package biz.tech.mapif.ps;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * Create Test Mapper
 * @author tkim
 *
 */
@Mapper("PGPS0090Mapper")
public interface PGPS0090Mapper {
	
	/**
	 * 정보 집어넣기
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertUserInfo(Map<?, ?> param) throws Exception;
	
	/**
	 * Template값 (foreign key)를 가지고오는 쿼리
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	public List selectQustnrTmplatManage();
	
}

