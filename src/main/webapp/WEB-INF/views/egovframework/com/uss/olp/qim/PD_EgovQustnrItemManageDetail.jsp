<%--
  Class Name : EgovQustnrItemManageDetail.jsp
  Description : 설문항목 상세보기
  Modification Information
 
      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2008.03.09    장동한          최초 생성
 
    author   : 공통서비스 개발팀 장동한
    since    : 2009.03.09
   
--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<%pageContext.setAttribute("crlf", "\r\n"); %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>설문항목 상세보기</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javascript">
/* ********************************************************
 * 목록 으로 가기
 ******************************************************** */
function fn_egov_list_QustnrItemManage(){
	var form = document.getElementById("QustnrItemManageForm");
	form.df_method_nm.value = "";
	form.submit();
}
/* ********************************************************
 * 수정처리화면
 ******************************************************** */
function fn_egov_modify_QustnrItemManage(){
	var form = document.getElementById("QustnrItemManageForm");
	form.df_method_nm.value = "updateEgovQustnrItemManage";
	form.submit();
}
/* ********************************************************
 * 삭제처리
 ******************************************************** */
function fn_egov_delete_QustnrItemManage(){
	
	jsMsgBox(null, 'confirm','<spring:message code="fail.common.custom" arguments="삭제 시 설문항목/설문결과 정보가 함께 삭제됩니다!" /> <spring:message code="confirm.common.delete" />',
			function(){
				$("#df_method_nm").val("deleteEgovQustnrItemManage");
				$("#QustnrItemManageForm").submit();
			});		
}
</script>
</head>
<body>
<div id="self_dgs">
	<div class="pop_q_con">	
		<div>
				<form name="QustnrItemManageForm" id="QustnrItemManageForm" action="<c:url value='${svcUrl }'/>" method="post">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				
				<!-- LNB 출력 방지 -->
				<input type="hidden" id="no_lnb" value="true" />
					
				<input type="hidden" name="qestnrId" id="qestnrId" value="<c:out value="${resultList[0].qestnrId}" />">
				<input type="hidden" name="qestnrTmplatId" id="qestnrTmplatId" value="<c:out value="${resultList[0].qestnrTmplatId}" />">  
  				<input type="hidden" name="qestnrQesitmId" id=qestnrQesitmId"" value="<c:out value="${resultList[0].qestnrQesitmId}" />">
				<input type="hidden" name="qustnrIemId" id="qustnrIemId" value="<c:out value="${resultList[0].qustnrIemId}" />">
				
                    <table cellpadding="0" cellspacing="0" class="table_basic" summary="설문항목상세조회">
                        <caption>
                        설문항목상세조회
                        </caption>
                        <colgroup>
                        <col width="150" />
                        <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row"> 설문제목</th>
                                <td><c:out value="${fn:replace(resultList[0].qestnrCn , crlf , '<br/>')}" escapeXml="false" /></td>
                            </tr>
                            <tr>
                                <th scope="row"> 설문문항</th>
                                <td><c:out value="${fn:replace(resultList[0].qestnrQesitmCn , crlf , '<br/>')}" escapeXml="false" /></td>
                            </tr>
                            <tr>
                                <th scope="row"> 항목순번</th>
                                <td><c:out value="${resultList[0].iemSn}" /></td>
                            </tr>
                            <tr>
                                <th scope="row">항목내용</th>
                                <td><c:out value="${fn:replace(resultList[0].iemCn , crlf , '<br/>')}" escapeXml="false" /></td>
                            </tr>
                            <tr>
                                <th scope="row"> 기타답변여부</th>
                                <td><c:if test="${resultList[0].etcAnswerAt == 'Y'}">Yes</c:if><c:if test="${resultList[0].etcAnswerAt != 'Y'}">No</c:if></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="btn_page_last">
                	<a class="btn_page_admin" href="#none" onclick="fn_egov_list_QustnrItemManage();"><span>목록</span></a> 
                	<a class="btn_page_admin" href="#none" onclick="fn_egov_delete_QustnrItemManage();"><span>삭제</span></a> 
                	<a class="btn_page_admin" href="#none" onclick="fn_egov_modify_QustnrItemManage();"><span>수정</span></a> 
                </div>
</div>
</body>
</html>
