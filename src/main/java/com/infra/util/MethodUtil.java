package com.infra.util;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

/**
 * <code>Method</code> 관련 Util Class
 * 
 */
public class MethodUtil {

    /**
     * 대상 <code>Class</code>에서 모든 public 지시자 <code>Method</code>를 추출하여 반환한다.
     * 
     * @param clazz <code>Method</code>를 추출할 대상 <code>Object</code>
     * @return <code>public</code> 지시자에 해당하는 <code>Method</code> 목록
     */
    public static Method[] getMethods(Class<?> clazz) {

        List<Method> methodList = new ArrayList<Method>();

        do {
            Method[] methods = clazz.getDeclaredMethods();
            for(Method method : methods) {
                methodList.add(method);
            }
            clazz = clazz.getSuperclass();
        } while(clazz != Object.class);

        return methodList.toArray(new Method[methodList.size()]);
    }

    /**
     * 대상 <code>Class</code>에서 methodName에 해당하는 public 지시자 <code>Method</code>를
     * 추출하여 반환한다.
     * 
     * @param clazz <code>Method</code>를 추출할 대상 <code>Class</code>
     * @param methodName 대상 <code>Method</code>명
     * @return methodName에 해당하는 <code>Method</code>
     * @throws IllegalArgumentException
     * @see {@link java.lang.Class#getMethods()}
     */
    public static Method getMethod(Class<?> clazz, String methodName) {

        Method[] methods = getMethods(clazz);

        for(Method method : methods) {
            if(methodName.equals(method.getName())) {
                return method;
            }
        }

        return null;
    }

    /**
     * 대상 <code>Class</code>에서 모든 public 지시자 <code>Method</code>를 추출하여 반환한다.
     * prefix는 get, set, is 등의 이름으로 시작되는 메소드 목록만 추출하기 위한 조건으로 사용된다.
     * 
     * @param clazz <code>Method</code>를 추출할 대상 <code>Class</code>
     * @param prefix get, set, is 등 Method 접두어에 해당
     * @return <code>public</code> 지시자에 해당하는 <code>Method</code> 목록
     */
    public static Method[] getMethods(Class<?> clazz, String prefix) {

        Method[] methods = getMethods(clazz);

        List<Method> methodList = new ArrayList<Method>();

        for(Method method : methods) {
            if(method.getName().startsWith(prefix)) {
                methodList.add(method);
            }
        }

        return methodList.toArray(new Method[methodList.size()]);
    }

    /**
     * 대상 <code>Class</code>에서 모든 public 지시자 <code>Method</code> 이름을 추출하여 반환한다.
     * 
     * @param clazz <code>Method</code> 이름을 추출할 대상 <code>Class</code>
     * @return <code>public</code> 지시자에 해당하는 <code>Method</code> 이름 목록
     */
    public static List<String> getMethodNames(Class<?> clazz) {

        List<String> mnList = new ArrayList<String>();
        Method[] method = getMethods(clazz);

        int mCnt = method.length;
        for(int i = 0 ; i < mCnt ; i++) {
            mnList.add(method[i].getName());
        }

        return mnList;

    }

    /**
     * 대상 <code>Class</code>에서 모든 public 지시자 <code>Method</code> 이름을 추출하여 반환한다.
     * <p />
     * prefix는 get, set, is 등의 이름으로 시작되는 메소드 목록만 추출하기 위한 조건으로 사용된다.
     * 
     * @param clazz <code>Method</code> 이름을 추출할 대상 <code>Class</code>
     * @param prefix 이름이 prefix로 시작되는 <code>Method</code>
     * @return <code>public</code> 지시자에 해당하는 <code>Method</code> 이름 목록
     */
    public static List<String> getMethodNames(Class<?> clazz, String prefix) {

        List<String> mnList = new ArrayList<String>();
        Method[] method = getMethods(clazz);

        String methodName = "";
        int mCnt = method.length;

        for(int i = 0 ; i < mCnt ; i++) {
            methodName = method[i].getName();

            if(methodName.startsWith(prefix)) {
                mnList.add(methodName);
            }
        }

        return mnList;

    }

    /**
     * <code>Method.getName()</code>을 사용하여 이름을 구한 후 표준 BEAN 규칙에 따라 접두사 3자리(set,
     * get 등)를 자르고 이후 첫자리를 소문자로 변환한 필드명 문자열을 반환한다.
     * 
     * @param method 필드명을 구할 <code>Method</code>
     * @return 필드명
     */
    public static String methodToFieldName(Method method) {

        return methodToFieldName(method, null);
    }

    /**
     * <code>Method.getName()</code>을 사용하여 이름을 구한 후 prefix에 해당하는 문자를 자르고 이후 첫자리를
     * 소문자로 변환한 필드명 문자열을 반환한다.
     * 
     * @param method 필드명을 구할 <code>Method</code>
     * @param prefix 잘라낼 문자
     * @return 필드명
     */
    public static String methodToFieldName(Method method, final String prefix) {

        String fieldName = "";
        String methodName = method.getName();

        int length = 0;
        if(prefix != null) {
            length = prefix.length();
        }

        fieldName = methodName.substring(length, length + 1).toLowerCase();
        fieldName += methodName.substring(length + 1);

        return fieldName;

    }

}
