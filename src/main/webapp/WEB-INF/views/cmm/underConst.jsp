<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>시스템점검 안내</title>
<ap:jsTag type="web" items="jquery,colorbox,notice,tools,ui" />
<ap:jsTag type="tech" items="util,ucm,etc" />
</head>
<body>
<div class="site_check">
	<div class="inner">
		<img src="/images/ucm/logo.png" alt="정보" />
		<div class="con_box">
			<div class="box">
				<p class="img_zone">기업 정보 점검 안내</p>
				<ul>
					<li>안녕하세요. 기업 정보 입니다.</li>
					<li>다음의 내용으로 시스템 점검 중이오니 서비스 이용에 참고하시기 바랍니다.</li>
					<li>
						<ol>
							<li>내용 : 시스템 점검 작업으로 인한 서비스 이용 불가</li>
						</ol>
					</li>
					<li>더욱 안정적인 서비스를 제공하기 위함이오니 양해 부탁 드립니다.</li>
					<li>감사합니다.</li>
					<li class="mgt12"><a href="/index.jsp"><img src="/images/etc/btn_home.png" alt="home" /></a></li>
				</ul>
			</div>
		</div>
		<div class="text_copy"><img src="/images/etc/text_error_copy.png" alt="COPYRIGHT (C) TECHBLUEGENIC OF KOREA. ALL RIGHTS RESERVED." /></div>
	</div>
</div>
</body>
</html>