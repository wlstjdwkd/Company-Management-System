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
		
	//엑셀 다운로드
	$("#excelDown").click(function(){
		var searchCondition = jQuery("#searchCondition").val();
		var sel_target_year = jQuery("#sel_target_year").val();
		
		//form.limitUse.value = "Y";
    	jsFiledownload("/PGPS0062.do","df_method_nm=excelRsolver&searchCondition="+searchCondition+"&sel_target_year="+sel_target_year);
    });
	
	/* //그리드 리사이즈
	$(window).bind('resize', function() {
		resizeJqGridWidth(); 
	}).trigger('resize');
	
	//현황 그리드
	$("#grid_sttus_list").jqGrid({        
	   	url:'PGPS0062.do?df_method_nm=getGridSttusList',
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
	   	cmTemplate: { sortable: false },
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
	
	// 조회
	$("#btn_search").click(function(){
		$("#df_method_nm").val("");
		$("#dataForm").submit();
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
	
	jQuery("#grid_sttus_list").jqGrid('setGridParam',{url:"PGPS0062.do?df_method_nm=getGridSttusList&searchCondition="+searchCondition
			+"&sel_target_year="+sel_target_year
			,page:1}).trigger("reloadGrid");
}

//출력 popup
var output = function() {
	var form = document.all;
	
	var searchCondition = form.searchCondition.value;
	var sel_target_year = jQuery("#sel_target_year").val();
    
	$.colorbox({
        title : "진입시기별분석 현황",
        href : "PGPS0062.do?df_method_nm=outputIdx&searchCondition="+searchCondition+"&sel_target_year="+sel_target_year,
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
                            <li class="on" onclick="idx_detail_view('0062');"><a href="#">현황</a></li><li onclick="idx_detail_view('0062_2');"><a href="#">성장현황</a></li>
                        </ul>
                    </div>
                    <div class="tabcon" style="display: block;">
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
                                        <p class="btn_src_zone"><a href="#" class="btn_search" id="btn_search">조회</a></p>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <!-- // 리스트영역-->
                        <div class="block">
                            <div class="btn_page_middle"> 
		                        <a class="btn_page_admin" href="#"><span id="excelDown">엑셀다운로드</span></a> 
		                        <a class="btn_page_admin" href="#" onclick="output();"><span>출력</span></a>
					        </div>
                            
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
                            
                        </div>
                        <!--리스트영역 //-->
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