<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>	
<ap:jsTag type="web" items="jquery, form, validate, notice, msgBox" />
<ap:jsTag type="tech" items= "msg, util, cmn, mainn, subb, font" />
<ap:globalConst />
<script type="text/javascript">
$(document).ready(function(){
	
	// 휴대전화번호인증
	$("#btn_certify_phone").click(function(){
		window.open('', 'popupChk', 'width=500, height=550, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=no');
		document.niceForm.action = "https://nice.checkplus.co.kr/CheckPlusSafeModel/checkplus.cb";
		document.niceForm.target = "popupChk";
		document.niceForm.submit();
	});
	
	// 아이핀인증
/* 	$("#btn_certify_ipin").click(function(){			
		    wWidth = 360;
		    wHight = 120;

		    wX = (window.screen.width - wWidth) / 2;
		    wY = (window.screen.height - wHight) / 2;

		    var w = window.open("/PGCMLOGIO0040.do?df_method_nm=gpincertify", "gPinLoginWin", "directories=no,toolbar=no,left="+wX+",top="+wY+",width="+wWidth+",height="+wHight);
	}); */
	$("#btn_certify_ipin").click(function(){		
		window.name ="NameCheck_window";
		window.open('', 'popupIPIN2', 'width=450, height=550, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=no');
		document.form_ipin.action = "https://cert.vno.co.kr/ipin.cb";
		document.form_ipin.target = "popupIPIN2";
		document.form_ipin.submit();

	});
	
	$("#btn_certify_free").click(function(){
		alert("바로 넘어가기");
		$("#df_method_nm").val("freepass");
		$form = $("#dataForm");
		$form.attr("action","PGCMLOGIO0040.do");
		$form.submit();
	});
});

function selectCase(){
	$("#df_method_nm").val("selectCase");
	$form = $("#dataForm");
	$form.attr("action","PGCMLOGIO0040.do");
	$form.submit();
}

function joinedUser(){
	jsMsgBox(null, 'info', Message.msg.alreadyJoin);
}

</script>
</head>

<body>
<form name="niceForm" method="post">
	<input type="hidden" name="m" value="checkplusSerivce">
	<input type="hidden" name="EncodeData" value="${sessionScope[SESSION_NICE_ENC_NAME].encData}">
	<input type="hidden" name="param_r1" value="">
	<input type="hidden" name="param_r2" value="">
	<input type="hidden" name="param_r3" value="">
</form>

<!--  -->
<form name="form_ipin" method="post">
	<input type="hidden" name="m" value="pubmain">						<!-- 필수 데이타로, 누락하시면 안됩니다. -->
    <input type="hidden" name="enc_data" value="${sessionScope[SESSION_NICE_ENC_NAME].ipinencData}">		<!-- 위에서 업체정보를 암호화 한 데이타입니다. -->
    
    <!-- 업체에서 응답받기 원하는 데이타를 설정하기 위해 사용할 수 있으며, 인증결과 응답시 해당 값을 그대로 송신합니다.
    	 해당 파라미터는 추가하실 수 없습니다. -->
    <input type="hidden" name="param_r1" value="">
    <input type="hidden" name="param_r2" value="">
    <input type="hidden" name="param_r3" value="">
</form>

<!--  -->
	
<form name="dataForm" id="dataForm" method="post">
	<ap:include page="param/defaultParam.jsp" />
	<ap:include page="param/dispParam.jsp" />
	<input type="hidden" id="chk_terms03" name="chk_terms03" value="${param.chk_terms03}" />
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
				<div class="r_cont s_cont07_05">
					<div class="step_sec join_step" style="margin-bottom: 20px;">
						<ul>
							<li>1.약관동의</li><!--공백제거
							--><li class="arr"> </li><!--공백제거
							--><li class="on">2.본인인증</li><!--공백제거
							--><li class="arr"></li><!--공백제거
							--><li>3.유형선택</li><!--공백제거
							--><li class="arr"></li><!--공백제거
							--><li>4.정보입력</li><!--공백제거
							--><li class="arr"></li><!--공백제거
							--><li>5.가입완료</li>
						</ul>
					</div>
					<div class="join_box">
						<ul>
						   <c:choose>
								<c:when test="${sessionScope[SESSION_NICE_ENC_NAME].encErrCd eq '0'}">
								<li><a href="#none" id="btn_certify_phone">휴대전화번호로<br/>본인인증</a></li>
                        		</c:when>
                        	</c:choose>
							<!--공백제거
							--><li>
							<c:choose>
								<c:when test="${sessionScope[SESSION_NICE_ENC_NAME].ipinencErrCd eq '0'}">
								<a href="#none" id="btn_certify_ipin">아이핀(I-PIN)으로<br/>본인인증</a></li>
                        		</c:when>
                        	</c:choose>
							<li><a href="#none" id="btn_certify_free">임시로 링크</a></li>
						</ul>
					</div>
					<p class="list_noraml">사이트회원가입을 위해 본인인증 방법을 선택해 주세요.<br/><span>인증방법 선택 시 팝업 차단을 해제 후 이용하시기 바랍니다.</span></p>
					<p class="list_noraml">‘정보통신망 이용촉진 및 정보보호 등에 관한 법률’ 제23조2 “주민등록번호의 사용제한” 규정에 따라 고객님의 주민등록번호를 <br/>수집∙이용하지 않습니다.</p>
					<p class="list_noraml">회원 여러분의 개인정보 도용방지 및 안전한 개인정보처리를 위하여 나이스평가정보㈜의 “휴대전화번호”와<br/>“아이핀(I-PIN)” 을 통해 본인인증 확인 서비스를 제공하고 있습니다.</p>
				</div>
			</div>
		</div>
	</div>
	</div>
	<!--content//-->
</form>

</body>
</html>