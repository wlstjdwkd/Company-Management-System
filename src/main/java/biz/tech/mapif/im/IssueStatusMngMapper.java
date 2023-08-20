package biz.tech.mapif.im;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 확인서발급관리 Mapper
 * @author JGS
 *
 */
@Mapper("issueStatusMngMapper")
public interface IssueStatusMngMapper {	
		
	/**
	 * 발급업무관리 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectIssueTaskMng(Map<String, Object> param) throws Exception;
	
	/**
	 * 발급업무관리 엑셀 다운
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectIssueTaskMngExcel(Map<String, Object> param) throws Exception;
	
	/**
	 * 발급내역 엑셀 다운
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectIssueTaskMngHisExcel(Map<String, Object> param) throws Exception;
	
	
	/**
	 * 발급업무관리 총개수 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int selectIssueTaskMngTotCnt(Map<String, Object> param) throws Exception;
	
	/**
	 * 최종상태이력관리 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map selectLastestResn(Map<String, Object> param) throws Exception;
	
	/**
	 * 기업명 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map selectEntrprsNm(Map<String, Object> param) throws Exception;	
	
	/**
	 * 판정 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map selectJudgment(Map<String, Object> param) throws Exception;	
	
	/**
	 * 신청담당자정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map selectChargerInfo(Map<String, Object> param) throws Exception;	
	
	
	/**
	 * 신청접수특이사항 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map selectPartclrMatter(Map<String, Object> param) throws Exception;
	
	/**
	 * 특례대상여부 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateExcpt(Map<String, Object> param) throws Exception;
	
	/**
	 * 판정 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateJudgment(Map<String, Object> param) throws Exception;
	
	/**
	 * 판정 유효기간 및 확인서구분 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateJudgmentForRC1(Map<String, Object> param) throws Exception;
	
	/**
	 * 발급일련번호 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateIssuSn(Map<String, Object> param) throws Exception;
	
	/**
	 * 신청접수특이사항 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updatePartclrMatter(Map<String, Object> param) throws Exception;
	
	/**
	 * 신용평가사수집데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectEntprsFnnrData(Map<String, Object> param) throws Exception;
	

}
