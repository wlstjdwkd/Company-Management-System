package biz.tech.mapif.ps;

import java.util.List;
import java.util.Map;

import com.comm.page.Pager;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 기업정보 Mapper
 * @author CWJ
 *
 */
@Mapper("PGPS0060Mapper")
public interface PGPS0060Mapper {
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
	public List<Map> selectGrowthSttus(Map<?, ?> param) throws Exception;

	/**
	 * 성장현황 - 현황 챠트 조회
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> selectGrowthSttusChart(Map<?, ?> param) throws Exception;
	
	
	/**
	 * 성장현황 - 추이 조회
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> selectGrowthSttus2(Map<?, ?> param) throws Exception;
	
}

