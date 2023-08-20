package biz.tech.ic;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import com.infra.util.ResponseUtil;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.ic.PGIC0031Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 기업확인>발급문서진위확인
 * 
 * @author KMY
 * 
 */
@Service("PGIC0031")
public class PGIC0031Service extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGIC0031Service.class);

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;
	
	@Autowired
	PGIC0031Mapper pgic0031Mapper;

	/**
	 * 위변조문서신고
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map param = new HashMap();
		
		String ad_documentNo_1 = MapUtils.getString(rqstMap, "ad_documentNo_1");
		String ad_documentNo_2 = MapUtils.getString(rqstMap, "ad_documentNo_2");
		String ad_documentNo_3 = MapUtils.getString(rqstMap, "ad_documentNo_3");
		String ad_documentNo_4 = MapUtils.getString(rqstMap, "ad_documentNo_4");
		
		param.put("ad_documentNo_1", ad_documentNo_1);
		param.put("ad_documentNo_2", ad_documentNo_2);
		param.put("ad_documentNo_3", ad_documentNo_3);
		param.put("ad_documentNo_4", ad_documentNo_4);
		
		mv.addObject("param", param);
		mv.setViewName("/www/ic/PD_UIICU0031");
		return mv;
	}
	
	public ModelAndView insertDocReport(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		
		String aplcntNm = MapUtils.getString(rqstMap, "ad_aplcntNm");
		String telNo = MapUtils.getString(rqstMap, "ad_mbtlNum");
		String docCrfirmNo = MapUtils.getString(rqstMap, "ad_docCrfirmNo");
		String acqsCrcmstncs = MapUtils.getString(rqstMap, "ad_acqsCrcmstncs");
		String email = MapUtils.getString(rqstMap, "ad_email");
		
		param.put("aplcntNm", aplcntNm);
		param.put("telNo", telNo);
		param.put("docCrfirmNo", docCrfirmNo);
		param.put("acqsCrcmstncs", acqsCrcmstncs);
		param.put("email", email);
		
		pgic0031Mapper.insertDocReport(param);
		
		return ResponseUtil.responseJson(mv, true);
	}

}
