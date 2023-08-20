package com.comm.mapif;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 프로그램 Mapper
 * @author sujong
 *
 */
@Mapper("aprvlineMapper")
public interface AprvLineMapper {

	/**
	 * 프로그램 정보 조회
	 * @param param 프로그램ID
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public List<Map> findAprvLine(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 프로그램 목록 갯수 조회
	 *
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int findProgramListCnt(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 프로그램 목록 조회
	 * @param param 조회범위 및 조회조건
	 * @return
	 */
	public List<Map> findProgramList(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 프로그램 등록
	 * @param param 프로그램 정보
	 * @return
	 * @throws RuntimeException, Exception
	*/
	public int insertProgram(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 프로그램 수정
	 *
	 * @param param 프로그램 번호
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateProgram(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 메뉴 삭제
	 *
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int deleteProgram(Map<?, ?> param) throws RuntimeException, Exception;


	/**
	 * 권한 정보 조회
	 * @param param 프로그램ID
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public Map<?, ?> findAuthor(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 권한 정보 입력
	 *
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int insertAuthor(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 권한 정보 수정
	 *
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateAuthor(Map<?, ?> param) throws RuntimeException, Exception;


	public int deleteAuthor(Map<?, ?> param) throws RuntimeException, Exception;


	public List<Map> findCodeAuthorList (Map<?,?> param) throws RuntimeException, Exception;

	public int selectProgrmCnt (Map<?, ?> param) throws RuntimeException, Exception;

}
