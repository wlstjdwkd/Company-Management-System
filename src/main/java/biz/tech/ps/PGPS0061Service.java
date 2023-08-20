package biz.tech.ps;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.response.ExcelVO;
import com.comm.response.GridJsonVO;
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
import biz.tech.mapif.ps.PGPS0061Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


/**
 * 현황및통계
 * @author JGS
 *
 */
@Service("PGPS0061")
public class PGPS0061Service extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(PGPS0061Service.class);
	
	@Resource(name = "PGPS0061Mapper")
	private PGPS0061Mapper entprsDAO;
	
	@Resource(name = "PGPS0010Mapper")
	private PGPS0010Mapper pgps0010Dao;
	
	/**
	 * 성장및회귀현황>일반기업성장현황>현황
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?,?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		ModelAndView mv = new ModelAndView("/admin/ps/BD_UIPSA0061");
		
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
		
		param.put("from_sel_target_year", fromTargetYear);
		param.put("to_sel_target_year", toTargetYear);
		
		//mv.addObject("entprsList1", entprsDAO.selectClFctr(param));
		//mv.addObject("entprsList2", entprsDAO.selectClFctr2(param));
		mv.addObject("fromTargetYear", fromTargetYear);
		mv.addObject("toTargetYear", toTargetYear);
		
		return mv;
	}
	
	/**
	 * 분류요인 조회
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getClFctr1(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/INC_UIPSA0061_1");
		HashMap param = new HashMap();
		
		boolean cndInduty = false; // 업종조건 적용여부
		boolean cndArea = false; // 지역조건 적용여부

		// 업종조건
		//cndInduty = true;
		//cndArea = false;
		
		
		int fromTargetYear = MapUtils.getIntValue(rqstMap, "from_sel_target_year");
		int toTargetYear = MapUtils.getIntValue(rqstMap, "to_sel_target_year");
		
		int yearCnt = (toTargetYear-fromTargetYear)+1;
		
		String[] selectYear= new String[yearCnt];
		for(int i=0; i<yearCnt; i++) {
			selectYear[i] = ""+fromTargetYear;
			fromTargetYear++;
		}
		
		param.put("selectYear", selectYear);	// PGPS0070Mapper.xml에서 사용하기 위해 넘기는 param
		
		param.put("from_sel_target_year", fromTargetYear);
		param.put("to_sel_target_year", toTargetYear);
		
		mv.addObject("seachedYears", selectYear);
		
		
		// 성장및회귀현황>업종별성장현황
		List<Map> resultList = new ArrayList<Map>();
		resultList = entprsDAO.selectClFctr(param);
		
		
		logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&: "+resultList.toString());
		
		
		if (resultList == null || resultList.size() <= 0) return null;

		// 제조/비제조 소계
		BigDecimal[] sumData = new BigDecimal[yearCnt];
		
		// 전산업
		BigDecimal[] totalData = new BigDecimal[yearCnt];
		
		String areaFt = null;
		String indutyFt = null;
		String stdAreaFt = null;
		String stdIndutyFt = null;
		Map resultInfo = null;
		Map prevInfo = null;
		Map sumMap = null;
		
		List<Map> rtnList = new ArrayList<Map>();	// 처리결과
		List<Map> dataList = new ArrayList<Map>();	// 데이터 임시
		List<Map> sumList = new ArrayList<Map>();	// 소계+데이터 임시

		for (int i=0; i<resultList.size(); i++) {
			resultInfo = (Map) resultList.get(i);

			// 제조/비제조별 합계
			if (cndInduty) {

				// 업종
				indutyFt = (String) resultInfo.get("INDUTY_CODE");
				
				if (stdIndutyFt == null) stdIndutyFt = indutyFt;
				
				if (!stdIndutyFt.equals(indutyFt)) {

					stdIndutyFt = indutyFt;
					
					prevInfo = resultList.get(i-1);
					
					// 제조/비제조 소계
					logger.debug("------------------제조/비제조 소계----------------------");
					sumMap = new HashMap();
					sumMap.put("gbnAs", prevInfo.get("GBN_AS"));
					sumMap.put("gbnIs", "S");
					
					for(int k=0; k<yearCnt; k++) {
						sumMap.put("data"+String.valueOf(k), sumData[k]);
					}
					
					sumMap.put("dtlclfcNm", prevInfo.get("INDUTY_GUBUN"));
					sumMap.put("indutyNm", prevInfo.get("INDUTY_GUBUN"));
					sumMap.put("AREA_NM", prevInfo.get("AREA_NM"));
					sumMap.put("ABRV", prevInfo.get("ABRV"));
					
					// 제조/비제조 검색이 아니면 제조/비제조 소계 처리
					if (!MapUtils.getString(rqstMap, "induty_select").equals("I")) {
						sumList.add(sumMap);
					}
					
					if (dataList.size() > 0) sumList.addAll(dataList);
					
					dataList = new ArrayList<Map>();
					
					
					for(int k=0; k<yearCnt; k++) {
						sumData[k] = new BigDecimal(0);
					}
				}


				if (cndArea && !stdAreaFt.equals(areaFt)) {
					stdAreaFt = areaFt;
					
					prevInfo = resultList.get(i-1);
					
					sumMap = new HashMap();
					sumMap.put("gbnAs", prevInfo.get("GBN_AS"));
					sumMap.put("gbnIs", "S");
					for(int k=0; k<yearCnt; k++) {
						sumMap.put("data"+String.valueOf(k), sumData[k]);
					}
					sumMap.put("indutySeNm", "전산업");
					sumMap.put("dtlclfcNm", "전산업");
					sumMap.put("indutyNm", "전산업");
					sumMap.put("AREA_NM", prevInfo.get("AREA_NM"));
					sumMap.put("ABRV", prevInfo.get("ABRV"));
					
					
					rtnList.add(sumMap);
					if (sumList.size() > 0) rtnList.addAll(sumList);
					
					sumList = new ArrayList<Map>();
					
					for(int k=0; k<yearCnt; k++) {
						totalData[k] = new BigDecimal(0);
					}
				}
				
				for(int k=0; k<yearCnt; k++) {
					// 제조/비제조 합계
					sumData[k] = sumData[k].add((BigDecimal) resultInfo.get("data"+String.valueOf(k)));
					
					// 지역별 전산업 합계
					totalData[k] = totalData[k].add((BigDecimal) resultInfo.get("data"+String.valueOf(k)));
				}
			}
			
			// 임시목록에 레코드 추가
			dataList.add(resultInfo);
		}
		
		// ### 마지막 레코드 처리 ###
		if (cndInduty) {
			
			if (!MapUtils.getString(rqstMap, "induty_select").equals("I")) {
				
				logger.debug("--------------------- 1. 제조/비제조 소계 : " + (String) rqstMap.get("induty_select"));
				
				// 1. 제조/비제조 소계
				sumMap = new HashMap();
				sumMap.put("gbnAs", prevInfo.get("GBN_AS"));
				sumMap.put("gbnIs", "S");
				
				for(int k=0; k<yearCnt; k++) {
					sumMap.put("data"+String.valueOf(k), sumData[k]);
				}
				sumMap.put("indutySeNm", prevInfo.get("INDUTY_GUBUN"));
				sumMap.put("dtlclfcNm", prevInfo.get("INDUTY_GUBUN"));
				sumMap.put("indutyNm", prevInfo.get("INDUTY_GUBUN"));
				sumMap.put("AREA_NM", prevInfo.get("AREA_NM"));
				sumMap.put("ABRV", prevInfo.get("ABRV"));
				
				logger.debug("--------------------- 3 indutySeNm : " + (String) resultInfo.get("INDUTY_GUBUN"));
				logger.debug("--------------------- 3 upperNm : " + (String) resultInfo.get("AREA_NM"));
				
				sumList.add(sumMap);
			}
			
			// 2. 전업종 합계
			sumMap = new HashMap();
			sumMap.put("gbnAs", prevInfo.get("GBN_AS"));
			sumMap.put("gbnIs", "S");
			
			for(int k=0; k<yearCnt; k++) {
				sumMap.put("data"+String.valueOf(k), sumData[k]);
			}
			sumMap.put("indutySeNm", "전산업");
			sumMap.put("dtlclfcNm", "전산업");
			sumMap.put("indutyNm", "전산업");
			sumMap.put("AREA_NM", prevInfo.get("AREA_NM"));
			sumMap.put("ABRV", prevInfo.get("ABRV"));
			
			logger.debug("--------------------- 4 upperNm : " + (String) resultInfo.get("AREA_NM"));
			
			rtnList.add(sumMap);
			if (sumList.size() > 0) rtnList.addAll(sumList);
		}
		
		rtnList.addAll(dataList);
		
		//return rtnList;
		
		
		mv.addObject("resultList", rtnList);
		
		//mv.addObject("resultList", rtnList);
		
		
		// 테이블 타이틀 조회
		//param = new HashMap();
		
		//param.put("codeGroupNo", "14");
		//param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrp"));
		//mv.addObject("tableTitle",codeService.findCodeInfo(param).get("codeNm"));
		
		// 테이블 타이틀 조회
		param = new HashMap();
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrp"));
		//mv.addObject("tableTitle",codeService.findCodeInfo(param).get("codeNm"));
		
		

		fromTargetYear = MapUtils.getIntValue(rqstMap, "from_sel_target_year");		// 다시 받아서 넣고
		
		String[] yearName= new String[yearCnt];
		for(int i=0; i<yearCnt; i++) {
			selectYear[i] = "data"+fromTargetYear;
			yearName[i] = ""+fromTargetYear;
			fromTargetYear++;
		}
		
		mv.addObject("seachedYears", selectYear);
		mv.addObject("yearName", yearName);
		
		return mv;
	}
	
	
	/**
	 * 분류요인-규모기준 조회
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getClFctr2(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/INC_UIPSA0061_2");
		HashMap param = new HashMap();
		
		int fromTargetYear = MapUtils.getIntValue(rqstMap, "from_sel_target_year");
		int toTargetYear = MapUtils.getIntValue(rqstMap, "to_sel_target_year");
		
		int yearCnt = (toTargetYear-fromTargetYear)+1;
		
		String[] selectYear= new String[yearCnt];
		for(int i=0; i<yearCnt; i++) {
			selectYear[i] = ""+fromTargetYear;
			fromTargetYear++;
		}
		
		param.put("selectYear", selectYear);	// PGPS0070Mapper.xml에서 사용하기 위해 넘기는 param
		
		param.put("from_sel_target_year", fromTargetYear);
		param.put("to_sel_target_year", toTargetYear);
		
		mv.addObject("resultList", entprsDAO.selectClFctr2(param));
		mv.addObject("seachedYears", selectYear);
		
		return mv;
	}
	
	/**
	 * 분류요인별분석 > 추이 - 분류요인 Main
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView processGetGridSttusMain(Map<?, ?> rqstMap) throws Exception {	
		HashMap param = new HashMap();
		Map dataMap = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("from_sel_target_year")) param.put("from_sel_target_year", MapUtils.getIntValue(rqstMap, "from_sel_target_year"));
		if (rqstMap.containsKey("to_sel_target_year")) param.put("to_sel_target_year", MapUtils.getIntValue(rqstMap, "to_sel_target_year"));
		
		logger.debug("--------------processGetGridSttusMain > searchCondition: "+rqstMap.get("searchCondition"));
		logger.debug("--------------processGetGridSttusMain > from_sel_target_year: "+rqstMap.get("from_sel_target_year"));
		logger.debug("--------------processGetGridSttusMain > to_sel_target_year: "+MapUtils.getIntValue(rqstMap, "to_sel_target_year"));
		
		int from_sel_target_year=0;
		int to_sel_target_year=0;
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("from_sel_target_year")) from_sel_target_year = MapUtils.getIntValue(rqstMap, "from_sel_target_year");
		if (rqstMap.containsKey("to_sel_target_year")) to_sel_target_year = MapUtils.getIntValue(rqstMap, "to_sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(to_sel_target_year == 0) to_sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		if(from_sel_target_year == 0) from_sel_target_year = 2003;				//to_sel_target_year == 0 -> 넘어오지 않으면 to_sel_target_year-2 세팅
		
		param.put("from_sel_target_year", from_sel_target_year);
		param.put("to_sel_target_year", to_sel_target_year);
		
		//기본으로 조회할 총 년도의 카운트를 계산
		int intNum = (to_sel_target_year-from_sel_target_year)+1;
		
		String[] columnNames = null;
		String[] colModelList = null;
		
		// 컬럼명을 배열형태로
		columnNames = new String[intNum+2];
		colModelList = new String[intNum+2];
		
		//컬럼명
		columnNames[0] = "기존기준";
		columnNames[1] = "구분";
		
		//모델명
		colModelList[0] = "GUBUN";
		colModelList[1] = "INDUTY_CODE";

		int year = from_sel_target_year;
		
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
	 * 분류요인별분석 > 추이 - 분류요인 List
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView processGetGridSttusList(Map<?, ?> rqstMap) throws Exception {	
		HashMap param = new HashMap();
		Map dataMap = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("from_sel_target_year")) param.put("from_sel_target_year", MapUtils.getIntValue(rqstMap, "from_sel_target_year"));
		if (rqstMap.containsKey("to_sel_target_year")) param.put("to_sel_target_year", MapUtils.getIntValue(rqstMap, "to_sel_target_year"));
		logger.debug("--------------processGetGridSttusList > searchCondition: "+rqstMap.get("searchCondition"));
		logger.debug("--------------processGetGridSttusList > from_sel_target_year: "+rqstMap.get("from_sel_target_year"));
		logger.debug("--------------processGetGridSttusList > to_sel_target_year: "+MapUtils.getIntValue(rqstMap, "to_sel_target_year"));
		
		int from_sel_target_year=0;
		int to_sel_target_year=0;
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("from_sel_target_year")) from_sel_target_year = MapUtils.getIntValue(rqstMap, "from_sel_target_year");
		if (rqstMap.containsKey("to_sel_target_year")) to_sel_target_year = MapUtils.getIntValue(rqstMap, "to_sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(to_sel_target_year == 0) to_sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		if(from_sel_target_year == 0) from_sel_target_year = 2003;				//to_sel_target_year == 0 -> 넘어오지 않으면 to_sel_target_year-3 세팅
		
		param.put("from_sel_target_year", from_sel_target_year);
		param.put("to_sel_target_year", to_sel_target_year);
		
		//기본으로 조회할 총 년도의 카운트를 계산
		int intNum = (to_sel_target_year-from_sel_target_year)+1;
		
		int year = from_sel_target_year;
		String[] selectYear= new String[intNum];
		for(int i=0; i<intNum; i++) {
			selectYear[i] = ""+year;
			year++;
		}
		
		param.put("selectYear", selectYear);
		
		// 성장 및 회귀현황 > 분류요인별분석 > 추이 조회
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.selectClFctr(param);
		
		ModelAndView mv = new ModelAndView();
		logger.debug("-----------PGPS0063Service>index selectGetGridSttusList 호출");
		mv.addObject("resultList", selectGetGridSttusList(rqstMap));
		
		logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&: "+entprsList.toString());
		
		GridJsonVO gridJsonVo = new GridJsonVO();
		gridJsonVo.setRows(entprsList);
		
		mv.addObject("entprsSize", entprsList.size());
		mv.addObject("entprsList", entprsList);
		
		return ResponseUtil.responseGridJson(mv, gridJsonVo);
	}
	
	/**
	 * 분류요인별분석 > 분류요인-규모기준 Main
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView processGetGridSttusMain2(Map<?, ?> rqstMap) throws Exception {	
		HashMap param = new HashMap();
		Map dataMap = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("from_sel_target_year")) param.put("from_sel_target_year", MapUtils.getIntValue(rqstMap, "from_sel_target_year"));
		if (rqstMap.containsKey("to_sel_target_year")) param.put("to_sel_target_year", MapUtils.getIntValue(rqstMap, "to_sel_target_year"));
		logger.debug("--------------processGetGridSttusMain2 > searchCondition: "+rqstMap.get("searchCondition"));
		logger.debug("--------------processGetGridSttusMain2 > from_sel_target_year: "+rqstMap.get("from_sel_target_year"));
		logger.debug("--------------processGetGridSttusMain2 > to_sel_target_year: "+rqstMap.get("to_sel_target_year"));
		
		int from_sel_target_year=0;
		int to_sel_target_year=0;
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("from_sel_target_year")) from_sel_target_year = MapUtils.getIntValue(rqstMap, "from_sel_target_year");
		if (rqstMap.containsKey("to_sel_target_year")) to_sel_target_year = MapUtils.getIntValue(rqstMap, "to_sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(to_sel_target_year == 0) to_sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		if(from_sel_target_year == 0) from_sel_target_year = 2003;				//to_sel_target_year == 0 -> 넘어오지 않으면 to_sel_target_year-2 세팅
		
		param.put("from_sel_target_year", from_sel_target_year);
		param.put("to_sel_target_year", to_sel_target_year);
		
		//기본으로 조회할 총 년도의 카운트를 계산
		int intNum = (to_sel_target_year-from_sel_target_year)+1;
		
		String[] columnNames = null;
		String[] colModelList = null;
		
		// 컬럼명을 배열형태로
				columnNames = new String[intNum+2];
				colModelList = new String[intNum+2];
				
				//컬럼명
				columnNames[0] = "구분";
				columnNames[1] = "구분";
				
				//모델명
				colModelList[0] = "GUBUN";
				colModelList[1] = "GUBUN2";

				int year = from_sel_target_year;
				
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
	 * 분류요인별분석 > 분류요인-규모기준 List
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView processGetGridSttusList2(Map<?, ?> rqstMap) throws Exception {	
		HashMap param = new HashMap();
		Map dataMap = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("from_sel_target_year")) param.put("from_sel_target_year", MapUtils.getIntValue(rqstMap, "from_sel_target_year"));
		if (rqstMap.containsKey("to_sel_target_year")) param.put("to_sel_target_year", MapUtils.getIntValue(rqstMap, "to_sel_target_year"));
		logger.debug("--------------processGetGridSttusList2 > searchCondition: "+rqstMap.get("searchCondition"));
		logger.debug("--------------processGetGridSttusList2 > from_sel_target_year: "+rqstMap.get("from_sel_target_year"));
		logger.debug("--------------processGetGridSttusList2 > to_sel_target_year: "+rqstMap.get("to_sel_target_year"));
		
		int from_sel_target_year=0;
		int to_sel_target_year=0;
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("from_sel_target_year")) from_sel_target_year = MapUtils.getIntValue(rqstMap, "from_sel_target_year");
		if (rqstMap.containsKey("to_sel_target_year")) to_sel_target_year = MapUtils.getIntValue(rqstMap, "to_sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(to_sel_target_year == 0) to_sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		if(from_sel_target_year == 0) from_sel_target_year = 2003;				//to_sel_target_year == 0 -> 넘어오지 않으면 to_sel_target_year-3 세팅
		
		param.put("from_sel_target_year", from_sel_target_year);
		param.put("to_sel_target_year", to_sel_target_year);
		
		//기본으로 조회할 총 년도의 카운트를 계산
		int intNum = (to_sel_target_year-from_sel_target_year)+1;
		
		int year = from_sel_target_year;
		String[] selectYear= new String[intNum];
		for(int i=0; i<intNum; i++) {
			selectYear[i] = ""+year;
			year++;
		}
		
		param.put("selectYear", selectYear);
		
		// 일반기업 성장현황 > 현황 조회
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.selectClFctr2(param);
		
		logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&: "+entprsList.toString());
		
		GridJsonVO gridJsonVo = new GridJsonVO();
		gridJsonVo.setRows(entprsList);
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("entprsSize2", entprsList.size());
		mv.addObject("entprsList2", entprsList);
		
		return ResponseUtil.responseGridJson(mv, gridJsonVo);
	}
	
	
	/**
	 * 분류요인별분석 > 추이 > 분류요인 챠트
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getGridSttusChart(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0061_1");
		HashMap param = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("from_sel_target_year")) param.put("from_sel_target_year", rqstMap.get("from_sel_target_year"));
		if (rqstMap.containsKey("to_sel_target_year")) param.put("to_sel_target_year", rqstMap.get("to_sel_target_year"));
		
		int from_sel_target_year=0;
		int to_sel_target_year=0;
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("from_sel_target_year")) from_sel_target_year = MapUtils.getIntValue(rqstMap, "from_sel_target_year");
		if (rqstMap.containsKey("to_sel_target_year")) to_sel_target_year = MapUtils.getIntValue(rqstMap, "to_sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(to_sel_target_year == 0) to_sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		if(from_sel_target_year == 0) from_sel_target_year = 2012;				//to_sel_target_year == 0 -> 넘어오지 않으면 to_sel_target_year-3 세팅
		
		param.put("from_sel_target_year", from_sel_target_year);
		param.put("to_sel_target_year", to_sel_target_year);
		
		//기본으로 조회할 총 년도의 카운트를 계산
		int intNum = (to_sel_target_year-from_sel_target_year)+1;
		
		int year = from_sel_target_year;
		String[] selectYear= new String[intNum];
		for(int i=0; i<intNum; i++) {
			selectYear[i] = ""+year;
			year++;
		}
		
		param.put("selectYear", selectYear);
		
		//분류요인별분석 > 추이 > 분류요인 조회
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.selectClFctr(param);
		
		/*
		 *  데이터 적재부분
		 *  각 구간에 해당하는 지표별 변수를 선언 후 조회조건에서 넘어온 년도들에 해당하는 entprsList의 결과값을 변수별로 저장하여 뒤에서 넘긴다.
		 *  ex) String aaa = "[[0,10],[1,20]]"; 
		 *       String bbb = "[[0,'2011'],[1,'2012']]"; 
		 *       의 형태가 되도록 만들기 위한 작업 -_-;
		 */
		String nm = "";		// 조회한 데이터 값을 담을 변수
		
		// for 이전에 뚜껑 선언
		String G01_data="["; 		String G02_data="[";		String G03_data="["; 		String G04_data="[";		String G05_data="["; 		String G06_data="[";
		String G07_data="["; 		String G08_data="[";
		String ticks="[";		//ticks에 들어갈 X축명 정의용
		
		int i=0;
		for(Map map : entprsList) {
			for(int j=0; j <selectYear.length; j++) {
				nm = MapUtils.getString(map, "data"+selectYear[j]);
				if(i == 0) {
					G01_data = G01_data + "[" + j + "," + nm + "],";
				}else if(i == 1) {
					G02_data = G02_data + "[" + j + "," + nm + "],";
				}else if(i == 2) {
					G03_data = G03_data + "[" + j + "," + nm + "],";
				}else if(i == 3) {
					G04_data = G04_data + "[" + j + "," + nm + "],";
				}else if(i == 4) {
					G05_data = G05_data + "[" + j + "," + nm + "],";
				}else if(i == 5) {
					G06_data = G06_data + "[" + j + "," + nm + "],";
				}else if(i == 6) {
					G07_data = G07_data + "[" + j + "," + nm + "],";
				}else if(i == 7) {
					G08_data = G08_data + "[" + j + "," + nm + "],";
				}
				ticks = ticks + "[" + j + "," + selectYear[j] + "],";
			}
			i++;
			logger.debug("---------------------------G01_data: "+G01_data);
			logger.debug("---------------------------G02_data: "+G02_data);
		}
		//for 종류 후 바닥
		G01_data=G01_data+"]";
		G02_data=G02_data+"]";
		G03_data=G03_data+"]";
		G04_data=G04_data+"]";
		G05_data=G05_data+"]";
		G06_data=G06_data+"]";
		G07_data=G07_data+"]";
		G08_data=G08_data+"]";
		ticks=ticks+"]";
		mv.addObject("ticks", ticks);
		
		/*
		 * mv로 넘김
		 */
		mv.addObject("G01_data", G01_data);
		mv.addObject("G02_data", G02_data);
		mv.addObject("G03_data", G03_data);
		mv.addObject("G04_data", G04_data);
		mv.addObject("G05_data", G05_data);
		mv.addObject("G06_data", G06_data);
		mv.addObject("G07_data", G07_data);
		mv.addObject("G08_data", G08_data);
		mv.addObject("ticks", ticks);
			
		// 데이터 추가
		mv.addObject("from_sel_target_year", from_sel_target_year);
		mv.addObject("to_sel_target_year", to_sel_target_year);
		mv.addObject("listCnt", entprsList.size());
		mv.addObject("selectYear", selectYear);
		mv.addObject("entprsList", entprsList);
		
		return mv;
	}
	
	/**
	 * 분류요인별분석 > 추이 > 분류요인-규모기준 챠트
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getGridSttusChart2(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0061_3");
		HashMap param = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("from_sel_target_year")) param.put("from_sel_target_year", rqstMap.get("from_sel_target_year"));
		if (rqstMap.containsKey("to_sel_target_year")) param.put("to_sel_target_year", rqstMap.get("to_sel_target_year"));
		
		int from_sel_target_year=0;
		int to_sel_target_year=0;
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("from_sel_target_year")) from_sel_target_year = MapUtils.getIntValue(rqstMap, "from_sel_target_year");
		if (rqstMap.containsKey("to_sel_target_year")) to_sel_target_year = MapUtils.getIntValue(rqstMap, "to_sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(to_sel_target_year == 0) to_sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		if(from_sel_target_year == 0) from_sel_target_year = 2012;				//to_sel_target_year == 0 -> 넘어오지 않으면 to_sel_target_year-3 세팅
		
		param.put("from_sel_target_year", from_sel_target_year);
		param.put("to_sel_target_year", to_sel_target_year);
		
		//기본으로 조회할 총 년도의 카운트를 계산
		int intNum = (to_sel_target_year-from_sel_target_year)+1;
		
		int year = from_sel_target_year;
		String[] selectYear= new String[intNum];
		for(int i=0; i<intNum; i++) {
			selectYear[i] = ""+year;
			year++;
		}
		
		param.put("selectYear", selectYear);
		
		//분류요인별분석 > 추이 > 분류요인 조회
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.selectClFctr2(param);
		
		/*
		 *  데이터 적재부분
		 *  각 구간에 해당하는 지표별 변수를 선언 후 조회조건에서 넘어온 년도들에 해당하는 entprsList의 결과값을 변수별로 저장하여 뒤에서 넘긴다.
		 *  ex) String aaa = "[[0,10],[1,20]]"; 
		 *       String bbb = "[[0,'2011'],[1,'2012']]"; 
		 *       의 형태가 되도록 만들기 위한 작업 -_-;
		 */
		String nm = "";		// 조회한 데이터 값을 담을 변수
		
		// for 이전에 뚜껑 선언
		String G01_data="["; 		String G02_data="[";		String G03_data="["; 		String G04_data="[";		String G05_data="["; 		String G06_data="[";
		String G07_data="["; 		String G08_data="[";
		String ticks="[";		//ticks에 들어갈 X축명 정의용
		
		int i=0;
		for(Map map : entprsList) {
			for(int j=0; j <selectYear.length; j++) {
				nm = MapUtils.getString(map, selectYear[j]);
				if(i == 0) {
					G01_data = G01_data + "[" + j + "," + nm + "],";
				}else if(i == 1) {
					G02_data = G02_data + "[" + j + "," + nm + "],";
				}else if(i == 2) {
					G03_data = G03_data + "[" + j + "," + nm + "],";
				}else if(i == 3) {
					G04_data = G04_data + "[" + j + "," + nm + "],";
				}else if(i == 4) {
					G05_data = G05_data + "[" + j + "," + nm + "],";
				}else if(i == 5) {
					G06_data = G06_data + "[" + j + "," + nm + "],";
				}else if(i == 6) {
					G07_data = G07_data + "[" + j + "," + nm + "],";
				}else if(i == 7) {
					G08_data = G08_data + "[" + j + "," + nm + "],";
				}
				ticks = ticks + "[" + j + "," + selectYear[j] + "],";
			}
			i++;
			logger.debug("---------------------------G01_data: "+G01_data);
			logger.debug("---------------------------G02_data: "+G02_data);
			logger.debug("---------------------------G03_data: "+G03_data);
			logger.debug("---------------------------G04_data: "+G04_data);
			logger.debug("---------------------------G05_data: "+G05_data);
			logger.debug("---------------------------ticks: "+ticks);
		}
		//for 종류 후 바닥
		G01_data=G01_data+"]";
		G02_data=G02_data+"]";
		G03_data=G03_data+"]";
		G04_data=G04_data+"]";
		G05_data=G05_data+"]";
		G06_data=G06_data+"]";
		G07_data=G07_data+"]";
		G08_data=G08_data+"]";
		ticks=ticks+"]";
		mv.addObject("ticks", ticks);
		
		/*
		 * mv로 넘김
		 */
		mv.addObject("G01_data", G01_data);
		mv.addObject("G02_data", G02_data);
		mv.addObject("G03_data", G03_data);
		mv.addObject("G04_data", G04_data);
		mv.addObject("G05_data", G05_data);
		mv.addObject("G06_data", G06_data);
		mv.addObject("G07_data", G07_data);
		mv.addObject("G08_data", G08_data);
		mv.addObject("ticks", ticks);
			
		// 데이터 추가
		mv.addObject("from_sel_target_year", from_sel_target_year);
		mv.addObject("to_sel_target_year", to_sel_target_year);
		mv.addObject("listCnt", entprsList.size());
		mv.addObject("selectYear", selectYear);
		mv.addObject("entprsList", entprsList);
		
		return mv;
	}
	
	
	/**
	 * 분류요인별분석 > 추이 > 분류요인 엑셀다운로드
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView processExcelRsolver(Map<?, ?> rqstMap) throws Exception {
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
		if(from_sel_target_year == 0) from_sel_target_year = 2003;				//to_sel_target_year == 0 -> 넘어오지 않으면 to_sel_target_year-2 세팅
		
		param.put("from_sel_target_year", from_sel_target_year);
		param.put("to_sel_target_year", to_sel_target_year);
		
logger.debug("-----------PGPS0061Service>processExcelRsolver>from_sel_target_year:"+from_sel_target_year);
logger.debug("-----------PGPS0061Service>processExcelRsolver>to_sel_target_year:"+to_sel_target_year);

		//기본으로 조회할 총 년도의 카운트를 계산
		int intNum = (to_sel_target_year-from_sel_target_year)+1;
		
		if (rqstMap.containsKey("gSelect1")) param.put("gSelect1", rqstMap.get("gSelect1"));
		if (rqstMap.containsKey("gSelect2")) param.put("gSelect2", rqstMap.get("gSelect2"));
		String gSelect1 = (String) rqstMap.get("gSelect1");		//업종이 그룹일때
		String gSelect2 = (String) rqstMap.get("gSelect2");		//지역이 그룹일때
		
		if(gSelect1 == null) gSelect1 = "G";
		if(gSelect2 == null) gSelect2 = "G";
		
		String[] columnNames = null;
		String[] colModelList = null;
		
		// 컬럼명을 배열형태로
		columnNames = new String[intNum+2];
		colModelList = new String[intNum+2];
		
		//컬럼명
		columnNames[0] = "기존기준";
		columnNames[1] = "구분";
		
		//모델명
		colModelList[0] = "GUBUN";
		colModelList[1] = "INDUTY_CODE";
		
		int year = from_sel_target_year;
		
		for(int i=2; i<intNum+2; i++) {
			columnNames[i] = ""+year;
			colModelList[i] = "data"+year;
			year++;
		}
		
		dataMap.put("colModelList", colModelList);
		dataMap.put("columnNames", columnNames);
		
		// ------------------------------------ 데이터 부분 -----------------------------------
		
		year = from_sel_target_year;	// 초기화
		
		String[] selectYear= new String[intNum];
		for(int i=0; i<intNum; i++) {
			selectYear[i] = ""+year;
			year++;
		}
		
		param.put("selectYear", selectYear);
		
		// 주요지표>추이 조회
		List<Map> resultList = new ArrayList<Map>();
		resultList = entprsDAO.selectClFctr(param);
		
		//ModelAndView mv = new ModelAndView();
		
		
		
		boolean cndInduty = false; // 업종조건 적용여부
		boolean cndArea = false; // 지역조건 적용여부

		// 업종조건
//		cndInduty = true;
//		cndArea = true;

		
		int fromTargetYear = MapUtils.getIntValue(rqstMap, "from_sel_target_year");
		int toTargetYear = MapUtils.getIntValue(rqstMap, "to_sel_target_year");
		
		int yearCnt = (toTargetYear-fromTargetYear)+1;
		
		if (resultList == null || resultList.size() <= 0) return null;

		// 제조/비제조 소계
		BigDecimal[] sumData = new BigDecimal[yearCnt];
		
		// 전산업
		BigDecimal[] totalData = new BigDecimal[yearCnt];
		
		String areaFt = null;
		String indutyFt = null;
		String stdAreaFt = null;
		String stdIndutyFt = null;
		Map resultInfo = null;
		Map prevInfo = null;
		Map sumMap = null;
		
		List<Map> rtnList = new ArrayList<Map>();	// 처리결과
		List<Map> dataList = new ArrayList<Map>();	// 데이터 임시
		List<Map> sumList = new ArrayList<Map>();	// 소계+데이터 임시

		for (int i=0; i<resultList.size(); i++) {
			resultInfo = (Map) resultList.get(i);

			// 제조/비제조별 합계
			if (cndInduty) {

				// 업종
				indutyFt = (String) resultInfo.get("INDUTY_CODE");
				
				if (stdIndutyFt == null) stdIndutyFt = indutyFt;
				
				if (!stdIndutyFt.equals(indutyFt)) {

					stdIndutyFt = indutyFt;
					
					prevInfo = resultList.get(i-1);
					
					// 제조/비제조 소계
					logger.debug("------------------제조/비제조 소계----------------------");
					sumMap = new HashMap();
					sumMap.put("gbnAs", prevInfo.get("GBN_AS"));
					sumMap.put("gbnIs", "S");
					
					for(int k=0; k<yearCnt; k++) {
						sumMap.put("data"+String.valueOf(k), sumData[k]);
						logger.debug("------------------String.valueOf("+k+") :  " + String.valueOf(k));
					}
					
					sumMap.put("dtlclfcNm", prevInfo.get("INDUTY_GUBUN"));
					sumMap.put("indutyNm", prevInfo.get("INDUTY_GUBUN"));
					sumMap.put("AREA_NM", prevInfo.get("AREA_NM"));
					sumMap.put("ABRV", prevInfo.get("ABRV"));
					
					// 제조/비제조 검색이 아니면 제조/비제조 소계 처리
					if (!MapUtils.getString(rqstMap, "induty_select").equals("I")) {
						sumList.add(sumMap);
					}
					
					if (dataList.size() > 0) sumList.addAll(dataList);
					
					dataList = new ArrayList<Map>();
					
					
					for(int k=0; k<yearCnt; k++) {
						sumData[k] = new BigDecimal(0);
					}
				}


				if (cndArea && !stdAreaFt.equals(areaFt)) {
					stdAreaFt = areaFt;
					
					prevInfo = resultList.get(i-1);
					
					sumMap = new HashMap();
					sumMap.put("gbnAs", prevInfo.get("GBN_AS"));
					sumMap.put("gbnIs", "S");
					for(int k=0; k<yearCnt; k++) {
						sumMap.put("data"+String.valueOf(k), sumData[k]);
						logger.debug("-----------------2-String.valueOf("+k+") :  " + String.valueOf(k));
					}
					sumMap.put("indutySeNm", "전산업");
					sumMap.put("dtlclfcNm", "전산업");
					sumMap.put("indutyNm", "전산업");
					sumMap.put("AREA_NM", prevInfo.get("AREA_NM"));
					sumMap.put("ABRV", prevInfo.get("ABRV"));
					
					
					rtnList.add(sumMap);
					if (sumList.size() > 0) rtnList.addAll(sumList);
					
					sumList = new ArrayList<Map>();
					
					for(int k=0; k<yearCnt; k++) {
						totalData[k] = new BigDecimal(0);
					}
				}
				
				for(int k=0; k<yearCnt; k++) {
					// 제조/비제조 합계
					sumData[k] = sumData[k].add((BigDecimal) resultInfo.get("data"+String.valueOf(k)));
					
					// 지역별 전산업 합계
					totalData[k] = totalData[k].add((BigDecimal) resultInfo.get("data"+String.valueOf(k)));
				}
			}
			
			// 임시목록에 레코드 추가
			dataList.add(resultInfo);
		}
		
		// ### 마지막 레코드 처리 ###
		if (cndInduty) {
			
			if (!MapUtils.getString(rqstMap, "induty_select").equals("I")) {
				
				logger.debug("--------------------- 1. 제조/비제조 소계 : " + (String) rqstMap.get("induty_select"));
				
				// 1. 제조/비제조 소계
				sumMap = new HashMap();
				sumMap.put("gbnAs", prevInfo.get("GBN_AS"));
				sumMap.put("gbnIs", "S");
				
				for(int k=0; k<yearCnt; k++) {
					sumMap.put("data"+String.valueOf(k), sumData[k]);
					logger.debug("-----------------3-String.valueOf("+k+") :  " + String.valueOf(k));
				}
				sumMap.put("indutySeNm", prevInfo.get("INDUTY_GUBUN"));
				sumMap.put("dtlclfcNm", prevInfo.get("INDUTY_GUBUN"));
				sumMap.put("indutyNm", prevInfo.get("INDUTY_GUBUN"));
				sumMap.put("AREA_NM", prevInfo.get("AREA_NM"));
				sumMap.put("ABRV", prevInfo.get("ABRV"));
				
				logger.debug("--------------------- 3 indutySeNm : " + (String) resultInfo.get("INDUTY_GUBUN"));
				logger.debug("--------------------- 3 upperNm : " + (String) resultInfo.get("AREA_NM"));
				
				sumList.add(sumMap);
			}
			
			// 2. 전업종 합계
			sumMap = new HashMap();
			sumMap.put("gbnAs", prevInfo.get("GBN_AS"));
			sumMap.put("gbnIs", "S");
			
			for(int k=0; k<yearCnt; k++) {
				sumMap.put("data"+String.valueOf(k), sumData[k]);
			}
			sumMap.put("indutySeNm", "전산업");
			sumMap.put("dtlclfcNm", "전산업");
			sumMap.put("indutyNm", "전산업");
			sumMap.put("AREA_NM", prevInfo.get("AREA_NM"));
			sumMap.put("ABRV", prevInfo.get("ABRV"));
			
			logger.debug("--------------------- 4 upperNm : " + (String) resultInfo.get("AREA_NM"));
			
			rtnList.add(sumMap);
			if (sumList.size() > 0) rtnList.addAll(sumList);
		}
		
		rtnList.addAll(dataList);
		
		//return rtnList;
		
		
		mv.addObject("resultList", rtnList);
		
		
		
		mv.addObject("_list", rtnList);

        mv.addObject("_headers", columnNames);
        mv.addObject("_items", colModelList);

        IExcelVO excel = new ExcelVO("분류요인별분석_분류요인_"+DateFormatUtil.getTodayFull());
				
		return ResponseUtil.responseExcel(mv, excel);
	}
	
	/**
	 * 분류요인별분석 > 추이 > 분류요인 엑셀다운로드
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView processExcelRsolver2(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		Map dataMap = new HashMap();
		
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
		if(from_sel_target_year == 0) from_sel_target_year = 2003;				//to_sel_target_year == 0 -> 넘어오지 않으면 to_sel_target_year-2 세팅
		
		param.put("from_sel_target_year", from_sel_target_year);
		param.put("to_sel_target_year", to_sel_target_year);
		
logger.debug("-----------PGPS0061Service>processExcelRsolver2>from_sel_target_year:"+from_sel_target_year);
logger.debug("-----------PGPS0061Service>processExcelRsolver2>to_sel_target_year:"+to_sel_target_year);

		//기본으로 조회할 총 년도의 카운트를 계산
		int intNum = (to_sel_target_year-from_sel_target_year)+1;
		
		if (rqstMap.containsKey("gSelect1")) param.put("gSelect1", rqstMap.get("gSelect1"));
		if (rqstMap.containsKey("gSelect2")) param.put("gSelect2", rqstMap.get("gSelect2"));
		String gSelect1 = (String) rqstMap.get("gSelect1");		//업종이 그룹일때
		String gSelect2 = (String) rqstMap.get("gSelect2");		//지역이 그룹일때
		
		if(gSelect1 == null) gSelect1 = "G";
		if(gSelect2 == null) gSelect2 = "G";
		
		String[] columnNames = null;
		String[] colModelList = null;
		
		// 컬럼명을 배열형태로
		columnNames = new String[intNum+2];
		colModelList = new String[intNum+2];
		
		//컬럼명
		columnNames[0] = "구분";
		columnNames[1] = "구분";
		
		//모델명
		colModelList[0] = "GUBUN";
		colModelList[1] = "GUBUN2";
		
		int year = from_sel_target_year;
		
		for(int i=2; i<intNum+2; i++) {
			columnNames[i] = ""+year;
			colModelList[i] = ""+year;
			year++;
		}
		
		dataMap.put("colModelList", colModelList);
		dataMap.put("columnNames", columnNames);
		
		// ------------------------------------ 데이터 부분 -----------------------------------
		
		year = from_sel_target_year;	// 초기화
		
		String[] selectYear= new String[intNum];
		for(int i=0; i<intNum; i++) {
			selectYear[i] = ""+year;
			year++;
		}
		
		param.put("selectYear", selectYear);
		
		// 주요지표>추이 조회
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.selectClFctr2(param);
		
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("_list", entprsList);

        mv.addObject("_headers", columnNames);
        mv.addObject("_items", colModelList);

        IExcelVO excel = new ExcelVO("분류요인별분석_분류요인_규모기준_"+DateFormatUtil.getTodayFull());
				
		return ResponseUtil.responseExcel(mv, excel);
	}
	
	
	/**
	 * 분류요인별분석 > 추이 > 분류요인 출력 outputIdx1
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView outputIdx1(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0061_2");
		HashMap param = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("from_sel_target_year")) param.put("from_sel_target_year", rqstMap.get("from_sel_target_year"));
		if (rqstMap.containsKey("to_sel_target_year")) param.put("to_sel_target_year", rqstMap.get("to_sel_target_year"));
		
		String searchCondition = param.get("searchCondition").toString();
		String from_sel_target_year = param.get("from_sel_target_year").toString();
		String to_sel_target_year = param.get("to_sel_target_year").toString();
		logger.debug("---------------------------searchCondition: "+searchCondition);
		logger.debug("---------------------------from_sel_target_year: "+from_sel_target_year);
		logger.debug("---------------------------to_sel_target_year: "+to_sel_target_year);
		
		// 데이터 추가
		mv.addObject("searchCondition", searchCondition);
		mv.addObject("from_sel_target_year", from_sel_target_year);
		mv.addObject("to_sel_target_year", to_sel_target_year);
		
		return mv;
	}
	
	/**
	 * 분류요인별분석 > 추이 > 분류요인-규모기준 출력 outputIdx2
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView outputIdx2(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0061_4");
		HashMap param = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("from_sel_target_year")) param.put("from_sel_target_year", rqstMap.get("from_sel_target_year"));
		if (rqstMap.containsKey("to_sel_target_year")) param.put("to_sel_target_year", rqstMap.get("to_sel_target_year"));
		
		String searchCondition = param.get("searchCondition").toString();
		String from_sel_target_year = param.get("from_sel_target_year").toString();
		String to_sel_target_year = param.get("to_sel_target_year").toString();
		logger.debug("---------------------------searchCondition: "+searchCondition);
		logger.debug("---------------------------from_sel_target_year: "+from_sel_target_year);
		logger.debug("---------------------------to_sel_target_year: "+to_sel_target_year);
		
		// 데이터 추가
		mv.addObject("searchCondition", searchCondition);
		mv.addObject("from_sel_target_year", from_sel_target_year);
		mv.addObject("to_sel_target_year", to_sel_target_year);
		
		return mv;
	}
	
	
	/**
	 * 성장및회귀현황>업종별성장현황 HTML
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView selectGetGridSttusList(Map rqstMap) throws Exception {	
		HashMap param = new HashMap();
		boolean cndInduty = false; // 업종조건 적용여부
		boolean cndArea = false; // 지역조건 적용여부

		// 업종조건
		if (!MapUtils.getString(rqstMap, "induty_select", "").equals("")) {
			cndInduty = true;
		}
		// 지역조건
		if (!MapUtils.getString(rqstMap, "sel_area", "").equals("")) {
			cndArea = true;
		}
		
		
		// 성장및회귀현황>업종별성장현황
		List<Map> resultList = new ArrayList<Map>();
		resultList = entprsDAO.selectClFctr(param);
		
		logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&: "+resultList.toString());
		
		/*GridJsonVO gridJsonVo = new GridJsonVO();
		gridJsonVo.setRows(entprsList);
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("entprsSize", entprsList.size());
		mv.addObject("entprsList", entprsList);
		*/		
		
		//ModelAndView mv = new ModelAndView("/admin/ps/INC_UIPSA0063");
		//mv.addObject("resultList", entprsList);
		
		
		
		
		
		if (resultList == null || resultList.size() <= 0) return null;

		// 제조/비제조 소계
		BigDecimal sumENTRPRS_CO = new BigDecimal(0);
		BigDecimal sumSELNG_AM = new BigDecimal(0);
		float sumSELNG_RT = 0;
		BigDecimal sumORDTM_LABRR_CO = new BigDecimal(0);
		float sumORDTM_RT = 0;
		BigDecimal sumXPORT_AM_WON = new BigDecimal(0);
		float sumXPORT_AM_WON_RT = 0;
		BigDecimal sumRSRCH_DEVLOP_CT = new BigDecimal(0);
		float sumRSRCH_RT = 0;
		
		// 전산업
		BigDecimal totalENTRPRS_CO = new BigDecimal(0);
		BigDecimal totalSELNG_AM = new BigDecimal(0);
		float totalSELNG_RT = 0;
		BigDecimal totalORDTM_LABRR_CO = new BigDecimal(0);
		float totalORDTM_RT = 0;
		BigDecimal totalXPORT_AM_WON = new BigDecimal(0);
		float totalXPORT_AM_WON_RT = 0;
		BigDecimal totalRSRCH_DEVLOP_CT = new BigDecimal(0);
		float totalRSRCH_RT = 0;
		
		String areaFt = null;
		String indutyFt = null;
		String stdAreaFt = null;
		String stdIndutyFt = null;
		Map resultInfo = null;
		Map prevInfo = null;
		Map sumMap = null;
		
		List<Map> rtnList = new ArrayList<Map>();	// 처리결과
		List<Map> dataList = new ArrayList<Map>();	// 데이터 임시
		List<Map> sumList = new ArrayList<Map>();	// 소계+데이터 임시

		for (int i=0; i<resultList.size(); i++) {
			resultInfo = (Map) resultList.get(i);

			// 제조/비제조별 합계
			if (cndInduty) {

				// 업종
				indutyFt = (String) resultInfo.get("INDUTY_GUBUN");
				// 지역
				if (rqstMap.get("sel_area").equals("A")) { // 권역별
					areaFt = (String) resultInfo.get("UPPER_CODE");
				} else { // 광역시별
					areaFt = (String) resultInfo.get("AREA_CODE");
				}
				
				if (stdIndutyFt == null) stdIndutyFt = indutyFt;
				if (stdAreaFt == null) stdAreaFt = areaFt;
				
				logger.debug("------stdIndutyFt : " + stdIndutyFt + " | indutyFt : " + indutyFt);
				logger.debug("------stdAreaFt : " + stdAreaFt + " | areaFt : " + areaFt);
				logger.debug("----------------------------------------");
				
				if (!stdIndutyFt.equals(indutyFt) || cndArea && !stdAreaFt.equals(areaFt)) {

					stdIndutyFt = indutyFt;
					
					prevInfo = resultList.get(i-1);
					
					// 제조/비제조 소계
					logger.debug("------------------제조/비제조 소계----------------------");
					sumMap = new HashMap();
					sumMap.put("gbnAs", prevInfo.get("GBN_AS"));
					sumMap.put("gbnIs", "S");
					sumMap.put("ENTRPRS_CO", sumENTRPRS_CO);
					sumMap.put("SELNG_AM", sumSELNG_AM);
					sumMap.put("SELNG_RT", sumSELNG_RT);
					sumMap.put("ORDTM_LABRR_CO", sumORDTM_LABRR_CO);
					sumMap.put("ORDTM_RT", sumORDTM_RT);
					sumMap.put("XPORT_AM_WON", sumXPORT_AM_WON);
					sumMap.put("XPORT_AM_WON_RT", sumXPORT_AM_WON_RT);
					sumMap.put("RSRCH_DEVLOP_CT", sumRSRCH_DEVLOP_CT);
					sumMap.put("RSRCH_RT", sumRSRCH_RT);
					sumMap.put("indutySeNm", prevInfo.get("INDUTY_GUBUN"));
					sumMap.put("dtlclfcNm", prevInfo.get("INDUTY_GUBUN"));
					sumMap.put("indutyNm", prevInfo.get("INDUTY_GUBUN"));
					sumMap.put("AREA_NM", prevInfo.get("AREA_NM"));
					sumMap.put("ABRV", prevInfo.get("ABRV"));
					
					logger.debug("--------------------- 1 indutySeNm : " + (String) prevInfo.get("INDUTY_GUBUN"));
					logger.debug("--------------------- 1 upperNm : " + (String) prevInfo.get("AREA_NM"));
					logger.debug("------------------제조/비제조 소계 : " + i + " ->" + totalENTRPRS_CO + "----------------------");
					logger.debug("------------------cndArea : " + cndArea);
					logger.debug("------------------stdAreaFt : " + stdAreaFt);
					logger.debug("------------------areaFt : " + areaFt);
					
					// 제조/비제조 검색이 아니면 제조/비제조 소계 처리
					if (!MapUtils.getString(rqstMap, "induty_select").equals("I")) {
						logger.debug("------------------제조/비제조 검색이 아니면 제조/비제조 소계 처리----------------------");
						sumList.add(sumMap);
					}
					if (dataList.size() > 0) sumList.addAll(dataList);
					
					dataList = new ArrayList<Map>();
					
					sumENTRPRS_CO = new BigDecimal(0);
					sumSELNG_AM = new BigDecimal(0);
					sumSELNG_RT = 0;
					sumORDTM_LABRR_CO = new BigDecimal(0);
					sumORDTM_RT = 0;
					sumXPORT_AM_WON = new BigDecimal(0);
					sumXPORT_AM_WON_RT = 0;
					sumRSRCH_DEVLOP_CT = new BigDecimal(0);
					sumRSRCH_RT = 0;
				}


				if (cndArea && !stdAreaFt.equals(areaFt)) {
					logger.debug("------------------!stdAreaFt.equals(areaFt) : " + i + " ->" + totalENTRPRS_CO + "----------------------");
					logger.debug("------------------cndArea : " + cndArea);
					logger.debug("------------------stdAreaFt : " + stdAreaFt);
					logger.debug("------------------areaFt : " + areaFt);
					stdAreaFt = areaFt;
					
					prevInfo = resultList.get(i-1);
					
					sumMap = new HashMap();
					sumMap.put("gbnAs", prevInfo.get("GBN_AS"));
					sumMap.put("gbnIs", "S");
					sumMap.put("ENTRPRS_CO", totalENTRPRS_CO);
					sumMap.put("SELNG_AM", totalSELNG_AM);
					sumMap.put("SELNG_RT", totalSELNG_RT);
					sumMap.put("ORDTM_LABRR_CO", totalORDTM_LABRR_CO);
					sumMap.put("ORDTM_RT", totalORDTM_RT);
					sumMap.put("XPORT_AM_WON", totalXPORT_AM_WON);
					sumMap.put("XPORT_AM_WON_RT", totalXPORT_AM_WON_RT);
					sumMap.put("RSRCH_DEVLOP_CT", totalRSRCH_DEVLOP_CT);
					sumMap.put("RSRCH_RT", totalRSRCH_RT);
					sumMap.put("indutySeNm", "전산업");
					sumMap.put("dtlclfcNm", "전산업");
					sumMap.put("indutyNm", "전산업");
					sumMap.put("AREA_NM", prevInfo.get("AREA_NM"));
					sumMap.put("ABRV", prevInfo.get("ABRV"));
					
					logger.debug("--------------------- 2 upperNm : " + (String) prevInfo.get("AREA_NM"));
					
					rtnList.add(sumMap);
					if (sumList.size() > 0) rtnList.addAll(sumList);
					
					sumList = new ArrayList<Map>();
					
					totalENTRPRS_CO = new BigDecimal(0);
					totalSELNG_AM = new BigDecimal(0);
					totalSELNG_RT = 0;
					totalORDTM_LABRR_CO = new BigDecimal(0);
					totalORDTM_RT = 0;
					totalXPORT_AM_WON = new BigDecimal(0);
					totalXPORT_AM_WON_RT = 0;
					totalRSRCH_DEVLOP_CT = new BigDecimal(0);
					totalRSRCH_RT = 0;
				}
				
				// 제조/비제조 합계
				sumENTRPRS_CO = sumENTRPRS_CO.add((BigDecimal) resultInfo.get("ENTRPRS_CO"));
				sumSELNG_AM = sumSELNG_AM.add((BigDecimal) resultInfo.get("SELNG_AM"));
				sumSELNG_RT = sumSELNG_RT + Float.parseFloat(resultInfo.get("SELNG_RT").toString());
				sumORDTM_LABRR_CO = sumORDTM_LABRR_CO.add((BigDecimal) resultInfo.get("ORDTM_LABRR_CO"));
				sumORDTM_RT = sumORDTM_RT + Float.parseFloat(resultInfo.get("ORDTM_RT").toString());
				sumXPORT_AM_WON = sumXPORT_AM_WON.add((BigDecimal) resultInfo.get("XPORT_AM_WON"));
				sumXPORT_AM_WON_RT = sumXPORT_AM_WON_RT + Float.parseFloat(resultInfo.get("XPORT_AM_WON_RT").toString());
				sumRSRCH_DEVLOP_CT = sumRSRCH_DEVLOP_CT.add((BigDecimal) resultInfo.get("RSRCH_DEVLOP_CT"));
				sumRSRCH_RT = sumRSRCH_RT + Float.parseFloat(resultInfo.get("RSRCH_RT").toString());
				
				// 지역별 전산업 합계
				totalENTRPRS_CO = totalENTRPRS_CO.add((BigDecimal) resultInfo.get("ENTRPRS_CO"));
				totalSELNG_AM = totalSELNG_AM.add((BigDecimal) resultInfo.get("SELNG_AM"));
				totalSELNG_RT = totalSELNG_RT + Float.parseFloat(resultInfo.get("SELNG_RT").toString());
				totalORDTM_LABRR_CO = totalORDTM_LABRR_CO.add((BigDecimal) resultInfo.get("ORDTM_LABRR_CO"));
				totalORDTM_RT = totalSELNG_RT + Float.parseFloat(resultInfo.get("ORDTM_RT").toString());
				totalXPORT_AM_WON = totalXPORT_AM_WON.add((BigDecimal) resultInfo.get("XPORT_AM_WON"));
				totalXPORT_AM_WON_RT = totalXPORT_AM_WON_RT + Float.parseFloat(resultInfo.get("XPORT_AM_WON_RT").toString());
				totalRSRCH_DEVLOP_CT = totalRSRCH_DEVLOP_CT.add((BigDecimal) resultInfo.get("RSRCH_DEVLOP_CT"));
				totalRSRCH_RT = totalRSRCH_RT + Float.parseFloat(resultInfo.get("RSRCH_RT").toString());
			}
			
			// 임시목록에 레코드 추가
			dataList.add(resultInfo);
		}
		
		// ### 마지막 레코드 처리 ###
		if (cndInduty) {
			
			if (!MapUtils.getString(rqstMap, "induty_select").equals("I")) {
				
				logger.debug("--------------------- 1. 제조/비제조 소계 : " + (String) rqstMap.get("induty_select"));
				
				// 1. 제조/비제조 소계
				sumMap = new HashMap();
				sumMap.put("gbnAs", prevInfo.get("GBN_AS"));
				sumMap.put("gbnIs", "S");
				sumMap.put("ENTRPRS_CO", sumENTRPRS_CO);
				sumMap.put("SELNG_AM", sumSELNG_AM);
				sumMap.put("SELNG_RT", sumSELNG_RT);
				sumMap.put("ORDTM_LABRR_CO", sumORDTM_LABRR_CO);
				sumMap.put("ORDTM_RT", sumORDTM_RT);
				sumMap.put("XPORT_AM_WON", sumXPORT_AM_WON);
				sumMap.put("XPORT_AM_WON_RT", sumXPORT_AM_WON_RT);
				sumMap.put("RSRCH_DEVLOP_CT", sumRSRCH_DEVLOP_CT);
				sumMap.put("RSRCH_RT", sumRSRCH_RT);
				sumMap.put("indutySeNm", prevInfo.get("INDUTY_GUBUN"));
				sumMap.put("dtlclfcNm", prevInfo.get("INDUTY_GUBUN"));
				sumMap.put("indutyNm", prevInfo.get("INDUTY_GUBUN"));
				sumMap.put("AREA_NM", prevInfo.get("AREA_NM"));
				sumMap.put("ABRV", prevInfo.get("ABRV"));
				
				logger.debug("--------------------- 3 indutySeNm : " + (String) resultInfo.get("INDUTY_GUBUN"));
				logger.debug("--------------------- 3 upperNm : " + (String) resultInfo.get("AREA_NM"));
				
				sumList.add(sumMap);
			}
			
			// 2. 전업종 합계
			sumMap = new HashMap();
			sumMap.put("gbnAs", prevInfo.get("GBN_AS"));
			sumMap.put("gbnIs", "S");
			sumMap.put("ENTRPRS_CO", totalENTRPRS_CO);
			sumMap.put("SELNG_AM", totalSELNG_AM);
			sumMap.put("SELNG_RT", totalSELNG_RT);
			sumMap.put("ORDTM_LABRR_CO", totalORDTM_LABRR_CO);
			sumMap.put("ORDTM_RT", totalORDTM_RT);
			sumMap.put("XPORT_AM_WON", totalXPORT_AM_WON);
			sumMap.put("XPORT_AM_WON_RT", totalXPORT_AM_WON_RT);
			sumMap.put("RSRCH_DEVLOP_CT", totalRSRCH_DEVLOP_CT);
			sumMap.put("RSRCH_RT", totalRSRCH_RT);
			sumMap.put("indutySeNm", "전산업");
			sumMap.put("dtlclfcNm", "전산업");
			sumMap.put("indutyNm", "전산업");
			sumMap.put("AREA_NM", prevInfo.get("AREA_NM"));
			sumMap.put("ABRV", prevInfo.get("ABRV"));
			
			logger.debug("--------------------- 4 upperNm : " + (String) resultInfo.get("AREA_NM"));
			
			rtnList.add(sumMap);
			if (sumList.size() > 0) rtnList.addAll(sumList);
		}
		
		rtnList.addAll(dataList);
		
		//return rtnList;
		
		ModelAndView mv = new ModelAndView("/admin/ps/INC_UIPSA0063");
		mv.addObject("resultList", rtnList);
		
		//mv.addObject("resultList", rtnList);
		
		
		// 테이블 타이틀 조회
		//param = new HashMap();
		
		//param.put("codeGroupNo", "14");
		//param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrp"));
		//mv.addObject("tableTitle",codeService.findCodeInfo(param).get("codeNm"));
		
		// 테이블 타이틀 조회
		param = new HashMap();
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrp"));
		//mv.addObject("tableTitle",codeService.findCodeInfo(param).get("codeNm"));
		
		return mv;
	}
	
}
