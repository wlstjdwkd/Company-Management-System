package biz.tech.mapif.pm;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 프로그램 Mapper
 */
@Mapper("PGPM0050Mapper")
public interface PGPM0050Mapper {
	/**
	 * 해당년 월별 급여 조회
	 *
	 * @param param
	 * @return List<Map>
	 * @throws RuntimeException, Exception
	 */
	public List<Map> selectMntPay(Map<?, ?> param) throws RuntimeException, Exception;
}