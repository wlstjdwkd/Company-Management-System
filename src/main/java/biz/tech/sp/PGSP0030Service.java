package biz.tech.sp;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.infra.util.StringUtil;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.sp.PGSP0030Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 기업정책
 * @author DST
 *
 */
@Service("PGSP0030")
public class PGSP0030Service extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(PGSP0030Service.class);
	
	@Resource(name = "PGSP0030Mapper")
	private PGSP0030Mapper pgsp0030Mapper;
	
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		
		HashMap param = new HashMap();
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		String searchKeyword = MapUtils.getString(rqstMap, "searchKeyword");
		String searchCondition = MapUtils.getString(rqstMap, "searchCondition");
		String searchDateType = MapUtils.getString(rqstMap, "searchDateType");
		String fromDate = MapUtils.getString(rqstMap, "q_pjt_start_dt");
		String toDate = MapUtils.getString(rqstMap, "q_pjt_end_dt");

		
		param.put("searchKeyword", searchKeyword);
		param.put("searchCondition", searchCondition);
		param.put("searchDateType", searchDateType);
		param.put("fromDate", fromDate);
		param.put("toDate", toDate);
		
		if(fromDate != null)
		{
			param.put("q_pjt_start_dt", fromDate.replace("-", ""));
		}
		if(fromDate != null)
		{
			param.put("q_pjt_end_dt", toDate.replace("-", ""));
		}
		
		param.put("ntceAt", "Y");
		
		// Tab 구분 설정
		String tabGb = MapUtils.getString(rqstMap, "tabGb");
		if(tabGb != null) {
			param.put("tabGb", tabGb);
		} else {
			param.put("tabGb", "A");
		}
		
		// 총 프로그램 갯수
		int totalRowCnt = pgsp0030Mapper.findSuportListCnt(param);

		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());

		// 프로그램 글 조회
		List<Map> suportList = pgsp0030Mapper.findSuportList(param);
		
		Map numMap = new HashMap();
		String num = null;
		for(int i=0; i<suportList.size(); i++) {	
			
			numMap = StringUtil.toDateFormat((String) suportList.get(i).get("opertnBginde"));
			num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last") ;
			suportList.get(i).put("opertnBginde", num);
			
			numMap = StringUtil.toDateFormat((String) suportList.get(i).get("opertnEndde"));
			num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last") ;
			suportList.get(i).put("opertnEndde", num);
		}
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("pager", pager);
		mv.addObject("suportList", suportList);
		mv.addObject("inparam",param);
		
		mv.setViewName("/www/sp/BD_UISPU0030");
		
		return mv;

	}
}
