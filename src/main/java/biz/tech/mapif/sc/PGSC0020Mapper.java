package biz.tech.mapif.sc;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("PGSC0020Mapper")
public interface PGSC0020Mapper {
	
	/**
	 * 사원 식대 조회
	 * @param param 사용자 ID
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public List<Map> findUserMeal(Map<String, Object> param) throws RuntimeException, Exception;
}