package biz.tech.mapif.ps;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 기업정보 Mapper
 * @author CWJ
 *
 */
@Mapper("PGPS0065Mapper")
public interface PGPS0065Mapper {
	/**
	 * 진입시기별분석 > 개수 조회	 
	 * @return 목록 개수
	 * @throws Exception
	 */
	public int findTotalIdxInfoRowCnt(Map<?, ?> param) throws Exception;
	
	/**
	 * 후보기업 성장분석 > 분류요인-규모기준
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> selectSttus(Map<?, ?> param) throws Exception;
	
	/**
	 * 후보기업 성장분석 > 진입기준별 중견 후보기업현황
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> selectSttus2(Map<?, ?> param) throws Exception;
	
	/**
	 * 테마별업종 조회(코드그룹별)
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> findCodesByGroupNo(Map<?, ?> param) throws Exception;
	
}

