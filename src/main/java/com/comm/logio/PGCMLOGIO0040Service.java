package com.comm.logio;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.comm.certify.CertifyService;
import com.comm.certify.NiceDecVO;
import com.comm.certify.NiceEncVO;
import com.comm.menu.MenuService;
import com.comm.user.UserService;
import com.comm.user.UserVO;
import com.infra.system.GlobalConst;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;
import com.infra.util.crypto.Crypto;
import com.infra.util.crypto.CryptoFactory;
import biz.tech.um.PGUM0001Service;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;
//import gov.mogaha.gpin.sp.proxy.GPinProxy;
import Kisinfo.Check.IPINClient;

/**
 * 회원서비스>회원가입
 * 
 * @author JGS
 * 
 */
@Service("PGCMLOGIO0040")
public class PGCMLOGIO0040Service extends EgovAbstractServiceImpl
{
	private Locale locale = Locale.getDefault();
	private static final Logger logger = LoggerFactory.getLogger(PGCMLOGIO0040Service.class);

	@Resource(name = "certifyService")
	private CertifyService certifyService;
	
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;
	
	@Resource(name = "messageSource")
	private MessageSource messageSource;

	@Autowired
	UserService userService;
	
	@Autowired
	MenuService menuService;
	
	@Autowired
	PGUM0001Service pgum0001;
	
	@Autowired
	ServletContext servletContext;
	

	/**
	 * 회원가입>약관동의(STEP01)
	 * 
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception
	{
		//return new ModelAndView("/www/mb/BD_UIMBU0040");
		return new ModelAndView("/www/comm/logio/BD_UICMLOGIOU0040");
	}
	
	
	/**
	 * 회원가입>본인인증(STEP02-1)
	 * 
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView certify(Map<?, ?> rqstMap) throws Exception
	{
		//ModelAndView mv = new ModelAndView("/www/mb/BD_UIMBU0041");
		ModelAndView mv = new ModelAndView("/www/comm/logio/BD_UICMLOGIOU0041");
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		
		//핸드포인증 암호화
		NiceEncVO niceEncVo = certifyService.encDataNice();
		if(niceEncVo.getEncErrCd()!=0 && niceEncVo.getIpinencErrCd()!=0) {		
			throw processException("fail.common.custom",new String[] {niceEncVo.getMessage()});
		}
		

		String niceipinUserIP =null;
		if (Validate.isNotEmpty(request.getRemoteAddr())) {
			niceipinUserIP = request.getRemoteAddr();
			logger.debug("gpincertify"+"getRemoteAddr ="  + request.getRemoteAddr() + "session.gpinUserIP=" + niceipinUserIP);
		} else {
			niceipinUserIP = request.getHeader("X-FORWARDED-FOR");
			logger.debug("gpincertify"+"getRemoteAddr ="  + request.getHeader("X-FORWARDED-FOR") + "session.gpinUserIP=" + niceipinUserIP);
		}

		niceEncVo.setClientIP(niceipinUserIP);
		
		SessionUtil.setNiceEncInfo(niceEncVo, propertiesService.getInt("session.timeout"));
		return mv;
	}
	
	/**
	 * 회원가입>본인인증(STEP02-1)
	 * 
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	/*
	public ModelAndView gpincertify(Map<?, ?> rqstMap) throws Exception {
		
		ModelAndView mv = new ModelAndView("/cmm/ND_UICMC0006");
		HttpSession session = SessionUtil.getHttpSession(true);
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		
		if(request.isSecure()) {
			session.setAttribute("gpinAuthRetPage", propertiesService.getString("gpinresponsurlHttps"));
		}else {
			session.setAttribute("gpinAuthRetPage", propertiesService.getString("gpinresponsurl"));
		}
		
	    // 인증 수신시 요청처와 동일한 위치인지를 확인할 요청자IP를 session에 저장합니다.
		if (Validate.isNotEmpty(request.getRemoteAddr())) {
			session.setAttribute("gpinUserIP", request.getRemoteAddr());
			logger.debug("gpincertify"+"getRemoteAddr ="  + request.getRemoteAddr() + "session.gpinUserIP=" + session.getAttribute("gpinUserIP"));
		} else {
			session.setAttribute("gpinUserIP", request.getHeader("X-FORWARDED-FOR"));
			logger.debug("gpincertify"+"getRemoteAddr ="  + request.getHeader("X-FORWARDED-FOR") + "session.gpinUserIP=" + session.getAttribute("gpinUserIP"));
		}
	    
	    session.setMaxInactiveInterval( propertiesService.getInt("session.timeout"));

	    GPinProxy proxy = GPinProxy.getInstance(servletContext);
	    

	    String requestHTML = "인증요청 메시지생성 실패";
	    try
	    {
	        if (request.getParameter("Attr") != null)
	        {
	            requestHTML = proxy.makeAuthRequest(Integer.parseInt(request.getParameter("Attr")));
	        }
	        else
	        {
	            requestHTML = proxy.makeAuthRequest();
	        }
	    }
	    catch(Exception e)
	    {
	        // 에러에 대한 처리는 이용기관에 맞게 처리할 수 있습니다.
	        e.printStackTrace();
	        	throw processException("errors.nice.system",new String[] {e.getMessage()});
	    }
	    // 인증 요청페이지를 생성하여 자동으로 공공I-PIN으로 forwarding 합니다.
	    
	    mv.addObject("rethtml", requestHTML);
	    return 	mv;
	}
	*/
	
	/**
	 * 회원가입>본인인증결과(STEP02-2:휴대전화인증)
	 * 
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView certifyResultMobile(Map<?, ?> rqstMap) throws Exception
	{		
		//ModelAndView mv = new ModelAndView("/www/mb/PD_UIMBU0047");
		ModelAndView mv = new ModelAndView("/www/comm/logio/PD_UICMLOGIOU0047");
		
		String encParam = (String) rqstMap.get("EncodeData");		
		NiceDecVO niceDecVo = certifyService.decDataNice(encParam);
		// 복호화 성공
		if(niceDecVo.getDecErrCd()==0) {
			NiceEncVO niceEncVo = SessionUtil.getNiceEncInfo();
			// 암호화시 세션에 저장된 요청번호와 복호화된 요청정보 비교
			if(Validate.isEmpty(niceEncVo)||!niceEncVo.getRequestNumber().equals(niceDecVo.getRequestNumber())) {
				throw processException("fail.common.session");
			}
			String failErrcd = StringUtil.trim(niceDecVo.getFailErrCd());
			if(!(Validate.isEmpty(failErrcd)||"0000".equals(failErrcd))) {								
				throw processException("errors.nice.failcertify");
			}
			// 복호화인증정보 설정
			SessionUtil.setNiceDecInfo(niceDecVo, propertiesService.getInt("session.timeout"));
			// 인증유형(휴대전화인증) 설정
			SessionUtil.setCertifyType(GlobalConst.CERTIFY_TYPE_MOBILE, propertiesService.getInt("session.timeout"));
		}else {			
			throw processException("fail.common.custom",new String[] {niceDecVo.getMessage()});
		}
		// TODO JGS:모바일인증 중복 가입여부 확인(필요시 주석해제)
		/*
		// 모바일인증 중복가입 여부
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("MOBLPHON_SELF_CRTFC_NO",niceDecVo.getDupInfo());// 휴대폰본인인증번호		
		int duplGnrMobCrtNoCnt = userService.findDuplGnrlMobCrtNo(param); // 개인회원정보
		int duplEntMobCrtNoCnt = userService.findDuplEntlMobCrtNo(param); // 기업회원정보
		if(duplGnrMobCrtNoCnt>0||duplEntMobCrtNoCnt>0) {
			mv.addObject("joinedUser", "Y");
		}else {
			mv.addObject("joinedUser", "N");			
		}
		*/
		return mv;
	}

	/**
	 * 회원가입>본인인증결과(STEP02-2:G-PIN인증)
	 * 
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	/**
	 * 회원가입>본인인증결과(STEP02-2:휴대전화인증)
	 * 
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView certifyResultNiceIpin(Map<?, ?> rqstMap) throws Exception
	{		
		//ModelAndView mv = new ModelAndView("/www/mb/PD_UIMBU0047");
		ModelAndView mv = new ModelAndView("/www/comm/logio/PD_UICMLOGIOU0047");
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		
		String encParam = (String) rqstMap.get("enc_data");		
		NiceDecVO niceDecVo = certifyService.ipindecDataNice(encParam);
		// 복호화 성공
		if(niceDecVo.getDecErrCd()==1) {
			NiceEncVO niceEncVo = SessionUtil.getNiceEncInfo();
			// 암호화시 세션에 저장된 요청번호와 복호화된 요청정보 비교
			if(Validate.isEmpty(niceEncVo)||!niceEncVo.getIpinrequestNumber().equals(niceDecVo.getRequestNumber())) {
				throw processException("fail.common.session");
			}
			
			boolean ipCheck = false;
			if (Validate.isNotEmpty(request.getRemoteAddr())) {
				ipCheck = request.getRemoteAddr().equals(niceEncVo.getClientIP());
				logger.debug("certifyResponseGpin"+"getRemoteAddr ="  + request.getRemoteAddr() + "session.gpinUserIP=" + niceEncVo.getClientIP());
			} else {
				ipCheck = request.getHeader("X-FORWARDED-FOR").equals(niceEncVo.getClientIP());
				logger.debug("certifyResponseGpin"+"getRemoteAddr ="  + request.getHeader("X-FORWARDED-FOR") + "session.gpinUserIP=" + niceEncVo.getClientIP());
			}		

			if(!ipCheck) {								
				throw processException("errors.ip");
			}

			// 복호화인증정보 설정
			SessionUtil.setNiceDecInfo(niceDecVo, propertiesService.getInt("session.timeout"));
			// 인증유형(휴대전화인증) 설정
			SessionUtil.setCertifyType(GlobalConst.CERTIFY_TYPE_IPIN, propertiesService.getInt("session.timeout"));
		}else {			
			throw processException("fail.common.custom",new String[] {niceDecVo.getMessage()});
		}
		// TODO JGS:모바일인증 중복 가입여부 확인(필요시 주석해제)
		/*
		// 모바일인증 중복가입 여부
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("MOBLPHON_SELF_CRTFC_NO",niceDecVo.getDupInfo());// 휴대폰본인인증번호		
		int duplGnrMobCrtNoCnt = userService.findDuplGnrlMobCrtNo(param); // 개인회원정보
		int duplEntMobCrtNoCnt = userService.findDuplEntlMobCrtNo(param); // 기업회원정보
		if(duplGnrMobCrtNoCnt>0||duplEntMobCrtNoCnt>0) {
			mv.addObject("joinedUser", "Y");
		}else {
			mv.addObject("joinedUser", "N");			
		}
		*/
		return mv;
	}

	/**
	 * 회원가입>본인인증결과(STEP02-3:아이핀인증)
	 * 
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView certifyResultIpin(Map<?, ?> rqstMap) throws Exception
	{		
		//ModelAndView mv = new ModelAndView("/www/mb/PD_UIMBU0041");
		ModelAndView mv = new ModelAndView("/www/comm/logio/PD_UICMLOGIOU0041");
		return mv;
	}
	
	/**
	 * 회원가입>유형선택(STEP03)
	 * 
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView selectCase(Map<?, ?> rqstMap) throws Exception
	{
		//ModelAndView mv = new ModelAndView("/www/mb/BD_UIMBU0042");
		ModelAndView mv = new ModelAndView("/www/comm/logio/BD_UICMLOGIOU0042");
		String certifyType = SessionUtil.getCertifyType();
		// 모바일인증
		if(GlobalConst.CERTIFY_TYPE_MOBILE.equals(certifyType)) {
			NiceDecVO niceDecVo = SessionUtil.getNiceDecInfo();
			if(Validate.isEmpty(niceDecVo)||Validate.isEmpty(niceDecVo.getDupInfo())) {
				throw processException("fail.common.session");
			}
		// 아이핀인증
		}else if(GlobalConst.CERTIFY_TYPE_IPIN.equals(certifyType)){
			// TODO JGS:세션에 아이핀 정보 유무 확인
			
		}else {
			throw processException("fail.common.session");
		}
		
		return mv;
	}
	
	
	/**
	 * 회원가입>정보입력(STEP04)
	 * 
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView joinInfoForm(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		String certifyType = SessionUtil.getCertifyType();
		String certifyName;
		// 모바일인증
		if(GlobalConst.CERTIFY_TYPE_MOBILE.equals(certifyType)) {
			NiceDecVO niceDecVo = SessionUtil.getNiceDecInfo();
			if(Validate.isEmpty(niceDecVo)||Validate.isEmpty(niceDecVo.getDupInfo())) {
				throw processException("fail.common.session");
			}
			certifyName = niceDecVo.getName(); 
		// 아이핀인증
		}else if(GlobalConst.CERTIFY_TYPE_IPIN.equals(certifyType)){
			NiceDecVO niceDecVo = SessionUtil.getNiceDecInfo();
			if(Validate.isEmpty(niceDecVo)||Validate.isEmpty(niceDecVo.getDupInfo())) {
				throw processException("fail.common.session");
			}
			certifyName = niceDecVo.getName(); 
		}else {
			// 지워야함
			certifyName = "TechBlue"; 
			// throw processException("fail.common.session");
		}
		
		mv.addObject("certifyName", certifyName);
		String joinType = MapUtils.getString(rqstMap, "ad_join_type","");
		
		if(joinType.equals("enterprise")) {
			//mv.setViewName("/www/mb/BD_UIMBU0043"); // 기업회원가입
			mv.setViewName("/www/comm/logio/BD_UICMLOGIOU0043"); // 기업회원가입
		}else {
			//mv.setViewName("/www/mb/BD_UIMBU0045"); // 개인회원가입
			mv.setViewName("/www/comm/logio/BD_UICMLOGIOU0045"); // 개인회원가입
		}
		return mv;
	}
	
	/**
	 * 회원가입>저장(STEP05)
	 * 
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView insertUserInfo(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> userInfo = new HashMap<String,Object>();
		Map<String, Object> mngInfo = new HashMap<String, Object>();
		
		
		/* 2021.03.22
		 * ==== S: 오아림 변경 ===== 
		 * // 세션에서 인증 정보 추출
		 * NiceDecVO niceDecVo = SessionUtil.getNiceDecInfo();
		 * if(Validate.isEmpty(niceDecVo)||Validate.isEmpty(niceDecVo.getDupInfo())) {
		 * throw processException("fail.common.session");
		 * }
		 * 
		 * String certifyType = SessionUtil.getCertifyType();
		 * */
		
		String certifyType = "ipin";
		
		/* ===== E: 오아림 변경 ===== */
		
		// 모바일인증
		if(GlobalConst.CERTIFY_TYPE_MOBILE.equals(certifyType)) {
			// 2021.03.20 오아림 변경 === userInfo.put("MOBLPHON_SELF_CRTFC_NO",niceDecVo.getDupInfo());	// 휴대폰본인인증번호
		// 아이핀인증
		}else if(GlobalConst.CERTIFY_TYPE_IPIN.equals(certifyType)){
			// TODO JGS:세션에 아이핀 정보 유무 확인
			// TODO JGS:IPIN_본인인증번호 추가
			userInfo.put("IPIN_SELF_CRTFC_NO","");	// IPIN_본인인증번호
		}else {
			// 지워야함
			// throw processException("fail.common.session");
		}
		
		
		String userId 		= MapUtils.getString(rqstMap, "ad_user_id","").toLowerCase();
		String password 	= MapUtils.getString(rqstMap, "ad_user_pw","");
		String cPassword 	= MapUtils.getString(rqstMap, "ad_confirm_password","");		
		
		String policyInfoAgreAt    = MapUtils.getString(rqstMap, "chk_terms03","N");		// 정책정보동의여부
		if(!policyInfoAgreAt.equals("Y")) {
			policyInfoAgreAt = "N";
		}
		
		// 인증된 사용자명 사용 - 웹 취약점 조치, 2017-04-04
		
		/* 2021.03.22 
		 * ======== S: 오아림 변경 =======  */
		String userNm 		= MapUtils.getString(rqstMap, "ad_user_nm","");
		// String userNm		= niceDecVo.getName();								// 사용자명
		
		/* ======E: 오아림 변경 ======= */
		String phoneNum		= MapUtils.getString(rqstMap, "ad_phone_num","");	// 휴대폰번호
		String telno2		= MapUtils.getString(rqstMap, "ad_tel2","");			// 담당자 일반전화번호
		String userEmail	= MapUtils.getString(rqstMap, "ad_user_email","");	// 이메일
		String rcvEmailYn 	= MapUtils.getString(rqstMap, "ad_rcv_email","");	// 이메일수신동의
		String rcvSmsYn		= MapUtils.getString(rqstMap, "ad_rcv_sms","");		// 문자수신동의
		
		String jurirno      = MapUtils.getString(rqstMap, "ad_jurirno","");		// 법인등록번호
		String chargerDept  = MapUtils.getString(rqstMap, "ad_dept","");		// 담당부서
		String ofcps        = MapUtils.getString(rqstMap, "ad_ofcps","");		// 직위
		String telno        = MapUtils.getString(rqstMap, "ad_tel","");			// 전화번호
		String fxnum        = MapUtils.getString(rqstMap, "ad_fax","");			// 팩스번호
		String bizrno       = MapUtils.getString(rqstMap, "ad_bizrno","");		// 사업자등록번호
		String entrprsNm    = MapUtils.getString(rqstMap, "ad_entrprs_nm","");	// 기업명
		String rprsntvNm    = MapUtils.getString(rqstMap, "ad_rprsntv_nm","");	// 대표자명		
		String hedofcAdres  = MapUtils.getString(rqstMap, "ad_addr","");		// 본사주소
		String hedofcZip    = MapUtils.getString(rqstMap, "ad_zipcod","");		// 본사우편번호	
		String dn			= MapUtils.getString(rqstMap, "ad_dn","");			// 사업자 공인인증서 DN값
		
		// 기업 사용자	
		String mngChargerNm	= MapUtils.getString(rqstMap, "ad_manager_nm","");				// 담당자이름
		String mngDept		= MapUtils.getString(rqstMap, "ad_manager_dept","");			// 소속부서
		String mngOfcps		= MapUtils.getString(rqstMap, "ad_manager_ofcps","");			// 직위	
		String mngTelNo		= MapUtils.getString(rqstMap, "ad_manager_tel","");		    	// 전화번호
		String mngPhoneNo	= MapUtils.getString(rqstMap, "ad_manager_phone_num","");		// 휴대전화번호
		String mngEmail		= MapUtils.getString(rqstMap, "ad_manager_user_email","");		// 이메일
		String mngEmailYn 	= MapUtils.getString(rqstMap, "ad_manager_rcv_email","");		// 이메일수신동의
		String mngSmsYn		= MapUtils.getString(rqstMap, "ad_manager_rcv_sms","");			// 문자수신동의
		
		
		String adres        = "";	// 주소
		String zip          = "";	// 우편번호
		String hpe_cd       = "";	// 기업관리코드
		
		
		// 아이디 유효성 체크
		Map<String, Object> resultMap = validateId(userId);
		if(!MapUtils.getBooleanValue(resultMap,"result",false)) {
			throw processException("fail.common.custom",new String[]{MapUtils.getString(resultMap, "message", "")});
		}
		// 비밀번호 유효성 체크
		resultMap = validatePw(userId, password,cPassword);
		if(!MapUtils.getBooleanValue(resultMap,"result",false)) {
			throw processException("fail.common.custom",new String[]{MapUtils.getString(resultMap, "message", "")});
		}
		// PASSWORD 암호화
		byte pszDigest[] = new byte[32];		
		Crypto cry = CryptoFactory.getInstance("SHA256");
		pszDigest =cry.encryptTobyte(password);		
		
		String emplyrTy = ""; 						// 사용자유형
		String authorGroupCode = ""; 				// 사용자권한그룹
		String sttus = GlobalConst.EMPLYR_STTUS_01;	// 회원상태:정상
		String joinType = MapUtils.getString(rqstMap, "ad_join_type","");
		
		if(joinType.equals("enterprise")) {			
			emplyrTy = GlobalConst.EMPLYR_TY_EP; 			// 사용자유형:기업사용자
			authorGroupCode = GlobalConst.AUTH_DIV_ENT; 	// 사용자권한그룹:기업사용자
			
			//mv.setViewName("/www/mb/BD_UIMBU0044");
			mv.setViewName("/www/comm/logio/BD_UICMLOGIOU0044");
		}else {
			emplyrTy = GlobalConst.EMPLYR_TY_GN; 			// 사용자유형:일반사용자
			authorGroupCode = GlobalConst.AUTH_DIV_PUB; 	// 사용자권한그룹:기업사용자
			
			//mv.setViewName("/www/mb/BD_UIMBU0046");
			mv.setViewName("/www/comm/logio/BD_UICMLOGIOU0046");
		}

		// 사용자정보
		userInfo.put("LOGIN_ID",userId);		// 로그인아이디		
		userInfo.put("PASSWORD",pszDigest);	// 비밀번호
		userInfo.put("EMPLYR_TY",emplyrTy);		// 사용자유형
		userInfo.put("STTUS",sttus);			// 상태
		
		// 일반사용자
		userInfo.put("NM",userNm);			// 이름		
		
		// 기업사용자		
		userInfo.put("JURIRNO",jurirno);               	// 법인등록번호(PK)   
		userInfo.put("CHARGER_NM",userNm);             	// 담당자명           
		userInfo.put("CHARGER_DEPT",chargerDept);      	// 담당자부서         
		userInfo.put("OFCPS",ofcps);                   	// 직위               
		userInfo.put("TELNO",telno);                   	// 전화번호           
		userInfo.put("TELNO2",telno2);                   	// 담당자 일반전화번호
		userInfo.put("FXNUM",fxnum);                   	// 팩스번호           
		userInfo.put("BIZRNO",bizrno);                 	// 사업자등록번호     
		userInfo.put("ENTRPRS_NM",entrprsNm);          	// 기업명             
		userInfo.put("RPRSNTV_NM",rprsntvNm);          	// 대표자명           
		userInfo.put("ADRES",adres);                   	// 주소               
		userInfo.put("ZIP",zip);						// 우편번호           
		userInfo.put("HEDOFC_ADRES",hedofcAdres);       // 본사주소           
		userInfo.put("HEDOFC_ZIP",hedofcZip);           // 본사우편번호       
		userInfo.put("HPE_CD",hpe_cd);                  // 기업관리코드       
		userInfo.put("DN", dn);							// 사업자번호 DN값
		userInfo.put("CERT_Y", "Y");					// 인증여부 Y
		
		// 일반사용자, 기업사용자
		userInfo.put("MBTLNUM",phoneNum);				// 휴대폰번호
		userInfo.put("EMAIL",userEmail);				// 이메일
		userInfo.put("EMAIL_RECPTN_AGRE",rcvEmailYn);	// 이메일수신동의
		userInfo.put("SMS_RECPTN_AGRE",rcvSmsYn);		// 문자메시지수신동의
		
		// 사용자권한그룹
		userInfo.put("AUTHOR_GROUP_CODE",authorGroupCode);	// 사용자권한그룹
		
		// 사용자약관동의
		userInfo.put("POLICY_INFO_AGRE_AT",policyInfoAgreAt);	// 정책정보동의여부
		
		// 책임자정보
		mngInfo.put("LOGIN_ID",userId);		// 로그인아이디	
		mngInfo.put("JURIRNO",jurirno);							// 법인등록번호
		mngInfo.put("CHARGER_NM", mngChargerNm);				// 책임자이름
		mngInfo.put("CHARGER_DEPT", mngDept);					// 소속부서
		mngInfo.put("OFCPS", mngOfcps);							// 직위
		mngInfo.put("TELNO", mngTelNo);							// 책임자 일반전화번호
		mngInfo.put("TELNO2", "");								
		mngInfo.put("MBTLNUM",mngPhoneNo);						// 휴대폰번호
		mngInfo.put("FXNUM", "");								
		mngInfo.put("EMAIL", mngEmail);							// 이메일
		mngInfo.put("BIZRNO", bizrno);							// 사업자등록번호
		mngInfo.put("ENTRPRS_NM", entrprsNm);					// 기업명
		mngInfo.put("RPRSNTV_NM", rprsntvNm);					// 대표자명
		mngInfo.put("HEDOFC_ADRES", "");						
		mngInfo.put("HEDOFC_ZIP", "");							
		mngInfo.put("EMAIL_RECPTN_AGRE", mngEmailYn);			// 이메일수신
		mngInfo.put("SMS_RECPTN_AGRE", mngSmsYn);				// SMS수신
		
		userService.insertUserInfo(userInfo);
		userService.insertMngUser(mngInfo);
		
		mv.addObject("userInfo", userInfo);

		// 세션 제거
		SessionUtil.getHttpSession(true).invalidate();
		pgum0001.setAnonymousInfo();
		
		return mv;
		
	}
	
	/**
	 * 아이디 중복 확인
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView checkDuplUserId(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		String loginId = MapUtils.getString(rqstMap, "ad_user_id","").toLowerCase();		

		if (StringUtils.isEmpty(loginId)) {
			return ResponseUtil.responseText(mv,Boolean.FALSE);
		}

		HashMap<String, Object> param = new HashMap();
		param.put("loginId", loginId);		

		// 사용자 조회
		UserVO userVo = userService.findUser(param);
		if (Validate.isEmpty(userVo)) {
			return ResponseUtil.responseText(mv,Boolean.TRUE);
		}
		return ResponseUtil.responseText(mv,Boolean.FALSE);
	}
	
	/**
	 * 법인등록번호 중복 확인
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView checkDuplJrirno(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		String jrirno = MapUtils.getString(rqstMap, "ad_jurirno","");
		String userNo = MapUtils.getString(rqstMap, "ad_user_no");
		if (StringUtils.isEmpty(jrirno)) {
			return ResponseUtil.responseText(mv,Boolean.FALSE);
		}

		HashMap<String, Object> param = new HashMap();
		param.put("JURIRNO", jrirno);
		param.put("USER_NO", userNo);
		
		// 법인등록번호 중복 조회
		int duplJrirnoCnt = userService.findDuplJrirno(param);
		if (duplJrirnoCnt>0) {
			return ResponseUtil.responseText(mv,Boolean.FALSE);
		}
		return ResponseUtil.responseText(mv,Boolean.TRUE);				

	}
	
	
	/**
	 * 일반사용자 휴대폰번호, 이메일 중복 조회
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView checkDuplGnrlUserInfo(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map jsonMap = new HashMap();
		
		String phoneNum = MapUtils.getString(rqstMap, "ad_phone_num");
		String userEmail = MapUtils.getString(rqstMap, "ad_user_email");
		String userNo = MapUtils.getString(rqstMap, "ad_user_no");

		if (StringUtils.isEmpty(phoneNum)||StringUtils.isEmpty(userEmail)) {
			jsonMap.put("reason", "invalidVal");
			return ResponseUtil.responseJson(mv, false, jsonMap);
		}

		HashMap<String, Object> param = new HashMap();
		param.put("MBTLNUM", phoneNum);
		param.put("EMAIL", userEmail);
		param.put("USER_NO", userNo);

		// 휴대전화번호 중복 조회
		int duplPhonNumCnt = userService.findDuplGnrlUserMbtlNum(param);
		if (duplPhonNumCnt>0) {
			jsonMap.put("reason", "duplPhonNum");
			return ResponseUtil.responseJson(mv, false, jsonMap);
		}
		// 이메일 전체 중복조회
		// int duplEmailCnt = userService.findDuplUserEmail(param);
		
		// 이메일 중복 조회
		int duplEmailCnt = userService.findDuplGnrlEmail(param);
		if (duplEmailCnt>0) {
			jsonMap.put("reason", "duplEmail");
			return ResponseUtil.responseJson(mv, false, jsonMap);
		}
		
		return ResponseUtil.responseJson(mv, true);
	}
	
	/**
	 * 기업사용자 휴대폰번호, 이메일 중복 조회
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView checkDuplEntUserInfo(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map jsonMap = new HashMap();
		
		String phoneNum = MapUtils.getString(rqstMap, "ad_phone_num");
		String userEmail = MapUtils.getString(rqstMap, "ad_user_email");
		String userNo = MapUtils.getString(rqstMap, "ad_user_no");

		if (StringUtils.isEmpty(phoneNum)||StringUtils.isEmpty(userEmail)) {
			jsonMap.put("reason", "invalidVal");
			return ResponseUtil.responseJson(mv, false, jsonMap);
		}

		HashMap<String, Object> param = new HashMap();
		param.put("MBTLNUM", phoneNum);
		param.put("EMAIL", userEmail);
		param.put("USER_NO", userNo);

		// 휴대전화번호 중복 조회
		int duplPhonNumCnt = userService.findDuplEntUserMbtlNum(param);
		if (duplPhonNumCnt>0) {
			jsonMap.put("reason", "duplPhonNum");
			return ResponseUtil.responseJson(mv, false, jsonMap);
		}
		
		// 이메일 전체 중복 조회
		// int duplEmailCnt = userService.findDuplUserEmail(param);
		
		// 이메일 중복 조회
		int duplEmailCnt = userService.findDuplEntEmail(param);
		
		if (duplEmailCnt>0) {
			jsonMap.put("reason", "duplEmail");
			return ResponseUtil.responseJson(mv, false, jsonMap);
		}
		
		return ResponseUtil.responseJson(mv, true);
	}
	
	/**
	 * 아이디 유효성 확인
	 * @param String 아이디
	 * @return Map 아이디 유효채크 결과
	 * @throws Exception
	 */
	private Map<String,Object> validateId(String userId) {
		// 알파벳 또는 숫자
		String alphanumeric = "^\\w+$";
		// 첫문자는 알파벳
		String firstAlpha	= "^[a-z]\\w*";
		// 최소 영문 2글자 이상 포함
		String includeAlphaAtLeast2 = "^[a-z]\\w*[a-z]+\\w*$";
		// 8자 이상 20자 이하
		String len = "^\\w{8,20}$";
		
		Map<String,Object> result = new HashMap<String,Object>();
		result.put("result", true);
		
		String type = "아이디";
		
		if(!matched(alphanumeric,userId)) {
			result.put("result", false);
			result.put("message", messageSource.getMessage("errors.alphanumeric", new String[] {type}, locale));
			return result;
		}		
		if(!matched(firstAlpha,userId)) {
			result.put("result", false);
			result.put("message", messageSource.getMessage("errors.validate05", new String[] {type}, locale));
			return result;
		}
		if(!matched(includeAlphaAtLeast2,userId)) {
			result.put("result", false);
			result.put("message", messageSource.getMessage("errors.validate06", new String[] {type}, locale));
			return result;
		}
		if(!matched(len,userId)) {
			result.put("result", false);
			result.put("message", messageSource.getMessage("errors.validate01", new String[] {type, "8", "20"}, locale));
			return result;
		}
		
		return result;
	}
	
	/**
	 * 패스워드 유효성 확인
	 * @param String 패스워드
	 * @return Map 패스워드 유효채크 결과
	 * @throws Exception
	 */
	private Map<String,Object> validatePw(String userId, String userPw, String confPw) {
		// 3자 이상 연속된 숫자(오름,내림)
		String noDigitsIncOrDec = ".*(012|123|234|345|456|567|678|789|987|876|765|654|543|432|321|210).*";
		// 3자 이상 연속된 영문(오름)
		String noAlphaInc = ".*(abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mno|nop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz).*";
		// 3자 이상 연속된 영문(내림)
		String noAlphaDec = ".*(zyx|yxw|xwv|wvu|vut|uts|tsr|srq|rqp|qpo|pon|onm|nml|mlk|lkj|kji|jih|ihg|hgf|gfe|fed|edc|dcb|cba).*";
		
		// 3자 이상 동일한 숫자
		String noIdenticalNum = ".*(0{3,}|1{3,}|2{3,}|3{3,}|4{3,}|5{3,}|6{3,}|7{3,}|8{3,}|9{3,}).*";
		// 3자 이상 동일한 영문
		String noIdenticalWord = ".*(a{3,}|b{3,}|c{3,}|d{3,}|e{3,}|f{3,}|g{3,}|h{3,}|i{3,}|j{3,}|k{3,}|l{3,}|m{3,}|n{3,}|o{3,}|p{3,}|q{3,}|r{3,}|s{3,}|t{3,}|u{3,}|v{3,}|w{3,}|x{3,}|y{3,}|z{3,}).*";			
		
		// 사용할 수 없는 특수 문자
		String noRefusedSpeChar = ".*(&lt|<|&gt|>|\\(|\\)|#|&apos|\\'|\\/|\\|).*";
		// 사용할 수 없는 단어
		String noRefusedWord = ".*(love|happy|qwer|asdf|zxcv|test|hpe).*";
		
		// 8자 이상 20자 이하
		String len = "^.{8,20}$";
		
		
		Map<String,Object> result = new HashMap<String,Object>();
		result.put("result", true);
		
		String type = "비밀번호";
		
		if(!userPw.equals(confPw)) {
			result.put("result", false);
			result.put("message", messageSource.getMessage("errors.confirmpassword", new String[] {}, locale));
			return result;
		}
		
		if(matched(noDigitsIncOrDec,userPw)||matched(noAlphaInc,userPw)||matched(noAlphaDec,userPw)) {
			result.put("result", false);
			result.put("message", messageSource.getMessage("errors.validate03", new String[] {type, "3"}, locale));
			return result;
		}
		
		if(matched(noIdenticalNum,userPw)||matched(noIdenticalWord,userPw)) {
			result.put("result", false);
			result.put("message", messageSource.getMessage("errors.validate04", new String[] {type, "3"}, locale));
			return result;
		}
		
		if(matched(noRefusedSpeChar,userPw)) {
			result.put("result", false);
			result.put("message", messageSource.getMessage("errors.validate07", new String[] {type, "3"}, locale));
			return result;
		}
		
		if(matched(noRefusedWord,userPw)) {
			result.put("result", false);
			result.put("message", messageSource.getMessage("errors.validate08", new String[] {type, "3"}, locale));
			return result;
		}
		
		// 비밀번호가 8자리 이상이면
		if(userPw.length() < 10) {
			Pattern p = Pattern.compile("([a-zA-Z0-9].*[!,@,$,%,^,&,*,?,_,~])|([!,@,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])");
			Matcher m = p.matcher(userPw);
			
			if(!m.find()) {
				result.put("result", false);
				result.put("message", messageSource.getMessage("errors.validate10", new String[] {type, "비밀번호"}, locale));
				return result;
			}
		}
		// 비밀번호가 10자리 이상이면
		else {
			Pattern p = Pattern.compile("([a-zA-Z0-9])|([!,@,$,%,^,&,*,?,_,~a-zA-Z]]) | ([!,@,$,%,^,&,*,?,_,~0-9])");
			Matcher m = p.matcher(userPw);
			
			if(!m.find()) {
				result.put("result", false);
				result.put("message", messageSource.getMessage("errors.validate10", new String[] {type, "비밀번호"}, locale));
				return result;
			}
		}
		
		int subStrLen = 3;
		int subStrEnd = 0;
		for(int i=0;i<userPw.length();i++){
			subStrEnd = i+subStrLen;			
			if(userPw.length() < subStrEnd){
				break;
			}
			
			String dupleWord = userPw.substring(i,subStrEnd);
			
			int idx = userId.indexOf(dupleWord);
			if(idx > -1){
				result.put("result", false);
				result.put("message", messageSource.getMessage("errors.validate09", new String[] {type, "아이디", "3"}, locale));
				return result;
			}
		}
		
		if(!matched(len,userPw)) {
			result.put("result", false);
			result.put("message", messageSource.getMessage("errors.validate01", new String[] {type, "8", "20"}, locale));
			return result;
		}
		
		return result;		
	}
	
	/**
	 * 정규식
	 * @param regex 정규식
	 * @param str 매칭할 스트링 
	 * @return boolean
	 * @throws Exception
	 */
	private boolean matched(String regex, String matStr) {
		return Pattern.matches(regex, matStr);
	}
	
	public ModelAndView freepass(Map<?, ?> rqstMap) throws Exception { // 임시
		//ModelAndView mv = new ModelAndView("/www/mb/BD_UIMBU0042");
		ModelAndView mv = new ModelAndView("/www/comm/logio/BD_UICMLOGIOU0042");
		System.out.println("freepass freepass freepass freepass freepass freepass freepass freepass freepass freepass ");
//		String certifyType = SessionUtil.getCertifyType();
		// FREE PASS
		return mv;
	}

}
