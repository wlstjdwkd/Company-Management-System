package biz.tech.ps;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.code.CodeService;
import com.comm.response.ExcelVO;
import com.comm.response.GridJsonVO;
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
import biz.tech.mapif.ps.PGPS0063Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


/**
 * 현황및통계
 * @author JGS
 *
 */
@Service("PGPS0063")
public class PGPS0063Service extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(PGPS0063Service.class);
	
	@Autowired
	CodeService codeService;
	
	@Resource(name = "PGPS0020Mapper")
	private PGPS0020Mapper PGPS0020DAO;
	
	@Resource(name = "PGPS0063Mapper")
	private PGPS0063Mapper entprsDAO;
	
	
	@Resource(name = "PGPS0030Mapper")
	private PGPS0030Mapper pgps0030Dao; // 거래유형별현황Mapper
	
	@Resource(name = "PGPS0020Mapper")
	private PGPS0020Mapper pgps0020Dao; // 현황및 통계 Mapper
	
	@Resource(name = "PGPS0010Mapper")
	private PGPS0010Mapper pgps0010Dao;
	
	/**
	 * 성장및회귀현황>업종별성장현황
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/ps/BD_UIPSA0063");
		HashMap param = new HashMap();
		param.put("param", 41);
		
		// 검색조건 년도목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		mv.addObject("stdyyList", stdyyList);
		
		// 검색조건 업종테마목록 조회
		//mv.addObject("themaList", pgps0030Dao.selectInduThemaList(param));		
		mv.addObject("themaList1", PGPS0020DAO.indutyCd2(param));
		mv.addObject("themaList2", PGPS0020DAO.indutyCd3(param));
		
		// 검색조건 상세업종목록 조회
		mv.addObject("indutyList", pgps0030Dao.selectIndutyList(param));
		
		// 검색조건 지역코드(권역별)목록 조회
		mv.addObject("areaState", codeService.findCodesByGroupNo("57"));
		
		// 검색조건 지역코드(광역시)목록 조회
		mv.addObject("areaCity", pgps0020Dao.findCodesCity(param));
				
		/*mv.addObject("areaCode1", areaCode1);
		mv.addObject("areaCode2", areaCode2);
		mv.addObject("indutyCd2", indutyCd2);
		mv.addObject("indutyCd3", indutyCd3);
		mv.addObject("areaCity", areaCity);
		mv.addObject("areaCityJson", JsonUtil.toJson(areaCity));*/
		
		// 초기검색조건 설정
		if (!rqstMap.containsKey("searchEntprsGrp")) rqstMap.put("searchEntprsGrp", "EA1");
		if (!rqstMap.containsKey("searchStdyy")) rqstMap.put("searchStdyy", stdyyList.get(0).get("stdyy"));
		
		logger.debug("-----------PGPS0063Service>index selectGetGridSttusList 호출");
		mv.addObject("resultList", selectGetGridSttusList(rqstMap));
		
		// 테이블 타이틀 조회
		param = new HashMap();
		
		param.put("codeGroupNo", "14");
		param.put("code", MapUtils.getString(rqstMap, "searchEntprsGrp"));
		mv.addObject("tableTitle",codeService.findCodeInfo(param).get("codeNm"));
		
		return mv;
		
	}
	
	/**
	 * 성장및회귀현황>업종별성장현황
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getGridSttusList(Map<?, ?> rqstMap) throws Exception {	
		HashMap param = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("induty_select")) param.put("induty_select", rqstMap.get("induty_select"));		// 업종 선택 구분
		if (rqstMap.containsKey("multiSelectGrid1")) param.put("multiSelectGrid1", rqstMap.get("multiSelectGrid1"));		// (제조, 비제조)
		if (rqstMap.containsKey("multiSelectGrid2")) param.put("multiSelectGrid2", rqstMap.get("multiSelectGrid2"));		// (업종테마)
		if (rqstMap.containsKey("multiSelectGrid3")) param.put("multiSelectGrid3", rqstMap.get("multiSelectGrid3"));		// (상세업종)
		if (rqstMap.containsKey("sel_area")) param.put("sel_area", rqstMap.get("sel_area"));		// 지역 선택 구분(권역별 : A, 지역별 : C)
		if (rqstMap.containsKey("cmpn_area_depth1")) param.put("cmpn_area_depth1", rqstMap.get("cmpn_area_depth1"));		// 권역별
		if (rqstMap.containsKey("cmpn_area_depth2")) param.put("cmpn_area_depth2", rqstMap.get("cmpn_area_depth2"));		// 지역별(시)
		
		String induty_select = "A";
		int sel_target_year=0;
		
		if (rqstMap.containsKey("induty_select")) induty_select = (String) rqstMap.get("induty_select");		// 업종 선택 구분
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("sel_target_year")) sel_target_year = MapUtils.getIntValue(rqstMap, "sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(sel_target_year == 0) sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		
		param.put("sel_target_year", sel_target_year);
		param.put("induty_select", induty_select);
		
		if (rqstMap.containsKey("gSelect1")) param.put("gSelect1", rqstMap.get("gSelect1"));
		if (rqstMap.containsKey("gSelect2")) param.put("gSelect2", rqstMap.get("gSelect2"));

		String gSelect1 = (String) rqstMap.get("gSelect1");		//업종이 그룹일때
		String gSelect2 = (String) rqstMap.get("gSelect2");		//지역이 그룹일때
		
		logger.debug("-----------PGPS0063Service>getGridSttusList>induty_select: "+induty_select);
		logger.debug("-----------PGPS0063Service>getGridSttusList>induty_select: "+param.get("induty_select"));
		logger.debug("-----------PGPS0063Service>getGridSttusList>gSelect1: "+gSelect1);
		logger.debug("-----------PGPS0063Service>getGridSttusList>gSelect2: "+gSelect2);
		logger.debug("-----------PGPS0063Service>getGridSttusList>sel_target_year:"+sel_target_year);
		logger.debug("-----------PGPS0063Service>getGridSttusList>multiSelectGrid1: "+param.get("multiSelectGrid1"));
		logger.debug("-----------PGPS0063Service>getGridSttusList>multiSelectGrid2: "+param.get("multiSelectGrid2"));
		logger.debug("-----------PGPS0063Service>getGridSttusList>multiSelectGrid3: "+param.get("multiSelectGrid3"));
		
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
					
					logger.debug("-----------PGPS0063Service>getGridSttusList>array_tmp1["+i+"]:"+array_tmp1[i]);
					logger.debug("-----------PGPS0063Service>getGridSttusList>all_induty["+i+"]:"+param.get("all_induty"));
					
					param.put("multiSelectGrid1", array_tmp1);	// xml에서 사용될 제조/비제조 코드
				}
			// 제조/비제조 검색 시 항목을 선택하지 않았을 때 
			}else if("null".equals(array_tmp1[0])) {
				array_tmp1 = new String[1];
				array_tmp1[0] = "XXX";
				param.put("multiSelectGrid1", array_tmp1);
			}
		}else{
			logger.debug("---------------------업종선택이 없다-------------------------------");
			
			param.put("multiSelectGrid1", null);
		}
		
		logger.debug("-----------PGPS0063Service>getGridSttusList>tmp2:"+tmp2);
		// 테마업종 선택한게 있으면 진행
		if(!"null".equals(tmp2) && tmp2 != null && "T".equals(induty_select)) {
			array_tmp2 = tmp2.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_tmp2[0])) {
				for(int i=0; i < array_tmp2.length; i++) {
					logger.debug("-----------------------PGPS0063Service>getGridSttusList>array_tmp2["+i+"]:"+array_tmp2[i]);
				}
				
				param.put("multiSelectGrid2", array_tmp2);	// xml에서 사용될 업종테마별 코드
			}
		}else {
			logger.debug("---------------------테마업종 선택이 없다-------------------------------");
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_tmp2 = new String[1];
			array_tmp2[0] = "XXX";
			param.put("multiSelectGrid2", array_tmp2);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		logger.debug("-----------PGPS0063Service>getGridSttusList>tmp3:"+tmp3);
		
		// 임시 세팅
		// tmp3 = "A,C10,C12,C13";
		
		// 상세업종 선택한게 있으면 진행
		if(!"null".equals(tmp3) && tmp3 != null && "D".equals(induty_select)) {
			array_tmp3 = tmp3.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_tmp3[0])) {
				for(int i=0; i < array_tmp3.length; i++) {
					logger.debug("-----------------------PGPS0063Service>getGridSttusList>array_tmp3["+i+"]:"+array_tmp3[i]);
				}
				
				param.put("multiSelectGrid3", array_tmp3);	// xml에서 사용될 상세업종별 코드
			}
		}else {
			logger.debug("---------------------상세업종 선택이 없다-------------------------------");
			array_tmp3 = new String[1];
			array_tmp3[0] = "XXX";
			param.put("multiSelectGrid3", array_tmp3);
		}
		
		String sel_area = (String) rqstMap.get("sel_area");			// 지역 구분 선택 (권역별, 지역별)
		String area_sel = (String) rqstMap.get("cmpn_area_depth1");			// 권역별 선택값
		String city_sel = (String) rqstMap.get("cmpn_area_depth2");			// 지역별 선택값
		String[] array_area;
		String[] array_city;
		
		logger.debug("-----------PGPS0063Service>getGridSttusList>sel_area:"+sel_area);
		logger.debug("-----------PGPS0063Service>getGridSttusList>area_sel:"+area_sel);
		logger.debug("-----------PGPS0063Service>getGridSttusList>city_sel:"+city_sel);
		// 권역별 선택이 넘어온게 있으면
		if(!"null".equals(sel_area) && sel_area != null && sel_area !="" && "A".equals(sel_area) && !"null".equals(area_sel) && area_sel != null) {
			logger.debug("---------------------권역별 선택이 들어왔다-------------------------------");
			array_area = area_sel.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_area[0])) {
				for(int i=0; i < array_area.length; i++) {
					logger.debug("-----------------------PGPS0063Service>getGridSttusList>array_area["+i+"]:"+array_area[i]);
				}
				
				param.put("cmpn_area_depth1", array_area);	// xml에서 사용될 권역별 코드
			}
		}else{
			logger.debug("---------------------권역선택이 없다-------------------------------");
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_area = new String[1];
			array_area[0] = "XXX";
			param.put("cmpn_area_depth1", array_area);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		// 지역별 선택이 넘어온게 있으면
		if(!"null".equals(sel_area) && sel_area != null && sel_area !="" && "C".equals(sel_area) && !"null".equals(city_sel) && city_sel != null) {
			logger.debug("---------------------지역별 선택이 들어왔다-------------------------------");
			array_city = city_sel.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_city[0])) {
				for(int i=0; i < array_city.length; i++) {
					logger.debug("-----------------------PGPS0063Service>getGridSttusList>array_city["+i+"]:"+array_city[i]);
				}
				
				param.put("cmpn_area_depth2", array_city);	// xml에서 사용될 권역별 코드
			}
		}else{
			logger.debug("---------------------지역선택이 없다-------------------------------");
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_city = new String[1];
			array_city[0] = "XXX";
			param.put("cmpn_area_depth2", array_city);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		
		
		// 성장및회귀현황>업종별성장현황
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.selectSttus(param);
		
		logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&: "+entprsList.toString());
		
		GridJsonVO gridJsonVo = new GridJsonVO();
		gridJsonVo.setRows(entprsList);
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("entprsSize", entprsList.size());
		return ResponseUtil.responseGridJson(mv, gridJsonVo);	
	}
	
	
	/**
	 * 성장및회귀현황>업종별성장현황
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView processGetGridSttusListMain(Map<?, ?> rqstMap) throws Exception {	
		HashMap param = new HashMap();
		Map dataMap = new HashMap();
		
		if (rqstMap.containsKey("gSelect1")) param.put("gSelect1", rqstMap.get("gSelect1"));
		if (rqstMap.containsKey("gSelect2")) param.put("gSelect2", rqstMap.get("gSelect2"));

		String gSelect1 = (String) rqstMap.get("gSelect1");		//업종이 그룹일때
		String gSelect2 = (String) rqstMap.get("gSelect2");		//지역이 그룹일때
		
		logger.debug("-----------PGPS0063Service>processGetGridSttusListMain>gSelect1: "+gSelect1);
		logger.debug("-----------PGPS0063Service>processGetGridSttusListMain>gSelect2: "+gSelect2);
		
		String[] columnNames = null;
		String[] colModelList = null;
		
		// 기본화면 및 전체보기
		if ((gSelect1 == null && gSelect2 == null) || ("G".equals(gSelect1) && "G".equals(gSelect2)) || ("W".equals(gSelect1) && "W".equals(gSelect2))) {
		
			// 컬럼명을 배열형태로
			columnNames = new String[11];
			colModelList = new String[11];
			
			//컬럼명
			columnNames[0] = "지역";
			columnNames[1] = "업종";
			columnNames[2] = "기업수(개)";
			columnNames[3] = "평균(천원)";
			columnNames[4] = "성장률";
			columnNames[5] = "평균(명)";
			columnNames[6] = "성장률";
			columnNames[7] = "평균(천원)";
			columnNames[8] = "성장률";
			columnNames[9] = "평균(천원)";
			columnNames[10] = "집약도(%)";
			
			//모델명
			colModelList[0] = "AREA1";
			colModelList[1] = "COL1";
			colModelList[2] = "ENTRPRS_CO";
			colModelList[3] = "SELNG_AM";
			colModelList[4] = "SELNG_RT";
			colModelList[5] = "ORDTM_LABRR_CO";
			colModelList[6] = "ORDTM_RT";
			colModelList[7] = "XPORT_AM_WON";
			colModelList[8] = "XPORT_AM_WON_RT";
			colModelList[9] = "RSRCH_DEVLOP_CT";
			colModelList[10] = "RSRCH_RT";
			
		//업종 그룹
		}else if ("G".equals(gSelect1) && ("W".equals(gSelect2) || gSelect2 == null)) {
			// 컬럼명을 배열형태로
			columnNames = new String[10];
			colModelList = new String[10];
			
			//컬럼명
			columnNames[0] = "업종";
			columnNames[1] = "기업수(개)";
			columnNames[2] = "평균(천원)";
			columnNames[3] = "성장률";
			columnNames[4] = "평균(명)";
			columnNames[5] = "성장률";
			columnNames[6] = "평균(천원)";
			columnNames[7] = "성장률";
			columnNames[8] = "평균(천원)";
			columnNames[9] = "집약도(%)";
			
			//모델명
			colModelList[0] = "COL1";
			colModelList[1] = "ENTRPRS_CO";
			colModelList[2] = "SELNG_AM";
			colModelList[3] = "SELNG_RT";
			colModelList[4] = "ORDTM_LABRR_CO";
			colModelList[5] = "ORDTM_RT";
			colModelList[6] = "XPORT_AM_WON";
			colModelList[7] = "XPORT_AM_WON_RT";
			colModelList[8] = "RSRCH_DEVLOP_CT";
			colModelList[9] = "RSRCH_RT";
			
		//지역 그룹
		}else if (("W".equals(gSelect1) || gSelect1 == null) && "G".equals(gSelect2)) {
			// 컬럼명을 배열형태로
			columnNames = new String[10];
			colModelList = new String[10];
			
			//컬럼명
			columnNames[0] = "지역";
			columnNames[1] = "기업수(개)";
			columnNames[2] = "평균(천원)";
			columnNames[3] = "성장률";
			columnNames[4] = "평균(명)";
			columnNames[5] = "성장률";
			columnNames[6] = "평균(천원)";
			columnNames[7] = "성장률";
			columnNames[8] = "평균(천원)";
			columnNames[9] = "집약도(%)";
			
			//모델명
			colModelList[0] = "AREA1";
			colModelList[1] = "ENTRPRS_CO";
			colModelList[2] = "SELNG_AM";
			colModelList[3] = "SELNG_RT";
			colModelList[4] = "ORDTM_LABRR_CO";
			colModelList[5] = "ORDTM_RT";
			colModelList[6] = "XPORT_AM_WON";
			colModelList[7] = "XPORT_AM_WON_RT";
			colModelList[8] = "RSRCH_DEVLOP_CT";
			colModelList[9] = "RSRCH_RT";
			
		}
		
		dataMap.put("colModelList", colModelList);
		dataMap.put("columnNames", columnNames);
		
		ModelAndView mv = new ModelAndView();
		return ResponseUtil.responseJson(mv, true, dataMap);
		
	}
	
	/**
	 * 성장및회귀현황>업종별성장현황
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView processGetGridSttusList(Map<?, ?> rqstMap) throws Exception {	
		HashMap param = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("induty_select")) param.put("induty_select", rqstMap.get("induty_select"));		// 업종 선택 구분
		if (rqstMap.containsKey("multiSelectGrid1")) param.put("multiSelectGrid1", rqstMap.get("multiSelectGrid1"));		// (제조, 비제조)
		if (rqstMap.containsKey("multiSelectGrid2")) param.put("multiSelectGrid2", rqstMap.get("multiSelectGrid2"));		// (업종테마)
		// if (rqstMap.containsKey("multiSelectGrid3")) param.put("multiSelectGrid3", rqstMap.get("multiSelectGrid3"));		// (상세업종)
		if (rqstMap.containsKey("ad_ind_cd")) param.put("ad_ind_cd", rqstMap.get("ad_ind_cd"));		// (상세업종)
		if (rqstMap.containsKey("sel_area")) param.put("sel_area", rqstMap.get("sel_area"));		// 지역 선택 구분(권역별 : A, 지역별 : C)
		if (rqstMap.containsKey("cmpn_area_depth1")) param.put("cmpn_area_depth1", rqstMap.get("cmpn_area_depth1"));		// 권역별
		if (rqstMap.containsKey("cmpn_area_depth2")) param.put("cmpn_area_depth2", rqstMap.get("cmpn_area_depth2"));		// 지역별(시)
		
		String induty_select = "A";
		int sel_target_year=0;
		
		if (rqstMap.containsKey("induty_select")) induty_select = (String) rqstMap.get("induty_select");		// 업종 선택 구분
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("sel_target_year")) sel_target_year = MapUtils.getIntValue(rqstMap, "sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(sel_target_year == 0) sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		
		param.put("sel_target_year", sel_target_year);
		param.put("induty_select", induty_select);
		
		if (rqstMap.containsKey("gSelect1")) param.put("gSelect1", rqstMap.get("gSelect1"));
		if (rqstMap.containsKey("gSelect2")) param.put("gSelect2", rqstMap.get("gSelect2"));

		String gSelect1 = (String) rqstMap.get("gSelect1");		//업종이 그룹일때
		String gSelect2 = (String) rqstMap.get("gSelect2");		//지역이 그룹일때
		
		logger.debug("-----------PGPS0063Service>processGetGridSttusList>induty_select: "+induty_select);
		logger.debug("-----------PGPS0063Service>processGetGridSttusList>induty_select: "+param.get("induty_select"));
		logger.debug("-----------PGPS0063Service>processGetGridSttusList>gSelect1: "+gSelect1);
		logger.debug("-----------PGPS0063Service>processGetGridSttusList>gSelect2: "+gSelect2);
		logger.debug("-----------PGPS0063Service>processGetGridSttusList>sel_target_year:"+sel_target_year);
		logger.debug("-----------PGPS0063Service>processGetGridSttusList>multiSelectGrid1: "+param.get("multiSelectGrid1"));
		logger.debug("-----------PGPS0063Service>processGetGridSttusList>multiSelectGrid2: "+param.get("multiSelectGrid2"));
		logger.debug("-----------PGPS0063Service>processGetGridSttusList>ad_ind_cd: "+param.get("ad_ind_cd"));
		
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
		
		// 선택 or 제조/비제조 구분이라면
		if(tmp1 != null && "A".equals(induty_select) || "I".equals(induty_select)) {
			array_tmp1 = tmp1.split(",");	// ','를 기준으로 잘라서
		
			if(!"null".equals(array_tmp1[0])) {
				for(int i=0; i < array_tmp1.length; i++) {
					if("UT00".equals(array_tmp1[i])) param.put("all_induty", "Y");		// 전산업 선택 시 all_induty : Y 로 넘김(전체)
					if("UT01".equals(array_tmp1[i])) array_tmp1[i] = "제조업";
					if("UT02".equals(array_tmp1[i])) array_tmp1[i] = "비제조업";
					
					logger.debug("-----------PGPS0063Service>processGetGridSttusList>array_tmp1["+i+"]:"+array_tmp1[i]);
					logger.debug("-----------PGPS0063Service>processGetGridSttusList>all_induty["+i+"]:"+param.get("all_induty"));
					
					param.put("multiSelectGrid1", array_tmp1);	// xml에서 사용될 제조/비제조 코드
				}
			// 제조/비제조 검색 시 항목을 선택하지 않았을 때 
			}else if("null".equals(array_tmp1[0])) {
				array_tmp1 = new String[1];
				array_tmp1[0] = "XXX";
				param.put("multiSelectGrid1", array_tmp1);
			}
		}else{
			logger.debug("---------------------업종선택이 없다-------------------------------");
			
			param.put("multiSelectGrid1", null);
		}
		
		logger.debug("-----------PGPS0063Service>processGetGridSttusList>tmp2:"+tmp2);
		// 테마업종 선택한게 있으면 진행
		if(!"null".equals(tmp2) && tmp2 != null && "T".equals(induty_select)) {
			array_tmp2 = tmp2.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_tmp2[0])) {
				for(int i=0; i < array_tmp2.length; i++) {
					logger.debug("-----------------------PGPS0063Service>processGetGridSttusList>array_tmp2["+i+"]:"+array_tmp2[i]);
				}
				
				param.put("multiSelectGrid2", array_tmp2);	// xml에서 사용될 업종테마별 코드
			}
		}else {
			logger.debug("---------------------테마업종 선택이 없다-------------------------------");
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_tmp2 = new String[1];
			array_tmp2[0] = "XXX";
			param.put("multiSelectGrid2", array_tmp2);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		logger.debug("-----------PGPS0063Service>processGetGridSttusList>tmp3:"+tmp3);
		
		// 임시 세팅
		//tmp3 = "A,C10,C12,C13";
		// C12:2,H:1
		// 상세업종 선택한게 있으면 진행
		if(!"null".equals(tmp3) && tmp3 != null && "D".equals(induty_select)) {
			array_tmp3 = tmp3.split(",");	// ','를 기준으로 잘라서
			//C12:2
			//H:1
			
			if(!"null".equals(array_tmp3[0])) {
				/*for(int i=0; i < array_tmp3.length; i++) {
					//array_tmp3[i] = array_tmp3[i].substring(array_tmp3[i].indexOf(":"), array_tmp3[i].length());
					array_tmp3[i] = array_tmp3[i].substring(0, array_tmp3[i].indexOf(":"));
					logger.debug("-----------------------PGPS0063Service>processGetGridSttusList>array_tmp3["+i+"]:"+array_tmp3[i]);
				}*/
				
				param.put("multiSelectGrid3", array_tmp3);	// xml에서 사용될 상세업종별 코드
			}
		}else {
			logger.debug("---------------------상세업종 선택이 없다-------------------------------");
			array_tmp3 = new String[1];
			array_tmp3[0] = "XXX";
			param.put("multiSelectGrid3", array_tmp3);
		}
		
		String sel_area = (String) rqstMap.get("sel_area");			// 지역 구분 선택 (권역별, 지역별)
		String area_sel = (String) rqstMap.get("cmpn_area_depth1");			// 권역별 선택값
		String city_sel = (String) rqstMap.get("cmpn_area_depth2");			// 지역별 선택값
		String[] array_area;
		String[] array_city;
		
		logger.debug("-----------PGPS0063Service>processGetGridSttusList>sel_area:"+sel_area);
		logger.debug("-----------PGPS0063Service>processGetGridSttusList>area_sel:"+area_sel);
		logger.debug("-----------PGPS0063Service>processGetGridSttusList>city_sel:"+city_sel);
		// 권역별 선택이 넘어온게 있으면
		if(!"null".equals(sel_area) && sel_area != null && sel_area !="" && "A".equals(sel_area) && !"null".equals(area_sel) && area_sel != null) {
			logger.debug("---------------------권역별 선택이 들어왔다-------------------------------");
			array_area = area_sel.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_area[0])) {
				for(int i=0; i < array_area.length; i++) {
					logger.debug("-----------------------PGPS0063Service>processGetGridSttusList>array_area["+i+"]:"+array_area[i]);
				}
				
				param.put("cmpn_area_depth1", array_area);	// xml에서 사용될 권역별 코드
			}
		}else{
			logger.debug("---------------------권역선택이 없다-------------------------------");
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_area = new String[1];
			array_area[0] = "XXX";
			param.put("cmpn_area_depth1", array_area);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		// 지역별 선택이 넘어온게 있으면
		if(!"null".equals(sel_area) && sel_area != null && sel_area !="" && "C".equals(sel_area) && !"null".equals(city_sel) && city_sel != null) {
			logger.debug("---------------------지역별 선택이 들어왔다-------------------------------");
			array_city = city_sel.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_city[0])) {
				for(int i=0; i < array_city.length; i++) {
					logger.debug("-----------------------PGPS0063Service>processGetGridSttusList>array_city["+i+"]:"+array_city[i]);
				}
				
				param.put("cmpn_area_depth2", array_city);	// xml에서 사용될 권역별 코드
			}
		}else{
			logger.debug("---------------------지역선택이 없다-------------------------------");
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_city = new String[1];
			array_city[0] = "XXX";
			param.put("cmpn_area_depth2", array_city);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		
		
		// 성장및회귀현황>업종별성장현황
		List<Map> entprsList = new ArrayList<Map>();
		entprsList = entprsDAO.selectSttus(param);
		
		logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&: "+entprsList.toString());
		
		/*GridJsonVO gridJsonVo = new GridJsonVO();
		gridJsonVo.setRows(entprsList);
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("entprsSize", entprsList.size());
		mv.addObject("entprsList", entprsList);
		*/		
		
		ModelAndView mv = new ModelAndView("/admin/ps/INC_UIPSA0063");
		mv.addObject("resultList", entprsList);
		
		//return ResponseUtil.responseGridJson(mv, gridJsonVo);
		return mv;
	}
	
	
	/**
	 * 성장및회귀현황 > 업종별성장현황 엑셀다운로드
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView excelRsolver(Map<?, ?> rqstMap) throws Exception {
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
		
		HashMap param = new HashMap();
		Map dataMap = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("induty_select")) param.put("induty_select", rqstMap.get("induty_select"));		// 업종 선택 구분
		if (rqstMap.containsKey("multiSelectGrid1")) param.put("multiSelectGrid1", rqstMap.get("multiSelectGrid1"));		// (제조, 비제조)
		if (rqstMap.containsKey("multiSelectGrid2")) param.put("multiSelectGrid2", rqstMap.get("multiSelectGrid2"));		// (업종테마)
		if (rqstMap.containsKey("ad_ind_cd")) param.put("ad_ind_cd", rqstMap.get("ad_ind_cd"));		// (상세업종)
		if (rqstMap.containsKey("sel_area")) param.put("sel_area", rqstMap.get("sel_area"));		// 지역 선택 구분(권역별 : A, 지역별 : C)
		if (rqstMap.containsKey("cmpn_area_depth1")) param.put("cmpn_area_depth1", rqstMap.get("cmpn_area_depth1"));		// 권역별
		if (rqstMap.containsKey("cmpn_area_depth2")) param.put("cmpn_area_depth2", rqstMap.get("cmpn_area_depth2"));		// 지역별(시)
		
		String induty_select = "A";
		int sel_target_year=0;
		
		if (rqstMap.containsKey("induty_select")) induty_select = (String) rqstMap.get("induty_select");		// 업종 선택 구분
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("sel_target_year")) sel_target_year = MapUtils.getIntValue(rqstMap, "sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(sel_target_year == 0) sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		
		param.put("sel_target_year", sel_target_year);
		param.put("induty_select", induty_select);
		
		if (rqstMap.containsKey("gSelect1")) param.put("gSelect1", rqstMap.get("gSelect1"));
		if (rqstMap.containsKey("gSelect2")) param.put("gSelect2", rqstMap.get("gSelect2"));

		String gSelect1 = (String) rqstMap.get("gSelect1");		//업종이 그룹일때
		String gSelect2 = (String) rqstMap.get("gSelect2");		//지역이 그룹일때
		
		logger.debug("-----------PGPS0063Service>excelRsolver>induty_select: "+induty_select);
		logger.debug("-----------PGPS0063Service>excelRsolver>induty_select: "+param.get("induty_select"));
		logger.debug("-----------PGPS0063Service>excelRsolver>gSelect1: "+gSelect1);
		logger.debug("-----------PGPS0063Service>excelRsolver>gSelect2: "+gSelect2);
		logger.debug("-----------PGPS0063Service>excelRsolver>sel_target_year:"+sel_target_year);
		logger.debug("-----------PGPS0063Service>excelRsolver>multiSelectGrid1: "+param.get("multiSelectGrid1"));
		logger.debug("-----------PGPS0063Service>excelRsolver>multiSelectGrid2: "+param.get("multiSelectGrid2"));
		logger.debug("-----------PGPS0063Service>excelRsolver>ad_ind_cd: "+param.get("ad_ind_cd"));
		
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
		
		// 선택 or 제조/비제조 구분이라면
		if(tmp1 != null && "A".equals(induty_select) || "I".equals(induty_select)) {
			array_tmp1 = tmp1.split(",");	// ','를 기준으로 잘라서
		
			if(!"null".equals(array_tmp1[0])) {
				for(int i=0; i < array_tmp1.length; i++) {
					if("UT00".equals(array_tmp1[i])) param.put("all_induty", "Y");		// 전산업 선택 시 all_induty : Y 로 넘김(전체)
					if("UT01".equals(array_tmp1[i])) array_tmp1[i] = "제조업";
					if("UT02".equals(array_tmp1[i])) array_tmp1[i] = "비제조업";
					
					logger.debug("-----------PGPS0063Service>excelRsolver>array_tmp1["+i+"]:"+array_tmp1[i]);
					logger.debug("-----------PGPS0063Service>excelRsolver>all_induty["+i+"]:"+param.get("all_induty"));
					
					param.put("multiSelectGrid1", array_tmp1);	// xml에서 사용될 제조/비제조 코드
				}
			// 제조/비제조 검색 시 항목을 선택하지 않았을 때 
			}else if("null".equals(array_tmp1[0])) {
				array_tmp1 = new String[1];
				array_tmp1[0] = "XXX";
				param.put("multiSelectGrid1", array_tmp1);
			}
		}else{
			logger.debug("---------------------업종선택이 없다-------------------------------");
			
			param.put("multiSelectGrid1", null);
		}
		
		logger.debug("-----------PGPS0063Service>excelRsolver>tmp2:"+tmp2);
		// 테마업종 선택한게 있으면 진행
		if(!"null".equals(tmp2) && tmp2 != null && "T".equals(induty_select)) {
			array_tmp2 = tmp2.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_tmp2[0])) {
				for(int i=0; i < array_tmp2.length; i++) {
					logger.debug("-----------------------PGPS0063Service>excelRsolver>array_tmp2["+i+"]:"+array_tmp2[i]);
				}
				
				param.put("multiSelectGrid2", array_tmp2);	// xml에서 사용될 업종테마별 코드
			}
		}else {
			logger.debug("---------------------테마업종 선택이 없다-------------------------------");
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_tmp2 = new String[1];
			array_tmp2[0] = "XXX";
			param.put("multiSelectGrid2", array_tmp2);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		logger.debug("-----------PGPS0063Service>excelRsolver>tmp3:"+tmp3);
		
		// 임시 세팅
		//tmp3 = "A,C10,C12,C13";
		// C12:2,H:1
		// 상세업종 선택한게 있으면 진행
		if(!"null".equals(tmp3) && tmp3 != null && "D".equals(induty_select)) {
			array_tmp3 = tmp3.split(",");	// ','를 기준으로 잘라서
			//C12:2
			//H:1
			
			if(!"null".equals(array_tmp3[0])) {
				for(int i=0; i < array_tmp3.length; i++) {
					//array_tmp3[i] = array_tmp3[i].substring(array_tmp3[i].indexOf(":"), array_tmp3[i].length());
					array_tmp3[i] = array_tmp3[i].substring(0, array_tmp3[i].indexOf(":"));
					logger.debug("-----------------------PGPS0063Service>excelRsolver>array_tmp3["+i+"]:"+array_tmp3[i]);
				}
				
				param.put("multiSelectGrid3", array_tmp3);	// xml에서 사용될 상세업종별 코드
			}
		}else {
			logger.debug("---------------------상세업종 선택이 없다-------------------------------");
			array_tmp3 = new String[1];
			array_tmp3[0] = "XXX";
			param.put("multiSelectGrid3", array_tmp3);
		}
		
		String sel_area = (String) rqstMap.get("sel_area");			// 지역 구분 선택 (권역별, 지역별)
		String area_sel = (String) rqstMap.get("cmpn_area_depth1");			// 권역별 선택값
		String city_sel = (String) rqstMap.get("cmpn_area_depth2");			// 지역별 선택값
		String[] array_area;
		String[] array_city;
		
		logger.debug("-----------PGPS0063Service>excelRsolver>sel_area:"+sel_area);
		logger.debug("-----------PGPS0063Service>excelRsolver>area_sel:"+area_sel);
		logger.debug("-----------PGPS0063Service>excelRsolver>city_sel:"+city_sel);
		// 권역별 선택이 넘어온게 있으면
		if(!"null".equals(sel_area) && sel_area != null && sel_area !="" && "A".equals(sel_area) && !"null".equals(area_sel) && area_sel != null) {
			logger.debug("---------------------권역별 선택이 들어왔다-------------------------------");
			array_area = area_sel.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_area[0])) {
				for(int i=0; i < array_area.length; i++) {
					logger.debug("-----------------------PGPS0063Service>excelRsolver>array_area["+i+"]:"+array_area[i]);
				}
				
				param.put("cmpn_area_depth1", array_area);	// xml에서 사용될 권역별 코드
			}
		}else{
			logger.debug("---------------------권역선택이 없다-------------------------------");
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_area = new String[1];
			array_area[0] = "XXX";
			param.put("cmpn_area_depth1", array_area);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		// 지역별 선택이 넘어온게 있으면
		if(!"null".equals(sel_area) && sel_area != null && sel_area !="" && "C".equals(sel_area) && !"null".equals(city_sel) && city_sel != null) {
			logger.debug("---------------------지역별 선택이 들어왔다-------------------------------");
			array_city = city_sel.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_city[0])) {
				for(int i=0; i < array_city.length; i++) {
					logger.debug("-----------------------PGPS0063Service>excelRsolver>array_city["+i+"]:"+array_city[i]);
				}
				
				param.put("cmpn_area_depth2", array_city);	// xml에서 사용될 권역별 코드
			}
		}else{
			logger.debug("---------------------지역선택이 없다-------------------------------");
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_city = new String[1];
			array_city[0] = "XXX";
			param.put("cmpn_area_depth2", array_city);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}


		String[] columnNames = null;			//header부분
		String[] colModelList = null;
		String[] subHeaders = null;
		
		if(("G".equals(gSelect1) && "G".equals(gSelect2)) || ("W".equals(gSelect1) && "W".equals(gSelect2))){
			// 컬럼명을 배열형태로
			columnNames = new String[8];
			colModelList = new String[11];
			
			//컬럼명
			columnNames[0] = "매출(천원)";
			columnNames[1] = "";
			columnNames[2] = "고용(만명)";
			columnNames[3] = "";
			columnNames[4] = "수출(원)";
			columnNames[5] = "";
			columnNames[6] = "연구개발비";
			columnNames[7] = "";
			
			subHeaders = new String[8];
			
			subHeaders[0] = "평균(천원)";
			subHeaders[1] = "성장률";
			subHeaders[2] = "평균(명)";
			subHeaders[3] = "성장률";
			subHeaders[4] = "평균(천원)";
			subHeaders[5] = "성장률";
			subHeaders[6] = "평균(천원)";
			subHeaders[7] = "집약도(%)";
			
			//모델명
			colModelList[0] = "AREA1";
			colModelList[1] = "COL1";
			colModelList[2] = "ENTRPRS_CO";
			colModelList[3] = "SELNG_AM";
			colModelList[4] = "SELNG_RT";
			colModelList[5] = "ORDTM_LABRR_CO";
			colModelList[6] = "ORDTM_RT";
			colModelList[7] = "XPORT_AM_WON";
			colModelList[8] = "XPORT_AM_WON_RT";
			colModelList[9] = "RSRCH_DEVLOP_CT";
			colModelList[10] = "RSRCH_RT";
			
			dataMap.put("colModelList", colModelList);
			dataMap.put("columnNames", columnNames);
			
		}else if("G".equals(gSelect1) && "W".equals(gSelect2)){
			// 컬럼명을 배열형태로
			columnNames = new String[8];
			colModelList = new String[10];
			
			//컬럼명
			columnNames[0] = "매출(천원)";
			columnNames[1] = "";
			columnNames[2] = "고용(만명)";
			columnNames[3] = "";
			columnNames[4] = "수출(원)";
			columnNames[5] = "";
			columnNames[6] = "연구개발비";
			columnNames[7] = "";
			
			subHeaders = new String[8];
			
			subHeaders[0] = "평균(천원)";
			subHeaders[1] = "성장률";
			subHeaders[2] = "평균(명)";
			subHeaders[3] = "성장률";
			subHeaders[4] = "평균(천원)";
			subHeaders[5] = "성장률";
			subHeaders[6] = "평균(천원)";
			subHeaders[7] = "집약도(%)";
			
			//모델명
			colModelList[0] = "COL1";
			colModelList[1] = "ENTRPRS_CO";
			colModelList[2] = "SELNG_AM";
			colModelList[3] = "SELNG_RT";
			colModelList[4] = "ORDTM_LABRR_CO";
			colModelList[5] = "ORDTM_RT";
			colModelList[6] = "XPORT_AM_WON";
			colModelList[7] = "XPORT_AM_WON_RT";
			colModelList[8] = "RSRCH_DEVLOP_CT";
			colModelList[9] = "RSRCH_RT";
			
			dataMap.put("colModelList", colModelList);
			dataMap.put("columnNames", columnNames);
		}else if("W".equals(gSelect1) && "G".equals(gSelect2)){
			// 컬럼명을 배열형태로
			columnNames = new String[8];
			colModelList = new String[10];
			
			//컬럼명
			columnNames[0] = "매출(천원)";
			columnNames[1] = "";
			columnNames[2] = "고용(만명)";
			columnNames[3] = "";
			columnNames[4] = "수출(원)";
			columnNames[5] = "";
			columnNames[6] = "연구개발비";
			columnNames[7] = "";
			
			subHeaders = new String[8];
			
			subHeaders[0] = "평균(천원)";
			subHeaders[1] = "성장률";
			subHeaders[2] = "평균(명)";
			subHeaders[3] = "성장률";
			subHeaders[4] = "평균(천원)";
			subHeaders[5] = "성장률";
			subHeaders[6] = "평균(천원)";
			subHeaders[7] = "집약도(%)";
			
			//모델명
			colModelList[0] = "AREA1";
			colModelList[1] = "ENTRPRS_CO";
			colModelList[2] = "SELNG_AM";
			colModelList[3] = "SELNG_RT";
			colModelList[4] = "ORDTM_LABRR_CO";
			colModelList[5] = "ORDTM_RT";
			colModelList[6] = "XPORT_AM_WON";
			colModelList[7] = "XPORT_AM_WON_RT";
			colModelList[8] = "RSRCH_DEVLOP_CT";
			colModelList[9] = "RSRCH_RT";
			
			dataMap.put("colModelList", colModelList);
			dataMap.put("columnNames", columnNames);
		}
				
		
		
		// ------------------------------------ 데이터 부분 -----------------------------------
		
		// 성장및회귀현황>업종별성장현황
		//List<Map> entprsList = new ArrayList<Map>();
		//entprsList = entprsDAO.selectSttus(param);
		
		
		ModelAndView mv = new ModelAndView();
		
		

		
		
		// 성장및회귀현황>업종별성장현황
		List<Map> resultList = new ArrayList<Map>();
		resultList = entprsDAO.selectSttus(param);
		
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
				
				if (!stdIndutyFt.equals(indutyFt) || cndArea && !stdAreaFt.equals(areaFt)) {

					stdIndutyFt = indutyFt;
					
					prevInfo = resultList.get(i-1);
					
					// 제조/비제조 소계
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
					
					// 제조/비제조 검색이 아니면 제조/비제조 소계 처리
					if (!MapUtils.getString(rqstMap, "induty_select").equals("I")) {
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
			
			rtnList.add(sumMap);
			if (sumList.size() > 0) rtnList.addAll(sumList);
		}
		
		rtnList.addAll(dataList);
		
		//return rtnList;
				
				
				
				
				
		
		
		mv.addObject("_list", rtnList);
		//mv.addObject("_list", entprsList);

        mv.addObject("_headers", columnNames);
        mv.addObject("_subHeaders", subHeaders);
        mv.addObject("_items", colModelList);
        mv.addObject("gSelect1", gSelect1);
        mv.addObject("gSelect2", gSelect2);

        IExcelVO excel = new PGPS0063ExcelVO("업종별성장현황_"+DateFormatUtil.getTodayFull());
				
		return ResponseUtil.responseExcel(mv, excel);
	}
	
	
	/**
	 * 진입시기별분석 > 현황 출력 outputIdx
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView outputIdx(Map<?,?> rqstMap) throws Exception {
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
		
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("sel_target_year")) param.put("sel_target_year", rqstMap.get("sel_target_year"));
		if (rqstMap.containsKey("induty_select")) param.put("induty_select", rqstMap.get("induty_select"));		// 업종 선택 구분
		if (rqstMap.containsKey("multiSelectGrid1")) param.put("multiSelectGrid1", rqstMap.get("multiSelectGrid1"));		// (제조, 비제조)
		if (rqstMap.containsKey("multiSelectGrid2")) param.put("multiSelectGrid2", rqstMap.get("multiSelectGrid2"));		// (업종테마)
		if (rqstMap.containsKey("ad_ind_cd")) param.put("ad_ind_cd", rqstMap.get("ad_ind_cd"));		// (상세업종)
		if (rqstMap.containsKey("sel_area")) param.put("sel_area", rqstMap.get("sel_area"));		// 지역 선택 구분(권역별 : A, 지역별 : C)
		if (rqstMap.containsKey("cmpn_area_depth1")) param.put("cmpn_area_depth1", rqstMap.get("cmpn_area_depth1"));		// 권역별
		if (rqstMap.containsKey("cmpn_area_depth2")) param.put("cmpn_area_depth2", rqstMap.get("cmpn_area_depth2"));		// 지역별(시)
		if (rqstMap.containsKey("gSelect1")) param.put("gSelect1", rqstMap.get("gSelect1"));
		if (rqstMap.containsKey("gSelect2")) param.put("gSelect2", rqstMap.get("gSelect2"));
		
		String searchCondition = param.get("searchCondition").toString();
		String sel_target_year = param.get("sel_target_year").toString();
		String induty_select = param.get("induty_select").toString();
		String multiSelectGrid1 = param.get("multiSelectGrid1").toString();
		String multiSelectGrid2 = param.get("multiSelectGrid2").toString();
		String ad_ind_cd = param.get("ad_ind_cd").toString();
		String sel_area = param.get("sel_area").toString();
		String cmpn_area_depth1 = param.get("cmpn_area_depth1").toString();
		String cmpn_area_depth2 = param.get("cmpn_area_depth2").toString();
		String gSelect1 = param.get("gSelect1").toString();
		String gSelect2 = param.get("gSelect2").toString();
		
		logger.debug("---------------------------searchCondition: "+searchCondition);
		logger.debug("---------------------------sel_target_year: "+sel_target_year);
		
		mv = selectGetGridSttusList(rqstMap);
		mv.setViewName("/admin/ps/PD_UIPSA0063_1");
		
		// 데이터 추가
		mv.addObject("searchCondition", searchCondition);
		mv.addObject("sel_target_year", sel_target_year);
		mv.addObject("induty_select", induty_select);
		mv.addObject("multiSelectGrid1", multiSelectGrid1);
		mv.addObject("multiSelectGrid2", multiSelectGrid2);
		mv.addObject("ad_ind_cd", ad_ind_cd);
		mv.addObject("sel_area", sel_area);
		mv.addObject("cmpn_area_depth1", cmpn_area_depth1);
		mv.addObject("cmpn_area_depth2", cmpn_area_depth2);
		mv.addObject("gSelect1", gSelect1);
		mv.addObject("gSelect2", gSelect2);
		
		return mv;
	}	
	
	
	/**
	 * 성장및회귀현황>업종별성장현황 HTML
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView selectGetGridSttusList(Map rqstMap) throws Exception {	
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
		
		HashMap param = new HashMap();
		
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("induty_select")) param.put("induty_select", rqstMap.get("induty_select"));		// 업종 선택 구분
		if (rqstMap.containsKey("multiSelectGrid1")) param.put("multiSelectGrid1", rqstMap.get("multiSelectGrid1"));		// (제조, 비제조)
		if (rqstMap.containsKey("multiSelectGrid2")) param.put("multiSelectGrid2", rqstMap.get("multiSelectGrid2"));		// (업종테마)
		// if (rqstMap.containsKey("multiSelectGrid3")) param.put("multiSelectGrid3", rqstMap.get("multiSelectGrid3"));		// (상세업종)
		if (rqstMap.containsKey("ad_ind_cd")) param.put("ad_ind_cd", rqstMap.get("ad_ind_cd"));		// (상세업종)
		if (rqstMap.containsKey("sel_area")) param.put("sel_area", rqstMap.get("sel_area"));		// 지역 선택 구분(권역별 : A, 지역별 : C)
		if (rqstMap.containsKey("cmpn_area_depth1")) param.put("cmpn_area_depth1", rqstMap.get("cmpn_area_depth1"));		// 권역별
		if (rqstMap.containsKey("cmpn_area_depth2")) param.put("cmpn_area_depth2", rqstMap.get("cmpn_area_depth2"));		// 지역별(시)
		
		String induty_select = "A";
		int sel_target_year=0;
		
		if (rqstMap.containsKey("induty_select")) induty_select = (String) rqstMap.get("induty_select");		// 업종 선택 구분
		
		//검색할 년도의 범위를 받는다.
		if (rqstMap.containsKey("sel_target_year")) sel_target_year = MapUtils.getIntValue(rqstMap, "sel_target_year");
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		if(sel_target_year == 0) sel_target_year = oCalendar.get(Calendar.YEAR)-1;		//to_sel_target_year == 0 -> 넘어오지 않으면 전년도로 세팅 
		
		param.put("sel_target_year", sel_target_year);
		param.put("induty_select", induty_select);
		
		if (rqstMap.containsKey("gSelect1")) param.put("gSelect1", rqstMap.get("gSelect1"));
		if (rqstMap.containsKey("gSelect2")) param.put("gSelect2", rqstMap.get("gSelect2"));

		String gSelect1 = (String) rqstMap.get("gSelect1");		//업종이 그룹일때
		String gSelect2 = (String) rqstMap.get("gSelect2");		//지역이 그룹일때
		
		logger.debug("-----------PGPS0063Service>selectGetGridSttusList>induty_select: "+induty_select);
		logger.debug("-----------PGPS0063Service>selectGetGridSttusList>induty_select: "+param.get("induty_select"));
		logger.debug("-----------PGPS0063Service>selectGetGridSttusList>gSelect1: "+gSelect1);
		logger.debug("-----------PGPS0063Service>selectGetGridSttusList>gSelect2: "+gSelect2);
		logger.debug("-----------PGPS0063Service>selectGetGridSttusList>sel_target_year:"+sel_target_year);
		logger.debug("-----------PGPS0063Service>selectGetGridSttusList>multiSelectGrid1: "+param.get("multiSelectGrid1"));
		logger.debug("-----------PGPS0063Service>selectGetGridSttusList>multiSelectGrid2: "+param.get("multiSelectGrid2"));
		logger.debug("-----------PGPS0063Service>selectGetGridSttusList>ad_ind_cd: "+param.get("ad_ind_cd"));
		
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
		
		// 선택 or 제조/비제조 구분이라면
		if(tmp1 != null && "A".equals(induty_select) || "I".equals(induty_select)) {
			array_tmp1 = tmp1.split(",");	// ','를 기준으로 잘라서
		
			if(!"null".equals(array_tmp1[0])) {
				for(int i=0; i < array_tmp1.length; i++) {
					if("UT00".equals(array_tmp1[i])) param.put("all_induty", "Y");		// 전산업 선택 시 all_induty : Y 로 넘김(전체)
					if("UT01".equals(array_tmp1[i])) array_tmp1[i] = "제조업";
					if("UT02".equals(array_tmp1[i])) array_tmp1[i] = "비제조업";
					
					logger.debug("-----------PGPS0063Service>selectGetGridSttusList>array_tmp1["+i+"]:"+array_tmp1[i]);
					logger.debug("-----------PGPS0063Service>selectGetGridSttusList>all_induty["+i+"]:"+param.get("all_induty"));
					
					param.put("multiSelectGrid1", array_tmp1);	// xml에서 사용될 제조/비제조 코드
				}
			// 제조/비제조 검색 시 항목을 선택하지 않았을 때 
			}else if("null".equals(array_tmp1[0])) {
				array_tmp1 = new String[1];
				array_tmp1[0] = "XXX";
				param.put("multiSelectGrid1", array_tmp1);
			}
		}else{
			logger.debug("---------------------업종선택이 없다-------------------------------");
			
			param.put("multiSelectGrid1", null);
		}
		
		logger.debug("-----------PGPS0063Service>selectGetGridSttusList>tmp2:"+tmp2);
		// 테마업종 선택한게 있으면 진행
		if(!"null".equals(tmp2) && tmp2 != null && "T".equals(induty_select)) {
			array_tmp2 = tmp2.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_tmp2[0])) {
				for(int i=0; i < array_tmp2.length; i++) {
					logger.debug("-----------------------PGPS0063Service>selectGetGridSttusList>array_tmp2["+i+"]:"+array_tmp2[i]);
				}
				
				param.put("multiSelectGrid2", array_tmp2);	// xml에서 사용될 업종테마별 코드
			}
		}else {
			logger.debug("---------------------테마업종 선택이 없다-------------------------------");
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_tmp2 = new String[1];
			array_tmp2[0] = "XXX";
			param.put("multiSelectGrid2", array_tmp2);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		logger.debug("-----------PGPS0063Service>selectGetGridSttusList>tmp3:"+tmp3);
		
		// 임시 세팅
		//tmp3 = "A,C10,C12,C13";
		// C12:2,H:1
		// 상세업종 선택한게 있으면 진행
		if(!"null".equals(tmp3) && tmp3 != null && "D".equals(induty_select)) {
			array_tmp3 = tmp3.split(",");	// ','를 기준으로 잘라서
			//C12:2
			//H:1
			
			if(!"null".equals(array_tmp3[0])) {
				/*for(int i=0; i < array_tmp3.length; i++) {
					//array_tmp3[i] = array_tmp3[i].substring(array_tmp3[i].indexOf(":"), array_tmp3[i].length());
					array_tmp3[i] = array_tmp3[i].substring(0, array_tmp3[i].indexOf(":"));
					logger.debug("-----------------------PGPS0063Service>selectGetGridSttusList>array_tmp3["+i+"]:"+array_tmp3[i]);
				}*/
				
				param.put("multiSelectGrid3", array_tmp3);	// xml에서 사용될 상세업종별 코드
			}
		}else {
			logger.debug("---------------------상세업종 선택이 없다-------------------------------");
			array_tmp3 = new String[1];
			array_tmp3[0] = "XXX";
			param.put("multiSelectGrid3", array_tmp3);
		}
		
		String sel_area = (String) rqstMap.get("sel_area");			// 지역 구분 선택 (권역별, 지역별)
		String area_sel = (String) rqstMap.get("cmpn_area_depth1");			// 권역별 선택값
		String city_sel = (String) rqstMap.get("cmpn_area_depth2");			// 지역별 선택값
		String[] array_area;
		String[] array_city;
		
		logger.debug("-----------PGPS0063Service>selectGetGridSttusList>sel_area:"+sel_area);
		logger.debug("-----------PGPS0063Service>selectGetGridSttusList>area_sel:"+area_sel);
		logger.debug("-----------PGPS0063Service>selectGetGridSttusList>city_sel:"+city_sel);
		// 권역별 선택이 넘어온게 있으면
		if(!"null".equals(sel_area) && sel_area != null && sel_area !="" && "A".equals(sel_area) && !"null".equals(area_sel) && area_sel != null) {
			logger.debug("---------------------권역별 선택이 들어왔다-------------------------------");
			array_area = area_sel.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_area[0])) {
				for(int i=0; i < array_area.length; i++) {
					logger.debug("-----------------------PGPS0063Service>selectGetGridSttusList>array_area["+i+"]:"+array_area[i]);
				}
				
				param.put("cmpn_area_depth1", array_area);	// xml에서 사용될 권역별 코드
			}
		}else{
			logger.debug("---------------------권역선택이 없다-------------------------------");
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_area = new String[1];
			array_area[0] = "XXX";
			param.put("cmpn_area_depth1", array_area);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		// 지역별 선택이 넘어온게 있으면
		if(!"null".equals(sel_area) && sel_area != null && sel_area !="" && "C".equals(sel_area) && !"null".equals(city_sel) && city_sel != null) {
			logger.debug("---------------------지역별 선택이 들어왔다-------------------------------");
			array_city = city_sel.split(",");	// ','를 기준으로 잘라서
			
			if(!"null".equals(array_city[0])) {
				for(int i=0; i < array_city.length; i++) {
					logger.debug("-----------------------PGPS0063Service>processGetGridSttusList>array_city["+i+"]:"+array_city[i]);
				}
				
				param.put("cmpn_area_depth2", array_city);	// xml에서 사용될 권역별 코드
			}
		}else{
			logger.debug("---------------------지역선택이 없다-------------------------------");
			// 쿼리에서 반복되어야 하는 값인데 String 문자열을 넘기면 에러 그래서 배열에 담아서 넘긴다.
			array_city = new String[1];
			array_city[0] = "XXX";
			param.put("cmpn_area_depth2", array_city);		// 업종테마를 아무것도 선택하지 않고 조회할 경우 조회가되면 안되니까 'XXX'로 처리
		}
		
		
		
		// 성장및회귀현황>업종별성장현황
		List<Map> resultList = new ArrayList<Map>();
		resultList = entprsDAO.selectSttus(param);
		
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
