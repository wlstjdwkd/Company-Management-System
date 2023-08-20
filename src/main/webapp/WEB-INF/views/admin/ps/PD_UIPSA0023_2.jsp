<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>

<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery,colorboxAdmin,cookie,flot,form,jqGrid,notice,selectbox,timer,tools,ui,validate" />
<ap:jsTag type="tech" items="util,acm,ps" />
<script type="text/javascript">
$(document).ready(function(){
	<c:if test="${not empty param.searchArea and not empty param.searchInduty }">
		<c:if test="${param.searchArea == '1'}">
		Util.rowSpan($("#tblStatics"), [1,2,3]);	
		</c:if>
		<c:if test="${param.searchArea == '2'}">
		Util.rowSpan($("#tblStatics"), [1,2]);	
		</c:if>
	</c:if>
	<c:if test="${not empty param.searchArea and empty param.searchInduty}">	
		<c:if test="${param.searchArea == '1'}">
		Util.rowSpan($("#tblStatics"), [1,2]);	
		</c:if>
		<c:if test="${param.searchArea == '2'}">
		Util.rowSpan($("#tblStatics"), [1]);	
		</c:if>
	</c:if>
	<c:if test="${empty param.searchArea and not empty param.searchInduty}">
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
	        <table cellpadding="0" cellspacing="0" class="table_search" summary="주요지표 현황 챠트" >
	            <caption>
	            주요지표 현황 표
	            </caption>
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
	                <td>${stdyySt} ~ ${stdyyEd}</td>
	            </tr>
	            <tr>
						<tr>
							<th scope="row">업종</th>
							<td><c:if test="${param.searchInduty eq '1' }">제조/비제조</c:if> <c:if
									test="${param.searchInduty eq '2' }">업종테마별</c:if> <c:if
									test="${param.searchInduty eq '3' }">상세업종별</c:if></td>
							<th scope="row">지역</th>
							<td><c:if test="${param.searchArea eq '1' }"> 권역별</c:if> <c:if
									test="${param.searchArea eq '2' }"> 지역별</c:if></td>
						</tr>
	            <tr>
	                <th scope="row">지표</th>
	                <td colspan="3">
	                <c:if test="${searchIndex == 'A'}">R&#38;D 구간별</c:if> 
	                <c:if test="${searchIndex == 'B'}">매출액 구간별</c:if>
	                <c:if test="${searchIndex == 'C'}">수출액 구간별</c:if>
	                <c:if test="${searchIndex == 'D'}">근로자수 구간별</c:if>
	                <c:if test="${searchIndex == 'E'}">평균업력 구간별</c:if>
	                <c:if test="${searchIndex == 'F'}">매출구간별 R&D집약도</c:if>
	                </td>
	            </tr>
	        </table>
	    </div>
	    <!-- // 리스트영역-->
	    <div class="block">
                    <div class="list_zone">
                       	<table cellspacing="0" border="0" summary="기업통계" class="list" id="tblStatics">
                           <caption>
                            리스트
                            </caption>
                            <colgroup>
                        	<c:if test="${!empty param.searchArea }">
                            <col width="*" />
                        	</c:if>
                        	<c:if test="${!empty param.searchInduty }">
                            <col width="*" />
                        	</c:if>
                        	<col width="*" />
                            <c:forEach var="outYr" begin="${stdyySt }" end="${stdyyEd }">
                            <col width="*" />
                            </c:forEach>
                            </colgroup>
                            <thead>
                                <tr>
                                	<c:if test="${!empty param.searchArea }">
										<c:if test="${param.searchArea == '1' }">
	                                   	<th scope="col" colspan="2">지역</th>
										</c:if>
										<c:if test="${param.searchArea == '2' }">
	                                   	<th scope="col">지역</th>
										</c:if>
									</c:if>
                                    <c:if test="${!empty param.searchInduty }">
                                    <th scope="col">업종</th>
                                    </c:if>
                                    <th scope="col">구분</th>
                                    <c:forEach var="outYr" begin="${stdyySt }" end="${stdyyEd }">
                                    <th scope="col">${outYr }</th>
                                    </c:forEach>
                                </tr>
                            </thead>
                            <tbody>
							<c:forEach items="${resultList }" var="resultInfo" varStatus="resStatus">							                    	
								<tr>
								<c:if test="${not empty param.searchArea}">
									<c:if test="${param.searchArea == 1 }">
                                    <td id='rowspan' class='tac'>	${resultInfo.upperNm }</td>
                                    </c:if>
                                    <td id='rowspan' class='tac'>	${resultInfo.abrv }</td>
								</c:if>
								<c:if test="${not empty param.searchInduty}">
                                    <td class='tal'>
									<c:if test="${param.searchInduty == 1 or resultInfo.gbnIs == 'S' }">${resultInfo.indutySeNm }</c:if>
									<c:if test="${param.searchInduty == 2 and resultInfo.gbnIs == 'D' }">&emsp;&emsp;&emsp;${resultInfo.dtlclfcNm }</c:if>
									<c:if test="${param.searchInduty == 3 and resultInfo.gbnIs == 'D' }">&emsp;&emsp;&emsp;${resultInfo.indutyNm }</c:if>
									</td>
								</c:if>
									<td class='tal'>
										<c:if test="${searchIndex == 'A' }">
	                                    <c:if test="${resStatus.index%8 == 0 }">없음</c:if>
	                                    <c:if test="${resStatus.index%8 == 1 }">1.0%미만</c:if>
	                                    <c:if test="${resStatus.index%8 == 2 }">2.0~3.0%</c:if>
	                                    <c:if test="${resStatus.index%8 == 3 }">3.0~5.0%</c:if>
	                                    <c:if test="${resStatus.index%8 == 4 }">5.0%~10.0%</c:if>
	                                    <c:if test="${resStatus.index%8 == 5 }">10.0%~30.0%</c:if>
	                                    <c:if test="${resStatus.index%8 == 6 }">30.0%이상</c:if>
	                                    <c:if test="${resStatus.index%8 == 7 }">합계</c:if>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'B' }">
	                                    <c:if test="${resStatus.index%9 == 0 }">100억미만</c:if>
	                                    <c:if test="${resStatus.index%9 == 1 }">100억원~500억원</c:if>
	                                    <c:if test="${resStatus.index%9 == 2 }">500억원~1천억원</c:if>
	                                    <c:if test="${resStatus.index%9 == 3 }">1천억원~2천억원</c:if>
	                                    <c:if test="${resStatus.index%9 == 4 }">2천억원~3천억원</c:if>
	                                    <c:if test="${resStatus.index%9 == 5 }">3천억원~5천억원</c:if>
	                                    <c:if test="${resStatus.index%9 == 6 }">5천억원~1조원</c:if>
	                                    <c:if test="${resStatus.index%9 == 7 }">1조원이상</c:if>
	                                    <c:if test="${resStatus.index%9 == 8 }">합계</c:if>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'C' }">
	                                    <c:if test="${resStatus.index%8 == 0 }">없음</c:if>
	                                    <c:if test="${resStatus.index%8 == 1 }">1백만~5백만불</c:if>
	                                    <c:if test="${resStatus.index%8 == 2 }">5백만~1천만불</c:if>
	                                    <c:if test="${resStatus.index%8 == 3 }">1천만~3천만불</c:if>
	                                    <c:if test="${resStatus.index%8 == 4 }">3천만~5천만불</c:if>
	                                    <c:if test="${resStatus.index%8 == 5 }">5천만~1억불</c:if>
	                                    <c:if test="${resStatus.index%8 == 6 }">1억불 이상</c:if>	                                    
	                                    <c:if test="${resStatus.index%8 == 7 }">합계</c:if>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'D' }">
	                                    <c:if test="${resStatus.index%7 == 0 }">10인 미만</c:if>
	                                    <c:if test="${resStatus.index%7 == 1 }">10인~50인</c:if>
	                                    <c:if test="${resStatus.index%7 == 2 }">50인~100인</c:if>
	                                    <c:if test="${resStatus.index%7 == 3 }">100인~200인</c:if>
	                                    <c:if test="${resStatus.index%7 == 4 }">200인~300인</c:if>
	                                    <c:if test="${resStatus.index%7 == 5 }">300인 이상</c:if>	                                    
	                                    <c:if test="${resStatus.index%7 == 6 }">합계</c:if>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'E' }">
	                                    <c:if test="${resStatus.index%7 == 0 }">0~6년</c:if>
	                                    <c:if test="${resStatus.index%7 == 1 }">7~20년</c:if>
	                                    <c:if test="${resStatus.index%7 == 2 }">21~30년</c:if>
	                                    <c:if test="${resStatus.index%7 == 3 }">31~40년</c:if>
	                                    <c:if test="${resStatus.index%7 == 4 }">41~50년</c:if>
	                                    <c:if test="${resStatus.index%7 == 5 }">51년이상</c:if>	                                    
	                                    <c:if test="${resStatus.index%7 == 6 }">합계</c:if>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'F' }">
	                                    <c:if test="${resStatus.index%9 == 0 }">100억미만</c:if>
	                                    <c:if test="${resStatus.index%9 == 1 }">100억원~500억원</c:if>
	                                    <c:if test="${resStatus.index%9 == 2 }">500억원~1천억원</c:if>
	                                    <c:if test="${resStatus.index%9 == 3 }">1천억원~2천억원</c:if>
	                                    <c:if test="${resStatus.index%9 == 4 }">2천억원~3천억원</c:if>
	                                    <c:if test="${resStatus.index%9 == 5 }">3천억원~5천억원</c:if>
	                                    <c:if test="${resStatus.index%9 == 6 }">5천억원~1조원</c:if>
	                                    <c:if test="${resStatus.index%9 == 7 }">1조원이상</c:if>
	                                    <c:if test="${resStatus.index%9 == 8 }">합계</c:if>
	                                    </c:if>									
									</td>
								<c:forEach var="outYr" begin="${stdyySt }" end="${stdyyEd }" varStatus="status">								
									<c:if test="${outYr == stdyySt }">
									
									<td class='tar'>
										<c:if test="${searchIndex == 'A' }">
	                                	    <c:if test="${resStatus.index%8 == 0 }"><fmt:formatNumber value="${resultInfo.sctn1 }"/></c:if>
	                                	    <c:if test="${resStatus.index%8 == 1 }"><fmt:formatNumber value="${resultInfo.sctn2 }"/></c:if>
	                                	    <c:if test="${resStatus.index%8 == 2 }"><fmt:formatNumber value="${resultInfo.sctn3 }"/></c:if>
	                                	    <c:if test="${resStatus.index%8 == 3 }"><fmt:formatNumber value="${resultInfo.sctn4 }"/></c:if>
	                                	    <c:if test="${resStatus.index%8 == 4 }"><fmt:formatNumber value="${resultInfo.sctn5 }"/></c:if>
	                                	    <c:if test="${resStatus.index%8 == 5 }"><fmt:formatNumber value="${resultInfo.sctn6 }"/></c:if>
	                                	    <c:if test="${resStatus.index%8 == 6 }"><fmt:formatNumber value="${resultInfo.sctn7 }"/></c:if>
	                                	    <c:if test="${resStatus.index%8 == 7 }"><fmt:formatNumber value="${resultInfo.sctnSum }"/></c:if>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'B' }">
	                                    <c:if test="${resStatus.index%9 == 0 }"><fmt:formatNumber value="${resultInfo.sctn1 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 1 }"><fmt:formatNumber value="${resultInfo.sctn2 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 2 }"><fmt:formatNumber value="${resultInfo.sctn3 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 3 }"><fmt:formatNumber value="${resultInfo.sctn4 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 4 }"><fmt:formatNumber value="${resultInfo.sctn5 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 5 }"><fmt:formatNumber value="${resultInfo.sctn6 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 6 }"><fmt:formatNumber value="${resultInfo.sctn7 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 7 }"><fmt:formatNumber value="${resultInfo.sctn8 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 8 }"><fmt:formatNumber value="${resultInfo.sctnSum }"/></c:if>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'C' }">
	                                    <c:if test="${resStatus.index%9 == 0 }"><fmt:formatNumber value="${resultInfo.sctn1 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 1 }"><fmt:formatNumber value="${resultInfo.sctn2 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 2 }"><fmt:formatNumber value="${resultInfo.sctn3 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 3 }"><fmt:formatNumber value="${resultInfo.sctn4 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 4 }"><fmt:formatNumber value="${resultInfo.sctn5 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 5 }"><fmt:formatNumber value="${resultInfo.sctn6 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 6 }"><fmt:formatNumber value="${resultInfo.sctn7 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 7 }"><fmt:formatNumber value="${resultInfo.sctn8 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 8 }"><fmt:formatNumber value="${resultInfo.sctnSum }"/></c:if>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'D' }">
	                                    <c:if test="${resStatus.index%7 == 0 }"><fmt:formatNumber value="${resultInfo.sctn1 }"/></c:if>
	                                    <c:if test="${resStatus.index%7 == 1 }"><fmt:formatNumber value="${resultInfo.sctn2 }"/></c:if>
	                                    <c:if test="${resStatus.index%7 == 2 }"><fmt:formatNumber value="${resultInfo.sctn3 }"/></c:if>
	                                    <c:if test="${resStatus.index%7 == 3 }"><fmt:formatNumber value="${resultInfo.sctn4 }"/></c:if>
	                                    <c:if test="${resStatus.index%7 == 4 }"><fmt:formatNumber value="${resultInfo.sctn5 }"/></c:if>
	                                    <c:if test="${resStatus.index%7 == 5 }"><fmt:formatNumber value="${resultInfo.sctn6 }"/></c:if>	                                    
	                                    <c:if test="${resStatus.index%7 == 6 }"><fmt:formatNumber value="${resultInfo.sctnSum }"/></c:if>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'E' }">
	                                    <c:if test="${resStatus.index%7 == 0 }"><fmt:formatNumber value="${resultInfo.sctn1 }"/></c:if>
	                                    <c:if test="${resStatus.index%7 == 1 }"><fmt:formatNumber value="${resultInfo.sctn2 }"/></c:if>
	                                    <c:if test="${resStatus.index%7 == 2 }"><fmt:formatNumber value="${resultInfo.sctn3 }"/></c:if>
	                                    <c:if test="${resStatus.index%7 == 3 }"><fmt:formatNumber value="${resultInfo.sctn4 }"/></c:if>
	                                    <c:if test="${resStatus.index%7 == 4 }"><fmt:formatNumber value="${resultInfo.sctn5 }"/></c:if>
	                                    <c:if test="${resStatus.index%7 == 5 }"><fmt:formatNumber value="${resultInfo.sctn6 }"/></c:if>	                                    
	                                    <c:if test="${resStatus.index%7 == 6 }"><fmt:formatNumber value="${resultInfo.sctnSum }"/></c:if>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'F' }">
	                                    <c:if test="${resStatus.index%9 == 0 }"><fmt:formatNumber value="${resultInfo.sctn1 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 1 }"><fmt:formatNumber value="${resultInfo.sctn2 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 2 }"><fmt:formatNumber value="${resultInfo.sctn3 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 3 }"><fmt:formatNumber value="${resultInfo.sctn4 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 4 }"><fmt:formatNumber value="${resultInfo.sctn5 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 5 }"><fmt:formatNumber value="${resultInfo.sctn6 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 6 }"><fmt:formatNumber value="${resultInfo.sctn7 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 7 }"><fmt:formatNumber value="${resultInfo.sctn8 }"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 8 }"><fmt:formatNumber value="${resultInfo.sctnSum }"/></c:if>
	                                    </c:if>										
									</td>																		
									</c:if>
									<c:if test="${outYr != stdyySt }">
									<c:set var="sname1" value="y${status.count-1 }sctn1" />
									<c:set var="sname2" value="y${status.count-1 }sctn2" />
									<c:set var="sname3" value="y${status.count-1 }sctn3" />
									<c:set var="sname4" value="y${status.count-1 }sctn4" />
									<c:set var="sname5" value="y${status.count-1 }sctn5" />
									<c:set var="sname6" value="y${status.count-1 }sctn6" />
									<c:set var="sname7" value="y${status.count-1 }sctn7" />
									<c:set var="sname8" value="y${status.count-1 }sctn8" />
									<c:set var="snameSum" value="y${status.count-1 }sctnSum" />							
									<td class='tar'>
										<c:if test="${searchIndex == 'A' }">
	                                    <c:if test="${resStatus.index%8 == 0 }"><fmt:formatNumber value="${resultInfo[sname1]}"/></c:if>
	                                    <c:if test="${resStatus.index%8 == 1 }"><fmt:formatNumber value="${resultInfo[sname2]}"/></c:if>
	                                    <c:if test="${resStatus.index%8 == 2 }"><fmt:formatNumber value="${resultInfo[sname3]}"/></c:if>
	                                    <c:if test="${resStatus.index%8 == 3 }"><fmt:formatNumber value="${resultInfo[sname4]}"/></c:if>
	                                    <c:if test="${resStatus.index%8 == 4 }"><fmt:formatNumber value="${resultInfo[sname5]}"/></c:if>
	                                    <c:if test="${resStatus.index%8 == 5 }"><fmt:formatNumber value="${resultInfo[sname6]}"/></c:if>
	                                    <c:if test="${resStatus.index%8 == 6 }"><fmt:formatNumber value="${resultInfo[sname7]}"/></c:if>
	                                    <c:if test="${resStatus.index%8 == 7 }"><fmt:formatNumber value="${resultInfo[snameSum]}"/></c:if>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'B' }">
	                                    <c:if test="${resStatus.index%9 == 0 }"><fmt:formatNumber value="${resultInfo[sname1]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 1 }"><fmt:formatNumber value="${resultInfo[sname2]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 2 }"><fmt:formatNumber value="${resultInfo[sname3]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 3 }"><fmt:formatNumber value="${resultInfo[sname4]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 4 }"><fmt:formatNumber value="${resultInfo[sname5]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 5 }"><fmt:formatNumber value="${resultInfo[sname6]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 6 }"><fmt:formatNumber value="${resultInfo[sname7]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 7 }"><fmt:formatNumber value="${resultInfo[sname8]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 8 }"><fmt:formatNumber value="${resultInfo[snameSum]}"/></c:if>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'C' }">
	                                    <c:if test="${resStatus.index%9 == 0 }"><fmt:formatNumber value="${resultInfo[sname1]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 1 }"><fmt:formatNumber value="${resultInfo[sname2]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 2 }"><fmt:formatNumber value="${resultInfo[sname3]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 3 }"><fmt:formatNumber value="${resultInfo[sname4]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 4 }"><fmt:formatNumber value="${resultInfo[sname5]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 5 }"><fmt:formatNumber value="${resultInfo[sname6]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 6 }"><fmt:formatNumber value="${resultInfo[sname7]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 7 }"><fmt:formatNumber value="${resultInfo[sname8]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 8 }"><fmt:formatNumber value="${resultInfo[snameSum]}"/></c:if>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'D' }">
	                                    <c:if test="${resStatus.index%7 == 0 }"><fmt:formatNumber value="${resultInfo[sname1]}"/></c:if>
	                                    <c:if test="${resStatus.index%7 == 1 }"><fmt:formatNumber value="${resultInfo[sname2]}"/></c:if>
	                                    <c:if test="${resStatus.index%7 == 2 }"><fmt:formatNumber value="${resultInfo[sname3]}"/></c:if>
	                                    <c:if test="${resStatus.index%7 == 3 }"><fmt:formatNumber value="${resultInfo[sname4]}"/></c:if>
	                                    <c:if test="${resStatus.index%7 == 4 }"><fmt:formatNumber value="${resultInfo[sname5]}"/></c:if>
	                                    <c:if test="${resStatus.index%7 == 5 }"><fmt:formatNumber value="${resultInfo[sname6]}"/></c:if>	                                    
	                                    <c:if test="${resStatus.index%7 == 6 }"><fmt:formatNumber value="${resultInfo[snameSum]}"/></c:if>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'E' }">
	                                    <c:if test="${resStatus.index%7 == 0 }"><fmt:formatNumber value="${resultInfo[sname1]}"/></c:if>
	                                    <c:if test="${resStatus.index%7 == 1 }"><fmt:formatNumber value="${resultInfo[sname2]}"/></c:if>
	                                    <c:if test="${resStatus.index%7 == 2 }"><fmt:formatNumber value="${resultInfo[sname3]}"/></c:if>
	                                    <c:if test="${resStatus.index%7 == 3 }"><fmt:formatNumber value="${resultInfo[sname4]}"/></c:if>
	                                    <c:if test="${resStatus.index%7 == 4 }"><fmt:formatNumber value="${resultInfo[sname5]}"/></c:if>
	                                    <c:if test="${resStatus.index%7 == 5 }"><fmt:formatNumber value="${resultInfo[sname6]}"/></c:if>	                                    
	                                    <c:if test="${resStatus.index%7 == 6 }"><fmt:formatNumber value="${resultInfo[snameSum]}"/></c:if>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'F' }">
	                                    <c:if test="${resStatus.index%9 == 0 }"><fmt:formatNumber value="${resultInfo[sname1]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 1 }"><fmt:formatNumber value="${resultInfo[sname2]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 2 }"><fmt:formatNumber value="${resultInfo[sname3]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 3 }"><fmt:formatNumber value="${resultInfo[sname4]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 4 }"><fmt:formatNumber value="${resultInfo[sname5]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 5 }"><fmt:formatNumber value="${resultInfo[sname6]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 6 }"><fmt:formatNumber value="${resultInfo[sname7]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 7 }"><fmt:formatNumber value="${resultInfo[sname8]}"/></c:if>
	                                    <c:if test="${resStatus.index%9 == 8 }"><fmt:formatNumber value="${resultInfo[snameSum]}"/></c:if>
	                                    </c:if>																			
									</td>
									</c:if>									
								</c:forEach>
								</tr>
                           	</c:forEach>
                            </tbody>
                        </table>
	                    </div>
	        <br><br>
	        <div class="btn_page_last"> 
	        	<a class="btn_page_admin" href="javascript:window.print();"><span>인쇄</span></a> 
	        	<a class="btn_page_admin" href="#" onclick="parent.$.fn.colorbox.close();"><span>닫기</span></a>
	        </div>
	        <br><br>
	    </div>
	    <!--리스트영역 //-->
	</div>
	<!--content//-->
	</div>
</div>
</form>
</body>
</html>