package biz.tech.so;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.StringTokenizer;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import com.comm.page.Pager;
import com.comm.user.UserVO;
import com.infra.file.FileDAO;
import com.infra.file.FileVO;
import com.infra.file.UploadHelper;
import com.infra.system.GlobalConst;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.so.PGSO0120Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

/**
 * @author HSC
 */
@Service("PGSO0120")
public class PGSO0120Service extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(PGSO0120Service.class);
	
	private Locale locale = Locale.getDefault();
	
	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	/** ID Generation */
	@Resource(name="egovLqttEmailIdGnrService")
	private EgovIdGnrService idgenService;
	
	@Resource(name="PGSO0120Mapper")
	private PGSO0120Mapper pgso0120Dao;
	
	@Resource(name = "filesDAO")
	private FileDAO fileDao;
	
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
		int totalRowCnt = pgso0120Dao.selectLqttEmailInfoCount(param);
		
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
		resultList = pgso0120Dao.selectLqttEmailInfo(param);
		
		mv.addObject("pager", pager);
		mv.addObject("resultList", resultList);
		
		mv.setViewName("/admin/so/BD_UISOA0120");
		
		return mv;
	}
	
	/**
	 * 대량메일관리 상세조회
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView lqttEmailDetail(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> param = new HashMap<String, Object>();
		Map<String, Object> dataMap = new HashMap<String, Object>();
		
		String lqttEmailId = MapUtils.getString(rqstMap, "ad_lqtt_email_id"); // 대량메일아이디
		
		param.put("LQTT_EMAIL_ID", lqttEmailId);
		
		// 대량메일관리 상세조회
		dataMap = pgso0120Dao.selectLqttEmailInfoDetail(param);
		
		mv.addObject("dataMap", dataMap);
		
		mv.setViewName("/admin/so/BD_UISOA0122");
		
		return mv;
	}
	
	/**
	 * 대량메일관리 등록/수정 폼
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView lqttEmailWriteForm(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> param = new HashMap<String, Object>();
		Map<String, Object> dataMap = new HashMap<String, Object>();
		
		String lqttEmailId = MapUtils.getString(rqstMap, "ad_lqtt_email_id"); // 대량메일아이디
		String formType = MapUtils.getString(rqstMap, "ad_form_type"); // 입력 유형
		
		// 등록/수정 폼 구분
		if(Validate.isEmpty(formType)) {
			formType = "INSERT";
		}
		
		if(formType.equals("UPDATE")) {
			param.put("LQTT_EMAIL_ID", lqttEmailId);
			
			// 대량메일관리 상세조회
			dataMap = pgso0120Dao.selectLqttEmailInfoDetail(param);
		}
		
		mv.addObject("formType", formType);
		mv.addObject("dataMap", dataMap);
		
		mv.setViewName("/admin/so/BD_UISOA0121");
		
		return mv;
	}
	
	/**
	 * 대량메일관리 등록
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView insertLqttEmail(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> lqttEmailInfo = new HashMap<String, Object>();
		
		//로그인 객체 선언
		UserVO userVo = SessionUtil.getUserInfo();
		
		String lqttEmailId			= idgenService.getNextStringId();
		String emailSj 				= MapUtils.getString(rqstMap, "ad_email_sj","");
		String emailCn 				= MapUtils.getString(rqstMap, "ad_email_cn","");
		String userNo				= userVo.getUserNo();
		
		lqttEmailInfo.put("LQTT_EMAIL_ID", lqttEmailId);
		lqttEmailInfo.put("EMAIL_SJ",emailSj);
		lqttEmailInfo.put("EMAIL_CN",emailCn);
		lqttEmailInfo.put("REGISTER", userNo);
		lqttEmailInfo.put("UPDUSR", userNo);
		
		pgso0120Dao.insertLqttEmailInfo(lqttEmailInfo);
		
		// 대량메일관리 상세조회에 필요한 파라미터
		Map<String, Object> viewParam = new HashMap<String, Object>();
		viewParam.put("ad_lqtt_email_id", lqttEmailId);
		mv = lqttEmailDetail(viewParam);
		mv.addObject("resultMsg", messageSource.getMessage("success.common.insert", new String[] {"대량메일관리"}, locale));
		
		return mv;
	}
	
	/**
	 * 대량메일관리 수정
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView updateLqttEmail(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> lqttEmailInfo = new HashMap<String, Object>();
		
		//로그인 객체 선언
		UserVO userVo = SessionUtil.getUserInfo();
		
		String lqttEmailId			= MapUtils.getString(rqstMap, "ad_lqtt_email_id","");
		String emailSj 				= MapUtils.getString(rqstMap, "ad_email_sj","");
		String emailCn 				= MapUtils.getString(rqstMap, "ad_email_cn","");
		String userNo				= userVo.getUserNo();
		
		lqttEmailInfo.put("LQTT_EMAIL_ID", lqttEmailId);
		lqttEmailInfo.put("EMAIL_SJ",emailSj);
		lqttEmailInfo.put("EMAIL_CN",emailCn);
		lqttEmailInfo.put("UPDUSR", userNo);
		
		pgso0120Dao.updateLqttEmailInfo(lqttEmailInfo);
		
		// 대량메일관리 상세조회에 필요한 파라미터
		Map<String, Object> viewParam = new HashMap<String, Object>();
		viewParam.put("ad_lqtt_email_id", lqttEmailId);
		mv = lqttEmailDetail(viewParam);
		mv.addObject("resultMsg", messageSource.getMessage("success.common.update", new String[] {"대량메일관리"}, locale));
		
		return mv;
	}
	
	/**
	 * 대량메일관리 삭제
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView deleteLqttEmail(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> lqttEmailInfo = new HashMap<String, Object>();
		
		String lqttEmailId = MapUtils.getString(rqstMap, "ad_lqtt_email_id","");
		
		lqttEmailInfo.put("LQTT_EMAIL_ID", lqttEmailId);
		
		pgso0120Dao.deleteLqttEmailAllRcver(lqttEmailInfo);
		pgso0120Dao.deleteLqttEmailInfo(lqttEmailInfo);
		
		// 대량메일관리 목록조회에 필요한 파라미터
		Map<String, Object> viewParam = new HashMap<String, Object>();
		mv = index(viewParam);
		mv.addObject("resultMsg", messageSource.getMessage("success.common.delete", new String[] {"대량메일관리"}, locale));
		
		return mv;
	}
	
	/**
	 * 대량메일수신자 목록
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView lqttEmailRcverListPopup(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("LQTT_EMAIL_ID", MapUtils.getString(rqstMap, "ad_lqtt_email_id"));
		
		// 검색조건
		param.put("search_type", MapUtils.getString(rqstMap, "search_type"));
		
		// 대량메일수신자 리스트 카운트
		int totalRowCnt = pgso0120Dao.selectLqttEmailRcverCount(param);
		
		// 페이지 설정
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		// 대량메일수신자 리스트 조회
		List<Map> resultList = new ArrayList<Map>();
		resultList = pgso0120Dao.selectLqttEmailRcver(param);
		
		mv.addObject("pager", pager);
		mv.addObject("resultList", resultList);
		mv.addObject("ad_lqtt_email_id", MapUtils.getString(rqstMap, "ad_lqtt_email_id"));
		
		mv.setViewName("/admin/so/PD_UISOA0123");
		
		return mv;
	}
	
	/**
	 * 대량메일수신자 삭제
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView deleteLqttEmailRcver(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		String lqttEmailId = MapUtils.getString(rqstMap, "ad_lqtt_email_id","");
		param.put("LQTT_EMAIL_ID", lqttEmailId);
		
		if(rqstMap.get("chk_email_addr") instanceof String[]) {
			logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>111"+rqstMap.get("chk_email_addr"));
			param.put("emailList", rqstMap.get("chk_email_addr"));
		} else {
			logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>222"+rqstMap.get("chk_email_addr"));
			param.put("emailList", new String[] {(String)rqstMap.get("chk_email_addr")});
		}
		
		pgso0120Dao.deleteLqttEmailRcver(param);
		
		// 대량메일관리 목록조회에 필요한 파라미터
		Map<String, Object> viewParam = new HashMap<String, Object>();
		viewParam.put("ad_lqtt_email_id", lqttEmailId);
		mv = lqttEmailRcverListPopup(viewParam);
		mv.addObject("resultMsg", messageSource.getMessage("success.common.delete", new String[]{"이메일"}, Locale.getDefault()));
		
		return mv;
	}
	
	/**
	 * 대량메일수신자 등록 폼
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView insertLqttEmailRcverFormPopup(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("ad_lqtt_email_id", MapUtils.getString(rqstMap, "ad_lqtt_email_id"));
		
		mv.setViewName("/admin/so/PD_UISOA0124");
		
		return mv;
	}
	
	/**
	 * 회원 이메일 목록 조회
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectUserEmailList(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> param = new HashMap<String, Object>();
		
		List<Map> resultList = pgso0120Dao.selectUserEmailList(param);
		
		if(resultList == null || resultList.size() <= 0) {
			return ResponseUtil.responseJson(mv, false);
		}
		
		ArrayList emailList = new ArrayList();
		
		for(int i=0; i<resultList.size(); i++) {
			Map<String, Object> data = (Map<String, Object>)resultList.get(i);
			emailList.add(data.get("EMAIL"));
		}
		
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("emailList", emailList);
		
		return ResponseUtil.responseJson(mv, true, jsonMap);
	}
	
	/**
	 * 대량메일수신자 등록
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView insertLqttEmailRcver(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> param = null;
		ArrayList emailList = null;
		
		// 이메일 목록 TXT를 Array로 변환
		StringTokenizer token = new StringTokenizer(MapUtils.getString(rqstMap, "txtEmail"));
		
		int reject = 0;
		int dupl = 0;
		
		if(token.countTokens() > 0) {
			// 수신 거부 이메일 목록
			List resultList = pgso0120Dao.selectRejectUserEmailList(param);
			ArrayList rejectList = new ArrayList();
			for(int i=0; i<resultList.size(); i++) {
				Map<String, Object> data = (Map<String, Object>) resultList.get(i);
				rejectList.add(data.get("EMAIL"));
			}
			
			// 기 등록된 이메일 목록
			param = new HashMap<String, Object>();
			param.put("LQTT_EMAIL_ID", MapUtils.getString(rqstMap, "ad_lqtt_email_id"));
			
			resultList = pgso0120Dao.selectDuplUserEmailList(param);
			ArrayList duplList = new ArrayList();
			for(int i=0; i<resultList.size(); i++) {
				Map<String, Object> data = (Map<String, Object>)resultList.get(i);
				duplList.add(data.get("EMAIL"));
			}

			// 일반 회원 이메일 목록
			resultList = pgso0120Dao.selectGnUserEmailList(param);
			ArrayList gnUserList = new ArrayList();
			for(int i=0; i<resultList.size(); i++) {
				Map<String, Object> data = (Map<String, Object>)resultList.get(i);
				gnUserList.add(data.get("EMAIL"));
			}
			
			// 기업 회원 이메일 목록
			resultList = pgso0120Dao.selectEpUserEmailList(param);
			ArrayList epUserList = new ArrayList();
			for(int i=0; i<resultList.size(); i++) {
				Map<String, Object> data = (Map<String, Object>)resultList.get(i);
				epUserList.add(data.get("EMAIL"));
			}
			
			// 이메일주소 검증
			emailList = new ArrayList();
			while(token.hasMoreElements()) {
				String email = token.nextToken();

				// 수신거부 검증
				if(rejectList.contains(email)) {
					reject++;
					continue;
				}
				
				// 기 등록 검증
				if(duplList.contains(email)) {
					dupl++;
					continue;
				}
				
				param = new HashMap<String, Object>();
				param.put("LQTT_EMAIL_ID", MapUtils.getString(rqstMap, "ad_lqtt_email_id"));
				param.put("RCVER_EMAIL", email);

				// 대상자분류
				if(gnUserList.contains(email)) {
					// 개인(일반)
					param.put("RCVER_CL", "1");
				} else if(epUserList.contains(email)) {
					// 기업
					param.put("RCVER_CL", "2");
				} else {
					// 직접입력
					param.put("RCVER_CL", "3");
				}
				
				emailList.add(param);
			}
		}
		
		// 저장처리
		param = new HashMap<String, Object>();
		param.put("ad_lqtt_email_id", MapUtils.getString(rqstMap, "ad_lqtt_email_id"));
		if(emailList != null && emailList.size() > 0) param.put("emailList", emailList);
		
		// 이메일 등록
		List<Map> insertEmailList = (List)param.get("emailList");
		if(insertEmailList != null && insertEmailList.size() > 0) {
			for(Map map : insertEmailList) {
				pgso0120Dao.insertLqttEmailRcver(map);
			}
		}
		
		mv = lqttEmailRcverListPopup(rqstMap);
		
		if(reject > 0 || dupl > 0) {
			mv.addObject("resultMsg", messageSource.getMessage("success.common.insert", new String[]{"발송정보 일부(수신거부:"+reject+", 중복주소:"+dupl+"제외)"}, Locale.getDefault()));
		} else {
			mv.addObject("resultMsg", messageSource.getMessage("success.common.insert", new String[]{"발송정보"}, Locale.getDefault()));
		}
		
		return mv;
	}
	
	/**
	 * 선택 이메일 발송 요청
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView insertCheckedLqttEmail(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> param = null;
		ArrayList emailList = null;
		String[] chkEamilAddr = null;
		
		if(rqstMap.get("chk_email_addr") instanceof String[]) {
			chkEamilAddr = (String[])rqstMap.get("chk_email_addr");
		} else {
			chkEamilAddr = new String[] {(String)rqstMap.get("chk_email_addr")};
		}
		
		if(chkEamilAddr.length > 0) {
			// 설문정보 조회
			param = new HashMap<String, Object>();
			param.put("LQTT_EMAIL_ID", MapUtils.getString(rqstMap, "ad_lqtt_email_id"));
			
			Map<String, Object> resultInfo = pgso0120Dao.selectLqttEmailInfoDetail(param);
			
			// 발송정보
			emailList = new ArrayList();
			
			for(int i=0; i<chkEamilAddr.length; i++) {
				String email = chkEamilAddr[i];
				
				param = new HashMap();
				param.put("PRPOS", "L");
				param.put("EMAIL_SJ", MapUtils.getString(resultInfo, "EMAIL_SJ"));
				param.put("EMAIL_CN", MapUtils.getString(resultInfo, "EMAIL_CN"));
				param.put("TMPLAT_USE_AT", "N");
				param.put("SNDR_EMAIL_ADRES", GlobalConst.MASTER_EMAIL_ADDR);
				param.put("RCVER_EMAIL_ADRES", email);
				param.put("SNDNG_STTUS", "R");
				param.put("PARAMTR1", MapUtils.getString(rqstMap, "ad_lqtt_email_id"));
				
				emailList.add(param);
			}
			
			// 저장처리
			param = new HashMap();
			param.put("emailList", emailList);
			insertLqttRequestSendEmail(param);
		}
		
		mv = lqttEmailRcverListPopup(rqstMap);
		
		mv.addObject("resultMsg", messageSource.getMessage("success.request.msg", new String[]{}, Locale.getDefault()));
		
		return mv;
	}

	/**
	 * 전체 이메일 발송 요청
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView insertAllLqttEmail(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> param = null;
		ArrayList emailList = null;
		
		// 설문정보 조회
		param = new HashMap<String, Object>();
		param.put("LQTT_EMAIL_ID", MapUtils.getString(rqstMap, "ad_lqtt_email_id"));
		
		// 검색조건
		param.put("search_type", MapUtils.getString(rqstMap, "search_type"));
				
		ArrayList rqstEmailAddr = (ArrayList)pgso0120Dao.selectAllLqttEmailRcver(param);
		
		if(rqstEmailAddr.size() > 0) {
			Map resultInfo = pgso0120Dao.selectLqttEmailInfoDetail(param);
			
			// 발송정보
			emailList = new ArrayList();
			
			for(int i=0; i<rqstEmailAddr.size(); i++) {
				String email = (String)rqstEmailAddr.get(i);
				
				param = new HashMap();
				param.put("PRPOS", "L");
				param.put("EMAIL_SJ", MapUtils.getString(resultInfo, "EMAIL_SJ"));
				param.put("EMAIL_CN", MapUtils.getString(resultInfo, "EMAIL_CN"));
				param.put("TMPLAT_USE_AT", "N");
				param.put("SNDR_EMAIL_ADRES", GlobalConst.MASTER_EMAIL_ADDR);
				param.put("RCVER_EMAIL_ADRES", email);
				param.put("SNDNG_STTUS", "R");
				param.put("PARAMTR1", MapUtils.getString(rqstMap, "ad_lqtt_email_id"));
				
				emailList.add(param);
			}
			
			// 저장처리
			param = new HashMap();
			param.put("emailList", emailList);
			insertLqttRequestSendEmail(param);
		}
		
		mv = lqttEmailRcverListPopup(rqstMap);
		
		mv.addObject("resultMsg", messageSource.getMessage("success.request.msg", new String[]{}, Locale.getDefault()));
		
		return mv;
	}
	
	/**
     * 이메일 발송요청
     * @param param
     * @return 
     * @throws Exception
     */
	private void insertLqttRequestSendEmail(Map param) throws Exception {
		// 이메일 등록
		List<Map> emailList = (List)param.get("emailList");
		if(emailList == null || emailList.size() <= 0) return;
		
		for(Map map : emailList) {
			pgso0120Dao.insertLqttRequestSendEmail(map);
		}
	}
	
	/**
	 * 에디터 업로드
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processUploadEditor(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> fileResult = insertImageFile(rqstMap);
		
		mv.addObject("CKEditor", rqstMap.get("CKEditor"));
		mv.addObject("CKEditorFuncNum", rqstMap.get("CKEditorFuncNum"));
		mv.addObject("langCode", rqstMap.get("langCode"));
		mv.addObject("fileUrl", fileResult.get("fileUrl"));
		
		mv.setViewName("/cmm/ND_UICMC0008");
		
		return mv;
	}

	/**
	 * 파일(이미지) 업로드
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	private Map<String, Object> insertImageFile(Map<?, ?> rqstMap) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		
		StringBuffer sb = new StringBuffer();
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();	
		
		MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)rqstMap.get(GlobalConst.RQST_MULTIPART);
		if(Validate.isEmpty(mptRequest)) {
			result.put("result", "N");
			return result;
		}
		
		sb = new StringBuffer();
		sb.append("upload");
		
		List<MultipartFile> multipartFiles = mptRequest.getFiles(sb.toString());
		if(Validate.isEmpty(multipartFiles)) {
			result.put("result", "N");
			return result;
		}
		if(multipartFiles.get(0).isEmpty()) {
			result.put("result", "N");
			return result;
		}
		
		List<FileVO> fileList = new ArrayList<FileVO>();
		fileList = UploadHelper.upload(multipartFiles, "editor");
		int fileSeq = fileDao.saveFile(fileList,-1);
			
		// 파일 업로드 성공
		if(fileList.size() > 0 && fileSeq > -1) {
			result.put("fileUrl", request.getRequestURL().toString().replace(request.getRequestURI(),"")+"/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=" + fileSeq);
			result.put("result", "Y");
			return result;
		// 파일 업로드 실패
		} else {
			result.put("result", "N");
			return result;
		}
	}
}
