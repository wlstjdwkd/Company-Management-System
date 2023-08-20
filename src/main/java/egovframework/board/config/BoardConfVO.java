/*
 * Copyright (c) 2012 ZES Inc. All rights reserved.
 * This software is the confidential and proprietary information of ZES Inc.
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with ZES Inc. (http://www.zesinc.co.kr/)
 */
package egovframework.board.config;

import java.util.List;
import java.util.Map;

public class BoardConfVO{

    private static final long serialVersionUID = 2004189154549584749L;

    /** 분류 목록 */
    private List<BoardCtgVO> ctgList;

    /** 확장설정 목록 */
    private List<BoardExtensionVO> listColunms;
    /** 확장상세보기 목록 */
    private List<BoardExtensionVO> viewColunms;
    /** 확장입력 목록 */
    private List<BoardExtensionVO> formColunms;
    /** 검색대상 목록 */
    private List<BoardExtensionVO> searchColunms;
    /** 관리자 목록 */
    /*private List<MgrVO> authList;*/
    /** 분류명 배열 */
    private String[] ctgNms;
    /** 목록 표시항목 배치 목록 */
    private List<BoardArrangeVO> listArrange;
    /** 상세보기 표시항목 배치 목록 */
    private List<BoardArrangeVO> viewArrange;

    /** 게시판 코드 */
    private Integer bbsCd = 0;
    /** 게시판 코드 목록 */
    private Integer[] bbsCds;
    /** 게시판 이름 */
    /*@Required(message = "게시판 명은 필수 입력입니다.")
    @RangeLength(min = 3, max = 30)*/
    private String bbsNm;
    /** 게시판 설명 */
    /*@RangeLength(max = 300)*/
    private String bbsDesc;
    /** 정렬순서 */
    private Integer orderNo = 0;
    /** 사용여부 */
    private String useYn;
    /** 등록일 */
    private String regDt;
    /** 수정일 */
    private String modDt;

    /** 게시물 수 */
    private Integer articleCnt = 0;
    /** 코멘트 수 */
    private Integer commentCnt = 0;
    /** 첨부파일 수 */
    private Integer fileCnt = 0;
    /** 삭제글 수 */
    private Integer delCnt = 0;

    /** 게시판 설정 구분 코드 */
    private Integer gubunCd = 0;

    /*
     * -----------------------------------------------------------
     * GLOBAL
     */
    /** 게시판 종류 */
    private Integer kindCd = 0;
    /** 게시판 종류 명 */
    private String kindNm;
    /** 분류 사용여부 */
    /*@Required*/
    private String ctgYn = "N";
    /** 공지글 사용여부 */
    /*@Required*/
    private String noticeYn = "N";
    /** 의견글 사용여부 */
    /*@Required*/
    private String commentYn = "N";
    /** FEED 제공여부 */
    private String feedYn = "N";
    /** 스킨세트 (경로명) */
    private String skinPath = "";
    /** 헤더 (경로명) */
    private String headerPath;
    /** 푸터 (경로명) */
    private String footerPath;
    /** 목록템플릿 */
    private String listSkin;
    /** 읽기템플릿 */
    private String viewSkin;
    /** 쓰기템플릿 */
    private String formSkin;

    /*
     * -----------------------------------------------------------
     * LIST
     */
    /** 페이지당 표시글 수 */
    private Integer rppNum = 10;
    /** 다운로드 사용여부 */
    private String downYn = "N";
    /** 제목 조정 길이 */
    private Integer cutTitleNum = 60;
    /** 새글 표시 기일 */
    private Integer newArticleNum = 3;
    /** 강조 조회 수 */
    private Integer emphasisNum = 100;
    /** 작성자 표시 코드 */
    private Integer registerViewCd = 0;

    /*
     * -----------------------------------------------------------
     * FORM
     */
    /** 관리자단 에디터 사용여부 */
    private String mgrEditorYn = "N";
    /** 사용자단 에디터 사용여부 */
    private String usrEditorYn = "N";
    /** 첨부파일 사용여부 */
    private String fileYn = "N";
    /** 업로더 종류 */
    private Integer uploadType = 1000;
    /** 최대 업로드 파일수 */
    private Integer maxFileCnt = 1;
    /** 파일 최대 사이즈 */
    private Integer maxFileSize = 0;
    /** 전체 업로드 사이즈 */
    private Integer totalFileSize = 0;
    /** 첨부파일 허용 확장자 ('|' 구분자) */
    private String fileExts;
    /** 금칙어 사용여부 */
    private String banYn = "N";
    /** CAPTCHAR 사용여부 */
    private String captchaYn = "N";
    /** 공개 여부 */
    private String openYn = "N";
    /** 금칙어 내용 (쉼표구분) */
    private String banContents;

    /*
     * -----------------------------------------------------------
     * VIEW
     */
    /** 글목록 표시 코드 */
    private Integer listViewCd = 1001;
    /** 추천 사용여부 */
    private String recommYn = "N";
    /** 신고 사용여부 */
    private String sueYn = "N";
    /** 만족도 사용여부 */
    private String stfyYn = "N";
    /** 태그사용여부 */
    private String tagYn = "N";
    /** 조회수 제한시간 */
    private Integer readCookieHour = 3;

    /*
     * -----------------------------------------------------------
     * AUTH
     */
    /** 목록조회 권한 코드 */
    private Integer authCdList = 0;
    /** 상세조회 권한 코드 */
    private Integer authCdView = 0;
    /** 글작성 권한 코드 */
    private Integer authCdWrite = 0;
    /** 답글작성 권한 코드 */
    private Integer authCdReply = 0;
    /** 댓글사용 권한 코드 */
    private Integer authCdComment = 0;
    /** 관리자 ID */
    private String authIds;
    /** 총괄관리자여부 */
    private String superAdmYn;
    /** 공공구매관리자여부 */
    private String ppAdmYn;
    
    /**
     * 페이지당 목록 수 
     */
    private Integer q_rowPerPage;
    private String q_searchKey;
	private String q_searchVal;
	private String q_searchType;
	private String q_sortName;
	private String q_sortOrder;
	
	private int q_currPage;
	
	private int df_curr_page;
	private int limitFrom;
	private int limitTo;
	
	private Map<String, Object> dataMap;

    public Integer getBbsCd() {
        return bbsCd;
    }

    public void setBbsCd(Integer bbsCd) {
        this.bbsCd = bbsCd;
    }

    public Integer[] getBbsCds() {
        return bbsCds;
    }

    public void setBbsCds(Integer[] bbsCds) {
        this.bbsCds = bbsCds;
    }

    public String getBbsNm() {
        return bbsNm;
    }

    public void setBbsNm(String bbsNm) {
        this.bbsNm = bbsNm;
    }

    public String getBbsDesc() {
        return bbsDesc;
    }

    public void setBbsDesc(String bbsDesc) {
        this.bbsDesc = bbsDesc;
    }

    public Integer getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(Integer orderNo) {
        this.orderNo = orderNo;
    }

    public String getRegDt() {
        return regDt;
    }

    public void setRegDt(String regDt) {
        this.regDt = regDt;
    }

    public String getModDt() {
        return modDt;
    }

    public void setModDt(String modDt) {
        this.modDt = modDt;
    }

    public Integer getArticleCnt() {
        return articleCnt;
    }

    public void setArticleCnt(Integer articleCnt) {
        this.articleCnt = articleCnt;
    }

    public Integer getCommentCnt() {
        return commentCnt;
    }

    public void setCommentCnt(Integer commentCnt) {
        this.commentCnt = commentCnt;
    }

    public Integer getFileCnt() {
        return fileCnt;
    }

    public void setFileCnt(Integer fileCnt) {
        this.fileCnt = fileCnt;
    }

    public Integer getDelCnt() {
        return delCnt;
    }

    public void setDelCnt(Integer delCnt) {
        this.delCnt = delCnt;
    }

    public Integer getKindCd() {
        return kindCd;
    }

    public void setKindCd(Integer kindCd) {
        /*setKindNm(BoardConfConstant.MAP_KIND_CD.get(kindCd));*/
        this.kindCd = kindCd;
    }

    public String getCtgYn() {
        return ctgYn;
    }

    public void setCtgYn(String ctgYn) {
        this.ctgYn = ctgYn;
    }

    public String getNoticeYn() {
        return noticeYn;
    }

    public void setNoticeYn(String noticeYn) {
        this.noticeYn = noticeYn;
    }

    public String getCommentYn() {
        return commentYn;
    }

    public void setCommentYn(String commentYn) {
        this.commentYn = commentYn;
    }

    public String getSkinPath() {
        return skinPath;
    }

    public void setSkinPath(String skinPath) {
        this.skinPath = skinPath;
    }

    public String getHeaderPath() {
        return headerPath;
    }

    public void setHeaderPath(String headerPath) {
        this.headerPath = headerPath;
    }

    public String getFooterPath() {
        return footerPath;
    }

    public void setFooterPath(String footerPath) {
        this.footerPath = footerPath;
    }

    public String getListSkin() {
        return listSkin;
    }

    public void setListSkin(String listSkin) {
        this.listSkin = listSkin;
    }

    public String getViewSkin() {
        return viewSkin;
    }

    public void setViewSkin(String viewSkin) {
        this.viewSkin = viewSkin;
    }

    public String getFormSkin() {
        return formSkin;
    }

    public void setFormSkin(String formSkin) {
        this.formSkin = formSkin;
    }

    public String getFeedYn() {
        return feedYn;
    }

    public void setFeedYn(String feedYn) {
        this.feedYn = feedYn;
    }

    public Integer getRppNum() {
        return rppNum;
    }

    public void setRppNum(Integer rppNum) {
        this.rppNum = rppNum;
    }

    public String getDownYn() {
        return downYn;
    }

    public void setDownYn(String downYn) {
        this.downYn = downYn;
    }

    public Integer getCutTitleNum() {
        return cutTitleNum;
    }

    public void setCutTitleNum(Integer cutTitleNum) {
        this.cutTitleNum = cutTitleNum;
    }

    public Integer getNewArticleNum() {
        return newArticleNum;
    }

    public void setNewArticleNum(Integer newArticleNum) {
        this.newArticleNum = newArticleNum;
    }

    public Integer getEmphasisNum() {
        return emphasisNum;
    }

    public void setEmphasisNum(Integer emphasisNum) {
        this.emphasisNum = emphasisNum;
    }

    public Integer getRegisterViewCd() {
        return registerViewCd;
    }

    public void setRegisterViewCd(Integer registerViewCd) {
        this.registerViewCd = registerViewCd;
    }

    public String getMgrEditorYn() {
        return mgrEditorYn;
    }

    public void setMgrEditorYn(String mgrEditorYn) {
        this.mgrEditorYn = mgrEditorYn;
    }

    public String getUsrEditorYn() {
        return usrEditorYn;
    }

    public void setUsrEditorYn(String usrEditorYn) {
        this.usrEditorYn = usrEditorYn;
    }

    public String getFileYn() {
        return fileYn;
    }

    public void setFileYn(String fileYn) {
        this.fileYn = fileYn;
    }

    public Integer getUploadType() {
        return uploadType;
    }

    public void setUploadType(Integer uploadType) {
        this.uploadType = uploadType;
    }

    public Integer getMaxFileCnt() {
        return maxFileCnt;
    }

    public void setMaxFileCnt(Integer maxFileCnt) {
        this.maxFileCnt = maxFileCnt;
    }

    public Integer getMaxFileSize() {
        return maxFileSize;
    }

    public void setMaxFileSize(Integer maxFileSize) {
        this.maxFileSize = maxFileSize;
    }

    public Integer getTotalFileSize() {
        return totalFileSize;
    }

    public void setTotalFileSize(Integer totalFileSize) {
        this.totalFileSize = totalFileSize;
    }

    public String getFileExts() {
        return fileExts;
    }

    public void setFileExts(String fileExts) {
        this.fileExts = fileExts;
    }

    public String getBanYn() {
        return banYn;
    }

    public void setBanYn(String banYn) {
        this.banYn = banYn;
    }

    public String getBanContents() {
        return banContents;
    }

    public void setBanContents(String banContents) {
        this.banContents = banContents;
    }

    public String getCaptchaYn() {
        return captchaYn;
    }

    public void setCaptchaYn(String captchaYn) {
        this.captchaYn = captchaYn;
    }

    public String getOpenYn() {
        return openYn;
    }

    public void setOpenYn(String openYn) {
        this.openYn = openYn;
    }

    public Integer getListViewCd() {
        return listViewCd;
    }

    public void setListViewCd(Integer listViewCd) {
        this.listViewCd = listViewCd;
    }

    public String getRecommYn() {
        return recommYn;
    }

    public void setRecommYn(String recommYn) {
        this.recommYn = recommYn;
    }

    public String getSueYn() {
        return sueYn;
    }

    public void setSueYn(String sueYn) {
        this.sueYn = sueYn;
    }

    public String getStfyYn() {
        return stfyYn;
    }

    public void setStfyYn(String stfyYn) {
        this.stfyYn = stfyYn;
    }

    public String getTagYn() {
        return tagYn;
    }

    public void setTagYn(String tagYn) {
        this.tagYn = tagYn;
    }

    public Integer getReadCookieHour() {
        return readCookieHour;
    }

    public void setReadCookieHour(Integer readCookieHour) {
        this.readCookieHour = readCookieHour;
    }

    public Integer getGubunCd() {
        return gubunCd;
    }

    public void setGubunCd(Integer gubunCd) {
        this.gubunCd = gubunCd;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

    public String getKindNm() {
        return kindNm;
    }

    public void setKindNm(String kindNm) {
        this.kindNm = kindNm;
    }

    public Integer getAuthCdList() {
        return authCdList;
    }

    public void setAuthCdList(Integer authCdList) {
        this.authCdList = authCdList;
    }

    public Integer getAuthCdView() {
        return authCdView;
    }

    public void setAuthCdView(Integer authCdView) {
        this.authCdView = authCdView;
    }

    public Integer getAuthCdWrite() {
        return authCdWrite;
    }

    public void setAuthCdWrite(Integer authCdWrite) {
        this.authCdWrite = authCdWrite;
    }

    public Integer getAuthCdReply() {
        return authCdReply;
    }

    public void setAuthCdReply(Integer authCdReply) {
        this.authCdReply = authCdReply;
    }

    public Integer getAuthCdComment() {
        return authCdComment;
    }

    public void setAuthCdComment(Integer authCdComment) {
        this.authCdComment = authCdComment;
    }

    public String getAuthIds() {
        return authIds;
    }

    public void setAuthIds(String authIds) {
        this.authIds = authIds;
    }

    public List<BoardCtgVO> getCtgList() {
        return ctgList;
    }

    public void setCtgList(List<BoardCtgVO> ctgList) {
        this.ctgList = ctgList;
    }

    public List<BoardExtensionVO> getListColunms() {
        return listColunms;
    }

    public void setListColunms(List<BoardExtensionVO> listColunms) {
        this.listColunms = listColunms;
    }

    public List<BoardExtensionVO> getViewColunms() {
        return viewColunms;
    }

    public void setViewColunms(List<BoardExtensionVO> viewColunms) {
        this.viewColunms = viewColunms;
    }

    public List<BoardExtensionVO> getFormColunms() {
        return formColunms;
    }

    public void setFormColunms(List<BoardExtensionVO> formColunms) {
        this.formColunms = formColunms;
    }

    public List<BoardExtensionVO> getSearchColunms() {
        return searchColunms;
    }

    public void setSearchColunms(List<BoardExtensionVO> searchColunms) {
        this.searchColunms = searchColunms;
    }

    public String[] getCtgNms() {
        return ctgNms;
    }

    public void setCtgNms(String[] ctgNms) {
        this.ctgNms = ctgNms;
    }

    /*public List<MgrVO> getAuthList() {
        return authList;
    }

    public void setAuthList(List<MgrVO> authList) {
        this.authList = authList;
    }*/

    public List<BoardArrangeVO> getListArrange() {
        return listArrange;
    }

    public void setListArrange(List<BoardArrangeVO> listArrange) {
        this.listArrange = listArrange;
    }

    public List<BoardArrangeVO> getViewArrange() {
        return viewArrange;
    }

    public void setViewArrange(List<BoardArrangeVO> viewArrange) {
        this.viewArrange = viewArrange;
    }

    public String getSuperAdmYn() {
        return superAdmYn;
    }

    public void setSuperAdmYn(String superAdmYn) {
        this.superAdmYn = superAdmYn;
    }

    public String getPpAdmYn() {
        return ppAdmYn;
    }

    public void setPpAdmYn(String ppAdmYn) {
        this.ppAdmYn = ppAdmYn;
    }

	public Integer getQ_rowPerPage() {
		return q_rowPerPage;
	}

	public void setQ_rowPerPage(Integer q_rowPerPage) {
		this.q_rowPerPage = q_rowPerPage;
	}

	public String getQ_searchKey() {
		return q_searchKey;
	}

	public void setQ_searchKey(String q_searchKey) {
		this.q_searchKey = q_searchKey;
	}

	public String getQ_searchVal() {
		return q_searchVal;
	}

	public void setQ_searchVal(String q_searchVal) {
		this.q_searchVal = q_searchVal;
	}

	public String getQ_searchType() {
		return q_searchType;
	}

	public void setQ_searchType(String q_searchType) {
		this.q_searchType = q_searchType;
	}

	public String getQ_sortName() {
		return q_sortName;
	}

	public void setQ_sortName(String q_sortName) {
		this.q_sortName = q_sortName;
	}

	public String getQ_sortOrder() {
		return q_sortOrder;
	}

	public void setQ_sortOrder(String q_sortOrder) {
		this.q_sortOrder = q_sortOrder;
	}

	public int getQ_currPage() {
		return q_currPage;
	}

	public void setQ_currPage(int q_currPage) {
		this.q_currPage = q_currPage;
	}

	public int getDf_curr_page() {
		return df_curr_page;
	}

	public void setDf_curr_page(int df_curr_page) {
		this.df_curr_page = df_curr_page;
	}

	public int getLimitFrom() {
		return limitFrom;
	}

	public void setLimitFrom(int limitFrom) {
		this.limitFrom = limitFrom;
	}

	public int getLimitTo() {
		return limitTo;
	}

	public void setLimitTo(int limitTo) {
		this.limitTo = limitTo;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public Map<String, Object> getDataMap() {
		return dataMap;
	}

	public void setDataMap(Map<String, Object> dataMap) {
		this.dataMap = dataMap;
	}
    
}
