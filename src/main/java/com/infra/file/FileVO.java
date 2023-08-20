/*
 * Copyright (c) 2012 ZES Inc. All rights reserved. This software is the
 * confidential and proprietary information of ZES Inc. You shall not disclose
 * such Confidential Information and shall use it only in accordance with the
 * terms of the license agreement you entered into with ZES Inc.
 * (http://www.zesinc.co.kr/)
 */
package com.infra.file;

import java.io.File;

public class FileVO{

    private static final long serialVersionUID = 5413582282091979242L;

    /** 파일 Object */
    private File file;

    /** 파일 순번 */
    private Integer fileSeq = 0;

    /** 파일 ID */
    private String fileId;

    /** 파일 정렬순서 (기본:0) */
    private Integer orderNo = 0;

    /** 파일 URL (외부 접근용-이미지) */
    private String fileUrl;

    /** 파일 이름 (업로드 원본 이름) */
    private String localNm;

    /** 파일 이름 (서버에 저장된 이름) */
    private String serverNm;

    /** 파일 설명(웹접근성 용도의 설명문. 이미지의 경우 alt 태그에 해당) */
    private String fileDesc;

    /** input type='file'의 name값 */
    private String inputNm;

    /** 파일 크기(화면표시용) */
    private String fileSize;

    /** 파일 크기(bite) */
    private Long fileByteSize;

    /** 파일 유형 */
    private String fileType;

    /** 다운로드 횟수 (기본:0) */
    private Integer downCnt = 0;

    /** 파일확장자 */
    private String fileExt;

    /**
     * File file을 반환
     * 
     * @return File file
     */
    public File getFile() {
        return file;
    }

    /**
     * file을 설정
     * 
     * @param file 을(를) File file로 설정
     */
    public void setFile(File file) {
        this.file = file;
    }

    /**
     * Integer fileSeq을 반환
     * 
     * @return Integer fileSeq
     */
    public Integer getFileSeq() {
        return fileSeq;
    }

    /**
     * fileSeq을 설정
     * 
     * @param fileSeq 을(를) Integer fileSeq로 설정
     */
    public void setFileSeq(Integer fileSeq) {
        this.fileSeq = fileSeq;
    }

    /**
     * String fileId을 반환
     * 
     * @return String fileId
     */
    public String getFileId() {
        return fileId;
    }

    /**
     * fileId을 설정
     * 
     * @param fileId 을(를) String fileId로 설정
     */
    public void setFileId(String fileId) {
        this.fileId = fileId;
    }

    /**
     * Integer orderNo을 반환
     * 
     * @return Integer orderNo
     */
    public Integer getOrderNo() {
        return orderNo;
    }

    /**
     * orderNo을 설정
     * 
     * @param orderNo 을(를) Integer orderNo로 설정
     */
    public void setOrderNo(Integer orderNo) {
        this.orderNo = orderNo;
    }

    /**
     * String fileUrl을 반환
     * 
     * @return String fileUrl
     */
    public String getFileUrl() {
        return fileUrl;
    }

    /**
     * fileUrl을 설정
     * 
     * @param fileUrl 을(를) String fileUrl로 설정
     */
    public void setFileUrl(String fileUrl) {
        this.fileUrl = fileUrl;
    }

    /**
     * String localNm을 반환
     * 
     * @return String localNm
     */
    public String getLocalNm() {
        return localNm;
    }

    /**
     * localNm을 설정
     * 
     * @param localNm 을(를) String localNm로 설정
     */
    public void setLocalNm(String localNm) {
        this.localNm = localNm;
    }

    /**
     * String serverNm을 반환
     * 
     * @return String serverNm
     */
    public String getServerNm() {
        return serverNm;
    }

    /**
     * serverNm을 설정
     * 
     * @param serverNm 을(를) String serverNm로 설정
     */
    public void setServerNm(String serverNm) {
        this.serverNm = serverNm;
    }

    /**
     * String fileDesc을 반환
     * 
     * @return String fileDesc
     */
    public String getFileDesc() {
        return fileDesc;
    }

    /**
     * fileDesc을 설정
     * 
     * @param fileDesc 을(를) String fileDesc로 설정
     */
    public void setFileDesc(String fileDesc) {
        this.fileDesc = fileDesc;
    }

    /**
     * String inputNm을 반환
     * 
     * @return String inputNm
     */
    public String getInputNm() {
        return inputNm;
    }

    /**
     * inputNm을 설정
     * 
     * @param inputNm 을(를) String inputNm로 설정
     */
    public void setInputNm(String inputNm) {
        this.inputNm = inputNm;
    }

    /**
     * String fileSize을 반환
     * 
     * @return String fileSize
     */
    public String getFileSize() {
        return fileSize;
    }

    /**
     * fileSize을 설정
     * 
     * @param fileSize 을(를) String fileSize로 설정
     */
    public void setFileSize(String fileSize) {
        this.fileSize = fileSize;
    }

    /**
     * Long fileByteSize을 반환
     * 
     * @return Long fileByteSize
     */
    public Long getFileByteSize() {
        return fileByteSize;
    }

    /**
     * fileByteSize을 설정
     * 
     * @param fileByteSize 을(를) Long fileByteSize로 설정
     */
    public void setFileByteSize(Long fileByteSize) {
        this.fileByteSize = fileByteSize;
    }

    /**
     * String fileType을 반환
     * 
     * @return String fileType
     */
    public String getFileType() {
        return fileType;
    }

    /**
     * fileType을 설정
     * 
     * @param fileType 을(를) String fileType로 설정
     */
    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    /**
     * Integer downCnt을 반환
     * 
     * @return Integer downCnt
     */
    public Integer getDownCnt() {
        return downCnt;
    }

    /**
     * downCnt을 설정
     * 
     * @param downCnt 을(를) Integer downCnt로 설정
     */
    public void setDownCnt(Integer downCnt) {
        this.downCnt = downCnt;
    }

    /**
     * String fileExt을 반환
     * 
     * @return String fileExt
     */
    public String getFileExt() {
        return fileExt;
    }

    /**
     * fileExt을 설정
     * 
     * @param fileExt 을(를) String fileExt로 설정
     */
    public void setFileExt(String fileExt) {
        this.fileExt = fileExt;
    }

}
