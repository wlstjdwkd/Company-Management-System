package com.comm.mapif;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("PGCMAPRV0010Mapper")
public interface PGCMAPRV0010Mapper
{
	//결재선 목록 조회
	public List<Map> getBasisProgrsList(Map<?,?> param) throws RuntimeException, Exception;
	//결재선 목록 갯수 조회
	public int getBasisProgrsListCnt(Map<?,?> param) throws RuntimeException, Exception;
	//결재선 목록 상세조회
	public List<Map> getBasisProgrsDetailList(Map<?,?> param) throws RuntimeException, Exception;
	//결재선번호 조회
	public int findSanctnSeq(Map<?,?> param) throws RuntimeException, Exception;
	//등록자 정보 조회
	public Map findEmplyrInfo(Map<?,?> param) throws RuntimeException, Exception;
	//직원 조회
	public List<Map> findConfirmerList(Map<?,?> param) throws RuntimeException, Exception;
	//기본결재선 등록
	public int insertBasisProgrs(Map<?,?> param) throws RuntimeException, Exception;
	//기본결재선 수정
	public int deleteBasisProgrs(Map<?,?> param) throws RuntimeException, Exception;
	//대체 결재자 정보 조회
	public Map findAltrtvConfrm(Map<?,?> param) throws RuntimeException, Exception;
}
