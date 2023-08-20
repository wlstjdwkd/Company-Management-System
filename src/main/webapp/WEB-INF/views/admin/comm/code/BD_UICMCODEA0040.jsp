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
			btn_code_get_list();
		}
	}

	/*
	* 목록 검색
	*/
	function btn_code_get_list() {
		var form = document.dataForm;
		if($("#searchCondition").val() != "" && $("#searchKeyword").val() == "") {
			jsMsgBox(null, 'error', Message.template.required('검색구분'));
			return;	
		}
		if($("#searchCondition").val() == "" && $("#searchKeyword").val() != "") {
			jsMsgBox(null, 'error', Message.template.required('검색구분'));
			return;	
		}
		
		form.df_curr_page.value = 1;
		form.df_method_nm.value = "";
		form.submit();
	}
	
	/* 
	 * 등록 처리 함수
	 */
	function btn_code_get_regist_view() {
		var form = document.dataForm;
		form.df_method_nm.value = "codeInsertForm";
		form.submit();
	} 
	
	/* 
	 * 수정화면 함수
	 */
	function btn_code_get_modify_view(codeGroupNo) {
		var form = document.dataForm;
		
		document.getElementById("codeGroupNo").value = codeGroupNo;
		form.df_method_nm.value = "codeUpdateForm";
		form.submit();
	}
</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />

		<input type="hidden" name="codeGroupNo" id="codeGroupNo" />

		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title">코드관리</h2>
					<!-- 타이틀 영역 //-->

					<!--// 검색 조건 -->
					<div class="search_top">
						<table cellpadding="0" cellspacing="0" class="table_search" summary="코드관리 검색">
							<caption>검색</caption>
							<colgroup>
								<col width="100%" />
							</colgroup>
							<tr>
								<td class="only"><select name="searchCondition" id="searchCondition" title="검색조건선택"
									style="width: 150px">
										<option value="">선택하세요</option>
										<option value="codeGroupNm"
											<c:if test="${param.searchCondition == 'codeGroupNm'}">selected="selected"		</c:if>>코드명</option>
										<option value="code"
											<c:if test="${param.searchCondition == 'code'}">selected="selected"		 		 </c:if>>하위코드</option>
										<option value="codeNm"
											<c:if test="${param.searchCondition == 'codeNm'}">selected="selected"		     </c:if>>하위코드명</option>
								</select> <input type="text" name="searchKeyword" id="searchKeyword" title="검색어 입력"
									style="width: 290px;" placeholder="검색어를 입력하세요." value='<c:out value="${param.searchKeyword}"/>'
									maxlength="35" onkeypress="press(event);" />
									<p class="btn_src_zone">
										<a href="#none" class="btn_search" onclick="btn_code_get_list();">검색</a>
									</p></td>
							</tr>
						</table>
					</div>
					<div class="block">
						<ap:pagerParam />
						<!--// 리스트 -->

						<div class="list_zone">
							<table cellspacing="0" border="0" summary="코드관리 리스트">
								<caption>코드관리</caption>
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
										<th scope="col">코드명</th>
										<th scope="col">하위코드 개수</th>
										<th scope="col">코드설명</th>
										<th scope="col">등록일</th>
									</tr>
								</thead>
								<tbody>
									<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
									<c:if test="${fn:length(codeGroupList) == 0}">
										<tr>
											<td colspan="5"><c:if test="${param.searchKeyword == '' }">
													<spring:message code="info.nodata.msg" />
												</c:if> <c:if test="${param.searchKeyword != '' }">
													<spring:message code="info.noresult.msg" />
												</c:if></td>
										</tr>
									</c:if>
									<%-- 데이터를 화면에 출력해준다 --%>
									<c:forEach items="${codeGroupList}" var="codeGroupList" varStatus="status">
										<tr>
											<td>${pager.totalRowCount-(pager.pageNo-1)*(pager.rowSize)-status.index }</td>
											<td class="tal"><a href="#none" class="btn_in_gray"
												onclick="btn_code_get_modify_view(${codeGroupList.codeGroupNo});"><span>${codeGroupList.codeGroupNm}</span></a>
											</td>
											<td class="tar">${codeGroupList.codeCnt}</td>
											<td class="tal">${codeGroupList.codeGroupDc}</td>
											<td>${codeGroupList.rgsde}</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>

						</div>

					</div>
					<!-- 리스트// -->
					<div class="btn_page_last">
						<a class="btn_page_admin" href="#none" onclick="btn_code_get_regist_view();"><span>등록</span></a>
					</div>
					<!--// paginate -->
					<ap:pager pager="${pager}" />
					<!-- paginate //-->
				</div>
			</div>
		</div>
		<!--//content-->
	</form>
</body>
</html>