package com.infra.web;

import java.io.PrintWriter;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.comm.program.ProgramService;
import com.comm.user.UserService;
import com.comm.user.UserVO;
import com.infra.system.GlobalConst;
import com.infra.util.SessionUtil;
import com.infra.util.Validate;
import com.infra.util.crypto.Aes256;
import com.infra.aop.CheckAuthorityInterceptor;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.NoSuchBeanDefinitionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.CacheManager;
import org.springframework.context.ApplicationContext;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.exception.EgovBizException;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.bind.annotation.CommandMap;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ServiceController {
	private static final Logger logger = LoggerFactory.getLogger(ServiceController.class);

	private Locale locale = Locale.getDefault();

	@Resource(name = "messageSource")
	private MessageSource messageSource;

	@Autowired
	private ProgramService programService;

	@Autowired
	UserService userService;

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

    @Autowired
    private CacheManager cacheManager;      // autowire cache manager


	@RequestMapping(value = "/{pgmId}.do")
	public ModelAndView execute(HttpServletRequest request, @CommandMap Map<String, Object> rqstMap,
			@PathVariable String pgmId,
			@RequestParam(value="df_method_nm", required = true, defaultValue = "index") String method) throws Throwable {

		logger.debug("====================================== Service Invocation Information ======================================");
		logger.debug("| Program ID : " + pgmId);
		logger.debug("| Method Name : " + method);
		logger.debug("| parameter information");
		logger.debug("| " + rqstMap.toString());
		logger.debug("==================================================================================================");

		ModelAndView mv = null;
		boolean isSucc = false;

		try {
			if (StringUtils.isEmpty(pgmId)) {
				throw new EgovBizException(messageSource.getMessage("errors.required", new String[] {"서비스ID"}, locale));
			}

			HashMap param = new HashMap();
			param.put("progrmId", pgmId);

			Map program = programService.findProgram(param);
			if (MapUtils.isEmpty(program)) {
				throw new EgovBizException(messageSource.getMessage("errors.invalid.progrm", new String[] {pgmId}, locale));
			}

			// 업로드 파일이 존재하면
			if (request.getContentType() != null && request.getContentType().startsWith("multipart/form-data")) {
				MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest) request;
				rqstMap.put(GlobalConst.RQST_MULTIPART, mptRequest);
			}

			if(logger.isDebugEnabled())
			{
				logger.debug("program info ===>"+program.toString());
			}
			// 업무서비스이면 해당 빈 호출
			if (program.get("svcAt").equals("Y")) {
				Method mthd = null;
				ServletContext svlCtx = request.getSession().getServletContext();
				ApplicationContext appCtx = WebApplicationContextUtils.getRequiredWebApplicationContext(svlCtx);

				Object instance = appCtx.getBean(pgmId);
				mthd = instance.getClass().getDeclaredMethod(method, java.util.Map.class);
				mv = (ModelAndView) mthd.invoke(instance, rqstMap);
			} else {
				// 단순 JSP이면 Forward 처리
				mv = new ModelAndView((String) program.get("viewFilePath"));
			}

//			//결재대상 카운트 , 알림 로직 =========================================================================================
//			String loginId = MapUtils.getString(rqstMap, "ad_user_id");
//			HashMap<String, Object> userParam = new HashMap<>();
//			UserVO userVo = null;
//			if(Validate.isNotEmpty(loginId)) {
//				userParam.put("loginId", loginId);
//				//로그인 아이디 있을시 사용자 조회
//				userVo = userService.findUser(userParam);
//			}else {
//				userVo = SessionUtil.getUserInfo();
//			}
//
//			if(Validate.isNotEmpty(userVo)) {
//				userParam.put("userNo", userVo.getUserNo());
//
//				//나의 대체결재자가 존재할떄
//				Map myAltrtvConfrmer = userService.findMyAltrtvConfrmer(userParam);
//				//내가 다른사람의 대체결재자일떄
//				List<Map> altrtvConfrmerList = userService.findAltrtvConfrmerList(userParam);
//
//				int confirmWaitCnt = 0;
//				List<Map> notiList = new ArrayList<>();
//				//내 대체결재자가 존재하지 않을떄 - 나한테 알람띄움
//				if(Validate.isEmpty(myAltrtvConfrmer)) {
//					//접수승인관련 승인대기상태 카운트
//					confirmWaitCnt = userService.findConfirmWaitStatusCnt(userParam);
//					//알림 조회
//					notiList = userService.findNotificationList(userParam);
//				}
//				//내가 누군가의 대체결재자일떄 - 다른사람 정보 가져옴
//				if(Validate.isNotEmpty(altrtvConfrmerList)) {
//					for(Map item:altrtvConfrmerList) {
//						userParam.put("userNo", MapUtils.getString(item, "CONFMER_ID"));	//내가 대체결재할 사람
//						int cnt = userService.findConfirmWaitStatusCnt(userParam);			//승인대기 카운트
//						confirmWaitCnt += cnt;
//						//알림 조회
//						notiList.addAll(userService.findNotificationList(userParam));
//					}
//				}
//				userVo.setConfirmWaitCnt(confirmWaitCnt);
//				userVo.setNotificationList(notiList);
//				// 사용자정보 세션설정
//				SessionUtil.setUserInfo(userVo);
//			}
//			//결재대상 카운트 , 알림 로직 =========================================================================================

			isSucc = true; // 서비스 수행 성공
		} catch (NoSuchBeanDefinitionException e) {
			logger.error(messageSource.getMessage("errors.invalid.service", new String[] {pgmId,method}, locale), e);
			throw new NoSuchBeanDefinitionException(messageSource.getMessage("errors.invalid.service", new String[] {pgmId,method}, locale));
		} catch (NoSuchMethodException e) {
			logger.error(messageSource.getMessage("errors.invalid.service", new String[] {pgmId,method}, locale), e);
			throw new NoSuchMethodException(messageSource.getMessage("errors.invalid.service", new String[] {pgmId,method}, locale));
		} catch (InvocationTargetException e) {
			logger.error("", e);

			Throwable sc = e.getCause();
			if (sc != null && sc instanceof EgovBizException) {
				throw sc;
			}

			throw e;
		} catch (Exception e) {
			logger.error("", e);
			throw new RuntimeException(messageSource.getMessage("fail.common.fail", null, locale));
		} finally {
			logger.debug("======================================== Service Response Details ========================================");
			if (isSucc) {
				logger.debug("| " + pgmId + "." + method);
				logger.debug("| model and view information");
				logger.debug("| View Name : " + mv.getViewName());
				logger.debug("| Model Objects : " + mv.getModelMap().toString());
			} else {
				logger.debug("| " + pgmId + "." + method + " throws exception.");
			}
			logger.debug("==================================================================================================");
		}

		return mv;
	}

	/**
	 * SQL 재로딩 처리(TODO 개발용, 운영환경 이행 시 삭제)
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value="/reload.do")
	public void reload(HttpServletRequest request, HttpServletResponse response) throws RuntimeException, Exception {
		HashMap ipParam = new HashMap();

		// 관리자 접근IP 제한모드가 설정되어 있으면
		if (propertiesService.getBoolean("restrictAdminIP", true)) {
			if (Validate.isNotEmpty(request.getRemoteAddr())) {
				ipParam.put("ip",  request.getRemoteAddr());
			} else {
				ipParam.put("ip",  request.getHeader("X-FORWARDED-FOR"));
			}

			if (!userService.validateIPAddress(ipParam)) throw new EgovBizException("errors.invalid.access.admin");
		}

		// refresh mybatis sql files
		com.infra.dev.Notifier.getInstance().order();

		PrintWriter pw = response.getWriter();
		pw.println("<?xml version='1.0' encoding='UTF-8'?><body>MyBatis SQL Files reloaded...</body>");
		pw.close();
	}

	/**
	 * SQL 재로딩 처리(TODO 개발용, 운영환경 이행 시 삭제)
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value="/clearCache.do")
	public void clearCache(HttpServletRequest request, HttpServletResponse response) throws RuntimeException, Exception {
		HashMap ipParam = new HashMap();

		// 관리자 접근IP 제한모드가 설정되어 있으면
		if (propertiesService.getBoolean("restrictAdminIP", true)) {
			if (Validate.isNotEmpty(request.getRemoteAddr())) {
				ipParam.put("ip",  request.getRemoteAddr());
			} else {
				ipParam.put("ip",  request.getHeader("X-FORWARDED-FOR"));
			}

			if (!userService.validateIPAddress(ipParam)) throw new EgovBizException("errors.invalid.access.admin");
		}

		// refresh mybatis sql files
		for(String name:cacheManager.getCacheNames()){
            cacheManager.getCache(name).clear();            // clear cache by name
        }

		PrintWriter pw = response.getWriter();
		pw.println("<?xml version='1.0' encoding='UTF-8'?><body>Cash Clear...</body>");
		pw.close();
	}
}
