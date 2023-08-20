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
<title>기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery,colorboxAdmin,cookie,form,jqGrid,selectbox,timer,tools,ui,validate,multiselect,msgBoxAdmin" />
<ap:jsTag type="tech" items="util,acm,ps" />
<script type="text/javascript">

$(document).ready(function(){	
	gnb_menu();
	lnb();
	tbl_faq();
	//tabwrap();
	
	var form = document.dataForm;
	var lastYear= Util.date.getLocalYear();
	var searchCondition = jQuery("#searchCondition2").val();
	var from_sel_target_year = jQuery("#from_sel_target_year").val();
	var to_sel_target_year = jQuery("#to_sel_target_year").val();
	
	//setSelectBoxYear('from_sel_target_year',lastYear, null, '${param.from_sel_target_year}');
	//setSelectBoxYear('to_sel_target_year',lastYear, null, '${param.to_sel_target_year}');
	
	
	//엑셀 다운로드
	$("#excelDown2").click(function(){
		var searchCondition = jQuery("#searchCondition2").val();
		var from_sel_target_year = jQuery("#from_sel_target_year").val();
		var to_sel_target_year = jQuery("#to_sel_target_year").val();
		
		//form.limitUse.value = "Y";
    	jsFiledownload("/PGPS0070.do","df_method_nm=excelRsolver2&searchCondition="+searchCondition
    			+'&from_sel_target_year='+from_sel_target_year+'&to_sel_target_year='+to_sel_target_year);
    });
	
	
	/* //그리드 리사이즈
	$(window).bind('resize', function() {
		resizeJqGridWidth();
	}).trigger('resize');
	
	// 추이 그리드
	$.ajax({
        url:'PGPS0070.do?df_method_nm=processGetGridSttusList2Main&searchCondition='+searchCondition
		+'&from_sel_target_year='+from_sel_target_year+'&to_sel_target_year='+to_sel_target_year,
        dataType: "json",
        type: 'POST',
        async: false,
        success: function (result) {

            if (result) {

                if (!result.Error) {

                    var colD = result.value.data;
                    var colN = result.value.columnNames;
                    
                    var ColModel1 = [];
                     for (var j = 0; j<result.value.colModelList.length; j++) {
                    	 ColModel1.push({name:result.value.colModelList[j],index:result.value.colModelList[j], width:100});
                      }
                    
                    $("#grid_sttus_list").jqGrid('GridUnload');
                    
                	$("#grid_sttus_list").jqGrid({
                		url:'PGPS0070.do?df_method_nm=processGetGridSttusList2List&searchCondition='+searchCondition
            			+'&from_sel_target_year='+from_sel_target_year+'&to_sel_target_year='+to_sel_target_year,
                		datatype: "json",
                		colNames:colN,
                	   	colModel:ColModel1,
                        height: "auto",
                        //rowNum:'${rowNum}',
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
	}); */
	
	// 조회
	$("#btn_search").click(function(){
		$("#df_method_nm").val("goIdxList2");
		$("#dataForm").submit();
	});
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
//추이 검색
function search_list2() {
	var form = document.all;

	var searchCondition = form.searchCondition2.value;
	var from_sel_target_year = jQuery("#from_sel_target_year").val();
	var to_sel_target_year = jQuery("#to_sel_target_year").val();
	
	//그리드 리사이즈
	$(window).bind('resize', function() {
		resizeJqGridWidth(); 
	}).trigger('resize');
	
	$.ajax({
	        url:'PGPS0070.do?df_method_nm=processGetGridSttusList2Main&searchCondition='+searchCondition
			+'&from_sel_target_year='+from_sel_target_year+'&to_sel_target_year='+to_sel_target_year,
	        dataType: "json",
	        type: 'POST',
	        async: false,
	        success: function (result) {

	            if (result) {

	                if (!result.Error) {

	                    var colD = result.value.data;
	                    var colN = result.value.columnNames;
	                    
	                    var ColModel1 = [];
	                     for (var j = 0; j<result.value.colModelList.length; j++) {
	                    	 ColModel1.push({name:result.value.colModelList[j],index:result.value.colModelList[j], width:100});
	                      }
	                     
	                    $("#grid_sttus_list").jqGrid('GridUnload');
	                    
	                  //기업현황 그리드
	                	$("#grid_sttus_list").jqGrid({
	                		url:'PGPS0070.do?df_method_nm=processGetGridSttusList2List&searchCondition='+searchCondition
	                				+'&from_sel_target_year='+from_sel_target_year+'&to_sel_target_year='+to_sel_target_year,
	                		datatype: "json",
	                		colNames:colN,
	                	   	colModel:ColModel1,
	                        height: "auto",
	                        rowNum:'${rowNum}',
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
}


//출력 popup
var output2 = function() {
	var searchCondition = jQuery("#searchCondition2").val();
	var from_sel_target_year = jQuery("#from_sel_target_year").val();
	var to_sel_target_year = jQuery("#to_sel_target_year").val();
    
	$.colorbox({
        title : "기업위상분석 추이 출력",
        href : "PGPS0070.do?df_method_nm=outputIdx2&searchCondition="+searchCondition
        		+"&from_sel_target_year="+from_sel_target_year+"&to_sel_target_year="+to_sel_target_year,
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
                            <li onclick="idx_detail_view('0070');"><a href="#">현황</a></li><li class="on" onclick="idx_detail_view('0071');"><a href="#">추이</a></li>
                        </ul>
                    </div>
                    <div class="tabcon">
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
                                    	<select name="searchCondition2" title="기업군" style="width:200px">
		                                    <option value="EA1" selected>전체기업</option>
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
		                                
                                    	<p class="btn_src_zone"><a href="#" class="btn_search" id="btn_search"">조회</a></p>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <!-- // 리스트영역-->
                        <div class="block">
                            <div class="btn_page_middle"> 
	                        <a class="btn_page_admin" href="#"><span id="excelDown2">엑셀다운로드</span></a> 
	                        <a class="btn_page_admin" href="#" onclick="output2();"><span>출력</span></a>
                            </div>
                            
                            <div class="list_zone">
		                       <table cellspacing="0" border="0" summary="기업통계" class="list" id="tblStatics">
		                           <caption>
		                            리스트
		                            </caption>
		                            <colgroup>		                        	
			                        	<col width="*" />
			                            <col width="*" />
			                           	<c:forEach items="${seachedYears }">
			                           	<col width="*" />
			                           	</c:forEach>                      
		                            </colgroup>
		                            <thead>		                                
		                                <tr>
		                                    <th scope="col">구분</th>		                                    
		                                    <th scope="col">구분</th>
		                                    <c:forEach items="${seachedYears }" var="year">
		                                    <th scope="col">${year }</th>
		                                    </c:forEach>		                                    		                                    		                                                                     
		                                </tr>
		                            </thead>
		                            <tbody>
		                            	<c:forEach items="${resultList }" var="resultInfo">
		                            	<tr>
		                            		<td>${resultInfo.CODE_NM }</td>
		                            		<td style="text-align: center">${resultInfo.GUBUN }</td>
		                            		<c:forEach items="${seachedYears }" var="year">
		                            		<td class="tar">${resultInfo[year] }</td>
		                            		</c:forEach>
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