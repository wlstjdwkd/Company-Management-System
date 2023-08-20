<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset=UTF-8">
<title>정보</title>
<c:set var="svcUrl" value=" ${requestScope[SVC_URL_NAME]}"/>
<ap:globalConst/>
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,selectbox,mask,jqGrid,css"/>
<ap:jsTag type="tech" items="acm,msg,util"/>
<style type="text/css">
	.tab_content{
		display: none;
	}
	.tab_content.on{
		display: inherit;
	}
	
</style>
<script type='text/javascript'>
	var areaJson = ${areaSelect};
	$(document).ready(function() {
		$('ul.tabs li').click(function(){
    		$('ul.tabs li').removeClass('on');
    		$(this).addClass('on');
    		var tab_id = $(this).attr('data_tab');
    		$('.tab_content').removeClass('on');
    		$('#'+tab_id).addClass('on');
    	});
		// 지역(구/군) 변경 시
		$("#ad_area2").change(function(){
			if($(this).val() == "") {
				$("#ad_hedofc_adres").val("");
				return;
			}		
			var selText = $("#ad_area2 option:selected").text();		
			$("#ad_hedofc_adres").val(selText);
		});
		
		$("#ad_area1").change(function() {
			var $val = $(this).val();
			var selectContent = "";
			if($val == "") {
				$("#ad_area2").val("");
				$("#ad_area2").attr("disabled", "disabled");
			}else {
				selectContent += "<optgroup label='구/군'>";
				selectContent += "<option value=''>-- 선택 --</option>";
				for(var i=0; i<areaJson.length; i++) {
					if($val == areaJson[i]["UPPER_CODE"]) {					
						selectContent += "<option value='" + areaJson[i]["AREA_CODE"] + "'>";
						selectContent += areaJson[i]["AREA_NM"];
						selectContent += "</option>";
					}
				}			
				selectContent += '</optgroup>';
				$("#ad_area2").html(selectContent);
				$("#ad_area2").attr("disabled", false);
			}
		});
		$("#ad_area1").change();
	})
</script>
</head>
<body>
<div id="wrap">
	<div class="wrap_inn">
		<div class="contents">
			<!-- 타이틀 영역 -->
			<h2 class="menu_title">셀렉트박스</h2>
			<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}'/>" method="post">
				<ap:include page="param/dispParam.jsp"/>
				<input type="hidden" name="ad_hedofc_adres" id="ad_hedofc_adres" value="${param.ad_hedofc_adres}" />
				<div class="block">
					<select id="ad_area1" name="ad_area1" style="width: 110px">                            		
			            <optgroup label="광역시도">
			            	<option value="" selected="selected">-- 선택 --</option>
				        	<c:forEach items="${areaCity}" var="areaCity" varStatus="status">
			            		<option value="${areaCity.AREA_CODE}" <c:if test="${param.ad_area1 eq areaCity.AREA_CODE}">selected="selected"</c:if> >${areaCity.ABRV}</option>
				            </c:forEach>
				        </optgroup>
			    	</select>						    	
                   	<select id="ad_area2" name="ad_area2" style="width: 150px">
                   		<option value="">-- 선택 --</option> 
			    	</select> 
				</div>
			</form>
			<div class="tabwrap" style="margin:70px;">
				<div class="tab">
					<ul class="tabs">
                        <li class="on" data_tab="tab_1">JSP</li>
                        <li data_tab="tab_2">JS</li>
                        <li data_tab="tab_3">Java</li>
                        <li data_tab="tab_4">SQL</li>
                    </ul>
                   	<div id="tab_1" class="tab_content on">
                   		<c:set var="string1" value='
<input type="hidden" name="ad_hedofc_adres" id="ad_hedofc_adres" value="${param.ad_hedofc_adres}" />
<div class="block">
	<select id="ad_area1" name="ad_area1" style="width: 110px">                            		
        <optgroup label="광역시도">
           	<option value="" selected="selected">-- 선택 --</option>
        	<c:forEach items="$ {areaCity}" var="areaCity" varStatus="status">
           		<option value="$ {areaCity.AREA_CODE}" <c:if test="$ {param.ad_area1 eq areaCity.AREA_CODE}">selected="selected"</c:if> >$ {areaCity.ABRV}</option>
            </c:forEach>
        </optgroup>
   	</select>						    	
    <select id="ad_area2" name="ad_area2" style="width: 150px">
      	<option value="">-- 선택 --</option> 
   	</select> 
</div>
						'/>
                   	<pre>${fn:escapeXml(string1)}</pre>
                   	</div>
                   
                   	<div id="tab_2" class="tab_content">
                   		<c:set var = "string2" value = '
<script>
   																// 지역(구/군) 변경 시
	$("#ad_area2").change(function(){
		
		if($(this).val() == "") {
			$("#ad_hedofc_adres").val("");
			return;
		}		
		var selText = $("#ad_area2 option:selected").text();		
		$("#ad_hedofc_adres").val(selText);
	});
	
																// 광역시도 변경시
	$("#ad_area1").change(function() {
		var $val = $(this).val();
		var selectContent = "";
		if($val == "") {												//선택이 없으면 지역 (구/군 disable 시키기)
			$("#ad_area2").val("");
			$("#ad_area2").attr("disabled", "disabled");
		}else {														//있으면 시도에있는 AREA_CODE를 지역 (구/군) 의 UPPER_CODE와 비교해서 출력 
			selectContent += "<optgroup label="구/군">";
			selectContent += "<option value="">-- 선택 --</option>";
			for(var i=0; i<areaJson.length; i++) {
				if($val == areaJson[i]["UPPER_CODE"]) {					
					selectContent += "<option value="" + areaJson[i]["AREA_CODE"] + "">";
					selectContent += areaJson[i]["AREA_NM"];
					selectContent += "</option>";
				}
			}			
			selectContent += "</optgroup>";
			$("#ad_area2").html(selectContent);
			$("#ad_area2").attr("disabled", false);
		}
	});
	$("#ad_area1").change();
</script>  		
                   		'/>
                   	<pre>${fn:escapeXml(string2)}</pre>
                   	</div>
                   	
                   	<div id="tab_3" class="tab_content">
                   		<c:forEach items ="${javaMessage }" var="indMess">
							${indMess }<br><br>
						</c:forEach>		
                   	</div>
                   	
                   	<div id="tab_4" class="tab_content">
                   		<c:forEach items ="${sqlMessage }" var="indMess">
							${indMess }<br><br>
						</c:forEach>
                   	</div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>