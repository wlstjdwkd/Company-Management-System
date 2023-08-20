<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox" />
<ap:jsTag type="tech" items="msg,util,ucm,cs" />

<script type="text/javascript">

$(document).ready(function(){	
 	
}); // ready

var fn_load_apply_info = function(empmnNo){
	var prtDoc = $(parent.document);
	$("#ad_virtl_empmn_manage_no", prtDoc).val(empmnNo);
	$("#df_method_nm", prtDoc).val("applyCmpnyForm");
	$("#dataForm", prtDoc).submit();
	
};

</script>
</head>
<body>

<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">

<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/pagingParam.jsp" />

<div class="list_zone">
    <table>
        <caption>
        기본게시판 목록
        </caption>
        <colgroup>
        <col />
        <col />
        <col />
        <col />
        <col />
        <col />
        </colgroup>
        <thead>
            <tr>
                <th scope="col">접수여부</th>
                <th scope="col">분류</th>
                <th scope="col">지원서</th>
                <th scope="col">직종</th>
                <th scope="col">채용기간</th>
                <th scope="col">입사지원일</th>
            </tr>
        </thead>
        <tbody>            
            <c:forEach items="${applyList }" var="apply" varStatus="status">
            <tr>
            	<td>
            		<c:choose>
            		<c:when test="${apply.RCEPT_AT == 'Y' }">접수</c:when>
            		<c:otherwise>임시저장</c:otherwise>
            		</c:choose>                             
            	</td>
                <td class="tal">${apply.ENTRPRS_NM }</td>
                <td class="tal">
                	<a href="#none" onclick="fn_load_apply_info('${apply.EMPMN_MANAGE_NO}')" >
                	<c:if test="${empty apply.APPLY_SJ }">제목없음</c:if>
                	${apply.APPLY_SJ }
                	</a>
               	</td>
                <td>${apply.JSSFC }</td>
                <td>${apply.RCRIT_BEGIN_DE } ~ ${apply.RCRIT_END_DE }</td>
                <td>${apply.RCEPT_DE }</td>
            </tr>                               
            </c:forEach>                    
        </tbody>
    </table>
</div>
</form>

</body>
</html>