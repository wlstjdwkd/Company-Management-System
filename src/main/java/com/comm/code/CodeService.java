package com.comm.code;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import com.comm.mapif.CodeMapper;

/**
 * 공통코드(캐쉬) 서비스 클래스
 */
@Service("codeService")
public class CodeService extends EgovAbstractServiceImpl {

    @Resource(name="codeMapper")
	private CodeMapper codeDAO;

	/**
	 * 지정된 코드그룹에 속하는 코드목록 조회
	 * @param grpCd 코드그룹번호
	 * @return 코드목록
	 * @throws Exception
	 */
	@Cacheable(value="systemCode", key="#p0")
	public List<CodeVO> findCodesByGroupNo(String grpCd) throws RuntimeException, Exception {
		return codeDAO.findCodesByGroupNo(grpCd);
	}

	/**
	 * 코드그룹 목록 개수
	 * @param param 조회조건
	 * @return 코드그룸목록 개수
	 * @throws Exception
	 */
	public int findCodeGroupListCnt(Map<?, ?> param) throws RuntimeException, Exception {
		return codeDAO.findCodeGroupListCnt(param);
	}

	/**
	 * 코드그룹 목록 조회
	 * @param param 조회조건
	 * @return 코드그룹목록
	 * @throws Exception
	 */
	public List<Map> findCodeGroupList(Map<?, ?> param) throws RuntimeException, Exception {
		return codeDAO.findCodeGroupList(param);
	}

	/**
	 * 코드그룹 정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map<?, ?> findCodeGroup(Map<?, ?> param) throws RuntimeException, Exception {
		return codeDAO.findCodeGroup(param);
	}

	/**
	 * 코드목록 개수 조회
	 * @param param 조회조건
	 * @return 코드목록 개수
	 * @throws Exception
	 */
	public int findCodeListCnt(Map<?, ?> param) throws RuntimeException, Exception {
		return codeDAO.findCodeListCnt(param);
	}

	/**
	 * 코드목록 조회
	 * @param param 조회조건
	 * @return 코드목록
	 * @throws Exception
	 */
	public List<Map> findCodeList(Map<?, ?> param) throws RuntimeException, Exception {
		return codeDAO.findCodeList(param);
	}

	/**
	 * 코드조회
	 * @param param 조회조건
	 * @return
	 * @throws Exception
	 */
	public Map findCodeInfo(Map<?, ?> param) throws RuntimeException, Exception {
		return codeDAO.findCodeInfo(param);
	}

	/**
	 * 코드그룹 및 코드 삭제
	 * @param param 삭제할 코드그룹번호
	 * @return 삭제된 레코드 개수
	 * @throws Exception
	 */
	@CacheEvict(value="systemCode", key="#p0['codeGroupNo']")
	public int deleteCode(Map<?, ?> param) throws RuntimeException, Exception {
		if (codeDAO.findCodeListCnt(param) > 0 ) {
			codeDAO.deleteCode(param);
		}
		return codeDAO.deleteCodeGroup(param);
	}

	/**
	 * 코드그룹 등록/수정 및 코드 등록/삭제
	 * @param param	등록/삭제할 코드그룹번호 또는 코드정보
	 * @return
	 * @throws Exception
	 */
	@CacheEvict(value="systemCode", key="#p0['codeGroupNo']", condition="#p0['codeGroupNo'] != null")
	public void processCode(Map<?, ?> param) throws RuntimeException, Exception {

		String codeGroupNo = null;

		// 코드그룹 정보 등록/수정
		if (param.containsKey("codeGroupNo")) {
			codeDAO.updateCodeGroup(param);
			codeDAO.deleteCode(param);
			codeGroupNo = (String) param.get("codeGroupNo");
		} else {
			codeDAO.insertCodeGroup(param);
			codeGroupNo = codeDAO.findLastCodeGroupNo();
		}

		// 코드등록
		List<Map> codeList = (List<Map>) param.get("codeList");
		for (Map codeInfo : codeList) {
			codeInfo.put("codeGroupNo", codeGroupNo);
			codeDAO.insertCode(codeInfo);
		}
	}

}
