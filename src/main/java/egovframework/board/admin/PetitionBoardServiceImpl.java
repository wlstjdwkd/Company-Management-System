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

import javax.annotation.Resource;

import com.infra.file.FileDAO;
import com.infra.file.FileVO;

import org.springframework.stereotype.Service;

import egovframework.board.config.BoardConfVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


@Service("petitionBoardService")
public class PetitionBoardServiceImpl extends EgovAbstractServiceImpl implements BoardService {

    @Resource
    private BoardDao boardDao;

    @Resource
    private FileDAO fileDao;
    
    @Override
    public int boardListCount(BoardVO boardVO) {
    	return boardDao.boardListCount(boardVO);
    }
    
    /**
     * 게시물 목록 조회
     */
    @Override
    public List<BoardVO> boardList(BoardVO boardVO, String listSkin) {
        return boardDao.boardList(boardVO, listSkin);
    }

    /**
     * 게시물 목록 조회(컨버전 다운로드용)
     *//*
    @Override
    public Pager<BoardVO> boardAllList(BoardConvertOptionVO boardConvertOptionVO) {
        return boardDao.boardAllList(boardConvertOptionVO);
    }*/

    /**
     * 게시물 공지 목록 조회
     */
    @Override
    public List<BoardVO> noticeList(BoardVO boardVO, String listSkin) {
        return boardDao.noticeList(boardVO, listSkin);
    }

    /**
     * 게시물 상세 조회
     */
    @Override
    public BoardVO boardView(BoardVO boardVO, BoardConfVO boardConfVO) {
        return boardDao.boardView(boardVO, boardConfVO);
    }

    /**
     * 게시물 상세 조회 카운트를 증가시킨다.
     */
    @Override
    public Object incReadCount(BoardVO boardVO) {
        return boardDao.incReadCount(boardVO);
    }

    /**
     * 게시물 평가 액션
     *//*
    @Override
    public Object scoreAction(BoardVO boardVO) {
        return boardDao.scoreAction(boardVO);
    }

    *//**
     * 게시물 추천 액션
     *//*
    @Override
    public Object recommAction(BoardVO boardVO) {
        return boardDao.recommAction(boardVO);
    }

    *//**
     * 게시물 신고 액션
     *//*
    @Override
    public Object accuseAction(BoardVO boardVO) {
        return boardDao.accuseAction(boardVO);
    }*/

    /**
     * 게시물 등록 액션
     */
    @Override
    public Object boardInsert(BoardVO boardVO, BoardConfVO boardConfVO) {
        return boardDao.boardInsert(boardVO, boardConfVO);
    }

    /**
     * 민원형 게시물 답변등록
     */
    @Override
    public int boardAnswer(BoardVO boardVO) {
        return boardDao.boardAnswer(boardVO);
    }

    /**
     * 게시물 수정 액션
     */
    @Override
    public int boardUpdate(BoardVO boardVO) {
        return boardDao.boardUpdate(boardVO);
    }

    /**
     * 게시물 수정 액션
     */
    /*
     * @Override
     * public int updateActionYn(BoardVO boardVO){
     * return boardDao.updateActionYn(boardVO);
     * }
     */

    /**
     * 첨부파일 개별 삭제 액션
     */
    @Override
    public int fileDelete(FileVO fileVO) {
        int affected = fileDao.removeFile(fileVO.getFileSeq(), fileVO.getFileId());
        return affected;
    }

    /**
     * 게시물 삭제 액션
     */
    @Override
    public int boardDelete(BoardVO boardVO, boolean useTrash) {
        return boardDao.boardDelete(boardVO, boardVO.getDelDesc(), useTrash);
    }

    /**
     * 게시물 삭제 액션(목록에서 여러개 삭제시)
     */
    @Override
    public int boardListDelete(BoardVO boardVO, boolean useTrash) {
        return boardDao.boardListDelete(boardVO, boardVO.getDelDesc(), useTrash);
    }

    /**
     * 게시물 플래그 삭제 액션
     *//*
    @Override
    public int boardFlagDelete(BoardVO boardVO) {
        return boardDao.boardFlagDelete(boardVO);
    }

    *//**
     * 게시물 플래그 삭제 액션(목록에서 여러개 삭제시)
     *//*
    @Override
    public int boardListFlagDelete(BoardVO boardVO) {
        return boardDao.boardListFlagDelete(boardVO);
    }

    *//**
     * 덧글 목록 조회
     *//*
    @Override
    public Pager<BoardCmtVO> commentList(BoardCmtVO boardCmtVO) {
        return boardDao.commentList(boardCmtVO);
    }

    *//**
     * 덧글 등록 액션
     *//*
    @Override
    public Object insertComment(BoardCmtVO boardCmtVO) {
        return boardDao.insertComment(boardCmtVO);
    }

    *//**
     * 덧글 상세 보기
     *//*
    @Override
    public BoardCmtVO viewComment(BoardCmtVO boardCmtVO) {
        return boardDao.viewComment(boardCmtVO);
    }

    *//**
     * 덧글 수정 액션
     *//*
    @Override
    public Object updateComment(BoardCmtVO boardCmtVO) {
        return boardDao.updateComment(boardCmtVO);
    }

    *//**
     * 덧글 삭제 액션
     *//*
    @Override
    public Object deleteComment(BoardCmtVO boardCmtVO) {
        return boardDao.deleteComment(boardCmtVO);
    }

    *//**
     * 덧글 플래그 삭제 액션
     *//*
    @Override
    public int cmtFlagDelete(BoardCmtVO boardCmtVO) {
        return boardDao.cmtFlagDelete(boardCmtVO);
    }

    *//**
     * 게시판 목록들(선택한 게시판이 아닌 다른 모든 게시판목록)
     *//*
    @Override
    public List<BoardConfVO> boardConfList(Integer bbsCd) {
        return boardDao.boardConfList(bbsCd);
    }

    *//**
     * 목록보기에서 게시물 복사 & 이동
     *//*
    @Override
    public Integer listTransfer(String bbsCd, Integer[] toBbsCds, String[] seqs, String isMove, Integer[] newCtg) {
        return boardDao.listTransfer(bbsCd, toBbsCds, seqs, isMove, newCtg);
    }

    *//**
     * 상세보기에서 게시물 복사 & 이동
     *//*
    @Override
    public Integer articleTransfer(String bbsCd, Integer toBbsCd, String seq, String isMove, Integer newCtg) {
        return boardDao.articleTransfer(bbsCd, toBbsCd, seq, isMove, newCtg);
    }*/

    /**
     * 용량이 오버된 첨부파일을 삭제한다.
     */
    @Override
    public boolean fileDelete(List<FileVO> fileList) {
        return boardDao.fileDelete(fileList);
    }

    /**
     * 게시판에 대한 클라우드 태그 목록을 가져온다.
     *//*
    @Override
    public String tagCloud(Integer bbsCd) {
        return boardDao.tagCloud(bbsCd);
    }

    @SuppressWarnings("rawtypes")
    @Override
    public List domainList(BoardVO boardVO) {
        return boardDao.domainList(boardVO);
    }*/
    
    /**
     * 게시물 반복 등록 검사
     */
    @Override
    public boolean boardRepeatInsertCheck(BoardVO boardVO) {
        return boardDao.boardRepeatInsertCheck(boardVO);
    }
    
    /**
     * 게시물 댓글 반복 등록 검사
     */
    @Override
    public boolean boardAnswerRepeatInsertCheck(HashMap params) {
        return boardDao.boardAnswerRepeatInsertCheck(params);
    }
    
    /**
     * 게시물 댓글 등록
     */
    @Override
    public Object boardAnswerInsert(HashMap params) {
        return boardDao.boardAnswerInsert(params);
    }
    
    /**
     * 게시물 댓글 목록 조회
     */
    @Override
    public List<HashMap> boardAnswerList(HashMap params) {
        return boardDao.boardAnswerList(params);
    }
    
    @Override
    public int boardAnswerListCount(HashMap params) {    	
    	return boardDao.boardAnswerListCount(params);
    }
    
    /**
     * 게시물 댓글 수정
     */
    @Override
    public int boardAnswerSeqUpdate(HashMap params) {
        return boardDao.boardAnswerSeqUpdate(params);
    }
    
    /**
     * 게시물 댓글 삭제
     */
    @Override
    public int boardAnswerSeqDelete(HashMap params) {
        return boardDao.boardAnswerSeqDelete(params);
    }
}
