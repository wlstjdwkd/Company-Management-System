<%--
  Class Name : EgovQustnrItemManageModify.jsp
  Description : 설문항목 수정 페이지
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
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<%pageContext.setAttribute("crlf", "\r\n"); %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>설문항목수정</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javascript">

$(document).ready(function(){

    // form submit validation
	$("#qustnrItemManageVO").validate({
		rules : {
			iemSn: {
				required: true,
				number: true,
				min: 1,
				max: 999
			},
			iemCn: {
				required: true,
				maxlength: 1000
			},
			etcAnswerAt: {
				required: true
			}
		},
		submitHandler: function(form) {
			
			jsMsgBox(null, 'confirm','<spring:message code="confirm.common.save" />', function(){
				$("#cmd").val("save");
				$("#df_method_nm").val("updateEgovQustnrItemManage");
				form.submit();
			});
		}
	});	
	
});

/* ********************************************************
 * 목록 으로 가기
 ******************************************************** */
function fn_egov_list_QustnrItemManage(){
	var form = document.getElementById("qustnrItemManageVO");
	
	form.action = "<c:url value='${svcUrl}' />";
	form.df_method_nm.value="EgovQustnrItemManageList";
	form.submit();
}

function checkSn() {
	$.ajax({
		url      : "PGSO0040.do",
		type     : "POST",
		dataType : "json",
		data     : { df_method_nm: "EgovQustnrItemCheckSn", qestnrId: $("#qestnrId").val(), qestnrTmplatId: $("#qestnrTmplatId").val(), qestnrQesitmId: $("#qestnrQesitmId").val(), iemSn: $("#iemSn").val(), qustnrIemId: $("#qustnrIemId").val() },
        //data     : $('#dataForm').formSerialize(),
		async    : false,                
		success  : function(response) {
			try {
				if(response.result) {
				} else {
					jsMsgBox($("#iemSn"), "error", Message.template.duplicationQustnrSn("항목"));
				}
			} catch (e) {
				if(response != null) {
					jsSysErrorBox(response);
				} else {
					jsSysErrorBox(e);
				}
				return;
			}                
		}
	});
}
</script>
</head>
<body>
<div id="self_dgs">
	<div class="pop_q_con">	
		<div>
			<h3> <span>항목은 입력 필수 항목 입니다.</span> </h3>
			
			<form:form commandName="qustnrItemManageVO" action="${svcUrl}" method="post">
			<ap:include page="param/defaultParam.jsp" />
			<ap:include page="param/dispParam.jsp" />
			
			<!-- LNB 출력 방지 -->
			<input type="hidden" id="no_lnb" value="true" />
			
			<input type="hidden" name="qestnrId" id="qestnrId" value="<c:out value="${resultList[0].qestnrId}" />" />
			<input type="hidden" name="qestnrTmplatId" id="qestnrTmplatId" value="<c:out value="${resultList[0].qestnrTmplatId}" />" />
			<input type="hidden" name="qestnrQesitmId" id="qestnrQesitmId" value="${resultList[0].qestnrQesitmId}">
			<input type="hidden" name="qustnrIemId" id="qustnrIemId" value="${resultList[0].qustnrIemId}">
			
			<input type="hidden" name="cmd" id="cmd" value="">
			
	         <table cellpadding="0" cellspacing="0" class="table_basic" summary="설문항목수정">
	             <caption>
	                 설문항목수정
	             </caption>
	             <colgroup>
	                 <col width="150" />
	                 <col />
	             </colgroup>
	             <tbody>
	                 <tr>
	                     <th scope="row">설문제목</th>
	                     <td><c:out value="${fn:replace(resultList[0].qestnrCn , crlf , '<br/>')}" escapeXml="false" /></td>
	                 </tr>
	                 <tr>
	                     <th scope="row">설문문항</th>
	                     <td><c:out value="${fn:replace(resultList[0].qestnrQesitmCn , crlf , '<br/>')}" escapeXml="false" /></td>
	                 </tr>
	                 <tr>
	                     <th scope="row" class="point">항목순번</th>
	                     <td>
	                           	<input type="text" name="iemSn" id="iemSn" style="width:110px;" title="항목순서입력" value="<c:out value="${resultList[0].iemSn}" />" onfocusout="checkSn();" />
	                           	<form:errors path="iemSn" cssClass="hiddden_txt" element="div" />
	                     </td>
	                 </tr>
	                 <tr>
	                     <th scope="row" class="point">항목내용</th>
	                     <td>
	                          	<textarea name="iemCn" id="iemCn" rows="8" title="내용입력란"  style="width:90%;" placeholder="항목내용을 입력해 주세요."><c:out value="${resultList[0].iemCn}" /></textarea>
	                          	<form:errors path="iemCn" cssClass="hiddden_txt" element="div" />
	                     </td>
	                 </tr>
	                 <tr>
	                     <th scope="row" class="point">기타답변여부</th>
	                     <td><span class="only">
	                         <select name="etcAnswerAt" title="기타압변여부 선택" id="etcAnswerAt" style="width:110px">
								<option value="N" <c:if test="${resultList[0].etcAnswerAt ==  'N'}">selected</c:if>>No</option>
								<option value="Y" <c:if test="${resultList[0].etcAnswerAt ==  'Y'}">selected</c:if>>Yes</option>
	                         </select>
	                     </span></td>
	                 </tr>
	             </tbody>
	         </table>
			</form:form>
		</div>
        <div class="btn_page_last">
        	<a class="btn_page_admin" href="#none" onclick="fn_egov_list_QustnrItemManage();"><span>취소</span></a> 
        	<a class="btn_page_admin" href="#none" onclick="$('#qustnrItemManageVO').submit();"><span>확인</span></a> 
        </div>
	</div>
</div>
</body>
</html>
