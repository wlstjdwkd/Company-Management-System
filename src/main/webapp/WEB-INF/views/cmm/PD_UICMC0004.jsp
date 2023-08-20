<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
	<c:when test="${param.inputYn eq 'Y'}">
		window.opener.jusoCallBack("${param.roadFullAddr}","${param.roadAddrPart1}","${param.addrDetail}","${param.roadAddrPart2}","${param.engAddr}","${param.jibunAddr}","${param.zipNo}", "${param.admCd}", "${param.rnMgtSn}", "${param.bdMgtSn}");
		self.close();	
	</c:when>
	<c:otherwise>
		document.dataForm.confmKey.value = "${JUSO_CONF_KEY}";
		document.dataForm.returnUrl.value = location.href;
		document.dataForm.action="${JUSO_URL}";		
		document.dataForm.submit();	
	</c:otherwise>
	</c:choose>

});
</script>
</head>

<body>
<form name="dataForm" id="dataForm" method="post">
<input type="hidden" id="confmKey" name="confmKey" value=""/>
<input type="hidden" id="returnUrl" name="returnUrl" value=""/>

우편번호 검색

</form>
</body>
</html>