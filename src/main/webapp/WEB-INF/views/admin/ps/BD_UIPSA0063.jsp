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
<ap:jsTag type="web" items="jquery,colorboxAdmin,form,jqGrid,selectbox,timer,tools,ui,validate,multiselect,msgBoxAdmin" />
<ap:jsTag type="tech" items="util,msg,acm,ps" />
<ap:globalConst />
<script type="text/javascript">

$(document).ready(function(){
	/*
	gnb_menu();
	lnb();
	tbl_faq();
	tabwrap();
	*/
	
	var form = document.dataForm;
	var lastYear= Util.date.getLocalYear()-1;
	
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
	
	//엑셀 다운로드
	$("#excelDown").click(function(){
		var form = document.all;
		
		var searchCondition = jQuery("#searchCondition").val();
		var sel_target_year = jQuery("#sel_target_year").val();
		var induty_select = form.induty_select.value;
		var multiSelectGrid1 = jQuery("#multiSelectGrid1").val();
		var multiSelectGrid2 = jQuery("#multiSelectGrid2").val();
		var multiSelectGrid3 = jQuery("#multiSelectGrid3").val();
		var gSelect1 = "W";
		var gSelect2 = "W";
		var sel_area = form.sel_area.value;
		var cmpn_area_depth1 = jQuery("#cmpn_area_depth1").val();
		var cmpn_area_depth2 = jQuery("#cmpn_area_depth2").val();
		
		/* var ad_isnew = form.ad_isnew.value;
		var ad_sn = form.ad_sn.value;
		var ad_ind_cd = form.ad_ind_cd_1.value; */
		var ad_ind_cd = form.ad_ind_cd.value;
		
    	jsFiledownload("/PGPS0063.do","df_method_nm=excelRsolver&searchCondition="+searchCondition
    			+"&sel_target_year="+sel_target_year+"&induty_select="+induty_select
    			+"&multiSelectGrid1="+multiSelectGrid1+"&multiSelectGrid2="+multiSelectGrid2+"&multiSelectGrid3="+multiSelectGrid3
    			+"&gSelect1="+gSelect1+"&gSelect2="+gSelect2+"&ad_ind_cd="+ad_ind_cd
    			+"&sel_area="+sel_area+"&cmpn_area_depth1="+cmpn_area_depth1+"&cmpn_area_depth2="+cmpn_area_depth2);
    });    	
	
	$("#dataForm").validate({
		rules : {
			searchCondition: {
				required: true
			},
			sel_target_year: {
				required: true
			}
		},
		submitHandler: function(form) {
			
			if ($("#searchInduty option:selected").val() != "" && $("#searchIndutyVal").multipleSelect("getSelects") == "") {
				jsMsgBox(null, "error", Message.template.noSetTarget("업종조건("+$("#induty_select option:selected").text()+")"));
				return;
			}

			if ($("#searchArea option:selected").val() != "" && $("#searchAreaVal").multipleSelect("getSelects") == "") {
				jsMsgBox(null, "error", Message.template.noSetTarget("지역조건("+$("#sel_area option:selected").text()+")"));
				return;
			}
			
			setHiddenParam();
			$("#df_method_nm").val("selectGetGridSttusList");
			
			$("#dataForm").ajaxSubmit({
		        url      : "PGPS0063.do",
		        dataType : "html",            
		        async    : false,
		        /* contentType: "multipart/form-data", */
		        beforeSubmit : function(){
		        },            
		        success  : function(response) {
		        	try {
		        		var html = $.parseHTML(response);
		        		
		        		$.each(html, function(i, el) {            		
		           			if(el.nodeType==1){
		           		  		var clazz = el.getAttribute('class');		           		  		
		           		  		if(clazz == "add_table"){		           		  			
		           		  			$("#div_data_table").html(el);
		           		  			//if(!$("#empty_resultList")) {		           		  				
		           		  				Util.rowSpan($("#tblStatics"), [1]);
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
		    });
			
		}
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

//검색
function search_list() {
	$("#df_method_nm").val("");
	$("#dataForm").submit();
}

//출력 popup
var output = function() {
	var form = document.all;
	
	var searchCondition = jQuery("#searchCondition").val();
	var sel_target_year = jQuery("#sel_target_year").val();
	var induty_select = form.induty_select.value;
	var multiSelectGrid1 = jQuery("#multiSelectGrid1").val();
	var multiSelectGrid2 = jQuery("#multiSelectGrid2").val();
	var multiSelectGrid3 = jQuery("#multiSelectGrid3").val();
	var gSelect1 = form.gSelect1.value;
	var gSelect2 = form.gSelect2.value;
	var sel_area = form.sel_area.value;
	var cmpn_area_depth1 = jQuery("#cmpn_area_depth1").val();
	var cmpn_area_depth2 = jQuery("#cmpn_area_depth2").val();
	
	var searchArea = $("#searchArea").val();
	var searchInduty = $("#searchInduty").val();
	
	/* var ad_isnew = form.ad_isnew.value;
	var ad_sn = form.ad_sn.value;
	var ad_ind_cd = form.ad_ind_cd_1.value; */
	var ad_ind_cd = form.ad_ind_cd.value;
    
	$.colorbox({
        title : "출력화면 팝업",
        href : "PGPS0063.do?df_method_nm=outputIdx&searchCondition="+searchCondition
			+"&sel_target_year="+sel_target_year+"&induty_select="+induty_select
			+"&multiSelectGrid1="+multiSelectGrid1+"&multiSelectGrid2="+multiSelectGrid2+"&multiSelectGrid3="+multiSelectGrid3
			+"&gSelect1="+gSelect1+"&gSelect2="+gSelect2+"&ad_ind_cd="+ad_ind_cd
			+"&sel_area="+sel_area+"&cmpn_area_depth1="+cmpn_area_depth1+"&cmpn_area_depth2="+cmpn_area_depth2
			+"&searchArea="+searchArea+"&searchInduty="+searchInduty,
        width : "80%",
        height : "80%",
        iframe : true,
        overlayClose : false,
        escKey : false
    });
};

//업종검색 구분에 따른 상세조건 출력
function changeIndutyBox(val){
	var html;
	
	switch (val) {
	case "I" :
		html = $("#searchIndustryType1").html();
		break;
	case "T" :
		html = $("#searchIndustryType2").html();
		break;
	case "D" :
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
	case "A" :
		html = $("#searchAreaType1").html();
		break;
	case "C" :
		html = $("#searchAreaType2").html();
		break;
	default :
		html = "";
	}
	
	$("#searchAreaVal").html(html);
	$("#searchAreaVal").multipleSelect('refresh');
}

// 업종, 지역 hidden value 세팅
function setHiddenParam() {
	var industryVal = $("#searchIndutyVal").val();
	var areaVal = $("#searchAreaVal").val();	
	
	switch ($("#induty_select").val()) {
	case "I" :
		$("#multiSelectGrid1").val(industryVal);
		break;
	case "T" :
		$("#multiSelectGrid2").val(industryVal);
		break;
	case "D" :
		$("#ad_ind_cd").val(industryVal);
		break;	
	}
	
	switch ($("#sel_area").val()) {
	case "A" :
		$("#cmpn_area_depth1").val(areaVal);
		break;
	case "C" :
		$("#cmpn_area_depth2").val(areaVal);
		break;	
	}
}

</script>
</head>

<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />
<ap:include page="param/pagingParam.jsp" />
<input name="limitUse" type="hidden" value="">

<input type="hidden" id="multiSelectGrid1" name="multiSelectGrid1" />
<input type="hidden" id="multiSelectGrid2" name="multiSelectGrid2" />
<input type="hidden" id="ad_ind_cd" name="ad_ind_cd" />

<input type="hidden" id="cmpn_area_depth1" name="cmpn_area_depth1" />
<input type="hidden" id="cmpn_area_depth2" name="cmpn_area_depth2" />

<input type="hidden" id="gSelect1" name="gSelect1" value="W"/>
<input type="hidden" id="gSelect2" name="gSelect2" value="W"/>

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
                            	<ap:code id="searchCondition" name="searchCondition" grpCd="14" type="select" selectedCd="${param.searchCondition}" defaultLabel="" option="style='width:100px; '" />
                            </td>
                            <th scope="row">년도</th>
                            <td>                            	
                            	<select id="sel_target_year" name="sel_target_year" style="width:100px; ">
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
						        <c:if test="${param.induty_select eq 'I' }">
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
						        <c:if test="${param.induty_select ne 'I' }">
						            <option value="UT01">제조업</option>
						            <option value="UT02">비제조업</option>
						        </c:if>
						    	</select>
						    	<select  id="searchIndustryType2" name="searchIndustryType2" style="display: none;">						    	
									<optgroup label="제조업">
									<c:forEach items="${themaList1}" var="thema1" varStatus="status">
										<option value="${thema1.INDUTY_CODE}" >${thema1.DTLCLFC_NM}</option>
									</c:forEach>
									</optgroup>
									<optgroup label="비제조업">
									<c:forEach items="${themaList2}" var="thema2" varStatus="status">
										<option value="${thema2.INDUTY_CODE}" >${thema2.DTLCLFC_NM}</option>
									</c:forEach>
									</optgroup>
						    	</select>
	                            <select id="searchIndustryType3" name="searchIndustryType3" style="display: none;">	                            
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
	                            </select>						    	
						    	<select name="induty_select" id="induty_select" title="업종조건선택" style="width:100px" onchange="changeIndutyBox(this.value);">
                                    <option value="">-- 선택 --</option>
                                    <option value="I" <c:if test="${param.induty_select eq 'I' }"> selected="selected"</c:if>>제조/비제조</option>
                                    <option value="T" <c:if test="${param.induty_select eq 'T' }"> selected="selected"</c:if>>업종테마별</option>
                                    <option value="D" <c:if test="${param.induty_select eq 'D' }"> selected="selected"</c:if>>상세업종별</option>
                                </select>
                                <select id="searchIndutyVal" name="searchIndutyVal" style="width: 380px;"></select>
                            </td>
                            
                            <th scope="row">지역</th>
                            <td>						    	
						    	<select id="searchAreaType1" name="searchAreaType1" style="display: none;">
						            <optgroup label="권역별">
							        <c:if test="${param.sel_area eq 'A' }">
										<c:forEach items="${areaState}" var="stateInfo" varStatus="status">
								        	<option value="${stateInfo.code}" 
									        	<c:forEach var="val" items="${paramValues.searchAreaVal}">
								        			<c:if test="${stateInfo.code eq val}"> selected="selected"</c:if>
								        		</c:forEach>
								        	>${stateInfo.codeNm}</option>
										</c:forEach>
							        </c:if>
							        <c:if test="${param.sel_area ne 'A' }">
										<c:forEach items="${areaState}" var="stateInfo" varStatus="status">
								        	<option value="${stateInfo.code}">${stateInfo.codeNm}</option>									        	
										</c:forEach>
							        </c:if>
							        </optgroup>
						    	</select>
	                           	<select id="searchAreaType2" name="searchAreaType2" style="display: none;">
							        <optgroup label="광역시도">
							        <c:if test="${param.sel_area eq 'C' }">
										<c:forEach items="${areaCity}" var="areaCity" varStatus="status">
								        	<option value="${areaCity.AREA_CODE}" 
									        	<c:forEach var="val" items="${paramValues.searchAreaVal}">
								        			<c:if test="${areaCity.AREA_CODE eq val}"> selected="selected"</c:if>
								        		</c:forEach>
								        	>${areaCity.ABRV}</option>
										</c:forEach>
							        </c:if>
							        <c:if test="${param.sel_area ne 'C' }">
										<c:forEach items="${areaCity}" var="areaCity" varStatus="status">
								        	<option value="${areaCity.AREA_CODE}" >${areaCity.ABRV}</option>
										</c:forEach>
							        </c:if>
						    	    </optgroup>
	                           	</select>
                              	<select name="sel_area" id="sel_area" title="지역조건선택" style="width:100px" onchange="changeAreaBox(this.value);">
                                      <option value="">-- 선택 --</option>
                                      <option value="A" <c:if test="${param.sel_area eq 'A' }"> selected="selected"</c:if>>권역별</option>
                                      <option value="C" <c:if test="${param.sel_area eq 'C' }"> selected="selected"</c:if>>지역별</option>
                               	</select>
                               	<select id="searchAreaVal" name="searchAreaVal" style="width: 200px;" class="multiselect"></select>
                               	
						    	<p class="btn_src_zone"><a href="#" class="btn_search" onclick="search_list()">조회</a></p>
                            </td>
                        </tr>                       
                    </table>
                </div>
                <!-- // 리스트영역-->
                <div class="block">
                    <h3 class="middle">기업전체</h3>
                    <div class="btn_page_middle"> 
                    <a class="btn_page_admin" href="#"><span id="excelDown">엑셀다운로드</span></a> 
	                <a class="btn_page_admin" href="#" onclick="output();"><span>출력</span></a>
                    </div>
                    <!--// grid -->
                    <!--<br>
                        <div id="baseGridWidth">
                       	<table id="grid_sttus_list"></table>
                       	<div id="grid_sttus_pager"></div>
                        </div> -->
                    <!--grid //-->
                    
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
                                    <th scope="col">성장률(%)</th>
                                    <th scope="col">평균(명)</th>
                                    <th scope="col">성장률(%)</th>
                                    <th scope="col">평균(천원)</th>
                                    <th scope="col">성장률(%)</th>
                                    <th scope="col">평균(천원)</th>
                                    <th scope="col">집약도(%)</th>                                    
                                </tr>
                            </thead>
                            <tbody>                                  
                            </tbody>
                        </table>
	            	</div>
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