package com.comm.mapif;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("PGCMFIRM0010Mapper")
public interface PGCMFIRM0010Mapper {
	public List<Map> findDeptList(Map<?,?> param) throws RuntimeException, Exception;		// 부서 리스트 가져오기
	public int findDeptListCnt(Map<?,?> param) throws RuntimeException, Exception;			// 부서 개수 가져오기
	public List<Map> findDeptCdNmList() throws RuntimeException, Exception;					// 부서 코드 & 이름 만 가지는 리스트 가져오기
	public Map findDeptInfo(Map<?,?> param) throws RuntimeException, Exception;				// 1개의 부서 정보 가져오기
	public int insertDeptInfo(Map<?,?> param) throws RuntimeException, Exception;			// 부서 정보 등록하기
	public int updateDeptInfo(Map<?,?> param) throws RuntimeException, Exception;			// 부서 정보 갱신하기
	public int updateUDeptCd(Map<?,?> param) throws RuntimeException, Exception;			// 부서 코드가 바뀔 경우 상위 부서코드를 전부 수정해주기
	public List<Map> findDeptListExcel(Map<?,?> param) throws RuntimeException, Exception;	// 부서 리스트 - 엑셀 다운로드 전용
}
