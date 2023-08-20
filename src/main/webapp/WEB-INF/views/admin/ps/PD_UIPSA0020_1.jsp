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
<ap:jsTag type="web" items="jquery,cookie,flot,form,jqGrid,noticetimer,tools,ui,validate,notice" />
<ap:jsTag type="tech" items="pc,util,acm" />

<script type="text/javascript">
$(document).ready(function(){
	tabwrap();													// 탭
	
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
	
	var searchIndex = "${searchIndex}";																// 지표 타입
	var searchIndexVal_length = ${searchIndexVal_length};										// 지표 갯수
	var searchIndexVal= document.getElementsByName("searchIndexVal");				// 지표
	
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
	
	if (${fn:length(param.searchEntprsGrpVal)} == 3) {
	
		if ( '${searchInduty}' != '') {
			var data1 = [];																								// 업종별
			var indutyTicks = [];
			var indutyListCnt = ${indutyListCnt};
			var tick1= document.getElementsByName("tick1");											// 업종별 x라벨
		
			var induty_entrprs_co= document.getElementsByName("induty_entrprs_co");
			var induty_selng_am= document.getElementsByName("induty_selng_am");
			var induty_bsn_profit= document.getElementsByName("induty_bsn_profit");
			var induty_bsn_profit_rt= document.getElementsByName("induty_bsn_profit_rt");
			var induty_xport_am_won= document.getElementsByName("induty_xport_am_won");
			var induty_xport_am_won_rt= document.getElementsByName("induty_xport_am_won_rt");
			var induty_ordtm_labrr_co= document.getElementsByName("induty_ordtm_labrr_co");
			var induty_rsrch_devlop_ct= document.getElementsByName("induty_rsrch_devlop_ct");
			var induty_thstrm_ntpf= document.getElementsByName("induty_thstrm_ntpf");	
			if (searchIndex == "2") {
				var induty_avrg_corage= document.getElementsByName("induty_corage");
			}
			
			var indutyD1 = [];
			var indutyD2 = [];
			var indutyD3 = [];
			var indutyD4 = [];
			var indutyD5 = [];
			var indutyD6 = [];
			var indutyD7 = [];
			var indutyD8 = [];
			var indutyD9 = [];
			var indutyD10 = [];
			
			for(var i = 0; i <indutyListCnt; i++) {
				indutyTicks.push([i, tick1[i].value]);
				
				indutyD1.push([i,induty_entrprs_co[i].value]);
				indutyD2.push([i,induty_selng_am[i].value]);
				indutyD3.push([i,induty_bsn_profit[i].value]);
				indutyD4.push([i,induty_bsn_profit_rt[i].value]);
				indutyD5.push([i,induty_xport_am_won[i].value]);
				indutyD6.push([i,induty_xport_am_won_rt[i].value]);
				indutyD7.push([i,induty_ordtm_labrr_co[i].value]);
				indutyD8.push([i,induty_rsrch_devlop_ct[i].value]);
				indutyD9.push([i,induty_thstrm_ntpf[i].value]);
				
					if( searchIndex == "2") {
					indutyD10.push([i,induty_avrg_corage[i].value]);	
				}
			}
			
			
			
			if (searchIndexVal_length * indutyListCnt < 400 ) {
				autoscaleMargin = 0.01;
				barWidth = 0.01;
			}
			if (searchIndexVal_length * indutyListCnt < 100 ) {
				autoscaleMargin = 0.02;
				barWidth = 0.015;
			}		
			if (searchIndexVal_length * indutyListCnt < 60 ) {
				autoscaleMargin = 0.05;
				barWidth = 0.025;
			}
			if (searchIndexVal_length * indutyListCnt < 40 ) {
				autoscaleMargin = 0.05;
				barWidth = 0.04;			
			}
			if (searchIndexVal_length * indutyListCnt < 20 ) {
				autoscaleMargin = 0.1;
				barWidth = 0.09;
			}
			if (searchIndexVal_length * indutyListCnt < 10 ) {
				autoscaleMargin = 0.3;
				barWidth = 0.12;
			}
			
			if( searchIndex == "1") {
				for(var j=0; j < searchIndexVal_length; j++ ) {
					if(searchIndexVal[j].value == "JP01") {
						data1.push({
							label: "기업수",
							data: indutyD1,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 1,
								fillColor : graphColor[0]
							}, color : graphColor[0]
						});
					}
						
					else if(searchIndexVal[j].value == "JP02") {
						data1.push({
							label: "매출액",
							data: indutyD2,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 2,
								fillColor : graphColor[1]
							}, color : graphColor[1]
						});
					}
					
					else if(searchIndexVal[j].value == "JP03") {
						data1.push({
							label: "영업이익",
							data: indutyD3,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 3,
								fillColor : graphColor[2]
							}, color : graphColor[2]
						});
						
						data1.push({
							label: "영업이익률",
							data: indutyD4,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 3,
								fillColor : graphColor[3]
							}, color : graphColor[3]
						});
					}
					else if(searchIndexVal[j].value == "JP04") {
						data1.push({
							label: "수출액",
							data: indutyD5,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 4,
								fillColor : graphColor[4]
							}, color : graphColor[4]
						});
						
						data1.push({
							label: "수출비중",
							data: indutyD6,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 4,
								fillColor : graphColor[5]
							}, color : graphColor[5]
						});
					}
					else if(searchIndexVal[j].value == "JP05") {
						data1.push({
							label: "근로자수",
							data: indutyD7,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 5,
								fillColor : graphColor[6]
							}, color : graphColor[6]
						});
					}
					else if(searchIndexVal[j].value == "JP06") {
						data1.push({
							label: "R&D집약도",
							data: indutyD8,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 6,
								fillColor : graphColor[7]
							}, color : graphColor[7]
						});
					}
					else if(searchIndexVal[j].value == "JP07") {
						data1.push({
							label: "당기순이익",
							data: indutyD9,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 7,
								fillColor : graphColor[8]
							}, color : graphColor[8]
						});	
					}
				}
			}
			
			else if( searchIndex == "2") {
				for(var j=0; j < searchIndexVal_length; j++ ) {
					if(searchIndexVal[j].value == "AJP01") {
						data1.push({
							label: "기업수",
							data: indutyD1,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 1,
								fillColor : graphColor[0]
							}, color : graphColor[0]
						});
					}
					else if(searchIndexVal[j].value == "AJP02") {
						data1.push({
							label: "평균매출액",
							data: indutyD2,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 2,
								fillColor : graphColor[1]
							}, color : graphColor[1]
						});
					}
					else if(searchIndexVal[j].value == "AJP03") {
						data1.push({
							label: "평균영업이익",
							data: indutyD3,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 3,
								fillColor : graphColor[2]
							}, color : graphColor[2]
						});
						
						data1.push({
							label: "평균영업이익률",
							data: indutyD4,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 3,
								fillColor : graphColor[3]
							}, color : graphColor[3]
						});
					}
					else if(searchIndexVal[j].value == "AJP04") {
						data1.push({
							label: "평균수출액",
							data: indutyD5,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 4,
								fillColor : graphColor[4]
							}, color : graphColor[4]
						});
						
						data1.push({
							label: "평균수출비중",
							data: indutyD6,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 4,
								fillColor : graphColor[5]
							}, color : graphColor[5]
						});
					}
					else if(searchIndexVal[j].value == "AJP05") {
						data1.push({
							label: "평균근로자수",
							data: indutyD7,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 5,
								fillColor : graphColor[6]
							}, color : graphColor[6]
						});
					}
					else if(searchIndexVal[j].value == "AJP06") {
						data1.push({
							label: "평균R&D집약도",
							data: indutyD8,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 6,
								fillColor : graphColor[7]
							}, color : graphColor[7]
						});
					}
					else if(searchIndexVal[j].value == "AJP07") {
						data1.push({
							label: "평균당기순이익",
							data: indutyD9,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 7,
								fillColor : graphColor[8]
							}, color : graphColor[8]
						});	
					}
					else if(searchIndexVal[j].value == "AJP08") {
						data1.push({
							label: "평균업력",
							data: indutyD10,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 8,
								fillColor : graphColor[9]
							}, color : graphColor[9]
						});	
					}
				}
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
	
		<c:if test="${searchArea != '' && searchInduty != ''}">
		$("#tab2").click(function(){
		</c:if>
		
		if( '${searchArea}' != '') {
			var data2 = [];																								// 지역별
			var areaTicks = [];
			var areaListCnt = ${areaListCnt};
			var tick2= document.getElementsByName("tick2");											// 업종별 x라벨
	
			var areaD1 = [];
			var areaD2 = [];
			var areaD3 = [];
			var areaD4 = [];
			var areaD5 = [];
			var areaD6 = [];
			var areaD7 = [];
			var areaD8 = [];
			var areaD9 = [];
			var areaD10 = [];
			
			var area_entrprs_co= document.getElementsByName("area_entrprs_co");
			var area_selng_am= document.getElementsByName("area_selng_am");
			var area_bsn_profit= document.getElementsByName("area_bsn_profit");
			var area_bsn_profit_rt= document.getElementsByName("area_bsn_profit_rt");
			var area_xport_am_won= document.getElementsByName("area_xport_am_won");
			var area_xport_am_won_rt= document.getElementsByName("area_xport_am_won_rt");
			var area_ordtm_labrr_co= document.getElementsByName("area_ordtm_labrr_co");
			var area_rsrch_devlop_ct= document.getElementsByName("area_rsrch_devlop_ct");
			var area_thstrm_ntpf= document.getElementsByName("area_thstrm_ntpf");
			if (searchIndex == "2") {
				var area_avrg_corage= document.getElementsByName("area_corage");
			}
		
			for(var i = 0; i <areaListCnt; i++) {
				areaTicks.push([i, tick2[i].value]);
				areaD1.push([i,area_entrprs_co[i].value]);
				areaD2.push([i,area_selng_am[i].value]);
				areaD3.push([i,area_bsn_profit[i].value]);
				areaD4.push([i,area_bsn_profit_rt[i].value]);
				areaD5.push([i,area_xport_am_won[i].value]);
				areaD6.push([i,area_xport_am_won_rt[i].value]);
				areaD7.push([i,area_ordtm_labrr_co[i].value]);
				areaD8.push([i,area_rsrch_devlop_ct[i].value]);
				areaD9.push([i,area_thstrm_ntpf[i].value]);
				if( searchIndex == "2") {
					areaD10.push([i,area_avrg_corage[i].value]);
				}
			}
			
			if (areaListCnt * searchIndexVal_length < 200 ) {
				autoscaleMargin = 0.01;
				barWidth = 0.01;
			}
			if (areaListCnt * searchIndexVal_length < 100 ) {
				autoscaleMargin = 0.02;
				barWidth = 0.015;
			}		
			if (areaListCnt *searchIndexVal_length < 60 ) {
				autoscaleMargin = 0.05;
				barWidth = 0.025;
			}
			if (areaListCnt * searchIndexVal_length < 40 ) {
				autoscaleMargin = 0.1;
				barWidth = 0.04;
			}
			if (areaListCnt * searchIndexVal_length < 20 ) {
				autoscaleMargin = 0.1;
				barWidth = 0.09;
			}
			if (areaListCnt * searchIndexVal_length < 10 ) {
				autoscaleMargin = 0.3;
				barWidth = 0.12;
			}
			
			if( searchIndex == "1") {
				for(var j=0; j < searchIndexVal_length; j++ ) {
					if(searchIndexVal[j].value == "JP01") {
						data2.push({
							label: "기업수",
							data: areaD1,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 1,
								fillColor : graphColor[0]
							}, color : graphColor[0]
						});
					}
	
					else if(searchIndexVal[j].value == "JP02") {
						data2.push({
							label: "매출액",
							data: areaD2,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 2,
								fillColor : graphColor[1]
							}, color : graphColor[1]
						});
					}
	
					else if(searchIndexVal[j].value == "JP03") {
						data2.push({
							label: "영업이익",
							data: areaD3,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 3,
								fillColor : graphColor[2]
							}, color : graphColor[2]
						});
						
						data2.push({
							label: "영업이익률",
							data: areaD4,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 3,
								fillColor : graphColor[3]
							}, color : graphColor[3]
						});
					}
					
					else if(searchIndexVal[j].value == "JP04") {
						data2.push({
							label: "수출액",
							data: areaD5,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 4,
								fillColor : graphColor[4]
							}, color : graphColor[4]
						});
						
						data2.push({
							label: "수출비중",
							data: areaD6,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 4,
								fillColor : graphColor[5]
							}, color : graphColor[5]
						});
					}
					else if(searchIndexVal[j].value == "JP05") {
						data2.push({
							label: "근로자수",
							data: areaD7,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 5,
									fillColor : graphColor[6]
							}, color : graphColor[6]
						});
					}
					
						else if(searchIndexVal[j].value == "JP06") {
						data2.push({
							label: "R&D집약도",
							data: areaD8,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 6,
								fillColor : graphColor[7]
							}, color : graphColor[7]
						});
					}
					
					else if(searchIndexVal[j].value == "JP07") {
						data2.push({
							label: "당기순이익",
							data: areaD9,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 7,
								fillColor : graphColor[8]
							}, color : graphColor[8]
						});	
					}
				}
			}
		
			else if( searchIndex == "2") {
				for(var j=0; j < searchIndexVal_length; j++ ) {
					if(searchIndexVal[j].value == "AJP01") {
						data2.push({
							label: "기업수",
							data: areaD1,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 1,
								fillColor : graphColor[0]
							}, color : graphColor[0]
						});
					}
					else if(searchIndexVal[j].value == "AJP02") {
						data2.push({
							label: "평균매출액",
							data: areaD2,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 2,
								fillColor : graphColor[1]
							}, color : graphColor[1]
						});
					}
					else if(searchIndexVal[j].value == "AJP03") {
						data2.push({
							label: "평균영업이익",
								data: areaD3,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 3,
								fillColor : graphColor[2]
							}, color : graphColor[2]
						});
						
						data2.push({
							label: "평균영업이익률",
							data: areaD4,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 3,
								fillColor : graphColor[3]
							}, color : graphColor[3]
						});
					}
					else if(searchIndexVal[j].value == "AJP04") {
						data2.push({
							label: "평균수출액",
							data: areaD5,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 4,
								fillColor : graphColor[4]
							}, color : graphColor[4]
						});
						
						data2.push({
							label: "평균수출비중",
							data: areaD6,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 4,
								fillColor : graphColor[5]
							}, color : graphColor[5]
						});
					}
					else if(searchIndexVal[j].value == "AJP05") {
						data2.push({
							label: "평균근로자수",
							data: areaD7,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 5,
								fillColor : graphColor[6]
							}, color : graphColor[6]
						});
					}
					else if(searchIndexVal[j].value == "AJP06") {
						data2.push({
							label: "평균R&D집약도",
							data: areaD8,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 6,
								fillColor : graphColor[7]
							}, color : graphColor[7]
						});
					}
					else if(searchIndexVal[j].value == "AJP07") {
						data2.push({
							label: "평균당기순이익",
							data: areaD9,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 7,
								fillColor : graphColor[8]
							}, color : graphColor[8]
						});
					}
					else if(searchIndexVal[j].value == "AJP08") {
						data2.push({
							label: "평균업력",
							data: areaD10,
							bars: {
								barWidth : barWidth,
								show : true,
								order : 8,
								fillColor : graphColor[9]
							}, color : graphColor[9]
						});
					}
				}
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
	
		<c:if test="${searchArea != '' && searchInduty != ''}">	
		});
		</c:if>
	
	}
		
		
	else if (${fn:length(param.searchEntprsGrpVal)} > 3) {									// 기업군 다중선택
		var data3 = [];																								
		var ticks = [];
		var indutyListCnt = ${indutyListCnt};
		var tick3= document.getElementsByName("tick3");											// 업종별 x라벨
		
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
			var corage= document.getElementsByName("corage");
		}
		
		var D1 = [];
		var D2 = [];
		var D3 = [];
		var D4 = [];
		var D5 = [];
		var D6 = [];
		var D7 = [];
		var D8 = [];
		var D9 = [];
		var D10 = [];
		
		for(var i = 0; i <indutyListCnt; i++) {
			ticks.push([i, tick3[i].value]);
			
			D1.push([i,entrprs_co[i].value]);
			D2.push([i,selng_am[i].value]);
			D3.push([i,bsn_profit[i].value]);
			D4.push([i,bsn_profit_rt[i].value]);
			D5.push([i,xport_am_won[i].value]);
			D6.push([i,xport_am_won_rt[i].value]);
			D7.push([i,ordtm_labrr_co[i].value]);
			D8.push([i,rsrch_devlop_ct[i].value]);
			D9.push([i,thstrm_ntpf[i].value]);
			
			if( searchIndex == "2") {
				D10.push([i,corage[i].value]);	
			}
		}

		if( searchIndex == "1") {
			for(var j=0; j < searchIndexVal_length; j++ ) {
				if(searchIndexVal[j].value == "JP01") {
					data3.push({
						label: "기업수",
						data: D1,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 1,
							fillColor : graphColor[0]
						}, color : graphColor[0]
					});
				}
					
				else if(searchIndexVal[j].value == "JP02") {
					data3.push({
						label: "매출액",
						data: D2,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 2,
							fillColor : graphColor[1]
						}, color : graphColor[1]
					});
				}
				
				else if(searchIndexVal[j].value == "JP03") {
					data3.push({
						label: "영업이익",
						data: D3,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 3,
							fillColor : graphColor[2]
						}, color : graphColor[2]
					});
					
					data3.push({
						label: "영업이익률",
						data: D4,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 3,
							fillColor : graphColor[3]
						}, color : graphColor[3]
					});
				}
				else if(searchIndexVal[j].value == "JP04") {
					data3.push({
						label: "수출액",
						data: D5,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 4,
							fillColor : graphColor[4]
						}, color : graphColor[4]
					});
					
					data3.push({
						label: "수출비중",
						data: D6,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 4,
							fillColor : graphColor[5]
						}, color : graphColor[5]
					});
				}
				else if(searchIndexVal[j].value == "JP05") {
					data3.push({
						label: "근로자수",
						data: D7,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 5,
							fillColor : graphColor[6]
						}, color : graphColor[6]
					});
				}
				else if(searchIndexVal[j].value == "JP06") {
					data3.push({
						label: "R&D집약도",
						data: D8,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 6,
							fillColor : graphColor[7]
						}, color : graphColor[7]
					});
				}
				else if(searchIndexVal[j].value == "JP07") {
					data3.push({
						label: "당기순이익",
						data: D9,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 7,
							fillColor : graphColor[8]
						}, color : graphColor[8]
					});	
				}
			}
		}
		else if( searchIndex == "2") {
			for(var j=0; j < searchIndexVal_length; j++ ) {
				if(searchIndexVal[j].value == "AJP01") {
					data3.push({
						label: "기업수",
						data: D1,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 1,
							fillColor : graphColor[0]
						}, color : graphColor[0]
					});
				}
				else if(searchIndexVal[j].value == "AJP02") {
					data3.push({
						label: "평균매출액",
						data: D2,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 2,
							fillColor : graphColor[1]
						}, color : graphColor[1]
					});
				}
				else if(searchIndexVal[j].value == "AJP03") {
					data3.push({
						label: "평균영업이익",
						data: D3,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 3,
							fillColor : graphColor[2]
						}, color : graphColor[2]
					});
					
					data3.push({
						label: "평균영업이익률",
						data: D4,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 3,
							fillColor : graphColor[3]
						}, color : graphColor[3]
					});
				}
				else if(searchIndexVal[j].value == "AJP04") {
					data3.push({
						label: "평균수출액",
						data: D5,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 4,
							fillColor : graphColor[4]
						}, color : graphColor[4]
					});
					
					data3.push({
						label: "평균수출비중",
						data: D6,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 4,
							fillColor : graphColor[5]
						}, color : graphColor[5]
					});
				}
				else if(searchIndexVal[j].value == "AJP05") {
					data3.push({
						label: "평균근로자수",
						data: D7,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 5,
							fillColor : graphColor[6]
						}, color : graphColor[6]
					});
				}
				else if(searchIndexVal[j].value == "AJP06") {
					data3.push({
						label: "평균R&D집약도",
						data: D8,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 6,
							fillColor : graphColor[7]
						}, color : graphColor[7]
					});
				}
				else if(searchIndexVal[j].value == "AJP07") {
					data3.push({
						label: "평균당기순이익",
						data: D9,
						bars: {
							barWidth : 0.05,
							show : true,
							order : 7,
							fillColor : graphColor[8]
						}, color : graphColor[8]
					});	
				}
				else if(searchIndexVal[j].value == "AJP08") {
					data3.push({
						label: "평균업력",
						data: D10,
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
	
		$.plot($("#placeholder3"), data3, {
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
		   $("#placeholder3").bind("plothover", function (event, pos, item) {
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
});
</script>
</head>
<body>
<form name="dataForm" id="dataForm" method="POST">
		<c:if test="${fn:length(param.searchEntprsGrpVal) == 3}">
			<c:forEach items="${areaResultList}" var="areaResult" varStatus="status">
				<c:if test="${searchArea != null}">
					<c:if test = "${searchArea=='1'}"><input type="hidden" name="tick2" value="${areaResult.upperNm}"></c:if>
					<c:if test = "${searchArea=='2'}"><input type="hidden" name="tick2" value="${areaResult.abrv}"></c:if>
	
					<c:if test="${searchIndex == '1'}"> 
						<input type="hidden" name="area_entrprs_co" value="${areaResult.sumEntrprsCo}"/>
						<input type="hidden" name="area_selng_am" value="${areaResult.sumSelngAm}"/>
						<input type="hidden" name="area_bsn_profit" value="${areaResult.sumBsnProfit}"/>
						<input type="hidden" name="area_bsn_profit_rt" value="${areaResult.sumBsnProfitRt}"/>
						<input type="hidden" name="area_xport_am_won" value="${areaResult.sumXportAmDollar}"/>
						<input type="hidden" name="area_xport_am_won_rt" value="${areaResult.sumXportAmRt}"/>
						<input type="hidden" name="area_ordtm_labrr_co" value="${areaResult.sumOrdtmLabrrCo}"/>
						<input type="hidden" name="area_rsrch_devlop_ct" value="${areaResult.sumRsrchDevlopRt}"/>
						<input type="hidden" name="area_thstrm_ntpf" value="${areaResult.sumThstrmNtpf}"/>
					</c:if>
					<c:if test="${searchIndex == '2'}"> 
						<input type="hidden" name="area_entrprs_co" value="${areaResult.sumEntrprsCo}"/>
						<input type="hidden" name="area_selng_am" value="${areaResult.avgSelngAm}"/>
						<input type="hidden" name="area_bsn_profit" value="${areaResult.avgBsnProfit}"/>
						<input type="hidden" name="area_bsn_profit_rt" value="${areaResult.avgBsnProfitRt}"/>
						<input type="hidden" name="area_xport_am_won" value="${areaResult.avgXportAmDollar}"/>
						<input type="hidden" name="area_xport_am_won_rt" value="${areaResult.avgXportAmRt}"/>
						<input type="hidden" name="area_ordtm_labrr_co" value="${areaResult.avgOrdtmLabrrCo}"/>
						<input type="hidden" name="area_rsrch_devlop_ct" value="${areaResult.avgRsrchDevlopRt}"/>
						<input type="hidden" name="area_thstrm_ntpf" value="${areaResult.avgThstrmNtpf}"/>
						<input type="hidden" name="area_corage" value="${areaResult.avgCorage}"/>
					</c:if>
				</c:if>
			</c:forEach>
			
			<c:forEach items="${indutyResultList}" var="indutyResult" varStatus="status">
				<c:if test="${searchInduty != null}">
					<c:if test = "${searchInduty=='1'}"><input type="hidden" name="tick1" value="${indutyResult.indutySeNm}"></c:if>
					<c:if test = "${searchInduty=='2'}"><input type="hidden" name="tick1" value="${indutyResult.dtlclfcNm}"></c:if>
					<c:if test = "${searchInduty=='3'}"><input type="hidden" name="tick1" value="${indutyResult.indutyNm}"></c:if>
		
					<c:if test="${searchIndex == '1'}">
						<input type="hidden" name="induty_entrprs_co" value="${indutyResult.sumEntrprsCo}"/>
						<input type="hidden" name="induty_selng_am" value="${indutyResult.sumSelngAm}"/>
						<input type="hidden" name="induty_bsn_profit" value="${indutyResult.sumBsnProfit}"/>
						<input type="hidden" name="induty_bsn_profit_rt" value="${indutyResult.sumBsnProfitRt}"/>
						<input type="hidden" name="induty_xport_am_won" value="${indutyResult.sumXportAmDollar}"/>
						<input type="hidden" name="induty_xport_am_won_rt" value="${indutyResult.sumXportAmRt}"/>
						<input type="hidden" name="induty_ordtm_labrr_co" value="${indutyResult.sumOrdtmLabrrCo}"/>
						<input type="hidden" name="induty_rsrch_devlop_ct" value="${indutyResult.sumRsrchDevlopRt}"/>
						<input type="hidden" name="induty_thstrm_ntpf" value="${indutyResult.sumThstrmNtpf}"/>
					</c:if>
					<c:if test="${searchIndex == '2'}">
						<input type="hidden" name="induty_entrprs_co" value="${indutyResult.sumEntrprsCo}"/>
						<input type="hidden" name="induty_selng_am" value="${indutyResult.avgSelngAm}"/>
						<input type="hidden" name="induty_bsn_profit" value="${indutyResult.avgBsnProfit}"/>
						<input type="hidden" name="induty_bsn_profit_rt" value="${indutyResult.avgBsnProfitRt}"/>
						<input type="hidden" name="induty_xport_am_won" value="${indutyResult.avgXportAmDollar}"/>
						<input type="hidden" name="induty_xport_am_won_rt" value="${indutyResult.avgXportAmRt}"/>
						<input type="hidden" name="induty_ordtm_labrr_co" value="${indutyResult.avgOrdtmLabrrCo}"/>
						<input type="hidden" name="induty_rsrch_devlop_ct" value="${indutyResult.avgRsrchDevlopRt}"/>
						<input type="hidden" name="induty_thstrm_ntpf" value="${indutyResult.avgThstrmNtpfRt}"/>
						<input type="hidden" name="induty_corage" value="${indutyResult.avgCorage}"/>
					</c:if>
				</c:if>
			</c:forEach>
		</c:if>

		<c:if test="${fn:length(param.searchEntprsGrpVal) > 3}">
			<c:forEach items="${resultList}" var="result" varStatus="status">
				<input type="hidden" name="tick3" value="${result.entclsNm}">

				<c:if test="${searchIndex == '1'}">
					<input type="hidden" name="entrprs_co" value="${result.sumEntrprsCo}"/>
					<input type="hidden" name="selng_am" value="${result.sumSelngAm}"/>
					<input type="hidden" name="bsn_profit" value="${result.sumBsnProfit}"/>
					<input type="hidden" name="bsn_profit_rt" value="${result.sumBsnProfitRt}"/>
					<input type="hidden" name="xport_am_won" value="${result.sumXportAmDollar}"/>
					<input type="hidden" name="xport_am_won_rt" value="${result.sumXportAmRt}"/>
					<input type="hidden" name="ordtm_labrr_co" value="${result.sumOrdtmLabrrCo}"/>
					<input type="hidden" name="rsrch_devlop_ct" value="${result.sumRsrchDevlopRt}"/>
					<input type="hidden" name="thstrm_ntpf" value="${result.sumThstrmNtpf}"/>
				</c:if>
				<c:if test="${searchIndex == '2'}">
					<input type="hidden" name="entrprs_co" value="${result.sumEntrprsCo}"/>
					<input type="hidden" name="selng_am" value="${result.avgSelngAm}"/>
					<input type="hidden" name="bsn_profit" value="${result.avgBsnProfit}"/>
					<input type="hidden" name="bsn_profit_rt" value="${result.avgBsnProfitRt}"/>
					<input type="hidden" name="xport_am_won" value="${result.avgXportAmDollar}"/>
					<input type="hidden" name="xport_am_won_rt" value="${result.avgXportAmRt}"/>
					<input type="hidden" name="ordtm_labrr_co" value="${result.avgOrdtmLabrrCo}"/>
					<input type="hidden" name="rsrch_devlop_ct" value="${result.avgRsrchDevlopRt}"/>
					<input type="hidden" name="thstrm_ntpf" value="${result.avgThstrmNtpfRt}"/>
					<input type="hidden" name="corage" value="${result.avgCorage}"/>
				</c:if>
				
			</c:forEach>
		</c:if>
		
		<c:forEach begin="0" end = "${searchIndexVal_length}" step = "1" var = "stat"> 
			<input type="hidden" name="searchIndexVal" value="${searchIndexVal[stat]}" />
		</c:forEach>
		
<div id="self_dgs">
	<div class="pop_q_con">
	    <!--// 검색 조건 -->
	    <div class="search_top">
	        <table cellpadding="0" cellspacing="0" class="table_search mgb30" summary="주요지표 현황 챠트">
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
	    	<c:if test="${fn:length(param.searchEntprsGrpVal) > 3}" >
				<div class="chart_zone mgt30" id="placeholder3" ></div>
	    	</c:if>
	    	
	        <!--chart //-->
	        <div class="btn_page_last mgt50"> 
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