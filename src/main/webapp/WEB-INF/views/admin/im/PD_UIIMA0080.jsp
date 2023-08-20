<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset=UTF-8">
<title>정보</title>
<c:set var="svcUrl" value=" ${requestScope[SVC_URL_NAME]}"/>
<ap:globalConst/>
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,selectbox,mask,jqGrid,css,cookie,flot,timer"/>
<ap:jsTag type="tech" items="acm,msg,util"/>
<script type='text/javascript'>

	$(document).ready(function() {
			
		// Rowspan 처리 (열 합치기)
		tableRowSpanning();
		
	});
	
	//Rowspan 처리 함수
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
	<form name="dataForm" id="dataForm" method="post">
		<div id="self_dgs">
			<div class="pop_q_con">
				<div class="block">
					<h3>월별 신청기준 집계 추진 현황</h3>
					<!-- 리스트 -->
					<div class="list_zone">
						<table id="tblStatics" class="list" cellspacing="0" border="0" summary="월별 신청기준 집계 추진 현황">
							<caption>리스트</caption>
							<colgroup>
								<col width="*"/>
								<col width="*"/>
								<col width="*"/>
								<col width="*"/>
								<col width="*"/>
								<col width="*"/>
								<col width="*"/>
								<col width="*"/>
								<col width="*"/>
								<col width="*"/>
								<col width="*"/>
								<col width="*"/>
							</colgroup>
							<thead>
								<tr>
									<th colspan="2" rowspan="2" scope="col">구분</th>
									<th colspan="10" scope="col">신청 월 기준</th>
								</tr>
								<tr>
									<th class="line_l" scope="col">신청</th>
									<th scope="col">접수</th>
									<th scope="col">검토중</th>
									<th scope="col">보완요청</th>
									<th scope="col">보완접수</th>
									<th scope="col">보완검토중</th>
									<th scope="col">발급</th>
									<th scope="col">반려</th>
									<th scope="col">접수취소</th>
									<th scope="col">발급취소</th>
								</tr>
							</thead>
							<tbody>
								<%-- 데이터가 없을때 화면에 메세지를 출력해준다 --%>
								<c:if test="${fn:length(applicationTotal) == 0}">
									<tr>
										<td colspan="8"><spring:message code="info.nodata.msg"/></td>
									</tr>
								</c:if>
								<%-- 데이터를 화면에 출력해준다 --%>
								<c:forEach items="${applicationTotal}" var="applicationTotal" varStatus="status">
									<c:if test="${applicationTotal.MM != '소계'}">
										<tr>
											<td>’${applicationTotal.year}년</td>
											<td class="tac line_l">${applicationTotal.MM}</td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS0}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS1}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS2}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS3}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS4}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS5}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.RC1}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.RC2}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.RC3}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.RC4}" pattern = "#,##0"/></td>
										</tr>
									</c:if>
									<c:if test="${applicationTotal.MM == '소계'}">
										<tr class="sum">
											<c:if test="${applicationTotal.YYYY == '소계'}">
												<td colspan="2">총계</td>
											</c:if>
											<c:if test="${applicationTotal.YYYY != '소계'}">
												<td>’${applicationTotal.year}년</td>
												<td class="line_l">${applicationTotal.MM}</td>
											</c:if>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS0}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS1}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS2}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS3}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS4}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS5}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.RC1}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.RC2}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.RC3}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.RC4}" pattern = "#,##0"/></td>
										</tr>
									</c:if>
								</c:forEach>
							</tbody>
						</table>
					</div>
					<p class="mgt10">* 보완요청 : 기업에 증빙서류 보완 요청된 경우</p>
					<br>
					<br>
					<div class="btn_page_last">
						<a class="btn_page_admin" href="javascript:window.print();"><span>인쇄</span></a>
						<a class="btn_page_admin" href="#" onclick="parent.$.fn.colorbox.close();"><span>닫기</span></a>
					</div>
					<br>
					<br>
				</div>
			</div>
		</div>
	</form>
</body>
</html>