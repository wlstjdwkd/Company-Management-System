package biz.tech.mapif.ev;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("PGEV1120Mapper")
public interface PGEV1120Mapper {	
	//휴가신청
	//검색
	//휴가신청 리스트
	public List<Map> findDayoffInfo(Map<?, ?> param) throws RuntimeException, Exception;
	//휴가신청내역 리스트
	public List<Map> findDayoffLog(Map<?, ?> param) throws RuntimeException, Exception;
	//휴가날짜 계산
	public List<Map> calDate(Map<?, ?> param) throws RuntimeException, Exception;
	//신청
	public void requestDayoff(Map<?, ?>param) throws RuntimeException, Exception;
	//저장
	public void saveDayoff(Map<?, ?> param) throws RuntimeException, Exception;
	//삭제
	public void cancelDayoff(Map<?, ?> param) throws RuntimeException, Exception;
}
