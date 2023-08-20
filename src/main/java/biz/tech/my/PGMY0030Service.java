package biz.tech.my;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.comm.response.ExcelVO;
import com.comm.response.IExcelVO;
import com.comm.user.EntUserVO;
import com.comm.user.UserService;
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
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 마이페이지 > 채용관리
 * 
 * @author dongwoo
 *
 */
@Service("PGMY0030")
public class PGMY0030Service extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGMY0030Service.class);

	private Locale locale = Locale.getDefault();
	
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	@Resource(name="empmnMapper")
	private EmpmnMapper empmnDAO;
	
	@Resource(name="applyMapper")
	private ApplyMapper applyMapper;
	
	@Resource
    private FileDAO fileDao;
	
	@Autowired
	UserService userService;
	
	/**
	 * 마이페이지 > 채용관리 (채용정보관리 리스트)
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		List<Map> dataList = new ArrayList<Map>();
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		String empmnNo;
		
		boolean isAdmin = false;
		UserVO userVo = SessionUtil.getUserInfo();
		if(Validate.isEmpty(userVo)) {
			throw processException("fail.common.session");
		}
		
		String[] authorGroupCode = userVo.getAuthorGroupCode();
		
		if(	ArrayUtil.contains(authorGroupCode, GlobalConst.AUTH_DIV_ADM) ) {
			isAdmin = true;
		}
		
		param.put("USER_NO", SessionUtil.getUserInfo().getUserNo());	// 사용자번호
		param.put("ISADMIN", "Y");	// 마감일 지난 항목도 조회
		
		int totalRowCnt = empmnDAO.findEmpmnPblancInfoCount(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		// 채용공고 리스트 조회
		dataList = empmnDAO.findEmpmnPblancInfoList(param);
		
		// 항목관리 데이터를 dataList에 추가한다.
		if(Validate.isNotEmpty(dataList)) {			
			for(Map row : dataList) {
				empmnNo = MapUtils.getString(row, "EMPMN_MANAGE_NO", "");
				param.put("EMPMN_MANAGE_NO", empmnNo);
				param.put("PBLANC_IEM", "33"); // 근무형태
				row.put("item33List", empmnDAO.findEmpmnItem(param));
			}
		}
				
		mv.addObject("isAdmin", isAdmin);
		mv.addObject("pager", pager);
		mv.addObject("dataList", dataList);
		mv.setViewName("/www/my/BD_UIMYU0030");
		return mv;
	}		
	
	/**
	 * 채용정보 상세보기
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView empmnInfoView(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> empParam = new HashMap<String,Object>();
		Map<String,Object> applyParam = new HashMap<String,Object>();
		
		Map<String,Object> dataMap = new HashMap<String,Object>();		
		List<Map> applyList = new ArrayList<Map>();				
		
		String userNo = SessionUtil.getUserInfo().getUserNo();
		String empNo = MapUtils.getString(rqstMap, "ad_empmn_manage_no");
		
		empParam.put("USER_NO", userNo);						// 사용자번호
		empParam.put("EMPMN_MANAGE_NO", empNo);	// 채용관리번호
		
		// 채용공고조회
		dataMap = empmnDAO.findEmpmnPblancInfo(empParam);
		
		if(Validate.isNotEmpty(dataMap)) {
			// 채용공고 항목관리 조회
			dataMap.put("itemList", empmnDAO.findEmpmnItem(empParam));			
		}
				
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		applyParam.put("EMPMN_MANAGE_NO", empNo);
		applyParam.put("RCEPT_AT", "Y");
		int totalRowCnt = applyMapper.findApplyCount(applyParam);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();		
		applyParam.put("limitFrom", pager.getLimitFrom());
		applyParam.put("limitTo", pager.getLimitTo());
		
		applyList = applyMapper.findApplyList(applyParam);
		
		mv.addObject("dataMap", dataMap);
		mv.addObject("applyList", applyList);		
		mv.addObject("pager", pager);
		mv.setViewName("/www/my/BD_UIMYU0031");
		
		return mv;
	}
	
	/**
	 * 입사지원목록 Excel 다운로드
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView excelDownApplyList(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		List<Map> applyList = new ArrayList<Map>();
				
		String empNo = MapUtils.getString(rqstMap, "ad_empmn_manage_no");
		param.put("EMPMN_MANAGE_NO", empNo);
		param.put("RCEPT_AT", "Y");
		param.put("ALL_LIST", "Y");
		
		applyList = applyMapper.findApplyList(param);
		
		mv.addObject("_list", applyList);
		
		String[] headers = {
            "지원자이름",
            "지원제목",
            "지원분야(직종)",
            "경력",
            "입사지원일"            
        };
        String[] items = {
            "NM",
            "APPLY_SJ",
            "APPLY_REALM",
            "CAREER_DIV_NM",
            "RCEPT_DE"
        };

        mv.addObject("_headers", headers);
        mv.addObject("_items", items);

        IExcelVO excel = new ExcelVO("사용자 목록");
				
		return ResponseUtil.responseExcel(mv, excel);
	}
	
	/**
	 * 채용정보관리 (입력/수정)
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView empmnInfoForm(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		Map<String,Object> dataMap = new HashMap<String,Object>();
		
		// 채용관리번호
		String empmnNum = MapUtils.getString(rqstMap, "ad_empmn_manage_no");
		// 입력 타입
		String writeType = MapUtils.getString(rqstMap, "ad_form_type", "INSERT");
		
		// 수정, 복사등록 시
		if(Validate.isNotEmpty(empmnNum) && (writeType.equals("UPDATE") || writeType.equals("COPY"))) {
			param.put("USER_NO", SessionUtil.getUserInfo().getUserNo());
			param.put("EMPMN_MANAGE_NO", empmnNum);
			
			// 채용공고조회
			dataMap = empmnDAO.findEmpmnPblancInfo(param);
			
			if(Validate.isNotEmpty(dataMap)) {
				// 채용공고 항목관리 조회
				dataMap.put("itemList", empmnDAO.findEmpmnItem(param));
				
				param.put("PBLANC_IEM", "33"); // 근무형태
				dataMap.put("iem33", StringUtil.join(empmnDAO.findEmpmnIemValue(param), ","));
				param.put("PBLANC_IEM", "25"); // 경력
				dataMap.put("iem25", StringUtil.join(empmnDAO.findEmpmnIemValue(param), ","));
				param.put("PBLANC_IEM", "52"); // 나이
				dataMap.put("iem52", StringUtil.join(empmnDAO.findEmpmnIemValue(param), ","));
				param.put("PBLANC_IEM", "22"); // 근무지역
				dataMap.put("iem22", StringUtil.join(empmnDAO.findEmpmnIemValue(param), ","));
				param.put("PBLANC_IEM", "31"); // 모집직급
				dataMap.put("iem31", StringUtil.join(empmnDAO.findEmpmnIemValue(param), ","));
				param.put("PBLANC_IEM", "32"); // 모집직책
				dataMap.put("iem32", StringUtil.join(empmnDAO.findEmpmnIemValue(param), ","));				
								
			}
		}
		
		mv.addObject("jssfcLargeList", empmnDAO.selectJssfcLargeList());
		mv.addObject("FORM_TYPE", writeType);
		mv.addObject("dataMap", dataMap);
		mv.setViewName("/www/my/BD_UIMYU0032");
		
		return mv;
	}
	
	/**
	 * 채용공고 등록/수정 액션
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processEmpmnInfo(Map<?, ?> rqstMap) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		Map<String,Object> dataMap = new HashMap<String,Object>();
		Map<String,Object> param = new HashMap<String,Object>();
		Map<String,Object> selParam = new HashMap<String,Object>();
		String pramFix = "ad_";
		String itemFix = "ad_itm_";
		int pramFixLen = pramFix.length();
		
		FileVO fileVO = null;
		int fileSeq = -1;
		
		// 채용관리번호
		String empmnNum = MapUtils.getString(rqstMap, "ad_empmn_manage_no");
		// 입력 타입
		String writeType = MapUtils.getString(rqstMap, "df_formType", "INSERT");
		
		UserVO userVO = SessionUtil.getUserInfo();
		String bizrNo = "";
		
		if(isAdminAuth(userVO)) {
			bizrNo = MapUtils.getString(rqstMap, "ad_bizrno");			
		}else {
			EntUserVO entUserVO = SessionUtil.getEntUserInfo();									
			bizrNo = entUserVO.getBizrno();
		}
		
		/**************************************** 채용공고 parameter 세팅 ***********************************/
		Set<String> keys = (Set<String>) rqstMap.keySet();
		Iterator<String> iter = keys.iterator();
		String key = "";
		String columnNm = "";
		
		// 채용공고 parameter 세팅
		while(iter.hasNext()) {
			key = iter.next();
			
			if(key.indexOf(itemFix) > -1) {
				
			}else if(key.indexOf(pramFix) > -1) {
				columnNm = key.substring(pramFixLen).toUpperCase();
				param.put(columnNm, MapUtils.getObject(rqstMap, key));
			}
		}
		/**************************************** 채용공고 parameter 세팅 ***********************************/
		
		/*
		 * 2015-07-28 수정하여 아래로 이동
		 * 이부분이 parameter 세팅 아래에 있어야 함
		 * 위로 올라가면 key 세팅하면서 BIZRNO를 공백 '' 으로 처리해 버려 에러 발생
		 */
		param.put("USER_NO"	, userVO.getUserNo());				// 사용자번호
		param.put("BIZRNO", bizrNo);							// 사업자등록번호
		
		logger.debug("######################### processEmpmnInfo");
		logger.debug("######################### bizrNo: "+param.get("BIZRNO").toString());
		
		if(Validate.isEmpty(bizrNo)) {
			throw processException(messageSource.getMessage("fail.common.insert", new String[] {"회사소개"}, locale));
		}
		
		//직종명과 코드 분리 처리
		String temp_jssfc = MapUtils.getString(rqstMap, "ad_jssfc");
		String jssfc_code = "";
		String jssfc_nm = "";
		if(temp_jssfc != null) {
			String[] array_jssfc = temp_jssfc.split(",");
			jssfc_code = array_jssfc[0];
			jssfc_nm = array_jssfc[1];
		}
		param.put("JSSFC_CODE", jssfc_code);
		param.put("JSSFC", jssfc_nm);
		
		// 기존 첨부파일 유무 확인
		selParam.put("USER_NO", SessionUtil.getUserInfo().getUserNo());
		selParam.put("EMPMN_MANAGE_NO", empmnNum);
		
		dataMap = empmnDAO.findEmpmnPblancInfo(selParam);
		fileSeq = MapUtils.getInteger(dataMap, "HIST_FILE_SEQ1", -1);
		
		//파일업로드
		List<FileVO> fileList = new ArrayList<FileVO>();		
		MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) MapUtils.getObject(rqstMap, GlobalConst.RQST_MULTIPART);		
    	List<MultipartFile> multiFiles = multiRequest.getFiles("form_file");
    	
    	if(Validate.isNotEmpty(multiFiles)) {
    	
	    	fileList = UploadHelper.upload(multiFiles, "company");
			
	    	//기존 첨부파일 삭제
	    	if(fileSeq != -1) {
	    		fileDao.removeFile(fileSeq);
	    	}
	    	fileSeq = fileDao.saveFile(fileList, fileSeq);
    	}    	
    	
    	//업로드 성공시 DB변경
    	if(fileList.size() > 0 && fileSeq > -1) {
    		fileVO = fileList.get(0);
    		
    		param.put("FILE_SEQ", fileSeq);
    		param.put("FILE_NM", fileVO.getLocalNm());    		
    	}else {
    		param.put("FILE_SEQ", MapUtils.getString(dataMap, "FILE_SEQ"));
    		param.put("FILE_NM", MapUtils.getString(dataMap, "FILE_NM"));
    	}
    			
		if(writeType.equals("UPDATE")) {
			// 채용공고 수정, 항목관리 삭제
			param.put("EMPMN_MANAGE_NO", empmnNum);
			int updateRes = empmnDAO.updateEmpmnPblancInfo(param);
			if(updateRes > 0) {
				empmnDAO.deleteEmpmnItem(param);
			}
		}else {
			// 채용공고 등록
			empmnDAO.insertEmpmnPblancInfo(param);
		}		
		
		// 채용공고항목관리
		String itemStr = MapUtils.getString(rqstMap, "ad_grp_code_json");
		itemStr = itemStr.replaceAll("&quot;", "\"");
		ArrayList<Map> itemList = JsonUtil.fromJson(itemStr, new ArrayList<Object>().getClass());
		
		for(Map itemMap : itemList) {
			param.put("PBLANC_IEM", MapUtils.getString(itemMap, "grpCd"));
			param.put("IEM_VALUE", MapUtils.getString(itemMap, "itmValue"));
			param.put("ATRB1", MapUtils.getString(itemMap, "atrb1"));
			param.put("ATRB2", MapUtils.getString(itemMap, "atrb2"));
			
			empmnDAO.insertEmpmnItem(param);
		}
		
		Map returnObj = new HashMap<String, Object>();
		returnObj.put("result", Boolean.TRUE);
		returnObj.put("EMPMN_MANAGE_NO", MapUtils.getString(param, "EMPMN_MANAGE_NO"));
							
		return ResponseUtil.responseText(mv, JsonUtil.toJson(returnObj));
		//return ResponseUtil.responseJson(mv, Boolean.TRUE, param);
	}
	
	/**
	 * 채용공고 삭제
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView deleteEmpmnInfo(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
					
		param.put("EMPMN_MANAGE_NO"	, MapUtils.getString(rqstMap, "ad_empmn_manage_no"));
		param.put("USER_NO"			, SessionUtil.getUserInfo().getUserNo());
		
		empmnDAO.deleteEmpmnItem(param);
		empmnDAO.deleteEmpmnPblancInfo(param);		
		
		return index(rqstMap);
	}
	
	/**
	 * 회사소개 관리 (입력/수정)
	 * @param rqstMap
	 * @throws Exception
	 */
	public ModelAndView cmpnyIntrcnMngForm(Map<?, ?> rqstMap) throws Exception {	
		
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		Map<String,Object> dataMap = new HashMap<String,Object>();
		
		UserVO userVO = SessionUtil.getUserInfo();
		String defltEntNm = "";		//입력화면에 보여줄 기업명
		String bizrno = "";
		
		if(Validate.isEmpty(userVO)) {
			throw processException("fail.common.session");
		}
						
		String userNo = userVO.getUserNo();
		
		if(isAdminAuth(userVO)) {
			bizrno = MapUtils.getString(rqstMap, "ad_bizrno");
			userNo = MapUtils.getString(rqstMap, "USER_NO");
		}else {
			EntUserVO entUserVO = SessionUtil.getEntUserInfo();
			bizrno = entUserVO.getBizrno();			
			defltEntNm = entUserVO.getEntrprsNm();
		}				
		
		param.put("BIZRNO", bizrno);
		param.put("USER_NO", userNo);
		
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
		
		// 주요지표현황 조회
		param.put("ENTRPRS_USER_NO", userNo);
		List<Map> indexList = empmnDAO.findEmpmnIndexInfo(param);
		List<int[]> labrrDatas = new ArrayList<int[]>();	//근로자수
		List<int[]> selngDatas = new ArrayList<int[]>();	//매출액
		List<int[]> caplDatas = new ArrayList<int[]>();		//자본금
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
		
		mv.addObject("chartr", empmnDAO.selectCmpnyIntrcnChartr(param));
		
		List<Map> layoutList = empmnDAO.findCmpnyIntrcnLayoutList(param);

		mv.addObject("layoutList",layoutList);
		
		mv.addObject("labrrDatas", JsonUtil.toJson(labrrDatas));
		mv.addObject("selngDatas", JsonUtil.toJson(selngDatas));
		mv.addObject("caplDatas", JsonUtil.toJson(caplDatas));
		mv.addObject("assetsDatas", JsonUtil.toJson(assetsDatas));
		
		mv.addObject("dataMap", dataMap);
		mv.addObject("defltEntNm", defltEntNm);
		mv.addObject("BIZRNO", bizrno);
		mv.setViewName("/www/my/PD_UIMYU0033");
		
		// return msg
		mv.addObject("message", MapUtils.getString(rqstMap, "message"));
		return mv;
	}
	
	/**
	 * 회사소개 등록
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView insertCmpnyIntrcn(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		
		UserVO userVO = SessionUtil.getUserInfo();
		String bizrNo = "";
		String user_No = userVO.getUserNo();
		String temp_chartr = MapUtils.getString(rqstMap, "ad_searchChartrVal");
		
		if(isAdminAuth(userVO)) {
			bizrNo = MapUtils.getString(rqstMap, "ad_bizrno");
			user_No = MapUtils.getString(rqstMap, "USER_NO");
			param.put("ad_bizrno", bizrNo);		// 회사소개 수정후 다시 조회를 위해 파라미터값 세팅
		}else {
			EntUserVO entUserVO = SessionUtil.getEntUserInfo();									
			bizrNo = entUserVO.getBizrno();
		}
		
		if(Validate.isEmpty(bizrNo)) {
			mv.addObject("message", messageSource.getMessage("fail.common.insert", new String[] {"회사소개"}, locale));			
			mv.setViewName("/www/my/PD_UIMYU0033");
			return mv;
		}
		
		// 추천기업 여부
		String recomend_entrprs_at = MapUtils.getString(rqstMap, "recomend_entrprs_at");
		if(recomend_entrprs_at != null) {
			param.put("recomend_entrprs_at", "Y");
		}
		else {
			param.put("recomend_entrprs_at", "N");
		}
		
		int type = MapUtils.getIntValue(rqstMap, "ad_layout_ty");
		
		param.put("BIZRNO"			, bizrNo);							// 사업자등록번호
		param.put("USER_NO"			, user_No);							// 사용자번호
		param.put("ENTRPRS_NM"		, MapUtils.getString(rqstMap, "ad_entrprs_nm", ""));// 기업명
		param.put("RPRSNTV_NM"		, MapUtils.getString(rqstMap, "ad_rprsntv_nm", ""));// 대표자명
		param.put("LOGO_FILE_NM"	, MapUtils.getString(rqstMap, "ad_logo_file_nm"));	// 로고파일명
		param.put("LOGO_FILE_SN"	, MapUtils.getString(rqstMap, "ad_logo_file_sn"));	// 로고파일순번
		param.put("LST_AT"			, MapUtils.getString(rqstMap, "ad_lst_at"));		// 상장여부
		param.put("ENTRPRS_STLE"	, MapUtils.getString(rqstMap, "ad_entrprs_stle"));	// 기업형태
		param.put("ENTRPRS_CRTFC"	, MapUtils.getString(rqstMap, "ad_entrprs_crtfc"));	// 기업인증
		param.put("HMPG"			, MapUtils.getString(rqstMap, "ad_hmpg"));			// 홈페이지
		param.put("TELNO"			, MapUtils.getString(rqstMap, "ad_telno"));			// 전화번호
		param.put("FXNUM"			, MapUtils.getString(rqstMap, "ad_fxnum"));			// 팩스번호
		param.put("CHARGER_EMAIL"	, MapUtils.getString(rqstMap, "ad_charger_email"));	// 담당자이메일
		param.put("HEDOFC_ZIP"		, MapUtils.getString(rqstMap, "ad_hedofc_zip"));	// 본사우편번호
		param.put("HEDOFC_ADRES"	, MapUtils.getString(rqstMap, "ad_hedofc_adres"));	// 본사주소
		param.put("ENTRPRS_INTRCN"	, MapUtils.getString(rqstMap, "ad_entrprs_intrcn"));// 기업소개
		param.put("FOND_DE"			, MapUtils.getString(rqstMap, "ad_fond_de"));		// 설립일자
		param.put("LST_DE"			, MapUtils.getString(rqstMap, "ad_lst_de"));		// 상장일자
		param.put("INDUTY_NM"		, MapUtils.getString(rqstMap, "ad_induty_nm"));		// 업종명
		param.put("MAIN_PRODUCT"	, MapUtils.getString(rqstMap, "ad_main_product"));	// 주요생산품
		param.put("DTL_VW_AT"		, MapUtils.getString(rqstMap, "ad_dtl_vw_at"));		// 상세정보보이기여부
		param.put("IND_VW_AT"		, MapUtils.getString(rqstMap, "ad_ind_vw_at"));		// 지표보이기여부
		param.put("ENTRPRS_VW_AT"	, MapUtils.getString(rqstMap, "ad_entrprs_vw_at"));	// 기업소개공개여부
		param.put("LAYOUT_TY", type);																				// 레이아웃 타입 (1, 2)
		
		//기업정보 등록
		int res = empmnDAO.insertCmpnyIntrcnInfo(param);
		
		empmnDAO.deleteCmpnyIntrcnLayout(param);
		
		
		//기업 레이아웃 6개 등록
		int iemCnt = 0;
		String iem = "";
		int snYn = 0;
		for(int i=1; i<7; i++) {
			iemCnt = MapUtils.getIntValue(rqstMap, "ad_sn_" + i);
			param.put("IEM_SN", i);	// 항목순번
			for(int j=0; j < iemCnt; j++) {
				iem = MapUtils.getString(rqstMap, "ad_textSn" + i + "_" + (j+1));
				if(!"".equals(iem) && Validate.isNotNull(iem)) {
					param.put("SN", j+1);
					param.put("TEXT", iem);
					
					snYn = empmnDAO.findCmpnyIntrcnLayoutSn(param);
					
					if(snYn > 0) {
						param.put("SN", (j+1)+1);
						empmnDAO.insertCmpnyIntrcnLayout(param);
					}
					else {
						empmnDAO.insertCmpnyIntrcnLayout(param);
					}
				}
				iem = "";
			}
		}
		
		    		
		// 기업특성
		if(temp_chartr != null) {
			empmnDAO.deleteCmpnyIntrcnChartr(param);
			String[] chartr = temp_chartr.split(",");
		
			for(int i=0; i<chartr.length; i++ ) {
				param.put("CHARTR_CODE", chartr[i]);
				if(chartr[i].equals("1")) {
					param.put("CHARTR_NM", "기업소개");
				}
				if(chartr[i].equals("2")) {
					param.put("CHARTR_NM", "월드클래스300");
				}
				if(chartr[i].equals("3")) {
					param.put("CHARTR_NM", "ATC");
				}
				if(chartr[i].equals("4")) {
					param.put("CHARTR_NM", "코스피");
				}
				if(chartr[i].equals("5")) {
					param.put("CHARTR_NM", "코스닥");
				}
				if(chartr[i].equals("6")) {
					param.put("CHARTR_NM", "입사지원");
				}
				//기업특성 등록
				empmnDAO.insertCmpnyIntrcnChartr(param);
			}
		}
		
		mv.addObject("dataMap", param);
		
		if(res > StringUtil.ZERO) {
			//mv.addObject("message", messageSource.getMessage("success.common.insert", new String[] {"회사소개"}, locale));
			param.put("message", messageSource.getMessage("success.common.insert", new String[] {"회사소개"}, locale));
		}
		
		return cmpnyIntrcnMngForm(param);
	}
	
	/**
	 * 회사소개 수정
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	/*public ModelAndView updateCmpnyIntrcn(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();		
		
		param.put("USER_NO"			, SessionUtil.getUserInfo().getUserNo());			// 사용자번호				
		
		param.put("RPRSNTV_NM"		, MapUtils.getString(rqstMap, "ad_rprsntv_nm", ""));// 대표자명		
		param.put("LST_AT"			, MapUtils.getString(rqstMap, "ad_lst_at"));		// 상장여부
		param.put("ENTRPRS_STLE"	, MapUtils.getString(rqstMap, "ad_entrprs_stle"));	// 기업형태
		param.put("ENTRPRS_CRTFC"	, MapUtils.getString(rqstMap, "ad_entrprs_crtfc"));	// 기업인증
		param.put("HMPG"			, MapUtils.getString(rqstMap, "ad_hmpg"));			// 홈페이지
		param.put("TELNO"			, MapUtils.getString(rqstMap, "ad_telno"));			// 전화번호
		param.put("FXNUM"			, MapUtils.getString(rqstMap, "ad_fxnum"));			// 팩스번호
		param.put("CHARGER_EMAIL"	, MapUtils.getString(rqstMap, "ad_charger_email"));	// 담당자이메일
		param.put("HEDOFC_ZIP"		, MapUtils.getString(rqstMap, "ad_hedofc_zip"));	// 본사우편번호
		param.put("HEDOFC_ADRES"	, MapUtils.getString(rqstMap, "ad_hedofc_adres"));	// 본사주소
		param.put("ENTRPRS_INTRCN"	, MapUtils.getString(rqstMap, "ad_entrprs_intrcn"));// 기업소개
		param.put("FOND_DE"			, MapUtils.getString(rqstMap, "ad_fond_de"));		// 설립일자
		param.put("LST_DE"			, MapUtils.getString(rqstMap, "ad_lst_de"));		// 상장일자
		param.put("INDUTY_NM"		, MapUtils.getString(rqstMap, "ad_induty_nm"));		// 업종명
		param.put("MAIN_PRODUCT"	, MapUtils.getString(rqstMap, "ad_main_product"));	// 주요생산품
		
		mv.addObject("dataMap", param);				
		
		int res = empmnDAO.updateCmpnyIntrcnInfo(param);
		
		if(res == StringUtil.ONE) {
			mv.addObject("message", messageSource.getMessage("success.common.update", new String[] {"회사소개"}, locale));
		}
		
		return cmpnyIntrcnMngForm(param);
	}*/
	
	/**
	 * 회사소개 첨부사진 업로드
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processAtchPhoto(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		Map<String,Object> dataMap = new HashMap<String,Object>();
		FileVO fileVO = null;
		int fileSeq = -1;
		int resultFileSeq = 0;
		boolean dataExst = false;
		
		UserVO userVO = SessionUtil.getUserInfo();
		String bizrNo = "";
		String userNo = userVO.getUserNo();
		
		if(isAdminAuth(userVO)) {
			bizrNo = MapUtils.getString(rqstMap, "ad_bizrno");
			userNo = MapUtils.getString(rqstMap, "USER_NO");
		}else {
			EntUserVO entUserVO = SessionUtil.getEntUserInfo();
			bizrNo = entUserVO.getBizrno();
		}
		
		param.put("USER_NO", userNo);
		param.put("BIZRNO", bizrNo);

		//파일 seq 조회
		dataMap = empmnDAO.findCmpnyIntrcnInfo(param);
		fileSeq = MapUtils.getInteger(dataMap, "LOGO_FILE_SN", -1);
		
		//INSERT, UPDATE 여부 결정
		if(Validate.isNotEmpty(MapUtils.getString(dataMap, "USER_NO"))) {
			dataExst = true;
		}
		
		//파일업로드
		List<FileVO> fileList = new ArrayList<FileVO>();		
		MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) MapUtils.getObject(rqstMap, GlobalConst.RQST_MULTIPART);		
    	List<MultipartFile> multiFiles = multiRequest.getFiles("multipartFile");
    	fileList = UploadHelper.upload(multiFiles, "company");
    	
    	//기존 첨부파일 삭제
    	if(fileSeq != -1) {
    		fileDao.removeFile(fileSeq);
    	}
    	fileSeq = fileDao.saveFile(fileList, fileSeq);
    	
    	//업로드 성공시 DB변경
    	if(fileList.size() > 0 && fileSeq > -1) {
    		fileVO = fileList.get(0);
    		
    		param.put("LOGO_FILE_SN", fileSeq);
    		param.put("LOGO_FILE_NM", fileVO.getLocalNm());
    		
    		if(dataExst) {
    			empmnDAO.updateAtchPhoto(param);
    		}else{
    			empmnDAO.insertAtchPhoto(param);
    		}
    		
    		resultFileSeq = fileVO.getFileSeq();
    	}
				
    	return ResponseUtil.responseText(mv, resultFileSeq);
	}
	
	/**
	 * 채용기업 소개 레이아웃 이미지 업로드
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processLayoutImageUpload(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		Map<String,Object> dataMap = new HashMap<String,Object>();
		FileVO fileVO = null;
		int fileSeq = -1;
		int resultFileSeq = 0;
		boolean dataExst = false;
		
		UserVO userVO = SessionUtil.getUserInfo();
		String bizrNo = "";
		String userNo = userVO.getUserNo();
		String sn = MapUtils.getString(rqstMap, "ad_filesn");							// 디비에 저장될 순번
		String iemsn = MapUtils.getString(rqstMap, "ad_fileiemsn");
		
		if(isAdminAuth(userVO)) {
			bizrNo = MapUtils.getString(rqstMap, "ad_bizrno");
			userNo = MapUtils.getString(rqstMap, "USER_NO");
		}else {
			EntUserVO entUserVO = SessionUtil.getEntUserInfo();
			bizrNo = entUserVO.getBizrno();
		}
		
		param.put("USER_NO", userNo);
		param.put("BIZRNO", bizrNo);
		param.put("SN", sn);
		param.put("IEM_SN", iemsn);
		
		//파일 seq 조회
		dataMap = empmnDAO.findCmpnyIntrcnLayoutImage(param);
		fileSeq = MapUtils.getInteger(dataMap, "IMAGE_SN", -1);
		//INSERT, UPDATE 여부 결정
		if(Validate.isNotEmpty(MapUtils.getString(dataMap, "USER_NO"))) {
			dataExst = true;
		}
		
		//파일업로드
		List<FileVO> fileList = new ArrayList<FileVO>();		
		MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) MapUtils.getObject(rqstMap, GlobalConst.RQST_MULTIPART);		
    	List<MultipartFile> multiFiles = multiRequest.getFiles("ad_imageSn"+iemsn+"_"+sn);
    	fileList = UploadHelper.upload(multiFiles, "company");
    	//기존 첨부파일 삭제
    	if(fileSeq != -1) {
    		fileDao.removeFile(fileSeq);
    	}
    	
    	fileSeq = fileDao.saveFile(fileList, fileSeq);
    	
    	//업로드 성공시 DB변경
    	if(fileList.size() > 0 && fileSeq > -1) {
    		fileVO = fileList.get(0);
    		
    		param.put("IMAGE_SN", fileSeq);
    		param.put("IMAGE_NM", fileVO.getLocalNm());
    		
    		if(dataExst) {
    			empmnDAO.updateCmpnyIntrcnLayoutImage(param);
    		} else {
    			empmnDAO.insertCmpnyIntrcnLayout(param);
    		}
    		
    		resultFileSeq = fileVO.getFileSeq();
    	}
				
    	return ResponseUtil.responseText(mv, resultFileSeq);
	}
	
	
	/**
	 * 회사소개 등록여부 체크
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView checkCmpnyInfoRegAt(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		
		UserVO userVO = SessionUtil.getUserInfo();
		String bizrNo = "";
		
		if(isAdminAuth(userVO)) {
			bizrNo = MapUtils.getString(rqstMap, "ad_bizrno");			
		}else {
			EntUserVO entUserVO = SessionUtil.getEntUserInfo();
			bizrNo = entUserVO.getBizrno();
		}
		
		param.put("USER_NO", userVO.getUserNo());
		param.put("BIZRNO", bizrNo);
		
		if(Validate.isNotEmpty(empmnDAO.findCmpnyIntrcnInfo(param))) {
			return ResponseUtil.responseText(mv, Boolean.TRUE);
		}else {
			return ResponseUtil.responseText(mv, Boolean.FALSE);
		}
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
		int preSeq = -1;
		
		param.put("EMPMN_MANAGE_NO", empmnNo);
		param.put("USER_NO", userNo);
		
		// 파일순번이 실제 저장된 값과 같은지 비교 후 삭제처리
		dataMap = empmnDAO.findEmpmnPblancInfo(param);
		
		preSeq = MapUtils.getIntValue(dataMap, "FILE_SEQ");
		
		if(fileSeq == preSeq) {
			param.put("FILE_NM", null);
			param.put("FILE_SEQ", null);
			
			//사진 첨부 컬럼 수정
			empmnDAO.updateEmpmnPblancFile(param);
			result = true;
		}		
		
		// 파일삭제
		fileDao.removeFile(fileSeq);			
		
		return ResponseUtil.responseJson(mv, result);
	}
	
	/**
	 * 회사소개관리 LOGO 사진파일 삭제
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView updateDelLogoFile(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		boolean result = false;
				
		int fileSeq = MapUtils.getIntValue(rqstMap, "file_seq");
		int sn = MapUtils.getIntValue(rqstMap, "ad_sn");
		int iemsn = MapUtils.getIntValue(rqstMap, "ad_iemsn");
		
		UserVO userVO = SessionUtil.getUserInfo();
		String bizrNo = "";
		String userNo = userVO.getUserNo();
		
		if(isAdminAuth(userVO)) {
			bizrNo = MapUtils.getString(rqstMap, "ad_bizrno");
			userNo = MapUtils.getString(rqstMap, "USER_NO");
		}else {
			EntUserVO entUserVO = SessionUtil.getEntUserInfo();
			bizrNo = entUserVO.getBizrno();
		}
		
		param.put("USER_NO", userNo);
		param.put("BIZRNO", bizrNo);
		
		if(sn < 1) {
			param.put("LOGO_FILE_NM", null);
			param.put("LOGO_FILE_SN", null);	
			empmnDAO.updateAtchPhoto(param);
		}
		else if(sn >= 1){
			param.put("SN", sn);
			param.put("IEM_SN", iemsn);
			empmnDAO.deleteCmpnyIntrcnLayoutImage(param);
		}
		
		// 파일삭제
		fileDao.removeFile(fileSeq);
			
		result = true;
		
		return ResponseUtil.responseText(mv, result);
	}
	
	/**
	 * 채용기업관리목록(관리자)
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView empmnCmpnyMngList(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/www/my/PD_UIMYU0034");
		Map<String,Object> param = new HashMap<String,Object>();
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		UserVO userVo = SessionUtil.getUserInfo();
		if(Validate.isEmpty(userVo)) {
			throw processException("fail.common.session");
		}
		
		param.put("USER_NO", userVo.getUserNo());
		// 기업명 검색파라미터
		param.put("ENTRPRS_NM", MapUtils.getString(rqstMap, "search_word"));
		
		int totalRowCnt = empmnDAO.findMngEntrprsListCnt(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		List<Map> entrprsList = empmnDAO.findMngEntrprsList(param);
		
		mv.addObject("entrprsList", entrprsList);
		mv.addObject("pager", pager);
		
		return mv;
	}
	
	/**
	 * 채용기업관리등록(관리자)
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView insertEmpmnCmpnyMng(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		String rtnMsg = "";
		
		String entrprsNm = MapUtils.getString(rqstMap, "ad_reg_entrprs_nm");		// 기업명
		String bizrno = MapUtils.getString(rqstMap, "ad_reg_bizrno");				// 사업자등록번호
		
		UserVO userVo = SessionUtil.getUserInfo();
		
		if(!isAdminAuth(userVo)) {
			throw processException("errors.author.store");
		}
		
		// 이미 존재하는 사업자등록번호인지 체크후 등록
		param.put("BIZRNO", bizrno);
		if(empmnDAO.findDupleEmpmnCmpny(param) > 0) {
			rtnMsg = messageSource.getMessage("errors.reqst.dupleBizNo", null, locale);
		}else {
			param.put("USER_NO", userVo.getUserNo());
			param.put("ENTRPRS_NM", entrprsNm);
			param.put("DTL_VW_AT", "N");
			int res = empmnDAO.insertEmpmnCmpnyMng(param);
			
			if(res > 0) {
				rtnMsg = messageSource.getMessage("success.common.insert", new String[] {"채용기업"}, locale);
			}else {
				rtnMsg = messageSource.getMessage("fail.common.insert", new String[] {"채용기업"}, locale);
			}
		}
		
		mv = empmnCmpnyMngList(rqstMap);
		mv.addObject("RETURN_MSG", rtnMsg);
		
		return mv;
	}
	
	/**
	 * 기업 사용자등록번호 찾기
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getEntUserList(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();

		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");

		String searchEntrprsNm = MapUtils.getString(rqstMap, "searchEntrprsNm");
		
		param.put("searchEntrprsNm", searchEntrprsNm);
		
		int totalRowCnt = userService.findEntUserListCnt(param);

		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		int pagerNo = pager.getIndexNo();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());

		// 메뉴 조회
		List<Map> list = userService.findEntUserList(param);

		// 데이터 추가
		ModelAndView mv = new ModelAndView();
		mv.addObject("pager", pager);
		mv.addObject("pagerNo", pagerNo);
		mv.addObject("list", list);
		mv.setViewName("/admin/so/PD_UISOA0081");
		return mv;
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
