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
	
	var data1 = [];
	
	data1.push({
		label: "일반기업",
		data: [ 
                  [ 0, '${entprsList[0].B_ENT}' ], 
                  [ 1, '${entprsList[0].H_ENT}' ],
                  [ 2, '${entprsList[0].R_ENT}' ],
                  [ 3, '${entprsList[0].C_ENT}' ],
                  [ 4, '${entprsList[0].S_ENT}' ],
                 ],
		bars : {
			fill : true,
			show : true,
			barWidth : 0.1,
			fillColor : "#013b6b"
		},
		color : "#013b6b"
	});
	
	data1.push({
		 label: "관계기업",
         data: [ 
					[ 0, '${entprsList[1].B_ENT}' ], 
					[ 1, '${entprsList[1].H_ENT}' ],
					[ 2, '${entprsList[1].R_ENT}' ],
					[ 3, '${entprsList[1].C_ENT}' ],
					[ 4, '${entprsList[1].S_ENT}' ],
                ],
		bars : {
			fill : true,
			show : true,
			barWidth : 0.1,
			fillColor : "#015ca5"
		},
		color : "#015ca5"
	});
	    
    $.plot($("#placeholder1"), data1, {
    	xaxis: {
    		ticks: [[0,'상호출자'],[1,'기업'],[2,'관계기업'],[3,'후보기업'],[4,'중소기업']],
			autoscaleMargin : 0.1
    	},
		yaxis: {
			tickFormatter : function numberWithCommas(x) {
				return x.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ",");
			}
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
	        <table cellpadding="0" cellspacing="0" class="table_search mgb30" summary="주요지표 현황 챠트" >
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
	                <td>일반기업</td>
	                <th scope="row">년도</th>
	                <td>${sel_target_year}</td>
	            </tr>
	        </table>
	        <!-- // chart영역-->
	        <!--// chart -->
	        <div class="remark_20 mgt20">
	    		<ul>
	    			<li class="remark1">일반기업</li>
	    			<li class="remark2">관계기업</li>	    		
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