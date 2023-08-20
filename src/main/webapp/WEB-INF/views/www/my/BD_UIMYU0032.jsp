<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox,multifile,jBox,json" />
<ap:jsTag type="tech" items="msg,util,cmn, mainn, subb, font, my" />

<script type="text/javascript">

$(document).ready(function(){
	
	// MASK
	$("#ad_itm_51_atrb1").mask('0000');
	$('#cal_start_dt').mask('0000-00-00');
    $('#cal_end_dt').mask('0000-00-00');
    $("#ad_lmtt_lt1").mask('0000');
    $("#ad_lmtt_lt2").mask('0000');
    $("#ad_lmtt_lt3").mask('0000');
    $("#ad_lmtt_lt4").mask('0000');
    $("#ad_lmtt_lt5").mask('0000');
	
	// 달력
	$('#cal_start_dt').datepicker({
        showOn : 'button',
        defaultDate : null,
        buttonImage : '<c:url value="/images2/sub/date_ico_btn.png" />',
        buttonImageOnly : true,
        changeYear: true,
        changeMonth: true,
        yearRange: "1920:+1"
    });
    $('#cal_end_dt').datepicker({
        showOn : 'button',
        defaultDate : null,
        buttonImage : '<c:url value="/images2/sub/date_ico_btn.png" />',
        buttonImageOnly : true,
        changeYear: true,
        changeMonth: true,
        yearRange: "1920:+1"
    });
    
 	// 유효성 검사
	$("#dataForm").validate({  
		rules : {//채용제목
				ad_empmn_sj: {
					required: true
				},//모집시작날짜
				cal_start_dt: {
					required: true
				},//모집종료날짜
				cal_end_dt: {
					required: true
				},//모집인원
				ad_itm_51: {
					required: true
				},//근무형태
				ad_itm_33: {
					required: true
				},//경력
				ad_itm_25: {
					required: true
				},//학력
				ad_itm_27: {
					required: true
				},//나이
				ad_itm_52: {
					required: true
				},//근무지역
				ad_itm_22: {
					required: true
				},//모집직종
				ad_jssfc: {
					required: true
				},//질문1 글자제한
				ad_lmtt_lt1: {
					required: true
				},//질문1
				ad_quest1: {
					required: true
				},//질문2 글자제한
				ad_lmtt_lt2: {
					required: true
				},//질문2
				ad_quest2: {
					required: true
				},//질문3 글자제한
				ad_lmtt_lt3: {
					required: true
				},//질문3
				ad_quest3: {
					required: true
				},//질문4 글자제한
				ad_lmtt_lt4: {
					required: true
				},//질문4
				ad_quest4: {
					required: true
				},//질문5 글자제한
				ad_lmtt_lt5: {
					required: true
				},//질문5
				ad_quest5: {
					required: true
				},				
				
				//모집직급
				//ad_itm_31
				//모집직책
				//ad_itm_32    			
			},
		submitHandler: function(form) {
			
			// 달력 valid			
	    	if($("#cal_start_dt").val() > $("#cal_end_dt").val() || $("#cal_start_dt").val().replace(/-/gi,"") > $("#cal_end_dt").val().replace(/-/gi,"")){
	    		jsMsgBox(null, 'warn', Message.msg.invalidDateCondition);		    		
	            $("#cal_end_dt").focus();
	            return false;
	        }		    
						
			var startDt = $('#cal_start_dt').cleanVal();
			var endDt = $('#cal_end_dt').cleanVal();
			$("#ad_rcrit_begin_de").val(startDt);
			$("#ad_rcrit_end_de").val(endDt);
			
			// 채용관리 항목 관련 파라미터 생성
			var jsonArray = [];
			var ad_itm_27;				// 학력조건
			var ad_itm_27_atrb1 = "N";	// 졸업예정자 가능여부
			
			jsonArray = jsonArray.concat(fnMakeCodeJson("ad_itm_51", "51", "A"));			
			jsonArray = jsonArray.concat(fnMakeCodeJson("ad_itm_33", "33", null));			
			jsonArray = jsonArray.concat(fnMakeCodeJson("ad_itm_25", "25", "CK2"));
			jsonArray = jsonArray.concat(fnMakeCodeJson("ad_itm_52", "52", null));
			jsonArray = jsonArray.concat(fnMakeCodeJson("ad_itm_22", "22", null));
			jsonArray = jsonArray.concat(fnMakeCodeJson("ad_itm_31", "31", null));
			jsonArray = jsonArray.concat(fnMakeCodeJson("ad_itm_32", "32", null));
			
			// 학력 조건 파라미터 생성
			ad_itm_27_atrb1 = $("#ad_itm_27_atrb1").is(":checked") ? "Y" : "N";
			
			ad_itm_27 = [{
				grpCd : "27",
				itmValue : $("#ad_itm_27").val(),
				atrb1 : ad_itm_27_atrb1
			}];
			
			jsonArray = jsonArray.concat(ad_itm_27);
			
			$("#ad_grp_code_json").val(JSON.stringify(jsonArray));
			$("#df_method_nm").val("processEmpmnInfo");
			
			$("#dataForm").ajaxSubmit({
				url      : "PGMY0030.do",
				type     : "post",
				dataType : "text",
				async    : false,
				success  : function(response) {
					try {						
						var returnObj = JSON.parse(response);
						if(eval(returnObj.result)) {							
							<c:if test="${FORM_TYPE == 'UPDATE'}">
							jsMsgBox(null,'info',Message.msg.updateOk, function() {
								$("#df_method_nm").val("empmnInfoView");
								document.dataForm.submit();
							});
							</c:if>
							<c:if test="${FORM_TYPE == 'INSERT' || FORM_TYPE == 'COPY'}">
							jsMsgBox(null,'info',Message.msg.insertOk, function() {
								$("#ad_empmn_manage_no").val(returnObj.EMPMN_MANAGE_NO);
								$("#df_method_nm").val("empmnInfoView");
								document.dataForm.submit();
							});
							</c:if>													
						} else {
							jsErrorBox(Message.msg.processFail);
						}
					} catch (e) {
						jsSysErrorBox(response, e);
						return;
					}                            
				}
			});
			
		}
	}); 	
 	
 	// 경력 - 무관 클릭
	$("#ad_itm_25_cb_1").click(function() {
		var $otherChks = $("input[name='ad_itm_25']").not($(this));
		var chYn = this.checked;
		
		$otherChks.prop('disabled', chYn);
		$otherChks.each(function() {
			if($(this).is(":checked")) {
				$otherChks.prop('checked', !chYn);	
			}	
		});
		
		$("#ad_itm_25_atrb1").val("").attr("disabled", chYn);
		$("#ad_itm_25_atrb2").val("").attr("disabled", chYn);
		
	});
 	
 	// 수정화면 전체연령, 전국 선택되어있는 경우 처리
 	var $allAge = $("input[name='ad_itm_52']").eq(0);
 	var $allArea = $("input[name='ad_itm_22']").eq(0);
 	if($allAge.is(":checked") == true) {
 		allChkDisabled($allAge, true);	
 	}
 	if($allArea.is(":checked") == true) {
 		allChkDisabled($allArea, true);	
 	}
 	 	 	
 	// 나이 - 전체연령
 	$("input[name='ad_itm_52']").change(function(){
 		if($(this).val() == 'AG0') {
 			allChkDisabled($(this), this.checked);
 		}
 	});
 	// 근무지역 - 전국
 	$("input[name='ad_itm_22']").change(function(){
 		if($(this).val() == 'WA00') {
 			allChkDisabled($(this), this.checked);
 		}
 	});
 	// 내부 입사지원시스템
 	$("#ad_ecny_apply_div").click(function(){
 		var ischked = this.checked; 		 		
 		$("#ad_ecny_apply__web_adres").attr("disabled", !this.checked);
 	});
 	
 	// 저장
 	$("#btn_submit").click(function(){
 		$("#dataForm").submit();
 	});
 	
 	// 취소
 	$("#btn_cancel").click(function(){
 		
 		<c:if test="${FORM_TYPE == 'UPDATE'}">
 		jsMsgBox(null, "confirm", Message.msg.noSaveConfirm, function(){
			$("#df_method_nm").val("empmnInfoView");
			document.dataForm.submit();
		});
		</c:if>
		<c:if test="${FORM_TYPE == 'INSERT' || FORM_TYPE == 'COPY'}">
		jsMsgBox(null, "confirm", Message.msg.noSaveConfirm, function(){
 			$("#df_method_nm").val("");
 			document.dataForm.submit();
 		});
		</c:if>
 	});
 	
 	// 질문 체크박스
 	$("input[name='chk_quest']").click(function(){
 		var diableYn = !this.checked;
 		$(this).closest('li').find("input:text").attr("disabled", diableYn).val(""); 		
 	});
 	
 	// 질문길이 최대 2400자
 	$("input[id^='ad_lmtt_lt']").keyup(function() { 		
 		if($(this).val() > 2400) {
 			$(this).val(2400);
 		}
 	});
 	
 	// mutifile-upload (양식첨부)
    $("#form_file").MultiFile({
		accept: 'hwp|doc|docx|pdf|jpg|jpge|zip',
		max: '1',		
		STRING: {			
			remove: '<img src="<c:url value="/images/ucm/icon_del.png" />" alt="x" />',
			denied: Message.msg.fildUploadDenied,  		//확장자 제한 문구
			duplicate: Message.msg.fildUploadDuplicate	//중복 파일 문구
		}
	});
 	
    $("#workType").children("ul").attr("class","check_sy2");
    for(var i=0; i < $("#workType").children("ul").children("li").length; i++){
    	var tempId = $("#workType").children("ul").children("li").eq(i).children("input").attr("id");
    	$("#workType").children("ul").children("li").eq(i).children("input").after("<label for='"+ tempId +"'></label>");
    }
    
    $("#age").children("ul").attr("class","check_sy2");
    for(var i=0; i < $("#age").children("ul").children("li").length; i++){
    	var tempId = $("#age").children("ul").children("li").eq(i).children("input").attr("id");
    	$("#age").children("ul").children("li").eq(i).children("input").after("<label for='"+ tempId +"'></label>");
    }

    $("#region").children("ul").attr("class","check_sy2");
    for(var i=0; i < $("#region").children("ul").children("li").length; i++){
    	var tempId = $("#region").children("ul").children("li").eq(i).children("input").attr("id");
    	$("#region").children("ul").children("li").eq(i).children("input").after("<label for='"+ tempId +"'></label>");
    }
    
    $("#jobLevel").children("ul").attr("class","check_sy2");
    for(var i=0; i < $("#jobLevel").children("ul").children("li").length; i++){
    	var tempId = $("#jobLevel").children("ul").children("li").eq(i).children("input").attr("id");
    	$("#jobLevel").children("ul").children("li").eq(i).children("input").after("<label for='"+ tempId +"'></label>");
    }
    
    $("#jobGrade").children("ul").attr("class","check_sy2");
    for(var i=0; i < $("#jobGrade").children("ul").children("li").length; i++){
    	var tempId = $("#jobGrade").children("ul").children("li").eq(i).children("input").attr("id");
    	$("#jobGrade").children("ul").children("li").eq(i).children("input").after("<label for='"+ tempId +"'></label>");
    }
    
    $("#choiceFile").click(function(){
    	$("[name=form_file]").attr("id","form_file");
    });
    
	$("#ad_itm_27").attr("class","select_box");
    
 	// tooltip
    setDescView();
});

var fnMakeCodeJson = function(name, grpCd, atrbCon) {
	var obj = {};
	var array = [];
	var atrbNm1 = name + "_atrb1"
	var atrbNm2 = name + "_atrb2"
	
	$("input[name='"+ name +"']:checked:not(:disabled)").each(function() {
		obj = {};
		obj.grpCd = grpCd;
		obj.itmValue = $(this).val();
		if(atrbCon && $(this).val() == atrbCon) {
			obj.atrb1 = $("#" + atrbNm1).val();
			obj.atrb2 = $("#" + atrbNm2).val();
		}		
		array.push(obj);		
	});	
	return array;
}

//첨부파일 다운로드
function downAttFile(fileSeq){
	jsFiledownload("/PGCM0040.do","df_method_nm=updateFileDownBySeq&seq="+fileSeq);
}

//첨부파일 삭제
function delAttFile(fileSeq){	
	
	jsMsgBox(null, "confirm", Message.msg.fileDeleteConfirm, function() {
		
		$.ajax({        
	        url      : "PGMY0030.do",
	        type     : "POST",
	        dataType : "json",
	        data     : {
	        			df_method_nm:"deleteAttFile"
	        			, file_seq:fileSeq
	        			, empmn_manage_no:$("#ad_empmn_manage_no").val()        			
	        },                
	        async    : false,                
	        success  : function(response) {        	
	        	try {
	        		if(response.result) {	        			
	        			jsMsgBox(null,'info',Message.msg.successDelete);
	        			$("#form_file").attr("disabled", false);
	        			$("#atch_file_view").remove();
	                } else {
	                	jsMsgBox(null,'info',Message.msg.failDelete);
	                }
	            } catch (e) {            	            	
	                if(response != null) {
	                	jsSysErrorBox(response.err_code+": "+response.err_msg);
	                } else {
	                    jsSysErrorBox(e);
	                }
	                return;
	            }
	        }
	    });
		
	});
}

//[?]표시 설명
function setDescView(){
	$("#tool_add_1").jBox('Tooltip', {
		content: '고등학교학력, 대학/대학원학력 별 학교명, 소재지, 입학/졸업년도, 전공/부전공, 학점'
	});
	$("#tool_add_2").jBox('Tooltip', {
		content: '보훈대상여부, 취업보호대상여부, 고용지원금대상여부, 장애여부 및 등급, 병역사항'
	});
	$("#tool_add_3").jBox('Tooltip', {
		content: '외국어 별 수준, 외국어시험의 취득점수 및 취득일자'
	});
	$("#tool_add_4").jBox('Tooltip', {
		content: '교육명, 교육기관, 교육기간, 교육내용'
	});
	$("#tool_add_5").jBox('Tooltip', {
		content: '연구국가, 교육명, 연수기간, 연수내용 및 목적'
	});
	$("#tool_add_6").jBox('Tooltip', {
		content: '자격명 및 등급, 자격번호, 취득일자, 발행기관'
	});
	$("#tool_add_7").jBox('Tooltip', {
		content: '수상명, 발행기관, 발행일'
	});	
}

// 전체연령, 전국 checkbox
function allChkDisabled($obj, isChecked) {
	var objname = $obj.attr("name");
	
	$("input[name='"+objname+"']").each(function(){
		var $this = $(this);
		if($obj.val() != $this.val()) {
			$this.prop("checked", isChecked);
			$this.prop("disabled", isChecked);
		}
	});
	
}


</script>

</head>
<body>
	<div id="wrap" class="top_bg">
		<c:set var="itm_51" value="" />					<%-- 모집인원 --%>
		<c:set var="itm_51_atrb1" value="" />			<%-- 모집인원 입력 --%>
		<c:set var="itm_25_atrb1" value="" />			<%-- 경력min --%>
		<c:set var="itm_25_atrb2" value="" />			<%-- 경력max --%>
		<c:set var="itm_27" value="" />					<%-- 학력 --%>
		<c:set var="itm_27_atrb1" value="" />			<%-- 졸업예정자 가능여부 --%>
		
		<c:if test="${not empty dataMap.itemList }">
		<c:forEach items="${dataMap.itemList }" var="item">
			<c:choose>
				<c:when test="${item.PBLANC_IEM == '51'}">
					<c:set var="itm_51" value="${item.IEM_VALUE }" />
					<c:if test="${item.IEM_VALUE == 'A' }">
						<c:set var="itm_51_atrb1" value="${item.ATRB1 }" />
					</c:if>
				</c:when>
				<c:when test="${item.PBLANC_IEM == '25' && item.IEM_VALUE == 'CK2'}">
					<c:set var="itm_25_atrb1" value="${item.ATRB1 }" />
					<c:set var="itm_25_atrb2" value="${item.ATRB2 }" />
				</c:when>
				<c:when test="${item.PBLANC_IEM == '27'}">
					<c:set var="itm_27" value="${item.IEM_VALUE }" />
					<c:set var="itm_27_atrb1" value="${item.ATRB1 }" />
				</c:when>		
			</c:choose>
		</c:forEach>
		</c:if>

		<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" enctype="multipart/form-data" method="post">
			<div class="s_cont" id="s_cont">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />

				<input type="hidden" id="ad_empmn_manage_no" name="ad_empmn_manage_no" value="${dataMap.EMPMN_MANAGE_NO }" />	<%-- 채용관리번호 --%>
				<input type="hidden" id="ad_rcrit_begin_de" name="ad_rcrit_begin_de" /> 	<%-- 모집시작일자 --%>
				<input type="hidden" id="ad_rcrit_end_de" name="ad_rcrit_end_de" /> 		<%-- 모집종료일자 --%>
				<input type="hidden" id="ad_grp_code_json" name="ad_grp_code_json" />
				<input type="hidden" id="df_formType" name="df_formType" value="${FORM_TYPE }" />
				<input type="hidden" id="ad_bizrno" name="ad_bizrno" value="${param.ad_bizrno }" />

				<div class="s_tit s_tit06">
					<h1>마이페이지</h1>
				</div>
				<div class="s_wrap">
					<div class="l_menu">
						<h2 class="tit tit6">마이페이지</h2>
						<ul>
						</ul>
					</div>
					<div class="r_sec">
						<div class="r_top">
							<ap:trail menuNo="${param.df_menu_no}" />
						</div>
						
					<div class="r_cont s_cont06_03">
						<div class="list_bl">
							<h4 class="fram_bl none"><p style="margin-top:0"><img src="/images2/sub/table_check.png">항목은 입력 필수 항목입니다.</p></h4>
							<table class="table_form">
								<colgroup>
									<col width="172px">
									<col width="*">
								</colgroup>
								<tbody>
	                                <tr>
	                                    <th><img src="/images2/sub/table_check.png">채용제목</th>
	                                    <td class="b_l_0">
	                                    	<input name="ad_empmn_sj" type="text" id="ad_empmn_sj" style="width: 541px" value="${dataMap.EMPMN_SJ }" />
	                                    </td>
	                                </tr>
	                                <tr>
	                                    <th><img src="/images2/sub/table_check.png">모집기간</th>
	                                    <td class="b_l_0 date">
	                                    	<input type="text" id="cal_start_dt" class="text" style="width: 104px;margin-right: 5px;" title="시작기간" value="${dataMap.RCRIT_BEGIN_DE }" />
	                                         ~
	                                        <input type="text" id="cal_end_dt" class="text" style="width: 104px;margin-right: 5px;" title="종료기간" value="${dataMap.RCRIT_END_DE }" />                                        
	                                   </td>
	                                </tr>
	                                <tr>
	                                    <th><img src="/images2/sub/table_check.png">모집인원</th>
	                                    <td class="b_l_0">
	                                    	<ul class="radio_sy">
	                                    		<li style="margin-right: 40px;">
													<input type="radio" id="ad_itm_51_cb_1" name="ad_itm_51" value="A" <c:if test="${itm_51 == 'A' }">checked</c:if>/>
													<label for="ad_itm_51_cb_1" style="margin-top: 11px;"></label>
													<label for="ad_itm_51_cb_1">
														<input type="text" name="ad_itm_51_atrb1" for="ad_itm_51_cb_1" id="ad_itm_51_atrb1"  value="${itm_51_atrb1 }" style="width: 81px;"> 명
													</label>
												</li>
		                                    	<li style="margin-top: 11px; margin-right: 48px;">
													<input type="radio" id="ad_itm_51_cb_2" name="ad_itm_51" value="B" <c:if test="${itm_51 == 'B' }"> checked</c:if>/>
													<label for="ad_itm_51_cb_2"></label>
													<label for="ad_itm_51_cb_2">0명</label>
												</li>
												<li style="margin-top: 11px; margin-right: 48px;">
													<input type="radio" id="ad_itm_51_cb_3" name="ad_itm_51" value="C" <c:if test="${itm_51 == 'C' }"> checked</c:if>/>
													<label for="ad_itm_51_cb_3"></label>
													<label for="ad_itm_51_cb_3">00명</label>
												</li>
												<li style="margin-top: 11px;">
													<input type="radio" id="ad_itm_51_cb_4" name="ad_itm_51" value="D" <c:if test="${itm_51 == 'D' }"> checked</c:if>/>
													<label for="ad_itm_51_cb_4"></label>
													<label for="ad_itm_51_cb_4">000명</label>
												</li>
	                                        </ul>
	                                    </td>
	                                </tr>
	                                <tr>
	                                    <th><img src="/images2/sub/table_check.png">근무형태</th>
	                                    <td colspan="1" class="u0032_1 b_l_0" id="workType">
	                                    	<ap:code id="ad_itm_33" grpCd="33" type="checkbox" selectedCd="${dataMap.iem33 }" />                                    	
	                                	</td>
	                                </tr>
	                                <tr>
	                                    <th><img src="/images2/sub/table_check.png">경력</th>
	                                    <!-- <td colspan="1" class="u0032_1"> -->
	                                    <td class="b_l_0">
	                                    	<ul class="check_sy2 hasinput">                                            
	                                            <li>
	                                                <input type="checkbox" name="ad_itm_25" id="ad_itm_25_cb_1" value="CK0" <c:if test="${fn:contains(dataMap.iem25, 'CK0')}"> checked</c:if>/>
	                                                <label for="ad_itm_25_cb_1"></label>
	                                                <label for="ad_itm_25_cb_1">무관</label>
	                                            </li>
	                                            <li>
	                                                <input type="checkbox" name="ad_itm_25" id="ad_itm_25_cb_2" value="CK1" <c:if test="${fn:contains(dataMap.iem25, 'CK1')}"> checked</c:if>/>
	                                                <label for="ad_itm_25_cb_2"></label>
	                                                <label for="ad_itm_25_cb_2">신입</label>
	                                            </li>
	                                            <li style="width:60%;" class="itsme">
	                                                <input type="checkbox" name="ad_itm_25" id="ad_itm_25_cb_3" value="CK2" <c:if test="${fn:contains(dataMap.iem25, 'CK2')}"> checked</c:if>/>
	                                                <label for="ad_itm_25_cb_3"></label>
	                                                <label for="ad_itm_25_cb_3">경력
		                                                <select class="select_box" style="width:100px;" name="ad_itm_25_atrb1" id="ad_itm_25_atrb1">
		                                                	<option value="">-- 선택 --</option>
		                                                    <c:forEach begin="1" end="20" var="atrb1Cnt">
		                                                    <option value="${atrb1Cnt }" <c:if test="${atrb1Cnt == itm_25_atrb1 }">selected="selected"</c:if> >${atrb1Cnt }년이상</option>
		                                                    </c:forEach>
		                                                </select>
		                                                ~
		                                                <select class="select_box" style="width:100px;" name="ad_itm_25_atrb2" id="ad_itm_25_atrb2">
		                                                    <option value="">-- 선택 --</option>
		                                                    <c:forEach begin="1" end="20" var="atrb2Cnt">
		                                                    <option value="${atrb2Cnt }" <c:if test="${atrb2Cnt == itm_25_atrb2 }">selected="selected"</c:if> >${atrb2Cnt }년미만</option>
		                                                    </c:forEach>
		                                                </select>
		                                            </label>
	                                            </li>
	                                            <li></li>
	                                        </ul>
	                                   	</td>
	                                </tr>
	                                <tr>
	                                    <th class="p_l_30">경력 상세요건</th>
	                                    <td class="b_l_0"><input name="ad_career_detail_rqisit" type="text" id="ad_career_detail_rqisit" style="width:541px;" value="${dataMap.CAREER_DETAIL_RQISIT }" /></td>
	                                </tr>
	                                <tr>
	                                    <th><img src="/images2/sub/table_check.png">학력</th>
	                                    <!-- <td colspan="1" class="u0032_1"> -->
	                                    <td class="b_l_0">
	                                    	<ul class="check_sy2 hasinput">
	                                            <li style="width: 40%;" class="itsme">                                              
	                                                <ap:code id="ad_itm_27" grpCd="27" type="select" selectedCd="${itm_27 }" />                                                
	                                            </li>
	                                            <li>
	                                                <input type="checkbox" name="ad_itm_27_atrb1" id="ad_itm_27_atrb1" <c:if test="${itm_27_atrb1 == 'Y' }">checked</c:if> />
	                                                <label for="ad_itm_27_atrb1"></label>
	                                                <label for="ad_itm_27_atrb1">졸업예정자 가능</label>
	                                            </li>
	                                        </ul>
	                                	</td>
	                                </tr>                                
	                                <tr>
	                                    <th><img src="/images2/sub/table_check.png">나이</th>
	                                    <!-- td colspan="1" class="u0032_1"> -->
	                                    <td class="b_l_0" id="age">
	                                    	<ap:code id="ad_itm_52" grpCd="52" type="checkbox" selectedCd="${dataMap.iem52 }" />
	                                	</td>
	                                </tr>
	                                <tr>
	                                    <th><img src="/images2/sub/table_check.png">근무지역</th>
	                                    <!-- <td colspan="1" class="u0032_2"> -->
	                                    <td class="b_l_0" id="region">
	                                    	<ap:code id="ad_itm_22" grpCd="22" type="checkbox" selectedCd="${dataMap.iem22 }" />
	                                    </td>
	                                </tr>
	                                <tr>
	                                    <th><img src="/images2/sub/table_check.png">모집직종</th>
	                                    <td class="b_l_0">
			                    			<select class="select_box" name="ad_jssfc" id="ad_jssfc" style="width:500px; margin-top:5px;">
												<option value="">직종</option>
												<c:forEach items="${jssfcLargeList}" var="list" varStatus="status">
													<option value="${list.CODE},${list.CODE_NM}"
														<c:if test="${list.CODE == dataMap.JSSFC_CODE}"> selected=="selected"</c:if>>${list.CODE_NM }</option>
												</c:forEach>
			                    			</select>
			                    		</td>
	                                </tr>
	                                <tr>
	                                    <th class="p_l_30">모집직급</th>
	                                    <td class="b_l_0 u0032_3" id="jobLevel">
	                                    	<ap:code id="ad_itm_31" grpCd="31" type="checkbox" selectedCd="${dataMap.iem31 }" />
	                                    </td>
	                                </tr>
	                                <tr>
	                                    <th class="p_l_30">모집직책</th>
	                                    <td class="u0032_3 b_l_0" id="jobGrade">
	                                    	<ap:code id="ad_itm_32" grpCd="32" type="checkbox" selectedCd="${dataMap.iem32 }" />
	                                    </td>
	                                </tr>
	                                <tr>
	                                    <th class="p_l_30">우대조건</th>
	                                    <td class="b_l_0"><input name="ad_pvltrt_cnd" type="text" id="ad_pvltrt_cnd" style="width:541px;" value="${dataMap.PVLTRT_CND }" /></td>
	                                </tr>
	                                <tr>
	                                    <th class="p_l_30">업무내용</th>
	                                    <td class="b_l_0" style="line-height:0;"><textarea name="ad_job_cn" id="ad_job_cn" rows="5" title="내용입력란" style="width: 688px; height: 132px;" >${dataMap.JOB_CN }</textarea></td>
	                                </tr>
	                                <tr>
	                                	<th class="p_l_30" rowspan="5">추가입력</th>	                                    
	                                    <td class="b_l_0">
	                                    	<ul class="check_sy2 intext">
												<li style="width: auto; padding-right: 30px;"><p>기업의 내부 입사지원시스템을 이용하시겠습니까?</p></li>
												<li style="width: auto;">
													<input type="checkbox" id="ad_ecny_apply_div" name="ad_ecny_apply_div" class=" ml40" value="F" <c:if test="${dataMap.ECNY_APPLY_DIV == 'F' }">checked</c:if> />	                                        
													<label for="ad_ecny_apply_div"></label>
													<label for="ad_ecny_apply_div"><input name="ad_ecny_apply__web_adres" type="text" id="ad_ecny_apply__web_adres" required maxlength="200" style="width: 336px" disabled placeholder="입사지원 웹주소(예:http://www.mme.or.kr)" value="${dataMap.ECNY_APPLY__WEB_ADRES }" <c:if test="${dataMap.ECNY_APPLY_DIV != 'F' }">disabled="disabled"</c:if> />
													</label>
												</li>
											</ul>
	                                    </td>
	                                </tr>                                
	                                <tr>
	                                	<td class="b_l_0">
											<ul class="check_sy2 w_25">
												<li style="width: auto; padding-right: 30px;"><p>입사지원자로부터 사진을 입력 받을 경우 선택하여 주세요.</p></li>
												<li style="width: auto;">
													<input type="checkbox" id="ad_photo_input_at" name="ad_photo_input_at" class=" ml40" value="Y" <c:if test="${dataMap.PHOTO_INPUT_AT == 'Y' }">checked</c:if> />
													<label for="ad_photo_input_at"></label>
													<label for="ad_photo_input_at">지원자 사진</label>
												</li>
											</ul>
										</td>	                                    
	                                </tr>	                                
	                                <tr>
	                                    <!-- <td colspan="1" class="u0032_3"> -->
	                                    <td class="b_l_0">
											<ul class="check_sy2 w_25">
												<li style="width: 100%;"><p>입사지원자에게 추가적으로 입력 받을 항목을 선택하여 주세요.</p></li>
	                                            <li>
	                                                <input type="checkbox" name="ad_detail_acdmcr_input_at" id="ad_detail_acdmcr_input_at" value="Y" <c:if test="${dataMap.DETAIL_ACDMCR_INPUT_AT == 'Y' }">checked</c:if> />
	                                                <label for="ad_detail_acdmcr_input_at"></label>
	                                                <label for="ad_detail_acdmcr_input_at">상세학력</label>
	                                                <img src="/images2/sub/help_btn.png" width="20" height="20" alt="내용보기" id="tool_add_1" /></li>
	                                            <li>
	                                                <input type="checkbox" name="ad_empymn_pvltrt_matter_input_at" id="ad_empymn_pvltrt_matter_input_at" value="Y" <c:if test="${dataMap.EMPYMN_PVLTRT_MATTER_INPUT_AT == 'Y' }">checked</c:if> />
	                                                <label for="ad_empymn_pvltrt_matter_input_at"></label>
	                                                <label for="ad_empymn_pvltrt_matter_input_at">취업우대사항</label>
	                                                <img src="/images2/sub/help_btn.png" width="20" height="20" alt="내용보기" id="tool_add_2" /></li>
	                                            <li style="width:280px;">
	                                                <input type="checkbox" name="ad__else_lgty_input_at" id="ad__else_lgty_input_at" value="Y" <c:if test="${dataMap._ELSE_LGTY_INPUT_AT == 'Y' }">checked</c:if> />
	                                                <label for="ad__else_lgty_input_at"></label>
	                                                <label for="ad__else_lgty_input_at">어학시험 및 외국어 구사능력</label>
	                                                <img src="/images2/sub/help_btn.png" width="20" height="20" alt="내용보기" id="tool_add_3" /></li>
	                                            <li>
	                                                <input type="checkbox" name="ad_edc_compl_input_at" id="ad_edc_compl_input_at" value="Y" <c:if test="${dataMap.EDC_COMPL_INPUT_AT == 'Y' }">checked</c:if> />
	                                                <label for="ad_edc_compl_input_at"></label>
	                                                <label for="ad_edc_compl_input_at">교육이수</label>
	                                                <img src="/images2/sub/help_btn.png" width="20" height="20" alt="내용보기" id="tool_add_4" /></li>
	                                            <li>
	                                                <input type="checkbox" name="ad_ovsea_sdytrn_input_at" id="ad_ovsea_sdytrn_input_at" value="Y" <c:if test="${dataMap.OVSEA_SDYTRN_INPUT_AT == 'Y' }">checked</c:if> />
	                                                <label for="ad_ovsea_sdytrn_input_at"></label>
	                                                <label for="ad_ovsea_sdytrn_input_at">해외연수 경력</label>
	                                                <img src="/images2/sub/help_btn.png" width="20" height="20" alt="내용보기" id="tool_add_5" /></li>
	                                            <li>
	                                                <input type="checkbox" name="ad_qualf_acqs_input_at" id="ad_qualf_acqs_input_at" value="Y" <c:if test="${dataMap.QUALF_ACQS_INPUT_AT == 'Y' }">checked</c:if> />
	                                                <label for="ad_qualf_acqs_input_at"></label>
	                                                <label for="ad_qualf_acqs_input_at">자격취득 내역</label>
	                                                <img src="/images2/sub/help_btn.png" width="20" height="20" alt="내용보기" id="tool_add_6" /></li>
	                                            <li>
	                                                <input type="checkbox" name="ad_wtrc_dtls_input_at" id="ad_wtrc_dtls_input_at" value="Y" <c:if test="${dataMap.WTRC_DTLS_INPUT_AT == 'Y' }">checked</c:if> />
	                                                <label for="ad_wtrc_dtls_input_at"></label>
	                                                <label for="ad_wtrc_dtls_input_at">수상내역</label>
	                                                <img src="/images2/sub/help_btn.png" width="20" height="20" alt="내용보기" id="tool_add_7" /></li>
	                                        </ul></td>
	                                </tr>
	                                <tr>
	                                	<td class="b_l_0">
											<ul class="check_sy2 w_100 intext">
	                                        <!-- <ul class="u0032_4" style="margin-top:10px"> -->
												<li><p>입사지원자에게 공통적으로 질문할 문항이 있으시면 체크버튼을 선택하시고 질문을 입력해주세요</p></li>
	                                            <li>
	                                            	<c:choose>
	                                            	<c:when test="${not empty dataMap.QUEST1 }">
	                                            		<input type="checkbox" name="chk_quest" id="chk_quest1" checked />
	                                            		<label for="chk_quest1"></label>
		                                                <label for="chk_quest1">질문1</label>
		                                                <input name="ad_lmtt_lt1" type="text" id="ad_lmtt_lt1" style="width: 101px; title="질문1의 글자 수 제한" value="${dataMap.LMTT_LT1 }" />
		                                                글자 이하
		                                                <input name="ad_quest1" type="text" id="ad_quest1" style="width: 431px;" title="질문1" value="${dataMap.QUEST1 }" />
	                                            	</c:when>
	                                            	<c:otherwise>                                            	                                            	
		                                                <input type="checkbox" name="chk_quest" id="chk_quest1" />
		                                                <label for="chk_quest1"></label>
		                                                <label for="chk_quest1">질문1</label>
		                                                <input name="ad_lmtt_lt1" type="text" id="ad_lmtt_lt1" style="width: 101px; title="질문1의 글자 수 제한" disabled="disabled"/>
		                                                글자 이하
		                                                <input name="ad_quest1" type="text" id="ad_quest1" style="width: 431px;" title="질문1" disabled="disabled" />
	                                                </c:otherwise>
	                                                </c:choose>
	                                            </li>
	                                            <li>
	                                                <input type="checkbox" name="chk_quest" id="chk_quest2" />
	                                                <label for="chk_quest2"></label>
	                                                <label for="chk_quest2">질문2</label>
	                                                <input name="ad_lmtt_lt2" type="text" id="ad_lmtt_lt2" style="width: 101px; title="질문2의 글자 수 제한" disabled="disabled"/>
	                                                글자 이하
	                                                <input name="ad_quest2" type="text" id="ad_quest2" style="width: 431px;" title="질문2" disabled="disabled" />
	                                            </li>
	                                            <li>
	                                                <input type="checkbox" name="chk_quest" id="chk_quest3" />
	                                                <label for="chk_quest3"></label>
	                                                <label for="chk_quest3">질문3</label>
	                                                <input name="ad_lmtt_lt3" type="text" id="ad_lmtt_lt3" style="width: 101px; title="질문3의 글자 수 제한" disabled="disabled"/>
	                                                글자 이하
	                                                <input name="ad_quest3" type="text" id="ad_quest3" style="width: 431px;" title="질문3" disabled="disabled" />
	                                            </li>
	                                            <li>
	                                                <input type="checkbox" name="chk_quest" id="chk_quest4" />
	                                                <label for="chk_quest4"></label>
	                                                <label for="chk_quest4">질문4</label>
	                                                <input name="ad_lmtt_lt4" type="text" id="ad_lmtt_lt4" style="width: 101px; title="질문4의 글자 수 제한" disabled="disabled"/>
	                                                글자 이하
	                                                <input name="ad_quest4" type="text" id="ad_quest4" style="width: 431px;" title="질문4" disabled="disabled" />
	                                            </li>
	                                            <li>
	                                                <input type="checkbox" name="chk_quest" id="chk_quest5" />
	                                                <label for="chk_quest5"></label>
	                                                <label for="chk_quest5">질문5</label>
	                                                <input name="ad_lmtt_lt5" type="text" id="ad_lmtt_lt5" style="width: 101px; title="질문5의 글자 수 제한" disabled="disabled"/>
	                                                글자 이하
	                                                <input name="ad_quest5" type="text" id="ad_quest5" style="width: 431px;" title="질문5" disabled="disabled" />
	                                            </li>
	                                        </ul></td>
	                                </tr>
	                                <tr>
	                                    <td class="b_l_0">                                                                               
	                                        <ul class="check_sy2 w_100">
												<li><p>양식등록</p></li>
											</ul>
					                            <div class="filebox">
													<input class="upload-name" disabled="disabled" placeholder="선택된 파일 없음"><!-- 공백
													--><label for="form_file" class="gray_btn" id="choiceFile">파일선택</label>
													<input name="form_file" type="file" id="form_file" title="파일선택" class="upload-hidden upload-hidden01" <c:if test="${not empty dataMap.FILE_SEQ }" >disabled="disabled"</c:if> />
	                                        	</div>
	                                        	<c:if test="${not empty dataMap.FILE_SEQ }" >
						                            <div id="atch_file_view" class="filebox">
							                            <a href="#none" onclick="delAttFile('${dataMap.FILE_SEQ}')"><img src="<c:url value="/images/ucm/icon_del.png" />" /> </a>
														<a href="#none" onclick="downAttFile('${dataMap.FILE_SEQ}')">${dataMap.FILE_NM} </a>[${dataMap.FILE_SIZE }]
													<div>
												</c:if>
												
												<%-- <div class="filebox">
													<input class="upload-name" disabled="disabled" placeholder="선택된 파일 없음"><!-- 공백
													--><label for="ex_filename" class="gray_btn">파일선택</label>
													<input type="file" id="form_file" name="form_file" class="upload-hidden upload-hidden01" <c:if test="${not empty dataMap.FILE_SEQ }" >disabled="disabled"</c:if> />
												</div> --%>
												
												
												
		                                        <%-- <div class="btn_inner ml10" style="margin-top:-5px;">
		                                        	<label>양식등록</label>
		                                        	<input name="form_file" type="file" id="form_file" style="width:500px;" title="파일선택" <c:if test="${not empty dataMap.FILE_SEQ }" >disabled="disabled"</c:if> />
		                                        	
						                            <c:if test="${not empty dataMap.FILE_SEQ }" >
						                            <div id="atch_file_view">
							                            <a href="#none" onclick="delAttFile('${dataMap.FILE_SEQ}')"><img src="<c:url value="/images/ucm/icon_del.png" />" /> </a>
														<a href="#none" onclick="downAttFile('${dataMap.FILE_SEQ}')">${dataMap.FILE_NM} </a>[${dataMap.FILE_SIZE }]
													<div>
													</c:if>
		                                        </div> --%>
	                                    </td>
	                                </tr>
	                            </tbody>
	                        </table>
	                    </div>
	                    <!-- 리스트// -->
	                    <!--//페이지버튼-->
	                    <div class="btn_bl">
	                    	<a href="#none" id="btn_submit"><span>확인</span></a>
	                    	<a class="wht" href="#none" id="btn_cancel"><span>취소</span></a>
	                    </div>
	                    <!--페이지버튼//-->
	                </div>
	            </div>
	            <!--sub contents //-->
	        </div>
	        <!-- 우측영역//-->
		</div>
    </div>
</div>
<!--content//-->
</form>

</body>
</html>