/*
 * Copyright (c) 2012 ZES Inc. All rights reserved.
 * This software is the confidential and proprietary information of ZES Inc.
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with ZES Inc. (http://www.zesinc.co.kr/)
 */
package egovframework.board.admin;

public class BoardConvertOptionVO extends BoardVO {

    static final long serialVersionUID = 9196639835280708011L;

    /** 모두 표시 */
    private String showAll = "N";
    /** 공지목록 사용 */
    private String noticeYnYn = "N";
    /** 카테고리 사용 */
    private String ctgCdYn = "N";
    /** 제목 사용 */
    private String titleYn = "N";
    /** 요약 사용 */
    private String summaryYn = "N";
    /** 등록일 사용 */
    private String regDtYn = "N";
    /** 수정일 사용 */
    private String modDtYn = "N";
    /** 작성자이름 사용 */
    private String regNmYn = "N";
    /** 매니저ID 사용 */
    private String mgrIdYn = "N";
    /** 유저ID 사용 */
    private String userKeyYn = "N";
    /** 조회수 사용 */
    private String readCntYn = "N";
    /** 총점수 사용 */
    private String scoreSumYn = "N";
    /** 투표수 사용 */
    private String scoreCntYn = "N";
    /** 신고수 사용 */
    private String accuseCntYn = "N";
    /** 추천수 사용 */
    private String recomCntYn = "N";

    /** 최대 결과갯수 */
    private Integer maxResult = 0;

    public String getShowAll() {
        return showAll;
    }

    public void setShowAll(String showAll) {
        this.showAll = showAll;
    }

    public String getNoticeYnYn() {
        return noticeYnYn;
    }

    public void setNoticeYnYn(String noticeYnYn) {
        this.noticeYnYn = noticeYnYn;
    }

    public String getCtgCdYn() {
        return ctgCdYn;
    }

    public void setCtgCdYn(String ctgCdYn) {
        this.ctgCdYn = ctgCdYn;
    }

    public String getTitleYn() {
        return titleYn;
    }

    public void setTitleYn(String titleYn) {
        this.titleYn = titleYn;
    }

    public String getSummaryYn() {
        return summaryYn;
    }

    public void setSummaryYn(String summaryYn) {
        this.summaryYn = summaryYn;
    }

    public String getRegDtYn() {
        return regDtYn;
    }

    public void setRegDtYn(String regDtYn) {
        this.regDtYn = regDtYn;
    }

    public String getModDtYn() {
        return modDtYn;
    }

    public void setModDtYn(String modDtYn) {
        this.modDtYn = modDtYn;
    }

    public String getRegNmYn() {
        return regNmYn;
    }

    public void setRegNmYn(String regNmYn) {
        this.regNmYn = regNmYn;
    }

    public String getMgrIdYn() {
        return mgrIdYn;
    }

    public void setMgrIdYn(String mgrIdYn) {
        this.mgrIdYn = mgrIdYn;
    }

    public String getUserKeyYn() {
        return userKeyYn;
    }

    public void setUserKeyYn(String userKeyYn) {
        this.userKeyYn = userKeyYn;
    }

    public String getReadCntYn() {
        return readCntYn;
    }

    public void setReadCntYn(String readCntYn) {
        this.readCntYn = readCntYn;
    }

    public String getScoreSumYn() {
        return scoreSumYn;
    }

    public void setScoreSumYn(String scoreSumYn) {
        this.scoreSumYn = scoreSumYn;
    }

    public String getScoreCntYn() {
        return scoreCntYn;
    }

    public void setScoreCntYn(String scoreCntYn) {
        this.scoreCntYn = scoreCntYn;
    }

    public String getAccuseCntYn() {
        return accuseCntYn;
    }

    public void setAccuseCntYn(String accuseCntYn) {
        this.accuseCntYn = accuseCntYn;
    }

    public String getRecomCntYn() {
        return recomCntYn;
    }

    public void setRecomCntYn(String recomCntYn) {
        this.recomCntYn = recomCntYn;
    }

    public Integer getMaxResult() {
        return maxResult;
    }

    public void setMaxResult(Integer maxResult) {
        this.maxResult = maxResult;
    }
}
