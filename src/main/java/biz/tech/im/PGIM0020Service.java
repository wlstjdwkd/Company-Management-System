package biz.tech.im;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import com.comm.issue.CertIssueService;
import com.comm.issue.CertIssueVo;
import com.comm.page.Pager;
import com.comm.response.ExcelVO;
import com.comm.response.IExcelVO;
import com.infra.util.ResponseUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.im.IssueStatusMngMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 확인서발급관리 > 발급내역
 * 
 * @author KMY
 *
 */
@Service("PGIM0020")
public class PGIM0020Service extends EgovAbstractServiceImpl {
	private Locale locale = Locale.getDefault();
	
	private static final Logger logger = LoggerFactory.getLogger(PGIM0020Service.class);
	
	@Autowired
	IssueStatusMngMapper issueStatusMngMapper;
	
	@Autowired
	CertIssueService certissueService;
	
	private enum ITEMS{ jurirno, entrprs_nm, issu_no }
	
	
	/**
	 * 발급내역 화면
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<? , ?> rqstMap) throws Exception {
		HashMap<String, Object> param = new HashMap<String, Object>();
		ModelAndView mv = new ModelAndView();
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		String reqstSe = MapUtils.getString(rqstMap, "ad_reqst_se");
		boolean reqstSeNullFlag = false;
		if(reqstSe == null || reqstSe.equals(""))
			reqstSeNullFlag = true;
		else
			reqstSeNullFlag = false;
		String[] seCodeR = {"RC1"};
		//String jdgmntReqstYear = MapUtils.getString(rqstMap, "ad_jdgmnt_reqst_year");
		/*confmTargetYear = MapUtils.getString(rqstMap, "ad_confm_target_yy");*/
		boolean ad_confm_target_yy_flag = true;
		String[] confmTargetYear = null;
		System.out.println(MapUtils.getString(rqstMap, "ad_confm_target_yy"));
		if(MapUtils.getString(rqstMap, "ad_confm_target_yy") != null && !MapUtils.getString(rqstMap, "ad_confm_target_yy").equals("")) {
			confmTargetYear = MapUtils.getString(rqstMap, "ad_confm_target_yy").split(",");
			ad_confm_target_yy_flag = false;
		}
		String jdgmntCode = MapUtils.getString(rqstMap, "ad_jdgmnt_code");
		
		/*
		// 조회항목
		String item = MapUtils.getString(rqstMap, "ad_item");
		String itemValue = MapUtils.getString(rqstMap, "ad_item_value");
		*/
		// 조회항목
		String[] item = null;
		if(MapUtils.getString(rqstMap, "ad_item") != null) {
			item = MapUtils.getString(rqstMap, "ad_item").split(",");
		}

		String itemValue = null;
		if(MapUtils.getString(rqstMap, "ad_item_value") != null)
			itemValue= MapUtils.getString(rqstMap, "ad_item_value");
		else
			itemValue = "";
		
		// 접수기간
		String rceptDeAll = MapUtils.getString(rqstMap, "ad_rcept_de_all","Y");
		String rceptDeFrom = MapUtils.getString(rqstMap, "ad_rcept_de_from");
		String rceptDeTo = MapUtils.getString(rqstMap, "ad_rcept_de_to");
		
		// 발급기간
		String issuDeAll = MapUtils.getString(rqstMap, "ad_issu_de_all","Y");
		String issuDeFrom = MapUtils.getString(rqstMap, "ad_issu_de_from");
		String issuDeTo = MapUtils.getString(rqstMap, "ad_issu_de_to");
		
		if(Validate.isNotEmpty(jdgmntCode)) {
			param.put("JDGMNT_CODE", jdgmntCode);
		}
		if(reqstSeNullFlag) {
			//String[] reqstSe2 = {""};
			//param.put("REQST_SE", reqstSe2);	
		}
		else {
			String[] reqstSe2 = MapUtils.getString(rqstMap, "ad_reqst_se").split(",");
			param.put("REQST_SE", reqstSe2);	
		}
		
		param.put("RCEPT_DE_ALL", rceptDeAll);
		param.put("RCEPT_DE_FROM", rceptDeFrom);
		param.put("RCEPT_DE_TO", rceptDeTo);
		
		param.put("ISSU_DE_ALL", issuDeAll);
		param.put("ISSU_DE_FROM", issuDeFrom);
		param.put("ISSU_DE_TO", issuDeTo);
		
		param.put("SE_CODE_R", seCodeR);
		
		/*if(Validate.isNotEmpty(item)) {
			ITEMS itemEnum = ITEMS.valueOf(item);
			
			switch(itemEnum) {
			case jurirno:				
				param.put("JURIRNO", itemValue);
				break;
			case entrprs_nm:
				param.put("ENTRPRS_NM", itemValue);
				break;
			case issu_no:
				param.put("ISSU_NO", itemValue);
				break;		
			}
		}*/
		if(MapUtils.getString(rqstMap, "ad_item") != null) {
			for(int i = 0; i < item.length; i++) {
				if(!item[i].contains("jurirno"))
					param.put(item[i].toUpperCase(), itemValue);
				else
					param.put(item[i].toUpperCase(), itemValue.replaceAll("-", ""));
			}
		}
		
		/*if(Validate.isEmpty(jdgmntReqstYear)) {
			Calendar today = Calendar.getInstance();
			String year = String.valueOf(today.get(Calendar.YEAR));
			param.put("JDGMNT_REQST_YEAR", year);
		}else {
			param.put("JDGMNT_REQST_YEAR", jdgmntReqstYear);
		}*/
		
		Calendar today = Calendar.getInstance();
		String year = String.valueOf(today.get(Calendar.YEAR));
		String[] yearArr = {year};
		
		/*
		if(Validate.isEmpty(confmTargetYear)) {
			param.put("CONFM_TARGET_YY", year);
		}else {
			param.put("CONFM_TARGET_YY", confmTargetYear);
		}
		*/
		
		if(Validate.isNull(confmTargetYear) && !ad_confm_target_yy_flag) {			
			param.put("CONFM_TARGET_YY", yearArr);
		} else if(Validate.isNull(confmTargetYear) && ad_confm_target_yy_flag) {
			// null
		} else if(!Validate.isNull(confmTargetYear)){
			param.put("CONFM_TARGET_YY", confmTargetYear);
		}
		//param.put("CONFM_TARGET_YY", confmTargetYear);
		
		mv.addObject("currentYear", year);
		mv.addObject("paramTargetYear", MapUtils.getIntValue(param, "CONFM_TARGET_YY"));
		
		// 총 발급업무관리 글 개수
		int totalRowCnt = issueStatusMngMapper.selectIssueTaskMngTotCnt(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();		
		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		// 발급업무관리 글 조회
		List<Map> issueTaskMng = issueStatusMngMapper.selectIssueTaskMng(param);
		

		// 법인등록번호, 발급일, 유효기간
		String jurirNo, issuDe, validBeginDe, validEndDe;
		for(int i=0; i<issueTaskMng.size(); i++) {
			jurirNo = (String) issueTaskMng.get(i).get("JURIRNO");
			issuDe = (String) issueTaskMng.get(i).get("ISSU_DE");
			validBeginDe = (String) issueTaskMng.get(i).get("VALID_PD_BEGIN_DE");
			validEndDe = (String) issueTaskMng.get(i).get("VALID_PD_END_DE");
			
			Map jurir_No = StringUtil.toJurirnoFormat(jurirNo);
			Map issu_De = StringUtil.toDateFormat(issuDe);
			Map valid_Begin_De = StringUtil.toDateFormat(validBeginDe);
			Map valid_End_De = StringUtil.toDateFormat(validEndDe);
			
			issueTaskMng.get(i).put("jurirNo", jurir_No);
			issueTaskMng.get(i).put("issuDe", issu_De);
			issueTaskMng.get(i).put("validBeginDe", valid_Begin_De);
			issueTaskMng.get(i).put("validEndDe", valid_End_De);
		}
		
		// 데이터 추가		
		mv.addObject("pager", pager);
		mv.addObject("issueTaskMng", issueTaskMng);
		
		mv.setViewName("/admin/im/BD_UIIMA0020");
		return mv;
	}
	
	/**
	 * 엑셀 다운로드
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView excelRsolver(Map<? , ?> rqstMap) throws Exception {
		HashMap<String, Object> param = new HashMap<String, Object>();
		ModelAndView mv = new ModelAndView();
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		String reqstSe = MapUtils.getString(rqstMap, "ad_reqst_se");
		boolean reqstSeNullFlag = false;
		if(reqstSe == null || reqstSe.equals(""))
			reqstSeNullFlag = true;
		else
			reqstSeNullFlag = false;
		String[] seCodeR = {"RC1"};
		//String jdgmntReqstYear = MapUtils.getString(rqstMap, "ad_jdgmnt_reqst_year");
		/*confmTargetYear = MapUtils.getString(rqstMap, "ad_confm_target_yy");*/
		boolean ad_confm_target_yy_flag = true;
		String[] confmTargetYear = null;
		System.out.println(MapUtils.getString(rqstMap, "ad_confm_target_yy"));
		if(MapUtils.getString(rqstMap, "ad_confm_target_yy") != null && !MapUtils.getString(rqstMap, "ad_confm_target_yy").equals("")) {
			confmTargetYear = MapUtils.getString(rqstMap, "ad_confm_target_yy").split(",");
			ad_confm_target_yy_flag = false;
		}
		String jdgmntCode = MapUtils.getString(rqstMap, "ad_jdgmnt_code");
		
		/*
		// 조회항목
		String item = MapUtils.getString(rqstMap, "ad_item");
		String itemValue = MapUtils.getString(rqstMap, "ad_item_value");
		*/
		// 조회항목
		String[] item = null;
		if(MapUtils.getString(rqstMap, "ad_item") != null) {
			item = MapUtils.getString(rqstMap, "ad_item").split(",");
		}

		String itemValue = null;
		if(MapUtils.getString(rqstMap, "ad_item_value") != null)
			itemValue= MapUtils.getString(rqstMap, "ad_item_value");
		else
			itemValue = "";
		
		// 접수기간
		String rceptDeAll = MapUtils.getString(rqstMap, "ad_rcept_de_all","Y");
		String rceptDeFrom = MapUtils.getString(rqstMap, "ad_rcept_de_from");
		String rceptDeTo = MapUtils.getString(rqstMap, "ad_rcept_de_to");
		
		// 발급기간
		String issuDeAll = MapUtils.getString(rqstMap, "ad_issu_de_all","Y");
		String issuDeFrom = MapUtils.getString(rqstMap, "ad_issu_de_from");
		String issuDeTo = MapUtils.getString(rqstMap, "ad_issu_de_to");
		
		if(Validate.isNotEmpty(jdgmntCode)) {
			param.put("JDGMNT_CODE", jdgmntCode);
		}
		if(reqstSeNullFlag) {
			//String[] reqstSe2 = {""};
			//param.put("REQST_SE", reqstSe2);	
		}
		else {
			String[] reqstSe2 = MapUtils.getString(rqstMap, "ad_reqst_se").split(",");
			param.put("REQST_SE", reqstSe2);	
		}
		
		param.put("RCEPT_DE_ALL", rceptDeAll);
		param.put("RCEPT_DE_FROM", rceptDeFrom);
		param.put("RCEPT_DE_TO", rceptDeTo);
		
		param.put("ISSU_DE_ALL", issuDeAll);
		param.put("ISSU_DE_FROM", issuDeFrom);
		param.put("ISSU_DE_TO", issuDeTo);
		
		param.put("SE_CODE_R", seCodeR);
		
		/*if(Validate.isNotEmpty(item)) {
			ITEMS itemEnum = ITEMS.valueOf(item);
			
			switch(itemEnum) {
			case jurirno:				
				param.put("JURIRNO", itemValue);
				break;
			case entrprs_nm:
				param.put("ENTRPRS_NM", itemValue);
				break;
			case issu_no:
				param.put("ISSU_NO", itemValue);
				break;		
			}
		}*/
		if(MapUtils.getString(rqstMap, "ad_item") != null) {
			for(int i = 0; i < item.length; i++) {
				if(!item[i].contains("jurirno"))
					param.put(item[i].toUpperCase(), itemValue);
				else
					param.put(item[i].toUpperCase(), itemValue.replaceAll("-", ""));
			}
		}
		
		/*if(Validate.isEmpty(jdgmntReqstYear)) {
			Calendar today = Calendar.getInstance();
			String year = String.valueOf(today.get(Calendar.YEAR));
			param.put("JDGMNT_REQST_YEAR", year);
		}else {
			param.put("JDGMNT_REQST_YEAR", jdgmntReqstYear);
		}*/
		
		Calendar today = Calendar.getInstance();
		String year = String.valueOf(today.get(Calendar.YEAR));
		String[] yearArr = {year};
		
		/*
		if(Validate.isEmpty(confmTargetYear)) {
			param.put("CONFM_TARGET_YY", year);
		}else {
			param.put("CONFM_TARGET_YY", confmTargetYear);
		}
		*/
		
		if(Validate.isNull(confmTargetYear) && !ad_confm_target_yy_flag) {			
			param.put("CONFM_TARGET_YY", yearArr);
		} else if(Validate.isNull(confmTargetYear) && ad_confm_target_yy_flag) {
			// null
		} else if(!Validate.isNull(confmTargetYear)){
			param.put("CONFM_TARGET_YY", confmTargetYear);
		}
		//param.put("CONFM_TARGET_YY", confmTargetYear);
		
		mv.addObject("currentYear", year);
		mv.addObject("paramTargetYear", MapUtils.getIntValue(param, "CONFM_TARGET_YY"));
		
		// 총 발급업무관리 글 개수
		int totalRowCnt = issueStatusMngMapper.selectIssueTaskMngTotCnt(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).build();
		pager.makePaging();		
		
		param.put("limitFrom", 0);
		param.put("limitTo", totalRowCnt);
		param.put("isExcel", "Y");
		
		// 발급업무관리 글 조회
		List<Map> issueTaskMng = issueStatusMngMapper.selectIssueTaskMngHisExcel(param);
		

		// 법인등록번호, 발급일, 유효기간
		String jurirNo, issuDe, validBeginDe, validEndDe;
		for(int i=0; i<issueTaskMng.size(); i++) {
			jurirNo = (String) issueTaskMng.get(i).get("JURIRNO");
			issuDe = (String) issueTaskMng.get(i).get("ISSU_DE");
			validBeginDe = (String) issueTaskMng.get(i).get("VALID_PD_BEGIN_DE");
			validEndDe = (String) issueTaskMng.get(i).get("VALID_PD_END_DE");
			
			Map jurir_No = StringUtil.toJurirnoFormat(jurirNo);
			Map issu_De = StringUtil.toDateFormat(issuDe);
			Map valid_Begin_De = StringUtil.toDateFormat(validBeginDe);
			Map valid_End_De = StringUtil.toDateFormat(validEndDe);
			
			issueTaskMng.get(i).put("jurirNo", jurir_No.get("first") + "-" + jurir_No.get("last"));
			issueTaskMng.get(i).put("issuDe", issu_De.get("first") + "-" + issu_De.get("middle") + "-" + issu_De.get("last"));
			issueTaskMng.get(i).put("validDe", valid_Begin_De.get("first") + "-" + valid_Begin_De.get("middle") + "-" + valid_Begin_De.get("last") + " ~ " + valid_End_De.get("first") + "-" + valid_End_De.get("middle") + "-" + valid_End_De.get("last"));
		}
		
		mv.addObject("_list", issueTaskMng);
		
		 String[] headers = {
		            "신청구분",
		            "대상연도",
		            "신청연도",
		            "발급번호",
		            "발급일",
		            "유효기간",
		            "판정사유",
		            "신청서",
		            "법인등록번호",
		            "담당자명",
		            "전화번호",
		            "이메일",
		            "업종코드",
		            "부서",
		            "직위"
		        };
		        String[] items = {
		            "REQST_SE_NM",
		            "CONFM_TARGET_YY",
		            "JDGMNT_REQST_YEAR",
		            "ISSU_NO",
		            "issuDe",
		            "validDe",
		            "JDGMNT_CODE_NM",
		            "ENTRPRS_NM",
		            "jurirNo",
		            "CHARGER_NM",
		        	"TELNO",
		        	"EMAIL",
		        	"LCLAS_CD",
		        	"CHARGER_DEPT",
		        	"OFCPS"
		        };

		        mv.addObject("_headers", headers);
		        mv.addObject("_items", items);

        SimpleDateFormat formatter = new SimpleDateFormat ( "yyyyMMddHHmmss", Locale.KOREA );
        Date currentTime = new Date ( );
        String dTime = formatter.format ( currentTime );
        IExcelVO excel = new ExcelVO("발급내역_확인서발급관리_"+dTime);
				
		return ResponseUtil.responseExcel(mv, excel);
	}
	
	/**
	 * 확인서 출력 요청
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView processCertIssuetInfo(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		String issueNo  = MapUtils.getString(rqstMap, "issueNo");
		String confmSe  = MapUtils.getString(rqstMap, "confmSe");
		
		if(Validate.isEmpty(issueNo)) {
			throw processException("errors.required",new String[]{"기업확인서 발급번호"});
		}
		
		Map param = new HashMap();
		param.put("issueNo", issueNo);
		
		CertIssueVo cerissueVo = certissueService.findCertIssueBsisInfo(param);
		cerissueVo.setIssueNo(issueNo);
		
		if(confmSe.equals("A")) {                   // 일반
			mv.setViewName("/cmm/PD_UICMC0006");
		} else {                                    // 특례
			mv.setViewName("/cmm/PD_UICMC0007");
		}
		
		mv.addObject("issueNo", issueNo);
		mv.addObject("confmSe", confmSe);
		mv.addObject("cerissueVo", cerissueVo);
		
		return mv;
	}
}

