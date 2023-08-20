package biz.tech.sc;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.comm.response.ExcelVO;
import com.comm.response.IExcelVO;
import com.infra.util.DateFormatUtil;
import com.infra.util.ResponseUtil;
import com.infra.util.Validate;
import com.infra.web.GridCodi;

import biz.tech.mapif.sc.PGSC0040Mapper;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;


/**
 * DHTMLX GRID SAMPLE CODE
 * 
 * @author LYJ
 * 
 */
@Service("PGSC0040")
public class PGSC0040Service extends EgovAbstractServiceImpl{
	
	private static final Logger logger = LoggerFactory.getLogger(PGSC0040Service.class); //로그 남기기

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService; //프로퍼티값 읽어오기

	@Resource(name = "messageSource")
	private MessageSource messageSource; //다국어화
	
	@Resource(name = "PGSC0040Mapper")
	PGSC0040Mapper pgsc0040DAO;
	
	/**
	 * DHTMLX GRID SAMPLE CODE
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index (Map<?, ?> rqstMap) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/sc/BD_UISCA0040");
		
		return mv;
	}	

	//DhtmlX Grid에 데이터 보내기
	public ModelAndView AjaxgridData (Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		
		String searchemNm = MapUtils.getString(rqstMap, "searchemNm");
		param.put("searchemNm", searchemNm);
		
		List<Map> expenseList = pgsc0040DAO.findExpenseList(param);
		
		String resData = GridCodi.MaptoJson(expenseList);
		
		ModelAndView mv = new ModelAndView("");
		return ResponseUtil.responseText(mv, resData);
	}
	
	//조회 후 엑셀파일로 다운받기
	public ModelAndView excelStatics(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		
		String searchemNm = MapUtils.getString(rqstMap, "searchemNm");
		param.put("searchemNm", searchemNm);

		List<Map> expenseList = pgsc0040DAO.findExpenseList(param);
		
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("사원번호");
		headers.add("일자");
		headers.add("내역");
		headers.add("상호");
		headers.add("금액");
		
		ArrayList<String> items = new ArrayList<String>();
		
		items.add("emnum");
		items.add("hdate");
		items.add("history");
		items.add("fee");
		items.add("price");

		String[] arryHeaders = new String[] {};
		String[] arryItems = new String[] {};
		arryHeaders = headers.toArray(arryHeaders);
		arryItems = items.toArray(arryItems);
		
		mv.addObject("_headers", arryHeaders);
		mv.addObject("_items", arryItems);
		mv.addObject("_list", expenseList);
		
		IExcelVO excel = null;
		
		excel = new ExcelVO(searchemNm+"_지출내역_현황_"+DateFormatUtil.getTodayFull());
		
		return ResponseUtil.responseExcel(mv, excel);
	}
	
}
			 