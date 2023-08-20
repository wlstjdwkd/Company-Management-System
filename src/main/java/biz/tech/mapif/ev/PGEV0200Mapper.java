package biz.tech.mapif.ev;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


@Mapper("PGEV0200Mapper")
public interface PGEV0200Mapper {
	public int selectProgrmCnt (Map<?, ?> param) throws RuntimeException, Exception;
	
	public void insertMember(Map<?, ?> param) throws RuntimeException, Exception;
	
	public Map<?, ?> findUsermember (Map<?,?> param) throws RuntimeException, Exception;
	
	/**
	 * 공통코드 목록 조회
	 *
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public List<Map> findCmmnCodeList (Map<?,?> param) throws RuntimeException, Exception;
	
	/**
	 * 공통코드 조회
	 *
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public Map<?, ?> findCmmnCode (Map<?,?> param) throws RuntimeException, Exception;
	
	/**
	 * 회원 삭제
	 *
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int deletemember(Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 회원 수정
	 *
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updatemember(Map<?, ?> param) throws RuntimeException, Exception;
	
	public int selectmemberCnt (Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 회원 조회
	 */
	public List<Map> findmember(Map<?, ?> param) throws RuntimeException, Exception;
	public int findUsermemberlist(Map<?, ?> param) throws RuntimeException, Exception;
	
	// 직원 조회 emp
	public List<Map> membersearch(Map<?, ?> param) throws RuntimeException, Exception;
	
	// 직원 갯수 조회 emp
	public int findmemberlist(Map<?, ?> param) throws RuntimeException, Exception;
	
	// 수정페이지 정보 조회 emp
	public Map<?, ?> updatememberlist (Map<?,?> param) throws RuntimeException, Exception;

	// 직원 등록 emp
	public void insertMemberemp(Map<?, ?> param) throws RuntimeException, Exception;
	
	// 직원 수정 emp
	public int updatememberemp(Map<?, ?> param) throws RuntimeException, Exception;

	//resume조회
	public Map<?, ?> findResumeMember(Map<?, ?> param) throws RuntimeException, Exception;
	
	// skill 조회
	public Map<?, ?> findSkillMember(Map<?, ?> param) throws RuntimeException, Exception;
	
	// 학력 조회
	public Map<?, ?> findScholarship(Map<?, ?> param) throws RuntimeException, Exception;
	
	/**
	 * 직원 삭제(수정)
	 *
	 * 해당 직원을 삭제한 경우 그날을 퇴사일로 지정
	 * @param param
	 * @return int
	 * @throws RuntimeException, Exception
	 */
	public int updateResignedEmployee(Map<?, ?> param) throws RuntimeException, Exception;
	
	// 직원 삭제 emp
	public int deletememberemp(Map<?, ?> param) throws RuntimeException, Exception;
	
	// 공통코드 조회
	public List<Map> findCodeAuthorList (Map<?,?> param) throws RuntimeException, Exception;
}