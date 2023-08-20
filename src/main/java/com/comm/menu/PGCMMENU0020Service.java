package com.comm.menu;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.menu.MenuService;
import com.comm.page.Pager;
import com.comm.program.ProgramService;
import com.comm.user.UserService;
import com.comm.user.UserVO;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;

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
 * 메뉴관리
 * 
 * @author KMY
 * 
 */
@Service("PGCMMENU0020")
public class PGCMMENU0020Service extends EgovAbstractServiceImpl
{
	private static final Logger logger = LoggerFactory.getLogger(PGCMMENU0020Service.class);

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;

	@Autowired
	UserService userService;

	@Autowired
	MenuService menuService;

	@Autowired
	ProgramService programService;

	/**
	 * 메뉴관리
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception
	{
		HashMap param = new HashMap();

		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		String menulist = MapUtils.getString(rqstMap, "ad_menuList");
		logger.debug("rowSize: " + rowSize);
		
		if("menulist".equals(menulist)) {
			String searchSiteSe = MapUtils.getString(rqstMap, "searchSiteSe");
			String searchMenuNm = MapUtils.getString(rqstMap, "searchMenuNm");
			param.put("searchSiteSe", searchSiteSe);
			param.put("searchMenuNm", searchMenuNm);
		}
		else {
			String searchSiteSe = MapUtils.getString(rqstMap, "searchSiteSe");
			String searchMenuNm = MapUtils.getString(rqstMap, "searchMenuNm");
			param.put("searchSiteSe", searchSiteSe);
			param.put("searchMenuNm", searchMenuNm);
		}

		// 총 메뉴 글 개수
		int totalRowCnt = menuService.findMenuListCnt(param);

		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		int pagerNo = pager.getIndexNo();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());

		// 메뉴 글 조회
		List<Map> menuList = menuService.findMenuList(param);

		// 데이터 추가
		ModelAndView mv = new ModelAndView();
		mv.addObject("param", param);
		mv.addObject("pager", pager);
		mv.addObject("pagerNo", pagerNo);
		mv.addObject("menuList", menuList);
		//mv.setViewName("/admin/ms/BD_UIMSA0020");
		mv.setViewName("/admin/comm/menu/BD_UICMMENUA0020");
		return mv;
	}

	/**
	 * 메뉴등록화면
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getMenuRegist(Map<?, ?> rqstMap) throws Exception
	{
		HashMap param = new HashMap();
		
		int df_curr_page = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int df_row_per_page = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		int limitFrom = MapUtils.getIntValue(rqstMap, "limitFrom");
		int limitTo = MapUtils.getIntValue(rqstMap, "limitTo");
		String searchSiteSe = MapUtils.getString(rqstMap, "searchSiteSe");
		String searchMenuNm = MapUtils.getString(rqstMap, "searchMenuNm");
		
		param.put("df_curr_page", df_curr_page);
		param.put("df_row_per_page", df_row_per_page);
		param.put("searchSiteSe", searchSiteSe);
		param.put("limitFrom", limitFrom);
		param.put("limitTo", limitTo);
		param.put("searchMenuNm", searchMenuNm);
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("param", param);
		//mv.setViewName("/admin/ms/BD_UIMSA0021");
		mv.setViewName("/admin/comm/menu/BD_UICMMENUA0021");
		return mv;
	}

	/**
	 * 메뉴수정화면
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getMenuModify(Map<?, ?> rqstMap) throws Exception
	{
		HashMap param = new HashMap();
		HashMap preParam = new HashMap();

		String menuNo = MapUtils.getString(rqstMap, "ad_menoNo");
		
		param.put("menuNo", menuNo);
		Map menuInfo = menuService.findMenuInfo(param);
		
		
		String searchSiteSe = MapUtils.getString(rqstMap, "searchSiteSe");
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
		preParam.put("searchMenuNm", searchMenuNm);
		

		ModelAndView mv = new ModelAndView();
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("preParam", preParam);
		//mv.setViewName("/admin/ms/BD_UIMSA0022");
		mv.setViewName("/admin/comm/menu/BD_UICMMENUA0022");
		return mv;
	}

	/**
	 * 메뉴등록/수정
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processMenu(Map<?, ?> rqstMap) throws Exception
	{
		HashMap param = new HashMap();

		// 등록자 정보
		UserVO user = SessionUtil.getUserInfo();

		// 등록자 정보
		param.put("register", user.getUserNo());
		param.put("updusr", user.getUserNo());

		String menuNo = MapUtils.getString(rqstMap, "ad_menuNo"); // 메뉴번호
		String menuNm = MapUtils.getString(rqstMap, "ad_menuNm"); // 메뉴명
		String programId = MapUtils.getString(rqstMap, "ad_programId"); // 프로그램ID
		String menuLevel = MapUtils.getString(rqstMap, "ad_menuLevel"); // 메뉴레벨
		String parntsMenuNo = MapUtils.getString(rqstMap, "ad_parntsMenuNo"); // 상위메뉴
		String outptOrdr = MapUtils.getString(rqstMap, "ad_outptOrdr"); // 출력순서
		String outptTy = MapUtils.getString(rqstMap, "ad_outptTy"); // 출력유형
		String outptAt = MapUtils.getString(rqstMap, "ad_rcv_outptAt"); // 출력여부
		String useAt = MapUtils.getString(rqstMap, "ad_rcv_useAt"); // 사용여부
		String lastNodeAt = MapUtils.getString(rqstMap, "ad_lastNodeAt"); // 최종노드여부
		String siteSe = MapUtils.getString(rqstMap, "ad_siteSe"); // 사이트구분
		String url = MapUtils.getString(rqstMap, "ad_url"); // URL

		String insert_update = MapUtils.getString(rqstMap, "ad_insert_update"); // 메뉴	등록/수정 체크

		// 메뉴등록정보
		param.put("menuNo", menuNo); // 메뉴번호
		param.put("menuNm", menuNm); // 메뉴명
		param.put("progrmId", programId); // 프로그램ID
		param.put("menuLevel", menuLevel); // 메뉴레벨
		param.put("parntsMenuNo", parntsMenuNo); // 상위메뉴번호
		param.put("outptOrdr", outptOrdr); // 출력순서
		param.put("outptTy", outptTy); // 출력유형
		param.put("outptAt", outptAt); // 출력여부
		param.put("useAt", useAt); // 사용여부
		param.put("lastNodeAt", lastNodeAt); // 최종노드여부
		param.put("siteSe", siteSe); // 사이트구분
		param.put("url", url); // URL
		param.put("insert_update", insert_update); // 메뉴 등록/수정 체크
		// 코드 등록/수정
		menuService.processMenu(param);

		
		// 등록/수정 후 화면
		HashMap indexMap = new HashMap(); 
		
		String preSiteSe = MapUtils.getString(rqstMap, "searchSiteSe");
		String preMenuNm = MapUtils.getString(rqstMap, "searchMenuNm");
		String preLimitTo = MapUtils.getString(rqstMap, "limitTo");
		String preLimitFrom = MapUtils.getString(rqstMap, "limitFrom");
		String pre_df_curr_page = MapUtils.getString(rqstMap, "df_curr_page");
		String pre_df_row_per_page = MapUtils.getString(rqstMap, "df_row_per_page");
		
		indexMap.put("searchSiteSe", preSiteSe);
		indexMap.put("searchMenuNm", preMenuNm);
		indexMap.put("limitTo", preLimitTo);
		indexMap.put("limitFrom", preLimitFrom);
		indexMap.put("df_curr_page", pre_df_curr_page);
		indexMap.put("df_row_per_page", pre_df_row_per_page);
		
		
		ModelAndView mv = index(indexMap);
		
		// 결과메시지
		if ("INSERT".equals(insert_update.toUpperCase())) {
			mv.addObject(
					"resultMsg",
					messageSource.getMessage("success.common.insert", new String[] { "메뉴" },
							Locale.getDefault()));
		} else if ("UPDATE".equals(insert_update.toUpperCase())) {
			mv.addObject(
					"resultMsg",
					messageSource.getMessage("success.common.update", new String[] { "메뉴" },
							Locale.getDefault()));
		}

		return mv;
	}

	/**
	 * 메뉴 삭제
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView deleteMenu(Map<?, ?> rqstMap) throws Exception
	{
		HashMap param = new HashMap();
		HashMap pParam = new HashMap();
		
		String menuNo = MapUtils.getString(rqstMap, "ad_menuNo");
		String parntsMenuNo = MapUtils.getString(rqstMap, "ad_parntsMenuNo");
		String lastNodeAt = "N";
		String parntsMenuDelete = "DELETE";

		param.put("menuNo", menuNo);
		param.put("lastNodeAt", lastNodeAt);
		param.put("parntsMenuDelete", parntsMenuDelete);
		param.put("parntsMenuNo", parntsMenuNo);
		pParam.put("menuNo", parntsMenuNo);
		
		// 메뉴 삭제
		menuService.deleteMenu(param);
		// 같은 형제 메뉴가 남아 있는지 조회
		int outptOrdrList = menuService.findOutptOrdr(pParam);
		// 같은 형제 메뉴가 없을 경우, 상위메뉴의 lastNodeAt N->Y 변경
		if (outptOrdrList == 0) {
			menuService.processMenu(param);
		}
		
		// 삭제 후 화면
		HashMap indexMap = new HashMap(); 
		
		String preSiteSe = MapUtils.getString(rqstMap, "searchSiteSe");
		String preMenuNm = MapUtils.getString(rqstMap, "searchMenuNm");
		String preLimitTo = MapUtils.getString(rqstMap, "limitTo");
		String preLimitFrom = MapUtils.getString(rqstMap, "limitFrom");
		String pre_df_curr_page = MapUtils.getString(rqstMap, "df_curr_page");
		String pre_df_row_per_page = MapUtils.getString(rqstMap, "df_row_per_page");
		
		indexMap.put("searchSiteSe", preSiteSe);
		indexMap.put("searchMenuNm", preMenuNm);
		indexMap.put("limitTo", preLimitTo);
		indexMap.put("limitFrom", preLimitFrom);
		indexMap.put("df_curr_page", pre_df_curr_page);
		indexMap.put("df_row_per_page", pre_df_row_per_page);
		
		ModelAndView mv = index(indexMap);
		
		mv.addObject("resultMsg",
				messageSource.getMessage("success.common.delete", new String[] { "메뉴" }, Locale.getDefault()));
		
		return mv;
	}

	/**
	 * 프로그램찾기
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getProgramList(Map<?, ?> rqstMap) throws Exception
	{
		HashMap param = new HashMap();

		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		logger.debug("rowSize: " + rowSize);

		String searchJobSe = MapUtils.getString(rqstMap, "searchJobSe");
		String searchProgramNm = MapUtils.getString(rqstMap, "searchProgramNm");

		param.put("searchJobSe", searchJobSe);
		param.put("searchProgramNm", searchProgramNm);

		// 총 메뉴 글 개수
		int totalRowCnt = programService.findProgramListCnt(param);

		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());

		// 프로그램 글 조회
		List<Map> programList = programService.findProgramList(param);

		// 데이터 추가
		ModelAndView mv = new ModelAndView();
		mv.addObject("pager", pager);
		mv.addObject("programList", programList);

		//mv.setViewName("/admin/ms/PD_UIMSA0023");
		mv.setViewName("/admin/comm/menu/PD_UICMMENUA0023");
		return mv;
	}

	/**
	 * 상위메뉴찾기
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getParntsMenuList(Map<?, ?> rqstMap) throws Exception
	{
		HashMap param = new HashMap();

		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		logger.debug("rowSize: " + rowSize);

		String searchSiteSe = MapUtils.getString(rqstMap, "pop_searchSiteSe");
		String searchMenuNm = MapUtils.getString(rqstMap, "searchMenuNm");
		String menuLevelCheck = "check";
		
		
		
		param.put("searchSiteSe", searchSiteSe);
		param.put("searchMenuNm", searchMenuNm);
		param.put("menuLevelCheck", menuLevelCheck);

		// 총 메뉴 글 개수
		int totalRowCnt = menuService.findMenuListCnt(param);

		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		int pagerNo = pager.getIndexNo();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());

		// 메뉴 조회
		List<Map> menuList = menuService.findMenuList(param);

		// 데이터 추가
		ModelAndView mv = new ModelAndView();
		mv.addObject("pager", pager);
		mv.addObject("pagerNo", pagerNo);
		mv.addObject("menuList", menuList);
		mv.addObject("searchSiteSe",searchSiteSe);
		//mv.setViewName("/admin/ms/PD_UIMSA0024");
		mv.setViewName("/admin/comm/menu/PD_UICMMENUA0024");
		return mv;
	}

	/**
	 * 출력순서 조회
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView findOutptOrdr(Map<?, ?> rqstMap) throws Exception
	{
		HashMap param = new HashMap();
		String menuNo = MapUtils.getString(rqstMap, "menuNo");
		param.put("menuNo", menuNo);

		int outptOrdrList = menuService.findOutptOrdr(param);

		ModelAndView mv = new ModelAndView();
		return ResponseUtil.responseText(mv, outptOrdrList);

	}
}