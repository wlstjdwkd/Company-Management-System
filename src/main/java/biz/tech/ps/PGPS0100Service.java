package biz.tech.ps;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.code.CodeService;
import com.comm.page.Pager;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.ic.HpeCnfirmReqstMapper;
import biz.tech.mapif.ps.PGPS0100Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


/**
 * Read Test Service
 * @author Tkim
 *
 */
@Service("PGPS0100")
public class PGPS0100Service extends EgovAbstractServiceImpl {
	
	@SuppressWarnings("unused")
	private static final Logger logger = LoggerFactory.getLogger(PGPS0100Service.class);
	
	@Autowired
	CodeService codeService;
	
	@Resource(name="messageSource")
	private MessageSource messageSource;
	
	@Resource(name = "PGPS0100Mapper")
	private PGPS0100Mapper pgps0100Dao;
	
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
			javaMessage.add("String initSearchYn = MapUtils.getString(rqstMap, 'init_search_yn');"
					+ "- initSearchYn을 null이 아닐때만 검색 ");
			javaMessage.add("Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build(); - Pager 호출 코드");
			
			sqlMessage.add("SELECT Count(*) FROM comtnqestnrinfo; \n - 데이터 총 값을 찾는 쿼리 (Pager을 위한 것)"); //	any information that needs to be placed into params before doing the read query
			sqlMessage.add("SELECT QESTNR_ID , QUSTNR_SJ , QUSTNR_PURPS , QUSTNR_WRITNG_GUIDANCE_CN , QUSTNR_TRGET , RGSDE , UPDDE " +
							"FROM comtnqestnrinfo " +
							"WHERE QUSTNR_SJ LIKE CONCAT ('%', #{qustnrSj},'%') " +
							"ORDER BY QESTNR_ID DESC " +
							"LIMIT #{limitFrom}, #{limitTo}; "
							+ "- 데이터 조회 쿼리"); //	read Query
			
			mv.addObject("pager", pager);
			mv.addObject("resultList", resultList);
			mv.addObject("javaMessage", javaMessage);
			mv.addObject("sqlMessage", sqlMessage);
		}
		
		mv.setViewName("/admin/ps/BD_UIPSA0100");	
		
		return mv;
	}

}
