package biz.tech.so;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.comm.user.UserService;
import com.infra.util.ResponseUtil;
import com.infra.util.Validate;

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

@Service("PGSO0110")
public class PGSO0110Service extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(PGSO0110Service.class);

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
		Map result = new HashMap();
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		// 필터에 저장된 항목들을 가져와 배열로 넘겨 NOT IN 처리한다.
		// 필터항목들 검색
		// 필터 검색
		String temp = null;
		param.put("ad_select", "a");
		result = applyMapper.findFilter(param);
		if( result != null) {
			temp = result.get("ATRB").toString();
			String[] array_filterListA = temp.split(",");
			param.put("array_filterListA", array_filterListA);	// xml에서 사용될 배열
			param.put("tempA", temp);
		}
		param.put("ad_select", "b");
		result = applyMapper.findFilter(param);
		if( result != null) {
			temp = result.get("ATRB").toString();
			String[] array_filterListB = temp.split(",");
			param.put("array_filterListB", array_filterListB);	// xml에서 사용될 배열
			param.put("tempB", temp);
		}
		param.put("ad_select", "c");
		result = applyMapper.findFilter(param);
		if( result != null) {
			String stringfilterListC = result.get("ATRB").toString();
			param.put("stringfilterListC", stringfilterListC);	// xml에서 사용될 배열
		}
		
		// 검색조건
		param.put("use_search", "Y");
		param.put("search_type", MapUtils.getString(rqstMap, "search_type"));
		param.put("search_word", MapUtils.getString(rqstMap, "search_word"));
		param.put("search_induty", MapUtils.getString(rqstMap, "search_induty"));
		param.put("BIZRNO", MapUtils.getString(rqstMap, "BIZRNO"));
		
		// 추천기업 검색 여부
		String recomend_entrprs_search_at = MapUtils.getString(rqstMap, "recomend_entrprs_search_at");
		if(recomend_entrprs_search_at != null) {
			param.put("recomend_entrprs_search_at", "Y".toString());
		}
		else {
//			param.put("recomend_entrprs_search_at", "N".toString());
		}
		
		int totalRowCnt = empmnDAO.findCmpnyIntrcnCount(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		dataList = empmnDAO.findCmpnyIntrcnList(param);
		mv.addObject("dataList", dataList);
		
		//mv.addObject("recommendList", empmnDAO.findCmpnyIntrcnRecomendLogoList());
		//추천기업 조회
		List<Map> recommendList = new ArrayList<Map>();
		recommendList = empmnDAO.findCmpnyIntrcnRecomendLogoList();
		
		// 추천기업에서 진행중인 채용정보 건수를 알아온다.
		if(Validate.isNotEmpty(recommendList)) {
			for(Map row : recommendList) {
				param.put("BIZRNO", MapUtils.getString(row, "BIZRNO"));
				// 추천기업에서 진행중인 채용정보 건수
				row.put("recRowCnt", empmnDAO.findEmpmnPblancInfoCount(param));
			}
		}
		
		//추천기업 리스트
		mv.addObject("recommendList", recommendList);
		mv.addObject("pager", pager);
		
		mv.setViewName("/admin/so/BD_UISOA0110");
		return mv;
	}
	
	/**
	 * 기업추천 체크 전체 여부 변경
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView updateCmpnyIntrcnAllRecommend(Map<?, ?> rqstMap) throws Exception {	
		HashMap param = new HashMap();

		int ad_count = MapUtils.getIntValue(rqstMap, "ad_count");
		
		for(int i=0; i<ad_count; i++) {
					
			String USER_NO = MapUtils.getString(rqstMap, "USER_NO_"+i);
			logger.debug(USER_NO);
			String BIZR_NO = MapUtils.getString(rqstMap, "BIZR_NO_"+i);
			String check = MapUtils.getString(rqstMap, "check_"+i);
			
			param.put("USER_NO", USER_NO);
			param.put("BIZRNO", BIZR_NO);
			param.put("RECOMEND_ENTRPRS_AT", check);

			empmnDAO.updateRecomendEntrprsAt(param);
		}
		
		return index(rqstMap);
	}
	
	/**
	 * 기업추천 여부 변경
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView updateCmpnyIntrcnRecommend(Map<?, ?> rqstMap) throws Exception {	
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		Map result_map = new HashMap();
		
		param.put("USER_NO", MapUtils.getString(rqstMap, "USER_NO"));
		param.put("BIZRNO", MapUtils.getString(rqstMap, "BIZR_NO"));
		
		// 추천기업인지 아닌지 확인
		result_map = empmnDAO.findCmpnyIntrcnInfo(param);
		
		if(result_map.get("RECOMEND_ENTRPRS_AT") != null) {
			String result = result_map.get("RECOMEND_ENTRPRS_AT").toString();
			// Y일 경우(이미 추천기업일 경우)
			if(result.equals("Y")) {
				param.put("RECOMEND_ENTRPRS_AT", "N");
			}
			// N일 경우(추천기업이 아닐경우)
			else if(result.equals("N")) {
				param.put("RECOMEND_ENTRPRS_AT", "Y");
			}
			empmnDAO.updateRecomendEntrprsAt(param);
		}
		// NULL 이 들어가 있을경우
		else {
			param.put("RECOMEND_ENTRPRS_AT", "Y");
			empmnDAO.updateRecomendEntrprsAt(param);
		}

		return index(rqstMap);
	}
}
