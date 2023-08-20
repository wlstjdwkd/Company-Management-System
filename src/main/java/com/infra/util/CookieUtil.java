package com.infra.util;

import java.io.IOException;
import java.net.URLDecoder;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.infra.util.Validate;

/**
 * <p>
 * 쿠키와 관련된 작업을 지원하는 유틸 클래스.
 * </p>
 */
public class CookieUtil {

	private static final Logger logger = LoggerFactory.getLogger(CookieUtil.class);

    /**
     * 지정된 키값에 대한 쿠키의 값을 꺼내 온다
     *
     * @param request HttpServletRequest
     * @param cookieName 가져올 쿠키의 이름
     * @return 지정된 쿠키의 값
     */
    public static String getCookie(HttpServletRequest request, String cookieName) throws RuntimeException, Exception {

        Cookie[] cookies = request.getCookies();
        if(cookies == null) {
            return StringUtil.EMPTY;
        }
        String value = StringUtil.EMPTY;
        for(int i = 0 ; i < cookies.length ; i++) {
            if(cookieName.equals(cookies[i].getName())) {
                value = URLDecoder.decode(cookies[i].getValue(), "UTF-8");
                break;
            }
        }
        return value;
    }

    /**
     * 지정된 키값에 해당하는 쿠키 객체를 얻는다.
     *
     * @param request 요청 객체
     * @param cookieName 가져올 쿠키의 이름
     * @return 지정된 쿠키 객체, 해당 쿠키가 없다면 null 리턴함.
     */
    public static Cookie getCookieObject(HttpServletRequest request, String cookieName) {

        Cookie[] cookies = request.getCookies();
        if(cookies != null) {
            Cookie cookie;
            for(int i = 0 ; i < cookies.length ; i++) {
                cookie = cookies[i];
                if(cookie.getName().equals(cookieName)) {
                    return cookie;
                }
            }
        }
        return null;
    }

    /**
     * 설정된 쿠키의 전체값을 꺼내 온다. (ex : key=val&key=val....)
     *
     * @param request 요청 객체
     * @return 쿠키의 값
     */
    public static String getCookieString(HttpServletRequest request) throws RuntimeException, Exception {

        Cookie[] cookies = request.getCookies();
        if(cookies == null || cookies.length == 0) {
            return StringUtil.EMPTY;
        }

        StringBuffer buffer = new StringBuffer();
        for(int i = 0 ; i < cookies.length ; i++) {
            buffer.append(cookies[i].getName()).append("=").append(cookies[i].getValue()).append("&");
        }
        String rtnValue = buffer.toString();
        if(rtnValue.endsWith("&")) {
            rtnValue = rtnValue.substring(0, rtnValue.length() - 1);
        }

        return rtnValue;

    }

    /**
     * 쿠키를 만든다. 기본 유효 시간은 1일(24시간) 이다.
     *
     * @param response 응답 객체
     * @param name 쿠키의 이름
     * @param value 쿠키의 값
     */
    public static void setCookie(HttpServletResponse response, String name, String value) throws RuntimeException, Exception {

        setCookie(response, name, value, (60 * 24));
    }

    /**
     * 쿠키를 만든다.
     *
     * @param response 응답 객체
     * @param cookieName 쿠키의 이름
     * @param cookieValue 쿠키의 값
     * @param iMinute 쿠키가 유효할 시간(분단위)
     */
    public static void setCookie(HttpServletResponse response, String cookieName, String cookieValue, int iMinute)
        throws RuntimeException, Exception {

        setCookie(response, cookieName, cookieValue, iMinute, null);
    }

    public static void setCookie(HttpServletResponse response, String cookieName, String cookieValue, int iMinute,
        String domain) throws RuntimeException, Exception {

        // 보안취약점 보완 적용
        String cookieVal = cookieValue.replaceAll("\r", "").replaceAll("\n", "");
        cookieVal = java.net.URLEncoder.encode(cookieVal, "UTF-8");
        Cookie cookie = new Cookie(cookieName, cookieVal);
        if(iMinute > 0) {
        	iMinute = iMinute * 60;
        }
        cookie.setMaxAge(iMinute);
        cookie.setPath("/");
        if(Validate.isNotEmpty(domain) == true) {
            cookie.setDomain(domain);
        }

        response.addCookie(cookie);
    }

    /**
     * 쿠키 값을 추가한다.
     *
     * @param response 응답 객체
     * @param cookieName 저장할 쿠키 이름
     * @param cookieValue 저장할 쿠키 값
     */
    public static void addCookie(HttpServletResponse response, String cookieName, String cookieValue) throws RuntimeException, Exception {

        if(cookieName != null && cookieValue != null) {
            Cookie cookie = new Cookie(cookieName, cookieValue);
            /* must call addCookie method before calling getWriter */
            response.addCookie(cookie);
        }
    }

    /**
     * 게시판의 조회수 증가 체크를 위한 쿠키 체크
     */
    public static boolean isIncreateReadCnt(String cookieKey, int readCookieHour, HttpServletRequest request, HttpServletResponse response) {
        try {
            String cookieVal = CookieUtil.getCookie(request, cookieKey);
            if(!"Y".equals(cookieVal)) {
                CookieUtil.setCookie(response, cookieKey, "Y", readCookieHour * 60);
                return true;
            }
        } catch (IOException e) {
        	logger.error("", e);
        } catch (Exception e) {
        	logger.error("", e);
        }

        return false;
    }
}
