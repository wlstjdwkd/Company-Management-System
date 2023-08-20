package com.infra.util;

import java.io.IOException;

//import gov.mogaha.gpin.sp.proxy.Util;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

//import antlr.Utils;
import com.infra.util.Validate;

/**
 * Jakarta commons-lang3 패키지의 StringUtils 클레스의 <code>Delegate Methods</code>
 * @see org.apache.commons.lang3.StringUtils
 */
public class StringUtil {

	private static final Logger logger = LoggerFactory.getLogger(StringUtil.class);

    /**
     * 빈 문자열 <code>""</code>.
     */
    public static final String EMPTY = "";

    /**
     * Zero 정수값 <code>0</code>.
     */
    public static final int ZERO = 0;

    /**
     * One 정수값 <code>1</code>.
     */
    public static final int ONE = 1;

    /**
     * 인덱스 관련 메소드에서 인덱스를 찾지 못하는 경우의 값
     */
    public static final int INDEX_NOT_FOUND = -1;

    /**
     * PADDING 가능 자릿수
     */
    private static final int PAD_LIMIT = 8192;

    /**
     * 값이 없는 빈 문자 배열
     */
    public static final String[] EMPTY_STRING_ARRAY = new String[0];

    // Trim
    // -----------------------------------------------------------------------
    /**
     * <p>
     * Removes control characters (char &lt;= 32) from both ends of this String,
     * handling {@code null} by returning {@code null}.
     * </p>
     * <p>
     * The String is trimmed using {@link String#trim()}. Trim removes start and
     * end characters &lt;= 32. To strip whitespace use {@link #strip(String)}.
     * </p>
     * <p>
     * To trim your choice of characters, use the {@link #strip(String, String)}
     * methods.
     * </p>
     *
     * <pre>
     * StringUtils.trim(null)          = ""
     * StringUtils.trim("")            = ""
     * StringUtils.trim("     ")       = ""
     * StringUtils.trim("abc")         = "abc"
     * StringUtils.trim("    abc    ") = "abc"
     * </pre>
     *
     * @param str the String to be trimmed, may be null
     * @return the trimmed string, {@code null} if null String input
     */
    public static String trim(String str) {
        return str == null ? "" : str.trim();
    }

    // Stripping
    // -----------------------------------------------------------------------
    /**
     * <p>
     * Strips whitespace from the start and end of a String.
     * </p>
     * <p>
     * This is similar to {@link #trim(String)} but removes whitespace.
     * Whitespace is defined by {@link Character#isWhitespace(char)}.
     * </p>
     * <p>
     * A {@code null} input String returns {@code null}.
     * </p>
     *
     * <pre>
     * StringUtils.strip(null)     = null
     * StringUtils.strip("")       = ""
     * StringUtils.strip("   ")    = ""
     * StringUtils.strip("abc")    = "abc"
     * StringUtils.strip("  abc")  = "abc"
     * StringUtils.strip("abc  ")  = "abc"
     * StringUtils.strip(" abc ")  = "abc"
     * StringUtils.strip(" ab c ") = "ab c"
     * </pre>
     *
     * @param str the String to remove whitespace from, may be null
     * @return the stripped String, {@code null} if null String input
     */
    public static String strip(String str) {
        return strip(str, null);
    }

    /**
     * <p>
     * Strips any of a set of characters from the start and end of a String.
     * This is similar to {@link String#trim()} but allows the characters to be
     * stripped to be controlled.
     * </p>
     * <p>
     * A {@code null} input String returns {@code null}. An empty string ("")
     * input returns the empty string.
     * </p>
     * <p>
     * If the stripChars String is {@code null}, whitespace is stripped as
     * defined by {@link Character#isWhitespace(char)}. Alternatively use
     * {@link #strip(String)}.
     * </p>
     *
     * <pre>
     * StringUtils.strip(null, *)          = null
     * StringUtils.strip("", *)            = ""
     * StringUtils.strip("abc", null)      = "abc"
     * StringUtils.strip("  abc", null)    = "abc"
     * StringUtils.strip("abc  ", null)    = "abc"
     * StringUtils.strip(" abc ", null)    = "abc"
     * StringUtils.strip("  abcyx", "xyz") = "  abc"
     * </pre>
     *
     * @param str the String to remove characters from, may be null
     * @param stripChars the characters to remove, null treated as whitespace
     * @return the stripped String, {@code null} if null String input
     */
    public static String strip(String str, String stripChars) {
        if(Validate.isEmpty(str)) {
            return null;
        }
        str = stripStart(str, stripChars);
        return stripEnd(str, stripChars);
    }

    /**
     * <p>
     * Strips any of a set of characters from the start of a String.
     * </p>
     * <p>
     * A {@code null} input String returns {@code null}. An empty string ("")
     * input returns the empty string.
     * </p>
     * <p>
     * If the stripChars String is {@code null}, whitespace is stripped as
     * defined by {@link Character#isWhitespace(char)}.
     * </p>
     *
     * <pre>
     * StringUtils.stripStart(null, *)          = null
     * StringUtils.stripStart("", *)            = ""
     * StringUtils.stripStart("abc", "")        = "abc"
     * StringUtils.stripStart("abc", null)      = "abc"
     * StringUtils.stripStart("  abc", null)    = "abc"
     * StringUtils.stripStart("abc  ", null)    = "abc  "
     * StringUtils.stripStart(" abc ", null)    = "abc "
     * StringUtils.stripStart("yxabc  ", "xyz") = "abc  "
     * </pre>
     *
     * @param str the String to remove characters from, may be null
     * @param stripChars the characters to remove, null treated as whitespace
     * @return the stripped String, {@code null} if null String input
     */
    public static String stripStart(String str, String stripChars) {
        int strLen;
        if(str == null || (strLen = str.length()) == 0) {
            return str;
        }
        int start = 0;
        if(stripChars == null) {
            while(start != strLen && Character.isWhitespace(str.charAt(start))) {
                start++;
            }
        } else if(stripChars.length() == 0) {
            return str;
        } else {
            while(start != strLen && stripChars.indexOf(str.charAt(start)) != INDEX_NOT_FOUND) {
                start++;
            }
        }
        return str.substring(start);
    }

    /**
     * <p>
     * Strips any of a set of characters from the end of a String.
     * </p>
     * <p>
     * A {@code null} input String returns {@code null}. An empty string ("")
     * input returns the empty string.
     * </p>
     * <p>
     * If the stripChars String is {@code null}, whitespace is stripped as
     * defined by {@link Character#isWhitespace(char)}.
     * </p>
     *
     * <pre>
     * StringUtils.stripEnd(null, *)          = null
     * StringUtils.stripEnd("", *)            = ""
     * StringUtils.stripEnd("abc", "")        = "abc"
     * StringUtils.stripEnd("abc", null)      = "abc"
     * StringUtils.stripEnd("  abc", null)    = "  abc"
     * StringUtils.stripEnd("abc  ", null)    = "abc"
     * StringUtils.stripEnd(" abc ", null)    = " abc"
     * StringUtils.stripEnd("  abcyx", "xyz") = "  abc"
     * StringUtils.stripEnd("120.00", ".0")   = "12"
     * </pre>
     *
     * @param str the String to remove characters from, may be null
     * @param stripChars the set of characters to remove, null treated as
     *        whitespace
     * @return the stripped String, {@code null} if null String input
     */
    public static String stripEnd(String str, String stripChars) {
        int end;
        if(str == null || (end = str.length()) == 0) {
            return str;
        }

        if(stripChars == null) {
            while(end != 0 && Character.isWhitespace(str.charAt(end - 1))) {
                end--;
            }
        } else if(stripChars.length() == 0) {
            return str;
        } else {
            while(end != 0 && stripChars.indexOf(str.charAt(end - 1)) != INDEX_NOT_FOUND) {
                end--;
            }
        }
        return str.substring(0, end);
    }

    // StripAll
    // -----------------------------------------------------------------------
    /**
     * <p>
     * Strips whitespace from the start and end of every String in an array.
     * Whitespace is defined by {@link Character#isWhitespace(char)}.
     * </p>
     * <p>
     * A new array is returned each time, except for length zero. A {@code null}
     * array will return {@code null}. An empty array will return itself. A
     * {@code null} array entry will be ignored.
     * </p>
     *
     * <pre>
     * StringUtils.stripAll(null)             = null
     * StringUtils.stripAll([])               = []
     * StringUtils.stripAll(["abc", "  abc"]) = ["abc", "abc"]
     * StringUtils.stripAll(["abc  ", null])  = ["abc", null]
     * </pre>
     *
     * @param strs the array to remove whitespace from, may be null
     * @return the stripped Strings, {@code null} if null array input
     */
    public static String[] stripAll(String... strs) {
        return stripAll(strs, null);
    }

    /**
     * <p>
     * Strips any of a set of characters from the start and end of every String
     * in an array.
     * </p>
     * Whitespace is defined by {@link Character#isWhitespace(char)}.</p>
     * <p>
     * A new array is returned each time, except for length zero. A {@code null}
     * array will return {@code null}. An empty array will return itself. A
     * {@code null} array entry will be ignored. A {@code null} stripChars will
     * strip whitespace as defined by {@link Character#isWhitespace(char)}.
     * </p>
     *
     * <pre>
     * StringUtils.stripAll(null, *)                = null
     * StringUtils.stripAll([], *)                  = []
     * StringUtils.stripAll(["abc", "  abc"], null) = ["abc", "abc"]
     * StringUtils.stripAll(["abc  ", null], null)  = ["abc", null]
     * StringUtils.stripAll(["abc  ", null], "yz")  = ["abc  ", null]
     * StringUtils.stripAll(["yabcz", null], "yz")  = ["abc", null]
     * </pre>
     *
     * @param strs the array to remove characters from, may be null
     * @param stripChars the characters to remove, null treated as whitespace
     * @return the stripped Strings, {@code null} if null array input
     */
    public static String[] stripAll(String[] strs, String stripChars) {
        int strsLen;
        if(strs == null || (strsLen = strs.length) == 0) {
            return strs;
        }
        String[] newArr = new String[strsLen];
        for(int i = 0 ; i < strsLen ; i++) {
            newArr[i] = strip(strs[i], stripChars);
        }
        return newArr;
    }

    // Equals
    // -----------------------------------------------------------------------
    /**
     * <p>
     * Compares two CharSequences, returning {@code true} if they are equal.
     * </p>
     * <p>
     * {@code null}s are handled without exceptions. Two {@code null} references
     * are considered to be equal. The comparison is case sensitive.
     * </p>
     *
     * <pre>
     * StringUtils.equals(null, null)   = true
     * StringUtils.equals(null, "abc")  = false
     * StringUtils.equals("abc", null)  = false
     * StringUtils.equals("abc", "abc") = true
     * StringUtils.equals("abc", "ABC") = false
     * </pre>
     *
     * @see java.lang.String#equals(Object)
     * @param cs1 the first CharSequence, may be null
     * @param cs2 the second CharSequence, may be null
     * @return {@code true} if the CharSequences are equal, case sensitive, or
     *         both {@code null}
     * @since 3.0 Changed signature from equals(String, String) to
     *        equals(CharSequence, CharSequence)
     */
    public static boolean equals(CharSequence cs1, CharSequence cs2) {
        return cs1 == null ? cs2 == null : cs1.equals(cs2);
    }

    // IndexOf
    // -----------------------------------------------------------------------

    /**
     * <p>
     * Finds the first index within a CharSequence, handling {@code null}. This
     * method uses {@link String#indexOf(String, int)} if possible.
     * </p>
     * <p>
     * A {@code null} CharSequence will return {@code -1}.
     * </p>
     *
     * <pre>
     * StringUtils.indexOf(null, *)          = -1
     * StringUtils.indexOf(*, null)          = -1
     * StringUtils.indexOf("", "")           = 0
     * StringUtils.indexOf("", *)            = -1 (except when * = "")
     * StringUtils.indexOf("aabaabaa", "a")  = 0
     * StringUtils.indexOf("aabaabaa", "b")  = 2
     * StringUtils.indexOf("aabaabaa", "ab") = 1
     * StringUtils.indexOf("aabaabaa", "")   = 0
     * </pre>
     *
     * @param source the CharSequence to check, may be null
     * @param search the CharSequence to find, may be null
     * @return the first index of the search CharSequence,
     *         -1 if no match or {@code null} string input
     * @since 2.0
     * @since 3.0 Changed signature from indexOf(String, String) to
     *        indexOf(CharSequence, CharSequence)
     */
    public static int indexOf(CharSequence source, CharSequence search) {
        if(source == null || search == null) {
            return INDEX_NOT_FOUND;
        }
        return source.toString().indexOf(search.toString(), 0);
    }

    /**
     * <p>
     * Finds the first index within a CharSequence, handling {@code null}. This
     * method uses {@link String#indexOf(String, int)} if possible.
     * </p>
     * <p>
     * A {@code null} CharSequence will return {@code -1}. A negative start
     * position is treated as zero. An empty ("") search CharSequence always
     * matches. A start position greater than the string length only matches an
     * empty search CharSequence.
     * </p>
     *
     * <pre>
     * StringUtils.indexOf(null, *, *)          = -1
     * StringUtils.indexOf(*, null, *)          = -1
     * StringUtils.indexOf("", "", 0)           = 0
     * StringUtils.indexOf("", *, 0)            = -1 (except when * = "")
     * StringUtils.indexOf("aabaabaa", "a", 0)  = 0
     * StringUtils.indexOf("aabaabaa", "b", 0)  = 2
     * StringUtils.indexOf("aabaabaa", "ab", 0) = 1
     * StringUtils.indexOf("aabaabaa", "b", 3)  = 5
     * StringUtils.indexOf("aabaabaa", "b", 9)  = -1
     * StringUtils.indexOf("aabaabaa", "b", -1) = 2
     * StringUtils.indexOf("aabaabaa", "", 2)   = 2
     * StringUtils.indexOf("abc", "", 9)        = 3
     * </pre>
     *
     * @param source the CharSequence to check, may be null
     * @param search the CharSequence to find, may be null
     * @param startPos the start position, negative treated as zero
     * @return the first index of the search CharSequence,
     *         -1 if no match or {@code null} string input
     * @since 2.0
     * @since 3.0 Changed signature from indexOf(String, String, int) to
     *        indexOf(CharSequence, CharSequence, int)
     */
    public static int indexOf(CharSequence source, CharSequence search, int startPos) {
        if(source == null || search == null) {
            return INDEX_NOT_FOUND;
        }
        return source.toString().indexOf(search.toString(), startPos);
    }

    // LastIndexOf
    // -----------------------------------------------------------------------

    /**
     * <p>
     * Finds the last index within a CharSequence, handling {@code null}. This
     * method uses {@link String#lastIndexOf(String)} if possible.
     * </p>
     * <p>
     * A {@code null} CharSequence will return {@code -1}.
     * </p>
     *
     * <pre>
     * StringUtils.lastIndexOf(null, *)          = -1
     * StringUtils.lastIndexOf(*, null)          = -1
     * StringUtils.lastIndexOf("", "")           = 0
     * StringUtils.lastIndexOf("aabaabaa", "a")  = 7
     * StringUtils.lastIndexOf("aabaabaa", "b")  = 5
     * StringUtils.lastIndexOf("aabaabaa", "ab") = 4
     * StringUtils.lastIndexOf("aabaabaa", "")   = 8
     * </pre>
     *
     * @param source the CharSequence to check, may be null
     * @param search the CharSequence to find, may be null
     * @return the last index of the search String,
     *         -1 if no match or {@code null} string input
     * @since 2.0
     * @since 3.0 Changed signature from lastIndexOf(String, String) to
     *        lastIndexOf(CharSequence, CharSequence)
     */
    public static int lastIndexOf(CharSequence source, CharSequence search) {
        if(source == null || search == null) {
            return INDEX_NOT_FOUND;
        }
        return source.toString().lastIndexOf(search.toString(), 0);
    }

    /**
     * <p>
     * Finds the first index within a CharSequence, handling {@code null}. This
     * method uses {@link String#lastIndexOf(String, int)} if possible.
     * </p>
     * <p>
     * A {@code null} CharSequence will return {@code -1}. A negative start
     * position returns {@code -1}. An empty ("") search CharSequence always
     * matches unless the start position is negative. A start position greater
     * than the string length searches the whole string.
     * </p>
     *
     * <pre>
     * StringUtils.lastIndexOf(null, *, *)          = -1
     * StringUtils.lastIndexOf(*, null, *)          = -1
     * StringUtils.lastIndexOf("aabaabaa", "a", 8)  = 7
     * StringUtils.lastIndexOf("aabaabaa", "b", 8)  = 5
     * StringUtils.lastIndexOf("aabaabaa", "ab", 8) = 4
     * StringUtils.lastIndexOf("aabaabaa", "b", 9)  = 5
     * StringUtils.lastIndexOf("aabaabaa", "b", -1) = -1
     * StringUtils.lastIndexOf("aabaabaa", "a", 0)  = 0
     * StringUtils.lastIndexOf("aabaabaa", "b", 0)  = -1
     * </pre>
     *
     * @param source the CharSequence to check, may be null
     * @param search the CharSequence to find, may be null
     * @param startPos the start position, negative treated as zero
     * @return the first index of the search CharSequence,
     *         -1 if no match or {@code null} string input
     * @since 2.0
     * @since 3.0 Changed signature from lastIndexOf(String, String, int) to
     *        lastIndexOf(CharSequence, CharSequence, int)
     */
    public static int lastIndexOf(CharSequence source, CharSequence search, int startPos) {
        if(source == null || search == null) {
            return INDEX_NOT_FOUND;
        }
        return source.toString().lastIndexOf(search.toString(), startPos);
    }

    /**
     * <p>
     * Checks if CharSequence contains a search CharSequence, handling
     * {@code null}. This method uses {@link String#indexOf(String)} if
     * possible.
     * </p>
     * <p>
     * A {@code null} CharSequence will return {@code false}.
     * </p>
     *
     * <pre>
     * StringUtils.contains(null, *)     = false
     * StringUtils.contains(*, null)     = false
     * StringUtils.contains("", "")      = true
     * StringUtils.contains("abc", "")   = true
     * StringUtils.contains("abc", "a")  = true
     * StringUtils.contains("abc", "z")  = false
     * </pre>
     *
     * @param source the CharSequence to check, may be null
     * @param search the CharSequence to find, may be null
     * @return true if the CharSequence contains the search CharSequence,
     *         false if not or {@code null} string input
     * @since 2.0
     * @since 3.0 Changed signature from contains(String, String) to
     *        contains(CharSequence, CharSequence)
     */
    public static boolean contains(CharSequence source, CharSequence search) {
        if(source == null || search == null) {
            return false;
        }

        return (indexOf(source, search) >= 0);
    }

    // Substring
    // -----------------------------------------------------------------------
    /**
     * <p>
     * Gets a substring from the specified String avoiding exceptions.
     * </p>
     * <p>
     * A negative start position can be used to start {@code n} characters from
     * the end of the String.
     * </p>
     * <p>
     * A {@code null} String will return {@code null}. An empty ("") String will
     * return "".
     * </p>
     *
     * <pre>
     * StringUtils.substring(null, *)   = null
     * StringUtils.substring("", *)     = ""
     * StringUtils.substring("abc", 0)  = "abc"
     * StringUtils.substring("abc", 2)  = "c"
     * StringUtils.substring("abc", 4)  = ""
     * StringUtils.substring("abc", -2) = "bc"
     * StringUtils.substring("abc", -4) = "abc"
     * </pre>
     *
     * @param str the String to get the substring from, may be null
     * @param start the position to start from, negative means
     *        count back from the end of the String by this many characters
     * @return substring from start position, {@code null} if null String input
     */
    public static String substring(String str, int start) {
        if(str == null) {
            return null;
        }

        // handle negatives, which means last n characters
        if(start < 0) {
            start = str.length() + start; // remember start is negative
        }

        if(start < 0) {
            start = 0;
        }
        if(start > str.length()) {
            return EMPTY;
        }

        return str.substring(start);
    }

    /**
     * <p>
     * Gets a substring from the specified String avoiding exceptions.
     * </p>
     * <p>
     * A negative start position can be used to start/end {@code n} characters
     * from the end of the String.
     * </p>
     * <p>
     * The returned substring starts with the character in the {@code start}
     * position and ends before the {@code end} position. All position counting
     * is zero-based -- i.e., to start at the beginning of the string use
     * {@code start = 0}. Negative start and end positions can be used to
     * specify offsets relative to the end of the String.
     * </p>
     * <p>
     * If {@code start} is not strictly to the left of {@code end}, "" is
     * returned.
     * </p>
     *
     * <pre>
     * StringUtils.substring(null, *, *)    = null
     * StringUtils.substring("", * ,  *)    = "";
     * StringUtils.substring("abc", 0, 2)   = "ab"
     * StringUtils.substring("abc", 2, 0)   = ""
     * StringUtils.substring("abc", 2, 4)   = "c"
     * StringUtils.substring("abc", 4, 6)   = ""
     * StringUtils.substring("abc", 2, 2)   = ""
     * StringUtils.substring("abc", -2, -1) = "b"
     * StringUtils.substring("abc", -4, 2)  = "ab"
     * </pre>
     *
     * @param str the String to get the substring from, may be null
     * @param start the position to start from, negative means
     *        count back from the end of the String by this many characters
     * @param end the position to end at (exclusive), negative means
     *        count back from the end of the String by this many characters
     * @return substring from start position to end position, {@code null} if
     *         null String input
     */
    public static String substring(String str, int start, int end) {
        if(str == null) {
            return null;
        }

        // handle negatives
        if(end < 0) {
            end = str.length() + end; // remember end is negative
        }
        if(start < 0) {
            start = str.length() + start; // remember start is negative
        }

        // check length next
        if(end > str.length()) {
            end = str.length();
        }

        // if start is greater than end, return ""
        if(start > end) {
            return EMPTY;
        }

        if(start < 0) {
            start = 0;
        }
        if(end < 0) {
            end = 0;
        }

        return str.substring(start, end);
    }

    // Left/Right/Mid
    // -----------------------------------------------------------------------
    /**
     * <p>
     * Gets the leftmost {@code len} characters of a String.
     * </p>
     * <p>
     * If {@code len} characters are not available, or the String is
     * {@code null}, the String will be returned without an exception. An empty
     * String is returned if len is negative.
     * </p>
     *
     * <pre>
     * StringUtils.left(null, *)    = null
     * StringUtils.left(*, -ve)     = ""
     * StringUtils.left("", *)      = ""
     * StringUtils.left("abc", 0)   = ""
     * StringUtils.left("abc", 2)   = "ab"
     * StringUtils.left("abc", 4)   = "abc"
     * </pre>
     *
     * @param str the String to get the leftmost characters from, may be null
     * @param len the length of the required String
     * @return the leftmost characters, {@code null} if null String input
     */
    public static String left(String str, int len) {
        if(str == null) {
            return null;
        }
        if(len < 0) {
            return EMPTY;
        }
        if(str.length() <= len) {
            return str;
        }
        return str.substring(0, len);
    }

    /**
     * <p>
     * Gets the rightmost {@code len} characters of a String.
     * </p>
     * <p>
     * If {@code len} characters are not available, or the String is
     * {@code null}, the String will be returned without an an exception. An
     * empty String is returned if len is negative.
     * </p>
     *
     * <pre>
     * StringUtils.right(null, *)    = null
     * StringUtils.right(*, -ve)     = ""
     * StringUtils.right("", *)      = ""
     * StringUtils.right("abc", 0)   = ""
     * StringUtils.right("abc", 2)   = "bc"
     * StringUtils.right("abc", 4)   = "abc"
     * </pre>
     *
     * @param str the String to get the rightmost characters from, may be null
     * @param len the length of the required String
     * @return the rightmost characters, {@code null} if null String input
     */
    public static String right(String str, int len) {
        if(str == null) {
            return null;
        }
        if(len < 0) {
            return EMPTY;
        }
        if(str.length() <= len) {
            return str;
        }
        return str.substring(str.length() - len);
    }

    /**
     * <p>
     * Gets {@code len} characters from the middle of a String.
     * </p>
     * <p>
     * If {@code len} characters are not available, the remainder of the String
     * will be returned without an exception. If the String is {@code null},
     * {@code null} will be returned. An empty String is returned if len is
     * negative or exceeds the length of {@code str}.
     * </p>
     *
     * <pre>
     * StringUtils.mid(null, *, *)    = null
     * StringUtils.mid(*, *, -ve)     = ""
     * StringUtils.mid("", 0, *)      = ""
     * StringUtils.mid("abc", 0, 2)   = "ab"
     * StringUtils.mid("abc", 0, 4)   = "abc"
     * StringUtils.mid("abc", 2, 4)   = "c"
     * StringUtils.mid("abc", 4, 2)   = ""
     * StringUtils.mid("abc", -2, 2)  = "ab"
     * </pre>
     *
     * @param str the String to get the characters from, may be null
     * @param pos the position to start from, negative treated as zero
     * @param len the length of the required String
     * @return the middle characters, {@code null} if null String input
     */
    public static String mid(String str, int pos, int len) {
        if(str == null) {
            return null;
        }
        if(len < 0 || pos > str.length()) {
            return EMPTY;
        }
        if(pos < 0) {
            pos = 0;
        }
        if(str.length() <= pos + len) {
            return str.substring(pos);
        }
        return str.substring(pos, pos + len);
    }

    // SubStringAfter/SubStringBefore
    // -----------------------------------------------------------------------
    /**
     * <p>
     * Gets the substring before the first occurrence of a separator. The
     * separator is not returned.
     * </p>
     * <p>
     * A {@code null} string input will return {@code null}. An empty ("")
     * string input will return the empty string. A {@code null} separator will
     * return the input string.
     * </p>
     * <p>
     * If nothing is found, the string input is returned.
     * </p>
     *
     * <pre>
     * StringUtils.substringBefore(null, *)      = null
     * StringUtils.substringBefore("", *)        = ""
     * StringUtils.substringBefore("abc", "a")   = ""
     * StringUtils.substringBefore("abcba", "b") = "a"
     * StringUtils.substringBefore("abc", "c")   = "ab"
     * StringUtils.substringBefore("abc", "d")   = "abc"
     * StringUtils.substringBefore("abc", "")    = ""
     * StringUtils.substringBefore("abc", null)  = "abc"
     * </pre>
     *
     * @param str the String to get a substring from, may be null
     * @param separator the String to search for, may be null
     * @return the substring before the first occurrence of the separator,
     *         {@code null} if null String input
     * @since 2.0
     */
    public static String substringBefore(String str, String separator) {
        if(Validate.isEmpty(str) || separator == null) {
            return str;
        }
        if(separator.length() == 0) {
            return EMPTY;
        }
        int pos = str.indexOf(separator);
        if(pos == INDEX_NOT_FOUND) {
            return str;
        }
        return str.substring(0, pos);
    }

    /**
     * <p>
     * Gets the substring after the first occurrence of a separator. The
     * separator is not returned.
     * </p>
     * <p>
     * A {@code null} string input will return {@code null}. An empty ("")
     * string input will return the empty string. A {@code null} separator will
     * return the empty string if the input string is not {@code null}.
     * </p>
     * <p>
     * If nothing is found, the empty string is returned.
     * </p>
     *
     * <pre>
     * StringUtils.substringAfter(null, *)      = null
     * StringUtils.substringAfter("", *)        = ""
     * StringUtils.substringAfter(*, null)      = ""
     * StringUtils.substringAfter("abc", "a")   = "bc"
     * StringUtils.substringAfter("abcba", "b") = "cba"
     * StringUtils.substringAfter("abc", "c")   = ""
     * StringUtils.substringAfter("abc", "d")   = ""
     * StringUtils.substringAfter("abc", "")    = "abc"
     * </pre>
     *
     * @param str the String to get a substring from, may be null
     * @param separator the String to search for, may be null
     * @return the substring after the first occurrence of the separator,
     *         {@code null} if null String input
     * @since 2.0
     */
    public static String substringAfter(String str, String separator) {
        if(Validate.isEmpty(str)) {
            return str;
        }
        if(separator == null) {
            return EMPTY;
        }
        int pos = str.indexOf(separator);
        if(pos == INDEX_NOT_FOUND) {
            return EMPTY;
        }
        return str.substring(pos + separator.length());
    }

    /**
     * <p>
     * Gets the substring before the last occurrence of a separator. The
     * separator is not returned.
     * </p>
     * <p>
     * A {@code null} string input will return {@code null}. An empty ("")
     * string input will return the empty string. An empty or {@code null}
     * separator will return the input string.
     * </p>
     * <p>
     * If nothing is found, the string input is returned.
     * </p>
     *
     * <pre>
     * StringUtils.substringBeforeLast(null, *)      = null
     * StringUtils.substringBeforeLast("", *)        = ""
     * StringUtils.substringBeforeLast("abcba", "b") = "abc"
     * StringUtils.substringBeforeLast("abc", "c")   = "ab"
     * StringUtils.substringBeforeLast("a", "a")     = ""
     * StringUtils.substringBeforeLast("a", "z")     = "a"
     * StringUtils.substringBeforeLast("a", null)    = "a"
     * StringUtils.substringBeforeLast("a", "")      = "a"
     * </pre>
     *
     * @param str the String to get a substring from, may be null
     * @param separator the String to search for, may be null
     * @return the substring before the last occurrence of the separator,
     *         {@code null} if null String input
     * @since 2.0
     */
    public static String substringBeforeLast(String str, String separator) {
        if(Validate.isEmpty(str) || Validate.isEmpty(separator)) {
            return str;
        }
        int pos = str.lastIndexOf(separator);
        if(pos == INDEX_NOT_FOUND) {
            return str;
        }
        return str.substring(0, pos);
    }

    // Nested extraction
    // -----------------------------------------------------------------------

    // Splitting
    // -----------------------------------------------------------------------
    /**
     * <p>
     * Splits the provided text into an array, using whitespace as the
     * separator. Whitespace is defined by {@link Character#isWhitespace(char)}.
     * </p>
     * <p>
     * The separator is not included in the returned String array. Adjacent
     * separators are treated as one separator. For more control over the split
     * use the StrTokenizer class.
     * </p>
     * <p>
     * A {@code null} input String returns {@code null}.
     * </p>
     *
     * <pre>
     * StringUtils.split(null)       = null
     * StringUtils.split("")         = []
     * StringUtils.split("abc def")  = ["abc", "def"]
     * StringUtils.split("abc  def") = ["abc", "def"]
     * StringUtils.split(" abc ")    = ["abc"]
     * </pre>
     *
     * @param str the String to parse, may be null
     * @return an array of parsed Strings, {@code null} if null String input
     */
    public static String[] split(String str) {
        return split(str, null, -1);
    }

    /**
     * <p>
     * Splits the provided text into an array, separator specified. This is an
     * alternative to using StringTokenizer.
     * </p>
     * <p>
     * The separator is not included in the returned String array. Adjacent
     * separators are treated as one separator. For more control over the split
     * use the StrTokenizer class.
     * </p>
     * <p>
     * A {@code null} input String returns {@code null}.
     * </p>
     *
     * <pre>
     * StringUtils.split(null, *)         = null
     * StringUtils.split("", *)           = []
     * StringUtils.split("a.b.c", '.')    = ["a", "b", "c"]
     * StringUtils.split("a..b.c", '.')   = ["a", "b", "c"]
     * StringUtils.split("a:b:c", '.')    = ["a:b:c"]
     * StringUtils.split("a b c", ' ')    = ["a", "b", "c"]
     * </pre>
     *
     * @param str the String to parse, may be null
     * @param separatorChar the character used as the delimiter
     * @return an array of parsed Strings, {@code null} if null String input
     * @since 2.0
     */
    public static String[] split(String str, char separatorChar) {
        return splitWorker(str, separatorChar, false);
    }

    /**
     * <p>
     * Splits the provided text into an array, separators specified. This is an
     * alternative to using StringTokenizer.
     * </p>
     * <p>
     * The separator is not included in the returned String array. Adjacent
     * separators are treated as one separator. For more control over the split
     * use the StrTokenizer class.
     * </p>
     * <p>
     * A {@code null} input String returns {@code null}. A {@code null}
     * separatorChars splits on whitespace.
     * </p>
     *
     * <pre>
     * StringUtils.split(null, *)         = null
     * StringUtils.split("", *)           = []
     * StringUtils.split("abc def", null) = ["abc", "def"]
     * StringUtils.split("abc def", " ")  = ["abc", "def"]
     * StringUtils.split("abc  def", " ") = ["abc", "def"]
     * StringUtils.split("ab:cd:ef", ":") = ["ab", "cd", "ef"]
     * </pre>
     *
     * @param str the String to parse, may be null
     * @param separatorChars the characters used as the delimiters, {@code null}
     *        splits on whitespace
     * @return an array of parsed Strings, {@code null} if null String input
     */
    public static String[] split(String str, String separatorChars) {
        return splitWorker(str, separatorChars, -1, false);
    }

    /**
     * <p>
     * Splits the provided text into an array with a maximum length, separators
     * specified.
     * </p>
     * <p>
     * The separator is not included in the returned String array. Adjacent
     * separators are treated as one separator.
     * </p>
     * <p>
     * A {@code null} input String returns {@code null}. A {@code null}
     * separatorChars splits on whitespace.
     * </p>
     * <p>
     * If more than {@code max} delimited substrings are found, the last
     * returned string includes all characters after the first {@code max - 1}
     * returned strings (including separator characters).
     * </p>
     *
     * <pre>
     * StringUtils.split(null, *, *)            = null
     * StringUtils.split("", *, *)              = []
     * StringUtils.split("ab de fg", null, 0)   = ["ab", "cd", "ef"]
     * StringUtils.split("ab   de fg", null, 0) = ["ab", "cd", "ef"]
     * StringUtils.split("ab:cd:ef", ":", 0)    = ["ab", "cd", "ef"]
     * StringUtils.split("ab:cd:ef", ":", 2)    = ["ab", "cd:ef"]
     * </pre>
     *
     * @param str the String to parse, may be null
     * @param separatorChars the characters used as the delimiters, {@code null}
     *        splits on whitespace
     * @param max the maximum number of elements to include in the
     *        array. A zero or negative value implies no limit
     * @return an array of parsed Strings, {@code null} if null String input
     */
    public static String[] split(String str, String separatorChars, int max) {
        return splitWorker(str, separatorChars, max, false);
    }

    // -----------------------------------------------------------------------
    /**
     * <p>
     * Splits the provided text into an array, using whitespace as the
     * separator, preserving all tokens, including empty tokens created by
     * adjacent separators. This is an alternative to using StringTokenizer.
     * Whitespace is defined by {@link Character#isWhitespace(char)}.
     * </p>
     * <p>
     * The separator is not included in the returned String array. Adjacent
     * separators are treated as separators for empty tokens. For more control
     * over the split use the StrTokenizer class.
     * </p>
     * <p>
     * A {@code null} input String returns {@code null}.
     * </p>
     *
     * <pre>
     * StringUtils.splitPreserveAllTokens(null)       = null
     * StringUtils.splitPreserveAllTokens("")         = []
     * StringUtils.splitPreserveAllTokens("abc def")  = ["abc", "def"]
     * StringUtils.splitPreserveAllTokens("abc  def") = ["abc", "", "def"]
     * StringUtils.splitPreserveAllTokens(" abc ")    = ["", "abc", ""]
     * </pre>
     *
     * @param str the String to parse, may be {@code null}
     * @return an array of parsed Strings, {@code null} if null String input
     * @since 2.1
     */
    public static String[] splitPreserveAllTokens(String str) {
        return splitWorker(str, null, -1, true);
    }

    /**
     * <p>
     * Splits the provided text into an array, separator specified, preserving
     * all tokens, including empty tokens created by adjacent separators. This
     * is an alternative to using StringTokenizer.
     * </p>
     * <p>
     * The separator is not included in the returned String array. Adjacent
     * separators are treated as separators for empty tokens. For more control
     * over the split use the StrTokenizer class.
     * </p>
     * <p>
     * A {@code null} input String returns {@code null}.
     * </p>
     *
     * <pre>
     * StringUtils.splitPreserveAllTokens(null, *)         = null
     * StringUtils.splitPreserveAllTokens("", *)           = []
     * StringUtils.splitPreserveAllTokens("a.b.c", '.')    = ["a", "b", "c"]
     * StringUtils.splitPreserveAllTokens("a..b.c", '.')   = ["a", "", "b", "c"]
     * StringUtils.splitPreserveAllTokens("a:b:c", '.')    = ["a:b:c"]
     * StringUtils.splitPreserveAllTokens("a\tb\nc", null) = ["a", "b", "c"]
     * StringUtils.splitPreserveAllTokens("a b c", ' ')    = ["a", "b", "c"]
     * StringUtils.splitPreserveAllTokens("a b c ", ' ')   = ["a", "b", "c", ""]
     * StringUtils.splitPreserveAllTokens("a b c  ", ' ')   = ["a", "b", "c", "", ""]
     * StringUtils.splitPreserveAllTokens(" a b c", ' ')   = ["", a", "b", "c"]
     * StringUtils.splitPreserveAllTokens("  a b c", ' ')  = ["", "", a", "b", "c"]
     * StringUtils.splitPreserveAllTokens(" a b c ", ' ')  = ["", a", "b", "c", ""]
     * </pre>
     *
     * @param str the String to parse, may be {@code null}
     * @param separatorChar the character used as the delimiter, {@code null}
     *        splits on whitespace
     * @return an array of parsed Strings, {@code null} if null String input
     * @since 2.1
     */
    public static String[] splitPreserveAllTokens(String str, char separatorChar) {
        return splitWorker(str, separatorChar, true);
    }

    /**
     * Performs the logic for the {@code split} and
     * {@code splitPreserveAllTokens} methods that do not return a
     * maximum array length.
     *
     * @param str the String to parse, may be {@code null}
     * @param separatorChar the separate character
     * @param preserveAllTokens if {@code true}, adjacent separators are
     *        treated as empty token separators; if {@code false}, adjacent
     *        separators are treated as one separator.
     * @return an array of parsed Strings, {@code null} if null String input
     */
    private static String[] splitWorker(String str, char separatorChar, boolean preserveAllTokens) {
        // Performance tuned for 2.0 (JDK1.4)

        if(str == null) {
            return null;
        }
        int len = str.length();
        if(len == 0) {
            return EMPTY_STRING_ARRAY;
        }
        List<String> list = new ArrayList<String>();
        int i = 0, start = 0;
        boolean match = false;
        boolean lastMatch = false;
        while(i < len) {
            if(str.charAt(i) == separatorChar) {
                if(match || preserveAllTokens) {
                    list.add(str.substring(start, i));
                    match = false;
                    lastMatch = true;
                }
                start = ++i;
                continue;
            }
            lastMatch = false;
            match = true;
            i++;
        }
        if(match || preserveAllTokens && lastMatch) {
            list.add(str.substring(start, i));
        }
        return list.toArray(new String[list.size()]);
    }

    /**
     * <p>
     * Splits the provided text into an array, separators specified, preserving
     * all tokens, including empty tokens created by adjacent separators. This
     * is an alternative to using StringTokenizer.
     * </p>
     * <p>
     * The separator is not included in the returned String array. Adjacent
     * separators are treated as separators for empty tokens. For more control
     * over the split use the StrTokenizer class.
     * </p>
     * <p>
     * A {@code null} input String returns {@code null}. A {@code null}
     * separatorChars splits on whitespace.
     * </p>
     *
     * <pre>
     * StringUtils.splitPreserveAllTokens(null, *)           = null
     * StringUtils.splitPreserveAllTokens("", *)             = []
     * StringUtils.splitPreserveAllTokens("abc def", null)   = ["abc", "def"]
     * StringUtils.splitPreserveAllTokens("abc def", " ")    = ["abc", "def"]
     * StringUtils.splitPreserveAllTokens("abc  def", " ")   = ["abc", "", def"]
     * StringUtils.splitPreserveAllTokens("ab:cd:ef", ":")   = ["ab", "cd", "ef"]
     * StringUtils.splitPreserveAllTokens("ab:cd:ef:", ":")  = ["ab", "cd", "ef", ""]
     * StringUtils.splitPreserveAllTokens("ab:cd:ef::", ":") = ["ab", "cd", "ef", "", ""]
     * StringUtils.splitPreserveAllTokens("ab::cd:ef", ":")  = ["ab", "", cd", "ef"]
     * StringUtils.splitPreserveAllTokens(":cd:ef", ":")     = ["", cd", "ef"]
     * StringUtils.splitPreserveAllTokens("::cd:ef", ":")    = ["", "", cd", "ef"]
     * StringUtils.splitPreserveAllTokens(":cd:ef:", ":")    = ["", cd", "ef", ""]
     * </pre>
     *
     * @param str the String to parse, may be {@code null}
     * @param separatorChars the characters used as the delimiters, {@code null}
     *        splits on whitespace
     * @return an array of parsed Strings, {@code null} if null String input
     * @since 2.1
     */
    public static String[] splitPreserveAllTokens(String str, String separatorChars) {
        return splitWorker(str, separatorChars, -1, true);
    }

    /**
     * <p>
     * Splits the provided text into an array with a maximum length, separators
     * specified, preserving all tokens, including empty tokens created by
     * adjacent separators.
     * </p>
     * <p>
     * The separator is not included in the returned String array. Adjacent
     * separators are treated as separators for empty tokens. Adjacent
     * separators are treated as one separator.
     * </p>
     * <p>
     * A {@code null} input String returns {@code null}. A {@code null}
     * separatorChars splits on whitespace.
     * </p>
     * <p>
     * If more than {@code max} delimited substrings are found, the last
     * returned string includes all characters after the first {@code max - 1}
     * returned strings (including separator characters).
     * </p>
     *
     * <pre>
     * StringUtils.splitPreserveAllTokens(null, *, *)            = null
     * StringUtils.splitPreserveAllTokens("", *, *)              = []
     * StringUtils.splitPreserveAllTokens("ab de fg", null, 0)   = ["ab", "cd", "ef"]
     * StringUtils.splitPreserveAllTokens("ab   de fg", null, 0) = ["ab", "cd", "ef"]
     * StringUtils.splitPreserveAllTokens("ab:cd:ef", ":", 0)    = ["ab", "cd", "ef"]
     * StringUtils.splitPreserveAllTokens("ab:cd:ef", ":", 2)    = ["ab", "cd:ef"]
     * StringUtils.splitPreserveAllTokens("ab   de fg", null, 2) = ["ab", "  de fg"]
     * StringUtils.splitPreserveAllTokens("ab   de fg", null, 3) = ["ab", "", " de fg"]
     * StringUtils.splitPreserveAllTokens("ab   de fg", null, 4) = ["ab", "", "", "de fg"]
     * </pre>
     *
     * @param str the String to parse, may be {@code null}
     * @param separatorChars the characters used as the delimiters, {@code null}
     *        splits on whitespace
     * @param max the maximum number of elements to include in the
     *        array. A zero or negative value implies no limit
     * @return an array of parsed Strings, {@code null} if null String input
     * @since 2.1
     */
    public static String[] splitPreserveAllTokens(String str, String separatorChars, int max) {
        return splitWorker(str, separatorChars, max, true);
    }

    /**
     * Performs the logic for the {@code split} and
     * {@code splitPreserveAllTokens} methods that return a maximum array
     * length.
     *
     * @param str the String to parse, may be {@code null}
     * @param separatorChars the separate character
     * @param max the maximum number of elements to include in the
     *        array. A zero or negative value implies no limit.
     * @param preserveAllTokens if {@code true}, adjacent separators are
     *        treated as empty token separators; if {@code false}, adjacent
     *        separators are treated as one separator.
     * @return an array of parsed Strings, {@code null} if null String input
     */
    private static String[] splitWorker(String str, String separatorChars, int max, boolean preserveAllTokens) {
        // Performance tuned for 2.0 (JDK1.4)
        // Direct code is quicker than StringTokenizer.
        // Also, StringTokenizer uses isSpace() not isWhitespace()

        if(str == null) {
            return null;
        }
        int len = str.length();
        if(len == 0) {
            return EMPTY_STRING_ARRAY;
        }
        List<String> list = new ArrayList<String>();
        int sizePlus1 = 1;
        int i = 0, start = 0;
        boolean match = false;
        boolean lastMatch = false;
        if(separatorChars == null) {
            // Null separator means use whitespace
            while(i < len) {
                if(Character.isWhitespace(str.charAt(i))) {
                    if(match || preserveAllTokens) {
                        lastMatch = true;
                        if(sizePlus1++ == max) {
                            i = len;
                            lastMatch = false;
                        }
                        list.add(str.substring(start, i));
                        match = false;
                    }
                    start = ++i;
                    continue;
                }
                lastMatch = false;
                match = true;
                i++;
            }
        } else if(separatorChars.length() == 1) {
            // Optimise 1 character case
            char sep = separatorChars.charAt(0);
            while(i < len) {
                if(str.charAt(i) == sep) {
                    if(match || preserveAllTokens) {
                        lastMatch = true;
                        if(sizePlus1++ == max) {
                            i = len;
                            lastMatch = false;
                        }
                        list.add(str.substring(start, i));
                        match = false;
                    }
                    start = ++i;
                    continue;
                }
                lastMatch = false;
                match = true;
                i++;
            }
        } else {
            // standard case
            while(i < len) {
                if(separatorChars.indexOf(str.charAt(i)) >= 0) {
                    if(match || preserveAllTokens) {
                        lastMatch = true;
                        if(sizePlus1++ == max) {
                            i = len;
                            lastMatch = false;
                        }
                        list.add(str.substring(start, i));
                        match = false;
                    }
                    start = ++i;
                    continue;
                }
                lastMatch = false;
                match = true;
                i++;
            }
        }
        if(match || preserveAllTokens && lastMatch) {
            list.add(str.substring(start, i));
        }
        return list.toArray(new String[list.size()]);
    }

    /**
     * <p>
     * Splits a String by Character type as returned by
     * {@code java.lang.Character.getType(char)}. Groups of contiguous
     * characters of the same type are returned as complete tokens.
     *
     * <pre>
     * StringUtils.splitByCharacterType(null)         = null
     * StringUtils.splitByCharacterType("")           = []
     * StringUtils.splitByCharacterType("ab de fg")   = ["ab", " ", "de", " ", "fg"]
     * StringUtils.splitByCharacterType("ab   de fg") = ["ab", "   ", "de", " ", "fg"]
     * StringUtils.splitByCharacterType("ab:cd:ef")   = ["ab", ":", "cd", ":", "ef"]
     * StringUtils.splitByCharacterType("number5")    = ["number", "5"]
     * StringUtils.splitByCharacterType("fooBar")     = ["foo", "B", "ar"]
     * StringUtils.splitByCharacterType("foo200Bar")  = ["foo", "200", "B", "ar"]
     * StringUtils.splitByCharacterType("ASFRules")   = ["ASFR", "ules"]
     * </pre>
     *
     * @param str the String to split, may be {@code null}
     * @return an array of parsed Strings, {@code null} if null String input
     * @since 2.4
     */
    public static String[] splitByCharacterType(String str) {
        return splitByCharacterType(str, false);
    }

    /**
     * <p>
     * Splits a String by Character type as returned by
     * {@code java.lang.Character.getType(char)}. Groups of contiguous
     * characters of the same type are returned as complete tokens, with the
     * following exception: the character of type
     * {@code Character.UPPERCASE_LETTER}, if any, immediately preceding a token
     * of type {@code Character.LOWERCASE_LETTER} will belong to the following
     * token rather than to the preceding, if any,
     * {@code Character.UPPERCASE_LETTER} token.
     *
     * <pre>
     * StringUtils.splitByCharacterTypeCamelCase(null)         = null
     * StringUtils.splitByCharacterTypeCamelCase("")           = []
     * StringUtils.splitByCharacterTypeCamelCase("ab de fg")   = ["ab", " ", "de", " ", "fg"]
     * StringUtils.splitByCharacterTypeCamelCase("ab   de fg") = ["ab", "   ", "de", " ", "fg"]
     * StringUtils.splitByCharacterTypeCamelCase("ab:cd:ef")   = ["ab", ":", "cd", ":", "ef"]
     * StringUtils.splitByCharacterTypeCamelCase("number5")    = ["number", "5"]
     * StringUtils.splitByCharacterTypeCamelCase("fooBar")     = ["foo", "Bar"]
     * StringUtils.splitByCharacterTypeCamelCase("foo200Bar")  = ["foo", "200", "Bar"]
     * StringUtils.splitByCharacterTypeCamelCase("ASFRules")   = ["ASF", "Rules"]
     * </pre>
     *
     * @param str the String to split, may be {@code null}
     * @return an array of parsed Strings, {@code null} if null String input
     * @since 2.4
     */
    public static String[] splitByCharacterTypeCamelCase(String str) {
        return splitByCharacterType(str, true);
    }

    /**
     * <p>
     * Splits a String by Character type as returned by
     * {@code java.lang.Character.getType(char)}. Groups of contiguous
     * characters of the same type are returned as complete tokens, with the
     * following exception: if {@code camelCase} is {@code true}, the character
     * of type {@code Character.UPPERCASE_LETTER}, if any, immediately preceding
     * a token of type {@code Character.LOWERCASE_LETTER} will belong to the
     * following token rather than to the preceding, if any,
     * {@code Character.UPPERCASE_LETTER} token.
     *
     * @param str the String to split, may be {@code null}
     * @param camelCase whether to use so-called "camel-case" for letter types
     * @return an array of parsed Strings, {@code null} if null String input
     * @since 2.4
     */
    private static String[] splitByCharacterType(String str, boolean camelCase) {
        if(str == null) {
            return null;
        }
        if(str.length() == 0) {
            return EMPTY_STRING_ARRAY;
        }
        char[] c = str.toCharArray();
        List<String> list = new ArrayList<String>();
        int tokenStart = 0;
        int currentType = Character.getType(c[tokenStart]);
        for(int pos = tokenStart + 1 ; pos < c.length ; pos++) {
            int type = Character.getType(c[pos]);
            if(type == currentType) {
                continue;
            }
            if(camelCase && type == Character.LOWERCASE_LETTER && currentType == Character.UPPERCASE_LETTER) {
                int newTokenStart = pos - 1;
                if(newTokenStart != tokenStart) {
                    list.add(new String(c, tokenStart, newTokenStart - tokenStart));
                    tokenStart = newTokenStart;
                }
            } else {
                list.add(new String(c, tokenStart, pos - tokenStart));
                tokenStart = pos;
            }
            currentType = type;
        }
        list.add(new String(c, tokenStart, c.length - tokenStart));
        return list.toArray(new String[list.size()]);
    }

    // Joining
    // -----------------------------------------------------------------------
    /**
     * <p>
     * Joins the elements of the provided array into a single String containing
     * the provided list of elements.
     * </p>
     * <p>
     * No separator is added to the joined String. Null objects or empty strings
     * within the array are represented by empty strings.
     * </p>
     *
     * <pre>
     * StringUtils.join(null)            = null
     * StringUtils.join([])              = ""
     * StringUtils.join([null])          = ""
     * StringUtils.join(["a", "b", "c"]) = "abc"
     * StringUtils.join([null, "", "a"]) = "a"
     * </pre>
     *
     * @param <T> the specific type of values to join together
     * @param elements the values to join together, may be null
     * @return the joined String, {@code null} if null array input
     * @since 2.0
     * @since 3.0 Changed signature to use varargs
     */
    public static <T> String join(T... elements) {
        return join(elements, null);
    }

    /**
     * <p>
     * Joins the elements of the provided array into a single String containing
     * the provided list of elements.
     * </p>
     * <p>
     * No delimiter is added before or after the list. Null objects or empty
     * strings within the array are represented by empty strings.
     * </p>
     *
     * <pre>
     * StringUtils.join(null, *)               = null
     * StringUtils.join([], *)                 = ""
     * StringUtils.join([null], *)             = ""
     * StringUtils.join(["a", "b", "c"], ';')  = "a;b;c"
     * StringUtils.join(["a", "b", "c"], null) = "abc"
     * StringUtils.join([null, "", "a"], ';')  = ";;a"
     * </pre>
     *
     * @param array the array of values to join together, may be null
     * @param separator the separator character to use
     * @return the joined String, {@code null} if null array input
     * @since 2.0
     */
    public static String join(Object[] array, char separator) {
        if(array == null) {
            return null;
        }

        return join(array, separator, 0, array.length);
    }

    /**
     * <p>
     * Joins the elements of the provided array into a single String containing
     * the provided list of elements.
     * </p>
     * <p>
     * No delimiter is added before or after the list. Null objects or empty
     * strings within the array are represented by empty strings.
     * </p>
     *
     * <pre>
     * StringUtils.join(null, *)               = null
     * StringUtils.join([], *)                 = ""
     * StringUtils.join([null], *)             = ""
     * StringUtils.join(["a", "b", "c"], ';')  = "a;b;c"
     * StringUtils.join(["a", "b", "c"], null) = "abc"
     * StringUtils.join([null, "", "a"], ';')  = ";;a"
     * </pre>
     *
     * @param array the array of values to join together, may be null
     * @param separator the separator character to use
     * @param startIndex the first index to start joining from. It is
     *        an error to pass in an end index past the end of the array
     * @param endIndex the index to stop joining from (exclusive). It is
     *        an error to pass in an end index past the end of the array
     * @return the joined String, {@code null} if null array input
     * @since 2.0
     */
    public static String join(Object[] array, char separator, int startIndex, int endIndex) {
        if(array == null) {
            return null;
        }
        int noOfItems = endIndex - startIndex;
        if(noOfItems <= 0) {
            return EMPTY;
        }

        StringBuilder buf = new StringBuilder(noOfItems * 16);

        for(int i = startIndex ; i < endIndex ; i++) {
            if(i > startIndex) {
                buf.append(separator);
            }
            if(array[i] != null) {
                buf.append(array[i]);
            }
        }
        return buf.toString();
    }

    /**
     * <p>
     * Joins the elements of the provided array into a single String containing
     * the provided list of elements.
     * </p>
     * <p>
     * No delimiter is added before or after the list. A {@code null} separator
     * is the same as an empty String (""). Null objects or empty strings within
     * the array are represented by empty strings.
     * </p>
     *
     * <pre>
     * StringUtils.join(null, *)                = null
     * StringUtils.join([], *)                  = ""
     * StringUtils.join([null], *)              = ""
     * StringUtils.join(["a", "b", "c"], "--")  = "a--b--c"
     * StringUtils.join(["a", "b", "c"], null)  = "abc"
     * StringUtils.join(["a", "b", "c"], "")    = "abc"
     * StringUtils.join([null, "", "a"], ',')   = ",,a"
     * </pre>
     *
     * @param array the array of values to join together, may be null
     * @param separator the separator character to use, null treated as ""
     * @return the joined String, {@code null} if null array input
     */
    public static String join(Object[] array, String separator) {
        if(array == null) {
            return null;
        }
        return join(array, separator, 0, array.length);
    }

    /**
     * <p>
     * Joins the elements of the provided array into a single String containing
     * the provided list of elements.
     * </p>
     * <p>
     * No delimiter is added before or after the list. A {@code null} separator
     * is the same as an empty String (""). Null objects or empty strings within
     * the array are represented by empty strings.
     * </p>
     *
     * <pre>
     * StringUtils.join(null, *)                = null
     * StringUtils.join([], *)                  = ""
     * StringUtils.join([null], *)              = ""
     * StringUtils.join(["a", "b", "c"], "--")  = "a--b--c"
     * StringUtils.join(["a", "b", "c"], null)  = "abc"
     * StringUtils.join(["a", "b", "c"], "")    = "abc"
     * StringUtils.join([null, "", "a"], ',')   = ",,a"
     * </pre>
     *
     * @param array the array of values to join together, may be null
     * @param separator the separator character to use, null treated as ""
     * @param startIndex the first index to start joining from. It is
     *        an error to pass in an end index past the end of the array
     * @param endIndex the index to stop joining from (exclusive). It is
     *        an error to pass in an end index past the end of the array
     * @return the joined String, {@code null} if null array input
     */
    public static String join(Object[] array, String separator, int startIndex, int endIndex) {
        if(array == null) {
            return null;
        }
        if(separator == null) {
            separator = EMPTY;
        }

        // endIndex - startIndex > 0: Len = NofStrings *(len(firstString) +
        // len(separator))
        // (Assuming that all Strings are roughly equally long)
        int noOfItems = endIndex - startIndex;
        if(noOfItems <= 0) {
            return EMPTY;
        }

        StringBuilder buf = new StringBuilder(noOfItems * 16);

        for(int i = startIndex ; i < endIndex ; i++) {
            if(i > startIndex) {
                buf.append(separator);
            }
            if(array[i] != null) {
                buf.append(array[i]);
            }
        }
        return buf.toString();
    }

    /**
     * <p>
     * Joins the elements of the provided {@code Iterator} into a single String
     * containing the provided elements.
     * </p>
     * <p>
     * No delimiter is added before or after the list. Null objects or empty
     * strings within the iteration are represented by empty strings.
     * </p>
     * <p>
     * See the examples here: {@link #join(Object[],char)}.
     * </p>
     *
     * @param iterator the {@code Iterator} of values to join together, may be
     *        null
     * @param separator the separator character to use
     * @return the joined String, {@code null} if null iterator input
     * @since 2.0
     */
    public static String join(Iterator<?> iterator, char separator) {

        // handle null, zero and one elements before building a buffer
        if(iterator == null) {
            return null;
        }
        if(!iterator.hasNext()) {
            return EMPTY;
        }
        Object first = iterator.next();
        if(!iterator.hasNext()) {
            return (first == null ? "" : first.toString());
        }

        // two or more elements
        StringBuilder buf = new StringBuilder(256); // Java default is 16,
                                                    // probably too small
        if(first != null) {
            buf.append(first);
        }

        while(iterator.hasNext()) {
            buf.append(separator);
            Object obj = iterator.next();
            if(obj != null) {
                buf.append(obj);
            }
        }

        return buf.toString();
    }

    /**
     * <p>
     * Joins the elements of the provided {@code Iterator} into a single String
     * containing the provided elements.
     * </p>
     * <p>
     * No delimiter is added before or after the list. A {@code null} separator
     * is the same as an empty String ("").
     * </p>
     * <p>
     * See the examples here: {@link #join(Object[],String)}.
     * </p>
     *
     * @param iterator the {@code Iterator} of values to join together, may be
     *        null
     * @param separator the separator character to use, null treated as ""
     * @return the joined String, {@code null} if null iterator input
     */
    public static String join(Iterator<?> iterator, String separator) {

        // handle null, zero and one elements before building a buffer
        if(iterator == null) {
            return null;
        }
        if(!iterator.hasNext()) {
            return EMPTY;
        }
        Object first = iterator.next();
        if(!iterator.hasNext()) {
            return (first == null ? "" : first.toString());
        }

        // two or more elements
        StringBuilder buf = new StringBuilder(256); // Java default is 16,
                                                    // probably too small
        if(first != null) {
            buf.append(first);
        }

        while(iterator.hasNext()) {
            if(separator != null) {
                buf.append(separator);
            }
            Object obj = iterator.next();
            if(obj != null) {
                buf.append(obj);
            }
        }
        return buf.toString();
    }

    /**
     * <p>
     * Joins the elements of the provided {@code Iterable} into a single String
     * containing the provided elements.
     * </p>
     * <p>
     * No delimiter is added before or after the list. Null objects or empty
     * strings within the iteration are represented by empty strings.
     * </p>
     * <p>
     * See the examples here: {@link #join(Object[],char)}.
     * </p>
     *
     * @param iterable the {@code Iterable} providing the values to join
     *        together, may be null
     * @param separator the separator character to use
     * @return the joined String, {@code null} if null iterator input
     * @since 2.3
     */
    public static String join(Iterable<?> iterable, char separator) {
        if(iterable == null) {
            return null;
        }
        return join(iterable.iterator(), separator);
    }

    /**
     * <p>
     * Joins the elements of the provided {@code Iterable} into a single String
     * containing the provided elements.
     * </p>
     * <p>
     * No delimiter is added before or after the list. A {@code null} separator
     * is the same as an empty String ("").
     * </p>
     * <p>
     * See the examples here: {@link #join(Object[],String)}.
     * </p>
     *
     * @param iterable the {@code Iterable} providing the values to join
     *        together, may be null
     * @param separator the separator character to use, null treated as ""
     * @return the joined String, {@code null} if null iterator input
     * @since 2.3
     */
    public static String join(Iterable<?> iterable, String separator) {
        if(iterable == null) {
            return null;
        }
        return join(iterable.iterator(), separator);
    }

    // Delete
    // -----------------------------------------------------------------------
    /**
     * <p>
     * Deletes all whitespaces from a String as defined by
     * {@link Character#isWhitespace(char)}.
     * </p>
     *
     * <pre>
     * StringUtils.deleteWhitespace(null)         = null
     * StringUtils.deleteWhitespace("")           = ""
     * StringUtils.deleteWhitespace("abc")        = "abc"
     * StringUtils.deleteWhitespace("   ab  c  ") = "abc"
     * </pre>
     *
     * @param str the String to delete whitespace from, may be null
     * @return the String without whitespaces, {@code null} if null String input
     */
    public static String deleteWhitespace(String str) {
        if(Validate.isEmpty(str)) {
            return str;
        }
        int sz = str.length();
        char[] chs = new char[sz];
        int count = 0;
        for(int i = 0 ; i < sz ; i++) {
            if(!Character.isWhitespace(str.charAt(i))) {
                chs[count++] = str.charAt(i);
            }
        }
        if(count == sz) {
            return str;
        }
        return new String(chs, 0, count);
    }

    // Remove
    // -----------------------------------------------------------------------
    /**
     * <p>
     * Removes a substring only if it is at the beginning of a source string,
     * otherwise returns the source string.
     * </p>
     * <p>
     * A {@code null} source string will return {@code null}. An empty ("")
     * source string will return the empty string. A {@code null} search string
     * will return the source string.
     * </p>
     *
     * <pre>
     * StringUtils.removeStart(null, *)      = null
     * StringUtils.removeStart("", *)        = ""
     * StringUtils.removeStart(*, null)      = *
     * StringUtils.removeStart("www.domain.com", "www.")   = "domain.com"
     * StringUtils.removeStart("domain.com", "www.")       = "domain.com"
     * StringUtils.removeStart("www.domain.com", "domain") = "www.domain.com"
     * StringUtils.removeStart("abc", "")    = "abc"
     * </pre>
     *
     * @param str the source String to search, may be null
     * @param remove the String to search for and remove, may be null
     * @return the substring with the string removed if found, {@code null} if
     *         null String input
     * @since 2.1
     */
    public static String removeStart(String str, String remove) {
        if(Validate.isEmpty(str) || Validate.isEmpty(remove)) {
            return str;
        }
        if(str.startsWith(remove)) {
            return str.substring(remove.length());
        }
        return str;
    }

    /**
     * <p>
     * Removes a substring only if it is at the end of a source string,
     * otherwise returns the source string.
     * </p>
     * <p>
     * A {@code null} source string will return {@code null}. An empty ("")
     * source string will return the empty string. A {@code null} search string
     * will return the source string.
     * </p>
     *
     * <pre>
     * StringUtils.removeEnd(null, *)      = null
     * StringUtils.removeEnd("", *)        = ""
     * StringUtils.removeEnd(*, null)      = *
     * StringUtils.removeEnd("www.domain.com", ".com.")  = "www.domain.com"
     * StringUtils.removeEnd("www.domain.com", ".com")   = "www.domain"
     * StringUtils.removeEnd("www.domain.com", "domain") = "www.domain.com"
     * StringUtils.removeEnd("abc", "")    = "abc"
     * </pre>
     *
     * @param str the source String to search, may be null
     * @param remove the String to search for and remove, may be null
     * @return the substring with the string removed if found, {@code null} if
     *         null String input
     * @since 2.1
     */
    public static String removeEnd(String str, String remove) {
        if(Validate.isEmpty(str) || Validate.isEmpty(remove)) {
            return str;
        }
        if(str.endsWith(remove)) {
            return str.substring(0, str.length() - remove.length());
        }
        return str;
    }

    /**
     * <p>
     * Removes all occurrences of a substring from within the source string.
     * </p>
     * <p>
     * A {@code null} source string will return {@code null}. An empty ("")
     * source string will return the empty string. A {@code null} remove string
     * will return the source string. An empty ("") remove string will return
     * the source string.
     * </p>
     *
     * <pre>
     * StringUtils.remove(null, *)        = null
     * StringUtils.remove("", *)          = ""
     * StringUtils.remove(*, null)        = *
     * StringUtils.remove(*, "")          = *
     * StringUtils.remove("queued", "ue") = "qd"
     * StringUtils.remove("queued", "zz") = "queued"
     * </pre>
     *
     * @param str the source String to search, may be null
     * @param remove the String to search for and remove, may be null
     * @return the substring with the string removed if found, {@code null} if
     *         null String input
     * @since 2.1
     */
    public static String remove(String str, String remove) {
        if(Validate.isEmpty(str) || Validate.isEmpty(remove)) {
            return str;
        }
        return replace(str, remove, EMPTY, -1);
    }

    /**
     * <p>
     * Removes all occurrences of a character from within the source string.
     * </p>
     * <p>
     * A {@code null} source string will return {@code null}. An empty ("")
     * source string will return the empty string.
     * </p>
     *
     * <pre>
     * StringUtils.remove(null, *)       = null
     * StringUtils.remove("", *)         = ""
     * StringUtils.remove("queued", 'u') = "qeed"
     * StringUtils.remove("queued", 'z') = "queued"
     * </pre>
     *
     * @param str the source String to search, may be null
     * @param remove the char to search for and remove, may be null
     * @return the substring with the char removed if found, {@code null} if
     *         null String input
     * @since 2.1
     */
    public static String remove(String str, char remove) {
        if(Validate.isEmpty(str) || str.indexOf(remove) == INDEX_NOT_FOUND) {
            return str;
        }
        char[] chars = str.toCharArray();
        int pos = 0;
        for(int i = 0 ; i < chars.length ; i++) {
            if(chars[i] != remove) {
                chars[pos++] = chars[i];
            }
        }
        return new String(chars, 0, pos);
    }

    // Replacing
    // -----------------------------------------------------------------------
    /**
     * <p>
     * Replaces a String with another String inside a larger String, once.
     * </p>
     * <p>
     * A {@code null} reference passed to this method is a no-op.
     * </p>
     *
     * <pre>
     * StringUtils.replaceOnce(null, *, *)        = null
     * StringUtils.replaceOnce("", *, *)          = ""
     * StringUtils.replaceOnce("any", null, *)    = "any"
     * StringUtils.replaceOnce("any", *, null)    = "any"
     * StringUtils.replaceOnce("any", "", *)      = "any"
     * StringUtils.replaceOnce("aba", "a", null)  = "aba"
     * StringUtils.replaceOnce("aba", "a", "")    = "ba"
     * StringUtils.replaceOnce("aba", "a", "z")   = "zba"
     * </pre>
     *
     * @see #replace(String text, String searchString, String replacement, int
     *      max)
     * @param text text to search and replace in, may be null
     * @param searchString the String to search for, may be null
     * @param replacement the String to replace with, may be null
     * @return the text with any replacements processed, {@code null} if null
     *         String input
     */
    public static String replaceOnce(String text, String searchString, String replacement) {
        return replace(text, searchString, replacement, 1);
    }

    /**
     * <p>
     * Replaces all occurrences of a String within another String.
     * </p>
     * <p>
     * A {@code null} reference passed to this method is a no-op.
     * </p>
     *
     * <pre>
     * StringUtils.replace(null, *, *)        = null
     * StringUtils.replace("", *, *)          = ""
     * StringUtils.replace("any", null, *)    = "any"
     * StringUtils.replace("any", *, null)    = "any"
     * StringUtils.replace("any", "", *)      = "any"
     * StringUtils.replace("aba", "a", null)  = "aba"
     * StringUtils.replace("aba", "a", "")    = "b"
     * StringUtils.replace("aba", "a", "z")   = "zbz"
     * </pre>
     *
     * @see #replace(String text, String searchString, String replacement, int
     *      max)
     * @param text text to search and replace in, may be null
     * @param searchString the String to search for, may be null
     * @param replacement the String to replace it with, may be null
     * @return the text with any replacements processed, {@code null} if null
     *         String input
     */
    public static String replace(String text, String searchString, String replacement) {
        return replace(text, searchString, replacement, -1);
    }

    /**
     * <p>
     * Replaces a String with another String inside a larger String, for the
     * first {@code max} values of the search String.
     * </p>
     * <p>
     * A {@code null} reference passed to this method is a no-op.
     * </p>
     *
     * <pre>
     * StringUtils.replace(null, *, *, *)         = null
     * StringUtils.replace("", *, *, *)           = ""
     * StringUtils.replace("any", null, *, *)     = "any"
     * StringUtils.replace("any", *, null, *)     = "any"
     * StringUtils.replace("any", "", *, *)       = "any"
     * StringUtils.replace("any", *, *, 0)        = "any"
     * StringUtils.replace("abaa", "a", null, -1) = "abaa"
     * StringUtils.replace("abaa", "a", "", -1)   = "b"
     * StringUtils.replace("abaa", "a", "z", 0)   = "abaa"
     * StringUtils.replace("abaa", "a", "z", 1)   = "zbaa"
     * StringUtils.replace("abaa", "a", "z", 2)   = "zbza"
     * StringUtils.replace("abaa", "a", "z", -1)  = "zbzz"
     * </pre>
     *
     * @param text text to search and replace in, may be null
     * @param searchString the String to search for, may be null
     * @param replacement the String to replace it with, may be null
     * @param max maximum number of values to replace, or {@code -1} if no
     *        maximum
     * @return the text with any replacements processed, {@code null} if null
     *         String input
     */
    public static String replace(String text, String searchString, String replacement, int max) {
        if(Validate.isEmpty(text) || Validate.isEmpty(searchString) || replacement == null || max == 0) {
            return text;
        }
        int start = 0;
        int end = text.indexOf(searchString, start);
        if(end == INDEX_NOT_FOUND) {
            return text;
        }
        int replLength = searchString.length();
        int increase = replacement.length() - replLength;
        increase = increase < 0 ? 0 : increase;
        increase *= max < 0 ? 16 : max > 64 ? 64 : max;
        StringBuilder buf = new StringBuilder(text.length() + increase);
        while(end != INDEX_NOT_FOUND) {
            buf.append(text.substring(start, end)).append(replacement);
            start = end + replLength;
            if(--max == 0) {
                break;
            }
            end = text.indexOf(searchString, start);
        }
        buf.append(text.substring(start));
        return buf.toString();
    }

    /**
     * <p>
     * Replaces all occurrences of Strings within another String.
     * </p>
     * <p>
     * A {@code null} reference passed to this method is a no-op, or if any
     * "search string" or "string to replace" is null, that replace will be
     * ignored. This will not repeat. For repeating replaces, call the
     * overloaded method.
     * </p>
     *
     * <pre>
     *  StringUtils.replaceEach(null, *, *)        = null
     *  StringUtils.replaceEach("", *, *)          = ""
     *  StringUtils.replaceEach("aba", null, null) = "aba"
     *  StringUtils.replaceEach("aba", new String[0], null) = "aba"
     *  StringUtils.replaceEach("aba", null, new String[0]) = "aba"
     *  StringUtils.replaceEach("aba", new String[]{"a"}, null)  = "aba"
     *  StringUtils.replaceEach("aba", new String[]{"a"}, new String[]{""})  = "b"
     *  StringUtils.replaceEach("aba", new String[]{null}, new String[]{"a"})  = "aba"
     *  StringUtils.replaceEach("abcde", new String[]{"ab", "d"}, new String[]{"w", "t"})  = "wcte"
     *  (example of how it does not repeat)
     *  StringUtils.replaceEach("abcde", new String[]{"ab", "d"}, new String[]{"d", "t"})  = "dcte"
     * </pre>
     *
     * @param text
     *        text to search and replace in, no-op if null
     * @param searchList
     *        the Strings to search for, no-op if null
     * @param replacementList
     *        the Strings to replace them with, no-op if null
     * @return the text with any replacements processed, {@code null} if
     *         null String input
     * @throws IllegalArgumentException
     *         if the lengths of the arrays are not the same (null is ok,
     *         and/or size 0)
     * @since 2.4
     */
    public static String replaceEach(String text, String[] searchList, String[] replacementList) {
        return replaceEach(text, searchList, replacementList, false, 0);
    }

    /**
     * <p>
     * Replaces all occurrences of Strings within another String.
     * </p>
     * <p>
     * A {@code null} reference passed to this method is a no-op, or if any
     * "search string" or "string to replace" is null, that replace will be
     * ignored.
     * </p>
     *
     * <pre>
     *  StringUtils.replaceEach(null, *, *, *) = null
     *  StringUtils.replaceEach("", *, *, *) = ""
     *  StringUtils.replaceEach("aba", null, null, *) = "aba"
     *  StringUtils.replaceEach("aba", new String[0], null, *) = "aba"
     *  StringUtils.replaceEach("aba", null, new String[0], *) = "aba"
     *  StringUtils.replaceEach("aba", new String[]{"a"}, null, *) = "aba"
     *  StringUtils.replaceEach("aba", new String[]{"a"}, new String[]{""}, *) = "b"
     *  StringUtils.replaceEach("aba", new String[]{null}, new String[]{"a"}, *) = "aba"
     *  StringUtils.replaceEach("abcde", new String[]{"ab", "d"}, new String[]{"w", "t"}, *) = "wcte"
     *  (example of how it repeats)
     *  StringUtils.replaceEach("abcde", new String[]{"ab", "d"}, new String[]{"d", "t"}, false) = "dcte"
     *  StringUtils.replaceEach("abcde", new String[]{"ab", "d"}, new String[]{"d", "t"}, true) = "tcte"
     *  StringUtils.replaceEach("abcde", new String[]{"ab", "d"}, new String[]{"d", "ab"}, true) = IllegalStateException
     *  StringUtils.replaceEach("abcde", new String[]{"ab", "d"}, new String[]{"d", "ab"}, false) = "dcabe"
     * </pre>
     *
     * @param text
     *        text to search and replace in, no-op if null
     * @param searchList
     *        the Strings to search for, no-op if null
     * @param replacementList
     *        the Strings to replace them with, no-op if null
     * @return the text with any replacements processed, {@code null} if
     *         null String input
     * @throws IllegalStateException
     *         if the search is repeating and there is an endless loop due
     *         to outputs of one being inputs to another
     * @throws IllegalArgumentException
     *         if the lengths of the arrays are not the same (null is ok,
     *         and/or size 0)
     * @since 2.4
     */
    public static String replaceEachRepeatedly(String text, String[] searchList, String[] replacementList) {
        // timeToLive should be 0 if not used or nothing to replace, else it's
        // the length of the replace array
        int timeToLive = searchList == null ? 0 : searchList.length;
        return replaceEach(text, searchList, replacementList, true, timeToLive);
    }

    /**
     * <p>
     * Replaces all occurrences of Strings within another String.
     * </p>
     * <p>
     * A {@code null} reference passed to this method is a no-op, or if any
     * "search string" or "string to replace" is null, that replace will be
     * ignored.
     * </p>
     *
     * <pre>
     *  StringUtils.replaceEach(null, *, *, *) = null
     *  StringUtils.replaceEach("", *, *, *) = ""
     *  StringUtils.replaceEach("aba", null, null, *) = "aba"
     *  StringUtils.replaceEach("aba", new String[0], null, *) = "aba"
     *  StringUtils.replaceEach("aba", null, new String[0], *) = "aba"
     *  StringUtils.replaceEach("aba", new String[]{"a"}, null, *) = "aba"
     *  StringUtils.replaceEach("aba", new String[]{"a"}, new String[]{""}, *) = "b"
     *  StringUtils.replaceEach("aba", new String[]{null}, new String[]{"a"}, *) = "aba"
     *  StringUtils.replaceEach("abcde", new String[]{"ab", "d"}, new String[]{"w", "t"}, *) = "wcte"
     *  (example of how it repeats)
     *  StringUtils.replaceEach("abcde", new String[]{"ab", "d"}, new String[]{"d", "t"}, false) = "dcte"
     *  StringUtils.replaceEach("abcde", new String[]{"ab", "d"}, new String[]{"d", "t"}, true) = "tcte"
     *  StringUtils.replaceEach("abcde", new String[]{"ab", "d"}, new String[]{"d", "ab"}, *) = IllegalStateException
     * </pre>
     *
     * @param text
     *        text to search and replace in, no-op if null
     * @param searchList
     *        the Strings to search for, no-op if null
     * @param replacementList
     *        the Strings to replace them with, no-op if null
     * @param repeat if true, then replace repeatedly
     *        until there are no more possible replacements or timeToLive < 0
     * @param timeToLive
     *        if less than 0 then there is a circular reference and endless
     *        loop
     * @return the text with any replacements processed, {@code null} if
     *         null String input
     * @throws IllegalStateException
     *         if the search is repeating and there is an endless loop due
     *         to outputs of one being inputs to another
     * @throws IllegalArgumentException
     *         if the lengths of the arrays are not the same (null is ok,
     *         and/or size 0)
     * @since 2.4
     */
    private static String replaceEach(String text, String[] searchList, String[] replacementList, boolean repeat,
        int timeToLive) {

        // mchyzer Performance note: This creates very few new objects (one
        // major goal)
        // let me know if there are performance requests, we can create a
        // harness to measure

        if(text == null || text.length() == 0 || searchList == null || searchList.length == 0
            || replacementList == null || replacementList.length == 0) {
            return text;
        }

        // if recursing, this shouldn't be less than 0
        if(timeToLive < 0) {
        	try {
        		throw new IllegalStateException("Aborting to protect against StackOverflowError - "
        				+ "output of one loop is the input of another");
			} catch (IllegalStateException e) {
				logger.error("", e);
			}
        }

        int searchLength = searchList.length;
        int replacementLength = replacementList.length;

        // make sure lengths are ok, these need to be equal
        if(searchLength != replacementLength) {
        	try {
        		throw new IllegalArgumentException("Search and Replace array lengths don't match: " + searchLength + " vs "
        				+ replacementLength);
			} catch (IllegalArgumentException e) {
				logger.error("", e);
			}
        }

        // keep track of which still have matches
        boolean[] noMoreMatchesForReplIndex = new boolean[searchLength];

        // index on index that the match was found
        int textIndex = -1;
        int replaceIndex = -1;
        int tempIndex = -1;

        // index of replace array that will replace the search string found
        // NOTE: logic duplicated below START
        for(int i = 0 ; i < searchLength ; i++) {
            if(noMoreMatchesForReplIndex[i] || searchList[i] == null || searchList[i].length() == 0
                || replacementList[i] == null) {
                continue;
            }
            tempIndex = text.indexOf(searchList[i]);

            // see if we need to keep searching for this
            if(tempIndex == -1) {
                noMoreMatchesForReplIndex[i] = true;
            } else {
                if(textIndex == -1 || tempIndex < textIndex) {
                    textIndex = tempIndex;
                    replaceIndex = i;
                }
            }
        }
        // NOTE: logic mostly below END

        // no search strings found, we are done
        if(textIndex == -1) {
            return text;
        }

        int start = 0;

        // get a good guess on the size of the result buffer so it doesn't have
        // to double if it goes over a bit
        int increase = 0;

        // count the replacement text elements that are larger than their
        // corresponding text being replaced
        for(int i = 0 ; i < searchList.length ; i++) {
            if(searchList[i] == null || replacementList[i] == null) {
                continue;
            }
            int greater = replacementList[i].length() - searchList[i].length();
            if(greater > 0) {
                increase += 3 * greater; // assume 3 matches
            }
        }
        // have upper-bound at 20% increase, then let Java take over
        increase = Math.min(increase, text.length() / 5);

        StringBuilder buf = new StringBuilder(text.length() + increase);

        while(textIndex != -1) {

            for(int i = start ; i < textIndex ; i++) {
                buf.append(text.charAt(i));
            }
            buf.append(replacementList[replaceIndex]);

            start = textIndex + searchList[replaceIndex].length();

            textIndex = -1;
            replaceIndex = -1;
            tempIndex = -1;
            // find the next earliest match
            // NOTE: logic mostly duplicated above START
            for(int i = 0 ; i < searchLength ; i++) {
                if(noMoreMatchesForReplIndex[i] || searchList[i] == null || searchList[i].length() == 0
                    || replacementList[i] == null) {
                    continue;
                }
                tempIndex = text.indexOf(searchList[i], start);

                // see if we need to keep searching for this
                if(tempIndex == -1) {
                    noMoreMatchesForReplIndex[i] = true;
                } else {
                    if(textIndex == -1 || tempIndex < textIndex) {
                        textIndex = tempIndex;
                        replaceIndex = i;
                    }
                }
            }
            // NOTE: logic duplicated above END

        }
        int textLength = text.length();
        for(int i = start ; i < textLength ; i++) {
            buf.append(text.charAt(i));
        }
        String result = buf.toString();
        if(!repeat) {
            return result;
        }

        return replaceEach(result, searchList, replacementList, repeat, timeToLive - 1);
    }

    // Replace, character based
    // -----------------------------------------------------------------------
    /**
     * <p>
     * Replaces all occurrences of a character in a String with another. This is
     * a null-safe version of {@link String#replace(char, char)}.
     * </p>
     * <p>
     * A {@code null} string input returns {@code null}. An empty ("") string
     * input returns an empty string.
     * </p>
     *
     * <pre>
     * StringUtils.replaceChars(null, *, *)        = null
     * StringUtils.replaceChars("", *, *)          = ""
     * StringUtils.replaceChars("abcba", 'b', 'y') = "aycya"
     * StringUtils.replaceChars("abcba", 'z', 'y') = "abcba"
     * </pre>
     *
     * @param str String to replace characters in, may be null
     * @param searchChar the character to search for, may be null
     * @param replaceChar the character to replace, may be null
     * @return modified String, {@code null} if null string input
     * @since 2.0
     */
    public static String replaceChars(String str, char searchChar, char replaceChar) {
        if(str == null) {
            return null;
        }
        return str.replace(searchChar, replaceChar);
    }

    /**
     * <p>
     * Replaces multiple characters in a String in one go. This method can also
     * be used to delete characters.
     * </p>
     * <p>
     * For example:<br />
     * <code>replaceChars(&quot;hello&quot;, &quot;ho&quot;, &quot;jy&quot;) = jelly</code>
     * .
     * </p>
     * <p>
     * A {@code null} string input returns {@code null}. An empty ("") string
     * input returns an empty string. A null or empty set of search characters
     * returns the input string.
     * </p>
     * <p>
     * The length of the search characters should normally equal the length of
     * the replace characters. If the search characters is longer, then the
     * extra search characters are deleted. If the search characters is shorter,
     * then the extra replace characters are ignored.
     * </p>
     *
     * <pre>
     * StringUtils.replaceChars(null, *, *)           = null
     * StringUtils.replaceChars("", *, *)             = ""
     * StringUtils.replaceChars("abc", null, *)       = "abc"
     * StringUtils.replaceChars("abc", "", *)         = "abc"
     * StringUtils.replaceChars("abc", "b", null)     = "ac"
     * StringUtils.replaceChars("abc", "b", "")       = "ac"
     * StringUtils.replaceChars("abcba", "bc", "yz")  = "ayzya"
     * StringUtils.replaceChars("abcba", "bc", "y")   = "ayya"
     * StringUtils.replaceChars("abcba", "bc", "yzx") = "ayzya"
     * </pre>
     *
     * @param str String to replace characters in, may be null
     * @param searchChars a set of characters to search for, may be null
     * @param replaceChars a set of characters to replace, may be null
     * @return modified String, {@code null} if null string input
     * @since 2.0
     */
    public static String replaceChars(String str, String searchChars, String replaceChars) {
        if(Validate.isEmpty(str) || Validate.isEmpty(searchChars)) {
            return str;
        }
        if(replaceChars == null) {
            replaceChars = EMPTY;
        }
        boolean modified = false;
        int replaceCharsLength = replaceChars.length();
        int strLength = str.length();
        StringBuilder buf = new StringBuilder(strLength);
        for(int i = 0 ; i < strLength ; i++) {
            char ch = str.charAt(i);
            int index = searchChars.indexOf(ch);
            if(index >= 0) {
                modified = true;
                if(index < replaceCharsLength) {
                    buf.append(replaceChars.charAt(index));
                }
            } else {
                buf.append(ch);
            }
        }
        if(modified) {
            return buf.toString();
        }
        return str;
    }

    // Overlay
    // -----------------------------------------------------------------------
    /**
     * <p>
     * Overlays part of a String with another String.
     * </p>
     * <p>
     * A {@code null} string input returns {@code null}. A negative index is
     * treated as zero. An index greater than the string length is treated as
     * the string length. The start index is always the smaller of the two
     * indices.
     * </p>
     *
     * <pre>
     * StringUtils.overlay(null, *, *, *)            = null
     * StringUtils.overlay("", "abc", 0, 0)          = "abc"
     * StringUtils.overlay("abcdef", null, 2, 4)     = "abef"
     * StringUtils.overlay("abcdef", "", 2, 4)       = "abef"
     * StringUtils.overlay("abcdef", "", 4, 2)       = "abef"
     * StringUtils.overlay("abcdef", "zzzz", 2, 4)   = "abzzzzef"
     * StringUtils.overlay("abcdef", "zzzz", 4, 2)   = "abzzzzef"
     * StringUtils.overlay("abcdef", "zzzz", -1, 4)  = "zzzzef"
     * StringUtils.overlay("abcdef", "zzzz", 2, 8)   = "abzzzz"
     * StringUtils.overlay("abcdef", "zzzz", -2, -3) = "zzzzabcdef"
     * StringUtils.overlay("abcdef", "zzzz", 8, 10)  = "abcdefzzzz"
     * </pre>
     *
     * @param str the String to do overlaying in, may be null
     * @param overlay the String to overlay, may be null
     * @param start the position to start overlaying at
     * @param end the position to stop overlaying before
     * @return overlayed String, {@code null} if null String input
     * @since 2.0
     */
    public static String overlay(String str, String overlay, int start, int end) {
        if(str == null) {
            return null;
        }
        if(overlay == null) {
            overlay = EMPTY;
        }
        int len = str.length();
        if(start < 0) {
            start = 0;
        }
        if(start > len) {
            start = len;
        }
        if(end < 0) {
            end = 0;
        }
        if(end > len) {
            end = len;
        }
        if(start > end) {
            int temp = start;
            start = end;
            end = temp;
        }
        return new StringBuilder(len + start - end + overlay.length() + 1).append(str.substring(0, start))
            .append(overlay).append(str.substring(end)).toString();
    }

    // Padding
    // -----------------------------------------------------------------------
    /**
     * <p>
     * Repeat a String {@code repeat} times to form a new String.
     * </p>
     *
     * <pre>
     * StringUtils.repeat(null, 2) = null
     * StringUtils.repeat("", 0)   = ""
     * StringUtils.repeat("", 2)   = ""
     * StringUtils.repeat("a", 3)  = "aaa"
     * StringUtils.repeat("ab", 2) = "abab"
     * StringUtils.repeat("a", -2) = ""
     * </pre>
     *
     * @param str the String to repeat, may be null
     * @param repeat number of times to repeat str, negative treated as zero
     * @return a new String consisting of the original String repeated,
     *         {@code null} if null String input
     */
    public static String repeat(String str, int repeat) {
        // Performance tuned for 2.0 (JDK1.4)

        if(str == null) {
            return null;
        }
        if(repeat <= 0) {
            return EMPTY;
        }
        int inputLength = str.length();
        if(repeat == 1 || inputLength == 0) {
            return str;
        }
        if(inputLength == 1 && repeat <= PAD_LIMIT) {
            return repeat(str.charAt(0), repeat);
        }

        int outputLength = inputLength * repeat;
        switch(inputLength) {
            case 1:
                return repeat(str.charAt(0), repeat);
            case 2:
                char ch0 = str.charAt(0);
                char ch1 = str.charAt(1);
                char[] output2 = new char[outputLength];
                for(int i = repeat * 2 - 2 ; i >= 0 ; i--, i--) {
                    output2[i] = ch0;
                    output2[i + 1] = ch1;
                }
                return new String(output2);
            default:
                StringBuilder buf = new StringBuilder(outputLength);
                for(int i = 0 ; i < repeat ; i++) {
                    buf.append(str);
                }
                return buf.toString();
        }
    }

    /**
     * <p>
     * Repeat a String {@code repeat} times to form a new String, with a String
     * separator injected each time.
     * </p>
     *
     * <pre>
     * StringUtils.repeat(null, null, 2) = null
     * StringUtils.repeat(null, "x", 2)  = null
     * StringUtils.repeat("", null, 0)   = ""
     * StringUtils.repeat("", "", 2)     = ""
     * StringUtils.repeat("", "x", 3)    = "xxx"
     * StringUtils.repeat("?", ", ", 3)  = "?, ?, ?"
     * </pre>
     *
     * @param str the String to repeat, may be null
     * @param separator the String to inject, may be null
     * @param repeat number of times to repeat str, negative treated as zero
     * @return a new String consisting of the original String repeated,
     *         {@code null} if null String input
     * @since 2.5
     */
    public static String repeat(String str, String separator, int repeat) {
        if(str == null || separator == null) {
            return repeat(str, repeat);
        } else {
            // given that repeat(String, int) is quite optimized, better to rely
            // on it than try and splice this into it
            String result = repeat(str + separator, repeat);
            return removeEnd(result, separator);
        }
    }

    /**
     * <p>
     * Returns padding using the specified delimiter repeated to a given length.
     * </p>
     *
     * <pre>
     * StringUtils.repeat(0, 'e')  = ""
     * StringUtils.repeat(3, 'e')  = "eee"
     * StringUtils.repeat(-2, 'e') = ""
     * </pre>
     * <p>
     * Note: this method doesn't not support padding with <a
     * href="http://www.unicode.org/glossary/#supplementary_character">Unicode
     * Supplementary Characters</a> as they require a pair of {@code char}s to
     * be represented. If you are needing to support full I18N of your
     * applications consider using {@link #repeat(String, int)} instead.
     * </p>
     *
     * @param ch character to repeat
     * @param repeat number of times to repeat char, negative treated as zero
     * @return String with repeated character
     * @see #repeat(String, int)
     */
    public static String repeat(char ch, int repeat) {
        char[] buf = new char[repeat];
        for(int i = repeat - 1 ; i >= 0 ; i--) {
            buf[i] = ch;
        }
        return new String(buf);
    }

    /**
     * <p>
     * Right pad a String with spaces (' ').
     * </p>
     * <p>
     * The String is padded to the size of {@code size}.
     * </p>
     *
     * <pre>
     * StringUtils.rightPad(null, *)   = null
     * StringUtils.rightPad("", 3)     = "   "
     * StringUtils.rightPad("bat", 3)  = "bat"
     * StringUtils.rightPad("bat", 5)  = "bat  "
     * StringUtils.rightPad("bat", 1)  = "bat"
     * StringUtils.rightPad("bat", -1) = "bat"
     * </pre>
     *
     * @param str the String to pad out, may be null
     * @param size the size to pad to
     * @return right padded String or original String if no padding is
     *         necessary, {@code null} if null String input
     */
    public static String rightPad(String str, int size) {
        return rightPad(str, size, ' ');
    }

    /**
     * <p>
     * Right pad a String with a specified character.
     * </p>
     * <p>
     * The String is padded to the size of {@code size}.
     * </p>
     *
     * <pre>
     * StringUtils.rightPad(null, *, *)     = null
     * StringUtils.rightPad("", 3, 'z')     = "zzz"
     * StringUtils.rightPad("bat", 3, 'z')  = "bat"
     * StringUtils.rightPad("bat", 5, 'z')  = "batzz"
     * StringUtils.rightPad("bat", 1, 'z')  = "bat"
     * StringUtils.rightPad("bat", -1, 'z') = "bat"
     * </pre>
     *
     * @param str the String to pad out, may be null
     * @param size the size to pad to
     * @param padChar the character to pad with
     * @return right padded String or original String if no padding is
     *         necessary, {@code null} if null String input
     * @since 2.0
     */
    public static String rightPad(String str, int size, char padChar) {
        if(str == null) {
            return null;
        }
        int pads = size - str.length();
        if(pads <= 0) {
            return str; // returns original String when possible
        }
        if(pads > PAD_LIMIT) {
            return rightPad(str, size, String.valueOf(padChar));
        }
        return str.concat(repeat(padChar, pads));
    }

    /**
     * <p>
     * Right pad a String with a specified String.
     * </p>
     * <p>
     * The String is padded to the size of {@code size}.
     * </p>
     *
     * <pre>
     * StringUtils.rightPad(null, *, *)      = null
     * StringUtils.rightPad("", 3, "z")      = "zzz"
     * StringUtils.rightPad("bat", 3, "yz")  = "bat"
     * StringUtils.rightPad("bat", 5, "yz")  = "batyz"
     * StringUtils.rightPad("bat", 8, "yz")  = "batyzyzy"
     * StringUtils.rightPad("bat", 1, "yz")  = "bat"
     * StringUtils.rightPad("bat", -1, "yz") = "bat"
     * StringUtils.rightPad("bat", 5, null)  = "bat  "
     * StringUtils.rightPad("bat", 5, "")    = "bat  "
     * </pre>
     *
     * @param str the String to pad out, may be null
     * @param size the size to pad to
     * @param padStr the String to pad with, null or empty treated as single
     *        space
     * @return right padded String or original String if no padding is
     *         necessary, {@code null} if null String input
     */
    public static String rightPad(String str, int size, String padStr) {
        if(str == null) {
            return null;
        }
        if(Validate.isEmpty(padStr)) {
            padStr = " ";
        }
        int padLen = padStr.length();
        int strLen = str.length();
        int pads = size - strLen;
        if(pads <= 0) {
            return str; // returns original String when possible
        }
        if(padLen == 1 && pads <= PAD_LIMIT) {
            return rightPad(str, size, padStr.charAt(0));
        }

        if(pads == padLen) {
            return str.concat(padStr);
        } else if(pads < padLen) {
            return str.concat(padStr.substring(0, pads));
        } else {
            char[] padding = new char[pads];
            char[] padChars = padStr.toCharArray();
            for(int i = 0 ; i < pads ; i++) {
                padding[i] = padChars[i % padLen];
            }
            return str.concat(new String(padding));
        }
    }

    /**
     * <p>
     * Left pad a String with spaces (' ').
     * </p>
     * <p>
     * The String is padded to the size of {@code size}.
     * </p>
     *
     * <pre>
     * StringUtils.leftPad(null, *)   = null
     * StringUtils.leftPad("", 3)     = "   "
     * StringUtils.leftPad("bat", 3)  = "bat"
     * StringUtils.leftPad("bat", 5)  = "  bat"
     * StringUtils.leftPad("bat", 1)  = "bat"
     * StringUtils.leftPad("bat", -1) = "bat"
     * </pre>
     *
     * @param str the String to pad out, may be null
     * @param size the size to pad to
     * @return left padded String or original String if no padding is necessary,
     *         {@code null} if null String input
     */
    public static String leftPad(String str, int size) {
        return leftPad(str, size, ' ');
    }

    /**
     * <p>
     * Left pad a String with a specified character.
     * </p>
     * <p>
     * Pad to a size of {@code size}.
     * </p>
     *
     * <pre>
     * StringUtils.leftPad(null, *, *)     = null
     * StringUtils.leftPad("", 3, 'z')     = "zzz"
     * StringUtils.leftPad("bat", 3, 'z')  = "bat"
     * StringUtils.leftPad("bat", 5, 'z')  = "zzbat"
     * StringUtils.leftPad("bat", 1, 'z')  = "bat"
     * StringUtils.leftPad("bat", -1, 'z') = "bat"
     * </pre>
     *
     * @param str the String to pad out, may be null
     * @param size the size to pad to
     * @param padChar the character to pad with
     * @return left padded String or original String if no padding is necessary,
     *         {@code null} if null String input
     * @since 2.0
     */
    public static String leftPad(String str, int size, char padChar) {
        if(str == null) {
            return null;
        }
        int pads = size - str.length();
        if(pads <= 0) {
            return str; // returns original String when possible
        }
        if(pads > PAD_LIMIT) {
            return leftPad(str, size, String.valueOf(padChar));
        }
        return repeat(padChar, pads).concat(str);
    }

    /**
     * <p>
     * Left pad a String with a specified String.
     * </p>
     * <p>
     * Pad to a size of {@code size}.
     * </p>
     *
     * <pre>
     * StringUtils.leftPad(null, *, *)      = null
     * StringUtils.leftPad("", 3, "z")      = "zzz"
     * StringUtils.leftPad("bat", 3, "yz")  = "bat"
     * StringUtils.leftPad("bat", 5, "yz")  = "yzbat"
     * StringUtils.leftPad("bat", 8, "yz")  = "yzyzybat"
     * StringUtils.leftPad("bat", 1, "yz")  = "bat"
     * StringUtils.leftPad("bat", -1, "yz") = "bat"
     * StringUtils.leftPad("bat", 5, null)  = "  bat"
     * StringUtils.leftPad("bat", 5, "")    = "  bat"
     * </pre>
     *
     * @param str the String to pad out, may be null
     * @param size the size to pad to
     * @param padStr the String to pad with, null or empty treated as single
     *        space
     * @return left padded String or original String if no padding is necessary,
     *         {@code null} if null String input
     */
    public static String leftPad(String str, int size, String padStr) {
        if(str == null) {
            return null;
        }
        if(Validate.isEmpty(padStr)) {
            padStr = " ";
        }
        int padLen = padStr.length();
        int strLen = str.length();
        int pads = size - strLen;
        if(pads <= 0) {
            return str; // returns original String when possible
        }
        if(padLen == 1 && pads <= PAD_LIMIT) {
            return leftPad(str, size, padStr.charAt(0));
        }

        if(pads == padLen) {
            return padStr.concat(str);
        } else if(pads < padLen) {
            return padStr.substring(0, pads).concat(str);
        } else {
            char[] padding = new char[pads];
            char[] padChars = padStr.toCharArray();
            for(int i = 0 ; i < pads ; i++) {
                padding[i] = padChars[i % padLen];
            }
            return new String(padding).concat(str);
        }
    }

    /**
     * Gets a CharSequence length or {@code 0} if the CharSequence is
     * {@code null}.
     *
     * @param cs
     *        a CharSequence or {@code null}
     * @return CharSequence length or {@code 0} if the CharSequence is
     *         {@code null}.
     * @since 2.4
     * @since 3.0 Changed signature from length(String) to length(CharSequence)
     */
    public static int length(CharSequence cs) {
        return cs == null ? 0 : cs.length();
    }

    // Case conversion
    // -----------------------------------------------------------------------
    /**
     * <p>
     * Converts a String to upper case as per {@link String#toUpperCase()}.
     * </p>
     * <p>
     * A {@code null} input String returns {@code null}.
     * </p>
     *
     * <pre>
     * StringUtils.upperCase(null)  = null
     * StringUtils.upperCase("")    = ""
     * StringUtils.upperCase("aBc") = "ABC"
     * </pre>
     * <p>
     * <strong>Note:</strong> As described in the documentation for
     * {@link String#toUpperCase()}, the result of this method is affected by
     * the current locale. For platform-independent case transformations, the
     * method {@link #lowerCase(String, Locale)} should be used with a specific
     * locale (e.g. {@link Locale#ENGLISH}).
     * </p>
     *
     * @param str the String to upper case, may be null
     * @return the upper cased String, {@code null} if null String input
     */
    public static String upperCase(String str) {
        if(str == null) {
            return null;
        }
        return str.toUpperCase();
    }

    /**
     * <p>
     * Converts a String to upper case as per {@link String#toUpperCase(Locale)}
     * .
     * </p>
     * <p>
     * A {@code null} input String returns {@code null}.
     * </p>
     *
     * <pre>
     * StringUtils.upperCase(null, Locale.ENGLISH)  = null
     * StringUtils.upperCase("", Locale.ENGLISH)    = ""
     * StringUtils.upperCase("aBc", Locale.ENGLISH) = "ABC"
     * </pre>
     *
     * @param str the String to upper case, may be null
     * @param locale the locale that defines the case transformation rules, must
     *        not be null
     * @return the upper cased String, {@code null} if null String input
     * @since 2.5
     */
    public static String upperCase(String str, Locale locale) {
        if(str == null) {
            return null;
        }
        return str.toUpperCase(locale);
    }

    /**
     * <p>
     * Converts a String to lower case as per {@link String#toLowerCase()}.
     * </p>
     * <p>
     * A {@code null} input String returns {@code null}.
     * </p>
     *
     * <pre>
     * StringUtils.lowerCase(null)  = null
     * StringUtils.lowerCase("")    = ""
     * StringUtils.lowerCase("aBc") = "abc"
     * </pre>
     * <p>
     * <strong>Note:</strong> As described in the documentation for
     * {@link String#toLowerCase()}, the result of this method is affected by
     * the current locale. For platform-independent case transformations, the
     * method {@link #lowerCase(String, Locale)} should be used with a specific
     * locale (e.g. {@link Locale#ENGLISH}).
     * </p>
     *
     * @param str the String to lower case, may be null
     * @return the lower cased String, {@code null} if null String input
     */
    public static String lowerCase(String str) {
        if(str == null) {
            return null;
        }
        return str.toLowerCase();
    }

    /**
     * <p>
     * Converts a String to lower case as per {@link String#toLowerCase(Locale)}
     * .
     * </p>
     * <p>
     * A {@code null} input String returns {@code null}.
     * </p>
     *
     * <pre>
     * StringUtils.lowerCase(null, Locale.ENGLISH)  = null
     * StringUtils.lowerCase("", Locale.ENGLISH)    = ""
     * StringUtils.lowerCase("aBc", Locale.ENGLISH) = "abc"
     * </pre>
     *
     * @param str the String to lower case, may be null
     * @param locale the locale that defines the case transformation rules, must
     *        not be null
     * @return the lower cased String, {@code null} if null String input
     * @since 2.5
     */
    public static String lowerCase(String str, Locale locale) {
        if(str == null) {
            return null;
        }
        return str.toLowerCase(locale);
    }

    /**
     * <p>
     * Capitalizes a String changing the first letter to title case as per
     * {@link Character#toTitleCase(char)}. No other letters are changed.
     * </p>
     * <p>
     * For a word based algorithm, see
     * {@link org.apache.commons.lang3.text.WordUtils#capitalize(String)}. A
     * {@code null} input String returns {@code null}.
     * </p>
     *
     * <pre>
     * StringUtils.capitalize(null)  = null
     * StringUtils.capitalize("")    = ""
     * StringUtils.capitalize("cat") = "Cat"
     * StringUtils.capitalize("cAt") = "CAt"
     * </pre>
     *
     * @param str the String to capitalize, may be null
     * @return the capitalized String, {@code null} if null String input
     * @see org.apache.commons.lang3.text.WordUtils#capitalize(String)
     * @see #uncapitalize(String)
     * @since 2.0
     */
    public static String capitalize(String str) {
        int strLen;
        if(str == null || (strLen = str.length()) == 0) {
            return str;
        }
        return new StringBuilder(strLen).append(Character.toTitleCase(str.charAt(0))).append(str.substring(1))
            .toString();
    }

    /**
     * <p>
     * Uncapitalizes a String changing the first letter to title case as per
     * {@link Character#toLowerCase(char)}. No other letters are changed.
     * </p>
     * <p>
     * For a word based algorithm, see
     * {@link org.apache.commons.lang3.text.WordUtils#uncapitalize(String)}. A
     * {@code null} input String returns {@code null}.
     * </p>
     *
     * <pre>
     * StringUtils.uncapitalize(null)  = null
     * StringUtils.uncapitalize("")    = ""
     * StringUtils.uncapitalize("Cat") = "cat"
     * StringUtils.uncapitalize("CAT") = "cAT"
     * </pre>
     *
     * @param str the String to uncapitalize, may be null
     * @return the uncapitalized String, {@code null} if null String input
     * @see org.apache.commons.lang3.text.WordUtils#uncapitalize(String)
     * @see #capitalize(String)
     * @since 2.0
     */
    public static String uncapitalize(String str) {
        int strLen;
        if(str == null || (strLen = str.length()) == 0) {
            return str;
        }
        return new StringBuilder(strLen).append(Character.toLowerCase(str.charAt(0))).append(str.substring(1))
            .toString();
    }

    /**
     * <p>
     * Swaps the case of a String changing upper and title case to lower case,
     * and lower case to upper case.
     * </p>
     * <ul>
     * <li>Upper case character converts to Lower case</li>
     * <li>Title case character converts to Lower case</li>
     * <li>Lower case character converts to Upper case</li>
     * </ul>
     * <p>
     * For a word based algorithm, see
     * {@link org.apache.commons.lang3.text.WordUtils#swapCase(String)}. A
     * {@code null} input String returns {@code null}.
     * </p>
     *
     * <pre>
     * StringUtils.swapCase(null)                 = null
     * StringUtils.swapCase("")                   = ""
     * StringUtils.swapCase("The dog has a BONE") = "tHE DOG HAS A bone"
     * </pre>
     * <p>
     * NOTE: This method changed in Lang version 2.0. It no longer performs a
     * word based algorithm. If you only use ASCII, you will notice no change.
     * That functionality is available in
     * org.apache.commons.lang3.text.WordUtils.
     * </p>
     *
     * @param str the String to swap case, may be null
     * @return the changed String, {@code null} if null String input
     */
    public static String swapCase(String str) {
        if(str == null || str.length() <= 0) {
            return str;
        }

        char[] buffer = str.toCharArray();

        for(int i = 0 ; i < buffer.length ; i++) {
            char ch = buffer[i];
            if(Character.isUpperCase(ch)) {
                buffer[i] = Character.toLowerCase(ch);
            } else if(Character.isTitleCase(ch)) {
                buffer[i] = Character.toLowerCase(ch);
            } else if(Character.isLowerCase(ch)) {
                buffer[i] = Character.toUpperCase(ch);
            }
        }
        return new String(buffer);
    }

    // Abbreviating
    // -----------------------------------------------------------------------
    /**
     * <p>
     * Abbreviates a String using ellipses. This will turn
     * "Now is the time for all good men" into "Now is the time for..."
     * </p>
     * <p>
     * Specifically:
     * <ul>
     * <li>If {@code str} is less than {@code maxWidth} characters long, return
     * it.</li>
     * <li>Else abbreviate it to {@code (substring(str, 0, max-3) + "...")}.</li>
     * <li>If {@code maxWidth} is less than {@code 4}, throw an
     * {@code IllegalArgumentException}.</li>
     * <li>In no case will it return a String of length greater than
     * {@code maxWidth}.</li>
     * </ul>
     * </p>
     *
     * <pre>
     * StringUtils.abbreviate(null, *)      = null
     * StringUtils.abbreviate("", 4)        = ""
     * StringUtils.abbreviate("abcdefg", 6) = "abc..."
     * StringUtils.abbreviate("abcdefg", 7) = "abcdefg"
     * StringUtils.abbreviate("abcdefg", 8) = "abcdefg"
     * StringUtils.abbreviate("abcdefg", 4) = "a..."
     * StringUtils.abbreviate("abcdefg", 3) = IllegalArgumentException
     * </pre>
     *
     * @param str the String to check, may be null
     * @param maxWidth maximum length of result String, must be at least 4
     * @return abbreviated String, {@code null} if null String input
     * @throws IllegalArgumentException if the width is too small
     * @since 2.0
     */
    public static String abbreviate(String str, int maxWidth) {
        return abbreviate(str, 0, maxWidth);
    }

    /**
     * <p>
     * Abbreviates a String using ellipses. This will turn
     * "Now is the time for all good men" into "...is the time for..."
     * </p>
     * <p>
     * Works like {@code abbreviate(String, int)}, but allows you to specify a
     * "left edge" offset. Note that this left edge is not necessarily going to
     * be the leftmost character in the result, or the first character following
     * the ellipses, but it will appear somewhere in the result.
     * <p>
     * In no case will it return a String of length greater than
     * {@code maxWidth}.
     * </p>
     *
     * <pre>
     * StringUtils.abbreviate(null, *, *)                = null
     * StringUtils.abbreviate("", 0, 4)                  = ""
     * StringUtils.abbreviate("abcdefghijklmno", -1, 10) = "abcdefg..."
     * StringUtils.abbreviate("abcdefghijklmno", 0, 10)  = "abcdefg..."
     * StringUtils.abbreviate("abcdefghijklmno", 1, 10)  = "abcdefg..."
     * StringUtils.abbreviate("abcdefghijklmno", 4, 10)  = "abcdefg..."
     * StringUtils.abbreviate("abcdefghijklmno", 5, 10)  = "...fghi..."
     * StringUtils.abbreviate("abcdefghijklmno", 6, 10)  = "...ghij..."
     * StringUtils.abbreviate("abcdefghijklmno", 8, 10)  = "...ijklmno"
     * StringUtils.abbreviate("abcdefghijklmno", 10, 10) = "...ijklmno"
     * StringUtils.abbreviate("abcdefghijklmno", 12, 10) = "...ijklmno"
     * StringUtils.abbreviate("abcdefghij", 0, 3)        = IllegalArgumentException
     * StringUtils.abbreviate("abcdefghij", 5, 6)        = IllegalArgumentException
     * </pre>
     *
     * @param str the String to check, may be null
     * @param offset left edge of source String
     * @param maxWidth maximum length of result String, must be at least 4
     * @return abbreviated String, {@code null} if null String input
     * @throws IllegalArgumentException if the width is too small
     * @since 2.0
     */
    public static String abbreviate(String str, int offset, int maxWidth) {
        if(str == null) {
            return null;
        }
        if(maxWidth < 4) {
        	try {
        		throw new IllegalArgumentException("Minimum abbreviation width is 4");
			} catch (IllegalArgumentException e) {
				logger.error("", e);
			}
        }
        if(str.length() <= maxWidth) {
            return str;
        }
        if(offset > str.length()) {
            offset = str.length();
        }
        if(str.length() - offset < maxWidth - 3) {
            offset = str.length() - (maxWidth - 3);
        }
        final String abrevMarker = "...";
        if(offset <= 4) {
            return str.substring(0, maxWidth - 3) + abrevMarker;
        }
        if(maxWidth < 7) {
        	try {
        		throw new IllegalArgumentException("Minimum abbreviation width with offset is 7");
			} catch (IllegalArgumentException e) {
				logger.error("", e);
			}
        }
        if(offset + maxWidth - 3 < str.length()) {
            return abrevMarker + abbreviate(str.substring(offset), maxWidth - 3);
        }
        return abrevMarker + str.substring(str.length() - (maxWidth - 3));
    }

    /**
     * 오른쪽에 문자 채우기.
     *
     * @param srValue 원래 문자열
     * @param nCount 총 문자열의 길이
     * @param fillchar 채울 문자
     * @return 지정된 길이로 변경된 문자열
     */
    public static String fillSpaceRight(String srValue, int nCount, char fillchar) {
        if(Validate.isEmpty(srValue)) {
            return fillSpace(fillchar + "", nCount);
        }

        StringBuffer temp = new StringBuffer();

        temp.append(srValue);
        temp.append(fillSpace(String.valueOf(fillchar), nCount - srValue.length()));

        return temp.toString();
    }

    /**
     * 왼쪽에 문자 채우기.
     *
     * @param nValue 원래 문자
     * @param nCount 문자열 총 길이
     * @param fillchar 채울 문자
     * @return 지정된 길이로 변경된 문자열
     */
    public static String fillSpaceLeft(String nValue, int nCount, char fillchar) {
        if(Validate.isEmpty(nValue)) {
            return fillSpace(fillchar + "", nCount);
        }

        String tmpString = nValue;
        int len = nValue.length();
        tmpString = fillSpace(String.valueOf(fillchar), nCount - len) + nValue;
        return tmpString;
    }

    /**
     * 문자 srValue를 size 만큼 반복하기.
     *
     * @param srValue
     * @param size
     * @return 반복하여 생성된 문자열
     */
    public static String fillSpace(String srValue, int size) {
        StringBuffer temp = new StringBuffer();

        for(int i = 0 ; i < size ; i++) {
            temp.append(srValue);
        }

        return temp.toString();
    }

    /**
     * XXX_YYY_ZZZ 형식의 DB 컬럼명을 JAVA 맴버변수 형식인 Camel Case 표기법으로 변경한다.
     *
     * @param field
     * @return
     */
    public static String camelCase(String field) {

        String lowerField = field.toLowerCase();

        if(lowerField.indexOf("_", 1) < 0) {
            return lowerField;
        }

        String word1, word2;
        String[] words = lowerField.split("_");

        StringBuilder sb = new StringBuilder();
        sb.append(words[0]);

        for(int i = 1 ; i < words.length ; i++) {
            word1 = words[i].substring(0, 1).toUpperCase();
            word2 = words[i].substring(1);

            sb.append(word1).append(word2);
        }

        return sb.toString();
    }

    /**
     * 지정한 길이만큼 문자열을 생략한다.
     *
     * @EXAMPLE StringUtil.omit("aaaa", 2) -> returns "aa.."
     * @param String omitStr
     * @param int omitLength
     */
    public static String omit(String omitStr, int omitLength) {

        if(Validate.isEmpty(omitStr)) {
            return EMPTY;
        }

        if(omitLength <= 0) {
            omitLength = 60;
        }

        String omittee = Converter.cleanHtml(omitStr);
        if(getUnicodeLength(omittee) > omitLength) {
            omittee = StringUtil.fixUnicodeLength(omittee, omitLength, "..");
        }

        return omittee;
    }

    /**
     * 스트링을 지정한 길이만큼 자른 뒤 지정한 문자열을 추가한다. (한글처리)
     *
     * @param str
     *        대상 문자열
     * @param limit
     *        자를 길이의 최대값
     * @param postFix
     *        뒤에 추가할 문자열
     * @return 지정한 길이만큼 잘려진 문자열
     */
    public static String fixUnicodeLength(String str, int limit, String postFix) {

        if(str == null) {
            return EMPTY;
        }

        char[] charArray = str.toCharArray();

        if(limit >= charArray.length) {
            return str;
        }

        if(postFix == null) {
            return new String(charArray, 0, limit);
        } else {
            return new String(charArray, 0, limit).concat(postFix);
        }
    }

    /**
     * 지정 문자열의 길이를 얻는다. (한글처리)
     *
     * @param str
     *        대상 문자열
     * @return 문자열 길이
     */
    public static int getUnicodeLength(String str) {

        if(str == null) {
            return ZERO;
        }

        return str.toCharArray().length;
    }

    /**
     * String Unicode Encoding
     * URLEncoder 설명
     * @param qs
     * @return QS
     */
    public static String URLEncoder(String qs){

        String QS = new String();

        try{
            QS = URLEncoder.encode(qs,"utf-8");
        }catch(UnsupportedEncodingException UEE){
            QS = qs;
        }
        return QS;
    }

    /**
     * 전화번호 format으로 변환
     * @param str
     * 			대상문자열
     * @return
     */
    public static Map<String, String> telNumFormat(String str) {
    	Map<String,String> map = new HashMap<String,String>();
    	int len;
    	int maxLen = 8;

    	try {

    		if(str == null) {
    			str = "";
    		}

    		if(str.indexOf("-") > 0) {
    			str = str.replace("-", "");
        	}

    		len = substring(str, 3).length();
    		if(substring(str, 0, 2).equals("01")) {

    			if(len >= maxLen) {
    				map.put("first", substring(str, 0, 3));
    				map.put("middle", substring(str, 3, 7));
    				map.put("last", substring(str, 7));
    			}else if(len < maxLen) {
    				map.put("first", substring(str, 0, 3));
    				map.put("middle", substring(str, 3, 6));
    				map.put("last", substring(str, 6));
    			}
    		}else {
    			if(substring(str, 0, 2).equals("02")) {
    				len = substring(str, 2).length();

    				if(len >= maxLen) {
        				map.put("first", substring(str, 0, 2));
        				map.put("middle", substring(str, 2, 6));
        				map.put("last", substring(str, 6));
        			}else if(len < maxLen) {
        				map.put("first", substring(str, 0, 2));
        				map.put("middle", substring(str, 2, 5));
        				map.put("last", substring(str, 5));
        			}
    			}else {
    				if(len >= maxLen) {
        				map.put("first", substring(str, 0, 3));
        				map.put("middle", substring(str, 3, 7));
        				map.put("last", substring(str, 7));
        			}else if(len < maxLen) {
        				map.put("first", substring(str, 0, 3));
        				map.put("middle", substring(str, 3, 6));
        				map.put("last", substring(str, 6));
        			}
    			}
    		}

    	}catch(RuntimeException e) {
    		return map;
    	}catch(Exception e) {
    		return map;
    	}

    	return map;
    }


    /**
     * 법인등록번호 format으로 변환
     * @param str
     * 			대상문자열
     * @return
     */
    public static Map<String, String> toJurirnoFormat(String str) {
    	Map<String,String> map = new HashMap<String,String>();
    	if(str.length()<13) {
    		return map;
    	}

    	map.put("first", substring(str,0, 6));
    	map.put("last", substring(str, 6));

    	return map;
    }

    /**
     * 사업자등록번호 format으로 변환
     * @param str
     * 			대상문자열
     * @return
     */
    public static Map<String, String> toBizrnoFormat(String str) {
    	Map<String,String> map = new HashMap<String,String>();
    	if(str.length()<10) {
    		return map;
    	}

    	map.put("first", substring(str,0, 3));
    	map.put("middle", substring(str, 3, 5));
    	map.put("last", substring(str, 5));

    	return map;
    }

    /**
     * 날짜 format으로 변환
     * @param str
     * 			대상문자열
     * @return
     */
    public static Map<String, String> toDateFormat(String str) {
    	Map<String,String> map = new HashMap<String,String>();
    	if(str.length()<8) {
    		return map;
    	}

    	map.put("first", substring(str,0, 4));
    	map.put("middle", substring(str, 4, 6));
    	map.put("last", substring(str, 6, 8));

    	return map;
    }

}
