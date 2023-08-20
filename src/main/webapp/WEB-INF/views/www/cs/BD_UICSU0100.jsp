<?xml version="1.0" encoding="UTF-8"?>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page contentType="text/xml;charset=UTF-8" %>

<Company>
	<EMPMN_PBLANC>
		<totalRowCnt>${totalRowCnt}</totalRowCnt>
	</EMPMN_PBLANC>
	
	<EMPMN_ENTRPRS>
	<c:forEach items="${dataList}" var="data" varStatus="status">
		<EMPMN_INFO>
			<EMPMN_SJ><![CDATA[${data.EMPMN_SJ}]]></EMPMN_SJ>
			<ENTRPRS_NM>${data.ENTRPRS_NM}</ENTRPRS_NM>
			<RCRIT_END_DE>${data.RCRIT_END_DE}</RCRIT_END_DE>
			<CAREER_DETAIL_RQISIT>${data.CAREER_DETAIL_RQISIT}</CAREER_DETAIL_RQISIT>
			<CAREER_DETAIL_RQISIT2>${data.CAREER_DETAIL_RQISIT2}</CAREER_DETAIL_RQISIT2>
			<CAREER_DETAIL_RQISIT3>${data.CAREER_DETAIL_RQISIT3}</CAREER_DETAIL_RQISIT3>
			<EMPMN_URL><![CDATA[${data.ECNY_APPLY__WEB_ADRES}]]></EMPMN_URL>
		</EMPMN_INFO>
	</c:forEach>
	</EMPMN_ENTRPRS>
</Company> 

