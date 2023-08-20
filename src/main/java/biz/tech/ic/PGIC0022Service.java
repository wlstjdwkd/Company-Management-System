package biz.tech.ic;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.user.EntUserVO;
import com.comm.user.UserService;
import com.comm.user.UserVO;
import com.infra.file.FileDAO;
import com.infra.file.FileVO;
import com.infra.file.UploadHelper;
import com.infra.system.GlobalConst;
import com.infra.util.ArrayUtil;
import com.infra.util.BizUtil;
import com.infra.util.JsonUtil;
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

import com.comm.mapif.CodeMapper;
import biz.tech.mapif.ic.HpeCnfirmReqstMapper;
import biz.tech.mapif.im.IssueStatusMngMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 기업확인>기업확인신청
 * 
 * @author JGS
 * 
 */
@Service("PGIC0022")
public class PGIC0022Service extends EgovAbstractServiceImpl {
	
	private Locale locale = Locale.getDefault();
	
	private static final Logger logger = LoggerFactory.getLogger(PGIC0022Service.class);

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;
	
	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	@Resource(name = "filesDAO")
	private FileDAO fileDao;
	
	@Autowired
	UserService userService;
	
	@Autowired
	HpeCnfirmReqstMapper hpeCnfirmReqstMapper;	

	@Autowired
	CodeMapper codeMapper;
	
	@Autowired
	IssueStatusMngMapper issueStatusMngMapper;
		
	// 첨부파일 타입
	private enum RF{ rf0, rf1, rf2, rf3, rf4, rf5 }

	/**
	 * 신청서작성 
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		UserVO userVo = SessionUtil.getUserInfo();
		if(Validate.isEmpty(userVo)) {
			throw processException("fail.common.session");
		}
		
		String loadDataYn = MapUtils.getString(rqstMap, "ad_load_data", "N");
		String loadRceptNo = MapUtils.getString(rqstMap, "ad_load_rcept_no");
		
		// 불러오기
		if("Y".equals(loadDataYn)) {
			if(Validate.isEmpty(loadRceptNo)) {
				// 접수번호 없음
				throw processException("errors.reqst.norceptno");
			}
		}
		
		String[] authorGroupCode = userVo.getAuthorGroupCode();
		logger.debug("%%%%%%%%%%%%%%%%%%%%%%%%%% userVo.getAuthorGroupCode: "+Arrays.toString(authorGroupCode));
		// 관리자 회원
		if(	ArrayUtil.contains(authorGroupCode, GlobalConst.AUTH_DIV_ADM)||
			ArrayUtil.contains(authorGroupCode, GlobalConst.AUTH_DIV_BIZ)
		){
			mv.addObject("isAdminOrBiz", "Y");
		// 기업회원	
		}else if(ArrayUtil.contains(authorGroupCode, GlobalConst.AUTH_DIV_ENT)){			
			// 불러오기일경우 해당 기업회원데이터인지 확인
			if("Y".equals(loadDataYn)) {
				EntUserVO entUserVo = SessionUtil.getEntUserInfo();		
				if(Validate.isEmpty(entUserVo)) {
					// 기업회원정보 없음
					throw processException("fail.common.select", new String[] {"기업정보"});			
				}
				
				Map<String,Object> entParam = new HashMap<String,Object>();
				entParam.put("RCEPT_NO", loadRceptNo);
				Map result = hpeCnfirmReqstMapper.selectApplyMaster(entParam);
				
				if(Validate.isEmpty(result)) {
					// 신청접수 데이터 존재하지 않음
					throw processException("errors.reqst.noapplydata");
				}
				
				String jurirno = MapUtils.getString(result, "JURIRNO");
				if(!entUserVo.getJurirno().equals(jurirno)) {
					// 해당 기업회원 데이터가 아님
					throw processException("errors.reqst.invalidrceptno");
				}
			}
		}else {
			// 관리자,업무,기업회원 아님
			throw processException("errors.reqst.invalidmembertype");
		}		
	
		if("Y".equals(loadDataYn)) {
			
			// 신청기업 정보 조회
			Map param = new HashMap();
			param.put("RCEPT_NO", loadRceptNo);
			param.put("ENTRPRS_SE", GlobalConst.ENTRPRS_SE_O);
			
			Map<String,Object> applyEntInfo = new HashMap<String,Object>();				
			
			// 신청접수마스터
			Map applyMaster	= hpeCnfirmReqstMapper.selectApplyMaster(param);
			// 신청기업기초정보
			Map issuBsisInfo = hpeCnfirmReqstMapper.selectIssuBsisInfo(param);
			
			// 신청기업업주요정보				
			Map reqstRcpyList = (Map) hpeCnfirmReqstMapper.selectReqstRcpyList(param).get(0);			
		
			// 업종 정보
			if(reqstRcpyList.get("MN_INDUTY_CODE").toString() != null && reqstRcpyList.get("MN_INDUTY_CODE").toString().length() != 0) {
				if(reqstRcpyList.get("MN_INDUTY_CODE").toString().length() > 1) {
					param.put("indutyCode", reqstRcpyList.get("MN_INDUTY_CODE").toString().substring(0, 2));
					String lclasCd = hpeCnfirmReqstMapper.selectLargeOne(param).get("lclasCd").toString();
					param.put("lclasCd", lclasCd);
					mv.addObject("lclasCd", lclasCd);
					mv.addObject("small", hpeCnfirmReqstMapper.selectSmallGroup(param));
				}
			}
			/* */
			param.put("lclasCd", "LCLAS_CD");
			mv.addObject("large", hpeCnfirmReqstMapper.selectLargeOne(param));
			/* */
			
			logger.debug("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 신청기업주요정보: "+reqstRcpyList.toString());
			
			// 법인등록번호
			String jurirnoApply = MapUtils.getString(reqstRcpyList, "JURIRNO");
			if(Validate.isNotEmpty(jurirnoApply)) {
				Map jurirnoFormat = StringUtil.toJurirnoFormat(jurirnoApply);					
				reqstRcpyList.put("JURIRNO_FIRST", jurirnoFormat.get("first"));
				reqstRcpyList.put("JURIRNO_LAST", jurirnoFormat.get("last"));
			}
			
			// 사업자등록번호
			String bizrnoApply = MapUtils.getString(reqstRcpyList, "BIZRNO");
			if(Validate.isNotEmpty(bizrnoApply)) {
				Map bizrnoFormat = StringUtil.toBizrnoFormat(bizrnoApply);					
				reqstRcpyList.put("BIZRNO_FIRST", bizrnoFormat.get("first"));
				reqstRcpyList.put("BIZRNO_MIDDLE", bizrnoFormat.get("middle"));
				reqstRcpyList.put("BIZRNO_LAST", bizrnoFormat.get("last"));
			}
			
			Map isgnParam = new HashMap();
			
			isgnParam.put("RCEPT_NO", loadRceptNo);
			
			List<Map> bizrnoFormatList =new ArrayList<Map>();	// 사업자등록번호 리스트
			String[] compnoBizrnoArr = hpeCnfirmReqstMapper.selectAddBizrnoManage(isgnParam);
			
			for(String compnoBizrno : compnoBizrnoArr) {
				if(Validate.isNotEmpty(compnoBizrno)) {					
					bizrnoFormatList.add(StringUtil.toBizrnoFormat(compnoBizrno));			
				}
			}
			
			// 결산일
			String acctMMdd = MapUtils.getString(reqstRcpyList, "PSACNT");
			String acctMT = acctMMdd.substring(0, 2);
			int lastIssuYear = BizUtil.getLastIssuYear(Integer.valueOf(acctMT.trim()));
			// 결산월
			issuBsisInfo.put("ACCT_MT", acctMT);
			// 확인서발행가능 최종년도
			issuBsisInfo.put("LAST_ISSU_YEAR", lastIssuYear);
			
			// 우편번호				
			String zip = MapUtils.getString(issuBsisInfo, "ZIP");
			logger.debug("============================== zip: "+zip);
			if(!Validate.isEmpty(zip)) {
				/*
				if(zip.length()>=8) {
					issuBsisInfo.put("ZIP_FIRST", zip.substring(0, 4));
					issuBsisInfo.put("ZIP_LAST", zip.substring(4));
				}
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
			
			// 신청기업지분소유
			Map reqstInfoQotaPosesn = null;
			List<Map> reqstInfoQotaPosesnList = hpeCnfirmReqstMapper.selectReqstInfoQotaPosesn(param);
			if(Validate.isNotEmpty(reqstInfoQotaPosesnList)) {
				reqstInfoQotaPosesn = (Map) hpeCnfirmReqstMapper.selectReqstInfoQotaPosesn(param).get(0);
			}
			
			// 신청기업재무정보
			List<Map> reqstFnnrDataList = hpeCnfirmReqstMapper.selectReqstFnnrData(param);
			Map<String, Object> reqstFnnrData = new HashMap<String, Object>();
			for(Map map : reqstFnnrDataList) {
				String bsnsYear = MapUtils.getString(map, "BSNS_YEAR");
				reqstFnnrData.put(bsnsYear, map);
			}
			
			// 신청기업상시근로자수
			List<Map> reqstOrdtmLabrrList = hpeCnfirmReqstMapper.selectReqstOrdtmLabrr(param);
			Map<String, Object> reqstOrdtmLabrr = new HashMap<String, Object>();
			for(Map map: reqstOrdtmLabrrList) {
				String bsnsYear = MapUtils.getString(map, "BSNS_YEAR");
				reqstOrdtmLabrr.put(bsnsYear, map);
			}				
			
			// 신청기업첨부파일 조회
			List<Map> reqstFileList = hpeCnfirmReqstMapper.selectReqstFile(param);
			Map reqstFile = new HashMap();
			logger.debug("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 신청기업첨부파일 조회 reqstFileList: "+reqstFileList.toString());
			int lastYear = MapUtils.getInteger(applyMaster, "JDGMNT_REQST_YEAR");
			for(int i=0;i<=3;i++) {
				int year = lastYear-i;
				Map reqstFileKnd = new HashMap();
				for(Map map: reqstFileList) {
					String fileKnd = MapUtils.getString(map, "FILE_KND");
					int bsnsYear = MapUtils.getInteger(map, "YEAR");
					if(year==bsnsYear) {
						reqstFileKnd.put(fileKnd, map);
					}
				}
				reqstFile.put(String.valueOf(year), reqstFileKnd);					
			}
			
			// 신청기업 최종 진행상태
			Map resnParam = new HashMap();
			resnParam.put("RCEPT_NO", loadRceptNo);
			resnParam.put("RESN_SE", GlobalConst.RESN_SE_S);
			Map resnSMap = issueStatusMngMapper.selectLastestResn(resnParam);			
			
			applyEntInfo.put("resnManageS", resnSMap);
			applyEntInfo.put("applyMaster", applyMaster);
			applyEntInfo.put("issuBsisInfo", issuBsisInfo);
			applyEntInfo.put("reqstRcpyList", reqstRcpyList);
			applyEntInfo.put("bizrnoFormatList", bizrnoFormatList);
			applyEntInfo.put("reqstInfoQotaPosesn", reqstInfoQotaPosesn);				
			applyEntInfo.put("reqstFnnrData", reqstFnnrData);
			applyEntInfo.put("reqstOrdtmLabrr", reqstOrdtmLabrr);
			applyEntInfo.put("reqstFile", reqstFile);
			
			logger.debug("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^  신청기업첨부파일 조회출력 reqstFile:: "+reqstFile.toString());
			// 신청기업정보 추가
			mv.addObject("applyEntInfo", applyEntInfo);
			
			param.put("ENTRPRS_SE", GlobalConst.ENTRPRS_SE_R);
			List<Map> relateEntInfos = new ArrayList<Map>();
			// 관계기업주요정보
			List<Map> reqstRcpyListRelateList = hpeCnfirmReqstMapper.selectReqstRcpyList(param);
			if(Validate.isNotEmpty(reqstRcpyListRelateList)) {
				for(Map rcpyMap : reqstRcpyListRelateList){
					Map relateEntInfo = new HashMap();
					 
					
					// 관계기업 업종 정보
					//if(rcpyMap.get("MN_INDUTY_CODE").toString() != null && rcpyMap.get("MN_INDUTY_CODE").toString().length() != 0) 
					if(Validate.isNotEmpty(rcpyMap.get("MN_INDUTY_CODE"))){				
						if(rcpyMap.get("MN_INDUTY_CODE").toString().length() > 1) {
							param.put("indutyCode", rcpyMap.get("MN_INDUTY_CODE").toString().substring(0, 2));
							String lclasCd = hpeCnfirmReqstMapper.selectLargeOne(param).get("lclasCd").toString();
							param.put("lclasCd", lclasCd);
							rcpyMap.put("lclasCd", lclasCd);
							rcpyMap.put("small", hpeCnfirmReqstMapper.selectSmallGroup(param));
						}
					}
					
					// 법인등록번호
					String jurirno = MapUtils.getString(rcpyMap, "JURIRNO");
					if(Validate.isNotEmpty(jurirno)) {
						Map jurirnoFormat = StringUtil.toJurirnoFormat(jurirno);					
						rcpyMap.put("JURIRNO_FIRST", jurirnoFormat.get("first"));
						rcpyMap.put("JURIRNO_LAST", jurirnoFormat.get("last"));
					}
					
					// 사업자등록번호
					String bizrno = MapUtils.getString(rcpyMap, "BIZRNO");
					if(Validate.isNotEmpty(bizrno)) {
						Map bizrnoFormat = StringUtil.toBizrnoFormat(bizrno);					
						rcpyMap.put("BIZRNO_FIRST", bizrnoFormat.get("first"));
						rcpyMap.put("BIZRNO_MIDDLE", bizrnoFormat.get("middle"));
						rcpyMap.put("BIZRNO_LAST", bizrnoFormat.get("last"));
					}
					
					// 결산일
					String acctMMddRelate = MapUtils.getString(rcpyMap, "PSACNT");
					if(Validate.isNotEmpty(acctMMddRelate)) {
						String acctMtRelate = acctMMddRelate.substring(0, 2);
						// 결산월
						rcpyMap.put("ACCT_MT", acctMtRelate);
					}					
					
					relateEntInfo.put("reqstRcpyListRelate", rcpyMap);
					
					// 순번
					int sn = MapUtils.getIntValue(rcpyMap, "SN");
					param.put("SN", sn);
					
					// 관계기업지분소유 조회
					List<Map> reqstInfoQotaPosesnRelateList = hpeCnfirmReqstMapper.selectReqstInfoQotaPosesn(param);
					Map reqstInfoQotaPosesnRelate = null; 
					if(Validate.isNotEmpty(reqstInfoQotaPosesnRelateList)) {
						reqstInfoQotaPosesnRelate = (Map) hpeCnfirmReqstMapper.selectReqstInfoQotaPosesn(param).get(0); 
					}							
					relateEntInfo.put("reqstInfoQotaPosesnRelate", reqstInfoQotaPosesnRelate);					
					
					// 관계기업재무 조회
					List<Map> reqstFnnrDataRelateList = hpeCnfirmReqstMapper.selectReqstFnnrData(param);
					if(Validate.isNotEmpty(reqstFnnrDataRelateList)) {
						Map<String, Object> reqstFnnrDataRelate = new HashMap<String, Object>();
						for(Map fnnrDataMap : reqstFnnrDataRelateList) {
							String bsnsYear = MapUtils.getString(fnnrDataMap, "BSNS_YEAR");
							reqstFnnrDataRelate.put(bsnsYear, fnnrDataMap);
						}
						relateEntInfo.put("reqstFnnrDataRelate", reqstFnnrDataRelate);
					}
					
					// 관계기업상시근로자수 조회
					List<Map> reqstOrdtmLabrrRelateList = hpeCnfirmReqstMapper.selectReqstOrdtmLabrr(param);
					if(Validate.isNotEmpty(reqstOrdtmLabrrRelateList)) {
						Map<String, Object> reqstOrdtmLabrrRelate = new HashMap<String, Object>();
						for(Map ordtmLabrrMap : reqstOrdtmLabrrRelateList) {
							String bsnsYear = MapUtils.getString(ordtmLabrrMap, "BSNS_YEAR");
							reqstOrdtmLabrrRelate.put(bsnsYear, ordtmLabrrMap);
						}
						relateEntInfo.put("reqstOrdtmLabrrRelate", reqstOrdtmLabrrRelate);
					}
					
					// 관계기업첨부파일 조회
					List<Map> reqstFileRelateList = hpeCnfirmReqstMapper.selectReqstFile(param);
					logger.debug("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% param 관계기업첨부파일 조회파람: "+param.toString());
					logger.debug("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% reqstFileRelateList 관계기업첨부파일 조회: "+reqstFileRelateList.toString());
					Map reqstFileRelate = new HashMap();					
					
					for(int i=0;i<=3;i++) {
						int year = lastYear-i;
						Map reqstFileKnd = new HashMap();
						for(Map map: reqstFileRelateList) {
							String fileKnd = MapUtils.getString(map, "FILE_KND");
							int bsnsYear = MapUtils.getInteger(map, "YEAR");
							if(year==bsnsYear) {
								reqstFileKnd.put(fileKnd, map);
							}
						}
						reqstFileRelate.put(String.valueOf(year), reqstFileKnd);					
					}
					relateEntInfo.put("reqstFileRelate", reqstFileRelate);
					
					logger.debug("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reqstFileRelate: "+reqstFileRelate.toString());
					relateEntInfos.add(relateEntInfo);						
				}
			}
			
			// 관계기업정보 추가
			mv.addObject("relateEntInfos", relateEntInfos);
		}
		
		mv.addObject("loadDataYn", loadDataYn);
		
		// 주업종 대분류 목록 가져오기
		mv.addObject("largeGroup",hpeCnfirmReqstMapper.selectLargeGroup());
		// 법인등록구분 나라 이름명
		HashMap codeGroupNo = new HashMap();
		codeGroupNo.put("codeGroupNo", 48);
		mv.addObject("crncy_code", codeMapper.findCodeList(codeGroupNo));
		
		
		String winType = MapUtils.getString(rqstMap, "ad_win_type","");
		String viewType = MapUtils.getString(rqstMap, "ad_view_type", "");
		
		if(viewType.equals("view")) {			
			if(winType.equals("pop")) {
				mv.setViewName("/www/my/PD_UIMYU0061");
			}else {
				mv.setViewName("/www/my/BD_UIMYU0061");
			}
		}else {
			if(winType.equals("pop")) {
				mv.setViewName("/www/ic/PD_UIICU0022");
			}else {
				mv.setViewName("/www/ic/BD_UIICU0022");
			}
		}
		
		return mv;
	}
	
	/**
	 * 재무정보 템플릿 
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getFnnrConTmp(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/www/ic/PD_UIICU0022_01");
		int lastYear = MapUtils.getInteger(rqstMap, "year");
		mv.addObject("lastYear", lastYear);
		return mv;
	}
	
	/**
	 * 상시근로자수 템플릿 
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getRabrrConTmp(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/www/ic/PD_UIICU0022_02");
		int lastYear = MapUtils.getInteger(rqstMap, "year");
		mv.addObject("lastYear", lastYear);
		return mv;
	}
	
	/**
	 * 관계기업추가 템플릿 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getRcpyConTmp(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/www/ic/PD_UIICU0022_03");
		int lastYear = MapUtils.getInteger(rqstMap, "year");
		int addRcpyId = MapUtils.getInteger(rqstMap, "addRcpyId");
		
		// 법인등록구분 나라 이름명
		HashMap codeGroupNo = new HashMap();
		codeGroupNo.put("codeGroupNo", 48);
		mv.addObject("crncy_code", codeMapper.findCodeList(codeGroupNo));
		//주업종 대분류
		mv.addObject("largeGroup", hpeCnfirmReqstMapper.selectLargeGroup());
		mv.addObject("lastYear", lastYear);
		mv.addObject("addRcpyId", addRcpyId);
		return mv;
	}
	
	/**
	 * 기업확인신청 저장(임시저장)
	 * 
	 * @param rqstMap
	 * request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView processSaveRequest(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();		
		
		UserVO userVo = SessionUtil.getUserInfo();
		if(Validate.isEmpty(userVo)) {
			throw processException("fail.common.session");
		}
		
		logger.debug("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 신청");
		logger.debug("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 임시저장");
		
		// 저장구분
		String reqstSe = MapUtils.getString(rqstMap, "ad_reqst_se");
		// 접수번호
		String loadRceptNo = MapUtils.getString(rqstMap, "ad_load_rcept_no");
		
		String[] authorGroupCode = userVo.getAuthorGroupCode();
		
		List<String> bizrnoList = new ArrayList<String>();
		
		// 신청기업 최종 진행상태
		Map resnParam = new HashMap();
		resnParam.put("RCEPT_NO", loadRceptNo);
		resnParam.put("RESN_SE", GlobalConst.RESN_SE_S);
		Map resnSMap = issueStatusMngMapper.selectLastestResn(resnParam);
		String seCode = MapUtils.getString(resnSMap, "SE_CODE", "");
		
		// 복수사업자번호
		String[] addBizrnoArr = hpeCnfirmReqstMapper.selectAddBizrnoManage(resnParam);
			
		logger.debug("################################ addBizrnoArr: "+addBizrnoArr);
		logger.debug("################################ bizrnoList: "+bizrnoList);
		
		String adBizrnoHo = MapUtils.getString(rqstMap,"ad_bizrno_ho");           // 사업자등록번호
		if(Validate.isNotEmpty(adBizrnoHo)) {
			bizrnoList.add(adBizrnoHo.replaceAll("-", ""));
		}
		
		/*if(addBizrnoArr.length == 0) {
			String bizrno = MapUtils.getString(rqstMap,"ad_bizrno_ho");           // 사업자등록번호
			if(Validate.isNotEmpty(bizrno)) {
				bizrnoList.add(bizrno.replaceAll("-", ""));
			}
		} else {
			for(String addBizrno : addBizrnoArr) {
				if(Validate.isNotEmpty(addBizrno)) {					
					bizrnoList.add(addBizrno);			
				}
			}
		}*/

		logger.debug("################################ bizrnoList: "+bizrnoList);
		logger.debug("################################ rqstMap: "+rqstMap);
		int addBiznoCnt = MapUtils.getIntValue(rqstMap, "ad_bizrno_cnt", 0);
		String addBizno = "";
		for(int i=1; i<=addBiznoCnt; i++) {
			addBizno = MapUtils.getString(rqstMap, "ad_bizrno_compno_list_" + i, "");
			bizrnoList.add(addBizno);
		}
		
		logger.debug("################################ bizrnoList: "+bizrnoList);
		
		// 보완요청 데이터
		Boolean isSeCodePs3 = false;
		if(seCode.equals(GlobalConst.RESN_SE_CODE_PS3) || seCode.equals(GlobalConst.RESN_SE_CODE_PS4)) {
			isSeCodePs3 = true;
		}
		
		// 관리자 또는 업무 회원
		Boolean isAdminOrBiz = false;
		// 관리자 회원
		if(	ArrayUtil.contains(authorGroupCode, GlobalConst.AUTH_DIV_ADM)||
			ArrayUtil.contains(authorGroupCode, GlobalConst.AUTH_DIV_BIZ)
		){
			isAdminOrBiz = true;
		// 기업회원	
		}else if(ArrayUtil.contains(authorGroupCode, GlobalConst.AUTH_DIV_ENT)){
			if(Validate.isNotEmpty(loadRceptNo)) {
				EntUserVO entUserVo = SessionUtil.getEntUserInfo();
				if(Validate.isEmpty(entUserVo)) {
					throw processException("fail.common.select", new String[] {"기업정보"});	
				}
				
				Map<String,Object> entParam = new HashMap<String,Object>();
				entParam.put("RCEPT_NO", loadRceptNo);
				Map result = hpeCnfirmReqstMapper.selectApplyMaster(entParam);
				
				if(Validate.isEmpty(result)) {
					// 신청접수 데이터 존재하지 않음
					throw processException("errors.reqst.noapplydata");
				}
				
				String resultJurirno = MapUtils.getString(result, "JURIRNO");
				if(!entUserVo.getJurirno().equals(resultJurirno)) {
					// 해당 기업회원 데이터가 아님
					throw processException("errors.reqst.invalidrceptno");
				}				
				
				// 보완요청에 대한 수정이 아닐경우
				if(!isSeCodePs3) {
					// 임시저장데이터 여부 확인
					if(GlobalConst.REQST_SE_AK0.equals(reqstSe)) {
						String resultReqstSe = MapUtils.getString(result, "REQST_SE");
						if(!GlobalConst.REQST_SE_AK0.equals(resultReqstSe)) {
							// 임시저장데이터가 아님
							throw processException("errors.reqst.nottempsavedata");
						}					
					}
				}
			}
		}else {
			// 관리자,업무,기업회원 아님
			throw processException("errors.reqst.invalidmembertype");
		}
		
		// 20171212 추가
		Boolean isAdminNewAt = false; // 관리자 권한으로 기업 신청 여부
		String strAdminNewAt = MapUtils.getString(rqstMap, "ad_admin_new_at", "");
		if(strAdminNewAt.equals("Y")) {
			isAdminNewAt = true;
		}
		
		
		String rceptNo = loadRceptNo;
		if(Validate.isEmpty(rceptNo)) {
			// 접수일련번호 생성
			Map snMap = createRceptSn();
			// 접수일련번호
			int rceptSn = MapUtils.getIntValue(snMap, "rceptSn");
			updateRceptSn(rceptSn);
			// 접수번호
			rceptNo = MapUtils.getString(snMap, "rceptNo");
		}
		
		
		// 임시저장 삭제
		deleteTempEntInfos(rceptNo,rqstMap);
		
		Map<String,Object> sParam = new HashMap<String,Object>();
		String paramJurirno				= MapUtils.getString(rqstMap,"ad_jurirno_ho");			// 법인등록번호
		String paramIssuYear			= MapUtils.getString(rqstMap,"ad_issu_year");			// 확인신청대상년도
		
		// 관리자, 업무 사용자가 저장 할 경우 신청접수상태에 영향을 줄 수 없음
		// 진행상태사유가 보완료청에 대한 수정일 경우 신청접수상태에 영향을 줄 수 없음
		if(!isAdminOrBiz&&!isSeCodePs3) {
			// 대상년도 발급 신청건 조회
			sParam.put("JURIRNO", paramJurirno);
			sParam.put("JDGMNT_REQST_YEAR", paramIssuYear);
			Map applyData = hpeCnfirmReqstMapper.selectApplyMasterReqstYear(sParam);
			if(Validate.isNotEmpty(applyData)) {
				throw processException("fail.common.session");
			}
			
			// 신청접수 등록
			insertApplyMaster(rceptNo,rqstMap);
		} else if(isAdminNewAt) { // 20171212 추가
			// 대상년도 발급 신청건 조회
			sParam.put("JURIRNO", paramJurirno);
			sParam.put("JDGMNT_REQST_YEAR", paramIssuYear);
			Map applyData = hpeCnfirmReqstMapper.selectApplyMasterReqstYear(sParam);
			if(Validate.isNotEmpty(applyData)) {
				throw processException("fail.common.session");
			}
			
			insertApplyMaster(rceptNo,rqstMap);
		}
		
		// 신청기업기초정보 등록
		insertIssuBsisInfo(rceptNo,rqstMap);
		
		// 신청기업주요정보 등록
		insertApplyMainInfo(rceptNo,rqstMap);
		
		logger.debug("################################ bizrnoList: "+bizrnoList);
		// 복수사업자번호관리 등록
		for(String bizrno : bizrnoList) {
			if(Validate.isNotEmpty(bizrno)) {
				resnParam.put("RCEPT_NO", rceptNo);
				resnParam.put("BIZRNO", bizrno);
				hpeCnfirmReqstMapper.insertAddBizrnoManage(resnParam);
			}	
		}
		
		// 신청기업기분소유 등록
		insertApplyInfoQotaPosesn(rceptNo,rqstMap);
		
		// 사업자등록증 파일 등록 - 추가
		insertAddFileData(rceptNo,rqstMap);
				
		// 신청기업재무정보 등록
		insertApplyFnnrData(rceptNo,rqstMap);
		
		// 보완요청인 경우에만 상시근로자수 입력을 받음.
		if(isSeCodePs3) {
			// 신청기업상시근로자수 등록
			inserApplyOrdtmLabrr(rceptNo,rqstMap);
		}
		
		String rcpyIds = MapUtils.getString(rqstMap, "ad_rcpy_id","");
		
		logger.debug("################################ rcpyIds: "+rcpyIds);
		String[] rcpyIdArr = new String[0];
		if(!Validate.isEmpty(rcpyIds)) {
			rcpyIdArr = rcpyIds.split(",");
		}		
				
		for(int i=0;i<rcpyIdArr.length;i++) {
			String rcpyId = rcpyIdArr[i];
			int sn = i+1;
			// 관계기업주요정보 등록
			insertRelateMainInfo(sn, rcpyId, rceptNo, rqstMap);
			
			//관계기업지분소유 등록
			insertRelateInfoQotaPosesn(sn, rcpyId, rceptNo, rqstMap);
			
			// 관계기업재무정보 등록
			insertRelateFnnrData(sn, rcpyId, rceptNo, rqstMap);
			
			// 관계기업상시근로자수정보 등록
			inserRelateOrdtmLabrr(sn, rcpyId, rceptNo, rqstMap);
		}		
		
		if(!isAdminOrBiz) {
			// 상태이력관리 등록
			insertResnManage(rceptNo,rqstMap, isSeCodePs3);		
		} else if (isAdminNewAt) { // 20171212 추가
			insertResnManage(rceptNo,rqstMap, isSeCodePs3);
		}
		Map outMap = new HashMap();
		outMap.put("result", Boolean.TRUE);
		outMap.put("rceptNo", rceptNo);
		String jsonStr = JsonUtil.toJson(outMap);
		
		return ResponseUtil.responseText(mv,jsonStr);
	}
	
	/**
	 * 자가진단
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processSelfDiagnosis(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/www/ic/PD_UIICU0023");
		Map<String, List> resultMap = new HashMap<String, List>();
		Map param = new HashMap<String, Object>();
		String rceptNo = MapUtils.getString(rqstMap, "ad_load_rcept_no");
		String entrprsNm = MapUtils.getString(rqstMap, "ad_entrprs_nm_ho");
		String confmTargetYear = MapUtils.getString(rqstMap, "ad_confm_target_yy");
		
		param.put("RCEPT_NO", rceptNo);
		List<Map> dataList = hpeCnfirmReqstMapper.callSelfDiagnosis(param);
		
		String stdr = "";
		
		for(Map<String, Object> row : dataList) {
			stdr = MapUtils.getString(row, "STDR");			
			if(Validate.isEmpty(stdr)) {
				continue;
			}else if("ST0".equals(stdr)) {
				mv.addObject("ST0", row);
				continue;
			}
			
			if(resultMap.containsKey(stdr)) {
				resultMap.get(stdr).add(row);
			}else {
				List<Map> tempList = new ArrayList<Map>();
				tempList.add(row);
				resultMap.put(stdr, tempList);
				
				String logStdr = MapUtils.getString(row,"STDR");
				String logEntrVal = MapUtils.getString(row,"ENTR_VAL");
				logger.debug("=============================================== stdr: "+logStdr);
				logger.debug("=============================================== entr_val: "+logEntrVal);
			}
			
		}
		
		mv.addObject("targetYear", confmTargetYear);
		mv.addObject("entrprsNm", entrprsNm);
		mv.addObject("selfDiagnosisMap", resultMap);
		
		return mv;
	}
	
	/**
	 * 접수일련번호 생성
	 * 
	 * @return ModelAndView
	 * @throws Exception
	 */
	public Map createRceptSn() throws Exception {
		
		Calendar cal = Calendar.getInstance( ); 
		String curYear = String.valueOf(cal.get(Calendar.YEAR));
		
		Map<String, Object> param = new HashMap<String, Object>();	
		param.put("YEAR", curYear);		
				
		Map result = hpeCnfirmReqstMapper.selectSnMng(param);
		/*
		 *  년도가 넘어가면 다음년도 데이터가 없어서 NullPointerException이 발생한다.
		 *  현재 일련번호등록 insertSnMng로직이 없다.
		 */
		if(result.isEmpty()) {
			throw processException("fail.common.custom",new String[] {"접수번호 생성 오류"});
		}
		
		int rceptSn = MapUtils.getInteger(result, "RCEPT_SN");
		int nextRceptSn = rceptSn+1;
		String rceptNo = curYear+"-"+StringUtil.leftPad(String.valueOf(nextRceptSn), 4, "0");
		Map out = new HashMap();
		out.put("rceptSn", nextRceptSn);
		out.put("rceptNo", rceptNo);
		
		return out;
	}
	
	/**
	 * 접수일련번호 수정
	 * 
	 * @return ModelAndView
	 * @throws Exception
	 */
	public void updateRceptSn(int rceptSn) throws Exception {
		
		Calendar cal = Calendar.getInstance( ); 
		String curYear = String.valueOf(cal.get(Calendar.YEAR));
		
		Map<String, Object> param = new HashMap<String, Object>();	
		param.put("YEAR", curYear);
		param.put("RCEPT_SN", rceptSn);		
				
		hpeCnfirmReqstMapper.updateRceptSn(param);		
	}
	
	/**
	 * 첨부파일 삭제
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView deleteAttFile(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();			
		String fileSeq	= MapUtils.getString(rqstMap,"file_seq");		// 파일순번
		
		Map<String, Object> param = new HashMap<String, Object>();		
		param.put("FILE_SEQ", fileSeq);				
		
		int result = hpeCnfirmReqstMapper.deleteReqstFileBySeq(param);	// 첨부파일
		
		if(result>0) {
			return ResponseUtil.responseText(mv);
		}else {
			return ResponseUtil.responseText(mv,Boolean.FALSE);
		}
	}
	
	/**
	 * 임시기업정보 삭제
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public void deleteTempEntInfos(String rceptNo, Map<?, ?> rqstMap) throws Exception {		
		
		Map<String, Object> param = new HashMap<String, Object>();		
		param.put("RCEPT_NO", rceptNo);
				
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
	}
	
	/**
	 * 상태이력관리 저장
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public void insertResnManage(String rceptNo, Map<?, ?> rqstMap, Boolean isSeCodePs3) throws Exception {
		
		String reqstSe	= MapUtils.getString(rqstMap,"ad_reqst_se","");
		
		// 20171212 추가
		Boolean isAdminNewAt = false; // 관리자 권한으로 기업 신청 여부
		String strAdminNewAt = MapUtils.getString(rqstMap, "ad_admin_new_at", "");
		if(strAdminNewAt.equals("Y")) {
			isAdminNewAt = true;
		}
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		
		if(isSeCodePs3) {
			EntUserVO entUserVo = SessionUtil.getEntUserInfo();
			
			if(Validate.isEmpty(entUserVo)) {				
				throw processException("fail.common.session");
			}
			
			param.put("USER_NO", entUserVo.getUserNo()); 		// 사용자번호
			param.put("RCEPT_NO", rceptNo);						// 접수번호
			param.put("RESN_SE", GlobalConst.RESN_SE_S); 		// 사유구분:진행상태
			param.put("SE_CODE", GlobalConst.RESN_SE_CODE_PS4); // 구분코드:보완접수			
			hpeCnfirmReqstMapper.insertResnManage(param);
			
			// 알림전송
			noticeToEntrprsUser(rceptNo, MapUtils.getString(param, "HIST_SN", ""), null,
					GlobalConst.RESN_SE_CODE_PS4, null);
			// 중견련 담당자 알림전송 방지
			/*
			noticeToEmplyrUser(rceptNo, MapUtils.getString(param, "HIST_SN", ""), 
					GlobalConst.RESN_SE_CODE_PS4, null);
			*/
			
			return;
		}
		
		// 신청구분:확인신청
		if(reqstSe.equals(GlobalConst.REQST_SE_AK1)) {
			EntUserVO entUserVo = SessionUtil.getEntUserInfo();
			
			if(Validate.isEmpty(entUserVo) && !isAdminNewAt) { // 20171212 추가
				throw processException("fail.common.session");
			}

			if(isAdminNewAt) { // 20171212 추가
				param.put("USER_NO", MapUtils.getString(rqstMap, "ad_user_no", "")); 		// 사용자번호
			} else {
				param.put("USER_NO", entUserVo.getUserNo()); 		// 사용자번호
			}
			param.put("RCEPT_NO", rceptNo);						// 접수번호
			param.put("RESN_SE", GlobalConst.RESN_SE_S); 		// 사유구분:진행상태
			param.put("SE_CODE", GlobalConst.RESN_SE_CODE_PS1); // 구분코드:접수			
									
			hpeCnfirmReqstMapper.insertResnManage(param);
			
			// 알림전송
			if(!isAdminNewAt) { // 20171212 추가
				noticeToEntrprsUser(rceptNo, MapUtils.getString(param, "HIST_SN", ""), null,
						GlobalConst.RESN_SE_CODE_PS1, null);
				// 중견련 담당자 알림전송 방지
				/*
				noticeToEmplyrUser(rceptNo, MapUtils.getString(param, "HIST_SN", ""), 
						GlobalConst.RESN_SE_CODE_PS1, null);
				*/
			}
		}
	}
	
	/**
	 * 신청접수마스터 저장
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public void insertApplyMaster(String rceptNo, Map<?, ?> rqstMap) throws Exception {		
		String confmYear = MapUtils.getString(rqstMap,"ad_confm_target_yy");	// 확인신청년도
		String excptTrgetAt = MapUtils.getString(rqstMap,"ad_excpt_trget_at");	// 특례대상여부
		String issuYear	= MapUtils.getString(rqstMap,"ad_issu_year");			// 판정신청년도
		String reqstSe	= MapUtils.getString(rqstMap,"ad_reqst_se","");
		
		if(Validate.isEmpty(confmYear) || Validate.isEmpty(issuYear)) {
			throw processException("errors.reqst.noIssuYear");
		}
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("RCEPT_NO", rceptNo);
		param.put("CONFM_TARGET_YY", confmYear);
		param.put("EXCPT_TRGET_AT", excptTrgetAt);
		param.put("JDGMNT_REQST_YEAR", issuYear);
		
		//	신청구분
		if(reqstSe.equals(GlobalConst.REQST_SE_AK0)) {
			param.put("REQST_SE", GlobalConst.REQST_SE_AK0); // 임시저장
		}else {
			param.put("REQST_SE", GlobalConst.REQST_SE_AK1); // 신청
		}		
		
		hpeCnfirmReqstMapper.insertApplyMaster(param);
	}
	
	/**
	 * 신청기업기초정보 저장
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public void insertIssuBsisInfo(String rceptNo, Map<?, ?> rqstMap) throws Exception {		
		
		String excptTrgetAt		    = MapUtils.getString(rqstMap,"ad_excpt_trget_at");	        // 특례대상여부
		String issuYear		        = MapUtils.getString(rqstMap,"ad_issu_year");	        	// 확인신청대상년도
		
		String rprsntvNm			= MapUtils.getString(rqstMap,"ad_rprsntv_nm_ho");	        // 대표자명
		String hedofcAdres			= MapUtils.getString(rqstMap,"ad_hedofc_adres_01_ho");	    // 본사주소
		
		String zipcodFirst			= MapUtils.getString(rqstMap,"ad_zipcod_first_ho");	        // 우편번호	2015.08.01부로 우편번호가 5자리코드 하나로 들어온다.
		//String zipcodLast			= MapUtils.getString(rqstMap,"ad_zipcod_last_ho");	        // 우편번호
		//String zip = zipcodFirst+zipcodLast;
		String zip = zipcodFirst;
		
		String reprsntTlphonFirst	= MapUtils.getString(rqstMap,"ad_reprsnt_tlphon_first_ho");	// 전화번호
		String reprsntTlphonMiddle	= MapUtils.getString(rqstMap,"ad_reprsnt_tlphon_middle_ho");// 전화번호
		String reprsntTlphonLast	= MapUtils.getString(rqstMap,"ad_reprsnt_tlphon_last_ho");	// 전화번호
		String reprsntTlphon = reprsntTlphonFirst+reprsntTlphonMiddle+reprsntTlphonLast;
		
		String fxnumFirst			= MapUtils.getString(rqstMap,"ad_fxnum_first_ho");	        // FAX번호
		String fxnumMiddle			= MapUtils.getString(rqstMap,"ad_fxnum_middle_ho");	        // FAX번호
		String fxnumLast			= MapUtils.getString(rqstMap,"ad_fxnum_last_ho");	        // FAX번호
		String fxnum = fxnumFirst+fxnumMiddle+fxnumLast;
		
		String prpos				= MapUtils.getString(rqstMap,"ad_prpos_ho");                 // 용도
		String recepdsk				= MapUtils.getString(rqstMap,"ad_recepdsk_ho");              // 제출처		
		String reqst_se_search		= MapUtils.getString(rqstMap,"ad_reqst_se_search");          // 용도체크박스
		
		Map<String, Object> param = new HashMap<String, Object>();		
		param.put("RCEPT_NO", rceptNo);	   			// 접수번호(PK)(FK)
		param.put("RPRSNTV_NM", rprsntvNm);     	// 대표자명        
		param.put("HEDOFC_ADRES", hedofcAdres); 	// 본사주소        
		param.put("ZIP", zip);                		// 우편번호        
		param.put("REPRSNT_TLPHON", reprsntTlphon); // 대표전화        
		param.put("FXNUM", fxnum);              	// 팩스번호        
		param.put("PRPOS", prpos);              	// 용도            
		param.put("RECEPDSK", recepdsk);        	// 제출처
		param.put("CHK_RECEPDSK", reqst_se_search);        	// 제출처

		hpeCnfirmReqstMapper.insertIssuBsisInfo(param);
		
		// 특례대상여부가 Y 일 때에만 중소기업유예확인서 저장
		/*if(excptTrgetAt.equals("Y")) {
			param.put("SN", 1);  					// 순번
			param.put("ENTRPRS_SE", GlobalConst.ENTRPRS_SE_O);	// 기업구분:신청기업
			
			insertRfFile("ho", RF.rf5, issuYear, param, rqstMap);
		}*/
	}
	
	/**
	 * 신청기업주요정보 저장
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public void insertApplyMainInfo(String rceptNo, Map<?, ?> rqstMap) throws Exception {
		String issuYear				= MapUtils.getString(rqstMap,"ad_issu_year");			// 확인신청대상년도
		String jurirno				= MapUtils.getString(rqstMap,"ad_jurirno_ho");			// 법인등록번호
		if(Validate.isNotEmpty(jurirno)) {
			jurirno = jurirno.replaceAll("-", "");
		}
		String entrprsNm			= MapUtils.getString(rqstMap,"ad_entrprs_nm_ho");	    // 기업명
		String bizrno				= MapUtils.getString(rqstMap,"ad_bizrno_ho");           // 사업자등록번호
		if(Validate.isNotEmpty(bizrno)) {
			bizrno = bizrno.replaceAll("-", "");
		}
		
		
		String mnInduty				= MapUtils.getString(rqstMap,"smallGroup");				// 셀렉 값		
		String mnIndutyNm;																	// 주업종명
		String mnIndutyCode;																// 주업종 코드
		
		if(mnInduty != null && mnInduty.length() != 0) {
			String temp[] 			= mnInduty.split(":");									// 나누기			
			mnIndutyCode			= temp[0];												// 주업종코드
			mnIndutyNm				= temp[1];												// 주업종명
		}
		else {
			mnIndutyCode		= "";														// 주업종코드
			mnIndutyNm			= "";														// 주업종명
		}

		String stacntMt				= MapUtils.getString(rqstMap,"ad_stacnt_mt_ho");        // 결산월
		String fondDe				= MapUtils.getString(rqstMap,"ad_fond_de_ho");          // 설립년월	
		if(!Validate.isEmpty(fondDe)) {
			fondDe = fondDe.replaceAll("-", "");
		}
		String partclrMatter		= MapUtils.getString(rqstMap,"ad_partclr_matter_ho");	// 특이사항
		
		// 해당월의 마지막일
		Calendar cal= Calendar.getInstance();
		int stacntMt4Cal = Integer.valueOf(stacntMt.trim())-1;
		cal.set(Calendar.MONTH, stacntMt4Cal);
		int lastDay = cal.getActualMaximum(Calendar.DATE);
		// 결산월+마지막일
		String psacnt = ""+stacntMt+lastDay;	
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("RCEPT_NO", rceptNo);        				// 접수번호(PK)(FK)
		param.put("JURIRNO", jurirno);         				// 법인등록번호(PK)
		param.put("CPR_REGIST_SE", GlobalConst.CPR_REGIST_SE_L);	// 법인등록구분 - 국내
		param.put("ENTRPRS_SE", GlobalConst.ENTRPRS_SE_O);	// 기업구분:신청기업
		param.put("ENTRPRS_NM", entrprsNm);      			// 기업명
		param.put("BIZRNO", bizrno);          				// 사업자등록번호  
		
		param.put("MN_INDUTY_NM", mnIndutyNm);    			// 주업종명
		param.put("MN_INDUTY_CODE", mnIndutyCode);  		// 주업종코드
		
		param.put("PSACNT", psacnt);    					// 결산일          
		param.put("FOND_DE", fondDe);         				// 설립일자        
		param.put("PARTCLR_MATTER", partclrMatter);  		// 특이사항
		param.put("SN", 1);  								// 순번
		param.put("CRNCY_CODE", "KRW");      				// 통화코드
		
		hpeCnfirmReqstMapper.insertReqstRcpyList(param);	
		
	}
	
	
	
	/**
	 * 신청기업지분소유 저장
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public void insertApplyInfoQotaPosesn(String rceptNo, Map<?, ?> rqstMap) throws Exception {
		
		String issuYear		= MapUtils.getString(rqstMap,"ad_issu_year");		// 확인신청대상년도
		String jurirno		= MapUtils.getString(rqstMap,"ad_jurirno_ho");		// 법인등록번호
		String shrholdrNm 	= MapUtils.getString(rqstMap,"ad_shrholdr_nm1_ho");	// 주주명
		String qotaRt1 		= MapUtils.getString(rqstMap,"ad_qota_rt1_ho","");	// 지분소유비율		
		String shrholdrNm2 	= MapUtils.getString(rqstMap,"ad_shrholdr_nm2_ho");	// 주주명1
		String qotaRt2 		= MapUtils.getString(rqstMap,"ad_qota_rt2_ho","");	// 지분소유비율1		
		String shrholdrNm3 	= MapUtils.getString(rqstMap,"ad_shrholdr_nm3_ho");	// 주주명2
		String qotaRt3 		= MapUtils.getString(rqstMap,"ad_qota_rt3_ho","");	// 지분소유비율2
		
		qotaRt1 = Validate.isEmpty(qotaRt1.trim())?null:qotaRt1;
		qotaRt2 = Validate.isEmpty(qotaRt2.trim())?null:qotaRt2;
		qotaRt3 = Validate.isEmpty(qotaRt3.trim())?null:qotaRt3;		
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("RCEPT_NO", rceptNo); 		// 접수번호(PK)(FK)
		param.put("JURIRNO",jurirno);			// 법인등록번호
		param.put("SHRHOLDR_NM1",shrholdrNm);	// 주주명
		param.put("QOTA_RT1",qotaRt1);			// 지분소유비율
		param.put("SHRHOLDR_NM2",shrholdrNm2);	// 주주명1
		param.put("QOTA_RT2",qotaRt2);			// 지분소유비율1
		param.put("SHRHOLDR_NM3",shrholdrNm3);	// 주주명2
		param.put("QOTA_RT3",qotaRt3);			// 지분소유비율2
		param.put("SN", 1);  					// 순번
		param.put("ENTRPRS_SE", GlobalConst.ENTRPRS_SE_O);	// 기업구분:신청기업
		
		hpeCnfirmReqstMapper.insertReqstInfoQotaPosesn(param);
		
		insertRfFile("ho", RF.rf2, issuYear, param, rqstMap);
		
	}	
	
	/**
	 * 신청기업재무 저장
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public void insertApplyFnnrData(String rceptNo, Map<?, ?> rqstMap) throws Exception {
		
		String confmYear = MapUtils.getString(rqstMap,"ad_confm_target_yy");	// 확인신청년도
		int issuYear		= MapUtils.getIntValue(rqstMap,"ad_issu_year");	// 확인신청대상년도
		String jurirno		= MapUtils.getString(rqstMap,"ad_jurirno_ho");	// 법인등록번호		          
		
		String y3sumSelngAm		= MapUtils.getString(rqstMap,"ad_y3sum_selng_am_ho");	// 합계 매출액
		String y3avgSelngAm		= MapUtils.getString(rqstMap,"ad_y3avg_selng_am_ho");	// 평균 매출액		
		
		y3sumSelngAm = Validate.isEmpty(y3sumSelngAm.trim())?null:y3sumSelngAm;
		y3avgSelngAm = Validate.isEmpty(y3avgSelngAm.trim())?null:y3avgSelngAm;
		
		Map<String, Object> param = new HashMap<String, Object>();				
		
		for(int i=0;i<=3;i++) {
			int year = issuYear-i;
			String bsnsYear		= String.valueOf(year);	// 사업년도(PK)
			
			String amountUnit	= MapUtils.getString(rqstMap, "ad_amount_unit_ho_"+year, "");	// 금액단위
			String selngAm      = MapUtils.getString(rqstMap,"ad_selng_am_ho_"+year,"");     	// 매출액
			String capl         = MapUtils.getString(rqstMap,"ad_capl_ho_"+year,"");         	// 자본금                 	  			 
			String clpl         = MapUtils.getString(rqstMap,"ad_clpl_ho_"+year,"");         	// 자본잉여금         					 
			String caplSm       = MapUtils.getString(rqstMap,"ad_capl_sm_ho_"+year,"");			// 자본총계               				
			String assetsTotamt = MapUtils.getString(rqstMap,"ad_assets_totamt_ho_"+year,"");	// 자산총액                					 
			String ordtmLabrrCo = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co_ho_"+year,"");	// 상시근로자수
			
			amountUnit = Validate.isEmpty(amountUnit.trim())?null:amountUnit;
			selngAm = Validate.isEmpty(selngAm.trim())?null:selngAm;		
			capl = Validate.isEmpty(capl.trim())?null:capl;		
			clpl = Validate.isEmpty(clpl.trim())?null:clpl;		
			caplSm = Validate.isEmpty(caplSm.trim())?null:caplSm;		
			assetsTotamt = Validate.isEmpty(assetsTotamt.trim())?null:assetsTotamt;		
			ordtmLabrrCo = Validate.isEmpty(ordtmLabrrCo.trim())?null:ordtmLabrrCo;		
			
			param.put("RCEPT_NO", rceptNo);				// 접수번호(PK)(FK)
			param.put("JURIRNO",jurirno);				// 법인등록번호	
			param.put("BSNS_YEAR", bsnsYear);			// 사업년도(PK)    				
			param.put("SELNG_AM", selngAm);				// 매출액          				
			param.put("CAPL", capl);					// 자본금          			
			param.put("CLPL", clpl);					// 자본잉여금      			
			param.put("CAPL_SM", caplSm);				// 자본총계        			
			param.put("ASSETS_TOTAMT", assetsTotamt);	// 자산총액        					
			param.put("ORDTM_LABRR_CO", ordtmLabrrCo);	// 상시근로자수
			param.put("SN", 1);  						// 순번
			param.put("ENTRPRS_SE", GlobalConst.ENTRPRS_SE_O);	// 기업구분:신청기업
			param.put("CRNCY_CODE", "KRW");      				// 통화코드
			param.put("AMOUNT_UNIT", amountUnit);		// 금액단위
			param.put("confmYear", confmYear);		// 확인신청대상년도
			
			logger.debug("=============================================== insertApplyFnnrData-confmYear: "+confmYear);
			
			if(i==0) {				
				param.put("Y3SUM_SELNG_AM", y3sumSelngAm);		// 3년합계 매출액
				param.put("Y3AVG_SELNG_AM", y3avgSelngAm);		// 3년평균 매출액				
			}
			
			hpeCnfirmReqstMapper.insertReqstFnnrData(param);			
			
			insertRfFile("ho", RF.rf1, bsnsYear, param, rqstMap);
			
			param.clear();
		}
	}
	
	/**
	 * 사업자등록증 파일 등록 - 추가
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public void insertAddFileData(String rceptNo, Map<?, ?> rqstMap) throws Exception {
		
		String issuYear		= MapUtils.getString(rqstMap,"ad_issu_year");		// 확인신청대상년도
		String jurirno		= MapUtils.getString(rqstMap,"ad_jurirno_ho");		// 법인등록번호
		String shrholdrNm 	= MapUtils.getString(rqstMap,"ad_shrholdr_nm1_ho");	// 주주명
		String qotaRt1 		= MapUtils.getString(rqstMap,"ad_qota_rt1_ho","");	// 지분소유비율		
		String shrholdrNm2 	= MapUtils.getString(rqstMap,"ad_shrholdr_nm2_ho");	// 주주명1
		String qotaRt2 		= MapUtils.getString(rqstMap,"ad_qota_rt2_ho","");	// 지분소유비율1		
		String shrholdrNm3 	= MapUtils.getString(rqstMap,"ad_shrholdr_nm3_ho");	// 주주명2
		String qotaRt3 		= MapUtils.getString(rqstMap,"ad_qota_rt3_ho","");	// 지분소유비율2
		
		qotaRt1 = Validate.isEmpty(qotaRt1.trim())?null:qotaRt1;
		qotaRt2 = Validate.isEmpty(qotaRt2.trim())?null:qotaRt2;
		qotaRt3 = Validate.isEmpty(qotaRt3.trim())?null:qotaRt3;		
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("RCEPT_NO", rceptNo); 		// 접수번호(PK)(FK)
		param.put("JURIRNO",jurirno);			// 법인등록번호
		param.put("SHRHOLDR_NM1",shrholdrNm);	// 주주명
		param.put("QOTA_RT1",qotaRt1);			// 지분소유비율
		param.put("SHRHOLDR_NM2",shrholdrNm2);	// 주주명1
		param.put("QOTA_RT2",qotaRt2);			// 지분소유비율1
		param.put("SHRHOLDR_NM3",shrholdrNm3);	// 주주명2
		param.put("QOTA_RT3",qotaRt3);			// 지분소유비율2
		param.put("SN", 1);  					// 순번
		param.put("ENTRPRS_SE", GlobalConst.ENTRPRS_SE_O);	// 기업구분:신청기업
		
		insertRfFile("ho", RF.rf4, issuYear, param, rqstMap);
		insertRfFile("ho", RF.rf3, issuYear, param, rqstMap);
		
	}
	
	/**
	 * 신청기업상시근로자수 저장
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public void inserApplyOrdtmLabrr(String rceptNo, Map<?, ?> rqstMap) throws Exception {
		
		int issuYear		= MapUtils.getIntValue(rqstMap,"ad_issu_year");	// 확인신청대상년도
		String jurirno		= MapUtils.getString(rqstMap,"ad_jurirno_ho");	// 법인등록번호		          
		
		
		Map<String, Object> param = new HashMap<String, Object>();		
		
		for(int i=0;i<=3;i++) {			
			int year = issuYear-i;
			if(year>2013) {
				continue;
			}
			String bsnsYear		= String.valueOf(year); // 사업년도(PK)
			
            String ordtmLabrrCo1     = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co1_ho_"+year,"");
            String ordtmLabrrCo2     = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co2_ho_"+year,"");
            String ordtmLabrrCo3     = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co3_ho_"+year,"");
            String ordtmLabrrCo4     = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co4_ho_"+year,"");
            String ordtmLabrrCo5     = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co5_ho_"+year,"");
            String ordtmLabrrCo6     = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co6_ho_"+year,"");
            String ordtmLabrrCo7     = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co7_ho_"+year,"");
            String ordtmLabrrCo8     = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co8_ho_"+year,"");
            String ordtmLabrrCo9     = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co9_ho_"+year,"");
            String ordtmLabrrCo10    = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co10_ho_"+year,"");
            String ordtmLabrrCo11    = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co11_ho_"+year,"");
            String ordtmLabrrCo12    = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co12_ho_"+year,"");
            
            String ordtmLabrrCoSm    = MapUtils.getString(rqstMap,"ad_ordtm_labrr_sum_ho_"+year,""); 	// 합계
            String ordtmLabrrCo    	 = MapUtils.getString(rqstMap,"ad_ordtm_labrr_avg_ho_"+year,""); 	// 연평균
			
			ordtmLabrrCo1	= Validate.isEmpty(ordtmLabrrCo1.trim())?null:ordtmLabrrCo1;
			ordtmLabrrCo2	= Validate.isEmpty(ordtmLabrrCo2.trim())?null:ordtmLabrrCo2;
			ordtmLabrrCo3	= Validate.isEmpty(ordtmLabrrCo3.trim())?null:ordtmLabrrCo3;
			ordtmLabrrCo4	= Validate.isEmpty(ordtmLabrrCo4.trim())?null:ordtmLabrrCo4;
			ordtmLabrrCo5	= Validate.isEmpty(ordtmLabrrCo5.trim())?null:ordtmLabrrCo5;
			ordtmLabrrCo6	= Validate.isEmpty(ordtmLabrrCo6.trim())?null:ordtmLabrrCo6;
			ordtmLabrrCo7	= Validate.isEmpty(ordtmLabrrCo7.trim())?null:ordtmLabrrCo7;
			ordtmLabrrCo8	= Validate.isEmpty(ordtmLabrrCo8.trim())?null:ordtmLabrrCo8;
			ordtmLabrrCo9	= Validate.isEmpty(ordtmLabrrCo9.trim())?null:ordtmLabrrCo9;
			ordtmLabrrCo10	= Validate.isEmpty(ordtmLabrrCo10.trim())?null:ordtmLabrrCo10;
			ordtmLabrrCo11	= Validate.isEmpty(ordtmLabrrCo11.trim())?null:ordtmLabrrCo11;
			ordtmLabrrCo12	= Validate.isEmpty(ordtmLabrrCo12.trim())?null:ordtmLabrrCo12;
			
			ordtmLabrrCoSm	= Validate.isEmpty(ordtmLabrrCoSm.trim())?null:ordtmLabrrCoSm;
			ordtmLabrrCo	= Validate.isEmpty(ordtmLabrrCo.trim())?null:ordtmLabrrCo;
			
			param.put("RCEPT_NO", rceptNo);					// 접수번호(PK)(FK)		
			param.put("JURIRNO",jurirno);					// 법인등록번호	
			param.put("BSNS_YEAR", bsnsYear);				// 사업년도(PK)
			param.put("ORDTM_LABRR_CO1",  ordtmLabrrCo1);	// 상시근로자수1
			param.put("ORDTM_LABRR_CO2",  ordtmLabrrCo2);	// 평상시근로자2
			param.put("ORDTM_LABRR_CO3",  ordtmLabrrCo3);	// 상시근로자수3
			param.put("ORDTM_LABRR_CO4",  ordtmLabrrCo4);	// 상시근로자수4
			param.put("ORDTM_LABRR_CO5",  ordtmLabrrCo5);	// 상시근로자수5
			param.put("ORDTM_LABRR_CO6",  ordtmLabrrCo6);	// 상시근로자수6
			param.put("ORDTM_LABRR_CO7",  ordtmLabrrCo7);	// 상시근로자수7
			param.put("ORDTM_LABRR_CO8",  ordtmLabrrCo8);	// 상시근로자수8
			param.put("ORDTM_LABRR_CO9",  ordtmLabrrCo9);	// 상시근로자수9
			param.put("ORDTM_LABRR_CO10", ordtmLabrrCo10);	// 상시근로자수10
			param.put("ORDTM_LABRR_CO11", ordtmLabrrCo11);	// 상시근로자수11
			param.put("ORDTM_LABRR_CO12", ordtmLabrrCo12);	// 상시근로자수12
			
			param.put("ORDTM_LABRR_CO_SM", ordtmLabrrCoSm);	// 합계
			param.put("ORDTM_LABRR_CO", ordtmLabrrCo);		// 연평균
			
			param.put("SN", 1);  							// 순번
			param.put("ENTRPRS_SE", GlobalConst.ENTRPRS_SE_O);	// 기업구분:신청기업
			
			hpeCnfirmReqstMapper.insertReqstOrdtmLabrr(param);
			
			insertRfFile("ho", RF.rf0, String.valueOf(year), param, rqstMap);
			
			param.clear();
		}
		
	}
	
	/**
	 * 관계기업주요정보 저장
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public void insertRelateMainInfo(int sn, String rId, String rceptNo, Map<?, ?> rqstMap) throws Exception {		
		
		String rcpyDiv 			= MapUtils.getString(rqstMap,"ad_rcpy_div_"+rId);		// 관계기업구분
		String qotaRr			= MapUtils.getString(rqstMap,"ad_qota_tr_"+rId,"");		// 지분율
		String entrprsNm		= MapUtils.getString(rqstMap,"ad_entrprs_nm_"+rId);		// 기업명
		String rprsntvNm		= MapUtils.getString(rqstMap,"ad_r_rprsntv_nm_ho_"+rId);	        // 대표자명
		String cprRegistSe		= MapUtils.getString(rqstMap,"ad_cpr_regist_se_"+rId);	// 법인등록구분
		String crncyCode		= MapUtils.getString(rqstMap,"ad_crncy_code_"+rId);		// 통화코드
		String jurirnoFirst		= MapUtils.getString(rqstMap,"ad_jurirno_first_"+rId);	// 법인등록번호 앞자리
		String jurirnoLast		= MapUtils.getString(rqstMap,"ad_jurirno_last_"+rId);	// 법인등록번호 뒷자리
		String jurirno = jurirnoFirst+jurirnoLast;
		if(Validate.isNotEmpty(jurirno)) {
			jurirno = jurirno.replaceAll("-", "");
		}
		
		String bizrnoFirst		= MapUtils.getString(rqstMap,"ad_bizrno_first_"+rId);	// 사업자등록번호 앞자리
		String bizrnoMiddle		= MapUtils.getString(rqstMap,"ad_bizrno_middle_"+rId);	// 사업자등록번호 앞자리
		String bizrnoLast		= MapUtils.getString(rqstMap,"ad_bizrno_last_"+rId);	// 사업자등록번호 앞자리		
		String bizrno = bizrnoFirst+bizrnoMiddle+bizrnoLast;
		if(Validate.isNotEmpty(bizrno)) {
			bizrno = bizrno.replaceAll("-", "");
		}
		
		String mnInduty			= MapUtils.getString(rqstMap,"smallGroup_"+rId);		// 업종코드 + 업종명
		logger.debug("1234123"+mnInduty);
		String mnIndutyCode;
		String mnIndutyNm;
		
		if(mnInduty != null && mnInduty.length() != 0) {
			String temp[] 			= mnInduty.split(":");							// 나누기			
			mnIndutyCode			= temp[0];										// 주업종코드
			mnIndutyNm				= temp[1];										// 주업종명
			logger.debug(mnIndutyCode);
		}
		else {
			mnIndutyCode		= "";												// 주업종코드
			mnIndutyNm			= "";												// 주업종명
			logger.debug(mnIndutyCode);
		}

		String stacntMt			= MapUtils.getString(rqstMap,"ad_stacnt_mt_"+rId);		// 결산월
		String fondDe			= MapUtils.getString(rqstMap,"ad_fond_de_"+rId);		// 설립년월
		if(Validate.isNotEmpty(fondDe)) {
			fondDe = fondDe.replaceAll("-", "");
		}
		
		String partclrMatter	= MapUtils.getString(rqstMap,"ad_partclr_matter_"+rId);	// 특이사항
		
		qotaRr = Validate.isEmpty(qotaRr.trim())?null:qotaRr;
		
		
		// 해당월의 마지막일
		Calendar cal= Calendar.getInstance();
		int stacntMt4Cal = Integer.valueOf(stacntMt)-1;
		cal.set(Calendar.MONTH, stacntMt4Cal);
		int lastDay = cal.getActualMaximum(Calendar.DATE);
		// 결산월+마지막일
		String psacnt = ""+stacntMt+lastDay;	
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("RCEPT_NO", rceptNo);        				// 접수번호(PK)(FK)
		param.put("JURIRNO", jurirno);         				// 법인등록번호(PK)
		param.put("ENTRPRS_SE", GlobalConst.ENTRPRS_SE_R);	// 기업구분:관계기업
		param.put("CPR_REGIST_SE", cprRegistSe);         	// 법인등록구분
		param.put("QOTA_RT", qotaRr);         				// 지분율
		param.put("ENTRPRS_NM", entrprsNm);      			// 기업명
		param.put("RPRSNTV_NM", rprsntvNm);     			// 대표자명
		param.put("BIZRNO", bizrno);          				// 사업자등록번호  
		param.put("MN_INDUTY_NM", mnIndutyNm);    			// 주업종명        
		param.put("MN_INDUTY_CODE", mnIndutyCode);  		// 주업종코드    
		param.put("PSACNT", psacnt);    					// 결산일          
		param.put("FOND_DE", fondDe);         				// 설립일자        
		param.put("PARTCLR_MATTER", partclrMatter);  		// 특이사항
		param.put("RCPY_DIV", rcpyDiv);        				// 관계기업구분
		param.put("CRNCY_CODE", crncyCode);      			// 통화코드
		param.put("SN", sn);  								// 순번		
			
		hpeCnfirmReqstMapper.insertReqstRcpyList(param);
	}
	
	/**
	 * 관계기업지분소유 저장
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public void insertRelateInfoQotaPosesn(int sn, String rId, String rceptNo, Map<?, ?> rqstMap) throws Exception {
		String issuYear		= MapUtils.getString(rqstMap,"ad_issu_year");			// 확인신청대상년도
		String jurirnoFirst	= MapUtils.getString(rqstMap,"ad_jurirno_first_"+rId);	// 법인등록번호 앞자리
		String jurirnoLast	= MapUtils.getString(rqstMap,"ad_jurirno_last_"+rId);	// 법인등록번호 뒷자리
		String jurirno = jurirnoFirst+jurirnoLast;
		
		String shrholdrNm 	= MapUtils.getString(rqstMap,"ad_shrholdr_nm1_"+rId);	// 주주명
		String qotaRt1 		= MapUtils.getString(rqstMap,"ad_qota_rt1_"+rId,"");	// 지분소유비율		
		String shrholdrNm2 	= MapUtils.getString(rqstMap,"ad_shrholdr_nm2_"+rId);	// 주주명1
		String qotaRt2 		= MapUtils.getString(rqstMap,"ad_qota_rt2_"+rId,"");	// 지분소유비율1		
		String shrholdrNm3 	= MapUtils.getString(rqstMap,"ad_shrholdr_nm3_"+rId);	// 주주명2
		String qotaRt3 		= MapUtils.getString(rqstMap,"ad_qota_rt3_"+rId,"");	// 지분소유비율2
		
		qotaRt1 = Validate.isEmpty(qotaRt1.trim())?null:qotaRt1;
		qotaRt2 = Validate.isEmpty(qotaRt2.trim())?null:qotaRt2;
		qotaRt3 = Validate.isEmpty(qotaRt3.trim())?null:qotaRt3;		
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("RCEPT_NO", rceptNo); 		// 접수번호(PK)(FK)
		param.put("JURIRNO",jurirno);			// 법인등록번호
		param.put("SHRHOLDR_NM1",shrholdrNm);	// 주주명
		param.put("QOTA_RT1",qotaRt1);			// 지분소유비율
		param.put("SHRHOLDR_NM2",shrholdrNm2);	// 주주명1
		param.put("QOTA_RT2",qotaRt2);			// 지분소유비율1
		param.put("SHRHOLDR_NM3",shrholdrNm3);	// 주주명2
		param.put("QOTA_RT3",qotaRt3);			// 지분소유비율2
		param.put("SN", sn);  					// 순번
		param.put("ENTRPRS_SE", GlobalConst.ENTRPRS_SE_R);	// 기업구분:관계기업
		
		hpeCnfirmReqstMapper.insertReqstInfoQotaPosesn(param);
		
		logger.debug("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ insertRelateInfoQotaPosesn 파일입력 시작: "+ sn+" : "+ rId +" : "+ rceptNo);
		insertRfFile(rId, RF.rf2, issuYear, param, rqstMap);
		
	}	
	
	/**
	 * 관계기업재무 저장
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public void insertRelateFnnrData(int sn, String rId, String rceptNo, Map<?, ?> rqstMap) throws Exception {
		
		String confmYear = MapUtils.getString(rqstMap,"ad_confm_target_yy");	// 확인신청년도
		int issuYear			= MapUtils.getIntValue(rqstMap,"ad_issu_year");			// 확인신청대상년도
		String jurirnoFirst		= MapUtils.getString(rqstMap,"ad_jurirno_first_"+rId);	// 법인등록번호 앞자리
		String jurirnoLast		= MapUtils.getString(rqstMap,"ad_jurirno_last_"+rId);	// 법인등록번호 뒷자리
		String jurirno = jurirnoFirst+jurirnoLast;
		
		String y3sumSelngAm		= MapUtils.getString(rqstMap,"ad_y3sum_selng_am_"+rId,"");	// 3년합계 매출액
		String y3avgSelngAm		= MapUtils.getString(rqstMap,"ad_y3avg_selng_am_"+rId,"");	// 3년평균 매출액
		
		String crncyCode		= MapUtils.getString(rqstMap,"ad_crncy_code_"+rId);		// 통화코드
		
		logger.debug("%%%%%%%%%%%%%%%%%%%%%%%%%% y3sumSelngAm: "+y3sumSelngAm);
		logger.debug("%%%%%%%%%%%%%%%%%%%%%%%%%% y3avgSelngAm: "+y3avgSelngAm);
		
		y3sumSelngAm = Validate.isEmpty(y3sumSelngAm.trim())?null:y3sumSelngAm;
		y3avgSelngAm = Validate.isEmpty(y3avgSelngAm.trim())?null:y3avgSelngAm;
		
		
		Map<String, Object> param = new HashMap<String, Object>();		
		
		for(int i=0;i<=2;i++) {
			int year = issuYear-i;
			String bsnsYear		= String.valueOf(year);	// 사업년도(PK)
			
			String amountUnit	= MapUtils.getString(rqstMap,"ad_amount_unit_"+rId+"_"+year,"");	// 금액단위
			String selngAm      = MapUtils.getString(rqstMap,"ad_selng_am_"+rId+"_"+year,"");     	// 매출액
			String capl         = MapUtils.getString(rqstMap,"ad_capl_"+rId+"_"+year,"");         	// 자본금                 	  			 
			String clpl         = MapUtils.getString(rqstMap,"ad_clpl_"+rId+"_"+year,"");         	// 자본잉여금         					 
			String caplSm       = MapUtils.getString(rqstMap,"ad_capl_sm_"+rId+"_"+year,"");		// 자본총계               				
			String assetsTotamt = MapUtils.getString(rqstMap,"ad_assets_totamt_"+rId+"_"+year,"");	// 자산총액                					 
			String ordtmLabrrCo = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co_"+rId+"_"+year,"");	// 상시근로자수
			
			amountUnit = Validate.isEmpty(amountUnit.trim())?null:amountUnit;
			selngAm = Validate.isEmpty(selngAm.trim())?null:selngAm;
			capl = Validate.isEmpty(capl.trim())?null:capl;
			clpl = Validate.isEmpty(clpl.trim())?null:clpl;
			caplSm = Validate.isEmpty(caplSm.trim())?null:caplSm;
			assetsTotamt = Validate.isEmpty(assetsTotamt.trim())?null:assetsTotamt;
			ordtmLabrrCo = Validate.isEmpty(ordtmLabrrCo.trim())?null:ordtmLabrrCo;
			
			param.put("RCEPT_NO", rceptNo);			// 접수번호(PK)(FK)
			param.put("JURIRNO",jurirno);			// 법인등록번호
			param.put("BSNS_YEAR", bsnsYear);		// 사업년도(PK)
			param.put("SELNG_AM", selngAm);			// 매출액
			param.put("CRNCY_CODE", crncyCode);     // 통화코드
			param.put("AMOUNT_UNIT", amountUnit);	// 금액단위
			param.put("confmYear", confmYear);		// 확인신청대상년도
			
			logger.debug("=============================================== insertRelateFnnrData-confmYear: "+confmYear);
			
			if(i==0) {
				param.put("CAPL", capl);						// 자본금          			
				param.put("CLPL", clpl);						// 자본잉여금      			
				param.put("CAPL_SM", caplSm);					// 자본총계        			
				param.put("ASSETS_TOTAMT", assetsTotamt);		// 자산총액        					
				param.put("ORDTM_LABRR_CO", ordtmLabrrCo);		// 상시근로자수
				param.put("Y3SUM_SELNG_AM", y3sumSelngAm);		// 3년합계 매출액
				param.put("Y3AVG_SELNG_AM", y3avgSelngAm);		// 3년평균 매출액
				
			}
			param.put("SN", sn);  								// 순번
			param.put("ENTRPRS_SE", GlobalConst.ENTRPRS_SE_R);	// 기업구분:관계기업
			
			hpeCnfirmReqstMapper.insertReqstFnnrData(param);
			
			insertRfFile(rId, RF.rf1, bsnsYear, param, rqstMap);
			param.clear();
		}
		
	}
	
	/**
	 * 관계기업상시근로자수 저장
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public void inserRelateOrdtmLabrr(int sn, String rId, String rceptNo, Map<?, ?> rqstMap) throws Exception {
		
		int issuYear		= MapUtils.getIntValue(rqstMap,"ad_issu_year");	// 확인신청대상년도
		String jurirno		= MapUtils.getString(rqstMap,"ad_jurirno_ho");	// 법인등록번호
		
		Map<String, Object> param = new HashMap<String, Object>();
		int year = issuYear;
		
		String bsnsYear		= String.valueOf(year); // 사업년도(PK)
		
        String ordtmLabrrCo1     = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co1_"+rId+"_"+year,"");
        String ordtmLabrrCo2     = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co2_"+rId+"_"+year,"");
        String ordtmLabrrCo3     = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co3_"+rId+"_"+year,"");
        String ordtmLabrrCo4     = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co4_"+rId+"_"+year,"");
        String ordtmLabrrCo5     = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co5_"+rId+"_"+year,"");
        String ordtmLabrrCo6     = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co6_"+rId+"_"+year,"");
        String ordtmLabrrCo7     = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co7_"+rId+"_"+year,"");
        String ordtmLabrrCo8     = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co8_"+rId+"_"+year,"");
        String ordtmLabrrCo9     = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co9_"+rId+"_"+year,"");
        String ordtmLabrrCo10    = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co10_"+rId+"_"+year,"");
        String ordtmLabrrCo11    = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co11_"+rId+"_"+year,"");
        String ordtmLabrrCo12    = MapUtils.getString(rqstMap,"ad_ordtm_labrr_co12_"+rId+"_"+year,"");  
        
        String ordtmLabrrCoSm    = MapUtils.getString(rqstMap,"ad_ordtm_labrr_sum_"+rId+"_"+year,""); 	// 합계
        String ordtmLabrrCo    	 = MapUtils.getString(rqstMap,"ad_ordtm_labrr_avg_"+rId+"_"+year,""); 	// 연평균
		
		ordtmLabrrCo1	= Validate.isEmpty(ordtmLabrrCo1.trim())?null:ordtmLabrrCo1;
		ordtmLabrrCo2	= Validate.isEmpty(ordtmLabrrCo2.trim())?null:ordtmLabrrCo2;
		ordtmLabrrCo3	= Validate.isEmpty(ordtmLabrrCo3.trim())?null:ordtmLabrrCo3;
		ordtmLabrrCo4	= Validate.isEmpty(ordtmLabrrCo4.trim())?null:ordtmLabrrCo4;
		ordtmLabrrCo5	= Validate.isEmpty(ordtmLabrrCo5.trim())?null:ordtmLabrrCo5;
		ordtmLabrrCo6	= Validate.isEmpty(ordtmLabrrCo6.trim())?null:ordtmLabrrCo6;
		ordtmLabrrCo7	= Validate.isEmpty(ordtmLabrrCo7.trim())?null:ordtmLabrrCo7;
		ordtmLabrrCo8	= Validate.isEmpty(ordtmLabrrCo8.trim())?null:ordtmLabrrCo8;
		ordtmLabrrCo9	= Validate.isEmpty(ordtmLabrrCo9.trim())?null:ordtmLabrrCo9;
		ordtmLabrrCo10	= Validate.isEmpty(ordtmLabrrCo10.trim())?null:ordtmLabrrCo10;
		ordtmLabrrCo11	= Validate.isEmpty(ordtmLabrrCo11.trim())?null:ordtmLabrrCo11;
		ordtmLabrrCo12	= Validate.isEmpty(ordtmLabrrCo12.trim())?null:ordtmLabrrCo12;
		
		ordtmLabrrCoSm	= Validate.isEmpty(ordtmLabrrCoSm.trim())?null:ordtmLabrrCoSm;
		ordtmLabrrCo	= Validate.isEmpty(ordtmLabrrCo.trim())?null:ordtmLabrrCo;
		
		param.put("RCEPT_NO", rceptNo);					// 접수번호(PK)(FK)		
		param.put("JURIRNO",jurirno);					// 법인등록번호	
		param.put("BSNS_YEAR", bsnsYear);				// 사업년도(PK)
		param.put("ORDTM_LABRR_CO1",  ordtmLabrrCo1);	// 상시근로자수1
		param.put("ORDTM_LABRR_CO2",  ordtmLabrrCo2);	// 평상시근로자2
		param.put("ORDTM_LABRR_CO3",  ordtmLabrrCo3);	// 상시근로자수3
		param.put("ORDTM_LABRR_CO4",  ordtmLabrrCo4);	// 상시근로자수4
		param.put("ORDTM_LABRR_CO5",  ordtmLabrrCo5);	// 상시근로자수5
		param.put("ORDTM_LABRR_CO6",  ordtmLabrrCo6);	// 상시근로자수6
		param.put("ORDTM_LABRR_CO7",  ordtmLabrrCo7);	// 상시근로자수7
		param.put("ORDTM_LABRR_CO8",  ordtmLabrrCo8);	// 상시근로자수8
		param.put("ORDTM_LABRR_CO9",  ordtmLabrrCo9);	// 상시근로자수9
		param.put("ORDTM_LABRR_CO10", ordtmLabrrCo10);	// 상시근로자수10
		param.put("ORDTM_LABRR_CO11", ordtmLabrrCo11);	// 상시근로자수11
		param.put("ORDTM_LABRR_CO12", ordtmLabrrCo12);	// 상시근로자수12
		
		param.put("ORDTM_LABRR_CO_SM", ordtmLabrrCoSm);	// 합계
		param.put("ORDTM_LABRR_CO", ordtmLabrrCo);		// 연평균
		
		param.put("SN", sn);  								// 순번
		param.put("ENTRPRS_SE", GlobalConst.ENTRPRS_SE_R);	// 기업구분:신청기업
		
		hpeCnfirmReqstMapper.insertReqstOrdtmLabrr(param);
		
		insertRfFile(rId, RF.rf0, bsnsYear, param, rqstMap);
		
		param.clear();		
		
	}
	
	
	/**
	 * 첨부파일(제출서류) 저장
	 * 
	 * @param String id		입력파일 아이디
	 * @param RF rf			첨부파일 타입
	 * @param String year	첨부파일 년도
	 * @param Map param		DB param
	 * @param Map rqstMap
	 * @throws Exception
	 */
	private void insertRfFile(String id, RF rf, String year, Map param, Map rqstMap) throws Exception {
		StringBuffer sb = new StringBuffer();
		sb.append("ad_file_");
		sb.append(id);
		sb.append("_");
		sb.append(rf);
		if(!(id.equals("ho")&&(rf.equals(RF.rf2)||rf.equals(RF.rf5)||rf.equals(RF.rf4)||rf.equals(RF.rf3)))) {
			sb.append("_");
			sb.append(year);
		}
		
		
		logger.debug("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ insertRfFile 파일 검색: "+sb.toString());
		
		// 신청기업 주주명부 첨부파일		
		String bfRfFile = MapUtils.getString(rqstMap,sb.toString());	// 이전 첨부파일 정보
		switch(rf) {
		case rf0:
			param.put("FILE_KND", GlobalConst.FILE_KND_RF0);
			break;
		case rf1:
			param.put("FILE_KND", GlobalConst.FILE_KND_RF1);
			break;
		case rf2:
			param.put("FILE_KND", GlobalConst.FILE_KND_RF2);
			break;
		case rf3:
			param.put("FILE_KND", GlobalConst.FILE_KND_RF3);
			break;
		case rf4:
			param.put("FILE_KND", GlobalConst.FILE_KND_RF4);
			break;
		case rf5:
			param.put("FILE_KND", GlobalConst.FILE_KND_RF5);
			break;
		}		
		param.put("YEAR", year);
		
		if(Validate.isNotEmpty(bfRfFile)) {
			param.put("FILE_SEQ", bfRfFile);
			hpeCnfirmReqstMapper.insertReqstFile(param);			
		}else {
			MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)rqstMap.get(GlobalConst.RQST_MULTIPART);
			
			if(Validate.isEmpty(mptRequest)) {return;}
			
			sb = new StringBuffer();
			sb.append("file_");
			sb.append(id);
			sb.append("_");
			sb.append(rf);
			if(!(id.equals("ho")&&(rf.equals(RF.rf2)||rf.equals(RF.rf5)||rf.equals(RF.rf4)||rf.equals(RF.rf3)))) {
				sb.append("_");
				sb.append(year);
			}
			
			List<MultipartFile> multipartFiles = mptRequest.getFiles(sb.toString());
			
			if(Validate.isEmpty(multipartFiles)) {return;}
			if(multipartFiles.get(0).isEmpty()) {return;}		
			
			List<FileVO> fileList = new ArrayList<FileVO>();
			
			fileList = UploadHelper.upload(multipartFiles, "test");
			
			int fileSeq = fileDao.saveFile(fileList,-1);		
			
			// 파일 업로드 성공
			if(fileList.size() > 0 && fileSeq > -1) {				
				param.put("FILE_SEQ", fileSeq);
				param.put("FILE_NM", fileDao.getFiles(fileSeq).get(0).getLocalNm());				
				hpeCnfirmReqstMapper.insertReqstFile(param);				
			// 파일 업로드 실패
	    	}else {
	    		// 파일업로드 실패
				throw processException("errors.reqst.failtouploadfile");
	    		
	    	}
		}
	}
	
	/**
	 * 기업사용자 확인서 상태 알림 (SMS, EMAIL)
	 * @param rceptNo 접수번호
	 * @param hist_sn 이력순번
	 * @param resn 사유(발급의 경우 유효기간 포맷)
	 * @param resn_s 진행상태 코드
	 * @param resn_r 진행결과 코드
	 * @throws Exception 
	 */
	public void noticeToEntrprsUser(String rceptNo, String hist_sn, String resn, String resn_s, String resn_r) throws Exception {
		
		HashMap dataParam = new HashMap();
		HashMap smsParam = new HashMap();
		HashMap emailParam = new HashMap();
		
		// SMS 알림 정보
		String smsContent = "";
		String mbtlNum = "";
		String refKeyPreFix = "EP";
		
		// EMAIL 알림 정보
		String sndrNm = "[기업정보]";
		String rcverNm = "";
		String rcverEmail = "";
		String emailSbj = "";
		String emailMsg = "";
		String templatFile = "TMPL_ISSU_STATUS.html";		
		
		// 접수 등록시 사용자 번호 조회
		dataParam.put("RCEPT_NO", rceptNo);				
		
		// 신청접수 마스터 조회
		Map applyMaster = hpeCnfirmReqstMapper.selectApplyMaster(dataParam);
		dataParam.put("JURIRNO", MapUtils.getString(applyMaster, "JURIRNO"));
		
		// 기업사용자 정보 조회
		EntUserVO entUserVo = userService.findEntUserByJurirno(dataParam);
		
		String issuYear = MapUtils.getString(applyMaster, "CONFM_TARGET_YY");	// 확인신청년도				
		
		if(Validate.isEmpty(entUserVo)) {
			return;
		}
		
		mbtlNum = entUserVo.getMbtlnum();
		rcverEmail = entUserVo.getEmail();
		rcverNm = entUserVo.getEntrprsNm();		
		
		resn_s = resn_s == null ? "" : resn_s;
		resn_r = resn_r == null ? "" : resn_r;
		resn = resn == null ? "" : resn;
		
		// SMS, EMAIL 메세지, 템플릿 결정
		if(resn_s.equals(GlobalConst.RESN_SE_CODE_PS1)) {
			smsContent = rcverNm + "의 기업확인서가 접수되었습니다.";
			emailMsg = "기업확인 신청이 접수되었습니다.";			
			
		}else if(resn_s.equals(GlobalConst.RESN_SE_CODE_PS3)) {
			smsContent = rcverNm + "의 기업확인서 보완요청이 있습니다. 신청내역조회를 확인하세요.";
			emailMsg = "기업확인 신청에 대한 보완요청이 등록되었습니다. 자세한 내용은 신청내역조회를 확인하시기 바랍니다.";
			resn = "[보완요청사유] " + resn;
			templatFile = "TMPL_ISSU_STATUS_PS3.html";
			
		}else if(resn_s.equals(GlobalConst.RESN_SE_CODE_PS4)) {
			smsContent = rcverNm + "의 기업확인서 서류가 보완접수 되었습니다.";
			emailMsg = "기업확인 신청이 보완접수되었습니다.";
			
		}else if(resn_s.equals(GlobalConst.RESN_SE_CODE_PS6)) {
			if(resn_r.equals(GlobalConst.RESN_SE_CODE_RC1)) {
				smsContent = rcverNm + "의 기업확인서가 발급되었습니다. 기업정보에서 확인 가능합니다!!";
				emailSbj = sndrNm + " " + "신청하신 기업확인이 발급되었습니다.";
				emailMsg = "기업확인 신청에 대한 신청서가 발급되었습니다.";
				resn = "[유효기간]" + resn;
				templatFile = "TMPL_ISSU_STATUS_PS6_RC1.html";
				
			}else if(resn_r.equals(GlobalConst.RESN_SE_CODE_RC2)) {
				smsContent = rcverNm + "의 기업확인서 신청이 반려되었습니다. 기업정보에서 확인 가능합니다.";
				emailSbj = sndrNm + " " + "신청하신 기업확인이 반려되었습니다.";
				emailMsg = "기업확인 신청이 반려되었습니다.";
				resn = "[반려사유] " + resn;
				
			}else if(resn_r.equals(GlobalConst.RESN_SE_CODE_RC4)) {
				smsContent = rcverNm + "의 기업확인서가 발급취소되었습니다. 기업정보에서 확인 가능합니다.";
				emailMsg = "기업확인서가 발급취소되었습니다.";
				resn = "[발급취소사유] " + resn;
			}else {
				return;
			}
			
		}else {
			return;
		}
		
		// 메일 제목
		if(Validate.isEmpty(emailSbj)) {
			emailSbj = sndrNm + " " + emailMsg;
		}				
		
		smsParam.put("MT_REFKEY", refKeyPreFix + hist_sn);
		smsParam.put("CONTENT", smsContent);
		smsParam.put("CALLBACK", GlobalConst.ISSU_PHONE_NUM);
		smsParam.put("RECIPIENT_NUM", mbtlNum);
		smsParam.put("SERVICE_TYPE", 0);
		
		emailParam.put("PRPOS", "C");
		emailParam.put("EMAIL_SJ", emailSbj);
		emailParam.put("TMPLAT_FILE_COURS", templatFile);
		emailParam.put("TMPLAT_USE_AT", "Y");
		emailParam.put("SNDR_NM", sndrNm);
		emailParam.put("SNDR_EMAIL_ADRES", GlobalConst.MASTER_EMAIL_ADDR);
		emailParam.put("RCVER_NM", rcverNm);
		emailParam.put("RCVER_EMAIL_ADRES", rcverEmail);
		emailParam.put("SNDNG_STTUS", "R");		
		emailParam.put("PARAMTR1", hist_sn);
		
		emailParam.put("SUBST_INFO1", "ENTPRS_NM::" + rcverNm);		// 기업명
		emailParam.put("SUBST_INFO2", "ISSU_YEAR::" + issuYear);	// 확인신청년도
		emailParam.put("SUBST_INFO3", "EAMIL_MSG::" + emailMsg);	// 메세지
		emailParam.put("SUBST_INFO4", "RESN::" + resn);				// 사유, 유효기간
		emailParam.put("SUBST_INFO5", "MASTER_EMAIL_ADDR::" + GlobalConst.QUSTNR_EMAIL_ADDR);	// 답변메일주소
		
		userService.insertSms(smsParam);
		userService.insertEmail(emailParam);
	}
	
	/**
	 * 기관사용자(확인서담당자) 확인서 상태 알림 (SMS, EMAIL)
	 * @param rceptNo
	 * @param hist_sn
	 * @param resn_s
	 * @param resn_r
	 * @throws Exception
	 */
	public void noticeToEmplyrUser(String rceptNo, String hist_sn, String resn_s, String resn_r) throws Exception {
		
		HashMap dataParam = new HashMap();
		HashMap smsParam = new HashMap();
		HashMap emailParam = new HashMap();
		
		// SMS 알림 정보
		String smsContent = "";
		String mbtlNum = GlobalConst.ISSU_MBTL_NUM;
		String refKeyPreFix = "EM";
		
		// EMAIL 알림 정보
		String sndrNm = "[기업정보]";
		String rcverNm = "";
		String rcverEmail = GlobalConst.ISSU_EMAIL_ADDR;
		String emailSbj = "";
		String emailMsg = "";
		String templatFile = "TMPL_ISSU_STATUS.html";
		
		// 접수 등록시 사용자 번호 조회
		dataParam.put("RCEPT_NO", rceptNo);				
		
		// 신청접수 마스터 조회
		Map applyMaster = hpeCnfirmReqstMapper.selectApplyMaster(dataParam);
		dataParam.put("JURIRNO", MapUtils.getString(applyMaster, "JURIRNO"));
		
		// 기업사용자 정보 조회
		EntUserVO entUserVo = userService.findEntUserByJurirno(dataParam);
		
		String issuYear = MapUtils.getString(applyMaster, "CONFM_TARGET_YY");	// 확인신청년도	
		
		if(Validate.isEmpty(entUserVo)) {
			return;
		}
		
		resn_s = resn_s == null ? "" : resn_s;
		resn_r = resn_r == null ? "" : resn_r;
		
		// SMS, EMAIL 메세지, 템플릿 결정
		if(resn_s.equals(GlobalConst.RESN_SE_CODE_PS1)) {
			smsContent = entUserVo.getEntrprsNm() + "의 기업확인서가 접수되었습니다.";
			emailMsg = "기업확인 신청이 접수되었습니다.";
		}else if(resn_s.equals(GlobalConst.RESN_SE_CODE_PS4)) {
			smsContent = entUserVo.getEntrprsNm() + "의 기업확인서 서류가 보완접수 되었습니다.";
			emailMsg = "기업확인 신청이 보완접수되었습니다.";
		}else {
			return;
		}
		
		// 메일 제목
		emailSbj = sndrNm + " " + emailMsg;
		
		smsParam.put("MT_REFKEY", refKeyPreFix + hist_sn);
		smsParam.put("CONTENT", smsContent);
		smsParam.put("CALLBACK", GlobalConst.ISSU_PHONE_NUM);
		smsParam.put("RECIPIENT_NUM", mbtlNum);
		smsParam.put("SERVICE_TYPE", 0);
		
		emailParam.put("PRPOS", "C");
		emailParam.put("EMAIL_SJ", emailSbj);
		emailParam.put("TMPLAT_FILE_COURS", templatFile);
		emailParam.put("TMPLAT_USE_AT", "Y");
		emailParam.put("SNDR_NM", sndrNm);
		emailParam.put("SNDR_EMAIL_ADRES", GlobalConst.MASTER_EMAIL_ADDR);
		emailParam.put("RCVER_NM", rcverNm);
		emailParam.put("RCVER_EMAIL_ADRES", rcverEmail);
		emailParam.put("SNDNG_STTUS", "R");
		emailParam.put("PARAMTR1", hist_sn);
		
		emailParam.put("SUBST_INFO1", "ENTPRS_NM::" + entUserVo.getEntrprsNm());		// 기업명
		emailParam.put("SUBST_INFO2", "ISSU_YEAR::" + issuYear);	// 확인신청년도
		emailParam.put("SUBST_INFO3", "EAMIL_MSG::" + emailMsg);	// 메세지		
		emailParam.put("SUBST_INFO5", "MASTER_EMAIL_ADDR::" + GlobalConst.QUSTNR_EMAIL_ADDR);	// 답변메일주소
		
		userService.insertSms(smsParam);
		userService.insertEmail(emailParam);
	}
	
	public ModelAndView changeSmallGroup(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map valueMap = new HashMap<String, Object>();
		
		valueMap.put("list", hpeCnfirmReqstMapper.selectSmallGroup(rqstMap));
		
		return ResponseUtil.responseJson(mv, Boolean.TRUE, valueMap, "");
	}
}
