/*
 * Copyright (c) 2012 ZES Inc. All rights reserved.
 * This software is the confidential and proprietary information of ZES Inc.
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with ZES Inc. (http://www.zesinc.co.kr/)
 */
package egovframework.board.config;

import java.util.List;

public class BoardCtgVO{

    private static final long serialVersionUID = -1468565720003089340L;

    /** 카테고리 목록 */
    private List<BoardCtgVO> ctgList;

    /** 게시판 코드 */
    private Integer bbsCd = 0;
    /** 카테고리 코드 */
    private Integer ctgCd = 0;
    /** 카테고리 이름 */
    private String ctgNm;
    /** 정렬순서 */
    private Integer orderNo = 0;
    /** 사용여부 */
    private String useYn;

    public List<BoardCtgVO> getCtgList() {
        return ctgList;
    }

    public void setCtgList(List<BoardCtgVO> ctgList) {
        this.ctgList = ctgList;
    }

    public Integer getBbsCd() {
        return bbsCd;
    }

    public void setBbsCd(Integer bbsCd) {
        this.bbsCd = bbsCd;
    }

    public Integer getCtgCd() {
        return ctgCd;
    }

    public void setCtgCd(Integer ctgCd) {
        this.ctgCd = ctgCd;
    }

    public String getCtgNm() {
        return ctgNm;
    }

    public void setCtgNm(String ctgNm) {
        this.ctgNm = ctgNm;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

    public Integer getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(Integer orderNo) {
        this.orderNo = orderNo;
    }
}
