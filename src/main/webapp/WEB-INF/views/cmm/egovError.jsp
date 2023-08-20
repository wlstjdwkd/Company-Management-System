<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rte.fdl.property.EgovPropertyService" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<title>biz error</title>
<ap:jsTag type="web" items="jquery,colorbox,notice,tools,ui" />
<ap:jsTag type="tech" items="util,ucm,etc" />
</head>
<body>
<div class="error">
	<div class="inner">
		<img src="/images/ucm/logo.png" alt="기업종합정보시스템" />
		<div class="con_box">
			<p>서비스 이용에 불편을 드려 죄송합니다.</p>
			<ul>
				<li>${exception.message}</li>
				<li>요청하신 서비스가 정상처리되지 않았습니다. 잠시 후 이용해 주시기바랍니다.</li>
				<li><span>문의사항은 <strong>담당자</strong>에게 연락주십시오.<span></li>
<%
	WebApplicationContext  ctx = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
	EgovPropertyService eps = (EgovPropertyService) ctx.getBean("propertiesService");
	if (!eps.getBoolean("productMode")) {
		out.println("				<li><span>");
		if ( request.getAttribute("exception") != null ) {
		    Exception e =(Exception)request.getAttribute("exception");
		    out.println( "<pre>" + org.apache.commons.lang3.exception.ExceptionUtils.getStackTrace(e) + "</pre>" );
		} else	if ( request.getAttribute("javax.servlet.error.message") != null) {
	        out.println( request.getAttribute("javax.servlet.error.message"));
	    }
		out.println("				</span></li>");
	}
%>
			</ul>
			<a href="/index.jsp"><img src="/images/etc/btn_home.png" alt="home" /></a>
		</div>
		<div class="text_copy"><img src="/images/etc/text_error_copy.png" alt="COPYRIGHT (C) TECHBLUEGENIC OF KOREA. ALL RIGHTS RESERVED." / ></div>
	</div>
</div>

</body>
</html>