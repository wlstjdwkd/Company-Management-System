package biz.tech.sc;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.comm.user.UserService;
import com.infra.file.FileDAO;
import com.infra.file.FileVO;
import com.infra.file.UploadHelper;
import com.infra.system.GlobalConst;
import com.infra.util.RandomNumber;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;
import com.infra.util.crypto.Crypto;
import com.infra.util.crypto.CryptoFactory;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

@Service("PGSC0030")
public class PGSC0030Service extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(PGSC0030Service.class);

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;

	@Autowired
	UserService userService;
	
	@Resource(name = "filesDAO")
	private FileDAO fileDao;
	
	/**
	 * 리스트 띄워주는 index
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		param = (Map<String, Object>) rqstMap;
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		logger.debug("param1 : "+param);
		
		int totalRowCnt = userService.selectChangeChargerCnt(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		List<Map> userList = userService.selectChangeCharger(param);
		
		logger.debug("param2 : "+param);
		logger.debug("^^^^^^^^^^^^^^^userList : "+userList);
		
		Map numMap = new HashMap();
		String num = null;
		
		for(int i=0; i<userList.size(); i++) {
			if(Validate.isNull(userList.get(i).get("TELNO2"))) {		// 담당자 일반전화 처리
				num="";
			} else {
				numMap = StringUtil.telNumFormat(userList.get(i).get("TELNO2").toString());
				//if(Validate.isNotEmpty(numMap.get("middle"))) {
					num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last");
				//}
			}
			userList.get(i).put("TELNO2", num);
			
			if(Validate.isNull(userList.get(i).get("MBTLNUM"))) {		// 담당자 휴대전화 처리
				num="";
			} else {
				numMap = StringUtil.telNumFormat(userList.get(i).get("MBTLNUM").toString());
				//if(Validate.isNotEmpty(numMap.get("middle"))) {
					num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last");
				//}
			}
			userList.get(i).put("MBTLNUM", num);
		}
		
		mv.addObject("pager", pager);
		mv.addObject("userList", userList);		
		mv.setViewName("/admin/sc/BD_UISCA0030");
		
		return mv;
	}
	
	// 파일 업로드
	public ModelAndView insertFile(Map<?, ?> rqstMap) throws Exception {		
		ModelAndView mv = new ModelAndView();
		
		MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)rqstMap.get(GlobalConst.RQST_MULTIPART);	
		List<MultipartFile> multipartFiles = mptRequest.getFiles("file");	
		
		logger.debug("-------------------------multipartFiles"+multipartFiles);
		
		List<FileVO> fileList = new ArrayList<FileVO>();
		fileList = UploadHelper.upload(multipartFiles, "test");
		
		logger.debug("^^^^^^^^^^^^^^^^^fileList:"+fileList);
		
		int fileSeq = fileDao.saveFile(fileList, 0);        
		logger.debug("fileSeq: "+fileSeq);
		
		mv.addObject("fileSeq",fileSeq);
		mv.setViewName("/admin/sc/BD_UISCA0030");		
		return mv;
	}
}
