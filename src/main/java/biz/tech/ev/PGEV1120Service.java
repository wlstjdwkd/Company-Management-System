package biz.tech.ev;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.json.JsonObject;

import org.apache.commons.collections.MapUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.infra.file.FileDAO;
import com.infra.util.ResponseUtil;
import com.infra.util.Validate;

import biz.tech.mapif.ev.PGEV1120Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

@Service("PGEV1120")
public class PGEV1120Service extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGEV1120Service.class);

	private Locale locale = Locale.getDefault();

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;

	@Resource(name = "filesDAO")
	private FileDAO fileDao;

	@Autowired
	PGEV1120Mapper PGEV1120Mapper;
	
	/////////휴가 신청
	//index 조회
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception{
		ModelAndView mv = new ModelAndView();
		Map param = new HashMap<>();
		param = (Map<?, ?>) rqstMap;
				
		String ad_select_year = MapUtils.getString(rqstMap, "ad_select_year");
		String state = MapUtils.getString(rqstMap, "state");
		String cancel_state = MapUtils.getString(rqstMap, "cancel_state");
		String EMP_NO = MapUtils.getString(rqstMap, "EMP_NO");
		
		param.put("ad_select_year", ad_select_year);
		param.put("state", state);
		param.put("cancel_state", cancel_state);		
		param.put("EMP_NO", EMP_NO);		

		
		List<Map> dayoffInfo = null;
		dayoffInfo = PGEV1120Mapper.findDayoffInfo(param);
		
		List<Map> dayoffLogList = null;
		
		dayoffLogList = PGEV1120Mapper.findDayoffLog(param);
	
		mv.addObject("dayoffInfo", dayoffInfo);
		mv.addObject("dayoffLogList", dayoffLogList);
		mv.setViewName("/admin/ev/BD_UIEVA1120");
		
		return mv;
	}
	
	//날짜 계산(공휴일 제외 휴가 기간)
	public ModelAndView calDate(Map<?, ?> rqstMap) throws Exception{
		ModelAndView mv = new ModelAndView();
		Map param = new HashMap<>();
		param = (Map<?, ?>) rqstMap;
		
		String start_date = MapUtils.getString(rqstMap, "start_date");
		String end_date = MapUtils.getString(rqstMap, "end_date");
		
		List<Map> days = null;
		param.put("start_date",start_date);
		param.put("end_date", end_date);
		
		days = PGEV1120Mapper.calDate(param);

		JSONArray json_array = new JSONArray();
		json_array.add(days);
		
		
		return ResponseUtil.responseText(mv, json_array);
	}


	//삭제(취소)
	public ModelAndView requestDayoff(Map<?, ?> rqstMap) throws Exception{
		
		Map param = new HashMap<>();
		param = (Map<?, ?>) rqstMap;
		
		String pk = MapUtils.getString(rqstMap, "pk");
		param.put("pk", pk);
		
		PGEV1120Mapper.cancelDayoff(param);
		
		
		ModelAndView mv = index(new HashMap());
		return mv;
		
	}


	//저장&신청
	public ModelAndView saveDayoff(Map<?, ?> rqstMap) throws Exception{
		Map param = new HashMap<>();
		param = (Map<?, ?>) rqstMap;
		
		String pk = MapUtils.getString(rqstMap, "PK");
		String dayoff_type = MapUtils.getString(rqstMap, "dayoff_type");
		String dayoff_id = MapUtils.getString(rqstMap, "dayoff_id");
		String date_cnt = MapUtils.getString(rqstMap, "date_cnt");
		String start_date = MapUtils.getString(rqstMap, "start_date");
		String end_date = MapUtils.getString(rqstMap, "end_date");
		String content = MapUtils.getString(rqstMap, "content");
		
		param.put("PK",pk);
		param.put("dayoff_type", dayoff_type);
		param.put("dayoff_id", dayoff_id);
		param.put("date_cnt", date_cnt);
		param.put("start_date", start_date);
		param.put("end_date", end_date);
		param.put("content", content);
		
		PGEV1120Mapper.saveDayoff(param);
		
		ModelAndView mv = index(new HashMap());
		
		return mv;
	}
}



