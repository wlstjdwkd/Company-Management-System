package biz.tech.im;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import com.comm.page.Pager;
import com.infra.util.Validate;
import org.apache.commons.collections.MapUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;
import biz.tech.mapif.ps.PGPS0100Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 확인서발급현황 > 신청기준집계
 */

@Service("PGIM0100")
public class PGIM0100Service extends EgovAbstractServiceImpl{
	
	@Resource(name = "PGPS0100Mapper")
	private PGPS0100Mapper pgps0100Dao;
	
	/**
	 * 지역 코드
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ModelAndView index(Map<? , ?> rqstMap) throws Exception 
	{
		HashMap param = new HashMap();		
		param = (HashMap) rqstMap;
		ModelAndView mv = new ModelAndView();
		List javaMessage = new ArrayList();
		List sqlMessage = new ArrayList();
		List<Map> resultList = new ArrayList<Map>();
		String initSearchYn = MapUtils.getString(rqstMap, "init_search_yn");
		if(Validate.isNotEmpty(initSearchYn)) {
			int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");		
			int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
			int totalRowCnt = 0;
			totalRowCnt = pgps0100Dao.findTotalCount(param);
			Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
			pager.makePaging();
			param.put("limitFrom", pager.getLimitFrom());
			param.put("limitTo", pager.getLimitTo());
			resultList = pgps0100Dao.selectUserInfo(param);
			javaMessage.add("int pageNo = MapUtils.getIntValue(rqstMap, 'df_curr_page'); -> 현재 어느 페이지 에 있는 값 (기본은 1)");
			javaMessage.add("int rowSize = MapUtils.getIntValue(rqstMap, 'df_row_per_page'); -> 한 페이지에 열이 몇게 보이는 변수");
			javaMessage.add("int totalRowCnt = 0; totalRowCnt = pgps0100Dao.findTotalCount(param); -> 데이터에 총 값 수");
			javaMessage.add("Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build(); - Pager 호출 코드");
			javaMessage.add("pager.makePaging(); -> 페이저를 만들기");
			
			sqlMessage.add("SELECT Count(*) FROM comtnqestnrinfo; \n - 데이터 총 값을 찾는 쿼리 "); //	any information that needs to be placed into params before doing the read query
			
			mv.addObject("pager", pager);
			mv.addObject("resultList", resultList);
			mv.addObject("javaMessage", javaMessage);
			mv.addObject("sqlMessage", sqlMessage);
		}
		mv.setViewName("/admin/im/BD_UIIMA0100");
		
		return mv;
	}
	
	
}