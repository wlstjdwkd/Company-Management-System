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
<title>기업검색|기업종합정보시스템</title>

<ap:jsTag type="web" items="jquery,validate,flot" />
<ap:jsTag type="tech" items="pc,ucm,msg,util" />

<script src="/script/jquery/flot/jquery.flot.stack.min.js"></script>
<script type="text/javascript">
	// 백분율 막대 그래프
	
	function drawPercentChart() {

		var ms_data = [ {
			label : "대기업",
			data : [[${(nEntrprs.ltrs * 100)/(nEntrprs.ltrs + nEntrprs.hpe + nEntrprs.smlpz)}, 3.5 ], [${(employ.ltrs*100)/(employ.ltrs+employ.hpe+employ.smlpz)}, 2.5 ], [${(sales.ltrs * 100)/(sales.ltrs + sales.hpe + sales.smlpz)}, 1.5 ], [${(export.ltrs * 100)/(export.ltrs + export.hpe + export.smlpz)}, 0.5 ] ],
			color : "#015ca5",
			bars : {
				fill : true,
				show : true,
				fillColor : "#015ca5"
			}
		}, {
			label : "기업",
			data : [[${(nEntrprs.hpe * 100)/(nEntrprs.ltrs + nEntrprs.hpe + nEntrprs.smlpz)}, 3.5 ], [${(employ.hpe*100)/(employ.ltrs+employ.hpe+employ.smlpz)}, 2.5 ], [${(sales.hpe * 100)/(sales.ltrs + sales.hpe + sales.smlpz)}, 1.5 ], [${(export.hpe * 100)/(export.ltrs + export.hpe + export.smlpz)}, 0.5 ]],
			color : "#1c8bd6",
			bars : {
				fill : true,
				show : true,
				fillColor : "#1c8bd6"
			}
		}, {
			label : "중소기업",
			data : [ [${(nEntrprs.smlpz * 100)/(nEntrprs.ltrs + nEntrprs.hpe + nEntrprs.smlpz)}, 3.5 ], [${(employ.smlpz*100)/(employ.ltrs+employ.hpe+employ.smlpz)}, 2.5 ], [${(sales.smlpz * 100)/(sales.ltrs + sales.hpe + sales.smlpz)}, 1.5 ], [${(export.smlpz * 100)/(export.ltrs + export.hpe + export.smlpz)}, 0.5 ]],
			color : "#00bfd0",
				bars : {
					fill : true,
					show : true,
					fillColor : "#00bfd0"
				}
		}]
		
		var ms_ticks = [[ 0.5, "매출액" ], [ 1.5, "수출액" ], [ 2.5, "고용인력" ],
						[ 3.5, "기업수" ]];
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
			data : [ [ 0, ${mMlfscPoint.entrprsCo} ], [ 1, ${mMlfscPoint.ordtmLabrrCo / 100} ], [ 2, ${(mMlfscPoint.xportAmDollar)/ 10000000 } ], [ 3, ${mMlfscPoint.selngAm / 10000000} ]],
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
			data : [[ 0, ${nMlfscPoint.entrprsCo } ], [ 1, ${nMlfscPoint.ordtmLabrrCo / 100} ], [ 2, ${(nMlfscPoint.xportAmDollar)/ 10000000 } ], [ 3, ${nMlfscPoint.selngAm / 10000000} ]],
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
		var ms_ticks = [[ 0, "기업수" ], [ 1, "고용인력" ], [ 2, "수출액" ], [ 3, "매출액" ]];
		
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
	 
	var productEntrprsCo= document.getElementsByName("productEntrprsCo");
	var nEntrprsCo= document.getElementsByName("nEntrprsCo");
//	var pieChart= document.getElementsByName("pieChart");
	
	
	
	for(var i=0; i<17; i++) {
 		pieChart[i] = document.getElementById("pieChart"+i);
		
		data[i] = [{
 			label : "제조" , data : Number(productEntrprsCo[i].value), color : "#1c8bd6"
 		},
 		{ label : "비제조", data : Number(nEntrprsCo[i].value), color : "#00bfd0"
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
		<div id="wrap" class="top_bg">
			<div class="contents">
				<!--//top img-->
				<div class="top_img menu01">Status and Statistics of High Potential Enterprise. 대한민국 기업이
					미래 글로벌 챔피언입니다.</div>
				<!--top img //-->

				<!--// lnb 페이지 타이틀-->
				<div class="title_page">
					<h2>						
						<img src="<c:url value="/images/pc/title_m1.png" />" alt="기업현황" />
					</h2>
				</div>
				
				<!--lnb 페이지 타이틀//-->
				<div id = "go_container"> 
				<!--//우측영역 -->
				<div class="rcont">
					<!--//page title -->
					<ap:trail menuNo="${param.df_menu_no}" />
					<!--page title //-->

					<!--//sub contents -->
					<div class="sub_cont">						
						<div class="tabwrap">					
						<div class="tab">
		                	<ul class="tab">
		                    	<li class="on"><span>현황</span></li><li onclick="jsMoveMenu('5', '14', 'PGPC0030')"><span>추이</span></li>
			                </ul>
			            </div>
					  
						<!--// 그래프1-->
			<!--			<div>
							<h4>${latelyYear}년 전체 기업 규모별 점유율</h4>
							<div class="graph_area">
							<div id="chart_stacking" style="width: 600px; height: 300px;"></div>
                            <div class="remark">
                                <ul>
                                    <li class="remark2">대기업</li>
                                    <li class="remark3">기업</li>
                                    <li class="remark4">중소기업</li>
                                </ul>
                            </div>
                        </div>  
							<div class="list2_zone graph_list">
								<table>
									<caption>기본게시판 목록</caption>
									<colgroup>
										<col style="" />
										<col style="" />
										<col style="" />
										<col style="" />
										<col style="" />
										<col style="" />
										<col style="" />
									</colgroup>
									<thead>
										<tr>
											<th scope="col">구분</th>
											<th scope="col" colspan="2">대기업</th>
											<th scope="col" colspan="2">기업</th>
											<th scope="col" colspan="2">중소기업</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td class="tit">기업수 (개)</td>
											<td><fmt:formatNumber value = "${nEntrprs.ltrs}" pattern = "#,##0"/></td>
											<td class="no_line">
												${(nEntrprs.ltrs*100)/(nEntrprs.ltrs+nEntrprs.hpe+nEntrprs.smlpz)}%</td>
											<td><fmt:formatNumber value = "${nEntrprs.hpe }" pattern = "#,##0"/></td>
											<td class="no_line">${(nEntrprs.hpe*100)/(nEntrprs.ltrs+nEntrprs.hpe+nEntrprs.smlpz)}%</td>
											<td><fmt:formatNumber value = "${nEntrprs.smlpz }" pattern = "#,##0"/></td>
											<td class="no_line">${(nEntrprs.smlpz * 100) / (nEntrprs.ltrs + nEntrprs.hpe + nEntrprs.smlpz) }%</td>
										</tr>
										<tr>
											<td class="tit">고용인력 (만명)</td>
											<td><fmt:formatNumber value = "${employ.ltrs }" pattern = "#,##0"/></td>
											<td class="no_line">${((employ.ltrs*100)div(employ.ltrs + employ.hpe + employ.smlpz))}%</td>
											<td><fmt:formatNumber value = "${employ.hpe }" pattern = "#,##0"/></td>
											<td class="no_line">${((employ.hpe * 100)div(employ.ltrs + employ.hpe + employ.smlpz))}%</td>
											<td><fmt:formatNumber value = "${employ.smlpz }" pattern = "#,##0"/></td>
											<td class="no_line">${((employ.smlpz  * 100)div (employ.ltrs + employ.hpe + employ.smlpz) )}%</td>
										</tr>
										<tr>
											<td class="tit">수출액 (억불)</td>
											<td><fmt:formatNumber value = "${sales.ltrs}" pattern = "#,##0"/></td>
											<td class="no_line">${(sales.ltrs * 100 )/ (sales.ltrs + sales.hpe + sales.smlpz)}%</td>
											<td><fmt:formatNumber value = "${sales.hpe}" pattern = "#,##0"/></td>
											<td class="no_line">${(sales.hpe * 100) / (sales.ltrs + sales.hpe + sales.smlpz)}%</td>
											<td><fmt:formatNumber value = "${sales.smlpz}" pattern = "#,##0"/></td>
											<td class="no_line">${ (sales.smlpz * 100) / (sales.ltrs + sales.hpe + sales.smlpz)}%</td>
										</tr>
										<tr>
											<td class="tit">매출액 (조원)</td>
											<td><fmt:formatNumber value = "${export.ltrs }" pattern = "#,##0"/></td>
											<td class="no_line">${(export.ltrs * 100) / (export.ltrs + export.hpe + export.smlpz) }%</td>
											<td><fmt:formatNumber value = "${export.hpe }" pattern = "#,##0"/></td>
											<td class="no_line">${(export.hpe * 100)/ (export.ltrs + export.hpe + export.smlpz)}%</td>
											<td><fmt:formatNumber value = "${export.smlpz }" pattern = "#,##0"/></td>
											<td class="no_line">${(export.smlpz * 100) / (export.ltrs + export.hpe + export.smlpz) }%</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
				-->
						<!--// 그래프2-->
						<div class="graph">
							<h4>${latelyYear}년 업종별 기업 주요 지표</h4>
							<div class="graph_area">
                            <div id="placeholder" style="width:600px; height: 300px;"></div>
                            <div class="remark">
                                <ul>
                                    <li class="remark3">제조업</li>
                                    <li class="remark4">비제조업</li>
                                </ul>
                            </div>
                        </div>
							<div class="list2_zone graph_list">
								<table>
									<caption>기본게시판 목록</caption>
									<colgroup>
										<col style="" />
										<col style="" />
										<col style="" />
										<col style="" />
										<col style="" />
									<thead>
										<tr>
											<th scope="col">구분</th>
											<th scope="col">기업수 (개)</th>
											<th scope="col">고용인력 (백명)</th>
											<th scope="col">수출액 (천만불)</th>
											<th scope="col">매출액 (백억)</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td class="tit">제조업</td>
											<td><fmt:formatNumber value = "${mMlfscPoint.entrprsCo }" pattern = "#,##0"/></td>
											<td><fmt:formatNumber value = "${mMlfscPoint.ordtmLabrrCo / 100}" pattern = "#,##0"/></td>
											<td><fmt:formatNumber value = "${(mMlfscPoint.xportAmDollar)/ 10000000 }" pattern = "#,##0"/></td>
											<td><fmt:formatNumber value = "${mMlfscPoint.selngAm / 10000000}" pattern = "#,##0"/></td>
										</tr>
										<tr>
											<td class="tit">비제조업</td>
											<td><fmt:formatNumber value = "${nMlfscPoint.entrprsCo }" pattern = "#,##0"/></td>
											<td><fmt:formatNumber value = "${nMlfscPoint.ordtmLabrrCo / 100}" pattern = "#,##0"/></td>
											<td><fmt:formatNumber value = "${(nMlfscPoint.xportAmDollar)/ 10000000 }" pattern = "#,##0"/></td>
											<td><fmt:formatNumber value = "${nMlfscPoint.selngAm / 10000000}" pattern = "#,##0"/></td>
										</tr>
										<tr>
											<td class="strong tac">합계</td>
											<td class="strong"><fmt:formatNumber value = "${mMlfscPoint.entrprsCo + nMlfscPoint.entrprsCo}" pattern = "#,##0"/></td>
											<td class="strong"><fmt:formatNumber value = "${(mMlfscPoint.ordtmLabrrCo + nMlfscPoint.ordtmLabrrCo) / 100}" pattern = "#,##0"/></td>
											<td class="strong"><fmt:formatNumber value = "${(mMlfscPoint.xportAmDollar + nMlfscPoint.xportAmDollar)/ 10000000}" pattern = "#,##0"/></td>
											<td class="strong"><fmt:formatNumber value = "${(mMlfscPoint.selngAm + nMlfscPoint.selngAm) / 10000000}" pattern = "#,##0"/></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>

						<!--// 그래프4-->
						<div class="graph">
							<h4>${latelyYear}년 지역별 기업 현황</h4>
							<div class="graph_map">지도 그래프
								<div style="position:absolute;"><div id="pieChart0" style="width:80px; height:101px; border:0px solid red; position:relative; left:230px;top:40px;"></div></div><!-- 강원 -->
								<div style="position:absolute;"><div id="pieChart1" style="width:80px; height:101px; border:0px solid red; position:relative; left:160px;top:100px;"></div></div> <!-- 경기 -->
								<div style="position:absolute;"><div id="pieChart2" style="width:80px; height:101px; border:0px solid red; position:relative; left:220px;top:350px;"></div></div> <!-- 강남 -->
								<div style="position:absolute;"><div id="pieChart3" style="width:80px; height:101px; border:0px solid red; position:relative; left:280px;top:220px;"></div></div> <!-- 경북 -->
								<div style="position:absolute;"><div id="pieChart4" style="width:80px; height:101px; border:0px solid red; position:relative; left:70px;top:365px;"></div></div> <!-- 광주 -->
								<div style="position:absolute;"><div id="pieChart5" style="width:80px; height:101px; border:0px solid red; position:relative; left:250px;top:290px;"></div></div> <!-- 대구 -->
								<div style="position:absolute;"><div id="pieChart6" style="width:80px; height:101px; border:0px solid red; position:relative; left:140px;top:240px;"></div></div> <!-- 대전 -->
								<div style="position:absolute;"><div id="pieChart7" style="width:80px; height:101px; border:0px solid red; position:relative; left:320px;top:380px;"></div></div> <!-- 부산 -->
								<div style="position:absolute;"><div id="pieChart8" style="width:80px; height:101px; border:0px solid red; position:relative; left:100px;top:55px;"></div></div> <!-- 서울 -->
								<div style="position:absolute;"><div id="pieChart9" style="width:80px; height:101px; border:0px solid red; position:relative; left:130px;top:200px;"></div></div> <!-- 세종 -->
								<div style="position:absolute;"><div id="pieChart10" style="width:80px; height:101px; border:0px solid red; position:relative; left:330px;top:305px;"></div></div> <!-- 울산 -->
								<div style="position:absolute;"><div id="pieChart11" style="width:80px; height:101px; border:0px solid red; position:relative; left:40px;top:105px;"></div></div> <!-- 인천 -->
								<div style="position:absolute;"><div id="pieChart12" style="width:80px; height:101px; border:0px solid red; position:relative; left:60px;top:430px;"></div></div> <!-- 전남 -->
								<div style="position:absolute;"><div id="pieChart13" style="width:80px; height:101px; border:0px solid red; position:relative; left:110px;top:300px;"></div></div> <!-- 전북 -->
								<div style="position:absolute;"><div id="pieChart14" style="width:80px; height:101px; border:0px solid red; position:relative; left:60px;top:530px;"></div></div> <!-- 제주 -->
								<div style="position:absolute;"><div id="pieChart15" style="width:80px; height:101px; border:0px solid red; position:relative; left:70px;top:220px;"></div></div> <!-- 충남 -->
								<div style="position:absolute;"><div id="pieChart16" style="width:80px; height:101px; border:0px solid red; position:relative; left:180px;top:160px;"></div></div> <!-- 충북 -->
							</div>
						</div>

							<div class="list2_zone map_list">
								<table>
									<caption>기본게시판 목록</caption>
									<colgroup>
										<col style="" />
										<col style="" />
										<col style="" />
										<col style="" />
									</colgroup>
									<thead>
										<tr>
											<th scope="col">구분</th>
											<th scope="col">제조업</th>
											<th scope="col">비제조업</th>
											<th scope="col">합계</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${areaPoint}" var="areaPoint" varStatus="status">
											<tr>
												<td class="tit">${areaPoint.abrv}</td>
												<td class="tar"><fmt:formatNumber value = "${areaPoint.productEntrprsCo}" pattern = "#,##0"/></td>
												<td class="tar"><fmt:formatNumber value = "${areaPoint.nEntrprsCo}" pattern = "#,##0"/></td>
												<td class="tar"><fmt:formatNumber value = "${areaPoint.productEntrprsCo + areaPoint.nEntrprsCo}" pattern = "#,##0"/></td>
											</tr>
										</c:forEach>
										<tr>
											<td class="strong tac">합계</td>
											<td class="strong tar"><fmt:formatNumber value = "${mMlfscPoint.entrprsCo}" pattern = "#,##0"/></td>
											<td class="strong tar"><fmt:formatNumber value = "${nMlfscPoint.entrprsCo }" pattern = "#,##0"/></td>
											<td class="strong tar"><fmt:formatNumber value = "${mMlfscPoint.entrprsCo + nMlfscPoint.entrprsCo }" pattern = "#,##0"/></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						</div>
						<!-- tabwrap // -->
					<!--sub contents //-->
					</div>
				<!-- 우측영역//-->
				</div>
			</div>
		</div>
		<!--content//-->
	</form>
</body>
</html>




