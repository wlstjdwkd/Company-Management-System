package egovframework.com.sym.bat.web;
import java.util.Date;
import java.util.Calendar;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.sym.bat.service.BatchOpert;
import egovframework.com.sym.bat.service.BatchSchdul;
import egovframework.com.sym.bat.service.BatchScheduler;
import egovframework.com.sym.bat.service.EgovBatchOpertService;
import egovframework.com.sym.bat.service.EgovBatchSchdulService;
import egovframework.com.sym.bat.validation.BatchSchdulValidator;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;
import egovframework.rte.fdl.property.EgovPropertyService;

import javax.annotation.Resource;

import com.comm.code.CodeService;
import com.comm.page.Pager;
import com.comm.user.UserVO;
import com.infra.util.DateUtil;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;

import org.apache.commons.lang.StringUtils;
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
 * 배치스케줄관리에 대한 controller 클래스
 *
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
@RequestMapping("/PGMS0060.do")
public class EgovBatchSchdulController {

	/** egovBatchSchdulService */
	@Resource(name = "egovBatchSchdulService")
	private EgovBatchSchdulService egovBatchSchdulService;

	/* Property 서비스 */
    @Resource(name="propertiesService")
    private EgovPropertyService propertyService;

    /** ID Generation */
	@Resource(name="egovBatchSchdulIdGnrService")
	private EgovIdGnrService idgenService;

    /* batchSchdul bean validator */
    @Resource(name="batchSchdulValidator")
    private BatchSchdulValidator batchSchdulValidator;
    
	/** 배치스케줄러 서비스 */
	@Resource(name = "batchScheduler")
	private BatchScheduler batchScheduler;
	
	@Autowired
	CodeService codeService;
	
	@Autowired
	private EgovBatchOpertService batchOpertService;
	
    /* 메세지 서비스 */
    @Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource;

	/** logger */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovBatchSchdulController.class);

	/**
	 * 배치스케줄을 삭제한다.
	 * @return 리턴URL
	 *
	 * @param batchSchdul 삭제대상 배치스케줄model
	 * @param model		ModelMap
	 * @exception Exception Exception
	 */
    @RequestMapping(params="df_method_nm=deleteBatchSchdul")	
	public String deleteBatchSchdul(BatchSchdul batchSchdul, ModelMap model)
	  throws Exception{

		// 배치스케줄러에 스케줄정보반영
		batchScheduler.deleteBatchSchdul(batchSchdul);

    	egovBatchSchdulService.deleteBatchSchdul(batchSchdul);

    	model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.delete", new String[]{"배치스케줄"}, Locale.getDefault()));
    	
    	return selectBatchSchdulList(batchSchdul, model);
	}

	/**
	 * 배치스케줄을 등록한다.
	 * @return 리턴URL
	 *
	 * @param batchSchdul 등록대상 배치스케줄model
	 * @param bindingResult	BindingResult
	 * @param model			ModelMap
	 * @exception Exception Exception
	 */
    @RequestMapping(params="df_method_nm=insertBatchSchdul")
	public String insertBatchSchdul(BatchSchdul batchSchdul, BindingResult bindingResult, ModelMap model)
	  throws Exception{
    	LOGGER.debug(" 인서트 대상정보 : {}", batchSchdul);

		UserVO userVo = SessionUtil.getUserInfo();
		
		batchSchdulValidator.validate(batchSchdul, bindingResult);
    	if (bindingResult.hasErrors()){
    		referenceData(model);
    		return "/egovframework/com/sym/bat/BD_EgovBatchSchdulRegist";
		}else{
		
			batchSchdul.setBatchSchdulId(idgenService.getNextStringId());
			//아이디 설정
			batchSchdul.setUpdusr(userVo.getUserNo());
			batchSchdul.setRegister(userVo.getUserNo());
	
			egovBatchSchdulService.insertBatchSchdul(batchSchdul);
	
			// 배치스케줄러에 스케줄정보반영
			BatchSchdul target = egovBatchSchdulService.selectBatchSchdul(batchSchdul);
			batchScheduler.insertBatchSchdul(target);
	
	        //Exception 없이 진행시 등록성공메시지
			model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.insert", new String[]{"배치스케줄"}, Locale.getDefault()));
		}
    	return selectBatchSchdulList(batchSchdul, model);
	}

	/**
	 * 배치스케줄정보을 상세조회한다.
	 * @return 리턴URL
	 *
	 * @param batchSchdul 조회대상 배치스케줄model
	 * @param model		ModelMap
	 * @exception Exception Exception
	 */
    @RequestMapping(params="df_method_nm=getBatchSchdul")
	public String selectBatchSchdul(@ModelAttribute("searchVO")BatchSchdul batchSchdul, ModelMap model)
	  throws Exception{
    	LOGGER.debug(" 조회조건 : {}", batchSchdul);
		BatchSchdul result = egovBatchSchdulService.selectBatchSchdul(batchSchdul);
		model.addAttribute("resultInfo", result);
		LOGGER.debug(" 결과값 : {}", result);

		return "/egovframework/com/sym/bat/BD_EgovBatchSchdulDetail";
	}

	/**
	 * 등록화면을 위한 배치스케줄정보을 조회한다.
	 * @return 리턴URL
	 *
	 * @param batchSchdul 조회대상 배치스케줄model
	 * @param model		ModelMap
	 * @exception Exception Exception
	 */
	@RequestMapping(params="df_method_nm=getBatchSchdulForRegist")
	public String selectBatchSchdulForRegist(@ModelAttribute("searchVO")BatchSchdul batchSchdul, ModelMap model)
	  throws Exception{
		referenceData(model);

        model.addAttribute("batchSchdul", batchSchdul);

        return "/egovframework/com/sym/bat/BD_EgovBatchSchdulRegist";
	}

	/**
	 * 수정화면을 위한 배치스케줄정보을 조회한다.
	 * @return 리턴URL
	 *
	 * @param batchSchdul 조회대상 배치스케줄model
	 * @param model		ModelMap
	 * @exception Exception Exception
	 */
	@RequestMapping(params="df_method_nm=getBatchSchdulForUpdate")
	public String selectBatchSchdulForUpdate(@ModelAttribute("searchVO")BatchSchdul batchSchdul, ModelMap model)
	  throws Exception{
		referenceData(model);

		LOGGER.debug(" 조회조건 : {}", batchSchdul);
		BatchSchdul result = egovBatchSchdulService.selectBatchSchdul(batchSchdul);
		model.addAttribute("batchSchdul", result);
		LOGGER.debug(" 결과값 : {}", result);

        return "/egovframework/com/sym/bat/BD_EgovBatchSchdulUpdt";
	}

	/**
	 * Reference Data 를 설정한다.
	 * @param model   화면용spring Model객체
	 * @throws Exception
	 */
	private void referenceData(ModelMap model) throws Exception {
		
     	//공통코드  직업유형 조회
    	List listComCode = codeService.findCodesByGroupNo("6");
    	model.addAttribute("executCycleList", listComCode);
    	
     	//공통코드  직업유형 조회
    	listComCode = codeService.findCodesByGroupNo("7");
    	model.addAttribute("executSchdulDfkSeList", listComCode);

        // 실행스케줄 시, 분, 초 값 설정.
    	Map executSchdulHourList =new LinkedHashMap();
    	for (int i = 0; i < 24; i++) {
    		if (i < 10) {
    			executSchdulHourList.put("0" + Integer.toString(i), "0" + Integer.toString(i));
    		} else {
    			executSchdulHourList.put(Integer.toString(i), Integer.toString(i));
    		}
    	}
    	model.addAttribute("executSchdulHourList",executSchdulHourList);
    	Map executSchdulMntList =new LinkedHashMap();
    	for (int i = 0; i < 60; i++) {
    		if (i < 10) {
    			executSchdulMntList.put("0" + Integer.toString(i), "0" + Integer.toString(i));
    		} else {
    			executSchdulMntList.put(Integer.toString(i), Integer.toString(i));
    		}
    	}
    	model.addAttribute("executSchdulMntList",executSchdulMntList);
    	Map executSchdulSecndList =new LinkedHashMap();
    	for (int i = 0; i < 60; i=i+10) {
    		if (i < 10) {
    			executSchdulSecndList.put("0" + Integer.toString(i), "0" + Integer.toString(i));
    		} else {
    			executSchdulSecndList.put(Integer.toString(i), Integer.toString(i));
    		}
    	}
    	model.addAttribute("executSchdulSecndList",executSchdulSecndList);
	}

	/**
	 * 배치스케줄 목록을 조회한다.
	 * @return 리턴URL
	 *
	 * @param searchVO 목록조회조건VO
	 * @param model		ModelMap
	 * @exception Exception Exception
	 */
	@RequestMapping("")
	public String selectBatchSchdulList(@ModelAttribute("searchVO")BatchSchdul searchVO, ModelMap model)
	  throws Exception{
		
		int totCnt = egovBatchSchdulService.selectBatchSchdulListCnt(searchVO);
        
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(searchVO.getPageIndex()).totalRowCount(totCnt).rowSize(searchVO.getPageSize()).build();
		pager.makePaging();
		
		searchVO.setRecordCountPerPage(pager.getLimitTo());
		searchVO.setFirstIndex(pager.getLimitFrom());
		
		List<BatchSchdul> resultList = (List<BatchSchdul>) egovBatchSchdulService.selectBatchSchdulList(searchVO);
		
		model.addAttribute("pager", pager);

		model.addAttribute("resultList", resultList);
		model.addAttribute("resultCnt", totCnt);

		return "/egovframework/com/sym/bat/BD_EgovBatchSchdulList";
	}

	/**
	 * 배치스케줄을 수정한다.
	 * @return 리턴URL
	 *
	 * @param batchSchdul 수정대상 배치스케줄model
	 * @param bindingResult		BindingResult
	 * @param model				ModelMap
	 * @exception Exception Exception
	 */
	@RequestMapping(params="df_method_nm=updateBatchSchdul")
	public String updateBatchSchdul(BatchSchdul batchSchdul, BindingResult bindingResult, ModelMap model)
	  throws Exception{
		//로그인 객체 선언
		UserVO userVo = SessionUtil.getUserInfo();

		batchSchdulValidator.validate(batchSchdul, bindingResult);
		if (bindingResult.hasErrors()) {
			referenceData(model);
			model.addAttribute("batchSchdul", batchSchdul);
		    return "/egovframework/com/sym/bat/BD_EgovBatchSchdulUpdt";
		}
		
		// 정보 업데이트
		batchSchdul.setUpdusr(userVo.getUserNo());
	    egovBatchSchdulService.updateBatchSchdul(batchSchdul);

		// 배치스케줄러에 스케줄정보반영
		BatchSchdul target = egovBatchSchdulService.selectBatchSchdul(batchSchdul);
		batchScheduler.updateBatchSchdul(target);

		model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.update", new String[]{"배치스케줄"}, Locale.getDefault()));
		
		return selectBatchSchdulList(batchSchdul, model);

	}

	
	/**
	 * 배치스케줄을 등록한다.
	 * @return 리턴URL
	 *
	 * @param batchSchdul 등록대상 배치스케줄model
	 * @param bindingResult	BindingResult
	 * @param model			ModelMap
	 * @exception Exception Exception
	 */
    @RequestMapping(params="df_method_nm=insertManualBatch")
	public ModelAndView insertManualBatch(BatchSchdul batchSchdul, BindingResult bindingResult, ModelMap model)
	  throws Exception{
    	
    	LOGGER.debug(" 인서트 대상정보 : {}", batchSchdul);

    	ModelAndView mv = new ModelAndView();
		UserVO userVo = SessionUtil.getUserInfo();
		
    	if (StringUtils.isEmpty(batchSchdul.getBatchOpertId())) {
    		LOGGER.error(egovMessageSource.getMessage("errors.required", new String[] {"batchOpertId"}, Locale.getDefault()));
   		
    		return ResponseUtil.responseJson(mv, false, egovMessageSource.getMessage("errors.required", new String[] {"batchOpertId"}, Locale.getDefault()));
    		
		} else {
			LOGGER.debug("배치 수동 실행");
			BatchOpert batchOpert = new BatchOpert();
			batchOpert.setBatchOpertId(batchSchdul.getBatchOpertId());
			batchOpert = batchOpertService.selectBatchOpert(batchOpert);
			
			Date now = Calendar.getInstance().getTime();
			
			batchSchdul.setBatchSchdulId("MANUAL_ONCE");
			batchSchdul.setExecutSchdulDe(DateUtil.getDate(now));
			
			batchSchdul.setBatchProgrm(batchOpert.getBatchProgrm());
			batchSchdul.setParamtr(batchOpert.getParamtr());
			
			//아이디 설정
			batchSchdul.setUpdusr(userVo.getUserNo());
			batchSchdul.setRegister(userVo.getUserNo());
	
			// 배치스케줄러에 스케줄정보반영
			batchScheduler.insertBatchSchdul(batchSchdul);
		}
    	
    	return ResponseUtil.responseJson(mv, true, egovMessageSource.getMessage("success.request.msg", new String[] {}, Locale.getDefault()));
	}
}