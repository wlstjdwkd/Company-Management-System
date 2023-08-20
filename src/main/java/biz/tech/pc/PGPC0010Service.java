package biz.tech.pc;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Locale;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.infra.util.StringUtil;
import com.comm.response.ExcelVO;
import com.comm.response.IExcelVO;
import com.infra.util.ResponseUtil;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.ps.PGPS0010Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 기업검색
 * 
 * 
 */
@Service("PGPC0010")
public class PGPC0010Service extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(PGPC0010Service.class);
	
	@Resource(name="PGPS0010Mapper")
	PGPS0010Mapper entprsDAO;
	
	/**
	 * 기업검색
	 * 
	 * 
	 */
	public ModelAndView index (Map<?,?> rqstMap) throws Exception {
		
		// 현재 년도 구하기
		SimpleDateFormat date = new SimpleDateFormat("yyyy");
		String cYear = date.format(new Date(System.currentTimeMillis()));
		
		HashMap param = new HashMap();
		HashMap<String, Object> indexInfo = new HashMap<String, Object>();
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		String searchCategory = MapUtils.getString(rqstMap, "search_category");
		String searchZone = MapUtils.getString(rqstMap, "search_zone");
		String searchCp = MapUtils.getString(rqstMap, "search_cp");
		String searchInput = MapUtils.getString(rqstMap, "search_input");
		String searchYear = MapUtils.getString(rqstMap, "search_year");
		
		String validSearchMonth1 = MapUtils.getString(rqstMap, "validBeginSearchMonth");
		String validSearchMonth2 = MapUtils.getString(rqstMap, "validEndSearchMonth");
		String validSearchYear1 = MapUtils.getString(rqstMap, "validBeginSearchYear");
		String validSearchYear2 = MapUtils.getString(rqstMap, "validEndSearchYear");
		
		if(rqstMap.containsKey("search_cp")) {
			if ("VALID".equals(searchCp.toUpperCase()) ) {
				int validPdBeginDe = Integer.parseInt(validSearchYear1 + validSearchMonth1 + "00");
				int validPdEndDe = Integer.parseInt(validSearchYear2 + validSearchMonth2 + "32");
				param.put("validPdBeginDe", validPdBeginDe);
				param.put("validPdEndDe", validPdEndDe);
			}
		}
		
		// 쿼리로 들어갈 변수들 입력
		param.put("searchCategory", searchCategory);
		
		if ( searchZone != null ) {
			String aSearchZone = searchZone.substring(0,1);
			String bSearchZone = searchZone.substring(1,2);
			param.put("aSearchZone", aSearchZone);
			param.put("bSearchZone", bSearchZone);
		}
		
		param.put("searchZone", searchZone);
		param.put("searchCp", searchCp);
		param.put("searchInput", searchInput);
		param.put("searchYear", searchYear);
		
		// 검색이 법인등록번호일 때 숫자 가운데 '-'가 붙어있으면 제거 후 검색한다.
		if(rqstMap.containsKey("search_cp")) {
			 if("JURIRNO".equals(searchCp.toUpperCase())) {
				 param.put("searchInput", searchInput.replace("-", ""));
			}
		}
		
		// View에 표시될 정보 입력
		indexInfo.put("pageNo", pageNo);
		indexInfo.put("rowSize", rowSize);
		indexInfo.put("searchCategory", searchCategory);
		indexInfo.put("searchZone", searchZone);
		indexInfo.put("searchCp", searchCp);
		indexInfo.put("searchInput", searchInput);
		indexInfo.put("searchYear", searchYear);
		indexInfo.put("cYear", cYear);
		indexInfo.put("validSearchMonth1", validSearchMonth1);
		indexInfo.put("validSearchMonth2", validSearchMonth2);
		indexInfo.put("validSearchYear1", validSearchYear1);
		indexInfo.put("validSearchYear2", validSearchYear2);
		
		// 기업 목록 갯수
		int totalEnCnt = entprsDAO.findEntprsListCnt(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalEnCnt).rowSize(rowSize).build();
		pager.makePaging();
		int pagerNo = pager.getIndexNo();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());

		// 기업 정보 find 
		List<Map> entprsList = entprsDAO.selectEntprsList(param);
		List<Map> abrvList = entprsDAO.selectAbrvList();
		
		Map numMap = new HashMap();
		String num = null;
		for(int i=0; i<entprsList.size(); i++) {	
			numMap = StringUtil.toJurirnoFormat((String) entprsList.get(i).get("jurirno"));
			num = numMap.get("first") + "-" + numMap.get("last") ;
			entprsList.get(i).put("jurirno", num);
			
			numMap = StringUtil.toDateFormat((String) entprsList.get(i).get("validPdBeginDe"));
			num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last") ;
			entprsList.get(i).put("validPdBeginDe", num);
			
			numMap = StringUtil.toDateFormat((String) entprsList.get(i).get("validPdEndDe"));
			num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last") ;
			entprsList.get(i).put("validPdEndDe", num);
		}
		
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("indexInfo", indexInfo);
		mv.addObject("pager", pager);
		mv.addObject("pagerNo", pagerNo);
		mv.addObject("entprsList", entprsList);
		mv.addObject("abrvList", abrvList);
		mv.setViewName("/www/pc/BD_UIPCU0010");
		return mv;
	}
	
	/**
	 * 엑셀 다운로드
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView excelRsolver(Map<? , ?> rqstMap) throws Exception {
		// 현재 년도 구하기
		SimpleDateFormat date = new SimpleDateFormat("yyyy");
		String cYear = date.format(new Date(System.currentTimeMillis()));
		
		HashMap param = new HashMap();
		HashMap<String, Object> indexInfo = new HashMap<String, Object>();
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		String searchCategory = MapUtils.getString(rqstMap, "search_category");
		String searchZone = MapUtils.getString(rqstMap, "search_zone");
		String searchCp = MapUtils.getString(rqstMap, "search_cp");
		String searchInput = MapUtils.getString(rqstMap, "search_input");
		String searchYear = MapUtils.getString(rqstMap, "search_year");
		
		String validSearchMonth1 = MapUtils.getString(rqstMap, "validBeginSearchMonth");
		String validSearchMonth2 = MapUtils.getString(rqstMap, "validEndSearchMonth");
		String validSearchYear1 = MapUtils.getString(rqstMap, "validBeginSearchYear");
		String validSearchYear2 = MapUtils.getString(rqstMap, "validEndSearchYear");
		
		if(rqstMap.containsKey("search_cp")) {
			if ("VALID".equals(searchCp.toUpperCase()) ) {
				int validPdBeginDe = Integer.parseInt(validSearchYear1 + validSearchMonth1 + "00");
				int validPdEndDe = Integer.parseInt(validSearchYear2 + validSearchMonth2 + "32");
				param.put("validPdBeginDe", validPdBeginDe);
				param.put("validPdEndDe", validPdEndDe);
			}
		}
		
		// 쿼리로 들어갈 변수들 입력
		param.put("searchCategory", searchCategory);
		
		if ( searchZone != null ) {
			String aSearchZone = searchZone.substring(0,1);
			String bSearchZone = searchZone.substring(1,2);
			param.put("aSearchZone", aSearchZone);
			param.put("bSearchZone", bSearchZone);
		}
		
		param.put("searchZone", searchZone);
		param.put("searchCp", searchCp);
		param.put("searchInput", searchInput);
		param.put("searchYear", searchYear);
		
		// 기업 목록 갯수
		int totalEnCnt = entprsDAO.findEntprsListCnt(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalEnCnt).rowSize(rowSize).build();
		pager.makePaging();
		int pagerNo = pager.getIndexNo();
		param.put("limitFrom", 0);
		param.put("limitTo", totalEnCnt);
		
		// 기업 정보 find 
		List<Map> entprsList = entprsDAO.selectEntprsList(param);
		List<Map> abrvList = entprsDAO.selectAbrvList();
		
		Map numMap = new HashMap();
		String num = null;
		for(int i=0; i<entprsList.size(); i++) {	
			numMap = StringUtil.toJurirnoFormat((String) entprsList.get(i).get("jurirno"));
			num = numMap.get("first") + "-" + numMap.get("last") ;
			entprsList.get(i).put("jurirno", num);
			
			numMap = StringUtil.toDateFormat((String) entprsList.get(i).get("validPdBeginDe"));
			num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last") ;
			entprsList.get(i).put("validPdBeginDe", num);
			
			numMap = StringUtil.toDateFormat((String) entprsList.get(i).get("validPdEndDe"));
			num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last") ;
			entprsList.get(i).put("validPdEndDe", num);
		}
		
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("_list", entprsList);
		
		 String[] headers = {
		            "기업명",
		            "법인번호",
		            "발급번호",
		            "유효기간시작",
		            "유효기간종료",
		            "업종",
		            "지역"
		        };
		        String[] items = {
		            "entrprsNm",
		            "jurirno",
		            "issuNo",
		            "validPdBeginDe",
		            "validPdEndDe",
		            "indutyCode",
		            "hedofcAdres"
		        };

		        mv.addObject("_headers", headers);
		        mv.addObject("_items", items);

        SimpleDateFormat formatter = new SimpleDateFormat ( "yyyyMMddHHmmss", Locale.KOREA );
        Date currentTime = new Date ( );
        String dTime = formatter.format ( currentTime );
        IExcelVO excel = new ExcelVO("확인서_발급현황_"+dTime);
				
		return ResponseUtil.responseExcel(mv, excel);
	}
}
