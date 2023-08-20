package com.infra.util;

import java.util.Map;

import javax.servlet.http.HttpSession;

import com.comm.certify.NiceDecVO;
import com.comm.certify.NiceEncVO;
import com.comm.menu.MenuVO;
import com.comm.user.AuthorityVO;
import com.comm.user.EntUserVO;
import com.comm.user.UserVO;
import com.infra.system.GlobalConst;

import org.apache.commons.collections.MapUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

/**
 * 세션관련 Util
 * @author sujong
 *
 */
@SuppressWarnings("unchecked")
public class SessionUtil {

	/**
	 * HttpSession을 반환한다.
	 *
	 * @param 세션 생성 여부(true : 생성된 세션이 없으면 신규 생성하여 반환, false : 생성된 세션이 없으면 null 반환)
	 * @return 생성된 세션 또는 null
	 */
	public static HttpSession getHttpSession(boolean create) {

		ServletRequestAttributes request = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
		HttpSession session = (request != null) ? request.getRequest().getSession(create) : null;

		return session;
	}

	/**
	 * 세션ID를 반환한다.
	 * @return 생성된 세션이 없으면 null
	 */
	public static String getSessionId() {
		HttpSession session = getHttpSession(false);
		if (session == null)
			return null;

		return session.getId();
	}

	/**
	 * 세션에 설정된 사용자 정보 객체를 반환한다.
	 * @return 세션에 설정된 객체가 없으면 null
	 */
	public static UserVO getUserInfo() {
		HttpSession session = getHttpSession(false);
		if (session == null)
			return null;

		return (UserVO) session.getAttribute(GlobalConst.SESSION_USERINFO_NAME);
	}

	/**
	 * 세션에 사용자 정보 객체를 설정한다.
	 * @param userInfo
	 */
	public static void setUserInfo(UserVO userInfo, int interval) {
		HttpSession session = getHttpSession(true);
		session.setAttribute(GlobalConst.SESSION_USERINFO_NAME, userInfo);
		session.setMaxInactiveInterval(interval);	// 세션유지 시간설정(초)
	}

	/**
	 * 세션에 사용자 정보 객체를 설정한다.
	 * @param userInfo
	 */
	public static void setUserInfo(UserVO userInfo) {
		HttpSession session = getHttpSession(true);
		session.setAttribute(GlobalConst.SESSION_USERINFO_NAME, userInfo);
	}

	/**
	 * 세션에 설정된 권한 정보에서 지정한 키의 값을 반환한다.
	 *
	 * @param key
	 * @return 세션에 설정된 값이 없으면 null
	 */
	public static AuthorityVO getAuthInfo(String key) {
		Map<String, AuthorityVO> authInfo = getAuthInfo();
		if (MapUtils.isEmpty(authInfo))
			return null;

		return (AuthorityVO) MapUtils.getObject(authInfo, key);
	}

	/**
	 * 세션에 설정된 권한 정보 객체를 반환한다.
	 * @return 세션에 설정된 객체가 없으면 null
	 */
	public static Map<String, AuthorityVO> getAuthInfo() {
		HttpSession session = getHttpSession(false);
		if (session == null)
			return null;

		return (Map<String, AuthorityVO>) session.getAttribute(GlobalConst.SESSION_AUTHINFO_NAME);
	}

	/**
	 * 세션에 권한 정보 객체를 설정한다.
	 * @param empInfo
	 */
	public static void setAuthInfo(Map<String, AuthorityVO> authInfo, int interval) {
		HttpSession session = getHttpSession(true);
		session.setAttribute(GlobalConst.SESSION_AUTHINFO_NAME, authInfo);
		session.setMaxInactiveInterval(interval);	// 세션유지 시간설정(초)
	}


	/**
	 * 세션에 설정된 메뉴 정보에서 지정한 키의 값을 반환한다.
	 *
	 * @param menuNo 조회할 메뉴번호
	 * @return 세션에 설정된 값이 없으면 null
	 */
	public static MenuVO getMenuInfo(int menuNo) {
		Map<String, MenuVO> menuInfo = getMenuInfo();
		if (MapUtils.isEmpty(menuInfo))
			return null;

		return (MenuVO) MapUtils.getObject(menuInfo, menuNo);
	}

	/**
	 * 세션에 설정된 메뉴 정보 객체를 반환한다.
	 * @return 세션에 설정된 객체가 없으면 null
	 */
	public static Map<String, MenuVO> getMenuInfo() {
		HttpSession session = getHttpSession(false);
		if (session == null)
			return null;

		return (Map<String, MenuVO>) session.getAttribute(GlobalConst.SESSION_MENUINFO_NAME);
	}

	/**
	 * 세션에 메뉴 객체를 설정한다.
	 * @param menuInfo
	 */
	public static void setMenuInfo(Map<String, MenuVO> menuInfo, int interval) {
		HttpSession session = getHttpSession(true);
		session.setAttribute(GlobalConst.SESSION_MENUINFO_NAME, menuInfo);
		session.setMaxInactiveInterval(interval);	// 세션유지 시간설정(초)
	}

	/**
	 * 세션에 사용자인증요청 정보 객체를 설정한다.
	 * @param userInfo
	 */
	public static void setNiceEncInfo(NiceEncVO niceEncVo, int interval) {
		HttpSession session = getHttpSession(true);
		session.setAttribute(GlobalConst.SESSION_NICE_ENC_NAME, niceEncVo);
		session.setMaxInactiveInterval(interval);	// 세션유지 시간설정(초)
	}

	/**
	 * 세션에 사용자인증요청 정보 객체를 반환한다.
	 * @return 세션에 설정된 객체가 없으면 null
	 */
	public static NiceEncVO getNiceEncInfo() {
		HttpSession session = getHttpSession(false);
		if (session == null)
			return null;

		return (NiceEncVO) session.getAttribute(GlobalConst.SESSION_NICE_ENC_NAME);
	}

	/**
	 * 세션에 사용자인증 정보 객체를 설정한다.
	 * @param userInfo
	 */
	public static void setNiceDecInfo(NiceDecVO niceDecVo, int interval) {
		HttpSession session = getHttpSession(true);
		session.setAttribute(GlobalConst.SESSION_NICE_DEC_NAME, niceDecVo);
		session.setMaxInactiveInterval(interval);	// 세션유지 시간설정(초)
	}

	/**
	 * 세션에 사용자인증요청 정보 객체를 반환한다.
	 * @return 세션에 설정된 객체가 없으면 null
	 */
	public static NiceDecVO getNiceDecInfo() {
		HttpSession session = getHttpSession(false);
		if (session == null)
			return null;

		return (NiceDecVO) session.getAttribute(GlobalConst.SESSION_NICE_DEC_NAME);
	}

	/**
	 * 세션에 인증유형 정보 객체를 설정한다.
	 * @param userInfo
	 */
	public static void setCertifyType(String certifyType, int interval) {
		HttpSession session = getHttpSession(true);
		session.setAttribute(GlobalConst.SESSION_CERTIFY_TYPE_NAME, certifyType);
		session.setMaxInactiveInterval(interval);	// 세션유지 시간설정(초)
	}

	/**
	 * 세션에 인증유형 정보 객체를 반환한다.
	 * @return 세션에 설정된 객체가 없으면 null
	 */
	public static String getCertifyType() {
		HttpSession session = getHttpSession(false);
		if (session == null)
			return null;

		return (String) session.getAttribute(GlobalConst.SESSION_CERTIFY_TYPE_NAME);
	}

	/**
	 * 세션에 기업사용자 정보 객체를 설정한다.
	 * @param userInfo
	 */
	public static void setEntUserInfo(EntUserVO entUserInfo, int interval) {
		HttpSession session = getHttpSession(true);
		session.setAttribute(GlobalConst.SESSION_ENTUSERINFO_NAME, entUserInfo);
		session.setMaxInactiveInterval(interval);	// 세션유지 시간설정(초)
	}

	/**
	 * 세션에 기업사용자 정보 객체를 설정한다.
	 * @return 세션에 설정된 객체가 없으면 null
	 */
	public static EntUserVO getEntUserInfo() {
		HttpSession session = getHttpSession(false);
		if (session == null)
			return null;

		return (EntUserVO) session.getAttribute(GlobalConst.SESSION_ENTUSERINFO_NAME);
	}

	/**
	 * 세션에 기업재무HTML 정보를 설정한다.
	 * @param userInfo
	 */
	public static void setFnnrHTML(String fnnrHTML, int interval) {
		HttpSession session = getHttpSession(true);
		session.setAttribute(GlobalConst.SESSION_FNNRHTML_NAME, fnnrHTML);
		session.setMaxInactiveInterval(interval);	// 세션유지 시간설정(초)
	}

	/**
	 * 세션에 기업재무HTML 정보를 설정한다.
	 * @return 세션에 설정된 객체가 없으면 null
	 */
	public static String getFnnrHTML() {
		HttpSession session = getHttpSession(false);
		if (session == null)
			return null;

		return (String) session.getAttribute(GlobalConst.SESSION_FNNRHTML_NAME);
	}

}
