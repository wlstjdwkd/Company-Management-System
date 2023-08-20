<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl" %>

<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업종합정보시스템</title>
<ap:jsTag type="web"
	items="jquery,colorboxAdmin,cookie,flot,form,jqGrid,notice,selectbox,timer,tools,ui,validate" />
<ap:jsTag type="tech" items="util,acm,ps" />
<script type="text/javascript">
$(document).ready(function(){
	<c:if test="${not empty param.searchArea }">
		Util.rowSpan($("#tblStatics"), [1]);
	</c:if>
});
</script>
</head>
<body>
	<form name="dataForm" id="dataForm" method="POST">
		<div id="self_dgs">
			<div class="pop_q_con">
				<!--// 검색 조건 -->
				<div class="search_top">
					<table cellpadding="0" cellspacing="0" class="table_search" summary="주요지표 현황 챠트">
						<caption>주요지표 현황 표</caption>
						<colgroup>
							<col width="15%" />
							<col width="25%" />
							<col width="15%" />
							<col width="25%" />
						</colgroup>
	            <tr>
	                <th scope="row">기업군</th>
	                <td>${tableTitle}</td>
	                <th scope="row">년도</th>
	                <td>${param.searchStdyy}</td>
	            </tr>
	            <tr>
	                <th scope="row">업종</th>
	                <td>
	                	<c:if test="${param.searchInduty eq '1' }">제조/비제조</c:if>
		               	<c:if test="${param.searchInduty eq '2' }">업종테마별</c:if>
		               	<c:if test="${param.searchInduty eq '3' }">상세업종별</c:if>
	                </td>
	                <th scope="row">지역</th>
	                <td>
	                	<c:if test="${param.searchArea eq '1' }"> 권역별</c:if>
	                    <c:if test="${param.searchArea eq '2' }"> 지역별</c:if>
	                </td>
	            </tr>
	            <tr>
	                <th scope="row">지표</th>
	                <td colspan="3">
	                	<c:forEach begin="0" end = "${searchIndexVal_length}" step = "1" var ="stat">
	                		<c:if test = "${searchIndex == 1}">
	 							<ap:code id = "a" grpCd="64" type="text" selectedCd="${searchIndexVal[stat]}" />&nbsp;&nbsp;&nbsp;
	                		</c:if>
							<c:if test = "${searchIndex == 2}">
	 							<ap:code id = "b" grpCd="65" type="text" selectedCd="${searchIndexVal[stat]}" />&nbsp;&nbsp;&nbsp;
		               		 </c:if>
	                	</c:forEach>
	                </td>
	            </tr>
				</table>
				</div>
				<div class="list_zone">
					<table cellspacing="0" border="0" summary="기업통계" class="list" id="tblStatics">
						<caption>리스트</caption>
						<colgroup>
							<c:if test="${fn:length(param.searchEntprsGrpVal) > 1}">
								<col width="*" />
							</c:if>
							<c:if test="${fn:length(param.searchEntprsGrpVal) == 1}">
								<c:if test="${!empty param.searchArea }">
									<col width="*" />
									<c:if test="${param.searchArea == '1' }">
										<col width="*" />
									</c:if>
								</c:if>
								<c:if test="${!empty param.searchInduty }">
									<col width="*" />
								</c:if>
							</c:if>
							<c:forEach items="${columnList }" var="item" varStatus="status">
								<col width="*" />
							</c:forEach>
						</colgroup>
						<thead>
							<tr>
								<c:if test="${fn:length(param.searchEntprsGrpVal) > 3}">
									<th scope="col">기업군</th>
								</c:if>
								<c:if test="${fn:length(param.searchEntprsGrpVal) == 3}">
									<c:if test="${!empty param.searchArea }">
										<c:if test="${param.searchArea == '1' }">
											<th scope="col" colspan="2">지역</th>
										</c:if>
										<c:if test="${param.searchArea == '2' }">
											<th scope="col">지역</th>
										</c:if>
									</c:if>
									<c:if test="${!empty param.searchInduty }">
										<th scope="col">업종/지표</th>
									</c:if>
								</c:if>
								<c:forEach items="${columnList }" var="item" varStatus="status">
									<th scope="col"><c:if test="${searchIndex == '1' }">
											<c:if test="${item == 'sumEntrprsCo' }">기업수(개)</c:if>
											<c:if test="${item == 'sumSelngAm' }">매출액(조원)</c:if>
											<c:if test="${item == 'sumBsnProfit' }">영업이익(조원)</c:if>
											<c:if test="${item == 'sumBsnProfitRt' }">영업이익률(%)</c:if>
											<c:if test="${item == 'sumXportAmDollar' }">수출액(억불)</c:if>
											<c:if test="${item == 'sumXportAmRt' }">수출비중(%)</c:if>
											<c:if test="${item == 'sumOrdtmLabrrCo' }">근로자수(만명)</c:if>
											<c:if test="${item == 'sumRsrchDevlopRt' }">R&D집약도(%)</c:if>
											<c:if test="${item == 'sumThstrmNtpf' }">당기순이익(조원)</c:if>
										</c:if> <c:if test="${searchIndex == '2' }">
											<c:if test="${item == 'sumEntrprsCo' }">기업수(개)</c:if>
											<c:if test="${item == 'avgSelngAm' }">평균매출액(억원)</c:if>
											<c:if test="${item == 'avgBsnProfit' }">평균영업이익(억원)</c:if>
											<c:if test="${item == 'avgBsnProfitRt' }">평균영업이익률(%)</c:if>
											<c:if test="${item == 'avgXportAmDollar' }">평균수출액(백만불)</c:if>
											<c:if test="${item == 'avgXportAmRt' }">평균수출비중(%)</c:if>
											<c:if test="${item == 'avgOrdtmLabrrCo' }">평균근로자수(백명)</c:if>
											<c:if test="${item == 'avgRsrchDevlopRt' }">평균R&D집약도(%)</c:if>
											<c:if test="${item == 'avgThstrmNtpfRt' }">평균당기순이익(억원)</c:if>
											<c:if test="${item == 'avgCorage' }">평균업력(년)</c:if>
										</c:if></th>
								</c:forEach>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${resultList }" var="resultInfo" varStatus="status">
								<tr>
									<c:if test="${fn:length(param.searchEntprsGrpVal) > 3}">
										<td class='tac'>${resultInfo.entclsNm }</td>
									</c:if>
									<c:if test="${not empty param.searchArea}">
										<c:if test="${param.searchArea == 1 }">
											<td id='rowspan' class='tac'>${resultInfo.upperNm }</td>
										</c:if>
										<td id='rowspan' class='tac'>${resultInfo.abrv }</td>
									</c:if>
									<c:if test="${not empty param.searchInduty}">
										<td class='tal'><c:if test="${param.searchInduty == 1 or resultInfo.gbnIs == 'S' }">${resultInfo.indutySeNm }</c:if>
											<c:if test="${param.searchInduty == 2 and resultInfo.gbnIs == 'D' }">&emsp;&emsp;&emsp;${resultInfo.dtlclfcNm }</c:if>
											<c:if test="${param.searchInduty == 3 and resultInfo.gbnIs == 'D' }">&emsp;&emsp;&emsp;${resultInfo.indutyNm }</c:if>
										</td>
									</c:if>
									<c:forEach items="${columnList }" var="item" varStatus="status">
										<c:set var="cname" value="${item}" />
										<td class='tar'><fmt:formatNumber value="${resultInfo[cname] }" /></td>
									</c:forEach>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<!-- 리스트// -->
				<div class="btn_page_last">
					<a class="btn_page_admin" href="javascript:window.print();"><span>인쇄</span></a> <a
						class="btn_page_admin" href="#" onclick="parent.$.fn.colorbox.close();"><span>닫기</span></a>
				</div>
			</div>
			<!--content//-->
		</div>
	</form>
</body>
</html>