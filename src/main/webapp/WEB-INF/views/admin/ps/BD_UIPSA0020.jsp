<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl" %>

<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,multiselect,colorboxAdmin" />
<ap:jsTag type="tech" items="util,msg,acm" />
<script type="text/javascript">

	$(document).ready(function(){
	
		tiptoggle();
	    
		var form = document.dataForm;
			  	
		// 멀티콤보박스 설정
	  	$("#searchEntprsGrpVal").multipleSelect({
	  		selectAll: true,
    		placeholder : "-- 선택 --",
    		selectAllText : "전체선택",
        	allSelected : "전체선택",
        	minimumCountSelected: 3,
        	filter: true,
        	onClick: function() {
        		if ($("#searchEntprsGrpVal").val().length > 1) {
        			$("#searchInduty").val("");
        			changeIndutyBox($("#searchInduty").val());
        			$("#searchIndutyVal").multipleSelect('disable');
        			$("#searchArea").val("");
        			changeAreaBox($("#searchArea").val());
        			$("#searchAreaVal").multipleSelect('disable');
        			$("#searchInduty").attr("disabled",true);
        			$("#searchArea").attr("disabled",true);
        		} else {
        			$("#searchInduty").removeAttr("disabled");
        			$("#searchArea").removeAttr("disabled");
        			$("#searchIndutyVal").multipleSelect('enable');
        			changeIndutyBox($("#searchInduty").val());
        			$("#searchAreaVal").multipleSelect('enable');
        			changeAreaBox($("#searchArea").val());
        		}
			}        	
	  	});
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
	  	$("#searchIndexVal").multipleSelect({
	  		selectAll: true,
    		placeholder : "-- 선택 --",
    		selectAllText : "전체선택",
        	allSelected : "전체선택",
        	minimumCountSelected: 5,
        	filter: true	
  		});
	  	
	  	$("#searchEntprsGrpVal").attr("multiple", "multiple");
	  	$("#searchIndutyVal").attr("multiple", "multiple");
	  	$("#searchAreaVal").attr("multiple", "multiple");
	  	$("#searchIndexVal").attr("multiple", "multiple");
	  	
		$("#dataForm").validate({
			rules : {
				searchStdyy: {
					required: true
				},
				searchIndex: {
					required: true
				}
			},
			submitHandler: function(form) {
				
				if ($("#searchEntprsGrpVal").multipleSelect("getSelects") == "") {
					jsMsgBox(null, "error", Message.template.noSetTarget("기업군조건"));
					return;
				}
				
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
		
		$("#searchEntprsGrpVal").html($("#searchEntprsGrp").html());
		$("#searchEntprsGrpVal").multipleSelect('refresh');
		
		<c:if test="${fn:length(paramValues.searchEntprsGrpVal) > 1}">
			$("#searchInduty").val("");
			changeIndutyBox($("#searchInduty").val());
			$("#searchIndutyVal").multipleSelect('disable');
			$("#searchArea").val("");
			changeAreaBox($("#searchArea").val());
			$("#searchAreaVal").multipleSelect('disable');
			$("#searchInduty").attr("disabled",true);
			$("#searchArea").attr("disabled",true);
		</c:if>
		<c:if test="${fn:length(paramValues.searchEntprsGrpVal) <= 1}">
			<c:if test="${not empty param.searchInduty}">changeIndutyBox("${param.searchInduty}");</c:if>
			<c:if test="${not empty param.searchArea}">changeAreaBox("${param.searchArea}");</c:if>
		</c:if>
		changeIndexBox("${searchIndex}");		
		
		<c:if test="${not empty param.searchArea and not empty param.searchInduty }">
		Util.rowSpan($("#tblStatics"), [1,2]);
		</c:if>
		<c:if test="${(not empty param.searchArea and empty param.searchInduty) or (empty param.searchArea and not empty param.searchInduty) }">
		Util.rowSpan($("#tblStatics"), [1]);
		</c:if>

	});
	
	// 업종검색 구분에 따른 상세조건 출력
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

	//지표 구분에 따른 상세조건 출력
	function changeIndexBox(val){
		var html;
		
		switch (val) {
		case "1" :
			html = $("#searchIndexType1").html();
			break;
		case "2" :
			html = $("#searchIndexType2").html();
			break;
		default :
			html = "";
		}
		
		$("#searchIndexVal").html(html);
		$("#searchIndexVal").multipleSelect('refresh');
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
	
	// 검색
	function searchStatics() {
		var form = document.dataForm;
		form.df_method_nm.value = "";
		
		$("#df_method_nm").val("");
		$("#dataForm").submit();
	}
	// 엑셀다운로드
	function downloadExcel() {
		var form = document.dataForm;

		form.df_method_nm.value = "excelStatics";
		form.submit();
		
		//$("#df_method_nm").val("excelStatics");
		//$("#dataForm").submit();
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
		var ad_type = form.ad_type.value;
		var searchIndex = form.searchIndex.value;
		var searchIndexVal = jQuery("#searchIndexVal").val();
		
		$.colorbox({
	        title : "주요지표 현황 출력",
	        href : "PGPS0020.do?df_method_nm=getPrintOut&&searchStdyy="
    		+searchStdyy+"&searchInduty="+searchInduty+"&searchIndutyVal="+searchIndutyVal+"&searchArea="
    		+searchArea+"&searchAreaVal="+searchAreaVal+"&ad_type="+ad_type+"&searchIndex="
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
		
		if ($("#searchArea option:selected").val() == "" && $("#searchInduty option:selected").val() == "" && searchEntprsGrpVal.length == 1 ) {
			jsMsgBox(null, "error", Message.template.noSetTarget("업종 또는 지역조건"));
			return;
		}
		
		var form = document.all;
		
		var searchStdyy = jQuery("#searchStdyy").val();
		var searchInduty = form.searchInduty.value;
		var searchIndutyVal = jQuery("#searchIndutyVal").val();
		var searchArea = form.searchArea.value;
		var searchAreaVal = jQuery("#searchAreaVal").val();
		var ad_type = form.ad_type.value;
		var searchIndex = form.searchIndex.value;
		var searchIndexVal = jQuery("#searchIndexVal").val();
		
		$.colorbox({
	        title : "주요지표 현황 챠트",
	        href : "PGPS0020.do?df_method_nm=getAllChart&searchStdyy="
    		+searchStdyy+"&searchInduty="+searchInduty+"&searchIndutyVal="+searchIndutyVal+"&searchArea="
    		+searchArea+"&searchAreaVal="+searchAreaVal+"&ad_type="+ad_type+"&searchIndex="
    		+searchIndex+"&searchIndexVal="+searchIndexVal+"&searchEntprsGrpVal="+searchEntprsGrpVal,
	        width : "80%",
	        height : "100%",
	        iframe : true,
	        overlayClose : false,
	        escKey : false
	    });
	}
	
	// 맵 챠트 POP UP
	function drawMapChart() {
		
		var form = document.all;
		
		var searchEntprsGrpVal = jQuery("#searchEntprsGrpVal").val();
		var searchStdyy = jQuery("#searchStdyy").val();
		var searchInduty = "1";
		var searchIndutyVal = jQuery("#searchIndutyVal").val();
		var searchArea = "1";
		var searchAreaVal = jQuery("#searchAreaVal").val();
		var ad_type = form.ad_type.value;
		var searchIndex = form.searchIndex.value;
		var searchIndexVal = jQuery("#searchIndexVal").val();
		
		$.colorbox({
	        title : "주요지표 현황 맵챠트",
	        href : "PGPS0020.do?df_method_nm=getMapChart&searchStdyy="
    		+searchStdyy+"&searchInduty="+searchInduty+"&searchIndutyVal="+searchIndutyVal+"&searchArea="
    		+searchArea+"&searchAreaVal="+searchAreaVal+"&ad_type="+ad_type+"&searchIndex="
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
<!--//content-->
<div id="wrap">
    <div class="wrap_inn">
        <div class="contents">
            <!--// 타이틀 영역 -->
            <h2 class="menu_title">주요지표 현황</h2>
            <!-- 타이틀 영역 //-->
            <form name="tabChangeForm" id="tabChangeForm" action="<c:url value='${svcUrl}' />" method="post">
			<ap:include page="param/defaultParam.jsp" />
			<ap:include page="param/dispParam.jsp" />
            </form>
            
			<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
			<ap:include page="param/defaultParam.jsp" />
			<ap:include page="param/dispParam.jsp" />
			
			<!-- 탭구분 구분 -->
			<input type="hidden" id="ad_type" name="ad_type" value="1" />
			
            <!--// tab -->
            <div class="tabwrap">
                <div class="tab">
                    <ul id="gnb">
                        <li class="on"><a href="#none" onclick="changeTab(1);">현황</a></li><li onclick="changeTab(2);"><a href="#none">구간별현황</a></li><li onclick="changeTab(3);"><a href="#none">추이</a></li><li onclick="changeTab(4);"><a href="#none">구간별추이</a></li>
                    </ul>
                </div>
                <div class="tabcon" style="display: block;">
                        <!--// 현황 조회 조건 -->
                        <div class="search_top">
                            <table cellpadding="0" cellspacing="0" class="table_search" summary="기업군 년도 업종 지역 현황 조회 조건" >
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
                                    	<select id="searchEntprsGrpVal" name="searchEntprsGrpVal" style="width:200px; ">
                                    	</select>
								    	<select id="searchEntprsGrp" name="searchEntprsGrp" style="display: none;">
										<c:forEach items="${entprsList}" var="codeVo" varStatus="status">
											<c:if test="${fn:length(paramValues.searchEntprsGrpVal) > 0 }">
								        		<option value="${codeVo.code }"
									        	<c:forEach var="val" items="${paramValues.searchEntprsGrpVal}">
								        			<c:if test="${val eq codeVo.code}"> selected="selected"</c:if>
								        		</c:forEach>
								        		>${codeVo.codeNm }</option>
											</c:if>
											<c:if test="${fn:length(paramValues.searchEntprsGrpVal) <= 0 }">
												<option value="${codeVo.code }"
												 <c:if test="${codeVo.code == 'EA1' }">selected="selected"</c:if>
												 >${codeVo.codeNm }</option>
											</c:if>
										</c:forEach>
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
		                                <select id="searchIndexType1" name="searchIndexType1" style="display: none;">
								    	<c:if test="${searchIndex eq '1' }">
											<c:forEach items="${indexSumList}" var="codeVo" varStatus="status">
								    	        <option value="${codeVo.code }"
									        	<c:forEach var="val" items="${searchIndexVal}">
								        			<c:if test="${codeVo.code eq val}"> selected="selected"</c:if>
								        		</c:forEach>									    	        
								    	        ><c:out value="${codeVo.codeNm }" /></option>
											</c:forEach>
										</c:if>
								    	<c:if test="${searchIndex ne '1' }">
											<c:forEach items="${indexSumList}" var="codeVo" varStatus="status">
												<option value="${codeVo.code }"><c:out value="${codeVo.codeNm }" /></option>
											</c:forEach>
										</c:if>
								    	</select>
			                            <select id="searchIndexType2" name="searchIndexType2" style="display: none;">
			                            <c:if test="${searchIndex eq '2' }">
											<c:forEach items="${indexAvgList}" var="codeVo" varStatus="status">
								    	        <option value="${codeVo.code }"
									        	<c:forEach var="val" items="${searchIndexVal}">
								        			<c:if test="${codeVo.code eq val}"> selected="selected"</c:if>
								        		</c:forEach>									    	        
								    	        ><c:out value="${codeVo.codeNm }" /></option>
											</c:forEach>
										</c:if>
			                            <c:if test="${searchIndex ne '2' }">
											<c:forEach items="${indexAvgList}" var="codeVo" varStatus="status">
												<option value="${codeVo.code }"><c:out value="${codeVo.codeNm }" /></option>
											</c:forEach>
										</c:if>
			                            </select>
	                              		<select name="searchIndex" id="searchIndex" title="지표선택" style="width:100px" onchange="changeIndexBox(this.value);">
		                                    <option value="1" <c:if test="${searchIndex eq '1' }"> selected="selected"</c:if>>총액</option>
		                                    <option value="2" <c:if test="${searchIndex eq '2' }"> selected="selected"</c:if>>평균</option>
		                                </select>
		                                <select id="searchIndexVal" name="searchIndexVal" style="width: 380px;"></select>
		                                <p class="btn_src_zone"><a href="#none" class="btn_search" onclick="searchStatics();">조회</a></p>
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
                        <div class="block mgt10">
                        	<h3 class="middle">${tableTitle }</h3>
                            <div class="btn_page_middle">
                            <a class="btn_page_admin" href="#none" onclick="drawMapChart();"><span id="mChart">맵챠트</span></a>
                            <a class="btn_page_admin" href="#none" onclick="drawChart();"><span>챠트</span></a>
	                        <a class="btn_page_admin" href="#none" onclick="downloadExcel();"><span>엑셀다운로드</span></a> 
	                        <a class="btn_page_admin" href="#none" onclick="printOut();"><span>출력</span></a>
                            </div>
                            <br>
                        </div>
                        <!-- // 리스트 -->
	                    <div class="list_zone">
                       <table cellspacing="0" border="0" summary="기업통계" class="list" id="tblStatics">
                           <caption>
                            리스트
                            </caption>
                            <colgroup>
							<c:if test="${fn:length(paramValues.searchEntprsGrpVal) > 1}">
	                            <col width="*" />
							</c:if>
							<c:if test="${fn:length(paramValues.searchEntprsGrpVal) == 1}">
								<c:if test="${!empty param.searchArea }">
	                            <col width="*" />
								<c:if test="${param.searchArea == '1' }"><col width="*" /></c:if>
	                        	</c:if>
								<c:if test="${!empty param.searchInduty }">
	                            <col width="*" />
								</c:if>
							</c:if>
							<c:forEach items="${columnList }" var="item" varStatus="status">
                            <col width="*" />
							</c:forEach>
                            </colgroup>
                            <thead>
                                <tr>
							<c:if test="${fn:length(paramValues.searchEntprsGrpVal) > 1}">
                                   	<th scope="col">기업군</th>
							</c:if>
							<c:if test="${fn:length(paramValues.searchEntprsGrpVal) == 1}">
								<c:if test="${!empty param.searchArea }">
									<c:if test="${param.searchArea == '1' }">
                                   	<th scope="col" colspan="2">지역</th>
									</c:if>
									<c:if test="${param.searchArea == '2' }">
                                   	<th scope="col">지역</th>
									</c:if>
								</c:if>
								<c:if test="${!empty param.searchInduty }">
                                    <th scope="col">업종/지표</th>
								</c:if>
							</c:if>
							<c:forEach items="${columnList }" var="item" varStatus="status">
                                   <th scope="col">
								<c:if test="${searchIndex == '1' }">
									<c:if test="${item == 'sumEntrprsCo' }">기업수(개)</c:if>
									<c:if test="${item == 'sumSelngAm' }">매출액(조원)</c:if>
									<c:if test="${item == 'sumBsnProfit' }">영업이익(조원)</c:if>
									<c:if test="${item == 'sumBsnProfitRt' }">영업이익률(%)</c:if>
									<c:if test="${item == 'sumXportAmDollar' }">수출액(억불)</c:if>
									<c:if test="${item == 'sumXportAmRt' }">수출비중(%)</c:if>
									<c:if test="${item == 'sumOrdtmLabrrCo' }">근로자수(만명)</c:if>
									<c:if test="${item == 'sumRsrchDevlopRt' }">R&D집약도(%)</c:if>
									<c:if test="${item == 'sumThstrmNtpf' }">당기순이익(조원)</c:if>
								</c:if>
								<c:if test="${searchIndex == '2' }">
									<c:if test="${item == 'sumEntrprsCo' }">기업수(개)</c:if>
									<c:if test="${item == 'avgSelngAm' }">평균매출액(억원)</c:if>
									<c:if test="${item == 'avgBsnProfit' }">평균영업이익(억원)</c:if>
									<c:if test="${item == 'avgBsnProfitRt' }">평균영업이익률(%)</c:if>
									<c:if test="${item == 'avgXportAmDollar' }">평균수출액(백만불)</c:if>
									<c:if test="${item == 'avgXportAmRt' }">평균수출비중(%)</c:if>
									<c:if test="${item == 'avgOrdtmLabrrCo' }">평균근로자수(백명)</c:if>
									<c:if test="${item == 'avgRsrchDevlopRt' }">평균R&D집약도(%)</c:if>
									<c:if test="${item == 'avgThstrmNtpf' }">평균당기순이익(억원)</c:if>
									<c:if test="${item == 'avgCorage' }">평균업력(년)</c:if>
								</c:if>
                                   </th>
							</c:forEach>
                                </tr>
                            </thead>
                            <tbody>
							<c:forEach items="${resultList }" var="resultInfo" varStatus="status">
								<tr>
								<c:if test="${fn:length(paramValues.searchEntprsGrpVal) > 1}">
									<td class='tac'>${resultInfo.entclsNm }</td>
								</c:if>
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
                                <c:forEach items="${columnList }" var="item" varStatus="status">
                                	<c:set var="cname" value="${item}" />
									<td class='tar'><fmt:formatNumber value="${resultInfo[cname] }"/></td>
                                </c:forEach>
								</tr>				
							</c:forEach>
                            </tbody>
                        </table>
	                    </div>
	                    <!-- 리스트// -->
                        <!--리스트영역 //-->
                    </div>
                </div>
            <!--tab //-->
            </form>
        </div>
    </div>
</div>
<!--content//-->
</body>
</html>