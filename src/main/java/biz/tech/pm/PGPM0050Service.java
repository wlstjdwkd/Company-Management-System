package biz.tech.pm;

import java.util.Calendar;
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
import com.infra.web.GridCodi;

import biz.tech.mapif.pm.PGPM0050Mapper;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 월별급여조회
 * 
 * 선택한 년도와 사원으로 해당 년도에 받은 급여를 월별로 조회
 * 
 * 조회
 * 
 */
@Service("PGPM0050")
public class PGPM0050Service {
	private static final Logger logger = LoggerFactory.getLogger(PGPM0050Service.class);
	private Locale locale = Locale.getDefault();

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	@Autowired
	PGPM0050Mapper pgpm0050Mapper;
	
	@Resource(name = "filesDAO")
	private FileDAO fileDao;

	/**
	 * 회원관리 회원 리스트 검색
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {		
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		Calendar today = Calendar.getInstance();
		
		//현재 년도를 받아 화면단에서 조회년도를 어디까지할 것인지 지정
		param.put("curr_year", String.valueOf(today.get(Calendar.YEAR)));
		
		mv.addObject("frontParam",param);
		mv.setViewName("/admin/pm/BD_UIPMA0050");

		return mv;
	}
	
	/**
	 * 월별급여내역 조회
	 * 
	 * 사원번호, 급여년월을 입력받아
	 * 해당하는 월별급여내역을 입력 
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView processPayMntTree(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map param = new HashMap<>();			// 쿼리매개변수
		param = (Map<?, ?>) rqstMap;
		
		String search_year = MapUtils.getString(rqstMap, "search_year");			// 조회 년
		String empNo = (String) MapUtils.getString(rqstMap, "ad_employee_code");	// 사원번호
		
		param.put("empNo", empNo);
		param.put("search_year", search_year);
				
		List<Map> payMntList = pgpm0050Mapper.selectMntPay(param);					// 특정 사원의 해당 년의 급여 금액을 조회, 항목금액 총액을 계산
		String jsData = GridCodi.MaptoTreeJson(payMntList, "PAY_ITM_CD", "UP_ITM_CD");
		
		//payMntList 내용 비었으면 에러 또는 알림창 뜨게 (추후)

		return ResponseUtil.responseText(mv, jsData);
	}
}