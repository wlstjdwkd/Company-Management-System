package biz.tech.ts;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.menu.MenuService;
import com.comm.page.Pager;
import com.infra.util.ResponseUtil;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.test.TestMapper;

@Service("PGTS0003")
public class PGTS0003Service {
private static final Logger logger = LoggerFactory.getLogger(MenuService.class);
	
	@Resource(name="testMapper")
	private TestMapper testDAO;
	
	/**
	 * 테스트
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {				
		
		Object obj1 = MapUtils.getObject(rqstMap, "mSelGridGrp_1");
		Object obj2 = MapUtils.getObject(rqstMap, "mSelGridGrp_2");
		String[] sArr1 = (String[])obj1;
		String[] sArr2 = (String[])obj2;
		
		logger.debug("@@@@@@@@@@" + sArr1.toString());
		logger.debug(String.valueOf(sArr1.length));
		for(String a : sArr1) {
			logger.debug(a);
		}
		
		logger.debug("@@@@@@@@@@" + sArr2.toString());
		logger.debug(String.valueOf(sArr2.length));
		for(String a : sArr2) {
			logger.debug(a);
		}
		
		
		ModelAndView mv = new ModelAndView();			
		mv.setViewName("/www/test/TS_index");
		
		return mv;
	}
	
	/**
	 * TEXT Resolver 테스트
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView textRsolver(Map<?, ?> rqstMap) throws Exception {	

		ModelAndView mv = new ModelAndView();
		return ResponseUtil.responseText(mv);
	}
}
