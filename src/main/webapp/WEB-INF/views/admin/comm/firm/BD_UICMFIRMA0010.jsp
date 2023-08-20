<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>석유관리원 환급시스템</title>

<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,blockUI" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javascript">

	$(document).ready(function() {
		// 엑셀 다운로드
		$("#btn_excel_down").click(function(){
			$("#df_method_nm").val("processExcelRsolver");
			$("#dataForm").submit();
		});

		// 화면 초기화
		$("#btn_refresh").on('click', function() {
			$("#df_method_nm").val("");
			$("#searchDeptCd").val("");
			$("#searchDeptLevel").val("");
			$("#searchUdeptCd").val("");
			$("#searchDeptUseAt").val("");
			$("#df_row_per_page").val('30');
		    $("#df_curr_page").val('1');
			$("#dataForm").submit();
		});

		// 등록
		$("#btn_regist").on('click', function() {
			$("#registOrUpdate").val("regist");
			var form = document.dataForm;
			form.df_method_nm.value = "registOrUpdate";
			form.submit();
		});
	});

	// 수정
	function btn_update(idx) {
		var form = document.dataForm;
		form.df_method_nm.value = "registOrUpdate";
		form.deptCd.value = $("#dept_" + idx).text().trim();
		form.registOrUpdate.value = "update";
		form.submit();
	}

	// 검색단어 입력 후 엔터 시 자동 submit
	function press(event) {
		if (event.keyCode == 13) {
			btn_joinLog_get_list();
		}
	}

	// 검색
	function btn_list() {
		$.blockUI({message:$("#loading")});
		var form = document.dataForm;
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

		<input type="hidden" name="registOrUpdate" id="registOrUpdate" />
		<input type="hidden" name="deptCd" id="deptCd" />

   		<!--//content-->
	    <div id="wrap">
	        <div class="wrap_inn">
	            <div class="contents">
	                <!--// 타이틀 영역 -->
	                <div class="r_top">
	                	<h2>부서 목록</h2>
	                	<ul class="icon_menu">
							<li style="display: inline-block;"><a href="#" id="btn_excel_down"><img src="/images/common/down.png" alt="다운로드"><span>다운로드</span></a></li>
						</ul>
	                </div>
	                <!-- 타이틀 영역 //-->
	                <div class="btn_page_total">
	                	<a class="btn_page_admin" href="#none" id="btn_refresh"><span>화면초기화</span></a>
						<a class="btn_page_admin registOrUpdate" href="#none" id="btn_regist"><span>등록</span></a>
					</div>
					<!-- // 검색 조건 -->
					<div class="search_zone search_top" style="margin-top:20px;">
						<table cellpadding="0" cellspacing="0" summary="검색조건">
							<caption>검색</caption>
							<colgroup>
								<col width="1px">
								<col width="1px">
								<col width="1px">
								<col width="1px">
								<col width="1px">
								<col width="1px">
								<col width="1px">
								<col width="1px">
								<col width="*">
							</colgroup>
							<tr>
								<td class="td_search_grey">부서명</td>
								<td>
									<select name="searchDeptCd" id="searchDeptCd">
										<option value="">- 선택 -</option>
										<c:forEach items="${deptAllList}" var="deptAll" varStatus="status">
											<option value="${deptAll.deptCd}" <c:if test="${paramMap.searchDeptCd eq deptAll.deptCd}">selected</c:if> >${deptAll.deptCd} &nbsp;&nbsp;&nbsp;&nbsp; ${deptAll.deptNm}</option>
										</c:forEach>
									</select>
								</td>
								<td class="td_search_grey">부서레벨</td>
								<td>
									<select name="searchDeptLevel" id="searchDeptLevel">
										<option value="">- 선택 -</option>
										<option value="1" <c:if test="${paramMap.searchDeptLevel eq '1'}">selected</c:if> >1</option>
										<option value="2" <c:if test="${paramMap.searchDeptLevel eq '2'}">selected</c:if> >2</option>
										<option value="3" <c:if test="${paramMap.searchDeptLevel eq '3'}">selected</c:if> >3</option>
									</select>
								</td>
								<td class="td_search_grey">상위부서</td>
								<td>
									<select name="searchUdeptCd" id="searchUdeptCd">
										<option value="">- 선택 -</option>
										<c:forEach items="${deptAllList}" var="deptAll" varStatus="status">
											<option value="${deptAll.deptCd}" <c:if test="${paramMap.searchUdeptCd eq deptAll.deptCd}">selected</c:if> >${deptAll.deptCd} &nbsp;&nbsp;&nbsp;&nbsp; ${deptAll.deptNm}</option>
										</c:forEach>
									</select>
								</td>
								<td class="td_search_grey">사용여부</td>
								<td>
									<select name="searchDeptUseAt" id="searchDeptUseAt">
										<option value="">- 선택 -</option>
										<option value="Y" <c:if test="${paramMap.searchUseAt eq 'Y'}">selected</c:if> >Y</option>
										<option value="N" <c:if test="${paramMap.searchUseAt eq 'N'}">selected</c:if> >N</option>
									</select>
								</td>
								<td>
									<p class="btn_src_zone">
										<a href="#none" class="btn_search" onclick="btn_list()">검색</a>
									</p>
								</td>
							</tr>
						</table>
					</div>
					<!-- 검색 조건 // -->
	                <div class="block" style="margin-top: 20px;">
						<ap:pagerParam />
						<!-- // 리스트 영역 -->
						<div class="list_zone">
							<table cellspacing="0" border="0" summary="부서 관리 리스트">
								<caption>부서 관리</caption>
								<colgroup>
									<%-- <col width="3%" /> --%>
									<col width="4%" />
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
										<th scope="col">부서코드</th>
										<th scope="col">부서명</th>
										<th scope="col">부서레벨</th>
										<th scope="col">상위부서</th>
										<th scope="col">사용여부</th>
										<th scope="col">등록일</th>
										<th scope="col">수정일</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${resultList}" var="dept" varStatus="status">
										<tr>
											<td class="tac">${pager.totalRowCount-(pager.totalRowCount-(pager.pageNo-1)*(pager.rowSize)-status.index) + 1}</td>
											<td class="tac" id="dept_${status.index+1}">
												<a href="#none" onclick="btn_update(${status.index+1})"><U>${dept.deptCd}</U></a>
											</td>
											<td class="tal">
												<a href="#none" onclick="btn_update(${status.index+1})"><U>${dept.deptNm}</U></a>
											</td>
											<td class="tac">${dept.deptLevel}</td>
											<td class="tac">
												<c:if test="${dept.udeptNm ne null}">${dept.udeptNm}</c:if>
												<c:if test="${dept.udeptNm eq null}">-</c:if>
											</td>
											<td class="tac">${dept.useAt}</td>
											<td class="tac">${dept.rgsDe}</td>
											<td class="tac">
												<c:if test="${dept.updDe ne null}">${dept.updDe}</c:if>
												<c:if test="${dept.updDe eq null}">-</c:if>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<div style="margin-top: 20px;">
							<ap:pager pager="${pager}" />
						</div>
					</div>
	                <!-- 리스트영역 // -->
	            </div>
	        </div>
	        <!--content//-->
		</div>
	</form>
	<!-- loading -->
	<div style="display:none">
		<div class="loading" id="loading">
			<div class="inner">
				<div class="box">
			    	<p>
			    		<span id="load_msg">진행 중 입니다. 잠시만 기다려주십시오.</span>
			    		<br />시스템 상태에 따라 최대 1분 정도 소요될 수 있습니다.
					</p>
					<span><img src="<c:url value="/images/etc/loading_bar.gif" />" width="323" height="39" alt="loading" /></span>
				</div>
			</div>
		</div>
	</div>
	<!-- loading -->
</body>
</html>