package com.infra.util;

/**
 * 캐릭터 관련 유틸 클래스 
 */
public class CharUtil {

    /**
     * 캐릭터 배열을 바이트 배열로 변환한다.
     * 
     * @param carr 변환할 캐릭터 배열
     * @return 변환된 바이트 배열
     */
    public static byte[] toByteArray(char[] carr) {
        if(carr == null) {
            return null;
        }
        byte[] barr = new byte[carr.length];
        for(int i = 0 ; i < carr.length ; i++) {
            barr[i] = (byte) carr[i];
        }
        return barr;
    }

    /**
     * 바이트 배열을 캐릭터 배열로 변환한다.
     * 
     * @param barr 변환할 바이트 배열
     * @return 변환된 캐릭터 배열
     */
    public static char[] toCharArray(byte[] barr) {
        if(barr == null) {
            return null;
        }
        char[] carr = new char[barr.length];
        for(int i = 0 ; i < barr.length ; i++) {
            carr[i] = (char) barr[i];
        }
        return carr;
    }

    /**
     * 지정한 캐릭터가 지정한 캐릭터배열에 속해있는지 여부를 확인한다.
     * 
     * @param c 확인할 대상 캐릭터
     * @param match 캐릭터 배열
     * @return 속해있다면 <code>true</code>, 아니면 <code>false</code>
     */
    public static boolean equals(char c, char[] match) {
        for(int i = 0 ; i < match.length ; i++) {
            if(c == match[i]) {
                return true;
            }
        }
        return false;
    }

    /**
     * 주어진 2개의 캐릭터 배열에 대해 지정 인덱스로부터 매치되는 값에 대한 첫번째 인덱스를 얻는다.
     * 
     * @param source 소스 캐릭터 배열
     * @param index 시작 인덱스
     * @param match 매칭 대상 캐릭터 배열
     * @return 매칭되는 캐릭터가 있다면 해당 인덱스 값, 아니면 -1
     */
    public static int findFirstAny(char[] source, int index, char[] match) {
        for(int i = index ; i < source.length ; i++) {
            if(equals(source[i], match) == true) {
                return i;
            }
        }
        return -1;
    }

    /**
     * 주어진 2개의 캐릭터 배열에 대해 지정 인덱스로부터 매치되지 않는 값에 대한 첫번째 인덱스를 얻는다.
     * 
     * @param source 소스 캐릭터 배열
     * @param index 시작 인덱스
     * @param match 매칭 대상 캐릭터 배열
     * @return 매칭되는 캐릭터가 없다면 해당 인덱스 값, 아니면 -1
     */
    public static int findFirstDiff(char[] source, int index, char[] match) {
        for(int i = index ; i < source.length ; i++) {
            if(equals(source[i], match) == false) {
                return i;
            }
        }
        return -1;
    }
}
