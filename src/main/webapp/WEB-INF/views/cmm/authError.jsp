<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<title>access error</title>
<ap:jsTag type="web" items="jquery,colorbox,notice,tools,ui" />
<ap:jsTag type="tech" items="util,ucm,etc" />
</head>
<body>
<div class="error">
	<div class="inner">
		<img src="/images/ucm/logo.png" alt="기업종합정보시스템" />
		<div class="con_box">
			<p><span>${exception.message}</span></p>
			<ul>
				<li>${exception.message}<br />페이지 이용권한 여부를 담당자에게 확인하시고, 다시 시도해 주세요.</li>
				<li><span>문의사항은 <strong>담당자</strong>에게 연락주십시오.</span></li>
			</ul>
			<a href="/index.jsp"><img src="/images/etc/btn_home.png" alt="home" /></a>
		</div>
		<div class="text_copy"><img src="/images/etc/text_error_copy.png" alt="COPYRIGHT (C) TECHBLUEGENIC OF KOREA. ALL RIGHTS RESERVED." / ></div>
	</div>
</div>

</body>
</html>
