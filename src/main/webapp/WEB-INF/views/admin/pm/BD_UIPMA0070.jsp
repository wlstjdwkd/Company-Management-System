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
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,selectbox,blockUI" />
<ap:jsTag type="tech" items="acm,msg,util,etc" />

<!-- 리얼그리드 라이브러리 -->
<script type="text/javascript" src="${contextPath}/script/realgrid.2.5.0/realgrid.2.5.0.min.js"></script>
<link rel="stylesheet" type="text/css" href="${contextPath}/script/realgrid.2.5.0/realgrid-style.css"/>
<link rel="stylesheet" href="${contextPath}/css/gridAlign.css"/>
<script src="${contextPath}/script/realgrid.2.5.0/libs/jszip.min.js"></script>
<script src="${contextPath}/script/realgrid.2.5.0/realgrid-lic.js"></script>

<script src="${contextPath}/gridDef/pm/SendMailGrid.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		// 조회시기 범위
		$("#search_year").numericOptions({from:2000, to:${frontParam.curr_year}, sort:"desc"});
		$("#search_month").numericOptions({from:01, to:12, namePadding:2, valuePadding:2, sort:"asc"});
		
		// 검색 버튼
		$("#btn_search").click(function() {
			$.ajax({
				type : "POST",
				url : "PGPM0070.do",
				data : { "df_method_nm"	: "searchWorkFile"
					, "is_folder_check"	: "Y"
					, "search_year"		: $("#search_year").val()
					, "search_month"	: $("#search_month").val()},
				error : function(error) {
					console.log("error");
				},
				success : function(data) {
					console.log("success");
					let empMailData = JSON.parse(data);
					mailDataProvider.fillJsonData(empMailData, { fillMode: "set" });
				}
			});
		});
		
		// 전송 버튼
		$("#btn_send_mail").click(function() {
			const rows = mailGridView.getCheckedRows(true);	// 그리드 내 절대 위치 받기
			const rowCnt = rows.length;
			
			if(rowCnt > 0) {								// 선택한 사원들의 주소 받기
				let emplyeeMailArray = [];
				let emplyeeMailJsonObj;
				
				for(let i=0; i < rowCnt; i++) {
					emplyeeMailArray[i] = {
							 "empNo"		: mailDataProvider.getValue(rows[i], "empNo")
							,"comMail"		: mailDataProvider.getValue(rows[i], "comMail")
							,"fileName"		: mailDataProvider.getValue(rows[i], "fileName")
							,"filePath"		: mailDataProvider.getValue(rows[i], "filePath")
							,"makeExcelYn"	: mailDataProvider.getValue(rows[i], "makeExcelYn")
					}
				}
				emplyeeMailJsonObj = {
						"jsonRows" : emplyeeMailArray
				}
				
				$.ajax({
					type : "POST",
					url : "PGPM0070.do",
					data : { "df_method_nm"			: "processSendMail"
							,"search_year"			: $("#search_year").val()
							,"search_month"			: $("#search_month").val()
							,"employee_mail_array"	: JSON.stringify(emplyeeMailJsonObj)},
					error : function(error) {
						console.log("error");
					},
					success : function(data) {
						console.log("success");
						let empMailData = JSON.parse(data);
						mailDataProvider.fillJsonData(empMailData, { fillMode: "set" });
					}
				});
			}
		});
		// 전송 버튼 끝 //
		
		// 개별 엑셀파일 생성 버튼
		$("#btn_make_indv_excel").click(function() {
			const rows = mailGridView.getCheckedRows(true);	// 그리드 내 절대 위치 받기
			const rowCnt = rows.length;
			
			if(rowCnt > 0) {								
				let emplyeeArray = [];						// 사원정보 배열
				let emplyeeJsonObj;							// 사원정보 param
				
				for(let i=0; i < rowCnt; i++) {
					emplyeeArray[i] = {
						  "empNo"		: mailDataProvider.getValue(rows[i], "empNo")
						, "empNm"		: mailDataProvider.getValue(rows[i], "empNm")
						, "makeExcelYn"	: mailDataProvider.getValue(rows[i], "makeExcelYn")
					}
				}
				emplyeeJsonObj = {
					"jsonRows" : emplyeeArray
				}
				
				$.ajax({
					type : "POST",
					url : "PGPM0070.do",
					data : { "df_method_nm"			: "makeIndvPayStubExcel"
							,"search_year"			: $("#search_year").val()
							,"search_month"			: $("#search_month").val()
							,"emplyee_excel_array"	: JSON.stringify(emplyeeJsonObj)},
					error : function(error) {
						console.log("error");
					},
					success : function(data) {
						console.log("success");
						let jsonData = JSON.parse(data);
						mailDataProvider.fillJsonData(jsonData, { fillMode: "set" });
					}
				});
			}
		});
		// 개별 엑셀 파일 생성 끝 //
		
		// 종합 엑셀파일 생성 버튼
		$("#btn_make_all_excel").click(function() {
			const rows = mailGridView.getCheckedRows(true);	// 그리드 내 절대 위치 받기
			const rowCnt = rows.length;
			
			if(rowCnt > 0) {								
				let emplyeeArray = [];						// 사원정보 배열
				let emplyeeJsonObj;							// 사원정보 param
				
				for(let i=0; i < rowCnt; i++) {
					emplyeeArray[i] = {
						  "empNo"		: mailDataProvider.getValue(rows[i], "empNo")
						, "empNm"		: mailDataProvider.getValue(rows[i], "empNm")
						, "makeExcelYn"	: mailDataProvider.getValue(rows[i], "makeExcelYn")
					}
				}
				emplyeeJsonObj = {
					"jsonRows" : emplyeeArray
				}
				
				$.ajax({
					type : "POST",
					url : "PGPM0070.do",
					data : { "df_method_nm"			: "makeAllPayStubExcel"
							,"search_year"			: $("#search_year").val()
							,"search_month"			: $("#search_month").val()
							,"emplyee_excel_array"	: JSON.stringify(emplyeeJsonObj)},
					error : function(error) {
						console.log("error");
					},
					success : function(data) {
						console.log("success");
						alert("월급여 명세서를 생성하였습니다");
					}
				});
			}
		});
		// 종합 엑셀 파일 생성 끝 //
	});
</script>
</head>

<body>
	<form name="dataForm" id="dataForm" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />

		<input type="hidden" name="emp_col" id="emp_col" />
		
		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title">메일전송</h2>
					<!-- 타이틀 영역 //-->
					
					<div class="block">	
						<!--// 검색 조건  -->
						<div class="search_top">
							<table cellpadding="0" cellspacing="0" class="table_search"
								summary="프로그램관리 검색">
								<caption>검색</caption>
								<colgroup>
									<col width="*" />
									<col width="*" />
									<col width="*" />
									<col width="*" />
								</colgroup>
								<tr>
									<th scope="row">조회시기</th>
									<td><select id="search_year" name="search_year" title="조회년도" style="width:100px">
	                                    </select> 년 </td>
	                                <td><select id="search_month" name="search_month" title="조회월" style="width:100px">
	                                   	</select> 월 </td>
									<td><p class="btn_src_zone">
										<a href="#" class="btn_search" id="btn_search">검색</a> </p></td>
								</tr>
							</table>
						</div>
						<!-- 검색 조건// -->
						
						<p> '급여계산'메뉴에서 해당 기간에 사원이 급여계산되어야  급여명세서 생성이 가능합니다</p> <br>
						
						<a class="btn_page_admin" href="#" id="btn_make_indv_excel"><span>개별 급여명세서 생성</span></a>
						<a class="btn_page_admin" href="#" id="btn_make_all_excel"><span>종합 급여명세서 생성</span></a>
						<a class="btn_page_admin" href="#" id="btn_send_mail"><span>메일 전송</span></a>
																	
						<!-- //리얼 그리드 -->
						<div class="list_zone">
							<div id="mailGrid" style="height: 44em; background-color: black;"></div>
						</div>
						<!-- 리얼 그리드// -->
					</div>
					
				</div>
			</div>
		</div>
		<!--content//-->

	</form>
</body>
</html>