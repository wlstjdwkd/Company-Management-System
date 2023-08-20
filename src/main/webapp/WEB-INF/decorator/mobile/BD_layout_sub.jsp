<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.infra.system.GlobalConst" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0" />
<meta name="format-detection" content="telephone=no, address=no, email=no" /><!--숫자인식,메일주소,지도상의 주소링크 막기-->
<link rel="apple-touch-icon" href="이미지경로.png" /> <!--북마크 추가시 바탕화면에서 볼수있는 아이콘 이미지(png저장)-->
<sitemesh:write property='head'/>
<title><sitemesh:write property='title'/></title>
</head>
<body>
<sitemesh:decorate decorator="/WEB-INF/views/mobile/cm/BD_header.jsp" />
<sitemesh:decorate decorator="/WEB-INF/views/mobile/cm/BD_sub.jsp" />
<sitemesh:write property='body'/>
<sitemesh:decorate decorator="/WEB-INF/views/mobile/cm/BD_footer.jsp" />
</body>
</html>