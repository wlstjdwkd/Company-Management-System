package com.comm.program;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import com.comm.mapif.ProgramMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 프로그램 관리 처리 클래스
 */
@Service("programService")
public class ProgramService extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(ProgramService.class);

	@Resource(name="programMapper")
	ProgramMapper programDAO;

	/**
	 * 프로그램 정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Cacheable(value="programInfo", key="#p0['progrmId']")
	public Map<?, ?> findProgram(Map<?, ?> param) throws RuntimeException, Exception {
		return programDAO.findProgram(param);
	}

	/**
	 * 프로그램 목록 갯수 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int findProgramListCnt(HashMap param) throws RuntimeException, Exception {
		int result = programDAO.findProgramListCnt(param);
		return result;
	}

	/**
	 * 프로그램 목록 조회
	 * @param param 조회범위 및 조회조건
	 * @return
	 * @throws Exception
	 */
	public List<Map> findProgramList(HashMap param) throws RuntimeException, Exception {
		List<Map> result = programDAO.findProgramList(param);

    	return result;
	}

	/**
	 * 프로그램 등록
	 * @param param 조회범위 및 조회조건
	 * @return
	 * @throws Exception
	 */
	public void insertProgram(Map<?, ?> param) throws RuntimeException, Exception {
			programDAO.insertProgram(param);
	}

	/**
	 * 권한정보 등록
	 * @param param
	 * @throws Exception
	 */
	public void insertAuthor(Map<?, ?> param) throws RuntimeException, Exception {
		programDAO.insertAuthor(param);
	}

	/**
	 * 프로그램 수정
	 * @param param
	 * @throws Exception
	 */
	@CacheEvict(value="programInfo", key="#p0['progrmId']")
	public void updateProgram(Map<?,?> param) throws RuntimeException, Exception {
		programDAO.updateProgram(param);
	}

	/**
	 * 프로그램 삭제
	 * @param param 조회범위 및 조회조건
	 * @return
	 * @throws Exception
	 */
	@CacheEvict(value="programInfo", key="#p0['progrmId']")
	public void deleteProgram(Map<?, ?> param) throws RuntimeException, Exception {
		programDAO.deleteProgram(param);
	}

	/**
	 * 권한 정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map<?, ?> findAuthor(Map<?, ?> param) throws RuntimeException, Exception {
		return programDAO.findAuthor(param);
	}

	/**
	 * 권한 정보 삭제
	 * @param param 조회범위 및 조회조건
	 * @return
	 * @throws Exception
	 */
	public void deleteAuthor(Map<?, ?> param) throws RuntimeException, Exception {
		programDAO.deleteAuthor(param);
	}

	/**
	 * 권한 정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findCodeAuthorList(Map<?, ?> param) throws RuntimeException, Exception {
		return programDAO.findCodeAuthorList(param);
	}

	/**
	 * 프로그램 갯수 조회(중복체크)
	 * @param param
	 * @return
	 * @throws Exception
	 */
    public int selectProgrmCnt(Map<?, ?> param) throws RuntimeException, Exception {
		return programDAO.selectProgrmCnt(param);
	}

}
