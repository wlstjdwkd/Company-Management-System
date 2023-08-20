package biz.tech.mapif.pm;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 프로그램 Mapper
 */
@Mapper("PGPM0030Mapper")
public interface PGPM0030Mapper {
	/**
	 * 개인별 급여항목 조회
	 *
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public List<Map> findEmpPayList(Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 사원 목록 조회
	 *
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public List<Map> findEmpList(Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 급여 항목 확인
	 *
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public List<Map> chkPayItm(Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 급여항목 등록
	 * @param param 코드그룹정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int insertPayItm(Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 변동 내역 등록
	 * @param param 코드그룹정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int insertPayItmLog(Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 개인별 급여항목 수정
	 * @param param 코드그룹정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateEmpPay(Map<?, ?> param) throws RuntimeException, Exception;
}