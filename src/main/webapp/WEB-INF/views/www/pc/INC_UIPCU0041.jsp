<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="method" value="${param.method}" />
<c:set var="key" value="${param.key}" />
<c:set var="vwcd" value="${param.vwcd}" />
<c:set var="parentId" value="${param.parentId}" />
<c:set var="type" value="${param.type}" />

<c:import url="http://kosis.kr/openapi/statisticsList.do?method=${method}&apiKey=${key}&vwCd=${vwcd}&parentListId=${parentId}&format=${type}&jsonVD=Y" charEncoding="utf-8"/>