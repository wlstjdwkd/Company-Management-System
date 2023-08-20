package biz.tech.ps;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.code.CodeService;
import com.comm.page.Pager;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.ic.HpeCnfirmReqstMapper;
import biz.tech.mapif.ps.PGPS0100Mapper;
import biz.tech.mapif.ps.PGPS0130Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


/**
 * Delete Test Service
 * @author Tkim
 *
 */
@Service("PGPS0130")
public class PGPS0130Service extends EgovAbstractServiceImpl {
	
	@SuppressWarnings("unused")
	private static final Logger logger = LoggerFactory.getLogger(PGPS0130Service.class);
	
	@Autowired
	CodeService codeService;
		
	@Resource(name="messageSource")
	private MessageSource messageSource;
	
	@Resource(name = "PGPS0100Mapper")
	private PGPS0100Mapper pgps0100Dao;
	
	@Resource(name = "PGPS0130Mapper")
	private PGPS0130Mapper pgps0130Dao;
	
	@Autowired
	HpeCnfirmReqstMapper hpeCnfirmReqstMapper;
	
	/**
	 * 기본 값 (테스트 탭 1)
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ModelAndView index(Map rqstMap) throws Exception {
		HashMap param = new HashMap();		
		param = (HashMap) rqstMap;
		ModelAndView mv = new ModelAndView();
		List javaMessage = new ArrayList();
		List sqlMessage = new ArrayList();
		List<Map> resultList = new ArrayList<Map>();
		String initSearchYn = MapUtils.getString(rqstMap, "init_search_yn");
		if(initSearchYn != null) {
			int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");		
			int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
			int totalRowCnt = 0;
			totalRowCnt = pgps0100Dao.findTotalCount(param);
			Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
			pager.makePaging();
			param.put("limitFrom", pager.getLimitFrom());
			param.put("limitTo", pager.getLimitTo());
			resultList = pgps0100Dao.selectUserInfo(param);
			
			/*javaMessage.add("Java important 1- Reason ");
			javaMessage.add("Java important 2 - Reason");*/
			
			/*sqlMessage.add("SELECT Count(*) FROM comtnqestnrinfo; \n - 총 값을 찾기 (Pager을 위한 것)"); //	any information that needs to be placed into params before doing the read query
			sqlMessage.add("SELECT QESTNR_ID , QUSTNR_SJ , QUSTNR_PURPS , QUSTNR_WRITNG_GUIDANCE_CN , QUSTNR_TRGET , RGSDE , UPDDE \n" +
							"FROM comtnqestnrinfo \n" +
							"WHERE QUSTNR_SJ LIKE CONCAT ('%', #{qustnr_sj},'%') \n" +
							"ORDER BY QESTNR_ID DESC \n" +
							"LIMIT #{limitFrom}, #{limitTo}; \n"
							+ "- 데이터 조회 쿼리"); //	read Query
*/			
			mv.addObject("pager", pager);
			mv.addObject("resultList", resultList);
			mv.addObject("javaMessage", javaMessage);
			mv.addObject("sqlMessage", sqlMessage);
		}
		mv.setViewName("/admin/ps/BD_UIPSA0130");	
		
		return mv;
	}
	
	

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ModelAndView deleteData(Map rqstMap) throws Exception {
		HashMap param = new HashMap();		
		param = (HashMap) rqstMap;
		ModelAndView mv = new ModelAndView();
		List javaMessage = new ArrayList();
		List sqlMessage = new ArrayList();
		String selectedID = MapUtils.getString(rqstMap, "selectedID");
		System.out.println("Selected ID: " + selectedID);
		String[] selectedArr = selectedID.split(",");
		param.put("selectedID", selectedArr);
		int deleter = pgps0130Dao.deleteUserInfo(param);
		if(deleter == 1){
			mv = index(rqstMap);
		}
		javaMessage.add("String selectedID = MapUtils.getString(rqstMap, 'selectedID'); "
					+ "String[] selectedArr = selectedID.split(','); "
					+ "param.put('selectedID', selectedArr); "
					+ "String으로 선택된 ID값을 Array로 변경해서 쿼리의 foreach를 이용");
		
		sqlMessage.add("DELETE FROM comtnqestnrinfo "
				+" WHERE QESTNR_ID IN "
				+ "<foreach item=\"item\" collection=\"selectedID\" open=\"(\" separator=\",\" close=\")\"> "
				+ "#{item} \n"
				+ "</foreach>\n"
				+ "- 삭제 쿼리");
		
		mv.addObject("javaMessage", javaMessage);
		mv.addObject("sqlMessage", sqlMessage);
		mv.setViewName("/admin/ps/BD_UIPSA0130");
		
		return mv;
	}
	
	

    
    
}
