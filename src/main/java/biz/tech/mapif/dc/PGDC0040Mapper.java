package biz.tech.mapif.dc;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 환율정보관리 Mapper
 * @author DST
 *
 */

@Mapper("PGDC0040Mapper")
public interface PGDC0040Mapper {
	
	/**
	 * 환율정보수집관리 목록
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public List<Map> findfxerMgrList(Map<?, ?> param) throws Exception;

	/**
	 * 환율정보수집관리 삭제
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public int deletfxerMgr(HashMap param);

	/**
	 * 환율정보 삭제
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public int deletfxerList(HashMap param);

	/**
	 * 환율수집 오류정보 조회
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public String findErrMsg(HashMap param);

	
	/**
	 * 환율정보 조회
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public List<Map> findfxerList(HashMap param);


	/**
	 * 환율코드정보 조회
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public List<Map> findfxercrncyCdList();

	
	/**
	 * 환율정보 Count 조회
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public int findfxerListCnt(HashMap param);

	
	/**
	 * Batch Job ID 조회
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public Map findBatchJobbyBatchNm(HashMap param);
	
}
