package biz.tech.mapif.test;

import java.util.List;
import java.util.Map;

import com.comm.page.Pager;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("testMapper")
public interface TestMapper {
	
	/**
	 * 총 메뉴 목록 개수 조회	 
	 * @return 메뉴 목록 개수
	 * @throws Exception
	 */
	public int findTotalUserMenuRowCnt() throws Exception;
	
	
	/**
	 * 메뉴 목록 조회(페이징)
	 * @return 메뉴 목록 개수
	 * @throws Exception
	 */
	public List<Map> findUserMenuWithPaging(Pager pager) throws Exception;	
	
}
