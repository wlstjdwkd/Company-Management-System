package com.comm.user;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.page.Pager;
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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

@Service("PGCMUSER0100")
public class PGCMUSER0100Service extends EgovAbstractServiceImpl
{
	private static final Logger logger = LoggerFactory.getLogger(PGCMUSER0100Service.class);

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;

	@Autowired
	UserService userService;
	
	/**
	 * 담당자변경신청 리스트 검색
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		param = (Map<String, Object>) rqstMap;
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		int totalRowCnt = userService.selectChangeChargerCnt(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		List<Map> userList = userService.selectChangeCharger(param);
		
		Map numMap = new HashMap();
		String num = null;
		
		for(int i=0; i<userList.size(); i++) {
			if(Validate.isNull(userList.get(i).get("TELNO2"))) {		// 담당자 일반전화 처리
				num="";
			} else {
				numMap = StringUtil.telNumFormat(userList.get(i).get("TELNO2").toString());
				//if(Validate.isNotEmpty(numMap.get("middle"))) {
					num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last");
				//}
			}
			userList.get(i).put("TELNO2", num);
			
			if(Validate.isNull(userList.get(i).get("MBTLNUM"))) {		// 담당자 휴대전화 처리
				num="";
			} else {
				numMap = StringUtil.telNumFormat(userList.get(i).get("MBTLNUM").toString());
				//if(Validate.isNotEmpty(numMap.get("middle"))) {
					num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last");
				//}
			}
			userList.get(i).put("MBTLNUM", num);
		}
		
//		mv.addObject("countMap", countMap);
		mv.addObject("pager", pager);
		mv.addObject("userList", userList);		
		mv.setViewName("/admin/comm/user/BD_UICMUSERA0100");
		
		return mv;
	}
	
	/**
	 * 담당자 변경(체크박스 전체)
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	/*public ModelAndView updateProcessStep(Map<?, ?> rqstMap) throws Exception
	 *  {
		ModelAndView mv = new ModelAndView();
		
		if(rqstMap.get("chk") instanceof String) {
			String rceptNo = MapUtils.getString(rqstMap, "chk");			
			updateChargerInfo(rqstMap);
		}else {
			String[] chks = (String[]) rqstMap.get("chk");			
			for(int i=0;i<chks.length;i++) {
				String rceptNo = chks[i];				
				updateChargerInfo(rqstMap);
			}			
		}
		
		return ResponseUtil.responseText(mv,Boolean.TRUE);
	}*/
	
	/**
	 * 담당자 변경(단일)
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView updateProcessStepOnlyOne(Map<?, ?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		
		/*String[] arraySn = (String[]) rqstMap.get("SN");
		String[] arrayJurirno = (String[]) rqstMap.get("JURIRNO");
		String[] arrayEntNm = (String[]) rqstMap.get("ENTRPRS_NM");
		String[] arrayChgNm = (String[]) rqstMap.get("CHARGER_NM");
		String[] arrayEmail = (String[]) rqstMap.get("EMAIL");
		
		String SN = arraySn[0];
		String JURIRNO = arrayJurirno[0];
		String ENTRPRS_NM = arrayEntNm[0];
		String CHARGER_NM = arrayChgNm[0];
		String EMAIL = arrayEmail[0];*/
		
		String SN = MapUtils.getString(rqstMap, "SN");
		
		Map param = new HashMap();
		param.put("SN", SN);
		
		Map userInfo = userService.selectChangeChargerInfo(param);
		
		String JURIRNO = (String) userInfo.get("JURIRNO");
		String SE = (String) userInfo.get("SE");
		String ENTRPRS_NM = (String) userInfo.get("ENTRPRS_NM");
		String CHARGER_NM = (String) userInfo.get("CHARGER_NM");
		String EMAIL = (String) userInfo.get("EMAIL");
		
		param.put("JURIRNO", JURIRNO);
		param.put("SE", SE);
		param.put("ENTRPRS_NM", ENTRPRS_NM);
		param.put("CHARGER_NM", CHARGER_NM);
		param.put("EMAIL", EMAIL);
		
		int upResult = 0;
		int upAtResult = 0;
		
		logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>SE : " + SE);
		
		String newkey = null;
		Map<String, Object> loginIdInfo = null;
		String loginId = null;
		
		if(SE.equals("1")) {
			// 담당자정보 업데이트
			upResult = updateChargerInfo(rqstMap);
		} else {
			// 기업명 업데이트
			upResult = updateEntrprsNmInfo(rqstMap);
		}
		
		// 담당자변경신청 적용여부 업데이트
		if(upResult == 1) {
			upAtResult = userService.updateApplcAt(param);
		}
		
		if(upResult == 1 && upAtResult == 1) {
			if(SE.equals("1")) {
				// 비밀번호 초기화
				newkey = updateInitializePwd(rqstMap);
				param.put("NEWKEY", newkey);
				
				// 아이디 조회
				loginIdInfo = userService.selectIdUserInfo(param);
				loginId = (String)loginIdInfo.get("LOGIN_ID");
				param.put("LOGIN_ID", loginId);
			}
			
			// 담당자변경 적용 후 담당자에게 이메일 발송
			insertEmail(param, rqstMap);
			
			return ResponseUtil.responseText(mv,Boolean.TRUE);
		}else {
			return ResponseUtil.responseText(mv,Boolean.FALSE);
		}
		
	}
	
	private int updateChargerInfo(Map<?, ?> rqstMap) throws Exception
	{
		/*String[] chks = (String[]) rqstMap.get("SN");
		String SN = chks[0];*/
		
		String SN = MapUtils.getString(rqstMap, "SN");
		
		Map param = new HashMap();
		param.put("SN", SN);
		
		int result = userService.updateChargerInfo(param);
		return result;
	}
	
	private int updateEntrprsNmInfo(Map<?, ?> rqstMap) throws Exception
	{
		String SN = MapUtils.getString(rqstMap, "SN");
		
		Map param = new HashMap();
		param.put("SN", SN);
		
		int result = userService.updateEntrprsNmInfo(param);
		
		return result;
	}
	
	/**
	 * 담당자변경 적용 후 담당자에게 이메일 발송
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView insertEmail(Map mparam, Map<?, ?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		
		String sEntrprsNm = mparam.get("ENTRPRS_NM").toString();	// 담당자 변경신청 기업명
		String userNm = mparam.get("CHARGER_NM").toString();	// 변경신청 담당자
		String userEmail = mparam.get("EMAIL").toString();			// 변경신청 담당자 이메일
		String sSe = mparam.get("SE").toString();           // 구분(1:담당자, 2:기업명)
		String newkey = null; // 초기화 비밀번호
		String loginId = null; // 사용자아이디
		if(sSe.equals("1")) {
			newkey = mparam.get("NEWKEY").toString();
			loginId = mparam.get("LOGIN_ID").toString();
		}
		
		param.put("userNm", userNm);
		param.put("email", userEmail);
		
		int resCnt = 0;
		
		// 변경신청한 담당자에게 메일 발송
		param.put("PRPOS", "U");
		if(sSe.equals("1")) {
			param.put("EMAIL_SJ", "[기업 정보] 담당자 변경요청 안내입니다.");
			param.put("TMPLAT_FILE_COURS", "TMPL_EMAIL_CH_CHARGER_SUCCESS.html");
			param.put("SUBST_INFO7", "userPwd::" + newkey);
			param.put("SUBST_INFO8", "userId::" + loginId);
		} else {
			param.put("EMAIL_SJ", "[기업 정보] 기업명 변경요청 안내입니다.");
			param.put("TMPLAT_FILE_COURS", "TMPL_EMAIL_CH_ENTRPRSNM_SUCCESS.html");
		}
		param.put("TMPLAT_USE_AT", "Y");
		param.put("SNDR_NM", "기업정보");
		param.put("SNDR_EMAIL_ADRES", GlobalConst.MASTER_EMAIL_ADDR);
		param.put("RCVER_NM", userNm);
		param.put("RCVER_EMAIL_ADRES", userEmail);
		param.put("SUBST_INFO3", "ENTPRS_NM::" + sEntrprsNm);
		param.put("SUBST_INFO4", "CHARGER_NM::" + userNm);
		param.put("SUBST_INFO5", "RCVER_EMAIL_ADRES::" + userNm);
		param.put("SUBST_INFO6", "MASTER_EMAIL_ADDR::" + GlobalConst.MASTER_EMAIL_ADDR);
		param.put("SNDNG_STTUS", "R");
		
		resCnt = userService.insertEmail(param);
		
		// 메일발송 성공 시
		if(resCnt == StringUtil.ONE) {
			return ResponseUtil.responseJson(mv, true);
		}
		
		return ResponseUtil.responseJson(mv, false);
	}
	
	/**
	 * 담당자 변경요청 리스트 삭제(체크박스 전체)
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView deleteProcessStep(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		if(rqstMap.get("chk") instanceof String) {
			String snNo = MapUtils.getString(rqstMap, "chk");
			deleteChargerInfo(snNo, rqstMap);
		}else {
			String[] chks = (String[]) rqstMap.get("chk");
			for(int i=0;i<chks.length;i++) {
				String snNo = chks[i];
				deleteChargerInfo(snNo, rqstMap);
			}			
		}
		
		return ResponseUtil.responseText(mv,Boolean.TRUE);
	}
	
	private int deleteChargerInfo(String snNo, Map<?, ?> rqstMap) throws Exception {
		String SN =snNo;
		
		Map param = new HashMap();
		param.put("SN", SN);
		
		int result = userService.deleteChargerInfo(param);
		
		return result;
	}
	
	/**
	 * 사용자 목록 Excel 다운로드
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	/*public ModelAndView excelDownUsrList (Map<?, ?> rqstMap) throws Exception {
		
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
	}*/
	
	/**
	 * 비밀번호 초기화
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	private String updateInitializePwd(Map<?, ?> rqstMap) throws Exception {
		String newkey = null;
		
		Map<String,Object> param = new HashMap<String,Object>();
		
		String SN = MapUtils.getString(rqstMap, "SN");
		param.put("SN", SN);
		Map<String, Object> user = userService.selectPwdInitEntUserInfo(param);
		
		if(Validate.isNotEmpty(user)) {
			// 새로운 비밀번호 생성
            int alplen = 2;
            int numlen = 7;
            newkey = tempKey2(alplen, numlen);
            
            // 새로생성한 비밀번호 암호화 후 업데이트
            byte pszDigest[] = new byte[32];
    		Crypto cry = CryptoFactory.getInstance("SHA256");
    		pszDigest =cry.encryptTobyte(newkey);
			
    		logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> USER_NO : " + user.get("USER_NO"));
    		param.put("USER_NO", user.get("USER_NO"));
    		
    		param.put("PASSWORD", pszDigest);
    		param.put("UPDUSR", SessionUtil.getUserInfo().getUserNo());
    		
    		userService.updateInitializePwd(param);
		}
		
		return newkey;
	}
	
	/**
	 * 임시 비밀번호 생성
	 * EX : AA1234567
	 * 8자리로 구성하며 앞 두자리는 임의의 영문자 나머지는 숫자로 구성
	 */
	private String tempKey2(int alplen, int numlen) {
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
