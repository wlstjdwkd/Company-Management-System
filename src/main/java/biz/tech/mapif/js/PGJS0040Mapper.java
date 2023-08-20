package biz.tech.mapif.js;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 관계기업판정처리 Mapper
 * 
 * @author HSC
 * 
 */
@Mapper("PGJS0040Mapper")
public interface PGJS0040Mapper {
	/**
	 * 기준년도 목록 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectStdyyList(Map<?, ?> param) throws Exception;

	/**
	 * 관계기업판정 수집내역 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map selectTbRcpyJdgmntColct(Map<?, ?> param) throws Exception;

	/**
	 * 관계기업판정관리 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map selectTbRcpyJdgmntManage(Map<?, ?> param) throws Exception;

	/**
	 * 관계기업판정관리 삭제(엑셀 파일 업로드)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void deleteTbRcpyJdgmntManage(Map<?, ?> param) throws Exception;

	/**
	 * 관계기업판정 수집내역 삭제(엑셀 파일 업로드)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void deleteTbRcpyJdgmntColct(Map<?, ?> param) throws Exception;

	/**
	 * 관계기업판정결과 삭제(엑셀 파일 업로드)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void deleteTbRcpyJdgmntResult(Map<?, ?> param) throws Exception;
	
	/**
	 * 임시관계기업판정결과 삭제(엑셀 파일 업로드)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void deleteTmpRcpyJdgmntResult() throws Exception;
	
	/**
	 * 관계기업판정기업정보 삭제(엑셀 파일 업로드)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void deleteTbRcpyJdgmntEntrprsInfo(Map<?, ?> param) throws Exception;

	/**
	 * 관계기업판정자료 삭제(엑셀 파일 업로드)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void deleteTbRcpyJdgmntDta(Map<?, ?> param) throws Exception;

	/**
	 * 임시관계기업판정업로드자료 삭제(엑셀 파일 업로드)
	 * 
	 * @param
	 * @return
	 * @throws Exception
	 */
	public void deleteTmpRcpyJdgmntUploadDta() throws Exception;

	/**
	 * 임시관계기업판정업로드자료 추가(엑셀 파일 업로드)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void insertTmpRcpyJdgmntUploadDta(Map<?, ?> param) throws Exception;

	/**
	 * 관계기업판정자료 추가(엑셀 파일 업로드)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void insertTbRcpyJdgmntDta(Map<?, ?> param) throws Exception;

	/**
	 * 관계기업판정기업정보 추가(엑셀 파일 업로드)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void insertTbRcpyJdgmntEntrprsInfo(Map<?, ?> param) throws Exception;

	/**
	 * 관계기업판정기업정보 갱신(기업데이터 업종코드로 변경)(엑셀 파일 업로드)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void updateTbRcpyJdgmntEntrprsInfo(Map<?, ?> param) throws Exception;

	/**
	 * 관계기업판정기업정보 갱신(3년평균매출액1 계산)(엑셀 파일 업로드)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void updateTbRcpyJdgmntEntrprsInfo2(Map<?, ?> param) throws Exception;

	/**
	 * 관계기업판정기업정보 갱신(3년평균매출액2 계산)(엑셀 파일 업로드)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void updateTbRcpyJdgmntEntrprsInfo3(Map<?, ?> param) throws Exception;
	
	/**
	 * 관계기업판정기업정보 갱신(3년평균매출액3 계산)(엑셀 파일 업로드)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void updateTbRcpyJdgmntEntrprsInfo4(Map<?, ?> param) throws Exception;
	
	/**
	 * 관계기업판정기업정보 갱신(3년평균매출액4 계산)(엑셀 파일 업로드)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void updateTbRcpyJdgmntEntrprsInfo5(Map<?, ?> param) throws Exception;
	
	/**
	 * 관계기업판정 수집내역 추가(엑셀 파일 업로드)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void insertTbRcpyJdgmntColct(Map<?, ?> param) throws Exception;

	/**
	 * 관계기업판정관리 추가(엑셀 파일 업로드)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void insertTbRcpyJdgmntManage(Map<?, ?> param) throws Exception;

	/**
	 * 결과테이블에 데이터 저장(엑셀 파일 업로드)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int callInsertRcpyData(Map<?, ?> param) throws Exception;

	/**
	 * 관계기업 판정
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int callRcpyJdgmnt(Map<?, ?> param) throws Exception;

	/**
	 * 관계기업판정기업정보 조회(목록)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectTbRcpyJdgmntEntrprsInfoList(Map<?, ?> param) throws Exception;

	/**
	 * 관계기업판정기업정보 조회(개수)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int selectTbRcpyJdgmntEntrprsInfoCnt(Map<?, ?> param) throws Exception;

	/**
	 * 관계기업판정관리 조회(상세)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map selectTbRcpyJdgmntDetail(Map<?, ?> param) throws Exception;
	
	/**
	 * 관계기업판정기업정보 상위그룹 조회(상세)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectTbRcpyJdgmntUpperDetail(Map<?, ?> param) throws Exception;
	
	/**
	 * 관계기업판정기업정보 하위그룹 조회(상세)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectTbRcpyJdgmntLwprtDetail(Map<?, ?> param) throws Exception;
	
	/**
	 * 관계기업판정기업정보 조회(목록, 엑셀다운로드)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectTbRcpyJdgmntEntrprsInfoListExcel(Map<?, ?> param) throws Exception;
}
