package egovframework.com.sym.bat.service;

import java.io.Serializable;

import egovframework.com.cmm.ComDefaultVO;

/**
 * 배치작업관리에 대한 model 클래스
 * 
 * @author 김진만
 * @since 2010.06.17
 * @version 1.0
 * @updated 17-6-2010 오전 10:27:13
 * @see
 * <pre>
 * == 개정이력(Modification Information) ==
 * 
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2010.06.17   김진만     최초 생성
 * </pre>
 */
@SuppressWarnings("serial")
public class BatchOpert extends ComDefaultVO implements Serializable {
	
	/**
	 * 배치작업ID
	 */
	private String batchOpertId;
	/**
	 * 배치작업명
	 */
	private String batchOpertNm;
	/**
	 * 배치프로그램
	 */
	private String batchProgrm;
	/**
	 * 수정자
	 */
	private String updusr;
	/**
	 * 수정일
	 */
	private String updde;
	/**
	 * 파라미터
	 */
	private String paramtr;
	/**
	 * 사용여부
	 */
	private String useAt;
	/**
	 * 등록자
	 */
	private String register;
	/**
	 * 등록일
	 */
	private String rgsde;

	
	/**
	 * 배치작업ID를 리턴한다. 
	 * @return the batchOpertId
	 */
	public String getBatchOpertId() {
		return batchOpertId;
	}

	/**
	 * 배치작업ID를 설정한다. 
	 * @param batchOpertId 	설정할 배치작업ID
	 */
	public void setBatchOpertId(String batchOpertId) {
		this.batchOpertId = batchOpertId;
	}

	/**
	 * 배치작업명을 리턴한다.
	 * @return the batchOpertNm
	 */
	public String getBatchOpertNm() {
		return batchOpertNm;
	}

	/**
	 * 배치작업명을 설정한다.
	 * @param batchOpertNm 설정할 배치작업명
	 */
	public void setBatchOpertNm(String batchOpertNm) {
		this.batchOpertNm = batchOpertNm;
	}

	/**
	 * 배치프로그램을 리턴한다.
	 * @return the batchProgrm
	 */
	public String getBatchProgrm() {
		return batchProgrm;
	}

	/**
	 * 배치프로그램을 설정한다.
	 * @param batchProgrm 설정할 배치프로그램
	 */
	public void setBatchProgrm(String batchProgrm) {
		this.batchProgrm = batchProgrm;
	}

	/**
	 * 수정자번호를 리턴한다.
	 * @return the updusr
	 */
	public String getUpdusr() {
		return updusr;
	}

	/**
	 * 최종수정자ID를 설정한다.
	 * @param lastUpdusrId 설정할 최종수정자ID
	 */
	public void setUpdusr(String updusr) {
		this.updusr = updusr;
	}

	/**
	 * 최종수정시점을 리턴한다.
	 * @return the updde
	 */
	public String getUpdde() {
		return updde;
	}

	/**
	 * 최종수정시점을 설정한다.
	 * @param lastUpdusrPnttm 설정할 최종수정시점
	 */
	public void setUpdde(String updde) {
		this.updde = updde;
	}

	/**
	 * 파라미터를 리턴한다.
	 * @return the paramtr
	 */
	public String getParamtr() {
		return paramtr;
	}

	/**
	 * 파라미터를 설정한다.
	 * @param paramtr 설정할 파라미터
	 */
	public void setParamtr(String paramtr) {
		this.paramtr = paramtr;
	}

	/**
	 * 사용여부를 리턴한다.
	 * @return the useAt
	 */
	public String getUseAt() {
		return useAt;
	}

	/**
	 * 사용여부를 설정한다.
	 * @param useAt 설정할 사용여부
	 */
	public void setUseAt(String useAt) {
		this.useAt = useAt;
	}

	/**
	 * @return the frstRegisterId
	 */
	public String getRegister() {
		return register;
	}

	/**
	 * @return the frstRegisterPnttm
	 */
	public String getRgsde() {
		return rgsde;
	}

	/**
	 * @param frstRegisterId the frstRegisterId to set
	 */
	public void setRegister(String register) {
		this.register = register;
	}

	/**
	 * @param frstRegisterPnttm the frstRegisterPnttm to set
	 */
	public void setRgsde(String rgsde) {
		this.rgsde = rgsde;
	}

	
}