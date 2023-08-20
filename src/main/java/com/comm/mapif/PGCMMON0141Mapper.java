package com.comm.mapif;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("PGCMMON0141Mapper")
public interface PGCMMON0141Mapper
{
		// 일별 업무별 접속 통계
		public List<Map> findVisitStats(Map<?,?> param) throws Exception;
		//일별 총 접속사용자 수
		public Map findTotalVisitstats (Map<?,?> param) throws Exception;
		// 일별 업무별 접속통계 건수
		public int findLogCnt (Map<?,?> param) throws Exception;
} 
