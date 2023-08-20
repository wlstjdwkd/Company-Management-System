<%@ page pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%> 

<div class="total">
	<p>전체 <strong><fmt:formatNumber value="${pager.totalRowCount}"/></strong> 건 (<strong>${pager.pageNo}</strong> / ${pager.finalPageNo}page)</p>
	<fieldset class="fr">
		<legend>페이지당 목록갯수 선택</legend>
		<c:choose>
		<c:when test="${empty addJsRowParam}">
        	<select class="select_box" style="width:120px;" onchange="${setRowScript}(this.value)">
        </c:when>
        <c:otherwise>
            <select class="select_box" style="width:120px;" onchange="${setRowScript}(this.value,${addJsRowParam})">
        </c:otherwise>
		</c:choose>
		<%-- <select name="" id="" style="width:120px;" onchange="${setRowScript}(this.value,null,'${addJsParam}')"> --%>
			<c:forEach items="${DEF_ROW_OPT}" var="rowNum">
			    <option value="${rowNum}" <c:if test="${rowNum eq pager.rowSize}">selected="selected"</c:if>>${rowNum}개씩 보기</option>
			</c:forEach>
		</select>
	</fieldset>
</div>

