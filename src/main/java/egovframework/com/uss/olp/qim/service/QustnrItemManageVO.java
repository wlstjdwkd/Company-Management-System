package egovframework.com.uss.olp.qim.service;

import java.io.Serializable;
/**
 * 설문항목관리 VO Class 구현
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
public class QustnrItemManageVO implements Serializable {
	
	/** 설문문항 아이디 */
	private String qestnrQesitmId = "";
	
	/** 설문지 아이디 */
	private String qestnrId = "";
	
	/** 항목순번 */
	private String iemSn = "";
	
	/** 항목내용 */
	private String qustnrIemId = "";
	
	/** 설문항목아이디 */
	private String iemCn = "";
	
	/** 키타답변여부 */
	private String etcAnswerAt = "";
	
	/** 설문항목(을)를 아이디 */
	private String qestnrTmplatId = "";
	
	/** 최초등록시점  */
	private String rgsde = "";
	
	/** 최초등록아이디 */
	private String register = "";
	
	/** 최종수정일 */
	private String updde = "";
	
	/** 최종수정자 아이디 */
	private String updusr = "";
	
	/** 컨트롤 명령어 */
	private String cmd = "";

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
	 * iemSn attribute 를 리턴한다.
	 * @return the String
	 */
	public String getIemSn() {
		return iemSn;
	}

	/**
	 * iemSn attribute 값을 설정한다.
	 * @return iemSn String
	 */
	public void setIemSn(String iemSn) {
		this.iemSn = iemSn;
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
	 * iemCn attribute 를 리턴한다.
	 * @return the String
	 */
	public String getIemCn() {
		return iemCn;
	}

	/**
	 * iemCn attribute 값을 설정한다.
	 * @return iemCn String
	 */
	public void setIemCn(String iemCn) {
		this.iemCn = iemCn;
	}

	/**
	 * etcAnswerAt attribute 를 리턴한다.
	 * @return the String
	 */
	public String getEtcAnswerAt() {
		return etcAnswerAt;
	}

	/**
	 * etcAnswerAt attribute 값을 설정한다.
	 * @return etcAnswerAt String
	 */
	public void setEtcAnswerAt(String etcAnswerAt) {
		this.etcAnswerAt = etcAnswerAt;
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

	/**
	 * cmd attribute 를 리턴한다.
	 * @return the String
	 */
	public String getCmd() {
		return cmd;
	}

	/**
	 * cmd attribute 값을 설정한다.
	 * @return cmd String
	 */
	public void setCmd(String cmd) {
		this.cmd = cmd;
	}
	
	
}
