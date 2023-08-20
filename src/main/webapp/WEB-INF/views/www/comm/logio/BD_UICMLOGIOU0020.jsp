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
<title>아이디찾기|기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery, colorbox, jqGrid, notice, css, validate" />
<ap:jsTag type="tech" items="cmn, mainn, subb, font, util" />
<script type="text/javascript">
	$(document).ready(function() {

		// 확인
		$("#btn_find_userId").click(function() {
			$("#df_method_nm").val("findUserIdForm");
			$("#dataForm").submit();
		});
	});
	
	/*
	* 검색단어 입력 후 엔터 시 자동 submit
	*/
	function press(event) {
		if (event.keyCode == 13) {
			$("#df_method_nm").val("findUserIdForm");
			$("#dataForm").submit();
		}
	}
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
					<ap:trail menuNo="${param.df_menu_no}" />
				</div>
				<div class="r_cont s_cont07_02">
					<div class="member_box">
						<img src="/images2/sub/member/finde_id_ico.png">
						<h3>회원 정보상의 이름과 이메일로 아이디를 찾으실 수 있습니다.</h3>
						<p class="list_noraml"><span>이름</span><input type="text" name="ad_user_nm" id="ad_user_nm" placeholder="이름을 입력하세요. "></p>
						<p class="list_noraml"><span>이메일</span><input type="text" name="ad_user_email" id="ad_user_email" placeholder="이메일을 입력하세요."></p>
					</div>
					<div class="btn_bl">
						<a href="#" id="btn_find_userId">확인</a>
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