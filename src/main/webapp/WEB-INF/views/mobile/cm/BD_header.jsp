<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title>정보</title>	
</head>
<body>
<!-- 사이드 메뉴 시작 //-->
<form name="menuForm" id="menuForm" method="post">
<ap:include page="param/menuParam.jsp" />
</form>
<aside id="s_menu">
    <div class="smenu_dimm"></div>
    <div class="smenu_wrap">
        <div id="menu">
            <div class="smenu_btn">
                <button class="smenu_close aside_icon" type="button">메뉴닫기</button>
            </div>
            <ul>
                <li>
                    <a href="${MOB_INDEX_URL}">기업 정보 홈<span class="aside_icon s_m01">icon</span></a>
                </li>
                
				<c:set var="mnMapList" value="${sessionScope[SESSION_MENUINFO_NAME]}" />
				<c:set var="idx" value="1" />
				<c:forEach items="${mnMapList}" var="mnMap" varStatus="status">				
					<c:if test="${mnMap.value.topNodeAt.equals('Y') and mnMap.value.outptAt.equals('Y') and mnMap.value.siteSe.equals(SITE_DIV_MOBILE)}">
                <li>
                    <a href="#none" class="menu_bg" onclick="jsMoveMenu('${mnMap.value.menuNo}','${mnMap.value.menuNo}','${mnMap.value.progrmId}')">${mnMap.value.menuNm}<span class="aside_icon s_m01">icon</span></a>
                    	
						<c:set var="subMnList" value="${mnMap.value.subMenu}" />
                    <ul>
						<c:forEach items="${subMnList}" var="subMnMap" varStatus="cstatus">
                        <li>
                        	<a href="#none" onclick="jsMoveMenu('${subMnMap.parntsMenuNo}','${subMnMap.menuNo}','${subMnMap.progrmId}')">
                        		${subMnMap.menuNm}
                        		<span class="aside_icon s_m01">icon</span>
                        	</a>
                        </li>
						</c:forEach>
                    </ul>
                </li>
					</c:if>
				</c:forEach>
                
            </ul>
        </div>
    </div>
</aside>
<!-- 사이드 메뉴 끝 //-->

<section id="container">
	<!--// header -->
    <header>
        <a href="#none" class="btn_s_menu"><img src="/images/mv/btn_s_menu.png" alt="좌측메뉴" title="좌측메뉴" /></a>
<c:if test ="${param.df_menu_no == null or param.df_menu_no == '' }">
        <h1><img src="/images/mv/logo.png" alt="" title="로고" /></h1>
</c:if>
<c:if test ="${param.df_menu_no != null and param.df_menu_no != '' }">
        <h2 id="pageTitle"></h2>
        <h3><img src="/images/mv/sub_logo.png" alt="" title="로고" /></h3>
</c:if>      
    </header>
    <!-- header //-->


    <!--// container -->
    <div id="container">

</body>
</html>