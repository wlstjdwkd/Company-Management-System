package biz.tech.mapif.dc;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 주가정보관리 Mapper
 * @author DST
 *
 */

@Mapper("PGDC0050Mapper")
public interface PGDC0050Mapper {
	
	/**
	 * 주가정보수집관리 목록
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public List<Map> findStkpcMgrList(Map<?, ?> param) throws Exception;

	/**
	 * 주가정보수집관리 삭제
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public int deletStkpcMgr(HashMap param);

	/**
	 * 주가정보 삭제
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public int deletStkpcPcList(HashMap param);

	/**
	 * 주가수집 오류정보 조회
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public String findErrMsg(HashMap param);

	
	/**
	 * 주가정보 조회
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public List<Map> findStkpcList(HashMap param);

	
	/**
	 * 주가정보 Count 조회
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public int findStkpcListCnt(HashMap param);

	
	/**
	 * Batch Job ID 조회
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public Map findBatchJobbyBatchNm(HashMap param);
	
}
