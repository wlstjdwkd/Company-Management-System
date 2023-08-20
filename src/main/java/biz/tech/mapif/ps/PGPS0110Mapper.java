package biz.tech.mapif.ps;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * Update Test Mapper
 * @author Tkim 
 *
 */
@Mapper("PGPS0110Mapper")
public interface PGPS0110Mapper {
	
	/**
	 * selecting editing target
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectEditTarget(Map<?, ?> param) throws Exception;
	
	/**
	 * Editing Info
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateUserInfo(Map<?, ?> param) throws Exception;
}

