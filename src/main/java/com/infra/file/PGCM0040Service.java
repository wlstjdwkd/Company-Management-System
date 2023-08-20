package com.infra.file;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.infra.system.GlobalConst;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 파일 다운로드 서비스
 * 
 * @author dongwoo
 *
 */
@Service("PGCM0040")
public class PGCM0040Service extends EgovAbstractServiceImpl  {
	
	private static final Logger logger = LoggerFactory.getLogger(PGCM0040Service.class);
	
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;
	
	@Resource(name = "filesDAO")
	private FileDAO dao;
	
	/**
     * 파일 다운로드
     */
    public ModelAndView updateFileDown(Map<?, ?> rqstMap) {
    	ModelAndView mv = new ModelAndView();
    	
    	String fileId = MapUtils.getString(rqstMap, "id");
        FileVO fileVo = dao.getFile(fileId);       
        
        if(fileVo != null) {
        	//TODO 파일다운로드 기록 남기는 부분 추후 확인
            //service.updateFileDown(request, id);
        	dao.updateFileDown(fileId);
        }
        
        mv.addObject(GlobalConst.FILE_DATA_KEY, fileVo);
    	mv.setViewName(GlobalConst.DOWNLOAD_VIEW_NAME);

        return mv;                
    }
    
    /**
     * 파일 다운로드
     */
    public ModelAndView updateFileDownBySeq(Map<?, ?> rqstMap) {
    	ModelAndView mv = new ModelAndView();
    	
    	int fileSeq = MapUtils.getIntValue(rqstMap, "seq");
        List<FileVO> fileVoList = dao.getFiles(fileSeq);
        FileVO fileVo = null;
        
        if(Validate.isNotEmpty(fileVoList)) {
        	fileVo = fileVoList.get(0);
        	logger.debug("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ fileVo: "+fileVo.getFileId());
        	logger.debug("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ fileVo: "+fileVo.getFileSeq());
        	logger.debug("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ fileVo: "+fileVo.getLocalNm());
        }
        
        mv.addObject(GlobalConst.FILE_DATA_KEY, fileVo);
    	mv.setViewName(GlobalConst.DOWNLOAD_VIEW_NAME);

        return mv;        
    }
}
