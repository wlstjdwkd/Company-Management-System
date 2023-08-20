<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>업종선택</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,multiselect" />
<ap:jsTag type="tech" items="acm,msg,util" />
<script type="text/javaScript">
$(document).ready(function(){
	$('select').multipleSelect({
		selectAll: false,
	    isOpen: true,
	    keepOpen: true,
	    allSelected: "",
	    minimumCountSelected: 100,
	    width: "99%",
	    maxHeight: "530",
	    placeholder: "제조업중분류/비제조"
	});
	
	$("#uncheckAll").click(function() {
		$("select").multipleSelect("uncheckAll");
	});
	
	$("#done").click(function() {
		if ($(".selected > label").length > 0) {
			parent.$("#ind_code_name_${param.scrno}").text($(".selected > label").get(0).innerText);
			parent.$("#ad_ind_cd_${param.scrno}").val($("select").multipleSelect("getSelects"));
			parent.$("#selectIndCode_${param.scrno}").colorbox.close();
		} else {
			jsMsgBox(null, "error", Message.template.noSetTarget("업종"));
			//parent.$("#ind_code_name_${param.scrno}").text("");
			//parent.$("#ad_ind_cd_${param.scrno}").val("");
		}
	});
});
</script>
</head>
<body>
<div id="self_dgs">
	<div class="pop_q_con">
		<div id="multiSelectBox" style="height: 565px; position:relative;">
			<select multiple="multiple" id="indCdList" name="indCdList">
			<c:set var="open" value="N" />
			<c:forEach items="${indCdList}" var="indCdInfo" varStatus="status">
				<c:if test="${indCdInfo.indCode == '' }">
					<c:if test="${open == 'Y' }"></optgroup></c:if>
		        <optgroup label="<c:out value="${indCdInfo.koreanNm }" />">
		        	<c:set var="open" value="Y" />
				</c:if>
				<c:if test="${indCdInfo.indCode != '' }">
		            <option value="${indCdInfo.indCode }:${indCdInfo.se }" <c:if test="${indCdInfo.chked == 'Y' }">selected="selected"</c:if>><c:out value="${indCdInfo.koreanNm }" /></option>
		    	</c:if>
		    </c:forEach>
			</select>
		</div>
		<div class="btn_page_last">
			<c:if test="${param.ad_ac_type != 'view' }">
			<a class="btn_page_admin" href="#none" id="done"><span>완료</span></a> 
			<a class="btn_page_admin" href="#none" id="uncheckAll"><span>선택해제</span></a>
			</c:if> 
		</div> 
	</div>
</div>
</body>
</html>