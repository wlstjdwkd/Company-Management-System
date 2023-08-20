<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl"%>

<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery,cookie,flot,form,jqGrid,noticetimer,tools,ui,validate,notice" />
<ap:jsTag type="tech" items="pc,util,acm" />

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
		<c:forEach items="${areaResultList}" var="areaResult" varStatus="status">
			<c:if test="${searchArea != null}">
				<c:if test="${searchArea=='1'}">
					<input type="hidden" name="tick2" value="${areaResult.upperNm}" />
				</c:if>
				<c:if test="${searchArea=='2'}">
					<input type="hidden" name="tick2" value="${areaResult.abrv}" />
				</c:if>

				<input type="hidden" name="areaB2bCo" value="${areaResult.b2bCo}" />
				<input type="hidden" name="areaB2cCo" value="${areaResult.b2cCo}" />
				<input type="hidden" name="areaB2gCo" value="${areaResult.b2gCo}" />
			</c:if>
		</c:forEach>

		<c:forEach items="${indutyResultList}" var="indutyResult" varStatus="status">
			<c:if test="${searchInduty != null}">
				<c:if test="${searchInduty=='1'}">
					<input type="hidden" name="tick1" value="${indutyResult.indutySeNm}" />
				</c:if>
				<c:if test="${searchInduty=='2'}">
					<input type="hidden" name="tick1" value="${indutyResult.dtlclfcNm}" />
				</c:if>
				<c:if test="${searchInduty=='3'}">
					<input type="hidden" name="tick1" value="${indutyResult.indutyNm}" />
				</c:if>

				<input type="hidden" name="indutyB2bCo" value="${indutyResult.b2bCo}" />
				<input type="hidden" name="indutyB2cCo" value="${indutyResult.b2cCo}" />
				<input type="hidden" name="indutyB2gCo" value="${indutyResult.b2gCo}" />
			</c:if>
		</c:forEach>

		<div id="self_dgs">
			<div class="pop_q_con">
				<!--// 검색 조건 -->
				<div class="search_top">
					<table cellpadding="0" cellspacing="0" class="table_search" summary="거래유형별 현황 챠트">
						<caption>주요지표 현황 표</caption>
						<colgroup>
							<col width="15%" />
							<col width="25%" />
							<col width="15%" />
							<col width="25%" />
						</colgroup>
						<tr>
							<th scope="row">기업군</th>
							<td>${searchEntprsGrp}</td>
							<th scope="row">년도</th>
							<td>${searchStdyy}</td>
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
					</table>
                       <!-- // 리스트 -->
	                    <div class="list_zone mgt30">
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
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            </colgroup>
                            <thead>
                                <tr>
                                	<c:if test="${!empty param.searchArea }">
                                    <th scope="col" rowspan="2">지역</th>
                                	</c:if>
                                    <c:if test="${!empty param.searchInduty }">
                                    <th scope="col" rowspan="2">업종</th>
                                    </c:if>
                                    <th scope="col" colspan="2">외투기업</th>
                                    <th scope="col" colspan="2">비외투기업</th>
                                    <th scope="col" colspan="2">합계</th>
                                </tr>
                                <tr>
                                    <th scope="col">국내매출</th>
                                    <th scope="col">해외매출</th>
                                    <th scope="col">국내매출</th>
                                    <th scope="col">해외매출</th>
                                    <th scope="col">국내매출</th>
                                    <th scope="col">해외매출</th>                                    
                                </tr>
                            </thead>
                            <tbody>
                            
							<c:forEach items="${resultList }" var="resultInfo" varStatus="status">                         		
								<tr>
								<c:if test="${not empty param.searchArea}">
                                    <td id='rowspan' class='tac'>
									<c:if test="${param.searchArea == 1 }">${resultInfo.upperNm }</c:if>
									<c:if test="${param.searchArea == 2 }">${resultInfo.abrv }</c:if>
									</td>
								</c:if>
								<c:if test="${not empty param.searchInduty}">
                                    <td class='tal'>
									<c:if test="${param.searchInduty == 1 or resultInfo.gbnIs == 'S' }">${resultInfo.indutySeNm }</c:if>
									<c:if test="${param.searchInduty == 2 and resultInfo.gbnIs == 'D' }">&emsp;&emsp;&emsp;${resultInfo.dtlclfcNm }</c:if>
									<c:if test="${param.searchInduty == 3 and resultInfo.gbnIs == 'D' }">&emsp;&emsp;&emsp;${resultInfo.indutyNm }</c:if>
									</td>
								</c:if>
									<td class='tar'><fmt:formatNumber value="${resultInfo.fieDomeAm }"/></td>
									<td class='tar'><fmt:formatNumber value="${resultInfo.nfieXportAm }"/></td>
									<td class='tar'><fmt:formatNumber value="${resultInfo.fieDomeAm }"/></td>
									<td class='tar'><fmt:formatNumber value="${resultInfo.nfieXportAm }"/></td>
									<td class='tar'><fmt:formatNumber value="${resultInfo.sumDomeAm }"/></td>
									<td class='tar'><fmt:formatNumber value="${resultInfo.sumXportAm }"/></td>
								</tr>
                           	</c:forEach>        
                            </tbody>
                        </table>
	                    </div>
					<div class="btn_page_last">
						<a class="btn_page_admin" href="javascript:window.print();"><span>인쇄</span></a> <a
							class="btn_page_admin" href="#" onclick="parent.$.fn.colorbox.close();"><span>닫기</span></a>
					</div>
					<!--chart영역 //-->
				</div>
				<!--content//-->
			</div>
		</div>
	</form>
</body>
</html>