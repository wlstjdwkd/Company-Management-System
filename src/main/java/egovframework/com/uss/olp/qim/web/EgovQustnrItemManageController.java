package egovframework.com.uss.olp.qim.web;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import egovframework.com.cmm.ComDefaultVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.uss.olp.qim.service.EgovQustnrItemManageService;
import egovframework.com.uss.olp.qim.service.QustnrItemManageVO;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.bind.annotation.CommandMap;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.comm.user.UserVO;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * 설문항목관리를 처리하는 Controller Class 구현
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
@RequestMapping("/PGSO0040.do")
public class EgovQustnrItemManageController {

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovQustnrItemManageController.class);

	@Resource(name="qustnrItemManageValidator")
	QustnrItemManageValidator beanValidator;

	/** EgovMessageSource */
    @Resource(name="egovMessageSource")
    EgovMessageSource egovMessageSource;

	@Resource(name = "egovQustnrItemManageService")
	private EgovQustnrItemManageService egovQustnrItemManageService;

    /** EgovPropertyService */
    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

    
    /**
     * 순번 중복 체크
     * @param qustnrItemManageVO 순번정보
     * @return true/false 여부
     * @throws Exception
     */
    @RequestMapping(params="df_method_nm=EgovQustnrItemCheckSn")
    public ModelAndView checkSn(QustnrItemManageVO qustnrItemManageVO) throws Exception {
		ModelAndView mv = new ModelAndView();

		if (egovQustnrItemManageService.selectQustnrItemSNCnt(qustnrItemManageVO) > 0) {
			return ResponseUtil.responseJson(mv, false);
		}

		return ResponseUtil.responseJson(mv, true);
    }
    
	/**
	 * 설문항목 팝업 목록을 조회한다.
	 * @param searchVO
	 * @param commandMap
	 * @param qustnrItemManageVO
	 * @param model
	 * @return "egovframework/com/uss/olp/qim/EgovQustnrItemManageListPopup"
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=EgovQustnrItemManageListPopup")
	public String egovQustnrItemManageListPopup(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			@CommandMap Map commandMap,
			QustnrItemManageVO qustnrItemManageVO,
    		ModelMap model)
    throws Exception {

		String sCmd = commandMap.get("cmd") == null ? "" : (String)commandMap.get("cmd");
		if(sCmd.equals("del")){
			egovQustnrItemManageService.deleteQustnrItemManage(qustnrItemManageVO);
		}

		int totCnt = (Integer)egovQustnrItemManageService.selectQustnrItemManageListCnt(searchVO);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(searchVO.getPageIndex()).totalRowCount(totCnt).rowSize(searchVO.getPageSize()).build();
		pager.makePaging();
		
		searchVO.setRecordCountPerPage(pager.getLimitTo());
		searchVO.setFirstIndex(pager.getLimitFrom());
		
        List resultList = egovQustnrItemManageService.selectQustnrItemManageList(searchVO);
        model.addAttribute("resultList", resultList);

        model.addAttribute("searchKeyword", commandMap.get("searchKeyword") == null ? "" : (String)commandMap.get("searchKeyword"));
        model.addAttribute("searchCondition", commandMap.get("searchCondition") == null ? "" : (String)commandMap.get("searchCondition"));
		
		model.addAttribute("pager", pager);

		return "/egovframework/com/uss/olp/qim/PD_EgovQustnrItemManageListPopup";
	}

	/**
	 * 설문항목 목록을 조회한다.
	 * @param searchVO
	 * @param commandMap
	 * @param qustnrItemManageVO
	 * @param model
	 * @return "egovframework/com/uss/olp/qim/EgovQustnrItemManageList"
	 * @throws Exception
	 */
	@RequestMapping(value="")
	public String egovQustnrItemManageList(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			@CommandMap Map commandMap,
			@ModelAttribute("qustnrItemManageVO") QustnrItemManageVO qustnrItemManageVO,
    		ModelMap model)
    throws Exception {

		//String sSearchMode = commandMap.get("searchMode") == null ? "" : (String)commandMap.get("searchMode");

		//설문문항에 넘어온 건에 대해 조회
		//if(sSearchMode.equals("Y")){
			searchVO.setSearchCondition("QUSTNR_QESITM_ID");//qestnrQesitmId
			searchVO.setSearchKeyword(qustnrItemManageVO.getQestnrQesitmId());
		//}

		//int totCnt = (Integer)egovQustnrItemManageService.selectQustnrItemManageListCnt(searchVO);
        
		// 페이저 빌드
		//Pager pager = new Pager.Builder().pageNo(searchVO.getPageIndex()).totalRowCount(totCnt).rowSize(searchVO.getPageSize()).build();
		//pager.makePaging();
		
		//searchVO.setRecordCountPerPage(pager.getLimitTo());
		//searchVO.setFirstIndex(pager.getLimitFrom());
		
        List resultList = egovQustnrItemManageService.selectQustnrItemManageList(searchVO);
        model.addAttribute("resultList", resultList);

        model.addAttribute("searchKeyword", commandMap.get("searchKeyword") == null ? "" : (String)commandMap.get("searchKeyword"));
        model.addAttribute("searchCondition", commandMap.get("searchCondition") == null ? "" : (String)commandMap.get("searchCondition"));

		//model.addAttribute("pager", pager);

		return "/egovframework/com/uss/olp/qim/PD_EgovQustnrItemManageList";
	}

	/**
	 * 설문항목 목록을 상세조회 조회한다.
	 * @param searchVO
	 * @param qustnrItemManageVO
	 * @param commandMap
	 * @param model
	 * @return  "/uss/olp/qim/EgovQustnrItemManageDetail"
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=EgovQustnrItemManageDetail")
	public String egovQustnrItemManageDetail(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			QustnrItemManageVO qustnrItemManageVO,
			@CommandMap Map commandMap,
    		ModelMap model)
    throws Exception {

		String sLocationUrl = "/egovframework/com/uss/olp/qim/PD_EgovQustnrItemManageDetail";

        List resultList = egovQustnrItemManageService.selectQustnrItemManageDetail(qustnrItemManageVO);
        model.addAttribute("resultList", resultList);

		return sLocationUrl;
	}
	
	/**
	 * 설문항목을 삭제한다.
	 * @param searchVO
	 * @param qustnrItemManageVO
	 * @param commandMap
	 * @param model
	 * @return  "/uss/olp/qim/PD_EgovQustnrItemManageList"
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=deleteEgovQustnrItemManage")
	public String qustnrItemManageDelete(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			QustnrItemManageVO qustnrItemManageVO,
			@CommandMap Map commandMap,
    		ModelMap model)
    throws Exception {

		egovQustnrItemManageService.deleteQustnrItemManage(qustnrItemManageVO);
		model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.delete", new String[]{"설문항목"}, Locale.getDefault()));
		String sLocationUrl = egovQustnrItemManageList(searchVO, commandMap, qustnrItemManageVO, model);

		return sLocationUrl;
	}

	/**
	 * 설문항목를 수정한다.
	 * @param searchVO
	 * @param commandMap
	 * @param qustnrItemManageVO
	 * @param bindingResult
	 * @param model
	 * @return "egovframework/com/uss/olp/qim/EgovQustnrItemManageModify"
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=updateEgovQustnrItemManage")
	public String qustnrItemManageModify(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			@CommandMap Map commandMap,
			@ModelAttribute("qustnrItemManageVO") QustnrItemManageVO qustnrItemManageVO,
			BindingResult bindingResult,
    		ModelMap model)
    throws Exception {

		//로그인 객체 선언
		UserVO userVo = SessionUtil.getUserInfo();

		String sLocationUrl = "/egovframework/com/uss/olp/qim/PD_EgovQustnrItemManageModify";

		String sCmd = commandMap.get("cmd") == null ? "" : (String)commandMap.get("cmd");

        if(sCmd.equals("save")){

    		//서버  validate 체크
            beanValidator.validate(qustnrItemManageVO, bindingResult);
    		if(bindingResult.hasErrors()){
            	//설문항목(을)를  정보 불러오기
                List listQustnrTmplat = egovQustnrItemManageService.selectQustnrTmplatManageList(qustnrItemManageVO);
                model.addAttribute("listQustnrTmplat", listQustnrTmplat);
            	//게시물 불러오기
                List resultList = egovQustnrItemManageService.selectQustnrItemManageDetail(qustnrItemManageVO);
                model.addAttribute("resultList", resultList);

                return "/egovframework/com/uss/olp/qim/PD_EgovQustnrItemManageModify";
    		}

    		//아이디 설정
    		qustnrItemManageVO.setRegister(userVo.getUserNo());
    		qustnrItemManageVO.setUpdusr(userVo.getUserNo());

        	egovQustnrItemManageService.updateQustnrItemManage(qustnrItemManageVO);
        	model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.update", new String[]{"설문항목"}, Locale.getDefault()));
        	sLocationUrl = egovQustnrItemManageList(searchVO, commandMap, qustnrItemManageVO, model);
        }else{
            List resultList = egovQustnrItemManageService.selectQustnrItemManageDetail(qustnrItemManageVO);
            model.addAttribute("resultList", resultList);

        	//설문항목(을)를  정보 불러오기
            List listQustnrTmplat = egovQustnrItemManageService.selectQustnrTmplatManageList(qustnrItemManageVO);
            model.addAttribute("listQustnrTmplat", listQustnrTmplat);
        }

		return sLocationUrl;
	}

	/**
	 * 설문항목를 등록한다.
	 * @param searchVO
	 * @param commandMap
	 * @param qustnrItemManageVO
	 * @param bindingResult
	 * @param model
	 * @return "egovframework/com/uss/olp/qim/EgovQustnrItemManageRegist"
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=insertEgovQustnrItemManage")
	public String qustnrItemManageRegist(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			@CommandMap Map commandMap,
			@ModelAttribute("qustnrItemManageVO") QustnrItemManageVO qustnrItemManageVO,
			BindingResult bindingResult,
    		ModelMap model)
    throws Exception {

		//로그인 객체 선언
		UserVO userVo = SessionUtil.getUserInfo();

		String sLocationUrl = "/egovframework/com/uss/olp/qim/PD_EgovQustnrItemManageRegist";

		String sCmd = commandMap.get("cmd") == null ? "" : (String)commandMap.get("cmd");
		LOGGER.info("cmd => {}", sCmd);

        if(sCmd.equals("save")){

    		//서버  validate 체크
            beanValidator.validate(qustnrItemManageVO, bindingResult);
    		if(bindingResult.hasErrors()){
            	//설문항목(을)를  정보 불러오기
                List listQustnrTmplat = egovQustnrItemManageService.selectQustnrTmplatManageList(qustnrItemManageVO);
                model.addAttribute("listQustnrTmplat", listQustnrTmplat);
                return "/egovframework/com/uss/olp/qim/PD_EgovQustnrItemManageRegist";
    		}

    		//아이디 설정
    		qustnrItemManageVO.setRegister(userVo.getUserNo());
    		qustnrItemManageVO.setUpdusr(userVo.getUserNo());

        	egovQustnrItemManageService.insertQustnrItemManage(qustnrItemManageVO);
        	model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.insert", new String[]{"설문항목"}, Locale.getDefault()));
        	sLocationUrl = egovQustnrItemManageList(searchVO, commandMap, qustnrItemManageVO, model);
        }else{
        	//설문항목(을)를  정보 불러오기
            List listQustnrTmplat = egovQustnrItemManageService.selectQustnrTmplatManageList(qustnrItemManageVO);
            model.addAttribute("listQustnrTmplat", listQustnrTmplat);
        }

		return sLocationUrl;
	}

}


