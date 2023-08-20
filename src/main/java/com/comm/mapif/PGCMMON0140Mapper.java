package com.comm.mapif;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("PGCMMON0140Mapper")
public interface PGCMMON0140Mapper
{
	public List<Map> callVisitStats(Map<?,?> param) throws Exception;
	public Map findBeforeVisitStats(Map<?,?> param) throws Exception;
	public int findTotalVisitStats() throws Exception;
}
