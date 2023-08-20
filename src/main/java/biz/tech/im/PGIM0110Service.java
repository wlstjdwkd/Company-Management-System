package biz.tech.im;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.im.PGIM0110Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 현황및통계
 * @author JGS
 *
 */
@Service("PGIM0110")
public class PGIM0110Service extends EgovAbstractServiceImpl{
	
	@Resource(name = "PGIM0110Mapper")
	private PGIM0110Mapper pgim0110Dao;
	
	/**
	 * 성장 및 회귀 현황 > 일반기업 성장 현황
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<? , ?> rqstMap) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		@SuppressWarnings({ "rawtypes", "unused" })
		HashMap param = new HashMap();
		
		// 일반기업 성장현황 > 현황 조회
		@SuppressWarnings("rawtypes")
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = pgim0110Dao.selectGrowthSttus(rqstMap);
		
		mv.addObject("entprsList", entprsList);
		mv.addObject("entprsSize", entprsList.size());
		
		mv.setViewName("/admin/im/BD_UIIMA0110");
		
		return mv;
	}
	
	/**
	 * 일반기업 성장 현황 > 현황 차트
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getGridSttusChart(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/im/PD_UIIMA0110");
		@SuppressWarnings("rawtypes")
		HashMap param = new HashMap();
		
		@SuppressWarnings("rawtypes")
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = pgim0110Dao.selectGrowthSttusChart(param);
		
		// 데이터 추가
		mv.addObject("listCnt", entprsList.size());
		mv.addObject("entprsList", entprsList);
		
		return mv;
	}
}