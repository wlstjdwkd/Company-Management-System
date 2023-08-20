package biz.tech.mapif.so;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 대량메일관리 Mapper
 * @author HSC
 *
 */
@Mapper("PGSO0120Mapper")
public interface PGSO0120Mapper {
	/**
	 * 대량메일관리 리스트 조회
	 * @param param
	 * @return List<Map>
	 * @throws Exception
	 */
	public List<Map> selectLqttEmailInfo(Map<?, ?> param) throws Exception;
	
	/**
	 * 대량메일관리 리스트 카운트
	 * @param param
	 * @return int
	 * @throws Exception
	 */
	public int selectLqttEmailInfoCount(Map<?, ?> param) throws Exception;
	
	/**
	 * 대량메일관리 상세 조회
	 * @param param
	 * @return Map
	 * @throws Exception
	 */
	public Map selectLqttEmailInfoDetail(Map<?, ?> param) throws Exception;
	
	/**
	 * 대량메일관리 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	void insertLqttEmailInfo(Map<?, ?> param) throws Exception;
	
	/**
	 * 대량메일관리 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	void updateLqttEmailInfo(Map<?, ?> param) throws Exception;
	
	/**
	 * 대량메일관리 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	void deleteLqttEmailInfo(Map<?, ?> param) throws Exception;
	
	/**
	 * 대량메일수신자 전체삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	void deleteLqttEmailAllRcver(Map<?, ?> param) throws Exception;
	
	/**
	 * 대량메일수신자 리스트 조회
	 * @param param
	 * @return List<Map>
	 * @throws Exception
	 */
	public List<Map> selectLqttEmailRcver(Map<?, ?> param) throws Exception;
	
	/**
	 * 대량메일수신자 리스트 카운트
	 * @param param
	 * @return int
	 * @throws Exception
	 */
	public int selectLqttEmailRcverCount(Map<?, ?> param) throws Exception;
	
	/**
	 * 대량메일수신자 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	void deleteLqttEmailRcver(Map<?, ?> param) throws Exception;
	
	/**
	 * 회원 이메일 리스트 조회
	 * @param param
	 * @return List<Map>
	 * @throws Exception
	 */
	public List<Map> selectUserEmailList(Map<?, ?> param) throws Exception;
	
	/**
	 * 이메일 수신거부 메일 리스트 조회
	 * @param param
	 * @return List<Map>
	 * @throws Exception
	 */
	public List<Map> selectRejectUserEmailList(Map<?, ?> param) throws Exception;
	
	/**
	 * 기 등록 메일 리스트 조회
	 * @param param
	 * @return List<Map>
	 * @throws Exception
	 */
	public List<Map> selectDuplUserEmailList(Map<?, ?> param) throws Exception;
	
	/**
	 * 일반 회원 이메일 리스트 조회
	 * @param param
	 * @return List<Map>
	 * @throws Exception
	 */
	public List<Map> selectGnUserEmailList(Map<?, ?> param) throws Exception;
	
	/**
	 * 기업 회원 이메일 리스트 조회
	 * @param param
	 * @return List<Map>
	 * @throws Exception
	 */
	public List<Map> selectEpUserEmailList(Map<?, ?> param) throws Exception;
	
	/**
	 * 대량메일수신자 등록
	 * @param param
	 * @return List<Map>
	 * @throws Exception
	 */
	void insertLqttEmailRcver(Map<?, ?> param) throws Exception;
	
	/**
	 * 전체 대량메일수신자 조회
	 * @param param
	 * @return List<Map>
	 * @throws Exception
	 */
	public List<Map> selectAllLqttEmailRcver(Map<?, ?> param) throws Exception;
	
	/**
	 * 이메일 발송요청 등록
	 * @param param
	 * @return List<Map>
	 * @throws Exception
	 */
	void insertLqttRequestSendEmail(Map<?, ?> param) throws Exception;
}