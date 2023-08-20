<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery,cookie,flot,form,jqGrid,noticetimer,tools,ui,validate" />
<ap:jsTag type="tech" items="util,acm,pc,um" />

<script  type="text/javascript"  src="/script/jquery/flot/jquery.flot.stack.js"></script>
<script type="text/javascript" src="/script/jquery/flot/excanvas.min.js"></script>

<script type="text/javascript">

$(document).ready(function(){
	//메인_Tab
	tabwrap();
	
	// 백분율 그래프 실행
	drawPercentChart();
});
	
// 백분율 막대 그래프
function drawPercentChart() {
	
	var ms_data = [ {
		label : "대기업",
		data : [
				['${entprsList[0].LTRS_VALUE}', 17.5 ],
		        ['${entprsList[1].LTRS_VALUE}', 16.5 ],
		        ['${entprsList[2].LTRS_VALUE}', 15.5 ],
		        ['${entprsList[3].LTRS_VALUE}', 14.5 ],
		        ['${entprsList[4].LTRS_VALUE}', 13.5 ], 
		        ['${entprsList[5].LTRS_VALUE}', 12.5 ],
		        ['${entprsList[6].LTRS_VALUE}', 11.5 ],
		        ['${entprsList[7].LTRS_VALUE}', 10.5 ], 
		        ['${entprsList[8].LTRS_VALUE}', 9.5 ],
		        ['${entprsList[9].LTRS_VALUE}', 8.5 ],
		        ['${entprsList[10].LTRS_VALUE}', 7.5 ], 
		        ['${entprsList[11].LTRS_VALUE}', 6.5 ],
		        ['${entprsList[12].LTRS_VALUE}', 5.5 ],
		        ['${entprsList[13].LTRS_VALUE}', 4.5 ], 
		        ['${entprsList[14].LTRS_VALUE}', 3.5 ],
		        ['${entprsList[15].LTRS_VALUE}', 2.5 ], 
		        ['${entprsList[16].LTRS_VALUE}', 1.5 ], 
		        ['${entprsList[17].LTRS_VALUE}', 0.5 ] 
		        ],
		color : "#015ca5",
		bars : {
			fill : true,
			show : true,
			fillColor : "#015ca5"
		}
	}, {
		label : "기업",
		data : [
		        ['${entprsList[0].HPE_VALUE}', 17.5 ], 
		        ['${entprsList[1].HPE_VALUE}', 16.5 ],
		        ['${entprsList[2].HPE_VALUE}', 15.5 ],
		        ['${entprsList[3].HPE_VALUE}', 14.5 ], 
		        ['${entprsList[4].HPE_VALUE}', 13.5 ],
		        ['${entprsList[5].HPE_VALUE}', 12.5 ],
		        ['${entprsList[6].HPE_VALUE}', 11.5 ], 
		        ['${entprsList[7].HPE_VALUE}', 10.5 ],
		        ['${entprsList[8].HPE_VALUE}', 9.5 ],
		        ['${entprsList[9].HPE_VALUE}', 8.5 ], 
		        ['${entprsList[10].HPE_VALUE}', 7.5 ],
		        ['${entprsList[11].HPE_VALUE}', 6.5 ],
		        ['${entprsList[12].HPE_VALUE}', 5.5 ], 
		        ['${entprsList[13].HPE_VALUE}', 4.5 ],
		        ['${entprsList[14].HPE_VALUE}', 3.5 ],
		        ['${entprsList[15].HPE_VALUE}', 2.5 ], 
		        ['${entprsList[16].HPE_VALUE}', 1.5 ],
		        ['${entprsList[17].HPE_VALUE}', 0.5 ]
		        ],
		color : "#1c8bd6",
		bars : {
			fill : true,
			show : true,
			fillColor : "#1c8bd6"
		}
	}, {
		label : "중소기업",
		data : [
		        ['${entprsList[0].SMLPZ_VALUE}', 17.5 ],
		        ['${entprsList[1].SMLPZ_VALUE}', 16.5 ],
		        ['${entprsList[2].SMLPZ_VALUE}', 15.5 ], 
		        ['${entprsList[3].SMLPZ_VALUE}', 14.5 ],
		        ['${entprsList[4].SMLPZ_VALUE}', 13.5 ],
		        ['${entprsList[5].SMLPZ_VALUE}', 12.5 ], 
		        ['${entprsList[6].SMLPZ_VALUE}', 11.5 ],
		        ['${entprsList[7].SMLPZ_VALUE}', 10.5 ],
		        ['${entprsList[8].SMLPZ_VALUE}', 9.5 ], 
		        ['${entprsList[9].SMLPZ_VALUE}', 8.5 ],
		        ['${entprsList[10].SMLPZ_VALUE}', 7.5 ],
		        ['${entprsList[11].SMLPZ_VALUE}', 6.5 ], 
		        ['${entprsList[12].SMLPZ_VALUE}', 5.5 ],
		        ['${entprsList[13].SMLPZ_VALUE}', 4.5 ],
		        ['${entprsList[14].SMLPZ_VALUE}', 3.5 ], 
		        ['${entprsList[15].SMLPZ_VALUE}', 2.5 ],
		        ['${entprsList[16].SMLPZ_VALUE}', 1.5 ],
		        ['${entprsList[17].SMLPZ_VALUE}', 0.5 ]
		        ],
		color : "#00bfd0",
			bars : {
				fill : true,
				show : true,
				fillColor : "#00bfd0"
			}
	}]
	
	var ms_ticks = [
	                [ 17.5, "기업수(기업생멸)" ],
	                [ 16.5, "기업수(중기청)" ],
	                [ 15.5, "매출액" ],
	                [ 14.5, "수출액" ],
	                [ 13.5, "고용(고용통계)" ],
	                [ 12.5, "고용(사업체조사)" ],
	                [ 11.5, "부가가치" ],
	                [ 10.5, "인건비" ],
	                [ 9.5, "1인당인건비" ],
	                [ 8.5, "연구개발비(전체)" ],
	                [ 7.5, "연구개발비(기업체)" ],
	                [ 6.5, "법인세" ],
	                [ 5.5, "기부금" ],
	                [ 4.5, "매출액증가율" ],
	                [ 3.5, "사내유보율" ],
	                [ 2.5, "코스피" ],
	                [ 1.5, "코스닥" ],
	                [ 0.5, "코넥스" ],
	                ];
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

                if(y == 17.5) {
                	showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + item.series.data[0][0] +"%");	
                }else if(y == 16.5) {
                	showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + item.series.data[1][0] +"%");	
                }else if(y == 15.5) {
                	showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + item.series.data[2][0] +"%");	
                }else if(y == 14.5) {
                	showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + item.series.data[3][0] +"%");	
                }else if(y == 13.5) {
                	showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + item.series.data[4][0] +"%");	
                }else if(y == 12.5) {
                	showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + item.series.data[5][0] +"%");	
                }else if(y == 11.5) {
                	showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + item.series.data[6][0] +"%");	
                }else if(y == 10.5) {
                	showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + item.series.data[7][0] +"%");	
                }else if(y == 9.5) {
                	showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + item.series.data[8][0] +"%");	
                }else if(y == 8.5) {
                	showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + item.series.data[9][0] +"%");	
                }else if(y == 7.5) {
                	showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + item.series.data[10][0] +"%");	
                }else if(y == 6.5) {
                	showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + item.series.data[11][0] +"%");	
                }else if(y == 5.5) {
                	showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + item.series.data[12][0] +"%");	
                }else if(y == 4.5) {
                	showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + item.series.data[13][0] +"%");	
                }else if(y == 3.5) {
                	showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + item.series.data[14][0] +"%");	
                }else if(y == 2.5) {
                	showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + item.series.data[15][0] +"%");	
                }else if(y == 1.5) {
                	showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + item.series.data[16][0] +"%");	
                }else if(y == 0.5) {
                	showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" + item.series.data[17][0] +"%");	
                }
        	}
        } else {
            $("#tooltip").remove();
            previousPoint = null;
        }
    });
}

function labelFormatter(label, series) {
	return "<div style='font-size:8pt; text-align:center; padding:2px; color:white;'>" + label + "<br/>" + Math.round(series.percent) + "%</div>";
}
	
</script>
</head>
<body>
<form name="dataForm" id="dataForm" method="POST">
<div id="self_dgs">
	<div class="pop_q_con">
	    <div class="search_top">
	        <!-- // chart영역-->
	        <div class="m_graph">
		        <div class="tabwrap">
					<div class="tab">
						<ul>
							<li class="on"><a href="#none">${sel_target_year}년 기업 규모별 점유율</a></li>
						</ul>
					</div>
					<!--chart //-->
					<div class="graph graph_line">
						<div id="chart_stacking" style="width: 650px; height: 500px; margin-bottom:20px;"></div>
                            <div class="remark">
                                <ul>
                                    <li class="remark2">대기업</li>
                                    <li class="remark3">기업</li>
                                    <li class="remark4">중소기업</li>
                                </ul>
                            </div>
					</div>
		        	<!--chart //-->
		    	</div>
		    	<div class="btn_page_last"> 
		        	<a class="btn_page_admin" href="javascript:window.print();"><span>인쇄</span></a> 
		        	<a class="btn_page_admin" href="#" onclick="parent.$.fn.colorbox.close();"><span>닫기</span></a>
        		</div>
	    	</div>
	    	<!-- // chart영역-->
		</div>
	</div>
</div>
</form>
</body>
</html>