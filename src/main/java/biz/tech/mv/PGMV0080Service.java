package biz.tech.mv;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.code.CodeService;
import com.infra.util.JsonUtil;
import com.infra.util.ResponseUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.my.ApplyMapper;
import biz.tech.mapif.my.EmpmnMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 고객지원 > 채용정보
 * 
 * @author KMY
 *
 */
@Service("PGMV0080")
public class PGMV0080Service extends EgovAbstractServiceImpl{

	private static final Logger logger = LoggerFactory.getLogger(PGMV0080Service.class);
	
	@Autowired
	private EmpmnMapper empmnDAO;
	
	@Autowired
	CodeService codeService;
	
	@Resource(name="applyMapper")
	private ApplyMapper applyMapper;
	
	/**
	 * 채용정보 리스트화면
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<?,?> rqstMap) throws Exception {
		Map<String,Object> param = new HashMap<String,Object>();
		Map result = new HashMap();
		ModelAndView mv = new ModelAndView();
		String empmnNo;
		String userNo;
		String bizrNo;
		
		
		String temp = null;
		param.put("ad_select", "a");
		result = applyMapper.findFilter(param);
		if( result != null) {
			temp = result.get("ATRB").toString();
			String[] array_filterListA = temp.split(",");
			param.put("array_filterListA", array_filterListA);	// xml에서 사용될 배열
			param.put("tempA", temp);
		}
		param.put("ad_select", "b");
		result = applyMapper.findFilter(param);
		if( result != null) {
			temp = result.get("ATRB").toString();
			String[] array_filterListB = temp.split(",");
			param.put("array_filterListB", array_filterListB);	// xml에서 사용될 배열
			param.put("tempB", temp);
		}
		param.put("ad_select", "c");
		result = applyMapper.findFilter(param);
		if( result != null) {
			String stringfilterListC = result.get("ATRB").toString();
			param.put("stringfilterListC", stringfilterListC);	// xml에서 사용될 배열
		}
		
		String moreList = MapUtils.getString(rqstMap, "ad_moreList");
		String search_area = MapUtils.getString(rqstMap,"search_zone");
		String search_jssfc = MapUtils.getString(rqstMap, "search_jssfc");
				
		// 지역
		param.put("search_area",search_area);
		param.put("code", search_area);
		param.put("codeGroupNo", 22);
		result = codeService.findCodeInfo(param);
		if(result != null) {
			String search_area_NM = result.get("codeNm").toString();
			param.put("search_area_NM", search_area_NM);
			if(search_area == "WA10") {
				param.put("search_area_NM", "경상남도");	
			}
			else if(search_area == "WA11") {
				param.put("search_area_NM", "경상북도");
			}
			else if(search_area == "WA12") {
				param.put("search_area_NM", "전라남도");
			}
			else if(search_area == "WA13") {
				param.put("search_area_NM", "전라북도");
			}
			else if(search_area == "WA14") {
				param.put("search_area_NM", "충청북도");
			}
			else if(search_area == "WA15") {
				param.put("search_area_NM", "충청남도");
			}
		}
		
		
		
		logger.debug(search_jssfc);

		param.put("search_jssfc", search_jssfc);
		
		
		// 전체 게시글 수
		int totalRowCnt = empmnDAO.findEmpmnPblancInfoCount(param);
		param.put("cnt", totalRowCnt);
		
		// 첫화면 리스트
		if(Validate.isEmpty(moreList)) {
			param.put("limitFrom", 0);
			param.put("limitTo", 10);
			
		}
		else {
			String ad_ajax = MapUtils.getString(rqstMap, "ad_ajax");
			
			// 더보기 버튼을 눌렀을 때
			if(Validate.isNotEmpty(ad_ajax)) {
				int limitFrom = MapUtils.getIntValue(rqstMap, "ad_limitFrom");
				param.put("limitFrom", limitFrom);
				param.put("limitTo", 10);
				
				// 채용공고 리스트 조회
				List<Map> empmnPblancInfo = empmnDAO.findEmpmnPblancInfoList(param);
				
				// 항목관리 데이터를 dataList에 추가한다.
				if(Validate.isNotEmpty(empmnPblancInfo)) {			
					for(Map row : empmnPblancInfo) {
						empmnNo = MapUtils.getString(row, "EMPMN_MANAGE_NO", "");
						userNo = MapUtils.getString(row, "EP_NO");
						bizrNo = MapUtils.getString(row, "BIZRNO");
						
						param.put("EMPMN_MANAGE_NO", empmnNo);
						param.put("USER_NO", userNo);
						param.put("BIZRNO", bizrNo);
						param.put("PBLANC_IEM", "25"); // 경력
						row.put("iem25", empmnDAO.findEmpmnItem(param));
						row.put("ChartrList", empmnDAO.selectCmpnyIntrcnChartr(param));
						row.put("paramLimitTo", limitFrom+10);
					}
				}
				
				return ResponseUtil.responseJson(mv, true, empmnPblancInfo);
			}
			/*else {
				int limitFrom = MapUtils.getIntValue(rqstMap, "ad_limitFrom");
				param.put("limitFrom", limitFrom);
				param.put("limitTo", totalRowCnt);
				
				// 채용공고 리스트 조회
				List<Map> empmnPblancInfo = empmnDAO.findEmpmnPblancInfoList(param);
				
				// 항목관리 데이터를 dataList에 추가한다.
				if(Validate.isNotEmpty(empmnPblancInfo)) {			
					for(Map row : empmnPblancInfo) {
						empmnNo = MapUtils.getString(row, "EMPMN_MANAGE_NO", "");
						param.put("EMPMN_MANAGE_NO", empmnNo);
						param.put("PBLANC_IEM", "25"); // 경력
						row.put("iem25", empmnDAO.findEmpmnItem(param));
					}
				}
				
				mv.addObject("inparam", param);
				mv.addObject("empmnPblancInfo", empmnPblancInfo);
				mv.setViewName("/mobile/mv/BD_UIMVU0080");
				return mv;
			}*/
		}
		
		// 채용공고 리스트 조회
		List<Map> empmnPblancInfo = empmnDAO.findEmpmnPblancInfoList(param);
		
		// 항목관리 데이터를 dataList에 추가한다.
		if(Validate.isNotEmpty(empmnPblancInfo)) {			
			for(Map row : empmnPblancInfo) {
				empmnNo = MapUtils.getString(row, "EMPMN_MANAGE_NO", "");
				userNo = MapUtils.getString(row, "EP_NO");
				bizrNo = MapUtils.getString(row, "BIZRNO");
				
				param.put("EMPMN_MANAGE_NO", empmnNo);
				param.put("USER_NO", userNo);
				param.put("BIZRNO", bizrNo);
				param.put("PBLANC_IEM", "25"); // 경력
				row.put("iem25", empmnDAO.findEmpmnItem(param));
				row.put("ChartrList", empmnDAO.selectCmpnyIntrcnChartr(param));
			}
		}
		
		// 지역 리스트 조회
		param.put("codeGroupNo", 22);
		List<Map> abrvList = codeService.findCodeList(param);
		
		// 직종 목록 조회
		mv.addObject("jssfcLargeList", empmnDAO.selectJssfcLargeList());
		
		mv.addObject("abrvList", abrvList);
		mv.addObject("inparam", param);
		mv.addObject("empmnPblancInfo", empmnPblancInfo);
		mv.setViewName("/mobile/mv/BD_UIMVU0080");
		return mv;
	}
	
	/**
	 * 채용공고 상세조회
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView empmnInfoForm(Map<?,?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		ModelAndView mv = new ModelAndView();
		String empmnNo2;
		String userNo2;
		String bizrNo2;
		
		String empmnManageNo = MapUtils.getString(rqstMap, "ad_empmnManageNo");
		String userNo = MapUtils.getString(rqstMap, "ad_userNo");
		
		param.put("EMPMN_MANAGE_NO", empmnManageNo);
		param.put("USER_NO", userNo);
		
		// 채용공고 상세조회
		Map empmnPblancInfo = empmnDAO.findEmpmnPblancInfo(param);
		
		param.put("BIZRNO", MapUtils.getString(empmnPblancInfo, "BIZRNO"));		
		// 채용공고 기업조회
		Map companyInfo = empmnDAO.findCmpnyIntrcnInfo(param);
		
		// 이전글 조회
		Map preList = empmnDAO.findPreList(param);
		// 다음글 조회
		Map nextList = empmnDAO.findNextList(param);
		
		if(Validate.isNotNull(preList)) {
			empmnPblancInfo.put("preList", preList);
		}
		
		if(Validate.isNotNull(nextList)) {
			empmnPblancInfo.put("nextList", nextList);
		}
		
		Map fmtTelNum = StringUtil.telNumFormat(MapUtils.getString(companyInfo, "TELNO", ""));		// 전화번호
		
		empmnPblancInfo.put("telNo1", MapUtils.getString(fmtTelNum, "first",""));
		empmnPblancInfo.put("telNo2", MapUtils.getString(fmtTelNum, "middle",""));
		empmnPblancInfo.put("telNo3", MapUtils.getString(fmtTelNum, "last",""));
		
		if(Validate.isNotEmpty(empmnPblancInfo)) {
			// 채용공고 항목관리 조회
			param.put("PBLANC_IEM", "33"); // 근무형태
			empmnPblancInfo.put("iem33", empmnDAO.findEmpmnItem(param));
			param.put("PBLANC_IEM", "25"); // 경력
			empmnPblancInfo.put("iem25", empmnDAO.findEmpmnItem(param));
			param.put("PBLANC_IEM", "27"); // 학력
			empmnPblancInfo.put("iem27", empmnDAO.findEmpmnItem(param));
			param.put("PBLANC_IEM", "51"); // 모집인원
			empmnPblancInfo.put("iem51", empmnDAO.findEmpmnItem(param));
			param.put("PBLANC_IEM", "79");
			empmnPblancInfo.put("iem79", empmnDAO.findEmpmnItem(param));
			param.put("PBLANC_IEM", "52"); // 나이
			empmnPblancInfo.put("iem52", empmnDAO.findEmpmnItem(param));
			param.put("PBLANC_IEM", "22"); // 근무지역
			empmnPblancInfo.put("iem22", empmnDAO.findEmpmnItem(param));
			param.put("PBLANC_IEM", "31"); // 모집직급
			empmnPblancInfo.put("iem31", empmnDAO.findEmpmnItem(param));
			param.put("PBLANC_IEM", "32"); // 모집직책
			empmnPblancInfo.put("iem32", empmnDAO.findEmpmnItem(param));
		}	
		
		param.put("EMPMN_MANAGE_NO", MapUtils.getString(empmnPblancInfo, "EMPMN_MANAGE_NO"));
       	param.put("USER_NO", MapUtils.getString(empmnPblancInfo, "USER_NO"));
       	param.put("BIZRNO", MapUtils.getString(empmnPblancInfo, "BIZRNO"));
		
       	//현 기업 다른 채용공고들
       	List<Map> diffInfoList = empmnDAO.findEmpmnPblancCurInfoList(param);
       	if(Validate.isNotEmpty(diffInfoList)) {			
			for(Map row : diffInfoList) {
				empmnNo2 = MapUtils.getString(row, "EMPMN_MANAGE_NO", "");
				userNo2 = MapUtils.getString(row, "EP_NO");
				bizrNo2 = MapUtils.getString(row, "BIZRNO");
				
				param.put("EMPMN_MANAGE_NO", empmnNo2);
				param.put("USER_NO", userNo2);
				param.put("BIZRNO", bizrNo2);
				param.put("PBLANC_IEM", "25"); // 경력
				row.put("iem25", empmnDAO.findEmpmnItem(param));
			}
       	}
		mv.addObject("diffInfoList", diffInfoList);
		
		mv.addObject("companyInfo", companyInfo);	
		mv.addObject("empmnPblancInfo", empmnPblancInfo);
		mv.setViewName("/mobile/mv/BD_UIMVU0081");
		return mv;
	}
	
	/**
	 * 채용기업 상세조회
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView cmpnyInfoForm(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		Map<String,Object> param = new HashMap<String,Object>();
		Map<String,Object> dataMap = new HashMap<String,Object>();
		
		String empmnNo2;
		String userNo2;
		String bizrNo2;

		String userNo = MapUtils.getString(rqstMap, "ad_userNo");
		String bizrNo = MapUtils.getString(rqstMap, "ad_bizrNo");
		
		param.put("USER_NO", userNo);
		param.put("BIZRNO", bizrNo);
		
		dataMap = empmnDAO.findCmpnyIntrcnInfo(param);
		
		// 전화번호 파싱
		if(Validate.isNotEmpty(dataMap)) {
			Map<String, String> fmtTelNum = StringUtil.telNumFormat(MapUtils.getString(dataMap, "TELNO", ""));		
			Map<String, String> fmtFxnum = StringUtil.telNumFormat(MapUtils.getString(dataMap, "FXNUM", ""));	
					
			//전화번호
			dataMap.put("TELNO1", MapUtils.getString(fmtTelNum, "first", ""));
			dataMap.put("TELNO2", MapUtils.getString(fmtTelNum, "middle", ""));
			dataMap.put("TELNO3", MapUtils.getString(fmtTelNum, "last", ""));	
			//팩스번호
			dataMap.put("FXNUM1", MapUtils.getString(fmtFxnum, "first", ""));
			dataMap.put("FXNUM2", MapUtils.getString(fmtFxnum, "middle", ""));
			dataMap.put("FXNUM3", MapUtils.getString(fmtFxnum, "last", ""));
		}
		
		// 홈페이지 주소
		String hmpgAddr = MapUtils.getString(dataMap, "HMPG");
		if(Validate.isNotEmpty(hmpgAddr)) {
			hmpgAddr.startsWith("");
			if(!hmpgAddr.startsWith("http://") && !hmpgAddr.startsWith("https://")) {
				dataMap.put("HMPG", "http://" + hmpgAddr);
			}
		}
		
		// 주요지표현황 조회
		param.put("ENTRPRS_USER_NO", userNo);
		List<Map> indexList = empmnDAO.findEmpmnIndexInfo(param);
		List<int[]> labrrDatas = new ArrayList<int[]>();	//근로자수
		List<int[]> selngDatas = new ArrayList<int[]>();	//매출액
		List<int[]> caplDatas = new ArrayList<int[]>();		//자본금
		List<int[]> assetsDatas = new ArrayList<int[]>();	//자산총액

		int[] tempArr = null;
		
		for(Map yearBydata : indexList) {
			tempArr = new int[2];
			tempArr[0] = MapUtils.getIntValue(yearBydata, "STDYY");
			tempArr[1] = MapUtils.getIntValue(yearBydata, "ORDTM_LABRR_CO");	// 상시근로자수
			labrrDatas.add(tempArr);
			tempArr = new int[2];
			tempArr[0] = MapUtils.getIntValue(yearBydata, "STDYY");
			tempArr[1] = MapUtils.getIntValue(yearBydata, "SELNG_AM");			// 매출액
			selngDatas.add(tempArr);
			tempArr = new int[2];
			tempArr[0] = MapUtils.getIntValue(yearBydata, "STDYY");
			tempArr[1] = MapUtils.getIntValue(yearBydata, "CAPL");				// 자본금
			caplDatas.add(tempArr);
			tempArr = new int[2];
			tempArr[0] = MapUtils.getIntValue(yearBydata, "STDYY");
			tempArr[1] = MapUtils.getIntValue(yearBydata, "ASSETS_SM");			// 자산총액
			assetsDatas.add(tempArr);
		}
		
		mv.addObject("chartr", empmnDAO.selectCmpnyIntrcnChartr(param));
		
		//채용공고 리스트
		List<Map> empmnInfoList = empmnDAO.findEmpmnPblancCurInfoList(param);
		if(Validate.isNotEmpty(empmnInfoList)) {			
			for(Map row : empmnInfoList) {
				empmnNo2 = MapUtils.getString(row, "EMPMN_MANAGE_NO", "");
				userNo2 = MapUtils.getString(row, "EP_NO");
				bizrNo2 = MapUtils.getString(row, "BIZRNO");
				
				param.put("EMPMN_MANAGE_NO", empmnNo2);
				param.put("USER_NO", userNo2);
				param.put("BIZRNO", bizrNo2);
				param.put("PBLANC_IEM", "25"); // 경력
				row.put("iem25", empmnDAO.findEmpmnItem(param));
			}
       	}
		mv.addObject("empmnInfoList", empmnInfoList);
		// 이미지 리스트
		mv.addObject("layoutImageList",empmnDAO.findCmpnyIntrcnLayoutList(param));
		// 텍스트 리스트
		//mv.addObject("layoutTextList",empmnDAO.findCmpnyIntrcnLayoutTextList(param));
		
		// 주요지표 데이터
		mv.addObject("jipyo",indexList);
		mv.addObject("labrrDatas", JsonUtil.toJson(labrrDatas));
		mv.addObject("selngDatas", JsonUtil.toJson(selngDatas));
		mv.addObject("caplDatas", JsonUtil.toJson(caplDatas));
		mv.addObject("assetsDatas", JsonUtil.toJson(assetsDatas));
		mv.addObject("existChartData", Validate.isNotEmpty(indexList));
		
		mv.addObject("dataMap", dataMap);
		
		mv.setViewName("/mobile/mv/BD_UIMVU0082");
		return mv;
	}
}
