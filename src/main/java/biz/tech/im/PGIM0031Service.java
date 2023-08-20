package biz.tech.im;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comm.response.IExcelVO;
import com.infra.util.ResponseUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.im.PGIM0031Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 확인서발급현황 > 월별기준집계
 * 
 * @author KMY
 *
 */
@Service("PGIM0031")
public class PGIM0031Service extends EgovAbstractServiceImpl{
	
	private static final Logger logger = LoggerFactory.getLogger(PGIM0031Service.class);
	
	@Autowired
	PGIM0031Mapper pgim0031Mapper;	

	/**
	 * 확인서발급현황 > 월별기준집계 화면
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<? , ?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		ModelAndView mv = new ModelAndView();
		
		String jdgmntReqstFromYear = MapUtils.getString(rqstMap, "ad_jdgmnt_reqst_year_from_search");
		String jdgmntReqstToYear = MapUtils.getString(rqstMap, "ad_jdgmnt_reqst_year_to_search");
		
		// 발급대상연도
		if(Validate.isNotEmpty(jdgmntReqstFromYear) && Validate.isNotEmpty(jdgmntReqstToYear)) {
			param.put("REQST_YEAR_FROM_SEARCH", jdgmntReqstFromYear+"0101");
			param.put("REQST_YEAR_TO_SEARCH", jdgmntReqstToYear+"1231");
		} 
		
		if(Validate.isNotEmpty(jdgmntReqstFromYear) && Validate.isNotEmpty(jdgmntReqstToYear)) {
			param.put("ad_REQST_YEAR_FROM_SEARCH", jdgmntReqstFromYear);
			param.put("ad_REQST_YEAR_TO_SEARCH", jdgmntReqstToYear);
		} else {
			param.put("ad_REQST_YEAR_FROM_SEARCH", "2011");
		}
		
		// 발급기준집계 조회
		List<Map> monthTotal = pgim0031Mapper.findMonthTotal(param);
		
		String year, month;
		for(int i=0; i<monthTotal.size(); i++) {
			year = (String) monthTotal.get(i).get("YYYY");
			month = (String) monthTotal.get(i).get("MM");
			year = year.substring(2);
			monthTotal.get(i).put("year", year);
			
			if("소계".equals(month)) {} 
			else {
				monthTotal.get(i).put("MM", month + "월");
			}
		}
		
		mv.addObject("inparam", param);
		mv.addObject("monthTotal", monthTotal);
		mv.setViewName("/admin/im/BD_UIIMA0031");
		return mv;
	}
	
	/**
	 * 엑셀 다운로드
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView excelRsolver(Map<? , ?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		ModelAndView mv = new ModelAndView();
		
		String jdgmntReqstFromYear = MapUtils.getString(rqstMap, "ad_jdgmnt_reqst_year_from_search");
		String jdgmntReqstToYear = MapUtils.getString(rqstMap, "ad_jdgmnt_reqst_year_to_search");
		
		// 발급대상연도
		if(Validate.isNotEmpty(jdgmntReqstFromYear) && Validate.isNotEmpty(jdgmntReqstToYear)) {
			param.put("REQST_YEAR_FROM_SEARCH", jdgmntReqstFromYear+"0101");
			param.put("REQST_YEAR_TO_SEARCH", jdgmntReqstToYear+"1231");
		} 
		
		if(Validate.isNotEmpty(jdgmntReqstFromYear) && Validate.isNotEmpty(jdgmntReqstToYear)) {
			param.put("ad_REQST_YEAR_FROM_SEARCH", jdgmntReqstFromYear);
			param.put("ad_REQST_YEAR_TO_SEARCH", jdgmntReqstToYear);
		} else {
			param.put("ad_REQST_YEAR_FROM_SEARCH", "2011");
		}
		
		// 발급기준집계 조회
		List<Map> monthTotal = pgim0031Mapper.findMonthTotal(param);
		// 발급기준집계 년도별 카운트
		List<Integer> monthTotalCnt = pgim0031Mapper.findMonthTotalCnt(param);
		
		String year, month;
		for(int i=0; i<monthTotal.size(); i++) {
			year = (String) monthTotal.get(i).get("YYYY");
			month = (String) monthTotal.get(i).get("MM");
			year = year.substring(2);
			monthTotal.get(i).put("year", year);
			
			if("소계".equals(month)) {} 
			else {
				monthTotal.get(i).put("MM", month + "월");
			}
		}
		
		mv.addObject("_list", monthTotal);
		mv.addObject("_listCnt", monthTotalCnt);
		// Header
		String header = "발급 및 발급 취소 기준";
		// SubHeader
		String[] subHeaders = {
	            "발급",
	            "내용변경",
	            "발급취소",
	            "유효기간중",
	            "유효기간만료"  
	        };
	    String[] items = {
	            "YYYY",
	            "MM",
	            "AK1",
	            "AK2",
	            "RC4",
	            "expiryDate",
	            "expiryDateEND"
	    };
	   
	    
	    mv.addObject("_headers", header);
	    mv.addObject("_subHeaders", subHeaders);
	    mv.addObject("_items", items);

	    IExcelVO excel = new IssuExcelVO("월별추진현황(발급기준집계)");
					
		return ResponseUtil.responseExcel(mv, excel);
		
	}
}
