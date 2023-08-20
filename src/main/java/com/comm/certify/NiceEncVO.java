package com.comm.certify;

import java.io.Serializable;

import com.infra.system.GlobalConst;

/**
 * NICE 암/복호화 정보 VO
 * @author JGS
 *
 */
public class NiceEncVO  implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1784535861814084023L;
	/**
	 * 
	 */

	private String siteCode 	= GlobalConst.NICE_SITE_CODE ;	// NICE로부터 부여받은 사이트 코드
	private String sitePassword	= GlobalConst.NICE_SITE_PASS;	// NICE로부터 부여받은 사이트 패스워드    
	
	private String ipinsiteCode 	= GlobalConst.NICE_IPIN_SITE_CODE ;	// NICE로부터 부여받은 사이트 코드
	private String ipinsitePassword	= GlobalConst.NICE_IPIN_SITE_PASS;	// NICE로부터 부여받은 사이트 패스워드    

     
	private String authType 	= GlobalConst.NICE_AUTH_TYPE;	// 없으면 기본 선택화면, M: 핸드폰, C: 신용카드, X: 공인인증서   	
	private String popgubun 	= GlobalConst.NICE_POP_GUBUN;	// Y : 취소버튼 있음 / N : 취소버튼 없음
	private String customize 	= GlobalConst.NICE_CUSTOMIZE;	// 없으면 기본 웹페이지 / Mobile : 모바일페이지		
    
	private String returnUrl 	= GlobalConst.NICE_RETURN_URL;  // 성공시 이동될 URL
	private String ipinreturnUrl 	= GlobalConst.NICE_IPIN_RETURN_URL;  // 성공시 이동될 URL

	private String errorUrl 	= GlobalConst.NICE_ERROR_URL;   // 실패시 이동될 URL
    
	private String requestNumber;  	// 요청 번호
	private String plainData;		// 암호화할 데이터 
	private String message;			// 결과 메시지
	private String encData;			// 암호화 데이터
	private int encErrCd;			// 암호화 에러 코드
	private String ipinrequestNumber;  	// 요청 번호
	private String ipinmessage;			// 결과 메시지
	private String ipinencData;			// 암호화 데이터
	private int ipinencErrCd;			// 암호화 에러 코드
	private String clientIP;			// 요청 Client IP
	
	public String getSiteCode() {
		return siteCode;
	}
	public void setSiteCode(String siteCode) {
		this.siteCode = siteCode;
	}
	public String getSitePassword() {
		return sitePassword;
	}
	public void setSitePassword(String sitePassword) {
		this.sitePassword = sitePassword;
	}
	public String getIpinsiteCode() {
		return ipinsiteCode;
	}
	public void setIpinsiteCode(String ipinsiteCode) {
		this.ipinsiteCode = ipinsiteCode;
	}
	public String getIpinsitePassword() {
		return ipinsitePassword;
	}
	public void setIpinsitePassword(String ipinsitePassword) {
		this.ipinsitePassword = ipinsitePassword;
	}
	public String getAuthType() {
		return authType;
	}
	public void setAuthType(String authType) {
		this.authType = authType;
	}
	public String getPopgubun() {
		return popgubun;
	}
	public void setPopgubun(String popgubun) {
		this.popgubun = popgubun;
	}
	public String getCustomize() {
		return customize;
	}
	public void setCustomize(String customize) {
		this.customize = customize;
	}
	public String getReturnUrl() {
		return returnUrl;
	}
	public void setReturnUrl(String returnUrl) {
		this.returnUrl = returnUrl;
	}
	public String getIpinreturnUrl() {
		return ipinreturnUrl;
	}
	public void setIpinreturnUrl(String ipinreturnUrl) {
		this.ipinreturnUrl = ipinreturnUrl;
	}

	public String getErrorUrl() {
		return errorUrl;
	}
	public void setErrorUrl(String errorUrl) {
		this.errorUrl = errorUrl;
	}
	public String getRequestNumber() {
		return requestNumber;
	}
	public void setRequestNumber(String requestNumber) {
		this.requestNumber = requestNumber;
	}
	public String getIpinrequestNumber() {
		return ipinrequestNumber;
	}
	public void setIpinrequestNumber(String ipinrequestNumber) {
		this.ipinrequestNumber = ipinrequestNumber;
	}
	public String getPlainData() {
		return plainData;
	}
	public void setPlainData(String plainData) {
		this.plainData = plainData;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getEncData() {
		return encData;
	}
	public void setEncData(String encData) {
		this.encData = encData;
	}
	public int getEncErrCd() {
		return encErrCd;
	}
	public void setEncErrCd(int errCd) {
		this.encErrCd = errCd;
	}	
	public String getIpinmessage() {
		return ipinmessage;
	}
	public void setIpinmessage(String ipinmessage) {
		this.ipinmessage = ipinmessage;
	}
	public String getIpinencData() {
		return ipinencData;
	}
	public void setIpinencData(String ipinencData) {
		this.ipinencData = ipinencData;
	}
	public int getIpinencErrCd() {
		return ipinencErrCd;
	}
	public void setIpinencErrCd(int ipinencErrCd) {
		this.ipinencErrCd = ipinencErrCd;
	}	
	public String getClientIP() {
		return clientIP;
	}
	public void setClientIP(String clientIP) {
		this.clientIP = clientIP;
	}

}
