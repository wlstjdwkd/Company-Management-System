/*
 * Copyright (c) 2012 ZES Inc. All rights reserved.
 * This software is the confidential and proprietary information of ZES Inc.
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with ZES Inc. (http://www.zesinc.co.kr/)
 */
package egovframework.board.config;

import java.util.List;

import egovframework.board.temp.BoardTempVO;

public interface BoardConfService {

    /**
     * 게시판 목록 조회
     */
	List<BoardConfVO> boardConfList(BoardConfVO boardConfVO) throws Exception;
	
	/**
	 * 게시판 목록 카운트
	 */
	int boardConfListCount(BoardConfVO boardConfVO) throws Exception;
	
    /**
     * 게시판 상세 조회
     */
    BoardConfVO boardConfView(BoardConfVO boardConfVO) throws Exception;

    /**
     * 게시판 전체항목 목록
     */
    List<BoardArrangeVO> boardColumnList(Integer bbsCd) throws Exception;

    /**
     * 게시판 표시항목 목록
     */
    List<BoardArrangeVO> boardDisplayColumnList(BoardArrangeVO boardArrangeVO) throws Exception;

    /**
     * 게시판 확장관리 목록
     */
    List<BoardExtensionVO> boardConfExtList(Integer bbsCd) throws Exception;

    /**
     * 게시판 템플릿 목록
     */
    List<BoardTempVO> boardTemplateList(String type) throws Exception;

    /**
     * 게시판 생성시 확장 기능 등록 정보
     */
    int updateExtAction(List<BoardExtensionVO> extList, int bbsCd) throws Exception;

    /**
     * 게시판 등록 액션
     */
    Object insertAction(BoardConfVO boardConfVO) throws Exception;

    /**
     * 게시판 수정 액션
     */
    int updateAction(BoardConfVO boardConfVO) throws Exception;

    /**
     * 게시판 목록/상세 배치 수정 액션
     */
    int arrangeUpdateAction(BoardArrangeVO boardArrangeVO) throws Exception;

    /**
     * 게시판 칼럼별 사용여부 수정 액션
     */
    int updateAction(BoardConfYnVO boardConfYnVO);

    /**
     * 게시판 삭제 액션
     * 현재 SeniorBbs사용 설정됨.
     * 사이트마다 참조하고 있는 게시판으로 바꿔줘야 합니다.
     *//*
    int deleteAction(String[] bbsCds);

    *//**
     * 게시판 삭제 액션
     *//*
    Integer boardConfDelete(BoardConfVO boardConfVO);

    *//**
     * 게시판 목록 삭제 액션
     */
    Integer deleteBoardConf(BoardConfVO boardConfVO);

    /**
     * 게시판 복사 액션
     *//*
    Object copyAction(String oldBbsCd, String newBbsNm, String newBbsDesc);

    *//**
     * 게시판 확장 설정 복사
     *//*
    int extCopyAction(Integer oldBbsCd);

    *//**
     * 게시판 설정 정보를 리로드 합니다.
     *//*
    void reloadBbsCache();*/
}
