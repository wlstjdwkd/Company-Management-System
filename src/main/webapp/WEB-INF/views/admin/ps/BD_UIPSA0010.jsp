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
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,colorboxAdmin,form,jqGrid,selectbox,timer,tools,ui,validate,multiselect,msgBoxAdmin,blockUI" />
<ap:jsTag type="tech" items="util,acm,ps,etc" />
<script type="text/javascript">

var areaJson = ${areaSelect};

$(document).ready(function(){
	
	var form = document.dataForm;
	
	// 멀티콤보박스 설정
  	$("#searchIndutyVal").multipleSelect({
  		selectAll: true,
		placeholder : "-- 선택 --",
		selectAllText : "전체선택",
    	allSelected : "전체선택",
    	minimumCountSelected: 20,
    	filter: true
  	}); 	
  	$("#searchIndutyVal").attr("multiple", "multiple");
	
    $("#dataForm").validate({
		rules : {
			sel_target_year: {
				required: true
			}
		},
	});
	
	$("#btnReset").click(function() {  
		$("dataForm").each(function() {
		   this.reset();  
		});  
	});
	
	var resnTxtObj = {
		"EA1" : ["규모기준","상한기준","독립성기준"],
		"EA2" : ["규모기준","상한기준","독립성기준"],
		"EA3" : [],
		"EA4" : ["업종별 매출액증가율 15%이상","R&D투자비율 2%이상","유예기업"],
		"EA5" : ["매출액성장률 20%이상","고용성장률 20%이상"]
	};
	
	// 기업군 변경 시 판정사유
	$("#searchCondition").change(function(){
		
		var entCls = $(this).val();
		var resnTxts = resnTxtObj[entCls];
		var htmlContent = "";
		var nameFix = "reason";
		
		if(resnTxts == null || resnTxts.length < 1) {
			$("#td_resn_list").empty();
			return;
		}				
		
		htmlContent += "<ul>";
		
		for(var i=0; i<resnTxts.length; i++) {
			var el_name = nameFix + (i+1);
			htmlContent += "<li style='white-space:nowrap; margin-right:30px'>";
			htmlContent += "<input type='checkbox' name='"+el_name+"' id='"+el_name+"' value='Y'/>";
			htmlContent += "<label for='"+el_name+"'> "+resnTxts[i]+"</label>";
			htmlContent += "</li>";
		}
		htmlContent += "</ul>";
		
		$("#td_resn_list").html($.trim(htmlContent));		 	
	});
	
	// 지역(구/군) 변경 시
	$("#ad_area2").change(function(){
		
		if($(this).val() == "") {
			$("#ad_hedofc_adres").val("");
			return;
		}		
		var selText = $("#ad_area2 option:selected").text();		
		$("#ad_hedofc_adres").val(selText);
	});
	
	// 광역시도 변경 시
	$("#ad_area1").change(function() {
		var $val = $(this).val();
		var selectContent = "";
		
		if($val == "") {
			$("#ad_area2").val("");
			$("#ad_area2").attr("disabled", "disabled");
		}else {
			selectContent += "<optgroup label='구/군'>";
			selectContent += "<option value=''>-- 선택 --</option>";
			for(var i=0; i<areaJson.length; i++) {
				if($val == areaJson[i]["UPPER_CODE"]) {					
					selectContent += "<option value='" + areaJson[i]["AREA_CODE"] + "'>";
					selectContent += areaJson[i]["AREA_NM"];
					selectContent += "</option>";
				}
			}			
			selectContent += '</optgroup>';
			
			$("#ad_area2").html(selectContent);
			$("#ad_area2").attr("disabled", false);
		}
	});
	$("#ad_area1").change();
	<c:if test="${not empty param.ad_area2}">
	$("#ad_area2").val("${param.ad_area2}");
	</c:if>
	
	changeIndutyBox("D");
	/* <c:if test="${not empty param.induty_select}">changeIndutyBox("${param.induty_select}");</c:if> */
	
});

function fn_entrprs_detail_view(stdyy, hpe_cd, jurirno) {
	var form = document.dataForm;
	form.df_method_nm.value = "selectEntrprsResultList";
	form.hpe_cd.value = hpe_cd;
	form.jurirno.value = jurirno;
	form.stdyy.value = stdyy;
	
	form.submit();
}

/*
* 목록 검색
*/
function search_list() {
	$.blockUI({message:$("#loading")});
	
	var form = document.dataForm;
	
	var indutySel = $("#searchIndutyVal").val();
	
	if(indutySel) {
		// 상세업종 선택 구분 변경
		$("#induty_select").val("D");		
	}
	
	// 업종 명칭 유지용
	$("#pram_ind_code_name").val($("#ind_code_name_1").text());
	
	form.df_curr_page.value = 1;
	form.df_method_nm.value = "";
	
	form.submit();
}

/*
 * 검색조건 초기화
 */
function btn_input_reset() {
	$("#dataForm").each(function() {
		this.reset();
	});	
}

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

// 엑셀다운로드
function downloadExcel() {

	$("#df_method_nm").val("excelEntrprsData");
	
    $.colorbox({
        title : "기업자료 엑셀다운",
        href : "PGPS0010.do?"+$("#dataForm").formSerialize(),
        width : "600",
        height : "380",
        overlayClose : false,
        escKey : false,
        iframe : true
    });
}
</script>
</head>

<body>
<form name="dataForm" id="dataForm" method="post" action="${svcUrl }">
	<ap:include page="param/defaultParam.jsp" />
	<ap:include page="param/dispParam.jsp" />
	<ap:include page="param/pagingParam.jsp" />
	
	<input type="hidden" name="hpe_cd" value="" />
	<input type="hidden" name="jurirno" value="" />
	<input type="hidden" name="stdyy" value="" />
	<input type="hidden" name="limitUse" value="" />

	<input type="hidden" name="ad_hedofc_adres" id="ad_hedofc_adres" value="${param.ad_hedofc_adres}" />
	<input type="hidden" name="pram_ind_code_name" id="pram_ind_code_name" value="${param.pram_ind_code_name }" />
		
	<input type="hidden" name="induty_select" id="induty_select" />
	
	<input type="hidden" id="init_search_yn" name="init_search_yn" value="N" />
	
<!--//content-->
<div id="wrap">
	<div class="wrap_inn">
		<div class="contents">
			<!--// 타이틀 영역 -->
                <h2 class="menu_title">기업검색</h2>
                <!-- 타이틀 영역 //-->
                <!--// 검색 조건 -->
                <div class="search_top">
                    <table cellpadding="0" cellspacing="0" class="table_search" summary="공통 검색조건으로 기업군 검색년도로 검색하는 표">
                        <caption>
                        공통 검색조건
                        </caption>
                        <colgroup>
                        <col width="15%" />
                        <col width="30%" />
                        <col width="15%" />
                        <col width="40%" />
                        </colgroup>
                        <tr>
                            <th scope="row">기&nbsp;&nbsp;&nbsp;&nbsp;업&nbsp;&nbsp;&nbsp;&nbsp;군</th>
                            <td>
                            	<ul>
                                    <li>
                                    	<ap:code id="searchCondition" name="searchCondition" grpCd="14" type="select" selectedCd="${param.searchCondition}" defaultLabel="전&emsp;&emsp;체" />
                                    </li>
                                </ul>
                            </td>
                            <th scope="row">기준년도(사업년도)</th>
                            <td>
                            	<!-- <select id="sel_target_year" name="sel_target_year" style="width:101px; "  selectedCd="${param.sel_target_year}"></select>  -->
                            	<select id="sel_target_year" name="sel_target_year" style="width:100px; ">
                            		<c:choose>
                            			<c:when test="${empty stdyyList}">
                            			<option value="">자료없음</option>
                            			</c:when>
                            			<c:otherwise>                            			
                            			<c:forEach items="${stdyyList }" var="year" varStatus="status">
	                                       <option value="${year.stdyy }"<c:if test="${year.stdyy eq param.sel_target_year or (param.sel_target_year eq '' and status.index eq 0) }"> selected="selected"</c:if>>${year.stdyy }년</option>
		                               	</c:forEach>	
                            			</c:otherwise>
                            		</c:choose>	                               	
                          		</select>
                            </td>
                        </tr>
                    </table>
                </div>
                <!--// 검색 조건2 -->
                <div class="search_top">
                    <table cellpadding="0" cellspacing="0" class="table_search mgt20" summary="검색어 기업형태 판정사유 별로 검색조건을 입력하는 표" >
                        <caption>
                        검색어 기업형태로 조회
                        </caption>
                        <colgroup>
                        <col width="15%" />
                        <col width="30%" />
                        <col width="15%" />
                        <col width="40%" />
                        </colgroup>
                        <tr>
                            <th scope="row">검&nbsp;&nbsp;&nbsp;&nbsp;색&nbsp;&nbsp;&nbsp;&nbsp;어</th>
                            <td>
                            	<select name="searchWrdSelect" title="검색조건선택" style="width:150px">
                                    <option value="ENTRPRS_NM" <c:if test="${param.searchWrdSelect == 'ENTRPRS_NM'}">selected="selected" </c:if>>업체명</option>
                                    <option value="BIZRNO" <c:if test="${param.searchWrdSelect == 'BIZRNO'}">selected="selected" </c:if>>사업자번호</option>
                                    <option value="JURIRNO" <c:if test="${param.searchWrdSelect == 'JURIRNO'}">selected="selected" </c:if>>법인번호</option>
                                    <option value="RPRSNTV_NM" <c:if test="${param.searchWrdSelect == 'RPRSNTV_NM'}">selected="selected" </c:if>>대표자명</option>
                                </select>
                                <span class="search_box">
                                <input name="searchWrd" title="검색어 입력" type="text" style="width:145px;" value='${param.searchWrd}' >
                                </span></td>
                            <th scope="row">업&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;종</th>
                            <td>
                                <%-- <select id="searchIndustryType1" name="searchIndustryType1" style="display: none;">                                    
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
						            <option value="C">제조업</option>
						            <option value="Z">비제조업</option>
						        </c:if>
						    	</select>
						    	<select  id="searchIndustryType2" name="searchIndustryType2" style="display: none;">
						    	<c:if test="${param.searchInduty eq 'T' }">
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
						    	<c:if test="${param.searchInduty ne 'T' }">
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
						    	</select> --%>
	                            <select id="searchIndustryType3" name="searchIndustryType3" style="display: none;">
	                            <%-- <c:if test="${param.induty_select eq 'D' }"> --%>
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
								<%-- </c:if> --%>
	                            <%-- <c:if test="${param.induty_select ne 'D' }">
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
								</c:if>	 --%>                            							
	                            </select>						    	
						    	<%-- <select name="induty_select" id="induty_select" title="업종조건선택" style="width:100px; display:none" onchange="changeIndutyBox(this.value);">
                                    <option value="">-- 선택 --</option>
                                    <option value="I" <c:if test="${param.induty_select eq 'I' }"> selected="selected"</c:if>>제조/비제조</option>
                                    <option value="T" <c:if test="${param.induty_select eq 'T' }"> selected="selected"</c:if>>업종테마별</option>
                                    <option value="D" <c:if test="${param.induty_select eq 'D' }"> selected="selected"</c:if>>상세업종별</option>
                                </select> --%>
                                <select id="searchIndutyVal" name="searchIndutyVal" style="width: 380px;"></select>                                                                                 
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">지역(본사기준)</th>
                            <td>
                            	<select id="ad_area1" name="ad_area1" style="width: 110px">                            		
						            <optgroup label="광역시도">
						            	<option value="" selected="selected">-- 선택 --</option>
							        	<c:forEach items="${areaCity}" var="areaCity" varStatus="status">
						            		<option value="${areaCity.AREA_CODE}" <c:if test="${param.ad_area1 eq areaCity.AREA_CODE}">selected="selected"</c:if> >${areaCity.ABRV}</option>
							            </c:forEach>
							        </optgroup>
						    	</select>						    	
                            	<select id="ad_area2" name="ad_area2" style="width: 150px">
                            		<option value="">-- 선택 --</option>
						            <%-- <optgroup label="구/군">
						            	<option value="" selected="selected">-- 선택 --</option>
							        	<c:forEach items="${areaSelect}" var="areaSelect" varStatus="status">
						            		<option value="${areaSelect.AREA_CODE}" <c:if test="${param.ad_area2 eq areaSelect.AREA_CODE}">selected="selected"</c:if> >${areaSelect.AREA_NM}</option>
							            </c:forEach>
							        </optgroup> --%>
						    	</select> 
                            </td>
                            <th scope="row">기업공개형태</th>
                            <td>
                                <ap:code id="ad_entrprs_othbc_stle" name="ad_entrprs_othbc_stle" grpCd="58" type="select" selectedCd="${param.ad_entrprs_othbc_stle}" />
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">자&nbsp;&nbsp;&nbsp;본&nbsp;&nbsp;&nbsp;금(억)</th>
                            <td><span class="search_box">
                                <input name="capl1" title="자본금 From" type="text" style="width:137px" class="tar" value='${param.capl1}'/>
                                ~
                                <input name="capl2" title="자본금 To" type="text" style="width:137px" class="tar" value='${param.capl2}'/>
                                </span></td>
                            <th scope="row">자&nbsp;산&nbsp;&nbsp;&nbsp;총&nbsp;계(억)</th>
                            <td><span class="search_box">
                                <input name="assets_sm1" title="자산총계 From" type="text" style="width:137px" class="tar" value='${param.assets_sm1}'/>
                                ~
                                <input name="assets_sm2" title="자산총계 To" type="text" style="width:137px" class="tar" value='${param.assets_sm2}'/>
                                </span></td>
                        </tr>
                        <tr>
                            <th scope="row">매&nbsp;&nbsp;&nbsp;출&nbsp;&nbsp;&nbsp;액(억)</th>
                            <td><span class="search_box">
                                <input name="selng_am1" title="매출액 From" type="text" style="width:137px" class="tar" value='${param.selng_am1}'/>
                                ~
                                <input name="selng_am2" title="매출액 To" type="text" style="width:137px" class="tar" value='${param.selng_am2}'/>
                                </span></td>
                            <th scope="row">수&nbsp;&nbsp;&nbsp;&nbsp;출&nbsp;&nbsp;&nbsp;&nbsp;액(억)</th>
                            <td><span class="search_box">
                                <input name="xport_am_kr1" title="수출액 From" type="text" style="width:137px" class="tar" value='${param.xport_am_kr1}'/>
                                ~
                                <input name="xport_am_kr2" title="수출액 To" type="text" style="width:137px" class="tar" value='${param.xport_am_kr2}'/>
                                </span></td>
                        </tr>
                        <tr>
                            <th scope="row">영&nbsp;업&nbsp;이&nbsp;익(억)</th>
                            <td><span class="search_box">
                                <input name="bsn_profit1" title="영업이익 From" type="text" style="width:137px" class="tar" value='${param.bsn_profit1}'/>
                                ~
                                <input name="bsn_profit2" title="영업이익 To" type="text" style="width:137px" class="tar" value='${param.bsn_profit2}'/>
                                </span></td>
                            <th scope="row">당기&nbsp;&nbsp;순이익(억)</th>
                            <td><span class="search_box">
                                <input name="thstrm_ntpf1" title="당기순이익 From" type="text" style="width:137px" class="tar" value='${param.thstrm_ntpf1}'/>
                                ~
                                <input name="thstrm_ntpf2" title="당기순이익 To" type="text" style="width:137px" class="tar" value='${param.thstrm_ntpf2}'/>
                                </span></td>
                        </tr>
                        <tr>
                            <th scope="row">연구개발비(억)</th>
                            <td><span class="search_box">
                                <input name="rsrch_devlop_ct1" title="연구개발비 From" type="text" style="width:137px" class="tar" value='${param.rsrch_devlop_ct1}'/>
                                ~
                                <input name="rsrch_devlop_ct2" title="연구개발비 To" type="text" style="width:137px" class="tar" value='${param.rsrch_devlop_ct2}'/>
                                </span></td>
                            <th scope="row">상시근로자수(명)</th>
                            <td><span class="search_box">
                                <input name="ordtm_labrr_co1" title="상시근로자수 From" type="text" style="width:137px" class="tar" value='${param.ordtm_labrr_co1}'/>
                                ~
                                <input name="ordtm_labrr_co2" title="상시근로자수 To" type="text" style="width:137px" class="tar" value='${param.ordtm_labrr_co2}'/>
                                </span></td>
                        </tr>
                        <tr>
                            <th scope="row">기&nbsp;업&nbsp;특&nbsp;성</th>
                            <td>
                            	<ul>
                                    <li style="white-space:nowrap; margin-right:30px; width:65px">
                                        <input type="checkbox" name="ad_b2b_entrprs_at" id="ad_b2b_entrprs_at" value="Y" <c:if test="${param.ad_b2b_entrprs_at eq 'Y' }">checked="checked"</c:if> />
                                        <label for="ad_b2b_entrprs_at">B2B기업</label>
                                    </li>
                                    <li style="white-space:nowrap; margin-right:30px; width:65px">
                                        <input type="checkbox" name="ad_b2c_entrprs_at" id="ad_b2c_entrprs_at" value="Y" <c:if test="${param.ad_b2c_entrprs_at eq 'Y' }">checked="checked"</c:if> />
                                        <label for="ad_b2c_entrprs_at">B2C기업</label>
                                    </li>
                                    <li style="white-space:nowrap; margin-right:30px; width:65px">
                                        <input type="checkbox" name="ad_b2g_entrprs_at" id="ad_b2g_entrprs_at" value="Y" <c:if test="${param.ad_b2g_entrprs_at eq 'Y' }">checked="checked"</c:if> />
                                        <label for="ad_b2g_entrprs_at">B2G기업</label>
                                    </li>
                                </ul>
                            </td>
                            <th scope="row">외국투자기업</th>
                            <td><span class="search_box">
                              	<ul>
                                    <li>
                                        <input type="checkbox" name="ad_fnsy_at" id="ad_fnsy_at" value="Y" <c:if test="${param.ad_fnsy_at eq 'Y' }">checked="checked"</c:if> />
                                        <label for="ad_fnsy_at">외국인투자기업</label>
                                    </li>
                                </ul>
                            </span></td>
                        </tr>
                        <tr>
                            <th scope="row">판정사유별</th>
                            <td colspan="3" id="td_resn_list">
                            	<ul>
                            		<c:if test="${param.searchCondition eq 'EA1' or param.searchCondition eq 'EA2' }">                            		
                                    <li style="white-space:nowrap; margin-right:30px"><input type="checkbox" name="reason1" id="reason1" value="Y" <c:if test="${param.reason1 eq 'Y' }">checked</c:if> /> <label for="reason1">규모기준</label></li>
                                    <li style="white-space:nowrap; margin-right:30px"><input type="checkbox" name="reason2" id="reason2" value="Y" <c:if test="${param.reason2 eq 'Y' }">checked</c:if> /> <label for="reason2">상한기준</label></li>
                                    <li style="white-space:nowrap; margin-right:30px"><input type="checkbox" name="reason3" id="reason3" value="Y" <c:if test="${param.reason3 eq 'Y' }">checked</c:if> /> <label for="reason3">독립성기준</label></li>
                                    </c:if>
                                    <c:if test="${param.searchCondition eq 'EA4'}">
                                    <li style="white-space:nowrap; margin-right:30px"><input type="checkbox" name="reason1" id="reason1" value="Y" <c:if test="${param.reason1 eq 'Y' }">checked</c:if> /> <label for="reason1">업종별 매출액증가율 15%이상</label></li>
                                    <li style="white-space:nowrap; margin-right:30px"><input type="checkbox" name="reason2" id="reason2" value="Y" <c:if test="${param.reason2 eq 'Y' }">checked</c:if> /> <label for="reason2">R&D투자비율 2%이상</label></li>
                                    <li style="white-space:nowrap; margin-right:30px"><input type="checkbox" name="reason3" id="reason3" value="Y" <c:if test="${param.reason3 eq 'Y' }">checked</c:if> /> <label for="reason3">유예기업</label></li>
                                    </c:if>
                                    <c:if test="${param.searchCondition eq 'EA5'}">
                                    <li style="white-space:nowrap; margin-right:30px"><input type="checkbox" name="reason1" id="reason1" value="Y" <c:if test="${param.reason1 eq 'Y' }">checked</c:if> /> <label for="reason1">매출액성장률 20%이상</label></li>
                                    <li style="white-space:nowrap; margin-right:30px"><input type="checkbox" name="reason2" id="reason2" value="Y" <c:if test="${param.reason2 eq 'Y' }">checked</c:if> /> <label for="reason2">고용성장률 20%이상</label></li>                                    
                                    </c:if>
                                </ul>
                           </td>
                        </tr>
                    </table>
                    <div class="btn_page_search">
                    		<a class="btn_page_admin" href="#none" id="btn_search_ok" onclick="search_list();"><span>검색</span></a> 
                    		<a class="btn_page_admin" href="#none" id="btn_reset" onclick = "btn_input_reset();"><span id="btnReset">초기화</span></a>
                    		<a class="btn_page_admin" href="#none" id="btn_down" onclick="downloadExcel();"><span>엑셀다운로드</span></a> 
                    </div>
                </div>
                <!-- // 리스트영역-->
                <div class="block">
                        <!-- <div class="btn_page_total">
                        <select name="st" title="검색조건선택" style="width:150px; margin-right:4px;">
                            <option value="">3개년</option>
                        </select>
                        재무자료
                        <a class="btn_page_admin" href="#none" id="excelDown"><span>엑셀다운로드</span></a> 
                        </div> -->
                    <!--// 리스트 -->
                    <div class="list_zone">
                    	<ap:pagerParam />
                        <table cellpadding="0" cellspacing="0" summary="검색어 기업형태 판정사유 별로 검색조건을 입력하는 표" >
                            <caption>
                            조회결과 리스트
                            </caption>
                            <colgroup>
	                        <col width="10%" />
	                        <col width="15%" />
	                        <col width="15%" />
	                        <col width="20%" />
	                        <col width="10%" />
	                        <col width="10%" />
	                        <col width="20%" />	                        
	                        </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">기준년도</th>
                                    <th scope="col">법인번호</th>
                                    <th scope="col">사업자번호</th>
                                    <th scope="col">기업명</th>
                                    <th scope="col">대표자</th>
                                    <th scope="col">지역</th>
                                    <th scope="col">업종</th>                                    
                                </tr>
                            </thead>
                            <tbody>
								<c:forEach items="${entprsList}" var="resultInfo" varStatus="status">
								<tr>
									<td><a href="#none" onclick="fn_entrprs_detail_view('${resultInfo.STDYY}', '${resultInfo.HPE_CD}', '${resultInfo.JURIRNO}')">${resultInfo.STDYY}</a></td>
									<td style="text-align: center"><a href="#none" onclick="fn_entrprs_detail_view('${resultInfo.STDYY}', '${resultInfo.HPE_CD}', '${resultInfo.JURIRNO}')">${fn:substring(resultInfo.JURIRNO, 0, 6) }-${fn:substring(resultInfo.JURIRNO, 6, 13) }</a></td>
									<td><a href="#none" onclick="fn_entrprs_detail_view('${resultInfo.STDYY}', '${resultInfo.HPE_CD}', '${resultInfo.JURIRNO}')">${fn:substring(resultInfo.BIZRNO, 0, 3) }-${fn:substring(resultInfo.BIZRNO, 3, 5) }-${fn:substring(resultInfo.BIZRNO, 5, 10) }</a></td>
									<td><a href="#none" onclick="fn_entrprs_detail_view('${resultInfo.STDYY}', '${resultInfo.HPE_CD}', '${resultInfo.JURIRNO}')">${resultInfo.ENTRPRS_NM}</a></td>
									<td><a href="#none" onclick="fn_entrprs_detail_view('${resultInfo.STDYY}', '${resultInfo.HPE_CD}', '${resultInfo.JURIRNO}')">${resultInfo.RPRSNTV_NM}</a></td>
									<td><a href="#none" onclick="fn_entrprs_detail_view('${resultInfo.STDYY}', '${resultInfo.HPE_CD}', '${resultInfo.JURIRNO}')">${resultInfo.AREA_NM}</a></td>
									<td><a href="#none" onclick="fn_entrprs_detail_view('${resultInfo.STDYY}', '${resultInfo.HPE_CD}', '${resultInfo.JURIRNO}')">${resultInfo.KOREAN_NM}</a></td>									
								</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
                    <!-- 리스트// -->
                    <div class="mgt10"></div>
                	<ap:pager pager="${pager}" />
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
		    		<span id="load_msg">검색 중 입니다. 잠시만 기다려주십시오.</span>
		    		<br />
					시스템 상태에 따라 최대 1분 정도 소요될 수 있습니다.
				</p>
				<span><img src="<c:url value="/images/etc/loading_bar.gif" />" width="323" height="39" alt="loading" /></span>
			</div>
		</div>
	</div>
</div>
</body>
</html>