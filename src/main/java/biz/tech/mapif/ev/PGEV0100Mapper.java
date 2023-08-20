package biz.tech.mapif.ev;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 직원 평가 Mapper
 */
@Mapper("PGEV0100Mapper")
public interface PGEV0100Mapper {
	public int selectProgrmCnt (Map<?, ?> param) throws RuntimeException, Exception;
	
	public void insertEVA(Map<?, ?> param) throws RuntimeException, Exception;
	
	public Map<?, ?> findUsermember (Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 평가 조회
	 */
	public List<Map> findMember(Map<?, ?> param) throws RuntimeException, Exception;
	public List<Map> findEvaList(Map<?, ?> param) throws RuntimeException, Exception;

	public int findEvalist(Map<?, ?> param) throws RuntimeException, Exception;

}
