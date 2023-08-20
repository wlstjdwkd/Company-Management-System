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
<title>저작권정책|정보</title>

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
								<img src="/images2/sub/terms/terms_copyright_img01.png" style="margin-bottom: 17px;">
								<p>산업통상자원부 정보 홈페이지에서 제공하는<br/>모든 자료(즉, 웹문서, 첨부화일, DB정보 등)는 저작권법에 의하여 보호받는 저작물로서,<br/>별도의 저작권 표시 또는 출처를 명시한 경우를 제외하고는  원칙적으로 정보에 저작권이 있으며,<br/>이를 무단 복제, 배포하는 경우 저작권법 제136조에 의한 저작재산침해죄에 해당합니다.</p>
							</div>
							<p>정보에서 제공하는 자료로 수익을 얻거나 이에 상응하는 혜택을 누리고자하는 경우에 정보과 사전에 별도의 <br/>
협의를 하거나 허락을 얻어야 하며, 협의 또는 허락을 얻어 자료의 내용을 게재하는 경우에도 출처가 정보임을 밝혀야 합니다.<br/><br/>
다른 인터넷 사이트 화면에서 정보 홈페이지의 첫화면으로 링크시키는 것은 허용되지만 이렇게 링크시에도 링크 사실을 홈페이지 <br/>
관리자에게 통지하여야 합니다. 그러나 세부화면(서브도메인)으로 링크시키는 것은 허용되지 않습니다.<br/><br/>
정보의 콘텐츠를 적법한 절차에 따라 다른 인터넷 사이트에 게재하는 경우에 단순한 오류 정정 이외에 내용의 무단변경을 금지하며, <br/>
이를 위반할 때에는 형사처벌을 받을 수 있습니다.<br/><br/>
위와 관련된 사항에 대한 더 자세한 문의는 정보 웹사이트 운영자(T:02-3275-2994)에 연락해 주십시오.</p>
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