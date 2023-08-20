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

import biz.tech.mapif.pm.PGPM0080Mapper;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 연·월차관리 
 * 작성자 : CHB
 * 조회 / 수정
 */
@Service("PGPM0080")
public class PGPM0080Service extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(PGPM0080Service.class);

	private Locale locale = Locale.getDefault();
	
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	@Autowired
	PGPM0080Mapper PGPM0080Mapper;
	
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

		int totalRowCnt = 0;
		if (Validate.isNotEmpty(initSearchYn)) { 
			totalRowCnt = PGPM0080Mapper.findmemberlist(param); 
		}
		
		List<Map> userList = null;
		if (Validate.isNotEmpty(initSearchYn)) {
			userList = PGPM0080Mapper.membersearch(param);
		}
		
		mv.addObject("userList", userList);
		mv.setViewName("/admin/pm/BD_UIPMA0080");

		return mv;
	}
	
	// 수정 view 띄우기
	public ModelAndView programModify(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		String adempno = MapUtils.getString(rqstMap, "EMP_NO");	
		param.put("adempno", adempno);
		
		Map<?, ?> userInfo = PGPM0080Mapper.updatememberlist(param);
		
		
		ModelAndView mv = new ModelAndView();

		mv.addObject("userInfo", userInfo);
		mv.setViewName("/admin/pm/BD_UIPMA0081");
		
		return mv;
	}
	
	// 수정
	public ModelAndView processProgrm (Map<?,?> rqstMap) throws Exception {
		HashMap progrmParam = new HashMap();
		HashMap param = new HashMap();
		// 프로그램 등록 정보	
		String adempno = MapUtils.getString(rqstMap, "empno");				// 직원번호
		String adempnm = MapUtils.getString(rqstMap, "empnm");				// 이름
		String adincodt = MapUtils.getString(rqstMap, "incodt");			// 입사일자
		String adrmrk = MapUtils.getString(rqstMap, "rmrk");
		
		progrmParam.put("adempno", adempno);
		progrmParam.put("adempnm", adempnm);
		progrmParam.put("adincodt", adincodt);
		progrmParam.put("adrmrk", adrmrk);
		
		String adhdwuse = MapUtils.getString(rqstMap, "hdwuse");			// 당회휴가사용
		logger.debug("HD_WUSE : "+ adhdwuse);
		progrmParam.put("adhdwuse", adhdwuse);

		String adoutcodt = String.valueOf(rqstMap.get("outcodt"));			// 퇴사일자
		if(!adoutcodt.isEmpty() && adoutcodt != null) { 
			progrmParam.put("adoutcodt",adoutcodt);
		}else{};
		logger.debug("work : from "+adincodt+" to "+adoutcodt);
		
		// 중간 UPDATE
		PGPM0080Mapper.updatememberemp(progrmParam);
		
		param.put("adempno", adempno);		
		// 휴가일수 계산하는 메소드 3개 돌려주고
		PGPM0080Mapper.updateEMPYOS(param);
		PGPM0080Mapper.updateHDUSED(param); 
		PGPM0080Mapper.updateHDLEFT(param);
				
		HashMap indexMap = new HashMap(); 
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		indexMap.put("df_curr_page", pageNo);
		
		ModelAndView mv = index(indexMap);
		mv.addObject("resultMsg", messageSource.getMessage("success.common.update",
				new String[] {"프로그램"}, Locale.getDefault()));
		return mv;
	}
	
	
	
	/*
	 * 초기화 후 리얼그리드로 DB 불러오기 (미구현)
	 * ### Error updating database.  Cause: java.sql.SQLException: Connection is read-only. 
	 * 		Queries leading to data modification are not allowed
	 */
	public ModelAndView reset (Map<?,?> rqstMap) throws Exception {
		HashMap progrmParam = new HashMap();
		HashMap param = new HashMap();
		
		String empno = MapUtils.getString(rqstMap, "empno");					// 직원번호
		progrmParam.put("emp_no", empno);
		
		PGPM0080Mapper.updateHDtoZero(progrmParam);
		
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
		
		mv.addObject("resultMsg", messageSource.getMessage("success.common.update", new String[] {"프로그램"}, Locale.getDefault()));
		
		return mv;
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
		
		List<Map> userList = PGPM0080Mapper.membersearch(param);
		String count = GridCodi.MaptoJson(userList);
		logger.debug("============================== userList : "+userList);

		return ResponseUtil.responseText(mv, count);
	}
}
