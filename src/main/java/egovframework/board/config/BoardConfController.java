package egovframework.board.config;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.comm.page.Pager;
import com.infra.util.ResponseUtil;
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
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.uss.olp.qim.web.EgovQustnrItemManageController;
import egovframework.rte.ptl.mvc.bind.annotation.CommandMap;

@Controller
@RequestMapping("/PGMS0080.do")
public class BoardConfController {
		
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovQustnrItemManageController.class);
	
	@Autowired
    private BoardConfService boardConfService;
	
	@Autowired
    private BoardCacheService boardCacheService;
	
	private Locale locale = Locale.getDefault();
	
	@Resource(name = "messageSource")
	private MessageSource messageSource;

    /**
     * 게시판 목록 조회
     * @throws Exception 
     */    
    @RequestMapping("")
    public String selectBoardConfList(HttpServletRequest request, ModelMap model, 
    		@ModelAttribute("boardConfVO") BoardConfVO boardConfVO,
    		@CommandMap Map commandMap) throws Exception {
    	
    	int totalListCount;
    	boardConfVO.setDataMap(commandMap);
    	
    	totalListCount = boardConfService.boardConfListCount(boardConfVO);
    	Pager pager = new Pager.Builder().pageNo(boardConfVO.getDf_curr_page()).totalRowCount(totalListCount).build();
    	pager.makePaging();
    	boardConfVO.setLimitFrom(pager.getLimitFrom());
    	boardConfVO.setLimitTo(pager.getLimitTo());
        
    	model.addAttribute("superAdmYn", "Y");    	
        model.addAttribute("resultList", boardConfService.boardConfList(boardConfVO));
        model.addAttribute("pager", pager);
        
        return "/egovframework/board/config/BD_boardconfList";
    }
    
    /**
     * 게시판 기본 설정 등록 폼
     * @throws Exception 
     */
    @RequestMapping(params="df_method_nm=boardConfRegist")
    public String insertForm(HttpServletRequest request, ModelMap model, BoardConfVO boardConfVO) throws Exception {

        model.addAttribute("kindCdMap", BoardConfConstant.MAP_KIND_CD);

        // 게시판 템플릿 종류
        model.addAttribute("listTemplates", boardConfService.boardTemplateList("L"));
        model.addAttribute("viewTemplates", boardConfService.boardTemplateList("V"));
        model.addAttribute("formTemplates", boardConfService.boardTemplateList("F"));

        return "/egovframework/board/config/BD_boardConfRegist";
    }
    
    /**
     * 게시판 등록 액션
     */
    @RequestMapping(params="df_method_nm=insertBoardConfRegistAction", method = RequestMethod.POST)
    public String boardConfInsert(ModelMap model, HttpServletRequest request, 
    		@ModelAttribute("boardConfVO") BoardConfVO boardConfVO,
    		@CommandMap Map commandMap) throws Exception {
        // 검증
        /*ValidateResultHolder holder = ValidateUtil.validate(boardConfVO);
        if(holder.isValid()) {
            // 등록 실행
            Object key = boardConfService.insertAction(boardConfVO);
            if(Validate.isEmpty(key)) {
                return alertAndBack(model, Messages.COMMON_PROCESS_FAIL);
            }
        } else {
            return alertAndBack(model, Messages.COMMON_VALIDATE_FAIL);
        }

        String url = "BD_boardconf.list.do?" + OpHelper.getSearchQueryString(request);
        return alertAndRedirect(model, Messages.COMMON_INSERT_OK, url);*/
    	
    	// 등록 실행
        Object key = boardConfService.insertAction(boardConfVO);
        if(Validate.isEmpty(key)) {
            //return alertAndBack(model, Messages.COMMON_PROCESS_FAIL);
        }
        
        model.addAttribute("superAdmYn", "Y");
        // 게시판 설정 리스트 조회
        model.addAttribute("resultList", boardConfService.boardConfList(boardConfVO));
        
        return selectBoardConfList(request, model, boardConfVO, commandMap);//"/egovframework/board/config/BD_boardconfList";
    }
    
    /**
     * 게시판 수정 액션(기본 설정)
     */
    @RequestMapping(params="df_method_nm=updateBoardBaseConfModifyAction", method = RequestMethod.POST)
    public ModelAndView updateAction(ModelMap model, HttpServletRequest request,
    		@ModelAttribute("boardConfVO") BoardConfVO boardConfVO,
    		@CommandMap Map commandMap) throws Exception {        
    	// 수정 실행
    	int affected = 0;
    	ModelAndView mv = new ModelAndView();
        affected = boardConfService.updateAction(boardConfVO);
        
        if(affected > 0) {
        	reloadBoardConfig(boardConfVO.getBbsCd());
        	return ResponseUtil.responseText(mv, Boolean.TRUE);
        }else {
        	return ResponseUtil.responseText(mv, Boolean.FALSE);
        }        
    }
    
    /**
     * 게시판 수정 액션(기본 설정을 제외한 설정 수정) - ui-tabs 사용 시
     */
    @RequestMapping(params="df_method_nm=updateBoardDetailConfModifyAction", method = RequestMethod.POST)
    public ModelAndView updateTabsAction(ModelMap model, BoardConfVO boardConfVO) throws Exception {
        int affected = 0;
        ModelAndView mv = new ModelAndView();
        
        // 수정 실행
        affected = boardConfService.updateAction(boardConfVO);
        if(affected != StringUtil.ONE) {
            return ResponseUtil.responseText(mv, Boolean.FALSE);
        }else{
        	reloadBoardConfig(boardConfVO.getBbsCd());
            return ResponseUtil.responseText(mv, Boolean.TRUE);
        }
    }
    
    /**
     * 게시판 목록/상세 배치 수정 액션
     */
    @RequestMapping(params="df_method_nm=updateBoardArrangeConfModifyAction", method = RequestMethod.POST)
    public ModelAndView arrangeUpdateAction(ModelMap model, BoardArrangeVO boardArrangeVO) throws Exception {
    	ModelAndView mv = new ModelAndView();
        int affected = boardConfService.arrangeUpdateAction(boardArrangeVO);
        if(affected < StringUtil.ONE) {
            return ResponseUtil.responseText(mv, Boolean.FALSE);
        }else{
        	reloadBoardConfig(boardArrangeVO.getBbsCd());
            return ResponseUtil.responseText(mv, Boolean.TRUE);
        }
    }
    
    /**
     * 게시판 확장 수정 액션
     */
    @RequestMapping(params="df_method_nm=updateBoardExtConfModifyAction", method = RequestMethod.POST)
    public ModelAndView extUpdateAction(ModelMap model, HttpServletRequest request,
        @RequestParam(value = "bbsCd", required = false) Integer bbsCd,
        @ModelAttribute BoardExtensionVO boardextensionVO) throws Exception {
        
    	ModelAndView mv = new ModelAndView();
        int affected = 0;
        List<BoardExtensionVO> boardExtList = boardextensionVO.getExtList();
        
        affected = boardConfService.updateExtAction(boardExtList, bbsCd);
        
        if(affected < StringUtil.ONE) {
            return ResponseUtil.responseText(mv, Boolean.FALSE);
        }else {
        	reloadBoardConfig(bbsCd);
        	return ResponseUtil.responseText(mv, Boolean.TRUE);
        }        
    }
    
    /**
     * 게시판 기본 설정 수정 폼
     * @throws Exception 
     */
    //@RequestMapping(value = "BD_boardconf.update.form.do", method = RequestMethod.GET)
    @RequestMapping(params="df_method_nm=boardConfUpdate")
    public String updateForm(HttpServletRequest request, ModelMap model, 
    		@ModelAttribute("boardConfVO") BoardConfVO boardConfVO,
    		@CommandMap Map commandMap) throws Exception {
    	
        if(Validate.isNotEmpty(commandMap.get("q_bbsCd"))) {
            boardConfVO.setBbsCd(Integer.parseInt(commandMap.get("q_bbsCd").toString()));
            boardConfVO.setGubunCd(BoardConfConstant.GUBUN_CD_GLOBAL);
            model.addAttribute(BoardConfConstant.KEY_DATA_VO, boardConfService.boardConfView(boardConfVO));
        }

        model.addAttribute("kindCdMap", BoardConfConstant.MAP_KIND_CD);

        // 게시판 템플릿 종류
        model.addAttribute("listTemplates", boardConfService.boardTemplateList("L"));
        model.addAttribute("viewTemplates", boardConfService.boardTemplateList("V"));
        model.addAttribute("formTemplates", boardConfService.boardTemplateList("F"));

        return "/egovframework/board/config/BD_boardconfUpdate";
    }
    
    /**
     * 게시판 목록 설정 폼
     * @throws Exception 
     */
    @RequestMapping(params="df_method_nm=boardConfUpdateSubListConfig", method = RequestMethod.POST)
    public String listConfig(HttpServletRequest request, ModelMap model, HttpServletResponse response, 
    		@ModelAttribute("boardConfVO") BoardConfVO boardConfVO) throws Exception {
        response.setHeader("Cache-Control", "no-cache");// HTTP 1.1
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0
        response.setDateHeader("Expires", 0);

        if(Validate.isEmpty(boardConfVO.getBbsCd())) {
            model.addAttribute(BoardConfConstant.KEY_DATA_VO, new BoardConfVO());
        } else {
            boardConfVO.setGubunCd(BoardConfConstant.GUBUN_CD_LIST);
            model.addAttribute(BoardConfConstant.KEY_DATA_VO, boardConfService.boardConfView(boardConfVO));
        }

        model.addAttribute("registerViewCdMap", BoardConfConstant.MAP_REGISTER_VIEW_CD);

        return "/egovframework/board/config/INC_listConfig";
    }
    
    /**
     * 게시판 목록 배치 폼
     * @throws Exception 
     */
    @RequestMapping(params="df_method_nm=boardConfUpdateSubListArrangeConfig", method = RequestMethod.POST)
    public String listArrange(ModelMap model, HttpServletResponse response, 
    		@ModelAttribute("boardConfVO") BoardArrangeVO boardArrangeVO) throws Exception {
    	
        response.setHeader("Cache-Control", "no-cache");// HTTP 1.1
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0
        response.setDateHeader("Expires", 0);

        if(Validate.isEmpty(boardArrangeVO.getBbsCd())) {
            model.addAttribute("boardDisplayColumnList", new BoardArrangeVO());
        } else {
            boardArrangeVO.setListViewGubun(BoardConfConstant.GUBUN_DISPLAY_COLUMN_LIST);
            List<BoardArrangeVO> list = boardConfService.boardDisplayColumnList(boardArrangeVO);
            model.addAttribute("boardDisplayColumnList", list);
        }

        model.addAttribute("boardColumnList", boardConfService.boardColumnList(boardArrangeVO.getBbsCd()));

        return "/egovframework/board/config/INC_listArrangeConfig";
    }
    
    /**
     * 게시판 상세조회 설정 폼
     * @throws Exception 
     */    
    //@RequestMapping(value = "INC_view.config.do", method = RequestMethod.POST)
    @RequestMapping(params="df_method_nm=boardConfUpdateViewConfig", method = RequestMethod.POST)
    public String viewConfig(HttpServletRequest request, ModelMap model, HttpServletResponse response, 
    		@ModelAttribute("boardConfVO") BoardConfVO boardConfVO) throws Exception {
    	
        response.setHeader("Cache-Control", "no-cache");// HTTP 1.1
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0
        response.setDateHeader("Expires", 0);

        if(Validate.isEmpty(boardConfVO.getBbsCd())) {
            model.addAttribute(BoardConfConstant.KEY_DATA_VO, new BoardConfVO());
        } else {
            boardConfVO.setGubunCd(BoardConfConstant.GUBUN_CD_VIEW);
            model.addAttribute(BoardConfConstant.KEY_DATA_VO, boardConfService.boardConfView(boardConfVO));
        }

        model.addAttribute("listViewCdMap", BoardConfConstant.MAP_LIST_VIEW_CD);

        return "/egovframework/board/config/INC_viewConfig";
    }
    
    /**
     * 게시판 상세조회 배치 폼
     * @throws Exception 
     */    
    //@RequestMapping(value = "INC_view.arrange.do", method = RequestMethod.POST)
    @RequestMapping(params="df_method_nm=boardConfUpdateViewArrangeConfig", method = RequestMethod.POST)
    public String viewArrange(ModelMap model, HttpServletResponse response, 
    		@ModelAttribute("boardConfVO") BoardArrangeVO boardArrangeVO) throws Exception {
        response.setHeader("Cache-Control", "no-cache");// HTTP 1.1
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0
        response.setDateHeader("Expires", 0);

        if(Validate.isEmpty(boardArrangeVO.getBbsCd())) {
            model.addAttribute("boardDisplayColumnList", new BoardArrangeVO());
        } else {
            boardArrangeVO.setListViewGubun(BoardConfConstant.GUBUN_DISPLAY_COLUMN_VIEW);
            List<BoardArrangeVO> list = boardConfService.boardDisplayColumnList(boardArrangeVO);
            model.addAttribute("boardDisplayColumnList", list);
        }

        model.addAttribute("boardColumnList", boardConfService.boardColumnList(boardArrangeVO.getBbsCd()));

        return "/egovframework/board/config/INC_viewArrangeConfig";
    }

    /**
     * 게시판 입력폼(등록/수정) 설정 폼
     * @throws Exception 
     */    
    //@RequestMapping(value = "INC_form.config.do", method = RequestMethod.POST)
    @RequestMapping(params="df_method_nm=boardConfUpdateRegFormConfig", method = RequestMethod.POST)
    public String formConfig(ModelMap model, HttpServletRequest request, HttpServletResponse response, 
    		@ModelAttribute("boardConfVO") BoardConfVO boardConfVO) throws Exception {
        response.setHeader("Cache-Control", "no-cache");// HTTP 1.1
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0
        response.setDateHeader("Expires", 0);

        /*OpHelper.bindSearchMap(boardConfVO, request);

        // 스크립트단에 동일한 validator를 설정할 수 있도록 한다.
        ValidateResultHolder holder = ValidateUtil.validate(boardConfVO);
        model.addAttribute(GlobalConfig.KEY_VALIDATE, holder);*/

        if(Validate.isEmpty(boardConfVO.getBbsCd())) {
            model.addAttribute(BoardConfConstant.KEY_DATA_VO, new BoardConfVO());
        } else {
            boardConfVO.setGubunCd(BoardConfConstant.GUBUN_CD_FORM);
            model.addAttribute(BoardConfConstant.KEY_DATA_VO, boardConfService.boardConfView(boardConfVO));
        }

        return "/egovframework/board/config/INC_regFormConfig";
    }
    
    /**
     * 게시판 확장관리(표시항목 및 추가 컬럼)
     * @throws Exception 
     */    
    //@RequestMapping(value = "INC_ext.config.do", method = RequestMethod.POST)
    @RequestMapping(params="df_method_nm=boardConfUpdateExtConfig", method = RequestMethod.POST)
    public String extConfig(HttpServletRequest request, ModelMap model, HttpServletResponse response, 
    		@ModelAttribute("boardConfVO") BoardConfVO boardConfVO) throws Exception {
        response.setHeader("Cache-Control", "no-cache");// HTTP 1.1
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0
        response.setDateHeader("Expires", 0);        

        List<BoardExtensionVO> extList = boardConfService.boardConfExtList(boardConfVO.getBbsCd());
        model.addAttribute(BoardConfConstant.KEY_DATA_LIST, extList);
        model.addAttribute(BoardConfConstant.KEY_DATA_VO, BoardConfConstant.SEARCH_TYPE_LIST);

        return "/egovframework/board/config/INC_extConfig";
    }
    
    /**
     * 게시판 목록 삭제 액션
     */
    @RequestMapping(params="df_method_nm=deleteBoardConf", method = RequestMethod.POST)
    public ModelAndView boardConfListDelete(HttpServletRequest request, ModelMap model, BoardConfVO boardConfVO) throws Exception {
    	
        Integer cnt = boardConfService.deleteBoardConf(boardConfVO);
        ModelAndView mv = new ModelAndView();
        
        if(cnt <= 0) {
            return ResponseUtil.responseText(mv, messageSource.getMessage("fail.common.delete", null, locale));
        }

        return ResponseUtil.responseText(mv, cnt);
    }
    
    /**
     * 게시판 옵션별 사용여부 수정 액션
     */
    @RequestMapping(params="df_method_nm=updateynModAction", method = RequestMethod.POST)
    public ModelAndView ynUpdateAction(ModelMap model, @ModelAttribute BoardConfYnVO boardConfYnVO,
        @RequestParam(value = "fieldColumn", required = true) String fieldColumn,
        @RequestParam(value = "fieldYn", required = true) String fieldYn) throws Exception {

    	ModelAndView mv = new ModelAndView();
    	
        if(boardConfYnVO == null) {
            throw new Exception("INVALID_ARGUMENTS");
        }

        configureBbsConfVO(boardConfYnVO, fieldColumn, fieldYn);

        int affected = boardConfService.updateAction(boardConfYnVO);

        if(affected != StringUtil.ONE) {
            throw new Exception("DB_UPDATE_FAIL");
        }
        
        reloadBoardConfig(boardConfYnVO.getBbsCd());

        return ResponseUtil.responseText(mv, affected);
    }
    
    private void configureBbsConfVO(BoardConfYnVO boardConfYnVO, String fieldColumn, String fieldYn) {
        if(fieldColumn.equals("useYn")) {
            boardConfYnVO.setUseYn(fieldYn);
        } else if(fieldColumn.equals("ctgYn")) {
            boardConfYnVO.setCtgYn(fieldYn);
        } else if(fieldColumn.equals("fileYn")) {
            boardConfYnVO.setFileYn(fieldYn);
        } else if(fieldColumn.equals("captchaYn")) {
            boardConfYnVO.setCaptchaYn(fieldYn);
        } else if(fieldColumn.equals("recommYn")) {
            boardConfYnVO.setRecommYn(fieldYn);
        } else if(fieldColumn.equals("commentYn")) {
            boardConfYnVO.setCommentYn(fieldYn);
        } else if(fieldColumn.equals("noticeYn")) {
            boardConfYnVO.setNoticeYn(fieldYn);
        } else if(fieldColumn.equals("usrEditorYn")) {
            boardConfYnVO.setUsrEditorYn(fieldYn);
        } else if(fieldColumn.equals("downYn")) {
            boardConfYnVO.setDownYn(fieldYn);
        } else if(fieldColumn.equals("feedYn")) {
            boardConfYnVO.setFeedYn(fieldYn);
        } else if(fieldColumn.equals("sueYn")) {
            boardConfYnVO.setSueYn(fieldYn);
        } else if(fieldColumn.equals("stfyYn")) {
            boardConfYnVO.setStfyYn(fieldYn);
        }
    }
    
    
    /**
     * 게시판 설정 캐시 리로드
     */
    private void reloadBoardConfig(int bbsCd) {
    	boardCacheService.resetBoardConfig(bbsCd);
    	boardCacheService.findBoardConfig(bbsCd);
    }
}
