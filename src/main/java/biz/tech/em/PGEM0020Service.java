package biz.tech.em;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.infra.file.FileDAO;
import com.infra.util.ResponseUtil;
import com.infra.web.GridCodi;

import biz.tech.mapif.em.PGEM0020Mapper;
//import biz.tech.pm.PGPM0020Service;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

@Service("PGEM0020")
public class PGEM0020Service extends EgovAbstractServiceImpl {
	private static final Logger logger = LoggerFactory.getLogger(PGEM0020Service.class);

	private Locale locale = Locale.getDefault();

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;
		
	@Resource(name = "filesDAO")
	private FileDAO fileDao;
	
	@Autowired
	PGEM0020Mapper PGEM0020Mapper;
	
	
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {		
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap<>();
		Calendar today = Calendar.getInstance();	// 현재 시간
		
		// 현재 년도를 받아 화면단에서 조회년도를 어디까지할 것인지 지정
		param.put("curr_year", String.valueOf(today.get(Calendar.YEAR)));
		param.put("curr_month", String.valueOf(today.get(Calendar.MONTH)));
		
		mv.addObject("frontParam",param);
		mv.setViewName("/admin/em/BD_UIEMA0020");

		return mv;
	}

	// 검색 
	public ModelAndView countSess(Map<?, ?> rqstMap) throws Exception {
	  ModelAndView mv = new ModelAndView();
	  Map param = new HashMap<>(); 
	  param = (Map<?, ?>) rqstMap;
	  
	  String search_year = MapUtils.getString(rqstMap, "search_year");
	  String search_month = MapUtils.getString(rqstMap, "search_month");
	  String search_year2 = MapUtils.getString(rqstMap, "search_year2");
	  String search_month2 = MapUtils.getString(rqstMap, "search_month2");
	  String department = MapUtils.getString(rqstMap, "department");
	  String ad_search_word = MapUtils.getString(rqstMap, "ad_search_word");
	  String limitFrom = MapUtils.getString(rqstMap, "limitFrom");
	  String limitTo =  MapUtils.getString(rqstMap, "limitTo");
	  
	  param.put("search_date1", search_year+"-"+search_month+"-15");
	  param.put("search_date2", search_year2+"-"+search_month2+"-15");
	  param.put("department", department);
	  param.put("ad_search_word", ad_search_word);
	  param.put("limitFrom", limitFrom);
	  param.put("limitTo", limitTo);
	  
	  logger.debug("========================= ad_search_word : "+ad_search_word);
	  
	  List<Map> userList = PGEM0020Mapper.docusearch(param);  
	  String count = GridCodi.MaptoJson(userList);
	  logger.debug("============================== userList : "+userList);
	  logger.debug("============================== count : "+count);
	  
	  return ResponseUtil.responseText(mv, count);
	 }
	
	// 수정 view
	public ModelAndView programModify(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		
		//윗단 
		String addocno = MapUtils.getString(rqstMap, "DOCU_NO");	
		param.put("addocno", addocno);
		
		Map<?, ?> TOPInfo = PGEM0020Mapper.modifydocuinfoTOP(param);
		mv.addObject("TOPInfo", TOPInfo);
		
			//부서명 찾기
		param.put("codeGroupNo", 89);
		param.put("code", TOPInfo.get("DEPART"));
		Map<?, ?> deptInfo = PGEM0020Mapper.findCmmnCode(param);
		mv.addObject("deptInfo", deptInfo);
		
		//아랫단
		String shdocno = addocno.substring(0, 6);
		HashMap botparam = new HashMap();
		botparam.put("shdocno", shdocno);
		List<Map> BOTInfo= new ArrayList<Map>();
		
		BOTInfo = PGEM0020Mapper.modifydocuinfoBOT(botparam);
		mv.addObject("BOTInfo", BOTInfo);
		
		mv.setViewName("/admin/em/BD_UIEMA0021");
		
		return mv;
	}
	
	// 수정
	public ModelAndView updateDOC(Map<?, ?> rqstMap) throws Exception {		
		
		// 윗단 업데이트
		HashMap expinfoTOP = new HashMap();
		
		String ad_docno = MapUtils.getString(rqstMap, "ad_docno");
		String departmentnm = MapUtils.getString(rqstMap, "departmentname");
		String ad_empnm = MapUtils.getString(rqstMap, "ad_empnm");
		String ad_date = MapUtils.getString(rqstMap, "ad_date");
		String tot_price = MapUtils.getString(rqstMap, "tot_price");
		
		HashMap param = new HashMap();
		param.put("codeGroupNo", 89);
		param.put("code_nm", departmentnm);
		Map<?, ?> deptInfo = PGEM0020Mapper.findCmmnCodebyname(param);
		String department = MapUtils.getString(deptInfo, "code");
		
		expinfoTOP.put("ad_docno", ad_docno);
		expinfoTOP.put("department", department);
		expinfoTOP.put("ad_empnm", ad_empnm);
		expinfoTOP.put("ad_date", ad_date);
		expinfoTOP.put("tot_price", tot_price);
		
		PGEM0020Mapper.upsertTOP(expinfoTOP);
				
		// 아랫단 업데이트(1개 행 upsert시 tdCount는 String, 2개이상 행 upsert시 tdCount는 String[])
//		try {
//			
//		}catch {
//			
//		}
		String[] tdCountstr = (String[]) rqstMap.get("tdCount");
		for(int i=0; i< tdCountstr.length; i++) {
			System.out.println("tdCountstr["+i+"]: "+tdCountstr[i]);
		}
		int tdCount = Integer.parseInt(tdCountstr[0]);
				  
		if (tdCount > 1) {
		  
		  String[] exp_no 	= (String[]) rqstMap.get("exp_no"); 
		  String[] exp_date = (String[]) rqstMap.get("exp_date");
		  String[] ad_item	= (String[]) rqstMap.get("ad_item");
		  String[] ad_shop	= (String[]) rqstMap.get("ad_shop");
		  String[] ad_price = (String[]) rqstMap.get("ad_price");
		  String[] ad_note	= (String[]) rqstMap.get("ad_note");
		  
		  HashMap expinfoBOT = new HashMap();
		  
		  for(int i=0; i < tdCount; i++) { 
			 expinfoBOT.clear();
			 System.out.println("비어있는지 체크: "+ expinfoBOT.isEmpty());
		  
			 expinfoBOT.put("exp_no", exp_no[i]);
			 expinfoBOT.put("exp_date", exp_date[i]);
			 expinfoBOT.put("ad_item", ad_item[i]);
			 expinfoBOT.put("ad_shop", ad_shop[i]);
			 expinfoBOT.put("ad_price", ad_price[i]); 
			 expinfoBOT.put("ad_note", ad_note[i]);
			 
			 if(!exp_no[i].isEmpty() && ad_price[i]== "0") {
				 PGEM0020Mapper.upsertBOT(expinfoBOT); 
			}
			 
		  } 
		  
		}else if (tdCount >0) {
			String exp_no = MapUtils.getString(rqstMap, "exp_no");
			String exp_date = MapUtils.getString(rqstMap, "exp_date");
			String ad_item = MapUtils.getString(rqstMap, "ad_item");
			String ad_shop = MapUtils.getString(rqstMap, "ad_shop");
			String ad_price = MapUtils.getString(rqstMap, "ad_price");
			String ad_note = MapUtils.getString(rqstMap, "ad_note");
			
			HashMap expinfoBOT = new HashMap();
			expinfoBOT.put("exp_no", exp_no);
			expinfoBOT.put("exp_date", exp_date);
			expinfoBOT.put("ad_item", ad_item);
			expinfoBOT.put("ad_shop", ad_shop);
			expinfoBOT.put("ad_price", ad_price);
			expinfoBOT.put("ad_note", ad_note);
			
			PGEM0020Mapper.upsertBOT(expinfoBOT);
		}
		
		//아랫단 삭제 열 처리
		String delinfo 	= MapUtils.getString(rqstMap,"delinfo"); 
		System.out.println("delinfo: "+delinfo);
		List<String> Delinfos = new ArrayList<>(Arrays.asList(delinfo.split(",")));
		
		Delinfos.removeAll(Arrays.asList(""));
		System.out.println("Delinfos: "+Delinfos+", type: "+Delinfos.getClass().getName());
		
		HashMap delinfoBOT = new HashMap();
		for(int i=0; i < Delinfos.size(); i++) {
			delinfoBOT.clear();
			
			String bot_docuno = Delinfos.get(i);
			delinfoBOT.put("bot_docuno", bot_docuno);
			
			PGEM0020Mapper.deleteBOTrow(delinfoBOT);
		}
		
		ModelAndView mv = index(rqstMap);
		return mv;
	}
	
	//전체 삭제
	public ModelAndView deleteAll(Map<?, ?> rqstMap) throws Exception {		
		
		// 윗단 삭제
		HashMap expinfoTOP = new HashMap();
		String ad_docno = MapUtils.getString(rqstMap, "ad_docno");
		expinfoTOP.put("top_docuno", ad_docno);
		PGEM0020Mapper.deleteTOP(expinfoTOP);
						
		// 아랫단 삭제
		PGEM0020Mapper.deleteBOT(expinfoTOP);
		
		ModelAndView mv = index(rqstMap);
		return mv;
	}	
}
