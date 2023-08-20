package egovframework.com.uss.olp.qmc.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.StringTokenizer;

import javax.annotation.Resource;

import com.comm.code.CodeService;
import com.comm.page.Pager;
import com.comm.response.ExcelVO;
import com.comm.response.IExcelVO;
import com.comm.user.UserVO;
import com.infra.system.GlobalConst;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.StringUtil;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.cmm.ComDefaultVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.uss.olp.qmc.service.EgovQustnrManageService;
import egovframework.com.uss.olp.qmc.service.QustnrManageVO;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.bind.annotation.CommandMap;

/**
 * 설문관리를 처리하는 Controller Class 구현
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
@RequestMapping("/PGSO0020.do")
public class EgovQustnrManageController {

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovQustnrManageController.class);

	@Resource(name="qustnrManageValidator")
	QustnrManageValidator beanValidator;

	/** EgovMessageSource */
    @Resource(name="egovMessageSource")
    EgovMessageSource egovMessageSource;

	@Resource(name = "egovQustnrManageService")
	private EgovQustnrManageService egovQustnrManageService;

    /** EgovPropertyService */
    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

    @Autowired
	private CodeService codeService;

	/**
	 * 설문관리 팝업 목록을 조회한다.
	 * @param searchVO
	 * @param commandMap
	 * @param qustnrManageVO
	 * @param model
	 * @return "egovframework/com/uss/olp/qmc/EgovQustnrManageListPopup"
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=EgovQustnrManageListPopup")
	public String egovQustnrManageListPopup(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			@CommandMap Map commandMap,
			QustnrManageVO qustnrManageVO,
    		ModelMap model)
    throws Exception {

		String sCmd = commandMap.get("cmd") == null ? "" : (String)commandMap.get("cmd");
		
		if(sCmd.equals("del")){
			egovQustnrManageService.deleteQustnrManage(qustnrManageVO);
		}

		int totCnt = (Integer)egovQustnrManageService.selectQustnrManageListCnt(searchVO);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(searchVO.getPageIndex()).totalRowCount(totCnt).rowSize(searchVO.getPageSize()).build();
		pager.makePaging();
		
		searchVO.setRecordCountPerPage(pager.getLimitTo());
		searchVO.setFirstIndex(pager.getLimitFrom());
		
        List resultList = egovQustnrManageService.selectQustnrManageList(searchVO);
        model.addAttribute("resultList", resultList);

        model.addAttribute("searchKeyword", commandMap.get("searchKeyword") == null ? "" : (String)commandMap.get("searchKeyword"));
        model.addAttribute("searchCondition", commandMap.get("searchCondition") == null ? "" : (String)commandMap.get("searchCondition"));

		model.addAttribute("pager", pager);

		return "/egovframework/com/uss/olp/qmc/PD_EgovQustnrManageListPopup";
	}

	/**
	 * 설문관리 목록을 조회한다.
	 * @param searchVO
	 * @param commandMap
	 * @param qustnrManageVO
	 * @param model
	 * @return  "/uss/olp/qmc/EgovQustnrManageList"
	 * @throws Exception
	 */
	@RequestMapping("")
	public String egovQustnrManageList(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			@CommandMap Map commandMap,
			QustnrManageVO qustnrManageVO,
    		ModelMap model)
    throws Exception {
		
		int totCnt = (Integer)egovQustnrManageService.selectQustnrManageListCnt(searchVO);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(searchVO.getPageIndex()).totalRowCount(totCnt).rowSize(searchVO.getPageSize()).build();
		pager.makePaging();
		
		searchVO.setRecordCountPerPage(pager.getLimitTo());
		searchVO.setFirstIndex(pager.getLimitFrom());
		
        List resultList = egovQustnrManageService.selectQustnrManageList(searchVO);
        model.addAttribute("resultList", resultList);

        model.addAttribute("searchKeyword", commandMap.get("searchKeyword") == null ? "" : (String)commandMap.get("searchKeyword"));
        model.addAttribute("searchCondition", commandMap.get("searchCondition") == null ? "" : (String)commandMap.get("searchCondition"));

		model.addAttribute("pager", pager);

		return "/egovframework/com/uss/olp/qmc/BD_EgovQustnrManageList";
	}

	/**
	 * 설문관리 목록을 상세조회 조회한다.
	 * @param searchVO
	 * @param qustnrManageVO
	 * @param commandMap
	 * @param model
	 * @return "egovframework/com/uss/olp/qmc/EgovQustnrManageDetail";
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=EgovQustnrManageDetail")
	public String egovQustnrManageDetail(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			QustnrManageVO qustnrManageVO,
			@CommandMap Map commandMap,
    		ModelMap model)
    throws Exception {

		String sLocationUrl = "/egovframework/com/uss/olp/qmc/BD_EgovQustnrManageDetail";

        List resultList = egovQustnrManageService.selectQustnrManageDetail(qustnrManageVO);
        model.addAttribute("resultList", resultList);

		return sLocationUrl;
	}

	/**
	 * 설문관리를 삭제한다.
	 * @param searchVO
	 * @param qustnrManageVO
	 * @param commandMap
	 * @param model
	 * @return "/uss/olp/qmc/BD_EgovQustnrManageList";
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=deleteEgovQustnrManage")
	public String qustnrManageDetele(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			QustnrManageVO qustnrManageVO,
			@CommandMap Map commandMap,
    		ModelMap model)
    throws Exception {

		egovQustnrManageService.deleteQustnrManage(qustnrManageVO);
		model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.delete", new String[]{"설문정보"}, Locale.getDefault()));
		String sLocationUrl = egovQustnrManageList(searchVO, commandMap, qustnrManageVO, model);

		return sLocationUrl;
	}
	
	/**
	 * 설문관리를 수정한다.
	 * @param searchVO
	 * @param commandMap
	 * @param qustnrManageVO
	 * @param bindingResult
	 * @param model
	 * @return "egovframework/com/uss/olp/qmc/EgovQustnrManageModify"
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=updateEgovQustnrManage")
	public String qustnrManageModify(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			@CommandMap Map commandMap,
			QustnrManageVO qustnrManageVO,
			BindingResult bindingResult,
    		ModelMap model)
    throws Exception {

		//로그인 객체 선언
		UserVO userVo = SessionUtil.getUserInfo();
		
		String sLocationUrl = "/egovframework/com/uss/olp/qmc/BD_EgovQustnrManageModify";

		String sCmd = commandMap.get("cmd") == null ? "" : (String)commandMap.get("cmd");

     	//공통코드  직업유형 조회
    	List listComCode = codeService.findCodesByGroupNo("9");
    	model.addAttribute("code9", listComCode);

        if(sCmd.equals("save")){

            beanValidator.validate(qustnrManageVO, bindingResult);
    		if (bindingResult.hasErrors()){

                List sampleList = egovQustnrManageService.selectQustnrManageDetail(qustnrManageVO);
                model.addAttribute("resultList", sampleList);

            	//설문템플릿 정보 불러오기
                List listQustnrTmplat = egovQustnrManageService.selectQustnrTmplatManageList(qustnrManageVO);
                model.addAttribute("listQustnrTmplat", listQustnrTmplat);

    			return sLocationUrl;
    		}

    		//아이디 설정
    		qustnrManageVO.setRegister(userVo.getUserNo());
    		qustnrManageVO.setUpdusr(userVo.getUserNo());

        	egovQustnrManageService.updateQustnrManage(qustnrManageVO);
        	model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.update", new String[]{"설문정보"}, Locale.getDefault()));
        	sLocationUrl = egovQustnrManageList(searchVO, commandMap, qustnrManageVO, model);
        	//"redirect:/uss/olp/qmc/EgovQustnrManageList.do";
        }else{
            List resultList = egovQustnrManageService.selectQustnrManageDetail(qustnrManageVO);
            model.addAttribute("resultList", resultList);

            QustnrManageVO newQustnrManageVO =  egovQustnrManageService.selectQustnrManageDetailModel(qustnrManageVO);
            model.addAttribute("qustnrManageVO", newQustnrManageVO);

        	//설문템플릿 정보 불러오기
            List listQustnrTmplat = egovQustnrManageService.selectQustnrTmplatManageList(qustnrManageVO);
            model.addAttribute("listQustnrTmplat", listQustnrTmplat);
        }

		return sLocationUrl;
	}

	/**
	 * 설문관리를 등록한다.
	 * @param searchVO
	 * @param commandMap
	 * @param qustnrManageVO
	 * @param bindingResult
	 * @param model
	 * @return "egovframework/com/uss/olp/qmc/EgovQustnrManageRegist"
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=insertEgovQustnrManage")
	public String qustnrManageRegist(
			@ModelAttribute("searchVO") ComDefaultVO searchVO,
			@CommandMap Map commandMap,
			@ModelAttribute("qustnrManageVO") QustnrManageVO qustnrManageVO,
			BindingResult bindingResult,
    		ModelMap model)
    throws Exception {
		//로그인 객체 선언
		UserVO userVo = SessionUtil.getUserInfo();

		String sLocationUrl = "/egovframework/com/uss/olp/qmc/BD_EgovQustnrManageRegist";

		String sCmd = commandMap.get("cmd") == null ? "" : (String)commandMap.get("cmd");
		LOGGER.info("cmd => {}", sCmd);

     	//공통코드  직업유형 조회
    	List listComCode = codeService.findCodesByGroupNo("9");
    	model.addAttribute("code9", listComCode);

        if(sCmd.equals("save")){

            beanValidator.validate(qustnrManageVO, bindingResult);
    		if (bindingResult.hasErrors()){
            	//설문템플릿 정보 불러오기
                List listQustnrTmplat = egovQustnrManageService.selectQustnrTmplatManageList(qustnrManageVO);
                model.addAttribute("listQustnrTmplat", listQustnrTmplat);
    			return sLocationUrl;
    		}

    		//아이디 설정
    		qustnrManageVO.setRegister(userVo.getUserNo());
    		qustnrManageVO.setUpdusr(userVo.getUserNo());

        	egovQustnrManageService.insertQustnrManage(qustnrManageVO);
        	model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.insert", new String[]{"설문정보"}, Locale.getDefault()));
        	sLocationUrl = egovQustnrManageList(searchVO, commandMap, qustnrManageVO, model);
        	//"redirect:/uss/olp/qmc/EgovQustnrManageList.do";
        }else{
        	//설문템플릿 정보 불러오기
            List listQustnrTmplat = egovQustnrManageService.selectQustnrTmplatManageList(qustnrManageVO);
            model.addAttribute("listQustnrTmplat", listQustnrTmplat);

        }

		return sLocationUrl;
	}
	
	@RequestMapping(params="df_method_nm=excelResponseData")
	public ModelAndView excelResponseData(@CommandMap Map commandMap,
			@ModelAttribute("qustnrManageVO") QustnrManageVO qustnrManageVO) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		List qustnrInfo = egovQustnrManageService.selectQustnrManageDetail(qustnrManageVO);
		List<Map> listTitle = egovQustnrManageService.selectQustnrResponseListTitle(qustnrManageVO);
		List<Map> listData = egovQustnrManageService.selectQustnrResponseListData(qustnrManageVO);

        ArrayList<String> headers = new ArrayList<String>(listTitle.size()+3);
        headers.add("연번");
        headers.add("로그인아이디");
        headers.add("이메일");
        
        for(Map title : listTitle) {
        	headers.add(MapUtils.getString(title, "qestnSn"));
        }
        
        ArrayList<String> items = new ArrayList<String>(listTitle.size()+3);
        items.add("no");
        items.add("loginId");
        items.add("trgterEmail");

        for(Map title : listTitle) {
        	items.add(MapUtils.getString(title, "qestnSn"));
        }
        
        String[] arryHeaders = new String[] {};
        String[] arryItems = new String[] {};
        arryHeaders = headers.toArray(arryHeaders);
        arryItems = items.toArray(arryItems);
        
        // 데이터 가공
        List<Map> xlsList = new ArrayList();
        Map xlsMap = new HashMap();
        String trgtEmail = "";
        
        for (int i=0; i<listData.size(); i++) {
        	Map data = listData.get(i);
        	
        	if (!trgtEmail.equals(MapUtils.getString(data, "trgterEmail"))) {
        		trgtEmail = MapUtils.getString(data, "trgterEmail");
        		
        		if (!xlsMap.isEmpty()) xlsList.add(xlsMap);
            	xlsMap = new HashMap();
            	xlsMap.put("no", i+1);
            	xlsMap.put("loginId", MapUtils.getString(data, "loginId"));		/* 로그인아이디 */
            	xlsMap.put("trgterEmail", trgtEmail);		/* 이메일 */
        	}
        	
        	//질문에 대한 응답값 설정
        	if (MapUtils.getString(data, "qestnTyCode").equals("1")) {
        		LOGGER.debug("객관식="+MapUtils.getString(data, "qestnSn"));
        		// 객관식
        		
        		// 다중선택
        		if (MapUtils.getString(xlsMap, MapUtils.getString(data, "qestnSn")) == null) {
            		if (MapUtils.getString(data, "etcAnswerCn").isEmpty()) {
    					xlsMap.put(	MapUtils.getString(data, "qestnSn"), MapUtils.getString(data, "iemSn"));
            		}
            		else {
                		// 기타답변이 존재하면 [기타답변] 처리
						xlsMap.put(MapUtils.getString(data, "qestnSn"), MapUtils.getString(data, "iemSn").concat("[")
								.concat(MapUtils.getString(data, "etcAnswerCn")).concat("]"));
            		}
        		} else {
        			// 기 응답한 항목이 저장되어 있으면 append 처리한다.
            		if (MapUtils.getString(data, "etcAnswerCn").isEmpty()) {
						xlsMap.put(
								MapUtils.getString(data, "qestnSn"),
								MapUtils.getString(xlsMap, MapUtils.getString(data, "qestnSn")).concat(", ")
										.concat(MapUtils.getString(data, "iemSn")));
            		}
            		else {
                		// 기타답변이 존재하면 [기타답변] 처리
						xlsMap.put(
								MapUtils.getString(data, "qestnSn"),
								MapUtils.getString(xlsMap, MapUtils.getString(data, "qestnSn"))
										.concat(", ")
										.concat(MapUtils.getString(data, "iemSn").concat("[")
												.concat(MapUtils.getString(data, "etcAnswerCn")).concat("]")));
            		}
        		}
        	}
        	else {
        		LOGGER.debug("주관식="+MapUtils.getString(data, "qestnSn"));
        		// 주관식
        		xlsMap.put(MapUtils.getString(data, "qestnSn"), MapUtils.getString(data, "respondAnswerCn"));
        	}
        }
        // 마지막 레코드 처리
        xlsList.add(xlsMap);

        for (Map row : xlsList) {
        	LOGGER.debug("row="+row);
        }
        
        mv.addObject("_headers", arryHeaders);
        mv.addObject("_items", arryItems);
        mv.addObject("_list", xlsList);
        
        IExcelVO excel = new ExcelVO((String) ( (Map)qustnrInfo.get(0) ).get("qestnrId"));
				
		return ResponseUtil.responseExcel(mv, excel);
	}
	

	/**
	 * 메일발송 설정 목록조회
	 * @param commandMap 설문ID, 템플릿ID, 목록검색 조건
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=qustnrTrgterEmailListPopup")
	public String qustnrTrgterEmailListPopup(@CommandMap Map commandMap, ModelMap model) throws Exception {

		HashMap param = new HashMap();
		
		param.put("searchCondition", MapUtils.getString(commandMap, "searchCondition"));
		param.put("qestnrId", MapUtils.getString(commandMap, "qestnrId"));
		param.put("qestnrTmplatId", MapUtils.getString(commandMap, "qestnrTmplatId"));
		
		int totCnt = (Integer)egovQustnrManageService.selectQustnrTrgterEmailListCnt(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(MapUtils.getIntValue(commandMap, "df_curr_page")).totalRowCount(totCnt).rowSize(MapUtils.getIntValue(commandMap, "df_row_per_page")).build();
		pager.makePaging();
		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());

        List resultList = egovQustnrManageService.selectQustnrTrgterEmailList(param);
        model.addAttribute("resultList", resultList);
		model.addAttribute("pager", pager);

        model.addAttribute("qestnrId", commandMap.get("qestnrId") == null ? "" : (String)commandMap.get("qestnrId"));
        model.addAttribute("qestnrTmplatId", commandMap.get("qestnrTmplatId") == null ? "" : (String)commandMap.get("qestnrTmplatId"));
        
		return "/egovframework/com/uss/olp/qmc/PD_QustnrTrgterEmailListPopup";
	}
	
	/**
	 * 이메일 주소 삭제
	 * @param commandMap 설문ID, 템플릿ID, 이메일주소목록
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=deleteQustnrTrgterEmail")
	public String deleteQustnrTrgterEmail(@CommandMap Map commandMap, ModelMap model) throws Exception {
		
		HashMap param = new HashMap();
		param.put("qestnrId", MapUtils.getString(commandMap, "qestnrId"));
		param.put("qestnrTmplatId", MapUtils.getString(commandMap, "qestnrTmplatId"));
		
		if (commandMap.get("chk_email_addr") instanceof String[]) {
			param.put("emailList", commandMap.get("chk_email_addr"));
		} else {
			param.put("emailList", new String[] {(String)commandMap.get("chk_email_addr")});
		}
		
		egovQustnrManageService.deleteQustnrTrgterEmail(param);
		
		model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.delete", new String[]{"이메일"}, Locale.getDefault()));

		return qustnrTrgterEmailListPopup(commandMap, model);
	}
	
	/**
	 * 메일등록 화면
	 * @param commandMap 설문ID, 템플릿ID
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=registTrgterEmail")
	public String registTrgterEmail(@CommandMap Map commandMap, ModelMap model) throws Exception {
		HashMap param = new HashMap();
		param.put("qestnrId", MapUtils.getString(commandMap, "qestnrId"));
		param.put("qestnrTmplatId", MapUtils.getString(commandMap, "qestnrTmplatId"));
		
		Map resultInfo = egovQustnrManageService.selectQustnrTrgterInfoGreeting(param);
		model.addAttribute("resultInfo", resultInfo);
		
        model.addAttribute("qestnrId", commandMap.get("qestnrId") == null ? "" : (String)commandMap.get("qestnrId"));
        model.addAttribute("qestnrTmplatId", commandMap.get("qestnrTmplatId") == null ? "" : (String)commandMap.get("qestnrTmplatId"));
        
		return "/egovframework/com/uss/olp/qmc/PD_QustnrTrgterEmailRegistPopup.jsp";
	}
	
	/**
	 * 이메일 등록
	 * @param commandMap 설문ID, 템플릿ID, 이메일, 메일제목, 설문안내
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=insertTrgterEmail")
	public String insertTrgterEmail(@CommandMap Map commandMap, ModelMap model) throws Exception {
		HashMap param = null;
		ArrayList emailList = null;
		
		// 이메일 목록 TXT를 Array로 변환
		StringTokenizer token = new StringTokenizer(MapUtils.getString(commandMap, "txtEmail"));

		int reject = 0;
		int dupl = 0;
		
		if (token.countTokens() > 0) {
			// 수신 거부 이메일 목록
			List resultList = egovQustnrManageService.selectRejectEmailList(new HashMap());
			ArrayList rejectList = new ArrayList();
			for (int i=0; i<resultList.size(); i++) {
				Map data = (Map) resultList.get(i);
				rejectList.add(data.get("email"));
			}
			
			// 기 등록된 이메일 목록
			param = new HashMap();
			param.put("qestnrId", MapUtils.getString(commandMap, "qestnrId"));
			param.put("qestnrTmplatId", MapUtils.getString(commandMap, "qestnrTmplatId"));
			
			resultList = egovQustnrManageService.selectDuplEmailList(param);
			ArrayList duplList = new ArrayList();
			for (int i=0; i<resultList.size(); i++) {
				Map data = (Map) resultList.get(i);
				duplList.add(data.get("email"));
			}
			
			// 확인서발급기업 이메일 목록
			resultList = egovQustnrManageService.selectCnfirmEnpEmailList(new HashMap());
			ArrayList cnfimList = new ArrayList();
			for (int i=0; i<resultList.size(); i++) {
				Map data = (Map) resultList.get(i);
				cnfimList.add(data.get("email"));
			}

			// 이메일주소 검증
			emailList = new ArrayList();
			while(token.hasMoreElements()) {
				String email = token.nextToken();

				// 수신거부 검증
				if (rejectList.contains(email)) {
					reject++;
					continue;
				}
				
				if (duplList.contains(email)) {
					dupl++;
					continue;
				}

				param = new HashMap();
				param.put("qestnrId", MapUtils.getString(commandMap, "qestnrId"));
				param.put("qestnrTmplatId", MapUtils.getString(commandMap, "qestnrTmplatId"));
				param.put("trgterEmail", email);

				// 대상자분류
				if (cnfimList.contains(email)) {
					// 확인서발급기업
					param.put("trgterCl", "1");
				} else {
					// 직접입력
					param.put("trgterCl", "2");
				}
				
				emailList.add(param);
			}
		}
		
		// 저장처리
		param = new HashMap();
		param.put("qestnrId", MapUtils.getString(commandMap, "qestnrId"));
		param.put("qestnrTmplatId", MapUtils.getString(commandMap, "qestnrTmplatId"));
		param.put("mailQustnrSj", MapUtils.getString(commandMap, "mailQustnrSj"));
		param.put("mailQustnrWritngGuidanceCn", MapUtils.getString(commandMap, "mailQustnrWritngGuidanceCn"));
		if (emailList != null && emailList.size() > 0) param.put("emailList", emailList);
		
		egovQustnrManageService.insertQustnrTrgterEmail(param);
		
		if (reject > 0 || dupl > 0) {
			model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.insert", new String[]{"발송정보 일부(수신거부:"+reject+", 중복주소:"+dupl+"제외)"}, Locale.getDefault()));
		} else {
			model.addAttribute("resultMsg", egovMessageSource.getMessage("success.common.insert", new String[]{"발송정보"}, Locale.getDefault()));
		}

		return qustnrTrgterEmailListPopup(commandMap, model);
	}
	
	/**
	 * 확인서발급기업 담당자 이메일 목록 조회
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=selectCnfirmEnpEmailList")
	public ModelAndView selectCnfirmEnpEmailList(@CommandMap Map commandMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		List resultList = egovQustnrManageService.selectCnfirmEnpEmailList(new HashMap());
		
		if (resultList == null || resultList.size() <= 0) {
			return ResponseUtil.responseJson(mv, false);
		}
		
		ArrayList emailList = new ArrayList();
		
		for (int i=0; i<resultList.size(); i++) {
			Map data = (Map) resultList.get(i);
			emailList.add(data.get("email"));
		}
		
		HashMap map = new HashMap();
		map.put("emailList", emailList);
		
		return ResponseUtil.responseJson(mv, true, map);
	}
	
	/**
	 * 선택 이메일 발송 요청
	 * @param commandMap 설문ID, 템플릿ID, 이메일목록
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=rqstCheckedQustnrTrgterEmail")
	public String rqstCheckedQustnrTrgterEmail(@CommandMap Map commandMap, ModelMap model) throws Exception {
		HashMap param = null;
		ArrayList emailList = null;
		String[] chkEamilAddr = null;
		
		if (commandMap.get("chk_email_addr") instanceof String[]) {
			chkEamilAddr = (String[]) commandMap.get("chk_email_addr");
		} else {
			chkEamilAddr = new String[] {(String)commandMap.get("chk_email_addr")};
		}
		
		if (chkEamilAddr.length > 0) {
			
			// 설문정보 조회
			param = new HashMap();
			param.put("qestnrId", MapUtils.getString(commandMap, "qestnrId"));
			param.put("qestnrTmplatId", MapUtils.getString(commandMap, "qestnrTmplatId"));
			
			Map resultInfo = egovQustnrManageService.selectQustnrEmailInfo(param);
			
			// 발송정보
			emailList = new ArrayList();

			for(int i=0; i<chkEamilAddr.length; i++) {
				String email = chkEamilAddr[i];

				param = new HashMap();
				param.put("prpos", "R");
				param.put("emailSj", MapUtils.getString(resultInfo, "mailQustnrSj"));
				param.put("tmplatFileCours", "TMPL_RQST_SURVEY.html");
				param.put("tmplatUseAt", "Y");
				param.put("sndrEmailAdres", GlobalConst.MASTER_EMAIL_ADDR);
				param.put("rcverEmailAdres", email);
				param.put("substInfo1", "SURVEY_TITLE::"+MapUtils.getString(resultInfo, "mailQustnrSj"));
				param.put("substInfo2", "SURVEY_TERM::"+MapUtils.getString(resultInfo, "qestnrBeginDe")+"~"+MapUtils.getString(resultInfo, "qestnrEndDe"));
				param.put("substInfo3", "SURVEY_PURPOSE::"+MapUtils.getString(resultInfo, "qustnrPurps"));
				param.put("substInfo4", "SURVEY_GUIDE::"+MapUtils.getString(resultInfo, "mailQustnrWritngGuidanceCn"));
				param.put("substInfo5", "SURVEY_ID::"+MapUtils.getString(commandMap, "qestnrId"));
				param.put("substInfo6", "SURVEY_TMPL_ID::"+MapUtils.getString(commandMap, "qestnrTmplatId"));
				param.put("substInfo7", "SURVEY_EMAIL::"+email);
				param.put("substInfo8", "QUSTNR_EMAIL_ADDR::"+GlobalConst.QUSTNR_EMAIL_ADDR);
				
				HashMap<String, String> phone = (HashMap) StringUtil.telNumFormat(GlobalConst.QUSTNR_PHONE_NUM);
				param.put("substInfo9", "QUSTNR_PHONE_NUM::"+phone.get("first").concat("-").concat(phone.get("middle")).concat("-").concat(phone.get("last")));
				param.put("sndngSttus", "R");
				param.put("paramtr1", MapUtils.getString(commandMap, "qestnrId"));
				param.put("paramtr2", MapUtils.getString(commandMap, "qestnrTmplatId"));
				
				emailList.add(param);
			}

			// 저장처리
			param = new HashMap();
			param.put("emailList", emailList);
			egovQustnrManageService.insertRequestSendEmail(param);
		}

		model.addAttribute("resultMsg", egovMessageSource.getMessage("success.request.msg", new String[]{}, Locale.getDefault()));

		return qustnrTrgterEmailListPopup(commandMap, model);
	}
	
	/**
	 * 전체 이메일 발송 요청
	 * @param commandMap 설문ID, 템플릿ID
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="df_method_nm=rqstAllQustnrTrgterEmail")
	public String rqstAllQustnrTrgterEmail(@CommandMap Map commandMap, ModelMap model) throws Exception {

		// 설문정보 조회
		HashMap param = new HashMap();
		param.put("qestnrId", MapUtils.getString(commandMap, "qestnrId"));
		param.put("qestnrTmplatId", MapUtils.getString(commandMap, "qestnrTmplatId"));
		
		ArrayList rqstEmailAddr = (ArrayList) egovQustnrManageService.selectAllTargetEmailList(param);
		
		if (rqstEmailAddr.size() > 0) {
	
			Map resultInfo = egovQustnrManageService.selectQustnrEmailInfo(param);
			
			// 발송정보
			ArrayList emailList = new ArrayList();

			for(int i=0; i<rqstEmailAddr.size(); i++) {
				String email = (String) rqstEmailAddr.get(i);

				param = new HashMap();
				param.put("prpos", "R");
				param.put("emailSj", MapUtils.getString(resultInfo, "mailQustnrSj").concat("[협조요청]"));
				param.put("tmplatFileCours", "TMPL_RQST_SURVEY.html");
				param.put("tmplatUseAt", "Y");
				param.put("sndrEmailAdres", GlobalConst.MASTER_EMAIL_ADDR);
				param.put("rcverEmailAdres", email);
				param.put("substInfo1", "SURVEY_TITLE::"+MapUtils.getString(resultInfo, "mailQustnrSj"));
				param.put("substInfo2", "SURVEY_TERM::"+MapUtils.getString(resultInfo, "qestnrBeginDe")+"~"+MapUtils.getString(resultInfo, "qestnrEndDe"));
				param.put("substInfo3", "SURVEY_PURPOSE::"+MapUtils.getString(resultInfo, "qustnrPurps"));
				param.put("substInfo4", "SURVEY_GUIDE::"+MapUtils.getString(resultInfo, "mailQustnrWritngGuidanceCn"));
				param.put("substInfo5", "SURVEY_ID::"+MapUtils.getString(commandMap, "qestnrId"));
				param.put("substInfo6", "SURVEY_TMPL_ID::"+MapUtils.getString(commandMap, "qestnrTmplatId"));
				param.put("substInfo7", "SURVEY_EMAIL::"+email);
				param.put("substInfo8", "QUSTNR_EMAIL_ADDR::"+GlobalConst.QUSTNR_EMAIL_ADDR);
				
				HashMap<String, String> phone = (HashMap) StringUtil.telNumFormat(GlobalConst.QUSTNR_PHONE_NUM);
				param.put("substInfo9", "QUSTNR_PHONE_NUM::"+phone.get("first").concat("-").concat(phone.get("middle")).concat("-").concat(phone.get("last")));
				param.put("sndngSttus", "R");
				param.put("paramtr1", MapUtils.getString(commandMap, "qestnrId"));
				param.put("paramtr2", MapUtils.getString(commandMap, "qestnrTmplatId"));
				
				emailList.add(param);
			}

			// 저장처리
			param = new HashMap();
			param.put("emailList", emailList);
			egovQustnrManageService.insertRequestSendEmail(param);
		}

		model.addAttribute("resultMsg", egovMessageSource.getMessage("success.request.msg", new String[]{}, Locale.getDefault()));

		return qustnrTrgterEmailListPopup(commandMap, model);
	}
}


