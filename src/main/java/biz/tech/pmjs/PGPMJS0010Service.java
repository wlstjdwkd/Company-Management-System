package biz.tech.pmjs;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.infra.file.FileDAO;
import com.infra.util.ResponseUtil;
import com.infra.util.Validate;
import com.infra.web.GridCodi;

import biz.tech.mapif.pmjs.PGPMJS0010Mapper;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 직원등록조회  
 *
 * 조회 / 등록 / 수정 / 비활성(재직여부 = N)
 */
@Service("PGPMJS0010")
public class PGPMJS0010Service extends EgovAbstractServiceImpl {
	private static final Logger logger = LoggerFactory.getLogger(PGPMJS0010Service.class);
	
	private Locale locale = Locale.getDefault();
	
	@Resource(name= "propertiesService")
	private EgovPropertyService propertiesService;
	
	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	@Autowired
	PGPMJS0010Mapper PGPMJS0010Mapper;
	
	@Resource(name = "filesDAO")
	private FileDAO fileDao;
	
	/**
	 * 회원관리 회원 리스트 검색
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception{
		ModelAndView mv = new ModelAndView();
		Map param = new HashMap<>();
		
		String initSearchYn = MapUtils.getString(rqstMap, "init_search_yn");
		
		List<Map> userList=null;
		if(Validate.isNotEmpty(initSearchYn)) {
			userList= PGPMJS0010Mapper.membersearch(param);
		}
		
		mv.addObject("userList", userList);
		mv.setViewName("/admin/pmjs/BD_UIPMJSA0010");
		
		return mv;
	}
	
	//등록 창 띄우기
	
	//수정/삭제 View 띄우기
	
	//등록 및 수정
	
	//프로그램, 권한 정보 삭제
	
	/**
	 * 근무형태 찾기 팝업 띄우기
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	
	/**
	 * 직급 찾기 팝업 띄우기
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	
	/**
	 * 부서 찾기 팝업 띄우기
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	
	//근무형태 리스트
	
	//직급 리스트
	
	//부서 리스트
	
	//리얼그리드로 db 불러오기
	public ModelAndView countSess(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map param = new HashMap<>();
		param = (Map<?, ?>) rqstMap;
		
		String ad_search_word = MapUtils.getString(rqstMap, "ad_search_word");
		String limitFrom = MapUtils.getString(rqstMap, "limitFrom");
		String limitTo = MapUtils.getString(rqstMap, "limitTo");
		
		param.put("ad_search_word", ad_search_word);
		param.put("limitFrom", limitFrom);
		param.put("limitTo", limitTo);
		
		logger.debug("============== ad_search_word : "+ad_search_word);
		
		List<Map> userList = PGPMJS0010Mapper.membersearch(param);
		String count = GridCodi.MaptoJson(userList);
		logger.debug("============== userList : "+ userList);
		
		return ResponseUtil.responseText(mv,count);
	}
}
