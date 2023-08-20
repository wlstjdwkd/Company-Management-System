<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업종합정보시스템</title>
<ap:jsTag type="web"
	items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,selectbox, mask, jqGrid, css" />
<ap:jsTag type="tech" items="acm,msg,util, im" />
<script type="text/javascript">
	$(document).ready(function() {
		// 발급대상년도 초기화
		var fromYear = 2011;
		var toYear = Util.date.getLocalYear();
		$("#jdgmnt_reqst_year_from_search").numericOptions({from:fromYear,to:toYear,sort:"desc"});		
		$("#jdgmnt_reqst_year_to_search").numericOptions({from:fromYear,to:toYear,sort:"desc"});		
		
		<c:if test="${!empty inparam.ad_REQST_YEAR_FROM_SEARCH}">
		$("#jdgmnt_reqst_year_from_search").val(${inparam.ad_REQST_YEAR_FROM_SEARCH});
		</c:if>
		<c:if test="${!empty inparam.ad_REQST_YEAR_TO_SEARCH}">
		$("#jdgmnt_reqst_year_to_search").val(${inparam.ad_REQST_YEAR_TO_SEARCH});
		</c:if>
		
		// Rowspan 처리
		tableRowSpanning();
		
		// 조회
		$("#btn_search_issue").on("click",function(){
			
			if($("#jdgmnt_reqst_year_from_search").val() > $("#jdgmnt_reqst_year_to_search").val() || $("#jdgmnt_reqst_year_from_search").val().replace(/-/gi,"") > $("#jdgmnt_reqst_year_to_search").val().replace(/-/gi,"")){
	    		jsMsgBox($("#jdgmnt_reqst_year_to_search"), 'error', Message.msg.invalidDateCondition );
	            return false;
	        }
			
			// 발급대상년도
			$("#ad_jdgmnt_reqst_year_from_search").val($("#jdgmnt_reqst_year_from_search option:selected").val());
			$("#ad_jdgmnt_reqst_year_to_search").val($("#jdgmnt_reqst_year_to_search option:selected").val());
			
			$("#df_method_nm").val("index");
			$("#dataForm").submit();
		});
		
		// Excel 다운로드
		$("#excelDown").click(function(){
			// 신청구분
			$("#ad_reqst_se").val($("#reqst_se_search option:selected").val());
			
			// 발급대상년도
			$("#ad_jdgmnt_reqst_year_from_search").val($("#jdgmnt_reqst_year_from_search option:selected").val());
			$("#ad_jdgmnt_reqst_year_to_search").val($("#jdgmnt_reqst_year_to_search option:selected").val());
			
        	jsFiledownload("/PGIM0031.do","df_method_nm=excelRsolver&ad_jdgmnt_reqst_year_from_search=" + $("#ad_jdgmnt_reqst_year_from_search").val() + "&ad_jdgmnt_reqst_year_to_search=" + $("#ad_jdgmnt_reqst_year_to_search").val());
        });
		
	});
	
	// Rowspan 처리함수
	function tableRowSpanning() {
        var RowspanTd = "";
        var RowspanText = "";
        var RowspanCount = 0;

        $('tr').each(function () {
            var This = $('td', this)[0];
            var text = $(This).text();

            if (RowspanTd == "") {
                RowspanTd = This;
                RowspanText = text;
                RowspanCount = 1;
            }
            else if (RowspanText != text) {
                $(RowspanTd).attr('rowSpan', RowspanCount);

                RowspanTd = This;
                RowspanText = text;
                RowspanCount = 1;
            }
            else {
                $(This).remove();
                RowspanCount++;
            }
        });
        // 반복 종료 후 마지막 rowspan 적용
        $(RowspanTd).attr('rowSpan', RowspanCount);
    }
</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />
		<input type="hidden" id="ad_jdgmnt_reqst_year_from_search" name="ad_jdgmnt_reqst_year_from_search" value="${inparam.ad_REQST_YEAR_FROM_SEARCH}" /> 
		<input type="hidden" id="ad_jdgmnt_reqst_year_to_search" name="ad_jdgmnt_reqst_year_to_search" value="${inparam.ad_REQST_YEAR_TO_SEARCH}" />

		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title">월별추진현황</h2>
					<!-- 타이틀 영역 //-->
					<div class="search_top">
						<table cellpadding="0" cellspacing="0" class="table_search" summary="조회 조건">
							<caption>&nbsp;</caption>
							<caption>조회 조건</caption>
							<colgroup>
								<col width="11%" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">발급 대상연도</th>
									<td>
										<select name="jdgmnt_reqst_year_from_search" title="발급대상연도" id="jdgmnt_reqst_year_from_search" style="width:80px"></select>
										<strong> ~ </strong> 
										<select name="jdgmnt_reqst_year_to_search" title="발급대상연도" id="jdgmnt_reqst_year_to_search" style="width:80px"></select>
										
										<p class="btn_src_zone">
											<a href="#none" class="btn_search" id="btn_search_issue">조회</a>
										</p>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="block">
						<h3>
							월별 발급기준 집계
							<div class="btn_pag fr">
								<a class="btn_page_admin" href="#none" id="excelDown"><span>엑셀다운로드</span></a>
							</div>
							<p class="unit">(단위 : 개)</p>
						</h3>
						<!--// 리스트 -->
						<div class="list_zone">
							<table cellspacing="0" border="0" summary="목록">
								<caption>리스트</caption>
								<colgroup>
									<col width="*" />
									<col width="*" />
									<col width="*" />
									<col width="*" />
									<col width="*" />
									<col width="*" />
									<col width="*" />
								</colgroup>
								<thead>
									<tr>
										<th colspan="2" rowspan="2" scope="col">구분</th>
										<th colspan="5" scope="col">발급 및 발급 취소 기준</th>
									</tr>
									<tr>
										<th scope="col">발급</th>
										<th scope="col">내용변경</th>
										<th scope="col">발급 취소</th>
										<th scope="col">유효기간중</th>
										<th scope="col">유효기간만료</th>
									</tr>
								</thead>
								<tbody>
									<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
									<c:if test="${fn:length(monthTotal) == 0}">
										<tr>
											<td colspan="7"><spring:message code="info.nodata.msg" /></td>
										</tr>
									</c:if>
									<%-- 데이터를 화면에 출력해준다 --%>
									<c:forEach items="${monthTotal}" var="monthTotal" varStatus="status">
									<c:if test="${monthTotal.MM != '소계'}">
									<tr>
										<td rowspan="7">’${monthTotal.year}년</td>
										<td class="tac line_l">${monthTotal.MM}</td>
										<td class="tar"><fmt:formatNumber value = "${monthTotal.AK1}" pattern = "#,##0"/></td>
										<td class="tar"><fmt:formatNumber value = "${monthTotal.AK2}" pattern = "#,##0"/></td>
										<td class="tar"><fmt:formatNumber value = "${monthTotal.RC4}" pattern = "#,##0"/></td>
										<td class="tar"><fmt:formatNumber value = "${monthTotal.expiryDate}" pattern = "#,##0"/></td>
										<td class="tar"><fmt:formatNumber value = "${monthTotal.expiryDateEND}" pattern = "#,##0"/></td>
									</tr>
									</c:if>
									
									<c:if test="${monthTotal.MM == '소계'}">
									<tr class="sum">
										<c:if test="${monthTotal.YYYY == '소계'}">
											<td colspan="2">총계</td>
										</c:if>
										<c:if test="${monthTotal.YYYY != '소계'}">
											<td>’${monthTotal.year}년</td>
										<td class="line_l">${monthTotal.MM}</td>
										</c:if>
										<td class="tar"><fmt:formatNumber value = "${monthTotal.AK1}" pattern = "#,##0"/></td>
										<td class="tar"><fmt:formatNumber value = "${monthTotal.AK2}" pattern = "#,##0"/></td>
										<td class="tar"><fmt:formatNumber value = "${monthTotal.RC4}" pattern = "#,##0"/></td>
										<td class="tar"><fmt:formatNumber value = "${monthTotal.expiryDate}" pattern = "#,##0"/></td>
										<td class="tar"><fmt:formatNumber value = "${monthTotal.expiryDateEND}" pattern = "#,##0"/></td>
									</tr>
									</c:if>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<!-- 리스트// -->
						<p class="mgt10">* 보완요청 : 기업에 증빙서류 보완 요청된 경우</p>
					</div>
					<!--리스트영역 //-->
				</div>
			</div>
			<!--content//-->
		</div>
	</form>
</body>
</html>