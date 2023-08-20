package biz.tech.cs;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.code.CodeService;
import com.comm.code.CodeVO;
import com.comm.page.Pager;
import com.comm.user.EntUserVO;
import com.comm.user.UserVO;
import com.infra.file.FileDAO;
import com.infra.file.FileVO;
import com.infra.file.UploadHelper;
import com.infra.system.GlobalConst;
import com.infra.util.ArrayUtil;
import com.infra.util.JsonUtil;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.my.ApplyMapper;
import biz.tech.mapif.my.EmpmnMapper;
import biz.tech.mapif.ps.PGPS0010Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 고객지원 > 채용정보
 * 
 * @author dongwoo
 *
 */
@Service("PGCS0070")
public class PGCS0070Service extends EgovAbstractServiceImpl
{
	private static final Logger logger = LoggerFactory.getLogger(PGCS0070Service.class);
	private Locale locale = Locale.getDefault();
	
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	@Autowired
	CodeService codeService;
	
	@Resource(name="empmnMapper")
	private EmpmnMapper empmnDAO;
	
	@Resource(name="applyMapper")
	private ApplyMapper applyMapper;
	
	@Resource
    private FileDAO fileDao;	
	
	@Resource(name="PGPS0010Mapper")
	PGPS0010Mapper PGPS0010DAO;
	
	/**
	 * 채용정보 리스트 검색
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		List<Map> dataList = new ArrayList<Map>();
		Map result = new HashMap();

		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		String empmnNo;
		
		// 필터에 저장된 항목들을 가져와 배열로 넘겨 NOT IN 처리한다.
		// 필터항목들 검색
		// 필터 검색
		String temp = null;
		param.put("ad_select", "a");
		result = applyMapper.findFilter(param);
		if( result != null) {
			temp = result.get("ATRB").toString();
			String[] array_filterListA = temp.split(",");
			param.put("array_filterListA", array_filterListA);	// xml에서 사용될 배열
			param.put("tempA", temp);
		}
		param.put("ad_select", "b");
		result = applyMapper.findFilter(param);
		if( result != null) {
			temp = result.get("ATRB").toString();
			String[] array_filterListB = temp.split(",");
			param.put("array_filterListB", array_filterListB);	// xml에서 사용될 배열
			param.put("tempB", temp);
		}
		param.put("ad_select", "c");
		result = applyMapper.findFilter(param);
		if( result != null) {
			String stringfilterListC = result.get("ATRB").toString();
			param.put("stringfilterListC", stringfilterListC);	// xml에서 사용될 배열
		}

		// 검색조건
		param.put("use_search", "Y");
		param.put("search_type", MapUtils.getString(rqstMap, "search_type"));
		param.put("search_word", MapUtils.getString(rqstMap, "search_word"));
		// 경력
		param.put("search_career", MapUtils.getString(rqstMap, "search_career"));
		param.put("search_career_year", MapUtils.getString(rqstMap, "search_career_year"));
		param.put("search_work_style", MapUtils.getString(rqstMap, "search_work_style"));
		// 지역
		String search_area = MapUtils.getString(rqstMap,"search_zone");
		param.put("search_area",search_area);
		param.put("code", search_area);
		param.put("codeGroupNo", 22);
		result = codeService.findCodeInfo(param);
		if(result != null) {
			String search_area_NM = result.get("codeNm").toString();
			param.put("search_area_NM", search_area_NM);
			if(search_area == "WA10") {
				param.put("search_area_NM", "경상남도");	
			}
			else if(search_area == "WA11") {
				param.put("search_area_NM", "경상북도");
			}
			else if(search_area == "WA12") {
				param.put("search_area_NM", "전라남도");
			}
			else if(search_area == "WA13") {
				param.put("search_area_NM", "전라북도");
			}
			else if(search_area == "WA14") {
				param.put("search_area_NM", "충청북도");
			}
			else if(search_area == "WA15") {
				param.put("search_area_NM", "충청남도");
			}
		}
		
		// 직종
		param.put("search_jssfc", MapUtils.getString(rqstMap, "search_jssfc"));
		
		// 정렬조건
		String search_order = MapUtils.getString(rqstMap, "search_order"); 
		if(search_order != null && !(search_order.equals(""))) {
			param.put("stringfilterListC", MapUtils.getString(rqstMap, "search_order"));
		}
		
		param.put("BIZRNO", MapUtils.getString(rqstMap,"BIZRNO"));

		int totalRowCnt = empmnDAO.findEmpmnPblancInfoCount(param);
		mv.addObject("totalRowCnt", totalRowCnt);

		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());

		// 채용공고 리스트 조회
		dataList = empmnDAO.findEmpmnPblancInfoList(param);
		// 지역 리스트 조회
		List<Map> abrvList = codeService.findCodeList(param);
		
		// 항목관리 데이터를 dataList에 추가한다.
		if(Validate.isNotEmpty(dataList)) {
			String ecnyApplyDiv = "";		// 입사지원구분
			String careerDetail = "";		// 경력상세요건
			int offSet = 0;
			
			for(Map row : dataList) {
				empmnNo = MapUtils.getString(row, "EMPMN_MANAGE_NO", "");
				param.put("EMPMN_MANAGE_NO", empmnNo);
				param.put("PBLANC_IEM", "25"); // 경력
				row.put("iem25", empmnDAO.findEmpmnItem(param));
				param.put("PBLANC_IEM", "27"); // 학력
				row.put("iem27", empmnDAO.findEmpmnItem(param));
				param.put("BIZRNO", MapUtils.getString(row, "BIZRNO"));
				// 기업특성 가져오기
				row.put("chartr", empmnDAO.selectCmpnyIntrcnChartr(param));
				
				// 고객요청으로 근무형태 보여주지 않기로함. 2015-04-10
				// param.put("PBLANC_IEM", "33"); // 근무형태
				// row.put("iem33", empmnDAO.findEmpmnItem(param));
				
				ecnyApplyDiv = MapUtils.getString(row, "ECNY_APPLY_DIV", "");
			}
		}
		// 직종명
		mv.addObject("jssfcLargeList", empmnDAO.selectJssfcLargeList());
		
		//추천기업 조회 param
		param.put("recomend_entrprs_search_at", "Y".toString());
		
		//추천기업 조회
		List<Map> recommendList = new ArrayList<Map>();
		recommendList = empmnDAO.findCmpnyIntrcnRecomendLogoList();
		
		// 추천기업에서 진행중인 채용정보 건수를 알아온다.
		if(Validate.isNotEmpty(recommendList)) {
			for(Map row : recommendList) {
				param.put("BIZRNO", MapUtils.getString(row, "BIZRNO"));
				// 추천기업에서 진행중인 채용정보 건수
				row.put("recRowCnt", empmnDAO.findEmpmnPblancInfoCount(param));
			}
		}
		
		//추천기업 리스트
		mv.addObject("recommendList", recommendList);
		mv.addObject("abrvList", abrvList);
		mv.addObject("pager", pager);
		mv.addObject("dataList", dataList);
		mv.setViewName("/www/cs/BD_UICSU0070");
		return mv;		
	}
	
	/**
	 * 기업소개 팝업
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView cmpnyIntrcn(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		Map<String,Object> dataMap = new HashMap<String,Object>();
		
		String userNo = MapUtils.getString(rqstMap, "ad_ep_no");
		String bizrNo = MapUtils.getString(rqstMap, "ad_bizrno");
		
		logger.debug(bizrNo);
		logger.debug(userNo);
		
		// 기업사용자번호
		param.put("USER_NO", userNo);
		param.put("BIZRNO", bizrNo);
		dataMap = empmnDAO.findCmpnyIntrcnInfo(param);
		
		// 전화번호 파싱
		if(Validate.isNotEmpty(dataMap)) {
			Map<String, String> fmtTelNum = StringUtil.telNumFormat(MapUtils.getString(dataMap, "TELNO", ""));		
			Map<String, String> fmtFxnum = StringUtil.telNumFormat(MapUtils.getString(dataMap, "FXNUM", ""));	
					
			//전화번호
			dataMap.put("TELNO1", MapUtils.getString(fmtTelNum, "first", ""));
			dataMap.put("TELNO2", MapUtils.getString(fmtTelNum, "middle", ""));
			dataMap.put("TELNO3", MapUtils.getString(fmtTelNum, "last", ""));	
			//팩스번호
			dataMap.put("FXNUM1", MapUtils.getString(fmtFxnum, "first", ""));
			dataMap.put("FXNUM2", MapUtils.getString(fmtFxnum, "middle", ""));
			dataMap.put("FXNUM3", MapUtils.getString(fmtFxnum, "last", ""));
		}
		
		// 홈페이지 주소
		String hmpgAddr = MapUtils.getString(dataMap, "HMPG");
		if(Validate.isNotEmpty(hmpgAddr)) {
			hmpgAddr.startsWith("");
			if(!hmpgAddr.startsWith("http://") && !hmpgAddr.startsWith("https://")) {
				dataMap.put("HMPG", "http://" + hmpgAddr);
			}
		}
		
		// 주요지표현황 조회
		param.put("ENTRPRS_USER_NO", userNo);
		List<Map> indexList = empmnDAO.findEmpmnIndexInfo(param);
		List<int[]> labrrDatas = new ArrayList<int[]>();	//근로자수
		List<int[]> selngDatas = new ArrayList<int[]>();	//매출액
		List<int[]> caplDatas = new ArrayList<int[]>();	//자본금
		List<int[]> assetsDatas = new ArrayList<int[]>();	//자산총액
		
		int[] tempArr = null;
		
		for(Map yearBydata : indexList) {
			tempArr = new int[2];
			tempArr[0] = MapUtils.getIntValue(yearBydata, "STDYY");
			tempArr[1] = MapUtils.getIntValue(yearBydata, "ORDTM_LABRR_CO");	// 상시근로자수
			labrrDatas.add(tempArr);
			tempArr = new int[2];
			tempArr[0] = MapUtils.getIntValue(yearBydata, "STDYY");
			tempArr[1] = MapUtils.getIntValue(yearBydata, "SELNG_AM");			// 매출액
			selngDatas.add(tempArr);
			tempArr = new int[2];
			tempArr[0] = MapUtils.getIntValue(yearBydata, "STDYY");
			tempArr[1] = MapUtils.getIntValue(yearBydata, "CAPL");				// 자본금
			caplDatas.add(tempArr);
			tempArr = new int[2];
			tempArr[0] = MapUtils.getIntValue(yearBydata, "STDYY");
			tempArr[1] = MapUtils.getIntValue(yearBydata, "ASSETS_SM");			// 자산총액
			assetsDatas.add(tempArr);
		}			
		
		List<Map> layoutList = empmnDAO.findCmpnyIntrcnLayoutList(param);
		
		String br = "";
		for(int i=0; i<layoutList.size(); i++) {
			br = (String) layoutList.get(i).get("TEXT");
			if(!"".equals(br) && Validate.isNotNull(br)) {
				br = br.replaceAll("\r\n", "<br/>");
				layoutList.get(i).put("TEXT", br);
			}
		}
		
		mv.addObject("chartr", empmnDAO.selectCmpnyIntrcnChartr(param));
		
		mv.addObject("layoutList",layoutList);
		//mv.addObject("layoutTextList",empmnDAO.findCmpnyIntrcnLayoutTextList(param));
		
		mv.addObject("labrrDatas", JsonUtil.toJson(labrrDatas));
		mv.addObject("selngDatas", JsonUtil.toJson(selngDatas));
		mv.addObject("caplDatas", JsonUtil.toJson(caplDatas));
		mv.addObject("assetsDatas", JsonUtil.toJson(assetsDatas));
		mv.addObject("existChartData", Validate.isNotEmpty(indexList));
		
		mv.addObject("dataMap", dataMap);
		mv.setViewName("/www/cs/PD_UICSU0071");
		return mv;		
		
	}
	
	/**
	 * 채용정보 팝업
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView empmnInfoView(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		Map<String,Object> intrcnMap = new HashMap<String,Object>();	//기업소개 조회결과
		Map<String,Object> pblancMap = new HashMap<String,Object>();	//채용공고 조회결과
		
		String empmnNo = MapUtils.getString(rqstMap, "ad_empmn_manage_no");		//채용관리번호
		String epNo = "";														//기업사용자번호
		
		//채용공고 조회
		param.put("EMPMN_MANAGE_NO", empmnNo);
		pblancMap = empmnDAO.findEmpmnPblancInfo(param);
		
		UserVO userVO = SessionUtil.getUserInfo();
		
		if(isAdminAuth(userVO)) {
			mv.addObject("adminAuth","Y");
		}else {
			mv.addObject("adminAuth","N");
		}		
		
		if(Validate.isNotEmpty(pblancMap)) {
			// 채용공고 항목관리 조회
			/*pblancMap.put("itemList", empmnDAO.findEmpmnItem(param));*/
			param.put("PBLANC_IEM", "33"); // 근무형태
			pblancMap.put("iem33", empmnDAO.findEmpmnItem(param));
			param.put("PBLANC_IEM", "25"); // 경력
			pblancMap.put("iem25", empmnDAO.findEmpmnItem(param));
			param.put("PBLANC_IEM", "27"); // 학력
			pblancMap.put("iem27", empmnDAO.findEmpmnItem(param));
			param.put("PBLANC_IEM", "51"); // 모집인원
			pblancMap.put("iem51", empmnDAO.findEmpmnItem(param));
			param.put("PBLANC_IEM", "52"); // 나이
			pblancMap.put("iem52", empmnDAO.findEmpmnItem(param));
			param.put("PBLANC_IEM", "22"); // 근무지역
			pblancMap.put("iem22", empmnDAO.findEmpmnItem(param));
			param.put("PBLANC_IEM", "31"); // 모집직급
			pblancMap.put("iem31", empmnDAO.findEmpmnItem(param));
			param.put("PBLANC_IEM", "32"); // 모집직책
			pblancMap.put("iem32", empmnDAO.findEmpmnItem(param));
		}		
		
		//기업소개 조회
		epNo = MapUtils.getString(pblancMap, "USER_NO");
		param.put("USER_NO", epNo);
		param.put("BIZRNO", MapUtils.getString(pblancMap, "BIZRNO"));
		intrcnMap = empmnDAO.findCmpnyIntrcnInfo(param);
		
		// 전화번호 파싱
		if(Validate.isNotEmpty(intrcnMap)) {
			Map<String, String> fmtTelNum = StringUtil.telNumFormat(MapUtils.getString(intrcnMap, "TELNO", ""));		
			Map<String, String> fmtFxnum = StringUtil.telNumFormat(MapUtils.getString(intrcnMap, "FXNUM", ""));	
					
			//전화번호
			intrcnMap.put("TELNO1", MapUtils.getString(fmtTelNum, "first", ""));
			intrcnMap.put("TELNO2", MapUtils.getString(fmtTelNum, "middle", ""));
			intrcnMap.put("TELNO3", MapUtils.getString(fmtTelNum, "last", ""));	
			//팩스번호
			intrcnMap.put("FXNUM1", MapUtils.getString(fmtFxnum, "first", ""));
			intrcnMap.put("FXNUM2", MapUtils.getString(fmtFxnum, "middle", ""));
			intrcnMap.put("FXNUM3", MapUtils.getString(fmtFxnum, "last", ""));
		}
		
		if(Validate.isEmpty(intrcnMap)) {								// 기업소개에서 정보를 찾지 못할경우
			intrcnMap = empmnDAO.findIntrcnInfo(param);		// 기업정보마스터 테이블에서 조회하고
			
			if(Validate.isNotEmpty(intrcnMap)) {						// 기업정보마스터 테이블에서도 조회가 안되면 통과한다.
				String fmtTelNum = MapUtils.getString(intrcnMap, "TELNO", "");
				fmtTelNum = fmtTelNum.replace("-", "");
				fmtTelNum = fmtTelNum.replace(" ", "");
				
				//전화번호
				if(fmtTelNum.length() > 0) {
	//				logger.debug("----------fmtTelNum.substring(1, 2) : " + fmtTelNum.substring(0, 2));
	//				logger.debug("----------fmtTelNum.length() : " + fmtTelNum.length());
	//				logger.debug("----------fmtTelNum.substring(0, 2) : " + fmtTelNum.substring(0, 2));
	//				logger.debug("----------fmtTelNum.substring(2, 6) : " + fmtTelNum.substring(2, 6));
	//				logger.debug("----------fmtTelNum.substring(6, 10) : " + fmtTelNum.substring(6, 10));
					
					if("02".equals(fmtTelNum.substring(0, 2))) {	//국번 02라면
						if(fmtTelNum.length()==10) {
							intrcnMap.put("TELNO1", fmtTelNum.substring(0, 2));
							intrcnMap.put("TELNO2", fmtTelNum.substring(2, 6));
							intrcnMap.put("TELNO3", fmtTelNum.substring(6, fmtTelNum.length()));
						}else if(fmtTelNum.length()==9) {
							intrcnMap.put("TELNO1", fmtTelNum.substring(0, 2));
							intrcnMap.put("TELNO2", fmtTelNum.substring(2, 5));
							intrcnMap.put("TELNO3", fmtTelNum.substring(5, fmtTelNum.length()));
						}
					}else{
						if(fmtTelNum.length()==11) {
							intrcnMap.put("TELNO1", fmtTelNum.substring(0, 3));
							intrcnMap.put("TELNO2", fmtTelNum.substring(3, 7));
							intrcnMap.put("TELNO3", fmtTelNum.substring(7, fmtTelNum.length()));
						}else if(fmtTelNum.length()==10) {
							intrcnMap.put("TELNO1", fmtTelNum.substring(0, 3));
							intrcnMap.put("TELNO2", fmtTelNum.substring(3, 6));
							intrcnMap.put("TELNO3", fmtTelNum.substring(6, fmtTelNum.length()));
						}
					}
					
					/*
					intrcnMap.put("TELNO1", fmtTelNum.substring(0, 4));
					intrcnMap.put("TELNO2", fmtTelNum.substring(4, 8));
					intrcnMap.put("TELNO3", fmtTelNum.substring(8, 12));
					*/
				}else {
					intrcnMap.put("TELNO1", "");
					intrcnMap.put("TELNO2", "");
					intrcnMap.put("TELNO3", "");
				}
			}
		}
		
		//기업특성 가져오기
		mv.addObject("chartr", empmnDAO.selectCmpnyIntrcnChartr(param));
		
		mv.addObject("intrcnMap", intrcnMap);
		mv.addObject("pblancMap", pblancMap);
		mv.setViewName("/www/cs/PD_UICSU0072");
		return mv;		
	}
		
	/**
	 * 입사지원서 작성
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView applyCmpnyForm(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		Map<String,Object> empmnMap = new HashMap<String,Object>();
		Map<String,Object> applyMap = new HashMap<String,Object>();
		
		String empmnNo = MapUtils.getString(rqstMap, "ad_empmn_manage_no");
		String virtualEmpNo = MapUtils.getString(rqstMap, "ad_virtl_empmn_manage_no");
		String loadDataAt = "N";
		
		String userNo = SessionUtil.getUserInfo().getUserNo();
		String userNm = SessionUtil.getUserInfo().getUserNm();		
		
		// 채용공고 상세조회
		param.put("EMPMN_MANAGE_NO", empmnNo);
		empmnMap = empmnDAO.findEmpmnPblancInfo(param);
		
		if(Validate.isEmpty(empmnMap)) {
			throw processException("info.searchdata.seq", new String[] {"채용공고"});
		}				
		
		// 학력구분코드 리스트
		List<CodeVO> codeList = codeService.findCodesByGroupNo("53");
		List<CodeVO> prtAcmCodeList = new ArrayList<CodeVO>();
		List<CodeVO> chdAcmCodeList = new ArrayList<CodeVO>();
		for(CodeVO vo : codeList) {
			if(vo.getCode().length() == 1) {
				prtAcmCodeList.add(vo);
			}else {
				chdAcmCodeList.add(vo);
			}
		}
		
		// 입사지원정보 조회		
		param.put("USER_NO", userNo);
		
		// 입사지원서 불러오기 사용한 경우
		if(Validate.isNotEmpty(virtualEmpNo)) {
			param.put("EMPMN_MANAGE_NO", virtualEmpNo);
			loadDataAt = "Y";
		}
		applyMap = applyMapper.findCompApplyInfo(param);				
		
		if(Validate.isNotEmpty(applyMap)) {
			String acdmcrAt = MapUtils.getString(empmnMap, "DETAIL_ACDMCR_INPUT_AT", "");				//상세학력입력여부			
			String elseLgtyAt = MapUtils.getString(empmnMap, "_ELSE_LGTY_INPUT_AT", "");				//외국어능력입력여부
			String edcComplAt = MapUtils.getString(empmnMap, "EDC_COMPL_INPUT_AT", "");					//교육이수입력여부
			String ovseaAdytrnAt = MapUtils.getString(empmnMap, "OVSEA_SDYTRN_INPUT_AT", "");			//해외연수입력여부
			String qualfAcqsAt = MapUtils.getString(empmnMap, "QUALF_ACQS_INPUT_AT", "");				//자격취득입력여부
			String wtrcDtlsAt = MapUtils.getString(empmnMap, "WTRC_DTLS_INPUT_AT", "");					//수상내역입력여부			
			
			if("Y".equals(acdmcrAt)) {
				// 학력사항 조회
				applyMap.put("ACDMCR", applyMapper.findCaAcdmcr(param));				
			}			
			if("Y".equals(elseLgtyAt)) {
				// 외국어능력 조회
				applyMap.put("FGGG", applyMapper.findCaFggg(param));
			}
			if("Y".equals(edcComplAt)) {
				// 교육이수내역 조회
				applyMap.put("EDC", applyMapper.findCaEdc(param));
			}
			if("Y".equals(ovseaAdytrnAt)) {
				// 해외연수경험 조회
				applyMap.put("SDYTRN", applyMapper.findCaSdytrn(param));
			}
			if("Y".equals(qualfAcqsAt)) {
				// 자격취득사항 조회
				applyMap.put("QUALF", applyMapper.findCaQualf(param));
			}
			if("Y".equals(wtrcDtlsAt)) {
				// 수상내역 조회
				applyMap.put("AQTC", applyMapper.findCaRwrpns(param));
			}
			// 경력사항 조회
			applyMap.put("CACAREER", applyMapper.findCaCareer(param));
			
			// 전화번호 파싱
			Map<String, String> fmtTelNum = StringUtil.telNumFormat(MapUtils.getString(applyMap, "TELNO", ""));		
			Map<String, String> fmtMbtlnum = StringUtil.telNumFormat(MapUtils.getString(applyMap, "MBTLNUM", ""));	
					
			//전화번호
			applyMap.put("TELNO1", MapUtils.getString(fmtTelNum, "first", ""));
			applyMap.put("TELNO2", MapUtils.getString(fmtTelNum, "middle", ""));
			applyMap.put("TELNO3", MapUtils.getString(fmtTelNum, "last", ""));	
			//팩스번호
			applyMap.put("MBTLNUM1", MapUtils.getString(fmtMbtlnum, "first", ""));
			applyMap.put("MBTLNUM2", MapUtils.getString(fmtMbtlnum, "middle", ""));
			applyMap.put("MBTLNUM3", MapUtils.getString(fmtMbtlnum, "last", ""));			
		}
		
		mv.addObject("userNm", userNm);
		mv.addObject("applyMap", applyMap);
		mv.addObject("empmnMap", empmnMap);
		mv.addObject("prtAcmCodeList", prtAcmCodeList);
		mv.addObject("chdAcmCodeList", chdAcmCodeList);
		mv.addObject("chdAcmCodeJson", JsonUtil.toJson(chdAcmCodeList));
		mv.addObject("LOAD_DATA_AT", loadDataAt);
		
		mv.setViewName("/www/cs/PD_UICSU0073");
		return mv;		
	}
	
	/**
	 * 입사지원 사진 업로드
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processApplyAtchPhoto(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		Map<String,Object> dataMap = new HashMap<String,Object>();
		FileVO fileVO = null;
		int fileSeq = -1;
		int resultFileSeq = 0;
		boolean dataExst = false;
		
		String empmnNo = MapUtils.getString(rqstMap, "ad_empmn_manage_no");
		String userNo = SessionUtil.getUserInfo().getUserNo();
		
		param.put("EMPMN_MANAGE_NO", empmnNo);
		param.put("USER_NO", userNo);		
		
		//파일 seq 조회
		dataMap = applyMapper.findCompApplyInfo(param);		
		fileSeq = MapUtils.getInteger(dataMap, "PHOTO_FILE_SN", -1);
		
		//INSERT, UPDATE 여부 결정
		if(Validate.isNotEmpty(MapUtils.getString(dataMap, "USER_NO"))) {
			dataExst = true;
		}
		
		//파일업로드
		List<FileVO> fileList = new ArrayList<FileVO>();		
		MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) MapUtils.getObject(rqstMap, GlobalConst.RQST_MULTIPART);		
    	List<MultipartFile> multiFiles = multiRequest.getFiles("photo_file");
    	fileList = UploadHelper.upload(multiFiles, "apply");
		
    	//기존 첨부파일 삭제
    	if(fileSeq != -1) {
    		fileDao.removeFile(fileSeq);
    	}
    	fileSeq = fileDao.saveFile(fileList, fileSeq);
    	
    	//업로드 성공시 DB변경
    	if(fileList.size() > 0 && fileSeq > -1) {
    		fileVO = fileList.get(0);
    		
    		param.put("PHOTO_FILE_SN", fileSeq);
    		param.put("PHOTO_FILE_NM", fileVO.getLocalNm());
    		
    		if(dataExst) {
    			applyMapper.updateApplyAtchPhoto(param);
    		}else{
    			applyMapper.insertApplyAtchPhoto(param);
    		}
    		    		
    		resultFileSeq = fileVO.getFileSeq();
    	}
    	
		return ResponseUtil.responseText(mv, resultFileSeq);
	}
	
	/**
	 * 입사지원서 저장/등록
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processApplyCmpny(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		Map<String,Object> dataMap = new HashMap<String,Object>();
		Map<String,Object> empmnMap = new HashMap<String,Object>();
		boolean isExist = false;
		
		String empmnNo = MapUtils.getString(rqstMap, "ad_empmn_manage_no");
		String userNo = SessionUtil.getUserInfo().getUserNo();
		String userNm = SessionUtil.getUserInfo().getUserNm();
		
		FileVO fileVO = null;
		int fileSeq = -1;
		
		if(Validate.isEmpty(empmnNo) || Validate.isEmpty(userNo)) {
			throw processException("fail.common.session");
		}				
		
		// 채용공고 상세조회
		param.put("EMPMN_MANAGE_NO", empmnNo);
		empmnMap = empmnDAO.findEmpmnPblancInfo(param);
		
		String acdmcrAt = MapUtils.getString(empmnMap, "DETAIL_ACDMCR_INPUT_AT", "");				//상세학력입력여부
		String pvltrtMatterAt = MapUtils.getString(empmnMap, "EMPYMN_PVLTRT_MATTER_INPUT_AT", "");	//취업우대사항입력여부
		String elseLgtyAt = MapUtils.getString(empmnMap, "_ELSE_LGTY_INPUT_AT", "");				//외국어능력입력여부
		String edcComplAt = MapUtils.getString(empmnMap, "EDC_COMPL_INPUT_AT", "");					//교육이수입력여부
		String ovseaAdytrnAt = MapUtils.getString(empmnMap, "OVSEA_SDYTRN_INPUT_AT", "");			//해외연수입력여부
		String qualfAcqsAt = MapUtils.getString(empmnMap, "QUALF_ACQS_INPUT_AT", "");				//자격취득입력여부
		String wtrcDtlsAt = MapUtils.getString(empmnMap, "WTRC_DTLS_INPUT_AT", "");					//수상내역입력여부
		
		// 입사지원정보 조회		
		param.put("USER_NO", userNo);
		//파일 seq 조회
		dataMap = applyMapper.findCompApplyInfo(param);				
		isExist = Validate.isNotEmpty(dataMap);
		fileSeq = MapUtils.getInteger(dataMap, "HIST_FILE_SEQ1", -1);		
		param.put("NM", userNm);
		
		param.put("RCEPT_AT", MapUtils.getString(rqstMap, "ad_rcept_at"));		
		param.put("ENG_NM", MapUtils.getString(rqstMap, "ad_eng_nm"));
		/*param.put("PHOTO_FILE_NM", MapUtils.getString(rqstMap, "ad_photo_file_nm"));
		param.put("PHOTO_FILE_SN", MapUtils.getString(rqstMap, "ad_photo_file_sn"));*/
		param.put("BRTHDY", MapUtils.getString(rqstMap, "ad_brthdy"));
		param.put("EMAIL", MapUtils.getString(rqstMap, "ad_email"));
		param.put("ZIP", MapUtils.getString(rqstMap, "ad_zip"));
		param.put("ADRES", MapUtils.getString(rqstMap, "ad_adres"));
		param.put("TELNO", MapUtils.getString(rqstMap, "ad_telno"));
		param.put("MBTLNUM", MapUtils.getString(rqstMap, "ad_mbtlnum"));
		param.put("APPLY_SJ", MapUtils.getString(rqstMap, "ad_apply_sj"));
		param.put("APPLY_REALM", MapUtils.getString(rqstMap, "ad_apply_realm"));
		param.put("CAREER_DIV", MapUtils.getString(rqstMap, "ad_career_div"));
		param.put("CAREER", MapUtils.getString(rqstMap, "ad_career"));
		param.put("ANSLRY_DIV", MapUtils.getString(rqstMap, "ad_anslry_div"));
		param.put("HOPE_ANSLRY", MapUtils.getString(rqstMap, "ad_hope_anslry"));
		param.put("RWDMRT_TRGET_AT", MapUtils.getString(rqstMap, "ad_rwdmrt_trget_at"));
		param.put("EMPYMN_PRTC_TRGET_AT", MapUtils.getString(rqstMap, "ad_empymn_prtc_trget_at"));
		param.put("EMPLYM_SPRMNY_TRGET_AT", MapUtils.getString(rqstMap, "ad_emplym_sprmny_trget_at"));
		param.put("TROBL_AT", MapUtils.getString(rqstMap, "ad_trobl_at"));
		param.put("TROBL_GRAD", MapUtils.getString(rqstMap, "ad_trobl_grad"));
		param.put("MTRSC_DIV", MapUtils.getString(rqstMap, "ad_mtrsc_div"));
		param.put("ENST_YM", MapUtils.getString(rqstMap, "ad_enst_ym"));
		param.put("DMBLZ_YM", MapUtils.getString(rqstMap, "ad_dmblz_ym"));
		param.put("MSCL", MapUtils.getString(rqstMap, "ad_mscl"));
		param.put("CLSS", MapUtils.getString(rqstMap, "ad_clss"));
		/*param.put("HIST_FILE1", MapUtils.getString(rqstMap, "ad_hist_file1"));
		param.put("HIST_FILE_SEQ1", MapUtils.getString(rqstMap, "ad_hist_file_seq1"));
		param.put("HIST_FILE2", MapUtils.getString(rqstMap, "ad_hist_file2"));
		param.put("HIST_FILE_SEQ2", MapUtils.getString(rqstMap, "ad_hist_file_seq2"));*/
		param.put("ANSWER1", MapUtils.getString(rqstMap, "ad_answer1"));
		param.put("ANSWER2", MapUtils.getString(rqstMap, "ad_answer2"));
		param.put("ANSWER3", MapUtils.getString(rqstMap, "ad_answer3"));
		param.put("ANSWER4", MapUtils.getString(rqstMap, "ad_answer4"));
		param.put("ANSWER5", MapUtils.getString(rqstMap, "ad_answer5"));
		
		//파일업로드
		List<FileVO> fileList = new ArrayList<FileVO>();		
		MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) MapUtils.getObject(rqstMap, GlobalConst.RQST_MULTIPART);		
    	List<MultipartFile> multiFiles = multiRequest.getFiles("hist_file");
    	
    	if(Validate.isNotEmpty(multiFiles)) {
    	
	    	fileList = UploadHelper.upload(multiFiles, "apply");
			
	    	//기존 첨부파일 삭제
	    	if(fileSeq != -1) {
	    		fileDao.removeFile(fileSeq);
	    	}
	    	fileSeq = fileDao.saveFile(fileList, fileSeq);
    	}    	
    	
    	//업로드 성공시 DB변경
    	if(fileList.size() > 0 && fileSeq > -1) {
    		fileVO = fileList.get(0);
    		
    		param.put("HIST_FILE_SEQ1", fileSeq);
    		param.put("HIST_FILE1", fileVO.getLocalNm());    		
    	}else {
    		param.put("HIST_FILE_SEQ1", MapUtils.getString(dataMap, "HIST_FILE_SEQ1"));
    		param.put("HIST_FILE1", MapUtils.getString(dataMap, "HIST_FILE1"));
    	}
		
		if(isExist) {
			// 입사지원 추가 항목리스트 삭제
			applyMapper.deleteCaAcdmcr(param);
			applyMapper.deleteCaEdc(param);
			applyMapper.deleteCaFggg(param);
			applyMapper.deleteCaSdytrn(param);
			applyMapper.deleteCaCareer(param);
			applyMapper.deleteCaQualf(param);
			applyMapper.deleteCaRwrpns(param);
			
			applyMapper.updateCompApply(param);
		}else {
			applyMapper.insertCompApply(param);
		}
		
		if("Y".equals(acdmcrAt)) {
			insertCaAcdmcr(rqstMap, empmnNo, userNo);
		}
		if("Y".equals(edcComplAt)) {
			insertCaEdc(rqstMap, empmnNo, userNo);
		}
		if("Y".equals(elseLgtyAt)) {
			insertCaFggg(rqstMap, empmnNo, userNo);
		}
		if("Y".equals(ovseaAdytrnAt)) {
			insertCaSdytrn(rqstMap, empmnNo, userNo);
		}		
		insertCaCareer(rqstMap, empmnNo, userNo);
		
		if("Y".equals(qualfAcqsAt)) {
			insertCaQualf(rqstMap, empmnNo, userNo);
		}
		if("Y".equals(wtrcDtlsAt)) {
			insertCaRwrpns(rqstMap, empmnNo, userNo);
		}				
				
		return ResponseUtil.responseText(mv, Boolean.TRUE);
	}
	
	/**
	 * 학력사항 등록
	 * @param rqstMap
	 * @throws Exception
	 */
	public void insertCaAcdmcr(Map<?, ?> rqstMap, String empmnNo, String userNo) throws Exception {
		Map<String,Object> param = new HashMap<String,Object>();		
		
		param.put("EMPMN_MANAGE_NO", empmnNo);
		param.put("USER_NO", userNo);
		
		String acdmcrCode = "";
		
		for(int i=1; i<=5; i++) {
			acdmcrCode = MapUtils.getString(rqstMap, "ad_acdmcr_code_" + i);
			if(Validate.isEmpty(acdmcrCode)) {
				continue;
			}
			
			param.put("ACDMCR_CODE", acdmcrCode);				
			param.put("SN", i);				
			param.put("SCHUL_NM", MapUtils.getString(rqstMap, "ad_schul_nm_" + i));
			param.put("MAJOR1", MapUtils.getString(rqstMap, "ad_major1_" + i));
			param.put("MAJOR2", MapUtils.getString(rqstMap, "ad_major2_" + i));
			param.put("LOCPLC", MapUtils.getString(rqstMap, "ad_locplc_" + i));
			param.put("ENTSCH_DE", MapUtils.getString(rqstMap, "ad_entsch_de_" + i));
			param.put("ENTSCH_SE", MapUtils.getString(rqstMap, "ad_entsch_se_" + i));
			param.put("GRDTN_DE", MapUtils.getString(rqstMap, "ad_grdtn_de_" + i));
			param.put("GRDTN_SE", MapUtils.getString(rqstMap, "ad_grdtn_se_" + i));
			param.put("SCRE", MapUtils.getString(rqstMap, "ad_scre_" + i));
			param.put("PSCORE", MapUtils.getString(rqstMap, "ad_pscore_" + i));
			
			applyMapper.insertCaAcdmcr(param);			
		}				
	}
	
	/**
	 * 교육이수내역 등록
	 * @param rqstMap
	 * @throws Exception
	 */
	public void insertCaEdc(Map<?, ?> rqstMap, String empmnNo, String userNo) throws Exception {
		Map<String,Object> param = new HashMap<String,Object>();		
		
		param.put("EMPMN_MANAGE_NO", empmnNo);
		param.put("USER_NO", userNo);
		
		String edcNm = "";
		String beginDe = "";
		String endDe = "";
		
		for(int i=1; i<=5; i++) {
			edcNm = MapUtils.getString(rqstMap, "ad_edc_nm_" + i);
			
			if(Validate.isEmpty(edcNm)) {
				continue;
			}
			
			param.put("SN", i);
			param.put("EDC_NM", edcNm);
			param.put("ECLST", MapUtils.getString(rqstMap, "ad_eclst_" + i));
			
			beginDe = MapUtils.getString(rqstMap, "ad_edc_begin_de_" + i);
			endDe = MapUtils.getString(rqstMap, "ad_edc_end_de_" + i);
			
			param.put("EDC_BEGIN_DE", StringUtil.replace(beginDe, "-", ""));
			param.put("EDC_END_DE", StringUtil.replace(endDe, "-", ""));
			param.put("EDC_CN", MapUtils.getString(rqstMap, "ad_edc_cn_" + i));	
			
			applyMapper.insertCaEdc(param);
		}				
	}
	
	/**
	 * 외국어능력 등록
	 * @param rqstMap
	 * @throws Exception
	 */
	public void insertCaFggg(Map<?, ?> rqstMap, String empmnNo, String userNo) throws Exception {
		Map<String,Object> param = new HashMap<String,Object>();		
		
		param.put("EMPMN_MANAGE_NO", empmnNo);
		param.put("USER_NO", userNo);
		
		String fgggNm = "";
		String acqsDe = "";
		
		for(int i=1; i<=5; i++) {
			fgggNm = MapUtils.getString(rqstMap, "ad_fggg_nm_" + i);
			
			if(Validate.isEmpty(fgggNm)) {
				continue;
			}
			
			param.put("SN", i);
			param.put("FGGG_NM", fgggNm);
			param.put("FGGG_LEVEL", MapUtils.getString(rqstMap, "ad_fggg_level_" + i));
			param.put("ATHRI_EXPR_NM", MapUtils.getString(rqstMap, "ad_athri_expr_nm_" + i));
			param.put("ACQS_SCORE", MapUtils.getString(rqstMap, "ad_acqs_score_" + i));
			param.put("PSCORE", MapUtils.getString(rqstMap, "ad_acqs_pscore_" + i));
			
			acqsDe = MapUtils.getString(rqstMap, "ad_acqs_de_" + i);			
			param.put("ACQS_DE", StringUtil.replace(acqsDe, "-", ""));
		
			applyMapper.insertCaFggg(param);
		}		
	}
	
	/**
	 * 해외연수경험 등록
	 * @param rqstMap
	 * @throws Exception
	 */
	public void insertCaSdytrn(Map<?, ?> rqstMap, String empmnNo, String userNo) throws Exception {
		Map<String,Object> param = new HashMap<String,Object>();		
		
		param.put("EMPMN_MANAGE_NO", empmnNo);
		param.put("USER_NO", userNo);
		
		String sdytrnNation = "";
		String beginDe = "";
		String endDe = "";
		
		for(int i=1; i<=5; i++) {
			sdytrnNation = MapUtils.getString(rqstMap, "ad_sdytrn_nation_" + i);
			
			if(Validate.isEmpty(sdytrnNation)) {
				continue;
			}
			
			param.put("SN", i);
			param.put("SDYTRN_NATION", sdytrnNation);
			
			beginDe = MapUtils.getString(rqstMap, "ad_sdytrn_begin_de_" + i);
			endDe = MapUtils.getString(rqstMap, "ad_sdytrn_end_de_" + i);
			
			param.put("SDYTRN_BEGIN_DE", StringUtil.replace(beginDe, "-", ""));
			param.put("SDYTRN_END_DE", StringUtil.replace(endDe, "-", ""));
			param.put("SDYTRN_CN", MapUtils.getString(rqstMap, "ad_sdytrn_cn_" + i));
			param.put("EDC_CN", MapUtils.getString(rqstMap, "ad_edc_cn_" + i));			
		
			applyMapper.insertCaSdytrn(param);
		}
		
	}
	
	/**
	 * 경력사항 등록
	 * @param rqstMap
	 * @throws Exception
	 */
	public void insertCaCareer(Map<?, ?> rqstMap, String empmnNo, String userNo) throws Exception {
		Map<String,Object> param = new HashMap<String,Object>();		
		
		param.put("EMPMN_MANAGE_NO", empmnNo);
		param.put("USER_NO", userNo);
		
		String wrcNm = "";
		String beginDe = "";
		String endDe = "";
		
		for(int i=1; i<=5; i++) {
			wrcNm = MapUtils.getString(rqstMap, "ad_wrc_nm_" + i);
			
			if(Validate.isEmpty(wrcNm)) {
				continue;
			}
			
			param.put("SN", i);
			param.put("WRC_NM", wrcNm);
			
			beginDe = MapUtils.getString(rqstMap, "ad_begin_de_" + i);
			endDe = MapUtils.getString(rqstMap, "ad_end_de_" + i);
			
			param.put("BEGIN_DE", StringUtil.replace(beginDe, "-", ""));
			param.put("END_DE", StringUtil.replace(endDe, "-", ""));
			param.put("OFCPS", MapUtils.getString(rqstMap, "ad_ofcps_" + i));
			param.put("CHRG_JOB", MapUtils.getString(rqstMap, "ad_chrg_job_" + i));
		
			applyMapper.insertCaCareer(param);
		}
		
	}
	
	/**
	 * 자격사항 등록
	 * @param rqstMap
	 * @throws Exception
	 */
	public void insertCaQualf(Map<?, ?> rqstMap, String empmnNo, String userNo) throws Exception {
		Map<String,Object> param = new HashMap<String,Object>();		
		
		param.put("EMPMN_MANAGE_NO", empmnNo);
		param.put("USER_NO", userNo);
		
		String qualfNm = "";
		String acqsDe = "";
		
		for(int i=1; i<=5; i++) {
			qualfNm = MapUtils.getString(rqstMap, "ad_qualf_nm_" + i);
			
			if(Validate.isEmpty(qualfNm)) {
				continue;
			}
			
			param.put("SN", i);
			param.put("QUALF_NM", qualfNm);
			param.put("GRAD", MapUtils.getString(rqstMap, "ad_grad_" + i));
			param.put("CRQFC_NO", MapUtils.getString(rqstMap, "ad_crqfc_no_" + i));
			param.put("PBLICTE_INSTT", MapUtils.getString(rqstMap, "ad_qualf_pblicte_instt_" + i));
			
			acqsDe = MapUtils.getString(rqstMap, "ad_qualf_acqs_de_" + i);
			param.put("ACQS_DE", StringUtil.replace(acqsDe, "-", ""));
			
			applyMapper.insertCaQualf(param);
		}						
	}
	
	/**
	 * 수상내역 등록
	 * @param rqstMap
	 * @throws Exception
	 */
	public void insertCaRwrpns(Map<?, ?> rqstMap, String empmnNo, String userNo) throws Exception {
		Map<String,Object> param = new HashMap<String,Object>();		
		
		param.put("EMPMN_MANAGE_NO", empmnNo);
		param.put("USER_NO", userNo);
		
		String aqtcNm = "";
		String occrrncOn = "";
		
		for(int i=1; i<=5; i++) {
			aqtcNm = MapUtils.getString(rqstMap, "ad_aqtc_nm_" + i);
			
			if(Validate.isEmpty(aqtcNm)) {
				continue;
			}
			
			param.put("SN", i);
			param.put("AQTC_NM", aqtcNm);
			param.put("PBLICTE_INSTT", MapUtils.getString(rqstMap, "ad_pblicte_instt_" + i));
			
			occrrncOn = MapUtils.getString(rqstMap, "ad_occrrnc_on_" + i);
			param.put("OCCRRNC_ON", StringUtil.replace(occrrncOn, "-", ""));
			param.put("RM", MapUtils.getString(rqstMap, "ad_rm_" + i));
			
			applyMapper.insertCaRwrpns(param);
		}				
	}
	
	/**
	 * 입사지원 성공 화면
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView successApplyRcept(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		String userNm = SessionUtil.getUserInfo().getUserNm();
		
		mv.addObject("userNm", userNm);
		mv.setViewName("/www/cs/PD_UICSU0074");
		
		return mv;
	}
	
	/**
	 * 입사지원서 불러오기 목록
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView myApplyList(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		List<Map> dataList = new ArrayList<Map>();		
		
		String userNo = SessionUtil.getUserInfo().getUserNo();		
		param.put("USER_NO", userNo);
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		int totalRowCnt = applyMapper.findApplyCount(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		dataList = applyMapper.findApplyList(param);
		
		mv.addObject("pager", pager);
		mv.addObject("applyList", dataList);
		mv.setViewName("/www/cs/PD_UICSU0075");
		return mv;
	}
	
	/**
	 * 첨부파일 삭제
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView deleteAttFile(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		Map<String,Object> dataMap = new HashMap<String,Object>();
		boolean result = false;
		
		String empmnNo = MapUtils.getString(rqstMap, "empmn_manage_no");
		String userNo = SessionUtil.getUserInfo().getUserNo();
		int fileSeq = MapUtils.getIntValue(rqstMap, "file_seq");
		String fileType = MapUtils.getString(rqstMap, "file_type");
		int preSeq = -1;
		
		param.put("EMPMN_MANAGE_NO", empmnNo);
		param.put("USER_NO", userNo);
		
		// 파일순번이 실제 저장된 값과 같은지 비교 후 삭제처리
		dataMap = applyMapper.findCompApplyInfo(param);
		if("photo".equals(fileType)) {
			preSeq = MapUtils.getIntValue(dataMap, "PHOTO_FILE_SN");
			
			if(fileSeq == preSeq) {
				param.put("PHOTO_FILE_NM", null);
				param.put("PHOTO_FILE_SN", null);
				
				//사진 첨부 컬럼 수정
				applyMapper.updateApplyAtchPhoto(param);
				result = true;
			}
			
		}else if("hist".equals(fileType)) {
			preSeq = MapUtils.getIntValue(dataMap, "HIST_FILE_SEQ1");
			
			if(fileSeq == preSeq) {
				param.put("HIST_FILE1", null);
				param.put("HIST_FILE_SEQ1", null);
				
				//포트폴리오 컬럼 수정
				applyMapper.updateAttFileHist(param);
				result = true;
			}
		}
		
		// 파일삭제
		fileDao.removeFile(fileSeq);			
		
		return ResponseUtil.responseJson(mv, result);
	}
	
	/**
	 * 관리자 세션체크
	 * @return
	 */
	public boolean isAdminAuth(UserVO userVo) {
		boolean isAdmin = false;
		
		if(Validate.isEmpty(userVo)) {
			isAdmin = false;
		}else {
			String[] authorGroupCode = userVo.getAuthorGroupCode();
			
			if(	ArrayUtil.contains(authorGroupCode, GlobalConst.AUTH_DIV_ADM) ) {
				isAdmin = true;
			}
		}
		
		return isAdmin;
	}
	
}
