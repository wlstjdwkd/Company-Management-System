package com.comm.user;

import java.io.Serializable;

/**
 * @author dongwoo
 *
 */
public class AllUserVO implements Serializable {

	private static final long serialVersionUID = 1L;

	private String userNo;					// 사용자번호
	private String loginId;					// 로그인ID
	private String emplyrTy;				// 사용자유형
	private String userNm;					// 이름
	private String telno;                	// 전화번호
	private String telno2;                	// 담당자 일반전화번호
	private String mbtlnum;					// 휴대폰번호
	private String fxnum;                	// 팩스번호
	private String email;					// 이메일
	private String ipinSelfCrtfcNo; 		// ipin 본인인증번호
	private String moblphonSelfCrtfcNo; 	// 휴대폰본인인증번호
	private String emailRecptnAgre;			// 이메일수신동의
	private String smsRecptnAgre;			// 문자메시지수신동의
	private String register;				// 등록자
	private String updusr; 					// 수정자
	private String rgsde;					// 등록일
	private String updde;					// 수정일

	private String jurirno;              	// 법인등록번호(PK)
	private String chargerNm;            	// 담당자명
	private String chargerDept;          	// 담당자부서
	private String deptCd;					// 담당부서코드
	private String ofcpsCd;					// 직위코드
	private String ofcps;                	// 직위
	private String bizrno;               	// 사업자등록번호
	private String entrprsNm;            	// 기업명
	private String rprsntvNm;            	// 대표자명
	private String adres;                	// 주소
	private String zip;                  	// 우편번호
	private String hedofcAdres;          	// 본사주소
	private String hedofcZip;            	// 본사우편번호
	private String hpeCd;                	// 기업관리코드

	private String deptNm;					// 부서명(기관)
	private String sttus;					// 기업상태


	public String getUserNo() {
		return userNo;
	}
	public void setUserNo(String userNo) {
		this.userNo = userNo;
	}
	public String getLoginId() {
		return loginId;
	}
	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}
	public String getEmplyrTy() {
		return emplyrTy;
	}
	public void setEmplyrTy(String emplyrTy) {
		this.emplyrTy = emplyrTy;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
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
	public String getRegister() {
		return register;
	}
	public void setRegister(String register) {
		this.register = register;
	}
	public String getUpdusr() {
		return updusr;
	}
	public void setUpdusr(String updusr) {
		this.updusr = updusr;
	}
	public String getRgsde() {
		return rgsde;
	}
	public void setRgsde(String rgsde) {
		this.rgsde = rgsde;
	}
	public String getUpdde() {
		return updde;
	}
	public void setUpdde(String updde) {
		this.updde = updde;
	}
	public String getJurirno() {
		return jurirno;
	}
	public void setJurirno(String jurirno) {
		this.jurirno = jurirno;
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
	public String getDeptNm() {
		return deptNm;
	}
	public void setDeptNm(String deptNm) {
		this.deptNm = deptNm;
	}
	public void setSttus(String sttus) {
		this.sttus = sttus;
	}
	public String getSttus() {
		return sttus;
	}
	public String getDeptCd() {
		return deptCd;
	}
	public void setDeptCd(String deptCd) {
		this.deptCd = deptCd;
	}
	public String getOfcpsCd() {
		return ofcpsCd;
	}
	public void setOfcpsCd(String ofcpsCd) {
		this.ofcpsCd = ofcpsCd;
	}

}

