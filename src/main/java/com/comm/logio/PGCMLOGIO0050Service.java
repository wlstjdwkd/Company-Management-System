package com.comm.logio;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.user.EntUserVO;
import com.comm.user.UserService;
import com.comm.user.UserVO;
import biz.tech.ic.PGIC0022Service;
import com.infra.file.FileDAO;
import com.infra.file.FileVO;
import com.infra.file.UploadHelper;
import com.infra.system.GlobalConst;
import com.infra.util.ArrayUtil;
import com.infra.util.JsonUtil;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.my.EmpmnMapper;
import biz.tech.mapif.ic.HpeCnfirmReqstMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 기업담당자변경신청
 * 
 * @author WJC
 *
 */
@Service("PGCMLOGIO0050")
public class PGCMLOGIO0050Service extends EgovAbstractServiceImpl
{
	private static final Logger logger = LoggerFactory.getLogger(PGCMLOGIO0050Service.class);
	
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Autowired
	UserService userService;
	
	@Resource(name = "filesDAO")
	private FileDAO fileDao;
	
	@Autowired
	HpeCnfirmReqstMapper hpeCnfirmReqstMapper;
	
	// 삭제예정
	@Resource(name="empmnMapper")
	private EmpmnMapper empmnDAO;
	
	/**
	 * 기업찾기 화면
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<?,?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		
		//mv.setViewName("/www/mb/BD_UIMBU0050");
		mv.setViewName("/www/comm/logio/BD_UICMLOGIOU0050");
		return mv;
	}
	
	/**
	 * 기업찾기 성공/실패
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView findEntUserForm(Map<?,?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		HashMap userInfo = new HashMap();
		
		/*String searchEntrprsNm = MapUtils.getString(rqstMap, "searchEntrprsNm");
		
		if(searchEntrprsNm == null || "".equals(searchEntrprsNm)) {
			searchEntrprsNm = "xxxxx";
		}
		
		param.put("searchEntrprsNm", searchEntrprsNm);*/
		
		String searchJurirno = MapUtils.getString(rqstMap, "searchJurirno");
		param.put("searchJurirno", searchJurirno);
		
		param.put("limitFrom", 0);
		param.put("limitTo", 9999);
		userInfo.put("searchJurirno", searchJurirno);
		
		List<Map> list = userService.findEntUserList(param);
		String entNm = null;
		
		if(Validate.isEmpty(list)) {
			// 기업찾기 실패
			//mv.setViewName("/www/mb/BD_UIMBU0052");
			mv.setViewName("/www/comm/logio/BD_UICMLOGIOU0052");
		} else {
			for(int i=0; i< list.size(); i++) {
				entNm = (String) list.get(i).get("entrprsNm");
				list.get(i).put("ENTRPRS_NM", entNm);
			}
			
			// 기업찾기 성공
			mv.addObject("userInfo", userInfo);
			mv.addObject("findEntUserList",list);
			//mv.setViewName("/www/mb/BD_UIMBU0051");
			mv.setViewName("/www/comm/logio/BD_UICMLOGIOU0051");
		}
		return mv;
	}
	
	
	/**
	 * 기업담당자정보 팝업
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView chargerInfo(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		Map<String,Object> dataMap = new HashMap<String,Object>();
		
		String userNo = MapUtils.getString(rqstMap, "ad_ep_no");
		String bizrNo = MapUtils.getString(rqstMap, "ad_bizrno");
		String se = MapUtils.getString(rqstMap, "ad_se");
		
		logger.debug(bizrNo);
		logger.debug(userNo);
		logger.debug(se);
		
		if(se == null || se.equals("")) {
			se = "1";
		}
		
		// 기업사용자번호
		param.put("USER_NO", userNo);
		param.put("BIZRNO", bizrNo);
		List<Map> list = userService.findEntCharger(param);
		
		if(Validate.isNotEmpty(list)) {
			//기존 담당자명
			String chargerNm = list.get(0).get("chargerNm").toString();
			chargerNm = chargerNm.substring(0, 1) + "*" + chargerNm.substring(2);
			dataMap.put("chargerNm", chargerNm);
			
			//담당자부서
			String chargerDept = list.get(0).get("chargerDept").toString();
			chargerDept = "*" + chargerDept.substring(1);
			dataMap.put("chargerDept", chargerDept);
			
			//직위
			String ofcps = "";
			if(list.get(0).get("ofcps") != null && !list.get(0).get("ofcps").toString().equals("")) {
				ofcps = list.get(0).get("ofcps").toString();
				ofcps = "*" + ofcps.substring(1);
				dataMap.put("ofcps", ofcps);
			} else {
				dataMap.put("ofcps", "");
			}
			
			//전화번호
			Map<String, String> fmtTelNum = StringUtil.telNumFormat((String) list.get(0).get("telno2"));
			dataMap.put("TELNO1", MapUtils.getString(fmtTelNum, "first", ""));
			if(MapUtils.getString(fmtTelNum, "middle", "") != null && !MapUtils.getString(fmtTelNum, "middle", "").equals("")) {
				dataMap.put("TELNO2", "***");
			} else {
				dataMap.put("TELNO2", MapUtils.getString(fmtTelNum, "middle", ""));
			}
			dataMap.put("TELNO3", MapUtils.getString(fmtTelNum, "last", ""));
			
			//휴대전화번호
			Map<String, String> fmtMbtNum = StringUtil.telNumFormat((String) list.get(0).get("mbtlnum"));
			dataMap.put("mbtlnum1", MapUtils.getString(fmtMbtNum, "first", ""));
			if(MapUtils.getString(fmtMbtNum, "middle", "") != null && !MapUtils.getString(fmtMbtNum, "middle", "").equals("")) {
				dataMap.put("mbtlnum2", "***");
			} else {
				dataMap.put("mbtlnum2", MapUtils.getString(fmtMbtNum, "middle", ""));
			}
			dataMap.put("mbtlnum3", MapUtils.getString(fmtMbtNum, "last", ""));
			
			//기존 담당자 이메일
			String email = list.get(0).get("email").toString();
			email = "***" + email.substring(3);
			dataMap.put("email", email);
		}
		
		mv.addObject("dataParam", param);
		mv.addObject("dataMap", dataMap);
		mv.addObject("findEntCharger",list);
		
		if(se.equals("1")) { // 담당자
			//mv.setViewName("/www/mb/PD_UIMBU0053");
			mv.setViewName("/www/comm/logio/PD_UICMLOGIOU0053");
		} else { // 기업명
			//mv.setViewName("/www/mb/PD_UIMBU0054");
			mv.setViewName("/www/comm/logio/PD_UICMLOGIOU0054");
		}
		
		return mv;		
		
	}
	
	
	/**
	 * 담당자변경신청 저장
	 * 
	 * @param rqstMap
	 * request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView processSaveRequest(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();		
		
		String sSe = MapUtils.getString(rqstMap, "ad_se");
		
		String sEntrprsNm = MapUtils.getString(rqstMap, "entrprsNm");
		
		String sJurirno = null;
		String sBizrno = null;
		String sAd_user_nm = null;
		String sAd_dept = null;
		String sAd_ofcps = null;
		String sAd_tel_first2 = null;
		String sAd_tel_middle2 = null;
		String sAd_tel_last2 = null;
		String sAd_phon_first = null;
		String sAd_phon_middle = null;
		String sAd_phon_last = null;
		String sAd_user_email = null;
		
		String sTelNum = null;
		String sMbphonNum = null;
		
		if(sSe.equals("1")) { // 담당자변경신청
			sJurirno = MapUtils.getString(rqstMap, "jurirno");
			sBizrno = MapUtils.getString(rqstMap, "bizrno");
			sAd_user_nm = MapUtils.getString(rqstMap, "ad_user_nm");
			sAd_dept = MapUtils.getString(rqstMap, "ad_dept");
			sAd_ofcps = MapUtils.getString(rqstMap, "ad_ofcps");
			sAd_tel_first2 = MapUtils.getString(rqstMap, "ad_tel_first2");
			sAd_tel_middle2 = MapUtils.getString(rqstMap, "ad_tel_middle2");
			sAd_tel_last2 = MapUtils.getString(rqstMap, "ad_tel_last2");
			sAd_phon_first = MapUtils.getString(rqstMap, "ad_phon_first");
			sAd_phon_middle = MapUtils.getString(rqstMap, "ad_phon_middle");
			sAd_phon_last = MapUtils.getString(rqstMap, "ad_phon_last");
			sAd_user_email = MapUtils.getString(rqstMap, "ad_user_email");
			
			sTelNum = sAd_tel_first2 + sAd_tel_middle2 + sAd_tel_last2;
			sMbphonNum = sAd_phon_first + sAd_phon_middle + sAd_phon_last;
		} else { // 기업명변경신청
			HashMap tparam = new HashMap();
			String sAd_user_no = MapUtils.getString(rqstMap, "ad_ep_no");
			tparam.put("USER_NO", sAd_user_no);
			
			List<Map> list = userService.findEntCharger(tparam);
			
			if(Validate.isNotEmpty(list)) {
				sJurirno = list.get(0).get("jurirno").toString();
				sBizrno = list.get(0).get("bizrno").toString();
				sAd_user_nm = list.get(0).get("chargerNm").toString();
				sAd_dept = list.get(0).get("chargerDept").toString();
				sAd_ofcps = list.get(0).get("ofcps").toString();
				sTelNum = list.get(0).get("telno2").toString();
				sMbphonNum = list.get(0).get("mbtlnum").toString();
				sAd_user_email = list.get(0).get("email").toString();
			}
			
		}
		
		Map<String, Object> param = new HashMap<String, Object>();		
		param.put("SE", sSe);
		param.put("ENTRPRS_NM", sEntrprsNm);
		param.put("JURIRNO", sJurirno);        
		param.put("BIZRNO", sBizrno);        
		param.put("CHARGER_NM", sAd_user_nm);        
		param.put("CHARGER_DEPT", sAd_dept);        
		param.put("OFCPS", sAd_ofcps);
		param.put("TELNO2", sTelNum);
		param.put("MBTLNUM", sMbphonNum);
		param.put("EMAIL", sAd_user_email);
		
		int result = userService.insertChangeEntCharger(param);		// 기업담당자정보 변경요청 등록
		int sn = userService.selectChangeEntChargerSn(param);		// 기업담당자정보 변경요청 등록번호
		
		param.put("SN", sn);
		
		//파일 업로드
		insertRfFile(param, rqstMap);
		
		insertEmail(param, rqstMap);
		
		Map outMap = new HashMap();
		outMap.put("result", Boolean.TRUE);
		//outMap.put("rceptNo", rceptNo);
		String jsonStr = JsonUtil.toJson(outMap);
		
		return ResponseUtil.responseText(mv,jsonStr);
		
	}
	
	/**
	 * 이메일 발송
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView insertEmail(Map mparam, Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		
		String sEntrprsNm = mparam.get("ENTRPRS_NM").toString();	// 담당자 변경신청 기업명
		String userNm = mparam.get("CHARGER_NM").toString();	// 변경신청 담당자
		String userEmail = mparam.get("EMAIL").toString();			// 변경신청 담당자 이메일
		String sSe = mparam.get("SE").toString();           // 구분(1:담당자, 2:기업명)
		
		param.put("userNm", userNm);
		param.put("email", userEmail);
		
		int resCnt = 0;
		int resCnt2 = 0;
		
		logger.debug("================GlobalConst.MASTER_EMAIL_ADDR(1):" + GlobalConst.MASTER_EMAIL_ADDR);
		// 변경신청한 담당자에게 메일 발송
		param.put("PRPOS", "U");
		if(sSe.equals("1")) {
			param.put("EMAIL_SJ", "[기업 정보] 담당자 변경요청 안내입니다.");
			param.put("TMPLAT_FILE_COURS", "TMPL_EMAIL_CH_CHARGER.html");
		} else {
			param.put("EMAIL_SJ", "[기업 정보] 기업명 변경요청 안내입니다.");
			param.put("TMPLAT_FILE_COURS", "TMPL_EMAIL_CH_ENTRPRSNM.html");
		}
		param.put("TMPLAT_USE_AT", "Y");
		param.put("SNDR_NM", "기업정보");
		param.put("SNDR_EMAIL_ADRES", GlobalConst.MASTER_EMAIL_ADDR);
		param.put("RCVER_NM", userNm);
		param.put("RCVER_EMAIL_ADRES", userEmail);
		param.put("SUBST_INFO3", "ENTPRS_NM::" + sEntrprsNm);
		param.put("SUBST_INFO4", "CHARGER_NM::" + userNm);
		param.put("SUBST_INFO5", "RCVER_EMAIL_ADRES::" + userEmail);
		param.put("SUBST_INFO6", "MASTER_EMAIL_ADDR::" + GlobalConst.MASTER_EMAIL_ADDR);
		param.put("SNDNG_STTUS", "R");
		
		resCnt = userService.insertEmail(param);
		
		logger.debug("================GlobalConst.MASTER_EMAIL_ADDR(2):" + GlobalConst.MASTER_EMAIL_ADDR);
		// 변경신청한 내용을 관리자에게 메일 발송
		param.put("PRPOS", "U");
		if(sSe.equals("1")) {
			param.put("EMAIL_SJ", "[기업 정보] 담당자 변경요청이 있습니다.");
			param.put("TMPLAT_FILE_COURS", "TMPL_EMAIL_CH_CHARGER_INFO.html");
		} else {
			param.put("EMAIL_SJ", "[기업 정보] 기업명 변경요청이 있습니다.");
			param.put("TMPLAT_FILE_COURS", "TMPL_EMAIL_CH_ENTRPRSNM_INFO.html");
		}
		param.put("TMPLAT_USE_AT", "Y");
		param.put("SNDR_NM", userNm);
		param.put("SNDR_EMAIL_ADRES", userEmail);
		param.put("RCVER_NM", "기업정보");
		param.put("RCVER_EMAIL_ADRES", GlobalConst.MASTER_EMAIL_ADDR);
		param.put("SUBST_INFO3", "ENTPRS_NM::" + sEntrprsNm);
		param.put("SUBST_INFO4", "CHARGER_NM::" + userNm);
		param.put("SUBST_INFO5", "CHARGER_DEPT::" + mparam.get("CHARGER_DEPT"));
		param.put("SUBST_INFO6", "OFCPS::" + mparam.get("OFCPS"));
		param.put("SUBST_INFO7", "MBTLNUM::" + mparam.get("MBTLNUM"));
		param.put("SUBST_INFO8", "MASTER_EMAIL_ADDR::" + GlobalConst.MASTER_EMAIL_ADDR);
		param.put("SNDNG_STTUS", "R");
		
		resCnt2 = userService.insertEmail(param);
		
		// 담당자와 관리자에게 둘다 메일발송 성공 시
		if(resCnt == StringUtil.ONE && resCnt2 == StringUtil.ONE) {
			return ResponseUtil.responseJson(mv, true);
		}
		
		return ResponseUtil.responseJson(mv, false);
		
	}
	
	/**
	 * SMS 전송
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	/*public ModelAndView insertMbtlNum(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		
		String userNm = MapUtils.getString(rqstMap, "ad_user_nm");
		String email = MapUtils.getString(rqstMap, "ad_user_email");
		
		param.put("userNm", userNm);
		param.put("email", email);
		
		List<Map> findUserId = userService.findUserId(param);
		int resCnt = 0;
		
		if(findUserId.size() < 2) {
			param.put("MT_REFKEY", findUserId.get(0).get("userNo"));
			param.put("CONTENT", "회원님의 아이디는 " + findUserId.get(0).get("loginId") + "입니다.");
			param.put("CALLBACK", GlobalConst.CSTMR_PHONE_NUM);
			param.put("RECIPIENT_NUM", findUserId.get(0).get("mbtlNum"));
			param.put("SERVICE_TYPE", 0);
			resCnt = userService.insertSms(param);
		}
		else {
			for(int i=0; i < findUserId.size(); i++) {
				param.put("MT_REFKEY", findUserId.get(i).get("userNo"));
				param.put("CONTENT", "회원님의 아이디는 " + findUserId.get(i).get("loginId") + "입니다.");
				param.put("CALLBACK", GlobalConst.CSTMR_PHONE_NUM);
				param.put("RECIPIENT_NUM", findUserId.get(i).get("mbtlNum"));
				param.put("SERVICE_TYPE", 0);
				resCnt = userService.insertSms(param);
			}
		}
		
		if(resCnt == StringUtil.ONE) {
			return ResponseUtil.responseJson(mv, true);
		}
		
		return ResponseUtil.responseJson(mv, false);
	}*/
	
	/**
	 * 첨부파일(제출서류) 저장
	 * 
	 * @param String id		입력파일 아이디
	 * @param RF rf			첨부파일 타입
	 * @param 
	 * @param Map param		DB param
	 * @param Map rqstMap
	 * @throws Exception
	 */
	private void insertRfFile(Map param, Map rqstMap) throws Exception {
		StringBuffer sb = new StringBuffer();
		
		MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)rqstMap.get(GlobalConst.RQST_MULTIPART);
		if(Validate.isEmpty(mptRequest)) {return;}
		
		// 사업자등록증 업로드
		sb = new StringBuffer();
		sb.append("file_ho_rf1");
		
		List<MultipartFile> multipartFiles = mptRequest.getFiles(sb.toString());
		if(Validate.isEmpty(multipartFiles)) {return;}
		if(multipartFiles.get(0).isEmpty()) {return;}
		
		List<FileVO> fileList = new ArrayList<FileVO>();
		fileList = UploadHelper.upload(multipartFiles, "charger", (String) param.get("JURIRNO"));
		int fileSeq = fileDao.saveFile(fileList,-1);
		
		// 재직증명서 업로드
		sb = new StringBuffer();
		sb.append("file_ho_rf2");
		
		List<MultipartFile> multipartFiles2 = mptRequest.getFiles(sb.toString());
		if(Validate.isEmpty(multipartFiles2)) {return;}
		if(multipartFiles2.get(0).isEmpty()) {return;}
		
		List<FileVO> fileList2 = new ArrayList<FileVO>();
		fileList2 = UploadHelper.upload(multipartFiles2, "charger", (String) param.get("JURIRNO"));
		int fileSeq2 = fileDao.saveFile(fileList2,-1);
		
		// 파일 업로드 성공
		if(fileList.size() > 0 && fileSeq > -1 && fileList2.size() > 0  && fileSeq2 > -1) {				
			param.put("FILE_SEQ", fileSeq);
			param.put("FILE_NM", fileDao.getFiles(fileSeq).get(0).getLocalNm());
			param.put("FILE_SEQ2", fileSeq2);
			param.put("FILE_NM2", fileDao.getFiles(fileSeq2).get(0).getLocalNm());
//			hpeCnfirmReqstMapper.insertReqstFile(param);
			
			// 파일업로드 성공 시 파일정보를 업데이트
			userService.updateChangeEntCharger(param);
//		// 파일 업로드 실패
    	}else {
//    		// 파일업로드 실패
			throw processException("errors.reqst.failtouploadfile");
//    		
    	}
	}
	
}
