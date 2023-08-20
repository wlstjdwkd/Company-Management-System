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
<ap:jsTag type="tech" items="cmn, mainn, subb, font, my, msg,util" />

<script type="text/javascript">
	$(document).ready(
			function() {

				// 법인등록번호
				var jurirNo = "${entInfo.jurirNo}";
				var jurirNo_1 = jurirNo.substring(0, 6);
				var jurirNo_2 = jurirNo.substring(6, 13);
				$("#ad_jurirNoTd").text(jurirNo_1 + "-" + jurirNo_2)

				// 사업자등록번호
				var bizrNo = "${entInfo.bizrNo}";
				var bizrNo_1 = bizrNo.substring(0, 3);
				var bizrNo_2 = bizrNo.substring(3, 5);
				var bizrNo_3 = bizrNo.substring(5, 10);
				$("#ad_bizrNoTd").text(
						bizrNo_1 + "-" + bizrNo_2 + "-" + bizrNo_3);

				var adres = "${entInfo.hedofcAdres}"; // 주소
				var ofcps = "${entInfo.ofcps}"; // 직위
				var emailRecptnAgre = "${entInfo.emailRecptnAgre}"; // 이메일수신
				var smsRecptnAgre = "${entInfo.smsRecptnAgre}"; // SMS수신

				// 데이터가 없으면 생략
				if (adres == "" || adres == "  " || adres == " ") {
					$("#ad_adresRow").hide();
				}
				if ("${telNo.first}" == "" || "${telNo.middle}" == ""
						|| "${telNo.last}" == "") {
					$("#ad_telnoRow").hide();
				}
				if ("${telNo2.first}" == "" || "${telNo2.middle}" == ""
					|| "${telNo2.last}" == "") {
					$("#ad_telnoRow2").hide();
				}
				if ("${fxNum.first}" == "" || "${fxNum.middle}" == ""
						|| "${fxNum.last}" == "") {
					$("#ad_fxnumRow").hide();
				}
				if (ofcps == "") {
					$("#ad_ofcpsRow").hide();
				}
				if (emailRecptnAgre == "") {
					$("#ad_emailRecptnAgreRow").hide();
				} else if (emailRecptnAgre == "Y") {
					$("#ad_emailRecptnAgreTd").text("사용");
				} else if (emailRecptnAgre == "N") {
					$("#ad_emailRecptnAgreTd").text("사용안함");
				}

				if (smsRecptnAgre == "") {
					$("#ad_smsRecptnAgreRow").hide();
				} else if (smsRecptnAgre == "Y") {
					$("#ad_smsRecptnAgreTd").text("사용");
				} else if (smsRecptnAgre == "N") {
					$("#ad_smsRecptnAgreTd").text("사용안함");
				}

				
				var mngOfcps = "${manager.ofcps}"; // 직위
				var mngEmailRecptnAgre = "${manager.emailRecptnAgre}"; // 이메일수신
				var mngSmsRecptnAgre = "${manager.smsRecptnAgre}"; // SMS수신
				
				if ("${manager.telNo.first}" == "" || "${manager.telNo.middle}" == ""
					|| "${manager.telNo.last}" == "") {
					$("#ad_telnoRow3").hide();
				}
				if (mngOfcps == "") {
					$("#ad_ofcpsRow3").hide();
				}
				if (mngEmailRecptnAgre == "") {
					$("#ad_emailRecptnAgreRow3").hide();
				} else if (mngEmailRecptnAgre == "Y") {
					$("#ad_emailRecptnAgreTd3").text("사용");
				} else if (mngEmailRecptnAgre == "N") {
					$("#ad_emailRecptnAgreTd3").text("사용안함");
				}

				if (mngSmsRecptnAgre == "") {
					$("#ad_smsRecptnAgreRow3").hide();
				} else if (mngSmsRecptnAgre == "Y") {
					$("#ad_smsRecptnAgreTd3").text("사용");
				} else if (mngSmsRecptnAgre == "N") {
					$("#ad_smsRecptnAgreTd3").text("사용안함");
				}
				
				
				// 수정
				$("#btn_entInfo_modify").click(function() {
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
											<td class="b_l_0"><strong>${entInfo.loginId}</strong></td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="list_bl">
								<h4 class="fram_bl">기업정보</h4>
								<table class="table_form">
									<caption>기업정보</caption>
									<colgroup>
										<col width="172px">
										<col width="*">
									</colgroup>
									<tbody>
										<tr>
											<th class="p_l_30">기업명</th>
											<td class="b_l_0">${entInfo.entrprsNm}</td>
										</tr>
										<tr>
											<th class="p_l_30">대표자명</th>
											<td class="b_l_0">${entInfo.rprsntvNm}</td>
										</tr>
										<tr>
											<th class="p_l_30">법인등록번호</th>
											<td class="b_l_0" id="ad_jurirNoTd">${entInfo.jurirNo}</td>
										</tr>
										<tr>
											<th class="p_l_30">사업자등록번호</th>
											<td class="b_l_0" id="ad_bizrNoTd">${entInfo.bizrNo}</td>
										</tr>
										<tr id="ad_adresRow">
											<th class="p_l_30">주소</th>
											<td class="b_l_0">${entInfo.hedofcAdres}</td>
										</tr>
										<tr id="ad_telnoRow">
											<th class="p_l_30">전화번호</th>
											<td class="b_l_0">${telNo.first}-${telNo.middle}-${telNo.last}</td>
										</tr>
										<tr id="ad_fxnumRow">
											<th class="p_l_30">팩스번호</th>
											<td class="b_l_0">${fxNum.first}-${fxNum.middle}-${fxNum.last}</td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="list_bl">
								<h4 class="fram_bl">책임자정보</h4>
								<table class="table_form">
									<caption>책임자정보</caption>
									<colgroup>
										<col width="172px">
										<col width="*">
									</colgroup>
									<tbody>
										<tr>
											<th class="p_l_30">책임자이름</th>
											<td class="b_l_0">${manager.chargerNm}</td>
										</tr>
										<tr>
											<th class="p_l_30">소속부서</th>
											<td class="b_l_0">${manager.chargerDept}</td>
										</tr>
										<tr id="ad_ofcpsRow3">
											<th class="p_l_30">직위</th>
											<td class="b_l_0">${manager.ofcps}</td>
										</tr>
										<tr id="ad_telnoRow3">
											<th class="p_l_30">일반전화번호</th>
											<td class="b_l_0">${manager.telNo.first}-${manager.telNo.middle}-${manager.telNo.last}</td>
										</tr>
										<tr>
											<th class="p_l_30">휴대전화번호</th>
											<td class="b_l_0">${manager.mbtlNum.first}-${manager.mbtlNum.middle}-${manager.mbtlNum.last}</td>
										</tr>
										<tr>
											<th class="p_l_30">이메일</th>
											<td class="b_l_0">${manager.email}</td>
										</tr>
										<tr id="ad_emailRecptnAgreRow3">
											<th class="p_l_30">이메일 수신</th>
											<td class="b_l_0" id="ad_emailRecptnAgreTd3">${manager.emailRecptnAgre}</td>
										</tr>
										<tr id="ad_smsRecptnAgreRow3">
											<th class="p_l_30">SMS 수신</th>
											<td class="b_l_0" id="ad_smsRecptnAgreTd3">${manager.smsRecptnAgre}</td>
										</tr>
										<tr>
											<th class="p_l_30">수정일</th>
											<td class="b_l_0">${manager.updde}</td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="list_bl">
								<h4 class="fram_bl">담당자(본인)정보</h4>
								<table class="table_form">
									<caption>담당자(본인)정보</caption>
									<colgroup>
										<col width="172px">
										<col width="*">
									</colgroup>
									<tbody>
										<tr>
											<th class="p_l_30">담당자이름</th>
											<td class="b_l_0">${entInfo.chargerNm}</td>
										</tr>
										<tr>
											<th class="p_l_30">소속부서</th>
											<td class="b_l_0">${entInfo.chargerDept}</td>
										</tr>
										<tr id="ad_ofcpsRow">
											<th class="p_l_30">직위</th>
											<td class="b_l_0">${entInfo.ofcps}</td>
										</tr>
										<tr id="ad_telnoRow2">
											<th class="p_l_30">일반전화번호</th>
											<td class="b_l_0">${telNo2.first}-${telNo2.middle}-${telNo2.last}</td>
										</tr>
										<tr>
											<th class="p_l_30">휴대전화번호</th>
											<td class="b_l_0">${mbtlNum.first}-${mbtlNum.middle}-${mbtlNum.last}</td>
										</tr>
										<tr>
											<th class="p_l_30">이메일</th>
											<td class="b_l_0">${entInfo.email}</td>
										</tr>
										<tr id="ad_emailRecptnAgreRow">
											<th class="p_l_30">이메일 수신</th>
											<td class="b_l_0" id="ad_emailRecptnAgreTd">${entInfo.emailRecptnAgre}</td>
										</tr>
										<tr id="ad_smsRecptnAgreRow">
											<th class="p_l_30">SMS 수신</th>
											<td class="b_l_0" id="ad_smsRecptnAgreTd">${entInfo.smsRecptnAgre}</td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="btn_bl">
								<a href="#none" id="btn_user_withdrawal">회원탈퇴</a>
								<a href="#none" id="btn_entInfo_modify" class="blu">수정</a>
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