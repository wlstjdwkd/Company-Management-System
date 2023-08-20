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
	tabwrap();													// 탭
	
	var previousPoint;
	
	var indutyListCnt = ${indutyListCnt};
	var areaListCnt = ${areaListCnt};
	
	var autoscaleMargin;											// 그래프 거리
	var barWidth;														// 바 너비
	
	var data1 = [];														// 업종별
	var data2 = [];														// 지역별
	var indutyTicks = [];
	var areaTicks = [];
	
	var indutyD1 = [];												// b2bCo
	var indutyD2 = [];												// b2cCo
	var indutyD3 = [];												// b2gCo
	
	var areaD1 = [];													// b2bCo
	var areaD2 = [];													// b2cCo
	var areaD3 = [];													// b2gCo
	
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
	
	if ( '${searchInduty}' != '') {
		var indutyTick= document.getElementsByName("tick1");						// 업종별 x라벨
			
		var indutyB2bCo= document.getElementsByName("indutyB2bCo");
		var indutyB2cCo= document.getElementsByName("indutyB2cCo");
		var indutyB2gCo= document.getElementsByName("indutyB2gCo");
		
		for(var i = 0; i < indutyListCnt; i++) {
			indutyTicks.push([i, indutyTick[i].value]);
			indutyD1.push([i,indutyB2bCo[i].value]);
			indutyD2.push([i,indutyB2cCo[i].value]);
			indutyD3.push([i,indutyB2gCo[i].value]);
		}
		
		if (indutyListCnt * 3 < 200 ) {
			autoscaleMargin = 0.01;
			barWidth = 0.01;
		}
		if (indutyListCnt * 3 < 100 ) {
			autoscaleMargin = 0.02;
			barWidth = 0.015;
		}		
		if (indutyListCnt * 3 < 60 ) {
			autoscaleMargin = 0.05;
			barWidth = 0.025;
		}
		if (indutyListCnt * 3 < 40 ) {
			autoscaleMargin = 0.05;
			barWidth = 0.04;			
		}
		if (indutyListCnt * 3 < 20 ) {
			autoscaleMargin = 0.1;
			barWidth = 0.09;
		}
		if (indutyListCnt * 3 < 10 ) {
			autoscaleMargin = 0.3;
			barWidth = 0.12;
		}
		
		data1.push({
			label: "B2B",
			data: indutyD1,
			bars: {
				barWidth : barWidth,
				show : true,
				order : 1,
				fillColor : graphColor[0]
			}, color : graphColor[0]
		});

		data1.push({
			label: "B2C",
			data: indutyD2,
			bars: {
				barWidth : barWidth,
				show : true,
				order : 2,
				fillColor : graphColor[1]
			}, color : graphColor[1]
		});

		data1.push({
			label: "B2G",
			data: indutyD3,
			bars: {
				barWidth : barWidth,
				show : true,
				order : 3,
				fillColor : graphColor[2]
			}, color : graphColor[2]
		});
		
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
	
	<c:if test="${searchArea != '' && searchInduty != ''}">
		$("#tab2").click(function(){
	</c:if>
	
	if( '${searchArea}' != '') {
		var areaTick= document.getElementsByName("tick2");							// 지역별 x라벨
	
		var areaB2bCo= document.getElementsByName("areaB2bCo");
		var areaB2cCo= document.getElementsByName("areaB2cCo");
		var areaB2gCo= document.getElementsByName("areaB2gCo");

		for(var j = 0; j < areaListCnt; j++) {
			areaTicks.push([j, areaTick[j].value]);
			areaD1.push([j,areaB2bCo[j].value]);
			areaD2.push([j,areaB2cCo[j].value]);
			areaD3.push([j,areaB2gCo[j].value]);
		}
	
		if (areaListCnt * 3 < 200 ) {
			autoscaleMargin = 0.01;
			barWidth = 0.01;
		}
		if (areaListCnt * 3 < 100 ) {
			autoscaleMargin = 0.02;
			barWidth = 0.015;
		}		
		if (areaListCnt * 3 < 60 ) {
			autoscaleMargin = 0.05;
			barWidth = 0.025;
		}
		if (areaListCnt * 3 < 40 ) {
			autoscaleMargin = 0.1;
			barWidth = 0.04;
		}
		if (areaListCnt * 3 < 20 ) {
			autoscaleMargin = 0.1;
			barWidth = 0.09;
		}
		if (areaListCnt * 3 < 10 ) {
			autoscaleMargin = 0.3;
			barWidth = 0.12;
		}
		
		data2.push({
			label: "B2B",
			data: areaD1,
			bars: {
				barWidth : barWidth,
				show : true,
				order : 1,
				fillColor : graphColor[0]
			}, color : graphColor[0]
		});
	
		data2.push({
			label: "B2C",
			data: areaD2,
			bars: {
				barWidth : barWidth,
				show : true,
				order : 2,
				fillColor : graphColor[1]
			}, color : graphColor[1]
		});

		data2.push({
			label: "B2G",
			data: areaD3,
			bars: {
				barWidth : barWidth,
				show : true,
				order : 3,
				fillColor : graphColor[2]
			}, color : graphColor[2]
		});
	
		
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
	
	<c:if test="${searchArea != '' && searchInduty != ''}">	
		});
	</c:if>
});
</script>
</head>
<body>
<form name="dataForm" id="dataForm" method="POST">
		<c:forEach items="${areaResultList}" var="areaResult" varStatus="status">
			<c:if test="${searchArea != null}">
				<c:if test = "${searchArea=='1'}"><input type="hidden" name="tick2" value="${areaResult.upperNm}" /></c:if>
				<c:if test = "${searchArea=='2'}"><input type="hidden" name="tick2" value="${areaResult.abrv}" /></c:if>
	
				<input type="hidden" name="areaB2bCo" value="${areaResult.b2bCo}" />
				<input type="hidden" name="areaB2cCo" value="${areaResult.b2cCo}" />
				<input type="hidden" name="areaB2gCo" value="${areaResult.b2gCo}" />
			</c:if>
		</c:forEach>
		<c:forEach items="${indutyResultList}" var="indutyResult" varStatus="status">
			<c:if test="${searchInduty != null}">
				<c:if test = "${searchInduty=='1'}"><input type="hidden" name="tick1" value="${indutyResult.indutySeNm}" /></c:if>
				<c:if test = "${searchInduty=='2'}"><input type="hidden" name="tick1" value="${indutyResult.dtlclfcNm}" /></c:if>
				<c:if test = "${searchInduty=='3'}"><input type="hidden" name="tick1" value="${indutyResult.indutyNm}" /></c:if>
				
				<input type="hidden" name="indutyB2bCo" value="${indutyResult.b2bCo}" />
				<input type="hidden" name="indutyB2cCo" value="${indutyResult.b2cCo}" />
				<input type="hidden" name="indutyB2gCo" value="${indutyResult.b2gCo}" />
			</c:if>
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
	                <td>${searchEntprsGrp}</td>
	                <th scope="row">년도</th>
	                <td>${searchStdyy}</td>
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
	        </table>
	        
	        <!-- // chart영역-->
	        <!--// chart -->
	        <div class="remark_20 mgt20">
	    		<ul>
	    			<li class="remark1">B2B</li>
	    			<li class="remark2">B2C</li>
	    			<li class="remark3">B2G</li>	    		
	    		</ul>
	    	</div>	        
	        <c:if test="${searchArea != '' && searchInduty != ''}">
				<div class="tabwrap mgt30">
					<div class="tab">
	     				<ul>
							<li class="on" id="tab1"><a href="#none">업종별</a></li><li id="tab2"><a href="#none">지역별</a></li>
						</ul>
	     			</div>
					<div class="tabcon" style="display: block;">
						<div class="chart_zone" id="placeholder1"></div>
	        		</div>
					<div class="tabcon" style="display: none;">
						<div class="chart_zone" id="placeholder2"></div>
					</div>
				</div>
			</c:if>
			<c:if test="${searchArea != '' && searchInduty == ''}">
				<div class="chart_zone mgt30" id="placeholder2"></div>
	    	</c:if>
			<c:if test="${searchArea == '' && searchInduty != ''}">
				<div class="chart_zone mgt30" id="placeholder1" ></div>
	    	</c:if>
	        <!--chart //-->
	        <div class="btn_page_last"> 
	        	<a class="btn_page_admin" href="#" onclick="window.print();"><span>인쇄</span></a> 
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