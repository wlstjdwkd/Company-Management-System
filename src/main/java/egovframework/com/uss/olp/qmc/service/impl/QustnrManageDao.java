package egovframework.com.uss.olp.qmc.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.com.cmm.ComDefaultVO;
import egovframework.com.uss.olp.qmc.service.QustnrManageVO;
import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

import org.springframework.stereotype.Repository;
/**
 * 설문관리를 처리하는 Dao Class 구현
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
@Repository("qustnrManageDao")
public class QustnrManageDao extends EgovAbstractMapper {
	
    /**
	 * 설문템플릿 목록을 조회한다. 
	 * @param qustnrManageVO - 설문관리 정보 담김 VO
	 * @return List
	 * @throws Exception
	 */
	public List selectQustnrTmplatManageList(QustnrManageVO qustnrManageVO) throws Exception{
		return (List)selectList("QustnrManage.selectQustnrTmplatManage", qustnrManageVO);
	}
	
    /**
	 * 설문관리 목록을 조회한다. 
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return List
	 * @throws Exception
	 */
	public List selectQustnrManageList(ComDefaultVO searchVO) throws Exception{
		return (List)selectList("QustnrManage.selectQustnrManage", searchVO);
	}
	
    /**
	 * 설문관리를 상세조회(Model) 한다. 
	 * @param qustnrManageVO - 설문관리 정보 담김 VO
	 * @return List
	 * @throws Exception
	 */
    public QustnrManageVO selectQustnrManageDetailModel(QustnrManageVO qustnrManageVO) throws Exception {    	
        return (QustnrManageVO) selectOne("QustnrManage.selectQustnrManageDetailModel", qustnrManageVO);
    }
    
    /**
	 * 설문관리를(을) 상세조회 한다.
	 * @param qustnrManageVO - 설문관리 정보 담김 VO
	 * @return List
	 * @throws Exception
	 */
	public List selectQustnrManageDetail(QustnrManageVO qustnrManageVO) throws Exception{
		return (List)selectList("QustnrManage.selectQustnrManageDetail", qustnrManageVO);
	}

    /**
	 * 설문관리를(을) 목록 전체 건수를(을) 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return int
	 * @throws Exception
	 */
	public int selectQustnrManageListCnt(ComDefaultVO searchVO) throws Exception{
		return (Integer)selectOne("QustnrManage.selectQustnrManageCnt", searchVO);
	}
	
	/**
	 * 설문결과 데이터 헤더컬럼 조회
	 * @param qustnrManageVO
	 * @return
	 * @throws Exception
	 */
	public List selectQustnrResponseListTitle(QustnrManageVO qustnrManageVO) throws Exception {
		return (List) selectList("QustnrManage.selectQustnrResponseListTitle", qustnrManageVO);
	}
	
	/**
	 * 설문결과 데이터 조회
	 * @param qustnrManageVO
	 * @return
	 * @throws Exception
	 */
	public List selectQustnrResponseListData(QustnrManageVO qustnrManageVO) throws Exception {
		return (List) selectList("QustnrManage.selectQustnrResponseListData", qustnrManageVO);
	}
	
    /**
	 * 설문관리를(을) 등록한다.
	 * @param qqustnrManageVO - 설문관리 정보 담김 VO
	 * @throws Exception
	 */
	public void insertQustnrManage(QustnrManageVO qustnrManageVO) throws Exception{
		insert("QustnrManage.insertQustnrManage", qustnrManageVO);
	}

    /**
	 * 설문관리를(을) 수정한다.
	 * @param qustnrManageVO - 설문관리 정보 담김 VO
	 * @throws Exception
	 */
	public void updateQustnrManage(QustnrManageVO qustnrManageVO) throws Exception{
		insert("QustnrManage.updateQustnrManage", qustnrManageVO);
	}
	
    /**
	 * 설문관리를(을) 삭제한다.
	 * @param qustnrManageVO - 설문관리 정보 담김 VO
	 * @throws Exception
	 */
	public void deleteQustnrManage(QustnrManageVO qustnrManageVO) throws Exception{
		//설문참여대상자 삭제
		delete("QustnrManage.deleteQustnrTrgter", qustnrManageVO);
		//설문조사(설문결과) 삭제
		delete("QustnrManage.deleteQustnrRespondInfo", qustnrManageVO);
		//설문항목 삭제
		delete("QustnrManage.deleteQustnrItemManage", qustnrManageVO);
		//설문문항 삭제
		delete("QustnrManage.deleteQustnrQestnManage", qustnrManageVO);
		
		//설문관리 삭제
		delete("QustnrManage.deleteQustnrManage", qustnrManageVO);
	}
	
	/**
	 * 메일발송자 목록조회
	 * @param param	설문ID, 템플릿ID
	 * @return
	 * @throws Exception
	 */
	public List selectQustnrTrgterEmailList(Map param) throws Exception {
		return (List) selectList("QustnrManage.selectQustnrTrgterEmailList", param);
	}
	
	/**
	 * 메일발송자 목록갯수 조회
	 * @param param	설문ID, 템플릿ID
	 * @return
	 * @throws Exception
	 */
	public int selectQustnrTrgterEmailListCnt(Map param) throws Exception {
		return (Integer)selectOne("QustnrManage.selectQustnrTrgterEmailListCnt", param);
	}
	
    /**
	 * 메일 제목 및 설문안내 조회
	 * @param param	설문ID, 템플릿ID
	 * @return 	메일 제목 및 설문안내 
	 * @throws Exception
	 */
    public Map selectQustnrTrgterInfoGreeting(Map param) throws Exception {    	
        return (Map) selectOne("QustnrManage.selectQustnrTrgterInfoGreeting", param);
    }
    
    /**
     * 메일 제목 및 설문안내 수정
     * @param param	설문ID, 템플릿ID, 메일제목, 설문안내
     * @throws Exception
     */
    public void updateQustnrTrgterInfoGreeting(Map param) throws Exception {
    	update("QustnrManage.updateQustnrTrgterInfoGreeting", param);
    }
    
    /**
     * 설문참여자 정보 등록
     * @param param 설문ID, 템플릿ID, 이메일주소, 대상자분류
     * @throws Exception
     */
    public void insertQustnrTrgterEmail(Map param) throws Exception {
    	insert("QustnrManage.insertQustnrTrgterEmail", param);
    }
    
    /**
     * 설문참여자 정보 삭제
     * @param param 설문ID, 템플릿ID, 이메일주소
     * @throws Exception
     */
    public void deleteQustnrTrgterEmail(Map param) throws Exception {
    	delete("QustnrManage.deleteQustnrTrgterEmail", param);
    }
    
    /**
     * 확인서발급기업 담당자 이메일목록 조회
     * @param param
     * @return
     * @throws Exception
     */
    public List selectCnfirmEnpEmailList(Map param) throws Exception {
    	return (List) selectList("QustnrManage.selectCnfirmEnpEmailList", param);
    }
    
    /**
     * 이메일 수신거부한 기업회원의 이메일목록 조회
     * @param param
     * @return
     * @throws Exception
     */
    public List selectRejectEmailList(Map param) throws Exception {
    	return (List) selectList("QustnrManage.selectRejectEmailList", param);
    }
    
    /**
     * 이미 등록된 이메일 조회
     * @param param
     * @return
     * @throws Exception
     */
    public List selectDuplEmailList(Map param) throws Exception {
    	return (List) selectList("QustnrManage.selectDuplEmailList", param);
    }
    
    /**
     * 전체 메일 목록 조회
     * @param param
     * @return
     * @throws Exception
     */
    public List selectAllTargetEmailList(Map param) throws Exception {
    	return (List) selectList("QustnrManage.selectAllTargetEmailList", param);
    }
    
    /**
     * 메일발송정보 조회
     * @param param
     * @return
     * @throws Exception
     */
    public Map selectQustnrEmailInfo(Map param) throws Exception {
    	return (Map) selectOne("QustnrManage.selectQustnrEmailInfo", param);
    }    
    
    /**
     * 이메일 발송요청
     * @param param 이메일발송정보
     * @throws Exception
     */
    public void insertRequestSendEmail(Map param) throws Exception {
    	insert("QustnrManage.insertRequestSendEmail", param);
    }
}
