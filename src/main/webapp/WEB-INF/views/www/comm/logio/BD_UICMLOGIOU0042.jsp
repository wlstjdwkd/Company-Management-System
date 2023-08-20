<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,form,validate" />
<ap:jsTag type="tech" items="msg,util,mb,cmn, mainn, subb, font" />
<script type="text/javascript">
	$(document).ready(function() {

		// 개인회원가입
		$("#btn_ind_join").click(function() {
			$("#df_method_nm").val("joinInfoForm");
			var joinType = "individual";
			$("#ad_join_type").val(joinType);
			$form = $("#dataForm");
			$form.attr("action", "PGCMLOGIO0040.do");
			$form.submit();
		});
		// 기업회원가입
		$("#btn_ent_join").click(function() {
			$("#df_method_nm").val("joinInfoForm");
			var joinType = "enterprise";
			$("#ad_join_type").val(joinType);
			$form = $("#dataForm");
			$form.attr("action", "PGCMLOGIO0040.do");
			$form.submit();
			$("#dataForm").submit();
		});
	});
</script>
</head>

<body>
	<form name="dataForm" id="dataForm" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<input type="hidden" id="ad_join_type" name="ad_join_type" />
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
				<div class="r_cont s_cont07_06">
					<div class="step_sec join_step" style="margin-bottom: 20px;">
						<ul>
							<li>1.약관동의</li><!--공백제거
							--><li class="arr"> </li><!--공백제거
							--><li>2.본인인증</li><!--공백제거
							--><li class="arr"></li><!--공백제거
							--><li class="on">3.유형선택</li><!--공백제거
							--><li class="arr"></li><!--공백제거
							--><li>4.정보입력</li><!--공백제거
							--><li class="arr"></li><!--공백제거
							--><li>5.가입완료</li>
						</ul>
					</div>
					<div class="join_box">
						<ul>
							<li><a href="#" id="btn_ind_join">개인회원<br/>가입하기</a></li><!--공백제거
							--><li><a href="#" id="btn_ent_join">기업회원 가입하기<br/><span>(기업 확인서 발급)</span></a></li>
						</ul>
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