<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,colorboxAdmin,cookie,form,jqGrid,timer,tools,selectbox,ui,validate" />
<ap:jsTag type="tech" items="util,acm,ps" />
<script type="text/javascript">

$(document).ready(function(){
	gnb_menu();
	lnb();
	tbl_faq();
	//tabwrap();
	
	/* var form = document.dataForm;
	var lastYear= Util.date.getLocalYear()-1;
	
	setSelectBoxYear('sel_target_year2',lastYear, null, '${param.sel_target_year2}'); */
	
	//엑셀 다운로드
	$("#excelDown2").click(function(){
		var searchCondition = jQuery("#searchCondition2").val();
		var sel_target_year = jQuery("#sel_target_year2").val();
		
		//form.limitUse.value = "Y";
    	jsFiledownload("/PGPS0062.do","df_method_nm=excelRsolver2&searchCondition="+searchCondition+"&sel_target_year="+sel_target_year);
    });
	
	/* //그리드 리사이즈
	$(window).bind('resize', function() {
		resizeJqGridWidth(); 
	}).trigger('resize');
	
	//성장현황 그리드
	$.ajax({
	        url:'PGPS0062.do?df_method_nm=processGetGridSttusMain2',
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
	                    ColModel1.push({name:result.value.colModelList[0],index:result.value.colModelList[0], width:100});			// 구분
	                     for (var j = 1; j<result.value.colModelList.length; j++) {
	                    	 ColModel1.push({name:result.value.colModelList[j],index:result.value.colModelList[j], align:"right", width:85});		// 나머지
	                      }
	                    
	                    $("#grid_sttus_list2").jqGrid('GridUnload');
	                    
	                  //기업현황 그리드
	                	$("#grid_sttus_list2").jqGrid({
	                		url:'PGPS0062.do?df_method_nm=processGetGridSttusList2',
	                		datatype: "json",
	                		colNames:colN,
	                	   	colModel:ColModel1,
	                        height: "auto",
	                	    //rowNum:10,
	                	   	//rowList:[10,20,30],
	                	   	//pager: '#grid_sttus_pager',
	                	   	cmTemplate: { sortable: false },
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
	                	jQuery("#grid_sttus_list2").jqGrid('setGroupHeaders', {
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
	
	// 조회
	$("#btn_search").click(function() {
		$("#df_method_nm").val("goIdxList2");
		$("#dataForm").submit();
	});
	
});

//jqGrid 리사이징
function resizeJqGridWidth(){
	$.timer(100, function (timer) {
		var grid_id = "grid_sttus_list";
		var div_id = "baseGridWidth";		 	
	 	$('#grid_sttus_list2').setGridWidth($('#baseGridWidth').width()-10 , true);
		timer.stop();
	});
}
/*
* 목록 검색
*/
// 진입시기별분석 > 성장현황 검색
function search_list2() {
	var form = document.all;
	
	var searchCondition = form.searchCondition2.value;
	var sel_target_year = jQuery("#sel_target_year2").val();
	
	//그리드 리사이즈
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
                    ColModel1.push({name:result.value.colModelList[0],index:result.value.colModelList[0], width:100});
                     for (var j = 1; j<result.value.colModelList.length; j++) {
                    	 ColModel1.push({name:result.value.colModelList[j],index:result.value.colModelList[j], align:"right", width:85});
                      }
                    
                    $("#grid_sttus_list2").jqGrid('GridUnload');
                    
                  //기업현황 그리드
                	$("#grid_sttus_list2").jqGrid({
                		url:'PGPS0062.do?df_method_nm=processGetGridSttusList2&sel_target_year='+sel_target_year,
                		datatype: "json",
                		colNames:colN,
                	   	colModel:ColModel1,
                        height: "auto",
                        cmTemplate: { sortable: false },
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
                	jQuery("#grid_sttus_list2").jqGrid('setGroupHeaders', {
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
	});
	
}

//출력 popup
var output2 = function() {
	var form = document.all;
	
	var searchCondition = form.searchCondition.value;
	var sel_target_year = jQuery("#sel_target_year").val();
    
	$.colorbox({
        title : "진입시기별분석 성장현황",
        href : "PGPS0062.do?df_method_nm=outputIdx2&searchCondition="+searchCondition+"&sel_target_year="+sel_target_year,
        width : "80%",
        height : "100%",
        iframe : true,
        overlayClose : false,
        escKey : false
    });
};

function idx_detail_view(pcode) {
	var form = document.dataForm;
	if(pcode == "0062"){
		form.df_method_nm.value = "";
	}else if(pcode == "0062_2"){
		form.df_method_nm.value = "goIdxList2";
	}
	
	form.submit();
}
</script>
</head>

<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />
<ap:include page="param/pagingParam.jsp" />
<input name="limitUse" type="hidden" value="">

<!--//content-->
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">성장 및 회귀현황 진입시기별 성장현황 </h2>
                <!-- 타이틀 영역 //-->
                <!--// tab -->
                <div class="tabwrap">
                    <div class="tab">
                        <ul>
                            <li onclick="idx_detail_view('0062');"><a href="#">현황</a></li><li class="on" onclick="idx_detail_view('0062_2');"><a href="#">성장현황</a></li>
                        </ul>
                    </div>
                    <div class="tabcon" style="display:block;">
                        <!--// 조회 조건 -->
                        <div class="search_top">
                            <table cellpadding="0" cellspacing="0" class="table_search" summary="기업군 년도 조회 조건" >
                                <caption>
                                조회 조건
                                </caption>
                                <colgroup>
                                <col width="10%" />
                                <col width="40%" />
                                <col width="10%" />
                                <col width="40%" />
                                </colgroup>
                                <tr>
                                    <th scope="row">기업군</th>
                                    <td>
                                    	<select id="searchCondition" name="searchCondition" title="검색조건선택" id="" style="width:110px">
				                        <option selected="selected" value="EA2">일반기업</option>
				                    </select>
                                    </td>
                                    <th scope="row">년도</th>
                                    <td>
                                    	<select id="sel_target_year" name="sel_target_year" style="width:101px; ">
                                    	<c:if test="${fn:length(stdyyList) == 0 }"><option value="">자료없음</option></c:if>
		                               	<c:forEach items="${stdyyList }" var="year" varStatus="status">
		                                	<option value="${year.stdyy }"<c:if test="${year.stdyy eq targetYear}"> selected="selected"</c:if>>${year.stdyy }년</option>
		                               	</c:forEach>
                                    	</select>
                                    	</select>
                                        <p class="btn_src_zone"><a href="#" class="btn_search" id="btn_search">조회</a></p></td>
                                </tr>
                            </table>
                        </div>
                        <!-- // 리스트영역-->
                        <div class="block">
                            <div class="btn_page_middle"> <span class="mgr20">(단위: 개,%) </span> 
                            <a class="btn_page_admin" href="#"><span id="excelDown2">엑셀다운로드</span></a> 
	                        <a class="btn_page_admin" href="#" onclick="output2();"><span>출력</span></a>
	                        </div>                     
                            
                            <c:set var="curYear" value="${fn:substring(targetYear, 2, 4) }" />
                            <c:set var="bef4Year" value="${fn:substring(targetYear-4, 2, 4) }" />
                            <c:set var="bef2Year" value="${fn:substring(targetYear-2, 2, 4) }" />
                            
                            <div class="list_zone">
		                       <table cellspacing="0" border="0" summary="기업통계" class="list" id="tblStatics">
		                           <caption>
		                            리스트
		                            </caption>
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
                            
                            
                        <!-- 리스트영역 //-->
                		</div>
                	</div>
                <!--tab //-->
            	</div>
        	</div>
    	</div>
	</div>
<!--content//-->
</form>
</body>
</html>