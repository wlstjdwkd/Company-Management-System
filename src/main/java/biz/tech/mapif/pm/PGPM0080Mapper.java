package biz.tech.mapif.pm;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 프로그램 Mapper
 */
@Mapper("PGPM0080Mapper")
public interface PGPM0080Mapper {
		
	// 직원 조회 emp
	public List<Map> membersearch(Map<?, ?> param) throws RuntimeException, Exception;
	
	// 직원 갯수 조회 emp
	public int findmemberlist(Map<?, ?> param) throws RuntimeException, Exception;
	
	// 수정페이지 정보 조회 emp
	public Map<?, ?> updatememberlist (Map<?,?> param) throws RuntimeException, Exception;

	// 직원 수정 emp
	public int updatememberemp(Map<?, ?> param) throws RuntimeException, Exception;

	// 발생휴가일수 갱신
	public int updateEMPYOS(Map<?, ?> param) throws RuntimeException, Exception;
	
	// 누적사용일수 갱신
	public int updateHDUSED(Map<?, ?> param) throws RuntimeException, Exception;
	
	// 잔여휴가일수 갱신 
	public int updateHDLEFT(Map<?, ?> param) throws RuntimeException, Exception;
	
	// 사용일수, 잔여일수 개별 초기화
	public int updateHDtoZero(Map<?, ?> param) throws RuntimeException, Exception;

}