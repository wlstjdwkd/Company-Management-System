package biz.tech.mapif.ev;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("PGEV1110Mapper")
public interface PGEV1110Mapper {
	

	//연차생성
	//검색
	public List<Map> findDayoff(Map<?, ?> param) throws RuntimeException, Exception;
	//생성
	public void insertDayoff(Map<?, ?>param) throws RuntimeException, Exception;
	//삭제
	public void deleteDayoff(Map<?, ?>param) throws RuntimeException, Exception;
	
}
