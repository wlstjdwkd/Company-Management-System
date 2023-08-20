package com.comm.mapif;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comm.user.AllUserVO;
import com.comm.user.AuthorityVO;
import com.comm.user.EntUserVO;
import com.comm.user.UserVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 사용자 Mapper
 * @author sujong
 *
 */
@Mapper("userMapper")
public interface UserMapper {

	/**
	 * 사용자 정보 조회
	 * @param param 사용자 ID
	 * @return 사용자정보
	 * @throws RuntimeException, Exception
	 */
	public UserVO findUser(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 사용자에게 할당된 권한그룹 조회
	 * @param param 사용자 No
	 * @return	권한그룹코드
	 * @throws RuntimeException, Exception
	 */
	public String[] findUserAuthorGroup(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 사용자에게 할당된 권한목록 조회
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public List<AuthorityVO> findUserAuthority(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 사용자정보 등록
	 * @param param 사용자정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int insertUserInfo(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 일반사용자 등록
	 * @param param 사용자정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int insertGnrlUserInfo(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기업사용자 등록
	 * @param param 사용자정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int insertEntUserInfo(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기관사용자 등록
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int insertEmpUserInfo(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 사용자권한그룹 등록
	 * @param param 사용자정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int insertUserAuthorGroupInfo(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 사용자약관동의 등록
	 * @param param 사용자정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int insertUserStplatAgre(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 일반사용자 휴대폰번호 중복 조회
	 * @param param 사용자정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int findDuplGnrlUserMbtlNum(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 일반사용자 이메일 중복 조회
	 * @param param 사용자정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int findDuplGnrlEmail(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기업사용자 휴대폰번호 중복 조회
	 * @param param 사용자정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int findDuplEntUserMbtlNum(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기업사용자 이메일 중복 조회
	 * @param param 사용자정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int findDuplEntEmail(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 전체사용자 이메일 중복 조회
	 * @param param 사용자정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int findDuplUserEmail(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 법인등록번호 중복 조회
	 * @param param 사용자정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int findDuplJrirno(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 일반사용자 휴대전화 인증 번호 중복 조회
	 * @param param 사용자정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int findDuplGnrlMobCrtNo(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기업사용자 휴대전화 인증 번호 중복 조회
	 * @param param 사용자정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int findDuplEntlMobCrtNo(Map<String, Object> param) throws RuntimeException, Exception;


	/**
	 * 기관사용자정보 조회
	 * @param param 사용자번호
	 * @return 기업정보
	 * @throws RuntimeException, Exception
	 */
	public AllUserVO findEmpUser(Map <String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기업 사용자정보 리스트 카운트
	 * @param param
	 * @return 기업정보 리스트 카운트
	 * @throws RuntimeException, Exception
	 */
	public int findEntUserListCnt(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기업사용자정보 리스트 조회
	 * @param param
	 * @return 기업정보 리스트
	 * @throws RuntimeException, Exception
	 */
	public List<Map> findEntUserList(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기업사용자정보 조회
	 * @param param 사용자번호
	 * @return 기업정보
	 * @throws RuntimeException, Exception
	 */
	public EntUserVO findEntUser(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기업책임자정보 조회
	 * @param param 사용자번호
	 * @return 기업정보
	 * @throws RuntimeException, Exception
	 */
	public EntUserVO findMngUser(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기업책임자 틀 등록
	 * @param param
	 * @throws RuntimeException, Exception
	 */
	public int insertMngUserBase(HashMap param) throws RuntimeException, Exception;

	/**
	 * 기업책임자 등록
	 * @param param
	 * @throws RuntimeException, Exception
	 */
	public int insertMngUser(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기업사용자정보 조회
	 * @param param email
	 * @return 기업정보
	 * @throws RuntimeException, Exception
	 */
	public EntUserVO findEntUserByEmail(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 법인등록번호로 기업사용자 조회
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public EntUserVO findEntUserByJurirno(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 일반사용자정보 조회
	 * @param param 사용자번호
	 * @return 일반사용자정보
	 * @throws RuntimeException, Exception
	 */
	public AllUserVO findGnrUser(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 모든사용자정보 조회 카운트
	 * @param param 검색조건
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int findAllUserCnt(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 회원유형별 카운트
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public List<Map> findUserCntByType() throws RuntimeException, Exception;

	/**
	 * 회원권한별 카운트
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public List<Map> findUserCntByauth() throws RuntimeException, Exception;

	/**
	 * 모든사용자정보 조회
	 * @param param 검색조건
	 * @return 사용자정보
	 * @throws RuntimeException, Exception
	 */
	public List<AllUserVO> findAllUser(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 일반 사용자 정보 삭제
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int deleteUsergnrl(Map<String, Object> param) throws RuntimeException, Exception;
	
	/**
	 * 기업 사용자 정보 삭제
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int deleteUserentrprs(Map<String, Object> param) throws RuntimeException, Exception;
	
	/**
	 * 기관 사용자 정보 삭제
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int deleteUseremp(Map<String, Object> param) throws RuntimeException, Exception;
	
	/**
	 * 사용자권한그룹 삭제
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int deleteUserAuthorGroup(Map<String, Object> param) throws RuntimeException, Exception;
	
	/**
	 * 사용자 정보 삭제
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int deleteUserInfo(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 패스워드초기화
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateInitializePwd(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 일반사용자 수정
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateGnrlUserInfo(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기업사용자 수정
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateEntUserInfo(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기업책임자 수정
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateMngUserInfo(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기관사용자 수정
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateEmpUserInfo(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 사용자정보 상태 수정
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateUserWithdrawal(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기업사용자정보 수정
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateEntrprsUserWithdrawal(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 아이디찾기 조회
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public  List<Map> findUserId(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 비밀번호찾기 조회
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public Map findUserPwd(Map<?,?> param) throws RuntimeException, Exception;

	/**
	 * 접근통제 IP여부 체크
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int validateIPAddress(Map<?,?> param) throws RuntimeException, Exception;

	/**
	 * 개별 SMS 전송
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int insertSms(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 개별 EMAIL 전송
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int insertEmail(Map<?, ?> param) throws RuntimeException, Exception;

	/**
	 * 로그인일자 업데이트
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateLoginDe(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 로그아웃일자 업데이트
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateLogoutDe(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기업담당자정보 조회
	 * @param param
	 * @return 기업담당자정보
	 * @throws RuntimeException, Exception
	 */
	public List<Map> findEntCharger(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기업담당자정보 변경요청 등록
	 * @param param 사용자정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int insertChangeEntCharger(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기업담당자정보 변경요청 등록번호 조회
	 * @param param 사용자정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int selectChangeEntChargerSn(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기업담당자정보 변경요청 파일정보 업데이트
	 * @param param 사용자정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateChangeEntCharger(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기업담당자 변경신청 조회 카운트
	 * @param param 검색조건
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int selectChangeChargerCnt(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 모든사용자정보 조회
	 * @param param 검색조건
	 * @return 사용자정보
	 * @throws RuntimeException, Exception
	 */
	public  List<Map> selectChangeCharger(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 사용자정보 조회
	 * @param param 검색조건
	 * @return 사용자정보
	 * @throws RuntimeException, Exception
	 */
	public Map selectChangeChargerInfo(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기업담당자정보 업데이트
	 * @param param 사용자정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateChargerInfo(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 패스워드 초기화 대상 기업사용자 조회
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public Map selectPwdInitEntUserInfo(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 담당자변경신청 기업사용자 아이디 조회
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public Map selectIdUserInfo(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기업명 업데이트
	 * @param param 사용자정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateEntrprsNmInfo(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기업담당자변경요청 적용여부 업데이트
	 * @param param 사용자정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateApplcAt(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 기업담당자정보 삭제
	 * @param param 사용자정보
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int deleteChargerInfo(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 유저의 상태정보 업데이트
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateUserStatus(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 유저의 비밃번호 업데이트
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateUserPassword(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 마이페이지 접수승인관련 승인대기인 상태 카운트
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int findConfirmWaitStatusCnt(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 알림정보조회
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public List<Map> findNotificationList(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 대체결재자 조회
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public Map findMyAltrtvConfrmer(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 내가 다른사람의 대체결재자 일떄
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public List<Map> findAltrtvConfrmerList(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 로그인 실패 횟수 업데이트
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateLoginFailCnt(Map<String, Object> param) throws RuntimeException, Exception;

	/**
	 * 로그인 실패 날짜 업데이트
	 * @param param
	 * @return
	 * @throws RuntimeException, Exception
	 */
	public int updateLoginFailDt(Map<String, Object> param) throws RuntimeException, Exception;
}
