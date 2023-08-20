package biz.tech.my;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.issue.CertIssueService;
import com.comm.issue.CertIssueVo;
import com.comm.page.Pager;
import com.comm.user.EntUserVO;
import com.comm.user.UserVO;
import biz.tech.ic.PGIC0022Service;
import com.infra.file.FileDAO;
import com.infra.file.FileVO;
import com.infra.file.UploadHelper;
import com.infra.system.GlobalConst;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.ic.HpeCnfirmReqstMapper;
import biz.tech.mapif.im.IssueStatusMngMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

@Service("PGMY0060")
public class PGMY0060Service extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGMY0060Service.class);

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;
	
	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	@Autowired
	IssueStatusMngMapper issueStatusMngMapper;
	
	@Autowired
	HpeCnfirmReqstMapper hpeCnfirmReqstMapper;
	
	@Autowired
	PGIC0022Service pgic0022;
	
	@Resource(name = "filesDAO")
	private FileDAO fileDao;
	
	@Autowired
	CertIssueService certissueService;
	
	/**
	 * 확인서신청내역
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/www/my/BD_UIMYU0060");					
		Map param = new HashMap();
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		
		EntUserVO entUserVo = SessionUtil.getEntUserInfo();
		String jurirno = entUserVo.getJurirno();				
		param.put("JURIRNO", jurirno);		
		// 임시저장 포함.
		param.put("INCLS_TMPR_SAVE", "Y");	
		
		// 총 발급업무관리 글 개수
		int totalRowCnt = issueStatusMngMapper.selectIssueTaskMngTotCnt(param);
		
		// 전체 글 출력
		int rowSize = totalRowCnt;
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();		
		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());			
		
		// 발급업무관리 글 조회
		List<Map> issueTaskMng = issueStatusMngMapper.selectIssueTaskMng(param);		
		
		for(Map map : issueTaskMng) {
			String rceptNo = MapUtils.getString(map, "RCEPT_NO");
			param = new HashMap();
			param.put("RCEPT_NO", rceptNo);
			param.put("RESN_SE", GlobalConst.RESN_SE_S);
			Map resnSMap = issueStatusMngMapper.selectLastestResn(param);
			if(Validate.isNotEmpty(resnSMap)) {
				map.put("SE_CODE_S", resnSMap.get("SE_CODE"));
				map.put("SE_CODE_NM_S", resnSMap.get("SE_CODE_NM"));
			}
			
			param.put("RESN_SE", GlobalConst.RESN_SE_R);
			Map resnRMap = issueStatusMngMapper.selectLastestResn(param);
			if(Validate.isNotEmpty(resnRMap)) {
				map.put("SE_CODE_R", resnRMap.get("SE_CODE"));
				map.put("SE_CODE_NM_R", resnRMap.get("SE_CODE_NM"));
			}
		}
		
		// 데이터 추가		
		mv.addObject("pager", pager);
		mv.addObject("issueTaskMng", issueTaskMng);
				
		return mv;
	}
	
	/**
	 * 재발급신청 상세보기
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView isgnResultView(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv;
		String authFlag  = MapUtils.getString(rqstMap, "auth");
		if(authFlag != null && authFlag.equals("Y"))
			mv = new ModelAndView("/admin/im/PD_UIIMA0018");
		else
			mv = new ModelAndView("/www/my/PD_UIMYU0065");
		Map param = new HashMap();
		
		String rceptNo  = MapUtils.getString(rqstMap, "ad_load_rcept_no");
		String upperRceptNo = "";
		
		Map<String,Object> applyEntInfo = new HashMap<String,Object>();	
		List<Map> bizrnoFormatList =new ArrayList<Map>();	// 사업자등록번호 리스트
		
		param.put("RCEPT_NO", rceptNo);
		param.put("ENTRPRS_SE", GlobalConst.ENTRPRS_SE_O);
		
		// 신청접수마스터
		Map applyMaster	= hpeCnfirmReqstMapper.selectApplyMaster(param);
		// 재발급기초정보
		Map isgnBsisInfo = hpeCnfirmReqstMapper.selectIsgnBsisInfo(param);
		// 복수사업자번호
		String[] compnoBizrnoArr = hpeCnfirmReqstMapper.selectCompnoBizrnoManage(param);
		
		
		// 부모접수번호의 기초정보, 주요정보 조회
		upperRceptNo = MapUtils.getString(applyMaster, "UPPER_RCEPT_NO");	
		param.put("RCEPT_NO", upperRceptNo);		
		// 신청기업기초정보
		Map issuBsisInfo = hpeCnfirmReqstMapper.selectIssuBsisInfo(param);
		// 신청기업업주요정보				
		Map reqstRcpyList = (Map) hpeCnfirmReqstMapper.selectReqstRcpyList(param).get(0);
		
		// 법인등록번호
		String jurirnoApply = MapUtils.getString(reqstRcpyList, "JURIRNO");
		if(Validate.isNotEmpty(jurirnoApply)) {
			Map jurirnoFormat = StringUtil.toJurirnoFormat(jurirnoApply);					
			reqstRcpyList.put("JURIRNO_FIRST", jurirnoFormat.get("first"));
			reqstRcpyList.put("JURIRNO_LAST", jurirnoFormat.get("last"));
		}
		
		reqstRcpyList.put("ENTRPRS_NM", MapUtils.getString(isgnBsisInfo, "ENTRPS_NM"));			
		issuBsisInfo.put("RPRSNTV_NM", MapUtils.getString(isgnBsisInfo, "RPRSNTV_NM"));
		issuBsisInfo.put("ZIP", MapUtils.getString(isgnBsisInfo, "ZIP"));
		issuBsisInfo.put("HEDOFC_ADRES", MapUtils.getString(isgnBsisInfo, "HEDOFC_ADRES"));
		issuBsisInfo.put("REPRSNT_TLPHON", MapUtils.getString(isgnBsisInfo, "REPRSNT_TLPHON"));
		issuBsisInfo.put("FXNUM", MapUtils.getString(isgnBsisInfo, "FXNUM"));
		
		issuBsisInfo.put("ENTRPRS_NM_CHANGE_AT", MapUtils.getString(isgnBsisInfo, "ENTRPRS_NM_CHANGE_AT"));
		issuBsisInfo.put("QY_CPTL_AT", MapUtils.getString(isgnBsisInfo, "QY_CPTL_AT"));
		issuBsisInfo.put("BIZRNO_ADIT_AT", MapUtils.getString(isgnBsisInfo, "BIZRNO_ADIT_AT"));
		
		for(String compnoBizrno : compnoBizrnoArr) {
			if(Validate.isNotEmpty(compnoBizrno)) {					
				bizrnoFormatList.add(StringUtil.toBizrnoFormat(compnoBizrno));			
			}
		}
		
		// 우편번호				
		String zip = MapUtils.getString(issuBsisInfo, "ZIP");
		if(!Validate.isEmpty(zip)) {
			/*
			issuBsisInfo.put("ZIP_FIRST", zip.substring(0, 4));
			issuBsisInfo.put("ZIP_LAST", zip.substring(4));
			*/
			// 2015.08.01부로 우편번호가 5자리로 변경
			issuBsisInfo.put("ZIP_FIRST", zip.replace("-", ""));
		}
		
		// 전화번호
		String telNum = MapUtils.getString(issuBsisInfo, "REPRSNT_TLPHON");
		if(!Validate.isEmpty(telNum)) {
			Map telNumFormat = StringUtil.telNumFormat(telNum);					
			issuBsisInfo.put("REPRSNT_TLPHON_FIRST", telNumFormat.get("first"));
			issuBsisInfo.put("REPRSNT_TLPHON_MIDDLE", telNumFormat.get("middle"));
			issuBsisInfo.put("REPRSNT_TLPHON_LAST", telNumFormat.get("last"));
		}				
	
		// 팩스번호
		String faxNum = MapUtils.getString(issuBsisInfo, "FXNUM");
		if(!Validate.isEmpty(faxNum)) {
			Map faxNumFormat = StringUtil.telNumFormat(faxNum);					
			issuBsisInfo.put("FXNUM_FIRST", faxNumFormat.get("first"));
			issuBsisInfo.put("FXNUM_MIDDLE", faxNumFormat.get("middle"));
			issuBsisInfo.put("FXNUM_LAST", faxNumFormat.get("last"));
		}
		
		applyEntInfo.put("applyMaster", applyMaster);
		applyEntInfo.put("issuBsisInfo", issuBsisInfo);
		applyEntInfo.put("reqstRcpyList", reqstRcpyList);
		applyEntInfo.put("bizrnoFormatList", bizrnoFormatList);
		applyEntInfo.put("isgnBsisInfo", isgnBsisInfo);
		
		mv.addObject("applyEntInfo", applyEntInfo);
				
		return mv;
	}
		
	/**
	 * 확인서재발급 등록폼
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView issueAgainForm(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/www/my/PD_UIMYU0064");					
		Map param = new HashMap();
		
		String loadRceptNo = MapUtils.getString(rqstMap, "ad_load_rcept_no");		// upper 신청번호
		String aginRceptNo = MapUtils.getString(rqstMap, "ad_again_rcept_no");		// 재발급 신청번호
		
		boolean isPs3 = false;		// 보완접수 여부
		
		param.put("RCEPT_NO", loadRceptNo);
		param.put("ENTRPRS_SE", GlobalConst.ENTRPRS_SE_O);
		
		Map<String,Object> applyEntInfo = new HashMap<String,Object>();				
		
		// 신청접수마스터
		Map applyMaster	= hpeCnfirmReqstMapper.selectApplyMaster(param);
		// 신청기업기초정보
		Map issuBsisInfo = hpeCnfirmReqstMapper.selectIssuBsisInfo(param);
		// 신청기업업주요정보				
		Map reqstRcpyList = (Map) hpeCnfirmReqstMapper.selectReqstRcpyList(param).get(0);
		// 사업자등록번호 리스트
		List<Map> bizrnoFormatList =new ArrayList<Map>();
		// 재발급여부
		String isgnAt = MapUtils.getString(applyMaster, "ISGN_AT", "N");
		
		// 법인등록번호
		String jurirnoApply = MapUtils.getString(reqstRcpyList, "JURIRNO");
		if(Validate.isNotEmpty(jurirnoApply)) {
			Map jurirnoFormat = StringUtil.toJurirnoFormat(jurirnoApply);					
			reqstRcpyList.put("JURIRNO_FIRST", jurirnoFormat.get("first"));
			reqstRcpyList.put("JURIRNO_LAST", jurirnoFormat.get("last"));
		}
		
		// 재발급신청 보완접수의 경우
		if(Validate.isNotEmpty(aginRceptNo)) {
			isPs3 = true;
		}
			
		// 재발급완료 또는 보완접수의 경우
		if(isgnAt.equals("Y") || isPs3) {
			Map isgnParam = new HashMap();
			
			if(isPs3) {
				isgnParam.put("RCEPT_NO", aginRceptNo);
				
			}else {				
				isgnParam.put("UPPER_RCEPT_NO", loadRceptNo);
				
				// 최근접수정보
				Map recentApply = hpeCnfirmReqstMapper.selectRecentApply(isgnParam);						
				String recentRceptNo = MapUtils.getString(recentApply, "RCEPT_NO");		// 최근발급처리된 접수번호
				isgnParam.put("RCEPT_NO", recentRceptNo);
			}
			
			// 재발급기초정보
			Map isgnBsisInfo = hpeCnfirmReqstMapper.selectIsgnBsisInfo(isgnParam);
			// 복수사업자번호
			String[] compnoBizrnoArr = hpeCnfirmReqstMapper.selectCompnoBizrnoManage(isgnParam);
			
			reqstRcpyList.put("ENTRPRS_NM", MapUtils.getString(isgnBsisInfo, "ENTRPS_NM"));			
			issuBsisInfo.put("RPRSNTV_NM", MapUtils.getString(isgnBsisInfo, "RPRSNTV_NM"));
			issuBsisInfo.put("ZIP", MapUtils.getString(isgnBsisInfo, "ZIP"));
			issuBsisInfo.put("HEDOFC_ADRES", MapUtils.getString(isgnBsisInfo, "HEDOFC_ADRES"));
			issuBsisInfo.put("REPRSNT_TLPHON", MapUtils.getString(isgnBsisInfo, "REPRSNT_TLPHON"));
			issuBsisInfo.put("FXNUM", MapUtils.getString(isgnBsisInfo, "FXNUM"));
			
			for(String compnoBizrno : compnoBizrnoArr) {
				if(Validate.isNotEmpty(compnoBizrno)) {					
					bizrnoFormatList.add(StringUtil.toBizrnoFormat(compnoBizrno));			
				}
			}
			
			// 보완접수의 경우 변경항목 및 첨부파일들 보여주기 위해
			if(isPs3) {
				issuBsisInfo.put("ENTRPRS_NM_CHANGE_AT", MapUtils.getString(isgnBsisInfo, "ENTRPRS_NM_CHANGE_AT"));
				issuBsisInfo.put("QY_CPTL_AT", MapUtils.getString(isgnBsisInfo, "QY_CPTL_AT"));
				issuBsisInfo.put("BIZRNO_ADIT_AT", MapUtils.getString(isgnBsisInfo, "BIZRNO_ADIT_AT"));
				issuBsisInfo.put("FILE_NM1", MapUtils.getString(isgnBsisInfo, "FILE_NM1"));
				issuBsisInfo.put("FILE_SEQ1", MapUtils.getString(isgnBsisInfo, "FILE_SEQ1"));
				issuBsisInfo.put("FILE_NM2", MapUtils.getString(isgnBsisInfo, "FILE_NM2"));
				issuBsisInfo.put("FILE_SEQ2", MapUtils.getString(isgnBsisInfo, "FILE_SEQ2"));
			}
			
		}else {
			
			// 사업자등록번호
			String[] addBizrnoArr = hpeCnfirmReqstMapper.selectAddBizrnoManage(param);
			
			for(String addBizrno : addBizrnoArr) {
				if(Validate.isNotEmpty(addBizrno)) {					
					bizrnoFormatList.add(StringUtil.toBizrnoFormat(addBizrno));			
				}
			}
			
		}				
		
		// 우편번호				
		String zip = MapUtils.getString(issuBsisInfo, "ZIP");
		if(!Validate.isEmpty(zip)) {
			/*
			issuBsisInfo.put("ZIP_FIRST", zip.substring(0, 4));
			issuBsisInfo.put("ZIP_LAST", zip.substring(4));
			*/
			// 2015.08.01부로 우편번호가 5자리로 변경
			issuBsisInfo.put("ZIP_FIRST", zip.replace("-", ""));
		}
		
		// 전화번호
		String telNum = MapUtils.getString(issuBsisInfo, "REPRSNT_TLPHON");
		if(!Validate.isEmpty(telNum)) {
			Map telNumFormat = StringUtil.telNumFormat(telNum);					
			issuBsisInfo.put("REPRSNT_TLPHON_FIRST", telNumFormat.get("first"));
			issuBsisInfo.put("REPRSNT_TLPHON_MIDDLE", telNumFormat.get("middle"));
			issuBsisInfo.put("REPRSNT_TLPHON_LAST", telNumFormat.get("last"));
		}				
	
		// 팩스번호
		String faxNum = MapUtils.getString(issuBsisInfo, "FXNUM");
		if(!Validate.isEmpty(faxNum)) {
			Map faxNumFormat = StringUtil.telNumFormat(faxNum);					
			issuBsisInfo.put("FXNUM_FIRST", faxNumFormat.get("first"));
			issuBsisInfo.put("FXNUM_MIDDLE", faxNumFormat.get("middle"));
			issuBsisInfo.put("FXNUM_LAST", faxNumFormat.get("last"));
		}
		
		applyEntInfo.put("applyMaster", applyMaster);
		applyEntInfo.put("issuBsisInfo", issuBsisInfo);
		applyEntInfo.put("reqstRcpyList", reqstRcpyList);
		applyEntInfo.put("bizrnoFormatList", bizrnoFormatList);
		
		mv.addObject("applyEntInfo", applyEntInfo);
		
		return mv;
	}
	
	/**
	 * 재발급신청
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processIssueAgain(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map param = new HashMap();
		
		String baseRceptNo = MapUtils.getString(rqstMap, "ad_load_rcept_no");		// upper 신청번호	
		String aginRceptNo = MapUtils.getString(rqstMap, "ad_again_rcept_no");		// 재발급 신청번호
		
		boolean isPs4 = false;		// 보완접수 여부
		
		param.put("RCEPT_NO", baseRceptNo);
		
		// 신청접수마스터
		Map applyMaster	= hpeCnfirmReqstMapper.selectApplyMaster(param);
		List<String> bizrnoList = new ArrayList<String>();
		
		// 재발급여부
		String isgnAt = MapUtils.getString(applyMaster, "ISGN_AT", "");
		
		// 재발급신청 보완접수의 경우
		if(Validate.isNotEmpty(aginRceptNo)) {
			isPs4 = true;
		}
		
		// 기존 재발급 이력이 있는 경우 또는 보완접수인 경우
		if(isgnAt.equals("Y") || isPs4) {
			
			Map isgnParam = new HashMap();
			
			if(isPs4) {
				isgnParam.put("RCEPT_NO", aginRceptNo);
				
			}else {
				isgnParam.put("UPPER_RCEPT_NO", baseRceptNo);
				
				// 최근접수정보
				Map recentApply = hpeCnfirmReqstMapper.selectRecentApply(isgnParam);						
				String recentRceptNo = MapUtils.getString(recentApply, "RCEPT_NO");		// 최근발급처리된 접수번호
				isgnParam.put("RCEPT_NO", recentRceptNo);
			}						
			
			// 복수사업자번호
			String[] compnoBizrnoArr = hpeCnfirmReqstMapper.selectCompnoBizrnoManage(isgnParam);
			
			for(String compnoBizrno : compnoBizrnoArr) {
				if(Validate.isNotEmpty(compnoBizrno)) {					
					bizrnoList.add(compnoBizrno);			
				}
			}
			
		// 첫 재발급 인 경우 
		}else {
			param.put("ENTRPRS_SE", GlobalConst.ENTRPRS_SE_O);

			// 복수사업자번호
			Map isgnParam = new HashMap();
			
			isgnParam.put("RCEPT_NO", baseRceptNo);
			
			String[] addBizrnoArr = hpeCnfirmReqstMapper.selectAddBizrnoManage(isgnParam);
			
			for(String addBizrno : addBizrnoArr) {
				if(Validate.isNotEmpty(addBizrno)) {					
					bizrnoList.add(addBizrno);			
				}
			}
		}
		
		int addBiznoCnt = MapUtils.getIntValue(rqstMap, "ad_bizrno_cnt", 0);
		String addBizno = "";
		for(int i=1; i<=addBiznoCnt; i++) {
			addBizno = MapUtils.getString(rqstMap, "ad_bizrno_compno_" + i, "");
			bizrnoList.add(addBizno);
		}
		
		Map<String,Object> sParam = new HashMap<String,Object>();
		sParam.put("UPPER_RCEPT_NO", baseRceptNo);
		
		String newRceptNo;	// 접수번호
		
		// 보완접수의 경우 접수일련번호 새로 생성하지 않음.
		if(isPs4) {
			newRceptNo = aginRceptNo;
		}else {
			// 재발급 신청건 조회
			Map applyData = hpeCnfirmReqstMapper.selectIsgnDplctReqst(sParam);
			if(Validate.isNotEmpty(applyData)) {
				throw processException("fail.common.session");
			}
			
			// 접수일련번호 생성
			Map snMap = pgic0022.createRceptSn();
			// 접수일련번호
			int rceptSn = MapUtils.getIntValue(snMap, "rceptSn");
			pgic0022.updateRceptSn(rceptSn);
			
			newRceptNo = MapUtils.getString(snMap, "rceptNo");	
		}					
		
		applyMaster.put("RCEPT_NO", newRceptNo);
		applyMaster.put("UPPER_RCEPT_NO", baseRceptNo);							// 상위접수번호
		applyMaster.put("REQST_SE", GlobalConst.REQST_SE_AK2);					// 신청구분 : 재발급신청
		applyMaster.put("UPDT_AT", null);
		applyMaster.put("UPDT_DE", null);
		
		// 신청접수 등록
		hpeCnfirmReqstMapper.insertApplyMaster(applyMaster);
		
		String entrpsNm = MapUtils.getString(rqstMap, "ad_entrprs_nm");								// 기업명
		String rprsntvNm = MapUtils.getString(rqstMap, "ad_rprsntv_nm");							// 대표자명
		String hedofcAdres = MapUtils.getString(rqstMap, "ad_hedofc_adres");						// 본사주소
		String zip = MapUtils.getString(rqstMap, "ad_zip");											// 우편번호
		String entrprsNmChangeAt = MapUtils.getString(rqstMap, "ad_entrprs_nm_change_at", "N");		// 기업명변경여부
		String qyCptlAt = MapUtils.getString(rqstMap, "ad_qy_cptl_at", "N");						// 양수도여부
		String bizrnoAditAt = MapUtils.getString(rqstMap, "ad_bizrno_adit_at", "N");				// 사업자번호추가여부
		String reprsntTlphon = MapUtils.getString(rqstMap, "ad_reprsnt_tlphon");					// 대표전화
		String fxnum = MapUtils.getString(rqstMap, "ad_fxnum");										// 팩스번호		
		
		param.put("RCEPT_NO", newRceptNo);
		param.put("ENTRPS_NM", entrpsNm);
		param.put("RPRSNTV_NM", rprsntvNm);
		param.put("HEDOFC_ADRES", hedofcAdres);
		param.put("ZIP", zip);
		param.put("ENTRPRS_NM_CHANGE_AT", entrprsNmChangeAt);
		param.put("QY_CPTL_AT", qyCptlAt);
		param.put("BIZRNO_ADIT_AT", bizrnoAditAt);
		param.put("REPRSNT_TLPHON", reprsntTlphon);
		param.put("FXNUM", fxnum);
		
		Map fileInfo1 = insertAttachFile(rqstMap, "fi_con_doc");
		Map fileInfo2 = insertAttachFile(rqstMap, "fi_proof_doc");
		
		if(Validate.isNotEmpty(fileInfo1)) {
			param.put("FILE_NM1", MapUtils.getString(fileInfo1, "FILE_NM"));
			param.put("FILE_SEQ1", MapUtils.getString(fileInfo1, "FILE_SEQ"));
		}
		if(Validate.isNotEmpty(fileInfo2)) {
			param.put("FILE_NM2", MapUtils.getString(fileInfo2, "FILE_NM"));
			param.put("FILE_SEQ2", MapUtils.getString(fileInfo2, "FILE_SEQ"));
		}
		
		// 재발급기초정보 등록
		hpeCnfirmReqstMapper.insertIsgnBsisInfo(param);
		
		// 복수사업자번호관리 삭제
		hpeCnfirmReqstMapper.deleteCompnoBizrnoManage(param);
		// 복수사업자번호관리 등록
		for(String bizrno : bizrnoList) {
			if(Validate.isNotEmpty(bizrno)) {
				param.put("BIZRNO", bizrno);
				hpeCnfirmReqstMapper.insertCompnoBizrnoManage(param);
			}	
		}
		
		EntUserVO entUserVo = SessionUtil.getEntUserInfo();
		
		if(Validate.isEmpty(entUserVo)) {				
			throw processException("fail.common.session");
		}
		
		param.put("USER_NO", entUserVo.getUserNo()); 		// 사용자번호		
		param.put("RESN_SE", GlobalConst.RESN_SE_S); 		// 사유구분:진행상태
		if(isPs4) {
			param.put("SE_CODE", GlobalConst.RESN_SE_CODE_PS4); // 구분코드:보완접수
		}else {
			param.put("SE_CODE", GlobalConst.RESN_SE_CODE_PS1); // 구분코드:접수
		}					
							
		hpeCnfirmReqstMapper.insertResnManage(param);
		
		return ResponseUtil.responseText(mv, Boolean.TRUE);
	}
	
	/**
	 * 보완요청 조회
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView showSupplement(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/im/PD_UIIMA0019");
		String rceptNo = MapUtils.getString(rqstMap, "ad_rcept_no");
		
		Map param = new HashMap();
		param.put("RCEPT_NO", rceptNo);
		param.put("RESN_SE", GlobalConst.RESN_SE_S);
		Map resnRMap = issueStatusMngMapper.selectLastestResn(param);
		if(Validate.isNotEmpty(resnRMap)) {
			String seCode = MapUtils.getString(resnRMap, "SE_CODE","");
			// 보완요청
			if(seCode.equals(GlobalConst.RESN_SE_CODE_PS3)) {
				mv.addObject("supplement", resnRMap);
			}
			logger.debug("######################### resnRMap: "+resnRMap);
		}
		return mv;		
	}
	
	/**
	 * 확인서 출력 요청
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView processCertIssuetInfo(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		String issueNo  = MapUtils.getString(rqstMap, "issueNo");
		String confmSe  = MapUtils.getString(rqstMap, "confmSe");
		
		if(Validate.isEmpty(issueNo)) {
			throw processException("errors.required",new String[]{"기업확인서 발급번호"});
		}
		
		Map param = new HashMap();
		param.put("issueNo", issueNo);
		
		CertIssueVo cerissueVo = certissueService.findCertIssueBsisInfo(param);
		cerissueVo.setIssueNo(issueNo);
		
		if(confmSe.equals("A")) {                   // 일반
			mv.setViewName("/cmm/PD_UICMC0006");
		} else {                                    // 특례
			mv.setViewName("/cmm/PD_UICMC0007");
		}
		
		mv.addObject("issueNo", issueNo);
		mv.addObject("confmSe", confmSe);
		mv.addObject("cerissueVo", cerissueVo);
		
		return mv;
	}
	
	/**
	 * 확인서 발급 신청증 출력 요청
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView processCertIssuetInfo2(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		String rceptNo  = MapUtils.getString(rqstMap, "rceptNo");
		
		if(Validate.isEmpty(rceptNo)) {
			throw processException("errors.required",new String[]{"기업확인서 접수번호"});
		}
		
		Map param = new HashMap();
		param.put("rceptNo", rceptNo);
		
		CertIssueVo cerissueVo = certissueService.findCertIssueBsisInfo2(param);
		
		mv.setViewName("/cmm/PD_UICMC0008");
		
		mv.addObject("cerissueVo", cerissueVo);
		
		return mv;
	}
	
	/**
	 * 접수취소 조회
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView showCancelReception(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/im/PD_UIIMA0016");
		String rceptNo = MapUtils.getString(rqstMap, "ad_rcept_no");
		
		Map param = new HashMap();
		param.put("RCEPT_NO", rceptNo);
		param.put("RESN_SE", GlobalConst.RESN_SE_R);
		Map resnRMap = issueStatusMngMapper.selectLastestResn(param);
		if(Validate.isNotEmpty(resnRMap)) {
			String seCode = MapUtils.getString(resnRMap, "SE_CODE","");
			// 접수취소
			if(seCode.equals(GlobalConst.RESN_SE_CODE_RC3)) {
				mv.addObject("cancelReception", resnRMap);
			}
			logger.debug("######################### resnRMap: "+resnRMap);
		}
		return mv;		
	}
	
	/**
	 * 접수취소 수정
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView updateCancelReception(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		String rceptNo = MapUtils.getString(rqstMap, "ad_rcept_no");
		String resn = MapUtils.getString(rqstMap, "ad_resn");
		Map param = new HashMap();
		param.put("RCEPT_NO", rceptNo);
		
		
		// 상태이력관리 등록:진행상태-완료		
		UserVO userVo = SessionUtil.getUserInfo();
		if(Validate.isEmpty(userVo)) {
			throw processException("fail.common.session");
		}		
		String userNo = userVo.getUserNo();		
		param = new HashMap();
		param.put("RCEPT_NO", rceptNo);
		param.put("RESN_SE", GlobalConst.RESN_SE_S);
		param.put("SE_CODE", GlobalConst.RESN_SE_CODE_PS6);
		param.put("USER_NO", userNo);		
		hpeCnfirmReqstMapper.insertResnManage(param);
		
		// 상태이력관리 등록:진행결과-반려
		param = new HashMap();
		param.put("RCEPT_NO", rceptNo);
		param.put("RESN_SE", GlobalConst.RESN_SE_R);
		param.put("SE_CODE", GlobalConst.RESN_SE_CODE_RC3);
		param.put("RESN", resn);
		param.put("USER_NO", userNo);
		hpeCnfirmReqstMapper.insertResnManage(param);
				
		return ResponseUtil.responseText(mv,Boolean.TRUE);
				
	}
	
	/**
	 * 발급취소 조회
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView showCancelIssue(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/im/PD_UIIMA0020");
		String rceptNo = MapUtils.getString(rqstMap, "ad_rcept_no");
		
		Map param = new HashMap();
		param.put("RCEPT_NO", rceptNo);
		
		Map judgment = issueStatusMngMapper.selectJudgment(param);
		param.put("RESN_SE", GlobalConst.RESN_SE_R);		
		if(Validate.isNotEmpty(judgment)) {			
			Map resnRMap = issueStatusMngMapper.selectLastestResn(param);
			if(Validate.isNotEmpty(resnRMap)) {
				String seCode = MapUtils.getString(resnRMap, "SE_CODE","");
				// 발급취소
				if(seCode.equals(GlobalConst.RESN_SE_CODE_RC4)) {
					judgment.put("RESN_SE", resnRMap.get("SE_CODE"));
					judgment.put("RESN", resnRMap.get("RESN"));
				}
			}
		}
		
		mv.addObject("cancelIssue", judgment);
		
		return mv;		
	}
	
	/**
	 * 판정 조회
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView showJudgment(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/im/PD_UIIMA0017");
		String rceptNo = MapUtils.getString(rqstMap, "ad_rcept_no");
		
		Map param = new HashMap();
		param.put("RCEPT_NO", rceptNo);
		
		Map judgment = issueStatusMngMapper.selectJudgment(param);
		param.put("RESN_SE", GlobalConst.RESN_SE_R);		
		/*
		if(Validate.isNotEmpty(judgment)) {			
			Map resnRMap = issueStatusMngMapper.selectLastestResn(param);
			if(Validate.isNotEmpty(resnRMap)) {
				String seCode = MapUtils.getString(resnRMap, "SE_CODE","");
				// 발급, 반려
				if(seCode.equals(GlobalConst.RESN_SE_CODE_RC1)
				||seCode.equals(GlobalConst.RESN_SE_CODE_RC2)) {
					judgment.put("RESN_SE", resnRMap.get("SE_CODE"));
					judgment.put("RESN", resnRMap.get("RESN"));
				}
			}
		}
		*/
		// 내용변경신청 -> 완료(반려처리)의 경우도 사유 보이게 변경
		Map resnRMap = issueStatusMngMapper.selectLastestResn(param);
		if(Validate.isNotEmpty(resnRMap)) {
			String seCode = MapUtils.getString(resnRMap, "SE_CODE","");
			// 발급, 반려
			if(seCode.equals(GlobalConst.RESN_SE_CODE_RC1)
			||seCode.equals(GlobalConst.RESN_SE_CODE_RC2)) {
				if(Validate.isEmpty(judgment)) {
					judgment = new HashMap();
				}
				judgment.put("RESN_SE", resnRMap.get("SE_CODE"));
				judgment.put("RESN", resnRMap.get("RESN"));
			}
		}
		judgment.put("RC1_FLAG", "N");
		mv.addObject("judgment", judgment);
		
		return mv;		
	}
	
	/**
	 * 기업분석서비스 팝업
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView entrpAnalisys(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/www/my/PD_UIMYU0066");
		String rceptNo = MapUtils.getString(rqstMap, "ad_load_rcept_no");
		
		Map param = new HashMap();
		param.put("RCEPT_NO", rceptNo);		
		
		// 신청접수마스터
		Map applyMaster	= hpeCnfirmReqstMapper.selectApplyMaster(param);
				
		int jdgmntReqstYear = MapUtils.getIntValue(applyMaster, "JDGMNT_REQST_YEAR", 0);	// 판정신청년도				
		String jurirno = MapUtils.getString(applyMaster, "JURIRNO");						// 법인등록번호
		
		param.put("STDYY", jdgmntReqstYear-1);
		param.put("JURIRNO", jurirno);
		
		// 기업기본정보조회
		Map entprsInfo = hpeCnfirmReqstMapper.selectEntprsInfo(param);
		String entrprsNm = MapUtils.getString(entprsInfo, "ENTRPRS_NM", "");					// 기업명
		String hpeCd = MapUtils.getString(entprsInfo, "HPE_CD");					// 기업관리코드		
		String lclasCd = MapUtils.getString(entprsInfo, "LCLAS_CD", "");			// 업종대분류코드
		String mlsfcCd = MapUtils.getString(entprsInfo, "MLSFC_CD", "");			// 업종중분류코드
		String indutyCode = lclasCd;	// 업종코드
						
		// 업종이 제조업인 경우 대분류코드 + 중분류코드 = 업종코드
		if(lclasCd.equals("C")) {
			indutyCode += mlsfcCd;			
		}
		
		param.put("HPE_CD", hpeCd);
		param.put("INDUTY_CODE", indutyCode);
		
		// 기업기본통계조회
		List<Map> stsEntcls = hpeCnfirmReqstMapper.selectEntBaseSts(param);
		
		param.put("LCLAS_CD", lclasCd);
		// 업종이 제조업인 경우 중분류코드 파라미터 추가
		if(lclasCd.equals("C")) {
			param.put("MLSFC_CD", mlsfcCd);
		}
		// 상위 5개 업체
		param.put("LIMIT", 5);
		
		// 상위업체평균통계 조회
		Map upperCmpnAvg = hpeCnfirmReqstMapper.selectUpperCmpnAvgSts(param);
		
		String[] remark = {entrprsNm, "동종업종(평균)", "전산업(평균)"};
		
		mv.addObject("entprsInfo", entprsInfo);
		mv.addObject("stsEntcls", stsEntcls);
		mv.addObject("upperCmpnAvg", upperCmpnAvg);
		mv.addObject("remark", remark);
		
		return mv;
	}
	
	/**
	 * 첨부파일 업로드
	 * @param rqstMap
	 * @param key
	 * @return
	 * @throws Exception
	 */
	public Map insertAttachFile(Map<?, ?> rqstMap, String key) throws Exception {
		Map fileInfoMap = null;
		
		List<FileVO> fileList = new ArrayList<FileVO>();		
		MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) MapUtils.getObject(rqstMap, GlobalConst.RQST_MULTIPART);		
    	List<MultipartFile> multiFiles = multiRequest.getFiles(key);
    	FileVO fileVO = new FileVO();
    	
    	int fileSeq = -1;
    	
    	if(Validate.isNotEmpty(multiFiles)) {
    	
	    	fileList = UploadHelper.upload(multiFiles, "test");			
	    	fileSeq = fileDao.saveFile(fileList, fileSeq);
    	}    	
    	
    	//업로드 성공시 DB변경
    	if(fileList.size() > 0 && fileSeq > -1) {
    		fileVO = fileList.get(0);
    		
    		fileInfoMap = new HashMap<String, Object>();
    		
    		fileInfoMap.put("FILE_SEQ", fileSeq);
    		fileInfoMap.put("FILE_NM", fileVO.getLocalNm());    		
    	}
		
		return fileInfoMap;
	}
	
	/**
	 * 임시기업정보 삭제
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView deleteTempSaveInfos(Map<?, ?> rqstMap) throws Exception {		
		
		ModelAndView mv = new ModelAndView();
		Map<String, Object> param = new HashMap<String, Object>();		
		param.put("RCEPT_NO", MapUtils.getString(rqstMap, "rcept_no"));
				
		hpeCnfirmReqstMapper.deleteAddBizrnoManage(param);		// 중복 사업자번호 
		
		// 관계기업
		param.put("ENTRPRS_SE", GlobalConst.ENTRPRS_SE_R);		// 기업구분:관계기업
		hpeCnfirmReqstMapper.deleteReqstFile(param);			// 첨부파일
		hpeCnfirmReqstMapper.deleteReqstOrdtmLabrr(param);		// 근로자수
		hpeCnfirmReqstMapper.deleteReqstInfoQotaPosesn(param);	// 지분소유
		hpeCnfirmReqstMapper.deleteReqstFnnrData(param);		// 재무
		hpeCnfirmReqstMapper.deleteReqstRcpyList(param);		// 주요정보		
		
		// 신청기업
		param.put("ENTRPRS_SE", GlobalConst.ENTRPRS_SE_O);		// 기업구분:신청기업
		hpeCnfirmReqstMapper.deleteReqstFile(param);			// 첨부파일
		hpeCnfirmReqstMapper.deleteReqstOrdtmLabrr(param);		// 근로자수
		hpeCnfirmReqstMapper.deleteReqstInfoQotaPosesn(param);	// 지분소유
		hpeCnfirmReqstMapper.deleteReqstFnnrData(param);		// 재무
		hpeCnfirmReqstMapper.deleteReqstRcpyList(param);		// 주요정보
		hpeCnfirmReqstMapper.deleteIssuBsisInfo(param);			// 기초정보
		
		return ResponseUtil.responseJson(mv, Boolean.TRUE);
	}
	
	/**
	 * 재발급기초정보 첨부파일정보 선택삭제
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView updateDelAttFile(Map<?, ?> rqstMap) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		Map<String, Object> param = new HashMap<String, Object>();
		String rceptNo = MapUtils.getString(rqstMap, "rcept_no");
		String fileGubun =  MapUtils.getString(rqstMap, "file_gubun", "");
		int result = 0;
		
		param.put("RCEPT_NO", rceptNo);
		
		if(fileGubun.equals("contract_document")) {
			result = hpeCnfirmReqstMapper.updateDelAttFileSeq1(param);
		}else if(fileGubun.equals("proof_document")) {
			result = hpeCnfirmReqstMapper.updateDelAttFileSeq2(param);
		}
		
		if(result>0) {
			return ResponseUtil.responseText(mv,Boolean.TRUE);
		}else {
			return ResponseUtil.responseText(mv,Boolean.FALSE);
		}
	}
}
