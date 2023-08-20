package biz.tech.ts;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

@Service("PGTS0006")
public class PGTS0006Service {
private static final Logger logger = LoggerFactory.getLogger(PGTS0006Service.class);
	
	/**
	 * 인덱스
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {		
		ModelAndView mv = new ModelAndView();		
		mv.setViewName("/www/test/TS_kosis");		
		return mv;
	}
	
	/**
	 * 임포트
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView testImport(Map<?, ?> rqstMap) throws Exception {		
		ModelAndView mv = new ModelAndView();		
		mv.setViewName("/www/test/TS_kosis_import");	
		return mv;
	}
}
