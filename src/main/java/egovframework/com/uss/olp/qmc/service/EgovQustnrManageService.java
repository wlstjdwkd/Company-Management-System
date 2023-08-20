package egovframework.com.uss.olp.qmc.service;

import java.util.List;
import java.util.Map;

import egovframework.com.cmm.ComDefaultVO;
/**
 * 설문관리를 처리하는 Service Class 구현
 * @author 공통서비스 장동한
 * @since 2009.03.20
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.03.20  장동한          최초 생성
 *
 * </pre>
 */ 
public interface EgovQustnrManageService {

    /**
	 * 설문템플릿 목록을 조회한다. 
	 * @param qustnrManageVO - 설문관리 정보 담김 VO
	 * @return List
	 * @throws Exception
	 */	
	public List selectQustnrTmplatManageList(QustnrManageVO qustnrManageVO) throws Exception;
	
    /**
	 * 설문관리 목록을 조회한다. 
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return List
	 * @throws Exception
	 */
	public List selectQustnrManageList(ComDefaultVO searchVO) throws Exception;
	
    /**
	 * 설문관리를(을) 상세조회 한다.
	 * @param qustnrManageVO - 설문관리 정보 담김 VO
	 * @return List
	 * @throws Exception
	 */
	public List selectQustnrManageDetail(QustnrManageVO qustnrManageVO) throws Exception;
	
    /**
	 * 설문관리를 상세조회(Model) 한다. 
	 * @param qustnrManageVO - 설문관리 정보 담김 VO
	 * @return List
	 * @throws Exception
	 */
    public QustnrManageVO selectQustnrManageDetailModel(QustnrManageVO qustnrManageVO) throws Exception ;
    
    /**
	 * 설문관리를(을) 목록 전체 건수를(을) 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return int
	 * @throws Exception
	 */
	public int selectQustnrManageListCnt(ComDefaultVO searchVO) throws Exception;

	/**
	 * 설문결과 데이터 헤더컬럼 조회
	 * @param qustnrManageVO
	 * @return
	 * @throws Exception
	 */
	public List selectQustnrResponseListTitle(QustnrManageVO qustnrManageVO) throws Exception;
	
	/**
	 * 설문결과 데이터 조회
	 * @param qustnrManageVO
	 * @return
	 * @throws Exception
	 */
	public List selectQustnrResponseListData(QustnrManageVO qustnrManageVO) throws Exception;
	
    /**
	 * 설문관리를(을) 등록한다.
	 * @param qustnrManageVO - 설문관리 정보 담김 VO
	 * @throws Exception
	 */
	void  insertQustnrManage(QustnrManageVO qustnrManageVO) throws Exception;
	
    /**
	 * 설문관리를(을) 수정한다.
	 * @param qustnrManageVO - 설문관리 정보 담김 VO
	 * @throws Exception
	 */
	void  updateQustnrManage(QustnrManageVO qustnrManageVO) throws Exception;
	
    /**
	 * 설문관리를(을) 삭제한다.
	 * @param qustnrManageVO - 설문관리 정보 담김 VO
	 * @throws Exception
	 */
	void  deleteQustnrManage(QustnrManageVO qustnrManageVO) throws Exception;
	
	/**
	 * 메일발송자 목록갯수 조회
	 * @param param 	설문ID, 템플릿ID
	 * @return
	 * @throws Exception
	 */
	public int selectQustnrTrgterEmailListCnt(Map param) throws Exception;
	
	/**
	 * 메일발송자 목록조회
	 * @param param  설문ID, 템플릿 ID
	 * @return
	 * @throws Exception
	 */
	public List selectQustnrTrgterEmailList(Map param) throws Exception;
	
	/**
	 * 메일 제목 및 설문안내 조회
	 * @param param	설문ID, 템플릿ID
	 * @return 	메일 제목 및 설문안내 
	 * @throws Exception
	 */
    public Map selectQustnrTrgterInfoGreeting(Map param) throws Exception;
    
    /**
     * 메일 제목 및 설문안내 수정, 설문참여자 정보 등록
     * @param param 설문ID, 템플릿ID, 이메일주소, 메일제목, 설문안내
     * @throws Exception
     */
    public void insertQustnrTrgterEmail(Map param) throws Exception;
    
    /**
     * 설문참여자 정보 삭제
     * @param param 설문ID, 템플릿ID, 이메일주소
     * @throws Exception
     */
    public void deleteQustnrTrgterEmail(Map param) throws Exception;

    /**
     * 확인서발급기업 담당자 이메일목록 조회
     * @param param
     * @return
     * @throws Exception
     */
    public List selectCnfirmEnpEmailList(Map param) throws Exception;
    
    /**
     * 이메일 수신거부한 기업회원의 이메일목록 조회
     * @param param
     * @return
     * @throws Exception
     */
    public List selectRejectEmailList(Map param) throws Exception;
    
    /**
     * 이미 등록된 이메일 조회
     * @param param
     * @return
     * @throws Exception
     */
    public List selectDuplEmailList(Map param) throws Exception;    
    
    /**
     * 전체 메일 목록 조회
     * @param param
     * @return
     * @throws Exception
     */
    public List selectAllTargetEmailList(Map param) throws Exception;
    
    /**
     * 메일발송정보 조회
     * @param param
     * @return
     * @throws Exception
     */
    public Map selectQustnrEmailInfo(Map param) throws Exception;
    
    /**
     * 이메일 발송요청
     * @param param 이메일 발송정보
     * @throws Exception
     */
    public void insertRequestSendEmail(Map param) throws Exception;
}
