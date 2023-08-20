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
<ap:jsTag type="web" items="jquery, colorbox, jqGrid, notice, css, validate, msgBox" />
<ap:jsTag type="tech" items="cmn,font,mainn,subb, msg,util" />

<script type="text/javascript">
	$(function() {

		// 수정
		$("#btn_cancel").click(function() {
			$("#df_method_nm").val("index");
			document.dataForm.submit();
		});
		
		// 수정
		$("#btn_cancel2").click(function() {
			$('#seces01').css('display', 'none');
			$("#df_method_nm").val("index");
			document.dataForm.submit();
		});
		
		// 탈퇴
		$("#btn_user_withdrawal").click(function() {
			$('#seces01').css('display', 'none');
			$("#df_method_nm").val("updateUserWithdrawal");
			$("#dataForm").submit();
		});
		/* $("#btn_user_withdrawal")
				.click(
						function() {
							$
									.msgBox({
										title : "Confirmation",
										content : "탈퇴하시면 회원정보가 삭제되며, <br> 회원전용 서비스 이용이 불가능합니다.<br>정말 회원을 탈퇴하시겠습니까?",
										type : "confirm",
										buttons : [ {
											value : "Yes"
										}, {
											value : "No"
										} ],
										success : function(result) {
											if (result == "Yes") {
												$("#df_method_nm").val(
														"updateUserWithdrawal");
												$("#dataForm").submit();
											} else {
												$("#df_method_nm").val("index");
												document.dataForm.submit();
											}
										}
									});
						}); */
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
							<ap:trail menuNo="${param.df_menu_no}"  />
						</div>
						<div class="r_cont s_cont06_05">
							<div class="list_bl">
								<table class="table_form">
									<caption>기업정보</caption>
									<colgroup>
										<col width="172px">
										<col width="273px">
										<col width="173px">
										<col width="272px">
									</colgroup>
									<tbody>
										<tr>
											<td colspan="4" class="result_blank">
												<img src="/images2/sub/member/retire_ico.png">
												<div><p>회원을 탈퇴하시면, </p><p>회원으로서 서비스 이용에 권한과 의무에 대한 책임을 상실하게 됩니다.<br/>해당 아이디는 즉시 탈퇴 처리되고, 회원정보는 삭제 됩니다.<br/>단, 아래의 공공적 성격의 게시물은 탈퇴 후에도 삭제되지 않습니다. <br/>(게시물 등의 삭제를 원하시는 경우에는 반드시 먼저 삭제 처리하신 후, 탈퇴를 신청하시기 바랍니다.)<br/>개인정보취급방침에 따라 불량이용 및 이용제한에 관한 기록은 일정기간 삭제 되지 않고 보관될 수 있습니다. </p></div>
											</td>
										</tr>
										<tr>
											<td colspan="4">
												그 동안 기업종합정보시스템 서비스를 이용해 주셔서 감사 드립니다. <br/>
												이용 중에 서비스의 미숙함이나, 불편을 끼쳐 드렸다면 진심으로 사과 드립니다. <br/>
												서비스 이용 중 아쉽거나, 불편하셨던 점 혹은 제안, 탈퇴 사유 등을 포함한 의견을 <span>‘<a href="#none" onclick="jsMoveMenu('11', '76', 'PGBS1025');">고객지원 > 묻고답하기</a>’</span>에 남겨주시면 <br/>
												더 나은 서비스를 위해 최선을 다하겠습니다. <br/> <br/>
												앞으로도 많은 관심과 애정 부탁드리며, 다시 한번 감사 드립니다.
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="btn_bl">
								<a href="#none" id="btn_cancel" class="wht">취소</a>
								<a href="#none" onclick="$('#seces01').css('display', 'block')" >회원탈퇴</a>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			<div id="seces01" class="modal2">
				<div class="modal_wrap">
					<div class="modal_header"> 
						<h1>Confirmation</h1>
					</div>
					 <div class="modal_cont">
						<div class="img_quide">
							<img src="/images2/sub/mypage/seces_ico.png" style="margin-top: -45px;"><!--공백제거
							--><div class="img_guide_txt">
								<p>탈퇴하시면 회원정보가 삭제되며, <br/>
								회원전용 서비스 이용이 불가능 합니다. <br/>
								정말 회원을 탈퇴하시겠습니까?</p>
							</div>
						</div>
						<div class="btn_bl">
							<a href="#none" id="btn_user_withdrawal"><span>Yes</span></a> 
							<a href="#none" id="btn_cancel2" class="wht"><span>No</span></a>
						</div>
					 </div>
				</div>
			</div>
		</div>
		<!--content//-->
	</form>
</body>
</html>