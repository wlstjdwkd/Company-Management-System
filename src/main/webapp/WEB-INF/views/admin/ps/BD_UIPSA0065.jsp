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
<ap:jsTag type="web" items="jquery,cookie,form,jqGrid,timer,tools,selectbox,ui,validate,multiselect" />
<ap:jsTag type="tech" items="util,acm,ps" />
<script type="text/javascript">

$(document).ready(function(){
	gnb_menu();
	lnb();
	tbl_faq();
	tabwrap();
	
	var form = document.dataForm;
	var lastYear= Util.date.getLocalYear()-1;
	
	setSelectBoxYear('from_sel_target_year',lastYear, null, '${param.from_sel_target_year}');
	setSelectBoxYear('to_sel_target_year',lastYear, null, '${param.to_sel_target_year}');
	
	//엑셀 다운로드
	$("#excelDown").click(function(){
		var searchCondition = jQuery("#searchCondition").val();
		var from_sel_target_year = jQuery("#from_sel_target_year").val();
		var to_sel_target_year = jQuery("#to_sel_target_year").val();
		var multiSelectGrid1 = jQuery("#multiSelectGrid1").val();
		var multiSelectGrid2 = jQuery("#multiSelectGrid2").val();
		
		//form.limitUse.value = "Y";
    	jsFiledownload("/PGPS0065.do","df_method_nm=excelRsolver&searchCondition="+searchCondition+"&sel_target_year="+sel_target_year);
    });
	
	//멀티 셀렉트
    var multipleSelectSetting = {
    		selectAllText : "전체선택",
        	allSelected : "전체선택",
        	filter: true
    }
	
	$("select[name^='mSelGridGrp']").multipleSelect(multipleSelectSetting);
    $("#induty_info1").hide();
    $("#induty_info2").hide();
	
	//그리드 리사이즈
	$(window).bind('resize', function() {
		resizeJqGridWidth(); 
	}).trigger('resize');
	
	//현황 그리드
	$("#grid_sttus_list").jqGrid({        
	   	url:'PGPS0065.do?df_method_nm=getGridSttusList',
		datatype: "json",
		colNames:['기존기준', '구분', '12년 후보<br>13년 중견', '13년 후보<br>14년 중견'],
	   	colModel:[
	   		{name:'COL0',index:'COL0', width:100},
	   		{name:'COL1',index:'COL1', width:100},
	   		{name:'COL2',index:'COL2', width:100, align:"right",sorttype:"float"},
	   		{name:'COL3',index:'COL3', width:100, align:"right",sorttype:"float"},
	   	],
	   //	rowNum:10,
	   	rowList:[10,20,30],
	   	//pager: '#grid_sttus_pager',
	   	height: 'auto',
	   	sortname: 'COL0',
	    viewrecords: true,
	    sortorder: "desc",
	    loadonce: false,
		jsonReader: {
			repeatitems : false
		},
		caption: "현황",
		height: '100%',
	});
	
	//현황 그리드
	$("#grid_sttus_list2").jqGrid({        
	   	url:'PGPS0065.do?df_method_nm=getGridSttusList2',
		datatype: "json",
		colNames:['구분', '2012', '2013', '2014'],
	   	colModel:[
	   		{name:'COL0',index:'COL0', width:100},
	   		{name:'COL1',index:'COL1', width:100, align:"right",sorttype:"float"},
	   		{name:'COL2',index:'COL2', width:100, align:"right",sorttype:"float"},
	   		{name:'COL3',index:'COL3', width:100, align:"right",sorttype:"float"},
	   	],
	   //	rowNum:10,
	   	rowList:[10,20,30],
	   	//pager: '#grid_sttus_pager',
	   	sortname: 'COL0',
	    viewrecords: true,
	    sortorder: "desc",
	    loadonce: false,
		jsonReader: {
			repeatitems : false
		},
		caption: "현황",
		height: '100%',
	});
});

//jqGrid 리사이징
function resizeJqGridWidth(){
	$.timer(100, function (timer) {
		var grid_id = "grid_sttus_list";
		var div_id = "baseGridWidth";		 	
	 	$('#' + grid_id).setGridWidth($('#' + div_id).width()-10 , true);
	 	$('#grid_sttus_list2').setGridWidth($('#baseGridWidth').width()-10 , true);
		timer.stop();
	});
}
/*
* 목록 검색
*/
//일반기업 성장현황 > 현황 검색
function search_list() {
	var searchCondition = jQuery("#searchCondition").val();
	var from_sel_target_year = jQuery("#from_sel_target_year").val();
	var to_sel_target_year = jQuery("#to_sel_target_year").val();
	
	jQuery("#grid_sttus_list").jqGrid('setGridParam',{url:"PGPS0065.do?df_method_nm=getGridSttusList&searchCondition="+searchCondition
		+"&from_sel_target_year="+from_sel_target_year+"&to_sel_target_year="+to_sel_target_year
		,page:1}).trigger("reloadGrid");
	
	jQuery("#grid_sttus_list2").jqGrid('setGridParam',{url:"PGPS0065.do?df_method_nm=getGridSttusList2&searchCondition="+searchCondition
		+"&from_sel_target_year="+from_sel_target_year+"&to_sel_target_year="+to_sel_target_year
		,page:1}).trigger("reloadGrid");
}

//차트 popup
var implementInsertForm = function() {
	var searchCondition = jQuery("#searchCondition").val();
	var from_sel_target_year = jQuery("#from_sel_target_year").val();
	var to_sel_target_year = jQuery("#to_sel_target_year").val();
    
	$.colorbox({
        title : "차트 팝업",
        href : "PGPS0100.do?searchCondition="+searchCondition+"&sel_target_year="+sel_target_year,
        width : "80%",
        height : "80%",
        iframe : true,
        overlayClose : false,
        escKey : false
    });
};

//출력 popup
var output = function() {
	var searchCondition = jQuery("#searchCondition").val();
	var from_sel_target_year = jQuery("#from_sel_target_year").val();
	var to_sel_target_year = jQuery("#to_sel_target_year").val();
    
	$.colorbox({
        title : "출력화면 팝업",
        href : "PGPS0100.do?df_method_nm=outputIdx&searchCondition="+searchCondition+"&sel_target_year="+sel_target_year,
        width : "80%",
        height : "80%",
        iframe : true,
        overlayClose : false,
        escKey : false
    });
};

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
                <h2 class="menu_title">후보기업 성장분석</h2>
                <!-- 타이틀 영역 //-->
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
                            	<select name="searchCondition" title="기업군" style="width:100px">
                                    <option value="EA4" selected>후보기업</option>
                                </select>
                            </td>
                            <th scope="row">년도</th>
                            <td>
                            	<select id="from_sel_target_year" name="from_sel_target_year" style="width:101px; "></select>
                                ~
                                <select id="to_sel_target_year" name="to_sel_target_year" style="width:101px; "></select>
                                <p class="btn_src_zone"><a href="#" class="btn_search" onclick="search_list()">조회</a></p></td>
                        </tr>
                    </table>
                </div>
                <!-- // 리스트영역-->
                <div class="block">
                    <h3 class="middle">분류요인 - 규모기준</h3>
                    <div class="btn_page_middle">
                    <a class="btn_page_admin" href="#"><span>챠트</span></a> 
                    <a class="btn_page_admin" href="#"><span>엑셀다운로드</span></a> 
                    <a class="btn_page_admin" href="#"><span>출력</span></a>
                    </div>
                    <!--// grid -->
                    <br>
                    <div id="baseGridWidth">
                  	<table id="grid_sttus_list"></table>
                  	<div id="grid_sttus_pager"></div>
                    </div>
                    <!--grid //-->
                </div>
                <!--리스트영역 //-->
                <!-- // 리스트영역-->
                <div class="block2">
                    <h3 class="middle">진입기준별  중견 후보기업현황</h3>
                    <div class="btn_page_middle">
                    <a class="btn_page_admin" href="#"><span>챠트</span></a> 
                    <a class="btn_page_admin" href="#"><span>엑셀다운로드</span></a> 
                    <a class="btn_page_admin" href="#"><span>출력</span></a>
                    </div>
                    <!--// grid -->
                    <br>
                    <div id="baseGridWidth">
                  	<table id="grid_sttus_list2"></table>
                  	<div id="grid_sttus_pager2"></div>
                    </div>
                    <!--grid //-->
                </div>
                <!--리스트영역 //-->
            </div>
        </div>
    </div>
    <!--content//-->
</div>
<!--container//-->
</form>
</body>
</html>