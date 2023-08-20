package com.infra.util;

import java.util.Calendar;
import java.util.Date;

import com.infra.util.Validate;

/**
 * <p>
 * 날짜 계산에 유용한 여러가지 메소드.
 * </p>
 * 
 * @EXAMPLE public static int[] getMonthDaysArray(int yr) 지정한 연도의 각 달에 포함된 날수의
 *          배열을 구하는 메소드 public static int getDaysInYear(int y) 지정한 연도에 포함된 날수
 *          구하는 메소드 public static int getDaysInMonth(int m, int y) 지정한 연도의 지정한
 *          달에 포함된 날수 구하는 메소드 public static int getDaysFromMonthFirst(int d, int
 *          m, int y) public static int getDaysFromMonthFirst(String s) 지정한 연도의
 *          1월 1일 이후에 경과한 날수 구하는 메소드 만약 지정한 날짜가 유효한 범위를 벗어나면 예외상황을 던진다. public
 *          static int getDaysFromYearFirst(int d, int m, int y) public static
 *          int getDaysFromYearFirst(String s) 지정한 연도의 1월 1일 이후에 경과한 날수 구하는 메소드
 *          public static int getDaysFrom21Century(int d, int m, int y) public
 *          static int getDaysFrom21Century(String s) 2000년 1월 1일 이후에 경과한 날수 구하는
 *          메소드 public static int getDaysBetween(String s1, String s2) 지정한 두 날짜의
 *          (양 끝 제외) 날짜 차이 구하는 메소드 public static int getDaysDiff(String s1,
 *          String s2) 지정한 두 날짜의 날짜 차이 구하는 메소드 public static int
 *          getDaysFromTo(String s1, String s2) 지정한 두 날짜의 (양 끝 포함) 날짜 차이 구하는 메소드
 *          public static int getWeekdaysInMonth(int weekDay, int m, int y)
 *          public static int getWeekdaysInMonth(String weekName, int m, int y)
 *          지정한 연도의 지정한 달에 포함된 지정한 요일의 개수 구하는 메소드 public static String
 *          getDateStringFrom21Century(int elapsed) 2000년 1월 1일 이후 지정한 날수
 *          elapsed 만큼 경과한 날짜를 String 타입으로 구하는 메소드 public static String
 *          addDate(int offset, int d, int m, int y) public static String
 *          addDate(int offset, String date) 지정한 날짜 이후 지정한 날수 offset 만큼 경과한 날짜를
 *          String 타입으로 구하는 메소드 public static int getTimeDiff(String fromTime,
 *          String toTime) 시작날짜와 종료날짜의 시간(초) 차이를 구하는 메소드 [참고 1] 그레고리식 달력은 1582
 *          연도 10월 달력이 비정상적이다. 즉, 10월 4일 다음 날이 10월 15일이었다. 그러므로, 그 달은 열흘이 부족한
 *          21일이 한달이었다. (KBS2TV 스펀지 참조) [참고 2] 영국식 달력은 1752 연도 9월 달력이 비정상적이다. 즉,
 *          9월 2일 다음 날이 9월 14일이었다. 그러므로, 그 달은 열하루가 부족한 19일이 한달이었다.
 * 
 */
public final class DateCalcUtil {

    /** 한글 요일정보 : "일월화수목금토" */
    public final static StringBuffer weekNames1 = new StringBuffer("일월화수목금토");

    /** 한문 요일정보 : "日月火水木金土" */
    public final static StringBuffer weekNames2 = new StringBuffer("日月火水木金土");

    /** 영문 요일정보 : { "sun", "mon", "tue", "wed", "thu", "fri", "sat" } */
    public final static String[] weekNames3 = { "sun", "mon", "tue", "wed", "thu", "fri", "sat" };

    /**
     * 영문 달(月) 정보 : { "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG",
     * "SEP", "OCT", "NOV", "DEC" }
     */
    public final static String[] monthNames = { "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT",
        "NOV", "DEC" };

    /**
     * <p>
     * 지정한 연도의 각 달에 포함된 날수의 배열을 얻는다.
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.getMonthDaysArray(0000) =
     *          {31,29,31,30,31,30,31,31,30,31,30,31}
     *          DateCalcUtil.getMonthDaysArray(1000) =
     *          {31,29,31,30,31,30,31,31,30,31,30,31}
     *          DateCalcUtil.getMonthDaysArray(2005) =
     *          {31,28,31,30,31,30,31,31,30,31,30,31}
     *          DateCalcUtil.getMonthDaysArray(2006) =
     *          {31,28,31,30,31,30,31,31,30,31,30,31}
     * @param yr 대상 연도 정수값 (yyyy)
     * @return 지정 연도에 대한 월별 날짜수 배열
     */
    public static int[] getMonthDaysArray(int yr) {
        int[] a1 = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
        int[] a2 = { 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };

        if(yr <= 1582) {
            if((yr % 4) == 0) {
                if(yr == 4) {
                    return a1;
                }
                return a2;
            }
        } else {
            if(((yr % 4) == 0) && ((yr % 100) != 0)) {
                return a2;
            } else if((yr % 400) == 0) {
                return a2;
            }
        }

        return a1;
    }

    /**
     * <p>
     * 지정된 연도와 달에 따른 요일 편차를 구한다.
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.addWeekDays(1, 2005) = 0
     *          DateCalcUtil.addWeekDays(2, 2005) = 3
     *          DateCalcUtil.addWeekDays(11, 2005) = 24
     *          DateCalcUtil.addWeekDays(12, 2005) = 26
     * @param m 대상 월 정수값 (mm)
     * @param y 대상 연도 정수값 (yyyy)
     * @return 지정 연도, 달에 대한 요일 편차
     */
    public static int addWeekDays(int m, int y) {
        int[] b1 = { 3, 0, 3, 2, 3, 2, 3, 3, 2, 3, 2, 3 };
        int[] b2 = { 3, 1, 3, 2, 3, 2, 3, 3, 2, 3, 2, 3 };
        int i = 0;
        int rval = 0;

        if(y <= 1582) {
            if((y % 4) == 0) {
                if(y == 4) {
                    for(i = 0 ; i < m - 1 ; i++) {
                        rval += b1[i];
                    }
                } else {
                    for(i = 0 ; i < m - 1 ; i++) {
                        rval += b2[i];
                    }
                }
            } else {
                for(i = 0 ; i < m - 1 ; i++) {
                    rval += b1[i];
                }
            }
        } else {
            if(((y % 4) == 0) && ((y % 100) != 0)) {
                for(i = 0 ; i < m - 1 ; i++) {
                    rval += b2[i];
                }
            } else if((y % 400) == 0) {
                for(i = 0 ; i < m - 1 ; i++) {
                    rval += b2[i];
                }
            } else {
                for(i = 0 ; i < m - 1 ; i++) {
                    rval += b1[i];
                }
            }
        }

        return rval;
    }

    /**
     * <p>
     * 지정한 연도의 총 날짜 수를 구한다.
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.getDaysInYear(2002) = 365
     *          DateCalcUtil.getDaysInYear(2003) = 365
     *          DateCalcUtil.getDaysInYear(2004) = 365
     *          DateCalcUtil.getDaysInYear(2005) = 365
     * @param y 대상 연도 정수값 (yyyy)
     * @return 지정한 연도의 총 날짜 수
     */
    public static int getDaysInYear(int y) {
        if(y > 1582) {
            if(y % 400 == 0) {
                return 366;
            } else if(y % 100 == 0) {
                return 365;
            } else if(y % 4 == 0) {
                return 366;
            } else {
                return 365;
            }
        } else if(y == 1582) {
            return 355;
        } else if(y > 4) {
            if(y % 4 == 0) {
                return 366;
            } else {
                return 365;
            }
        } else if(y > 0) {
            return 365;
        } else {
            return 0;
        }
    }

    /**
     * <p>
     * 지정한 연도, 지정한 월의 총 날짜 수를 구한다.
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.getDaysInMonth(1, 2005) = 31
     *          DateCalcUtil.getDaysInMonth(2, 2005) = 28
     *          DateCalcUtil.getDaysInMonth(3, 2005) = 31
     *          DateCalcUtil.getDaysInMonth(4, 2005) = 30
     * @param m 대상 월 정수값 (mm)
     * @param y 대상 연도 정수값 (yyyy)
     * @return 지정한 연도의 총 날짜 수
     * @exception RuntimeException 대상 월이 1보다 작거나 12보다 클 때 발생.
     */
    public static int getDaysInMonth(int m, int y) {
        if(m < 1 || m > 12) {
            throw new RuntimeException("Invalid month: " + m);
        }

        int[] b = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
        if(m != 2 && m >= 1 && m <= 12 && y != 1582) {
            return b[m - 1];
        }
        if(m != 2 && m >= 1 && m <= 12 && y == 1582) {
            if(m != 10) {
                return b[m - 1];
            } else {
                return b[m - 1] - 10;
            }
        }

        if(m != 2) {
            return 0;
        }

        // m == 2 (즉 2월)
        if(y > 1582) {
            if(y % 400 == 0) {
                return 29;
            } else if(y % 100 == 0) {
                return 28;
            } else if(y % 4 == 0) {
                return 29;
            } else {
                return 28;
            }
        } else if(y == 1582) {
            return 28;
        } else if(y > 4) {
            if(y % 4 == 0) {
                return 29;
            } else {
                return 28;
            }
        } else if(y > 0) {
            return 28;
        } else {
            throw new RuntimeException("Invalid year: " + y);
        }
    }

    /**
     * <p>
     * 지정한 연도, 월의 첫날 부터 ~ 지정한 날 까지의 날짜 수를 구한다.
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.getDaysFromMonthFirst(1, 1, 2005) = 1
     *          DateCalcUtil.getDaysFromMonthFirst(2, 1, 2005) = 2
     *          DateCalcUtil.getDaysFromMonthFirst(10, 1, 2005) = 10
     *          DateCalcUtil.getDaysFromMonthFirst(20, 1, 2005) = 20
     * @param d 대상 날짜 정수값 (dd)
     * @param m 대상 월 정수값 (mm)
     * @param y 대상 연도 정수값 (yyyy)
     * @return 계산된 날짜 수
     * @exception RuntimeException 대상 월이 1보다 작거나 12보다 클 때 발생, 대상 날짜가 지정 월의 최대값보다
     *            클 때 발생.
     */
    public static int getDaysFromMonthFirst(int d, int m, int y) {
        if(m < 1 || m > 12) {
            throw new RuntimeException("Invalid month " + m + " in " + d + "/" + m + "/" + y);
        }

        int max = getDaysInMonth(m, y);
        if(d >= 1 && d <= max) {
            return d;
        } else {
            throw new RuntimeException("Invalid date " + d + " in " + d + "/" + m + "/" + y);
        }
    }

    /**
     * <p>
     * 지정한 연도의 첫날 부터 ~ 지정한 월의 지정한 날 까지의 날짜 수를 구한다.
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.getDaysFromYearFirst(1, 2, 2005) = 32
     *          DateCalcUtil.getDaysFromYearFirst(2, 2, 2005) = 33
     *          DateCalcUtil.getDaysFromYearFirst(10, 2, 2005) = 41
     *          DateCalcUtil.getDaysFromYearFirst(20, 2, 2005) = 51
     * @param d 대상 날짜 정수값 (dd)
     * @param m 대상 월 정수값 (mm)
     * @param y 대상 연도 정수값 (yyyy)
     * @return 계산된 날짜 수
     * @exception RuntimeException 대상 월이 1보다 작거나 12보다 클 때 발생, 대상 날짜가 지정 월의 최대값보다
     *            클 때 발생.
     */
    public static int getDaysFromYearFirst(int d, int m, int y) {
        if(m < 1 || m > 12) {
            throw new RuntimeException("Invalid month " + m + " in " + d + "/" + m + "/" + y);
        }

        int max = getDaysInMonth(m, y);
        if(d >= 1 && d <= max) {
            int sum = d;
            for(int j = 1 ; j < m ; j++) {
                sum += getDaysInMonth(j, y);
            }
            return sum;
        } else {
            throw new RuntimeException("Invalid date " + d + " in " + d + "/" + m + "/" + y);
        }
    }

    /**
     * <p>
     * 지정한 연도의 1월 1일 이후에 경과한 날수 구하는 메소드
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.getDaysFromMonthFirst("01-Jan-2005") = 1
     *          DateCalcUtil.getDaysFromMonthFirst("2005-01-01") = 2
     *          DateCalcUtil.getDaysFromMonthFirst("2005/01/02") = 3
     *          DateCalcUtil.getDaysFromMonthFirst("20050103") = 4
     * @param s 대상 연월일
     * @return 계산된 날짜 수
     * @exception RuntimeException 지정한 날짜가 유효한 범위를 벗어나면 발생.
     */
    public static int getDaysFromMonthFirst(String s) {
        int d, m, y;
        if(s.length() == 8) {
            y = Integer.parseInt(s.substring(0, 4));
            m = Integer.parseInt(s.substring(4, 6));
            d = Integer.parseInt(s.substring(6));

            return getDaysFromMonthFirst(d, m, y);
        } else if(s.length() == 10) {
            y = Integer.parseInt(s.substring(0, 4));
            m = Integer.parseInt(s.substring(5, 7));
            d = Integer.parseInt(s.substring(8));

            return getDaysFromMonthFirst(d, m, y);
        } else if(s.length() == 11) {
            d = Integer.parseInt(s.substring(0, 2));
            String strM = s.substring(3, 6).toUpperCase();

            m = 0;
            for(int j = 1 ; j <= 12 ; j++) {
                if(strM.equals(monthNames[j - 1])) {
                    m = j;
                    break;
                }
            }
            if(m < 1 || m > 12) {
                throw new RuntimeException("Invalid month name: " + strM + " in " + s);
            }

            y = Integer.parseInt(s.substring(7));

            return getDaysFromMonthFirst(d, m, y);
        } else {
            throw new RuntimeException("Invalid date format: " + s);
        }
    }

    /**
     * <p>
     * 지정한 연도의 첫날 부터 ~ 지정한 월의 지정한 날 까지의 날짜 수를 구한다.
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.getDaysFromYearFirst("01-Jan-2005") = 1
     *          DateCalcUtil.getDaysFromYearFirst("2005-01-02") = 2
     *          DateCalcUtil.getDaysFromYearFirst("2005/01/03") = 3
     *          DateCalcUtil.getDaysFromYearFirst("20050104") = 4
     * @param s 대상 연월일
     * @return 계산된 날짜 수
     * @exception RuntimeException 지정한 날짜가 유효한 범위를 벗어나면 발생.
     */
    public static int getDaysFromYearFirst(String s) {
        int d, m, y;
        if(s.length() == 8) {
            y = Integer.parseInt(s.substring(0, 4));
            m = Integer.parseInt(s.substring(4, 6));
            d = Integer.parseInt(s.substring(6));
            return getDaysFromYearFirst(d, m, y);
        } else if(s.length() == 10) {
            y = Integer.parseInt(s.substring(0, 4));
            m = Integer.parseInt(s.substring(5, 7));
            d = Integer.parseInt(s.substring(8));
            return getDaysFromYearFirst(d, m, y);
        } else if(s.length() == 11) {
            d = Integer.parseInt(s.substring(0, 2));
            String strM = s.substring(3, 6).toUpperCase();

            m = 0;
            for(int j = 1 ; j <= 12 ; j++) {
                if(strM.equals(monthNames[j - 1])) {
                    m = j;
                    break;
                }
            }
            if(m < 1 || m > 12) {
                throw new RuntimeException("Invalid month name: " + strM + " in " + s);
            }
            y = Integer.parseInt(s.substring(7));
            return getDaysFromYearFirst(d, m, y);
        } else {
            throw new RuntimeException("Invalid date format: " + s);
        }
    }

    /**
     * <p>
     * 21세기(2000년 1월 1일) 부터 지정한 년, 월, 일 까지의 날짜 수를 구한다.
     * </p>
     * <p>
     * 21세기(2000년 1월 1일) 이전의 경우에는 음수를 리턴한다.
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.getDaysFrom21Century(31, 12, 1998) = -366
     *          DateCalcUtil.getDaysFrom21Century(31, 12, 1999) = -1
     *          DateCalcUtil.getDaysFrom21Century(1, 1, 2000) = 0
     *          DateCalcUtil.getDaysFrom21Century(1, 1, 2001) = 366
     * @param d 대상 날짜 정수값 (dd)
     * @param m 대상 월 정수값 (mm)
     * @param y 대상 연도 정수값 (yyyy)
     * @return 계산된 날짜 수
     * @exception RuntimeException 대상 연도가 0보다 작을 때 발생
     */
    public static int getDaysFrom21Century(int d, int m, int y) {
        if(y >= 2000) {
            int sum = getDaysFromYearFirst(d, m, y);
            for(int j = y - 1 ; j >= 2000 ; j--) {
                sum += getDaysInYear(j);
            }
            return sum - 1;
        } else if(y > 0 && y < 2000) {
            int sum = getDaysFromYearFirst(d, m, y);
            for(int j = 1999 ; j >= y ; j--) {
                sum -= getDaysInYear(y);
            }
            return sum - 1;
        } else {
            throw new RuntimeException("Invalid year " + y + " in " + d + "/" + m + "/" + y);
        }
    }

    /**
     * <p>
     * 21세기(2000년 1월 1일) 부터 지정한 년, 월, 일 까지의 날짜 수를 구한다.
     * </p>
     * <p>
     * 21세기(2000년 1월 1일) 이전의 경우에는 음수를 리턴한다.
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.getDaysFrom21Century("19981231") = -366
     *          DateCalcUtil.getDaysFrom21Century("21-Dec-1999") = -1
     *          DateCalcUtil.getDaysFrom21Century("2000/01/01") = 0
     *          DateCalcUtil.getDaysFrom21Century("2001-01-01") = 366
     * @param s 대상 연월일
     * @return 계산된 날짜 수
     * @exception RuntimeException 대상 연도가 0보다 작을 때 발생
     */
    public static int getDaysFrom21Century(String s) {
        int d, m, y;
        if(s.length() == 8 || s.length() == 14) {
            y = Integer.parseInt(s.substring(0, 4));
            m = Integer.parseInt(s.substring(4, 6));
            d = Integer.parseInt(s.substring(6, 8));
            return getDaysFrom21Century(d, m, y);
        } else if(s.length() == 10) {
            y = Integer.parseInt(s.substring(0, 4));
            m = Integer.parseInt(s.substring(5, 7));
            d = Integer.parseInt(s.substring(8));
            return getDaysFrom21Century(d, m, y);
        } else if(s.length() == 11) {
            d = Integer.parseInt(s.substring(0, 2));
            String strM = s.substring(3, 6).toUpperCase();

            m = 0;
            for(int j = 1 ; j <= 12 ; j++) {
                if(strM.equals(monthNames[j - 1])) {
                    m = j;
                    break;
                }
            }
            if(m < 1 || m > 12) {
                throw new RuntimeException("Invalid month name: " + strM + " in " + s);
            }
            y = Integer.parseInt(s.substring(7));
            return getDaysFrom21Century(d, m, y);
        } else {
            throw new RuntimeException("Invalid date format: " + s);
        }
    }

    /**
     * <p>
     * 날짜간 차이 구하기.
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.getDaysDiff("20050101", "2005-01-01") = 0
     *          DateCalcUtil.getDaysDiff("20050102", "2005/01/01") = 1
     *          DateCalcUtil.getDaysDiff("20050103", "01-Jan-2005") = 2
     *          DateCalcUtil.getDaysDiff("20050104", "20050101") = 3
     * @param s1 기준 대상 날짜
     * @param s2 비교 대상 날짜
     * @return 날짜 차이
     */
    public static int getDaysDiff(String s1, String s2) {
        int y1 = getDaysFrom21Century(s1);
        int y2 = getDaysFrom21Century(s2);
        return y1 - y2;
    }

    /**
     * <p>
     * 지정한 연도의 지정한 달에 지정한 요일이 들어 있는 회수를 구한다.
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.getWeekdaysInMonth(1, 1, 2005) = 5 // 2005년 1월의 일요일
     *          수 DateCalcUtil.getWeekdaysInMonth(2, 1, 2005) = 5 // 2005년 1월의
     *          월요일 수 DateCalcUtil.getWeekdaysInMonth(6, 1, 2005) = 4 // 2005년
     *          1월의 금요일 수 DateCalcUtil.getWeekdaysInMonth(7, 1, 2005) = 5 //
     *          2005년 1월의 토요일 수
     * @param weekDay 요일 정수값 (1 : 일, 2 : 월, .... , 7 : 토)
     * @param m 대상 월 (mm)
     * @param y 대상 연도 (yyyy)
     * @return 해당하는 요일 수
     */
    public static int getWeekdaysInMonth(int weekDay, int m, int y) {
        int week = ((weekDay - 1) % 7);
        int days = getDaysInMonth(m, y);
        int sum = 6; // 2000년 1월 1일은 토요일
        if(y >= 2000) {
            for(int i = 2000 ; i < y ; i++) {
                sum += getDaysInYear(i);
            }
        } else {
            for(int i = y ; i < 2000 ; i++) {
                sum -= getDaysInYear(i);
            }
        }
        for(int i = 1 ; i < m ; i++) {
            sum += getDaysInMonth(i, y);
        }

        // if (sum < 0)
        // sum += 350*3000;

        int firstWeekDay = sum % 7;
        if(firstWeekDay < 0) {
            firstWeekDay += 7;
        }

        // firstWeekDay += 1;
        int n = firstWeekDay + days;
        int counter = (n / 7) + (((n % 7) > week) ? 1 : 0);
        if(firstWeekDay > week) {
            counter--;
        }

        return counter;
    }

    /**
     * <p>
     * 지정한 연도의 지정한 달에 지정한 요일이 들어 있는 회수를 구한다.
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.getWeekdaysInMonth("일", 1, 2005) = 5
     *          DateCalcUtil.getWeekdaysInMonth("月", 1, 2005) = 5
     *          DateCalcUtil.getWeekdaysInMonth("sat", 1, 2005) = 5
     *          DateCalcUtil.getWeekdaysInMonth("토", 1, 2005) = 5
     * @param weekName 요일명
     * @param m 대상 월 (mm)
     * @param y 대상 연도 (yyyy)
     * @return 해당하는 요일 수
     */
    public static int getWeekdaysInMonth(String weekName, int m, int y) {

        int n = weekNames1.indexOf(weekName);
        if(n < 0) {
            n = weekNames2.indexOf(weekName);
        }
        if(n < 0) {
            String str = weekName.toLowerCase();
            for(int i = 0 ; i < weekNames3.length ; i++) {
                if(str.equals(weekNames3[i])) {
                    n = i;
                    break;
                }
            }
        }

        if(n < 0) {
            throw new RuntimeException("Invalid week name: " + weekName);
        }

        return getWeekdaysInMonth(n + 1, m, y);
    }

    /**
     * <p>
     * 2000년 1월 1일 기준을 n일 경과한 날짜를 얻는다.
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.getDateStringFrom21Century(1) = 20000102
     *          DateCalcUtil.getDateStringFrom21Century(2) = 20000103
     *          DateCalcUtil.getDateStringFrom21Century(3) = 20000104
     *          DateCalcUtil.getDateStringFrom21Century(4) = 20000105
     * @param elapsed 더할 날짜 정수값 (dd)
     * @return yyyymmdd 양식의 문자열
     */
    public static String getDateStringFrom21Century(int elapsed) {
        return getDateStringFrom21Century(elapsed, StringUtil.EMPTY);
    }

    /**
     * <p>
     * 2000년 1월 1일 기준을 n일 경과한 날짜를 얻는다.
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.getDateStringFrom21Century(1, "") = 20000102
     *          DateCalcUtil.getDateStringFrom21Century(2, "-") = 2000-01-03
     *          DateCalcUtil.getDateStringFrom21Century(3, "/") = 2000/01/04
     *          DateCalcUtil.getDateStringFrom21Century(4, ":") = 2000:01:05
     * @param elapsed 더할 날짜 정수값 (dd)
     * @param delimiter 날짜 구분자
     * @return 지정한 구분자로 구분된 날짜
     */
    public static String getDateStringFrom21Century(int elapsed, String delimiter) {
        int y = 2000;
        int m = 1;
        int d = 1;

        int n = elapsed + 1;
        int j = 2000;
        if(n > 0) {
            while(n > getDaysInYear(j)) {
                n -= getDaysInYear(j);
                j++;
            }
            y = j;

            int i = 1;
            while(n > getDaysInMonth(i, y)) {
                n -= getDaysInMonth(i, y);
                i++;
            }
            m = i;
            d = n;
        } else if(n < 0) {
            while(n < 0) {
                n += getDaysInYear(j - 1);
                j--;
            }
            y = j;

            int i = 1;
            while(n > getDaysInMonth(i, y)) {
                n -= getDaysInMonth(i, y);
                i++;
            }
            m = i;
            d = n;
        }

        String strY = "" + y;
        String strM = "";
        String strD = "";

        if(m < 10) {
            strM = "0" + m;
        } else {
            strM = "" + m;
        }

        if(d < 10) {
            strD = "0" + d;
        } else {
            strD = "" + d;
        }

        return strY + delimiter + strM + delimiter + strD;
    }

    /**
     * <p>
     * 지정한 연월일에 대해 특정 일수를 더한 날짜를 얻는다.
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.addDate(10, 1, 1, 2005) = 20050111
     *          DateCalcUtil.addDate(10, 2, 1, 2005) = 20050112
     *          DateCalcUtil.addDate(10, 3, 1, 2005) = 20050113
     *          DateCalcUtil.addDate(10, 4, 1, 2005) = 20050114
     * @param offset 더할 날짜 정수값 (dd)
     * @param d 대상 날짜 정수값 (dd)
     * @param m 대상 월 정수값 (mm)
     * @param y 대상 연도 정수값 (yyyy)
     * @return yyyymmdd 양식의 문자열
     */
    public static String addDate(int offset, int d, int m, int y) {
        return addDate(offset, d, m, y, StringUtil.EMPTY);
    }

    /**
     * <p>
     * 지정한 연월일에 대해 특정 일수를 더한 날짜를 얻는다.
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.addDate(10, 1, 1, 2005, "") = 20050111
     *          DateCalcUtil.addDate(10, 2, 1, 2005, "-") = 2005-01-12
     *          DateCalcUtil.addDate(10, 3, 1, 2005, "/") = 2005/01/13
     *          DateCalcUtil.addDate(10, 4, 1, 2005, ":") = 2005:01:14
     * @param offset 더할 날짜 정수값 (dd)
     * @param d 대상 날짜 정수값 (dd)
     * @param m 대상 월 정수값 (mm)
     * @param y 대상 연도 정수값 (yyyy)
     * @param delimiter 날짜 구분자
     * @return 지정한 구분자로 구분된 날짜
     */
    public static String addDate(int offset, int d, int m, int y, String delimiter) {
        int z = getDaysFrom21Century(d, m, y);
        int n = z + offset;
        return getDateStringFrom21Century(n, delimiter);
    }

    /**
     * <p>
     * 지정한 날짜에 대해 특정 일수를 더한 날짜를 얻는다.
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.addDate(10, "01-Jan-2005") = 20050111
     *          DateCalcUtil.addDate(10, "2005-01-02") = 20050112
     *          DateCalcUtil.addDate(10, "2005/01/03") = 20050113
     *          DateCalcUtil.addDate(10, "20050104") = 20050114
     * @param offset 더할 날짜 정수값 (dd)
     * @param date 대상 연도 문자열
     * @return yyyymmdd 양식의 문자열
     */
    public static String addDate(int offset, String date) {
        return addDate(offset, date, StringUtil.EMPTY);
    }

    /**
     * <p>
     * 지정한 날짜에 대해 특정 일수를 더한 날짜를 얻는다.
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.addDate(10, "01-Jan-2005", "") = 20050111
     *          DateCalcUtil.addDate(10, "2005-01-02", "-") = 2005-01-12
     *          DateCalcUtil.addDate(10, "2005/01/03", "/") = 2005/01/13
     *          DateCalcUtil.addDate(10, "20050104", ":") = 2005:01:14
     * @param offset 더할 날짜 정수값 (dd)
     * @param date 대상 연도 문자열
     * @param delimiter 날짜 구분자
     * @return 지정한 구분자로 구분된 날짜
     */
    public static String addDate(int offset, String date, String delimiter) {
        int z = getDaysFrom21Century(date);
        int n = z + offset;
        return getDateStringFrom21Century(n, delimiter);
    }

    /**
     * <p>
     * 현재 날짜를 기준으로 일간 검색일 기간을 얻는다.
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.getTermDay() = 20050111 ~ 20050111
     * @return String[] 0 : 검색시작일, 1 : 검색종료일
     */
    public static String[] getTermDay() {

        String startDt = DateFormatUtil.getTodayShort();

        return new String[] { startDt, startDt };
    }

    /**
     * <p>
     * 현재 날짜를 기준으로 주간 검색일 기간을 얻는다.
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.getTermWeek() = 20050111 ~ 20050118
     * @return String[] 0 : 검색시작일, 1 : 검색종료일
     */
    public static String[] getTermWeek() {

        Calendar now = Calendar.getInstance();
        int currentDaw = now.get(Calendar.DAY_OF_WEEK);
        if(currentDaw == Calendar.MONDAY) {
            now.add(Calendar.DATE, -1);
        } else {
            now.add(Calendar.DATE, -(currentDaw - 1));
        }

        String startDt = parseCalendar(now.get(Calendar.YEAR), now.get(Calendar.MONTH) + 1, now.get(Calendar.DATE));

        now.add(Calendar.DATE, 6);

        String endDt = parseCalendar(now.get(Calendar.YEAR), now.get(Calendar.MONTH) + 1, now.get(Calendar.DATE));

        return new String[] { startDt, endDt };
    }

    /**
     * <p>
     * 현재 날짜를 기준으로 월간 검색일 기간을 얻는다.
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.getTermMonth() = 20050101 ~ 20050131
     * @return String[] 0 : 검색시작일, 1 : 검색종료일
     */
    public static String[] getTermMonth() {

        Calendar now = Calendar.getInstance();
        int currentYear = now.get(Calendar.YEAR);
        int currentMonth = now.get(Calendar.MONTH) + 1;

        int lastDay = now.getActualMaximum(Calendar.DATE);

        String startDt = parseCalendar(currentYear, currentMonth, StringUtil.ONE);
        String endDt = startDt.substring(0, 6) + lastDay;

        return new String[] { startDt, endDt };
    }

    /**
     * <p>
     * 현재 날짜를 기준으로 연간 검색일 기간을 얻는다.
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.getTermMonth() = 20050101 ~ 20051231
     * @return String[] 0 : 검색시작일, 1 : 검색종료일
     */
    public static String[] getTermYear() {

        Calendar now = Calendar.getInstance();
        int currentYear = now.get(Calendar.YEAR);

        String startDt = parseCalendar(currentYear, StringUtil.ONE, StringUtil.ONE);
        String endDt = parseCalendar(currentYear, 12, 31);

        return new String[] { startDt, endDt };
    }

    public static String parseCalendar(int year, int month, int day) {

        String yyyyMMdd = String.valueOf(year);

        if(month < 10) {
            yyyyMMdd += String.valueOf(StringUtil.ZERO) + month;
        } else {
            yyyyMMdd += String.valueOf(month);
        }

        if(day < 10) {
            yyyyMMdd += String.valueOf(StringUtil.ZERO) + day;
        } else {
            yyyyMMdd += String.valueOf(day);
        }

        return yyyyMMdd;
    }

    /**
     * <p>
     * 현재 날짜가 기준으로 시작 - 종료일을 지났는지 여부를 확인(접수날짜 확인)
     * </p>
     * <p>
     * null 입력의 경우 true 리턴
     * </p>
     * 
     * @EXAMPLE DateCalcUtil.isExpired('시작날짜', '종료날짜');
     * @return BOOLEAN TRUE : 기준일이 아님, FALSE : 기준일 안에 포함됨
     */
    public static boolean isExpired(String sd, String ed) {

        if(Validate.isEmpty(sd) || Validate.isEmpty(ed)) {
            return true;
        }

        StringUtil.fillSpaceRight(sd, 14, '0');
        StringUtil.fillSpaceRight(ed, 14, '0');

        Calendar startDt = Calendar.getInstance();
        Calendar endDt = Calendar.getInstance();
        Calendar tdy = Calendar.getInstance();
        startDt.set(Integer.valueOf(sd.substring(0, 4)), Integer.valueOf(sd.substring(4, 6)).intValue() - 1,
            Integer.valueOf(sd.substring(6, 8)), Integer.valueOf(sd.substring(8, 10)),
            Integer.valueOf(sd.substring(10, 12)), 0);
        endDt.set(Integer.valueOf(ed.substring(0, 4)), Integer.valueOf(ed.substring(4, 6)).intValue() - 1,
            Integer.valueOf(ed.substring(6, 8)), Integer.valueOf(ed.substring(8, 10)),
            Integer.valueOf(ed.substring(10, 12)), 0);
        if(tdy.getTimeInMillis() > endDt.getTimeInMillis() || tdy.getTimeInMillis() < startDt.getTimeInMillis()) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * <p>
     * 시작날짜와 종료날짜의 시간(초) 차이를 구하는 메소드
     * </p>
     * 
     * @EXAMPLE getTimeDiff('시작날짜', '종료날짜');
     * @return n : 차이 시간(초)
     */
    public static int getTimeDiff(String fromTime, String toTime) {
        Date fromDt = DateFormatUtil.toDateFull(fromTime);
        Date toDt = DateFormatUtil.toDateFull(toTime);
        long diffTime = toDt.getTime() - fromDt.getTime();
        return (int) (diffTime / 1000);
    }

}
