package com.comm.mapif;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("PGCMMON0142Mapper")
public interface PGCMMON0142Mapper
{
	// 접속 로그 정보 찾기
	public List<Map> findJoinLog(Map<?,?> param) throws Exception;
	
	// 접속 로그 정보 갯수
	public int findJoinLogCnt (Map<?,?> param) throws Exception;
	
	/**
	 * 요청로그 등록
	 * @param param	요청로그 정보
	 * @return
	 * @throws Exception
	 */
	public int insertRequestLog(Map<?, ?> param) throws Exception;
}
