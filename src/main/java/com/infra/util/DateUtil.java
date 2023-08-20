/**
 * 프로그램명: DateUtil
 * 내     용: 날짜변환에 관련된 Helper Util 클래스
 * 이     력:
 *  ---------------------------------------------------------------
 *  Revision	Date		Author		Description
 *  ---------------------------------------------------------------
 *  1.1			2014/04/22	tech		최초 작성
 *
 */
package com.infra.util;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 날짜관련 Util
 * @author sujong
 *
 */
public class DateUtil {
	private static final String datePattern = "yyyyMMdd";
//	private static final String yyyymmddhh24mi = "yyyymmddhh24mi";

	private static String timePattern = "yyyyMMdd HH:MM a";
	private static String timePatternHms = "yyyyMMddHHmmss";

//	private static final long ONE_MINUTE = 60000L;
//	private static final long ONE_HOUR = 3600000L;
	private static final long ONE_DAY = 86400000L;

	/**
	 * 해당 DefaultDatePattern을 return
	 * @return String
	 */
	public static String getDatePattern() {
		return datePattern;
	}

	/**
	 * 파라미터로 java.util.Date, datePattern을 넘길시 해당 날짜를 datePattern형식으로 return e
	 * x) DateUtil.getDate(new Date(), datePattern);
	 * =========================================================================
	 * DatePattern Result
	 * =========================================================================
	 * MM/dd/yyyy : 08/10/2007 EEE, dd MMM yyyy
	 * HH:mm:ss Z : 금, 10 8월 2007 18:20:31 +0900 EEE
	 * MMM dd HH:mm:ss 'CET' yyyy : 금 8월 10 18:20:31 CET 2007
	 * dd/MM/yyyy : 10/08/2007
	 * yyyy-MM-dd : 2007-08-10
	 * EEE, dd MMM yyyy HH:mm:ss zzz : 금, 10 8월 2007 18:20:31 KST
	 * yyyy-MM-dd'T'HH:mm:ssZ :2007-08-10T18:20:31+0900
	 * yyyyMMdd : 20070810
	 * =========================================================================
	 * @param java.uti.Date
	 * @return
	 */
	public static final String getDate(Date date, String s) {
		String s1 = "";
		if (date != null) {
			SimpleDateFormat sdf = new SimpleDateFormat(s);
			s1 = sdf.format(date);
		}
		return s1;
	}

	/**
	 * 두 날짜 사이의 일수(days) 계산
	 * @param d1 -
	 * @param d2
	 * @return
	 */
	public static long getDateDiffInDays(Date from, Date end) {
		long l = supressTime(end, null).getTime() - supressTime(from, null).getTime();
		return l / ONE_DAY;
	}

	public static Date supressTime(Date date, Locale locale) {
		Calendar calendar = locale != null ? Calendar.getInstance() : Calendar.getInstance();
		calendar.setTime(date);
		calendar.set(11, 0);
		calendar.set(12, 0);
		calendar.set(13, 0);
		calendar.set(14, 0);
		return calendar.getTime();
	}

	/**
	 * 현재 날짜에서 days에 해당하는 일수의 날짜를 반환
	 * @param days
	 * @return
	 */
	public static String getDateDiffInDays(int i) {
		GregorianCalendar gc = new GregorianCalendar();
		gc.add(5, i);
		return getDate(gc.getTime());
	}

	public static String getHHmmss() {
		return getDate(new Date(), timePatternHms).substring(8);
	}

	/**
	 * 현재 날짜에서 months에 해당하는 개월수 만큼의 날짜을 반환
	 * @param String yyyymmdd, int days
	 * @return 기준일 며칠 후
	 */
	public static String getDateDiffDays(String str, int i) {
		GregorianCalendar gc = new GregorianCalendar();
		gc.set(Integer.parseInt(str.substring(0, 4)), Integer.parseInt(str.substring(4, 6)) - 1, Integer.parseInt(str.substring(6, 8)));
		gc.add(5, i);

		return convertDateToString(gc.getTime());
	}

	/**
	 * 현재 날짜에서 months에 해당하는 개월수 만큼의 날짜을 반환
	 * @param months
	 * @return
	 */
	public static String getDateDiffInMonths(int i) {
		Calendar calendar = Calendar.getInstance();
		calendar.add(2, i);
		calendar.set(11, 0);
		calendar.set(12, 0);
		calendar.set(13, 0);
		calendar.set(14, 0);
		return getDate(calendar.getTime());
	}

	/**
	 * 시작날짜와 종료날짜의 날짜차이를 구한다.
	 * @param yyyymmdd1
	 * @param yyyymmdd2
	 * @return
	 */
	public static long getDateDiffRetDays(String from, String end) {
		GregorianCalendar gcF = new GregorianCalendar();
		gcF.set(Integer.parseInt(from.substring(0, 4)), Integer.parseInt(from.substring(4, 6)) - 1, Integer.parseInt(from.substring(6, 8)));

		GregorianCalendar gcE = new GregorianCalendar();
		gcE.set(Integer.parseInt(end.substring(0, 4)), Integer.parseInt(end.substring(4, 6)) - 1, Integer.parseInt(end.substring(6, 8)));

		long l = gcE.getTimeInMillis() - gcF.getTimeInMillis();

		return l / ONE_DAY;
	}

	/**
	 * 파라미터로 java.util.Date를 넘길시 해당 날짜를 datePattern형식으로
	 * @param java.uti.Date
	 * @return DateUtil.getDate(new Date()); ==> 20070810
	 */
	public static final String getDate(Date date) {
		return getDate(date, datePattern);
	}

	/**
	 * 날짜를 java.util.Date Type으로 return DateUtil.convertStringToDate("yyyyMMdd", "20070810")
	 * @param aMask
	 * @param strDate
	 * @return java.util.Date
	 * @throws ParseException
	 */
	public static final Date convertStringToDate(String format, String str) throws ParseException {
		SimpleDateFormat sdf = null;
		Date date = null;
		sdf = new SimpleDateFormat(format);

		try {
			date = sdf.parse(str);
		} catch (ParseException pe) {
			throw new ParseException("", pe.getErrorOffset());
		}
		return date;
	}

	/**
	 * timePattern에 해당하는 형식으로 현재의 시간을 return
	 * @param theTime
	 * @return
	 */
	public static String getTimeNow(Date date) {
		return getDate(date, timePattern);
	}

	/**
	 * 당일의 날짜를 default datePattern형식의 Carlendar로 return
	 * @return
	 * @throws ParseException
	 */
	public static Calendar getToday() throws ParseException {
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat(datePattern);
		String str = sdf.format(date);
		GregorianCalendar gc = new GregorianCalendar();
		gc.setTime(convertStringToDate(str));
		return gc;
	}

	/**
	 * 현재 날짜 return
	 * @param aDate
	 * @return
	 */
	public static final String convertDateToString(Date date) {
		return getDate(date, datePattern);
	}

	/**
	 * String형식의 날짜를 default datePatten형식으로 return
	 * @param strDate
	 * @return
	 * @throws ParseException
	 */
	public static Date convertStringToDate(String str) throws ParseException {
		Date date = null;
		try {

			date = convertStringToDate(datePattern, str);
		} catch (ParseException pe) {

			//pe.printStackTrace();
			throw new ParseException("", pe.getErrorOffset());
		}
		return date;
	}

	public static String getLastMonthDay(String str) {
		Calendar calendar = Calendar.getInstance();
		calendar.set(Integer.parseInt(str.substring(0, 4)), Integer.parseInt(str.substring(4, 6)) - 1, Integer.parseInt(str.substring(6, 8)));
		int i = calendar.getActualMaximum(5);
		calendar.set(5, i);
		return getDate(calendar.getTime());
	}

	/**
	 * java.sql.TimeStamp를 return
	 * @return
	 */
	public static Timestamp getTimeStamp() {
		return new Timestamp((new Date()).getTime());
	}

	public static Timestamp getTimeStamp(String str) {
		int i = Integer.parseInt(str.substring(0, 4));
		int j = Integer.parseInt(str.substring(4, 6)) - 1;
		int k = Integer.parseInt(str.substring(6, 8));
		int l = Integer.parseInt(str.substring(8, 10));
		int i1 = Integer.parseInt(str.substring(10, 12));
		int j1 = Integer.parseInt(str.substring(12, 14));
		GregorianCalendar gc = new GregorianCalendar();
		gc.set(i, j, k, l, i1, j1);
		return new Timestamp(gc.getTimeInMillis());
	}

	/**
	 * 년도 목록 생성
	 * */
	public static List<String> getYearList(int startYr,int lastYr){
		List<String> yearList = new ArrayList<>();

		int defaultStartYr = 2000;

		if(Validate.isEmpty(startYr)){
			startYr = defaultStartYr;
		}

		for(int i=lastYr; i>=startYr; i--){
			yearList.add(String.valueOf(i));
		}

		return yearList;
	}

	/**
	 * 월 목록 생성
	 * */
	public static List<String> getMonthList(){
		List<String> monthList = new ArrayList<>();
		String temp = "";
		for(int i = 1; i < 13; i++) {
			if(i < 10) {
				temp = "0"+i;
			}else {
				temp = String.valueOf(i);
			}
			monthList.add(temp);
		}
		return monthList;
	}

	/**
	 * 올해년도 조회
	 * */
	public static String getThisYear() {
		String thisYear = "";

		SimpleDateFormat yymmFm = new SimpleDateFormat("yyyy");
		Calendar today = Calendar.getInstance();
		thisYear = yymmFm.format(today.getTime());

		return thisYear;
	}

}
