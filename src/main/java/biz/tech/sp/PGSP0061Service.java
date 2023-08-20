package biz.tech.sp;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.comm.user.EntUserVO;
import com.comm.user.UserVO;
import com.infra.file.FileDAO;
import com.infra.file.FileVO;
import com.infra.file.UploadHelper;
import com.infra.system.GlobalConst;
import com.infra.util.ArrayUtil;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;
import biz.tech.so.PGSO0120Service;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.my.EmpmnMapper;
import biz.tech.mapif.so.PGSO0120Mapper;
import biz.tech.mapif.sp.PGSP0061Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

/**
 * 기업정책
 * @author DST
 *
 */
@Service("PGSP0061")
public class PGSP0061Service extends EgovAbstractServiceImpl {
	private static final Logger logger = LoggerFactory.getLogger(PGSO0120Service.class);
	
	private Locale locale = Locale.getDefault();
	
	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	/** ID Generation */
	@Resource(name="egovLqttEmailIdGnrService")
	private EgovIdGnrService idgenService;
	
	@Resource(name="PGSO0120Mapper")
	private PGSO0120Mapper pgso0120Dao;
	
	@Resource(name="PGSP0061Mapper")
	private PGSP0061Mapper pgsp0061Dao;
	
	@Resource(name = "filesDAO")
	private FileDAO fileDao;
	
	@Resource(name="empmnMapper")
	private EmpmnMapper empmnDAO;
	
	
	/**
	 * 서비스운영관리 > 대량메일관리
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		// 검색조건
		param.put("search_type", MapUtils.getString(rqstMap, "search_type"));
		param.put("search_word", MapUtils.getString(rqstMap, "search_word"));
		
		// 대량메일관리 리스트 카운트
		int totalRowCnt = pgsp0061Dao.selectGalleryBoardCount(param);
		
		// 페이지 설정
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");

		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		// 대량메일관리 리스트 조회
		List<Map> resultList = new ArrayList<Map>();
		resultList = pgsp0061Dao.selectGalleryBoardInfo(param);
		
		mv.addObject("pager", pager);
		mv.addObject("resultList", resultList);
		
		mv.setViewName("/admin/sp/BD_UISPU0061");
		
		return mv;
	}
	
	/**
	 * 갤러리 게시판 등록
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView insertGalleryBoard(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> req = new HashMap<String, Object>();
		
		//로그인 객체 선언
		UserVO userVo = SessionUtil.getUserInfo();
		
		String lqttEmailId			= idgenService.getNextStringId();
		String subjBoard 				= MapUtils.getString(rqstMap, "subjBoard","");
		String descBoard 				= MapUtils.getString(rqstMap, "descBoard","");
		String dateBoard 			= MapUtils.getString(rqstMap, "dateBoard","");
		String imgFile				= MapUtils.getString(rqstMap, "imgFile","");
		String urlBoard				= MapUtils.getString(rqstMap, "urlBoard","");
		String type				= MapUtils.getString(rqstMap, "type","");
		String userNo				= userVo.getUserNo();
		
		req.put("SUBJ_BOARD", subjBoard);
		req.put("DESC_BOARD", descBoard);
		req.put("DATE_BOARD",dateBoard);
		req.put("IMG_FILE",imgFile);
		req.put("URL_BOARD", urlBoard);
		req.put("REGISTER", userNo);
		req.put("UPDUSR", userNo);
		req.put("TYPE", type);
		
		pgsp0061Dao.insertGalleryBoard(req);
		

		Map<String, Object> param = new HashMap<String, Object>();
		
		// 검색조건
		param.put("search_type", MapUtils.getString(rqstMap, "search_type"));
		param.put("search_word", MapUtils.getString(rqstMap, "search_word"));
		
		// 대량메일관리 리스트 카운트
		int totalRowCnt = pgsp0061Dao.selectGalleryBoardCount(param);
		
		// 페이지 설정
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");

		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		// 대량메일관리 리스트 조회
		List<Map> resultList = new ArrayList<Map>();
		resultList = pgsp0061Dao.selectGalleryBoardInfo(param);
		
		mv.addObject("pager", pager);
		mv.addObject("resultList", resultList);
		
		mv.setViewName("/admin/sp/BD_UISPU0061");
		
		mv.addObject("resultMsg", messageSource.getMessage("success.common.insert", new String[] {"갤러리 게시판"}, locale));
		
		return mv;
	}
	
	/**
	 * 첨부사진 업로드
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processAtchPhoto(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		Map<String,Object> dataMap = new HashMap<String,Object>();
		FileVO fileVO = null;
		int fileSeq = -1;
		int resultFileSeq = 0;
		boolean dataExst = false;
		
		UserVO userVO = SessionUtil.getUserInfo();
		String bizrNo = "";
		String userNo = userVO.getUserNo();
		
		if(isAdminAuth(userVO)) {
//			bizrNo = MapUtils.getString(rqstMap, "ad_bizrno");
			userNo = MapUtils.getString(rqstMap, "USER_NO");
		}else {
			EntUserVO entUserVO = SessionUtil.getEntUserInfo();
//			bizrNo = entUserVO.getBizrno();
		}
		
		bizrNo = pgsp0061Dao.getMaxBizSeq(); 
				
		param.put("USER_NO", userNo);
		param.put("BIZRNO", bizrNo);

		logger.debug("@@" + param);

		//파일 seq 조회
		dataMap = empmnDAO.findCmpnyIntrcnInfo(param);
		fileSeq = MapUtils.getInteger(dataMap, "LOGO_FILE_SN", -1);
		
		//INSERT, UPDATE 여부 결정
		if(Validate.isNotEmpty(MapUtils.getString(dataMap, "USER_NO"))) {
			dataExst = true;
		}
		
		//파일업로드
		List<FileVO> fileList = new ArrayList<FileVO>();		
		MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) MapUtils.getObject(rqstMap, GlobalConst.RQST_MULTIPART);		
    	List<MultipartFile> multiFiles = multiRequest.getFiles("multipartFile");
    	fileList = UploadHelper.upload(multiFiles, "company");
    	
    	//기존 첨부파일 삭제
    	if(fileSeq != -1) {
    		fileDao.removeFile(fileSeq);
    	}
    	fileSeq = fileDao.saveFile(fileList, fileSeq);
    	
    	//업로드 성공시 DB변경
    	if(fileList.size() > 0 && fileSeq > -1) {
    		fileVO = fileList.get(0);
    		
    		param.put("LOGO_FILE_SN", fileSeq);
    		param.put("LOGO_FILE_NM", fileVO.getLocalNm());
    		
    		if(dataExst) {
    			empmnDAO.updateAtchPhoto(param);
    		}else{
    			empmnDAO.insertAtchPhoto(param);
    		}
    		
    		resultFileSeq = fileVO.getFileSeq();
    	}
				
    	return ResponseUtil.responseText(mv, resultFileSeq);
	}
	
	/**
	 * 관리자 세션체크
	 * @return
	 */
	public boolean isAdminAuth(UserVO userVo) {
		boolean isAdmin = false;
		
		if(Validate.isEmpty(userVo)) {
			isAdmin = false;
		}else {
			String[] authorGroupCode = userVo.getAuthorGroupCode();
			
			if(	ArrayUtil.contains(authorGroupCode, GlobalConst.AUTH_DIV_ADM) ) {
				isAdmin = true;
			}
		}
		
		return isAdmin;
	}
	
	/**
	 * 메뉴수정화면
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getMenuModify(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		HashMap preParam = new HashMap();

		String SEQ = MapUtils.getString(rqstMap, "temp");
		
		param.put("SEQ", SEQ);
		Map menuInfo = pgsp0061Dao.findMenuInfo(param);
		
		
		/*String searchSiteSe = MapUtils.getString(rqstMap, "searchSiteSe");
		String searchMenuNm = MapUtils.getString(rqstMap, "searchMenuNm");
		int df_curr_page = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int df_row_per_page = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		int limitFrom = MapUtils.getIntValue(rqstMap, "limitFrom");
		int limitTo = MapUtils.getIntValue(rqstMap, "limitTo");
		
		preParam.put("df_curr_page", df_curr_page);
		preParam.put("df_row_per_page", df_row_per_page);
		preParam.put("limitFrom", limitFrom);
		preParam.put("limitTo", limitTo);
		preParam.put("searchSiteSe", searchSiteSe);
		preParam.put("searchMenuNm", searchMenuNm);*/
		

		ModelAndView mv = new ModelAndView();
		mv.addObject("menuInfo", menuInfo);
		//mv.addObject("preParam", preParam);
		mv.setViewName("/admin/sp/BD_UISPU0062");
		return mv;
	}
	
	/**
	 * 메뉴삭제
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView deleteMenu(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		
		String SEQ = MapUtils.getString(rqstMap, "SEQ");
		
		logger.debug("@@"+SEQ+"");
		param.put("SEQ", SEQ);
		pgsp0061Dao.deleteMenu(param);
		
		ModelAndView mv = new ModelAndView();

		mv.setViewName("/admin/sp/BD_UISPU0061");
		
		return mv;
	}
	
	/**
	 * 메뉴수정 저장
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processMenu(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> req = new HashMap<String, Object>();
		
		//로그인 객체 선언
		UserVO userVo = SessionUtil.getUserInfo();
		
		String lqttEmailId			= idgenService.getNextStringId();
		String subjBoard 				= MapUtils.getString(rqstMap, "subjBoard","");
		String descBoard 				= MapUtils.getString(rqstMap, "descBoard","");
		String dateBoard 			= MapUtils.getString(rqstMap, "dateBoard","");
		String imgFile				= MapUtils.getString(rqstMap, "imgFile","");
		String urlBoard				= MapUtils.getString(rqstMap, "urlBoard","");
		String type				= MapUtils.getString(rqstMap, "type","");
		String seq				= MapUtils.getString(rqstMap, "SEQ","");
		String userNo				= userVo.getUserNo();
		
		req.put("SUBJ_BOARD", subjBoard);
		req.put("DESC_BOARD", descBoard);
		req.put("DATE_BOARD",dateBoard);
		req.put("IMG_FILE",imgFile);
		req.put("URL_BOARD", urlBoard);
		req.put("REGISTER", userNo);
		req.put("UPDUSR", userNo);
		req.put("TYPE", type);
		req.put("SEQ", seq);
		
		pgsp0061Dao.updateGalleryBoard(req);

		
		Map<String, Object> param = new HashMap<String, Object>();
		
		// 검색조건
		param.put("search_type", MapUtils.getString(rqstMap, "search_type"));
		param.put("search_word", MapUtils.getString(rqstMap, "search_word"));
		
		// 대량메일관리 리스트 카운트
		int totalRowCnt = pgsp0061Dao.selectGalleryBoardCount(param);
		
		// 페이지 설정
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");

		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		// 대량메일관리 리스트 조회
		List<Map> resultList = new ArrayList<Map>();
		resultList = pgsp0061Dao.selectGalleryBoardInfo(param);
		
		mv.addObject("pager", pager);
		mv.addObject("resultList", resultList);
		
		mv.setViewName("/admin/sp/BD_UISPU0061");
		
		return mv;
	}
}
