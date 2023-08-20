package com.comm.certify;

import java.io.Serializable;

import com.infra.system.GlobalConst;

/**
 * NICE 암/복호화 정보 VO
 * @author JGS
 *
 */
public class NiceDecVO implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -329664844897296552L;
	
	private String siteCode 	= GlobalConst.NICE_SITE_CODE ;	// NICE로부터 부여받은 사이트 코드
	private String sitePassword	= GlobalConst.NICE_SITE_PASS;	// NICE로부터 부여받은 사이트 패스워드    
	private String ipinsiteCode 	= GlobalConst.NICE_IPIN_SITE_CODE ;	// NICE로부터 부여받은 사이트 코드
	private String ipinsitePassword	= GlobalConst.NICE_IPIN_SITE_PASS;	// NICE로부터 부여받은 사이트 패스워드    
     
	private String cipherTime;		// 복호화한 시간
	private String cipherIPAddress;
	private String requestNumber;	// 요청 번호
	private String responseNumber;	// 인증 고유번호
	private String authType;		// 인증 수단
	private String name;			// 성명
	private String dupInfo;			// 중복가입 확인값 (DI_64 byte)
	private String connInfo;		// 연계정보 확인값 (CI_88 byte)
	private String birthDate;		// 생일
	private String ageCode;		// 연력코드
	private String gender;			// 성별
	private String nationalInfo;   // 내/외국인정보 (개발가이드 참조)
	private String plainData;		// 복호화 데이터
	private String message;			// 에러 메시지    
	private int decErrCd;			// 복호화 에러 코드
	private String failErrCd;		// 실패 에러 코드
    
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

	public String getCipherTime() {
		return cipherTime;
	}
	public void setCipherTime(String cipherTime) {
		this.cipherTime = cipherTime;
	}
	public String getRequestNumber() {
		return requestNumber;
	}
	public void setRequestNumber(String requestNumber) {
		this.requestNumber = requestNumber;
	}
	public String getResponseNumber() {
		return responseNumber;
	}
	public void setResponseNumber(String responseNumber) {
		this.responseNumber = responseNumber;
	}
	public String getAuthType() {
		return authType;
	}
	public void setAuthType(String authType) {
		this.authType = authType;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDupInfo() {
		return dupInfo;
	}
	public void setDupInfo(String dupInfo) {
		this.dupInfo = dupInfo;
	}
	public String getConnInfo() {
		return connInfo;
	}
	public void setConnInfo(String connInfo) {
		this.connInfo = connInfo;
	}
	public String getBirthDate() {
		return birthDate;
	}
	public void setBirthDate(String birthDate) {
		this.birthDate = birthDate;
	}
	public String getAgeCode() {
		return ageCode;
	}
	public void setAgeCode(String ageCode) {
		this.ageCode = ageCode;
	}

	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getNationalInfo() {
		return nationalInfo;
	}
	public void setNationalInfo(String nationalInfo) {
		this.nationalInfo = nationalInfo;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getPlainData() {
		return plainData;
	}
	public void setPlainData(String plainData) {
		this.plainData = plainData;
	}
	public String getCipherIPAddress() {
		return cipherIPAddress;
	}
	public void setCipherIPAddress(String cipherIPAddress) {
		this.cipherIPAddress = cipherIPAddress;
	}
	public int getDecErrCd() {
		return decErrCd;
	}
	public void setDecErrCd(int decErrCd) {
		this.decErrCd = decErrCd;
	}
	public String getFailErrCd() {
		return failErrCd;
	}
	public void setFailErrCd(String failErrCd) {
		this.failErrCd = failErrCd;
	}	
}
