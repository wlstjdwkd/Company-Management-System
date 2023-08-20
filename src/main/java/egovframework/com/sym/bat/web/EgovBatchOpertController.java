package egovframework.com.sym.bat.web;
import java.util.List;
import java.util.Locale;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.sym.bat.service.BatchOpert;
import egovframework.com.sym.bat.service.EgovBatchOpertService;
import egovframework.com.sym.bat.validation.BatchOpertValidator;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;
import egovframework.rte.fdl.property.EgovPropertyService;

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
import org.springframework.web.bind.annotation.RequestParam;

/**
 * 배치작업관리에 대한 controller 클래스를 정의한다.
 *
 * 배치작업관리에 대한 등록, 수정, 삭제, 조회 기능을 제공한다.
 * 배치작업관리의 조회기능은 목록조회, 상세조회로 구분된다.
 * @author 김진만
 * @since 2010.06.17
 * @version 1.0
 * @updated 17-6-2010 오전 10:27:13
 * @see
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2010.06.17   김진만     최초 생성
 *  2011.8.26	정진오			IncludedInfo annotation 추가
 * </pre>
 */

@Controller
@RequestMapping("/PGMS0050.do")
public class EgovBatchOpertController {

	/** egovBatchOpertService */
	@Resource(name = "egovBatchOpertService")
	private EgovBatchOpertService egovBatchOpertService;

	/* Property 서비스 */
    @Resource(name="propertiesService")
    private EgovPropertyService propertyService;

    /* 메세지 서비스 */
    @Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource;
    
    /* batchOpert bean validator */
    @Resource(name="batchOpertValidator")
    private BatchOpertValidator batchOpertValidator;
    
    /** ID Generation */
	@Resource(name="egovBatchOpertIdGnrService")
	private EgovIdGnrService idgenService;

	/** logger */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovBatchOpertController.class);

    /**
	 * 배치작업을 삭제한다.
	 * @return 리턴URL
	 *
	 * @param batchOpert 삭제대상 배치작업model
	 * @param model		ModelMap
	 * @exception Exception Exception
	 */
    @RequestMapping(params="df_method_nm=deleteBatchOpert")
	public String deleteBatchOpert(BatchOpert batchOpert, ModelMap model)
	  throws Exception{

    	egovBatchOpertService.deleteBatchOpert(batchOpert);

    	model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.delete", new String[]{"배치작업"}, Locale.getDefault()));
    	
    	return selectBatchOpertList(batchOpert, model, "N");
	}

	/**
	 * 배치작업을 등록한다.
	 * @return 리턴URL
	 *
	 * @param batchOpert 등록대상 배치작업model
	 * @param bindingResult	BindingResult
	 * @param model			ModelMap
	 * @exception Exception Exception
	 */
    @RequestMapping(params="df_method_nm=insertBatchOpert")
	public String insertBatchOpert(BatchOpert batchOpert, BindingResult bindingResult, ModelMap model)
	  throws Exception{

		//로그인 객체 선언
    	UserVO userVo = SessionUtil.getUserInfo();
    	
    	batchOpertValidator.validate(batchOpert, bindingResult);
    	if (bindingResult.hasErrors()){
    		return "/egovframework/com/sym/bat/BD_EgovBatchOpertRegist";
		}else{
			batchOpert.setBatchOpertId(idgenService.getNextStringId());
			//아이디 설정
			batchOpert.setUpdusr(userVo.getUserNo());
			batchOpert.setRegister(userVo.getUserNo());

			egovBatchOpertService.insertBatchOpert(batchOpert);
	        //Exception 없이 진행시 등록성공메시지
	        model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.insert", new String[]{"배치작업"}, Locale.getDefault()));
	        
	        return selectBatchOpertList(batchOpert, model, "N");
		}
	}

	/**
	 * 배치작업정보을 상세조회한다.
	 * @return 리턴URL
	 *
	 * @param batchOpert 조회대상 배치작업model
	 * @param model		ModelMap
	 * @exception Exception Exception
	 */
    @RequestMapping(params="df_method_nm=getBatchOpert")
	public String selectBatchOpert(@ModelAttribute("searchVO")BatchOpert batchOpert, ModelMap model)
	  throws Exception{
    	LOGGER.debug(" 조회조건 : {}", batchOpert);
		BatchOpert result = egovBatchOpertService.selectBatchOpert(batchOpert);
		model.addAttribute("resultInfo", result);
		LOGGER.debug(" 결과값 : {}", result);

		return "/egovframework/com/sym/bat/BD_EgovBatchOpertDetail";
	}

	/**
	 * 등록화면을 위한 배치작업정보을 조회한다.
	 * @return 리턴URL
	 *
	 * @param batchOpert 조회대상 배치작업model
	 * @param model		ModelMap
	 * @exception Exception Exception
	 */
	@RequestMapping(params="df_method_nm=getBatchOpertForRegist")
	public String selectBatchOpertForRegist(@ModelAttribute("searchVO")BatchOpert batchOpert, ModelMap model)
	  throws Exception{
        model.addAttribute("batchOpert", batchOpert);

        return "/egovframework/com/sym/bat/BD_EgovBatchOpertRegist";
	}

	/**
	 * 수정화면을 위한 배치작업정보을 조회한다.
	 * @return 리턴URL
	 *
	 * @param batchOpert 조회대상 배치작업model
	 * @param model		ModelMap
	 * @exception Exception Exception
	 */
	@RequestMapping(params="df_method_nm=getBatchOpertForUpdate")
	public String selectBatchOpertForUpdate(@ModelAttribute("searchVO")BatchOpert batchOpert, ModelMap model)
	  throws Exception{
		LOGGER.debug(" 조회조건 : {}", batchOpert);
		BatchOpert result = egovBatchOpertService.selectBatchOpert(batchOpert);
		model.addAttribute("batchOpert", result);
		LOGGER.debug(" 결과값 : {}", result);

		return "/egovframework/com/sym/bat/BD_EgovBatchOpertUpdt";
	}

	/**
	 * 배치작업 목록을 조회한다.
	 * @return 리턴URL
	 *
	 * @param searchVO 목록조회조건VO
	 * @param model		ModelMap
	 * @param popupAt	팝업여부
	 * @exception Exception Exception
	 */
	@RequestMapping("")
	public String selectBatchOpertList(@ModelAttribute("searchVO")BatchOpert searchVO, ModelMap model, @RequestParam(value="popupAt", required=false)String popupAt)
	  throws Exception{
		
		int totCnt = egovBatchOpertService.selectBatchOpertListCnt(searchVO);

		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(searchVO.getPageIndex()).totalRowCount(totCnt).rowSize(searchVO.getPageSize()).build();
		pager.makePaging();

		searchVO.setRecordCountPerPage(pager.getLimitTo());
		searchVO.setFirstIndex(pager.getLimitFrom());
		
		List<BatchOpert> resultList = (List<BatchOpert>) egovBatchOpertService.selectBatchOpertList(searchVO);
		
		model.addAttribute("resultList", resultList);
		model.addAttribute("resultCnt", totCnt);
		
		model.addAttribute("pager", pager);
		
		if ("Y".equals(popupAt)) {
			// Popup 화면이면
			return "/egovframework/com/sym/bat/PD_EgovBatchOpertListPopup";
		} else {
			// 메인화면 호출이면
			return "/egovframework/com/sym/bat/BD_EgovBatchOpertList";
		}

	}

	/**
	 * 배치작업을 수정한다.
	 * @return 리턴URL
	 *
	 * @param batchOpert 수정대상 배치작업model
	 * @param bindingResult		BindingResult
	 * @param model				ModelMap
	 * @exception Exception Exception
	 */
	@RequestMapping(params="df_method_nm=updateBatchOpert")
	public String updateBatchOpert(BatchOpert batchOpert, BindingResult bindingResult, ModelMap model)
	  throws Exception{

		UserVO userVo = SessionUtil.getUserInfo();
        
		batchOpertValidator.validate(batchOpert, bindingResult);
		if (bindingResult.hasErrors()) {
			model.addAttribute("batchOpert", batchOpert);
		    return "/egovframework/com/sym/bat/BD_EgovBatchOpertUpdt";
		}
		
		// 정보 업데이트
		batchOpert.setUpdusr(userVo.getUserNo());
	    egovBatchOpertService.updateBatchOpert(batchOpert);

	    model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.update", new String[]{"배치작업"}, Locale.getDefault()));
	    
		return selectBatchOpertList(batchOpert, model, "N");

	}

	/**
	 * 배치작업 조회팝업을 실행한다.
	 * @return 리턴URL
	 *
	 * @param searchVO 목록조회조건VO
	 * @param model		ModelMap
	 * @exception Exception Exception
	 */
	@RequestMapping(params="df_method_nm=getBatchOpertListPopup")
	public String openPopupWindow(@ModelAttribute("searchVO") BatchOpert searchVO, ModelMap model)
	  throws Exception {
		return "/egovframework/com/sym/bat/PD_EgovBatchOpertListPopupFrame";
	}

}