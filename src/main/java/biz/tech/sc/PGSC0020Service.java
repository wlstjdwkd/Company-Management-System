package biz.tech.sc;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.response.ExcelVO;
import com.comm.response.IExcelVO;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.infra.util.DateFormatUtil;
import com.infra.util.ResponseUtil;

import biz.tech.mapif.sc.PGSC0020Mapper;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * Excel download Sample Code
 * @author seungwon
 */
@Service("PGSC0020")
public class PGSC0020Service extends EgovAbstractServiceImpl
{
	private static final Logger logger = LoggerFactory.getLogger(PGSC0020Service.class);

	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	@Resource(name = "PGSC0020Mapper")
	PGSC0020Mapper pgsc0020DAO;

	/**
	 * 회원관리 회원 리스트 검색
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		
		// 사원 식대 조회
		List<Map> userList = pgsc0020DAO.findUserMeal(new HashMap());			// 쿼리 질의
		
		ModelAndView mv = new ModelAndView(); 			
		mv.addObject("userList", userList);										// 쿼리 결과
		mv.setViewName("/admin/sc/BD_UISCA0020");								// 경로로 이동

		return mv;
	}
	
	/**
	 * 엑셀 다운로드 (PGPS0020 참조)
	 * @param rqstMap
	 * @return
	 * @throws Exception 
	 */
	public ModelAndView downloadExcel(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		ArrayList<String> headers = new ArrayList<String>();	// 타이틀
		ArrayList<String> items = new ArrayList<String>();		// 컬럼명
		List<Map> userList;									// 쿼리 응답 저장	
		
		// 엑셀 속성 정의
		headers.add("번호");			// int
		headers.add("일자");			// DATE
		headers.add("내역");			// String
		headers.add("상호");			// String
		headers.add("금액");			// Double
		headers.add("비고");			// String
		
		items.add("mealId");		// 번호
		items.add("date");			// 일자
		items.add("item");			// 내역
		items.add("shopName");		// 상호
		items.add("price");			// 금액
		items.add("note");			// 배고
		
		userList = pgsc0020DAO.findUserMeal(new HashMap());
		
		// List를 array로 변환 및 저장
		String[] arryHeaders = new String[] {};
		String[] arryItems = new String[] {};
		arryHeaders = headers.toArray(arryHeaders);
		arryItems = items.toArray(arryItems);
		
		mv.addObject("_headers", arryHeaders);
		mv.addObject("_items", arryItems);
		mv.addObject("_list", userList);
				
		//메뉴명_탭명_YYYYMMDDhhmmss.xlsx
		IExcelVO excel = new ExcelVO("식대목록_전체_"+DateFormatUtil.getTodayFull());

		return ResponseUtil.responseExcel(mv, excel);
	}
}
