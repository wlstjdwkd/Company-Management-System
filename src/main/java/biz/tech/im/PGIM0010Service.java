package biz.tech.im;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.code.CodeService;
import com.comm.code.CodeVO;
import com.comm.issue.CertIssueService;
import com.comm.issue.CertIssueVo;
import com.comm.page.Pager;
import com.comm.response.ExcelVO;
import com.comm.response.IExcelVO;
import com.comm.user.AllUserVO;
import com.comm.user.EntUserVO;
import com.comm.user.UserService;
import com.comm.user.UserVO;
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
import org.springframework.web.servlet.ModelAndView;

import com.comm.mapif.CodeMapper;
import biz.tech.mapif.ic.HpeCnfirmReqstMapper;
import biz.tech.mapif.im.IssueStatusMngMapper;
import biz.tech.mapif.test.TestMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 확인서발급관리
 * 
 * @author JGS
 * 
 */
@Service("PGIM0010")
public class PGIM0010Service extends EgovAbstractServiceImpl {
	private Locale locale = Locale.getDefault();
	
	private static final Logger logger = LoggerFactory.getLogger(PGIM0010Service.class);

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;
	
	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	@Autowired
	IssueStatusMngMapper issueStatusMngMapper;	
	
	@Autowired
	HpeCnfirmReqstMapper hpeCnfirmReqstMapper;	
	
	@Autowired
	CodeService codeService;
	
	@Autowired
	UserService userService;
	
	@Autowired
	CertIssueService certissueService;
	
	@Resource(name="codeMapper")
	private CodeMapper codeDAO;
	
	@Resource(name="testMapper")
	private TestMapper testDAO;
	
	private enum ITEMS{ jurirno, entrprs_nm, issu_no }
	
	/**
	 * 발급업무관리
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/im/BD_UIIMA0010");		
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		Calendar today = Calendar.getInstance();
		String year = String.valueOf(today.get(Calendar.YEAR));
		
		mv.addObject("currentYear", year);
		mv.addObject("df_method_nm", "getData");
		return mv;		
	}
	
	public ModelAndView getData(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/im/BD_UIIMA0010");		
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		/*
			String reqstSe = MapUtils.getString(rqstMap, "ad_reqst_se");
			String seCodeS = MapUtils.getString(rqstMap, "ad_se_code_s");
			String seCodeR = MapUtils.getString(rqstMap, "ad_se_code_r");
			//String jdgmntReqstYear = MapUtils.getString(rqstMap, "ad_jdgmnt_reqst_year");
			String confmTargetYear = MapUtils.getString(rqstMap, "ad_confm_target_yy");
			
			// 특례대상여부
			String excptTrgetAt = MapUtils.getString(rqstMap, "ad_excpt_trget_at");
			
			// 조회항목
			String item = MapUtils.getString(rqstMap, "ad_item");
		*/
		String[] reqstSe = null;
		String[] seCodeS = null;
		String[] seCodeR = null;
		String[] confmTargetYear = null;
		String[] excptTrgetAt = null;
		String[] item = null;

		if(MapUtils.getString(rqstMap, "ad_reqst_se") != null && !MapUtils.getString(rqstMap, "ad_reqst_se").equals("")) {
			reqstSe = MapUtils.getString(rqstMap, "ad_reqst_se").split(",");
		}
		if(MapUtils.getString(rqstMap, "ad_se_code_s") != null && !MapUtils.getString(rqstMap, "ad_se_code_s").equals("")) {
			seCodeS = MapUtils.getString(rqstMap, "ad_se_code_s").split(",");
		}
		if(MapUtils.getString(rqstMap, "ad_se_code_r") != null && MapUtils.getString(rqstMap, "ad_se_code_r").equals("")) {
			// null
		}
		else if(MapUtils.getString(rqstMap, "ad_se_code_r") != null && !MapUtils.getString(rqstMap, "ad_se_code_r").equals("")) {
			seCodeR = MapUtils.getString(rqstMap, "ad_se_code_r").split(",");
		}
		if(MapUtils.getString(rqstMap, "ad_confm_target_yy") != null && !MapUtils.getString(rqstMap, "ad_confm_target_yy").equals("")) {
			confmTargetYear = MapUtils.getString(rqstMap, "ad_confm_target_yy").split(",");
		}
		
		// 특례대상여부
		if(MapUtils.getString(rqstMap, "ad_excpt_trget_at") != null && !MapUtils.getString(rqstMap, "ad_excpt_trget_at").equals("")) {
			excptTrgetAt = MapUtils.getString(rqstMap, "ad_excpt_trget_at").split(",");
		}
		
		// 조회항목
		if(MapUtils.getString(rqstMap, "ad_item") != null && !MapUtils.getString(rqstMap, "ad_item").equals("")) {
			item = MapUtils.getString(rqstMap, "ad_item").split(",");
		}

		String itemValue = null;
		if(MapUtils.getString(rqstMap, "ad_item_value") != null)
			itemValue= MapUtils.getString(rqstMap, "ad_item_value");
		else
			itemValue = "";
		/*String itemValue = null;
		if(item != null && item.contains("jurirno") && MapUtils.getString(rqstMap, "ad_item_value") != null && MapUtils.getString(rqstMap, "ad_item_value") != "")
			itemValue = MapUtils.getString(rqstMap, "ad_item_value").replaceAll("-", ""); //  법인등록번호 '-' 있어도 입력가능하도록 변경
		 */
		// 접수기간
		String rceptDeAll = MapUtils.getString(rqstMap, "ad_rcept_de_all","Y");
		String rceptDeFrom = MapUtils.getString(rqstMap, "ad_rcept_de_from");
		String rceptDeTo = MapUtils.getString(rqstMap, "ad_rcept_de_to");
		
		// 발급기간
		String issuDeAll = MapUtils.getString(rqstMap, "ad_issu_de_all","Y");
		String issuDeFrom = MapUtils.getString(rqstMap, "ad_issu_de_from");
		String issuDeTo = MapUtils.getString(rqstMap, "ad_issu_de_to");
		
		// 보완접수만
		String onlySplemnt = MapUtils.getString(rqstMap, "ad_only_splemnt");		
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("REQST_SE", reqstSe);
		param.put("SE_CODE_S", seCodeS);
		param.put("SE_CODE_R", seCodeR);		
		
		param.put("RCEPT_DE_ALL", rceptDeAll);
		param.put("RCEPT_DE_FROM", rceptDeFrom);
		param.put("RCEPT_DE_TO", rceptDeTo);
		
		param.put("ISSU_DE_ALL", issuDeAll);
		param.put("ISSU_DE_FROM", issuDeFrom);
		param.put("ISSU_DE_TO", issuDeTo);
		
		param.put("ONLY_SPLEMNT", onlySplemnt);		
		
		if(MapUtils.getString(rqstMap, "ad_item") != null && !MapUtils.getString(rqstMap, "ad_item").equals("")) {
			for(int i = 0; i < item.length; i++) {
				if(!item[i].contains("jurirno"))
					param.put(item[i].toUpperCase(), itemValue);
				else
					param.put(item[i].toUpperCase(), itemValue.replaceAll("-", ""));
			}
		}
		/*
		if(Validate.isNotEmpty(item)) {
			ITEMS itemEnum = ITEMS.valueOf(item);
			
			switch(itemEnum) {
			case jurirno:				
				param.put("JURIRNO", itemValue);
				break;
			case entrprs_nm:
				param.put("ENTRPRS_NM", itemValue);
				break;
			case issu_no:
				param.put("ISSU_NO", itemValue);
				break;		
			}
		}	
		*/
		
		
		/*if(Validate.isEmpty(jdgmntReqstYear)) {
			Calendar today = Calendar.getInstance();
			String year = String.valueOf(today.get(Calendar.YEAR));
			param.put("JDGMNT_REQST_YEAR", year);
		}else {
			param.put("JDGMNT_REQST_YEAR", jdgmntReqstYear);
		}*/
		
		/*if(Validate.isEmpty(confmTargetYear)) {
			Calendar today = Calendar.getInstance();
			String year = String.valueOf(today.get(Calendar.YEAR));
			param.put("CONFM_TARGET_YY", year);
		}else {
			param.put("CONFM_TARGET_YY", confmTargetYear);
		}*/
		
		
		Calendar today = Calendar.getInstance();
		String year = String.valueOf(today.get(Calendar.YEAR));
		
		if(Validate.isNull(confmTargetYear)) {			
			// null
		} else {
			param.put("CONFM_TARGET_YY", confmTargetYear);
		}
		
		//param.put("CONFM_TARGET_YY", confmTargetYear);
		
		param.put("EXCPT_TRGET_AT", excptTrgetAt);
		
		mv.addObject("currentYear", year);
		mv.addObject("paramTargetYear", MapUtils.getIntValue(param, "CONFM_TARGET_YY"));
		
		// 총 발급업무관리 글 개수
		int totalRowCnt = issueStatusMngMapper.selectIssueTaskMngTotCnt(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();		
		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		// 발급업무관리 글 조회
		List<Map> issueTaskMng = issueStatusMngMapper.selectIssueTaskMng(param);
		/*
		for(Map map : issueTaskMng) {
			String rceptNo = MapUtils.getString(map, "RCEPT_NO");
			param = new HashMap();
			param.put("RCEPT_NO", rceptNo);
			param.put("RESN_SE", GlobalConst.RESN_SE_S);
			Map resnSMap = issueStatusMngMapper.selectLastestResn(param);
			map.put("HIST_SN_S", resnSMap.get("HIST_SN"));
			map.put("SE_CODE_S", resnSMap.get("SE_CODE"));
			
			param.put("RESN_SE", GlobalConst.RESN_SE_R);
			Map resnRMap = issueStatusMngMapper.selectLastestResn(param);
			if(Validate.isNotEmpty(resnRMap)) {
				map.put("HIST_SN_R", resnSMap.get("HIST_SN"));
				map.put("SE_CODE_R", resnRMap.get("SE_CODE"));				
			}
		}
		*/
		// 데이터 추가		
		mv.addObject("pager", pager);
		mv.addObject("issueTaskMng", issueTaskMng);
		
		return mv;		
	}
	
	/**
	 * 신용평가사수집데이터 조회
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView showCdlTColctData(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/im/PD_UIIMA0012");
		
		String jurirno 	= MapUtils.getString(rqstMap, "ad_jurirno");
		String bizrno 	= MapUtils.getString(rqstMap, "ad_bizrno");
		int baseYr 	= MapUtils.getIntValue(rqstMap, "ad_baseYr");		
		
		String stdyy_end 	= String.valueOf(baseYr);
		String stdyy_start 	= String.valueOf(baseYr-3);
		
		Map param = new HashMap();
		param.put("JURIRNO", jurirno);
		param.put("BIZRNO", bizrno);
		param.put("STDYY_END", stdyy_end);
		param.put("STDYY_START", stdyy_start);
		
		List<Map> entprsFnnrDataList = issueStatusMngMapper.selectEntprsFnnrData(param);
		if(Validate.isNotEmpty(entprsFnnrDataList)) {
			for(Map map : entprsFnnrDataList) {
				// 결산일
				String psacnt 	= MapUtils.getString(map, "PSACNT", "");				
				// 설립일자
				String fondDe	= MapUtils.getString(map, "FOND_DE", "");
				// 대표전화
				String reprsntTlphon = MapUtils.getString(map, "REPRSNT_TLPHON", "");				
				// 법인번호
				String _jurirno = MapUtils.getString(map, "JURIRNO", "");				
				// 사업자번호
				String _bizrno = MapUtils.getString(map, "BIZRNO", "");				
				
				psacnt = psacnt.replaceAll("\\D", "");
				fondDe = fondDe.replaceAll("\\D", "");
				reprsntTlphon = reprsntTlphon.replaceAll("\\D", "");
				_jurirno = _jurirno.replaceAll("\\D", "");
				_bizrno = _bizrno.replaceAll("\\D", "");
				
				map.put("PSACNT", psacnt);
				map.put("FOND_DE", fondDe);
				map.put("REPRSNT_TLPHON", reprsntTlphon);
				
				if(psacnt.length()>=4) {
					map.put("PSACNT_MT", psacnt.substring(0, 2));
					map.put("PSACNT_DY", psacnt.substring(2));
				}
				
				Map fondDeMap = StringUtil.toDateFormat(fondDe);
				map.put("FOND_DE_YR", fondDeMap.get("first"));
				map.put("FOND_DE_MT", fondDeMap.get("middle"));
				map.put("FOND_DE_DY", fondDeMap.get("last"));
				
				Map reprsntTlphonMap = StringUtil.telNumFormat(reprsntTlphon);
				map.put("REPRSNT_TLPHON_FIRST", reprsntTlphonMap.get("first"));
				map.put("REPRSNT_TLPHON_MIDDLE", reprsntTlphonMap.get("middle"));
				map.put("REPRSNT_TLPHON_LAST", reprsntTlphonMap.get("last"));
				
				Map jurirnoMap = StringUtil.toJurirnoFormat(_jurirno);
				map.put("JURIRNO_FIRST", jurirnoMap.get("first"));				
				map.put("JURIRNO_LAST", jurirnoMap.get("last"));
				
				Map bizrnoMap = StringUtil.toBizrnoFormat(_bizrno);
				map.put("BIZRNO_FIRST", bizrnoMap.get("first"));
				map.put("BIZRNO_MIDDLE", bizrnoMap.get("middle"));
				map.put("BIZRNO_LAST", bizrnoMap.get("last"));
				
			}
		}
		
		logger.debug("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% entprsFnnrDataList: "+entprsFnnrDataList);
		
		mv.addObject("entprsFnnrDataList", entprsFnnrDataList);
		
		return mv;		
	}
	
	
	/**
	 * 알림이력 조회
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView showNotiHist(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/im/PD_UIIMA0015");
		String rceptNo = MapUtils.getString(rqstMap, "ad_rcept_no");
		
		Map param = new HashMap();
		param.put("RCEPT_NO", rceptNo);
		
		List<Map> notiHistList = hpeCnfirmReqstMapper.selectResnManage(param);
		
		if(Validate.isNotEmpty(notiHistList)) {
			for(Map map : notiHistList) {
				String emplyrTy = MapUtils.getString(map, "EMPLYR_TY");				
				String userNo = MapUtils.getString(map, "USER_NO");
				Map iParam = new HashMap();
				iParam.put("USER_NO", userNo);
				// 일반
				if(GlobalConst.EMPLYR_TY_GN.equals(emplyrTy)) {
					AllUserVO allUserVo = userService.findGnrUser(iParam);
					if(Validate.isNotEmpty(allUserVo)) {
						String userNm = allUserVo.getUserNm(); 
						map.put("USER_NM", userNm);
					}
				// 기업	
				}else if(GlobalConst.EMPLYR_TY_EP.equals(emplyrTy)) {
					EntUserVO entUserVO = userService.findEntUser(iParam);
					if(Validate.isNotEmpty(entUserVO)) {
						String userNm = entUserVO.getChargerNm();
						map.put("USER_NM", userNm);
					}
				// 업무	
				}else if(GlobalConst.EMPLYR_TY_JB.equals(emplyrTy)) {
					AllUserVO allUserVo = userService.findEmpUser(iParam);
					if(Validate.isNotEmpty(allUserVo)) {
						String userNm = allUserVo.getUserNm();
						map.put("USER_NM", userNm);
					}
				}
			}
			
		}
		mv.addObject("notiHistList", notiHistList);
		
		return mv;		
	}
	
	/**
	 * 신청담당자정보 조회
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView showChargerInfo(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/im/PD_UIIMA0013");
		String jurirno = MapUtils.getString(rqstMap, "ad_jurirno");
		
		Map param = new HashMap();
		param.put("JURIRNO", jurirno);
		
		Map chargerInfo = issueStatusMngMapper.selectChargerInfo(param);
		
		
		// 전화, 팩스, 휴대전화 '-' 표시
		Map numMap = new HashMap();
		String num = null;
		
		for(int i=0; i<chargerInfo.size(); i++) {
			if(Validate.isNull(chargerInfo.get("TELNO"))) {
				num="";
			}
			else {
				numMap = StringUtil.telNumFormat((String) chargerInfo.get("TELNO"));
				if(Validate.isNotEmpty(numMap.get("middle"))) {
				num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last");
				}
				chargerInfo.put("TELNO", num);
			}
			
			if(Validate.isNull(chargerInfo.get("TELNO2"))) {
				num="";
			}
			else {
				num = "";		/* 앞에서 들어간 값이 간섭하지 않도록 초기화 */
				
				numMap = StringUtil.telNumFormat((String) chargerInfo.get("TELNO2"));
				if(Validate.isNotEmpty(numMap.get("middle"))) {
				num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last");
				}
				chargerInfo.put("TELNO2", num);
			}
			
			if(Validate.isNull(chargerInfo.get("FXNUM"))) {
				num="";
			}
			else {
				numMap = StringUtil.telNumFormat((String) chargerInfo.get("FXNUM"));
				if(Validate.isNotEmpty(numMap.get("middle"))) {
					num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last");
				}
				chargerInfo.put("FXNUM", num);
			}
			
			if(Validate.isNull(chargerInfo.get("MBTLNUM"))) {
				num="";
			}
			else {
				numMap = StringUtil.telNumFormat((String) chargerInfo.get("MBTLNUM"));
				if(Validate.isNotEmpty(numMap.get("middle"))) {
					num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last");
				}
				chargerInfo.put("MBTLNUM", num);
			}
		}
		
		mv.addObject("chargerInfo", chargerInfo);
		
		return mv;		
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
	 * 보완요청 조회 윈도우팝업용
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView showSupplementWinpop(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/im/PD_UIIMA0019");
		String rceptNo = MapUtils.getString(rqstMap, "ad_rcept_no");
		
		Map param = new HashMap();
		param.put("RCEPT_NO", rceptNo);
		param.put("RESN_SE", GlobalConst.RESN_SE_S);
		Map resnRMap = issueStatusMngMapper.selectLastestResn(param);
		
		// ------------------ 검색 시 기업명을 가져오기 위한 부분 시작 ------------------ 
		String supplementYn = MapUtils.getString(rqstMap, "supplementYn");
		String reqstNm = MapUtils.getString(rqstMap, "reqstNm");		//신청구분 (발급신청, 재발급신청)
		
		param.put("supplementYn", supplementYn);
		
		if("AK1".equals(reqstNm)) {
			param.put("reqstChk", 1);
		}else {
			param.put("reqstChk", 2);
		}
		
		Map resnRMap2 = issueStatusMngMapper.selectEntrprsNm(param);
		
		String entrprsNm="";
		if("AK1".equals(reqstNm)) {
			entrprsNm = MapUtils.getString(resnRMap2, "ENTRPRS_NM","");
		}else {
			entrprsNm = MapUtils.getString(resnRMap2, "ENTRPS_NM","");
		}
		
		logger.debug("######################### entrprsNm: "+entrprsNm);
		
		mv.addObject("ENTRPRS_NM", entrprsNm);
		
		// ------------------ 검색 시 기업명을 가져오기 위한 부분 끝 ------------------ 
		
		if(Validate.isNotEmpty(resnRMap)) {
			String seCode = MapUtils.getString(resnRMap, "SE_CODE","");
			// 보완요청
			if(seCode.equals(GlobalConst.RESN_SE_CODE_PS3) || seCode.equals(GlobalConst.RESN_SE_CODE_PS4) ) {
				mv.addObject("supplement", resnRMap);
			}
			logger.debug("######################### resnRMap: "+resnRMap);
		}
		return mv;		
	}
	
	/**
	 * 보완요청 수정
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView updateSupplement(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		String rceptNo = MapUtils.getString(rqstMap, "ad_rcept_no");
		String resn = MapUtils.getString(rqstMap, "ad_resn");
		Map param = new HashMap();
		param.put("RCEPT_NO", rceptNo);
		
		
		// 상태이력관리 등록:진행상태-보완요청		
		UserVO userVo = SessionUtil.getUserInfo();
		if(Validate.isEmpty(userVo)) {
			throw processException("fail.common.session");
		}		
		String userNo = userVo.getUserNo();		
		param = new HashMap();
		param.put("RCEPT_NO", rceptNo);
		param.put("RESN_SE", GlobalConst.RESN_SE_S);
		param.put("SE_CODE", GlobalConst.RESN_SE_CODE_PS3);
		param.put("RESN", resn);
		param.put("USER_NO", userNo);		
		hpeCnfirmReqstMapper.insertResnManage(param);
		
		// 알림전송
		noticeToEntrprsUser(rceptNo, MapUtils.getString(param, "HIST_SN", ""), resn,
				GlobalConst.RESN_SE_CODE_PS3, null);
				
		return ResponseUtil.responseText(mv,Boolean.TRUE);
				
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
	 * 신청접수특이사항 조회
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView showPartclrMatter(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/im/PD_UIIMA0014");
		String rceptNo = MapUtils.getString(rqstMap, "ad_rcept_no");
		
		Map param = new HashMap();
		param.put("RCEPT_NO", rceptNo);
		
		Map partclrMatter = issueStatusMngMapper.selectPartclrMatter(param);
		
		mv.addObject("partclrMatter", partclrMatter);
		
		return mv;		
	}
	
	/**
	 * 신청접수특이사항 수정
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView updatePartclrMatter(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		String rceptNo = MapUtils.getString(rqstMap, "ad_rcept_no");
		String partclrMatter = MapUtils.getString(rqstMap, "ad_partclr_matter");
		
		Map param = new HashMap();
		param.put("RCEPT_NO", rceptNo);
		param.put("PARTCLR_MATTER", partclrMatter);
		
		int result = issueStatusMngMapper.updatePartclrMatter(param);
		
		if(result<=0) {
			return ResponseUtil.responseText(mv,Boolean.FALSE);
		}
		
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
	 * 발급취소 수정
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView updateCancelIssue(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		String rceptNo = MapUtils.getString(rqstMap, "ad_rcept_no");
		String resn = MapUtils.getString(rqstMap, "ad_resn");
		Map param = new HashMap();
		param.put("RCEPT_NO", rceptNo);
				
		// 상태이력관리 등록:진행상태-보완요청		
		UserVO userVo = SessionUtil.getUserInfo();
		if(Validate.isEmpty(userVo)) {
			throw processException("fail.common.session");
		}		
		String userNo = userVo.getUserNo();		
		param = new HashMap();
		param.put("RCEPT_NO", rceptNo);
		param.put("RESN_SE", GlobalConst.RESN_SE_R);
		param.put("SE_CODE", GlobalConst.RESN_SE_CODE_RC4);
		param.put("RESN", resn);
		param.put("USER_NO", userNo);		
		hpeCnfirmReqstMapper.insertResnManage(param);
		
		param.put("codeGroupNo", 17);
		param.put("code", resn);
		
		Map codeInfo = codeService.findCodeInfo(param);
		if(Validate.isNotEmpty(codeInfo)) {
			resn = MapUtils.getString(codeInfo, "codeNm", "");
		}
		
		// 알림전송
		noticeToEntrprsUser(rceptNo, MapUtils.getString(param, "HIST_SN", ""), resn,
				GlobalConst.RESN_SE_CODE_PS6, GlobalConst.RESN_SE_CODE_RC4);
				
		return ResponseUtil.responseText(mv,Boolean.TRUE);
				
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
					judgment.put("RC1_FLAG", "N");
				}
				if(seCode.equals(GlobalConst.RESN_SE_CODE_RC1)) {
					judgment.put("RC1_FLAG", "Y");
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
				judgment.put("RC1_FLAG", "N");
			}
			if(seCode.equals(GlobalConst.RESN_SE_CODE_RC1)) {
				judgment.put("RC1_FLAG", "Y");
			}
		}
		
		mv.addObject("judgment", judgment);
		
		return mv;		
	}
	
	/**
	 * 판정 등록
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView updateJudgment(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		String rceptNo = MapUtils.getString(rqstMap, "ad_rcept_no");
		logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& rceptNo: "+rceptNo);
		String validPdBeginDe = MapUtils.getString(rqstMap, "ad_valid_pd_begin_de");
		if(Validate.isNotEmpty(validPdBeginDe)) {
			validPdBeginDe = validPdBeginDe.replaceAll("-", "");
		}
		String validPdEndDe = MapUtils.getString(rqstMap, "ad_valid_pd_end_de");
		if(Validate.isNotEmpty(validPdEndDe)) {
			validPdEndDe = validPdEndDe.replaceAll("-", "");
		}
		String jdgmntCode = MapUtils.getString(rqstMap, "ad_jdgmnt_code");
		
		String confmSe = MapUtils.getString(rqstMap, "ad_confm_se");
		
		String seCode = MapUtils.getString(rqstMap, "ad_se_code","");
		String resn = MapUtils.getString(rqstMap, "ad_resn","");
		
		if(seCode.equals(GlobalConst.RESN_SE_CODE_RC1)) {
			Map param = new HashMap();
			param.put("RCEPT_NO", rceptNo);
			
			// 발급 신청건 조회 - 완료 -> 검토중 상태 변경가능에 따른 주석처리
			/*
			Map applyData = hpeCnfirmReqstMapper.selectIssuDplctReqst(param);
			if(Validate.isNotEmpty(applyData)) {
				throw processException("fail.common.session");
			}
			*/
			
			Map applyMaster = hpeCnfirmReqstMapper.selectApplyMaster(param);
			if(Validate.isNotEmpty(applyMaster)) {
				String upperRceptNo = MapUtils.getString(applyMaster, "UPPER_RCEPT_NO","");
				// 재발급
				if(Validate.isNotEmpty(upperRceptNo.trim())) {
					Map parantParam = new HashMap();
					parantParam.put("RCEPT_NO", upperRceptNo);
					parantParam.put("ISGN_AT", "Y");
					hpeCnfirmReqstMapper.updateIsgnAt(parantParam);
				// 신규발급
				}else {
					// 발급일련번호 생성
					Map snMap = createIssuNo();
					// 발급일련번호
					int issuSn = MapUtils.getIntValue(snMap, "issuSn");
					updateIssuSn(issuSn);
					// 발급번호
					String issuNo = MapUtils.getString(snMap, "issuNo");
					
					param.put("JDGMNT_CODE", jdgmntCode);
					param.put("VALID_PD_BEGIN_DE", validPdBeginDe);
					param.put("VALID_PD_END_DE", validPdEndDe);
					param.put("ISSU_NO", issuNo);
					param.put("CONFM_SE", confmSe);
					issueStatusMngMapper.updateJudgment(param);
					logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& : after updateJudgment");
				}
			}
			
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
			
			// 상태이력관리 등록:진행결과-발급
			param = new HashMap();
			param.put("RCEPT_NO", rceptNo);
			param.put("RESN_SE", GlobalConst.RESN_SE_R);
			param.put("SE_CODE", GlobalConst.RESN_SE_CODE_RC1);
			param.put("USER_NO", userNo);
			hpeCnfirmReqstMapper.insertResnManage(param);
			
			String validDe = validPdBeginDe + " ~ " + validPdEndDe;
			// 알림전송
			noticeToEntrprsUser(rceptNo, MapUtils.getString(param, "HIST_SN", ""), validDe,
					GlobalConst.RESN_SE_CODE_PS6, GlobalConst.RESN_SE_CODE_RC1);
			
		}else if(seCode.equals(GlobalConst.RESN_SE_CODE_RC2)){
			Map param = new HashMap();
			
			// 판정코드 등록
			param.put("RCEPT_NO", rceptNo);
			param.put("JDGMNT_CODE", jdgmntCode);							
			issueStatusMngMapper.updateJudgment(param);
			
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
			param.put("SE_CODE", GlobalConst.RESN_SE_CODE_RC2);
			param.put("RESN", resn);			
			param.put("USER_NO", userNo);
			hpeCnfirmReqstMapper.insertResnManage(param);
			
			// 알림전송
			noticeToEntrprsUser(rceptNo, MapUtils.getString(param, "HIST_SN", ""), resn,
					GlobalConst.RESN_SE_CODE_PS6, GlobalConst.RESN_SE_CODE_RC2);
		}
		return ResponseUtil.responseText(mv,Boolean.TRUE);
	}
	
	/**
	 * 판정 유효기간 및 확인서구분 수정
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView updateJudgmentForRC1(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		String rceptNo = MapUtils.getString(rqstMap, "ad_rcept_no");
		logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& rceptNo: "+rceptNo);
		String validPdBeginDe = MapUtils.getString(rqstMap, "ad_valid_pd_begin_de");
		if(Validate.isNotEmpty(validPdBeginDe)) {
			validPdBeginDe = validPdBeginDe.replaceAll("-", "");
		}
		String validPdEndDe = MapUtils.getString(rqstMap, "ad_valid_pd_end_de");
		if(Validate.isNotEmpty(validPdEndDe)) {
			validPdEndDe = validPdEndDe.replaceAll("-", "");
		}
		
		String confmSe = MapUtils.getString(rqstMap, "ad_confm_se");

		Map param = new HashMap();
		param.put("RCEPT_NO", rceptNo);
		param.put("VALID_PD_BEGIN_DE", validPdBeginDe);
		param.put("VALID_PD_END_DE", validPdEndDe);
		param.put("CONFM_SE", confmSe);
		issueStatusMngMapper.updateJudgmentForRC1(param);
		logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& : after updateJudgmentForRC1");
		
		// 상태이력관리 등록:진행상태-완료		
		UserVO userVo = SessionUtil.getUserInfo();
		if(Validate.isEmpty(userVo)) {
			throw processException("fail.common.session");
		}
			
		return ResponseUtil.responseText(mv,Boolean.TRUE);
	}
	
	/**
	 * 판정 등록
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView updateJudgmentResn(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		String chks = MapUtils.getString(rqstMap, "ad_jdgmnt_code");
		String[] chksArr = chks.split(",");
		String rceptNo = MapUtils.getString(rqstMap, "ad_check_rcept_code");
		String[] rceptNoArr = rceptNo.split(",");

		String validPdBeginDe = MapUtils.getString(rqstMap, "ad_valid_pd_begin_de");
		if(Validate.isNotEmpty(validPdBeginDe)) {
			validPdBeginDe = validPdBeginDe.replaceAll("-", "");
		}
		String validPdEndDe = MapUtils.getString(rqstMap, "ad_valid_pd_end_de");
		if(Validate.isNotEmpty(validPdEndDe)) {
			validPdEndDe = validPdEndDe.replaceAll("-", "");
		}
		String jdgmntCode = MapUtils.getString(rqstMap, "ad_jdgmnt_code");
		logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& jdgmntCode: "+jdgmntCode);
		
		String confmSe = MapUtils.getString(rqstMap, "ad_confm_se");
		
		String seCode = MapUtils.getString(rqstMap, "ad_se_code","");
		String resn = MapUtils.getString(rqstMap, "ad_resn","");
		
		logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& ad_se_code: "+seCode);
		
		Map param = new HashMap();
		
		for(int i = 0; i < chksArr.length; i++) {
			if(i == 0) {
				continue;
			}
			param.put("RCEPT_NO", rceptNoArr[i]);
			
			param.put("JDGMNT_CODE", chksArr[i]);
			param.put("VALID_PD_BEGIN_DE", validPdBeginDe);
			param.put("VALID_PD_END_DE", validPdEndDe);
			param.put("CONFM_SE", confmSe);
			issueStatusMngMapper.updateJudgment(param);
		}
		
		logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& : after updateJudgment");
		
		return ResponseUtil.responseText(mv,Boolean.TRUE);
	}
	
	/**
	 * 발급일련번호 생성
	 * 
	 * @return ModelAndView
	 * @throws Exception
	 */
	public Map createIssuNo() throws Exception {
		
		Calendar cal = Calendar.getInstance( ); 
		String curYear = String.valueOf(cal.get(Calendar.YEAR));
		
		Map<String, Object> param = new HashMap<String, Object>();	
		param.put("YEAR", curYear);		
				
		Map result = hpeCnfirmReqstMapper.selectSnMng(param);
		if(result.isEmpty()) {
			throw processException("fail.common.custom",new String[] {"접수번호 생성 오류"});
		}
		
		int issuSn = MapUtils.getInteger(result, "ISSU_SN");
		int nextIssuSn = issuSn+1;
		String issuNo = curYear+"-"+StringUtil.leftPad(String.valueOf(nextIssuSn), 4, "0");
		Map out = new HashMap();
		out.put("issuSn", nextIssuSn);
		out.put("issuNo", issuNo);
		
		return out;
	}
	
	/**
	 * 발급일련번호 수정
	 * 
	 * @return ModelAndView
	 * @throws Exception
	 */
	public void updateIssuSn(int issuSn) throws Exception {
		
		Calendar cal = Calendar.getInstance( ); 
		String curYear = String.valueOf(cal.get(Calendar.YEAR));
		
		Map<String, Object> param = new HashMap<String, Object>();	
		param.put("YEAR", curYear);
		param.put("ISSU_SN", issuSn);		
				
		issueStatusMngMapper.updateIssuSn(param);		
	}
	
	/**
	 * 특례대상여부 수정
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView updateExcptProcess(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();

		if(rqstMap.get("chk") instanceof String) {
			String rceptNo = MapUtils.getString(rqstMap, "chk");
			String[] excptFlag = rqstMap.get("ad_excpt_trget_at_rslt").toString().substring(1).split(",");
			updateExcpt(rceptNo, excptFlag[0]);
		}else {
			System.out.println(rqstMap.get("excpt_trget_at_rslt").toString().substring(1).split(",").length);
			String[] chks = (String[]) rqstMap.get("chk");	
			String[] rslts = rqstMap.get("ad_excpt_trget_at_rslt").toString().substring(1).split(",");	
			for(int i=0;i<chks.length;i++) {
				String rceptNo = chks[i];
				String excptFlag = rslts[i];
				updateExcpt(rceptNo, excptFlag);
			}			
		}
		
		return ResponseUtil.responseText(mv,Boolean.TRUE);
	}
	
	private void updateExcpt(String rceptNo, String excptFlag) throws Exception {
		if(excptFlag != null && excptFlag != "") {
			Map param = new HashMap();
			param.put("RCEPT_NO", rceptNo);
			param.put("EXCPT_FLAG", excptFlag);
			
			issueStatusMngMapper.updateExcpt(param);
		}
	}
	
	
	/**
	 * 진행단계 변경
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView updateProcessStep(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		if(rqstMap.get("chk") instanceof String) {
			String rceptNo = MapUtils.getString(rqstMap, "chk");			
			insertResnManage(rceptNo, rqstMap);
		}else {
			String[] chks = (String[]) rqstMap.get("chk");			
			for(int i=0;i<chks.length;i++) {
				String rceptNo = chks[i];				
				insertResnManage(rceptNo, rqstMap);
			}			
		}
		
		return ResponseUtil.responseText(mv,Boolean.TRUE);		
	}
	
	private void insertResnManage(String rceptNo, Map<?, ?> rqstMap) throws Exception {
		
		String resnSe = GlobalConst.RESN_SE_S;
		String seCode = MapUtils.getString(rqstMap, "ad_se_code_s_"+rceptNo);
		
		UserVO userVo = SessionUtil.getUserInfo();
		if(Validate.isEmpty(userVo)) {
			throw processException("fail.common.session");
		}
		
		String userNo = userVo.getUserNo();
		
		Map param = new HashMap();
		param.put("RCEPT_NO", rceptNo);
		param.put("RESN_SE", resnSe);
		param.put("SE_CODE", seCode);
		param.put("USER_NO", userNo);
		
		hpeCnfirmReqstMapper.insertResnManage(param);
		
		// 보완요청의 경우 상태변경 후 발송하지 않고 사유까지 입력한 후 알림발송함.
		if(!seCode.equals(GlobalConst.RESN_SE_CODE_PS3)) {
			//알림전송
			noticeToEntrprsUser(rceptNo, MapUtils.getString(param, "HIST_SN", ""), null, seCode, null);
		}
	}
	
	/**
	 * 진행단계 변경
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getJudgCd(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		String grpCd = MapUtils.getString(rqstMap, "ad_grp_cd");	
		
		logger.debug("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% grpCd: "+grpCd);
		
		
		List<CodeVO> codeList = codeService.findCodesByGroupNo(grpCd);
		
		Map map = new HashMap();		
		if(Validate.isNotEmpty(codeList)) {			
			for(CodeVO codeVo : codeList) {
				String code = codeVo.getCode();
				String codeNM = codeVo.getCodeNm();
				map.put(code, codeNM);
			}			
		}
		
		logger.debug("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% map: "+map.toString());
		//String json = JsonUtil.toJson(map);
		mv.addObject("notiHistList", codeList);
		
		//return ResponseUtil.responseText(mv, map);
		return ResponseUtil.responseJson(mv, Boolean.TRUE, codeList);
	}
	
	
	/**
	 * 엑셀 다운로드
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView excelRsolver(Map<?, ?> rqstMap) throws Exception {	

		ModelAndView mv = new ModelAndView();
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		/*
			String reqstSe = MapUtils.getString(rqstMap, "ad_reqst_se");
			String seCodeS = MapUtils.getString(rqstMap, "ad_se_code_s");
			String seCodeR = MapUtils.getString(rqstMap, "ad_se_code_r");
			//String jdgmntReqstYear = MapUtils.getString(rqstMap, "ad_jdgmnt_reqst_year");
			String confmTargetYear = MapUtils.getString(rqstMap, "ad_confm_target_yy");
			
			// 특례대상여부
			String excptTrgetAt = MapUtils.getString(rqstMap, "ad_excpt_trget_at");
			
			// 조회항목
			String item = MapUtils.getString(rqstMap, "ad_item");
		*/
		String[] reqstSe = null;
		String[] seCodeS = null;
		String[] seCodeR = null;
		String[] confmTargetYear = null;
		String[] excptTrgetAt = null;
		String[] item = null;

		if(MapUtils.getString(rqstMap, "ad_reqst_se") != null && !MapUtils.getString(rqstMap, "ad_reqst_se").equals("")) {
			reqstSe = MapUtils.getString(rqstMap, "ad_reqst_se").split(",");
		}
		if(MapUtils.getString(rqstMap, "ad_se_code_s") != null && !MapUtils.getString(rqstMap, "ad_se_code_s").equals("")) {
			seCodeS = MapUtils.getString(rqstMap, "ad_se_code_s").split(",");
		}
		if(MapUtils.getString(rqstMap, "ad_se_code_r") != null && !MapUtils.getString(rqstMap, "ad_se_code_r").equals("")) {
			seCodeR = MapUtils.getString(rqstMap, "ad_se_code_r").split(",");
		}
		if(MapUtils.getString(rqstMap, "ad_confm_target_yy") != null && !MapUtils.getString(rqstMap, "ad_confm_target_yy").equals("")) {
			confmTargetYear = MapUtils.getString(rqstMap, "ad_confm_target_yy").split(",");
		}
		
		// 특례대상여부
		if(MapUtils.getString(rqstMap, "ad_excpt_trget_at") != null && !MapUtils.getString(rqstMap, "ad_excpt_trget_at").equals("")) {
			excptTrgetAt = MapUtils.getString(rqstMap, "ad_excpt_trget_at").split(",");
		}
		
		// 조회항목
		if(MapUtils.getString(rqstMap, "ad_item") != null && !MapUtils.getString(rqstMap, "ad_item").equals("")) {
			item = MapUtils.getString(rqstMap, "ad_item").split(",");
		}

		String itemValue = null;
		if(MapUtils.getString(rqstMap, "ad_item_value") != null)
			itemValue= MapUtils.getString(rqstMap, "ad_item_value");
		else
			itemValue = "";
		/*String itemValue = null;
		if(item != null && item.contains("jurirno") && MapUtils.getString(rqstMap, "ad_item_value") != null && MapUtils.getString(rqstMap, "ad_item_value") != "")
			itemValue = MapUtils.getString(rqstMap, "ad_item_value").replaceAll("-", ""); //  법인등록번호 '-' 있어도 입력가능하도록 변경
		 */
		// 접수기간
		String rceptDeAll = MapUtils.getString(rqstMap, "ad_rcept_de_all","Y");
		String rceptDeFrom = MapUtils.getString(rqstMap, "ad_rcept_de_from");
		String rceptDeTo = MapUtils.getString(rqstMap, "ad_rcept_de_to");
		
		// 발급기간
		String issuDeAll = MapUtils.getString(rqstMap, "ad_issu_de_all","Y");
		String issuDeFrom = MapUtils.getString(rqstMap, "ad_issu_de_from");
		String issuDeTo = MapUtils.getString(rqstMap, "ad_issu_de_to");
		
		// 보완접수만
		String onlySplemnt = MapUtils.getString(rqstMap, "ad_only_splemnt");		
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("REQST_SE", reqstSe);
		param.put("SE_CODE_S", seCodeS);
		param.put("SE_CODE_R", seCodeR);		
		
		param.put("RCEPT_DE_ALL", rceptDeAll);
		param.put("RCEPT_DE_FROM", rceptDeFrom);
		param.put("RCEPT_DE_TO", rceptDeTo);
		
		param.put("ISSU_DE_ALL", issuDeAll);
		param.put("ISSU_DE_FROM", issuDeFrom);
		param.put("ISSU_DE_TO", issuDeTo);
		
		param.put("ONLY_SPLEMNT", onlySplemnt);		
		
		if(MapUtils.getString(rqstMap, "ad_item") != null && !MapUtils.getString(rqstMap, "ad_item").equals("")) {
			for(int i = 0; i < item.length; i++) {
				if(!item[i].contains("jurirno"))
					param.put(item[i].toUpperCase(), itemValue);
				else
					param.put(item[i].toUpperCase(), itemValue.replaceAll("-", ""));
			}
		}
		/*
		if(Validate.isNotEmpty(item)) {
			ITEMS itemEnum = ITEMS.valueOf(item);
			
			switch(itemEnum) {
			case jurirno:				
				param.put("JURIRNO", itemValue);
				break;
			case entrprs_nm:
				param.put("ENTRPRS_NM", itemValue);
				break;
			case issu_no:
				param.put("ISSU_NO", itemValue);
				break;		
			}
		}	
		*/
		
		
		/*if(Validate.isEmpty(jdgmntReqstYear)) {
			Calendar today = Calendar.getInstance();
			String year = String.valueOf(today.get(Calendar.YEAR));
			param.put("JDGMNT_REQST_YEAR", year);
		}else {
			param.put("JDGMNT_REQST_YEAR", jdgmntReqstYear);
		}*/
		
		/*if(Validate.isEmpty(confmTargetYear)) {
			Calendar today = Calendar.getInstance();
			String year = String.valueOf(today.get(Calendar.YEAR));
			param.put("CONFM_TARGET_YY", year);
		}else {
			param.put("CONFM_TARGET_YY", confmTargetYear);
		}*/
		
		
		Calendar today = Calendar.getInstance();
		String year = String.valueOf(today.get(Calendar.YEAR));
		
		if(Validate.isNull(confmTargetYear)) {			
			// null
		} else {
			param.put("CONFM_TARGET_YY", confmTargetYear);
		}
		
		//param.put("CONFM_TARGET_YY", confmTargetYear);
		
		param.put("EXCPT_TRGET_AT", excptTrgetAt);
		
		mv.addObject("currentYear", year);
		mv.addObject("paramTargetYear", MapUtils.getIntValue(param, "CONFM_TARGET_YY"));
		
		// 총 발급업무관리 글 개수
		int totalRowCnt = issueStatusMngMapper.selectIssueTaskMngTotCnt(param);

		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(1).totalRowCount(totalRowCnt).rowSize(totalRowCnt).build();
		pager.makePaging();		
		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		param.put("isExcel", "Y");
		
		// 발급업무관리 글 조회
		List<Map> issueTaskMng = issueStatusMngMapper.selectIssueTaskMngExcel(param);
		mv.addObject("_list", issueTaskMng);

		for (Map iMap : issueTaskMng) {
			String temp = (String) iMap.get("PRPOS");
			temp = temp.replace("USE01", "인력·교육");
			temp = temp.replace("USE02", "기술·R&D");
			temp = temp.replace("USE03", "수출·무역");
			temp = temp.replace("USE04", "경영·동반성장");
			
			iMap.put("PRPOS", temp);
		}
		
        /*String[] headers = {
            "신청구분",
            "대상연도",
            "특례대상여부",
            "접수번호",
            "접수일자",
            "진행단계",
            "처리결과",
            "발급번호",
            "기업명",
            "담당자명",
            "전화번호",
            "이메일",
            "법인등록번호",
            "업종코드"
        };*/

		/*String[] headers = {
                "신청구분",
                "대상연도",
                "특례대상여부",
                "접수번호",
                "접수일자",
                "진행단계",
                "처리결과",
                "발급번호",
                "기업명",
                "담당자명",
                "전화번호",
                "이메일",
                "법인등록번호",
                "업종코드",
                "용도",
                "제출처",
                "판정신청년도",
            	"상위접수번호",
            	"신청구분",
            	"갱신여부",
            	"특이사항",
            	"재발급여부", 
            	"발급일자",
            	"판정코드", 
            	"판정코드명",
            	"유효기간시작일자",
            	"유효기간종료일자",
            	"확인서 구분",
            	"진행상태 사유구분",
            	"진행상태 구분코드",
            	"진행결과 사유구분", 
            	"진행결과 구분코드",
            	"생성일자",
            	"유효기간여부",
            	"진행결과 사유",
            	"진행결과 처리자명",
            	"담당자 부서",
            	"직위"
        };*/

		String[] headers = {
                "대상연도",
                "발급번호",
                "발급일자",
                "발급사유",
                "법인등록번호",
                "기업명",
                "국가구분",
                "관계기업명",
                "신청기업본사주소",
                "업종코드",
                "담당자명",
                "담당자부서",
                "직위",
                "전화번호",
                "이메일",
                "특이사항",
                "용도(사업명)",
                "제출처",
                "유효기간시작일자",
                "유효기간종료일자",
                "신청구분",
                "접수번호",
                "접수일자",
                "진행단계",
                "처리결과",
                "통화코드",
                "관계기업구분",
                "특례여부"
        };
		
		String[] items = {
        	"CONFM_TARGET_YY", /* 대상연도 */
        	"ISSU_NO", /* 발급번호 */ 
        	"ISSU_DE", /* 발급일자 */
        	"JDGMNT_CODE_NM", /* 발급사유 */
        	"JURIRNO", /* 법인등록번호 */
        	"ENTRPRS_NM", /* 기업명 */
        	"CPR_REGIST_SE", /* 국가구분 */ 
        	"ENT_NM", /* 관계기업명 */
        	"HEDOFC_ADRES", /* 신청기업본사주소 */ 
        	"LCLAS_CD", /* 업종코드 */
        	"CHARGER_NM", /* 담당자명 */
        	"CHARGER_DEPT", /* 담당자부서 */
        	"OFCPS", /* 직위 */
        	"TELNO", /* 전화번호 */
        	"EMAIL", /* 이메일 */
        	"PARTCLR_MATTER",  /* 특이사항 */
        	"PRPOS",  /* 용도(사업명) */
        	"RECEPDSK",  /* 제출처 */
        	"VALID_PD_BEGIN_DE", /* 유효기간시작일자 */
        	"VALID_PD_END_DE", /* 유효기간종료일자 */
        	"REQST_SE_NM", /* 신청구분 */
        	"RCEPT_NO", /* 접수번호 */ 
        	"RCEPT_DE", /* 접수일자 */
        	"SE_CODE_NM_S", /* 진행단계 */ 
        	"SE_CODE_NM_R", /* 처리결과 */
        	"CRNCY_CODE", /* 통화코드 */
        	"RCPY_DIV" , /* 관계기업구분 */
        	"EXCPT_TRGET_AT" /* 특례여부 */
        };
	
        /*String[] items = {
        	"REQST_SE_NM",  신청구분명 
        	"CONFM_TARGET_YY",  확인서대상년도  
        	"EXCPT_TRGET_AT",  특례대상여부 
        	"RCEPT_NO",  접수번호 
        	"RCEPT_DE",  접수일자 
        	"SE_CODE_NM_S",  진행상태 구분코드명 
        	"SE_CODE_NM_R",  진행결과 구분코드명  
        	"ISSU_NO",  발급번호 
        	"ENTRPRS_NM",  기업명  
        	"CHARGER_NM",
        	"TELNO",
        	"EMAIL",
        	"JURIRNO",  법인번호 
        	"LCLAS_CD",
        	"PRPOS",   용도  
        	"RECEPDSK",   제출처 
        	"JDGMNT_REQST_YEAR",   판정신쳥년도 
        	"UPPER_RCEPT_NO",   상위접수번호 
        	"REQST_SE",  신청구분 
        	"UPDT_AT",  갱신여부 
        	"PARTCLR_MATTER",  특이사항 
        	"ISGN_AT",  재발급여부  
        	"ISSU_DE",  발급일자 
        	"JDGMNT_CODE",  판정코드  
        	"JDGMNT_CODE_NM",  판정코드명 
        	"VALID_PD_BEGIN_DE",  유효기간시작일자 
        	"VALID_PD_END_DE",  유효기간종료일자 
        	"CONFM_SE",  확인서 구분 
        	"RESN_SE_S",  진행상태 사유구분 
        	"SE_CODE_S",  진행상태 구분코드 
        	"RESN_SE_R",  진행결과 사유구분  
        	"SE_CODE_R",  진행결과 구분코드  
        	"CREAT_DE",  생성일자 
        	"ISVALID",  유효기간여부 
        	"RESN",  진행결과 사유 
        	"NM",  진행결과 처리자명 
        	"CHARGER_DEPT",  담당자 부서 
        	"OFCPS"  직위 
        };*/

        mv.addObject("_headers", headers);
        mv.addObject("_items", items);
        
        IExcelVO excel = new ExcelVO("발급업무관리 리스트");

        return ResponseUtil.responseExcel(mv, excel);        
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
			smsContent = rcverNm + "의 기업확인서 보완요청이 있습니다.신청내역조회를 확인하세요.";
			emailMsg = "기업확인 신청에 대한 보완요청이 등록되었습니다. 자세한 내용은 신청내역조회를 확인하시기 바랍니다.";
			resn = "[보완요청사유] " + resn;
			templatFile = "TMPL_ISSU_STATUS_PS3.html";
			
		}else if(resn_s.equals(GlobalConst.RESN_SE_CODE_PS4)) {
			smsContent = rcverNm + "의 기업확인서 서류가 보완접수 되었습니다.";
			emailMsg = "기업확인 신청이 보완접수되었습니다.";
			
		}else if(resn_s.equals(GlobalConst.RESN_SE_CODE_PS6)) {
			if(resn_r.equals(GlobalConst.RESN_SE_CODE_RC1)) {
				smsContent = rcverNm + "의 기업확인서 발급되었습니다. 신청내역조회를 확인하세요.";
				emailSbj = sndrNm + " " + "신청하신 기업확인이 판정되었습니다.";
				emailMsg = "기업확인 신청에 대한 신청서가 발급되었습니다.";
				resn = "[유효기간]" + resn;
				templatFile = "TMPL_ISSU_STATUS_PS6_RC1.html";
				
			}else if(resn_r.equals(GlobalConst.RESN_SE_CODE_RC2)) {
				smsContent = rcverNm + "의 기업확인서 신청이 반려되었습니다. 기업정보에서 확인 가능합니다.";
				emailSbj = sndrNm + " " + "신청하신 기업확인이 판정되었습니다.";
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
	 * 관리자 확인서신청 1(기업찾기)
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView confmInsert1(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		Map param = new HashMap();
		
		/*int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");*/
		
		String initSearchYn = MapUtils.getString(rqstMap, "init_search_yn");
		
		String searchJurirno = MapUtils.getString(rqstMap, "searchJurirno");
		param.put("searchJurirno", searchJurirno);
		
		// 기업찾기 개수 조회
		/*int totalRowCnt = 0;
		if(Validate.isNotEmpty(initSearchYn)) {
			totalRowCnt = userService.findEntUserListCnt(param);
		}*/
		
		// 페이저 빌드
		/*Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();*/
		
		/*param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());*/
		param.put("limitFrom", 0);
		param.put("limitTo", 9999);
		
		// 기업찾기 조회
		List<Map> list = null;
		if(Validate.isNotEmpty(initSearchYn)) {
			list = userService.findEntUserList(param);
		}
		
		// 데이터 추가		
		/*mv.addObject("pager", pager);*/
		mv.addObject("list", list);
		
		mv.setViewName("/admin/im/BD_UIIMA0011");
		return mv;
	}
	
	/**
	 * 관리자 확인서신청 2(기본확인)
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView confmInsert2(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/im/BD_UIIMA0012");
		
		Map<String,Object> param = new HashMap<String,Object>();
		
		String ad_jurirno = MapUtils.getString(rqstMap, "ad_jurirno");
		
		param.put("JURIRNO", ad_jurirno);
		Map<String,String> applyMap = hpeCnfirmReqstMapper.selectTempApplyMaster(param);
		
		Calendar cal1 = Calendar.getInstance();
		mv.addObject("ad_stacnt_mt_yy", cal1.get(Calendar.YEAR));		//현재년도
		
		// 임시저장 유무 확인
		String existedTempData ="N";
		if(!Validate.isEmpty(applyMap)) {		
			mv.addObject("loadRceptNo", applyMap.get("RCEPT_NO"));
			mv.addObject("tempTargetYear", applyMap.get("CONFM_TARGET_YY"));
			existedTempData ="Y";
		}
		
		mv.addObject("existedTempData", existedTempData);		
		
		return mv;
	}
	
	/**
	 * 확인서 신청년도 조회
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getIssuYears(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map valueMap = new HashMap<String, Object>();
				
		int sacntYear = MapUtils.getIntValue(rqstMap, "ad_stacnt_mt_yy");
		int lastStdyy = sacntYear+1;
		
		valueMap.put("start_issu_year", 2010);
		valueMap.put("last_issu_year", lastStdyy);
		
		return ResponseUtil.responseJson(mv, Boolean.TRUE, valueMap, "");
	}
	
	/**
	 * 확인서 신청 가능여부(상호출자제한, 중소기업확인)
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView pblictePossibleAt(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		Map valueMap = new HashMap<String, Object>();
		
		String ad_jurirno = MapUtils.getString(rqstMap, "ad_jurirno");
		param.put("JURIRNO", ad_jurirno);
		
		int issuYear = MapUtils.getIntValue(rqstMap, "ad_issu_year");			// 확인신청년도
		
		Calendar cal = Calendar.getInstance( );
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		String stdDate = "";
		boolean isLastYear = true;
		
		valueMap.put("last_year_at", isLastYear);
		
		List<Map> dataList = null;
		
		/** 상호출자제한기업 확인 */
		// 최종년도
		if(isLastYear) {
			// 현재일 기준 지난달 1일
			cal.add(Calendar.MONTH, -1);
			cal.set(Calendar.DATE, 1);			
		
			stdDate = sdf.format(cal.getTime());
			
			param.put("STD_DE", stdDate);
			
			dataList = hpeCnfirmReqstMapper.selectMutualInvestLimit(param);
			if(Validate.isNotEmpty(dataList)) {
				valueMap.put("mutual_invest_limit_at", "Y");
			}else {
				valueMap.put("mutual_invest_limit_at", "N");
			}
		}
		
		/** 중소기업확인서발급내역 확인 */
		if(isLastYear) {
			cal = Calendar.getInstance();
			sdf = new SimpleDateFormat("yyyyMMdd");
			
			param.put("TODAY", sdf.format(cal.getTime()));
			dataList = hpeCnfirmReqstMapper.selectSmbaList(param);
			
			if(Validate.isNotEmpty(dataList)) {
				valueMap.put("smba_at", "Y");
				valueMap.put("process_de_fmt", StringUtil.toDateFormat(MapUtils.getString(dataList.get(0), "PROCESS_DE")));
			}else {
				valueMap.put("smba_at", "N");
			}
		}else{
			valueMap.put("smba_at", "N");
		}
		
		/** 대상년도 발급 신청건 조회 */
		param.put("JDGMNT_REQST_YEAR", issuYear);
		Map applyData = hpeCnfirmReqstMapper.selectApplyMasterReqstYear(param);
		
		if(Validate.isNotEmpty(applyData)) {
			valueMap.put("applyData_at", "Y");
		}else {
			valueMap.put("applyData_at", "N");
		}
		
		return ResponseUtil.responseJson(mv, Boolean.TRUE, valueMap, "");
	}
	
	/**
	 * 내용변경신청 수정
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView updateAK2(Map<?, ?> rqstMap) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		Map param = new HashMap();
		
		String rceptNo  = MapUtils.getString(rqstMap, "ad_load_rcept_no");
		String entrpsNm = MapUtils.getString(rqstMap, "ad_entrprs_nm");
		String rprsntvNm = MapUtils.getString(rqstMap, "ad_rprsntv_nm");
		String zip = MapUtils.getString(rqstMap, "ad_zip");
		String hedofcAdres = MapUtils.getString(rqstMap, "ad_hedofc_adres");
		String reprsntTlphon = MapUtils.getString(rqstMap, "ad_reprsnt_tlphon");
		String fxnum = MapUtils.getString(rqstMap, "ad_fxnum");
		
		List<String> bizrnoList = new ArrayList<String>();
		
		int addBiznoCnt = MapUtils.getIntValue(rqstMap, "ad_bizrno_cnt", 0);

		String addBizno = "";
		for(int i=1; i<=addBiznoCnt; i++) {
			addBizno = MapUtils.getString(rqstMap, "ad_bizrno_compno_" + i, "");
			bizrnoList.add(addBizno);
		}
		
		param.put("RCEPT_NO", rceptNo);
		param.put("ENTRPRS_SE", GlobalConst.ENTRPRS_SE_O);
		
		param.put("ENTRPS_NM", entrpsNm);
		param.put("RPRSNTV_NM", rprsntvNm);
		param.put("HEDOFC_ADRES", hedofcAdres);
		param.put("ZIP", zip);
		param.put("REPRSNT_TLPHON", reprsntTlphon);
		param.put("FXNUM", fxnum);
		
		// 내용변경신청 업데이트
		int IsgnBsisInfoUpdate = hpeCnfirmReqstMapper.updateIsgnBsisInfo(param);
		
		// 복수사업자번호관리 삭제
		hpeCnfirmReqstMapper.deleteCompnoBizrnoManage(param);
		// 복수사업자번호관리 등록
		for(String bizrno : bizrnoList) {
			if(Validate.isNotEmpty(bizrno)) {
				param.put("BIZRNO", bizrno);
				hpeCnfirmReqstMapper.insertCompnoBizrnoManage(param);
			}	
		}

		if(IsgnBsisInfoUpdate == 1)
			return ResponseUtil.responseText(mv,Boolean.TRUE);
		else
			return ResponseUtil.responseText(mv,Boolean.FALSE);
		
	}
}
