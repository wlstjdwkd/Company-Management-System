<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<ap:jsTag type="tech" items="pc,util,acm" />
<script type="text/javascript">
$(document).ready(function(){	
	
 	var data = new Array();
	var pieChart = new Array();
	var entrprs_co= document.getElementsByName("entrprs_co");
	for(var i=0; i<8; i++) {
		pieChart[i] = document.getElementById("pieChart"+i);
		
		var c = i*2; 
		var z = (i*2)+1;
		
		data[i] =  [{
			label : "제조" , data : entrprs_co[c].value , color : "#1c8bd6"
		},
		{ label : "비제조", data : entrprs_co[z].value, color : "#00bfd0"
		}];
	
		$.plot( pieChart[i] , data[i], {
	   	    series: {
	   	        pie: {
	   	            show: true,
					radius: 3/4,
	   	            label: {
						show: true,
						radius: 3/4,
						formatter: function(label, slice){
							return "<div style='font-size:8pt; text-align:center; padding:2px; color:black;'>" + label + "<br/>" + Math.round(slice.percent) + "%</div>";
						},
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

</script>
</head>
<body>
<form name="dataForm" id="dataForm" method="POST">
		<c:forEach items="${resultList}" var="result" varStatus="status">
			<c:if test="${result.areaCode != 'ALL'}">
				<input type="hidden" name="entrprs_co" value="${result.sumEntrprsCo}" />
			</c:if>
		</c:forEach>

    <div id="self_dgs">
        <div class="pop_q_con">
            <!--// 검색 조건 -->
            <div class="search_top">
                <table cellpadding="0" cellspacing="0" class="table_search" summary="주요지표 현황 챠트" >
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
                        <td>${tableTitle }</td>
                        <th scope="row">년도</th>
                        <td>${param.searchStdyy}</td>
                    </tr>
                    <tr>
                        <th scope="row">지표</th>
                        <td colspan="3">기업수</td>
                    </tr>
                    <tr>
                 
                        <td colspan="4">
                        <!--// chart 지역별
                            <div class = "chart_zone mgt20" >
                                <div style = "width:30%; height:662; margin:0 auto;">
                                    <div class = "graph_map mgb20">
                                        <div style="position:absolute;">
                                            <div id="pieChart0" style="width:80px; height:101px; border:0px solid red; position:relative; left:100px;top:75px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart1" style="width:80px; height:101px; border:0px solid red; position:relative; left:320px;top:395px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart2" style="width:80px; height:101px; border:0px solid red; position:relative; left:250px;top:305px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart3" style="width:80px; height:101px; border:0px solid red; position:relative; left:40px;top:120px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart4" style="width:80px; height:101px; border:0px solid red; position:relative; left:70px;top:385px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart5" style="width:80px; height:101px; border:0px solid red; position:relative; left:140px;top:260px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart6" style="width:80px; height:101px; border:0px solid red; position:relative; left:330px;top:325px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart7" style="width:80px; height:101px; border:0px solid red; position:relative; left:125px;top:215px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart8" style="width:80px; height:101px; border:0px solid red; position:relative; left:160px;top:115px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart9" style="width:80px; height:101px; border:0px solid red; position:relative; left:230px;top:55px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart10" style="width:80px; height:101px; border:0px solid red; position:relative; left:180px;top:175px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart11" style="width:80px; height:101px; border:0px solid red; position:relative; left:60px;top:235px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart12" style="width:80px; height:101px; border:0px solid red; position:relative; left:115px;top:315px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart13" style="width:80px; height:101px; border:0px solid red; position:relative; left:60px;top:440px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart14" style="width:80px; height:101px; border:0px solid red; position:relative; left:280px;top:235px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart15" style="width:80px; height:101px; border:0px solid red; position:relative; left:220px;top:365px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart16" style="width:80px; height:101px; border:0px solid red; position:relative; left:60px;top:550px;"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                          지역별  chart //-->
                          
                        <!--// chart 지역별 -->
                            <div class = "chart_zone mgt20" >
                                <div style = "width:30%; height:662; margin:0 auto;">
                                    <div class = "graph_map mgb20">
                                        <div style="position:absolute;">
                                            <div id="pieChart0" style="width:80px; height:101px; border:0px solid red; position:relative; left:100px;top:85px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart1" style="width:80px; height:101px; border:0px solid red; position:relative; left:180px;top:175px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart2" style="width:80px; height:101px; border:0px solid red; position:relative; left:70px;top:385px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart3" style="width:80px; height:101px; border:0px solid red; position:relative; left:280px;top:235px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart4" style="width:80px; height:101px; border:0px solid red; position:relative; left:220px;top:365px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart5" style="width:80px; height:101px; border:0px solid red; position:relative; left:230px;top:55px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart6" style="width:80px; height:101px; border:0px solid red; position:relative; left:60px;top:550px;"></div>
                                        </div>
                                        <div style="position:absolute;">
                                            <div id="pieChart7" style="width:80px; height:101px; border:0px solid red; position:relative; left:115px;top:225px;"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                          <!-- 권역별  chart //-->
                          </td>  
                    </tr>
                </table>
                <!-- // chart영역-->
                <div class="btn_page_last"> <a class="btn_page_admin" href="javascript:window.print();"><span>인쇄</span></a> <a class="btn_page_admin" href="#" onClick="parent.$.fn.colorbox.close();"><span>닫기</span></a> </div>
                <!--chart영역 //-->
            </div>
            <!--content//-->
        </div>
    </div>
</form>
</body>
</html>