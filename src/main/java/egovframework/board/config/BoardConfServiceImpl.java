/*
 * Copyright (c) 2012 ZES Inc. All rights reserved.
 * This software is the confidential and proprietary information of ZES Inc.
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with ZES Inc. (http://www.zesinc.co.kr/)
 */
package egovframework.board.config;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.board.temp.BoardTempVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("boardConfService")
public class BoardConfServiceImpl extends EgovAbstractServiceImpl implements BoardConfService {

    @Resource
    private BoardConfDao boardConfDao;

    @Override
    public List<BoardConfVO> boardConfList(BoardConfVO boardConfVO) throws Exception {
    	return boardConfDao.boardConfList(boardConfVO);
    }
    
    @Override
    public int boardConfListCount(BoardConfVO boardConfVO) throws Exception {
    	return boardConfDao.boardConfListCount(boardConfVO);
    }
    
    @Override
    public List<BoardTempVO> boardTemplateList(String type) throws Exception {
    	return boardConfDao.boardTemplateList(type);
    }
    
    @Override
    public Object insertAction(BoardConfVO boardConfVO) throws Exception {
    	return boardConfDao.insertAction(boardConfVO);
    }
    
    @Override
    public BoardConfVO boardConfView(BoardConfVO boardConfVO) throws Exception {
    	return boardConfDao.boardConfView(boardConfVO);
    }
    
    @Override
    public List<BoardExtensionVO> boardConfExtList(Integer bbsCd) throws Exception {
    	return boardConfDao.boardConfExtList(bbsCd);
    }
    
    @Override
    public int updateAction(BoardConfVO boardConfVO) throws Exception {
        return boardConfDao.updateAction(boardConfVO);
    }
    
    @Override
    public List<BoardArrangeVO> boardDisplayColumnList(BoardArrangeVO boardArrangeVO) throws Exception {
    	return boardConfDao.boardDisplayColumnList(boardArrangeVO);
    }
    
    @Override
    public List<BoardArrangeVO> boardColumnList(Integer bbsCd) throws Exception {
    	return boardConfDao.boardColumnList(bbsCd);
    }
    
    @Override
    public int arrangeUpdateAction(BoardArrangeVO boardArrangeVO) throws Exception  {
        return boardConfDao.arrangeUpdateAction(boardArrangeVO);
    }
    
    @Override
    public int updateExtAction(List<BoardExtensionVO> extList, int bbsCd) throws Exception {
    	return boardConfDao.updateExtAction(extList, bbsCd);
    }
    
    @Override
    public Integer deleteBoardConf(BoardConfVO boardConfVO) {
        Integer delCnt = 0;
        Integer[] bbsCds = boardConfVO.getBbsCds();

        for(Integer bbsCd : bbsCds) {
            boardConfVO.setBbsCd(bbsCd);
            boardConfDao.deleteBdConArrange(boardConfVO);
            boardConfDao.deleteBdConExtension(boardConfVO);
            boardConfDao.deleteBdConForm(boardConfVO);
            boardConfDao.deleteBdConGlobal(boardConfVO);
            boardConfDao.deleteBdConList(boardConfVO);
            boardConfDao.deleteBdConView(boardConfVO);
            boardConfDao.deleteBdConCtg(boardConfVO);
            
            delCnt += boardConfDao.boardConfDelete(boardConfVO);
        }

        return delCnt;
    }
    
    @Override
    public int updateAction(BoardConfYnVO boardConfYnVO) {
        return boardConfDao.updateAction(boardConfYnVO);
    }
    
    /*@Override
    public Pager<BoardConfVO> boardConfList(BoardConfVO boardConfVO) {
        return boardConfDao.boardConfList(boardConfVO);
    }*/

    /*@Override
    public List<BoardConfVO> boardConfList() {
        return boardConfDao.boardConfList();
    }

    @Override
    public BoardConfVO boardConfView(BoardConfVO boardConfVO) {
        return boardConfDao.boardConfView(boardConfVO);
    }

    @Override
    public Object insertAction(BoardConfVO boardConfVO) {
        return boardConfDao.insertAction(boardConfVO);
    }

    @Override
    public int updateAction(BoardConfVO boardConfVO) {
        return boardConfDao.updateAction(boardConfVO);
    }

    @Override
    public int updateAction(BoardConfYnVO boardConfYnVO) {
        return boardConfDao.updateAction(boardConfYnVO);
    }

    @Override
    public List<BoardArrangeVO> boardColumnList(Integer bbsCd) {
        return boardConfDao.boardColumnList(bbsCd);
    }

    @Override
    public List<BoardArrangeVO> boardDisplayColumnList(BoardArrangeVO boardArrangeVO) {
        return boardConfDao.boardDisplayColumnList(boardArrangeVO);
    }

    @Override
    public int arrangeUpdateAction(BoardArrangeVO boardArrangeVO) {
        return boardConfDao.arrangeUpdateAction(boardArrangeVO);
    }

    @Override
    public List<BoardExtensionVO> boardConfExtList(Integer bbsCd) {
        return boardConfDao.boardConfExtList(bbsCd);
    }

    @Override
    public List<BoardTempVO> boardTemplateList(String type){
        return boardConfDao.boardTemplateList(type);
    }

    @Override
    public int updateExtAction(List<BoardExtensionVO> extList) {
        return boardConfDao.updateExtAction(extList);
    }

    @Override
    public int deleteAction(String[] bbsCds) {
        return boardConfDao.deleteAction(bbsCds);
    }

    @Override
    public Integer boardConfDelete(BoardConfVO boardConfVO) {
        BoardConfVO delBoardConfVO = boardConfView(boardConfVO);
        delBoardConfVO.setDataMap(boardConfVO.getDataMap());

        Integer delCnt = boardConfDao.boardConfDelete(delBoardConfVO);

        return delCnt;
    }

    @Override
    public Integer boardConfListDelete(BoardConfVO boardConfVO) {
        Integer delCnt = 0;
        Integer[] bbsCds = boardConfVO.getBbsCds();

        for(Integer bbsCd : bbsCds) {
            boardConfVO.setBbsCd(bbsCd);
            delCnt += boardConfDao.boardConfDelete(boardConfVO);
        }

        return delCnt;
    }

    @Override
    public Object copyAction(String oldBbsCd, String newBbsNm, String newBbsDesc) {
        return boardConfDao.copyAction(oldBbsCd, newBbsNm, newBbsDesc);
    }

    *//**
     * 게시판 확장 설정 복사
     *//*
    @Override
    public int extCopyAction(Integer oldBbsCd) {
        return boardConfDao.extCopyAction(oldBbsCd);
    }

    @Override
    public void reloadBbsCache() {
        boardConfDao.reloadBbsCache();
    }*/
}
