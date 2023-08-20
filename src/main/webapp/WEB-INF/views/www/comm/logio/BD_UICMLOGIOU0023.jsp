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
<title>아이디찾기|기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery, colorbox, jqGrid, notice, css, msgBox, validate" />
<ap:jsTag type="tech" items="cmn,mainn,subb,font, msg,util" />
<script type="text/javascript">
	$(document)
			.ready(
					function() {
						
						// 이메일 발송
						$("#btn_send_email")
								.click(
										function() {
											$
													.ajax({
														url : "PGCMLOGIO0020.do",
														type : "POST",
														dataType : "json",
														data : {
															df_method_nm : "insertEmail",
															"ad_user_nm" : $(
																	'#ad_user_nm')
																	.val(),
															"ad_user_email" : $(
																	'#ad_user_email')
																	.val()
														},
														async : false,
														success : function(
																response) {
															try {
																if (response.result) {
																		/* btn_click1(); */
																		jsMsgBox( null, 'info', '회원님의 이메일로 <br>아이디를 발송하였습니다.');
																		/* document.getElementById('passwordFind01').style.display='block'; */
																	return;
																} else {
																	return;
																}
															} catch (e) {
																if (response != null) {
																	jsSysErrorBox(response);
																} else {
																	jsSysErrorBox(e);
																}
																return;
															}
														}
													});
										});

						// SMS 전송
						$("#btn_send_mbtlNum")
								.click(
										function() {
											$
													.ajax({
														url : "PGCMLOGIO0020.do",
														type : "POST",
														dataType : "json",
														data : {
															df_method_nm : "insertMbtlNum",
															"ad_user_nm" : $(
																	'#ad_user_nm')
																	.val(),
															"ad_user_email" : $(
																	'#ad_user_email')
																	.val()
														},
														async : false,
														success : function(
																response) {
															try {
																if (response.result) {
																		/* btn_click2(); */
																		jsMsgBox(
																			null,
																			'info',
																			'회원님의 휴대전화번호로<br> 아이디를 전송하였습니다.');
																		/* document.getElementById('passwordFind02').style.display='block'; */
																	return;
																} else {

																	return;
																}
															} catch (e) {
																if (response != null) {
																	jsSysErrorBox(response);
																} else {
																	jsSysErrorBox(e);
																}
																return;
															}
														}
													});
										});

						function btn_click1(){
							$("#passwordFind01").css("display", "block");
						};
						
						function btn_click2(){
							$("#passwordFind02").css("display", "block");
						};
					});
	
</script>
</head>

<body>

	<!--//content-->
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />

		<input type="hidden" name="ad_user_nm" id="ad_user_nm" value="${userInfo.userNm}" /> 
		<input type="hidden" name="ad_user_email" id="ad_user_email" value="${userInfo.email}" />
		
		<c:forEach items="${findUserId}" var="findUserId" varStatus="status">
             <input type="hidden" name="ad_findEmail" value="${findUserId.email}" />
			  <input type="hidden" name="ad_findNum" value="${findUserId.mbtlNum.first}-${findUserId.mbtlNum.middle}-${findUserId.mbtlNum.last}" />
		 </c:forEach>

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
						<div class="r_cont s_cont07_03">
							<p class="resultGuide" style="width: 724px">아래 선택하신 수단으로 아이디를 전송해 드립니다.</p>
							<div class="member_box_wrap">
								<div class="member_box xs_member_box member_boxL">
									<h3 class="txt">아래의 이메일로<br/>아이디 받기</h3>
									<img src="/images2/sub/member/finde_password_mail_ico.png">
									<c:forEach items="${findUserId}" var="findUserId" varStatus="status">
										<h4 class="fnt_bl">${findUserId.email}</h4>
									</c:forEach>
									<div class="btn_center">
										<a href="#none" id="btn_send_email" class="blu">이메일 발송<img src="/images2/common/btn_arr.png"></a>
									</div>
								</div>
								<div class="member_box xs_member_box member_boxR">
									<h3 class="txt">아래의 휴대전화번호로<br/>아이디 받기</h3>
									<img src="/images2/sub/member/finde_password_ico.png">
									<c:forEach items="${findUserId}" var="findUserId" varStatus="status">
										<h4 class="fnt_bl">${findUserId.mbtlNum.first}-${findUserId.mbtlNum.middle}-${findUserId.mbtlNum.last}</h4>
									</c:forEach>
									<div class="btn_center">
										<a href="#none" id="btn_send_mbtlNum" class="blu">SMS 전송<img src="/images2/common/btn_arr.png"></a>
									</div>
								</div>
							</div>
							<div class="agree_st">
		
							</div>
							<div class="btn_bl">
								<a href="#none" id="find_user_passpwd" onclick="jsMoveMenu('24', '86', 'PGCMLOGIO0030');" class="blu">비밀번호찾기</a>
								<a href="#none" onclick="${PUB_LOGIN_URL}">로그인</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		
			<!-- <div id="passwordFind01" class="modal2" style="display:none;">
				<div class="modal_wrap">
					<div class="modal_header"> 
						<h1>Information</h1>
					</div>
					 <div class="modal_cont">
						<div class="img_quide">
							<img src="/images2/sub/info_ico.png" style="margin-top: -32px; margin-bottom: -10px;">
							<div class="img_guide_txt">
								<p>등록하신 이메일로<br/>회원님께 아이디를 전송하였습니다. </p>
							</div>
						</div>
						<div class="btn_bl">
							<a href="javascript:;" onclick="document.getElementById('passwordFind01').style.display='none'">Close</a>
							
						</div>
					 </div>
				</div>
			</div>
			
			<div id="passwordFind02" class="modal2" style="display:none;">
				<div class="modal_wrap">
					<div class="modal_header"> 
						<h1>Information</h1>
					</div>
					 <div class="modal_cont">
						<div class="img_quide">
							<img src="/images2/sub/info_ico.png" style="margin-top: -32px; margin-bottom: -10px;">
							<div class="img_guide_txt">
								<p>등록하신 휴대전화번호로<br/>회원님께 아이디를 전송하였습니다. </p>
							</div>
						</div>
						<div class="btn_bl">
							<a href="javascript:;" onclick="document.getElementById('passwordFind02').style.display='none'">Close</a>
							
						</div>
					 </div>
				</div>
			</div> -->
			
		</div>
		<!--content//-->
	</form>
</body>
</html>