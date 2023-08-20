<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery,cookie,flot,form,jqGrid,noticetimer,tools,ui,validate,notice" />
<ap:jsTag type="tech" items="pc,util,acm" />

<script type="text/javascript">
$(document).ready(function(){
	var form = document.all;

	var previousPoint;

	var stdyySt = ${stdyySt};
	var stdyyEd = ${stdyyEd};
	var searchIndex = "${searchIndex}";
	
	var graphColor = new Array (          
			"#013b6b", "#015ca5", "#147f94", "#149c85", "#75bc2e",
			"#ffb200", "#008738", "#025156", "#314397", "#3e107c",
			"#69077e", "#91017c", "#990134", "#fd3303", "#ff7f00",
			"#b2db11", "#80c31b", "#4bab26", "#036649", "#aba000",
			"#a0410d", "#013b6b", "#015ca5", "#147f94", "#149c85",
			"#75bc2e", "#ffb200", "#008738", "#025156", "#314397",
			"#3e107c", "#69077e", "#91017c", "#990134", "#fd3303",
			"#ff7f00", "#b2db11", "#80c31b", "#4bab26", "#036649",
			"#aba000", "#a0410d","#013b6b", "#015ca5"
	)
	
	
	if (searchIndex == "A") {
		var label = new Array("없음", "1.0%미만", "2.0~3.0%", "3.0~5.0%", "5.0~10.0%", "10.0~30.0%", "30.0%이상");
	}
	else if (searchIndex == "B") {
		var label = new Array("100억미만", "100억원~500억원", "500억원~1천억원", "1천억원~2천억원", "2천억원~3천억원", "3천억원~5천억원", "5천억원~1조원", "1조원이상");
	}
	else if (searchIndex == "C") {
		var label = new Array("없음", "1백만~5백만불", "5백만~1천만불", "1천만불~3천만불", "3천만불~5천만불", "5천만불~1억불", "1억불 이상");
	}
	else if (searchIndex == "D") {
		var label = new Array("10인미만", "10인~50인", "50인~100인", "100인~200인", "200인~300인", "300인이상")
	}
	else if (searchIndex == "E") {
		var label = new Array("0~6년", "7~20년", "21~30년", "31~40년", "41~50년", "51년이상");
	}
	else if (searchIndex == "F") {
		var label = new Array("100억미만", "100억원~500억원", "500억원~1천억원", "1천억원~2천억원", "2천억원~3천억원","3천억원~5천억원","5천억원~1조원", "1조원이상");
	}
	
	var  label_length = label.length;
	
	var data1 = [];	
	var ticks = [];
	
	var number;

	var dataArray = new Array();
	
	function showTooltip(x, y, contents) {
		$('<div id = "tooltip">' +contents +' </div>').css( {
	        position: 'absolute',
	        display: 'none',
	        top: y  - 50,
	        left: x  + 40,
	        border: '1px solid #fdd',
	        padding: '2px',
	       	'background-color': '#fee',
	 		opacity: 0.80
		}).appendTo("body").show();
	}
	
	var sctn1= document.getElementsByName("sctn1");	
	var sctn2= document.getElementsByName("sctn2");
	var sctn3= document.getElementsByName("sctn3");
	var sctn4= document.getElementsByName("sctn4");
	var sctn5= document.getElementsByName("sctn5");
	var sctn6= document.getElementsByName("sctn6");										
	var sctn7= document.getElementsByName("sctn7");										
	var sctn8= document.getElementsByName("sctn8");	
	
	var d1 = [];
	var d2 = [];
	var d3 = [];
	var d4 = [];
	var d5 = [];
	var d6 = [];
	var d7 = [];
	var d8 = [];
	
	for(var i = 0; i < stdyyEd-stdyySt+1; i++) {
		d1.push([i,sctn1[i].value]);
		d2.push([i,sctn2[i].value]);
		d3.push([i,sctn3[i].value]);
		d4.push([i,sctn4[i].value]);						
		d5.push([i,sctn5[i].value]);
		d6.push([i,sctn6[i].value]);
		d7.push([i,sctn7[i].value]);
		d8.push([i,sctn8[i].value]);
	}
	
	dataArray[0] = d1;
	dataArray[1] = d2;
	dataArray[2] = d3;
	dataArray[3] = d4;
	dataArray[4] = d5;
	dataArray[5] = d6;
	dataArray[6] = d7;
	dataArray[7] = d8;
	
	for (var i = stdyySt; i < stdyyEd+1; i++) {
		ticks.push([i-stdyySt, i]);
	}
	
	for(var k = 0; k < label_length; k++) {
		data1.push({
			label: label[k],
			data: dataArray[k],
			bars: {
				barWidth : 0.05,
				show : true,
				order : k,
				fillColor : graphColor[k]
			}, color : graphColor[k]
		});
	}
		
	$.plot($("#placeholder1"), data1, {
		xaxis : {
			show : true,
			ticks : ticks,
			autoscaleMargin : .1
		},
		yaxis: {
			tickFormatter : function numberWithCommas(x) {
				return x.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ",");
			}
		},
		grid : {
			hoverable: true,
			borderWidth : 0.2,
			clickable : false
		},
		valueLabels : {
			show : true
		},
		legend : {
				show : false
		}
	});
	
	// 툴팁 이벤트
	$("#placeholder1").bind("plothover", function (event, pos, item) {
	       	if (item) {
	      		if (previousPoint != item.datapoint) {
	        		previousPoint = item.datapoint;
	                $("#tooltip").remove();
	               
	               	var x = item.datapoint[0],
	                y = item.datapoint[1];
	                showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + y );
	           	}
	    	} else {
	        $("#tooltip").remove();
	  		previousPoint = null;
		}
	});
});
</script>
</head>
<body>
<form name="dataForm" id="dataForm" method="POST">

		<input type="hidden" name="sctn1" value="${resultList[0].sctn1}" />
		<input type="hidden" name="sctn2" value="${resultList[0].sctn2}" />
		<input type="hidden" name="sctn3" value="${resultList[0].sctn3}" />
		<input type="hidden" name="sctn4" value="${resultList[0].sctn4}" />
		<input type="hidden" name="sctn5" value="${resultList[0].sctn5}" />
		<input type="hidden" name="sctn6" value="${resultList[0].sctn6}" />
		<input type="hidden" name="sctn7" value="${resultList[0].sctn7}" />
		<input type="hidden" name="sctn8" value="${resultList[0].sctn8}" />

	<c:forEach begin="1" end ="${stdyyEd-stdyySt}" step = "1" var ="stat" varStatus="status">
		<c:set var="cname" value="y${status.count}sctn1" />
		<input type = "hidden" name = "sctn1" value="${resultList[0][cname]}"/>	
	
		<c:set var="cname" value="y${status.count}sctn2" />
		<input type = "hidden" name = "sctn2" value="${resultList[0][cname]}"/>	
	
		<c:set var="cname" value="y${status.count}sctn3" />
		<input type = "hidden" name = "sctn3" value="${resultList[0][cname]}"/>	
	
		<c:set var="cname" value="y${status.count}sctn4" />
		<input type = "hidden" name = "sctn4" value="${resultList[0][cname]}"/>	
	
		<c:set var="cname" value="y${status.count}sctn5" />
		<input type = "hidden" name = "sctn5" value="${resultList[0][cname]}"/>	
	
		<c:set var="cname" value="y${status.count}sctn6" />
		<input type = "hidden" name = "sctn6" value="${resultList[0][cname]}"/>	
	
		<c:set var="cname" value="y${status.count}sctn7" />
		<input type = "hidden" name = "sctn7" value="${resultList[0][cname]}"/>	
	
		<c:set var="cname" value="y${status.count}sctn8" />
		<input type = "hidden" name = "sctn8" value="${resultList[0][cname]}"/>	
	</c:forEach>
	
<div id="self_dgs">
	<div class="pop_q_con">
	    <!--// 검색 조건 -->
	    <div class="search_top">
	        <table cellpadding="0" cellspacing="0" class="table_search mgb30" summary="거래유형별 현황 챠트" >
	            <caption>
	            주요지표 현황 표
	            </caption>
	            <colgroup>
	            <col width="15%" />
	            <col width="25%" />
	            <col width="15%" />
	            <col width="25%" />
	            </colgroup>
	            <tr>
	                <th scope="row">기업군</th>
	                <td>${tableTitle}</td>
	                <th scope="row">년도</th>
	                <td>${stdyySt} ~ ${stdyyEd}</td>
	            </tr>
	            <tr>
	                <th scope="row">지표</th>
	                <td colspan="3">
	                <c:if test="${searchIndex == 'A'}">R&#38;D 구간별</c:if> 
	                <c:if test="${searchIndex == 'B'}">매출액 구간별</c:if>
	                <c:if test="${searchIndex == 'C'}">수출액 구간별</c:if>
	                <c:if test="${searchIndex == 'D'}">근로자수 구간별</c:if>
	                <c:if test="${searchIndex == 'E'}">평균업력 구간별</c:if>
	                <c:if test="${searchIndex == 'F'}">매출구간별 R&D집약도</c:if>
	                </td>
	            </tr>
	        </table>
	        
	        <!-- // chart영역-->
	        <!--// chart -->
	        <div class="remark_20 mgt20">
	    		<ul>
	    			<c:if test="${searchIndex == 'A'}">
	                	<li class="remark1">없음</li>
	    				<li class="remark2">1.0%미만</li>
	    				<li class="remark3">2.0~3.0%</li>
	    				<li class="remark4">3.0%~5.0%</li>
	    				<li class="remark5">5.0%~10.0%</li>
	    				<li class="remark6">10.0%~30.0%</li>
	    				<li class="remark7">30.0%이상</li>
	 				</c:if>
	                <c:if test="${searchIndex == 'B'}">
	                	<li class="remark1">100억미만</li>
	    				<li class="remark2">100억원~500억원</li>
	    				<li class="remark3">500억원~1천억원</li>
	    				<li class="remark4">1천억원~2천억원</li>
	    				<li class="remark5">2천억원~3천억원</li>
	    				<li class="remark6">3천억원~5천억원</li>
	    				<li class="remark7">5천억원~1조원</li>	                
	                	<li class="remark8">1조원이상</li>	                
	                </c:if>
	                <c:if test="${searchIndex == 'C'}">
	                	<li class="remark1">없음</li>
	                	<li class="remark2">100만불 미만</li>
	    				<li class="remark3">1백만~5백만불</li>
	    				<li class="remark4">5백만~1천만불</li>
	    				<li class="remark5">1천만~3천만불</li>
	    				<li class="remark6">3천만~5천만불</li>
	    				<li class="remark7">5천만~1억불</li>
	    				<li class="remark8">1억불이상</li>
	                </c:if>
	                <c:if test="${searchIndex == 'D'}">
	                	<li class="remark1">10인 미만</li>
	    				<li class="remark2">10인~50인</li>
	    				<li class="remark3">50인~100인</li>
	    				<li class="remark4">100인~200인</li>
	    				<li class="remark5">200인~300인</li>
	    				<li class="remark6">300인 이상</li>
	                </c:if>
	                <c:if test="${searchIndex == 'E'}">
	                	<li class="remark1">0~6년</li>
	    				<li class="remark2">7~20년</li>
	    				<li class="remark3">21~30년</li>
	    				<li class="remark4">31~40년</li>
	    				<li class="remark5">41~50년</li>
	    				<li class="remark6">51년이상</li>
	                </c:if>
	                <c:if test="${searchIndex == 'F'}">
	                	<li class="remark1">100억미만</li>
	    				<li class="remark2">100억원~500억원</li>
	    				<li class="remark3">500억원~1천억원</li>
	    				<li class="remark4">1천억원~2천억원</li>
	    				<li class="remark5">2천억원~3천억원</li>
	    				<li class="remark6">3천억원~5천억원</li>
	    				<li class="remark7">5천억원~1조원</li>	                
	                	<li class="remark8">1조원이상</li>	  
	                </c:if>
	    		</ul>
	    	</div>
	        <div class="chart_zone mgt30" id="placeholder1" ></div>
	        <!--chart //-->
	        <div class="btn_page_last"> 
	        	<a class="btn_page_admin" href="javascript:window.print();"><span>인쇄</span></a> 
	        	<a class="btn_page_admin" href="#" onclick="parent.$.fn.colorbox.close();"><span>닫기</span></a>
	        </div>
	    	<!--chart영역 //-->
		</div>
	<!--content//-->
	</div>
</div>
</form>
</body>
</html>