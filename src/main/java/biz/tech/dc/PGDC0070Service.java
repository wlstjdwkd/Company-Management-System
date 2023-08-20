package biz.tech.dc;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.infra.util.ResponseUtil;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.sp.PGSP0030Mapper;

/**
 * 지원사업수집관리
 * @author DST
 *
 */
@Service("PGDC0070")
public class PGDC0070Service {

	private static final Logger logger = LoggerFactory.getLogger(PGDC0070Service.class);
	
	@Resource(name = "PGSP0030Mapper")
	private PGSP0030Mapper pgsp0030Mapper;
	
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
	
		HashMap param = new HashMap();
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		String searchKeyword = MapUtils.getString(rqstMap, "searchKeyword");
		String regDate = MapUtils.getString(rqstMap, "q_pjt_reg_dt");
	
		param.put("searchKeyword", searchKeyword);
		param.put("q_pjt_reg_dt", regDate);
		
		// 총 프로그램 갯수
		int totalRowCnt = pgsp0030Mapper.findRssListCnt(param);
	
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
	
		// 프로그램 글 조회
		List<Map> rsssiteList = pgsp0030Mapper.findRssList(param);
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("pager", pager);
		mv.addObject("rsssiteList", rsssiteList);
		mv.addObject("inparam",param);

		mv.setViewName("/admin/dc/BD_UIDCA0070");
		
		return mv;
	}

	public ModelAndView regRssSite(Map<?, ?> rqstMap) throws Exception {
		
		HashMap param = new HashMap();
		
		String rssNo = MapUtils.getString(rqstMap, "rssno");
	
		param.put("rssNo", rssNo);
		
		// 페이저 빌드
		// 프로그램 글 조회
		List<Map> rsssiteList = pgsp0030Mapper.findRss(param);
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("rsssiteList", rsssiteList);

		mv.setViewName("/admin/dc/PD_UIDCA0071");
		
		return mv;
	}
	
public ModelAndView insertRssSite(Map<?, ?> rqstMap) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		HashMap jsonMap = new HashMap();
		int retcnt = 0;
		
		String rssNo = MapUtils.getString(rqstMap, "rssNo");
		String siteNm = MapUtils.getString(rqstMap, "siteNm");
		String siteUrl = MapUtils.getString(rqstMap, "siteUrl");
		String flter1 = MapUtils.getString(rqstMap, "flter1");
		String flter2 = MapUtils.getString(rqstMap, "flter2");
		
		
		param.put("rssNo", rssNo);
		param.put("siteNm", siteNm);
		param.put("siteUrl", siteUrl);
		param.put("flter1", flter1);
		param.put("flter2", flter2);
		
		
		//지원수집 사이트 등록/수정
		
		if(rssNo != null && !rssNo.isEmpty())
		{
			retcnt = pgsp0030Mapper.updateRSSsite(param);
		}
		else
		{
			retcnt = pgsp0030Mapper.insertRSSsite(param);
			
		}

		jsonMap.put("retcnt", retcnt);					// 발급일자
		return ResponseUtil.responseJson(mv, true, jsonMap);
	}

}
