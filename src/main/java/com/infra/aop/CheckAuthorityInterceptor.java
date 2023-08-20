package com.infra.aop;

import java.io.IOException;
import java.util.Iterator;
import java.util.Set;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.comm.user.AuthorityVO;
import com.comm.user.UserVO;
import com.infra.system.GlobalConst;
import com.infra.util.SessionUtil;
import biz.tech.um.PGUM0001Service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import egovframework.com.cmm.EgovMessageSource;

public class CheckAuthorityInterceptor extends HandlerInterceptorAdapter {

	private static final Logger logger = LoggerFactory.getLogger(CheckAuthorityInterceptor.class);

	private Set<String> exclude; // 검증예외 URL

	@Resource(name = "egovMessageSource")
	private EgovMessageSource messageService;

	@Autowired
	PGUM0001Service pgum0001;

	/**
	 * 권한체크
	 */
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws RuntimeException, Exception {

		try {
			if (request.getRequestURI().indexOf(".api") > 0)
			{
				return this.apiPreHandler(request, response, handler);
			}

			// Site 첫 접속이면, Anonymous권한으로 세션 설정
			if (SessionUtil.getMenuInfo() == null && SessionUtil.getAuthInfo() == null) {
				pgum0001.setAnonymousInfo();
			}

			String requestURI = request.getRequestURI(); // 요청 URI

			String ctxPath = request.getContextPath();
			String method = request.getParameter("df_method_nm");

			if (StringUtils.isEmpty(method)) method = "index";
			if (StringUtils.isEmpty(ctxPath)) ctxPath = "/";

			//String tailStr;
			int idx = requestURI.indexOf(".do");
			if (idx < 0) 	idx = requestURI.indexOf(".jsp");

			String pgmId = requestURI.substring(ctxPath.length(), idx);

			logger.debug("requestURI ===> " + requestURI);
			logger.debug("method ===> " + method);
			logger.debug("pgmId ===> " + pgmId);

			// 검증예외 PGM ID이면 return true;
			for (Iterator<String> it = this.exclude.iterator(); it.hasNext();) {
				String exPgm =  (String) it.next();
				logger.debug("###### exPgm ===> " + exPgm);
				if (Pattern.matches(exPgm, pgmId)) {
					request.setAttribute(GlobalConst.SVC_URL_NAME, request.getContextPath() + "/" + pgmId + ".do");
					return true;
				}
			}

			AuthorityVO authVo = SessionUtil.getAuthInfo(pgmId);
			UserVO userVo = SessionUtil.getUserInfo();
			// 권한없는 메뉴 접속 시 로그인 여부체크
			if (authVo == null) {
				if (userVo == null) throw new NoMemberException(messageService.getMessage("errors.author.access"));
				else throw new AuthorityException(messageService.getMessage("errors.author.access"));
			}

			if (method.startsWith("insert") || method.startsWith("update")) {
				if (authVo.getStreAt().equals("N")) {
					if (userVo == null) throw new NoMemberException(messageService.getMessage("errors.author.store"));
					else throw new AuthorityException(messageService.getMessage("errors.author.store"));
				}
			} else if (method.startsWith("delete")) {
				if (authVo.getDeleteAt().equals("N")) {
					if (userVo == null) throw new NoMemberException(messageService.getMessage("errors.author.delete"));
					else throw new AuthorityException(messageService.getMessage("errors.author.delete"));
				}
			} else if (method.startsWith("process")) {
				if (authVo.getInqireAt().equals("N") || authVo.getStreAt().equals("N") || authVo.getDeleteAt().equals("N")) {
					if (userVo == null) throw new NoMemberException(messageService.getMessage("errors.author.process"));
					else throw new AuthorityException(messageService.getMessage("errors.author.process"));
				}
			} else if (method.startsWith("excel")) {
				if (authVo.getExcelAt().equals("N")) {
					if (userVo == null) throw new NoMemberException(messageService.getMessage("errors.author.excel"));
					else throw new AuthorityException(messageService.getMessage("errors.author.excel"));
				}
			} else if (method.startsWith("print")) {
				if (authVo.getPrntngAt().equals("N")) {
					if (userVo == null) throw new NoMemberException(messageService.getMessage("errors.author.print"));
					else throw new AuthorityException(messageService.getMessage("errors.author.print"));
				}
			} else {
				if (authVo.getInqireAt().equals("N")) {
					if (userVo == null) throw new NoMemberException(messageService.getMessage("errors.author.inquire"));
					else throw new AuthorityException(messageService.getMessage("errors.author.inquire"));
				}
			}

			request.setAttribute(GlobalConst.SVC_URL_NAME, request.getContextPath() + "/" + pgmId + ".do");

		} catch (IOException e) {
			logger.error("", e);
			throw e;
		} catch (Exception e) {
			logger.error("", e);
			throw e;
		}

		return true;
	}

	public boolean apiPreHandler(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws RuntimeException, Exception {

		try {

			// Site 첫 접속이면, Anonymous권한으로 세션 설정
			if (SessionUtil.getMenuInfo() == null && SessionUtil.getAuthInfo() == null) {
				pgum0001.setAnonymousInfo();
			}

			String requestURI = request.getRequestURI(); // 요청 URI
			String ctxPath = request.getContextPath();
			String method = request.getParameter("df_method_nm");

			if (StringUtils.isEmpty(method)) method = "index";
			if (StringUtils.isEmpty(ctxPath)) ctxPath = "/";

			String tailStr;
			int idx = requestURI.indexOf(".api");
			String pgmId = requestURI.substring(ctxPath.length(), idx);

			logger.debug("requestURI ===> " + requestURI);
			logger.debug("method ===> " + method);
			logger.debug("pgmId ===> " + pgmId);

			// 검증예외 PGM ID이면 return true;
			for (Iterator<String> it = this.exclude.iterator(); it.hasNext();) {
				String exPgm =  (String) it.next();
				logger.debug("###### exPgm ===> " + exPgm);
				if (Pattern.matches(exPgm, pgmId)) {
					request.setAttribute(GlobalConst.SVC_URL_NAME, request.getContextPath() + "/" + pgmId + ".api");
					return true;
				}
			}

			AuthorityVO authVo = SessionUtil.getAuthInfo(pgmId);
			UserVO userVo = SessionUtil.getUserInfo();
			// 권한없는 메뉴 접속 시 로그인 여부체크
			if (authVo == null) {
				if (userVo == null) throw new NoMemberException(messageService.getMessage("errors.author.access"));
				else throw new AuthorityException(messageService.getMessage("errors.author.access"));
			}

			if (method.startsWith("insert") || method.startsWith("update")) {
				if (authVo.getStreAt().equals("N")) {
					if (userVo == null) throw new NoMemberException(messageService.getMessage("errors.author.store"));
					else throw new AuthorityException(messageService.getMessage("errors.author.store"));
				}
			} else if (method.startsWith("delete")) {
				if (authVo.getDeleteAt().equals("N")) {
					if (userVo == null) throw new NoMemberException(messageService.getMessage("errors.author.delete"));
					else throw new AuthorityException(messageService.getMessage("errors.author.delete"));
				}
			} else if (method.startsWith("process")) {
				if (authVo.getInqireAt().equals("N") || authVo.getStreAt().equals("N") || authVo.getDeleteAt().equals("N")) {
					if (userVo == null) throw new NoMemberException(messageService.getMessage("errors.author.process"));
					else throw new AuthorityException(messageService.getMessage("errors.author.process"));
				}
			} else if (method.startsWith("excel")) {
				if (authVo.getExcelAt().equals("N")) {
					if (userVo == null) throw new NoMemberException(messageService.getMessage("errors.author.excel"));
					else throw new AuthorityException(messageService.getMessage("errors.author.excel"));
				}
			} else if (method.startsWith("print")) {
				if (authVo.getPrntngAt().equals("N")) {
					if (userVo == null) throw new NoMemberException(messageService.getMessage("errors.author.print"));
					else throw new AuthorityException(messageService.getMessage("errors.author.print"));
				}
			} else {
				if (authVo.getInqireAt().equals("N")) {
					if (userVo == null) throw new NoMemberException(messageService.getMessage("errors.author.inquire"));
					else throw new AuthorityException(messageService.getMessage("errors.author.inquire"));
				}
			}

			request.setAttribute(GlobalConst.SVC_URL_NAME, request.getContextPath() + "/" + pgmId + ".api");

		} catch (IOException e) {
			logger.error("", e);
			throw e;
		} catch (Exception e) {
			logger.error("", e);
			throw e;
		}

		return true;
	}

	/**
	 * 검증예외 URL 설정
	 *
	 * @param exclude
	 *            Set of excludes
	 */
	public void setExclude(Set<String> exclude) {
		this.exclude = exclude;
	}
}
