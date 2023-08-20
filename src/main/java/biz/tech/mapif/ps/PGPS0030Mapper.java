package biz.tech.mapif.ps;


import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 거래유형별현황 Mapper
 * @author CWJ
 * @param <Map>
 *
 */
@Mapper("PGPS0030Mapper")
public interface PGPS0030Mapper {
	
	/**
	 * 업종테마목록 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectInduThemaList(Map<?, ?> param) throws Exception;
	
	/**
	 * 업종목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectIndutyList(Map<?, ?> param) throws Exception;
	
	/**
	 * 거래유형별현황 데이터 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectStaticsDataList(Map<?, ?> param) throws Exception;
	
}

