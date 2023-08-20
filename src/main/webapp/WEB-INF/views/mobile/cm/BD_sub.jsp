<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title>기업 종합정보시스템</title>	
<script type="text/javascript">
</script>
</head>
<body>
       <!--//메뉴-->
       <section class="nav">
            <ul>
                <li><a href="${MOB_INDEX_URL}">홈</a></li>

				<c:set var="mnMapList" value="${sessionScope[SESSION_MENUINFO_NAME]}" />
				<c:set var="sMenuList" value="${mnMapList[param.df_pmenu_no].subMenu}" />
				<c:if test="${!empty sMenuList}">
					<c:forEach items="${sMenuList}" var="sMnMap" varStatus="status">
                		<c:if test="${sMnMap.outptAt.equals('Y') and sMnMap.siteSe.equals(SITE_DIV_MOBILE)}">
                <li>
                	<a href="#" <c:if test="${param.df_menu_no == sMnMap.menuNo }"> class="on"</c:if> onclick="jsMoveMenu('${sMnMap.parntsMenuNo}','${sMnMap.menuNo}','${sMnMap.progrmId}')">
                		${sMnMap.menuNm}
                	</a>
                </li>
						</c:if>
					</c:forEach>
				</c:if>
            </ul>
        </section>
        <!--메뉴//-->
</body>
</html>