package biz.tech.mapif.ic;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 기업확인신청 Mapper
 * @author JGS
 *
 */
@Mapper("hpeCnfirmReqstMapper")
public interface HpeCnfirmReqstMapper {	
	
	/**
	 * 임시신청접수 조회
	 * @param param 조회년도
	 * @return
	 * @throws Exception
	 */
	public Map selectTempApplyMaster(Map<String, Object> param) throws Exception;
	
	/**
	 * 신청접수(법인번호) 조회
	 * @param param 조회년도
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectApplyMasterByJurirno(Map<String, Object> param) throws Exception;
	
	/**
	 * 신청접수 조회
	 * @param param 조회년도
	 * @return
	 * @throws Exception
	 */
	public Map selectApplyMaster(Map<String, Object> param) throws Exception;
	
	/**
	 * 알림이력 조회
	 * @param param 조회년도
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectResnManage(Map<String, Object> param) throws Exception;
	
	/**
	 * 일련번호관리 조회
	 * @param param 조회년도
	 * @return
	 * @throws Exception
	 */
	public Map selectSnMng(Map<String, Object> param) throws Exception;
	
	/**
	 * 신청기업기초정보 조회
	 * @param param 조회년도
	 * @return
	 * @throws Exception
	 */
	public Map selectIssuBsisInfo(Map<String, Object> param) throws Exception;

	/**
	 * 신청기업및관계기업주요정보 조회
	 * @param param 조회년도
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectReqstRcpyList(Map<String, Object> param) throws Exception;
	
	/**
	 * 신청정보_지분소유 조회
	 * @param param 조회년도
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectReqstInfoQotaPosesn(Map<String, Object> param) throws Exception;
	
	/**
	 * 신청정보_재무 조회
	 * @param param 조회년도
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectReqstFnnrData(Map<String, Object> param) throws Exception;
	
	/**
	 * 신청정보_상시근로자수 조회
	 * @param param 조회년도
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectReqstOrdtmLabrr(Map<String, Object> param) throws Exception;
	
	/**
	 * 첨부파일 조회
	 * @param param 조회년도
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectReqstFile(Map<String, Object> param) throws Exception;
	
	/**
	 * 최근재발급접수 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map selectRecentApply(Map<String, Object> param) throws Exception;
	
	/**
	 * 상태별 상태 이력 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map selectResnMngBySeCode(Map<String, Object> param) throws Exception;
	
	/**
	 * 재발급기초정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map selectIsgnBsisInfo(Map<String, Object> param) throws Exception;
	
	/**
	 * 내용변경신청 업데이트
	 * @param param 조회년도
	 * @return
	 * @throws Exception
	 */
	public int updateIsgnBsisInfo(Map<String, Object> param) throws Exception;
	
	/**
	 * 복수사업자번호관리 조회 - 재발급
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String[] selectCompnoBizrnoManage(Map<String, Object> param) throws Exception;
		
	/**
	 * 복수사업자번호관리 조회 - 신규
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String[] selectAddBizrnoManage(Map<String, Object> param) throws Exception;
	
	/**
	 * 기업기본정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map selectEntprsInfo(Map<String, Object> param) throws Exception;
	
	/**
	 * 기업기본통계 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectEntBaseSts(Map<String, Object> param) throws Exception;
	
	/**
	 * 상위업체평균통계 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map selectUpperCmpnAvgSts(Map<String, Object> param) throws Exception;
	
	/**
	 * 상호출자제한기업 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectMutualInvestLimit(Map<String, Object> param) throws Exception;
	
	/**
	 * 중소기업확인서발급내역 조회(유효항목만)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectSmbaList(Map<String, Object> param) throws Exception;
	
	/**
	 * 대상년도 발급 신청건 조회(법인번호)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map selectApplyMasterReqstYear(Map<String, Object> param) throws Exception;
	
	/**
	 * 업종 대 분류 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectLargeGroup() throws Exception;
	
	/**
	 * 업종 대 분류 검색
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map selectLargeOne (Map<String, Object> param) throws Exception;
	
	/**
	 * 업종 중 분류 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectSmallGroup(Map<?, ?> param) throws Exception;
	
	/**
	 * 일련번호관리 등록
	 * @param param 사용자정보
	 * @return
	 * @throws Exception
	 */
	public int insertSnMng(Map<String, Object> param) throws Exception;
	
	/**
	 * 접수일련번호 수정
	 * @param param 사용자정보
	 * @return
	 * @throws Exception
	 */
	public int updateRceptSn(Map<String, Object> param) throws Exception;
	
	/**
	 * 신청접수 재발급여부 수정
	 * @param param 사용자정보
	 * @return
	 * @throws Exception
	 */
	public int updateIsgnAt(Map<String, Object> param) throws Exception;
	
	/**
	 * 신청접수 등록
	 * @param param 사용자정보
	 * @return
	 * @throws Exception
	 */
	public int insertApplyMaster(Map<String, Object> param) throws Exception;
	
	/**
	 * 신청기업기초정보 등록
	 * @param param 사용자정보
	 * @return
	 * @throws Exception
	 */
	public int insertIssuBsisInfo(Map<String, Object> param) throws Exception;
	
	/**
	 * 신청기업및관계기업주요정보 등록
	 * @param param 사용자정보
	 * @return
	 * @throws Exception
	 */
	public int insertReqstRcpyList(Map<String, Object> param) throws Exception;
	
	/**
	 * 신청정보_지분소유 등록
	 * @param param 사용자정보
	 * @return
	 * @throws Exception
	 */
	public int insertReqstInfoQotaPosesn(Map<String, Object> param) throws Exception;
	
	/**
	 * 신청정보_재무 등록
	 * @param param 사용자정보
	 * @return
	 * @throws Exception
	 */
	public int insertReqstFnnrData(Map<String, Object> param) throws Exception;
	
	/**
	 * 신청정보_상시근로자수 등록
	 * @param param 사용자정보
	 * @return
	 * @throws Exception
	 */
	public int insertReqstOrdtmLabrr(Map<String, Object> param) throws Exception;
	
	/**
	 * 상태이력관리 등록
	 * @param param 사용자정보
	 * @return
	 * @throws Exception
	 */
	public int insertResnManage(Map<String, Object> param) throws Exception;
	
	/**
	 * 첨부파일 등록
	 * @param param 사용자정보
	 * @return
	 * @throws Exception
	 */
	public int insertReqstFile(Map<String, Object> param) throws Exception;
	
	/**
	 * 재발급기초정보 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertIsgnBsisInfo(Map<String, Object> param) throws Exception;
	
	/**
	 * 복수사업자번호관리 등록 - 재발급 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertCompnoBizrnoManage(Map<String, Object> param) throws Exception;	
	
	/**
	 * 복수사업자번호관리 등록 - 신규
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertAddBizrnoManage(Map<String, Object> param) throws Exception;	
	
	/**
	 * 복수사업자번호관리 삭제 - 재발급
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteCompnoBizrnoManage(Map<String, Object> param) throws Exception;
	
	/**
	 * 복수사업자번호관리 삭제 - 신규
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteAddBizrnoManage(Map<String, Object> param) throws Exception;
	
	/**
	 * 산업기업기초정보 삭제
	 * @param param 사용자정보
	 * @return
	 * @throws Exception
	 */
	public int deleteIssuBsisInfo(Map<String, Object> param) throws Exception;
	
	/**
	 * 신청기업및관계기업주요정보 삭제
	 * @param param 사용자정보
	 * @return
	 * @throws Exception
	 */
	public int deleteReqstRcpyList(Map<String, Object> param) throws Exception;
	
	/**
	 * 신청정보_재무 삭제
	 * @param param 사용자정보
	 * @return
	 * @throws Exception
	 */
	public int deleteReqstFnnrData(Map<String, Object> param) throws Exception;
	
	/**
	 * 신청정보_지분소유 삭제
	 * @param param 사용자정보
	 * @return
	 * @throws Exception
	 */
	public int deleteReqstInfoQotaPosesn(Map<String, Object> param) throws Exception;
	
	/**
	 * 신청정보_상시근로자수 삭제
	 * @param param 사용자정보
	 * @return
	 * @throws Exception
	 */
	public int deleteReqstOrdtmLabrr(Map<String, Object> param) throws Exception;
	
	/**
	 * 첨부파일 삭제
	 * @param param 사용자정보
	 * @return
	 * @throws Exception
	 */
	public int deleteReqstFile(Map<String, Object> param) throws Exception;
	
	/**
	 * 첨부파일 삭제(파일순번)
	 * @param param 사용자정보
	 * @return
	 * @throws Exception
	 */
	public int deleteReqstFileBySeq(Map<String, Object> param) throws Exception;
		
	/**
	 * 기업 자가진단
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> callSelfDiagnosis(Map<String, Object> param) throws Exception;
	
	/**
	 * 재발급기초정보 첨부파일1 정보 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateDelAttFileSeq1(Map<String, Object> param) throws Exception;
	
	/**
	 * 재발급기초정보 첨부파일2 정보 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateDelAttFileSeq2(Map<String, Object> param) throws Exception;
	
	/**
	 * 재발급중복신청 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map selectIsgnDplctReqst(Map<String, Object> param) throws Exception;
	
	/**
	 * 발급중복신청 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map selectIssuDplctReqst(Map<String, Object> param) throws Exception;
}
