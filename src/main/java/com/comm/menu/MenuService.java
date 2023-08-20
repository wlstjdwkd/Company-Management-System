package com.comm.menu;

/**
 * 사용자 메뉴목록 조회 클래스
 */
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import com.comm.mapif.MenuMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import com.comm.user.UserVO;
import com.infra.util.SessionUtil;

@Service("menuService")
public class MenuService extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(MenuService.class);

	@Resource(name = "menuMapper")
	private MenuMapper menuDAO;

	/**
	 * 사용자 할당 메뉴 조회 DB에서 조회한 메뉴 데이터를 반환
	 *
	 * @param param
	 * 조회조건 Map
	 * @return
	 * @throws Exception
	 */
	public LinkedHashMap<String, MenuVO> findUserMenuList(Map<String, Object> param) throws RuntimeException, Exception {
		LinkedHashMap<String, MenuVO> result = new LinkedHashMap();
		List<MenuVO> list = menuDAO.findUserMenu(param);

		for (MenuVO vo : list) {
			result.put(String.valueOf(vo.getMenuNo()), vo);
		}

		return result;
	}

	/**
	 * 사용자 할당 메뉴 조회 DB에서 조회한 레코드를 카테고리 구조로 가공하여 반환
	 *
	 * @param param
	 * 조회조건 Map
	 * @return
	 * @throws Exception
	 */
	public LinkedHashMap<String, MenuVO> findUserMenuMap(Map<String, Object> param) throws RuntimeException, Exception {
		LinkedHashMap<String, MenuVO> result = new LinkedHashMap();
		LinkedHashMap<String, MenuVO> list = findUserMenuList(param);

		Iterator itr = list.keySet().iterator();

		while (itr.hasNext()) {
			String menuNo = (String) itr.next();

			MenuVO menu = list.get(menuNo);
			result.put(menuNo, menu);

			MenuVO pMenu = list.get(String.valueOf(menu.getParntsMenuNo()));
			if (pMenu != null)
				pMenu.addSubMenu(menu);
		}

		return result;
	}

	/**
	 * 화면이 없는 메뉴 번호 조회
	 *
	 * @return 메뉴번호 리스트
	 * @throws Exception
	 */
	@Cacheable(value = "noScreenMunuNo")
	public List<String> findNoScreenMenu() throws RuntimeException, Exception {
		List<HashMap> list = menuDAO.findNoScreenMenu();
		List<String> result = new ArrayList<String>();
		for (HashMap map : list) {
			result.add(MapUtils.getString(map, "menuNo"));
		}
		return result;
	}

	/**
	 * 메뉴 목록 갯수 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int findMenuListCnt(HashMap param) throws RuntimeException, Exception {
		int result = menuDAO.findMenuListCnt(param);
		return result;
	}

	/**
	 * 메뉴 목록 조회
	 *
	 * @param param
	 * 조회범위 및 조회조건
	 * @return
	 * @throws Exception
	 */
	public List<Map> findMenuList(HashMap param) throws RuntimeException, Exception {
		List<Map> result = menuDAO.findMenuList(param);
		return result;
	}

	/**
	 * 메뉴 정보 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map findMenuInfo(HashMap param) throws RuntimeException, Exception {
		Map result = menuDAO.findMenuInfo(param);
		return result;
	}

	/**
	 * 출력순서 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int findOutptOrdr(HashMap param) throws RuntimeException, Exception {
		int result = menuDAO.findOutptOrdr(param);
		return result;
	}

	/**
	 * 메뉴 등록/수정
	 *
	 * @param param
	 * @throws Exception
	 */
	@CacheEvict(value="noScreenMunuNo", allEntries = true)
	public void processMenu(Map<?, ?> param) throws RuntimeException, Exception {

		String lastNodeAt = (String) param.get("lastNodeAt");
		String parntsMenuDelete = (String) param.get("parntsMenuDelete");
		String insert_update = (String) param.get("insert_update");

		// 메뉴 등록할 때, 상위 메뉴 lastNodeAt Y -> N 변경
		if ("Y".equals(lastNodeAt.toUpperCase())) {
			if ("INSERT".equals(insert_update.toUpperCase())) {
				String p_lastNodeAt = "N";
				String p_parntsMenuNo = (String) param.get("parntsMenuNo");

				HashMap pParam = new HashMap();

				UserVO userVO = SessionUtil.getUserInfo();
				String userNo = userVO.getUserNo();

				pParam.put("lastNodeAt", p_lastNodeAt);
				pParam.put("updusr", userNo);
				pParam.put("parntsMenuNo", p_parntsMenuNo);

				menuDAO.updateLastNodeAt(pParam);
				menuDAO.insertMenu(param);
			}
			// 메뉴 수정
			else {
				menuDAO.updateMenu(param);
			}
		}
		// 메뉴 삭제할 때, 하위메뉴가 없는 상위 메뉴 lastNodeAt N -> Y 변경
		else if ("N".equals(lastNodeAt.toUpperCase())) {

			if (parntsMenuDelete == null) {
				menuDAO.updateMenu(param);
			} else if (insert_update == null && "DELETE".equals(parntsMenuDelete.toUpperCase())) {

				String p_lastNodeAt = "Y";
				String p_parntsMenuNo = (String) param.get("parntsMenuNo");

				HashMap pParam = new HashMap();

				pParam.put("lastNodeAt", p_lastNodeAt);
				pParam.put("parntsMenuNo", p_parntsMenuNo);
				menuDAO.updateLastNodeAt(pParam);

			} else if ("UPDATE".equals(insert_update.toUpperCase()) || insert_update != null) {
				menuDAO.updateMenu(param);
			}
		}
	}

	/**
	 * 메뉴 삭제
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@CacheEvict(value="noScreenMunuNo", allEntries = true)
	public int deleteMenu(Map<?, ?> param) throws RuntimeException, Exception {
		return menuDAO.deleteMenu(param);
	}

}