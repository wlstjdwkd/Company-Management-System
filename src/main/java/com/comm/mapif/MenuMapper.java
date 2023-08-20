package com.comm.mapif;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comm.menu.MenuVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 메뉴 Mapper
 */
@Mapper("menuMapper")
public interface MenuMapper {

	/**
	 * 사용자에게 할당된 메뉴목록 조회
	 *
	 * @param param 권한그룹코드 및 사이트구분
	 * @return 메뉴목록
	 * @throws RuntimeException, Exception
	 */
	public List<MenuVO> findUserMenu(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 화면이 없는 메뉴 번호 조회
	 *
	 * @return 메뉴 번호
	 * @throws RuntimeException, Exception
	 */
	public List<HashMap> findNoScreenMenu() throws RuntimeException, Exception;

	/**
	 * 메뉴 목록 갯수 조회
	 *
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int findMenuListCnt(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 하위메뉴 갯수 조회
	 *
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int findSubMenuCnt(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 메뉴 목록 조회
	 *
	 * @param param 조회범위 및 조회조건
	 * @return
	 */
	public List<Map> findMenuList(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 메뉴 정보 조회
	 *
	 * @param param 메뉴번호
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public Map findMenuInfo(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 출력순서 조회
	 *
	 * @param param 메뉴번호
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int findOutptOrdr(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 메뉴 등록
	 *
	 * @param param 메뉴정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int insertMenu(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 메뉴 수정
	 *
	 * @param param 메뉴번호
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateMenu(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * lastNodeAt 수정
	 *
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateLastNodeAt(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 메뉴 삭제
	 *
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int deleteMenu(Map<?, ?> param) throws RuntimeException, Exception;

}