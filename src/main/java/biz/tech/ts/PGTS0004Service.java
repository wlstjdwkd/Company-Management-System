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

@Service("PGTS0004")
public class PGTS0004Service {
private static final Logger logger = LoggerFactory.getLogger(MenuService.class);
	
	/**
	 * 차트 테스트
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		
		ModelAndView mv = new ModelAndView();			
		mv.setViewName("/www/test/TS_chart");
		
		return mv;
	}
}
