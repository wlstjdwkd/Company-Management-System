package biz.tech.ps;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Calendar;

import javax.annotation.Resource;

import com.comm.menu.MenuService;
import com.comm.response.ExcelVO;
import com.comm.response.GridJsonVO;
import com.comm.response.IExcelVO;
import com.comm.user.UserService;
import com.infra.util.DateFormatUtil;
import com.infra.util.ResponseUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;
import biz.tech.mapif.pc.PGPC0030Mapper;
import biz.tech.mapif.ps.PGPS0010Mapper;
import biz.tech.mapif.ps.PGPS0070Mapper;
import biz.tech.mapif.um.PGUM0001Mapper;


/**
 * 현황및통계
 * @author CWJ
 *
 */
@Service("PGPS0070")
public class PGPS0070Service extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(PGPS0070Service.class);
	
	@Resource(name = "PGPS0070Mapper")
	private PGPS0070Mapper entprsDAO;
	
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "PGUM0001Mapper")
	PGUM0001Mapper PGUM0001DAO;

	@Resource(name = "PGPC0030Mapper")
	PGPC0030Mapper PGPC0030DAO;
	
	@Resource(name = "PGPS0010Mapper")
	private PGPS0010Mapper pgps0010Dao;

	@Autowired
	UserService userService;

	@Autowired
	MenuService menuService;
	
	/**
	 * 거래유형별현황 
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/ps/BD_UIPSA0070");
		
		HashMap param = new HashMap();
		
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		mv.addObject("stdyyList", stdyyList);
		
		String searchCondition = MapUtils.getString(rqstMap, "searchCondition");
		String targetYear = MapUtils.getString(rqstMap, "sel_target_year");
		
		if(Validate.isEmpty(targetYear)) {
			targetYear = MapUtils.getString(stdyyList.get(0), "stdyy");
		}
		
		param.put("searchCondition", searchCondition);
		param.put("sel_target_year", targetYear);
		
		mv.addObject("targetYear", targetYear);
		mv.addObject("resultList", entprsDAO.phaseList(param));
		return mv;
	}
	
	/**
	 * 기업위상 > 현황
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getGridSttusList(Map<?, ?> rqstMap) throws Exception {	
		HashMap param = new HashMap();
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("sel_target_year")) param.put("sel_target_year", MapUtils.getIntValue(rqstMap, "sel_target_year"));
		logger.debug("---------getGridSttusList>searchCondition: "+rqstMap.get("searchCondition"));
		logger.debug("---------getGridSttusList>sel_target_year: "+MapUtils.getIntValue(rqstMap, "sel_target_year"));
		
		// 기업위상 > 현황 조회
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.phaseList(param);
		
		logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&: "+entprsList.toString());
		
		GridJsonVO gridJsonVo = new GridJsonVO();
		gridJsonVo.setRows(entprsList);
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("rowNum", entprsList.size());
		return ResponseUtil.responseGridJson(mv, gridJsonVo);	
	}
	
	/**
	 * 기업위상 > 추이 Main
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView processGetGridSttusList2Main(Map<?, ?> rqstMap) throws Exception {	
		HashMap param = new HashMap();
		Map dataMap = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("from_sel_target_year")) param.put("from_sel_target_year", MapUtils.getIntValue(rqstMap, "from_sel_target_year"));
		if (rqstMap.containsKey("to_sel_target_year")) param.put("to_sel_target_year", MapUtils.getIntValue(rqstMap, "to_sel_target_year"));
		logger.debug("---------processGetGridSttusList2Main>searchCondition: "+rqstMap.get("searchCondition"));
		logger.debug("---------processGetGridSttusList2Main>from_sel_target_year: "+MapUtils.getIntValue(rqstMap, "from_sel_target_year"));
		logger.debug("---------processGetGridSttusList2Main>to_sel_target_year: "+MapUtils.getIntValue(rqstMap, "to_sel_target_year"));
		
		int from_sel_target_year=0;
		int to_sel_target_year=0;
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("from_sel_target_year")) from_sel_target_year = MapUtils.getIntValue(rqstMap, "from_sel_target_year");
		if (rqstMap.containsKey("to_sel_target_year")) to_sel_target_year = MapUtils.getIntValue(rqstMap, "to_sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		//if(to_sel_target_year == 0) to_sel_target_year = oCalendar.get(Calendar.YEAR);		//to_sel_target_year == 0 -> 넘어오지 않으면 2015년도로 세팅 
		if(from_sel_target_year == 0) from_sel_target_year = 2013;				//to_sel_target_year == 0 -> 넘어오지 않으면 to_sel_target_year-2 세팅
		
		//param.put("from_sel_target_year", from_sel_target_year);
		//param.put("to_sel_target_year", to_sel_target_year);

		//기본으로 조회할 총 년도의 카운트를 계산
		int intNum = (to_sel_target_year-from_sel_target_year)+1;
		
		String[] columnNames = null;
		String[] colModelList = null;
		
		int year = from_sel_target_year;		// 컬럼명에 사용할 변수
		
		// 컬럼명을 배열형태로
		columnNames = new String[intNum+2];
		colModelList = new String[intNum+2];
		
		//컬럼명
		columnNames[0] = "구분";
		columnNames[1] = "구분";
		
		//모델명
		colModelList[0] = "CODE_NM";
		colModelList[1] = "GUBUN";
		
		for(int i=2; i<intNum+2; i++) {
			columnNames[i] = ""+year;
			colModelList[i] = ""+year;
			year++;
		}
		
		dataMap.put("colModelList", colModelList);
		dataMap.put("columnNames", columnNames);
		
		ModelAndView mv = new ModelAndView();
		return ResponseUtil.responseJson(mv, true, dataMap);
		
	}
	
	/**
	 * 기업위상 > 추이
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView processGetGridSttusList2List(Map<?, ?> rqstMap) throws Exception {	
		HashMap param = new HashMap();
		Map dataMap = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("from_sel_target_year")) param.put("from_sel_target_year", MapUtils.getIntValue(rqstMap, "from_sel_target_year"));
		if (rqstMap.containsKey("to_sel_target_year")) param.put("to_sel_target_year", MapUtils.getIntValue(rqstMap, "to_sel_target_year"));
		logger.debug("---------processGetGridSttusList2List>searchCondition: "+rqstMap.get("searchCondition"));
		logger.debug("---------processGetGridSttusList2List>from_sel_target_year: "+MapUtils.getIntValue(rqstMap, "from_sel_target_year"));
		logger.debug("---------processGetGridSttusList2List>to_sel_target_year: "+MapUtils.getIntValue(rqstMap, "to_sel_target_year"));
		
		int from_sel_target_year=0;
		int to_sel_target_year=0;
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("from_sel_target_year")) from_sel_target_year = MapUtils.getIntValue(rqstMap, "from_sel_target_year");
		if (rqstMap.containsKey("to_sel_target_year")) to_sel_target_year = MapUtils.getIntValue(rqstMap, "to_sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		//if(from_sel_target_year == 0) from_sel_target_year = 2013;				//to_sel_target_year == 0 -> 넘어오지 않으면 to_sel_target_year-2 세팅
		//if(to_sel_target_year == 0) to_sel_target_year = oCalendar.get(Calendar.YEAR);		//to_sel_target_year == 0 -> 넘어오지 않으면 2015년도로 세팅 
		
		//param.put("from_sel_target_year", from_sel_target_year);
		//param.put("to_sel_target_year", to_sel_target_year);

		//기본으로 조회할 총 년도의 카운트를 계산
		int intNum = (to_sel_target_year-from_sel_target_year)+1;
		
		int year = from_sel_target_year;		// 컬럼명에 사용할 변수
		
		String[] selectYear= new String[intNum];
		for(int i=0; i<intNum; i++) {
			selectYear[i] = ""+year;
			year++;
		}
		
		param.put("selectYear", selectYear);	// PGPS0070Mapper.xml에서 사용하기 위해 넘기는 param
		
		// 주요지표>추이 조회
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.phaseList2(param);
		
		logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&: "+entprsList.toString());
		
		GridJsonVO gridJsonVo = new GridJsonVO();
		gridJsonVo.setRows(entprsList);
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("rowNum", entprsList.size());
		mv.addObject("entprsList", entprsList);
		return ResponseUtil.responseGridJson(mv, gridJsonVo);	
	}
	
	
	/**
	 * 기업위상 > 현황 엑셀다운로드
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView excelRsolver(Map<?, ?> rqstMap) throws Exception {	
		ModelAndView mv = new ModelAndView();
		
		HashMap param = new HashMap();
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("sel_target_year")) param.put("sel_target_year", rqstMap.get("sel_target_year"));
		
		// 기업위상 > 현황 조회
		List<Map> entprsList = new ArrayList<Map>();		
		entprsList = entprsDAO.phaseList(param);
		
		mv.addObject("_list", entprsList);

        String[] headers = {
            "구분",
            "구분",
            "중견",
            "중소",
            "대기업",
            "전체",
            "비고"
        };
        String[] items = {
            "CODE_NM",
            "GUBUN",
            "HPE_VALUE",
            "SMLPZ_VALUE",
            "LTRS_VALUE",
            "ALL_V",
            "CODE_DC",
        };

        mv.addObject("_headers", headers);
        mv.addObject("_items", items);

        IExcelVO excel = new ExcelVO("기업위상분석_현황_"+DateFormatUtil.getTodayFull());
				
		return ResponseUtil.responseExcel(mv, excel);
        
	}
	
	/**
	 * 기업위상 > 추이 엑셀다운로드
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView excelRsolver2(Map<?, ?> rqstMap) throws Exception {	
		HashMap param = new HashMap();
		Map dataMap = new HashMap();
		
		ModelAndView mv = new ModelAndView();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));		// 조회조건 : 기업군
		if (rqstMap.containsKey("from_sel_target_year")) param.put("from_sel_target_year", rqstMap.get("from_sel_target_year"));
		if (rqstMap.containsKey("to_sel_target_year")) param.put("to_sel_target_year", rqstMap.get("to_sel_target_year"));
		
		int from_sel_target_year=0;
		int to_sel_target_year=0;
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("from_sel_target_year")) from_sel_target_year = MapUtils.getIntValue(rqstMap, "from_sel_target_year");
		if (rqstMap.containsKey("to_sel_target_year")) to_sel_target_year = MapUtils.getIntValue(rqstMap, "to_sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(to_sel_target_year == 0) to_sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		if(from_sel_target_year == 0) from_sel_target_year = to_sel_target_year-2;				//to_sel_target_year == 0 -> 넘어오지 않으면 to_sel_target_year-2 세팅
		
		param.put("from_sel_target_year", from_sel_target_year);
		param.put("to_sel_target_year", to_sel_target_year);
		
		//기본으로 조회할 총 년도의 카운트를 계산
		int intNum = (to_sel_target_year-from_sel_target_year)+1;
		
		String[] columnNames = null;
		String[] colModelList = null;
		int year = from_sel_target_year;
		
		// 컬럼명을 배열형태로
		columnNames = new String[intNum+3];
		colModelList = new String[intNum+3];
		
		//컬럼명
		columnNames[0] = "구분";
		columnNames[1] = "구분";
		
		//모델명
		colModelList[0] = "CODE_NM";
		colModelList[1] = "GUBUN";
		
		// 컬럼명, 모델명 생성
		for(int i=2; i<intNum+2; i++) {
			columnNames[i] = ""+year;
			colModelList[i] = ""+year;
			year++;
		}	
		
		// 피봇형태의 구성을 위한 검색조건에서 넘어온 기간(년도)의 배열
		year = from_sel_target_year;	// 초기화
		String[] selectYear= new String[intNum];
		for(int i=0; i<intNum; i++) {
			selectYear[i] = ""+year;
			year++;
		}
		
		param.put("selectYear", selectYear);		// <-- 컬럼이 될 년도들
		
		// ------------------------------------ 데이터 부분 ------------------------------------
		// 기업위상 > 추이 조회
		List<Map> entprsList = new ArrayList<Map>();		
		entprsList = entprsDAO.phaseList2(param);
		
		mv.addObject("_list", entprsList);

        mv.addObject("_headers", columnNames);
        mv.addObject("_items", colModelList);

        IExcelVO excel = new ExcelVO("기업위상분석_추이_"+DateFormatUtil.getTodayFull());
				
		return ResponseUtil.responseExcel(mv, excel);
	}
	
	
	/**
	 * outputIdx 출력
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView outputIdx(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0070_2");
		HashMap param = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("sel_target_year")) param.put("sel_target_year", rqstMap.get("sel_target_year"));
		
		String searchCondition = param.get("searchCondition").toString();
		String sel_target_year = param.get("sel_target_year").toString();
		
		logger.debug("---------------------------searchCondition: "+searchCondition);
		
		// 기업정보 목록 조회
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.phaseList(param);
		
		// 데이터 추가
		mv.addObject("searchCondition", searchCondition);
		mv.addObject("sel_target_year", sel_target_year);		
		mv.addObject("resultList", entprsList);
		
		return mv;
	}
	
	/**
	 * outputIdx2 출력
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView outputIdx2(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0071_1");
		HashMap param = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("from_sel_target_year")) param.put("from_sel_target_year", MapUtils.getIntValue(rqstMap, "from_sel_target_year"));
		if (rqstMap.containsKey("to_sel_target_year")) param.put("to_sel_target_year", MapUtils.getIntValue(rqstMap, "to_sel_target_year"));
		
		String searchCondition = param.get("searchCondition").toString();
		
		int from_sel_target_year=0;
		int to_sel_target_year=0;
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("from_sel_target_year")) from_sel_target_year = MapUtils.getIntValue(rqstMap, "from_sel_target_year");
		if (rqstMap.containsKey("to_sel_target_year")) to_sel_target_year = MapUtils.getIntValue(rqstMap, "to_sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(to_sel_target_year == 0) to_sel_target_year = oCalendar.get(Calendar.YEAR);		//to_sel_target_year == 0 -> 넘어오지 않으면 2015년도로 세팅 
		if(from_sel_target_year == 0) from_sel_target_year = to_sel_target_year-2;				//to_sel_target_year == 0 -> 넘어오지 않으면 to_sel_target_year-2 세팅
		
		param.put("from_sel_target_year", from_sel_target_year);
		param.put("to_sel_target_year", to_sel_target_year);
		
		//기본으로 조회할 총 년도의 카운트를 계산
		int intNum = (to_sel_target_year-from_sel_target_year)+1;
		
		int year = from_sel_target_year;		// 컬럼명에 사용할 변수
		
		String[] selectYear= new String[intNum];
		for(int i=0; i<intNum; i++) {
			selectYear[i] = ""+year;
			year++;
		}
		
		param.put("selectYear", selectYear);	// PGPS0070Mapper.xml에서 사용하기 위해 넘기는 param
		
		// 기업정보 목록 조회
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.phaseList2(param);
		
		// 데이터 추가
		mv.addObject("searchCondition", searchCondition);
		mv.addObject("from_sel_target_year", from_sel_target_year);
		mv.addObject("to_sel_target_year", to_sel_target_year);
		mv.addObject("seachedYears", selectYear);
		mv.addObject("entprsList", entprsList);
		
		return mv;
	}
	

	/**
	 * 기업위상 > 현황 챠트
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getGridSttusChart(Map<?,?> rqstMap) throws Exception {
		// 전체 기업규모, 업종별 기업 쿼리에 사용할 파라미터
		HashMap param = new HashMap();
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0070_1");
		List<Map> mainPointList = new ArrayList();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("sel_target_year")) param.put("sel_target_year", rqstMap.get("sel_target_year"));
		
		String sel_target_year = param.get("sel_target_year").toString();
		
		logger.debug("---------------------------sel_target_year: "+sel_target_year);
		
		//기업위상>현황 BAR 챠트 조회
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.phaseListChart(param);
		
		// 데이터 추가
		mv.addObject("sel_target_year", sel_target_year);
		mv.addObject("entprsList", entprsList);
		
		return mv;
	}
	
	
	/**
	 * 기업위상 > 추이탭 조회
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView goIdxList2(Map<?,?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		
		// 데이터 추가
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/ps/BD_UIPSA0071");
		
		
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		mv.addObject("stdyyList", stdyyList);
		
		String searchCondition = MapUtils.getString(rqstMap, "searchCondition");
		String fromTargetYear = MapUtils.getString(rqstMap, "from_sel_target_year");
		//String fromTargetYear = "2002";
		String toTargetYear = MapUtils.getString(rqstMap, "to_sel_target_year");
		
		if(Validate.isEmpty(fromTargetYear)) {
			fromTargetYear = MapUtils.getString(stdyyList.get(stdyyList.size() - 1), "stdyy");
		}
		if(Validate.isEmpty(toTargetYear)) {
			toTargetYear = MapUtils.getString(stdyyList.get(0), "stdyy");
		}
		
		param.put("searchCondition", searchCondition);
		param.put("from_sel_target_year", fromTargetYear);
		param.put("to_sel_target_year", toTargetYear);				
		
		int fromYear = Integer.parseInt(fromTargetYear);		// 컬럼명에 사용할 변수
		int toYear = Integer.parseInt(toTargetYear);
		
		//기본으로 조회할 총 년도의 카운트를 계산
		int yearCnt = (toYear-fromYear)+1;
		
		String[] selectYear= new String[yearCnt];
		for(int i=0; i<yearCnt; i++) {
			selectYear[i] = ""+fromYear;
			fromYear++;
		}
		
		param.put("selectYear", selectYear);	// PGPS0070Mapper.xml에서 사용하기 위해 넘기는 param
		
		// 주요지표>추이 조회		
		mv.addObject("resultList", entprsDAO.phaseList2(param));
		
		mv.addObject("seachedYears", selectYear);
		mv.addObject("fromTargetYear", fromTargetYear);
		mv.addObject("toTargetYear", toTargetYear);
		
		return mv;
	}
}

