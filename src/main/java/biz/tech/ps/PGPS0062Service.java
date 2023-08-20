package biz.tech.ps;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.response.ExcelVO;
import com.comm.response.IExcelVO;
import com.infra.util.DateFormatUtil;
import com.infra.util.ResponseUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.ps.PGPS0010Mapper;
import biz.tech.mapif.ps.PGPS0062Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


/**
 * 현황및통계
 * @author JGS
 *
 */
@Service("PGPS0062")
public class PGPS0062Service extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(PGPS0062Service.class);
	
	@Resource(name = "PGPS0062Mapper")
	private PGPS0062Mapper entprsDAO;
	
	@Resource(name = "PGPS0010Mapper")
	private PGPS0010Mapper pgps0010Dao;
	
	/**
	 * 성장및회귀현황>진입시기별분석>현황
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv = getGridSttusList(rqstMap);
		mv.setViewName("/admin/ps/BD_UIPSA0062");
		return mv;
	}
	
	/**
	 * 성장및회귀현황>진입시기별분석>성장현황
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView goIdxList2(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv = processGetGridSttusList2(rqstMap);
		mv.setViewName("/admin/ps/BD_UIPSA0062_2");		
		return mv;
	}
	
	/**
	 * 진입시기별분석 > 현황
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getGridSttusList(Map<?, ?> rqstMap) throws Exception {	
		HashMap param = new HashMap();
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		/*
		if (rqstMap.containsKey("sel_target_year")) param.put("sel_target_year", MapUtils.getIntValue(rqstMap, "sel_target_year"));
		logger.debug("--------------getGridSttusList > searchCondition: "+rqstMap.get("searchCondition"));
		logger.debug("--------------getGridSttusList > sel_target_year: "+MapUtils.getIntValue(rqstMap, "sel_target_year"));
		
		int sel_target_year=0;
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("sel_target_year")) sel_target_year = MapUtils.getIntValue(rqstMap, "sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(sel_target_year == 0) sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		
		param.put("sel_target_year", sel_target_year);*/
		
		String selTargetYear = MapUtils.getString(rqstMap, "sel_target_year");
		
		// 기준년도 목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		
		if(Validate.isEmpty(selTargetYear) && Validate.isNotEmpty(stdyyList)) {
			selTargetYear = MapUtils.getString(stdyyList.get(0), "stdyy");
		}
		
		param.put("sel_target_year", selTargetYear);
		
		// 진입시기별분석 > 현황 조회
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.selectSttus(param);		
		
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("targetYear", selTargetYear);
		mv.addObject("stdyyList", stdyyList);
		mv.addObject("entprsList", entprsList);
		
		//return ResponseUtil.responseGridJson(mv, gridJsonVo);
		return mv;
	}
	
	/**
	 * 진입시기별분석 > 성장현황 Main
	 * @param rqstMap request parameters
	 * @return responseJson
	 * @throws Exception
	 */
	public ModelAndView processGetGridSttusMain2(Map<?,?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		Map dataMap = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));		// 조회조건 : 기업군
		if (rqstMap.containsKey("sel_target_year")) param.put("sel_target_year", rqstMap.get("sel_target_year"));
		
		int sel_target_year=0;
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("sel_target_year")) sel_target_year = MapUtils.getIntValue(rqstMap, "sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(sel_target_year == 0) sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		
		param.put("sel_target_year", sel_target_year);
		
		String[] columnNames = null;
		String[] colModelList = null;
		
		// 컬럼명을 배열형태로
		columnNames = new String[11];
		colModelList = new String[11];
		
		String toYear = "" + sel_target_year;
		String fromYear4 = "" + (sel_target_year-4);
		String fromYear2 = "" + (sel_target_year-2);
		
		toYear = toYear.substring(2, 4);
		fromYear4 = fromYear4.substring(2, 4);
		fromYear2 = fromYear2.substring(2, 4);
		
		//컬럼명
		columnNames[0] = "구분";
		columnNames[1] = "'" + fromYear4 + "~ '" + toYear;
		columnNames[2] = "'" + fromYear2 + "~ '" + toYear;
		columnNames[3] = "'" + fromYear4 + "~ '" + toYear;
		columnNames[4] = "'" + fromYear2 + "~ '" + toYear;
		columnNames[5] = "'" + fromYear4 + "~ '" + toYear;
		columnNames[6] = "'" + fromYear2 + "~ '" + toYear;
		columnNames[7] = "'" + fromYear4 + "~ '" + toYear;
		columnNames[8] = "'" + fromYear2 + "~ '" + toYear;
		columnNames[9] = "'" + fromYear4 + "~ '" + toYear;
		columnNames[10] = "'" + fromYear2 + "~ '" + toYear;
		
		//모델명
		colModelList[0] = "CODE_NM";
		colModelList[1] = "SELNG_GROWTH5";
		colModelList[2] = "SELNG_GROWTH3";
		colModelList[3] = "XPORT_GROWTH5";
		colModelList[4] = "XPORT_GROWTH3";
		colModelList[5] = "ORDTM_GROWTH5";
		colModelList[6] = "ORDTM_GROWTH3";
		colModelList[7] = "RSRCH_GROWTH5";
		colModelList[8] = "RSRCH_GROWTH3";
		colModelList[9] = "BSN_GROWTH5";
		colModelList[10] = "BSN_GROWTH3";
		
		
		dataMap.put("colModelList", colModelList);
		dataMap.put("columnNames", columnNames);
		
		ModelAndView mv = new ModelAndView();
		return ResponseUtil.responseJson(mv, true, dataMap);
	}
	
	/**
	 * 진입시기별분석 > 성장현황 List
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView processGetGridSttusList2(Map<?, ?> rqstMap) throws Exception {	
		HashMap param = new HashMap();
		Map dataMap = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));		// 조회조건 : 기업군
		if (rqstMap.containsKey("sel_target_year")) param.put("sel_target_year", rqstMap.get("sel_target_year"));
		
		/*int sel_target_year=0;
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("sel_target_year")) sel_target_year = MapUtils.getIntValue(rqstMap, "sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(sel_target_year == 0) sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		*/		
		
		String selTargetYear = MapUtils.getString(rqstMap, "sel_target_year");
		
		// 기준년도 목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		
		if(Validate.isEmpty(selTargetYear) && Validate.isNotEmpty(stdyyList)) {
			selTargetYear = MapUtils.getString(stdyyList.get(0), "stdyy");
		}
				
		param.put("sel_target_year", selTargetYear);
		
		// 주요지표>추이 조회
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.selectGrowthSttus(param);
		
		logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&: "+entprsList.toString());		
		
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("targetYear", selTargetYear);
		mv.addObject("stdyyList", stdyyList);
		mv.addObject("entprsList", entprsList);
		
		return mv;
	}
	
	
	/**
	 * 진입시기별 성장현황 > 현황 엑셀다운로드
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView excelRsolver(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		Map dataMap = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));		// 조회조건 : 기업군
		if (rqstMap.containsKey("sel_target_year")) param.put("sel_target_year", rqstMap.get("sel_target_year"));
		
		int sel_target_year=0;
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("sel_target_year")) sel_target_year = MapUtils.getIntValue(rqstMap, "sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(sel_target_year == 0) sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		
		param.put("sel_target_year", sel_target_year);
		
logger.debug("-----------PGPS0062Service>excelRsolver>sel_target_year:"+sel_target_year);

		String[] columnNames = null;
		String[] colModelList = null;
		
		// 컬럼명을 배열형태로
		columnNames = new String[7];
		colModelList = new String[7];
		
		//컬럼명
		columnNames[0] = "구분";
		columnNames[1] = "평균매출액(억원)";
		columnNames[2] = "평균수출액(억불)";
		columnNames[3] = "평균근로자수(명)";
		columnNames[4] = "평균R&D투자비율(%)";
		columnNames[5] = "평균영업이익(억원)";
		columnNames[6] = "평균영업이익률(%)";
		
		//모델명
		colModelList[0] = "CODE_NM";
		colModelList[1] = "AVRG_SELNG_AM";
		colModelList[2] = "AVRG_XPORT_AM_DOLLAR";
		colModelList[3] = "AVRG_ORDTM_LABRR_CO";
		colModelList[4] = "AVRG_RSRCH_DEVLOP_RT";
		colModelList[5] = "AVRG_BSN_PROFIT";
		colModelList[6] = "AVRG_BSN_PROFIT_RT";
		
		dataMap.put("colModelList", colModelList);
		dataMap.put("columnNames", columnNames);
		
		// ------------------------------------ 데이터 부분 -----------------------------------
		
		// 진입시기별 성장현황 > 현황 조회
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.selectSttus(param);
		
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("_list", entprsList);

        mv.addObject("_headers", columnNames);
        mv.addObject("_items", colModelList);

        IExcelVO excel = new ExcelVO("진입시기별성장현황_현황"+DateFormatUtil.getTodayFull());
				
		return ResponseUtil.responseExcel(mv, excel);
	}
	
	/**
	 * 진입시기별 성장현황 > 성장현황 엑셀다운로드
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView excelRsolver2(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		Map dataMap = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));		// 조회조건 : 기업군
		if (rqstMap.containsKey("sel_target_year")) param.put("sel_target_year", rqstMap.get("sel_target_year"));
		
		int sel_target_year=0;
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("sel_target_year")) sel_target_year = MapUtils.getIntValue(rqstMap, "sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(sel_target_year == 0) sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		
		param.put("sel_target_year", sel_target_year);
		
logger.debug("-----------PGPS0062Service>excelRsolver2>sel_target_year:"+sel_target_year);

		String[] columnNames = null;			//header부분
		String[] colModelList = null;
		
		// 컬럼명을 배열형태로
		columnNames = new String[10];
		colModelList = new String[11];
		
		String toYear = "" + sel_target_year;
		String fromYear4 = "" + (sel_target_year-4);
		String fromYear2 = "" + (sel_target_year-2);
		
		toYear = toYear.substring(2, 4);
		fromYear4 = fromYear4.substring(2, 4);
		fromYear2 = fromYear2.substring(2, 4);
		
		//컬럼명
		//columnNames[0] = "구분";
		columnNames[0] = "매출액증가율";
		columnNames[1] = "";
		columnNames[2] = "수출액증가율";
		columnNames[3] = "";
		columnNames[4] = "고용증가율";
		columnNames[5] = "";
		columnNames[6] = "R&D증가율";
		columnNames[7] = "";
		columnNames[8] = "영업이익증가율";
		columnNames[9] = "";
		
		String[] subHeaders = {
				"'" + fromYear4 + "~ '" + toYear,
				"'" + fromYear2 + "~ '" + toYear,
				"'" + fromYear4 + "~ '" + toYear,
				"'" + fromYear2 + "~ '" + toYear,
				"'" + fromYear4 + "~ '" + toYear,
				"'" + fromYear2 + "~ '" + toYear,
				"'" + fromYear4 + "~ '" + toYear,
				"'" + fromYear2 + "~ '" + toYear,
				"'" + fromYear4 + "~ '" + toYear,
				"'" + fromYear2 + "~ '" + toYear
	        };
		
		//모델명
		colModelList[0] = "CODE_NM";
		colModelList[1] = "SELNG_GROWTH5";
		colModelList[2] = "SELNG_GROWTH3";
		colModelList[3] = "XPORT_GROWTH5";
		colModelList[4] = "XPORT_GROWTH3";
		colModelList[5] = "ORDTM_GROWTH5";
		colModelList[6] = "ORDTM_GROWTH3";
		colModelList[7] = "RSRCH_GROWTH5";
		colModelList[8] = "RSRCH_GROWTH3";
		colModelList[9] = "BSN_GROWTH5";
		colModelList[10] = "BSN_GROWTH3";
		
		dataMap.put("colModelList", colModelList);
		dataMap.put("columnNames", columnNames);
		
		// ------------------------------------ 데이터 부분 -----------------------------------
		
		// 진입시기별 성장현황 > 성장현황 조회
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.selectGrowthSttus(param);
		
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("_list", entprsList);

        mv.addObject("_headers", columnNames);
        mv.addObject("_subHeaders", subHeaders);
        mv.addObject("_items", colModelList);

        IExcelVO excel = new PGPS0062ExcelVO("진입시기별성장현황_성장현황_"+DateFormatUtil.getTodayFull());
        //IExcelVO excel = new ExcelVO("메뉴 리스트");
				
		return ResponseUtil.responseExcel(mv, excel);
	}
	
	
	/**
	 * 진입시기별분석 > 현황 출력 outputIdx
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView outputIdx(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0062_1");
		HashMap param = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("sel_target_year")) param.put("sel_target_year", rqstMap.get("sel_target_year"));
		
		String searchCondition = param.get("searchCondition").toString();
		String sel_target_year = param.get("sel_target_year").toString();
		logger.debug("---------------------------searchCondition: "+searchCondition);
		logger.debug("---------------------------sel_target_year: "+sel_target_year);
						
		mv.addObject("entprsList", entprsDAO.selectSttus(param));
		
		// 데이터 추가
		mv.addObject("searchCondition", searchCondition);
		mv.addObject("sel_target_year", sel_target_year);
		
		return mv;
	}
	
	/**
	 * 진입시기별분석 >  성장현황 outputIdx
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView outputIdx2(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("sel_target_year")) param.put("sel_target_year", rqstMap.get("sel_target_year"));
		
		String searchCondition = param.get("searchCondition").toString();
		String sel_target_year = param.get("sel_target_year").toString();
		logger.debug("---------------------------searchCondition: "+searchCondition);
		logger.debug("---------------------------sel_target_year: "+sel_target_year);
		
		mv = processGetGridSttusList2(rqstMap);
		
		// 데이터 추가
		mv.addObject("searchCondition", searchCondition);
		mv.addObject("sel_target_year", sel_target_year);
		
		mv.setViewName("/admin/ps/PD_UIPSA0062_2");
		
		return mv;
	}
}
