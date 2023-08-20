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
@Mapper("PGPS0070Mapper")
public interface PGPS0070Mapper {
	
	/**
	 * 주요지표 현황 목록 개수 조회	 
	 * @return 목록 개수
	 * @throws Exception
	 */
	public int findTotalIdxInfoRowCnt(Map<?, ?> param) throws Exception;
	
	/**
	 * 업종	 
	 * @return 목록
	 * @throws Exception
	 */
	public List<Map> selectInduty() throws Exception;

	/**
	 * 지역(본사기준)-시/도 조회	 
	 * @return 목록
	 * @throws Exception
	 */
	public List<Map> areaSelect() throws Exception;
	
	/**
	 * 기업위상 > 현황
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> phaseList(Map<?, ?> param) throws Exception;
	
	/**
	 * 기업위상 > 추이
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> phaseList2(Map<?, ?> param) throws Exception;
	
	/**
	 * 기업위상 > 현황 챠트
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> phaseListChart(Map<?, ?> param) throws Exception;
	
}

