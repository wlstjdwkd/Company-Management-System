package com.comm.user;

import java.io.Serializable;

/**
 * 사용자에게 할당된 권한정보 클래스
 * @author sujong
 *
 */
public class AuthorityVO implements Serializable {

	private static final long serialVersionUID = -2166796703596121692L;
	
	private String progrmId;						// 프로그램ID
	private String menuOutptAt;					// 메뉴출력여부
	private String inqireAt;							// 조회여부
	private String streAt;							// 저장여부
	private String deleteAt;						// 삭제여부
	private String prntngAt;						// 인쇄여부
	private String excelAt;							// 엑셀여부
	private String spclAt;							// 특수여부
	
	public String getProgrmId() {
		return progrmId;
	}
	public void setProgrmId(String progrmId) {
		this.progrmId = progrmId;
	}
	public String getMenuOutptAt() {
		return menuOutptAt;
	}
	public void setMenuOutptAt(String menuOutptAt) {
		this.menuOutptAt = menuOutptAt;
	}
	public String getInqireAt() {
		return inqireAt;
	}
	public void setInqireAt(String inqireAt) {
		this.inqireAt = inqireAt;
	}
	public String getStreAt() {
		return streAt;
	}
	public void setStreAt(String streAt) {
		this.streAt = streAt;
	}
	public String getDeleteAt() {
		return deleteAt;
	}
	public void setDeleteAt(String deleteAt) {
		this.deleteAt = deleteAt;
	}
	public String getPrntngAt() {
		return prntngAt;
	}
	public void setPrntngAt(String prntngAt) {
		this.prntngAt = prntngAt;
	}
	public String getExcelAt() {
		return excelAt;
	}
	public void setExcelAt(String excelAt) {
		this.excelAt = excelAt;
	}
	public String getSpclAt() {
		return spclAt;
	}
	public void setSpclAt(String spclAt) {
		this.spclAt = spclAt;
	}
	
}
