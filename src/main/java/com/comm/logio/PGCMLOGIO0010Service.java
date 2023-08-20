package com.comm.logio;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.comm.menu.MenuService;
import com.comm.menu.MenuVO;
import com.comm.user.AuthorityVO;
import com.comm.user.EntUserVO;
import com.comm.user.UserService;
import com.comm.user.UserVO;
import com.infra.system.GlobalConst;
import com.infra.util.ArrayUtil;
import com.infra.util.JsonUtil;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.Validate;
import com.infra.util.crypto.Crypto;
import com.infra.util.crypto.CryptoFactory;
import biz.tech.my.PGMY0070Service;
import biz.tech.um.PGUM0001Service;
import biz.tech.am.PGAM0001Service;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.ModelAndView;

import tradesign.crypto.provider.JeTS;
import tradesign.pki.pkix.Login;
import tradesign.pki.pkix.X509Certificate;
import tradesign.pki.util.JetsUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 로그인/로그아웃 처리 클래스
 * 
 * @author JGS
 * 
 */
@Service("PGCMLOGIO0010")
public class PGCMLOGIO0010Service extends EgovAbstractServiceImpl
{
	private static final Logger logger = LoggerFactory.getLogger(PGCMLOGIO0010Service.class);

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;
	
	@Resource(name = "messageSource")
	private MessageSource messageSource;

	@Autowired
	UserService userService;
	
	@Autowired
	MenuService menuService;
	
	@Autowired
	PGAM0001Service pgam0001;
	
	@Autowired
	PGUM0001Service pgum0001;
	
	@Autowired
	PGMY0070Service pgmy0070;

	/**
	 * 관리자 로그인 화면 출력
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception
	{
		//return new ModelAndView("/www/mb/BD_UIMBU0010");
		logger.debug("============================ start");
		return new ModelAndView("/www/comm/logio/BD_UICMLOGIOU0010");
	}	
	
	/**
	 * 사용자 유효 확인
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView checkVaildUser(Map<?, ?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		HashMap jsonMap = new HashMap();
		
		String loginId = MapUtils.getString(rqstMap, "ad_user_id","").toLowerCase();
		String loginPw = MapUtils.getString(rqstMap, "ad_user_pw","");
		String loginType = MapUtils.getString(rqstMap, "login_type","");
		String ssn = MapUtils.getString(rqstMap, "ad_ssn","");

		if (StringUtils.isEmpty(loginId)||StringUtils.isEmpty(loginPw)) {
			jsonMap.put("result", "fail");
			return ResponseUtil.responseText(mv,JsonUtil.toJson(jsonMap));
		}

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
		if (userVo == null) {
			jsonMap.put("result", "fail");
			return ResponseUtil.responseText(mv,JsonUtil.toJson(jsonMap));
		}
		
		/*logger.debug("##### loginAt ===> " , userVo.getLoginAt());*/
		if (userVo.getLoginAt().equals("N")) {
			jsonMap.put("result", "fail");
			return ResponseUtil.responseText(mv,JsonUtil.toJson(jsonMap));
		}
		
		if(loginType.equals("0"))
		{
			// 개인/기관 로그인일때 기업회원이 로그인할시 거부
			if(userVo.getEmplyrTy().equals("EP")) {
				jsonMap.put("result", "gubun1");
				return ResponseUtil.responseText(mv, JsonUtil.toJson(jsonMap));
			}
		}
		
		if(loginType.equals("1"))
		{

			HashMap findMngUserParam = new HashMap();
			findMngUserParam.put("USER_NO", userVo.getUserNo().toString());	
			EntUserVO mngUser = userService.findMngUser(findMngUserParam);
			
			// 사업자번호 공인인증 여부 확인
			if(userVo.getEmplyrTy().equals("EP")) {
				param.put("USER_NO", userVo.getUserNo().toString());
				EntUserVO entUserVo = userService.findEntUser(param);
				if(entUserVo.getBizrnoCertChk().equals("N")) {
					jsonMap.put("result", "notcert");
					jsonMap.put("loginid", userVo.getLoginId().toString());
					jsonMap.put("userno", userVo.getUserNo().toString());
				}
				if(entUserVo.getBizrnoCertChk().equals("Y")) {
					// 관리자 정보 없을 경우
					if (mngUser == null) {
						jsonMap.put("result", "noMngUser");
						return ResponseUtil.responseText(mv,JsonUtil.toJson(jsonMap));
					}
					
					jsonMap.put("result", "sucess");
					return ResponseUtil.responseText(mv,JsonUtil.toJson(jsonMap));
				}
				
				return ResponseUtil.responseText(mv, JsonUtil.toJson(jsonMap));
			}
			else {
				jsonMap.put("result", "gubun2");
				return ResponseUtil.responseText(mv, JsonUtil.toJson(jsonMap));
			}
		}
		
		// 비밀번호 유효날짜 만료
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
		Date now = new Date();
		String todayDe = format.format(now);
		String passwordDe = userVo.getPasswordValidDe();
		String emplyrTy = userVo.getEmplyrTy();
		
		if("EP".equals(emplyrTy.toUpperCase()) || "GN".equals(emplyrTy.toUpperCase())) {
			if(Integer.parseInt(todayDe) > Integer.parseInt(passwordDe)) {
				jsonMap.put("result", "select");
				return ResponseUtil.responseText(mv,JsonUtil.toJson(jsonMap));
			}
		}
		
		jsonMap.put("result", "sucess");
		return ResponseUtil.responseText(mv,JsonUtil.toJson(jsonMap));
	}
	
	/**
	 * 로그인 처리 및 관리자인 경우 IP 체크
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processLogin(Map<?, ?> rqstMap) throws Exception
	{
		String loginId = MapUtils.getString(rqstMap, "ad_user_id");
		String loginPw = MapUtils.getString(rqstMap, "ad_user_pw");
		
		String mypage = MapUtils.getString(rqstMap, "ad_mypage");
		
		String managerPage = MapUtils.getString(rqstMap, "manager_page");
		
		if (StringUtils.isEmpty(loginId)) {
			throw processException("errors.required", new String[] { "로그인 아이디" });
		}
		if (StringUtils.isEmpty(loginPw)) {
			throw processException("errors.required", new String[] { "비밀번호" });
		}
		
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
		if (userVo == null) {
			throw processException("errors.invalid.login");
		}
		if (userVo.getLoginAt().equals("N")) {
			throw processException("errors.invalid.login");
		}
		
		// 이전 로그인 세션정보 삭제
		if (SessionUtil.getUserInfo() != null) SessionUtil.getHttpSession(true).invalidate();
		
		// 권한그룹 조회
		param = new HashMap();
		param.put("userNo", userVo.getUserNo());
		userVo.setAuthorGroupCode(userService.findUserAuthorGroup(param));

		// 관리자 접근IP 제한모드가 설정되어 있으면
		if (propertiesService.getBoolean("restrictAdminIP", true)) {
			String adminAuthCode = propertiesService.getString("adminGroupCd");
			String[] userAuth = userVo.getAuthorGroupCode();
			for(int i=0; i<userAuth.length; i++) {
				// 관리자이면 IP check
				if (userAuth[i].equals(adminAuthCode)) {					
					HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
					HashMap ipParam = new HashMap();
					
					if (Validate.isNotEmpty(request.getRemoteAddr())) {
						ipParam.put("ip",  request.getRemoteAddr());
					} else {
						ipParam.put("ip",  request.getHeader("X-FORWARDED-FOR"));
					}					
					
					if (!userService.validateIPAddress(ipParam)) throw processException("errors.invalid.access.admin");
				}
			}
		}

		// 사용자정보 세션설정
		SessionUtil.setUserInfo(userVo, propertiesService.getInt("session.timeout"));
		
		// 사용자 로그인 일자 업데이트
		userService.updateLoginDe(param);

		param = new HashMap();
		param.put("authorGrpCd", userVo.getAuthorGroupCode());
		
		// 사용자 권한조회 및 세션설정
		HashMap<String, AuthorityVO> auth = userService.findUserAuthority(param);
		SessionUtil.setAuthInfo(auth, propertiesService.getInt("session.timeout"));
		
		// 사용자 메뉴조회 및 세션설정
		LinkedHashMap<String, MenuVO> menu = menuService.findUserMenuMap(param);
		SessionUtil.setMenuInfo(menu, propertiesService.getInt("session.timeout"));
		
		String[] authorGroupCode = userVo.getAuthorGroupCode();
		// 기업회원 세션설정
		if(ArrayUtil.contains(authorGroupCode, GlobalConst.AUTH_DIV_ENT)) {
			param = new HashMap();
			param.put("USER_NO", userVo.getUserNo());			
			// 기업사용자조회
			EntUserVO entUserVo = userService.findEntUser(param);
			SessionUtil.setEntUserInfo(entUserVo, propertiesService.getInt("session.timeout"));
		}
		if("Y".equals(mypage)) {
			ModelAndView mv = pgmy0070.userUpdateForm(rqstMap);
			return mv;
		}
		
		if("Y".equals(managerPage)) {
			ModelAndView mv = pgmy0070.userUpdateForm(rqstMap);
			return mv;
		}
		
		ModelAndView mv = pgam0001.index(rqstMap);
		return mv;
	}
	
	
	/**
	 * 로그아웃 처리
	 */
	public ModelAndView processLogout(Map<?, ?> rqstMap) throws Exception
	{
		HttpSession session = SessionUtil.getHttpSession(false);
		if (session != null) {
			session.removeAttribute(GlobalConst.SESSION_USERINFO_NAME);
			session.removeAttribute(GlobalConst.SESSION_AUTHINFO_NAME);
			session.removeAttribute(GlobalConst.SESSION_MENUINFO_NAME);
			session.invalidate();
		}
		pgum0001.setAnonymousInfo();
		//return new ModelAndView("/www/mb/BD_UIMBU0011");
		return new ModelAndView("/www/comm/logio/BD_UICMLOGIOU0011");
	}
	
	/**
	 * 키보드 보안 솔루션 설치페이지
	 */
	public ModelAndView keyboardEnc(Map<?, ?> rqstMap) throws Exception
	{
		//return new ModelAndView("/www/mb/install");
		return new ModelAndView("/www/comm/logio/install");
	}
	
	/**
	 * 사업자 공인인증 보안 솔루션 설치페이지
	 */
	public ModelAndView bsisnoInstall(Map<?, ?> rqstMap) throws Exception
	{
		//return new ModelAndView("/www/mb/index");
		return new ModelAndView("/www/comm/logio/index");
	}
	
	/**
	 * 사업자 공인인증 보안 솔루션 proc 페이지
	 */
	public ModelAndView bsisnoProc(Map<?, ?> rqstMap) throws Exception
	{
		//ModelAndView mv = new ModelAndView("/www/mb/bizrnoLoginProc");
		ModelAndView mv = new ModelAndView("/www/comm/logio/bizrnoLoginProc");
		mv.addObject(rqstMap);
		return mv;
	}
	
	/**
	 * 사업자번호 인증 팝업
	 */
	public ModelAndView businessNumCert(Map<?, ?> rqstMap) throws Exception
	{
		// 추가해야함
		//ModelAndView mv = new ModelAndView("/www/mb/PD_UIMBU0012");
		ModelAndView mv = new ModelAndView("/www/comm/logio/PD_UICMLOGIOU0012");
		Map param = new HashMap();
		Map param2 = new HashMap();
		String loginid = MapUtils.getString(rqstMap, "ad_login_id","");
		param.put("loginId", loginid);
		// 사용자 조회
		UserVO userVo = userService.findUser(param);
		EntUserVO entVo = new EntUserVO();
		param2.put("USER_NO", userVo.getUserNo().toString());
		if (userVo != null) {
			entVo = userService.findEntUser(param2);
		}
		if(entVo != null)
		{
			mv.addObject("ad_bizrno_first", entVo.getBizrno().substring(0, 3));
			mv.addObject("ad_bizrno_middle", entVo.getBizrno().substring(3, 5));
			mv.addObject("ad_bizrno_last", entVo.getBizrno().substring(5));
		}
		return mv;
	}
	
	/**
	 * 사업자번호 임시 패스
	 */
	public ModelAndView certPass(Map<?, ?> rqstMap) throws Exception {
		// 추가해야함
		ModelAndView mv = new ModelAndView();					
		Map param = new HashMap();
		Map param2 = new HashMap();
		HashMap jsonMap = new HashMap();
		String loginid = MapUtils.getString(rqstMap, "ad_user_id","");
		String ssn = MapUtils.getString(rqstMap, "ad_ssn","");
		String userpw = MapUtils.getString(rqstMap, "ad_user_pw","");
		param.put("loginId", loginid);
		// 사용자 조회
		UserVO userVo = userService.findUser(param);
		EntUserVO entVo = new EntUserVO();
		
		if (userVo != null) {
			param2.put("USER_NO", userVo.getUserNo().toString());
			entVo = userService.findEntUser(param2);
		} else {
			jsonMap.put("result", "X");
			return ResponseUtil.responseText(mv,JsonUtil.toJson(jsonMap));
		}
		if(entVo != null)
		{
			if(!ssn.equals(entVo.getBizrno().toString())) {
				jsonMap.put("result", "X");
				return ResponseUtil.responseText(mv,JsonUtil.toJson(jsonMap));
			}
			if(ssn.equals(entVo.getBizrno().toString()) && entVo.getBizrnoCertChk().equals("Y")) {
				jsonMap.put("result", "Y");
				return ResponseUtil.responseText(mv,JsonUtil.toJson(jsonMap));
			}
			if(ssn.equals(entVo.getBizrno().toString()) && entVo.getBizrnoCertChk().equals("N")) {
				jsonMap.put("result", "N");
				return ResponseUtil.responseText(mv,JsonUtil.toJson(jsonMap));
			}
		}
		return mv;
	}
}
