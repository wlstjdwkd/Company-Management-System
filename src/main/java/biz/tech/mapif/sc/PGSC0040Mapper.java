package biz.tech.mapif.sc;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 
 * 
 * @author KMY
 *
 */
@Mapper("PGSC0040Mapper")
public interface PGSC0040Mapper {
	
	//사용내역 목록 조회
	//@param param 사원명(searchemNm)
	public List<Map> findExpenseList(Map<?, ?> param) throws RuntimeException, Exception;
	
	//사원 이름 조회(사원 테이블)
	//@param
	public List<Map> findName(Map<?, ?> param) throws RuntimeException, Exception;
	
	//사용내역 목록 조회(수정창)
	//@param
	public List<Map> findHistory(Map<?, ?> param) throws RuntimeException, Exception;
	
	//사용내역 목록 갯수 조회
	//@param
	public int findExpenseListCnt(Map<?, ?> param) throws RuntimeException, Exception;
	
	//사용 금액 합계 조회
	//@param
	public int expenseCnt(Map<?, ?> param) throws RuntimeException, Exception;
	
	//사용내역 등록
	//@param 
	public int insertExpense(Map<?, ?> param) throws RuntimeException, Exception;
	
	//사용내역 수정
	//@param
	public int updateExpense(Map<?, ?> param) throws RuntimeException, Exception;
	
	//사용내역 삭제
	public int deleteExpense(Map<?, ?> param) throws RuntimeException, Exception;
	
	//등록, 삭제, 수정 후 인덱스로 돌아가면 그 사원의 내역이 보이도록 이름을 넘겨주기위한 것
	public String findEmname(String emnum) throws RuntimeException, Exception;
	
}
