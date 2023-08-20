/*
 * Copyright (c) 2012 ZES Inc. All rights reserved.
 * This software is the confidential and proprietary information of ZES Inc.
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with ZES Inc. (http://www.zesinc.co.kr/)
 */
package egovframework.board.config;

public class BoardConfYnVO {    

    /** 게시판 코드 */
    private Integer bbsCd = 0;
    /** 사용여부 */
    private String useYn;
    /** 수정일 */
    private String modDt;

    /** 게시판 설정 구분 코드 */
    private Integer gubunCd = 0;

    /*
     * -----------------------------------------------------------
     * GLOBAL
     */
    /** 분류 사용여부 */
    private String ctgYn;
    /** 공지글 사용여부 */
    private String noticeYn;
    /** 의견글 사용여부 */
    private String commentYn;
    /** FEED 제공여부 */
    private String feedYn;

    /*
     * -----------------------------------------------------------
     * LIST
     */
    /** 다운로드 사용여부 */
    private String downYn;

    /*
     * -----------------------------------------------------------
     * FORM
     */
    /** 관리자단 에디터 사용여부 */
    private String mgrEditorYn;
    /** 사용자단 에디터 사용여부 */
    private String usrEditorYn;
    /** 첨부파일 사용여부 */
    private String fileYn;
    /** 금칙어 사용여부 */
    private String banYn;
    /** 태그사용여부 */
    private String tagYn = "N";
    /** CAPTCHAR 사용여부 */
    private String captchaYn;
    /** 공개 여부 */
    private String openYn;
    /*
     * -----------------------------------------------------------
     * VIEW
     */
    /** 추천 사용여부 */
    private String recommYn;
    /** 신고 사용여부 */
    private String sueYn;
    /** 만족도 사용여부 */
    private String stfyYn;

    public Integer getBbsCd() {
        return bbsCd;
    }

    public void setBbsCd(Integer bbsCd) {
        this.bbsCd = bbsCd;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

    public String getModDt() {
        return modDt;
    }

    public void setModDt(String modDt) {
        this.modDt = modDt;
    }

    public Integer getGubunCd() {
        return gubunCd;
    }

    public void setGubunCd(Integer gubunCd) {
        this.gubunCd = gubunCd;
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

    public String getFeedYn() {
        return feedYn;
    }

    public void setFeedYn(String feedYn) {
        this.feedYn = feedYn;
    }

    public String getDownYn() {
        return downYn;
    }

    public void setDownYn(String downYn) {
        this.downYn = downYn;
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

    public String getBanYn() {
        return banYn;
    }

    public void setBanYn(String banYn) {
        this.banYn = banYn;
    }

    public String getTagYn() {
        return tagYn;
    }

    public void setTagYn(String tagYn) {
        this.tagYn = tagYn;
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
}
