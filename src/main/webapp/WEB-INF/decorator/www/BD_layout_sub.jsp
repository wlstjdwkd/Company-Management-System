<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<%@ page import="com.infra.system.GlobalConst" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<sitemesh:write property='head'/>
<title><ap:title  menuNo="${param.df_menu_no}" /> | 정보</title>
</head>
<body>
<sitemesh:decorate decorator="/WEB-INF/views/www/cm/BD_header.jsp" />
<sitemesh:decorate decorator="/WEB-INF/views/www/cm/BD_left.jsp" />
<sitemesh:write property='body'/>
<sitemesh:decorate decorator="/WEB-INF/views/www/cm/BD_footer.jsp" />
</body>
</html>