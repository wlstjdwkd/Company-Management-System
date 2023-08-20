<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,form" />
<ap:jsTag type="tech" items="util,acm,ps" />	
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
	<div class="wrap_inn">

		<div class="contents">
			<!--// 타이틀 영역 -->
			<ap:trail menuNo="${param.df_menu_no}" onlyTitle="true" />
			<!-- 타이틀 영역 //-->

			/admin/ps/BD_UIPSA0099

		</div>
	</div>
</div>
<!--content//-->
</form>

</body>
</html>