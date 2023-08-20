package com.infra.file;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("filesService")
public class FileServiceImpl extends EgovAbstractServiceImpl implements FileService {

    @Resource
    private FileDAO dao;

    @Override
    public List<FileVO> getFiles(Integer fileSeq) {
        return dao.getFiles(fileSeq);
    }

    @Override
    public FileVO getFile(String fileId) {
        return dao.getFile(fileId);
    }

    @Override
    public int saveFile(List<FileVO> fileList) {
        return dao.saveFile(fileList);
    }

    @Override
    public int saveFile(List<FileVO> fileList, Integer fileSeq) {
        return dao.saveFile(fileList, fileSeq);
    }

    @Override
    public int saveFile(List<FileVO> fileList, Integer fileSeq, String inputNm) {
        return dao.saveFile(fileList, fileSeq, inputNm);
    }

    @SuppressWarnings("unused")
    private int saveFileAction(List<FileVO> fileList, Integer fileSeq, String inputNm) {
        // if (Validator.isNotEmpty(vo.getFileIds())) {
        // fileDao.fileDeleteAction(vo.getFileSeq(), vo.getFileIds());
        // }

        /*
         * if (vo.getFileSeq() > 0) {
         * if (Validator.isNotEmpty(vo.getFileList())) {
         * if (Validator.isNotEmpty(inputNms)) {
         * for (String inputNm : inputNms) {
         * fileDao.fileReplaceAction(vo.getFileList(), vo.getFileSeq(),
         * inputNm);
         * }
         * } else {
         * fileDao.fileInsertAction(vo.getFileList(), vo.getFileSeq());
         * }
         * }
         * } else {
         * return fileDao.fileInsertAction(vo.getFileList());
         * }
         */
        return 1;
    }

    @Override
    public int removeFile(Integer fileSeq) {
        return dao.removeFile(fileSeq);
    }

    @Override
    public int removeFile(Integer fileSeq, String fileId) {
        return dao.removeFile(fileSeq, fileId);
    }

    @Override
    public int removeFile(Integer fileSeq, String[] fileIds) {
        return dao.removeFile(fileSeq, fileIds);
    }

    /*@Override
    public int updateFileDown(HttpServletRequest request, String fileId) {
        return dao.updateFileDown(request, fileId);
    }*/

    @Override
    public int replaceFile(List<FileVO> fileList, Integer fileSeq, String inputNm) {
        return dao.replaceFile(fileList, fileSeq, inputNm);
    }

    /*@Override
    public Pager<?> getFileLogs(FileLogVO vo) {
        return dao.fileLogList(vo);
    }*/

}
