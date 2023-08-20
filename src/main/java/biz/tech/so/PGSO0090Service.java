package biz.tech.so;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.page.Pager;
import biz.tech.dc.PGDC0060Service;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.my.ApplyMapper;
import biz.tech.mapif.my.EmpmnMapper;


@Service("PGSO0090")
public class PGSO0090Service {
	
	private static final Logger logger = LoggerFactory.getLogger(PGDC0060Service.class);
	
	@Resource(name="applyMapper")
	private ApplyMapper applyMapper;
	
	@Resource(name="empmnMapper")
	private EmpmnMapper empmnDAO;
	
	/**
	 * 서비스운영관리 > 채용관리 > 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		Map result = new HashMap();									//필터 조회 결과
		List<Map> dataList = new ArrayList<Map>();
		String empmnNo;
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		String ad_hire_word = MapUtils.getString(rqstMap, "ad_hire_word");
		String ad_job_word = MapUtils.getString(rqstMap, "ad_job_word");
		String ad_range = MapUtils.getString(rqstMap, "ad_range");
		
		String[] temp_hire = null;
		String[] temp_job = null;
		
		// 페이지 고정(검색 할 때)
		if(ad_hire_word != null && ad_hire_word != null) {
			temp_hire = ad_hire_word.split(",");			
//			param.put("temp_hire", temp_hire);
			param.put("ad_hire_word", ad_hire_word);
			mv.addObject("ad_hire_word",ad_hire_word);

			temp_job = ad_job_word.split(",");
//			param.put("temp_job", temp_job);
			param.put("ad_job_word", ad_job_word);
			mv.addObject("ad_job_word", ad_job_word);
			
			mv.addObject("ad_range", ad_range);
		}
		// 처음 페이지 열 때(필터테이블 조회)
		else {
			param.put("ad_select", "a");
			result = applyMapper.findFilter(param);
			if(result != null) {
				String ad_hire = result.get("ATRB").toString();	
				temp_hire = ad_hire.split(",");
//				param.put("temp_hire", temp_hire);
				param.put("ad_hire_word", ad_hire);
				mv.addObject("ad_hire_word", ad_hire);
			}
			param.put("ad_select", "b");
			result = applyMapper.findFilter(param);
			if(result != null) {
				String ad_job = result.get("ATRB").toString();
				temp_job = ad_job.split(",");
//				param.put("temp_job", temp_job);
				param.put("ad_job_word", ad_job);
				mv.addObject("ad_job_word", ad_job);
			}
			param.put("ad_select", "c");
			result = applyMapper.findFilter(param);
			if(result != null) {
				mv.addObject("ad_range", result.get("ATRB"));
			}
		}
		
		param.put("temp_hire", temp_hire);
		param.put("temp_job", temp_job);
		param.put("ad_range", ad_range);
		
		int totalRowCnt = empmnDAO.findFilterEmpmnPblancInfoCnt(param);

		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		mv.addObject("pager", pager);
				
		dataList = empmnDAO.findFilterEmpmnPblancInfoList(param);
		
		// 항목관리 데이터를 dataList에 추가한다.
		if(Validate.isNotEmpty(dataList)) {
			String ecnyApplyDiv = "";		// 입사지원구분
			String careerDetail = "";		// 경력상세요건
			int offSet = 0;
			
			for(Map row : dataList) {
				empmnNo = MapUtils.getString(row, "EMPMN_MANAGE_NO", "");
				param.put("EMPMN_MANAGE_NO", empmnNo);
				param.put("PBLANC_IEM", "25"); // 경력
				row.put("iem25", empmnDAO.findEmpmnItem(param));
				param.put("PBLANC_IEM", "27"); // 학력
				row.put("iem27", empmnDAO.findEmpmnItem(param));
				
				param.put("BIZRNO", MapUtils.getString(row, "BIZRNO"));
				// 기업특성 가져오기
				row.put("chartr", empmnDAO.selectCmpnyIntrcnChartr(param));
				
				// 고객요청으로 근무형태 보여주지 않기로함. 2015-04-10
				// param.put("PBLANC_IEM", "33"); // 근무형태
				// row.put("iem33", empmnDAO.findEmpmnItem(param));
				
				ecnyApplyDiv = MapUtils.getString(row, "ECNY_APPLY_DIV", "");
			}
		}
		
		mv.addObject("list",dataList);
		
		
		mv.setViewName("/admin/so/BD_UISOA0090");
		return mv;
	}
	
	public ModelAndView insertFilter(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		applyMapper.deleteTitleFilter(rqstMap);
		applyMapper.deleteJobFilter(rqstMap);
		applyMapper.deleteOrderbyFilter(rqstMap);
		
		applyMapper.insertTitleFilter(rqstMap);
		applyMapper.insertJobFilter(rqstMap);
		applyMapper.insertOrderbyFilter(rqstMap);
		
		mv = index(rqstMap);
		return mv;
	}
	
}
