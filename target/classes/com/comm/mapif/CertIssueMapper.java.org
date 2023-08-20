package com.comm.mapif;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 기업확인서발급정보 Mapper
 * @author DST
 *
 */
@Mapper("certissueMapper")
public interface CertIssueMapper {

	/**
	 * 기업확인서발급정보 조회
	 * @param param 발급번호
	 * @return 확인서정보
	 * @throws Exception
	 */
	public List<Map> findCertIssueBsisInfo(Map<String, Object> param) throws Exception;
	
	/**
	 * 기업확인서발급정보 조회(기업 확인서 발급 신청증)
	 * @param param 발급번호
	 * @return 확인서정보
	 * @throws Exception
	 */
	public List<Map> findCertIssueBsisInfo2(Map<String, Object> param) throws Exception;
	
	/**
	 * 기업확인서재발급정보 조회
	 * @param param 접수번호
	 * @return 확인서정보
	 * @throws Exception
	 */
	public List<Map> findCertIssueIsgnInfo(Map<String, Object> param) throws Exception;

	/**
	 * 기업확인서재발급사업자정보 목록 - 재발급
	 * @param param 접수번호
	 * @return 확인서정보
	 * @throws Exception
	 */
	public List<Map> findCertIssueBiznoList(Map<String, Object> param) throws Exception;
	
	/**
	 * 기업확인서재발급사업자정보 목록 - 신규
	 * @param param 접수번호
	 * @return 확인서정보
	 * @throws Exception
	 */
	public List<Map> findCertIssueAddBiznoList(Map<String, Object> param) throws Exception;
	

	/**
	 * 기업확인서문서출력번호
	 * @param param 접수번호
	 * @return 확인서정보
	 * @throws Exception
	 */
	public String calldocNo(String rceptNo) throws Exception;
	
	/**
	 * 기업확인서발급신청증문서출력번호
	 * @param param 접수번호
	 * @return 확인서정보
	 * @throws Exception
	 */
	public String calldocNo2(String rceptNo) throws Exception;
}
