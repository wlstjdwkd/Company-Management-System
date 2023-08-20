package com.infra.filter;

import java.io.IOException;
import java.util.HashMap;
import java.util.StringTokenizer;
import java.util.regex.Pattern;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.comm.mon.PGCMMON0142Service;
import com.comm.user.UserVO;
import com.infra.system.GlobalConst;
import com.infra.util.DateUtil;
import com.infra.util.Validate;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

public class RequestLogFilter implements Filter {

	private static final Logger logger = LoggerFactory.getLogger(RequestLogFilter.class);

	private FilterConfig config;

	@Override
	public void destroy() {
	}

	@Override
	public void doFilter(ServletRequest svlReq, ServletResponse svlResp, FilterChain fc) throws IOException,
			ServletException {

		HttpServletRequest request = (HttpServletRequest) svlReq;

		String requestURI = request.getRequestURI(); // 요청 URI
		String ctxPath = request.getContextPath();
		String method = request.getParameter("df_method_nm");

		if (Validate.isEmpty(method)) method = "index";
		if (Validate.isEmpty(ctxPath)) ctxPath = "/";

		if(logger.isDebugEnabled())
		{
			logger.debug("| requestURI : " + requestURI);
		}


		int idx = requestURI.indexOf(".do");
		if (idx < 0) 	idx = requestURI.indexOf(".jsp");

		String pgmId = requestURI.substring(ctxPath.length(), idx);

		// 로깅예외 PGM ID이면 return;
		StringTokenizer strTkn = new StringTokenizer(config.getInitParameter("exclude"));

		while(strTkn.hasMoreElements()) {
			String exPgm = (String) strTkn.nextElement();
			if (Pattern.matches(exPgm, pgmId)) {
				fc.doFilter(svlReq, svlResp);
				return;
			}
		}

		HashMap<String, Object> param = new HashMap<>();

		param.put("pgmId", pgmId);
		param.put("methodNm", method);

		// 처리구분
		if (method.startsWith("insert")) {
			param.put("processDiv",  "02");
		} else if (method.startsWith("update")) {
			param.put("processDiv",  "03");
		} else if (method.startsWith("delete")) {
			param.put("processDiv",  "04");
		} else if (method.startsWith("process")) {
			param.put("processDiv",  "05");
		} else {
			param.put("processDiv",  "01");
		}

		// 사용자번호 - 사용자 번호가 없으면 '0' 값을 넣기
		HttpSession session = request.getSession();
		UserVO userVo = (UserVO) session.getAttribute(GlobalConst.SESSION_USERINFO_NAME);
		if (userVo != null)
			param.put("rqesterNo",  userVo.getUserNo());
		else
			param.put("rqesterNo",  "0");

		// 사용자IP
		if (Validate.isNotEmpty(request.getRemoteAddr())) {
			param.put("rqesterIp",  request.getRemoteAddr());
		} else {
			param.put("rqesterIp",  request.getHeader("X-FORWARDED-FOR"));
		}

		// 실행시작시각
		param.put("beginTm",  DateUtil.getTimeStamp());

		// ** 업무실행 ** //
		fc.doFilter(svlReq, svlResp);

		// 실행종료시각
		param.put("endTm",  DateUtil.getTimeStamp());

		ApplicationContext act = WebApplicationContextUtils.getRequiredWebApplicationContext(config.getServletContext());

		try {
			// 로그ID
			EgovIdGnrService idGnrService = (EgovIdGnrService) act.getBean("webRequestLogIdGnrService");
			param.put("logId",  idGnrService.getNextStringId());

			// 로그 DB 기록
			PGCMMON0142Service pgcmmon0142Service = (PGCMMON0142Service) act.getBean("PGCMMON0142");
			pgcmmon0142Service.insertRequestLog(param);

		} catch (IOException e) {
			logger.error("요청로그 DB기록 실패: "+param, e);
		} catch (Exception e) {
			logger.error("요청로그 DB기록 실패: "+param, e);
		}

		return;
	}

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		config = filterConfig;
	}

}
