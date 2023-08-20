package com.infra.util;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ibm.icu.text.DecimalFormat;
import com.ibm.icu.util.ChineseCalendar;

public class BsnDayUtil
{
	private static final Logger logger = LoggerFactory.getLogger(BsnDayUtil.class);

	//양력공휴일
    private static String[] solarArr = new String[]{"0101", "0301", "0505", "0606", "0815", "1225"};
    //음력공휴일
    private static String[] lunarArr = new String[]{"0101", "0102", "0408", "0814", "0815", "0816"};


    /**
     * 해당일자가 법정공휴일, 대체공휴일, 토요일, 일요일인지 확인
     * @param date 양력날짜 (yyyyMMdd)
     * @return 법정공휴일, 대체공휴일, 일요일이면 true, 오류시 false
     */

    public static boolean isHoliday(String date) {
        try {
            return isHolidaySolar(date) || isHolidayLunar(date) || isHolidayAlternate(date) || isWeekend(date);
        } catch (ParseException e) {
            //e.printStackTrace();
        	logger.error("", e);
            return false;
        }
    }

    /**
     * 영업일 이후 날짜 구하기
     * @param bDay 영업일 , date 기준날짜 (yyyyMMdd);
     * @return 영업일 이후 날짜
     * */
    public static Date isBusinessDay(int bDay , String date) {
    	Date businessDay = null;

	   	 int weekDayCheck = 0;
	   	 int plusCnt = 0;

	   	 for(int i = 1; i < 30; i++) {
	   		 Integer intDate = Integer.parseInt(date) + i;
	   		 if(!isHoliday(String.valueOf(intDate))) weekDayCheck++;
	   		 if(weekDayCheck == bDay) {
	   			 plusCnt = i;
	   			 break;
	   		 }
	   	 }

	   	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		Calendar cal = Calendar.getInstance();
		try {
			cal.setTime(sdf.parse(date));
		} catch (ParseException e) {
			//e.printStackTrace();
			logger.error("", e);
		}
		cal.add(Calendar.DATE, plusCnt);
		businessDay = cal.getTime();

    	return businessDay;
    }

    /**
     * 토요일 또는 일요일이면 true를 리턴한다.
     * @param date 양력날짜 (yyyyMMdd)
     * @return 일요일인지 여부
     * @throws ParseException
     */
    private static boolean isWeekend(String date) throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        Calendar cal = Calendar.getInstance();
        cal.setTime(sdf.parse(date));
        return cal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY || cal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY;
    }


    /**
     * 해당일자가 대체공휴일에 해당하는 지 확인
     * @param 양력날짜 (yyyyMMdd)
     * @return 대체 공휴일이면 true
     */
    private static boolean isHolidayAlternate(String date) {
        String[] altHoliday = new String[] {"20100101"};
        return Arrays.asList(altHoliday).contains(date);
    }


    /**
     * 해당일자가 음력 법정공휴일에 해당하는 지 확인
     * @param 양력날짜 (yyyyMMdd)
     * @return 음력 공휴일이면 true
     */
    private static boolean isHolidayLunar(String date) {
        try {
            Calendar cal = Calendar.getInstance();
            ChineseCalendar chinaCal = new ChineseCalendar();

            cal.set(Calendar.YEAR, Integer.parseInt(date.substring(0, 4)));
            cal.set(Calendar.MONTH, Integer.parseInt(date.substring(4, 6)) - 1);
            cal.set(Calendar.DAY_OF_MONTH, Integer.parseInt(date.substring(6)));
            chinaCal.setTimeInMillis(cal.getTimeInMillis());

            // 음력으로 변환된 월과 일자
            int mm = chinaCal.get(ChineseCalendar.MONTH) + 1;
            int dd = chinaCal.get(ChineseCalendar.DAY_OF_MONTH);

            StringBuilder sb = new StringBuilder();
            sb.append(String.format("%02d", mm));
            sb.append(String.format("%02d", dd));

            // 음력 12월의 마지막날 (설날 첫번째 휴일)인지 확인
            if (mm == 12) {
                int lastDate = chinaCal.getActualMaximum(ChineseCalendar.DAY_OF_MONTH);
                if (dd == lastDate) {
                    return true;
                }
            }

            // 음력 휴일에 포함되는지 여부 리턴
            return Arrays.asList(lunarArr).contains(sb.toString());
        } catch(RuntimeException ex) {
        	logger.error("", ex);
            return false;
        } catch(Exception ex) {
        	logger.error("", ex);
            return false;
        }
    }


    /**
     * 해당일자가 양력 법정공휴일에 해당하는 지 확인
     * @param date 양력날짜 (yyyyMMdd)
     * @return 양력 공휴일이면 true
     */
    private static boolean isHolidaySolar(String date) {
        try {
            // 공휴일에 포함 여부 리턴
            return Arrays.asList(solarArr).contains(date.substring(4));
        } catch(RuntimeException ex) {
        	logger.error("", ex);
            return false;
        } catch(Exception ex) {
        	logger.error("", ex);
            return false;
        }
    }

    /**
     * 월등록회차 구하기
     * @param date 입력날짜
     * @return 월등록회차 0,1,2
     * */
    public static int getMtRegistOrd(Date date) throws RuntimeException, Exception {
    	SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyyMMdd");

    	int mtRegistOrd = 0;
    	Date applyDate = yyyyMMdd.parse(yyyyMMdd.format(date));		//시간 제거하기위해서 format -> parse
    	boolean changeYear = false;

		Calendar cal = Calendar.getInstance();
    	cal.setTime(applyDate);

    	int preYear = 0;
		int year = cal.get(cal.YEAR);
		int preMonth = cal.get(cal.MONTH) == 0 ? 12 : cal.get(cal.MONTH);
		String strPreMonth = preMonth < 10 ? "0"+String.valueOf(preMonth) : String.valueOf(preMonth);
		int month = cal.get(cal.MONTH)+1;
		String strMonth = month < 10 ? "0"+String.valueOf(month) : String.valueOf(month);
		int day = cal.get(cal.DATE);

		if(month == 1 && day < 13) {
			preYear = cal.get(cal.YEAR) - 1;
			changeYear = true;
		}

		//Calendar today = Calendar.getInstance();
		//String yyyyMM = yymmFm.format(today.getTime());		//이번달

		String str13 = year + (0 < day && day < 10 ? strPreMonth : strMonth) + "13";								//13일부터
		String str23 = (changeYear ? preYear : year) + (0 < day && day < 10 ? strPreMonth : strMonth) + "23";		//23일부터
		Date date13 = yyyyMMdd.parse(str13);
		Date date23 = yyyyMMdd.parse(str23);
		Date businessEndDay13 = BsnDayUtil.isBusinessDay(7,str13);	//13일의 7영업일 후 날짜
		Date businessEndDay23 = BsnDayUtil.isBusinessDay(7,str23);	//13일의 7영업일 후 날짜

		//월등록회차구할날짜 == 이번달13일
    	if(applyDate.equals(date13)) {
    		mtRegistOrd = 1;
    	}
    	//월등록회차구할날짜 == 이번달13일+7영업일
    	else if(applyDate.equals(businessEndDay13)) {
    		mtRegistOrd = 1;
    	}
    	//월등록회차구할날짜 > 이번달13일 && 월등록회차구할날짜 < 이번달23일
    	else if(applyDate.after(date13) && applyDate.before(date23)) {
    		mtRegistOrd = 1;
    	}
    	//월등록회차구할날짜 == 이번달23일
    	else if(applyDate.equals(date23)) {
    		mtRegistOrd = 2;
    	}
    	//월등록회차구할날짜 == 이번달23일+7영업일
    	else if(applyDate.equals(businessEndDay23)) {
    		mtRegistOrd = 2;
    	}
    	//월등록회차구할날짜 > 이번달23일 && 월등록회차구할날짜 > 이번달23일+7영업일
    	else if(applyDate.after(date23) && applyDate.before(businessEndDay23)) {
    		mtRegistOrd = 2;
    	}
    	else {
    		mtRegistOrd = 0;
    	}

    	return mtRegistOrd;
    }

    /**
     * 회차로 fromDate , toDate 구하기
     * */
    public static Map getDateFromMtRegistOrd(Date date) throws RuntimeException, Exception {
    	Map dateInfo = new HashMap();
    	DecimalFormat df = new DecimalFormat("00");
    	SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyyMMdd");

    	int mtRegistOrd = 0;
    	Date applyDate = yyyyMMdd.parse(yyyyMMdd.format(date));		//시간 제거하기위해서 format -> parse
    	boolean changeYear = false;

    	Calendar cal = Calendar.getInstance();
    	cal.setTime(applyDate);

    	int preYear = 0;
    	int year = cal.get(cal.YEAR);
    	int preMonth = cal.get(cal.MONTH) == 0 ? 12 : cal.get(cal.MONTH);
    	String strPreMonth = df.format(preMonth);
    	int month = cal.get(cal.MONTH)+1;
    	String strMonth = df.format(month);
    	int day = cal.get(cal.DATE);

		if(month == 1 && day < 13) {
			preYear = cal.get(cal.YEAR) - 1;
			changeYear = true;
		}

    	String str13 = year + (0 < day && day < 10 ? strPreMonth : strMonth) + "13";								//13일부터
    	String str23 = (changeYear ? preYear : year) + (0 < day && day < 10 ? strPreMonth : strMonth) + "23";		//23일부터
    	Date date13 = yyyyMMdd.parse(str13);
    	Date date23 = yyyyMMdd.parse(str23);
    	Date businessEndDay13 = BsnDayUtil.isBusinessDay(7,str13);	//13일의 7영업일 후 날짜
    	Date businessEndDay23 = BsnDayUtil.isBusinessDay(7,str23);	//13일의 7영업일 후 날짜

    	//월등록회차구할날짜 == 이번달13일
    	if(applyDate.equals(date13)) {
    		mtRegistOrd = 1;
    	}
    	//월등록회차구할날짜 == 이번달13일+7영업일
    	else if(applyDate.equals(businessEndDay13)) {
    		mtRegistOrd = 1;
    	}
    	//월등록회차구할날짜 > 이번달13일 && 월등록회차구할날짜 < 이번달23일
    	else if(applyDate.after(date13) && applyDate.before(date23)) {
    		mtRegistOrd = 1;
    	}
    	//월등록회차구할날짜 == 이번달23일
    	else if(applyDate.equals(date23)) {
    		mtRegistOrd = 2;
    	}
    	//월등록회차구할날짜 == 이번달23일+7영업일
    	else if(applyDate.equals(businessEndDay23)) {
    		mtRegistOrd = 2;
    	}
    	//월등록회차구할날짜 > 이번달23일 && 월등록회차구할날짜 > 이번달23일+7영업일
    	else if(applyDate.after(date23) && applyDate.before(businessEndDay23)) {
    		mtRegistOrd = 2;
    	}
    	else {
    		mtRegistOrd = 0;
    	}

    	//해당년도 추가
    	if(changeYear) dateInfo.put("year", preYear);
    	else dateInfo.put("year", year);

    	if(mtRegistOrd == 1) {
    		dateInfo.put("originMtRegistOrd", mtRegistOrd);
    		dateInfo.put("mtRegistOrd", mtRegistOrd);
    		dateInfo.put("month", strMonth);
    		dateInfo.put("from", date13);
    		dateInfo.put("to", businessEndDay13);
    	}else if(mtRegistOrd == 2) {
    		//2일때 day가 13보다 작으면 month -1
    		if(day < 13) dateInfo.put("month", df.format(cal.get(cal.MONTH)));
    		else dateInfo.put("month", strMonth);
    		dateInfo.put("originMtRegistOrd", mtRegistOrd);
    		dateInfo.put("mtRegistOrd", mtRegistOrd);
    		dateInfo.put("from", date23);
    		dateInfo.put("to", businessEndDay23);
    	}else if(mtRegistOrd == 0) {
    		//월등록회차가 0이면서 1일보다 크고 13일보다 작으면 이번달-1
    		if(day >= 1 && day < 13) {
    			dateInfo.put("originMtRegistOrd", mtRegistOrd);
    			dateInfo.put("mtRegistOrd", 2);
    			dateInfo.put("month", df.format(cal.get(cal.MONTH)));
        		dateInfo.put("from", date23);
        		dateInfo.put("to", businessEndDay23);
    		}
    		//월등록회차가 0이면서 13일보다 크고 23일보다 작을떄
    		else if(day > 13 && day < 23) {
    			dateInfo.put("originMtRegistOrd", mtRegistOrd);
    			dateInfo.put("mtRegistOrd", 1);
    			dateInfo.put("month", strMonth);
        		dateInfo.put("from", date13);
        		dateInfo.put("to", businessEndDay13);
    		}
    	}

    	return dateInfo;
    }
}