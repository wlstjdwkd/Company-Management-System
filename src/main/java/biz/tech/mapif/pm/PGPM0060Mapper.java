package biz.tech.mapif.pm;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 프로그램 Mapper
 */
@Mapper("PGPM0060Mapper")
public interface PGPM0060Mapper {
	/**
	 * 세율 목록 조회
	 *
	 * @param param
	 * @return List<Map>
	 * @throws RuntimeException, Exception
	 */
	public List<Map> findTaxItmList(Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 세율 조회
	 *
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public Map findTaxItm(Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 세율 등록
	 * @param param 코드그룹정보
	 * @return int
	 * @throws RuntimeException, Exception
	 */
	public int insertTaxItm(Map<?, ?> param) throws RuntimeException, Exception;
		
	/**
	 * 세율 수정
	 * @param param 코드그룹정보
	 * @return int
	 * @throws RuntimeException, Exception
	 */
	public int updateTaxItm(Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 세율 삭제
	 * @param param 코드그룹정보
	 * @return int
	 * @throws RuntimeException, Exception
	 */
	public int deleteTaxItm(Map<?, ?> param) throws RuntimeException, Exception;
}