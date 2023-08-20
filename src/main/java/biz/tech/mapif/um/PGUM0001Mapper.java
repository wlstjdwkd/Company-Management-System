package biz.tech.mapif.um;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("PGUM0001Mapper")
public interface PGUM0001Mapper {

	//최근년도 구하기 
	public int findMaxStdyy () throws Exception;
	
	//기업 규모별 주요지표 정보 찾기 
	public Map<?,?> findEntrprSize (Map<?, ?> param) throws Exception;
	
	//메인 페이지 기업 인재 채용정보 정보 찾기 
	public List<Map> findEmpmnInfo(Map<?, ?> param) throws Exception;
	
	//메인 페이지 기업지원사업 정보 찾기
	public List<Map> findRssInfo() throws Exception;
	
	public List<Map> findNoticeInfo() throws Exception;
	
}