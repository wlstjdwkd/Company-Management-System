package biz.tech.mapif.pm;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("PGPM0070Mapper")
public interface PGPM0070Mapper {
	/**
	 * 메일 전송기록 조회
	 *
	 * @param param
	 * @return Map<?,?>
	 * @throws RuntimeException, Exception
	 */
	public Map<?,?> findSendLog(Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 선택한 기간의 특정 사원이 개인월급여 조회 
	 *
	 * @param param
	 * @return Map<?,?>
	 * @throws RuntimeException, Exception
	 */
	public List<Map> findIndvPayMnt(Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 급여 명세서 전송 기록 저장
	 * @param param 코드그룹정보
	 * @return int
	 * @throws RuntimeException, Exception
	 */
	public int insertSendLog(Map<?, ?> param) throws RuntimeException, Exception;
}