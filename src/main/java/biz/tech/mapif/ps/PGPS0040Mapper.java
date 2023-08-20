package biz.tech.mapif.ps;


import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 외투기업별별현황 Mapper
 * @author CWJ
 * @param <Map>
 *
 */
@Mapper("PGPS0040Mapper")
public interface PGPS0040Mapper {
		
	/**
	 * 외투기업별현황 데이터 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectStaticsDataList(Map<?, ?> param) throws Exception;
	
}

