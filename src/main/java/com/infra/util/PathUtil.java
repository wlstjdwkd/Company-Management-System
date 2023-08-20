package com.infra.util;

import java.io.File;

import com.infra.system.GlobalConst;

/**
 * <p>
 * 파일 경로와 관련된 다양한 함수를 지원하는 유틸 클래스.
 * </p> * 
 */
public final class PathUtil {

    /**
     * <p>
     * 지정한 경로를 현재 시스템에 맞는 경로로 변환한다.
     * </p>
     * 
     * @EXAMPLE // [Window] <br>
     *          PathUtil.toCurrentPath("/") = "C:/"; <br>
     *          PathUtil.toCurrentPath(".") = "C:/Devz/Tomcat_5.0/.";
     *          <p>
     *          // [Unix] <br>
     *          PathUtil.toCurrentPath("/") = "/"; <br>
     *          PathUtil.toCurrentPath(".") = "/Devz/Tomcat_5.0/."; <br>
     * @param path 대상 파일 경로
     * @return 현재 시스템에 맞는 경로
     */
    public static String toCurrentPath(String path) {

        String cPath = path;

        if(SystemUtil.IS_OS_WINDOWS) {
            cPath = toWindowsPath(cPath);
        } else {
            cPath = toUnixPath(cPath);
        }

        File file1 = new File(cPath);
        File file2 = new File(file1.getAbsolutePath());

        if(file2.exists()) {
            cPath = file2.getAbsolutePath();
        }

        file1 = null;

        return cPath.trim();
    }

    /**
     * 현재 시스템에 해당하는 경로 구분자로 변경
     * 
     * @param mixPath
     * @return
     */
    public static String replacePath(String mixPath) {

        return StringUtil.replace(mixPath, GlobalConst.REPLACE_FILE_SEPARATOR,
        		GlobalConst.FILE_SEPARATOR);
    }

    /**
     * <p>
     * 지정한 경로를 Unix 시스템에 맞는 경로로 변환한다.
     * </p>
     * 
     * @EXAMPLE PathUtil.toUnixPath("/") = "/"; <br>
     *          PathUtil.toUnixPath(".") = "./";
     * @param inPath 대상 파일 경로
     * @return 변환된 Unix 경로.
     */
    public static String toUnixPath(String inPath) {

        StringBuffer path = new StringBuffer();
        int index = -1;

        inPath = inPath.trim();
        index = inPath.indexOf(":\\"); // nores
        inPath = inPath.replace('\\', '/');
        if(index > -1) {
            // path.append("/"); // nores
            // path.append(inPath.substring(0, index));
            path.append('/');
            path.append(inPath.substring(index + 2));
        } else {
            path.append(inPath);
        }

        return path.toString();
    }

    /**
     * <p>
     * 지정한 경로를 Windows 시스템에 맞는 경로로 변환한다.
     * </p>
     * 
     * @EXAMPLE PathUtil.toWindowsPath("/") = "\\"; <br>
     *          PathUtil.toWindowsPath(".") = ".\\";
     * @param path 대상 파일 경로
     * @return 변환된 Windows 경로.
     */
    public static String toWindowsPath(String path) {

        String winPath = path;
        int index = winPath.indexOf("//"); // nores

        if(index > -1) {
            winPath = winPath.substring(0, index) + ":\\" // nores
                + winPath.substring(index + 2);
        }
        index = winPath.indexOf(':');
        if(index == 1) {
            winPath = winPath.substring(0, 1).toUpperCase() + winPath.substring(1);
        }
        winPath = winPath.replace('/', '\\');

        return winPath;
    }

    public static String dirName(String dirname, String separator) {
        int i = dirname.lastIndexOf(separator);
        return (i >= 0 ? dirname.substring(0, i) : dirname);
    }

    /**
     * <p>
     * 지정 경로에서 디렉토리 경로를 얻음.
     * </p>
     * 
     * @EXAMPLE PathUtil.dirName("/usr") = "usr"; <br>
     *          PathUtil.dirName("/usr/local/tomcat") = "tomcat";
     * @param dirname 전체 경로.
     * @return 디렉토리까지의 경로.
     */
    public static String dirName(String dirname) {

        return dirName(dirname, File.separator);
    }

    public static String fileName(String filename, String separator) {
        int i = filename.lastIndexOf(separator);
        return (i >= 0 ? filename.substring(i + 1) : filename);
    }

    /**
     * <p>
     * 지정 경로에서 파일 구분자를 제거한 파일명을 얻음.
     * </p>
     * 
     * @EXAMPLE PathUtil.fileName("/usr/system.conf") = "system.conf"; <br>
     *          PathUtil.fileName("/usr/local/tomcat/index.html") =
     *          "index.html";
     * @param filename 파일명.
     * @return 파일명.
     */
    public static String fileName(String filename) {

        return fileName(filename, File.separator);
    }

    /**
     * <p>
     * 지정 경로에서 확장자를 제외한 파일명을 얻음.
     * </p>
     * 
     * @EXAMPLE PathUtil.baseName("/usr/system.conf") = "system"; <br>
     *          PathUtil.baseName("/usr/local/tomcat/index.html") = "index";
     * @param filename 파일명.
     * @return 확장자를 제외한 파일명.
     */
    public static String baseName(String filename) {
        return baseName(filename, extension(filename));
    }

    /**
     * <p>
     * 지정 경로에서 확장자를 제외한 파일명을 얻음.
     * </p>
     * 
     * @EXAMPLE PathUtil.baseName("/usr/system.conf", "conf") = "system"; <br>
     *          PathUtil.baseName("/usr/local/tomcat/index.html", "html") =
     *          "index";
     * @param filename 파일명.
     * @param suffix 확장자.
     * @return 파일명.
     */
    public static String baseName(String filename, String suffix) {
        int i = filename.lastIndexOf(File.separator) + 1;
        int lastDot = ((suffix != null) && (suffix.length() > 0)) ? filename.lastIndexOf(suffix)
            : -1;

        if(lastDot >= 0) {
            return filename.substring(i, lastDot - 1);
        } else if(i > 0) {
            return filename.substring(i - 1);
        } else {
            return filename; // else returns all (no path and no extension)
        }
    }

    /**
     * <p>
     * 지정 경로에서 파일 확장자를 얻음.
     * </p>
     * 
     * @EXAMPLE PathUtil.extension("/usr/system.conf") = "conf"; <br>
     *          PathUtil.extension("/usr/local/tomcat/index.html") = "html";
     * @param filename 파일명.
     * @return 확장자.
     */
    public static String extension(String filename) {
        int lastDot = filename.lastIndexOf('.');

        if(lastDot >= 0) {
            return filename.substring(lastDot + 1);
        } else {
            return "";
        }
    }

    /**
     * <p>
     * 지정 경로에서 최종 폴더명을 얻음.
     * </p>
     * 
     * @EXAMPLE PathUtil.extension("/usr/system.conf") = "usr"; <br>
     *          PathUtil.extension("/usr/local/tomcat/index.html") = "tomcat";
     * @param filename 파일명.
     * @return 확장자.
     */
    public static String lastFolderName(String path, String separator) {

        int lastSlashIndex = path.lastIndexOf(separator);
        if(lastSlashIndex == -1) {
            return path;
        }

        String tempUri = path.substring(0, lastSlashIndex);

        lastSlashIndex = tempUri.lastIndexOf(separator);

        return lastSlashIndex == -1 ? tempUri : tempUri.substring(lastSlashIndex + 1);
    }

    public static String lastFolderName(String path) {

        return lastFolderName(path, File.separator);
    }
}
