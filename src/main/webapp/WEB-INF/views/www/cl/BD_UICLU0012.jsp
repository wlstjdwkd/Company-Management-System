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
<title>이메일자동수집거부|정보</title>
<!-- <script src="../../js/jquery-1.11.1.min.js" type="text/javascript"></script>
<script src="../../js/ucm.js" type="text/javascript"></script> -->

<ap:jsTag type="web" items="jquery,form,validate" />
<ap:jsTag type="tech" items="cmn, mainn, subb, font, util" />

<script type="text/javascript">
	$(document).ready(function() {

	});
</script>
</head>

<body>
	<form name="dataForm" id="dataForm" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<!--//content-->
		<div id="wrap">
		<div class="s_cont" id="s_cont">
		<div class="s_tit s_tit08">
			<h1>약관</h1>
		</div>
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit tit8">약관</h2>
				<ul>
				</ul>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}" />
				</div>
				<div class="r_cont">
					<div class="terms_wrap" style="border-bottom: 0;">
						<div>
							<div class="img_text">
								<img src="/images2/sub/terms/terms_email_img01.png">
								<p>본 웹사이트에 게시된 이메일 주소가 전자우편 수집 프로그램이나<br/>그 밖의 기술적 장치를 이용하여 <span>무단으로 수집되는 것을 거부</span>하며, <br/>이를 위반 시 정보통신망법에 의해 <span>형사 처벌</span>됨을 유념하시기 바랍니다.</p>
							</div>
							<h4>정보통신망 이용촉진 및 정보보호 등에 관한 법률 제50조의2 (전자우편주소의 무단 수집행위 등 금지)</h4>
							<ul class="terms_dot">
								<li>누구든지 인터넷 홈페이지 운영자 또는 관리자의 사전 동의 없이 인터넷 홈페이지에서 자동으로 전자우편주소 를 수집하는 프로그램이나 <br/>그 밖의 기술적 장치를 이용하여 전자우편주소를 수집하여서는 아니 된다.</li>
								<li>누구든지 제1항을 위반하여 수집된 전자우편주소를 판매ㆍ유통하여서는 아니 된다.</li>
								<li>누구든지 제1항과 제2항에 따라 수집 · 판매 및 유통이 금지된 전자우편주소임을 알면서 이를 정보 전송에 이용 하여서는 아니 된다.</li>
							</ul>
						</div>
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