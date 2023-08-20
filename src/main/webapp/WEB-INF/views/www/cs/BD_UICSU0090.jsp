<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox,json" />
<ap:jsTag type="tech" items="msg,util,cmn, mainn, subb, font,cs" />
<script type="text/javascript">
var authMenu = JSON.parse('${authMenu}');

function chkAuthAndMove(menuNo){
	var menu_info = authMenu[menuNo];
	
	if(!Util.isEmpty(menu_info)) {
		
		if(!Util.isEmpty(menu_info.url)) {			
			var url = menu_info.url;
			url = url.replace(/&amp;/g, '&');			
			jsMoveMenuURL(menu_info.parntsMenuNo, menu_info.menuNo, menu_info.progrmId, url);
		}else{
			jsMoveMenu(menu_info.parntsMenuNo, menu_info.menuNo, menu_info.progrmId);
		}
		
	}else {	
		
		<c:if test="${not empty sessionScope[SESSION_USERINFO_NAME]}">		
		jsMsgBox(null, 'info', Message.msg.noAuth);
		return;
		</c:if>
		
		jsMoveMenu('24', '25', 'PGCMLOGIO0010');
	}
}

</script>

</head>
<body>
<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
    <ap:include page="param/defaultParam.jsp" />
    <ap:include page="param/dispParam.jsp" />
    <ap:include page="param/pagingParam.jsp" />
    
    <!--//content-->
	<div id="wrap">
		<div class="s_cont" id="s_cont">
		<div class="s_tit s_tit05">
			<h1>고객지원</h1>
		</div>
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit tit5">고객지원</h2>
				<ul>
				</ul>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}" />
				</div>
				<div class="r_cont">
					<c:set var="outIdx" value="0" />
					<c:forEach items="${menuMap}" var="menuMap" varStatus="status" begin="0">
						<div class="siteMap">
							<c:if test="${menuMap.value.topNodeAt.equals('Y') and menuMap.value.siteSe.equals(SITE_DIV_WEB)}">
								<c:set var="outIdx" value="${outIdx + 1}" />
								<div class="depth01">
									<p>${menuMap.value.menuNm}</p>
								</div>
								<div class="depth02">
									<ul>								
										<c:forEach items="${menuMap.value.subMenu}" var="subMenuMap">
											<c:if test="${subMenuMap.menuNo != '26'}">	<%-- 로그아웃 제외 --%>
												<li><a href="#none" onclick="chkAuthAndMove('${subMenuMap.menuNo}')">${subMenuMap.menuNm}</a></li>
											</c:if>																							
										</c:forEach>
									</ul>
								</div>
							</c:if>
						</div>																										
					</c:forEach>										
				</div>
			</div>
		</div>
	</div>
	</div>
	<!--content//-->
</form>
</body>
</html>