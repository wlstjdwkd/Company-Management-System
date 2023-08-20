package com.comm.program;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.code.CodeService;
import com.comm.page.Pager;
import com.comm.program.ProgramService;
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
 * 프로그램 관리
 * 
 * @author KMY
 * 
 */
@Service("PGCMPGM0030")
public class PGCMPGM0030Service extends EgovAbstractServiceImpl
{
	private static final Logger logger = LoggerFactory.getLogger(PGCMPGM0030Service.class);

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;

	@Autowired
	ProgramService programService;
	
	@Autowired
	CodeService codeService;

	/**
	 * 프로그램관리
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index (Map<?, ?> rqstMap) throws Exception
	{
		HashMap param = new HashMap();
		
		int df_curr_page = MapUtils.getIntValue(rqstMap, "df_curr_page");											
		int df_row_per_page = MapUtils.getIntValue(rqstMap, "df_row_per_page");								
		
		String searchJobSe = MapUtils.getString(rqstMap, "searchJobSe");
		String searchProgramNm = MapUtils.getString(rqstMap, "searchProgramNm");
		
		// 업무구분
		param.put("searchJobSe", searchJobSe);
		// 프로그램명
		param.put("searchProgramNm", searchProgramNm);
		
		// 총 프로그램 갯수
		int totalPgCnt = programService.findProgramListCnt(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(df_curr_page).totalRowCount(totalPgCnt).rowSize(df_row_per_page).build();
		pager.makePaging();
		int pagerNo = pager.getIndexNo();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());

		// 프로그램 정보 find
		List<Map> programList = programService.findProgramList(param);
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("pager", pager);
		mv.addObject("pagerNo", pagerNo);
		
		mv.addObject("programList", programList);
		//mv.setViewName("/admin/ms/BD_UIMSA0030");
		mv.setViewName("/admin/comm/pgm/BD_UICMPGMA0030");
		
		return mv;
	}
	
	// 등록 창 띄우기
	public ModelAndView programRegist(Map<?,?> rqstMap) throws Exception
	{
		HashMap param = new HashMap();
		HashMap codeInfo = new HashMap();
		
		int df_curr_page = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int df_row_per_page = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		int limitFrom = MapUtils.getIntValue(rqstMap, "limitFrom");
		int limitTo = MapUtils.getIntValue(rqstMap, "limitTo");
		String searchJobSe = MapUtils.getString(rqstMap, "searchJobSe");
		
		param.put("df_curr_page", df_curr_page);
		param.put("df_row_per_page", df_row_per_page);
		param.put("searchJobSe", searchJobSe);
		param.put("limitFrom", limitFrom);
		param.put("limitTo", limitTo);
		
		codeInfo.put("codeGroupNo", "2");

		ModelAndView mv = new ModelAndView();
		mv.addObject("param", param);
		// 업무구분 코드 불러오기
		mv.addObject("codeList", codeService.findCodeList(codeInfo));
		
		//mv.setViewName("/admin/ms/BD_UIMSA0031");
		mv.setViewName("/admin/comm/pgm/BD_UICMPGMA0031");
		return mv;
		
	}

	// 수정/삭제 View 띄우기
	public ModelAndView programModify(Map<?, ?> rqstMap) throws Exception
	{
		HashMap param = new HashMap();
		HashMap indexValue = new HashMap();
		HashMap codeInfo = new HashMap();
		
		String searchJobSe = MapUtils.getString(rqstMap, "searchJobSe");
		String searchProgramNm = MapUtils.getString(rqstMap, "searchProgramNm");
		int df_curr_page = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int df_row_per_page = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		int limitFrom = MapUtils.getIntValue(rqstMap, "limitFrom");
		int limitTo = MapUtils.getIntValue(rqstMap, "limitTo");
		
		String progrmId = MapUtils.getString(rqstMap, "ad_progrmId");
		
		param.put("progrmId", progrmId);
		indexValue.put("searchJobSe", searchJobSe);
		indexValue.put("searchProgramNm", searchProgramNm);
		indexValue.put("df_curr_page", df_curr_page);
		indexValue.put("df_row_per_page", df_row_per_page);
		
		codeInfo.put("codeGroupNo", "2");
		codeInfo.put("progrmId", progrmId);
		
		Map<?, ?> progrmInfo = programService.findProgram(param);
		
		// 프로그램 find
		List<Map> progrmCodeInfoList = programService.findCodeAuthorList(codeInfo);
		
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("indexValue", indexValue);
		mv.addObject("progrmInfo", progrmInfo);
		mv.addObject("progrmCodeInfoList", progrmCodeInfoList);
		
		//mv.setViewName("/admin/ms/BD_UIMSA0032");
		mv.setViewName("/admin/comm/pgm/BD_UICMPGMA0032");
		return mv;
	}
	
	// 등록 및 수정
	public ModelAndView processProgrm (Map<?,?> rqstMap) throws Exception
	{
		HashMap progrmParam = new HashMap();
		HashMap authorParam = new HashMap();
		
		// 등록자 정보
		UserVO user = SessionUtil.getUserInfo();
		progrmParam.put("register", user.getUserNo());
		progrmParam.put("updusr", user.getUserNo());
		authorParam.put("register", user.getUserNo());
		authorParam.put("updusr", user.getUserNo());
		
		// 프로그램 등록 정보
		String jobSe = MapUtils.getString(rqstMap, "ad_jobSe");							//업무구분
		String progrmNm = MapUtils.getString(rqstMap, "ad_progrmNm");				// 프로그램명
		String svcAt = MapUtils.getString(rqstMap, "ad_svcAt");								// 서비스 여부
		String viewFilePath = MapUtils.getString(rqstMap, "ad_viewFilePath");			// 뷰 파일경로
		String preProgrmId = MapUtils.getString(rqstMap, "preProgrmId");				// 프로그램 ID 영어부분
		String progrmId = MapUtils.getString(rqstMap, "ad_progrmId");					// 프로그램 ID 숫자부분
		String rm = MapUtils.getString(rqstMap, "ad_rm");									// 비고
		
		progrmId = preProgrmId + progrmId;
		
		progrmParam.put("jobSe", jobSe);
		progrmParam.put("progrmNm", progrmNm);
		progrmParam.put("svcAt", svcAt);
		progrmParam.put("viewFilePath", viewFilePath);
		progrmParam.put("progrmId", progrmId);
		progrmParam.put("rm", rm);
		
		authorParam.put("progrmId", progrmId);
		
		// 등록,수정 구분
		String insert_update = MapUtils.getString(rqstMap, "insert_update");

		// 프로그램 등록
		if("INSERT".equals(insert_update.toUpperCase())) {
			programService.insertProgram(progrmParam);
		}
		// 프로그램 수정
		else {
			// 권한 정보 삭제
			programService.deleteAuthor(authorParam);
			// 프로그램 수정
			programService.updateProgram(progrmParam);
		}
		
		
		// 프로그램 권한 정보, 입력
		for(int i=0; i<5; i++) {
			
			String authorGroupCode;
			if(i == 0) 	
				authorGroupCode = "0001";							// 관리자
			else if (i==1) 
				authorGroupCode = "0002";							// 기관회원
			else if (i==2)
				authorGroupCode = "0003";							// 가입 회원
			else if (i==3)
				authorGroupCode = "0004";							// 일반 회원
			else
				authorGroupCode = "9999";							// 비 회원
			
			String menuOutptAt = MapUtils.getString(rqstMap, "menuOutptAt__"+i);
			String inqireAt = MapUtils.getString(rqstMap, "inqireAt__"+i);
			String streAt = MapUtils.getString(rqstMap, "streAt__"+i);
			String deleteAt = MapUtils.getString(rqstMap, "deleteAt__"+i);
			String prntngAt = MapUtils.getString(rqstMap, "prntngAt__"+i);
			String excelAt = MapUtils.getString(rqstMap, "excelAt__"+i);
			String spclAt = MapUtils.getString(rqstMap, "spclAt__"+i);
			
			authorParam.put("authorGroupCode", authorGroupCode);
			authorParam.put("menuOutptAt", menuOutptAt);
			authorParam.put("inqireAt", inqireAt);
			authorParam.put("streAt", streAt);
			authorParam.put("deleteAt", deleteAt);
			authorParam.put("prntngAt", prntngAt);
			authorParam.put("excelAt", excelAt);
			authorParam.put("spclAt", spclAt);
			
			// 프로그램 권한 정보 입력
			programService.insertAuthor(authorParam);
		}
		
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
		
		if("INSERT".equals(insert_update.toUpperCase())) {
			mv.addObject("resultMsg", messageSource.getMessage("success.common.insert", new String[] {"프로그램"}, Locale.getDefault()));
		} else {
			mv.addObject("resultMsg", messageSource.getMessage("success.common.update", new String[] {"프로그램"}, Locale.getDefault()));
		}
		
		return mv;
	}
	
	// 프로그램, 권한 정보 삭제
	public ModelAndView deleteProgrm (Map <?, ?> rqstMap) throws Exception
	{
		HashMap param = new HashMap();
		
		String progrmId = MapUtils.getString(rqstMap, "ad_progrmId");
		String preProgrmId = MapUtils.getString(rqstMap, "preProgrmId");
		progrmId = preProgrmId + progrmId;
		
		param.put("progrmId", progrmId);
		
		// 권한 정보 삭제
		programService.deleteAuthor(param);
		// 프로그램 삭제
		programService.deleteProgram(param);
		
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
		mv.addObject("resultMsg", messageSource.getMessage("success.common.delete", new String[] {"프로그램"}, Locale.getDefault()));
		return mv;
	}
	
	// 프로그램 ID 입력 체크
	public ModelAndView checkProgrmId (Map <?, ?> rqstMap) throws Exception
	{
		HashMap param = new HashMap();
		
		String progrmId = MapUtils.getString(rqstMap, "progrmId");
		String preProgrmId = MapUtils.getString(rqstMap, "preProgrmId");
		
		progrmId = preProgrmId + progrmId;
		param.put("progrmId", progrmId);
		
		ModelAndView mv = new ModelAndView();

		if (programService.selectProgrmCnt(param) > 0) {
			return ResponseUtil.responseJson(mv, false);
		}

		return ResponseUtil.responseJson(mv, true);
    }
}
