<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
<ap:jsTag type="tech" items="pc,util,acm,ps" />
<script type="text/javascript">
$(document).ready(function(){	
	var listCnt = '${listCnt}';

    var stdyySt = ${param.from_sel_target_year};
    var stdyyEd = ${param.to_sel_target_year};
    
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
	
	var data1 = [];
	
	if (9 * (stdyyEd-stdyySt+1) < 100 ) {
		autoscaleMargin = 0.02;
		barWidth = 0.015;
	}		
	if (9 * (stdyyEd-stdyySt+1) < 60 ) {
		autoscaleMargin = 0.05;
		barWidth = 0.025;
	}
	if (9 * (stdyyEd-stdyySt+1) < 40 ) {
		autoscaleMargin = 0.05;
		barWidth = 0.04;			
	}
	if (9 * (stdyyEd-stdyySt+1) < 20 ) {
		autoscaleMargin = 0.1;
		barWidth = 0.09;
	}
	if (9 * (stdyyEd-stdyySt+1) < 10 ) {
		autoscaleMargin = 0.3;
		barWidth = 0.12;
	}
	
	data1.push({
		label: "전산업-기업수",
		data: ${G01_data},
		bars : {
			fill : true,
			show : true,
			barWidth : barWidth,
			fillColor : graphColor[0]
		},
		color : graphColor[0]
	});
	data1.push({
		label: "전산업-신규진입",
		data: ${G02_data},
		bars : {
			fill : true,
			show : true,
			barWidth : barWidth,
			fillColor : graphColor[1]
		},
		color : graphColor[1]
	});
	data1.push({
		label: "전산업-성장기업",
		data: ${G03_data},
		bars : {
			fill : true,
			show : true,
			barWidth : barWidth,
			fillColor : graphColor[2]
		},
		color : graphColor[2]
	});
	data1.push({
		label: "제조업-기업수",
		data: ${G04_data},
		bars : {
			fill : true,
			show : true,
			barWidth : barWidth,
			fillColor : graphColor[3]
		},
		color : graphColor[3]
	});
	data1.push({
		label: "제조업-증가수",
		data: ${G05_data},
		bars : {
			fill : true,
			show : true,
			barWidth : barWidth,
			fillColor : graphColor[4]
		},
		color : graphColor[4]
	});
	data1.push({
		label: "제조업-성장기업",
		data: ${G06_data},
		bars : {
			fill : true,
			show : true,
			barWidth : barWidth,
			fillColor : graphColor[5]
		},
		color : graphColor[5]
	});
	data1.push({
		label: "비제조업-기업수",
		data: ${G07_data},
		bars : {
			fill : true,
			show : true,
			barWidth : barWidth,
			fillColor : graphColor[6]
		},
		color : graphColor[6]
	});
	data1.push({
		label: "비제조업-증가수",
		data: ${G08_data},
		bars : {
			fill : true,
			show : true,
			barWidth : barWidth,
			fillColor : graphColor[7]
		},
		color : graphColor[7]
	});
	data1.push({
		label: "비제조업-성장기업",
		data: ${G08_data},
		bars : {
			fill : true,
			show : true,
			barWidth : barWidth,
			fillColor : graphColor[8]
		},
		color : graphColor[8]
	});
	
             
    $.plot($("#placeholder1"), data1, {
    	xaxis: {
    		ticks: ${ticks},
    		autoscaleMargin : autoscaleMargin
    	},
    	series : {
			bars : {
				show : true,
				barWidth : 0.1,
				order : 1
			}
		},
		grid : {
			hoverable: true,
			clickable: true
		},
		valueLabels : {
			show : true
		},
		legend : {
			show : false
		}
    });
	
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
<div id="self_dgs">
	<div class="pop_q_con">
	    <!--// 검색 조건 -->
	    <div class="search_top">
	        <table cellpadding="0" cellspacing="0" class="table_search mgb30" summary="일반기업 성장현황 추이 챠트" >
	            <caption>
	            일반기업 성장현황 추이 챠트
	            </caption>
	            <colgroup>
	            <col width="15%" />
	            <col width="25%" />
	            <col width="15%" />
	            <col width="25%" />
	            </colgroup>
	            <tr>
	                <th scope="row">기업군</th>
	                <td>일반기업</td>
	                <th scope="row">년도</th>
	                <td>${from_sel_target_year} ~ ${to_sel_target_year}</td>
	            </tr>
	        </table>
	        <!-- // chart영역-->
	        <!--// chart -->
	        <div class="remark_20 mgb30">
                <ul>
                    <li class="remark1">전산업-기업수</li>
                    <li class="remark2">전산업-증가수</li>
                    <li class="remark3">전산업-신규진입</li>
                    <li class="remark4">제조업-기업수</li>
                    <li class="remark5">제조업-증가수</li>
                    <li class="remark6">제조업-신규진입</li>
                    <li class="remark7">비제조업-기업수</li>
                    <li class="remark8">비제조업-증가수</li>
                    <li class="remark9">비제조업-신규진입</li>
                </ul>
            </div>
			<div class="chart_zone mgt30" id="placeholder1"></div>
	        <!--chart //-->
	        <div class="btn_page_last"> 
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