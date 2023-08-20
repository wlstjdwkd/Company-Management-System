package com.infra.util.crypto;

/**
 * ARIA 암복호화에 필요한 Padding 처리 클레스
 * <p />
 * 전자정부 프레임워크에 공개된 클레스를 차용하며 패키지 이외 수정사항 없음.
 * <p />
 * 전자정부 프레임워크 패키지 참조 : egovframework.rte.fdl.cryptography.impl.aria *
 * 
 */
public class AnsiX923Padding {

    /** 패딩 규칙 이름 */
    private String name = "ANSI-X.923-Padding";

    private final byte PADDING_VALUE = 0x00;

    /**
     * 요청한 Block Size를 맞추기 위해 Padding을 추가한다.
     * 
     * @param source byte[] 패딩을 추가할 bytes
     * @param blockSize int block size
     * @return byte[] 패딩이 추가 된 결과 bytes
     */
    public byte[] addPadding(byte[] source, int blockSize) {
        int paddingCnt = source.length % blockSize;
        byte[] paddingResult = null;

        if(paddingCnt != 0) {
            paddingResult = new byte[source.length + (blockSize - paddingCnt)];

            System.arraycopy(source, 0, paddingResult, 0, source.length);

            // 패딩해야 할 갯수 - 1 (마지막을 제외)까지 0x00 값을 추가한다.
            int addPaddingCnt = blockSize - paddingCnt;
            for(int i = 0 ; i < addPaddingCnt ; i++) {
                paddingResult[source.length + i] = PADDING_VALUE;
            }

            // 마지막 패딩 값은 패딩 된 Count를 추가한다.
            paddingResult[paddingResult.length - 1] = (byte) addPaddingCnt;
        } else {
            paddingResult = source;
        }

        return paddingResult;
    }

    /**
     * 요청한 Block Size를 맞추기 위해 추가 된 Padding을 제거한다.
     * 
     * @param source byte[] 패딩을 제거할 bytes
     * @param blockSize int block size
     * @return byte[] 패딩이 제거 된 결과 bytes
     */
    public byte[] removePadding(byte[] source, int blockSize) {
        byte[] paddingResult = null;
        boolean isPadding = false;

        // 패딩 된 count를 찾는다.
        int lastValue = source[source.length - 1];
        if(lastValue < (blockSize - 1)) {
            int zeroPaddingCount = lastValue - 1;

            for(int i = 2 ; i < (zeroPaddingCount + 2) ; i++) {
                if(source[source.length - i] != PADDING_VALUE) {
                    isPadding = false;
                    break;
                }
            }

            isPadding = true;
        } else {
            // 마지막 값이 block size 보다 클 경우 패딩 된것이 없음.
            isPadding = false;
        }

        if(isPadding && lastValue <= 1) { // minus, 0, 1
            isPadding = false;
        }

        if(isPadding) {
            for(int index = source.length - lastValue ; index < source.length - 1 ; index++) {
                if(source[index] != (byte) 0) {
                    isPadding = false;
                    break;
                }
            }
        }

        if(isPadding) {
            paddingResult = new byte[source.length - lastValue];
            try {
                System.arraycopy(source, 0, paddingResult, 0, paddingResult.length);
            } catch (ArrayIndexOutOfBoundsException ex) {
                return source;
            }
        } else {
            paddingResult = source;
        }

        return paddingResult;
    }

    public String getName() {
        return name;
    }

}
