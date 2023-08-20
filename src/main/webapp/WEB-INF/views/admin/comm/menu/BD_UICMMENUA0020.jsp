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
			btn_menu_get_list();
		}
	}

	/*
	* 목록 검색
	*/
	function btn_menu_get_list() {
		var form = document.dataForm;

		form.df_curr_page.value = 1;
		form.df_method_nm.value = "";
		form.submit();
	}
	
	/* 
	 * 등록 처리 함수
	 */
	function btn_menu_get_regist_view() {
		var form = document.dataForm;
		form.df_method_nm.value = "getMenuRegist";
		form.submit();
	}
	
	/* 
	 * 수정화면 함수
	 */
	function btn_menu_get_modify_view(menuNo) {
		var form = document.dataForm;
		form.df_method_nm.value = "getMenuModify";
		document.getElementById("ad_menoNo").value = menuNo;
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
		
		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title">메뉴관리</h2>
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
								<ap:code id="searchSiteSe" grpCd="1" type="select"	selectedCd="${param.searchSiteSe}" defaultLabel="사이트구분전체"/> 
										<input name="searchMenuNm" id="searchMenuNm" type="text"style="width: 300px;" title="검색어 입력" placeholder="메뉴명을 입력하세요."
									value='<c:out value="${param.searchMenuNm}"/>' onkeypress="press(event);" />
									<p class="btn_src_zone">
										<a href="#none" class="btn_search" onclick="btn_menu_get_list()">검색</a>
									</p></td>
							</tr>
						</table>
					</div>
					<div class="block">
						<ap:pagerParam />
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
									<col width="*" />
									<col width="*" />
									<col width="*" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col">번호</th>
										<th scope="col">메뉴명</th>
										<th scope="col">프로그램명</th>
										<th scope="col">메뉴레벨</th>
										<th scope="col">출력유형</th>
										<th scope="col">출력여부</th>
										<th scope="col">사이트구분</th>
										<th scope="col">사용여부</th>
									</tr>
								</thead>
								<tbody>
									<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
									<c:if test="${fn:length(menuList) == 0}">
										<tr>
											<td colspan="8"><c:if test="${param.searchSiteSe == '' || param.searchMenuNm == ''}">
													<spring:message code="info.nodata.msg" />
												</c:if> <c:if test="${param.searchSiteSe != '' || param.searchMenuNm != ''}">
													<spring:message code="info.noresult.msg" />
												</c:if></td>
										</tr>
									</c:if>
									<%-- 데이터를 화면에 출력해준다 --%>
									<c:forEach items="${menuList}" var="menuList" varStatus="status">
										<tr>
											<td>${pagerNo-(status.index)}</td>
											<td>
												<c:forEach var="i" begin="1" end="${menuList.menuLevel}"><c:out value="&nbsp;&nbsp;&nbsp;&nbsp;" escapeXml="false" /></c:forEach>
												<a href="#none" class="btn_in_gray"	onclick="btn_menu_get_modify_view('<c:out value="${menuList.menuNo}"/>');"><span>${menuList.menuNm}</span></a>
											</td>
											<td class="tal">${menuList.progrmNm}</td>
											<td>${menuList.menuLevel}</td>
											<td>${menuList.outptAt}</td>
											<td>${menuList.outptTyNm}</td>
											<td>${menuList.siteSeNm}</td>
											<td>${menuList.useAt}</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<!-- 리스트// -->
						<div class="btn_page_last">
							<a class="btn_page_admin" href="#none" onclick="btn_menu_get_regist_view()"><span>등록</span></a>
						</div>
						<!--// paginate -->
						<ap:pager pager="${pager}" />
						<!-- paginate //-->
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>