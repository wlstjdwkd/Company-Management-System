<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title>기업 종합정보시스템</title>	
</head>
<body>
<ap:globalConst />

<!--// 좌측영역 -->
<div class="lnb_zone">
	<dl class="lnb">
	<c:set var="mnMapList" value="${sessionScope[SESSION_MENUINFO_NAME]}" />
	<%-- <c:set var="param_menu" value="27" /> --%>
	<c:set var="pMenuList" value="${mnMapList[param.df_pmenu_no].subMenu}" />
	<%-- <c:set var="pMenuList" value="${mnMapList[param_menu].subMenu}" /> --%>
	<%-- ${param.df_pmenu_no } --%>
	<c:if test="${!empty pMenuList}">
		<c:forEach items="${pMenuList}" var="pMnMap" varStatus="pstatus">
			<c:if test="${pMnMap.outptAt.equals('Y') and pMnMap.siteSe.equals(SITE_DIV_ADM)}">
				<c:choose>
					<c:when  test="${pMnMap.lastNodeAt.equals('Y')}">
						<dt id="${pMnMap.menuNo}" >
						<c:choose>
							<c:when test="${!empty pMnMap.url}">
								<a href="#none" onclick="jsMoveMenuURL('${pMnMap.parntsMenuNo}','${pMnMap.menuNo}','${pMnMap.progrmId}','${pMnMap.url}')">
									${pMnMap.menuNm}
								</a>
							</c:when>
							<c:otherwise>
								<a href="#none" onclick="jsMoveMenu('${pMnMap.parntsMenuNo}','${pMnMap.menuNo}','${pMnMap.progrmId}')">
									${pMnMap.menuNm}
								</a>
							</c:otherwise>
						</c:choose>
						</dt>
					</c:when>
	     			<c:otherwise>
		     			<dt>
							<a href="#none">${pMnMap.menuNm}</a>
						</dt>
					</c:otherwise>
				</c:choose>					
				<c:set var="stepTwoList" value="${pMnMap.subMenu}" />
				<c:if test="${!empty stepTwoList}">
					<dd class="lnb_menu2" style="display:none;">
					<ul>
					<c:forEach items="${stepTwoList}" var="stepTwo" varStatus="s2status">
						<li class="btn">
						
						<c:choose>
							<c:when test="${!empty stepTwo.url}">
								<a id="${stepTwo.menuNo}" href="#none" onclick="jsMoveMenuURL('${pMnMap.parntsMenuNo}','${stepTwo.menuNo}','${stepTwo.progrmId}','${stepTwo.url}')">
									${stepTwo.menuNm}
								</a>
							</c:when>
							<c:otherwise>
								<a id="${stepTwo.menuNo}" href="#none" onclick="jsMoveMenu('${pMnMap.parntsMenuNo}','${stepTwo.menuNo}','${stepTwo.progrmId}')">
									<span>${stepTwo.menuNm}</span>
								</a>
							</c:otherwise>
						</c:choose>						

<%-- 4단계 메뉴 없음(아래 미수행) --%>
						<c:set var="stepThreeList" value="${stepTwo.subMenu}" />
						<c:if test="${!empty stepThreeList}">
							<ul class="lnb_menu3">
							<c:forEach items="${stepThreeList}" var="stepThree" varStatus="s3status">
								<li><a href="#">stepThree.menuNm</a></li>
							</c:forEach>
							</ul>
						</c:if>
<%-- 4단계 메뉴 없음 --%>
						</li>
					</c:forEach>
					</ul>
					</dd>
				</c:if>
			</c:if>					
		</c:forEach>
	</c:if>
	</dl>
</div>
<!-- 좌측영역 //-->

</body>
</html>