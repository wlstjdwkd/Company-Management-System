package biz.tech.im;

import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("PGIM0050")
public class PGIM0050Service extends EgovAbstractServiceImpl{
	
	public ModelAndView index(Map<? , ?> rqstMap) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/admin/im/BD_UIIMA0050");
		
		return mv;
	}
}