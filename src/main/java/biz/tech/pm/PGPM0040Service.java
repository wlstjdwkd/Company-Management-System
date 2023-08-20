package biz.tech.pm;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.infra.file.FileDAO;
import com.infra.util.ResponseUtil;
import com.infra.web.GridCodi;

import biz.tech.mapif.pm.PGPM0030Mapper;
import biz.tech.mapif.pm.PGPM0040Mapper;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 급여계산
 * 
 * 선택한 기간에 재직 중인 사원들의 급여를 계산
 * 
 * 조회 / 계산(전체 / 개인) / 수정(개인)
 * 
 */
@Service("PGPM0040")
public class PGPM0040Service extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGPM0040Service.class);

	private Locale locale = Locale.getDefault();

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;

	@Autowired
	PGPM0030Mapper pgpm0030Mapper;
	
	@Autowired
	PGPM0040Mapper pgpm0040Mapper;
		
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
		HashMap param = new HashMap<>();
		Calendar today = Calendar.getInstance();	// 현재 시간
		
		// 현재 년도를 받아 화면단에서 조회년도를 어디까지할 것인지 지정
		param.put("curr_year", String.valueOf(today.get(Calendar.YEAR)));
		
		mv.addObject("frontParam",param);
		mv.setViewName("/admin/pm/BD_UIPMA0040");

		return mv;
	}
	
	/**
	 * 선택된 시기에 재직 중인 모든 사원의 급여 조회
	 * 검색버튼
	 * 	
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView searchPayMntList(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map param = new HashMap<>();
		param = (Map<?, ?>) rqstMap;
		
		String search_year = MapUtils.getString(rqstMap, "search_year");	// 조회 년
		String search_month = MapUtils.getString(rqstMap, "search_month");	// 조회 월

		param.put("payYm", search_year + search_month);						// 급여년월
		param.put("payDate", search_year + "-" + search_month + "-01");		// 조회할 시기를 날짜로 전달
		
		List<Map> empList = pgpm0040Mapper.findCurrEmpList(param);			// 조회시기 중 재직 중인 사원 목록
		param.put("empList", empList);
		
		List<Map> payMntList = pgpm0040Mapper.selectIndvEmpPayList(param);	// 재직 중인 사원의 급여 조회
		// JS에서 처리하기 위한 Json형식의 String
		String jsData = GridCodi.MaptoTreeJson(payMntList, "payItmCd", "upItmCd");	

		return ResponseUtil.responseText(mv, jsData);
	}
	
	/**
	 * 선택된 시기에 재직 중인 모든 사원 조회
	 * 	
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView findIndvEmpList(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map param = new HashMap<>();
		param = (Map<?, ?>) rqstMap;
		
		String search_year = MapUtils.getString(rqstMap, "search_year");	// 조회 년
		String search_month = MapUtils.getString(rqstMap, "search_month");	// 조회 월
		param.put("payDate", search_year + "-" + search_month + "-01");		// 조회할 시기를 날짜로 전달
		  
		// 재직 중인 사원의 정보(그리드에서 컬럼명, 사원명, 사원번호)전달
		List<Map> empList = pgpm0040Mapper.selectIndvEmpList(param);		
		String jsData = GridCodi.MaptoJson(empList);
		  
		return ResponseUtil.responseText(mv, jsData); 
	}	 
	
	/**
	 * 개인 월별 급여 내역 입력
	 * 
	 * 사원번호, 급여년월을 입력받아
	 * 해당하는 월별급여내역을 입력 
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView processIndvMonthList(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		List<Map> chkPayMntList = null;										// 사용여부 Y인 개인별 급여항목
		String empNo;														// 사원번호
		String payYear;														// 검색할 년도
		String payMonth;													// 검색할 월
		String processMode;													// 수행할 작업
		
		//사원번호, 급여 년/월
		empNo = MapUtils.getString(rqstMap, "ad_employee_code");			// 사원번호
		payYear = MapUtils.getString(rqstMap, "search_year");				// 조회 년
		payMonth = MapUtils.getString(rqstMap, "search_month");				// 조회 월
		processMode = MapUtils.getString(rqstMap, "process_mode");			// 생성 / 재계산
		
		// 해당 사원의 사용여부 Y인 급여항목만 받기
		param.put("empNo", empNo);
		param.put("payYm", payYear + payMonth);
		param.put("payDate", payYear + "-" + payMonth + "-01");				// 조회할 시기를 날짜로 전달
		List<Map> itemList = pgpm0040Mapper.selectUseEmpPayList(param);		// 사원의 재직여부 판단과 사용여부가 Y인 급여항목

		if("INSERT".equals(processMode.toUpperCase())) {
			//지정한 사원의 급여년월에 항목금액 등록
			for(Map item : itemList) {
				param.put("payItmCd", item.get("payItmCd"));
				
				// 저장 하려는 행이 없을 때만 삽입 실행
				chkPayMntList = pgpm0040Mapper.chkPayMnt(param);
				if(chkPayMntList.isEmpty()) {								// 급여항목이 테이블에 없을때
					param.put("itmAmt", item.get("itmBasAmt"));
					param.put("rmrk", item.get("rmrk"));
					
					pgpm0040Mapper.insertPayMnt(param);						// 등록
				}
			}
		}
		else if("UPDATE".equals(processMode.toUpperCase())) {
			////월급여 재계산(개인)
			//현재 시간을 받아 년도와 월이 일치할 때만 가능
			for(Map item : itemList) {
				param.put("payItmCd", MapUtils.getString(item, "payItmCd"));
				
				//저장 하려는 행이 있을 때만 삽입 실행
				chkPayMntList = pgpm0040Mapper.chkPayMnt(param);
				if(!(chkPayMntList.isEmpty())) {							// 급여항목이 테이블에 있을때
					param.put("itmAmt", MapUtils.getString(item, "itmBasAmt"));
					param.put("rmrk", MapUtils.getString(item, "rmrk"));
					
					pgpm0040Mapper.updatePayMnt(param);						// 수정
				}
			}
		}
		else {
			logger.debug("processing NOTHING");
		}

		return searchPayMntList(rqstMap);	//화면 refresh
	}
	
	/**
	 * 전체 월별 급여 내역 생성
	 * 
	 * 급여년월을 입력받아
	 * 해당하는 월별급여내역을 입력 
	 * '개인별월급여항목'에 값을 생성한 인원만 계산
	 * 퇴사자는 계산에서 제외
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView processAllMonthList(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		ModelAndView mv = new ModelAndView();
		List<Map> chkPayMntList = null;								// 사용여부 Y인 개인별 급여항목
		List<Map> employeeList = null;								// 직원 목록
		String empNo;												// 사원번호
		String payYear;												// 검색할 년도
		String payMonth;											// 검색할 월
		
		// 사원번호, 급여 년/월
		payYear = MapUtils.getString(rqstMap, "search_year");
		payMonth = MapUtils.getString(rqstMap, "search_month");
		
		// 전체 직원 목록
		employeeList = pgpm0030Mapper.findEmpList(new HashMap());
		
		for(Map employee : employeeList)  {
			String empOut = MapUtils.getString(employee, "outCoDt");
			 
			//해당 사원의 사용여부 Y인 급여항목만 받기
			empNo = MapUtils.getString(employee, "empNo");
			param.put("empNo", empNo);								// 사원번호
			param.put("payYm", payYear + payMonth);					// 조회년월
			param.put("payDate", payYear + "-" + payMonth + "-01");	// 조회시기
			// 사원의 재직여부 판단과 사용여부가 Y인 급여항목
			List<Map> itemList = pgpm0040Mapper.selectUseEmpPayList(param);	
			
			//지정한 사원의 급여년월에 항목금액 등록
			for(Map item : itemList) {
				param.put("payItmCd", MapUtils.getString(item, "payItmCd"));					
				
				//저장 하려는 행이 없을 때만 삽입 실행
				chkPayMntList = pgpm0040Mapper.chkPayMnt(param);
				if(chkPayMntList.isEmpty()) {						// 급여항목이 테이블에 없을때
					param.put("itmAmt", MapUtils.getString(item, "itmBasAmt"));
					param.put("rmrk", MapUtils.getString(item, "rmrk"));
					
					pgpm0040Mapper.insertPayMnt(param);				// 등록
				}
			}
		}
		
		mv = searchPayMntList(rqstMap);	//화면 refresh
		mv.addObject("resultMsg", messageSource.getMessage("success.common.insert", new String[] {"프로그램"}, Locale.getDefault()));

		return mv;
	}
}