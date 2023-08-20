package biz.tech.mapif.ic;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 발급문서진위확인 Mapper
 * @author KMY
 *
 */
@Mapper("PGIC0030Mapper")
public interface PGIC0030Mapper {
	
	/**
	 * 발급문서진위확인 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map findIssuDocument(Map<?,?> param) throws Exception;
}
