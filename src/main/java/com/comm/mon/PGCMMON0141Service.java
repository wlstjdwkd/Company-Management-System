package com.comm.mon;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.page.Pager;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.comm.mapif.PGCMMON0141Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 	일별업무별접속통계
 * 
 */
@Service("PGCMMON0141")
public class PGCMMON0141Service extends EgovAbstractServiceImpl
{
	private static final Logger logger = LoggerFactory.getLogger(PGCMMON0141Service.class);
	
	@Resource(name = "PGCMMON0141Mapper")
	PGCMMON0141Mapper pgcmmon0141DAO;
	
	/**
	 * 일별 업무별 접속 통계
	 */
	public ModelAndView index (Map<?, ?> rqstMap) throws Exception
	{
		HashMap indexInfo = new HashMap();
		HashMap param = new HashMap();
		java.util.Calendar cal = java.util.Calendar.getInstance();
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		String searchDate = MapUtils.getString(rqstMap, "searchDate");
		
		if(searchDate == null) {
				cal.add(Calendar.DATE, -1);
				SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
				searchDate = dateFormatter.format(cal.getTime());
		}
		// yyyymmdd 형태로 만들어주기 위함
		String[] result = searchDate.split("-");
		param.put("searchDate", result[0]+result[1]+result[2]);
		indexInfo.put("searchDate", searchDate.replace("-", ""));
		
		// 업무갯수 20개
		//int totalPgCnt = 20;
		int totalPgCnt = pgcmmon0141DAO.findLogCnt(indexInfo);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalPgCnt).rowSize(rowSize).build();
		pager.makePaging();
		int pagerNo = pager.getIndexNo();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("pager", pager);
		mv.addObject("pagerNo", pagerNo);
		mv.addObject("indexInfo", indexInfo);
		
		// 일별 업무별 접속 통계
		mv.addObject("visitStatsList", pgcmmon0141DAO.findVisitStats(param));
		// 일별 총 접속사용자수
		mv.addObject("totalVisitstats", pgcmmon0141DAO.findTotalVisitstats(param));
		
		//mv.setViewName("/admin/ms/BD_UIMSA0141");
		mv.setViewName("/admin/comm/mon/BD_UICMMONA0141");
		return mv;
	}
}
