package com.comm.user;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.infra.util.Validate;

/**
 * 사이트에 접속한 사용자 정보 클래스
 *
 * @author sujong
 *
 */
public class UserVO implements Serializable {

	private static final long serialVersionUID = -8416034030240937563L;

	private String userNo;								// 사용자번호
	private String loginId;								// 로그인ID
	private String emplyrTy;							// 사용자유형
	private String sttus;								// 상태
	private String loginAt;								// 로그인여부
	private String[] authorGroupCode;					// 사용자 권한그룹
	private String userNm;								// 사용자이름
	private String passwordValidDe;						// 비밀번호유효날짜
	private Date loginDe;								// 로그인 일시
	private Date logoutDe;								// 로그아웃 일시
	private String passwdInitlAt;						// 비밀번호 초기화 여부
	private String hashed;								// 해싱값
	private int confirmWaitCnt;							//접수승인관련 승인대기 수
	public List<Map> notificationList;					//알림 리스트
	private int loginFailCnt;							//로그인 실패 횟수
	private Date loginFailDt;							//로그인 실패시간

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
	public String getSttus() {
		return sttus;
	}
	public void setSttus(String sttus) {
		this.sttus = sttus;
	}
	public String getLoginAt() {
		return loginAt;
	}
	public void setLoginAt(String loginAt) {
		this.loginAt = loginAt;
	}
	public String[] getAuthorGroupCode() {
		String[] authorGroupCode = new String[this.authorGroupCode.length];
		authorGroupCode = this.authorGroupCode;
		return authorGroupCode;
	}
	public void setAuthorGroupCode(String[] authorGroupCode) {
		 this.authorGroupCode = new String[authorGroupCode.length];
	     for(int i = 0; i < authorGroupCode.length; ++i) {
	    	 this.authorGroupCode[i] = authorGroupCode[i];
	     }
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getPasswordValidDe() {
		return passwordValidDe;
	}
	public void setPasswordValidDe(String passwordValidDe) {
		this.passwordValidDe = passwordValidDe;
	}
	public String getLoginDe() {
		String result = "";
		if(loginDe != null) {
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			result = df.format(loginDe);
		}else result = "";
		return result;
	}
	public void setLoginDe(Date loginDe) {
		this.loginDe = loginDe;
	}
	public String getLogoutDe() {
		String result = "";
		if(logoutDe != null) {
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			result = df.format(logoutDe);
		}else result = "";
		return result;
	}
	public void setLogoutDe(Date logoutDe) {
		this.logoutDe = logoutDe;
	}
	public String getPasswdInitlAt() {
		return passwdInitlAt;
	}
	public void setPasswdInitlAt(String passwdInitlAt) {
		this.passwdInitlAt = passwdInitlAt;
	}
	public String getHashed() {
		return hashed;
	}
	public void setHashed(String hashed) {
		this.hashed = hashed;
	}
	public int getConfirmWaitCnt() {
		return confirmWaitCnt;
	}
	public void setConfirmWaitCnt(int confirmWaitCnt) {
		this.confirmWaitCnt = confirmWaitCnt;
	}
	public List<Map> getNotificationList() {
		return notificationList;
	}
	public void setNotificationList(List<Map> notificationList) {
		this.notificationList = notificationList;
	}
	public int getLoginFailCnt() {
		return loginFailCnt;
	}
	public void setLoginFailCnt(int loginFailCnt) {
		this.loginFailCnt = loginFailCnt;
	}
	public Date getLoginFailDt() {
		return loginFailDt;
	}
	public void setLoginFailDt(Date loginFailDt) {
		this.loginFailDt = loginFailDt;
	}
}
