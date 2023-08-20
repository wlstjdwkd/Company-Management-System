package biz.tech.mapif.ps;

import java.util.List;
import java.util.Map;

import com.comm.page.Pager;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 기업정보 Mapper
 * @author CWJ
 *
 */
@Mapper("PGPS0020Mapper")
public interface PGPS0020Mapper {
	
	/**
	 * 주요지표 현황 목록 개수 조회	 
	 * @return 목록 개수
	 * @throws Exception
	 */
	public int findTotalIdxInfoRowCnt(Map<?, ?> param) throws Exception;
	
	/**
	 * 지역(본사기준)-시/도 조회	 
	 * @return 목록
	 * @throws Exception
	 */
	public List<Map> findAreaSelect(Map<?, ?> param) throws Exception;
	
	/**
	 * 주요지표-현황 조회
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> idxList(Map<?, ?> param) throws Exception;
	
	/**
	 * 주요지표-현황 맵챠트용
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> idxMapChart(Map<?, ?> param) throws Exception;
	
	/**
	 * 주요지표-현황 조건없이 조회
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> idxListAll(Map<?, ?> param) throws Exception;
	
	/**
	 * 주요지표-구간별현황 조회
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> sectionIdxList(Map<?, ?> param) throws Exception;
	
	/**
	 * 주요지표-구간별현황 조건없이 조회
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> sectionIdxListAll(Map<?, ?> param) throws Exception;
	
	/**
	 * 주요지표-추이 조회 (총액)
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> trnsitnList(Map<?, ?> param) throws Exception;
	
	/**
	 * 주요지표-추이 조회 (평균)
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> trnsitnListAvg(Map<?, ?> param) throws Exception;
	
	
	/**
	 * 주요지표-구간별추이 조회
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> sectionTrnsitnList(Map<?, ?> param) throws Exception;
	
	/**
	 * 주요지표-구간별추이 조건없이 조회
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> sectionTrnsitnListAll(Map<?, ?> param) throws Exception;
	
	/**
	 * 테마별업종 조회
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> indutyCd(Map<?, ?> param) throws Exception;
	
	/**
	 * 테마별업종 조회(제조업)
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> indutyCd2(Map<?, ?> param) throws Exception;
	
	/**
	 * 테마별업종 조회(비제조업)
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> indutyCd3(Map<?, ?> param) throws Exception;
	
	/**
	 * 시도별 코드 조회
	 * @return 메뉴 목록
	 * @throws Exception
	 */
	public List<Map> findCodesCity(Map<?, ?> param) throws Exception;
	
	
	
	
	
	/*
	 * ############## 주요지표현황(2015.01.13 강수종) #############
	 */
	
	/**
	 * 주요지표현황 데이터 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectIndxStaticsDataList(Map<?, ?> param) throws Exception;
	
	/*
	 * ############## 주요지표현황(2015.01.13 강수종) #############
	 */
	
	/**
	 * 구간별현황 데이터 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectSctnStaticsDataList(Map<?, ?> param) throws Exception;
}

