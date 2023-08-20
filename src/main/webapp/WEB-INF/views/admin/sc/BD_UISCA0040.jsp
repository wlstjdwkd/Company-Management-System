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
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,multifile,msgBoxAdmin,colorboxAdmin,mask,blockUI,dhtmlx,sheetjs" />
<ap:jsTag type="tech" items="acm,msg,util,etc" />

<script type="text/javascript">
	$(document).ready(function(){
		<c:if test="${resultMsg != null}">
			$(function(){
				jsMsgBox(null, "info", "${resultMsg}");
			});
		</c:if>
	});
	
	//엑셀을 JSON으로 변경
	function excelImport(event){
		let input = event.target; //input file 객체를 가져옴
		let reader = new FileReader(); //FileReader를 생성
		reader.readAsBinaryString(input.files[0]); //파일객체를 읽는다. 완료되면 원시 이진 데이터가 문자열로 포함됨
		reader.onload = () => { //성공적으로 읽기 동작이 완료된 경우 실행되는 이벤트 핸들러를 설정
			let fileData = reader.result; //FileReader 결과 데이터(컨텐츠)를 가져옴
			console.log(fileData);
			let workbook = XLSX.read(fileData, {type : 'binary'}); //바이너리 형태로 엑셀파일을 읽음
			console.log(workbook);
			workbook.SheetNames.forEach(function(item, index, array){ //엑셀파일의 시트 정보를 읽어서 JSON 형태로 변환
				EXCEL_JSON = XLSX.utils.sheet_to_json(workbook.Sheets[item]);
				//헤더값 변경
				EXCEL_JSON.forEach(obj => renameKey(obj, '사원번호', 'emnum'));
				EXCEL_JSON.forEach(obj => renameKey(obj, '일자', 'hdate'));
				EXCEL_JSON.forEach(obj => renameKey(obj, '내역', 'history'));
				EXCEL_JSON.forEach(obj => renameKey(obj, '상호', 'fee'));
				EXCEL_JSON.forEach(obj => renameKey(obj, '금액', 'price'));
				console.log(EXCEL_JSON);
				//json데이터 grid에 넣기
				mygrid.clearAll();
				mygrid.parse(EXCEL_JSON, "js");
			})
		};
	}
	
	//Json key 값 변경
	function renameKey(obj, oldKey, newKey) {
	    	obj[newKey] = obj[oldKey];
	    	delete obj[oldKey]
	}
	
	//검색
	function searchName(){
		var name = document.getElementById('searchemNm').value;
		$.ajax({
			type : "POST",
			url : "PGSC0040.do",
			data : { "df_method_nm" : "AjaxgridData" , "searchemNm" : name},
			error : function(error) {
				console.log("error");
			},
			success : function(data) {
				console.log("success");
				var ddd = JSON.parse(data);
				mygrid.clearAll();
				mygrid.parse(ddd, "js");
			}
		});
	}
	
	//엑셀 다운로드
	function downloadExcel() {
		$("#df_method_nm").val("excelStatics");
		$("#DxForm").submit();
	}
	
	/*
	 * 검색단어 입력 후 엔터 시 자동 submit
	 */
	function press(event) {
		if (event.keyCode == 13) {
			event.preventDefault();
			searchName();
		}
	}

	/* 
	 * 등록 화면 이동
	 */
	 function btn_program_regist_view() {
		var form = document.DxForm;
		form.df_method_nm.value = "programRegist";
		form.submit();
	}
	/* 
	 * 수정,취소 화면 이동
	 */
	 function btn_program_modify_view(exnum) {
		var form = document.DxForm;
		form.df_method_nm.value = "programModify";
		document.getElementById("ad_history").value = exnum;
		form.submit();
	}
</script>
</head>

<body>
	<form name="DxForm" id="DxForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		
		<input type="hidden" id="ad_upfile" value="" />
		<input type="hidden" name="ad_history" id="ad_history" />

		<!-- Content Start -->
		<div class="container-fluid" style="padding: 30px 0 0 270px; margin: 0 50px 0 0;">
			<div>
				<h2 class="menu_title">지출내역 관리</h2>
				<div class="search_top">
					<table class="table_search">
						<colgroup>
						<col width="15%">
						<col width="*">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">사원 이름</th>
								<td>
									<input name="searchemNm" id=searchemNm type="text" style="width: 150px;" title="검색어 입력"
									placeholder="공백 - 전체목록" onkeypress="press(event);"/>
								</td>
								<td>
									<p class="btn_src_zone"><a href="#" class="btn_search" id="btn_search" onclick="searchName()">검색</a></p>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div id="recinfoArea"></div>
			<div id="gridbox" style="height: 312px; background-color: white;">
				<script>
					mygrid = new dhtmlXGridObject('gridbox');
					mygrid.load("/gridDef/sc/BD_UISCA0040Grid.xml");
					mygrid.attachEvent("onRowSelect",function(rowID,celInd){
							var a = mygrid.cellById(rowID, 0).getValue();
				    		btn_program_modify_view(a);
					});
				</script>
			</div>
			<div id="pagingArea"></div>
			<br/>
			<input type="file" name="hpeDcsnFile" id="hpeDcsnFile" style="width:295px;" title="파일선택" onchange="excelImport(event)" accept=".xls, .xlsx"/>
			<div class="btn_page_last">
				<a class="btn_page_admin" href="#none" onclick="downloadExcel();"><span>엑셀다운로드</span></a>
			</div>
		</div>
	</form>
</body>
</html>