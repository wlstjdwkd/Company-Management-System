<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>	
<ap:jsTag type="web" items="jquery,form,validate" />
<ap:jsTag type="tech" items="msg,util,cmn, mainn, subb, font,mb" />
<ap:globalConst />
<script type="text/javascript">
$(document).ready(function(){		
	
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
				<div class="r_cont s_cont07_08">
					<div class="step_sec join_step" style="margin-bottom: 20px;">
						<ul>
							<li>1.약관동의</li><!--공백제거
							--><li class="arr"> </li><!--공백제거
							--><li>2.본인인증</li><!--공백제거
							--><li class="arr"></li><!--공백제거
							--><li>3.유형선택</li><!--공백제거
							--><li class="arr"></li><!--공백제거
							--><li>4.정보입력</li><!--공백제거
							--><li class="arr"></li><!--공백제거
							--><li class="on">5.가입완료</li>
						</ul>
					</div>
					<div class="join_box">
						<img src="/images2/sub/member/join_complete_ico.png">
						<div>
							<p>${userInfo['NM']}님! </p>
							<p>사이트 회원가입이 완료되었습니다.</p>
						</div>
					</div>
					<div class="btn_bl">
						<a href="#none">회원탈퇴</a>
						<a href="#none" class="blu">수정</a>
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