/*
 * Copyright (c) 2012 ZES Inc. All rights reserved.
 * This software is the confidential and proprietary information of ZES Inc.
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with ZES Inc. (http://www.zesinc.co.kr/)
 */
package egovframework.board.config;

public class BoardArrangeVO{

    private static final long serialVersionUID = 3146240459147309647L;

    /** 표시항목 목록 */
    private String[] displayColumns;

    /** 게시판 코드 */
    private Integer bbsCd = 0;
    /** 목록/상세 구분 */
    private String listViewGubun;
    /** 표시항목ID */
    private String columnId;
    /** 표시항목명 */
    private String columnNm;
    /** 정렬순서 */
    private Integer orderNo = 0;
    /** 빈 이름 */
    private String beanNm;

    public String[] getDisplayColumns() {
        return displayColumns;
    }

    public void setDisplayColumns(String[] displayColumns) {
        this.displayColumns = displayColumns;
    }

    public Integer getBbsCd() {
        return bbsCd;
    }

    public void setBbsCd(Integer bbsCd) {
        this.bbsCd = bbsCd;
    }

    public String getListViewGubun() {
        return listViewGubun;
    }

    public void setListViewGubun(String listViewGubun) {
        this.listViewGubun = listViewGubun;
    }

    public String getColumnId() {
        return columnId;
    }

    public void setColumnId(String columnId) {
        this.columnId = columnId;
    }

    public String getColumnNm() {
        return columnNm;
    }

    public void setColumnNm(String columnNm) {
        this.columnNm = columnNm;
    }

    public Integer getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(Integer orderNo) {
        this.orderNo = orderNo;
    }

    public String getBeanNm() {
        return beanNm;
    }

    public void setBeanNm(String beanNm) {
        this.beanNm = beanNm;
    }
}
