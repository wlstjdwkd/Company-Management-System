package biz.tech.em;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import biz.tech.mapif.em.PGEM0090Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 프로그램 관리 처리 클래스
 */
@Service("PGEM0090ServicePG")
public class PGEM0090ServicePG extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGEM0090ServicePG.class);

	@Resource(name="PGEM0090Mapper")
	PGEM0090Mapper PGEM0090DAO;
	
	    /**
		 * 직원 등록
		 * @param param 조회범위 및 조회조건
		 * @return
		 * @throws Exception
		 */
		public void insertMember(Map<?, ?> param) throws RuntimeException, Exception {
			PGEM0090DAO.insertMember(param);
		}
		
	  /**
		 * 직원 조회
		 * @param param 조회범위 및 조회조건
		 * @return
		 * @throws Exception
		 */
		
		 public Map<?, ?> findUsermember(Map<?, ?> param) throws RuntimeException, Exception { 
			 return PGEM0090DAO.findUsermember(param); }
		
		/**
		 * 직원 삭제
		 * @param param 조회범위 및 조회조건
		 * @return
		 * @throws Exception
		 */
		public void deletemember(Map<?, ?> param) throws RuntimeException, Exception {
			PGEM0090DAO.deletemember(param);
		}

		/**
		 * 직원 수정
		 * @param param 조회범위 및 조회조건
		 * @return
		 * @throws Exception
		 */
		public void updatemember(Map<?, ?> param) throws RuntimeException, Exception {
			PGEM0090DAO.updatemember(param);
		}
		
		/**
		 * 직원 갯수 조회(중복체크)
		 * @param param
		 * @return
		 * @throws Exception
		 */
	    public int selectmemberCnt(Map<?, ?> param) throws RuntimeException, Exception {
			return PGEM0090DAO.selectmemberCnt(param);
		}
	    
		/**
		 * 직원 조회
		 */
		public List<Map> findmember(Map<?, ?> param) throws RuntimeException, Exception {
			return PGEM0090DAO.findmember(param);
		}
		
		public int findUsermemberlist(Map<?, ?> param) throws RuntimeException, Exception {
			return PGEM0090DAO.findUsermemberlist(param);
		}

}
