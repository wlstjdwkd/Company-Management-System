<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ezhelp</title>
<ap:jsTag type="web" items="jquery" />
<script src="https://939.co.kr/runezhelp.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	runezHelp({
	    divid:'ezHelpActivex', //설치될 id
	    userid:'komia', //유저id
	    width:'370', //가로길이
	    height:'210', //세로 길이
	    type:'1', //1:ActiveX부분만, 2:우측부분만, 3: 페이지전체
	    set:'A' //A:자동모드(브라우저에 따라 자동으로 표출됨), N:실행파일접속 모드
	});
});
</script>
</head>
<body>
	<div id="ezHelpActivex"></div>
</body>
</html>