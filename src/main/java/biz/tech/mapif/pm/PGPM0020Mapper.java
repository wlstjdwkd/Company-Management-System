package biz.tech.mapif.pm;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 프로그램 Mapper
 */
@Mapper("PGPM0020Mapper")
public interface PGPM0020Mapper {
	/**
	 * 급여항목mst 목록조회
	 *
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public List<Map> findPayItmMstList(Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 급여항목mst 조회
	 *
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public Map findPayItmMst(Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 급여항목mst 등록
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int insertPayItmMst(Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 급여항목mst 수정
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updatePayItemMst(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 급여항목mst 수정
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int deletePayItemMst(Map<?, ?> param) throws RuntimeException, Exception;
}