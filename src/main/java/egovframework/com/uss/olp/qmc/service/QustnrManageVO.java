package egovframework.com.uss.olp.qmc.service;

import java.io.Serializable;
/**
 * 설문관리 VO Class 구현
 * @author 공통서비스 장동한
 * @since 2009.03.20
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.03.20  장동한          최초 생성
 *
 * </pre>
 */
@SuppressWarnings("serial")
public class QustnrManageVO implements Serializable {
	
	/** 설문지ID */
	private String qestnrId =  "";
	
	/**  설문제목 */
	private String qestnrSj =  "";
	
	/**  설문목적 */
	private String qestnrPurps =  "";
	
	/**  설문작성안내내용 */
	private String qestnrWritngGuidanceCn =  "";
	
	/**  설문시작일자 */
	private String qestnrBeginDe =  "";
	
	/**  설문종료일자 */
	private String qestnrEndDe =  "";
	
	/**  설문대상 */
	private String qestnrTrget =  "";
	
	/**  설문시작일자 */
	private String qestnrTmplatId =  "";

	/**  설문템플릿유형 */
	private String qestnrTmplatTy =  "";
	
	/**  최초등록시점 */
	private String rgsde =  "";
	
	/**  최초등록자아이디 */
	private String register =  "";
	
	/**  최종수정시점 */
	private String updde =  "";
	
	/**  최종수정자아이디 */
	private String updusr =  "";

	/**
	 * qestnrId attribute 를 리턴한다.
	 * @return the String
	 */
	public String getQestnrId() {
		return qestnrId;
	}

	/**
	 * qestnrId attribute 값을 설정한다.
	 * @return qestnrId String
	 */
	public void setQestnrId(String qestnrId) {
		this.qestnrId = qestnrId;
	}

	/**
	 * qestnrSj attribute 를 리턴한다.
	 * @return the String
	 */
	public String getQestnrSj() {
		return qestnrSj;
	}

	/**
	 * qestnrSj attribute 값을 설정한다.
	 * @return qestnrSj String
	 */
	public void setQestnrSj(String qestnrSj) {
		this.qestnrSj = qestnrSj;
	}

	/**
	 * qestnrPurps attribute 를 리턴한다.
	 * @return the String
	 */
	public String getQestnrPurps() {
		return qestnrPurps;
	}

	/**
	 * qestnrPurps attribute 값을 설정한다.
	 * @return qestnrPurps String
	 */
	public void setQestnrPurps(String qestnrPurps) {
		this.qestnrPurps = qestnrPurps;
	}

	/**
	 * qestnrWritngGuidanceCn attribute 를 리턴한다.
	 * @return the String
	 */
	public String getQestnrWritngGuidanceCn() {
		return qestnrWritngGuidanceCn;
	}

	/**
	 * qestnrWritngGuidanceCn attribute 값을 설정한다.
	 * @return qestnrWritngGuidanceCn String
	 */
	public void setQestnrWritngGuidanceCn(String qestnrWritngGuidanceCn) {
		this.qestnrWritngGuidanceCn = qestnrWritngGuidanceCn;
	}

	/**
	 * qestnrBeginDe attribute 를 리턴한다.
	 * @return the String
	 */
	public String getQestnrBeginDe() {
		return qestnrBeginDe;
	}

	/**
	 * qestnrBeginDe attribute 값을 설정한다.
	 * @return qestnrBeginDe String
	 */
	public void setQestnrBeginDe(String qestnrBeginDe) {
		this.qestnrBeginDe = qestnrBeginDe;
	}

	/**
	 * qestnrEndDe attribute 를 리턴한다.
	 * @return the String
	 */
	public String getQestnrEndDe() {
		return qestnrEndDe;
	}

	/**
	 * qestnrEndDe attribute 값을 설정한다.
	 * @return qestnrEndDe String
	 */
	public void setQestnrEndDe(String qestnrEndDe) {
		this.qestnrEndDe = qestnrEndDe;
	}

	/**
	 * qestnrTrget attribute 를 리턴한다.
	 * @return the String
	 */
	public String getQestnrTrget() {
		return qestnrTrget;
	}

	/**
	 * qestnrTrget attribute 값을 설정한다.
	 * @return qestnrTrget String
	 */
	public void setQestnrTrget(String qestnrTrget) {
		this.qestnrTrget = qestnrTrget;
	}

	/**
	 * qestnrTmplatId attribute 를 리턴한다.
	 * @return the String
	 */
	public String getQestnrTmplatId() {
		return qestnrTmplatId;
	}

	/**
	 * qestnrTmplatId attribute 값을 설정한다.
	 * @return qestnrTmplatId String
	 */
	public void setQestnrTmplatId(String qestnrTmplatId) {
		this.qestnrTmplatId = qestnrTmplatId;
	}

	/**
	 * qestnrTmplatTy attribute 를 리턴한다.
	 * @return the String
	 */
	public String getQestnrTmplatTy() {
		return qestnrTmplatTy;
	}

	/**
	 * qestnrTmplatTy attribute 값을 설정한다.
	 * @return qestnrTmplatTy String
	 */
	public void setQestnrTmplatTy(String qestnrTmplatTy) {
		this.qestnrTmplatTy = qestnrTmplatTy;
	}

	/**
	 * frstRegisterPnttm attribute 를 리턴한다.
	 * @return the String
	 */
	public String getRgsde() {
		return rgsde;
	}

	/**
	 * frstRegisterPnttm attribute 값을 설정한다.
	 * @return frstRegisterPnttm String
	 */
	public void setRgsde(String rgsde) {
		this.rgsde = rgsde;
	}

	/**
	 * frstRegisterId attribute 를 리턴한다.
	 * @return the String
	 */
	public String getRegister() {
		return register;
	}

	/**
	 * frstRegisterId attribute 값을 설정한다.
	 * @return frstRegisterId String
	 */
	public void setRegister(String register) {
		this.register = register;
	}

	/**
	 * lastUpdusrPnttm attribute 를 리턴한다.
	 * @return the String
	 */
	public String getUpdde() {
		return updde;
	}

	/**
	 * lastUpdusrPnttm attribute 값을 설정한다.
	 * @return lastUpdusrPnttm String
	 */
	public void setUpdde(String updde) {
		this.updde = updde;
	}

	/**
	 * lastUpdusrId attribute 를 리턴한다.
	 * @return the String
	 */
	public String getUpdusr() {
		return updusr;
	}

	/**
	 * lastUpdusrId attribute 값을 설정한다.
	 * @return lastUpdusrId String
	 */
	public void setUpdusr(String updusr) {
		this.updusr = updusr;
	}
}
