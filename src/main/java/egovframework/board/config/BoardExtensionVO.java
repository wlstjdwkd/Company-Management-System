/*
 * Copyright (c) 2012 ZES Inc. All rights reserved.
 * This software is the confidential and proprietary information of ZES Inc.
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with ZES Inc. (http://www.zesinc.co.kr/)
 */
package egovframework.board.config;

import java.util.List;

public class BoardExtensionVO{

    /** serialVersionUID */
    private static final long serialVersionUID = 5107498923052754886L;

    /** 게시판코드 */
    private Integer bbsCd;
    /** 컬럼 */
    /*@Required*/
    private String columnId;
    /** 컬럼명 */
    /*@Required*/
    private String columnNm;
    /** 컬럼유형 */
    private String columnType;
    /** 컬럼주석 */
    private String columnComment;
    /** 컬럼명에 따른 Bean 멤버명 */
    private String beanName;
    /** 검색조건여부 */
    private String searchYn;
    /** 검색유형 */
    private String searchType;
    /** 필수여부 */
    private String requireYn;
    /** 사용여부 */
    /*@Required*/
    private String useYn;
    
    private List<BoardExtensionVO> extList;

    /**
     * Integer bbsCd을 반환
     * 
     * @return Integer bbsCd
     */
    public Integer getBbsCd() {
        return bbsCd;
    }

    /**
     * bbsCd을 설정
     * 
     * @param bbsCd 을(를) Integer bbsCd로 설정
     */
    public void setBbsCd(Integer bbsCd) {
        this.bbsCd = bbsCd;
    }

    /**
     * String columnId을 반환
     * 
     * @return String columnId
     */
    public String getColumnId() {
        return columnId;
    }

    /**
     * columnId을 설정
     * 
     * @param columnId 을(를) String columnId로 설정
     */
    public void setColumnId(String columnId) {
        this.columnId = columnId;
    }

    /**
     * String columnNm을 반환
     * 
     * @return String columnNm
     */
    public String getColumnNm() {
        return columnNm;
    }

    /**
     * columnNm을 설정
     * 
     * @param columnNm 을(를) String columnNm로 설정
     */
    public void setColumnNm(String columnNm) {
        this.columnNm = columnNm;
    }

    /**
     * String columnType을 반환
     * 
     * @return String columnType
     */
    public String getColumnType() {
        return columnType;
    }

    /**
     * columnType을 설정
     * 
     * @param columnType 을(를) String columnType로 설정
     */
    public void setColumnType(String columnType) {
        this.columnType = columnType;
    }

    /**
     * String columnComment을 반환
     * 
     * @return String columnComment
     */
    public String getColumnComment() {
        return columnComment;
    }

    /**
     * columnComment을 설정
     * 
     * @param columnComment 을(를) String columnComment로 설정
     */
    public void setColumnComment(String columnComment) {
        this.columnComment = columnComment;
    }

    /**
     * String beanName을 반환
     * 
     * @return String beanName
     */
    public String getBeanName() {
        return beanName;
    }

    /**
     * beanName을 설정
     * 
     * @param beanName 을(를) String beanName로 설정
     */
    public void setBeanName(String beanName) {
        this.beanName = beanName;
    }

    /**
     * String searchYn을 반환
     * 
     * @return String searchYn
     */
    public String getSearchYn() {
        return searchYn;
    }

    /**
     * searchYn을 설정
     * 
     * @param searchYn 을(를) String searchYn로 설정
     */
    public void setSearchYn(String searchYn) {
        this.searchYn = searchYn;
    }

    /**
     * String searchType을 반환
     * 
     * @return String searchType
     */
    public String getSearchType() {
        return searchType;
    }

    /**
     * searchType을 설정
     * 
     * @param searchType 을(를) String searchType로 설정
     */
    public void setSearchType(String searchType) {
        this.searchType = searchType;
    }

    /**
     * String requireYn을 반환
     * 
     * @return String requireYn
     */
    public String getRequireYn() {
        return requireYn;
    }

    /**
     * requireYn을 설정
     * 
     * @param requireYn 을(를) String requireYn로 설정
     */
    public void setRequireYn(String requireYn) {
        this.requireYn = requireYn;
    }

    /**
     * String useYn을 반환
     * 
     * @return String useYn
     */
    public String getUseYn() {
        return useYn;
    }

    /**
     * useYn을 설정
     * 
     * @param useYn 을(를) String useYn로 설정
     */
    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

	public List<BoardExtensionVO> getExtList() {
		return extList;
	}

	public void setExtList(List<BoardExtensionVO> extList) {
		this.extList = extList;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
    
    
}
