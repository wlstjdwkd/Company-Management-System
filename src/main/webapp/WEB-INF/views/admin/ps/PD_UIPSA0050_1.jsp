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
	
	var autoscaleMargin;											// 그래프 거리
	var barWidth;														// 바 너비
	
	var stdyySt = ${stdyySt};
	var stdyyEd = ${stdyyEd};
	
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

	for(var y=0; y <=stdyyEd-stdyySt; y++) {
		ticks.push([stdyySt+y, stdyySt+y]);
	}
	
	if ( '${searchInduty}' != '') {
		var indutyListCnt = ${indutyListCnt};
		var data1 = [];														// 업종별 통합 데이터
		
		var indutyArray = new Array();
		var tick1= document.getElementsByName("tick1");
		
		var indutyy0Co= document.getElementsByName("indutyy0Co");
		var indutyy1Co= document.getElementsByName("indutyy1Co");
		var indutyy2Co= document.getElementsByName("indutyy2Co");
		var indutyy3Co= document.getElementsByName("indutyy3Co");
		var indutyy4Co= document.getElementsByName("indutyy4Co");
		var indutyy5Co= document.getElementsByName("indutyy5Co");
		var indutyy6Co= document.getElementsByName("indutyy6Co");
		var indutyy7Co= document.getElementsByName("indutyy7Co");
		var indutyy8Co= document.getElementsByName("indutyy8Co");
		var indutyy9Co= document.getElementsByName("indutyy9Co");
		
		for(var i = 0; i < indutyListCnt; i++) {
			var d1 = [];
			
			if( stdyyEd-stdyySt >= 9 ) {
				d1.push([stdyySt,indutyy0Co[i].value]);
				d1.push([stdyySt+1,indutyy1Co[i].value]);
				d1.push([stdyySt+2,indutyy2Co[i].value]);
				d1.push([stdyySt+3,indutyy3Co[i].value]);
				d1.push([stdyySt+4,indutyy4Co[i].value]);				
				d1.push([stdyySt+5,indutyy5Co[i].value]);
				d1.push([stdyySt+6,indutyy6Co[i].value]);
				d1.push([stdyySt+7,indutyy7Co[i].value]);
				d1.push([stdyySt+8,indutyy8Co[i].value]);
				d1.push([stdyySt+9,indutyy9Co[i].value]);
			}
			else if( stdyyEd-stdyySt >= 8 ) {
				d1.push([stdyySt,indutyy0Co[i].value]);
				d1.push([stdyySt+1,indutyy1Co[i].value]);				
				d1.push([stdyySt+2,indutyy2Co[i].value]);
				d1.push([stdyySt+3,indutyy3Co[i].value]);
				d1.push([stdyySt+4,indutyy4Co[i].value]);				
				d1.push([stdyySt+5,indutyy5Co[i].value]);
				d1.push([stdyySt+6,indutyy6Co[i].value]);
				d1.push([stdyySt+7,indutyy7Co[i].value]);
				d1.push([stdyySt+8,indutyy8Co[i].value]);
			}
			else if (stdyyEd-stdyySt >= 7) {
				d1.push([stdyySt,indutyy0Co[i].value]);
				d1.push([stdyySt+1,indutyy1Co[i].value]);				
				d1.push([stdyySt+2,indutyy2Co[i].value]);
				d1.push([stdyySt+3,indutyy3Co[i].value]);
				d1.push([stdyySt+4,indutyy4Co[i].value]);				
				d1.push([stdyySt+5,indutyy5Co[i].value]);
				d1.push([stdyySt+6,indutyy6Co[i].value]);
				d1.push([stdyySt+7,indutyy7Co[i].value]);
			}
			else if (stdyyEd-stdyySt >= 6) {
				d1.push([stdyySt,indutyy0Co[i].value]);
				d1.push([stdyySt+1,indutyy1Co[i].value]);				
				d1.push([stdyySt+2,indutyy2Co[i].value]);
				d1.push([stdyySt+3,indutyy3Co[i].value]);
				d1.push([stdyySt+4,indutyy4Co[i].value]);				
				d1.push([stdyySt+5,indutyy5Co[i].value]);
				d1.push([stdyySt+6,indutyy6Co[i].value]);
			}
			else if (stdyyEd-stdyySt >= 5) {
				d1.push([stdyySt,indutyy0Co[i].value]);
				d1.push([stdyySt+1,indutyy1Co[i].value]);				
				d1.push([stdyySt+2,indutyy2Co[i].value]);
				d1.push([stdyySt+3,indutyy3Co[i].value]);
				d1.push([stdyySt+4,indutyy4Co[i].value]);				
				d1.push([stdyySt+5,indutyy5Co[i].value]);
			}
			else if (stdyyEd-stdyySt >= 4) {
				d1.push([stdyySt,indutyy0Co[i].value]);
				d1.push([stdyySt+1,indutyy1Co[i].value]);				
				d1.push([stdyySt+2,indutyy2Co[i].value]);
				d1.push([stdyySt+3,indutyy3Co[i].value]);
				d1.push([stdyySt+4,indutyy4Co[i].value]);
			}
			else if (stdyyEd-stdyySt >= 3) {
				d1.push([stdyySt,indutyy0Co[i].value]);
				d1.push([stdyySt+1,indutyy1Co[i].value]);				
				d1.push([stdyySt+2,indutyy2Co[i].value]);
				d1.push([stdyySt+3,indutyy3Co[i].value]);
			}
			else if (stdyyEd-stdyySt >= 2) {
				d1.push([stdyySt,indutyy0Co[i].value]);
				d1.push([stdyySt+1,indutyy1Co[i].value]);				
				d1.push([stdyySt+2,indutyy2Co[i].value]);
			}
			else if (stdyyEd-stdyySt >= 1) {
				d1.push([stdyySt,indutyy0Co[i].value]);
				d1.push([stdyySt+1,indutyy1Co[i].value]);
			}
			else if (stdyyEd-stdyySt >= 0) {
				d1.push([stdyySt,indutyy0Co[i].value]);
			}		
			indutyArray[i] = d1;
		}
		
		if (indutyListCnt * (stdyyEd-stdyySt+1) < 100 ) {
			autoscaleMargin = 0.02;
			barWidth = 0.015;
		}		
		if (indutyListCnt * (stdyyEd-stdyySt+1) < 60 ) {
			autoscaleMargin = 0.05;
			barWidth = 0.025;
		}
		if (indutyListCnt * (stdyyEd-stdyySt+1) < 40 ) {
			autoscaleMargin = 0.05;
			barWidth = 0.04;			
		}
		if (indutyListCnt * (stdyyEd-stdyySt+1) < 20 ) {
			autoscaleMargin = 0.1;
			barWidth = 0.09;
		}
		if (indutyListCnt * (stdyyEd-stdyySt+1) < 10 ) {
			autoscaleMargin = 0.3;
			barWidth = 0.12;
		}
		
		for(var j = 0; j<indutyListCnt; j++) {
			data1.push({
				label: tick1[j].value,
				data: indutyArray[j],
				bars: {
					barWidth : barWidth,
					show : true,
					order : 1,
					fillColor : graphColor[j]
				}, color : graphColor[j]
			});
		}

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
	}
	
	<c:if test="${searchArea != '' && searchInduty != ''}">
	$("#tab2").click(function(){
	</c:if>

	if( '${searchArea}' != '') {
		var areaListCnt = ${areaListCnt};
		
		var data2 = [];																				// 지역별 통합 데이터
		var areaArray = new Array();

		var tick2= document.getElementsByName("tick2");							// 지역별 x라벨

		var areay0Co= document.getElementsByName("areay0Co");
		var areay1Co= document.getElementsByName("areay1Co");
		var areay2Co= document.getElementsByName("areay2Co");
		var areay3Co= document.getElementsByName("areay3Co");
		var areay4Co= document.getElementsByName("areay4Co");
		var areay5Co= document.getElementsByName("areay5Co");
		var areay6Co= document.getElementsByName("areay6Co");
		var areay7Co= document.getElementsByName("areay7Co");
		var areay8Co= document.getElementsByName("areay8Co");
		var areay9Co= document.getElementsByName("areay9Co");
		
		for(var k = 0; k < areaListCnt; k++) {
			var d2 = [];
			
			if( stdyyEd-stdyySt >= 9 ) {
				d2.push([stdyySt,areay0Co[k].value]);
				d2.push([stdyySt+1,areay0Co[k].value]);
				d2.push([stdyySt+2,areay2Co[k].value]);
				d2.push([stdyySt+3,areay3Co[k].value]);
				d2.push([stdyySt+4,areay4Co[k].value]);	
				d2.push([stdyySt+5,areay5Co[k].value]);
				d2.push([stdyySt+6,areay6Co[k].value]);
				d2.push([stdyySt+7,areay7Co[k].value]);
				d2.push([stdyySt+8,areay8Co[k].value]);
				d2.push([stdyySt+9,areay9Co[k].value]);
			}			
			else if( stdyyEd-stdyySt >= 8 ) {
				d2.push([stdyySt,areay0Co[k].value]);
				d2.push([stdyySt+1,areay1Co[k].value]);
				d2.push([stdyySt+2,areay2Co[k].value]);
				d2.push([stdyySt+3,areay3Co[k].value]);
				d2.push([stdyySt+4,areay4Co[k].value]);				
				d2.push([stdyySt+5,areay5Co[k].value]);
				d2.push([stdyySt+6,areay6Co[k].value]);
				d2.push([stdyySt+7,areay7Co[k].value]);
				d2.push([stdyySt+8,areay8Co[k].value]);
			}
			else if (stdyyEd-stdyySt >= 7) {
				d2.push([stdyySt,areay0Co[k].value]);
				d2.push([stdyySt+1,areay1Co[k].value]);
				d2.push([stdyySt+2,areay2Co[k].value]);
				d2.push([stdyySt+3,areay3Co[k].value]);
				d2.push([stdyySt+4,areay4Co[k].value]);				
				d2.push([stdyySt+5,areay5Co[k].value]);
				d2.push([stdyySt+6,areay6Co[k].value]);
				d2.push([stdyySt+7,areay7Co[k].value]);
			}
			else if (stdyyEd-stdyySt >= 6) {
				d2.push([stdyySt,areay0Co[i].value]);
				d2.push([stdyySt+1,areay1Co[k].value]);
				d2.push([stdyySt+2,areay2Co[k].value]);
				d2.push([stdyySt+3,areay3Co[k].value]);
				d2.push([stdyySt+4,areay4Co[k].value]);				
				d2.push([stdyySt+5,areay5Co[k].value]);
				d2.push([stdyySt+6,areay6Co[k].value]);
			}
			else if (stdyyEd-stdyySt >= 5) {
				d2.push([stdyySt,areay0Co[k].value]);
				d2.push([stdyySt+1,areay1Co[k].value]);
				d2.push([stdyySt+2,areay2Co[k].value]);
				d2.push([stdyySt+3,areay3Co[k].value]);
				d2.push([stdyySt+4,areay4Co[k].value]);				
				d2.push([stdyySt+5,areay5Co[k].value]);
			}
			else if (stdyyEd-stdyySt >= 4) {
				d2.push([stdyySt,areay0Co[k].value]);
				d2.push([stdyySt+1,areay1Co[k].value]);
				d2.push([stdyySt+2,areay2Co[k].value]);
				d2.push([stdyySt+3,areay3Co[k].value]);
				d2.push([stdyySt+4,areay4Co[k].value]);
			}
			else if (stdyyEd-stdyySt >= 3) {
				d2.push([stdyySt,areay0Co[k].value]);
				d2.push([stdyySt+1,areay1Co[k].value]);
				d2.push([stdyySt+2,areay2Co[k].value]);
				d2.push([stdyySt+3,areay3Co[k].value]);
			}
			else if (stdyyEd-stdyySt >= 2) {
				d2.push([stdyySt,areay0Co[k].value]);
				d2.push([stdyySt+1,areay1Co[k].value]);
				d2.push([stdyySt+2,areay2Co[k].value]);
			}
			else if (stdyyEd-stdyySt >= 1) {
				d2.push([stdyySt,areay0Co[k].value]);
				d2.push([stdyySt+1,areay1Co[k].value]);
			}
			else if (stdyyEd-stdyySt >= 0) {
				d2.push([stdyySt,areay0Co[k].value]);
			}		
			areaArray[k] = d2;
		}
		
		if (areaListCnt * (stdyyEd-stdyySt+1) < 100 ) {
			autoscaleMargin = 0.02;
			barWidth = 0.015;
		}		
		if (areaListCnt * (stdyyEd-stdyySt+1) < 60 ) {
			autoscaleMargin = 0.05;
			barWidth = 0.025;
		}
		if (areaListCnt * (stdyyEd-stdyySt+1) < 40 ) {
			autoscaleMargin = 0.1;
			barWidth = 0.04;
		}
		if (areaListCnt * (stdyyEd-stdyySt+1) < 20 ) {
			autoscaleMargin = 0.1;
			barWidth = 0.09;
		}
		if (areaListCnt * (stdyyEd-stdyySt+1) < 10 ) {
			autoscaleMargin = 0.3;
			barWidth = 0.12;
		}
		
		for(var z = 0; z<areaListCnt; z++) {
			data2.push({
				label: tick2[z].value,
				data: areaArray[z],
				bars: {
					barWidth : barWidth,
					show : true,
					order : 1,
					fillColor : graphColor[z]
				}, color : graphColor[z]
			});
		}

		$.plot($("#placeholder2"), data2, {
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
				
				<input type="hidden" name="areay0Co" value="${areaResult.y0Co}" />
				<input type="hidden" name="areay1Co" value="${areaResult.y1Co}" />
				<input type="hidden" name="areay2Co" value="${areaResult.y2Co}" />
				<input type="hidden" name="areay3Co" value="${areaResult.y3Co}" />
				<input type="hidden" name="areay4Co" value="${areaResult.y4Co}" />
				<input type="hidden" name="areay5Co" value="${areaResult.y5Co}" />
				<input type="hidden" name="areay6Co" value="${areaResult.y6Co}" />
				<input type="hidden" name="areay7Co" value="${areaResult.y7Co}" />
				<input type="hidden" name="areay8Co" value="${areaResult.y8Co}" />
				<input type="hidden" name="areay9Co" value="${areaResult.y9Co}" />
				
			</c:if>
		</c:forEach>

		<c:forEach items="${indutyResultList}" var="indutyResult" varStatus="status">
			<c:if test="${searchInduty != null}">
			
				<c:if test = "${searchInduty=='1'}"><input type="hidden" name="tick1" value="${indutyResult.indutySeNm}"/></c:if>
				<c:if test = "${searchInduty=='2'}"><input type="hidden" name="tick1" value="${indutyResult.dtlclfcNm}"/></c:if>
				<c:if test = "${searchInduty=='3'}"><input type="hidden" name="tick1" value="${indutyResult.indutyNm}"/></c:if>
			
				<input type="hidden" name="indutyy0Co" value="${indutyResult.y0Co}" />
				<input type="hidden" name="indutyy1Co" value="${indutyResult.y1Co}" />
				<input type="hidden" name="indutyy2Co" value="${indutyResult.y2Co}" />
				<input type="hidden" name="indutyy3Co" value="${indutyResult.y3Co}" />
				<input type="hidden" name="indutyy4Co" value="${indutyResult.y4Co}" />
				<input type="hidden" name="indutyy5Co" value="${indutyResult.y5Co}" />
				<input type="hidden" name="indutyy6Co" value="${indutyResult.y6Co}" />
				<input type="hidden" name="indutyy7Co" value="${indutyResult.y7Co}" />
				<input type="hidden" name="indutyy8Co" value="${indutyResult.y8Co}" />
				<input type="hidden" name="indutyy9Co" value="${indutyResult.y9Co}" />
			</c:if>
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
	        <c:if test="${searchArea != '' && searchInduty != ''}">
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
			<c:if test="${searchArea != '' && searchInduty == ''}" > 
				<div class="chart_zone mgt30" id="placeholder2"></div>
	    	</c:if>
			<c:if test="${searchArea == '' && searchInduty != ''}" > 
				<div class="chart_zone mgt30" id="placeholder1" ></div>
	    	</c:if>
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