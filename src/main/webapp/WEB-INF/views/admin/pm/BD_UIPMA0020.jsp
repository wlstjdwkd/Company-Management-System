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
<link rel="stylesheet" href="${contextPath}/css/gridAlign.css"/>
<script src="${contextPath}/script/realgrid.2.5.0/libs/jszip.min.js"></script>
<script src="${contextPath}/script/realgrid.2.5.0/realgrid-lic.js"></script>

<script src="${contextPath}/gridDef/pm/PayItemTreeGrid.js"></script>

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
	
	/* 
	 * 수정화면 함수
	 */
	function get_modify_view(codeNo) {
		var form = document.dataForm;
		form.df_method_nm.value = "getPayItemModify";
		document.getElementById("ad_codeNo").value = codeNo;
		form.submit();
	}
	
	function registerCallback() {		
		// 셀이 더블 클릭 되었을 때 작동
		treeView.onCellDblClicked = function (grid, clickData) {
			if(clickData.cellType == "data") {
				var arr = new Array();
				var current = treeView.getCurrent();
				
				arr = treeDataProvider.getValues(current.dataRow);
	
				//alert("current: " + current + "\tdataRow: " + current.dataRow + "\tarr[0]: " +arr[0]);
				
				get_modify_view(arr[1]);
			}
		}
	}
	
	// 엑셀다운로드
	function downloadExcel() {
		treeView.exportGrid({
			type: "excel",
			target: "local",
			fileName: "급여항목.xlsx",
			indicator: "default",
			header: "default",
			footer: "default",
			hideColumns: ["useYn"],		// 출력하지 않을 열 목록
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
					<h2 class="menu_title">급여항목관리</h2>
					<!-- 타이틀 영역 //-->
					
					<br>
					<div class="block">
						
						<!-- //리얼 그리드 -->
						<div class="list_zone">
							<div id="payItemTreeGrid" style="height: 44em; background-color: white;"></div>
						</div>
						<!-- 리얼그리드// -->
					
						<div class="btn_page_last">
							<a class="btn_page_admin" href="#none" onclick="btn_get_regist_view()"><span>등록</span></a>
							<a class="btn_page_admin" href="#" onclick="downloadExcel();"><span>엑셀다운로드</span></a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>