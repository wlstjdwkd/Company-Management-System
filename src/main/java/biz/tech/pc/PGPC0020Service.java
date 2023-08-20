package biz.tech.pc;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.pc.PGPC0020Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;


@Service("PGPC0020")
public class PGPC0020Service extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGPC0020Service.class);
	
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name="PGPC0020Mapper")
	PGPC0020Mapper PGPC0020DAO;

	public ModelAndView index (Map<?,?> rqstMap) throws Exception {
		
		// 전체 기업규모, 업종별 기업 쿼리에 사용할 파라미터
		HashMap param = new HashMap();
		// 지역별 쿼리에 사용할 파라미터
		
		// 최근년도 구하기
		int latelyYear = PGPC0020DAO.findMaxStdyy();
		param.put("stdyyDo", latelyYear);
		
		ModelAndView mv = new ModelAndView();
		//PI1 = 기업수
		param.put("phaseIx", "PI1");
		mv.addObject("nEntrprs", PGPC0020DAO.findEntrprSize(param));
		//PI3 = 매출액
		param.put("phaseIx", "PI3");
		mv.addObject("sales", PGPC0020DAO.findEntrprSize(param));
		//PI4 = 수출액
		param.put("phaseIx", "PI4");
		mv.addObject("export", PGPC0020DAO.findEntrprSize(param));
		//PI5 = 고용
		param.put("phaseIx", "PI5");
		mv.addObject("employ", PGPC0020DAO.findEntrprSize(param));
		
		// 제조업
		param.put("C","CC");
		mv.addObject("mMlfscPoint",PGPC0020DAO.findMlfscPoint(param));
		
		// 비제조업
		param.put("C","DD");
		mv.addObject("nMlfscPoint", PGPC0020DAO.findMlfscPoint(param));
		
		mv.addObject("areaPoint", PGPC0020DAO.findCounPoint(param));
		mv.addObject("latelyYear", latelyYear);
		
		mv.setViewName("/www/pc/BD_UIPCU0020");
		return mv;
	}
}