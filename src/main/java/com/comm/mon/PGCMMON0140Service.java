package com.comm.mon;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.comm.response.ExcelVO;
import com.comm.response.IExcelVO;
import com.infra.util.ResponseUtil;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.comm.mapif.PGCMMON0140Mapper;
import com.comm.mapif.PGCMMON0142Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 	방문자 통계
 * 
 */
@Service("PGCMMON0140")
public class PGCMMON0140Service extends EgovAbstractServiceImpl
{
	private static final Logger logger = LoggerFactory.getLogger(PGCMMON0140Service.class);
	
	@Resource(name = "PGCMMON0142Mapper")
	private PGCMMON0142Mapper pgcmmon0142DAO;
	
	@Resource(name = "PGCMMON0140Mapper")
	PGCMMON0140Mapper pgcmmon0140DAO;
	
	/**
	 * 요청로그 등록
	 * @param param	요청로그정보(로그ID, 프로그램ID, 메소드명, 요청자번호 ...)
	 * @return
	 * @throws Exception
	 */
	public int insertRequestLog(Map<?,?> param) throws Exception
	{
		return pgcmmon0142DAO.insertRequestLog(param);
	}
	
	/**
	 * 방문자 통계
	 */
	public ModelAndView processVisitStats(Map<?, ?> rqstMap) throws Exception
	{
		HashMap param = new HashMap();
		HashMap indexInfo = new HashMap();
		ModelAndView mv = new ModelAndView();
		
		java.util.Calendar cal = java.util.Calendar.getInstance();
		//검색(조회) 조건 
		String searchYear = MapUtils.getString(rqstMap, "searchYear");
		String searchMonth = MapUtils.getString(rqstMap, "searchMonth");
		
		if(searchYear == null) {
			searchYear = Integer.toString(cal.get(Calendar.YEAR));
		}
		if(searchMonth == null) {
			if((cal.get(Calendar.MONTH))+1 < 10) {
				searchMonth = Integer.toString((cal.get(Calendar.MONTH))+1);
				searchMonth = "0"+searchMonth;
			}
			else {
				searchMonth = Integer.toString((cal.get(Calendar.MONTH))+1);
			}
		}
		
		String de = searchYear + searchMonth;
		param.put("de", de);
		indexInfo.put("searchYear", searchYear);
		indexInfo.put("searchMonth", searchMonth);

		mv.addObject("visitStatsList",pgcmmon0140DAO.callVisitStats(param));
		mv.addObject("beforeVisitStats", pgcmmon0140DAO.findBeforeVisitStats(param));
		mv.addObject("totalVisitStats", pgcmmon0140DAO.findTotalVisitStats());
		mv.addObject("indexInfo", indexInfo);
		mv.addObject("currentYear", Integer.toString(cal.get(Calendar.YEAR)));
		
		//mv.setViewName("/admin/ms/BD_UIMSA0140");
		mv.setViewName("/admin/comm/mon/BD_UICMMONA0140");
		return mv;
	}

	
	public ModelAndView processExcelRsolver(Map<?,?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		
		HashMap param = new HashMap();
		HashMap indexInfo = new HashMap();
		
		java.util.Calendar cal = java.util.Calendar.getInstance();
		//검색(조회) 조건 
		String searchYear = MapUtils.getString(rqstMap, "searchYear");
		String searchMonth = MapUtils.getString(rqstMap, "searchMonth");
		
		if(searchYear == null) {
			searchYear = Integer.toString(cal.get(Calendar.YEAR));
		}
		if(searchMonth == null) {
			if((cal.get(Calendar.MONTH))+1 < 10) {
				searchMonth = Integer.toString((cal.get(Calendar.MONTH))+1);
				searchMonth = "0"+searchMonth;
			}
			else {
				searchMonth = Integer.toString((cal.get(Calendar.MONTH))+1);
			}
		}
		String de = searchYear + searchMonth;
		param.put("de", de);
		
		// 총 발급업무관리 글 개수
		int totalRowCnt = 10;
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(1).totalRowCount(totalRowCnt).rowSize(totalRowCnt).build();
		pager.makePaging();		
		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());

		List<Map> visitStatsList = pgcmmon0140DAO.callVisitStats(param);
		
		mv.addObject("_list",visitStatsList);
		
		Map beforeVisitStats = pgcmmon0140DAO.findBeforeVisitStats(param);
		mv.addObject("beforeVisitStats", beforeVisitStats);
		
        String[] headers = {
            "일",
            searchYear+"-"+searchMonth,
            "당월누적합계",
            "누적총합계"
        };
        String[] items = {
            "de",
            "sum_day",
            "acc_day",
            "total_day"
        };

        mv.addObject("_headers", headers);
        mv.addObject("_items", items);

        IExcelVO excel = new ExcelVO("방문자통계 리스트");
		return ResponseUtil.responseExcel(mv, excel);
	}
}