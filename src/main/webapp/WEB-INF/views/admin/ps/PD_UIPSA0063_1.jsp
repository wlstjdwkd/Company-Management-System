<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@	taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
	var induty_select = '${induty_select}';
	var multiSelectGrid1 = '${multiSelectGrid1}';
	var multiSelectGrid2 = '${multiSelectGrid2}';
	var ad_ind_cd = '${ad_ind_cd}';
	var sel_area = '${sel_area}';
	var cmpn_area_depth1 = '${cmpn_area_depth1}';
	var cmpn_area_depth2 = '${cmpn_area_depth2}';
	var gSelect1 = '${gSelect1}';
	var gSelect2 = '${gSelect2}';
	
	/* //그리드 리사이즈
	$(window).bind('resize', function() {
		resizeJqGridWidth(); 
	}).trigger('resize');
	
	//현황 그리드
	$.ajax({
	    url:'PGPS0063.do?df_method_nm=processGetGridSttusListMain&gSelect1='+gSelect1+'&gSelect2='+gSelect2,
	    dataType: "json",
	    type: 'POST',
	    async: false,
	    success: function (result) {

	        if (result) {

	            if (!result.Error) {

	                var colD = result.value.data;
	                var colM = result.value.colModelList;
	                var colN = result.value.columnNames;
	                
	                var ColModel1 = [];
	                 for (var j = 0; j<result.value.colModelList.length; j++) {
	                	 ColModel1.push({name:result.value.colModelList[j],index:result.value.colModelList[j], width:80});
	                  }
	                
	                $("#grid_sttus_list3").jqGrid('GridUnload');
	                
	               //기업현황 그리드
	            	$("#grid_sttus_list3").jqGrid({
	            		url:"PGPS0063.do?df_method_nm=processGetGridSttusList&searchCondition="+searchCondition
		        			+"&sel_target_year="+sel_target_year+"&induty_select="+induty_select
		        			+"&multiSelectGrid1="+multiSelectGrid1+"&multiSelectGrid2="+multiSelectGrid2
		        			+"&gSelect1="+gSelect1+"&gSelect2="+gSelect2+"&ad_ind_cd="+ad_ind_cd
		        			+"&sel_area="+sel_area+"&cmpn_area_depth1="+cmpn_area_depth1+"&cmpn_area_depth2="+cmpn_area_depth2,
	            		datatype: "json",
	            		colNames:colN,
	            	   	colModel:ColModel1,
	                    height: "auto",
	                    rowNum:'${entprsSizeentprsSize}',
	            	   	//rowList:[10,20,30],
	            	   	//pager: '#grid_sttus_pager',
	            	   	sortname: 'AREA1',
	            	    //viewrecords: true,
	            	    gridview: true,
	            	    sortorder: "desc",
	            	    loadonce: false,
	            		jsonReader: {
	            			repeatitems : false
	            		},
	            		//caption: "추이",
	            		height: '100%',
	            	});
	            }
	        }
	    },
	    error: function (xhr, ajaxOptions, thrownError) {
	        if (xhr && thrownError) {
	            alert('Status: ' + xhr.status + ' Error: ' + thrownError);
	        }
	    }
	});
	jQuery("#grid_sttus_list3").jqGrid('setGroupHeaders', {
		useColSpanStyle: true,
		groupHeaders:[
			{startColumnName: 'SELNG_AM', numberOfColumns: 2, titleText: '매출(천원)'},
			{startColumnName: 'ORDTM_LABRR_CO', numberOfColumns: 2, titleText: '고용(만명)'},
			{startColumnName: 'XPORT_AM_WON', numberOfColumns: 2, titleText: '수출(원)'},
			{startColumnName: 'RSRCH_DEVLOP_CT', numberOfColumns: 2, titleText: '연구개발비'},
		]
	}); */
	
	Util.rowSpan($("#tblStatics"), [1]);
});

//jqGrid 리사이징
/* function resizeJqGridWidth(){
	$.timer(100, function (timer) {
		var grid_id = "grid_sttus_list3";
		var div_id = "baseGridWidth";		 	
	 	$('#' + grid_id).setGridWidth($('#' + div_id).width()-10 , true);
		timer.stop();
	});
} */
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
	                <td>전체기업</td>
	                <th scope="row">년도</th>
	                <td>${sel_target_year}</td>
	            </tr>
	        </table>
	    </div>
	    <!-- // 리스트영역-->
	    <div class="block">
	        <!--// chart -->
			<!-- <div id="baseGridWidth">
            	<table id="grid_sttus_list3"></table>
            	<div id="grid_sttus_pager3"></div>
            </div> 
	        chart //
	        <br><br> -->

	        <div class="list_zone" id="div_data_table">
               <table cellspacing="0" border="0" summary="기업통계" class="list" id="tblStatics">
                   <caption>
                    리스트
                    </caption>
                    <colgroup>
                	<c:if test="${!empty param.searchArea }">
                    <col width="*" />
                	</c:if>
                	<c:if test="${!empty param.searchInduty }">
                    <col width="*" />
                	</c:if>
                	<col width="*" />
                    <col width="*" />
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
                        	<c:if test="${!empty param.searchArea }">
                            <th scope="col" rowspan="2">지역</th>
                        	</c:if>
                            <c:if test="${!empty param.searchInduty }">
                            <th scope="col" rowspan="2">업종</th>
                            </c:if>
                            <th scope="col" rowspan="2">기업수(개)</th>
                            <th scope="col" colspan="2">매출(천원)</th>
                            <th scope="col" colspan="2">고용(만명)</th>
                            <th scope="col" colspan="2">수출(원)</th>
                            <th scope="col" colspan="2">연구개발비</th>
                        </tr>
                        <tr>
                            <th scope="col">평균(천원)</th>
                            <th scope="col">성장률</th>
                            <th scope="col">평균(명)</th>
                            <th scope="col">성장률</th>
                            <th scope="col">평균(천원)</th>
                            <th scope="col">성장률</th>
                            <th scope="col">평균(천원)</th>
                            <th scope="col">성장률</th>                                    
                        </tr>
                    </thead>
                    <tbody>    	
				    	<c:if test="${empty resultList }"><input type="hidden" id="empty_resultList" /></c:if>
						<c:forEach items="${resultList }" var="resultInfo" varStatus="status">                         		
						<tr>
						<c:if test="${not empty param.sel_area}">
							<td id='rowspan' class='tac'>
							<c:if test="${param.sel_area == 'A' }">${resultInfo.AREA_NM }</c:if>
							<c:if test="${param.sel_area == 'C' }">${resultInfo.ABRV }</c:if>
							</td>
						</c:if>
						<c:if test="${not empty param.induty_select}">
							<td class='tal'>
							<!-- sub sum 데이터셋 처리 됬을 때 --> 
							<c:if test="${param.searchInduty == 'I' or resultInfo.gbnIs == 'S' }">${resultInfo.indutySeNm }</c:if>
							<c:if test="${param.searchInduty == 'T' and resultInfo.gbnIs == 'D' }">&emsp;&emsp;&emsp;${resultInfo.dtlclfc_nm }</c:if>
							<c:if test="${param.searchInduty == 'D' and resultInfo.gbnIs == 'D' }">&emsp;&emsp;&emsp;${resultInfo.korean_nm }</c:if>
							
							<!-- 현재 리스트를 출력하기 위한 처리 --> 
							<c:if test="${param.induty_select == 'I'}">${resultInfo.INDUTY_GUBUN }</c:if>
							<c:if test="${param.induty_select == 'T'}">&emsp;&emsp;&emsp;${resultInfo.DTLCLFC_NM }</c:if>
							<c:if test="${param.induty_select == 'D'}">&emsp;&emsp;&emsp;${resultInfo.KOREAN_NM }</c:if>
							</td>
						</c:if>
							<td class='tar'><fmt:formatNumber value="${resultInfo.ENTRPRS_CO }"/></td>
							<td class='tar'><fmt:formatNumber value="${resultInfo.SELNG_AM }"/></td>
							<td class='tar'><fmt:formatNumber value="${resultInfo.SELNG_RT }"/></td>
							<td class='tar'><fmt:formatNumber value="${resultInfo.ORDTM_LABRR_CO }"/></td>
							<td class='tar'><fmt:formatNumber value="${resultInfo.ORDTM_RT }"/></td>
							<td class='tar'><fmt:formatNumber value="${resultInfo.XPORT_AM_WON }"/></td>
							<td class='tar'><fmt:formatNumber value="${resultInfo.XPORT_AM_WON_RT }"/></td>
							<td class='tar'><fmt:formatNumber value="${resultInfo.RSRCH_DEVLOP_CT }"/></td>
							<td class='tar'><fmt:formatNumber value="${resultInfo.RSRCH_RT }"/></td>
						</tr>
						</c:forEach>      
				    </tbody>
                </table>
     		</div>
	        
	        <div class="btn_page_last"> 
	        	<a class="btn_page_admin" href="javascript:window.print();"><span>인쇄</span></a> 
	        	<a class="btn_page_admin" href="#" onclick="parent.$.fn.colorbox.close();"><span>닫기</span></a>
	        </div>
	        <br><br>
	    </div>
	    <!--리스트영역 //-->
	</div>
	<!--content//-->
	</div>
</div>
</form>
</body>
</html>