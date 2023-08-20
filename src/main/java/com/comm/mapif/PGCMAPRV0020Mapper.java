package com.comm.mapif;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("PGCMAPRV0020Mapper")
public interface PGCMAPRV0020Mapper
{
	/*대체승인 목록 출력*/
	public List<Map> findList(Map<?,?> param) throws RuntimeException, Exception;

	/*대체승인 목록 갯수 출력*/
	public int findListCnt(Map<?,?> param) throws RuntimeException, Exception;
	
	/*대체승인 상세 출력*/
	public Map getAltrtvDetail(Map<?,?> param) throws RuntimeException, Exception;
	
	/*대체승인자 선택 리스트*/
	public List<Map> findAltrtvConfmerList(Map<?,?> param) throws RuntimeException, Exception;

	/*대체승인자 등록*/
	public int insertAltrtvInfo(Map<?,?> param) throws RuntimeException, Exception;

	/*대체승인자 수정*/
	public int updateAltrtvInfo(Map<?,?> param) throws RuntimeException, Exception;
	
	/*대체승인자테이블 출력*/
	public List<Map> findAltrtvConfmDe(Map<?,?> param) throws RuntimeException, Exception;
	
	/*동일한대체승인자테이블 출력*/
	public List<Map> findSameAltrtvConfmDe(Map<?,?> param) throws RuntimeException, Exception;
	
	/*대체승인자 삭제*/
	public int deleteAltrtvInfo(Map<?,?> param) throws RuntimeException, Exception;

}