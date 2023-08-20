<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,cookie,form,notice,ui,validate" />
<ap:jsTag type="tech" items="msg,util,cmn,font,mainn,subb,mb" />
<script type="text/javascript">
	$(document).ready(function() {

	});
</script>
</head>

<body>
	<form name="dataForm" id="dataForm" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:globalConst />
		<!--//content-->
		<div id="wrap">
			<div class="s_cont" id="s_cont">
				<div class="s_tit s_tit07">
					<h1>인사시스템</h1>
				</div>
				<div class="s_wrap">
					<div class="l_menu">
						<h2 class="tit tit7">인사시스템</h2>
						<ul>
						</ul>
					</div>
					<div class="r_sec">
						<div class="r_top">
							<ap:trail menuNo="${param.df_menu_no}"  />
						</div>
						<div class="r_cont s_cont07_01">
							<div class="member_box s_member_box">
								<img src="/images2/sub/seces_ico.png">
								<h3>서비스 이용에 감사 드리며, 오늘도 좋은 하루 보내세요.</h3>
							</div>
							<div class="btn_bl">
								<a href="<c:url value='${PUB_INDEX_URL}' />" class="blu">홈</a>
								<a href="#none" onclick="${PUB_LOGIN_URL}">로그인</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!--content//-->


	</form>

</body>
</html>