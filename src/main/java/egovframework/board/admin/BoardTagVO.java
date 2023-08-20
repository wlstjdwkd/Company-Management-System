/*
 * Copyright (c) 2012 ZES Inc. All rights reserved.
 * This software is the confidential and proprietary information of ZES Inc.
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with ZES Inc. (http://www.zesinc.co.kr/)
 */
package egovframework.board.admin;

public class BoardTagVO{

    private static final long serialVersionUID = -9078428935462207175L;

    /** 게시판 코드 */
    private Integer bbsCd;
    /** 일련번호 */
    private String seq;
    /** 태그 이름 */
    private String tagNm;
    /** 태그 갯수 */
    private Integer tagCnt;

    public BoardTagVO(Integer bbsCd, String seq, String tagNm) {
        this.bbsCd = bbsCd;
        this.seq = seq;
        this.tagNm = tagNm;
    }

    public BoardTagVO() {
        // 기본 생성자
    }

    public Integer getBbsCd() {
        return bbsCd;
    }

    public void setBbsCd(Integer bbsCd) {
        this.bbsCd = bbsCd;
    }

    public String getSeq() {
        return seq;
    }

    public void setSeq(String seq) {
        this.seq = seq;
    }

    public String getTagNm() {
        return tagNm;
    }

    public void setTagNm(String tagNm) {
        this.tagNm = tagNm;
    }

    public Integer getTagCnt() {
        return tagCnt;
    }

    public void setTagCnt(Integer tagCnt) {
        this.tagCnt = tagCnt;
    }
}
