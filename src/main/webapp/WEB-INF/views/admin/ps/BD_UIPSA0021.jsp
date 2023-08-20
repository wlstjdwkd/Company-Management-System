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
<ap:jsTag type="web" items="jquery,colorboxAdmin,form,jqGrid,selectbox,timer,tools,ui,validate,multiselect,msgBoxAdmin" />
<ap:jsTag type="tech" items="util,acm,msg" />
<script type="text/javascript">

$(document).ready(function(){	
	tiptoggle();
	
	// 멀티콤보박스 설정
  	$("#searchIndutyVal").multipleSelect({
  		selectAll: true,
   		placeholder : "-- 선택 --",
   		selectAllText : "전체선택",
       	allSelected : "전체선택",
       	minimumCountSelected: 20,
       	filter: true
  	});
  	$("#searchAreaVal").multipleSelect({
  		selectAll: false,
   		placeholder : "-- 선택 --",
   		selectAllText : "전체선택",
       	allSelected : "전체선택",
       	minimumCountSelected: 20,
       	filter: true
 		});
  	  	
  	$("#searchIndutyVal").attr("multiple", "multiple");
  	$("#searchAreaVal").attr("multiple", "multiple");	

	<c:if test="${not empty param.searchInduty}">changeIndutyBox("${param.searchInduty}");</c:if>
	<c:if test="${not empty param.searchArea}">changeAreaBox("${param.searchArea}");</c:if>
	
	<c:if test="${not empty param.searchArea and not empty param.searchInduty }">
		<c:if test="${param.searchArea == '1'}">
		Util.rowSpan($("#tblStatics"), [1,2,3]);	
		</c:if>
		<c:if test="${param.searchArea == '2'}">
		Util.rowSpan($("#tblStatics"), [1,2]);	
		</c:if>
	</c:if>
	<c:if test="${not empty param.searchArea and empty param.searchInduty}">	
		<c:if test="${param.searchArea == '1'}">
		Util.rowSpan($("#tblStatics"), [1,2]);	
		</c:if>
		<c:if test="${param.searchArea == '2'}">
		Util.rowSpan($("#tblStatics"), [1]);	
		</c:if>
	</c:if>
	<c:if test="${empty param.searchArea and not empty param.searchInduty}">
		Util.rowSpan($("#tblStatics"), [1]);
	</c:if>
	
	// 조회
  	$("#btn_search").click(function(){
  		var form = document.dataForm;
		form.df_method_nm.value = "goIdxList2";
  		
  		$("#df_method_nm").val("goIdxList2");
		$("#dataForm").submit();
  	});
  	
  	$("#dataForm").validate({
		rules : {			
		},
		submitHandler: function(form) {						
			
			if ($("#searchIndex option:selected").val() != "" && $("#searchIndexVal").multipleSelect("getSelects") == "") {
				jsMsgBox(null, "error", Message.template.noSetTarget("지표조건("+$("#searchIndex option:selected").text()+")"));
				return;
			}
			
			if ($("#searchInduty option:selected").val() != "" && $("#searchIndutyVal").multipleSelect("getSelects") == "") {
				jsMsgBox(null, "error", Message.template.noSetTarget("업종조건("+$("#searchInduty option:selected").text()+")"));
				return;
			}

			if ($("#searchArea option:selected").val() != "" && $("#searchAreaVal").multipleSelect("getSelects") == "") {
				jsMsgBox(null, "error", Message.template.noSetTarget("지역조건("+$("#searchArea option:selected").text()+")"));
				return;
			}

			form.submit();
		}
	});
	
	//엑셀 다운로드
	$("#excelDown").click(function(){
		var form = document.all;
		
		var searchCondition = jQuery("#searchCondition2").val();
		var sel_target_year = jQuery("#sel_target_year2").val();
		var induty_select = form.induty_select.value;
		var sel_area = form.sel_area.value;
		var multiSelectGrid1 = jQuery("#multiSelectGrid1").val();
		var multiSelectGrid2 = jQuery("#multiSelectGrid2").val();
		var gSelect1 = form.gSelect1.value;
		var gSelect2 = form.gSelect2.value;
		var sel_index_type = jQuery("#sel_index_type").val();
		var ad_index_kind = jQuery("#ad_index_kind").val();
		var ad_isnew = form.ad_isnew.value;
		var ad_sn = form.ad_sn.value;
		var ad_ind_cd = form.ad_ind_cd_1.value;
		var cmpn_area_depth1 = jQuery("#cmpn_area_depth1").val();
		var cmpn_area_depth2 = jQuery("#cmpn_area_depth2").val();
		
    	jsFiledownload("/PGPS0020.do","df_method_nm=excelRsolver2&searchCondition="+searchCondition
        		+'&sel_target_year='+sel_target_year+'&induty_select='+induty_select+'&multiSelectGrid1='+multiSelectGrid1+'&multiSelectGrid2='+multiSelectGrid2
    			+"&gSelect1="+gSelect1+"&gSelect2="+gSelect2+"&sel_index_type="+sel_index_type+"&ad_ind_cd="+ad_ind_cd
    			+"&sel_area="+sel_area+"&cmpn_area_depth1="+cmpn_area_depth1+"&cmpn_area_depth2="+cmpn_area_depth2);
    });
	
});	

//엑셀다운로드
function downloadExcel() {
	var form = document.dataForm;
	
	form.df_method_nm.value = "excelStatics2";
	
	$("#df_method_nm").val("excelStatics2");
	$("#dataForm").submit();
}

//챠트 popup
var implementInsertForm = function() {
	var form = document.all;
	
	var searchCondition = jQuery("#searchCondition2").val();
	var sel_target_year = jQuery("#sel_target_year2").val();
	var induty_select = form.induty_select.value;
	var sel_area = form.sel_area.value;
	var multiSelectGrid1 = jQuery("#multiSelectGrid1").val();
	var multiSelectGrid2 = jQuery("#multiSelectGrid2").val();
	var gSelect1 = form.gSelect1.value;
	var gSelect2 = form.gSelect2.value;
	var sel_index_type = jQuery("#sel_index_type").val();
	var ad_index_kind = jQuery("#ad_index_kind").val();
	var ad_isnew = form.ad_isnew.value;
	var ad_sn = form.ad_sn.value;
	var ad_ind_cd = form.ad_ind_cd_1.value;
	var cmpn_area_depth1 = jQuery("#cmpn_area_depth1").val();
	var cmpn_area_depth2 = jQuery("#cmpn_area_depth2").val();
	
	if(gSelect1 == "G" && gSelect2 == "G"){
		alert("그룹 지정은 업종과 지역 중 하나만 선택하세요.");
		return false;
	}
	if(gSelect1 == "W" && gSelect2 == "W"){
		alert("챠트는 하나의 그룹이 필요합니다.");
		return false;
	}
	
    
	$.colorbox({
        title : "주요지표 구간별현황 챠트",
        href : "PGPS0020.do?df_method_nm=sectionIdxChart&searchCondition="+searchCondition
			+'&sel_target_year='+sel_target_year+'&induty_select='+induty_select+'&multiSelectGrid1='+multiSelectGrid1+'&multiSelectGrid2='+multiSelectGrid2
			+"&gSelect1="+gSelect1+"&gSelect2="+gSelect2+"&sel_index_type="+sel_index_type+"&ad_ind_cd="+ad_ind_cd
			+"&sel_area="+sel_area+"&cmpn_area_depth1="+cmpn_area_depth1+"&cmpn_area_depth2="+cmpn_area_depth2,
        width : "80%",
        height : "80%",
        iframe : true,
        overlayClose : false,
        escKey : false
    });
};

//출력 popup
var output = function() {
	var form = document.all;
	
	var searchCondition = jQuery("#searchCondition2").val();
	var sel_target_year = jQuery("#sel_target_year2").val();
	var induty_select = form.induty_select.value;
	var sel_area = form.sel_area.value;
	var multiSelectGrid1 = jQuery("#multiSelectGrid1").val();
	var multiSelectGrid2 = jQuery("#multiSelectGrid2").val();
	var gSelect1 = form.gSelect1.value;
	var gSelect2 = form.gSelect2.value;
	var sel_index_type = jQuery("#sel_index_type").val();
	var ad_index_kind = jQuery("#ad_index_kind").val();
	var ad_isnew = form.ad_isnew.value;
	var ad_sn = form.ad_sn.value;
	var ad_ind_cd = form.ad_ind_cd_1.value;
	var cmpn_area_depth1 = jQuery("#cmpn_area_depth1").val();
	var cmpn_area_depth2 = jQuery("#cmpn_area_depth2").val();
   
	$.colorbox({
        title : "주요지표 구간별현황 출력",
        href : "PGPS0020.do?df_method_nm=outputIdx2&searchCondition="+searchCondition
    		+'&sel_target_year='+sel_target_year+'&induty_select='+induty_select+'&multiSelectGrid1='+multiSelectGrid1+'&multiSelectGrid2='+multiSelectGrid2
			+"&gSelect1="+gSelect1+"&gSelect2="+gSelect2+"&sel_index_type="+sel_index_type+"&ad_ind_cd="+ad_ind_cd
			+"&sel_area="+sel_area+"&cmpn_area_depth1="+cmpn_area_depth1+"&cmpn_area_depth2="+cmpn_area_depth2,
        width : "80%",
        height : "80%",
        iframe : true,
        overlayClose : false,
        escKey : false
    });
};

//업종검색 구분에 따른 상세조건 출력
function changeIndutyBox(val){
	var form = document.all;
	var html;
	
	switch (val) {
	case "1" :
		html = $("#searchIndustryType1").html();
		break;
	case "2" :
		html = $("#searchIndustryType2").html();
		break;
	case "3" :
		html = $("#searchIndustryType3").html();
		break;
	default :
		html = "";
	}
	
	$("#searchIndutyVal").html(html);
	$("#searchIndutyVal").multipleSelect('refresh');
}

//지역검색 구분에 따른 상세조건 출력
function changeAreaBox(val){
	var html;
	
	switch (val) {
	case "1" :
		html = $("#searchAreaType1").html();
		break;
	case "2" :
		html = $("#searchAreaType2").html();
		break;
	default :
		html = "";
	}
	
	$("#searchAreaVal").html(html);
	$("#searchAreaVal").multipleSelect('refresh');
}

function changeTab(val) {
	switch (val) {
	case 1 :
		$("#df_method_nm").val("");
		break;
	case 2 :
		$("#df_method_nm").val("goIdxList2");
		break;
	case 3 :
		$("#df_method_nm").val("goIdxList3");
		break;
	case 4 :
		$("#df_method_nm").val("goIdxList4");
		break;
	default :
		$("#df_method_nm").val("");
	}
	
	$("#tabChangeForm").submit();
}

// 출력
function printOut() {
	if ($("#searchInduty option:selected").val() != "" && $("#searchIndutyVal").multipleSelect("getSelects") == "") {
		jsMsgBox(null, "error", Message.template.noSetTarget("업종조건("+$("#searchInduty option:selected").text()+")"));
		return;
	}

	if ($("#searchArea option:selected").val() != "" && $("#searchAreaVal").multipleSelect("getSelects") == "") {
		jsMsgBox(null, "error", Message.template.noSetTarget("지역조건("+$("#searchArea option:selected").text()+")"));
		return;
	}
	
	var form = document.all;
	
	var searchEntprsGrpVal = jQuery("#searchEntprsGrpVal").val();
	var searchStdyy = jQuery("#searchStdyy").val();
	var searchInduty = form.searchInduty.value;
	var searchIndutyVal = jQuery("#searchIndutyVal").val();
	var searchArea = form.searchArea.value;
	var searchAreaVal = jQuery("#searchAreaVal").val();
	var searchIndex = form.searchIndex.value;
	var searchIndexVal = jQuery("#searchIndexVal").val();
	
	$.colorbox({
        title : "주요지표 구간별현황 출력",
        href : "PGPS0020.do?df_method_nm=getPrintOut2&searchStdyy="
		+searchStdyy+"&searchInduty="+searchInduty+"&searchIndutyVal="+searchIndutyVal+"&searchArea="
		+searchArea+"&searchAreaVal="+searchAreaVal+"&searchIndex="
		+searchIndex+"&searchIndexVal="+searchIndexVal+"&searchEntprsGrpVal="+searchEntprsGrpVal,
        width : "80%",
        height : "100%",
        iframe : true,
        overlayClose : false,
        escKey : false
    });
}

// 챠트 POP UP
function drawChart() {		
	var searchEntprsGrpVal = jQuery("#searchEntprsGrpVal").val();
	
	if ($("#searchInduty option:selected").val() != "" && $("#searchIndutyVal").multipleSelect("getSelects") == "") {
		jsMsgBox(null, "error", Message.template.noSetTarget("업종조건("+$("#searchInduty option:selected").text()+")"));
		return;
	}

	if ($("#searchArea option:selected").val() != "" && $("#searchAreaVal").multipleSelect("getSelects") == "") {
		jsMsgBox(null, "error", Message.template.noSetTarget("지역조건("+$("#searchArea option:selected").text()+")"));
		return;
	}
	
	if ($("#searchArea option:selected").val() == "" && $("#searchInduty option:selected").val() == "") {
		jsMsgBox(null, "error", Message.template.noSetTarget("업종 또는 지역조건"));
		return;
	}
	
	var form = document.all;
	
	var searchStdyy = jQuery("#searchStdyy").val();
	var searchInduty = form.searchInduty.value;
	var searchIndutyVal = jQuery("#searchIndutyVal").val();
	var searchArea = form.searchArea.value;
	var searchAreaVal = jQuery("#searchAreaVal").val();
	var searchIndex = form.searchIndex.value;
	var searchIndexVal = jQuery("#searchIndexVal").val();
	
	$.colorbox({
        title : "주요지표 구간별현황 챠트",
        href : "PGPS0020.do?df_method_nm=getAllChart2&searchStdyy="
		+searchStdyy+"&searchInduty="+searchInduty+"&searchIndutyVal="+searchIndutyVal+"&searchArea="
		+searchArea+"&searchAreaVal="+searchAreaVal+"&searchIndex="
		+searchIndex+"&searchIndexVal="+searchIndexVal+"&searchEntprsGrpVal="+searchEntprsGrpVal,
        width : "80%",
        height : "100%",
        iframe : true,
        overlayClose : false,
        escKey : false
    });
}

</script>
</head>
<body>
<form name="tabChangeForm" id="tabChangeForm" action="<c:url value='${svcUrl}' />" method="post">
	<ap:include page="param/defaultParam.jsp" />
	<ap:include page="param/dispParam.jsp" />
</form>

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
            <h2 class="menu_title">주요지표 구간별현황</h2>
            <!-- 타이틀 영역 //-->
            <!--// tab -->
            <div class="tabwrap">
                <div class="tab">
                    <ul id="gnb">
                        <li><a href="#none" onclick="changeTab(1);">현황</a></li><li class="on" onclick="changeTab(2);"><a href="#none">구간별현황</a></li><li onclick="changeTab(3);"><a href="#none">추이</a></li><li onclick="changeTab(4);"><a href="#none">구간별추이</a></li>
                    </ul>
                </div>
                <div class="tabcon" style="display: block;">
                    <!--// 구간별현황 조회 조건 -->
                    <div class="search_top">
                        <table cellpadding="0" cellspacing="0" class="table_search" summary="기업군 년도 업종 지역 지표 구간별현황 조회 조건" >
                            <caption>
                            구간별현황 조회 조건
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
                                	<ap:code id="searchEntprsGrpVal" name="searchEntprsGrpVal" grpCd="14" type="select" selectedCd="${param.searchEntprsGrpVal}" defaultLabel="" option="style='width:100px; '" />
                                </td>
                                <th scope="row">년도</th>
                                <td>
                                	<select id="searchStdyy" name="searchStdyy" style="width:100px; ">
	                                	<c:if test="${fn:length(stdyyList) == 0 }"><option value="">자료없음</option></c:if>
	                                	<c:forEach items="${stdyyList }" var="year" varStatus="status">
	                                        <option value="${year.stdyy }"<c:if test="${year.stdyy eq param.searchStdyy or (param.searchStdyy eq '' and status.index eq 0) }"> selected="selected"</c:if>>${year.stdyy }년</option>
	                                	</c:forEach>
                               		</select>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">업종</th>
                                <td>
	                                <select id="searchIndustryType1" name="searchIndustryType1" style="display: none;">
							        <c:if test="${param.searchInduty eq '1' }">
						        		<option value="C"
							        	<c:forEach var="val" items="${paramValues.searchIndutyVal}">
						        			<c:if test="${val eq 'C'}"> selected="selected"</c:if>
						        		</c:forEach>
						        		>제조업</option>
						        		<option value="Z"
							        	<c:forEach var="val" items="${paramValues.searchIndutyVal}">
						        			<c:if test="${val eq 'Z'}"> selected="selected"</c:if>
						        		</c:forEach>
						        		>비제조업</option>
							        </c:if>
							        <c:if test="${param.searchInduty ne '1' }">
							            <option value="C">제조업</option>
							            <option value="Z">비제조업</option>
							        </c:if>
							    	</select>
							    	<select  id="searchIndustryType2" name="searchIndustryType2" style="display: none;">
							    	<c:if test="${param.searchInduty eq '2' }">
										<c:set var="open" value="N" />
										<c:forEach items="${themaList}" var="themaInfo" varStatus="status">
											<c:if test="${themaInfo.dtlclfcNo == '0' }">
												<c:if test="${open == 'Y' }">
								    	    </optgroup>
												</c:if>
								    	    <optgroup label="<c:out value="${themaInfo.dtlclfcNm }" />">
	    										<c:set var="open" value="Y" />
											</c:if>
											<c:if test="${themaInfo.dtlclfcNo != '0' }">
								    	        <option value="${themaInfo.dtlclfcNo }"
									        	<c:forEach var="val" items="${paramValues.searchIndutyVal}">
								        			<c:if test="${themaInfo.dtlclfcNo eq val}"> selected="selected"</c:if>
								        		</c:forEach>									    	        
								    	        ><c:out value="${themaInfo.dtlclfcNm }" /></option>
										 	</c:if>
										</c:forEach>
									</c:if>
							    	<c:if test="${param.searchInduty ne '2' }">
										<c:set var="open" value="N" />
										<c:forEach items="${themaList}" var="themaInfo" varStatus="status">
											<c:if test="${themaInfo.dtlclfcNo == '0' }">
												<c:if test="${open == 'Y' }">
								    	    </optgroup>
												</c:if>
								    	    <optgroup label="<c:out value="${themaInfo.dtlclfcNm }" />">
	    										<c:set var="open" value="Y" />
											</c:if>
											<c:if test="${themaInfo.dtlclfcNo != '0' }">
								    	        <option value="${themaInfo.dtlclfcNo }"><c:out value="${themaInfo.dtlclfcNm }" /></option>
										 	</c:if>
										</c:forEach>
									</c:if>
							    	</select>
		                            <select id="searchIndustryType3" name="searchIndustryType3" style="display: none;">
		                            <c:if test="${param.searchInduty eq '3' }">
										<c:set var="open" value="N" />
										<c:forEach items="${indutyList}" var="indutyInfo" varStatus="status">
											<c:if test="${indutyInfo.indCode == '0' }">
												<c:if test="${open == 'Y' }">
								    	    </optgroup>
												</c:if>
								    	    <optgroup label="<c:out value="${indutyInfo.koreanNm }" />">
	    										<c:set var="open" value="Y" />
											</c:if>
											<c:if test="${indutyInfo.indCode != '0' }">
								    	        <option value="${indutyInfo.indCode }"
									        	<c:forEach var="val" items="${paramValues.searchIndutyVal}">
								        			<c:if test="${indutyInfo.indCode eq val}"> selected="selected"</c:if>
								        		</c:forEach>	
								    	        ><c:out value="${indutyInfo.koreanNm }" /></option>
										 	</c:if>
										</c:forEach>
									</c:if>
		                            <c:if test="${param.searchInduty ne '3' }">
										<c:set var="open" value="N" />
										<c:forEach items="${indutyList}" var="indutyInfo" varStatus="status">
											<c:if test="${indutyInfo.indCode == '0' }">
												<c:if test="${open == 'Y' }">
								    	    </optgroup>
												</c:if>
								    	    <optgroup label="<c:out value="${indutyInfo.koreanNm }" />">
	    										<c:set var="open" value="Y" />
											</c:if>
											<c:if test="${indutyInfo.indCode != '0' }">
								    	        <option value="${indutyInfo.indCode }"><c:out value="${indutyInfo.koreanNm }" /></option>
										 	</c:if>
										</c:forEach>
									</c:if>
		                            </select>
                              		<select name="searchInduty" id="searchInduty" title="업종조건선택" style="width:100px" onchange="changeIndutyBox(this.value);">
	                                    <option value="">-- 선택 --</option>
	                                    <option value="1" <c:if test="${param.searchInduty eq '1' }"> selected="selected"</c:if>>제조/비제조</option>
	                                    <option value="2" <c:if test="${param.searchInduty eq '2' }"> selected="selected"</c:if>>업종테마별</option>
	                                    <option value="3" <c:if test="${param.searchInduty eq '3' }"> selected="selected"</c:if>>상세업종별</option>
	                                </select>
	                                <select id="searchIndutyVal" name="searchIndutyVal" style="width: 380px;"></select>								        		                                
                                   </td>
                                <th scope="row">지역</th>
                                <td>
                                	<select id="searchAreaType1" name="searchAreaType1" style="display: none;">
							            <optgroup label="권역별">
								        <c:if test="${param.searchArea eq '1' }">
											<c:forEach items="${areaState}" var="stateInfo" varStatus="status">
									        	<option value="${stateInfo.code}" 
										        	<c:forEach var="val" items="${paramValues.searchAreaVal}">
									        			<c:if test="${stateInfo.code eq val}"> selected="selected"</c:if>
									        		</c:forEach>
									        	>${stateInfo.codeNm}</option>
											</c:forEach>
								        </c:if>
								        <c:if test="${param.searchArea ne '1' }">
											<c:forEach items="${areaState}" var="stateInfo" varStatus="status">
									        	<option value="${stateInfo.code}">${stateInfo.codeNm}</option>									        	
											</c:forEach>
								        </c:if>
								        </optgroup>
							    	</select>
	                            	<select id="searchAreaType2" name="searchAreaType2" style="display: none;">
								        <optgroup label="광역시도">
								        <c:if test="${param.searchArea eq '2' }">
											<c:forEach items="${areaCity}" var="areaCity" varStatus="status">
									        	<option value="${areaCity.AREA_CODE}" 
										        	<c:forEach var="val" items="${paramValues.searchAreaVal}">
									        			<c:if test="${areaCity.AREA_CODE eq val}"> selected="selected"</c:if>
									        		</c:forEach>
									        	>${areaCity.ABRV}</option>
											</c:forEach>
								        </c:if>
								        <c:if test="${param.searchArea ne '2' }">
											<c:forEach items="${areaCity}" var="areaCity" varStatus="status">
									        	<option value="${areaCity.AREA_CODE}" >${areaCity.ABRV}</option>
											</c:forEach>
								        </c:if>
							    	    </optgroup>
	                            	</select>
                                   	<select name="searchArea" id="searchArea" title="지역조건선택" style="width:100px" onchange="changeAreaBox(this.value);">
                                           <option value="">-- 선택 --</option>
                                           <option value="1" <c:if test="${param.searchArea eq '1' }"> selected="selected"</c:if>>권역별</option>
                                           <option value="2" <c:if test="${param.searchArea eq '2' }"> selected="selected"</c:if>>지역별</option>
                                    	</select>
                                    	<select id="searchAreaVal" name="searchAreaVal" style="width: 200px;"></select>
                                  	</td>
                            </tr>                            
                            <tr>
                                <th scope="row">지표</th>
                                <td colspan="3">
                                	<select name="searchIndex" title="검색조건선택" id="searchIndex" style="width:150px">
                                        <option value="A" <c:if test="${searchIndex eq 'A' }"> selected="selected"</c:if>>R&#38;D집약도 구간별</option>
                                        <option value="B" <c:if test="${searchIndex eq 'B' }"> selected="selected"</c:if>>매출액 구간별</option>
                                        <option value="C" <c:if test="${searchIndex eq 'C' }"> selected="selected"</c:if>>수출액 구간별</option>
                                        <option value="D" <c:if test="${searchIndex eq 'D' }"> selected="selected"</c:if>>근로자수 구간별</option>
                                        <option value="E" <c:if test="${searchIndex eq 'E' }"> selected="selected"</c:if>>평균업력 구간별</option>
                                        <option value="F" <c:if test="${searchIndex eq 'F' }"> selected="selected"</c:if>>매출구간별 R&D집약도</option>
                                    </select>
                                    <p class="btn_src_zone"><a href="#" class="btn_search" id="btn_search">조회</a></p>
                                </td>
                            </tr>
                        </table>
                    </div>
                                            <dl class="tip">
                            <dt class="tip"><a href="#"> 사용 팁</a><span class="openTip" style="display:block;"><a href="#none"><img src="/images/acm/tip_open.png" width="24" height="23" alt="열기" /></a></span><span class="closeTip" style="display:none;"><a href="#none"><img src="/images/acm/tip_close.png" width="24" height="23" alt="닫기" /></a></span></dt>
                            <dd class="tip">
                                <ul>
                                    <li class="left">
                                        <dl>
                                            <dt style="width:110px">조건/그룹선택 </dt>
                                            <dd><span class="blue">챠트 조회 시에만 적용되는 기능으로</span><br />
                                                조건일 경우 선택된 업종 또는 지역의 데이터만 조회<br />
                                                그룹일 경우 선택된 업종 또는 지역의 세부항목별로 데이터가 그룹핑되어 조회 </dd>
                                        </dl>
                                        <dl>
                                            <dt style="width:110px">업종/지역</dt>
                                            <dd>각 조회 조건의 상세항목까지 선택 후 통계 데이터 조회 </dd>
                                        </dl>
                                    </li>
                                    <li class="right">
                                        <dl>
                                            <dt style="width:60px">년도</dt>
                                            <dd>2002년 ~ 최근 통계 발표년도 </dd>
                                        </dl>
                                        <dl>
                                            <dt style="width:60px">맵챠트</dt>
                                            <dd>지역별(시도)로 주요지표현황을 출력 </dd>
                                        </dl>
                                        <dl>
                                            <dt style="width:60px">챠트</dt>
                                            <dd>업종 또는 지역 중 하나의 조건항목을 그룹( x 축 출력 ) 으로 선택으로  조회 </dd>
                                        </dl>
                                    </li>
                                </ul>
                            </dd>
                        </dl>                        
                    
                    <!-- // 리스트영역-->
                    <div class="block">
                        <h3 class="middle"><p id="titleTxt"><font size='3'>전체기업</font></p></h3>
                        <div class="btn_page_middle"> 
                        <span class="mgr20">(단위: 개,%) </span> 
                        <a class="btn_page_admin" href="#" onclick="drawChart();"><span>챠트</span></a>
                        <a class="btn_page_admin" href="#none" onclick="downloadExcel();"><span>엑셀다운로드</span></a>
                        <a class="btn_page_admin" href="#" onclick="printOut();"><span>출력</span></a>
                        </div>
                        
                        <div class="list_zone">
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
	                            <c:forEach var="outYr" begin="${stdyySt }" end="${stdyyEd }">
	                            <col width="*" />
	                            </c:forEach>
	                            </colgroup>
	                            <thead>
	                                <tr>
	                                	<c:if test="${!empty param.searchArea }">
											<c:if test="${param.searchArea == '1' }">
		                                   	<th scope="col" colspan="2">지역</th>
											</c:if>
											<c:if test="${param.searchArea == '2' }">
		                                   	<th scope="col">지역</th>
											</c:if>
										</c:if>
	                                    <c:if test="${!empty param.searchInduty }">
	                                    <th scope="col">업종</th>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'A' }">
	                                    <th scope="col">없음</th>
	                                    <th scope="col">1.0%미만</th>
	                                    <th scope="col">2.0~3.0%</th>
	                                    <th scope="col">3.0~5.0%</th>
	                                    <th scope="col">5.0%~10.0%</th>
	                                    <th scope="col">10.0%~30.0%</th>
	                                    <th scope="col">30.0%이상</th>
	                                    <th scope="col">합계</th>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'B' }">
	                                    <th scope="col">100억미만</th>
	                                    <th scope="col">100억원~500억원</th>
	                                    <th scope="col">500억원~1천억원</th>
	                                    <th scope="col">1천억원~2천억원</th>
	                                    <th scope="col">2천억원~3천억원</th>
	                                    <th scope="col">3천억원~5천억원</th>
	                                    <th scope="col">5천억원~1조원</th>
	                                    <th scope="col">1조원이상</th>
	                                    <th scope="col">합계</th>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'C' }">
	                                    <th scope="col">없음</th>
	                                    <th scope="col">1백만불 미만</th>
	                                    <th scope="col">1백만~5백만불</th>
	                                    <th scope="col">5백만~1천만불</th>
	                                    <th scope="col">1천만~3천만불</th>
	                                    <th scope="col">3천만~5천만불</th>
	                                    <th scope="col">5천만~1억불</th>
	                                    <th scope="col">1억불 이상</th>	                                    
	                                    <th scope="col">합계</th>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'D' }">
	                                    <th scope="col">10인 미만</th>
	                                    <th scope="col">10인~50인</th>
	                                    <th scope="col">50인~100인</th>
	                                    <th scope="col">100인~200인</th>
	                                    <th scope="col">200인~300인</th>
	                                    <th scope="col">300인 이상</th>	                                    
	                                    <th scope="col">합계</th>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'E' }">
	                                    <th scope="col">0~6년</th>
	                                    <th scope="col">7~20년</th>
	                                    <th scope="col">21~30년</th>
	                                    <th scope="col">31~40년</th>
	                                    <th scope="col">41~50년</th>
	                                    <th scope="col">51년이상</th>	                                    
	                                    <th scope="col">합계</th>
	                                    </c:if>
	                                    <c:if test="${searchIndex == 'F' }">
	                                    <th scope="col">100억미만</th>
	                                    <th scope="col">100억원~500억원</th>
	                                    <th scope="col">500억원~1천억원</th>
	                                    <th scope="col">1천억원~2천억원</th>
	                                    <th scope="col">2천억원~3천억원</th>
	                                    <th scope="col">3천억원~5천억원</th>
	                                    <th scope="col">5천억원~1조원</th>
	                                    <th scope="col">1조원이상</th>
	                                    <th scope="col">합계</th>
	                                    </c:if>	                                    
	                                </tr>
	                            </thead>
	                            <tbody>
								<c:forEach items="${resultList }" var="resultInfo" varStatus="resStatus">								                     	
									<tr>
									<c:if test="${not empty param.searchArea}">
										<c:if test="${param.searchArea == 1 }">
	                                    <td id='rowspan' class='tac'>	${resultInfo.upperNm }</td>
	                                    </c:if>
	                                    <td id='rowspan' class='tac'>	${resultInfo.abrv }</td>
									</c:if>
									<c:if test="${not empty param.searchInduty}">
	                                    <td class='tal'>
										<c:if test="${param.searchInduty == 1 or resultInfo.gbnIs == 'S' }">${resultInfo.indutySeNm }</c:if>
										<c:if test="${param.searchInduty == 2 and resultInfo.gbnIs == 'D' }">&emsp;&emsp;&emsp;${resultInfo.dtlclfcNm }</c:if>
										<c:if test="${param.searchInduty == 3 and resultInfo.gbnIs == 'D' }">&emsp;&emsp;&emsp;${resultInfo.indutyNm }</c:if>
										</td>
									</c:if>
									<c:if test="${searchIndex == 'A' }">
	                                    <td class="tar">${resultInfo.sctn1 }</td>
	                                    <td class="tar">${resultInfo.sctn2 }</td>
	                                    <td class="tar">${resultInfo.sctn3 }</td>
	                                    <td class="tar">${resultInfo.sctn4 }</td>
	                                    <td class="tar">${resultInfo.sctn5 }</td>
	                                    <td class="tar">${resultInfo.sctn6 }</td>
	                                    <td class="tar">${resultInfo.sctn7 }</td>
	                                    <td class="tar">${resultInfo.sctnSum }</td>
	                                </c:if>
                                    <c:if test="${searchIndex == 'B' }">
	                                    <td class="tar">${resultInfo.sctn1 }</td>
	                                    <td class="tar">${resultInfo.sctn2 }</td>
	                                    <td class="tar">${resultInfo.sctn3 }</td>
	                                    <td class="tar">${resultInfo.sctn4 }</td>
	                                    <td class="tar">${resultInfo.sctn5 }</td>
	                                    <td class="tar">${resultInfo.sctn6 }</td>
	                                    <td class="tar">${resultInfo.sctn7 }</td>
	                                    <td class="tar">${resultInfo.sctn8 }</td>
	                                    <td class="tar">${resultInfo.sctnSum }</td>
                                    </c:if>
                                    <c:if test="${searchIndex == 'C' }">
	                                    <td class="tar">${resultInfo.sctn1 }</td>
	                                    <td class="tar">${resultInfo.sctn2 }</td>
	                                    <td class="tar">${resultInfo.sctn3 }</td>
	                                    <td class="tar">${resultInfo.sctn4 }</td>
	                                    <td class="tar">${resultInfo.sctn5 }</td>
	                                    <td class="tar">${resultInfo.sctn6 }</td>
	                                    <td class="tar">${resultInfo.sctn7 }</td>
	                                    <td class="tar">${resultInfo.sctn8 }</td>
	                                    <td class="tar">${resultInfo.sctnSum }</td>
                                    </c:if>
                                    <c:if test="${searchIndex == 'D' }">
	                                    <td class="tar">${resultInfo.sctn1 }</td>
	                                    <td class="tar">${resultInfo.sctn2 }</td>
	                                    <td class="tar">${resultInfo.sctn3 }</td>
	                                    <td class="tar">${resultInfo.sctn4 }</td>
	                                    <td class="tar">${resultInfo.sctn5 }</td>
	                                    <td class="tar">${resultInfo.sctn6 }</td>	                                    
	                                    <td class="tar">${resultInfo.sctnSum }</td>
                                    </c:if>
                                    <c:if test="${searchIndex == 'E' }">
	                                    <td class="tar">${resultInfo.sctn1 }</td>
	                                    <td class="tar">${resultInfo.sctn2 }</td>
	                                    <td class="tar">${resultInfo.sctn3 }</td>
	                                    <td class="tar">${resultInfo.sctn4 }</td>
	                                    <td class="tar">${resultInfo.sctn5 }</td>
	                                    <td class="tar">${resultInfo.sctn6 }</td>	                                    
	                                    <td class="tar">${resultInfo.sctnSum }</td>
                                    </c:if>
                                    <c:if test="${searchIndex == 'F' }">
	                                    <td class="tar">${resultInfo.sctn1 }</td>
	                                    <td class="tar">${resultInfo.sctn2 }</td>
	                                    <td class="tar">${resultInfo.sctn3 }</td>
	                                    <td class="tar">${resultInfo.sctn4 }</td>
	                                    <td class="tar">${resultInfo.sctn5 }</td>
	                                    <td class="tar">${resultInfo.sctn6 }</td>
	                                    <td class="tar">${resultInfo.sctn7 }</td>
	                                    <td class="tar">${resultInfo.sctn8 }</td>
	                                    <td class="tar">${resultInfo.sctnSum }</td>
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