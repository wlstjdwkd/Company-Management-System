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
import biz.tech.mapif.ps.PGPS0110Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


/**
 * Update Test 
 * @author Tkim
 *
 */
@Service("PGPS0110")
public class PGPS0110Service extends EgovAbstractServiceImpl {
	
	@SuppressWarnings("unused")
	private static final Logger logger = LoggerFactory.getLogger(PGPS0110Service.class);
	
	@Autowired
	CodeService codeService;
	
	@Resource(name="messageSource")
	private MessageSource messageSource;
	
	@Resource(name = "PGPS0100Mapper")
	private PGPS0100Mapper pgps0100Dao;
	
	@Resource(name = "PGPS0110Mapper")
	private PGPS0110Mapper pgps0110Dao;
	
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
			String searchValue = MapUtils.getString(rqstMap, "searchValue");
			
			int totalRowCnt = 0;
			totalRowCnt = pgps0100Dao.findTotalCount(param);
			Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
			pager.makePaging();
			
			param.put("limitFrom", pager.getLimitFrom());
			param.put("limitTo", pager.getLimitTo());
			
			resultList = pgps0100Dao.selectUserInfo(param);
			
			/*javaMessage.add("String initSearchYn = MapUtils.getString(rqstMap, 'qustnr_sj');- Not sure how the pager works however whenever the pager is clicked on"
					+ "it defaults to the index function and so I made it so that if there is a null value on the search value, it will pass through and if it's not null"
					+ " then it will continue to use the value ");
			javaMessage.add("Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build(); - Making a pager");
			
			sqlMessage.add("SELECT Count(*) FROM comtnqestnrinfo; - Find total num of results"); //	any information that needs to be placed into params before doing the read query
			sqlMessage.add("SELECT QESTNR_ID , QUSTNR_SJ , QUSTNR_PURPS , QUSTNR_WRITNG_GUIDANCE_CN , QUSTNR_TRGET , RGSDE , UPDDE" +
							"FROM comtnqestnrinfo" +
							"WHERE QUSTNR_SJ LIKE CONCAT ('%', #{qustnr_sj},'%')" +
							"ORDER BY QESTNR_ID DESC" +
							"LIMIT #{limitFrom}, #{limitTo};- Obtaining the read query"); //	read Query
*/			
			mv.addObject("pager", pager);
			mv.addObject("searchValue", searchValue);
			mv.addObject("resultList", resultList);
			mv.addObject("javaMessage", javaMessage);
			mv.addObject("sqlMessage", sqlMessage);
		}
		mv.setViewName("/admin/ps/BD_UIPSA0110");	
		return mv;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ModelAndView moveEdit(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();		
		param = (HashMap) rqstMap;
		List sqlMessage = new ArrayList();
		List<Map> resultList = new ArrayList<Map>();
		String searchValue = MapUtils.getString(rqstMap, "searchValue");
		String idValue = MapUtils.getString(rqstMap, "targetID");
		param.put("targetID", idValue);
		resultList = pgps0110Dao.selectEditTarget(param);
		
		sqlMessage.add("SELECT "
				+	"QUSTNR_SJ "
				+	", QUSTNR_PURPS "
				+	", QUSTNR_WRITNG_GUIDANCE_CN "
				+	", QUSTNR_TRGET " 
				+	"FROM comtnqestnrinfo "
				+	"WHERE QESTNR_ID = #{targetID} "
				+ " - 정보를 가지고 오는 쿼리");
		mv.addObject("resultList", resultList);
		mv.addObject("targetID", idValue);
		mv.addObject("searchValue", searchValue);
		mv.addObject("sqlMessage", sqlMessage);
		mv.setViewName("/admin/ps/BD_UIPSA0111");
		
		return mv;
		
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ModelAndView updateData(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();		
		param = (HashMap) rqstMap;
		List sqlMessage = new ArrayList();
		String initSearchYn = MapUtils.getString(rqstMap, "init_search_yn");
		if(initSearchYn != null) {
			int updater = pgps0110Dao.updateUserInfo(param);
			if(updater == 1){
				mv = index(rqstMap);
			}
		}
		sqlMessage.add("UPDATE comtnqestnrinfo"
				+ "SET QUSTNR_SJ = #{qustnrSj} "
				+ ", QUSTNR_PURPS = #{qustnrPurps} "
				+ ", QUSTNR_WRITNG_GUIDANCE_CN = #{qustnrWritngGuidanceCn} "
				+ ", QUSTNR_TRGET = #{qustnrTrget} "
				+ ", UPDDE = CURRENT_TIMESTAMP "
				+ "WHERE QESTNR_ID = #{qestnrId} - 데이터 테이블 수정"); //	read Query
		mv.setViewName("/admin/ps/BD_UIPSA0110");
		mv.addObject("sqlMessage", sqlMessage);
		
		return mv;
	}
	
	

    
    
}
