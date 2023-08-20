package biz.tech.js;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.StringTokenizer;

import javax.annotation.Resource;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.js.PGJS0020Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

/**
 * 기업판정기준 관리 서비스 클래스
 * 
 * @author sujong
 * 
 */
@Service("PGJS0020")
public class PGJS0020Service extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGJS0020Service.class);

	private static final String STDRCL_SCALE = "ST1";
	private static final String STDRCL_UPLMT = "ST2";
	private static final String STDRCL_INDPN = "ST3";
	private static final String FIN_END_DE = "99991231";
	
	@Resource(name="messageSource")
	private MessageSource messageSource;
	
	@Resource(name = "PGJS0020Mapper")
	private PGJS0020Mapper pgjs0020Dao;

	// 판정기준 순번(규모)
	@Resource(name = "judgeStdrScaleGnrService")
	private EgovIdGnrService judgeStdrScaleGnrService;

	// 판정기준 순번(상한)
	@Resource(name = "judgeStdrUplmtGnrService")
	private EgovIdGnrService judgeStdrUplmtGnrService;

	// 판정기준 순번(독립성)
	@Resource(name = "judgeStdrIndpnGnrService")
	private EgovIdGnrService judgeStdrIndpnGnrService;

	/**
	 * 판정기준 목록 조회
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/js/BD_UIJSA0020");

		// 규모기준 목록 조회
		HashMap param = new HashMap();
		param.put("jdgmntStdrCl", STDRCL_SCALE);

		List<Map> resultList = pgjs0020Dao.selectJudgeStdrList(param);
		mv.addObject("scaleList", resultList);

		// 상한기준
		param = new HashMap();
		param.put("jdgmntStdrCl", STDRCL_UPLMT);

		resultList = pgjs0020Dao.selectJudgeStdrList(param);
		mv.addObject("uplmtList", resultList);

		// 독립성기준
		param = new HashMap();
		param.put("jdgmntStdrCl", STDRCL_INDPN);

		resultList = pgjs0020Dao.selectJudgeStdrList(param);
		mv.addObject("indpntList", resultList);

		return mv;
	}

	/**
	 * 규모기준 등록/수정 화면
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView formScaleStdr(Map rqstMap) throws Exception {
		
		ModelAndView mv = new ModelAndView("/admin/js/BD_UIJSA0021");
		
		// 입력값 검증		
		validateJudgeStdr(rqstMap);

		HashMap param = new HashMap();
		param.put("jdgmntStdrCl", STDRCL_SCALE);
		
		// 등록/수정 구분
		String acType = MapUtils.getString(rqstMap, "ad_ac_type");
		
		if (acType.equals("update") || acType.equals("view")) {
			
			param.put("stdrSn", MapUtils.getString(rqstMap, "ad_stdr_sn"));
			
			// 판정기준 상세정보 조회
			mv.addObject("judgeStdrInfo", pgjs0020Dao.selectJudgeStdr(param));
			
			// 규모기준 목록 조회
			mv.addObject("scaleStdrList", pgjs0020Dao.selectScaleStdrList(param));
		}
		
		// 최종 판정기준 상세정보 조회
		mv.addObject("lastJudgeStdrInfo", pgjs0020Dao.selectLastJudgeStdr(param));
		
		return mv;
	}

	/**
	 * 업종 목록 조회(팝업)
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectIndCdList(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/js/PD_UIJSA0024");
		
		HashMap param = new HashMap();
		
		// 수정화면에서 호출한 팝업이면, 기 등록된 업종 조회
		if (MapUtils.getString(rqstMap, "ad_ac_type", "").equals("update") || MapUtils.getString(rqstMap, "ad_ac_type", "").equals("view")) {
			if (!rqstMap.containsKey("ad_stdr_sn") || !rqstMap.containsKey("ad_sn"))
				throw processException("errors.required", new String[] {"기준순번, 순번"});

				param.put("ad_ac_type", MapUtils.getString(rqstMap, "ad_ac_type"));
				param.put("jdgmntStdrCl", STDRCL_SCALE);
				param.put("stdrSn", MapUtils.getString(rqstMap, "ad_stdr_sn"));
				param.put("sn", MapUtils.getString(rqstMap, "ad_sn"));
		}

		List<Map> resultList = pgjs0020Dao.selectIndCdList(param);
		mv.addObject("indCdList", resultList);
		
		return mv;
	}

	/**
	 * 규모기준 등록/수정
	 * @param rqstMap 규모기준정보
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processScaleStdr(Map rqstMap) throws Exception {
		
		String sn = null;
		String stdrSn = null;
		HashMap param = null;
		
		// 0. 입력값 검증
		validateScaleStdr(rqstMap);
	
		// 등록/수정 구분
		String acType = MapUtils.getString(rqstMap, "ad_ac_type");
		
		// 1. 판정기준 등록/수정
		param = new HashMap();
		param.put("jdgmntStdrCl", STDRCL_SCALE);
		
		if (acType.equals("update")) stdrSn = MapUtils.getString(rqstMap, "ad_stdr_sn");
		else stdrSn = judgeStdrScaleGnrService.getNextStringId();
		
		param.put("stdrSn", stdrSn);
		param.put("applcBeginDe", MapUtils.getString(rqstMap, "ad_applc_begin_de"));
		param.put("applcEndDe", FIN_END_DE);
		param.put("dc", MapUtils.getString(rqstMap, "ad_dc"));
		pgjs0020Dao.insertJudgeStdr(param);
		
		String[] arrIsNew = (rqstMap.get("ad_isnew") instanceof String) ? new String[] {(String) rqstMap.get("ad_isnew")} : (String[]) rqstMap.get("ad_isnew");
		String[] arrSn = (rqstMap.get("ad_sn") instanceof String) ? new String[] {(String) rqstMap.get("ad_sn")} : (String[]) rqstMap.get("ad_sn");
		String[] arrOrdtmLabrrCoApplcAt = (rqstMap.get("ad_ordtm_labrr_co_applc_at") instanceof String) ? new String[] {(String) rqstMap.get("ad_ordtm_labrr_co_applc_at")} : (String[]) rqstMap.get("ad_ordtm_labrr_co_applc_at");
		String[] arrOrdtmLabrrCo = (rqstMap.get("ad_ordtm_labrr_co") instanceof String) ? new String[] {(String) rqstMap.get("ad_ordtm_labrr_co")} : (String[]) rqstMap.get("ad_ordtm_labrr_co");
		String[] arrCaplApplcAt = (rqstMap.get("ad_capl_applc_at") instanceof String) ? new String[] {(String) rqstMap.get("ad_capl_applc_at")} : (String[]) rqstMap.get("ad_capl_applc_at");
		String[] arrCapl =  (rqstMap.get("ad_capl") instanceof String) ? new String[] {(String) rqstMap.get("ad_capl")} : (String[]) rqstMap.get("ad_capl");
		String[] arrSelngAmApplcAt = (rqstMap.get("ad_selng_am_applc_at") instanceof String) ? new String[] {(String) rqstMap.get("ad_selng_am_applc_at")} : (String[]) rqstMap.get("ad_selng_am_applc_at");
		String[] arrSelngAm = (rqstMap.get("ad_selng_am") instanceof String) ? new String[] {(String) rqstMap.get("ad_selng_am")} : (String[]) rqstMap.get("ad_selng_am");
		String[] arrY3avgSelngAmApplcAt = (rqstMap.get("ad_y3avg_selng_am_applc_at") instanceof String) ? new String[] {(String) rqstMap.get("ad_y3avg_selng_am_applc_at")} : (String[]) rqstMap.get("ad_y3avg_selng_am_applc_at");
		String[] arrY3avgSelngAm = (rqstMap.get("ad_y3avg_selng_am") instanceof String) ? new String[] {(String) rqstMap.get("ad_y3avg_selng_am")} : (String[]) rqstMap.get("ad_y3avg_selng_am");
		String[] arrIndCd =  (rqstMap.get("ad_ind_cd") instanceof String) ? new String[] {(String) rqstMap.get("ad_ind_cd")} : (String[]) rqstMap.get("ad_ind_cd");
		
		for (int i=0; i<arrIsNew.length; i++) {
			// 2. 규모기준 등록/수정
			param = new HashMap();
			param.put("jdgmntStdrCl", STDRCL_SCALE);
			param.put("stdrSn", stdrSn);
			
			if (arrIsNew[i].equals("Y")) sn = pgjs0020Dao.getScaleStdrMaxSnPlus1(param); // 신규
			else sn = arrSn[i]; // 수정
			
			param.put("sn", sn);
			param.put("ordtmLabrrCoApplcAt", arrOrdtmLabrrCoApplcAt[i]);
			param.put("ordtmLabrrCo", arrOrdtmLabrrCo[i]);
			param.put("caplApplcAt", arrCaplApplcAt[i]);
			param.put("capl", arrCapl[i]);
			param.put("selngAmApplcAt", arrSelngAmApplcAt[i]);
			param.put("selngAm", arrSelngAm[i]);
			param.put("y3avgSelngAmApplcAt", arrY3avgSelngAmApplcAt[i]);
			param.put("y3avgSelngAm", arrY3avgSelngAm[i]);
			
			pgjs0020Dao.insertScaleStdr(param);
			
			// 3. 규모기준 업종삭제 후 등록
			param = new HashMap();
			param.put("jdgmntStdrCl", STDRCL_SCALE);
			param.put("stdrSn", stdrSn);
			param.put("sn", sn);
			
			pgjs0020Dao.deleteScaleStdrInduty(param);
			
			StringTokenizer token = new StringTokenizer(arrIndCd[i], ",");
			while (token.hasMoreTokens()) {
				String[] indCd = token.nextToken().split(":");
				
				param = new HashMap();
				param.put("jdgmntStdrCl", STDRCL_SCALE);
				param.put("stdrSn", stdrSn);
				param.put("sn", sn);
				param.put("indCd", indCd[0]);
				param.put("codeSe", indCd[1]);
				
				pgjs0020Dao.insertScaleStdrInduty(param);
			}
		}

		// 4. 최종 판정기준 적용만료일자 수정(단, 최초등록 시 제외)
		if (!MapUtils.getString(rqstMap, "ad_last_stdr_sn").equals("N")) {
			param = new HashMap();
			param.put("jdgmntStdrCl", STDRCL_SCALE);
			param.put("stdrSn", MapUtils.getString(rqstMap, "ad_last_stdr_sn"));
			param.put("applcEndDe", MapUtils.getString(rqstMap, "ad_last_applc_end_de"));
			pgjs0020Dao.updateLastJudgeStdrEndDe(param);
		}

		ModelAndView mv = index(rqstMap);
		// 처리결과 메시지 추가
		if (acType.equals("update")) mv.addObject("resultMsg", messageSource.getMessage("success.common.update", new String[] {"규모기준"}, Locale.getDefault()));
		else mv.addObject("resultMsg", messageSource.getMessage("success.common.insert", new String[] {"규모기준"}, Locale.getDefault()));

		return mv;
	}
	
	/**
	 * 상한기준 등록/수정 화면
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView formUplmtStdr(Map rqstMap) throws Exception {
		
		ModelAndView mv = new ModelAndView("/admin/js/BD_UIJSA0022");
		
		// 입력값 검증	
		validateJudgeStdr(rqstMap);
		
		HashMap param = new HashMap();
		param.put("jdgmntStdrCl", STDRCL_UPLMT);
		
		// 등록/수정 구분
		String acType = MapUtils.getString(rqstMap, "ad_ac_type");

		if (acType.equals("update") || acType.equals("view")) {
			
			param.put("stdrSn", MapUtils.getString(rqstMap, "ad_stdr_sn"));
			
			// 판정기준 상세정보 조회
			mv.addObject("judgeStdrInfo", pgjs0020Dao.selectJudgeStdr(param));
			
			// 상한기준 목록 조회
			mv.addObject("uplmtStdrInfo", pgjs0020Dao.selectUplmtStdr(param));
		}
		
		mv.addObject("lastJudgeStdrInfo", pgjs0020Dao.selectLastJudgeStdr(param));
		
		return mv;
	}
	
	/**
	 * 상한기준 등록/수정
	 * @param rqstMap 상한기준정보
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processUplmtStdr(Map rqstMap) throws Exception {
		
		String stdrSn = null;
		HashMap param = null;
		
		// 0. 입력값 검증
		validateUplmtStdr(rqstMap);
	
		// 등록/수정 구분
		String acType = MapUtils.getString(rqstMap, "ad_ac_type");
		
		// 1. 판정기준 등록/수정
		param = new HashMap();
		param.put("jdgmntStdrCl", STDRCL_UPLMT);
		
		if (acType.equals("update")) stdrSn = MapUtils.getString(rqstMap, "ad_stdr_sn");
		else stdrSn = judgeStdrUplmtGnrService.getNextStringId();
		
		param.put("stdrSn", stdrSn);
		param.put("applcBeginDe", MapUtils.getString(rqstMap, "ad_applc_begin_de"));
		param.put("applcEndDe", FIN_END_DE);
		param.put("dc", MapUtils.getString(rqstMap, "ad_dc"));
		pgjs0020Dao.insertJudgeStdr(param);
		
		// 2. 상한기준 등록/수정
		param = new HashMap();
		param.put("jdgmntStdrCl", STDRCL_UPLMT);
		param.put("stdrSn", stdrSn);
		param.put("ordtmLabrrCoApplcAt", MapUtils.getObject(rqstMap, "ad_ordtm_labrr_co_applc_at"));
		param.put("ordtmLabrrCo", MapUtils.getObject(rqstMap, "ad_ordtm_labrr_co"));
		param.put("assetsTotamtApplcAt", MapUtils.getObject(rqstMap, "ad_assets_totamt_applc_at"));
		param.put("assetsTotamt", MapUtils.getObject(rqstMap, "ad_assets_totamt"));
		param.put("ecptlApplcAt", MapUtils.getObject(rqstMap, "ad_ecptl_applc_at"));
		param.put("ecptl", MapUtils.getObject(rqstMap, "ad_ecptl"));
		param.put("y3avgSelngAmApplcAt", MapUtils.getObject(rqstMap, "ad_y3avg_selng_am_applc_at"));
		param.put("y3avgSelngAm", MapUtils.getObject(rqstMap, "ad_y3avg_selng_am"));
		
		if (acType.equals("update")) pgjs0020Dao.updateUplmtStdr(param);
		else pgjs0020Dao.insertUplmtStdr(param);

		// 3. 최종 판정기준 적용만료일자 수정(단, 최초등록 시 제외)
		if (!MapUtils.getString(rqstMap, "ad_last_stdr_sn").equals("N")) {
			param = new HashMap();
			param.put("jdgmntStdrCl", STDRCL_UPLMT);
			param.put("stdrSn", MapUtils.getString(rqstMap, "ad_last_stdr_sn"));
			param.put("applcEndDe", MapUtils.getString(rqstMap, "ad_last_applc_end_de"));
			pgjs0020Dao.updateLastJudgeStdrEndDe(param);
		}
		
		ModelAndView mv = index(rqstMap);
		// 처리결과 메시지 추가
		if (acType.equals("update")) mv.addObject("resultMsg", messageSource.getMessage("success.common.update", new String[] {"상한기준"}, Locale.getDefault()));
		else mv.addObject("resultMsg", messageSource.getMessage("success.common.insert", new String[] {"상한기준"}, Locale.getDefault()));

		return mv;
	}
	
	/**
	 * 독립성기준 등록/수정 화면
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView formIndpnStdr(Map rqstMap) throws Exception {
		
		ModelAndView mv = new ModelAndView("/admin/js/BD_UIJSA0023");

		// 입력값 검증	
		validateJudgeStdr(rqstMap);
		
		HashMap param = new HashMap();
		param.put("jdgmntStdrCl", STDRCL_INDPN);
		
		// 등록/수정 구분
		String acType = MapUtils.getString(rqstMap, "ad_ac_type");
		
		if (acType.equals("update") || acType.equals("view")) {
			param.put("stdrSn", MapUtils.getString(rqstMap, "ad_stdr_sn"));
			
			// 판정기준 상세정보 조회
			mv.addObject("judgeStdrInfo", pgjs0020Dao.selectJudgeStdr(param));
			
			// 독립성기준 목록 조회
			mv.addObject("indpnStdrInfo", pgjs0020Dao.selectIndpnStdr(param));
		}
		
		mv.addObject("lastJudgeStdrInfo", pgjs0020Dao.selectLastJudgeStdr(param));
		
		return mv;
	}
	
	/**
	 * 독립성기준 등록/수정
	 * @param rqstMap 독립성기준정보
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processIndpnStdr(Map rqstMap) throws Exception {
		
		String stdrSn = null;
		HashMap param = null;
		
		// 0. 입력값 검증
		validateIndpnStdr(rqstMap);
	
		// 등록/수정 구분
		String acType = MapUtils.getString(rqstMap, "ad_ac_type");
		
		// 1. 판정기준 등록/수정
		param = new HashMap();
		param.put("jdgmntStdrCl", STDRCL_INDPN);
		
		if (acType.equals("update")) stdrSn = MapUtils.getString(rqstMap, "ad_stdr_sn");
		else stdrSn = judgeStdrIndpnGnrService.getNextStringId();
		
		param.put("stdrSn", stdrSn);
		param.put("applcBeginDe", MapUtils.getString(rqstMap, "ad_applc_begin_de"));
		param.put("applcEndDe", FIN_END_DE);
		param.put("dc", MapUtils.getString(rqstMap, "ad_dc"));
		pgjs0020Dao.insertJudgeStdr(param);
		
		// 2. 독립성기준 등록/수정
		param = new HashMap();
		param.put("jdgmntStdrCl", STDRCL_INDPN);
		param.put("stdrSn", stdrSn);
		param.put("posesn30ApplcAt", MapUtils.getObject(rqstMap, "ad_posesn30_applc_at"));
		param.put("assetsTotamt", MapUtils.getObject(rqstMap, "ad_assets_totamt"));
		param.put("posesnQotaRt", MapUtils.getObject(rqstMap, "ad_posesn_qota_rt"));
		param.put("RcpyAdupQotaRtApplcAt", MapUtils.getObject(rqstMap, "ad_rcpy_adup_qota_rt_applc_at"));
		param.put("RcpyStdrQotaRt", MapUtils.getObject(rqstMap, "ad_rcpy_stdr_qota_rt"));
				
		if (acType.equals("update")) pgjs0020Dao.updateIndpnStdr(param);
		else pgjs0020Dao.insertIndpnStdr(param);

		// 3. 최종 판정기준 적용만료일자 수정(단, 최초등록 시 제외)
		if (!MapUtils.getString(rqstMap, "ad_last_stdr_sn").equals("N")) {
			param = new HashMap();
			param.put("jdgmntStdrCl", STDRCL_INDPN);
			param.put("stdrSn", MapUtils.getString(rqstMap, "ad_last_stdr_sn"));
			param.put("applcEndDe", MapUtils.getString(rqstMap, "ad_last_applc_end_de"));
			pgjs0020Dao.updateLastJudgeStdrEndDe(param);
		}

		ModelAndView mv = index(rqstMap);
		// 처리결과 메시지 추가
		if (acType.equals("update")) mv.addObject("resultMsg", messageSource.getMessage("success.common.update", new String[] {"독립성기준"}, Locale.getDefault()));
		else mv.addObject("resultMsg", messageSource.getMessage("success.common.insert", new String[] {"독립성기준"}, Locale.getDefault()));

		return mv;
	}
	
	/**
	 * 판정기준 입력값 검증
	 * @param rqstMap
	 * @throws Exception
	 */
	private void validateJudgeStdr(Map rqstMap) throws Exception {
		// 실행구분
		if (MapUtils.getString(rqstMap, "ad_ac_type", "").equals(""))
			throw processException("errors.required", new String[] { "실행구분" });

		// 수정 시 기준순번
		if (MapUtils.getString(rqstMap, "ad_ac_type").equals("update")
				&& MapUtils.getString(rqstMap, "ad_stdr_sn", "").equals(""))
			throw processException("errors.required", new String[] { "기준순번" });
		
		if (MapUtils.getString(rqstMap, "df_method_nm").startsWith("process")
				&& MapUtils.getString(rqstMap, "ad_last_stdr_sn", "").equals(""))
			throw processException("errors.required", new String[] { "최종기준 순번" });
		if (MapUtils.getString(rqstMap, "df_method_nm").startsWith("process")
				&& MapUtils.getString(rqstMap, "ad_last_applc_end_de", "").equals(""))
			throw processException("errors.required", new String[] { "최종기준 적용만료일자" });
		if (MapUtils.getString(rqstMap, "df_method_nm").startsWith("process")
				&& MapUtils.getString(rqstMap, "ad_applc_begin_de", "").equals(""))
			throw processException("errors.required", new String[] { "적용시작일자" });
		if (MapUtils.getString(rqstMap, "df_method_nm").startsWith("process")
				&& MapUtils.getString(rqstMap, "ad_dc", "").equals(""))
			throw processException("errors.required", new String[] { "설명" });
	}
	
	/**
	 * 규모기준 입력값 검증
	 * @param rqstMap
	 * @throws Exception
	 */
	private void validateScaleStdr(Map rqstMap) throws Exception {
		validateJudgeStdr(rqstMap);
		
		String[] arrIsNew = (rqstMap.get("ad_isnew") instanceof String) ? new String[] {(String) rqstMap.get("ad_isnew")} : (String[]) rqstMap.get("ad_isnew");
		String[] arrSn = (rqstMap.get("ad_sn") instanceof String) ? new String[] {(String) rqstMap.get("ad_sn")} : (String[]) rqstMap.get("ad_sn");
		String[] arrOrdtmLabrrCoApplcAt = (rqstMap.get("ad_ordtm_labrr_co_applc_at") instanceof String) ? new String[] {(String) rqstMap.get("ad_ordtm_labrr_co_applc_at")} : (String[]) rqstMap.get("ad_ordtm_labrr_co_applc_at");
		String[] arrOrdtmLabrrCo = (rqstMap.get("ad_ordtm_labrr_co") instanceof String) ? new String[] {(String) rqstMap.get("ad_ordtm_labrr_co")} : (String[]) rqstMap.get("ad_ordtm_labrr_co");
		String[] arrCaplApplcAt = (rqstMap.get("ad_capl_applc_at") instanceof String) ? new String[] {(String) rqstMap.get("ad_capl_applc_at")} : (String[]) rqstMap.get("ad_capl_applc_at");
		String[] arrCapl =  (rqstMap.get("ad_capl") instanceof String) ? new String[] {(String) rqstMap.get("ad_capl")} : (String[]) rqstMap.get("ad_capl");
		String[] arrSelngAmApplcAt = (rqstMap.get("ad_selng_am_applc_at") instanceof String) ? new String[] {(String) rqstMap.get("ad_selng_am_applc_at")} : (String[]) rqstMap.get("ad_selng_am_applc_at");
		String[] arrSelngAm = (rqstMap.get("ad_selng_am") instanceof String) ? new String[] {(String) rqstMap.get("ad_selng_am")} : (String[]) rqstMap.get("ad_selng_am");
		String[] arrY3avgSelngAmApplcAt = (rqstMap.get("ad_y3avg_selng_am_applc_at") instanceof String) ? new String[] {(String) rqstMap.get("ad_y3avg_selng_am_applc_at")} : (String[]) rqstMap.get("ad_y3avg_selng_am_applc_at");
		String[] arrY3avgSelngAm = (rqstMap.get("ad_y3avg_selng_am") instanceof String) ? new String[] {(String) rqstMap.get("ad_y3avg_selng_am")} : (String[]) rqstMap.get("ad_y3avg_selng_am");
		String[] arrIndCd =  (rqstMap.get("ad_ind_cd") instanceof String) ? new String[] {(String) rqstMap.get("ad_ind_cd")} : (String[]) rqstMap.get("ad_ind_cd");
		
		for (int i=0; i<arrIsNew.length; i++) {
			if (arrIsNew[i].equals("")) throw processException("errors.required", new String[] { "신규/수정구분" });
			if (arrSn[i].equals("")) throw processException("errors.required", new String[] { "순번" });
			if (arrOrdtmLabrrCoApplcAt[i].equals("")) throw processException("errors.required", new String[] { "상시근로자수적용여부" });
			if (arrOrdtmLabrrCo[i].equals("")) throw processException("errors.required", new String[] { "상시근로자수" });
			if (arrCaplApplcAt[i].equals("")) throw processException("errors.required", new String[] { "자본금적용여부" });
			if (arrCapl[i].equals("")) throw processException("errors.required", new String[] { "자본금" });
			if (arrSelngAmApplcAt[i].equals("")) throw processException("errors.required", new String[] { "매출액적용여부" });
			if (arrSelngAm[i].equals("")) throw processException("errors.required", new String[] { "매출액" });
			if (arrY3avgSelngAmApplcAt[i].equals("")) throw processException("errors.required", new String[] { "3년평균매출액적용여부" });
			if (arrY3avgSelngAm[i].equals("")) throw processException("errors.required", new String[] { "3년평균매출액" });
			if (arrIndCd[i].equals("")) throw processException("errors.required", new String[] { "업종코드" });
		}
	}
	
	/**
	 * 상한기준 입력값 검증
	 * @param rqstMap
	 * @throws Exception
	 */
	private void validateUplmtStdr(Map rqstMap) throws Exception {
		validateJudgeStdr(rqstMap);
		
		if (MapUtils.getString(rqstMap, "ad_ordtm_labrr_co_applc_at", "").equals(""))
			throw processException("errors.required", new String[] { "상시근로자수적용여부" });
		if (MapUtils.getString(rqstMap, "ad_ordtm_labrr_co", "").equals(""))
			throw processException("errors.required", new String[] { "상시근로자수" });
		if (MapUtils.getString(rqstMap, "ad_assets_totamt_applc_at", "").equals(""))
			throw processException("errors.required", new String[] { "자산총액적용여부" });
		if (MapUtils.getString(rqstMap, "ad_assets_totamt", "").equals(""))
			throw processException("errors.required", new String[] { "자산총액" });
		if (MapUtils.getString(rqstMap, "ad_ecptl_applc_at", "").equals(""))
			throw processException("errors.required", new String[] { "자기자본적용여부" });
		if (MapUtils.getString(rqstMap, "ad_ecptl", "").equals(""))
			throw processException("errors.required", new String[] { "자기자본" });
		if (MapUtils.getString(rqstMap, "ad_y3avg_selng_am_applc_at", "").equals(""))
			throw processException("errors.required", new String[] { "3년평균매출액적용여부" });
		if (MapUtils.getString(rqstMap, "ad_y3avg_selng_am", "").equals(""))
			throw processException("errors.required", new String[] { "3년평균매출액" });
	}
	
	/**
	 * 독립성기준 입력값 검증
	 * @param rqstMap
	 * @throws Exception
	 */
	private void validateIndpnStdr(Map rqstMap) throws Exception {
		validateJudgeStdr(rqstMap);
		
		if (MapUtils.getString(rqstMap, "ad_posesn30_applc_at", "").equals(""))
			throw processException("errors.required", new String[] { "직간접소유적용여부" });
		if (MapUtils.getString(rqstMap, "ad_assets_totamt", "").equals(""))
			throw processException("errors.required", new String[] { "자산총액" });
		if (MapUtils.getString(rqstMap, "ad_posesn_qota_rt", "").equals(""))
			throw processException("errors.required", new String[] { "소유지분율" });
		if (MapUtils.getString(rqstMap, "ad_rcpy_adup_qota_rt_applc_at", "").equals(""))
			throw processException("errors.required", new String[] { "관계기업합산지분율적용여부" });
		if (MapUtils.getString(rqstMap, "ad_rcpy_stdr_qota_rt", "").equals(""))
			throw processException("errors.required", new String[] { "관계기업기준지분율" });
	}
}
