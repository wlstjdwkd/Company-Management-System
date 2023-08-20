package com.infra.util.crypto;

import java.io.UnsupportedEncodingException;

/**
 * 암 복호화 표준 타입 인터페이스
 */
public interface Crypto {

    /**
     * 문자열 암호화
     *
     * @param encStr
     * @return
     * @throws Exception
     */
    String encrypt(String encStr) throws Exception;
    
    /**
     * 문자열 암호화
     *
     * @param encStr
     * @return
     * @throws Exception
     */
    byte[] encryptTobyte(String encStr) throws Exception;

    /**
     * 문자열 복호화
     *
     * @param decStr
     * @return
     * @throws Exception
     */
    String decrypt(String decStr);

    /**
     * 키 문자열 또는 키파일 경로를 설정한다.
     *
     * @param cryptoKey
     * @return
     */
    Crypto setKey(String cryptoKey);

	/**
     * 문자열 암호화
     *
     * @param encStr
     * @return
     * @throws Exception
     */
    //String encrypt(String encStr);

    /**
     * 암호화 확인
     *
     * @param encStr
     * @return
     * @throws Exception
     */
    boolean isMatch(String encStr, String hashed);
}
