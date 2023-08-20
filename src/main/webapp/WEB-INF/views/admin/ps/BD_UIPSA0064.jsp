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
	
	setSelectBoxYear('sel_target_year',lastYear, null, '${param.sel_target_year}');
	
	//엑셀 다운로드
	$("#excelDown").click(function(){
		var searchCondition = jQuery("#searchCondition").val();
		var sel_target_year = jQuery("#sel_target_year").val();
		var multiSelectGrid1 = jQuery("#multiSelectGrid1").val();
		var multiSelectGrid2 = jQuery("#multiSelectGrid2").val();
		
		//form.limitUse.value = "Y";
    	jsFiledownload("/PGPS0064.do","df_method_nm=excelRsolver&searchCondition="+searchCondition+"&sel_target_year="+sel_target_year);
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
	   	url:'PGPS0064.do?df_method_nm=getGridSttusList',
		datatype: "json",
		colNames:['회귀유형', '07->08', '08->09', '09->10', '10->11', '11->12', '12->13', '계'],
	   	colModel:[
	   		{name:'COL0',index:'COL0', width:80},
	   		{name:'COL1',index:'COL1', width:80, align:"right",sorttype:"float"},
	   		{name:'COL2',index:'COL2', width:80, align:"right",sorttype:"float"},
	   		{name:'COL3',index:'COL3', width:80, align:"right",sorttype:"float"},
	   		{name:'COL4',index:'COL4', width:80, align:"right",sorttype:"float"},
	   		{name:'COL5',index:'COL5', width:80, align:"right",sorttype:"float"},
	   		{name:'COL6',index:'COL6', width:80, align:"right",sorttype:"float"},
	   		{name:'COL7',index:'COL7', width:80, align:"right",sorttype:"float"},
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
	jQuery("#grid_sttus_list").jqGrid('setGroupHeaders', {
		useColSpanStyle: true,
		groupHeaders:[
			{startColumnName: 'COL3', numberOfColumns: 2, titleText: '매출(천원)'},
			{startColumnName: 'COL5', numberOfColumns: 2, titleText: '고용(만명)'},
			{startColumnName: 'COL7', numberOfColumns: 2, titleText: '수출(억불)'},
			{startColumnName: 'COL9', numberOfColumns: 2, titleText: '연구개발비'},
		]
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
	var sel_target_year = jQuery("#sel_target_year").val();
	var induty_select = jQuery("#induty_select").val();
	var multiSelectGrid1 = jQuery("#multiSelectGrid1").val();
	var multiSelectGrid2 = jQuery("#multiSelectGrid2").val();
	
	jQuery("#grid_sttus_list").jqGrid('setGridParam',{url:"PGPS0064.do?df_method_nm=getGridSttusList&searchCondition="+searchCondition
		+"&sel_target_year="+sel_target_year+"&induty_select="+induty_select+"&multiSelectGrid1="+multiSelectGrid1+"&multiSelectGrid2="+multiSelectGrid2
		,page:1}).trigger("reloadGrid");
}

//차트 popup
var implementInsertForm = function() {
	var searchCondition = jQuery("#searchCondition").val();
	var sel_target_year = jQuery("#sel_target_year").val();
    
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
	var sel_target_year = jQuery("#sel_target_year").val();
    
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

//업종 selectbox 선택 시
function selectInduty(indt){
	var form = document.all;
	
	if(form.induty_select.value=="0"){
		form.induty_info1.style.display='none';
		form.induty_info2.style.display='none';
	}else if(form.induty_select.value=="1"){
		form.induty_info1.style.display='inline-block'; 
		form.induty_info2.style.display='none';
	}else{
		form.induty_info1.style.display='none';
		form.induty_info2.style.display='inline-block';
	}
}


function idx_detail_view(pcode) {
	var form = document.dataForm;
	if(pcode == "0050"){
		form.df_method_nm.value = "";
	}else if(pcode == "0051"){
		form.df_method_nm.value = "goIdxList2";
	}else if(pcode == "0052"){
		form.df_method_nm.value = "goIdxList3";
	}else if(pcode == "0053"){
		form.df_method_nm.value = "goIdxList4";
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
                <h2 class="menu_title">업종별 성장현황</h2>
                <!-- 타이틀 영역 //-->
                <!--// 현황 조회 조건 -->
                <div class="search_top">
                    <table cellpadding="0" cellspacing="0" class="table_search" summary="기업군 년도 업종 지역 지표 현황 조회 조건" >
                        <caption>
                        현황 조회 조건
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
                            	<ap:code id="searchCondition" name="searchCondition" grpCd="14" type="select" selectedCd="${param.searchCondition}" />
                            </td>
                            <th scope="row">년도</th>
                            <td>
                            	<select id="sel_target_year" name="sel_target_year" style="width:101px; "></select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">업종</th>
                            <td>
                             	<select name="induty_select" title="검색조건선택" style="width:100px" onchange="selectInduty(this.value);">
                                    <option selected="selected" value="0">-- 선택 --</option>
                                    <option value="1">제조/비제조</option>
                                    <option value="2">업종테마별</option>
                                    <option value="3">상세업종별</option>
                                </select>
                             		<div id="induty_info1">
                                <select multiple="multiple" id="multiSelectGrid1" name="mSelGridGrp_1" style="width: 200px;">
						            <option value="UT00" selected="selected">전산업</option>
						            <option value="UT01">제조업</option>
						            <option value="UT02">비제조업</option>
						    	</select>
						    	</div>
						    	<div id="induty_info2">
						    	<select multiple="multiple" id="multiSelectGrid2" name="mSelGridGrp_2" style="width: 200px">
						            <optgroup label="제조업">
						            	<c:forEach items="${indutyCode}" var="indutyCode" varStatus="status">
						            		<c:if test="${fn:length(indutyCode.code) > 4}">
						            		<c:if test="${fn:indexOf(indutyCode.code, 'UT01') > -1}">
							            		<option value="'${indutyCode.code}'" >${indutyCode.codeNm}</option>
							            	</c:if>
							            	</c:if>
							            </c:forEach>
							        </optgroup>		        
							        <optgroup label="비제조업">
							        	<c:forEach items="${indutyCode}" var="indutyCode" varStatus="status">
							        		<c:if test="${fn:length(indutyCode.code) > 4}">
						            		<c:if test="${fn:indexOf(indutyCode.code, 'UT02') > -1}">
							            		<option value="'${indutyCode.code}'" >${indutyCode.codeNm}</option>
							            	</c:if>
							            	</c:if>
							            </c:forEach>
							        </optgroup>
						    	</select> 
							    </div>
                               </td>
                            <th scope="row">지역</th>
                            <td><select name="" title="검색조건선택" id="" style="width:110px">
                                    <option selected="selected" value="0">권역</option>
                                </select>
                                <select name="" title="검색조건선택" id="" style="width:150px">
                                    <option selected="selected" value="0">수도권, 충청권</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">지표</th>
                            <td colspan="3">
                            	<select name="" title="검색조건선택" id="" style="width:110px">
                                    <option selected="selected" value="0">총액</option>
                                </select>
                                <select name="" title="검색조건선택" id="" style="width:510px">
                                    <option selected="selected" value="0">기업수,총매출, 총고용, 총수출, R&amp;D 집약도, 업력,당기순이익,영업이익 </option>
                                </select>
                                <!-- 
                                <input type="checkbox" name="view" id="view_1" value="1" checked="checked" />
                                <label for="view_1">비율보기</label>
                                 -->
                                <p class="btn_src_zone"><a href="#" class="btn_search" onclick="search_list()">조회</a></p>
                            </td>
                        </tr>
                    </table>
                </div>
                <!-- // 리스트영역-->
                <div class="block">
                    <h3 class="middle">기업전체</h3>
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
            </div>
            <!--content//-->
        </div>
    </div>
</div>
<!--container//-->
</form>
</body>
</html>