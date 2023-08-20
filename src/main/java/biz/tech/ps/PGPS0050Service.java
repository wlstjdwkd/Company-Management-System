package biz.tech.ps;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.code.CodeService;
import com.comm.code.CodeVO;
import com.comm.response.ExcelVO;
import com.comm.response.IExcelVO;
import com.infra.util.DateFormatUtil;
import com.infra.util.ResponseUtil;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.ps.PGPS0010Mapper;
import biz.tech.mapif.ps.PGPS0020Mapper;
import biz.tech.mapif.ps.PGPS0030Mapper;
import biz.tech.mapif.ps.PGPS0050Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


/**
 * 가젤형기업현황 서비스 클래스
 * @author CWJ
 */
@Service("PGPS0050")
public class PGPS0050Service extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(PGPS0050Service.class);
	
	@Resource(name = "PGPS0050Mapper")
	private PGPS0050Mapper pgps0050Dao; // 가젤형별현황Mapper
	
	@Resource(name = "PGPS0030Mapper")
	private PGPS0030Mapper pgps0030Dao; // 거래유형별현황Mapper
	
	@Resource(name = "PGPS0020Mapper")
	private PGPS0020Mapper pgps0020Dao; // 현황및 통계 Mapper
	
	@Resource(name = "PGPS0010Mapper")
	private PGPS0010Mapper pgps0010Dao;
	
	@Autowired
	private CodeService codeService; // 공통코드서비스
	
	/**
	 * 업종별분포추이 화면
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/BD_UIPSA0050");
		
		// 탭구분
		rqstMap.put("ad_type", "1");
		
		HashMap param = new HashMap();
		
		// 검색조건 년도목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		mv.addObject("stdyyList", stdyyList);
		
		// 검색조건 업종테마목록 조회
		mv.addObject("themaList", pgps0030Dao.selectInduThemaList(param));
		
		// 검색조건 상세업종목록 조회
		mv.addObject("indutyList", pgps0030Dao.selectIndutyList(param));
		
		// 검색조건 지역코드(권역별)목록 조회
		mv.addObject("areaState", codeService.findCodesByGroupNo("57"));
		
		// 검색조건 지역코드(광역시)목록 조회
		mv.addObject("areaCity", pgps0020Dao.findCodesCity(param));
		
		// 초기검색조건 설정
		if (!rqstMap.containsKey("searchEntprsGrp")) rqstMap.put("searchEntprsGrp", "EA5");
		
		// 검색기간 조건 설정
		int startYr = 2012;
		int endYr = Integer.parseInt((String) stdyyList.get(0).get("stdyy"));

		if (rqstMap.containsKey("searchStdyySt")) {
			startYr = MapUtils.getIntValue(rqstMap, "searchStdyySt");
		} else {
			if ( (endYr - 10) > startYr) {
				startYr = Integer.parseInt((String) stdyyList.get(9).get("stdyy"));
			}
		}
		if (rqstMap.containsKey("searchStdyyEd")) endYr = MapUtils.getIntValue(rqstMap, "searchStdyyEd");
		
		List<Map> dataList = null;
		List<Map> resultList = new ArrayList();
		int idx = 0;
		
		// 검색기간 데이터 조회
		for (int i=startYr; i<=endYr; i++) {
			rqstMap.put("searchStdyy", String.valueOf(i));
			dataList = selectStaticsList(rqstMap);
			
			if (resultList.size() == 0) {
				resultList.addAll(dataList);
			} else {
				idx++;
				for (int j=0; j<dataList.size(); j++) {
					Map dataInfo = dataList.get(j);
					Map resultInfo = resultList.get(j);
					resultInfo.put("y"+idx+"Co", dataInfo.get("y0Co"));
				}
			}
		}

		mv.addObject("stdyySt", startYr);
		mv.addObject("stdyyEd", endYr);
		mv.addObject("resultList", resultList);
		
		return mv;
	}
	
	/**
	 * 기업규모별현황 화면
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectStaticsScle(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/BD_UIPSA0051");
		
		// 탭구분
		rqstMap.put("ad_type", "2");
		
		HashMap param = new HashMap();
		
		// 검색조건 년도목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		mv.addObject("stdyyList", stdyyList);
		
		// 검색조건 업종테마목록 조회
		mv.addObject("themaList", pgps0030Dao.selectInduThemaList(param));
		
		// 검색조건 상세업종목록 조회
		mv.addObject("indutyList", pgps0030Dao.selectIndutyList(param));
		
		// 검색조건 지역코드(권역별)목록 조회
		mv.addObject("areaState", codeService.findCodesByGroupNo("57"));
		
		// 검색조건 지역코드(광역시)목록 조회
		mv.addObject("areaCity", pgps0020Dao.findCodesCity(param));

		// 초기검색조건 설정
		if (!rqstMap.containsKey("searchEntprsGrp")) rqstMap.put("searchEntprsGrp", "EA5");
		if (!rqstMap.containsKey("searchStdyy")) rqstMap.put("searchStdyy", stdyyList.get(0).get("stdyy"));
		
		// 테이블 타이틀명 조회
		mv.addObject("scleNmList", codeService.findCodesByGroupNo("61"));

		// 매출액 and 근로자
		rqstMap.put("searchResnSe", "GR01");
		List<Map> gr01List = selectStaticsListScle(rqstMap);
		
		// 근로자
		rqstMap.put("searchResnSe", "GR02");
		List<Map> gr02List = selectStaticsListScle(rqstMap);
		
		// 매출액
		rqstMap.put("searchResnSe", "GR03");
		List<Map> gr03List = selectStaticsListScle(rqstMap);
		
		// 매출액 or 근로자
		rqstMap.put("searchResnSe", "GR04");
		List<Map> gr04List = selectStaticsListScle(rqstMap);
		
		List<Map> resultList = new ArrayList();
		
		for (int j=0; j<gr01List.size(); j++) {
			resultList.add(gr01List.get(j));
			resultList.add(gr02List.get(j));
			resultList.add(gr03List.get(j));
			resultList.add(gr04List.get(j));
		}
		
		mv.addObject("resultList", resultList);
		return mv;
	}
	
	/**
	 * 업력별분포 화면
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectStaticsHist(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/BD_UIPSA0052");
		
		// 탭구분
		rqstMap.put("ad_type", "3");
		
		HashMap param = new HashMap();
		
		// 검색조건 년도목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		mv.addObject("stdyyList", stdyyList);
		
		// 검색조건 업종테마목록 조회
		mv.addObject("themaList", pgps0030Dao.selectInduThemaList(param));
		
		// 검색조건 상세업종목록 조회
		mv.addObject("indutyList", pgps0030Dao.selectIndutyList(param));
		
		// 검색조건 지역코드(권역별)목록 조회
		mv.addObject("areaState", codeService.findCodesByGroupNo("57"));
		
		// 검색조건 지역코드(광역시)목록 조회
		mv.addObject("areaCity", pgps0020Dao.findCodesCity(param));

		// 초기검색조건 설정
		if (!rqstMap.containsKey("searchEntprsGrp")) rqstMap.put("searchEntprsGrp", "EA5");
		
		// 검색기간 조건 설정
		int startYr = 2012;
		int endYr = Integer.parseInt((String) stdyyList.get(0).get("stdyy"));

		if (rqstMap.containsKey("searchStdyySt")) {
			startYr = MapUtils.getIntValue(rqstMap, "searchStdyySt");
		} else {
			if ( (endYr - 10) > startYr) {
				startYr = Integer.parseInt((String) stdyyList.get(9).get("stdyy"));
			}
		}
		if (rqstMap.containsKey("searchStdyyEd")) endYr = MapUtils.getIntValue(rqstMap, "searchStdyyEd");


		List<Map> resultList = new ArrayList();
		int idx = 0;
		int pos = 0;
		
		for (int i=startYr; i<=endYr; i++) {
			rqstMap.put("searchStdyy", String.valueOf(i));
			
			// 매출액 and 근로자
			rqstMap.put("searchResnSe", "GR01");
			List<Map> gr01List = selectStaticsLisHistIndx(rqstMap);
			
			// 근로자
			rqstMap.put("searchResnSe", "GR02");
			List<Map> gr02List = selectStaticsLisHistIndx(rqstMap);
			
			// 매출액
			rqstMap.put("searchResnSe", "GR03");
			List<Map> gr03List =  selectStaticsLisHistIndx(rqstMap);
			
			// 매출액 or 근로자
			rqstMap.put("searchResnSe", "GR04");
			List<Map> gr04List = selectStaticsLisHistIndx(rqstMap);

			
			if (resultList.size() == 0) {
				for (int j=0; j<gr01List.size(); j++) {
					resultList.add(gr01List.get(j));
					resultList.add(gr02List.get(j));
					resultList.add(gr03List.get(j));
					resultList.add(gr04List.get(j));
				}
			} else {
				idx++;
				for (int j=0; j<gr01List.size(); j++) {
					pos = j * 4;
					Map resultInfo = resultList.get(pos);
					Map dataInfo = gr01List.get(j);
					resultInfo.put("y"+idx+"EntrHistU7", dataInfo.get("y0EntrHistU7"));
					resultInfo.put("y"+idx+"EntrHistR7", dataInfo.get("y0EntrHistR7"));
					resultInfo.put("y"+idx+"SumEntrHist", dataInfo.get("y0SumEntrHist"));
					
					resultInfo = resultList.get(pos+1);
					dataInfo = gr02List.get(j);
					resultInfo.put("y"+idx+"EntrHistU7", dataInfo.get("y0EntrHistU7"));
					resultInfo.put("y"+idx+"EntrHistR7", dataInfo.get("y0EntrHistR7"));
					resultInfo.put("y"+idx+"SumEntrHist", dataInfo.get("y0SumEntrHist"));
					
					resultInfo = resultList.get(pos+2);
					dataInfo = gr03List.get(j);
					resultInfo.put("y"+idx+"EntrHistU7", dataInfo.get("y0EntrHistU7"));
					resultInfo.put("y"+idx+"EntrHistR7", dataInfo.get("y0EntrHistR7"));
					resultInfo.put("y"+idx+"SumEntrHist", dataInfo.get("y0SumEntrHist"));
					
					resultInfo = resultList.get(pos+3);
					dataInfo = gr04List.get(j);
					resultInfo.put("y"+idx+"EntrHistU7", dataInfo.get("y0EntrHistU7"));
					resultInfo.put("y"+idx+"EntrHistR7", dataInfo.get("y0EntrHistR7"));
					resultInfo.put("y"+idx+"SumEntrHist", dataInfo.get("y0SumEntrHist"));
				}
			}
		}

		mv.addObject("stdyySt", startYr);
		mv.addObject("stdyyEd", endYr);	
		mv.addObject("resultList", resultList);

		return mv;
	}
	
	/**
	 * 주요지표현황 화면
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectStaticsIndx(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/BD_UIPSA0053");
		
		// 탭구분
		rqstMap.put("ad_type", "4");
		
		HashMap param = new HashMap();
		
		// 검색조건 년도목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		mv.addObject("stdyyList", stdyyList);
		
		// 검색조건 업종테마목록 조회
		mv.addObject("themaList", pgps0030Dao.selectInduThemaList(param));
		
		// 검색조건 상세업종목록 조회
		mv.addObject("indutyList", pgps0030Dao.selectIndutyList(param));
		
		// 검색조건 지역코드(권역별)목록 조회
		mv.addObject("areaState", codeService.findCodesByGroupNo("57"));
		
		// 검색조건 지역코드(광역시)목록 조회
		mv.addObject("areaCity", pgps0020Dao.findCodesCity(param));

		// 초기검색조건 설정
		if (!rqstMap.containsKey("searchEntprsGrp")) rqstMap.put("searchEntprsGrp", "EA5");
		if (!rqstMap.containsKey("searchStdyy")) rqstMap.put("searchStdyy", stdyyList.get(0).get("stdyy"));

		// 매출액 and 근로자
		rqstMap.put("searchResnSe", "GR01");
		List<Map> gr01List = selectStaticsLisHistIndx(rqstMap);
		
		// 근로자
		rqstMap.put("searchResnSe", "GR02");
		List<Map> gr02List = selectStaticsLisHistIndx(rqstMap);
		
		// 매출액
		rqstMap.put("searchResnSe", "GR03");
		List<Map> gr03List = selectStaticsLisHistIndx(rqstMap);
		
		// 매출액 or 근로자
		rqstMap.put("searchResnSe", "GR04");
		List<Map> gr04List = selectStaticsLisHistIndx(rqstMap);
		
		List<Map> resultList = new ArrayList();
		
		for (int j=0; j<gr01List.size(); j++) {
			resultList.add(gr01List.get(j));
			resultList.add(gr02List.get(j));
			resultList.add(gr03List.get(j));
			resultList.add(gr04List.get(j));
		}
		
		mv.addObject("resultList", resultList);
		return mv;
	}
	
	/**
	 * DB 데이터 조회
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectStaticsData(Map rqstMap) throws Exception {
		HashMap param = new HashMap();
		
		param.put("entcls", rqstMap.get("searchEntprsGrp")); // 기업군조건
		param.put("resnSe", rqstMap.get("searchResnSe")); // 판정조건
		param.put("stdyy", rqstMap.get("searchStdyy")); // 년도조건
		
		// 업종조건
		if (!MapUtils.getString(rqstMap, "searchInduty", "").equals("")) {
			param.put("induty", MapUtils.getString(rqstMap, "searchInduty"));
			
			if (MapUtils.getObject(rqstMap, "searchIndutyVal") instanceof String[]) {
				param.put("indutyVal", MapUtils.getObject(rqstMap, "searchIndutyVal"));
			} else {
				param.put("indutyVal", new String[] {(String) MapUtils.getObject(rqstMap, "searchIndutyVal")});
			}
		}
		// 지역조건
		if (!MapUtils.getString(rqstMap, "searchArea", "").equals("")) {
			param.put("area", MapUtils.getString(rqstMap, "searchArea"));
			
			if (MapUtils.getObject(rqstMap, "searchAreaVal") instanceof String[]) {
				param.put("areaVal", MapUtils.getObject(rqstMap, "searchAreaVal"));
			} else {
				param.put("areaVal", new String[] {(String) MapUtils.getObject(rqstMap, "searchAreaVal")});
			}
		}
		// 챠트출력여부
		if (!MapUtils.getString(rqstMap, "ad_chartY", "").equals("")) {
			param.put("chartY", MapUtils.getString(rqstMap, "ad_chartY"));
		}
		
		List<Map> dataList = null;
		
		int tabno = MapUtils.getIntValue(rqstMap, "ad_type");
		
		switch (tabno) {
		case 1 :			// 업종별분포추이
			dataList = pgps0050Dao.selectStaticsDataList(param);
			break;
		case 2 :			// 기업규모별현황
			dataList = pgps0050Dao.selectStaticsDataListScle(param);
			break;
		case 3 :			// 업력별분포
			dataList = pgps0050Dao.selectStaticsDataListHistIndx(param);
			break;
		case 4 :			// 주요지표현황
			dataList = pgps0050Dao.selectStaticsDataListHistIndx(param);
			break;
		default :			// 업종별분포추이
			dataList = pgps0050Dao.selectStaticsDataList(param);
		}
		
		return dataList;
	}
	
	/**
	 * 업종별분포 조회(가공처리)
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectStaticsList(Map rqstMap) throws Exception {
		boolean cndInduty = false; // 업종조건 적용여부
		boolean cndArea = false; // 지역조건 적용여부

		// 업종조건
		if (!MapUtils.getString(rqstMap, "searchInduty", "").equals("")) {
			cndInduty = true;
		}
		// 지역조건
		if (!MapUtils.getString(rqstMap, "searchArea", "").equals("")) {
			cndArea = true;
		}
		
		List<Map> resultList = selectStaticsData(rqstMap);
		
		if (resultList == null || resultList.size() <= 0) return null;

		// 제조/비제조 소계
		BigDecimal sumCo = new BigDecimal(0);
		
		// 전산업
		BigDecimal totalCo = new BigDecimal(0);
		
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
				indutyFt = (String) resultInfo.get("indutySe");
				// 지역
				if (rqstMap.get("searchArea").equals("1")) { // 권역별
					areaFt = (String) resultInfo.get("upperCode");
				} else { // 광역시별
					areaFt = (String) resultInfo.get("areaCode");
				}
				
				if (stdIndutyFt == null) stdIndutyFt = indutyFt;
				if (stdAreaFt == null) stdAreaFt = areaFt;
				
				if (!stdIndutyFt.equals(indutyFt) || cndArea && !stdAreaFt.equals(areaFt)) {

					stdIndutyFt = indutyFt;
					
					prevInfo = resultList.get(i-1);
					
					// 제조/비제조 소계
					sumMap = new HashMap();
					sumMap.put("gbnAs", prevInfo.get("gbnAs"));
					sumMap.put("gbnIs", "S");
					sumMap.put("y0Co", sumCo);
					sumMap.put("indutySeNm", prevInfo.get("indutySeNm"));
					sumMap.put("dtlclfcNm", prevInfo.get("indutySeNm"));
					sumMap.put("indutyNm", prevInfo.get("indutySeNm"));
					sumMap.put("upperNm", prevInfo.get("upperNm"));
					sumMap.put("abrv", prevInfo.get("abrv"));
					
					// 제조/비제조 검색이 아니면 제조/비제조 소계 처리
					if (!MapUtils.getString(rqstMap, "searchInduty").equals("1")) {
						sumList.add(sumMap);
					}
					if (dataList.size() > 0) sumList.addAll(dataList);
					
					dataList = new ArrayList<Map>();
					sumCo = new BigDecimal(0);
				}


				if (cndArea && !stdAreaFt.equals(areaFt)) {
					stdAreaFt = areaFt;
					
					prevInfo = resultList.get(i-1);
					
					sumMap = new HashMap();
					sumMap.put("gbnAs", prevInfo.get("gbnAs"));
					sumMap.put("gbnIs", "S");
					sumMap.put("y0Co", totalCo);
					sumMap.put("indutySeNm", "전산업");
					sumMap.put("dtlclfcNm", "전산업");
					sumMap.put("indutyNm", "전산업");
					sumMap.put("upperNm", prevInfo.get("upperNm"));
					sumMap.put("abrv", prevInfo.get("abrv"));
					
					rtnList.add(sumMap);
					if (sumList.size() > 0) rtnList.addAll(sumList);
					
					sumList = new ArrayList<Map>();
					totalCo = new BigDecimal(0);
				}
				
				// 제조/비제조 합계
				sumCo = sumCo.add((BigDecimal) resultInfo.get("y0Co"));
				
				// 지역별 전산업 합계
				totalCo = totalCo.add((BigDecimal) resultInfo.get("y0Co"));
			}
			
			// 임시목록에 레코드 추가
			dataList.add(resultInfo);
		}
		
		// ### 마지막 레코드 처리 ###
		if (cndInduty) {
			
			if (!MapUtils.getString(rqstMap, "searchInduty").equals("1")) {
				// 1. 제조/비제조 소계
				sumMap = new HashMap();
				sumMap.put("gbnAs", resultInfo.get("gbnAs"));
				sumMap.put("gbnIs", "S");
				sumMap.put("y0Co", sumCo);
				sumMap.put("indutySeNm", resultInfo.get("indutySeNm"));
				sumMap.put("dtlclfcNm", resultInfo.get("indutySeNm"));
				sumMap.put("indutyNm", resultInfo.get("indutySeNm"));
				sumMap.put("upperNm", resultInfo.get("upperNm"));
				sumMap.put("abrv", resultInfo.get("abrv"));
				
				sumList.add(sumMap);
			}
			
			// 2. 전업종 합계
			sumMap = new HashMap();
			sumMap.put("gbnAs", resultInfo.get("gbnAs"));
			sumMap.put("gbnIs", "S");
			sumMap.put("y0Co", totalCo);
			sumMap.put("indutySeNm", "전산업");
			sumMap.put("dtlclfcNm", "전산업");
			sumMap.put("indutyNm", "전산업");
			sumMap.put("upperNm", resultInfo.get("upperNm"));
			sumMap.put("abrv", resultInfo.get("abrv"));
			
			rtnList.add(sumMap);
			if (sumList.size() > 0) rtnList.addAll(sumList);
		}
		
		rtnList.addAll(dataList);
		
		return rtnList;
	}
	
	
	/**
	 * 기업규모별현황 조회(가공처리)
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectStaticsListScle(Map rqstMap) throws Exception {
		boolean cndInduty = false; // 업종조건 적용여부
		boolean cndArea = false; // 지역조건 적용여부

		// 업종조건
		if (!MapUtils.getString(rqstMap, "searchInduty", "").equals("")) {
			cndInduty = true;
		}
		// 지역조건
		if (!MapUtils.getString(rqstMap, "searchArea", "").equals("")) {
			cndArea = true;
		}
		
		List<Map> resultList = selectStaticsData(rqstMap);
		
		if (resultList == null || resultList.size() <= 0) return null;

		// 제조/비제조 소계
		BigDecimal sctnCo1 = new BigDecimal(0);
		BigDecimal sctnCo2 = new BigDecimal(0);
		BigDecimal sctnCo3 = new BigDecimal(0);
		BigDecimal sctnCo4 = new BigDecimal(0);
		BigDecimal sctnCo5 = new BigDecimal(0);
		BigDecimal sctnCo6 = new BigDecimal(0);
		BigDecimal sctnCo7 = new BigDecimal(0);
		BigDecimal sctnCo8 = new BigDecimal(0);
		BigDecimal sumCo = new BigDecimal(0);
		
		// 전산업
		BigDecimal totalSctnCo1 = new BigDecimal(0);
		BigDecimal totalSctnCo2 = new BigDecimal(0);
		BigDecimal totalSctnCo3 = new BigDecimal(0);
		BigDecimal totalSctnCo4 = new BigDecimal(0);
		BigDecimal totalSctnCo5 = new BigDecimal(0);
		BigDecimal totalSctnCo6 = new BigDecimal(0);
		BigDecimal totalSctnCo7 = new BigDecimal(0);
		BigDecimal totalSctnCo8 = new BigDecimal(0);
		BigDecimal totalSumCo = new BigDecimal(0);
		
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
				indutyFt = (String) resultInfo.get("indutySe");
				// 지역
				if (rqstMap.get("searchArea").equals("1")) { // 권역별
					areaFt = (String) resultInfo.get("upperCode");
				} else { // 광역시별
					areaFt = (String) resultInfo.get("areaCode");
				}
				
				if (stdIndutyFt == null) stdIndutyFt = indutyFt;
				if (stdAreaFt == null) stdAreaFt = areaFt;
				
				if (!stdIndutyFt.equals(indutyFt) || cndArea && !stdAreaFt.equals(areaFt)) {

					stdIndutyFt = indutyFt;
					
					prevInfo = resultList.get(i-1);
					
					// 제조/비제조 소계
					sumMap = new HashMap();
					sumMap.put("gbnAs", prevInfo.get("gbnAs"));
					sumMap.put("gbnIs", "S");
					sumMap.put("sctn1", sctnCo1);
					sumMap.put("sctn2", sctnCo2);
					sumMap.put("sctn3", sctnCo3);
					sumMap.put("sctn4", sctnCo4);
					sumMap.put("sctn5", sctnCo5);
					sumMap.put("sctn6", sctnCo6);
					sumMap.put("sctn7", sctnCo7);
					sumMap.put("sctn8", sctnCo8);
					sumMap.put("sumSctn", sumCo);
					sumMap.put("resnNm", prevInfo.get("resnNm"));
					sumMap.put("indutySeNm", prevInfo.get("indutySeNm"));
					sumMap.put("dtlclfcNm", prevInfo.get("indutySeNm"));
					sumMap.put("indutyNm", prevInfo.get("indutySeNm"));
					sumMap.put("upperNm", prevInfo.get("upperNm"));
					sumMap.put("abrv", prevInfo.get("abrv"));
					
					// 제조/비제조 검색이 아니면 제조/비제조 소계 처리
					if (!MapUtils.getString(rqstMap, "searchInduty").equals("1")) {
						sumList.add(sumMap);
					}
					if (dataList.size() > 0) sumList.addAll(dataList);
					
					dataList = new ArrayList<Map>();
					
					sctnCo1 = new BigDecimal(0);
					sctnCo2 = new BigDecimal(0);
					sctnCo3 = new BigDecimal(0);
					sctnCo4 = new BigDecimal(0);
					sctnCo5 = new BigDecimal(0);
					sctnCo6 = new BigDecimal(0);
					sctnCo7 = new BigDecimal(0);
					sctnCo8 = new BigDecimal(0);
					sumCo = new BigDecimal(0);
				}


				if (cndArea && !stdAreaFt.equals(areaFt)) {
					stdAreaFt = areaFt;
					
					prevInfo = resultList.get(i-1);
					
					sumMap = new HashMap();
					sumMap.put("gbnAs", prevInfo.get("gbnAs"));
					sumMap.put("gbnIs", "S");
					sumMap.put("sctn1", totalSctnCo1);
					sumMap.put("sctn2", totalSctnCo2);
					sumMap.put("sctn3", totalSctnCo3);
					sumMap.put("sctn4", totalSctnCo4);
					sumMap.put("sctn5", totalSctnCo5);
					sumMap.put("sctn6", totalSctnCo6);
					sumMap.put("sctn7", totalSctnCo7);
					sumMap.put("sctn8", totalSctnCo8);
					sumMap.put("sumSctn", totalSumCo);
					sumMap.put("resnNm", prevInfo.get("resnNm"));
					sumMap.put("indutySeNm", "전산업");
					sumMap.put("dtlclfcNm", "전산업");
					sumMap.put("indutyNm", "전산업");
					sumMap.put("upperNm", prevInfo.get("upperNm"));
					sumMap.put("abrv", prevInfo.get("abrv"));
					
					rtnList.add(sumMap);
					if (sumList.size() > 0) rtnList.addAll(sumList);
					
					sumList = new ArrayList<Map>();
					
					totalSctnCo1 = new BigDecimal(0);
					totalSctnCo2 = new BigDecimal(0);
					totalSctnCo3 = new BigDecimal(0);
					totalSctnCo4 = new BigDecimal(0);
					totalSctnCo5 = new BigDecimal(0);
					totalSctnCo6 = new BigDecimal(0);
					totalSctnCo7 = new BigDecimal(0);
					totalSctnCo8 = new BigDecimal(0);
					totalSumCo = new BigDecimal(0);
				}
				
				// 제조/비제조 합계
				sctnCo1 = sctnCo1.add((BigDecimal) resultInfo.get("sctn1"));
				sctnCo2 = sctnCo1.add((BigDecimal) resultInfo.get("sctn2"));
				sctnCo3 = sctnCo1.add((BigDecimal) resultInfo.get("sctn3"));
				sctnCo4 = sctnCo1.add((BigDecimal) resultInfo.get("sctn4"));
				sctnCo5 = sctnCo1.add((BigDecimal) resultInfo.get("sctn5"));
				sctnCo6 = sctnCo1.add((BigDecimal) resultInfo.get("sctn6"));
				sctnCo7 = sctnCo1.add((BigDecimal) resultInfo.get("sctn7"));
				sctnCo8 = sctnCo1.add((BigDecimal) resultInfo.get("sctn8"));
				sumCo = sumCo.add((BigDecimal) resultInfo.get("sumSctn"));
				
				// 지역별 전산업 합계
				totalSctnCo1 = totalSctnCo1.add((BigDecimal) resultInfo.get("sctn1"));
				totalSctnCo2 = totalSctnCo2.add((BigDecimal) resultInfo.get("sctn2"));
				totalSctnCo3 = totalSctnCo3.add((BigDecimal) resultInfo.get("sctn3"));
				totalSctnCo4 = totalSctnCo4.add((BigDecimal) resultInfo.get("sctn4"));
				totalSctnCo5 = totalSctnCo5.add((BigDecimal) resultInfo.get("sctn5"));
				totalSctnCo6 = totalSctnCo6.add((BigDecimal) resultInfo.get("sctn6"));
				totalSctnCo7 = totalSctnCo7.add((BigDecimal) resultInfo.get("sctn7"));
				totalSctnCo8 = totalSctnCo8.add((BigDecimal) resultInfo.get("sctn8"));
				totalSumCo = totalSumCo.add((BigDecimal) resultInfo.get("sumSctn"));
			}
			
			// 임시목록에 레코드 추가
			dataList.add(resultInfo);
		}
		
		// ### 마지막 레코드 처리 ###
		if (cndInduty) {
			
			if (!MapUtils.getString(rqstMap, "searchInduty").equals("1")) {
				// 1. 제조/비제조 소계
				sumMap = new HashMap();
				sumMap.put("gbnAs", resultInfo.get("gbnAs"));
				sumMap.put("gbnIs", "S");
				sumMap.put("sctn1", sctnCo1);
				sumMap.put("sctn2", sctnCo2);
				sumMap.put("sctn3", sctnCo3);
				sumMap.put("sctn4", sctnCo4);
				sumMap.put("sctn5", sctnCo5);
				sumMap.put("sctn6", sctnCo6);
				sumMap.put("sctn7", sctnCo7);
				sumMap.put("sctn8", sctnCo8);
				sumMap.put("sumSctn", sumCo);
				sumMap.put("resnNm", resultInfo.get("resnNm"));
				sumMap.put("indutySeNm", resultInfo.get("indutySeNm"));
				sumMap.put("dtlclfcNm", resultInfo.get("indutySeNm"));
				sumMap.put("indutyNm", resultInfo.get("indutySeNm"));
				sumMap.put("upperNm", resultInfo.get("upperNm"));
				sumMap.put("abrv", resultInfo.get("abrv"));
				
				sumList.add(sumMap);
			}
			
			// 2. 전업종 합계
			sumMap = new HashMap();
			sumMap.put("gbnAs", resultInfo.get("gbnAs"));
			sumMap.put("gbnIs", "S");
			sumMap.put("sctn1", totalSctnCo1);
			sumMap.put("sctn2", totalSctnCo2);
			sumMap.put("sctn3", totalSctnCo3);
			sumMap.put("sctn4", totalSctnCo4);
			sumMap.put("sctn5", totalSctnCo5);
			sumMap.put("sctn6", totalSctnCo6);
			sumMap.put("sctn7", totalSctnCo7);
			sumMap.put("sctn8", totalSctnCo8);
			sumMap.put("sumSctn", totalSumCo);
			sumMap.put("resnNm", resultInfo.get("resnNm"));
			sumMap.put("indutySeNm", "전산업");
			sumMap.put("dtlclfcNm", "전산업");
			sumMap.put("indutyNm", "전산업");
			sumMap.put("upperNm", resultInfo.get("upperNm"));
			sumMap.put("abrv", resultInfo.get("abrv"));
			
			rtnList.add(sumMap);
			if (sumList.size() > 0) rtnList.addAll(sumList);
		}
		
		rtnList.addAll(dataList);
		
		return rtnList;
	}	
	
	
	/**
	 * 업력별분포 & 주요지표현황 조회(가공처리)
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectStaticsLisHistIndx(Map rqstMap) throws Exception {
		boolean cndInduty = false; // 업종조건 적용여부
		boolean cndArea = false; // 지역조건 적용여부

		// 업종조건
		if (!MapUtils.getString(rqstMap, "searchInduty", "").equals("")) {
			cndInduty = true;
		}
		// 지역조건
		if (!MapUtils.getString(rqstMap, "searchArea", "").equals("")) {
			cndArea = true;
		}
		
		List<Map> resultList = selectStaticsData(rqstMap);
		
		if (resultList == null || resultList.size() <= 0) return null;

		// 제조/비제조 소계
		BigDecimal entrHistR7 = new BigDecimal(0);
		BigDecimal entrHistU7 = new BigDecimal(0);
		BigDecimal sumEntrHist = new BigDecimal(0);
		BigDecimal entrprsCo = new BigDecimal(0);
		BigDecimal selngAm = new BigDecimal(0);
		BigDecimal xportAmDr = new BigDecimal(0);
		BigDecimal labrCo = new BigDecimal(0);
		BigDecimal rsrchCt = new BigDecimal(0);
		BigDecimal rsrchRt = new BigDecimal(0);
		
		// 전산업
		BigDecimal totalEntrHistR7 = new BigDecimal(0);
		BigDecimal totalEntrHistU7 = new BigDecimal(0);
		BigDecimal totalSumEntrHist = new BigDecimal(0);
		BigDecimal totalEntrprsCo = new BigDecimal(0);
		BigDecimal totalSelngAm = new BigDecimal(0);
		BigDecimal totalXportAmDr = new BigDecimal(0);
		BigDecimal totalLabrCo = new BigDecimal(0);
		BigDecimal totalRsrchCt = new BigDecimal(0);
		BigDecimal totalRsrchRt = new BigDecimal(0);
		
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
				indutyFt = (String) resultInfo.get("indutySe");
				// 지역
				if (rqstMap.get("searchArea").equals("1")) { // 권역별
					areaFt = (String) resultInfo.get("upperCode");
				} else { // 광역시별
					areaFt = (String) resultInfo.get("areaCode");
				}
				
				if (stdIndutyFt == null) stdIndutyFt = indutyFt;
				if (stdAreaFt == null) stdAreaFt = areaFt;
				
				if (!stdIndutyFt.equals(indutyFt) || cndArea && !stdAreaFt.equals(areaFt)) {

					stdIndutyFt = indutyFt;
					
					prevInfo = resultList.get(i-1);
					
					// 제조/비제조 소계
					sumMap = new HashMap();
					sumMap.put("gbnAs", prevInfo.get("gbnAs"));
					sumMap.put("gbnIs", "S");
					sumMap.put("y0EntrHistR7", entrHistR7);
					sumMap.put("y0EntrHistU7", entrHistU7);
					sumMap.put("y0SumEntrHist", sumEntrHist);
					sumMap.put("entrprsCo", entrprsCo);
					sumMap.put("avrgSelngAm", selngAm);
					sumMap.put("avrgXportAmDollar", xportAmDr);
					sumMap.put("avrgOrdtmLabrrCo", labrCo);
					sumMap.put("avrgRsrchDevlopCt", rsrchCt);
					sumMap.put("avrgRsrchDevlopRt", rsrchRt);
					sumMap.put("resnNm", prevInfo.get("resnNm"));
					sumMap.put("indutySeNm", prevInfo.get("indutySeNm"));
					sumMap.put("dtlclfcNm", prevInfo.get("indutySeNm"));
					sumMap.put("indutyNm", prevInfo.get("indutySeNm"));
					sumMap.put("upperNm", prevInfo.get("upperNm"));
					sumMap.put("abrv", prevInfo.get("abrv"));
					
					// 제조/비제조 검색이 아니면 제조/비제조 소계 처리
					if (!MapUtils.getString(rqstMap, "searchInduty").equals("1")) {
						sumList.add(sumMap);
					}
					if (dataList.size() > 0) sumList.addAll(dataList);
					
					dataList = new ArrayList<Map>();
					
					entrHistR7 = new BigDecimal(0);
					entrHistU7 = new BigDecimal(0);
					sumEntrHist = new BigDecimal(0);
					entrprsCo = new BigDecimal(0);
					selngAm = new BigDecimal(0);
					xportAmDr = new BigDecimal(0);
					labrCo = new BigDecimal(0);
					rsrchCt = new BigDecimal(0);
					rsrchRt = new BigDecimal(0);
				}


				if (cndArea && !stdAreaFt.equals(areaFt)) {
					stdAreaFt = areaFt;
					
					prevInfo = resultList.get(i-1);
					
					sumMap = new HashMap();
					sumMap.put("gbnAs", prevInfo.get("gbnAs"));
					sumMap.put("gbnIs", "S");
					sumMap.put("y0EntrHistR7", totalEntrHistR7);
					sumMap.put("y0EntrHistU7", totalEntrHistU7);
					sumMap.put("y0SumEntrHist", totalSumEntrHist);
					sumMap.put("entrprsCo", totalEntrprsCo);
					sumMap.put("avrgSelngAm", totalSelngAm);
					sumMap.put("avrgXportAmDollar", totalXportAmDr);
					sumMap.put("avrgOrdtmLabrrCo", totalLabrCo);
					sumMap.put("avrgRsrchDevlopCt", totalRsrchCt);
					sumMap.put("avrgRsrchDevlopRt", totalRsrchRt);
					sumMap.put("resnNm", prevInfo.get("resnNm"));
					sumMap.put("indutySeNm", "전산업");
					sumMap.put("dtlclfcNm", "전산업");
					sumMap.put("indutyNm", "전산업");
					sumMap.put("upperNm", prevInfo.get("upperNm"));
					sumMap.put("abrv", prevInfo.get("abrv"));
					
					rtnList.add(sumMap);
					if (sumList.size() > 0) rtnList.addAll(sumList);
					
					sumList = new ArrayList<Map>();
					
					totalEntrHistR7 = new BigDecimal(0);
					totalEntrHistU7 = new BigDecimal(0);
					totalSumEntrHist = new BigDecimal(0);
					totalEntrprsCo = new BigDecimal(0);
					totalSelngAm = new BigDecimal(0);
					totalXportAmDr = new BigDecimal(0);
					totalLabrCo = new BigDecimal(0);
					totalRsrchCt = new BigDecimal(0);
					totalRsrchRt = new BigDecimal(0);
				}
				
				// 제조/비제조 합계
				entrHistR7 = entrHistR7.add((BigDecimal) resultInfo.get("y0EntrHistR7"));
				entrHistU7 = entrHistR7.add((BigDecimal) resultInfo.get("y0EntrHistU7"));
				sumEntrHist = entrHistR7.add((BigDecimal) resultInfo.get("y0SumEntrHist"));
				entrprsCo = entrHistR7.add((BigDecimal) resultInfo.get("entrprsCo"));
				selngAm = entrHistR7.add((BigDecimal) resultInfo.get("avrgSelngAm"));
				xportAmDr = entrHistR7.add((BigDecimal) resultInfo.get("avrgXportAmDollar"));
				labrCo = entrHistR7.add((BigDecimal) resultInfo.get("avrgOrdtmLabrrCo"));
				rsrchCt = entrHistR7.add((BigDecimal) resultInfo.get("avrgRsrchDevlopCt"));
				rsrchRt = rsrchRt.add((BigDecimal) resultInfo.get("avrgRsrchDevlopRt"));
				
				// 지역별 전산업 합계
				totalEntrHistR7 = totalEntrHistR7.add((BigDecimal) resultInfo.get("y0EntrHistR7"));
				totalEntrHistU7 = totalEntrHistU7.add((BigDecimal) resultInfo.get("y0EntrHistU7"));
				totalSumEntrHist = totalSumEntrHist.add((BigDecimal) resultInfo.get("y0SumEntrHist"));
				totalEntrprsCo = totalEntrprsCo.add((BigDecimal) resultInfo.get("entrprsCo"));
				totalSelngAm = totalSelngAm.add((BigDecimal) resultInfo.get("avrgSelngAm"));
				totalXportAmDr = totalXportAmDr.add((BigDecimal) resultInfo.get("avrgXportAmDollar"));
				totalLabrCo = totalLabrCo.add((BigDecimal) resultInfo.get("avrgOrdtmLabrrCo"));
				totalRsrchCt = totalRsrchCt.add((BigDecimal) resultInfo.get("avrgRsrchDevlopCt"));
				totalRsrchRt = totalRsrchRt.add((BigDecimal) resultInfo.get("avrgRsrchDevlopRt"));
			}
			
			// 임시목록에 레코드 추가
			dataList.add(resultInfo);
		}
		
		// ### 마지막 레코드 처리 ###
		if (cndInduty) {
			
			if (!MapUtils.getString(rqstMap, "searchInduty").equals("1")) {
				// 1. 제조/비제조 소계
				sumMap = new HashMap();
				sumMap.put("gbnAs", resultInfo.get("gbnAs"));
				sumMap.put("gbnIs", "S");
				sumMap.put("y0EntrHistR7", entrHistR7);
				sumMap.put("y0EntrHistU7", entrHistU7);
				sumMap.put("y0SumEntrHist", sumEntrHist);
				sumMap.put("entrprsCo", entrprsCo);
				sumMap.put("avrgSelngAm", selngAm);
				sumMap.put("avrgXportAmDollar", xportAmDr);
				sumMap.put("avrgOrdtmLabrrCo", labrCo);
				sumMap.put("avrgRsrchDevlopCt", rsrchCt);
				sumMap.put("avrgRsrchDevlopRt", rsrchRt);
				sumMap.put("resnNm", resultInfo.get("resnNm"));
				sumMap.put("indutySeNm", resultInfo.get("indutySeNm"));
				sumMap.put("dtlclfcNm", resultInfo.get("indutySeNm"));
				sumMap.put("indutyNm", resultInfo.get("indutySeNm"));
				sumMap.put("upperNm", resultInfo.get("upperNm"));
				sumMap.put("abrv", resultInfo.get("abrv"));
				
				sumList.add(sumMap);
			}
			
			// 2. 전업종 합계
			sumMap = new HashMap();
			sumMap.put("gbnAs", resultInfo.get("gbnAs"));
			sumMap.put("gbnIs", "S");
			sumMap.put("y0EntrHistR7", totalEntrHistR7);
			sumMap.put("y0EntrHistU7", totalEntrHistU7);
			sumMap.put("y0SumEntrHist", totalSumEntrHist);
			sumMap.put("entrprsCo", totalEntrprsCo);
			sumMap.put("avrgSelngAm", totalSelngAm);
			sumMap.put("avrgXportAmDollar", totalXportAmDr);
			sumMap.put("avrgOrdtmLabrrCo", totalLabrCo);
			sumMap.put("avrgRsrchDevlopCt", totalRsrchCt);
			sumMap.put("avrgRsrchDevlopRt", totalRsrchRt);
			sumMap.put("resnNm", resultInfo.get("resnNm"));
			sumMap.put("indutySeNm", "전산업");
			sumMap.put("dtlclfcNm", "전산업");
			sumMap.put("indutyNm", "전산업");
			sumMap.put("upperNm", resultInfo.get("upperNm"));
			sumMap.put("abrv", resultInfo.get("abrv"));
			
			rtnList.add(sumMap);
			if (sumList.size() > 0) rtnList.addAll(sumList);
		}
		
		rtnList.addAll(dataList);
		
		return rtnList;
	}		
	
	/**
	 * 엑셀 다운로드
	 * @param rqstMap
	 * @return
	 * @throws Exception 
	 */
	public ModelAndView excelStatics(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		List<Map> resultList = new ArrayList();
		IExcelVO excel = null;
		
		// 파일명(기준년도)
		String stdyy = MapUtils.getString(rqstMap, "searchStdyy");
		String stdyySt = MapUtils.getString(rqstMap, "searchStdyySt", "0");
		String stdyyEd = MapUtils.getString(rqstMap, "searchStdyyEd", "0");
		
		int startYr = Integer.valueOf(stdyySt);
		int endYr = Integer.valueOf(stdyyEd);
		
		// 타이틀
		ArrayList<String> headers = new ArrayList<String>();
		ArrayList<String> subHeaders = new ArrayList<String>();
		
		// 지역조건
		if (!MapUtils.getString(rqstMap, "searchArea", "").equals("")) {
			headers.add("지역");
		}
		// 업종조건
		if (!MapUtils.getString(rqstMap, "searchInduty", "").equals("")) {
			headers.add("업종/거래유형");
		}

		ArrayList<String> items = new ArrayList<String>();
		// 지역조건
		if (!MapUtils.getString(rqstMap, "searchArea", "").equals("")) {
			if (MapUtils.getString(rqstMap, "searchArea").equals("1")) items.add("upperNm");
			if (MapUtils.getString(rqstMap, "searchArea").equals("2")) items.add("abrv");
		}
		// 업종조건
		if (!MapUtils.getString(rqstMap, "searchInduty", "").equals("")) {
			if (MapUtils.getString(rqstMap, "searchInduty").equals("1")) items.add("indutySeNm");
			if (MapUtils.getString(rqstMap, "searchInduty").equals("2")) items.add("dtlclfcNm");
			if (MapUtils.getString(rqstMap, "searchInduty").equals("3")) items.add("indutyNm");
		}

		List<Map> dataList = null;
		List<Map> gr01List = null;
		List<Map> gr02List = null;
		List<Map> gr03List = null;
		List<Map> gr04List = null;
		
		int idx = 0;
		int pos = 0;
		int tabno = MapUtils.getIntValue(rqstMap, "ad_type");
		
		switch (tabno) {
		case 1 :				// 업종별분포추이
			
			for (int i=startYr; i<=endYr; i++) {
				headers.add(String.valueOf(i));
				items.add("y"+idx+"Co");
				
				rqstMap.put("searchStdyy", String.valueOf(i));
				dataList = selectStaticsList(rqstMap);
				
				if (resultList.size() == 0) {
					resultList.addAll(dataList);
				} else {
					for (int j=0; j<dataList.size(); j++) {
						Map dataInfo = dataList.get(j);
						Map resultInfo = resultList.get(j);
						resultInfo.put("y"+idx+"Co", dataInfo.get("y0Co"));
					}
				}
				idx++;
			}
			
			excel = new ExcelVO("가젤형기업현황_업종별분포추이_"+DateFormatUtil.getTodayFull());
			
			break;
		case 2 :				// 기업규모별현황

			headers.add("고성장기준");
			for (CodeVO code : codeService.findCodesByGroupNo("61")) {
				headers.add(code.getCodeNm());
			}
			headers.add("계");
			
			items.add("resnNm");
			items.add("sctn1");
			items.add("sctn2");
			items.add("sctn3");
			items.add("sctn4");
			items.add("sctn5");
			items.add("sctn6");
			items.add("sctn7");
			items.add("sctn8");
			items.add("sumSctn");
			
			// 매출액 and 근로자
			rqstMap.put("searchResnSe", "GR01");
			gr01List = selectStaticsListScle(rqstMap);
			
			// 근로자
			rqstMap.put("searchResnSe", "GR02");
			gr02List = selectStaticsListScle(rqstMap);
			
			// 매출액
			rqstMap.put("searchResnSe", "GR03");
			gr03List =  selectStaticsListScle(rqstMap);
			
			// 매출액 or 근로자
			rqstMap.put("searchResnSe", "GR04");
			gr04List = selectStaticsListScle(rqstMap);

			for (int i=0; i<gr01List.size(); i++) {
				resultList.add(gr01List.get(i));
				resultList.add(gr02List.get(i));
				resultList.add(gr03List.get(i));
				resultList.add(gr04List.get(i));
			}
			
			excel = new ExcelVO("가젤형기업현황_기업규모별현황_"+DateFormatUtil.getTodayFull());
			
			break;
		case 3 :				// 업력별분포
			
			headers.add("고성장기준");
			items.add("resnNm");
			
			for (int i=startYr; i<=endYr; i++) {
				headers.add(String.valueOf(i));
				headers.add("");
				headers.add("");
				
				subHeaders.add("계");
				subHeaders.add("7년미만");
				subHeaders.add("7년이상");
				
				items.add("y"+idx+"SumEntrHist");
				items.add("y"+idx+"EntrHistR7");
				items.add("y"+idx+"EntrHistU7");
				
				rqstMap.put("searchStdyy", String.valueOf(i));
				
				// 매출액 and 근로자
				rqstMap.put("searchResnSe", "GR01");
				gr01List = selectStaticsLisHistIndx(rqstMap);
				
				// 근로자
				rqstMap.put("searchResnSe", "GR02");
				gr02List = selectStaticsLisHistIndx(rqstMap);
				
				// 매출액
				rqstMap.put("searchResnSe", "GR03");
				gr03List =  selectStaticsLisHistIndx(rqstMap);
				
				// 매출액 or 근로자
				rqstMap.put("searchResnSe", "GR04");
				gr04List = selectStaticsLisHistIndx(rqstMap);
	
				
				if (resultList.size() == 0) {
					for (int j=0; j<gr01List.size(); j++) {
						resultList.add(gr01List.get(j));
						resultList.add(gr02List.get(j));
						resultList.add(gr03List.get(j));
						resultList.add(gr04List.get(j));
					}
				} else {
					for (int j=0; j<gr01List.size(); j++) {
						pos = j * 4;

						Map resultInfo = resultList.get(pos);
						Map dataInfo = gr01List.get(j);					
						resultInfo.put("y"+idx+"EntrHistU7", dataInfo.get("y0EntrHistU7"));
						resultInfo.put("y"+idx+"EntrHistR7", dataInfo.get("y0EntrHistR7"));
						resultInfo.put("y"+idx+"SumEntrHist", dataInfo.get("y0SumEntrHist"));

						resultInfo = resultList.get(pos+1);
						dataInfo = gr02List.get(j);
						resultInfo.put("y"+idx+"EntrHistU7", dataInfo.get("y0EntrHistU7"));
						resultInfo.put("y"+idx+"EntrHistR7", dataInfo.get("y0EntrHistR7"));
						resultInfo.put("y"+idx+"SumEntrHist", dataInfo.get("y0SumEntrHist"));

						resultInfo = resultList.get(pos+2);
						dataInfo = gr03List.get(j);
						resultInfo.put("y"+idx+"EntrHistU7", dataInfo.get("y0EntrHistU7"));
						resultInfo.put("y"+idx+"EntrHistR7", dataInfo.get("y0EntrHistR7"));
						resultInfo.put("y"+idx+"SumEntrHist", dataInfo.get("y0SumEntrHist"));

						resultInfo = resultList.get(pos+3);
						dataInfo = gr04List.get(j);
						resultInfo.put("y"+idx+"EntrHistU7", dataInfo.get("y0EntrHistU7"));
						resultInfo.put("y"+idx+"EntrHistR7", dataInfo.get("y0EntrHistR7"));
						resultInfo.put("y"+idx+"SumEntrHist", dataInfo.get("y0SumEntrHist"));
					}
				}
				idx++;
			}

			String[] arrySubHeaders = new String[] {};
			arrySubHeaders = subHeaders.toArray(arrySubHeaders);
			mv.addObject("_subHeaders", arrySubHeaders);
			
			excel = new PGPS0050ExcelVO("가젤형기업현황_업력별분포_"+DateFormatUtil.getTodayFull());
			
			break;
		case 4 :				// 주요지표현황
			
			headers.add("고성장기준");
			headers.add("기업수");
			headers.add("평균매출액(억원)");
			headers.add("평균수출액(백만불)");
			headers.add("평균근로자수(명)");
			headers.add("평균R&D투자");
			headers.add("평균R&D투자비율");
			
			items.add("resnNm");
			items.add("entrprsCo");
			items.add("avrgSelngAm");
			items.add("avrgXportAmDollar");
			items.add("avrgOrdtmLabrrCo");
			items.add("avrgRsrchDevlopCt");
			items.add("avrgRsrchDevlopRt");

			// 매출액 and 근로자
			rqstMap.put("searchResnSe", "GR01");
			gr01List = selectStaticsLisHistIndx(rqstMap);
			
			// 근로자
			rqstMap.put("searchResnSe", "GR02");
			gr02List = selectStaticsLisHistIndx(rqstMap);
			
			// 매출액
			rqstMap.put("searchResnSe", "GR03");
			gr03List =  selectStaticsLisHistIndx(rqstMap);
			
			// 매출액 or 근로자
			rqstMap.put("searchResnSe", "GR04");
			gr04List = selectStaticsLisHistIndx(rqstMap);
			
			for (int i=0; i<gr01List.size(); i++) {
				resultList.add(gr01List.get(i));
				resultList.add(gr02List.get(i));
				resultList.add(gr03List.get(i));
				resultList.add(gr04List.get(i));
			}

			excel = new ExcelVO("가젤형기업현황_주요지표현황_"+DateFormatUtil.getTodayFull());
			
			break;
		default :

		}

		String[] arryHeaders = new String[] {};
		String[] arryItems = new String[] {};
		arryHeaders = headers.toArray(arryHeaders);
		arryItems = items.toArray(arryItems);
		
		mv.addObject("_headers", arryHeaders);
		mv.addObject("_items", arryItems);
		mv.addObject("_list", resultList);
		
		return ResponseUtil.responseExcel(mv, excel);
	}
	
	public ModelAndView getAllChart(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();

		// 업종별분포추이
		if(MapUtils.getInteger(rqstMap, "ad_type") == 1) {
			mv.setViewName("/admin/ps/PD_UIPSA0050_1");
		}
		// 업력별분포추이
		else if(MapUtils.getInteger(rqstMap, "ad_type") == 3) {
			mv.setViewName("/admin/ps/PD_UIPSA0052_1");
		}

		HashMap param = new HashMap();
		List<Map> areaResultList = new ArrayList();
		List<Map> indutyResultList = new ArrayList();
		
		// 검색조건 년도목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		mv.addObject("stdyyList", stdyyList);
		
		// 초기검색조건 설정
		if (!rqstMap.containsKey("searchEntprsGrp")) rqstMap.put("searchEntprsGrp", "EA1");
				
		// ad_type == 1 or ad_type == 3
		// 년도입력이 기간일경우
		// 검색기간 조건 설정
		int startYr = 2012;
		int endYr = Integer.parseInt((String) stdyyList.get(0).get("stdyy"));
		if (rqstMap.containsKey("searchStdyySt")) {
			startYr = MapUtils.getIntValue(rqstMap, "searchStdyySt");
		} else {
			if ( (endYr - 10) > startYr) {
				startYr = Integer.parseInt((String) stdyyList.get(9).get("stdyy"));
			}
		}
		if (rqstMap.containsKey("searchStdyyEd")) endYr = MapUtils.getIntValue(rqstMap, "searchStdyyEd");
			
		mv.addObject("stdyySt", startYr);
		mv.addObject("stdyyEd", endYr);
			
		if (MapUtils.getInteger(rqstMap, "ad_type") == 1) {
			// 지역별
			String searchAreaVal = null;
			if (rqstMap.containsKey("searchAreaVal")) searchAreaVal = (String) rqstMap.get("searchAreaVal");
			// 업무별
			String searchIndutyVal = null;
			if (rqstMap.containsKey("searchIndutyVal")) searchIndutyVal = (String) rqstMap.get("searchIndutyVal");

			String[] array_searchAreaVal = searchAreaVal.split(",");
			String[] array_searchIndutyVal = searchIndutyVal.split(",");
			
			rqstMap.put("searchAreaVal", array_searchAreaVal);
			rqstMap.put("searchIndutyVal", array_searchIndutyVal);
			
			String searchArea = MapUtils.getString(rqstMap, "searchArea");
			String searchInduty = MapUtils.getString(rqstMap, "searchInduty");

			
			// 지역별 챠트 쿼리
			rqstMap.put("ad_chartY", "area");
			List<Map> dataList1 = null;
			List<Map> dataList2 = null;
			
			int idx = 0;
			
			// 검색기간 데이터 조회
			for (int i=startYr; i<=endYr; i++) {
				rqstMap.put("searchStdyy", String.valueOf(i));
				dataList1 = selectStaticsData(rqstMap);
				
				if (areaResultList.size() == 0) {
					areaResultList.addAll(dataList1);
				} else {
					idx++;
					for (int j=0; j<dataList1.size(); j++) {
						Map dataInfo = dataList1.get(j);
						
						Map resultInfo = areaResultList.get(j);
						resultInfo.put("y"+idx+"Co", dataInfo.get("y0Co"));
					}
				}
			}
			// 업무별 챠트 쿼리
			rqstMap.put("ad_chartY", "induty");
			idx = 0;
			
			// 검색기간 데이터 조회
			for (int i=startYr; i<=endYr; i++) {
				rqstMap.put("searchStdyy", String.valueOf(i));
				dataList2 = selectStaticsData(rqstMap);
					
				if (indutyResultList.size() == 0) {
					indutyResultList.addAll(dataList2);
				} else {
					idx++;
					for (int j=0; j<dataList2.size(); j++) {
						Map dataInfo = dataList2.get(j);
						Map resultInfo = indutyResultList.get(j);
						resultInfo.put("y"+idx+"Co", dataInfo.get("y0Co"));
					}
				}
			}
			mv.addObject("searchArea",searchArea);
			mv.addObject("searchInduty",searchInduty);
		}
			
		else if (MapUtils.getInteger(rqstMap, "ad_type") == 3 ) {
			
			List<Map> resultList = new ArrayList();
			int idx = 0;
			int pos = 0;
			
			for (int i=startYr; i<=endYr; i++) {
				rqstMap.put("searchStdyy", String.valueOf(i));
				
				// 매출액 and 근로자
				rqstMap.put("searchResnSe", "GR01");
				List<Map> gr01List = selectStaticsLisHistIndx(rqstMap);
				
				// 근로자
				rqstMap.put("searchResnSe", "GR02");
				List<Map> gr02List = selectStaticsLisHistIndx(rqstMap);
				
				// 매출액
				rqstMap.put("searchResnSe", "GR03");
				List<Map> gr03List =  selectStaticsLisHistIndx(rqstMap);
				
				// 매출액 or 근로자
				rqstMap.put("searchResnSe", "GR04");
				List<Map> gr04List = selectStaticsLisHistIndx(rqstMap);

				
				if (resultList.size() == 0) {
					for (int j=0; j<gr01List.size(); j++) {
						resultList.add(gr01List.get(j));
						resultList.add(gr02List.get(j));
						resultList.add(gr03List.get(j));
						resultList.add(gr04List.get(j));
					}
				} else {
					idx++;
					for (int j=0; j<gr01List.size(); j++) {
						pos = j * 4;
						Map resultInfo = resultList.get(pos);
						Map dataInfo = gr01List.get(j);
						resultInfo.put("y"+idx+"EntrHistU7", dataInfo.get("y0EntrHistU7"));
						resultInfo.put("y"+idx+"EntrHistR7", dataInfo.get("y0EntrHistR7"));
						resultInfo.put("y"+idx+"SumEntrHist", dataInfo.get("y0SumEntrHist"));
						
						resultInfo = resultList.get(pos+1);
						dataInfo = gr02List.get(j);
						resultInfo.put("y"+idx+"EntrHistU7", dataInfo.get("y0EntrHistU7"));
						resultInfo.put("y"+idx+"EntrHistR7", dataInfo.get("y0EntrHistR7"));
						resultInfo.put("y"+idx+"SumEntrHist", dataInfo.get("y0SumEntrHist"));
						
						resultInfo = resultList.get(pos+2);
						dataInfo = gr03List.get(j);
						resultInfo.put("y"+idx+"EntrHistU7", dataInfo.get("y0EntrHistU7"));
						resultInfo.put("y"+idx+"EntrHistR7", dataInfo.get("y0EntrHistR7"));
						resultInfo.put("y"+idx+"SumEntrHist", dataInfo.get("y0SumEntrHist"));
						
						resultInfo = resultList.get(pos+3);
						dataInfo = gr04List.get(j);
						resultInfo.put("y"+idx+"EntrHistU7", dataInfo.get("y0EntrHistU7"));
						resultInfo.put("y"+idx+"EntrHistR7", dataInfo.get("y0EntrHistR7"));
						resultInfo.put("y"+idx+"SumEntrHist", dataInfo.get("y0SumEntrHist"));
					}
				}
			}
			mv.addObject("resultList", resultList);
			mv.addObject("resultListCnt", resultList.size());
		}
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrp"));
		mv.addObject("searchEntprsGrp",codeService.findCodeInfo(param).get("codeNm"));
		
		mv.addObject("areaResultList", areaResultList);
		mv.addObject("areaListCnt", areaResultList.size());
		mv.addObject("indutyResultList", indutyResultList);
		mv.addObject("indutyListCnt", indutyResultList.size());
		
		return mv;
	}
	
	public ModelAndView getPrintOut0(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0050_2");

		HashMap param = new HashMap();
		
		// 검색조건 년도목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		mv.addObject("stdyyList", stdyyList);
		
		// 검색기간 조건 설정
		int startYr = 2012;
		int endYr = Integer.parseInt((String) stdyyList.get(0).get("stdyy"));

		if (rqstMap.containsKey("searchStdyySt")) {
			startYr = MapUtils.getIntValue(rqstMap, "searchStdyySt");
		} else {
			if ( (endYr - 10) > startYr) {
				startYr = Integer.parseInt((String) stdyyList.get(9).get("stdyy"));
			}
		}
		if (rqstMap.containsKey("searchStdyyEd")) endYr = MapUtils.getIntValue(rqstMap, "searchStdyyEd");

		
		// 초기검색조건 설정
		if (!rqstMap.containsKey("searchEntprsGrp")) rqstMap.put("searchEntprsGrp", "EA1");
		
		// 지역별
		String searchAreaVal = null;
		if (rqstMap.containsKey("searchAreaVal")) searchAreaVal = (String) rqstMap.get("searchAreaVal");
		// 업무별
		String searchIndutyVal = null;
		if (rqstMap.containsKey("searchAreaVal")) searchIndutyVal = (String) rqstMap.get("searchIndutyVal");

		String[] array_searchAreaVal = searchAreaVal.split(",");
		String[] array_searchIndutyVal = searchIndutyVal.split(",");
		
		rqstMap.put("searchAreaVal", array_searchAreaVal);
		rqstMap.put("searchIndutyVal", array_searchIndutyVal);
		
		String searchArea = MapUtils.getString(rqstMap, "searchArea");
		String searchInduty = MapUtils.getString(rqstMap, "searchInduty");
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrp"));
		
		List<Map> dataList = null;
		List<Map> resultList = new ArrayList();
		int idx = 0;
		
		// 검색기간 데이터 조회
		for (int i=startYr; i<=endYr; i++) {
			rqstMap.put("searchStdyy", String.valueOf(i));
			dataList = selectStaticsList(rqstMap);
			
			if (resultList.size() == 0) {
				resultList.addAll(dataList);
			} else {
				idx++;
				for (int j=0; j<dataList.size(); j++) {
					Map dataInfo = dataList.get(j);
					Map resultInfo = resultList.get(j);
					resultInfo.put("y"+idx+"Co", dataInfo.get("y0Co"));
				}
			}
		}
		
		mv.addObject("stdyySt", startYr);
		mv.addObject("stdyyEd", endYr);
		mv.addObject("searchEntprsGrp",codeService.findCodeInfo(param).get("codeNm"));
		mv.addObject("searchArea",searchArea);
		mv.addObject("searchInduty",searchInduty);
		mv.addObject("resultList", resultList);
		mv.addObject("listCnt", resultList.size());
		
		return mv;
	}
	
	public ModelAndView getPrintOut1(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0051_2");
		
		// 탭구분
		rqstMap.put("ad_type", "2");
		
		HashMap param = new HashMap();
		
		// 검색조건 년도목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		mv.addObject("stdyyList", stdyyList);
		
		// 검색조건 업종테마목록 조회
		mv.addObject("themaList", pgps0030Dao.selectInduThemaList(param));
		
		// 검색조건 상세업종목록 조회
		mv.addObject("indutyList", pgps0030Dao.selectIndutyList(param));
		
		// 검색조건 지역코드(권역별)목록 조회
		mv.addObject("areaState", codeService.findCodesByGroupNo("57"));
		
		// 검색조건 지역코드(광역시)목록 조회
		mv.addObject("areaCity", pgps0020Dao.findCodesCity(param));

		// 초기검색조건 설정
		if (!rqstMap.containsKey("searchEntprsGrp")) rqstMap.put("searchEntprsGrp", "EA5");
		if (!rqstMap.containsKey("searchStdyy")) rqstMap.put("searchStdyy", stdyyList.get(0).get("stdyy"));
		
		
		// 지역별
		String searchAreaVal = null;
		if (rqstMap.containsKey("searchAreaVal")) searchAreaVal = (String) rqstMap.get("searchAreaVal");
		// 업무별
		String searchIndutyVal = null;
		if (rqstMap.containsKey("searchAreaVal")) searchIndutyVal = (String) rqstMap.get("searchIndutyVal");

		String[] array_searchAreaVal = searchAreaVal.split(",");
		String[] array_searchIndutyVal = searchIndutyVal.split(",");
		String searchStdyy = MapUtils.getString(rqstMap, "searchStdyy");
		
		rqstMap.put("searchAreaVal", array_searchAreaVal);
		rqstMap.put("searchIndutyVal", array_searchIndutyVal);
		
		String searchArea = MapUtils.getString(rqstMap, "searchArea");
		String searchInduty = MapUtils.getString(rqstMap, "searchInduty");
		
		// 테이블 타이틀명 조회
		mv.addObject("scleNmList", codeService.findCodesByGroupNo("61"));

		// 매출액 and 근로자
		rqstMap.put("searchResnSe", "GR01");
		List<Map> gr01List = selectStaticsListScle(rqstMap);
		
		// 근로자
		rqstMap.put("searchResnSe", "GR02");
		List<Map> gr02List = selectStaticsListScle(rqstMap);
		
		// 매출액
		rqstMap.put("searchResnSe", "GR03");
		List<Map> gr03List = selectStaticsListScle(rqstMap);
		
		// 매출액 or 근로자
		rqstMap.put("searchResnSe", "GR04");
		List<Map> gr04List = selectStaticsListScle(rqstMap);
		
		List<Map> resultList = new ArrayList();
		
		for (int j=0; j<gr01List.size(); j++) {
			resultList.add(gr01List.get(j));
			resultList.add(gr02List.get(j));
			resultList.add(gr03List.get(j));
			resultList.add(gr04List.get(j));
		}
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrp"));

		mv.addObject("searchEntprsGrp",codeService.findCodeInfo(param).get("codeNm"));
		mv.addObject("resultList", resultList);
		mv.addObject("listCnt", resultList.size());
		mv.addObject("searchArea",searchArea);
		mv.addObject("searchInduty",searchInduty);
		mv.addObject("stdyy",searchStdyy);
		
		
		
		return mv;
	}
	
	public ModelAndView getPrintOut2(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0052_2");
		
		// 탭구분
		rqstMap.put("ad_type", "3");
		
		HashMap param = new HashMap();
		
		// 검색조건 년도목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		mv.addObject("stdyyList", stdyyList);
		
		// 검색조건 업종테마목록 조회
		mv.addObject("themaList", pgps0030Dao.selectInduThemaList(param));
		
		// 검색조건 상세업종목록 조회
		mv.addObject("indutyList", pgps0030Dao.selectIndutyList(param));
		
		// 검색조건 지역코드(권역별)목록 조회
		mv.addObject("areaState", codeService.findCodesByGroupNo("57"));
		
		// 검색조건 지역코드(광역시)목록 조회
		mv.addObject("areaCity", pgps0020Dao.findCodesCity(param));

		// 초기검색조건 설정
		if (!rqstMap.containsKey("searchEntprsGrp")) rqstMap.put("searchEntprsGrp", "EA5");
		
		// 검색기간 조건 설정
		int startYr = 2012;
		int endYr = Integer.parseInt((String) stdyyList.get(0).get("stdyy"));

		if (rqstMap.containsKey("searchStdyySt")) {
			startYr = MapUtils.getIntValue(rqstMap, "searchStdyySt");
		} else {
			if ( (endYr - 10) > startYr) {
				startYr = Integer.parseInt((String) stdyyList.get(9).get("stdyy"));
			}
		}
		if (rqstMap.containsKey("searchStdyyEd")) endYr = MapUtils.getIntValue(rqstMap, "searchStdyyEd");

		// 지역별
		String searchAreaVal = null;
		if (rqstMap.containsKey("searchAreaVal")) searchAreaVal = (String) rqstMap.get("searchAreaVal");
		// 업무별
		String searchIndutyVal = null;
		if (rqstMap.containsKey("searchAreaVal")) searchIndutyVal = (String) rqstMap.get("searchIndutyVal");

		String[] array_searchAreaVal = searchAreaVal.split(",");
		String[] array_searchIndutyVal = searchIndutyVal.split(",");
		
		rqstMap.put("searchAreaVal", array_searchAreaVal);
		rqstMap.put("searchIndutyVal", array_searchIndutyVal);
		
		String searchArea = MapUtils.getString(rqstMap, "searchArea");
		String searchInduty = MapUtils.getString(rqstMap, "searchInduty");
		
		List<Map> resultList = new ArrayList();
		int idx = 0;
		int pos = 0;
		
		for (int i=startYr; i<=endYr; i++) {
			rqstMap.put("searchStdyy", String.valueOf(i));
			
			// 매출액 and 근로자
			rqstMap.put("searchResnSe", "GR01");
			List<Map> gr01List = selectStaticsLisHistIndx(rqstMap);
			
			// 근로자
			rqstMap.put("searchResnSe", "GR02");
			List<Map> gr02List = selectStaticsLisHistIndx(rqstMap);
			
			// 매출액
			rqstMap.put("searchResnSe", "GR03");
			List<Map> gr03List =  selectStaticsLisHistIndx(rqstMap);
			
			// 매출액 or 근로자
			rqstMap.put("searchResnSe", "GR04");
			List<Map> gr04List = selectStaticsLisHistIndx(rqstMap);

			
			if (resultList.size() == 0) {
				for (int j=0; j<gr01List.size(); j++) {
					resultList.add(gr01List.get(j));
					resultList.add(gr02List.get(j));
					resultList.add(gr03List.get(j));
					resultList.add(gr04List.get(j));
				}
			} else {
				idx++;
				for (int j=0; j<gr01List.size(); j++) {
					pos = j * 4;
					Map resultInfo = resultList.get(pos);
					Map dataInfo = gr01List.get(j);
					resultInfo.put("y"+idx+"EntrHistU7", dataInfo.get("y0EntrHistU7"));
					resultInfo.put("y"+idx+"EntrHistR7", dataInfo.get("y0EntrHistR7"));
					resultInfo.put("y"+idx+"SumEntrHist", dataInfo.get("y0SumEntrHist"));
					
					resultInfo = resultList.get(pos+1);
					dataInfo = gr02List.get(j);
					resultInfo.put("y"+idx+"EntrHistU7", dataInfo.get("y0EntrHistU7"));
					resultInfo.put("y"+idx+"EntrHistR7", dataInfo.get("y0EntrHistR7"));
					resultInfo.put("y"+idx+"SumEntrHist", dataInfo.get("y0SumEntrHist"));
					
					resultInfo = resultList.get(pos+2);
					dataInfo = gr03List.get(j);
					resultInfo.put("y"+idx+"EntrHistU7", dataInfo.get("y0EntrHistU7"));
					resultInfo.put("y"+idx+"EntrHistR7", dataInfo.get("y0EntrHistR7"));
					resultInfo.put("y"+idx+"SumEntrHist", dataInfo.get("y0SumEntrHist"));
					
					resultInfo = resultList.get(pos+3);
					dataInfo = gr04List.get(j);
					resultInfo.put("y"+idx+"EntrHistU7", dataInfo.get("y0EntrHistU7"));
					resultInfo.put("y"+idx+"EntrHistR7", dataInfo.get("y0EntrHistR7"));
					resultInfo.put("y"+idx+"SumEntrHist", dataInfo.get("y0SumEntrHist"));
				}
			}
		}
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrp"));

		mv.addObject("stdyySt", startYr);
		mv.addObject("stdyyEd", endYr);	
		mv.addObject("searchEntprsGrp",codeService.findCodeInfo(param).get("codeNm"));
		mv.addObject("searchArea",searchArea);
		mv.addObject("searchInduty",searchInduty);
		mv.addObject("resultList", resultList);
		mv.addObject("listCnt", resultList.size());

		return mv;

	}
	
	public ModelAndView getPrintOut3(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0053_2");
		
		// 탭구분
		rqstMap.put("ad_type", "4");
		
		HashMap param = new HashMap();
		
		// 검색조건 년도목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		mv.addObject("stdyyList", stdyyList);
		
		// 검색조건 업종테마목록 조회
		mv.addObject("themaList", pgps0030Dao.selectInduThemaList(param));
		
		// 검색조건 상세업종목록 조회
		mv.addObject("indutyList", pgps0030Dao.selectIndutyList(param));
		
		// 검색조건 지역코드(권역별)목록 조회
		mv.addObject("areaState", codeService.findCodesByGroupNo("57"));
		
		// 검색조건 지역코드(광역시)목록 조회
		mv.addObject("areaCity", pgps0020Dao.findCodesCity(param));

		// 초기검색조건 설정
		if (!rqstMap.containsKey("searchEntprsGrp")) rqstMap.put("searchEntprsGrp", "EA5");
		if (!rqstMap.containsKey("searchStdyy")) rqstMap.put("searchStdyy", stdyyList.get(0).get("stdyy"));

		// 지역별
		String searchAreaVal = null;
		if (rqstMap.containsKey("searchAreaVal")) searchAreaVal = (String) rqstMap.get("searchAreaVal");
		// 업무별
		String searchIndutyVal = null;
		if (rqstMap.containsKey("searchAreaVal")) searchIndutyVal = (String) rqstMap.get("searchIndutyVal");

		String[] array_searchAreaVal = searchAreaVal.split(",");
		String[] array_searchIndutyVal = searchIndutyVal.split(",");
		
		rqstMap.put("searchAreaVal", array_searchAreaVal);
		rqstMap.put("searchIndutyVal", array_searchIndutyVal);
		
		String searchArea = MapUtils.getString(rqstMap, "searchArea");
		String searchInduty = MapUtils.getString(rqstMap, "searchInduty");
		String searchStdyy = MapUtils.getString(rqstMap, "searchStdyy");
		
		// 매출액 and 근로자
		rqstMap.put("searchResnSe", "GR01");
		List<Map> gr01List = selectStaticsLisHistIndx(rqstMap);
		
		// 근로자
		rqstMap.put("searchResnSe", "GR02");
		List<Map> gr02List = selectStaticsLisHistIndx(rqstMap);
		
		// 매출액
		rqstMap.put("searchResnSe", "GR03");
		List<Map> gr03List = selectStaticsLisHistIndx(rqstMap);
		
		// 매출액 or 근로자
		rqstMap.put("searchResnSe", "GR04");
		List<Map> gr04List = selectStaticsLisHistIndx(rqstMap);
		
		List<Map> resultList = new ArrayList();
		
		for (int j=0; j<gr01List.size(); j++) {
			resultList.add(gr01List.get(j));
			resultList.add(gr02List.get(j));
			resultList.add(gr03List.get(j));
			resultList.add(gr04List.get(j));
		}
		
		mv.addObject("resultList", resultList);
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrp"));

		mv.addObject("searchEntprsGrp",codeService.findCodeInfo(param).get("codeNm"));
		mv.addObject("searchArea",searchArea);
		mv.addObject("searchInduty",searchInduty);
		mv.addObject("resultList", resultList);
		mv.addObject("listCnt", resultList.size());
		mv.addObject("stdyy",searchStdyy);

		return mv;
	}
}
