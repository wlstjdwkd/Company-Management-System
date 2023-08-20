package biz.tech.js;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.code.CodeService;
import com.comm.code.CodeVO;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.js.PGJS0010Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


/**
 * 통계생성관리 서비스 클래스
 * 
 * @author sujong
 * 
 */
@Service("PGJS0010")
public class PGJS0010Service extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGJS0010Service.class);
	
	@Resource(name="messageSource")
	private MessageSource messageSource;
	
	@Resource(name = "PGJS0010Mapper")
	private PGJS0010Mapper pgjs0010Dao;
	
	@Resource(name = "codeService")
	private CodeService codeService;

	
	/**
	 * 판정기준 목록 조회
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/admin/js/BD_UIJSA0010");

		int crtYear = MapUtils.getIntValue(rqstMap, "ad_searchYear", 0);

		if (crtYear <= 0) return mv;

		HashMap param = new HashMap();

		// 자료기준년도, 시스템및 학정판정일자 조회
		param.put("stdyy", String.valueOf(--crtYear));
		
		mv.addObject("stdyy", MapUtils.getString(param, "stdyy"));
		mv.addObject("jdgmntManage", pgjs0010Dao.selectJdgmntManage(param));
		mv.addObject("statsOpertList", pgjs0010Dao.selectStatsOpertList(param));

		return mv;
	}
	
	/**
	 * 통계 프로시져 호출
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processStaticsSp(Map rqstMap) throws Exception {
		
		if (MapUtils.getString(rqstMap, "ad_stdyy", "").equals(""))
			throw processException("errors.required", new String[] { "기준년도" });
		if (MapUtils.getString(rqstMap, "ad_gubun", "").equals(""))
			throw processException("errors.required", new String[] { "실행구분" });
		if (MapUtils.getString(rqstMap, "ad_code", "").equals(""))
			throw processException("errors.required", new String[] { "통계구분" });
		
		HashMap param = new HashMap();
		
		param.put("stdyy", MapUtils.getString(rqstMap, "ad_stdyy"));
		param.put("code", MapUtils.getString(rqstMap, "ad_code"));
		param.put("gubun", MapUtils.getInteger(rqstMap, "ad_gubun"));
		
		int result = pgjs0010Dao.callStaticsSp(param);
		
		ModelAndView mv = index(rqstMap);
		
		if (result == 0) {
			mv.addObject("resultMsg", messageSource.getMessage("success.request.msg", new String[] {}, Locale.getDefault()));
		} else {
			mv.addObject("resultMsg", messageSource.getMessage("fail.common.sql", new String[] {String.valueOf(result), "통계생성SP 오류"}, Locale.getDefault()));
		}
		
		return mv;
	}
	
	/**
	 * 전체 통계 프로시져 호출
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView processAllStaticsSp(Map rqstMap) throws Exception {

		HashMap param = null;
		int result = -1;
		
		if (MapUtils.getString(rqstMap, "ad_stdyy", "").equals(""))
			throw processException("errors.required", new String[] { "기준년도" });
		if (MapUtils.getString(rqstMap, "ad_gubun", "").equals(""))
			throw processException("errors.required", new String[] { "실행구분" });

		List<CodeVO> codeList = codeService.findCodesByGroupNo("45");
		
		for(CodeVO code : codeList) {
			param = new HashMap();

			param.put("code", code.getCode());
			param.put("stdyy", MapUtils.getString(rqstMap, "ad_stdyy"));
			param.put("gubun", MapUtils.getInteger(rqstMap, "ad_gubun"));
			
			result = pgjs0010Dao.callStaticsSp(param);
		}

		ModelAndView mv = index(rqstMap);
		mv.addObject("resultMsg", messageSource.getMessage("success.request.msg", new String[] {}, Locale.getDefault()));
		
		return mv;
	}

}
