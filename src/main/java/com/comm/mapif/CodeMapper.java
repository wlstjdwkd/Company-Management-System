package com.comm.mapif;

import java.util.List;
import java.util.Map;

import com.comm.code.CodeVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("codeMapper")
public interface CodeMapper {

	/**
	 * 코드그룹번호로 코드 조회
	 * @param param 코드그룹번호
	 * @return 코드목록
	 * @throws RuntimeException, Exception
	 */
	public List<CodeVO> findCodesByGroupNo(String param) throws RuntimeException, Exception;

	/**
	 * 코드그룹목록갯수 조회
	 * @param param 조회조건
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int findCodeGroupListCnt(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 코드그룹목록 조회
	 * @param param 조회조건
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public List<Map> findCodeGroupList(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 코드그룹정보 조회
	 * @param param 코드그룹번호
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public Map<?, ?> findCodeGroup(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 코드목록갯수 조회
	 * @param param 코드그룹번호
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int findCodeListCnt(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 코드목록 조회
	 * @param param 코드그룹번호
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public List<Map> findCodeList(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 코드정보 조회
	 * @param param 코드그룹번호, 코드
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public Map findCodeInfo(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 코드그룹 등록
	 * @param param 코드그룹정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int insertCodeGroup(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 코드그룹번호 조회
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public String findLastCodeGroupNo() throws RuntimeException, Exception;

	/**
	 * 코드 등록
	 * @param param 코드정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int insertCode(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 코드그룹 수정
	 * @param param 코드그룹정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateCodeGroup(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 코드그룹 삭제
	 * @param param 코드그룹정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int deleteCodeGroup(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 코드삭제
	 * @param param 코드정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int deleteCode(Map<?, ?> param) throws RuntimeException, Exception;

}