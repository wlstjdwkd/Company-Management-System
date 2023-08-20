package biz.tech.js;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Date;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.comm.response.ExcelVO;
import com.comm.response.IExcelVO;
import com.comm.user.UserService;
import com.comm.user.UserVO;
import com.infra.file.FileDAO;
import com.infra.file.FileVO;
import com.infra.file.UploadHelper;
import com.infra.system.GlobalConst;
import com.infra.util.BizUtil;
import com.infra.util.JsonUtil;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.Validate;
import com.infra.util.crypto.Crypto;
import com.infra.util.crypto.CryptoFactory;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.js.PGJS0030Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 시스템판정처리 서비스 클래스
 * 
 * @author sujong
 * 
 */
@Service("PGJS0030")
public class PGJS0030Service extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGJS0030Service.class);

	@Resource(name = "PGJS0030Mapper")
	private PGJS0030Mapper pgjs0030Dao;

	@Resource(name="messageSource")
	private MessageSource messageSource;
	
	@Resource(name="filesDAO")
    private FileDAO fileDao;
	
	@Autowired
	UserService userService;
	
	/**
	 * 기준년도(기본 당해년도) 판정처리 정보 조회
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/js/BD_UIJSA0030");
		
		HashMap param = new HashMap();
		
		// 기준년도 목록 조회
		List<Map> stdyyList = pgjs0030Dao.selectStdyyList(param);
		
		mv.addObject("stdyyList", stdyyList);
			
		// 기준년도 검색 조건이 없으면 당해년도값 설정
		if (MapUtils.getString(rqstMap, "ad_searchStdyy", "").equals("")) {
			if (stdyyList != null && stdyyList.size() > 0) {
				param.put("stdyy", (String) stdyyList.get(0).get("stdyy"));
			}
		}
		else	param.put("stdyy", MapUtils.getString(rqstMap, "ad_searchStdyy"));
		
		// 기준년도
		mv.addObject("stdyy", MapUtils.getString(param, "stdyy"));
		// 판정기업 개수
		mv.addObject("jdgmntEntprsCount", pgjs0030Dao.selectJdgmntEntprsCount(param));
		// 최종 데이터 수집일자
		mv.addObject("lastDataCollectDate", pgjs0030Dao.selectLastDataCollectDate(param));
		// 시스템판정 요약정보
		mv.addObject("systemJdgmntManage", pgjs0030Dao.selectSystemJdgmntManage(param));
		// 확정판정 요약정보
		mv.addObject("dcsnJdgmntManage", pgjs0030Dao.selectDcsnJdgmntManage(param));
		
		return mv;
	}
	
	/**
	 * 판정기업 목록 조회
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectEntprsInfoList(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/js/BD_UIJSA0031");

		// 기준년도 필수 체크
		if (MapUtils.getString(rqstMap, "ad_stdyy", "").equals("")) {
			throw processException("errors.required", new String[] { "기준년도" });
		}
		
		HashMap param = new HashMap();

		// 검색조건
		param.put("stdyy", MapUtils.getString(rqstMap, "ad_stdyy"));
		param.put("searchKeyword", MapUtils.getString(rqstMap, "ad_searchKeyword", ""));
		param.put("searchCondition", MapUtils.getString(rqstMap, "ad_searchCondition", ""));
		param.put("searchGubun", MapUtils.getString(rqstMap, "ad_searchGubun", ""));

		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		int totalRowCnt = pgjs0030Dao.selectEntprsInfoListCountByHpe(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		mv.addObject("entprsList", pgjs0030Dao.selectEntprsInfoListByHpe(param));
		mv.addObject("pager", pager);
		
		return mv;
	}
	
	/**
	 * 판정상세 조회
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectDcsnJdgmntResn(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/js/PD_UIJSA0032");

		// 기준년도 필수 체크
		if (MapUtils.getString(rqstMap, "ad_stdyy", "").equals("")) {
			throw processException("errors.required", new String[] { "기준년도" });
		}
		// 기업관리코드 필수 체크
		if (MapUtils.getString(rqstMap, "ad_hpe_cd", "").equals("")) {
			throw processException("errors.required", new String[] { "기업관리코드" });
		}

		HashMap param = new HashMap();
		
		param.put("stdyy", MapUtils.getString(rqstMap, "ad_stdyy"));
		param.put("hpeCd", MapUtils.getString(rqstMap, "ad_hpe_cd"));
		
		mv.addObject("JdgmntResn", pgjs0030Dao.selectDcsnJdgmntResnByHpe(param));
		
		return mv;
	}
	
	/**
	 * 시스템판정 기업목록 엑셀 다운
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView excelSystemJdgmnt(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();

		HashMap param = new HashMap();
		if (!MapUtils.getString(rqstMap, "ad_stdyy", "").equals("")) {
			param.put("stdyy", MapUtils.getString(rqstMap, "ad_stdyy"));
		}
		
		// 자료년도 추출
		List<Map> yearList = pgjs0030Dao.selectStdyyList(param);
		
		Map yearInfo = null;
		String year = null;
		
		// 4개년도 데이터 추출
		for (int i=0; i<4; i++) {
			yearInfo = yearList.get(i);
			year = (String) yearInfo.get("stdyy");
			
			if (i == 0) param.put("stdyy", year);
			else if (i == 1) param.put("year1", year);
			else if (i == 2) param.put("year2", year);
			else if (i == 3) param.put("year3", year);
			else if (i > 3) break;
		}

		List<Map> xlsList = pgjs0030Dao.selectHpeSystemJdgmntDataList(param);
		
		// 타이틀
		ArrayList<String> headers = new ArrayList<String>(118);
		
		headers.add("자료기준년도");
		headers.add("HPE_CD");
		headers.add("법인번호");
		headers.add("사업자번호");
		headers.add("업체명");
		headers.add("기업공개형태");
		headers.add("설립일자");
		headers.add("휴폐업일자");
		headers.add("휴폐업여부");
		headers.add("시스템판정기업여부");
		headers.add("확인서발급여부");
		headers.add("확인서발급사유");
		headers.add("확정기업여부");
		headers.add("분석사용여부");
		headers.add("규모기준");
		headers.add("상한기준(천명)");
		headers.add("상한기준(자산)");
		headers.add("상한기준(자본)");
		headers.add("상한기준(3년평균)");
		headers.add("독립성기준(직접30%)");
		headers.add("독립성기준(간접30%)");
		headers.add("독립성기준(관계기업)");
		headers.add("상호출자");
		headers.add("금융업및보험업");
		headers.add("중소기업");
		headers.add("유예기업1");
		headers.add("유예기업2");
		headers.add("유예기업3");
		headers.add("제외법인");
		headers.add("외국계대기업");
		headers.add("경과조치");
		headers.add("산업코드중분류_"+yearList.get(0).get("stdyy"));
		headers.add("산업코드중분류_"+yearList.get(1).get("stdyy"));
		headers.add("산업코드중분류_"+yearList.get(2).get("stdyy"));
		headers.add("산업코드중분류_"+yearList.get(3).get("stdyy"));
		headers.add("상시근로자수_"+yearList.get(0).get("stdyy"));
		headers.add("상시근로자수_"+yearList.get(1).get("stdyy"));
		headers.add("상시근로자수_"+yearList.get(2).get("stdyy"));
		headers.add("상시근로자수_"+yearList.get(3).get("stdyy"));
		headers.add("자산총계_"+yearList.get(0).get("stdyy"));
		headers.add("자산총계_"+yearList.get(1).get("stdyy"));
		headers.add("자산총계_"+yearList.get(2).get("stdyy"));
		headers.add("자산총계_"+yearList.get(3).get("stdyy"));
		headers.add("자본+잉여금_"+yearList.get(0).get("stdyy"));
		headers.add("자본+잉여금_"+yearList.get(1).get("stdyy"));
		headers.add("자본+잉여금_"+yearList.get(2).get("stdyy"));
		headers.add("자본+잉여금_"+yearList.get(3).get("stdyy"));
		headers.add("자본총계_"+yearList.get(0).get("stdyy"));
		headers.add("자본총계_"+yearList.get(1).get("stdyy"));
		headers.add("자본총계_"+yearList.get(2).get("stdyy"));
		headers.add("자본총계_"+yearList.get(3).get("stdyy"));
		headers.add("매출액_"+yearList.get(0).get("stdyy"));
		headers.add("매출액_"+yearList.get(1).get("stdyy"));
		headers.add("매출액_"+yearList.get(2).get("stdyy"));
		headers.add("매출액_"+yearList.get(3).get("stdyy"));
		headers.add("BtoB");
		headers.add("BtoC");
		headers.add("BtoG");
		headers.add("외투여부");
		headers.add("수출액(달러화)_"+yearList.get(0).get("stdyy"));
		headers.add("수출액(달러화)_"+yearList.get(1).get("stdyy"));
		headers.add("수출액(달러화)_"+yearList.get(2).get("stdyy"));
		headers.add("수출액(달러화)_"+yearList.get(3).get("stdyy"));
		headers.add("수출액(달러화)_"+yearList.get(4).get("stdyy"));
		headers.add("수출액(달러화)_"+yearList.get(5).get("stdyy"));
		headers.add("수출액(달러화)_"+yearList.get(6).get("stdyy"));
		headers.add("수출액(달러화)_"+yearList.get(7).get("stdyy"));
		headers.add("수출액(달러화)_"+yearList.get(8).get("stdyy"));
		headers.add("수출액(달러화)_"+yearList.get(9).get("stdyy"));
		headers.add("국내특허등록권_"+yearList.get(0).get("stdyy"));
		headers.add("국내특허등록권_"+yearList.get(1).get("stdyy"));
		headers.add("국내특허등록권_"+yearList.get(2).get("stdyy"));
		headers.add("국내특허등록권_"+yearList.get(3).get("stdyy"));
		headers.add("국내특허등록권_"+yearList.get(4).get("stdyy"));
		headers.add("국내특허등록권_"+yearList.get(5).get("stdyy"));
		headers.add("국내특허등록권_"+yearList.get(6).get("stdyy"));
		headers.add("국내특허등록권_"+yearList.get(7).get("stdyy"));
		headers.add("국내특허등록권_"+yearList.get(8).get("stdyy"));
		headers.add("국내특허등록권_"+yearList.get(9).get("stdyy"));
		headers.add("국내출원특허권_"+yearList.get(0).get("stdyy"));
		headers.add("국내출원특허권_"+yearList.get(1).get("stdyy"));
		headers.add("국내출원특허권_"+yearList.get(2).get("stdyy"));
		headers.add("국내출원특허권_"+yearList.get(3).get("stdyy"));
		headers.add("국내출원특허권_"+yearList.get(4).get("stdyy"));
		headers.add("국내출원특허권_"+yearList.get(5).get("stdyy"));
		headers.add("국내출원특허권_"+yearList.get(6).get("stdyy"));
		headers.add("국내출원특허권_"+yearList.get(7).get("stdyy"));
		headers.add("국내출원특허권_"+yearList.get(8).get("stdyy"));
		headers.add("국내출원특허권_"+yearList.get(9).get("stdyy"));
		headers.add("실용신안권_"+yearList.get(0).get("stdyy"));
		headers.add("실용신안권_"+yearList.get(1).get("stdyy"));
		headers.add("실용신안권_"+yearList.get(2).get("stdyy"));
		headers.add("실용신안권_"+yearList.get(3).get("stdyy"));
		headers.add("실용신안권_"+yearList.get(4).get("stdyy"));
		headers.add("실용신안권_"+yearList.get(5).get("stdyy"));
		headers.add("실용신안권_"+yearList.get(6).get("stdyy"));
		headers.add("실용신안권_"+yearList.get(7).get("stdyy"));
		headers.add("실용신안권_"+yearList.get(8).get("stdyy"));
		headers.add("실용신안권_"+yearList.get(9).get("stdyy"));
		headers.add("디자인등록_"+yearList.get(0).get("stdyy"));
		headers.add("디자인등록_"+yearList.get(1).get("stdyy"));
		headers.add("디자인등록_"+yearList.get(2).get("stdyy"));
		headers.add("디자인등록_"+yearList.get(3).get("stdyy"));
		headers.add("디자인등록_"+yearList.get(4).get("stdyy"));
		headers.add("디자인등록_"+yearList.get(5).get("stdyy"));
		headers.add("디자인등록_"+yearList.get(6).get("stdyy"));
		headers.add("디자인등록_"+yearList.get(7).get("stdyy"));
		headers.add("디자인등록_"+yearList.get(8).get("stdyy"));
		headers.add("디자인등록_"+yearList.get(9).get("stdyy"));
		headers.add("상표권_"+yearList.get(0).get("stdyy"));
		headers.add("상표권_"+yearList.get(1).get("stdyy"));
		headers.add("상표권_"+yearList.get(2).get("stdyy"));
		headers.add("상표권_"+yearList.get(3).get("stdyy"));
		headers.add("상표권_"+yearList.get(4).get("stdyy"));
		headers.add("상표권_"+yearList.get(5).get("stdyy"));
		headers.add("상표권_"+yearList.get(6).get("stdyy"));
		headers.add("상표권_"+yearList.get(7).get("stdyy"));
		headers.add("상표권_"+yearList.get(8).get("stdyy"));
		headers.add("상표권_"+yearList.get(9).get("stdyy"));
		
		ArrayList<String> items = new ArrayList<String>(54);
		
		items.add("STDYY");
		items.add("HPE_CD");
		items.add("JURIRNO");
		items.add("BIZRNO");
		items.add("ENTRPRS_NM");
		items.add("ENTRPRS_OTHBC_STLE_NM");
		items.add("FOND_DE");
		items.add("SPCSS_DE");
		items.add("SPCSS_AT");
		items.add("SYS_HPE_AT");
		items.add("ISGN_AT");
		items.add("ISGN_NM");
		items.add("DCSN_HPE_AT");
		items.add("ANALS_USE_AT");
		items.add("SCALE_STDR");
		items.add("UPLMT_1000");
		items.add("UPLMT_ASSETS");
		items.add("UPLMT_CAPL");
		items.add("UPLMT_SELNG_3Y");
		items.add("INDPNDNCY_DIRECT_30");
		items.add("INDPNDNCY_INDRT_30");
		items.add("INDPNDNCY_RCPY");
		items.add("MTLTY_INVSTMNT_LMTT");
		items.add("FNCBIZ_ISCS");
		items.add("SMLPZ");
		items.add("POSTPNE_ENTRPRS1");
		items.add("POSTPNE_ENTRPRS2");
		items.add("POSTPNE_ENTRPRS3");
		items.add("EXCL_CPR");
		items.add("FRNTN_SM_LTRS");
		items.add("ELAPSE_MANAGT");
		items.add("CTGR_Y0");
		items.add("CTGR_Y1");
		items.add("CTGR_Y2");
		items.add("CTGR_Y3");
		items.add("LABRR_Y0");
		items.add("LABRR_Y1");
		items.add("LABRR_Y2");
		items.add("LABRR_Y3");
		items.add("ASSET_Y0");
		items.add("ASSET_Y1");
		items.add("ASSET_Y2");
		items.add("ASSET_Y3");
		items.add("GLD_Y0");
		items.add("GLD_Y1");
		items.add("GLD_Y2");
		items.add("GLD_Y3");
		items.add("CAPL_Y0");
		items.add("CAPL_Y1");
		items.add("CAPL_Y2");
		items.add("CAPL_Y3");
		items.add("SELNG_Y0");
		items.add("SELNG_Y1");
		items.add("SELNG_Y2");
		items.add("SELNG_Y3");
		//items.add("B2B_ENTRPRS_AT");
		//items.add("B2C_ENTRPRS_AT");
		//items.add("B2G_ENTRPRS_AT");
		//items.add("FNSY_AT");
		
		String[] arryHeaders = new String[] {};
		String[] arryItems = new String[] {};
		arryHeaders = headers.toArray(arryHeaders);
		arryItems = items.toArray(arryItems);
		
		mv.addObject("_headers", arryHeaders);
		mv.addObject("_items", arryItems);
		mv.addObject("_list", xlsList);
		
		IExcelVO excel = new ExcelVO("자료출력기준_"+yearList.get(0).get("stdyy")+"년_기업시스템판정결과");

		return ResponseUtil.responseExcel(mv, excel);
	}
	
	/**
	 * 첨부파일 삭제
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView deleteAttchFile(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		// 기준년도 필수 체크
		if (MapUtils.getString(rqstMap, "ad_stdyy", "").equals("")) {
			return ResponseUtil.responseJson(mv, false, messageSource.getMessage("errors.required", new String[] {"기준년도"}, Locale.getDefault()));
		}
		// 기업관리코드 필수 체크
		if (MapUtils.getString(rqstMap, "ad_hpe_cd", "").equals("")) {
			return ResponseUtil.responseJson(mv, false, messageSource.getMessage("errors.required", new String[] {"기업관리코드"}, Locale.getDefault()));
		}
		// 파일번호 필수 체크
		if (MapUtils.getString(rqstMap, "ad_file_seq", "").equals("")) {
			return ResponseUtil.responseJson(mv, false, messageSource.getMessage("errors.required", new String[] {"FILE_SEQ"}, Locale.getDefault()));
		}

		HashMap param = new HashMap();
		param.put("stdyy", MapUtils.getString(rqstMap, "ad_stdyy"));
		param.put("hpeCd", MapUtils.getString(rqstMap, "ad_hpe_cd"));
		
		// 파일정보 삭제
		pgjs0030Dao.updateSetNullAttachFileInfo(param);
		
		// 파일삭제
		fileDao.removeFile(MapUtils.getInteger(rqstMap, "ad_file_seq"));
				
		return ResponseUtil.responseJson(mv, true, messageSource.getMessage("success.common.delete", new String[] {"첨부파일"}, Locale.getDefault()));
	}
	
	/**
	 * 기업 확정사유 등록
	 * @param rqstMap 확정사유 정보
	 * @return
	 * @throws Exception
	 */
	public ModelAndView insertDcsnJdgmntResn(Map<?, ?> rqstMap) throws Exception {

		int fileSeq = -1;
		
		// 기준년도 필수 체크
		if (MapUtils.getString(rqstMap, "ad_stdyy", "").equals("")) {
			throw processException("errors.required", new String[] {"기준년도"});
		}
		// 기업관리코드 필수 체크
		if (MapUtils.getString(rqstMap, "ad_hpe_cd", "").equals("")) {
			throw processException("errors.required", new String[] {"기업관리코드"});
		}
		// 확정판정
		if (MapUtils.getString(rqstMap, "ad_dcsnHpeAt", "").equals("")) {
			throw processException("errors.required", new String[] {"확정판정"});
		}
		// 판정사유
		if ((MapUtils.getString(rqstMap, "ad_dcsnHpeAt").equals("Y") && MapUtils.getString(rqstMap, "ad_resn_Y", "").equals(""))
				|| (MapUtils.getString(rqstMap, "ad_dcsnHpeAt").equals("N") && MapUtils.getString(rqstMap, "ad_resn_N", "").equals(""))) {
			throw processException("errors.required", new String[] { "판정사유" });
		}
		// 설명
		if (MapUtils.getString(rqstMap, "ad_basisDc", "").equals("")) {
			throw processException("errors.required", new String[] {"기업관리코드"});
		}

		HashMap param = new HashMap();
		
		//파일업로드
		List<FileVO> fileList = new ArrayList<FileVO>();
		MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) MapUtils.getObject(rqstMap, GlobalConst.RQST_MULTIPART);
		List<MultipartFile> multiFiles = multiRequest.getFiles("ad_attachFile");
		
		// 첨부파일 있으면 저장처리
		if(Validate.isNotEmpty(multiFiles)) {
			fileList = UploadHelper.upload(multiFiles, "resnJdgmnt");
			
			if(Validate.isNotEmpty(fileList)) {
		    	fileSeq = fileDao.saveFile(fileList, -1);
				param.put("fileNm", fileList.get(0).getLocalNm());
				param.put("fileSn", fileSeq);
			}
		}

		param.put("stdyy", MapUtils.getString(rqstMap, "ad_stdyy"));
		param.put("hpeCd", MapUtils.getString(rqstMap, "ad_hpe_cd"));
		param.put("dcsnHpeAt", MapUtils.getString(rqstMap, "ad_dcsnHpeAt"));
		param.put("basisDc", MapUtils.getString(rqstMap, "ad_basisDc"));
		
		if (MapUtils.getString(rqstMap, "ad_dcsnHpeAt").equals("Y")) param.put("resnCd", MapUtils.getString(rqstMap, "ad_resn_Y"));
		else param.put("resnCd", MapUtils.getString(rqstMap, "ad_resn_N"));
		
		pgjs0030Dao.updateHpeDcsnJdgmnt(param);
		pgjs0030Dao.insertHpeDcsnJdgmntResn(param);
		
		ModelAndView mv = selectDcsnJdgmntResn(rqstMap);
		mv.addObject("resultMsg", messageSource.getMessage("success.common.insert", new String[] {"확정판정 및 판정사유"}, Locale.getDefault()));
		
		return mv;
	}
	
	/**
	 * 기업 확정자료 처리
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processDcsnUploadFile(Map<?,?> rqstMap) throws Exception {
		int result = -1;
		
		if (MapUtils.getString(rqstMap, "ad_stdyy", "").equals("")) {
			throw processException("errors.required", new String[] {"기준년도"});
		}
		
		HashMap param = new HashMap();
		// 자료기준년도 설정
		param.put("stdyy", MapUtils.getString(rqstMap, "ad_stdyy"));
		
		Map<String,Object> paramdata = null;
		ModelAndView mv = new ModelAndView();
		List<Map<String,Object>> resultList = null;
		
		// 자료년도 추출
		List<Map> yearList = pgjs0030Dao.selectStdyyList(param);
		
		String[] columNames = 
		     {
				"자료기준년도"
				,"HPE_CD"
				,"법인번호"
				,"사업자번호"
				,"시스템판정기업여부"
				,"확인서발급여부"
				,"확정기업여부"
				,"분석사용여부"
				,"규모기준"
				,"상한기준(천명)"
				,"상한기준(자산)"
				,"상한기준(자본)"
				,"상한기준(3년평균)"
				,"독립성기준(직접30%)"
				,"독립성기준(간접30%)"
				,"독립성기준(관계기업)"
				,"상호출자"
				,"금융업및보험업"
				,"중소기업"
				,"유예기업1"
				,"유예기업2"
				,"유예기업3"
				,"제외법인"
				,"외국계대기업"
				,"경과조치"
				,"BtoB"
				,"BtoC"
				,"BtoG"
				,"외투여부"
				,"수출액(달러화)_" + yearList.get(0).get("stdyy")
				,"수출액(달러화)_" + yearList.get(1).get("stdyy")
				,"수출액(달러화)_" + yearList.get(2).get("stdyy")
				,"수출액(달러화)_" + yearList.get(3).get("stdyy")
				,"수출액(달러화)_" + yearList.get(4).get("stdyy")
				,"수출액(달러화)_" + yearList.get(5).get("stdyy")
				,"수출액(달러화)_" + yearList.get(6).get("stdyy")
				,"수출액(달러화)_" + yearList.get(7).get("stdyy")
				,"수출액(달러화)_" + yearList.get(8).get("stdyy")
				,"수출액(달러화)_" + yearList.get(9).get("stdyy")
				,"국내특허등록권_" + yearList.get(0).get("stdyy")
				,"국내특허등록권_" + yearList.get(1).get("stdyy")
				,"국내특허등록권_" + yearList.get(2).get("stdyy")
				,"국내특허등록권_" + yearList.get(3).get("stdyy")
				,"국내특허등록권_" + yearList.get(4).get("stdyy")
				,"국내특허등록권_" + yearList.get(5).get("stdyy")
				,"국내특허등록권_" + yearList.get(6).get("stdyy")
				,"국내특허등록권_" + yearList.get(7).get("stdyy")
				,"국내특허등록권_" + yearList.get(8).get("stdyy")
				,"국내특허등록권_" + yearList.get(9).get("stdyy")
				,"국내출원특허권_" + yearList.get(0).get("stdyy")
				,"국내출원특허권_" + yearList.get(1).get("stdyy")
				,"국내출원특허권_" + yearList.get(2).get("stdyy")
				,"국내출원특허권_" + yearList.get(3).get("stdyy")
				,"국내출원특허권_" + yearList.get(4).get("stdyy")
				,"국내출원특허권_" + yearList.get(5).get("stdyy")
				,"국내출원특허권_" + yearList.get(6).get("stdyy")
				,"국내출원특허권_" + yearList.get(7).get("stdyy")
				,"국내출원특허권_" + yearList.get(8).get("stdyy")
				,"국내출원특허권_" + yearList.get(9).get("stdyy")
				,"실용신안권_" + yearList.get(0).get("stdyy")
				,"실용신안권_" + yearList.get(1).get("stdyy")
				,"실용신안권_" + yearList.get(2).get("stdyy")
				,"실용신안권_" + yearList.get(3).get("stdyy")
				,"실용신안권_" + yearList.get(4).get("stdyy")
				,"실용신안권_" + yearList.get(5).get("stdyy")
				,"실용신안권_" + yearList.get(6).get("stdyy")
				,"실용신안권_" + yearList.get(7).get("stdyy")
				,"실용신안권_" + yearList.get(8).get("stdyy")
				,"실용신안권_" + yearList.get(9).get("stdyy")
				,"디자인등록_" + yearList.get(0).get("stdyy")
				,"디자인등록_" + yearList.get(1).get("stdyy")
				,"디자인등록_" + yearList.get(2).get("stdyy")
				,"디자인등록_" + yearList.get(3).get("stdyy")
				,"디자인등록_" + yearList.get(4).get("stdyy")
				,"디자인등록_" + yearList.get(5).get("stdyy")
				,"디자인등록_" + yearList.get(6).get("stdyy")
				,"디자인등록_" + yearList.get(7).get("stdyy")
				,"디자인등록_" + yearList.get(8).get("stdyy")
				,"디자인등록_" + yearList.get(9).get("stdyy")
				,"상표권_" + yearList.get(0).get("stdyy")
				,"상표권_" + yearList.get(1).get("stdyy")
				,"상표권_" + yearList.get(2).get("stdyy")
				,"상표권_" + yearList.get(3).get("stdyy")
				,"상표권_" + yearList.get(4).get("stdyy")
				,"상표권_" + yearList.get(5).get("stdyy")
				,"상표권_" + yearList.get(6).get("stdyy")
				,"상표권_" + yearList.get(7).get("stdyy")
				,"상표권_" + yearList.get(8).get("stdyy")
				,"상표권_" + yearList.get(9).get("stdyy")
		     };
			 String[] columparam = 
			 {
					 "STDYY"
						,"HPE_CD"
						,"JURIRNO"
						,"BIZRNO"
						,"SYS_HPE_AT"
						,"ISGN_AT"
						,"DCSN_HPE_AT"
						,"ANALS_USE_AT"
						,"SCALE_STDR"
						,"UPLMT_1000"
						,"UPLMT_ASSETS"
						,"UPLMT_CAPL"
						,"UPLMT_SELNG_3Y"
						,"INDPNDNCY_DIRECT_30"
						,"INDPNDNCY_INDRT_30"
						,"INDPNDNCY_RCPY"
						,"MTLTY_INVSTMNT_LMTT"
						,"FNCBIZ_ISCS"
						,"SMLPZ"
						,"POSTPNE_ENTRPRS1"
						,"POSTPNE_ENTRPRS2"
						,"POSTPNE_ENTRPRS3"
						,"EXCL_CPR"
						,"FRNTN_SM_LTRS"
						,"ELAPSE_MANAGT"
						,"B2B_ENTRPRS_AT"
						,"B2C_ENTRPRS_AT"
						,"B2G_ENTRPRS_AT"
						,"FNSY_AT"
						,"XPORT_AM_DOLLAR_Y0"
						,"XPORT_AM_DOLLAR_Y1"
						,"XPORT_AM_DOLLAR_Y2"
						,"XPORT_AM_DOLLAR_Y3"
						,"XPORT_AM_DOLLAR_Y4"
						,"XPORT_AM_DOLLAR_Y5"
						,"XPORT_AM_DOLLAR_Y6"
						,"XPORT_AM_DOLLAR_Y7"
						,"XPORT_AM_DOLLAR_Y8"
						,"XPORT_AM_DOLLAR_Y9"
						,"DMSTC_PATENT_REGIST_VLM_Y0"
						,"DMSTC_PATENT_REGIST_VLM_Y1"
						,"DMSTC_PATENT_REGIST_VLM_Y2"
						,"DMSTC_PATENT_REGIST_VLM_Y3"
						,"DMSTC_PATENT_REGIST_VLM_Y4"
						,"DMSTC_PATENT_REGIST_VLM_Y5"
						,"DMSTC_PATENT_REGIST_VLM_Y6"
						,"DMSTC_PATENT_REGIST_VLM_Y7"
						,"DMSTC_PATENT_REGIST_VLM_Y8"
						,"DMSTC_PATENT_REGIST_VLM_Y9"
						,"DMSTC_APLC_PATNTRT_Y0"
						,"DMSTC_APLC_PATNTRT_Y1"
						,"DMSTC_APLC_PATNTRT_Y2"
						,"DMSTC_APLC_PATNTRT_Y3"
						,"DMSTC_APLC_PATNTRT_Y4"
						,"DMSTC_APLC_PATNTRT_Y5"
						,"DMSTC_APLC_PATNTRT_Y6"
						,"DMSTC_APLC_PATNTRT_Y7"
						,"DMSTC_APLC_PATNTRT_Y8"
						,"DMSTC_APLC_PATNTRT_Y9"
						,"UTLMDLRT_Y0"
						,"UTLMDLRT_Y1"
						,"UTLMDLRT_Y2"
						,"UTLMDLRT_Y3"
						,"UTLMDLRT_Y4"
						,"UTLMDLRT_Y5"
						,"UTLMDLRT_Y6"
						,"UTLMDLRT_Y7"
						,"UTLMDLRT_Y8"
						,"UTLMDLRT_Y9"
						,"DSNREG_Y0"
						,"DSNREG_Y1"
						,"DSNREG_Y2"
						,"DSNREG_Y3"
						,"DSNREG_Y4"
						,"DSNREG_Y5"
						,"DSNREG_Y6"
						,"DSNREG_Y7"
						,"DSNREG_Y8"
						,"DSNREG_Y9"
						,"TRDMKRT_Y0"
						,"TRDMKRT_Y1"
						,"TRDMKRT_Y2"
						,"TRDMKRT_Y3"
						,"TRDMKRT_Y4"
						,"TRDMKRT_Y5"
						,"TRDMKRT_Y6"
						,"TRDMKRT_Y7"
						,"TRDMKRT_Y8"
						,"TRDMKRT_Y9"
			 };
			 
			Date startTime = new Date ( );
			 
			MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)rqstMap.get(GlobalConst.RQST_MULTIPART);
			
			if( Validate.isEmpty(mptRequest) )
				return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!.\"}");
			
			List<MultipartFile> multipartFiles = mptRequest.getFiles("hpeDcsnFile");
			if(Validate.isEmpty(multipartFiles)) 
				return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!.\"}");
			
			if(multipartFiles.get(0).isEmpty()) 
				return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!.\"}");
			
			List<FileVO> fileList = new ArrayList<FileVO>();
			fileList = UploadHelper.upload(multipartFiles, "dscntemp");
			
			if(fileList.size() != 1)
			{
				return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"Upload 파일에 에러가 있습니다!\"}");
			}
			
			resultList = BizUtil.paserExcelFile(columNames,columparam,fileList.get(0).getFile(),0);
		
		try {

			// 이전 데이터 삭제
			pgjs0030Dao.deleteHpeDcsnJdgmntData(param);
			
			int k = 0;
			// 임시테이블에 업로드 데이터 저장
			for(Map dcsnData : resultList) {
				pgjs0030Dao.insertHpeDcsnJdgmntData(dcsnData);
				logger.debug("--------- chk insertHpeDcsnJdgmntData count : " + k);
				
				k ++;
			}
			
			// 판정처리 프로시져 호출
			param.put("mode", 'C');
			result = pgjs0030Dao.callDcsnJdgmnt(param);
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
			throw processException("fail.common.insert", new String[] { "기업 확정자료" });
		}

		mv = index(rqstMap);
		
		if (result == 0) {
			mv.addObject("resultMsg", messageSource.getMessage("success.request.msg", new String[] {}, Locale.getDefault()));
		} else {
			mv.addObject("resultMsg", messageSource.getMessage("fail.common.sql", new String[] {String.valueOf(result), "확정판정SP 오류"}, Locale.getDefault()));
		}

		return mv;
	}
	
	/**
	 * 기업 판정자료 삭제
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processDeleteData(Map<?,?> rqstMap) throws Exception {
		
		if (MapUtils.getString(rqstMap, "ad_stdyy", "").equals("")) {
			throw processException("errors.required", new String[] {"기준년도"});
		}
		
		HashMap param = new HashMap();
		// 자료기준년도 설정
		param.put("stdyy", MapUtils.getString(rqstMap, "ad_stdyy"));
		param.put("mode", 'D');
		
		// 판정처리 프로시져 호출
		int result = pgjs0030Dao.callDcsnJdgmnt(param);

		ModelAndView mv = index(rqstMap);

		if (result == 0) {
			mv.addObject("resultMsg", messageSource.getMessage("success.request.msg", new String[] {}, Locale.getDefault()));
		} else {
			mv.addObject("resultMsg", messageSource.getMessage("fail.common.sql", new String[] {String.valueOf(result), "확정판정SP 오류"}, Locale.getDefault()));
		}
		
		return mv;
	}
	
	/**
	 * 기업 판정처리
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processSystemJdgmnt(Map<?,?> rqstMap) throws Exception {
		
		// 기준년도 필수 체크
		if (MapUtils.getString(rqstMap, "ad_stdyy", "").equals("")) {
			throw processException("errors.required", new String[] {"기준년도"});
		}
		
		// 기업군구분 필수 체크
		if (MapUtils.getString(rqstMap, "ad_gubun", "").equals("")) {
			throw processException("errors.required", new String[] {"기업군구분"});
		}
		
		HashMap param = new HashMap();
		
		param.put("gubun", MapUtils.getString(rqstMap, "ad_gubun"));
		param.put("stdyy", MapUtils.getString(rqstMap, "ad_stdyy"));
		param.put("stdym", MapUtils.getString(rqstMap, "ad_stdyy").concat("03"));
		param.put("avgYear", Integer.valueOf(3));
		param.put("contAt", MapUtils.getString(rqstMap, "ad_contat"));//확인서발급기업 정보를 통계로 이동한다 
		
		int result = pgjs0030Dao.callSystemJdgmnt(param);
		
		ModelAndView mv = index(rqstMap);
		
		if (result == 0) {
			mv.addObject("resultMsg", messageSource.getMessage("success.request.msg", new String[] {}, Locale.getDefault()));
		} else {
			mv.addObject("resultMsg", messageSource.getMessage("fail.common.sql", new String[] {String.valueOf(result), "시스템판정SP 오류"}, Locale.getDefault()));
		}

		return mv;
	}
	
	/**
	 * 관리자 비밀번호 확인 화면
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView adminPwdForm(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/js/PD_UIJSA0040");
		return mv;
	}
	
	/**
	 * 관리자 비밀번호 확인 처리
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView adminPwdConfirm(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map jsonMap = new HashMap();
		
		UserVO uservo = SessionUtil.getUserInfo();
		String loginId = uservo.getLoginId();
		String loginPw = MapUtils.getString(rqstMap, "regPwd","");
		
		
		if (StringUtils.isEmpty(loginId)||StringUtils.isEmpty(loginPw)) {
			jsonMap.put("result", "fail");
			return ResponseUtil.responseJson(mv, false, jsonMap);
		}

		// PASSWORD 암호화
		byte pszDigest[] = new byte[32];		
		Crypto cry = CryptoFactory.getInstance("SHA256");
		pszDigest =cry.encryptTobyte(loginPw);
				
		HashMap<String, Object> param = new HashMap();
		param.put("loginId", loginId);
		param.put("loginPw", pszDigest);
		param.put("checkSttus", "01");
		
		// 사용자 조회
		UserVO userVo = userService.findUser(param);
		
		if (userVo == null) {
			jsonMap.put("result", "fail");
			return ResponseUtil.responseJson(mv, false, jsonMap);
		}
		if (userVo.getLoginAt().equals("N")) {
			jsonMap.put("result", "fail");
			return ResponseUtil.responseJson(mv, false, jsonMap);
		}
		
		return ResponseUtil.responseJson(mv, true, jsonMap);
	}
	
	/**
	 * 기업 확정판정 판정자료 백업
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView callBackData(Map<?,?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		
		String base_year = MapUtils.getString(rqstMap, "ad_searchStdyy");
		param.put("base_year", base_year);
		
		int result = pgjs0030Dao.callDataBackup(param);
		
		ModelAndView mv = index(rqstMap);

		if (result == 0) {
			mv.addObject("resultMsg", messageSource.getMessage("success.request.msg", new String[] {}, Locale.getDefault()));
		} else {
			mv.addObject("resultMsg", messageSource.getMessage("fail.common.sql", new String[] {String.valueOf(result), "확정판정SP 오류"}, Locale.getDefault()));
		}
		
		return mv;
		
	}
}
