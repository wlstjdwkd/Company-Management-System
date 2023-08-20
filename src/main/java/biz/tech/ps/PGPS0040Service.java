package biz.tech.ps;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.code.CodeService;
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

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import biz.tech.mapif.ps.PGPS0010Mapper;
import biz.tech.mapif.ps.PGPS0020Mapper;
import biz.tech.mapif.ps.PGPS0030Mapper;
import biz.tech.mapif.ps.PGPS0040Mapper;


/**
 * 외투기업별현황 서비스 클래스
 * @author CWJ
 */
@Service("PGPS0040")
public class PGPS0040Service extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(PGPS0040Service.class);
	
	@Resource(name = "PGPS0040Mapper")
	private PGPS0040Mapper pgps0040Dao; // 외투기업별현황Mapper
	
	@Resource(name = "PGPS0030Mapper")
	private PGPS0030Mapper pgps0030Dao; // 거래유형별현황Mapper
	
	@Resource(name = "PGPS0020Mapper")
	private PGPS0020Mapper pgps0020Dao; // 현황및 통계 Mapper
	
	@Resource(name = "PGPS0010Mapper")
	private PGPS0010Mapper pgps0010Dao;
	
	@Autowired
	private CodeService codeService; // 공통코드서비스
	
	/**
	 * 외투기업별현황 통계 화면
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/BD_UIPSA0040");
		
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
		mv.addObject("areaCity", pgps0020Dao.findCodesCity(param));
		
		// 초기검색조건 설정
		if (!rqstMap.containsKey("searchEntprsGrp")) rqstMap.put("searchEntprsGrp", "EA1");
		if (!rqstMap.containsKey("searchStdyy")) rqstMap.put("searchStdyy", stdyyList.get(0).get("stdyy"));
		
		mv.addObject("resultList", selectStaticsList(rqstMap));
		
		// 테이블 타이틀 조회
		param = new HashMap();
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrp"));
		mv.addObject("tableTitle",codeService.findCodeInfo(param).get("codeNm"));
		
		return mv;
	}
	
	/**
	 * 외투기업별현황 통계 화면(매출액기준)
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectStaticsSellAm(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/BD_UIPSA0041");
		
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
		mv.addObject("areaCity", pgps0020Dao.findCodesCity(param));

		// 초기검색조건 설정
		if (!rqstMap.containsKey("searchEntprsGrp")) rqstMap.put("searchEntprsGrp", "EA1");
		if (!rqstMap.containsKey("searchStdyy")) rqstMap.put("searchStdyy", stdyyList.get(0).get("stdyy"));
		
		mv.addObject("resultList", selectStaticsList(rqstMap));
		
		// 테이블 타이틀 조회
		param = new HashMap();
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrp"));
		mv.addObject("tableTitle",codeService.findCodeInfo(param).get("codeNm"));
		
		return mv;
	}
	
	/**
	 * 외투기업별현황 데이터 목록 조회(RAW)
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectStaticsData(Map rqstMap) throws Exception {
		HashMap param = new HashMap();
		
		param.put("entcls", rqstMap.get("searchEntprsGrp")); // 기업군조건
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
		
		return pgps0040Dao.selectStaticsDataList(param);
	}
	
	/**
	 * 외투기업별현황 통계 조회(가공처리)
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
		BigDecimal sumFieCo = new BigDecimal(0);
		BigDecimal sumNfieCo = new BigDecimal(0);
		BigDecimal sumCo = new BigDecimal(0);
		BigDecimal sumFieXPAm = new BigDecimal(0);
		BigDecimal sumNfieXPAm = new BigDecimal(0);
		BigDecimal sumXPAm = new BigDecimal(0);
		BigDecimal sumFieDMAm = new BigDecimal(0);
		BigDecimal sumNfieDMAm = new BigDecimal(0);
		BigDecimal sumDMAm = new BigDecimal(0);
		
		// 전산업
		BigDecimal totalFieCo = new BigDecimal(0);
		BigDecimal totalNfieCo = new BigDecimal(0);
		BigDecimal totalCo = new BigDecimal(0);
		BigDecimal totalFieXPAm = new BigDecimal(0);
		BigDecimal totalNfieXPAm = new BigDecimal(0);
		BigDecimal totalXPAm = new BigDecimal(0);
		BigDecimal totalFieDMAm = new BigDecimal(0);
		BigDecimal totalNfieDMAm = new BigDecimal(0);
		BigDecimal totalDMAm = new BigDecimal(0);
		
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
					sumMap.put("fieCo", sumFieCo);
					sumMap.put("nfieCo", sumNfieCo);
					sumMap.put("sumCo", sumCo);
					sumMap.put("fieXportAm", sumFieXPAm);
					sumMap.put("nfieXportAm", sumNfieXPAm);
					sumMap.put("sumXportAm", sumXPAm);
					sumMap.put("fieDomeAm", sumFieDMAm);
					sumMap.put("nfieDomeAm", sumNfieDMAm);
					sumMap.put("sumDomeAm", sumDMAm);
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
					
					sumFieCo = new BigDecimal(0);
					sumNfieCo = new BigDecimal(0);
					sumCo = new BigDecimal(0);
					sumFieXPAm = new BigDecimal(0);
					sumNfieXPAm = new BigDecimal(0);
					sumXPAm = new BigDecimal(0);
					sumFieDMAm = new BigDecimal(0);
					sumNfieDMAm = new BigDecimal(0);
					sumDMAm = new BigDecimal(0);
				}


				if (cndArea && !stdAreaFt.equals(areaFt)) {
					stdAreaFt = areaFt;
					
					prevInfo = resultList.get(i-1);
					
					sumMap = new HashMap();
					sumMap.put("gbnAs", prevInfo.get("gbnAs"));
					sumMap.put("gbnIs", "S");
					sumMap.put("fieCo", totalFieCo);
					sumMap.put("nfieCo", totalNfieCo);
					sumMap.put("sumCo", totalCo);
					sumMap.put("fieXportAm", totalFieXPAm);
					sumMap.put("nfieXportAm", totalNfieXPAm);
					sumMap.put("sumXportAm", totalXPAm);
					sumMap.put("fieDomeAm", totalFieDMAm);
					sumMap.put("nfieDomeAm", totalNfieDMAm);
					sumMap.put("sumDomeAm", totalDMAm);
					sumMap.put("indutySeNm", "전산업");
					sumMap.put("dtlclfcNm", "전산업");
					sumMap.put("indutyNm", "전산업");
					sumMap.put("upperNm", prevInfo.get("upperNm"));
					sumMap.put("abrv", prevInfo.get("abrv"));
					
					rtnList.add(sumMap);
					if (sumList.size() > 0) rtnList.addAll(sumList);
					
					sumList = new ArrayList<Map>();
					
					totalFieCo = new BigDecimal(0);
					totalNfieCo = new BigDecimal(0);
					totalCo = new BigDecimal(0);
					totalFieXPAm = new BigDecimal(0);
					totalNfieXPAm = new BigDecimal(0);
					totalXPAm = new BigDecimal(0);
					totalFieDMAm = new BigDecimal(0);
					totalNfieDMAm = new BigDecimal(0);
					totalDMAm = new BigDecimal(0);
				}
				
				// 제조/비제조 합계
				sumFieCo = sumFieCo.add((BigDecimal) resultInfo.get("fieCo"));
				sumNfieCo = sumNfieCo.add((BigDecimal) resultInfo.get("nfieCo"));
				sumCo = sumCo.add((BigDecimal) resultInfo.get("sumCo"));
				sumFieXPAm = sumFieXPAm.add((BigDecimal) resultInfo.get("fieXportAm"));
				sumNfieXPAm = sumNfieXPAm.add((BigDecimal) resultInfo.get("nfieXportAm"));
				sumXPAm = sumXPAm.add((BigDecimal) resultInfo.get("sumXportAm"));
				sumFieDMAm = sumFieDMAm.add((BigDecimal) resultInfo.get("fieDomeAm"));
				sumNfieDMAm = sumNfieDMAm.add((BigDecimal) resultInfo.get("nfieDomeAm"));
				sumDMAm = sumDMAm.add((BigDecimal) resultInfo.get("sumDomeAm"));
				
				// 지역별 전산업 합계
				totalFieCo = totalFieCo.add((BigDecimal) resultInfo.get("fieCo"));
				totalNfieCo = totalNfieCo.add((BigDecimal) resultInfo.get("nfieCo"));
				totalCo = totalCo.add((BigDecimal) resultInfo.get("sumCo"));
				totalFieXPAm = totalFieXPAm.add((BigDecimal) resultInfo.get("fieXportAm"));
				totalNfieXPAm = totalNfieXPAm.add((BigDecimal) resultInfo.get("nfieXportAm"));
				totalXPAm = totalXPAm.add((BigDecimal) resultInfo.get("sumXportAm"));
				totalFieDMAm = totalFieDMAm.add((BigDecimal) resultInfo.get("fieDomeAm"));
				totalNfieDMAm = totalNfieDMAm.add((BigDecimal) resultInfo.get("nfieDomeAm"));
				totalDMAm = totalDMAm.add((BigDecimal) resultInfo.get("sumDomeAm"));	
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
				sumMap.put("fieCo", sumFieCo);
				sumMap.put("nfieCo", sumNfieCo);
				sumMap.put("sumCo", sumCo);
				sumMap.put("fieXportAm", sumFieXPAm);
				sumMap.put("nfieXportAm", sumNfieXPAm);
				sumMap.put("sumXportAm", sumXPAm);
				sumMap.put("fieDomeAm", sumFieDMAm);
				sumMap.put("nfieDomeAm", sumNfieDMAm);
				sumMap.put("sumDomeAm", sumDMAm);
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
			sumMap.put("fieCo", totalFieCo);
			sumMap.put("nfieCo", totalNfieCo);
			sumMap.put("sumCo", totalCo);
			sumMap.put("fieXportAm", totalFieXPAm);
			sumMap.put("nfieXportAm", totalNfieXPAm);
			sumMap.put("sumXportAm", totalXPAm);
			sumMap.put("fieDomeAm", totalFieDMAm);
			sumMap.put("nfieDomeAm", totalNfieDMAm);
			sumMap.put("sumDomeAm", totalDMAm);
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
		
		// 파일명(기준년도)
		String stdyy = MapUtils.getString(rqstMap, "searchStdyy");
		
		// 파일명(기업군) 조회
		HashMap param = new HashMap();
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrp"));
		
		String entprs = (String) codeService.findCodeInfo(param).get("codeNm");

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

		// 기업현황/매출형태 구분
		if (MapUtils.getString(rqstMap, "ad_type", "1").equals("1")) {
			headers.add("외투기업");
			headers.add("비회투기업");
			headers.add("합계");
		} else {
			headers.add("외투기업");
			headers.add("");
			headers.add("비외투기업");
			headers.add("");
			headers.add("합계");
			headers.add("");
			subHeaders.add("국내매출");
			subHeaders.add("해외매출");
			subHeaders.add("국내매출");
			subHeaders.add("해외매출");
			subHeaders.add("국내매출");
			subHeaders.add("해외매출");
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
		
		// 기업현황/매출형태 구분
		if (MapUtils.getString(rqstMap, "ad_type", "1").equals("1")) {
			items.add("fieCo");
			items.add("nfieCo");
			items.add("sumCo");
		} else {
			items.add("fieDomeAm");
			items.add("fieXportAm");
			items.add("nfieDomeAm");
			items.add("nfieXportAm");
			items.add("sumDomeAm");
			items.add("sumXportAm");
		}

		String[] arryHeaders = new String[] {};
		String[] arryItems = new String[] {};
		arryHeaders = headers.toArray(arryHeaders);
		arryItems = items.toArray(arryItems);
		
		mv.addObject("_headers", arryHeaders);
		mv.addObject("_items", arryItems);
		mv.addObject("_list", selectStaticsList(rqstMap));
		
		IExcelVO excel = null;
		
		if (MapUtils.getString(rqstMap, "ad_type", "1").equals("1")) {
			excel = new ExcelVO("외투기업별현황_기업현황_"+DateFormatUtil.getTodayFull());
		} else {
			String[] arrySubHeaders = new String[] {};
			arrySubHeaders = subHeaders.toArray(arrySubHeaders);
			mv.addObject("_subHeaders", arrySubHeaders);
			
			excel = new PGPS0030ExcelVO("외투기업별현황_매출형태_"+DateFormatUtil.getTodayFull());
		}
		
		return ResponseUtil.responseExcel(mv, excel);
	}
	
	// 챠트 popup
	public ModelAndView getAllChart(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();

		// 기업현황챠트
		if(MapUtils.getInteger(rqstMap, "ad_type") == 1) {
			mv.setViewName("/admin/ps/PD_UIPSA0040_1");
		}
		// 매출형태챠트
		else if(MapUtils.getInteger(rqstMap, "ad_type") == 2) {
			mv.setViewName("/admin/ps/PD_UIPSA0041_1");
		}

		HashMap param = new HashMap();
		
		// 검색조건 년도목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);

		// 초기검색조건 설정
		if (!rqstMap.containsKey("searchEntprsGrp")) rqstMap.put("searchEntprsGrp", "EA1");
		if (!rqstMap.containsKey("searchStdyy")) rqstMap.put("searchStdyy", stdyyList.get(0).get("stdyy"));
		
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
		String searchStdyy = MapUtils.getString(rqstMap, "searchStdyy");
		
		// 지역별 챠트 쿼리
		rqstMap.put("ad_chartY", "area");
		List<Map> areaResultList = selectStaticsData(rqstMap);
		// 업무별 챠트 쿼리
		rqstMap.put("ad_chartY", "induty");
		List<Map> indutyResultList = selectStaticsData(rqstMap);
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrp"));
		mv.addObject("searchEntprsGrp",codeService.findCodeInfo(param).get("codeNm"));
		
		mv.addObject("searchStdyy",searchStdyy);
		mv.addObject("searchArea",searchArea);
		mv.addObject("searchInduty",searchInduty);
		mv.addObject("areaResultList", areaResultList);
		mv.addObject("areaListCnt", areaResultList.size());
		mv.addObject("indutyResultList", indutyResultList);
		mv.addObject("indutyListCnt", indutyResultList.size());
		
		return mv;
	}
	
	// 출력 popup
	public ModelAndView getPrintOut(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();

		// 기업현황출력
		if(MapUtils.getInteger(rqstMap, "ad_type") == 1) {
			mv.setViewName("/admin/ps/PD_UIPSA0040_2");
		}
		// 매출형태출력
		else if(MapUtils.getInteger(rqstMap, "ad_type") == 2) {
			mv.setViewName("/admin/ps/PD_UIPSA0041_2");
		}
		
		HashMap param = new HashMap();
		
		// 검색조건 년도목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);

		// 초기검색조건 설정
		if (!rqstMap.containsKey("searchEntprsGrp")) rqstMap.put("searchEntprsGrp", "EA1");
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
		
		List<Map> resultList = selectStaticsList(rqstMap);
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrp"));
		
		mv.addObject("searchEntprsGrp",codeService.findCodeInfo(param).get("codeNm"));
		mv.addObject("searchStdyy",searchStdyy);
		mv.addObject("searchArea",searchArea);
		mv.addObject("searchInduty",searchInduty);
		mv.addObject("resultList", resultList);
		mv.addObject("listCnt", resultList.size());
		
		return mv;
	}
}
