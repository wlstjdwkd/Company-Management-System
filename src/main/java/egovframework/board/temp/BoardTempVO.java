/*
 * Copyright (c) 2012 ZES Inc. All rights reserved.
 * This software is the confidential and proprietary information of ZES Inc.
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with ZES Inc. (http://www.zesinc.co.kr/)
 */
package egovframework.board.temp;

public class BoardTempVO {

    static final long serialVersionUID = -4912268371906466687L;

    /** 게시판 템플릿 타입 */
    private String templateType;
    /** 게시판 템플릿 아이디 */
    private String templateId;
    /** 게시판 템플릿 이름 */
    private String templateNm;
    /** 게시판 템플릿 소스 파일경로 */
    private String templateFileNm;
    /** 게시판 템플릿 스크린샷 파일경로 */
    private String screenshotFileNm;
    /** 등록자아이디 */
    private String regId;
    /** 등록일시 */
    private String regDt;
    /** 수정자아이디 */
    private String modId;
    /** 수정일시 */
    private String modDt;

    /** 기존 게시판 템플릿 아이디 */
    private String oldTemplateId;

    /**
     * String templateType을 반환
     * @return String templateType
     */
    public String getTemplateType() {
        return templateType;
    }
    
    /**
     * templateType을 설정
     * @param templateType 을(를) String templateType로 설정
     */
    public void setTemplateType(String templateType) {
        this.templateType = templateType;
    }
    
    /**
     * String templateId을 반환
     * @return String templateId
     */
    public String getTemplateId() {
        return templateId;
    }
    
    /**
     * templateId을 설정
     * @param templateId 을(를) String templateId로 설정
     */
    public void setTemplateId(String templateId) {
        this.templateId = templateId;
    }
    
    /**
     * String templateNm을 반환
     * @return String templateNm
     */
    public String getTemplateNm() {
        return templateNm;
    }
    
    /**
     * templateNm을 설정
     * @param templateNm 을(를) String templateNm로 설정
     */
    public void setTemplateNm(String templateNm) {
        this.templateNm = templateNm;
    }
    
    /**
     * String templateFileNm을 반환
     * @return String templateFileNm
     */
    public String getTemplateFileNm() {
        return templateFileNm;
    }
    
    /**
     * templateFileNm을 설정
     * @param templateFileNm 을(를) String templateFileNm로 설정
     */
    public void setTemplateFileNm(String templateFileNm) {
        this.templateFileNm = templateFileNm;
    }
    
    /**
     * String screenshotFileNm을 반환
     * @return String screenshotFileNm
     */
    public String getScreenshotFileNm() {
        return screenshotFileNm;
    }
    
    /**
     * screenshotFileNm을 설정
     * @param screenshotFileNm 을(를) String screenshotFileNm로 설정
     */
    public void setScreenshotFileNm(String screenshotFileNm) {
        this.screenshotFileNm = screenshotFileNm;
    }
    
    /**
     * String regId을 반환
     * @return String regId
     */
    public String getRegId() {
        return regId;
    }
    
    /**
     * regId을 설정
     * @param regId 을(를) String regId로 설정
     */
    public void setRegId(String regId) {
        this.regId = regId;
    }
    
    /**
     * String regDt을 반환
     * @return String regDt
     */
    public String getRegDt() {
        return regDt;
    }
    
    /**
     * regDt을 설정
     * @param regDt 을(를) String regDt로 설정
     */
    public void setRegDt(String regDt) {
        this.regDt = regDt;
    }
    
    /**
     * String modId을 반환
     * @return String modId
     */
    public String getModId() {
        return modId;
    }
    
    /**
     * modId을 설정
     * @param modId 을(를) String modId로 설정
     */
    public void setModId(String modId) {
        this.modId = modId;
    }
    
    /**
     * String modDt을 반환
     * @return String modDt
     */
    public String getModDt() {
        return modDt;
    }
    
    /**
     * modDt을 설정
     * @param modDt 을(를) String modDt로 설정
     */
    public void setModDt(String modDt) {
        this.modDt = modDt;
    }

    /**
     * String oldTemplateId을 반환
     * @return String oldTemplateId
     */
    public String getOldTemplateId() {
        return oldTemplateId;
    }
    
    /**
     * oldTemplateId을 설정
     * @param oldTemplateId 을(를) String oldTemplateId로 설정
     */
    public void setOldTemplateId(String oldTemplateId) {
        this.oldTemplateId = oldTemplateId;
    }
}