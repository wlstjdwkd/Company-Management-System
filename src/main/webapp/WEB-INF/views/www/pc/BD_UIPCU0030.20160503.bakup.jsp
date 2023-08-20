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
	var d1 = [[ ${latelyYear-4}, ${yMlfscPointList[0].entrprsCo} ], [ ${latelyYear-3}, ${yMlfscPointList[1].entrprsCo} ], [ ${latelyYear-2}, ${yMlfscPointList[2].entrprsCo} ], [ ${latelyYear-1}, ${yMlfscPointList[3].entrprsCo} ], [ ${latelyYear}, ${yMlfscPointList[4].entrprsCo} ] ]	
	var d2 = [[ ${latelyYear-4}, ${nMlfscPointList[0].entrprsCo} ], [ ${latelyYear-3}, ${nMlfscPointList[1].entrprsCo} ], [ ${latelyYear-2}, ${nMlfscPointList[2].entrprsCo} ], [ ${latelyYear-1}, ${nMlfscPointList[3].entrprsCo} ], [ ${latelyYear}, ${nMlfscPointList[4].entrprsCo} ]]
	var d3 = [[ ${latelyYear-4.1}, ${yMlfscPointList[0].entrprsCo} ], [ ${latelyYear-3.1}, ${yMlfscPointList[1].entrprsCo} ], [ ${latelyYear-2.1}, ${yMlfscPointList[2].entrprsCo} ], [ ${latelyYear-1.1}, ${yMlfscPointList[3].entrprsCo} ], [ ${latelyYear-0.1}, ${yMlfscPointList[4].entrprsCo} ] ]	
	var d4 = [[ ${latelyYear-3.85}, ${nMlfscPointList[0].entrprsCo} ], [ ${latelyYear-2.85}, ${nMlfscPointList[1].entrprsCo} ], [ ${latelyYear-1.85}, ${nMlfscPointList[2].entrprsCo} ], [ ${latelyYear-0.85}, ${nMlfscPointList[3].entrprsCo} ], [ ${latelyYear+0.15}, ${nMlfscPointList[4].entrprsCo} ]]
	// 기업 성장 추이 그래프 그리기
	drawGraph(d1,d2,d3,d4,holder);
	
	// 기업 매출 추이 데이터 입력, 그래프 그리기
	holder = "#holder2"
	d1 = [[ ${latelyYear-4}, ${yMlfscPointList[0].selngAm/1000000000} ], [ ${latelyYear-3}, ${yMlfscPointList[1].selngAm/1000000000} ], [ ${latelyYear-2}, ${yMlfscPointList[2].selngAm/1000000000} ], [ ${latelyYear-1}, ${yMlfscPointList[3].selngAm/1000000000} ], [ ${latelyYear}, ${yMlfscPointList[4].selngAm/1000000000} ] ]	
	d2 = [[ ${latelyYear-4}, ${nMlfscPointList[0].selngAm/1000000000} ], [ ${latelyYear-3}, ${nMlfscPointList[1].selngAm/1000000000} ], [ ${latelyYear-2}, ${nMlfscPointList[2].selngAm/1000000000} ], [ ${latelyYear-1}, ${nMlfscPointList[3].selngAm/1000000000} ], [ ${latelyYear}, ${nMlfscPointList[4].selngAm/1000000000} ]]
	d3 = [[ ${latelyYear-4.1}, ${yMlfscPointList[0].selngAm/1000000000} ], [ ${latelyYear-3.1}, ${yMlfscPointList[1].selngAm/1000000000} ], [ ${latelyYear-2.1}, ${yMlfscPointList[2].selngAm/1000000000} ], [ ${latelyYear-1.1}, ${yMlfscPointList[3].selngAm/1000000000} ], [ ${latelyYear-0.1}, ${yMlfscPointList[4].selngAm/1000000000} ] ]	
	d4 = [[ ${latelyYear-3.85}, ${nMlfscPointList[0].selngAm/1000000000} ], [ ${latelyYear-2.85}, ${nMlfscPointList[1].selngAm/1000000000} ], [ ${latelyYear-1.85}, ${nMlfscPointList[2].selngAm/1000000000} ], [ ${latelyYear-0.85}, ${nMlfscPointList[3].selngAm/1000000000} ], [ ${latelyYear+0.15}, ${nMlfscPointList[4].selngAm/1000000000} ]]
	drawGraph(d1,d2,d3,d4,holder);
	
	// 기업 수출 추이 데이터 입력, 그래프 그리기
	holder = "#holder3"
	d1 = [[ ${latelyYear-4}, ${yMlfscPointList[0].xportAmDollar/100000} ], [ ${latelyYear-3}, ${yMlfscPointList[1].xportAmDollar/100000} ], [ ${latelyYear-2}, ${yMlfscPointList[2].xportAmDollar/100000} ], [ ${latelyYear-1}, ${yMlfscPointList[3].xportAmDollar/100000} ], [ ${latelyYear}, ${yMlfscPointList[4].xportAmDollar/100000} ] ]	
	d2 = [[ ${latelyYear-4}, ${nMlfscPointList[0].xportAmDollar/100000} ], [ ${latelyYear-3}, ${nMlfscPointList[1].xportAmDollar/100000} ], [ ${latelyYear-2}, ${nMlfscPointList[2].xportAmDollar/100000} ], [ ${latelyYear-1}, ${nMlfscPointList[3].xportAmDollar/100000} ], [ ${latelyYear}, ${nMlfscPointList[4].xportAmDollar/100000} ]]
	d3 = [[ ${latelyYear-4.1}, ${yMlfscPointList[0].xportAmDollar/100000} ], [ ${latelyYear-3.1}, ${yMlfscPointList[1].xportAmDollar/100000} ], [ ${latelyYear-2.1}, ${yMlfscPointList[2].xportAmDollar/100000} ], [ ${latelyYear-1.1}, ${yMlfscPointList[3].xportAmDollar/100000} ], [ ${latelyYear-0.1}, ${yMlfscPointList[4].xportAmDollar/100000} ] ]	
	d4 = [[ ${latelyYear-3.85}, ${nMlfscPointList[0].xportAmDollar/100000} ], [ ${latelyYear-2.85}, ${nMlfscPointList[1].xportAmDollar/100000} ], [ ${latelyYear-1.85}, ${nMlfscPointList[2].xportAmDollar/100000} ], [ ${latelyYear-0.85}, ${nMlfscPointList[3].xportAmDollar/100000} ], [ ${latelyYear+0.15}, ${nMlfscPointList[4].xportAmDollar/100000} ]]
	drawGraph(d1,d2,d3,d4,holder);

	// 기업 고용 추이 데이터 입력, 그래프 그리기
	holder = "#holder4"
	d1 = [[ ${latelyYear-4}, ${yMlfscPointList[0].ordtmLabrrCo/10000} ], [ ${latelyYear-3}, ${yMlfscPointList[1].ordtmLabrrCo/10000} ], [ ${latelyYear-2}, ${yMlfscPointList[2].ordtmLabrrCo/10000} ], [ ${latelyYear-1}, ${yMlfscPointList[3].ordtmLabrrCo/10000} ], [ ${latelyYear}, ${yMlfscPointList[4].ordtmLabrrCo/10000} ] ]	
	d2 = [[ ${latelyYear-4}, ${nMlfscPointList[0].ordtmLabrrCo/10000} ], [ ${latelyYear-3}, ${nMlfscPointList[1].ordtmLabrrCo/10000} ], [ ${latelyYear-2}, ${nMlfscPointList[2].ordtmLabrrCo/10000} ], [ ${latelyYear-1}, ${nMlfscPointList[3].ordtmLabrrCo/10000} ], [ ${latelyYear}, ${nMlfscPointList[4].ordtmLabrrCo/10000} ]]
	d3 = [[ ${latelyYear-4.1}, ${yMlfscPointList[0].ordtmLabrrCo/10000} ], [ ${latelyYear-3.1}, ${yMlfscPointList[1].ordtmLabrrCo/10000} ], [ ${latelyYear-2.1}, ${yMlfscPointList[2].ordtmLabrrCo/10000} ], [ ${latelyYear-1.1}, ${yMlfscPointList[3].ordtmLabrrCo/10000} ], [ ${latelyYear-0.1}, ${yMlfscPointList[4].ordtmLabrrCo/10000} ] ]	
	d4 = [[ ${latelyYear-3.85}, ${nMlfscPointList[0].ordtmLabrrCo/10000} ], [ ${latelyYear-2.85}, ${nMlfscPointList[1].ordtmLabrrCo/10000} ], [ ${latelyYear-1.85}, ${nMlfscPointList[2].ordtmLabrrCo/10000} ], [ ${latelyYear-0.85}, ${nMlfscPointList[3].ordtmLabrrCo/10000} ], [ ${latelyYear+0.15}, ${nMlfscPointList[4].ordtmLabrrCo/10000} ]]
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

	var ticks = [[ ${latelyYear-4}, "${latelyYear-4}" ], [ ${latelyYear-3}, "${latelyYear-3}" ], [ ${latelyYear-2}, "${latelyYear-2}" ],
					[ ${latelyYear-1}, "${latelyYear-1}" ], [ ${latelyYear}, "${latelyYear}" ]];

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
		data : [ [ ${latelyYear-4}, ${mainPointList[0].entrprsCo} ], [ ${latelyYear-3}, ${mainPointList[1].entrprsCo} ], [ ${latelyYear-2}, ${mainPointList[2].entrprsCo} ],
				[ ${latelyYear-1}, ${mainPointList[3].entrprsCo} ], [ ${latelyYear}, ${mainPointList[4].entrprsCo} ] ],
		color : "#014379"
	}, {
		label : "고용인력(천명)",
		data : [ [ ${latelyYear-4}, ${mainPointList[0].ordtmLabrrCo/1000} ], [ ${latelyYear-3}, ${mainPointList[1].ordtmLabrrCo/1000} ], [ ${latelyYear-2}, ${mainPointList[2].ordtmLabrrCo/1000} ], [ ${latelyYear-1}, ${mainPointList[3].ordtmLabrrCo/1000} ], 
				[ ${latelyYear}, ${mainPointList[4].ordtmLabrrCo/1000} ] ],
		color : "#015ca5"
	}, {
		label : "수출액(억달러)",
		data : [ [ ${latelyYear-4}, ${mainPointList[0].xportAmDollar/100000000} ], [ ${latelyYear-3}, ${mainPointList[1].xportAmDollar/100000000} ], [ ${latelyYear-2}, ${mainPointList[2].xportAmDollar/100000000} ],
				[ ${latelyYear-1}, ${mainPointList[3].xportAmDollar/100000000} ], [ ${latelyYear}, ${mainPointList[4].xportAmDollar/100000000} ] ],
		color : "#1c8bd6"
	}, {
		label : "매출액(천억원)",
		data : [ [ ${latelyYear-4}, ${mainPointList[0].selngAm/100000000} ], [ ${latelyYear-3}, ${mainPointList[1].selngAm/100000000} ], [ ${latelyYear-2}, ${mainPointList[2].selngAm/100000000} ],
				[ ${latelyYear-1}, ${mainPointList[3].selngAm/100000000} ], [ ${latelyYear}, ${mainPointList[4].selngAm/100000000} ] ],
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
                <h2> <img src="<c:url value="/images/pc/title_m1.png" />" alt="기업현황" /> </h2>
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
	                    	<li onclick="jsMoveMenu('5', '14', 'PGPC0020')"><span>현황</span></li><li class="on"><span>추이</span></li>
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
                                    <li class="remark3">수출액</li>
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
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">구분</th>
                                        <c:forEach begin="${latelyYear - 4}" end="${latelyYear}" step="1" var="status">
                                            <th scope="col">${status}</th>
                                        </c:forEach>
                                        <th scope="col">비고 [최근 2년 대비]</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="tit">기업수 (개)</td>
                                        <c:forEach items="${mainPointList}" var="mainPoint" varStatus="status">
                                            <td><fmt:formatNumber value = "${mainPoint.entrprsCo }" pattern = "#,##0"/></td>
                                        </c:forEach>
                                        <td><fmt:formatNumber value = "${mainPointList[4].entrprsCo-mainPointList[3].entrprsCo}" pattern = "#,##0"/>
                                            (${((mainPointList[4].entrprsCo-mainPointList[3].entrprsCo)*100) / mainPointList[3].entrprsCo}%)</td>
                                    </tr>
                                    <tr>
                                        <td class="tit">고용인력 (천명)</td>
                                        <c:forEach items="${mainPointList}" var="mainPoint" varStatus="status">
                                            <td><fmt:formatNumber value = "${mainPoint.ordtmLabrrCo / 1000}" pattern = "#,##0"/></td>
                                        </c:forEach>
                                        <td><fmt:formatNumber value = "${(mainPointList[4].ordtmLabrrCo/ 1000) - (mainPointList[3].ordtmLabrrCo/ 1000)}" pattern = "#,##0"/>
                                            (${((mainPointList[4].ordtmLabrrCo-mainPointList[3].ordtmLabrrCo)*100) / mainPointList[3].ordtmLabrrCo}%)</td>
                                    </tr>
                                    <tr>
                                        <td class="tit">수출액 (억달러)</td>
                                        <c:forEach items="${mainPointList}" var="mainPoint" varStatus="status">
                                            <td><fmt:formatNumber value = "${mainPoint.xportAmDollar / 100000000 }" pattern = "#,##0"/></td>
                                        </c:forEach>
                                        <td><fmt:formatNumber value = "${(mainPointList[4].xportAmDollar / 100000000) - (mainPointList[3].xportAmDollar / 100000000)}" pattern = "#,##0"/>
                                            (${((mainPointList[4].xportAmDollar-mainPointList[3].xportAmDollar)*100) / mainPointList[3].xportAmDollar}%)</td>
                                    </tr>
                                    <tr>
                                        <td class="tit">매출액 (천억원)</td>
                                        <c:forEach items="${mainPointList}" var="mainPoint" varStatus="status">
                                            <td><fmt:formatNumber value = "${mainPoint.selngAm / 100000000}" pattern = "#,##0"/></td>
                                        </c:forEach>
                                        <td><fmt:formatNumber value = "${(mainPointList[4].selngAm/100000000)-(mainPointList[3].selngAm/100000000)}" pattern = "#,##0"/>
                                            (${((mainPointList[4].selngAm-mainPointList[3].selngAm)*100) / mainPointList[3].selngAm}%)</td>
                                    </tr>
                                </tbody>
                            </table>
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
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">구분</th>
                                        <c:forEach begin="${latelyYear - 4}" end="${latelyYear}" step="1" var="status">
                                            <th scope="col">${status}</th>
                                        </c:forEach>
                                        <th scope="col">비고 [최근 2년 대비]</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="tit">제조업</td>
                                        <c:forEach items="${yMlfscPointList}" var="yMlfscPoint" varStatus="status">
                                            <td><fmt:formatNumber value = "${yMlfscPoint.entrprsCo}" pattern = "#,##0"/></td>
                                        </c:forEach>
                                        <td><fmt:formatNumber value = "${yMlfscPointList[4].entrprsCo-yMlfscPointList[3].entrprsCo}" pattern = "#,##0"/>
                                            (${((yMlfscPointList[4].entrprsCo-yMlfscPointList[3].entrprsCo)*100) / yMlfscPointList[3].entrprsCo}%)</td>
                                    </tr>
                                    <tr>
                                        <td class="tit">비제조업</td>
                                        <c:forEach items="${nMlfscPointList}" var="nMlfscPoint" varStatus="status">
                                            <td><fmt:formatNumber value = "${nMlfscPoint.entrprsCo}" pattern = "#,##0"/></td>
                                        </c:forEach>
                                        <td><fmt:formatNumber value = "${nMlfscPointList[4].entrprsCo-nMlfscPointList[3].entrprsCo}" pattern = "#,##0"/>
                                            (${((nMlfscPointList[4].entrprsCo-nMlfscPointList[3].entrprsCo)*100) / nMlfscPointList[3].entrprsCo}%)</td>
                                    </tr>
                                    <tr>
                                        <td class="strong tac">합계</td>
                                        <c:forEach items="${mainPointList}" var="mainPoint" varStatus="status">
                                            <td class="strong"><fmt:formatNumber value = "${mainPoint.entrprsCo }" pattern = "#,##0"/></td>
                                        </c:forEach>
                                        <td class="strong"><fmt:formatNumber value = "${mainPointList[4].entrprsCo-mainPointList[3].entrprsCo}" pattern = "#,##0"/>
                                            (${((mainPointList[4].entrprsCo-mainPointList[3].entrprsCo)*100) / mainPointList[3].entrprsCo}%)</td>
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
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">구분</th>
                                        <c:forEach begin="${latelyYear - 4}" end="${latelyYear}" step="1" var="status">
                                            <th scope="col">${status}</th>
                                        </c:forEach>
                                        <th scope="col">비고 [최근 2년 대비]</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="tit">제조업</td>
                                        <c:forEach items="${yMlfscPointList}" var="yMlfscPoint" varStatus="status">
                                            <td><fmt:formatNumber value = "${yMlfscPoint.selngAm / 1000000000}" pattern = "#,##0"/></td>
                                        </c:forEach>
                                        <td><fmt:formatNumber value = "${(yMlfscPointList[4].selngAm/1000000000)-(yMlfscPointList[3].selngAm/1000000000)}" pattern = "#,##0"/>
                                            (${((yMlfscPointList[4].selngAm-yMlfscPointList[3].selngAm)*100) / yMlfscPointList[3].selngAm}%)</td>
                                    </tr>
                                    <tr>
                                        <td class="tit">비제조업</td>
                                        <c:forEach items="${nMlfscPointList}" var="nMlfscPoint" varStatus="status">
                                            <td><fmt:formatNumber value = "${nMlfscPoint.selngAm / 1000000000}" pattern = "#,##0"/></td>
                                        </c:forEach>
                                        <td><fmt:formatNumber value = "${(nMlfscPointList[4].selngAm/1000000000)-(nMlfscPointList[3].selngAm/1000000000)}" pattern = "#,##0"/>
                                            (${((nMlfscPointList[4].selngAm-nMlfscPointList[3].selngAm)*100) / nMlfscPointList[3].selngAm}%)</td>
                                    </tr>
                                    <tr>
                                        <td class="strong tac">합계</td>
                                        <c:forEach items="${mainPointList}" var="mainPoint" varStatus="status">
                                            <td class="strong"><fmt:formatNumber value = "${mainPoint.selngAm / 1000000000}" pattern = "#,##0"/></td>
                                        </c:forEach>
                                        <td class="strong"><fmt:formatNumber value = "${(mainPointList[4].selngAm/1000000000)-(mainPointList[3].selngAm/1000000000)}" pattern = "#,##0"/>
                                            (${((mainPointList[4].selngAm-mainPointList[3].selngAm)*100) / mainPointList[3].selngAm}%)</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <!--// 그래프4-->
                    <div class="graph">
                        <h4> 업종별 기업 수출 추이<span>[억불]</span> </h4>
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
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">구분</th>
                                        <c:forEach begin="${latelyYear - 4}" end="${latelyYear}" step="1" var="status">
                                            <th scope="col">${status}</th>
                                        </c:forEach>
                                        <th scope="col">비고 [최근 2년 대비]</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="tit">제조업</td>
                                        <c:forEach items="${yMlfscPointList}" var="yMlfscPoint" varStatus="status">
                                            <td><fmt:formatNumber value = "${yMlfscPoint.xportAmDollar / 100000000}" pattern = "#,##0"/></td>
                                        </c:forEach>
                                        <td><fmt:formatNumber value = "${(yMlfscPointList[4].xportAmDollar/100000000)-(yMlfscPointList[3].xportAmDollar/100000000)}" pattern = "#,##0"/>
                                            (${((yMlfscPointList[4].xportAmDollar-yMlfscPointList[3].xportAmDollar)*100) / yMlfscPointList[3].xportAmDollar}%)</td>
                                    </tr>
                                    <tr>
                                        <td class="tit">비제조업</td>
                                        <c:forEach items="${nMlfscPointList}" var="nMlfscPoint" varStatus="status">
                                            <td><fmt:formatNumber value = "${nMlfscPoint.xportAmDollar / 100000000}" pattern = "#,##0"/></td>
                                        </c:forEach>
                                        <td><fmt:formatNumber value = "${(nMlfscPointList[4].xportAmDollar/100000000)-(nMlfscPointList[3].xportAmDollar/100000000)}" pattern = "#,##0"/>
                                            (${((nMlfscPointList[4].xportAmDollar-nMlfscPointList[3].xportAmDollar)*100) / nMlfscPointList[3].xportAmDollar}%)</td>
                                    </tr>
                                    <tr>
                                        <td class="strong tac">합계</td>
                                        <c:forEach items="${mainPointList}" var="mainPoint" varStatus="status">
                                            <td class="strong"><fmt:formatNumber value = "${mainPoint.xportAmDollar / 100000000}" pattern = "#,##0"/></td>
                                        </c:forEach>
                                        <td class="strong"><fmt:formatNumber value = "${(mainPointList[4].xportAmDollar/100000000)-(mainPointList[3].xportAmDollar/100000000)}" pattern = "#,##0"/>
                                            (${((mainPointList[4].xportAmDollar-mainPointList[3].xportAmDollar)*100) / mainPointList[3].xportAmDollar}%)</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <!--// 그래프5-->
                    <div class="graph">
                        <h4> 업종별 기업 고용 추이<span>[만명]</span> </h4>
                        <div class="graph_area">
                            <div id="holder4" style="width:600px; height: 300px;"></div>
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
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">구분</th>
                                        <c:forEach begin="${latelyYear - 4}" end="${latelyYear}" step="1" var="status">
                                            <th scope="col">${status}</th>
                                        </c:forEach>
                                        <th scope="col">비고 [최근 2년 대비]</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="tit">제조업</td>
                                        <c:forEach items="${yMlfscPointList}" var="yMlfscPoint" varStatus="status">
                                            <td><fmt:formatNumber value = "${yMlfscPoint.ordtmLabrrCo / 10000}" pattern = "#,##0"/></td>
                                        </c:forEach>
                                        <td><fmt:formatNumber value = "${(yMlfscPointList[4].ordtmLabrrCo/10000)-(yMlfscPointList[3].ordtmLabrrCo/10000)}" pattern = "#,##0"/>
                                            (${((yMlfscPointList[4].ordtmLabrrCo-yMlfscPointList[3].ordtmLabrrCo)*100) / yMlfscPointList[3].ordtmLabrrCo}%)</td>
                                    </tr>
                                    <tr>
                                        <td class="tit">비제조업</td>
                                        <c:forEach items="${nMlfscPointList}" var="nMlfscPoint" varStatus="status">
                                            <td><fmt:formatNumber value = "${nMlfscPoint.ordtmLabrrCo / 10000}" pattern = "#,##0"/></td>
                                        </c:forEach>
                                        <td><fmt:formatNumber value = "${(nMlfscPointList[4].ordtmLabrrCo/10000)-(nMlfscPointList[3].ordtmLabrrCo/10000)}" pattern = "#,##0"/>
                                            (${((nMlfscPointList[4].ordtmLabrrCo-nMlfscPointList[3].ordtmLabrrCo)*100) / nMlfscPointList[3].ordtmLabrrCo}%)</td>
                                    </tr>
                                    <tr>
                                        <td class="strong tac">합계</td>
                                        <c:forEach items="${mainPointList}" var="mainPoint" varStatus="status">
                                            <td class="strong"><fmt:formatNumber value = "${mainPoint.ordtmLabrrCo / 10000}" pattern = "#,##0"/></td>
                                        </c:forEach>
                                        <td class="strong"><fmt:formatNumber value = "${(mainPointList[4].ordtmLabrrCo/10000)-(mainPointList[3].ordtmLabrrCo/10000)}" pattern = "#,##0"/>
                                            (${((mainPointList[4].ordtmLabrrCo-mainPointList[3].ordtmLabrrCo)*100) / mainPointList[3].ordtmLabrrCo}%)</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <!--//데이터요청-->
                    <div class="link_data">
						<ul class="data">
							<li>업체명 확인을 위해서는 버튼을 클릭해주세요.</li>
						</ul>
						<div class="btn_data">
							<a class="btn_data_blue" href="#none" id="btn_search_ent" ><span>업체명확인</span></a>
						</div>
					</div>
					
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
    <!--content//-->
</form>
</body>
</html>