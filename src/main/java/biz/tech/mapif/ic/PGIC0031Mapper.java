package biz.tech.mapif.ic;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 위변조문서신고
 * 
 * @author KMY
 *
 */
@Mapper("PGIC0031Mapper")
public interface PGIC0031Mapper {
	
	/**
	 * 위변조문서신고 등록
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertDocReport(Map<?,?> param) throws Exception;
}
