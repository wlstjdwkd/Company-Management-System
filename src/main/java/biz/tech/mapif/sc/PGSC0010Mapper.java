package biz.tech.mapif.sc;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 프로그램 Mapper
 */
@Mapper("PGSC0010Mapper")
public interface PGSC0010Mapper {

	// 회원 등록
	public void insertMember(Map<?, ?> param) throws RuntimeException, Exception;
	
	// 회원 검색
	public Map<?, ?> findUsermember (Map<?,?> param) throws RuntimeException, Exception;

	// 회원 삭제
	public int deletemember(Map<?, ?> param) throws RuntimeException, Exception;
	
	// 회원 수정
	public int updatemember(Map<?, ?> param) throws RuntimeException, Exception;
	
	// 회원 갯수 계산
	public int selectmemberCnt (Map<?, ?> param) throws RuntimeException, Exception;
	
	// 회원 조회
	public List<Map> findmember(Map<?, ?> param) throws RuntimeException, Exception;
	public int findUsermemberlist(Map<?, ?> param) throws RuntimeException, Exception;
}