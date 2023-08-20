<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox,jBox,flot" />
<ap:jsTag type="tech" items="msg,util,cmn, mainn, subb, font,pc" />

<script type="text/javascript">

$(document).ready(function() {
	var ticks1 = [[0, "매출액"], [1, "영업이익"], [2, "당기순이익"]];
	var ticks2 = [[0, "고용"], [1, "R&D집약도"]];
	var ticks3 = [[1, "R&D집약도"]];
	
	var flotOption1 = {
			
		series: {
            bars: {
                show: true,
                barWidth: 0.13,
                order: 1
            }
        },
        valueLabels: {
            show: true
        },
        xaxis: {           
        	 ticks: ticks1,
        	autoscaleMargin : 0.1
       	},
       	yaxis: {
			tickFormatter : function numberWithCommas(x) {
				return x.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ",");
			}
		},
        legend : {
			show : false
        },
       	grid : {
       		hoverable: true, 
            clickable: false, 
            mouseActiveRadius: 30,
			borderWidth : 0.2   
		},
	};
	
	var flotOption2 = {
			
			series: {
	            bars: {
	                show: true,
	                barWidth: 0.13,
	                order: 1
	            }
	        },
	        valueLabels: {
	            show: true
	        },
	        xaxis: {
	        	ticks: ticks2,
	        	autoscaleMargin:0.1
	       	},
	       	yaxes: [
		{
					
				  },
		{
					 position: "right"
				  }],
	        legend : {
				show : false
	        },
	       	grid : {
	       		hoverable: true, 
				clickable: false, 
				mouseActiveRadius: 30,
				borderWidth : 0.2
			},
		};
	
	// 매출액, 영업이익, 당기순이익
    var chData1_1 = [[0,${stsEntcls[0].SELNG_AM}],[1,${stsEntcls[0].BSN_PROFIT}],[2,${stsEntcls[0].THSTRM_NTPF}]];	// 기업
    var chData1_2 = [[0,${stsEntcls[1].SELNG_AM}],[1,${stsEntcls[1].BSN_PROFIT}],[2,${stsEntcls[1].THSTRM_NTPF}]];	// 업종 
    var chData1_3 = [[0,${stsEntcls[2].SELNG_AM}],[1,${stsEntcls[2].BSN_PROFIT}],[2,${stsEntcls[2].THSTRM_NTPF}]];	// 전산업
    var chData1_4 = [[0,${upperCmpnAvg.SELNG_AM}],[1,${upperCmpnAvg.BSN_PROFIT}],[2,${upperCmpnAvg.THSTRM_NTPF}]];	// 상위5개업체
    
    // 고용
    var chData2_1 = [[0,${stsEntcls[0].ORDTM_LABRR_CO}]];	// 기업
    var chData2_2 = [[0,${stsEntcls[1].ORDTM_LABRR_CO}]];	// 업종
    var chData2_3 = [[0,${stsEntcls[2].ORDTM_LABRR_CO}]];	// 전산업
    var chData2_4 = [[0,${upperCmpnAvg.ORDTM_LABRR_CO}]];	// 상위5개업체
    
    // R&D집약도
    var chData3_1 = [[1,${stsEntcls[0].RND_CCTRR}]];	// 기업
    var chData3_2 = [[1,${stsEntcls[1].RND_CCTRR}]];	// 업종
    var chData3_3 = [[1,${stsEntcls[2].RND_CCTRR}]];	// 전산업
    var chData3_4 = [[1,${upperCmpnAvg.RND_CCTRR}]];	// 상위5개업체

    var flot1_data = [
        {
            label: "${entprsInfo.ENTRPRS_NM }",
            color : "#015ca5",
            bars: {
				barWidth : 0.1,
        		show : true,
				order : 1,
				fillColor : "#015ca5"
        	},
            data: chData1_1
        },
        {
            label: "동종업종",
            color: "#149c85",
            bars: {
				barWidth : 0.1,
        		show : true,
				order : 2,
				fillColor : "#149c85"
        	},
            data: chData1_2
        },
        {
            label: "전산업",
            color : "#75bc2e",
            bars: {
				barWidth : 0.1,
        		show : true,
				order : 3,
				fillColor : "#75bc2e"
        	},
            data: chData1_3
        }
    ];
    
    var flot2_data = [
       {
           label: "${entprsInfo.ENTRPRS_NM }",
           color : "#015ca5",
           bars: {
			barWidth : 0.1,
       		show : true,
			order : 1,
			fillColor : "#015ca5"
       		},
           data: chData2_1
       },
       {
           label: "동종업종",
           color: "#149c85",
           bars: {
			barWidth : 0.1,
       		show : true,
			order : 2,
			fillColor : "#149c85"
       	},
           data: chData2_2
       },
       {
           label: "전산업",
           color : "#75bc2e",
           bars: {
			barWidth : 0.1,
       		show : true,
			order : 3,
			fillColor : "#75bc2e"
       	},
           data: chData2_3
       },
       {
           label: "${entprsInfo.ENTRPRS_NM }",
           color : "#015ca5",
           bars: {
			barWidth : 0.1,
       		show : true,
			order : 1,
			fillColor : "#015ca5"
       		},
       	   yaxis: 2,
           data: chData3_1
       },
       {
           label: "동종업종",
           color: "#149c85",
           bars: {
			barWidth : 0.1,
       		show : true,
			order : 2,
			fillColor : "#149c85"
       		},
       	   yaxis: 2,
           data: chData3_2
       },
       {
           label: "전산업",
           color : "#75bc2e",
           bars: {
			barWidth : 0.1,
       		show : true,
			order : 3,
			fillColor : "#75bc2e"
       		},
       	   yaxis: 2,
           data: chData3_3
       }
    ];
    
    var flot3_data = [
        {
            label: "${entprsInfo.ENTRPRS_NM }",
            color : "#015ca5",
            bars: {
				barWidth : 0.1,
        		show : true,
				order : 1,
				fillColor : "#015ca5"
        	},
            data: chData1_1
        },
        {
            label: "동종업종 상위5개기업",
            color: "#149c85",
            bars: {
				barWidth : 0.1,
        		show : true,
				order : 2,
				fillColor : "#149c85"
        	},
            data: chData1_4
        }
    ];
    
    var flot4_data = [
       {
           label: "${entprsInfo.ENTRPRS_NM }",
           color : "#015ca5",
           bars: {
			barWidth : 0.1,
       		show : true,
			order : 1,
			fillColor : "#015ca5"
       		},
           data: chData2_1
       },
       {
           label: "동종업종 상위5개기업",
           color: "#149c85",
           bars: {
			barWidth : 0.1,
       		show : true,
			order : 2,
			fillColor : "#149c85"
       	},
           data: chData2_4
       },       
       {
           label: "${entprsInfo.ENTRPRS_NM }",
           color : "#015ca5",
           bars: {
			barWidth : 0.1,
       		show : true,
			order : 1,
			fillColor : "#015ca5"
       		},
       	   yaxis: 2,
           data: chData3_1
       },
       {
           label: "동종업종 상위5개기업",
           color: "#149c85",
           bars: {
			barWidth : 0.1,
       		show : true,
			order : 2,
			fillColor : "#149c85"
       		},
       	   yaxis: 2,
           data: chData3_4
       }       
    ];

    $.plot($("#analisysChart1"), flot1_data, flotOption1);
    $("#analisysChart1").useTooltip();
    $.plot($("#analisysChart2"), flot2_data, flotOption2);
    $("#analisysChart2").useTooltip();
    $.plot($("#analisysChart3"), flot3_data, flotOption1);
    $("#analisysChart3").useTooltip();
    $.plot($("#analisysChart4"), flot4_data, flotOption2);
    $("#analisysChart4").useTooltip();
    
}); // ready

$.fn.useTooltip = function () {
    var previousPoint = null;
     
    $(this).bind("plothover", function (event, pos, item) {        
        if (item) {
			if (previousPoint != item.datapoint) {
				previousPoint = item.datapoint;
				$("#tooltip").remove();

				var x = item.datapoint[0], y = item.datapoint[1];
				if(pos.pageX > 900) {
					item.pageX = item.pageX - 50;
				}
				showTooltip(item.pageX, item.pageY, y + "("+ item.series.label + ")");
			}
		} else {
			$("#tooltip").remove();
			previousPoint = null;
		}
    });
    
}

//툴팁
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

</script>

</head>
<body>

<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" enctype="multipart/form-data" method="post">

<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/pagingParam.jsp" />

<div id="lookup01" class="modal">
	<div class="modal_wrap">
			 <div class="modal_cont">
				<table class="table_form">
					<caption>기업분석 서비스</caption>
					<colgroup>
						<col width="172px">
						<col width="364px">
						<col width="172px">
						<col width="365px">
					</colgroup>
					<tbody>
						<tr>
							<th>기업명</th>
							<td>${entprsInfo.ENTRPRS_NM }</td>
							<th>업종</th>
							<td>${entprsInfo.INDUTY_NM }</td>
						</tr>
					</tbody>
				</table>
				<div class="list_bl">
					<h4 class="fram_bl">동업종별 지표분석 (전산업 ${stsEntcls[1].ENTRPRS_CO}개, ${entprsInfo.INDUTY_NM } ${stsEntcls[0].ENTRPRS_CO})</h4>
					<div class="graph">
						<div style="width:50%; height:300px;" id="analisysChart1" class="leftzone"></div>
    					<div style="width:50%; height:300px;" id="analisysChart2" class="rightzone"></div>
					</div>

					<table class="table_form">
						<caption>동업종별 지표분석 (전산업 ${stsEntcls[1].ENTRPRS_CO}개, ${entprsInfo.INDUTY_NM } ${stsEntcls[0].ENTRPRS_CO})</caption>
						<colgroup>
							<col width="180px">
							<col width="178px">
							<col width="179px">
							<col width="178px">
							<col width="178px">
							<col width="180px">
						</colgroup>
						<thead>
							<tr>
								<th>비고</th>
								<th>매출액(억원)</th>
								<th>영업이익(억원)</th>
								<th>당기순이익(억원)</th>
								<th>고용(명)</th>
								<th>R&D집약도(%)</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${stsEntcls }" var="stsEntcls" varStatus="status">
		            		<tr>
			                    <td>${remark[status.index] }</td>
			                    <td class="tar">${stsEntcls.SELNG_AM }</td>
			                    <td class="tar">${stsEntcls.BSN_PROFIT }</td>
			                    <td class="tar">${stsEntcls.THSTRM_NTPF }</td>
			                    <td class="tar">${stsEntcls.ORDTM_LABRR_CO }</td>
			                    <td class="tar">${stsEntcls.RND_CCTRR }</td>                    
			                </tr>
            				</c:forEach>
						</tbody>
					</table>

				</div>
				<div class="list_bl">
					<h4 class="fram_bl">상위 5개 기업 분석</h4>
					<div class="graph">
						<div style="width:50%; height:300px;" id="analisysChart3" class="leftzone"></div>
    					<div style="width:50%; height:300px;" id="analisysChart4" class="rightzone"></div>
					</div>

					<table class="table_form">
						<caption>상위 5개 기업 분석</caption>
						<colgroup>
							<col width="180px">
							<col width="178px">
							<col width="179px">
							<col width="178px">
							<col width="178px">
							<col width="180px">
						</colgroup>
						<thead>
							<tr>
								<th>비고</th>
								<th>매출액(억원)</th>
								<th>영업이익(억원)</th>
								<th>당기순이익(억원)</th>
								<th>고용(명)</th>
								<th>R&D집약도(%)</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="t_center">${entprsInfo.ENTRPRS_NM }(총액)</td>
								<td class="t_right">${stsEntcls[0].SELNG_AM}</td>
								<td class="t_right">${stsEntcls[0].BSN_PROFIT}</td>
								<td class="t_right">${stsEntcls[0].THSTRM_NTPF}</td>
								<td class="t_right">${stsEntcls[0].ORDTM_LABRR_CO}</td>
								<td class="t_right">${stsEntcls[0].RND_CCTRR}</td> 
							</tr>
							<tr>
								<td class="t_center">동종업종(평균)</td>
								<td class="t_right">${upperCmpnAvg.SELNG_AM}</td>
								<td class="t_right">${upperCmpnAvg.BSN_PROFIT}</td>
								<td class="t_right">${upperCmpnAvg.THSTRM_NTPF}</td>
								<td class="t_right">${upperCmpnAvg.ORDTM_LABRR_CO}</td>
								<td class="t_right">${upperCmpnAvg.RND_CCTRR}</td>
							</tr>
						</tbody>
					</table>

				</div>
			 </div>
		</div>
	</div>

</form>

</body>
</html>