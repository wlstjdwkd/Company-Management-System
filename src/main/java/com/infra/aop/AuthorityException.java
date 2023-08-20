package com.infra.aop;

import java.util.Locale;

import org.springframework.context.MessageSource;

import egovframework.rte.fdl.cmmn.exception.BaseException;

/**
 * 권한체크 예외발생 시 사용
 * @author sujong
 *
 */
@SuppressWarnings("serial")
public class AuthorityException extends BaseException {

	public AuthorityException() {
		super();
	}

	public AuthorityException(MessageSource messageSource, String messageKey, Locale locale,
			Throwable wrappedException) {
		super(messageSource, messageKey, locale, wrappedException);
	}

	public AuthorityException(MessageSource messageSource, String messageKey, Object[] messageParameters,
			Locale locale, Throwable wrappedException) {
		super(messageSource, messageKey, messageParameters, locale, wrappedException);
	}

	public AuthorityException(MessageSource messageSource, String messageKey, Object[] messageParameters,
			String defaultMessage, Locale locale, Throwable wrappedException) {
		super(messageSource, messageKey, messageParameters, defaultMessage, locale, wrappedException);
	}

	public AuthorityException(MessageSource messageSource, String messageKey, Object[] messageParameters,
			String defaultMessage, Throwable wrappedException) {
		super(messageSource, messageKey, messageParameters, defaultMessage, wrappedException);
	}

	public AuthorityException(MessageSource messageSource, String messageKey, Object[] messageParameters,
			Throwable wrappedException) {
		super(messageSource, messageKey, messageParameters, wrappedException);
	}

	public AuthorityException(MessageSource messageSource, String messageKey, Throwable wrappedException) {
		super(messageSource, messageKey, wrappedException);
	}

	public AuthorityException(MessageSource messageSource, String messageKey) {
		super(messageSource, messageKey);
	}

	public AuthorityException(String defaultMessage, Object[] messageParameters, Throwable wrappedException) {
		super(defaultMessage, messageParameters, wrappedException);
	}

	public AuthorityException(String defaultMessage, Throwable wrappedException) {
		super(defaultMessage, wrappedException);
	}

	public AuthorityException(String defaultMessage) {
		super(defaultMessage);
	}

	public AuthorityException(Throwable wrappedException) {
		super(wrappedException);
	}

}
