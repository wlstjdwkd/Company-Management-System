package biz.tech.mapif.ps;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 기업정보 Mapper
 * @author CWJ
 *
 */
@Mapper("PGPS0050Mapper")
public interface PGPS0050Mapper {
	
	/**
	 * 가젤형기업현황 업종별분포추이 데이터 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectStaticsDataList(Map<?, ?> param) throws Exception;
	
	/**
	 * 가젤형기업현황 기업규모별현황 데이터 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectStaticsDataListScle(Map<?, ?> param) throws Exception;
	
	/**
	 * 가젤형기업현황 업력별분포 & 주요지표현황 데이터 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectStaticsDataListHistIndx(Map<?, ?> param) throws Exception;

}

