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
<title>내정보관리|기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery, colorbox, jqGrid, notice, css, validate" />
<ap:jsTag type="tech" items="font,cmn,mainn,subb, my, msg,util" />

<script type="text/javascript">
	$().ready(function() {

		var emailRecptnAgre = "${gnrInfo.emailRecptnAgre}"; // 이메일수신
		var smsRecptnAgre = "${gnrInfo.smsRecptnAgre}"; // SMS수신

		// 데이터가 없으면 생략
		if (emailRecptnAgre == "") {
			$("#emailRecptnAgreRow").hide();
		} else if (emailRecptnAgre == "Y") {
			$("#emailRecptnAgreTd").text("사용");
		} else if (emailRecptnAgre == "N") {
			$("#emailRecptnAgreTd").text("사용안함");
		}

		if (smsRecptnAgre == "") {
			$("#smsRecptnAgreRow").hide();
		} else if (smsRecptnAgre == "Y") {
			$("#smsRecptnAgreTd").text("사용");
		} else if (smsRecptnAgre == "N") {
			$("#smsRecptnAgreTd").text("사용안함");
		}

		// 수정
		$("#btn_gnrInfo_modify").click(function() {
			$("#df_method_nm").val("userUpdateForm");
			$("#dataForm").submit();

		});

		// 탈퇴
		$("#btn_user_withdrawal").click(function() {
			$("#df_method_nm").val("userWithdrawalForm");
			document.dataForm.submit();

		});
	});
</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<!--//content-->
		<div id="wrap">
			<div class="s_cont" id="s_cont">
				<div class="s_tit s_tit06">
					<h1>마이페이지</h1>
				</div>
				<div class="s_wrap">
					<div class="l_menu">
						<h2 class="tit tit6">마이페이지</h2>
						<ul>
						</ul>
					</div>
					<div class="r_sec">
						<div class="r_top">
							<ap:trail menuNo="${param.df_menu_no}" />
						</div>
						<div class="r_cont s_cont06_04">
							<div class="list_bl">
								<h4 class="fram_bl">로그인정보</h4>
								<table class="table_form">
									<caption>로그인정보</caption>
									<colgroup>
										<col width="172px">
										<col width="*">
									</colgroup>
									<tbody>
										<tr>
											<th class="p_l_30">아이디</th>
											<td class="b_l_0"><strong>${gnrInfo.loginId}</strong></td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="list_bl">
								<h4 class="fram_bl">개인정보</h4>
								<table class="table_form">
									<caption>기업정보</caption>
									<colgroup>
										<col width="172px">
										<col width="*">
									</colgroup>
									<tbody>
										<tr>
											<th class="p_l_30">이름</th>
											<td class="b_l_0">${gnrInfo.userNm}</td>
										</tr>
										<tr>
											<th class="p_l_30">휴대전화번호</th>
											<td class="b_l_0">${mbtlNum.first}-${mbtlNum.middle}-${mbtlNum.last}</td>
										</tr>
										<tr>
											<th class="p_l_30">이메일</th>
											<td class="b_l_0">${gnrInfo.email}</td>
										</tr>
										<tr id="emailRecptnAgreRow">
											<th class="p_l_30">이메일 수신</th>
											<td class="b_l_0" id="emailRecptnAgreTd">${gnrInfo.emailRecptnAgre}</td>
										</tr>
										<tr id="smsRecptnAgreRow">
											<th class="p_l_30">SMS 수신</th>
											<td class="b_l_0" id="smsRecptnAgreTd">${gnrInfo.smsRecptnAgre}</td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="btn_bl">
								<a href="#none" id="btn_user_withdrawal">회원탈퇴</a>
								<a href="#none" id="btn_gnrInfo_modify" class="blu">수정</a>
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