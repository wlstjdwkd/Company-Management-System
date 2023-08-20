<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@	taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<div class="add_table">
<table cellspacing="0" border="0" summary="기업통계" class="list" id="tblStatics">
   <caption>
    리스트
    </caption>
    <colgroup>
	<c:if test="${!empty param.sel_area }">
    <col width="*" />
	</c:if>
	<c:if test="${!empty param.induty_select }">
    <col width="*" />
	</c:if>
	<col width="*" />
    <col width="*" />
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
        	<c:if test="${!empty param.sel_area }">
            <th scope="col" rowspan="2">지역</th>
        	</c:if>
            <c:if test="${!empty param.induty_select }">
            <th scope="col" rowspan="2">업종</th>
            </c:if>
            <th scope="col" rowspan="2">기업수(개)</th>
            <th scope="col" colspan="2">매출(천원)</th>
            <th scope="col" colspan="2">고용(만명)</th>
            <th scope="col" colspan="2">수출(원)</th>
            <th scope="col" colspan="2">연구개발비</th>
        </tr>
        <tr>
            <th scope="col">평균(억원)</th>
            <th scope="col">성장률</th>
            <th scope="col">평균(명)</th>
            <th scope="col">성장률</th>
            <th scope="col">평균(억원)</th>
            <th scope="col">성장률</th>
            <th scope="col">평균(억원)</th>
            <th scope="col">성장률</th>                                    
        </tr>
    </thead>
    <tbody>    	
    	<c:if test="${empty resultList }"><input type="hidden" id="empty_resultList" /></c:if>
		<c:forEach items="${resultList }" var="resultInfo" varStatus="status">                         		
		<tr>
		<c:if test="${not empty param.sel_area}">
			<td id='rowspan' class='tac'>
			<c:if test="${param.sel_area == 'A' }">${resultInfo.AREA_NM }</c:if>
			<c:if test="${param.sel_area == 'C' }">${resultInfo.ABRV }</c:if>
			</td>
		</c:if>
		<c:if test="${not empty param.induty_select}">
			<td class='tal'>
			 
			<c:if test="${param.induty_select == 'I' or resultInfo.gbnIs == 'S' }">${resultInfo.indutySeNm }</c:if>
			<c:if test="${param.induty_select == 'T' and resultInfo.gbnIs == 'D' }">&emsp;&emsp;&emsp;${resultInfo.dtlclfcNm }</c:if>
			<c:if test="${param.induty_select == 'D' and resultInfo.gbnIs == 'D' }">&emsp;&emsp;&emsp;${resultInfo.indutyNm }</c:if>
			
			<!-- 현재 리스트를 출력하기 위한 처리 --> 
			<c:if test="${param.induty_select == 'I'}">${resultInfo.INDUTY_GUBUN }</c:if>
			<c:if test="${param.induty_select == 'T'}">&emsp;&emsp;&emsp;${resultInfo.COL1 }</c:if>
			<c:if test="${param.induty_select == 'D'}">&emsp;&emsp;&emsp;${resultInfo.COL1 }</c:if>
			</td>
		</c:if>
			<td class='tar'><fmt:formatNumber value="${resultInfo.ENTRPRS_CO }"/></td>
			<td class='tar'><fmt:formatNumber value="${resultInfo.SELNG_AM }"/></td>
			<td class='tar'><fmt:formatNumber value="${resultInfo.SELNG_RT }"/></td>
			<td class='tar'><fmt:formatNumber value="${resultInfo.ORDTM_LABRR_CO }"/></td>
			<td class='tar'><fmt:formatNumber value="${resultInfo.ORDTM_RT }"/></td>
			<td class='tar'><fmt:formatNumber value="${resultInfo.XPORT_AM_WON }"/></td>
			<td class='tar'><fmt:formatNumber value="${resultInfo.XPORT_AM_WON_RT }"/></td>
			<td class='tar'><fmt:formatNumber value="${resultInfo.RSRCH_DEVLOP_CT }"/></td>
			<td class='tar'><fmt:formatNumber value="${resultInfo.RSRCH_RT }"/></td>
		</tr>
		</c:forEach>      
    </tbody>
</table>
</div>