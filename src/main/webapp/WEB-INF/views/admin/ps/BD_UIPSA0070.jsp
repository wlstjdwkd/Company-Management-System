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
<ap:jsTag type="web" items="jquery,colorboxAdmin,cookie,form,jqGrid,selectbox,timer,tools,ui,validate,multiselect,msgBoxAdmin" />
<ap:jsTag type="tech" items="util,acm,ps" />
<script type="text/javascript">

$(document).ready(function(){	
	gnb_menu();
	lnb();
	tbl_faq();
	//tabwrap();
	
	/* var form = document.dataForm;
	var lastYear= Util.date.getLocalYear();
	
	setSelectBoxYear('sel_target_year',lastYear, null, '${param.sel_target_year}');
	setSelectBoxYear('from_sel_target_year',lastYear, null, '${param.from_sel_target_year}');
	setSelectBoxYear('to_sel_target_year',lastYear, null, '${param.to_sel_target_year}'); */
	
	
	//엑셀 다운로드
	$("#excelDown").click(function(){
		var searchCondition = jQuery("#searchCondition").val();
		var sel_target_year = jQuery("#sel_target_year").val();
		
		//form.limitUse.value = "Y";
    	jsFiledownload("/PGPS0070.do","df_method_nm=excelRsolver&searchCondition="+searchCondition+"&sel_target_year="+sel_target_year);
    });
	
	
	/* //그리드 리사이즈
	$(window).bind('resize', function() {
		resizeJqGridWidth();
	}).trigger('resize');
	
	
	//현황 그리드
	$("#grid_sttus_list").jqGrid({        
	   	url:'PGPS0070.do?df_method_nm=getGridSttusList',
		datatype: "json",
		colNames:['구분','구분', '중견', '중소', '대기업', '전체', '비고'],
		colModel:[
	   		{name:'CODE_NM',index:'CODE_NM', width:100},
	   		{name:'GUBUN',index:'GUBUN', width:100},
	   		{name:'HPE_VALUE',index:'HPE_VALUE', width:80, align:"right",sorttype:"float"},
	   		{name:'SMLPZ_VALUE',index:'SMLPZ_VALUE', width:80, align:"right",sorttype:"float", summaryType:'avg', summaryTpl:'<b>avg: {0}</b>'},
	   		{name:'LTRS_VALUE',index:'LTRS_VALUE', width:80, align:"right",sorttype:"float"},
	   		{name:'ALL_V',index:'ALL_V', width:80, align:"right",sorttype:"float"},
	   		{name:'CODE_DC',index:'CODE_DC', width:150},
	   	],
	   	rowNum:'${rowNum}',
	   	cmTemplate: { sortable: false },
	   	//rowList:[10,20,30],
	   	//pager: '#grid_sttus_pager',
	   	sortname: 'CODE_NM',
	    viewrecords: false,
	    sortorder: "desc",
	    loadonce: false,
		jsonReader: {
			repeatitems : false
		},
		height: '100%',
	}); */
		
});

//jqGrid 리사이징
function resizeJqGridWidth(){
	$.timer(100, function (timer) {
		var grid_id = "grid_sttus_list";
		var div_id = "baseGridWidth";	 	
	 	$('#' + grid_id).setGridWidth($('#' + div_id).width()-10 , true);
	 	timer.stop();
	});
}

/*
* 목록 검색
*/
//현황 검색
function search_list() {
	/* var searchCondition = jQuery("#searchCondition").val();
	var sel_target_year = jQuery("#sel_target_year").val();
	
	jQuery("#grid_sttus_list").jqGrid('setGridParam',{url:"PGPS0070.do?df_method_nm=getGridSttusList&searchCondition="+searchCondition
			+"&sel_target_year="+sel_target_year
			,page:1}).trigger("reloadGrid"); */
	$("#df_method_nm").val("");
	$("#dataForm").submit();
}


//차트 popup
var implementInsertForm = function() {
	var searchCondition = jQuery("#searchCondition").val();
	var sel_target_year = jQuery("#sel_target_year").val();
    
	$.colorbox({
        title : "기업위상분석 현황 챠트",
        href : "PGPS0070.do?df_method_nm=getGridSttusChart&searchCondition="+searchCondition+"&sel_target_year="+sel_target_year,
        width : "800px",
        height : "550px",
        iframe : true,
        overlayClose : false,
        escKey : false
    });
};


//출력 popup
var output = function() {
	var searchCondition = jQuery("#searchCondition").val();
	var sel_target_year = jQuery("#sel_target_year").val();
    
	$.colorbox({
        title : "기업위상분석 현황 출력",
        href : "PGPS0070.do?df_method_nm=outputIdx&searchCondition="+searchCondition+"&sel_target_year="+sel_target_year,
        width : "80%",
        height : "100%",
        iframe : true,
        overlayClose : false,
        escKey : false
    });
};


function idx_detail_view(pcode) {
	var form = document.dataForm;
	if(pcode == "0070"){
		form.df_method_nm.value = "";
	}else if(pcode == "0071"){
		form.df_method_nm.value = "goIdxList2";
	}
	
	form.df_curr_page.value = 1;
	form.submit();
}
</script>
</head>
<body>
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
                <h2 class="menu_title">기업위상</h2>
                <!-- 타이틀 영역 //-->
                <!--// tab -->
                <div class="tabwrap">
                    <div class="tab">
                        <ul>
                            <li class="on" onclick="idx_detail_view('0070');"><a href="#">현황</a></li><li onclick="idx_detail_view('0071');"><a href="#">추이</a></li>
                        </ul>
                    </div>
                    <div class="tabcon" style="display: block;">
                        <!--// 현황 조회 조건 -->
                        <div class="search_top">
                            <table cellpadding="0" cellspacing="0" class="table_search" summary="기업군 년도 현황 조회 조건" >
                                <caption>조회 조건
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
                                    	<select name="searchCondition" title="기업군" style="width:200px">
		                                    <option value="EA1" selected>전체기업</option>
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
                                        <p class="btn_src_zone"><a href="#" class="btn_search" onclick="search_list()">조회</a></p>                                        
                                    </td>
                                </tr>
                            </table>
                    </div>
                        <!-- // 리스트영역-->
                        <div class="block">
                            <div class="btn_page_middle"> 
	                            <a class="btn_page_admin" href="#" onclick="implementInsertForm();"><span>챠트</span></a>
		                        <a class="btn_page_admin" href="#"><span id="excelDown">엑셀다운로드</span></a> 
		                        <a class="btn_page_admin" href="#" onclick="output();"><span>출력</span></a>
                            </div>
                            
                           	<div class="list_zone" id="div_data_table">
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
		                            </colgroup>
		                            <thead>		                                
		                                <tr>
		                                    <th scope="col" colspan="2">구분</th>		                                    
		                                    <th scope="col">중견</th>
		                                    <th scope="col">중소</th>
		                                    <th scope="col">대기업</th>
		                                    <th scope="col">전체</th>
		                                    <th scope="col">비고</th>		                                                                       
		                                </tr>
		                            </thead>
		                            <tbody>
		                            	<c:forEach items="${resultList}" var="resultInfo" varStatus="status" begin="0">
		                            	<tr>
		                            		<c:if test="${status.index%2 == 0}">
		                            		<td rowspan="2">${resultInfo.CODE_NM }</td>
		                            		</c:if>
											<td class='none' style="text-align: center">${resultInfo.GUBUN }</td>
											<td class='tar'>
												<c:choose>
												<c:when test="${fn:indexOf(resultInfo.HPE_VALUE, '%') > -1}">${resultInfo.HPE_VALUE }</c:when>
												<c:otherwise><fmt:formatNumber value="${resultInfo.HPE_VALUE }"/></c:otherwise>
												</c:choose>
											</td>
											<td class='tar'>
												<c:choose>
												<c:when test="${fn:indexOf(resultInfo.SMLPZ_VALUE, '%') > -1}">${resultInfo.SMLPZ_VALUE }</c:when>
												<c:otherwise><fmt:formatNumber value="${resultInfo.SMLPZ_VALUE }"/></c:otherwise>
												</c:choose>
											</td>
											<td class='tar'>
												<c:choose>
												<c:when test="${fn:indexOf(resultInfo.LTRS_VALUE, '%') > -1}">${resultInfo.LTRS_VALUE }</c:when>
												<c:otherwise><fmt:formatNumber value="${resultInfo.LTRS_VALUE }"/></c:otherwise>
												</c:choose>
											</td>
											<td class='tar'>
												<c:choose>
												<c:when test="${fn:indexOf(resultInfo.ALL_V, '%') > -1}">${resultInfo.ALL_V }</c:when>
												<c:otherwise><fmt:formatNumber value="${resultInfo.ALL_V }"/></c:otherwise>
												</c:choose>
											</td>
											<c:if test="${status.index%2 == 0}">
		                            		<td rowspan="2">${resultInfo.CODE_DC }</td>
		                            		</c:if>																					
										</tr>
										</c:forEach>                                 
		                            </tbody>
		                        </table>
			            	</div>
			            	
                        </div>
                        <!--리스트영역 //-->
                    </div>
                </div>
                <!--tab //-->
            </div>
        </div>
    </div>
    <!--content//-->
</form>
</body>
</html>