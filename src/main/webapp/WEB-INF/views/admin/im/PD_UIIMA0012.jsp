<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,form,validate,notice,msgBoxAdmin" />
<ap:jsTag type="tech" items="msg,util,acm,im" />
<ap:globalConst />	
<script type="text/javascript">
$(document).ready(function(){

});
</script>
</head>

<body>
<form name="dataForm" id="dataForm" method="post" action="/PGIM0010.do">
<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />
<ap:include page="param/pagingParam.jsp" />
<input type="hidden" id="no_lnb" value="true" />

<div id="self_dgs">
<div class="pop_q_con">
	<c:if test="${!empty entprsFnnrDataList}">   
	<c:set var="baseFnnrData" value="${entprsFnnrDataList[0]}" />
	</c:if>
   <div class="table_hrz"> <span class="fr"><strong>${baseFnnrData.STDYY}년 기준&nbsp;&nbsp;</strong></span>
        <!--//table1-->
        <table cellpadding="0" cellspacing="0" class="table_basic" summary="신용평가사" >
            <caption>
            신용평가사
            </caption>
            <colgroup>
            <col width="20%" />
            <col width="40%" />
            <col width="40%" />
            </colgroup>
            <thead>
            <th scope="row">구분</th>               
               <th scope="col">신용평가사</th>               
            <tbody>
                <tr>
                    <th scope="row">기업명</th>
                    <td class="tal">${baseFnnrData.ENTRPRS_NM}</td>
                </tr>
                <tr>
                    <th scope="row">법인등록번호</th>
                    <td class="tal">
                    <c:choose>
					<c:when test="${!empty baseFnnrData.JURIRNO_FIRST}">
					${baseFnnrData.JURIRNO_FIRST}-${baseFnnrData.JURIRNO_LAST}
					</c:when>       
					<c:otherwise>
					${baseFnnrData.JURIRNO}
					</c:otherwise>
					</c:choose>
					</td>
                </tr>
                <tr>
                    <th scope="row">사업자번호</th>
                    <td class="tal">
                    <c:choose>
					<c:when test="${!empty baseFnnrData.BIZRNO_FIRST}">
					${baseFnnrData.BIZRNO_FIRST}-${baseFnnrData.BIZRNO_MIDDLE}-${baseFnnrData.BIZRNO_LAST}
					</c:when>       
					<c:otherwise>
					${baseFnnrData.BIZRNO}
					</c:otherwise>
					</c:choose>
					</td>
                </tr>
                <tr>
                    <th scope="row">대표자명</th>
                    <td class="tal">${baseFnnrData.RPRSNTV_NM}</td>
                </tr>
                <tr>
                    <th scope="row">표준산업분류코드(주업종명) </th>
                    <td class="tal">${baseFnnrData.DTLDTLCLFC_CD}(${baseFnnrData.DTLDTLCLFC_CD_NM})</td>
                </tr>
                <tr>
                    <th scope="row">주소</th>
                    <td class="tal">${baseFnnrData.HEDOFC_ADRES}</td>
                </tr>
                <tr>
                    <th scope="row">전화번호</th>
                    <td class="tal">
                    <c:choose>
					<c:when test="${!empty baseFnnrData.REPRSNT_TLPHON_FIRST}">
					${baseFnnrData.REPRSNT_TLPHON_FIRST}-${baseFnnrData.REPRSNT_TLPHON_MIDDLE}-${baseFnnrData.REPRSNT_TLPHON_LAST}
					</c:when>       
					<c:otherwise>
					${baseFnnrData.REPRSNT_TLPHON}
					</c:otherwise>
					</c:choose>
                    </td>
                </tr>
                <tr>
                    <th scope="row">설립년도</th>
                    <td class="tal">
                    <c:choose>
					<c:when test="${!empty baseFnnrData.FOND_DE_YR}">
					${baseFnnrData.FOND_DE_YR}년 ${baseFnnrData.FOND_DE_MT}월 ${baseFnnrData.FOND_DE_DY}일
					</c:when>       
					<c:otherwise>
					${baseFnnrData.FOND_DE}
					</c:otherwise>
					</c:choose>                    
                    </td>
                </tr>
                <tr>
                    <th scope="row">결산일</th>
                    <td class="tal">                    
                    <c:choose>
					<c:when test="${!empty baseFnnrData.PSACNT_MT}">
					${baseFnnrData.PSACNT_MT}월 ${baseFnnrData.PSACNT_DY}일
					</c:when>       
					<c:otherwise>
					${baseFnnrData.PSACNT}
					</c:otherwise>
					</c:choose>                    
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <!--//table2-->
    <!-- // 리스트영역-->
    <span class="mgb10 fr"><strong>단위 : 천원&nbsp;&nbsp;</strong></span>
    <div class="list_zone">
        <table cellpadding="0" cellspacing="0" class="table_basic" summary="신용평가사" >
            <caption>
            신용평가사
            </caption>
            <colgroup>
            <col width="*" />
            <col width="*" />
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
            </thead>
            <tr>
                <th rowspan="2" scope="row">구분</th>
                <th colspan="5" scope="col">신용평가사</th>
            </tr>
             <tr>
                <th scope="col">매출액</th>
                <th scope="col">자본금</th>
                <th scope="col">자본잉여금</th>
                <th scope="col">자본총계</th>
                <th scope="col">자산총액</th>
            </tr>
            <tbody>            
            <c:forEach var="entprsFnnrData" items="${entprsFnnrDataList}">
                <tr>
                    <th scope="row">${entprsFnnrData.STDYY}년</th>
                    <td class="tar"><fmt:formatNumber value="${entprsFnnrData.SELNG_AM}" type="currency" /></td>
                    <td class="tar"><fmt:formatNumber value="${entprsFnnrData.CAPL}" type="currency" /></td>
                    <td class="tar"><fmt:formatNumber value="${entprsFnnrData.CLPL }" type="currency" /></td>
                    <td class="tar"><fmt:formatNumber value="${entprsFnnrData.CAPL_SM}" type="currency" /></td>
                    <td class="tar"><fmt:formatNumber value="${entprsFnnrData.ASSETS_SM}" type="currency" /></td>
                </tr>
			</c:forEach>
            </tbody>
        </table>
    </div>
    <!--리스트영역 //-->
   
</div>
</div>
</form>
</body>
</html>