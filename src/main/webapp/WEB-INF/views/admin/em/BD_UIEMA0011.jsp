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
<title>정보마당</title>
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask,selectbox" />
<ap:jsTag type="tech" items="acm,msg,util" />

<!-- 리얼그리드 라이브러리 -->
<script type="text/javascript" src="${contextPath}/script/realgrid.2.5.0/realgrid.2.5.0.min.js"></script>
<link rel="stylesheet" type="text/css" href="${contextPath}/script/realgrid.2.5.0/realgrid-style.css"/>
<script src="${contextPath}/script/realgrid.2.5.0/libs/jszip.min.js"></script>
<script src="${contextPath}/script/realgrid.2.5.0/realgrid-lic.js"></script>

<script src="/gridDef/em/outlayINFO.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		
		// 등록
		$("#btn_insert").click(function() {
			jsMsgBox(
					null,
					'confirm',
					'<spring:message code="confirm.common.save" />',
					function() {
						$("#df_method_nm").val("insertDOC");
						$("#dataForm").submit();
					});
		});
		
	});
	
	//달력
	$(document).ready(function() {
   		
    	initDatepicker();
    											//	https://api.jqueryui.com/datepicker/
    	function initDatepicker() {
    		$('.datepicker').datepicker({
    			showOn : 'both',						//버튼을 눌러서 출력(button, focus, on)
    			buttonImage : '<c:url value='/images/acm/icon_cal.png' />',	//이미지 링크
    			buttonImageOnly : true,
    			nextText: '다음 달',
    			prevText: '이전 달',
    			changeYear : true,
    			changeMonth : true,
    			yearRange : '1990:2022',
    			showButtonPanel : true,
    			currentText: '오늘 날짜',
    			closeText: '닫기'
    		});
    		//$('.datepicker').mask('0000-00-00'); 					// '0000-00-00'를 숨기기
    		
    	}
    });	

	//행 삽입(지정행 이전), beginInsertRow(itemIndex, shift), shift의 default는 false
	function btnBeginInsertRow() {
		var curr = ExpInfogridView.getCurrent();
		ExpInfogridView.beginInsertRow(Math.max(0, curr.itemIndex));
		ExpInfogridView.showEditor();
		ExpInfogridView.setFocus();
	}
		
	//행 삽입(지정행 이후)
	function btnBeginInsertRowShift() {
		var curr = ExpInfogridView.getCurrent();
		ExpInfogridView.beginInsertRow(Math.max(0, curr.itemIndex), true);
		ExpInfogridView.showEditor();
		ExpInfogridView.setFocus();
	}

	//행 추가(최하단), beginAppendRow:그리드 마지막 데이터행 이후에 새로운 데이터행을 추가한다.
	function btnBeginAppendRow() {
		ExpInfogridView.beginAppendRow();
		ExpInfogridView.showEditor();
		ExpInfogridView.setFocus();
	}

	//행 삭제, getCurrent:현재 포커스를 갖는 셀의 CellIndex 값을 가져온다.
	//	 		removeRow: 행 삭제
	function btnRemoveRow() {
		var curr = ExpInfogridView.getCurrent();
		ExpInfoDataProvider.removeRow(curr.DataRow);
	}
	
</script>

<style>
  input {
  	height: 30px;
  	border: none;
  }
  table {
    width: 80%;
    border: 1px solid #444444;
    
  }
  th {
    border: 1px solid #444444;
    text-align: center;
  }
  td {
  	border: 1px solid #444444;
  }
</style>

</head>

<body>
	<form name="dataForm" id="dataForm" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
					
		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<div class="block">
						<!-- 테이블 -->
						<table cellpadding="0" cellspacing="0" summary="품의서 윗단">
							<caption>품의서 윗단</caption>
							<colgroup>
								<col width="15%" />
								<col width="*" />
								<col width="15%" />
								<col width="*" />
								<col width="15%" />
								<col width="*" />
							</colgroup>
							<tr>
								<th colspan='6'><text style="font-size: 30px;">(지출 입금 대체) 품의서-법인</td>
							</tr>
							<tr>
								<th scope="row">문서번호</th>
								<td><input name="ad_docno" id="ad_docno" type="text"></td>
								<th scope="row">부 서</th>
								<td><ap:code name="department" id="department" grpCd="89" type="select"/></td>
								<th scope="row">사원명</th>
								<td><input name="ad_empnm" id="ad_empnm" type="text"></td>
							</tr>
							<tr>
								<th scope="row">작성 일자</th>
								<td><input name="ad_date" id="ad_date" type="text" class="datepicker"></td>
								<th scope="row">금 액</th>
								<td colspan='3'><text name="tot_price" id="tot_price" type="text" style="font-size: 20px; text-align: center;" value="${GridBase.getSummary(PRICE, sum)}">원</td>
							</tr>
						</table><br><br>
						
						<div class="block">
						<!--// 리스트 -->
						<div class="container-fluid">
							<div id="ExpInfogrid" style="width: 80%; height: 400px; background-color: white;"></div><br> 
							<a class="btn_page_admin" href="#none" class="btn_in_gray" onclick="btnBeginInsertRow()"><span>행 삽입(지정행 이전)</span></a>
							<a class="btn_page_admin" href="#none" class="btn_in_gray" onclick="btnBeginInsertRowShift()"><span>행 삽입(지정행 이후)</span></a>
							<a class="btn_page_admin" href="#none" class="btn_in_gray" onclick="btnBeginAppendRow()"><span>행 추가(최하단)</span></a>
							<a class="btn_page_admin" href="#none" class="btn_in_gray" onclick="btnRemoveRow()"><span>행 삭제</span></a>
						
						</div> 
						</div>
						
					</div>
					<div class="block">
					<!-- 리스트// -->
						<div class="btn_page_last">
							<a class="btn_page_admin" href="#" id="btn_insert"><span>등록</span></a>
						</div>
					</div>
					<!--리스트영역 //-->
					
				</div>
			</div>
			<!--content//-->
		</div>
	</form>
</body>
</html>