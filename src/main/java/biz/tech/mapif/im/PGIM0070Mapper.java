package biz.tech.mapif.im;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 기업직간접소유현황관리 Mapper
 * @author DST
 *
 */

@Mapper("PGIM0070Mapper")
public interface PGIM0070Mapper  {
	
	/**
	 *기업직간접소유현황 수집내역 목록
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public List<Map> findrelPossessionMgrList(Map<?, ?> param) throws Exception;
	

	/**
	 * 기업직간접소유현황 수집내역 삭제
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public int deletrelPossessionMgr(HashMap param);
	

	/**
	 * 기업직간접소유현황 정보 삭제
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public int deletrelPossessionList(HashMap param);
	

	/**
	 * 기업직간접소유현황 수집내역 오류 조회
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public String findErrMsg(HashMap param);
	

	/**
	 * 기업직간접소유현황 정보 내용 조회
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public List<Map> findrelPossessionList(HashMap param);
	

	/**
	 * 기업직간접소유현황 정보 Count 조회
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public int findrelPossessionListCnt(HashMap param);
	

	/**
	 * 기업직간접소유현황 정보 입력
	 * @param param	상호출자제한기업정보
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public void intsertrelPossession(HashMap param);

	
	/**
	 * 기업직간접소유현황 수집내역 입력
	 * @param param	상호출자제한기업정보
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public void insertrelPossessionMgr(HashMap param);
	
}