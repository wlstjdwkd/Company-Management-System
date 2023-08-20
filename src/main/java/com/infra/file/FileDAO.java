package com.infra.file;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import com.comm.user.UserVO;
import com.infra.util.FileUtil;
import com.infra.util.SessionUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.springframework.stereotype.Repository;

import egovframework.rte.fdl.cmmn.exception.FdlException;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@SuppressWarnings("unchecked")
@Repository("filesDAO")
public class FileDAO extends EgovAbstractMapper {

	@Resource(name="fileUploadIdGnrService")
	private EgovIdGnrService idgenService;

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

    /**
     * 신규 파일 일련번호 추출
     *
     * @param fileList 첨부파일 목록(업로드 파일이 있는지 확인용)
     * @return
     */
    private synchronized int getMaxFileSeq(List<FileVO> fileList) {

        if(Validate.isEmpty(fileList)) {
            return -1;
        }

        return (Integer) selectOne("com.infra.file.fileDao.getMaxFileSeq", null);
    }

    /**
     * 파일 일련번호와 일치하는 모든 파일목록을 반환
     * 
     * @param fileSeq 첨부파일 일련번호
     * @return
     */
    public List<FileVO> getFiles(Integer fileSeq) {

        return selectList("com.infra.file.fileDao.getFiles", fileSeq);
    }

    /**
     * 여러개의 파일 일련번호와 일치하는 모든 파일목록을 반환
     *
     * @param fileSeq 첨부파일 일련번호
     * @return
     */
    @SuppressWarnings("rawtypes")
    public List<FileVO> getFilesSeqs(String fileSeq) {

        HashMap map = new HashMap();
        map.put("fileSeq", fileSeq);
        return selectList("com.infra.file.fileDao.getFilesSeqs", map);
    }

    /**
     * 파일 고유 ID로 하나의 파일 정보를 반환
     *
     * @param fileId 파일 고유 ID
     * @return
     */
    public FileVO getFile(String fileId) {

        return (FileVO) selectOne("com.infra.file.fileDao.getFile", fileId);
    }

    /**
     * 파일 목록 저장
     *
     * @param fileList 추가할 파일 목록
     * @return
     */
    public int saveFile(List<FileVO> fileList) {

        return saveFile(fileList, -1);
    }

    /**
     * 이미 저장되어 있는 일련번호 그룹에 추가 저장
     *
     * @param fileList 추가할 파일 목록
     * @param fileSeq 저장할 파일들의 일련번호
     * @return
     */
    public int saveFile(List<FileVO> fileList, Integer fileSeq) {

        return saveFile(fileList, fileSeq, null);
    }

    /**
     * 이미 저장되어 있는 일련번호 그룹에 추가 저장하며, 화면 UI의 input 태그의 name 속성을 함께 저장한다.
     *
     * @param fileList 추가할 파일 목록
     * @param fileSeq 저장할 파일들의 일련번호
     * @param inputNm 화면 UI의 input 태그의 name 속성
     * @return
     */
    public int saveFile(List<FileVO> fileList, Integer fileSeq, String inputNm) {

        int _fileSeq = fileSeq;

        if(Validate.isNotEmpty(fileList)) {

            if(_fileSeq <= 0) {
                _fileSeq = getMaxFileSeq(fileList);
            	/*try {
					_fileSeq = idgenService.getNextIntegerId();
				} catch (FdlException e) {
					e.printStackTrace();
				}*/
            }

            for(FileVO baseFileVo : fileList) {
                baseFileVo.setFileSeq(_fileSeq);
                insert("com.infra.file.fileDao.insertFile", baseFileVo);
            }
        }
        else {
        	logger.debug("파일 업로드 실패");
        }
        return _fileSeq;
    }

    /**
     * 파일 일련번호에 해당하는 모든 파일을 삭제한다.
     * DB와 물리적 파일 모두 삭제한다.
     *
     * @param fileSeq 삭제할 파일들의 일련번호
     * @return
     */
    public int removeFile(Integer fileSeq) {
    	int logDeleted = 0;
        int affected = 0;

        if(fileSeq <= 0) {
            return affected;
        }

        List<FileVO> fileList = selectList("com.infra.file.fileDao.getFiles", fileSeq);
        
        logDeleted = delete("com.infra.file.fileDao.deleteFilesLog", fileSeq);
        affected = delete("com.infra.file.fileDao.deleteFiles", fileSeq);

        if(affected > 0) {
            for(FileVO baseFileVo : fileList) {
                FileUtil.delete(propertiesService.getString("attachFilePath", "") + baseFileVo.getFileUrl());
            }
        }
        return affected;
    }

    /**
     * 파일 고유 ID를 통하여 하나의 파일을 삭제 한다.
     * DB와 물리적 파일 모두 삭제한다.
     *
     * @param fileSeq 삭제할 파일들의 일련번호
     * @param fileId 삭제할 파일의 고유 id
     * @return
     */
    public int removeFile(Integer fileSeq, String fileId) {

        return removeFile(fileSeq, new String[] { fileId });
    }


    /**
     * 파일 고유 ID를 통하여 하나의 파일을 삭제 한다.
     * DB와 물리적 파일 모두 삭제한다.
     *
     * @param fileId 삭제할 파일의 고유 id
     * @return
     */
    public int removeFile(String fileId) {
    	int logDeleted = 0;
        int affected = 0;

        if(Validate.isNotEmpty(fileId)) {
            FileVO file = getFile(fileId);
            if(file != null) {
            	FileUtil.delete(propertiesService.getString("attachFilePath", "") + file.getFileUrl());

            	logDeleted += delete("com.infra.file.fileDao.deleteFileLogById", file);
            	affected += delete("com.infra.file.fileDao.deleteFileById", file);
            }

        }
        return affected;
    }

    /**
     * 일련번호에 해당하는 파일중 지정된 고유 ID에 해당하는 파일들을 삭제한다.
     * DB와 물리적 파일 모두 삭제한다.
     *
     * @param fileSeq 삭제할 파일들의 일련번호
     * @param fileIds 삭제할 파일의 고유 id 목록
     * @return
     */
    public int removeFile(Integer fileSeq, String[] fileIds) {
    	int logDeleted = 0;
    	int affected = 0;

    	if(fileSeq <= 0) {
    		return affected;
    	}

    	if(Validate.isNotEmpty(fileIds)) {

            List<FileVO> fileList = selectList("com.infra.file.fileDao.getFiles", fileSeq);

    		for(String fileId : fileIds) {
    			for(FileVO baseFileVo : fileList) {
    				if(fileId.equals(baseFileVo.getFileId())) {

                        FileUtil.delete(propertiesService.getString("attachFilePath", "") + baseFileVo.getFileUrl());
                        
                        logDeleted += delete("com.infra.file.fileDao.deleteFileLog", baseFileVo);
                        affected += delete("com.infra.file.fileDao.deleteFile", baseFileVo);
                        break;
                    }
                }
            }
        }
        return affected;
    }

    /**
     * 파일 교체(기존 파일 삭제후 신규 등록)
     * 
     * @param fileList 파일 목록
     * @param fileSeq 파일 일련 번호
     * @param inputNm 화면 UI의 input 태그의 name 속성
     * @return
     */
    public int replaceFile(List<FileVO> fileList, Integer fileSeq, String inputNm) {
    	int logDeleted = 0;
        int affected = 0;

        if(fileSeq <= 0) {
            return affected;
        }
        if(Validate.isEmpty(inputNm)) {
            return affected;
        }
        if(Validate.isEmpty(fileList)) {
            return affected;
        }

        List<FileVO> dataList = selectList("com.infra.file.fileDao.getFiles", fileSeq);
        for(FileVO baseFileVo : dataList) {
            if(inputNm.equals(baseFileVo.getInputNm())) {
                FileUtil.delete(propertiesService.getString("attachFilePath", "") + baseFileVo.getFileUrl());
                
                logDeleted += delete("com.infra.file.fileDao.deleteFileLog", baseFileVo);
                affected += delete("com.infra.file.fileDao.deleteFile", baseFileVo);
            }
        }

        return saveFile(fileList, fileSeq, inputNm);
    }

    /**
     * 파일 다운로드 이력을 남기고 다운로드
     *
     * @param fileId 첨부파일 고유 ID
     * @return
     */
    public int updateFileDown(String fileId) {

        int affected = update("com.infra.file.fileDao.updateFileDown", fileId);
        HashMap<String, Object> paramMap = new HashMap<String, Object>();
        UserVO userVo = SessionUtil.getUserInfo();

        if(affected == StringUtil.ONE) {

        	paramMap.put("fileId", fileId);
        	if(Validate.isNotEmpty(userVo)) {
        		paramMap.put("workerNm", userVo.getLoginId());
        	}else {
        		paramMap.put("workerNm", "anonymous");
        	}

            // 다운로드 로그 기록
            /*FileLogVO logVo = new FileLogVO();
            logVo.setFileId(fileId);
            LoginVO mgrVo = OpHelper.getMgrSession(request);
            if(Validate.isNotEmpty(mgrVo) && Validate.isNotEmpty(mgrVo.getMgrId())) {
                logVo.setWorkerNm(mgrVo.getMgrNm());
            } else {
                UserLoginVO userLoginVo = OpHelper.getUserSession(request);
                if(Validate.isNotEmpty(userLoginVo) && Validate.isNotEmpty(userLoginVo.getUserId())) {
                    logVo.setWorkerNm(userLoginVo.getUserNm());
                } else {
                    logVo.setWorkerNm("비회원");
                }
            }*/


            Integer fileSeq = (Integer) selectOne(
                "com.infra.file.fileDao.getFileSeqByFileId", fileId);
            if(fileSeq != null) {
            	paramMap.put("fileSeq", fileSeq);
                insert("com.infra.file.fileDao.insertFileLog", paramMap);
            }
        }
        return affected;
    }

    /**
     * 파일별 파일 다운로드 이력 목록
     * 
     * @param vo 이력을 확인 할 파일 정보
     * @return
     */
    /*public Pager<?> fileLogList(FileLogVO vo) {

        Map<String, Object> parameterMap = vo.getDataMap();
        parameterMap.put("fileSeq", vo.getFileSeq());
        parameterMap.put("fileId", vo.getFileId());

        List<FileLogVO> dataList = list("zes.openworks.component.file.getFileLogs", parameterMap);
        vo.setTotalNum((Integer) selectByPk("zes.openworks.component.file.getFileLogCount",
            parameterMap));

        return new Pager<FileLogVO>(dataList, vo);
    }*/
}
