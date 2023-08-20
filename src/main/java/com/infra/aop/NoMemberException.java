package com.infra.aop;

import java.util.Locale;

import org.springframework.context.MessageSource;

import egovframework.rte.fdl.cmmn.exception.BaseException;

/**
 * 비로그인 예외발생 시 사용
 * @author sujong
 *
 */
@SuppressWarnings("serial")
public class NoMemberException extends BaseException {

	public NoMemberException() {
		super();
	}

	public NoMemberException(MessageSource messageSource, String messageKey, Locale locale,
			Throwable wrappedException) {
		super(messageSource, messageKey, locale, wrappedException);
	}

	public NoMemberException(MessageSource messageSource, String messageKey, Object[] messageParameters,
			Locale locale, Throwable wrappedException) {
		super(messageSource, messageKey, messageParameters, locale, wrappedException);
	}

	public NoMemberException(MessageSource messageSource, String messageKey, Object[] messageParameters,
			String defaultMessage, Locale locale, Throwable wrappedException) {
		super(messageSource, messageKey, messageParameters, defaultMessage, locale, wrappedException);
	}

	public NoMemberException(MessageSource messageSource, String messageKey, Object[] messageParameters,
			String defaultMessage, Throwable wrappedException) {
		super(messageSource, messageKey, messageParameters, defaultMessage, wrappedException);
	}

	public NoMemberException(MessageSource messageSource, String messageKey, Object[] messageParameters,
			Throwable wrappedException) {
		super(messageSource, messageKey, messageParameters, wrappedException);
	}

	public NoMemberException(MessageSource messageSource, String messageKey, Throwable wrappedException) {
		super(messageSource, messageKey, wrappedException);
	}

	public NoMemberException(MessageSource messageSource, String messageKey) {
		super(messageSource, messageKey);
	}

	public NoMemberException(String defaultMessage, Object[] messageParameters, Throwable wrappedException) {
		super(defaultMessage, messageParameters, wrappedException);
	}

	public NoMemberException(String defaultMessage, Throwable wrappedException) {
		super(defaultMessage, wrappedException);
	}

	public NoMemberException(String defaultMessage) {
		super(defaultMessage);
	}

	public NoMemberException(Throwable wrappedException) {
		super(wrappedException);
	}

}
