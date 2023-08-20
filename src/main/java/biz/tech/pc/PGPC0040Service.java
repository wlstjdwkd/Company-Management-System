package biz.tech.pc;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;


/**
 * 기업실태조사
 * 
 * 
 */
@Service("PGPC0040")
public class PGPC0040Service {
	private static final Logger logger = LoggerFactory.getLogger(PGPC0040Service.class);
	
	/**
	 * 기업실태조사
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {		
		ModelAndView mv = new ModelAndView();		
		mv.setViewName("/www/pc/BD_UIPCU0040");		
		return mv;
	}
	
	/**
	 * 실태조사 임포트
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView kosisImport(Map<?, ?> rqstMap) throws Exception {		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/www/pc/INC_UIPCU0041");	
		return mv;
	}
}

