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

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.ps.PGPS0010Mapper;
import biz.tech.mapif.ps.PGPS0060Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


/**
 * 현황및통계
 * @author JGS
 *
 */
@Service("PGPS0060")
public class PGPS0060Service extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(PGPS0060Service.class);
	
	@Resource(name = "PGPS0060Mapper")
	private PGPS0060Mapper entprsDAO;
	
	@Resource(name = "PGPS0010Mapper")
	private PGPS0010Mapper pgps0010Dao; 
	
	/**
	 * 성장및회귀현황>일반기업성장현황>현황
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map rqstMap) throws Exception {
		HashMap param = new HashMap();
		ModelAndView mv = new ModelAndView("/admin/ps/BD_UIPSA0060");
		
		// 검색조건 년도목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		mv.addObject("stdyyList", stdyyList);
		
		// 초기검색조건 설정
		if (!rqstMap.containsKey("searchCondition")) rqstMap.put("searchCondition", "EA1");
		if (!rqstMap.containsKey("sel_target_year")) rqstMap.put("sel_target_year", stdyyList.get(0).get("stdyy"));
		
		// 입력 받은 값
		if (rqstMap.containsKey("searchCondition")) rqstMap.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("sel_target_year")) rqstMap.put("sel_target_year", rqstMap.get("sel_target_year"));
		
		// 일반기업 성장현황 > 현황 조회
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.selectGrowthSttus(rqstMap);
		
		logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&: "+entprsList.toString());
		
		mv.addObject("entprsList", entprsList);
		mv.addObject("entprsSize", entprsList.size());
		
		return mv;
	}
	
	/**
	 * 성장및회귀현황>일반기업성장현황>추이
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView goIdxList2(Map rqstMap) throws Exception {
		HashMap param = new HashMap();
		ModelAndView mv = new ModelAndView("/admin/ps/BD_UIPSA0060_2");
		
		int from_sel_target_year = 2014;
		int to_sel_target_year = 2014;
		// 검색조건 년도목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		mv.addObject("stdyyList", stdyyList);
		
		// 초기검색조건 설정
		if (!rqstMap.containsKey("searchCondition")) rqstMap.put("searchCondition", "EA1");
		if (!rqstMap.containsKey("from_sel_target_year")) rqstMap.put("from_sel_target_year", stdyyList.get(0).get("stdyy"));
		if (!rqstMap.containsKey("to_sel_target_year")) rqstMap.put("to_sel_target_year", stdyyList.get(0).get("stdyy"));
		
		// 입력 받은 값
		if (rqstMap.containsKey("searchCondition")) rqstMap.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("from_sel_target_year")) {
			from_sel_target_year = MapUtils.getIntValue(rqstMap, "from_sel_target_year");
			rqstMap.put("from_sel_target_year", from_sel_target_year);
		}
		if (rqstMap.containsKey("to_sel_target_year")) {
			to_sel_target_year = MapUtils.getIntValue(rqstMap, "to_sel_target_year");
			rqstMap.put("to_sel_target_year", to_sel_target_year);
		}
		
		mv.addObject("from_sel_target_year", from_sel_target_year);		
		mv.addObject("to_sel_target_year", to_sel_target_year);
		
		//기본으로 조회할 총 년도의 카운트를 계산
		int intNum = (to_sel_target_year-from_sel_target_year)+1;
		
		int year = from_sel_target_year;
		String[] selectYear= new String[intNum];
		for(int i=0; i<intNum; i++) {
			selectYear[i] = ""+year;
			year++;
		}
		
		List<Map> resultList = new ArrayList();
		int idx = 0;
		
		List<Map> dataList = null;

		for (int i=from_sel_target_year; i<=to_sel_target_year; i++) {
			// rqstMap.put("searchStdyy", searchStdyy);
			rqstMap.put("searchStdyy", i);
		
			// 매출액 and 근로자
			dataList = entprsDAO.selectGrowthSttus2(rqstMap);
			
			// 처음엔 사이트가 0이므로 최초 한번은 들어간다.
			if (resultList.size() == 0) {
					resultList.addAll(dataList);
			} else {
				idx++;
				for (int j=0; j<dataList.size(); j++) {
					Map dataInfo = dataList.get(j);
					Map resultInfo = resultList.get(j);
					resultInfo.put("CNT"+idx+"N", dataInfo.get("CNT0N")); 		// 새로 구해온 값을 기존의 데이터에 결합
				}
			}
			rqstMap.put("idx", idx);
		}
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchCondition"));
		
		mv.addObject("entprsList", resultList);
		
		return mv;
	}
	
	/**
	 * 일반기업 성장현황 > 현황 챠트
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getGridSttusChart(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0060_1");
		HashMap param = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("sel_target_year")) param.put("sel_target_year", rqstMap.get("sel_target_year"));
		
		int sel_target_year=0;
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("sel_target_year")) sel_target_year = MapUtils.getIntValue(rqstMap, "sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(sel_target_year == 0) sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		
		param.put("sel_target_year", sel_target_year);
		
		
		//주요지표>현황 조회
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.selectGrowthSttusChart(param);
		
		// 데이터 추가
		mv.addObject("sel_target_year", sel_target_year);
		mv.addObject("listCnt", entprsList.size());
		mv.addObject("entprsList", entprsList);
		
		return mv;
	}
	
	/**
	 * 일반기업 성장현황 > 추이 챠트
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getGridSttusChart2(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0060_2_1");
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
		
		
		
		
		String nm = "";		// 조회한 데이터 값을 담을 변수
		
		// for 이전에 뚜껑 선언
		String G01_data="["; 		String G02_data="[";		String G03_data="["; 		String G04_data="[";		String G05_data="["; 		String G06_data="[";
		String G07_data="["; 		String G08_data="[";		String G09_data="[";
		String ticks="[";		//ticks에 들어갈 X축명 정의용
		
		
		
		// 추이 
		List<Map> entprsList = new ArrayList<Map>();
		//entprsList = entprsDAO.selectGrowthSttus2(param);
		
		
		List<Map> resultList = new ArrayList();
		int idx = 0;
		int pos = 0;
		
		int searchStdyy = from_sel_target_year;
		logger.debug("-----------PGPS0060Service>getGridSttusChart2>searchStdyy : " + searchStdyy);
		
		param.put("idx", idx);
		
		Map resultInfo = null;
		
		int k = 0;
		int x = 0;
		int aaa = 0;
		int j=0;
		for (int i=from_sel_target_year; i<=to_sel_target_year; i++) {
			// rqstMap.put("searchStdyy", searchStdyy);
			param.put("searchStdyy", i);
		
			// 매출액 and 근로자
			// List<Map> entprsList = new ArrayList<Map>();
			entprsList = entprsDAO.selectGrowthSttus2(param);
			
				//for(int j=0; j <1; j++) {
					
					for(Map map : entprsList) {
						logger.debug("---------------------------aaa : "+aaa);
						
						nm = MapUtils.getString(map, "CNT0N");
						if(aaa == 0) {
							G01_data = G01_data + "[" + j + "," + nm + "],";
						}else if(aaa == 1) {
							G02_data = G02_data + "[" + j + "," + nm + "],";
						}else if(aaa == 2) {
							G03_data = G03_data + "[" + j + "," + nm + "],";
						}else if(aaa == 3) {
							G04_data = G04_data + "[" + j + "," + nm + "],";
						}else if(aaa == 4) {
							G05_data = G05_data + "[" + j + "," + nm + "],";
						}else if(aaa == 5) {
							G06_data = G06_data + "[" + j + "," + nm + "],";
						}else if(aaa == 6) {
							G07_data = G07_data + "[" + j + "," + nm + "],";
						}else if(aaa == 7) {
							G08_data = G08_data + "[" + j + "," + nm + "],";
						}else if(aaa == 8) {
							G09_data = G09_data + "[" + j + "," + nm + "],";
						}
						ticks = ticks + "[" + x + "," + selectYear[x] + "],";
						
						logger.debug("---------------------------G01_data: "+G01_data);
						logger.debug("---------------------------G02_data: "+G02_data);
						logger.debug("---------------------------G03_data: "+G03_data);
						logger.debug("---------------------------G04_data: "+G04_data);
						logger.debug("---------------------------G05_data: "+G05_data);
						logger.debug("---------------------------G06_data: "+G06_data);
						logger.debug("---------------------------G07_data: "+G07_data);
						logger.debug("---------------------------G08_data: "+G08_data);
						logger.debug("---------------------------G09_data: "+G09_data);
						logger.debug("---------------------------ticks: "+ticks);
						
						aaa++;
					}
					aaa = 0;	// 초기화
				//}
				logger.debug("---------------------------j : "+j);
				j++;
				x++;
				k++;
			
			/*			
			
			logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&: "+entprsList.toString());
		
			logger.debug("-----------PGPS0020Service>processGetGridSttusList2>entprsList.size() : " + entprsList.size());
			// 처음엔 사이트가 0이므로 최초 한번은 들어간다.
			if (resultList.size() == 0) {
				logger.debug("----------- resultList.size() == 0 ------------");
				for (int j=0; j<entprsList.size(); j++) {
					resultList.add(entprsList.get(j));
				}
			} else {
				logger.debug("----------- resultList.size() <> 0 ------------");
				
				for (int j=0; j<entprsList.size(); j++) {
					resultInfo = resultList.get(j);		// 기존 조회된 데이터 넣고
					Map dataInfo = entprsList.get(j);		// 새로 조회한 데이터
					resultInfo.put("CNT"+idx, dataInfo.get("CNT")); 		// 새로 구해온 값을 기존의 데이터에 결합
					logger.debug("-----------PGPS0020Service>processGetGridSttusList2>resultInfo : " + resultInfo.toString());
					logger.debug("-----------PGPS0020Service>processGetGridSttusList2>dataInfo : " + dataInfo.toString());
					logger.debug("-----------PGPS0020Service>processGetGridSttusList2>entprsList.size() : " + entprsList.size());
					logger.debug("-----------PGPS0020Service>processGetGridSttusList2>dataInfo.get(CNT) : "  + dataInfo.get("CNT"));
					logger.debug("-----------PGPS0020Service>processGetGridSttusList2>resultInfo.get(CNT) : "  + resultInfo.get("CNT"));
					logger.debug("----------- for문 " + j + "번째 수행");
					
				}
				idx++;
			}
			
			searchStdyy++;
			param.put("idx", idx);
			 */
		}
			
		
		
		/*
		 *  데이터 적재부분
		 *  각 구간에 해당하는 지표별 변수를 선언 후 조회조건에서 넘어온 년도들에 해당하는 entprsList의 결과값을 변수별로 저장하여 뒤에서 넘긴다.
		 *  ex) String aaa = "[[0,10],[1,20]]"; 
		 *       String bbb = "[[0,'2011'],[1,'2012']]"; 
		 *       의 형태가 되도록 만들기 위한 작업 -_-;
		 */
		
		//entprsList = entprsList.add(resultInfo);
		
		
		//for 종류 후 바닥
		G01_data=G01_data+"]";
		G02_data=G02_data+"]";
		G03_data=G03_data+"]";
		G04_data=G04_data+"]";
		G05_data=G05_data+"]";
		G06_data=G06_data+"]";
		G07_data=G07_data+"]";
		G08_data=G08_data+"]";
		G08_data=G09_data+"]";
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
		mv.addObject("G09_data", G09_data);
		mv.addObject("ticks", ticks);
			
		// 데이터 추가
		mv.addObject("from_sel_target_year", from_sel_target_year);
		mv.addObject("to_sel_target_year", to_sel_target_year);
		mv.addObject("listCnt", entprsList.size());
		mv.addObject("selectYear", selectYear);
		// mv.addObject("entprsList", entprsList);
		mv.addObject("entprsList", resultInfo);
		
		return mv;
		
	}
	
	
	/**
	 * outputIdx 출력
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView outputIdx(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0060_2");
		HashMap param = new HashMap();
		
		//입력 받은 값
		if (rqstMap.containsKey("searchCondition")) {
			param.put("searchCondition", rqstMap.get("searchCondition"));
		}
		if (rqstMap.containsKey("sel_target_year")) {
			param.put("sel_target_year", rqstMap.get("sel_target_year"));
		}
		
		String searchCondition = param.get("searchCondition").toString();
		String sel_target_year = param.get("sel_target_year").toString();
		
		logger.debug("---------------------------searchCondition: "+searchCondition);
		logger.debug("---------------------------sel_target_year: "+sel_target_year);
		
		// 일반기업 성장현황 > 현황 조회
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.selectGrowthSttus(rqstMap);
		
		// 데이터 추가
		mv.addObject("entprsList", entprsList);
		mv.addObject("searchCondition", searchCondition);
		mv.addObject("sel_target_year", sel_target_year);
		
		return mv;
	}
	
	/**
	 * outputIdx 출력
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView outputIdx2(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0060_2_2");
		HashMap param = new HashMap();
		
		int from_sel_target_year = 2014;
		int to_sel_target_year = 2014;
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("from_sel_target_year")) {
			param.put("from_sel_target_year", rqstMap.get("from_sel_target_year"));
			from_sel_target_year = MapUtils.getIntValue(rqstMap, "from_sel_target_year");
		}
		if (rqstMap.containsKey("to_sel_target_year")) {
			param.put("to_sel_target_year", rqstMap.get("to_sel_target_year"));
			to_sel_target_year = MapUtils.getIntValue(rqstMap, "to_sel_target_year");
		}
		String searchCondition = param.get("searchCondition").toString();

		mv.addObject("searchCondition", searchCondition);
		// 데이터 추가
		mv.addObject("from_sel_target_year", from_sel_target_year);
		mv.addObject("to_sel_target_year", to_sel_target_year);
		
		//기본으로 조회할 총 년도의 카운트를 계산
		int intNum = (to_sel_target_year-from_sel_target_year)+1;
		
		int year = from_sel_target_year;
		String[] selectYear= new String[intNum];
		for(int i=0; i<intNum; i++) {
			selectYear[i] = ""+year;
			year++;
		}
		
		List<Map> resultList = new ArrayList();
		int idx = 0;
		
		List<Map> dataList = null;

		for (int i=from_sel_target_year; i<=to_sel_target_year; i++) {
			// rqstMap.put("searchStdyy", searchStdyy);
			rqstMap.put("searchStdyy", i);
		
			// 매출액 and 근로자
			dataList = entprsDAO.selectGrowthSttus2(rqstMap);
			
			// 처음엔 사이트가 0이므로 최초 한번은 들어간다.
			if (resultList.size() == 0) {
					resultList.addAll(dataList);
			} else {
				idx++;
				for (int j=0; j<dataList.size(); j++) {
					Map dataInfo = dataList.get(j);
					Map resultInfo = resultList.get(j);
					resultInfo.put("CNT"+idx+"N", dataInfo.get("CNT0N")); 		// 새로 구해온 값을 기존의 데이터에 결합
				}
			}
			rqstMap.put("idx", idx);
		}
		mv.addObject("entprsList", resultList);
		
		return mv;
	}
	
	
	/** 현황-엑셀다운로드
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView excelRsolver(Map<?, ?> rqstMap) throws Exception {	
		HashMap param = new HashMap();
		Map dataMap = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));		// 조회조건 : 기업군
		
		int sel_target_year=0;
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("sel_target_year")) sel_target_year = MapUtils.getIntValue(rqstMap, "sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(sel_target_year == 0) sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		
		param.put("sel_target_year", sel_target_year);
		
		logger.debug("-----------PGPS0020Service>excelRsolver>sel_target_year:"+sel_target_year);
		
		String[] columnNames = null;
		String[] colModelList = null;
		
		// 컬럼명을 배열형태로
		columnNames = new String[7];
		colModelList = new String[7];
		
		//컬럼명
		columnNames[0] = "구분";
		columnNames[1] = "상호출자";
		columnNames[2] = "기업";
		columnNames[3] = "관계기업";
		columnNames[4] = "후보기업";
		columnNames[5] = "중소기업";
		columnNames[6] = "전체";
		
		//모델명
		colModelList[0] = "GUBUN";
		colModelList[1] = "B_ENT";
		colModelList[2] = "H_ENT";
		colModelList[3] = "R_ENT";
		colModelList[4] = "C_ENT";
		colModelList[5] = "S_ENT";
		colModelList[6] = "SUM_ENT";
			
		// ------------------------------------ 데이터 부분 ------------------------------------
		
		//일반기업 성장현황 > 현황 조회
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.selectGrowthSttus(param);
		logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&: "+entprsList.toString());
		
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("_list", entprsList);
		
        mv.addObject("_headers", columnNames);
        mv.addObject("_items", colModelList);

        IExcelVO excel = new ExcelVO("일반기업성장현황_현황_"+DateFormatUtil.getTodayFull());
				
		return ResponseUtil.responseExcel(mv, excel);
        
	}
	
	/** 추이-엑셀다운로드
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView excelRsolverGridSttusList2(Map<?, ?> rqstMap) throws Exception {	
		HashMap param = new HashMap();
		Map dataMap = new HashMap();
		
		param.put("induty_select", MapUtils.getString(rqstMap, "induty_select"));		// 업종 선택 구분
		param.put("sel_area", MapUtils.getString(rqstMap, "sel_area"));		// 지역 선택 구분(권역별 : A, 지역별 : C)
		if (rqstMap.containsKey("gSelect1")) param.put("gSelect1", rqstMap.get("gSelect1"));
		if (rqstMap.containsKey("gSelect2")) param.put("gSelect2", rqstMap.get("gSelect2"));
		if (rqstMap.containsKey("sel_index_type")) param.put("sel_index_type", rqstMap.get("sel_index_type"));		// 지표 선택 구분
		if (rqstMap.containsKey("ad_index_kind")) param.put("ad_index_kind", rqstMap.get("ad_index_kind"));		// 넘어오는 지표
		if("".equals(param.get("induty_select")) || param.get("induty_select") == "") param.put("induty_select", null);
		if("".equals(param.get("sel_area")) || param.get("sel_area") == "") param.put("sel_area", null);
		
		String gSelect1 = (String) rqstMap.get("gSelect1");		//업종이 그룹일때
		String gSelect2 = (String) rqstMap.get("gSelect2");		//지역이 그룹일때

		logger.debug("-----------PGPS0020Service>excelRsolverGridSttusList2>sel_index_type: "+rqstMap.get("sel_index_type"));
		logger.debug("-----------PGPS0020Service>excelRsolverGridSttusList2>ad_index_kind: "+rqstMap.get("ad_index_kind"));
		logger.debug("-----------PGPS0020Service>excelRsolverGridSttusList2>induty_select: "+param.get("induty_select"));
		logger.debug("-----------PGPS0020Service>excelRsolverGridSttusList2>sel_area: "+param.get("sel_area"));
		logger.debug("-----------PGPS0020Service>excelRsolverGridSttusList2>induty_select: "+param.get("induty_select"));
		logger.debug("-----------PGPS0020Service>excelRsolverGridSttusList2>sel_area: "+param.get("sel_area"));
		logger.debug("-----------PGPS0020Service>excelRsolverGridSttusList2>gSelect1: "+gSelect1);
		logger.debug("-----------PGPS0020Service>excelRsolverGridSttusList2>gSelect2: "+gSelect2);
		
		String[] columnNames = null;
		String[] colModelList = null;
		
		String index_type = null;
		String index_kind = null;
		String[] array_index_kind;
		
		if (rqstMap.containsKey("sel_index_type")) index_type = (String) rqstMap.get("sel_index_type");		// 지표구분
		if (rqstMap.containsKey("ad_index_kind")) index_kind = (String) rqstMap.get("ad_index_kind");		// 넘어오는 지표
		
		
		int from_sel_target_year=0;
		int to_sel_target_year=0;
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("from_sel_target_year")) from_sel_target_year = MapUtils.getIntValue(rqstMap, "from_sel_target_year");
		if (rqstMap.containsKey("to_sel_target_year")) to_sel_target_year = MapUtils.getIntValue(rqstMap, "to_sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(to_sel_target_year == 0) to_sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		if(from_sel_target_year == 0) from_sel_target_year = to_sel_target_year-3;				//to_sel_target_year == 0 -> 넘어오지 않으면 to_sel_target_year-2 세팅
		
		param.put("from_sel_target_year", from_sel_target_year);
		param.put("to_sel_target_year", to_sel_target_year);
		
		//기본으로 조회할 총 년도의 카운트를 계산
		int intNum = (to_sel_target_year-from_sel_target_year)+1;
		
		

		int year = from_sel_target_year;
		
		// 컬럼명을 배열형태로
		columnNames = new String[intNum+2];
		colModelList = new String[intNum+2];
		
		//컬럼명
		columnNames[0] = "업종";
		columnNames[1] = "구분";
		
		//모델명
		colModelList[0] = "COL1";
		colModelList[1] = "GUBUN1";
		int j=0;
		for(int i=2; i<intNum+2; i++) {
			columnNames[i] = ""+year+"년";
			colModelList[i] = "CNT"+ j + "N";
			logger.debug("-----------PGPS0020Service>excelRsolverGridSttusList2>colModelList["+i+"] : " + colModelList[i]);
			year++;
			j++;
		}	
		
		dataMap.put("colModelList", colModelList);
		dataMap.put("columnNames", columnNames);
			
		// ------------------------------------ 데이터 부분 ------------------------------------
		
		
		List<Map> resultList = new ArrayList();
		int idx = 0;
		int pos = 0;
		
		int searchStdyy = from_sel_target_year;
		logger.debug("-----------PGPS0020Service>excelRsolverGridSttusList2>searchStdyy : " + searchStdyy);
		
		param.put("idx", idx);
		
		Map resultInfo = null;
		
		
		
		for (int i=from_sel_target_year; i<=to_sel_target_year; i++) {
			// rqstMap.put("searchStdyy", searchStdyy);
			param.put("searchStdyy", i);
		
			// 매출액 and 근로자
			List<Map> entprsList = new ArrayList<Map>();
			entprsList = entprsDAO.selectGrowthSttus2(param);
			
			logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&: "+entprsList.toString());
		
			logger.debug("-----------PGPS0060Service>excelRsolverGridSttusList2>entprsList.size() : " + entprsList.size());
			// 처음엔 사이트가 0이므로 최초 한번은 들어간다.
			if (resultList.size() == 0) {
				logger.debug("----------- resultList.size() == 0 ------------");
				for ( j=0; j<entprsList.size(); j++) {
					resultList.add(entprsList.get(j));
				}
			} else {
				logger.debug("----------- resultList.size() <> 0 ------------");
				
				idx++;
				for ( j=0; j<entprsList.size(); j++) {
					resultInfo = resultList.get(j);		// 기존 조회된 데이터 넣고
					Map dataInfo = entprsList.get(j);		// 새로 조회한 데이터
					resultInfo.put("CNT"+idx+"N", dataInfo.get("CNT0N")); 		// 새로 구해온 값을 기존의 데이터에 결합
					logger.debug("-----------PGPS0060Service>excelRsolverGridSttusList2>idx : " + idx);
					logger.debug("-----------PGPS0060Service>excelRsolverGridSttusList2>resultInfo : " + resultInfo.toString());
					logger.debug("-----------PGPS0060Service>excelRsolverGridSttusList2>dataInfo : " + dataInfo.toString());
					logger.debug("-----------PGPS0060Service>excelRsolverGridSttusList2>entprsList.size() : " + entprsList.size());
					logger.debug("-----------PGPS0060Service>excelRsolverGridSttusList2>dataInfo.get(CNT"+j+"N) : "  + dataInfo.get("CNT0N"));
					logger.debug("-----------PGPS0060Service>excelRsolverGridSttusList2>resultInfo.get(CNT"+j+"N) : "  + resultInfo.get("CNT0N"));
					logger.debug("----------- for문 " + j + "번째 수행");
					
				}
			}
			searchStdyy++;
			param.put("idx", idx);
		}
		logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&: "+resultList.toString());
		
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("_list", resultList);
		
        mv.addObject("_headers", columnNames);
        mv.addObject("_items", colModelList);

        IExcelVO excel = new ExcelVO("일반기업성장현황_추이_"+DateFormatUtil.getTodayFull());
				
		return ResponseUtil.responseExcel(mv, excel);
        
	}
}
