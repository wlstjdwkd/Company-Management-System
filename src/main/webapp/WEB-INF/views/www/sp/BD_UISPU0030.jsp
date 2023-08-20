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
<title>지원사업|기업정책|기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,colorbox,mask" />
<ap:jsTag type="tech" items="cmn, mainn, subb, font,msg,util,sp,paginate" />

<script type="text/javascript">
<c:if test="${resultMsg != null}">
	$(function(){
		jsMsgBox(null, "info", "${resultMsg}");
	});
</c:if>

	$(document).ready(function(){	
		/* 선택한 tab의 class에 on 처리 */
		var tabGb = $("#tabGb").val();
		$("#tab"+tabGb).attr("class", "on");
	});

	
	/* 탭 검색 */
	function tab_suport_get_list(tabGb) {
		var form = document.dataForm;

		form.tabGb.value = tabGb;
		
		form.df_curr_page.value = 1;
		form.df_method_nm.value = "";
		form.submit();
	}
	
</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />

		<input type="hidden" name="ad_menoNo" id="ad_menoNo" />
		<input type="hidden" name="ad_menuList" id="ad_menuList" value="menulist" />
		<input type="hidden" name="tabGb" id="tabGb" value="${inparam.tabGb}" />
		
		<div id="wrap">
			<div class="s_cont" id="s_cont">
		<div class="s_tit s_tit04">
			<h1>정보제공</h1>
		</div>
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit tit4">정보제공</h2>
				<ul>
				</ul>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}" />
				</div>
				<div class="r_cont">
					<div class="s_tabMenu s_4tabMenu">
						<ul>
							<li id="tabA" onclick="tab_suport_get_list('A')"><span class="supTab">금융·경영</span></li>
							<li id="tabB" onclick="tab_suport_get_list('B')"><span class="supTab">기술·인력</span></li>
							<li id="tabC" onclick="tab_suport_get_list('C')"><span class="supTab">수출·내수</span></li>
							<li id="tabD" onclick="tab_suport_get_list('D')"><span class="supTab">기타</span></li>
						</ul>
					</div>
					<div class="table_list">
						<ap:pagerParam />
						<table class="st_bl01" style="margin-top: 11px;">
							<colgroup>
								<col width="80px">
								<col width="*">
								<col width="150px">
								<col width="105px">
								<col width="124px">
							</colgroup>
							<thead>
								<tr>
									<th>사업분야</th>
									<th style="padding-right: 98px;">제목</th>
									<th>주관기관</th>
									<th>시작일</th>
									<th>마감일</th>
								</tr>
							</thead>
							<tbody>
								<c:choose>
									<c:when test="${fn:length(suportList) > 0}">
										<c:forEach items="${suportList}" var="info" varStatus="status">
											<tr>
												<td><b>${fn:replace(info.realm,'&','&amp;')}</b></td>
												<td class="txt_l" style="padding-left: 15px;"><a href="${fn:replace(info.url, '&','&amp;')}" target="_blank">${info.sj}</a></td>
												<td style="color:#222">${info.mngtMiryfc}</td>
												<td>${info.opertnBginde}</td>
												<td>${info.opertnEndde}</td>
											</tr>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<tr>
											<td colspan="6" style="text-align: center;">지원사업 정보가 없습니다.</td>
										</tr>
									</c:otherwise>
								</c:choose>
							</tbody>
						</table>
					</div>
					<div style="text-align:center;"><ap:pager pager="${pager}" /></div>
				</div>
			</div>
		</div>
	</div>
		</div>
	</form>
</body>
</html>