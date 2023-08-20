package com.infra.util.crypto;

import com.infra.system.GlobalConst;

/**
 * 암호화 모듈을 반환한다.
 */
public class CryptoFactory {

    /**
     * 각각의 명칭에 해당하는 암복호화 지칭
     */ 
    public enum EncryptType {
        ARIA, SHA256
    }

    /**
     * 프레임 워크 기본 암호화 모듈 반환
     * 
     * @return
     * @see GlobalConst
     */
    public static Crypto getInstance() {

        return getInstance(GlobalConst.DEFAULT_CRYPTO);
    }

    /**
     * 별칭으로 암호화 모듈 반환
     * 
     * @param cryptoName
     * @return
     */
    public static Crypto getInstance(String cryptoName) {

        return getInstance(EncryptType.valueOf(cryptoName));
    }

    /**
     * 별칭으로 암호화 모듈 반환
     * 
     * @param cryptoName
     * @return
     */
    public static Crypto getInstance(EncryptType cryptoType) {
        if(EncryptType.ARIA.equals(cryptoType)) {
            return new ARIACrypto();
        } else if(EncryptType.SHA256.equals(cryptoType)) {
            return new SHA256Crypto();
        } else {
            new Throwable("지원하지 않는 암호화 방식입니다.");
        }
        return null;
    }

}
