package biz.tech.mapif.js;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 통계생성관리 Mapper
 * @author sujong
 *
 */
@Mapper("PGJS0010Mapper")
public interface PGJS0010Mapper {

	/**
	 * 판정정보 조회
	 * @param param 기준년도
	 * @return
	 * @throws Exception
	 */
	public Map selectJdgmntManage(Map param) throws Exception;
	
	/**
	 * 통계생성목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectStatsOpertList(Map param) throws Exception;
	
	/**
	 * 통계 프로시져 호출
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int callStaticsSp(Map param) throws Exception;

}
