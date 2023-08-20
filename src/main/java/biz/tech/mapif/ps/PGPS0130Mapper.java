package biz.tech.mapif.ps;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * Delete Test Mapper
 * @author Tkim
 *
 */
@Mapper("PGPS0130Mapper")
public interface PGPS0130Mapper {
	
	/**
	 * 기준년도 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteUserInfo(Map<?, ?> param) throws Exception;
	
}

