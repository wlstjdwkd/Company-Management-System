package biz.tech.ts;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.xml.bind.Validator;

import com.comm.menu.MenuService;
import com.comm.page.Pager;
import com.infra.file.FileDAO;
import com.infra.file.FileVO;
import com.infra.file.UploadHelper;
import com.infra.system.GlobalConst;
import com.infra.util.ResponseUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.test.TestMapper;

@Service("PGTS0005")
public class PGTS0005Service {
private static final Logger logger = LoggerFactory.getLogger(PGTS0005Service.class);
	
	@Resource(name = "filesDAO")
	private FileDAO fileDao;
	
	/**
	 * 파일업로드 인덱스
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {		
		ModelAndView mv = new ModelAndView();		
		mv.setViewName("/www/test/TS_index");		
		return mv;
	}
	
	/**
	 * 파일업로드 입력
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView insertFile(Map<?, ?> rqstMap) throws Exception {		
		ModelAndView mv = new ModelAndView();
		
		MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)rqstMap.get(GlobalConst.RQST_MULTIPART);	
		List<MultipartFile> multipartFiles = mptRequest.getFiles("file");		
		List<FileVO> fileList = new ArrayList<FileVO>();
		fileList = UploadHelper.upload(multipartFiles, "test");
		int fileSeq = fileDao.saveFile(fileList, 0);        
		logger.debug("fileSeq: "+fileSeq);
		
		mv.setViewName("/www/test/TS_index");		
		return mv;
	}
	
	/**
	 * 파일업로드 수정
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView updateFile(Map<?, ?> rqstMap) throws Exception {		
		ModelAndView mv = new ModelAndView();
		
		MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)rqstMap.get(GlobalConst.RQST_MULTIPART);	
		List<MultipartFile> multipartFiles = mptRequest.getFiles("file");		
		List<FileVO> fileList = new ArrayList<FileVO>();
		fileList = UploadHelper.upload(multipartFiles, "test");
		int fileSeq = fileDao.saveFile(fileList, 1000);        
		logger.debug("fileSeq: "+fileSeq);
		
		mv.setViewName("/www/test/TS_index");		
		return mv;
	}
}
