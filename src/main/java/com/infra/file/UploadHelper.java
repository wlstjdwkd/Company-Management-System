/*
 * Copyright (c) 2012 techbluegenic Inc. All rights reserved.
 * This software is the confidential and proprietary information of ZES Inc.
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with ZES Inc. (http://www.techblue.co.kr/)
 */
package com.infra.file;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import com.infra.system.GlobalConst;
import com.infra.util.FileUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.property.impl.EgovPropertyServiceImpl;

@Component
public class UploadHelper implements ApplicationContextAware{
	private static final Logger logger = LoggerFactory.getLogger(UploadHelper.class);

	private EgovPropertyService propertiesService;

	//TODO 파일업로드 관련 config 저장경로 추후 확인
    /** 파일 저장 경로 */
    private static final String DEFAULT_UPLOAD_FOLDER_PATH = "";//GlobalConfig.UPLOAD_FOLDER_PATH;
    /** 기능별 저장경로를 지정하지 않는 경우의 기본 폴더명 */
    private static final String DEFAULT_UPLOAD_FOLDER_NAME = "";//GlobalConfig.DEFAULT_UPLOAD_FOLDER_NAME;
    /** File.separator */
    private static final String separator = File.separator;
    /** Was ROOT 경로 */
    public static String WEBAPP_ROOT;

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
    	propertiesService = (EgovPropertyService) applicationContext.getBean("propertiesService");
    	WEBAPP_ROOT = propertiesService.getString("attachFilePath", "");
    }

    /**
     * 기본 폴더명을 사용하여 파일 저장
     *
     * @param request Http 요청 객체
     * @return 저장 파일 목록
     */
    public static List<FileVO> upload(HttpServletRequest request) {

        return upload(request, DEFAULT_UPLOAD_FOLDER_NAME);
    }

    /**
     * 폴더명을 지정하여 파일 저장
     *
     * @param request
     * @param folderName
     * @return 저장 파일 목록
     */
    public static List<FileVO> upload(HttpServletRequest request, String folderName) {

        @SuppressWarnings("unchecked")
        List<MultipartFile> files = (List<MultipartFile>) request
        		.getAttribute(GlobalConst.FILE_LIST_KEY);//request.getAttribute(GlobalConfig.FILE_LIST_KEY);

        return upload(files, folderName);
    }

    /**
     * 기본 폴더명을 사용하여 파일 저장
     *
     * @param multiFiles
     * @return 저장 파일 목록
     */
    public static List<FileVO> upload(MultipartFile multiFiles) {
        return upload(new MultipartFile[] { multiFiles }, DEFAULT_UPLOAD_FOLDER_NAME);
    }

    /**
     * 폴더명을 지정하여 파일 저장
     *
     * @param multiFiles
     * @return 저장 파일 목록
     */
    public static List<FileVO> upload(MultipartFile multiFiles, String folderName) {
        return upload(new MultipartFile[] { multiFiles }, folderName);
    }

    /**
     * 기본 폴더명을 사용하여 파일 저장
     *
     * @param multiFiles
     * @return 저장 파일 목록
     */
    public static List<FileVO> upload(MultipartFile[] multiFiles) {
        return upload(multiFiles, DEFAULT_UPLOAD_FOLDER_NAME);
    }

    /**
     * 폴더명을 지정하여 파일 저장(압축파일 해제 미지원)
     *
     * @param files multiFiles 목록
     * @param folderName
     * @return 저장 파일 목록
     */
    public static List<FileVO> upload(List<MultipartFile> files, String folderName) {
        return upload(files, folderName, false);
    }

    /**
     * 폴더명을 지정하여 파일 저장(압축파일 해제 미지원)
     *
     * @param multiFiles
     * @param folderName
     * @return 저장 파일 목록
     */
    public static List<FileVO> upload(MultipartFile[] multiFiles, String folderName) {
        return upload(multiFiles, folderName, false);
    }

    /**
     * upload 설명
     *
     * @param files
     * @param folderName
     * @param isExtractZip 압축해제 여부
     * @return 저장 파일 목록
     */
    public static List<FileVO> upload(List<MultipartFile> files, String folderName,
        boolean isExtractZip) {

        if(Validate.isEmpty(files)) {
            return new ArrayList<FileVO>();
        }

        return upload(files.toArray(new MultipartFile[] {}), folderName, isExtractZip);
    }

    /**
     * upload 설명
     *
     * @param multiFiles
     * @param folderName
     * @param isExtractZip 압축해제 여부
     * @return 저장 파일 목록
     * @throws Exception
     */
    public static List<FileVO> upload(MultipartFile[] multiFiles, String folderName,
        boolean isExtractZip) {

        if(Validate.isEmpty(multiFiles)) {
            return new ArrayList<FileVO>();
        }

        if(Validate.isEmpty(folderName)) {
            folderName = DEFAULT_UPLOAD_FOLDER_NAME;
        }

        String concludeFolderPath = createFolderAsDate(getUploadFolderPath() + folderName);

        FileVO fileVo;
        List<FileVO> fileList = new ArrayList<FileVO>();

        try {
            for(MultipartFile multiFile : multiFiles) {

                if(multiFile.getSize() > 0) {

                    /*if(ZipCompress.isZipFile(multiFile.getContentType()) && isExtractZip) {

                        fileList = ZipCompress.unCompressRename(multiFile.getInputStream(),
                            concludeFolderPath);

                    } else {*/

                        String uuid = UUID.randomUUID().toString();
                        String newFileName = uuid + "." + extension(multiFile.getOriginalFilename());
                        File newFileObject = new File(concludeFolderPath, newFileName);
                        String filePath = newFileObject.getAbsolutePath();
                        String fileType = multiFile.getContentType();

                        multiFile.transferTo(newFileObject);

                        fileVo = new FileVO();

                        fileVo.setFile(newFileObject);
                        fileVo.setFileUrl(FileUtil.getContextPath(WEBAPP_ROOT, filePath));
                        fileVo.setInputNm(multiFile.getName());
                        fileVo.setServerNm(newFileObject.getName());
                        fileVo.setLocalNm(multiFile.getOriginalFilename());
                        fileVo.setFileType(fileType);
                        fileVo.setFileSize(FileUtil.toDisplaySize(multiFile.getSize()));
                        fileVo.setFileByteSize(multiFile.getSize());
                        fileVo.setFileId(uuid);
                        fileVo.setFileExt(extension(fileVo.getLocalNm()));

                        fileList.add(fileVo);
                    /*}*/
                }
            }
        } catch (IOException e) {
        	logger.error("", e);
        }

        return fileList;
    }

    /**
     * 최상위 파일 저장 경로 반환
     *
     * @return 최상위 저장경로
     */
    public static String getUploadFolderPath() {

        String uploadFolderPath = DEFAULT_UPLOAD_FOLDER_PATH;

        if(Validate.isEmpty(uploadFolderPath)) {
            String webRoot = new String(WEBAPP_ROOT);
            webRoot += webRoot.endsWith(separator) ? "" : separator;	//"upload/" : "/upload/";
            webRoot += "upload" + separator;
            uploadFolderPath = webRoot;
        } else {
            uploadFolderPath += uploadFolderPath.endsWith(separator) ? StringUtil.EMPTY : "/";
        }

        return uploadFolderPath;
    }

    /**
     * 파일 확장자 추출
     *
     * @param fileName
     * @return
     */
    private static String extension(String fileName) {

        return FileUtil.extension(fileName).toLowerCase();
    }

    /**
     * 년월일 기반 저장 경로 생성
     *
     * @param fullFolderPath
     * @return
     */
    public static String createFolderAsDate(String fullFolderPath) {

        Calendar cal = Calendar.getInstance();
        String yearFolderName = Integer.toString(cal.get(Calendar.YEAR));
        String monthFolderName = Integer.toString(cal.get(Calendar.MONTH) + 1);
        String dayFolderName = Integer.toString(cal.get(Calendar.DATE));

        String dateFolderName = separator + yearFolderName + separator + monthFolderName
            + separator + dayFolderName
            + separator;

        String returnFolderPath = fullFolderPath + dateFolderName;

        FileUtil.mkdirs(returnFolderPath);

        return returnFolderPath;
    }

    /**
     * 폴더명을 지정하여 파일 저장(압축파일 해제 미지원)
     *
     * @param files multiFiles 목록
     * @param folderName
     * @return 저장 파일 목록
     */
    public static List<FileVO> upload(List<MultipartFile> files, String folderName, String jurirno) {
        return upload(files, folderName, jurirno, false);
    }

    /**
     * upload 설명
     * 담당자변경요청 사업자등록증, 재직증명서 업로드
     * @param files
     * @param folderName, jurirno
     * @param isExtractZip 압축해제 여부
     * @return 저장 파일 목록
     */
    public static List<FileVO> upload(List<MultipartFile> files, String folderName, String jurirno,
        boolean isExtractZip) {

        if(Validate.isEmpty(files)) {
            return new ArrayList<FileVO>();
        }

        return upload(files.toArray(new MultipartFile[] {}), folderName, jurirno, isExtractZip);
    }

    /**
     * upload 설명
     * 담당자변경요청 사업자등록증, 재직증명서 업로드
     * @param multiFiles
     * @param folderName, jurirno
     * @param isExtractZip 압축해제 여부
     * @return 저장 파일 목록
     * @throws Exception
     */
    public static List<FileVO> upload(MultipartFile[] multiFiles, String folderName, String jurirno,
        boolean isExtractZip) {

        if(Validate.isEmpty(multiFiles)) {
            return new ArrayList<FileVO>();
        }

        if(Validate.isEmpty(folderName)) {
            folderName = DEFAULT_UPLOAD_FOLDER_NAME;
        }

        String concludeFolderPath = createFolderAsJurirno(getUploadFolderPath() + folderName, jurirno);

        FileVO fileVo;
        List<FileVO> fileList = new ArrayList<FileVO>();

        try {
            for(MultipartFile multiFile : multiFiles) {

                if(multiFile.getSize() > 0) {

                    /*if(ZipCompress.isZipFile(multiFile.getContentType()) && isExtractZip) {

                        fileList = ZipCompress.unCompressRename(multiFile.getInputStream(),
                            concludeFolderPath);

                    } else {*/

                        String uuid = UUID.randomUUID().toString();
                        String newFileName = uuid + "." + extension(multiFile.getOriginalFilename());
                        File newFileObject = new File(concludeFolderPath, newFileName);
                        String filePath = newFileObject.getAbsolutePath();
                        String fileType = multiFile.getContentType();

                        multiFile.transferTo(newFileObject);

                        fileVo = new FileVO();

                        fileVo.setFile(newFileObject);
                        fileVo.setFileUrl(FileUtil.getContextPath(WEBAPP_ROOT, filePath));
                        fileVo.setInputNm(multiFile.getName());
                        fileVo.setServerNm(newFileObject.getName());
                        fileVo.setLocalNm(multiFile.getOriginalFilename());
                        fileVo.setFileType(fileType);
                        fileVo.setFileSize(FileUtil.toDisplaySize(multiFile.getSize()));
                        fileVo.setFileByteSize(multiFile.getSize());
                        fileVo.setFileId(uuid);
                        fileVo.setFileExt(extension(fileVo.getLocalNm()));

                        fileList.add(fileVo);
                    /*}*/
                }
            }
        } catch (IOException e) {
        	logger.error("", e);
        }

        return fileList;
    }

    /**
     * 법인번호 기반 저장 경로 생성
     * 담당자변경요청 사업자등록증, 재직증명서 업로드
     * @param fullFolderPath
     * @return
     */
    public static String createFolderAsJurirno(String fullFolderPath, String jurirno) {

        String dateFolderName = separator + jurirno + separator;

        String returnFolderPath = fullFolderPath + dateFolderName;

        FileUtil.mkdirs(returnFolderPath);

        return returnFolderPath;
    }

}
