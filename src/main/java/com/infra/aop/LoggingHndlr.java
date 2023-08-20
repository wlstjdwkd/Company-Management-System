/**
 * 프로그램명: 서비스로깅
 * 내     용: 서비스 수행 로그 기록
 * 이     력:
 *  ---------------------------------------------------------------
 *  Revision	Date		Author		Description
 *  ---------------------------------------------------------------
 *  1.1			2014/04/22	강수종		최초 작성
 *
 */
package com.infra.aop;

import org.aspectj.lang.ProceedingJoinPoint;

import java.io.IOException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.util.StopWatch;


public class LoggingHndlr {

	private Log logger = LogFactory.getLog(LoggingHndlr.class);


	/**
	 * 처리시간, 입력값을 Logging.
	 * @throws Throwable
	 */
	@SuppressWarnings("rawtypes")
	public Object writeLog(ProceedingJoinPoint join) throws Throwable {

		StopWatch stopWatch = new StopWatch();

		String className = join.getTarget().getClass().getName();
		String methodName = join.getSignature().getName();

		try {
			stopWatch.start();

			if (logger.isDebugEnabled() && !methodName.equals("toString")) {
				logger.debug("");
				logger.debug("=========================== Service Input Parameter ===========================");
				logger.debug("Component명 : " + getClassName(className) + "." + methodName);

				Object[] argument = join.getArgs();

				if (argument != null && argument.length > 0) {

					for (int i = 0; i < argument.length; i++) {

						logger.debug("입력값" + ((argument.length > 1) ? "(" + (i + 1) + ")" : "") + " : " + argument[i].toString());
					}
				}

				logger.debug("========================================================================");
			}

			Object retVal = join.proceed();

			return retVal;

		} catch (IOException e) {
			throw e;
		} catch (Exception e) {
			throw e;
		} finally {
			stopWatch.stop();

			long millis = stopWatch.getTotalTimeMillis();

			if (logger.isDebugEnabled() && !methodName.equals("toString")) {
				printProcessTime(className, methodName, millis);
			}
		}
	}

	/**
	 * Logging처리
	 * @param className
	 * @param methodName
	 * @param layerName
	 * @param endTime
	 * @param startTime
	 */
	public void printProcessTime(String className, String methodName, long millis) {
		logger.debug("");
		logger.debug("============================ Service Process Time =============================");
		logger.debug(getClassName(className) + "." + methodName + "()" + " 처리시간 " + getTimeString(millis));
		logger.debug("========================================================================");
	}

	public String getClassName(String className) {
		return className.substring(className.lastIndexOf(".") + 1);
	}

	/**
	 * 소요 시간을 출력
	 * @param millis
	 * @return String
	 */
	public String getTimeString(long millis) {

		long days = millis / 32400000;
		long days_rest = millis % 32400000;
		long hours = days_rest / 3600000;
		long hours_rest = days_rest % 3600000;
		long minutes = hours_rest / 60000;
		long minutes_rest = hours_rest % 60000;
		long seconds = minutes_rest / 1000;
		long millisecs = minutes_rest % 1000;

		String timestr = "";
		timestr += days + "d " + hours + "h " + minutes + "m " + seconds + "s " + millisecs + "ms";
		return timestr;
	}
}
