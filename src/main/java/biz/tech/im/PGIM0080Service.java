package biz.tech.im;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comm.response.IExcelVO;
import com.infra.util.ResponseUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.im.PGIM0080Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 확인서발급현황 > 신청기준집계
 */

@Service("PGIM0080")
public class PGIM0080Service extends EgovAbstractServiceImpl{
	
	@Autowired
	PGIM0080Mapper pgim0080Mapper;
	
	/**
	 * 확인서발급현황 > 신청기준집계 화면
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public ModelAndView index(Map<? , ?> rqstMap) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		@SuppressWarnings("rawtypes")
		HashMap param = new HashMap();
		
		// 신청기준집계 조회
		@SuppressWarnings("rawtypes")
		List<Map> applicationTotal = pgim0080Mapper.findApplicationTotal(param);
		
		String year, month;
		for(int i=0; i<applicationTotal.size(); i++) {
			year = (String) applicationTotal.get(i).get("YYYY");
			month = (String) applicationTotal.get(i).get("MM");
			year = year.substring(2);
			applicationTotal.get(i).put("year", year);
			
			if("소계".equals(month)) {
			} else {
				applicationTotal.get(i).put("MM", month + "월");
			}
		}
		
		mv.addObject("inparam", param);
		mv.addObject("applicationTotal", applicationTotal);
		
		mv.setViewName("/admin/im/BD_UIIMA0080");
		
		return mv;
	}
	
	/**
	 * 엑셀 다운로드
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public ModelAndView excelRsolver(Map<? , ?> rqstMap) throws Exception {
		
		@SuppressWarnings("rawtypes")
		HashMap param = new HashMap();
		ModelAndView mv = new ModelAndView();
		
		// 신청기준집계 조회
		@SuppressWarnings("rawtypes")
		List<Map> applicationTotal = pgim0080Mapper.findApplicationTotal(param);
		// 신청기준집계 년도별 카운트
		List<Integer> applicationTotalCnt = pgim0080Mapper.findApplicationTotalCnt(param);
		
		String year;
		String month;
		
		for(int i=0; i<applicationTotal.size(); i++) {
			year = (String) applicationTotal.get(i).get("YYYY");
			month = (String) applicationTotal.get(i).get("MM");
			year = year.substring(2);
			applicationTotal.get(i).put("year", year);
			
			if("소계".equals(month)) {
			} else {
				applicationTotal.get(i).put("MM", month + "월");
			}
		}
		
		mv.addObject("_list", applicationTotal);
		mv.addObject("_listCnt", applicationTotalCnt);
		
		// Header
		String header = "신청 월 기준";
		// SubHeader
		String[] subHeaders = {
	            "신청",
	            "접수",
	            "검토중",
	            "보완요청",
	            "보완접수",
	            "보완검토중",
	            "발급",
	            "반려",
	            "접수취소",
	            "발급취소"	                    
	    };
		//Item
	    String[] items = {
	            "YYYY",
	            "MM",
	            "PS0",
	            "PS1",
	            "PS2",
	            "PS3",
	            "PS4",
	            "PS5",
	            "RC1",
	            "RC2",
	            "RC3",
	            "RC4"
	    };
	    
	    mv.addObject("_headers", header);
	    mv.addObject("_subHeaders", subHeaders);
	    mv.addObject("_items", items);

	    IExcelVO excel = new IssuExcelVO("월별추진현황(신청기준집계)");
					
		return ResponseUtil.responseExcel(mv, excel);
	}
}