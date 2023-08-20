package biz.tech.mapif.im;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 기업정보 Mapper
 * @author CWJ
 *
 */
@Mapper("PGIM0110Mapper")
public interface PGIM0110Mapper {
	
	/**
	 * 성장현황 - 현황 목록 개수 조회	 
	 * @return 목록 개수
	 * @throws Exception
	 */
	public int findTotalIdxInfoRowCnt(Map<?, ?> param) throws Exception;
	
	/**
	 * 성장현황 - 현황 조회
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public List<Map> selectGrowthSttus(Map<?, ?> param) throws Exception;

	/**
	 * 성장현황 - 현황 차트 조회
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public List<Map> selectGrowthSttusChart(Map<?, ?> param) throws Exception;
	
}