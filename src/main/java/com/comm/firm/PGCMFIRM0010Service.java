package com.comm.firm;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import com.comm.mapif.PGCMFIRM0010Mapper;
import com.comm.page.Pager;
import com.comm.response.ExcelVO;
import com.comm.response.IExcelVO;
import com.comm.user.UserVO;
import com.infra.util.JsonUtil;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.Validate;

@Service("PGCMFIRM0010")
public class PGCMFIRM0010Service extends EgovAbstractServiceImpl
{
	private static final Logger logger = LoggerFactory.getLogger(PGCMFIRM0010Service.class);

	@Resource(name = "messageSource")
	private MessageSource messageSource;

	@Resource(name="PGCMFIRM0010Mapper")
	private PGCMFIRM0010Mapper pgcmfirm0010Mapper;

	/**
	 * 부서 관리 - 조회 페이지
	 * @param rqstMap
	 * @return
	 * @throws RuntimeException, Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ModelAndView index(Map<?,?> rqstMap) throws RuntimeException, Exception
	{
		ModelAndView mv = new ModelAndView();
		Map param = new HashMap<>();

		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		String searchDeptCd = MapUtils.getString(rqstMap, "searchDeptCd");					// 부서코드
		String searchDeptLevel = MapUtils.getString(rqstMap, "searchDeptLevel");			// 부서레벨
		String searchUdeptCd = MapUtils.getString(rqstMap, "searchUdeptCd");				// 상위부서코드
		String searchUseAt = MapUtils.getString(rqstMap, "searchDeptUseAt");				// 사용여부

		param.put("searchDeptCd", searchDeptCd);
		param.put("searchDeptLevel", searchDeptLevel);
		param.put("searchUdeptCd", searchUdeptCd);
		param.put("searchUseAt", searchUseAt);

		// 페이징 처리
		int totalRowCnt = pgcmfirm0010Mapper.findDeptListCnt(param);
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		int pagerNo = pager.getIndexNo();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());

		// 리스트 가져오기 및 데이터 가공
		List<Map> resultList = pgcmfirm0010Mapper.findDeptList(param);
		for(Map item: resultList) {
			if(Validate.isNotEmpty(MapUtils.getString(item, "rgsDe"))) {
				String rgsDe = MapUtils.getString(item, "rgsDe").substring(0,10);
				item.put("rgsDe", rgsDe.substring(0,4) + "-" + rgsDe.substring(5,7) + "-" + rgsDe.substring(8));
			}
			if(Validate.isNotEmpty(MapUtils.getString(item, "updDe"))) {
				String updDe = MapUtils.getString(item, "updDe").substring(0,10);
				item.put("updDe", updDe.substring(0,4) + "-" + updDe.substring(5,7) + "-" + updDe.substring(8));
			}
		}
		mv.addObject("resultList", resultList);

		mv.addObject("pager", pager);
		mv.addObject("pagerNo", pagerNo);
		mv.addObject("df_curr_page", pageNo);
		mv.addObject("df_row_per_page", rowSize);
		mv.addObject("deptAllList", pgcmfirm0010Mapper.findDeptCdNmList());
		mv.addObject("paramMap", param);

		//mv.setViewName("/admin/comm/firm/BD_UIMSA0170");
		mv.setViewName("/admin/comm/firm/BD_UICMFIRMA0010");
		return mv;
	}

	/**
	 * 엑셀 다운로드
	 * @param rqstMap
	 * @return
	 * @throws RuntimeException, Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ModelAndView processExcelRsolver(Map<?,?> rqstMap) throws RuntimeException, Exception
	{
		ModelAndView mv = new ModelAndView();
		Map param = new HashMap<>();

		param.put("searchDeptCd", MapUtils.getString(rqstMap, "searchDeptCd"));
		param.put("searchDeptLevel", MapUtils.getString(rqstMap, "searchDeptLevel"));
		param.put("searchUdeptCd", MapUtils.getString(rqstMap, "searchUdeptCd"));
		param.put("searchUseAt", MapUtils.getString(rqstMap, "searchUseAt"));

		List<Map> resultList = pgcmfirm0010Mapper.findDeptListExcel(param);
		mv.addObject("_list", resultList);

		String[] headers = {
				"부서코드",
				"부서명",
				"부서레벨",
				"상위부서",
				"사용여부",
				"등록일",
				"수정일"
		};
		String[] items = {
				"deptCd",
				"deptNm",
				"deptLevel",
				"udeptNm",
				"useAt",
				"rgsDe",
				"updDe"
		};

		mv.addObject("_headers", headers);
        mv.addObject("_items", items);

		IExcelVO excel = new ExcelVO("부서 목록");
		return ResponseUtil.responseExcel(mv, excel);
	}

	/**
	 * 부서 등록 or 수정 페이지
	 * @param rqstMap
	 * @return
	 * @throws RuntimeException, Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ModelAndView registOrUpdate(Map<?,?> rqstMap) throws RuntimeException, Exception
	{
		ModelAndView mv = new ModelAndView();
		Map param = new HashMap<>();

		String rou = MapUtils.getString(rqstMap, "registOrUpdate");
		String deptCd = MapUtils.getString(rqstMap, "deptCd").trim();

		if(rou.equals("update")) {
			mv.addObject("title", "부서코드 수정");
			mv.addObject("button", "수정");
		} else {
			mv.addObject("title", "부서코드 등록");
			mv.addObject("button", "등록");
		}

		if(Validate.isNotEmpty(deptCd)) {
			param.put("deptCd", deptCd);
			Map deptInfo = pgcmfirm0010Mapper.findDeptInfo(param);
			mv.addObject("deptInfo", deptInfo);
		}

		List<Map> deptAllList = pgcmfirm0010Mapper.findDeptCdNmList();
		mv.addObject("deptAllList", deptAllList);

		mv.addObject("registOrUpdate", rou);
		mv.addObject("deptCd", deptCd);

		//mv.setViewName("/admin/ms/BD_UIMSA0171");
		mv.setViewName("/admin/comm/firm/BD_UICMFIRMA0011");
		return mv;
	}

	/**
	 * 등록 혹은 갱신 로직
	 * @param rqstMap
	 * @return
	 * @throws RuntimeException, Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ModelAndView updateOrInsertDept(Map<?,?> rqstMap) throws RuntimeException, Exception
	{
		ModelAndView mv = new ModelAndView();
		Map param = new HashMap<>();
		Map returnObj = new HashMap<>();

		UserVO userVo = SessionUtil.getUserInfo();
		if(Validate.isEmpty(userVo)) {
			returnObj.put("message", "다시 로그인 해주세요.");
			returnObj.put("result", false);
			return ResponseUtil.responseText(mv, JsonUtil.toJson(returnObj));
		}

		String message = "";
		String rou = MapUtils.getString(rqstMap, "registOrUpdate");

		param.put("deptCd", MapUtils.getString(rqstMap, "deptCd"));
		param.put("deptNm", MapUtils.getString(rqstMap, "deptNm"));
		param.put("deptLevel", MapUtils.getString(rqstMap, "deptLevel"));
		param.put("udeptCd", MapUtils.getString(rqstMap, "udeptCd"));
		param.put("useAt", MapUtils.getString(rqstMap, "useAt"));

		try {
			if(rou.equals("regist")) {							// 등록
				param.put("register", userVo.getUserNo());
				pgcmfirm0010Mapper.insertDeptInfo(param);
			} else {											// 갱신
				param.put("originDeptCd", MapUtils.getString(rqstMap, "originDeptCd"));
				param.put("updUsr", userVo.getUserNo());
				pgcmfirm0010Mapper.updateDeptInfo(param);
				pgcmfirm0010Mapper.updateUDeptCd(param);
			}
		} catch(RuntimeException e) {
			logger.error("",e);
			if(rou.equals("regist")) message = messageSource.getMessage("fail.common.insert", new String[] {"부서"}, Locale.getDefault());
			else message = messageSource.getMessage("fail.common.update", new String[] {"부서"}, Locale.getDefault());

			returnObj.put("message", message);
			returnObj.put("result", false);
			return ResponseUtil.responseText(mv, JsonUtil.toJson(returnObj));
		} catch(Exception e) {
			logger.error("",e);
			if(rou.equals("regist")) message = messageSource.getMessage("fail.common.insert", new String[] {"부서"}, Locale.getDefault());
			else message = messageSource.getMessage("fail.common.update", new String[] {"부서"}, Locale.getDefault());

			returnObj.put("message", message);
			returnObj.put("result", false);
			return ResponseUtil.responseText(mv, JsonUtil.toJson(returnObj));
		}

		if(rou.equals("regist")) message = messageSource.getMessage("success.common.insert", new String[] {"부서"}, Locale.getDefault());
		else message = messageSource.getMessage("success.common.update", new String[] {"부서"}, Locale.getDefault());

		returnObj.put("message", message);
		returnObj.put("result", true);

		return ResponseUtil.responseText(mv, JsonUtil.toJson(returnObj));
	}
}
