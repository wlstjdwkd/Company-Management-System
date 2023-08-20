package biz.tech.cs;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.menu.MenuService;
import com.comm.menu.MenuVO;
import com.comm.user.UserVO;
import com.infra.system.GlobalConst;
import com.infra.util.JsonUtil;
import com.infra.util.SessionUtil;
import com.infra.util.Validate;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

@Service("PGCS0090")
public class PGCS0090Service extends EgovAbstractServiceImpl
{
	private static final Logger logger = LoggerFactory.getLogger(PGCS0090Service.class);
	private Locale locale = Locale.getDefault();
	
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	@Autowired
	MenuService menuService;
	
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/www/cs/BD_UICSU0090");
		String[] allAuthGrp = {"9999", GlobalConst.AUTH_DIV_PUB, GlobalConst.AUTH_DIV_BIZ, GlobalConst.AUTH_DIV_ENT};
		
		Map param = new HashMap<String, Object>();
		
		param.put("authorGrpCd", allAuthGrp);		
		LinkedHashMap<String, MenuVO> menu = menuService.findUserMenuMap(param);
		
		UserVO userVO = SessionUtil.getUserInfo();		
		if(Validate.isEmpty(userVO)) {
			param.put("authorGrpCd", propertiesService.getStringArray("annymsGroupCd"));
		}else {
			param.put("authorGrpCd", userVO.getAuthorGroupCode());
		}
		Map authMenu = menuService.findUserMenuList(param);
		
		mv.addObject("menuMap", menu);
		mv.addObject("authMenu", JsonUtil.toJson(authMenu));
		return mv;
	}
}
