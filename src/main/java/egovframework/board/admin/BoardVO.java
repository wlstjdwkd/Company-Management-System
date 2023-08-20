/*
 * Copyright (c) 2012 ZES Inc. All rights reserved.
 * This software is the confidential and proprietary information of ZES Inc.
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with ZES Inc. (http://www.zesinc.co.kr/)
 */
package egovframework.board.admin;

import java.util.List;
import com.infra.file.FileVO;

public class BoardVO{

    private static final long serialVersionUID = 4899680125294621540L;

    /** 게시판 코드 */
    private Integer bbsCd = 0;
    /** 일련번호 */
    private String seq;
    /** 참조번호 */
    private String refSeq;
    /** 댓글순서 */
    private Integer orderNo = 0;
    /** 댓글레벨 */
    private Integer depth = 0;
    /** 분류코드 */
    private Integer ctgCd = -1;
    /** 공지확인 */
    private String noticeYn = "N";
    /** 제목 */    
    private String title;
    /** 제목바이트 길이 */
    private String titleLength;
    /** 자를 글자수 */
    private Integer cutTitleNum;
    /** 내용 */
    /*@Required(message = "내용은 필수 입력입니다.")
    @MinLength(min = 10)*/
    private String contents;
    /** 내용요약 */
    private String summary;
    /** 답변내용 */
    private String replyContents;
    /** 답변일 */
    private String replyDt;
    /** 파일순번 */
    private Integer fileSeq = -1;
    /** 답변파일순번 */
    private Integer ansFileSeq = -1;    
    /** 조회수 */
    private Integer readCnt = 0;
    /** 평점수 */
    private Integer scoreCnt = 0;
    /** 평점합 */
    private Integer scoreSum = 0;
    /** 신고수 */
    private Integer accuseCnt = 0;
    /** 추천수 */
    private Integer recomCnt = 0;
    /** 접속 IP */
    private String ipAddr;
    /** 에이전트 */
    private String agent;
    /** 공개 여부 */
    private String openYn = "Y";
    /** 사용 금지 여부 */
    private String banYn = "N";
    /** 사용자인증키(로그인 사용자의 글만 보여줄 때 사용) */
    private String userKey;
    /** 글비밀번호 */
    private String regPwd;
    /** 등록자명 */
    /*@Required(message = "작성자는 필수 입력입니다.")
    @RangeLength(min = 2, max = 10)*/
    private String regNm;
    /** 휴대전화 */
    private String cellPhone;
    /** 이메일 */
    private String emailAddr;
    /** 등록자ID */
    private String regId;
    /** 등록일 */
    private String regDt;
    /** 수정자ID */
    private String modId;
    /** 수정일 */
    private String modDt;
    /** 담당자ID */
    private String mgrId;
    /** 담당자명 */
    private String mgrNm;
    /** 부서코드 */
    private String deptCd;
    /** 부서명 */
    private String deptNm;

    /** 게시판명 */
    private String bbsNm;
    /** 분류명 */
    private String ctgNm;
    /** 유저 이름 */
    private String userNm;
    /** 유저 닉네임 */
    private String nickNm;
    /** 수정자명 */
    private String modNm;

    /** 요약 보여주기여부 */
    private String showSummaryYn = "N";
    /** 목록 보기 타입 */
    private String listShowType = "webzine";

    /** 일련번호 목록 */
    private String[] seqs;
    /** 첨부파일 목록 */
    private List<FileVO> fileList;
    /** 답변 첨부파일 목록 */
    private List<FileVO> ansFileList;
    /** 체크된 첨부파일 목록 (수정 시) */
    private String[] fileIds;
    /** 태그 사용 */
    private String[] bbsTags;
    /** 커멘트 목록 */
    private List<BoardCmtVO> commentList;
    /** 코멘트 일련번호 */
    private String cmtSeq;
    /** 첨부파일 경로 */
    private String filePath;
    /** 첨부파일 수 */
    private Integer fileCnt = 0;
    /** 답변 첨부파일 수 */
    private Integer ansFileCnt = 0;
    /** 커멘트 수 */
    private Integer commentCnt = 0;

    /** 게시판 이전글 */
    private BoardVO prevVO;
    /** 게시판 다음글 */
    private BoardVO nextVO;

    /** 게시물 삭제일 */
    private String delDt;
    /** 게시물 삭제이유 */
    private String delDesc;
    /** 삭제 일련번호 */
    private Integer delSeq;

    /** 확장컬럼1 */
    private String extColumn1;
    /** 확장컬럼2 */
    private String extColumn2;
    /** 확장컬럼3 */
    private String extColumn3;
    /** 확장컬럼4 */
    private String extColumn4;
    /** 확장컬럼5 */
    private String extColumn5;
    /** 확장컬럼6 */
    private String extColumn6;
    /** 확장컬럼7 */
    private String extColumn7;
    /** 확장컬럼8 */
    private String extColumn8;
    /** 확장컬럼9 */
    private String extColumn9;
    /** 확장컬럼10 */
    private String extColumn10;

    /** 관리자삭제여부 */
    private String mgrDelYn;
    /** 이동한게시판코드 */
    private String moveBbsCd;
    /** 이동한게시판명 */
    private String moveBbsNm;

    /** 등록경과일 */
    private Integer passDay;

    /** 검색 - 분류코드 */
    private String q_ctgCd;
    
    /** 검색 - 데이터 요청,처리일 */
    private String q_dateType;
    private String q_pjtStartDt;
    private String q_pjtEndDt;
    
    private String q_sttsType;
    
	/** 검색 - 시작일 */
    private String q_startDt;

	/** 검색 - 종료일 */
    private String q_endDt;
    
    /** 검색 - 항목+타입 */
    private String q_searchKeyType;

    /** 메인화면 최근게시물용 **/
    private String domainDesc;
    private String domainCd;
    private String domainNm;
    private String hostNm;
    
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
	private int df_row_per_page;
	private int limitFrom;
	private int limitTo;
	
	private String excludeOpenN;
    
    /**
     * bbsBean 객체 복사하기(검색에 필요한 필드만 복사한다.)
     */
    public BoardVO copyCreateVO() {
        BoardVO newBean = new BoardVO();
        newBean.setBbsCd(this.getBbsCd());
        newBean.setSeq(this.getSeq());
        newBean.setRefSeq(this.getRefSeq());
        newBean.setOrderNo(this.getOrderNo());
        newBean.setDepth(this.getDepth());
        return newBean;
    }

    /**
     * Integer bbsCd을(를) 반환
     * 
     * @return Integer bbsCd
     */
    public Integer getBbsCd() {
        return bbsCd;
    }

    /**
     * bbsCd을(를) 설정
     * 
     * @param bbsCd을(를) Integer bbsCd로 설정
     */
    public void setBbsCd(Integer bbsCd) {
        this.bbsCd = bbsCd;
    }

    /**
     * String seq을(를) 반환
     * 
     * @return String seq
     */
    public String getSeq() {
        return seq;
    }

    /**
     * seq을(를) 설정
     * 
     * @param seq을(를) String seq로 설정
     */
    public void setSeq(String seq) {
        this.seq = seq;
    }

    /**
     * String refSeq을(를) 반환
     * 
     * @return String refSeq
     */
    public String getRefSeq() {
        return refSeq;
    }

    /**
     * refSeq을(를) 설정
     * 
     * @param refSeq을(를) String refSeq로 설정
     */
    public void setRefSeq(String refSeq) {
        this.refSeq = refSeq;
    }

    /**
     * Integer orderNo을(를) 반환
     * 
     * @return Integer orderNo
     */
    public Integer getOrderNo() {
        return orderNo;
    }

    /**
     * orderNo을(를) 설정
     * 
     * @param orderNo을(를) Integer orderNo로 설정
     */
    public void setOrderNo(Integer orderNo) {
        this.orderNo = orderNo;
    }

    /**
     * Integer depth을(를) 반환
     * 
     * @return Integer depth
     */
    public Integer getDepth() {
        return depth;
    }

    /**
     * depth을(를) 설정
     * 
     * @param depth을(를) Integer depth로 설정
     */
    public void setDepth(Integer depth) {
        this.depth = depth;
    }

    /**
     * Integer ctgCd을(를) 반환
     * 
     * @return Integer ctgCd
     */
    public Integer getCtgCd() {
        return ctgCd;
    }

    /**
     * ctgCd을(를) 설정
     * 
     * @paramctgCd을(를) Integer ctgCd로 설정
     */
    public void setCtgCd(Integer ctgCd) {
        this.ctgCd = ctgCd;
    }

    /**
     * String noticeYn을(를) 반환
     * 
     * @return String noticeYn
     */
    public String getNoticeYn() {
        return noticeYn;
    }

    /**
     * noticeYn을(를) 설정
     * 
     * @param noticeYn을(를) String noticeYn로 설정
     */
    public void setNoticeYn(String noticeYn) {
        this.noticeYn = noticeYn;
    }

    /**
     * String title을(를) 반환
     * 
     * @return String title
     */
    public String getTitle() {
        return title;
    }

    /**
     * title을(를) 설정
     * 
     * @param title을(를) String title로 설정
     */
    public void setTitle(String title) {
        this.title = title;
    }

    /**
     * String titleLength을(를) 반환
     * 
     * @return String titleLength
     */
    public String getTitleLength() {
        return titleLength;
    }

    /**
     * titleLength을(를) 설정
     * 
     * @param titleLength을(를) String titleLength로 설정
     */
    public void setTitleLength(String titleLength) {
        this.titleLength = titleLength;
    }

    /**
     * Integer cutTitleNum을(를) 반환
     * 
     * @return Integer cutTitleNum
     */
    public Integer getCutTitleNum() {
        return cutTitleNum;
    }

    /**
     * cutTitleNum을(를) 설정
     * 
     * @param cutTitleNum을(를) Integer cutTitleNum로 설정
     */
    public void setCutTitleNum(Integer cutTitleNum) {
        this.cutTitleNum = cutTitleNum;
    }

    /**
     * String contents을(를) 반환
     * 
     * @return String contents
     */
    public String getContents() {
        return contents;
    }

    /**
     * contents을(를) 설정
     * 
     * @param contents을(를) String contents로 설정
     */
    public void setContents(String contents) {
        this.contents = contents;
    }

    /**
     * String summary을(를) 반환
     * 
     * @return String summary
     */
    public String getSummary() {
        return summary;
    }

    /**
     * summary을(를) 설정
     * 
     * @param summary을(를) String summary로 설정
     */
    public void setSummary(String summary) {
        this.summary = summary;
    }

    /**
     * String replyContents을(를) 반환
     * 
     * @return String replyContents
     */
    public String getReplyContents() {
        return replyContents;
    }

    /**
     * replyContents을(를) 설정
     * 
     * @param replyContents을(를) String replyContents로 설정
     */
    public void setReplyContents(String replyContents) {
        this.replyContents = replyContents;
    }

    /**
     * String replyDt을(를) 반환
     * 
     * @return String replyDt
     */
    public String getReplyDt() {
        return replyDt;
    }

    /**
     * replyDt을(를) 설정
     * 
     * @param replyDt을(를) String replyDt로 설정
     */
    public void setReplyDt(String replyDt) {
        this.replyDt = replyDt;
    }

    /**
     * Integer fileSeq을(를) 반환
     * 
     * @return Integer fileSeq
     */
    public Integer getFileSeq() {
        return fileSeq;
    }

    /**
     * fileSeq을(를) 설정
     * 
     * @param fileSeq을(를) Integer fileSeq로 설정
     */
    public void setFileSeq(Integer fileSeq) {
        this.fileSeq = fileSeq;
    }
            
    public Integer getAnsFileSeq() {
		return ansFileSeq;
	}

	public void setAnsFileSeq(Integer ansFileSeq) {
		this.ansFileSeq = ansFileSeq;
	}

	/**
     * Integer readCnt을(를) 반환
     * 
     * @return Integer readCnt
     */
    public Integer getReadCnt() {
        return readCnt;
    }

    /**
     * readCnt을(를) 설정
     * 
     * @param readCnt을(를) Integer readCnt로 설정
     */
    public void setReadCnt(Integer readCnt) {
        this.readCnt = readCnt;
    }

    /**
     * Integer scoreCnt을(를) 반환
     * 
     * @return Integer scoreCnt
     */
    public Integer getScoreCnt() {
        return scoreCnt;
    }

    /**
     * scoreCnt을(를) 설정
     * 
     * @param scoreCnt을(를) Integer scoreCnt로 설정
     */
    public void setScoreCnt(Integer scoreCnt) {
        this.scoreCnt = scoreCnt;
    }

    /**
     * Integer scoreSum을(를) 반환
     * 
     * @return Integer scoreSum
     */
    public Integer getScoreSum() {
        return scoreSum;
    }

    /**
     * scoreSum을(를) 설정
     * 
     * @param scoreSum을(를) Integer scoreSum로 설정
     */
    public void setScoreSum(Integer scoreSum) {
        this.scoreSum = scoreSum;
    }

    /**
     * String scoreAvg을(를) 반환
     * 
     * @return String scoreAvg
     */
    public String getScoreAvg() {
        if(this.scoreCnt == 0) {
            return "0.0점, (0점/0회)";
        } else {
            Float avg = Float.valueOf(this.scoreSum) / Float.valueOf(this.scoreCnt);
            return String.format("%.1f", avg) + "점, (" + this.scoreSum + "점/" + this.scoreCnt + "회)";
        }
    }

    public void setScoreAvg(String scoreAvg) {
    }

    /**
     * Integer accuseCnt을(를) 반환
     * 
     * @return Integer accuseCnt
     */
    public Integer getAccuseCnt() {
        return accuseCnt;
    }

    /**
     * accuseCnt을(를) 설정
     * 
     * @param accuseCnt을(를) Integer accuseCnt로 설정
     */
    public void setAccuseCnt(Integer accuseCnt) {
        this.accuseCnt = accuseCnt;
    }

    /**
     * Integer recomCnt을(를) 반환
     * 
     * @return Integer recomCnt
     */
    public Integer getRecomCnt() {
        return recomCnt;
    }

    /**
     * recomCnt을(를) 설정
     * 
     * @param recomCnt을(를) Integer recomCnt로 설정
     */
    public void setRecomCnt(Integer recomCnt) {
        this.recomCnt = recomCnt;
    }

    /**
     * String ipAddr을(를) 반환
     * 
     * @return String ipAddr
     */
    public String getIpAddr() {
        return ipAddr;
    }

    /**
     * ipAddr을(를) 설정
     * 
     * @param ipAddr을(를) String ipAddr로 설정
     */
    public void setIpAddr(String ipAddr) {
        this.ipAddr = ipAddr;
    }

    /**
     * String agent을(를) 반환
     * 
     * @return String agent
     */
    public String getAgent() {
        return agent;
    }

    /**
     * agent을(를) 설정
     * 
     * @param agent을(를) String agent로 설정
     */
    public void setAgent(String agent) {
        this.agent = agent;
    }

    /**
     * String openYn을(를) 반환
     * 
     * @return String openYn
     */
    public String getOpenYn() {
        return openYn;
    }

    /**
     * openYn을(를) 설정
     * 
     * @param qopenYn을(를) String openYn로 설정
     */
    public void setOpenYn(String openYn) {
        this.openYn = openYn;
    }

    /**
     * String banYn을(를) 반환
     * 
     * @return String banYn
     */
    public String getBanYn() {
        return banYn;
    }

    /**
     * banYn을(를) 설정
     * 
     * @param banYn을(를) String banYn로 설정
     */
    public void setBanYn(String banYn) {
        this.banYn = banYn;
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
     * String regPwd을(를) 반환
     * 
     * @return String regPwd
     */
    public String getRegPwd() {
        return regPwd;
    }

    /**
     * regPwd을(를) 설정
     * 
     * @param regPwd을(를) String regPwd로 설정
     */
    public void setRegPwd(String regPwd) {
        this.regPwd = regPwd;
    }

    /**
     * String regNm을(를) 반환
     * 
     * @return String regNm
     */
    public String getRegNm() {
        return regNm;
    }

    /**
     * regNm을(를) 설정
     * 
     * @param regNm을(를) String regNm로 설정
     */
    public void setRegNm(String regNm) {
        this.regNm = regNm;
    }

    /**
     * String regId을(를) 반환
     * 
     * @return String regId
     */
    public String getRegId() {
        return regId;
    }

    /**
     * regId을(를) 설정
     * 
     * @param regId을(를) String regId로 설정
     */
    public void setRegId(String regId) {
        this.regId = regId;
    }

    /**
     * String regDt을(를) 반환
     * 
     * @return String regDt
     */
    public String getRegDt() {
        return regDt;
    }

    /**
     * regDt을(를) 설정
     * 
     * @param regDt을(를) String regDt로 설정
     */
    public void setRegDt(String regDt) {
        this.regDt = regDt;
    }

    /**
     * String modId을(를) 반환
     * 
     * @return String modId
     */
    public String getModId() {
        return modId;
    }

    /**
     * modId을(를) 설정
     * 
     * @param modId을(를) String modId로 설정
     */
    public void setModId(String modId) {
        this.modId = modId;
    }

    /**
     * String modDt을(를) 반환
     * 
     * @return String modDt
     */
    public String getModDt() {
        return modDt;
    }

    /**
     * modDt을(를) 설정
     * 
     * @param v을(를) String modDt로 설정
     */
    public void setModDt(String modDt) {
        this.modDt = modDt;
    }

    /**
     * String mgrId을(를) 반환
     * 
     * @return String mgrId
     */
    public String getMgrId() {
        return mgrId;
    }

    /**
     * mgrId을(를) 설정
     * 
     * @param mgrId을(를) String mgrId로 설정
     */
    public void setMgrId(String mgrId) {
        this.mgrId = mgrId;
    }

    /**
     * String mgrNm을(를) 반환
     * 
     * @return String mgrNm
     */
    public String getMgrNm() {
        return mgrNm;
    }

    /**
     * mgrNm을(를) 설정
     * 
     * @param mgrNm을(를) String mgrNm로 설정
     */
    public void setMgrNm(String mgrNm) {
        this.mgrNm = mgrNm;
    }

    /**
     * String deptCd을(를) 반환
     * 
     * @return String deptCd
     */
    public String getDeptCd() {
        return deptCd;
    }

    /**
     * deptCd을(를) 설정
     * 
     * @param deptCd을(를) String deptCd로 설정
     */
    public void setDeptCd(String deptCd) {
        this.deptCd = deptCd;
    }

    /**
     * String deptNm을(를) 반환
     * 
     * @return String deptNm
     */
    public String getDeptNm() {
        return deptNm;
    }

    /**
     * deptNm을(를) 설정
     * 
     * @param deptNm을(를) String deptNm로 설정
     */
    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }

    /**
     * String bbsNm을(를) 반환
     * 
     * @return String bbsNm
     */
    public String getBbsNm() {
        return bbsNm;
    }

    /**
     * bbsNm을(를) 설정
     * 
     * @param bbsNm을(를) String bbsNm로 설정
     */
    public void setBbsNm(String bbsNm) {
        this.bbsNm = bbsNm;
    }

    /**
     * String ctgNm을(를) 반환
     * 
     * @return String ctgNm
     */
    public String getCtgNm() {
        return ctgNm;
    }

    /**
     * ctgNm을(를) 설정
     * 
     * @param ctgNm을(를) String ctgNm로 설정
     */
    public void setCtgNm(String ctgNm) {
        this.ctgNm = ctgNm;
    }

    /**
     * String userNm을(를) 반환
     * 
     * @return String userNm
     */
    public String getUserNm() {
        return userNm;
    }

    /**
     * userNm을(를) 설정
     * 
     * @param userNm을(를) String userNm로 설정
     */
    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }

    /**
     * String nickNm을(를) 반환
     * 
     * @return String nickNm
     */
    public String getNickNm() {
        return nickNm;
    }

    /**
     * nickNm을(를) 설정
     * 
     * @param nickNm을(를) String nickNm로 설정
     */
    public void setNickNm(String nickNm) {
        this.nickNm = nickNm;
    }

    /**
     * String modNm을(를) 반환
     * 
     * @return String modNm
     */
    public String getModNm() {
        return modNm;
    }

    /**
     * modNm을(를) 설정
     * 
     * @param modNm을(를) String modNm로 설정
     */
    public void setModNm(String modNm) {
        this.modNm = modNm;
    }

    /**
     * String showSummaryYn을(를) 반환
     * 
     * @return String showSummaryYn
     */
    public String getShowSummaryYn() {
        return showSummaryYn;
    }

    /**
     * q_ctgCd을(를) 설정
     * 
     * @param showSummaryYn을(를) String showSummaryYn로 설정
     */
    public void setShowSummaryYn(String showSummaryYn) {
        this.showSummaryYn = showSummaryYn;
    }

    /**
     * String listShowType을(를) 반환
     * 
     * @return String listShowType
     */
    public String getListShowType() {
        return listShowType;
    }

    /**
     * listShowType을(를) 설정
     * 
     * @param listShowType을(를) String listShowType로 설정
     */
    public void setListShowType(String listShowType) {
        this.listShowType = listShowType;
    }

    /**
     * String[] seqs을(를) 반환
     * 
     * @return String[] seqs
     */
    public String[] getSeqs() {
        return seqs;
    }

    /**
     * seqs을 설정
     * 
     * @param seqs을(를) String[] seqs로 설정
     */
    public void setSeqs(String[] seqs) {
        this.seqs = seqs;
    }

    /**
     * List<FileVO> fileList을(를) 반환
     * 
     * @return List<FileVO> fileList
     */
    public List<FileVO> getFileList() {
        return fileList;
    }

    /**
     * fileList을(를) 설정
     * 
     * @param fileList을(를) List<FileVO> fileList로 설정
     */
    public void setFileList(List<FileVO> fileList) {
        this.fileList = fileList;
    }

    public List<FileVO> getAnsFileList() {
		return ansFileList;
	}

	public void setAnsFileList(List<FileVO> ansFileList) {
		this.ansFileList = ansFileList;
	}

	/**
     * String[] fileIds을(를) 반환
     * 
     * @return String[] fileIds
     */
    public String[] getFileIds() {
        return fileIds;
    }

    /**
     * fileIds을(를) 설정
     * 
     * @param fileIds을(를) String[] fileIds로 설정
     */
    public void setFileIds(String[] fileIds) {
        this.fileIds = fileIds;
    }

    /**
     * String[] tagsBbs을(를) 반환
     * 
     * @return String[] tagsBbs
     */
    /*
     * public String[] getTags_bbs(){
     * return tags_bbs;
     * }
     */
    /**
     * tagsBbs을(를) 설정
     * 
     * @param tagsBbs을(를) String[] tagsBbs로 설정
     */
    /*
     * public void setTags_bbs(String[] tagsBbs){
     * tags_bbs = tagsBbs;
     * }
     */

    /**
     * String bbsTags을(를) 반환
     * 
     * @return String bbsTags
     */
    public String[] getBbsTags() {
        /*
         * String str = "";
         * if(Validate.isEmpty(this.tags_bbs)){
         * return str;
         * }
         * for(int i=0; i<this.tags_bbs.length; i++){
         * if(i == (this.tags_bbs.length - 1)){
         * str += this.tags_bbs[i];
         * }else{
         * str += (this.tags_bbs[i] + ", ");
         * }
         * }
         * return str;
         */
        return bbsTags;
    }

    public void setBbsTags(String[] bbsTags) {
        this.bbsTags = bbsTags;
    }

    /**
     * List<BoardCmtVO> commentList을(를) 반환
     * 
     * @return List<BoardCmtVO> commentList
     */
    public List<BoardCmtVO> getCommentList() {
        return commentList;
    }

    /**
     * commentList을(를) 설정
     * 
     * @param commentList을(를) List<BoardCmtVO> commentList로 설정
     */
    public void setCommentList(List<BoardCmtVO> commentList) {
        this.commentList = commentList;
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
     * Integer fileCnt을(를) 반환
     * 
     * @return Integer fileCnt
     */
    public Integer getFileCnt() {
        return fileCnt;
    }

    /**
     * fileCnt을(를) 설정
     * 
     * @param fileCnt을(를) Integer fileCnt로 설정
     */
    public void setFileCnt(Integer fileCnt) {
        this.fileCnt = fileCnt;
    }    

    public Integer getAnsFileCnt() {
		return ansFileCnt;
	}

	public void setAnsFileCnt(Integer ansFileCnt) {
		this.ansFileCnt = ansFileCnt;
	}

	/**
     * Integer commentCnt을(를) 반환
     * 
     * @return Integer commentCnt
     */
    public Integer getCommentCnt() {
        return commentCnt;
    }

    /**
     * commentCnt을(를) 설정
     * 
     * @param commentCnt을(를) Integer commentCnt로 설정
     */
    public void setCommentCnt(Integer commentCnt) {
        this.commentCnt = commentCnt;
    }

    /**
     * BoardVO prevVO을(를) 반환
     * 
     * @return BoardVO prevVO
     */
    public BoardVO getPrevVO() {
        return prevVO;
    }

    /**
     * q_ctgCd을(를) 설정
     * 
     * @param prevVO을(를) BoardVO prevVO로 설정
     */
    public void setPrevVO(BoardVO prevVO) {
        this.prevVO = prevVO;
    }

    /**
     * BoardVO nextVO을(를) 반환
     * 
     * @return BoardVO nextVO
     */
    public BoardVO getNextVO() {
        return nextVO;
    }

    /**
     * nextVO을(를) 설정
     * 
     * @param nextVO을(를) BoardVO nextVO로 설정
     */
    public void setNextVO(BoardVO nextVO) {
        this.nextVO = nextVO;
    }

    /**
     * String delDt을(를) 반환
     * 
     * @return String delDt
     */
    public String getDelDt() {
        return delDt;
    }

    /**
     * delDt을(를) 설정
     * 
     * @param delDt을(를) String delDt로 설정
     */
    public void setDelDt(String delDt) {
        this.delDt = delDt;
    }

    /**
     * String delDesc을(를) 반환
     * 
     * @return String delDesc
     */
    public String getDelDesc() {
        return delDesc;
    }

    /**
     * delDesc을(를) 설정
     * 
     * @param delDesc을(를) String delDesc로 설정
     */
    public void setDelDesc(String delDesc) {
        this.delDesc = delDesc;
    }

    /**
     * Integer delSeq을(를) 반환
     * 
     * @return Integer delSeq
     */
    public Integer getDelSeq() {
        return delSeq;
    }

    /**
     * delSeq을(를) 설정
     * 
     * @param delSeq을(를) Integer delSeq로 설정
     */
    public void setDelSeq(Integer delSeq) {
        this.delSeq = delSeq;
    }

    /**
     * String extColumn1을(를) 반환
     * 
     * @return String extColumn1
     */
    public String getExtColumn1() {
        return extColumn1;
    }

    /**
     * extColumn1을(를) 설정
     * 
     * @param qextColumn1을(를) String extColumn1로 설정
     */
    public void setExtColumn1(String extColumn1) {
        this.extColumn1 = extColumn1;
    }

    /**
     * String extColumn2을(를) 반환
     * 
     * @return String extColumn2
     */
    public String getExtColumn2() {
        return extColumn2;
    }

    /**
     * extColumn2을(를) 설정
     * 
     * @param extColumn2을(를) String extColumn2로 설정
     */
    public void setExtColumn2(String extColumn2) {
        this.extColumn2 = extColumn2;
    }

    /**
     * String extColumn3을(를) 반환
     * 
     * @return String extColumn3
     */
    public String getExtColumn3() {
        return extColumn3;
    }

    /**
     * extColumn3을(를) 설정
     * 
     * @param extColumn3을(를) String extColumn3로 설정
     */
    public void setExtColumn3(String extColumn3) {
        this.extColumn3 = extColumn3;
    }

    /**
     * String extColumn4을(를) 반환
     * 
     * @return String extColumn4
     */
    public String getExtColumn4() {
        return extColumn4;
    }

    /**
     * extColumn4을(를) 설정
     * 
     * @param extColumn4을(를) String extColumn4로 설정
     */
    public void setExtColumn4(String extColumn4) {
        this.extColumn4 = extColumn4;
    }

    /**
     * String extColumn5을(를) 반환
     * 
     * @return String extColumn5
     */
    public String getExtColumn5() {
        return extColumn5;
    }

    /**
     * extColumn5을(를) 설정
     * 
     * @param extColumn5을(를) String extColumn5로 설정
     */
    public void setExtColumn5(String extColumn5) {
        this.extColumn5 = extColumn5;
    }

    /**
     * String extColumn6을(를) 반환
     * 
     * @return String extColumn6
     */
    public String getExtColumn6() {
        return extColumn6;
    }

    /**
     * extColumn6을(를) 설정
     * 
     * @param extColumn6을(를) String extColumn6로 설정
     */
    public void setExtColumn6(String extColumn6) {
        this.extColumn6 = extColumn6;
    }

    /**
     * String extColumn7을(를) 반환
     * 
     * @return String extColumn7
     */
    public String getExtColumn7() {
        return extColumn7;
    }

    /**
     * extColumn7을(를) 설정
     * 
     * @param extColumn7을(를) String extColumn7로 설정
     */
    public void setExtColumn7(String extColumn7) {
        this.extColumn7 = extColumn7;
    }

    /**
     * String extColumn8을(를) 반환
     * 
     * @return String extColumn8
     */
    public String getExtColumn8() {
        return extColumn8;
    }

    /**
     * extColumn8을(를) 설정
     * 
     * @param extColumn8을(를) String extColumn8로 설정
     */
    public void setExtColumn8(String extColumn8) {
        this.extColumn8 = extColumn8;
    }

    /**
     * String extColumn9을(를) 반환
     * 
     * @return String extColumn9
     */
    public String getExtColumn9() {
        return extColumn9;
    }

    /**
     * extColumn9을(를) 설정
     * 
     * @param extColumn9을(를) String extColumn9로 설정
     */
    public void setExtColumn9(String extColumn9) {
        this.extColumn9 = extColumn9;
    }

    /**
     * String extColumn10을(를) 반환
     * 
     * @return String extColumn10
     */
    public String getExtColumn10() {
        return extColumn10;
    }

    /**
     * extColumn10을(를) 설정
     * 
     * @param extColumn10을(를) String extColumn10로 설정
     */
    public void setExtColumn10(String extColumn10) {
        this.extColumn10 = extColumn10;
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
     * String moveBbsCd을(를) 반환
     * 
     * @return String moveBbsCd
     */
    public String getMoveBbsCd() {
        return moveBbsCd;
    }

    /**
     * moveBbsCd을(를) 설정
     * 
     * @param moveBbsCd을(를) String moveBbsCd로 설정
     */
    public void setMoveBbsCd(String moveBbsCd) {
        this.moveBbsCd = moveBbsCd;
    }

    /**
     * String moveBbsNm을(를) 반환
     * 
     * @return String moveBbsNm
     */
    public String getMoveBbsNm() {
        return moveBbsNm;
    }

    /**
     * moveBbsNm을(를) 설정
     * 
     * @param moveBbsNm을(를) String moveBbsNm로 설정
     */
    public void setMoveBbsNm(String moveBbsNm) {
        this.moveBbsNm = moveBbsNm;
    }

    /**
     * Integer passDay을(를) 반환
     * 
     * @return Integer passDay
     */
    public Integer getPassDay() {
        return passDay;
    }

    /**
     * passDay을(를) 설정
     * 
     * @param passDay을(를) Integer passDay로 설정
     */
    public void setPassDay(Integer passDay) {
        this.passDay = passDay;
    }

    /**
     * String q_ctgCd을(를) 반환
     * 
     * @return String q_ctgCd
     */
    public String getQ_ctgCd() {
        return q_ctgCd;
    }

    /**
     * q_ctgCd을(를) 설정
     * 
     * @param q_ctgCd을(를) String q_ctgCd로 설정
     */
    public void setQ_ctgCd(String q_ctgCd) {
        this.q_ctgCd = q_ctgCd;
    }

    /**
     * String q_startDt을(를) 반환
     * 
     * @return String q_startDt
     */
    public String getQ_startDt() {
        return q_startDt;
    }

    /**
     * q_startDt을(를) 설정
     * 
     * @param q_startDt을(를) String q_startDt로 설정
     */
    public void setQ_startDt(String q_startDt) {
        this.q_startDt = q_startDt;
    }

    /**
     * String q_endDt을(를) 반환
     * 
     * @return String q_endDt
     */
    public String getQ_endDt() {
        return q_endDt;
    }

    /**
     * q_endDt(를) 설정
     * 
     * @param q_endDt을(를) String q_endDt로 설정
     */
    public void setQ_endDt(String q_endDt) {
        this.q_endDt = q_endDt;
    }

    /**
     * String q_searchKeyType을(를) 반환
     * 
     * @return String q_searchKeyType
     */
    public String getQ_searchKeyType() {
        return q_searchKeyType;
    }

    /**
     * q_searchKeyType(를) 설정
     * 
     * @param q_searchKeyType을(를) String q_searchKeyType로 설정
     */
    public void setQ_searchKeyType(String q_searchKeyType) {
        this.q_searchKeyType = q_searchKeyType;
    }
    
    /**
     * String filePath을 반환
     * @return String filePath
     */
    public String getFilePath() {
        return filePath;
    }
    
    /**
     * filePath을 설정
     * @param filePath 을(를) String filePath로 설정
     */
    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    /**
     * String domainDesc을 반환
     * @return String domainDesc
     */
    public String getDomainDesc() {
        return domainDesc;
    }

    /**
     * domainDesc을 설정
     * @param domainDesc 을(를) String domainDesc로 설정
     */
    public void setDomainDesc(String domainDesc) {
        this.domainDesc = domainDesc;
    }

    /**
     * String domainCd을 반환
     * @return String domainCd
     */
    public String getDomainCd() {
        return domainCd;
    }

    /**
     * domainCd을 설정
     * @param domainCd 을(를) String domainCd로 설정
     */
    public void setDomainCd(String domainCd) {
        this.domainCd = domainCd;
    }

    /**
     * String domainNm을 반환
     * @return String domainNm
     */
    public String getDomainNm() {
        return domainNm;
    }

    /**
     * domainNm을 설정
     * @param domainNm 을(를) String domainNm로 설정
     */
    public void setDomainNm(String domainNm) {
        this.domainNm = domainNm;
    }

    /**
     * String hostNm을 반환
     * @return String hostNm
     */
    public String getHostNm() {
        return hostNm;
    }

    /**
     * hostNm을 설정
     * @param hostNm 을(를) String hostNm로 설정
     */
    public void setHostNm(String hostNm) {
        this.hostNm = hostNm;
    }

	public Integer getQ_rowPerPage() {
		return q_rowPerPage;
	}

	public void setQ_rowPerPage(Integer q_rowPerPage) {
		this.q_rowPerPage = q_rowPerPage;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
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

	public int getLimitFrom() {
		return limitFrom;
	}

	public void setLimitFrom(int limitFrom) {
		this.limitFrom = limitFrom;
	}
	
	
	public int getQ_currPage() {
		return q_currPage;
	}

	public void setQ_currPage(int q_currPage) {
		this.q_currPage = q_currPage;
	}

	public int getLimitTo() {
		return limitTo;
	}

	public void setLimitTo(int limitTo) {
		this.limitTo = limitTo;
	}		
	
	public int getDf_row_per_page() {
		return df_row_per_page;
	}

	public void setDf_row_per_page(int df_row_per_page) {
		this.df_row_per_page = df_row_per_page;
	}

	public int getDf_curr_page() {
		return df_curr_page;
	}

	public void setDf_curr_page(int df_curr_page) {
		this.df_curr_page = df_curr_page;
	}

	public String getCellPhone() {
		return cellPhone;
	}

	public void setCellPhone(String cellPhone) {
		this.cellPhone = cellPhone;
	}

	public String getEmailAddr() {
		return emailAddr;
	}

	public void setEmailAddr(String emailAddr) {
		this.emailAddr = emailAddr;
	}
	
    public String getQ_dateType() {
		return q_dateType;
	}

	public void setQ_dateType(String q_dateType) {
		this.q_dateType = q_dateType;
	}

	public String getQ_pjtStartDt() {
		return q_pjtStartDt;
	}

	public void setQ_pjtStartDt(String q_pjtStartDt) {
		this.q_pjtStartDt = q_pjtStartDt;
	}

	public String getQ_pjtEndDt() {
		return q_pjtEndDt;
	}

	public void setQ_pjtEndDt(String q_pjtEndDt) {
		this.q_pjtEndDt = q_pjtEndDt;
	}

	public String getQ_sttsType() {
		return q_sttsType;
	}

	public void setQ_sttsType(String q_sttsType) {
		this.q_sttsType = q_sttsType;
	}

	public String getExcludeOpenN() {
		return excludeOpenN;
	}

	public void setExcludeOpenN(String excludeOpenN) {
		this.excludeOpenN = excludeOpenN;
	}
	
	
    
}
