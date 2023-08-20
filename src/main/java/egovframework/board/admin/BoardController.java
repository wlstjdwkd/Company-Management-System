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
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.comm.page.Pager;
import com.comm.user.AllUserVO;
import com.comm.user.UserService;
import com.comm.user.UserVO;
import com.infra.file.FileDAO;
import com.infra.file.FileVO;
import com.infra.file.UploadHelper;
import com.infra.util.Converter;
import com.infra.util.CookieUtil;
import com.infra.util.DateFormatUtil;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import egovframework.board.config.BoardCacheService;
import egovframework.board.config.BoardConfConstant;
import egovframework.board.config.BoardConfVO;
import egovframework.board.util.SpringHelper;
import egovframework.com.uss.olp.qim.web.EgovQustnrItemManageController;

/**
 * @author dongwoo
 *
 */
@Controller
@RequestMapping("/PGMS0081.do")
public class BoardController{

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovQustnrItemManageController.class);
	
	private Locale locale = Locale.getDefault();
	
	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	@Resource(name = "filesDAO")
	private FileDAO fileDao;
	
	@Autowired
	UserService userService;
	
    //private BoardService boardService;
	@Autowired
    private BoardCacheService boardCacheService;
	
	private BoardService boardService;

    public void setBoardService(HttpServletRequest request) {
        this.boardService = getBoardServiceName(request);
    }

    public void setBoardService(HttpServletRequest request, String pageType) {
        this.boardService = getBoardServiceName(request, pageType);
    }

    /**
     * 게시판 유형별 서비스 설정
     */
    private BoardService getBoardServiceName(HttpServletRequest request) {
        String serviceName = "";
        //BoardConfVO boardConfVO = (BoardConfVO) Cache.get(BoardConfCache.BBS_CD_KEY + request.getParameter("bbsCd"));
        BoardConfVO boardConfVO = boardCacheService.findBoardConfig(Integer.parseInt(request.getParameter("bbsCd")));
        int kindCd = boardConfVO.getKindCd();
        if(kindCd == 0) {
            kindCd = BoardConfConstant.GUBUN_BOARD_BASIC;
        }
        switch(kindCd) {
            case BoardConfConstant.GUBUN_BOARD_BASIC:
                serviceName = "basicBoardService";
                break;
            case BoardConfConstant.GUBUN_BOARD_PETITION:
                serviceName = "petitionBoardService";
                break;
            case BoardConfConstant.GUBUN_BOARD_REPLY:
                serviceName = "replyBoardService";
                break;
            case BoardConfConstant.GUBUN_BOARD_GALLERY:
                serviceName = "galleryBoardService";
                break;
            case BoardConfConstant.GUBUN_BOARD_EBOOK:
                serviceName = "ebookBoardService";
                break;
            case BoardConfConstant.GUBUN_BOARD_FAQ:
                serviceName = "faqBoardService";
                break;
            default:
                serviceName = "basicBoardService";
                break;
        }
        return (BoardService) SpringHelper.findService(request.getSession().getServletContext(), serviceName);
    }

    /**
     * 게시판 유형별 서비스 설정(템플릿별)
     */
    private BoardService getBoardServiceName(HttpServletRequest request, String pageType) {
        String serviceName = "", skinName = "";
        //BoardConfVO boardConfVO = (BoardConfVO) Cache.get(BoardConfCache.BBS_CD_KEY + request.getParameter("bbsCd"));
        BoardConfVO boardConfVO = boardCacheService.findBoardConfig(Integer.parseInt(request.getParameter("bbsCd")));

        if(pageType.equals("L")) {
            skinName = boardConfVO.getListSkin().toLowerCase();
        } else if(pageType.equals("V")) {
            skinName = boardConfVO.getViewSkin().toLowerCase();
        } else if(pageType.equals("F")) {
            skinName = boardConfVO.getFormSkin().toLowerCase();
        }

        if(skinName.contains("basic")) {
            serviceName = "basicBoardService";
        } else if(skinName.contains("petition")) {
            serviceName = "petitionBoardService";
        } else if(skinName.contains("reply")) {
            serviceName = "replyBoardService";
        } else if(skinName.contains("gallery")) {
            serviceName = "galleryBoardService";
        } else if(skinName.contains("ebook")) {
            serviceName = "ebookBoardService";
        } else if(skinName.contains("faq")) {
            serviceName = "faqBoardService";
        } else {
            serviceName = "basicBoardService";
        }

        return (BoardService) SpringHelper.findService(request.getSession().getServletContext(), serviceName);
    }
    
    
    
    
    /**
     * 게시물 목록 조회
     * 
     * @param request
     * @param model
     */    
    //@RequestMapping(value = "BD_board.list.do", method = RequestMethod.GET)
	@RequestMapping("")
    public String boardList(HttpServletRequest request, ModelMap model, BoardVO boardVO) {
        setBoardService(request, "L"); // 게시판 유형 서비스 설정
                
        //캐싱된 게시판 설정을 가져온다.
		BoardConfVO boardConfVO = boardCacheService.findBoardConfig(boardVO.getBbsCd());
		
        if(Validate.isEmpty(boardVO.getQ_rowPerPage())) {
            boardVO.setQ_rowPerPage(boardConfVO.getRppNum());
        }

        // 게시판 항목설정에 따른 검색 대상 및 검색 유형 설정
        if(Validate.isNotEmpty(boardVO.getQ_searchKeyType())) {
            if(boardVO.getQ_searchKeyType().contains("___")) {
                String[] search = boardVO.getQ_searchKeyType().split("___");
                boardVO.setQ_searchKey(search[0]);
                boardVO.setQ_searchType(search[1]);
            }
        }
        // 날짜 검색값 포맷
        if(Validate.isNotEmpty(boardVO.getQ_startDt())) {
            String startDt = boardVO.getQ_startDt();
            startDt = StringUtil.remove(startDt, "-");
            boardVO.setQ_startDt(startDt + "000000");
        }
        if(Validate.isNotEmpty(boardVO.getQ_endDt())) {
            String endDt = boardVO.getQ_endDt();
            endDt = StringUtil.remove(endDt, "-");
            boardVO.setQ_endDt(endDt + "232359");
        }
        
        // 데이터요청 날짜 검색값 포맷
        if(Validate.isNotEmpty(boardVO.getQ_pjtStartDt())) {
            String startDt = boardVO.getQ_pjtStartDt();
            startDt = StringUtil.remove(startDt, "-");
            boardVO.setQ_pjtStartDt(startDt + "000000");
        }
        if(Validate.isNotEmpty(boardVO.getQ_pjtEndDt())) {
            String endDt = boardVO.getQ_pjtEndDt();
            endDt = StringUtil.remove(endDt, "-");
            boardVO.setQ_pjtEndDt(endDt + "232359");
        }

        boardVO.setCutTitleNum(boardConfVO.getCutTitleNum());
        model.addAttribute(BoardConfConstant.KEY_CONF_VO, boardConfVO);
        model.addAttribute("pageType", "LIST");

        addNoticeBbsList(boardVO, boardConfVO.getListSkin(), request.getSession().getServletContext().getRealPath("/"), model);

        String url = getTemplateFolderName(request.getRequestURL().toString(), boardConfVO.getKindCd(), boardConfVO.getListSkin());        
        return url + "PD_boardList";
    }
	
	/**
     * 게시물 상세 조회
     */    
    //@RequestMapping(value = "BD_board.view.do")
	@RequestMapping(params="df_method_nm=boardView")
    public String boardView(ModelMap model, HttpServletRequest request, HttpServletResponse response, @ModelAttribute BoardVO boardVO)
        throws Exception {
		
		UserVO userVO = SessionUtil.getUserInfo();
		
        setBoardService(request, "V"); // 게시판 유형 서비스 설정                        
        BoardConfVO boardConfVO = boardCacheService.findBoardConfig(boardVO.getBbsCd());

        // 게시판 항목설정에 따른 검색 대상 및 검색 유형 설정
        if(Validate.isNotEmpty(boardVO.getQ_searchKeyType())) {
            if(boardVO.getQ_searchKeyType().contains("___")) {
                String[] search = boardVO.getQ_searchKeyType().split("___");
                boardVO.setQ_searchKey(search[0]);
                boardVO.setQ_searchType(search[1]);
            }
        }
        // 날짜 검색값 포맷
        if(Validate.isNotEmpty(boardVO.getQ_startDt())) {
            String startDt = boardVO.getQ_startDt();
            startDt = StringUtil.remove(startDt, "-");
            boardVO.setQ_startDt(startDt + "000000");
        }
        if(Validate.isNotEmpty(boardVO.getQ_endDt())) {
            String endDt = boardVO.getQ_endDt();
            endDt = StringUtil.remove(endDt, "-");
            boardVO.setQ_endDt(endDt + "232359");
        }

        BoardVO dataVO = boardService.boardView(boardVO, boardConfVO);
        if(dataVO == null) {
        	//TODO 게시물 데이터 없는 경우 처리
            //return alertAndBack(model, Messages.COMMON_NO_DATA);
        }

        // 비밀글인 경우 작성자나 슈퍼유저인가? => 회원 게시판에서 체크할 것
        if("N".equals(dataVO.getOpenYn())) {
        	//TODO 비밀글인 경우 처리
            /*LoginVO loginVo = OpHelper.getMgrSession(request);
            if(Validate.isEmpty(loginVo.getMgrId())) { // 일단은 관리자 세션이 존재하는지 체크함
                return alertAndBack(model, Messages.COMMON_NO_AUTH);
            }*/
        }

        // 조회수 증가를 위한 쿠키 체크
        if(CookieUtil.isIncreateReadCnt("board" + boardVO.getBbsCd() + "_" + boardVO.getSeq(), boardConfVO.getReadCookieHour(), request, response)) {
            boardService.incReadCount(boardVO);
            dataVO.setReadCnt(dataVO.getReadCnt() + 1);
        }

        // 에디터사용이 N일 때 \n이 있으면 <br/> 태그로 전환
        if("N".equals(boardConfVO.getMgrEditorYn())) {
            dataVO.setContents(Converter.translateBR(dataVO.getContents()));
        }
        
        //TODO 겔러리형 : file path 처리, 민원형 : 관리자 null 체크 후 세팅
        if(boardConfVO.getViewSkin().toLowerCase().contains("gallery")) {
            /*convertFilePath(dataVO.getFileList(), request.getSession().getServletContext().getRealPath("/"));*/
        } else if(boardConfVO.getViewSkin().toLowerCase().contains("petition")) {        	
            /*if(Validate.isEmpty(dataVO.getMgrNm())) {
                LoginVO loginVo = OpHelper.getMgrSession(request);
                dataVO.setMgrNm(loginVo.getMgrNm());
            }*/
        }
        
        //질문형 게시판의 경우 관리자 정보가 없는 경우 로그인 관리자 이름으로 세팅
        if(boardConfVO.getViewSkin().equals("petition") 
        		&& Validate.isNotEmpty(userVO)
        		&& Validate.isEmpty(dataVO.getMgrNm())) {
        	
        	dataVO.setMgrNm(userVO.getUserNm());        	        
        }
        
        ///////////////// 법인등록번호, 기업명 가져오는 로직 추가 ////////////
        String regId = dataVO.getRegId();
		
		HashMap param = new HashMap();
		param.put("LOGIN_ID", regId);
		
		param.put("limitFrom", 0);
		param.put("limitTo", 1);
		
		List<AllUserVO> userInfo = userService.findAllUser(param);

		model.addAttribute("entrprsNm", userInfo.get(0).getEntrprsNm());
		model.addAttribute("jurirno", userInfo.get(0).getJurirno());
		///////////////// 법인등록번호, 기업명 가져오는 로직 추가 끝 ////////////
                
        model.addAttribute("today", DateFormatUtil.getTodayShortKr());
        model.addAttribute("pageType", "VIEW");
        model.addAttribute(BoardConfConstant.KEY_CONF_VO, boardConfVO);
        model.addAttribute(BoardConfConstant.KEY_DATA_VO, dataVO);

        if(boardConfVO.getListViewCd() == BoardConfConstant.GUBUN_LISTVIEW_LIST) {
            addNoticeBbsList(boardVO, boardConfVO.getListSkin(), request.getSession().getServletContext().getRealPath("/"), model);
        }

        String url = getTemplateFolderName(request.getRequestURL().toString(), boardConfVO.getKindCd(), boardConfVO.getViewSkin());
        return url + "PD_boardView";
    }
	
	/**
     * 게시물 등록 폼 & (bbsCd, seq=null, refSeq=null)
     * 답글 등록 폼 & (bbsCd, refSeq, seq)
     * 게시물 수정 폼 (bbsCd, seq, refSeq=null)
     * 게시물 등록 당사자나 관리자만 가능하다.
     */    
    //@RequestMapping(value = { "boardWriteForm.do", "BD_board.update.form.do", "BD_board.reply.form.do" })
	@RequestMapping(params="df_method_nm=boardWriteForm")
    public String insertForm(ModelMap model, HttpServletRequest request, @ModelAttribute BoardVO boardVO,
        @RequestParam(value = "pageType", required = true) String pageType) throws Exception {
		
		UserVO userVo = SessionUtil.getUserInfo();
		
        setBoardService(request, "F"); // 게시판 유형 서비스 설정        
        BoardConfVO boardConfVO = boardCacheService.findBoardConfig(boardVO.getBbsCd());
        model.addAttribute(BoardConfConstant.KEY_CONF_VO, boardConfVO);        

        BoardVO dataVO = new BoardVO();
        dataVO.setBbsCd(boardVO.getBbsCd());
        
        if("UPDATE".equals(pageType)) {
            // *** 수정폼 ***
            model.addAttribute("pageType", "UPDATE");
            dataVO = boardService.boardView(boardVO, boardConfVO);

        } else if("REPLY".equals(pageType)) {
            // *** 답변등록폼 ***
            model.addAttribute("pageType", "REPLY");
            boardVO = boardService.boardView(boardVO, boardConfVO);
            dataVO = boardVO.copyCreateVO();

        } else {
            // *** 등록폼 ***
            model.addAttribute("pageType", "INSERT");
            if(Validate.isNotEmpty(userVo)) {
            	dataVO.setRegNm(userVo.getUserNm());            	
            }
        }
        
        //TODO 관리자 ID, 이름 추후 사이트에 맞게 변경
        /*if(!Validate.isEmpty(loginVo.getMgrId())) {
            dataVO.setRegId(loginVo.getMgrId());
            dataVO.setRegNm(loginVo.getMgrNm());
        }*/
        @SuppressWarnings({ "rawtypes", "unused" })
        List domainList = new ArrayList();        
        model.addAttribute(BoardConfConstant.KEY_DATA_VO, dataVO);
        model.addAttribute("domCd", boardVO.getExtColumn3());
        String url = getTemplateFolderName(request.getRequestURL().toString(), boardConfVO.getKindCd(), boardConfVO.getFormSkin());
        return url + "PD_boardForm";
    }
	
	/**
     * 게시물 등록 액션
     */
	@RequestMapping(params="df_method_nm=processBoardInsert", method = RequestMethod.POST)
    public String boardInsert(ModelMap model, HttpServletRequest request, @ModelAttribute BoardVO boardVO) throws Exception {
        setBoardService(request); // 게시판 유형 서비스 설정
        BoardConfVO boardConfVO = boardCacheService.findBoardConfig(boardVO.getBbsCd());
        String rtnUrl = "/egovframework/board/templates/admin/basic/PD_boardForm";

        // 자동 작성 방지 체크
        if("Y".equals(boardConfVO.getCaptchaYn())) {
            /*Captcha captcha = (Captcha) RequestUtil.getSessionAttribue(request, Captcha.NAME);
            // request.setCharacterEncoding("UTF-8");
            String answer = request.getParameter("answer");
            if(!captcha.isCorrect(answer)) {
                String message = "자동 작성 방지 문자를 다시 입력해주세요.";
                return alertAndBack(model, message);
            }*/
        }

        // GUBUN_UPLOADER_FLASH 일때는 파일 업로드를 하지 않는다.
        List<FileVO> fileList = new ArrayList<FileVO>();
        if(boardConfVO.getUploadType() == BoardConfConstant.GUBUN_UPLOADER_FORM) {
        	MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
        	List<MultipartFile> multiFiles = multiRequest.getFiles("multiFiles");
        	fileList = UploadHelper.upload(multiFiles, "board");

            // 폼 업로드시 업로드 파일 용량을 체크한다.
            if(!checkUploadFileSize(fileList, boardConfVO)) {
                if(boardService.fileDelete(fileList)) {
                    //return alertAndBack(model, Messages.COMMON_FILE_SIZE_OVER);
                	LOGGER.error("첨부파일 용량이 허용치보다 초과되었습니다.");
                	return rtnUrl;
                } else {
                    //return alertAndBack(model, Messages.COMMON_PROCESS_FAIL);
                	LOGGER.error("요청에 대한 처리가 실패되었습니다.");
                	return rtnUrl;
                }
            }
        }
    	
        UserVO userVO = SessionUtil.getUserInfo();
        
        if(Validate.isNotEmpty(userVO)) {
        	boardVO.setRegId(userVO.getLoginId());
        	boardVO.setRegNm(userVO.getUserNm());
        }
        
        boardVO.setIpAddr(request.getRemoteAddr());
        boardVO.setFileList(fileList);
        // 에디터 사용 상태가 아닌 경우 HTML 태그 제거
        if(boardConfVO.getMgrEditorYn().equals("N")) {
            //boardVO.setContents(Converter.XSS(boardVO.getContents()));
        }

        // 등록 실행
        Object key = boardService.boardInsert(boardVO, boardConfVO);
        if(Validate.isEmpty(key)) {
            //return alertAndBack(model, Messages.COMMON_PROCESS_FAIL);
        }
            
        return boardList(request, model, boardVO);
    }
	
	/**
     * 게시물 수정 액션
     */    
    //@RequestMapping(value = "ND_board.update.do", method = RequestMethod.POST)
	@RequestMapping(params="df_method_nm=boardUpdate", method = RequestMethod.POST)
    public String boardUpdate(ModelMap model, HttpServletRequest request, HttpServletResponse response
    		, @ModelAttribute BoardVO boardVO) throws Exception {
    	
        setBoardService(request); // 게시판 유형 서비스 설정
        BoardConfVO boardConfVO = boardCacheService.findBoardConfig(boardVO.getBbsCd());
        String rtnUrl = "/egovframework/board/templates/admin/basic/PD_boardForm";

        // 자동 작성 방지 체크
        /*if("Y".equals(boardConfVO.getCaptchaYn())) {
            Captcha captcha = (Captcha) RequestUtil.getSessionAttribue(request, Captcha.NAME);
            String answer = request.getParameter("answer");
            if(!captcha.isCorrect(answer)) {
                String message = "자동 작성 방지 문자를 다시 입력해주세요.";
                return alertAndBack(model, message);
            }
        }*/

        // *** 수정데이터 ***
        model.addAttribute("pageType", "UPDATE");
        BoardVO dataVO = boardService.boardView(boardVO, boardConfVO);
        if(dataVO == null) {
            //return alertAndBack(model, Messages.COMMON_NO_DATA);
        	return rtnUrl;
        }

        // GUBUN_UPLOADER_FLASH 일때는 파일 업로드를 하지 않는다.
        List<FileVO> fileList = new ArrayList<FileVO>();
        if(boardConfVO.getUploadType() == BoardConfConstant.GUBUN_UPLOADER_FORM) {
            //fileList = UploadHelper.upload(request, "board");
        	MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
        	List<MultipartFile> multiFiles = multiRequest.getFiles("multiFiles");
        	fileList = UploadHelper.upload(multiFiles, "board");

            // 폼 업로드시 업로드 파일 용량을 체크한다.
            if(!checkUploadFileSize(fileList, boardConfVO)) {
                if(boardService.fileDelete(fileList)) {
                    //return alertAndBack(model, Messages.COMMON_FILE_SIZE_OVER);
                	return rtnUrl;
                } else {
                    //return alertAndBack(model, Messages.COMMON_PROCESS_FAIL);
                	return rtnUrl;
                }
            }
        }

        // 검증
        /*ValidateResultHolder holder = ValidateUtil.validate(boardVO);
        if(holder.isValid()) {*/
            /*LoginVO loginVo = OpHelper.getMgrSession(request);
            if(!Validate.isEmpty(loginVo.getMgrId())) {
                boardVO.setModId(loginVo.getMgrId());
                boardVO.setModNm(loginVo.getMgrNm());
                boardVO.setMgrId(loginVo.getMgrId());
                boardVO.setMgrNm(loginVo.getMgrNm());
                boardVO.setDeptCd(loginVo.getDeptCd());
                boardVO.setDeptNm(loginVo.getDeptNm());
            }*/
            boardVO.setIpAddr(request.getRemoteAddr());
            boardVO.setFileList(fileList);
            // 에디터 사용 상태가 아닌 경우 HTML 태그 제거
            if(boardConfVO.getMgrEditorYn().equals("N")) {
                // boardVO.setContents(Converter.XSS(boardVO.getContents()));
            }

            // 수정 실행
            int result = boardService.boardUpdate(boardVO);
            if(StringUtil.ONE != result) {
                //return alertAndBack(model, Messages.COMMON_PROCESS_FAIL);
            	return rtnUrl;
            }
        /*} else {
            return alertAndBack(model, Messages.COMMON_VALIDATE_FAIL);
        }*/

        //String url = "BD_board.view.do?bbsCd=" + boardVO.getBbsCd() + "&seq=" + boardVO.getSeq() + "&" + OpHelper.getSearchQueryString(request);
        //return alertAndRedirect(model, Messages.COMMON_UPDATE_OK, url);
            
        if(boardConfVO.getFormSkin().equals("faq")) {
        	return boardList(request, model, boardVO);
        }else {
        	return boardView(model, request, null, boardVO);
        }                                
    }
	
	/**
     * 민원형 게시물 답글 등록
     */    
    //@RequestMapping(value = "ND_board.answer.do", method = RequestMethod.POST)
	@RequestMapping(params="df_method_nm=updateBoardAnswer", method = RequestMethod.POST)
    public String boardAnswer(ModelMap model, HttpServletRequest request, HttpServletResponse response, 
    		@ModelAttribute BoardVO boardVO) throws Exception {
		
        setBoardService(request); // 게시판 유형 서비스 설정
                
        UserVO userVO = SessionUtil.getUserInfo();
        BoardConfVO boardConfVO = boardCacheService.findBoardConfig(boardVO.getBbsCd());
        
        if(Validate.isNotEmpty(userVO)) {
        	boardVO.setMgrId(userVO.getLoginId());
        	boardVO.setMgrNm(userVO.getUserNm());
        }
        
        List<FileVO> fileList = new ArrayList<FileVO>();
        if(boardConfVO.getUploadType() == BoardConfConstant.GUBUN_UPLOADER_FORM) {
        	
        	MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
        	List<MultipartFile> multiFiles = multiRequest.getFiles("multiFiles");
        	fileList = UploadHelper.upload(multiFiles, "board");

            // 폼 업로드시 업로드 파일 용량을 체크한다.
            if(!checkUploadFileSize(fileList, boardConfVO)) {
                if(boardService.fileDelete(fileList)) {
                	LOGGER.error("첨부파일 용량이 허용치보다 초과되었습니다.");                	
                } else {
                	LOGGER.error("요청에 대한 처리가 실패되었습니다.");                	
                }
                
                return boardView(model, request, response, boardVO);
            }
        }
        
        boardVO.setIpAddr(request.getRemoteAddr());
        boardVO.setAnsFileList(fileList);
                
        boardService.boardAnswer(boardVO);

        /*String url = "BD_board.view.do?bbsCd=" + boardVO.getBbsCd() + "&seq=" + boardVO.getSeq() + "&" + OpHelper.getSearchQueryString(request);
        return alertAndRedirect(model, Messages.COMMON_INSERT_OK, url);*/
        return boardList(request, model, boardVO);
    }
	
	/**
     * 개별 파일 삭제(수정 폼 화면에서 Ajsx 방식으로 삭제)
     */
    //@RequestMapping(value = "ND_file.delete.do", method = RequestMethod.POST)
	@RequestMapping(params="df_method_nm=boardFileDeleteOne", method = RequestMethod.POST)
    public ModelAndView fileDelete(ModelMap model, FileVO fileVO, HttpServletRequest request) {
        setBoardService(request); // 게시판 유형 서비스 설정
        int affected = boardService.fileDelete(fileVO);
        ModelAndView mv = new ModelAndView();
        if(affected < 1) {
            return ResponseUtil.responseText(mv, StringUtil.ZERO);//responseJson(model, StringUtil.ZERO);
        }

        //return responseJson(model, affected);
        return ResponseUtil.responseText(mv, affected);        
    }
	
	/**
     * 게시물 목록 선택 완전 삭제
     * 
     * @param request
     * @param model
     */    
    //@RequestMapping(value = "ND_board.list.delete.do", method = RequestMethod.POST)
	@RequestMapping(params="df_method_nm=boardDeleteList", method = RequestMethod.POST)
    public String boardListDelete(HttpServletRequest request, ModelMap model, BoardVO boardVO) {
        setBoardService(request); // 게시판 유형 서비스 설정
        //OpHelper.bindSearchMap(boardVO, request);

        Integer cnt = boardService.boardListDelete(boardVO, true);
        if(cnt <= StringUtil.ZERO) {
            //return alertAndBack(model, Messages.COMMON_PROCESS_FAIL);
        }

        //String url = "BD_board.list.do?bbsCd=" + boardVO.getBbsCd() + "&" + OpHelper.getSearchQueryString(request);
        //return alertAndRedirect(model, Messages.COMMON_DELETE_OK, url);
        return boardList(request, model, boardVO);
    }
	
	/**
     * 게시물 한건 완전 삭제
     * 
     * @param request
     * @param model
     */    
	@RequestMapping(params="df_method_nm=deleteBoardOne", method = RequestMethod.POST)
    public String boardDelete(HttpServletRequest request, ModelMap model, BoardVO boardVO) {
        setBoardService(request); // 게시판 유형 서비스 설정        

        Integer cnt = boardService.boardDelete(boardVO, true);
        if(cnt != StringUtil.ONE) {
            //return alertAndBack(model, Messages.COMMON_PROCESS_FAIL);
        }
        
        return boardList(request, model, boardVO);
    }
	
	// 공지리스트 및 게시물 리스트를 셋팅.
    private void addNoticeBbsList(BoardVO boardVO, String listSkin, String contextPath, ModelMap model) {
    	int listTotalCount;
        List<BoardVO> list = null;
        List<BoardVO> noticeList = null;
        int rowperPage = Validate.isEmpty(boardVO.getDf_row_per_page()) 
        		? boardVO.getQ_rowPerPage() : boardVO.getDf_row_per_page();

        boardVO.setNoticeYn("N");        
        listTotalCount = boardService.boardListCount(boardVO);
        
	    // 페이저 빌드        
		Pager pager = new Pager.Builder().pageNo(boardVO.getDf_curr_page()).rowSize(rowperPage).totalRowCount(listTotalCount).build();
		pager.makePaging();
		boardVO.setLimitFrom(pager.getLimitFrom());
		boardVO.setLimitTo(pager.getLimitTo());
        
        list = boardService.boardList(boardVO, listSkin);
        boardVO.setNoticeYn("Y");
        noticeList = boardService.noticeList(boardVO, listSkin);

        if(listSkin.toLowerCase().contains("gallery")) {
            /*convertFilePaths(pager.getList(), contextPath);
            convertFilePaths(noticeList, contextPath);*/
        }
        @SuppressWarnings({ "rawtypes", "unused" })
        List domainList = new ArrayList();
        //model.addAttribute(BoardConfConstant.KEY_DATA_VO, boardService.domainList(boardVO));
        model.addAttribute("boardList", list);
        model.addAttribute("pager", pager);
        model.addAttribute("noticeList", noticeList);
    }
    
    /**
     * 각 템플릿별 베이스 URL("basePath/URI.do")
     */
    private String getTemplateFolderName(String url, Integer kindCd, String skinPath) {
        if(Validate.isNotEmpty(skinPath)) {
            if(skinPath.toLowerCase().contains("basic")) {
                skinPath = "basic";
            } else if(skinPath.toLowerCase().contains("petition")) {
                skinPath = "petition";
            } else if(skinPath.toLowerCase().contains("reply")) {
                skinPath = "reply";
            } else if(skinPath.toLowerCase().contains("gallery")) {
                skinPath = "gallery";
            } else if(skinPath.toLowerCase().contains("ebook")) {
                skinPath = "ebook";
            } else if(skinPath.toLowerCase().contains("faq")) {
                skinPath = "faq";
            } else {
                skinPath = "basic";
            }
            return ("/egovframework/board/templates/admin/" + skinPath + "/");
        } else if(Validate.isNotEmpty(kindCd)) {
            return ("/egovframework/board/templates/admin/" + getTemplateFolderName(kindCd) + "/");
        } else {
            return ("/egovframework/board/templates/admin/" + getTemplateFolderName(1001) + "/");
        }
    }
    
    /**
     * 각 템플릿별 폴더 이름을 가져온다.
     */
    private String getTemplateFolderName(Integer kindCd) {
        if(Validate.isEmpty(kindCd)) {
            return StringUtil.EMPTY;
        }
        switch(kindCd) {
            case BoardConfConstant.GUBUN_BOARD_BASIC:
                return "basic";
            case BoardConfConstant.GUBUN_BOARD_PETITION:
                return "petition";
            case BoardConfConstant.GUBUN_BOARD_REPLY:
                return "reply";
            case BoardConfConstant.GUBUN_BOARD_GALLERY:
                return "gallery";
            case BoardConfConstant.GUBUN_BOARD_EBOOK:
                return "ebook";
            case BoardConfConstant.GUBUN_BOARD_FAQ:
                return "faq";
            default:
                return "basic";
        }
    }
    
    // 폼 업로드시 업로드 파일 용량을 체크한다.
    private boolean checkUploadFileSize(List<FileVO> fileList, BoardConfVO boardConfVO) {
        Long totalFileSize = 0L;
        boolean uploadYn = true;
        // 업로드 파일 사이즈 제한이 있는 경우(사이즈 0일 경우 무제한 용량)
        for(FileVO baseFileVO : fileList) {
            try {
                Long fileSize = baseFileVO.getFileByteSize();

                if(boardConfVO.getMaxFileSize() > 0) {
                    Long maxFileSize = Long.valueOf(((Integer) (boardConfVO.getMaxFileSize() * 1024 * 1024)).toString());
                    if(fileSize > maxFileSize) {
                        uploadYn = false;
                    }
                }
                totalFileSize += fileSize;
            } catch (Exception e) {
                uploadYn = false;
            }
        }
        // 업로드 총 파일 사이즈 제한이 있는 경우
        if(boardConfVO.getTotalFileSize() > 0) {
            Long totalMaxFileSize = Long.valueOf(((Integer) (boardConfVO.getTotalFileSize() * 1024 * 1024)).toString());
            if(totalFileSize > totalMaxFileSize) {
                return false;
            }
        }
        return uploadYn;
    }
    
    /**
	 * 에디터 업로드
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(params="df_method_nm=processUploadEditor", method = RequestMethod.POST)
	public ModelAndView processUploadEditor(ModelMap model, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> fileResult = insertImageFile(request);
		
		mv.addObject("CKEditor", request.getAttribute("CKEditor"));
		mv.addObject("CKEditorFuncNum", request.getAttribute("CKEditorFuncNum"));
		mv.addObject("langCode", request.getAttribute("langCode"));
		mv.addObject("fileUrl", fileResult.get("fileUrl"));
		
		mv.setViewName("/cmm/ND_UICMC0008");
		
		return mv;
	}

	/**
	 * 파일(이미지) 업로드
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	private Map<String, Object> insertImageFile(HttpServletRequest request) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		
		StringBuffer sb = new StringBuffer();
		
		MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest) request;
		if(Validate.isEmpty(mptRequest)) {
			result.put("result", "N");
			return result;
		}
		
		sb = new StringBuffer();
		sb.append("upload");
		
		List<MultipartFile> multipartFiles = mptRequest.getFiles(sb.toString());
		if(Validate.isEmpty(multipartFiles)) {
			result.put("result", "N");
			return result;
		}
		if(multipartFiles.get(0).isEmpty()) {
			result.put("result", "N");
			return result;
		}
		
		List<FileVO> fileList = new ArrayList<FileVO>();
		fileList = UploadHelper.upload(multipartFiles, "editor");
		int fileSeq = fileDao.saveFile(fileList,-1);
			
		// 파일 업로드 성공
		if(fileList.size() > 0 && fileSeq > -1) {
			result.put("fileUrl", request.getRequestURL().toString().replace(request.getRequestURI(),"")+"/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=" + fileSeq);
			result.put("result", "Y");
			return result;
		// 파일 업로드 실패
		} else {
			result.put("result", "N");
			return result;
		}
	}
	
	/**
     * 게시물 댓글 목록 액션(Ajax)
     */
	@RequestMapping(params="df_method_nm=processBoardAnswerListAjax", method = RequestMethod.POST)	
	public ModelAndView boardAnswerListAjax(HttpServletRequest request, ModelMap model) throws Exception {
		ModelAndView mv = new ModelAndView("/egovframework/board/templates/admin/common/INC_boardAnswerList");
		
		HashMap params = new HashMap();
		
		params.put("bbsCd", request.getParameter("bbsCd"));
		params.put("seq", request.getParameter("seq"));
		
		// 게시물 댓글 목록 갯수
		int listTotalCount = boardService.boardAnswerListCount(params);
		
		int answer_curr_page = Validate.isEmpty(request.getParameter("answer_curr_page")) ?
				1 : Integer.parseInt(request.getParameter("answer_curr_page"));
		int answer_row_per_page = Validate.isEmpty(request.getParameter("answer_row_per_page")) ?
				5 : Integer.parseInt(request.getParameter("answer_row_per_page"));
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(answer_curr_page).rowSize(answer_row_per_page).totalRowCount(listTotalCount).build();
		pager.makePaging();
		params.put("limitFrom", pager.getLimitFrom());
		params.put("limitTo", pager.getLimitTo());
		
		// 게시물 댓글 목록
		List<HashMap> list = boardService.boardAnswerList(params);
		
		mv.addObject("boardAnswerList", list);
		mv.addObject("boardAnswerPager", pager);
        
        return mv;
    }
	
	/**
     * 게시물 댓글 삭제 액션(Ajax)
     */
	@RequestMapping(params="df_method_nm=processBoardAnswerSeqDeleteAjax", method = RequestMethod.POST)	
	public ModelAndView boardAnswerSeqDeleteAjax(HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		HashMap params = new HashMap();
		
		params.put("bbsCd", request.getParameter("bbsCd"));
		params.put("seq", request.getParameter("seq"));
		params.put("answerSeq", request.getParameter("answerSeq"));
		
		// 삭제 실행
		int key = boardService.boardAnswerSeqDelete(params);
		
		if(key < 1) {
			return ResponseUtil.responseJson(mv, Boolean.FALSE, messageSource.getMessage("fail.common.delete", new String[] {"댓글"}, locale));
		} else {
			return ResponseUtil.responseJson(mv, Boolean.TRUE, messageSource.getMessage("success.common.delete", new String[] {"댓글"}, locale));
		}
    }
}
