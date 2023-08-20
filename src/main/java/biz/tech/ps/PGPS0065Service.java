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

import biz.tech.mapif.ps.PGPS0065Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


/**
 * 현황및통계
 * @author JGS
 *
 */
@Service("PGPS0065")
public class PGPS0065Service extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(PGPS0065Service.class);
	
	@Resource(name = "PGPS0065Mapper")
	private PGPS0065Mapper entprsDAO;
	
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
		
		ModelAndView mv = new ModelAndView("/admin/ps/BD_UIPSA0065");
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
		if (rqstMap.containsKey("from_sel_target_year")) param.put("from_sel_target_year", MapUtils.getIntValue(rqstMap, "from_sel_target_year"));
		if (rqstMap.containsKey("to_sel_target_year")) param.put("to_sel_target_year", MapUtils.getIntValue(rqstMap, "to_sel_target_year"));
		logger.debug("--------------getGridSttusList > searchCondition: "+rqstMap.get("searchCondition"));
		logger.debug("--------------getGridSttusList > from_sel_target_year: "+rqstMap.get("from_sel_target_year"));
		logger.debug("--------------getGridSttusList > to_sel_target_year: "+MapUtils.getIntValue(rqstMap, "to_sel_target_year"));
		
		int pageNo = MapUtils.getIntValue(rqstMap, "page");
		int rowSize = MapUtils.getIntValue(rqstMap, "rows");
		logger.debug("rowSize: "+rowSize);
		
		// 총 메뉴 글 개수
		int totalRowCnt = entprsDAO.findTotalIdxInfoRowCnt(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		
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
	
	/**
	 * 성장및회귀현황>업종별성장현황
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getGridSttusList2(Map<?, ?> rqstMap) throws Exception {	
		HashMap param = new HashMap();
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("from_sel_target_year")) param.put("from_sel_target_year", MapUtils.getIntValue(rqstMap, "from_sel_target_year"));
		if (rqstMap.containsKey("to_sel_target_year")) param.put("to_sel_target_year", MapUtils.getIntValue(rqstMap, "to_sel_target_year"));
		logger.debug("--------------getGridSttusList2 > searchCondition: "+rqstMap.get("searchCondition"));
		logger.debug("--------------getGridSttusList2 > from_sel_target_year: "+rqstMap.get("from_sel_target_year"));
		logger.debug("--------------getGridSttusList2 > to_sel_target_year: "+MapUtils.getIntValue(rqstMap, "to_sel_target_year"));
		
		int pageNo = MapUtils.getIntValue(rqstMap, "page");
		int rowSize = MapUtils.getIntValue(rqstMap, "rows");
		logger.debug("rowSize: "+rowSize);
		
		// 총 메뉴 글 개수
		int totalRowCnt = entprsDAO.findTotalIdxInfoRowCnt(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		
		param.put("pageNo", pageNo);
		param.put("rowSize", rowSize);
		
		// 성장및회귀현황>업종별성장현황
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.selectSttus2(param);
		
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
