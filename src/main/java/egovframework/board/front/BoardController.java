/*
 * Copyright (c) 2012 ZES Inc. All rights reserved.
 * This software is the confidential and proprietary information of ZES Inc.
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with ZES Inc. (http://www.zesinc.co.kr/)
 */
package egovframework.board.front;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.comm.page.Pager;
import com.comm.user.UserVO;
import com.infra.file.FileVO;
import com.infra.file.UploadHelper;
import com.infra.util.Converter;
import com.infra.util.CookieUtil;
import com.infra.util.FileUtil;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;
import biz.tech.cs.PGCS0070Service; //test

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import egovframework.board.admin.BoardService;
import egovframework.board.admin.BoardVO;
import egovframework.board.config.BoardCacheService;
import egovframework.board.config.BoardConfConstant;
import egovframework.board.config.BoardConfVO;
import egovframework.board.util.SpringHelper;
import egovframework.com.uss.olp.qim.web.EgovQustnrItemManageController;

/**
 * @author dongwoo
 *
 */
@Controller("boardFrontController")
@RequestMapping(value= {"/PGBS{bbsCd}.do"})
public class BoardController{

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovQustnrItemManageController.class);
	
	private Locale locale = Locale.getDefault();
	
	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	@Resource(name = "boardValidator")
	private BoardValidator boardValidator;
		
	@Autowired
    private BoardCacheService boardCacheService;
	
	private BoardService boardService;

    public void setBoardService(HttpServletRequest request) {
        this.boardService = getBoardServiceName(request);
    }
    
    public void setBoardService(HttpServletRequest request, int bbsCd) {
        this.boardService = getBoardServiceName(request, bbsCd);
    }
    
    public void setBoardService(HttpServletRequest request, String pageType) {
        this.boardService = getBoardServiceName(request, pageType);
    }
    
    public void setBoardService(HttpServletRequest request, String pageType, int bbsCd) {
        this.boardService = getBoardServiceName(request, pageType, bbsCd);
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
     * 게시판 유형별 서비스 설정(bbsCd 추가)
     * 20160718 추가
     */
    private BoardService getBoardServiceName(HttpServletRequest request, int bbsCd) {
        String serviceName = "";
        //BoardConfVO boardConfVO = (BoardConfVO) Cache.get(BoardConfCache.BBS_CD_KEY + request.getParameter("bbsCd"));
        BoardConfVO boardConfVO = boardCacheService.findBoardConfig(bbsCd);
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
     * 게시판 유형별 서비스 설정(템플릿별, bbsCd 추가)
     */
    private BoardService getBoardServiceName(HttpServletRequest request, String pageType, int bbsCd) {
        String serviceName = "", skinName = "";
        //BoardConfVO boardConfVO = (BoardConfVO) Cache.get(BoardConfCache.BBS_CD_KEY + request.getParameter("bbsCd"));
        BoardConfVO boardConfVO = boardCacheService.findBoardConfig(bbsCd);

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
    public String boardList(HttpServletRequest request, ModelMap model
    		, @ModelAttribute("boardVO") BoardVO boardVO
    		, @PathVariable int bbsCd){
		
		//bbsCd가 parameter로 전달되지 않은 경우PathVariable로 세팅 
		setDefaultBbsCd(request, bbsCd, model);
		
		// 게시판 유형 서비스 설정
        setBoardService(request, "L", bbsCd);
                
        //캐싱된 게시판 설정을 가져온다.
		BoardConfVO boardConfVO = boardCacheService.findBoardConfig(bbsCd);
		
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

        boardVO.setCutTitleNum(boardConfVO.getCutTitleNum());
        model.addAttribute(BoardConfConstant.KEY_CONF_VO, boardConfVO);
        model.addAttribute("pageType", "LIST");        
        addNoticeBbsList(boardVO, boardConfVO.getListSkin(), request.getSession().getServletContext().getRealPath("/"), model);

        String url = getTemplateFolderName(request.getRequestURL().toString(), boardConfVO.getKindCd(), boardConfVO.getListSkin());        
        return url + "BD_boardList";
    }
	
	/**
     * 게시물 상세 조회
     */
	@RequestMapping(params="df_method_nm=boardView")
    public String boardView(ModelMap model, HttpServletRequest request, HttpServletResponse response, @ModelAttribute BoardVO boardVO)
        throws Exception {
		
		// 권한확인로직 : 게시물등록자이름과 사용자세션이름이 일치하는지 확인
		HttpSession session = request.getSession();
		int bbsCd = 0;
		if(session.getAttribute("SESSION_BBSCD") != null) {
			bbsCd = (Integer)session.getAttribute("SESSION_BBSCD");
			session.removeAttribute("SESSION_BBSCD");
			boardVO.setBbsCd(bbsCd);
		} else {
			bbsCd = boardVO.getBbsCd();
		}
		
        BoardConfVO boardConfVO2 = boardCacheService.findBoardConfig(boardVO.getBbsCd());
        BoardVO dataVO2 = boardService.boardView(boardVO, boardConfVO2);
        String RegId = dataVO2.getRegId();
        String UserId = "";
        if(SessionUtil.getUserInfo() != null)
        	UserId = SessionUtil.getUserInfo().getLoginId();
        
        if( bbsCd == 1005){ //1005: 나의묻고답하기
            if( UserId != "" && !RegId.toString().equals(UserId.toString()) ) {
	            //LOGGER.error("게시물등록자와 사용자세션이 불일치합니다.");
	        	//LOGGER.debug("게시물등록자와 사용자세션이 불일치합니다.");
	        	//LOGGER.debug("---------1start---------" +RegId +"-----------1end----------");
	        	//LOGGER.debug("---------1start---------" +UserId +"-----------1end----------");
	        	//LOGGER.debug("---------1start---------" +bbsCd +"-----------1end----------");
	            
	        	String url = "";
	            return url;
            }
         }
    
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

        //TODO 질문형 게시판의 경우 로그인 아이디에 해당하는 게시물만 보여줌.
        if(boardConfVO.getViewSkin().equals("petition")) {
        	UserVO userVO = SessionUtil.getUserInfo();
        	if(Validate.isEmpty(userVO)) {
        		boardVO.setUserKey("");
        	}else {
        		boardVO.setUserKey(userVO.getLoginId());
        	}        	
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
        @SuppressWarnings({ "rawtypes", "unused" })
        List domainList = new ArrayList();
        //model.addAttribute("domList", boardService.domainList(boardVO));
        model.addAttribute("pageType", "VIEW");
        model.addAttribute(BoardConfConstant.KEY_CONF_VO, boardConfVO);
        model.addAttribute(BoardConfConstant.KEY_DATA_VO, dataVO);

        if(boardConfVO.getListViewCd() == BoardConfConstant.GUBUN_LISTVIEW_LIST) {
            addNoticeBbsList(boardVO, boardConfVO.getListSkin(), request.getSession().getServletContext().getRealPath("/"), model);
        }

        String url = getTemplateFolderName(request.getRequestURL().toString(), boardConfVO.getKindCd(), boardConfVO.getViewSkin());
        return url + "BD_boardView";
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
        @RequestParam(value = "pageType", required = true) String pageType, 
        @PathVariable int bbsCd) throws Exception {
		
		UserVO userVO = SessionUtil.getUserInfo();
        setBoardService(request, "F", bbsCd); // 게시판 유형 서비스 설정
        
        BoardConfVO boardConfVO = boardCacheService.findBoardConfig(boardVO.getBbsCd());
        model.addAttribute(BoardConfConstant.KEY_CONF_VO, boardConfVO);

        BoardVO dataVO = new BoardVO();
        dataVO.setBbsCd(boardVO.getBbsCd());

        if("UPDATE".equals(pageType)) {
        	// 권한확인로직 : 게시물등록자이름과 사용자세션이름이 일치하는지 확인
            BoardConfVO boardConfVO2 = boardCacheService.findBoardConfig(boardVO.getBbsCd());
            BoardVO dataVO2 = boardService.boardView(boardVO, boardConfVO2);
            String RegId = dataVO2.getRegId();
            String UserId = SessionUtil.getUserInfo().getLoginId();
            
            if( !RegId.toString().equals(UserId.toString()) ){
                //LOGGER.error("게시물등록자와 사용자세션이 불일치합니다.");
            	//LOGGER.debug("---------1start---------" +RegId +"-----------1end----------");
            	//LOGGER.debug("---------1start---------" +UserId +"-----------1end----------");
                
            	String url = "";
                return url;
             }
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
            if(!Validate.isEmpty(userVO)) {
            	dataVO.setRegId(userVO.getLoginId());
            	dataVO.setRegNm(userVO.getUserNm());
        	}
        }
        
        @SuppressWarnings({ "rawtypes", "unused" })
        List domainList = new ArrayList();        
        model.addAttribute(BoardConfConstant.KEY_DATA_VO, dataVO);
        model.addAttribute("domCd", boardVO.getExtColumn3());
        String url = getTemplateFolderName(request.getRequestURL().toString(), boardConfVO.getKindCd(), boardConfVO.getFormSkin());
        return url + "BD_boardForm";
    }
	
	/**
     * 게시물 등록 액션
     */
	@RequestMapping(params="df_method_nm=processBoardInsert", method = RequestMethod.POST)
    public String boardInsert(ModelMap model, HttpServletRequest request, 
    		@ModelAttribute BoardVO boardVO,
    		BindingResult bindResult) throws Exception {		
		
		setBoardService(request); // 게시판 유형 서비스 설정
        BoardConfVO boardConfVO = boardCacheService.findBoardConfig(boardVO.getBbsCd());
        String rtnUrl = getTemplateFolderName(request.getRequestURL().toString(), boardConfVO.getKindCd(), boardConfVO.getFormSkin()) + "BD_boardForm";
        UserVO userVO = SessionUtil.getUserInfo();
        
		//검증
		boardValidator.validate(boardVO, bindResult);
		if(bindResult.hasErrors()) {			
			errorPostPro(model, bindResult, boardVO, boardConfVO, "INSERT");
			return rtnUrl;
		}		        

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
                	model.addAttribute("message", messageSource.getMessage("errors.file.oversize", null, locale));
                } else {
                	model.addAttribute("message", messageSource.getMessage("errors.file.oversize", null, locale));                	
                }
                model.addAttribute(BoardConfConstant.KEY_CONF_VO, boardConfVO);
		        model.addAttribute(BoardConfConstant.KEY_DATA_VO, boardVO);
		        model.addAttribute("pageType", "INSERT");
                return rtnUrl;
            }
        }      
        
    	if(!Validate.isEmpty(userVO)) {
    		boardVO.setRegId(userVO.getLoginId());
    		boardVO.setRegNm(userVO.getUserNm());
    	}
    
        boardVO.setIpAddr(request.getRemoteAddr());
        boardVO.setFileList(fileList);
        // 에디터 사용 상태가 아닌 경우 HTML 태그 제거
        if(boardConfVO.getMgrEditorYn().equals("N")) {
            // boardVO.setContents(Converter.XSS(boardVO.getContents()));
        }
        
        // 등록 실행
        Object key = boardService.boardInsert(boardVO, boardConfVO);
        
        if(Validate.isEmpty(key)) {
        	model.addAttribute("message", messageSource.getMessage("fail.common.insert", new String[] {"게시물"}, locale));
        }else {
        	model.addAttribute("message", messageSource.getMessage("success.common.insert", new String[] {"게시물"}, locale));
        }
        
        model.addAttribute(BoardConfConstant.KEY_CONF_VO, boardConfVO);
        model.addAttribute(BoardConfConstant.KEY_DATA_VO, boardVO);
        model.addAttribute("pageType", "INSERT");        
        model.addAttribute("rtnCode", StringUtil.ONE);
        
        return rtnUrl;
    }
	
	/**
     * 게시물 등록 액션(AjaxSubmit)
     */
	@RequestMapping(params="df_method_nm=processBoardInsertAjax", method = RequestMethod.POST)
    public ModelAndView boardInsertAjax(ModelMap model, HttpServletRequest request, 
    		@ModelAttribute BoardVO boardVO,
    		BindingResult bindResult) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		// 20160718 웹 취약점 보완으로 인한 게시판번호 세션화 작업
		HttpSession session = request.getSession();
		int bbsCd = 0;
		if(session.getAttribute("SESSION_BBSCD") != null) {
			bbsCd = (Integer)session.getAttribute("SESSION_BBSCD");
			session.removeAttribute("SESSION_BBSCD");
			boardVO.setBbsCd(bbsCd);
		} else {
			bbsCd = boardVO.getBbsCd();
		}
		setBoardService(request, bbsCd); // 게시판 유형 서비스 설정
        BoardConfVO boardConfVO = boardCacheService.findBoardConfig(bbsCd);        
        UserVO userVO = SessionUtil.getUserInfo();
        
		//검증
		boardValidator.validate(boardVO, bindResult);
		if(bindResult.hasErrors()) {			
			errorPostPro(model, bindResult, boardVO, boardConfVO, "INSERT");
			return ResponseUtil.responseJson(mv, Boolean.FALSE, model.get("message"));
		}		        

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
        
        // 게시물 반복 등록 검사
        if(boardService.boardRepeatInsertCheck(boardVO)) {
        	LOGGER.debug("게시물이 반복적으로 등록되었음");
        	return ResponseUtil.responseJson(mv, Boolean.FALSE, messageSource.getMessage("fail.common.insert", new String[] {"게시물"}, locale));
        }
        
        //권한확인로직 : 공지사항등록 페이지인지 확인, 관리자 권한인지 확인
        PGCS0070Service pgcs = new PGCS0070Service();
        
        if(bbsCd == 1001 && !pgcs.isAdminAuth(userVO)) { //공지사항 페이지이고, 관리자권한이 아니라면
        	//LOGGER.error("관리자 권한이 아닙니다.");
    	    //LOGGER.debug("관리자 권한이 아닙니다.");
        	
    	    //return ResponseUtil.responseJson(mv, Boolean.FALSE, messageSource.getMessage("fail.common.insert", null, locale));
    	    //return ResponseUtil.responseJson(mv, Boolean.FALSE, model.get("message"));
    	    return null;
        }
        
        // GUBUN_UPLOADER_FLASH 일때는 파일 업로드를 하지 않는다.
        List<FileVO> fileList = new ArrayList<FileVO>();
        if(boardConfVO.getUploadType() == BoardConfConstant.GUBUN_UPLOADER_FORM) {

        	MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
        	List<MultipartFile> multiFiles = multiRequest.getFiles("multiFiles");
        	fileList = UploadHelper.upload(multiFiles, "board");
        	
        	// 폼 업로드 시 확장명을 체크한다.
        	if(!checkUploadFileExt(fileList, boardConfVO)) {
        		boardService.fileDelete(fileList);
            	
                return ResponseUtil.responseJson(mv, Boolean.FALSE, messageSource.getMessage("errors.file.notExt", null, locale));
        	}
        	
            // 폼 업로드시 업로드 파일 용량을 체크한다.
            if(!checkUploadFileSize(fileList, boardConfVO)) {
            	
            	boardService.fileDelete(fileList);
            	
                return ResponseUtil.responseJson(mv, Boolean.FALSE, messageSource.getMessage("errors.file.oversize", null, locale));
            }
        }      
        
    	if(!Validate.isEmpty(userVO)) {
    		boardVO.setRegId(userVO.getLoginId());
    		boardVO.setRegNm(userVO.getUserNm());
    	}
    
        boardVO.setIpAddr(request.getRemoteAddr());
        boardVO.setFileList(fileList);
        // 에디터 사용 상태가 아닌 경우 HTML 태그 제거
        if(boardConfVO.getMgrEditorYn().equals("N")) {
            // boardVO.setContents(Converter.XSS(boardVO.getContents()));
        }
        
        // 등록 실행
        Object key = boardService.boardInsert(boardVO, boardConfVO);
        if(Validate.isEmpty(key)) {        	
        	return ResponseUtil.responseJson(mv, Boolean.FALSE, messageSource.getMessage("fail.common.insert", new String[] {"게시물"}, locale));
        }else {
        	return ResponseUtil.responseJson(mv, Boolean.TRUE, messageSource.getMessage("success.common.insert", new String[] {"게시물"}, locale));
        }        
    }
	
	/**
     * 게시물 수정 액션
     */
	@RequestMapping(params="df_method_nm=boardUpdate", method = RequestMethod.POST)
    public String boardUpdate(ModelMap model, HttpServletRequest request, HttpServletResponse response
    		, @ModelAttribute BoardVO boardVO
    		, BindingResult bindResult) throws Exception {
		
        setBoardService(request); // 게시판 유형 서비스 설정
        BoardConfVO boardConfVO = boardCacheService.findBoardConfig(boardVO.getBbsCd());
        String rtnUrl = getTemplateFolderName(request.getRequestURL().toString(), boardConfVO.getKindCd(), boardConfVO.getFormSkin()) + "BD_boardForm";
        
        //검증
		boardValidator.validate(boardVO, bindResult);
		if(bindResult.hasErrors()) {			
			errorPostPro(model, bindResult, boardVO, boardConfVO, "INSERT");
		
			return rtnUrl;
		}
      		
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
        	model.addAttribute("message", messageSource.getMessage("info.noarticle.msg", null, locale));
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

        //String url = "BD_board.view.do?bbsCd=" + boardVO.getBbsCd() + "&seq=" + boardVO.getSeq() + "&" + OpHelper.getSearchQueryString(request);
        //return alertAndRedirect(model, Messages.COMMON_UPDATE_OK, url);
        return boardView(model, request, null, boardVO);
    }
	
	/**
     * 게시물 수정 액션
     */
	@RequestMapping(params="df_method_nm=boardUpdateAjax", method = RequestMethod.POST)
    public ModelAndView boardUpdateAjax(ModelMap model, HttpServletRequest request, HttpServletResponse response
    		, @ModelAttribute BoardVO boardVO
    		, BindingResult bindResult) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
        setBoardService(request); // 게시판 유형 서비스 설정
        BoardConfVO boardConfVO = boardCacheService.findBoardConfig(boardVO.getBbsCd());
        String rtnUrl = getTemplateFolderName(request.getRequestURL().toString(), boardConfVO.getKindCd(), boardConfVO.getFormSkin()) + "BD_boardForm";
        
        //검증
		boardValidator.validate(boardVO, bindResult);
		if(bindResult.hasErrors()) {			
			errorPostPro(model, bindResult, boardVO, boardConfVO, "INSERT");		
			return ResponseUtil.responseJson(mv, Boolean.FALSE, model.get("message"));
		}
      		
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
        	return ResponseUtil.responseJson(mv, Boolean.FALSE, messageSource.getMessage("info.noarticle.msg", null, locale));
        }

        // GUBUN_UPLOADER_FLASH 일때는 파일 업로드를 하지 않는다.
        List<FileVO> fileList = new ArrayList<FileVO>();
        if(boardConfVO.getUploadType() == BoardConfConstant.GUBUN_UPLOADER_FORM) {
            //fileList = UploadHelper.upload(request, "board");
        	MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
        	List<MultipartFile> multiFiles = multiRequest.getFiles("multiFiles");
        	fileList = UploadHelper.upload(multiFiles, "board");
        	
        	// 폼 업로드 시 확장명을 체크한다.
        	if(!checkUploadFileExt(fileList, boardConfVO)) {
        		boardService.fileDelete(fileList);
            	
                return ResponseUtil.responseJson(mv, Boolean.FALSE, messageSource.getMessage("errors.file.notExt", null, locale));
        	}
        	
            // 폼 업로드시 업로드 파일 용량을 체크한다.
            if(!checkUploadFileSize(fileList, boardConfVO)) {
                boardService.fileDelete(fileList);
                
                return ResponseUtil.responseJson(mv, Boolean.FALSE, messageSource.getMessage("errors.file.oversize", null, locale));               
            }
        }
        
        boardVO.setIpAddr(request.getRemoteAddr());
        boardVO.setFileList(fileList);
        // 에디터 사용 상태가 아닌 경우 HTML 태그 제거
        if(boardConfVO.getMgrEditorYn().equals("N")) {
            // boardVO.setContents(Converter.XSS(boardVO.getContents()));
        }

        // 권한확인로직 : 게시물등록자이름과 사용자세션이름이 일치하는지 확인
        // setRegNm후
        String RegId = dataVO.getRegId();
        String UserId = SessionUtil.getUserInfo().getLoginId();
		
        if( !RegId.toString().equals(UserId.toString()) ){
            //LOGGER.error("게시물등록자와 사용자세션이 불일치합니다.");
            //LOGGER.debug("---------1start---------" +RegId +"-----------1end----------");
            //LOGGER.debug("---------1start---------" +UserId +"-----------1end----------");
            
            return ResponseUtil.responseJson(mv, Boolean.FALSE, model.get("message"));
         }
        
        // 수정 실행
        int result = boardService.boardUpdate(boardVO);
        if(StringUtil.ONE != result) {
        	return ResponseUtil.responseJson(mv, Boolean.FALSE, messageSource.getMessage("fail.common.update", new String[] {"게시물"}, locale));
        }else {
        	return ResponseUtil.responseJson(mv, Boolean.TRUE, messageSource.getMessage("success.common.update", new String[] {"게시물"}, locale));
        }
        
    }
	
	/**
     * 개별 파일 삭제(수정 폼 화면에서 Ajsx 방식으로 삭제)
     */
	@RequestMapping(params="df_method_nm=boardFileDeleteOne", method = RequestMethod.POST)
    public ModelAndView fileDelete(ModelMap model, FileVO fileVO, HttpServletRequest request) {
        setBoardService(request); // 게시판 유형 서비스 설정
        int affected = boardService.fileDelete(fileVO);
        ModelAndView mv = new ModelAndView();
        
        if(affected < 1) {
            return ResponseUtil.responseText(mv, StringUtil.ZERO);
        }

        return ResponseUtil.responseText(mv, affected);        
    }
	
	/**
     * 게시물 목록 선택 완전 삭제
     * 
     * @param request
     * @param model
     */
	@RequestMapping(params="df_method_nm=boardDeleteList", method = RequestMethod.POST)
    public String boardListDelete(HttpServletRequest request, ModelMap model, BoardVO boardVO) {
        setBoardService(request); // 게시판 유형 서비스 설정       

        Integer cnt = boardService.boardListDelete(boardVO, true);
        if(cnt <= StringUtil.ZERO) {
            //return alertAndBack(model, Messages.COMMON_PROCESS_FAIL);
        }

        return boardList(request, model, boardVO, boardVO.getBbsCd());
    }
	
	/**
     * 게시물 삭제
     * 
     * @param request
     * @param model
	 * @throws Exception 
     */
	@RequestMapping(params="df_method_nm=deleteBoardOne", method = RequestMethod.POST)
    public String boardDelete(HttpServletRequest request, HttpServletResponse response, ModelMap model, BoardVO boardVO) throws Exception {
		// 권한확인로직 : 게시물등록자이름과 사용자세션이름이 일치하는지 확인
        BoardConfVO boardConfVO = boardCacheService.findBoardConfig(boardVO.getBbsCd());
        BoardVO dataVO = boardService.boardView(boardVO, boardConfVO);
        String RegId = dataVO.getRegId();
        String UserId = SessionUtil.getUserInfo().getLoginId();
		
        if( !RegId.toString().equals(UserId.toString()) ){
            //LOGGER.error("게시물등록자와 사용자세션이 불일치합니다.");
        	//LOGGER.debug("---------1start---------" +RegId +"-----------1end----------");
        	//LOGGER.debug("---------1start---------" +UserId +"-----------1end----------");
                    	
            model.addAttribute("message", messageSource.getMessage("fail.common.delete", null, locale));        	
        	return boardView(model, request, response, boardVO);
         }
		
		setBoardService(request); // 게시판 유형 서비스 설정
        
        Integer cnt = boardService.boardDelete(boardVO, true);
        
        if(cnt < StringUtil.ONE) {
        	model.addAttribute("message", messageSource.getMessage("fail.common.delete", new String[] {"게시물"}, locale));        	
        	return boardView(model, request, response, boardVO);
        }
        model.addAttribute("message", messageSource.getMessage("success.common.delete", new String[] {"게시물"}, locale)); 
        return boardList(request, model, boardVO, boardVO.getBbsCd());
    }
	
	/**
     * 비공개 게시물 비밀번호 확인 폼
     */    
    @RequestMapping(params="df_method_nm=boardPwdForm")
    public String boardPwdForm(ModelMap model, HttpServletRequest request, @ModelAttribute BoardVO boardVO) throws Exception {
        setBoardService(request); // 게시판 유형 서비스 설정
        //String url = getTemplateFolderName(request.getRequestURL().toString(), null, null);
        return "/egovframework/board/templates/front/common/PD_pwdForm";
    }
    
    /**
     * 비공개 게시물 비밀번호 확인
     */
    @RequestMapping(params="df_method_nm=boardPwdConfirm", method = RequestMethod.POST)
    public ModelAndView boardPwdConfirm(ModelMap model, HttpServletRequest request, @ModelAttribute BoardVO boardVO) throws Exception {
        setBoardService(request); // 게시판 유형 서비스 설정
        
        ModelAndView mv = new ModelAndView();
        BoardConfVO boardConfVO = boardCacheService.findBoardConfig(boardVO.getBbsCd());        
        boolean result = false;
        
        BoardVO dataVO = boardService.boardView(boardVO, boardConfVO);
        if(boardVO.getRegPwd().equals(dataVO.getRegPwd())) {
            result = true;
        }
        return ResponseUtil.responseJson(mv, result);//responseJson(model, result);
    }
	
	// 공지리스트 및 게시물 리스트를 셋팅.
    private void addNoticeBbsList(BoardVO boardVO, String listSkin, String contextPath, ModelMap model) {
    	int listTotalCount;
        List<BoardVO> list = null;
        List<BoardVO> noticeList = null;
        int rowperPage = Validate.isEmpty(boardVO.getDf_row_per_page()) 
        		? boardVO.getQ_rowPerPage() : boardVO.getDf_row_per_page();
        
        //TODO 질문형 게시판의 경우 로그인 아이디에 해당하는 게시물만 보여줌.
        if(listSkin.equals("petition")) {
        	UserVO userVO = SessionUtil.getUserInfo();
        	if(Validate.isEmpty(userVO)) {
        		boardVO.setUserKey("");
        	}else {
        		boardVO.setUserKey(userVO.getLoginId());
        	}        	
        }

        boardVO.setNoticeYn("N");
        // front에서 FAQ게시판은 비공개글 제외
        if(listSkin.toLowerCase().contains("faq")) {
        	boardVO.setExcludeOpenN("Y");
        }
        
        listTotalCount = boardService.boardListCount(boardVO);
        
	    // 페이저 빌드        
		Pager pager = new Pager.Builder().pageNo(boardVO.getDf_curr_page()).rowSize(rowperPage).totalRowCount(listTotalCount).build();
		pager.makePaging();
		boardVO.setLimitFrom(pager.getLimitFrom());
		boardVO.setLimitTo(pager.getLimitTo());
        
        list = boardService.boardList(boardVO, listSkin);
        boardVO.setNoticeYn("Y");
        noticeList = boardService.noticeList(boardVO, listSkin);
        
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
            return ("/egovframework/board/templates/front/" + skinPath + "/");
        } else if(Validate.isNotEmpty(kindCd)) {
            return ("/egovframework/board/templates/front/" + getTemplateFolderName(kindCd) + "/");
        } else {
            return ("/egovframework/board/templates/front/" + getTemplateFolderName(1001) + "/");
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
    
    /**
     * 폼 업로드시 확장명을 체크한다. 2017-04-06 웹 취약점 조치 사항
     */
    private boolean checkUploadFileExt(List<FileVO> fileList, BoardConfVO boardConfVO) {
    	boolean fileUploadYN = true;
        String extList = boardConfVO.getFileExts();
        LOGGER.debug("EXTS : " + extList);
        String[] exts = extList.split("\\|");
        for(String ext : exts) {
        	LOGGER.debug("EXT : " + ext);
        }
        
        for(FileVO baseFileVO : fileList) {
        	String fileName = baseFileVO.getLocalNm();
        	String fileExt = baseFileVO.getFileExt();
        	boolean fileExtYN = FileUtil.hasExtension(exts, fileExt);
        	LOGGER.debug("----------------------------------------");
        	LOGGER.debug("FILE NAME : " + fileName);
        	LOGGER.debug("FILE EXT : " + fileExt);
        	LOGGER.debug("FILEEXTYN : " + fileExtYN);
        	LOGGER.debug("----------------------------------------");
        	if(!fileExtYN) {
        		fileUploadYN = false;
        	}
        }
        return fileUploadYN;
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
    
    private void setDefaultBbsCd(HttpServletRequest request, int bbsCd, ModelMap model) {
    	if(Validate.isEmpty(request.getParameter("bbsCd"))) {
    		model.addAttribute("bbsCd", bbsCd);
    	}else {
    		model.addAttribute("bbsCd", request.getParameter("bbsCd"));
    	}
    }
    
    private void errorPostPro(ModelMap model, BindingResult result, BoardVO boardVO, BoardConfVO boardConfVO, String pageType) {
    	for (Object object : result.getAllErrors()) {
		    if(object instanceof ObjectError) {
		        ObjectError objectError = (ObjectError) object;
		        model.addAttribute("message", messageSource.getMessage(objectError.getCode(), objectError.getArguments(), locale));
		        model.addAttribute(BoardConfConstant.KEY_CONF_VO, boardConfVO);
		        model.addAttribute(BoardConfConstant.KEY_DATA_VO, boardVO);
		        model.addAttribute("pageType", "INSERT");
		        break;
		    }
		}
    }
    
    /**
     * 게시물 댓글 등록 액션(Ajax)
     */
	@RequestMapping(params="df_method_nm=processBoardAnswerInsertAjax", method = RequestMethod.POST)	
	public ModelAndView boardAnswerInsertAjax(HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		UserVO userVO = SessionUtil.getUserInfo();
		
		HashMap params = new HashMap();
		
		// 로그인 상태 확인(로그인 한 대상만 가능함)
		if(!Validate.isEmpty(userVO)) {
    		params.put("regId", userVO.getLoginId());
    		params.put("regNm", userVO.getUserNm());
    	} else {
    		return ResponseUtil.responseJson(mv, Boolean.FALSE, messageSource.getMessage("fail.common.insert", new String[] {"댓글"}, locale));
    	}
		
		params.put("bbsCd", request.getParameter("bbsCd"));
		params.put("seq", request.getParameter("seq"));
		params.put("answerCn", request.getParameter("answerCn"));
		
		// 게시물 댓글 반복 등록 검사
        if(boardService.boardAnswerRepeatInsertCheck(params)) {
        	LOGGER.debug("댓글이 반복적으로 등록되었음");
        	return ResponseUtil.responseJson(mv, Boolean.FALSE, messageSource.getMessage("fail.common.insert", new String[] {"댓글"}, locale));
        }
		
		// 등록 실행
		Object key = boardService.boardAnswerInsert(params);
		
		if(Validate.isEmpty(key)) {
			return ResponseUtil.responseJson(mv, Boolean.FALSE, messageSource.getMessage("fail.common.insert", new String[] {"댓글"}, locale));
		} else {
			return ResponseUtil.responseJson(mv, Boolean.TRUE, messageSource.getMessage("success.common.insert", new String[] {"댓글"}, locale));
		}
    }
	
	/**
     * 게시물 댓글 목록 액션(Ajax)
     */
	@RequestMapping(params="df_method_nm=processBoardAnswerListAjax", method = RequestMethod.POST)	
	public ModelAndView boardAnswerListAjax(HttpServletRequest request, ModelMap model) throws Exception {
		ModelAndView mv = new ModelAndView("/egovframework/board/templates/front/common/INC_boardAnswerList");
		
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
     * 게시물 댓글 수정 액션(Ajax)
     */
	@RequestMapping(params="df_method_nm=processBoardAnswerSeqUpdateAjax", method = RequestMethod.POST)	
	public ModelAndView boardAnswerSeqUpdateAjax(HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		HashMap params = new HashMap();
		
		params.put("bbsCd", request.getParameter("bbsCd"));
		params.put("seq", request.getParameter("seq"));
		params.put("answerSeq", request.getParameter("answerSeq"));
		
		String answerSeq = request.getParameter("answerSeq");
		params.put("answerCn", request.getParameter("answerCn_" + answerSeq));
		
		// 수정 실행
		int key = boardService.boardAnswerSeqUpdate(params);
		
		if(key < 1) {
			return ResponseUtil.responseJson(mv, Boolean.FALSE, messageSource.getMessage("fail.common.update", new String[] {"댓글"}, locale));
		} else {
			return ResponseUtil.responseJson(mv, Boolean.TRUE, messageSource.getMessage("success.common.update", new String[] {"댓글"}, locale));
		}
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
