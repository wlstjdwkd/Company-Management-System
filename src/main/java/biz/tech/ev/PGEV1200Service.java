package biz.tech.ev;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.infra.file.FileDAO;

import biz.tech.mapif.ev.PGEV1200Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

@Service("PGEV1200")
public class PGEV1200Service extends EgovAbstractServiceImpl  {
	private static final Logger logger = LoggerFactory.getLogger(PGEV1200Service.class);

	private Locale locale = Locale.getDefault();

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;

	@Resource(name = "filesDAO")
	private FileDAO fileDao;

	@Autowired
	PGEV1200Mapper PGEV1200Mapper;
	
	//초기 실행
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception{
		ModelAndView mv = new ModelAndView();
		Map param = new HashMap<>();
		param = (Map<?, ?>) rqstMap;
		
		mv.setViewName("/admin/ev/BD_UIEVA1210");
		
		return mv;
	}
}
