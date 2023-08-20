package biz.tech.um;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import com.comm.menu.MenuService;
import com.comm.menu.MenuVO;
import com.comm.user.AuthorityVO;
import com.comm.user.UserService;
import com.infra.util.SessionUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.my.ApplyMapper;
import biz.tech.mapif.pc.PGPC0030Mapper;
import biz.tech.mapif.um.PGUM0001Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 메인
 * 
 * @author JGS
 * 
 */
@Service("PGUM0001")
public class PGUM0001Service extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGUM0001Service.class);

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "PGUM0001Mapper")
	PGUM0001Mapper PGUM0001DAO;

	@Resource(name = "PGPC0030Mapper")
	PGPC0030Mapper PGPC0030DAO;
	
	@Resource(name="applyMapper")
	private ApplyMapper applyMapper;

	@Autowired
	UserService userService;

	@Autowired
	MenuService menuService;

	/**
	 * INDEX 화면 출력
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {

		// 전체 기업규모, 업종별 기업 쿼리에 사용할 파라미터
		// HashMap param = new HashMap();
		ModelAndView mv = new ModelAndView("/www/um/BD_UIUMU0001");
		// List<Map> mainPointList = new ArrayList();		
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();		

		//기업 규모별 비중 최근년도
		// int latelyYear = PGUM0001DAO.findMaxStdyy();
		// param.put("stdyyDo", latelyYear);

		//PI1 = 기업수
		// param.put("phaseIx", "PI1");
		// mv.addObject("nEntrprs", PGUM0001DAO.findEntrprSize(param));
		//PI4 = 수출액
		// param.put("phaseIx", "PI4");
		// mv.addObject("export", PGUM0001DAO.findEntrprSize(param));
		//PI5 = 고용
		// param.put("phaseIx", "PI5");
		// mv.addObject("employ", PGUM0001DAO.findEntrprSize(param));

		// 데이터 들어가면 수정해야함 (-2) 로
		// 2년전부터 현재 년도 기업 통계 값 가져오기
		//기업 통계 최근년도
		// int latelyYear2 = PGPC0030DAO.findMaxStdyy();
		// for (int i = latelyYear2 - 4; i <= latelyYear2; i++) {
		// 	param.put("stdyyDo", i);
		// 	mainPointList.add(PGPC0030DAO.findMainPoint(param));
		// }
		
		
		// Map result = new HashMap();
		
		// 필터에 저장된 항목들을 가져와 배열로 넘겨 NOT IN 처리한다.
		// 필터항목들 검색
		// 필터 검색
		// String temp = null;
		// param.put("ad_select", "a");
		// result = applyMapper.findFilter(param);
		// if( result != null) {
		// 	temp = result.get("ATRB").toString();
		// 	String[] array_filterListA = temp.split(",");
		// 	param.put("array_filterListA", array_filterListA);	// xml에서 사용될 배열
		// 	param.put("tempA", temp);
		// }
		// param.put("ad_select", "b");
		// result = applyMapper.findFilter(param);
		// if( result != null) {
		// 	temp = result.get("ATRB").toString();
		// 	String[] array_filterListB = temp.split(",");
		// 	param.put("array_filterListB", array_filterListB);	// xml에서 사용될 배열
			// 	param.put("tempB", temp);
		// }
		// param.put("ad_select", "c");
		// result = applyMapper.findFilter(param);
		// if( result != null) {
		// 	String stringfilterListC = result.get("ATRB").toString();
		// 	param.put("stringfilterListC", stringfilterListC);	// xml에서 사용될 배열
		// }
		
		
		
		//기업 규모별 비중 최근년도
		// mv.addObject("latelyYear", latelyYear);
		//기업 통계 최근년도
		// mv.addObject("latelyYear2", latelyYear2);
		// mv.addObject("noticeInfoList", PGUM0001DAO.findNoticeInfo());
		// mv.addObject("rssInfoList", PGUM0001DAO.findRssInfo());
		// mv.addObject("empmnInfoList", PGUM0001DAO.findEmpmnInfo(param));
		// mv.addObject("mainPointList", mainPointList);
		// mv.addObject("latelyYear", latelyYear);
		mv.addObject("isHttps", request.isSecure());

		return mv;
	}

	/**
	 * Anonymous 권한 설정
	 * 
	 * @throws Exception
	 */
	public void setAnonymousInfo() throws Exception {

		HashMap<String, Object> param = new HashMap();
		param.put("authorGrpCd", propertiesService.getStringArray("annymsGroupCd"));

		// 사용자 권한조회 및 세션설정
		HashMap<String, AuthorityVO> auth = userService.findUserAuthority(param);
		SessionUtil.setAuthInfo(auth, propertiesService.getInt("session.timeout"));

		// 비로그인 사용자 메뉴조회 및 세션설정
		LinkedHashMap<String, MenuVO> list = menuService.findUserMenuMap(param);
		SessionUtil.setMenuInfo(list, propertiesService.getInt("session.timeout"));
	}
}
