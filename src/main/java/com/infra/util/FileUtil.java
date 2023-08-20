package com.infra.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.nio.channels.FileChannel;
import java.util.Arrays;
import java.util.Comparator;

import javax.activation.MimetypesFileTypeMap;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * <p>
 * 파일과 관련된 다양한 함수를 지원하는 유틸 클래스.
 * </p>
 *
 */
public final class FileUtil {

	private static final Logger logger = LoggerFactory.getLogger(FileUtil.class);

    // ---------------------------------------------------------------- misc
    // utils

	/**
	 * 파일 확장자명을 가져온다.
	 **/
	public static String getExtension(String fname){

		if(fname == null || fname.isEmpty() || fname.equals("")){
			return null;
		}
		int point = fname.lastIndexOf('.');
		if( point>0 ){
			String type = fname.substring(point+1, fname.length());
			return type.toLowerCase();
		}
		else{
			return null;
		}
	}
    /**
     * 현재 작업 디렉토리를 문자열로 얻는다.<br>
     * System.getProperty("user.dir")의 결과와 같다.
     *
     * @return 현재 작업 디렉토리
     */
    public static String getWorkingDir() {
    	String userDir = System.getProperty("user.dir");
    	userDir = userDir.replaceAll("/", "");
    	userDir = userDir.replaceAll(".", "");
    	userDir = userDir.replaceAll("&", "");
        return userDir;
    }

    /**
     * 현재 작업 디렉토리를 파일객체로 얻는다.<br>
     * System.getProperty("user.dir")의 결과와 같다.
     *
     * @return 현재 작업 디렉토리
     */
    public static File getWorkingDirFile() {
        return new File(getWorkingDir());
    }

    /**
     * 파일 길이를 얻는다.
     *
     * @param fileName 파일 전체경로
     * @return 대상 파일의 길이
     */
    public static long getFileSize(String fileName) {
        return getFileSize(new File(fileName));
    }

    /**
     * 파일 길이를 얻는다.
     *
     * @param file 대상 파일 객체
     * @return 대상 파일의 길이
     */
    public static long getFileSize(File file) {
        return file.length();
    }

    /**
     * 대상 파일이 가리키는 파일이 동일한지를 판단한다.
     *
     * @param file1 대상 파일 전체경로 1
     * @param file2 대상 파일 전체경로 2
     * @return 같으면 true.
     */
    public static boolean equals(String file1, String file2) {
        return equals(new File(file1), new File(file2));
    }

    /**
     * 대상 파일이 가리키는 파일이 동일한지를 판단한다.
     *
     * @param file1 대상 파일 객체 1
     * @param file2 대상 파일 객체 2
     * @return 같으면 true.
     */
    public static boolean equals(File file1, File file2) {

        File _file1 = null;
        File _file2 = null;

        try {
            _file1 = file1.getCanonicalFile();
            _file2 = file2.getCanonicalFile();
        } catch (IOException e) {
            return false;
        }
        return _file1.equals(_file2);
    }

    /**
     * 새 디렉토리를 생성한다. 상위디렉토리가 없으면 생성한다.
     *
     * @param dirs 생성할 디렉토리 전체경로
     * @return 성공적으로 생성했다면 true.
     */
    public static boolean mkdirs(String dirs) {
        return mkdirs(new File(dirs));
    }

    /**
     * 새 디렉토리를 생성한다. 상위디렉토리가 없으면 생성한다.
     *
     * @param dirs 생성할 디렉토리 파일 객체
     * @return 성공적으로 생성했다면 true.
     */
    public static boolean mkdirs(File dirs) {
    	dirs.setExecutable(true);
    	dirs.setReadable(true);
    	dirs.setWritable(true);
        return dirs.mkdirs();
    }

    /**
     * 새 디렉토리를 생성한다.
     *
     * @param dir 생성할 디렉토리 전체경로
     * @return 성공적으로 생성했다면 true.
     */
    public static boolean mkdir(String dir) {
        return mkdir(new File(dir));
    }

    /**
     * 새 디렉토리를 생성한다.
     *
     * @param dir 생성할 디렉토리 파일 객체
     * @return 성공적으로 생성했다면 true.
     */
    public static boolean mkdir(File dir) {
    	dir.setExecutable(true);
    	dir.setReadable(true);
    	dir.setWritable(true);
        return dir.mkdir();
    }

    // ---------------------------------------------------------------- file
    // copy vairants

    /**
     * 파일 조작에 사용되는 기본 버퍼 사이즈 (32KB).
     */
    public static final int FILE_BUFFER_SIZE = 32 * 1024;

    /**
     * 파일을 복사한다. 기존에 존재한다면 덮어쓴다.
     *
     * @param fileIn 원본 파일 전체경로
     * @param fileOut 목적 파일 전체경로
     * @return 파일 복사가 성공했다면 true.
     * @see #copy(File, File, int, boolean)
     */
    public static boolean copy(String fileIn, String fileOut) {
        return copy(new File(fileIn), new File(fileOut), FILE_BUFFER_SIZE, true);
    }

    /**
     * 파일을 복사한다. 기존에 존재한다면 덮어씌우지 않는다.
     *
     * @param fileIn 원본 파일 전체경로
     * @param fileOut 목적 파일 전체경로
     * @return 파일 복사가 성공했다면 true.
     * @see #copy(File, File, int, boolean)
     */
    public static boolean copySafe(String fileIn, String fileOut) {
        return copy(new File(fileIn), new File(fileOut), FILE_BUFFER_SIZE, false);
    }

    /**
     * 파일을 지정한 버퍼사이즈 단위로 복사한다. 기존에 존재한다면 덮어쓴다.
     *
     * @param fileIn 원본 파일 전체경로
     * @param fileOut 목적 파일 전체경로
     * @param bufsize 복사에 사용될 버퍼사이즈 길이
     * @return 파일 복사가 성공했다면 true.
     * @see #copy(File, File, int, boolean)
     */
    public static boolean copy(String fileIn, String fileOut, int bufsize) {
        return copy(new File(fileIn), new File(fileOut), bufsize, true);
    }

    /**
     * 파일을 복사한다. 기존에 존재한다면 덮어씌우지 않는다.
     *
     * @param fileIn 원본 파일 전체경로
     * @param fileOut 목적 파일 전체경로
     * @param bufsize 복사에 사용될 버퍼사이즈 길이
     * @return 파일 복사가 성공했다면 true.
     * @see #copy(File, File, int, boolean)
     */
    public static boolean copySafe(String fileIn, String fileOut, int bufsize) {
        return copy(new File(fileIn), new File(fileOut), bufsize, false);
    }

    /**
     * 파일을 지정한 버퍼사이즈 단위로 복사한다. 기존에 존재한다면 덮어쓴다.
     *
     * @param fileIn 원본 파일 객체
     * @param fileOut 목적 파일 객체
     * @return 파일 복사가 성공했다면 true.
     * @see #copy(File, File, int, boolean)
     */
    public static boolean copy(File fileIn, File fileOut) {
        return copy(fileIn, fileOut, FILE_BUFFER_SIZE, true);
    }

    /**
     * 파일을 복사한다. 기존에 존재한다면 덮어씌우지 않는다.
     *
     * @param fileIn 원본 파일 객체
     * @param fileOut 목적 파일 객체
     * @return 파일 복사가 성공했다면 true.
     * @see #copy(File, File, int, boolean)
     */
    public static boolean copySafe(File fileIn, File fileOut) {
        return copy(fileIn, fileOut, FILE_BUFFER_SIZE, false);
    }

    /**
     * 파일을 지정한 버퍼사이즈 단위로 복사한다. 기존에 존재한다면 덮어쓴다.
     *
     * @param fileIn 원본 파일 객체
     * @param fileOut 목적 파일 객체
     * @param bufsize 복사에 사용될 버퍼사이즈 길이
     * @return 파일 복사가 성공했다면 true.
     * @see #copy(File, File, int, boolean)
     */
    public static boolean copy(File fileIn, File fileOut, int bufsize) {
        return copy(fileIn, fileOut, bufsize, true);
    }

    /**
     * 파일을 복사한다. 기존에 존재한다면 덮어씌우지 않는다.
     *
     * @param fileIn 원본 파일 객체
     * @param fileOut 목적 파일 객체
     * @param bufsize 복사에 사용될 버퍼사이즈 길이
     * @return 파일 복사가 성공했다면 true.
     * @see #copy(File, File, int, boolean)
     */
    public static boolean copySafe(File fileIn, File fileOut, int bufsize) {
        return copy(fileIn, fileOut, bufsize, false);
    }

    // ---------------------------------------------------------------- file
    // copy

    /**
     * 파일을 지정한 버퍼사이즈 단위로 복사한다.
     *
     * @param fileIn 원본 파일 전체경로
     * @param fileOut 목적 파일 전체경로
     * @param bufsize 복사에 사용될 버퍼사이즈 길이
     * @param overwrite 기존에 존재한다면 덮어씌울지 여부
     * @return 파일 복사가 성공했다면 true.
     * @see #copy(File, File, int, boolean)
     */
    public static boolean copy(String fileIn, String fileOut, int bufsize, boolean overwrite) {
        return copy(new File(fileIn), new File(fileOut), bufsize, overwrite);
    }

    /**
     * 파일을 지정한 버퍼사이즈 단위로 복사한다.
     *
     * @param fileIn 원본 파일 객체
     * @param fileOut 목적 파일 객체
     * @param bufsize 복사에 사용될 버퍼사이즈 길이
     * @param overwrite 기존에 존재한다면 덮어씌울지 여부
     * @return 파일 복사가 성공했다면 true.
     * @see #copy(File, File, int, boolean)
     */
    public static boolean copy(File fileIn, File fileOut, int bufsize, boolean overwrite) {

        // check if source exists
        if(fileIn.exists() == false) {
            return false;
        }

        // check if source is a file
        if(fileIn.isFile() == false) {
            return false;
        }

        // if destination is folder, make it to be a file.
        if(fileOut.isDirectory() == true) {
            fileOut = new File(fileOut.getPath() + File.separator + fileIn.getName());
        }

        if(overwrite == false) {
            if(fileOut.exists() == true) {
                return false;
            }
        } else {
            if(fileOut.exists()) { // if overwriting, check if destination is
                // the same file as source
                try {
                    if(fileIn.getCanonicalFile().equals(fileOut.getCanonicalFile()) == true) {
                        return true;
                    }
                } catch (IOException ioex) {
                    return false;
                }
            }
        }
        return copyFile(fileIn, fileOut, bufsize);
    }

    // ---------------------------------------------------------------- copy
    // file

    /**
     * 파일을 기본 버퍼사이즈 단위로 복사한다. 파일 존재여부는 체크하지 않음.
     *
     * @param fileIn 원본 파일 전체경로
     * @param fileOut 목적 파일 전체경로
     * @return 파일 복사가 성공했다면 true.
     */
    public static boolean copyFile(String fileIn, String fileOut) {
        return copyFile(new File(fileIn), new File(fileOut), FILE_BUFFER_SIZE);
    }

    /**
     * 파일을 기본 버퍼사이즈 단위로 복사한다. 파일 존재여부는 체크하지 않음.
     *
     * @param fileIn 원본 파일 객체
     * @param fileOut 목적 파일 객체
     * @return 파일 복사가 성공했다면 true.
     */
    public static boolean copyFile(File fileIn, File fileOut) {
        return copyFile(fileIn, fileOut, FILE_BUFFER_SIZE);
    }

    /**
     * 파일을 지정 버퍼사이즈 단위로 복사한다. 파일 존재여부는 체크하지 않음.
     *
     * @param fileIn 원본 파일 전체경로
     * @param fileOut 목적 파일 전체경로
     * @param bufsize 버퍼 사이즈
     * @return 파일 복사가 성공했다면 true.
     */
    public static boolean copyFile(String fileIn, String fileOut, int bufsize) {
        return copyFile(new File(fileIn), new File(fileOut), bufsize);
    }

    /**
     * 파일을 지정 버퍼사이즈 단위로 복사한다. 파일 존재여부는 체크하지 않음.
     *
     * @param fileIn 원본 파일 객체
     * @param fileOut 목적 파일 객체
     * @param bufsize 버퍼 사이즈
     * @return 파일 복사가 성공했다면 true.
     */
    public static boolean copyFile(File fileIn, File fileOut, int bufsize) {

        FileChannel sourceChannel = null;
        FileChannel destinationChannel = null;
        boolean result = false;
        FileInputStream in = null;
        FileOutputStream out = null;
        try {
        	in = new FileInputStream(fileIn);
        	out = new FileOutputStream(fileOut);
            sourceChannel = in.getChannel();
            destinationChannel = out.getChannel();
            sourceChannel.transferTo(0, sourceChannel.size(), destinationChannel);
            result = true;
        } catch (IOException ioex) {
        	logger.error("", ioex);
        } finally {
            if(sourceChannel != null) {
                try {
                    sourceChannel.close();
                } catch (IOException ioex) {
                	logger.error("", ioex);
                }
            }
            if(destinationChannel != null) {
                try {
                    destinationChannel.close();
                } catch (IOException ioex) {
                	logger.error("", ioex);
                }
            }
            if(in != null) {
            	try {
            		in.close();
            	} catch (IOException ioex) {
            		logger.error("", ioex);
            	}
            }
            if(out != null) {
            	try {
            		out.close();
            	} catch (IOException ioex) {
            		logger.error("", ioex);
            	}
            }
        }
        return result;

    }

    // ---------------------------------------------------------------- file
    // move variants
    /**
     * @see #move(File, File, boolean) move(File, File, boolean)
     */
    public static boolean move(String fileNameIn, String fileNameOut) {
        return move(new File(fileNameIn), new File(fileNameOut), true);
    }

    /**
     * @see #move(File, File, boolean) move(File, File, boolean)
     */
    public static boolean moveSafe(String fileNameIn, String fileNameOut) {
        return move(new File(fileNameIn), new File(fileNameOut), false);
    }

    /**
     * @see #move(File, File, boolean) move(File, File, boolean)
     */
    public static boolean move(File fileIn, File fileOut) {
        return move(fileIn, fileOut, true);
    }

    /**
     * @see #move(File, File, boolean) move(File, File, boolean)
     */
    public static boolean moveSafe(File fileIn, File fileOut) {
        return move(fileIn, fileOut, false);
    }

    // ---------------------------------------------------------------- file
    // move
    /**
     * 파일을 지정한 디렉토리로 이동한다.<br>
     * 목적 파일이 디렉토리라면 같은 파일명으로 이동한다.<br>
     * 목적 파일이 파일이라면 false 리턴.
     *
     * @param fileNameIn 원본 파일 전체경로
     * @param fileNameOut 목적 파일 전체경로
     * @param overwrite 기존에 존재한다면 덮어씌울지 여부
     * @return 파일 이동이 성공했다면 true.
     * @see #move(File, File, boolean)
     */
    public static boolean move(String fileNameIn, String fileNameOut, boolean overwrite) {
        return move(new File(fileNameIn), new File(fileNameOut), overwrite);
    }

    /**
     * 파일을 지정한 디렉토리로 이동한다.<br>
     * 목적 파일이 디렉토리라면 같은 파일명으로 이동한다.<br>
     * 목적 파일이 파일이라면 false 리턴.
     *
     * @param fileIn 원본 파일 객체
     * @param fileOut 목적 파일 객체
     * @param overwrite 기존에 존재한다면 덮어씌울지 여부
     * @return 파일 이동이 성공했다면 true.
     * @see #move(File, File, boolean)
     */
    public static boolean move(File fileIn, File fileOut, boolean overwrite) {
        // check if source exists
        if(fileIn.exists() == false) {
            return false;
        }

        // check if source is a file
        if(fileIn.isFile() == false) {
            return false;
        }

        // if destination is folder, make it to be a file.
        if(fileOut.isDirectory() == true) {
            fileOut = new File(fileOut.getPath() + File.separator + fileIn.getName());
        }

        if(overwrite == false) {
            if(fileOut.exists() == true) {
                return false;
            }
        } else {
            if(fileOut.exists()) { // if overwriting, check if destination is
                // the same file as source
                try {
                    if(fileIn.getCanonicalFile().equals(fileOut.getCanonicalFile()) == true) {
                        return true;
                    } else {
                        fileOut.delete(); // delete destination
                    }
                } catch (IOException ioex) {
                    return false;
                }
            }
        }

        return fileIn.renameTo(fileOut);
    }

    // ---------------------------------------------------------------- move
    // file

    /**
     * @see #moveFile(File, File) moveFile(File, File)
     */
    public static boolean moveFile(String src, String dest) {
        return new File(src).renameTo(new File(dest));
    }

    /**
     * 파일을 이동하거나 이름을 변경한다.
     *
     * @param src 원본 파일
     * @param dest 목적 파일
     * @return 성공하면 true.
     */
    public static boolean moveFile(File src, File dest) {
        return src.renameTo(dest);
    }

    // ----------------------------------------------------------------
    // move/copy directory
    /**
     * @see #moveDir(File, File) moveDir(File, File)
     */
    public static boolean moveDir(String fileIn, String fileOut) {
        return moveDir(new File(fileIn), new File(fileOut));
    }

    /**
     * 원본 디렉토리를 목적 디렉토리로 이동한다.<br>
     * 원본 디렉토리가 없다면 false를 리턴한다.<br>
     * 원본 파일과 목적 디렉토리 같다면 true를 리턴한다.<br>
     * 원본 디렉토리가 파일이거나 목적 디렉토리가 존재하지 않으면 false를 리턴한다.
     *
     * @param fileIn 원본 디렉토리
     * @param fileOut 목적 디렉토리
     * @return 성공하면 true.
     */
    public static boolean moveDir(File fileIn, File fileOut) {
        // check if source exists
        if(fileIn.exists() == false) {
            return false;
        }

        // check if source is a directory
        if(fileIn.isDirectory() == false) {
            return false;
        }

        // check if destination exists
        if(fileOut.exists() == true) {
            try {
                if(fileIn.getCanonicalFile().equals(fileOut.getCanonicalFile()) == true) {
                    return true;
                } else {
                    return false;
                }
            } catch (IOException ioex) {
                return false;
            }
        }

        return fileIn.renameTo(fileOut);
    }

    /**
     * @see #copyDir(File, File) copyDir(File, File)
     */
    public static boolean copyDir(String srcDir, String dstDir) {
        return copyDir(new File(srcDir), new File(dstDir));
    }

    /**
     * 원본 디렉토리 하위의 모든 파일을 목적 디렉토리로 복사한다.<br>
     * 목적 디렉토리가 존재하지 않으면 새로 생성한다.
     *
     * @param srcDir 원본 디렉토리
     * @param dstDir 목적 디렉토리
     * @return 성공하면 true.
     */
    public static boolean copyDir(File srcDir, File dstDir) {
        if(srcDir.isDirectory()) {
            if(!dstDir.exists()) {
                dstDir.mkdir();
            }
            String[] files = srcDir.list();
            for(int i = 0 ; i < files.length ; i++) {
                if(copyDir(new File(srcDir, files[i]), new File(dstDir, files[i])) == false) {
                    return false;
                }
            }
            return true;
        }
        return copyFile(srcDir, dstDir);
    }

    // ---------------------------------------------------------------- delete
    // file/dir

    /**
     * 지정한 파일(또는 빈 디렉토리)을 삭제한다.
     *
     * @param fileName 삭제할 파일 전체경로
     */
    public static boolean delete(String fileName) {
        return delete(new File(fileName));
    }

    /**
     * 지정한 파일(또는 빈 디렉토리)을 삭제한다.
     *
     * @param fileIn 삭제할 파일 객체
     */
    public static boolean delete(File fileIn) {

        if(fileIn != null) {
            return fileIn.delete();
        }

        return false;
    }

    /**
     * 지정한 디렉토리를 하위디렉토리를 포함해 모두 삭제한다.
     *
     * @param pathName 삭제할 디렉토리 전체경로
     */
    public static boolean deleteDir(String pathName) {
        return deleteDir(new File(pathName));
    }

    /**
     * 지정한 디렉토리를 하위디렉토리를 포함해 모두 삭제한다.<br>
     * 삭제에 실패한다면 함수는 실행을 중단하며, false를 리턴한다.
     *
     * @param path 삭제할 디렉토리 객체
     * @return 삭제 성공시 <code>true</code>.
     */
    public static boolean deleteDir(File path) {

        if(path == null) {
            return false;
        }

        if(path.isDirectory()) {
            File[] files = path.listFiles();
            for(int i = 0 ; i < files.length ; i++) {
                if(deleteDir(files[i]) == false) {
                    return false;
                }
            }
        }
        return path.delete();
    }

    // ---------------------------------------------------------------- string
    // utilities

    /**
     * 파일내의 문자열을 조작하는데 필요한 기본 버퍼 사이즈 (32KB).
     */
    public static final int STRING_BUFFER_SIZE = 32 * 1024;

    /**
     * 지정한 파일의 내용을 시스템 인코딩을 사용해 문자열로 얻는다.
     *
     * @param fileName 대상 파일 전체경로
     * @return 파일의 내용
     * @exception IOException
     */
    public static String readString(String fileName) throws IOException {
		if(Validate.isNotEmpty(fileName)) {
    		fileName = fileName.replaceAll("/", "");
    		fileName = fileName.replaceAll(".", "");
    		fileName = fileName.replaceAll("&", "");
    	}
        return readString(new File(fileName), STRING_BUFFER_SIZE);
    }

    /**
     * 지정한 파일의 내용을 버퍼단위로 시스템 인코딩을 사용해 문자열로 얻는다.
     *
     * @param fileName 대상 파일 전체경로
     * @param bufferSize 버퍼 사이즈
     * @return 파일의 내용
     * @exception IOException
     */
    public static String readString(String fileName, int bufferSize) throws IOException {
    	if(Validate.isNotEmpty(fileName)) {
    		fileName = fileName.replaceAll("/", "");
    		fileName = fileName.replaceAll(".", "");
    		fileName = fileName.replaceAll("&", "");
    	}
        return readString(new File(fileName), bufferSize);
    }

    /**
     * 지정한 파일의 내용을 시스템 인코딩을 사용해 문자열로 얻는다.
     *
     * @param file 파일 객체
     * @return 파일의 내용
     * @exception IOException
     */
    public static String readString(File file) throws IOException {
        return readString(file, STRING_BUFFER_SIZE);
    }

    /**
     * 지정한 파일의 내용을 버퍼단위로 시스템 인코딩을 사용해 문자열로 얻는다.
     *
     * @param file 파일 객체
     * @param bufferSize 버퍼 사이즈
     * @return 파일의 내용
     * @exception IOException
     */
    public static String readString(File file, int bufferSize) throws IOException {
        long fileLen = file.length();
        if(fileLen <= 0L) {
            if(file.exists() == true) {
                return ""; // empty file
            }
            return null; // all other file len problems
        }
        if(fileLen > Integer.MAX_VALUE) { // max String size
            throw new IOException("File too big for loading into a String!");
        }

        FileReader fr = null;
        BufferedReader brin = null;
        char[] buf = null;
        try {
            fr = new FileReader(file);
            brin = new BufferedReader(fr, bufferSize);
            int length = (int) fileLen;
            buf = new char[length];
            brin.read(buf, 0, length);
        } finally {
            if(brin != null) {
                brin.close();
                //fr = null;
            }
            if(fr != null) {
                fr.close();
            }
        }
        return new String(buf);
    }

    /**
     * 지정한 문자열을 시스템 인코딩을 이용해 파일에 기록한다.
     *
     * @param fileName 대상 파일명 전체경로
     * @param s 기록할 문자열
     * @exception IOException
     */
    public static void writeString(String fileName, String s) throws IOException {
    	if(Validate.isNotEmpty(fileName)) {
    		fileName = fileName.replaceAll("/", "");
    		fileName = fileName.replaceAll(".", "");
    		fileName = fileName.replaceAll("&", "");
    	}
        writeString(new File(fileName), s, STRING_BUFFER_SIZE);
    }

    /**
     * 지정한 문자열을 시스템 인코딩을 이용해 버퍼단위로 파일에 기록한다.
     *
     * @param fileName 대상 파일명 전체경로
     * @param s 기록할 문자열
     * @param bufferSize 버퍼 사이즈
     * @exception IOException
     */
    public static void writeString(String fileName, String s, int bufferSize) throws IOException {
    	if(Validate.isNotEmpty(fileName)) {
    		fileName = fileName.replaceAll("/", "");
    		fileName = fileName.replaceAll(".", "");
    		fileName = fileName.replaceAll("&", "");
    	}
        writeString(new File(fileName), s, bufferSize);
    }

    /**
     * 지정한 문자열을 시스템 인코딩을 이용해 파일에 기록한다.
     *
     * @param file 대상 파일 객체
     * @param s 기록할 문자열
     * @exception IOException
     */
    public static void writeString(File file, String s) throws IOException {
        writeString(file, s, STRING_BUFFER_SIZE);
    }

    /**
     * 지정한 문자열을 시스템 인코딩을 이용해 버퍼단위로 파일에 기록한다.
     *
     * @param file 대상 파일 객체
     * @param s 기록할 문자열
     * @param bufferSize 버퍼 사이즈
     * @exception IOException
     */
    public static void writeString(File file, String s, int bufferSize) throws IOException {
        FileWriter fw = null;
        BufferedWriter out = null;
        if(s == null) {
            return;
        }
        try {
            fw = new FileWriter(file);
            out = new BufferedWriter(fw, bufferSize);
            out.write(s);
        } finally {
            if(out != null) {
                out.close();
                //fw = null;
            }
            if(fw != null) {
                fw.close();
            }
        }
    }

    // ---------------------------------------------------------------- unicode
    // string utilities

    /**
     * 파일의 내용을 지정한 인코딩을 통해 읽는다.
     *
     * @param fileName 대상 파일 전체경로
     * @param encoding 인코딩
     * @return 파일의 내용
     * @exception IOException
     */
    public static String readString(String fileName, String encoding) throws IOException {
    	if(Validate.isNotEmpty(fileName)) {
    		fileName = fileName.replaceAll("/", "");
    		fileName = fileName.replaceAll(".", "");
    		fileName = fileName.replaceAll("&", "");
    	}
        return readString(new File(fileName), STRING_BUFFER_SIZE, encoding);
    }

    /**
     * 파일의 내용을 지정한 인코딩을 통해 버퍼단위로 읽는다.
     *
     * @param fileName 대상 파일 전체경로
     * @param bufferSize 버퍼 사이즈
     * @param encoding 인코딩
     * @return 파일의 내용
     * @exception IOException
     */
    public static String readString(String fileName, int bufferSize, String encoding) throws IOException {
    	if(Validate.isNotEmpty(fileName)) {
    		fileName = fileName.replaceAll("/", "");
    		fileName = fileName.replaceAll(".", "");
    		fileName = fileName.replaceAll("&", "");
    	}
        return readString(new File(fileName), bufferSize, encoding);
    }

    /**
     * 파일의 내용을 지정한 인코딩을 통해 읽는다.
     *
     * @param file 대상 파일 객체
     * @param encoding 인코딩
     * @return 파일의 내용
     * @exception IOException
     */
    public static String readString(File file, String encoding) throws IOException {
        return readString(file, STRING_BUFFER_SIZE, encoding);
    }

    /**
     * 파일의 내용을 지정한 인코딩을 통해 버퍼단위로 읽는다.
     *
     * @param file 대상 파일 객체
     * @param bufferSize 버퍼 사이즈
     * @param encoding 인코딩
     * @return 파일의 내용
     * @exception IOException
     */
    public static String readString(File file, int bufferSize, String encoding) throws IOException {
        long fileLen = file.length();
        if(fileLen <= 0L) {
            if(file.exists() == true) {
                return ""; // empty file
            }
            return null; // all other file len problems
        }
        if(fileLen > Integer.MAX_VALUE) { // max String size
            throw new IOException("File too big for loading into a String!");
        }

        FileInputStream fis = null;
        InputStreamReader isr = null;
        BufferedReader brin = null;

        int length = (int) fileLen;
        char[] buf = null;
        int realSize = 0;
        try {
            fis = new FileInputStream(file);
            isr = new InputStreamReader(fis, encoding);
            brin = new BufferedReader(isr, bufferSize);
            buf = new char[length]; // this is the weakest point, since real
            // file size is not determined
            int c; // anyhow, this is the fastest way doing this
            while((c = brin.read()) != -1) {
                buf[realSize] = (char) c;
                realSize++;
            }
        } finally {
            if(brin != null) {
                brin.close();
                //isr = null;
                //fis = null;
            }
            if(isr != null) {
                isr.close();
                //fis = null;
            }
            if(fis != null) {
                fis.close();
            }
        }
        return new String(buf, 0, realSize);
    }

    /**
     * 문자열을 지정 인코딩을 사용해 파일에 기록한다.
     *
     * @param fileName 대상 파일명 전체경로
     * @param s 기록할 문자열
     * @param encoding 인코딩
     * @exception IOException
     */
    public static void writeString(String fileName, String s, String encoding) throws IOException {
    	if(Validate.isNotEmpty(fileName)) {
    		fileName = fileName.replaceAll("/", "");
    		fileName = fileName.replaceAll(".", "");
    		fileName = fileName.replaceAll("&", "");
    	}
        writeString(new File(fileName), s, STRING_BUFFER_SIZE, encoding);
    }

    /**
     * 문자열을 지정 인코딩을 사용해 버퍼단위로 파일에 기록한다.
     *
     * @param fileName 대상 파일명 전체경로
     * @param s 기록할 문자열
     * @param bufferSize 버퍼 사이즈
     * @param encoding 인코딩
     * @exception IOException
     */
    public static void writeString(String fileName, String s, int bufferSize, String encoding) throws IOException {
    	if(Validate.isNotEmpty(fileName)) {
    		fileName = fileName.replaceAll("/", "");
    		fileName = fileName.replaceAll(".", "");
    		fileName = fileName.replaceAll("&", "");
    	}
        writeString(new File(fileName), s, bufferSize, encoding);
    }

    /**
     * 문자열을 지정 인코딩을 사용해 파일에 기록한다.
     *
     * @param file 대상 파일 객체
     * @param s 기록할 문자열
     * @param encoding 인코딩
     * @exception IOException
     */
    public static void writeString(File file, String s, String encoding) throws IOException {
        writeString(file, s, STRING_BUFFER_SIZE, encoding);
    }

    /**
     * 문자열을 지정 인코딩을 사용해 버퍼단위로 파일에 기록한다.
     *
     * @param file 대상 파일 객체
     * @param s 기록할 문자열
     * @param bufferSize 버퍼 사이즈
     * @param encoding 인코딩
     * @exception IOException
     */
    public static void writeString(File file, String s, int bufferSize, String encoding) throws IOException {
        if(s == null) {
            return;
        }
        FileOutputStream fos = null;
        OutputStreamWriter osw = null;
        BufferedWriter out = null;
        try {
            fos = new FileOutputStream(file);
            osw = new OutputStreamWriter(fos, encoding);
            out = new BufferedWriter(osw, bufferSize);
            out.write(s);
        } finally {
            if(out != null) {
                out.close();
                //osw = null;
                //fos = null;
            }
            if(osw != null) {
                osw.close();
                //fos = null;
            }
            if(fos != null) {
                fos.close();
            }
        }
    }

    // ---------------------------------------------------------------- object
    // serialization

    /**
     * 객체 직렬화를 위한 기본 버퍼 사이즈 (32KB).
     */
    public static final int OBJECT_BUFFER_SIZE = 32 * 1024;

    /**
     * 직렬화 객체를 파일에 기록한다. 기존 파일 존재시 덮어씌운다.
     *
     * @param f 대상 파일 전체경로
     * @param o 대상 객체
     * @exception IOException
     */
    public static void writeObject(String f, Object o) throws IOException {
        writeObject(f, o, OBJECT_BUFFER_SIZE);
    }

    /**
     * 직렬화 객체를 지정 버퍼단위로 파일에 기록한다. 기존 파일 존재시 덮어씌운다.
     *
     * @param f 대상 파일 전체경로
     * @param o 대상 객체
     * @param bufferSize 버퍼 사이즈
     * @exception IOException
     */
    public static void writeObject(String f, Object o, int bufferSize) throws IOException {
        FileOutputStream fos = null;
        BufferedOutputStream bos = null;
        ObjectOutputStream oos = null;
        try {
            fos = new FileOutputStream(f);
            bos = new BufferedOutputStream(fos, bufferSize);
            oos = new ObjectOutputStream(bos);
            oos.writeObject(o);
        } finally {
            if(oos != null) {
                oos.close();
                //bos = null;
                //fos = null;
            }
            if(bos != null) {
                bos.close();
                //fos = null;
            }
            if(fos != null) {
                fos.close();
            }
        }
    }

    /**
     * 직렬화된 객체를 파일에서 얻는다.
     *
     * @param f 대상 파일 전체경로
     * @return 직렬화된 객체
     * @exception IOException
     */
    public static Object readObject(String f) throws IOException, ClassNotFoundException, FileNotFoundException {

        return readObject(f, OBJECT_BUFFER_SIZE);
    }

    /**
     * 직렬화된 객체를 지정 버퍼 단위로 파일에서 얻는다.
     *
     * @param f 대상 파일 전체경로
     * @param bufferSize 버퍼 사이즈
     * @return 직렬화된 객체
     * @exception IOException
     * @exception ClassNotFoundException
     * @exception FileNotFoundException
     */
    public static Object readObject(String f, int bufferSize) throws IOException, ClassNotFoundException,
        FileNotFoundException {

        Object result = null;
        FileInputStream fis = null;
        BufferedInputStream bis = null;
        ObjectInputStream ois = null;
        try {
            fis = new FileInputStream(f);
            bis = new BufferedInputStream(fis, bufferSize);
            ois = new ObjectInputStream(bis);
            result = ois.readObject();
        } finally {
            if(ois != null) {
                ois.close();
                //bis = null;
                //fis = null;
            }
            if(bis != null) {
                bis.close();
                //fis = null;
            }
            if(fis != null) {
                fis.close();
            }
        }
        return result;
    }

    // ---------------------------------------------------------------- byte
    // array

    /**
     * 지정한 파일의 내용을 바이트 배열로 얻는다.
     *
     * @param s 대상 파일 전체경로
     * @return 파일 내용 바이트 배열
     * @exception IOException
     */
    public static final byte[] readBytes(String s) throws IOException {
        return readBytes(new File(s));
    }

    /**
     * 지정한 파일의 내용을 바이트 배열로 얻는다.
     *
     * @param file 대상 파일 객체
     * @return 파일 내용 바이트 배열
     * @exception IOException
     */
    public static final byte[] readBytes(File file) throws IOException {
        FileInputStream fileinputstream = new FileInputStream(file);
        byte byteArray[] = new byte[0];
        try {
        	long l = file.length();
        	if(l > Integer.MAX_VALUE) {
        		throw new IOException("File too big for loading into a byte array!");
        	}
        	byteArray = new byte[(int) l];
        	int i = 0;
        	for(int j = 0 ; (i < byteArray.length) && (j = fileinputstream.read(byteArray, i, byteArray.length - i)) >= 0 ; i += j) {
        		;
        	}
        	if(i < byteArray.length) {
        		throw new IOException("Could not completely read the file " + file.getName());
        	}
		}finally {
			if(fileinputstream != null) {
				fileinputstream.close();
			}
		}

        return byteArray;
    }

    public static void writeBytes(String filename, byte[] source) throws IOException {
        if(source == null) {
            return;
        }
        writeBytes(new File(filename), source, 0, source.length);
    }

    public static void writeBytes(File file, byte[] source) throws IOException {
        if(source == null) {
            return;
        }
        writeBytes(file, source, 0, source.length);
    }

    public static void writeBytes(String filename, byte[] source, int offset, int len) throws IOException {
        writeBytes(new File(filename), source, offset, len);
    }

    public static void writeBytes(File file, byte[] source, int offset, int len) throws IOException {
        if(len < 0) {
            throw new IOException("File size is negative!");
        }
        if(offset + len > source.length) {
            len = source.length - offset;
        }
        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(file);
            fos.write(source, offset, len);
        } finally {
            if(fos != null) {
                fos.close();
            }
        }
        return;
    }

    /**
     * 지정한 입력스트림의 데이타를 버퍼단위로 출력스트림에 기록한다.
     *
     * @param in 입력스트림
     * @param out 출력스트림
     * @param bufSizeHint 버퍼사이즈
     * @throws IOException
     */
    public static void copyPipe(InputStream in, OutputStream out, int bufSizeHint) throws IOException {
        int read = -1;
        byte[] buf = new byte[bufSizeHint];
        while((read = in.read(buf, 0, bufSizeHint)) >= 0) {
            out.write(buf, 0, read);
        }
        out.flush();
    }

    /**
     * 하위의 파일들의 목록을 얻음.
     *
     * @param dir 대상 파일(디렉토리) 객체
     * @return 파일 목록.
     */
    public static File[] listFiles(File dir) {

        String[] ss = dir.list();
        if(ss == null) {
            return null;
        }
        int n = ss.length;
        File[] fs = new File[n];
        for(int i = 0 ; i < n ; i++) {
            fs[i] = new File(dir.getPath(), ss[i]);
        }
        return fs;
    }

    /**
     * 하위의 파일들의 목록을 디렉토리->파일 순으로 정열하여 얻음.
     *
     * @param dir 대상 파일(디렉토리) 객체
     * @return 파일 목록.
     */
    public static File[] sortListFiles(File dir) {

        File[] fs = dir.listFiles();

        if(fs != null && fs.length > 1) {
            Arrays.sort(fs, new Comparator<File>() {

                @Override
                public int compare(File filea, File fileb) {

                    // 파일 소트전 디렉토리 소트
                    // 대소문자는 구분하지 않음
                    if(filea.isDirectory() && !fileb.isDirectory()) {
                        return -1;
                    } else if(!filea.isDirectory() && fileb.isDirectory()) {
                        return 1;
                    } else {
                        return filea.getName().compareToIgnoreCase(fileb.getName());
                    }
                }
            });
        }
        return fs;
    }

    /**
     * <p>
     * 지정된 파일경로에 대한 파일객체를 얻음.
     * </p>
     *
     * @param fileName 파일명 전체경로.
     * @return 파일객체.
     */
    public static File getFile(String fileName) {
        return new File(fileName);
    }

    /**
     * 지정 경로가 디렉토리인지 여부를 판단함.
     *
     * @param path 파일의 경로
     * @return 디렉토리이면 true.
     */
    public static boolean isDirectory(String path) {

        boolean dir = false;

        if(path != null) {
            File file = new File(path);

            dir = file.isDirectory();
        }
        return dir;
    }

    /**
     * 지정 경로가 파일인지 여부를 판단함.
     *
     * @param path 파일의 경로
     * @return 파일이면 true.
     */
    public static boolean isFile(String path) {

        boolean file = false;

        if(path != null) {
            File f = new File(path);

            file = f.isFile();
        }
        return file;
    }

    /**
     * 지정한 파일의 확장자가 주어진 확장자 목록에 있는지를 판단함.
     *
     * @param ext 비교할 확장자.
     * @param exts 비교할 파일의 확장자 목록 .
     * @return 주어진 확장자 목록에 있다면 true.
     */
    public static boolean hasExtension(String[] exts, String ext) {

        if(exts == null || ext == null) {
            return false;
        }

        if(exts.length == 0) {
            return false;
        }

        for(int i = 0 ; i < exts.length ; i++) {
            if(ext.equalsIgnoreCase(exts[i])) {
                return true;
            }
        }

        return false;
    }

    /** 1 KB */
    public static final int ONE_KB = 1024;

    /** 1 MB. */
    public static final int ONE_MB = ONE_KB * ONE_KB;

    /** 1 GB */
    public static final int ONE_GB = ONE_KB * ONE_MB;

    /**
     * <p>
     * 파일크기를 사람이 읽기 쉽게 변환함.
     * </p>
     *
     * @param file 대상 파일 전체경로.
     * @return 변환된 파일사이즈.
     */
    public static String toDisplaySize(String file) {

        if(file == null || file.length() == 0) {
            return "";
        }

        return toDisplaySize(new File(file));
    }

    /**
     * <p>
     * 파일크기를 사람이 읽기 쉽게 변환함.
     * </p>
     *
     * @param file 대상 파일 객체.
     * @return 변환된 파일사이즈.
     */
    public static String toDisplaySize(File file) {

        if(file == null || !file.exists()) {
            return "";
        }

        return toDisplaySize(file.length());
    }

    /**
     * <p>
     * 파일크기를 사람이 읽기 쉽게 변환함.
     * </p>
     *
     * @param size 파일사이즈.
     * @return 변환된 파일사이즈.
     */
    public static String toDisplaySize(long size) {
        return toDisplaySize(Long.valueOf(String.valueOf(size)).intValue());
    }

    /**
     * <p>
     * 파일크기를 사람이 읽기 쉽게 변환함.
     * </p>
     *
     * @param size 파일사이즈.
     * @return 변환된 파일사이즈.
     */
    public static String toDisplaySize(int size) {

        String displaySize;

        if(size / ONE_GB > 0) {
            displaySize = String.valueOf(size / ONE_GB) + " GB";
        } else if(size / ONE_MB > 0) {
            displaySize = String.valueOf(size / ONE_MB) + " MB";
        } else if(size / ONE_KB > 0) {
            displaySize = String.valueOf(size / ONE_KB) + " KB";
        } else {
            displaySize = String.valueOf(size) + " bytes";
        }

        return displaySize;
    }

    /**
     * <p>
     * 지정된 시간(초)까지 파일이 존재하는지 확인함.
     * </p>
     *
     * @param fileName 확인할 파일명.
     * @param seconds 확인을 위해 대기할 시간(초).
     * @return 지정 시간(초)까지 파일이 존재하면 true.
     */
    public static boolean waitFor(String fileName, int seconds) {

        File file = new File(fileName);
        int timeout = 0;
        int tick = 0;

        while(!file.exists()) {
            if(tick++ >= 10) {
                tick = 0;
                if(timeout++ > seconds) {
                    return false;
                }
            }
            try {
                Thread.sleep(100);
            } catch (InterruptedException ignore) {
            	logger.error("", ignore);
            } catch (Exception ex) {
                break;
            }
        }
        return true;
    }

    /**
     * <p>
     * 파일 구분자를 제거한 디렉토리명을 얻음.
     * </p>
     *
     * @param filename 디렉토리명.
     * @return 파일 구분자를 제거한 디렉토리명.
     */
    public static String dirname(String filename) {
        int i = filename.lastIndexOf(File.separator);
        return (i >= 0 ? filename.substring(0, i) : "");
    }

    /**
     * <p>
     * 파일 구분자를 제거한 파일명을 얻음.
     * </p>
     *
     * @param filename 파일명.
     * @return 파일 구분자를 제거한 파일명.
     */
    public static String filename(String filename) {
        int i = filename.lastIndexOf(File.separator);
        return (i >= 0 ? filename.substring(i + 1) : filename);
    }

    /**
     * <p>
     * 확장자를 제외한 파일명을 얻음.
     * </p>
     *
     * @param filename 파일명.
     * @return 확장자를 제외한 파일명.
     */
    public static String basename(String filename) {
        return basename(filename, extension(filename));
    }

    /**
     * <p>
     * 확장자를 제외한 파일명을 얻음.
     * </p>
     *
     * @param filename 파일명.
     * @param suffix 확장자.
     * @return 확장자를 제외한 파일명.
     */
    public static String basename(String filename, String suffix) {
        int i = filename.lastIndexOf(File.separator) + 1;
        int lastDot = ((suffix != null) && (suffix.length() > 0)) ? filename.lastIndexOf(suffix) : -1;

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
     * 파일 확장자를 얻음.
     * </p>
     *
     * @param filename 파일명.
     * @return 파일 확장자.
     */
    public static String extension(String filename) {
        int lastDot = filename.lastIndexOf('.');

        if(lastDot >= 0) {
            return filename.substring(lastDot + 1);
        } else {
            return StringUtil.EMPTY;
        }
    }

    /**
     * <p>
     * 파일 변경일자를 지정한 포맷으로 변환
     * </p>
     *
     * @param lastmodified 변경일자.
     * @param format 변경 포맷(yyyy-MM-dd hh:mm:ss).
     * @return 지정한 포맷으로 변환한 날짜.
     */
    public static String toFormatDate(long lastmodified, String format) {

        java.text.SimpleDateFormat df = null;
        if(format == null || format.length() == 0) {
            df = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        } else {
            df = new java.text.SimpleDateFormat(format);
        }

        return df.format(new java.util.Date(lastmodified));
    }

    /**
     * <p>
     * 중복되는 파일 존재시 파일 끝에 [i++] 값을 넣은 비중복 파일명을 얻음
     * </p>
     *
     * @param files 대상 파일폴더.
     * @param targetName 중복되는지 체크해야 할 파일명.
     * @return 중복되면 aaaa.txt -> aaaa[1].txt 로 변환한 값 중복되지 않으면 aaaa.txt 그래도 반환.
     */
    public static String getRenameDupleFile(File files[], String targetName) {

        String resultName = targetName;
        String baseName = PathUtil.baseName(targetName);
        String extName = PathUtil.extension(targetName);

        int startTag = baseName.lastIndexOf('[');
        int endTag = baseName.lastIndexOf(']');

        for(int i = 0 ; i < files.length ; i++) {
            if(files[i].isFile()) {
                if(targetName.equals(files[i].getName())) {

                    if(startTag != -1 && endTag != -1) {
                        String indexNo = baseName.substring(startTag + 1, endTag);
                        String indexName = baseName.substring(0, startTag);
                        int indexNoInt = 1;
                        try {
                            indexNoInt = Integer.parseInt(indexNo);
                            indexNoInt++;
                        } catch (NumberFormatException nfe) {
                            /* none */
                        	logger.error("NumberFormatException",nfe);
                        }

                        resultName = indexName + "[" + indexNoInt + "]." + extName;

                    } else {
                        resultName = baseName + "[1]." + extName;
                    }

                    resultName = getRenameDupleFile(files, resultName);
                }
            }
        }

        return resultName;
    }

    public static String getContentType(File file) {

        try {
            return new MimetypesFileTypeMap().getContentType(file);
            /*--
            return file.toURI().toURL().openConnection().getContentType();
            --*/
        } catch (RuntimeException e) {
            return "content/unknown";
        } catch (Exception e) {
            return "content/unknown";
        }
    }

    /**
     * <p>
     * 풀 패스로 저장된 첨부파일을 웹 CONTEXT_ROOT에 맞게 표시하기 위해 설정파일의 값(substringFileCount)을
     * 체크하여 substring한 패스경로를 반환
     * </p>
     *
     * @param ctxPath 웹 컨텍스트 절대경로
     * @param filePath 대상 파일 풀패스
     * @return String
     */
    public static String getContextPath(String ctxPath, String filePath) {

        if(Validate.isEmpty(ctxPath)) {
            return filePath;
        }

        if(Validate.isEmpty(filePath)) {
            return filePath;
        }

        return PathUtil.toUnixPath(filePath.substring(ctxPath.length() /*- StringUtil.ONE*/));
    }

    public static String getContextPath(HttpServletRequest request, String filePath) {

        String webRoot = request.getSession().getServletContext().getRealPath("/");

        return getContextPath(webRoot, filePath);
    }

    public static String getContextPath(String filePath, int cutIndex) {

        if(Validate.isEmpty(filePath)) {
            return filePath;
        }

        return PathUtil.toUnixPath(filePath.substring(cutIndex));
    }

    /* 지정한 파일유형의 이미지 여부 확인 */
    public static boolean isImage(String fileType) {
        return fileType.startsWith("image/");
    }

    public static char getDelimiter(String typename) {

		if(typename == null || typename.isEmpty() || typename.equals(""))
		{
			return ',';
		}
		if( typename.equals("comma"))
		{
			return ',';
		}
		else if(typename.equals("pipe"))
		{
			return '|';
		}else if(typename.equals("tab"))
		{
			return '\t';
		}
		else
			return ',';
	}
}
