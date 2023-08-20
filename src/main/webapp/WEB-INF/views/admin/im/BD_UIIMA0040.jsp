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
<title>기업종합정보시스템</title>
<ap:jsTag type="web"
	items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin, mask, jqGrid, css" />
<ap:jsTag type="tech" items="acm,msg,util" />
<script type="text/javascript">
	$(document).ready(function() {
		
		initDatepicker();
		
		// 조회버튼 이벤트
		$("#check_date").click(function() {
			if($("#q_pjt_start_dt").val() == "" && $("#q_pjt_end_dt").val() == "" ) {
				
			}
			else if($("#q_pjt_start_dt").val() == "" || $("#q_pjt_end_dt").val() == ""){
				if($("#q_pjt_start_dt").val() == "") {
					jsMsgBox($("#q_pjt_start_dt"), 'error', Message.msg.bothRequiredDateCondition );
					return false;
				} else {
					jsMsgBox($("#q_pjt_end_dt"), 'error', Message.msg.bothRequiredDateCondition );
					return false;
				}
			}
			
        	if($("#q_pjt_start_dt").val() > $("#q_pjt_end_dt").val() || $("#q_pjt_start_dt").val().replace(/-/gi,"") > $("#q_pjt_end_dt").val().replace(/-/gi,"")){
        		jsMsgBox($("#q_pjt_end_dt"), 'error', Message.msg.invalidDateCondition );
                return false;
            }
        	$("#df_curr_page").val(1);
        	$("#dataForm").submit();
        });

	});
	
	function initDatepicker() {
		$('.datepicker').datepicker({
			showOn : 'button',
			buttonImage : '<c:url value="/images/acm/icon_cal.png" />',
			buttonImageOnly : true,
			changeYear : true,
			changeMonth : true,
			yearRange : "1920:+0"
		});
		$('.datepicker').mask('0000-00-00');
	
		$('#q_pjt_start_dt').datepicker(
				"setDate",
				Util.isEmpty($("#q_pjt_start_dt").val()) ? new Date() : $("#q_pjt_start_dt").val());
		$('#q_pjt_end_dt').datepicker(
				"setDate",
				Util.isEmpty($("#q_pjt_end_dt").val()) ? new Date() : $("#q_pjt_end_dt").val());
	}
	
	/*
	* 검색단어 입력 후 엔터 시 자동 submit
	*/
	function press(event) {
		if (event.keyCode == 13) {
			event.preventDefault();
			$("#check_date").click();
		}
	}
	
</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />
		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title">위변조문서신고내역</h2>
					<!-- 타이틀 영역 //-->
					<div class="search_top">
						<table cellpadding="0" cellspacing="0" class="table_search" summary="조회 조건">
							<caption>&nbsp;</caption>
							<caption>조회 조건</caption>
							<colgroup>
								<col width="15%" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">신고일자</th>
									<td>
										<input type="text" name="q_pjt_start_dt" id="q_pjt_start_dt" class="datepicker" maxlength="10"	title="날짜선택" onkeypress="press(event);" value='<c:out value="${inparam.fromDate}"/>' /> 
										<strong> ~ </strong> 
										<input type="text" name="q_pjt_end_dt" id="q_pjt_end_dt" class="datepicker" maxlength="10" title="날짜선택" onkeypress="press(event);" value='<c:out value="${inparam.toDate}"/>' />
										<p class="btn_src_zone">
											<a href="#none" class="btn_search" id="check_date">조회</a>
										</p></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="block">
							<ap:pagerParam />
						<!--// 리스트 -->
						<div class="list_zone">
							<table cellspacing="0" border="0" summary="목록">
								<caption>리스트</caption>
								<colgroup>
									<col width="7%" />
									<col width="9%" />
									<col width="9%" />
									<col width="9%" />
									<col width="12%" />
									<col width="*" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col">신고일</th>
										<th scope="col">신고자</th>
										<th scope="col">전화번호</th>
										<th scope="col">이메일</th>
										<th scope="col">신고문서번호</th>
										<th scope="col">습득경위</th>
									</tr>
								</thead>
								<tbody>
									<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
									<c:if test="${fn:length(docReportList) == 0}">
										<tr>
											<td colspan="6"><spring:message code="info.nodata.msg" /></td>
										</tr>
									</c:if>
									<%-- 데이터를 화면에 출력해준다 --%>
									<c:forEach items="${docReportList}" var="docReportList" varStatus="status">
										<tr>
											<td class="tac">${docReportList.creatDe}</td>
											<td>${docReportList.aplcntNm}</td>
											<td>${docReportList.telNo.first}-${docReportList.telNo.middle}-${docReportList.telNo.last}</td>
											<td class="tal"><p>${docReportList.email}</p></td>
											<td>${docReportList.docCnfirmNo}</td>
											<td class="tal">${docReportList.acqsCrcmstncs}</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<!-- 리스트// -->
						<div class="mgt10"></div>
						<!--// paginate -->
						<ap:pager pager="${pager}" />
						<!-- paginate //-->
					</div>
					<!--리스트영역 //-->
				</div>
			</div>
			<!--content//-->
		</div>
	</form>
</body>
</html>