package biz.tech.mapif.am;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;



@Mapper("PGAM0001Mapper")
public interface PGAM0001Mapper {
	
	public int findConfirmSttus (Map<?, ?> param) throws Exception;

	public int findRssSttus (Map<?, ?> param) throws Exception;

	public int findQaSttus (Map<?, ?> param) throws Exception;

	public int findRequestSttus (Map<?, ?> param) throws Exception;
	
	public int findDocReportCnt (Map<?, ?> param) throws Exception;

	public int findUserInfoCnt (Map<?, ?> param) throws Exception;

	public int findUserAccrueCnt (Map<?, ?> param) throws Exception;

	public int findVisitCnt (Map<?, ?> param) throws Exception;
	
//정보변경신청 메인표시
	public int entprsChanger (Map<?, ?>param) throws Exception;

//

}