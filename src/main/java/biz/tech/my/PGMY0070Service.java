package biz.tech.my;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import com.comm.certify.CertifyService;
import com.comm.logio.PGCMLOGIO0040Service;
import com.comm.user.AllUserVO;
import com.comm.user.EntUserVO;
import com.comm.user.UserService;
import com.comm.user.UserVO;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.StringUtil;
import com.infra.util.crypto.Crypto;
import com.infra.util.crypto.CryptoFactory;
import biz.tech.um.PGUM0001Service;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 마이페이지 > 내정보관리
 * 
 * @author KMY
 *
 */
@Service("PGMY0070")
public class PGMY0070Service extends EgovAbstractServiceImpl
{
	private static final Logger logger = LoggerFactory.getLogger(PGMY0070Service.class);
	private Locale locale = Locale.getDefault();
	
	@Resource(name = "certifyService")
	private CertifyService certifyService;
	
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;
	
	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	@Autowired
	UserService userService;
	
	@Autowired
	PGCMLOGIO0040Service pgcmlogiomb0040;
	
	@Autowired
	PGUM0001Service pgum0001;
	
	/**
	 * 내정보관리 화면
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<?,?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		
		// 등록자 정보
		UserVO user = SessionUtil.getUserInfo();						// 사용자정보
		param.put("USER_NO", user.getUserNo());							// 사용자번호
		String emplyrTy = user.getEmplyrTy();							// 사용자구분
		
		// 기업사용자 화면
		if("EP".equals(emplyrTy.toUpperCase())) {	
			// 기업사용자 정보조회
			
			EntUserVO entUser = userService.findEntUser(param);
			EntUserVO mngUser = userService.findMngUser(param);
			
			Map telNo = StringUtil.telNumFormat(entUser.getTelno());		// 전화번호
			Map telNo2 = StringUtil.telNumFormat(entUser.getTelno2());		// 담당자 일반전화번호
			Map fxNum = StringUtil.telNumFormat(entUser.getFxnum());		// 팩스번호
			Map mbtlNum = StringUtil.telNumFormat(entUser.getMbtlnum());	// 휴대전화번호
			
			HashMap entInfo = new HashMap();
			// 로그인정보
			entInfo.put("loginId", user.getLoginId());						// 로그인ID						
			
			// 기업정보
			entInfo.put("entrprsNm", entUser.getEntrprsNm());				// 기업명
			entInfo.put("rprsntvNm", entUser.getRprsntvNm());				// 대표자명
			entInfo.put("jurirNo", entUser.getJurirno());					// 법인등록번호
			entInfo.put("bizrNo", entUser.getBizrno());						// 사업자등록번호
			entInfo.put("hedofcAdres", entUser.getHedofcAdres());			// 주소
			
			// 담당자정보
			entInfo.put("chargerNm", entUser.getChargerNm());				// 담당자이름
			entInfo.put("chargerDept", entUser.getChargerDept());			// 소속부서
			entInfo.put("ofcps", entUser.getOfcps());						// 직위
			entInfo.put("email", entUser.getEmail());						// 이메일
			entInfo.put("emailRecptnAgre", entUser.getEmailRecptnAgre());	// 이메일수신
			entInfo.put("smsRecptnAgre", entUser.getSmsRecptnAgre());		// SMS수신
			
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
				mngInfo.put("mbtlNum", StringUtil.telNumFormat(mngUser.getMbtlnum()));		// 책임자휴대전화번호
				mngInfo.put("updde", mngUser.getUpdde());		// 수정일
			}
			
			mv.addObject("telNo", telNo);
			mv.addObject("telNo2", telNo2);
			mv.addObject("fxNum", fxNum);
			mv.addObject("mbtlNum", mbtlNum);
			mv.addObject("entInfo", entInfo);
			mv.addObject("manager", mngInfo);
			mv.setViewName("/www/my/BD_UIMYU0070");
			
		}
		// 개인사용자 화면
		else if("GN".equals(emplyrTy.toUpperCase())) {
			// 개인사용자 정보조회
			AllUserVO gnrUser = userService.findGnrUser(param);
			
			Map mbtlNum = StringUtil.telNumFormat(gnrUser.getMbtlnum());	// 휴대전화번호
			
			HashMap gnrInfo = new HashMap();
			
			// 로그인정보
			gnrInfo.put("loginId", user.getLoginId());						// 로그인ID						
			
			// 사용자정보
			gnrInfo.put("userNm", gnrUser.getUserNm());						// 사용자이름
			gnrInfo.put("email", gnrUser.getEmail());						// 이메일
			gnrInfo.put("emailRecptnAgre", gnrUser.getEmailRecptnAgre());	// 이메일수신
			gnrInfo.put("smsRecptnAgre", gnrUser.getSmsRecptnAgre());		// SMS수신
			
			mv.addObject("mbtlNum", mbtlNum);
			mv.addObject("gnrInfo", gnrInfo);
			mv.setViewName("/www/my/BD_UIMYU0072");
			
		}
		else {
			throw processException("errors.author.access");

		}
		return mv;
	}
	
	
	/**
	 * 개인/기업사용자 수정화면
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView userUpdateForm(Map<?,?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		
		// 등록자 정보
		UserVO user = SessionUtil.getUserInfo();						// 사용자정보
		param.put("USER_NO", user.getUserNo());							// 사용자번호
		String emplyrTy = user.getEmplyrTy();							// 사용자구분
		
		if("EP".equals(emplyrTy.toUpperCase())) {
			// 기업사용자 정보조회
			EntUserVO entUser = userService.findEntUser(param);
			EntUserVO mngUser = userService.findMngUser(param);
			
			Map telNo = StringUtil.telNumFormat(entUser.getTelno());		// 전화번호
			Map telNo2 = StringUtil.telNumFormat(entUser.getTelno2());		// 전화번호
			Map fxNum = StringUtil.telNumFormat(entUser.getFxnum());		// 팩스번호
			Map mbtlNum = StringUtil.telNumFormat(entUser.getMbtlnum());	// 휴대전화번호
			
			HashMap entInfo = new HashMap();
			
			// 로그인정보
			entInfo.put("loginId", user.getLoginId());						// 로그인ID						
			entInfo.put("userNo", user.getUserNo());						// 유저번호
			
			// 기업정보
			entInfo.put("entrprsNm", entUser.getEntrprsNm());				// 기업명
			entInfo.put("rprsntvNm", entUser.getRprsntvNm());				// 대표자명
			entInfo.put("jurirNo", entUser.getJurirno());					// 법인등록번호
			entInfo.put("bizrNo", entUser.getBizrno());						// 사업자등록번호
			entInfo.put("hedofcAdres", entUser.getHedofcAdres());			// 주소
			entInfo.put("hedofcZip", entUser.getHedofcZip());				// 우편번호
			entInfo.put("bizrnoCertChk", entUser.getBizrnoCertChk());		// 사업자 인증여부
			
			// 담당자정보
			entInfo.put("chargerNm", entUser.getChargerNm());				// 담당자이름
			entInfo.put("chargerDept", entUser.getChargerDept());			// 소속부서
			entInfo.put("ofcps", entUser.getOfcps());						// 직위
			entInfo.put("email", entUser.getEmail());						// 이메일
			entInfo.put("emailRecptnAgre", entUser.getEmailRecptnAgre());	// 이메일수신
			entInfo.put("smsRecptnAgre", entUser.getSmsRecptnAgre());		// SMS수신
			
			HashMap mngInfo = new HashMap();
			// 책임자정보
			if (mngUser != null) {
				mngInfo.put("chargerNm", mngUser.getChargerNm());				// 책임자이름
				mngInfo.put("chargerDept", mngUser.getChargerDept());			// 소속부서
				mngInfo.put("ofcps", mngUser.getOfcps());						// 직위
				mngInfo.put("email", mngUser.getEmail());						// 이메일
				mngInfo.put("emailRecptnAgre", mngUser.getEmailRecptnAgre());	// 이메일수신
				mngInfo.put("smsRecptnAgre", mngUser.getSmsRecptnAgre());		// SMS수신
				mngInfo.put("telNo", StringUtil.telNumFormat(mngUser.getTelno()));		// 책임자 전화번호
				mngInfo.put("mbtlNum", StringUtil.telNumFormat(mngUser.getMbtlnum()));		// 책임자휴대전화번호
			}
			
			mv.addObject("telNo", telNo);
			mv.addObject("telNo2", telNo2);
			mv.addObject("fxNum", fxNum);
			mv.addObject("mbtlNum", mbtlNum);
			mv.addObject("entInfo", entInfo);
			mv.addObject("manager", mngInfo);
			
			mv.setViewName("/www/my/BD_UIMYU0071");
		}
		// 개인사용자 화면
		else if("GN".equals(emplyrTy.toUpperCase())) {
			// 개인사용자 정보조회
			AllUserVO gnrUser = userService.findGnrUser(param);
			
			Map mbtlNum = StringUtil.telNumFormat(gnrUser.getMbtlnum());	// 휴대전화번호
			HashMap gnrInfo = new HashMap();
			
			// 로그인정보
			gnrInfo.put("loginId", user.getLoginId());						// 로그인ID						
			gnrInfo.put("userNo", user.getUserNo());
			// 사용자정보
			gnrInfo.put("userNm", gnrUser.getUserNm());						// 사용자이름
			gnrInfo.put("email", gnrUser.getEmail());						// 이메일
			gnrInfo.put("emailRecptnAgre", gnrUser.getEmailRecptnAgre());	// 이메일수신
			gnrInfo.put("smsRecptnAgre", gnrUser.getSmsRecptnAgre());		// SMS수신
			
			mv.addObject("mbtlNum", mbtlNum);
			mv.addObject("gnrInfo", gnrInfo);
			mv.setViewName("/www/my/BD_UIMYU0073");
		
		}
		return mv;
	}
	
	/**
	 * 개인/기업 사용자 수정
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView updateUserInfo(Map<?,?> rqstMap) throws Exception
	{

		ModelAndView mv = new ModelAndView();
		Map<String, Object> userInfo = new HashMap<String, Object>();
		Map<String, Object> mngInfo = new HashMap<String, Object>();
		
		String password = "";
		String cPassword = "";
		// 등록자 정보
		UserVO user = SessionUtil.getUserInfo();
		userInfo.put("USER_NO", user.getUserNo());							// 사용자번호
		userInfo.put("UPDUSR", user.getUserNo());
		mngInfo.put("USER_NO", user.getUserNo());							// 사용자번호
		mngInfo.put("UPDUSR", user.getUserNo());
		
		String joinType = MapUtils.getString(rqstMap, "ad_join_type","");
		String passwordAt = MapUtils.getString(rqstMap, "ad_passwordAt");

		// 개인, 기업 사용자
		String userId 		= MapUtils.getString(rqstMap, "ad_userId","").toLowerCase();
		if("N".equals(passwordAt.toUpperCase())) {
			password 	= MapUtils.getString(rqstMap, "ad_user_pw","");
			cPassword 	= MapUtils.getString(rqstMap, "ad_user_pw","");	
		}
		else if("Y".equals(passwordAt.toUpperCase())) {
			password 	= MapUtils.getString(rqstMap, "ad_user_new_pw","");
			cPassword 	= MapUtils.getString(rqstMap, "ad_confirm_new_password","");	
		}
		
		String phoneNum		= MapUtils.getString(rqstMap, "ad_phone_num","");		// 휴대폰번호
		String userEmail	= MapUtils.getString(rqstMap, "ad_user_email","");		// 이메일
		String rcvEmailYn 	= MapUtils.getString(rqstMap, "ad_rcv_email","");		// 이메일수신동의
		String rcvSmsYn		= MapUtils.getString(rqstMap, "ad_rcv_sms","");			// 문자수신동의
		
		// 개인 사용자
		String userNm 		= MapUtils.getString(rqstMap, "ad_user_nm","");			// 사용자명

		// 기업 사용자	
		String entrprsNm	= MapUtils.getString(rqstMap, "ad_entrprsNm","");		// 기업명
		String rprsntvNm	= MapUtils.getString(rqstMap, "ad_rprsntv_nm","");		// 대표자명
		String jurirNo		= MapUtils.getString(rqstMap, "ad_jurirNo","");			// 법인등록번호
		String bizrNo		= MapUtils.getString(rqstMap, "ad_bizrNo","");			// 사업자등록번호
		String addr			= MapUtils.getString(rqstMap, "ad_addr","");			// 주소
		String zip			= MapUtils.getString(rqstMap, "ad_zipcod","");			// 우편번호
		String telNo		= MapUtils.getString(rqstMap, "ad_tel","");				// 전화번호
		String telNo2		= MapUtils.getString(rqstMap, "ad_tel2","");			// 담당자 일반전화번호
		String fxNum		= MapUtils.getString(rqstMap, "ad_fax","");				// 팩스번호
		String chargerNm	= MapUtils.getString(rqstMap, "ad_chargerNm","");		// 담당자이름
		String dept			= MapUtils.getString(rqstMap, "ad_dept","");			// 소속부서
		String ofcps		= MapUtils.getString(rqstMap, "ad_ofcps","");			// 직위					
		
		// 기업 사용자	
		String mngChargerNm	= MapUtils.getString(rqstMap, "ad_manager_chargerNm","");		// 담당자이름
		String mngDept		= MapUtils.getString(rqstMap, "ad_manager_dept","");			// 소속부서
		String mngOfcps		= MapUtils.getString(rqstMap, "ad_manager_ofcps","");			// 직위	
		String mngTelNo		= MapUtils.getString(rqstMap, "ad_manager_tel2","");			// 전화번호
		String mngPhoneNo	= MapUtils.getString(rqstMap, "ad_manager_phone_num","");		// 휴대전화번호
		String mngEmail		= MapUtils.getString(rqstMap, "ad_manager_user_email","");		// 이메일
		String mngEmailYn 	= MapUtils.getString(rqstMap, "ad_manager_rcv_email","");		// 이메일수신동의
		String mngSmsYn		= MapUtils.getString(rqstMap, "ad_manager_rcv_sms","");			// 문자수신동의
		
		// 비밀번호 유효성 체크
		if("Y".equals(passwordAt.toUpperCase())) {
			Map<String, Object> resultMap = validatePw(userId, password, cPassword);
			if(!MapUtils.getBooleanValue(resultMap,"result",false)) {
				throw processException("fail.common.custom",new String[]{MapUtils.getString(resultMap, "message", "")});
			}
		}
		
		// PASSWORD 암호화
		byte pszDigest[] = new byte[32];		
		Crypto cry = CryptoFactory.getInstance("SHA256");
		pszDigest =cry.encryptTobyte(password);		
		
		// 사용자정보
		userInfo.put("USER_NO", user.getUserNo());
		
		userInfo.put("LOGIN_ID",userId);		// 로그인아이디		
		userInfo.put("PASSWORD",pszDigest);		// 비밀번호
		
		// 사용자정보
		mngInfo.put("USER_NO", user.getUserNo());
		
		mngInfo.put("LOGIN_ID",userId);		// 로그인아이디		
		mngInfo.put("PASSWORD",pszDigest);		// 비밀번호
		
		// 개인 사용자
		if(joinType.equals("individual")) {
			
			userInfo.put("NM",userNm);						// 이름
			userInfo.put("MBTLNUM",phoneNum);				// 휴대폰번호
			userInfo.put("EMAIL",userEmail);				// 이메일
			userInfo.put("EMAIL_RECPTN_AGRE",rcvEmailYn);	// 이메일수신동의
			userInfo.put("SMS_RECPTN_AGRE",rcvSmsYn);		// 문자메시지수신동의
			
			if("Y".equals(passwordAt.toUpperCase())) {
				userInfo.put("passwordValidDe", "passwordValidDe");
				userService.updateInitializePwd(userInfo);
			}
			userService.updateGnrlUserInfo(userInfo);
			
			mv = index(rqstMap);
			mv.setViewName("/www/my/BD_UIMYU0072");
		}
		
		// 기업 사용자
		if(joinType.equals("enterprise")) {
			
			HashMap param = new HashMap();
			param.put("USER_NO", user.getUserNo());	
			EntUserVO mngUser = userService.findMngUser(param);
			
			if (mngUser == null) {
				param.put("JURIRNO", jurirNo);	
				userService.insertMngUserBase(param);
			}
			
			// 기업정보
			userInfo.put("ENTRPRS_NM", entrprsNm);					// 기업명
			userInfo.put("RPRSNTV_NM", rprsntvNm);					// 대표자명
			userInfo.put("JURIRNO", jurirNo);						// 법인등록번호
			userInfo.put("BIZRNO", bizrNo);							// 사업자등록번호
			userInfo.put("HEDOFC_ADRES", addr);						// 주소
			userInfo.put("HEDOFC_ZIP", zip);						// 우편번호
			userInfo.put("TELNO", telNo);							// 전화번호
			userInfo.put("FXNUM", fxNum);							// 팩스번호
			
			
			// 담당자정보
			userInfo.put("CHARGER_NM", chargerNm);					// 담당자이름
			userInfo.put("CHARGER_DEPT", dept);						// 소속부서
			userInfo.put("OFCPS", ofcps);							// 직위
			userInfo.put("TELNO2", telNo2);							// 담당자 일반전화번호
			userInfo.put("MBTLNUM",phoneNum);						// 휴대폰번호
			userInfo.put("EMAIL", userEmail);						// 이메일
			userInfo.put("EMAIL_RECPTN_AGRE", rcvEmailYn);			// 이메일수신
			userInfo.put("SMS_RECPTN_AGRE", rcvSmsYn);				// SMS수신
			
			// 책임자정보
			mngInfo.put("JURIRNO", jurirNo);						// 법인등록번호
			mngInfo.put("CHARGER_NM", mngChargerNm);				// 책임자이름
			mngInfo.put("CHARGER_DEPT", mngDept);					// 소속부서
			mngInfo.put("OFCPS", mngOfcps);							// 직위
			mngInfo.put("TELNO", mngTelNo);							// 책임자 일반전화번호
			mngInfo.put("TELNO2", "");								
			mngInfo.put("MBTLNUM",mngPhoneNo);						// 휴대폰번호
			mngInfo.put("FXNUM", "");								
			mngInfo.put("EMAIL", mngEmail);							// 이메일
			mngInfo.put("BIZRNO", bizrNo);							// 사업자등록번호
			mngInfo.put("ENTRPRS_NM", entrprsNm);					// 기업명
			mngInfo.put("RPRSNTV_NM", rprsntvNm);					// 대표자명
			mngInfo.put("HEDOFC_ADRES", "");						
			mngInfo.put("HEDOFC_ZIP", "");							
			mngInfo.put("EMAIL_RECPTN_AGRE", mngEmailYn);			// 이메일수신
			mngInfo.put("SMS_RECPTN_AGRE", mngSmsYn);				// SMS수신
			
			if("Y".equals(passwordAt.toUpperCase())) {
				userInfo.put("passwordValidDe", "passwordValidDe");
				userService.updateInitializePwd(userInfo);
			}
			userService.updateEntUserInfo(userInfo);
			userService.updateMngUserInfo(mngInfo);

			logger.debug("######################### rqstMap: "+rqstMap);
			logger.debug("######################### userInfo: "+userInfo);
			logger.debug("######################### mngInfo: "+mngInfo);
			
			mv = index(rqstMap);			
			mv.setViewName("/www/my/BD_UIMYU0070");
		}
		
		return mv;
	}
	
	/**
	 * 일반사용자 휴대폰번호 조회
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView checkDuplGnrUserPhone(Map<?, ?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		Map jsonMap = new HashMap();
		
		String phoneNum = MapUtils.getString(rqstMap, "ad_phone_num");
		String userNo = MapUtils.getString(rqstMap, "ad_user_no");

		if (StringUtils.isEmpty(phoneNum)) {
			jsonMap.put("reason", "invalidVal");
			return ResponseUtil.responseJson(mv, false, jsonMap);
		}

		HashMap<String, Object> param = new HashMap();
		param.put("MBTLNUM", phoneNum);
		param.put("USER_NO", userNo);

		// 휴대전화번호 중복 조회
		int duplPhonNumCnt = userService.findDuplGnrlUserMbtlNum(param);
		if (duplPhonNumCnt>0) {
			jsonMap.put("reason", "duplPhonNum");
			return ResponseUtil.responseJson(mv, false, jsonMap);
		}
		return ResponseUtil.responseJson(mv, true);
	}
	
	/**
	 * 일반사용자 이메일 조회
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView checkDuplGnrUserEmail(Map<?, ?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		Map jsonMap = new HashMap();
		
		String userEmail = MapUtils.getString(rqstMap, "ad_user_email");
		String userNo = MapUtils.getString(rqstMap, "ad_user_no");

		if (StringUtils.isEmpty(userEmail)) {
			jsonMap.put("reason", "invalidVal");
			return ResponseUtil.responseJson(mv, false, jsonMap);
		}

		HashMap<String, Object> param = new HashMap();
		param.put("EMAIL", userEmail);
		param.put("USER_NO", userNo);

		// 이메일 전체 중복 조회
		// int duplEmailCnt = userService.findDuplUserEmail(param);
		
		// 이메일 중복 조회
		int duplEmailCnt = userService.findDuplGnrlEmail(param);
		
		if (duplEmailCnt>0) {
			jsonMap.put("reason", "duplEmail");
			return ResponseUtil.responseJson(mv, false, jsonMap);
		}
		
		return ResponseUtil.responseJson(mv, true);
	}
	
	/**
	 * 일반사용자 휴대폰번호, 이메일 중복 조회
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView checkDuplGnrUserInfo(Map<?, ?> rqstMap) throws Exception
	{
		return pgcmlogiomb0040.checkDuplGnrlUserInfo(rqstMap);
	}
	
	/**
	 * 기업사용자 휴대폰번호 조회
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView checkDuplEntUserPhone(Map<?, ?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		Map jsonMap = new HashMap();
		
		String phoneNum = MapUtils.getString(rqstMap, "ad_phone_num");
		String userNo = MapUtils.getString(rqstMap, "ad_user_no");

		if (StringUtils.isEmpty(phoneNum)) {
			jsonMap.put("reason", "invalidVal");
			return ResponseUtil.responseJson(mv, false, jsonMap);
		}

		HashMap<String, Object> param = new HashMap();
		param.put("MBTLNUM", phoneNum);
		param.put("USER_NO", userNo);

		// 휴대전화번호 중복 조회
		int duplPhonNumCnt = userService.findDuplEntUserMbtlNum(param);
		if (duplPhonNumCnt>0) {
			jsonMap.put("reason", "duplPhonNum");
			return ResponseUtil.responseJson(mv, false, jsonMap);
		}
		
		return ResponseUtil.responseJson(mv, true);
	}
	
	/**
	 * 기업사용자 이메일 조회
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView checkDuplEntUserEmail(Map<?, ?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		Map jsonMap = new HashMap();
		
		String userEmail = MapUtils.getString(rqstMap, "ad_user_email");
		String userNo = MapUtils.getString(rqstMap, "ad_user_no");

		if (StringUtils.isEmpty(userEmail)) {
			jsonMap.put("reason", "invalidVal");
			return ResponseUtil.responseJson(mv, false, jsonMap);
		}

		HashMap<String, Object> param = new HashMap();
		param.put("EMAIL", userEmail);
		param.put("USER_NO", userNo);

		// 이메일 전체 중복 조회
		//int duplEmailCnt = userService.findDuplUserEmail(param);
		
		// 이메일 중복 조회
		int duplEmailCnt = userService.findDuplEntEmail(param);
		
		if (duplEmailCnt>0) {
			jsonMap.put("reason", "duplEmail");
			return ResponseUtil.responseJson(mv, false, jsonMap);
		}
		
		return ResponseUtil.responseJson(mv, true);
	}
	
	/**
	 * 기업사용자 휴대폰번호, 이메일 중복 조회
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView checkDuplEntUserInfo(Map<?, ?> rqstMap) throws Exception
	{
		return pgcmlogiomb0040.checkDuplEntUserInfo(rqstMap);
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
	private boolean matched(String regex, String matStr) {
		return Pattern.matches(regex, matStr);
	}
	
	/**
	 * 사용자정보 삭제화면
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView userWithdrawalForm(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/www/my/BD_UIMYU0074");
		
		return mv;
	}
	
	/**
	 * 사용자정보 상태수정
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView updateUserWithdrawal(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		String sttus = "03";		// 회원탈퇴
		
		// 등록자 정보
		UserVO user = SessionUtil.getUserInfo();
		param.put("USER_NO", user.getUserNo());	
		param.put("STTUS", sttus);
		userService.updateUserWithdrawal(param);
		userService.updateEntrprsUserWithdrawal(param);
		
		// 세션 제거
		SessionUtil.getHttpSession(true).invalidate();
		pgum0001.setAnonymousInfo();

		return pgum0001.index(rqstMap);
	}
	
	/**
	 * 회원정보 공통팝업
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView popUserInfo(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		
		String regId = MapUtils.getString(rqstMap, "ad_regId");
		String userNo = MapUtils.getString(rqstMap, "ad_userNo");		
		
		param.put("LOGIN_ID", regId);
		param.put("USER_NO", userNo);
		
		param.put("limitFrom", 0);
		param.put("limitTo", 1);
		
		List<AllUserVO> userInfo = userService.findAllUser(param);
		
		Map telNum = StringUtil.telNumFormat(userInfo.get(0).getTelno());
		Map mbtlNum = StringUtil.telNumFormat(userInfo.get(0).getMbtlnum());
		
		mv.addObject("telNum", telNum);
		mv.addObject("mbtlNum", mbtlNum);
		mv.addObject("userInfo", userInfo);
		mv.setViewName("/www/my/PD_UIMYU0075");
		
		return mv;
	}
	
	/**
	 * 비밀번호 일치확인
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView checkPwd(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map jsonMap = new HashMap();
		
		String loginId = MapUtils.getString(rqstMap, "ad_user_id","").toLowerCase();
		String loginPw = MapUtils.getString(rqstMap, "ad_user_pw","");
		
		// PASSWORD 암호화
		byte pszDigest[] = new byte[32];		
		Crypto cry = CryptoFactory.getInstance("SHA256");
		pszDigest =cry.encryptTobyte(loginPw);
				
		HashMap<String, Object> param = new HashMap();
		param.put("loginId", loginId);
		param.put("loginPw", pszDigest);
		param.put("checkSttus", "01");
		
		// 사용자 조회
		UserVO userVo = userService.findUser(param);
		
		if (userVo.getLoginAt().equals("N")) {
			jsonMap.put("reason", "fail");
			return ResponseUtil.responseJson(mv, false, jsonMap);
			
		}

		return ResponseUtil.responseJson(mv, true, jsonMap);
	}
}
