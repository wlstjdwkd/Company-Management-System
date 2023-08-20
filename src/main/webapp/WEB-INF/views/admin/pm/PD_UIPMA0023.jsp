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

<script src="${contextPath}/gridDef/pm/PayItemListGrid.js"></script>

<script type="text/javascript">
	// 팝업검색 결과를 호출자에게 리턴하고 화면을 닫는다.
	function return_opener(code, codeNm) {
		var opener = parent;

		opener.document.getElementById("ad_itmCd").value = code;
		opener.document.getElementById("ad_itmNm").value = codeNm;

		parent.$.colorbox.close();
	}

	function registerCallback() {		
		// 셀이 클릭 되었을 때 작동
		payItemGridView.onCellDblClicked = function (grid, clickData) {
			if(clickData.cellType == "data") {
				var current = payItemGridView.getCurrent();
				var arr = new Array();
				
				arr = payItemDataProvider.getValues(current.dataRow);
	
				//alert("current: " + current + "\tdataRow: " + current.dataRow);
				
				return_opener(arr[1], arr[0]);
			}
		}
	}
</script>
</head>
<body>
	<!--//content-->
	<div id="self_dgs">
		<div class="pop_q_con">
			<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />
				<!-- LNB 출력 방지 -->
				<input type="hidden" id="no_lnb" value="true" />
				<input type="hidden" name="pop_searchSiteSe" id="pop_searchSiteSe" value="${searchSiteSe}"/>
				<!--// 타이틀 영역 -->
				<h2 class="menu_title">급여 항목 선택</h2>
				<!-- 타이틀 영역 //-->
				
				<p> <b>해당 내용을 선택하세요</b> </p><br>
				
				<!--// 검색 조건 -->
				<div class="block">
					<!--// 리스트 -->
					<div class="list_zone">
						<div id="payItemListGrid" style="height: 30em; background-color: white;"></div>
					</div>
					<!-- 리스트// -->
				</div>
				<!--content//-->
			</form>
		</div>
	</div>
</body>
</html>