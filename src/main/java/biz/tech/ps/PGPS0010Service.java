package biz.tech.ps;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.code.CodeService;
import com.comm.page.Pager;
import com.comm.response.IExcelVO;
import com.infra.util.DateFormatUtil;
import com.infra.util.JsonUtil;
import com.infra.util.ResponseUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.ic.HpeCnfirmReqstMapper;
import biz.tech.mapif.ps.PGPS0010Mapper;
import biz.tech.mapif.ps.PGPS0020Mapper;
import biz.tech.mapif.ps.PGPS0030Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


/**
 * 현황및통계>기업검색
 * @author CWJ
 *
 */
@Service("PGPS0010")
public class PGPS0010Service extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(PGPS0010Service.class);
	
	@Autowired
	CodeService codeService;
	
	@Resource(name = "PGPS0010Mapper")
	private PGPS0010Mapper pgps0010Dao;
	
	@Resource(name = "PGPS0020Mapper")
	private PGPS0020Mapper pgps0020Dao;
	
	@Resource(name = "PGPS0030Mapper")
	private PGPS0030Mapper pgps0030Dao;
	
	@Resource(name="messageSource")
	private MessageSource messageSource;
	
	@Autowired
	HpeCnfirmReqstMapper hpeCnfirmReqstMapper;
	
	/**
	 * 기업검색>검색/목록
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map rqstMap) throws Exception {
		HashMap param = new HashMap();		
		param = (HashMap) rqstMap;
		/*
		int sel_target_year=0;
		
		//검색할 년도의 범위를 받는다.
		sel_target_year = MapUtils.getIntValue(rqstMap, "sel_target_year", 0);
		
		// 검색조건 년도목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		
		// 기준년도 파라미터 없는 경우 디폴트 세팅
		if(sel_target_year == 0) {
			sel_target_year = MapUtils.getIntValue(stdyyList.get(0), "stdyy");
		}		
		param.put("sel_target_year", sel_target_year);
		*/
		
		// 검색조건 년도목록 조회
		List<Map> stdyyList = pgps0010Dao.selectStdyyList(param);
		
		String selTargetYear = MapUtils.getString(rqstMap, "sel_target_year");
		
		// 기준년도 파라미터 없는 경우 디폴트 세팅
		if(Validate.isEmpty(selTargetYear)) {
			selTargetYear = MapUtils.getString(stdyyList.get(0), "stdyy");
		}
		param.put("sel_target_year", selTargetYear);
		
			
		if (MapUtils.getObject(rqstMap, "searchIndutyVal") instanceof String[]) {
			param.put("indutyVal", MapUtils.getObject(rqstMap, "searchIndutyVal"));
		} else {
			param.put("indutyVal", new String[] {(String) MapUtils.getObject(rqstMap, "searchIndutyVal")});
		}
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");		
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		logger.debug("rowSize: "+rowSize);
		
		String initSearchYn = MapUtils.getString(rqstMap, "init_search_yn");
		
		// 총 메뉴 글 개수
		int totalRowCnt = 0;
		if(Validate.isNotEmpty(initSearchYn)) {
			totalRowCnt = pgps0010Dao.findTotalEntprsInfoRowCnt2(param);
		}
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());

		// 기업정보 목록 조회
		List<Map> entprsList = new ArrayList<Map>();	
		if(Validate.isNotEmpty(initSearchYn)) {
			entprsList = pgps0010Dao.entprsList2(param);				
		}
		
		// 지역코드-광역시도
		List areaCity = new ArrayList();
		areaCity = pgps0020Dao.findCodesCity(param);
		
		// 지역코드-구/군
		List areaSelect = new ArrayList();
		areaSelect = pgps0020Dao.findAreaSelect(param);
		
		// 데이터 추가
		ModelAndView mv = new ModelAndView();
		
		// 검색조건 업종테마목록 조회
		//mv.addObject("themaList1", pgps0020Dao.indutyCd2(param));
		//mv.addObject("themaList2", pgps0020Dao.indutyCd3(param));
		
		// 검색조건 업종테마목록 조회
		//mv.addObject("themaList", pgps0030Dao.selectInduThemaList(param));
		
		// 검색조건 상세업종목록 조회
		mv.addObject("indutyList", pgps0030Dao.selectIndutyList(param));
		
		mv.addObject("pager", pager);
		mv.addObject("entprsList", entprsList);		
		mv.addObject("areaCity", areaCity);
		//mv.addObject("areaSelect", areaSelect);
		mv.addObject("areaSelect", JsonUtil.toJson(areaSelect));
		mv.addObject("stdyyList", stdyyList);
		
		mv.setViewName("/admin/ps/BD_UIPSA0010");			
		
		return mv;
	}
	
	/**
	 * 기업검색>상세정보을 조회한다.
	 * @return mv
	 * 
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
    public ModelAndView selectEntrprsResultList(Map<?,?> rqstMap) throws Exception {		
		HashMap param = new HashMap();
		if (rqstMap.containsKey("searchCondition")) param.put("searchCondition", rqstMap.get("searchCondition"));
		if (rqstMap.containsKey("searchKeyword")) param.put("searchKeyword", rqstMap.get("searchKeyword"));
		if (rqstMap.containsKey("sel_target_year")) param.put("sel_target_year", rqstMap.get("sel_target_year"));
		if (rqstMap.containsKey("multiSelectGrid3")) param.put("multiSelectGrid3", rqstMap.get("multiSelectGrid3"));
		if (rqstMap.containsKey("multiSelectGrid4")) param.put("multiSelectGrid4", rqstMap.get("multiSelectGrid4"));
		if (rqstMap.containsKey("ad_isnew")) param.put("ad_isnew", rqstMap.get("ad_isnew"));
		if (rqstMap.containsKey("ad_sn")) param.put("ad_sn", rqstMap.get("ad_sn"));
		if (rqstMap.containsKey("ad_ind_cd")) param.put("ad_ind_cd", rqstMap.get("ad_ind_cd"));
		if (rqstMap.containsKey("searchWrdSelect")) param.put("searchWrdSelect", rqstMap.get("searchWrdSelect"));
		if (rqstMap.containsKey("searchWrd")) param.put("searchWrd", rqstMap.get("searchWrd"));
		if (rqstMap.containsKey("capl1")) param.put("capl1", rqstMap.get("capl1"));
		if (rqstMap.containsKey("capl2")) param.put("capl2", rqstMap.get("capl2"));
		if (rqstMap.containsKey("assets_sm1")) param.put("assets_sm1", rqstMap.get("assets_sm1"));
		if (rqstMap.containsKey("assets_sm2")) param.put("assets_sm2", rqstMap.get("assets_sm2"));
		if (rqstMap.containsKey("selng_am1")) param.put("selng_am1", rqstMap.get("selng_am1"));
		if (rqstMap.containsKey("selng_am2")) param.put("selng_am2", rqstMap.get("selng_am2"));
		if (rqstMap.containsKey("xport_am_kr1")) param.put("xport_am_kr1", rqstMap.get("xport_am_kr1"));
		if (rqstMap.containsKey("xport_am_kr2")) param.put("xport_am_kr2", rqstMap.get("xport_am_kr2"));
		if (rqstMap.containsKey("bsn_profit1")) param.put("bsn_profit1", rqstMap.get("bsn_profit1"));
		if (rqstMap.containsKey("bsn_profit2")) param.put("bsn_profit2", rqstMap.get("bsn_profit2"));
		if (rqstMap.containsKey("thstrm_ntpf1")) param.put("thstrm_ntpf1", rqstMap.get("thstrm_ntpf1"));
		if (rqstMap.containsKey("thstrm_ntpf2")) param.put("thstrm_ntpf2", rqstMap.get("thstrm_ntpf2"));
		if (rqstMap.containsKey("rsrch_devlop_ct1")) param.put("rsrch_devlop_ct1", rqstMap.get("rsrch_devlop_ct1"));
		if (rqstMap.containsKey("rsrch_devlop_ct2")) param.put("rsrch_devlop_ct2", rqstMap.get("rsrch_devlop_ct2"));
		if (rqstMap.containsKey("ordtm_labrr_co1")) param.put("ordtm_labrr_co1", rqstMap.get("ordtm_labrr_co1"));
		if (rqstMap.containsKey("ordtm_labrr_co2")) param.put("ordtm_labrr_co2", rqstMap.get("ordtm_labrr_co2"));
		
		if (rqstMap.containsKey("b2bChk")) param.put("b2bChk", rqstMap.get("b2bChk"));
		if (rqstMap.containsKey("b2cChk")) param.put("b2cChk", rqstMap.get("b2cChk"));
		if (rqstMap.containsKey("b2gChk")) param.put("b2gChk", rqstMap.get("b2gChk"));
		if (rqstMap.containsKey("frgnrChk")) param.put("frgnrChk", rqstMap.get("frgnrChk"));
		if (rqstMap.containsKey("reason1")) param.put("reason1", rqstMap.get("reason1"));
		if (rqstMap.containsKey("reason2")) param.put("reason2", rqstMap.get("reason2"));
		if (rqstMap.containsKey("reason3")) param.put("reason3", rqstMap.get("reason3"));
		
		if (rqstMap.containsKey("hpe_cd")) param.put("hpe_cd", rqstMap.get("hpe_cd"));
		if (rqstMap.containsKey("jurirno")) param.put("jurirno", rqstMap.get("jurirno"));
		
		/*String hpe_cd = (String) rqstMap.get("hpe_cd");
		String jurirno = (String) rqstMap.get("jurirno");*/
		
		String multiSelectGrid3="";
		String multiSelectGrid4="";
		String ad_isnew="";
		String ad_sn="";
		String ad_ind_cd="";
		
		if (rqstMap.containsKey("multiSelectGrid3")) multiSelectGrid3= (String) rqstMap.get("multiSelectGrid3");
		if (rqstMap.containsKey("multiSelectGrid4")) multiSelectGrid4= (String) rqstMap.get("multiSelectGrid4");
		if (rqstMap.containsKey("ad_isnew")) ad_isnew= (String) rqstMap.get("ad_isnew");
		if (rqstMap.containsKey("ad_sn")) ad_sn= (String) rqstMap.get("ad_sn");
		if (rqstMap.containsKey("ad_ind_cd")) ad_ind_cd= (String) rqstMap.get("ad_ind_cd");		
		
		// 기업기본정보
		Map<String,Object> resultInfo = new HashMap<String,Object>();
		resultInfo = pgps0010Dao.selectEntrprsResult(rqstMap);
		
		String jurirno = MapUtils.getString(resultInfo, "JURIRNO");
		String bizrno = MapUtils.getString(resultInfo, "BIZRNO");
		String jurirno_fmt = "";
		String bizrno_fmt = "";
		
		if(Validate.isNotEmpty(jurirno)) {
			Map jurirnoMap = new HashMap<String, String>();
			jurirnoMap = StringUtil.toJurirnoFormat(jurirno);
			jurirno_fmt = jurirnoMap.get("first") + "-" +  jurirnoMap.get("last");
		}		
		if(Validate.isNotEmpty(bizrno)) {
			Map bizrnoMap = new HashMap<String, String>();
			bizrnoMap = StringUtil.toBizrnoFormat(bizrno);
			bizrno_fmt = bizrnoMap.get("first") + "-" + bizrnoMap.get("middle") + "-" +  bizrnoMap.get("last");
		}
		
		resultInfo.put("JURIRNO_FMT", jurirno_fmt);
		resultInfo.put("BIZRNO_FMT", bizrno_fmt);
		
		// 재무정보
		List<Map> fnnrResultInfo = new ArrayList<Map>();
		fnnrResultInfo = pgps0010Dao.selectFnnrResult(rqstMap);
		
		// 수출정보
		List<Map> patentExpInfo = new ArrayList<Map>();
		patentExpInfo = pgps0010Dao.selectExportResult(rqstMap);
		
		// 특허정보
		List<Map> patentResultInfo = new ArrayList<Map>();
		patentResultInfo = pgps0010Dao.selectPatentResult(rqstMap);
		
		// 출자 / 피출자
		List<Map> invstmntResultInfo = new ArrayList<Map>();
		invstmntResultInfo = pgps0010Dao.selectInvstmntResult(rqstMap);
		
		// 거래처정보
		List<Map> bcncResultInfo = new ArrayList<Map>();
		bcncResultInfo = pgps0010Dao.selectBcncResult(rqstMap);
		
		// 판정정보
		List<Map> jdgmntResultInfo = new ArrayList<Map>();
		jdgmntResultInfo = pgps0010Dao.selectJdgmntResult(rqstMap);
		
		// 주가정보
		List<Map> stkResultInfo = new ArrayList<Map>();
		stkResultInfo = pgps0010Dao.selectStkData(rqstMap);
		
		// 주요재무정보
		List<Map> entResultInfo = new ArrayList<Map>();	
		entResultInfo = pgps0010Dao.selectPointFnnrResult(rqstMap);
			
		
		List<Map> entResultInfoData = new ArrayList<Map>();
		int num = 0;
		for(int i=entResultInfo.size(); i > 0; i--) {
			entResultInfoData.add(num, entResultInfo.get(i-1));
			num++;
		}
		
		// 기업분석서비스
		HashMap sParam = new HashMap();
		sParam.put("STDYY", resultInfo.get("STDYY"));
		sParam.put("JURIRNO", resultInfo.get("JURIRNO"));
		Map entprsInfo = hpeCnfirmReqstMapper.selectEntprsInfo(sParam);
		
		String entrprsNm = MapUtils.getString(entprsInfo, "ENTRPRS_NM", "");					// 기업명
		String hpeCd = MapUtils.getString(entprsInfo, "HPE_CD");										// 기업관리코드		
		String lclasCd = MapUtils.getString(entprsInfo, "LCLAS_CD", "");							// 업종대분류코드
		String mlsfcCd = MapUtils.getString(entprsInfo, "MLSFC_CD", "");							// 업종중분류코드
		String indutyCode = lclasCd;	// 업종코드
						
		// 업종이 제조업인 경우 대분류코드 + 중분류코드 = 업종코드
		if(lclasCd.equals("C")) {
			indutyCode += mlsfcCd;			
		}
		
		sParam.put("HPE_CD", hpeCd);
		sParam.put("INDUTY_CODE", indutyCode);
		
		// 기업기본통계조회
		List<Map> stsEntcls = hpeCnfirmReqstMapper.selectEntBaseSts(sParam);
		
		sParam.put("LCLAS_CD", lclasCd);
		// 업종이 제조업인 경우 중분류코드 파라미터 추가
		if(lclasCd.equals("C")) {
			sParam.put("MLSFC_CD", mlsfcCd);
		}
		// 상위 5개 업체
		sParam.put("LIMIT", 5);
		
		// 상위업체평균통계 조회
		Map upperCmpnAvg = hpeCnfirmReqstMapper.selectUpperCmpnAvgSts(sParam);
		
		String[] remark = {entrprsNm, "동종업종(평균)", "전산업(평균)"};
		
		// 데이터 추가
		ModelAndView mv = new ModelAndView();
		mv.addObject("resultInfo", resultInfo);
		mv.addObject("fnnrResultInfo", fnnrResultInfo);
		mv.addObject("patentExpInfo", patentExpInfo);
		mv.addObject("patentResultInfo", patentResultInfo);
		mv.addObject("invstmntResultInfo", invstmntResultInfo);
		mv.addObject("bcncResultInfo", bcncResultInfo);
		mv.addObject("jdgmntResultInfo", jdgmntResultInfo);
		mv.addObject("stkResultInfo", stkResultInfo);
		
		// 주요재무정보
		mv.addObject("entResultInfoData", entResultInfoData);
		mv.addObject("existChartData", Validate.isNotEmpty(entResultInfo));
		mv.addObject("entprsInfo", entprsInfo);
		mv.addObject("stsEntcls", stsEntcls);
		mv.addObject("upperCmpnAvg", upperCmpnAvg);
		mv.addObject("remark", remark);
		
		
		mv.setViewName("/admin/ps/BD_UIPSA0011");
		
		
		return mv;
	}
    
    /**
     * 기업자료 엑셀자료 검색화면 
     * @param rqstMap
     * @return
     * @throws Exception
     */
    public ModelAndView excelEntrprsData(Map rqstMap) throws Exception {
    	
    	ModelAndView mv = new ModelAndView();

    	// 화면출력
    	if (MapUtils.getString(rqstMap, "ad_down", "").equals("")) {
    		    		
        	if (pgps0010Dao.findTotalEntprsInfoRowCnt2(rqstMap) > 5000) {
        		mv.addObject("resultMsg", messageSource.getMessage("fail.common.custom", new String[] {"엑셀다운로드 가능한 데이터는 최대 5,000건 입니다."}, Locale.getDefault()));
        	}
    		
    		mv.setViewName("/admin/ps/PD_UIPSA0010_1");
    		return mv;
    	}
    	
    	// 엑셀다운 처리
    	List<Map> resultBasic = null;
		ArrayList<String> headers = null;
		ArrayList<String> items = null;
		String[] arryHeaders = new String[] {};
		String[] arryItems = new String[] {};

		
    	String[] hpeCds = pgps0010Dao.selectEntrprsPKList2(rqstMap);
    	
    	if (hpeCds == null || hpeCds.length <= 0) {
    		
    		mv.addObject("_headers", arryHeaders);
    		mv.addObject("_items", arryItems);
    		mv.addObject("_list", new ArrayList());
    		
    		IExcelVO excel = new PGPS0010ExcelVO("기업검색_"+DateFormatUtil.getTodayFull());

    		return ResponseUtil.responseExcel(mv, excel);
    	}
    	
    	HashMap param = new HashMap();
    	param.put("stdyy", MapUtils.getString(rqstMap, "sel_target_year"));
    	param.put("hpeCds", hpeCds);

    	if (!MapUtils.getString(rqstMap, "searchInvst", "").equals("")) {
        	List<Map> resultInvst  = pgps0010Dao.selectExcelInvstDataList(param);
    		
    		headers = new ArrayList<String>();	// 타이틀
    		items = new ArrayList<String>();		// 컬럼명
    		
    		headers.add("기준년");
    		headers.add("기업관리코드");
    		headers.add("출자구분");
    		headers.add("순번");
    		headers.add("기업명");
    		headers.add("법인등록번호");
    		headers.add("사업자등록번호");
    		headers.add("지분율");
    		
    		items.add("STDYY");
    		items.add("HPE_CD");
    		items.add("INVSTMNT_SE_NM");
    		items.add("SN");
    		items.add("ENTRPRS_NM");
    		items.add("JURIRNO");
    		items.add("BIZRNO");
    		items.add("QOTA_RT");

    		arryHeaders= new String[] {};
    		arryItems = new String[] {};
    		
    		arryHeaders = headers.toArray(arryHeaders);
    		arryItems = items.toArray(arryItems);
    		
    		mv.addObject("_invstHeaders", arryHeaders);
    		mv.addObject("_invstItems", arryItems);
    		mv.addObject("_invstList", resultInvst);
    	}
    	
    	param.put("jdgmntMby", MapUtils.getString(rqstMap, "searchResn"));
    	
    	int sYear = MapUtils.getIntValue(rqstMap, "searchStartYear");
    	int eYear = MapUtils.getIntValue(rqstMap, "searchEndYear");
    	String[] years = new String[(eYear-sYear+1)];
    	
    	for (int i=0; i<years.length; i++) {
    		years[i] = String.valueOf(eYear-i);
    	}
    	
    	param.put("years", years);
    	
    	String[] fncItems = null;
    	ArrayList<String> arryFnnr = new ArrayList();
    	ArrayList<String> arryFtnt = new ArrayList();
    	String[] fnnrCols = new String[] {};
    	String[] ptntCols = new String[] {};
    	
    	Object obj = MapUtils.getObject(rqstMap, "searchFncItemVal");
    	if (obj instanceof String[]) {
    		fncItems = (String[]) obj;
    		
    		for (int i=0; i<fncItems.length; i++) {
    			String fncItem = fncItems[i];
    			if (fncItem.startsWith("fnnr.")) {
        			arryFnnr.add(fncItem.replaceFirst("fnnr.", ""));
    			} else {
        			arryFtnt.add(fncItem.replaceFirst("ptnt.", ""));
    			}
    			fnnrCols = arryFnnr.toArray(fnnrCols);
    			ptntCols = arryFtnt.toArray(ptntCols);
    		}
    	} else {
    		if (((String) obj).startsWith("fnnr.")) {
    			arryFnnr.add(((String) obj).replaceFirst("fnnr.", ""));
    			fnnrCols = arryFnnr.toArray(fnnrCols);
    		} else {
    			arryFtnt.add(((String) obj).replaceFirst("ftnt.", ""));
    			ptntCols = arryFtnt.toArray(ptntCols);
    		}
    	}
    	
    	param.put("fnnrCols", fnnrCols);
    	param.put("ftntCols", ptntCols);

    	resultBasic = pgps0010Dao.selectExcelBasicDataList(param);
    	
		headers = new ArrayList<String>();	// 타이틀
		items = new ArrayList<String>();		// 컬럼명
    	
		headers.add("기준년");
		headers.add("기업관리코드");
		headers.add("수집일자");
		headers.add("법인등록번호");
		headers.add("사업자등록번호");
		headers.add("기업명");
		headers.add("기업공개형태");
		headers.add("대표자명");
		headers.add("경영형태");
		headers.add("설립일자");
		headers.add("휴폐업일자");
		headers.add("휴폐업여부");
		headers.add("결산일");
		headers.add("상장일자");
		headers.add("소속그룹");
		headers.add("소속그룹법인등록번호");
		headers.add("본사주소");
		headers.add("지역(시도)");
		headers.add("대표전화");
		headers.add("업종대분류코드");
		headers.add("판정업종코드");
		headers.add("주요생산품");
		headers.add("규모기준");
		headers.add("상한_천명");
		headers.add("상한자산");
		headers.add("상한자본");
		headers.add("상한3년매출");
		headers.add("독립성직접30");
		headers.add("독립성간접30");
		headers.add("독립성_관계기업");
		headers.add("상호출자제한");
		headers.add("금융업_보험업");
		headers.add("중소기업");
		headers.add("유예기업1");
		headers.add("유예기업2");
		headers.add("유예기업3");
		headers.add("제외법인");
		headers.add("외국계대기업");
		headers.add("경과조치");
		headers.add("유예사유");
		
		items.add("STDYY");
		items.add("HPE_CD");
		items.add("COLCT_DE");
		items.add("JURIRNO");
		items.add("BIZRNO");
		items.add("ENTRPRS_NM");
		items.add("ENTRPRS_OTHBC_STLE");
		items.add("RPRSNTV_NM");
		items.add("MNGMT_STLE");
		items.add("FOND_DE");
		items.add("SPCSS_DE");
		items.add("SPCSS_AT");
		items.add("PSACNT");
		items.add("LST_DE");
		items.add("PSITN_GROUP");
		items.add("PSITN_GROUP_JURIRNO");
		items.add("HEDOFC_ADRES");
		items.add("AREA1");
		items.add("REPRSNT_TLPHON");
		items.add("LCLAS_CD");
		items.add("JDGMNT_INDUTY_CODE");
		items.add("MAIN_PRODUCT");
		items.add("SCALE_STDR");
		items.add("UPLMT_1000");
		items.add("UPLMT_ASSETS");
		items.add("UPLMT_CAPL");
		items.add("UPLMT_SELNG_3Y");
		items.add("INDPNDNCY_DIRECT_30");
		items.add("INDPNDNCY_INDRT_30");
		items.add("INDPNDNCY_RCPY");
		items.add("MTLTY_INVSTMNT_LMTT");
		items.add("FNCBIZ_ISCS");
		items.add("SMLPZ");
		items.add("POSTPNE_ENTRPRS1");
		items.add("POSTPNE_ENTRPRS2");
		items.add("POSTPNE_ENTRPRS3");
		items.add("EXCL_CPR");
		items.add("FRNTN_SM_LTRS");
		items.add("ELAPSE_MANAGT");
		items.add("POSTPNE_PRVONSH");
		
    	for (int i=0; i<years.length; i++) {
    		String year = years[i];
    		
    		for (int j=0; j<fnnrCols.length; j++) {
    			String colmn = fnnrCols[j];
    			
    			if (colmn.equals("ORDTM_LABRR_CO")) {
    				headers.add("상시근로자수_"+year);
    				items.add("y"+i+"ORDTM_LABRR_CO");
    			}
    			if (colmn.equals("DYNMC_ASSETS")) {
    				headers.add("유동자산_"+year);
    				items.add("y"+i+"DYNMC_ASSETS");
    			}
    			if (colmn.equals("CT_DYNMC_ASSETS")) {
    				headers.add("비유동자산_"+year);
    				items.add("y"+i+"CT_DYNMC_ASSETS");
    			}
    			if (colmn.equals("ASSETS_SM")) {
    				headers.add("자산총계_"+year);
    				items.add("y"+i+"ASSETS_SM");
    			}
    			if (colmn.equals("DYNMC_DEBT")) {
    				headers.add("유동부채_"+year);
    				items.add("y"+i+"DYNMC_DEBT");
    			}
    			if (colmn.equals("CT_DYNMC_DEBT")) {
    				headers.add("비유동부채_"+year);
    				items.add("y"+i+"CT_DYNMC_DEBT");
    			}
    			if (colmn.equals("DEBT")) {
    				headers.add("부채_"+year);
    				items.add("y"+i+"DEBT");
    			}
    			if (colmn.equals("CAPL_RESIDU_GLD")) {
    				headers.add("자본금잉여금_"+year);
    				items.add("y"+i+"CAPL_RESIDU_GLD");
    			}
    			if (colmn.equals("CAPL")) {
    				headers.add("자본금_"+year);
    				items.add("y"+i+"CAPL");
    			}
    			if (colmn.equals("CLPL")) {
    				headers.add("자본잉여금_"+year);
    				items.add("y"+i+"CLPL");
    			}
    			if (colmn.equals("PROFIT_RESIDU_GLD")) {
    				headers.add("이익잉여금_"+year);
    				items.add("y"+i+"PROFIT_RESIDU_GLD");
    			}
    			if (colmn.equals("CAPL_MDAT")) {
    				headers.add("자본조정_"+year);
    				items.add("y"+i+"CAPL_MDAT");
    			}
    			if (colmn.equals("CAPL_SM")) {
    				headers.add("자본총계_"+year);
    				items.add("y"+i+"CAPL_SM");
    			}
    			if (colmn.equals("SELNG_AM")) {
    				headers.add("매출액_"+year);
    				items.add("y"+i+"SELNG_AM");
    			}
    			if (colmn.equals("SELNG_TOT_PROFIT")) {
    				headers.add("매출총이익_"+year);
    				items.add("y"+i+"SELNG_TOT_PROFIT");
    			}
    			if (colmn.equals("BSN_PROFIT")) {
    				headers.add("영업이익_"+year);
    				items.add("y"+i+"BSN_PROFIT");
    			}
    			if (colmn.equals("BSN_ELSE_PROFIT")) {
    				headers.add("영업외이익_"+year);
    				items.add("y"+i+"BSN_ELSE_PROFIT");
    			}
    			if (colmn.equals("BSN_ELSE_CT")) {
    				headers.add("영업외비용_"+year);
    				items.add("y"+i+"BSN_ELSE_CT");
    			}
    			if (colmn.equals("PBDCRRX")) {
    				headers.add("법인세차감전순이익_"+year);
    				items.add("y"+i+"PBDCRRX");
    			}
    			if (colmn.equals("CRRX_CT")) {
    				headers.add("법인세비용_"+year);
    				items.add("y"+i+"CRRX_CT");
    			}
    			if (colmn.equals("THSTRM_NTPF")) {
    				headers.add("당기순이익_"+year);
    				items.add("y"+i+"THSTRM_NTPF");
    			}
    			if (colmn.equals("BSIS_CASH")) {
    				headers.add("기초현금_"+year);
    				items.add("y"+i+"BSIS_CASH");
    			}
    			if (colmn.equals("CFFO")) {
    				headers.add("영업활동으로인한현금흐름_"+year);
    				items.add("y"+i+"CFFO");
    			}
    			if (colmn.equals("CFFIA")) {
    				headers.add("투자활동으로인한현금흐름_"+year);
    				items.add("y"+i+"CFFIA");
    			}
    			if (colmn.equals("CFFFA")) {
    				headers.add("재무활동으로인한현금흐름_"+year);
    				items.add("y"+i+"CFFFA");
    			}
    			if (colmn.equals("CASH_INCRS_DCRS")) {
    				headers.add("현금증가감소_"+year);
    				items.add("y"+i+"CASH_INCRS_DCRS");
    			}
    			if (colmn.equals("TRMEND_CASH")) {
    				headers.add("기말현금_"+year);
    				items.add("y"+i+"TRMEND_CASH");
    			}
    			if (colmn.equals("RSRCH_DEVLOP_CT")) {
    				headers.add("연구개발비_"+year);
    				items.add("y"+i+"RSRCH_DEVLOP_CT");
    			}
    			if (colmn.equals("MCHN_DEVICE_ACQS")) {
    				headers.add("기계장치취득_"+year);
    				items.add("y"+i+"MCHN_DEVICE_ACQS");
    			}
    			if (colmn.equals("TOOL_ORGNZ_ACQS")) {
    				headers.add("공구기구취득_"+year);
    				items.add("y"+i+"TOOL_ORGNZ_ACQS");
    			}
    			if (colmn.equals("CNSTRC_ASSETS_INCRS")) {
    				headers.add("건설자산증가_"+year);
    				items.add("y"+i+"CNSTRC_ASSETS_INCRS");
    			}
    			if (colmn.equals("EQP_INVT")) {
    				headers.add("설비투자_"+year);
    				items.add("y"+i+"EQP_INVT");
    			}
    			if (colmn.equals("VAT")) {
    				headers.add("부가세_"+year);
    				items.add("y"+i+"VAT");
    			}
    			if (colmn.equals("LBCST")) {
    				headers.add("인건비_"+year);
    				items.add("y"+i+"LBCST");
    			}
    			if (colmn.equals("CTBNY")) {
    				headers.add("기부금_"+year);
    				items.add("y"+i+"CTBNY");
    			}
    			if (colmn.equals("WNMPY_RESRVE_RT")) {
    				headers.add("사내유보율_"+year);
    				items.add("y"+i+"WNMPY_RESRVE_RT");
    			}
    			if (colmn.equals("Y3AVG_SELNG_AM")) {
    				headers.add("3년평균매출액_"+year);
    				items.add("y"+i+"Y3AVG_SELNG_AM");
    			}
    		}
    		
    		for (int j=0; j<ptntCols.length; j++) {
    			String colmn = ptntCols[j];
    			
    			if (colmn.equals("DMSTC_PATENT_REGIST_VLM")) {
    				headers.add("국내특허등록권_"+year);
    				items.add("y"+i+"DMSTC_PATENT_REGIST_VLM");
    			}
    			if (colmn.equals("DMSTC_APLC_PATNTRT")) {
    				headers.add("국내출원특허권_"+year);
    				items.add("y"+i+"DMSTC_APLC_PATNTRT");
    			}
    			if (colmn.equals("UTLMDLRT")) {
    				headers.add("실용신안권_"+year);
    				items.add("y"+i+"UTLMDLRT");
    			}
    			if (colmn.equals("DSNREG")) {
    				headers.add("디자인등록_"+year);
    				items.add("y"+i+"DSNREG");
    			}
    			if (colmn.equals("TRDMKRT")) {
    				headers.add("상표권"+year);
    				items.add("y"+i+"TRDMKRT");
    			}
    			if (colmn.equals("XPORT_AM_WON")) {
    				headers.add("수출액원화_"+year);
    				items.add("y"+i+"XPORT_AM_WON");
    			}
    			if (colmn.equals("XPORT_AM_DOLLAR")) {
    				headers.add("수출액달러_"+year);
    				items.add("y"+i+"XPORT_AM_DOLLAR");
    			}
    		}
    	}

		arryHeaders = headers.toArray(arryHeaders);
		arryItems = items.toArray(arryItems);
		
		mv.addObject("_headers", arryHeaders);
		mv.addObject("_items", arryItems);
		mv.addObject("_list", resultBasic);

		IExcelVO excel = new PGPS0010ExcelVO("기업검색_"+DateFormatUtil.getTodayFull());

		return ResponseUtil.responseExcel(mv, excel);
    }

    
    
}
