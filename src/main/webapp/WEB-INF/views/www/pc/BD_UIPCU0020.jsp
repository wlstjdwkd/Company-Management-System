<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업검색|기업종합정보시스템 </title>

<ap:jsTag type="web" items="jquery,validate,flot" />
<ap:jsTag type="tech" items="pc,cmn, mainn, subb, font,msg,util" />


<script src="/script/jquery/flot/jquery.flot.stack.min.js"></script>
<script type="text/javascript">
	// 백분율 막대 그래프
	
	
	function drawPercentChart() {

		var ms_data = [ {
			label : "대기업",
			data : [[${(nEntrprs.ltrs * 100)/(nEntrprs.ltrs + nEntrprs.hpe + nEntrprs.smlpz)}, 3.5 ]
					, [${(employ.ltrs*100)/(employ.ltrs+employ.hpe+employ.smlpz)}, 2.5 ]
					, [${(sales.ltrs * 100)/(sales.ltrs + sales.hpe + sales.smlpz)}, 1.5 ]
					, [${(export.ltrs * 100)/(export.ltrs + export.hpe + export.smlpz)}, 0.5 ] ],
			color : "#015ca5",
			bars : {
				fill : true,
				show : true,
				fillColor : "#015ca5"
			}
		}, {
			label : "기업",
			data : [[${(nEntrprs.hpe * 100)/(nEntrprs.ltrs + nEntrprs.hpe + nEntrprs.smlpz)}, 3.5 ]
					, [${(employ.hpe*100)/(employ.ltrs+employ.hpe+employ.smlpz)}, 2.5 ]
					, [${(sales.hpe * 100)/(sales.ltrs + sales.hpe + sales.smlpz)}, 1.5 ]
					, [${(export.hpe * 100)/(export.ltrs + export.hpe + export.smlpz)}, 0.5 ]],
			color : "#1c8bd6",
			bars : {
				fill : true,
				show : true,
				fillColor : "#1c8bd6"
			}
		}, {
			label : "중소기업",
			data : [ [${(nEntrprs.smlpz * 100)/(nEntrprs.ltrs + nEntrprs.hpe + nEntrprs.smlpz)}, 3.5 ]
					, [${(employ.smlpz*100)/(employ.ltrs+employ.hpe+employ.smlpz)}, 2.5 ]
					, [${(sales.smlpz * 100)/(sales.ltrs + sales.hpe + sales.smlpz)}, 1.5 ]
					, [${(export.smlpz * 100)/(export.ltrs + export.hpe + export.smlpz)}, 0.5 ]],
			color : "#00bfd0",
				bars : {
					fill : true,
					show : true,
					fillColor : "#00bfd0"
				}
		}]
		
		var ms_ticks = [[ 0.5, "매출액" ]
						// , [ 1.5, "수출액" ]
						, [ 2.5, "고용인력" ]
						, [ 3.5, "기업수" ]];
			$.plot("#chart_stacking", ms_data, {
				yaxis : {
					ticks : ms_ticks,
					autoscaleMargin : .10
				},
				series: {
					stack: true,
					bars: {
						barWidth : 0.2,
						horizontal : true
					}
				},
				legend : {
					show : false
				},
				grid : {
					hoverable: true,
					clickable: true,
					borderWidth : 0.2
				},
				valueLabels : {
					show : true
				}
			});
			
			function showTooltip(x, y, contents) {
				$('<div id = "tooltip" style = "z-index: 999;">' +contents +' </div>').css( {
		            position: 'absolute',
		            display: 'none',
		            top: y  - 80,
		            left: x  + 10,
		            border: '1px solid #fdd',
		            padding: '2px',
		            'background-color': '#fee',
		            opacity: 0.80
		        }).appendTo("body").show();
		    }
			
			 // 툴팁 이벤트
		    $("#chart_stacking").bind("plothover", function (event, pos, item) {
		        if (item) {
		            if (previousPoint != item.datapoint) {
		                previousPoint = item.datapoint;

		                $("#tooltip").remove();
		                
		                var x = item.datapoint[0],
		                    y = item.datapoint[1];

		                if(y == 3.5) {
		                	showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + item.series.data[0][0] +"%");	
		                }
		                else if(y == 2.5) {
		                	showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + item.series.data[1][0] +"%");	
		                }
		                else if(y == 1.5) {
		                	showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + item.series.data[2][0] +"%");	
		                }
		                else if(y == 0.5) {
		                	showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + item.series.data[3][0] +"%");	
		                }
		        	}
		        } else {
		            $("#tooltip").remove();
		            previousPoint = null;
		        }
		    });
	}
	
	$(function() {
		// 백분율 그래프 실행
//		drawPercentChart();
		
		
		var previousPoint;
		// 막대 차트 데이터  	
		var ms_data = [ {
			label : "제조",
			data : [ [ 0, 1488 ]
					, [ 1, 5679]
					// , [ 2, ${(mMlfscPoint.xportAmDollar)/ 10000000 } ]
					, [ 2, 35720]],
			bars : {
					fill : true,
					show : true,
					barWidth : 0.2,
					order : 1,
					fillColor : "#1c8bd6"
			},
			color : "#1c8bd6"
		}, {
			label : "비제조",
			data : [[ 0, 2070 ]
					, [ 1, 5846 ]
					// , [ 2, ${(nMlfscPoint.xportAmDollar)/ 10000000 } ]
					, [ 2, 26320 ]],
			bars : {
				fill : true,
				show : true,
				barWidth : 0.2,
				order : 2,
				fillColor : "#00bfd0"
			},
			color : "#00bfd0"
		} ]
		
		// x 좌표
		var ms_ticks = [[ 0, "기업수" ]
							, [ 1, "고용인력" ]
							, [ 2, "매출액" ]];
		
		$.plot($("#placeholder"), ms_data, {
			xaxis : {
				ticks : ms_ticks,
				autoscaleMargin : .10
			},
			yaxis: {
				tickFormatter : function numberWithCommas(x) {
					return x.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ",");
				}
			},
			grid : {
				hoverable: true,
				clickable: true,
				borderWidth : 0.2
			},
			valueLabels : {
				show : true
			},
			legend : {
				show : false
			}
		});
		
		function showTooltip(x, y, contents) {
				$('<div id = "tooltip" style = "z-index: 999;">' +contents +' </div>').css( {
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

		// 툴팁 이벤트
	    $("#placeholder").bind("plothover", function (event, pos, item) {
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
		
		
	 // 원형 차트 데이터
 	var data = new Array();
	var pieChart = new Array();
	var  maker = [22, 444, 153, 125, 32, 56, 25,  91,  316, 15, 49, 95, 30, 47,  3, 140, 100];
	var nmaker = [50, 500,  77,  47, 92, 46, 38, 168, 1367,  4, 28, 76, 63, 31, 29,  56,  53];
	 
	var productEntrprsCo= document.getElementsByName("productEntrprsCo");
	var nEntrprsCo= document.getElementsByName("nEntrprsCo");
//	var pieChart= document.getElementsByName("pieChart");
	
	
	
	for(var i=0; i<17; i++) {
//		alert(Number(productEntrprsCo[i].value));
 		pieChart[i] = document.getElementById("pieChart"+i);
		
		data[i] = [{
// 			label : "제조" , data : Number(productEntrprsCo[i].value), color : "#1c8bd6"
 			label : "제조" , data : maker[i], color : "#1c8bd6"

 		},
 		{ 
// 			label : "비제조", data : Number(nEntrprsCo[i].value), color : "#00bfd0"
  			label : "비제조", data : nmaker[i], color : "#00bfd0"
 		}];
 		
 		$.plot(pieChart[i], data[i], {
 	   	    series: {
 	   	        pie: {
 	   	            show: true,
					radius: 1/2,
 	   	         	label: {
 						show: true,
 						formatter: function(label, slice){
 							return "<div style='font-size:8pt; text-align:center; padding:2px; color:black;'>" + label + "<br/>" + Math.round(slice.percent) + "%</div>";
 						},
 						radius: 1/2,
 						background: {
 							color: null,
 							opacity: 0
 						},
 						threshold: 0
 					},
 	   	        }
 	   	    },
 	   	    legend: {
 	   	        show: false
 	   	    }
 	   	});
 	}
});

function labelFormatter(label, series) {
	return "<div style='font-size:8pt; text-align:center; padding:2px; color:white;'>" + label + "<br/>" + Math.round(series.percent) + "%</div>";
}


	
</script>
</head>
<body>
	<form name="dataForm" id="dataForm" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />

		<c:forEach items="${areaPoint}" var="areaPoint" varStatus="status">
			<input type="hidden" name="productEntrprsCo" value="${areaPoint.productEntrprsCo}" />
			<input type="hidden" name="nEntrprsCo" value="${areaPoint.nEntrprsCo}" />
		</c:forEach>
		<!--//content-->
		<div id="wrap">
			<div class="s_cont" id="s_cont">
		<div class="s_tit s_tit01">
			<h1>기업현황</h1>
		</div>
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit">기업현황</h2>
				<ul>
				</ul>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}"  />
				</div>
				<div class="r_cont s_cont01_05">
					<div class="s_tabMenu">
						<ul>
							<li class="on" style="width:50%;" ><a href="#none" alt="현황">현황</a></li>
							<li style="display:none;"><a href="#none" onclick="jsMoveMenu('1', '14', 'PGPC0030')" alt="경기전망조사">경기전망조사</a></li>
							<li style="width:50%;" ><a href="#none" onclick="jsMoveMenu('1', '14', 'PGPC0040')" alt="승인통계">승인통계</a></li>
						</ul>
					</div>
					<div class="list_bl">
						<h4 class="fram_bl">2017년 결산기준 기업규모별·업종별 주요 현황</h4>
						<div class="graph_area" style="padding: 25px 112px 49px 103px; display:none;" >
                            <div id="placeholder" style="width:673px; height: 291px;"></div>
							<div class="remark">
								<ul>
									<li class="remark1">제조업</li>
									<li class="remark2" style="margin-left: 115px;">비제조업</li>
								</ul>
							</div>
						</div>
						<span style="line-height:38px;font-size:14pt; font-weight: 400;">기업규모별 주요 현황</span>
						<table class="table_bl2">
							<colgroup>
								<col width="151px">
								<col width="184px">
								<col width="184px">
								<col width="184px">
								<col width="184px">
							</colgroup>
							<thead>
								<tr>
									<th>기업규모</th>
									<th>기업수(개)</th>
									<th>종사자(천명)</th>
									<th>매출액(십억)</th>
									<th>수출액(백만달러)</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<th class="t_bg_blue t_left">대기업<br>(구성비,%)</th>
									<td class="t_right">2,453<br>(0.4)</td>
									<td class="t_right">2,060<br>(20.5)</td>
									<td class="t_right">2,310,017<br>(48.5)</td>
									<td class="t_right">380,302<br>(66.4)</td>
								</tr>
								<tr>
									<th class="t_bg_blue t_left" style="background-color: #F6F6F6;">기업</th>
									<td style="background-color: #F6F6F6;" class="t_right">4,468<br>(0.7)</td>
									<td style="background-color: #F6F6F6;" class="t_right">1,358<br>(13.5)</td>
									<td style="background-color: #F6F6F6;" class="t_right">737,983<br>(15.5)</td>
									<td style="background-color: #F6F6F6;" class="t_right">90,895<br>(15.9)</td>
								</tr>
								<tr>
									<th class="t_bg_blue t_left">중소기업</th>
									<td class="t_right">659,174<br>(99.0)</td>
									<td class="t_right">6,608<br>(65.9)</td>
									<td class="t_right">1,711,964<br>(36.0)</td>
									<td class="t_right">101,396<br>(17.7)</td>
								</tr>
							</tbody>
						</table>
						<span style="line-height:38px;font-size:14pt; font-weight: 400;">업종별 기업 주요 현황</span>
						<table class="table_bl2">
							<colgroup>
								<col width="207px">
								<col width="226px">
								<col width="227px">
								<col width="227px">
							</colgroup>
							<thead>
								<tr>
									<th>구분</th>
									<th>기업수(개)</th>
									<th>종사자(천명)</th>
									<th>매출액(십억)</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<th class="t_bg_blue t_left">제조업</th>
									<td class="t_right">1,743</td>
									<td class="t_right">629</td>
									<td class="t_right">390,275</td>
								</tr>
								<tr>
									<th class="t_bg_blue t_left">비제조업</th>
									<td class="t_right">2,725</td>
									<td class="t_right">729</td>
									<td class="t_right">347,708</td>
								</tr>
							</tbody>
							<tfoot>
								<tr>
									<th>합계</th>
									<td class="t_right">4,468</td>
									<td class="t_right">1,358</td>
									<td class="t_right">737,983</td>
								</tr>
							</tfoot>
						</table>
					</div>
					
					<div class="list_bl">
						<h4 class="fram_bl">2017년 결산기준 지역별 기업 현황</h4>
						<div class="graph">
							<div class="graph_map">지도 그래프
								<div style="position:absolute;"><div id="pieChart0" style="width:80px; height:101px; border:0px solid red; position:relative; left:270px;top:100px;"></div></div><!-- 강원 -->
								<div style="position:absolute;"><div id="pieChart1" style="width:80px; height:101px; border:0px solid red; position:relative; left:195px;top:166px;"></div></div> <!-- 경기 -->
								<div style="position:absolute;"><div id="pieChart2" style="width:80px; height:101px; border:0px solid red; position:relative; left:265px;top:440px;"></div></div> <!-- 강남 -->
								<div style="position:absolute;"><div id="pieChart3" style="width:80px; height:101px; border:0px solid red; position:relative; left:320px;top:286px;"></div></div> <!-- 경북 -->
								<div style="position:absolute;"><div id="pieChart4" style="width:80px; height:101px; border:0px solid red; position:relative; left:110px;top:460px;"></div></div> <!-- 광주 -->
								<div style="position:absolute;"><div id="pieChart5" style="width:80px; height:101px; border:0px solid red; position:relative; left:300px;top:370px;"></div></div> <!-- 대구 -->
								<div style="position:absolute;"><div id="pieChart6" style="width:80px; height:101px; border:0px solid red; position:relative; left:170px;top:310px;"></div></div> <!-- 대전 -->
								<div style="position:absolute;"><div id="pieChart7" style="width:80px; height:101px; border:0px solid red; position:relative; left:360px;top:460px;"></div></div> <!-- 부산 -->
								<div style="position:absolute;"><div id="pieChart8" style="width:80px; height:101px; border:0px solid red; position:relative; left:140px;top:120px;"></div></div> <!-- 서울 -->
								<div style="position:absolute;"><div id="pieChart9" style="width:80px; height:101px; border:0px solid red; position:relative; left:160px;top:265px;"></div></div> <!-- 세종 -->
								<div style="position:absolute;"><div id="pieChart10" style="width:80px; height:101px; border:0px solid red; position:relative; left:390px;top:385px;"></div></div> <!-- 울산 -->
								<div style="position:absolute;"><div id="pieChart11" style="width:80px; height:101px; border:0px solid red; position:relative; left:80px;top:165px;"></div></div> <!-- 인천 -->
								<div style="position:absolute;"><div id="pieChart12" style="width:80px; height:101px; border:0px solid red; position:relative; left:90px;top:530px;"></div></div> <!-- 전남 -->
								<div style="position:absolute;"><div id="pieChart13" style="width:80px; height:101px; border:0px solid red; position:relative; left:140px;top:390px;"></div></div> <!-- 전북 -->
								<div style="position:absolute;"><div id="pieChart14" style="width:80px; height:101px; border:0px solid red; position:relative; left:80px;top:684px;"></div></div> <!-- 제주 -->
								<div style="position:absolute;"><div id="pieChart15" style="width:80px; height:101px; border:0px solid red; position:relative; left:100px;top:280px;"></div></div> <!-- 충남 -->
								<div style="position:absolute;"><div id="pieChart16" style="width:80px; height:101px; border:0px solid red; position:relative; left:210px;top:230px;"></div></div> <!-- 충북 -->
							</div>
						</div>

						<table class="table_bl2">
							<colgroup>
								<col width="25%">
								<col width="25%">
								<col width="25%">
								<col width="25%">
							</colgroup>
							<thead>
								<tr>
									<th>구분</th>
									<th>제조업</th>
									<th>비제조업</th>
									<th>합계</th>
								</tr>
							</thead>
							<tbody>
<tr><th class="t_bg_blue">강원</th><td class="t_right">22</td><td class="t_right">50</td><td class="t_right">72</td></tr>
<tr><th class="t_bg_blue">경기</th><td class="t_right">444</td><td class="t_right">500</td><td class="t_right">944</td></tr>
<tr><th class="t_bg_blue">경남</th><td class="t_right">153</td><td class="t_right">77</td><td class="t_right">230</td></tr>
<tr><th class="t_bg_blue">경북</th><td class="t_right">125</td><td class="t_right">47</td><td class="t_right">172</td></tr>
<tr><th class="t_bg_blue">광주</th><td class="t_right">32</td><td class="t_right">92</td><td class="t_right">124</td></tr>
<tr><th class="t_bg_blue">대구</th><td class="t_right">56</td><td class="t_right">46</td><td class="t_right">102</td></tr>
<tr><th class="t_bg_blue">대전</th><td class="t_right">25</td><td class="t_right">38</td><td class="t_right">63</td></tr>
<tr><th class="t_bg_blue">부산</th><td class="t_right">91</td><td class="t_right">168</td><td class="t_right">259</td></tr>
<tr><th class="t_bg_blue">서울</th><td class="t_right">316</td><td class="t_right">1,367</td><td class="t_right">1,683</td></tr>
<tr><th class="t_bg_blue">세종</th><td class="t_right">15</td><td class="t_right">4</td><td class="t_right">19</td></tr>
<tr><th class="t_bg_blue">울산</th><td class="t_right">49</td><td class="t_right">28</td><td class="t_right">77</td></tr>
<tr><th class="t_bg_blue">인천</th><td class="t_right">95</td><td class="t_right">76</td><td class="t_right">171</td></tr>
<tr><th class="t_bg_blue">전남</th><td class="t_right">30</td><td class="t_right">63</td><td class="t_right">93</td></tr>
<tr><th class="t_bg_blue">전북</th><td class="t_right">47</td><td class="t_right">31</td><td class="t_right">78</td></tr>
<tr><th class="t_bg_blue">제주</th><td class="t_right">3</td><td class="t_right">29</td><td class="t_right">32</td></tr>
<tr><th class="t_bg_blue">충남</th><td class="t_right">140</td><td class="t_right">56</td><td class="t_right">196</td></tr>
<tr><th class="t_bg_blue">충북</th><td class="t_right">100</td><td class="t_right">53</td><td class="t_right">153</td></tr>
							</tbody>
							<tfoot>
<tr><th class="t_bg_blue">전국</th><td class="t_right">1,743</td><td class="t_right">2,725</td><td class="t_right">4,468</td></tr>
							</tfoot>
						</table>
					</div>
					<div class="list_bl">
						<h4 class="fram_bl">2017년 기준 기업규모별·산업별 수출 현황</h4>
						<table class="table_bl2">
							<colgroup>
								<col width="104px">
								<col width="111px">
								<col width="167px">
								<col width="167px">
								<col width="167px">
								<col width="167px">
							</colgroup>
							<thead>
								<tr>
									<th colspan="2">구분</th>
									<th>전체</th>
									<th>광제조업</th>
									<th>도매 및 소매업</th>
									<th>기타산업</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<th rowspan="3" class="t_bg_blue" style="padding: 0">수출액<br/><span style="font-weight: 300">(백만달러%)</span></th>
									<th style="background-color: #fff;">대기업<br/><span style="font-weight: 300">(구성비)</span></th>
									<td class="t_right">380,302<br/>(66.4)</td>
									<td class="t_right">340,855<br/>(70.7)</td>
									<td class="t_right">26,117<br/>(37.2)</td>
									<td class="t_right">13,329<br/>(65.8)</td>
								</tr>
								<tr>
									<th class="t_bg_gray"         style="background-color: #F6F6F6;">기업</th>
									<td class="t_right t_bg_gray" style="background-color: #F6F6F6;">90,895<br/>(15.9)</td>
									<td class="t_right t_bg_gray" style="background-color: #F6F6F6;">79,908<br/>(16.6)</td>
									<td class="t_right t_bg_gray" style="background-color: #F6F6F6;">8,713<br/>(12.4)</td>
									<td class="t_right t_bg_gray" style="background-color: #F6F6F6;">2,273<br/>(11.2)</td>
								</tr>
								<tr>
									<th style="background-color: #fff;">기업</th>
									<td class="t_right">101,396<br/>(17.7)</td>
									<td class="t_right">61,444<br/>(12.7)</td>
									<td class="t_right">35,306<br/>(50.3)</td>
									<td class="t_right">4,646<br/>(22.9)</td>
								</tr>
							</tbody>
						</table>
					</div>
	
					<div align="right">
						<a href="http://kostat.go.kr/portal/korea/kor_nw/1/9/7/index.board" target="_blank" style="width: 331px; background: #2763ba url('/images2/sub/policy/btn_arr.png') no-repeat 305px 18px; color: #fff; text-align: center; display: inline-block; font-size: 16px; font-family: 'NanumBarunGothic'; margin-right: 8px; padding: 14px 0 13px; padding-right: 17px; letter-spacing: 0.031em; box-sizing: border-box;"  >영리법인 기업체 행정통계 결과 바로가기</a>　
						<a href="http://kostat.go.kr/portal/korea/kor_nw/1/9/8/index.board" target="_blank" style="width: 331px; background: #2763ba url('/images2/sub/policy/btn_arr.png') no-repeat 305px 18px; color: #fff; text-align: center; display: inline-block; font-size: 16px; font-family: 'NanumBarunGothic'; margin-right: 8px; padding: 14px 0 13px; padding-right: 17px; letter-spacing: 0.031em; box-sizing: border-box;"  >기업특성별 무역통계 결과 바로가기</a>
					</div>
					
				</div>				
			</div>
		</div>
	</div>
		</div>
		<!--content//-->
	</form>
</body>
</html>




