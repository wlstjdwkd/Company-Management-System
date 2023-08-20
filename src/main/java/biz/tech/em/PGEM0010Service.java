package biz.tech.em;

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
//import biz.tech.pm.PGPM0010Service;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

@Service("PGEM0010")
public class PGEM0010Service extends EgovAbstractServiceImpl {
	private static final Logger logger = LoggerFactory.getLogger(PGEM0010Service.class);

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
		mv.setViewName("/admin/em/BD_UIEMA0010");

		return mv;
	}
		
	//등록
	public ModelAndView insertDOC(Map<?, ?> rqstMap) throws Exception {		

		HashMap expinfoTOP = new HashMap();
		
		String ad_docno = MapUtils.getString(rqstMap, "ad_docno");
		String department = MapUtils.getString(rqstMap, "department");
		String ad_empnm = MapUtils.getString(rqstMap, "ad_empnm");
		String ad_date = MapUtils.getString(rqstMap, "ad_date");
		String tot_price = MapUtils.getString(rqstMap, "tot_price");
		
		expinfoTOP.put("ad_docno", ad_docno);
		expinfoTOP.put("department", department);
		expinfoTOP.put("ad_empnm", ad_empnm);
		expinfoTOP.put("ad_date", ad_date);
		expinfoTOP.put("tot_price", tot_price);
		try {
			PGEM0020Mapper.insertTOP(expinfoTOP);
			
		}catch(Exception ex) {
			ex.printStackTrace();
			//alert("잘못되거나 있는 번호입니다. 다른 번호로 등록해주세요.");
		}
		
		
		// 아랫단 등록
		String tdCountstr = MapUtils.getString(rqstMap, "tdCount");
		int tdCount = Integer.parseInt(tdCountstr);
		System.out.println("tdCount 체크: "+ tdCount);
		
		if (tdCount > 1) {
			
			String[] exp_no = (String[]) rqstMap.get("exp_no");
			String[] exp_date = (String[]) rqstMap.get("exp_date");
			String[] ad_item = (String[]) rqstMap.get("ad_item");
			String[] ad_shop = (String[]) rqstMap.get("ad_shop");
			String[] ad_price = (String[]) rqstMap.get("ad_price");
			String[] ad_note = (String[]) rqstMap.get("ad_note");
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
				
				if(!exp_no[i].isEmpty()) {
					PGEM0020Mapper.insertBOT(expinfoBOT);
				}
			}
		}else if(tdCount >0) {
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
			
			PGEM0020Mapper.insertBOT(expinfoBOT);
		}
		
		
		ModelAndView mv = index(rqstMap);
		return mv;

	}
}
