package com.comm.user;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.infra.system.GlobalConst;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.comm.mapif.UserMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 사용자 로그인 및 세션설정 처리 클래스
 * @author sujong
 *
 */
@Service("userService")
public class UserService extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(UserService.class);

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "userMapper")
	private UserMapper userDAO;

	/**
	 * 사용자 조회
	 * @param param 로그인ID
	 * @return 사용자VO
	 * @throws Exception
	 */
	public UserVO findUser(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.findUser(param);
	}

	/**
	 * 사용자 권한그룹 조회
	 * @param param 사용자No
	 * @return 권한그룹목록
	 * @throws Exception
	 */
	public String[] findUserAuthorGroup(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.findUserAuthorGroup(param);
	}

	/**
	 * 사용자 권한목록 조회
	 * @return
	 * @throws Exception
	 */
	public HashMap<String, AuthorityVO> findUserAuthority(Map<String, Object> param) throws RuntimeException, Exception {
		HashMap<String, AuthorityVO> result = new HashMap();

    	for (AuthorityVO vo: userDAO.findUserAuthority(param)) {

    		// 기 등록된 권한이면 merge
    		if (result.containsKey(vo.getProgrmId())) {
    			AuthorityVO preVo = result.get(vo.getProgrmId());
    			if (vo.getMenuOutptAt().equals("Y")) preVo.setMenuOutptAt("Y");
    			if (vo.getInqireAt().equals("Y")) preVo.setInqireAt("Y");
    			if (vo.getStreAt().equals("Y")) preVo.setInqireAt("Y");
    			if (vo.getDeleteAt().equals("Y")) preVo.setDeleteAt("Y");
    			if (vo.getPrntngAt().equals("Y")) preVo.setPrntngAt("Y");
    			if (vo.getExcelAt().equals("Y")) preVo.setExcelAt("Y");
    			if (vo.getSpclAt().equals("Y")) preVo.setSpclAt("Y");
    		}
    		else result.put(vo.getProgrmId(), vo);
    	}

		return result;
	}

	/**
	 * 사용자 등록
	 * @return
	 * @throws Exception
	 */
	public void insertUserInfo(Map<String, Object> param) throws RuntimeException, Exception {
		// 사용자정보 등록
		userDAO.insertUserInfo(param);
		// 사용자권한그룹 등록
		userDAO.insertUserAuthorGroupInfo(param);
		// 사용자약관동의 등록 --> 필요에 의해 주석 풀고 테이블 생성
		/*userDAO.insertUserStplatAgre(param);*/
		logger.debug("########## param ==> ", param.get("USER_NO"));
		if(GlobalConst.EMPLYR_TY_EP.equals(MapUtils.getObject(param, "EMPLYR_TY",""))) {
			// 기업 사용자 등록
			userDAO.insertEntUserInfo(param);
		} else if(GlobalConst.EMPLYR_TY_JB.equals(MapUtils.getObject(param, "EMPLYR_TY",""))) {
			// 기관 사용자 등록
			userDAO.insertEmpUserInfo(param);
		} else {
			// 일반 사용자 등록
			userDAO.insertGnrlUserInfo(param);
		}
	}

	/**
	 * 회원 관리 사용자 등록
	 * @param param
	 * @return 사용자 번호
	 * @throws Exception
	 */
	public String insertUserMgrInfo(Map<String, Object> param) throws RuntimeException, Exception {
		// 사용자정보 등록
		userDAO.insertUserInfo(param);

		// 사용자권한그룹 등록
		for(String authorGroupCode : (String[])MapUtils.getObject(param, "AUTHGRPCODES")) {
			param.put("AUTHOR_GROUP_CODE", authorGroupCode);
			userDAO.insertUserAuthorGroupInfo(param);
		}

		if(GlobalConst.EMPLYR_TY_EP.equals(MapUtils.getObject(param, "EMPLYR_TY",""))) {
			// 기업사용자 등록
			userDAO.insertEntUserInfo(param);
		}else if(GlobalConst.EMPLYR_TY_GN.equals(MapUtils.getObject(param, "EMPLYR_TY",""))) {
			// 일반사용자 등록
			userDAO.insertGnrlUserInfo(param);
		}else {
			// 기관사용자 등록
			userDAO.insertEmpUserInfo(param);
		}

		return MapUtils.getString(param, "USER_NO");
	}

	/**
	 * 회원 관리 사용자 수정
	 * @param param
	 * @return 사용자 번호
	 * @throws Exception
	 */
	public String updateUserMgrInfo(Map<String, Object> param) throws RuntimeException, Exception {

		if(GlobalConst.EMPLYR_TY_EP.equals(MapUtils.getObject(param, "EMPLYR_TY",""))) {
			// 기업사용자 수정
			userDAO.updateEntUserInfo(param);
		}else if(GlobalConst.EMPLYR_TY_GN.equals(MapUtils.getObject(param, "EMPLYR_TY",""))) {
			// 일반사용자 수정
			userDAO.updateGnrlUserInfo(param);
		}else {
			// 기관사용자 수정
			userDAO.updateEmpUserInfo(param);
		}

		// 사용자권한그룹 삭제
		param.put("USER_NO_LIST", new String[] {MapUtils.getString(param, "USER_NO", "")});
		userDAO.deleteUserAuthorGroup(param);

		// 사용자권한그룹 등록
		for(String authorGroupCode : (String[])MapUtils.getObject(param, "AUTHGRPCODES")) {
			param.put("AUTHOR_GROUP_CODE", authorGroupCode);
			userDAO.insertUserAuthorGroupInfo(param);
		}

		return MapUtils.getString(param, "USER_NO");
	}
	
	/**
	 * 회원 관리 사용자 삭제
	 * @param param
	 * @return 사용자 번호
	 * @throws Exception
	 */
	public String deleteUserMgrInfo(Map<String, Object> param) throws RuntimeException, Exception {
		
		//등록의 역순으로 삭제함
		//유형(일반, 기업, 기관)별 사용자 삭제
		userDAO.deleteUsergnrl(param);
		userDAO.deleteUserentrprs(param);
		userDAO.deleteUseremp(param);
		
		//사용자 권한그룹 삭제
		userDAO.deleteUserAuthorGroup(param);
		
		//사용자 상세정보 삭제
		userDAO.deleteUserInfo(param);
		
		return MapUtils.getString(param, "USER_NO_LIST");
	}

	/**
	 * 일반사용자 휴대폰번호 중복 조회
	 * @return
	 * @throws Exception
	 */
	public int findDuplGnrlUserMbtlNum(Map<String, Object> param) throws RuntimeException, Exception {
		// 일반사용자 휴대폰번호 중복 조회
		return userDAO.findDuplGnrlUserMbtlNum(param);
	}

	/**
	 * 일반사용자 이메일 중복 조회
	 * @return
	 * @throws Exception
	 */
	public int findDuplGnrlEmail(Map<String, Object> param) throws RuntimeException, Exception {
		// 일반사용자 휴대폰번호 중복 조회
		return userDAO.findDuplGnrlEmail(param);
	}

	/**
	 * 기업사용자 휴대폰번호 중복 조회
	 * @return
	 * @throws Exception
	 */
	public int findDuplEntUserMbtlNum(Map<String, Object> param) throws RuntimeException, Exception {
		// 기업사용자 휴대폰번호 중복 조회
		return userDAO.findDuplEntUserMbtlNum(param);
	}

	/**
	 * 기업사용자 이메일 중복 조회
	 * @return
	 * @throws Exception
	 */
	public int findDuplEntEmail(Map<String, Object> param) throws RuntimeException, Exception {
		// 기업사용자 휴대폰번호 중복 조회
		return userDAO.findDuplEntEmail(param);
	}

	/**
	 * 전체사용자 이메일 중복 조회
	 * @return
	 * @throws Exception
	 */
	public int findDuplUserEmail(Map<String, Object> param) throws RuntimeException, Exception {
		// 전체사용자 이메일 중복 조회
		return userDAO.findDuplUserEmail(param);
	}

	/**
	 * 법인등록번호 중복 조회
	 * @return
	 * @throws Exception
	 */
	public int findDuplJrirno(Map<String, Object> param) throws RuntimeException, Exception {
		// 기업사용자 휴대폰번호 중복 조회
		return userDAO.findDuplJrirno(param);
	}

	/**
	 * 일반사용자 휴대전화 인증 번호 중복 조회
	 * @return
	 * @throws Exception
	 */
	public int findDuplGnrlMobCrtNo(Map<String, Object> param) throws RuntimeException, Exception {
		// 일반사용자 휴대전화 인증 번호 중복 조회
		return userDAO.findDuplGnrlMobCrtNo(param);
	}

	/**
	 * 기업사용자 휴대전화 인증 번호 중복 조회
	 * @return
	 * @throws Exception
	 */
	public int findDuplEntlMobCrtNo(Map<String, Object> param) throws RuntimeException, Exception {
		// 기업사용자 휴대전화 인증 번호 중복 조회
		return userDAO.findDuplEntlMobCrtNo(param);
	}

	/**
	 * 기관사용자정보 조회
	 * @param param 사용자번호
	 * @return 기관사용자VO
	 * @throws Exception
	 */
	public AllUserVO findEmpUser(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.findEmpUser(param);
	}

	/**
	 *
	 */
	public int findEntUserListCnt(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.findEntUserListCnt(param);
	}

	/**
	 * 기업사용자정보 조회
	 * @param param 사용자번호
	 * @return 기업정보
	 * @throws Exception
	 */
	public List<Map> findEntUserList(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.findEntUserList(param);
	}

	/**
	 * 기업사용자정보 조회
	 * @param param 사용자번호
	 * @return 기업사용자VO
	 * @throws Exception
	 */
	public EntUserVO findEntUser(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.findEntUser(param);
	}

	/**
	 * 기업책임자정보 조회
	 * @param param 사용자번호
	 * @return 기업사용자VO
	 * @throws Exception
	 */
	public EntUserVO findMngUser(Map<String, Object> param) throws Exception {	
		return userDAO.findMngUser(param);
	}
	
	/**
	 * 기업책임자 틀 등록
	 * @param param
	 * @throws Exception
	 */
	public int insertMngUserBase(HashMap param) throws Exception {
		return userDAO.insertMngUserBase(param);	
	}
	
	/**
	 * 기업책임자 등록
	 * @param param
	 * @throws Exception
	 */
	public int insertMngUser(Map<String, Object> param) throws Exception {
		return userDAO.insertMngUser(param);	
	}
	
	/**
	 * 기업사용자정보 조회
	 * @param param Email
	 * @return 기업사용자VO
	 * @throws Exception
	 */
	public EntUserVO findEntUserByEmail(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.findEntUser(param);
	}

	/**
	 * 법인등록번호로 기업사용자 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public EntUserVO findEntUserByJurirno(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.findEntUserByJurirno(param);
	}

	/**
	 * 일반사용자정보 조회
	 * @param param 사용자번호
	 * @return 일반사용자정보
	 * @throws Exception
	 */
	public AllUserVO findGnrUser(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.findGnrUser(param);
	}

	/**
	 * 모든사용자정보 조회카운트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int findAllUserCnt(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.findAllUserCnt(param);
	}

	/**
	 * 회원유형별 카운트
	 * @return
	 * @throws Exception
	 */
	public List<Map> findUserCntByType() throws RuntimeException, Exception {
		return userDAO.findUserCntByType();
	}

	/**
	 * 회원권한별 카운트
	 * @return
	 * @throws Exception
	 */
	public List<Map> findUserCntByauth() throws RuntimeException, Exception {
		return userDAO.findUserCntByauth();
	}

	/**
	 * 모든사용자정보 조회
	 * @param param 검색조건
	 * @return
	 * @throws Exception
	 */
	public List<AllUserVO> findAllUser(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.findAllUser(param);
	}

	/**
	 * 사용자권한그룹 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteUserAuthorGroup(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.deleteUserAuthorGroup(param);
	}

	/**
	 * 사용자권한그룹 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertUserAuthorGroupInfo(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.insertUserAuthorGroupInfo(param);
	}

	/**
	 * 패스워드초기화
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateInitializePwd(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.updateInitializePwd(param);
	}

	/**
	 * 일반사용자 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateGnrlUserInfo(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.updateGnrlUserInfo(param);
	}

	/**
	 * 기업사용자 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateEntUserInfo(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.updateEntUserInfo(param);
	}

	/**
	 * 기업책임자 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateMngUserInfo(Map<String, Object> param) throws Exception {
		return userDAO.updateMngUserInfo(param);
	}
	
	/**
	 * 사용자정보 상태 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateUserWithdrawal(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.updateUserWithdrawal(param);
	}

	/**
	 * 기업사용자정보 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateEntrprsUserWithdrawal(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.updateEntrprsUserWithdrawal(param);
	}

	/**
	 * 아이디찾기 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findUserId(HashMap param) throws RuntimeException, Exception {
		List<Map> result = userDAO.findUserId(param);
		return result;
	}

	/**
	 * 비밀번호찾기 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map findUserPwd(HashMap param) throws RuntimeException, Exception {
		Map result = userDAO.findUserPwd(param);
		return result;
	}

	/**
	 * 접근통제 IP여부 체크
	 * @param param
	 * @return
	 * @throws Exceptoin
	 */
	public boolean validateIPAddress(Map<String, Object> param) throws RuntimeException, Exception {
		if (userDAO.validateIPAddress(param) > 0) return true;
		else return false;
	}

	/**
	 * 개별 SMS 전송
	 * @param param
	 * @throws Exception
	 */
	public int insertSms(HashMap param) throws RuntimeException, Exception {
		return userDAO.insertSms(param);
	}

	/**
	 * 개별 EMAIL 전송
	 * @param param
	 * @throws Exception
	 */
	public int insertEmail(HashMap param) throws RuntimeException, Exception {
		return userDAO.insertEmail(param);
	}

	/**
	 * 로그인일자 업데이트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateLoginDe(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.updateLoginDe(param);
	}

	/**
	 * 로그아웃일자 업데이트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateLogoutDe(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.updateLogoutDe(param);
	}

	/**
	 * 기업담당자정보 조회
	 * @param param 사용자번호
	 * @return 기업담당자정보
	 * @throws Exception
	 */
	public List<Map> findEntCharger(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.findEntCharger(param);
	}

	/**
	 * 기업담당자정보 변경요청 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertChangeEntCharger(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.insertChangeEntCharger(param);
	}

	/**
	 * 기업담당자정보 변경요청 등록번호 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int selectChangeEntChargerSn(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.selectChangeEntChargerSn(param);
	}

	/**
	 * 기업담당자정보 변경요청 파일정보 업데이트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateChangeEntCharger(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.updateChangeEntCharger(param);
	}

	/**
	 * 기업담당자정보 변경요청 조회카운트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int selectChangeChargerCnt(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.selectChangeChargerCnt(param);
	}

	/**
	 * 모든사용자정보 조회
	 * @param param 검색조건
	 * @return
	 * @throws Exception
	 */
	public  List<Map> selectChangeCharger(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.selectChangeCharger(param);
	}

	/**
	 * 사용자정보 조회
	 * @param param 검색조건
	 * @return
	 * @throws Exception
	 */
	public Map selectChangeChargerInfo(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.selectChangeChargerInfo(param);
	}

	/**
	 * 기업담당자정보 업데이트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateChargerInfo(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.updateChargerInfo(param);
	}

	/**
	 * 패스워드 초기화 대상 기업사용자 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map selectPwdInitEntUserInfo(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.selectPwdInitEntUserInfo(param);
	}

	/**
	 * 담당자변경신청 기업사용자 아이디 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map selectIdUserInfo(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.selectIdUserInfo(param);
	}

	/**
	 * 기업명 업데이트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateEntrprsNmInfo(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.updateEntrprsNmInfo(param);
	}

	/**
	 * 기업담당자변경요청 적용여부 업데이트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateApplcAt(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.updateApplcAt(param);
	}

	/**
	 * 기업담당자정보 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteChargerInfo(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.deleteChargerInfo(param);
	}

	/**
	 * 유저의 상태정보 업데이트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateUserStatus(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.updateUserStatus(param);
	}

	/**
	 * 유저의 비밀번호 업데이트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateUserPassword(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.updateUserPassword(param);
	}

	/**
	 * 마이페이지 접수승인관련 승인대기인 상태 카운트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int findConfirmWaitStatusCnt(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.findConfirmWaitStatusCnt(param);
	}

	/**
	 * 알림정보조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findNotificationList(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.findNotificationList(param);
	}

	/**
	 * 나의 대체결재자 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map findMyAltrtvConfrmer(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.findMyAltrtvConfrmer(param);
	}

	/**
	 * 내가 다른사람의 대체결재자 일떄
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map> findAltrtvConfrmerList(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.findAltrtvConfrmerList(param);
	}

	/**
	 * 로그인 실패 횟수 업데이트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateLoginFailCnt(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.updateLoginFailCnt(param);
	}

	/**
	 * 로그인 실패 날짜 업데이트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateLoginFailDt(Map<String, Object> param) throws RuntimeException, Exception {
		return userDAO.updateLoginFailDt(param);
	}

}