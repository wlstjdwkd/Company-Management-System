package biz.tech.mapif.dc;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 기업직간접소유현황관리 Mapper
 * @author DST
 *
 */

@Mapper("PGDC0080Mapper")
public interface PGDC0080Mapper  {
	
	/**
	 *기업직간접소유현황정보수집관리 목록
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public List<Map> findrelPossessionMgrList(Map<?, ?> param) throws Exception;

	/**
	 * 기업직간접소유현황정보수집관리 삭제
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public int deletrelPossessionMgr(HashMap param);

	/**
	 * 기업직간접소유현황정보 삭제
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public int deletrelPossessionList(HashMap param);

	/**
	 * 기업직간접소유현황수집 오류정보 조회
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public String findErrMsg(HashMap param);

	
	/**
	 * 기업직간접소유현황정보 조회
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public List<Map> findrelPossessionList(HashMap param);

	
	/**
	 * 기업직간접소유현황정보 Count 조회
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public int findrelPossessionListCnt(HashMap param);

		
	/**
	 * 기업직간접소유현황정보 입력
	 * @param param	상호출자제한기업정보
	 * @return
	 * @throws Exception
	 */
	public void intsertrelPossession(HashMap param);

	
	/**
	 * 기업직간접소유현황정보수집관리 입력
	 * @param param	상호출자제한기업정보
	 * @return
	 * @throws Exception
	 */
	public void insertrelPossessionMgr(HashMap param);
	
}
