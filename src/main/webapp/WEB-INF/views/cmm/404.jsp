<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<title>404 error</title>
<ap:jsTag type="web" items="jquery,colorbox,notice,tools,ui" />
<ap:jsTag type="tech" items="util,ucm,etc" />
</head>
<body>
<div class="error">
	<div class="inner">
		<img src="/images/ucm/logo.png" alt="기업종합정보시스템" />
		<div class="con_box">
			<p>요청하신 페이지는 존재하지 않습니다.</p>
			<ul>
				<li>요청하신 페이지를 찾을 수 없습니다.<br />페이지 주소를 다시 확인해 주세요.</li>
				<li><span>감사합니다.</span></li>
			</ul>
			<a href="/index.jsp"><img src="/images/etc/btn_home.png" alt="home" /></a>
		</div>
		<div class="text_copy"><img src="/images/etc/text_error_copy.png" alt="COPYRIGHT (C) TECHBLUEGENIC OF KOREA. ALL RIGHTS RESERVED." / ></div>
	</div>
</div>

</body>
</html>