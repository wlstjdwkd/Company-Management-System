package com.infra.util;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * <p>
 * 자바 기본데이터 타입(<code>int[]</code>와 같은)의 배열에 대한 보조기능(<code>Integer[]</code>와 같은)을
 * 제공하는 유틸리티 클래스
 * </p>
 * <p>
 * 다음과 같은 기능을 제공한다.
 * </p>
 * <ul>
 * <li>배열에서 특정값 찾기</li>
 * <li>두 배열 비교하기</li>
 * <li>배열에 저장된 요소들의 순서 뒤집기</li>
 * <li>기본 데이터타입의 배열을 래퍼클래스의 배열로 변환</li>
 * <li>래퍼 클래스의 배열을 기본 데이터타입의 배열로 변환</li>
 * <li>배열 복제하기</li>
 * </ul>
 * 이 클래스는 <code>null</code> 입력값에 대해 효율적으로 다룬다.<br>
 * <code>null</code>에 대한 예외는 던져지지 않으나<br>
 * <code>null</code>을 포함하는 오브젝트 배열은 예외를 던지는 것에 유의할 것.
 *
 * @EXAMPLE ArrayUtil.toString(null) = "{}" <br>
 *          ArrayUtil.toString(new Object[0]) = "{}" <br>
 *          ArrayUtil.toString(new String[0]) = "{}" <br>
 *          ArrayUtil.toString(new String[] {null}) = "{<null>}" <br>
 *          ArrayUtil.toString(new String[] {"pink","blue"}) = "{pink,blue}" <br>
 *          ArrayUtil.toString(null, "<empty>") = "<empty>" <br>
 *          ArrayUtil.toString(new Object[0], "<empty>") = "{}" <br>
 *          ArrayUtil.toString(new String[0], "<empty>") = "{}" <br>
 *          ArrayUtil.toString(new String[] {null}, "<empty>") = "{<null>}" <br>
 *          ArrayUtil.toString(new String[] {"pink","blue"}, "<empty>") =
 *          "{pink,blue}" <br> *
 */
@SuppressWarnings({ "unchecked", "rawtypes" })
public class ArrayUtil {

	private static final Logger logger = LoggerFactory.getLogger(ArrayUtil.class);

    /**
     * 내용이 빈 상수 <code>Object</code> 배열.
     */
    public static final Object[] EMPTY_OBJECT_ARRAY = new Object[0];

    /**
     * 내용이 빈 상수 <code>Class</code> 배열.
     */
    public static final Class[] EMPTY_CLASS_ARRAY = new Class[0];

    /**
     * 내용이 빈 상수 <code>String</code> 배열.
     */
    public static final String[] EMPTY_STRING_ARRAY = new String[0];

    /**
     * 내용이 빈 상수 <code>long</code> 배열.
     */
    public static final long[] EMPTY_LONG_ARRAY = new long[0];

    /**
     * 내용이 빈 상수 <code>Long</code> 배열.
     */
    public static final Long[] EMPTY_LONG_OBJECT_ARRAY = new Long[0];

    /**
     * 내용이 빈 상수 <code>int</code> 배열.
     */
    public static final int[] EMPTY_INT_ARRAY = new int[0];

    /**
     * 내용이 빈 상수 <code>Integer</code> 배열.
     */
    public static final Integer[] EMPTY_INTEGER_OBJECT_ARRAY = new Integer[0];

    /**
     * 내용이 빈 상수 <code>short</code> 배열.
     */
    public static final short[] EMPTY_SHORT_ARRAY = new short[0];

    /**
     * 내용이 빈 상수 <code>Short</code> 배열.
     */
    public static final Short[] EMPTY_SHORT_OBJECT_ARRAY = new Short[0];

    /**
     * 내용이 빈 상수 <code>byte</code> 배열.
     */
    public static final byte[] EMPTY_BYTE_ARRAY = new byte[0];

    /**
     * 내용이 빈 상수 <code>Byte</code> 배열.
     */
    public static final Byte[] EMPTY_BYTE_OBJECT_ARRAY = new Byte[0];

    /**
     * 내용이 빈 상수 <code>double</code> 배열.
     */
    public static final double[] EMPTY_DOUBLE_ARRAY = new double[0];

    /**
     * 내용이 빈 상수 <code>Double</code> 배열.
     */
    public static final Double[] EMPTY_DOUBLE_OBJECT_ARRAY = new Double[0];

    /**
     * 내용이 빈 상수 <code>float</code> 배열.
     */
    public static final float[] EMPTY_FLOAT_ARRAY = new float[0];

    /**
     * 내용이 빈 상수 <code>Float</code> 배열.
     */
    public static final Float[] EMPTY_FLOAT_OBJECT_ARRAY = new Float[0];

    /**
     * 내용이 빈 상수 <code>boolean</code> 배열.
     */
    public static final boolean[] EMPTY_BOOLEAN_ARRAY = new boolean[0];

    /**
     * 내용이 빈 상수 <code>Boolean</code> 배열.
     */
    public static final Boolean[] EMPTY_BOOLEAN_OBJECT_ARRAY = new Boolean[0];

    /**
     * 내용이 빈 상수 <code>char</code> 배열.
     */
    public static final char[] EMPTY_CHAR_ARRAY = new char[0];

    /**
     * 내용이 빈 상수 <code>Character</code> 배열.
     */
    public static final Character[] EMPTY_CHARACTER_OBJECT_ARRAY = new Character[0];

    /**
     * <p>
     * 모든 메소드가 static이기 때문에 <code>ArrayUtil</code> 인스탄스는 일반적으로 필요하지 않음.<br>
     * 대신 아래와 같이 사용하면 됨.<br>
     * <code>ArrayUtil.clone(new int[] {2})</code>.
     * </p>
     * <p>
     * 참고로 본 생성자는 JavaBean 인스탄스를 위해 public으로 선언됨
     * </p>
     */
    public ArrayUtil() {
    }

    // To map
    // -----------------------------------------------------------------------
    /**
     * <p>
     * Converts the given array into a {@link java.util.Map}. Each element of
     * the array must be either a {@link java.util.Map.Entry} or an Array,
     * containing at least two elements, where the first element is used as key
     * and the second as value.
     * </p>
     * <p>
     * 다음과 같이 초기화되어 이용될 수 있음:
     * </p>
     *
     * <pre>
     *   Map colorMap = MapUtils.toMap(new String[][] {{
     *       {&quot;RED&quot;, &quot;#FF0000&quot;},
     *       {&quot;GREEN&quot;, &quot;#00FF00&quot;},
     *       {&quot;BLUE&quot;, &quot;#0000FF&quot;}});
     * </pre>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array {@link java.util.Map.Entry} 타입이거나 적어도 2개 이상의 값이 존재하는 배열,
     *        <code>null</code>도 가능함.
     * @return 주어진 배열로부터 발생된 <code>Map</code>
     * @throws IllegalArgumentException 주어진 배열의 요소가 1개 이거나 2개보다 작다면 발생
     * @throws IllegalArgumentException 주어진 배열의 타입이 {@link java.util.Map.Entry}이
     *         아닐경우 발생
     */
    public static Map toMap(final Object[] array) {
        if(array == null) {
            return null;
        }
        final Map map = new HashMap((int) (array.length * 1.5));
        for(int i = 0 ; i < array.length ; i++) {
            Object object = array[i];
            if(object instanceof Map.Entry) {
                Map.Entry entry = (Map.Entry) object;
                map.put(entry.getKey(), entry.getValue());
            } else if(object instanceof Object[]) {
                Object[] entry = (Object[]) object;
                if(entry.length < 2) {
                	try {
                		throw new IllegalArgumentException("Array element " + i + ", '" + object
                				+ "', has a length less than 2");
					} catch (IllegalArgumentException e) {
						logger.error("", e);
					}
                }
                map.put(entry[0], entry[1]);
            } else {
            	try {
            		throw new IllegalArgumentException("Array element " + i + ", '" + object
            				+ "', is neither of type Map.Entry nor an Array");
				} catch (IllegalArgumentException e) {
					logger.error("", e);
				}
            }
        }
        return map;
    }

    // Clone
    // -----------------------------------------------------------------------
    /**
     * <p>
     * Shallow clones an array returning a typecast result and handling
     * <code>null</code>.
     * </p>
     * <p>
     * The objecs in the array are not cloned, thus there is no special handling
     * for multi-dimensional arrays.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array the array to shallow clone, <code>null</code>도 가능함.
     * @return the cloned array, <code>null</code> if <code>null</code> input
     */
    public static Object[] clone(final Object[] array) {
        if(array == null) {
            return null;
        }
        return array.clone();
    }

    /**
     * <p>
     * Clones an array returning a typecast result and handling
     * <code>null</code>.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array the array to clone, <code>null</code>도 가능함.
     * @return the cloned array, <code>null</code> if <code>null</code> input
     */
    public static long[] clone(final long[] array) {
        if(array == null) {
            return null;
        }
        return array.clone();
    }

    /**
     * <p>
     * Clones an array returning a typecast result and handling
     * <code>null</code>.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array the array to clone, <code>null</code>도 가능함.
     * @return the cloned array, <code>null</code> if <code>null</code> input
     */
    public static int[] clone(int[] array) {
        if(array == null) {
            return null;
        }
        return array.clone();
    }

    /**
     * <p>
     * Clones an array returning a typecast result and handling
     * <code>null</code>.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array the array to clone, <code>null</code>도 가능함.
     * @return the cloned array, <code>null</code> if <code>null</code> input
     */
    public static short[] clone(final short[] array) {
        if(array == null) {
            return null;
        }
        return array.clone();
    }

    /**
     * <p>
     * Clones an array returning a typecast result and handling
     * <code>null</code>.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array the array to clone, <code>null</code>도 가능함.
     * @return the cloned array, <code>null</code> if <code>null</code> input
     */
    public static char[] clone(final char[] array) {
        if(array == null) {
            return null;
        }
        return array.clone();
    }

    /**
     * <p>
     * Clones an array returning a typecast result and handling
     * <code>null</code>.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array the array to clone, <code>null</code>도 가능함.
     * @return the cloned array, <code>null</code> if <code>null</code> input
     */
    public static byte[] clone(final byte[] array) {
        if(array == null) {
            return null;
        }
        return array.clone();
    }

    /**
     * <p>
     * Clones an array returning a typecast result and handling
     * <code>null</code>.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array the array to clone, <code>null</code>도 가능함.
     * @return the cloned array, <code>null</code> if <code>null</code> input
     */
    public static double[] clone(final double[] array) {
        if(array == null) {
            return null;
        }
        return array.clone();
    }

    /**
     * <p>
     * Clones an array returning a typecast result and handling
     * <code>null</code>.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array the array to clone, <code>null</code>도 가능함.
     * @return the cloned array, <code>null</code> if <code>null</code> input
     */
    public static float[] clone(final float[] array) {
        if(array == null) {
            return null;
        }
        return array.clone();
    }

    /**
     * <p>
     * Clones an array returning a typecast result and handling
     * <code>null</code>.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array the array to clone, <code>null</code>도 가능함.
     * @return the cloned array, <code>null</code> if <code>null</code> input
     */
    public static boolean[] clone(final boolean[] array) {
        if(array == null) {
            return null;
        }
        return array.clone();
    }

    // Is same length
    // -----------------------------------------------------------------------
    /**
     * <p>
     * Checks whether two arrays are the same length, treating <code>null</code>
     * arrays as length <code>0</code>.
     * <p>
     * Any multi-dimensional aspects of the arrays are ignored.
     * </p>
     *
     * @param array1 the first배열, <code>null</code>도 가능함.
     * @param array2 the second배열, <code>null</code>도 가능함.
     * @return <code>true</code> if length of arrays matches, treating
     *         <code>null</code> as an empty array
     */
    public static boolean isSameLength(final Object[] array1, final Object[] array2) {
        if((array1 == null && array2 != null && array2.length > 0)
            || (array2 == null && array1 != null && array1.length > 0)
            || (array1 != null && array2 != null && array1.length != array2.length)) {
            return false;
        }
        return true;
    }

    /**
     * <p>
     * Checks whether two arrays are the same length, treating <code>null</code>
     * arrays as length <code>0</code>.
     * </p>
     *
     * @param array1 the first배열, <code>null</code>도 가능함.
     * @param array2 the second배열, <code>null</code>도 가능함.
     * @return <code>true</code> if length of arrays matches, treating
     *         <code>null</code> as an empty array
     */
    public static boolean isSameLength(final long[] array1, final long[] array2) {
        if((array1 == null && array2 != null && array2.length > 0)
            || (array2 == null && array1 != null && array1.length > 0)
            || (array1 != null && array2 != null && array1.length != array2.length)) {
            return false;
        }
        return true;
    }

    /**
     * <p>
     * Checks whether two arrays are the same length, treating <code>null</code>
     * arrays as length <code>0</code>.
     * </p>
     *
     * @param array1 the first배열, <code>null</code>도 가능함.
     * @param array2 the second배열, <code>null</code>도 가능함.
     * @return <code>true</code> if length of arrays matches, treating
     *         <code>null</code> as an empty array
     */
    public static boolean isSameLength(final int[] array1, final int[] array2) {
        if((array1 == null && array2 != null && array2.length > 0)
            || (array2 == null && array1 != null && array1.length > 0)
            || (array1 != null && array2 != null && array1.length != array2.length)) {
            return false;
        }
        return true;
    }

    /**
     * <p>
     * Checks whether two arrays are the same length, treating <code>null</code>
     * arrays as length <code>0</code>.
     * </p>
     *
     * @param array1 the first배열, <code>null</code>도 가능함.
     * @param array2 the second배열, <code>null</code>도 가능함.
     * @return <code>true</code> if length of arrays matches, treating
     *         <code>null</code> as an empty array
     */
    public static boolean isSameLength(final short[] array1, final short[] array2) {
        if((array1 == null && array2 != null && array2.length > 0)
            || (array2 == null && array1 != null && array1.length > 0)
            || (array1 != null && array2 != null && array1.length != array2.length)) {
            return false;
        }
        return true;
    }

    /**
     * <p>
     * Checks whether two arrays are the same length, treating <code>null</code>
     * arrays as length <code>0</code>.
     * </p>
     *
     * @param array1 the first배열, <code>null</code>도 가능함.
     * @param array2 the second배열, <code>null</code>도 가능함.
     * @return <code>true</code> if length of arrays matches, treating
     *         <code>null</code> as an empty array
     */
    public static boolean isSameLength(final char[] array1, final char[] array2) {
        if((array1 == null && array2 != null && array2.length > 0)
            || (array2 == null && array1 != null && array1.length > 0)
            || (array1 != null && array2 != null && array1.length != array2.length)) {
            return false;
        }
        return true;
    }

    /**
     * <p>
     * Checks whether two arrays are the same length, treating <code>null</code>
     * arrays as length <code>0</code>.
     * </p>
     *
     * @param array1 the first배열, <code>null</code>도 가능함.
     * @param array2 the second배열, <code>null</code>도 가능함.
     * @return <code>true</code> if length of arrays matches, treating
     *         <code>null</code> as an empty array
     */
    public static boolean isSameLength(final byte[] array1, final byte[] array2) {
        if((array1 == null && array2 != null && array2.length > 0)
            || (array2 == null && array1 != null && array1.length > 0)
            || (array1 != null && array2 != null && array1.length != array2.length)) {
            return false;
        }
        return true;
    }

    /**
     * <p>
     * Checks whether two arrays are the same length, treating <code>null</code>
     * arrays as length <code>0</code>.
     * </p>
     *
     * @param array1 the first배열, <code>null</code>도 가능함.
     * @param array2 the second배열, <code>null</code>도 가능함.
     * @return <code>true</code> if length of arrays matches, treating
     *         <code>null</code> as an empty array
     */
    public static boolean isSameLength(final double[] array1, final double[] array2) {
        if((array1 == null && array2 != null && array2.length > 0)
            || (array2 == null && array1 != null && array1.length > 0)
            || (array1 != null && array2 != null && array1.length != array2.length)) {
            return false;
        }
        return true;
    }

    /**
     * <p>
     * Checks whether two arrays are the same length, treating <code>null</code>
     * arrays as length <code>0</code>.
     * </p>
     *
     * @param array1 the first배열, <code>null</code>도 가능함.
     * @param array2 the second배열, <code>null</code>도 가능함.
     * @return <code>true</code> if length of arrays matches, treating
     *         <code>null</code> as an empty array
     */
    public static boolean isSameLength(final float[] array1, final float[] array2) {
        if((array1 == null && array2 != null && array2.length > 0)
            || (array2 == null && array1 != null && array1.length > 0)
            || (array1 != null && array2 != null && array1.length != array2.length)) {
            return false;
        }
        return true;
    }

    /**
     * <p>
     * Checks whether two arrays are the same length, treating <code>null</code>
     * arrays as length <code>0</code>.
     * </p>
     *
     * @param array1 the first배열, <code>null</code>도 가능함.
     * @param array2 the second배열, <code>null</code>도 가능함.
     * @return <code>true</code> if length of arrays matches, treating
     *         <code>null</code> as an empty array
     */
    public static boolean isSameLength(final boolean[] array1, final boolean[] array2) {
        if((array1 == null && array2 != null && array2.length > 0)
            || (array2 == null && array1 != null && array1.length > 0)
            || (array1 != null && array2 != null && array1.length != array2.length)) {
            return false;
        }
        return true;
    }

    /**
     * <p>
     * Checks whether two arrays are the same type taking into account
     * multi-dimensional arrays.
     * </p>
     *
     * @param array1 the first array, must not be <code>null</code>
     * @param array2 the second array, must not be <code>null</code>
     * @return <code>true</code> if type of arrays matches
     * @throws IllegalArgumentException if either array is <code>null</code>
     */
    public static boolean isSameType(final Object array1, final Object array2) {
        if(array1 == null || array2 == null) {
        	try {
        		throw new IllegalArgumentException("The Array must not be null");
			} catch (IllegalArgumentException e) {
				logger.error("", e);
			}
        }
        return array1.getClass().getName().equals(array2.getClass().getName());
    }

    // Reverse
    // -----------------------------------------------------------------------
    /**
     * <p>
     * Reverses the order of the given array.
     * </p>
     * <p>
     * There is no special handling for multi-dimensional arrays.
     * </p>
     * <p>
     * This method does nothing if <code>null</code> array input.
     * </p>
     *
     * @param array the array to reverse, <code>null</code>도 가능함.
     */
    public static void reverse(final Object[] array) {
        if(array == null) {
            return;
        }
        int i = 0;
        int j = array.length - 1;
        Object tmp;
        while(j > i) {
            tmp = array[j];
            array[j] = array[i];
            array[i] = tmp;
            j--;
            i++;
        }
    }

    /**
     * <p>
     * Reverses the order of the given array.
     * </p>
     * <p>
     * This method does nothing if <code>null</code> array input.
     * </p>
     *
     * @param array the array to reverse, <code>null</code>도 가능함.
     */
    public static void reverse(final long[] array) {
        if(array == null) {
            return;
        }
        int i = 0;
        int j = array.length - 1;
        long tmp;
        while(j > i) {
            tmp = array[j];
            array[j] = array[i];
            array[i] = tmp;
            j--;
            i++;
        }
    }

    /**
     * <p>
     * Reverses the order of the given array.
     * </p>
     * <p>
     * This method does nothing if <code>null</code> array input.
     * </p>
     *
     * @param array the array to reverse, <code>null</code>도 가능함.
     */
    public static void reverse(final int[] array) {
        if(array == null) {
            return;
        }
        int i = 0;
        int j = array.length - 1;
        int tmp;
        while(j > i) {
            tmp = array[j];
            array[j] = array[i];
            array[i] = tmp;
            j--;
            i++;
        }
    }

    /**
     * <p>
     * Reverses the order of the given array.
     * </p>
     * <p>
     * This method does nothing if <code>null</code> array input.
     * </p>
     *
     * @param array the array to reverse, <code>null</code>도 가능함.
     */
    public static void reverse(final short[] array) {
        if(array == null) {
            return;
        }
        int i = 0;
        int j = array.length - 1;
        short tmp;
        while(j > i) {
            tmp = array[j];
            array[j] = array[i];
            array[i] = tmp;
            j--;
            i++;
        }
    }

    /**
     * <p>
     * Reverses the order of the given array.
     * </p>
     * <p>
     * This method does nothing if <code>null</code> array input.
     * </p>
     *
     * @param array the array to reverse, <code>null</code>도 가능함.
     */
    public static void reverse(final char[] array) {
        if(array == null) {
            return;
        }
        int i = 0;
        int j = array.length - 1;
        char tmp;
        while(j > i) {
            tmp = array[j];
            array[j] = array[i];
            array[i] = tmp;
            j--;
            i++;
        }
    }

    /**
     * <p>
     * Reverses the order of the given array.
     * </p>
     * <p>
     * This method does nothing if <code>null</code> array input.
     * </p>
     *
     * @param array the array to reverse, <code>null</code>도 가능함.
     */
    public static void reverse(final byte[] array) {
        if(array == null) {
            return;
        }
        int i = 0;
        int j = array.length - 1;
        byte tmp;
        while(j > i) {
            tmp = array[j];
            array[j] = array[i];
            array[i] = tmp;
            j--;
            i++;
        }
    }

    /**
     * <p>
     * Reverses the order of the given array.
     * </p>
     * <p>
     * This method does nothing if <code>null</code> array input.
     * </p>
     *
     * @param array the array to reverse, <code>null</code>도 가능함.
     */
    public static void reverse(final double[] array) {
        if(array == null) {
            return;
        }
        int i = 0;
        int j = array.length - 1;
        double tmp;
        while(j > i) {
            tmp = array[j];
            array[j] = array[i];
            array[i] = tmp;
            j--;
            i++;
        }
    }

    /**
     * <p>
     * Reverses the order of the given array.
     * </p>
     * <p>
     * This method does nothing if <code>null</code> array input.
     * </p>
     *
     * @param array the array to reverse, <code>null</code>도 가능함.
     */
    public static void reverse(final float[] array) {
        if(array == null) {
            return;
        }
        int i = 0;
        int j = array.length - 1;
        float tmp;
        while(j > i) {
            tmp = array[j];
            array[j] = array[i];
            array[i] = tmp;
            j--;
            i++;
        }
    }

    /**
     * <p>
     * Reverses the order of the given array.
     * </p>
     * <p>
     * This method does nothing if <code>null</code> array input.
     * </p>
     *
     * @param array the array to reverse, <code>null</code>도 가능함.
     */
    public static void reverse(final boolean[] array) {
        if(array == null) {
            return;
        }
        int i = 0;
        int j = array.length - 1;
        boolean tmp;
        while(j > i) {
            tmp = array[j];
            array[j] = array[i];
            array[i] = tmp;
            j--;
            i++;
        }
    }

    // IndexOf search
    // ----------------------------------------------------------------------

    // Object IndexOf
    // -----------------------------------------------------------------------
    /**
     * <p>
     * 주어진 배열안에 존재하는 지정한 값의 인덱스를 얻음.
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     *
     * @param array 대상 배열, <code>null</code>도 가능함.
     * @param objectToFind 찾고자 하는 값, <code>null</code>도 가능함.
     * @return 배열안에 존재하는 지정한 값의 인덱스
     */
    public static int indexOf(final Object[] array, final Object objectToFind) {
        return indexOf(array, objectToFind, 0);
    }

    /**
     * <p>
     * 주어진 배열안에 존재하는 지정한 값의 인덱스를 얻음.
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     * <p>
     * startIndex에 음수 입력시는 0부터 시작함.<br>
     * startIndex가 주어진 배열의 길이보다 크다면 -1 리턴함
     * </p>
     *
     * @param array 대상 배열, <code>null</code>도 가능함.
     * @param objectToFind 찾고자 하는 값, <code>null</code>도 가능함.
     * @param startIndex 찾고자 하는 인덱스의 최종값
     * @return 배열안에 존재하는 지정한 값의 인덱스
     */
    public static int indexOf(final Object[] array, final Object objectToFind, int startIndex) {
        if(array == null) {
            return -1;
        }
        if(startIndex < 0) {
            startIndex = 0;
        }
        if(objectToFind == null) {
            for(int i = startIndex ; i < array.length ; i++) {
                if(array[i] == null) {
                    return i;
                }
            }
        } else {
            for(int i = startIndex ; i < array.length ; i++) {
                if(objectToFind.equals(array[i])) {
                    return i;
                }
            }
        }
        return -1;
    }

    /**
     * <p>
     * 주어진 배열안에 존재하는 지정한 값의 마지막 인덱스를 얻음.
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     *
     * @param array 대상 배열, <code>null</code>도 가능함.
     * @param objectToFind 찾고자 하는 값, <code>null</code>도 가능함.
     * @return 배열안에 존재하는 지정한 값의 최종 인덱스
     */
    public static int lastIndexOf(final Object[] array, final Object objectToFind) {
        return lastIndexOf(array, objectToFind, Integer.MAX_VALUE);
    }

    /**
     * <p>
     * 주어진 배열안에 존재하는 지정한 값의 마지막 인덱스를 얻음.
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     * <p>
     * A negative startIndex will return <code>-1</code>. A startIndex larger
     * than the array 시작 인덱스가 배열의 길이보다 크다면 끝에서 부터 찾는다.
     *
     * @param array 대상 배열, <code>null</code>도 가능함.
     * @param objectToFind 찾고자 하는 값, <code>null</code>도 가능함.
     * @param startIndex 찾고자 하는 인덱스의 최종값 (뒤에서 부터 검색함)
     * @return 배열안에 존재하는 지정한 값의 최종 인덱스
     */
    public static int lastIndexOf(final Object[] array, final Object objectToFind, int startIndex) {
        if(array == null) {
            return -1;
        }
        if(startIndex < 0) {
            return -1;
        } else if(startIndex >= array.length) {
            startIndex = array.length - 1;
        }
        if(objectToFind == null) {
            for(int i = startIndex ; i >= 0 ; i--) {
                if(array[i] == null) {
                    return i;
                }
            }
        } else {
            for(int i = startIndex ; i >= 0 ; i--) {
                if(objectToFind.equals(array[i])) {
                    return i;
                }
            }
        }
        return -1;
    }

    /**
     * <p>
     * 주어진 배열안에 지정한 값이 존재하는지 여부를 확인함.
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>false</code> 리턴함.
     * </p>
     *
     * @param array 대상 배열
     * @param objectToFind 찾고자 하는 값
     * @return 값이 존재한다면 <code>true</code> 리턴
     */
    public static boolean contains(final Object[] array, final Object objectToFind) {
        return (indexOf(array, objectToFind) != -1);
    }

    // long IndexOf
    // -----------------------------------------------------------------------
    /**
     * <p>
     * 주어진 값의 인덱스를 배열에서 찾는다
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     *
     * @param array 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @return 배열안에 존재하는 지정한 값의 인덱스
     */
    public static int indexOf(final long[] array, final long valueToFind) {
        return indexOf(array, valueToFind, 0);
    }

    /**
     * <p>
     * 주어진 인덱스부터 지정한 값의 인덱스를 배열에서 찾는다
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     * <p>
     * startIndex에 음수 입력시는 0부터 시작함.<br>
     * startIndex가 주어진 배열의 길이보다 크다면 -1 리턴함
     * </p>
     *
     * @param array 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @param startIndex 찾아야 하는 시작 인덱스
     * @return 배열안에 존재하는 지정한 값의 인덱스
     */
    public static int indexOf(final long[] array, final long valueToFind, int startIndex) {
        if(array == null) {
            return -1;
        }
        if(startIndex < 0) {
            startIndex = 0;
        }
        for(int i = startIndex ; i < array.length ; i++) {
            if(valueToFind == array[i]) {
                return i;
            }
        }
        return -1;
    }

    /**
     * <p>
     * 배열안에 지정한 값이 존재하는 최종 인덱스 값을 얻음.
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     *
     * @param array 뒤로 부터 검색할 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾고자 하는 값
     * @return 배열안에 존재하는 지정한 값의 최종 인덱스
     */
    public static int lastIndexOf(final long[] array, final long valueToFind) {
        return lastIndexOf(array, valueToFind, Integer.MAX_VALUE);
    }

    /**
     * <p>
     * 주어진 값을 배열에서 오차범위내에서 찾아 최종 인덱스를 얻는다.<br>
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     * 시작 인덱스가 음수라면 -1 리턴함<br>
     * 시작 인덱스가 배열의 길이보다 크다면 끝에서 부터 찾는다.
     *
     * @param array 찾고자 하는 값, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @param startIndex 뒤로 부터 검색할 시작 인덱스
     * @return 배열안에 존재하는 지정한 값의 최종 인덱스
     */
    public static int lastIndexOf(final long[] array, final long valueToFind, int startIndex) {
        if(array == null) {
            return -1;
        }
        if(startIndex < 0) {
            return -1;
        } else if(startIndex >= array.length) {
            startIndex = array.length - 1;
        }
        for(int i = startIndex ; i >= 0 ; i--) {
            if(valueToFind == array[i]) {
                return i;
            }
        }
        return -1;
    }

    /**
     * <p>
     * 배열안에 지정한 값이 존재하는지 체크함.
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>false</code> 리턴함.
     * </p>
     *
     * @param array 찾을 대상 배열
     * @param valueToFind 찾아야 할 값
     * @return 지정한 값이 존재한다면 <code>true</code> 리턴
     */
    public static boolean contains(final long[] array, final long valueToFind) {
        return (indexOf(array, valueToFind) != -1);
    }

    // int IndexOf
    // -----------------------------------------------------------------------
    /**
     * <p>
     * 주어진 값의 인덱스를 배열에서 찾는다
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     *
     * @param array 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @return 배열안에 존재하는 지정한 값의 인덱스
     */
    public static int indexOf(final int[] array, final int valueToFind) {
        return indexOf(array, valueToFind, 0);
    }

    /**
     * <p>
     * 주어진 인덱스부터 지정한 값의 인덱스를 배열에서 찾는다
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     * <p>
     * startIndex에 음수 입력시는 0부터 시작함.<br>
     * startIndex가 주어진 배열의 길이보다 크다면 -1 리턴함
     * </p>
     *
     * @param array 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @param startIndex 찾아야 하는 시작 인덱스
     * @return 배열안에 존재하는 지정한 값의 인덱스
     */
    public static int indexOf(final int[] array, final int valueToFind, int startIndex) {
        if(array == null) {
            return -1;
        }
        if(startIndex < 0) {
            startIndex = 0;
        }
        for(int i = startIndex ; i < array.length ; i++) {
            if(valueToFind == array[i]) {
                return i;
            }
        }
        return -1;
    }

    /**
     * <p>
     * 배열안에 지정한 값이 존재하는 최종 인덱스 값을 얻음.
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     *
     * @param array 뒤로 부터 검색할 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾고자 하는 값
     * @return 배열안에 존재하는 지정한 값의 최종 인덱스
     */
    public static int lastIndexOf(final int[] array, final int valueToFind) {
        return lastIndexOf(array, valueToFind, Integer.MAX_VALUE);
    }

    /**
     * <p>
     * 주어진 값을 배열에서 오차범위내에서 찾아 최종 인덱스를 얻는다.<br>
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     * 시작 인덱스가 음수라면 -1 리턴함<br>
     * 시작 인덱스가 배열의 길이보다 크다면 끝에서 부터 찾는다.
     *
     * @param array 찾고자 하는 값, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @param startIndex 뒤로 부터 검색할 시작 인덱스
     * @return 배열안에 존재하는 지정한 값의 최종 인덱스
     */
    public static int lastIndexOf(final int[] array, final int valueToFind, int startIndex) {
        if(array == null) {
            return -1;
        }
        if(startIndex < 0) {
            return -1;
        } else if(startIndex >= array.length) {
            startIndex = array.length - 1;
        }
        for(int i = startIndex ; i >= 0 ; i--) {
            if(valueToFind == array[i]) {
                return i;
            }
        }
        return -1;
    }

    /**
     * <p>
     * 배열안에 지정한 값이 존재하는지 체크함.
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>false</code> 리턴함.
     * </p>
     *
     * @param array 찾을 대상 배열
     * @param valueToFind 찾아야 할 값
     * @return 지정한 값이 존재한다면 <code>true</code> 리턴
     */
    public static boolean contains(final int[] array, final int valueToFind) {
        return (indexOf(array, valueToFind) != -1);
    }

    // short IndexOf
    // -----------------------------------------------------------------------
    /**
     * <p>
     * 주어진 값의 인덱스를 배열에서 찾는다
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     *
     * @param array 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @return 배열안에 존재하는 지정한 값의 인덱스
     */
    public static int indexOf(final short[] array, final short valueToFind) {
        return indexOf(array, valueToFind, 0);
    }

    /**
     * <p>
     * 주어진 인덱스부터 지정한 값의 인덱스를 배열에서 찾는다
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     * <p>
     * startIndex에 음수 입력시는 0부터 시작함.<br>
     * startIndex가 주어진 배열의 길이보다 크다면 -1 리턴함
     * </p>
     *
     * @param array 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @param startIndex 찾아야 하는 시작 인덱스
     * @return 배열안에 존재하는 지정한 값의 인덱스
     */
    public static int indexOf(final short[] array, final short valueToFind, int startIndex) {
        if(array == null) {
            return -1;
        }
        if(startIndex < 0) {
            startIndex = 0;
        }
        for(int i = startIndex ; i < array.length ; i++) {
            if(valueToFind == array[i]) {
                return i;
            }
        }
        return -1;
    }

    /**
     * <p>
     * 배열안에 지정한 값이 존재하는 최종 인덱스 값을 얻음.
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     *
     * @param array 뒤로 부터 검색할 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾고자 하는 값
     * @return 배열안에 존재하는 지정한 값의 최종 인덱스
     */
    public static int lastIndexOf(final short[] array, final short valueToFind) {
        return lastIndexOf(array, valueToFind, Integer.MAX_VALUE);
    }

    /**
     * <p>
     * 주어진 값을 배열에서 오차범위내에서 찾아 최종 인덱스를 얻는다.<br>
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     * 시작 인덱스가 음수라면 -1 리턴함<br>
     * 시작 인덱스가 배열의 길이보다 크다면 끝에서 부터 찾는다.
     *
     * @param array 찾고자 하는 값, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @param startIndex 뒤로 부터 검색할 시작 인덱스
     * @return 배열안에 존재하는 지정한 값의 최종 인덱스
     */
    public static int lastIndexOf(final short[] array, final short valueToFind, int startIndex) {
        if(array == null) {
            return -1;
        }
        if(startIndex < 0) {
            return -1;
        } else if(startIndex >= array.length) {
            startIndex = array.length - 1;
        }
        for(int i = startIndex ; i >= 0 ; i--) {
            if(valueToFind == array[i]) {
                return i;
            }
        }
        return -1;
    }

    /**
     * <p>
     * 배열안에 지정한 값이 존재하는지 체크함.
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>false</code> 리턴함.
     * </p>
     *
     * @param array 찾을 대상 배열
     * @param valueToFind 찾아야 할 값
     * @return 지정한 값이 존재한다면 <code>true</code> 리턴
     */
    public static boolean contains(final short[] array, final short valueToFind) {
        return (indexOf(array, valueToFind) != -1);
    }

    // byte IndexOf
    // -----------------------------------------------------------------------
    /**
     * <p>
     * 주어진 값의 인덱스를 배열에서 찾는다
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     *
     * @param array 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @return 배열안에 존재하는 지정한 값의 인덱스
     */
    public static int indexOf(final byte[] array, final byte valueToFind) {
        return indexOf(array, valueToFind, 0);
    }

    /**
     * <p>
     * 주어진 인덱스부터 지정한 값의 인덱스를 배열에서 찾는다
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     * <p>
     * startIndex에 음수 입력시는 0부터 시작함.<br>
     * startIndex가 주어진 배열의 길이보다 크다면 -1 리턴함
     * </p>
     *
     * @param array 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @param startIndex 찾아야 하는 시작 인덱스
     * @return 배열안에 존재하는 지정한 값의 인덱스
     */
    public static int indexOf(final byte[] array, final byte valueToFind, int startIndex) {
        if(array == null) {
            return -1;
        }
        if(startIndex < 0) {
            startIndex = 0;
        }
        for(int i = startIndex ; i < array.length ; i++) {
            if(valueToFind == array[i]) {
                return i;
            }
        }
        return -1;
    }

    /**
     * <p>
     * 배열안에 지정한 값이 존재하는 최종 인덱스 값을 얻음.
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     *
     * @param array 뒤로 부터 검색할 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾고자 하는 값
     * @return 배열안에 존재하는 지정한 값의 최종 인덱스
     */
    public static int lastIndexOf(final byte[] array, final byte valueToFind) {
        return lastIndexOf(array, valueToFind, Integer.MAX_VALUE);
    }

    /**
     * <p>
     * 주어진 값을 배열에서 오차범위내에서 찾아 최종 인덱스를 얻는다.<br>
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     * 시작 인덱스가 음수라면 -1 리턴함<br>
     * 시작 인덱스가 배열의 길이보다 크다면 끝에서 부터 찾는다.
     *
     * @param array 찾고자 하는 값, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @param startIndex 뒤로 부터 검색할 시작 인덱스
     * @return 배열안에 존재하는 지정한 값의 최종 인덱스
     */
    public static int lastIndexOf(final byte[] array, final byte valueToFind, int startIndex) {
        if(array == null) {
            return -1;
        }
        if(startIndex < 0) {
            return -1;
        } else if(startIndex >= array.length) {
            startIndex = array.length - 1;
        }
        for(int i = startIndex ; i >= 0 ; i--) {
            if(valueToFind == array[i]) {
                return i;
            }
        }
        return -1;
    }

    /**
     * <p>
     * 배열안에 지정한 값이 존재하는지 체크함.
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>false</code> 리턴함.
     * </p>
     *
     * @param array 찾을 대상 배열
     * @param valueToFind 찾아야 할 값
     * @return 지정한 값이 존재한다면 <code>true</code> 리턴
     */
    public static boolean contains(final byte[] array, final byte valueToFind) {
        return (indexOf(array, valueToFind) != -1);
    }

    // double IndexOf
    // -----------------------------------------------------------------------
    /**
     * <p>
     * 주어진 값의 인덱스를 배열에서 찾는다
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     *
     * @param array 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @return 배열안에 존재하는 지정한 값의 인덱스
     */
    public static int indexOf(final double[] array, final double valueToFind) {
        return indexOf(array, valueToFind, 0);
    }

    /**
     * <p>
     * Find the index of the given value within a given tolerance in the array.
     * [valueToFind - tolerance < 찾을 값 < valueToFind + tolerance] 을 만족하는 값을
     * 리턴한다. defined by valueToFind - tolerance and valueToFind + tolerance.
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     *
     * @param array 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @param tolerance 오차범위
     * @return 배열안에 존재하는 지정한 값의 인덱스
     */
    public static int indexOf(final double[] array, final double valueToFind, final double tolerance) {
        return indexOf(array, valueToFind, 0, tolerance);
    }

    /**
     * <p>
     * 주어진 인덱스부터 지정한 값의 인덱스를 배열에서 찾는다
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     * <p>
     * startIndex에 음수 입력시는 0부터 시작함.<br>
     * startIndex가 주어진 배열의 길이보다 크다면 -1 리턴함
     * </p>
     *
     * @param array 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @param startIndex 찾아야 하는 시작 인덱스
     * @return 배열안에 존재하는 지정한 값의 인덱스
     */
    public static int indexOf(final double[] array, final double valueToFind, int startIndex) {
        if(array == null || array.length == 0) {
            return -1;
        }
        if(startIndex < 0) {
            startIndex = 0;
        }
        for(int i = startIndex ; i < array.length ; i++) {
            if(valueToFind == array[i]) {
                return i;
            }
        }
        return -1;
    }

    /**
     * <p>
     * 주어진 인덱스부터 지정한 값의 인덱스를 배열에서 찾는다 [valueToFind - tolerance < 찾을 값 <
     * valueToFind + tolerance] 을 만족하는 값을 리턴한다.
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     * <p>
     * startIndex에 음수 입력시는 0부터 시작함.<br>
     * startIndex가 주어진 배열의 길이보다 크다면 -1 리턴함
     * </p>
     *
     * @param array 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @param startIndex 찾아야 하는 시작 인덱스
     * @param tolerance 오차범위
     * @return 배열안에 존재하는 지정한 값의 인덱스
     */
    public static int indexOf(final double[] array, final double valueToFind, int startIndex, double tolerance) {
        if(array == null || array.length == 0) {
            return -1;
        }
        if(startIndex < 0) {
            startIndex = 0;
        }
        double min = valueToFind - tolerance;
        double max = valueToFind + tolerance;
        for(int i = startIndex ; i < array.length ; i++) {
            if(array[i] >= min && array[i] <= max) {
                return i;
            }
        }
        return -1;
    }

    /**
     * <p>
     * 배열안에 지정한 값이 존재하는 최종 인덱스 값을 얻음.
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     *
     * @param array 뒤로 부터 검색할 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾고자 하는 값
     * @return 배열안에 존재하는 지정한 값의 최종 인덱스
     */
    public static int lastIndexOf(final double[] array, final double valueToFind) {
        return lastIndexOf(array, valueToFind, Integer.MAX_VALUE);
    }

    /**
     * <p>
     * Find the last index of the given value within a given tolerance in the
     * array. [valueToFind - tolerance < 찾을 값 < valueToFind + tolerance] 을 만족하는
     * 값을 리턴한다.
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     *
     * @param array 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @param tolerance 오차범위
     * @return 배열안에 존재하는 지정한 값의 인덱스
     */
    public static int lastIndexOf(final double[] array, final double valueToFind, final double tolerance) {
        return lastIndexOf(array, valueToFind, Integer.MAX_VALUE, tolerance);
    }

    /**
     * <p>
     * 주어진 값을 배열에서 오차범위내에서 찾아 최종 인덱스를 얻는다.<br>
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     * 시작 인덱스가 음수라면 -1 리턴함<br>
     * 시작 인덱스가 배열의 길이보다 크다면 끝에서 부터 찾는다.
     *
     * @param array 찾고자 하는 값, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @param startIndex 뒤로 부터 검색할 시작 인덱스
     * @return 배열안에 존재하는 지정한 값의 최종 인덱스
     */
    public static int lastIndexOf(final double[] array, final double valueToFind, int startIndex) {
        if(array == null || array.length == 0) {
            return -1;
        }
        if(startIndex < 0) {
            return -1;
        } else if(startIndex >= array.length) {
            startIndex = array.length - 1;
        }
        for(int i = startIndex ; i >= 0 ; i--) {
            if(valueToFind == array[i]) {
                return i;
            }
        }
        return -1;
    }

    /**
     * <p>
     * 주어진 값을 배열에서 오차범위내에서 찾아 최종 인덱스를 얻는다.<br>
     * [valueToFind - tolerance < 찾을 값 < valueToFind + tolerance] 을 만족하는 값을
     * 리턴한다.
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     * 시작 인덱스가 음수라면 -1 리턴함<br>
     * 시작 인덱스가 배열의 길이보다 크다면 끝에서 부터 찾는다.
     *
     * @param array 찾고자 하는 값, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @param startIndex 뒤로 부터 검색할 시작 인덱스
     * @param tolerance search for value within plus/minus this amount
     * @return 배열안에 존재하는 지정한 값의 최종 인덱스
     */
    public static int lastIndexOf(final double[] array, final double valueToFind, int startIndex, double tolerance) {
        if(array == null || array.length == 0) {
            return -1;
        }
        if(startIndex < 0) {
            return -1;
        } else if(startIndex >= array.length) {
            startIndex = array.length - 1;
        }
        double min = valueToFind - tolerance;
        double max = valueToFind + tolerance;
        for(int i = startIndex ; i >= 0 ; i--) {
            if(array[i] >= min && array[i] <= max) {
                return i;
            }
        }
        return -1;
    }

    /**
     * <p>
     * 배열안에 지정한 값이 존재하는지 체크함.
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>false</code> 리턴함.
     * </p>
     *
     * @param array 찾을 대상 배열
     * @param valueToFind 찾아야 할 값
     * @return 지정한 값이 존재한다면 <code>true</code> 리턴
     */
    public static boolean contains(final double[] array, final double valueToFind) {
        return (indexOf(array, valueToFind) != -1);
    }

    /**
     * <p>
     * Checks if a value falling within the given tolerance is in the given
     * array. If the array contains a value within the inclusive range defined
     * by (value - tolerance) to (value + tolerance).
     * </p>
     * <p>
     * The method returns <code>false</code> if <code>null</code> array is
     * passed in.
     * </p>
     *
     * @param array the array to search
     * @param valueToFind 찾아야 할 값
     * @param tolerance the array contains the 오차범위
     * @return true if value falling within tolerance is in array
     */
    public static boolean contains(final double[] array, final double valueToFind, final double tolerance) {
        return (indexOf(array, valueToFind, 0, tolerance) != -1);
    }

    // float IndexOf
    // -----------------------------------------------------------------------
    /**
     * <p>
     * 주어진 값의 인덱스를 배열에서 찾는다
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     *
     * @param array 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @return 배열안에 존재하는 지정한 값의 인덱스
     */
    public static int indexOf(final float[] array, final float valueToFind) {
        return indexOf(array, valueToFind, 0);
    }

    /**
     * <p>
     * 주어진 인덱스부터 지정한 값의 인덱스를 배열에서 찾는다
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     * <p>
     * startIndex에 음수 입력시는 0부터 시작함.<br>
     * startIndex가 주어진 배열의 길이보다 크다면 -1 리턴함
     * </p>
     *
     * @param array 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @param startIndex 찾아야 하는 시작 인덱스
     * @return 배열안에 존재하는 지정한 값의 인덱스
     */
    public static int indexOf(final float[] array, final float valueToFind, int startIndex) {
        if(array == null || array.length == 0) {
            return -1;
        }
        if(startIndex < 0) {
            startIndex = 0;
        }
        for(int i = startIndex ; i < array.length ; i++) {
            if(valueToFind == array[i]) {
                return i;
            }
        }
        return -1;
    }

    /**
     * <p>
     * 배열안에 지정한 값이 존재하는 최종 인덱스 값을 얻음.
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     *
     * @param array 뒤로 부터 검색할 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾고자 하는 값
     * @return 배열안에 존재하는 지정한 값의 최종 인덱스
     */
    public static int lastIndexOf(final float[] array, final float valueToFind) {
        return lastIndexOf(array, valueToFind, Integer.MAX_VALUE);
    }

    /**
     * <p>
     * 주어진 값을 배열에서 오차범위내에서 찾아 최종 인덱스를 얻는다.<br>
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     * 시작 인덱스가 음수라면 -1 리턴함<br>
     * 시작 인덱스가 배열의 길이보다 크다면 끝에서 부터 찾는다.
     *
     * @param array 찾고자 하는 값, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @param startIndex 뒤로 부터 검색할 시작 인덱스
     * @return 배열안에 존재하는 지정한 값의 최종 인덱스
     */
    public static int lastIndexOf(final float[] array, final float valueToFind, int startIndex) {
        if(array == null || array.length == 0) {
            return -1;
        }
        if(startIndex < 0) {
            return -1;
        } else if(startIndex >= array.length) {
            startIndex = array.length - 1;
        }
        for(int i = startIndex ; i >= 0 ; i--) {
            if(valueToFind == array[i]) {
                return i;
            }
        }
        return -1;
    }

    /**
     * <p>
     * 배열안에 지정한 값이 존재하는지 체크함.
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>false</code> 리턴함.
     * </p>
     *
     * @param array 찾을 대상 배열
     * @param valueToFind 찾아야 할 값
     * @return 지정한 값이 존재한다면 <code>true</code> 리턴
     */
    public static boolean contains(final float[] array, final float valueToFind) {
        return (indexOf(array, valueToFind) != -1);
    }

    // boolean IndexOf
    // -----------------------------------------------------------------------
    /**
     * <p>
     * 주어진 값의 인덱스를 배열에서 찾는다
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     *
     * @param array 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @return 배열안에 존재하는 지정한 값의 인덱스
     */
    public static int indexOf(final boolean[] array, final boolean valueToFind) {
        return indexOf(array, valueToFind, 0);
    }

    /**
     * <p>
     * 주어진 인덱스부터 지정한 값의 인덱스를 배열에서 찾는다
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     * <p>
     * startIndex에 음수 입력시는 0부터 시작함.<br>
     * startIndex가 주어진 배열의 길이보다 크다면 -1 리턴함
     * </p>
     *
     * @param array 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @param startIndex 찾아야 하는 시작 인덱스
     * @return 배열안에 존재하는 지정한 값의 인덱스
     */
    public static int indexOf(final boolean[] array, final boolean valueToFind, int startIndex) {
        if(array == null || array.length == 0) {
            return -1;
        }
        if(startIndex < 0) {
            startIndex = 0;
        }
        for(int i = startIndex ; i < array.length ; i++) {
            if(valueToFind == array[i]) {
                return i;
            }
        }
        return -1;
    }

    /**
     * <p>
     * 배열안에 지정한 값이 존재하는 최종 인덱스 값을 얻음.
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     *
     * @param array 뒤로 부터 검색할 대상 배열, <code>null</code>도 가능함.
     * @param valueToFind 찾고자 하는 값
     * @return 배열안에 존재하는 지정한 값의 최종 인덱스
     */
    public static int lastIndexOf(final boolean[] array, final boolean valueToFind) {
        return lastIndexOf(array, valueToFind, Integer.MAX_VALUE);
    }

    /**
     * <p>
     * 주어진 값을 배열에서 오차범위내에서 찾아 최종 인덱스를 얻는다.<br>
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>-1</code> 리턴함.
     * </p>
     * 시작 인덱스가 음수라면 -1 리턴함<br>
     * 시작 인덱스가 배열의 길이보다 크다면 끝에서 부터 찾는다.
     *
     * @param array 찾고자 하는 값, <code>null</code>도 가능함.
     * @param valueToFind 찾아야 할 값
     * @param startIndex 뒤로 부터 검색할 시작 인덱스
     * @return 배열안에 존재하는 지정한 값의 최종 인덱스
     */
    public static int lastIndexOf(final boolean[] array, final boolean valueToFind, int startIndex) {
        if(array == null || array.length == 0) {
            return -1;
        }
        if(startIndex < 0) {
            return -1;
        } else if(startIndex >= array.length) {
            startIndex = array.length - 1;
        }
        for(int i = startIndex ; i >= 0 ; i--) {
            if(valueToFind == array[i]) {
                return i;
            }
        }
        return -1;
    }

    /**
     * <p>
     * 배열안에 지정한 값이 존재하는지 체크함.
     * </p>
     * <p>
     * <code>null</code> 입력시 <code>false</code> 리턴함.
     * </p>
     *
     * @param array 찾을 대상 배열
     * @param valueToFind 찾아야 할 값
     * @return 지정한 값이 존재한다면 <code>true</code> 리턴
     */
    public static boolean contains(final boolean[] array, final boolean valueToFind) {
        return (indexOf(array, valueToFind) != -1);
    }

    // Primitive/Object array converters
    // ----------------------------------------------------------------------

    // Long array converters
    // ----------------------------------------------------------------------
    /**
     * <p>
     * 오브젝트 배열 Longs 에 대한 원시타입 배열을 얻는다.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array <code>Long</code>배열, <code>null</code>도 가능함.
     * @return <code>long</code> 배열, null 입력시 <code>null</code> 리턴함
     * @throws NullPointerException <code>null</code> 입력값일 경우 발생.
     */
    public static long[] toPrimitive(final Long[] array) {
        if(array == null) {
            return null;
        } else if(array.length == 0) {
            return EMPTY_LONG_ARRAY;
        }
        final long[] result = new long[array.length];
        for(int i = 0 ; i < array.length ; i++) {
            result[i] = array[i].longValue();
        }
        return result;
    }

    /**
     * <p>
     * 오브젝트 배열 Long 에 대한 null을 다루는 원시타입 배열을 얻는다.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array <code>Long</code>배열, <code>null</code>도 가능함.
     * @param valueForNull 배열요소가 null일 경우 기본 할당값
     * @return <code>long</code> 배열, null 입력시 <code>null</code> 리턴함
     */
    public static long[] toPrimitive(final Long[] array, final long valueForNull) {
        if(array == null) {
            return null;
        } else if(array.length == 0) {
            return EMPTY_LONG_ARRAY;
        }
        final long[] result = new long[array.length];
        for(int i = 0 ; i < array.length ; i++) {
            Long b = array[i];
            result[i] = (b == null ? valueForNull : b.longValue());
        }
        return result;
    }

    /**
     * <p>
     * 원시타입 배열 longs에 대한 오브젝트 배열을 얻는다.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array <code>long</code> array
     * @return <code>Long</code> 배열, null 입력시 <code>null</code> 리턴함
     */
    public static Long[] toObject(final long[] array) {
        if(array == null) {
            return null;
        } else if(array.length == 0) {
            return EMPTY_LONG_OBJECT_ARRAY;
        }
        final Long[] result = new Long[array.length];
        for(int i = 0 ; i < array.length ; i++) {
            result[i] = new Long(array[i]);
        }
        return result;
    }

    // Int array converters
    // ----------------------------------------------------------------------
    /**
     * <p>
     * 오브젝트 배열 Integers 에 대한 원시타입 배열을 얻는다.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array <code>Integer</code>배열, <code>null</code>도 가능함.
     * @return an <code>int</code> 배열, null 입력시 <code>null</code> 리턴함
     * @throws NullPointerException <code>null</code> 입력값일 경우 발생.
     */
    public static int[] toPrimitive(final Integer[] array) {
        if(array == null) {
            return null;
        } else if(array.length == 0) {
            return EMPTY_INT_ARRAY;
        }
        final int[] result = new int[array.length];
        for(int i = 0 ; i < array.length ; i++) {
            result[i] = array[i].intValue();
        }
        return result;
    }

    /**
     * <p>
     * 오브젝트 배열 Integer 에 대한 null을 다루는 원시타입 배열을 얻는다.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array <code>Integer</code>배열, <code>null</code>도 가능함.
     * @param valueForNull 배열요소가 null일 경우 기본 할당값
     * @return an <code>int</code> 배열, null 입력시 <code>null</code> 리턴함
     */
    public static int[] toPrimitive(final Integer[] array, final int valueForNull) {
        if(array == null) {
            return null;
        } else if(array.length == 0) {
            return EMPTY_INT_ARRAY;
        }
        final int[] result = new int[array.length];
        for(int i = 0 ; i < array.length ; i++) {
            Integer b = array[i];
            result[i] = (b == null ? valueForNull : b.intValue());
        }
        return result;
    }

    /**
     * <p>
     * 원시타입 배열 ints에 대한 오브젝트 배열을 얻는다.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array an <code>int</code> array
     * @return an <code>Integer</code> 배열, null 입력시 <code>null</code> 리턴함
     */
    public static Integer[] toObject(final int[] array) {
        if(array == null) {
            return null;
        } else if(array.length == 0) {
            return EMPTY_INTEGER_OBJECT_ARRAY;
        }
        final Integer[] result = new Integer[array.length];
        for(int i = 0 ; i < array.length ; i++) {
            result[i] = new Integer(array[i]);
        }
        return result;
    }

    // Short array converters
    // ----------------------------------------------------------------------
    /**
     * <p>
     * 오브젝트 배열 Shorts 에 대한 원시타입 배열을 얻는다.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array <code>Short</code>배열, <code>null</code>도 가능함.
     * @return <code>byte</code> 배열, null 입력시 <code>null</code> 리턴함
     * @throws NullPointerException <code>null</code> 입력값일 경우 발생.
     */
    public static short[] toPrimitive(final Short[] array) {
        if(array == null) {
            return null;
        } else if(array.length == 0) {
            return EMPTY_SHORT_ARRAY;
        }
        final short[] result = new short[array.length];
        for(int i = 0 ; i < array.length ; i++) {
            result[i] = array[i].shortValue();
        }
        return result;
    }

    /**
     * <p>
     * 오브젝트 배열 Short 에 대한 null을 다루는 원시타입 배열을 얻는다.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array <code>Short</code>배열, <code>null</code>도 가능함.
     * @param valueForNull 배열요소가 null일 경우 기본 할당값
     * @return <code>byte</code> 배열, null 입력시 <code>null</code> 리턴함
     */
    public static short[] toPrimitive(final Short[] array, final short valueForNull) {
        if(array == null) {
            return null;
        } else if(array.length == 0) {
            return EMPTY_SHORT_ARRAY;
        }
        final short[] result = new short[array.length];
        for(int i = 0 ; i < array.length ; i++) {
            Short b = array[i];
            result[i] = (b == null ? valueForNull : b.shortValue());
        }
        return result;
    }

    /**
     * <p>
     * 원시타입 배열 shorts에 대한 오브젝트 배열을 얻는다.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array <code>short</code> array
     * @return <code>Short</code> 배열, null 입력시 <code>null</code> 리턴함
     */
    public static Short[] toObject(final short[] array) {
        if(array == null) {
            return null;
        } else if(array.length == 0) {
            return EMPTY_SHORT_OBJECT_ARRAY;
        }
        final Short[] result = new Short[array.length];
        for(int i = 0 ; i < array.length ; i++) {
            result[i] = new Short(array[i]);
        }
        return result;
    }

    // Byte array converters
    // ----------------------------------------------------------------------
    /**
     * <p>
     * 오브젝트 배열 Bytes 에 대한 원시타입 배열을 얻는다.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array <code>Byte</code>배열, <code>null</code>도 가능함.
     * @return <code>byte</code> 배열, null 입력시 <code>null</code> 리턴함
     * @throws NullPointerException <code>null</code> 입력값일 경우 발생.
     */
    public static byte[] toPrimitive(final Byte[] array) {
        if(array == null) {
            return null;
        } else if(array.length == 0) {
            return EMPTY_BYTE_ARRAY;
        }
        final byte[] result = new byte[array.length];
        for(int i = 0 ; i < array.length ; i++) {
            result[i] = array[i].byteValue();
        }
        return result;
    }

    /**
     * <p>
     * 오브젝트 배열 Bytes 에 대한 null을 다루는 원시타입 배열을 얻는다.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array <code>Byte</code>배열, <code>null</code>도 가능함.
     * @param valueForNull 배열요소가 null일 경우 기본 할당값
     * @return <code>byte</code> 배열, null 입력시 <code>null</code> 리턴함
     */
    public static byte[] toPrimitive(final Byte[] array, final byte valueForNull) {
        if(array == null) {
            return null;
        } else if(array.length == 0) {
            return EMPTY_BYTE_ARRAY;
        }
        final byte[] result = new byte[array.length];
        for(int i = 0 ; i < array.length ; i++) {
            Byte b = array[i];
            result[i] = (b == null ? valueForNull : b.byteValue());
        }
        return result;
    }

    /**
     * <p>
     * 원시타입 배열 bytes에 대한 오브젝트 배열을 얻는다.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array <code>byte</code> array
     * @return <code>Byte</code> 배열, null 입력시 <code>null</code> 리턴함
     */
    public static Byte[] toObject(final byte[] array) {
        if(array == null) {
            return null;
        } else if(array.length == 0) {
            return EMPTY_BYTE_OBJECT_ARRAY;
        }
        final Byte[] result = new Byte[array.length];
        for(int i = 0 ; i < array.length ; i++) {
            result[i] = new Byte(array[i]);
        }
        return result;
    }

    // Double array converters
    // ----------------------------------------------------------------------
    /**
     * <p>
     * 오브젝트 배열 Doubles 에 대한 원시타입 배열을 얻는다.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array <code>Double</code>배열, <code>null</code>도 가능함.
     * @return <code>double</code> 배열, null 입력시 <code>null</code> 리턴함
     * @throws NullPointerException <code>null</code> 입력값일 경우 발생.
     */
    public static double[] toPrimitive(final Double[] array) {
        if(array == null) {
            return null;
        } else if(array.length == 0) {
            return EMPTY_DOUBLE_ARRAY;
        }
        final double[] result = new double[array.length];
        for(int i = 0 ; i < array.length ; i++) {
            result[i] = array[i].doubleValue();
        }
        return result;
    }

    /**
     * <p>
     * 오브젝트 배열 Doubles 에 대한 null을 다루는 원시타입 배열을 얻는다.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array <code>Double</code>배열, <code>null</code>도 가능함.
     * @param valueForNull 배열요소가 null일 경우 기본 할당값
     * @return <code>double</code> 배열, null 입력시 <code>null</code> 리턴함
     */
    public static double[] toPrimitive(final Double[] array, final double valueForNull) {
        if(array == null) {
            return null;
        } else if(array.length == 0) {
            return EMPTY_DOUBLE_ARRAY;
        }
        final double[] result = new double[array.length];
        for(int i = 0 ; i < array.length ; i++) {
            Double b = array[i];
            result[i] = (b == null ? valueForNull : b.doubleValue());
        }
        return result;
    }

    /**
     * <p>
     * 원시타입 배열 doubles에 대한 오브젝트 배열을 얻는다.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array <code>double</code> array
     * @return <code>Double</code> 배열, null 입력시 <code>null</code> 리턴함
     */
    public static Double[] toObject(final double[] array) {
        if(array == null) {
            return null;
        } else if(array.length == 0) {
            return EMPTY_DOUBLE_OBJECT_ARRAY;
        }
        final Double[] result = new Double[array.length];
        for(int i = 0 ; i < array.length ; i++) {
            result[i] = new Double(array[i]);
        }
        return result;
    }

    // Float array converters
    // ----------------------------------------------------------------------
    /**
     * <p>
     * 오브젝트 배열 Floats 에 대한 원시타입 배열을 얻는다.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array <code>Float</code>배열, <code>null</code>도 가능함.
     * @return <code>float</code> 배열, null 입력시 <code>null</code> 리턴함
     * @throws NullPointerException <code>null</code> 입력값일 경우 발생.
     */
    public static float[] toPrimitive(final Float[] array) {
        if(array == null) {
            return null;
        } else if(array.length == 0) {
            return EMPTY_FLOAT_ARRAY;
        }
        final float[] result = new float[array.length];
        for(int i = 0 ; i < array.length ; i++) {
            result[i] = array[i].floatValue();
        }
        return result;
    }

    /**
     * <p>
     * 오브젝트 배열 Floats 에 대한 null을 다루는 원시타입 배열을 얻는다.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array <code>Float</code>배열, <code>null</code>도 가능함.
     * @param valueForNull 배열요소가 null일 경우 기본 할당값
     * @return <code>float</code> 배열, null 입력시 <code>null</code> 리턴함
     */
    public static float[] toPrimitive(final Float[] array, final float valueForNull) {
        if(array == null) {
            return null;
        } else if(array.length == 0) {
            return EMPTY_FLOAT_ARRAY;
        }
        final float[] result = new float[array.length];
        for(int i = 0 ; i < array.length ; i++) {
            Float b = array[i];
            result[i] = (b == null ? valueForNull : b.floatValue());
        }
        return result;
    }

    /**
     * <p>
     * 원시타입 배열 floats에 대한 오브젝트 배열을 얻는다.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array <code>float</code> array
     * @return <code>Float</code> 배열, null 입력시 <code>null</code> 리턴함
     */
    public static Float[] toObject(final float[] array) {
        if(array == null) {
            return null;
        } else if(array.length == 0) {
            return EMPTY_FLOAT_OBJECT_ARRAY;
        }
        final Float[] result = new Float[array.length];
        for(int i = 0 ; i < array.length ; i++) {
            result[i] = new Float(array[i]);
        }
        return result;
    }

    // Boolean array converters
    // ----------------------------------------------------------------------
    /**
     * <p>
     * 오브젝트 배열 Booleans 에 대한 원시타입 배열을 얻는다.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array <code>Boolean</code>배열, <code>null</code>도 가능함.
     * @return <code>boolean</code> 배열, null 입력시 <code>null</code> 리턴함
     * @throws NullPointerException <code>null</code> 입력값일 경우 발생.
     */
    public static boolean[] toPrimitive(final Boolean[] array) {
        if(array == null) {
            return null;
        } else if(array.length == 0) {
            return EMPTY_BOOLEAN_ARRAY;
        }
        final boolean[] result = new boolean[array.length];
        for(int i = 0 ; i < array.length ; i++) {
            result[i] = array[i].booleanValue();
        }
        return result;
    }

    /**
     * <p>
     * 오브젝트 배열 Booleans 에 대한 null을 다루는 원시타입 배열을 얻는다.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array <code>Boolean</code>배열, <code>null</code>도 가능함.
     * @param valueForNull 배열요소가 null일 경우 기본 할당값
     * @return <code>boolean</code> 배열, null 입력시 <code>null</code> 리턴함
     */
    public static boolean[] toPrimitive(final Boolean[] array, final boolean valueForNull) {
        if(array == null) {
            return null;
        } else if(array.length == 0) {
            return EMPTY_BOOLEAN_ARRAY;
        }
        final boolean[] result = new boolean[array.length];
        for(int i = 0 ; i < array.length ; i++) {
            Boolean b = array[i];
            result[i] = (b == null ? valueForNull : b.booleanValue());
        }
        return result;
    }

    /**
     * <p>
     * 원시타입 배열 booleans에 대한 오브젝트 배열을 얻는다.
     * </p>
     * <p>
     * <code>null</code>이 입력될 경우 <code>null</code>을 리턴한다.
     *
     * @param array <code>boolean</code> 배열
     * @return <code>Boolean</code> 배열, null 입력시 <code>null</code> 리턴함
     */
    public static Boolean[] toObject(final boolean[] array) {
        if(array == null) {
            return null;
        } else if(array.length == 0) {
            return EMPTY_BOOLEAN_OBJECT_ARRAY;
        }
        final Boolean[] result = new Boolean[array.length];
        for(int i = 0 ; i < array.length ; i++) {
            result[i] = (array[i] ? Boolean.TRUE : Boolean.FALSE);
        }
        return result;
    }

}
