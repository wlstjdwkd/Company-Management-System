package biz.tech.mapif.dc;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 상호출자제한기업관리 Mapper
 * @author DST
 *
 */

@Mapper("PGDC0030Mapper")
public interface PGDC0030Mapper  {
	
	/**
	 *상호출자제한기업정보수집관리 목록
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public List<Map> findmiLimitMgrList(Map<?, ?> param) throws Exception;

	/**
	 * 상호출자제한기업정보수집관리 삭제
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public int deletmiLimitMgr(HashMap param);

	/**
	 * 상호출자제한기업정보 삭제
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public int deletmiLimitList(HashMap param);

	/**
	 * 상호출자제한기업수집 오류정보 조회
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public String findErrMsg(HashMap param);

	
	/**
	 * 상호출자제한기업정보 조회
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public List<Map> findmiLimitList(HashMap param);

	
	/**
	 * 상호출자제한기업정보 Count 조회
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public int findmiLimitListCnt(HashMap param);

		
	/**
	 * 상호출자제한기업정보 입력
	 * @param param	상호출자제한기업정보
	 * @return
	 * @throws Exception
	 */
	public void intsertLimit(HashMap param);

	
	/**
	 * 상호출자제한기업정보수집관리 입력
	 * @param param	상호출자제한기업정보
	 * @return
	 * @throws Exception
	 */
	public void insertmiLimitMgr(HashMap param);
	
}
