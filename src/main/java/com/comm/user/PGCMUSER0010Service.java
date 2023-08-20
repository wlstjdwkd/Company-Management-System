package com.comm.user;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.comm.response.ExcelVO;
import com.comm.response.IExcelVO;
import com.comm.user.AllUserVO;
import com.comm.user.EntUserVO;
import com.comm.user.UserService;
import com.infra.system.GlobalConst;
import com.infra.util.RandomNumber;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;
import com.infra.util.crypto.Crypto;
import com.infra.util.crypto.CryptoFactory;

import org.apache.commons.collections.MapUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.joda.time.LocalDate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

@Service("PGCMUSER0010")
public class PGCMUSER0010Service extends EgovAbstractServiceImpl
{
	private static final Logger logger = LoggerFactory.getLogger(PGCMUSER0010Service.class);
	private Locale locale = Locale.getDefault();
	
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;

	@Autowired
	UserService userService;
	
	/**
	 * 회원관리 회원 리스트 검색
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		param = (Map<String, Object>) rqstMap;
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		/*
		 * String searchStartDt = MapUtils.getString(rqstMap, "ad_rgsde_start_dt");
		 * String searchEndtDt = MapUtils.getString(rqstMap, "ad_rgsde_end_dt");
		 * 
		 * if(Validate.isNotEmpty(searchStartDt)) { searchStartDt += "000000";
		 * param.put("START_DT", searchStartDt); } if(Validate.isNotEmpty(searchEndtDt))
		 * { searchEndtDt += "235959"; param.put("END_DT", searchEndtDt); }
		 * 
		 * String initSearchYn = MapUtils.getString(rqstMap, "init_search_yn");
		 * 
		 * int totalRowCnt = 0; if(Validate.isNotEmpty(initSearchYn)) { totalRowCnt =
		 * userService.findAllUserCnt(param); }
		 */
		
		int totalRowCnt = 0;
		totalRowCnt = userService.findAllUserCnt(param);
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
				
		/*
		 * // 각 분류별 회원 카운트 List<Map> cntByType = userService.findUserCntByType();
		 * List<Map> cntByAuth = userService.findUserCntByauth();
		 * 
		 * Map<String, Object> countMap = new HashMap<String, Object>();
		 * countMap.put("ALL", userService.findAllUserCnt(new HashMap<String,
		 * Object>()));
		 * 
		 * String tmpStr = ""; for(Map map : cntByType) { tmpStr =
		 * MapUtils.getString(map, "EMPLYR_TY", "");
		 * if(tmpStr.equals(GlobalConst.EMPLYR_TY_GN)) {
		 * countMap.put(GlobalConst.EMPLYR_TY_GN, MapUtils.getString(map, "CNT")); }else
		 * if(tmpStr.equals(GlobalConst.EMPLYR_TY_EP)) {
		 * countMap.put(GlobalConst.EMPLYR_TY_EP, MapUtils.getString(map, "CNT")); }else
		 * if(tmpStr.equals(GlobalConst.EMPLYR_TY_JB)) {
		 * countMap.put(GlobalConst.EMPLYR_TY_JB, MapUtils.getString(map, "CNT")); } }
		 * 
		 * for(Map map : cntByAuth) { tmpStr = MapUtils.getString(map,
		 * "AUTHOR_GROUP_CODE", ""); if(tmpStr.equals(GlobalConst.AUTH_DIV_PUB)) {
		 * countMap.put("PUB", MapUtils.getString(map, "CNT")); }else
		 * if(tmpStr.equals(GlobalConst.AUTH_DIV_ENT)) { countMap.put("ENT",
		 * MapUtils.getString(map, "CNT")); }else
		 * if(tmpStr.equals(GlobalConst.AUTH_DIV_BIZ)) { countMap.put("BIZ",
		 * MapUtils.getString(map, "CNT")); }else
		 * if(tmpStr.equals(GlobalConst.AUTH_DIV_ADM)) { countMap.put("ADM",
		 * MapUtils.getString(map, "CNT")); } }
		 * 
		 * List<AllUserVO> userList = null; if(Validate.isNotEmpty(initSearchYn)) {
		 * userList = userService.findAllUser(param); }
		 */
		List<AllUserVO> userList = null;
		userList = userService.findAllUser(param);
		
		Map numMap = new HashMap();
		String num = null;
		
		if(userList != null) {
		for(int i=0; i<userList.size(); i++) {
			if(Validate.isNull(userList.get(i).getTelno2())) {
				num="";
			} else {
				numMap = StringUtil.telNumFormat(userList.get(i).getTelno2());
				//if(Validate.isNotEmpty(numMap.get("middle"))) {
					num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last");
				//}
			}
			userList.get(i).setTelno2(num);
			
			if(Validate.isNull(userList.get(i).getMbtlnum())) {
				num="";
			} else {
				numMap = StringUtil.telNumFormat(userList.get(i).getMbtlnum());
				//if(Validate.isNotEmpty(numMap.get("middle"))) {
					num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last");
				//}
			}
			userList.get(i).setMbtlnum(num);
		}
		}
		
		//mv.addObject("countMap", countMap);
		mv.addObject("pager", pager);
		mv.addObject("userList", userList);		
		//mv.setViewName("/admin/ms/BD_UIMSA0010");
		mv.setViewName("/admin/comm/user/BD_UICMUSERA0010");
		
		return mv;
	}
	
	/**
	 * 회원관리 회원 삭제
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView deleteUserInfo(Map<?, ?> rqstMap) throws Exception
	{
		Map<String,Object> param = new HashMap<String,Object>();
		
		String dellist = MapUtils.getString(rqstMap, "dellist");
		
		String[] del = dellist.split(",");
		
		param.put("USER_NO_LIST", del);
		
		userService.deleteUserMgrInfo(param);
		
		ModelAndView mv = index(rqstMap);
		return mv;
	}
	
	/**
	 * 회원정보 상세보기
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getUserInfoView(Map<?, ?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		
		String userNo = MapUtils.getString(rqstMap, "ad_user_no");
		
		param.put("USER_NO", userNo);
		param.put("limitFrom", 0);
		param.put("limitTo", 1);
		
		List<AllUserVO> userList = userService.findAllUser(param);
		EntUserVO mngUser = userService.findMngUser(param);
		
		HashMap mngInfo = new HashMap();
		
		if (mngUser != null) {
			// 책임자정보
			mngInfo.put("chargerNm", mngUser.getChargerNm());				// 책임자이름
			mngInfo.put("chargerDept", mngUser.getChargerDept());			// 소속부서
			mngInfo.put("ofcps", mngUser.getOfcps());						// 직위
			mngInfo.put("email", mngUser.getEmail());						// 이메일
			mngInfo.put("emailRecptnAgre", mngUser.getEmailRecptnAgre());	// 이메일수신
			mngInfo.put("smsRecptnAgre", mngUser.getSmsRecptnAgre());		// SMS수신
			mngInfo.put("telNo", StringUtil.telNumFormat(mngUser.getTelno()));		// 책임자 전화번호
			mngInfo.put("mbtlNum", StringUtil.telNumFormat(mngUser.getMbtlnum()));	// 책임자휴대전화번호
			mngInfo.put("updde", mngUser.getUpdde());		// 수정일
		}
		
		param.put("userNo", userNo);
		String[] authGroup = userService.findUserAuthorGroup(param);
		
		Map numMap = new HashMap();
		String num = null;
		
		for(int i=0; i<userList.size(); i++) {
			if(Validate.isNull(userList.get(i).getTelno())) {
				num="";
			}
			else {
				numMap = StringUtil.telNumFormat(userList.get(i).getTelno());
				if(Validate.isNotEmpty(numMap.get("middle"))) {
				num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last");
				}
				userList.get(i).setTelno(num);
			}
			
			if(Validate.isNull(userList.get(i).getTelno2())) {
				num="";
			}
			else {
				num = userList.get(i).getTelno2();		/* 전역변수 - 앞에서 들어간 값이 간섭하지 않도록 초기화 */
				
				numMap = StringUtil.telNumFormat(userList.get(i).getTelno2());
				if(Validate.isNotEmpty(numMap.get("middle"))) {
				num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last");
				}
				userList.get(i).setTelno2(num);
			}
			
			if(Validate.isNull(userList.get(i).getMbtlnum())) {
				num="";
			}
			else {
				numMap = StringUtil.telNumFormat(userList.get(i).getMbtlnum());
				if(Validate.isNotEmpty(numMap.get("middle"))) {
					num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last");
				}
				userList.get(i).setMbtlnum(num);
			}
			
			if("EP".equals(userList.get(i).getEmplyrTy().toUpperCase())) {
				numMap = StringUtil.toBizrnoFormat(userList.get(i).getBizrno());
				num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last");
				userList.get(i).setBizrno(num);
				
				numMap = StringUtil.toJurirnoFormat(userList.get(i).getJurirno());
				num = numMap.get("first") + "-" + numMap.get("last") ;
				userList.get(i).setJurirno(num);
				
				numMap = StringUtil.telNumFormat(userList.get(i).getFxnum());
				if(Validate.isNotEmpty(numMap.get("middle"))) {
					num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last");
				} else {
					num="";
				}
				userList.get(i).setFxnum(num);
			}
		}
		
		mv.addObject("dataMap", userList.get(0));
		mv.addObject("authGrp", authGroup);
		mv.addObject("manager", mngInfo);
		//mv.setViewName("/admin/ms/BD_UIMSA0011");
		mv.setViewName("/admin/comm/user/BD_UICMUSERA0011");
		
		return mv;
	}
	
	/**
	 * 회원권한설정 팝업
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getAuthList(Map<?, ?> rqstMap) throws Exception
	{
		//return new ModelAndView("/admin/ms/PD_UIMSA0012");
		return new ModelAndView("/admin/comm/user/PD_UICMUSERA0012");
	}
	
	/**
	 * 회원권한설정
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processUserAuthGroup(Map<?, ?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		
		String userNoStr = MapUtils.getString(rqstMap, "ad_ta_users");
		String authCdStr = MapUtils.getString(rqstMap, "ad_set_auths");
		
		if(Validate.isEmpty(userNoStr) && Validate.isEmpty(authCdStr)) {
			return ResponseUtil.responseText(mv, Boolean.FALSE);
		}
		
		String[] userNoArr = userNoStr.split(",");
		String[] authCdArr = authCdStr.split(",");
		
		param.put("USER_NO_LIST", userNoArr);		
		
		userService.deleteUserAuthorGroup(param);
		
		for(String userNo : userNoArr) {
			for(String authCd : authCdArr) {
				param.put("USER_NO", userNo);
				param.put("AUTHOR_GROUP_CODE", authCd);
				
				userService.insertUserAuthorGroupInfo(param);
			}
		}
		
		return ResponseUtil.responseText(mv, Boolean.TRUE);
	}
	
	/**
	 * 회원유형선택
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectUserType(Map<?, ?> rqstMap) throws Exception
	{
		//return new ModelAndView("/admin/ms/BD_UIMSA0013");
		return new ModelAndView("/admin/comm/user/BD_UICMUSERA0013");
	}
		
	/**
	 * 회원 등록/수정 폼
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView userInfoWriteForm(Map<?, ?> rqstMap) throws Exception
	{
		
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		Map<String,Object> dataMap = new HashMap<String,Object>();
		HashMap mngInfo = new HashMap();
		
		AllUserVO allUserVO = new AllUserVO();
		
		String userNo = MapUtils.getString(rqstMap, "ad_user_no");		// 사용자 번호
		String formType = MapUtils.getString(rqstMap, "ad_form_type");	// 입력 유형
		String joinType = MapUtils.getString(rqstMap, "ad_join_type");  // 사용자 유형
		
		// 등록/수정 폼 구분
		if(Validate.isEmpty(formType)) {
			formType = "INSERT";
		}
		
		if(formType.equals("UPDATE")) {
			param.put("USER_NO", userNo);
			param.put("limitFrom", 0);
			param.put("limitTo", 1);
			
			List<AllUserVO> userList = userService.findAllUser(param);
			allUserVO = userList.get(0);
			joinType = allUserVO.getEmplyrTy();			
			
			Map<String, String> fmtTelNum = StringUtil.telNumFormat(allUserVO.getTelno());
			Map<String, String> fmtTelNum2 = StringUtil.telNumFormat(allUserVO.getTelno2());		/* 담당자 일반전화번호 */
			Map<String, String> fmtMbtlnum = StringUtil.telNumFormat(allUserVO.getMbtlnum());
			Map<String, String> fmtFxnum = StringUtil.telNumFormat(allUserVO.getFxnum());			
			
			//전화번호
			dataMap.put("TELNO1", MapUtils.getString(fmtTelNum, "first", ""));
			dataMap.put("TELNO2", MapUtils.getString(fmtTelNum, "middle", ""));
			dataMap.put("TELNO3", MapUtils.getString(fmtTelNum, "last", ""));
			//담당자 일반전화번호
			dataMap.put("TELNO2_1", MapUtils.getString(fmtTelNum2, "first", ""));
			dataMap.put("TELNO2_2", MapUtils.getString(fmtTelNum2, "middle", ""));
			dataMap.put("TELNO2_3", MapUtils.getString(fmtTelNum2, "last", ""));
			//휴대폰번호
			dataMap.put("MBTLNUM1", MapUtils.getString(fmtMbtlnum, "first", ""));
			dataMap.put("MBTLNUM2", MapUtils.getString(fmtMbtlnum, "middle", ""));
			dataMap.put("MBTLNUM3", MapUtils.getString(fmtMbtlnum, "last", ""));
			//팩스번호
			dataMap.put("FXNUM1", MapUtils.getString(fmtFxnum, "first", ""));
			dataMap.put("FXNUM2", MapUtils.getString(fmtFxnum, "middle", ""));
			dataMap.put("FXNUM3", MapUtils.getString(fmtFxnum, "last", ""));
			
			//사용자 권한그룹 조회
			param.put("userNo", userNo);
			dataMap.put("authGroup", userService.findUserAuthorGroup(param));			
			
		}else {
			allUserVO.setEmplyrTy(joinType);
		}
		
		EntUserVO mngUser = userService.findMngUser(param);
		
		if (mngUser != null) {
			// 책임자정보
			mngInfo.put("chargerNm", mngUser.getChargerNm());				// 책임자이름
			mngInfo.put("chargerDept", mngUser.getChargerDept());			// 소속부서
			mngInfo.put("ofcps", mngUser.getOfcps());						// 직위
			mngInfo.put("email", mngUser.getEmail());						// 이메일
			mngInfo.put("emailRecptnAgre", mngUser.getEmailRecptnAgre());	// 이메일수신
			mngInfo.put("smsRecptnAgre", mngUser.getSmsRecptnAgre());		// SMS수신
			mngInfo.put("telNo", StringUtil.telNumFormat(mngUser.getTelno()));		// 책임자 전화번호
			mngInfo.put("mbtlNum", StringUtil.telNumFormat(mngUser.getMbtlnum()));		// 책임자휴대전화번호
		}
		
		// 사용자 유형별 view 구분
		if(joinType.equals(GlobalConst.EMPLYR_TY_GN)) {
			//mv.setViewName("/admin/ms/BD_UIMSA0014");
			mv.setViewName("/admin/comm/user/BD_UICMUSERA0014");
		}else if(joinType.equals(GlobalConst.EMPLYR_TY_EP)) {
			//mv.setViewName("/admin/ms/BD_UIMSA0015");
			mv.setViewName("/admin/comm/user/BD_UICMUSERA0015");
		}else if(joinType.equals(GlobalConst.EMPLYR_TY_JB)) {
			//mv.setViewName("/admin/ms/BD_UIMSA0016");
			mv.setViewName("/admin/comm/user/BD_UICMUSERA0016");
		}
				
		mv.addObject("formType", formType);
		mv.addObject("dataVO", allUserVO);
		mv.addObject("dataMap", dataMap);
		mv.addObject("manager", mngInfo);
		
		return mv;
	}
	
	/**
	 * 사용자정보 수정
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView updateUserInfo(Map<?, ?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		Map<String,Object> userInfo = new HashMap<String,Object>();
		Map<String, Object> mngInfo = new HashMap<String, Object>();
		
		String userNo 		= MapUtils.getString(rqstMap, "ad_user_no");		// 사용자번호
		
		String userNm 		= MapUtils.getString(rqstMap, "ad_user_nm","");		// 사용자명
		String phoneNum		= MapUtils.getString(rqstMap, "ad_phone_num","");	// 휴대폰번호
		String userEmail	= MapUtils.getString(rqstMap, "ad_user_email","");	// 이메일
		String rcvEmailYn 	= MapUtils.getString(rqstMap, "ad_rcv_email","");	// 이메일수신동의
		String rcvSmsYn		= MapUtils.getString(rqstMap, "ad_rcv_sms","");		// 문자수신동의
		
		String jurirno      = MapUtils.getString(rqstMap, "ad_jurirno","");		// 법인등록번호
		String chargerDept  = MapUtils.getString(rqstMap, "ad_dept","");		// 담당부서
		String ofcps        = MapUtils.getString(rqstMap, "ad_ofcps","");		// 직위
		String telno        = MapUtils.getString(rqstMap, "ad_tel","");			// 전화번호
		String telno2        = MapUtils.getString(rqstMap, "ad_tel2","");			// 담당자 일반전화번호
		String fxnum        = MapUtils.getString(rqstMap, "ad_fax","");			// 팩스번호
		String bizrno       = MapUtils.getString(rqstMap, "ad_bizrno","");		// 사업자등록번호
		String entrprsNm    = MapUtils.getString(rqstMap, "ad_entrprs_nm","");	// 기업명
		String rprsntvNm    = MapUtils.getString(rqstMap, "ad_rprsntv_nm","");	// 대표자명		
		String hedofcAdres  = MapUtils.getString(rqstMap, "ad_addr","");		// 본사주소
		String hedofcZip    = MapUtils.getString(rqstMap, "ad_zipcod","");		// 본사우편번호
		
		String mngChargerNm    = MapUtils.getString(rqstMap, "ad_manager_user_nm","");		// 담당자이름
		String mngDept    = MapUtils.getString(rqstMap, "ad_manager_dept","");		// 소속부서
		String mngOfcps    = MapUtils.getString(rqstMap, "ad_manager_ofcps","");		// 직위	
		String mngTelNo    = MapUtils.getString(rqstMap, "ad_manager_tel","");			// 전화번호
		String mngPhoneNo    = MapUtils.getString(rqstMap, "ad_manager_phone_num","");	// 휴대전화번호
		String mngEmail    = MapUtils.getString(rqstMap, "ad_manager_user_email","");	// 이메일
		String mngEmailYn    = MapUtils.getString(rqstMap, "ad_manager_rcv_email","");	// 이메일수신동의
		String mngSmsYn    = MapUtils.getString(rqstMap, "ad_manager_rcv_sms","");		// 문자수신동의
		
		String adres        = "";	// 주소
		String zip          = "";	// 우편번호
		String hpe_cd       = "";	// 기업관리코드
		
		String emplyrTy 		= MapUtils.getString(rqstMap, "ad_join_type", "");	// 사용자유형
		Object authorGroupCode	= MapUtils.getObject(rqstMap, "ad_chk_auth", "");	// 사용자권한그룹
		String[] authorGroupCodes = null;
		
		if(Validate.isEmpty(userNo)) {			
			throw processException("fail.common.update",new String[]{"회원정보"});
		}
		
		if (authorGroupCode instanceof String[]) {
			authorGroupCodes = (String[]) authorGroupCode;
		}else {
			authorGroupCodes = new String[] {(String) authorGroupCode};
		}
		
		userInfo.put("USER_NO", userNo);		// 사용자번호
		userInfo.put("EMPLYR_TY",emplyrTy);		// 사용자유형
		
		// 일반사용자
		userInfo.put("NM",userNm);				// 이름		
		
		// 기업사용자		
		userInfo.put("JURIRNO",jurirno);               	// 법인등록번호(PK)   
		userInfo.put("CHARGER_NM",userNm);             	// 담당자명           
		userInfo.put("CHARGER_DEPT",chargerDept);      	// 담당자부서         
		userInfo.put("OFCPS",ofcps);                   	// 직위               
		userInfo.put("TELNO",telno);                   	// 전화번호
		userInfo.put("TELNO2",telno2);                   	// 담당자 일반전화번호
		userInfo.put("FXNUM",fxnum);                   	// 팩스번호           
		userInfo.put("BIZRNO",bizrno);                 	// 사업자등록번호     
		userInfo.put("ENTRPRS_NM",entrprsNm);          	// 기업명             
		userInfo.put("RPRSNTV_NM",rprsntvNm);          	// 대표자명           
		userInfo.put("ADRES",adres);                   	// 주소               
		userInfo.put("ZIP",zip);						// 우편번호           
		userInfo.put("HEDOFC_ADRES",hedofcAdres);       // 본사주소           
		userInfo.put("HEDOFC_ZIP",hedofcZip);           // 본사우편번호       
		userInfo.put("HPE_CD",hpe_cd);                  // 기업관리코드       
		
		// 책임자정보
		mngInfo.put("USER_NO", userNo);							// 사용자번호
		mngInfo.put("UPDUSR", userNo);
		mngInfo.put("JURIRNO", jurirno);						// 법인등록번호
		mngInfo.put("CHARGER_NM", mngChargerNm);				// 책임자이름
		mngInfo.put("CHARGER_DEPT", mngDept);					// 소속부서
		mngInfo.put("OFCPS", mngOfcps);							// 직위
		mngInfo.put("TELNO", mngTelNo);							// 책임자 일반전화번호
		mngInfo.put("TELNO2", "");								
		mngInfo.put("MBTLNUM",mngPhoneNo);						// 휴대폰번호
		mngInfo.put("FXNUM", "");								
		mngInfo.put("EMAIL", mngEmail);							// 이메일
		mngInfo.put("BIZRNO", bizrno);							// 사업자등록번호
		mngInfo.put("ENTRPRS_NM", entrprsNm);					// 기업명
		mngInfo.put("RPRSNTV_NM", rprsntvNm);					// 대표자명
		mngInfo.put("HEDOFC_ADRES", "");						
		mngInfo.put("HEDOFC_ZIP", "");							
		mngInfo.put("EMAIL_RECPTN_AGRE", mngEmailYn);			// 이메일수신
		mngInfo.put("SMS_RECPTN_AGRE", mngSmsYn);				// SMS수신
		
		// 일반사용자, 기업사용자
		userInfo.put("MBTLNUM",phoneNum);				// 휴대폰번호
		userInfo.put("EMAIL",userEmail);				// 이메일
		userInfo.put("EMAIL_RECPTN_AGRE",rcvEmailYn);	// 이메일수신동의
		userInfo.put("SMS_RECPTN_AGRE",rcvSmsYn);		// 문자메시지수신동의
		
		// 기관사용자
		userInfo.put("DEPT_NM",chargerDept);  			// 담당자부서
		userInfo.put("UPDUSR", SessionUtil.getUserInfo().getUserNo());	// 수정자
		
		// 사용자권한그룹
		userInfo.put("AUTHGRPCODES",authorGroupCodes);	// 사용자권한그룹 목록 
		
		HashMap param = new HashMap();
		param.put("USER_NO", userNo);	
		EntUserVO mngUser = userService.findMngUser(param);
		
		if (mngUser == null) {
			param.put("JURIRNO", jurirno);	
			userService.insertMngUserBase(param);
		}
		
		// 사용자 상세보기에 필요한 파라미터
		userService.updateUserMgrInfo(userInfo);
		userService.updateMngUserInfo(mngInfo);
		Map<String,Object> viewParam = new HashMap<String,Object>();
		viewParam.put("ad_user_no", userNo);
		
		mv = getUserInfoView(viewParam);
		mv.addObject("rtnMsg", messageSource.getMessage("success.common.update", new String[] {"회원정보"}, locale));
		
		return mv;
	}
	
	/**
	 * 사용자정보 등록
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView insertUserInfo(Map<?, ?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		Map<String,Object> userInfo = new HashMap<String,Object>();
		
		String userId 		= MapUtils.getString(rqstMap, "ad_user_id","").toLowerCase();
		String password 	= MapUtils.getString(rqstMap, "ad_user_pw","");
		String cPassword 	= MapUtils.getString(rqstMap, "ad_confirm_password","");		
		
		String userNm 		= MapUtils.getString(rqstMap, "ad_user_nm","");		// 사용자명
		String phoneNum		= MapUtils.getString(rqstMap, "ad_phone_num","");	// 휴대폰번호
		String userEmail	= MapUtils.getString(rqstMap, "ad_user_email","");	// 이메일
		String rcvEmailYn 	= MapUtils.getString(rqstMap, "ad_rcv_email","");	// 이메일수신동의
		String rcvSmsYn		= MapUtils.getString(rqstMap, "ad_rcv_sms","");		// 문자수신동의
		
		String jurirno      = MapUtils.getString(rqstMap, "ad_jurirno","");		// 법인등록번호
		String chargerDept  = MapUtils.getString(rqstMap, "ad_dept","");		// 담당부서
		String ofcps        = MapUtils.getString(rqstMap, "ad_ofcps","");		// 직위
		String telno        = MapUtils.getString(rqstMap, "ad_tel","");			// 전화번호
		String telno2        = MapUtils.getString(rqstMap, "ad_tel2","");			// 담당자 일반전화번호
		String fxnum        = MapUtils.getString(rqstMap, "ad_fax","");			// 팩스번호
		String bizrno       = MapUtils.getString(rqstMap, "ad_bizrno","");		// 사업자등록번호
		String entrprsNm    = MapUtils.getString(rqstMap, "ad_entrprs_nm","");	// 기업명
		String rprsntvNm    = MapUtils.getString(rqstMap, "ad_rprsntv_nm","");	// 대표자명		
		String hedofcAdres  = MapUtils.getString(rqstMap, "ad_addr","");		// 본사주소
		String hedofcZip    = MapUtils.getString(rqstMap, "ad_zipcod","");		// 본사우편번호
		
		String adres        = "";	// 주소
		String zip          = "";	// 우편번호
		String hpe_cd       = "";	// 기업관리코드
		
		String emplyrTy 		= MapUtils.getString(rqstMap, "ad_join_type", "");	// 사용자유형
		Object authorGroupCode	= MapUtils.getObject(rqstMap, "ad_chk_auth", "");	// 사용자권한그룹
		String[] authorGroupCodes = null;
		
		if (authorGroupCode instanceof String[]) {
			authorGroupCodes = (String[]) authorGroupCode;
		}else {
			authorGroupCodes = new String[] {(String) authorGroupCode};
		}
		
		// 아이디 유효성 체크
		Map<String, Object> resultMap = validateId(userId);
		if(!MapUtils.getBooleanValue(resultMap,"result",false)) {
			throw processException("fail.common.custom",new String[]{MapUtils.getString(resultMap, "message", "")});
		}
		// 비밀번호 유효성 체크
		resultMap = validatePw(userId, password,cPassword);
		if(!MapUtils.getBooleanValue(resultMap,"result",false)) {
			throw processException("fail.common.custom",new String[]{MapUtils.getString(resultMap, "message", "")});
		}
		// PASSWORD 암호화
		byte pszDigest[] = new byte[32];		
		Crypto cry = CryptoFactory.getInstance("SHA256");
		pszDigest =cry.encryptTobyte(password);
				
		String sttus = GlobalConst.EMPLYR_STTUS_01;	// 회원상태:정상				
				
		// 사용자정보
		userInfo.put("LOGIN_ID",userId);		// 로그인아이디		
		userInfo.put("PASSWORD",pszDigest);		// 비밀번호
		userInfo.put("EMPLYR_TY",emplyrTy);		// 사용자유형
		userInfo.put("STTUS",sttus);			// 상태
		
		// 일반사용자
		userInfo.put("NM",userNm);				// 이름		
		
		// 기업사용자		
		userInfo.put("JURIRNO",jurirno);               	// 법인등록번호(PK)   
		userInfo.put("CHARGER_NM",userNm);             	// 담당자명           
		userInfo.put("CHARGER_DEPT",chargerDept);      	// 담당자부서         
		userInfo.put("OFCPS",ofcps);                   	// 직위               
		userInfo.put("TELNO",telno);                   	// 전화번호
		userInfo.put("TELNO2",telno2);                   	// 담당자 일반전화번호
		userInfo.put("FXNUM",fxnum);                   	// 팩스번호           
		userInfo.put("BIZRNO",bizrno);                 	// 사업자등록번호     
		userInfo.put("ENTRPRS_NM",entrprsNm);          	// 기업명             
		userInfo.put("RPRSNTV_NM",rprsntvNm);          	// 대표자명           
		userInfo.put("ADRES",adres);                   	// 주소               
		userInfo.put("ZIP",zip);						// 우편번호           
		userInfo.put("HEDOFC_ADRES",hedofcAdres);       // 본사주소           
		userInfo.put("HEDOFC_ZIP",hedofcZip);           // 본사우편번호       
		userInfo.put("HPE_CD",hpe_cd);                  // 기업관리코드       
		
		// 일반사용자, 기업사용자
		userInfo.put("MBTLNUM",phoneNum);				// 휴대폰번호
		userInfo.put("EMAIL",userEmail);				// 이메일
		userInfo.put("EMAIL_RECPTN_AGRE",rcvEmailYn);	// 이메일수신동의
		userInfo.put("SMS_RECPTN_AGRE",rcvSmsYn);		// 문자메시지수신동의
		
		// 기관사용자
		userInfo.put("DEPT_NM",chargerDept);      							// 담당자부서
		userInfo.put("REGISTER", SessionUtil.getUserInfo().getUserNo());	// 등록자
		
		// 사용자권한그룹
		userInfo.put("AUTHGRPCODES",authorGroupCodes);	// 사용자권한그룹 목록 
		
		// 사용자 상세보기에 필요한 파라미터
		String userNo = userService.insertUserMgrInfo(userInfo);
		Map<String,Object> viewParam = new HashMap<String,Object>();
		viewParam.put("ad_user_no", userNo);
		
		mv = getUserInfoView(viewParam);
		mv.addObject("rtnMsg", messageSource.getMessage("success.common.insert", new String[] {"회원정보"}, locale));
		
		return mv;
	}
	
	/**
	 * 비밀번호 초기화
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView updateInitializePwd (Map<?, ?> rqstMap) throws Exception
	{
		
		boolean result = Boolean.FALSE;
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();		
		String userNo = MapUtils.getString(rqstMap, "ad_user_no");		
		
		param.put("USER_NO", userNo);
		param.put("limitFrom", 0);
		param.put("limitTo", 1);
		
		List<AllUserVO> user = userService.findAllUser(param);
		
		if(Validate.isNotEmpty(user)) {
			//새로운 비밀번호 생성
            int alplen = 2;
            int numlen = 7;
            String newkey = tempKey2(alplen, numlen);
            
            //새로생성한 비밀번호 암호화 후 업데이트
            byte pszDigest[] = new byte[32];		
    		Crypto cry = CryptoFactory.getInstance("SHA256");
    		pszDigest =cry.encryptTobyte(newkey);
			
    		param.put("PASSWORD", pszDigest);
    		param.put("UPDUSR", SessionUtil.getUserInfo().getUserNo());
    		
    		int resCnt = userService.updateInitializePwd(param);
    		
    		if(resCnt == StringUtil.ONE) {
    			//TODO email 발송 추가해야 할 부분
    			String userNm = MapUtils.getString(rqstMap, "ad_userNm");			// 이름
    			String mbtlNum = user.get(0).getMbtlnum()	;		// 휴대전화번호
    			String email = user.get(0).getEmail();			// 이메일
    			
    			// 이메일 발송
    			HashMap emailParam = new HashMap();
    			emailParam.put("PRPOS", "T");
    			emailParam.put("EMAIL_SJ", "[기업 정보] 임시비밀번호안내입니다.");
    			emailParam.put("TMPLAT_FILE_COURS", "TMPL_EMAIL_USERPWD.html");
    			emailParam.put("TMPLAT_USE_AT", "Y");
    			emailParam.put("SNDR_NM", "기업정보");
    			emailParam.put("SNDR_EMAIL_ADRES", GlobalConst.MASTER_EMAIL_ADDR);
    			emailParam.put("RCVER_NM", userNm);
    			emailParam.put("RCVER_EMAIL_ADRES", email);
    			emailParam.put("SUBST_INFO1", "userPwd::" + newkey);
    			emailParam.put("SUBST_INFO8", "MASTER_EMAIL_ADDR::" + GlobalConst.MASTER_EMAIL_ADDR);
    			emailParam.put("SNDNG_STTUS", "R");
    			
    			userService.insertEmail(emailParam);
    			
    			// SMS 발송
    			HashMap smsParam = new HashMap();
    			smsParam.put("MT_REFKEY", userNo);
    			smsParam.put("CONTENT", "회원님의 임시비밀번호는 " + newkey + "입니다.");
    			smsParam.put("CALLBACK", GlobalConst.CSTMR_PHONE_NUM);
    			smsParam.put("RECIPIENT_NUM", mbtlNum);
    			smsParam.put("SERVICE_TYPE", 0);
    			
    			userService.insertSms(smsParam);
    			
    			result = Boolean.TRUE;
    		}			
		}
		
		return ResponseUtil.responseJson(mv, result, param);
	}
	
	public ModelAndView updateInitializePwd2(Map<?,?> rqstMap) throws RuntimeException, Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<>();

		String newPwd = MapUtils.getString(rqstMap, "init_pwd");

		try {
			//새로생성한 비밀번호 암호화 후 업데이트
	        byte pszDigest[] = new byte[32];
			Crypto cry = CryptoFactory.getInstance("SHA256");
			pszDigest =cry.encryptTobyte(newPwd);

			// 오늘 날짜
			Integer nowYear = LocalDate.now().getYear();
			Integer nowMonth = LocalDate.now().getMonthOfYear();
			Integer nowDay = LocalDate.now().getDayOfMonth();
			nowDay += 3;

			// 월, 일 변환
			String nowMonthString;
			if(nowMonth < 10) nowMonthString = "0" + nowMonth;
			else nowMonthString = nowMonth.toString();

			String nowDayString;
			if(nowDay < 10) nowDayString = "0" + nowDay;
			else nowDayString = nowDay.toString();

			// 패스워드 초기화
			param.put("PASSWORD", pszDigest);
			param.put("USER_NO", MapUtils.getString(rqstMap, "ad_user_no"));
			param.put("UPDUSR", SessionUtil.getUserInfo().getUserNo());
			param.put("passwordValidDe", "" + nowYear + nowMonthString + nowDayString);
			userService.updateInitializePwd(param);
		} catch(IOException e) {
			logger.error("", e);
			return ResponseUtil.responseText(mv, false);
		} catch(Exception e) {
			logger.error("", e);
			return ResponseUtil.responseText(mv, false);
		}
		return ResponseUtil.responseText(mv, true);
	}
	
	/**
	 * 사용자 목록 Excel 다운로드
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView excelDownUsrList (Map<?, ?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		param = (Map<String, Object>) rqstMap;
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		String searchStartDt = MapUtils.getString(rqstMap, "ad_rgsde_start_dt");
		String searchEndtDt = MapUtils.getString(rqstMap, "ad_rgsde_end_dt");
		
		if(Validate.isNotEmpty(searchStartDt)) {
			searchStartDt += "000000";
			param.put("START_DT", searchStartDt);
		}
		if(Validate.isNotEmpty(searchEndtDt)) {
			searchEndtDt += "235959";
			param.put("END_DT", searchEndtDt);
		}
		
		int totalRowCnt = userService.findAllUserCnt(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(1).totalRowCount(totalRowCnt).rowSize(totalRowCnt).build();
		pager.makePaging();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		ObjectMapper mapper = new ObjectMapper();		
		
		// Excel 용 Map 생성
		List<Map> userList = mapper.convertValue(userService.findAllUser(param), new TypeReference<List<Map>>() {});
		String userType = "";
		for(Map refMap : userList) {
			userType = MapUtils.getString(refMap, "emplyrTy", "");
			if(userType.equals(GlobalConst.EMPLYR_TY_GN)) {
				refMap.put("userType", "일반회원");
			}else if(userType.equals(GlobalConst.EMPLYR_TY_EP)) {
				refMap.put("userType", "기업회원");
			}else if(userType.equals(GlobalConst.EMPLYR_TY_JB)) {
				refMap.put("userType", "기관회원");
			}
		}
		
		mv.addObject("_list", userList);
		
		String[] headers = {
			"로그인ID",
            "회원분류",
            "기업명",
            "회원이름",
            "직위",
            "전화번호",
            "휴대전화번호",
            "이메일",
            "가입일"    
        };
        String[] items = {
        	"loginId",
            "userType",
            "entrprsNm",
            "userNm",
            "ofcps",
            "telno",
            "mbtlnum",
            "email",
            "rgsde"
        };

        mv.addObject("_headers", headers);
        mv.addObject("_items", items);

        IExcelVO excel = new ExcelVO("사용자 목록");
				
		return ResponseUtil.responseExcel(mv, excel);
	}
	
	/**
	 * 아이디 유효성 확인
	 * @param String 아이디
	 * @return Map 아이디 유효채크 결과
	 * @throws Exception
	 */
	private Map<String,Object> validateId(String userId)
	{
		// 알파벳 또는 숫자
		String alphanumeric = "^\\w+$";
		// 첫문자는 알파벳
		String firstAlpha	= "^[a-z]\\w*";
		// 최소 영문 2글자 이상 포함
		String includeAlphaAtLeast2 = "^[a-z]\\w*[a-z]+\\w*$";
		// 8자 이상 20자 이하
		String len = "^\\w{8,20}$";
		
		Map<String,Object> result = new HashMap<String,Object>();
		result.put("result", true);
		
		String type = "아이디";
		
		if(!matched(alphanumeric,userId)) {
			result.put("result", false);
			result.put("message", messageSource.getMessage("errors.alphanumeric", new String[] {type}, locale));
			return result;
		}		
		if(!matched(firstAlpha,userId)) {
			result.put("result", false);
			result.put("message", messageSource.getMessage("errors.validate05", new String[] {type}, locale));
			return result;
		}
		if(!matched(includeAlphaAtLeast2,userId)) {
			result.put("result", false);
			result.put("message", messageSource.getMessage("errors.validate06", new String[] {type}, locale));
			return result;
		}
		if(!matched(len,userId)) {
			result.put("result", false);
			result.put("message", messageSource.getMessage("errors.validate01", new String[] {type, "8", "20"}, locale));
			return result;
		}
		
		return result;
	}
	
	/**
	 * 패스워드 유효성 확인
	 * @param String 패스워드
	 * @return Map 패스워드 유효채크 결과
	 * @throws Exception
	 */
	private Map<String,Object> validatePw(String userId, String userPw, String confPw)
	{
		// 3자 이상 연속된 숫자(오름,내림)
		String noDigitsIncOrDec = ".*(012|123|234|345|456|567|678|789|987|876|765|654|543|432|321|210).*";
		// 3자 이상 연속된 영문(오름)
		String noAlphaInc = ".*(abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mno|nop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz).*";
		// 3자 이상 연속된 영문(내림)
		String noAlphaDec = ".*(zyx|yxw|xwv|wvu|vut|uts|tsr|srq|rqp|qpo|pon|onm|nml|mlk|lkj|kji|jih|ihg|hgf|gfe|fed|edc|dcb|cba).*";
		
		// 3자 이상 동일한 숫자
		String noIdenticalNum = ".*(0{3,}|1{3,}|2{3,}|3{3,}|4{3,}|5{3,}|6{3,}|7{3,}|8{3,}|9{3,}).*";
		// 3자 이상 동일한 영문
		String noIdenticalWord = ".*(a{3,}|b{3,}|c{3,}|d{3,}|e{3,}|f{3,}|g{3,}|h{3,}|i{3,}|j{3,}|k{3,}|l{3,}|m{3,}|n{3,}|o{3,}|p{3,}|q{3,}|r{3,}|s{3,}|t{3,}|u{3,}|v{3,}|w{3,}|x{3,}|y{3,}|z{3,}).*";			
		
		// 사용할 수 없는 특수 문자
		String noRefusedSpeChar = ".*(&lt|<|&gt|>|\\(|\\)|#|&apos|\\'|\\/|\\|).*";
		// 사용할 수 없는 단어
		String noRefusedWord = ".*(love|happy|qwer|asdf|zxcv|test|hpe).*";

		// 8자 이상 20자 이하
		String len = "^.{8,20}$";
		
		
		Map<String,Object> result = new HashMap<String,Object>();
		result.put("result", true);
		
		String type = "비밀번호";
		
		if(!userPw.equals(confPw)) {
			result.put("result", false);
			result.put("message", messageSource.getMessage("errors.confirmpassword", new String[] {}, locale));
			return result;
		}
		
		if(matched(noDigitsIncOrDec,userPw)||matched(noAlphaInc,userPw)||matched(noAlphaDec,userPw)) {
			result.put("result", false);
			result.put("message", messageSource.getMessage("errors.validate03", new String[] {type, "3"}, locale));
			return result;
		}
		
		if(matched(noIdenticalNum,userPw)||matched(noIdenticalWord,userPw)) {
			result.put("result", false);
			result.put("message", messageSource.getMessage("errors.validate04", new String[] {type, "3"}, locale));
			return result;
		}
		
		if(matched(noRefusedSpeChar,userPw)) {
			result.put("result", false);
			result.put("message", messageSource.getMessage("errors.validate07", new String[] {type, "3"}, locale));
			return result;
		}
		
		if(matched(noRefusedWord,userPw)) {
			result.put("result", false);
			result.put("message", messageSource.getMessage("errors.validate08", new String[] {type, "3"}, locale));
			return result;
		}
		
		// 비밀번호가 8자리 이상이면
		if(userPw.length() < 10) {
			Pattern p = Pattern.compile("([a-zA-Z0-9].*[!,@,$,%,^,&,*,?,_,~])|([!,@,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])");
			Matcher m = p.matcher(userPw);
			
			if(!m.find()) {
				result.put("result", false);
				result.put("message", messageSource.getMessage("errors.validate10", new String[] {type, "비밀번호"}, locale));
				return result;
			}
		}
		// 비밀번호가 10자리 이상이면
		else {
			Pattern p = Pattern.compile("([a-zA-Z0-9])|([!,@,$,%,^,&,*,?,_,~a-zA-Z]]) | ([!,@,$,%,^,&,*,?,_,~0-9])");
			Matcher m = p.matcher(userPw);
			
			if(!m.find()) {
				result.put("result", false);
				result.put("message", messageSource.getMessage("errors.validate10", new String[] {type, "비밀번호"}, locale));
				return result;
			}
		}
		
		int subStrLen = 3;
		int subStrEnd = 0;
		for(int i=0;i<userPw.length();i++){
			subStrEnd = i+subStrLen;			
			if(userPw.length() < subStrEnd){
				break;
			}
			
			String dupleWord = userPw.substring(i,subStrEnd);
			
			int idx = userId.indexOf(dupleWord);
			if(idx > -1){
				result.put("result", false);
				result.put("message", messageSource.getMessage("errors.validate09", new String[] {type, "아이디", "3"}, locale));
				return result;
			}
		}
		
		if(!matched(len,userPw)) {
			result.put("result", false);
			result.put("message", messageSource.getMessage("errors.validate01", new String[] {type, "8", "20"}, locale));
			return result;
		}
		
		return result;		
	}
	
	/**
	 * 정규식
	 * @param regex 정규식
	 * @param str 매칭할 스트링 
	 * @return boolean
	 * @throws Exception
	 */
	private boolean matched(String regex, String matStr)
	{
		return Pattern.matches(regex, matStr);
	}
	
	/**
	 * 임시 비밀번호 생성
	 * EX : AA1234567
	 * 8자리로 구성하며 앞 두자리는 임의의 영문자 나머지는 숫자로 구성
	 */
   private String tempKey2(int alplen, int numlen)
   {
       String alp = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
       String num = "0123456789";
       String newkey = "";
       int max = alplen + numlen;
       int n = 0;

       int a_len = alp.length();
       int n_len = num.length();

       for(int i = 0 ; i < max; i++) {
           if(i < alplen) {
               n = RandomNumber.getInt(a_len);
               newkey = newkey + alp.charAt(n);
           }
           else {
               n = RandomNumber.getInt(n_len);
               newkey = newkey + num.charAt(n);
           }
       }

       return newkey;
   }
	
}
