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

	var searchIndex = "${searchIndex}";																// 지표 타입
	var searchIndexVal_length = ${searchIndexVal_length};										// 지표 갯수
	var searchIndexVal= document.getElementsByName("searchIndexVal");				// 지표
	
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
	
	var data1 = [];	
	var ticks = [];
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

	var data1 = [];																								
	var tick1= document.getElementsByName("tick1");											
	
	var entrprs_co= document.getElementsByName("entrprs_co");
	var selng_am= document.getElementsByName("selng_am");
	var bsn_profit= document.getElementsByName("bsn_profit");
	var bsn_profit_rt= document.getElementsByName("bsn_profit_rt");
	var xport_am_won= document.getElementsByName("xport_am_won");
	var xport_am_won_rt= document.getElementsByName("xport_am_won_rt");
	var ordtm_labrr_co= document.getElementsByName("ordtm_labrr_co");
	var rsrch_devlop_ct= document.getElementsByName("rsrch_devlop_ct");
	var thstrm_ntpf= document.getElementsByName("thstrm_ntpf");	
	if (searchIndex == "2") {
		var avrg_corage= document.getElementsByName("corage");
	}
	
	var d1 = [];
	var d2 = [];
	var d3 = [];
	var d4 = [];
	var d5 = [];
	var d6 = [];
	var d7 = [];
	var d8 = [];
	var d9 = [];
	var d10 = [];
		
	for(var i = 0; i < stdyyEd-stdyySt+1; i++) {
		d1.push([i,entrprs_co[i].value]);
		d2.push([i,selng_am[i].value]);
		d3.push([i,bsn_profit[i].value]);
		d4.push([i,bsn_profit_rt[i].value]);						
		d5.push([i,xport_am_won[i].value]);
		d6.push([i,xport_am_won_rt[i].value]);
		d7.push([i,ordtm_labrr_co[i].value]);
		d8.push([i,rsrch_devlop_ct[i].value]);
		d9.push([i,thstrm_ntpf[i].value]);
				
		if (searchIndex == "2") {
			d10.push([i,avrg_corage[i].value]);
		}
	}
    
	for (var i = stdyySt; i < stdyyEd+1; i++) {
		ticks.push([i-stdyySt, i]);
	}
	

	for(var k = 0; k < searchIndexVal_length; k++) {
		if( searchIndex == "1") {
			if(searchIndexVal[k].value == "JP01") {
				data1.push({
					label: "기업수",
					data: d1,
					bars: {
						barWidth : 0.05,
						show : true,
						order : k,
						fillColor : graphColor[0]
					}, color : graphColor[0]
				});
			}
			else if(searchIndexVal[k].value == "JP02") {
				data1.push({
					label: "매출액",
					data: d2,
					bars: {
						barWidth : 0.05,
						show : true,
						order : 2,
						fillColor : graphColor[1]
					}, color : graphColor[1]
				});
			}
			else if(searchIndexVal[k].value == "JP03") {
				data1.push({
					label: "영업이익",
					data: d3,
					bars: {
						barWidth : 0.05,
						show : true,
						order : 3,
						fillColor : graphColor[2]
					}, color : graphColor[2]
				});
				
				data1.push({
					label: "영업이익률",
					data: d4,
					bars: {
						barWidth : 0.05,
						show : true,
						order : 3,
						fillColor : graphColor[3]
					}, color : graphColor[3]
				});
				
				
			}
			else if(searchIndexVal[k].value == "JP04") {
				data1.push({
					label: "수출액",
					data: d5,
					bars: {
						barWidth : 0.05,
						show : true,
						order : 4,
						fillColor : graphColor[4]
					}, color : graphColor[4]
				});
				
				data1.push({
					label: "수출비중",
					data: d6,
					bars: {
						barWidth : 0.05,
						show : true,
						order : 4,
						fillColor : graphColor[5]
					}, color : graphColor[5]
				});
			}
			else if(searchIndexVal[k].value == "JP05") {
					data1.push({
					label: "근로자수",
					data: d7,
					bars: {
						barWidth : 0.05,
						show : true,
					order : 5,
						fillColor : graphColor[6]
					}, color : graphColor[6]
					});
			}
			else if(searchIndexVal[k].value == "JP06") {
				data1.push({
					label: "R&D집약도",
					data: d8,
					bars: {
						barWidth : 0.05,
						show : true,
						order : 6,
						fillColor : graphColor[7]
					}, color : graphColor[7]
				});
			}
			else if(searchIndexVal[k].value == "JP07") {
				data1.push({
					label: "당기순이익",
					data: d9,
					bars: {
						barWidth : 0.05,
						show : true,
						order : 7,
						fillColor : graphColor[8]
					}, color : graphColor[8]
				});
			}
		
			else if( searchIndex == "2") {
				if(searchIndexVal[j].value == "AJP01") {
					data1.push({
						label: "기업수",
						data: d1,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 1,
							fillColor : graphColor[0]
						}, color : graphColor[0]
					});
				}
				else if(searchIndexVal[j].value == "AJP02") {
					data1.push({
						label: "평균매출액",
						data: d2,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 2,
							fillColor : graphColor[1]
						}, color : graphColor[1]
					});
				}
				else if(searchIndexVal[j].value == "AJP03") {
					data1.push({
						label: "평균영업이익",
						data: d3,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 3,
							fillColor : graphColor[2]
						}, color : graphColor[2]
					});
					
					data1.push({
						label: "평균영업이익률",
						data: d4,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 3,
							fillColor : graphColor[3]
						}, color : graphColor[3]
					});
				}
				else if(searchIndexVal[j].value == "AJP04") {
					data1.push({
						label: "평균수출액",
						data: d5,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 4,
							fillColor : graphColor[4]
						}, color : graphColor[4]
					});
					
						data1.push({
						label: "평균수출비중",
						data: d6,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 4,
							fillColor : graphColor[5]
						}, color : graphColor[5]
					});
				}
				else if(searchIndexVal[j].value == "AJP05") {
					data1.push({
						label: "평균근로자수",
						data: d7,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 5,
							fillColor : graphColor[6]
						}, color : graphColor[6]
					});
				}
				else if(searchIndexVal[j].value == "AJP06") {
					data1.push({
						label: "평균R&D집약도",
						data: d8,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 6,
							fillColor : graphColor[7]
						}, color : graphColor[7]
					});
				}
				else if(searchIndexVal[j].value == "AJP07") {
					data1.push({
						label: "평균당기순이익",
						data: d9,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 7,
							fillColor : graphColor[8]
						}, color : graphColor[8]
					});	
				}
				else if(searchIndexVal[j].value == "AJP08") {
					data1.push({
						label: "평균업력",
						data: d10,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 8,
							fillColor : graphColor[9]
						}, color : graphColor[9]
					});	
				}
			}
		}
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
	<c:if test="${searchIndex == '1'}"> 
		<input type="hidden" name="entrprs_co" value="${resultList[0].sumEntrprsCo}"/>
		<input type="hidden" name="selng_am" value="${resultList[0].sumSelngAm}"/>
		<input type="hidden" name="bsn_profit" value="${resultList[0].sumBsnProfit}"/>
		<input type="hidden" name="bsn_profit_rt" value="${resultList[0].sumBsnProfitRt}"/>
		<input type="hidden" name="xport_am_won" value="${resultList[0].sumXportAmDollar}"/>
		<input type="hidden" name="xport_am_won_rt" value="${resultList[0].sumXportAmRt}"/>
		<input type="hidden" name="ordtm_labrr_co" value="${resultList[0].sumOrdtmLabrrCo}"/>
		<input type="hidden" name="rsrch_devlop_ct" value="${resultList[0].sumRsrchDevlopRt}"/>
		<input type="hidden" name="thstrm_ntpf" value="${resultList[0].sumThstrmNtpf}"/>
	</c:if>
	<c:if test="${searchIndex == '2'}">
		<input type="hidden" name="entrprs_co" value="${resultList[0].sumEntrprsCo}"/>
		<input type="hidden" name="selng_am" value="${resultList[0].avgSelngAm}"/>
		<input type="hidden" name="bsn_profit" value="${resultList[0].avgBsnProfit}"/>
		<input type="hidden" name="bsn_profit_rt" value="${resultList[0].avgBsnProfitRt}"/>
		<input type="hidden" name="xport_am_won" value="${resultList[0].avgXportAmDollar}"/>
		<input type="hidden" name="xport_am_won_rt" value="${resultList[0].avgXportAmRt}"/>
		<input type="hidden" name="ordtm_labrr_co" value="${resultList[0].avgOrdtmLabrrCo}"/>
		<input type="hidden" name="rsrch_devlop_ct" value="${resultList[0].avgRsrchDevlopRt}"/>
		<input type="hidden" name="thstrm_ntpf" value="${resultList[0].avgThstrmNtpfRt}"/>
		<input type="hidden" name="corage" value="${resultList[0].avgCorage}"/>
	</c:if>
	<c:forEach begin="1" end ="${stdyyEd-stdyySt}" step = "1" var ="stat" varStatus="status">
		<c:if test="${searchIndex == '1'}"> 
			<c:set var="cname" value="y${status.count}sumEntrprsCo" />
			<input type = "hidden" name = "entrprs_co" value="${resultList[0][cname]}"/>
			
			<c:set var="cname" value="y${status.count}sumSelngAm" />
			<input type="hidden" name="selng_am" value="${resultList[0][cname]}"/>
			
			<c:set var="cname" value="y${status.count}sumBsnProfit" />
			<input type="hidden" name="bsn_profit" value="${resultList[0][cname]}"/>
			
			<c:set var="cname" value="y${status.count}sumBsnProfitRt" />
			<input type="hidden" name="bsn_profit_rt" value="${resultList[0][cname]}"/>
			
			<c:set var="cname" value="y${status.count}sumXportAmDollar" />
			<input type="hidden" name="xport_am_won" value="${resultList[0][cname]}"/>
			
			<c:set var="cname" value="y${status.count}sumXportAmRt" />
			<input type="hidden" name="xport_am_won_rt" value="${resultList[0][cname]}"/>
			
			<c:set var="cname" value="y${status.count}sumOrdtmLabrrCo" />
			<input type="hidden" name="ordtm_labrr_co" value="${resultList[0][cname]}"/>
			
			<c:set var="cname" value="y${status.count}sumRsrchDevlopRt" />
			<input type="hidden" name="rsrch_devlop_ct" value="${resultList[0][cname]}"/>
			
			<c:set var="cname" value="y${status.count}sumThstrmNtpf" />
			<input type="hidden" name="thstrm_ntpf" value="${resultList[0][cname]}"/>
		</c:if>
		
		<c:if test="${searchIndex == '2'}"> 
		
		</c:if>
    </c:forEach>



	<c:forEach begin="0" end = "${searchIndexVal_length}" step = "1" var = "stat"> 
		<input type="hidden" name="searchIndexVal" value="${searchIndexVal[stat]}" />
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
	                <c:forEach begin="0" end = "${searchIndexVal_length}" step = "1" var ="stat">
	                	<c:if test = "${searchIndex == 1}">
	 						<ap:code id = "a" grpCd="64" type="text" selectedCd="${searchIndexVal[stat]}" />&nbsp;&nbsp;&nbsp;
	                	</c:if>
						<c:if test = "${searchIndex == 2}">
	 						<ap:code id = "b" grpCd="65" type="text" selectedCd="${searchIndexVal[stat]}" />&nbsp;&nbsp;&nbsp;
		               	 </c:if>
	                	</c:forEach>
	                </td>
	            </tr>
	        </table>
	        <!-- // chart영역-->
	        <!--// chart -->
	        <div class="remark_20 mgt20">
	    		<ul>
	    				<c:if test="${searchIndex == '2'}">
	    					<li class="bold text_16">(평균)</li>
	    				</c:if>
	    			<li class="remark1">기업수</li>
	    			<li class="remark2">매출액</li>
	    			<li class="remark3">영업이익</li>
	    			<li class="remark4">영업이익률</li>
	    			<li class="remark5">수출액</li>
	    			<li class="remark6">수출비중</li>
	    			<li class="remark7">근로자수</li>
	    			<li class="remark8">R&D집약도</li>
	    			<li class="remark9">당기순이익</li>
	    			<c:if test="${searchIndex == '2'}">
	    					<li class="remark10">평균업력</li>
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