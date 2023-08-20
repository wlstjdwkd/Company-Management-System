<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@	taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<div class="add_table">
<table cellspacing="0" border="0" summary="기업통계" class="list" id="tblStatics2">
   <caption>
    리스트
    </caption>
    <colgroup>	
	<col width="*" />
    <col width="*" />    
    <c:forEach items="${seachedYears }">
    <col width="*" />
    </c:forEach>
    
    </colgroup>
    <thead>
        <tr>        	
            <th scope="col">구분</th>
            <th scope="col">구분</th>
            <c:forEach items="${seachedYears }" var="year">
            <th scope="col">${year }</th>
            </c:forEach>
        </tr>        
    </thead>
    <tbody>    	
    	<c:if test="${empty resultList }"><input type="hidden" id="empty_flag2" value="N"/></c:if>
    	<c:if test="${not empty resultList }"><input type="hidden" id="empty_flag2" value="Y"/></c:if>
		<c:forEach items="${resultList }" var="resultInfo" varStatus="status"> 
			<tr>                       		
				<td>${resultInfo.GUBUN }</td>
	       		<td>${resultInfo.GUBUN2 }</td>
	       		<c:forEach items="${seachedYears }" var="year">
	       		<td>${resultInfo[year] }</td>
	       		</c:forEach>
       		</tr>
		</c:forEach>      
    </tbody>
</table>
</div>