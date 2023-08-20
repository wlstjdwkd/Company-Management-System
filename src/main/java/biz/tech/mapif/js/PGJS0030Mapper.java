package biz.tech.mapif.js;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 시스템판정처리 Mapper
 * @author sujong
 *
 */
@Mapper("PGJS0030Mapper")
public interface PGJS0030Mapper {

	/**
	 * 기준년도 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectStdyyList(Map<?, ?> param) throws Exception;
	
	/**
	 * 최종 데이터 수집일자 조회
	 * @param param	기준년도
	 * @return
	 * @throws Exception
	 */
	public String selectLastDataCollectDate(Map<?, ?> param) throws Exception;
	
	/**
	 * 기업수 조회
	 * @param param 기준년도
	 * @return
	 * @throws Exception
	 */
	public int selectJdgmntEntprsCount(Map<?, ?> param) throws Exception;
	
	/**
	 * 기업군 시스템 판정 정보 조회
	 * @param param 기준년도
	 * @return
	 * @throws Exception
	 */
	public Map selectSystemJdgmntManage(Map<?, ?> param) throws Exception;
	
	/**
	 * 기업군 확정 판정 정보 조회
	 * @param param 기준년도
	 * @return
	 * @throws Exception
	 */
	public Map selectDcsnJdgmntManage(Map<?, ?> param) throws Exception;
	
	/**
	 * 기업 판정상세 목록 개수 조회
	 * @param param 기준년도, 검색조건, 판정구분
	 * @return
	 * @throws Exception
	 */
	public int selectEntprsInfoListCountByHpe(Map<?, ?> param) throws Exception;
	
	/**
	 * 기업 판정상세 목록 조회
	 * @param param 기준년도, 검색조건, 판정구분
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectEntprsInfoListByHpe(Map<?, ?> param) throws Exception;
	
	/**
	 * 기업 판정사유 조회
	 * @param param 기준년도, 기업관리코드
	 * @return
	 * @throws Exception
	 */
	public Map selectDcsnJdgmntResnByHpe(Map<?, ?> param) throws Exception;
	
	/**
	 * 첨부파일정보 삭제
	 * @param param
	 * @throws Exception
	 */
	public void updateSetNullAttachFileInfo(Map<?, ?> param) throws Exception;
	
	/**
	 * 시스템판정
	 * @param param
	 * @throws Exception
	 */
	public int callSystemJdgmnt(Map<?, ?> param) throws Exception;
	
	/**
	 * 기업 확정판정
	 * @param resultList
	 * @throws Exception
	 */
	public int callDcsnJdgmnt(Map<?, ?> param) throws Exception;
	
	/**
	 * 개별 확정판정 처리
	 * @param param
	 * @throws Exception
	 */
	public void updateHpeDcsnJdgmnt(Map<?, ?> param) throws Exception;
	
	/**
	 * 개별 확정판정 사유등록
	 * @param param
	 * @throws Exception
	 */
	public void insertHpeDcsnJdgmntResn(Map<?, ?> param) throws Exception;
	
	/**
	 * 기업 시스템판정 데이터 목록 조회(엑셀다운)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectHpeSystemJdgmntDataList(Map<?, ?> param) throws Exception;
	
	/**
	 * 기업 확정판정 데이터 삭제(엑셀업로드)
	 * @param param
	 * @throws Exception
	 */
	public void deleteHpeDcsnJdgmntData(Map<?, ?> param) throws Exception;
	
	/**
	 * 기업 확정판정 데이터 등록(엑셀업로드)
	 * @param param
	 * @throws Exception
	 */
	public void insertHpeDcsnJdgmntData(Map<?, ?> param) throws Exception;
	
	/***
	 * 기업 확정판정 판정자료 백업
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int callDataBackup(Map<?, ?> param) throws Exception;
}
