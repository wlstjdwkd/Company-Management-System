package com.comm.menu;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * 화면에 출력할 메뉴정보 클래스
 */
public class MenuVO implements Serializable {

	private static final long serialVersionUID = 4248462308447082932L;

	private int menuNo;					// 메뉴번호
	private String progrmId;			// 프로그램ID
	private String menuNm;				// 메뉴명
	private int menuLevel;				// 메뉴레벨(depth)
	private int parntsMenuNo;			// 부모메뉴번호
	private int outptOrdr;				// 출력순서
	private String outptTy;				// 출력유형(팝업/일반)
	private String outptAt;				// 출역여부
	private String lastNodeAt;			// 최종노드여부
	private String siteSe;				// 사이트구분(웹/관리자)
	private String url;					// 링크URL
	private List<MenuVO> subMenu;		// 서브메뉴 목록(최종노드여부가 'N'일 시 설정)
	private String topNodeAt;			// 탑메뉴여부
	private String jobSe;				// 업무구분

	public int getMenuNo() {
		return menuNo;
	}
	public void setMenuNo(int menuNo) {
		this.menuNo = menuNo;
	}
	public String getProgrmId() {
		return progrmId;
	}
	public void setProgrmId(String progrmId) {
		this.progrmId = progrmId;
	}
	public String getMenuNm() {
		return menuNm;
	}
	public void setMenuNm(String menuNm) {
		this.menuNm = menuNm;
	}
	public int getMenuLevel() {
		return menuLevel;
	}
	public void setMenuLevel(int menuLevel) {
		this.menuLevel = menuLevel;
	}
	public int getParntsMenuNo() {
		return parntsMenuNo;
	}
	public void setParntsMenuNo(int parntsMenuNo) {
		this.parntsMenuNo = parntsMenuNo;
	}
	public int getOutptOrdr() {
		return outptOrdr;
	}
	public void setOutptOrdr(int outptOrdr) {
		this.outptOrdr = outptOrdr;
	}
	public String getOutptTy() {
		return outptTy;
	}
	public void setOutptTy(String outptTy) {
		this.outptTy = outptTy;
	}
	public String getLastNodeAt() {
		return lastNodeAt;
	}
	public void setLastNodeAt(String lastNodeAt) {
		this.lastNodeAt = lastNodeAt;
	}
	public String getSiteSe() {
		return siteSe;
	}
	public void setSiteSe(String siteSe) {
		this.siteSe = siteSe;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public List<MenuVO> getSubMenu() {
		List<MenuVO> subMenu = this.subMenu;
		return subMenu;
	}
	public void setSubMenu(List<MenuVO> subMenu) {
		for(int i = 0; i < subMenu.size(); i++) {
			this.subMenu.set(i, subMenu.get(i));
		}
	}
	public void addSubMenu(MenuVO menu) {
		if (this.subMenu == null) this.subMenu = new ArrayList();
		this.subMenu.add(menu);
	}
	public String getTopNodeAt() {
		return topNodeAt;
	}
	public void setTopNodeAt(String topNodeAt) {
		this.topNodeAt = topNodeAt;
	}
	public String getJobSe() {
		return jobSe;
	}
	public void setJobSe(String jobSe) {
		this.jobSe = jobSe;
	}
	public String getOutptAt() {
		return outptAt;
	}
	public void setOutptAt(String outptAt) {
		this.outptAt = outptAt;
	}

}
