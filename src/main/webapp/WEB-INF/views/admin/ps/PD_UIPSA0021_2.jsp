<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	                                    <c:if test="${searchIndex == 'A' }">
	                                    <th scope="col">없음</th>
	                                    <th scope="col">1.0%미만</th>
	                                    <th scope="col">2.0~3.0%</th>
	                                    <th scope="col">3.0~5.0%</th>
	                                    <th scope="col">5.0%~10.0%</th>
	                                    <th scope="col">10.0%~30.0%</th>
	                                    <th scope="col">30.0%이상</th>
	                                    <th scope="col">합계</th>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'B' }">
	                                    <th scope="col">100억미만</th>
	                                    <th scope="col">100억원~500억원</th>
	                                    <th scope="col">500억원~1천억원</th>
	                                    <th scope="col">1천억원~2천억원</th>
	                                    <th scope="col">2천억원~3천억원</th>
	                                    <th scope="col">3천억원~5천억원</th>
	                                    <th scope="col">5천억원~1조원</th>
	                                    <th scope="col">1조원이상</th>
	                                    <th scope="col">합계</th>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'C' }">
	                                    <th scope="col">없음</th>
	                                    <th scope="col">1백만불 미만</th>
	                                    <th scope="col">1백만~5백만불</th>
	                                    <th scope="col">5백만~1천만불</th>
	                                    <th scope="col">1천만~3천만불</th>
	                                    <th scope="col">3천만~5천만불</th>
	                                    <th scope="col">5천만~1억불</th>
	                                    <th scope="col">1억불 이상</th>	                                    
	                                    <th scope="col">합계</th>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'D' }">
	                                    <th scope="col">10인 미만</th>
	                                    <th scope="col">10인~50인</th>
	                                    <th scope="col">50인~100인</th>
	                                    <th scope="col">100인~200인</th>
	                                    <th scope="col">200인~300인</th>
	                                    <th scope="col">300인 이상</th>	                                    
	                                    <th scope="col">합계</th>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'E' }">
	                                    <th scope="col">0~6년</th>
	                                    <th scope="col">7~20년</th>
	                                    <th scope="col">21~30년</th>
	                                    <th scope="col">31~40년</th>
	                                    <th scope="col">41~50년</th>
	                                    <th scope="col">51년이상</th>	                                    
	                                    <th scope="col">합계</th>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'F' }">
	                                    <th scope="col">100억미만</th>
	                                    <th scope="col">100억원~500억원</th>
	                                    <th scope="col">500억원~1천억원</th>
	                                    <th scope="col">1천억원~2천억원</th>
	                                    <th scope="col">2천억원~3천억원</th>
	                                    <th scope="col">3천억원~5천억원</th>
	                                    <th scope="col">5천억원~1조원</th>
	                                    <th scope="col">1조원이상</th>
	                                    <th scope="col">합계</th>
	                                    </c:if>	                                    
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
									<c:if test="${searchIndex == 'A' }">
	                                    <td class="tar">${resultInfo.sctn1 }</td>
	                                    <td class="tar">${resultInfo.sctn2 }</td>
	                                    <td class="tar">${resultInfo.sctn3 }</td>
	                                    <td class="tar">${resultInfo.sctn4 }</td>
	                                    <td class="tar">${resultInfo.sctn5 }</td>
	                                    <td class="tar">${resultInfo.sctn6 }</td>
	                                    <td class="tar">${resultInfo.sctn7 }</td>
	                                    <td class="tar">${resultInfo.sctnSum }</td>
	                                </c:if>
                                    <c:if test="${searchIndex == 'B' }">
	                                    <td class="tar">${resultInfo.sctn1 }</td>
	                                    <td class="tar">${resultInfo.sctn2 }</td>
	                                    <td class="tar">${resultInfo.sctn3 }</td>
	                                    <td class="tar">${resultInfo.sctn4 }</td>
	                                    <td class="tar">${resultInfo.sctn5 }</td>
	                                    <td class="tar">${resultInfo.sctn6 }</td>
	                                    <td class="tar">${resultInfo.sctn7 }</td>
	                                    <td class="tar">${resultInfo.sctn8 }</td>
	                                    <td class="tar">${resultInfo.sctnSum }</td>
                                    </c:if>
                                    <c:if test="${searchIndex == 'C' }">
	                                    <td class="tar">${resultInfo.sctn1 }</td>
	                                    <td class="tar">${resultInfo.sctn2 }</td>
	                                    <td class="tar">${resultInfo.sctn3 }</td>
	                                    <td class="tar">${resultInfo.sctn4 }</td>
	                                    <td class="tar">${resultInfo.sctn5 }</td>
	                                    <td class="tar">${resultInfo.sctn6 }</td>
	                                    <td class="tar">${resultInfo.sctn7 }</td>
	                                    <td class="tar">${resultInfo.sctn8 }</td>
	                                    <td class="tar">${resultInfo.sctnSum }</td>
                                    </c:if>
                                    <c:if test="${searchIndex == 'D' }">
	                                    <td class="tar">${resultInfo.sctn1 }</td>
	                                    <td class="tar">${resultInfo.sctn2 }</td>
	                                    <td class="tar">${resultInfo.sctn3 }</td>
	                                    <td class="tar">${resultInfo.sctn4 }</td>
	                                    <td class="tar">${resultInfo.sctn5 }</td>
	                                    <td class="tar">${resultInfo.sctn6 }</td>	                                    
	                                    <td class="tar">${resultInfo.sctnSum }</td>
                                    </c:if>
                                    <c:if test="${searchIndex == 'E' }">
	                                    <td class="tar">${resultInfo.sctn1 }</td>
	                                    <td class="tar">${resultInfo.sctn2 }</td>
	                                    <td class="tar">${resultInfo.sctn3 }</td>
	                                    <td class="tar">${resultInfo.sctn4 }</td>
	                                    <td class="tar">${resultInfo.sctn5 }</td>
	                                    <td class="tar">${resultInfo.sctn6 }</td>	                                    
	                                    <td class="tar">${resultInfo.sctnSum }</td>
                                    </c:if>
                                    <c:if test="${searchIndex == 'F' }">
	                                    <td class="tar">${resultInfo.sctn1 }</td>
	                                    <td class="tar">${resultInfo.sctn2 }</td>
	                                    <td class="tar">${resultInfo.sctn3 }</td>
	                                    <td class="tar">${resultInfo.sctn4 }</td>
	                                    <td class="tar">${resultInfo.sctn5 }</td>
	                                    <td class="tar">${resultInfo.sctn6 }</td>
	                                    <td class="tar">${resultInfo.sctn7 }</td>
	                                    <td class="tar">${resultInfo.sctn8 }</td>
	                                    <td class="tar">${resultInfo.sctnSum }</td>
                                    </c:if>	 									
									</tr>
	                           	</c:forEach>
	                            </tbody>
	                        </table>
		                    </div>


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