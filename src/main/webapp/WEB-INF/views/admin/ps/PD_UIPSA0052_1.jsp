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
	
	var previousPoint;
	
	var stdyySt = ${stdyySt};
	var stdyyEd = ${stdyyEd};

	var autoscaleMargin;											// 그래프 거리(모양이쁘게)
	var barWidth;														// 바 너비
	
	var resultListCnt = ${resultListCnt};
	
	var data1 = [];	

	var ticks = [];
	
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

	var y0SumEntrHist= document.getElementsByName("y0SumEntrHist");
	var y1SumEntrHist= document.getElementsByName("y1SumEntrHist");
	var y2SumEntrHist= document.getElementsByName("y2SumEntrHist");
	var y3SumEntrHist= document.getElementsByName("y3SumEntrHist");
	var y4SumEntrHist= document.getElementsByName("y4SumEntrHist");
	var y5SumEntrHist= document.getElementsByName("y5SumEntrHist");
	var y6SumEntrHist= document.getElementsByName("y6SumEntrHist");
	var y7SumEntrHist= document.getElementsByName("y7SumEntrHist");
	var y8SumEntrHist= document.getElementsByName("y8SumEntrHist");
	var y9SumEntrHist= document.getElementsByName("y9SumEntrHist");
		
	for (var i = stdyySt; i < stdyyEd+1; i++) {
		ticks.push([i-stdyySt, i]);
	}

	for(var i = 0; i < resultListCnt; i++) {
		var d1 = [];
		
		if( stdyyEd-stdyySt >= 9 ) {
			d1.push([0,y0SumEntrHist[i].value]);
			d1.push([1,y1SumEntrHist[i].value]);
			d1.push([2,y2SumEntrHist[i].value]);
			d1.push([3,y3SumEntrHist[i].value]);
			d1.push([4,y4SumEntrHist[i].value]);	
			d1.push([5,y5SumEntrHist[i].value]);
			d1.push([6,y6SumEntrHist[i].value]);
			d1.push([7,y7SumEntrHist[i].value]);
			d1.push([8,y8SumEntrHist[i].value]);
			d1.push([9,y9SumEntrHist[i].value]);
		}	
		else if( stdyyEd-stdyySt >= 8 ) {
			d1.push([0,y0SumEntrHist[i].value]);
			d1.push([1,y1SumEntrHist[i].value]);
			d1.push([2,y2SumEntrHist[i].value]);
			d1.push([3,y3SumEntrHist[i].value]);
			d1.push([4,y4SumEntrHist[i].value]);	
			d1.push([5,y5SumEntrHist[i].value]);
			d1.push([6,y6SumEntrHist[i].value]);
			d1.push([7,y7SumEntrHist[i].value]);
			d1.push([8,y8SumEntrHist[i].value]);
		}
		else if (stdyyEd-stdyySt >= 7) {
			d1.push([0,y0SumEntrHist[i].value]);
			d1.push([1,y1SumEntrHist[i].value]);
			d1.push([2,y2SumEntrHist[i].value]);
			d1.push([3,y3SumEntrHist[i].value]);
			d1.push([4,y4SumEntrHist[i].value]);				
			d1.push([5,y5SumEntrHist[i].value]);
			d1.push([6,y6SumEntrHist[i].value]);
			d1.push([7,y7SumEntrHist[i].value]);
		}
		else if (stdyyEd-stdyySt >= 6) {
			d1.push([0,y0SumEntrHist[i].value]);
			d1.push([1,y1SumEntrHist[i].value]);
			d1.push([2,y2SumEntrHist[i].value]);
			d1.push([3,y3SumEntrHist[i].value]);
			d1.push([4,y4SumEntrHist[i].value]);				
			d1.push([5,y5SumEntrHist[i].value]);
			d1.push([6,y6SumEntrHist[i].value]);
		}
		else if (stdyyEd-stdyySt >= 5) {
			d1.push([0,y0SumEntrHist[i].value]);
			d1.push([1,y1SumEntrHist[i].value]);
			d1.push([2,y2SumEntrHist[i].value]);
			d1.push([3,y3SumEntrHist[i].value]);
			d1.push([4,y4SumEntrHist[i].value]);				
			d1.push([5,y5SumEntrHist[i].value]);
		}
		else if (stdyyEd-stdyySt >= 4) {
			d1.push([0,y0SumEntrHist[i].value]);
			d1.push([1,y1SumEntrHist[i].value]);
			d1.push([2,y2SumEntrHist[i].value]);
			d1.push([3,y3SumEntrHist[i].value]);
			d1.push([4,y4SumEntrHist[i].value]);	
		}
		else if (stdyyEd-stdyySt >= 3) {
			d1.push([0,y0SumEntrHist[i].value]);
			d1.push([1,y1SumEntrHist[i].value]);
			d1.push([2,y2SumEntrHist[i].value]);
			d1.push([3,y3SumEntrHist[i].value]);
		}
		else if (stdyyEd-stdyySt >= 2) {
			d1.push([0,y0SumEntrHist[i].value]);
			d1.push([1,y1SumEntrHist[i].value]);
			d1.push([2,y2SumEntrHist[i].value]);
		}
		else if (stdyyEd-stdyySt >= 1) {
			d1.push([0,y0SumEntrHist[i].value]);
			d1.push([1,y1SumEntrHist[i].value]);
		}
		else if (stdyyEd-stdyySt >= 0) {
			d1.push([0,y0SumEntrHist[i].value]);
		}		
		dataArray[i] = d1;
	}

	if (resultListCnt * (stdyyEd-stdyySt+1) < 100 ) {
		autoscaleMargin = 0.02;
		barWidth = 0.015;
	}		
	if (resultListCnt * (stdyyEd-stdyySt+1) < 60 ) {
		autoscaleMargin = 0.05;
		barWidth = 0.025;
	}
	if (resultListCnt * (stdyyEd-stdyySt+1) < 40 ) {
		autoscaleMargin = 0.05;
		barWidth = 0.04;			
	}
	if (resultListCnt * (stdyyEd-stdyySt+1) < 20 ) {
		autoscaleMargin = 0.1;
		barWidth = 0.09;
	}
	if (resultListCnt * (stdyyEd-stdyySt+1) < 10 ) {
		autoscaleMargin = 0.3;
		barWidth = 0.12;
	}
	
	data1.push({
		label: "매출자&근로자",
		data: dataArray[0],
		bars: {
			barWidth : barWidth,
			show : true,
			order : 1,
			fillColor : graphColor[0]
		}, color : graphColor[0]
	});
		
	data1.push({
		label: "근로자",
		data: dataArray[1],
		bars: {
			barWidth : barWidth,
			show : true,
			order : 2,
			fillColor : graphColor[1]
		}, color : graphColor[1]
	});
		
	data1.push({
		label: "매출액",
		data: dataArray[2],
		bars: {
			barWidth : barWidth,
			show : true,
			order : 3,
			fillColor : graphColor[2]
		}, color : graphColor[2]
	});
		
	data1.push({
		label: "매출액&근로자",
		data: dataArray[3],
		bars: {
			barWidth : barWidth,
			show : true,
			order : 4,
			fillColor : graphColor[3]
		}, color : graphColor[3]
	});
		
	$.plot($("#placeholder1"), data1, {
		xaxis : {
			show : true,
			ticks : ticks,
			autoscaleMargin : autoscaleMargin
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
		<c:forEach items="${resultList}" var="result" varStatus="status">
				<input type="hidden" name="y0SumEntrHist" value="${result.y0SumEntrHist}" />
				<input type="hidden" name="y1SumEntrHist" value="${result.y1SumEntrHist}" />
				<input type="hidden" name="y2SumEntrHist" value="${result.y2SumEntrHist}" />
				<input type="hidden" name="y3SumEntrHist" value="${result.y3SumEntrHist}" />
				<input type="hidden" name="y4SumEntrHist" value="${result.y4SumEntrHist}" />
				<input type="hidden" name="y5SumEntrHist" value="${result.y5SumEntrHist}" />
				<input type="hidden" name="y6SumEntrHist" value="${result.y6SumEntrHist}" />
				<input type="hidden" name="y7SumEntrHist" value="${result.y7SumEntrHist}" />
				<input type="hidden" name="y8SumEntrHist" value="${result.y8SumEntrHist}" />
				<input type="hidden" name="y9SumEntrHist" value="${result.y9SumEntrHist}" />
		</c:forEach>

<div id="self_dgs">
	<div class="pop_q_con">
	    <!--// 검색 조건 -->
	    <div class="search_top">
	        <table cellpadding="0" cellspacing="0" class="table_search" summary="거래유형별 현황 챠트" >
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
	                <td>${searchEntprsGrp}</td>
	                <th scope="row">년도</th>
	                <td>${stdyySt} ~ ${stdyyEd}</td>
	            </tr>

	        </table>
	        
	        <!-- // chart영역-->
	        <!--// chart -->
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