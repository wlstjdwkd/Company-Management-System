package egovframework.com.uss.olp.qqm.web;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import egovframework.com.cmm.ComDefaultVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.uss.olp.qqm.service.EgovQustnrQestnManageService;
import egovframework.com.uss.olp.qqm.service.QustnrQestnManageVO;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.bind.annotation.CommandMap;

import javax.annotation.Resource;

import com.comm.code.CodeService;
import com.comm.page.Pager;
import com.comm.user.UserVO;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * 설문문항을 처리하는 Controller Class 구현
 * @author 공통서비스 장동한
 * @since 2009.03.20
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.03.20  장동한          최초 생성
 *   2011.8.26	정진오			IncludedInfo annotation 추가
 *
 * </pre>
 */

@Controller
@RequestMapping("/PGSO0030.do")
public class EgovQustnrQestnManageController {

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovQustnrQestnManageController.class);

	@Resource(name="qustnrQestnManageValidator")
	private QustnrQestnManageValidator beanValidator;

	/** EgovMessageSource */
    @Resource(name="egovMessageSource")
    EgovMessageSource egovMessageSource;

	@Resource(name = "egovQustnrQestnManageService")
	private EgovQustnrQestnManageService egovQustnrQestnManageService;

    /** EgovPropertyService */
    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

    @Autowired
    CodeService codeService;

    /**
     * 순번 중복 체크
     * @param qustnrQestnManageVO 순번정보
     * @return	true/false 여부
     * @throws Exception
     */
    @RequestMapping(params="df_method_nm=EgovQustnrQustnCheckSn")
    public ModelAndView checkSn(QustnrQestnManageVO qustnrQestnManageVO) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		if (egovQustnrQestnManageService.selectQustnrQestnSNCnt(qustnrQestnManageVO) > 0) {
			return ResponseUtil.responseJson(mv, false);
		}

		return ResponseUtil.responseJson(mv, true);
    }
    
    /**
     * 설문항목 통계를 조회한다.
     * @param searchVO
     * @param qustnrQestnManageVO
     * @param commandMap
     * @param model
     * @return "egovframework/com/uss/olp/qqm/EgovQustnrQestnManageStatistics"
     * @throws Exception
     */
    @RequestMapping(params="df_method_nm=EgovQustnrQestnManageStatistics")
	public String egovQustnrQestnManageStatistics(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			QustnrQestnManageVO qustnrQestnManageVO,
			@CommandMap Map commandMap,
    		ModelMap model)
    throws Exception {

		String sLocationUrl = "/egovframework/com/uss/olp/qqm/BD_EgovQustnrQestnManageStatistics";

        List resultList = egovQustnrQestnManageService.selectQustnrQestnManageDetail(qustnrQestnManageVO);
        model.addAttribute("resultList", resultList);
        // 객관식설문통계
        HashMap mapParam = new HashMap();
        mapParam.put("qestnrQesitmId", (String)qustnrQestnManageVO.getQestnrQesitmId());
        List statisticsList = egovQustnrQestnManageService.selectQustnrManageStatistics(mapParam);
        model.addAttribute("statisticsList", statisticsList);
        // 주관식설문통계
        List statisticsList2 = egovQustnrQestnManageService.selectQustnrManageStatistics2(mapParam);
        model.addAttribute("statisticsList2", statisticsList2);
		return sLocationUrl;
	}

	/**
	 * 설문문항 팝업 록을 조회한다.
	 * @param searchVO
	 * @param qustnrQestnManageVO
	 * @param commandMap
	 * @param model
	 * @return "egovframework/com/uss/olp/qqm/EgovQustnrQestnManageListPopup"
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=EgovQustnrQestnManageListPopup")
	public String egovQustnrQestnManageListPopup(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			@ModelAttribute("qustnrQestnManageVO") QustnrQestnManageVO qustnrQestnManageVO,
			@CommandMap Map commandMap,
    		ModelMap model)
    throws Exception {

		String sSearchMode = commandMap.get("searchMode") == null ? "" : (String)commandMap.get("searchMode");

		//설문지정보에서 넘어오면 자동검색 설정
		if(sSearchMode.equals("Y")){
			searchVO.setSearchCondition("QESTNR_ID");
			searchVO.setSearchKeyword(qustnrQestnManageVO.getQestnrId());
		}

        int totCnt = (Integer)egovQustnrQestnManageService.selectQustnrQestnManageListCnt(searchVO);

		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(searchVO.getPageIndex()).totalRowCount(totCnt).rowSize(searchVO.getPageSize()).build();
		pager.makePaging();
		
		searchVO.setRecordCountPerPage(pager.getLimitTo());
		searchVO.setFirstIndex(pager.getLimitFrom());
		
		List resultList = egovQustnrQestnManageService.selectQustnrQestnManageList(searchVO);
        model.addAttribute("resultList", resultList);
		model.addAttribute("pager", pager);

		return "/egovframework/com/uss/olp/qqm/PD_EgovQustnrQestnManageListPopup";
	}

	/**
	 * 설문문항 목록을 조회한다.
	 * @param searchVO
	 * @param qustnrQestnManageVO
	 * @param commandMap
	 * @param model
	 * @return "egovframework/com/uss/olp/qqm/EgovQustnrQestnManageList"
	 * @throws Exception
	 */
	@RequestMapping("")
	public String egovQustnrQestnManageList(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			@ModelAttribute("qustnrQestnManageVO") QustnrQestnManageVO qustnrQestnManageVO,
			@CommandMap Map commandMap,
    		ModelMap model)
    throws Exception {

		String sCmd = commandMap.get("cmd") == null ? "" : (String)commandMap.get("cmd");
		String sSearchMode = commandMap.get("searchMode") == null ? "" : (String)commandMap.get("searchMode");

		if(sCmd.equals("del")){
			egovQustnrQestnManageService.deleteQustnrQestnManage(qustnrQestnManageVO);
		}

		//설문지정보에서 넘어오면 자동검색 설정
		if(sSearchMode.equals("Y")){
			searchVO.setSearchCondition("QESTNR_ID");
			searchVO.setSearchKeyword(qustnrQestnManageVO.getQestnrId());
		}

		int totCnt = (Integer)egovQustnrQestnManageService.selectQustnrQestnManageListCnt(searchVO);
        
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(searchVO.getPageIndex()).totalRowCount(totCnt).rowSize(searchVO.getPageSize()).build();
		pager.makePaging();
		
		searchVO.setRecordCountPerPage(pager.getLimitTo());
		searchVO.setFirstIndex(pager.getLimitFrom());
		
        List resultList = egovQustnrQestnManageService.selectQustnrQestnManageList(searchVO);
        model.addAttribute("resultList", resultList);
		model.addAttribute("pager", pager);
		
		searchVO.setSearchCondition("");
		searchVO.setSearchKeyword("");
		
		return "/egovframework/com/uss/olp/qqm/BD_EgovQustnrQestnManageList";
	}

	/**
	 * 설문문항 목록을 상세조회 조회한다.
	 * @param searchVO
	 * @param qustnrQestnManageVO
	 * @param commandMap
	 * @param model
	 * @return "egovframework/com/uss/olp/qqm/EgovQustnrQestnManageDetail"
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=EgovQustnrQestnManageDetail")
	public String egovQustnrQestnManageDetail(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			@ModelAttribute("qustnrQestnManageVO") QustnrQestnManageVO qustnrQestnManageVO,
			@CommandMap Map commandMap,
    		ModelMap model)
    throws Exception {

		String sLocationUrl = "/egovframework/com/uss/olp/qqm/BD_EgovQustnrQestnManageDetail";

		String sCmd = commandMap.get("cmd") == null ? "" : (String)commandMap.get("cmd");

		if(sCmd.equals("del")){
			egovQustnrQestnManageService.deleteQustnrQestnManage(qustnrQestnManageVO);
			model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.delete", new String[]{"설문문항"}, Locale.getDefault()));
			sLocationUrl = egovQustnrQestnManageList(searchVO, qustnrQestnManageVO, commandMap, model); 
			/** 목록으로갈때 검색조건 유지 */

		}else{
	     	//공통코드 질문유형 조회
	    	List listComCode = codeService.findCodesByGroupNo("10");
	    	model.addAttribute("code10", listComCode);

	        List resultList = egovQustnrQestnManageService.selectQustnrQestnManageDetail(qustnrQestnManageVO);
	        model.addAttribute("resultList", resultList);
		}

		return sLocationUrl;
	}
	
	/**
	 * 설문문항 목록을 삭제한다.
	 * @param searchVO
	 * @param qustnrQestnManageVO
	 * @param commandMap
	 * @param model
	 * @return "egovframework/com/uss/olp/qqm/EgovQustnrQestnManageList"
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=deleteEgovQustnrQestnManage")
	public String qustnrQestnManageDelete(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			@ModelAttribute("qustnrQestnManageVO") QustnrQestnManageVO qustnrQestnManageVO,
			@CommandMap Map commandMap,
    		ModelMap model)
    throws Exception {

		egovQustnrQestnManageService.deleteQustnrQestnManage(qustnrQestnManageVO);
		model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.delete", new String[]{"설문문항"}, Locale.getDefault()));
		String sLocationUrl = egovQustnrQestnManageList(searchVO, qustnrQestnManageVO, commandMap, model); 

		return sLocationUrl;
	}

	/**
	 * 설문문항를 수정한다.
	 * @param searchVO
	 * @param commandMap
	 * @param qustnrQestnManageVO
	 * @param bindingResult
	 * @param model
	 * @return "egovframework/com/uss/olp/qqm/EgovQustnrQestnManageModify"
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=updateEgovQustnrQestnManage")
	public String qustnrQestnManageModify(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			@CommandMap Map commandMap,
			@ModelAttribute("qustnrQestnManageVO") QustnrQestnManageVO qustnrQestnManageVO,
			BindingResult bindingResult,
    		ModelMap model)
    throws Exception {

		//로그인 객체 선언
		UserVO userVo = SessionUtil.getUserInfo();

		String sLocationUrl = "/egovframework/com/uss/olp/qqm/BD_EgovQustnrQestnManageModify";

		String sCmd = commandMap.get("cmd") == null ? "" : (String)commandMap.get("cmd");

     	//공통코드 질문유형 조회
    	List listComCode = codeService.findCodesByGroupNo("10");
    	model.addAttribute("code10", listComCode);

        if(sCmd.equals("save")){
    		//서버  validate 체크
            beanValidator.validate(qustnrQestnManageVO, bindingResult);
    		if (bindingResult.hasErrors()){
            	//설문제목가져오기
            	String sQestnrId = commandMap.get("qestnrId") == null ? "" : (String)commandMap.get("qestnrId");
            	String sQestnrTmplatId = commandMap.get("qestnrTmplatId") == null ? "" : (String)commandMap.get("qestnrTmplatId");

            	LOGGER.info("sQestnrId => {}", sQestnrId);
            	LOGGER.info("sQestnrTmplatId => {}", sQestnrTmplatId);
            	if(!sQestnrId.equals("") && !sQestnrTmplatId.equals("")){

            		Map mapQustnrManage = new HashMap();
            		mapQustnrManage.put("qestnrId", sQestnrId);
            		mapQustnrManage.put("qestnrTmplatId", sQestnrTmplatId);

            		model.addAttribute("qestnrInfo", (Map)egovQustnrQestnManageService.selectQustnrManageQestnrSj(mapQustnrManage));
            	}

                List resultList = egovQustnrQestnManageService.selectQustnrQestnManageDetail(qustnrQestnManageVO);
                model.addAttribute("resultList", resultList);
            	return "/egovframework/com/uss/olp/qqm/BD_EgovQustnrQestnManageModify";
    		}

    		//아이디 설정
    		qustnrQestnManageVO.setRegister(userVo.getUserNo());
    		qustnrQestnManageVO.setUpdusr(userVo.getUserNo());

        	egovQustnrQestnManageService.updateQustnrQestnManage(qustnrQestnManageVO);
        	model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.update", new String[]{"설문문항"}, Locale.getDefault()));
        	sLocationUrl = egovQustnrQestnManageList(searchVO, qustnrQestnManageVO, commandMap, model); 

        }else{
            List resultList = egovQustnrQestnManageService.selectQustnrQestnManageDetail(qustnrQestnManageVO);
            model.addAttribute("resultList", resultList);

        }

		return sLocationUrl;
	}

	/**
	 * 설문문항를 등록한다.
	 * @param searchVO
	 * @param commandMap
	 * @param qustnrQestnManageVO
	 * @param bindingResult
	 * @param model
	 * @return "egovframework/com/uss/olp/qqm/EgovQustnrQestnManageRegist"
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=insertEgovQustnrQestnManage")
	public String qustnrQestnManageRegist(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			@CommandMap Map commandMap,
			@ModelAttribute("qustnrQestnManageVO") QustnrQestnManageVO qustnrQestnManageVO,
			BindingResult bindingResult,
    		ModelMap model)
    throws Exception {

		//로그인 객체 선언
		UserVO userVo = SessionUtil.getUserInfo();

		String sLocationUrl = "/egovframework/com/uss/olp/qqm/BD_EgovQustnrQestnManageRegist";

		String sCmd = commandMap.get("cmd") == null ? "" : (String)commandMap.get("cmd");
		LOGGER.info("cmd => {}", sCmd);

     	//공통코드 질문유형 조회
    	List listComCode = codeService.findCodesByGroupNo("10");
    	model.addAttribute("code10", listComCode);

        if(sCmd.equals("save")){

    		//서버  validate 체크
            beanValidator.validate(qustnrQestnManageVO, bindingResult);
    		if (bindingResult.hasErrors()){
            	//설문제목가져오기
            	String sQestnrId = commandMap.get("qestnrId") == null ? "" : (String)commandMap.get("qestnrId");
            	String sQestnrTmplatId = commandMap.get("qestnrTmplatId") == null ? "" : (String)commandMap.get("qestnrTmplatId");

            	LOGGER.info("sQestnrId => {}", sQestnrId);
            	LOGGER.info("sQestnrTmplatId => {}", sQestnrTmplatId);
            	if(!sQestnrId.equals("") && !sQestnrTmplatId.equals("")){

            		Map mapQustnrManage = new HashMap();
            		mapQustnrManage.put("qestnrId", sQestnrId);
            		mapQustnrManage.put("qestnrTmplatId", sQestnrTmplatId);

            		model.addAttribute("qestnrInfo", (Map)egovQustnrQestnManageService.selectQustnrManageQestnrSj(mapQustnrManage));
            	}

    			return "/egovframework/com/uss/olp/qqm/BD_EgovQustnrQestnManageRegist";
    		}

    		//아이디 설정
    		qustnrQestnManageVO.setRegister(userVo.getUserNo());
    		qustnrQestnManageVO.setUpdusr(userVo.getUserNo());
    		
        	egovQustnrQestnManageService.insertQustnrQestnManage(qustnrQestnManageVO);
        	model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.insert", new String[]{"설문문항"}, Locale.getDefault()));
        	sLocationUrl = egovQustnrQestnManageList(searchVO, qustnrQestnManageVO, commandMap, model);

        }else{

        	//설문제목가져오기
        	String sQestnrId = commandMap.get("qestnrId") == null ? "" : (String)commandMap.get("qestnrId");
        	String sQestnrTmplatId = commandMap.get("qestnrTmplatId") == null ? "" : (String)commandMap.get("qestnrTmplatId");

        	LOGGER.info("sQestnrId => {}", sQestnrId);
        	LOGGER.info("sQestnrTmplatId => {}", sQestnrTmplatId);
        	if(!sQestnrId.equals("") && !sQestnrTmplatId.equals("")){

        		Map mapQustnrManage = new HashMap();
        		mapQustnrManage.put("qestnrId", sQestnrId);
        		mapQustnrManage.put("qestnrTmplatId", sQestnrTmplatId);

        		model.addAttribute("qestnrInfo", (Map)egovQustnrQestnManageService.selectQustnrManageQestnrSj(mapQustnrManage));
        	}
        }

		return sLocationUrl;
	}
}
