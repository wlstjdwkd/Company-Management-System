package biz.tech.sc;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.comm.program.ProgramService;
import com.comm.response.ExcelVO;
import com.comm.response.IExcelVO;
import com.comm.user.AllUserVO;
import com.comm.user.EntUserVO;
import com.comm.user.UserService;
import com.comm.user.UserVO;
import com.infra.file.FileDAO;
import com.infra.system.GlobalConst;
import com.infra.util.DateFormatUtil;
import com.infra.util.RandomNumber;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;
import com.infra.util.crypto.Crypto;
import com.infra.util.crypto.CryptoFactory;

import biz.tech.mapif.sc.PGSC0010Mapper;

import org.apache.commons.collections.MapUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

@Service("PGSC0010")
public class PGSC0010Service extends EgovAbstractServiceImpl
{
	private static final Logger logger = LoggerFactory.getLogger(PGSC0010Service.class);
	private Locale locale = Locale.getDefault();

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	@Autowired
	PGSC0010Mapper PGSC0010Mapper;

	/**
	 * 회원관리 회원 리스트 검색
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception
	{		
		ModelAndView mv = new ModelAndView();
		Map param = new HashMap<>();
		param = (Map<?, ?>) rqstMap;

		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		String initSearchYn = MapUtils.getString(rqstMap, "init_search_yn");

		int totalRowCnt = 0;
		 if (Validate.isNotEmpty(initSearchYn)) { totalRowCnt =
				 PGSC0010Mapper.findUsermemberlist(param); }

		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		List<Map> userList = null;
		if (Validate.isNotEmpty(initSearchYn)) {
			userList = PGSC0010Mapper.findmember(param);
		}

		mv.addObject("pager", pager);
		mv.addObject("userList", userList);
		mv.setViewName("/admin/sc/BD_UISCA0010");

		return mv;
	}
	
	// 등록 창 띄우기
	public ModelAndView programRegist(Map<?,?> rqstMap) throws Exception {
			
		HashMap param = new HashMap();
			
		ModelAndView mv = new ModelAndView();
		mv.addObject("param", param);
			
		mv.setViewName("/admin/sc/BD_UISCA0011");
		return mv;
	}
		
	// 수정/삭제 View 띄우기
	public ModelAndView programModify(Map<?, ?> rqstMap) throws Exception {
			
		HashMap param = new HashMap();
			
		String adPK = MapUtils.getString(rqstMap, "ad_PK");
		param.put("adPK", adPK);
			
		Map<?, ?> userInfo = PGSC0010Mapper.findUsermember(param);
					
		ModelAndView mv = new ModelAndView();
		mv.addObject("userInfo", userInfo);
		mv.setViewName("/admin/sc/BD_UISCA0012");
			
		return mv;
	}
		
	// 등록 및 수정
	public ModelAndView processProgrm (Map<?,?> rqstMap) throws Exception {
		HashMap progrmParam = new HashMap();
		HashMap authorParam = new HashMap();
			
		// 등록 정보
		String adPK = MapUtils.getString(rqstMap, "ad_PK");							// 사원번호
		String adname = MapUtils.getString(rqstMap, "ad_name");						// 이름
		String adrank = MapUtils.getString(rqstMap, "ad_rank");						// 직급
		String adss = MapUtils.getString(rqstMap, "ad_ss");							// 주민번호
		String adbank = MapUtils.getString(rqstMap, "ad_bank");						// 결제은행
		String adbanknum = MapUtils.getString(rqstMap, "ad_banknum");				// 결제계좌
		String startdt = MapUtils.getString(rqstMap, "start_dt");					// 입사일
		String adtel = MapUtils.getString(rqstMap, "ad_tel");						// 전화번호
		String adpmail = MapUtils.getString(rqstMap, "ad_pmail");					// 개인 이메일
		String adcmail = MapUtils.getString(rqstMap, "ad_cmail");					// 회사 이메일
		String adadd = MapUtils.getString(rqstMap, "ad_add");						// 주소
			
		progrmParam.put("adPK", adPK);
		progrmParam.put("adname", adname);
		progrmParam.put("adrank", adrank);
		progrmParam.put("adss", adss);
		progrmParam.put("adbank", adbank);
		progrmParam.put("adbanknum", adbanknum);
		progrmParam.put("startdt", startdt);
		progrmParam.put("adtel", adtel);
		progrmParam.put("adpmail", adpmail);
		progrmParam.put("adcmail", adcmail);
		progrmParam.put("adadd", adadd);
		
		// 등록,수정 구분
		String insert_update = MapUtils.getString(rqstMap, "insert_update");
			// 등록
			if("INSERT".equals(insert_update.toUpperCase())) {
				PGSC0010Mapper.insertMember(progrmParam);
			}
			// 수정
			else {
				PGSC0010Mapper.updatemember(progrmParam);
			} 
		
		HashMap indexMap = new HashMap(); 
			
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
			
		indexMap.put("df_curr_page", pageNo);
		indexMap.put("df_row_per_page", rowSize);
			
		ModelAndView mv = index(indexMap);
			
		if("INSERT".equals(insert_update.toUpperCase())) {
			mv.addObject("resultMsg", messageSource.getMessage("success.common.insert", new String[] {"프로그램"}, Locale.getDefault()));
		} else {
			mv.addObject("resultMsg", messageSource.getMessage("success.common.update", new String[] {"프로그램"}, Locale.getDefault()));
		}
			
		return mv;
	}
		
	//정보 삭제
	public ModelAndView deleteProgrm (Map <?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();
			
		String adPK = MapUtils.getString(rqstMap, "ad_PK");
			
		param.put("adPK", adPK);
			
		// 정보 삭제
		PGSC0010Mapper.deletemember(param);
			
		HashMap indexMap = new HashMap();
			
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
			
		indexMap.put("df_curr_page", pageNo);
		indexMap.put("df_row_per_page", rowSize);
			
		ModelAndView mv = index(indexMap);
		mv.addObject("resultMsg", messageSource.getMessage("success.common.delete", new String[] {"프로그램"}, Locale.getDefault()));
		return mv;
	} 
		
	/**
	 * 엑셀 다운로드
	 * @param rqstMap
	 * @return
	 * @throws Exception 
	 */
	public ModelAndView excelStatics(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
			
		// 타이틀
		ArrayList<String> headers = new ArrayList<String>();

		// 헤더 이름 설정
		headers.add("사원번호");
		headers.add("이름");
		headers.add("주민번호");
		headers.add("거래은행");
		headers.add("계좌번호");
		headers.add("핸드폰번호");
		headers.add("회사메일");
		headers.add("주소");
			
		List<Map> userList = PGSC0010Mapper.findmember(rqstMap);
				
		ArrayList<String> items = new ArrayList<String>();
			
		// jsp에서 받아온 명칭
		items.add("PK");
		items.add("name");
		items.add("ssnum");
		items.add("bank");
		items.add("banknum");
		items.add("tel");
		items.add("cmail");
		items.add("address");

		String[] arryHeaders = new String[] {};
		String[] arryItems = new String[] {};
		arryHeaders = headers.toArray(arryHeaders);
		arryItems = items.toArray(arryItems);
			
		mv.addObject("_headers", arryHeaders);
		mv.addObject("_items", arryItems);
		mv.addObject("_list", userList);
			
		IExcelVO excel = new ExcelVO("직원정보_"+DateFormatUtil.getTodayFull());

		return ResponseUtil.responseExcel(mv, excel);
	}
		
}
