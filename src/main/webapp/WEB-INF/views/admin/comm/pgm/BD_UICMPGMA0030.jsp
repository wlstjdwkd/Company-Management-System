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
<c:if test="${resultMsg != null}">
$(function(){
	jsMsgBox(null, "info", "${resultMsg}");
});
</c:if>
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
		form.df_method_nm.value = "";
		form.submit();
	}
	
	/* 
	 * 등록 화면 이동
	 */
	function btn_program_regist_view() {
		var form = document.dataForm;
		form.df_method_nm.value = "programRegist";
		form.submit();
	}
	/* 
	 * 수정,취소 화면 이동
	 */
	function btn_program_modify_view(progrmId) {
		var form = document.dataForm;
		form.df_method_nm.value = "programModify";
		document.getElementById("ad_progrmId").value = progrmId;
		form.submit();
	}
</script>
</head>

<body>
	<form name="dataForm" id="dataForm" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />

		<input type="hidden" name="ad_progrmId" id="ad_progrmId" />

		
		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title">프로그램관리</h2>
					<!-- 타이틀 영역 //-->
					<!--// 검색 조건 -->
					<div class="search_top">
						<table cellpadding="0" cellspacing="0" class="table_search" summary="프로그램관리 검색">
							<caption>검색</caption>
							<colgroup>
								<col width="100%" />
							</colgroup>
							<tr>
								<td class="only"><ap:code id="searchJobSe" grpCd="4" type="select"
										selectedCd="${param.searchJobSe}" defaultLabel="전체분류" /> <input
									name="searchProgramNm" id=searchProgramNm type="text" style="width: 300px;" title="검색어 입력"
									placeholder="프로그램명을 입력하세요." onkeypress="press(event);" value = "${param.searchProgramNm}"/>
									<p class="btn_src_zone">
										<a href="#" class="btn_search" onclick="btn_program_get_list()">검색</a>
									</p></td>
							</tr>
						</table>
					</div>
					<div class="block">
						<ap:pagerParam />
						<!--// 리스트 -->
						<div class="list_zone">
							<table cellspacing="0" border="0" summary="프로그램관리 리스트">
								<caption>프로그램관리</caption>
								<colgroup>
									<col width="10%" />
									<col width="20%" />
									<col width="15%" />
									<col width="30%" />
									<col width="15%" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col">번호</th>
										<th scope="col">프로그램ID</th>
										<th scope="col">프로그램명</th>
										<th scope="col">업무구분</th>
										<th scope="col"><p>서비스여부</p></th>
									</tr>
								</thead>
								<tbody>
									<c:if test="${fn:length(programList) == 0}">
										<tr>
											<td colspan="8"><c:if test="${param.searchJobSe == '' || param.searchProgramNm == ''}">
													<spring:message code="info.nodata.msg" />
												</c:if> <c:if test="${param.searchJobSe != '' || param.searchProgramNm != ''}">
													<spring:message code="info.noresult.msg" />
												</c:if></td>
										</tr>
									</c:if>
									<c:forEach items="${programList}" var="programList" varStatus="status">
										<tr>
											<td >${pagerNo-(status.index)}</td>
											<td><a href="#" class="btn_in_gray" onclick="btn_program_modify_view('<c:out value="${programList.progrmId}"/>');"><span>${programList.progrmId}</span></a>
											</td>
											<td class="tal">${programList.progrmNm}</td>
											<td class="tal">${programList.jobSeNm}</td>
											<td>${programList.svcAt}</td>
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
				</div>
				<!--content//-->
			</div>
		</div>
	</form>
</body>
</html>