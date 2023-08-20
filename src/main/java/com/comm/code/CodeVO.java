package com.comm.code;

/**
 * 코드 정보 VO
 */
public class CodeVO {
	
	// 코드
	private String code;
	// 코드 설명
	private String codeDc;
	// 코드 그룹 번호
	private int codeGroupNo;
	// 코드명
	private String codeNm;
	// 사용여부
	private String userAt;
	// 출력순서
	private String outptOrdr;
	
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getCodeDc() {
		return codeDc;
	}
	public void setCodeDc(String codeDc) {
		this.codeDc = codeDc;
	}
	public int getCodeGroupNo() {
		return codeGroupNo;
	}
	public void setCodeGroupNo(int codeGroupNo) {
		this.codeGroupNo = codeGroupNo;
	}
	public String getCodeNm() {
		return codeNm;
	}
	public void setCodeNm(String codeNm) {
		this.codeNm = codeNm;
	}
	public String getUserAt() {
		return userAt;
	}
	public void setUserAt(String userAt) {
		this.userAt = userAt;
	}
	public String getOutptOrdr() {
		return outptOrdr;
	}
	public void setOutptOrdr(String outptOrdr) {
		this.outptOrdr = outptOrdr;
	}
	
}
