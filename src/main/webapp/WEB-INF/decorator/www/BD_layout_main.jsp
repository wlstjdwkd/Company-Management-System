<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.infra.system.GlobalConst" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<sitemesh:write property='head'/>
<title>정보</title>
</head>
<body>
<!-- <sitemesh:decorate decorator="/WEB-INF/views/www/cm/BD_header.jsp" /> -->
<sitemesh:write property='body'/>
<sitemesh:decorate decorator="/WEB-INF/views/www/cm/BD_main_footer.jsp" />
</body>
</html>