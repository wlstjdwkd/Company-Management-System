<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
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
	
	$.ajax({
        url:'PGPS0062.do?df_method_nm=processGetGridSttusMain2&sel_target_year='+sel_target_year,
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
                    ColModel1.push({name:result.value.colModelList[0],index:result.value.colModelList[0], width:85});
                     for (var j = 1; j<result.value.colModelList.length; j++) {
                    	 ColModel1.push({name:result.value.colModelList[j],index:result.value.colModelList[j], align:"right", width:85});
                      }
                    
                    $("#grid_sttus_list3").jqGrid('GridUnload');
                    
                  //기업현황 그리드
                	$("#grid_sttus_list3").jqGrid({
                		url:'PGPS0062.do?df_method_nm=processGetGridSttusList2&sel_target_year='+sel_target_year,
                		datatype: "json",
                		colNames:colN,
                	   	colModel:ColModel1,
                        height: "auto",
                	    //rowNum:10,
                	   	//rowList:[10,20,30],
                	   	//pager: '#grid_sttus_pager',
                	   	sortname: 'CODE_NM',
                	    //viewrecords: true,
                	    gridview: true,
                	    sortorder: "desc",
                	    loadonce: false,
                		jsonReader: {
                			repeatitems : false
                		},
                		height: '100%',
                	});
                	jQuery("#grid_sttus_list3").jqGrid('setGroupHeaders', {
                		useColSpanStyle: true,
                		groupHeaders:[
                			{startColumnName: 'SELNG_GROWTH5', numberOfColumns: 2, titleText: '매출액증가율'},
                			{startColumnName: 'XPORT_GROWTH5', numberOfColumns: 2, titleText: '수출액증가율'},
                			{startColumnName: 'ORDTM_GROWTH5', numberOfColumns: 2, titleText: '고용증가율'},
                			{startColumnName: 'RSRCH_GROWTH5', numberOfColumns: 2, titleText: 'R&D증가율'},
                			{startColumnName: 'BSN_GROWTH5', numberOfColumns: 2, titleText: '영업이익증가율'}
                		]
                	});
                }
            }
        },
        error: function (xhr, ajaxOptions, thrownError) {
            if (xhr && thrownError) {
                alert('Status: ' + xhr.status + ' Error: ' + thrownError);
            }
        }
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
	        
	        <c:set var="curYear" value="${fn:substring(sel_target_year, 2, 4) }" />
            <c:set var="bef4Year" value="${fn:substring(sel_target_year-4, 2, 4) }" />
            <c:set var="bef2Year" value="${fn:substring(sel_target_year-2, 2, 4) }" />
	        
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
					<col width="*" />
					<col width="*" />
					<col width="*" />
					<col width="*" />                            
				</colgroup>
				<thead>		                                
				    <tr>
				        <th scope="col" rowspan="2">구분</th>		                                    
				        <th scope="col" colspan="2">매출액증가율</th>
				        <th scope="col" colspan="2">수출액증가율</th>
				        <th scope="col" colspan="2">고용증가율</th>
				        <th scope="col" colspan="2">R&#38;D증가율</th>
				        <th scope="col" colspan="2">영업이익증가율</th>		                                                                       
				    </tr>
    				<tr>
    					<th>'${bef4Year}~ '${curYear}</th>
						<th>'${bef2Year}~ '${curYear}</th>
						<th>'${bef4Year}~ '${curYear}</th>
						<th>'${bef2Year}~ '${curYear}</th>
						<th>'${bef4Year}~ '${curYear}</th>
						<th>'${bef2Year}~ '${curYear}</th>
						<th>'${bef4Year}~ '${curYear}</th>
						<th>'${bef2Year}~ '${curYear}</th>
						<th>'${bef4Year}~ '${curYear}</th>
						<th>'${bef2Year}~ '${curYear}</th>
    				</tr>
				</thead>
				<tbody>
					<c:forEach items="${entprsList}" var="resultInfo" varStatus="status" begin="0">
					<tr>
						<td>${resultInfo.CODE_NM }</td>
						<td class='tar'>${resultInfo.SELNG_GROWTH5 }</td>
						<td class='tar'>${resultInfo.SELNG_GROWTH3 }</td>
						<td class='tar'>${resultInfo.XPORT_GROWTH5 }</td>
						<td class='tar'>${resultInfo.XPORT_GROWTH3 }</td>
						<td class='tar'>${resultInfo.ORDTM_GROWTH5 }</td>
						<td class='tar'>${resultInfo.ORDTM_GROWTH3 }</td>		                            		
						<td class='tar'>${resultInfo.RSRCH_GROWTH5 }</td>
						<td class='tar'>${resultInfo.RSRCH_GROWTH3 }</td>
						<td class='tar'>${resultInfo.BSN_GROWTH5 }</td>
						<td class='tar'>${resultInfo.BSN_GROWTH3 }</td>
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