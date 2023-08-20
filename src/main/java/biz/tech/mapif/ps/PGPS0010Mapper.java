package biz.tech.mapif.ps;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 기업정보 Mapper
 * @author wonjae
 *
 */
@Mapper("PGPS0010Mapper")
public interface PGPS0010Mapper {
	
	/**
	 * 기준년도 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectStdyyList(Map<?, ?> param) throws Exception;
	
	/**
	 * 기업정보 목록 개수 조회	 
	 * @return 목록 개수
	 * @throws Exception
	 */
	public int findTotalEntprsInfoRowCnt(Map<?, ?> param) throws Exception;

	/**
	 * 기업정보 목록 조회(페이징)
	 * @return 메뉴 목록 개수
	 * @throws Exception
	 */
	//public List<Map> entprsList(Pager pager) throws Exception;
	public List<Map> entprsList(Map<?, ?> param) throws Exception;
	
	/**
	 * 엑셀다운 대상 기업코드 목록조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String[]	selectEntrprsPKList(Map<?, ?> param) throws Exception;
	
	/**
	 * 개황, 사유, 재무항목 데이터 목록조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectExcelBasicDataList(Map<?, ?> param) throws Exception;
	
	/**
	 * 출자피출자기업 데이터 목록조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectExcelInvstDataList(Map<?, ?> param) throws Exception;
	
	
	/**
	 * 기업정보 목록 조회(엑셀저장용)
	 * @return 메뉴 목록 개수
	 * @throws Exception
	 */
	public List<Map> entprsListExcel(Map<?, ?> param) throws Exception;
	
	
	/**
	 * 기업정보 상세 조회(페이징)
	 * @return 기업상세정보
	 * @throws Exception
	 */
	public Map selectEntrprsResult(Map<?,?> param) throws Exception;
	
	/**
	 * 기업정보 재무정보
	 * @return 기업상세정보
	 * @throws Exception
	 */
	public List<Map> selectFnnrResult(Map<?,?> param) throws Exception;
	
	/**
	 * 기업정보 수출정보
	 * @return 기업상세정보
	 * @throws Exception
	 */
	public List<Map> selectExportResult(Map<?,?> param) throws Exception;
	
	/**
	 * 기업정보 특허정보
	 * @return 기업상세정보
	 * @throws Exception
	 */
	public List<Map> selectPatentResult(Map<?,?> param) throws Exception;
	
	/**
	 * 기업정보 출자 / 피출자
	 * @return 기업상세정보
	 * @throws Exception
	 */
	public List<Map> selectInvstmntResult(Map<?,?> param) throws Exception;
	
	/**
	 * 기업정보 거래처정보
	 * @return 기업상세정보
	 * @throws Exception
	 */
	public List<Map> selectBcncResult(Map<?,?> param) throws Exception;
	
	/**
	 * 기업정보 판정정보
	 * @return 기업상세정보
	 * @throws Exception
	 */
	public List<Map> selectJdgmntResult(Map<?,?> param) throws Exception;
	
	/**
	 * 지역(본사기준)-시/도 조회	 
	 * @return 목록
	 * @throws Exception
	 */
	public List<Map> areaSelect() throws Exception;
	
	/**
	 * 주요지표-현황 목록 개수	 
	 * @return 목록 개수
	 * @throws Exception
	 */
	public int findTotalIdxSttusRowCnt(Map<?, ?> param) throws Exception;
	
	/**
	 * 지표현황 조회(페이징)
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> idxList(Map<?, ?> param) throws Exception;
	
	/**
	 * 기업정보 목록 조회(pc)
	 * @return 메뉴 목록 개수
	 * @throws Exception
	 */
	public List<Map> selectEntprsList (Map<?,?> param) throws Exception;
	
	public int findEntprsListCnt (Map<?,?> param) throws Exception;
	
	
	/**
	 * 지역 약칭 리스트 검색
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectAbrvList () throws Exception;
	
	/**
	 * 기업정보 주가정보
	 * @return 기업상세정보
	 * @throws Exception
	 */
	public List<Map> selectStkData(Map<?,?> param) throws Exception;
	
	/**
	 * 기업정보 재무정보
	 * @return 기업상세정보
	 * @throws Exception
	 */
	public List<Map> selectPointFnnrResult(Map<?,?> param) throws Exception;
	
	/**
	 * 기업정보 목록 개수 조회	 
	 * @return 목록 개수
	 * @throws Exception
	 */
	public int findTotalEntprsInfoRowCnt2(Map<?, ?> param) throws Exception;

	/**
	 * 기업정보 목록 조회(페이징)
	 * @return 메뉴 목록 개수
	 * @throws Exception
	 */
	public List<Map> entprsList2(Map<?, ?> param) throws Exception;
	
	/**
	 * 엑셀다운 대상 기업코드 목록조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String[]	selectEntrprsPKList2(Map<?, ?> param) throws Exception;
}

