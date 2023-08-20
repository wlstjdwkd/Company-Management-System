package biz.tech.am;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.menu.MenuService;
import com.comm.user.UserService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.am.PGAM0001Mapper;
import biz.tech.mapif.sp.PGSP0030Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 관리자 메인
 * @author JGS
 *
 */
@Service("PGAM0001")
public class PGAM0001Service extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGAM0001Service.class);
	
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;
	
	@Autowired
	UserService userService;
	
	@Autowired
	MenuService menuService;
	
	@Resource(name = "PGAM0001Mapper")
	PGAM0001Mapper PGAM0001DAO;
	
	@Resource(name = "PGSP0030Mapper")
	private PGSP0030Mapper pgsp0030Mapper;
	
	/**
	 * INDEX 화면 출력
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?,?> rqstMap) throws Exception {
		
		HashMap param = new HashMap();
		ModelAndView mv = new ModelAndView("/admin/am/BD_UIAMA0001");
		
		
		/* */
		//정보변경신청
		// N = 접수 
		param.put("applcAt", "N");
		mv.addObject("cntNewChanger", PGAM0001DAO.entprsChanger(param));
		// Y = 완료
		param.put("applcAt", "Y");
		mv.addObject("cntChanger", PGAM0001DAO.entprsChanger(param));
		/* */
		
		
		// 확인서신청 처리현황
		// PS1 = 접수 ~ 발급, 내용변경신청 조회
		param.put("sttusCode", "PS1");
		/*mv.addObject("cntConfirmReceive", PGAM0001DAO.findConfirmSttus(param));*/
		param.put("reqstSe", "AK1");
		mv.addObject("cntConfirmReceive1", PGAM0001DAO.findConfirmSttus(param));
		param.put("reqstSe", "AK2");
		mv.addObject("cntConfirmReceive2", PGAM0001DAO.findConfirmSttus(param));
		// PS4 = 보완접수
		param.put("sttusCode", "PS4");
		mv.addObject("cntConfirmSupplement", PGAM0001DAO.findConfirmSttus(param));
		// PS2 = 검토중
		param.put("reqstSe", "");
		param.put("sttusCode", "PS2");
		mv.addObject("cntConfirmReview1", PGAM0001DAO.findConfirmSttus(param));
		// PS5 = 보완검토중
		param.put("sttusCode", "PS5");
		mv.addObject("cntConfirmReview2", PGAM0001DAO.findConfirmSttus(param));
		
		// 기업시책(RSS) 처리현황
		// new = 신규
		param.put("sttus", "new");
		mv.addObject("cntNewRss", PGAM0001DAO.findRssSttus(param));
		// finish = 처리완료
		param.put("sttus", "finish");
		mv.addObject("cntFinishRss", PGAM0001DAO.findRssSttus(param));
		// 사업공고건수
		param.put("ntceAt", "Y");
		mv.addObject("cntSuportList", pgsp0030Mapper.findSuportListCnt(param));
		
		// 묻고답하기 처리현황
		// A = 신청
		param.put("qaSttusCode", "A");
		mv.addObject("cntQaReceive", PGAM0001DAO.findQaSttus(param));
		// C = 답변중
		param.put("qaSttusCode", "C");
		mv.addObject("cntQaOngoing", PGAM0001DAO.findQaSttus(param));
		// D = 답변완료
		param.put("qaSttusCode", "D");
		mv.addObject("cntQaFinish", PGAM0001DAO.findQaSttus(param));
		
		// 자료요청 처리현황
		// A = 신청
		param.put("requestSttusCode", "A");
		mv.addObject("cntRequestReceive", PGAM0001DAO.findRequestSttus(param));
		// C = 답변중
		param.put("requestSttusCode", "C");
		mv.addObject("cntRequestOngoing", PGAM0001DAO.findRequestSttus(param));
		// D = 답변완료
		param.put("requestSttusCode", "D");
		mv.addObject("cntRequestFinish", PGAM0001DAO.findRequestSttus(param));
		
		param.put("innerDay", 7);
		// 위변조 신고내역(일주일이내)
		mv.addObject("cntDocReportLately", PGAM0001DAO.findDocReportCnt(param));
		// 회원가입현황(일주일이내)
		// GN = 일반회원
		param.put("emplyrTy", "GN");
		mv.addObject("cntGnWeekUser", PGAM0001DAO.findUserInfoCnt(param));
		// EP = 기업회원
		param.put("emplyrTy", "EP");
		mv.addObject("cntEpWeekUser", PGAM0001DAO.findUserInfoCnt(param));

		param.put("innerDay", 30);
		// 회원가입현황(한달이내)
		param.put("emplyrTy", "GN");
		mv.addObject("cntGnMonUser", PGAM0001DAO.findUserInfoCnt(param));
		param.put("emplyrTy", "EP");
		mv.addObject("cntEpMonUser", PGAM0001DAO.findUserInfoCnt(param));
		
		param.put("innerDay", 100000);
		// 위변조 신고내역(누적)
		mv.addObject("cntDocReport", PGAM0001DAO.findDocReportCnt(param));
		// 회원가입현황(누적)
		param.put("emplyrTy", "GN");
		mv.addObject("cntGnUser", PGAM0001DAO.findUserAccrueCnt(param));
		param.put("emplyrTy", "EP");
		mv.addObject("cntEpUser", PGAM0001DAO.findUserAccrueCnt(param));
		
		// 방문현황(누적)
		mv.addObject("cntVisit", PGAM0001DAO.findVisitCnt(param));
		// 방문현황(전일)
		param.put("visit", "yester");
		mv.addObject("cntYesterVisit", PGAM0001DAO.findVisitCnt(param));
		// 방문현황(금일)
		param.put("visit", "today");
		mv.addObject("cntTodayVisit", PGAM0001DAO.findVisitCnt(param));
		
		return mv;
	}
}
