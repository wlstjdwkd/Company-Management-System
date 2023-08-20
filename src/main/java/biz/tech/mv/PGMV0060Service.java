package biz.tech.mv;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.infra.util.ResponseUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.sp.PGSP0030Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 기업정책 > 지원사업 (Mobile)
 * 
 * @author KMY
 *
 */
@Service("PGMV0060")
public class PGMV0060Service extends EgovAbstractServiceImpl{
	
	private static final Logger logger = LoggerFactory.getLogger(PGMV0060Service.class);
	
	@Autowired
	private PGSP0030Mapper pgsp0030Mapper;
	
	/**
	 * 지원사업 리스트화면
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<?,?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		ModelAndView mv = new ModelAndView();
		String moreList = MapUtils.getString(rqstMap, "ad_moreList");
		
		String searchKeyword = MapUtils.getString(rqstMap, "searchKeyword");
		String searchCondition = MapUtils.getString(rqstMap, "searchCondition");
		
		param.put("searchKeyword", searchKeyword);
		param.put("searchCondition", searchCondition);
		param.put("ntceAt", "Y");
		
		// Tab 구분 설정
		String tabGb = MapUtils.getString(rqstMap, "tabGb");
		if(tabGb != null) {
			param.put("tabGb", tabGb);
		} else {
			param.put("tabGb", "A");
		}
		
		// 총 프로그램 갯수
		int totalRowCnt = pgsp0030Mapper.findSuportListCnt(param);
		
		param.put("cnt", totalRowCnt);
		
		Map numMap = new HashMap();
		String num = null;
		
		// 첫화면 리스트
		if(Validate.isEmpty(moreList)) {
			param.put("limitFrom", 0);
			param.put("limitTo", 10);
		}
		else {
			String ad_ajax = MapUtils.getString(rqstMap, "ad_ajax");
		
			// 더보기 버튼을 눌렀을 때
			if(Validate.isNotEmpty(ad_ajax)) {
				int limitFrom = MapUtils.getIntValue(rqstMap, "ad_limitFrom");
				param.put("limitFrom", limitFrom);
				param.put("limitTo", totalRowCnt);
				
				// 프로그램 글 조회
				List<Map> suportMoreList = pgsp0030Mapper.findSuportList(param);
				
				for(int i=0; i<suportMoreList.size(); i++) {
					if(Validate.isNull(suportMoreList.get(i).get("opertnBginde"))) {
						num="";
					}
					else {
						numMap = StringUtil.toDateFormat((String) suportMoreList.get(i).get("opertnBginde"));
						if(Validate.isNotEmpty(numMap.get("middle"))) {
						num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last");
						}
						suportMoreList.get(i).put("opertnBginde", num);
					}
					
					if(Validate.isNull(suportMoreList.get(i).get("opertnEndde"))) {
						num="";
					}
					else {
						numMap = StringUtil.toDateFormat((String) suportMoreList.get(i).get("opertnEndde"));
						if(Validate.isNotEmpty(numMap.get("middle"))) {
							num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last");
						}
						suportMoreList.get(i).put("opertnEndde", num);
					}
				}
				
				return ResponseUtil.responseJson(mv,true, suportMoreList);
			}
			else {
					int limitFrom = MapUtils.getIntValue(rqstMap, "ad_limitFrom");
					param.put("limitFrom", limitFrom);
					param.put("limitTo", totalRowCnt);
					
					// 프로그램 글 조회
					List<Map> suportMoreList = pgsp0030Mapper.findSuportList(param);
					
					for(int i=0; i<suportMoreList.size(); i++) {
						if(Validate.isNull(suportMoreList.get(i).get("opertnBginde"))) {
							num="";
						}
						else {
							numMap = StringUtil.toDateFormat((String) suportMoreList.get(i).get("opertnBginde"));
							if(Validate.isNotEmpty(numMap.get("middle"))) {
							num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last");
							}
							suportMoreList.get(i).put("opertnBginde", num);
						}
						
						if(Validate.isNull(suportMoreList.get(i).get("opertnEndde"))) {
							num="";
						}
						else {
							numMap = StringUtil.toDateFormat((String) suportMoreList.get(i).get("opertnEndde"));
							if(Validate.isNotEmpty(numMap.get("middle"))) {
								num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last");
							}
							suportMoreList.get(i).put("opertnEndde", num);
						}
					}
					
					mv.addObject("suportList", suportMoreList);
					mv.addObject("inparam",param);
					mv.setViewName("/mobile/mv/BD_UIMVU0060");
					return mv;
			}
		}
		// 프로그램 글 조회
		List<Map> suportList = pgsp0030Mapper.findSuportList(param);
		
		for(int i=0; i<suportList.size(); i++) {
			if(Validate.isNull(suportList.get(i).get("opertnBginde"))) {
				num="";
			}
			else {
				numMap = StringUtil.toDateFormat((String) suportList.get(i).get("opertnBginde"));
				if(Validate.isNotEmpty(numMap.get("middle"))) {
				num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last");
				}
				suportList.get(i).put("opertnBginde", num);
			}
			
			if(Validate.isNull(suportList.get(i).get("opertnEndde"))) {
				num="";
			}
			else {
				numMap = StringUtil.toDateFormat((String) suportList.get(i).get("opertnEndde"));
				if(Validate.isNotEmpty(numMap.get("middle"))) {
					num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last");
				}
				suportList.get(i).put("opertnEndde", num);
			}
		}
		
		mv.addObject("suportList", suportList);
		mv.addObject("inparam",param);
		mv.setViewName("/mobile/mv/BD_UIMVU0060");
		return mv;
	}
}
