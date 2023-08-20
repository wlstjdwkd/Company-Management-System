package biz.tech.ts;

/**
 * 테스트 서비스 클래스
 * @author JGS
 *
 */
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.menu.MenuService;
import com.comm.page.Pager;
import com.comm.response.ExcelVO;
import com.comm.response.IExcelVO;
import com.infra.system.GlobalConst;
import com.infra.util.ResponseUtil;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.test.TestMapper;

@Service("PGTS0002")
public class PGTS0002Service {
	
	private static final Logger logger = LoggerFactory.getLogger(MenuService.class);
	
	@Resource(name="testMapper")
	private TestMapper testDAO;
	
	/**
	 * 테스트
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {		
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");		
		
		// 총 메뉴 글 개수
		int totalRowCnt = testDAO.findTotalUserMenuRowCnt();		
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).build();
		pager.makePaging();
		
		// 메뉴 글 조회
		List<Map> menuList = new ArrayList<Map>();		
		menuList = testDAO.findUserMenuWithPaging(pager);
		
		// 데이터 추가
		ModelAndView mv = new ModelAndView();
		mv.addObject("pager", pager);
		mv.addObject("menuList", menuList);		
		mv.setViewName("/www/test/TS_index");
		
		return mv;
	}
	
	/**
	 * JSON Resolver 테스트
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView jsonRsolver(Map<?, ?> rqstMap) throws Exception {	

		ModelAndView mv = new ModelAndView();
		Map dataMap = new HashMap();
		dataMap.put("data1", "test1");
		dataMap.put("data2", "test2");
		return ResponseUtil.responseJson(mv, true, dataMap);
	}
	
	
	/**
	 * SXSSF Resolver 테스트
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView excelRsolver(Map<?, ?> rqstMap) throws Exception {	
		ModelAndView mv = new ModelAndView();
		
		int pageNo = 1;		
		
		// 총 메뉴 글 개수
		int totalRowCnt = testDAO.findTotalUserMenuRowCnt();		
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).build();
		pager.makePaging();
		
		// 메뉴 글 조회
		List<Map> menuList = new ArrayList<Map>();		
		menuList = testDAO.findUserMenuWithPaging(pager);
		
		mv.addObject("_list", menuList);

        String[] headers = {
            "메뉴번호",
            "프로그램ID",
            "메뉴명"
        };
        String[] items = {
            "menu_no",
            "progrm_id",
            "menu_nm"
        };

        mv.addObject("_headers", headers);
        mv.addObject("_items", items);

        IExcelVO excel = new ExcelVO("메뉴 리스트");
				
		return ResponseUtil.responseExcel(mv, excel);
        
	}
}
