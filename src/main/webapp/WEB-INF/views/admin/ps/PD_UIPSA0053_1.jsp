<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
	
	var indutyListCnt = ${indutyListCnt};
	var areaListCnt = ${areaListCnt};
	
	var data1 = [];														// 업종별
	var data2 = [];														// 지역별
	var indutyTicks = [];
	var areaTicks = [];
	
	var indutyD1 = [];												// fieCo
	var indutyD2 = [];												// nfieCo
	
	var areaD1 = [];													// fieCo
	var areaD2 = [];													// nfieCo

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

	if ( '${searchInduty}' != '') {
		var indutyTick= document.getElementsByName("tick1");						// 업종별 x라벨

		var indutyFieCo= document.getElementsByName("indutyFieCo");
		var indutyNfieCo= document.getElementsByName("indutyNfieCo");

		for(var i = 0; i < indutyListCnt; i++) {
			indutyTicks.push([i, indutyTick[i].value]);
			indutyD1.push([i,indutyFieCo[i].value]);
			indutyD2.push([i,indutyNfieCo[i].value]);
		}

		for(var i = startYear; i< endYear+1; i++) {

			data1.push({
				label: "외투기업",
				data: indutyD1,
				bars: {
					barWidth : 0.05,
					show : true,
					order : 1,
					fillColor : "#013b6b"
				}, color : "#013b6b"
			});
		}

		$.plot($("#placeholder1"), data1, {
			xaxis : {
				show : true,
				ticks : indutyTicks,
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

	if( '${searchArea}' != null) {
		var areaTick= document.getElementsByName("tick2");							// 지역별 x라벨

		var areaFieCo= document.getElementsByName("areaFieCo");
		var areaNfieCo= document.getElementsByName("areaNfieCo");

		for(var j = 0; j < areaListCnt; j++) {
			areaTicks.push([j, areaTick[j].value]);
			areaD1.push([j,areaFieCo[j].value]);
			areaD2.push([j,areaNfieCo[j].value]);
		}

		data2.push({
			label: "기업현황",
			data: areaD1,
			bars: {
				barWidth : 0.05,
				show : true,
				order : 1,
				fillColor : "#013b6b"
			}, color : "#013b6b"
		});

		data2.push({
			label: "매출형태",
			data: areaD2,
			bars: {
				barWidth : 0.05,
				show : true,
				order : 2,
				fillColor : "#147f94"
			}, color : "#147f94"
		});

		$.plot($("#placeholder2"), data2, {
			xaxis : {
				show : true,
				ticks : areaTicks,
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
});
</script>
</head>
<body>
<form name="dataForm" id="dataForm" method="POST">
		<c:forEach items="${areaResultList}" var="areaResult" varStatus="status">
			<c:if test="${searchArea != null}">
				<c:if test = "${searchArea=='1'}"><input type="hidden" name="tick2" value="${areaResult.upperNm}" /></c:if>
				<c:if test = "${searchArea=='2'}"><input type="hidden" name="tick2" value="${areaResult.abrv}" /></c:if>

				<input type="hidden" name="areaFieCo" value="${areaResult.fieCo}"/>
				<input type="hidden" name="areaNfieCo" value="${areaResult.nfieCo}"/>
				<input type="hidden" name="areaFieCo" value="${areaResult.fieCo}"/>
				<input type="hidden" name="areaNfieCo" value="${areaResult.nfieCo}"/>
				<input type="hidden" name="areaFieCo" value="${areaResult.fieCo}"/>
				<input type="hidden" name="areaNfieCo" value="${areaResult.nfieCo}"/>
				<input type="hidden" name="areaFieCo" value="${areaResult.fieCo}"/>
				<input type="hidden" name="areaNfieCo" value="${areaResult.nfieCo}"/>
				
			</c:if>
		</c:forEach>

		<c:forEach items="${indutyResultList}" var="indutyResult" varStatus="status">
			<c:if test="${searchInduty != null}">
				<c:if test = "${searchInduty=='1'}"><input type="hidden" name="tick1" value="${indutyResult.indutySeNm}"/></c:if>
				<c:if test = "${searchInduty=='2'}"><input type="hidden" name="tick1" value="${indutyResult.dtlclfcNm}"/></c:if>
				<c:if test = "${searchInduty=='3'}"><input type="hidden" name="tick1" value="${indutyResult.indutyNm}"/></c:if>

				<input type="hidden" name="indutyFieCo" value="${indutyResult.fieCo}"/>
				<input type="hidden" name="indutyNfieCo" value="${indutyResult.nfieCo}"/>
				<input type="hidden" name="indutyFieCo" value="${indutyResult.fieCo}"/>
				<input type="hidden" name="indutyNfieCo" value="${indutyResult.nfieCo}"/>
				<input type="hidden" name="indutyFieCo" value="${indutyResult.fieCo}" />
				<input type="hidden" name="indutyNfieCo" value="${indutyResult.nfieCo}"/>
				<input type="hidden" name="indutyFieCo" value="${indutyResult.fieCo}"/>
				<input type="hidden" name="indutyNfieCo" value="${indutyResult.nfieCo}"/>
				
			</c:if>
		</c:forEach>

<div id="self_dgs">
	<div class="pop_q_con">
	    <!--// 검색 조건 -->
	    <div class="search_top">
	        <table cellpadding="0" cellspacing="0" class="table_search" summary="거래유형별 현황 챠트" >
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
	                <td>${searchEntprsGrp}</td>
	                <th scope="row">년도</th>
	                <td>${searchStdyy}</td>
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
	        </table>
	        
	        <!-- // chart영역-->
	        <!--// chart -->
	        <c:if test="${searchArea != '' && searchInduty != ''}">
				<div class="tabwrap mgt30">
					<div class="tab">
	     				<ul>
							<li class="on"><a href="#none">업종별</a></li><li><a href="#none">지역별</a></li>
						</ul>
	     			</div>
					<div class="tabcon" style="display: block;">
						<div class="chart_zone" id="placeholder1" ></div>
	        		</div>
					<div class="tabcon" style="display: none;">
						<div class="chart_zone" id="placeholder2" style="width: 1448px;"></div>
					</div>
				</div>
			</c:if>
			<c:if test="${searchArea != '' && searchInduty == ''}" > 
				<div class="chart_zone mgt30" id="placeholder2"></div>
	    	</c:if>
			<c:if test="${searchArea == '' && searchInduty != ''}" > 
				<div class="chart_zone mgt30" id="placeholder1" ></div>
	    	</c:if>
	        <!--chart //-->
	        <div class="btn_page_last"> 
	        	<a class="btn_page_admin" href="javascript:window.print();"><span>인쇄</span></a> 
	        	<a class="btn_page_admin" href="#" onclick="parent.$.fn.colorbox.close();"><span>닫기</span></a>
	        </div>
	    	<!--chart영역 //-->
		</div>
	<!--content//-->
	</div>
</div>
</form>
</body>
</html>