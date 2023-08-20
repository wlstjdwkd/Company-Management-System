package biz.tech.mapif.ps;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * Read Test Mapper
 * @author Tkim
 *
 */
@Mapper("PGPS0100Mapper")
public interface PGPS0100Mapper {
	
	/**
	 *  목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int findTotalCount(Map<?, ?> param) throws Exception;
	
	
	/**
	 *  목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectUserInfo(Map<?, ?> param) throws Exception;
	
}

