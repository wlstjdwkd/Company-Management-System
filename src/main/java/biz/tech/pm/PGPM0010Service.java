package biz.tech.pm;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.infra.file.FileDAO;
import com.infra.util.ResponseUtil;
import com.infra.util.Validate;
import com.infra.web.GridCodi;

import biz.tech.mapif.pm.PGPM0010Mapper;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 직원등록조회  
 *
 * 조회 / 등록 / 수정 / 비활성(재직여부 = N)
 */
@Service("PGPM0010")
public class PGPM0010Service extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGPM0010Service.class);

	private Locale locale = Locale.getDefault();

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	@Autowired
	PGPM0010Mapper PGPM0010Mapper;
	
	@Resource(name = "filesDAO")
	private FileDAO fileDao;

	/**
	 * 회원관리 회원 리스트 검색
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {		
		ModelAndView mv = new ModelAndView();
		Map param = new HashMap<>();
		param = (Map<?, ?>) rqstMap;

		String initSearchYn = MapUtils.getString(rqstMap, "init_search_yn");

//		int totalRowCnt = 0;
//		if (Validate.isNotEmpty(initSearchYn)) { 
//			totalRowCnt = PGPM0010Mapper.findmemberlist(param); 
//		}
		
		List<Map> userList = null;
		if (Validate.isNotEmpty(initSearchYn)) {
			userList = PGPM0010Mapper.membersearch(param);
		}
		
		mv.addObject("userList", userList);
		mv.setViewName("/admin/pm/BD_UIPMA0010");

		return mv;
	}
	
	// 등록 창 띄우기
	public ModelAndView programRegist(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap<>();
		Calendar today = Calendar.getInstance();
		
		//현재 년도를 받아 화면단에서 조회년도를 어디까지할 것인지 지정
		param.put("curr_year", String.valueOf(today.get(Calendar.YEAR)));
		
		mv.addObject("frontParam",param);
		mv.setViewName("/admin/pm/BD_UIPMA0011");
		
		return mv;
		
	}

	// 수정/삭제 View 띄우기
	public ModelAndView programModify(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		Calendar today = Calendar.getInstance();
		String adempno = MapUtils.getString(rqstMap, "EMP_NO");
		
		param.put("adempno", adempno);
		
		Map<?, ?> userInfo = PGPM0010Mapper.updatememberlist(param);
		
		//직급명 찾기
		param.put("codeGroupNo", 31);
		param.put("code", userInfo.get("POS_CD"));
		Map<?, ?> rankInfo = PGPM0010Mapper.findCmmnCode(param);
		
		//근무형태명 찾기
		param.put("codeGroupNo", 33);
		param.put("code", userInfo.get("WRK_TP"));
		Map<?, ?> workTypeInfo = PGPM0010Mapper.findCmmnCode(param);
		
		//부서명 찾기
		param.put("codeGroupNo", 89);
		param.put("code", userInfo.get("DEPT_CD"));
		Map<?, ?> deptInfo = PGPM0010Mapper.findCmmnCode(param);
		
		//현재 년도를 받아 화면단에서 조회년도를 어디까지할 것인지 지정
		param.put("curr_year", String.valueOf(today.get(Calendar.YEAR)));
		
		ModelAndView mv = new ModelAndView();

		mv.addObject("frontParam",param);
		mv.addObject("userInfo", userInfo);
		mv.addObject("rankInfo", rankInfo);
		mv.addObject("workTypeInfo", workTypeInfo);
		mv.addObject("deptInfo", deptInfo);

		mv.setViewName("/admin/pm/BD_UIPMA0012");
		
		return mv;
	}
	
	// 등록 및 수정
	public ModelAndView processProgrm (Map<?,?> rqstMap) throws Exception {
		HashMap progrmParam = new HashMap();
		
		// 프로그램 등록 정보	
		String adempno = MapUtils.getString(rqstMap, "empno");					// 직원번호
		String adempnm = MapUtils.getString(rqstMap, "empnm");					// 이름
		String adwrktp = MapUtils.getString(rqstMap, "wrktp");					// 근무형태
		String adposcd = MapUtils.getString(rqstMap, "poscd");					// 직급코드
		String addeptcd = MapUtils.getString(rqstMap, "deptcd");				// 직급코드
		String adcizno = MapUtils.getString(rqstMap, "cizno");					// 주민번호
		String addealbnk = MapUtils.getString(rqstMap, "dealbnk");				// 거래은행
		String adacctno = MapUtils.getString(rqstMap, "acctno");				// 계좌번호
		String adincodt = MapUtils.getString(rqstMap, "incodt");				// 입사일자
		String adadjyr = MapUtils.getString(rqstMap, "adjyr");					// 조정년
		String adadjmon = MapUtils.getString(rqstMap, "adjmon");				// 조정월
		String adrmrk = MapUtils.getString(rqstMap, "rmrk");					// 비고
		String adbdt = MapUtils.getString(rqstMap, "bdt");						// 생년월일
		String admobtel = MapUtils.getString(rqstMap, "mobtel");				// 휴대전화번호
		String adhmtel = MapUtils.getString(rqstMap, "hmtel");					// 집전화번호
		String adlsed = MapUtils.getString(rqstMap, "lsed");					// 최종학력
		String addpt = MapUtils.getString(rqstMap, "dpt");						// 학과
		String addgr = MapUtils.getString(rqstMap, "dgr");						// 인정학력
		String adgrayr = MapUtils.getString(rqstMap, "grayr");					// 졸업년
		String adgramn = MapUtils.getString(rqstMap, "gramn");					// 졸업월
		String adpermail = MapUtils.getString(rqstMap, "pmail");				// 개인메일
		String adcommail = MapUtils.getString(rqstMap, "cmail");				// 회사메일
		String adaddr = MapUtils.getString(rqstMap, "addr");					// 주소
		String admrg = MapUtils.getString(rqstMap, "mrg");						// 혼인여부
		String admrgdt = MapUtils.getString(rqstMap, "mrgdt");					// 결혼기념일
		String addcrt = MapUtils.getString(rqstMap, "dcrt");					// 공제세율
		
		progrmParam.put("adempno", adempno);
		progrmParam.put("adempnm", adempnm);
		progrmParam.put("adwrktp", adwrktp);
		progrmParam.put("adposcd", adposcd);
		progrmParam.put("addeptcd", addeptcd);
		progrmParam.put("adcizno", adcizno);
		progrmParam.put("addealbnk", addealbnk);
		progrmParam.put("adacctno", adacctno);
		progrmParam.put("adincodt", adincodt);
		/* // 달력에 아무것도 입력되지 않아도 값이 null이 아님 
		 * if(!adoutcodt.isEmpty() && adoutcodt != null) { progrmParam.put("adoutcodt",
		 * adoutcodt); }
		 */
		progrmParam.put("adadjyr", adadjyr);
		progrmParam.put("adadjmon", adadjmon);
		progrmParam.put("adrmrk", adrmrk);
		progrmParam.put("adbdt", adbdt);
		progrmParam.put("admobtel", admobtel);
		progrmParam.put("adhmtel", adhmtel);
		progrmParam.put("adlsed", adlsed);
		progrmParam.put("addpt", addpt);
		progrmParam.put("addgr", addgr);
		progrmParam.put("adgrayr", adgrayr);
		progrmParam.put("adgramn", adgramn);
		progrmParam.put("adpermail", adpermail);
		progrmParam.put("adcommail", adcommail);
		progrmParam.put("adaddr", adaddr);
		progrmParam.put("admrg", admrg);
		progrmParam.put("admrgdt", admrgdt);
		progrmParam.put("addcrt", addcrt);

		// 등록,수정 구분
		String insert_update = MapUtils.getString(rqstMap, "insert_update");

		// 프로그램 등록
		if("INSERT".equals(insert_update.toUpperCase())) {
			String adoutcodt = MapUtils.getString(rqstMap, "outcodt");				// 퇴사일자
			progrmParam.put("adoutcodt", adoutcodt);
			progrmParam.put("adcurryn", "Y");
			PGPM0010Mapper.insertMemberemp(progrmParam);
		}
		// 프로그램 수정
		else {
			String adoutcodt = ((String[])rqstMap.get("outcodt"))[1];				// 퇴사일자
			progrmParam.put("adoutcodt", adoutcodt);
			PGPM0010Mapper.updatememberemp(progrmParam);
		} 
		
		HashMap indexMap = new HashMap(); 
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		String searchJobSe = MapUtils.getString(rqstMap, "searchJobSe");
		String searchProgramNm = MapUtils.getString(rqstMap, "searchProgramNm");
		
		indexMap.put("df_curr_page", pageNo);
		indexMap.put("df_row_per_page", rowSize);
		indexMap.put("searchJobSe", searchJobSe);
		indexMap.put("searchProgramNm", searchProgramNm);
		
		ModelAndView mv = index(indexMap);
		
		if("INSERT".equals(insert_update.toUpperCase())) {
			mv.addObject("resultMsg", messageSource.getMessage("success.common.insert", new String[] {"프로그램"}, Locale.getDefault()));
		} else {
			mv.addObject("resultMsg", messageSource.getMessage("success.common.update", new String[] {"프로그램"}, Locale.getDefault()));
		}
		
		return mv;
	}
	
	//프로그램, 권한 정보 삭제
	public ModelAndView deleteProgrm (Map <?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		
		String adempno = MapUtils.getString(rqstMap, "empno");
		
		logger.debug("===================adempno:"+adempno);
		
		param.put("adempno", adempno);
		
		// 프로그램 삭제
		PGPM0010Mapper.updateResignedEmployee(param);
		
		HashMap indexMap = new HashMap();
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		String searchJobSe = MapUtils.getString(rqstMap, "searchJobSe");
		String searchProgramNm = MapUtils.getString(rqstMap, "searchProgramNm");
		
		indexMap.put("df_curr_page", pageNo);
		indexMap.put("df_row_per_page", rowSize);
		indexMap.put("searchJobSe", searchJobSe);
		indexMap.put("searchProgramNm", searchProgramNm);
		
		ModelAndView mv = index(indexMap);
		mv.addObject("resultMsg", messageSource.getMessage("success.common.delete", new String[] {"프로그램"}, Locale.getDefault()));
		return mv;
	} 
	
	/**
	 * 근무형태 찾기 팝업 띄우기
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView goWorkTypeList(Map<?, ?> rqstMap) throws Exception {
		// 데이터 추가
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/pm/PD_UIPMA0013");
		
		return mv;
	}
	/**
	 * 직급 찾기 팝업 띄우기
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView goRankList(Map<?, ?> rqstMap) throws Exception {
		// 데이터 추가
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/pm/PD_UIPMA0014");
		
		return mv;
	}
	
	/**
	 * 부서 찾기 팝업 띄우기
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView goDepartmentList(Map<?, ?> rqstMap) throws Exception {
		// 데이터 추가
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/pm/PD_UIPMA0015");
		
		return mv;
	}
	
	// 근무형태 리스트
	public ModelAndView getWorkTypeList(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		
		param.put("codeGroupNo", 33);
		
		List<Map> codeList = PGPM0010Mapper.findCmmnCodeList(param);
		String jsData = GridCodi.MaptoJson(codeList);
		
		ModelAndView mv = new ModelAndView("");
		return ResponseUtil.responseText(mv, jsData);
	}
	
	// 직급 리스트
	public ModelAndView getRankList(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		
		param.put("codeGroupNo", 31);
		
		List<Map> codeList = PGPM0010Mapper.findCmmnCodeList(param);
		String jsData = GridCodi.MaptoJson(codeList);
		
		ModelAndView mv = new ModelAndView("");
		return ResponseUtil.responseText(mv, jsData);
	}
		
	// 부서 리스트
	public ModelAndView getDepartmentList(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		
		param.put("codeGroupNo", 89);
		
		List<Map> codeList = PGPM0010Mapper.findCmmnCodeList(param);
		String jsData = GridCodi.MaptoJson(codeList);
		
		ModelAndView mv = new ModelAndView("");
		return ResponseUtil.responseText(mv, jsData);
	}
	
	//리얼그리드로 DB 불러오기
	public ModelAndView countSess(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map param = new HashMap<>();
		param = (Map<?, ?>) rqstMap;
		
		String ad_search_word = MapUtils.getString(rqstMap, "ad_search_word");
		String limitFrom = MapUtils.getString(rqstMap, "limitFrom");
		String limitTo = MapUtils.getString(rqstMap, "limitTo");

		param.put("ad_search_word", ad_search_word);
		param.put("limitFrom", limitFrom);
		param.put("limitTo", limitTo);
		
		logger.debug("========================= ad_search_word : "+ad_search_word);
		
		List<Map> userList = PGPM0010Mapper.membersearch(param);
		String count = GridCodi.MaptoJson(userList);
		logger.debug("============================== userList : "+userList);

		return ResponseUtil.responseText(mv, count);
	}
}
