<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title>정보</title>	
</head>
<body>
<form name="menuForm" id="menuForm" method="post">
<ap:include page="param/menuParam.jsp" />
</form>
<ap:globalConst />

<div id="header">
	<div class="top">	
		<%-- <h1><a href="<c:url value='${ADM_INDEX_URL}' />"><img src="<c:url value='/images/acm/logo.png' />" alt="정보" /></a></h1> --%>
		<div class="gnb_zone">
			<div class="quick">
				<ul>
					<!-- <li><a href="/" target="_blank">서비스홈</a></li> -->
					<li><a href="#none" onclick="<c:url value='${PUB_LOGOUT_URL}' />">로그아웃</a></li>
				</ul>
			</div>
			<!--// 1뎁스 -->
			<div class="gnb">				
				<ul>				
				<c:set var="mnMapList" value="${sessionScope[SESSION_MENUINFO_NAME]}" />
				<c:set var="idx" value="1" />
				<c:forEach items="${mnMapList}" var="mnMap" varStatus="status">
					<c:if test="${mnMap.value.topNodeAt.equals('Y') and mnMap.value.outptAt.equals('Y') and mnMap.value.siteSe.equals(SITE_DIV_ADM)}">						
						<li class="m${idx}" style="margin-right:35px; text-align: left;"><a href="#none" onclick="jsMoveMenu('${mnMap.value.menuNo}','${mnMap.value.menuNo}','${mnMap.value.progrmId}')">${mnMap.value.menuNm}</a></li>
						<c:set var="idx" value="${idx+1}" />
					</c:if>
				</c:forEach>
				</ul>
			</div>
		</div>
	</div>
	<!--// 하위메뉴 -->
	<div class="gnb_menu">
		<div class="inner">
			<div class="fr">
				<c:set var="idx" value="1" />
				<c:forEach items="${mnMapList}" var="mnMap" varStatus="pstatus">
					<c:if test="${mnMap.value.topNodeAt.equals('Y') and mnMap.value.outptAt.equals('Y') and mnMap.value.siteSe.equals(SITE_DIV_ADM)}">
					<c:set var="subMnList" value="${mnMap.value.subMenu}" />
					<ul class="m${idx}">
						<c:set var="idx" value="${idx+1}" />									
						<c:forEach items="${subMnList}" var="subMnMap" varStatus="cstatus">
						<li>
							<c:set var="threeMnMapList" value="${subMnMap.subMenu}" />
							<c:choose>
							<c:when  test="${!empty threeMnMapList}">
								<c:set var="threeMnMap" value="${threeMnMapList.get(0)}" />
								<c:choose>
									<c:when test="${!empty threeMnMap.url}">
										<a href="#none" onclick="jsMoveMenuURL('${subMnMap.parntsMenuNo}','${threeMnMap.menuNo}','${threeMnMap.progrmId}','${threeMnMap.url}')">
											${subMnMap.menuNm}
										</a>
									</c:when>
									<c:otherwise>
										<a href="#none" onclick="jsMoveMenu('${subMnMap.parntsMenuNo}','${threeMnMap.menuNo}','${threeMnMap.progrmId}')">
											${subMnMap.menuNm}
										</a>
									</c:otherwise>
								</c:choose>
							</c:when>
					     	<c:otherwise>
								<c:choose>
									<c:when test="${!empty subMnMap.url}">
										<a href="#none" onclick="jsMoveMenuURL('${subMnMap.parntsMenuNo}','${subMnMap.menuNo}','${subMnMap.progrmId}','${subMnMap.url}')">
											${subMnMap.menuNm}
										</a>
									</c:when>
									<c:otherwise>
										<a href="#none" onclick="jsMoveMenu('${subMnMap.parntsMenuNo}','${subMnMap.menuNo}','${subMnMap.progrmId}')">
											${subMnMap.menuNm}
										</a>
									</c:otherwise>
								</c:choose>		
							</c:otherwise>
							</c:choose>
						</li>						
						</c:forEach>					
					</ul>
					</c:if>
				</c:forEach>
			</div>
		</div>
	</div>
	<!-- 하위메뉴 //-->
</div>



</body>
</html>