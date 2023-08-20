package com.comm;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.menu.MenuService;
import com.comm.menu.MenuVO;
import com.comm.user.AuthorityVO;
import com.comm.user.UserService;
import com.comm.user.UserVO;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
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
 * 우편번호검색
 * 
 * @author JGS
 * 
 */
@Service("PGCM0004")
public class PGCM0004Service extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGCM0004Service.class);
	
	/**
	 * 우편번호검색 화면 출력
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		return new ModelAndView("/cmm/PD_UICMC0004");
	}	
	
}
