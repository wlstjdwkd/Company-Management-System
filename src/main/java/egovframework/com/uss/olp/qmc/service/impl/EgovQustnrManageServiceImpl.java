package egovframework.com.uss.olp.qmc.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.com.cmm.ComDefaultVO;
import egovframework.com.uss.olp.qmc.service.EgovQustnrManageService;
import egovframework.com.uss.olp.qmc.service.QustnrManageVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
/**
 * 설문관리를 처리하는 ServiceImpl Class 구현
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
@Service("egovQustnrManageService")
public class EgovQustnrManageServiceImpl extends EgovAbstractServiceImpl implements EgovQustnrManageService{

	@Resource(name="qustnrManageDao")
	private QustnrManageDao dao;
	
	@Resource(name="egovQustnrManageIdGnrService")
	private EgovIdGnrService idgenService;
	
    
    /**
	 * 설문템플릿 목록을 조회한다. 
	 * @param qustnrManageVO - 설문관리 정보 담김 VO
	 * @return List
	 * @throws Exception
	 */	
	public List selectQustnrTmplatManageList(QustnrManageVO qustnrManageVO) throws Exception{
		return (List)dao.selectQustnrTmplatManageList(qustnrManageVO);
	}
	
	
    /**
	 * 설문관리 목록을 조회한다. 
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return List
	 * @throws Exception
	 */
	public List selectQustnrManageList(ComDefaultVO searchVO) throws Exception{
		return (List)dao.selectQustnrManageList(searchVO);
	}
	
    /**
	 * 설문관리를 상세조회(Model) 한다. 
	 * @param qustnrManageVO - 설문관리 정보 담김 VO
	 * @return List
	 * @throws Exception
	 */
    public QustnrManageVO selectQustnrManageDetailModel(QustnrManageVO qustnrManageVO) throws Exception {    	
        return (QustnrManageVO) dao.selectQustnrManageDetailModel(qustnrManageVO);
    }
    
    /**
	 * 설문관리를(을) 상세조회 한다.
	 * @param QustnrManage - 회정정보가 담김 VO
	 * @return List
	 * @throws Exception
	 */
	public List selectQustnrManageDetail(QustnrManageVO qustnrManageVO) throws Exception{
		return (List)dao.selectQustnrManageDetail(qustnrManageVO);
	}
	
    /**
	 * 설문관리를(을) 목록 전체 건수를(을) 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return int
	 * @throws Exception
	 */
	public int selectQustnrManageListCnt(ComDefaultVO searchVO) throws Exception{
		return (Integer)dao.selectQustnrManageListCnt(searchVO);
	}
	
	/**
	 * 설문결과 데이터 헤더컬럼 조회
	 * @param qustnrManageVO
	 * @return
	 * @throws Exception
	 */
	public List selectQustnrResponseListTitle(QustnrManageVO qustnrManageVO) throws Exception{
		return (List) dao.selectQustnrResponseListTitle(qustnrManageVO);
	}
	
	/**
	 * 설문결과 데이터 조회
	 * @param qustnrManageVO
	 * @return
	 * @throws Exception
	 */
	public List selectQustnrResponseListData(QustnrManageVO qustnrManageVO) throws Exception{
		return (List) dao.selectQustnrResponseListData(qustnrManageVO);
	}
	
    /**
	 * 설문관리를(을) 등록한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @throws Exception
	 */
	public void insertQustnrManage(QustnrManageVO qustnrManageVO) throws Exception {
		String sMakeId = idgenService.getNextStringId();
		
		qustnrManageVO.setQestnrId(sMakeId);

		dao.insertQustnrManage(qustnrManageVO);
	}
	
    /**
	 * 설문관리를(을) 수정한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @throws Exception
	 */
	public void updateQustnrManage(QustnrManageVO qustnrManageVO) throws Exception{
		dao.updateQustnrManage(qustnrManageVO);
	}
	
    /**
	 * 설문관리를(을) 삭제한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @throws Exception
	 */
	public void deleteQustnrManage(QustnrManageVO qustnrManageVO) throws Exception{
		dao.deleteQustnrManage(qustnrManageVO);
	}
	
	/**
	 * 메일발송자 목록갯수 조회
	 * @param param 	설문ID, 템플릿ID
	 * @return
	 * @throws Exception
	 */
	public int selectQustnrTrgterEmailListCnt(Map param) throws Exception {
		return dao.selectQustnrTrgterEmailListCnt(param);
	}
	
	/**
	 * 메일발송자 목록조회
	 * @param param  설문ID, 템플릿 ID
	 * @return
	 * @throws Exception
	 */
	public List selectQustnrTrgterEmailList(Map param) throws Exception {
		return dao.selectQustnrTrgterEmailList(param);
	}

	/**
	 * 메일 제목 및 설문안내 조회
	 * @param param	설문ID, 템플릿ID
	 * @return 	메일 제목 및 설문안내 
	 * @throws Exception
	 */
	public Map selectQustnrTrgterInfoGreeting(Map param) throws Exception {
		return dao.selectQustnrTrgterInfoGreeting(param);
	}

    /**
     * 메일 제목 및 설문안내 수정, 설문참여자 정보 등록
     * @param param 설문ID, 템플릿ID, 이메일주소, 메일제목, 설문안내
     * @throws Exception
     */
	public void insertQustnrTrgterEmail(Map param) throws Exception {
		dao.updateQustnrTrgterInfoGreeting(param);
		
		// 이메일 등록
		List<Map> emailList = (List) param.get("emailList");
		if (emailList == null || emailList.size() <= 0) return;
		
		for(Map map : emailList) {
			dao.insertQustnrTrgterEmail(map);
		}
	}

    /**
     * 설문참여자 정보 삭제
     * @param param 설문ID, 템플릿ID, 이메일주소
     * @throws Exception
     */
	public void deleteQustnrTrgterEmail(Map param) throws Exception {
		dao.deleteQustnrTrgterEmail(param);
	}


	/**
	 * 확인서발급기업 담당자 불러오기
     * @param param 설문ID, 템플릿ID, 이메일주소
     * @throws Exception
	 */
	public List selectCnfirmEnpEmailList(Map param) throws Exception {
		return dao.selectCnfirmEnpEmailList(param);
	}


    /**
     * 이메일 수신거부한 기업회원의 이메일목록 조회
     * @param param
     * @return
     * @throws Exception
     */
	public List selectRejectEmailList(Map param) throws Exception {
		return dao.selectRejectEmailList(param);
	}
	
    /**
     * 이미 등록된 이메일 조회
     * @param param
     * @return
     * @throws Exception
     */
    public List selectDuplEmailList(Map param) throws Exception {
    	return dao.selectDuplEmailList(param);
    }

    /**
     * 메일발송정보 조회
     */
    public Map selectQustnrEmailInfo(Map param) throws Exception {
    	return dao.selectQustnrEmailInfo(param);
    }
    
    /**
     * 이메일 발송요청
     * @param param 이메일 발송정보
     * @throws Exception
     */
	public void insertRequestSendEmail(Map param) throws Exception {
		// 이메일 등록
		List<Map> emailList = (List) param.get("emailList");
		if (emailList == null || emailList.size() <= 0) return;
		
		for(Map map : emailList) {
			dao.insertRequestSendEmail(map);
		}
	}

	/**
	 * 전체 메일 목록 조회 
	 */
	public List selectAllTargetEmailList(Map param) throws Exception {
		return dao.selectAllTargetEmailList(param);
	}
}
