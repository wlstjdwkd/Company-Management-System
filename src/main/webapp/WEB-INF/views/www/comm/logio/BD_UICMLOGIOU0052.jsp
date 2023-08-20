<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>정보변경신청|기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery, colorbox, jqGrid, notice, css, validate" />
<ap:jsTag type="tech" items="font,cmn,mainn,subb,msg,util" />
<script type="text/javascript">
	
</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<!--//content-->
		<div id="wrap">
			<div class="s_cont" id="s_cont">
				<div class="s_tit s_tit07">
					<h1>회원서비스</h1>
				</div>
				<div class="s_wrap">
					<div class="l_menu">
						<h2 class="tit tit7">회원서비스</h2>
						<ul>
						</ul>
					</div>
					<div class="r_sec">
						<div class="r_top">
							<ap:trail menuNo="${param.df_menu_no}"  />
						</div>
						<div class="r_cont s_cont07_09">
							<div class="list_bl">
								<h4 class="fram_bl">기업정보찾기</h4>
								<p class="resultGuide" style="margin:0 auto;">기업정보 찾기 결과 입니다.</p>
								<div class="member_box">
									<img src="/images2/sub/member/cor_info_noresult_ico.png">
									<h3>입력하신 정보와 일치하는 기업정보가 없습니다.</h3>
								</div>
							</div>
							
							<div class="btn_bl">
								<a href="#none" onclick="${PUB_JOIN_URL}" class="blu">시스템 회원가입</a>
								<a href="#none" onclick="${PUB_FINDUSERINFO_URL}">아이디 찾기</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>