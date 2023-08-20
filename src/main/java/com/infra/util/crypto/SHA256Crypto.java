package com.infra.util.crypto;

import java.security.MessageDigest;

import org.springframework.security.crypto.bcrypt.BCrypt;

import com.sun.org.apache.xerces.internal.impl.dv.util.Base64;

/**
 * SHA256 복호화 불가능한 암호화 
 */
//@SuppressWarnings("restriction")
public class SHA256Crypto implements Crypto {

    @Override
    public String encrypt(String encStr) throws Exception {
        String result = "";
    
        byte[] bytes = encStr.getBytes("UTF-8");

        MessageDigest sha256 = MessageDigest.getInstance("SHA-256");
        byte[] hash = sha256.digest(bytes);
        result = new String(Base64.encode(hash));
        
        return result;
    }

    @Override
    public String decrypt(String decStr) {

        return null;
    }

    @Override
    public Crypto setKey(String cryptoKey) {

        return null;
    }

	@Override
	public byte[] encryptTobyte(String encStr) throws Exception {
        byte[] bytes = encStr.getBytes("UTF-8");

        MessageDigest sha256 = MessageDigest.getInstance("SHA-256");
        byte[] hash = sha256.digest(bytes);        
        
        return hash;
	}

	@Override
	public boolean isMatch(String encStr, String hashed) {
		return BCrypt.checkpw(encStr, hashed);
	}

	/*
	@Override
	public String encrypt(String encStr) {
		return BCrypt.hashpw(encStr, BCrypt.gensalt());
	}
	*/
}
