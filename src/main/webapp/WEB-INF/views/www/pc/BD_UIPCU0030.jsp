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
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,colorbox,flot, jqGrid, msgBox" />
<ap:jsTag type="tech" items="pc,ucm,util" />

<script type="text/javascript">
$(document).ready(function() {
	drawLineChart();
	// 기업 성장 추이 데이터 입력
	var holder = "#holder1"
	var d1 = [[ 2015-5, 869 ], [ 2015-4, 1050 ], [ 2015-3, 1556 ], [ 2015-2, 1675 ], [ 2015-1, 1331 ], [ 2015, 1488 ] ]
	var d2 = [[ 2015-5, 1318 ], [ 2015-4, 1693 ], [ 2015-3, 1880 ], [ 2015-2, 2171 ], [ 2015-1, 1648 ], [ 2015, 2070 ] ]
	var d3 = [[ 2015-5.1, 869 ], [ 2015-4.1, 1050 ], [ 2015-3.1, 1556 ], [ 2015-2.1, 1675 ], [ 2015-1.1, 1331 ], [ 2015-0.1, 1488 ] ]
	var d4 = [[ 2015-4.85, 1318 ], [ 2015-3.85, 1693 ], [ 2015-2.85, 1880 ], [ 2015-1.85, 2171 ], [ 2015-0.85, 1648 ], [ 2015+0.15, 2070 ] ]
	// 기업 성장 추이 그래프 그리기
	drawGraph(d1,d2,d3,d4,holder);
	
	// 기업 매출 추이 데이터 입력, 그래프 그리기
	holder = "#holder2"
	d1 = [[ 2015-5, 239.7 ], [ 2015-4, 260.6 ], [ 2015-3, 363.9 ], [ 2015-2, 375.2 ], [ 2015-1, 284.9 ], [ 2015, 357.2 ] ]
	d2 = [[ 2015-5, 151.4 ], [ 2015-4, 167.7 ], [ 2015-3, 231.2 ], [ 2015-2, 254.2 ], [ 2015-1, 198.7 ], [ 2015, 263.2 ] ]
	d3 = [[ 2015-5.1, 239.7 ], [ 2015-4.1, 260.6 ], [ 2015-3.1, 363.9 ], [ 2015-2.1, 375.2 ], [ 2015-1.1, 284.9 ], [ 2015-0.1, 357.2 ] ]
	d4 = [[ 2015-4.85, 151.4 ], [ 2015-3.85, 167.7 ], [ 2015-2.85, 231.2 ], [ 2015-1.85, 254.2 ], [ 2015-0.85, 198.7 ], [ 2015+0.15, 263.2 ] ]
	drawGraph(d1,d2,d3,d4,holder);
	
	// 기업 고용 추이 데이터 입력, 그래프 그리기
	holder = "#holder3"
	d1 = [[ 2015-5, 40.1 ], [ 2015-4, 42.5 ], [ 2015-3, 54.1 ], [ 2015-2, 58.0 ], [ 2015-1, 46.7 ], [ 2015, 56.8 ] ]
	d2 = [[ 2015-5, 48.8 ], [ 2015-4, 50.9 ], [ 2015-3, 52.5 ], [ 2015-2, 58.1 ], [ 2015-1, 43.2 ], [ 2015, 58.5 ] ]
	d3 = [[ 2015-5.1, 40.1 ], [ 2015-4.1, 42.5 ], [ 2015-3.1, 54.1 ], [ 2015-2.1, 58.0 ], [ 2015-1.1, 46.7 ], [ 2015-0.1, 56.8 ] ]
	d4 = [[ 2015-4.85, 48.8 ], [ 2015-3.85, 50.9 ], [ 2015-2.85, 52.5 ], [ 2015-1.85, 58.1 ], [ 2015-0.85, 43.2 ], [ 2015+0.15, 58.5 ] ]
	drawGraph(d1,d2,d3,d4,holder);
	
	// 업체명 확인
	$("#btn_search_ent").click(function() {
		$.colorbox({
			title : "기업 통계 포함기업 검색",
			href : "<c:url value='/PGPC0030.do?df_method_nm=statsIncEntrprsSearch' />",
			width : "900",
			height : "650",
			overlayClose : false,
			escKey : false,
			iframe : true
		});
	})
});

//툴팁 이벤트
function showTooltip(x, y, contents) {
	$('<div id = "tooltip" style = "z-index: 999;">' +contents +' </div>').css( {
        position: 'absolute',
        display: 'none',
        top: y  - 40,
        left: x ,
        border: '1px solid #fdd',
        padding: '2px',
        'background-color': '#fee',
        opacity: 0.80,
    }).appendTo("body").show();
}

// 데이터 요청
function popDataRequest() {
	if(Util.isEmpty(${UserInfo.userNo})) { 	
		$.msgBox({
            title: "Notice",
            content: "로그인 후 이용하실 수 있습니다.",
            type: "notice",
            buttons: [{ value: "회원가입" }, { value: "로그인"}, { value: "닫기"}],
            success: function (result) {
                if (result == "회원가입") {
                	$(location).attr('href', ${PUB_JOIN_URL});
                }
            	else if(result == "로그인"){
            		$(location).attr('href', ${PUB_LOGIN_URL});
            	}
            	else {
            		return;
            	}
			}
		});
	}
	else {
		var userNo = "${UserInfo.userNo}";
		var emplyrTy = "${UserInfo.emplyrTy}";

		$.colorbox({
			title : "데이터 요청",
			href : "PGPC0030.do?df_method_nm=getDataRequestPop&userNo="+userNo+"&emplyrTy="+emplyrTy,
			width : "70%",
			height : "60%",
			overlayClose : false,
			escKey : false,
			iframe : true
		});
	}
}

// 그래프 그리기
function drawGraph(d1,d2,d3,d4,holder) {
	var data = [
	            {
	            	label : "제조",    data : d1,
					bars: {
						barWidth : 0.2,
	            		show : true,
						order : 1,
						fillColor : "#1c8bd6"
	            	}, color : "#1c8bd6"
	            }, {
	            	label: "비제조",
	            	data : d2,
	            	bars: {
	            		fill : true,
	            		show : true,
						barWidth : 0.2,
						order: 2,
						fillColor : "#00bfd0"
	            	}, color: "#00bfd0"
	            }, {
	            	label: "제조",
	            	data : d3,
	            	lines: {
	    				lineWidth : 1,
	            		show: true,
	            		order : 3
	            	}, point : {
	            		show: true
	            	}, color : "#1c8bd6"
	            },
	            {
	            	label: "비제조",
	            	data : d4,
	            	lines: {
	    				lineWidth : 1,
	            		show: true,
	            		order : 4
	            	}, point : {
	            		show: true
	            	}, color: "#00bfd0"
	            }]

	var ticks = [[ 2010, "2010" ], [ 2011, "2011" ], [ 2012, "2012" ],
					[ 2013, "2013" ], [ 2014, "2014" ], [ 2015, "2015" ]];

	var options = {
			xaxis : {
				show : true,
				ticks : ticks,
				autoscaleMargin : .10
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
			},
			series: {
	            shadowSize: 1
	        }
	};
			$.plot($(holder), data, options);
			
			// 주요 통계 지표 툴팁 
			$(holder).bind("plothover", function(event, pos, item) {
						if (item) {
							if (previousPoint != item.datapoint) {
								previousPoint = item.datapoint;
								$("#tooltip").remove();

								var x = item.datapoint[0], y = item.datapoint[1];

								showTooltip(item.pageX, item.pageY, y + "("+ item.series.label + ")");
							}
						} else {
							$("#tooltip").remove();
							previousPoint = null;
						}
			});
}

function drawLineChart() {
	// 주요 통계 지표 그래프 옵션
	var options = {
		lines : {
			show : true,
			lineWidth : 5
		}, series : {
			shadowSize : 0
		}, points : {
			show : true
		}, xaxis : {
			tickDecimals : 0,
			tickSize : 1
		}, yaxis: {
			tickFormatter : function numberWithCommas(x) {
				return x.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ",");
			}
		},legend : {
			show : false
		}, grid : {
			hoverable : true,
			borderWidth : 0.2
		}, valueLabels : {
			show : true
		},
	};
	// 주요 통계 지표 데이터 입력
	var data = [{
		label : "기업수",
		data : [ [ 2010, 2187 ], [ 2011, 2743 ], [ 2012, 3436 ],
				[ 2013, 3846 ], [ 2014, 2979 ], [ 2015, 3558 ] ],
		color : "#014379"
	}, {
		label : "고용인력(천명)",
		data : [ [ 2010, 889 ], [ 2011, 934 ], [ 2012, 1067 ],
				[ 2013, 1161 ], [ 2014, 898 ], [ 2015, 1153 ] ],
		color : "#015ca5"
	}, {
		label : "매출액(천억원)",
		data : [ [ 2010, 3911 ], [ 2011, 4283 ], [ 2012, 5950 ],
				[ 2013, 6294 ], [ 2014, 4836 ], [ 2015, 6204 ] ],
		color : "#00bfd0"
	}]
	$.plot("#placeholder", data, options);

	// 주요 통계 지표 툴팁 
	$("#placeholder").bind("plothover", function(event, pos, item) {
				if (item) { if (previousPoint != item.datapoint) {
						previousPoint = item.datapoint;
						$("#tooltip").remove();
						var x = item.datapoint[0], y = item.datapoint[1];

						showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + x +"년 " + y);
					}
				} else {
			$("#tooltip").remove();
			previousPoint = null;
		}
	});
}

</script>
</head>
<body>
<form name="dataForm" id="dataForm" method="post">
    <ap:include page="param/defaultParam.jsp" />
    <ap:include page="param/dispParam.jsp" />
    <!--//content-->
    <div id="wrap" class="top_bg">
        <div class="contents">
            <!--//top img-->
            <div class="top_img menu01">Status and Statistics of High Potential Enterprise. 대한민국 기업이
                미래 글로벌 챔피언입니다.</div>
            <!--top img //-->
            <!--// lnb 페이지 타이틀-->
            <div class="title_page">
                <h2> <img src="<c:url value="/images/hi/title_m1.png" />" alt="기업이란?" /> </h2>
            </div>
            <!--lnb 페이지 타이틀//-->
            <div id ="go_container">
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
	                    	<li onclick="jsMoveMenu('1', '14', 'PGPC0020')"><span>현황</span></li><li class="on"><span>추이</span></li><li onclick="jsMoveMenu('1', '14', 'PGPC0040')"><span>실태조사</span></li>
		                </ul>
		            </div>
                
                    <!--// 그래프1-->
                    <div>
                        <h4>기업 주요 통계 지표</h4>
                        <div class="graph_area">
                            <div id="placeholder" style="width:600px; height: 250px;"></div>
                            <div class="remark">
                                <ul>
                                    <li class="remark1">기업수</li>
                                    <li class="remark2">고용인력</li>
                                    <li class="remark4">매출액</li>
                                </ul>
                            </div>
                        </div>
                        <div class="list_zone graph_list">
                            <table>
                                <caption>
                                기본게시판 목록
                                </caption>
                                <colgroup>
                                <col style="" />
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
                                        <th scope="col">2010</th>
                                        <th scope="col">2011</th>
                                        <th scope="col">2012</th>
                                        <th scope="col">2013</th>
                                        <th scope="col">2014</th>
                                        <th scope="col">2015*</th>
                                        <th scope="col">전년대비<br />증감율</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="tit">기업수 (개)</td>
                                        <td><fmt:formatNumber value = "2187" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "2743" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "3436" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "3846" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "2979" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "3558" pattern = "#,##0"/></td>
                                        <td>19.4%</td>
                                    </tr>
                                    <tr>
                                        <td class="tit">고용인력 (천명)</td>
                                        <td><fmt:formatNumber value = "889" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "934" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "1067" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "1161" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "898" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "1153" pattern = "#,##0"/></td>
                                        <td>28.4%</td>
                                    </tr>
                                    <tr>
                                        <td class="tit">매출액 (천억원)</td>
                                        <td><fmt:formatNumber value = "3911" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "4283" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "5950" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "6294" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "4836" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "6204" pattern = "#,##0"/></td>
                                        <td>28.3%</td>
                                    </tr>
                                </tbody>
                            </table>
                            <p style="margin-top:10px;">* '16년 9월 상호출자제한기업 집단 기준변경에 따라 기업으로 편입된 기업수를 반영</p>
                        </div>
                    </div>
                    <!--// 그래프2-->
                    <div class="graph">
                        <h4> 업종별 기업 성장 추이<span>[개수]</span> </h4>
                        <div class="graph_area">
                            <div id="holder1" style="width:600px; height: 200px;"></div>
                            <div class="remark">
                                <ul>
                                    <li class="remark2">제조업</li>
                                    <li class="remark3">비제조업</li>
                                </ul>
                            </div>
                        </div>
                        <div class="list_zone graph_list">
                            <table>
                                <caption>
                                기본게시판 목록
                                </caption>
                                <colgroup>
                                <col style="" />
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
                                        <th scope="col">2010</th>
                                        <th scope="col">2011</th>
                                        <th scope="col">2012</th>
                                        <th scope="col">2013</th>
                                        <th scope="col">2014</th>
                                        <th scope="col">2015</th>
                                        <th scope="col">전년대비<br />증감율</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="tit">제조업</td>
                                        <td><fmt:formatNumber value = "869" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "1050" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "1556" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "1675" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "1331" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "1488" pattern = "#,##0"/></td>
                                        <td>11.8%</td>
                                    </tr>
                                    <tr>
                                        <td class="tit">비제조업</td>
                                        <td><fmt:formatNumber value = "1318" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "1693" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "1880" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "2171" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "1648" pattern = "#,##0"/></td>
                                        <td><fmt:formatNumber value = "2070" pattern = "#,##0"/></td>
                                        <td>25.6%</td>
                                    </tr>
                                    <tr>
                                        <td class="strong tac">합계</td>
                                        <td class="strong"><fmt:formatNumber value = "2187" pattern = "#,##0"/></td>
                                        <td class="strong"><fmt:formatNumber value = "2743" pattern = "#,##0"/></td>
                                        <td class="strong"><fmt:formatNumber value = "3436" pattern = "#,##0"/></td>
                                        <td class="strong"><fmt:formatNumber value = "3846" pattern = "#,##0"/></td>
                                        <td class="strong"><fmt:formatNumber value = "2979" pattern = "#,##0"/></td>
                                        <td class="strong"><fmt:formatNumber value = "3558" pattern = "#,##0"/></td>
                                        <td class="strong">19.4%</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <!--// 그래프3-->
                    <div class="graph">
                        <h4> 업종별 기업 매출 추이<span>[조원]</span> </h4>
                        <div class="graph_area">
                            <div id="holder2" style="width:600px; height: 300px;"></div>
                            <div class="remark">
                                <ul>
                                    <li class="remark2">제조업</li>
                                    <li class="remark3">비제조업</li>
                                </ul>
                            </div>
                        </div>
                        <div class="list_zone graph_list">
                            <table>
                                <caption>
                                기본게시판 목록
                                </caption>
                                <colgroup>
                                <col style="" />
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
                                        <th scope="col">2010</th>
                                        <th scope="col">2011</th>
                                        <th scope="col">2012</th>
                                        <th scope="col">2013</th>
                                        <th scope="col">2014</th>
                                        <th scope="col">2015</th>
                                        <th scope="col">전년대비<br />증감율</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="tit">제조업</td>
                                        <td><fmt:formatNumber value = "239.7" pattern = "#,##0.#"/></td>
                                        <td><fmt:formatNumber value = "260.6" pattern = "#,##0.#"/></td>
                                        <td><fmt:formatNumber value = "363.9" pattern = "#,##0.#"/></td>
                                        <td><fmt:formatNumber value = "375.2" pattern = "#,##0.#"/></td>
                                        <td><fmt:formatNumber value = "284.9" pattern = "#,##0.#"/></td>
                                        <td><fmt:formatNumber value = "357.2" pattern = "#,##0.#"/></td>
                                        <td>25.4%</td>
                                    </tr>
                                    <tr>
                                        <td class="tit">비제조업</td>
                                        <td><fmt:formatNumber value = "151.4" pattern = "#,##0.#"/></td>
                                        <td><fmt:formatNumber value = "167.7" pattern = "#,##0.#"/></td>
                                        <td><fmt:formatNumber value = "231.2" pattern = "#,##0.#"/></td>
                                        <td><fmt:formatNumber value = "254.2" pattern = "#,##0.#"/></td>
                                        <td><fmt:formatNumber value = "198.7" pattern = "#,##0.#"/></td>
                                        <td><fmt:formatNumber value = "263.2" pattern = "#,##0.#"/></td>
                                        <td>32.5%</td>
                                    </tr>
                                    <tr>
                                        <td class="strong tac">합계</td>
                                        <td class="strong"><fmt:formatNumber value = "391.1" pattern = "#,##0.#"/></td>
                                        <td class="strong"><fmt:formatNumber value = "428.3" pattern = "#,##0.#"/></td>
                                        <td class="strong"><fmt:formatNumber value = "595.1" pattern = "#,##0.#"/></td>
                                        <td class="strong"><fmt:formatNumber value = "629.4" pattern = "#,##0.#"/></td>
                                        <td class="strong"><fmt:formatNumber value = "483.6" pattern = "#,##0.#"/></td>
                                        <td class="strong"><fmt:formatNumber value = "620.4" pattern = "#,##0.#"/></td>
                                        <td class="strong">28.3%</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <!--// 그래프5-->
                    <div class="graph">
                        <h4> 업종별 기업 고용 추이<span>[만명]</span> </h4>
                        <div class="graph_area">
                            <div id="holder3" style="width:600px; height: 300px;"></div>
                            <div class="remark">
                                <ul>
                                    <li class="remark3">제조업</li>
                                    <li class="remark4">비제조업</li>
                                </ul>
                            </div>
                        </div>
                        <div class="list_zone graph_list">
                            <table>
                                <caption>
                                기본게시판 목록
                                </caption>
                                <colgroup>
                                <col style="" />
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
                                        <th scope="col">2010</th>
                                        <th scope="col">2011</th>
                                        <th scope="col">2012</th>
                                        <th scope="col">2013</th>
                                        <th scope="col">2014</th>
                                        <th scope="col">2015</th>
                                        <th scope="col">전년대비<br />증감율</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="tit">제조업</td>
                                        <td><fmt:formatNumber value = "40.1" pattern = "#,##0.#"/></td>
                                        <td><fmt:formatNumber value = "42.5" pattern = "#,##0.#"/></td>
                                        <td><fmt:formatNumber value = "54.1" pattern = "#,##0.#"/></td>
                                        <td><fmt:formatNumber value = "58.0" pattern = "#,##0.#"/></td>
                                        <td><fmt:formatNumber value = "46.7" pattern = "#,##0.#"/></td>
                                        <td><fmt:formatNumber value = "56.8" pattern = "#,##0.#"/></td>
                                        <td>21.6%</td>
                                    </tr>
                                    <tr>
                                        <td class="tit">비제조업</td>
                                        <td><fmt:formatNumber value = "48.8" pattern = "#,##0.#"/></td>
                                        <td><fmt:formatNumber value = "50.9" pattern = "#,##0.#"/></td>
                                        <td><fmt:formatNumber value = "52.5" pattern = "#,##0.#"/></td>
                                        <td><fmt:formatNumber value = "58.1" pattern = "#,##0.#"/></td>
                                        <td><fmt:formatNumber value = "43.2" pattern = "#,##0.#"/></td>
                                        <td><fmt:formatNumber value = "58.5" pattern = "#,##0.#"/></td>
                                        <td>35.4%</td>
                                    </tr>
                                    <tr>
                                        <td class="strong tac">합계</td>
                                        <td class="strong"><fmt:formatNumber value = "88.9" pattern = "#,##0.#"/></td>
                                        <td class="strong"><fmt:formatNumber value = "93.4" pattern = "#,##0.#"/></td>
                                        <td class="strong"><fmt:formatNumber value = "106.6" pattern = "#,##0.#"/></td>
                                        <td class="strong"><fmt:formatNumber value = "116.1" pattern = "#,##0.#"/></td>
                                        <td class="strong"><fmt:formatNumber value = "89.9" pattern = "#,##0.#"/></td>
                                        <td class="strong"><fmt:formatNumber value = "115.3" pattern = "#,##0.#"/></td>
                                        <td class="strong">28.3%</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <!--//데이터요청-->
                   <!--  <div class="link_data">
						<ul class="data">
							<li>업체명 확인을 위해서는 버튼을 클릭해주세요.</li>
						</ul>
						<div class="btn_data">
							<a class="btn_data_blue" href="#none" id="btn_search_ent" ><span>업체명확인</span></a>
						</div>
					</div> -->
					
                    <!-- <div class="link_data">
                        <ul>
                            <li>기업 관련 데이터가 필요하시면 요청해 보세요.</li>
                            <li>요청 내용을 확인하고, 가능한 데이터를 공유해 드립니다.</li>
                        </ul>
                        <div class="btn_data"><a class="btn_data_blue" href="#none" onClick="popDataRequest();"><span>데이터 요청</span></a></div>
                    </div> -->
                    <!--데이터요청//-->
                </div>                
                <!-- tabwrap -->
            </div>
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