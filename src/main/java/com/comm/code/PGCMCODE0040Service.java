package com.comm.code;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.code.CodeService;
import com.comm.page.Pager;
import com.comm.user.UserVO;
import com.infra.util.SessionUtil;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 코드관리 서비스 클래스
 * 
 * @author sujong
 * 
 */
@Service("PGCMCODE0040")
public class PGCMCODE0040Service extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGCMCODE0040Service.class);

	@Resource(name = "messageSource")
	private MessageSource messageSource;

	@Autowired
	CodeService codeService;

	/**
	 * 코드그룹목록 조회
	 * 
	 * @param rqstMap
	 *            조회조건
	 * @return 코드그룹목록
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception
	{

			HashMap param = new HashMap();
			if (rqstMap.containsKey("searchCondition"))
				param.put("searchCondition", rqstMap.get("searchCondition"));
			
			if (rqstMap.containsKey("searchKeyword"))
				param.put("searchKeyword", rqstMap.get("searchKeyword"));
			
			int totCnt = codeService.findCodeGroupListCnt(param);
			int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
			int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
			logger.debug("rowSize: " + rowSize);
			
			// 페이저 빌드
			Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totCnt).rowSize(rowSize).build();
			pager.makePaging();

			param.put("limitFrom", pager.getLimitFrom());
			param.put("limitTo", pager.getLimitTo());

			List<Map> list = codeService.findCodeGroupList(param);

			//ModelAndView mv = new ModelAndView("/admin/ms/BD_UIMSA0040");
			ModelAndView mv = new ModelAndView("/admin/comm/code/BD_UICMCODEA0040");
			mv.addObject("codeGroupList", list);
			mv.addObject("pager", pager);
			return mv;
	}

	/**
	 * 코드등록 화면 출력
	 * 
	 * @param rqstMap
	 *            화면구성 기본 파라미터(페이징, 메뉴번호 등)
	 * @return
	 * @throws Exception
	 */
	public ModelAndView codeInsertForm(Map<?, ?> rqstMap) throws Exception
	{
		//return new ModelAndView("/admin/ms/BD_UIMSA0041");
		return new ModelAndView("/admin/comm/code/BD_UICMCODEA0041");
	}

	/**
	 * 코드수정 화면 출력
	 * 
	 * @param rqstMap
	 *            화면구성 기본 파라미터(페이징, 메뉴번호 등)
	 * @return
	 * @throws Exception
	 */
	public ModelAndView codeUpdateForm(Map<?, ?> rqstMap) throws Exception
	{
		if (!rqstMap.containsKey("codeGroupNo"))
			throw processException("errors.required", new String[] { "코드그룹번호" });

		HashMap param = new HashMap();
		param.put("codeGroupNo", rqstMap.get("codeGroupNo"));
		
		// 이전페이지
		HashMap prePage = new HashMap();
		int df_curr_page = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int df_row_per_page = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		int limitFrom = MapUtils.getIntValue(rqstMap, "limitFrom");
		int limitTo = MapUtils.getIntValue(rqstMap, "limitTo");
		String searchCondition = MapUtils.getString(rqstMap, "searchCondition");
		String searchKeyword = MapUtils.getString(rqstMap, "searchKeyword");
		
		prePage.put("df_curr_page", df_curr_page);
		prePage.put("df_row_per_page", df_row_per_page);
		prePage.put("limitFrom", limitFrom);
		prePage.put("limitTo", limitTo);
		prePage.put("searchCondition", searchCondition);
		prePage.put("searchKeyword", searchKeyword);

		//ModelAndView mv = new ModelAndView("/admin/ms/BD_UIMSA0042");
		ModelAndView mv = new ModelAndView("/admin/comm/code/BD_UICMCODEA0042");
		
		mv.addObject("prePage", prePage);
		mv.addObject("param", param);
		mv.addObject("codeGroupInfo", codeService.findCodeGroup(param));
		mv.addObject("codeList", codeService.findCodeList(param));

		return mv;
	}

	/**
	 * 코드등록 처리
	 * 
	 * @param rqstMap
	 *            코드 및 하위코드 정보
	 * @return 코드 등록 결과메시지 및 코드목록
	 * @throws Exception
	 */
	public ModelAndView processCode(Map<?, ?> rqstMap) throws Exception {

		// 등록자 정보
		UserVO user = SessionUtil.getUserInfo();

		// 등록자 정보
		HashMap param = new HashMap();
		param.put("register", user.getUserNo());
		param.put("updusr", user.getUserNo());

		// 코드그룹정보
		if (rqstMap.containsKey("codeGroupNo"))
			param.put("codeGroupNo", rqstMap.get("codeGroupNo"));
		param.put("codeGroupNm", rqstMap.get("codeGroupNm"));
		param.put("codeGroupDc", rqstMap.get("codeGroupDc"));

		// 코드목록 작성
		ArrayList<Map> cdList = new ArrayList();
		HashMap cdParam;

		int codeCnt = MapUtils.getIntValue(rqstMap, "codeCnt");
		for (int i = 0; i < codeCnt; i++) {
			cdParam = new HashMap();
			cdParam.put("code", MapUtils.getString(rqstMap, "code_" + (i)));
			cdParam.put("codeNm", MapUtils.getString(rqstMap, "codeNm_" + (i)));
			cdParam.put("codeDc", MapUtils.getString(rqstMap, "codeDc_" + (i)));
			cdParam.put("outptOrdr", MapUtils.getString(rqstMap, "outptOrdr_" + (i)));
			cdParam.put("useAt", MapUtils.getString(rqstMap, "useAt_" + (i)));
			cdParam.put("register", user.getUserNo());
			cdParam.put("updusr", user.getUserNo());

			cdList.add(cdParam);
		}

		// 코드목록
		param.put("codeList", cdList);
		// 코드 등록/수정
		codeService.processCode(param);
		// 코드목록 조회

		ModelAndView mv = index(rqstMap);

		// 결과메시지
		if (rqstMap.containsKey("codeGroupNo")) {
			mv.addObject(
					"resultMsg",
					messageSource.getMessage("success.common.update", new String[] { "코드" },
							Locale.getDefault()));
		} else {
			mv.addObject(
					"resultMsg",
					messageSource.getMessage("success.common.insert", new String[] { "코드" },
							Locale.getDefault()));
		}

		return mv;
	}

	/**
	 * 코드삭제 처리
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView deleteCode(Map<?, ?> rqstMap) throws Exception {

		if (!rqstMap.containsKey("codeGroupNo"))
			throw processException("errors.required", new String[] { "코드그룹번호" });

		HashMap param = new HashMap();
		param.put("codeGroupNo", rqstMap.get("codeGroupNo"));

		codeService.deleteCode(param);

		// 코드목록 조회
		ModelAndView mv = index(rqstMap);
		mv.addObject("resultMsg",
				messageSource.getMessage("success.common.delete", new String[] { "코드" }, Locale.getDefault()));

		return mv;
	}
}
