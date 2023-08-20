package biz.tech.ev;

import java.io.Console;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.infra.file.FileDAO;
import com.infra.util.ResponseUtil;
import com.infra.util.Validate;
import com.infra.web.GridCodi;

import biz.tech.mapif.ev.PGEV1110Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

@Service("PGEV1110")
public class PGEV1110Service extends EgovAbstractServiceImpl {
	private static final Logger logger = LoggerFactory.getLogger(PGEV1110Service.class);

	private Locale locale = Locale.getDefault();

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;

	@Resource(name = "filesDAO")
	private FileDAO fileDao;

	@Autowired
	PGEV1110Mapper PGEV1110Mapper;
	
	//초기 실행
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception{
		ModelAndView mv = new ModelAndView();
		Map param = new HashMap<>();
		param = (Map<?, ?>) rqstMap;
		
		String ad_select_year = MapUtils.getString(rqstMap, "ad_select_year");
		String ad_search_type = MapUtils.getString(rqstMap, "ad_search_type");
		String ad_search_word = MapUtils.getString(rqstMap, "ad_search_word");
		
		param.put("ad_select_year", ad_select_year);
		param.put("ad_search_type", ad_search_type);
		param.put("ad_search_word", ad_search_word);
		
		List<Map> dayoffList = null;
		
		if (Validate.isNotEmpty(ad_select_year)) {
			System.out.println("----------------------------------------------------------------------------------------------------------------------");
			dayoffList = PGEV1110Mapper.findDayoff(param);
		}
		
		mv.addObject("dayoffList", dayoffList);
		mv.setViewName("/admin/ev/BD_UIEVA1110");
		return mv;
	}
	
	//연차생성
	public ModelAndView insertDayoff(Map<?, ?> rqstMap) throws Exception{
		HashMap param = new HashMap<>();
		
		String emp_no = MapUtils.getString(rqstMap, "emp_no");
		int use_year = MapUtils.getInteger(rqstMap, "use_year");
		String inco_dt = MapUtils.getString(rqstMap, "inco_dt");
		
		
		//emp_no, total_cnt,  use_year, overuse
		param.put("emp_no", emp_no);
		param.put("use_year", use_year);
		param.put("inco_dt", inco_dt);
		
		PGEV1110Mapper.insertDayoff(param);
		ModelAndView mv = index(new HashMap());
		
		return mv;
	}
	
	//연차삭제
	public ModelAndView deleteDayoff(Map<?, ?> rqstMap) throws Exception{
		HashMap param = new HashMap();
		
		String emp_no = MapUtils.getString(rqstMap, "emp_no");
		String use_year = MapUtils.getString(rqstMap, "use_year");
		param.put("emp_no", emp_no);
		param.put("use_year", use_year);
		
		PGEV1110Mapper.deleteDayoff(param);
		
		ModelAndView mv = index(new HashMap());
		return mv;
	}
	
	
	
	
}