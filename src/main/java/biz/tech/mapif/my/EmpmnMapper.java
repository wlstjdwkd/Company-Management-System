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
@Mapper("empmnMapper")
public interface EmpmnMapper {
	
	/**
	 * 채용기업소개 리스트 카운트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int findCmpnyIntrcnCount(Map<?, ?> param) throws Exception;
	
	/**
	 * 채용기업소개 리스트 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findCmpnyIntrcnList(Map<?, ?> param) throws Exception;
	
	/**
	 * 채용 추천 기업 로고 리스트 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findCmpnyIntrcnRecomendLogoList() throws Exception;
	
	/**
	 * 채용기업소개 상세조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map findCmpnyIntrcnInfo(Map<?, ?> param) throws Exception;
	
	/**
	 * 채용기업소개 상세조회(기업정보테이블 조회)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map findIntrcnInfo(Map<?, ?> param) throws Exception;
	
	/**
	 * 채용기업소개 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertCmpnyIntrcnInfo(Map<?, ?> param) throws Exception;
	
	/**
	 * 채용기업소개 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	//public int updateCmpnyIntrcnInfo(Map<?, ?> param) throws Exception;
	
	/**
	 * 채용기업소개 삭제
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	public int deleteCmpnyIntrcnInfo(Map<?,?> param) throws Exception;
	
	/**
	 * 대분류 직종 코드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectJssfcLargeList() throws Exception;
	
	/**
	 * 채용기업소개 기업특성 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectCmpnyIntrcnChartr(Map<?,?> param) throws Exception;
	
	/**
	 * 채용기업소개 기업특성 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertCmpnyIntrcnChartr(Map<?,?> param) throws Exception;
	
	/**
	 * 채용기업소개 기업특성 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteCmpnyIntrcnChartr(Map<?,?> param) throws Exception;
	
	
	/**
	 * 채용기업소개 레이아웃 이미지 리스트 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	//public List<Map> findCmpnyIntrcnLayoutImageList(Map<?,?> param) throws Exception;
	
	/**
	 * 채용기업소개 레이아웃 텍스트 리스트 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	//public List<Map> findCmpnyIntrcnLayoutTextList(Map<?,?> param) throws Exception;
	
	/**
	 * 채용기업소개 레이아웃 이미지 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map findCmpnyIntrcnLayoutImage(Map<?,?> param) throws Exception;
	
	/**
	 * 채용기업소개 레이아웃 이미지 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int findCmpnyIntrcnLayoutSn(Map<?,?> param) throws Exception;
	
	/**
	 * 채용기업소개 레이아웃 이미지 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int findCmpnyIntrcnLayoutMaxSn(Map<?,?> param) throws Exception;
	
	
	/**
	 * 채용기업소개 레이아웃 이미지 리스트 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findCmpnyIntrcnLayoutList(Map<?,?> param) throws Exception;

	/**
	 * 채용기업소개 레이아웃 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertCmpnyIntrcnLayout(Map<?,?> param) throws Exception;
	
	/**
	 * 채용기업소개 레이아웃 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateCmpnyIntrcnLayout(Map<?,?> param) throws Exception;
	
	/**
	 * 채용기업소개 레이아웃 텍스트 삭제
	 * @param param
	 * @return
	 * @throws Exception 
	 */
	//public int deleteCmpnyIntrcnLayoutText(Map<?,?> param) throws Exception;
	
	/**
	 * 채용기업소개 레이아웃 삭제
	 * @param param
	 * @return
	 * @throws Exception 
	 */
	public int deleteCmpnyIntrcnLayout(Map<?,?> param) throws Exception;
	
	/**
	 * 채용기업 추천/해제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateRecomendEntrprsAt(Map<?,?> param) throws Exception;
	
	/**
	 * 채용기업소개 레이아웃 이미지 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateCmpnyIntrcnLayoutImage(Map<?,?> param) throws Exception;
	
	/**
	 * 채용기업소개 레이아웃 이미지 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteCmpnyIntrcnLayoutImage(Map<?,?> param) throws Exception;
	
	/**
	 * 사진 첨부 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertAtchPhoto(Map<?, ?> param) throws Exception;
	
	/**
	 * 사진 첨부 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateAtchPhoto(Map<?, ?> param) throws Exception;
	
	/**
	 * 채용공고 카운트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int findEmpmnPblancInfoCount(Map<?, ?> param) throws Exception;
	
	/**
	 * 채용공고 리스트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findEmpmnPblancInfoList(Map<?, ?> param) throws Exception;
	
	/**
	 * 채용공고 필터 카운트
	 * @param param
	 * @return int
	 * @throws Exception
	 */
	public int findFilterEmpmnPblancInfoCnt(Map<?, ?> param) throws Exception;
	
	/**
	 * 채용공고 필터 리스트
	 * @param param
	 * @return 
	 * @throws Exception 
	 */
	public List<Map> findFilterEmpmnPblancInfoList(Map<?,?> param) throws Exception;
	
	/**
	 * 채용공고 제목 필터 목록
	 * @param param
	 * @return 
	 * @throws Exception 
	 */
	public List<Map> findFilterItemA(Map<?,?> param) throws Exception;
	
	/**
	 * 채용공고 직종 필터 목록
	 * @param param
	 * @return 
	 * @throws Exception 
	 */
	public List<Map> findFilterItemB(Map<?,?> param) throws Exception;
	
	
	/**
	 * 채용공고 상세조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map findEmpmnPblancInfo(Map<?, ?> param) throws Exception;
	
	/**
	 * 채용공고 항목관리 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findEmpmnItem(Map<?, ?> param) throws Exception;
	
	/**
	 * 채용공고 항목값 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String[] findEmpmnIemValue(Map<?, ?> param) throws Exception;
	
	/**
	 * 채용공고 항목명 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String[] findEmpmnIemCodeNm(Map<?, ?> param) throws Exception;
	
	/**
	 * 채용공고 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertEmpmnPblancInfo(Map<?, ?> param) throws Exception;
	
	/**
	 * 채용공고 항목관리 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertEmpmnItem(Map<?, ?> param) throws Exception;
	
	/**
	 * 채용공고 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateEmpmnPblancInfo(Map<?, ?> param) throws Exception;
	
	/**
	 * 채용공고 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteEmpmnPblancInfo(Map<?, ?> param) throws Exception;
	
	/**
	 * 채용공고 항목관리 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteEmpmnItem(Map<?, ?> param) throws Exception;
	
	/**
	 * 주요지표현황 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findEmpmnIndexInfo(Map<?, ?> param) throws Exception;
	
	/**
	 * 채용공고 첨부파일 정보 변경
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateEmpmnPblancFile(Map<?, ?> param) throws Exception;
	
	/**
	 * 이전글 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map findPreList(Map<?, ?> param) throws Exception;
	
	/**
	 * 다음글 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map findNextList(Map<?, ?> param) throws Exception;
	
	/**
	 * 채용기업소개 목록 카운트(관리자)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int findMngEntrprsListCnt(Map<?, ?> param) throws Exception;
	
	/**
	 * 채용기업소개 목록 조회(관리자)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findMngEntrprsList(Map<?, ?> param) throws Exception;	
	
	/**
	 * 법인등록번호에 해당하는 채용기업소개 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int findDupleEmpmnCmpny(Map<?, ?> param) throws Exception;
	
	/**
	 * 채용기업소개 등록(관리자)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertEmpmnCmpnyMng(Map<?, ?> param) throws Exception;

	/**
	 * 채용기업소개 등록(모바일)
	 * @param param
	 * @return List<Map>
	 * @throws Exception
	 */
	public List<Map> findEmpmnPblancCurInfoList(Map<?,?> param) throws Exception;
}
