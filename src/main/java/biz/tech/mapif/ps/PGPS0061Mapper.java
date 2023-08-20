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
@Mapper("PGPS0061Mapper")
public interface PGPS0061Mapper {
	/**
	 * 분류요인별분석 개수 조회	 
	 * @return 목록 개수
	 * @throws Exception
	 */
	public int findTotalIdxInfoRowCnt(Map<?, ?> param) throws Exception;
	
	/**
	 * 분류요인별분석 분류요인 조회
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> selectClFctr(Map<?, ?> param) throws Exception;
	
	/**
	 * 분류요인별분석 분류요인-규모기준 조회
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> selectClFctr2(Map<?, ?> param) throws Exception;

}

