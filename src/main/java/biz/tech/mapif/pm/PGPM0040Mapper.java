package biz.tech.mapif.pm;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 프로그램 Mapper
 */
@Mapper("PGPM0040Mapper")
public interface PGPM0040Mapper {
	/**
	 * 급여 항목 확인
	 *
	 * @param param
	 * @return List<Map>
	 * @throws RuntimeException, Exception
	 */
	public List<Map> chkPayMnt(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 특정 기간 재직 사원 목록 조회
	 *
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public List<Map> findCurrEmpList(Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 사용 급여 항목
	 *
	 * @param param
	 * @return List<Map>
	 * @throws RuntimeException, Exception
	 */
	public List<Map> selectUseEmpPayList(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 사원별 급여 항목
	 *
	 * @param param
	 * @return List<Map>
	 * @throws RuntimeException, Exception
	 */
	public List<Map> selectIndvEmpPayList(Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 사원별 급여 항목
	 *
	 * @param param
	 * @return List<Map>
	 * @throws RuntimeException, Exception
	 */
	public List<Map> selectIndvEmpList(Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 월급여지급 등록
	 * @param param 코드그룹정보
	 * @return int
	 * @throws RuntimeException, Exception
	 */
	public int insertPayMnt(Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 월급여지급 수정
	 * @param param 코드그룹정보
	 * @return int
	 * @throws RuntimeException, Exception
	 */
	public int updatePayMnt(Map<?, ?> param) throws RuntimeException, Exception;
}