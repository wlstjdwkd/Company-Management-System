package biz.tech.mapif.dc;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 신용평가사수집관리 Mapper
 * @author DST
 *
 */

@Mapper("PGDC0020Mapper")
public interface PGDC0020Mapper  {
	
	/**
	 * 신용평가사기업정보수집관리 목록
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public List<Map> findentInfoMgrList(Map<?, ?> param) throws Exception;

	/**
	 *  신용평가사기업정보수집대상 기업 리스트조회
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public  List<Map>   findentInfoReq();
	
	/**
	 *  신용평가사기업정보수집대상 기업 리스트조회
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public  List<Map>   callentInfoReq(Map<?, ?> param);
	
	/**
	 * 신용평가사기업정보수집관리 등록
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public int insertentInfoMgr(Map<?, ?> param) throws Exception;
	
	/**
	 * 신용평가사기업정보수집관리 등록(NICE)
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public int insertentInfoMgrNice(Map<?, ?> param) throws Exception;
}
