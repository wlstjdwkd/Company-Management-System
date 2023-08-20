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
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox" />
<ap:jsTag type="tech" items="msg,util,ucm,cs" />

<script type="text/javascript">

$(document).ready(function(){
	$("#btn_mypage").click(function(){		
		opener.jsMoveMenu('73', '82', 'PGMY0020');
		self.close();
	});
	
	
}); // ready

</script>

</head>
<body>

<form name="dataForm" id="dataForm" action="<c:url value="${svcUrl}" />" method="post">

<ap:include page="param/defaultParam.jsp" />

	<!--폭 750px -->
	<div class="pop_imgbox" style="left:25%">
	    <div class="in_dot ok">
	        <ul>
	            <li><span>${userNm }</span>님!</li>
	            <li>정상적으로 입사지원신청이 접수되었습니다.<br />
	            </li>
	            <li>가입 감사 드리며, 좋은 하루 보내세요.</li>
	        </ul>
	    </div>
	    <p>입사지원신청서는 ‘마이페이지 〉 입사지원현황’에서 확인하실 수 있으며, 채용마감 전 수정이 가능합니다. </p>
	</div>
	
	<!--//버튼 -->
	<div class="btn_page" style="width:750px; left: 25%">
		<a class="btn_page_blue" href="#none" id="btn_mypage"><span>입사지원현황 바로가기</span></a>
	</div>
	<!--버튼 //-->

</form>

</body>
</html>