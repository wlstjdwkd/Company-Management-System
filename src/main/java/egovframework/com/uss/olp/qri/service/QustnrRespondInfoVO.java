package egovframework.com.uss.olp.qri.service;

import java.io.Serializable;
/**
 * 설문조사 VO Class 구현 
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
public class QustnrRespondInfoVO implements Serializable {
	
	/** 설문응답ID */
	private String qestnrQesrspnsId = ""; 
	
	/** 설문문항ID */
	private String qestnrQesitmId = "";
	
	/** 설문ID */
	private String qestnrId = "";
	
	/** 설문템플릿ID */
	private String qestnrTmplatId = "";
	
	/** 설문항목ID */
	private String qustnrIemId = "";
	
	/** 응답자답변내용 */
	private String respondAnswerCn = "";
	
	/** 응답자명 */
	private String respondNm = "";
	
	/** 기타답변내용 */
	private String etcAnswerCn = "";
	
	/** 최초등록시점 */
	private String rgsde = "";
	
	/** 최등등록시점ID */
	private String register = "";
	
	/** 최종수정시점 */
	private String updde = "";
	
	/** 최종수정시점ID */
	private String updusr = "";
	
	/** 응답자 이메일 */
	private String trgterEmail = "";

	/**
	 * qestnrQesrspnsId attribute 를 리턴한다.
	 * @return the String
	 */
	public String getQestnrQesrspnsId() {
		return qestnrQesrspnsId;
	}

	/**
	 * qestnrQesrspnsId attribute 값을 설정한다.
	 * @return qestnrQesrspnsId String
	 */
	public void setQestnrQesrspnsId(String qestnrQesrspnsId) {
		this.qestnrQesrspnsId = qestnrQesrspnsId;
	}

	/**
	 * qestnrQesitmId attribute 를 리턴한다.
	 * @return the String
	 */
	public String getQestnrQesitmId() {
		return qestnrQesitmId;
	}

	/**
	 * qestnrQesitmId attribute 값을 설정한다.
	 * @return qestnrQesitmId String
	 */
	public void setQestnrQesitmId(String qestnrQesitmId) {
		this.qestnrQesitmId = qestnrQesitmId;
	}

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
	 * qustnrIemId attribute 를 리턴한다.
	 * @return the String
	 */
	public String getQustnrIemId() {
		return qustnrIemId;
	}

	/**
	 * qustnrIemId attribute 값을 설정한다.
	 * @return qustnrIemId String
	 */
	public void setQustnrIemId(String qustnrIemId) {
		this.qustnrIemId = qustnrIemId;
	}

	/**
	 * respondAnswerCn attribute 를 리턴한다.
	 * @return the String
	 */
	public String getRespondAnswerCn() {
		return respondAnswerCn;
	}

	/**
	 * respondAnswerCn attribute 값을 설정한다.
	 * @return respondAnswerCn String
	 */
	public void setRespondAnswerCn(String respondAnswerCn) {
		this.respondAnswerCn = respondAnswerCn;
	}

	/**
	 * respondNm attribute 를 리턴한다.
	 * @return the String
	 */
	public String getRespondNm() {
		return respondNm;
	}

	/**
	 * respondNm attribute 값을 설정한다.
	 * @return respondNm String
	 */
	public void setRespondNm(String respondNm) {
		this.respondNm = respondNm;
	}

	/**
	 * etcAnswerCn attribute 를 리턴한다.
	 * @return the String
	 */
	public String getEtcAnswerCn() {
		return etcAnswerCn;
	}

	/**
	 * etcAnswerCn attribute 값을 설정한다.
	 * @return etcAnswerCn String
	 */
	public void setEtcAnswerCn(String etcAnswerCn) {
		this.etcAnswerCn = etcAnswerCn;
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
	public void setRgsde(String frstRegisterPnttm) {
		this.rgsde = frstRegisterPnttm;
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

	/**
	 * trgterEmail attribute 를 리턴한다.
	 * @return
	 */
	public String getTrgterEmail() {
		return trgterEmail;
	}

	/**
	 * trgterEmail attribute 값을 설정한다.
	 * @return
	 */
	public void setTrgterEmail(String trgterEmail) {
		this.trgterEmail = trgterEmail;
	}
}
