package com.comm.aprv;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.MapUtils;
import org.joda.time.LocalDateTime;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import com.comm.mapif.PGCMAPRV0020Mapper;
import com.comm.page.Pager;
import com.comm.user.UserVO;
import com.infra.util.JsonUtil;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.Validate;

@Service("PGCMAPRV0020")
public class PGCMAPRV0020Service extends EgovAbstractServiceImpl
{
	@Resource(name="PGCMAPRV0020Mapper")
	private PGCMAPRV0020Mapper pgcmaprv0020Mapper;

	/**
	 * 대체승인목록 화면 출력
	 *
	 * @param rqstMap
	 * request parameters
	 * @return ModelAndView
	 * @throws RuntimeException, Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ModelAndView index(Map<?,?> rqstMap) throws RuntimeException, Exception {

		ModelAndView mv = new ModelAndView();

		HashMap param = new HashMap();

		UserVO userVO = SessionUtil.getUserInfo();
		param.put("confmerId", userVO.getUserNo());

		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");

		//대체승인 목록 갯수
		int totalRowCnt = pgcmaprv0020Mapper.findListCnt(param);

		//페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		int pagerNo = pager.getIndexNo();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());

		//대체승인 목록
		List<Map> resultList = pgcmaprv0020Mapper.findList(param);

		mv.addObject("param", param);
		mv.addObject("pager", pager);
		mv.addObject("pagerNo", pagerNo);
		mv.addObject("resultList", resultList);
		mv.setViewName("/admin/mp/BD_UIMPA0020");
		return mv;
	}

	/**
	 * 대체승인 등록/수정 입력 폼
	 *
	 * @param rqstMap
	 * request parameters
	 * @return ModelAndView
	 * @throws RuntimeException, Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ModelAndView altrtvConfrmForm(Map<?,?> rqstMap) throws RuntimeException, Exception
	{
		ModelAndView mv = new ModelAndView();
		HashMap preParam = new HashMap();
		HashMap param = new HashMap();
		
		//이전페이지값
		int df_curr_page = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int df_row_per_page = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		int limitFrom = MapUtils.getIntValue(rqstMap, "limitFrom");
		int limitTo = MapUtils.getIntValue(rqstMap, "limitTo");
		
		preParam.put("df_curr_page", df_curr_page);
		preParam.put("df_row_per_page", df_row_per_page);
		preParam.put("limitFrom", limitFrom);
		preParam.put("limitTo", limitTo);

		String mode = MapUtils.getString(rqstMap, "mode");

		if(mode.equals("regist")) {
			mv.addObject("mode", mode);
		}

		if(mode.equals("modify")) {

			param.put("confmerId", MapUtils.getString(rqstMap, "confmerId"));
			param.put("altrtvConfmerId", MapUtils.getString(rqstMap, "altrtvConfmerId"));
			param.put("altrtvConfmBgnDe", MapUtils.getString(rqstMap, "altrtvConfmBgnDe"));

			//대체승인 상세
			Map altrtvDetail = pgcmaprv0020Mapper.getAltrtvDetail(param);

			mv.addObject("mode", mode);
			mv.addObject("altrtvDetail", altrtvDetail);
		}

		mv.addObject("preParam", preParam);
		mv.setViewName("/admin/mp/BD_UIMPA0021");
		return mv;
	}

	/**
	 * 대체승인자 검색 팝업
	 *
	 * @param rqstMap
	 * request parameters
	 * @return ModelAndView
	 * @throws RuntimeException, Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ModelAndView altrtvSearch(Map<?,?> rqstMap) throws RuntimeException, Exception
	{
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		
		UserVO userVO = SessionUtil.getUserInfo();
		String userNo = userVO.getUserNo();
		
		param.put("userNo", userNo);
		
		//유저 리스트
		mv.addObject("altrtvConfmerList", pgcmaprv0020Mapper.findAltrtvConfmerList(param));

		mv.setViewName("/admin/mp/PD_UIMPA0022");
		return mv;
	}

	/**
	 * 대체승인자 등록
	 *
	 * @param rqstMap
	 * request parameters
	 * @return ModelAndView
	 * @throws RuntimeException, Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ModelAndView insertAltrtvInfo(Map<?,?> rqstMap) throws RuntimeException, Exception
	{
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		Map<String, Object> returnObj = new HashMap<String, Object>();
		boolean result = false;

		UserVO userVO = SessionUtil.getUserInfo();
		String userNo = userVO.getUserNo();
		String userNm = userVO.getUserNm();

		String altrtvConfmerId = MapUtils.getString(rqstMap, "altrtvConfmerId");
		String altrtvConfmerNm = MapUtils.getString(rqstMap, "altrtvConfmerNm");
		String altrtvConfmBgnDe = MapUtils.getString(rqstMap, "altrtvConfmBgnDe");
		String altrtvConfmEndDe = MapUtils.getString(rqstMap, "altrtvConfmEndDe");
		String altrtvReason = MapUtils.getString(rqstMap, "altrtvReason");
		String useAt = MapUtils.getString(rqstMap, "useAt");

		if(Validate.isEmpty(altrtvConfmerId) || Validate.isEmpty(altrtvConfmerNm)) {
			returnObj.put("message", "대체승인자를 선택해주세요.");
			returnObj.put("result", result);
			return ResponseUtil.responseText(mv, JsonUtil.toJson(returnObj));
		}
		
		LocalDateTime bgnDate = LocalDateTime.parse(altrtvConfmBgnDe);
		LocalDateTime endDate = LocalDateTime.parse(altrtvConfmEndDe);
		if(bgnDate.isAfter(endDate)) {
			returnObj.put("message", "시작일이 종료일보다 클 수 없습니다.");
			returnObj.put("result", result);
			return ResponseUtil.responseText(mv, JsonUtil.toJson(returnObj));
		}
		
		param.put("confmerId", userNo);
		param.put("altrtvConfmerId", altrtvConfmerId);
		param.put("altrtvConfmBgnDe", altrtvConfmBgnDe);

		if(useAt.equals("Y")) {

			List<Map> altrtvConfmDeList = pgcmaprv0020Mapper.findAltrtvConfmDe(param);
			boolean overlapChk = false;
			if(Validate.isNotEmpty(altrtvConfmDeList)) {
				overlapChk = periodOverlapCheck(altrtvConfmDeList , altrtvConfmBgnDe , altrtvConfmEndDe);
			}

			if(overlapChk) {
				returnObj.put("message", "대체승인기간이 겹치는 대체승인자가 존재합니다.");
				returnObj.put("result", result);
				return ResponseUtil.responseText(mv, JsonUtil.toJson(returnObj));
			}
		}
		
		List<Map> sameAltrtvConfmDeList = pgcmaprv0020Mapper.findSameAltrtvConfmDe(param);
		
		if(Validate.isNotEmpty(sameAltrtvConfmDeList)) {
			returnObj.put("message", "이미 등록된 대체자 정보입니다. <br/> 이미 등록된 정보를 수정하거나 삭제 후 등록하세요.");
			returnObj.put("result", result);
			return ResponseUtil.responseText(mv, JsonUtil.toJson(returnObj));
		}

		param.put("confmerNm", userNm);
		param.put("altrtvConfmerNm", altrtvConfmerNm);
		param.put("altrtvConfmEndDe", altrtvConfmEndDe);
		param.put("altrtvReason", altrtvReason);
		param.put("useAt", useAt);
		param.put("register", userNo);

		pgcmaprv0020Mapper.insertAltrtvInfo(param);

		result = true;

		returnObj.put("message", "대체승인자가 등록되었습니다.");
		returnObj.put("result", result);
		return ResponseUtil.responseText(mv, JsonUtil.toJson(returnObj));
	}

	/**
	 * 대체승인자 수정
	 *
	 * @param rqstMap
	 * request parameters
	 * @return ModelAndView
	 * @throws RuntimeException, Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ModelAndView updateAltrtvInfo(Map<?,?> rqstMap) throws RuntimeException, Exception
	{
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		Map<String, Object> returnObj = new HashMap<String, Object>();
		boolean result = false;

		UserVO userVO = SessionUtil.getUserInfo();
		String userNo = userVO.getUserNo();

		String preAltrtvConfmerId = MapUtils.getString(rqstMap, "preAltrtvConfmerId");
		String preAltrtvConfmBgnDe = MapUtils.getString(rqstMap, "preAltrtvConfmBgnDe");

		String altrtvConfmerId = MapUtils.getString(rqstMap, "altrtvConfmerId");
		String altrtvConfmerNm = MapUtils.getString(rqstMap, "altrtvConfmerNm");
		String altrtvConfmBgnDe = MapUtils.getString(rqstMap, "altrtvConfmBgnDe");
		String altrtvConfmEndDe = MapUtils.getString(rqstMap, "altrtvConfmEndDe");
		String altrtvReason = MapUtils.getString(rqstMap, "altrtvReason");
		String useAt = MapUtils.getString(rqstMap, "useAt");

		LocalDateTime bgnDate = LocalDateTime.parse(altrtvConfmBgnDe);
		LocalDateTime endDate = LocalDateTime.parse(altrtvConfmEndDe);
		if(bgnDate.isAfter(endDate)) {
			returnObj.put("message", "시작일이 종료일보다 클 수 없습니다.");
			returnObj.put("result", result);
			return ResponseUtil.responseText(mv, JsonUtil.toJson(returnObj));
		}
		
		param.put("confmerId", userNo);
		param.put("preAltrtvConfmerId", preAltrtvConfmerId);
		param.put("preAltrtvConfmBgnDe", preAltrtvConfmBgnDe);
		
		if(useAt.equals("Y")) {
			List<Map> altrtvConfmDeList = pgcmaprv0020Mapper.findAltrtvConfmDe(param);

			boolean overlapChk = false;
			if(Validate.isNotEmpty(altrtvConfmDeList)) {
				overlapChk = periodOverlapCheck(altrtvConfmDeList , altrtvConfmBgnDe , altrtvConfmEndDe);
			}

			if(overlapChk) {
				returnObj.put("message", "대체승인기간이 겹치는 대체승인자가 존재합니다.");
				returnObj.put("result", result);
				return ResponseUtil.responseText(mv, JsonUtil.toJson(returnObj));
			}
		}
		
		param.put("altrtvConfmerId", altrtvConfmerId);
		param.put("altrtvConfmBgnDe", altrtvConfmBgnDe);
		
		List<Map> sameAltrtvConfmDeList = pgcmaprv0020Mapper.findSameAltrtvConfmDe(param);
		
		if(!preAltrtvConfmBgnDe.equals(altrtvConfmBgnDe)) {
			if(Validate.isNotEmpty(sameAltrtvConfmDeList)) {
				returnObj.put("message", "이미 등록된 대체자 정보입니다.");
				returnObj.put("result", result);
				return ResponseUtil.responseText(mv, JsonUtil.toJson(returnObj));
			}
		}
		
		param.put("altrtvConfmerNm", altrtvConfmerNm);
		param.put("altrtvConfmEndDe", altrtvConfmEndDe);
		param.put("altrtvReason", altrtvReason);
		param.put("useAt", useAt);
		param.put("updusr", userNo);

		pgcmaprv0020Mapper.updateAltrtvInfo(param);

		result = true;

		returnObj.put("message", "대체승인자가 수정되었습니다.");
		returnObj.put("result", result);
		return ResponseUtil.responseText(mv, JsonUtil.toJson(returnObj));
	}

	/**
	 * 대체승인일 기간 중복체크
	 *
	 * @param rqstMap
	 * request parameters
	 * @return ModelAndView
	 * @throws RuntimeException, Exception
	 */
	@SuppressWarnings("rawtypes")
	public boolean periodOverlapCheck(List<Map> list , String bgnDe , String endDe) throws RuntimeException, Exception
	{
		boolean result = false;

		LocalDateTime bgnDate = LocalDateTime.parse(bgnDe);
		LocalDateTime endDate = LocalDateTime.parse(endDe);

		for(Map item : list) {
			LocalDateTime originBgnDate = LocalDateTime.parse(MapUtils.getString(item, "altrtvConfmBgnDe"));
			LocalDateTime originEndDate = LocalDateTime.parse(MapUtils.getString(item, "altrtvConfmEndDe"));

			//입력받은 시작기간이 기존 시작기간과 같을떄
			if(bgnDate.isEqual(originBgnDate)) {
				result = true;
			}
			//입력받은 시작기간이 기존 종료기간과 같을떄
			else if(bgnDate.isEqual(originEndDate)) {
				result = true;
			}
			//입력받은 시작기간이 기존 시작기간과  기존 종료기간 사이일떄
			else if(bgnDate.isAfter(originBgnDate) && bgnDate.isBefore(originEndDate)) {
				result = true;
			}
			//입력받은 종료기간이 기존 종료기간과 같을떄
			else if(endDate.isEqual(originEndDate)) {
				result = true;
			}
			//입력받은 종료기간이 기존시작기간과 같을때
			else if(endDate.isEqual(originBgnDate)) {
				result = true;
			}
			//입력받은 종료기간이 기존 시작기간과 기존 종료기간 사이일때
			else if(endDate.isAfter(originBgnDate) && endDate.isBefore(originEndDate)) {
				result = true;
			}
		}
		return result;
	}
	
	/**
	 * 대체승인자 삭제
	 *
	 * @param rqstMap
	 * request parameters
	 * @return ModelAndView
	 * @throws RuntimeException, Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ModelAndView deleteAltrtvInfo(Map<?,?> rqstMap) throws RuntimeException, Exception
	{
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		Map<String, Object> returnObj = new HashMap<String, Object>();
		boolean result = false;

		UserVO userVO = SessionUtil.getUserInfo();
		String userNo = userVO.getUserNo();
		
		String preAltrtvConfmerId = MapUtils.getString(rqstMap, "preAltrtvConfmerId");
		String preAltrtvConfmBgnDe = MapUtils.getString(rqstMap, "preAltrtvConfmBgnDe");
		
		param.put("confmerId", userNo);
		param.put("altrtvConfmerId", preAltrtvConfmerId);
		param.put("altrtvConfmBgnDe", preAltrtvConfmBgnDe);

		pgcmaprv0020Mapper.deleteAltrtvInfo(param);

		result = true;

		returnObj.put("message", "대체승인자가 삭제되었습니다.");
		returnObj.put("result", result);
		return ResponseUtil.responseText(mv, JsonUtil.toJson(returnObj));
	}
}