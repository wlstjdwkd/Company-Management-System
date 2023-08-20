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
<ap:jsTag type="web" items="jquery,colorboxAdmin,cookie,form,jqGrid,timer,tools,selectbox,ui,validate,blockUI,flot" />
<ap:jsTag type="tech" items="util,acm,ps,etc" />
<script type="text/javascript">

$(document).ready(function(){
	gnb_menu();
	lnb();
	tbl_faq();
	tabwrap();
	
	// 로딩 화면
	$(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);	
	
	var form = document.dataForm;
	var lastYear= Util.date.getLocalYear()-1;

	
	//엑셀 다운로드
	$("#excelDown").click(function(){
		var searchCondition = jQuery("#searchCondition").val();
		var from_sel_target_year = jQuery("#from_sel_target_year").val();
		var to_sel_target_year = jQuery("#to_sel_target_year").val();
		
    	jsFiledownload("/PGPS0061.do","df_method_nm=processExcelRsolver&searchCondition="+searchCondition
    			+'&from_sel_target_year='+from_sel_target_year+'&to_sel_target_year='+to_sel_target_year);
    });
	
	//엑셀 다운로드
	$("#excelDown2").click(function(){
		var searchCondition = jQuery("#searchCondition").val();
		var from_sel_target_year = jQuery("#from_sel_target_year").val();
		var to_sel_target_year = jQuery("#to_sel_target_year").val();
		
    	jsFiledownload("/PGPS0061.do","df_method_nm=processExcelRsolver2&searchCondition="+searchCondition
    			+'&from_sel_target_year='+from_sel_target_year+'&to_sel_target_year='+to_sel_target_year);
    });
	

	/* //그리드 리사이즈
	$(window).bind('resize', function() {
		resizeJqGridWidth(); 
	}).trigger('resize');
	
	//분류요인 그리드
	$.ajax({
        url:'PGPS0061.do?df_method_nm=processGetGridSttusMain',
        dataType: "json",
        type: 'POST',
        async: false,
        success: function (result) {

            if (result) {

                if (!result.Error) {

                    var colM = result.value.colModelList;
                    var colN = result.value.columnNames;
                    
                    var ColModel1 = [];
                    ColModel1.push({name:result.value.colModelList[0],index:result.value.colModelList[0], width:80});
                    ColModel1.push({name:result.value.colModelList[1],index:result.value.colModelList[1], width:80, summaryType:'count', summaryTpl:'합계'});
                     for (var j = 2; j<result.value.colModelList.length; j++) {
                    	 ColModel1.push({name:result.value.colModelList[j],index:result.value.colModelList[j], width:80, align:"right", summaryType:'sum', formatter:'integer'});
                      }
                    
                    $("#grid_sttus_list").jqGrid('GridUnload');
                    alert(2);
                    //기업현황 그리드
                	$("#grid_sttus_list").jqGrid({
                		url:'PGPS0061.do?df_method_nm=processGetGridSttusList',
                		datatype: "json",
                		colNames:colN,
                	   	colModel:ColModel1,
                	   	formatter:{
                	   		integer : {thousandsSeparator:",", defaultValue:'0'} 
                	   	},
                        height: "auto",
                        cmTemplate: { sortable: false },
                	    //rowNum:10,
                	   	//rowList:[10,20,30],
                	   	//pager: '#grid_sttus_pager',
                	   	//sortname: 'ABRV',
                	    //viewrecords: true,
                	    gridview: true,
                	    //sortorder: "desc",
                	    loadonce: false,
                		jsonReader: {
                			repeatitems : false
                		},
                		grouping:true,
                	   	groupingView : {
                	   		groupField : ['GUBUN'],
                	   		groupSummary : [true],
                	   		//groupColumnShow : [true],
                	   		groupText : ['<b>{0}</b>'],
                	   		groupCollapse : false,
                			groupOrder: ['asc']
                	   	},
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
	
	//분류요인-규모기준 그리드
	$.ajax({
        url:'PGPS0061.do?df_method_nm=processGetGridSttusMain2',
        dataType: "json",
        type: 'POST',
        async: false,
        success: function (result) {

            if (result) {

                if (!result.Error) {

                    var colM = result.value.colModelList;
                    var colN = result.value.columnNames;
                    
                    var ColModel1 = [];
                    ColModel1.push({name:result.value.colModelList[0],index:result.value.colModelList[0], width:80});
                    ColModel1.push({name:result.value.colModelList[1],index:result.value.colModelList[1], width:80});
                     for (var j = 2; j<result.value.colModelList.length; j++) {
                    	 ColModel1.push({name:result.value.colModelList[j],index:result.value.colModelList[j], width:80, align:"right", formatter:'integer'});
                      }
                    
                    $("#grid_sttus_list2").jqGrid('GridUnload');
                    
                    //기업현황 그리드
                	$("#grid_sttus_list2").jqGrid({
                		url:'PGPS0061.do?df_method_nm=processGetGridSttusList2',
                		datatype: "json",
                		colNames:colN,
                	   	colModel:ColModel1,
                		formatter:{
                	   		integer : {thousandsSeparator:",", defaultValue:'0'} 
                	   	},
                        height: "auto",
                        cmTemplate: { sortable: false },
                	    //rowNum:10,
                	   	//rowList:[10,20,30],
                	   	//pager: '#grid_sttus_pager',
                	   	//sortname: 'ABRV',
                	    //viewrecords: true,
                	    gridview: true,
                	    //sortorder: "desc",
                	    loadonce: false,
                		jsonReader: {
                			repeatitems : false
                		},
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
	}); */
		
	// 조회
	$("#btn_search").click(function(){
		getClFctrData();	
	});
	
	getClFctrData();
		
});

function getClFctrData() {
	var to_sel_target_year = $("#to_sel_target_year").val();
	var from_sel_target_year = $("#from_sel_target_year").val()
	
	$("#df_method_nm").val("getClFctr1");
	
	$.ajax({
        url:'PGPS0061.do?df_method_nm=getClFctr1&from_sel_target_year='+from_sel_target_year+'&to_sel_target_year='+to_sel_target_year,
        dataType: "html",        
        async: true,
        type: 'POST',
        success: function (response) {
        	try {
        		var html = $.parseHTML(response);
        		
        		$.each(html, function(i, el) {            		
           			if(el.nodeType==1){
           		  		var clazz = el.getAttribute('class');		           		  		
           		  		if(clazz == "add_table"){		           		  			
           		  			$("#div_data_table1").html(el);
           		  			//if(!$("#empty_resultList")) {		           		  				
           		  				Util.rowSpan($("#tblStatics1"), [1]);
           		  			//}
           		  			return;
           		  		}
           		  	}
        		});
        		
            } catch (e) {
                if(response != null) {
                	jsSysErrorBox(response);
                } else {
                    jsSysErrorBox(e);
                }
                return;
            }
        }
	});	//ajax end
	
	$.ajax({
        url:'PGPS0061.do?df_method_nm=getClFctr2&from_sel_target_year='+from_sel_target_year+'&to_sel_target_year='+to_sel_target_year,
        dataType: "html",        
        async: true,
        type: 'POST',
        success: function (response) {
        	try {
        		var html = $.parseHTML(response);
        		
        		$.each(html, function(i, el) {            		
           			if(el.nodeType==1){
           		  		var clazz = el.getAttribute('class');		           		  		
           		  		if(clazz == "add_table"){		           		  			
           		  			$("#div_data_table2").html(el);
           		  			//if(!$("#empty_resultList")) {		           		  				
           		  				Util.rowSpan($("#tblStatics2"), [1]);
           		  			//}
           		  			return;
           		  		}
           		  	}
        		});
        		
            } catch (e) {
                if(response != null) {
                	jsSysErrorBox(response);
                } else {
                    jsSysErrorBox(e);
                }
                return;
            }
        }
	});	//ajax end
}


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
	var from_sel_target_year = jQuery("#from_sel_target_year").val();
	var to_sel_target_year = jQuery("#to_sel_target_year").val();
	
	//그리드 리사이즈
	$(window).bind('resize', function() {
		resizeJqGridWidth(); 
	}).trigger('resize');
	
	//분류요인 그리드
	$.ajax({
        url:'PGPS0061.do?df_method_nm=processGetGridSttusMain&searchCondition='+searchCondition
        				+'&from_sel_target_year='+from_sel_target_year+'&to_sel_target_year='+to_sel_target_year,
        dataType: "json",
        type: 'POST',
        async: false,
        success: function (result) {

            if (result) {

                if (!result.Error) {

                    var colM = result.value.colModelList;
                    var colN = result.value.columnNames;
                    
                    var ColModel1 = [];
                    ColModel1.push({name:result.value.colModelList[0],index:result.value.colModelList[0], width:80});
                    ColModel1.push({name:result.value.colModelList[1],index:result.value.colModelList[1], width:80, summaryType:'count', summaryTpl:'합계'});
                     for (var j = 2; j<result.value.colModelList.length; j++) {
                    	 ColModel1.push({name:result.value.colModelList[j],index:result.value.colModelList[j], width:80, align:"right", summaryType:'sum'});
                      }
                    
                    $("#grid_sttus_list").jqGrid('GridUnload');
                    
                    //기업현황 그리드
                	$("#grid_sttus_list").jqGrid({
                		url:'PGPS0061.do?df_method_nm=processGetGridSttusList&searchCondition='+searchCondition
        						+'&from_sel_target_year='+from_sel_target_year+'&to_sel_target_year='+to_sel_target_year,
                		datatype: "json",
                		colNames:colN,
                	   	colModel:ColModel1,
                        height: "auto",
                	    //rowNum:10,
                	   	//rowList:[10,20,30],
                	   	//pager: '#grid_sttus_pager',
                	   	//sortname: 'ABRV',
                	    //viewrecords: true,
                	    gridview: true,
                	    //sortorder: "desc",
                	    loadonce: false,
                		jsonReader: {
                			repeatitems : false
                		},
                		grouping:true,
                	   	groupingView : {
                	   		groupField : ['GUBUN'],
                	   		groupSummary : [true],
                	   		//groupColumnShow : [true],
                	   		groupText : ['<b>{0}</b>'],
                	   		groupCollapse : false,
                			groupOrder: ['asc']
                	   	},
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
	
	//분류요인-규모기준 그리드
	$.ajax({
        url:'PGPS0061.do?df_method_nm=processGetGridSttusMain2&searchCondition='+searchCondition
        		+'&from_sel_target_year='+from_sel_target_year+'&to_sel_target_year='+to_sel_target_year,
        dataType: "json",
        type: 'POST',
        async: false,
        success: function (result) {

            if (result) {

                if (!result.Error) {

                    var colM = result.value.colModelList;
                    var colN = result.value.columnNames;
                    
                    var ColModel1 = [];
                    ColModel1.push({name:result.value.colModelList[0],index:result.value.colModelList[0], width:80});
                    ColModel1.push({name:result.value.colModelList[1],index:result.value.colModelList[1], width:80});
                     for (var j = 2; j<result.value.colModelList.length; j++) {
                    	 ColModel1.push({name:result.value.colModelList[j],index:result.value.colModelList[j], width:80, align:"right"});
                      }
                    
                    $("#grid_sttus_list2").jqGrid('GridUnload');
                    
                    //기업현황 그리드
                	$("#grid_sttus_list2").jqGrid({
                		url:'PGPS0061.do?df_method_nm=processGetGridSttusList2&searchCondition='+searchCondition
                					+'&from_sel_target_year='+from_sel_target_year+'&to_sel_target_year='+to_sel_target_year,
                		datatype: "json",
                		colNames:colN,
                	   	colModel:ColModel1,
                        height: "auto",
                	    //rowNum:10,
                	   	//rowList:[10,20,30],
                	   	//pager: '#grid_sttus_pager',
                	   	//sortname: 'ABRV',
                	    //viewrecords: true,
                	    gridview: true,
                	    //sortorder: "desc",
                	    loadonce: false,
                		jsonReader: {
                			repeatitems : false
                		},
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
}


//차트 popup
var implementInsertForm = function() {
	var form = document.all;
	
	var searchCondition = form.searchCondition.value;
	var from_sel_target_year = jQuery("#from_sel_target_year").val();
	var to_sel_target_year = jQuery("#to_sel_target_year").val();
	var df_method_nm = "";
    
	df_method_nm = "getGridSttusChart";
	
	$.colorbox({
        title : "분류요인별분석 분류요인 챠트",
        href : "PGPS0061.do?df_method_nm="+df_method_nm+"&searchCondition="+searchCondition
			+"&from_sel_target_year="+from_sel_target_year+"&to_sel_target_year="+to_sel_target_year,
        width : "80%",
        height : "100%",
        iframe : true,
        overlayClose : false,
        escKey : false
    });
};

//차트 popup (분류요인-규모기준)
var implementInsertForm2 = function() {
	var form = document.all;
	
	var searchCondition = form.searchCondition.value;
	var from_sel_target_year = jQuery("#from_sel_target_year").val();
	var to_sel_target_year = jQuery("#to_sel_target_year").val();
	var df_method_nm = "";
    
	df_method_nm = "getGridSttusChart2";
	
	$.colorbox({
        title : "분류요인별분석 분류요인 규모기준 챠트",
        href : "PGPS0061.do?df_method_nm="+df_method_nm+"&searchCondition="+searchCondition
			+"&from_sel_target_year="+from_sel_target_year+"&to_sel_target_year="+to_sel_target_year,
        width : "80%",
        height : "100%",
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
        title : "분류요인별분석 출력",
        href : "PGPS0061.do?df_method_nm=outputIdx1&searchCondition="+searchCondition
        		+"&from_sel_target_year="+from_sel_target_year+"&to_sel_target_year="+to_sel_target_year,
        width : "80%",
        height : "100%",
        iframe : true,
        overlayClose : false,
        escKey : false
    });
};

var output2 = function() {
	var searchCondition = jQuery("#searchCondition").val();
	var from_sel_target_year = jQuery("#from_sel_target_year").val();
	var to_sel_target_year = jQuery("#to_sel_target_year").val();
    
	$.colorbox({
        title : "분류요인별분석 출력",
        href : "PGPS0061.do?df_method_nm=outputIdx2&searchCondition="+searchCondition
        		+"&from_sel_target_year="+from_sel_target_year+"&to_sel_target_year="+to_sel_target_year,
        width : "80%",
        height : "100%",
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
                <h2 class="menu_title">성장 및 회귀현황 분류요인별분석 </h2>
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
                            	<select id="searchCondition" name="searchCondition" title="검색조건선택" id="" style="width:110px">
			                        <option selected="selected" value="EA2">일반기업</option>
			                    </select>
                            </td>
                            <th scope="row">년도</th>
                            <td>
                               	<select id="from_sel_target_year" name="from_sel_target_year" style="width:101px; ">
                                   		<c:if test="${fn:length(stdyyList) == 0 }"><option value="">자료없음</option></c:if>
		                               	<c:forEach items="${stdyyList }" var="year" varStatus="status">
		                                       <option value="${year.stdyy }"<c:if test="${year.stdyy eq fromTargetYear}"> selected="selected"</c:if>>${year.stdyy }년</option>
		                               	</c:forEach>
                                    	</select>
                                    	~
                                    	<select id="to_sel_target_year" name="to_sel_target_year" style="width:101px; ">
                                   		<c:if test="${fn:length(stdyyList) == 0 }"><option value="">자료없음</option></c:if>
		                               	<c:forEach items="${stdyyList }" var="year" varStatus="status">
		                                       <option value="${year.stdyy }"<c:if test="${year.stdyy eq toTargetYear}"> selected="selected"</c:if>>${year.stdyy }년</option>
		                               	</c:forEach>
                                    	</select>
                               	<p class="btn_src_zone"><a href="#" class="btn_search" id="btn_search">조회</a></p>
                            </td>
                        </tr>
                    </table>
                </div>
                <!-- // 리스트영역-->
                <div class="block">
                    <h3 class="middle">분류요인</h3>
                    <div class="btn_page_middle">
                    <span class="mgr20">(단위: 개) </span>
                    <a class="btn_page_admin" href="#" onclick="implementInsertForm();"><span>챠트</span></a>
                    <a class="btn_page_admin" href="#"><span id="excelDown">엑셀다운로드</span></a> 
                    <a class="btn_page_admin" href="#" onclick="output();"><span>출력</span></a>
                    </div>
                    <!--// grid -->
                    <br>
                    <div id="baseGridWidth">
                   	<table id="grid_sttus_list"></table>
                   	<div id="grid_sttus_pager"></div>
                   	</div>                   	                   	
                    <!--grid //-->
                    
                    <div class="list_zone" id="div_data_table1">
                   	</div>
                   	
                </div>
                <!--리스트영역 //-->
                <!-- // 리스트영역-->
                <div class="block2">
                    <h3 class="middle">분류요인-규모기준</h3>
                    <div class="btn_page_middle">
                    <a class="btn_page_admin" href="#" onclick="implementInsertForm2();"><span>챠트</span></a>
                    <a class="btn_page_admin" href="#"><span id="excelDown2">엑셀다운로드</span></a> 
                    <a class="btn_page_admin" href="#" onclick="output2();"><span>출력</span></a>
                    </div>
                    <!--// grid -->
                    <br>
                    <div id="baseGridWidth">
                   	<table id="grid_sttus_list2"></table>
                   	<div id="grid_sttus_pager2"></div>
                   	</div>
                    <!--grid //-->
                    
                    <div class="list_zone" id="div_data_table2">
                   	</div>
                   	                   	
                </div>
                <!--리스트영역 //-->
            </div>
        </div>
    </div>
    <!--content//-->
</form>

<!-- loading -->
<div style="display:none">
	<div class="loading" id="loading">
		<div class="inner">
			<div class="box">
		    	<p>
		    		<span id="load_msg">조회중입니다.</span>
		    		<br />
					시스템 상태에 따라 최대 10분 정도 소요될 수 있습니다.
				</p>
				<span><img src="<c:url value="/images/etc/loading_bar.gif" />" width="323" height="39" alt="loading" /></span>
			</div>
		</div>
	</div>
</div>

</body>
</html>