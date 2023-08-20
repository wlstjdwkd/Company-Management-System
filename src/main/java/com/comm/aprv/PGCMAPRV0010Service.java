package com.comm.aprv;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.sun.media.sound.ModelDestination;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import com.comm.mapif.PGCMAPRV0010Mapper;
import com.comm.page.Pager;
import com.comm.user.UserVO;
import com.infra.util.JsonUtil;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.Validate;

@Service("PGCMAPRV0010")
public class PGCMAPRV0010Service extends EgovAbstractServiceImpl
{
	private static final Logger logger = LoggerFactory.getLogger(PGCMAPRV0010Service.class);

	@Resource
	private PGCMAPRV0010Mapper pgcmaprv0010Mapper;

	//메인화면 -> 결재선 조회
	public ModelAndView index(Map<?, ?> rqstMap) throws RuntimeException, Exception
	{
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();

		UserVO userVO = SessionUtil.getUserInfo();
		param.put("userNo", userVO.getUserNo());

		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		logger.debug("rowSize: " + rowSize);

		// 총 메뉴 글 개수
		int totalRowCnt = pgcmaprv0010Mapper.getBasisProgrsListCnt(param);

		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		int pagerNo = pager.getIndexNo();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());

		List<Map> list = pgcmaprv0010Mapper.getBasisProgrsList(param);
		//회사코드리스트
		mv.addObject("pager", pager);
		mv.addObject("pagerNo", pagerNo);
		mv.addObject("resultList", list);
		//mv.setViewName("/admin/ra/BD_UIRAA0010");
		mv.setViewName("/admin/comm/aprv/BD_UICMAPRVA0010");
		return mv;
	}
	
	//결재선 조회
	public ModelAndView getChoiceLine(Map<?, ?> rqstMap) throws RuntimeException, Exception
	{
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();

		UserVO userVO = SessionUtil.getUserInfo();
		param.put("userNo", userVO.getUserNo());

		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		logger.debug("rowSize: " + rowSize);
		param.put("useAt", "Y");

		// 총 메뉴 글 개수
		int totalRowCnt = pgcmaprv0010Mapper.getBasisProgrsListCnt(param);

		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		int pagerNo = pager.getIndexNo();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());

		List<Map> list = pgcmaprv0010Mapper.getBasisProgrsList(param);
		mv.addObject("pager", pager);
		mv.addObject("pagerNo", pagerNo);
		mv.addObject("resultList", list);
		//mv.setViewName("/admin/ra/PD_UIRAA0031");
		mv.setViewName("/admin/comm/aprv/PD_UICMAPRVA0031");
		return mv;
	}

	//신규등록 팝업
	public ModelAndView getCreateForm(Map<?, ?> rqstMap) throws RuntimeException, Exception
	{
		ModelAndView mv = new ModelAndView();
		String mode = MapUtils.getString(rqstMap, "mode");
		String sanctnSeq = MapUtils.getString(rqstMap, "sanctnSeq");

		mv.addObject("sanctnSeq", sanctnSeq);
		mv.addObject("mode", mode);
		//mv.setViewName("/admin/ra/PD_UIRAA0011");
		mv.setViewName("/admin/comm/aprv/PD_UICMAPRVA0011");
		return mv;
	}

	//등록 및 수정 팝업 - getCreateForm 열자마자 실행
	public ModelAndView findRegistrationInfo(Map<?, ?> rqstMap) throws RuntimeException, Exception
	{
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		boolean result = true;
		String mode = MapUtils.getString(rqstMap, "mode");
		String sanctnSeq = MapUtils.getString(rqstMap, "sanctnSeq");

		UserVO userVO = SessionUtil.getUserInfo();
		param.put("userNo", userVO.getUserNo());

		if("create".equals(mode)) {
			//결재선 번호
			int maxSeq = pgcmaprv0010Mapper.findSanctnSeq(param);
			param.put("sanctnSeq", maxSeq+1);

		}else {
			param.put("sanctnSeq", sanctnSeq);

			//등록된 정보 찾기
			List<Map> detailList = pgcmaprv0010Mapper.getBasisProgrsDetailList(param);
			param.put("detailList", detailList);
		}

		//기안자 정보
		Map empInfo = pgcmaprv0010Mapper.findEmplyrInfo(param);
		if(Validate.isNotEmpty(empInfo)) {
			param.put("drafterCd", MapUtils.getString(empInfo, "userNo"));
			param.put("drafterNm", MapUtils.getString(empInfo, "nm"));
			param.put("drafterDeptCd", MapUtils.getString(empInfo, "deptCd"));
			param.put("drafterDeptNm", MapUtils.getString(empInfo, "deptNm"));
		}

		return ResponseUtil.responseJson(mv, result, param);
	}

	//결재자 검색 팝업
	public ModelAndView findConfirmer(Map<?, ?> rqstMap) throws RuntimeException, Exception {
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();

		//부모창 테이블 rowIndex
		String index = MapUtils.getString(rqstMap, "index");
		mv.addObject("index", index);

		UserVO userVO = SessionUtil.getUserInfo();
		param.put("userNo", userVO.getUserNo());

		//유저 리스트
		List<Map> confirmerList = pgcmaprv0010Mapper.findConfirmerList(param);

		mv.addObject("confirmerList", confirmerList);
		//mv.setViewName("/admin/ra/PD_UIRAA0012");
		mv.setViewName("/admin/comm/aprv/PD_UICMAPRVA0012");
		return mv;
	}

	//결재선 등록 및 수정
	public ModelAndView createDraftLine(Map<?, ?> rqstMap) throws RuntimeException, Exception {
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		String mode = MapUtils.getString(rqstMap, "mode");
		UserVO userVO = SessionUtil.getUserInfo();

		String message = "등록되었습니다.";
		boolean result = true;
		int totalConfirmer = MapUtils.getIntValue(rqstMap, "totalConfirmer");

		try {
			param.put("drafterId", MapUtils.getString(rqstMap, "drafterCd"));				//기안자 번호
			param.put("sanctnSeq", MapUtils.getString(rqstMap, "sanctnSeq"));				//결재번호
			param.put("sanctnNm", MapUtils.getString(rqstMap, "sanctnNm"));					//결재명
			param.put("drafterDeptCd", MapUtils.getString(rqstMap, "drafterDeptCd"));		//기안자 부서코드
			param.put("drafterDeptNm", MapUtils.getString(rqstMap, "drafterDeptNm"));		//기안자 부서명
			param.put("drafterNm", MapUtils.getString(rqstMap, "drafterNm"));				//기안자명
			param.put("useAt", MapUtils.getString(rqstMap, "useAt"));						//사용여부
			param.put("register", userVO.getUserNo());										//등록자

			if("update".equals(mode)) {
				pgcmaprv0010Mapper.deleteBasisProgrs(param);
				message = "수정되었습니다.";
			}

			for(int i = 1; i <= totalConfirmer; i++) {
				param.put("progrsStep", MapUtils.getString(rqstMap, ("progrsStep_"+i)));				//결재순번
				param.put("confmerId", MapUtils.getString(rqstMap, ("confirmerNo_"+i)));				//결재자ID
				param.put("confmerNm", MapUtils.getString(rqstMap, ("confirmer_"+i)));					//결재자명
				param.put("sanctnEndAt", "N");															//결재선종료여부
				if(i == totalConfirmer) param.put("sanctnEndAt", "Y");									//결재선종료여부

				pgcmaprv0010Mapper.insertBasisProgrs(param);
			}
			result = true;
		} catch (RuntimeException e) {
			//e.printStackTrace();
			logger.error("",e);
			result = false;
			message = "실패하였습니다. 관리자에게 문의하세요.";
		} catch (Exception e) {
			//e.printStackTrace();
			logger.error("",e);
			result = false;
			message = "실패하였습니다. 관리자에게 문의하세요.";
		}

		Map<String, Object> returnObj = new HashMap<String, Object>();
		returnObj.put("message", message);
		returnObj.put("result", result);

		return ResponseUtil.responseText(mv, JsonUtil.toJson(returnObj));
	}

	//결재선 기본 정보 행 클릭시 디테일 정보 조회
	public ModelAndView findDetailProgrs(Map<?, ?> rqstMap) throws RuntimeException, Exception
	{
		ModelAndView mv =  new ModelAndView();
		HashMap param = new HashMap();
		UserVO userVO = SessionUtil.getUserInfo();
		boolean result = true;

		//결재선번호
		param.put("sanctnSeq", MapUtils.getString(rqstMap, "sanctnSeq"));
		param.put("userNo", userVO.getUserNo());

		List<Map> detailList = pgcmaprv0010Mapper.getBasisProgrsDetailList(param);
		param.put("resultList", detailList);
		return ResponseUtil.responseJson(mv, result, param);
	}

	//결재선 삭제
	public ModelAndView deleteDraftLine(Map<?,?> rqstMap) throws RuntimeException, Exception
	{
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		boolean result = true;
		UserVO userVO = SessionUtil.getUserInfo();

		//기안자번호
		param.put("drafterId", userVO.getUserNo());

		String delList = MapUtils.getString(rqstMap, "deleteList");
		String[] delDetail = delList.split(",");

		//결재선삭제
		for(String item : delDetail) {
			param.put("sanctnSeq", item);
			pgcmaprv0010Mapper.deleteBasisProgrs(param);
		}
		return ResponseUtil.responseJson(mv, result, param);
	}

	//대체 결재자 존재유무 확인
	public ModelAndView findAltrtvConfrm(Map<?,?> rqstMap) throws RuntimeException, Exception {
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		UserVO userVO = SessionUtil.getUserInfo();
		boolean result = false;

		String confmerId = MapUtils.getString(rqstMap, "confmerId");
		if(Validate.isNotEmpty(confmerId)) {
			param.put("confmerId", confmerId);
			Map altrtvInfo = pgcmaprv0010Mapper.findAltrtvConfrm(param);
			if(Validate.isNotEmpty(altrtvInfo)) {
				result = true;
				param.put("altrtvInfo", altrtvInfo);
			}
		}
		return ResponseUtil.responseJson(mv, result, param);
	}
}
