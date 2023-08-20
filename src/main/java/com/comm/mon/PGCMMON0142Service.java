package com.comm.mon;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.mapif.PGCMMON0142Mapper;
import com.comm.page.Pager;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/*
 * view execution log
 */
@Service("PGCMMON0142")
public class PGCMMON0142Service extends EgovAbstractServiceImpl
{
	private static final Logger logger = LoggerFactory.getLogger(PGCMMON0142Service.class);
	
	@Resource(name = "PGCMMON0142Mapper")
	PGCMMON0142Mapper pgcmmon0142DAO;
	
	public ModelAndView index (Map<?, ?> rqstMap) throws Exception
	{
		HashMap indexInfo = new HashMap();
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		String searchSelect = MapUtils.getString(rqstMap, "searchSelect");
		String searchWrd = MapUtils.getString(rqstMap, "searchWrd");
		String searchDate = MapUtils.getString(rqstMap, "searchDate");
		
		indexInfo.put("searchSelect", searchSelect);
		indexInfo.put("searchWrd", searchWrd);
		indexInfo.put("searchDate", searchDate);
		
		int totalPgCnt = pgcmmon0142DAO.findJoinLogCnt(indexInfo);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalPgCnt).rowSize(rowSize).build();
		pager.makePaging();
		int pagerNo = pager.getIndexNo();
		indexInfo.put("limitFrom", pager.getLimitFrom());
		indexInfo.put("limitTo", pager.getLimitTo());

		ModelAndView mv = new ModelAndView();

		mv.addObject("pager", pager);
		mv.addObject("pagerNo", pagerNo);
		mv.addObject("indexInfo", indexInfo);
		mv.addObject("joinLogList", pgcmmon0142DAO.findJoinLog(indexInfo));
		//mv.setViewName("/admin/ms/BD_UIMSA0142");
		mv.setViewName("/admin/comm/mon/BD_UICMMONA0142");
		
		return mv;
	}
	
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
}
