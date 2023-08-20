package biz.tech.mapif.pc;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


@Mapper("PGPC0030Mapper")
public interface PGPC0030Mapper {
	
	// 최근 년도 구하기
	public int findMaxStdyy() throws Exception;

	
	// 연도별 주요 지표 찾기
	public Map<?,?> findMainPoint(Map<?,?> param) throws Exception;
	
	
	// 연도별 업무별 지표 찾기
	public Map<?,?> findMlfscPoint(Map<?,?> param) throws Exception;
	
	/**
	 * 판정 최종년도 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String selectMaxJdgmntYear(Map<?,?> param) throws Exception;
	
	/**
	 * 기업 통계 포함기업 카운트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int selectHpeAllFnnrCount(Map<?,?> param) throws Exception;
	
	/**
	 * 기업 통계 포함기업 검색
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectHpeAllFnnr(Map<?,?> param) throws Exception;
	
	/**
	 * 업종세분류목록 조회
	 * @param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectIndutyDtlclfcList() throws Exception;
	
	/**
	 * 지역코드 조회(시도별)
	 * @param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectAreaDivList() throws Exception;
	
}
