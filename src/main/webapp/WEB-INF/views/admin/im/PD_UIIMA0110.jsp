<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset=UTF-8">
<title>정보</title>
<c:set var="svcUrl" value=" ${requestScope[SVC_URL_NAME]}"/>
<ap:globalConst/>
<ap:jsTag type="web" items="jquery,cookie,flot,form,jqGrid,noticetimer,tools,ui,validate"/>
<ap:jsTag type="tech" items="acm,msg,util"/>
<style type="text/css">

	.tab_content{
		display: none;
	}
	.tab_content.on{
		display: inherit;
	}
	
</style>
<script type='text/javascript'>

	$(document).ready(function() {
		
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
			bars: {
				fill: true,
				show: true,
				barWidth: 0.1,
				fillColor: "red"
			},
			color: "red"
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
			bars: {
				fill: true,
				show: true,
				barWidth: 0.1,
				fillColor: "blue"
			},
			color: "blue"
		});
		
		$.plot($("#placeholder1"), data1, {
			
	    	xaxis: {
	    		ticks: [[0,'상호출자'],[1,'기업'],[2,'관계기업'],[3,'후보기업'],[4,'중소기업']],
				autoscaleMargin: 0.1
	    	},
	    	
			yaxis: {
				tickFormatter: function numberWithCommas(x) {
					return x.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ",");
				}
			},
			
	    	series: {
	    		bars: {
	    			show: true,
					barWidth: 0.1,
					order: 1
				}
			},
			
			grid: {
				hoverable: true,
				clickable: true
			},
			
			valueLabels: {
				show: true
			},
			
			legend: {
				show: false
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
<!-- 콘텐츠 영역 -->
<form name="dataForm" id="dataForm" method="post">
	<div id="self_dgs">
		<div class="pop_q_con">
			<div class="search_top">
				<table cellpadding="0" cellspacing="0" class="table_search mgb30" summary="일반기업 성장현황 차트" >
					<caption>일반기업 성장현황 차트</caption>
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
						<td>2018</td>
					</tr>
				</table>
				<!-- chart 영역 -->
				<div class="remark_20 mgt20">
					<ul>
						<li class="remark1" style="background-image:url(../images/acm/remark03.png);">일반기업</li>
						<li class="remark2" style="background-image:url(../images/acm/remark07.png);">관계기업</li>
					</ul>
				</div>
				<div class="chart_zone mgt30" id="placeholder1"></div>
				<br>
				<br>
				<div class="btn_page_last">
					<a class="btn_page_admin" href="javascript:window.print();"><span>인쇄</span></a>
					<a class="btn_page_admin" href="#" onclick="parent.$.fn.colorbox.close();"><span>닫기</span></a>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>