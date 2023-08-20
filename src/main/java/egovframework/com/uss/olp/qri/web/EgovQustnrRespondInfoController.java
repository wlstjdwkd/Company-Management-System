package egovframework.com.uss.olp.qri.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.com.cmm.ComDefaultVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.uss.olp.qri.service.EgovQustnrRespondInfoService;
import egovframework.com.uss.olp.qri.service.QustnrRespondInfoVO;
import egovframework.rte.fdl.cmmn.exception.EgovBizException;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.bind.annotation.CommandMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.comm.page.Pager;
import com.comm.user.EntUserVO;
import com.comm.user.UserService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 설문조사 Controller Class 구현
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
 *   2011.8.26	정진오			IncludedInfo annotation 추가
 *
 * </pre>
 */


@Controller
public class EgovQustnrRespondInfoController {

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovQustnrRespondInfoController.class);

	@Resource(name="qustnrRespondInfoValidator")
	private QustnrRespondInfoValidator beanValidator;

	/** EgovMessageSource */
    @Resource(name="egovMessageSource")
    EgovMessageSource egovMessageSource;

	@Resource(name = "egovQustnrRespondInfoService")
	private EgovQustnrRespondInfoService egovQustnrRespondInfoService;

    /** EgovPropertyService */
    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

    @Autowired
    private UserService	userService;


	/**
	 * 설문템플릿을 적용한다.
	 * @param searchVO
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return "egovframework/com/uss/olp/template/template"
	 * @throws Exception
	 */
	@RequestMapping(value={"/PGSU0010.do", "/PGSO0050.do"}, params="df_method_nm=template")
	public String egovQustnrRespondInfoManageTemplate(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			HttpServletRequest request,
			@CommandMap Map commandMap,
    		ModelMap model)
    throws Exception {

		 String sTemplateUrl = (String)commandMap.get("templateUrl");

		 LOGGER.debug("qestnrId=> {}", commandMap.get("qestnrId"));
		 LOGGER.debug("qestnrTmplatId=> {}", commandMap.get("qestnrTmplatId"));
		 LOGGER.debug("templateUrl=> {}", commandMap.get("templateUrl"));

 		 //설문템플릿정보
		 model.addAttribute("QustnrTmplatManage",  (List)egovQustnrRespondInfoService.selectQustnrTmplatManage(commandMap));
    	 //설문정보
    	 model.addAttribute("Comtnqestnrinfo",  (List)egovQustnrRespondInfoService.selectQustnrRespondInfoManageComtnqestnrinfo(commandMap));
    	 //문항정보
    	 model.addAttribute("Comtnqustnrqesitm",  (List)egovQustnrRespondInfoService.selectQustnrRespondInfoManageComtnqustnrqesitm(commandMap));
    	 //항목정보
    	 model.addAttribute("Comtnqustnriem",  (List)egovQustnrRespondInfoService.selectQustnrRespondInfoManageComtnqustnriem(commandMap));
    	 //설문템플릿ID 설정
    	 model.addAttribute("qestnrTmplatId",  commandMap.get("qestnrTmplatId") == null ? "" : (String)commandMap.get("qestnrTmplatId") );
       	 //설문지정보ID 설정
    	 model.addAttribute("qestnrId",  commandMap.get("qestnrId") == null ? "" : (String)commandMap.get("qestnrId"));
         //객관식통계 답안
    	 model.addAttribute("qestnrStatistic1", (List)egovQustnrRespondInfoService.selectQustnrRespondInfoManageStatistics1(commandMap));
         //주관식통계 답안
    	 model.addAttribute("qestnrStatistic2", (List)egovQustnrRespondInfoService.selectQustnrRespondInfoManageStatistics2(commandMap));
    	 //이전 주소
    	 model.addAttribute("returnUrl", request.getHeader("REFERER"));

		return sTemplateUrl;
	}

	/**
	 * 설문조사 전체 통계를 조회한다.
	 * @param searchVO
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return "egovframework/com/uss/olp/qnn/EgovQustnrRespondInfoManageStatistics"
	 * @throws Exception
	 */
	@RequestMapping(value="/PGSO0050.do", params="df_method_nm=EgovQustnrRespondInfoManageStatistics")
	public String egovQustnrRespondInfoManageStatistics(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			HttpServletRequest request,
			@CommandMap Map commandMap,
    		ModelMap model)
    throws Exception {

		String sLocationUrl;
		
		if (commandMap.containsKey("popupAt") && commandMap.get("popupAt").equals("Y")) {
			sLocationUrl = "/egovframework/com/uss/olp/qnn/PD_EgovQustnrRespondInfoManageStatistics";
		} else {
			sLocationUrl = "/egovframework/com/uss/olp/qnn/BD_EgovQustnrRespondInfoManageStatistics";
		}

		//설문정보
		model.addAttribute("Comtnqestnrinfo",  (List)egovQustnrRespondInfoService.selectQustnrRespondInfoManageComtnqestnrinfo(commandMap));
		//문항정보
		model.addAttribute("Comtnqustnrqesitm",  (List)egovQustnrRespondInfoService.selectQustnrRespondInfoManageComtnqustnrqesitm(commandMap));
		//항목정보
		model.addAttribute("Comtnqustnriem",  (List)egovQustnrRespondInfoService.selectQustnrRespondInfoManageComtnqustnriem(commandMap));
		//설문템플릿ID 설정
		model.addAttribute("qestnrTmplatId",  commandMap.get("qestnrTmplatId") == null ? "" : (String)commandMap.get("qestnrTmplatId") );
		//설문지정보ID 설정
		model.addAttribute("qestnrId",  commandMap.get("qestnrId") == null ? "" : (String)commandMap.get("qestnrId"));
		//객관식통계 답안
		model.addAttribute("qestnrStatistic1", (List)egovQustnrRespondInfoService.selectQustnrRespondInfoManageStatistics1(commandMap));
		//주관식통계 답안
		model.addAttribute("qestnrStatistic2", (List)egovQustnrRespondInfoService.selectQustnrRespondInfoManageStatistics2(commandMap));
		//이전 주소
		model.addAttribute("returnUrl", request.getHeader("REFERER"));

		return sLocationUrl;
	}

	/**
	 * 설문조사(설문등록) 목록을 조회한다.
	 * @param searchVO
	 * @param request
	 * @param response
	 * @param commandMap
	 * @param model
	 * @return "egovframework/com/uss/olp/qnn/EgovQustnrRespondInfoManageList"
	 * @throws Exception
	 */
	@RequestMapping(value="/PGSO0050.do")
	public String egovQustnrRespondInfoManageList(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			HttpServletRequest request,
			HttpServletResponse response,
			@CommandMap Map commandMap,
    		ModelMap model)
    throws Exception {

        int totCnt = (Integer)egovQustnrRespondInfoService.selectQustnrRespondInfoManageListCnt(searchVO);
        
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(searchVO.getPageIndex()).totalRowCount(totCnt).rowSize(searchVO.getPageSize()).build();
		pager.makePaging();
		
		searchVO.setRecordCountPerPage(pager.getLimitTo());
		searchVO.setFirstIndex(pager.getLimitFrom());
		
        List resultList = egovQustnrRespondInfoService.selectQustnrRespondInfoManageList(searchVO);
        model.addAttribute("resultList", resultList);

        model.addAttribute("searchKeyword", commandMap.get("searchKeyword") == null ? "" : (String)commandMap.get("searchKeyword"));
        model.addAttribute("searchCondition", commandMap.get("searchCondition") == null ? "" : (String)commandMap.get("searchCondition"));
	
		model.addAttribute("pager", pager);

		return "/egovframework/com/uss/olp/qnn/BD_EgovQustnrRespondInfoManageList";
	}

	/**
	 * 설문조사(설문등록)를 등록한다.
	 * @param searchVO
	 * @param commandMap
	 * @param model
	 * @return "egovframework/com/uss/olp/qnn/EgovQustnrRespondInfoManageRegist"
	 * @throws Exception
	 */
	@RequestMapping(value={"/PGSU0010.do", "/PGSO0050.do"}, params="df_method_nm=insertRespond")
	public String egovQustnrRespondInfoManageRegist(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			@CommandMap Map commandMap,
    		ModelMap model)
    throws Exception {

		String sLocationUrl = "/egovframework/com/uss/olp/qnn/BD_EgovQustnrRespondInfoManageRegist";

		String sCmd = commandMap.get("cmd") == null ? "" : (String)commandMap.get("cmd");
    	String trgterEmail = commandMap.get("trgterEmail") == null ? "" : (String)commandMap.get("trgterEmail");
    	
    	// 중복응답체크
    	HashMap<String, Object> param = new HashMap();
    	param.put("EMAIL", trgterEmail);
    	param.put("qestnrId", (String)commandMap.get("qestnrId"));
    	param.put("qestnrTmplatId", (String)commandMap.get("qestnrTmplatId"));
    	
    	// 이미 응답한 대상자이면 오류처리
    	if (!egovQustnrRespondInfoService.checkDuplQustnrRespond(param)) {
    		throw new EgovBizException(egovMessageSource.getMessage("errors.qustnr.duplicate.respond"));
    	}
    	
		LOGGER.info("cmd => {}", sCmd);

        if(sCmd.equals("save") && !StringUtils.isEmpty(trgterEmail)){

        	// 응답자 정보 조회
        	EntUserVO userVo = userService.findEntUserByEmail(param);
        	
        	if (userVo == null) {
        		//throw new EgovBizException(egovMessageSource.getMessage("errors.qustnr.invalid.respond"));
        		userVo = new EntUserVO();
        		userVo.setEmail(trgterEmail);
        	}
        	
    		//설문조사 처리 START
    		String sKey ="";
    		String sVal ="";
    		
           	for(Object key:commandMap.keySet()){

           		sKey = key.toString();

           		//설문문항정보 추출
           		if(sKey.length() > 6 && sKey.substring(0, 6).equals("QQESTN")){

           			//설문조사 등록
	           		//객관식 답안 처리
	           		if( ((String)commandMap.get("TY_"+key)).equals("1") ){

           				if( commandMap.get(key) instanceof String){
	           				sVal = (String)commandMap.get(key);

		           			QustnrRespondInfoVO qustnrRespondInfoVO = new QustnrRespondInfoVO();

		           			qustnrRespondInfoVO.setQestnrTmplatId((String)commandMap.get("qestnrTmplatId"));
		           			qustnrRespondInfoVO.setQestnrId((String)commandMap.get("qestnrId"));
		           			qustnrRespondInfoVO.setQestnrQesitmId(sKey);
		           			qustnrRespondInfoVO.setQustnrIemId(sVal);

		           			qustnrRespondInfoVO.setRespondAnswerCn("");

		           			//qustnrRespondInfoVO.setRespondNm((String)commandMap.get("respondNm"));
		           			qustnrRespondInfoVO.setEtcAnswerCn((String)commandMap.get("ETC_" + sVal));

		            		qustnrRespondInfoVO.setRegister(userVo.getUserNo());
		            		qustnrRespondInfoVO.setUpdusr(userVo.getUserNo());
		            		
		            		// 응답자 이메일, 응답자명 추가
		            		qustnrRespondInfoVO.setRespondNm(userVo.getEntrprsNm());
		            		qustnrRespondInfoVO.setTrgterEmail(userVo.getEmail());
		            		
		           			egovQustnrRespondInfoService.insertQustnrRespondInfo(qustnrRespondInfoVO);
		           			
           				}else{
	        				String[] arrVal = (String[]) commandMap.get(key);
	        				for(int g=0; g < arrVal.length; g++ ){
	        					//("QQESTN arr :" + arrVal[g]);
			           			QustnrRespondInfoVO qustnrRespondInfoVO = new QustnrRespondInfoVO();

			           			qustnrRespondInfoVO.setQestnrTmplatId((String)commandMap.get("qestnrTmplatId"));
			           			qustnrRespondInfoVO.setQestnrId((String)commandMap.get("qestnrId"));
			           			qustnrRespondInfoVO.setQestnrQesitmId(sKey);
			           			qustnrRespondInfoVO.setQustnrIemId(arrVal[g]);

			           			qustnrRespondInfoVO.setRespondAnswerCn("");

			           			//qustnrRespondInfoVO.setRespondNm((String)commandMap.get("respondNm"));
			           			qustnrRespondInfoVO.setEtcAnswerCn((String)commandMap.get("ETC_" + arrVal[g]));

			            		qustnrRespondInfoVO.setRegister(userVo.getUserNo());
			            		qustnrRespondInfoVO.setUpdusr(userVo.getUserNo());
			            		
			            		// 응답자 이메일, 응답자명 추가
			            		qustnrRespondInfoVO.setRespondNm(userVo.getEntrprsNm());
			            		qustnrRespondInfoVO.setTrgterEmail(userVo.getEmail());

			           			egovQustnrRespondInfoService.insertQustnrRespondInfo(qustnrRespondInfoVO);
	        				}
           				}


	           		//주관식 답안 처리
	           		}else if( ((String)commandMap.get("TY_"+key)).equals("2") ){
	           			QustnrRespondInfoVO qustnrRespondInfoVO = new QustnrRespondInfoVO();

	           			qustnrRespondInfoVO.setQestnrTmplatId((String)commandMap.get("qestnrTmplatId"));
	           			qustnrRespondInfoVO.setQestnrId((String)commandMap.get("qestnrId"));
	           			qustnrRespondInfoVO.setQestnrQesitmId(sKey);
	           			qustnrRespondInfoVO.setQustnrIemId(null);

	           			qustnrRespondInfoVO.setRespondAnswerCn((String)commandMap.get(sKey));

	           			//qustnrRespondInfoVO.setRespondNm((String)commandMap.get("respondNm"));
	           			qustnrRespondInfoVO.setEtcAnswerCn(null);

	            		qustnrRespondInfoVO.setRegister(userVo.getUserNo());
	            		qustnrRespondInfoVO.setUpdusr(userVo.getUserNo());

	            		// 응답자 이메일, 응답자명 추가
	            		qustnrRespondInfoVO.setRespondNm(userVo.getEntrprsNm());
	            		qustnrRespondInfoVO.setTrgterEmail(userVo.getEmail());
	            		
	           			egovQustnrRespondInfoService.insertQustnrRespondInfo(qustnrRespondInfoVO);
	           		}
           		}
        	}

   			model.addAttribute("resultMsg", "설문에 참여해 주셔서 감사합니다.");
        }

		 //설문템플릿정보
		 model.addAttribute("QustnrTmplatManage",  (List)egovQustnrRespondInfoService.selectQustnrTmplatManage(commandMap));
		 //설문정보
		 model.addAttribute("Comtnqestnrinfo",  (List)egovQustnrRespondInfoService.selectQustnrRespondInfoManageComtnqestnrinfo(commandMap));
		 //문항정보
		 model.addAttribute("Comtnqustnrqesitm",  (List)egovQustnrRespondInfoService.selectQustnrRespondInfoManageComtnqustnrqesitm(commandMap));
		 //항목정보
		 model.addAttribute("Comtnqustnriem",  (List)egovQustnrRespondInfoService.selectQustnrRespondInfoManageComtnqustnriem(commandMap));
		 //설문템플릿ID 설정
		 model.addAttribute("qestnrTmplatId",  commandMap.get("qestnrTmplatId") == null ? "" : (String)commandMap.get("qestnrTmplatId") );
		 //설문지정보ID 설정
		 model.addAttribute("qestnrId",  commandMap.get("qestnrId") == null ? "" : (String)commandMap.get("qestnrId"));
		 
		 return sLocationUrl;
	}
}
