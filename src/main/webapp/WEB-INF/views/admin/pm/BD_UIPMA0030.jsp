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

<!-- 리얼그리드 라이브러리 -->
<script type="text/javascript" src="${contextPath}/script/realgrid.2.5.0/realgrid.2.5.0.min.js"></script>
<link rel="stylesheet" type="text/css" href="${contextPath}/script/realgrid.2.5.0/realgrid-style.css"/>
<!-- 다른 테마 -->
<%-- <link rel="stylesheet" href="${contextPath}/script/realgrid.2.5.0/realgrid-sky-blue.css"/> --%> 
<link rel="stylesheet" href="${contextPath}/css/gridAlign.css"/>
<script src="${contextPath}/script/realgrid.2.5.0/libs/jszip.min.js"></script>
<script src="${contextPath}/script/realgrid.2.5.0/realgrid-lic.js"></script>

<script src="${contextPath}/gridDef/pm/EmpPayItemGrid.js"></script>

<script type="text/javascript">
	<c:if test="${resultMsg != null}">
	$(function() {
		jsMsgBox(null, "info", "${resultMsg}");
	});
	</c:if>
	
	/* 
	 * 등록 처리 함수
	 */
	function btn_get_regist_view() {
		var form = document.dataForm;
		form.df_method_nm.value = "getPayItemRegist";
		form.submit();
	}
	
	//직원 검색 기능
	function searhEmpPay() {
		var codeNo = $("#ad_employee_code").val();
		if(codeNo != null && codeNo != "") {
			$.ajax({
				type : "POST",
				url : "PGPM0030.do",
				data :  { "df_method_nm"		: "processEmpPayTree"
						, "insertChk"			: "Y"
						, "ad_employee_code"	: codeNo},
				error : function(error) {
					console.log("error");
				},
				success : function(data) {
					console.log("success");
					//console.log("Emp PayItem DATA\n\n" + data);

					var treeData = JSON.parse(data);
					empPayDataProvider.setRows(treeData, "treeId", true);
					
					//항목기본금액, 사용여부, 비고 column 수정활성화
					empPayView.columnByName("itmBasAmt").editable = true;
					empPayView.columnByName("useYN").editable = true;
					empPayView.columnByName("rmk").editable = true;
					empPayView.expandAll();
				}
			});
		}
	}
	
	$(document).ready(function() {
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
		
		//검색 버튼
		$("#searchEPay").click(function() {
			searhEmpPay();
		});
		
		////테스트
		//서버 전송전 데이터 실제 값 확인
		//!!삭제 예정
		$("#getJsonRow").click(function() {
			var jsongo = "{";
			console.log("for");
			for(var i = 1; i <= empPayDataProvider.getRowCount(); i++) {
				jsonData = empPayDataProvider.getJsonRow(i);
				console.log(jsonData);
				delete jsonData.payItmNm;
				delete jsonData.modDt;
				delete jsonData.enrtDay;
				jsonData.empCd = $("#ad_employee_code").val();
				jsongo += JSON.stringify(jsonData);
				if(i != empPayDataProvider.getRowCount()) {
					jsongo += ",";
				}
			}
			
			jsongo += "}";
			alert(jsongo);
		});
		
		//저장 버튼
		$("#btn_save_employee_pay").click(function() {
			let codeNo = $("#ad_employee_code").val();				// 사원 번호
			let updates = empPayDataProvider.getStateRows("updated");	// 수정된 항목만 저장
			let sendData = "{ \"jsonRows\" :[";						// 전송할 Json 데이터
			
			for(var i = 0; i < updates.length; i++) {
				jsonData = empPayDataProvider.getJsonRow(updates[i]);
								
				//delete jsonData.KEY; //전송안할 데이터 해당 행 명으로(KEY부분) json에서 제외가능
				delete jsonData.payItmNm;		//급여 항목명 제외
				delete jsonData.modDt;			//수정일 제외
				delete jsonData.enrtDay;		//등록일 제외
				//jsonData[i].KEY = "VALUE";	//추가할 데이터 작성가능
				jsonData.empNo = codeNo;		//사원번호 추가
				sendData += JSON.stringify(jsonData);
				if(i != updates.length -1) {
					sendData += ",";
				}
			}
			sendData += "] }";
			console.log(sendData);
					
			// 개인별급여항목(TB_PAY_ITM_LST) 수정
			$.ajax({
				type : "POST",
				url : "PGPM0030.do",
				data: {"df_method_nm"	: "updateEmpPay"
					 , "sendData"		: sendData},
				success: function(data){
					console.log("저장 완료");
					var treeData = JSON.parse(data);
					empPayDataProvider.setRows(treeData, "treeId", true);
					empPayView.expandAll();
				},
				error : function(request,status,error) {
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+
							"error:"+error);
				}
			});

			//// 변동내역(TB_PAY_ITM_LOG)에 기록
			if(codeNo != null && codeNo != "") {		// 선택된 사원이 있을때
				// TODO
				// 개인별급여항목 테이블(TB_PAY_ITM_LST)에서 원래 기록을 가져온다
				// 변경된 항목과  값을 변동사항에 기록
				// 변동 전후 금액을 제대로 찾았을 때 작동
				// 1) 변경된 항목의 코드, 수정된 금액, 비고 저장
				// 2) 해당 코드로 수정 이전 금액 탐색
				// 3) 기록 저장
				$.ajax({
					type : "POST",
					url : "PGPM0030.do",
					data :  { "df_method_nm"		: "processEmpPayTree"
							, "ad_employee_code"	: codeNo},
					error : function(error) {
						console.log("error");
					},
					success : function(payItmData) {
						let payItmList = JSON.parse(payItmData);	// 수정 이전 data
						let updatedLog = "{ \"jsonRows\" :[ \n";	// 수정된 항목과 수정 전/후 금액 데이터
						let itmCd;									// 수정된 항목 코드
						let prevItmAmt;								// 수정 이전 항목 금액
						let postItmAmt;								// 수정 이후 항목 금액	
						let rmrk;									// 수정 이후 비고
						
						for(let i = 0; i < updates.length; i++) {					// 변경된 모든 항목에 대해
							// 1) 변경된 항목의 코드, 수정된 금액, 비고 저장 
							const row = updates[i];					// 행 위치
							itmCd = empPayDataProvider.getValue(row, "payItmCd");
							postItmAmt = empPayDataProvider.getValue(row, "itmBasAmt");
							rmrk = empPayDataProvider.getValue(row, "rmk");
							
							updatedLog += "{ \n";
							updatedLog += " \"payItmCd\" : \"" + itmCd + "\",\n";			// 항목 코드
							updatedLog += " \"postItmAmt\" : \"" + postItmAmt + "\",\n";	// 수정된 항목 금액
							if(rmrk) {												// 비고가 비어있지 않을때
								updatedLog += " \"rmk\" : \"" + rmrk + "\",\n";			// 수정된 비고
							}
							
							// 2) 해당 코드로 수정 이전 금액 탐색
							let j;
							for(j = 0; j < payItmList.length; j++) {				// 수정 이전 data에서 수정전 항목 금액 저장 
								const payItm = payItmList[j];
								if(itmCd == payItm["payItmCd"]) {					// 항목코드가 같을때
									prevItmAmt = payItm["itmBasAmt"];
									updatedLog += " \"prevItmAmt\" : \"" + prevItmAmt + "\"\n";
									break;
								}
							}
							updatedLog += "} \n";
							
							if(i != updates.length -1) {
								updatedLog += ", ";
							}
						}
						updatedLog += "] }";
						
						// 3) 기록 저장(TB_PAY_ITM_LOG)
						$.ajax({
							type : "POST",
							url : "PGPM0030.do",
							data: {"df_method_nm"	: "insertPayItmLog"
								 , "empNo"			: codeNo
								 , "updatedLog"		: updatedLog},		// 바뀐 모든 항목 전달
							success: function(data){
								console.log("LOG 기록 완료");
							},
							error : function(error) {
								console.log("error");
							}
						});
					}
				});
			}
			// 변동내역 기록  끝 //
		});
		// 저장 버튼 끝 //
	});
	
	// 엑셀다운로드
	function downloadExcel() {
		empPayView.exportGrid({
			type: "excel",
			target: "local",
			fileName: $("#ad_employee_name").val() + " 월급여항목.xlsx",
			indicator: "default",
			header: "default",
			footer: "default",
			hideColumns: ["useYN", "modDt", "enrtDay"],		// 출력하지 않을 열 목록
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
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />
		
		<input type="hidden" name="ad_codeNo" id="ad_codeNo" />
		<input type="hidden" name="ad_menuList" id="ad_menuList" value="menulist" />
		
		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title">개인별월급여항목</h2> <br>
					<!-- 타이틀 영역 //-->
					
					<!--// 검색 영역 -->
					<div class="search_top" >
						<table cellpadding="0" cellspacing="0" class="table_search"
							summary="직원 찾기">
							<caption>찾기</caption>
							<colgroup>
								<col width="*" />
								<col width="*" />
								<col width="*" />
							</colgroup>
							<tr>
								<th scope="row">직원찾기</th>
								<td></td>
								<td><input name="ad_employee_code" id="ad_employee_code" type="text"
									style="width: 150px; background-color: #aaa5;" readonly/></td>
								<td><input name="ad_employee_name" id="ad_employee_name" type="text"
									style="width: 150px; background-color: #aaa5;" readonly/></td>
								<td style="text-align:right;"><!-- 왜 내용이 반대로 출력되는지 모르겠음 -->
									<p class="btn_src_zone">
										<a href="#" class="btn_search" id="searchEPay">검색</a>
									</p>
									<p class="btn_src_zone">
										<a href="#" class="btn_search" id="popEmp">직원</a>
									</p>
								</td>
							</tr>
						</table>
					</div>
					<!-- 검색 영역// -->
					
					<p style="text-align: right;">(금액단위: 원)</p>
					
					<div class="block">	
						<!-- //리얼 그리드 -->
						<div class="list_zone">
							<div id="empPayGrid" style="height: 44em; background-color: black;"></div>
						</div>
						<!-- 리얼그리드// -->
						
						<!-- //리스트 -->
						<div class="btn_page_last">
							<!-- <a class="btn_page_admin" href="#" id="getJsonRow"><span>json 테스트</span></a> -->
							<a class="btn_page_admin" href="#" id="btn_save_employee_pay"><span>저장</span></a>
							<a class="btn_page_admin" href="#" onclick="downloadExcel();"><span>엑셀다운로드</span></a>
						</div>
						<!-- 리스트// -->
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>