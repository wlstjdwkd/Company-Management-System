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
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,selectbox,mask,jqGrid,css"/>
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
		
		$('ul.tabs li').click(function(){
			
    		$('ul.tabs li').removeClass('on');
    		$(this).addClass('on');
    		
    		var tab_id = $(this).attr('data_tab');
    		
    		$('.tab_content').removeClass('on');
    		$('#'+tab_id).addClass('on');
    		
    	});
		
	});
	
	//일반기업 성장현황 > 목록 검색
	function search_list() {
		
		$("#df_method_nm").val("");
		$("#dataForm").submit();
		
	}
	
	//차트 popup
	var implementInsertForm = function() {
	    
		$.colorbox({
	        title : "일반기업성장현황 차트",
	        href : "PGIM0110.do?df_method_nm=getGridSttusChart",
	        width : "80%",
	        height : "100%",
	        iframe : true,
	        overlayClose : false,
	        escKey : false
	    });
		
	};
	
</script>
</head>
<body>
<div id="wrap">
	<div class="wrap_inn">
		<div class="contents">
			<!-- 타이틀 영역 -->
			<h2 class="menu_title">일반기업 성장현황 차트</h2>
			<!-- 콘텐츠 영역 -->
			<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}'/>" method="post">
			
				<ap:include page="param/defaultParam.jsp"/>
				<ap:include page="param/dispParam.jsp"/>
				<ap:include page="param/pagingParam.jsp"/>
				
				<div class="block">
					<div class="btn_page_middle">
						<span class="mgr20">(단위: 개,%) </span>
						<a class="btn_page_admin" href="#" onclick="implementInsertForm();"><span>차트</span></a>
			     	</div>
			     	
			     	<div class="list_zone">
			     		<table cellspacing="0" border="0" summary="기업통계" class="list" id="tblStatics">
			     			<caption>리스트</caption>
			     			<colgroup>
			     				<col width="*" />
			     				<col width="*" />
			     				<col width="*" />
			     				<col width="*" />
			     				<col width="*" />
			     				<col width="*" />
			     				<col width="*" />
			     			</colgroup>
			     			<thead>
			     				<tr>
			     					<th scope="col">기업구분</th>	
			     					<th scope="col">상호출자</th>
			     					<th scope="col">중견</th>
			     					<th scope="col">관계</th>
			     					<th scope="col">후보</th>
			     					<th scope="col">중소</th>
			     					<th scope="col">전체</th>
			     				</tr>
			     			</thead>
			     			<tbody>
			     				<c:forEach items="${entprsList}" var="entprs" varStatus="status" begin="0">
			     					<tr>
			     						<td>${entprs.GUBUN}</td>
	                            		<td class='tar'>${entprs.B_ENT}</td>
	                            		<td class='tar'>${entprs.H_ENT}</td>
	                            		<td class='tar'>${entprs.R_ENT}</td>
	                            		<td class='tar'>${entprs.C_ENT}</td>
	                            		<td class='tar'>${entprs.S_ENT}</td>
	                            		<td class='tar'>${entprs.SUM_ENT}</td>
	                            	</tr>
	                            </c:forEach>
	                        </tbody>
	                    </table>
	                </div>
	            </div>
	        </form>
			<div class="tabwrap" style="margin:70px;">
				<div class="tab">
					<ul class="tabs">
                        <li class="on" data_tab="tab_1">jsp</li>
                        <li data_tab="tab_2">js</li>
                        <li data_tab="tab_3">java</li>
                    </ul>
                   	<div id="tab_1" class="tab_content on">
                   	<c:set var="string1" value='
                   	
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
                        <li class="remark1">일반기업</li>
                        <li class="remark2">관계기업</li>
                    </ul>
                </div>
                <div class="chart_zone mgt30" id="placeholder1"></div>
            </div>
        </div>
    </div>
</form>
</body>                   	
                   	'/>
                   	<pre>${fn:escapeXml(string1)}</pre>
                   	</div>
                   	<div id="tab_2" class="tab_content">
                   	<c:set var="string2" value="
                   	
<script type='text/javascript'>

    $(document).ready(function() {
    
        var data1 = [];
        
        data1.push({
            label: '일반기업',
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
                fillColor: '#013b6b'
            },
            color: '#013b6b'
        });
        
        data1.push({
            label: '관계기업',
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
                fillColor: '#015ca5'
            },
            color: '#015ca5'
        });
        
        $.plot($('#placeholder1'), data1, {
        
            xaxis: {
                ticks: [[0,'상호출자'],[1,'기업'],[2,'관계기업'],[3,'후보기업'],[4,'중소기업']],
                autoscaleMargin: 0.1
            },
            
            yaxis: {
                tickFormatter: function numberWithCommas(x) {
                    return x.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ',');
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
        
            $('<div id = 'tooltip'>' +contents +' </div>').css( {
                position: 'absolute',
                display: 'none',
                top: y  - 50,
                left: x  + 40,
                border: '1px solid #fdd',
                padding: '2px',
                'background-color': '#fee',
                opacity: 0.80
            }).appendTo('body').show();
            
        }
        
        // 툴팁 이벤트
        $('#placeholder1').bind('plothover', function (event, pos, item) {
        
            if (item) {
            
                if (previousPoint != item.datapoint) {
                    previousPoint = item.datapoint;
                    
                    $('#tooltip').remove();
                    
                    var x = item.datapoint[0],
                        y = item.datapoint[1];
                        
                    showTooltip(item.pageX, item.pageY,  '<b>' + item.series.label + '</b><br />' + y );
                }
                
            } else {
                $('#tooltip').remove();
                previousPoint = null;
            }
            
        });
        
    });
	
</script>                   	
                   	"/>
                   	<pre>${fn:escapeXml(string2)}</pre>
                   	</div>
                   	<div id="tab_3" class="tab_content">
                   	<c:set var="string3" value='
                   	
//일반기업 성장 현황 > 현황 차트
public ModelAndView getGridSttusChart(Map<?,?> rqstMap) throws Exception {
    ModelAndView mv = new ModelAndView("/admin/im/PD_UIIMA0110");
    HashMap param = new HashMap();
    
    List<Map> entprsList = new ArrayList<Map>();
    entprsList = pgim0110Dao.selectGrowthSttusChart(param);
    
    // 데이터 추가
    mv.addObject("listCnt", entprsList.size());
    mv.addObject("entprsList", entprsList);
    
    return mv;
}                   	
                   	'/>
                   	<pre>${fn:escapeXml(string3)}</pre>
                   	</div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>