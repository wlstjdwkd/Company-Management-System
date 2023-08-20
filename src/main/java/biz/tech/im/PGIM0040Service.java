package biz.tech.im;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.im.PGIM0040Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 위변조문서신고내역
 * 
 * @author KMY
 *
 */
@Service("PGIM0040")
public class PGIM0040Service extends EgovAbstractServiceImpl{
	
	private static final Logger logger = LoggerFactory.getLogger(PGIM0040Service.class);
	
	@Resource(name = "PGIM0040Mapper")
	private PGIM0040Mapper pgim0040Mapper;
	
	/**
	 * 위변조문서신고내역 화면
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<? , ?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		ModelAndView mv = new ModelAndView();
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		String fromDate = MapUtils.getString(rqstMap, "q_pjt_start_dt");
		String toDate = MapUtils.getString(rqstMap, "q_pjt_end_dt");
		
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
		
		// 총 프로그램 갯수
		int totalRowCnt = pgim0040Mapper.findDocReportListCnt(param);
				
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		// 프로그램 글 조회
		List<Map> docReportList = pgim0040Mapper.findDocReportList(param);
		
		// 날짜 포맷
		if(Validate.isNotEmpty(docReportList)) {
			for(int i=0; i<totalRowCnt; i++) {
				Map telNo = StringUtil.telNumFormat((String) docReportList.get(i).get("telNo"));
				docReportList.get(i).put("telNo", telNo);
			}
		}
		mv.addObject("inparam", param);
		mv.addObject("pager", pager);
		mv.addObject("docReportList", docReportList);
		mv.setViewName("/admin/im/BD_UIIMA0040");
		
		return mv;
	}
}
