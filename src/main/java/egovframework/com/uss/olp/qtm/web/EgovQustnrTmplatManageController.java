package egovframework.com.uss.olp.qtm.web;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import egovframework.com.cmm.ComDefaultVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.uss.olp.qtm.service.EgovQustnrTmplatManageService;
import egovframework.com.uss.olp.qtm.service.QustnrTmplatManageVO;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.bind.annotation.CommandMap;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.comm.user.UserVO;
import com.infra.util.SessionUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 설문템플릿 Controller Class 구현
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
@RequestMapping("/PGSO0010.do")
public class EgovQustnrTmplatManageController {

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovQustnrTmplatManageController.class);

	@Resource(name="qustnrTmplatManageValidator")
	private QustnrTmplatManageValidator beanValidator;

	/** EgovMessageSource */
    @Resource(name="egovMessageSource")
    EgovMessageSource egovMessageSource;

	@Resource(name = "egovQustnrTmplatManageService")
	private EgovQustnrTmplatManageService egovQustnrTmplatManageService;

    /** EgovPropertyService */
    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

	/**
	 * 설문템플릿 목록을 조회한다.
	 * @param searchVO
	 * @param commandMap
	 * @param qustnrTmplatManageVO
	 * @param model
	 * @return "egovframework/com/uss/olp/qtm/EgovQustnrTmplatManageList"
	 * @throws Exception
	 */
	@RequestMapping("")
	public String egovQustnrTmplatManageList(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			@CommandMap Map commandMap,
			QustnrTmplatManageVO qustnrTmplatManageVO,
    		ModelMap model)
    throws Exception {

        int totCnt = (Integer)egovQustnrTmplatManageService.selectQustnrTmplatManageListCnt(searchVO);
        
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(searchVO.getPageIndex()).totalRowCount(totCnt).rowSize(searchVO.getPageSize()).build();
		pager.makePaging();
		
		searchVO.setRecordCountPerPage(pager.getLimitTo());
		searchVO.setFirstIndex(pager.getLimitFrom());
		
		List resultList = egovQustnrTmplatManageService.selectQustnrTmplatManageList(searchVO);
        model.addAttribute("resultList", resultList);

        model.addAttribute("searchKeyword", commandMap.get("searchKeyword") == null ? "" : (String)commandMap.get("searchKeyword"));
        model.addAttribute("searchCondition", commandMap.get("searchCondition") == null ? "" : (String)commandMap.get("searchCondition"));

		model.addAttribute("pager", pager);

		return "/egovframework/com/uss/olp/qtm/BD_EgovQustnrTmplatManageList";
	}

	/**
	 * 설문템플릿 목록을 상세조회 조회한다.
	 * @param searchVO
	 * @param qustnrTmplatManageVO
	 * @param commandMap
	 * @param model
	 * @return "egovframework/com/uss/olp/qtm/EgovQustnrTmplatManageDetail"
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=EgovQustnrTmplatManageDetail")
	public String egovQustnrTmplatManageDetail(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			QustnrTmplatManageVO qustnrTmplatManageVO,
			@CommandMap Map commandMap,
    		ModelMap model)
    throws Exception {

		String sLocationUrl = "/egovframework/com/uss/olp/qtm/BD_EgovQustnrTmplatManageDetail";

        List resultList = egovQustnrTmplatManageService.selectQustnrTmplatManageDetail(qustnrTmplatManageVO);
        model.addAttribute("resultList", resultList);

		return sLocationUrl;
	}
	
	/**
	 * 설문템플릿 목록을 삭제한다.
	 * @param searchVO
	 * @param qustnrTmplatManageVO
	 * @param commandMap
	 * @param model
	 * @return "/egovframework/com/uss/olp/qtm/BD_EgovQustnrTmplatManageList"
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=deleteEgovQustnrTmplatManage")
	public String deleteEgovQustnrTmplatManage(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			QustnrTmplatManageVO qustnrTmplatManageVO,
			@CommandMap Map commandMap,
    		ModelMap model)
    throws Exception {

		egovQustnrTmplatManageService.deleteQustnrTmplatManage(qustnrTmplatManageVO);
		model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.delete", new String[]{"설문템플릿"}, Locale.getDefault()));
		String sLocationUrl = egovQustnrTmplatManageList(searchVO, commandMap, qustnrTmplatManageVO, model);			


		return sLocationUrl;
	}

	/**
	 * 설문템플릿를 수정한다.
	 * @param searchVO
	 * @param commandMap
	 * @param qustnrTmplatManageVO
	 * @param model
	 * @return "egovframework/com/uss/olp/qtm/EgovQustnrTmplatManageModify"
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=EgovQustnrTmplatManageModify")
	public String qustnrTmplatManageModify(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			@CommandMap Map commandMap,
			QustnrTmplatManageVO qustnrTmplatManageVO,
    		ModelMap model)
    throws Exception {
		String sLocationUrl = "/egovframework/com/uss/olp/qtm/BD_EgovQustnrTmplatManageModify";

        List resultList = egovQustnrTmplatManageService.selectQustnrTmplatManageDetail(qustnrTmplatManageVO);
        model.addAttribute("resultList", resultList);

		return sLocationUrl;
	}

	/**
	 * 설문템플릿를 수정처리 한다.
	 * @param multiRequest
	 * @param searchVO
	 * @param commandMap
	 * @param qustnrTmplatManageVO
	 * @param bindingResult
	 * @param model
	 * @return "egovframework/com/uss/olp/qtm/EgovQustnrTmplatManageModifyActor"
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=updateEgovQustnrTmplatManage")
	public String qustnrTmplatManageModifyActor(
			//final MultipartHttpServletRequest multiRequest,
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			@CommandMap Map commandMap,
			@ModelAttribute("qustnrTmplatManageVO") QustnrTmplatManageVO qustnrTmplatManageVO,
			BindingResult bindingResult,
    		ModelMap model)
    throws Exception {

		//로그인 객체 선언
		UserVO userVo = SessionUtil.getUserInfo();

		//서버  validate 체크
        beanValidator.validate(qustnrTmplatManageVO, bindingResult);
		if (bindingResult.hasErrors()){
	        List sampleList = egovQustnrTmplatManageService.selectQustnrTmplatManageDetail(qustnrTmplatManageVO);
	        model.addAttribute("resultList", sampleList);
			return "/egovframework/com/uss/olp/qtm/BD_EgovQustnrTmplatManageModify";
		}

		//아이디 설정
		qustnrTmplatManageVO.setRegister(userVo.getUserNo());
		qustnrTmplatManageVO.setUpdusr(userVo.getUserNo());

    	egovQustnrTmplatManageService.updateQustnrTmplatManage(qustnrTmplatManageVO);
    	model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.update", new String[]{"설문템플릿"}, Locale.getDefault()));
		return egovQustnrTmplatManageList(searchVO, commandMap, qustnrTmplatManageVO, model);
	}

	/**
	 * 설문템플릿를 등록한다. / 초기등록페이지
	 * @param searchVO
	 * @param commandMap
	 * @param qustnrTmplatManageVO
	 * @param model
	 * @return "egovframework/com/uss/olp/qtm/EgovQustnrTmplatManageRegist"
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=EgovQustnrTmplatManageRegist")
	public String qustnrTmplatManageRegist(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			@CommandMap Map commandMap,
			@ModelAttribute("qustnrTmplatManageVO") QustnrTmplatManageVO qustnrTmplatManageVO,
    		ModelMap model)
    throws Exception {

		//로그인 객체 선언
		UserVO userVo = SessionUtil.getUserInfo();

		String sLocationUrl = "/egovframework/com/uss/olp/qtm/BD_EgovQustnrTmplatManageRegist";

		String sCmd = commandMap.get("cmd") == null ? "" : (String)commandMap.get("cmd");
		LOGGER.info("cmd => {}", sCmd);

		//아이디 설정
		qustnrTmplatManageVO.setRegister(userVo.getUserNo());
		qustnrTmplatManageVO.setUpdusr(userVo.getUserNo());

		return sLocationUrl;
	}

	/**
	 * 설문템플릿를 등록 처리 한다.  / 등록처리
	 * @param multiRequest
	 * @param searchVO
	 * @param qustnrTmplatManageVO
	 * @param model
	 * @return "egovframework/com/uss/olp/qtm/EgovQustnrTmplatManageRegistActor"
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=insertEgovQustnrTmplatManage")
	public String qustnrTmplatManageRegistActor(
			//final MultipartHttpServletRequest multiRequest,
			@CommandMap Map commandMap,
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			QustnrTmplatManageVO qustnrTmplatManageVO,
    		ModelMap model)
    throws Exception {

		//로그인 객체 선언
		UserVO userVo = SessionUtil.getUserInfo();

		//아이디 설정
		qustnrTmplatManageVO.setRegister(userVo.getUserNo());
		qustnrTmplatManageVO.setUpdusr(userVo.getUserNo());

    	//log.info("qestnrTmplatImagepathnm =>" + qustnrTmplatManageVO.getQestnrTmplatImagepathnm() );
    	egovQustnrTmplatManageService.insertQustnrTmplatManage(qustnrTmplatManageVO);
    	model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.insert", new String[]{"설문템플릿"}, Locale.getDefault()));
    	return egovQustnrTmplatManageList(searchVO, commandMap, qustnrTmplatManageVO, model);
	}
}
