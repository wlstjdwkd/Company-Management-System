package biz.tech.ps;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.response.ExcelVO;
import com.comm.response.GridJsonVO;
import com.comm.response.IExcelVO;
import com.comm.code.CodeService;
import com.comm.code.CodeVO;
import com.infra.util.DateFormatUtil;
import com.infra.util.ResponseUtil;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import biz.tech.mapif.ps.PGPS0010Mapper;
import biz.tech.mapif.ps.PGPS0020Mapper;
import biz.tech.mapif.ps.PGPS0030Mapper;


/**
 * 현황및통계
 * @author CWJ
 *
 */
@Service("PGPS0020")
public class PGPS0020Service extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(PGPS0020Service.class);
	
	@Autowired
	CodeService codeService;
	
	@Resource(name = "PGPS0020Mapper")
	private PGPS0020Mapper entprsDAO;
	
	@Resource(name = "PGPS0030Mapper")
	private PGPS0030Mapper pgps0030Dao;
	
	@Resource(name = "PGPS0010Mapper")
	private PGPS0010Mapper pgps0010Dao;
	
	
	/*
	 * ############## 주요지표현황(2015.01.13 강수종) #############
	 */
	
	/**
	 * 주요지표 조회
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/BD_UIPSA0020");
		HashMap param = new HashMap();
		
		// 검색조건 년도목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		mv.addObject("stdyyList", stdyyList);
		
		// 검색조건 업종테마목록 조회
		mv.addObject("themaList", pgps0030Dao.selectInduThemaList(param));
		
		// 검색조건 업종테마목록 조회
		mv.addObject("indutyList", pgps0030Dao.selectIndutyList(param));
		
		// 검색조건 지역코드(권역별)목록 조회
		mv.addObject("areaState", codeService.findCodesByGroupNo("57"));
		
		// 검색조건 지역코드(광역시)목록 조회
		mv.addObject("areaCity", entprsDAO.findCodesCity(param));
		
		// 검색조건 기업군목록 조회
		mv.addObject("entprsList", codeService.findCodesByGroupNo("14"));
		
		// 출력조건 지표
		mv.addObject("indexSumList", codeService.findCodesByGroupNo("64"));
		mv.addObject("indexAvgList", codeService.findCodesByGroupNo("65"));
		
		// 초기검색조건 설정
		if (!rqstMap.containsKey("searchEntprsGrpVal")) {
			rqstMap.put("searchEntprsGrpVal", "EA1");
		}
		if (!rqstMap.containsKey("searchStdyy")) rqstMap.put("searchStdyy", stdyyList.get(0).get("stdyy"));
		
		// 초기조회지표 설정
		ArrayList<String> indexVal = new ArrayList();
		if (!rqstMap.containsKey("searchIndex")) {
			rqstMap.put("searchIndex", "1");
			List<CodeVO> indexList = codeService.findCodesByGroupNo("64");

			for (CodeVO code: indexList) {
				indexVal.add(code.getCode());
			}
			String[] arrIndexVal = new String[] {};
			arrIndexVal = indexVal.toArray(arrIndexVal);
			rqstMap.put("searchIndexVal", arrIndexVal);
		}

		mv.addObject("searchIndex", rqstMap.get("searchIndex"));
		mv.addObject("searchIndexVal", rqstMap.get("searchIndexVal"));
		
		List<Map> resultList = selectIndxStaticsList(rqstMap);
		mv.addObject("resultList", resultList);
		
		Map resultInfo = resultList.get(0);
		ArrayList<String> columnList = new ArrayList();
		String[] arrColmList = new String[] {};
		
		Iterator colmItr = resultInfo.keySet().iterator();
		while (colmItr.hasNext()) {
			String colmNm = (String) colmItr.next();
			if (colmNm.startsWith("sum") || colmNm.startsWith("avg")) {
				columnList.add(colmNm);
			}
		}
		
		arrColmList = (String[]) columnList.toArray(arrColmList);
		mv.addObject("columnList", arrColmList);
		
		// 테이블 타이틀 조회
		param = new HashMap();

		if (MapUtils.getObject(rqstMap, "searchEntprsGrpVal") instanceof String[]) {		// 기업군조건(멀티셀렉트) 체크
			String[] entprsGrp = (String[]) MapUtils.getObject(rqstMap, "searchEntprsGrpVal");
			String tableTitle = "";
			
			for (int i=0; i<entprsGrp.length; i++) {
				param.put("codeGroupNo", "14");
				param.put("code", entprsGrp[i]);
				
				if (i < entprsGrp.length-1) 	tableTitle = tableTitle.concat((String) codeService.findCodeInfo(param).get("codeNm")).concat(", ");
				else tableTitle = tableTitle.concat((String) codeService.findCodeInfo(param).get("codeNm"));
			}
			mv.addObject("tableTitle", tableTitle);
			
		} else {
			param.put("codeGroupNo", "14");
			param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrpVal"));
			mv.addObject("tableTitle",codeService.findCodeInfo(param).get("codeNm"));
		}		
		
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
		
		param.put("stdyy", rqstMap.get("searchStdyy")); // 년도조건
		
		// 기업군조건(멀티셀렉트)
		if (MapUtils.getObject(rqstMap, "searchEntprsGrpVal") instanceof String[]) {
			param.put("entcls", MapUtils.getObject(rqstMap, "searchEntprsGrpVal"));			
		} else {
			param.put("entcls", new String[] {(String) MapUtils.getObject(rqstMap, "searchEntprsGrpVal")});
		}		
		
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
		// 지표조건
		param.put("index", MapUtils.getString(rqstMap, "searchIndex"));
		
		if (MapUtils.getObject(rqstMap, "searchIndexVal") instanceof String[]) {
			param.put("indexVal", MapUtils.getObject(rqstMap, "searchIndexVal"));
		} else {
			param.put("indexVal", new String[] {(String) MapUtils.getObject(rqstMap, "searchIndexVal")});
		}
		
		// 챠트출력여부
		if (!MapUtils.getString(rqstMap, "ad_chartY", "").equals("")) {
			param.put("chartY", MapUtils.getString(rqstMap, "ad_chartY"));
		}

		return entprsDAO.selectIndxStaticsDataList(param);
	}
	
	/**
	 * 구간별현황 DB 데이터 조회
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectSctnData(Map rqstMap) throws Exception {
		HashMap param = new HashMap();
		
		param.put("stdyy", rqstMap.get("searchStdyy")); // 년도조건
		
		// 기업군조건		
		param.put("entcls", MapUtils.getObject(rqstMap, "searchEntprsGrpVal"));			
		
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
		// 지표조건
		param.put("searchIndex", MapUtils.getString(rqstMap, "searchIndex"));		
		
		// 챠트출력여부
		if (!MapUtils.getString(rqstMap, "ad_chartY", "").equals("")) {
			param.put("chartY", MapUtils.getString(rqstMap, "ad_chartY"));
		}

		return entprsDAO.selectSctnStaticsDataList(param);
	}
	
	/**
	 * 주요지표현황 조회(가공처리)
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectIndxStaticsList(Map rqstMap) throws Exception {
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

		String areaFt = null;
		String indutyFt = null;
		String stdAreaFt = null;
		String stdIndutyFt = null;
		Map  resultInfo = null;
		Map prevInfo = null;
		LinkedHashMap sumMap = null;
		Iterator<String> colmItr = null;
		String colmNm = null;
		
		List<Map> rtnList = new ArrayList<Map>();	// 처리결과
		List<Map> dataList = new ArrayList<Map>();	// 데이터 임시
		List<Map> sumList = new ArrayList<Map>();	// 소계+데이터 임시


		// 제조/비제조/전산업 소계
		LinkedHashMap <String, BigDecimal> arrSum = new LinkedHashMap ();
		LinkedHashMap <String, BigDecimal> arrTotal = new LinkedHashMap ();
		
		resultInfo = resultList.get(0);

		if (MapUtils.getString(rqstMap, "searchIndex").equals("1")) {

			if (resultInfo.containsKey("sumEntrprsCo")) {
				arrSum.put("sumEntrprsCo", new BigDecimal(0));
				arrTotal.put("sumEntrprsCo", new BigDecimal(0));
			}
			if (resultInfo.containsKey("sumSelngAm")) {
				arrSum.put("sumSelngAm", new BigDecimal(0));
				arrTotal.put("sumSelngAm", new BigDecimal(0));
			}
			if (resultInfo.containsKey("sumBsnProfit")) {
				arrSum.put("sumBsnProfit", new BigDecimal(0));
				arrTotal.put("sumBsnProfit", new BigDecimal(0));
			}
			if (resultInfo.containsKey("sumBsnProfitRt")) {
				arrSum.put("sumBsnProfitRt", new BigDecimal(0));
				arrTotal.put("sumBsnProfitRt", new BigDecimal(0));
			}
			if (resultInfo.containsKey("sumXportAmDollar")) {
				arrSum.put("sumXportAmDollar", new BigDecimal(0));
				arrTotal.put("sumXportAmDollar", new BigDecimal(0));
			}
			if (resultInfo.containsKey("sumXportAmRt")) {
				arrSum.put("sumXportAmRt", new BigDecimal(0));
				arrTotal.put("sumXportAmRt", new BigDecimal(0));
			}
			if (resultInfo.containsKey("sumOrdtmLabrrCo")) {
				arrSum.put("sumOrdtmLabrrCo", new BigDecimal(0));
				arrTotal.put("sumOrdtmLabrrCo", new BigDecimal(0));
			}
			if (resultInfo.containsKey("sumRsrchDevlopRt")) {
				arrSum.put("sumRsrchDevlopRt", new BigDecimal(0));
				arrTotal.put("sumRsrchDevlopRt", new BigDecimal(0));
			}
			if (resultInfo.containsKey("sumThstrmNtpf")) {
				arrSum.put("sumThstrmNtpf", new BigDecimal(0));
				arrTotal.put("sumThstrmNtpf", new BigDecimal(0));
			}
		} else {
			
			if (resultInfo.containsKey("sumEntrprsCo")) {
				arrSum.put("sumEntrprsCo", new BigDecimal(0));
				arrTotal.put("sumEntrprsCo", new BigDecimal(0));
			}
			if (resultInfo.containsKey("avgSelngAm")) {
				arrSum.put("avgSelngAm", new BigDecimal(0));
				arrTotal.put("avgSelngAm", new BigDecimal(0));
			}
			if (resultInfo.containsKey("avgBsnProfit")) {
				arrSum.put("avgBsnProfit", new BigDecimal(0));
				arrTotal.put("avgBsnProfit", new BigDecimal(0));
			}
			if (resultInfo.containsKey("avgBsnProfitRt")) {
				arrSum.put("avgBsnProfitRt", new BigDecimal(0));
				arrTotal.put("avgBsnProfitRt", new BigDecimal(0));
			}
			if (resultInfo.containsKey("avgXportAmDollar")) {
				arrSum.put("avgXportAmDollar", new BigDecimal(0));
				arrTotal.put("avgXportAmDollar", new BigDecimal(0));
			}
			if (resultInfo.containsKey("avgXportAmRt")) {
				arrSum.put("avgXportAmRt", new BigDecimal(0));
				arrTotal.put("avgXportAmRt", new BigDecimal(0));
			}
			if (resultInfo.containsKey("avgOrdtmLabrrCo")) {
				arrSum.put("avgOrdtmLabrrCo", new BigDecimal(0));
				arrTotal.put("avgOrdtmLabrrCo", new BigDecimal(0));
			}
			if (resultInfo.containsKey("avgRsrchDevlopRt")) {
				arrSum.put("avgRsrchDevlopRt", new BigDecimal(0));
				arrTotal.put("avgRsrchDevlopRt", new BigDecimal(0));
			}
			if (resultInfo.containsKey("avgThstrmNtpfRt")) {
				arrSum.put("avgThstrmNtpfRt", new BigDecimal(0));
				arrTotal.put("avgThstrmNtpfRt", new BigDecimal(0));
			}
			if (resultInfo.containsKey("avgCorage")) {
				arrSum.put("avgCorage", new BigDecimal(0));
				arrTotal.put("avgCorage", new BigDecimal(0));
			}
		}
		
		for (int i=0; i<resultList.size(); i++) {
			resultInfo = (Map) resultList.get(i);

			// 제조/비제조별 합계
			if (cndInduty) {

				// 업종
				indutyFt = (String) resultInfo.get("indutySe");
				// 지역
				areaFt = (String) resultInfo.get("areaCode");
				
				if (stdIndutyFt == null) stdIndutyFt = indutyFt;
				if (stdAreaFt == null) stdAreaFt = areaFt;
				
				if (!stdIndutyFt.equals(indutyFt) || cndArea && !stdAreaFt.equals(areaFt)) {

					stdIndutyFt = indutyFt;
					
					prevInfo = resultList.get(i-1);
					
					// 제조/비제조 소계
					sumMap = new LinkedHashMap();
					sumMap.put("gbnAs", prevInfo.get("gbnAs"));
					sumMap.put("gbnIs", "S");
					
					colmItr = arrSum.keySet().iterator();
					while(colmItr.hasNext()) {
						colmNm = colmItr.next();
						sumMap.put(colmNm, arrSum.get(colmNm));
					}
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
					
					colmItr = arrSum.keySet().iterator();
					while(colmItr.hasNext()) {
						colmNm = colmItr.next();
						arrSum.put(colmNm, new BigDecimal(0));
					}
				}


				if (cndArea && !stdAreaFt.equals(areaFt)) {
					stdAreaFt = areaFt;
					
					prevInfo = resultList.get(i-1);
					
					sumMap = new LinkedHashMap();
					sumMap.put("gbnAs", prevInfo.get("gbnAs"));
					sumMap.put("gbnIs", "S");
					
					colmItr = arrTotal.keySet().iterator();
					while(colmItr.hasNext()) {
						colmNm = colmItr.next();
						sumMap.put(colmNm, arrTotal.get(colmNm));
					}
					sumMap.put("indutySeNm", "전산업");
					sumMap.put("dtlclfcNm", "전산업");
					sumMap.put("indutyNm", "전산업");
					sumMap.put("upperNm", prevInfo.get("upperNm"));
					sumMap.put("abrv", prevInfo.get("abrv"));
					
					rtnList.add(sumMap);
					if (sumList.size() > 0) rtnList.addAll(sumList);
					
					sumList = new ArrayList<Map>();
					
					colmItr = arrTotal.keySet().iterator();
					while(colmItr.hasNext()) {
						colmNm = colmItr.next();
						arrTotal.put(colmNm, new BigDecimal(0));
					}
				}
				
				colmItr = arrTotal.keySet().iterator();
				while(colmItr.hasNext()) {
					colmNm = colmItr.next();
					// 제조/비제조 합계
					arrSum.put(colmNm, arrSum.get(colmNm).add((BigDecimal) resultInfo.get(colmNm)));
					// 지역별 전산업 합계
					arrTotal.put(colmNm, arrTotal.get(colmNm).add((BigDecimal) resultInfo.get(colmNm)));
				}
			}
			
			// 임시목록에 레코드 추가
			dataList.add(resultInfo);
		}
		
		// ### 마지막 레코드 처리 ###
		if (cndInduty) {
			
			if (!MapUtils.getString(rqstMap, "searchInduty").equals("1")) {
				// 1. 제조/비제조 소계
				sumMap = new LinkedHashMap();
				sumMap.put("gbnAs", resultInfo.get("gbnAs"));
				sumMap.put("gbnIs", "S");
				
				colmItr = arrSum.keySet().iterator();
				while(colmItr.hasNext()) {
					colmNm = colmItr.next();
					sumMap.put(colmNm, arrSum.get(colmNm));
				}
				sumMap.put("indutySeNm", resultInfo.get("indutySeNm"));
				sumMap.put("dtlclfcNm", resultInfo.get("indutySeNm"));
				sumMap.put("indutyNm", resultInfo.get("indutySeNm"));
				sumMap.put("upperNm", resultInfo.get("upperNm"));
				sumMap.put("abrv", resultInfo.get("abrv"));
				
				sumList.add(sumMap);
			}
			
			// 2. 전업종 합계
			sumMap = new LinkedHashMap();
			sumMap.put("gbnAs", resultInfo.get("gbnAs"));
			sumMap.put("gbnIs", "S");
			
			colmItr = arrTotal.keySet().iterator();
			while(colmItr.hasNext()) {
				colmNm = colmItr.next();
				sumMap.put(colmNm, arrTotal.get(colmNm));
			}
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
	 * 구간별현황 데이터 가공처리
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectStaticsLisSctn(Map rqstMap) throws Exception {
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
		
		List<Map> resultList = selectSctnData(rqstMap);
		
		if (resultList == null || resultList.size() <= 0) return null;

		// 제조/비제조 소계
		BigDecimal sctn1 = new BigDecimal(0);
		BigDecimal sctn2 = new BigDecimal(0);
		BigDecimal sctn3 = new BigDecimal(0);
		BigDecimal sctn4 = new BigDecimal(0);
		BigDecimal sctn5 = new BigDecimal(0);
		BigDecimal sctn6 = new BigDecimal(0);
		BigDecimal sctn7 = new BigDecimal(0);
		BigDecimal sctn8 = new BigDecimal(0);
		BigDecimal sctnSum = new BigDecimal(0);		
		
		// 전산업
		BigDecimal totalSctn1 = new BigDecimal(0);
		BigDecimal totalSctn2 = new BigDecimal(0);
		BigDecimal totalSctn3 = new BigDecimal(0);
		BigDecimal totalSctn4 = new BigDecimal(0);
		BigDecimal totalSctn5 = new BigDecimal(0);
		BigDecimal totalSctn6 = new BigDecimal(0);
		BigDecimal totalSctn7 = new BigDecimal(0);
		BigDecimal totalSctn8 = new BigDecimal(0);
		BigDecimal totalSctnSum = new BigDecimal(0);		
		
		String searchIndex = (String) rqstMap.get("searchIndex");			
		
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
				areaFt = (String) resultInfo.get("areaCode");
				
				if (stdIndutyFt == null) stdIndutyFt = indutyFt;
				if (stdAreaFt == null) stdAreaFt = areaFt;
				
				if (!stdIndutyFt.equals(indutyFt) || cndArea && !stdAreaFt.equals(areaFt)) {

					stdIndutyFt = indutyFt;
					
					prevInfo = resultList.get(i-1);
					
					// 제조/비제조 소계
					sumMap = new HashMap();
					sumMap.put("gbnAs", prevInfo.get("gbnAs"));
					sumMap.put("gbnIs", "S");
					
					if(searchIndex.equals("A")) {
						sumMap.put("sctn1", sctn1);
						sumMap.put("sctn2", sctn2);
						sumMap.put("sctn3", sctn3);
						sumMap.put("sctn4", sctn4);
						sumMap.put("sctn5", sctn5);
						sumMap.put("sctn6", sctn6);
						sumMap.put("sctn7", sctn7);						
						sumMap.put("sctnSum", sctnSum);
					}else if(searchIndex.equals("B")) {
						sumMap.put("sctn1", sctn1);
						sumMap.put("sctn2", sctn2);
						sumMap.put("sctn3", sctn3);
						sumMap.put("sctn4", sctn4);
						sumMap.put("sctn5", sctn5);
						sumMap.put("sctn6", sctn6);
						sumMap.put("sctn7", sctn7);
						sumMap.put("sctn8", sctn8);
						sumMap.put("sctnSum", sctnSum);
					}else if(searchIndex.equals("C")) {
						sumMap.put("sctn1", sctn1);
						sumMap.put("sctn2", sctn2);
						sumMap.put("sctn3", sctn3);
						sumMap.put("sctn4", sctn4);
						sumMap.put("sctn5", sctn5);
						sumMap.put("sctn6", sctn6);
						sumMap.put("sctn7", sctn7);
						sumMap.put("sctn8", sctn8);
						sumMap.put("sctnSum", sctnSum);
					}else if(searchIndex.equals("D")) {
						sumMap.put("sctn1", sctn1);
						sumMap.put("sctn2", sctn2);
						sumMap.put("sctn3", sctn3);
						sumMap.put("sctn4", sctn4);
						sumMap.put("sctn5", sctn5);
						sumMap.put("sctn6", sctn6);						
						sumMap.put("sctnSum", sctnSum);
					}else if(searchIndex.equals("E")) {
						sumMap.put("sctn1", sctn1);
						sumMap.put("sctn2", sctn2);
						sumMap.put("sctn3", sctn3);
						sumMap.put("sctn4", sctn4);
						sumMap.put("sctn5", sctn5);
						sumMap.put("sctn6", sctn6);						
						sumMap.put("sctnSum", sctnSum);
					}else if(searchIndex.equals("F")) {
						sumMap.put("sctn1", sctn1);
						sumMap.put("sctn2", sctn2);
						sumMap.put("sctn3", sctn3);
						sumMap.put("sctn4", sctn4);
						sumMap.put("sctn5", sctn5);
						sumMap.put("sctn6", sctn6);
						sumMap.put("sctn7", sctn7);
						sumMap.put("sctn8", sctn8);
						sumMap.put("sctnSum", sctnSum);						
					}
					
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
					
					sctn1 = new BigDecimal(0);    
					sctn2 = new BigDecimal(0);    
					sctn3 = new BigDecimal(0);    
					sctn4 = new BigDecimal(0);    
					sctn5 = new BigDecimal(0);    
					sctn6 = new BigDecimal(0);    
					sctn7 = new BigDecimal(0);    
					sctn8 = new BigDecimal(0);    
					sctnSum = new BigDecimal(0);  
									
				}


				if (cndArea && !stdAreaFt.equals(areaFt)) {
					stdAreaFt = areaFt;
					
					prevInfo = resultList.get(i-1);
					
					sumMap = new HashMap();
					sumMap.put("gbnAs", prevInfo.get("gbnAs"));
					sumMap.put("gbnIs", "S");
					
					if(searchIndex.equals("A")) {
						sumMap.put("sctn1", totalSctn1);
						sumMap.put("sctn2", totalSctn2);
						sumMap.put("sctn3", totalSctn3);
						sumMap.put("sctn4", totalSctn4);
						sumMap.put("sctn5", totalSctn5);
						sumMap.put("sctn6", totalSctn6);
						sumMap.put("sctn7", totalSctn7);						
						sumMap.put("sctnSum", totalSctnSum);
					}else if(searchIndex.equals("B")) {
						sumMap.put("sctn1", totalSctn1);
						sumMap.put("sctn2", totalSctn2);
						sumMap.put("sctn3", totalSctn3);
						sumMap.put("sctn4", totalSctn4);
						sumMap.put("sctn5", totalSctn5);
						sumMap.put("sctn6", totalSctn6);
						sumMap.put("sctn7", totalSctn7);
						sumMap.put("sctn8", totalSctn8);
						sumMap.put("sctnSum", totalSctnSum);
					}else if(searchIndex.equals("C")) {
						sumMap.put("sctn1", totalSctn1);
						sumMap.put("sctn2", totalSctn2);
						sumMap.put("sctn3", totalSctn3);
						sumMap.put("sctn4", totalSctn4);
						sumMap.put("sctn5", totalSctn5);
						sumMap.put("sctn6", totalSctn6);
						sumMap.put("sctn7", totalSctn7);
						sumMap.put("sctn8", totalSctn8);
						sumMap.put("sctnSum", totalSctnSum);
					}else if(searchIndex.equals("D")) {
						sumMap.put("sctn1", totalSctn1);
						sumMap.put("sctn2", totalSctn2);
						sumMap.put("sctn3", totalSctn3);
						sumMap.put("sctn4", totalSctn4);
						sumMap.put("sctn5", totalSctn5);
						sumMap.put("sctn6", totalSctn6);
						sumMap.put("sctnSum", totalSctnSum);
					}else if(searchIndex.equals("E")) {
						sumMap.put("sctn1", totalSctn1);
						sumMap.put("sctn2", totalSctn2);
						sumMap.put("sctn3", totalSctn3);
						sumMap.put("sctn4", totalSctn4);
						sumMap.put("sctn5", totalSctn5);
						sumMap.put("sctn6", totalSctn6);
						sumMap.put("sctnSum", totalSctnSum);
					}else if(searchIndex.equals("F")) {
						sumMap.put("sctn1", totalSctn1);
						sumMap.put("sctn2", totalSctn2);
						sumMap.put("sctn3", totalSctn3);
						sumMap.put("sctn4", totalSctn4);
						sumMap.put("sctn5", totalSctn5);
						sumMap.put("sctn6", totalSctn6);
						sumMap.put("sctn7", totalSctn7);
						sumMap.put("sctn8", totalSctn8);
						sumMap.put("sctnSum", totalSctnSum);												
					}
					
					sumMap.put("resnNm", prevInfo.get("resnNm"));
					sumMap.put("indutySeNm", "전산업");
					sumMap.put("dtlclfcNm", "전산업");
					sumMap.put("indutyNm", "전산업");
					sumMap.put("upperNm", prevInfo.get("upperNm"));
					sumMap.put("abrv", prevInfo.get("abrv"));
					
					rtnList.add(sumMap);
					if (sumList.size() > 0) rtnList.addAll(sumList);
					
					sumList = new ArrayList<Map>();
					
					totalSctn1 = new BigDecimal(0);    
					totalSctn2 = new BigDecimal(0);    
					totalSctn3 = new BigDecimal(0);    
					totalSctn4 = new BigDecimal(0);    
					totalSctn5 = new BigDecimal(0);    
					totalSctn6 = new BigDecimal(0);    
					totalSctn7 = new BigDecimal(0);    
					totalSctn8 = new BigDecimal(0);    
					totalSctnSum = new BigDecimal(0);  					
				}
				
				if(searchIndex.equals("A")) {
					// 제조/비제조 합계
					sctn1 = sctn1.add((BigDecimal) resultInfo.get("sctn1"));
					sctn2 = sctn2.add((BigDecimal) resultInfo.get("sctn2"));
					sctn3 = sctn3.add((BigDecimal) resultInfo.get("sctn3"));
					sctn4 = sctn4.add((BigDecimal) resultInfo.get("sctn4"));
					sctn5 = sctn5.add((BigDecimal) resultInfo.get("sctn5"));
					sctn6 = sctn6.add((BigDecimal) resultInfo.get("sctn6"));
					sctn7 = sctn7.add((BigDecimal) resultInfo.get("sctn7"));					
					sctnSum = sctnSum.add((BigDecimal) resultInfo.get("sctnSum"));
					
					// 지역별 전산업 합계
					totalSctn1 = totalSctn1.add((BigDecimal) resultInfo.get("sctn1"));
					totalSctn2 = totalSctn2.add((BigDecimal) resultInfo.get("sctn2"));
					totalSctn3 = totalSctn3.add((BigDecimal) resultInfo.get("sctn3"));
					totalSctn4 = totalSctn4.add((BigDecimal) resultInfo.get("sctn4"));
					totalSctn5 = totalSctn5.add((BigDecimal) resultInfo.get("sctn5"));
					totalSctn6 = totalSctn6.add((BigDecimal) resultInfo.get("sctn6"));
					totalSctn7 = totalSctn7.add((BigDecimal) resultInfo.get("sctn7"));					
					totalSctnSum = totalSctnSum.add((BigDecimal) resultInfo.get("sctnSum"));
				}else if(searchIndex.equals("B")) {
					// 제조/비제조 합계
					sctn1 = sctn1.add((BigDecimal) resultInfo.get("sctn1"));
					sctn2 = sctn2.add((BigDecimal) resultInfo.get("sctn2"));
					sctn3 = sctn3.add((BigDecimal) resultInfo.get("sctn3"));
					sctn4 = sctn4.add((BigDecimal) resultInfo.get("sctn4"));
					sctn5 = sctn5.add((BigDecimal) resultInfo.get("sctn5"));
					sctn6 = sctn6.add((BigDecimal) resultInfo.get("sctn6"));
					sctn7 = sctn7.add((BigDecimal) resultInfo.get("sctn7"));
					sctn8 = sctn8.add((BigDecimal) resultInfo.get("sctn8"));
					sctnSum = sctnSum.add((BigDecimal) resultInfo.get("sctnSum"));
					
					// 지역별 전산업 합계
					totalSctn1 = totalSctn1.add((BigDecimal) resultInfo.get("sctn1"));
					totalSctn2 = totalSctn2.add((BigDecimal) resultInfo.get("sctn2"));
					totalSctn3 = totalSctn3.add((BigDecimal) resultInfo.get("sctn3"));
					totalSctn4 = totalSctn4.add((BigDecimal) resultInfo.get("sctn4"));
					totalSctn5 = totalSctn5.add((BigDecimal) resultInfo.get("sctn5"));
					totalSctn6 = totalSctn6.add((BigDecimal) resultInfo.get("sctn6"));
					totalSctn7 = totalSctn7.add((BigDecimal) resultInfo.get("sctn7"));
					totalSctn8 = totalSctn8.add((BigDecimal) resultInfo.get("sctn8"));
					totalSctnSum = totalSctnSum.add((BigDecimal) resultInfo.get("sctnSum"));
				}else if(searchIndex.equals("C")) {
					// 제조/비제조 합계
					sctn1 = sctn1.add((BigDecimal) resultInfo.get("sctn1"));
					sctn2 = sctn2.add((BigDecimal) resultInfo.get("sctn2"));
					sctn3 = sctn3.add((BigDecimal) resultInfo.get("sctn3"));
					sctn4 = sctn4.add((BigDecimal) resultInfo.get("sctn4"));
					sctn5 = sctn5.add((BigDecimal) resultInfo.get("sctn5"));
					sctn6 = sctn6.add((BigDecimal) resultInfo.get("sctn6"));
					sctn7 = sctn7.add((BigDecimal) resultInfo.get("sctn7"));
					sctn8 = sctn8.add((BigDecimal) resultInfo.get("sctn8"));
					sctnSum = sctnSum.add((BigDecimal) resultInfo.get("sctnSum"));
					
					// 지역별 전산업 합계
					totalSctn1 = totalSctn1.add((BigDecimal) resultInfo.get("sctn1"));
					totalSctn2 = totalSctn2.add((BigDecimal) resultInfo.get("sctn2"));
					totalSctn3 = totalSctn3.add((BigDecimal) resultInfo.get("sctn3"));
					totalSctn4 = totalSctn4.add((BigDecimal) resultInfo.get("sctn4"));
					totalSctn5 = totalSctn5.add((BigDecimal) resultInfo.get("sctn5"));
					totalSctn6 = totalSctn6.add((BigDecimal) resultInfo.get("sctn6"));
					totalSctn7 = totalSctn7.add((BigDecimal) resultInfo.get("sctn7"));
					totalSctn8 = totalSctn8.add((BigDecimal) resultInfo.get("sctn8"));
					totalSctnSum = totalSctnSum.add((BigDecimal) resultInfo.get("sctnSum"));
				}else if(searchIndex.equals("D")) {
					// 제조/비제조 합계
					sctn1 = sctn1.add((BigDecimal) resultInfo.get("sctn1"));
					sctn2 = sctn2.add((BigDecimal) resultInfo.get("sctn2"));
					sctn3 = sctn3.add((BigDecimal) resultInfo.get("sctn3"));
					sctn4 = sctn4.add((BigDecimal) resultInfo.get("sctn4"));
					sctn5 = sctn5.add((BigDecimal) resultInfo.get("sctn5"));
					sctn6 = sctn6.add((BigDecimal) resultInfo.get("sctn6"));					
					sctnSum = sctnSum.add((BigDecimal) resultInfo.get("sctnSum"));
					
					// 지역별 전산업 합계
					totalSctn1 = totalSctn1.add((BigDecimal) resultInfo.get("sctn1"));
					totalSctn2 = totalSctn2.add((BigDecimal) resultInfo.get("sctn2"));
					totalSctn3 = totalSctn3.add((BigDecimal) resultInfo.get("sctn3"));
					totalSctn4 = totalSctn4.add((BigDecimal) resultInfo.get("sctn4"));
					totalSctn5 = totalSctn5.add((BigDecimal) resultInfo.get("sctn5"));
					totalSctn6 = totalSctn6.add((BigDecimal) resultInfo.get("sctn6"));					
					totalSctnSum = totalSctnSum.add((BigDecimal) resultInfo.get("sctnSum"));
				}else if(searchIndex.equals("E")) {
					// 제조/비제조 합계
					sctn1 = sctn1.add((BigDecimal) resultInfo.get("sctn1"));
					sctn2 = sctn2.add((BigDecimal) resultInfo.get("sctn2"));
					sctn3 = sctn3.add((BigDecimal) resultInfo.get("sctn3"));
					sctn4 = sctn4.add((BigDecimal) resultInfo.get("sctn4"));
					sctn5 = sctn5.add((BigDecimal) resultInfo.get("sctn5"));
					sctn6 = sctn6.add((BigDecimal) resultInfo.get("sctn6"));					
					sctnSum = sctnSum.add((BigDecimal) resultInfo.get("sctnSum"));
					
					// 지역별 전산업 합계
					totalSctn1 = totalSctn1.add((BigDecimal) resultInfo.get("sctn1"));
					totalSctn2 = totalSctn2.add((BigDecimal) resultInfo.get("sctn2"));
					totalSctn3 = totalSctn3.add((BigDecimal) resultInfo.get("sctn3"));
					totalSctn4 = totalSctn4.add((BigDecimal) resultInfo.get("sctn4"));
					totalSctn5 = totalSctn5.add((BigDecimal) resultInfo.get("sctn5"));
					totalSctn6 = totalSctn6.add((BigDecimal) resultInfo.get("sctn6"));					
					totalSctnSum = totalSctnSum.add((BigDecimal) resultInfo.get("sctnSum"));
				}else if(searchIndex.equals("F")) {
					// 제조/비제조 합계
					sctn1 = sctn1.add((BigDecimal) resultInfo.get("sctn1"));
					sctn2 = sctn2.add((BigDecimal) resultInfo.get("sctn2"));
					sctn3 = sctn3.add((BigDecimal) resultInfo.get("sctn3"));
					sctn4 = sctn4.add((BigDecimal) resultInfo.get("sctn4"));
					sctn5 = sctn5.add((BigDecimal) resultInfo.get("sctn5"));
					sctn6 = sctn6.add((BigDecimal) resultInfo.get("sctn6"));
					sctn7 = sctn7.add((BigDecimal) resultInfo.get("sctn7"));
					sctn8 = sctn8.add((BigDecimal) resultInfo.get("sctn8"));
					sctnSum = sctnSum.add((BigDecimal) resultInfo.get("sctnSum"));
					
					// 지역별 전산업 합계
					totalSctn1 = totalSctn1.add((BigDecimal) resultInfo.get("sctn1"));
					totalSctn2 = totalSctn2.add((BigDecimal) resultInfo.get("sctn2"));
					totalSctn3 = totalSctn3.add((BigDecimal) resultInfo.get("sctn3"));
					totalSctn4 = totalSctn4.add((BigDecimal) resultInfo.get("sctn4"));
					totalSctn5 = totalSctn5.add((BigDecimal) resultInfo.get("sctn5"));
					totalSctn6 = totalSctn6.add((BigDecimal) resultInfo.get("sctn6"));
					totalSctn7 = totalSctn7.add((BigDecimal) resultInfo.get("sctn7"));
					totalSctn8 = totalSctn8.add((BigDecimal) resultInfo.get("sctn8"));
					totalSctnSum = totalSctnSum.add((BigDecimal) resultInfo.get("sctnSum"));					
				}				
								
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
				
				if(searchIndex.equals("A")) {
					sumMap.put("sctn1", sctn1);
					sumMap.put("sctn2", sctn2);
					sumMap.put("sctn3", sctn3);
					sumMap.put("sctn4", sctn4);
					sumMap.put("sctn5", sctn5);
					sumMap.put("sctn6", sctn6);
					sumMap.put("sctn7", sctn7);						
					sumMap.put("sctnSum", sctnSum);
				}else if(searchIndex.equals("B")) {
					sumMap.put("sctn1", sctn1);
					sumMap.put("sctn2", sctn2);
					sumMap.put("sctn3", sctn3);
					sumMap.put("sctn4", sctn4);
					sumMap.put("sctn5", sctn5);
					sumMap.put("sctn6", sctn6);
					sumMap.put("sctn7", sctn7);
					sumMap.put("sctn8", sctn8);
					sumMap.put("sctnSum", sctnSum);
				}else if(searchIndex.equals("C")) {
					sumMap.put("sctn1", sctn1);
					sumMap.put("sctn2", sctn2);
					sumMap.put("sctn3", sctn3);
					sumMap.put("sctn4", sctn4);
					sumMap.put("sctn5", sctn5);
					sumMap.put("sctn6", sctn6);
					sumMap.put("sctn7", sctn7);
					sumMap.put("sctn8", sctn8);
					sumMap.put("sctnSum", sctnSum);
				}else if(searchIndex.equals("D")) {
					sumMap.put("sctn1", sctn1);
					sumMap.put("sctn2", sctn2);
					sumMap.put("sctn3", sctn3);
					sumMap.put("sctn4", sctn4);
					sumMap.put("sctn5", sctn5);
					sumMap.put("sctn6", sctn6);						
					sumMap.put("sctnSum", sctnSum);
				}else if(searchIndex.equals("E")) {
					sumMap.put("sctn1", sctn1);
					sumMap.put("sctn2", sctn2);
					sumMap.put("sctn3", sctn3);
					sumMap.put("sctn4", sctn4);
					sumMap.put("sctn5", sctn5);
					sumMap.put("sctn6", sctn6);						
					sumMap.put("sctnSum", sctnSum);
				}else if(searchIndex.equals("F")) {
					sumMap.put("sctn1", sctn1);
					sumMap.put("sctn2", sctn2);
					sumMap.put("sctn3", sctn3);
					sumMap.put("sctn4", sctn4);
					sumMap.put("sctn5", sctn5);
					sumMap.put("sctn6", sctn6);
					sumMap.put("sctn7", sctn7);
					sumMap.put("sctn8", sctn8);
					sumMap.put("sctnSum", sctnSum);						
				}								
				
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
			
			if(searchIndex.equals("A")) {
				sumMap.put("sctn1", totalSctn1);
				sumMap.put("sctn2", totalSctn2);
				sumMap.put("sctn3", totalSctn3);
				sumMap.put("sctn4", totalSctn4);
				sumMap.put("sctn5", totalSctn5);
				sumMap.put("sctn6", totalSctn6);
				sumMap.put("sctn7", totalSctn7);						
				sumMap.put("sctnSum", totalSctnSum);
			}else if(searchIndex.equals("B")) {
				sumMap.put("sctn1", totalSctn1);
				sumMap.put("sctn2", totalSctn2);
				sumMap.put("sctn3", totalSctn3);
				sumMap.put("sctn4", totalSctn4);
				sumMap.put("sctn5", totalSctn5);
				sumMap.put("sctn6", totalSctn6);
				sumMap.put("sctn7", totalSctn7);
				sumMap.put("sctn8", totalSctn8);
				sumMap.put("sctnSum", totalSctnSum);
			}else if(searchIndex.equals("C")) {
				sumMap.put("sctn1", totalSctn1);
				sumMap.put("sctn2", totalSctn2);
				sumMap.put("sctn3", totalSctn3);
				sumMap.put("sctn4", totalSctn4);
				sumMap.put("sctn5", totalSctn5);
				sumMap.put("sctn6", totalSctn6);
				sumMap.put("sctn7", totalSctn7);
				sumMap.put("sctn8", totalSctn8);
				sumMap.put("sctnSum", totalSctnSum);
			}else if(searchIndex.equals("D")) {
				sumMap.put("sctn1", totalSctn1);
				sumMap.put("sctn2", totalSctn2);
				sumMap.put("sctn3", totalSctn3);
				sumMap.put("sctn4", totalSctn4);
				sumMap.put("sctn5", totalSctn5);
				sumMap.put("sctn6", totalSctn6);
				sumMap.put("sctnSum", totalSctnSum);
			}else if(searchIndex.equals("E")) {
				sumMap.put("sctn1", totalSctn1);
				sumMap.put("sctn2", totalSctn2);
				sumMap.put("sctn3", totalSctn3);
				sumMap.put("sctn4", totalSctn4);
				sumMap.put("sctn5", totalSctn5);
				sumMap.put("sctn6", totalSctn6);
				sumMap.put("sctnSum", totalSctnSum);
			}else if(searchIndex.equals("F")) {
				sumMap.put("sctn1", totalSctn1);
				sumMap.put("sctn2", totalSctn2);
				sumMap.put("sctn3", totalSctn3);
				sumMap.put("sctn4", totalSctn4);
				sumMap.put("sctn5", totalSctn5);
				sumMap.put("sctn6", totalSctn6);
				sumMap.put("sctn7", totalSctn7);
				sumMap.put("sctn8", totalSctn8);
				sumMap.put("sctnSum", totalSctnSum);												
			}

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
	
	// 주요지표 현황 챠트 popup
	public ModelAndView getAllChart(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();

		mv.setViewName("/admin/ps/PD_UIPSA0020_1");

		HashMap param = new HashMap();
		
		// 검색조건 년도목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		mv.addObject("stdyyList", stdyyList);

		// 초기검색조건 설정
		if (!rqstMap.containsKey("searchEntprsGrp")) rqstMap.put("searchEntprsGrp", "EA1");
		if (!rqstMap.containsKey("searchStdyy")) rqstMap.put("searchStdyy", stdyyList.get(0).get("stdyy"));
		
		// 초기조회지표 설정
		ArrayList<String> indexVal = new ArrayList();
		if (!rqstMap.containsKey("searchIndex")) {
			rqstMap.put("searchIndex", "1");
			List<CodeVO> indexList = codeService.findCodesByGroupNo("64");

			for (CodeVO code: indexList) {
				indexVal.add(code.getCode());
			}
			String[] arrIndexVal = new String[] {};
			arrIndexVal = indexVal.toArray(arrIndexVal);
			rqstMap.put("searchIndexVal", arrIndexVal);
		}
		
		// 지역별
		String searchAreaVal = null;
		if (rqstMap.containsKey("searchAreaVal")) searchAreaVal = (String) rqstMap.get("searchAreaVal");
		// 업무별
		String searchIndutyVal = null;
		if (rqstMap.containsKey("searchIndutyVal")) searchIndutyVal = (String) rqstMap.get("searchIndutyVal");
		// 지표
		String searchIndexVal = null;
		if (rqstMap.containsKey("searchIndexVal")) searchIndexVal = (String) rqstMap.get("searchIndexVal");
		// 기업군
		String searchEntprsGrpVal = null;
		if (rqstMap.containsKey("searchEntprsGrpVal")) searchEntprsGrpVal = (String) rqstMap.get("searchEntprsGrpVal");
		
		String[] array_searchAreaVal = searchAreaVal.split(",");
		String[] array_searchIndutyVal = searchIndutyVal.split(",");
		String[] array_searchIndexVal = searchIndexVal.split(",");
		String[] array_searchEntprsGrpVal = searchEntprsGrpVal.split(",");
		
		rqstMap.put("searchAreaVal", array_searchAreaVal);
		rqstMap.put("searchIndutyVal", array_searchIndutyVal);
		rqstMap.put("searchIndexVal", array_searchIndexVal);
		rqstMap.put("searchEntprsGrpVal", array_searchEntprsGrpVal);
		
		String searchArea = MapUtils.getString(rqstMap, "searchArea");
		String searchInduty = MapUtils.getString(rqstMap, "searchInduty");
		String searchIndex = MapUtils.getString(rqstMap, "searchIndex");
		String searchStdyy = MapUtils.getString(rqstMap, "searchStdyy");
		
		
		List<Map> resultList = selectStaticsData(rqstMap);
		// 지역별 챠트 쿼리
		rqstMap.put("ad_chartY", "area");
		List<Map> areaResultList = selectStaticsData(rqstMap);
		// 업무별 챠트 쿼리
		rqstMap.put("ad_chartY", "induty");
		List<Map> indutyResultList = selectStaticsData(rqstMap);
		
		// 테이블 타이틀 조회
		param = new HashMap();

		if (MapUtils.getObject(rqstMap, "searchEntprsGrpVal") instanceof String[]) {		// 기업군조건(멀티셀렉트) 체크
			String[] entprsGrp = (String[]) MapUtils.getObject(rqstMap, "searchEntprsGrpVal");
			String tableTitle = "";
			
			for (int i=0; i<entprsGrp.length; i++) {
				param.put("codeGroupNo", "14");
				param.put("code", entprsGrp[i]);
				
				if (i < entprsGrp.length-1) 	tableTitle = tableTitle.concat((String) codeService.findCodeInfo(param).get("codeNm")).concat(", ");
				else tableTitle = tableTitle.concat((String) codeService.findCodeInfo(param).get("codeNm"));
			}
			mv.addObject("tableTitle", tableTitle);
			
		} else {
			param.put("codeGroupNo", "14");
			param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrpVal"));
			mv.addObject("tableTitle",codeService.findCodeInfo(param).get("codeNm"));
		}

		mv.addObject("searchIndexVal", array_searchIndexVal);
		mv.addObject("searchIndexVal_length", array_searchIndexVal.length);
		
		mv.addObject("searchEntprsGrpVal", array_searchEntprsGrpVal);
		
		mv.addObject("searchStdyy",searchStdyy);
		mv.addObject("searchArea",searchArea);
		mv.addObject("searchIndex",searchIndex);	
		
		mv.addObject("searchInduty",searchInduty);
		
		mv.addObject("resultList", resultList);
		mv.addObject("resultListCnt", resultList.size());
		mv.addObject("areaResultList", areaResultList);
		mv.addObject("areaListCnt", areaResultList.size());
		mv.addObject("indutyResultList", indutyResultList);
		mv.addObject("indutyListCnt", indutyResultList.size());
		
		return mv;
	}
	
	
	// 주요지표 구간별 현황 챠트 popup
	public ModelAndView getAllChart2(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/ps/PD_UIPSA0021_1");	
		
		HashMap param = new HashMap();

		mv.addObject("searchIndex", rqstMap.get("searchIndex"));		
		
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
		
		// 지역별 챠트 쿼리
		rqstMap.put("ad_chartY", "area");
		List<Map> areaResultList = selectSctnData(rqstMap);
		// 업무별 챠트 쿼리
		rqstMap.put("ad_chartY", "induty");
		List<Map> indutyResultList = selectSctnData(rqstMap);
		
		mv.addObject("areaResultList", areaResultList);
		mv.addObject("areaListCnt", areaResultList.size());
		mv.addObject("indutyResultList", indutyResultList);
		mv.addObject("indutyListCnt", indutyResultList.size());
		
		param = new HashMap();
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrpVal"));
		mv.addObject("tableTitle",codeService.findCodeInfo(param).get("codeNm"));	
		
		return mv;
	}
	
	
	
	// 주요지표 추이 챠트 popup
	public ModelAndView getAllChart3(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/ps/PD_UIPSA0022_1");	
		
		HashMap param = new HashMap();

		// 검색기간 조건 설정
		int startYr = 2013;
		int endYr = 2013;
		// 검색기간 가져오기
		if (rqstMap.containsKey("searchStdyySt")) startYr = MapUtils.getIntValue(rqstMap, "searchStdyySt"); 
		if (rqstMap.containsKey("searchStdyyEd")) endYr = MapUtils.getIntValue(rqstMap, "searchStdyyEd");
		
		// 지역별
		String searchAreaVal = null;
		if (rqstMap.containsKey("searchAreaVal")) searchAreaVal = (String) rqstMap.get("searchAreaVal");
		// 업무별
		String searchIndutyVal = null;
		if (rqstMap.containsKey("searchIndutyVal")) searchIndutyVal = (String) rqstMap.get("searchIndutyVal");

		mv.addObject("searchIndex", rqstMap.get("searchIndex"));
		mv.addObject("searchIndexVal", rqstMap.get("searchIndexVal"));
		
		// 지표
		String searchIndexVal = null;
		if (rqstMap.containsKey("searchIndexVal")) searchIndexVal = (String) rqstMap.get("searchIndexVal");
		
		String[] array_searchAreaVal = searchAreaVal.split(",");
		String[] array_searchIndutyVal = searchIndutyVal.split(",");
		String[] array_searchIndexVal = searchIndexVal.split(",");
		
		rqstMap.put("searchAreaVal", array_searchAreaVal);
		rqstMap.put("searchIndutyVal", array_searchIndutyVal);
		rqstMap.put("searchIndexVal", array_searchIndexVal);
				
		List<Map> resultList = new ArrayList();
		int idx = 0;
		int pos = 0;
		ArrayList<String> columnList = new ArrayList();
		
		for (int i=startYr; i<=endYr; i++) {
			rqstMap.put("searchStdyy", String.valueOf(i));
									
			List<Map> idxList = selectStaticsData(rqstMap);
			
			if (resultList.size() == 0) {
				
				Map idxInfo = idxList.get(0);
				
				String[] arrColmList = new String[] {};
				
				Iterator colmItr = idxInfo.keySet().iterator();
				while (colmItr.hasNext()) {
					String colmNm = (String) colmItr.next();
					if (colmNm.startsWith("sum") || colmNm.startsWith("avg")) {
						columnList.add(colmNm);
					}
				}
				
				arrColmList = (String[]) columnList.toArray(arrColmList);
				mv.addObject("columnList", arrColmList);
				
				for (int j=0; j<idxList.size(); j++) {
					for(int k=0; k<columnList.size(); k++) {
						resultList.add(idxList.get(j));						
					}
				}
				
			}else {
				idx++;
				for (int j=0; j<idxList.size(); j++) {
					Map dataInfo = idxList.get(j);
					pos = j * columnList.size();
					for(int k=0; k<columnList.size(); k++) {
						Map resultInfo = resultList.get(pos+k);
						resultInfo.put("y"+idx+columnList.get(k), dataInfo.get(columnList.get(k)));
					}					
				}
			}						
		}
						
		mv.addObject("resultList", resultList);
		mv.addObject("resultListCnt", resultList.size());
		
		mv.addObject("searchIndexVal", array_searchIndexVal);
		mv.addObject("searchIndexVal_length", array_searchIndexVal.length);
		
		// 테이블 타이틀 조회
		param = new HashMap();
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrpVal"));
		mv.addObject("tableTitle",codeService.findCodeInfo(param).get("codeNm"));
		mv.addObject("stdyySt", startYr);
		mv.addObject("stdyyEd", endYr);	
		
		return mv;
	}
	
	// 주요지표 추이 챠트 popup
	public ModelAndView getAllChart4(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/ps/PD_UIPSA0023_1");	
		
		HashMap param = new HashMap();

		// 검색기간 조건 설정
		int startYr = 2013;
		int endYr = 2013;
	
		if (rqstMap.containsKey("searchStdyySt")) startYr = MapUtils.getIntValue(rqstMap, "searchStdyySt");
	
		if (rqstMap.containsKey("searchStdyyEd")) endYr = MapUtils.getIntValue(rqstMap, "searchStdyyEd");		

		// 지역별
		String searchAreaVal = null;
		if (rqstMap.containsKey("searchAreaVal")) searchAreaVal = (String) rqstMap.get("searchAreaVal");
		// 업무별
		String searchIndutyVal = null;
		if (rqstMap.containsKey("searchIndutyVal")) searchIndutyVal = (String) rqstMap.get("searchIndutyVal");

		mv.addObject("searchIndex", rqstMap.get("searchIndex"));
		
		String[] array_searchAreaVal = searchAreaVal.split(",");
		String[] array_searchIndutyVal = searchIndutyVal.split(",");
		
		rqstMap.put("searchAreaVal", array_searchAreaVal);
		rqstMap.put("searchIndutyVal", array_searchIndutyVal);
		
		List<Map> resultList = new ArrayList();
		int idx = 0;			
		int colmCnt = 0;
		
		for (int i=startYr; i<=endYr; i++) {
			rqstMap.put("searchStdyy", String.valueOf(i));
									
			List<Map> idxList = selectSctnData(rqstMap);
			
			if (resultList.size() == 0) {
				
				for (int j=0; j<idxList.size(); j++) {										
					Map idxInfo = idxList.get(j);
					
					if(rqstMap.get("searchIndex").equals("A")) {
						colmCnt = 8;
					}else if(rqstMap.get("searchIndex").equals("B")) {						
						colmCnt = 9;
					}else if(rqstMap.get("searchIndex").equals("C")) {						
						colmCnt = 9;
					}else if(rqstMap.get("searchIndex").equals("D")) {						
						colmCnt = 7;
					}else if(rqstMap.get("searchIndex").equals("E")) {						
						colmCnt = 7;
					}else if(rqstMap.get("searchIndex").equals("F")) {						
						colmCnt = 9;			
					}
					for(int k=0; k<colmCnt; k++) {
						resultList.add(idxInfo);
						logger.debug("@@ idxInfo : " + idxInfo);
					}
										
				}
				
			}else {				
				idx++;
				for (int j=0; j<idxList.size(); j++) {
					Map dataInfo = idxList.get(j);
					int pos = j * colmCnt;

					if(rqstMap.get("searchIndex").equals("A")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));
						resultList.get(pos+6).put("y"+idx+"sctn7", dataInfo.get("sctn7"));						
						resultList.get(pos+7).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));
					}else if(rqstMap.get("searchIndex").equals("B")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));
						resultList.get(pos+6).put("y"+idx+"sctn7", dataInfo.get("sctn7"));
						resultList.get(pos+7).put("y"+idx+"sctn8", dataInfo.get("sctn8"));
						resultList.get(pos+8).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));
					}else if(rqstMap.get("searchIndex").equals("C")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));
						resultList.get(pos+6).put("y"+idx+"sctn7", dataInfo.get("sctn7"));
						resultList.get(pos+7).put("y"+idx+"sctn8", dataInfo.get("sctn8"));
						resultList.get(pos+8).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));
					}else if(rqstMap.get("searchIndex").equals("D")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));						
						resultList.get(pos+6).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));
					}else if(rqstMap.get("searchIndex").equals("E")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));						
						resultList.get(pos+6).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));
					}else if(rqstMap.get("searchIndex").equals("F")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));
						resultList.get(pos+6).put("y"+idx+"sctn7", dataInfo.get("sctn7"));
						resultList.get(pos+7).put("y"+idx+"sctn8", dataInfo.get("sctn8"));
						resultList.get(pos+8).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));				
					}
									
				}
			}						
			
		}
						
		mv.addObject("resultList", resultList);
		
		// 테이블 타이틀 조회
		param = new HashMap();
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrpVal"));
		mv.addObject("tableTitle",codeService.findCodeInfo(param).get("codeNm"));
		mv.addObject("stdyySt", startYr);
		mv.addObject("stdyyEd", endYr);	
		
		return mv;
	}
	
	// 주요지표 현황 맵 챠트 popup
	public ModelAndView getMapChart(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();

		mv.setViewName("/admin/ps/PD_UIPSA0020_M");

		HashMap param = new HashMap();
		
		// 검색조건 지역코드(권역별)목록 조회
		ArrayList areaList = (ArrayList) codeService.findCodesByGroupNo("57");
		ArrayList<String> areaType = new ArrayList();
		
		for(int i=0; i< areaList.size(); i++) {
			areaType.add((String) ((CodeVO) areaList.get(i)).getCode());
		}
		String[] arrArea = new String[] {};
		arrArea = areaType.toArray(arrArea);
		rqstMap.put("searchAreaVal", arrArea);
		
		// 업종 :  제조 / 비제조
		ArrayList indutyList = (ArrayList) codeService.findCodesByGroupNo("74");
		ArrayList<String> indutyType = new ArrayList();
		
		for (int i=0; i< indutyList.size(); i++) {
			indutyType.add(((CodeVO) indutyList.get(i)).getCode());
		}
		String[] arrInduty = new String[] {};
		arrInduty = indutyType.toArray(arrInduty);
		rqstMap.put("searchIndutyVal", arrInduty);

		// 기업군
		String searchEntprsGrpVal = null;
		if (rqstMap.containsKey("searchEntprsGrpVal")) searchEntprsGrpVal = (String) rqstMap.get("searchEntprsGrpVal");
		String[] arrSearchEntprsGrpVal = searchEntprsGrpVal.split(",");
		rqstMap.put("searchEntprsGrpVal", arrSearchEntprsGrpVal);
		
		// 지표
		MapUtils.getString(rqstMap, "searchIndex");
		rqstMap.put("searchIndexVal", "JP01");

		List<Map> indutyResultList = selectIndxStaticsList(rqstMap);
		
		// 테이블 타이틀 조회
		param = new HashMap();

		if (MapUtils.getObject(rqstMap, "searchEntprsGrpVal") instanceof String[]) {		// 기업군조건(멀티셀렉트) 체크
			String[] entprsGrp = (String[]) MapUtils.getObject(rqstMap, "searchEntprsGrpVal");
			String tableTitle = "";
			
			for (int i=0; i<entprsGrp.length; i++) {
				param.put("codeGroupNo", "14");
				param.put("code", entprsGrp[i]);
				
				if (i < entprsGrp.length-1) 	tableTitle = tableTitle.concat((String) codeService.findCodeInfo(param).get("codeNm")).concat(", ");
				else tableTitle = tableTitle.concat((String) codeService.findCodeInfo(param).get("codeNm"));
			}
			mv.addObject("tableTitle", tableTitle);
			
		} else {
			param.put("codeGroupNo", "14");
			param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrpVal"));
			mv.addObject("tableTitle",codeService.findCodeInfo(param).get("codeNm"));
		}		
		
		mv.addObject("searchEntprsGrpVal", arrSearchEntprsGrpVal);
		mv.addObject("resultList", indutyResultList);
		mv.addObject("indutyListCnt", indutyResultList.size());
		
		return mv;
	}
	
	
	// 주요지표 현황 출력 popup
	public ModelAndView getPrintOut(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();

		mv.setViewName("/admin/ps/PD_UIPSA0020_2");

		HashMap param = new HashMap();
		
		// 지역별
		String searchAreaVal = null;
		if (rqstMap.containsKey("searchAreaVal")) searchAreaVal = (String) rqstMap.get("searchAreaVal");
		// 업무별
		String searchIndutyVal = null;
		if (rqstMap.containsKey("searchIndutyVal")) searchIndutyVal = (String) rqstMap.get("searchIndutyVal");
		// 지표
		String searchIndexVal = null;
		if (rqstMap.containsKey("searchIndexVal")) searchIndexVal = (String) rqstMap.get("searchIndexVal");
		// 기업군
		String searchEntprsGrpVal = null;
		if (rqstMap.containsKey("searchEntprsGrpVal")) searchEntprsGrpVal = (String) rqstMap.get("searchEntprsGrpVal");
		
		String[] array_searchAreaVal = searchAreaVal.split(",");
		String[] array_searchIndutyVal = searchIndutyVal.split(",");
		String[] array_searchIndexVal = searchIndexVal.split(",");
		String[] array_searchEntprsGrpVal = searchEntprsGrpVal.split(",");
		
		rqstMap.put("searchAreaVal", array_searchAreaVal);
		rqstMap.put("searchIndutyVal", array_searchIndutyVal);
		rqstMap.put("searchIndexVal", array_searchIndexVal);
		rqstMap.put("searchEntprsGrpVal", array_searchEntprsGrpVal);
		
		String searchArea = MapUtils.getString(rqstMap, "searchArea");
		String searchInduty = MapUtils.getString(rqstMap, "searchInduty");
		String searchIndex = MapUtils.getString(rqstMap, "searchIndex");

		mv.addObject("searchIndex", rqstMap.get("searchIndex"));
		mv.addObject("searchIndexVal", rqstMap.get("searchIndexVal"));
		mv.addObject("searchIndexVal_length", array_searchIndexVal.length);
		
		List<Map> resultList = selectIndxStaticsList(rqstMap);
		mv.addObject("resultList", resultList);
		
		Map resultInfo = resultList.get(0);
		ArrayList<String> columnList = new ArrayList();
		String[] arrColmList = new String[] {};
		
		Iterator colmItr = resultInfo.keySet().iterator();
		while (colmItr.hasNext()) {
			String colmNm = (String) colmItr.next();
			if (colmNm.startsWith("sum") || colmNm.startsWith("avg")) {
				columnList.add(colmNm);
			}
		}
		
		arrColmList = (String[]) columnList.toArray(arrColmList);
		mv.addObject("columnList", arrColmList);
		
		// 테이블 타이틀 조회
		param = new HashMap();

		if (MapUtils.getObject(rqstMap, "searchEntprsGrpVal") instanceof String[]) {		// 기업군조건(멀티셀렉트) 체크
			String[] entprsGrp = (String[]) MapUtils.getObject(rqstMap, "searchEntprsGrpVal");
			String tableTitle = "";
			
			for (int i=0; i<entprsGrp.length; i++) {
				param.put("codeGroupNo", "14");
				param.put("code", entprsGrp[i]);
				
				if (i < entprsGrp.length-1) 	tableTitle = tableTitle.concat((String) codeService.findCodeInfo(param).get("codeNm")).concat(", ");
				else tableTitle = tableTitle.concat((String) codeService.findCodeInfo(param).get("codeNm"));
			}
			mv.addObject("tableTitle", tableTitle);
			
		} else {
			param.put("codeGroupNo", "14");
			param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrpVal"));
			mv.addObject("tableTitle",codeService.findCodeInfo(param).get("codeNm"));
		}		
		
		return mv;

	}
	
	public ModelAndView getPrintOut2(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/ps/PD_UIPSA0021_2");
		
		HashMap param = new HashMap();

		mv.addObject("searchIndex", rqstMap.get("searchIndex"));		
		
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
		
		List<Map> resultList = selectStaticsLisSctn(rqstMap);

		mv.addObject("resultList", resultList);
		mv.addObject("resultListCnt", resultList.size());
		
		param = new HashMap();
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrpVal"));
		mv.addObject("tableTitle",codeService.findCodeInfo(param).get("codeNm"));	
		
		return mv;
	}
	
	
	public ModelAndView getPrintOut3(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/ps/PD_UIPSA0022_2");
		
		HashMap param = new HashMap();
		
		// 검색조건 년도목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		mv.addObject("stdyyList", stdyyList);

		// 검색기간 조건 설정
		int startYr = 2013;
		int endYr = 2013;
		// 검색기간 가져오기
		if (rqstMap.containsKey("searchStdyySt")) startYr = MapUtils.getIntValue(rqstMap, "searchStdyySt"); 
		if (rqstMap.containsKey("searchStdyyEd")) endYr = MapUtils.getIntValue(rqstMap, "searchStdyyEd");
		
		// 지역별
		String searchAreaVal = null;
		if (rqstMap.containsKey("searchAreaVal")) searchAreaVal = (String) rqstMap.get("searchAreaVal");
		// 업무별
		String searchIndutyVal = null;
		if (rqstMap.containsKey("searchIndutyVal")) searchIndutyVal = (String) rqstMap.get("searchIndutyVal");

		mv.addObject("searchIndex", rqstMap.get("searchIndex"));
		mv.addObject("searchIndexVal", rqstMap.get("searchIndexVal"));
		
		// 지표
		String searchIndexVal = null;
		if (rqstMap.containsKey("searchIndexVal")) searchIndexVal = (String) rqstMap.get("searchIndexVal");
		
		String[] array_searchAreaVal = searchAreaVal.split(",");
		String[] array_searchIndutyVal = searchIndutyVal.split(",");
		String[] array_searchIndexVal = searchIndexVal.split(",");
		
		rqstMap.put("searchAreaVal", array_searchAreaVal);
		rqstMap.put("searchIndutyVal", array_searchIndutyVal);
		rqstMap.put("searchIndexVal", array_searchIndexVal);
				
		List<Map> resultList = new ArrayList();
		int idx = 0;
		int pos = 0;
		ArrayList<String> columnList = new ArrayList();
		
		for (int i=startYr; i<=endYr; i++) {
			rqstMap.put("searchStdyy", String.valueOf(i));
									
			List<Map> idxList = selectIndxStaticsList(rqstMap);

			if (resultList.size() == 0) {
				
				Map idxInfo = idxList.get(0);
				
				String[] arrColmList = new String[] {};
				
				Iterator colmItr = idxInfo.keySet().iterator();
				while (colmItr.hasNext()) {
					String colmNm = (String) colmItr.next();
					if (colmNm.startsWith("sum") || colmNm.startsWith("avg")) {
						columnList.add(colmNm);
					}
				}
				
				arrColmList = (String[]) columnList.toArray(arrColmList);
				mv.addObject("columnList", arrColmList);
				
				for (int j=0; j<idxList.size(); j++) {
					for(int k=0; k<columnList.size(); k++) {
						resultList.add(idxList.get(j));						
					}
				}
				
			}else {
				idx++;
				for (int j=0; j<idxList.size(); j++) {
					Map dataInfo = idxList.get(j);
					pos = j * columnList.size();
					for(int k=0; k<columnList.size(); k++) {
						Map resultInfo = resultList.get(pos+k);
						resultInfo.put("y"+idx+columnList.get(k), dataInfo.get(columnList.get(k)));
					}					
				}
			}						
		}
						
		mv.addObject("resultList", resultList);
		mv.addObject("resultListCnt", resultList.size());
		
		mv.addObject("searchIndexVal", array_searchIndexVal);
		mv.addObject("searchIndexVal_length", array_searchIndexVal.length);
		
		// 테이블 타이틀 조회
		param = new HashMap();
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrpVal"));
		mv.addObject("tableTitle",codeService.findCodeInfo(param).get("codeNm"));
		mv.addObject("stdyySt", startYr);
		mv.addObject("stdyyEd", endYr);	
		
		return mv;
	}	
	
	
	public ModelAndView getPrintOut4(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/ps/PD_UIPSA0023_2");
		
		HashMap param = new HashMap();

		// 검색기간 조건 설정
		int startYr = 2013;
		int endYr = 2013;
	
		if (rqstMap.containsKey("searchStdyySt")) startYr = MapUtils.getIntValue(rqstMap, "searchStdyySt");
	
		if (rqstMap.containsKey("searchStdyyEd")) endYr = MapUtils.getIntValue(rqstMap, "searchStdyyEd");		

		// 지역별
		String searchAreaVal = null;
		if (rqstMap.containsKey("searchAreaVal")) searchAreaVal = (String) rqstMap.get("searchAreaVal");
		// 업무별
		String searchIndutyVal = null;
		if (rqstMap.containsKey("searchIndutyVal")) searchIndutyVal = (String) rqstMap.get("searchIndutyVal");

		mv.addObject("searchIndex", rqstMap.get("searchIndex"));
		
		String[] array_searchAreaVal = searchAreaVal.split(",");
		String[] array_searchIndutyVal = searchIndutyVal.split(",");
		
		rqstMap.put("searchAreaVal", array_searchAreaVal);
		rqstMap.put("searchIndutyVal", array_searchIndutyVal);
		
		List<Map> resultList = new ArrayList();
		int idx = 0;			
		int colmCnt = 0;
		
		for (int i=startYr; i<=endYr; i++) {
			rqstMap.put("searchStdyy", String.valueOf(i));
									
			List<Map> idxList = selectStaticsLisSctn(rqstMap);
			
			if (resultList.size() == 0) {
				
				for (int j=0; j<idxList.size(); j++) {
					Map idxInfo = idxList.get(j);
					
					if(rqstMap.get("searchIndex").equals("A")) {
						colmCnt = 8;
					}else if(rqstMap.get("searchIndex").equals("B")) {						
						colmCnt = 9;
					}else if(rqstMap.get("searchIndex").equals("C")) {						
						colmCnt = 9;
					}else if(rqstMap.get("searchIndex").equals("D")) {						
						colmCnt = 7;
					}else if(rqstMap.get("searchIndex").equals("E")) {						
						colmCnt = 7;
					}else if(rqstMap.get("searchIndex").equals("F")) {						
						colmCnt = 9;			
					}
					for(int k=0; k<colmCnt; k++) {
						resultList.add(idxInfo);
						logger.debug("@@ idxInfo : " + idxInfo);
					}
										
				}
				
			}else {				
				idx++;
				for (int j=0; j<idxList.size(); j++) {
					Map dataInfo = idxList.get(j);
					int pos = j * colmCnt;

					if(rqstMap.get("searchIndex").equals("A")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));
						resultList.get(pos+6).put("y"+idx+"sctn7", dataInfo.get("sctn7"));						
						resultList.get(pos+7).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));
					}else if(rqstMap.get("searchIndex").equals("B")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));
						resultList.get(pos+6).put("y"+idx+"sctn7", dataInfo.get("sctn7"));
						resultList.get(pos+7).put("y"+idx+"sctn8", dataInfo.get("sctn8"));
						resultList.get(pos+8).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));
					}else if(rqstMap.get("searchIndex").equals("C")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));
						resultList.get(pos+6).put("y"+idx+"sctn7", dataInfo.get("sctn7"));
						resultList.get(pos+7).put("y"+idx+"sctn8", dataInfo.get("sctn8"));
						resultList.get(pos+8).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));
					}else if(rqstMap.get("searchIndex").equals("D")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));						
						resultList.get(pos+6).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));
					}else if(rqstMap.get("searchIndex").equals("E")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));						
						resultList.get(pos+6).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));
					}else if(rqstMap.get("searchIndex").equals("F")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));
						resultList.get(pos+6).put("y"+idx+"sctn7", dataInfo.get("sctn7"));
						resultList.get(pos+7).put("y"+idx+"sctn8", dataInfo.get("sctn8"));
						resultList.get(pos+8).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));				
					}
									
				}
			}						
			
		}
						
		mv.addObject("resultList", resultList);
		
		// 테이블 타이틀 조회
		param = new HashMap();
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrpVal"));
		mv.addObject("tableTitle",codeService.findCodeInfo(param).get("codeNm"));
		mv.addObject("stdyySt", startYr);
		mv.addObject("stdyyEd", endYr);	
		
		return mv;
	}
	
	
	
	/**
	 * 엑셀 다운로드
	 * @param rqstMap
	 * @return
	 * @throws Exception 
	 */
	public ModelAndView excelStatics(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		ArrayList<String> headers = new ArrayList<String>();	// 타이틀
		ArrayList<String> items = new ArrayList<String>();		// 컬럼명
		
		// 파일명(기준년도)
		String stdyy = MapUtils.getString(rqstMap, "searchStdyy");
		
		// 파일명(기업군) 조회
		String entprs = "";
		HashMap param = new HashMap();
		if (MapUtils.getObject(rqstMap, "searchEntprsGrpVal") instanceof String[]) {		// 기업군조건(멀티셀렉트) 체크
			String[] entprsGrp = (String[]) MapUtils.getObject(rqstMap, "searchEntprsGrpVal");

			for (int i=0; i<entprsGrp.length; i++) {
				param.put("codeGroupNo", "14");
				param.put("code", entprsGrp[i]);
				
				if (i < entprsGrp.length-1) 	entprs = entprs.concat((String) codeService.findCodeInfo(param).get("codeNm")).concat("_");
				else entprs = entprs.concat((String) codeService.findCodeInfo(param).get("codeNm"));
			}
			
			headers.add("기업군");
			items.add("entclsNm");
		} else {
			param.put("entcls", new String[] {(String) MapUtils.getObject(rqstMap, "searchEntprsGrpVal")});
			param.put("codeGroupNo", "14");
			param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrpVal"));
			entprs= (String) codeService.findCodeInfo(param).get("codeNm");
		}
		
		// 지표조건
		String indx = MapUtils.getString(rqstMap, "searchIndex");
		
		// 지역조건
		if (!MapUtils.getString(rqstMap, "searchArea", "").equals("")) {
			if (MapUtils.getString(rqstMap, "searchArea").equals("1")) {
				headers.add("권역");
				headers.add("지역");
				items.add("upperNm");
				items.add("abrv");
			} else {
				headers.add("지역");
				items.add("abrv");
			}
		}
		// 업종조건
		if (!MapUtils.getString(rqstMap, "searchInduty", "").equals("")) {
			headers.add("업종/지표");
			if (MapUtils.getString(rqstMap, "searchInduty").equals("1")) items.add("indutySeNm");
			if (MapUtils.getString(rqstMap, "searchInduty").equals("2")) items.add("dtlclfcNm");
			if (MapUtils.getString(rqstMap, "searchInduty").equals("3")) items.add("indutyNm");
		}

		// 데이터 조회
		List<Map> resultList = selectIndxStaticsList(rqstMap);
		
		Map resultInfo = resultList.get(0);
		
		Iterator colmItr = resultInfo.keySet().iterator();
		while (colmItr.hasNext()) {
			String colmNm = (String) colmItr.next();
			if (colmNm.startsWith("sum") || colmNm.startsWith("avg")) {
				items.add(colmNm);		// 컬럼명
				
				// 타이틀
				if (indx.equals("1")) {
					if (colmNm.equals("sumEntrprsCo")) headers.add("기업수(개)");
					if (colmNm.equals("sumSelngAm")) headers.add("매출액(조원)");
					if (colmNm.equals("sumBsnProfit")) headers.add("영업이익(조원)");
					if (colmNm.equals("sumBsnProfitRt")) headers.add("영업이익률(%)");
					if (colmNm.equals("sumXportAmDollar")) headers.add("수출액(억불)");
					if (colmNm.equals("sumXportAmRt")) headers.add("수출비중(%)");
					if (colmNm.equals("sumOrdtmLabrrCo")) headers.add("근로자수(만명)");
					if (colmNm.equals("sumRsrchDevlopRt")) headers.add("R&D집약도(%)");
					if (colmNm.equals("sumThstrmNtpf")) headers.add("당기순이익(조원)");
				} else {
					if (colmNm.equals("sumEntrprsCo")) headers.add("기업수(개)");
					if (colmNm.equals("avgSelngAm")) headers.add("평균매출액(억원)");
					if (colmNm.equals("avgBsnProfit")) headers.add("평균영업이익(억원)");
					if (colmNm.equals("avgBsnProfitRt")) headers.add("평균영업이익률(%)");
					if (colmNm.equals("avgXportAmDollar")) headers.add("평균수출액(백만불)");
					if (colmNm.equals("avgXportAmRt")) headers.add("평균수출비중(%)");
					if (colmNm.equals("avgOrdtmLabrrCo")) headers.add("평균근로자수(백명)");
					if (colmNm.equals("avgRsrchDevlopRt")) headers.add("평균R&D집약도(%)");
					if (colmNm.equals("avgThstrmNtpfRt")) headers.add("평균당기순이익(억원)");
					if (colmNm.equals("avgCorage")) headers.add("평균업력(년)");
				}
			}
		}
		
		String[] arryHeaders = new String[] {};
		String[] arryItems = new String[] {};
		arryHeaders = headers.toArray(arryHeaders);
		arryItems = items.toArray(arryItems);
		
		mv.addObject("_headers", arryHeaders);
		mv.addObject("_items", arryItems);
		mv.addObject("_list", resultList);
		
		
		//메뉴명_탭명_YYYYMMDDhhmmss.xlsx
		IExcelVO excel = new ExcelVO("주요지표_현황_"+DateFormatUtil.getTodayFull());

		return ResponseUtil.responseExcel(mv, excel);
	}
	
	/**
	 * 엑셀 다운로드
	 * @param rqstMap
	 * @return
	 * @throws Exception 
	 */
	public ModelAndView excelStatics2(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		ArrayList<String> headers = new ArrayList<String>();	// 타이틀
		ArrayList<String> items = new ArrayList<String>();		// 컬럼명
		
		// 파일명(기준년도)
		String stdyy = MapUtils.getString(rqstMap, "searchStdyy");
		
		// 파일명(기업군) 조회
		String entprs = "";
		HashMap param = new HashMap();
		if (MapUtils.getObject(rqstMap, "searchEntprsGrpVal") instanceof String[]) {		// 기업군조건(멀티셀렉트) 체크
			String[] entprsGrp = (String[]) MapUtils.getObject(rqstMap, "searchEntprsGrpVal");

			for (int i=0; i<entprsGrp.length; i++) {
				param.put("codeGroupNo", "14");
				param.put("code", entprsGrp[i]);
				
				if (i < entprsGrp.length-1) 	entprs = entprs.concat((String) codeService.findCodeInfo(param).get("codeNm")).concat("_");
				else entprs = entprs.concat((String) codeService.findCodeInfo(param).get("codeNm"));
			}
			
			headers.add("기업군");
			items.add("entclsNm");
		} else {
			param.put("entcls", new String[] {(String) MapUtils.getObject(rqstMap, "searchEntprsGrpVal")});
			param.put("codeGroupNo", "14");
			param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrpVal"));
			entprs= (String) codeService.findCodeInfo(param).get("codeNm");
		}
		
		// 지표조건
		String indx = MapUtils.getString(rqstMap, "searchIndex");
		
		// 초기조회지표 설정
		ArrayList<String> indexVal = new ArrayList();
		if (!rqstMap.containsKey("searchIndex")) {
			rqstMap.put("searchIndex", "1");
			List<CodeVO> indexList = codeService.findCodesByGroupNo("64");

			for (CodeVO code: indexList) {
				indexVal.add(code.getCode());
			}
			String[] arrIndexVal = new String[] {};
			arrIndexVal = indexVal.toArray(arrIndexVal);
			rqstMap.put("searchIndexVal", arrIndexVal);
		}
		
		mv.addObject("searchIndex", rqstMap.get("searchIndex"));
		mv.addObject("searchIndexVal", rqstMap.get("searchIndexVal"));
		
		// 지역조건
		if (!MapUtils.getString(rqstMap, "searchArea", "").equals("")) {
			if (MapUtils.getString(rqstMap, "searchArea").equals("1")) {
				headers.add("권역");
				headers.add("지역");
				items.add("upperNm");
				items.add("abrv");
			} else {
				headers.add("지역");
				items.add("abrv");
			}
		}
		// 업종조건
		if (!MapUtils.getString(rqstMap, "searchInduty", "").equals("")) {
			headers.add("업종");
			if (MapUtils.getString(rqstMap, "searchInduty").equals("1")) items.add("indutySeNm");
			if (MapUtils.getString(rqstMap, "searchInduty").equals("2")) items.add("dtlclfcNm");
			if (MapUtils.getString(rqstMap, "searchInduty").equals("3")) items.add("indutyNm");
		}

		// 데이터 조회
		List<Map> resultList = selectStaticsLisSctn(rqstMap);
		
		
		// 타이틀
		if (indx.equals("A")) {
			headers.add("없음");
			headers.add("1.0%미만");
			headers.add("2.0~3.0%");
			headers.add("3.0~5.0%");
			headers.add("5.0%~10.0%");
			headers.add("10.0%~30.0%");
			headers.add("30.0%이상");
			headers.add("합계");
			
			items.add("sctn1");
			items.add("sctn2");
			items.add("sctn3");
			items.add("sctn4");
			items.add("sctn5");
			items.add("sctn6");
			items.add("sctn7");
			items.add("sctnSum");
		} else if (indx.equals("B")) {
			headers.add("100억미만");
			headers.add("100억원~500억원");
			headers.add("500억원~1천억원");
			headers.add("1천억원~2천억원");
			headers.add("2천억원~3천억원");
			headers.add("3천억원~5천억원");
			headers.add("5천억원~1조원");
			headers.add("1조원이상");
			headers.add("합계");
			
			items.add("sctn1");
			items.add("sctn2");
			items.add("sctn3");
			items.add("sctn4");
			items.add("sctn5");
			items.add("sctn6");
			items.add("sctn7");
			items.add("sctn8");
			items.add("sctnSum");
		} else if (indx.equals("C")) {
			headers.add("없음");
			headers.add("1백만~5백만불");
			headers.add("5백만~1천만불");
			headers.add("1천만~3천만불");
			headers.add("3천만~5천만불");
			headers.add("5천만~1억불");
			headers.add("1억불 이상");
			headers.add("합계");
			
			items.add("sctn1");
			items.add("sctn2");
			items.add("sctn3");
			items.add("sctn4");
			items.add("sctn5");
			items.add("sctn6");
			items.add("sctn7");
			items.add("sctnSum");
		}else if (indx.equals("D")) {
			headers.add("10인 미만");
			headers.add("10인~50인");
			headers.add("50인~100인");
			headers.add("100인~200인");
			headers.add("200인~300인");
			headers.add("300인 이상");
			headers.add("합계");
			
			items.add("sctn1");
			items.add("sctn2");
			items.add("sctn3");
			items.add("sctn4");
			items.add("sctn5");
			items.add("sctn6");
			items.add("sctnSum");
		}else if (indx.equals("E")) {
			headers.add("0~6년");
			headers.add("7~20년");
			headers.add("21~30년");
			headers.add("31~40년");
			headers.add("41~50년");
			headers.add("51년이상");
			headers.add("합계");
			
			items.add("sctn1");
			items.add("sctn2");
			items.add("sctn3");
			items.add("sctn4");
			items.add("sctn5");
			items.add("sctn6");
			items.add("sctnSum");
		}else if (indx.equals("F")) {
			headers.add("100억미만");
			headers.add("100억원~500억원");
			headers.add("500억원~1천억원");
			headers.add("1천억원~2천억원");
			headers.add("2천억원~3천억원");
			headers.add("3천억원~5천억원");
			headers.add("5천억원~1조원");
			headers.add("1조원이상");
			headers.add("합계");
			
			items.add("sctn1");
			items.add("sctn2");
			items.add("sctn3");
			items.add("sctn4");
			items.add("sctn5");
			items.add("sctn6");
			items.add("sctn7");
			items.add("sctn8");
			items.add("sctnSum");
		}
		
		String[] arryHeaders = new String[] {};
		String[] arryItems = new String[] {};
		arryHeaders = headers.toArray(arryHeaders);
		arryItems = items.toArray(arryItems);
		
		mv.addObject("_headers", arryHeaders);
		mv.addObject("_items", arryItems);
		mv.addObject("_list", resultList);
		
		
		//메뉴명_탭명_YYYYMMDDhhmmss.xlsx
		IExcelVO excel = new ExcelVO("주요지표_구간별현황_"+DateFormatUtil.getTodayFull());

		return ResponseUtil.responseExcel(mv, excel);
	}
	
	
	/**
	 * 엑셀 다운로드
	 * @param rqstMap
	 * @return
	 * @throws Exception 
	 */
	public ModelAndView excelStatics3(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		ArrayList<String> headers = new ArrayList<String>();	// 타이틀
		ArrayList<String> items = new ArrayList<String>();		// 컬럼명
		
		// 파일명(기준년도)
		int startYr = MapUtils.getIntValue(rqstMap, "searchStdyySt");
		int endYr =  MapUtils.getIntValue(rqstMap, "searchStdyyEd");
		int strdColIndex = 0;	//기준컬럼 위치 인덱스
		
		
		// 초기검색조건 설정
		if (!rqstMap.containsKey("searchEntprsGrpVal")) {
			rqstMap.put("searchEntprsGrpVal", "EA1");
		}
		
		// 파일명(기업군) 조회
		String entprs = "";
		HashMap param = new HashMap();
		if (MapUtils.getObject(rqstMap, "searchEntprsGrpVal") instanceof String[]) {		// 기업군조건(멀티셀렉트) 체크
			String[] entprsGrp = (String[]) MapUtils.getObject(rqstMap, "searchEntprsGrpVal");

			for (int i=0; i<entprsGrp.length; i++) {
				param.put("codeGroupNo", "14");
				param.put("code", entprsGrp[i]);
				
				if (i < entprsGrp.length-1) 	entprs = entprs.concat((String) codeService.findCodeInfo(param).get("codeNm")).concat("_");
				else entprs = entprs.concat((String) codeService.findCodeInfo(param).get("codeNm"));
			}
			
			//headers.add("기업군");
			//items.add("entclsNm");
		} else {
			param.put("entcls", new String[] {(String) MapUtils.getObject(rqstMap, "searchEntprsGrpVal")});
			param.put("codeGroupNo", "14");
			param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrpVal"));
			entprs= (String) codeService.findCodeInfo(param).get("codeNm");
		}
		
		// 지표조건 (1 : 총액, 2 : 평균)
		String indx = MapUtils.getString(rqstMap, "searchIndex");
		
		// 지역조건
		if (!MapUtils.getString(rqstMap, "searchArea", "").equals("")) {
			if (MapUtils.getString(rqstMap, "searchArea").equals("1")) {
				headers.add("권역");
				headers.add("지역");
				items.add("upperNm");
				items.add("abrv");
				strdColIndex = strdColIndex+2;
			} else {
				headers.add("지역");
				items.add("abrv");
				strdColIndex ++;
			}
		}
		// 업종조건
		if (!MapUtils.getString(rqstMap, "searchInduty", "").equals("")) {
			headers.add("업종");
			strdColIndex ++;
			if (MapUtils.getString(rqstMap, "searchInduty").equals("1")) items.add("indutySeNm");
			if (MapUtils.getString(rqstMap, "searchInduty").equals("2")) items.add("dtlclfcNm");
			if (MapUtils.getString(rqstMap, "searchInduty").equals("3")) items.add("indutyNm");
		}
		//구분
		headers.add("구분");
		strdColIndex ++;

		mv.addObject("searchIndex", rqstMap.get("searchIndex"));
		mv.addObject("searchIndexVal", rqstMap.get("searchIndexVal"));

		// 지표
		String searchIndex = null;
		String searchIndexVal = null;
		if (rqstMap.containsKey("searchIndex")) searchIndex = (String) rqstMap.get("searchIndex");	// 1, 2
		
		String[] array_searchIndexVal = null;
		array_searchIndexVal = (String[]) rqstMap.get("searchIndexVal");
		
		mv.addObject("searchIndex", searchIndex);
		mv.addObject("indx", indx);
		mv.addObject("searchIndexVal", searchIndexVal);
		mv.addObject("array_searchIndexVal", array_searchIndexVal);

		
		List<Map> resultList = new ArrayList();
		int idx = 0;
		
		ArrayList<String> columnList = new ArrayList();				
		
		for (int i=startYr; i<=endYr; i++) {
			headers.add(String.valueOf(i));
			
			rqstMap.put("searchStdyy", String.valueOf(i));
									
			List<Map> idxList = selectIndxStaticsList(rqstMap);
				
			if (resultList.size() == 0) {
				
				Map idxInfo = idxList.get(0);
				
				String[] arrColmList = new String[] {};
				
				Iterator colmItr = idxInfo.keySet().iterator();
				while (colmItr.hasNext()) {
					String colmNm = (String) colmItr.next();
					if (colmNm.startsWith("sum") || colmNm.startsWith("avg")) {
						columnList.add(colmNm);
					}
				}
				
				arrColmList = (String[]) columnList.toArray(arrColmList);
				mv.addObject("columnList", arrColmList);
				
				for (int j=0; j<idxList.size(); j++) {										
					
					for(int k=0; k<columnList.size(); k++) {
						resultList.add(idxList.get(j));						
					}
				}
			
			}else {
				idx++;
				for (int j=0; j<idxList.size(); j++) {
					int pos = j * columnList.size();
					
					Map dataInfo = idxList.get(j);
					/*
					String key = columnList.get(j%columnList.size());
					
					
					Map resultInfo = resultList.get(j);
					resultInfo.put("y"+idx+key, dataInfo.get(key));*/
					
					for(int k=0; k<columnList.size(); k++) {
						// Map resultInfo = resultList.get(pos + k);
																
						String key = columnList.get(k);
												
						Map resultInfo = resultList.get(k + pos);
						resultInfo.put("y"+idx+key, dataInfo.get(key));
						
						//resultInfo.put("y"+idx+columnList.get(k), dataInfo.get(columnList.get(k)));
						
					}				
				}
			}						
			
		}
		
		mv.addObject("resultList", resultList);
				
		String[] arryHeaders = new String[] {};
		String[] arryItems = new String[] {};
		arryHeaders = headers.toArray(arryHeaders);
		arryItems = items.toArray(arryItems);
		
		mv.addObject("columnList", columnList);
		mv.addObject("searchIndex", MapUtils.getIntValue(rqstMap, "searchIndex"));
		
		mv.addObject("_headers", arryHeaders);
		mv.addObject("_items", arryItems);
		mv.addObject("_list", resultList);		
		mv.addObject("stdyySt", startYr);
		mv.addObject("stdyyEd", endYr);	
		
		IExcelVO excel = new PGPS0020ExcelVO("주요지표_추이_"+DateFormatUtil.getTodayFull());
		
		return ResponseUtil.responseExcel(mv, excel);
	}
	
	
	/**
	 * 엑셀 다운로드
	 * @param rqstMap
	 * @return
	 * @throws Exception 
	 */
	public ModelAndView excelStatics4(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		ArrayList<String> headers = new ArrayList<String>();	// 타이틀
		ArrayList<String> items = new ArrayList<String>();		// 컬럼명
		
		// 파일명(기준년도)
		int startYr = MapUtils.getIntValue(rqstMap, "searchStdyySt");
		int endYr =  MapUtils.getIntValue(rqstMap, "searchStdyyEd");
		
		// 파일명(기업군) 조회
		String entprs = "";
		HashMap param = new HashMap();
		if (MapUtils.getObject(rqstMap, "searchEntprsGrpVal") instanceof String[]) {		// 기업군조건(멀티셀렉트) 체크
			String[] entprsGrp = (String[]) MapUtils.getObject(rqstMap, "searchEntprsGrpVal");

			for (int i=0; i<entprsGrp.length; i++) {
				param.put("codeGroupNo", "14");
				param.put("code", entprsGrp[i]);
				
				if (i < entprsGrp.length-1) 	entprs = entprs.concat((String) codeService.findCodeInfo(param).get("codeNm")).concat("_");
				else entprs = entprs.concat((String) codeService.findCodeInfo(param).get("codeNm"));
			}
			
		} else {
			param.put("entcls", new String[] {(String) MapUtils.getObject(rqstMap, "searchEntprsGrpVal")});
			param.put("codeGroupNo", "14");
			param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrpVal"));
			entprs= (String) codeService.findCodeInfo(param).get("codeNm");
		}
		
		// 지표조건
		String indx = MapUtils.getString(rqstMap, "searchIndex");
		
		mv.addObject("searchIndex", rqstMap.get("searchIndex"));
		mv.addObject("searchIndexVal", rqstMap.get("searchIndexVal"));
		
		// 지역조건
		if (!MapUtils.getString(rqstMap, "searchArea", "").equals("")) {
			if (MapUtils.getString(rqstMap, "searchArea").equals("1")) {
				headers.add("권역");
				headers.add("지역");
				items.add("upperNm");
				items.add("abrv");
			} else {
				headers.add("지역");
				items.add("abrv");
			}
		}
		// 업종조건
		if (!MapUtils.getString(rqstMap, "searchInduty", "").equals("")) {
			headers.add("업종");
			if (MapUtils.getString(rqstMap, "searchInduty").equals("1")) items.add("indutySeNm");
			if (MapUtils.getString(rqstMap, "searchInduty").equals("2")) items.add("dtlclfcNm");
			if (MapUtils.getString(rqstMap, "searchInduty").equals("3")) items.add("indutyNm");
		}
		//구분
		headers.add("구분");
				
		List<Map> resultList = new ArrayList();
		int idx = 0;			
		int colmCnt = 0;
		
		for (int i=startYr; i<=endYr; i++) {
			headers.add(String.valueOf(i));
			rqstMap.put("searchStdyy", String.valueOf(i));
									
			List<Map> idxList = selectStaticsLisSctn(rqstMap);
				
			if (resultList.size() == 0) {
								
				
				for (int j=0; j<idxList.size(); j++) {										
					Map idxInfo = idxList.get(j);
					
					if(rqstMap.get("searchIndex").equals("A")) {
						colmCnt = 8;
					}else if(rqstMap.get("searchIndex").equals("B")) {						
						colmCnt = 9;
					}else if(rqstMap.get("searchIndex").equals("C")) {						
						colmCnt = 9;
					}else if(rqstMap.get("searchIndex").equals("D")) {						
						colmCnt = 7;
					}else if(rqstMap.get("searchIndex").equals("E")) {						
						colmCnt = 7;
					}else if(rqstMap.get("searchIndex").equals("F")) {						
						colmCnt = 9;			
					}
					for(int k=0; k<colmCnt; k++) {
						resultList.add(idxInfo);
						logger.debug("@@ idxInfo : " + idxInfo);
					}
										
				}
				
			}else {				
				idx++;
				for (int j=0; j<idxList.size(); j++) {
					Map dataInfo = idxList.get(j);
					int pos = j * colmCnt;

					if(rqstMap.get("searchIndex").equals("A")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));
						resultList.get(pos+6).put("y"+idx+"sctn7", dataInfo.get("sctn7"));						
						resultList.get(pos+7).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));
					}else if(rqstMap.get("searchIndex").equals("B")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));
						resultList.get(pos+6).put("y"+idx+"sctn7", dataInfo.get("sctn7"));
						resultList.get(pos+7).put("y"+idx+"sctn8", dataInfo.get("sctn8"));
						resultList.get(pos+8).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));
					}else if(rqstMap.get("searchIndex").equals("C")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));
						resultList.get(pos+6).put("y"+idx+"sctn7", dataInfo.get("sctn7"));
						resultList.get(pos+7).put("y"+idx+"sctn8", dataInfo.get("sctn8"));
						resultList.get(pos+8).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));
					}else if(rqstMap.get("searchIndex").equals("D")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));						
						resultList.get(pos+6).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));
					}else if(rqstMap.get("searchIndex").equals("E")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));						
						resultList.get(pos+6).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));
					}else if(rqstMap.get("searchIndex").equals("F")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));
						resultList.get(pos+6).put("y"+idx+"sctn7", dataInfo.get("sctn7"));
						resultList.get(pos+7).put("y"+idx+"sctn8", dataInfo.get("sctn8"));
						resultList.get(pos+8).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));				
					}
									
				}
			}						
			
		}
						
		String[] arryHeaders = new String[] {};
		String[] arryItems = new String[] {};
		arryHeaders = headers.toArray(arryHeaders);
		arryItems = items.toArray(arryItems);
		
		mv.addObject("_headers", arryHeaders);
		mv.addObject("_items", arryItems);
		mv.addObject("_list", resultList);
		mv.addObject("searchIndex", rqstMap.get("searchIndex"));		
		mv.addObject("stdyySt", startYr);
		mv.addObject("stdyyEd", endYr);
				
		IExcelVO excel = new PGPS0020_2ExcelVO("주요지표_구간별추이_"+DateFormatUtil.getTodayFull());

		return ResponseUtil.responseExcel(mv, excel);
	}
	
	
	
	
	
	
	
	
	
	/*
	 * ############## 주요지표현황(2015.01.13 강수종) #############
	 */
	
	
	
	
	/**
	 * 주요지표>현황 조회`
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getGridSttusList(Map<?, ?> rqstMap) throws Exception {	
		HashMap param = new HashMap();
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));		// 조회조건 : 기업군
		if (rqstMap.containsKey("sel_target_year")) param.put("sel_target_year", rqstMap.get("sel_target_year"));
		if (rqstMap.containsKey("induty_select")) param.put("induty_select", rqstMap.get("induty_select"));		// 업종 선택 구분
		if (rqstMap.containsKey("multiSelectGrid1")) param.put("multiSelectGrid1", rqstMap.get("multiSelectGrid1"));
		if (rqstMap.containsKey("multiSelectGrid2")) param.put("multiSelectGrid2", rqstMap.get("multiSelectGrid2"));
		logger.debug("------------------searchCondition: "+rqstMap.get("searchCondition"));
		
		int pageNo = MapUtils.getIntValue(rqstMap, "page");
		int rowSize = MapUtils.getIntValue(rqstMap, "rows");
		logger.debug("rowSize: "+rowSize);
		
		//주요지표>현황 조회
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.idxList(param);
		logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&: "+entprsList.toString());
		
		GridJsonVO gridJsonVo = new GridJsonVO();
		gridJsonVo.setRows(entprsList);
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("entprsList", entprsList);
		
		return ResponseUtil.responseGridJson(mv, gridJsonVo);
	}
	


	/**
	 * 주요지표 > 구간별현황탭 조회
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView goIdxList2(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/BD_UIPSA0021");
		HashMap param = new HashMap();
		
		// 검색조건 년도목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		mv.addObject("stdyyList", stdyyList);
		
		// 검색조건 업종테마목록 조회
		mv.addObject("themaList", pgps0030Dao.selectInduThemaList(param));
		
		// 검색조건 업종테마목록 조회
		mv.addObject("indutyList", pgps0030Dao.selectIndutyList(param));
		
		// 검색조건 지역코드(권역별)목록 조회
		mv.addObject("areaState", codeService.findCodesByGroupNo("57"));
		
		// 검색조건 지역코드(광역시)목록 조회
		mv.addObject("areaCity", entprsDAO.findCodesCity(param));				
		
		// 초기검색조건 설정
		if (!rqstMap.containsKey("searchEntprsGrpVal")) {
			rqstMap.put("searchEntprsGrpVal", "EA1");
		}
		if (!rqstMap.containsKey("searchIndex")) {
			rqstMap.put("searchIndex", "A");
		}
		if (!rqstMap.containsKey("searchStdyy")) rqstMap.put("searchStdyy", stdyyList.get(0).get("stdyy"));
				
		mv.addObject("searchIndex", rqstMap.get("searchIndex"));		
		
		List<Map> resultList = selectStaticsLisSctn(rqstMap);
		
		mv.addObject("resultList", resultList);
										
		// 테이블 타이틀 조회
		param = new HashMap();
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrpVal"));
		mv.addObject("tableTitle",codeService.findCodeInfo(param).get("codeNm"));				
		
		return mv;
	}
	
	/**
	 * 주요지표 > 추이탭 조회
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView goIdxList3(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/BD_UIPSA0022");
		HashMap param = new HashMap();
		
		// 검색조건 년도목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		mv.addObject("stdyyList", stdyyList);
		
		// 검색조건 업종테마목록 조회
		mv.addObject("themaList", pgps0030Dao.selectInduThemaList(param));
		
		// 검색조건 업종테마목록 조회
		mv.addObject("indutyList", pgps0030Dao.selectIndutyList(param));
		
		// 검색조건 지역코드(권역별)목록 조회
		mv.addObject("areaState", codeService.findCodesByGroupNo("57"));
		
		// 검색조건 지역코드(광역시)목록 조회
		mv.addObject("areaCity", entprsDAO.findCodesCity(param));
		
		// 검색조건 기업군목록 조회
		mv.addObject("entprsList", codeService.findCodesByGroupNo("14"));
		
		// 출력조건 지표
		mv.addObject("indexSumList", codeService.findCodesByGroupNo("64"));
		mv.addObject("indexAvgList", codeService.findCodesByGroupNo("65"));
		
		// 초기검색조건 설정
		if (!rqstMap.containsKey("searchEntprsGrpVal")) {
			rqstMap.put("searchEntprsGrpVal", "EA1");
		}
		
		// 검색기간 조건 설정
		int startYr = Integer.parseInt((String) stdyyList.get(4).get("stdyy"));
		int endYr = Integer.parseInt((String) stdyyList.get(0).get("stdyy"));
	
		if (rqstMap.containsKey("searchStdyySt")) {
			startYr = MapUtils.getIntValue(rqstMap, "searchStdyySt");
		} else {
			if ( (endYr - 10) > startYr) {
				startYr = Integer.parseInt((String) stdyyList.get(9).get("stdyy"));
			}
		}
		if (rqstMap.containsKey("searchStdyyEd")) endYr = MapUtils.getIntValue(rqstMap, "searchStdyyEd");
		
		// 초기조회지표 설정
		ArrayList<String> indexVal = new ArrayList();
		if (!rqstMap.containsKey("searchIndex")) {
			rqstMap.put("searchIndex", "1");
			List<CodeVO> indexList = codeService.findCodesByGroupNo("64");

			for (CodeVO code: indexList) {
				indexVal.add(code.getCode());
			}
			String[] arrIndexVal = new String[] {};
			arrIndexVal = indexVal.toArray(arrIndexVal);
			rqstMap.put("searchIndexVal", arrIndexVal);
		}

		mv.addObject("searchIndex", rqstMap.get("searchIndex"));
		mv.addObject("searchIndexVal", rqstMap.get("searchIndexVal"));
				
		List<Map> resultList = new ArrayList();
		int idx = 0;
		
		ArrayList<String> columnList = new ArrayList();
		
		for (int i=startYr; i<=endYr; i++) {
			rqstMap.put("searchStdyy", String.valueOf(i));
									
			List<Map> idxList = selectIndxStaticsList(rqstMap);
			logger.debug("idxList의 사이즈 :" + idxList.size());
			logger.debug("@@ selectIndxStaticsList 결과 = \n" + idxList);	
			if (resultList.size() == 0) {
				
				Map idxInfo = idxList.get(0);
				
				String[] arrColmList = new String[] {};
				
				Iterator colmItr = idxInfo.keySet().iterator();
				while (colmItr.hasNext()) {
					String colmNm = (String) colmItr.next();
					if (colmNm.startsWith("sum") || colmNm.startsWith("avg")) {
						columnList.add(colmNm);
					}
				}
				
				arrColmList = (String[]) columnList.toArray(arrColmList);
				mv.addObject("columnList", arrColmList);
				
				for (int j=0; j<idxList.size(); j++) {										
					
					for(int k=0; k<columnList.size(); k++) {
						resultList.add(idxList.get(j));						
					}
				}
			logger.debug("@@ resultList.size() == 0 --> \n" + resultList);	
			}else {
				idx++;
				for (int j=0; j<idxList.size(); j++) {
					int pos = j * columnList.size();
					
					Map dataInfo = idxList.get(j);
					/*
					String key = columnList.get(j%columnList.size());
					
					
					Map resultInfo = resultList.get(j);
					resultInfo.put("y"+idx+key, dataInfo.get(key));*/
					
					for(int k=0; k<columnList.size(); k++) {
						// Map resultInfo = resultList.get(pos + k);
																
						String key = columnList.get(k);
												
						Map resultInfo = resultList.get(k + pos);
						resultInfo.put("y"+idx+key, dataInfo.get(key));
						
						//resultInfo.put("y"+idx+columnList.get(k), dataInfo.get(columnList.get(k)));
						
					}				
				}
			}						
			
		}
						
		mv.addObject("resultList", resultList);						
		
		// 테이블 타이틀 조회
		param = new HashMap();
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrpVal"));
		mv.addObject("tableTitle",codeService.findCodeInfo(param).get("codeNm"));
		mv.addObject("stdyySt", startYr);
		mv.addObject("stdyyEd", endYr);	
				
		return mv;
	}
	
	/**
	 * 주요지표 > 구간별추이탭 조회
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView goIdxList4(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/BD_UIPSA0023");
		HashMap param = new HashMap();
		
		// 검색조건 년도목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		mv.addObject("stdyyList", stdyyList);
		
		// 검색조건 업종테마목록 조회
		mv.addObject("themaList", pgps0030Dao.selectInduThemaList(param));
		
		// 검색조건 업종테마목록 조회
		mv.addObject("indutyList", pgps0030Dao.selectIndutyList(param));
		
		// 검색조건 지역코드(권역별)목록 조회
		mv.addObject("areaState", codeService.findCodesByGroupNo("57"));
		
		// 검색조건 지역코드(광역시)목록 조회
		mv.addObject("areaCity", entprsDAO.findCodesCity(param));
		
		// 검색조건 기업군목록 조회
		mv.addObject("entprsList", codeService.findCodesByGroupNo("14"));		
		
		// 초기검색조건 설정
		if (!rqstMap.containsKey("searchEntprsGrpVal")) {
			rqstMap.put("searchEntprsGrpVal", "EA1");
		}
		if (!rqstMap.containsKey("searchIndex")) {
			rqstMap.put("searchIndex", "A");
		}
		
		// 검색기간 조건 설정
		int startYr = Integer.parseInt((String) stdyyList.get(4).get("stdyy"));
		int endYr = Integer.parseInt((String) stdyyList.get(0).get("stdyy"));
	
		if (rqstMap.containsKey("searchStdyySt")) {
			startYr = MapUtils.getIntValue(rqstMap, "searchStdyySt");
		} else {
			if ( (endYr - 10) > startYr) {
				startYr = Integer.parseInt((String) stdyyList.get(9).get("stdyy"));
			}
		}
		if (rqstMap.containsKey("searchStdyyEd")) endYr = MapUtils.getIntValue(rqstMap, "searchStdyyEd");		

		mv.addObject("searchIndex", rqstMap.get("searchIndex"));		
				
		List<Map> resultList = new ArrayList();
		int idx = 0;			
		int colmCnt = 0;
		
		for (int i=startYr; i<=endYr; i++) {
			rqstMap.put("searchStdyy", String.valueOf(i));
									
			List<Map> idxList = selectStaticsLisSctn(rqstMap);
				
			if (resultList.size() == 0) {
								
				
				for (int j=0; j<idxList.size(); j++) {										
					Map idxInfo = idxList.get(j);
					
					if(rqstMap.get("searchIndex").equals("A")) {
						colmCnt = 8;
					}else if(rqstMap.get("searchIndex").equals("B")) {						
						colmCnt = 9;
					}else if(rqstMap.get("searchIndex").equals("C")) {						
						colmCnt = 9;
					}else if(rqstMap.get("searchIndex").equals("D")) {						
						colmCnt = 7;
					}else if(rqstMap.get("searchIndex").equals("E")) {						
						colmCnt = 7;
					}else if(rqstMap.get("searchIndex").equals("F")) {						
						colmCnt = 9;			
					}
					for(int k=0; k<colmCnt; k++) {
						resultList.add(idxInfo);
						logger.debug("@@ idxInfo : " + idxInfo);
					}
										
				}
				
			}else {				
				idx++;
				for (int j=0; j<idxList.size(); j++) {
					Map dataInfo = idxList.get(j);
					int pos = j * colmCnt;

					if(rqstMap.get("searchIndex").equals("A")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));
						resultList.get(pos+6).put("y"+idx+"sctn7", dataInfo.get("sctn7"));						
						resultList.get(pos+7).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));
					}else if(rqstMap.get("searchIndex").equals("B")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));
						resultList.get(pos+6).put("y"+idx+"sctn7", dataInfo.get("sctn7"));
						resultList.get(pos+7).put("y"+idx+"sctn8", dataInfo.get("sctn8"));
						resultList.get(pos+8).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));
					}else if(rqstMap.get("searchIndex").equals("C")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));
						resultList.get(pos+6).put("y"+idx+"sctn7", dataInfo.get("sctn7"));
						resultList.get(pos+7).put("y"+idx+"sctn8", dataInfo.get("sctn8"));
						resultList.get(pos+8).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));
					}else if(rqstMap.get("searchIndex").equals("D")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));						
						resultList.get(pos+6).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));
					}else if(rqstMap.get("searchIndex").equals("E")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));						
						resultList.get(pos+6).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));
					}else if(rqstMap.get("searchIndex").equals("F")) {												
						resultList.get(pos).put("y"+idx+"sctn1", dataInfo.get("sctn1"));
						resultList.get(pos+1).put("y"+idx+"sctn2", dataInfo.get("sctn2"));
						resultList.get(pos+2).put("y"+idx+"sctn3", dataInfo.get("sctn3"));
						resultList.get(pos+3).put("y"+idx+"sctn4", dataInfo.get("sctn4"));
						resultList.get(pos+4).put("y"+idx+"sctn5", dataInfo.get("sctn5"));
						resultList.get(pos+5).put("y"+idx+"sctn6", dataInfo.get("sctn6"));
						resultList.get(pos+6).put("y"+idx+"sctn7", dataInfo.get("sctn7"));
						resultList.get(pos+7).put("y"+idx+"sctn8", dataInfo.get("sctn8"));
						resultList.get(pos+8).put("y"+idx+"sctnSum", dataInfo.get("sctnSum"));				
					}
									
				}
			}						
			
		}
						
		mv.addObject("resultList", resultList);						
		
		// 테이블 타이틀 조회
		param = new HashMap();
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrpVal"));
		mv.addObject("tableTitle",codeService.findCodeInfo(param).get("codeNm"));
		mv.addObject("stdyySt", startYr);
		mv.addObject("stdyyEd", endYr);	
				
		return mv;
	}
	
	
	/**
	 * 맵 챠트
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView idxMapChart(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0020_M");
		HashMap param = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));		// 조회조건 : 기업군
		
		String induty_select = "A";
		if (rqstMap.containsKey("induty_select")) param.put("induty_select", rqstMap.get("induty_select"));		// 업종 선택 구분
		
		int sel_target_year=0;
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("sel_target_year")) sel_target_year = MapUtils.getIntValue(rqstMap, "sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(sel_target_year == 0) sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		
		param.put("sel_target_year", sel_target_year);
		
		if (rqstMap.containsKey("induty_select")) param.put("induty_select", rqstMap.get("induty_select"));		// 업종 선택 구분
		if (rqstMap.containsKey("multiSelectGrid1")) param.put("multiSelectGrid1", rqstMap.get("multiSelectGrid1"));
		if (rqstMap.containsKey("multiSelectGrid2")) param.put("multiSelectGrid2", rqstMap.get("multiSelectGrid2"));
		
		if (rqstMap.containsKey("gSelect1")) param.put("gSelect1", rqstMap.get("gSelect1"));
		if (rqstMap.containsKey("gSelect2")) param.put("gSelect2", rqstMap.get("gSelect2"));

		//지표명을 받아 쿼리의 컬럼명으로 사용할것이다
		if (rqstMap.containsKey("induty1")) param.put("induty1", rqstMap.get("induty1"));
		if (rqstMap.containsKey("induty2")) param.put("induty2", rqstMap.get("induty2"));
		
		String gSelect1 = (String) rqstMap.get("gSelect1");		//업종이 그룹일때
		String gSelect2 = (String) rqstMap.get("gSelect2");		//지역이 그룹일때
		
		String tmp1=null;
		String tmp2=null;
		String tmp3=null;
		String[] array_tmp1;
		String[] array_tmp2;
		String[] array_tmp3;
		
		//우선 업종을 받아서
		tmp1 = MapUtils.getString(rqstMap, "multiSelectGrid1");		// (제조, 비제조)
		tmp2 = MapUtils.getString(rqstMap, "multiSelectGrid2");		// (업종테마)
		tmp3 = MapUtils.getString(rqstMap, "multiSelectGrid3");		// (상세업종)
		
		// 선택 or 제조/비제조 구분이라면
		if(tmp1 != null && "A".equals(induty_select) || "I".equals(induty_select)) {
			array_tmp1 = tmp1.split(",");	// ','를 기준으로 잘라서
		
			if(!"null".equals(array_tmp1[0])) {
				for(int i=0; i < array_tmp1.length; i++) {
					if("UT00".equals(array_tmp1[i])) param.put("all_induty", "Y");		// 전산업 선택 시 all_induty : Y 로 넘김(전체)
					if("UT01".equals(array_tmp1[i])) array_tmp1[i] = "제조업";
					if("UT02".equals(array_tmp1[i])) array_tmp1[i] = "비제조업";
					
					
					param.put("multiSelectGrid1", array_tmp1);	// xml에서 사용될 제조/비제조 코드
				}
			// 제조/비제조 검색 시 항목을 선택하지 않았을 때 
			}else if("null".equals(array_tmp1[0])) {
				array_tmp1 = new String[1];
				array_tmp1[0] = "XXX";
				param.put("multiSelectGrid1", array_tmp1);
			}
		}else{
			
			param.put("multiSelectGrid1", null);
		}
		
		// 테마업종 선택한게 있으면 진행
		if(!"null".equals(tmp2) && tmp2 != null && "T".equals(induty_select)) {
			array_tmp2 = tmp2.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_tmp2[0])) {
				for(int i=0; i < array_tmp2.length; i++) {
				}
				
				param.put("multiSelectGrid2", array_tmp2);	// xml에서 사용될 업종테마별 코드
			}
		}else {
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_tmp2 = new String[1];
			array_tmp2[0] = "XXX";
			param.put("multiSelectGrid2", array_tmp2);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		
		// 임시 세팅
		// tmp3 = "A,C10,C12,C13";
		
		// 상세업종 선택한게 있으면 진행
		if(!"null".equals(tmp3) && tmp3 != null && "D".equals(induty_select)) {
			array_tmp3 = tmp3.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_tmp3[0])) {
				for(int i=0; i < array_tmp3.length; i++) {
				}
				
				param.put("multiSelectGrid3", array_tmp3);	// xml에서 사용될 상세업종별 코드
			}
		}else {
			array_tmp3 = new String[1];
			array_tmp3[0] = "XXX";
			param.put("multiSelectGrid3", array_tmp3);
		}
		
		String induty1 = ""; 	//지표1
		String induty2 = ""; 	//지표2
		
		// 지표가 넘어왔을때의 가정 - 테스트 : 기업수, 총매출, 총고용
		tmp1 = "ENTRPRS_CO,SELNG_AM,ORDTM_LABRR_CO";
		
		//지표를 처리한다
		if(tmp1 != null && tmp1 != "") {
			array_tmp1 = tmp1.split(",");	// ','를 기준으로 잘라서
			
			for(int i=0; i < array_tmp1.length; i++) {
			}
		}
		
		if(gSelect1 == null) gSelect1 = "G";
		if(gSelect2 == null) gSelect2 = "G";
		
		//주요지표>현황 조회
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.idxMapChart(param);
		
		GridJsonVO gridJsonVo = new GridJsonVO();
		gridJsonVo.setRows(entprsList);
		
		String searchCondition = param.get("searchCondition").toString();
		
		// 데이터 추가
		mv.addObject("entprsList", entprsList);
		mv.addObject("searchCondition", searchCondition);
		mv.addObject("sel_target_year", sel_target_year);
		mv.addObject("gSelect1", gSelect1);
		mv.addObject("gSelect2", gSelect2);
		mv.addObject("listCnt", entprsList.size());
		
		return mv;
	}
	
	/**
	 * 주요지표 > 현황 챠트
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getGridSttusChart(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0020_1");
		HashMap param = new HashMap();
		Map dataMap = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));		// 조회조건 : 기업군
		param.put("induty_select", MapUtils.getString(rqstMap, "induty_select"));
		param.put("sel_area", MapUtils.getString(rqstMap, "sel_area"));		// 지역 선택 구분(권역별 : A, 지역별 : C)
		if (rqstMap.containsKey("gSelect1")) param.put("gSelect1", rqstMap.get("gSelect1"));
		if (rqstMap.containsKey("gSelect2")) param.put("gSelect2", rqstMap.get("gSelect2"));
		if (rqstMap.containsKey("sel_index_type")) param.put("sel_index_type", rqstMap.get("sel_index_type"));		// 지표 선택 구분
		if (rqstMap.containsKey("ad_index_kind")) param.put("ad_index_kind", rqstMap.get("ad_index_kind"));		// 넘어오는 지표
	
		if("".equals(param.get("induty_select")) || param.get("induty_select") == "") param.put("induty_select", null);
		if("".equals(param.get("sel_area")) || param.get("sel_area") == "") param.put("sel_area", null);
		
		String gSelect1 = (String) rqstMap.get("gSelect1");		//업종이 그룹일때
		String gSelect2 = (String) rqstMap.get("gSelect2");		//지역이 그룹일때
		
		String[] columnNames = null;
		String[] colModelList = null;
		
		String index_type = null;
		String index_kind = null;
		String[] array_index_kind;
		
		if (rqstMap.containsKey("sel_index_type")) index_type = (String) rqstMap.get("sel_index_type");		// 지표구분
		if (rqstMap.containsKey("ad_index_kind")) index_kind = (String) rqstMap.get("ad_index_kind");		// 넘어오는 지표
		
		// 업종, 지역 선택없이 들어왔다면
		if(rqstMap.get("induty_select") == null && rqstMap.get("sel_area") == null) {
			// 화면에 처음 들어온 초기화면일 때
			if (rqstMap.get("gSelect1")==null && rqstMap.get("gSelect2")==null) {
				
				// 컬럼명을 배열형태로
				columnNames = new String[10];
				colModelList = new String[10];
				
				//컬럼명
				columnNames[0] = "권역";
				columnNames[1] = "지역";
				columnNames[2] = "업종/자료";
				columnNames[3] = "기업수(명)";
				columnNames[4] = "매출액(조원)";
				columnNames[5] = "영업이익";
				columnNames[6] = "수출액";
				columnNames[7] = "근로자수";
				columnNames[8] = "R&D집약도";
				columnNames[9] = "당기순이익";
				
				//모델명
				colModelList[0] = "AREA_NM";
				colModelList[1] = "ABRV";
				colModelList[2] = "INDUTY_GUBUN";
				colModelList[3] = "ENTRPRS_CO_SUM";
				colModelList[4] = "SELNG_AM_SUM";
				colModelList[5] = "BSN_PROFIT_SUM";
				colModelList[6] = "XPORT_AM_WON_SUM";
				colModelList[7] = "ORDTM_LABRR_CO_SUM";
				colModelList[8] = "RSRCH_DEVLOP_CT_SUM";
				colModelList[9] = "THSTRM_NTPF_SUM";
				
			}else {
				array_index_kind = index_kind.split(",");
				
				// 컬럼명을 배열형태로
				columnNames = new String[array_index_kind.length];
				colModelList = new String[array_index_kind.length];
				
				if("SUM".equals(index_type)) {
					for(int j=0; j < array_index_kind.length; j++) {
						if("JP01".equals(array_index_kind[j])) {
							columnNames[j] = "기업수(명)";
							colModelList[j] = "ENTRPRS_CO_SUM";
						}else if("JP02".equals(array_index_kind[j])) {
							columnNames[j] = "매출액(조원)";
							colModelList[j] = "SELNG_AM_SUM";
						}else if("JP03".equals(array_index_kind[j])) {
							columnNames[j] = "영업이익";
							colModelList[j] = "BSN_PROFIT_SUM";
						}else if("JP04".equals(array_index_kind[j])) {
							columnNames[j] = "수출액";
							colModelList[j] = "XPORT_AM_WON_SUM";
						}else if("JP05".equals(array_index_kind[j])) {
							columnNames[j] = "근로자수";
							colModelList[j] = "ORDTM_LABRR_CO_SUM";
						}else if("JP06".equals(array_index_kind[j])) {
							columnNames[j] = "R&D집약도";
							colModelList[j] = "RSRCH_DEVLOP_CT_SUM";
						}else if("JP07".equals(array_index_kind[j])) {
							columnNames[j] = "당기순이익";
							colModelList[j] = "THSTRM_NTPF_SUM";
						}
					}
				}else {
					for(int j=0; j < array_index_kind.length; j++) {
						if("JP01".equals(array_index_kind[j])) {
							columnNames[j] = "기업수(명)";
							colModelList[j] = "ENTRPRS_CO_SUM";
						}else if("JP02".equals(array_index_kind[j])) {
							columnNames[j] = "평균매출액(억원)";
							colModelList[j] = "SELNG_AM";
						}else if("JP03".equals(array_index_kind[j])) {
							columnNames[j] = "평균영업이익(억원)";
							colModelList[j] = "BSN_PROFIT";
						}else if("JP04".equals(array_index_kind[j])) {
							columnNames[j] = "평균수출액(억원)";
							colModelList[j] = "XPORT_AM_WON";
						}else if("JP05".equals(array_index_kind[j])) {
							columnNames[j] = "평균근로자수(명)";
							colModelList[j] = "ORDTM_LABRR_CO";
						}else if("JP06".equals(array_index_kind[j])) {
							columnNames[j] = "평균R&D집약도(%)";
							colModelList[j] = "RSRCH_DEVLOP_CT";
						}else if("JP07".equals(array_index_kind[j])) {
							columnNames[j] = "평균당기순이익(명)";
							colModelList[j] = "THSTRM_NTPF";
						}else if("JP08".equals(array_index_kind[j])) {
							columnNames[j] = "평균업력";
							colModelList[j] = "AVRG_CORAGE";
						}
					}
				}
			}
		}else {
			// 화면에 처음 들어온 초기화면일 때
			if (rqstMap.get("gSelect1")==null && rqstMap.get("gSelect2")==null) {
				
				// 컬럼명을 배열형태로
				columnNames = new String[10];
				colModelList = new String[10];
				
				//컬럼명
				columnNames[0] = "권역";
				columnNames[1] = "지역";
				columnNames[2] = "업종/자료";
				columnNames[3] = "기업수(명)";
				columnNames[4] = "매출액(조원)";
				columnNames[5] = "영업이익";
				columnNames[6] = "수출액";
				columnNames[7] = "근로자수";
				columnNames[8] = "R&D집약도";
				columnNames[9] = "당기순이익";
				
				//모델명
				colModelList[0] = "AREA_NM";
				colModelList[1] = "ABRV";
				colModelList[2] = "INDUTY_GUBUN";
				colModelList[3] = "ENTRPRS_CO_SUM";
				colModelList[4] = "SELNG_AM_SUM";
				colModelList[5] = "BSN_PROFIT_SUM";
				colModelList[6] = "XPORT_AM_WON_SUM";
				colModelList[7] = "ORDTM_LABRR_CO_SUM";
				colModelList[8] = "RSRCH_DEVLOP_CT_SUM";
				colModelList[9] = "THSTRM_NTPF_SUM";
				
			}else if (("W".equals(gSelect1) && "W".equals(gSelect2)) || ("G".equals(gSelect1) && "G".equals(gSelect2))) {		// 둘다 조건 or 둘다 그룹
				array_index_kind = index_kind.split(",");
				
				// 컬럼명을 배열형태로
				columnNames = new String[array_index_kind.length];
				colModelList = new String[array_index_kind.length];
				
				int i = 0;
				
				//둘다 null 즉, 전체조회
				if(param.get("induty_select") == null && param.get("sel_area") == null) {
					// 전체조회니까 구분없이 데이터만 보여준다.
					if("SUM".equals(index_type)) {
						for(int j=0; j < array_index_kind.length; j++) {
							if("JP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("JP02".equals(array_index_kind[j])) {
								columnNames[i] = "매출액(조원)";
								colModelList[i] = "SELNG_AM_SUM";
							}else if("JP03".equals(array_index_kind[j])) {
								columnNames[i] = "영업이익(억원)";
								colModelList[i] = "BSN_PROFIT_SUM";
							}else if("JP04".equals(array_index_kind[j])) {
								columnNames[i] = "수출액(억원)";
								colModelList[i] = "XPORT_AM_WON_SUM";
							}else if("JP05".equals(array_index_kind[j])) {
								columnNames[i] = "근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO_SUM";
							}else if("JP06".equals(array_index_kind[j])) {
								columnNames[i] = "R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT_SUM";
							}else if("JP07".equals(array_index_kind[j])) {
								columnNames[i] = "당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF_SUM";
							}
							i++;
						}
					}else {
						for(int j=0; j < array_index_kind.length; j++) {
							if("AJP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("AJP02".equals(array_index_kind[j])) {
								columnNames[i] = "평균매출액(조원)";
								colModelList[i] = "SELNG_AM";
							}else if("AJP03".equals(array_index_kind[j])) {
								columnNames[i] = "평균영업이익(억원)";
								colModelList[i] = "BSN_PROFIT";
							}else if("AJP04".equals(array_index_kind[j])) {
								columnNames[i] = "평균수출액(억원)";
								colModelList[i] = "XPORT_AM_WON";
							}else if("AJP05".equals(array_index_kind[j])) {
								columnNames[i] = "평균근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO";
							}else if("AJP06".equals(array_index_kind[j])) {
								columnNames[i] = "평균R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT";
							}else if("AJP07".equals(array_index_kind[j])) {
								columnNames[i] = "평균당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF";
							}else if("AJP08".equals(array_index_kind[j])) {
								columnNames[i] = "평균업력";
								colModelList[i] = "AVRG_CORAGE";
							}
							i++;
						}
					}
				}
				
				//업종만 선택
				if("I".equals(param.get("induty_select")) && param.get("sel_area") == null) {
					// 컬럼명을 배열형태로
					columnNames = new String[array_index_kind.length+1];
					colModelList = new String[array_index_kind.length+1];
					
					//컬럼명
					columnNames[0] = "업종/자료";
					
					//모델명
					colModelList[0] = "COL1";
					
					i=1;
					
					if("SUM".equals(index_type)) {
						for(int j=0; j < array_index_kind.length; j++) {
							if("JP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("JP02".equals(array_index_kind[j])) {
								columnNames[i] = "매출액(조원)";
								colModelList[i] = "SELNG_AM_SUM";
							}else if("JP03".equals(array_index_kind[j])) {
								columnNames[i] = "영업이익(억원)";
								colModelList[i] = "BSN_PROFIT_SUM";
							}else if("JP04".equals(array_index_kind[j])) {
								columnNames[i] = "수출액(억원)";
								colModelList[i] = "XPORT_AM_WON_SUM";
							}else if("JP05".equals(array_index_kind[j])) {
								columnNames[i] = "근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO_SUM";
							}else if("JP06".equals(array_index_kind[j])) {
								columnNames[i] = "R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT_SUM";
							}else if("JP07".equals(array_index_kind[j])) {
								columnNames[i] = "당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF_SUM";
							}
							i++;
						}
					}else {
						for(int j=0; j < array_index_kind.length; j++) {
							if("AJP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("AJP02".equals(array_index_kind[j])) {
								columnNames[i] = "평균매출액(조원)";
								colModelList[i] = "SELNG_AM";
							}else if("AJP03".equals(array_index_kind[j])) {
								columnNames[i] = "평균영업이익(억원)";
								colModelList[i] = "BSN_PROFIT";
							}else if("AJP04".equals(array_index_kind[j])) {
								columnNames[i] = "평균수출액(억원)";
								colModelList[i] = "XPORT_AM_WON";
							}else if("AJP05".equals(array_index_kind[j])) {
								columnNames[i] = "평균근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO";
							}else if("AJP06".equals(array_index_kind[j])) {
								columnNames[i] = "평균R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT";
							}else if("AJP07".equals(array_index_kind[j])) {
								columnNames[i] = "평균당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF";
							}else if("AJP08".equals(array_index_kind[j])) {
								columnNames[i] = "평균업력";
								colModelList[i] = "AVRG_CORAGE";
							}
							i++;
						}
					}
				}
				
				//권역만 선택
				if(param.get("induty_select") == null && "A".equals(param.get("sel_area"))) {
					// 컬럼명을 배열형태로
					columnNames = new String[array_index_kind.length+1];
					colModelList = new String[array_index_kind.length+1];
					
					//컬럼명
					columnNames[0] = "지역";
					
					//모델명
					colModelList[0] = "AREA1";
					
					i=1;
					
					if("SUM".equals(index_type)) {
						for(int j=0; j < array_index_kind.length; j++) {
							if("JP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("JP02".equals(array_index_kind[j])) {
								columnNames[i] = "매출액(조원)";
								colModelList[i] = "SELNG_AM_SUM";
							}else if("JP03".equals(array_index_kind[j])) {
								columnNames[i] = "영업이익(억원)";
								colModelList[i] = "BSN_PROFIT_SUM";
							}else if("JP04".equals(array_index_kind[j])) {
								columnNames[i] = "수출액(억원)";
								colModelList[i] = "XPORT_AM_WON_SUM";
							}else if("JP05".equals(array_index_kind[j])) {
								columnNames[i] = "근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO_SUM";
							}else if("JP06".equals(array_index_kind[j])) {
								columnNames[i] = "R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT_SUM";
							}else if("JP07".equals(array_index_kind[j])) {
								columnNames[i] = "당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF_SUM";
							}
							i++;
						}
					}else {
						for(int j=0; j < array_index_kind.length; j++) {
							if("AJP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("AJP02".equals(array_index_kind[j])) {
								columnNames[i] = "평균매출액(조원)";
								colModelList[i] = "SELNG_AM";
							}else if("AJP03".equals(array_index_kind[j])) {
								columnNames[i] = "평균영업이익(억원)";
								colModelList[i] = "BSN_PROFIT";
							}else if("AJP04".equals(array_index_kind[j])) {
								columnNames[i] = "평균수출액(억원)";
								colModelList[i] = "XPORT_AM_WON";
							}else if("AJP05".equals(array_index_kind[j])) {
								columnNames[i] = "평균근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO";
							}else if("AJP06".equals(array_index_kind[j])) {
								columnNames[i] = "평균R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT";
							}else if("AJP07".equals(array_index_kind[j])) {
								columnNames[i] = "평균당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF";
							}else if("AJP08".equals(array_index_kind[j])) {
								columnNames[i] = "평균업력";
								colModelList[i] = "AVRG_CORAGE";
							}
							i++;
						}
					}
				}
				
				//지역별만 선택
				if(param.get("induty_select") == null && "C".equals(param.get("sel_area"))) {
					// 컬럼명을 배열형태로
					columnNames = new String[array_index_kind.length+1];
					colModelList = new String[array_index_kind.length+1];
					
					//컬럼명
					columnNames[0] = "지역";
					
					//모델명
					colModelList[0] = "AREA1";
					
					i=1;
					
					if("SUM".equals(index_type)) {
						for(int j=0; j < array_index_kind.length; j++) {
							if("JP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("JP02".equals(array_index_kind[j])) {
								columnNames[i] = "매출액(조원)";
								colModelList[i] = "SELNG_AM_SUM";
							}else if("JP03".equals(array_index_kind[j])) {
								columnNames[i] = "영업이익(억원)";
								colModelList[i] = "BSN_PROFIT_SUM";
							}else if("JP04".equals(array_index_kind[j])) {
								columnNames[i] = "수출액(억원)";
								colModelList[i] = "XPORT_AM_WON_SUM";
							}else if("JP05".equals(array_index_kind[j])) {
								columnNames[i] = "근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO_SUM";
							}else if("JP06".equals(array_index_kind[j])) {
								columnNames[i] = "R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT_SUM";
							}else if("JP07".equals(array_index_kind[j])) {
								columnNames[i] = "당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF_SUM";
							}
							i++;
						}
					}else {
						for(int j=0; j < array_index_kind.length; j++) {
							if("AJP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("AJP02".equals(array_index_kind[j])) {
								columnNames[i] = "평균매출액(조원)";
								colModelList[i] = "SELNG_AM";
							}else if("AJP03".equals(array_index_kind[j])) {
								columnNames[i] = "평균영업이익(억원)";
								colModelList[i] = "BSN_PROFIT";
							}else if("AJP04".equals(array_index_kind[j])) {
								columnNames[i] = "평균수출액(억원)";
								colModelList[i] = "XPORT_AM_WON";
							}else if("AJP05".equals(array_index_kind[j])) {
								columnNames[i] = "평균근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO";
							}else if("AJP06".equals(array_index_kind[j])) {
								columnNames[i] = "평균R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT";
							}else if("AJP07".equals(array_index_kind[j])) {
								columnNames[i] = "평균당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF";
							}else if("AJP08".equals(array_index_kind[j])) {
								columnNames[i] = "평균업력";
								colModelList[i] = "AVRG_CORAGE";
							}
							i++;
						}
					}
				}
				
				// 업종 + 권역
				if("I".equals(param.get("induty_select")) && "A".equals(param.get("sel_area"))) {
					// 컬럼명을 배열형태로
					columnNames = new String[array_index_kind.length+3];
					colModelList = new String[array_index_kind.length+3];
					
					//컬럼명
					columnNames[0] = "권역";
					columnNames[1] = "지역";
					columnNames[2] = "업종/자료";
					
					//모델명
					colModelList[0] = "AREA_NM";
					colModelList[1] = "ABRV";
					colModelList[2] = "COL1";
					
					i=3;
					
					if("SUM".equals(index_type)) {
						for(int j=0; j < array_index_kind.length; j++) {
							if("JP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("JP02".equals(array_index_kind[j])) {
								columnNames[i] = "매출액(조원)";
								colModelList[i] = "SELNG_AM_SUM";
							}else if("JP03".equals(array_index_kind[j])) {
								columnNames[i] = "영업이익(억원)";
								colModelList[i] = "BSN_PROFIT_SUM";
							}else if("JP04".equals(array_index_kind[j])) {
								columnNames[i] = "수출액(억원)";
								colModelList[i] = "XPORT_AM_WON_SUM";
							}else if("JP05".equals(array_index_kind[j])) {
								columnNames[i] = "근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO_SUM";
							}else if("JP06".equals(array_index_kind[j])) {
								columnNames[i] = "R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT_SUM";
							}else if("JP07".equals(array_index_kind[j])) {
								columnNames[i] = "당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF_SUM";
							}
							i++;
						}
					}else {
						for(int j=0; j < array_index_kind.length; j++) {
							if("AJP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("AJP02".equals(array_index_kind[j])) {
								columnNames[i] = "평균매출액(조원)";
								colModelList[i] = "SELNG_AM";
							}else if("AJP03".equals(array_index_kind[j])) {
								columnNames[i] = "평균영업이익(억원)";
								colModelList[i] = "BSN_PROFIT";
							}else if("AJP04".equals(array_index_kind[j])) {
								columnNames[i] = "평균수출액(억원)";
								colModelList[i] = "XPORT_AM_WON";
							}else if("AJP05".equals(array_index_kind[j])) {
								columnNames[i] = "평균근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO";
							}else if("AJP06".equals(array_index_kind[j])) {
								columnNames[i] = "평균R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT";
							}else if("AJP07".equals(array_index_kind[j])) {
								columnNames[i] = "평균당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF";
							}else if("AJP08".equals(array_index_kind[j])) {
								columnNames[i] = "평균업력";
								colModelList[i] = "AVRG_CORAGE";
							}
							i++;
						}
					}
				}
				
				// 업종 + 지역
				if("I".equals(param.get("induty_select")) && "C".equals(param.get("sel_area"))) {
					// 컬럼명을 배열형태로
					columnNames = new String[array_index_kind.length+2];
					colModelList = new String[array_index_kind.length+2];
					
					//컬럼명
					columnNames[0] = "지역";
					columnNames[1] = "업종/자료";
					
					//모델명
					colModelList[0] = "ABRV";
					colModelList[1] = "COL1";
					
					i=2;
					
					if("SUM".equals(index_type)) {
						for(int j=0; j < array_index_kind.length; j++) {
							if("JP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("JP02".equals(array_index_kind[j])) {
								columnNames[i] = "매출액(조원)";
								colModelList[i] = "SELNG_AM_SUM";
							}else if("JP03".equals(array_index_kind[j])) {
								columnNames[i] = "영업이익(억원)";
								colModelList[i] = "BSN_PROFIT_SUM";
							}else if("JP04".equals(array_index_kind[j])) {
								columnNames[i] = "수출액(억원)";
								colModelList[i] = "XPORT_AM_WON_SUM";
							}else if("JP05".equals(array_index_kind[j])) {
								columnNames[i] = "근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO_SUM";
							}else if("JP06".equals(array_index_kind[j])) {
								columnNames[i] = "R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT_SUM";
							}else if("JP07".equals(array_index_kind[j])) {
								columnNames[i] = "당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF_SUM";
							}
							i++;
						}
					}else {
						for(int j=0; j < array_index_kind.length; j++) {
							if("AJP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("AJP02".equals(array_index_kind[j])) {
								columnNames[i] = "평균매출액(조원)";
								colModelList[i] = "SELNG_AM";
							}else if("AJP03".equals(array_index_kind[j])) {
								columnNames[i] = "평균영업이익(억원)";
								colModelList[i] = "BSN_PROFIT";
							}else if("AJP04".equals(array_index_kind[j])) {
								columnNames[i] = "평균수출액(억원)";
								colModelList[i] = "XPORT_AM_WON";
							}else if("AJP05".equals(array_index_kind[j])) {
								columnNames[i] = "평균근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO";
							}else if("AJP06".equals(array_index_kind[j])) {
								columnNames[i] = "평균R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT";
							}else if("AJP07".equals(array_index_kind[j])) {
								columnNames[i] = "평균당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF";
							}else if("AJP08".equals(array_index_kind[j])) {
								columnNames[i] = "평균업력";
								colModelList[i] = "AVRG_CORAGE";
							}
							i++;
						}
					}
				}
				
				// 테마 + null
				if("T".equals(param.get("induty_select")) && param.get("sel_area") == null) {
					
					// 컬럼명을 배열형태로
					columnNames = new String[array_index_kind.length+1];
					colModelList = new String[array_index_kind.length+1];
					
					//컬럼명
					columnNames[0] = "업종";
					
					//모델명
					colModelList[0] = "COL1";
					
					i=1;
					
					if("SUM".equals(index_type)) {
						for(int j=0; j < array_index_kind.length; j++) {
							if("JP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("JP02".equals(array_index_kind[j])) {
								columnNames[i] = "매출액(조원)";
								colModelList[i] = "SELNG_AM_SUM";
							}else if("JP03".equals(array_index_kind[j])) {
								columnNames[i] = "영업이익(억원)";
								colModelList[i] = "BSN_PROFIT_SUM";
							}else if("JP04".equals(array_index_kind[j])) {
								columnNames[i] = "수출액(억원)";
								colModelList[i] = "XPORT_AM_WON_SUM";
							}else if("JP05".equals(array_index_kind[j])) {
								columnNames[i] = "근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO_SUM";
							}else if("JP06".equals(array_index_kind[j])) {
								columnNames[i] = "R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT_SUM";
							}else if("JP07".equals(array_index_kind[j])) {
								columnNames[i] = "당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF_SUM";
							}
							i++;
						}
					}else {
						for(int j=0; j < array_index_kind.length; j++) {
							if("AJP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("AJP02".equals(array_index_kind[j])) {
								columnNames[i] = "평균매출액(조원)";
								colModelList[i] = "SELNG_AM";
							}else if("AJP03".equals(array_index_kind[j])) {
								columnNames[i] = "평균영업이익(억원)";
								colModelList[i] = "BSN_PROFIT";
							}else if("AJP04".equals(array_index_kind[j])) {
								columnNames[i] = "평균수출액(억원)";
								colModelList[i] = "XPORT_AM_WON";
							}else if("AJP05".equals(array_index_kind[j])) {
								columnNames[i] = "평균근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO";
							}else if("AJP06".equals(array_index_kind[j])) {
								columnNames[i] = "평균R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT";
							}else if("AJP07".equals(array_index_kind[j])) {
								columnNames[i] = "평균당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF";
							}else if("AJP08".equals(array_index_kind[j])) {
								columnNames[i] = "평균업력";
								colModelList[i] = "AVRG_CORAGE";
							}
							i++;
						}
					}
				}
				
				// 테마 + 권역
				if("T".equals(param.get("induty_select")) && "A".equals(param.get("sel_area"))) {
					// 컬럼명을 배열형태로
					columnNames = new String[array_index_kind.length+3];
					colModelList = new String[array_index_kind.length+3];
					
					//컬럼명
					columnNames[0] = "권역";
					columnNames[1] = "지역";
					columnNames[2] = "업종/자료";
					
					//모델명
					colModelList[0] = "AREA_NM";
					colModelList[1] = "ABRV";
					colModelList[2] = "COL1";
					
					i=3;
					
					if("SUM".equals(index_type)) {
						for(int j=0; j < array_index_kind.length; j++) {
							if("JP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("JP02".equals(array_index_kind[j])) {
								columnNames[i] = "매출액(조원)";
								colModelList[i] = "SELNG_AM_SUM";
							}else if("JP03".equals(array_index_kind[j])) {
								columnNames[i] = "영업이익(억원)";
								colModelList[i] = "BSN_PROFIT_SUM";
							}else if("JP04".equals(array_index_kind[j])) {
								columnNames[i] = "수출액(억원)";
								colModelList[i] = "XPORT_AM_WON_SUM";
							}else if("JP05".equals(array_index_kind[j])) {
								columnNames[i] = "근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO_SUM";
							}else if("JP06".equals(array_index_kind[j])) {
								columnNames[i] = "R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT_SUM";
							}else if("JP07".equals(array_index_kind[j])) {
								columnNames[i] = "당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF_SUM";
							}
							i++;
						}
					}else {
						for(int j=0; j < array_index_kind.length; j++) {
							if("AJP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("AJP02".equals(array_index_kind[j])) {
								columnNames[i] = "평균매출액(조원)";
								colModelList[i] = "SELNG_AM";
							}else if("AJP03".equals(array_index_kind[j])) {
								columnNames[i] = "평균영업이익(억원)";
								colModelList[i] = "BSN_PROFIT";
							}else if("AJP04".equals(array_index_kind[j])) {
								columnNames[i] = "평균수출액(억원)";
								colModelList[i] = "XPORT_AM_WON";
							}else if("AJP05".equals(array_index_kind[j])) {
								columnNames[i] = "평균근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO";
							}else if("AJP06".equals(array_index_kind[j])) {
								columnNames[i] = "평균R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT";
							}else if("AJP07".equals(array_index_kind[j])) {
								columnNames[i] = "평균당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF";
							}else if("AJP08".equals(array_index_kind[j])) {
								columnNames[i] = "평균업력";
								colModelList[i] = "AVRG_CORAGE";
							}
							i++;
						}
					}
				}
				
				// 테마 + 지역
				if("T".equals(param.get("induty_select")) && "C".equals(param.get("sel_area"))) {
					// 컬럼명을 배열형태로
					columnNames = new String[array_index_kind.length+3];
					colModelList = new String[array_index_kind.length+3];
					
					//컬럼명
					columnNames[0] = "권역";
					columnNames[1] = "지역";
					columnNames[2] = "업종/자료";
					
					//모델명
					colModelList[0] = "AREA_NM";
					colModelList[1] = "ABRV";
					colModelList[2] = "COL1";
					
					i=3;
					
					if("SUM".equals(index_type)) {
						for(int j=0; j < array_index_kind.length; j++) {
							if("JP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("JP02".equals(array_index_kind[j])) {
								columnNames[i] = "매출액(조원)";
								colModelList[i] = "SELNG_AM_SUM";
							}else if("JP03".equals(array_index_kind[j])) {
								columnNames[i] = "영업이익(억원)";
								colModelList[i] = "BSN_PROFIT_SUM";
							}else if("JP04".equals(array_index_kind[j])) {
								columnNames[i] = "수출액(억원)";
								colModelList[i] = "XPORT_AM_WON_SUM";
							}else if("JP05".equals(array_index_kind[j])) {
								columnNames[i] = "근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO_SUM";
							}else if("JP06".equals(array_index_kind[j])) {
								columnNames[i] = "R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT_SUM";
							}else if("JP07".equals(array_index_kind[j])) {
								columnNames[i] = "당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF_SUM";
							}
							i++;
						}
					}else {
						for(int j=0; j < array_index_kind.length; j++) {
							if("AJP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("AJP02".equals(array_index_kind[j])) {
								columnNames[i] = "평균매출액(조원)";
								colModelList[i] = "SELNG_AM";
							}else if("AJP03".equals(array_index_kind[j])) {
								columnNames[i] = "평균영업이익(억원)";
								colModelList[i] = "BSN_PROFIT";
							}else if("AJP04".equals(array_index_kind[j])) {
								columnNames[i] = "평균수출액(억원)";
								colModelList[i] = "XPORT_AM_WON";
							}else if("AJP05".equals(array_index_kind[j])) {
								columnNames[i] = "평균근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO";
							}else if("AJP06".equals(array_index_kind[j])) {
								columnNames[i] = "평균R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT";
							}else if("AJP07".equals(array_index_kind[j])) {
								columnNames[i] = "평균당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF";
							}else if("AJP08".equals(array_index_kind[j])) {
								columnNames[i] = "평균업력";
								colModelList[i] = "AVRG_CORAGE";
							}
							i++;
						}
					}
				}
				
				// 상세 + null
				if("D".equals(param.get("induty_select")) && param.get("sel_area") == null) {
					// 컬럼명을 배열형태로
					columnNames = new String[array_index_kind.length+1];
					colModelList = new String[array_index_kind.length+1];
					
					//컬럼명
					columnNames[0] = "업종";
					
					//모델명
					colModelList[0] = "COL1";
					
					i=1;
					
					if("SUM".equals(index_type)) {
						for(int j=0; j < array_index_kind.length; j++) {
							if("JP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("JP02".equals(array_index_kind[j])) {
								columnNames[i] = "매출액(조원)";
								colModelList[i] = "SELNG_AM_SUM";
							}else if("JP03".equals(array_index_kind[j])) {
								columnNames[i] = "영업이익(억원)";
								colModelList[i] = "BSN_PROFIT_SUM";
							}else if("JP04".equals(array_index_kind[j])) {
								columnNames[i] = "수출액(억원)";
								colModelList[i] = "XPORT_AM_WON_SUM";
							}else if("JP05".equals(array_index_kind[j])) {
								columnNames[i] = "근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO_SUM";
							}else if("JP06".equals(array_index_kind[j])) {
								columnNames[i] = "R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT_SUM";
							}else if("JP07".equals(array_index_kind[j])) {
								columnNames[i] = "당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF_SUM";
							}
							i++;
						}
					}else {
						for(int j=0; j < array_index_kind.length; j++) {
							if("AJP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("AJP02".equals(array_index_kind[j])) {
								columnNames[i] = "평균매출액(조원)";
								colModelList[i] = "SELNG_AM";
							}else if("AJP03".equals(array_index_kind[j])) {
								columnNames[i] = "평균영업이익(억원)";
								colModelList[i] = "BSN_PROFIT";
							}else if("AJP04".equals(array_index_kind[j])) {
								columnNames[i] = "평균수출액(억원)";
								colModelList[i] = "XPORT_AM_WON";
							}else if("AJP05".equals(array_index_kind[j])) {
								columnNames[i] = "평균근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO";
							}else if("AJP06".equals(array_index_kind[j])) {
								columnNames[i] = "평균R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT";
							}else if("AJP07".equals(array_index_kind[j])) {
								columnNames[i] = "평균당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF";
							}else if("AJP08".equals(array_index_kind[j])) {
								columnNames[i] = "평균업력";
								colModelList[i] = "AVRG_CORAGE";
							}
							i++;
						}
					}
				}
				
				// 상세 + 권역
				if("D".equals(param.get("induty_select")) && "A".equals(param.get("sel_area"))) {
					// 컬럼명을 배열형태로
					columnNames = new String[array_index_kind.length+3];
					colModelList = new String[array_index_kind.length+3];
					
					//컬럼명
					columnNames[0] = "권역";
					columnNames[1] = "지역";
					columnNames[2] = "업종/자료";
					
					//모델명
					colModelList[0] = "AREA_NM";
					colModelList[1] = "ABRV";
					colModelList[2] = "COL1";
					
					i=3;
					
					if("SUM".equals(index_type)) {
						for(int j=0; j < array_index_kind.length; j++) {
							if("JP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("JP02".equals(array_index_kind[j])) {
								columnNames[i] = "매출액(조원)";
								colModelList[i] = "SELNG_AM_SUM";
							}else if("JP03".equals(array_index_kind[j])) {
								columnNames[i] = "영업이익(억원)";
								colModelList[i] = "BSN_PROFIT_SUM";
							}else if("JP04".equals(array_index_kind[j])) {
								columnNames[i] = "수출액(억원)";
								colModelList[i] = "XPORT_AM_WON_SUM";
							}else if("JP05".equals(array_index_kind[j])) {
								columnNames[i] = "근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO_SUM";
							}else if("JP06".equals(array_index_kind[j])) {
								columnNames[i] = "R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT_SUM";
							}else if("JP07".equals(array_index_kind[j])) {
								columnNames[i] = "당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF_SUM";
							}
							i++;
						}
					}else {
						for(int j=0; j < array_index_kind.length; j++) {
							if("AJP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("AJP02".equals(array_index_kind[j])) {
								columnNames[i] = "평균매출액(조원)";
								colModelList[i] = "SELNG_AM";
							}else if("AJP03".equals(array_index_kind[j])) {
								columnNames[i] = "평균영업이익(억원)";
								colModelList[i] = "BSN_PROFIT";
							}else if("AJP04".equals(array_index_kind[j])) {
								columnNames[i] = "평균수출액(억원)";
								colModelList[i] = "XPORT_AM_WON";
							}else if("AJP05".equals(array_index_kind[j])) {
								columnNames[i] = "평균근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO";
							}else if("AJP06".equals(array_index_kind[j])) {
								columnNames[i] = "평균R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT";
							}else if("AJP07".equals(array_index_kind[j])) {
								columnNames[i] = "평균당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF";
							}else if("AJP08".equals(array_index_kind[j])) {
								columnNames[i] = "평균업력";
								colModelList[i] = "AVRG_CORAGE";
							}
							i++;
						}
					}
				}
				
				// 상세 + 지역
				if("D".equals(param.get("induty_select")) && "C".equals(param.get("sel_area"))) {
					// 컬럼명을 배열형태로
					columnNames = new String[array_index_kind.length+2];
					colModelList = new String[array_index_kind.length+2];
					
					//컬럼명
					columnNames[0] = "지역";
					columnNames[1] = "업종/자료";
					
					//모델명
					colModelList[0] = "ABRV";
					colModelList[1] = "COL1";
					
					i=2;
					
					if("SUM".equals(index_type)) {
						for(int j=0; j < array_index_kind.length; j++) {
							if("JP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("JP02".equals(array_index_kind[j])) {
								columnNames[i] = "매출액(조원)";
								colModelList[i] = "SELNG_AM_SUM";
							}else if("JP03".equals(array_index_kind[j])) {
								columnNames[i] = "영업이익(억원)";
								colModelList[i] = "BSN_PROFIT_SUM";
							}else if("JP04".equals(array_index_kind[j])) {
								columnNames[i] = "수출액(억원)";
								colModelList[i] = "XPORT_AM_WON_SUM";
							}else if("JP05".equals(array_index_kind[j])) {
								columnNames[i] = "근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO_SUM";
							}else if("JP06".equals(array_index_kind[j])) {
								columnNames[i] = "R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT_SUM";
							}else if("JP07".equals(array_index_kind[j])) {
								columnNames[i] = "당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF_SUM";
							}
							i++;
						}
					}else {
						for(int j=0; j < array_index_kind.length; j++) {
							if("AJP01".equals(array_index_kind[j])) {
								columnNames[i] = "기업수(개)";
								colModelList[i] = "ENTRPRS_CO_SUM";
							}else if("AJP02".equals(array_index_kind[j])) {
								columnNames[i] = "평균매출액(조원)";
								colModelList[i] = "SELNG_AM";
							}else if("AJP03".equals(array_index_kind[j])) {
								columnNames[i] = "평균영업이익(억원)";
								colModelList[i] = "BSN_PROFIT";
							}else if("AJP04".equals(array_index_kind[j])) {
								columnNames[i] = "평균수출액(억원)";
								colModelList[i] = "XPORT_AM_WON";
							}else if("AJP05".equals(array_index_kind[j])) {
								columnNames[i] = "평균근로자수(명)";
								colModelList[i] = "ORDTM_LABRR_CO";
							}else if("AJP06".equals(array_index_kind[j])) {
								columnNames[i] = "평균R&D집약도(%)";
								colModelList[i] = "RSRCH_DEVLOP_CT";
							}else if("AJP07".equals(array_index_kind[j])) {
								columnNames[i] = "평균당기순이익(억원)";
								colModelList[i] = "THSTRM_NTPF";
							}else if("AJP08".equals(array_index_kind[j])) {
								columnNames[i] = "평균업력";
								colModelList[i] = "AVRG_CORAGE";
							}
							i++;
						}
					}
				}
				
			//업종 그룹
			}else if ("G".equals(gSelect1) && ("W".equals(gSelect2) || gSelect2 == null)) {
				array_index_kind = index_kind.split(",");
				
				// 컬럼명을 배열형태로
				columnNames = new String[array_index_kind.length+1];
				colModelList = new String[array_index_kind.length+1];
				
				//컬럼명
				columnNames[0] = "업종/자료";
				
				//모델명
				colModelList[0] = "COL1";
				
				if("SUM".equals(index_type)) {
					int i = 1;
					for(int j=0; j < array_index_kind.length; j++) {
						if("JP01".equals(array_index_kind[j])) {
							columnNames[i] = "기업수(개)";
							colModelList[i] = "ENTRPRS_CO_SUM";
						}else if("JP02".equals(array_index_kind[j])) {
							columnNames[i] = "매출액(조원)";
							colModelList[i] = "SELNG_AM_SUM";
						}else if("JP03".equals(array_index_kind[j])) {
							columnNames[i] = "영업이익(억원)";
							colModelList[i] = "BSN_PROFIT_SUM";
						}else if("JP04".equals(array_index_kind[j])) {
							columnNames[i] = "수출액(억원)";
							colModelList[i] = "XPORT_AM_WON_SUM";
						}else if("JP05".equals(array_index_kind[j])) {
							columnNames[i] = "근로자수(명)";
							colModelList[i] = "ORDTM_LABRR_CO_SUM";
						}else if("JP06".equals(array_index_kind[j])) {
							columnNames[i] = "R&D집약도(%)";
							colModelList[i] = "RSRCH_DEVLOP_CT_SUM";
						}else if("JP07".equals(array_index_kind[j])) {
							columnNames[i] = "당기순이익(억원)";
							colModelList[i] = "THSTRM_NTPF_SUM";
						}
						i++;
					}
				}else {
					int i = 1;
					for(int j=0; j < array_index_kind.length; j++) {
						if("AJP01".equals(array_index_kind[j])) {
							columnNames[i] = "기업수(개)";
							colModelList[i] = "ENTRPRS_CO_SUM";
						}else if("AJP02".equals(array_index_kind[j])) {
							columnNames[i] = "평균매출액(조원)";
							colModelList[i] = "SELNG_AM";
						}else if("AJP03".equals(array_index_kind[j])) {
							columnNames[i] = "평균영업이익(억원)";
							colModelList[i] = "BSN_PROFIT";
						}else if("AJP04".equals(array_index_kind[j])) {
							columnNames[i] = "평균수출액(억원)";
							colModelList[i] = "XPORT_AM_WON";
						}else if("AJP05".equals(array_index_kind[j])) {
							columnNames[i] = "평균근로자수(명)";
							colModelList[i] = "ORDTM_LABRR_CO";
						}else if("AJP06".equals(array_index_kind[j])) {
							columnNames[i] = "평균R&D집약도(%)";
							colModelList[i] = "RSRCH_DEVLOP_CT";
						}else if("AJP07".equals(array_index_kind[j])) {
							columnNames[i] = "평균당기순이익(억원)";
							colModelList[i] = "THSTRM_NTPF";
						}else if("AJP08".equals(array_index_kind[j])) {
							columnNames[i] = "평균업력";
							colModelList[i] = "AVRG_CORAGE";
						}
						i++;
					}
				}
				
			//지역 그룹
			}else if (("W".equals(gSelect1) || gSelect1 == null) && "G".equals(gSelect2)) {
				array_index_kind = index_kind.split(",");
				
				// 컬럼명을 배열형태로
				columnNames = new String[array_index_kind.length+1];
				colModelList = new String[array_index_kind.length+1];
				
				//컬럼명
				columnNames[0] = "지역";
				
				//모델명
				colModelList[0] = "AREA1";
				
				if("SUM".equals(index_type)) {
					int i = 1;
					for(int j=0; j < array_index_kind.length; j++) {
						if("JP01".equals(array_index_kind[j])) {
							columnNames[i] = "기업수(개)";
							colModelList[i] = "ENTRPRS_CO_SUM";
						}else if("JP02".equals(array_index_kind[j])) {
							columnNames[i] = "매출액(조원)";
							colModelList[i] = "SELNG_AM_SUM";
						}else if("JP03".equals(array_index_kind[j])) {
							columnNames[i] = "영업이익(억원)";
							colModelList[i] = "BSN_PROFIT_SUM";
						}else if("JP04".equals(array_index_kind[j])) {
							columnNames[i] = "수출액(억원)";
							colModelList[i] = "XPORT_AM_WON_SUM";
						}else if("JP05".equals(array_index_kind[j])) {
							columnNames[i] = "근로자수(명)";
							colModelList[i] = "ORDTM_LABRR_CO_SUM";
						}else if("JP06".equals(array_index_kind[j])) {
							columnNames[i] = "R&D집약도(%)";
							colModelList[i] = "RSRCH_DEVLOP_CT_SUM";
						}else if("JP07".equals(array_index_kind[j])) {
							columnNames[i] = "당기순이익(억원)";
							colModelList[i] = "THSTRM_NTPF_SUM";
						}
						i++;
					}
				}else {
					int i = 1;
					for(int j=0; j < array_index_kind.length; j++) {
						if("AJP01".equals(array_index_kind[j])) {
							columnNames[i] = "기업수(개)";
							colModelList[i] = "ENTRPRS_CO_SUM";
						}else if("AJP02".equals(array_index_kind[j])) {
							columnNames[i] = "평균매출액(조원)";
							colModelList[i] = "SELNG_AM";
						}else if("AJP03".equals(array_index_kind[j])) {
							columnNames[i] = "평균영업이익(억원)";
							colModelList[i] = "BSN_PROFIT";
						}else if("AJP04".equals(array_index_kind[j])) {
							columnNames[i] = "평균수출액(억원)";
							colModelList[i] = "XPORT_AM_WON";
						}else if("AJP05".equals(array_index_kind[j])) {
							columnNames[i] = "평균근로자수(명)";
							colModelList[i] = "ORDTM_LABRR_CO";
						}else if("AJP06".equals(array_index_kind[j])) {
							columnNames[i] = "평균R&D집약도(%)";
							colModelList[i] = "RSRCH_DEVLOP_CT";
						}else if("AJP07".equals(array_index_kind[j])) {
							columnNames[i] = "평균당기순이익(억원)";
							colModelList[i] = "THSTRM_NTPF";
						}else if("AJP08".equals(array_index_kind[j])) {
							columnNames[i] = "평균업력";
							colModelList[i] = "AVRG_CORAGE";
						}
						i++;
					}
				}
			} // 그룹체크 if문 끝
			
		}
		
		
		// --------------------- 데이터 부분 ---------------------
		int sel_target_year=0;
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("sel_target_year")) sel_target_year = MapUtils.getIntValue(rqstMap, "sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(sel_target_year == 0) sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		
		param.put("sel_target_year", sel_target_year);
		
		if (rqstMap.containsKey("gSelect1")) param.put("gSelect1", rqstMap.get("gSelect1"));
		if (rqstMap.containsKey("gSelect2")) param.put("gSelect2", rqstMap.get("gSelect2"));
		
		String tmp1=null;
		String tmp2=null;
		String tmp3=null;
		String[] array_tmp1;
		String[] array_tmp2;
		String[] array_tmp3;
		
		//우선 업종을 받아서
		tmp1 = MapUtils.getString(rqstMap, "multiSelectGrid1");		// (제조, 비제조)
		tmp2 = MapUtils.getString(rqstMap, "multiSelectGrid2");		// (업종테마)
		tmp3 = MapUtils.getString(rqstMap, "ad_ind_cd");		// (상세업종)
		
		String induty_select = null;
		if (rqstMap.containsKey("induty_select")) induty_select = (String) rqstMap.get("induty_select");		// 업종 선택 구분
		
		// 선택 or 제조/비제조 구분이라면
		if(tmp1 != null && "A".equals(induty_select) || "I".equals(induty_select)) {
			array_tmp1 = tmp1.split(",");	// ','를 기준으로 잘라서
		
			if(!"null".equals(array_tmp1[0])) {
				for(int i=0; i < array_tmp1.length; i++) {
					if("UT00".equals(array_tmp1[i])) param.put("all_induty", "Y");		// 전산업 선택 시 all_induty : Y 로 넘김(전체)
					if("UT01".equals(array_tmp1[i])) array_tmp1[i] = "제조업";
					if("UT02".equals(array_tmp1[i])) array_tmp1[i] = "비제조업";
					
					param.put("multiSelectGrid1", array_tmp1);	// xml에서 사용될 제조/비제조 코드
				}
			// 제조/비제조 검색 시 항목을 선택하지 않았을 때 
			}else if("null".equals(array_tmp1[0])) {
				array_tmp1 = new String[1];
				array_tmp1[0] = "XXX";
				param.put("multiSelectGrid1", array_tmp1);
			}
		}else{
			
			param.put("multiSelectGrid1", null);
		}
		
		// 테마업종 선택한게 있으면 진행
		if(!"null".equals(tmp2) && tmp2 != null && "T".equals(induty_select)) {
			array_tmp2 = tmp2.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_tmp2[0])) {
				for(int i=0; i < array_tmp2.length; i++) {
				}
				
				param.put("multiSelectGrid2", array_tmp2);	// xml에서 사용될 업종테마별 코드
			}
		}else {
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_tmp2 = new String[1];
			array_tmp2[0] = "YYY";
			param.put("multiSelectGrid2", array_tmp2);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		
		// 임시 세팅
		// tmp3 = "A,C10,C12,C13";
		// 상세업종 선택한게 있으면 진행
		if(!"null".equals(tmp3) && tmp3 != null && "D".equals(induty_select)) {
			array_tmp3 = tmp3.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_tmp3[0])) {
				for(int i=0; i < array_tmp3.length; i++) {
					//array_tmp3[i] = array_tmp3[i].substring(array_tmp3[i].indexOf(":"), array_tmp3[i].length());
					array_tmp3[i] = array_tmp3[i].substring(0, array_tmp3[i].indexOf(":"));
				}
				
				param.put("multiSelectGrid3", array_tmp3);	// xml에서 사용될 상세업종별 코드
			}
		}else {
			array_tmp3 = new String[1];
			array_tmp3[0] = "ZZZ";
			param.put("multiSelectGrid3", array_tmp3);
		}
		
		
		if (rqstMap.containsKey("sel_index_type")) index_type = (String) rqstMap.get("sel_index_type");		// 지표구분
		if (rqstMap.containsKey("ad_index_kind")) index_kind = (String) rqstMap.get("ad_index_kind");		// 넘어오는 지표
		
		//지표를 처리한다
		if(rqstMap.get("ad_index_kind") != null && rqstMap.get("ad_index_kind") != "") {
			array_index_kind = index_kind.split(",");	// ','를 기준으로 잘라서
			
			param.put("array_index_kind", array_index_kind);
		}
		
		String sel_area = (String) rqstMap.get("sel_area");			// 지역 구분 선택 (권역별, 지역별)
		String area_sel = (String) rqstMap.get("cmpn_area_depth1");			// 권역별 선택값
		String city_sel = (String) rqstMap.get("cmpn_area_depth2");			// 지역별 선택값
		String[] array_area;
		String[] array_city;
		
		// 권역별 선택이 넘어온게 있으면
		if(!"null".equals(sel_area) && sel_area != null && sel_area !="" && "A".equals(sel_area) && !"null".equals(area_sel) && area_sel != null) {
			array_area = area_sel.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_area[0])) {
				for(int i=0; i < array_area.length; i++) {
				}
				
				param.put("cmpn_area_depth1", array_area);	// xml에서 사용될 권역별 코드
			}
		}else{
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_area = new String[1];
			array_area[0] = "XXX";
			param.put("cmpn_area_depth1", array_area);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		// 지역별 선택이 넘어온게 있으면
		if(!"null".equals(sel_area) && sel_area != null && sel_area !="" && "C".equals(sel_area) && !"null".equals(city_sel) && city_sel != null) {
			array_city = city_sel.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_city[0])) {
				for(int i=0; i < array_city.length; i++) {
				}
				
				param.put("cmpn_area_depth2", array_city);	// xml에서 사용될 권역별 코드
			}
		}else{
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_city = new String[1];
			array_city[0] = "XXX";
			param.put("cmpn_area_depth2", array_city);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		
		
		//주요지표>현황 조회
		List<Map> entprsList = new ArrayList<Map>();
		
		if("W".equals(gSelect1) && "W".equals(gSelect2) && param.get("sel_area") == null && param.get("induty_select") == null){
			entprsList = entprsDAO.idxListAll(param);
		}else {
			entprsList = entprsDAO.idxList(param);
		}
		
		
		
		dataMap.put("colModelList", colModelList);
		dataMap.put("columnNames", columnNames);

		dataMap.put("sel_index_type", index_type);		// 지표 선택 구분
		dataMap.put("induty_select", param.get("induty_select"));		// 업종 선택 구분
		dataMap.put("sel_area", param.get("sel_area"));		//지역선택
		
		// 데이터 추가
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchCondition"));
		
		mv.addObject("searchEntprsGrp",codeService.findCodeInfo(param).get("codeNm"));
		
		mv.addObject("sel_target_year", sel_target_year);
		mv.addObject("listCnt", entprsList.size());
		mv.addObject("colModelList", colModelList);
		mv.addObject("columnNames", columnNames);
		
		mv.addObject("sel_index_type", index_type);
		mv.addObject("induty_select", param.get("induty_select"));
		mv.addObject("sel_area", sel_area);
		mv.addObject("col_length", colModelList.length);
		mv.addObject("gSelect1", gSelect1);
		mv.addObject("gSelect2", gSelect2);
		mv.addObject("ad_index_kind", rqstMap.get("ad_index_kind"));
		
		mv.addObject("entprsList", entprsList);
		
		return mv;
	}
	
	
	/**
	 * 주요지표 > 구간별현황 챠트
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView sectionIdxChart(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0021_1");
		HashMap param = new HashMap();
		Map dataMap = new HashMap();

		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));		// 조회조건 : 기업군
		param.put("induty_select", MapUtils.getString(rqstMap, "induty_select"));
		param.put("sel_area", MapUtils.getString(rqstMap, "sel_area"));		// 지역 선택 구분(권역별 : A, 지역별 : C)
		if (rqstMap.containsKey("gSelect1")) param.put("gSelect1", rqstMap.get("gSelect1"));
		if (rqstMap.containsKey("gSelect2")) param.put("gSelect2", rqstMap.get("gSelect2"));
		if (rqstMap.containsKey("sel_index_type")) param.put("sel_index_type", rqstMap.get("sel_index_type"));		// 지표 선택 구분
		if (rqstMap.containsKey("ad_index_kind")) param.put("ad_index_kind", rqstMap.get("ad_index_kind"));		// 넘어오는 지표
		
		if("".equals(param.get("induty_select")) || param.get("induty_select") == "") param.put("induty_select", null);
		if("".equals(param.get("sel_area")) || param.get("sel_area") == "") param.put("sel_area", null);
		
		String gSelect1 = (String) rqstMap.get("gSelect1");		//업종이 그룹일때
		String gSelect2 = (String) rqstMap.get("gSelect2");		//지역이 그룹일때
		
		String[] columnNames = null;
		String[] colModelList = null;
		
		String index_type = null;
		String index_kind = null;
		String[] array_index_kind;
		
		if (rqstMap.containsKey("sel_index_type")) index_type = (String) rqstMap.get("sel_index_type");		// 지표구분
		if (rqstMap.containsKey("ad_index_kind")) index_kind = (String) rqstMap.get("ad_index_kind");		// 넘어오는 지표
		
		int i = 0;		// start 번호
		
		// 화면에 처음 들어온 초기화면일 때
		if (param.get("gSelect1")==null && param.get("gSelect2")==null) {
			
			// 컬럼명을 배열형태로
			columnNames = new String[10];
			colModelList = new String[10];
			
			//컬럼명
			columnNames[0] = "지역";
			columnNames[1] = "업종";
			columnNames[2] = "없음";
			columnNames[3] = "1.0%미만";
			columnNames[4] = "2.0~3.0%";
			columnNames[5] = "3.0~5.0%";
			columnNames[6] = "5.0~10.0%";
			columnNames[7] = "10.0~30.0%";
			columnNames[8] = "30.0%이상";
			columnNames[9] = "합계";
			
			//모델명
			colModelList[0] = "AREA_NM";
			colModelList[1] = "INDUTY_GUBUN";
			colModelList[2] = "SCTN1";
			colModelList[3] = "SCTN2";
			colModelList[4] = "SCTN3";
			colModelList[5] = "SCTN4";
			colModelList[6] = "SCTN5";
			colModelList[7] = "SCTN6";
			colModelList[8] = "SCTN7";
			colModelList[9] = "SCTN8";
		}else {
			// 업종, 지역 선택없이 들어왔을때
			if(param.get("induty_select") == null && param.get("sel_area") == null) {
				// R&D집약도
				if("A".equals(index_type)) {
					// 컬럼명을 배열형태로
					columnNames = new String[8];
					colModelList = new String[8];
					
					//컬럼명
					columnNames[0] = "없음";
					columnNames[1] = "1.0%미만";
					columnNames[2] = "2.0~3.0%";
					columnNames[3] = "3.0~5.0%";
					columnNames[4] = "5.0~10.0%";
					columnNames[5] = "10.0~30.0%";
					columnNames[6] = "30.0%이상";
					columnNames[7] = "합계";
					
					//모델명
					colModelList[0] = "SCTN1";
					colModelList[1] = "SCTN2";
					colModelList[2] = "SCTN3";
					colModelList[3] = "SCTN4";
					colModelList[4] = "SCTN5";
					colModelList[5] = "SCTN6";
					colModelList[6] = "SCTN7";
					colModelList[7] = "SCTN8";
				}
				
				if("B".equals(index_type)) {
					// 컬럼명을 배열형태로
					columnNames = new String[9];
					colModelList = new String[9];
					
					//컬럼명
					columnNames[0] = "100억미만";
					columnNames[1] = "100억원~500억원";
					columnNames[2] = "500억원~1천억원";
					columnNames[3] = "1천억원~2천억원";
					columnNames[4] = "2천억원~3천억원";
					columnNames[5] = "3천억원~5천억원";
					columnNames[6] = "5천억원~1조원";
					columnNames[7] = "1조원이상";
					columnNames[8] = "합계";
					
					//모델명
					colModelList[0] = "SCTN1";
					colModelList[1] = "SCTN2";
					colModelList[2] = "SCTN3";
					colModelList[3] = "SCTN4";
					colModelList[4] = "SCTN5";
					colModelList[5] = "SCTN6";
					colModelList[6] = "SCTN7";
					colModelList[7] = "SCTN8";
					colModelList[8] = "SCTN9";
				}
				
				if("C".equals(index_type)) {
					// 컬럼명을 배열형태로
					columnNames = new String[8];
					colModelList = new String[8];
					
					//컬럼명
					columnNames[0] = "없음";
					columnNames[1] = "1백만∼5백만불";
					columnNames[2] = "5백만∼1천만불";
					columnNames[3] = "1천만∼3천만불";
					columnNames[4] = "3천만∼5천만불";
					columnNames[5] = "5천만∼1억불";
					columnNames[6] = "1억불 이상";
					columnNames[7] = "합계";
					
					//모델명
					colModelList[0] = "SCTN1";
					colModelList[1] = "SCTN2";
					colModelList[2] = "SCTN3";
					colModelList[3] = "SCTN4";
					colModelList[4] = "SCTN5";
					colModelList[5] = "SCTN6";
					colModelList[6] = "SCTN7";
					colModelList[7] = "SCTN8";
				}
				
				//근로자수
				if("D".equals(index_type)) {
					// 컬럼명을 배열형태로
					columnNames = new String[7];
					colModelList = new String[7];
					
					//컬럼명
					columnNames[0] = "10인 미만";
					columnNames[1] = "10인~50인";
					columnNames[2] = "50인~100인";
					columnNames[3] = "100인~200인";
					columnNames[4] = "200인~300인";
					columnNames[5] = "300인 이상";
					columnNames[6] = "합계";
					
					//모델명
					colModelList[0] = "SCTN1";
					colModelList[1] = "SCTN2";
					colModelList[2] = "SCTN3";
					colModelList[3] = "SCTN4";
					colModelList[4] = "SCTN5";
					colModelList[5] = "SCTN6";
					colModelList[6] = "SCTN7";
				}
			}
			
			// 업종
			if(param.get("induty_select") != null && param.get("sel_area") == null) {
				// R&D집약도
				if("A".equals(index_type)) {
					// 컬럼명을 배열형태로
					columnNames = new String[9];
					colModelList = new String[9];
					
					//컬럼명
					columnNames[0] = "업-종";
					columnNames[1] = "없음";
					columnNames[2] = "1.0%미만";
					columnNames[3] = "2.0~3.0%";
					columnNames[4] = "3.0~5.0%";
					columnNames[5] = "5.0~10.0%";
					columnNames[6] = "10.0~30.0%";
					columnNames[7] = "30.0%이상";
					columnNames[8] = "합계";
					
					//모델명
					colModelList[0] = "COL1";
					colModelList[1] = "SCTN1";
					colModelList[2] = "SCTN2";
					colModelList[3] = "SCTN3";
					colModelList[4] = "SCTN4";
					colModelList[5] = "SCTN5";
					colModelList[6] = "SCTN6";
					colModelList[7] = "SCTN7";
					colModelList[8] = "SCTN8";
				}
				
				if("B".equals(index_type)) {
					// 컬럼명을 배열형태로
					columnNames = new String[10];
					colModelList = new String[10];
					
					//컬럼명
					columnNames[0] = "업종";
					columnNames[1] = "100억미만";
					columnNames[2] = "100억원~500억원";
					columnNames[3] = "500억원~1천억원";
					columnNames[4] = "1천억원~2천억원";
					columnNames[5] = "2천억원~3천억원";
					columnNames[6] = "3천억원~5천억원";
					columnNames[7] = "5천억원~1조원";
					columnNames[8] = "1조원이상";
					columnNames[9] = "합계";
					
					//모델명
					colModelList[0] = "COL1";
					colModelList[1] = "SCTN1";
					colModelList[2] = "SCTN2";
					colModelList[3] = "SCTN3";
					colModelList[4] = "SCTN4";
					colModelList[5] = "SCTN5";
					colModelList[6] = "SCTN6";
					colModelList[7] = "SCTN7";
					colModelList[8] = "SCTN8";
					colModelList[9] = "SCTN9";
				}
				
				if("C".equals(index_type)) {
					// 컬럼명을 배열형태로
					columnNames = new String[9];
					colModelList = new String[9];
					
					//컬럼명
					columnNames[0] = "업종";
					columnNames[1] = "없음";
					columnNames[2] = "1백만∼5백만불";
					columnNames[3] = "5백만∼1천만불";
					columnNames[4] = "1천만∼3천만불";
					columnNames[5] = "3천만∼5천만불";
					columnNames[6] = "5천만∼1억불";
					columnNames[7] = "1억불 이상";
					columnNames[8] = "합계";
					
					//모델명
					colModelList[0] = "COL1";
					colModelList[1] = "SCTN1";
					colModelList[2] = "SCTN2";
					colModelList[3] = "SCTN3";
					colModelList[4] = "SCTN4";
					colModelList[5] = "SCTN5";
					colModelList[6] = "SCTN6";
					colModelList[7] = "SCTN7";
					colModelList[8] = "SCTN8";
				}
				
				//근로자수
				if("D".equals(index_type)) {
					// 컬럼명을 배열형태로
					columnNames = new String[8];
					colModelList = new String[8];
					
					//컬럼명
					columnNames[0] = "업종";
					columnNames[1] = "10인 미만";
					columnNames[2] = "10인~50인";
					columnNames[3] = "50인~100인";
					columnNames[4] = "100인~200인";
					columnNames[5] = "200인~300인";
					columnNames[6] = "300인 이상";
					columnNames[7] = "합계";
					
					//모델명
					colModelList[0] = "COL1";
					colModelList[1] = "SCTN1";
					colModelList[2] = "SCTN2";
					colModelList[3] = "SCTN3";
					colModelList[4] = "SCTN4";
					colModelList[5] = "SCTN5";
					colModelList[6] = "SCTN6";
					colModelList[7] = "SCTN7";
				}
			}	// null : null
			
			if(param.get("induty_select") == null && param.get("sel_area") != null) {
				
				// R&D집약도
				if("A".equals(index_type)) {
					// 컬럼명을 배열형태로
					columnNames = new String[9];
					colModelList = new String[9];
					
					//컬럼명
					columnNames[0] = "지역";
					columnNames[1] = "없음";
					columnNames[2] = "1.0%미만";
					columnNames[3] = "2.0~3.0%";
					columnNames[4] = "3.0~5.0%";
					columnNames[5] = "5.0~10.0%";
					columnNames[6] = "10.0~30.0%";
					columnNames[7] = "30.0%이상";
					columnNames[8] = "합계";
					
					//모델명
					colModelList[0] = "AREA1";
					colModelList[1] = "SCTN1";
					colModelList[2] = "SCTN2";
					colModelList[3] = "SCTN3";
					colModelList[4] = "SCTN4";
					colModelList[5] = "SCTN5";
					colModelList[6] = "SCTN6";
					colModelList[7] = "SCTN7";
					colModelList[8] = "SCTN8";
				}
				
				if("B".equals(index_type)) {
					// 컬럼명을 배열형태로
					columnNames = new String[10];
					colModelList = new String[10];
					
					//컬럼명
					columnNames[0] = "지역";
					columnNames[1] = "100억미만";
					columnNames[2] = "100억원~500억원";
					columnNames[3] = "500억원~1천억원";
					columnNames[4] = "1천억원~2천억원";
					columnNames[5] = "2천억원~3천억원";
					columnNames[6] = "3천억원~5천억원";
					columnNames[7] = "5천억원~1조원";
					columnNames[8] = "1조원이상";
					columnNames[9] = "합계";
					
					//모델명
					colModelList[0] = "AREA1";
					colModelList[1] = "SCTN1";
					colModelList[2] = "SCTN2";
					colModelList[3] = "SCTN3";
					colModelList[4] = "SCTN4";
					colModelList[5] = "SCTN5";
					colModelList[6] = "SCTN6";
					colModelList[7] = "SCTN7";
					colModelList[8] = "SCTN8";
					colModelList[9] = "SCTN9";
				}
				
				if("C".equals(index_type)) {
					// 컬럼명을 배열형태로
					columnNames = new String[9];
					colModelList = new String[9];
					
					//컬럼명
					columnNames[0] = "지역";
					columnNames[1] = "없음";
					columnNames[2] = "1백만∼5백만불";
					columnNames[3] = "5백만∼1천만불";
					columnNames[4] = "1천만∼3천만불";
					columnNames[5] = "3천만∼5천만불";
					columnNames[6] = "5천만∼1억불";
					columnNames[7] = "1억불 이상";
					columnNames[8] = "합계";
					
					//모델명
					colModelList[0] = "AREA1";
					colModelList[1] = "SCTN1";
					colModelList[2] = "SCTN2";
					colModelList[3] = "SCTN3";
					colModelList[4] = "SCTN4";
					colModelList[5] = "SCTN5";
					colModelList[6] = "SCTN6";
					colModelList[7] = "SCTN7";
					colModelList[8] = "SCTN8";
				}
				
				//근로자수
				if("D".equals(index_type)) {
					// 컬럼명을 배열형태로
					columnNames = new String[8];
					colModelList = new String[8];
					
					//컬럼명
					columnNames[0] = "지역";
					columnNames[1] = "10인 미만";
					columnNames[2] = "10인~50인";
					columnNames[3] = "50인~100인";
					columnNames[4] = "100인~200인";
					columnNames[5] = "200인~300인";
					columnNames[6] = "300인 이상";
					columnNames[7] = "합계";
					
					//모델명
					colModelList[0] = "AREA1";
					colModelList[1] = "SCTN1";
					colModelList[2] = "SCTN2";
					colModelList[3] = "SCTN3";
					colModelList[4] = "SCTN4";
					colModelList[5] = "SCTN5";
					colModelList[6] = "SCTN6";
					colModelList[7] = "SCTN7";
				}
			}
			
			if(param.get("induty_select") != null && param.get("sel_area") != null) {
				
				if ("G".equals(param.get("gSelect1")) && "W".equals(param.get("gSelect2"))) {
					// R&D집약도
					if("A".equals(index_type)) {
						// 컬럼명을 배열형태로
						columnNames = new String[9];
						colModelList = new String[9];
						
						//컬럼명
						columnNames[0] = "업종";
						columnNames[1] = "없음";
						columnNames[2] = "1.0%미만";
						columnNames[3] = "2.0~3.0%";
						columnNames[4] = "3.0~5.0%";
						columnNames[5] = "5.0~10.0%";
						columnNames[6] = "10.0~30.0%";
						columnNames[7] = "30.0%이상";
						columnNames[8] = "합계";
						
						//모델명
						colModelList[0] = "COL1";
						colModelList[1] = "SCTN1";
						colModelList[2] = "SCTN2";
						colModelList[3] = "SCTN3";
						colModelList[4] = "SCTN4";
						colModelList[5] = "SCTN5";
						colModelList[6] = "SCTN6";
						colModelList[7] = "SCTN7";
						colModelList[8] = "SCTN8";
					}
					
					if("B".equals(index_type)) {
						// 컬럼명을 배열형태로
						columnNames = new String[10];
						colModelList = new String[10];
						
						//컬럼명
						columnNames[0] = "업종";
						columnNames[1] = "100억미만";
						columnNames[2] = "100억원~500억원";
						columnNames[3] = "500억원~1천억원";
						columnNames[4] = "1천억원~2천억원";
						columnNames[5] = "2천억원~3천억원";
						columnNames[6] = "3천억원~5천억원";
						columnNames[7] = "5천억원~1조원";
						columnNames[8] = "1조원이상";
						columnNames[9] = "합계";
						
						//모델명
						colModelList[0] = "COL1";
						colModelList[1] = "SCTN1";
						colModelList[2] = "SCTN2";
						colModelList[3] = "SCTN3";
						colModelList[4] = "SCTN4";
						colModelList[5] = "SCTN5";
						colModelList[6] = "SCTN6";
						colModelList[7] = "SCTN7";
						colModelList[8] = "SCTN8";
						colModelList[9] = "SCTN9";
					}
					
					if("C".equals(index_type)) {
						// 컬럼명을 배열형태로
						columnNames = new String[9];
						colModelList = new String[9];
						
						//컬럼명
						columnNames[0] = "업종";
						columnNames[1] = "없음";
						columnNames[2] = "1백만∼5백만불";
						columnNames[3] = "5백만∼1천만불";
						columnNames[4] = "1천만∼3천만불";
						columnNames[5] = "3천만∼5천만불";
						columnNames[6] = "5천만∼1억불";
						columnNames[7] = "1억불 이상";
						columnNames[8] = "합계";
						
						//모델명
						colModelList[0] = "COL1";
						colModelList[1] = "SCTN1";
						colModelList[2] = "SCTN2";
						colModelList[3] = "SCTN3";
						colModelList[4] = "SCTN4";
						colModelList[5] = "SCTN5";
						colModelList[6] = "SCTN6";
						colModelList[7] = "SCTN7";
						colModelList[8] = "SCTN8";
					}
					
					//근로자수
					if("D".equals(index_type)) {
						// 컬럼명을 배열형태로
						columnNames = new String[8];
						colModelList = new String[8];
						
						//컬럼명
						columnNames[0] = "업종";
						columnNames[1] = "10인 미만";
						columnNames[2] = "10인~50인";
						columnNames[3] = "50인~100인";
						columnNames[4] = "100인~200인";
						columnNames[5] = "200인~300인";
						columnNames[6] = "300인 이상";
						columnNames[7] = "합계";
						
						//모델명
						colModelList[0] = "COL1";
						colModelList[1] = "SCTN1";
						colModelList[2] = "SCTN2";
						colModelList[3] = "SCTN3";
						colModelList[4] = "SCTN4";
						colModelList[5] = "SCTN5";
						colModelList[6] = "SCTN6";
						colModelList[7] = "SCTN7";
					}
				}
				
				if ("W".equals(param.get("gSelect1")) && "G".equals(param.get("gSelect2"))) {
					// R&D집약도
					if("A".equals(index_type)) {
						// 컬럼명을 배열형태로
						columnNames = new String[9];
						colModelList = new String[9];
						
						//컬럼명
						columnNames[0] = "지역";
						columnNames[1] = "없음";
						columnNames[2] = "1.0%미만";
						columnNames[3] = "2.0~3.0%";
						columnNames[4] = "3.0~5.0%";
						columnNames[5] = "5.0~10.0%";
						columnNames[6] = "10.0~30.0%";
						columnNames[7] = "30.0%이상";
						columnNames[8] = "합계";
						
						//모델명
						colModelList[0] = "AREA1";
						colModelList[1] = "SCTN1";
						colModelList[2] = "SCTN2";
						colModelList[3] = "SCTN3";
						colModelList[4] = "SCTN4";
						colModelList[5] = "SCTN5";
						colModelList[6] = "SCTN6";
						colModelList[7] = "SCTN7";
						colModelList[8] = "SCTN8";
					}
					
					if("B".equals(index_type)) {
						// 컬럼명을 배열형태로
						columnNames = new String[10];
						colModelList = new String[10];
						
						//컬럼명
						columnNames[0] = "지역";
						columnNames[1] = "100억미만";
						columnNames[2] = "100억원~500억원";
						columnNames[3] = "500억원~1천억원";
						columnNames[4] = "1천억원~2천억원";
						columnNames[5] = "2천억원~3천억원";
						columnNames[6] = "3천억원~5천억원";
						columnNames[7] = "5천억원~1조원";
						columnNames[8] = "1조원이상";
						columnNames[9] = "합계";
						
						//모델명
						colModelList[0] = "AREA1";
						colModelList[1] = "SCTN1";
						colModelList[2] = "SCTN2";
						colModelList[3] = "SCTN3";
						colModelList[4] = "SCTN4";
						colModelList[5] = "SCTN5";
						colModelList[6] = "SCTN6";
						colModelList[7] = "SCTN7";
						colModelList[8] = "SCTN8";
						colModelList[9] = "SCTN9";
					}
					
					if("C".equals(index_type)) {
						// 컬럼명을 배열형태로
						columnNames = new String[9];
						colModelList = new String[9];
						
						//컬럼명
						columnNames[0] = "지역";
						columnNames[1] = "없음";
						columnNames[2] = "1백만∼5백만불";
						columnNames[3] = "5백만∼1천만불";
						columnNames[4] = "1천만∼3천만불";
						columnNames[5] = "3천만∼5천만불";
						columnNames[6] = "5천만∼1억불";
						columnNames[7] = "1억불 이상";
						columnNames[8] = "합계";
						
						//모델명
						colModelList[0] = "AREA1";
						colModelList[1] = "SCTN1";
						colModelList[2] = "SCTN2";
						colModelList[3] = "SCTN3";
						colModelList[4] = "SCTN4";
						colModelList[5] = "SCTN5";
						colModelList[6] = "SCTN6";
						colModelList[7] = "SCTN7";
						colModelList[8] = "SCTN8";
					}
					
					//근로자수
					if("D".equals(index_type)) {
						// 컬럼명을 배열형태로
						columnNames = new String[8];
						colModelList = new String[8];
						
						//컬럼명
						columnNames[0] = "지역";
						columnNames[1] = "10인 미만";
						columnNames[2] = "10인~50인";
						columnNames[3] = "50인~100인";
						columnNames[4] = "100인~200인";
						columnNames[5] = "200인~300인";
						columnNames[6] = "300인 이상";
						columnNames[7] = "합계";
						
						//모델명
						colModelList[0] = "AREA1";
						colModelList[1] = "SCTN1";
						colModelList[2] = "SCTN2";
						colModelList[3] = "SCTN3";
						colModelList[4] = "SCTN4";
						colModelList[5] = "SCTN5";
						colModelList[6] = "SCTN6";
						colModelList[7] = "SCTN7";
					}
				}
				
				if ("G".equals(param.get("gSelect1")) && "G".equals(param.get("gSelect2")) || "W".equals(param.get("gSelect1")) && "W".equals(param.get("gSelect2"))) {
					// R&D집약도
					if("A".equals(index_type)) {
						// 컬럼명을 배열형태로
						columnNames = new String[10];
						colModelList = new String[10];
						
						//컬럼명
						columnNames[0] = "지역";
						columnNames[1] = "업종";
						columnNames[2] = "없음";
						columnNames[3] = "1.0%미만";
						columnNames[4] = "2.0~3.0%";
						columnNames[5] = "3.0~5.0%";
						columnNames[6] = "5.0~10.0%";
						columnNames[7] = "10.0~30.0%";
						columnNames[8] = "30.0%이상";
						columnNames[9] = "합계";
						
						//모델명
						colModelList[0] = "AREA1";
						colModelList[1] = "COL1";
						colModelList[2] = "SCTN1";
						colModelList[3] = "SCTN2";
						colModelList[4] = "SCTN3";
						colModelList[5] = "SCTN4";
						colModelList[6] = "SCTN5";
						colModelList[7] = "SCTN6";
						colModelList[8] = "SCTN7";
						colModelList[9] = "SCTN8";
					}
					
					if("B".equals(index_type)) {
						// 컬럼명을 배열형태로
						columnNames = new String[11];
						colModelList = new String[11];
						
						//컬럼명
						columnNames[0] = "지역";
						columnNames[1] = "업종";
						columnNames[2] = "100억미만";
						columnNames[3] = "100억원~500억원";
						columnNames[4] = "500억원~1천억원";
						columnNames[5] = "1천억원~2천억원";
						columnNames[6] = "2천억원~3천억원";
						columnNames[7] = "3천억원~5천억원";
						columnNames[8] = "5천억원~1조원";
						columnNames[9] = "1조원이상";
						columnNames[10] = "합계";
						
						//모델명
						colModelList[0] = "AREA1";
						colModelList[1] = "COL1";
						colModelList[2] = "SCTN1";
						colModelList[3] = "SCTN2";
						colModelList[4] = "SCTN3";
						colModelList[5] = "SCTN4";
						colModelList[6] = "SCTN5";
						colModelList[7] = "SCTN6";
						colModelList[8] = "SCTN7";
						colModelList[9] = "SCTN8";
						colModelList[10] = "SCTN9";
					}
					
					if("C".equals(index_type)) {
						// 컬럼명을 배열형태로
						columnNames = new String[10];
						colModelList = new String[10];
						
						//컬럼명
						columnNames[0] = "지역";
						columnNames[1] = "업종";
						columnNames[2] = "없음";
						columnNames[3] = "1백만∼5백만불";
						columnNames[4] = "5백만∼1천만불";
						columnNames[5] = "1천만∼3천만불";
						columnNames[6] = "3천만∼5천만불";
						columnNames[7] = "5천만∼1억불";
						columnNames[8] = "1억불 이상";
						columnNames[9] = "합계";
						
						//모델명
						colModelList[0] = "AREA1";
						colModelList[1] = "COL1";
						colModelList[2] = "SCTN1";
						colModelList[3] = "SCTN2";
						colModelList[4] = "SCTN3";
						colModelList[5] = "SCTN4";
						colModelList[6] = "SCTN5";
						colModelList[7] = "SCTN6";
						colModelList[8] = "SCTN7";
						colModelList[9] = "SCTN8";
					}
					
					//근로자수
					if("D".equals(index_type)) {
						// 컬럼명을 배열형태로
						columnNames = new String[9];
						colModelList = new String[9];
						
						//컬럼명
						columnNames[0] = "지역";
						columnNames[1] = "업종";
						columnNames[2] = "10인 미만";
						columnNames[3] = "10인~50인";
						columnNames[4] = "50인~100인";
						columnNames[5] = "100인~200인";
						columnNames[6] = "200인~300인";
						columnNames[7] = "300인 이상";
						columnNames[8] = "합계";
						
						//모델명
						colModelList[0] = "AREA1";
						colModelList[1] = "COL1";
						colModelList[2] = "SCTN1";
						colModelList[3] = "SCTN2";
						colModelList[4] = "SCTN3";
						colModelList[5] = "SCTN4";
						colModelList[6] = "SCTN5";
						colModelList[7] = "SCTN6";
						colModelList[8] = "SCTN7";
					}
				}
			}
		}
			
		dataMap.put("colModelList", colModelList);
		dataMap.put("columnNames", columnNames);
		
		
		// --------------------- 데이터 부분 ---------------------
		int sel_target_year=0;
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("sel_target_year")) sel_target_year = MapUtils.getIntValue(rqstMap, "sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(sel_target_year == 0) sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		
		param.put("sel_target_year", sel_target_year);
		
		if (rqstMap.containsKey("gSelect1")) param.put("gSelect1", rqstMap.get("gSelect1"));
		if (rqstMap.containsKey("gSelect2")) param.put("gSelect2", rqstMap.get("gSelect2"));

		gSelect1 = (String) rqstMap.get("gSelect1");		//업종이 그룹일때
		gSelect2 = (String) rqstMap.get("gSelect2");		//지역이 그룹일때
		
		String tmp1=null;
		String tmp2=null;
		String tmp3=null;
		String[] array_tmp1;
		String[] array_tmp2;
		String[] array_tmp3;
		
		//우선 업종을 받아서
		tmp1 = MapUtils.getString(rqstMap, "multiSelectGrid1");		// (제조, 비제조)
		tmp2 = MapUtils.getString(rqstMap, "multiSelectGrid2");		// (업종테마)
		tmp3 = MapUtils.getString(rqstMap, "ad_ind_cd");		// (상세업종)
		
		String induty_select = null;
		if (rqstMap.containsKey("induty_select")) induty_select = (String) rqstMap.get("induty_select");		// 업종 선택 구분
		
		// 선택 or 제조/비제조 구분이라면
		if(tmp1 != null && "A".equals(induty_select) || "I".equals(induty_select)) {
			array_tmp1 = tmp1.split(",");	// ','를 기준으로 잘라서
		
			if(!"null".equals(array_tmp1[0])) {
				for(i=0; i < array_tmp1.length; i++) {
					if("UT00".equals(array_tmp1[i])) param.put("all_induty", "Y");		// 전산업 선택 시 all_induty : Y 로 넘김(전체)
					if("UT01".equals(array_tmp1[i])) array_tmp1[i] = "제조업";
					if("UT02".equals(array_tmp1[i])) array_tmp1[i] = "비제조업";
					
					param.put("multiSelectGrid1", array_tmp1);	// xml에서 사용될 제조/비제조 코드
				}
			// 제조/비제조 검색 시 항목을 선택하지 않았을 때 
			}else if("null".equals(array_tmp1[0])) {
				array_tmp1 = new String[1];
				array_tmp1[0] = "XXX";
				param.put("multiSelectGrid1", array_tmp1);
			}
		}else{
			
			param.put("multiSelectGrid1", null);
		}
		
		// 테마업종 선택한게 있으면 진행
		if(!"null".equals(tmp2) && tmp2 != null && "T".equals(induty_select)) {
			array_tmp2 = tmp2.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_tmp2[0])) {
				for(i=0; i < array_tmp2.length; i++) {
				}
				
				param.put("multiSelectGrid2", array_tmp2);	// xml에서 사용될 업종테마별 코드
			}
		}else {
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_tmp2 = new String[1];
			array_tmp2[0] = "YYY";
			param.put("multiSelectGrid2", array_tmp2);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		// 임시 세팅
		// tmp3 = "A,C10,C12,C13";
		// 상세업종 선택한게 있으면 진행
		if(!"null".equals(tmp3) && tmp3 != null && "D".equals(induty_select)) {
			array_tmp3 = tmp3.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_tmp3[0])) {
				for(i=0; i < array_tmp3.length; i++) {
					//array_tmp3[i] = array_tmp3[i].substring(array_tmp3[i].indexOf(":"), array_tmp3[i].length());
					array_tmp3[i] = array_tmp3[i].substring(0, array_tmp3[i].indexOf(":"));
				}
				
				param.put("multiSelectGrid3", array_tmp3);	// xml에서 사용될 상세업종별 코드
			}
		}else {
			array_tmp3 = new String[1];
			array_tmp3[0] = "ZZZ";
			param.put("multiSelectGrid3", array_tmp3);
		}
		
		
		index_type = null;
		index_kind = null;
		array_index_kind = null;
		if (rqstMap.containsKey("sel_index_type")) index_type = (String) rqstMap.get("sel_index_type");		// 지표구분
		if (rqstMap.containsKey("ad_index_kind")) index_kind = (String) rqstMap.get("ad_index_kind");		// 넘어오는 지표
		
		//지표를 처리한다
		if(rqstMap.get("ad_index_kind") != null && rqstMap.get("ad_index_kind") != "") {
			array_index_kind = index_kind.split(",");	// ','를 기준으로 잘라서
			
			param.put("array_index_kind", array_index_kind);
		}
		
		String sel_area = (String) rqstMap.get("sel_area");			// 지역 구분 선택 (권역별, 지역별)
		String area_sel = (String) rqstMap.get("cmpn_area_depth1");			// 권역별 선택값
		String city_sel = (String) rqstMap.get("cmpn_area_depth2");			// 지역별 선택값
		String[] array_area;
		String[] array_city;
		
		// 권역별 선택이 넘어온게 있으면
		if(!"null".equals(sel_area) && sel_area != null && sel_area !="" && "A".equals(sel_area) && !"null".equals(area_sel) && area_sel != null) {
			array_area = area_sel.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_area[0])) {
				for(i=0; i < array_area.length; i++) {
				}
				
				param.put("cmpn_area_depth1", array_area);	// xml에서 사용될 권역별 코드
			}
		}else{
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_area = new String[1];
			array_area[0] = "XXX";
			param.put("cmpn_area_depth1", array_area);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		// 지역별 선택이 넘어온게 있으면
		if(!"null".equals(sel_area) && sel_area != null && sel_area !="" && "C".equals(sel_area) && !"null".equals(city_sel) && city_sel != null) {
			array_city = city_sel.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_city[0])) {
				for(i=0; i < array_city.length; i++) {
				}
				
				param.put("cmpn_area_depth2", array_city);	// xml에서 사용될 권역별 코드
			}
		}else{
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_city = new String[1];
			array_city[0] = "XXX";
			param.put("cmpn_area_depth2", array_city);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		
		//주요지표>현황 조회
		List<Map> entprsList = new ArrayList<Map>();
		
		if("W".equals(gSelect1) && "W".equals(gSelect2) && param.get("sel_area") == null && param.get("induty_select") == null){
			entprsList = entprsDAO.sectionIdxListAll(param);
		}else {
			entprsList = entprsDAO.sectionIdxList(param);
		}

		
		// 데이터 추가
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchCondition"));
		
		mv.addObject("searchEntprsGrp",codeService.findCodeInfo(param).get("codeNm"));
		
		mv.addObject("sel_target_year", sel_target_year);
		mv.addObject("listCnt", entprsList.size());
		mv.addObject("colModelList", colModelList);
		mv.addObject("columnNames", columnNames);
		
		mv.addObject("sel_index_type", index_type);		// 지표 선택 구분
		mv.addObject("induty_select", param.get("induty_select"));		// 업종 선택 구분
		mv.addObject("sel_area", param.get("sel_area"));		//지역선택
		mv.addObject("col_length", colModelList.length);
		mv.addObject("gSelect1", gSelect1);
		mv.addObject("gSelect2", gSelect2);
		mv.addObject("sel_index_type", rqstMap.get("sel_index_type"));
		mv.addObject("ad_index_kind", rqstMap.get("ad_index_kind"));
		
		mv.addObject("entprsList", entprsList);
		
		return mv;
	}
	
	
	/**
	 * outputIdx 출력
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView outputIdx(Map rqstMap) throws Exception {
		if (!rqstMap.containsKey("searchEntprsGrp")) rqstMap.put("searchEntprsGrp", "EA1");
		
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0020_2");
		HashMap param = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));		// 조회조건 : 기업군
		if (rqstMap.containsKey("sel_target_year")) param.put("sel_target_year", rqstMap.get("sel_target_year"));
		param.put("induty_select", MapUtils.getString(rqstMap, "induty_select"));
		param.put("sel_area", MapUtils.getString(rqstMap, "sel_area"));		// 지역 선택 구분(권역별 : A, 지역별 : C)
		if (rqstMap.containsKey("gSelect1")) param.put("gSelect1", rqstMap.get("gSelect1"));
		if (rqstMap.containsKey("gSelect2")) param.put("gSelect2", rqstMap.get("gSelect2"));
		if (rqstMap.containsKey("cmpn_area_depth1")) param.put("cmpn_area_depth1", rqstMap.get("cmpn_area_depth1"));		// 권역별
		if (rqstMap.containsKey("cmpn_area_depth2")) param.put("cmpn_area_depth2", rqstMap.get("cmpn_area_depth2"));		// 지역별(시)
		if (rqstMap.containsKey("sel_index_type")) param.put("sel_index_type", rqstMap.get("sel_index_type"));		// 지표 선택 구분
		if (rqstMap.containsKey("ad_index_kind")) param.put("ad_index_kind", rqstMap.get("ad_index_kind"));		// 넘어오는 지표
		if (rqstMap.containsKey("multiSelectGrid1")) param.put("multiSelectGrid1", rqstMap.get("multiSelectGrid1"));		// (제조, 비제조)
		if (rqstMap.containsKey("multiSelectGrid2")) param.put("multiSelectGrid2", rqstMap.get("multiSelectGrid2"));		// (업종테마)
		if (rqstMap.containsKey("ad_ind_cd")) param.put("ad_ind_cd", rqstMap.get("ad_ind_cd"));		// (상세업종)
		
		String searchCondition = param.get("searchCondition").toString();
		String sel_target_year = param.get("sel_target_year").toString();
		String gSelect1 = (String) rqstMap.get("gSelect1");
		String gSelect2 = (String) rqstMap.get("gSelect2");
		
		// 데이터 추가
		mv.addObject("searchCondition", searchCondition);
		mv.addObject("sel_target_year", sel_target_year);
		mv.addObject("induty_select", rqstMap.get("induty_select"));
		mv.addObject("sel_area", rqstMap.get("sel_area"));
		mv.addObject("multiSelectGrid1", rqstMap.get("multiSelectGrid1"));
		mv.addObject("multiSelectGrid2", rqstMap.get("multiSelectGrid2"));
		mv.addObject("gSelect1", gSelect1);
		mv.addObject("gSelect2", gSelect2);
		mv.addObject("sel_index_type", rqstMap.get("sel_index_type"));
		mv.addObject("ad_index_kind", rqstMap.get("ad_index_kind"));
		mv.addObject("cmpn_area_depth1", rqstMap.get("cmpn_area_depth1"));
		mv.addObject("cmpn_area_depth2", rqstMap.get("cmpn_area_depth2"));
		mv.addObject("ad_ind_cd", rqstMap.get("ad_ind_cd"));
		
		return mv;
		
	}
	
	/**
	 * 구간별현황 outputIdx2 출력
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView outputIdx2(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0021_2");
		HashMap param = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));		// 조회조건 : 기업군
		if (rqstMap.containsKey("sel_target_year")) param.put("sel_target_year", rqstMap.get("sel_target_year"));
		param.put("induty_select", MapUtils.getString(rqstMap, "induty_select"));
		param.put("sel_area", MapUtils.getString(rqstMap, "sel_area"));		// 지역 선택 구분(권역별 : A, 지역별 : C)
		if (rqstMap.containsKey("gSelect1")) param.put("gSelect1", rqstMap.get("gSelect1"));
		if (rqstMap.containsKey("gSelect2")) param.put("gSelect2", rqstMap.get("gSelect2"));
		if (rqstMap.containsKey("cmpn_area_depth1")) param.put("cmpn_area_depth1", rqstMap.get("cmpn_area_depth1"));		// 권역별
		if (rqstMap.containsKey("cmpn_area_depth2")) param.put("cmpn_area_depth2", rqstMap.get("cmpn_area_depth2"));		// 지역별(시)
		if (rqstMap.containsKey("sel_index_type")) param.put("sel_index_type", rqstMap.get("sel_index_type"));		// 지표 선택 구분
		if (rqstMap.containsKey("ad_index_kind")) param.put("ad_index_kind", rqstMap.get("ad_index_kind"));		// 넘어오는 지표
		if (rqstMap.containsKey("multiSelectGrid1")) param.put("multiSelectGrid1", rqstMap.get("multiSelectGrid1"));		// (제조, 비제조)
		if (rqstMap.containsKey("multiSelectGrid2")) param.put("multiSelectGrid2", rqstMap.get("multiSelectGrid2"));		// (업종테마)
		if (rqstMap.containsKey("ad_ind_cd")) param.put("ad_ind_cd", rqstMap.get("ad_ind_cd"));		// (상세업종)
		
		String searchCondition = param.get("searchCondition").toString();
		String sel_target_year = param.get("sel_target_year").toString();
		String gSelect1 = (String) rqstMap.get("gSelect1");
		String gSelect2 = (String) rqstMap.get("gSelect2");
		
		// 데이터 추가
		mv.addObject("searchCondition", searchCondition);
		mv.addObject("sel_target_year", sel_target_year);
		mv.addObject("induty_select", rqstMap.get("induty_select"));
		mv.addObject("sel_area", rqstMap.get("sel_area"));
		mv.addObject("multiSelectGrid1", rqstMap.get("multiSelectGrid1"));
		mv.addObject("multiSelectGrid2", rqstMap.get("multiSelectGrid2"));
		mv.addObject("gSelect1", gSelect1);
		mv.addObject("gSelect2", gSelect2);
		mv.addObject("sel_index_type", rqstMap.get("sel_index_type"));
		mv.addObject("ad_index_kind", rqstMap.get("ad_index_kind"));
		mv.addObject("cmpn_area_depth1", rqstMap.get("cmpn_area_depth1"));
		mv.addObject("cmpn_area_depth2", rqstMap.get("cmpn_area_depth2"));
		mv.addObject("ad_ind_cd", rqstMap.get("ad_ind_cd"));
		
		return mv;
	}
	
	/**
	 * 구간별현황 추이 outputIdx3 출력
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView outputIdx3(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0022_2");
		HashMap param = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));		// 조회조건 : 기업군
		if (rqstMap.containsKey("from_sel_target_year")) param.put("from_sel_target_year", rqstMap.get("from_sel_target_year"));
		if (rqstMap.containsKey("to_sel_target_year")) param.put("to_sel_target_year", rqstMap.get("to_sel_target_year"));
		param.put("induty_select", MapUtils.getString(rqstMap, "induty_select"));
		param.put("sel_area", MapUtils.getString(rqstMap, "sel_area"));		// 지역 선택 구분(권역별 : A, 지역별 : C)
		if (rqstMap.containsKey("gSelect1")) param.put("gSelect1", rqstMap.get("gSelect1"));
		if (rqstMap.containsKey("gSelect2")) param.put("gSelect2", rqstMap.get("gSelect2"));
		if (rqstMap.containsKey("cmpn_area_depth1")) param.put("cmpn_area_depth1", rqstMap.get("cmpn_area_depth1"));		// 권역별
		if (rqstMap.containsKey("cmpn_area_depth2")) param.put("cmpn_area_depth2", rqstMap.get("cmpn_area_depth2"));		// 지역별(시)
		if (rqstMap.containsKey("sel_index_type")) param.put("sel_index_type", rqstMap.get("sel_index_type"));		// 지표 선택 구분
		if (rqstMap.containsKey("ad_index_kind")) param.put("ad_index_kind", rqstMap.get("ad_index_kind"));		// 넘어오는 지표
		if (rqstMap.containsKey("multiSelectGrid1")) param.put("multiSelectGrid1", rqstMap.get("multiSelectGrid1"));		// (제조, 비제조)
		if (rqstMap.containsKey("multiSelectGrid2")) param.put("multiSelectGrid2", rqstMap.get("multiSelectGrid2"));		// (업종테마)
		if (rqstMap.containsKey("ad_ind_cd")) param.put("ad_ind_cd", rqstMap.get("ad_ind_cd"));		// (상세업종)
		
		String searchCondition = param.get("searchCondition").toString();
		String from_sel_target_year = param.get("from_sel_target_year").toString();
		String to_sel_target_year = param.get("to_sel_target_year").toString();
		String gSelect1 = (String) rqstMap.get("gSelect1");
		String gSelect2 = (String) rqstMap.get("gSelect2");
		
		// 데이터 추가
		mv.addObject("searchCondition", searchCondition);
		mv.addObject("from_sel_target_year", from_sel_target_year);
		mv.addObject("to_sel_target_year", to_sel_target_year);
		mv.addObject("induty_select", rqstMap.get("induty_select"));
		mv.addObject("sel_area", rqstMap.get("sel_area"));
		mv.addObject("multiSelectGrid1", rqstMap.get("multiSelectGrid1"));
		mv.addObject("multiSelectGrid2", rqstMap.get("multiSelectGrid2"));
		mv.addObject("gSelect1", gSelect1);
		mv.addObject("gSelect2", gSelect2);
		mv.addObject("sel_index_type", rqstMap.get("sel_index_type"));
		mv.addObject("ad_index_kind", rqstMap.get("ad_index_kind"));
		mv.addObject("cmpn_area_depth1", rqstMap.get("cmpn_area_depth1"));
		mv.addObject("cmpn_area_depth2", rqstMap.get("cmpn_area_depth2"));
		mv.addObject("ad_ind_cd", rqstMap.get("ad_ind_cd"));
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchCondition"));
		
		mv.addObject("searchEntprsGrp",codeService.findCodeInfo(param).get("codeNm"));
		
		return mv;
	}
	
	
	/**
	 * 구간별현황 추이 outputIdx4 출력
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView outputIdx4(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0023_2");
		HashMap param = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));		// 조회조건 : 기업군
		if (rqstMap.containsKey("from_sel_target_year")) param.put("from_sel_target_year", rqstMap.get("from_sel_target_year"));
		if (rqstMap.containsKey("to_sel_target_year")) param.put("to_sel_target_year", rqstMap.get("to_sel_target_year"));
		param.put("induty_select", MapUtils.getString(rqstMap, "induty_select"));
		param.put("sel_area", MapUtils.getString(rqstMap, "sel_area"));		// 지역 선택 구분(권역별 : A, 지역별 : C)
		if (rqstMap.containsKey("gSelect1")) param.put("gSelect1", rqstMap.get("gSelect1"));
		if (rqstMap.containsKey("gSelect2")) param.put("gSelect2", rqstMap.get("gSelect2"));
		if (rqstMap.containsKey("cmpn_area_depth1")) param.put("cmpn_area_depth1", rqstMap.get("cmpn_area_depth1"));		// 권역별
		if (rqstMap.containsKey("cmpn_area_depth2")) param.put("cmpn_area_depth2", rqstMap.get("cmpn_area_depth2"));		// 지역별(시)
		if (rqstMap.containsKey("sel_index_type")) param.put("sel_index_type", rqstMap.get("sel_index_type"));		// 지표 선택 구분
		if (rqstMap.containsKey("ad_index_kind")) param.put("ad_index_kind", rqstMap.get("ad_index_kind"));		// 넘어오는 지표
		if (rqstMap.containsKey("multiSelectGrid1")) param.put("multiSelectGrid1", rqstMap.get("multiSelectGrid1"));		// (제조, 비제조)
		if (rqstMap.containsKey("multiSelectGrid2")) param.put("multiSelectGrid2", rqstMap.get("multiSelectGrid2"));		// (업종테마)
		if (rqstMap.containsKey("ad_ind_cd")) param.put("ad_ind_cd", rqstMap.get("ad_ind_cd"));		// (상세업종)
		
		String searchCondition = param.get("searchCondition").toString();
		String from_sel_target_year = param.get("from_sel_target_year").toString();
		String to_sel_target_year = param.get("to_sel_target_year").toString();
		String gSelect1 = (String) rqstMap.get("gSelect1");
		String gSelect2 = (String) rqstMap.get("gSelect2");
		
		// 데이터 추가
		mv.addObject("searchCondition", searchCondition);
		mv.addObject("from_sel_target_year", from_sel_target_year);
		mv.addObject("to_sel_target_year", to_sel_target_year);
		mv.addObject("induty_select", rqstMap.get("induty_select"));
		mv.addObject("sel_area", rqstMap.get("sel_area"));
		mv.addObject("multiSelectGrid1", rqstMap.get("multiSelectGrid1"));
		mv.addObject("multiSelectGrid2", rqstMap.get("multiSelectGrid2"));
		mv.addObject("gSelect1", gSelect1);
		mv.addObject("gSelect2", gSelect2);
		mv.addObject("sel_index_type", rqstMap.get("sel_index_type"));
		mv.addObject("ad_index_kind", rqstMap.get("ad_index_kind"));
		mv.addObject("cmpn_area_depth1", rqstMap.get("cmpn_area_depth1"));
		mv.addObject("cmpn_area_depth2", rqstMap.get("cmpn_area_depth2"));
		mv.addObject("ad_ind_cd", rqstMap.get("ad_ind_cd"));
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchCondition"));
		
		mv.addObject("searchEntprsGrp",codeService.findCodeInfo(param).get("codeNm"));
		
		return mv;
	}
	
	
	/**
	 * 추이 챠트
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView trnsitnChart(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0022_1");
		HashMap param = new HashMap();
		Map dataMap = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));		// 조회조건 : 기업군
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
		if(from_sel_target_year == 0) from_sel_target_year = 2003;				//to_sel_target_year == 0 -> 넘어오지 않으면 to_sel_target_year-2 세팅
		
		param.put("from_sel_target_year", from_sel_target_year);
		param.put("to_sel_target_year", to_sel_target_year);
		
		//기본으로 조회할 총 년도의 카운트를 계산
		int intNum = (to_sel_target_year-from_sel_target_year)+1;
		
		

		//메뉴에서 왔거나 둘다 그룹으로 설정했다면 (기본화면 및 전체보기)
		//if ((gSelect1 == null && gSelect2 == null) || ("G".equals(gSelect1) && "G".equals(gSelect2))) {
		// 화면에 처음 들어온 초기화면일 때
		if (param.get("gSelect1")==null && param.get("gSelect2")==null) {
			int year = from_sel_target_year;
			
			// 컬럼명을 배열형태로
			columnNames = new String[intNum+3];
			colModelList = new String[intNum+3];
			
			//컬럼명
			columnNames[0] = "지역";
			columnNames[1] = "업종";
			columnNames[2] = "구분";
			
			//모델명
			colModelList[0] = "AREA1";
			colModelList[1] = "COL1";
			colModelList[2] = "GUBUN1";
			
			for(int i=3; i<intNum+3; i++) {
				columnNames[i] = ""+year;
				colModelList[i] = "data"+year;
				year++;
			}	
		}else if (("W".equals(gSelect1) && "W".equals(gSelect2)) || ("G".equals(gSelect1) && "G".equals(gSelect2))) {
			if(param.get("induty_select") == null && param.get("sel_area") == null) {
				
				int year = from_sel_target_year;
				
				// 컬럼명을 배열형태로
				columnNames = new String[intNum+1];
				colModelList = new String[intNum+1];
				
				//컬럼명
				columnNames[0] = "구분";
				
				//모델명
				colModelList[0] = "GUBUN1";
				
				for(int i=1; i<intNum+1; i++) {
					columnNames[i] = ""+year;
					colModelList[i] = "data"+year;
					year++;
				}
				
			}else if(param.get("induty_select") != null && param.get("sel_area") == null) {
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
				
				for(int i=2; i<intNum+2; i++) {
					columnNames[i] = ""+year;
					colModelList[i] = "data"+year;
					year++;
				}
				
			}else if(param.get("induty_select") == null && param.get("sel_area") != null) {
				int year = from_sel_target_year;
				
				// 컬럼명을 배열형태로
				columnNames = new String[intNum+2];
				colModelList = new String[intNum+2];
				
				//컬럼명
				columnNames[0] = "지역";
				columnNames[1] = "구분";
				
				//모델명
				colModelList[0] = "AREA1";
				colModelList[1] = "GUBUN1";
				
				for(int i=2; i<intNum+2; i++) {
					columnNames[i] = ""+year;
					colModelList[i] = "data"+year;
					year++;
				}
				
			}else if(param.get("induty_select") != null && param.get("sel_area") != null) {
				int year = from_sel_target_year;
				
				// 컬럼명을 배열형태로
				columnNames = new String[intNum+3];
				colModelList = new String[intNum+3];
				
				//컬럼명
				columnNames[0] = "지역";
				columnNames[1] = "업종";
				columnNames[2] = "구분";
				
				//모델명
				colModelList[0] = "AREA1";
				colModelList[1] = "COL1";
				colModelList[2] = "GUBUN1";
				
				for(int i=3; i<intNum+3; i++) {
					columnNames[i] = ""+year;
					colModelList[i] = "data"+year;
					year++;
				}
			}
			
		//업종 그룹
		}else if ("G".equals(gSelect1) && ("W".equals(gSelect2) || gSelect2 == null)) {
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
			
			for(int i=2; i<intNum+2; i++) {
				columnNames[i] = ""+year;
				colModelList[i] = "data"+year;
				year++;
			}
			
		//지역 그룹
		}else if (("W".equals(gSelect1) || gSelect1 == null) && "G".equals(gSelect2)) {
			int year = from_sel_target_year;
			
			// 컬럼명을 배열형태로
			columnNames = new String[intNum+2];
			colModelList = new String[intNum+2];
			
			//컬럼명
			columnNames[0] = "지역";
			columnNames[1] = "구분";
			
			//모델명
			colModelList[0] = "AREA1";
			colModelList[1] = "GUBUN1";
			
			for(int i=2; i<intNum+2; i++) {
				columnNames[i] = ""+year;
				colModelList[i] = "data"+year;
				year++;
			}
		}
		
		
		///////////////////////////////////////////// 데이터 부분 ////////////////////////////////////////////////////
		
		from_sel_target_year=0;
		to_sel_target_year=0;
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("from_sel_target_year")) from_sel_target_year = MapUtils.getIntValue(rqstMap, "from_sel_target_year");
		if (rqstMap.containsKey("to_sel_target_year")) to_sel_target_year = MapUtils.getIntValue(rqstMap, "to_sel_target_year");
		
		//if(to_sel_target_year == 0) to_sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		to_sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅
		from_sel_target_year = 2003;				//to_sel_target_year == 0 -> 넘어오지 않으면 to_sel_target_year-2 세팅
		
		param.put("from_sel_target_year", from_sel_target_year);
		param.put("to_sel_target_year", to_sel_target_year);
		
		//기본으로 조회할 총 년도의 카운트를 계산
		intNum = (to_sel_target_year-from_sel_target_year)+1;
		
		int year = from_sel_target_year;
		String[] selectYear= new String[intNum];
		String[] selectAsYear= new String[intNum];
		for(int i=0; i<intNum; i++) {
			selectYear[i] = ""+year;
			selectAsYear[i] = "data"+year;
			year++;
		}
		
		param.put("selectYear", selectAsYear);
		
		if (rqstMap.containsKey("gSelect1")) param.put("gSelect1", rqstMap.get("gSelect1"));
		if (rqstMap.containsKey("gSelect2")) param.put("gSelect2", rqstMap.get("gSelect2"));

		gSelect1 = (String) rqstMap.get("gSelect1");		//업종이 그룹일때
		gSelect2 = (String) rqstMap.get("gSelect2");		//지역이 그룹일때
		
		String tmp1=null;
		String tmp2=null;
		String tmp3=null;
		String[] array_tmp1;
		String[] array_tmp2;
		String[] array_tmp3;
		
		//우선 업종을 받아서
		tmp1 = MapUtils.getString(rqstMap, "multiSelectGrid1");		// (제조, 비제조)
		tmp2 = MapUtils.getString(rqstMap, "multiSelectGrid2");		// (업종테마)
		tmp3 = MapUtils.getString(rqstMap, "ad_ind_cd");		// (상세업종)
		
		String induty_select = null;
		if (rqstMap.containsKey("induty_select")) induty_select = (String) rqstMap.get("induty_select");		// 업종 선택 구분
		
		// 선택 or 제조/비제조 구분이라면
		if(tmp1 != null && "A".equals(induty_select) || "I".equals(induty_select)) {
			array_tmp1 = tmp1.split(",");	// ','를 기준으로 잘라서
		
			if(!"null".equals(array_tmp1[0])) {
				for(int i=0; i < array_tmp1.length; i++) {
					if("UT00".equals(array_tmp1[i])) param.put("all_induty", "Y");		// 전산업 선택 시 all_induty : Y 로 넘김(전체)
					if("UT01".equals(array_tmp1[i])) array_tmp1[i] = "제조업";
					if("UT02".equals(array_tmp1[i])) array_tmp1[i] = "비제조업";
					
					param.put("multiSelectGrid1", array_tmp1);	// xml에서 사용될 제조/비제조 코드
				}
			// 제조/비제조 검색 시 항목을 선택하지 않았을 때 
			}else if("null".equals(array_tmp1[0])) {
				array_tmp1 = new String[1];
				array_tmp1[0] = "XXX";
				param.put("multiSelectGrid1", array_tmp1);
			}
		}else{
			
			param.put("multiSelectGrid1", null);
		}
		
		// 테마업종 선택한게 있으면 진행
		if(!"null".equals(tmp2) && tmp2 != null && "T".equals(induty_select)) {
			array_tmp2 = tmp2.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_tmp2[0])) {
				for(int i=0; i < array_tmp2.length; i++) {
				}
				
				param.put("multiSelectGrid2", array_tmp2);	// xml에서 사용될 업종테마별 코드
			}
		}else {
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_tmp2 = new String[1];
			array_tmp2[0] = "YYY";
			param.put("multiSelectGrid2", array_tmp2);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		
		// 임시 세팅
		// tmp3 = "A,C10,C12,C13";
		// 상세업종 선택한게 있으면 진행
		if(!"null".equals(tmp3) && tmp3 != null && "D".equals(induty_select)) {
			array_tmp3 = tmp3.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_tmp3[0])) {
				for(int i=0; i < array_tmp3.length; i++) {
					//array_tmp3[i] = array_tmp3[i].substring(array_tmp3[i].indexOf(":"), array_tmp3[i].length());
					array_tmp3[i] = array_tmp3[i].substring(0, array_tmp3[i].indexOf(":"));
				}
				
				param.put("multiSelectGrid3", array_tmp3);	// xml에서 사용될 상세업종별 코드
			}
		}else {
			array_tmp3 = new String[1];
			array_tmp3[0] = "ZZZ";
			param.put("multiSelectGrid3", array_tmp3);
		}
		
		
		index_type = null;
		index_kind = null;
		array_index_kind = null;
		if (rqstMap.containsKey("sel_index_type")) index_type = (String) rqstMap.get("sel_index_type");		// 지표구분
		if (rqstMap.containsKey("ad_index_kind")) index_kind = (String) rqstMap.get("ad_index_kind");		// 넘어오는 지표
		
		//지표를 처리한다
		if(rqstMap.get("ad_index_kind") != null && rqstMap.get("ad_index_kind") != "") {
			array_index_kind = index_kind.split(",");	// ','를 기준으로 잘라서

			param.put("array_index_kind", array_index_kind);
			
		}
		
		String sel_area = (String) rqstMap.get("sel_area");			// 지역 구분 선택 (권역별, 지역별)
		String area_sel = (String) rqstMap.get("cmpn_area_depth1");			// 권역별 선택값
		String city_sel = (String) rqstMap.get("cmpn_area_depth2");			// 지역별 선택값
		String[] array_area;
		String[] array_city;
		
		// 권역별 선택이 넘어온게 있으면
		if(!"null".equals(sel_area) && sel_area != null && sel_area !="" && "A".equals(sel_area) && !"null".equals(area_sel) && area_sel != null) {
			array_area = area_sel.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_area[0])) {
				for(int i=0; i < array_area.length; i++) {
				}
				
				param.put("cmpn_area_depth1", array_area);	// xml에서 사용될 권역별 코드
			}
		}else{
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_area = new String[1];
			array_area[0] = "XXX";
			param.put("cmpn_area_depth1", array_area);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		// 지역별 선택이 넘어온게 있으면
		if(!"null".equals(sel_area) && sel_area != null && sel_area !="" && "C".equals(sel_area) && !"null".equals(city_sel) && city_sel != null) {
			array_city = city_sel.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_city[0])) {
				for(int i=0; i < array_city.length; i++) {
				}
				
				param.put("cmpn_area_depth2", array_city);	// xml에서 사용될 권역별 코드
			}
		}else{
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_city = new String[1];
			array_city[0] = "XXX";
			param.put("cmpn_area_depth2", array_city);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		
		// 주요지표>추이 조회
		List<Map> entprsList = new ArrayList<Map>();
		
		/*
		if("W".equals(gSelect1) && "W".equals(gSelect2) && param.get("sel_area") == null && param.get("induty_select") == null){
			entprsList = entprsDAO.trnsitnList(param);
		}else {
			entprsList = entprsDAO.trnsitnList(param);
		}
		*/
		if("SUM".equals(index_type) ){
			entprsList = entprsDAO.trnsitnList(param);
		}else {
			entprsList = entprsDAO.trnsitnListAvg(param);
		} 
		
		
		
		/*
		 *  데이터 적재부분
		 *  각 구간에 해당하는 지표별 변수를 선언 후 조회조건에서 넘어온 년도들에 해당하는 entprsList의 결과값을 변수별로 저장하여 뒤에서 넘긴다.
		 *  ex) String aaa = "[[0,10],[1,20]]"; 
		 *       String bbb = "[[0,'2011'],[1,'2012']]"; 
		 *       의 형태가 되도록 만들기 위한 작업 -_-;
		 */
		String nm = "";		// 조회한 데이터 값을 담을 변수
		
		// for 이전에 뚜껑 선언
		String G01_data="["; 		String G02_data="["; 		String G03_data="["; 		String G04_data="["; 		String G05_data="[";
		String G06_data="[";
		String ticks="[";		//ticks에 들어갈 X축명 정의용
		
		int i=0;
		for(Map map : entprsList) {
			for(int j=0; j <selectYear.length; j++) {
				nm = MapUtils.getString(map, selectYear[j]);
				if(i == 0) {
					G01_data = G01_data + "[" + j + "," + nm + "],";		// 0~6년
				}else if(i == 1) {
					G02_data = G02_data + "[" + j + "," + nm + "],";		// 7~20년
				}else if(i == 2) {
					G03_data = G03_data + "[" + j + "," + nm + "],";		// 20~30년
				}else if(i == 3) {
					G04_data = G04_data + "[" + j + "," + nm + "],";		// 30~40년
				}else if(i == 4) {
					G05_data = G05_data + "[" + j + "," + nm + "],";		// 40~50년
				}else if(i == 5) {
					G06_data = G06_data + "[" + j + "," + nm + "],";		// 50년이상
				}
				ticks = ticks + "[" + j + "," + selectYear[j] + "],";
			}
			i++;
		}
		//for 종류 후 바닥
		G01_data=G01_data+"]";
		G02_data=G02_data+"]";
		G03_data=G03_data+"]";
		G04_data=G04_data+"]";
		G05_data=G05_data+"]";
		G06_data=G06_data+"]";
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
		mv.addObject("ticks", ticks);
		
		
		GridJsonVO gridJsonVo = new GridJsonVO();
		gridJsonVo.setRows(entprsList);
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchCondition"));
		
		mv.addObject("searchEntprsGrp",codeService.findCodeInfo(param).get("codeNm"));

		dataMap.put("colModelList", colModelList);
		dataMap.put("columnNames", columnNames);
		
		mv.addObject("colModelList", colModelList);
		mv.addObject("columnNames", columnNames);
		mv.addObject("array_index_kind", array_index_kind);
		mv.addObject("array_index_kind_length", array_index_kind.length);
		
		mv.addObject("ad_index_kind", rqstMap.get("ad_index_kind"));
		mv.addObject("from_sel_target_year", from_sel_target_year);
		mv.addObject("to_sel_target_year", to_sel_target_year);
		mv.addObject("gSelect1", gSelect1);
		mv.addObject("gSelect2", gSelect2);
		mv.addObject("listCnt", entprsList.size());
		mv.addObject("selectYear", selectYear);
		mv.addObject("entprsList", entprsList);

		return mv;
	}
	
	/**
	 * 구간별추이 챠트
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView sectionTrnsitnChart(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/PD_UIPSA0023_1");
		HashMap param = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));		// 조회조건 : 기업군
		//if (rqstMap.containsKey("induty_select")) param.put("induty_select", rqstMap.get("induty_select"));		// 업종 선택 구분
		param.put("induty_select", MapUtils.getString(rqstMap, "induty_select"));
		if (rqstMap.containsKey("multiSelectGrid1")) param.put("multiSelectGrid1", rqstMap.get("multiSelectGrid1"));		// (제조, 비제조)
		if (rqstMap.containsKey("multiSelectGrid2")) param.put("multiSelectGrid2", rqstMap.get("multiSelectGrid2"));		// (업종테마)
		if (rqstMap.containsKey("ad_ind_cd")) param.put("ad_ind_cd", rqstMap.get("ad_ind_cd"));		// (상세업종)
		
		//if (rqstMap.containsKey("sel_area")) param.put("sel_area", rqstMap.get("sel_area"));		// 지역 선택 구분(권역별 : A, 지역별 : C)
		param.put("sel_area", MapUtils.getString(rqstMap, "sel_area"));		// 지역 선택 구분(권역별 : A, 지역별 : C)
		if (rqstMap.containsKey("cmpn_area_depth1")) param.put("cmpn_area_depth1", rqstMap.get("cmpn_area_depth1"));		// 권역별
		if (rqstMap.containsKey("cmpn_area_depth2")) param.put("cmpn_area_depth2", rqstMap.get("cmpn_area_depth2"));		// 지역별(시)
		param.put("sel_index_type", MapUtils.getString(rqstMap, "sel_index_type"));
		param.put("ad_index_kind", MapUtils.getString(rqstMap, "ad_index_kind"));
		
		String searchCondition = param.get("searchCondition").toString();
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
		String[] selectAsYear= new String[intNum];
		for(int i=0; i<intNum; i++) {
			selectYear[i] = ""+year;
			selectAsYear[i] = "data"+year;
			year++;
		}
		
		//param.put("selectYear", selectYear);
		param.put("selectYear", selectAsYear);
		
		if("".equals(param.get("induty_select")) || param.get("induty_select") == "") param.put("induty_select", null);
		if("".equals(param.get("sel_area")) || param.get("sel_area") == "") param.put("sel_area", null);	
		
		if (rqstMap.containsKey("gSelect1")) param.put("gSelect1", rqstMap.get("gSelect1"));
		if (rqstMap.containsKey("gSelect2")) param.put("gSelect2", rqstMap.get("gSelect2"));
		String gSelect1 = (String) rqstMap.get("gSelect1");		//업종이 그룹일때
		String gSelect2 = (String) rqstMap.get("gSelect2");		//지역이 그룹일때
		
		String tmp1=null;
		String tmp2=null;
		String tmp3=null;
		String[] array_tmp1=null;
		String[] array_tmp2=null;
		String[] array_tmp3=null;
		
		//우선 업종을 받아서
		tmp1 = MapUtils.getString(rqstMap, "multiSelectGrid1");		// (제조, 비제조)
		tmp2 = MapUtils.getString(rqstMap, "multiSelectGrid2");		// (업종테마)
		tmp3 = MapUtils.getString(rqstMap, "ad_ind_cd");		// (상세업종)
		
		String induty_select = null;
		if (rqstMap.containsKey("induty_select")) induty_select = (String) rqstMap.get("induty_select");		// 업종 선택 구분
		
		
		// 선택 or 제조/비제조 구분이라면
		if(tmp1 != null && "A".equals(induty_select) || "I".equals(induty_select)) {
			array_tmp1 = tmp1.split(",");	// ','를 기준으로 잘라서
		
			if(!"null".equals(array_tmp1[0])) {
				for(int i=0; i < array_tmp1.length; i++) {
					if("UT00".equals(array_tmp1[i])) param.put("all_induty", "Y");		// 전산업 선택 시 all_induty : Y 로 넘김(전체)
					if("UT01".equals(array_tmp1[i])) array_tmp1[i] = "제조업";
					if("UT02".equals(array_tmp1[i])) array_tmp1[i] = "비제조업";
					
					param.put("multiSelectGrid1", array_tmp1);	// xml에서 사용될 제조/비제조 코드
				}
			// 제조/비제조 검색 시 항목을 선택하지 않았을 때 
			}else if("null".equals(array_tmp1[0])) {
				array_tmp1 = new String[1];
				array_tmp1[0] = "XXX";
				param.put("multiSelectGrid1", array_tmp1);
			}
		}else{
			
			param.put("multiSelectGrid1", null);
		}
		
		// 테마업종 선택한게 있으면 진행
		if(!"null".equals(tmp2) && tmp2 != null && "T".equals(induty_select)) {
			array_tmp2 = tmp2.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_tmp2[0])) {
				for(int i=0; i < array_tmp2.length; i++) {
				}
				
				param.put("multiSelectGrid2", array_tmp2);	// xml에서 사용될 업종테마별 코드
			}
		}else {
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_tmp2 = new String[1];
			array_tmp2[0] = "YYY";
			param.put("multiSelectGrid2", array_tmp2);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		
		// 임시 세팅
		// tmp3 = "A,C10,C12,C13";
		// 상세업종 선택한게 있으면 진행
		if(!"null".equals(tmp3) && tmp3 != null && "D".equals(induty_select)) {
			array_tmp3 = tmp3.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_tmp3[0])) {
				for(int i=0; i < array_tmp3.length; i++) {
					//array_tmp3[i] = array_tmp3[i].substring(array_tmp3[i].indexOf(":"), array_tmp3[i].length());
					array_tmp3[i] = array_tmp3[i].substring(0, array_tmp3[i].indexOf(":"));
				}
				
				param.put("multiSelectGrid3", array_tmp3);	// xml에서 사용될 상세업종별 코드
			}
		}else {
			array_tmp3 = new String[1];
			array_tmp3[0] = "ZZZ";
			param.put("multiSelectGrid3", array_tmp3);
		}
		
		
		String index_type = null;
		String index_kind = null;
		String[] array_index_kind;
		if (rqstMap.containsKey("sel_index_type")) index_type = (String) rqstMap.get("sel_index_type");		// 지표구분
		if (rqstMap.containsKey("ad_index_kind")) index_kind = (String) rqstMap.get("ad_index_kind");		// 넘어오는 지표
		
		//지표를 처리한다
		if(rqstMap.get("ad_index_kind") != null && rqstMap.get("ad_index_kind") != "") {
			array_index_kind = index_kind.split(",");	// ','를 기준으로 잘라서
			
			param.put("array_index_kind", array_index_kind);
		}
		
		String sel_area = (String) rqstMap.get("sel_area");			// 지역 구분 선택 (권역별, 지역별)
		String area_sel = (String) rqstMap.get("cmpn_area_depth1");			// 권역별 선택값
		String city_sel = (String) rqstMap.get("cmpn_area_depth2");			// 지역별 선택값
		String[] array_area;
		String[] array_city;
		
		// 권역별 선택이 넘어온게 있으면
		if(!"null".equals(sel_area) && sel_area != null && sel_area !="" && "A".equals(sel_area) && !"null".equals(sel_area) && sel_area != null) {
			array_area = area_sel.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_area[0])) {
				for(int i=0; i < array_area.length; i++) {
				}
				
				param.put("cmpn_area_depth1", array_area);	// xml에서 사용될 권역별 코드
			}
		}else{
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_area = new String[1];
			array_area[0] = "XXX";
			param.put("cmpn_area_depth1", array_area);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		// 지역별 선택이 넘어온게 있으면
		if(!"null".equals(param.get("sel_area")) && param.get("sel_area") != null && param.get("sel_area") !="" && "C".equals(param.get("sel_area")) && !"null".equals(city_sel) && city_sel != null) {
			array_city = city_sel.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_city[0])) {
				for(int i=0; i < array_city.length; i++) {
				}
				
				param.put("cmpn_area_depth2", array_city);	// xml에서 사용될 권역별 코드
			}
		}else{
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_city = new String[1];
			array_city[0] = "XXX";
			param.put("cmpn_area_depth2", array_city);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		
		param.put("indutyNm", array_tmp1);	// xml에서 사용려고한 업종명
		param.put("areaNm", array_tmp2);	// xml에서 사용될 지역명
		
		//주요지표>구간별추이 조회
		List<Map> entprsList = new ArrayList<Map>();
		//entprsList = pgps0120DAO.sectionTrnsitnChart(param);
		if("W".equals(gSelect1) && "W".equals(gSelect2) && param.get("sel_area") == null && param.get("induty_select") == null){
//			entprsList = pgps0120DAO.sectionTrnsitnListAll(param);
		}else {
//			entprsList = pgps0120DAO.sectionTrnsitnList(param);
		}
		
		/*
		 *  데이터 적재부분
		 *  각 구간에 해당하는 지표별 변수를 선언 후 조회조건에서 넘어온 년도들에 해당하는 entprsList의 결과값을 변수별로 저장하여 뒤에서 넘긴다.
		 *  ex) String aaa = "[[0,10],[1,20]]"; 
		 *       String bbb = "[[0,'2011'],[1,'2012']]"; 
		 *       의 형태가 되도록 만들기 위한 작업 -_-;
		 */
		String nm = "";		// 조회한 데이터 값을 담을 변수
		
		// for 이전에 뚜껑 선언
		String G01_data="["; 		String G02_data="["; 		String G03_data="["; 		String G04_data="["; 		String G05_data="[";
		String G06_data="[";
		String ticks="[";		//ticks에 들어갈 X축명 정의용
		
		int i=0;
		for(Map map : entprsList) {
			for(int j=0; j <selectYear.length; j++) {
				nm = MapUtils.getString(map, selectYear[j]);
				if(i == 0) {
					G01_data = G01_data + "[" + j + "," + nm + "],";		// 0~6년
				}else if(i == 1) {
					G02_data = G02_data + "[" + j + "," + nm + "],";		// 7~20년
				}else if(i == 2) {
					G03_data = G03_data + "[" + j + "," + nm + "],";		// 20~30년
				}else if(i == 3) {
					G04_data = G04_data + "[" + j + "," + nm + "],";		// 30~40년
				}else if(i == 4) {
					G05_data = G05_data + "[" + j + "," + nm + "],";		// 40~50년
				}else if(i == 5) {
					G06_data = G06_data + "[" + j + "," + nm + "],";		// 50년이상
				}
				ticks = ticks + "[" + j + "," + selectYear[j] + "],";
			}
			i++;
		}
		//for 종류 후 바닥
		G01_data=G01_data+"]";
		G02_data=G02_data+"]";
		G03_data=G03_data+"]";
		G04_data=G04_data+"]";
		G05_data=G05_data+"]";
		G06_data=G06_data+"]";
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
		mv.addObject("ticks", ticks);
		
		// 데이터 추가
		mv.addObject("sel_index_type", rqstMap.get("sel_index_type"));
		mv.addObject("ad_index_kind", rqstMap.get("ad_index_kind"));
		mv.addObject("searchCondition", searchCondition);
		mv.addObject("from_sel_target_year", from_sel_target_year);
		mv.addObject("to_sel_target_year", to_sel_target_year);
		mv.addObject("gSelect1", gSelect1);
		mv.addObject("gSelect2", gSelect2);
		mv.addObject("listCnt", entprsList.size());
		mv.addObject("selectYear", selectYear);
		mv.addObject("entprsList", entprsList);
		
		return mv;
	}
}
