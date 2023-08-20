<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>	
<ap:jsTag type="web" items="jquery" />
<ap:globalConst />
<script type="text/javascript">
$(document).ready(function(){
	<c:choose>
		<c:when test="${joinedUser eq 'Y'}">
		window.opener.joinedUser();
		</c:when>
		<c:otherwise>
		window.opener.selectCase();				
		</c:otherwise>
	</c:choose>
	
	self.close();
});
</script>
</head>

<body>
<form name="dataForm" id="dataForm" method="post">

인증 성공

</form>
</body>
</html>