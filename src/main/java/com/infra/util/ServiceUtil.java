/**
 * 프로그램명: Service Util
 * 내     용: 서비스 클래스에서 사용되는 기타 유틸
 * 이     력:
 *  ---------------------------------------------------------------
 *  Revision	Date		Author		Description
 *  --------------------------------------------------------------- 
 *  1.1			2014/04/22	강수종		최초 작성
 *  
 */
package com.infra.util;

import java.util.Locale;

import org.springframework.context.MessageSource;
import org.springframework.context.MessageSourceAware;
import org.springframework.stereotype.Component;

/**
 * 서비스 관련 Util
 * @author sujong
 *
 */
@Component
public class ServiceUtil implements MessageSourceAware {
	
	private static MessageSource msgSource;

	private static ServiceUtil su = new ServiceUtil();
	private static Locale locale = Locale.getDefault();

	/**
	 * 메시지소스 전달받는다.
	 */
	public void setMessageSource(MessageSource messageSource) {
		msgSource = messageSource;
	}
	
	/**
	 * 메시지 String을 반환한다.
	 * 
	 * @param key
	 * @param args
	 * @param locale
	 * @return
	 */
	private String getMessage(String key, String[] args, Locale locale) {
		return msgSource.getMessage(key, args, locale);
	}
	
	
	/**
	 * 두 개의 메시지 키를 받아 String 객체로 반환한다.
	 * @param keyF
	 * @param keyS
	 * @param nl 두 메시지 사이에 new line 사용여부
	 * @return
	 */
	public static String concatMessage(String keyF, String keyS, boolean nl) {
		return concatMessage(keyF, null, keyS, null, nl);
	}
	
	/**
	 * 두 개의 메시지 키와 첫번째 메시지의 치환인자를 받아 String 객체로 반환한다.
	 * @param keyF
	 * @param argF
	 * @param keyS
	 * @param nl 두 메시지 사이에 new line 사용여부
	 * @return
	 */
	public static String concatMessage(String keyF, String[] argF, String keyS, boolean nl) {
		return concatMessage(keyF, argF, keyS, null, nl);
	}
	
	/**
	 * 두 개의 메시지 키와 두번째 메시지의 치환인자를 받아 String 객체로 반환한다.
	 * @param keyF
	 * @param keyS
	 * @param argS
	 * @param nl 두 메시지 사이에 new line 사용여부
	 * @return
	 */
	public static String concatMessage(String keyF, String keyS, String[] argS, boolean nl) {
		return concatMessage(keyF, null, keyS, argS, nl);
	}
	
	/**
	 * 두 개의 메시지 키와 치환인자를 받아 String 객체로 반환한다.
	 * @param keyF
	 * @param argsF
	 * @param keyS
	 * @param argsS
	 * @param nl 두 메시지 사이에 new line 사용여부
	 * @return
	 */
	public static String concatMessage(String keyF, String[] argsF, String keyS, String[] argsS, boolean nl) {
		
		StringBuilder sb = new StringBuilder();
		sb.append(su.getMessage(keyF, argsF, locale));
		if (nl) sb.append("\n");
		else sb.append(" ");
		sb.append(su.getMessage(keyS, argsS, locale));
		
		return sb.toString();
	}
	
}
