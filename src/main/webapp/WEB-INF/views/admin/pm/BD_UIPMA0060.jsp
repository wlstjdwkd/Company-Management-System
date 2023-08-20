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
<script src="/gridDef/pm/TaxRateGrid.js"></script>

<script type="text/javascript">
	/* 
	 * 등록 처리 함수
	 */
	function btn_get_regist_view() {
		var form = document.dataForm;
		form.df_method_nm.value = "getTaxItemRegist";
		form.submit();
	}
	
	/* 
	 * 수정화면 함수
	 */
	function get_modify_view(codeNo) {
		var form = document.dataForm;
		form.df_method_nm.value = "getTaxItemModify";
		document.getElementById("ad_codeNo").value = codeNo;
		form.submit();
	}
	
	function registerCallback() {		
		// 셀이 더블 클릭 되었을 때 작동
		taxView.onCellDblClicked = function (grid, clickData) {
			if(clickData.cellType == "data") {
				var arr = new Array();
				var current = taxView.getCurrent();
				
				arr = taxDataProvider.getValues(current.dataRow);
	
				//alert("current: " + current + "\tdataRow: " + current.dataRow + "\tarr[0]: " +arr[0]);
				
				get_modify_view(arr[1]);
			}
		}
	}
	
	// 엑셀다운로드
	function downloadExcel() {
		taxView.exportGrid({
			type: "excel",
			target: "local",
			fileName: "일괄적용 세율 목록.xlsx", 
			showProgress: true,
			progressMessage: "엑셀파일 생성 중 입니다.",
			indicator: "default",
			header: "default",
			footer: "default",
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

		<input type="hidden" name="ad_codeNo" id="ad_codeNo" />

		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title">세율관리</h2>
					<!-- 타이틀 영역 //-->
					
					<div>
						<p style="font-size: 20px;">등록된 급여항목은 '참고항목의 금액' x '세율' / 100의 식에서 일의 자리 반올림한 값으로 자동 계산되며,</p>
						<p style="font-size: 20px;">모든 사원의 '개인별월급여항목'에서 직접 입력이 불가능하게 됩니다.</p>
						<br>
					</div>
					
					<div class="block">
						<!--// 리스트 -->
						<div class="container-fluid">
							<div id="taxRateGrid" style="height: 500px; background-color: white;">
							</div> 
						</div>
						<!-- 리스트// -->
						
						<div class="btn_page_last">
							<a class="btn_page_admin" href="#" onclick="btn_get_regist_view();"><span>등록</span></a>
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