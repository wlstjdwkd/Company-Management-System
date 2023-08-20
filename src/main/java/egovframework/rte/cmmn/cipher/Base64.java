package egovframework.rte.cmmn.cipher;

public final class Base64 {

	public static String toString(byte[] data)
	{
		if( data == null )
			return null;
		
		char binaryChar[] = convertCharToByte(data);
		if( binaryChar == null )
			return null;
		
		return (new String(binaryChar));
	}
	
	public static byte[] toByte(String data)
	{
		if(data == null)
            return null;
        char ac[] = data.toCharArray();
        int i = removeWhiteSpace(ac);
        if(i % 4 != 0)
            return null;
        int j = i / 4;
        if(j == 0)
            return new byte[0];
        byte abyte0[] = null;
        byte byte0 = 0;
        byte byte1 = 0;
        char c = '\0';
        char c1 = '\0';
        char c2 = '\0';
        char c3 = '\0';
        int k = 0;
        int l = 0;
        int i1 = 0;
        abyte0 = new byte[j * 3];
        for(; k < j - 1; k++)
        {
            if(!isData(c = ac[i1++]) || !isData(c1 = ac[i1++]) || !isData(c2 = ac[i1++]) || !isData(c3 = ac[i1++]))
                return null;
            byte0 = BASE64_ALPHABET_BYTE[c];
            byte1 = BASE64_ALPHABET_BYTE[c1];
            byte byte2 = BASE64_ALPHABET_BYTE[c2];
            byte byte5 = BASE64_ALPHABET_BYTE[c3];
            abyte0[l++] = (byte)(byte0 << 2 | byte1 >> 4);
            abyte0[l++] = (byte)((byte1 & 0xf) << 4 | byte2 >> 2 & 0xf);
            abyte0[l++] = (byte)(byte2 << 6 | byte5);
        }

        if(!isData(c = ac[i1++]) || !isData(c1 = ac[i1++]))
            return null;
        byte0 = BASE64_ALPHABET_BYTE[c];
        byte1 = BASE64_ALPHABET_BYTE[c1];
        c2 = ac[i1++];
        c3 = ac[i1++];
        if(!isData(c2) || !isData(c3))
        {
            if(isPad(c2) && isPad(c3))
                if((byte1 & 0xf) != 0)
                {
                    return null;
                } else
                {
                    byte abyte1[] = new byte[k * 3 + 1];
                    System.arraycopy(abyte0, 0, abyte1, 0, k * 3);
                    abyte1[l] = (byte)(byte0 << 2 | byte1 >> 4);
                    return abyte1;
                }
            if(!isPad(c2) && isPad(c3))
            {
                byte byte3 = BASE64_ALPHABET_BYTE[c2];
                if((byte3 & 3) != 0)
                {
                    return null;
                } else
                {
                    byte abyte2[] = new byte[k * 3 + 2];
                    System.arraycopy(abyte0, 0, abyte2, 0, k * 3);
                    abyte2[l++] = (byte)(byte0 << 2 | byte1 >> 4);
                    abyte2[l] = (byte)((byte1 & 0xf) << 4 | byte3 >> 2 & 0xf);
                    return abyte2;
                }
            } else
            {
                return null;
            }
        } else
        {
            byte byte4 = BASE64_ALPHABET_BYTE[c2];
            byte byte6 = BASE64_ALPHABET_BYTE[c3];
            abyte0[l++] = (byte)(byte0 << 2 | byte1 >> 4);
            abyte0[l++] = (byte)((byte1 & 0xf) << 4 | byte4 >> 2 & 0xf);
            abyte0[l++] = (byte)(byte4 << 6 | byte6);
            return abyte0;
        }
	}
	
	private static boolean isData(char c)
    {
        return BASE64_ALPHABET_BYTE[c] != -1;
    }
    
    private static boolean isPad(char c)
    {
        return c == '=';
    }
    
	private static int removeWhiteSpace(char ac[])
    {
        if(ac == null)
            return 0;
        int i = 0;
        int j = ac.length;
        for(int k = 0; k < j; k++)
            if(!isWhiteSpace(ac[k]))
                ac[i++] = ac[k];

        return i;
    }
	
	private static boolean isWhiteSpace(char c)
    {
        return c == ' ' || c == '\r' || c == '\n' || c == '\t';
    }
	
	private static char[] convertCharToByte(byte binary[])
    {
        if( binary == null )
            return null;
        
        int binaryBitLength = binary.length * 8;
        if( binaryBitLength == 0 )
        	return new char[0];
        
        int j = binaryBitLength % 24;
        int k = binaryBitLength / 24;
        int l = j == 0 ? k : k + 1;
        int i1 = (l - 1) / 19 + 1;
        char ac[] = new char[l * 4];

        int j1 = 0;
        int k1 = 0;
        int l1 = 0;
        for(int i2 = 0; i2 < i1 - 1; i2++)
        {
            for(int j2 = 0; j2 < 19; j2++)
            {
                byte byte7 = binary[k1++];
                byte byte11 = binary[k1++];
                byte byte14 = binary[k1++];
                byte byte4 = (byte)(byte11 & 0xf);
                byte byte0 = (byte)(byte7 & 3);
                byte byte16 = (byte7 & 0xffffff80) != 0 ? (byte)(byte7 >> 2 ^ 0xc0) : (byte)(byte7 >> 2);
                byte byte20 = (byte11 & 0xffffff80) != 0 ? (byte)(byte11 >> 4 ^ 0xf0) : (byte)(byte11 >> 4);
                byte byte23 = (byte14 & 0xffffff80) != 0 ? (byte)(byte14 >> 6 ^ 0xfc) : (byte)(byte14 >> 6);
                ac[j1++] = BASE64_ALPHABET_CHAR[byte16];
                ac[j1++] = BASE64_ALPHABET_CHAR[byte20 | byte0 << 4];
                ac[j1++] = BASE64_ALPHABET_CHAR[byte4 << 2 | byte23];
                ac[j1++] = BASE64_ALPHABET_CHAR[byte14 & 0x3f];
                l1++;
            }

        }

        for(; l1 < k; l1++)
        {
            byte byte8 = binary[k1++];
            byte byte12 = binary[k1++];
            byte byte15 = binary[k1++];
            byte byte5 = (byte)(byte12 & 0xf);
            byte byte1 = (byte)(byte8 & 3);
            byte byte17 = (byte8 & 0xffffff80) != 0 ? (byte)(byte8 >> 2 ^ 0xc0) : (byte)(byte8 >> 2);
            byte byte21 = (byte12 & 0xffffff80) != 0 ? (byte)(byte12 >> 4 ^ 0xf0) : (byte)(byte12 >> 4);
            byte byte24 = (byte15 & 0xffffff80) != 0 ? (byte)(byte15 >> 6 ^ 0xfc) : (byte)(byte15 >> 6);
            ac[j1++] = BASE64_ALPHABET_CHAR[byte17];
            ac[j1++] = BASE64_ALPHABET_CHAR[byte21 | byte1 << 4];
            ac[j1++] = BASE64_ALPHABET_CHAR[byte5 << 2 | byte24];
            ac[j1++] = BASE64_ALPHABET_CHAR[byte15 & 0x3f];
        }

        if(j == 8)
        {
            byte byte9 = binary[k1];
            byte byte2 = (byte)(byte9 & 3);
            byte byte18 = (byte9 & 0xffffff80) != 0 ? (byte)(byte9 >> 2 ^ 0xc0) : (byte)(byte9 >> 2);
            ac[j1++] = BASE64_ALPHABET_CHAR[byte18];
            ac[j1++] = BASE64_ALPHABET_CHAR[byte2 << 4];
            ac[j1++] = '=';
            ac[j1++] = '=';
        } else
        if(j == 16)
        {
            byte byte10 = binary[k1];
            byte byte13 = binary[k1 + 1];
            byte byte6 = (byte)(byte13 & 0xf);
            byte byte3 = (byte)(byte10 & 3);
            byte byte19 = (byte10 & 0xffffff80) != 0 ? (byte)(byte10 >> 2 ^ 0xc0) : (byte)(byte10 >> 2);
            byte byte22 = (byte13 & 0xffffff80) != 0 ? (byte)(byte13 >> 4 ^ 0xf0) : (byte)(byte13 >> 4);
            ac[j1++] = BASE64_ALPHABET_CHAR[byte19];
            ac[j1++] = BASE64_ALPHABET_CHAR[byte22 | byte3 << 4];
            ac[j1++] = BASE64_ALPHABET_CHAR[byte6 << 2];
            ac[j1++] = '=';
        }
        
        return ac;
    }
	
	private static final byte BASE64_ALPHABET_BYTE[] = new byte[255];
	private static final char BASE64_ALPHABET_CHAR[] = new char[64];
	
	static 
    {
		for( int i =  0; i <= 25; i++ ) BASE64_ALPHABET_CHAR[i] = (char)(65 + i);
        for( int i = 26; i <= 51; i++ ) BASE64_ALPHABET_CHAR[i] = (char)(97 + (i-26));
        for( int i = 52; i <= 61; i++ ) BASE64_ALPHABET_CHAR[i] = (char)(48 + (i-52));
        BASE64_ALPHABET_CHAR[62] = '+';
        BASE64_ALPHABET_CHAR[63] = '/';
        
        for( int i =   0; i <  255; i++ ) BASE64_ALPHABET_BYTE[i] = -1;
        for( int i =  90; i >=  65; i-- ) BASE64_ALPHABET_BYTE[i] = (byte)(i - 65);
        for( int i = 122; i >=  97; i-- ) BASE64_ALPHABET_BYTE[i] = (byte)((i - 97) + 26);
        for( int i =  57; i >=  48; i-- ) BASE64_ALPHABET_BYTE[i] = (byte)((i - 48) + 52);
        BASE64_ALPHABET_BYTE[43] = 62;
        BASE64_ALPHABET_BYTE[47] = 63;
    }
}
