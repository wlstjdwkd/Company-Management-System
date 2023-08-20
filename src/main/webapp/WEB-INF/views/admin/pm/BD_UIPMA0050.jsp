<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
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
<ap:jsTag type="web"
	items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,selectbox,blockUI" />
<ap:jsTag type="tech" items="acm,msg,util,etc" />

<!-- 리얼그리드 라이브러리 -->
<script type="text/javascript" src="${contextPath}/script/realgrid.2.5.0/realgrid.2.5.0.min.js"></script>
<link rel="stylesheet" type="text/css" href="${contextPath}/script/realgrid.2.5.0/realgrid-style.css"/>
<link rel="stylesheet" href="${contextPath}/css/gridAlign.css"/>
<script src="${contextPath}/script/realgrid.2.5.0/libs/jszip.min.js"></script>
<script src="${contextPath}/script/realgrid.2.5.0/realgrid-lic.js"></script>

<script src="/gridDef/pm/PayMntGrid.js"></script>

<script type="text/javascript">
	$(document).ready(function(){
		
		$("#search_year").numericOptions({from:2002,to:${frontParam.curr_year},sort:"desc"});
		
		//직원 찾기
		$("#popEmp").click(function() {
			$.colorbox({
				title : "직원 찾기",
				href : "PGPM0030.do?df_method_nm=goEmpList",		
				width : "40%",
				height : "70%",
				overlayClose : false,
				escKey : false,
				iframe : true
			});
		});
	});
		 
	//해당 직원의 년도 급여 검색
	function searchEmployeeSalary(){
		//직원란이 비어있지 않을 때만 작동
		var codeNo = $("#ad_employee_code").val();
		if(codeNo != null && codeNo != "") {
			//
			payMntDataProvider.clearRows();
		
			//월별급여 조회
			$.ajax({
				type : "POST",
				url : "PGPM0050.do",
				data : { "df_method_nm"		: "processPayMntTree"			//작동하는 메서드 명
					, "ad_employee_code"	: $("#ad_employee_code").val()	//사원번호
					, "search_year"			: $("#search_year").val()		//선택한 년도
				},
				error : function(error) {
					console.log("error");
				},
				success : function(data) {
					console.log("success");
					console.log(data);
					var treeData = JSON.parse(data);
					payMntDataProvider.setRows(treeData, "treeId", true);	
					
					payMntGridView.expandAll();
				}
			});
		}
	}
		
	// 엑셀다운로드
	function downloadExcel() {
		payMntGridView.exportGrid({
		    type: "excel",
		    target: "local",
		    fileName: $("#search_year").val() + "년 " + $("#ad_employee_name").val() +" 월별급여조회.xlsx",
		    indicator: "default",
		    header: "default",
		    footer: "default",
		    allItems: true,
		    compatibility: true,
		    done: function () {  //내보내기 완료 후 실행되는 함수
				//alert("done excel export")
			}
		});
	}
</script>
</head>

<body>
	<form name="dataForm" id="dataForm" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />

		<input type="hidden" name="emp_no" id="emp_no" /> <input type="hidden"
			id="init_search_yn" name="init_search_yn" value="N" />

		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title">월별급여조회</h2>
					<!-- 타이틀 영역 //-->
					
					<!--// 검색 조건  -->
					<div class="search_top">
						<table cellpadding="0" cellspacing="0" class="table_search" style="empty-cells: show;"
							summary="프로그램관리 검색">
							<caption>검색</caption>
							<colgroup>
								<col width="15%" />
								<col width="*" />
								<col width="*" />
							</colgroup>
							<tr>
								<th scope="row">조회시기</th>
								<td><select id="search_year" name="search_year" title="조회년도" style="width:100px">
                                    </select> 년 </td>
								<td>
								<th scope="row">직원</th>
								<td><input name="ad_employee_code" id="ad_employee_code"
									type="text" style="width: 100px; background-color: #aaa5;" readonly/> </td>
								<td><input name="ad_employee_name" id="ad_employee_name"
									type="text" style="width: 100px; background-color: #aaa5;" readonly/> </td>
								<td><p class="btn_src_zone">
										<a href="#" class="btn_search" onclick="searchEmployeeSalary()">검색</a>
									</p>
									<p class="btn_src_zone">
										<a href="#" class="btn_search" id="popEmp">직원</a>
									</p></td>
							</tr>
						</table>
					</div>
					<!-- 검색 조건// -->
					
					<p style="text-align: right;">(금액단위: 원)</p>
					
					<div class="block">
						<!--// 리스트 -->
						<div class="container-fluid">
							<div id="MNTpaygrid" style="height: 500px; background-color: white;">
							</div> 
						</div>
						<!-- 리스트// -->
						
						<div class="btn_page_last">
							<a class="btn_page_admin" href="#" onclick="downloadExcel();"><span>엑셀다운로드</span></a>
						</div>
					</div>
				</div>
				
			</div>
		</div>
		<!--content//-->

	</form>
</body>
</html>