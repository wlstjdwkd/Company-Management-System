package com.infra.util;

/**
 * <p>
 * <code>java.lang.System</code>을 보다 쉽게 사용하도록 해주는 Helper 클래스.
 * </p>
 * 특정기능을 제공하기 보다는 환경과 관련된 변수를 쉽게 사용할 수 있도록 지원해준다.
 * <p>
 * 만약 보안문제로 시스템 프로퍼티를 읽을 수 없다면, 해당 필드는 <code>null</code>을 리턴하며
 * <code>System.err</code>로 해당 에러메시지가 출력된다.
 * </p>
 * 
 */
public final class SystemUtil {

    // System property constants
    // -----------------------------------------------------------------------
    // These MUST be declared first. Other constants depend on this.

    /**
     * <p>
     * <code>file.encoding</code> 프로퍼티의 값.
     * </p>
     * <p>
     * <code>Cp1252</code>과 같은 파일 인코딩 값을 의미함.
     * </p>
     * 
     * @since 2.0
     * @since Java 1.2.
     */
    public static final String FILE_ENCODING = getSystemProperty("file.encoding");

    /**
     * <p>
     * <code>file.separator</code> 프로퍼티의 값. 파일 구분자 (유닉스에서는
     * <code>&quot;/&quot;</code>)를 의미함.
     * </p>
     * 
     * @since Java 1.1.
     */
    public static final String FILE_SEPARATOR = getSystemProperty("file.separator");

    /**
     * <p>
     * <code>java.class.path</code> 프로퍼티의 값.
     * </p>
     * 
     * @since Java 1.1.
     */
    public static final String JAVA_CLASS_PATH = getSystemProperty("java.class.path");

    /**
     * <p>
     * <code>java.class.version</code> 프로퍼티의 값. Java 클래스 포맷 버전을 나타냄.
     * </p>
     * 
     * @since Java 1.1.
     */
    public static final String JAVA_CLASS_VERSION = getSystemProperty("java.class.version");

    /**
     * <p>
     * <code>java.compiler</code> 프로퍼티의 값. Name of JIT compiler to use. JIT
     * 컴파일러명을 나타냄. 참고로 JDK 1.2 이후부터는 사용되지 않음.
     * </p>
     * 
     * @since Java 1.2.
     */
    public static final String JAVA_COMPILER = getSystemProperty("java.compiler");

    /**
     * <p>
     * <code>java.ext.dirs</code> 프로퍼티의 값. 확장 경로의 패스를 나타냄.
     * </p>
     * 
     * @since Java 1.3
     */
    public static final String JAVA_EXT_DIRS = getSystemProperty("java.ext.dirs");

    public static final String JAVA_ENDORSED_DIRS = getSystemProperty("java.endorsed.dirs");

    /**
     * <p>
     * <code>java.home</code> 프로퍼티의 값. 자바 설치 디렉토리를 나타냄.
     * </p>
     * 
     * @since Java 1.1
     */
    public static final String JAVA_HOME = getSystemProperty("java.home");

    /**
     * <p>
     * <code>java.io.tmpdir</code> 프로퍼티의 값. 임시 디렉토리를 나타냄.
     * </p>
     * 
     * @since Java 1.2
     */
    public static final String JAVA_IO_TMPDIR = getSystemProperty("java.io.tmpdir");

    /**
     * <p>
     * <code>java.library.path</code> 프로퍼티의 값. 라이브러리 로드시 참조할 경로를 나타냄.
     * </p>
     * 
     * @since Java 1.2
     */
    public static final String JAVA_LIBRARY_PATH = getSystemProperty("java.library.path");

    /**
     * <p>
     * <code>java.runtime.name</code> 프로퍼티의 값. 자바 런타임 환경의 이름을 나타냄.
     * </p>
     * 
     * @since 2.0
     * @since Java 1.3
     */
    public static final String JAVA_RUNTIME_NAME = getSystemProperty("java.runtime.name");

    /**
     * <p>
     * <code>java.runtime.version</code> 프로퍼티의 값. 자바 런타임 환경의 버전을 나타냄.
     * </p>
     * 
     * @since 2.0
     * @since Java 1.3
     */
    public static final String JAVA_RUNTIME_VERSION = getSystemProperty("java.runtime.version");

    /**
     * <p>
     * <code>java.specification.name</code> 프로퍼티의 값. 자바 런타임 환경의 명세을 나타냄.
     * </p>
     * 
     * @since Java 1.2
     */
    public static final String JAVA_SPECIFICATION_NAME = getSystemProperty("java.specification.name");

    /**
     * <p>
     * <code>java.specification.vendor</code> 프로퍼티의 값. 자바 런타임 환경의 명세를 정의한 벤더를
     * 나타냄.
     * </p>
     * 
     * @since Java 1.2
     */
    public static final String JAVA_SPECIFICATION_VENDOR = getSystemProperty("java.specification.vendor");

    /**
     * <p>
     * <code>java.specification.version</code> 프로퍼티의 값. 자바 런타임 환경의 명세 버전을 나타냄.
     * </p>
     * 
     * @since Java 1.3
     */
    public static final String JAVA_SPECIFICATION_VERSION = getSystemProperty("java.specification.version");

    /**
     * <p>
     * <code>java.vendor</code> 프로퍼티의 값. 자바 벤더-명세를 나타냄.
     * </p>
     * 
     * @since Java 1.1
     */
    public static final String JAVA_VENDOR = getSystemProperty("java.vendor");

    /**
     * <p>
     * <code>java.vendor.url</code> 프로퍼티의 값. 자바 벤더의 URL을 나타냄.
     * </p>
     * 
     * @since Java 1.1
     */
    public static final String JAVA_VENDOR_URL = getSystemProperty("java.vendor.url");

    /**
     * <p>
     * <code>java.version</code> 프로퍼티의 값. 자바 버전을 나타냄.
     * </p>
     * 
     * @since Java 1.1
     */
    public static final String JAVA_VERSION = getSystemProperty("java.version");

    /**
     * <p>
     * <code>java.vm.info</code> 프로퍼티의 값. 자바 가상머신 구현정보를 나타냄.
     * </p>
     * 
     * @since 2.0
     * @since Java 1.2
     */
    public static final String JAVA_VM_INFO = getSystemProperty("java.vm.info");

    /**
     * <p>
     * <code>java.vm.name</code> 프로퍼티의 값. 자바 가상머신 구현체를 나타냄.
     * </p>
     * 
     * @since Java 1.2
     */
    public static final String JAVA_VM_NAME = getSystemProperty("java.vm.name");

    /**
     * <p>
     * <code>java.vm.specification.name</code> 프로퍼티의 값. 자바 가상머신 명세를 나타냄.
     * </p>
     * 
     * @since Java 1.2
     */
    public static final String JAVA_VM_SPECIFICATION_NAME = getSystemProperty("java.vm.specification.name");

    /**
     * <p>
     * <code>java.vm.specification.vendor</code> 프로퍼티의 값. 자바 가상머신 명세 벤더를 나타냄.
     * </p>
     * 
     * @since Java 1.2
     */
    public static final String JAVA_VM_SPECIFICATION_VENDOR = getSystemProperty("java.vm.specification.vendor");

    /**
     * <p>
     * <code>java.vm.specification.version</code> 프로퍼티의 값. 자바 가상머신 명세 버전을 나타냄.
     * </p>
     * 
     * @since Java 1.2
     */
    public static final String JAVA_VM_SPECIFICATION_VERSION = getSystemProperty("java.vm.specification.version");

    /**
     * <p>
     * <code>java.vm.vendor</code> 프로퍼티의 값. 자바 가상머신 구현 벤더를 나타냄.
     * </p>
     * 
     * @since Java 1.2
     */
    public static final String JAVA_VM_VENDOR = getSystemProperty("java.vm.vendor");

    /**
     * <p>
     * <code>java.vm.version</code> 프로퍼티의 값. 자바 가상머신 구현체 버전을 나타냄.
     * </p>
     * 
     * @since Java 1.2
     */
    public static final String JAVA_VM_VERSION = getSystemProperty("java.vm.version");

    /**
     * <p>
     * <code>line.separator</code> 프로퍼티의 값. 라인 구분자를 나타냄 (
     * <code>&quot;\n<&quot;</code> on UNIX).
     * </p>
     * 
     * @since Java 1.1
     */
    public static final String LINE_SEPARATOR = getSystemProperty("line.separator");

    /**
     * <p>
     * <code>os.arch</code> 프로퍼티의 값. 운영체제 아키텍쳐명
     * </p>
     * 
     * @since Java 1.1
     */
    public static final String OS_ARCH = getSystemProperty("os.arch");

    /**
     * <p>
     * <code>os.name</code> 프로퍼티의 값. 운영체제명
     * </p>
     * 
     * @since Java 1.1
     */
    public static final String OS_NAME = getSystemProperty("os.name");

    /**
     * <p>
     * <code>os.version</code> 프로퍼티의 값. 운영체제 버전
     * </p>
     * 
     * @since Java 1.1
     */
    public static final String OS_VERSION = getSystemProperty("os.version");

    /**
     * <p>
     * <code>path.separator</code> 프로퍼티의 값. 경로 구분자 (유닉스에서는
     * <code>&quot;:&quot;</code>).
     * </p>
     * 
     * @since Java 1.1
     */
    public static final String PATH_SEPARATOR = getSystemProperty("path.separator");

    /**
     * <p>
     * <code>user.country</code> 또는 <code>user.region</code> 프로퍼티의 값.
     * <code>GB</code>와 같은 사용자 지역코드를 의미.
     * </p>
     * 
     * @since 2.0
     * @since Java 1.2
     */
    public static final String USER_COUNTRY = (getSystemProperty("user.country") == null ? getSystemProperty("user.region")
        : getSystemProperty("user.country"));

    /**
     * <p>
     * <code>user.dir</code> 프로퍼티의 값. 사용자 작업 디렉토리를 의미
     * </p>
     * 
     * @since Java 1.1
     */
    public static final String USER_DIR = getSystemProperty("user.dir");

    /**
     * <p>
     * <code>user.home</code> 프로퍼티의 값. 사용자 홈 디렉토리를 의미.
     * </p>
     * 
     * @since Java 1.1
     */
    public static final String USER_HOME = getSystemProperty("user.home");

    /**
     * <p>
     * <code>user.language</code> 프로퍼티의 값. 사용자 언어코드를 의미(예 : en)
     * </p>
     * 
     * @since 2.0
     * @since Java 1.2
     */
    public static final String USER_LANGUAGE = getSystemProperty("user.language");

    /**
     * <p>
     * <code>user.name</code> 프로퍼티의 값. 사용자 계정명을 의미
     * </p>
     * 
     * @since Java 1.1
     */
    public static final String USER_NAME = getSystemProperty("user.name");

    // Java version
    // -----------------------------------------------------------------------
    // These MUST be declared after those above as they depend on the
    // values being set up

    /**
     * <p>
     * 자바(JDK) 버전을 얻음 : <code>float</code>.
     * </p>
     * <p>
     * 예제 반환 값 :
     * </p>
     * <ul>
     * <li><code>1.2f</code> -> JDK 1.2
     * <li><code>1.31f</code> -> JDK 1.3.1
     * </ul>
     * <p>
     * {@link #JAVA_VERSION}이 <code>null</code>이면 zero를 반환함.
     * </p>
     * 
     * @since 2.0
     */
    public static final float JAVA_VERSION_FLOAT = getJavaVersionAsFloat();

    /**
     * <p>
     * 자바(JDK) 버전을 얻음 : <code>int</code>.
     * </p>
     * <p>
     * 예제 반환 값 :
     * </p>
     * <ul>
     * <li><code>120</code> -> JDK 1.2
     * <li><code>131</code> -> JDK 1.3.1
     * </ul>
     * <p>
     * {@link #JAVA_VERSION}이 <code>null</code>이면 zero를 반환함.
     * </p>
     * 
     * @since 2.0
     */
    public static final int JAVA_VERSION_INT = getJavaVersionAsInt();

    // Java version checks
    // -----------------------------------------------------------------------
    // These MUST be declared after those above as they depend on the
    // values being set up

    /**
     * <p>
     * JDK가 1.1 (1.1.x 포함) 이상인지 여부.
     * </p>
     * <p>
     * {@link #JAVA_VERSION}이 <code>null</code>이면 false를 반환함.
     * </p>
     */
    public static final boolean IS_JAVA_1_1 = getJavaVersionMatches("1.1");

    /**
     * <p>
     * JDK가 1.2 (1.2.x 포함) 이상인지 여부.
     * </p>
     * <p>
     * {@link #JAVA_VERSION}이 <code>null</code>이면 false를 반환함.
     * </p>
     */
    public static final boolean IS_JAVA_1_2 = getJavaVersionMatches("1.2");

    /**
     * <p>
     * JDK가 1.3 (1.3.x 포함) 이상인지 여부.
     * </p>
     * <p>
     * {@link #JAVA_VERSION}이 <code>null</code>이면 false를 반환함.
     * </p>
     */
    public static final boolean IS_JAVA_1_3 = getJavaVersionMatches("1.3");

    /**
     * <p>
     * JDK가 1.4 (1.4.x 포함) 이상인지 여부.
     * </p>
     * <p>
     * {@link #JAVA_VERSION}이 <code>null</code>이면 false를 반환함.
     * </p>
     */
    public static final boolean IS_JAVA_1_4 = getJavaVersionMatches("1.4");

    /**
     * <p>
     * JDK가 1.5 (1.5.x 포함) 이상인지 여부.
     * </p>
     * <p>
     * {@link #JAVA_VERSION}이 <code>null</code>이면 false를 반환함.
     * </p>
     */
    public static final boolean IS_JAVA_1_5 = getJavaVersionMatches("1.5");

    // Operating system checks
    // -----------------------------------------------------------------------
    // These MUST be declared after those above as they depend on the
    // values being set up
    // OS names from http://www.vamphq.com/os.html
    // Selected ones included - please advise commons-dev@jakarta.apache.org
    // if you want another added or a mistake corrected

    /**
     * <p>
     * 시스템(OS)이 AIX인지 여부..
     * </p>
     * <p>
     * <code>OS_NAME</code>이 <code>null</code>이면 <code>false</code> 리턴함.
     * </p>
     * 
     * @since 2.0
     */
    public static final boolean IS_OS_AIX = getOSMatches("AIX");

    /**
     * <p>
     * 시스템(OS)이 HP-UX인지 여부..
     * </p>
     * <p>
     * <code>OS_NAME</code>이 <code>null</code>이면 <code>false</code> 리턴함.
     * </p>
     * 
     * @since 2.0
     */
    public static final boolean IS_OS_HP_UX = getOSMatches("HP-UX");

    /**
     * <p>
     * 시스템(OS)이 Irix인지 여부..
     * </p>
     * <p>
     * <code>OS_NAME</code>이 <code>null</code>이면 <code>false</code> 리턴함.
     * </p>
     * 
     * @since 2.0
     */
    public static final boolean IS_OS_IRIX = getOSMatches("Irix");

    /**
     * <p>
     * 시스템(OS)이 Linux인지 여부..
     * </p>
     * <p>
     * <code>OS_NAME</code>이 <code>null</code>이면 <code>false</code> 리턴함.
     * </p>
     * 
     * @since 2.0
     */
    public static final boolean IS_OS_LINUX = getOSMatches("Linux") || getOSMatches("LINUX");

    /**
     * <p>
     * 시스템(OS)이 Mac인지 여부..
     * </p>
     * <p>
     * <code>OS_NAME</code>이 <code>null</code>이면 <code>false</code> 리턴함.
     * </p>
     * 
     * @since 2.0
     */
    public static final boolean IS_OS_MAC = getOSMatches("Mac");

    /**
     * <p>
     * 시스템(OS)이 Mac OSX인지 여부..
     * </p>
     * <p>
     * <code>OS_NAME</code>이 <code>null</code>이면 <code>false</code> 리턴함.
     * </p>
     * 
     * @since 2.0
     */
    public static final boolean IS_OS_MAC_OSX = getOSMatches("Mac OS X");

    /**
     * <p>
     * 시스템(OS)이 OS/2인지 여부..
     * </p>
     * <p>
     * <code>OS_NAME</code>이 <code>null</code>이면 <code>false</code> 리턴함.
     * </p>
     * 
     * @since 2.0
     */
    public static final boolean IS_OS_OS2 = getOSMatches("OS/2");

    /**
     * <p>
     * 시스템(OS)이 Solaris인지 여부..
     * </p>
     * <p>
     * <code>OS_NAME</code>이 <code>null</code>이면 <code>false</code> 리턴함.
     * </p>
     * 
     * @since 2.0
     */
    public static final boolean IS_OS_SOLARIS = getOSMatches("Solaris");

    /**
     * <p>
     * 시스템(OS)이 SunOS인지 여부..
     * </p>
     * <p>
     * <code>OS_NAME</code>이 <code>null</code>이면 <code>false</code> 리턴함.
     * </p>
     * 
     * @since 2.0
     */
    public static final boolean IS_OS_SUN_OS = getOSMatches("SunOS");

    /**
     * <p>
     * 시스템(OS)이 Windows인지 여부..
     * </p>
     * <p>
     * <code>OS_NAME</code>이 <code>null</code>이면 <code>false</code> 리턴함.
     * </p>
     * 
     * @since 2.0
     */
    public static final boolean IS_OS_WINDOWS = getOSMatches("Windows");

    /**
     * <p>
     * 시스템(OS)이 Windows 2000인지 여부..
     * </p>
     * <p>
     * <code>OS_NAME</code>이 <code>null</code>이면 <code>false</code> 리턴함.
     * </p>
     * 
     * @since 2.0
     */
    public static final boolean IS_OS_WINDOWS_2000 = getOSMatches("Windows", "5.0");

    /**
     * <p>
     * 시스템(OS)이 Windows 95인지 여부..
     * </p>
     * <p>
     * <code>OS_NAME</code>이 <code>null</code>이면 <code>false</code> 리턴함.
     * </p>
     * 
     * @since 2.0
     */
    public static final boolean IS_OS_WINDOWS_95 = getOSMatches("Windows 9", "4.0");

    // JDK 1.2 running on Windows98 returns 'Windows 95', hence the above

    /**
     * <p>
     * 시스템(OS)이 Windows 98인지 여부..
     * </p>
     * <p>
     * <code>OS_NAME</code>이 <code>null</code>이면 <code>false</code> 리턴함.
     * </p>
     * 
     * @since 2.0
     */
    public static final boolean IS_OS_WINDOWS_98 = getOSMatches("Windows 9", "4.1");

    // JDK 1.2 running on Windows98 returns 'Windows 95', hence the above

    /**
     * <p>
     * 시스템(OS)이 Windows ME인지 여부..
     * </p>
     * <p>
     * <code>OS_NAME</code>이 <code>null</code>이면 <code>false</code> 리턴함.
     * </p>
     * 
     * @since 2.0
     */
    public static final boolean IS_OS_WINDOWS_ME = getOSMatches("Windows", "4.9");

    // JDK 1.2 running on WindowsME may return 'Windows 95', hence the above

    /**
     * <p>
     * 시스템(OS)이 Windows NT인지 여부..
     * </p>
     * <p>
     * <code>OS_NAME</code>이 <code>null</code>이면 <code>false</code> 리턴함.
     * </p>
     * 
     * @since 2.0
     */
    public static final boolean IS_OS_WINDOWS_NT = getOSMatches("Windows NT");

    // Windows 2000 returns 'Windows 2000' but may suffer from same JDK1.2
    // problem

    /**
     * <p>
     * 시스템(OS)이 Windows XP인지 여부..
     * </p>
     * <p>
     * <code>OS_NAME</code>이 <code>null</code>이면 <code>false</code> 리턴함.
     * </p>
     * 
     * @since 2.0
     */
    public static final boolean IS_OS_WINDOWS_XP = getOSMatches("Windows", "5.1");

    // Windows XP returns 'Windows 2000' just for fun...

    // -----------------------------------------------------------------------
    /**
     * <p>
     * SystemUtil instances should NOT be constructed in standard programming.
     * Instead, the class should be used as
     * <code>SystemUtil.FILE_SEPARATOR</code>.
     * </p>
     * <p>
     * This constructor is public to permit tools that require a JavaBean
     * instance to operate.
     * </p>
     */
    public SystemUtil() {
    }

    // -----------------------------------------------------------------------
    /**
     * <p>
     * 자바(JDK) 버전을 얻음 : <code>float</code>.
     * </p>
     * <p>
     * 예제 반환 값 :
     * </p>
     * <ul>
     * <li><code>1.2f</code> -> JDK 1.2
     * <li><code>1.31f</code> -> JDK 1.3.1
     * </ul>
     * <p>
     * {@link #JAVA_VERSION}이 <code>null</code>이면 zero를 반환함.
     * </p>
     * 
     * @return 자바 버전
     */
    private static float getJavaVersionAsFloat() {
        if(JAVA_VERSION == null) {
            return 0f;
        }
        String str = JAVA_VERSION.substring(0, 3);
        if(JAVA_VERSION.length() >= 5) {
            str = str + JAVA_VERSION.substring(4, 5);
        }
        return Float.parseFloat(str);
    }

    /**
     * <p>
     * 자바(JDK) 버전을 얻음 : <code>int</code>.
     * </p>
     * <p>
     * 예제 반환 값 :
     * </p>
     * <ul>
     * <li><code>120</code> -> JDK 1.2
     * <li><code>131</code> -> JDK 1.3.1
     * </ul>
     * <p>
     * {@link #JAVA_VERSION}이 <code>null</code>이면 zero를 반환함.
     * </p>
     * 
     * @return 자바 버전
     */
    private static int getJavaVersionAsInt() {
        if(JAVA_VERSION == null) {
            return 0;
        }
        String str = JAVA_VERSION.substring(0, 1);
        str = str + JAVA_VERSION.substring(2, 3);
        if(JAVA_VERSION.length() >= 5) {
            str = str + JAVA_VERSION.substring(4, 5);
        } else {
            str = str + "0";
        }
        return Integer.parseInt(str);
    }

    /**
     * <p>
     * 자바 버전이 지정한 값과 일치하는지를 판단함.
     * </p>
     * 
     * @param versionPrefix 비교할 자바버전 접두어
     * @return 일치하면 true, 아니면 false.
     */
    private static boolean getJavaVersionMatches(String versionPrefix) {
        if(JAVA_VERSION == null) {
            return false;
        }
        return JAVA_VERSION.startsWith(versionPrefix);
    }

    /**
     * <p>
     * OS가 지정한 값과 일치하는지를 판단함.
     * </p>
     * 
     * @param osNamePrefix 비교할 OS 접두어
     * @return 일치하면 true, 아니면 false.
     */
    private static boolean getOSMatches(String osNamePrefix) {
        if(OS_NAME == null) {
            return false;
        }
        return OS_NAME.startsWith(osNamePrefix);
    }

    /**
     * <p>
     * OS가 지정한 값과 일치하는지를 판단함.
     * </p>
     * 
     * @param osNamePrefix 비교할 OS 접두어
     * @param osVersionPrefix 비교할 OS 버전 접두어
     * @return 일치하면 true, 아니면 false.
     */
    private static boolean getOSMatches(String osNamePrefix, String osVersionPrefix) {
        if(OS_NAME == null || OS_VERSION == null) {
            return false;
        }
        return OS_NAME.startsWith(osNamePrefix) && OS_VERSION.startsWith(osVersionPrefix);
    }

    // -----------------------------------------------------------------------
    /**
     * <p>
     * 지정한 키에 대한 시스템 프로퍼티를 얻음. 해당 프로퍼티를 읽을 수 없다면 null 리턴함.
     * </p>
     * 
     * @param property 시스템 프로퍼티 키값
     * @return 지정한 키에 대한 시스템 프로퍼티
     */
    private static String getSystemProperty(String property) {
        try {
            return System.getProperty(property);
        } catch (SecurityException ex) {
            // we are not allowed to look at this property
            System.err.println("Caught a SecurityException reading the system property '" + property
                + "'; the SystemUtil property value will default to null.");
            return null;
        }
    }

    /**
     * <p>
     * 자바 버전이 지정한 값과 같거나 큰지의 여부를 검사함.
     * </p>
     * <p>
     * 예제
     * </p>
     * <ul>
     * <li>JDK 1.2 또는 그 이상인지를 검사하기 위해서 <code>1.2f</code>을 입력함</li>
     * <li>JDK 1.3.1 또는 그 이상인지를 검사하기 위해서 <code>1.31f</code>를 입력함</li>
     * </ul>
     * 
     * @param requiredVersion 검사하고자 하는 자바버전, 예를들면 13.1f
     * @return 지정한 버전과 같거나 크면 <code>true</code> 리턴.
     */
    public static boolean isJavaVersionAtLeast(float requiredVersion) {
        return (JAVA_VERSION_FLOAT >= requiredVersion);
    }

    /**
     * <p>
     * 자바 버전이 지정한 값과 같거나 큰지의 여부를 검사함.
     * </p>
     * <p>
     * 예제
     * </p>
     * <ul>
     * <li>JDK 1.2 또는 그 이상인지를 검사하기 위해서 <code>120</code>을 입력함</li>
     * <li>JDK 1.3.1 또는 그 이상인지를 검사하기 위해서 <code>131</code>를 입력함</li>
     * </ul>
     * 
     * @param requiredVersion 검사하고자 하는 자바버전, 예를들면 131
     * @return 지정한 버전과 같거나 크면 <code>true</code> 리턴.
     * @since 2.0
     */
    public static boolean isJavaVersionAtLeast(int requiredVersion) {
        return (JAVA_VERSION_INT >= requiredVersion);
    }
}
