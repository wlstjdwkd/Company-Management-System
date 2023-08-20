package biz.tech.mapif.pc;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;




@Mapper("PGPC0020Mapper")
public interface PGPC0020Mapper {
	
	//데이터 최근년도 구하기 
	public int findMaxStdyy () throws Exception;
	
	// 업종 기업 정보 검색
	public Map<?,?> findMlfscPoint(Map<?, ?> param) throws Exception;
	
	// 지역별 기업 정보 검색
	public List<Map> findCounPoint(Map<?,?> param) throws Exception;
	
	// 전체 기업 규모 정보 검색
	public Map<?,?> findEntrprSize(Map<?, ?> param) throws Exception;
	
	public Map<?,?> findSumPoint(Map<?, ?> param) throws Exception;

}
