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
<ap:jsTag type="tech" items="acm,msg,util" />

<!-- 리얼그리드 라이브러리 -->
<script type="text/javascript" src="${contextPath}/script/realgrid.2.5.0/realgrid.2.5.0.min.js"></script>
<link rel="stylesheet" type="text/css" href="${contextPath}/script/realgrid.2.5.0/realgrid-style.css"/>
<script src="${contextPath}/script/realgrid.2.5.0/libs/jszip.min.js"></script>
<script src="${contextPath}/script/realgrid.2.5.0/realgrid-lic.js"></script>

<script src="/gridDef/em/ExpenseINFO.js"></script>

<script type="text/javascript">

	$(document).ready( function() {
		$("#search_year").numericOptions({from:1960, to:${frontParam.curr_year}, sort:"desc"});
		$("#search_month").numericOptions({from:01, to:12, namePadding:2, valuePadding:2, sort:"asc"});
		$("#search_year2").numericOptions({from:1960, to:${frontParam.curr_year}, sort:"desc"});
		$("#search_month2").numericOptions({from:01, to:12, namePadding:2, valuePadding:2, sort:"asc"});
	});
	
	
function countSess(){
	ExpInfoDataProvider.clearRows();

	$.ajax({
		type : "POST",
		url : "PGEM0020.do",
		data : { "df_method_nm" : "countSess" 
			, "search_year" : $("#search_year").val()
			, "search_month" : $("#search_month").val()
			, "search_year2" : $("#search_year2").val()
			, "search_month2" : $("#search_month2").val()
			, "department" : $("#department").val()
			, "ad_search_word" : $("#search_word").val()
			, "limitFrom" : 0 , "limitTo" : 100},
		error : function(error) {
			console.log("error");
		},
		success : function(data) {
			console.log("success");
			var ddd = JSON.parse(data);
			ExpInfoDataProvider.fillJsonData(ddd, {fillMode: "set"});
		}
	}); 
}

	function registerCallback() {
		ExpInfogridView.onCellClicked = function (grid, clickData) {
			if(clickData.cellType == "data"){
				var current = ExpInfogridView.getCurrent();
				var arr = new Array();
				arr = ExpInfoDataProvider.getValues(current.dataRow);
				
				var form = document.dataForm;
				form.df_method_nm.value = "programModify";
				document.getElementById("DOCU_NO").value = arr[0];
				form.submit();
			};
		};
	}

	/*
	 * 검색단어 입력 후 엔터 시 자동 submit
	 */
	function press(event) {
		if (event.keyCode == 13) {
			event.preventDefault();
			countSess();
		}
	}
	


	
<c:if test="${resultMsg != null}">
$(function(){
	jsMsgBox(null, "info", "${resultMsg}");
});
</c:if>


</script>
</head>

<body>
	<form name="dataForm" id="dataForm" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />

		<input type="hidden" name="DOCU_NO" id="DOCU_NO" /> 

		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					
					<!--// 타이틀 영역 -->
					<h2 class="menu_title">지출내역 조회</h2>
					<!-- 타이틀 영역 //-->
					<!--// 검색 조건 -->
					<div class="search_top">
						<table cellpadding="0" cellspacing="0" class="table_search"
							summary="품의서 검색 테이블">
							<caption>검색</caption>
							<colgroup>
								<col width="9%" />
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
								<th scope="row">기한 검색</th>
								<td><select id="search_year" name="search_year" title="조회년도" style="width:70px">
                                    </select> 년 </td>
                                <td><select id="search_month" name="search_month" title="조회월" style="width:50px">
                                   	</select> 월   부터</td>
                                <td><select id="search_year2" name="search_year2" title="조회년도" style="width:70px">
                                    </select> 년 </td>
                                <td><select id="search_month2" name="search_month2" title="조회월" style="width:50px">
                                   	</select> 월   까지</td>
								<th scope="row">부서 선택</th>
								<td><ap:code name="department" id="department" grpCd="89" type="select"/></td>
								<td><input name="search_word" id="search_word"
									title="이름을 입력하세요." placeholder="사원 이름" type="text"
									style="width: 200px" value="${param.search_word}" onkeypress="press(event);"/></td>
								<td>
								<td>
									<p class="btn_src_zone">
										<a href="#" class="btn_search"
											onclick="countSess()">검색</a>
									</p>
								</td>
							</tr>
						</table>
					</div><br>
					<div class="block">
						<!--// 리스트 -->
						<div class="container-fluid">
							<div id="ExpInfogrid" style="height: 242px; background-color: white;">
							</div> 
						</div> 
					</div>
					
				</div>
				<!--content//-->
			</div>
		</div>

	</form>
</body>
</html>