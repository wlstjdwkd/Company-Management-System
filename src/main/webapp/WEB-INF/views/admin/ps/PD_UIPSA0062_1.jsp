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
<ap:jsTag type="web" items="jquery,colorboxAdmin,cookie,flot,form,jqGrid,notice,selectbox,timer,tools,ui,validate" />
<ap:jsTag type="tech" items="util,acm,ps" />
<script type="text/javascript">
$(document).ready(function(){
	var form = document.all;
	
	var searchCondition = '${searchCondition}';
	var sel_target_year = '${sel_target_year}';
	
	/* //그리드 리사이즈
	$(window).bind('resize', function() {
		resizeJqGridWidth(); 
	}).trigger('resize');
	
	//현황 그리드
	$("#grid_sttus_list3").jqGrid({        
	   	url:'PGPS0062.do?df_method_nm=getGridSttusList&sel_target_year='+sel_target_year,
		datatype: "json",
		colNames:['구분', '평균매출액(억원)', '평균수출액(억불)', '평균근로자수(명)', '평균 R&D 투자비율(%)', '평균영업이익(억원)', '평균영업이익률(%)'],
	   	colModel:[
	   		{name:'CODE_NM',index:'CODE_NM', width:100},
	   		{name:'AVRG_SELNG_AM',index:'AVRG_SELNG_AM', width:80, align:"right",sorttype:"float"},
	   		{name:'AVRG_XPORT_AM_DOLLAR',index:'AVRG_XPORT_AM_DOLLAR', width:80, align:"right",sorttype:"float"},
	   		{name:'AVRG_ORDTM_LABRR_CO',index:'AVRG_ORDTM_LABRR_CO', width:80, align:"right",sorttype:"float"},
	   		{name:'AVRG_RSRCH_DEVLOP_RT',index:'AVRG_RSRCH_DEVLOP_RT', width:80, align:"right"},
	   		{name:'AVRG_BSN_PROFIT',index:'AVRG_BSN_PROFIT', width:80, align:"right",sorttype:"float"},
	   		{name:'AVRG_BSN_PROFIT_RT',index:'AVRG_BSN_PROFIT_RT', width:80, align:"right"},
	   	],
	   	//rowNum:10,
	   	//rowList:[10,20,30],
	   	//pager: '#grid_sttus_pager',
	   	sortname: 'CODE_NM',
	    viewrecords: true,
	    sortorder: "desc",
	    loadonce: false,
		jsonReader: {
			repeatitems : false
		},
		//caption: "현황",
		height: '100%',
	}); */
});

//jqGrid 리사이징
function resizeJqGridWidth(){
	$.timer(100, function (timer) {
		var grid_id = "grid_sttus_list3";
		var div_id = "baseGridWidth";		 	
	 	$('#' + grid_id).setGridWidth($('#' + div_id).width()-10 , true);
		timer.stop();
	});
}
</script>
</head>
<body>
<form name="dataForm" id="dataForm" method="POST">
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
	                <td>일반기업</td>
	                <th scope="row">년도</th>
	                <td>${sel_target_year}</td>
	            </tr>
	        </table>
	    </div>
	    <!-- // 리스트영역-->
	    <div class="block">
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
                            <th scope="col">구분</th>		                                    
                            <th scope="col">평균매출액(억원)</th>
                            <th scope="col">평균수출액(억불)</th>
                            <th scope="col">평균근로자수(명)</th>
                            <th scope="col">평균 R&#38;D 투자비율(&#37;)</th>
                            <th scope="col">평균영업이익(억원)</th>
                            <th scope="col">평균영업이익률(&#37;)</th>		                                                                       
                        </tr>
                    </thead>
                    <tbody>
						<c:forEach items="${entprsList}" var="resultInfo" varStatus="status" begin="0">
							<tr>
								<td>${resultInfo.CODE_NM }</td>
								<td class='tar'>${resultInfo.AVRG_SELNG_AM }</td>
								<td class='tar'>${resultInfo.AVRG_XPORT_AM_DOLLAR }</td>
								<td class='tar'>${resultInfo.AVRG_ORDTM_LABRR_CO }</td>
								<td class='tar'>${resultInfo.AVRG_RSRCH_DEVLOP_RT }</td>
								<td class='tar'>${resultInfo.AVRG_BSN_PROFIT }</td>
								<td class='tar'>${resultInfo.AVRG_BSN_PROFIT_RT }</td>
							</tr>
						</c:forEach>                                 
                	</tbody>
            	</table>
           	</div>        

	        <div class="btn_page_last"> 
	        	<a class="btn_page_admin" href="javascript:window.print();"><span>인쇄</span></a> 
	        	<a class="btn_page_admin" href="#" onclick="parent.$.fn.colorbox.close();"><span>닫기</span></a>
	        </div>
	        	        
	    </div>
	    <!--리스트영역 //-->
	</div>
	<!--content//-->
	</div>
</div>
</form>
</body>
</html>