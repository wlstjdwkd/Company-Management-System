package egovframework.com.sym.bat.web;
import java.util.List;
import java.util.Locale;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.sym.bat.service.BatchResult;
import egovframework.com.sym.bat.service.EgovBatchResultService;
import egovframework.rte.fdl.property.EgovPropertyService;

import javax.annotation.Resource;

import com.comm.page.Pager;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 배치결과관리에 대한 controller 클래스
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
@RequestMapping("/PGMS0070.do")
public class EgovBatchResultController {

	/** egovBatchResultService */
	@Resource(name = "egovBatchResultService")
	private EgovBatchResultService egovBatchResultService;

	/* Property 서비스 */
    @Resource(name="propertiesService")
    private EgovPropertyService propertyService;

    /*  메세지 서비스 */
    @Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource;

	/** logger */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovBatchResultController.class);

	/**
	 * 배치결과을 삭제한다.
	 * @return 리턴URL
	 *
	 * @param batchResult 삭제대상 배치결과model
	 * @param model		ModelMap
	 * @exception Exception Exception
	 */
    @RequestMapping(params="df_method_nm=deleteBatchResult")
	public String deleteBatchResult(BatchResult batchResult, ModelMap model)
	  throws Exception{

    	egovBatchResultService.deleteBatchResult(batchResult);
    	
    	model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.delete", new String[]{"배치결과"}, Locale.getDefault()));
    	
    	return selectBatchResultList(batchResult, model);
	}

	/**
	 * 배치결과정보을 상세조회한다.
	 * @return 리턴URL
	 *
	 * @param batchResult 조회대상 배치결과model
	 * @param model		ModelMap
	 * @exception Exception Exception
	 */
    @RequestMapping(params="df_method_nm=getBatchResult")
	public String selectBatchResult(@ModelAttribute("searchVO")BatchResult batchResult, ModelMap model)
	  throws Exception{
    	LOGGER.debug(" 조회조건 : {}", batchResult);
		BatchResult result = egovBatchResultService.selectBatchResult(batchResult);
		model.addAttribute("resultInfo", result);
		LOGGER.debug(" 결과값 : {}", result);

		return "/egovframework/com/sym/bat/BD_EgovBatchResultDetail";
	}

	/**
	 * 배치결과 목록을 조회한다.
	 * @return 리턴URL
	 *
	 * @param searchVO 목록조회조건VO
	 * @param model		ModelMap
	 * @exception Exception Exception
	 */
    @RequestMapping("")
	public String selectBatchResultList(@ModelAttribute("searchVO")BatchResult searchVO, ModelMap model)
	  throws Exception{

		int totCnt = egovBatchResultService.selectBatchResultListCnt(searchVO);
        
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(searchVO.getPageIndex()).totalRowCount(totCnt).rowSize(searchVO.getPageSize()).build();
		pager.makePaging();

		searchVO.setRecordCountPerPage(pager.getLimitTo());
		searchVO.setFirstIndex(pager.getLimitFrom());
		
		List<BatchResult> resultList = (List<BatchResult>) egovBatchResultService.selectBatchResultList(searchVO);
		
		model.addAttribute("pager", pager);

		model.addAttribute("resultList", resultList);
		model.addAttribute("resultCnt", totCnt);

		return "/egovframework/com/sym/bat/BD_EgovBatchResultList";
	}


}