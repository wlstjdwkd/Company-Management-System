<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<%@ page import="com.infra.system.GlobalConst" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.infra.util.StringUtil" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title>기업 종합정보시스템</title>	
<% 
	StringUtil stringUtil = new StringUtil();
	
	String issu_phone_num = GlobalConst.ISSU_PHONE_NUM;
	
	Map<String,String> num = stringUtil.telNumFormat(issu_phone_num);
	
	String ISSU_PHONE_NUM_FIRST = num.get("first");
	String ISSU_PHONE_NUM_MIDDLE = num.get("middle");
	String ISSU_PHONE_NUM_LAST = num.get("last");
	
%>
</head>
<body>
<ap:globalConst />
<!--//lnb -->
<div style="height:80px;"></div>
<div id="lnb_wrap">
	<div class="inner2" >
		<div class="lnb_zone">
			<h2 class="tit_trans"></h2>
			<ul class="lnb">
				<c:set var="mnMapList" value="${sessionScope[SESSION_MENUINFO_NAME]}" />
				<c:set var="pMenuList" value="${mnMapList[param.df_pmenu_no].subMenu}" />
				<c:if test="${!empty pMenuList}">
				<c:forEach items="${pMenuList}" var="pMnMap" varStatus="pstatus">
					<c:if test="${pMnMap.outptAt.equals('Y') and pMnMap.siteSe.equals(SITE_DIV_WEB)}">					
						<c:choose>						
							<c:when  test="${pMnMap.lastNodeAt.equals('Y')}">
								<li id="${pMnMap.menuNo}">
									<c:choose>
									<c:when test="${!empty pMnMap.url}">
										<a href="#none" onclick="jsMoveMenuURL('${pMnMap.parntsMenuNo}','${pMnMap.menuNo}','${pMnMap.progrmId}','${pMnMap.url}')" <c:if test="${pstatus.last}">class="bd0"</c:if>>
										${pMnMap.menuNm}
										</a>
									</c:when>
									<c:otherwise>
										<a href="#none" onclick="jsMoveMenu('${pMnMap.parntsMenuNo}','${pMnMap.menuNo}','${pMnMap.progrmId}')" <c:if test="${pstatus.last}">class="bd0"</c:if>>
										${pMnMap.menuNm}
										</a>
									</c:otherwise>
									</c:choose>			
								</li>
							</c:when>
							<c:otherwise>
								<li>
									<a href="#none">${pMnMap.menuNm}</a>
								</li>
							</c:otherwise>
						</c:choose>
					</c:if>					
				</c:forEach>
				</c:if> 
			</ul>
		</div>
	</div>
</div>
<!-- lnb//-->
</body>
</html>