package biz.tech.ev;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.infra.file.FileDAO;
import com.infra.util.ResponseUtil;
import com.infra.util.Validate;
import com.infra.web.GridCodi;

import biz.tech.mapif.pm.PGPM0010Mapper;
import biz.tech.mapif.ev.PGEV0200Mapper;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

@Service("PGEV0200")
public class PGEV0200Service extends EgovAbstractServiceImpl {
	private static final Logger logger = LoggerFactory.getLogger(PGEV0200Service.class);
	private Locale locale = Locale.getDefault();

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	@Autowired
	PGPM0010Mapper PGPM0010Mapper;

	@Autowired
	PGEV0200Mapper PGEV0200Mapper;

	@Resource(name = "filesDAO")
	private FileDAO fileDao;

	public ModelAndView index(Map<?, ?> reqMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map param = new HashMap<>();
		param = (Map<?, ?>) reqMap;

		String initSearchYn = MapUtils.getString(reqMap, "init_search_yn");

		int totalRowCnt = 0;
		if (Validate.isNotEmpty(initSearchYn)) {
			totalRowCnt = PGEV0200Mapper.findmemberlist(param);
		}

		List<Map> userList = null;
		if (Validate.isNotEmpty(initSearchYn)) {
			userList = PGEV0200Mapper.membersearch(param);
		}

		mv.addObject("userList", userList);
		mv.setViewName("/admin/ev/BD_UIEVA0200");

		return mv;
	}
	
	//이력카드 창 띄우기
	public ModelAndView programResume(Map<?, ?> rqstMap) throws Exception{
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap<>();
		
		String adempno = MapUtils.getString(rqstMap, "EMP_NO");
		System.out.println("==================="+adempno);
		param.put("adempno", adempno);
		Map<?, ?> userInfo = PGEV0200Mapper.findResumeMember(param);
		Map<?, ?> skillInfo = PGEV0200Mapper.findSkillMember(param);
		Map<?, ?> scholarInfo = PGEV0200Mapper.findScholarship(param);
				
		mv.addObject("userInfo", userInfo);
		mv.addObject("skillInfo", skillInfo);
		mv.addObject("scholarInfo", scholarInfo);
		
		mv.setViewName("/admin/ev/BD_UIEVA0202");
		return mv;
	}
	
	//등록 창 띄우기
	public ModelAndView programRegist(Map<?, ?> rqstMap) throws Exception{
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap<>();
		
		String adempno = MapUtils.getString(rqstMap, "empno");
		
		mv.setViewName("/admin/ev/UIEVA0201");
		
		return mv;
	}
	
	//등록하기
	public ModelAndView insertResume(Map<?, ?>rqstMap) throws Exception{
		HashMap programParam = new HashMap();
		
		//이력서 등록 정보
		//이름
		//주민번호
		
		//성별
		String gender = MapUtils.getString(rqstMap, "gender");
		//입사일
		String comeDay = MapUtils.getString(rqstMap, "comeDay");
		//부서
		
		//직위
		//결혼
		//기타
		String etc = MapUtils.getString(rqstMap, "etc");
		//전역구분
		String armyYes = MapUtils.getString(rqstMap, "armyYes");
		//군별
		String soldier = MapUtils.getString(rqstMap, "soldier");
		//복무시작기간
		
		//복무종료기간
		
		//병과
		String armyType = MapUtils.getString(rqstMap, "armyType");
		//수행업무
		String doWork = MapUtils.getString(rqstMap, "doWork");
		//유선전화
		//무선전화
		//이메일
		//주소
		//학교이름
		String schoolname = MapUtils.getString(rqstMap, "schoolname");
		//학교구분
		String schooltype = MapUtils.getString(rqstMap, "schooltype");
		//학과
		String department = MapUtils.getString(rqstMap, "department");
		//프로젝트명
		String projectName = MapUtils.getString(rqstMap, "projectName");
		//고객사
		String clientCompany = MapUtils.getString(rqstMap,"clientCompany");
		//시작기간
		String projectStart = MapUtils.getString(rqstMap, "projectStart");
		//종료기간
		String projectEnd = MapUtils.getString(rqstMap, "projectEnd");
		//역할
		String type = MapUtils.getString(rqstMap, "type");
		//OS
		String OS = MapUtils.getString(rqstMap, "OS");
		//기술스택
		String techType = MapUtils.getString(rqstMap, "techType");
		//언어
		String language = MapUtils.getString(rqstMap, "language");
		//DBMS
		String DBMS = MapUtils.getString(rqstMap, "DBMS");
		//TOOL
		String tool = MapUtils.getString(rqstMap, "tool");
		//통신
		String message = MapUtils.getString(rqstMap, "message");
		//기타
		String etc2 = MapUtils.getString(rqstMap, "etc2");
		
		//이름
		//주민번호
		programParam.put("gender",gender);
		programParam.put("comeDay", comeDay);
		//부서
		//직위
		//결혼
		programParam.put("etc", etc);
		programParam.put("armyYes", armyYes);
		programParam.put("soldier",soldier);
		//복무시작기간
		//복무종료기간
		programParam.put("armyType", armyType);
		programParam.put("doWork", doWork);
		//유선전화
		//무선전화
		//이메일
		//주소
		programParam.put("schoolname",schoolname);
		programParam.put("schooltype", schooltype);
		programParam.put("department", department);
		programParam.put("projectName", projectName);
		programParam.put("clientCompany", clientCompany);
		programParam.put("projectStart", projectStart);
		programParam.put("projectEnd", projectEnd);
		programParam.put("type", type);
		programParam.put("OS",OS);
		programParam.put("techType", techType);
		programParam.put("language", language);
		programParam.put("DBMS", DBMS);
		programParam.put("tool", tool);
		programParam.put("message", message);
		programParam.put("etc2", etc2);
		
		ModelAndView mv = new ModelAndView();
		return mv;
		
		
	}


	   // 개별 조회 창 띄우기
	   public ModelAndView programEvaluation(Map<?, ?> rqstMap) throws Exception {
	      ModelAndView mv = new ModelAndView();
	      HashMap param = new HashMap<>();

	      String ad_PK = MapUtils.getString(rqstMap, "ad_PK");
	      param.put("ad_PK", ad_PK);

	      List<Map> evaList = null;
	      if (Validate.isNotEmpty(ad_PK)) {
//	         evaList = PGEV0200Mapper.findEvaList(param);
	      }

	      mv.addObject("ad_PK", MapUtils.getString(rqstMap, "ad_PK"));
	      mv.addObject("ad_name", MapUtils.getString(rqstMap, "ad_name"));
	      mv.addObject("ad_rank", MapUtils.getString(rqstMap, "ad_rank"));
	      mv.addObject("ad_in_date", MapUtils.getString(rqstMap, "ad_in_date"));
	      mv.addObject("evaList", evaList);
	      mv.setViewName("/admin/ev/BD_UIEVA0201");
	      return mv;
	   }
	

	public ModelAndView programModify(Map<?, ?> reqMap) throws Exception {
		HashMap param = new HashMap();
		Calendar today = Calendar.getInstance();
		String adempno = MapUtils.getString(reqMap, "EMP_NO");

		param.put("adempno", adempno);
		Map<?, ?> userInfo = PGEV0200Mapper.updatememberlist(param);

		param.put("codeGroupNo", 31);
		param.put("code", userInfo.get("POS_CD"));
		Map<?, ?> rankInfo = PGEV0200Mapper.findCmmnCode(param);

		param.put("codeGroupNo", 33);
		param.put("code", userInfo.get("WRK_TP"));
		Map<?, ?> workTypeInfo = PGEV0200Mapper.findCmmnCode(param);

		param.put("codeGroupNo", 89);
		param.put("code", userInfo.get("DEPT_CD"));
		Map<?, ?> deptInfo = PGEV0200Mapper.findCmmnCode(param);

		param.put("curr_year", String.valueOf(today.get(Calendar.YEAR)));

		ModelAndView mv = new ModelAndView();

		mv.addObject("frontParam", param);
		mv.addObject("userInfo", userInfo);
		mv.addObject("rankInfo", rankInfo);
		mv.addObject("workTypeInfo", workTypeInfo);
		mv.addObject("deptInfo", deptInfo);

		mv.setViewName("/admin/pm/BD_UIPMA0112");

		return mv;
	}

	public ModelAndView processProgrm(Map<?, ?> reqMap) throws Exception {
		HashMap progrmParam = new HashMap();

		progrmParam.put("adempno", MapUtils.getString(reqMap, "empno"));
		progrmParam.put("adempnm", MapUtils.getString(reqMap, "empnm"));
		progrmParam.put("adwrktp", MapUtils.getString(reqMap, "wrktp"));
		progrmParam.put("adposcd", MapUtils.getString(reqMap, "poscd"));
		progrmParam.put("addeptcd", MapUtils.getString(reqMap, "deptcd"));
		progrmParam.put("adcizno", MapUtils.getString(reqMap, "cizno"));
		progrmParam.put("addealbnk", MapUtils.getString(reqMap, "dealbnk"));
		progrmParam.put("adacctno", MapUtils.getString(reqMap, "acctno"));
		progrmParam.put("adincodt", MapUtils.getString(reqMap, "incodt"));
		progrmParam.put("adadjyr", MapUtils.getString(reqMap, "adjyr"));
		progrmParam.put("adadjmon", MapUtils.getString(reqMap, "adjmon"));
		progrmParam.put("adrmrk", MapUtils.getString(reqMap, "rmrk"));
		progrmParam.put("adbdt", MapUtils.getString(reqMap, "bdt"));
		progrmParam.put("admobtel", MapUtils.getString(reqMap, "mobtel"));
		progrmParam.put("adhmtel", MapUtils.getString(reqMap, "hmtel"));
		progrmParam.put("adlsed", MapUtils.getString(reqMap, "lsed"));
		progrmParam.put("addpt", MapUtils.getString(reqMap, "dpt"));
		progrmParam.put("addgr", MapUtils.getString(reqMap, "dgr"));
		progrmParam.put("adgrayr", MapUtils.getString(reqMap, "grayr"));
		progrmParam.put("adgramn", MapUtils.getString(reqMap, "gramn"));
		progrmParam.put("adpermail", MapUtils.getString(reqMap, "pmail"));
		progrmParam.put("adcommail", MapUtils.getString(reqMap, "cmail"));
		progrmParam.put("adaddr", MapUtils.getString(reqMap, "addr"));
		progrmParam.put("admrg", MapUtils.getString(reqMap, "mrg"));
		progrmParam.put("admrgdt", MapUtils.getString(reqMap, "mrgdt"));
		progrmParam.put("addcrt", MapUtils.getString(reqMap, "dcrt"));

		String insert_update = MapUtils.getString(reqMap, "insert_update").toUpperCase();

		if ("INSERT".equals(insert_update)) {
			String adoutcodt = MapUtils.getString(reqMap, "outcodt");
			progrmParam.put("adoutcodt", adoutcodt);
			progrmParam.put("adcurryn", "Y");
			PGEV0200Mapper.insertMemberemp(progrmParam);
		} else {
			String adoutcodt = ((String[]) reqMap.get("outcodt"))[1];
			progrmParam.put("adoutcodt", adoutcodt);
			PGEV0200Mapper.updatememberemp(progrmParam);
		}

		HashMap indexMap = new HashMap();

		int pageNo = MapUtils.getIntValue(reqMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(reqMap, "df_row_per_page");
		String searchJobSe = MapUtils.getString(reqMap, "searchJobSe");
		String searchProgramNm = MapUtils.getString(reqMap, "searchProgramNm");

		indexMap.put("df_curr_page", pageNo);
		indexMap.put("df_row_per_page", rowSize);
		indexMap.put("searchJobSe", searchJobSe);
		indexMap.put("searchProgramNm", searchProgramNm);

		ModelAndView mv = index(indexMap);

		if ("INSERT".equals(insert_update)) {
			mv.addObject("resultMsg",
					messageSource.getMessage("success.common.insert", new String[] { "프로그램" }, Locale.getDefault()));
		} else {
			mv.addObject("resultMsg",
					messageSource.getMessage("success.common.update", new String[] { "프로그램" }, Locale.getDefault()));
		}

		return mv;
	}

	public ModelAndView deleteProgrm(Map<?, ?> reqMap) throws Exception {
		HashMap param = new HashMap();

		String adempno = MapUtils.getString(reqMap, "empno");

		logger.debug("===================adempno:" + adempno);

		param.put("adempno", adempno);

		PGEV0200Mapper.updateResignedEmployee(param);

		HashMap indexMap = new HashMap();

		int pageNo = MapUtils.getIntValue(reqMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(reqMap, "df_row_per_page");
		String searchJobSe = MapUtils.getString(reqMap, "searchJobSe");
		String searchProgramNm = MapUtils.getString(reqMap, "searchProgramNm");

		indexMap.put("df_curr_page", pageNo);
		indexMap.put("df_row_per_page", rowSize);
		indexMap.put("searchJobSe", searchJobSe);
		indexMap.put("searchProgramNm", searchProgramNm);

		ModelAndView mv = index(indexMap);
		mv.addObject("resultMsg",
				messageSource.getMessage("success.common.delete", new String[] { "프로그램" }, Locale.getDefault()));

		return mv;
	}

	public ModelAndView goWorkTypeList(Map<?, ?> reqMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/pm/PD_UIPMA0113");

		return mv;
	}

	public ModelAndView goRankList(Map<?, ?> reqMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/pm/PD_UIPMA0114");

		return mv;
	}

	public ModelAndView goDepartmentList(Map<?, ?> reqMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/pm/PD_UIPMA0115");

		return mv;
	}

	public ModelAndView getWorkTypeList(Map<?, ?> reqMap) throws Exception {
		HashMap param = new HashMap();
		param.put("codeGroupNo", 33);
		List<Map> codeList = PGEV0200Mapper.findCmmnCodeList(param);

		return ResponseUtil.responseText(new ModelAndView(""), GridCodi.MaptoJson(codeList));
	}

	public ModelAndView getRankList(Map<?, ?> reqMap) throws Exception {
		HashMap param = new HashMap();
		param.put("codeGroupNo", 31);
		List<Map> codeList = PGEV0200Mapper.findCmmnCodeList(param);

		return ResponseUtil.responseText(new ModelAndView(""), GridCodi.MaptoJson(codeList));
	}

	public ModelAndView getDepartmentList(Map<?, ?> reqMap) throws Exception {
		HashMap param = new HashMap();
		param.put("codeGroupNo", 89);
		List<Map> codeList = PGEV0200Mapper.findCmmnCodeList(param);

		return ResponseUtil.responseText(new ModelAndView(""), GridCodi.MaptoJson(codeList));
	}

	// 리얼그리드로 DB 불러오기
	public ModelAndView countSess(Map<?, ?> reqMap) throws Exception {
		Map param = new HashMap<>();
		param = (Map<?, ?>) reqMap;

		String ad_search_word = MapUtils.getString(reqMap, "ad_search_word");
		logger.debug("========================= ad_search_word : " + ad_search_word);

		param.put("ad_search_word", ad_search_word);
		param.put("limitFrom", MapUtils.getString(reqMap, "limitFrom"));
		param.put("limitTo", MapUtils.getString(reqMap, "limitTo"));

		List<Map> userList = PGEV0200Mapper.membersearch(param);
		logger.debug("============================== userList : " + userList);

		return ResponseUtil.responseText(new ModelAndView(), GridCodi.MaptoJson(userList));
	}
}
