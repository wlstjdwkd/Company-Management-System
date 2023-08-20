package com.comm.user;

import java.io.Serializable;

/**
 * 사이트에 접속한 기업사용자 정보 클래스
 * 
 * @author JGS
 *
 */
public class EntUserVO implements Serializable {	
	
	private static final long serialVersionUID = 9011106168005061616L;
	
	private String userNo;               // 사용자번호(PK)(FK)
	private String jurirno;              // 법인등록번호(PK)  
	private String ipinSelfCrtfcNo;      // IPIN_본인인증번호 
	private String moblphonSelfCrtfcNo;  // 휴대폰본인인증번호
	private String chargerNm;            // 담당자명          
	private String chargerDept;          // 담당자부서        
	private String ofcps;                // 직위              
	private String telno;                // 전화번호
	private String telno2;                // 담당자 일반전화번호
	private String mbtlnum;              // 휴대폰번호        
	private String fxnum;                // 팩스번호          
	private String email;                // 이메일            
	private String bizrno;               // 사업자등록번호    
	private String entrprsNm;            // 기업명            
	private String rprsntvNm;            // 대표자명          
	private String adres;                // 주소              
	private String zip;                  // 우편번호          
	private String hedofcAdres;          // 본사주소          
	private String hedofcZip;            // 본사우편번호      
	private String hpeCd;                // 기업관리코드      
	private String emailRecptnAgre;      // 이메일수신동의    
	private String smsRecptnAgre;        // 문자메시지수신동의
	private String tempRceptNo;			  // 임시저장기업확인신청번호	
	private String bizrnoCertChk;		  // 사업자번호 인증확인
	private String bizrnoDN;			  // 사업자번호 인증 DN값
	private String updde;				  // 수정일
	
	public String getUserNo() {
		return userNo;
	}
	public void setUserNo(String userNo) {
		this.userNo = userNo;
	}
	public String getJurirno() {
		return jurirno;
	}
	public void setJurirno(String jurirno) {
		this.jurirno = jurirno;
	}
	public String getIpinSelfCrtfcNo() {
		return ipinSelfCrtfcNo;
	}
	public void setIpinSelfCrtfcNo(String ipinSelfCrtfcNo) {
		this.ipinSelfCrtfcNo = ipinSelfCrtfcNo;
	}
	public String getMoblphonSelfCrtfcNo() {
		return moblphonSelfCrtfcNo;
	}
	public void setMoblphonSelfCrtfcNo(String moblphonSelfCrtfcNo) {
		this.moblphonSelfCrtfcNo = moblphonSelfCrtfcNo;
	}
	public String getChargerNm() {
		return chargerNm;
	}
	public void setChargerNm(String chargerNm) {
		this.chargerNm = chargerNm;
	}
	public String getChargerDept() {
		return chargerDept;
	}
	public void setChargerDept(String chargerDept) {
		this.chargerDept = chargerDept;
	}
	public String getOfcps() {
		return ofcps;
	}
	public void setOfcps(String ofcps) {
		this.ofcps = ofcps;
	}
	public String getTelno() {
		return telno;
	}
	public String getTelno2() {
		return telno2;
	}
	public void setTelno(String telno) {
		this.telno = telno;
	}
	public void setTelno2(String telno2) {
		this.telno2 = telno2;
	}
	public String getMbtlnum() {
		return mbtlnum;
	}
	public void setMbtlnum(String mbtlnum) {
		this.mbtlnum = mbtlnum;
	}
	public String getFxnum() {
		return fxnum;
	}
	public void setFxnum(String fxnum) {
		this.fxnum = fxnum;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getBizrno() {
		return bizrno;
	}
	public void setBizrno(String bizrno) {
		this.bizrno = bizrno;
	}
	public String getEntrprsNm() {
		return entrprsNm;
	}
	public void setEntrprsNm(String entrprsNm) {
		this.entrprsNm = entrprsNm;
	}
	public String getRprsntvNm() {
		return rprsntvNm;
	}
	public void setRprsntvNm(String rprsntvNm) {
		this.rprsntvNm = rprsntvNm;
	}
	public String getAdres() {
		return adres;
	}
	public void setAdres(String adres) {
		this.adres = adres;
	}
	public String getZip() {
		return zip;
	}
	public void setZip(String zip) {
		this.zip = zip;
	}
	public String getHedofcAdres() {
		return hedofcAdres;
	}
	public void setHedofcAdres(String hedofcAdres) {
		this.hedofcAdres = hedofcAdres;
	}
	public String getHedofcZip() {
		return hedofcZip;
	}
	public void setHedofcZip(String hedofcZip) {
		this.hedofcZip = hedofcZip;
	}
	public String getHpeCd() {
		return hpeCd;
	}
	public void setHpeCd(String hpeCd) {
		this.hpeCd = hpeCd;
	}
	public String getEmailRecptnAgre() {
		return emailRecptnAgre;
	}
	public void setEmailRecptnAgre(String emailRecptnAgre) {
		this.emailRecptnAgre = emailRecptnAgre;
	}
	public String getSmsRecptnAgre() {
		return smsRecptnAgre;
	}
	public void setSmsRecptnAgre(String smsRecptnAgre) {
		this.smsRecptnAgre = smsRecptnAgre;
	}
	public String getTempRceptNo() {
		return tempRceptNo;
	}
	public void setTempRceptNo(String tempRceptNo) {
		this.tempRceptNo = tempRceptNo;
	}
	public String getBizrnoCertChk() {
		return bizrnoCertChk;
	}
	public void setBizrnoCertChk(String bizrnoCertChk) {
		this.bizrnoCertChk = bizrnoCertChk;
	}
	public String getBizrnoDN() {
		return bizrnoDN;
	}
	public void setBizrnoDN(String bizrnoDN) {
		this.bizrnoDN = bizrnoDN;
	}
	public String getUpdde() {
		return updde;
	}
	public void setUpdde(String updde) {
		this.updde = updde;
	}
}
