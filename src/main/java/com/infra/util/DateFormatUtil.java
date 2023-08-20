package com.infra.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import com.infra.util.Validate;

/**
 * <p>
 * 날짜와 시간을 포맷하는데 필요한 유틸리티 클래스.
 * </p>
 * ※ 참고<br/>
 * 1. TimeZone : 그리니치 표준시간(GMT)를 기준으로 각 지역이 위치한 경도에 따라<br/>
 * 시간의 차이가 있다. 이러한 동일한 시간대를 지역을 동일한 timezone을 가진다고 말한다.<br/>
 * 2. UTC(Universal Time Coordinated) : 지역 표준시를 말하며, GMT(그리니치 표준시)라고도 한다.<br/>
 * 1970년 1월 1일 자정부터 시간이 계산된다. * 
 * 
 */
public final class DateFormatUtil {

    /** SimpleDateFormat. <tt>yyyyMMddHHmmssSSS</tt>. */
    public static final SimpleDateFormat ISO_MSEC_FORMAT = new SimpleDateFormat("yyyyMMddHHmmssSSS");

    /** SimpleDateFormat. <tt>yyyyMMddHHmmss</tt>. */
    public static final SimpleDateFormat ISO_FULL_FORMAT = new SimpleDateFormat("yyyyMMddHHmmss");

    /** SimpleDateFormat. <tt>yyyyMMdd</tt>. */
    public static final SimpleDateFormat ISO_SHORT_FORMAT = new SimpleDateFormat("yyyyMMdd");

    /** SimpleDateFormat. <tt>yyyy-MM-dd HH:mm:ss</tt>. */
    public static final SimpleDateFormat KR_FULL_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    /** SimpleDateFormat. <tt>yyyy-MM-dd</tt>. */
    public static final SimpleDateFormat KR_SHORT_FORMAT = new SimpleDateFormat("yyyy-MM-dd");

    /**
     * Instantiates a new date format util.
     */
    private DateFormatUtil() {
    }

    /**
     * <p>
     * 오늘 날짜를 yyyyMMddHHmmss 형식으로 얻는다.
     * </p>
     * 
     * @return 포맷된 날짜 (yyyyMMddHHmmss)
     */
    public static String getToday() {
        return getTodayFull();
    }

    /**
     * <p>
     * 오늘 날짜를 yyyyMMddHHmmss 형식으로 얻는다.
     * </p>
     * 
     * @return 포맷된 날짜 (yyyyMMddHHmmss)
     */
    public static String getTodayFull() {
        return ISO_FULL_FORMAT.format(new Date());
    }

    /**
     * <p>
     * 오늘 날짜를 yyyyMMddHHmmssSSS 형식으로 얻는다.
     * </p>
     * 
     * @return 포맷된 날짜 (yyyyMMddHHmmssSSS)
     */
    public static String getTodayMsec() {
        return ISO_MSEC_FORMAT.format(new Date());
    }

    /**
     * <p>
     * 오늘 날짜를 yyyyMMdd 형식으로 얻는다.
     * </p>
     * 
     * @return 포맷된 날짜 (yyyyMMdd)
     */
    public static String getTodayShort() {
        return ISO_SHORT_FORMAT.format(new Date());
    }

    /**
     * <p>
     * 오늘 날짜를 yyyy-MM-dd 형식으로 얻는다.
     * </p>
     * 
     * @return 포맷된 날짜 (yyyy-MM-dd)
     */
    public static String getTodayShortKr() {
        return KR_SHORT_FORMAT.format(new Date());
    }

    /**
     * <p>
     * 지정한 날짜를 yyyy-MM-dd HH:mm:ss 형식으로 얻는다.
     * </p>
     * 
     * @param date the date
     * @return 포맷된 날짜 (yyyy-MM-dd HH:mm:ss)
     */
    public static String getDateFull(Date date) {
        return KR_FULL_FORMAT.format(date);
    }

    /**
     * <p>
     * 지정한 날짜를 yyyyMMdd 형식으로 얻는다.
     * </p>
     * 
     * @param date the date
     * @return 포맷된 날짜 (yyyy-MM-dd)
     */
    public static String getDateShort(Date date) {
        return KR_SHORT_FORMAT.format(date);
    }

    /**
     * <p>
     * 지정된 날짜 문자열(14자리)에 대해 yyyy년 MM월 dd일 a hh시 mm분 ss초 형식으로 전환한다.
     * </p>
     * 
     * @param str the str
     * @return 포맷된 날짜 (yyyy년 MM월 dd일 오전/오후 hh시 mm분 ss초)
     */
    public static String parseDateFull(String str) {

        return getFormatedDateKR(str, true);
    }

    /**
     * <p>
     * 지정된 날짜 문자열(14자리)에 대해 yyyy년 MM월 dd일 형식으로 전환한다.
     * </p>
     * 
     * @param str the str
     * @return 포맷된 날짜 (yyyy년 MM월 dd일)
     */
    public static String parseDateShort(String str) {

        return getFormatedDateKR(str, false);
    }

    /**
     * <p>
     * 지정된 날짜 문자열(6, 8, 14자리)에 대해 [yyyy년 MM월 dd일 hh시 mm분 ss초] 형식으로 전환한다.
     * </p>
     * 기존 parseDateFull(), parseDateShort() 에서 java.lang.NumberFormatException
     * 발생<br/>
     * java forum 검색결과 SimpleDateFormat의 비동기화 메소드일 가능성이라고 함.<br/>
     * fixed by wisepms 2006-08-22
     * 
     * @param date the date
     * @param isFull the is full
     * @return 포맷된 날짜 (yyyy년 MM월 dd일 hh시 mm분 ss초)
     */
    private static String getFormatedDateKR(String date, boolean isFull) {

        if(date == null) {
            return "";
        }
        if(date.length() == 0) {
            return date;
        }
        if(!Validate.isAlphaNumeric(date)) {
            return date;
        }

        StringBuffer buff = new StringBuffer();
        int length = date.trim().length();

        if(length == 6) {
            buff.append(date.substring(0, 2) + "년 ");
            buff.append(date.substring(2, 4) + "월 ");
            buff.append(date.substring(4, 6) + "일");
        } else if(length == 8) {
            buff.append(date.substring(0, 4) + "년 ");
            buff.append(date.substring(4, 6) + "월 ");
            buff.append(date.substring(6, 8) + "일");
        } else if(length == 14) {
            buff.append(date.substring(0, 4) + "년 ");
            buff.append(date.substring(4, 6) + "월 ");
            buff.append(date.substring(6, 8) + "일 ");

            if(isFull) {
                buff.append(date.substring(8, 10) + "시 ");
                buff.append(date.substring(10, 12) + "분 ");
                buff.append(date.substring(12, 14) + "초");
            }
        } else {
            return date;
        }

        return buff.toString();
    }

    /**
     * <p>
     * 지정된 날짜 문자열(14자리)에 대해 yyyy-MM-dd hh:mm:ss 형식으로 전환한다.
     * </p>
     * 
     * @param str the str
     * @return 포맷된 날짜 (yyyy-MM-dd hh:mm:ss)
     */
    public static String parseDateFullISO(String str) {

        return getFormatedDateISO(str, true);
    }

    /**
     * <p>
     * 지정된 날짜 문자열(14자리)에 대해 yyyy-MM-dd 형식으로 전환한다.
     * </p>
     * 
     * @param str the str
     * @return 포맷된 날짜 (yyyy-MM-dd)
     */
    public static String parseDateShortISO(String str) {

        return getFormatedDateISO(str, false);
    }

    /**
     * <p>
     * 지정된 날짜 문자열(6, 8, 14자리)에 대해 yyyy-MM-dd hh:mm:ss 형식으로 전환한다.
     * </p>
     * 기존 parseDateFullISO(), parseDateShortISO() 에서
     * java.lang.NumberFormatException 발생<br/>
     * java forum 검색결과 SimpleDateFormat의 비동기화 메소드일 가능성이라고 함.<br/>
     * fixed by wisepms 2006-08-22
     * 
     * @param date the date
     * @param isFull the is full
     * @return 포맷된 날짜 (yyyy-MM-dd hh:mm:ss)
     */
    private static String getFormatedDateISO(String date, boolean isFull) {

        if(date == null) {
            return "";
        }
        if(date.length() == 0) {
            return date;
        }
        if(!Validate.isAlphaNumeric(date)) {
            return date;
        }

        StringBuffer buff = new StringBuffer();
        int length = date.trim().length();

        if(length == 6) {
            buff.append(date.substring(0, 2) + "-");
            buff.append(date.substring(2, 4) + "-");
            buff.append(date.substring(4, 6));
        } else if(length == 8) {
            buff.append(date.substring(0, 4) + "-");
            buff.append(date.substring(4, 6) + "-");
            buff.append(date.substring(6, 8));
        } else if(length == 14) {
            buff.append(date.substring(0, 4) + "-");
            buff.append(date.substring(4, 6) + "-");
            buff.append(date.substring(6, 8) + " ");

            if(isFull) {
                buff.append(date.substring(8, 10) + ":");
                buff.append(date.substring(10, 12) + ":");
                buff.append(date.substring(12, 14));
            }
        } else {
            return date;
        }

        return buff.toString().trim();
    }

    /**
     * Gets the date string. (yyyyMMdd)
     * 
     * @param calendar the calendar
     * @return the date string
     */
    public static String getDateString(Calendar calendar) {

        String returnVal = String.valueOf(calendar.get(Calendar.YEAR));

        int thisMonth = calendar.get(Calendar.MONTH) + 1;

        if(thisMonth < 10) {
            returnVal += "0";
        }

        returnVal += String.valueOf(thisMonth);

        int thisDate = calendar.get(Calendar.DATE);

        if(thisDate < 10) {
            returnVal += "0";
        }

        returnVal += String.valueOf(thisDate);

        return returnVal;
    }

    public static Date toDateShort(String textDate) {

        return toDate(ISO_SHORT_FORMAT, textDate);
    }

    public static Date toDateFull(String textDate) {

        return toDate(ISO_FULL_FORMAT, textDate);
    }

    public static Date toKrDateShort(String textDate) {

        return toDate(KR_SHORT_FORMAT, textDate);
    }

    public static Date toKrDateFull(String textDate) {

        return toDate(KR_FULL_FORMAT, textDate);
    }

    public static Date toDate(SimpleDateFormat format, String textDate) {

        try {
            return format.parse(textDate);
        } catch (ParseException ex) {
            return new Date();
        }
    }

    /**
     * 입력 날짜의 calendar 인스턴스를 얻는다.
     * 
     * @param dateStr
     * @return
     */
    public static Calendar getCalendarObj(String dateStr) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(toDate(ISO_SHORT_FORMAT, dateStr));
        return cal;
    }
}
