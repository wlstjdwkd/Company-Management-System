/*
 * Copyright (c) 2012 ZES Inc. All rights reserved.
 * This software is the confidential and proprietary information of ZES Inc.
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with ZES Inc. (http://www.zesinc.co.kr/)
 */
package egovframework.board.admin;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import com.infra.file.FileDAO;
import com.infra.file.FileVO;
import com.infra.util.DateFormatUtil;
import com.infra.util.FileUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.springframework.stereotype.Repository;

import egovframework.board.config.BoardConfVO;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository
public class BoardDao extends EgovAbstractMapper {

    @Resource
    private FileDAO fileDao;

    @Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;
    
    /**
     * 게시물 목록 조회
     * 
     * @param : bbsCd, noticeYn, banYn
     */
    @SuppressWarnings("unchecked")
    public List<BoardVO> boardList(BoardVO boardVO, String listSkin) {
    	    	    	
        //int listTotalCount = ((Integer) (selectOne("_board.boardListCount", boardVO))).intValue();

        if(listSkin.toLowerCase().contains("reply")) {            
        	if(Validate.isEmpty(boardVO.getQ_sortName())) {
        		boardVO.setQ_sortName("ROWNUM");
        		boardVO.setQ_sortOrder("DESC");
            }
        }

        /*parameterMap.put(
            "pagingEndNum",
            Pager.getEndNum(Integer.parseInt(parameterMap.get("pagingStartNum").toString()),
                Integer.parseInt(parameterMap.get("q_rowPerPage").toString())));*/
        
        List<BoardVO> dataList = selectList("_board.boardList", boardVO);
        /*for(BoardVO dataVO : dataList) {
            dataVO.setFileList(fileDao.getFiles(dataVO.getFileSeq()));
        }*/
        //boardVO.setTotalNum(listTotalCount);

        return dataList;
    }
    
    public int boardListCount(BoardVO boardVO) {
    	return ((Integer) (selectOne("_board.boardListCount", boardVO))).intValue();
    }

    /**
     * 게시물 목록 조회(컨버전 다운로드용)
     */
    /*@SuppressWarnings("unchecked")
    public Pager<BoardVO> boardAllList(BoardConvertOptionVO boardConvertOptionVO) {
        Map<String, Object> parameterMap = boardConvertOptionVO.getDataMap();
        VoBinder.methodBind(parameterMap, boardConvertOptionVO);

        if(!"Y".equals(boardConvertOptionVO.getShowAll())) {
            parameterMap.put("bbsCd", boardConvertOptionVO.getBbsCd());
            if(Validate.isNotEmpty(boardConvertOptionVO.getMaxResult()) && boardConvertOptionVO.getMaxResult() > 0) {
                parameterMap.put("pagingStartNum", String.valueOf(1));
                parameterMap.put("pagingEndNum", String.valueOf(boardConvertOptionVO.getMaxResult()));
            } else {
                parameterMap.remove("pagingStartNum");
                parameterMap.remove("pagingEndNum");
            }
        } else {
            parameterMap.remove("pagingStartNum");
            parameterMap.remove("pagingEndNum");
        }

        List<BoardVO> dataList = list("_board.boardAllList", parameterMap);
        int listTotalCount = ((Integer) (selectByPk("_board.boardListCount", parameterMap))).intValue();
        boardConvertOptionVO.setTotalNum(listTotalCount);

        return new Pager<BoardVO>(dataList, boardConvertOptionVO);
    }

    *//**
     * 게시물 공지 목록 조회
     */
    @SuppressWarnings("unchecked")
    public List<BoardVO> noticeList(BoardVO boardVO, String listSkin) {
        /*Map<String, Object> parameterMap = new HashMap<String, Object>();
        parameterMap.putAll(boardVO.getDataMap());
        VoBinder.methodBind(parameterMap, boardVO);
        parameterMap.put("noticeYn", "Y");*/

        return selectList("_board.noticeList", boardVO);
    }

    /**
     * 게시물 상세 조회
     */
    @SuppressWarnings("unchecked")
    public BoardVO boardView(BoardVO boardVO, BoardConfVO boardConfVO) {
        BoardVO dataVO = (BoardVO) selectOne("_board.boardView", boardVO);

        if(dataVO != null) {
            dataVO.setPrevVO((BoardVO) selectOne("_board.boardPrevView", boardVO));
            dataVO.setNextVO((BoardVO) selectOne("_board.boardNextView", boardVO));
            
            dataVO.setFileList(fileDao.getFiles(dataVO.getFileSeq()));
            dataVO.setFileCnt(dataVO.getFileList().size());
            
            if(Validate.isNotEmpty(dataVO.getAnsFileSeq())) {
            	dataVO.setAnsFileList(fileDao.getFiles(dataVO.getAnsFileSeq()));
            	dataVO.setAnsFileCnt(dataVO.getAnsFileList().size());
            }
            
            //TODO 게시물 등록비밀번호 암호화하고 있음. 추후처리
            /*if(Validate.isNotEmpty(dataVO.getRegPwd())) {
                DESCrypto descrypto = new DESCrypto();
                dataVO.setRegPwd(descrypto.decrypt(dataVO.getRegPwd()));
            }*/
            
            // 민원형 게시판인 경우 신청상태를 변경
            //TODO CONTROLLER에서 넘기는 방식으로 변경
            //BoardConfVO boardConfVO = boardCacheService.findBoardConfig(boardVO.getBbsCd());
            String stateStr = dataVO.getExtColumn1() != null ? dataVO.getExtColumn1() : "";
            //신청이거나 상태값이 없을 경우에 접수로 변경
            if(boardConfVO.getListSkin().toLowerCase().contains("petition") && ("".equals(stateStr) || "A".equals(stateStr))) {
                boardVO.setExtColumn1("B");
                //TODO 관리자 화면에서는 상태 변경하는 부분 구현해야함.
                //update("_board.updatePetiState", boardVO);
            }
        }
        
        // 태그를 가져온다.
        List<String> list = new ArrayList<String>();
        if(dataVO != null) {
            list = selectList("_board.boardTagList", dataVO);
        }
        if(Validate.isNotEmpty(list)) {
            dataVO.setBbsTags(list.toArray(new String[list.size()]));
        }

        return dataVO;
    }

    /**
     * 게시물 상세 조회 카운트를 증가시킨다.
     */
    public Object incReadCount(BoardVO boardVO) {
        return update("_board.boardIncReadCnt", boardVO);
    }

    /**
     * 게시물 평가 액션
     *//*
    public Object scoreAction(BoardVO boardVO) {
        Object result = update("_board.scoreInc", boardVO);
        return result;
    }

    *//**
     * 게시물 추천 액션
     *//*
    public Object recommAction(BoardVO boardVO) {
        Object result = update("_board.recommInc", boardVO);
        return result;
    }

    *//**
     * 게시물 신고 액션
     *//*
    public Object accuseAction(BoardVO boardVO) {
        Object result = update("_board.accuseInc", boardVO);
        return result;
    }

    *//**
     * 게시물 등록 액션
     */
    public Object boardInsert(BoardVO boardVO, BoardConfVO boardConfVO) {

        int fileSeq = fileDao.saveFile(boardVO.getFileList(), boardVO.getFileSeq());
        boardVO.setFileSeq(fileSeq);

        /*boardVO.setTitle(Converter.cleanHtml(boardVO.getTitle()));
        boardVO.setSummary(StringUtil.omit(Converter.cleanHtml(StringUtil.replace(boardVO.getContents(), "\"", "'")), 60));*/
        
        boardVO.setSummary(StringUtil.omit(StringUtil.replace(boardVO.getContents(), "\"", "'"), 60));
        
        if(Validate.isNotEmpty(boardVO.getRegPwd())) {
            /*DESCrypto descrypto = new DESCrypto();
            boardVO.setRegPwd(descrypto.encrypt(boardVO.getRegPwd()));*/
        }

        String date = DateFormatUtil.getTodayMsec();

        // 답글 작성시
        if(Validate.isNotEmpty(boardVO.getRefSeq())) {
            BoardVO tempVO = boardVO.copyCreateVO();
            int lastChildNo = getMinChildNo(tempVO);
            boardVO.setOrderNo(lastChildNo);
            update("_board.boardUpdateOrderNo", boardVO);
            boardVO.setOrderNo(lastChildNo + 1);
            boardVO.setDepth(boardVO.getDepth() + 1);
            boardVO.setSeq(date);
        }
        // 신규 등록시
        else {
            boardVO.setOrderNo(0);
            boardVO.setDepth(0);
            boardVO.setSeq(date);
            boardVO.setRefSeq(date);
        }
        boardVO.setReadCnt(0);
        // 민원형 게시판인 경우 상태를 신청상태로 등록
        //BoardConfVO boardConfVO = (BoardConfVO) Cache.get(BoardConfCache.BBS_CD_KEY + boardVO.getBbsCd());
        if(boardConfVO.getListSkin().toLowerCase().contains("petition")) {
            boardVO.setExtColumn1("A");
        }
        //도메인코드가 비어있을경우 기본은 포털로
        if(boardVO.getExtColumn3() == null){
            boardVO.setExtColumn3("1");
        }
        
        insert("_board.boardInsert", boardVO);

        // 갤러리 게시판인 경우 썸네일을 생성한다.        
        if(boardConfVO.getListSkin().toLowerCase().contains("gallery")) {
        	//TODO 겔러리형 게시판 처리(이 템플릿 사용하는지?)
            //createThumbNail(fileSeq, 100, 100);
        }

        addTags(boardVO);

        return StringUtil.ONE;
    }

    /**
     * 민원형 게시물 답변 액션
     */
    public int boardAnswer(BoardVO boardVO) {
    	
    	int fileSeq = fileDao.saveFile(boardVO.getAnsFileList(), boardVO.getAnsFileSeq());
        boardVO.setAnsFileSeq(fileSeq);
    	
        return update("_board.boardAnswerUpdate", boardVO);
    }

    /**
     * 태그를 등록한다.
     */
    private void addTags(BoardVO boardVO) {
        if(Validate.isEmpty(boardVO.getBbsTags()) || (boardVO.getBbsTags()[0].length() == 0)) {
            return;
        }

        String[] tags = boardVO.getBbsTags()[0].split(",");
        for(String tagNm : tags) {
            BoardTagVO boardTagVO = new BoardTagVO(boardVO.getBbsCd(), boardVO.getSeq(), StringUtil.trim(tagNm));

            if(Validate.isEmpty(boardTagVO.getTagNm())) {
                return;
            }
            if(((Integer) selectOne("_board.boardTagCount", boardTagVO)).intValue() > 0) {
                continue;
            }
            insert("_board.boardTagInsert", boardTagVO);
        }
    }

    /**
     * 재귀적 호출을 하여 자식중 orderNo가 최고 낮은 마지막 자식의 orderNo를 넘겨준다.
     */
    private int getMinChildNo(BoardVO boardVO) {
        BoardVO dataVO = new BoardVO();

        while(true) {
            dataVO = (BoardVO) selectOne("_board.boardMinChildNode", boardVO);
            if(boardVO.getOrderNo().intValue() == dataVO.getOrderNo().intValue()) {
                // 현재 제일 마지막 자식 노드의 넘버를 리턴한다.
                return dataVO.getOrderNo();
            } else {
                boardVO.setBbsCd(dataVO.getBbsCd());
                boardVO.setSeq(dataVO.getSeq());
                boardVO.setRefSeq(dataVO.getRefSeq());
                boardVO.setOrderNo(dataVO.getOrderNo());
                boardVO.setDepth(dataVO.getDepth());
            }
        }
    }

    private int getMaxChildNo(BoardVO boardVO) {
        BoardVO dataVO = new BoardVO();

        while(true) {
            dataVO = (BoardVO) selectOne("_board.boardMaxChildNode", boardVO);
            if(boardVO.getOrderNo().intValue() == dataVO.getOrderNo().intValue()) {
                // 현재 제일 마지막 자식 노드의 넘버를 리턴한다.
                return dataVO.getOrderNo();
            } else {
                boardVO.setBbsCd(dataVO.getBbsCd());
                boardVO.setSeq(dataVO.getSeq());
                boardVO.setRefSeq(dataVO.getRefSeq());
                boardVO.setOrderNo(dataVO.getOrderNo());
                boardVO.setDepth(dataVO.getDepth());
            }
        }
    }

    /**
     * 게시물 수정 액션
     */
    public int boardUpdate(BoardVO boardVO) {
        // boardVO.setTitle(Converter.cleanHtml(boardVO.getTitle()));
        if(Validate.isNotEmpty(boardVO.getRegPwd())) {
            /*DESCrypto descrypto = new DESCrypto();
            boardVO.setRegPwd(descrypto.encrypt(boardVO.getRegPwd()));*/
        }
        boardVO.setModDt(DateFormatUtil.getToday());

        int affected = update("_board.boardUpdate", boardVO);

        if(affected == StringUtil.ONE) {
            // ajax 삭제 기능으로 불필요해짐
            // fileDao.removeFile(boardVO.getFileSeq(), boardVO.getFileIds());

            int fileSeq = fileDao.saveFile(boardVO.getFileList(), boardVO.getFileSeq());
            boardVO.setFileSeq(fileSeq);

            // 갤러리 게시판인 경우 썸네일을 생성한다.
            /*BoardConfVO boardConfVO = (BoardConfVO) Cache.get(BoardConfCache.BBS_CD_KEY + boardVO.getBbsCd());
            if(boardConfVO.getListSkin().toLowerCase().contains("gallery")) {
                createThumbNail(fileSeq, 100, 100);
            }*/
        }

        affected = update("_board.boardUpdate", boardVO);

        delete("_board.boardTagDeleteAll", boardVO);

        addTags(boardVO);

        return affected;
    }

    /**
     * 게시물 수정 액션
     *//*
    
     * public int updateActionYn(BoardVO boardVO){
     * Map<String, Object> paramMap = new HashMap<String, Object>();
     * paramMap.put("bbsCd", String.valueOf(boardVO.getBbsCd().intValue()));
     * paramMap.put("seq", boardVO.getSeq());
     * paramMap.put("banYn", boardVO.getBanYn());
     * paramMap.put("modDt", DateFormatUtil.getToday());
     * return update("_board.boardUpdateYn", paramMap);
     * }
     

    *//**
     * 게시물 삭제 액션
     */
    @SuppressWarnings("unchecked")
    public int boardDelete(BoardVO boardVO, String delDesc, boolean useTrash) {
        BoardVO data = (BoardVO) selectOne("_board.boardView", boardVO);
        if(Validate.isEmpty(data.getSeq())) {
            return 0;
        }

        BoardVO tempVO = data.copyCreateVO();
        int lastChildNo = getMaxChildNo(tempVO);
        data.setDepth(lastChildNo);

        List<BoardVO> dataList = selectList("_board.deleteBoardList", data);

        int affected = 0;
        for(BoardVO dataVO : dataList) {
            BoardVO deleteVO = (BoardVO) selectOne("_board.boardView", dataVO);
            if(useTrash) {
                deleteVO.setDelDt(DateFormatUtil.getToday());
                deleteVO.setDelDesc(delDesc);
                deleteVO.setCmtSeq(null);

                insert("_board.trashBoardInsert", deleteVO);
                insert("_board.trashTagInsert", deleteVO);
                insert("_board.trashCommentInsert", deleteVO);

                fileDao.removeFile(dataVO.getFileSeq());
            }
            delete("_board.commentDeleteAll", dataVO);
            delete("_board.boardTagDeleteAll", dataVO);

            affected += delete("_board.boardDelete", dataVO);
        }

        return (affected == dataList.size()) ? affected : 0;
    }

    /**
     * 게시물 삭제 액션(목록에서 여러개 삭제시)
     */
    public int boardListDelete(BoardVO boardVO, String delDesc, boolean useTrash) {
        int result = 0;
        for(String seq : boardVO.getSeqs()) {
            BoardVO dataVO = new BoardVO();
            dataVO.setBbsCd(boardVO.getBbsCd());
            dataVO.setSeq(seq);
            result += boardDelete(dataVO, delDesc, useTrash);
        }
        return result;
    }

    /**
     * 게시물 플래그 삭제 액션
     *//*
    public int boardFlagDelete(BoardVO boardVO) {
        return update("_board.updateMgrDelYn", boardVO);
    }

    *//**
     * 게시물 플래그 삭제 액션(목록에서 여러개 삭제시)
     *//*
    public int boardListFlagDelete(BoardVO boardVO) {
        int result = 0;
        for(String seq : boardVO.getSeqs()) {
            BoardVO dataVO = new BoardVO();
            dataVO.setBbsCd(boardVO.getBbsCd());
            dataVO.setSeq(seq);
            result += boardFlagDelete(dataVO);
        }
        return result;
    }

    *//**
     * 덧글 목록 조회
     *//*
    @SuppressWarnings("unchecked")
    public Pager<BoardCmtVO> commentList(BoardCmtVO boardCmtVO) {
        Map<String, Object> parameterMap = boardCmtVO.getDataMap();
        VoBinder.methodBind(parameterMap, boardCmtVO);

        int listTotalCount = ((Integer) (selectByPk("_board.commentListCount", parameterMap))).intValue();

        List<BoardCmtVO> dataList = list("_board.commentList", parameterMap);
        for(BoardCmtVO cmtVo : dataList) {
            cmtVo.setComments(Converter.translateBR(cmtVo.getComments()));
        }

        boardCmtVO.setTotalNum(listTotalCount);

        return new Pager<BoardCmtVO>(dataList, boardCmtVO);
    }

    *//**
     * 덧글 등록 액션
     *//*
    public Object insertComment(BoardCmtVO boardCmtVO) {
        if(Validate.isNotEmpty(boardCmtVO.getRegPwd())) {
            DESCrypto descrypto = new DESCrypto();
            boardCmtVO.setRegPwd(descrypto.encrypt(boardCmtVO.getRegPwd()));
        }
        String date = DateFormatUtil.getTodayMsec();
        boardCmtVO.setCmtSeq(date);
        boardCmtVO.setComments(Converter.XSS(boardCmtVO.getComments()));
        Object result = insert("_board.commentInsert", boardCmtVO);
        return result;
    }

    *//**
     * 덧글 상세 보기
     *//*
    public BoardCmtVO viewComment(BoardCmtVO boardCmtVO) {
        BoardCmtVO dataVO = (BoardCmtVO) selectByPk("_board.commentView", boardCmtVO);
        if(Validate.isNotEmpty(dataVO) && Validate.isNotEmpty(dataVO.getRegPwd())) {
            DESCrypto descrypto = new DESCrypto();
            dataVO.setRegPwd(descrypto.decrypt(dataVO.getRegPwd()));
        }
        return dataVO;
    }

    *//**
     * 덧글 수정 액션
     *//*
    public Object updateComment(BoardCmtVO boardCmtVO) {
        boardCmtVO.setModDt(DateFormatUtil.getToday());
        if(Validate.isNotEmpty(boardCmtVO.getRegPwd())) {
            DESCrypto descrypto = new DESCrypto();
            boardCmtVO.setRegPwd(descrypto.encrypt(boardCmtVO.getRegPwd()));
        }
        boardCmtVO.setComments(Converter.XSS(boardCmtVO.getComments()));
        Object result = update("_board.commentUpdate", boardCmtVO);
        return result;
    }

    *//**
     * 덧글 삭제 액션(완전삭제)
     *//*
    public Object deleteComment(BoardCmtVO boardCmtVO) {
        BoardVO deleteVO = new BoardVO();
        deleteVO.setBbsCd(boardCmtVO.getBbsCd());
        deleteVO.setSeq(boardCmtVO.getSeq());
        deleteVO.setCmtSeq(boardCmtVO.getCmtSeq());
        deleteVO.setDelDt(DateFormatUtil.getToday());
        deleteVO.setDelDesc("댓글 개별 삭제");
        insert("_board.trashCommentInsert", deleteVO);

        Object result = delete("_board.commentDelete", boardCmtVO);
        return result;
    }

    *//**
     * 덧글 플래그 삭제 액션
     *//*
    public int cmtFlagDelete(BoardCmtVO boardCmtVO) {
        return update("_board.updateCmtMgrDelYn", boardCmtVO);
    }

    *//**
     * 게시판 목록들(선택한 게시판이 아닌 다른 모든 게시판목록)
     *//*
    @SuppressWarnings("unchecked")
    public List<BoardConfVO> boardConfList(Integer bbsCd) {
        Map<String, Integer> map = new HashMap<String, Integer>();
        map.put("bbsCd", bbsCd);

        return list("_boardconf.boardConfSimpleList", map);
    }

    *//**
     * 목록보기에서 게시물 복사 & 이동
     *//*
    public Integer listTransfer(String bbsCd, Integer[] toBbsCds, String[] seqs, String isMove, Integer[] newCtg) {
        int primaryKey = 0;
        for(int i = 0 ; i < seqs.length ; i++) {
            primaryKey += articleTransfer(bbsCd, toBbsCds[i], seqs[i], isMove, newCtg[i]);
        }

        return primaryKey;
    }

    *//**
     * 상세보기에서 게시물 복사 & 이동
     *//*
    @SuppressWarnings("unchecked")
    public Integer articleTransfer(String bbsCd, Integer toBbsCd, String seq, String isMove, Integer newCtg) {
        BoardVO boardVO = new BoardVO();
        boardVO.setBbsCd(Integer.valueOf(bbsCd));
        boardVO.setSeq(seq);
        BoardVO dataVO = (BoardVO) selectByPk("_board.boardMoveView", boardVO);

        BoardConfVO boardConfVO = (BoardConfVO) Cache.get(BoardConfCache.BBS_CD_KEY + toBbsCd);

        if(boardConfVO.getListSkin().toLowerCase().contains("gallery")) {
            if(!isAllImage(dataVO.getFileSeq())) {
                return 0;
            }
        }

        dataVO.setBbsCd(toBbsCd);
        if(Validate.isNotEmpty(newCtg)) {
            dataVO.setCtgCd(newCtg);
        } else {
            dataVO.setCtgCd(-1);
        }

        dataVO.setModDt(DateFormatUtil.getToday());

        // 게시물을 대상 게시판으로 복사
        if((Integer) selectByPk("_board.getBoardCount", dataVO) > 0) {
            return 0;
        }

        try {
            insert("_board.boardInsert", dataVO);
            // 원본게시물에 이동한게시판코드 저장
            Map<String, Object> param = new HashMap<String, Object>();
            param.put("toBbsCd", toBbsCd);
            param.put("bbsCd", bbsCd);
            param.put("seq", seq);
            update("_board.updateMoveBbsCd", param);
        } catch (Exception e) {
            if(logger.isDebugEnabled()) {
                logger.debug("article move failed", e);
            }
            return 0;
        }

        if(boardConfVO.getListSkin().toLowerCase().contains("gallery")) {
            // 이동할 게시판이 갤러리 게시판인 경우 썸네일을 생성한다.
            createThumbNail(dataVO.getFileSeq(), 100, 100);
        }

        List<BoardCmtVO> commentList = list("_board.commentListAll", boardVO);

        for(BoardCmtVO boardCommentVO : commentList) {
            boardCommentVO.setBbsCd(toBbsCd);
            insert("_board.commentInsert", boardCommentVO);
        }

        List<BoardTagVO> tagList = list("_board.boardTagListAll", boardVO);

        for(BoardTagVO boardTagVO : tagList) {
            boardTagVO.setBbsCd(toBbsCd);
            insert("_board.boardTagInsert", boardTagVO);
        }

        // 원본 게시물 삭제 => 원본 게시물 보관
        if("Y".equals(isMove)) {
            // return boardDelete(boardVO, "게시물이동 : " + bbsCd + " -> " +
            // toBbsCd.toString(), false);
        }

        return 1;
    }

    *//**
     * 첨부파일이 모두 이미지 파일인지 확인한다.
     *//*
    private boolean isAllImage(Integer fileSeq) {
        List<FileVO> fileList = fileDao.getFiles(fileSeq);
        for(FileVO bean : fileList) {
            if(!bean.getFileType().startsWith("image/")) {
                return false;
            }
        }
        return true;
    }

    *//**
     * 용량이 오버된 첨부파일을 삭제한다.
     */
    public boolean fileDelete(List<FileVO> fileList) {
        int deleteCnt = 0;
        if(Validate.isNotEmpty(fileList)) {
            // 물리적인 첨부파일 삭제
            for(FileVO fileVO : fileList) {
                if(FileUtil.delete(propertiesService.getString("attachFilePath", "") + fileVO.getFileUrl())) {
                    deleteCnt++;
                }
            }
        }
        return (deleteCnt == fileList.size()) ? true : false;
    }

    /**
     * 게시판에 대한 클라우드 태그 목록을 가져온다.
     *//*
    @SuppressWarnings("unchecked")
    public String tagCloud(Integer bbsCd) {
        BoardTagVO resultVO = new BoardTagVO();
        resultVO.setBbsCd(bbsCd);

        StringBuilder jsonStr = new StringBuilder();
        Integer tagMaxCnt = 0;
        Integer tagMinCnt = 0;
        Integer tagAvgCnt = 0;

        List<BoardTagVO> dataList = list("_board.boardTagAllList", bbsCd);

        tagMaxCnt = (Integer) selectByPk("_board.boardTagMaxCount", bbsCd);
        tagMinCnt = (Integer) selectByPk("_board.boardTagMinCount", bbsCd);
        tagAvgCnt = (Integer) selectByPk("_board.boardTagAvgCount", bbsCd);

        jsonStr.append("({ tags:[ ");

        for(int i = 0 ; i < dataList.size() ; i++) {
            jsonStr.append("{tag:'" + dataList.get(i).getTagNm() + "', freq:'" + dataList.get(i).getTagCnt() + "'}");
            if(i != (dataList.size() - 1)) {
                jsonStr.append(",");
            }
        }
        jsonStr.append("],");

        jsonStr.append("tagMaxCnt: '" + tagMaxCnt + "',");
        jsonStr.append("tagMinCnt: '" + tagMinCnt + "',");
        jsonStr.append("tagAvgCnt: '" + tagAvgCnt + "'");
        jsonStr.append("})");

        return jsonStr.toString();
    }

    // 갤러리 게시판용 썸네일 이미지를 생성한다. (같은 폴더, postfix = "_t")
    private void createThumbNail(Integer fileSeq, int width, int height) {
        List<FileVO> fileList = fileDao.getFiles(fileSeq);
        createThumbNail(fileList, width, height);
    }

    // 갤러리 게시판용 썸네일 이미지를 생성한다. (같은 폴더, postfix = "_t")
    private void createThumbNail(List<FileVO> fileList, int width, int height) {
        for(FileVO baseFileVO : fileList) {
            String filePath = baseFileVO.getServerNm();
            String fileName = filePath.substring(0, filePath.length() - 4) + "_t.jpg";

            if(FileUtil.isFile(fileName) || !baseFileVO.getFileType().startsWith("image/")) {
                continue;
            }

            try {
                BufferedImage bi = ImageIO.read(new File(GlobalConfig.WEBAPP_ROOT + baseFileVO.getFileUrl()));

                // width, height는 원하는 thumbnail 이미지의 크기

                // aspect ratio 유지하기 위해 크기 조정
                if((float) width / bi.getWidth() > (float) height / bi.getHeight()) {
                    width = (int) (bi.getWidth() * ((float) height / bi.getHeight()));
                } else {
                    height = (int) (bi.getHeight() * ((float) width / bi.getWidth()));
                }

                BufferedImage thImg = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
                Graphics2D g2 = thImg.createGraphics();
                g2.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
                g2.drawImage(bi, 0, 0, width, height, null);

                g2.dispose();

                // thumbnail 이미지를 JPEG 형식으로 저장
                ImageIO.write(thImg, "jpg", new File(fileName));
            } catch (IOException e) {
                if(logger.isDebugEnabled()) {
                    logger.debug("create thumbnail failed", e);
                }
            }
        }
    }

    *//**
     * domainList 설명
     * @param boardVO
     * @return
     *//*
    @SuppressWarnings("rawtypes")
    public List domainList(BoardVO boardVO) {
        return list("_board.domainList", boardVO);
    }*/
    
    /**
     * 게시물 반복 등록 검사
     */
    public boolean boardRepeatInsertCheck(BoardVO boardVO) {
        int selectCnt = 0;
        
        selectCnt = selectOne("_board.boardRepeatInsertCheck", boardVO);
        
        return (selectCnt > 0) ? true : false;
    }
    
    /**
     * 게시물 댓글 반복 등록 검사
     */
    public boolean boardAnswerRepeatInsertCheck(HashMap params) {
        int selectCnt = 0;
        
        selectCnt = selectOne("_board.boardAnswerRepeatInsertCheck", params);
        
        return (selectCnt > 0) ? true : false;
    }
    
    /**
     * 게시물 댓글 등록
     */
    public Object boardAnswerInsert(HashMap params) {
    	String date = DateFormatUtil.getTodayMsec();
    	
    	params.put("answerSeq", date);
    	
        insert("_board.boardAnswerInsert", params);
        
        return StringUtil.ONE;
    }
    
    /**
     * 게시물 댓글 목록 조회
     * 
     * @param : HashMap
     */
    @SuppressWarnings("unchecked")
    public List<HashMap> boardAnswerList(HashMap params) {
        List<HashMap> dataList = selectList("_board.boardAnswerList", params);

        return dataList;
    }
    
    public int boardAnswerListCount(HashMap params) {
    	return ((Integer) (selectOne("_board.boardAnswerListCount", params))).intValue();
    }
    
    /**
     * 게시물 댓글 수정
     */
    public int boardAnswerSeqUpdate(HashMap params) {
    	int result = update("_board.boardAnswerSeqUpdate", params);
    	
    	return result;
	}
    
    /**
     * 게시물 댓글 삭제
     */
    public int boardAnswerSeqDelete(HashMap params) {
    	int result = delete("_board.boardAnswerSeqDelete", params);
    	
    	return result;
	}
}
