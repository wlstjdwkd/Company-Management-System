package com.infra.util;

import java.io.IOException;
import java.lang.reflect.Array;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 데이터 값을 검증하기 위한 클레스
 */
public final class Validate {

	private static final Logger logger = LoggerFactory.getLogger(Validate.class);

    /**
     * 문자열이 제로(0)인지 확인한다.
     *
     * @param propertyValue 대상 문자열.
     * @return 제로(0)이면 <code>true</code>, 아니면 <code>false</code>.
     */
    public static boolean isZero(final CharSequence propertyValue) {

        if(propertyValue == null || propertyValue.length() == 0) {
            return false;
        }

        return (propertyValue.length() == 1 && propertyValue.charAt(0) == '0');
    }

    /**
     * 숫자값이이 제로(0)인지 확인한다.
     *
     * @param propertyValue 대상 숫자값
     * @return 제로(0)이면 <code>true</code>, 아니면 <code>false</code>.
     */
    public static boolean isZero(final Number propertyValue) {

        return (propertyValue != null && propertyValue.intValue() == 0);
    }

    /**
     * 문자 최대길이 확인. maxLength 보다 같거나 짧으면 참
     *
     * @param propertyValue 최대길이를 확인할 대상 문자열.
     * @param maxLength 최대길이 값.
     * @return 길이가 이하면 <code>true</code>, 초과 <code>false</code>.
     */
    public static boolean isMaxLength(final CharSequence propertyValue, int maxLength) {

        return ((propertyValue != null) && (propertyValue.length() <= maxLength));
    }

    /**
     * 문자 최소길이 확인. minLength 보다 같거나 길면 참
     *
     * @param propertyValue 최소길이를 확인할 대상 문자열.
     * @param minLength 최소길이 값.
     * @return 길이보다 작으면(미달하면) <code>true</code>, 초과하면 <code>false</code>.
     */
    public static boolean isMinLength(final CharSequence propertyValue, int minLength) {

        return ((propertyValue != null) && (propertyValue.length() >= minLength));
    }

    /**
     * 최대 숫자값 확인. max 보다 같거나 작으면 참
     *
     * @param propertyValue
     * @param max
     * @return
     */
    public static boolean isMax(final Number propertyValue, int max) {

        return ((propertyValue != null) && (propertyValue.intValue() <= max));
    }

    /**
     * 최소 숫자값 확인. min 보다 같거나 크면 참
     *
     * @param propertyValue
     * @param min
     * @return
     */
    public static boolean isMin(final Number propertyValue, int min) {

        return ((propertyValue != null) && (propertyValue.intValue() >= min));
    }

    /**
     * 영문만으로 값이 구성되어 있는지 확인
     *
     * @param propertyValue 대상 문자열
     * @return 영문인 경우 <code>true</code>, 아니면 <code>false</code>.
     */
    public static boolean isAlphabetic(final CharSequence propertyValue) {

        if(propertyValue == null || propertyValue.length() == 0) {
            return false;
        }

        int size = propertyValue.length();
        for(int i = 0 ; i < size ; i++) {
            char ch = propertyValue.charAt(i);
            if(!((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z'))) {
                return false;
            }
        }
        return true;
    }

    /**
     * 문자만으로 값이 구성되어 있는지 확인
     * <p />
     * 모든 국가의 문자어 포함(한글, 영문, 중문, 일문...)
     *
     * @param propertyValue 대상 문자열
     * @return 문자만인 경우 <code>true</code>, 아니면 <code>false</code>.
     */
    public static boolean isLetter(final CharSequence propertyValue) {

        if(propertyValue == null || propertyValue.length() == 0) {
            return false;
        }

        int size = propertyValue.length();
        for(int i = 0 ; i < size ; i++) {
            if(Character.isLetter(propertyValue.charAt(i)) == false) {
                return false;
            }
        }
        return true;
    }

    /**
     * 한글만으로 값이 구성되어 있는지 확인
     *
     * @param propertyValue 대상 문자열
     * @return 한글인 경우 <code>true</code>, 아니면 <code>false</code>.
     */
    public static boolean isHangul(final CharSequence propertyValue) {

        if(propertyValue == null || propertyValue.length() == 0) {
            return false;
        }

        int size = propertyValue.length();
        for(int i = 0 ; i < size ; i++) {
            char c = propertyValue.charAt(i);
            if(!(44032 <= c && c <= 55203)) {
                return false;
            }
        }
        return true;
    }

    /**
     * 영문과 숫자만으로 구성되었는지 확인
     *
     * @param propertyValue 대상 문자열
     * @return 영문과 숫자인 경우 <code>true</code>, 아니면 <code>false</code>.
     */
    public static boolean isAlphaNumeric(final CharSequence propertyValue) {

        if(propertyValue == null || propertyValue.length() == 0) {
            return false;
        }

        int sz = propertyValue.length();
        for(int i = 0 ; i < sz ; i++) {

            char ch = propertyValue.charAt(i);
            if(!((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z'))
                && !Character.isDigit(propertyValue.charAt(i))) {
                return false;
            }
        }
        return true;
    }

    /**
     * 영문이 소문자로만 구성되었는지 확인
     *
     * @param propertyValue 대상 문자열
     * @return 소문자인 경우 <code>true</code>, 아니면 <code>false</code>.
     */
    public static boolean isAlphaLower(final CharSequence propertyValue) {

        if(propertyValue == null || propertyValue.length() == 0) {
            return false;
        }

        int sz = propertyValue.length();
        for(int i = 0 ; i < sz ; i++) {

            char ch = propertyValue.charAt(i);
            if(!Character.isLowerCase(ch)) {
                return false;
            }
        }
        return true;
    }

    /**
     * 영문이 대문자로만 구성되었는지 확인
     *
     * @param propertyValue 대상 문자열
     * @return 대문자인 경우 <code>true</code>, 아니면 <code>false</code>.
     */
    public static boolean isAlphaUpper(final CharSequence propertyValue) {

        if(propertyValue == null || propertyValue.length() == 0) {
            return false;
        }

        int sz = propertyValue.length();
        for(int i = 0 ; i < sz ; i++) {

            char ch = propertyValue.charAt(i);
            if(!Character.isUpperCase(ch)) {
                return false;
            }
        }
        return true;
    }

    /**
     * 공백 문자가 포함되어 있는지 확인
     *
     * @param propertyValue 대상 문자열
     * @return 공백 문자가 포함된 경우 <code>true</code>, 아니면 <code>false</code>.
     */
    public static boolean isWhitespace(final CharSequence propertyValue) {

        if(propertyValue == null) {
            return false;
        }

        int size = propertyValue.length();
        for(int i = 0 ; i < size ; i++) {
            if(Character.isWhitespace(propertyValue.charAt(i))) {
                return true;
            }
        }
        return false;
    }

    /**
     * 제시된 비교 대상 값(배열)과 입력 값을 비교하여 비교 값이 존재하는지 확인
     *
     * @param propertyValue 대상 값
     * @param compareValues 비교 값 문자 배열
     * @return 비교 문자 배열에 값이 있으면 <code>true</code>, 아니면 <code>false</code>.
     */
    public static boolean isContainsValue(final Object propertyValue, String[] compareValues) {

        if(propertyValue == null) {
            return false;
        }

        // 문자열 확인
        if(propertyValue instanceof CharSequence) {
            String value = (String) propertyValue;
            for(String compareValue : compareValues) {
                if(value.equals(compareValue)) {
                    return true;
                }
            }
        }
        // 문자 배열 확인
        else if(propertyValue instanceof String[]) {
            String[] values = (String[]) propertyValue;
            List<String> valueList = Arrays.asList(values);
            for(String compareValue : compareValues) {
                if(valueList.contains(compareValue)) {
                    return true;
                }
            }
        }
        // 숫자 확인
        else if(propertyValue instanceof Number) {
            Integer value = (Integer) propertyValue;
            for(String compareValue : compareValues) {
                Integer numValue = Integer.getInteger(compareValue);
                if(numValue.equals(value)) {
                    return true;
                }
            }
        }
        // 숫자 배열 확인
        else if(propertyValue instanceof Integer[]) {
            Integer[] values = (Integer[]) propertyValue;
            List<Integer> valueList = Arrays.asList(values);
            for(String compareValue : compareValues) {
                Integer numValue = Integer.getInteger(compareValue);
                if(valueList.contains(numValue)) {
                    return true;
                }
            }
        }
        // Collection 확인
        else if(propertyValue instanceof Collection) {
            Collection<?> collection = (Collection<?>) propertyValue;
            for(String compareValue : compareValues) {
                if(collection.contains(compareValue)) {
                    return true;
                }
            }
        }
        // Array 배열
        else if(propertyValue.getClass().isArray()) {
            try {
                Object[] arrays = (Object[]) propertyValue;
                int arrayCnt = arrays.length;
                for(String compareValue : compareValues) {
                    for(int i = 0 ; i < arrayCnt ; i++) {
                        String value = arrays[i].toString();
                        if(compareValue.equals(value)) {
                            return true;
                        }
                    }
                }
            } catch (RuntimeException e) {
                // do nothing
            	logger.error("", e);
            } catch (Exception e) {
                // do nothing
            	logger.error("", e);
            }
        }

        return false;

    }

    /**
     * 지정된 날짜 포멧 패턴과 입력 값을 비교하여 패턴에 적합한지 확인하고,
     * 또한 입력된 날짜를 파싱하여 입력값이 존재하는 일자 인지 확인
     * <p />
     * 년 월 일만 확인한다.
     *
     * @param propertyValue 대상 값
     * @param datePattern 비교 날짜 포멧 패턴(YYYY-MM-DD)
     * @return 패턴적용이 가능하면 <code>true</code>, 아니면 <code>false</code>.
     */
    public static boolean isEqualsDataFormat(final CharSequence propertyValue, String datePattern) {

        if(propertyValue == null || propertyValue.length() == 0) {
            return false;
        }

        String patternLowerCase = datePattern.toLowerCase();
        String value = propertyValue.toString();

        if(patternLowerCase.length() == value.length()) {

            String delimiter = "";

            if(datePattern.length() > 8) {
                delimiter = datePattern.substring(4, 5);
            }

            String valuePattern = "[123][0-9]{3}" + delimiter + "[0-9]{2}" + delimiter + "[0-9]{2}";
            if(value.matches(valuePattern)) {

                String[] dateArr = { "", "", "" };
                if("".equals(delimiter)) {
                    dateArr[0] = value.substring(0, 4);
                    dateArr[1] = value.substring(4, 6);
                    dateArr[2] = value.substring(6, 8);
                } else {
                    dateArr = value.split(delimiter);
                }
                int yyyy = new Integer(dateArr[0]);
                int mm = new Integer(dateArr[1]);
                int dd = new Integer(dateArr[2]);

                Calendar calendar = Calendar.getInstance();
                calendar.add(Calendar.YEAR, yyyy);

                int maxVal = calendar.getActualMaximum(Calendar.MONTH);
                int minVal = calendar.getActualMinimum(Calendar.MONTH);
                if(mm > maxVal || mm < minVal) {
                    return false;
                }
                calendar.add(Calendar.MONTH, mm);

                maxVal = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
                minVal = calendar.getActualMinimum(Calendar.DAY_OF_MONTH);
                if(dd > maxVal || dd < minVal) {
                    return false;
                }

                return true;
            }
        }

        return false;
    }

    /**
     * 이메일 형식이 맞는지 확인
     *
     * @param propertyValue 대상 값
     * @return 이메일 형식이 맞으면 <code>true</code>, 아니면 <code>false</code>.
     */
    public static boolean isEmail(final CharSequence propertyValue) {

        if(propertyValue == null || propertyValue.length() == 0) {
            return false;
        }

        String value = propertyValue.toString();

        boolean match = value
            .matches("^[0-9a-zA-Z]([-_\\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\\.]?[0-9a-zA-Z])*\\.[a-zA-Z]{2,3}$");
        if(match) {
            return true;
        }
        return false;
    }

    /**
     * 주민번호 검증 수식에 따라서 입력된 값을 계산 하여 확인
     * <p />
     * 주민번호는 '-'가 포함되어 있는 지는 상관없음
     *
     * @param propertyValue 대상 값
     * @return 주민번호 형식이 맞으면 <code>true</code>, 아니면 <code>false</code>.
     */
    public static boolean isJuminNo(final CharSequence propertyValue) {

        if(propertyValue == null || propertyValue.length() == 0) {
            return false;
        }

        String value = propertyValue.toString();
        value = value.replaceAll("-", "");

        if(value.length() != 13) {
            return false;
        }

        int sum = 0;
        for(int i = 0 ; i < 12 ; i++) {
            sum += (((i % 8) + 2) * Integer.parseInt(value.substring(i, i + 1)));
        }

        sum = 11 - (sum % 11);
        sum = sum % 10;

        String lastNum = value.substring(12);
        if(sum == Integer.parseInt(lastNum)) {
            return true;
        }

        return false;
    }

    /**
     * 입력된 문자열의 길이가 최소, 최대 값 사이인지 확인
     *
     * @param propertyValue 대상 값
     * @param min 최소 길이
     * @param max 최대 길이(-1 이면 무제한)
     * @return 최소, 최대 값 사이이면 <code>true</code>, 아니면 <code>false</code>.
     */
    public static boolean isLengthMetch(final CharSequence propertyValue, int min, int max) {

        if(propertyValue == null || propertyValue.length() == 0) {
            return false;
        }

        int length = propertyValue.length();
        if(max < 0 && length >= min) {
            return true;
        }
        if(max >= 0 && length >= min && length <= max) {
            return true;
        }

        return false;
    }

    /**
     * 입력 값이 <code>null</code> 인지 확인
     *
     * @param propertyValue 대상 값
     * @return <code>null</code>이면 <code>true</code>, 아니면 <code>false</code>.
     */
    public static boolean isNull(final Object propertyValue) {

        return (propertyValue == null);
    }

    /**
     * 입력 값이 <code>not null</code> 인지 확인
     *
     * @param propertyValue 대상 값
     * @return <code>not null</code>이면 <code>true</code>, 아니면 <code>false</code>
     *         .
     */
    public static boolean isNotNull(final Object propertyValue) {

        return (propertyValue != null);
    }

    /**
     * 숫자(정수)만으로 구성되어 있는지 확인
     *
     * @param propertyValue 대상 값
     * @return 숫자만이면 이면 <code>true</code>, 아니면 <code>false</code>
     */
    public static boolean isDigits(final CharSequence propertyValue) {

        if(propertyValue == null || propertyValue.length() == 0) {
            return false;
        }

        int size = propertyValue.length();
        for(int i = 0 ; i < size ; i++) {
            if(!Character.isDigit(propertyValue.charAt(i))) {
                return false;
            }
        }
        return true;
    }

    /**
     * 숫자(소숫점 포함 실수 까지만 적용)만으로 구성되어 있는지 확인
     *
     * @param propertyValue 대상 값
     * @return 숫자만이면 이면 <code>true</code>, 아니면 <code>false</code>
     */
    public static boolean isNumeric(final CharSequence propertyValue) {

        if(propertyValue == null || propertyValue.length() == 0) {
            return false;
        }

        try {
            String value = propertyValue.toString();
            Float.valueOf(value);
        } catch (RuntimeException e) {
            return false;
        } catch (Exception e) {
            return false;
        }

        return true;
    }

    /**
     * 입력된 숫자 값이 최소, 최대값 사이인지 확인(정수 값만)
     * <p />
     * 입력값 타입은 <code>Number</code> 또는 <code>String</code> 타입이어야 함
     *
     * @param propertyValue 대상 값
     * @param min 최소 숫자값
     * @param max 최대 숫자값(-1 이면 무제한)
     * @return 최소/최대 숫자 값 범위 내면 <code>true</code>, 아니면 <code>false</code>
     */
    public static boolean isRangeMatch(final Object propertyValue, int min, int max) {

        try {
            int value = 0;
            if(propertyValue instanceof Number) {
                value = ((Number) propertyValue).intValue();
            } else if(propertyValue instanceof CharSequence) {
                value = Integer.parseInt(propertyValue.toString());
            } else {
                return false;
            }

            if(max < 0 && value >= min) {
                return true;
            }
            if(max >= 0 && value >= min && value <= max) {
                return true;
            }
        } catch (RuntimeException e) {
            return false;
        } catch (Exception e) {
            return false;
        }

        return false;
    }

    /**
     * 문자열을 정규표현식을 통하여 검증
     * <p />
     * 예 : [a-zA-Z0-9]
     *
     * @param propertyValue 대상 값
     * @param regexp 정규 표현식
     * @return 패턴과 일치되면 <code>true</code>, 아니면 <code>false</code>
     */
    public static boolean isRegExpMatch(final CharSequence propertyValue, String regexp) {

        if(propertyValue == null || propertyValue.length() == 0) {
            return false;
        }

        String value = propertyValue.toString();

        return (value.matches(regexp));
    }

    /**
     * 대상 객체가 <code>null</code>이 아니고, 길이가 0 이 아닌지를 확인한다.
     * <p />
     * <code>CharSequence, Number, Enumeration, Iterator, Array</code>를 확인한다.
     *
     * @param propertyValue 대상 값
     * @return null, "", 0, 길이가 0이 아닌 경우 <code>true</code>, 아니면
     *         <code>false</code>
     */
    public static boolean isNotEmpty(final Object propertyValue) {

        if(propertyValue == null) {
            return false;
        }

        // 문자열 확인
        if(propertyValue instanceof CharSequence) {

            return (propertyValue.toString().length() > 0);
        }
        // 숫자 확인
        else if(propertyValue instanceof Number) {

            return ((Integer) propertyValue > 0);
        }
        // Enumeration
        else if(propertyValue instanceof Enumeration) {
            Enumeration<?> enumer = (Enumeration<?>) propertyValue;

            return (enumer.hasMoreElements());
        }
        // Iterator
        else if(propertyValue instanceof Iterator) {
            Iterator<?> iter = (Iterator<?>) propertyValue;

            return (iter.hasNext());
        }
        // Collection
        else if(propertyValue instanceof Collection) {
            Collection<?> collection = (Collection<?>) propertyValue;

            return (collection != null && collection.size() > 0);
        }
        // Array
        else if(propertyValue.getClass().isArray()) {
            try {
                return (Array.getLength(propertyValue) > 0);
            } catch (RuntimeException e) {
            	logger.error("", e);
            } catch (Exception e) {
                // do nothing
            	logger.error("", e);
            }
        }
        // Object
        else {
            return isNotEmpty(propertyValue.toString());
        }

        return false;
    }

    /**
     * 대상 객체가 "", <code>null</code> 또는 길이가 0 인지를 확인한다.
     * <p />
     * <code>Enumeration, Iterator, Array</code>를 확인한다.
     *
     * @param propertyValue 대상 값
     * @return null, "", 0, 길이가 0인 경우 <code>true</code>, 아니면 <code>false</code>
     */
    public static boolean isEmpty(final Object propertyValue) {

        return !(isNotEmpty(propertyValue));
    }

    /**
     * 대상 문자열이 "", <code>null</code> 이 아닌지를 확인한다.
     *
     * @param propertyValue 대상 값
     * @return null, "" 이 아니면 <code>true</code>, 아니면 <code>false</code>
     */
    public static boolean isNotEmpty(final CharSequence propertyValue) {

        return (propertyValue != null && propertyValue.length() > 0);
    }

    /**
     * 대상 문자열이 "", <code>null</code> 인지를 확인한다.
     *
     * @param propertyValue 대상 값
     * @return null, "" 인 경우 <code>true</code>, 아니면 <code>false</code>
     */
    public static boolean isEmpty(final CharSequence propertyValue) {

        return (propertyValue == null || propertyValue.length() <= 0);
    }

    /**
     * 대상 숫자가 <code>null</code>이 아니고, 0 이 아닌지를 확인한다.
     *
     * @param propertyValue 대상 값
     * @return null 또는 0 이 아니면 <code>true</code>, 아니면 <code>false</code>
     */
    public static boolean isNotEmpty(final Number propertyValue) {

        return (propertyValue != null && propertyValue.intValue() > 0);
    }

    /**
     * 대상 숫자가 <code>null</code> 또는 0 인지를 확인한다.
     *
     * @param propertyValue 대상 값
     * @return null 또는 0인 경우 <code>true</code>, 아니면 <code>false</code>
     */
    public static boolean isEmpty(final Number propertyValue) {

        return (propertyValue == null || propertyValue.intValue() <= 0);
    }

    /**
     * 대상 <code>Collection</code>이 <code>null</code>이 아니고, size가 0 이 아닌지를 확인한다.
     *
     * @param propertyValue 대상 값
     * @return null 또는 size가 0 이 아니면 <code>true</code>, 아니면 <code>false</code>
     */
    public static boolean isNotEmpty(final Collection<?> propertyValue) {

        return (propertyValue != null && propertyValue.size() > 0);
    }

    /**
     * 대상 <code>Collection</code>이 <code>null</code> 또는 size가 0 인지를 확인한다.
     *
     * @param propertyValue 대상 값
     * @return null 또는 size가 0인 경우 <code>true</code>, 아니면 <code>false</code>
     */
    public static boolean isEmpty(final Collection<?> propertyValue) {

        return (propertyValue == null || propertyValue.size() <= 0);
    }

    /**
     * 대상 <code>Map</code>이 <code>null</code>이 아니고, 값이 있는지를 확인한다.
     *
     * @param propertyValue 대상 값
     * @return null 또는 size가 0 이 아니면 <code>true</code>, 아니면 <code>false</code>
     */
    public static boolean isNotEmpty(final Map<?, ?> propertyValue) {

        return (isNotNull(propertyValue) && !propertyValue.isEmpty());
    }

    /**
     * 대상 <code>Map</code>이 <code>null</code> 또는 값이 없는지를 확인한다.
     *
     * @param propertyValue 대상 값
     * @return null 또는 size가 0인 경우 <code>true</code>, 아니면 <code>false</code>
     */
    public static boolean isEmpty(final Map<?, ?> propertyValue) {

        return (isNull(propertyValue) || propertyValue.isEmpty());
    }

    /**
     * 대상 <code>Object[]</code> 배열이 <code>null</code>이 아니고, size가 0 이 아닌지를 확인한다.
     *
     * @param propertyValue 대상 값
     * @return null 또는 length가 0 이 아니면 <code>true</code>, 아니면 <code>false</code>
     */
    public static boolean isNotEmpty(final Object[] propertyValue) {

        return (propertyValue != null && propertyValue.length > 0);
    }

    /**
     * 대상 <code>Object[]</code>이 <code>null</code> 또는 size가 0 인지를 확인한다.
     *
     * @param propertyValue 대상 값
     * @return <code>null</code> 또는 length가 0인 경우 <code>true</code>, 아니면
     *         <code>false</code>
     */
    public static boolean isEmpty(final Object[] propertyValue) {

        return (propertyValue == null || propertyValue.length <= 0);
    }

    /**
     * <code>Collection, Array, Enumeration, Iterator, Map</code>의 지정 Size 범위와
     * 일치하는지 확인
     *
     * @param propertyValue 대상 값
     * @param min 최소 길이
     * @param max 최대 길이(-1 이면 무제한)
     * @return 컬렉션, 배열 유형의 길이가 범위 내면 <code>true</code>, 아니면 <code>false</code>
     */
    public static boolean isSizeMatch(final Object propertyValue, int min, int max) {

        if(propertyValue == null) {
            return false;
        }

        int size = 0;
        if(propertyValue instanceof Map) {
            Map<?, ?> map = (Map<?, ?>) propertyValue;
            size = map.size();
        }
        // Collection
        else if(propertyValue instanceof Collection) {
            Collection<?> collection = (Collection<?>) propertyValue;
            size = collection.size();
        }
        // Enumeration
        else if(propertyValue instanceof Enumeration) {
            Enumeration<?> enumer = (Enumeration<?>) propertyValue;
            size = 0;

            while(enumer.hasMoreElements()) {
                size++;
                enumer.nextElement();
            }
        }
        // Iterator
        else if(propertyValue instanceof Iterator) {
            Iterator<?> iter = (Iterator<?>) propertyValue;
            size = 0;
            while(iter.hasNext()) {
                size++;
                iter.next();
            }
        }
        // Array 배열
        else if(propertyValue.getClass().isArray()) {
            try {
                size = Array.getLength(propertyValue);
            } catch (RuntimeException e) {
            	logger.error("", e);
            } catch (Exception e) {
            	logger.error("", e);
            }
        }
        // 기타 String Integer 등
        else if(!propertyValue.getClass().isArray()) {
            try {
                size = 1;
            } catch (RuntimeException e) {
            	logger.error("", e);
            } catch (Exception e) {
            	logger.error("", e);
            }
        }

        if(max < 0 && size >= min) {
            return true;
        }
        if(max >= 0 && size >= min && size <= max) {
            return true;
        }

        return false;
    }

    /**
     * <code>URL</code> 형식과 일치하는지 확인
     *
     * @param propertyValue 대상 값
     * @return URL 형식과 일치하면 <code>true</code>, 아니면 <code>false</code>
     */
    public static boolean isUrl(final CharSequence propertyValue) {

        String value = propertyValue.toString();

        boolean match = value.matches("(http|https|ftp)://[^\\s^\\.]+(\\.[^\\s^\\.]+)*");
        if(match) {
            return true;
        }
        return false;
    }

    /**
     * 공백 문자가 포함되어 있으면 참
     *
     * @param propertyValue 대상 값
     * @return
     */
    public static boolean isWhiteSpace(final CharSequence propertyValue) {

        return !(isNoWhiteSpace(propertyValue));
    }

    /**
     * 공백 문자가 포함되어 있지 않으면 참
     *
     * @param propertyValue
     * @return
     */
    public static boolean isNoWhiteSpace(final CharSequence propertyValue) {

        if(propertyValue == null || propertyValue.length() == 0) {
            return true;
        }

        int sz = propertyValue.length();
        for(int i = 0 ; i < sz ; i++) {

            char ch = propertyValue.charAt(i);
            if(Character.isWhitespace(ch)) {
                return false;
            }
        }
        return true;
    }
}
