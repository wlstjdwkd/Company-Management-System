<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<title>error</title>
<ap:jsTag type="web" items="jquery,colorbox,notice,tools,ui" />
<ap:jsTag type="tech" items="util,ucm,etc" />
</head>
<body>
<div class="error">
	<div class="inner">
		<img src="/images/ucm/logo.png" alt="기업종합정보시스템" />
		<div class="con_box">
			<p>존재하지 않는 페이지거나<br>오류로 인하여 현재 페이지를 볼 수 없습니다.</p>
			<ul>
				<li><span style="font-size:13px;">이용에 불편을 드려서 죄송합니다. 잠시 후 다시 시도해 주십시오.<br>현재 서비스되는 페이지인지 다시 한번 확인 해 주시기 바랍니다.</span></li>
			</ul>
			<a href="/index.jsp"><img src="/images/etc/btn_home.png" alt="home" /></a>
		</div>
		<div class="text_copy"><img src="/images/etc/text_error_copy.png" alt="COPYRIGHT (C) TECHBLUEGENIC OF KOREA. ALL RIGHTS RESERVED." / ></div>
	</div>
</div>

</body>
</html>