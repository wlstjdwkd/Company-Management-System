<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@	taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<form name="dataForm" id="dataForm" method="post" action="${svcUrl }">
			<c:forEach items="${stkResultInfo}" var="stkResultInfo" varStatus="status">
             <input type="hidden" name="ad_std" value="${stkResultInfo.stdYy}.${stkResultInfo.stdMt}" />
			  <input type="hidden" name="ad_stkPc" value="${stkResultInfo.stkPc}" />
			 </c:forEach>
                <!--// 리스트 -->
                    <div id="placeholder1"style="width: 1550px; height: 600px;"></div>
                   
                    <!-- 리스트// -->
</form>