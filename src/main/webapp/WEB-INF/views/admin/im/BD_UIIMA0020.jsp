<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>정보</title>
<ap:jsTag type="web"	items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,selectbox, mask, jqGrid, css, json" />
<ap:jsTag type="tech" items="msg,util,acm,im" />
<ap:globalConst />
<script type="text/javascript">
	$(document).ready(function() {
		// 발급대상년도 초기화
		/*var fromYear = 2011;
		var toYear = Util.date.getLocalYear(); */
		//$("#confm_target_year_search").numericOptions({from:fromYear,to:toYear,sort:"desc"});		
		
		/*<c:if test="${!empty param.ad_confm_target_yy}">
		$("#confm_target_year_search").val(${param.ad_confm_target_yy});
		</c:if>*/
		
		//$("#ad_confm_target_yy").val($("#confm_target_year_search option:selected").val());
		
		// 날짜 변경했을 경우, 
		// 접수
		$("INPUT[name='rcept_de_from_search']").change(function () { 
		    	$("#ad_rcept_de_all").val("N");
		    	$("#rcept_de_from_search").attr("disabled", false);
		    	$("#rcept_de_to_search").attr("disabled", false);
		});
		
		$("INPUT[name='rcept_de_to_search']").change(function () {
		    	$("#ad_rcept_de_all").val("N");
		    	$("#rcept_de_from_search").attr("disabled", false);
		    	$("#rcept_de_to_search").attr("disabled", false);
		});
		// 발급
		$("INPUT[name='issu_de_from_search']").change(function () { 
		    	$("#ad_issu_de_all").val("N");
		    	$("#issu_de_from_search").attr("disabled", false);
		    	$("#issu_de_to_search").attr("disabled", false);
		});
		$("INPUT[name='issu_de_to_search']").change(function () { 
		  
		    	$("#ad_issu_de_all").val("N");
		    	$("#issu_de_from_search").attr("disabled", false);
		    	$("#issu_de_to_search").attr("disabled", false);
		    
		});
		
		// 조회
		$("#btn_search_issue").on("click",function(){
			
			if($("#rcept_de_from_search").val() > $("#rcept_de_to_search").val() || $("#rcept_de_from_search").val().replace(/-/gi,"") > $("#rcept_de_to_search").val().replace(/-/gi,"")){
	    		jsMsgBox($("#rcept_de_from_search"), 'error', Message.msg.invalidDateCondition );
	            return false;
	        }
			
			if($("#issu_de_from_search").val() > $("#issu_de_to_search").val() || $("#issu_de_from_search").val().replace(/-/gi,"") > $("#issu_de_to_search").val().replace(/-/gi,"")){
	    		jsMsgBox($("#issu_de_from_search"), 'error', Message.msg.invalidDateCondition );
	            return false;
	        }
			
			// 신청구분
			$("#ad_reqst_se").val($("#reqst_se_search option:selected").val());
			// 발급대상년도
			$("#ad_confm_target_yy").val($("#confm_target_year_search option:selected").val());
			// 판정사유
			$("#ad_jdgmnt_code").val($("#ad_jdgmnt_code_search option:selected").val());
			// 조회항목
			$("#ad_item").val($("#item_search option:selected").val());
			$("#ad_item_value").val($("#item_value_search").val());
			// 접수기간
			$("#ad_rcept_de_from").val($("#rcept_de_from_search").val());
			$("#ad_rcept_de_to").val($("#rcept_de_to_search").val());
			// 발급기간
			$("#ad_issu_de_from").val($("#issu_de_from_search").val());
			$("#ad_issu_de_to").val($("#issu_de_to_search").val());
			
			$("#df_method_nm").val("index");
			$("#dataForm").submit();
		});
		
		// Excel 다운로드
		$("#excelDown").click(function(){
			// 신청구분
			$("#ad_reqst_se").val($("#reqst_se_search option:selected").val());
			// 발급대상년도
			$("#ad_confm_target_yy").val($("#confm_target_year_search option:selected").val());
			// 판정사유
			$("#ad_jdgmnt_code").val($("#ad_jdgmnt_code_search option:selected").val());
			// 조회항목
			$("#ad_item").val($("#item_search option:selected").val());
			$("#ad_item_value").val($("#item_value_search").val());
			// 접수기간
			$("#ad_rcept_de_from").val($("#rcept_de_from_search").val());
			$("#ad_rcept_de_to").val($("#rcept_de_to_search").val());
			// 발급기간
			$("#ad_issu_de_from").val($("#issu_de_from_search").val());
			$("#ad_issu_de_to").val($("#issu_de_to_search").val());
			
        	/* jsFiledownload("/PGIM0020.do","df_method_nm=excelRsolver&ad_reqst_se=" + $("#ad_reqst_se").val() + "&ad_confm_target_yy=" + $("#ad_confm_target_yy").val() + "&ad_jdgmnt_code=" + $("#ad_jdgmnt_code").val() + "&ad_item=" + $("#ad_item").val() + "&ad_item_value=" + $("#ad_item_value").val() + "&ad_rcept_de_from=" + $("#ad_rcept_de_from").val() + "&ad_rcept_de_to=" + $("#ad_rcept_de_to").val() 
        			+ "&ad_issu_de_from=" + $("#ad_issu_de_from").val() + "&ad_issu_de_to=" + $("#ad_issu_de_to").val() + "&ad_rcept_de_all=" + $("#ad_rcept_de_all").val() + "&ad_issu_de_all=" + $("#ad_issu_de_all").val()); */
        	
			$("#df_method_nm").val("excelRsolver");
			$("#dataForm").submit();
        });
		
		initDatepicker();	
	});
	
	function setCalendar(id, type, val){
		
		var fromId = id+"_de_from_search";
		var toId = id+"_de_to_search";
		var adId = "ad_"+id+"_de_all";
		
		if(type=="all"){
			$("#"+fromId).attr("disabled",true);
			$("#"+toId).attr("disabled",true);
			$("#"+adId).val("Y");
		}else{
			var yyyyMMdd = Util.date.getLocalToday();
			val = Number(val);
			
			var from;
			var to = yyyyMMdd;
			
			switch(type){
			case 'year':
				from = Util.date.addYear(yyyyMMdd,val);
				break;
			case 'month':
				from = Util.date.addMonth(yyyyMMdd,val);
				break;
			case 'day':
				from = Util.date.addDate(yyyyMMdd,val);
				break;
			}	
			
			var test = new Date().toFormatString("yyyy-MM-dd");
			from = new Date(parseInt(from.substr(0, 4)),parseInt(from.substr(4, 2))-1,parseInt(from.substr(6, 2))).toFormatString("yyyy-MM-dd");
			to = new Date(parseInt(to.substr(0, 4)),parseInt(to.substr(4, 2))-1,parseInt(to.substr(6, 2))).toFormatString("yyyy-MM-dd");
			
			$("#"+fromId).val(from);
			$("#"+toId).val(to);
			
			$("#"+fromId).attr("disabled",false);
			$("#"+toId).attr("disabled",false);
			$("#"+adId).val("N");
		}
	}

	//설립년월일(달력) 초기화
	function initDatepicker(){
		$('.datepicker').datepicker({
	        showOn : 'button',        
	        buttonImage : '<c:url value="/images/acm/icon_cal.png" />',
	        buttonImageOnly : true,
	        changeYear: true,
	        changeMonth: true,
	        yearRange: "2012:+0"
	    });
		$('.datepicker').mask('0000-00-00');	
		
		$('#rcept_de_from_search').datepicker("setDate", Util.isEmpty($("#ad_rcept_de_from").val())?new Date():$("#ad_rcept_de_from").val());
		$('#rcept_de_to_search').datepicker("setDate", Util.isEmpty($("#ad_rcept_de_to").val())?new Date():$("#ad_rcept_de_to").val());
		
		$('#issu_de_from_search').datepicker("setDate", Util.isEmpty($("#ad_issu_de_from").val())?new Date():$("#ad_issu_de_from").val());
		$('#issu_de_to_search').datepicker("setDate", Util.isEmpty($("#ad_issu_de_to").val())?new Date():$("#ad_issu_de_to").val());
		
		
		if($("#ad_rcept_de_all").val()=="N"){
			$("#rcept_de_from_search").attr("disabled",false);
			$("#rcept_de_to_search").attr("disabled",false);
		}else{		
			$("#rcept_de_from_search").attr("disabled",true);
			$("#rcept_de_to_search").attr("disabled",true);
		}
		
		if($("#ad_issu_de_all").val()=="N"){
			$("#issu_de_from_search").attr("disabled",false);
			$("#issu_de_to_search").attr("disabled",false);
		}else{		
			$("#issu_de_from_search").attr("disabled",true);
			$("#issu_de_to_search").attr("disabled",true);
		}
	}
	
	
	// 신청서 상세보기
	function showRcepDetail(rceptNo, viewType, winType){
		$.colorbox({
	        title : "신청서 상세",
	        href  : "PGIC0022.do?ad_load_rcept_no="+rceptNo+"&ad_load_data=Y&ad_win_type=pop",        
	        width : "817px",
	        height: "80%",            
	        overlayClose : false,
	        escKey : false,  
	        iframe: true
	    });
	}
	
	function showDetail(title, rceptNo, methodNm, readOnly, jurirno){
		var pgmId;	
		var scrolling;
		if(methodNm=="isgnResultView"){		
			pgmId = "PGMY0060";
			scrolling = true;
		}else{
			pgmId = "PGIM0010";
			scrolling = false;
		}
		$.colorbox({
	        title : title,
	        href  : pgmId+".do?df_method_nm="+methodNm+"&ad_rcept_no="+rceptNo+"&ad_readonly="+readOnly+"&ad_jurirno="+jurirno+"&ad_load_rcept_no="+rceptNo,        
	        width : "50%",
	        height: "50%",            
	        overlayClose : false,
	        escKey : false,  
	        iframe: true,
	        scrolling: scrolling
	    });
	}
	
	function printCertIssue( issue_no, confm_se )
	{
		/* $.colorbox({
	        title : "기업확인서출력",
	        href  : "PGIM0020.do?df_method_nm=printCertIssue&issueNo="+issue_no+"&confmSe="+confm_se,//+"&output=embed",        
	        width : "980",
	        height: "710",            
	        overlayClose : false,
	        escKey : false,  
	        iframe: true,
	        scrolling: true
	    }); */
		
		window.open("PGIM0020.do?df_method_nm=processCertIssuetInfo&issueNo="+issue_no+"&confmSe="+confm_se,
				"printPop","width=700, height=750, scrollbars=yes, resizable=no");
	}
</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />
		<input type="hidden" id="ad_reqst_se" name="ad_reqst_se" value="${param.ad_reqst_se}" />
		<input type="hidden" id="ad_se_code_s" name="ad_se_code_s" value="${param.ad_se_code_s}" />
		<c:choose>
			<c:when test="${param.ad_confm_target_yy eq null}">
				<input type="hidden" id="ad_confm_target_yy" name="ad_confm_target_yy" value="2017" />
			</c:when>
			<c:otherwise>
				<input type="hidden" id="ad_confm_target_yy" name="ad_confm_target_yy" value="${param.ad_confm_target_yy}" />
			</c:otherwise>
		</c:choose>
		<input type="hidden" id="ad_item" name="ad_item" value="${param.ad_item}" />
		<input type="hidden" id="ad_item_value" name="ad_item_value" value="${param.ad_item_value}" />
		<input type="hidden" id="ad_judgment_resn" name="ad_judgment_resn" value="${param.ad_judgment_resn}" />
		<input type="hidden" id="ad_rcept_de_all" name="ad_rcept_de_all" value="${param.ad_rcept_de_all}" />
		<input type="hidden" id="ad_rcept_de_from" name="ad_rcept_de_from" value="${param.ad_rcept_de_from}" />
		<input type="hidden" id="ad_rcept_de_to" name="ad_rcept_de_to" value="${param.ad_rcept_de_to}" />
		<input type="hidden" id="ad_issu_de_all" name="ad_issu_de_all" value="${param.ad_issu_de_all}" />
		<input type="hidden" id="ad_issu_de_from" name="ad_issu_de_from" value="${param.ad_issu_de_from}" />
		<input type="hidden" id="ad_issu_de_to" name="ad_issu_de_to" value="${param.ad_issu_de_to}" />
		<input type="hidden" id="ad_jdgmnt_code" name="ad_jdgmnt_code" value="${param.ad_jdgmnt_code}" />
		
		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title">발급내역</h2>
					<!-- 타이틀 영역 //-->
					<div class="search_top">
						<table cellpadding="0" cellspacing="0" class="table_search" summary="조회 조건">
							<caption>&nbsp;</caption>
							<caption>조회 조건</caption>
							<colgroup>
								<col width="11%" />
								<col width="*" />
								<col width="11%" />
								<col width="*" />
								<col width="9%" />
								<col width="*" />
								<col width="9%" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">발급대상연도</th>
									<td>
										<!--  <select name="confm_target_year_search" title="발급대상년도" id="confm_target_year_search" style="width:91px">
                                		</select> -->
                                		<select name="confm_target_year_search" title="발급대상년도" id="confm_target_year_search" style="width:110px">
		                                	<option value="">전체</option>
		                                	<c:forEach begin="2011" end="${currentYear }" var="confmYear" varStatus="yearStatus" >
		                                	<c:set var="yearVal" value="${currentYear - (yearStatus.count-1)}" />
		                                	<option value="${yearVal}" <c:if test="${fn:contains(param.ad_confm_target_yy, yearVal)}">selected</c:if><%-- <c:if test="${yearVal == paramTargetYear}">selected</c:if> --%>>${yearVal}</option>                                	
		                                	</c:forEach>                                                           
		                                </select>
          		                    </td>
									<th scope="row">신청구분</th>
									<td>
										<ap:code id="reqst_se_search" grpCd="20" type="select" selectedCd="${param.ad_reqst_se}" ignoreCd="AK0" defaultLabel="전체" />
									</td>
									
									<%--판정사유 아직--%>
									<th scope="row">판정사유</th>
									<td>
										<ap:code id="ad_jdgmnt_code_search" grpCd="16" type="select" selectedCd="${param.ad_jdgmnt_code}" defaultLabel="전체" />
									</td>
									
									
									<th scope="row">조회항목</th>
									<td>
										<select name="item_search" title="조회항목" id="item_search" style="width:110px">
		                                    <option value="">전체</option>
		                                    <option value="jurirno" <c:if test="${param.ad_item eq 'jurirno'}">selected</c:if>>법인등록번호</option>
		                                    <option value="entrprs_nm" <c:if test="${param.ad_item eq 'entrprs_nm'}">selected</c:if>>기업명</option>
		                                    <option value="issu_no" <c:if test="${param.ad_item eq 'issu_no'}">selected</c:if>>발급번호</option>
	                                	</select>
	                                	<input value="${param.ad_item_value}" name="item_value_search" type="text" id="item_value_search" class="text" style="width:180px;" title="조회항목" />
                                	</td>
								</tr>
								<tr>
									<th scope="row">접수</th>
									<td colspan="3">
										<input type="text" value="${param.ad_rcept_de_from}" id="rcept_de_from_search" name="rcept_de_from_search" class="datepicker" style="width:83px;" />
										<strong> ~ </strong> 
										<input type="text" value="${param.ad_rcept_de_to}" id="rcept_de_to_search" name="rcept_de_to_search" class="datepicker" style="width:83px;" />
										<div class="btn_inner">
											<a href="#none" class="btn_in_gray" onclick="setCalendar('rcept','day', -20);"><span>20일</span></a> 
                                			<a href="#none" class="btn_in_gray" onclick="setCalendar('rcept','month', -1);"><span>1개월</span></a> 
                                			<a href="#none" class="btn_in_gray" onclick="setCalendar('rcept','year', -1);"><span>1년</span></a> 
                                			<a href="#none" class="btn_in_gray" onclick="setCalendar('rcept','all');"><span>전체</span></a>
										</div>
									</td>
									<th scope="row">발급</th>
									<td colspan="3">
										<input type="text" value="${param.ad_issu_de_from}" id="issu_de_from_search" name="issu_de_from_search" class="datepicker" style="width:83px;" />
										<strong> ~ </strong>
										<input type="text" value="${param.ad_issu_de_to}" id="issu_de_to_search" name="issu_de_to_search" class="datepicker" style="width:83px;" />
										<div class="btn_inner">
											<a href="#none" class="btn_in_gray" onclick="setCalendar('issu','month', -1);"><span>1개월</span></a> 
                                			<a href="#none" class="btn_in_gray" onclick="setCalendar('issu','year', -1);"><span>1년</span></a> 
                                			<a href="#none" class="btn_in_gray" onclick="setCalendar('issu','all');"><span>전체</span></a>
										</div>
										<p class="btn_src_zone">
											<a href="#none" class="btn_search" id="btn_search_issue">조회</a>
										</p>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="block">
						<ul>
							<li class="d1">‘기업명‘ : ‘기업명’을 클릭하시면 신청정보 확인 가능합니다.</li>
						</ul>
					</div>
					<div class="block ">
						<div class="btn_page_total"><a class="btn_page_admin" href="#none" id="excelDown"><span>엑셀다운로드</span></a> </div>
						<ap:pagerParam />
						<!--// 리스트 -->
						<div class="list_zone">
							<table cellspacing="0" border="0" summary="목록">
								<caption>리스트</caption>
								<colgroup>
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
										<th scope="col">신청구분</th>
										<th scope="col">대상연도</th>
										<th scope="col">발급번호(확인서)</th>
										<th scope="col">발급일</th>
										<th scope="col">유효기간</th>
										<th scope="col">판정사유</th>
										<th scope="col">신청서</th>
										<th scope="col">법인등록번호</th>
									</tr>
								</thead>
								<tbody>
									<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
									<c:if test="${fn:length(issueTaskMng) == 0}">
										<tr>
											<td colspan="8"><spring:message code="info.nodata.msg" /></td>
										</tr>
									</c:if>
									<c:forEach items="${issueTaskMng}" var="issueTaskMng" varStatus="status"> 
									<tr>
										<td class="tac">${issueTaskMng.REQST_SE_NM}</td>
										<td class="tac">${issueTaskMng.CONFM_TARGET_YY}</td>
										<td><a href="#none" onclick="printCertIssue('${issueTaskMng.ISSU_NO }', '${issueTaskMng.CONFM_SE}');">${issueTaskMng.ISSU_NO}</a></td>
										<td>${issueTaskMng.issuDe.first}-${issueTaskMng.issuDe.middle}-${issueTaskMng.issuDe.last}</td>
										<td><p>${issueTaskMng.validBeginDe.first}-${issueTaskMng.validBeginDe.middle}-${issueTaskMng.validBeginDe.last} ~ ${issueTaskMng.validEndDe.first}-${issueTaskMng.validEndDe.middle}-${issueTaskMng.validEndDe.last}</p></td>
										<td><ap:code id="" grpCd="16" selectedCd="${issueTaskMng.JDGMNT_CODE}" type="text"/></td>										
										<td>
											<c:choose>
											<c:when test="${issueTaskMng.REQST_SE eq 'AK2'}">
												<a href="#none" class="btn_in_gray" onclick="showDetail('내용변경신청 상세','${issueTaskMng.RCEPT_NO}','isgnResultView');">
													${issueTaskMng.ENTRPRS_NM}
												</a>
											</c:when>       
											<c:otherwise>
												<c:choose>	
												<c:when test="${issueTaskMng.SE_CODE_S eq 'PS6'}">
												<a href="#none" onclick="showRcepDetail('${issueTaskMng.RCEPT_NO}','view','pop')">${issueTaskMng.ENTRPRS_NM}</a>
												</c:when>       
												<c:otherwise>
												<a href="#none" onclick="showRcepDetail('${issueTaskMng.RCEPT_NO}','edit','pop')">${issueTaskMng.ENTRPRS_NM}</a>
												</c:otherwise>
												</c:choose>
											</c:otherwise>
											</c:choose>
										</td>
										<td>${issueTaskMng.jurirNo.first}-${issueTaskMng.jurirNo.last}</td>
									</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<!-- 리스트// -->
						<div class="mgt10"></div>
						<!--// paginate -->
               			<div class="paginate"> <ap:pager pager="${pager}" /> </div>
               			<!-- paginate //-->
					</div>
					<!--리스트영역 //-->
				</div>
			</div>
			<!--content//-->
		</div>
	</form>
</body>
</html>