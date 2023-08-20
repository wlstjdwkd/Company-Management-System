package biz.tech.so;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.infra.util.ResponseUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.sp.PGSP0030Mapper;

/**
 * 지원사업관리
 * @author DST
 *
 */
@Service("PGSO0100")
public class PGSO0100Service {

	
	private static final Logger logger = LoggerFactory.getLogger(PGSO0100Service.class);
	
	@Resource(name = "PGSP0030Mapper")
	private PGSP0030Mapper pgsp0030Mapper;
	
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		
	
		HashMap param = new HashMap();
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		String searchKeyword = MapUtils.getString(rqstMap, "searchKeyword");
		String searchCondition = MapUtils.getString(rqstMap, "searchCondition");
		String searchDateType = MapUtils.getString(rqstMap, "searchDateType");
		String fromDate = MapUtils.getString(rqstMap, "q_pjt_start_dt");
		String toDate = MapUtils.getString(rqstMap, "q_pjt_end_dt");
	
		param.put("searchKeyword", searchKeyword);
		param.put("searchCondition", searchCondition);
		param.put("searchDateType", searchDateType);
		param.put("fromDate", fromDate);
		param.put("toDate", toDate);
		
		if(fromDate != null)
		{
			param.put("q_pjt_start_dt", fromDate.replace("-", ""));
		}
		if(fromDate != null)
		{
			param.put("q_pjt_end_dt", toDate.replace("-", ""));
		}
		
//		param.put("ntceAt", "Y");
		
		// 총 프로그램 갯수
		int totalRowCnt = pgsp0030Mapper.findSuportListCnt(param);
	
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
	
		// 프로그램 글 조회
		List<Map> suportList = pgsp0030Mapper.findSuportList(param);
		Map dateMap = new HashMap();
		
		// 시작일, 마감일 '-' 추가
		if(Validate.isNotEmpty(suportList)) {
			for(int i=0; i < suportList.size(); i++) {
				// 시작일
				if(Validate.isNotNull(suportList.get(i).get("opertnBginde"))) {
					dateMap = StringUtil.toDateFormat((String) suportList.get(i).get("opertnBginde"));
					suportList.get(i).put("opertnBginde", dateMap.get("first") + "-" + dateMap.get("middle") + "-" + dateMap.get("last"));
				}
				
				// 마감일
				if(Validate.isNotNull(suportList.get(i).get("opertnEndde"))) {
					dateMap = StringUtil.toDateFormat((String) suportList.get(i).get("opertnEndde"));
					suportList.get(i).put("opertnEndde", dateMap.get("first") + "-" + dateMap.get("middle") + "-" + dateMap.get("last"));
				}
			}
		}
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("pager", pager);
		mv.addObject("suportList", suportList);
		mv.addObject("inparam",param);

		mv.setViewName("/admin/so/BD_UISOA0100");
		
		return mv;
	}
	
	/**
     * 사업지원 공개여부 변경 선택
     * 
     * @param request
     * @param model
     */    
	public ModelAndView disntceAtYN(Map<?, ?> rqstMap) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/so/PD_UISOA0101");
		
		return mv;
	}
	
	
	/**
	 * 선택 목록 사업지원 공개여부 변경
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView updatentceAtYN(Map<?, ?> rqstMap) throws Exception {	
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		HashMap jsonMap = new HashMap();
		int upt_cnt=0, succ_cnt=0, ret_cnt= 0;
		
		String ntceayn = MapUtils.getString(rqstMap, "ntceaynval");
		Object seq = MapUtils.getObject(rqstMap, "seqs");
		String[] seqs = null;
		
		if (seq instanceof String[]) {
			seqs = (String[]) seq;
		}else {
			seqs = new String[] {(String) seq};
		}
		
		param.put("ntceayn", ntceayn);	
		
		System.out.println(seqs.length);
		
		// 공개여부 수정
		for(String seq_item : seqs) {
			param.put("seq", seq_item);
			
			System.out.println(seq_item);
			upt_cnt++;
			
			if( (ret_cnt = pgsp0030Mapper.updateSuportntceAtYN(param)) > 0 )
			{
				succ_cnt += ret_cnt;
			}
			
		}
			
		jsonMap.put("upt_cnt", upt_cnt);					// 발급일자
		jsonMap.put("succ_cnt", succ_cnt);		// 유효기간시작일자
		return ResponseUtil.responseJson(mv, true, jsonMap);
	}
}
