<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<%--
  Class Name : template.jsp
  Description : 설문기본 템플릿
  Modification Information

      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2008.03.09    장동한          최초 생성

    author   : 공통서비스 개발팀 장동한
    since    : 2009.03.09

--%>
<table width="100%">
<c:forEach items="${Comtnqustnrqesitm}" var="QestmInfo" varStatus="status1">
	<!--1번 설문 -->
	<tr>
	    <td height="15" colspan="2">
			<%-- 최대선택 건수 --%>
			<input type="hidden" name="MXMM_${QestmInfo.qestnrQesitmId}" value="${QestmInfo.mxmmChoiseCo}">
			<%-- 객관식/주관식  타입 --%>
			<input type="hidden" name="TY_${QestmInfo.qestnrQesitmId}" value="${QestmInfo.qestnTyCode}">
	    </td>
	</tr>
	<tr>
	    <td width="2%" valign="top" style="font-size:12px; color:#333; font-weight:bold; margin-bottom:15px;">${status1.count}.</td>
	    <td width="97%" style="font-size:12px; color:#333; font-weight:bold; margin-bottom:15px;">
	    	<c:out value="${fn:replace(QestmInfo.qestnCn , crlf , '<br/>')}" escapeXml="false" />
	    	<c:if test="${QestmInfo.mxmmChoiseCo >  1}">(최대 ${QestmInfo.mxmmChoiseCo}개 선택 가능)</c:if>
	    </td>
	</tr>
	<tr>
	    <td>&nbsp;</td>
	    <td>
		    <%-- 객관식 --%>
		    <c:if test="${QestmInfo.qestnTyCode ==  '1'}">
	    	<table width="100%" border="0">
	    	<tr>
		    	<c:forEach items="${Comtnqustnriem}" var="QestmItem" varStatus="status01">
		    	<c:if test="${QestmInfo.qestnrTmplatId eq QestmItem.qestnrTmplatId && QestmInfo.qestnrId eq QestmItem.qestnrId && QestmInfo.qestnrQesitmId eq QestmItem.qestnrQesitmId}">
		    		<td height="25">

		    		<%-- 다중체크구현 로직 --%>
		    		<c:if test="${QestmInfo.mxmmChoiseCo ==  '1'}">
		    		<input type="radio" name="${QestmItem.qestnrQesitmId}" value="${QestmItem.qustnrIemId}"> 
		    		<c:out value="${fn:replace(QestmItem.iemCn , crlf , '<br/>')}" escapeXml="false" />
		    		</c:if>

		    		<c:if test="${QestmInfo.mxmmChoiseCo >  1}">
		    		<input type="checkbox" name="${QestmItem.qestnrQesitmId}" value="${QestmItem.qustnrIemId}" id="${QestmItem.qestnrQesitmId}" onclick="fn_egov_checkbox_amout('${QestmItem.qestnrQesitmId}', ${QestmInfo.mxmmChoiseCo}, this)"  title="체크박스">
		    		<c:out value="${fn:replace(QestmItem.iemCn , crlf , '<br/>')}" escapeXml="false"/>
		    		</c:if>
		    		
		    		<%-- 기타답변여부 --%>
		    		<c:if test="${QestmItem.etcAnswerAt eq  'Y'}">
		    		<input name="ETC_${QestmItem.qustnrIemId}" id="ETC_${QestmItem.qustnrIemId}" type="text" size="73" value="" maxlength="1000" style="width:150px;" title="기타답변여부">
		    		</c:if>
		    		
		    		<c:if test="${QestmItem.etcAnswerAt eq  'N' || QestmItem.etcAnswerAt eq ''}">
		    		<input name="ETC_${QestmItem.qustnrIemId}" id="ETC_${QestmItem.qustnrIemId}" type="hidden" size="73" value="" maxlength="1000">
		    		</c:if>
		    		</td>
		    	</c:if>
		    	</c:forEach>
	    	</tr>
	    	</table>
	    	</c:if>

    		<%-- 주관식 --%>
    		<c:if test="${QestmInfo.qestnTyCode ==  '2'}">
    		<textarea name="${QestmInfo.qestnrQesitmId}" id="${QestmInfo.qestnrQesitmId}" rows="4" style=" overflow:auto; width:660px; font-size:12px; border:1px #999 solid" value="" title="주관식내용입력"></textarea>
    		</c:if>
	    </td>
	</tr>
</c:forEach>
