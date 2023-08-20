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
<title>정보</title>
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />


<script type="text/javascript">
	/*
	 * 검색단어 입력 후 엔터 시 자동 submit
	 */
	function press(event) {
		if (event.keyCode == 13) {
			event.preventDefault();
			btn_program_get_list();
		}
	}

	/*
	 * 목록 검색
	 */
	function btn_program_get_list() {
		var form = document.dataForm;

		form.df_curr_page.value = 1;
		form.submit();
	}

	// 팝업검색 결과를 호출자에게 리턴하고 화면을 닫는다.
	function btn_menu_return_program_list(programId, programNm) {
		var opener = parent;

		opener.document.getElementById("ad_programId").value = programId;
		opener.document.getElementById("ad_programNm").value = programNm;

		parent.$.colorbox.close();
	}
</script>
</head>
<body>
	<!--//content-->
	<div id="self_dgs">
		<div class="pop_q_con">
			<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />
				<!-- LNB 출력 방지 -->
				<input type="hidden" id="no_lnb" value="true" />
				<input type="hidden" name="pop_searchSiteSe" id="pop_searchSiteSe" value="${searchSiteSe}"/>
				<!--// 타이틀 영역 -->
				<h2 class="menu_title">프로그램찾기</h2>
				<!-- 타이틀 영역 //-->
				<!--// 검색 조건 -->
				<div class="search_top">
					<table cellpadding="0" cellspacing="0" class="table_search" summary="메뉴명으로 검색">
						<caption>검색</caption>
						<colgroup>
							<col width="100%" />
						</colgroup>
						<tr>
							<td class="only">
							<ap:code id="searchJobSe" grpCd="4" type="select"
									selectedCd="${param.searchJobSe}" defaultLabel="업무구분전체" /> <input name="searchProgramNm"
								type="text" style="width: 300px;" title="검색어 입력" placeholder="프로그램을 입력하세요"
								value='<c:out value="${param.searchProgramNm}"/>' onkeypress="press(event);" />
								<p class="btn_src_zone">
									<a href="#none" class="btn_search" onclick="btn_program_get_list()">검색</a>
								</p></td>
						</tr>
					</table>
				</div>
				<div class="block">
					<ap:pagerParam addJsRowParam="null,'getProgramList'"/>
					<!--// 리스트 -->
					<div class="list_zone">
						<table cellspacing="0" border="0" summary="메뉴명 프로그램명 메뉴레벨 출력유형 출력여부 사이트구분 사용여부 리스트">
							<caption>메뉴관리리스트</caption>
							<colgroup>
								<col width="*" />
								<col width="*" />
								<col width="*" />
								<col width="*" />
								<col width="*" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">프로그램ID</th>
									<th scope="col">프로그램명</th>
									<th scope="col">업무구분</th>
									<th scope="col">서비스여부</th>
									<th scope="col">선택</th>
								</tr>
							</thead>
							<tbody>
								<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
								<c:if test="${fn:length(programList) == 0}">
									<tr>
										<td colspan="5"><c:if
												test="${param.searchJobSe == '' || param.searchProgramNm == ''}">
												<spring:message code="info.nodata.msg" />
											</c:if> <c:if test="${param.searchJobSe != '' || param.searchProgramNm != ''}">
												<spring:message code="info.noresult.msg" />
											</c:if></td>
									</tr>
								</c:if>
								<%-- 데이터를 화면에 출력해준다 --%>
								<c:forEach items="${programList}" var="programList" varStatus="status">
									<tr>
										<td>${programList.progrmId}</td>
										<td class="tal">${programList.progrmNm}</td>
										<td>${programList.jobSeNm}</td>
										<td>${programList.svcAt}</td>
										<td><div class="btn_inner">
												<a href="#none" class="btn_in_gray"
													onclick="btn_menu_return_program_list('<c:out value="${programList.progrmId}"/>', '<c:out value="${programList.progrmNm}"/>'); "><span>선택</span></a>
											</div></td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
					<!-- 리스트// -->
					<div class="mgt10"></div>
					<!--// paginate -->
						<ap:pager pager="${pager}" addJsParam="'getProgramList'" />
					<!-- paginate //-->
				</div>
				<!--content//-->
			</form>
		</div>
	</div>
</body>
</html>