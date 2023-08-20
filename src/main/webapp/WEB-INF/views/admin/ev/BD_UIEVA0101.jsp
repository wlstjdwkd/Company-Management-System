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
<title>직원평가</title>
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask,selectbox" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javascript"></script>
<script type="text/javascript" src="${contextPath}/script/jquery/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="${contextPath}/script/dhtmlxSuite/codebase/dhtmlx.js"></script>
<link rel="stylesheet" type="text/css" href="${contextPath}/script/dhtmlxSuite/codebase/dhtmlx.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/nimbleRes/js/nimblegw.css"/>
<script type="text/javascript" src="${contextPath}/nimbleRes/js/dhtmlpost.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/nimbleRes/js/logKey.js"></script>
</head>
<%
	String a = JSON.stringify()
%>
<body>
	<form name="dataForm1" id="dataForm1" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />

<%-- 		<input type="hidden" name="insert_update" id="insert_update" value="UPDATE" /> 
		<input type="hidden" name="df_curr_page" id="df_curr_page" value="${indexValue.df_curr_page}"> 
		<input type="hidden" name="df_row_per_page" id="df_row_per_page" value="${indexValue.df_row_per_page}">
		<input type="hidden" name="empno" id="empno" value="${userInfo.EMP_NO}" />
		<input type="hidden" name="empnm" id="empnm" value="${userInfo.EMP_NM}" />
		<input type="hidden" name="cizno" id="cizno" value="${userInfo.CIZ_NO}" />
		<input type="hidden" name="incodt" id="incodt" value="${userInfo.INCO_DT}" />
		<input type="hidden" name="outcodt" id="outcodt" value="${userInfo.OUTCO_DT}" />
		<input type="hidden" name="bdt" id="bdt" value="${userInfo.INCO_DT}" />
		 --%>
		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title_line">직원평가</h2>
					<!-- 타이틀 영역 //-->
					<div class="block">
						<!--// 등록 -->
						<table cellpadding="0" cellspacing="0" class="table_basic mgt10" summary="프로그램등록">
							<caption>직원 정보</caption>
							<colgroup>
								<col width="15%" />
								<col width="30%" />
								<col width="15%" />
								<col width="*" />
							</colgroup>
							<!-- 직원 정보 등록 -->
							<tr>
								<th scope="row" class="point">사원번호</th>
								<td>${member} </td>
								<th scope="row" class="point">이름</th>
								<td>${member}</td>
							</tr>
							<tr>
								<th scope="row" class="point">직급</th>
								<td>${member}</td>
								<th scope="row" class="point">평가점수</th>
								<td >공백</td>
							</tr>
						</table>
						<!-- 직원 정보 -->
						</div>
					<!--리스트영역 //-->
				</div>
			</div>
			<!--content//-->
		</div>
	</form>
	
	<form name="dataForm2" id="dataForm2" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />

		<input type="hidden" name="ad_PK" id="ad_PK" />
		<input type="hidden" id="init_search_yn" name="init_search_yn" value="N" />
		
		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<!-- <h2 class="menu_title">평가 조회</h2> -->
					<!-- 타이틀 영역 //-->
					<div class="block">
						<ap:pagerParam />
						<!--// 리스트 -->
						<div class="list_zone">
							<table cellspacing="0" border="0" summary="평점관리 리스트">
								<caption>평점관리</caption>
								<colgroup>
									<col width="10%" />
									<col width="60%" />
									<col width="*%" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col">평점</th>
										<th scope="col">한줄평/코맨트</th>
										<th scope="col">작성일자</th>
									</tr>
								</thead>
								<tbody>
									<c:if test="${fn:length(EMP_EVA) == 0}">
										<tr>
											<td colspan="11"><c:if test="${param.searchJobSe == '' || param.searchProgramNm == ''}">
													<spring:message code="info.nodata.msg" />
												</c:if> <c:if test="${param.searchJobSe != '' || param.searchProgramNm != ''}">
													<spring:message code="info.noresult.msg" />
												</c:if></td>
										</tr>
									</c:if>
									<c:forEach items="${evaList}" var="EVA" varStatus="status">
										<tr>
											<td>${EVA.SCORE}</td>
											<td>${EVA.COMMENT}</td>
											<td>${EVA.EVA_DATE}</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<!-- 리스트// -->
						<div class="btn_page_last">
							<a class="btn_page_admin" href="#" onclick="btn_program_regist_view()"><span>등록</span></a>
						</div>
						<!--// paginate -->
						<ap:pager pager="${pager}" />
						<!-- paginate //-->
					</div> 
                  <br>
				</div>
				<!--content//-->
			</div>
		</div>
	</form>
	
	
</body>
</html>