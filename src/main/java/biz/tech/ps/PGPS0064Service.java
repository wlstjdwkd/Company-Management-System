package biz.tech.ps;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.comm.response.GridJsonVO;
import com.infra.util.ResponseUtil;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.ps.PGPS0064Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


/**
 * 현황및통계
 * @author JGS
 *
 */
@Service("PGPS0064")
public class PGPS0064Service extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(PGPS0064Service.class);
	
	@Resource(name = "PGPS0064Mapper")
	private PGPS0064Mapper entprsDAO;
	
	/**
	 * 성장및회귀현황>업종별성장현황
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?,?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		param.put("param", 41);
		
		// 테마별업종 조회(코드그룹별)
		List<Map> indutyCode = new ArrayList<Map>();
		indutyCode = entprsDAO.findCodesByGroupNo(param);
		
		ModelAndView mv = new ModelAndView("/admin/ps/BD_UIPSA0064");
		mv.addObject("indutyCode", indutyCode);
		return mv;
	}
	
	/**
	 * 성장및회귀현황>업종별성장현황
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getGridSttusList(Map<?, ?> rqstMap) throws Exception {	
		HashMap param = new HashMap();
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("sel_target_year")) param.put("sel_target_year", MapUtils.getIntValue(rqstMap, "sel_target_year"));
		logger.debug("--------------getGridSttusList > searchCondition: "+rqstMap.get("searchCondition"));
		logger.debug("--------------getGridSttusList > sel_target_year: "+MapUtils.getIntValue(rqstMap, "sel_target_year"));
		
		String tmp1="";
		String tmp2="";
		String[] array_tmp1;
		String[] array_tmp2;
		String multiSelectGrid1 = "";
		//String multiSelectGrid2 = "";
		
		if (rqstMap.containsKey("multiSelectGrid1")) tmp1= (String) rqstMap.get("multiSelectGrid1");
		if (rqstMap.containsKey("multiSelectGrid2")) tmp2 = (String) rqstMap.get("multiSelectGrid2");
		
		if(tmp1 != null && tmp1 != "") {
			logger.debug("------tmp1:"+tmp1);
			
			array_tmp1 = tmp1.split(",");
			
			logger.debug("------array_tmp1.length:"+array_tmp1.length);
			
			for(int i=0; i < array_tmp1.length; i++) {
				logger.debug("------array_tmp1["+i+"]:"+array_tmp1[i]);
				if("UT00".equals(array_tmp1[i])) multiSelectGrid1 = multiSelectGrid1 + " AND INDUTY_NM = '전산업'";
				if("UT01".equals(array_tmp1[i])) multiSelectGrid1 = multiSelectGrid1 + " AND INDUTY_NM = '제조업'";
				if("UT02".equals(array_tmp1[i])) multiSelectGrid1 = multiSelectGrid1 + " AND INDUTY_NM = '비제조업'";
			}
		}
		
		if(tmp2 != null && tmp2 != "") {
			array_tmp2 = tmp2.split(",");
		}
		
		logger.debug("multiSelectGrid1: "+param.get("multiSelectGrid1"));
		
		int pageNo = MapUtils.getIntValue(rqstMap, "page");
		int rowSize = MapUtils.getIntValue(rqstMap, "rows");
		logger.debug("rowSize: "+rowSize);
		
		// 총 메뉴 글 개수
		int totalRowCnt = entprsDAO.findTotalIdxInfoRowCnt(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		
		//param.put("limitFrom", pager.getLimitFrom());
		//param.put("limitTo", pager.getLimitTo());
		param.put("pageNo", pageNo);
		param.put("rowSize", rowSize);
		
		// 성장및회귀현황>업종별성장현황
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.selectSttus(param);
		
		logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&: "+entprsList.toString());
		
		GridJsonVO gridJsonVo = new GridJsonVO();
		gridJsonVo.setPage(pager.getPageNo());
		gridJsonVo.setTotal(pager.getPageSize());
		gridJsonVo.setRecords(pager.getTotalRowCount());
		gridJsonVo.setRows(entprsList);
		
		ModelAndView mv = new ModelAndView();
		return ResponseUtil.responseGridJson(mv, gridJsonVo);	
	}
}
