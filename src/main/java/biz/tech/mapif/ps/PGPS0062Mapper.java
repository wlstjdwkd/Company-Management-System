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
@Mapper("PGPS0062Mapper")
public interface PGPS0062Mapper {
	/**
	 * 진입시기별분석 > 개수 조회	 
	 * @return 목록 개수
	 * @throws Exception
	 */
	public int findTotalIdxInfoRowCnt(Map<?, ?> param) throws Exception;
	
	/**
	 * 진입시기별분석 > 현황 조회
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> selectSttus(Map<?, ?> param) throws Exception;
	
	/**
	 * 진입시기별분석 > 성장현황 조회
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> selectGrowthSttus(Map<?, ?> param) throws Exception;

}

