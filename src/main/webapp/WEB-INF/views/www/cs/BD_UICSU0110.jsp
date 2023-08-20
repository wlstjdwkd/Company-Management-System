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
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox,json" />
<ap:jsTag type="tech" items="cmn, mainn, subb, font, util" />

<script src="https://939.co.kr/runezhelp.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		// ezHelp(사용 안함)
		/* runezHelp({
			divid:'ezHelpActivex', //설치될 id
			userid:'komia', //유저id
			width:'370', //가로길이
			height:'210', //세로 길이
			type:'1', //1:ActiveX부분만, 2:우측부분만, 3: 페이지전체
			set:'A' //A:자동모드(브라우저에 따라 자동으로 표출됨), N:실행파일접속 모드
		}); */
	});
</script>
</head>
<body>
<form name="dataForm" id="dataForm" method="post">
    <ap:include page="param/defaultParam.jsp" />
    <ap:include page="param/dispParam.jsp" />
    <ap:include page="param/pagingParam.jsp" />
    
    <!--//content-->
	<div id="wrap">
		<div class="s_cont" id="s_cont">
		<div class="s_tit s_tit05">
			<h1>고객지원</h1>
		</div>
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit tit5">고객지원</h2>
				<ul>
				</ul>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}" />
				</div>
				<div class="r_cont s_cont05_04">
					<div class="terms_wrap" style="border-bottom: 0;">
						<div>
							<div class="img_text">
								<img src="/images2/sub/customer/customer_remote_img01.png" style="margin-bottom: 41px; margin-left: -10px; margin-top: -8px;">
								<h3>기업 정보에서는 고객님들의 편의를 위하여 원격지원 서비스를 제공하고 있습니다.</h3>
								<p>원격지원 서비스는 고객님들의 PC에서 확인서 신청 등의 문제가 발생할 경우<br/>직접 고객님의 PC에 원격 접속하여 문제를 쉽고 빠르게 해결해 드리는 서비스입니다.</p>
								<p class="op">원격지원 가능시간 : 10:00 ~ 17:00&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;l&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;원격지원 이용문의 : 02-3275-0107</p>
								<p>원격지원 서비스를 시작하시려면, 아래 버튼을 클릭해 주십시오.</p>
								<div class="btn_bl">
									<a href="http://helpu.kr/tech" target="_blank">원격지원 서비스</a>
								</div>
							</div>
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