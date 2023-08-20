/*
 * Copyright (c) 2012 ZES Inc. All rights reserved.
 * This software is the confidential and proprietary information of ZES Inc.
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with ZES Inc. (http://www.zesinc.co.kr/)
 */
package com.infra.util;

import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.List;

public class FieldUtil {

    /**
     * 최상위 클레스인 <code>Object.class</code>를 제외 한 모든 상속(extends) , 구현(implements)
     * 관계의 <code>Field</code>에서 동일 이름의 <code>Field</code>를 찾아 반환한다.
     * <p />
     * <code>java.lang.Class#getDeclaredField</code>를 사용하여 Public 이외의 접근 지시자
     * <code>Field</code>항목까지 반환한다.
     * <p />
     * 또한 public 지시자를 사용한 것 과 같이 값을 설정할 수 있도록 <code>Field.Accessible</code>이
     * true 상태가 된다.
     *
     * @param clazz <code>Field</code> 추출대상 <code>Class</code>
     * @param fieldName 추출 대상 Field Name
     * @return 추출된 <code>Field</code> or null
     * @see {@link java.lang.Class#getDeclaredField}
     * @see {@link java.lang.reflect.Field#setAccessible(boolean)}
     */
    public static Field getField(Class<?> clazz, String fieldName) {

        Field field = null;

        do {
            try {
                field = clazz.getDeclaredField(fieldName);
            } catch (NoSuchFieldException e) {
                clazz = clazz.getSuperclass();
            }
        } while(field == null && clazz != Object.class);

        if(field != null && !Modifier.isFinal(field.getModifiers())) {
            field.setAccessible(true);
        }
        return field;

    }

    /**
     * 최상위 클레스인 <code>Object.class</code>를 제외 한 모든 상속 관계의 <code>Field</code>를 모두
     * 가져온다.
     * <p />
     * 또한 public 지시자를 사용한 것 과 같이 값을 설정할 수 있도록 <code>Field.Accessible</code>이
     * true 상태가 된다.
     *
     * @param clazz <code>Field</code>를 추출할 대상 <code>Class</code>
     * @return Field[] 배열 반환
     * @see {@link java.lang.Class#getDeclaredField}
     * @see {@link java.lang.reflect.Field#setAccessible(boolean)}
     */
    public static Field[] getFields(Class<?> clazz) {

        List<Field> fieldList = new ArrayList<Field>();

        do {
            Field[] fields = clazz.getDeclaredFields();
            for(Field field : fields) {

                if(!Modifier.isFinal(field.getModifiers())) {
                    field.setAccessible(true);
                }
                fieldList.add(field);
            }
            clazz = clazz.getSuperclass();
        } while(clazz != Object.class);

        return fieldList.toArray(new Field[fieldList.size()]);

    }

    /**
     * 최상위 클레스인 <code>Object.class</code>를 제외 한 모든 상속 관계의 <code>Field</code>를 모두
     * 가져온다.
     * <p />
     * prefix는 get, set, is 등의 이름으로 시작되는 <code>Field</code> 목록만 추출하기 위한 조건으로
     * 사용된다.
     * <p />
     * 또한 public 지시자를 사용한 것 과 같이 값을 설정할 수 있도록 <code>Field.Accessible</code>이
     * true 상태가 된다.
     *
     * @param clazz <code>Field</code>를 추출할 대상 <code>Class</code>
     * @return Field[] 배열 반환
     * @see {@link java.lang.Class#getDeclaredField}
     * @see {@link java.lang.reflect.Field#setAccessible(boolean)}
     */
    public static Field[] getFields(Class<?> clazz, String prefix) {

        List<Field> fieldList = new ArrayList<Field>();

        do {
            Field[] fields = clazz.getDeclaredFields();
            for(Field field : fields) {
                if(field.getName().startsWith(prefix)) {
                    if(!Modifier.isFinal(field.getModifiers())) {
                        field.setAccessible(true);
                    }
                    fieldList.add(field);
                }
            }
            clazz = clazz.getSuperclass();
        } while(clazz != Object.class);

        return fieldList.toArray(new Field[fieldList.size()]);

    }

    /**
     * <code>Class</code>의 멤버 변수 명을 모두 반환한다.
     *
     * @param clazz FieldName을 추출할 대상 <code>Class</code>
     * @return
     */
    public static List<String> getFieldNames(Class<?> clazz) {

        List<String> fieldNameList = new ArrayList<String>();
        Field[] fields = getFields(clazz);

        for(Field field : fields) {
            fieldNameList.add(field.getName());
        }

        return fieldNameList;
    }

    /**
     * <code>Field.getName()</code>을 사용하여 이름을 구한 후 prefix(get 또는 is)에
     * 해당하는 문자를 붙이고 이후 첫자리를대문자로 변환한 함수명 문자열을 반환한다.
     * <p />
     * - java beans 규약에 해당하는 setter 명을 구하는 용도
     *
     * @param field 메소드명을 구할 <code>Field</code>
     * @return 메소드명
     */
    public static String fieldToSetter(Field field) {

        String prefix = "set";

        return fieldToMethodName(field, prefix);
    }

    /**
     * <code>Field.getName()</code>을 사용하여 이름을 구한 후 prefix(get 또는 is)에
     * 해당하는 문자를 붙이고 이후 첫자리를대문자로 변환한 함수명 문자열을 반환한다.
     * <p />
     * - java beans 규약에 해당하는 setter, getter 명을 구하는 용도
     *
     * @param field 메소드명을 구할 <code>Field</code>
     * @return 메소드명
     */
    public static String fieldToGetter(Field field) {

        String prefix = "get";
        if(Boolean.TYPE.equals(field.getType())) {
            prefix = "is";
        }

        return fieldToMethodName(field, prefix);
    }

    /**
     * <code>Field.getName()</code>을 사용하여 이름을 구한 후 prefix에 해당하는 문자를 붙이고 이후 첫자리를
     * 대문자로 변환한 함수명 문자열을 반환한다.<br />
     * - java beans 규약에 해당하는 setter, getter 명을 구하는 용도
     *
     * @param field 메소드명을 구할 <code>Field</code>
     * @param prefix 접두어 문자
     * @return 메소드명
     */
    public static String fieldToMethodName(Field field, String prefix) {

        String fieldName = field.getName();
        StringBuffer methodName = new StringBuffer();

        int length = 0;
        if(prefix != null) {
            length = prefix.length();
            methodName.append(prefix);
        }

        methodName.append(fieldName.substring(length, length + 1).toUpperCase());
        methodName.append(fieldName.substring(length));

        return fieldName.toString();

    }

    /**
     * 필드 멤버의 값을 반환한다.
     *
     * @param obj 대상 객체
     * @param fieldName
     * @return
     */
    public static Object getValue(Object obj, String fieldName) {

        Field field = getField(obj.getClass(), fieldName);
        Object value = null;

        try {
            value = field.get(obj);
        } catch (RuntimeException e) {
            return value;
        } catch (Exception e) {
            return value;
        }

        return value;
    }
}
