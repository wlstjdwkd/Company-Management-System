package biz.tech.mapif.pmjs;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 프로그램 Mapper
 */
public interface PGPMJS0010Mapper {
	public int selectProgrmCnt (Map<?, ?> param) throws RuntimeException, Exception;
	
	public void insertMember(Map<?, ?> param) throws RuntimeException, Exception;
	
	public Map<?, ?> findUsermember(Map<?, ?> param) throws RuntimeException,Exception;
	
	/**
	 * 공통코드 목록 조회
	 *
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public List<Map> findCmmnCodeList (Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 공통코드 조회
	 *
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public Map<?, ?> findCmmnCode(Map<?, ?> param) throws RuntimeException, Exception;
	
	public int selectmemberCnt(Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 회원 조회
	 */
	public List<Map> findmember(Map<?, ?> param) throws RuntimeException, Exception;
	public int findUsermemberlist(Map<?, ?> param) throws RuntimeException, Exception;
	
	// 직원 조회 emp
	public List<Map> membersearch(Map<?, ?> param) throws RuntimeException, Exception;
	
	//직원 갯수 조회 emp
	public int findmemberlist(Map<?, ?> param) throws RuntimeException, Exception;
	
	//수정페이지 정보 조회 emp
	public Map<?, ?> updatememberlist (Map<?, ?> param) throws RuntimeException, Exception;
	
	//직원 등록 emp
	public void insertMemberemp(Map<?, ?> param) throws RuntimeException, Exception;
	
	//공통코드 조회
	public List<Map> findCodeAuthorList(Map<?, ?> param) throws RuntimeException, Exception;

}
