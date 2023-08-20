package biz.tech.js;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.comm.response.ExcelVO;
import com.comm.response.IExcelVO;
import com.infra.file.FileVO;
import com.infra.file.UploadHelper;
import com.infra.system.GlobalConst;
import com.infra.util.BizUtil;
import com.infra.util.ResponseUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.js.PGJS0040Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 관계기업판정처리 서비스 클래스
 * 
 * @author HSC
 * 
 */
@Service("PGJS0040")
public class PGJS0040Service extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGJS0040Service.class);

	@Resource(name = "PGJS0040Mapper")
	private PGJS0040Mapper pgjs0040Dao;
	
	@Resource(name="messageSource")
	private MessageSource messageSource;
	
	/**
	 * 기준년도(기본 당해년도) 관계기업판정처리 정보 조회
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/js/BD_UIJSA0040");
		
		HashMap param = new HashMap();
		
		// 기준년도 목록 조회
		List<Map> stdyyList = pgjs0040Dao.selectStdyyList(param);
		mv.addObject("stdyyList", stdyyList);
		
		// 기준년도 검색 조건이 없으면 당해년도값 설정
		if (MapUtils.getString(rqstMap, "ad_searchStdyy", "").equals("")) {
			if (stdyyList != null && stdyyList.size() > 0) {
				param.put("stdyy", (String) stdyyList.get(0).get("stdyy"));
			}
		} else	{
			param.put("stdyy", MapUtils.getString(rqstMap, "ad_searchStdyy"));
		}
		
		// 관계기업판정 수집내역 조회
		Map rcpyJdgmntColctInfo = pgjs0040Dao.selectTbRcpyJdgmntColct(param);
		mv.addObject("rcpyJdgmntColctInfo", rcpyJdgmntColctInfo);
		
		// 관계기업판정관리 조회
		Map rcpyJdgmntManageInfo = pgjs0040Dao.selectTbRcpyJdgmntManage(param);
		mv.addObject("rcpyJdgmntManageInfo", rcpyJdgmntManageInfo);
		
		// 기준년도
		mv.addObject("stdyy", MapUtils.getString(param, "stdyy"));
		
		return mv;
	}
	
	/**
	 * 관계기업 엑셀 파일 업로드 처리
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processRcpyUploadFile(Map<?,?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		
		List<FileVO> fileList = new ArrayList<FileVO>();
		
		List<Map<String,Object>> resultList = null;
		
		int result = -1;
		
		ModelAndView mv = new ModelAndView();
		
		int k = 0;
		
		String[] columNames =
			{
				"대상기업법인등록번호"
				,"대상기업명"
				,"대상기업관리코드_NICE"
				,"대상기업업종코드"
				,"대상기업설립일자"
				,"대상기업결산일"
				,"대상기업자산총액"
				,"대상기업매출액1"
				,"대상기업매출액2"
				,"대상기업매출액3"
				,"대상기업매출액4"
				,"대상기업매출액5"
				,"대상기업매출액6"
				,"지분관계기업법인등록번호"
				,"지분관계기업명"
				,"지분관계기업설립일자"
				,"지분관계기업지분율"
				,"지분관계기업외국법인여부"
				,"지분관계기업자산총액"
				,"지분관계기업매출액1"
				,"지분관계기업매출액2"
				,"지분관계기업매출액3"
				,"지분관계기업매출액4"
				,"지분관계기업매출액5"
				,"지분관계기업매출액6"
			};
		
		String[] columParams =
			{
				"TRGET_ENTRPRS_JURIRNO"
				,"TRGET_ENTRPRS_NM"
				,"TRGET_ENTRPRS_CODE_NICE"
				,"TRGET_ENTRPRS_INDUTY_CODE"
				,"TRGET_ENTRPRS_FOND_DE"
				,"TRGET_ENTRPRS_PSACNT"
				,"TRGET_ENTRPRS_ASSETS_TOTAMT"
				,"TRGET_ENTRPRS_SELNG_AM1"
				,"TRGET_ENTRPRS_SELNG_AM2"
				,"TRGET_ENTRPRS_SELNG_AM3"
				,"TRGET_ENTRPRS_SELNG_AM4"
				,"TRGET_ENTRPRS_SELNG_AM5"
				,"TRGET_ENTRPRS_SELNG_AM6"
				,"QOTA_RELATE_ENTRPRS_JURIRNO"
				,"QOTA_RELATE_ENTRPRS_NM"
				,"QOTA_RELATE_ENTRPRS_FOND_DE"
				,"QOTA_RELATE_ENTRPRS_QOTA_RT"
				,"QOTA_RELATE_ENTRPRS_FRNP_AT"
				,"QOTA_RELATE_ENTRPRS_ASSETS_TOTAMT"
				,"QOTA_RELATE_ENTRPRS_SELNG_AM1"
				,"QOTA_RELATE_ENTRPRS_SELNG_AM2"
				,"QOTA_RELATE_ENTRPRS_SELNG_AM3"
				,"QOTA_RELATE_ENTRPRS_SELNG_AM4"
				,"QOTA_RELATE_ENTRPRS_SELNG_AM5"
				,"QOTA_RELATE_ENTRPRS_SELNG_AM6"
			};
		
		// 기준년도 필수 체크
		if (MapUtils.getString(rqstMap, "ad_stdyy", "").equals("")) {
			throw processException("errors.required", new String[] {"기준년도"});
		}
		
		MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)rqstMap.get(GlobalConst.RQST_MULTIPART);
		if(Validate.isEmpty(mptRequest)) {
			logger.debug("-------------- ERROR : mptRequest");
			return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!.\"}");
		}
		
		List<MultipartFile> multipartFiles = mptRequest.getFiles("file_rcpy");
		if(Validate.isEmpty(multipartFiles)) {
			logger.debug("-------------- ERROR : multipartFiles");
			return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!.\"}");
		}
		if(multipartFiles.get(0).isEmpty()) {
			logger.debug("-------------- ERROR : isEmpty");
			return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!.\"}");
		}
		
		fileList = UploadHelper.upload(multipartFiles, "rcpytemp");
		if(fileList.size() != 1) {
			logger.debug("-------------- ERROR : size");
			return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"Upload 파일에 에러가 있습니다!\"}");
		}
		
		// 자료기준년도 설정
		param.put("stdyy", MapUtils.getString(rqstMap, "ad_stdyy"));
		
		resultList = BizUtil.paserExcelFile(columNames, columParams, fileList.get(0). getFile(), 0);
		
		try {
			// 관계기업판정관리 삭제(엑셀 파일 업로드)
			pgjs0040Dao.deleteTbRcpyJdgmntManage(param);
			// 관계기업판정 수집내역 삭제(엑셀 파일 업로드)
			pgjs0040Dao.deleteTbRcpyJdgmntColct(param);
			// 관계기업판정결과 삭제(엑셀 파일 업로드)
			pgjs0040Dao.deleteTbRcpyJdgmntResult(param);
			// 임시관계기업판정결과 삭제(엑셀 파일 업로드)
			pgjs0040Dao.deleteTmpRcpyJdgmntResult();
			// 관계기업판정기업정보 삭제(엑셀 파일 업로드)
			pgjs0040Dao.deleteTbRcpyJdgmntEntrprsInfo(param);
			// 관계기업판정자료 삭제(엑셀 파일 업로드)
			pgjs0040Dao.deleteTbRcpyJdgmntDta(param);
			// 임시관계기업판정업로드자료 삭제(엑셀 파일 업로드)
			pgjs0040Dao.deleteTmpRcpyJdgmntUploadDta();
			
			// 임시테이블에 업로드 데이터 저장
			for(Map dcsnData : resultList) {
				// 임시관계기업판정업로드자료 추가(엑셀 파일 업로드)
				pgjs0040Dao.insertTmpRcpyJdgmntUploadDta(dcsnData);
				
				k ++;
				logger.debug("--------- chk insertTmpRcpyData Count : " + k);
			}
			
			param.put("trgetEntrprsCo", k);
			
			// 관계기업판정자료 추가(엑셀 파일 업로드)
			pgjs0040Dao.insertTbRcpyJdgmntDta(param);
			
			// 관계기업판정기업정보 추가(엑셀 파일 업로드)
			pgjs0040Dao.insertTbRcpyJdgmntEntrprsInfo(param);
			
			// 적용업종선택
			if (MapUtils.getString(rqstMap, "ad_induty", "NICE").equals("KED")) {
				// 관계기업판정기업정보 갱신(기업데이터 업종코드로 변경)(엑셀 파일 업로드)
				pgjs0040Dao.updateTbRcpyJdgmntEntrprsInfo(param);
			}
			
			// 관계기업판정기업정보 갱신(3년평균매출액1 계산)(엑셀 파일 업로드)
			pgjs0040Dao.updateTbRcpyJdgmntEntrprsInfo2(param);
			// 관계기업판정기업정보 갱신(3년평균매출액2 계산)(엑셀 파일 업로드)
			pgjs0040Dao.updateTbRcpyJdgmntEntrprsInfo3(param);
			// 관계기업판정기업정보 갱신(3년평균매출액3 계산)(엑셀 파일 업로드)
			pgjs0040Dao.updateTbRcpyJdgmntEntrprsInfo4(param);
			// 관계기업판정기업정보 갱신(3년평균매출액4 계산)(엑셀 파일 업로드)
			pgjs0040Dao.updateTbRcpyJdgmntEntrprsInfo5(param);
			
			// 관계기업판정 수집내역 추가(엑셀 파일 업로드)
			pgjs0040Dao.insertTbRcpyJdgmntColct(param);
			
			// 관계기업판정관리 추가(엑셀 파일 업로드)
			pgjs0040Dao.insertTbRcpyJdgmntManage(param);
			
			result = 0;
		} catch (Exception e) {
			logger.error(e.toString(), e);
			throw processException("fail.common.insert", new String[] { "관계기업 데이터" });
		}
		
		mv = index(rqstMap);
		
		if (result == 0) {
			mv.addObject("resultMsg", messageSource.getMessage("success.request.msg", new String[] {}, Locale.getDefault()));
		} else {
			mv.addObject("resultMsg", messageSource.getMessage("fail.common.sql", new String[] {String.valueOf(result), "관계기업 업로드 오류"}, Locale.getDefault()));
		}
		
		return mv;
	}
	
	/**
	 * 관계기업 판정처리
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processRcpyJdgmnt(Map<?,?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		
		// 기준년도 필수 체크
		if (MapUtils.getString(rqstMap, "ad_stdyy", "").equals("")) {
			throw processException("errors.required", new String[] {"기준년도"});
		}
		// 자료기준년도 설정
		param.put("stdyy", MapUtils.getString(rqstMap, "ad_stdyy"));
		
		// 관계기업 판정
		int result = pgjs0040Dao.callRcpyJdgmnt(param);
		
		ModelAndView mv = index(rqstMap);
		
		if (result == 0) {
			mv.addObject("resultMsg", messageSource.getMessage("success.request.msg", new String[] {}, Locale.getDefault()));
		} else {
			mv.addObject("resultMsg", messageSource.getMessage("fail.common.sql", new String[] {String.valueOf(result), "관계기업 판정 오류"}, Locale.getDefault()));
		}
		
		return mv;
	}
	
	/**
	 * 관계기업판정목록 조회
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectRcpyJdgmntList(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/js/BD_UIJSA0041");

		// 기준년도 필수 체크
		if (MapUtils.getString(rqstMap, "ad_stdyy", "").equals("")) {
			throw processException("errors.required", new String[] { "기준년도" });
		}
		
		HashMap param = new HashMap();
		
		// 검색조건
		param.put("stdyy", MapUtils.getString(rqstMap, "ad_stdyy"));
		param.put("searchCondition", MapUtils.getString(rqstMap, "ad_searchCondition", ""));
		param.put("searchKeyword", MapUtils.getString(rqstMap, "ad_searchKeyword", ""));
		param.put("searchGubun", MapUtils.getString(rqstMap, "ad_searchGubun", ""));
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		int totalRowCnt = pgjs0040Dao.selectTbRcpyJdgmntEntrprsInfoCnt(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		mv.addObject("entrprsList", pgjs0040Dao.selectTbRcpyJdgmntEntrprsInfoList(param));
		mv.addObject("pager", pager);
		
		return mv;
	}
	
	/**
	 * 관계기업판정상세보기 조회
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectRcpyJdgmntInfo(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/js/PD_UIJSA0042");

		// 기준년도 필수 체크
		if (MapUtils.getString(rqstMap, "ad_stdyy", "").equals("")) {
			throw processException("errors.required", new String[] { "기준년도" });
		}
		
		// 기준년도 목록 조회
		HashMap param = new HashMap();
		
		param.put("stdyy", MapUtils.getString(rqstMap, "ad_stdyy"));
		param.put("entrprsJurirno", MapUtils.getString(rqstMap, "ad_entrprsJurirno"));
		
		Map rcpyJdgmntInfo = pgjs0040Dao.selectTbRcpyJdgmntDetail(param);
		mv.addObject("rcpyJdgmntInfo", rcpyJdgmntInfo);
		
		List<Map> rcpyJdgmntUpperInfo = pgjs0040Dao.selectTbRcpyJdgmntUpperDetail(param);
		mv.addObject("rcpyJdgmntUpperInfo", rcpyJdgmntUpperInfo);
		
		List<Map> rcpyJdgmntLwprtInfo = pgjs0040Dao.selectTbRcpyJdgmntLwprtDetail(param);
		mv.addObject("rcpyJdgmntLwprtInfo", rcpyJdgmntLwprtInfo);
	
		return mv;
	}
	
	/**
	 * 사용자 목록 Excel 다운로드
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView excelDownDddList (Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		// 기준년도 필수 체크
		if (MapUtils.getString(rqstMap, "ad_stdyy", "").equals("")) {
			throw processException("errors.required", new String[] { "기준년도" });
		}
		
		HashMap param = new HashMap();

		param.put("stdyy", MapUtils.getString(rqstMap, "ad_stdyy"));
		
		ObjectMapper mapper = new ObjectMapper();		
		
		// Excel 용 Map 생성
		List<Map> entrprsList = mapper.convertValue(pgjs0040Dao.selectTbRcpyJdgmntEntrprsInfoListExcel(param), new TypeReference<List<Map>>() {});
		
		mv.addObject("_list", entrprsList);
		
		String stdyyStr = MapUtils.getString(rqstMap, "ad_stdyy");
		int stdyyInt = Integer.parseInt(stdyyStr);
		String stdyyStr1 = Integer.toString(stdyyInt);
		String stdyyStr2 = Integer.toString(stdyyInt - 1);
		String stdyyStr3 = Integer.toString(stdyyInt - 2);
		String stdyyStr4 = Integer.toString(stdyyInt - 3);
		
		String[] headers = {
			"기준년",
			"법인등록번호",
			"기업명",
			"관계기업여부",
			"금융업여부" ,
			stdyyStr1 + "년 확정기업여부",
			stdyyStr2 + "년 확정기업여부",
			stdyyStr3 + "년 확정기업여부",
			stdyyStr4 + "년 확정기업여부",
			"기업업종코드",
			"매출액1",
			"매출액2",
			"매출액3",
			"매출액4",
			"매출액5",
			"매출액6",
			"3년평균매출액1",
			"3년평균매출액2",
			"3년평균매출액3",
			"3년평균매출액4",
			"판정업종코드",
			"합산매출액",
			"2단계 구분",
			"2단계 법인등록번호",
			"2단계 기업명",
			"2단계 지분율",
			"2단계 기업업종코드",
			"2단계 3년평균매출액",
			"3단계 구분",
			"3단계 법인등록번호",
			"3단계 기업명",
			"3단계 지분율",
			"3단계 기업업종코드",
			"3단계 3년평균매출액"
        };
		
        String[] items = {
        	"stdyy",
        	"entrprsJurirno",
        	"entrprsNm",
        	"rcpyScaleYn",
        	"entrprsK",
        	"dcsnHpeAt1",
        	"dcsnHpeAt2",
        	"dcsnHpeAt3",
        	"dcsnHpeAt4",
        	"entrprsIndutyCode",
        	"entrprsSelngAm1",
        	"entrprsSelngAm2",
        	"entrprsSelngAm3",
        	"entrprsSelngAm4",
        	"entrprsSelngAm5",
        	"entrprsSelngAm6",
        	"y3avgSelngAm1",
        	"y3avgSelngAm2",
        	"y3avgSelngAm3",
        	"y3avgSelngAm4",
        	"jdgmntIndutyCode",
        	"adupSelngAm",
        	"lev2Gubun",
        	"lev2Jurirno",
        	"lev2Nm",
        	"lev2QotaRt",
        	"lev2IndutyCode",
        	"lev2Y3avgSelngAm1",
        	"lev3Gubun",
        	"lev3Jurirno",
        	"lev3Nm",
        	"lev3QotaRt",
        	"lev3IndutyCode",
        	"lev3Y3avgSelngAm1"
        };
        
        mv.addObject("_headers", headers);
        mv.addObject("_items", items);
        
        IExcelVO excel = new ExcelVO(stdyyStr + "년도 관계기업판정결과");
		
		return ResponseUtil.responseExcel(mv, excel);
	}
}
