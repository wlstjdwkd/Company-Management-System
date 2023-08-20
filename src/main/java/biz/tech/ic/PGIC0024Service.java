package biz.tech.ic;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.menu.MenuService;
import com.comm.menu.MenuVO;
import com.comm.user.AuthorityVO;
import com.comm.user.EntUserVO;
import com.comm.user.UserService;
import com.comm.user.UserVO;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.Validate;
import biz.tech.um.PGUM0001Service;

import org.apache.commons.collections.MapUtils;
import org.springframework.util.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 기업확인>기업확인신청
 * 
 * @author JGS
 * 
 */
@Service("PGIC0024")
public class PGIC0024Service extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGIC0024Service.class);

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;


	/**
	 * 신청완료
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		EntUserVO entUserVo = SessionUtil.getEntUserInfo();
		
		if(Validate.isEmpty(entUserVo)) {				
			throw processException("fail.common.session");
		}
		
		return new ModelAndView("/www/ic/BD_UIICU0024");
	}

}
