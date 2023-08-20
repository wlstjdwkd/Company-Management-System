package biz.tech.mapif.js;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 기업판정기준 관리 Mapper
 * @author sujong
 *
 */
@Mapper("PGJS0020Mapper")
public interface PGJS0020Mapper {

	/**
	 * 판정기준 목록 조회
	 * @param param 판정기준분류
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectJudgeStdrList(Map param) throws Exception;

	/**
	 * 판정기준 상세조회
	 * @param param 판정기준분류, 기준순번
	 * @return
	 * @throws Exception
	 */
	public Map selectJudgeStdr(Map param) throws Exception;

	/**
	 * 이전 판정기준 상세조회
	 * @param param 판정기준분류
	 * @return
	 * @throws Exception
	 */
	public Map selectLastJudgeStdr(Map param) throws Exception;
	
	/**
	 * 규모기준 목록조회
	 * @param param 판정기준분류, 기준순번
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectScaleStdrList(Map param) throws Exception;

	/**
	 * 업종 목록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectIndCdList(Map param) throws Exception;

	/**
	 * 상한기준 조회
	 * @param param 판정기준분류, 기준순번
	 * @return
	 * @throws Exception
	 */
	public Map selectUplmtStdr(Map param) throws Exception;

	/**
	 * 독립성기준 조회
	 * @param param 판정기준분류, 기준순번
	 * @return
	 * @throws Exception
	 */
	public Map selectIndpnStdr(Map param) throws Exception;
	
	/**
	 * 규모기준순번 채번
	 * @param param 판정기준분류, 기준순번
	 * @return
	 * @throws Exception
	 */
	public String getScaleStdrMaxSnPlus1(Map param) throws Exception;
	
	/**
	 * 판정기준 등록
	 * @param param 판정기준정보
	 * @throws Exception
	 */
	public void insertJudgeStdr(Map param) throws Exception;
	
	/**
	 * 규모기준 등록
	 * @param param 규모기준정보
	 * @throws Exception
	 */
	public void insertScaleStdr(Map param) throws Exception;
	
	/**
	 * 규모기준 업종등록
	 * @param param 업종코드
	 * @throws Exception
	 */
	public void insertScaleStdrInduty(Map param) throws Exception;
	
	/**
	 * 규모기준 업종삭제
	 * @param param 판정기준분류, 기준순번, 순번
	 * @throws Exception
	 */
	public void deleteScaleStdrInduty(Map param) throws Exception;
	
	/**
	 * 상한기준 등록
	 * @param param 상한기준정보
	 * @throws Exception
	 */
	public void insertUplmtStdr(Map param) throws Exception;
	
	/**
	 * 독립성기준 등록
	 * @param param 독립성기준정보
	 * @throws Exception
	 */
	public void insertIndpnStdr(Map param) throws Exception;

	/**
	 * 이전 판정기준 적용만료일자 수정
	 * @param param 판정기준뷴류, 기준순번, 적용만료일자
	 * @throws Exception
	 */
	public void updateLastJudgeStdrEndDe(Map param) throws Exception;
	
	/**
	 * 상한기준 수정
	 * @param param 상한기준정보
	 * @throws Exception
	 */
	public void updateUplmtStdr(Map param) throws Exception;
	
	/**
	 * 독립성기준 수정
	 * @param param 독립성기준정보
	 * @throws Exception
	 */
	public void updateIndpnStdr(Map param) throws Exception;
}
