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
import biz.tech.my.PGMY0030Service;

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
@Service("PGSO0060")
public class PGSO0060Service extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(PGSO0060Service.class);

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
	 * 서비스운영관리 > 채용관리 > 채용정보관리
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
		
		String empmnNo;
		
		// 검색조건
		param.put("use_search", "Y");
		param.put("search_type", MapUtils.getString(rqstMap, "search_type"));
		param.put("search_word", MapUtils.getString(rqstMap, "search_word"));
		
		param.put("ISADMIN", "Y");	// 마감일 지난 항목도 조회
		int totalRowCnt = empmnDAO.findEmpmnPblancInfoCount(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		// 채용공고 리스트 조회
		dataList = empmnDAO.findEmpmnPblancInfoList(param);
		
		// 항목관리 데이터를 dataList에 추가한다.
		if(Validate.isNotEmpty(dataList)) {	
			String ecnyApplyDiv = "";		// 입사지원구분
			String careerDetail = "";		// 경력상세요건
			int offSet = 0;
			
			for(Map row : dataList) {
				empmnNo = MapUtils.getString(row, "EMPMN_MANAGE_NO", "");
				param.put("EMPMN_MANAGE_NO", empmnNo);
				param.put("PBLANC_IEM", "25"); // 경력
				row.put("item25", StringUtil.join(empmnDAO.findEmpmnIemCodeNm(param), ","));
				param.put("PBLANC_IEM", "27"); // 학력
				row.put("item27", StringUtil.join(empmnDAO.findEmpmnIemCodeNm(param), ","));
				/*param.put("PBLANC_IEM", "33"); // 근무형태
				row.put("item33", StringUtil.join(empmnDAO.findEmpmnIemCodeNm(param), ","));*/
				
				ecnyApplyDiv = MapUtils.getString(row, "ECNY_APPLY_DIV", "");
				
				/*
				if("W".equals(ecnyApplyDiv)) {
					careerDetail = MapUtils.getString(row, "CAREER_DETAIL_RQISIT", "");
					offSet = careerDetail.lastIndexOf(" ");
					
					if(offSet > -1) {
						row.put("worknet_acdmcr", careerDetail.substring(0, offSet));
						row.put("worknet_careear", careerDetail.substring(offSet));
					}else {
						row.put("worknet_acdmcr", careerDetail);
						row.put("worknet_careear", "");
					}
				}
				*/
			}
		}
		
		mv.addObject("pager", pager);
		mv.addObject("dataList", dataList);		
		
		mv.setViewName("/admin/so/BD_UISOA0060");
		return mv;
	}
}
