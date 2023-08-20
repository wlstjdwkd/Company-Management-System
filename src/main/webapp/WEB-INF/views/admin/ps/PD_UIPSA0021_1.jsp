<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl" %>

<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery,cookie,flot,form,jqGrid,noticetimer,tools,ui,validate" />
<ap:jsTag type="tech" items="util,acm,ps" />
<script type="text/javascript">
$(document).ready(function(){	
	tabwrap();													// 탭
	
	var searchIndex = "${searchIndex}";
	
	var previousPoint;
	
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
	);
	
	var autoscaleMargin;											// 그래프 거리
	var barWidth;														// 바 너비
	
	if (searchIndex == "A") {
		var label = new Array("없음", "1.0%미만", "2.0~3.0%", "3.0~5.0%", "5.0~10.0%", "10.0~30.0%", "30.0%이상");
	}
	else if (searchIndex == "B") {
		var label = new Array("100억미만", "100억원~500억원", "500억원~1천억원", "1천억원~2천억원", "2천억원~3천억원", "3천억원~5천억원", "5천억원~1조원", "1조원이상");
	}
	else if (searchIndex == "C") {
		var label = new Array("없음", "100만불미만", "1백만~5백만불", "5백만~1천만불", "1천만불~3천만불", "3천만불~5천만불", "5천만불~1억불", "1억불 이상");
	}
	else if (searchIndex == "D") {
		var label = new Array("10인미만", "10인~50인", "50인~100인", "100인~200인", "200인~300인", "300인이상")
	}
	else if (searchIndex == "E") {
		var label = new Array("0~6년", "7~20년", "21~30년", "31~40년", "41~50년", "51년이상");
	}
	else if (searchIndex == "F") {
		var label = new Array("100억미만", "100억원~500억원", "500억원~1천억원", "1천억원~2천억원", "2천억원~3천억원", "5천억원~1조원", "1조원이상");
	}

	var  label_length = label.length;
	
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
	
	
	if ( '${param.searchInduty}' != '') {
		var data1 = [];																								// 업종별
		var indutyTicks = [];
		var indutyListCnt = ${indutyListCnt};
		var tick1= document.getElementsByName("tick1");											// 업종별 x라벨
		
		var induty_sctn1= document.getElementsByName("induty_sctn1");	
		var induty_sctn2= document.getElementsByName("induty_sctn2");
		var induty_sctn3= document.getElementsByName("induty_sctn3");
		var induty_sctn4= document.getElementsByName("induty_sctn4");
		var induty_sctn5= document.getElementsByName("induty_sctn5");
		var induty_sctn6= document.getElementsByName("induty_sctn6");										
		var induty_sctn7= document.getElementsByName("induty_sctn7");										
		var induty_sctn8= document.getElementsByName("induty_sctn8");	
	
		var indutyD1 = [];
		var indutyD2 = [];
		var indutyD3 = [];
		var indutyD4 = [];
		var indutyD5 = [];
		var indutyD6 = [];
		var indutyD7 = [];
		var indutyD8 = [];
		
		var indutyDataArray = [];
		for(var i = 0; i <indutyListCnt; i++) {
			indutyTicks.push([i, tick1[i].value]);
			
			indutyD1.push([i,induty_sctn1[i].value]);
			indutyD2.push([i,induty_sctn2[i].value]);
			indutyD3.push([i,induty_sctn3[i].value]);
			indutyD4.push([i,induty_sctn4[i].value]);
			indutyD5.push([i,induty_sctn5[i].value]);
			indutyD6.push([i,induty_sctn6[i].value]);
			indutyD7.push([i,induty_sctn7[i].value]);
			indutyD8.push([i,induty_sctn8[i].value]);
			
		}

		indutyDataArray[0] = indutyD1;
		indutyDataArray[1] = indutyD2;
		indutyDataArray[2] = indutyD3;
		indutyDataArray[3] = indutyD4;
		indutyDataArray[4] = indutyD5;
		indutyDataArray[5] = indutyD6;
		indutyDataArray[6] = indutyD7;
		indutyDataArray[7] = indutyD8;
		
		if (label_length * indutyListCnt < 400 ) {
			autoscaleMargin = 0.01;
			barWidth = 0.01;
		}
		if (label_length * indutyListCnt < 100 ) {
			autoscaleMargin = 0.02;
			barWidth = 0.015;
		}		
		if (label_length * indutyListCnt < 60 ) {
			autoscaleMargin = 0.05;
			barWidth = 0.025;
		}
		if (label_length * indutyListCnt < 40 ) {
			autoscaleMargin = 0.05;
			barWidth = 0.04;			
		}
		if (label_length * indutyListCnt < 20 ) {
			autoscaleMargin = 0.1;
			barWidth = 0.09;
		}
		if (label_length * indutyListCnt < 10 ) {
			autoscaleMargin = 0.3;
			barWidth = 0.12;
		}
		
		for (var i = 0; i < label_length; i++) {
			data1.push({
				label: label[i],
				data: indutyDataArray[i],
				bars: {
					barWidth : barWidth,
					show : true,
					order : 1,
					fillColor : graphColor[i]
				}, color : graphColor[i]
			});
		}

		$.plot($("#placeholder1"), data1, {
			xaxis : {
				show : true,
				ticks : indutyTicks,
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
	}
	
	<c:if test="${param.searchArea != '' && param.searchInduty != ''}">
	$("#tab2").click(function(){
	</c:if>
	
	if ( '${param.searchArea}' != '') {
		var data2 = [];																								// 지역별
		var areaTicks = [];
		var areaListCnt = ${areaListCnt};
		var tick2= document.getElementsByName("tick2");											// 지역별 x라벨
		
		var area_sctn1= document.getElementsByName("area_sctn1");											
		var area_sctn2= document.getElementsByName("area_sctn2");										
		var area_sctn3= document.getElementsByName("area_sctn3");										
		var area_sctn4= document.getElementsByName("area_sctn4");										
		var area_sctn5= document.getElementsByName("area_sctn5");										
		var area_sctn6= document.getElementsByName("area_sctn6");										
		var area_sctn7= document.getElementsByName("area_sctn7");										
		var area_sctn8= document.getElementsByName("area_sctn8");
		
		var areaD1 = [];
		var areaD2 = [];
		var areaD3 = [];
		var areaD4 = [];
		var areaD5 = [];
		var areaD6 = [];
		var areaD7 = [];
		var areaD8 = [];
		
		var areaDataArray = [];
		for(var i = 0; i <areaListCnt; i++) {
			areaTicks.push([i, tick2[i].value]);
			
			areaD1.push([i,area_sctn1[i].value]);
			areaD2.push([i,area_sctn2[i].value]);
			areaD3.push([i,area_sctn3[i].value]);
			areaD4.push([i,area_sctn4[i].value]);
			areaD5.push([i,area_sctn5[i].value]);
			areaD6.push([i,area_sctn6[i].value]);
			areaD7.push([i,area_sctn7[i].value]);
			areaD8.push([i,area_sctn8[i].value]);
		}

		areaDataArray[0] = areaD1
		areaDataArray[1] = areaD2
		areaDataArray[2] = areaD3
		areaDataArray[3] = areaD4
		areaDataArray[4] = areaD5
		areaDataArray[5] = areaD6
		areaDataArray[6] = areaD7
		areaDataArray[7] = areaD8
		
		if (label_length * areaListCnt < 200 ) {
			autoscaleMargin = 0.01;
			barWidth = 0.01;
		}
		if (label_length * areaListCnt < 100 ) {
			autoscaleMargin = 0.02;
			barWidth = 0.015;
		}		
		if (label_length *areaListCnt < 60 ) {
			autoscaleMargin = 0.05;
			barWidth = 0.025;
		}
		if (label_length * areaListCnt < 40 ) {
			autoscaleMargin = 0.1;
			barWidth = 0.04;
		}
		if (label_length * areaListCnt < 20 ) {
			autoscaleMargin = 0.1;
			barWidth = 0.09;
		}
		if (label_length * areaListCnt < 10 ) {
			autoscaleMargin = 0.3;
			barWidth = 0.12;
		}
		
		for (var i = 0; i < label_length; i++) {
			data2.push({
				label: label[i],
				data: areaDataArray[i],
				bars: {
					barWidth : barWidth,
					show : true,
					order : 1,
					fillColor : graphColor[i]
				}, color : graphColor[i]
			});
		}

		$.plot($("#placeholder2"), data2, {
			xaxis : {
				show : true,
				ticks : areaTicks,
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
	    $("#placeholder2").bind("plothover", function (event, pos, item) {
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
	}
	
	<c:if test="${param.searchArea != '' && param.searchInduty != ''}">	
	});
	</c:if>
	
});
</script>
</head>
<body>
<form name="dataForm" id="dataForm" method="POST">
		<c:forEach items="${areaResultList}" var="areaResult" varStatus="status">
			<c:if test="${param.searchArea != null}">
				<c:if test = "${param.searchArea=='1'}"><input type="hidden" name="tick2" value="${areaResult.upperNm}"></c:if>
				<c:if test = "${param.searchArea=='2'}"><input type="hidden" name="tick2" value="${areaResult.abrv}"></c:if>			
			
				<input type="hidden" name="area_sctn1" value="${areaResult.sctn1}" />
				<input type="hidden" name="area_sctn2" value="${areaResult.sctn2}" />
				<input type="hidden" name="area_sctn3" value="${areaResult.sctn3}" />
				<input type="hidden" name="area_sctn4" value="${areaResult.sctn4}" />
				<input type="hidden" name="area_sctn5" value="${areaResult.sctn5}" />
				<input type="hidden" name="area_sctn6" value="${areaResult.sctn6}" />
				<input type="hidden" name="area_sctn7" value="${areaResult.sctn7}" />
				<input type="hidden" name="area_sctn8" value="${areaResult.sctn8}" />
			</c:if>	
		</c:forEach>
		
		<c:forEach items="${indutyResultList}" var="indutyResult" varStatus="status">
			<c:if test="${param.searchInduty != null}">
				<c:if test = "${param.searchInduty=='1'}"><input type="hidden" name="tick1" value="${indutyResult.indutySeNm}"></c:if>
				<c:if test = "${param.searchInduty=='2'}"><input type="hidden" name="tick1" value="${indutyResult.dtlclfcNm}"></c:if>
				<c:if test = "${param.searchInduty=='3'}"><input type="hidden" name="tick1" value="${indutyResult.indutyNm}"></c:if>		
			
				<input type="hidden" name="induty_sctn1" value="${indutyResult.sctn1}" />
				<input type="hidden" name="induty_sctn2" value="${indutyResult.sctn2}" />
				<input type="hidden" name="induty_sctn3" value="${indutyResult.sctn3}" />
				<input type="hidden" name="induty_sctn4" value="${indutyResult.sctn4}" />
				<input type="hidden" name="induty_sctn5" value="${indutyResult.sctn5}" />
				<input type="hidden" name="induty_sctn6" value="${indutyResult.sctn6}" />
				<input type="hidden" name="induty_sctn7" value="${indutyResult.sctn7}" />
				<input type="hidden" name="induty_sctn8" value="${indutyResult.sctn8}" />
			</c:if>
		</c:forEach>
		
		
<div id="self_dgs">
	<div class="pop_q_con">
	    <!--// 검색 조건 -->
	    <div class="search_top">
	        <table cellpadding="0" cellspacing="0" class="table_search mgb30" summary="주요지표 현황 챠트" >
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
	                <td>${param.searchStdyy}</td>
	            </tr>
	            <tr>
	                <th scope="row">업종</th>
	                <td>
	                	<c:if test="${param.searchInduty eq '1' }">제조/비제조</c:if>
		               	<c:if test="${param.searchInduty eq '2' }">업종테마별</c:if>
		               	<c:if test="${param.searchInduty eq '3' }">상세업종별</c:if>
	                </td>
	                <th scope="row">지역</th>
	                <td>
	                	<c:if test="${param.searchArea eq '1' }"> 권역별</c:if>
	                    <c:if test="${param.searchArea eq '2' }"> 지역별</c:if>
	                </td>
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
	                	<li class="remark2">1백만불 미만</li>
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
	        <c:if test="${param.searchArea != '' && param.searchInduty != ''}">
				<div class="tabwrap mgt30">
					<div class="tab">
	     				<ul>
							<li class="on" id="tab1"><a href="#none">업종별</a></li><li id="tab2"><a href="#none">지역별</a></li>
						</ul>
	     			</div>
					<div class="tabcon" style="display: block;">
						<div class="chart_zone" id="placeholder1" ></div>
	        		</div>
					<div class="tabcon"style="display: none;">
						<div class="chart_zone" id="placeholder2" ></div>
					</div>
				</div>
			</c:if>
			<c:if test="${param.searchArea != '' && param.searchInduty == ''}" > 
				<div class="chart_zone mgt30" id="placeholder2"></div>
	    	</c:if>
			<c:if test="${param.searchArea == '' && param.searchInduty != ''}" > 
				<div class="chart_zone mgt30" id="placeholder1" ></div>
	    	</c:if>

	        <!--chart //-->
	        <div class="btn_page_last"> 
	        	<a class="btn_page_admin" href="javascript:window.print();"><span>인쇄</span></a> 
	        	<a class="btn_page_admin" href="#" onclick="parent.$.fn.colorbox.close();"><span>닫기</span></a>
	        </div>
	    	<!--chart영역 //-->
	    </div>
	</div>
	<!--content//-->
	</div>
</div>
</form>
</body>
</html>