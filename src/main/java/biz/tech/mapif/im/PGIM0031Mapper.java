package biz.tech.mapif.im;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 월별추진현황 - 발급기준집계
 * 
 * @author KMY
 *
 */
@Mapper("PGIM0031Mapper")
public interface PGIM0031Mapper {

	/**
	 * 월별추진현황 신청기준집계 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findMonthTotal(HashMap param) throws Exception;
	
	/**
	 * 월별추진현황 신청기준집계 년도별 카운트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Integer> findMonthTotalCnt(HashMap param) throws Exception;
	
	
}
