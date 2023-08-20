<%--
  Class Name : EgovQustnrRespondInfoRegist.jsp
  Description : 설문조사 등록 페이지
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
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<%pageContext.setAttribute("crlf", "\r\n"); %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>설문조사</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,msgBox" />
<ap:jsTag type="tech" items="msg,util" />

<script type="text/javaScript">
<c:if test="${svcUrl == '/PGSU0010.do'}">
$(document).ready(function(){
	// 설문기간 아니면...
	<c:if test="${Comtnqestnrinfo[0].validDate == 'F'}">
		jsMsgBox(null, "error", Message.msg.invalidQustnrResponseDate, function() {location.href="${BASE_URL}"});
	</c:if>
	// 처리 안내 메시지
	<c:if test="${resultMsg != null}">
		jsMsgBox(null, "info","${resultMsg}", function() {location.href="${BASE_URL}"});
	</c:if>
});
</c:if>
/* ********************************************************
 * 목록 으로 가기
 ******************************************************** */
function fn_egov_list_QustnrRespondInfo() {
    var form = document.getElementById("qustnrRespondInfoManage");
    form.df_method_nm.value = "";
    form.submit();
}

/* ********************************************************
 * 저장처리화면
 ******************************************************** */
function fn_egov_save_QustnrRespondInfo() {
	
	var form = document.getElementById("qustnrRespondInfoManage");
	
	if(form.trgterEmail.value == null || form.trgterEmail.value == "") {
		jsMsgBox(null, "error", Message.msg.invalidQustnrRespondInfo);
		return;
	}
	if(form.qestnrTmplatId.value == null || form.qestnrTmplatId.value == "" || form.qestnrId.value == null || form.qestnrId.value == "") {
		jsMsgBox(null, "error", Message.msg.invalidQustnrInfo);
		return;
	}

	//설문정보 Validtation
<c:forEach items="${Comtnqustnrqesitm}" var="QestmInfo" varStatus="status1">
	<c:if test="${QestmInfo.qestnTyCode ==  '1'}">
	
	if(!fn_egov_selectBoxChecking("${QestmInfo.qestnrQesitmId}")) {
		jsMsgBox(document.getElementsByName("${QestmInfo.qestnrQesitmId}")[0], 'error', Message.template.qustnrRespond("${status1.count}"));
		return;
	}

		<c:forEach items="${Comtnqustnriem}" var="QestmItem" varStatus="status01">
			<c:if test="${QestmInfo.qestnrTmplatId eq QestmItem.qestnrTmplatId && QestmInfo.qestnrId eq QestmItem.qestnrId && QestmInfo.qestnrQesitmId eq QestmItem.qestnrQesitmId}">
				<c:if test="${QestmItem.etcAnswerAt eq  'Y'}">
	//기타답변을 선택했는체크
	if(fn_egov_RadioBoxValue("${QestmInfo.qestnrQesitmId}") == "${QestmItem.qustnrIemId}") {
		if(document.getElementById("ETC_${QestmItem.qustnrIemId}").value == "") {
			jsMsgBox(document.getElementById("ETC_${QestmItem.qustnrIemId}"), 'error', Message.template.qustnrRespondEtc("${status1.count}"));
			return;
		}
	}
				</c:if>
			</c:if>
		</c:forEach>
	</c:if>


	<c:if test="${QestmInfo.qestnTyCode ==  '2'}">
	if( document.getElementById("${QestmInfo.qestnrQesitmId}").value == "" ){
		jsMsgBox(document.getElementById("${QestmInfo.qestnrQesitmId}"), 'error', Message.template.qustnrRespond("${status1.count}"));
		return;
	}
	</c:if>
</c:forEach>

	jsMsgBox(null, 'confirm','<spring:message code="confirm.common.save" />', function(){
		$("#cmd").val("save");
		$("#df_method_nm").val("insertRespond");
		form.submit();
	});
}

/************************************************************************
//라디오박스 : 최대선택건수 체크
************************************************************************/
function fn_egov_checkbox_amout(sbName, sbCount, sbObj){

	var FLength= document.getElementsByName(sbName).length;

	var reuslt = false;
	var reusltCount = 0;
	for(var i=0; i < FLength; i++)
	{
		if(document.getElementsByName(sbName)[i].checked == true){
			reusltCount++;
		}
	}

	if(reusltCount > sbCount){
		jsMsgBox(null, 'error',Message.template.qustnrRespondMax(sbCount));
	 	sbObj.checked=false;
	 	return;
	}
}

/************************************************************************
//셀렉트 박스 선택했는 찾는 함수
************************************************************************/

function fn_egov_selectBoxChecking(sbName){

	var FLength= document.getElementsByName(sbName).length;

	var reuslt = false;
	for(var i=0; i < FLength; i++)
	{
		if(document.getElementsByName(sbName)[i].checked == true){
			reuslt=true;
		}
	}

	return reuslt;
}
/************************************************************************
//셀렉트박스 값 컨트롤 함수
************************************************************************/
function fn_egov_SelectBoxValue(sbName)
{
	var FValue = "";
	for(var i=0; i < document.getElementById(sbName).length; i++)
	{
		if(document.getElementById(sbName).options[i].selected == true)
		{
			FValue=document.getElementById(sbName).options[i].value;
		}
	}

	return  FValue;
}

/************************************************************************
//라디오박스 체크 박스
************************************************************************/
function fn_egov_RadioBoxValue(sbName)
{
	var FLength = document.getElementsByName(sbName).length;
	var FValue = "";
	for(var i=0; i < FLength; i++)
	{
		if(document.getElementsByName(sbName)[i].checked == true){
			FValue = document.getElementsByName(sbName)[i].value;
		}
	}

	return FValue;
}

</script>
</head>
<body style="margin: 0;padding: 0;">
<table cellspacing="0" cellpadding="0" border="0" width="778px" align="center" style="margin-left:auto;margin-right:auto">
    <thead>
        <!-- 헤더로고  -->
        <tr>
            <td align="center"><table cellspacing="0" cellpadding="0" border="0" width="778px">
                    <tbody>
                        <tr>
                            <td align="left" style="border-top:solid 4px #a6c8d6;padding: 26px 0 19px;"><h1 style="margin:0; padding:0; display:inline;"><a href="#" target="_blank"><img src="/images/mail/logo_email.png" alt="기업종합정보시스템" border="0" hspace="0" vspace="0"></a></h1></td>
                        </tr>
                    </tbody>
                </table></td>
        </tr>
        <!-- //헤더로고  -->
    </thead>
    <tbody>
        <!-- 내용  -->
        <tr>
            <td style="padding:0;"><table cellspacing="0" cellpadding="0" border="0" width="778px">
                    <tbody>
                        <tr>
                            <td style="position:relative;height:70px;font-size:14px;font-weight: bold;font-family:돋움;line-height:18px;color:#060606;padding:20px 0 20px 20px;background-image:url(/images/mail/bg_email.png) "> 안녕하세요, 기업 정보입니다.<br />
                                아래와 같은 목적으로 설문참여를 요청드리오니, 많은 참여와 관심 부탁 드립니다. </td>
                        </tr>
                        <tr>
                            <td>
                            <form name="qustnrRespondInfoManage" id="qustnrRespondInfoManage" method="post" action="${svcUrl}">
							<ap:include page="param/defaultParam.jsp" />
							<ap:include page="param/dispParam.jsp" />
							<ap:include page="param/pagingParam.jsp" />
							
                            <input type="hidden" name="qestnrTmplatId" id="qestnrTmplatId" value="${qestnrTmplatId}">
                            <input type="hidden" name="qestnrId" id="qestnrId" value="${qestnrId}">
                            <input type="hidden" name="trgterEmail" id="trgterEmail" value="${param.trgterEmail}" />
                            <input type="hidden" name="cmd" id="cmd" value="">
                                                        
                                <table cellspacing="0" cellpadding="0" border="0" width="778px" style="background-image:url(/images/mail/pattern_02.png);border-top: 1px solid #416e98;">
                                    <tr>
                                        <td align="center" style="color: #c6eefe;font-size:20px;font-weight: bold; font-family:Malgun Gothic;padding:26px;">
                                        	<c:out value="${fn:replace(Comtnqestnrinfo[0].qestnrSj , crlf , '<br/>')}" escapeXml="false" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top" style="background-image:url(/images/mail/pattern_01.png);color: #FFF;font-size:14px;font-family:돋움;font-weight: bold;padding:26px; line-height:180%; border-bottom:#86a0b8 dotted 1px">
                                        	<img src="/images/mail/d1.png" alt="동그라미" hspace="0" vspace="0" border="0" align="absmiddle" style=" margin-top:0px;margin-left:38px;"  />설문기간 : 
                                        		<c:out value="${Comtnqestnrinfo[0].qestnrBeginDe}" /> ~ <c:out value="${Comtnqestnrinfo[0].qestnrEndDe}" /><br />
                                            <img src="/images/mail/d1.png" alt="동그라미" hspace="0" vspace="0" border="0" align="absmiddle" style=" margin-top:0px;margin-left:38px;" />설문목적 : 
                                            	<span style="display:inline-block; width:590px; vertical-align:top;"><c:out value="${fn:replace(Comtnqestnrinfo[0].qestnrPurps , crlf , '<br/>')}" escapeXml="false" /> </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td  style="color: #F9F9F9;font-size:12px; line-height:180%; padding:15px;background-image:url(/images/mail/pattern_01.png); padding:26px 26px 36px 26px;">
                                        	<c:out value="${fn:replace(Comtnqestnrinfo[0].qestnrWritngGuidanceCn , crlf , '<br/>')}" escapeXml="false" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="#f9f9f9"  style="font-size:12px;font-family:돋움; line-height:180%;background-image:url(/images/mail/pattern_01.png); padding:0px 26px 36px 26px;"><table width="100%" cellpadding="10" style="background-color:#FFF; border:#aed2dd solid 3px; padding-bottom:20px;">
                                                <tr>
                                                    <td>
<%-- 설문템플릿설정 --%>
<c:import charEncoding="utf-8" url="${svcUrl}?df_method_nm=template" >
<c:param name="templateUrl" value="${QustnrTmplatManage[0].qestnrTmplatCours}" />
</c:import>
                                                    </td>
                                                </tr>
                                            </table></td>
                                    </tr>
                                </table></td>
                        </tr>
                        <tr>
                            <td align="center" style="color:#a6daee;font-size:12px;padding:31px 0 29px 26px;background-image:url(/images/mail/pattern_02.png)">
                            <c:if test="${param.trgterEmail == null || param.trgterEmail == '' }">
                            	<a href="#none" onclick="fn_egov_list_QustnrRespondInfo();"><img src="/images/mail/btn_list.png" alt="설문참여관리" width="237" height="69" border="0" /></a>
                            </c:if>
                            <c:if test="${param.trgterEmail != null && param.trgterEmail != '' }">
                            	<a href="#none" onclick="fn_egov_save_QustnrRespondInfo();"><img src="/images/mail/btn_survey.png" alt="설문참여" width="237" height="69" border="0" /></a>
                            </c:if>
                            </td>
                        </tr>
                    </tbody>
                </table></td>
        </tr>
        <!-- //내용  -->
        <!-- 푸터  -->
        <tr>
            <td style="padding:0;"><table cellspacing="0" cellpadding="0" border="0" width="778px">
                    <tbody>
                        <tr>
                            <td style="position:relative;font-size:12px;line-height:18px;color:#060606;padding:40px 20px 50px 20px;font-family:돋움; text-align:left;background:url(/images/mail/pattern_03.png);"> 이 메일은 정보통신망이용촉진 및 정보보호 등에 관한 법률에 의거해, <!-- 발송기준일(YYYY년 MM월 DD일) //--> 현재 e-메일 수신에 동의한 고객님을 대상으로 기업 정보 홈페이지에 회원가입 하시거나, 기업 정보 홈페이지 이용 시 제공해주신 e-메일 주소로 (광고)표시를 하지 않고 발송하는 발송전용 메일로 답변해 드리지 않습니다.<br />
                                앞으로 메일 수신을 원하지 않으시면 <a href="#" style="font-weight: bold;color:#060606;">내정보관리</a>에서 이메일 수신여부를 변경하시거나 아래 정보로 연락 주시기 바랍니다. <br />
                                대표전화 : 02-3275-2985, E-mail : <a href="mailto:tech@tech.or.kr" style="font-weight: bold;color:#060606;">tech@tech.or.kr</a></td>
                        </tr>
                        <tr>
                            <td><img src="/images/mail/email_copy.png" alt="기업종합정보시스템" border="0" hspace="0" vspace="0"></td>
                        </tr>
                    </tbody>
                </table></td>
        </tr>
        <!-- //푸터  -->
    </tbody>
</table>
</body>
</html>