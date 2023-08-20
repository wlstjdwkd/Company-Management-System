/*
 * Copyright (c) 2012 ZES Inc. All rights reserved.
 * This software is the confidential and proprietary information of ZES Inc.
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with ZES Inc. (http://www.zesinc.co.kr/)
 */
package egovframework.board.admin;

public class BoardCmtVO{

    private static final long serialVersionUID = -1405393597849020323L;

    /** 게시판 코드 */
    private int bbsCd;
    /** 게시판 일련번호 */
    private String seq;
    /** 코멘트 일련번호 */
    private String cmtSeq;
    /** 표정아이콘 */
    private String iconKey;
    /** 코멘트 */
    private String comments;
    /** IP주소 */
    private String ipAddr;
    /** 게시글평가점수 */
    private int score = 0;
    /** 비밀번호 */
    private String regPwd;
    /** 작성자ID */
    private String regId;
    /** 작성자명 */
    private String regNm;
    /** 사용자인증키 */
    private String userKey;
    /** 등록일 */
    private String regDt;
    /** 수정자ID */
    private String modId;
    /** 수정자명 */
    private String modNm;
    /** 수정일 */
    private String modDt;
    /** 담당자ID */
    private String mgrId;
    /** 담당자 이름 */
    private String mgrNm;
    /** 관리자삭제여부 */
    private String mgrDelYn;

    /** 사용자ID */
    private String userId;
    /** 사용자명 */
    private String userNm;
    /** 사용자 닉네임 */
    private String nickNm;

    /**
     * int bbsCd을 반환
     * 
     * @return int bbsCd
     */
    public int getBbsCd() {
        return bbsCd;
    }

    /**
     * bbsCd을 설정
     * 
     * @param bbsCd을(를) int bbsCd로 설정
     */
    public void setBbsCd(int bbsCd) {
        this.bbsCd = bbsCd;
    }

    /**
     * String seq을 반환
     * 
     * @return String seq
     */
    public String getSeq() {
        return seq;
    }

    /**
     * seq을 설정
     * 
     * @param seq을(를) String seq로 설정
     */
    public void setSeq(String seq) {
        this.seq = seq;
    }

    /**
     * String cmtSeq을 반환
     * 
     * @return String cmtSeq
     */
    public String getCmtSeq() {
        return cmtSeq;
    }

    /**
     * cmtSeq을 설정
     * 
     * @param cmtSeq을(를) String cmtSeq로 설정
     */
    public void setCmtSeq(String cmtSeq) {
        this.cmtSeq = cmtSeq;
    }

    /**
     * String iconKey을 반환
     * 
     * @return String iconKey
     */
    public String getIconKey() {
        return iconKey;
    }

    /**
     * iconKey을 설정
     * 
     * @param iconKey을(를) String iconKey로 설정
     */
    public void setIconKey(String iconKey) {
        this.iconKey = iconKey;
    }

    /**
     * String comments을 반환
     * 
     * @return String comments
     */
    public String getComments() {
        return comments;
    }

    /**
     * comments을 설정
     * 
     * @param comments을(를) String comments로 설정
     */
    public void setComments(String comments) {
        this.comments = comments;
    }

    /**
     * String ipAddr을 반환
     * 
     * @return String ipAddr
     */
    public String getIpAddr() {
        return ipAddr;
    }

    /**
     * ipAddr을 설정
     * 
     * @param ipAddr을(를) String ipAddr로 설정
     */
    public void setIpAddr(String ipAddr) {
        this.ipAddr = ipAddr;
    }

    /**
     * int score을 반환
     * 
     * @return int score
     */
    public int getScore() {
        return score;
    }

    /**
     * score을 설정
     * 
     * @param score을(를) int score로 설정
     */
    public void setScore(int score) {
        this.score = score;
    }

    /**
     * String regPwd을 반환
     * 
     * @return String regPwd
     */
    public String getRegPwd() {
        return regPwd;
    }

    /**
     * regPwd을 설정
     * 
     * @param regPwd을(를) String regPwd로 설정
     */
    public void setRegPwd(String regPwd) {
        this.regPwd = regPwd;
    }

    /**
     * String regId을 반환
     * 
     * @return String regId
     */
    public String getRegId() {
        return regId;
    }

    /**
     * regId을 설정
     * 
     * @param regId을(를) String regId로 설정
     */
    public void setRegId(String regId) {
        this.regId = regId;
    }

    /**
     * String regNm을 반환
     * 
     * @return String regNm
     */
    public String getRegNm() {
        return regNm;
    }

    /**
     * regNm을 설정
     * 
     * @param regNm을(를) String regNm로 설정
     */
    public void setRegNm(String regNm) {
        this.regNm = regNm;
    }

    /**
     * String userKey을(를) 반환
     * 
     * @return String userKey
     */
    public String getUserKey() {
        return userKey;
    }

    /**
     * userKey을(를) 설정
     * 
     * @param userKey을(를) String userKey로 설정
     */
    public void setUserKey(String userKey) {
        this.userKey = userKey;
    }

    /**
     * String regDt을 반환
     * 
     * @return String regDt
     */
    public String getRegDt() {
        return regDt;
    }

    /**
     * regDt을 설정
     * 
     * @param regDt을(를) String regDt로 설정
     */
    public void setRegDt(String regDt) {
        this.regDt = regDt;
    }

    /**
     * String modId을 반환
     * 
     * @return String modId
     */
    public String getModId() {
        return modId;
    }

    /**
     * modId을 설정
     * 
     * @param modId을(를) String modId로 설정
     */
    public void setModId(String modId) {
        this.modId = modId;
    }

    /**
     * String modNm을 반환
     * 
     * @return String modNm
     */
    public String getModNm() {
        return modNm;
    }

    /**
     * modNm을 설정
     * 
     * @param modNm을(를) String modNm로 설정
     */
    public void setModNm(String modNm) {
        this.modNm = modNm;
    }

    /**
     * String modDt을 반환
     * 
     * @return String modDt
     */
    public String getModDt() {
        return modDt;
    }

    /**
     * modDt을 설정
     * 
     * @param modDt을(를) String modDt로 설정
     */
    public void setModDt(String modDt) {
        this.modDt = modDt;
    }

    /**
     * String mgrId을 반환
     * 
     * @return String mgrId
     */
    public String getMgrId() {
        return mgrId;
    }

    /**
     * mgrId을 설정
     * 
     * @param mgrId을(를) String mgrId로 설정
     */
    public void setMgrId(String mgrId) {
        this.mgrId = mgrId;
    }

    /**
     * String mgrNm을 반환
     * 
     * @return String mgrNm
     */
    public String getMgrNm() {
        return mgrNm;
    }

    /**
     * mgrNm을 설정
     * 
     * @param mgrNm을(를) String mgrNm로 설정
     */
    public void setMgrNm(String mgrNm) {
        this.mgrNm = mgrNm;
    }

    /**
     * String mgrDelYn을(를) 반환
     * 
     * @return String mgrDelYn
     */
    public String getMgrDelYn() {
        return mgrDelYn;
    }

    /**
     * mgrDelYn을(를) 설정
     * 
     * @param mgrDelYn을(를) String mgrDelYn로 설정
     */
    public void setMgrDelYn(String mgrDelYn) {
        this.mgrDelYn = mgrDelYn;
    }

    /**
     * String userId을 반환
     * 
     * @return String userId
     */
    public String getUserId() {
        return userId;
    }

    /**
     * userId을 설정
     * 
     * @param userId을(를) String userId로 설정
     */
    public void setUserId(String userId) {
        this.userId = userId;
    }

    /**
     * String userNm을 반환
     * 
     * @return String userNm
     */
    public String getUserNm() {
        return userNm;
    }

    /**
     * userNm을 설정
     * 
     * @param userNm을(를) String userNm로 설정
     */
    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }

    /**
     * String nickNm을 반환
     * 
     * @return String nickNm
     */
    public String getNickNm() {
        return nickNm;
    }

    /**
     * nickNm을 설정
     * 
     * @param nickNm을(를) String nickNm로 설정
     */
    public void setNickNm(String nickNm) {
        this.nickNm = nickNm;
    }
}
