package biz.tech.so;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.infra.util.SessionUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.my.ApplyMapper;
import biz.tech.mapif.my.EmpmnMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * @author dongwoo
 *
 */
@Service("PGSO0070")
public class PGSO0070Service extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(PGSO0070Service.class);

	private Locale locale = Locale.getDefault();
	
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	@Resource(name="empmnMapper")
	private EmpmnMapper empmnDAO;
	
	@Resource(name="applyMapper")
	private ApplyMapper applyMapper;
	
	/**
	 * 서비스운영관리 > 채용관리 > 입사지원현황
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
		
		param.put("RCEPT_AT", "Y");		
		
		// 검색조건
		param.put("use_search", "Y");
		param.put("search_type", MapUtils.getString(rqstMap, "search_type"));
		param.put("search_word", MapUtils.getString(rqstMap, "search_word"));
		
		int totalRowCnt = applyMapper.findApplyCount(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		dataList = applyMapper.findApplyList(param);
		
		// 항목관리 데이터를 dataList에 추가한다.
		if(Validate.isNotEmpty(dataList)) {			
			for(Map row : dataList) {
				String empmnNo = MapUtils.getString(row, "EMPMN_MANAGE_NO", "");
				param.put("EMPMN_MANAGE_NO", empmnNo);
				param.put("PBLANC_IEM", "25"); // 경력
				row.put("item25", StringUtil.join(empmnDAO.findEmpmnIemCodeNm(param), ","));			
			}
		}
		
		mv.addObject("pager", pager);
		mv.addObject("dataList", dataList);
		
		mv.setViewName("/admin/so/BD_UISOA0070");
		return mv;
	}
}
