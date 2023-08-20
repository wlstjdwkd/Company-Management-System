package biz.tech.mapif.my;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 채용관리 및 입사지원 용 Mapper
 * 
 * @author dongwoo
 *
 */
@Mapper("applyMapper")
public interface ApplyMapper {
		
	/**
	 * 입사지원 정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map findCompApplyInfo(Map<?, ?> param) throws Exception;
	
	/**
	 * 입사지원현황 카운트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int findApplyCount(Map<?, ?> param) throws Exception;
	
	/**
	 * 입사지원현황 리스트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findApplyList(Map<?, ?> param) throws Exception;
	
	/**
	 * 필터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map findFilter(Map<?,?> param) throws Exception;
	
	/**
	 * 사진첨부 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertApplyAtchPhoto(Map<?, ?> param) throws Exception;
	
	/**
	 * 사진첨부 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateApplyAtchPhoto(Map<?, ?> param) throws Exception;
	
	/**
	 * 포트폴리오첨부 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateAttFileHist(Map<?, ?> param) throws Exception;
	
	/**
	 * 접수여부 변경(입사지원 취소시)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateReceptAt(Map<?, ?> param) throws Exception;
	
	/**
	 * 입사지원정보 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteApplyInfo(Map<?, ?> param) throws Exception;
	
	/**
	 * 입사지원 메인 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertCompApply(Map<?, ?> param) throws Exception;
	
	/**
	 * 입사지원 메인 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateCompApply(Map<?, ?> param) throws Exception;
	
	/**
	 * 학력사항 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertCaAcdmcr(Map<?, ?> param) throws Exception;
	
	/**
	 * 교육이수내역 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertCaEdc(Map<?, ?> param) throws Exception;
	
	/**
	 * 외국어능력 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertCaFggg(Map<?, ?> param) throws Exception;
	
	/**
	 * 해외연수경험 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertCaSdytrn(Map<?, ?> param) throws Exception;
	
	/**
	 * 경력사항 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertCaCareer(Map<?, ?> param) throws Exception;
	
	/**
	 * 자격사항 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertCaQualf(Map<?, ?> param) throws Exception;
	
	/**
	 * 수상내역 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertCaRwrpns(Map<?, ?> param) throws Exception;
	
	/**
	 * 제목 필터 정보 등록
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	public int insertTitleFilter(Map<?, ?> param) throws Exception;
	
	/**
	 * 직종 필터 정보 등록
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	public int insertJobFilter(Map<?, ?> param) throws Exception;	
	
	/**
	 * 정렬조건 필터 정보 등록
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	public int insertOrderbyFilter(Map<?, ?> param) throws Exception;	
	
	
	/**
	 * 학력사항 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findCaAcdmcr(Map<?, ?> param) throws Exception;
	
	/**
	 * 교육이수내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findCaEdc(Map<?, ?> param) throws Exception;
	
	/**
	 * 외국어능력 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findCaFggg(Map<?, ?> param) throws Exception;
		
	/**
	 * 해외연수경험 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findCaSdytrn(Map<?, ?> param) throws Exception;
	
	/**
	 * 경력사항 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findCaCareer(Map<?, ?> param) throws Exception;
	
	/**
	 * 자격사항 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findCaQualf(Map<?, ?> param) throws Exception;
	
	/**
	 * 수상내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findCaRwrpns(Map<?, ?> param) throws Exception;
	
	/**
	 * 학력사항 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteCaAcdmcr(Map<?, ?> param) throws Exception;
	
	/**
	 * 교육이수내역 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteCaEdc(Map<?, ?> param) throws Exception;
	
	/**
	 * 외국어능력 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteCaFggg(Map<?, ?> param) throws Exception;
	
	/**
	 * 해외연수경험 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteCaSdytrn(Map<?, ?> param) throws Exception;
	
	/**
	 * 경력사항 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteCaCareer(Map<?, ?> param) throws Exception;
	
	/**
	 * 자격사항 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteCaQualf(Map<?, ?> param) throws Exception;
	
	/**
	 * 수상내역 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteCaRwrpns(Map<?, ?> param) throws Exception;
	
	/**
	 * 제목 필터 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteTitleFilter(Map<?,?> param) throws Exception;
	
	
	/**
	 * 직종 필터 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteJobFilter(Map<?, ?> param) throws Exception;
	
	/**
	 * 정렬조건 필터 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteOrderbyFilter(Map<?, ?> param) throws Exception;
	
	
}
