package com.comm.issue;

public class CertIssueVo {
	/***********************
	 * 문서확인번호
	 ***********************/
	String docNo;	
	/***********************
	 * 접수번호
	 ***********************/
	String rceptNo;
	/***********************
	 * 접수일자
	 ***********************/
	String rceptDe;
	/***********************
	 * 발급번호
	 ***********************/
	String issueNo;
	/***********************
	 * 회사명
	 ***********************/
	String corpNm;
	/***********************
	 * 대표자명
	 ***********************/
	String ceoNm;
	/***********************
	 * 법인번호
	 ***********************/
	String juriNo;
	/***********************
	 * 사업자번호
	 ***********************/
	String corpRegNo;
	/***********************
	 * 본사주소
	 ***********************/
	String address;
	/***********************
	 * 유효기간
	 ***********************/
	String expireDe;
	/***********************
	 * 출력일
	 ***********************/
	String printDe;

	public String getDocNo() {
		return docNo;
	}

	public void setDocNo(String docNo) {
		this.docNo = docNo;
	}
	
	public String getRceptNo() {
		return rceptNo;
	}
	
	public void setRceptNo(String rceptNo) {
		this.rceptNo = rceptNo;
	}
	
	public String getRceptDe() {
		return rceptDe;
	}
	
	public void setRceptDe(String rceptDe) {
		this.rceptDe = rceptDe;
	}
	
	public String getIssueNo() {
		return issueNo;
	}

	public void setIssueNo(String issueNo) {
		this.issueNo = issueNo;
	}

	public String getCorpNm() {
		return corpNm;
	}

	public void setCorpNm(String corpNm) {
		this.corpNm = corpNm;
	}

	public String getJuriNo() {
		return juriNo;
	}

	public void setJuriNo(String juriNo) {
		this.juriNo = juriNo;
	}
	
	public String getCeoNm() {
		return ceoNm;
	}

	public void setCeoNm(String ceoNm) {
		this.ceoNm = ceoNm;
	}
	
	public String getCorpRegNo() {
		return corpRegNo;
	}

	public void setCorpRegNo(String corpRegNo) {
		this.corpRegNo = corpRegNo;
	}
	
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
	
	public String getExpireDe() {
		return expireDe;
	}

	public void setExpireDe(String expireDe) {
		this.expireDe = expireDe;
	}
	
	public String getPrintDe() {
		return printDe;
	}

	public void setPrintDe(String printDe) {
		this.printDe = printDe;
	}
}
