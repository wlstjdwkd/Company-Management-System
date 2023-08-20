package egovframework.com.uss.olp.qtm.service;

import java.io.Serializable;
/**
 * 설문템플릿 VO Class 구현
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
public class QustnrTmplatManageVO implements Serializable {

	/** 설문템플릿 아이디 */
	private String qestnrTmplatId = "";

	/** 설문템플릿 유형 */
	private String qestnrTmplatTy = "";

	/** 설문템플 이미지내용 */
	private byte[] qestnrTmplatImagepathnm;

	/** 설문템플릿  설명 */
	private String qestnrTmplatCn = "";

	/** 설문템플릿경로명 */
	private String qestnrTmplatCours;

	/** 최초등록시점 */
	private String rgsde = "";

	/** 최초등록자아이디 */
	private String register = "";

	/** 최종수정자 시점 */
	private String updde = "";

	/** 최종수정자아이디 */
	private String updusr = "";

	/** 화면 명령 처리 */
	private String cmd = "";

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
	 * qestnrTmplatImagepathnm attribute 를 리턴한다.
	 * @return the byte[]
	 */
	public byte[] getQestnrTmplatImagepathnm() {
		byte[] ret = null;
		
		if (qestnrTmplatImagepathnm != null) {
			ret = new byte[qestnrTmplatImagepathnm.length];
			
			for (int i = 0; i < qestnrTmplatImagepathnm.length; i++) {
				ret[i] = qestnrTmplatImagepathnm[i];
			}
		}
		return ret;
	}

	/**
	 * qestnrTmplatImagepathnm attribute 값을 설정한다.
	 * @return qestnrTmplatImagepathnm byte[]
	 */
	public void setQestnrTmplatImagepathnm(byte[] qestnrTmplatImagepathnm) {
		this.qestnrTmplatImagepathnm = new byte[qestnrTmplatImagepathnm.length];
		
		for (int i = 0; i <  qestnrTmplatImagepathnm.length; ++i) {
			this.qestnrTmplatImagepathnm[i] = qestnrTmplatImagepathnm[i];
		}
	}

	/**
	 * qestnrTmplatCn attribute 를 리턴한다.
	 * @return the String
	 */
	public String getQestnrTmplatCn() {
		return qestnrTmplatCn;
	}

	/**
	 * qestnrTmplatCn attribute 값을 설정한다.
	 * @return qestnrTmplatCn String
	 */
	public void setQestnrTmplatCn(String qestnrTmplatCn) {
		this.qestnrTmplatCn = qestnrTmplatCn;
	}

	/**
	 * qestnrTmplatCours attribute 를 리턴한다.
	 * @return the String
	 */
	public String getQestnrTmplatCours() {
		return qestnrTmplatCours;
	}

	/**
	 * qestnrTmplatCours attribute 값을 설정한다.
	 * @return qestnrTmplatCours String
	 */
	public void setQestnrTmplatCours(String qestnrTmplatCours) {
		this.qestnrTmplatCours = qestnrTmplatCours;
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
