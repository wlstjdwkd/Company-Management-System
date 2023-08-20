package biz.tech.mapif.dc;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;



@Mapper("PGDC0060Mapper")
public interface PGDC0060Mapper {

	//최근년도 구하기 
	public int findMaxStdyy () throws Exception;
	
	//  기업 지표 데이터 정보 찾기
	public Map<?,?> findHpePoint(Map<?,?> param) throws Exception;
	
	
	// 중소기업, 대기업 지표 정보 입력 및 수정
	public void updateHpePhase(Map<?,?> param) throws Exception;
	
}
