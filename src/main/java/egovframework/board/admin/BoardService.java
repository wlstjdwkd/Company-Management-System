/*
 * Copyright (c) 2012 ZES Inc. All rights reserved.
 * This software is the confidential and proprietary information of ZES Inc.
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with ZES Inc. (http://www.zesinc.co.kr/)
 */
package egovframework.board.admin;

import java.util.HashMap;
import java.util.List;

import com.infra.file.FileVO;
import egovframework.board.config.BoardConfVO;

public interface BoardService {

    /**
     * 게시물 목록 조회
     */
    List<BoardVO> boardList(BoardVO boardVO, String listSkin);

    /**
     * 게시물 목록 전체 카운트
     */
    int boardListCount(BoardVO boardVO);
    
    /**
     * 게시물 목록 조회(컨버전 다운로드용)
     *//*
    List<BoardVO> boardAllList(BoardConvertOptionVO boardConvertOptionVO);

    *//**
     * 게시물 공지 목록 조회
     */
    List<BoardVO> noticeList(BoardVO boardVO, String listSkin);

    /**
     * 게시물 상세 조회
     */
    BoardVO boardView(BoardVO boardVO, BoardConfVO boardConfVO);

    /**
     * 게시물 상세 조회 카운트를 증가시킨다.
     */
    Object incReadCount(BoardVO boardVO);

    /**
     * 게시물 평가 액션
     *//*
    Object scoreAction(BoardVO boardVO);

    *//**
     * 게시물 추천 액션
     *//*
    Object recommAction(BoardVO boardVO);

    *//**
     * 게시물 신고 액션
     *//*
    Object accuseAction(BoardVO boardVO);

    *//**
     * 게시물 등록 액션
     * seq == 1부터 시작한다.
     * highBbsCd == 0이면 등록, 아니면 답글
     */
    Object boardInsert(BoardVO boardVO, BoardConfVO boardConfVO);

    /**
     * 민원형 게시물 답변등록
     */
    int boardAnswer(BoardVO boardVO);

    /**
     * 게시물 수정 액션
     */
    int boardUpdate(BoardVO boardVO);

    /**
     * 게시물 수정 액션
     *//*
    // int updateActionYn(BoardVO boardVO);

    *//**
     * 개별 파일 삭제 액션
     */
    int fileDelete(FileVO fileVO);

    /**
     * 게시물 삭제 액션
     */
    int boardDelete(BoardVO boardVO, boolean useTrash);

    /**
     * 게시물 삭제 액션(목록에서 여러개 삭제시)
     */
    int boardListDelete(BoardVO boardVO, boolean useTrash);

    /**
     * 게시물 플래그 삭제 액션
     *//*
    int boardFlagDelete(BoardVO boardVO);

    *//**
     * 게시물 플래그 삭제 액션(목록에서 여러개 삭제시)
     *//*
    int boardListFlagDelete(BoardVO boardVO);

    *//**
     * 덧글 목록 조회
     *//*
    List<BoardCmtVO> commentList(BoardCmtVO boardCmtVO);

    *//**
     * 덧글 등록 액션
     *//*
    Object insertComment(BoardCmtVO boardCmtVO);

    *//**
     * 덧글 상세 보기
     *//*
    BoardCmtVO viewComment(BoardCmtVO boardCmtVO);

    *//**
     * 덧글 수정 액션
     *//*
    Object updateComment(BoardCmtVO boardCmtVO);

    *//**
     * 덧글 삭제 액션
     *//*
    Object deleteComment(BoardCmtVO boardCmtVO);

    *//**
     * 덧글 플래그 삭제 액션
     *//*
    int cmtFlagDelete(BoardCmtVO boardCmtVO);

    *//**
     * 게시판 목록들(선택한 게시판이 아닌 다른 모든 게시판목록)
     *//*
    List<BoardConfVO> boardConfList(Integer bbsCd);

    *//**
     * 목록보기에서 게시물 복사 & 이동
     *//*
    Integer listTransfer(String bbsCd, Integer[] toBbsCds, String[] seqs, String isMove, Integer[] newCtg);

    *//**
     * 상세보기에서 게시물 복사 & 이동
     *//*
    Integer articleTransfer(String bbsCd, Integer toBbsCd, String seq, String isMove, Integer newCtg);

    *//**
     * 용량이 오버된 첨부파일을 삭제한다.
     */
    boolean fileDelete(List<FileVO> fileList);

    /**
     * 게시판에 대한 클라우드 태그 목록을 가져온다.
     *//*
    String tagCloud(Integer bbsCd);

    *//**
     * domainList 설명
     * @param boardVO
     * @return
     *//*
    @SuppressWarnings("rawtypes")
    List domainList(BoardVO boardVO);*/
    
    /**
     * 게시물 반복 등록 검사
     */
    boolean boardRepeatInsertCheck(BoardVO boardVO);
    
    /**
     * 게시물 댓글 반복 등록 검사
     */
    boolean boardAnswerRepeatInsertCheck(HashMap params);
    
    /**
     * 게시물 댓글 등록
     */
    Object boardAnswerInsert(HashMap params);
    
    /**
    * 게시물 댓글 목록 조회
    */
	List<HashMap> boardAnswerList(HashMap params);

   /**
    * 게시물 댓글 조회 갯수
    */
	int boardAnswerListCount(HashMap params);
	
	/**
     * 게시물 댓글 수정
     */
    public int boardAnswerSeqUpdate(HashMap params);
    
    /**
     * 게시물 댓글 삭제
     */
    public int boardAnswerSeqDelete(HashMap params);
}
