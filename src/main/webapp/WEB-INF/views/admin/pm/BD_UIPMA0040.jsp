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

<script src="/gridDef/pm/CalcPayGrid.js"></script>

<script type="text/javascript">
	$(document).ready(function(){
		/* $("#dataForm").validate({  
			rules : {
				search_year: "required",
				search_month: "required"
			}
		}); */
		
		// 조회시기 범위
		$("#search_year").numericOptions({from:2002, to:${frontParam.curr_year}, sort:"desc"});
		$("#search_month").numericOptions({from:01, to:12, namePadding:2, valuePadding:2, sort:"asc"});
		
		// 개인별 급여생성(월급여생성 개인)
		$("#btn_insert_indv").click(function() {
			if($('input:radio[name=empRadio]').is(':checked')) {	// 선택된 사원이 있을때
				$.ajax({
					type : "POST",
					url : "PGPM0040.do",
					data : { "df_method_nm"		: "processIndvMonthList"
						, "ad_employee_code"	: $("input:radio[name=empRadio]:checked").val()  
						, "process_mode"		: "INSERT"
						, "search_year"			: $("#search_year").val()
						, "search_month"		: $("#search_month").val()},
					error : function(error) {
						console.log("error");
					},
					success : function(data) {
						console.log("success");
						console.log(data);
						var treeData = JSON.parse(data);
						
						calcPayDataProvider.setRows(treeData, "treeId", true);
						calcPayGridView.expandAll();
					}
				});
			}
		});
		
		// 모든 직원 급여생성(월급여생성 전체)
		$("#btn_insert_all").click(function() {
			$.ajax({
				type : "POST",
				url : "PGPM0040.do",
				data : { "df_method_nm"	: "processAllMonthList"
					, "search_year"		: $("#search_year").val()
					, "search_month"	: $("#search_month").val()},
				error : function(error) {
					console.log("error");
				},
				success : function(data) {
					console.log("success");
					var treeData = JSON.parse(data);
					
					calcPayDataProvider.setRows(treeData, "treeId", true);
					calcPayGridView.expandAll();
				}
			});
		});
		
		//// 개인별 급여수정 (월급여재계산)
		// 조회시기가 현재 월 일때만 수정 가능
		$("#btn_update_indv").click(function() {
			var today = new Date();
			var year = today.getFullYear(); 							// 현재 년도
			var month = today.getMonth() + 1;  							// 현재 월
			var selectedYear = parseInt($("#search_year").val());		// 선택 년도
			var selectedMonth = parseInt($("#search_month").val());		// 선택 월
			
			if($('input:radio[name=empRadio]').is(':checked')) {			// 선택된 사원이 있을때
				if(year == selectedYear && month == selectedMonth) {		// 현재 월만 수정 가능
					$.ajax({
						type : "POST",
						url : "PGPM0040.do",
						data : { "df_method_nm"		: "processIndvMonthList"
							, "process_mode"		: "UPDATE"
							, "ad_employee_code"	: $("input:radio[name=empRadio]:checked").val()
							, "search_year"			: $("#search_year").val()
							, "search_month"		: $("#search_month").val()},
						error : function(error) {
							console.log("error");
						},
						success : function(data) {
							console.log("success");
							console.log(data);
							var treeData = JSON.parse(data);
							
							calcPayDataProvider.setRows(treeData, "treeId", true);
							calcPayGridView.expandAll();
						}
					});
				}
				else {
					alert('현재 월이 아니면 재계산이 불가능 합니다');
				}
			}
		});
		// 월급여재계산 끝 //
	});
		 
	// 해당 년도의 월급여 검색 (검색 버튼)
	function searchSalary(){
		$.ajax({
			type : "POST",
			url : "PGPM0040.do",
			data : { "df_method_nm"	: "searchPayMntList"
				, "search_year"		: $("#search_year").val()
				, "search_month"	: $("#search_month").val()},
			error : function(error) {
				console.log("error");
			},
			success : function(salaryData) {
				console.log("success");
				var slrData = JSON.parse(salaryData);		// 급여정보
				let empRow = {"payItmNm" : "사원번호"};
				
				$.ajax({
					type : "POST",
					url : "PGPM0040.do",
					data : { "df_method_nm"		: "findIndvEmpList"
						, "search_year"			: $("#search_year").val()
						, "search_month"		: $("#search_month").val()},
					error : function(error) {
						console.log("error");
					},
					success : function(employeeData) {
						console.log("success");
						var empData = JSON.parse(employeeData);		// 사원번호, 사원명
						const empCnt = empData.length;
						
						// 컬럼 생성
						calcPayDataProvider.clearRows();
						
						var dynamicColumns = [
							{
								"name" : "treeId",
								"visible" : false
							},
							{
								"name" : "payItmNm",
								"type" : "data",
								"width" : "200",
								"header" : {
									"text" : "급여항목명",
								}
							},
							{
								"name" : "payItmCd",
								"styleName" : "align-center",
								"type" : "data",
								"width" : "100",
								"header" : {
									"text" : "급여항목코드",
								}
							}
						];
						
						//// 직원 컬럼 동적 할당
						for(let i = 0; i < empCnt; i++) {
							const empCol = "emp".concat(i);
							const empNm = empData[i].empNm;
							
							var empField = {
								"name": empCol,
								"styleName" : "align-right",
								"type": "data",
								"width": "100",
								"tag": {"dataType": "number"},   
								"header": {
									template: "<input type='radio' name='empRadio'"
											+ "value='"+empData[i].empNo+"'/>" + empData[i].empNm
								},
								"numberFormat": "#,##0"
							};
							dynamicColumns.push(empField);
						}
						
						var endField = {
							"name" : "empTot",
							"styleName" : "align-right",
							"type" : "data",
							"width" : "120",
							"tag" : {"dataType": "number"},    // dataType이 text가 아닌경우 tag속성에 지정
							"header" : {
								"text" : "합계"
							},
							"numberFormat" : "#,##0"
						};
						dynamicColumns.push(endField);
						
						// 새 컬럼 설정
						setFieldsNColumns(calcPayDataProvider, calcPayGridView, dynamicColumns);
						calcPayDataProvider.setRows(slrData, "treeId", true);
						calcPayGridView.expandAll();
					}
				});				
			}
		});
	}
	// 검색 버튼 끝 //
	
	<c:if test="${resultMsg != null}">
	$(function(){
		jsMsgBox(null, "info", "${resultMsg}");
	});
	</c:if>
	
	// 엑셀다운로드
	function downloadExcel() {
		calcPayGridView.exportGrid({
			type: "excel",
			target: "C:",	// 경로지정
			fileName: $("#search_year").val()+"년 "+ $("#search_month").val() + "월 급여항목.xlsx",
			indicator: "default",
			header: "default",
			footer: "default",
			//hideColumns: ["useYN", "modDt", "enrtDay"],		// 출력하지 않을 열 목록
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

		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title">급여계산</h2>
					<!-- 타이틀 영역 //-->
					
					<!--// 검색 조건  -->
					<div class="search_top">
						<table cellpadding="0" cellspacing="0" class="table_search"
							summary="프로그램관리 검색">
							<caption>검색</caption>
							<colgroup>
								<col width="8%" />
								<col width="*" />
								<col width="*" />
								<col width="*" />
								<col width="*" />
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
										<a href="#" class="btn_search" onclick="searchSalary()">검색</a>
									</p></td>
							
								<th scope="row">월급여생성</th>
                               	<td><p class="btn_src_zone">
										<a href="#" class="btn_search" id="btn_insert_indv">개인</a> </p>
									<p class="btn_src_zone">
										<a href="#" class="btn_search" id="btn_insert_all">전체</a> </p>
								</td>
								
								<th>월급여재계산</th>
								<td>
									<p class="btn_src_zone">
										<a href="#" class="btn_search" id="btn_update_indv">개인</a> </p>
								</td>
							</tr>
						</table>
					</div>
					<!-- 검색 조건// -->
					
					<p style="text-align: right;">(금액단위: 원)</p>
					
					<div class="block">
						<!--// 리스트 -->
						<div class="container-fluid">
							<div id="calcPayGrid" style="height: 500px; background-color: white;">
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