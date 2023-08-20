package biz.tech.cs;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.cs.PGCS1008Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 우수사례
 * @author DST
 *
 */
@Service("PGCS1008")
public class PGCS1008Service extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(PGCS1008Service.class);
	
	@Resource(name = "PGCS1008Mapper")
	private PGCS1008Mapper pgcs1008Dao;
	
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		logger.debug("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
		
		ModelAndView mv = new ModelAndView();
		Map<String, Object> param = new HashMap<String, Object>();
		
		// 검색조건
		param.put("search_type", MapUtils.getString(rqstMap, "search_type"));
		param.put("search_word", MapUtils.getString(rqstMap, "search_word"));
		
		// 대량메일관리 리스트 카운트
		int totalRowCnt = pgcs1008Dao.selectGalleryBoardCount(param);

		// 대량메일관리 리스트 조회
		List<Map> resultList = new ArrayList<Map>();
		resultList = pgcs1008Dao.selectGalleryBoardInfo(param);
		
		for(int i = 0; i < resultList.size(); i++) {
			Map dateMap = resultList.get(i);
			
			String date = "" + dateMap.get("DATE_BOARD");
			date = date.substring(0, 4) + "-" + date.substring(5, 7) + "-" + date.substring(8, 10);
			
			dateMap.put("DATE_BOARD", date);
			resultList.set(i, dateMap);
		}
		
		mv.addObject("resultList", resultList);
		
		mv.setViewName("/www/cs/BD_UICSU1008");
		
		return mv;

	}
}
