package biz.tech.ic;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import com.infra.util.ResponseUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.ic.PGIC0030Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 기업확인
 * 
 * @author KMY
 * 
 */
@Service("PGIC0030")
public class PGIC0030Service extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGIC0030Service.class);

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Autowired
	PGIC0030Mapper pgic0030Mapper;
	
	/**
	 * 발급문서진위확인
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		return new ModelAndView("/www/ic/BD_UIICU0030");
	}
	
	
	/**
	 * 발급문서진위확인 조회
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView checkDocumnet(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		HashMap jsonMap = new HashMap();
		
		String documentNo = MapUtils.getString(rqstMap, "ad_documentNo");
			
		param.put("DOC_CNFIRMNO", documentNo);
		Map issuInfo = pgic0030Mapper.findIssuDocument(param);
				
		// 문서정보 없음
		if(Validate.isEmpty(issuInfo)) {
			jsonMap.put("reason", "noDocument");
			return ResponseUtil.responseJson(mv, false, jsonMap);
		}
		else {
			Map issuDe = StringUtil.toDateFormat((String) issuInfo.get("issuDe"));
			Map validBeginDe = StringUtil.toDateFormat((String) issuInfo.get("validBeginDe"));
			Map validEndDe = StringUtil.toDateFormat((String) issuInfo.get("validEndDe"));
			
			jsonMap.put("issuDe", issuDe);					// 발급일자
			jsonMap.put("validBeginDe", validBeginDe);		// 유효기간시작일자
			jsonMap.put("validEndDe", validEndDe);			// 유효기간마지막일자
			jsonMap.put("issuInfo", issuInfo);				// 문서확인번호, 발급번호
			return ResponseUtil.responseJson(mv, true, jsonMap);
		}
	}
}
