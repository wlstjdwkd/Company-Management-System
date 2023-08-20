package biz.tech.mapif.em;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 프로그램 Mapper
 */
@Mapper("PGEM0020Mapper")
public interface PGEM0020Mapper {
		
	// 문서 조회
	public List<Map> docusearch(Map<?, ?> param) throws RuntimeException, Exception;
	
	// 수정 view 띄우기
	public Map<?,?> modifydocuinfoTOP(Map<?, ?> param) throws RuntimeException, Exception;
	public List<Map> modifydocuinfoBOT(Map<?, ?> param) throws RuntimeException, Exception;
	public Map<?,?> findCmmnCode(Map<?, ?> param) throws RuntimeException, Exception;
	public Map<?,?> findCmmnCodebyname(Map<?, ?> param) throws RuntimeException, Exception;
	
	// 수정
	public int upsertTOP(Map<?, ?> param) throws RuntimeException, Exception;
	public int upsertBOT(Map<?, ?> param) throws RuntimeException, Exception;
	public int deleteBOTrow(Map<?, ?> param) throws RuntimeException, Exception;
	
	//삭제
	public int deleteTOP(Map<?, ?> param) throws RuntimeException, Exception;
	public int deleteBOT(Map<?, ?> param) throws RuntimeException, Exception;
	
	// 0010service 등록
	public int insertTOP(Map<?, ?> param) throws RuntimeException, Exception;
	public int insertBOT(Map<?, ?> param) throws RuntimeException, Exception;
}