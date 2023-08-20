package biz.tech.mapif.sp;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 지원사업관리 Mapper
 * @author DST
 *
 */

@Mapper("PGSP0060Mapper")
public interface PGSP0060Mapper {

	/**
	 * 지원사업리스트
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public List<Map> findSuportList(Map<?, ?> param) throws Exception;
	
	
	/**
	 * 지원사업 목록 갯수 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int findSuportListCnt(Map<?, ?> param) throws Exception;

	/**
	 * 지원사업 공개어부 수정
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateSuportntceAtYN(HashMap param);


	/**
	 * 지원사업 사이트 목록 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findRssList(HashMap param);

	/**
	 * 지원사업 사이트 갯수
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int findRssListCnt(HashMap param);

	/**
	 * 지원사업 사이트 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findRss(HashMap param);


	/**
	 * 지원사업 사이트 수정
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateRSSsite(HashMap param);
	
	/**
	 * 지원사업 사이트 등록
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertRSSsite(HashMap param);


	public int selectGalleryBoardCount(Map<?, ?> param);


	public List<Map> selectGalleryBoardInfo(Map<?, ?> param);
	
}
