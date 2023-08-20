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
<%-- <ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox" />
<ap:jsTag type="tech" items="msg,util,ucm,cs" /> --%>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox" />
<ap:jsTag type="tech" items="msg,util, cmn , mainn, subb, font" />

<script type="text/javascript">
 
$(document).ready(function(){
	
	// 입사지원 버튼
 	$("#btn_apply").click(function(){
		<c:choose>
		<c:when test="${not empty pblancMap.ECNY_APPLY_DIV and (pblancMap.ECNY_APPLY_DIV == 'F' or pblancMap.ECNY_APPLY_DIV == 'W')}">
			<c:choose>
			<c:when test="${fn:startsWith(pblancMap.ECNY_APPLY__WEB_ADRES, 'http')}">
			window.open("${pblancMap.ECNY_APPLY__WEB_ADRES}","applyWeb","width=570,height=420, scrollbars=yes, resizable=yes");
			</c:when>
			<c:otherwise>
			window.open("http://${pblancMap.ECNY_APPLY__WEB_ADRES}","applyWeb","width=570,height=420, scrollbars=yes, resizable=yes");
			</c:otherwise>
			</c:choose>
		</c:when>
		<c:otherwise>
	 		<c:if test="${not empty sessionScope[SESSION_USERINFO_NAME]}">
			$("#df_method_nm").val("applyCmpnyForm");
			$("#dataForm").submit();
			</c:if>
			<c:if test="${empty sessionScope[SESSION_USERINFO_NAME]}">
			opener.jsMoveMenu(24, 25, 'PGCMLOGIO0010');
			self.close();
			</c:if>
	 	</c:otherwise>
		</c:choose>
 	});
}); // ready

var wc300_popup = function() {
	window.open("/popup/wc300Popup.html","event20150825","width=390,height=660, left=10, top=24, scrollbars=no, resizable=no");	
};

var atc_popup = function() {
	window.open("/popup/atcPopup.html","event20150825","width=390,height=660, left=10, top=24, scrollbars=no, resizable=no");	
};

</script>

</head>
<body>

	<c:set value="${pblancMap.iem22 }" var="iem22" />
	<%-- 근무지역 --%>
	<c:set value="${pblancMap.iem25 }" var="iem25" />
	<%-- 경력 --%>
	<c:set value="${pblancMap.iem27 }" var="iem27" />
	<%-- 학력 --%>
	<c:set value="${pblancMap.iem31 }" var="iem31" />
	<%-- 모집직급 --%>
	<c:set value="${pblancMap.iem32 }" var="iem32" />
	<%-- 모집직책 --%>
	<c:set value="${pblancMap.iem33 }" var="iem33" />
	<%-- 근무형태 --%>
	<c:set value="${pblancMap.iem51 }" var="iem51" />
	<%-- 모집인원 --%>
	<c:set value="${pblancMap.iem52 }" var="iem52" />
	<%-- 나이 --%>

	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">

		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />

		<input type="hidden" id="ad_empmn_manage_no" name="ad_empmn_manage_no"
			value="${param.ad_empmn_manage_no }" />

		<div id="hire01" class="modal">
			<div class="modal_wrap">
				<div class="modal_cont">
					<table class="table_form" style="table-layout: fixed;width:100%;">
						<caption>채용정보 상세보기</caption>
						<colgroup>
							<col width="*">
							<col width="145px">
							<col width="168px">
							<col width="145px">
							<col width="168px">
						</colgroup>
						<thead>
							<tr>
								<th colspan="7" scope="colgroup">${pblancMap.EMPMN_SJ }</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td rowspan="5" class="t_center"><c:choose>
										<c:when test="${not empty intrcnMap.LOGO_FILE_SN }">
											<img
												src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${intrcnMap.LOGO_FILE_SN}" />"
												alt="로고" width="250" height="100" />
										</c:when>
										<c:otherwise>
											<img src="<c:url value="/images/cs/logo.png"/>" id="img_photo" alt="로고" width="250"
												height="100" />
										</c:otherwise>
									</c:choose>
									</li>
									<li class="tac">
										<h4>${intrcnMap.ENTRPRS_NM }</h4>
								<th scope="col">상장여부</th>
								<td>${intrcnMap.LST_AT_NM }</td>
								<th scope="col">기업형태</th>
								<td>${intrcnMap.ENTRPRS_STLE_NM }</td>
							</tr>
							<tr>
								<th scope="col" style="border-left: 1px solid #dadada;">기업인증</th>
								<td class="b_l_0" colspan="3">${intrcnMap.ENTRPRS_CRTFC_NM }</td>
							</tr>
							<tr>
								<th style="border-left: 1px solid #dadada;">기업특성</th>
								<td class="b_l_0" colspan="3"><c:forEach items="${chartr}" var="chartr"
										varStatus="status">
										<c:if test="${chartr.CHARTR_CODE == '1'}">
											<span class="ico_k"></span>${chartr.CHARTR_NM}
                 		</c:if>
										<c:if test="${chartr.CHARTR_CODE == '2'}">
											<a href="#none" onclick="wc300_popup();"><span class="ico_w">${chartr.CHARTR_NM}</span></a>
										</c:if>
										<c:if test="${chartr.CHARTR_CODE == '3'}">
											<a href="#none" onclick="atc_popup();"><span class="ico_a">${chartr.CHARTR_NM}</span></a>
										</c:if>
										<c:if test="${chartr.CHARTR_CODE == '4'}">
											<span class="ico_c"></span>${chartr.CHARTR_NM}
                 		</c:if>
										<c:if test="${chartr.CHARTR_CODE == '5'}">
											<span class="ico_d"></span>${chartr.CHARTR_NM}
                 		</c:if>
									</c:forEach></td>
							</tr>
							<tr>
								<th style="border-left: 1px solid #dadada;">전화번호</th>
								<td class="b_l_0"><c:if test="${not empty intrcnMap.TELNO1 }">							
						${intrcnMap.TELNO1 } - ${intrcnMap.TELNO2 } - ${intrcnMap.TELNO3 }
		        	</c:if></td>
								<th>팩스번호</th>
								<td class="b_l_0"><c:if test="${not empty intrcnMap.FXNUM1 }">
                		${intrcnMap.FXNUM1 }-${intrcnMap.FXNUM2 }-${intrcnMap.FXNUM3 }
                	</c:if></td>
							</tr>
							<tr>
								<th style="border-left: 1px solid #dadada;" scope="col">주소</th>
								<td class="b_l_0" colspan="3">${intrcnMap.HEDOFC_ZIP }${intrcnMap.HEDOFC_ADRES }</td>
							</tr>
						</tbody>
					</table>
					<div class="list_bl" style="margin-bottom: 20px;">
						<h4 class="fram_bl">모집요강</h4>
						<table class="table_form" style="margin-bottom: 20px;">
							<caption>채용정보 상세보기</caption>
							<colgroup>
								<col width="172px">
								<col width="367px">
								<col width="173px">
								<col width="367px">
							</colgroup>
							<tbody>
								<tr>
									<th>신청 시작일</th>
									<td class="b_l_0">${pblancMap.RCRIT_BEGIN_DE }~ ${pblancMap.RCRIT_END_DE }</td>
									<th>모집인원</th>
									<td class="b_l_0"><c:choose>
											<c:when test="${iem51[0].IEM_VALUE != 'WKN' }">
												<c:choose>
													<c:when test="${iem51[0].IEM_VALUE == 'A' }">${iem51[0].ATRB1}명</c:when>
													<c:otherwise>${iem51[0].CODE_NM}</c:otherwise>
												</c:choose>
											</c:when>
											<c:otherwise>
	                	${iem51[0].ATRB3}명
	                </c:otherwise>
										</c:choose></td>
								</tr>
								<tr>
									<th>경력</th>
									<td class="b_l_0"><c:forEach items="${iem25 }" var="iem25" varStatus="status">
											<c:if test="${not status.first }">,</c:if>
											<c:choose>
												<c:when test="${iem25.IEM_VALUE != 'WKN' }">${iem25.CODE_NM }</c:when>
												<c:otherwise>${iem25.ATRB3}</c:otherwise>
											</c:choose>
											<c:if test="${iem25.IEM_VALUE == 'CK2' }">(${iem25.ATRB1 }년 이상 ~ ${iem25.ATRB2 }년 미만)</c:if>
										</c:forEach></td>
									<th>근무형태</th>
									<td class="b_l_0"><c:forEach items="${iem33 }" var="iem33" varStatus="status">
											<c:if test="${not status.first }">,</c:if>
											<c:choose>
												<c:when test="${iem33.IEM_VALUE != 'WKN' }">${iem33.CODE_NM }</c:when>
												<c:otherwise>${iem33.ATRB3}</c:otherwise>
											</c:choose>
										</c:forEach></td>
								</tr>
								<tr>
									<th>학력</th>
									<td class="b_l_0"><c:choose>
											<c:when test="${iem27[0].IEM_VALUE != 'WKN' }">${iem27[0].CODE_NM }</c:when>
											<c:otherwise>${iem27[0].ATRB3}</c:otherwise>
										</c:choose> <c:if test="${iem27[0].ATRB1 == 'Y' }"> (졸업예정자 가능)</c:if></td>
									<th>나이</th>
									<td class="b_l_0"><c:forEach items="${iem52 }" var="iem52" varStatus="status">
											<c:if test="${not status.first }">,</c:if>
                		${iem52.CODE_NM }
                	</c:forEach></td>
								</tr>
								<tr>
									<th>근무지역</th>
									<td class="b_l_0" colspan="3"><c:forEach items="${iem22 }" var="iem22"
											varStatus="status">
											<c:if test="${not status.first }">,</c:if>
											<c:choose>
												<c:when test="${iem22.IEM_VALUE != 'WKN' }">${iem22.CODE_NM }</c:when>
												<c:otherwise>${iem22.ATRB3}</c:otherwise>
											</c:choose>
										</c:forEach></td>
								</tr>
								<tr>
									<th>모집직종</th>
									<td class="b_l_0" colspan="3">${pblancMap.JSSFC }</td>
								</tr>
								<tr>
									<th>모집직급</th>
									<td class="b_l_0"><c:forEach items="${iem31 }" var="iem31" varStatus="status">
											<c:if test="${not status.first }">,</c:if>
											<c:choose>
												<c:when test="${iem31.IEM_VALUE != 'WKN' }">${iem31.CODE_NM }</c:when>
												<c:otherwise>${iem31.ATRB3}</c:otherwise>
											</c:choose>
										</c:forEach></td>
									<th>모집직책</th>
									<td class="b_l_0"><c:forEach items="${iem32 }" var="iem32" varStatus="status">
											<c:if test="${not status.first }">,</c:if>
											<c:choose>
												<c:when test="${iem32.IEM_VALUE != 'WKN' }">${iem32.CODE_NM }</c:when>
												<c:otherwise>${iem32.ATRB3}</c:otherwise>
											</c:choose>
										</c:forEach></td>
								</tr>
								<%-- <tr>
									<th scope="col">우대조건</th>
									<td colspan="3">${pblancMap.PVLTRT_CND }</td>
								</tr> --%>
								<tr>
									<th>업무내용</th>
									<td class="b_l_0" colspan="3">${pblancMap.JOB_CN }</td>
								</tr>
								<tr>
									<th>경력요건</th>
									<td class="b_l_0" colspan="3">${pblancMap.CAREER_DETAIL_RQISIT }</td>
								</tr>
							</tbody>
						</table>
					<c:if test="${adminAuth != 'Y'}">
					</div>
						<div class="btn_bl">
							<a class="btn_page_blue" href="#" id="btn_apply"><span>입사지원</span></a>
						</div>
					</c:if>
				</div>
			</div>
		</div>

	</form>

</body>
</html>