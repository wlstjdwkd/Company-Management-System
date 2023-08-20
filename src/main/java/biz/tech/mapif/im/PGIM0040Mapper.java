package biz.tech.mapif.im;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 위변조문서신고내역 Mapper
 * 
 * @author KMY
 *
 */
@Mapper("PGIM0040Mapper")
public interface PGIM0040Mapper {
	
	/**
	 * 위변조문서신고 목록갯수
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int findDocReportListCnt(Map<?, ?> param) throws Exception;
	
	/**
	 * 위변조문서신고 목록조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findDocReportList(Map<?, ?> param) throws Exception;
	
}
