package biz.tech.so;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.comm.user.UserService;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.my.ApplyMapper;
import biz.tech.mapif.my.EmpmnMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

@Service("PGSO0080")
public class PGSO0080Service extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(PGSO0080Service.class);

	private Locale locale = Locale.getDefault();
	
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	@Resource(name="empmnMapper")
	private EmpmnMapper empmnDAO;
	
	@Resource(name="applyMapper")
	private ApplyMapper applyMapper;
	
	@Autowired
	UserService userService;
	
	/**
	 * 서비스운영관리 > 채용관리 > 기업정보관리
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		List<Map> dataList = new ArrayList<Map>();
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		// 검색조건
		param.put("use_search", "Y");
		param.put("search_type", MapUtils.getString(rqstMap, "search_type"));
		param.put("search_word", MapUtils.getString(rqstMap, "search_word"));
		param.put("search_chartr", MapUtils.getString(rqstMap, "search_chartr"));
		
		int totalRowCnt = empmnDAO.findCmpnyIntrcnCount(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		dataList = empmnDAO.findCmpnyIntrcnList(param);
		
		mv.addObject("pager", pager);
		mv.addObject("dataList", dataList);
		
		mv.setViewName("/admin/so/BD_UISOA0080");
		return mv;
	}
	
	
	/**
	 * 기업 사용자등록번호 찾기
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	/* PGMY0030 으로 이동
	public ModelAndView getEntUserList(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();

		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");

		String searchEntrprsNm = MapUtils.getString(rqstMap, "searchEntrprsNm");
		
		param.put("searchEntrprsNm", searchEntrprsNm);
		
		int totalRowCnt = userService.findEntUserListCnt(param);

		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		int pagerNo = pager.getIndexNo();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());

		// 메뉴 조회
		List<Map> list = userService.findEntUserList(param);

		// 데이터 추가
		ModelAndView mv = new ModelAndView();
		mv.addObject("pager", pager);
		mv.addObject("pagerNo", pagerNo);
		mv.addObject("list", list);
		mv.setViewName("/admin/so/PD_UISOA0081");
		return mv;
	}
	*/
}
