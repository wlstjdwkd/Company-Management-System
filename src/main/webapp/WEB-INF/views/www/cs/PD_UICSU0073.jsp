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
<%-- <ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox,multifile" />
<ap:jsTag type="tech" items="msg,util,ucm,cs" /> --%>

<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox,multifile" />
<ap:jsTag type="tech" items="msg,util, cmn , mainn, subb, font , paginate" />
<script type="text/javascript">

// 학력사항 분류
var acdmcrJson = ${chdAcmCodeJson};

$(document).ready(function(){
	<c:if test="${applyMap.MTRSC_DIV != '1'}">
	$("#ad_mscl").attr("disabled", "disabled");
	$("#ad_clss").attr("disabled", "disabled");
	</c:if>
	
	// MASK
	$("#ad_career").mask('000');
	$("#ad_hope_anslry").mask('000000');
	
	$("#ad_zip").mask('000000');
	$("#telno_middle").mask('0000');
	$("#telno_last").mask('0000');
	$("#mbtlnum_middle").mask('0000');
	$("#mbtlnum_last").mask('0000');
	$("#brthdy_year").mask('0000');
	$("#brthdy_month").mask('00');
	$("#brthdy_day").mask('00');
	
	$("#ad_enst_ym_year").mask('0000');
	$("#ad_enst_ym_month").mask('00');
	$("#ad_dmblz_ym_year").mask('0000');
	$("#ad_dmblz_ym_month").mask('00');
	
	$("input[id^='entsch_de_year_']").mask('0000');
	$("input[id^='entsch_de_month_']").mask('00');
	$("input[id^='grdtn_de_year_']").mask('0000');
	$("input[id^='grdtn_de_month_']").mask('00');
	
	// 학력사항 분류
	$("select[id^='ad_acdmcr_prt_code']").change(function(){
		var index = $("select[id^='ad_acdmcr_prt_code']").index(this);
		var prtVal = $(this).val();
		var childVal = "";
		var childNm = "";
		var selectTarget = $("select[id^='ad_acdmcr_code']").eq(index);
		var textTarget1 = $("input:text[id^='ad_major1_']").eq(index);
		var textTarget2 = $("input:text[id^='ad_major2_']").eq(index);
		var textTarget3 = $("input:text[id^='ad_scre_']").eq(index);
		var textTarget4 = $("input:text[id^='ad_pscore_']").eq(index);
		var html = "";
		
		if(prtVal == "") {
			html = "<option value=''>-- 선택 --</option>";
		}else {
			for(var i=0; i<acdmcrJson.length; i++) {
				childVal = acdmcrJson[i]["code"];
				childNm = acdmcrJson[i]["codeNm"];
				
				if(childVal.indexOf(prtVal) == 0){
					html += "<option value='"+ childVal +"'>";
					html += childNm + "</option>";
				}
			}	
		}
		
		if(prtVal == "U" || prtVal == "G") {
			textTarget1.attr("disabled", false);
			textTarget2.attr("disabled", false);
			textTarget3.attr("disabled", false);
			textTarget4.attr("disabled", false);
		}else {
			textTarget1.attr("disabled", true);
			textTarget2.attr("disabled", true);
			textTarget3.attr("disabled", true);
			textTarget4.attr("disabled", true);
		}
		
		selectTarget.html(html);
	});
	
	// 경력구분 radio
	$("input:radio[name='ad_career_div']").change(function(){			
		if($(this).val() == 'CK1'){
			$("#ad_career").attr("disabled", false);
		}else{
			$("#ad_career").attr("disabled", true).val("");
		}
	});
	
	// 희망연봉 radio
	$("input:radio[name='ad_anslry_div']").change(function(){			
		if($(this).val() == '2'){
			$("#ad_hope_anslry").attr("disabled", false);
		}else{
			$("#ad_hope_anslry").attr("disabled", true).val("");
		}
	});
	
	// 병역사항 radio
	$("input:radio[name='ad_mtrsc_div']").change(function(){
		var disableStatus = false;
		
		if($(this).val() == "1") {
			disableStatus = false;
		}else{
			disableStatus = true;
		}
		
		$("#ad_enst_ym_year").attr("disabled", disableStatus);
		$("#ad_enst_ym_month").attr("disabled", disableStatus);
		$("#ad_dmblz_ym_year").attr("disabled", disableStatus);
		$("#ad_dmblz_ym_month").attr("disabled", disableStatus);
		$("#ad_mscl").attr("disabled", disableStatus);
		$("#ad_clss").attr("disabled", disableStatus);
	});
	
	// 장애여부 radio
	$("input:radio[name='ad_trobl_at']").change(function(){
		if($(this).val() == "Y"){			
			$("#ad_trobl_grad").attr("disabled", false);
		}else {
			$("#ad_trobl_grad").val("");
			$("#ad_trobl_grad").attr("disabled", true);
		}
	});
	
	// 달력 컴포넌트 init && Mask
	$(".picker").datepicker({
        showOn : 'button',
        defaultDate : null,
        buttonImage : '<c:url value="images2/sub/date_ico_btn.png" />',
        buttonImageOnly : true,
        changeYear: true,
        changeMonth: true,
        yearRange: "1920:+1"
    }).mask('0000-00-00');		
	
	// 유효성 검사
	$("#dataForm").validate({  
		rules : {//이메일
				ad_email: {
					required: true,
					email: true
				}/* ,//군별
				ad_mscl: {
					required: true
				},//계급
				ad_clss: {
					required: true
				}, */				
			},
		submitHandler: function(form) {
			
			// 달력 valid
			/* $(".picker").click(function() {
		    	if($("#cal_start_dt").val() > $("#cal_end_dt").val() || $("#cal_start_dt").val().replace(/-/gi,"") > $("#cal_end_dt").val().replace(/-/gi,"")){
		    		jsMsgBox(Message.msg.invalidDateCondition);		    		
		            $(this).focus();
		            return false;
		        }
		    });	 */		
			
			$("#dataForm").ajaxSubmit({
				url      : "PGCS0070.do",
				type     : "post",
				dataType : "text",
				async    : false,
				success  : function(response) {
					try {						
						if(eval(response)) {							
							jsMsgBox(null, "info", Message.msg.insertOk, function(){
								if($("#ad_rcept_at").val() == "Y") {									
									location.href = '<c:url value="/PGCS0070.do?df_method_nm=successApplyRcept" />';									
								}	
							});
														
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
	
	// 임시저장 버튼
	$("#btn_save").click(function() {
		
		jsMsgBox(null, "confirm", Message.msg.confirmSaveTemp, function() {
			if(!$('#dataForm').valid()){
				jsMsgBox(null,'info',Message.msg.checkEssVal);
				return;
			}else{
				fn_set_param();
				$("#ad_rcept_at").val("N");
				$("#df_method_nm").val("processApplyCmpny");
				$("#dataForm").submit();	
			}	
		});				
	});
	
	// 신청 버튼
	$("#btn_rcept").click(function() {
		
		jsMsgBox(null, "confirm", Message.msg.confirmSave, function() {
			if(!$('#dataForm').valid()){
				jsMsgBox(null,'info',Message.msg.checkEssVal);
				return;
			}else{
				fn_set_param();
				$("#ad_rcept_at").val("Y");
				$("#df_method_nm").val("processApplyCmpny");
				$("#dataForm").submit();	
			}	
		});				
	});
	
	// 취소 버튼
	$("#btn_cancel").click(function(){
		self.close();
	});
	
	// 우편번호 검색 팝업
	$('#btn_search_zip').click(function() {
    	var pop = window.open("<c:url value='${SEARCH_ZIP_URL}' />","searchZip","width=570,height=420, scrollbars=yes, resizable=yes");		
    });
	
	// mutifile-upload (포트폴리오)
    $("#hist_file").MultiFile({
		accept: 'hwp|doc|docx|pdf|jpg|jpge|zip',
		max: '1',		
		STRING: {			
			remove: '<img src="<c:url value="/images/ucm/icon_del.png" />" alt="x" />',
			denied: Message.msg.fildUploadDenied,  		//확장자 제한 문구
			duplicate: Message.msg.fildUploadDuplicate	//중복 파일 문구
		}
	});
	
 	// mutifile-upload (사진)
    $("#photo_file").MultiFile({
		accept: 'jpg|jpge|gif',
		max: '1',
		list: '#photo_file_view',
		STRING: {			
			remove: '<img src="<c:url value="/images/ucm/icon_del.png" />" alt="x" />',
			denied: Message.msg.fildUploadDenied,  		//확장자 제한 문구
			duplicate: Message.msg.fildUploadDuplicate	//중복 파일 문구
		},
		afterFileSelect: function(element, value, master_element){
			/* if($("#photo_file_view")) {
				$("#photo_file_view").remove();
			} */
			
			var $fileList = $("#photo_file_view").find(".MultiFile-label");
			var $remove_btn;
			for(var i=0; i<$fileList.length-1; i++) {
				$remove_btn = $fileList.eq(i).find(".MultiFile-remove");
				
				if($remove_btn.length > 0) {					
					$fileList.eq(i).find(".MultiFile-remove").click();	
				}else{					
					$fileList.eq(i).remove();
				}				
			}
			
			$("#df_method_nm").val("processApplyAtchPhoto");
			
			$("#dataForm").ajaxSubmit({
				url      : "PGCS0070.do",
				type     : "post",
				dataType : "text",
				async    : false,
				contentType: "multipart/form-data",
				success  : function(response) {
					try {						
						if(response) {
							var srcStr = "/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=" + response + "&number=" + Math.random();
							$("#img_photo").attr("src", srcStr);
							/* var $remove_btn = $("#photo_file_view").find(".MultiFile-remove");
							$remove_btn.click(function(){
								delAttFile(response, "photo");
							}); */
						} else {							
							$(".MultiFile-list").remove();	// file list 삭제
							jsMsgBox(null, "error", Message.msg.processFail);
						}
					} catch (e) {
						jsSysErrorBox(response, e);
						return;
					}                            
				}
			});
			
		}
	});
 	
 	// 입사지원서 불러오기
 	$("#btn_load").click(function(){
 		$.colorbox({
 			title : "입사지원서 불러오기",
 			href : "<c:url value='/PGCS0070.do?df_method_nm=myApplyList' />",
 			width : "800",
 			height : "650",
 			overlayClose : false,
 			escKey : false,
 			iframe : true
 		});
 	});
	
}); // ready

// 파라미터 세팅
var fn_set_param = function(){	
	var year = "";
	var month = "";
	var day = "";
	
	// 생년월일
	year = $("#brthdy_year").val();
	month = $("#brthdy_month").val();
	day = $("#brthdy_day").val();	
	if(month && month.length == 1) {
		month = "0" + month;
	}
	if(day && day.length == 1) {
		day = "0" + day;
	}	
	var brthdy = "" + year + month + day;
	$("#ad_brthdy").val(brthdy);
	
	// 전화번호
	var telnum = "" + $("#telno_first").val() + $("#telno_middle").val() + $("#telno_last").val();
	$("#ad_telno").val(telnum);
	
	// 휴대전화번호
	var mbtlnum = "" + $("#mbtlnum_first").val() + $("#mbtlnum_middle").val() + $("#mbtlnum_last").val();
	$("#ad_mbtlnum").val(mbtlnum);
	
	// 입대년월
	month = $("#ad_enst_ym_month").val();
	if(month && month.length == 1) {
		month = "0" + month;
	}
	var enst_ym = $("#ad_enst_ym_year").val() + month;
	$("#ad_enst_ym").val(enst_ym);
	
	// 제대년월
	month = $("#ad_dmblz_ym_month").val();
	if(month && month.length == 1) {
		month = "0" + month;
	}
	var dmblz_ym = $("#ad_dmblz_ym_year").val() + month;
	$("#ad_dmblz_ym").val(dmblz_ym);
	
	// 재학기간
	var entsch_de_year;
	var entsch_de_month;
	var grdtn_de_year;
	var grdtn_de_month
	for(var i=1; i<=5; i++) {
		entsch_de_year = $("#entsch_de_year_" + i).val();
		entsch_de_month = $("#entsch_de_month_" + i).val();
		grdtn_de_year = $("#grdtn_de_year_" + i).val();
		grdtn_de_month = $("#grdtn_de_month_" + i).val();
		
		if(entsch_de_month && entsch_de_month.length == 1){
			entsch_de_month = "0" + entsch_de_month;
		}
		if(grdtn_de_month && grdtn_de_month.length == 1){
			grdtn_de_month = "0" + grdtn_de_month;
		}
		
		$("#ad_entsch_de_" + i).val( "" + entsch_de_year + entsch_de_month );
		$("#ad_grdtn_de_" + i).val( "" + grdtn_de_year + grdtn_de_month );
	}
	
};

//첨부파일 다운로드
function downAttFile(fileSeq){
	jsFiledownload("/PGCM0040.do","df_method_nm=updateFileDownBySeq&seq="+fileSeq);
}

//첨부파일 삭제
function delAttFile(fileSeq, fileType){	
	
	jsMsgBox(null, "confirm", Message.msg.fileDeleteConfirm, function() {
		
		$.ajax({        
	        url      : "PGCS0070.do",
	        type     : "POST",
	        dataType : "json",
	        data     : {
	        			df_method_nm:"deleteAttFile"
	        			, file_seq:fileSeq
	        			, file_type:fileType
	        			, empmn_manage_no:$("#ad_empmn_manage_no").val()        			
	        },                
	        async    : false,                
	        success  : function(response) {        	
	        	try {
	        		if(response.result) {
	        			
	        			if(fileType == "photo") {
	        				$("#img_photo").attr("src", '<c:url value="/images/cs/photo.png" />');
	        			}
	        			
	        			$("#" + fileType + "_file").attr("disabled",false);
	        			$("#" + fileType + "_file_view").empty();
	        			jsMsgBox(null,'info',Message.msg.successDelete);
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

function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){	
	<%--
	roadFullAddr : 도로명주소 전체(포멧)
	roadAddrPart1: 도로명주소           
	addrDetail   : 고객입력 상세주소    
	roadAddrPart2: 참고주소             
	engAddr      : 영문 도로명주소      
	jibunAddr    : 지번 주소            
	zipNo        : 우편번호             
	admCd        : 행정구역코드         
	rnMgtSn      : 도로명코드           
	bdMgtSn      : 건물관리번호
	
	var zipArr = Util.str.split(zipNo,'-');	
	$("#ad_zip").val(zipArr[0] + zipArr[1]);
	$("#ad_adres").val(roadAddrPart1 + " " + addrDetail);
	--%>
	
	var zipArr = zipNo.replace("-", "");	// 혹시 모를 '-'처리
	$('#ad_zip').val(zipArr);		// 우편번호 자리에 그냥 넣어준다.
	$("#ad_adres").val(roadAddrPart1 + " " + addrDetail);
}

</script>

</head>
<body class="popup">

<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" enctype="multipart/form-data" method="post">

<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/pagingParam.jsp" />

<input type="hidden" id="ad_empmn_manage_no" name="ad_empmn_manage_no" value="${param.ad_empmn_manage_no }" />
<input type="hidden" id="ad_virtl_empmn_manage_no" name="ad_virtl_empmn_manage_no" />
<input type="hidden" id="ad_rcept_at" name="ad_rcept_at" />
<input type="hidden" id="ad_brthdy" name="ad_brthdy" />
<input type="hidden" id="ad_telno" name="ad_telno" />
<input type="hidden" id="ad_mbtlnum" name="ad_mbtlnum" />
<input type="hidden" id="ad_enst_ym" name="ad_enst_ym" />
<input type="hidden" id="ad_dmblz_ym" name="ad_dmblz_ym" />

<c:forEach begin="1" end="5" step="1" varStatus="status">
<input type="hidden" id="ad_entsch_de_${status.index }" name="ad_entsch_de_${status.index }" />
<input type="hidden" id="ad_grdtn_de_${status.index }" name="ad_grdtn_de_${status.index }" />
</c:forEach>

<!--팝업영역 시작-->
<div id="vol01" class="modal">
<!-- <div id="wrapper_popup"> -->
    <!--header_popup 시작-->
    <div class="modal_wrap">
    <div id="modal_header">
        <h2>입사지원서</h2>
        <div class="pop_close"><a href="#"><img src="<c:url value="/images2/sub/modal_closeBtn.png" />" alt="닫기버튼" /></a></div>
    </div>
    <!--container_popup 시작-->
    <div class="modal_cont">
				<div class="list_bl">
					<h4 class="fram_bl" style="margin-bottom: 6px;">기본사항<p><img src="/images2/sub/table_check.png">항목은 입력 필수 항목입니다.&nbsp;&nbsp;<a href="#" id="btn_load" class="form_blBtn">입사지원서 불러오기</a></p></h4>
					<table class="table_form" style="margin-bottom: 20px">
						<caption>기업정보</caption>
						<colgroup>
							<col width="172px">
							<col width="367px">
							<col width="173px">
							<col width="367px">
						</colgroup>
						<tbody>
							<tr class="table_input">
								<th><img src="/images2/sub/table_check.png">지원제목</th>
								<td class="b_l_0" colspan="3"><input name="ad_apply_realm" type="text" id="ad_apply_realm" style="width:398px; margin-top:5px;" value="${applyMap.APPLY_REALM }" placeholder="지원분야(직종)을 입력해주세요." required maxlength="30" style="width: 507px;"></td>
							</tr>
							<tr class="table_input">
								<th><img src="/images2/sub/table_check.png">지원분야(직종)</th>
								<td class="b_l_0" colspan="3"><input type="text" placeholder="지원분야(직종)을 입력해 주세요." style="width: 507px;"></td>
							</tr>
							<tr class="table_input">
								<th><img src="/images2/sub/table_check.png">경력구분</th>
								<td class="b_l_0">
									<input name="ad_career_div" type="radio" id="ad_career_div_1" value="CK0" <c:if test="${applyMap.CAREER_DIV == 'CK0' }">checked</c:if> required />
                          					 <label for="ad_career_div_1">신입</label>
                           					 <input name="ad_career_div" type="radio" id="ad_career_div_2" title="경력" class="ml40" value="CK1" <c:if test="${applyMap.CAREER_DIV == 'CK1' }">checked</c:if> required />
                           					 <label for="ad_career">경력
                                <input name="ad_career" type="text" <c:if test="${applyMap.CAREER_DIV != 'CK1' }">disabled="disabled" </c:if> class="text" id="ad_career" value="${applyMap.CAREER }" style="width:30px;" title="경력해당년" required />
                            	년
                            </label>
								</td>
								<th><img src="/images2/sub/table_check.png">희망연봉</th>
								<td class="b_l_0">
									<input name="ad_anslry_div" type="radio" id="ad_anslry_div_1" value="1" <c:if test="${applyMap.ANSLRY_DIV == '1' }">checked</c:if> required />
                            		<label for="ad_anslry_div_1">회사내규에따름</label>
                           			<input name="ad_anslry_div" type="radio" id="ad_anslry_div_2" title="연봉" class="ml40" value="2" <c:if test="${applyMap.ANSLRY_DIV == '2' }">checked</c:if> required />
                           			<label for="ad_hope_anslry">연봉
                                <input name="ad_hope_anslry" type="text" <c:if test="${applyMap.ANSLRY_DIV != '2' }">disabled="disabled"</c:if> class="text" id="ad_hope_anslry" value="${applyMap.HOPE_ANSLRY }" style="width:40px;" title="연봉액" required />
                                만원
                           	</label>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="list_bl">
					<h4 class="fram_bl">인적사항</h4>
					<table class="table_form">
						<caption>인적사항</caption>
						<colgroup>
							<col width="240px">
							<col width="144px">
							<col width="274px">
							<col width="144px">
							<col width="274px">
						</colgroup>
						<tbody>
							<tr class="table_input">
								<!-- <td rowspan="8" class="t_center">
									<img src="/images2/sub/support/photo_ex.png">
									<div class="filebox" style="margin-top: 14px;">
										<input class="upload-name" disabled="disabled" placeholder="선택된 파일 없음" style="width: 129px">공백
										<label for="ex_filename" class="gray_btn" style="margin-left: -1px; padding-bottom: 10px;">파일선택</label>
										<input type="file" id="ex_filename" class="upload-hidden upload-hidden01">
									</div>
								</td> -->
								<td class="none" rowspan="5">
                        	<ul style="width:100%">
                                <li class="tac mb10">
                                	<c:choose>
                                	<c:when test="${not empty applyMap.PHOTO_FILE_SN and LOAD_DATA_AT != 'Y'}">
                                		<img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${applyMap.PHOTO_FILE_SN}" />" alt="로고" id="img_photo" width="120" height="150" style="border:#666 solid 1px" />
                                	</c:when>
                                	<c:otherwise><img src="<c:url value="/images2/sub/support/photo_ex.png" />" alt="로고" id="img_photo" width="120" height="150" style="border:#666 solid 1px" /></c:otherwise>
                                	</c:choose>                                	
                               	</li>
                                <li class="tac">
                                    <div class="btn_inner">                                    	
                                    	<input type="file" name="photo_file" id="photo_file" title="사진파일선택" style="width: 90px" />
                                    	<div id="photo_file_view" >
                                    	<c:if test="${not empty applyMap.PHOTO_FILE_SN and LOAD_DATA_AT != 'Y' }" >                                    	
                                    		<div class="MultiFile-label">
		                                    	<a href="#none" onclick="delAttFile('${applyMap.PHOTO_FILE_SN}', 'photo')"><img src="<c:url value='/images/ucm/icon_del.png' />" alt="삭제하기" /></a>
												<a href="#none" onclick="downAttFile('${applyMap.PHOTO_FILE_SN}')">${applyMap.PHOTO_FILE_NM} </a>
											</div>										
										</c:if>
										</div>
                                    </div>                                    
                                </li>
                            </ul>
                        </td>
								<th><img src="/images2/sub/table_check.png">이름</th>
								<td class="b_l_0" colspan="3">
									한글&nbsp;&nbsp;&nbsp;&nbsp;<strong class="s_strong">${userNm }</strong></strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									영문&nbsp;&nbsp;<input type="text" style="width: 173px; margin-right: 5px;" value="${applyMap.ENG_NM }"></td>
							</tr>
							<tr class="table_input">
								<th style="border-left: 1px solid #dadada;"><img src="/images2/sub/table_check.png">주소</th>
								<td colspan="3">
                        	<input name="ad_zip" type="text" id="ad_zip" style="width:118px;" value="${applyMap.ZIP }" title="우편번호" required />                            
                            <div class="btn_inner ml10">
                            	<a href="#" class="btn_in_gray" id="btn_search_zip"><span>우편번호 검색</span></a>
                            </div>
                            <br />
                            <input name="ad_adres" type="text" id="ad_adres" value="${applyMap.ADRES }" style="width:98%; margin-top:5px;" title="주소상세" required maxlength="200" /></td>
								
							</tr>
							<tr class="table_input">
								<th style="border-left: 1px solid #dadada;"><img src="/images2/sub/table_check.png">전화번호</th>
								<td class="b_l_0">
                        	<select name="telno_first" id="telno_first" style="width:50px; ">
                        		<c:forTokens items="${PHONE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
									<option value="${firstNum }" <c:if test="${applyMap.TELNO1 == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
								</c:forTokens>                            
                            </select>
                            ~
                            <input name="telno_middle" type="text" id="telno_middle" value="${applyMap.TELNO2 }" class="text" style="width:45px;" title="전화번호중간번호" required />
                            ~
                            <input name="telno_last" type="text" id="telno_last" value="${applyMap.TELNO3 }" class="text" style="width:45px;" title="전화번호마지막번호" required />
								</td>
								<th><img src="/images2/sub/table_check.png">휴대폰</th>
								<td class="b_l_0">
									<select name="mbtlnum_first" id="mbtlnum_first" style="width:50px; ">
                                <c:forTokens items="${MOBILE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
									<option value="${firstNum }" <c:if test="${applyMap.MBTLNUM1 == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
								</c:forTokens>
                            </select>
                            ~
                            <input name="mbtlnum_middle" type="text" id="mbtlnum_middle" value="${applyMap.MBTLNUM2 }" class="text" style="width:45px;" title="휴대전화번호중간번호" required />
                            ~
                            <input name="mbtlnum_last" type="text" id="mbtlnum_last" value="${applyMap.MBTLNUM3 }" class="text" style="width:45px;" title="휴대전화번호마지막번호" required />
								</td>
							</tr>
							<tr class="table_input">
								<th style="border-left: 1px solid #dadada;"><img src="/images2/sub/table_check.png">이메일</th>
								<td class="b_l_0" colspan="3"><input type="text" value="${applyMap.EMAIL }" style="width: 661px;"></td>
							</tr>
							<tr class="table_input">
								<th style="border-left: 1px solid #dadada;"><img src="/images2/sub/table_check.png">생년월일</th>
								<td class="b_l_0" colspan="3">
								<input type="text" style="width: 77px;" value="${applyMap.BRTHDY_YEAR }" >&nbsp;년&nbsp;&nbsp;
								<input type="text"  style="width: 77px;" value="${applyMap.BRTHDY_MONTH }">&nbsp;월&nbsp;&nbsp;
								<input type="text" style="width: 77px;" value="${applyMap.BRTHDY_DAY }">&nbsp;일
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="list_bl">
					<h4 class="fram_bl">경력사항</h4>
					<table class="table_form">
						<caption>경력사항</caption>
						<colgroup>
							<col width="200px">
							<col width="300px">
							<col width="145px">
							<col width="303px">
						</colgroup>
						<thead>
							<tr>
								<th>기업명</th>
								<th>재직기간</th>
								<th>직위</th>
								<th>담당업무</th>
							</tr>
						</thead>
						<tbody>
						
							<tr class="table_input">
								<td class="t_center"><input type="text" style="width: 191px;"></td>
								<td class="table_input t_center date">
									<input type="text" style="width: 88px"name="ad_begin_de_${status.index }" type="text" id="ad_begin_de_${status.index }" value="${CACAREER.BEGIN_DE }" class="text picker" >~
									<input type="text" style="width: 88px" name="ad_end_de_${status.index }" type="text" id="ad_end_de_${status.index }" value="${CACAREER.END_DE }"class="text picker">
								</td>
								<td class="t_center"><input type="text" style="width: 130px;"></td>
								<td class="t_center"><input type="text" style="width: 295px;"></td>
							</tr>
							<tr class="table_input">
								<td class="t_center"><input type="text" style="width: 191px;"></td>
								<td class="table_input t_center date">
									<input type="text" style="width: 88px"name="ad_begin_de_${status.index }" type="text" id="ad_begin_de_${status.index }" value="${CACAREER.BEGIN_DE }" class="text picker" >~
									<input type="text" style="width: 88px" name="ad_end_de_${status.index }" type="text" id="ad_end_de_${status.index }" value="${CACAREER.END_DE }"class="text picker">
								</td>
								<td class="t_center"><input type="text" style="width: 130px;"></td>
								<td class="t_center"><input type="text" style="width: 295px;"></td>
							</tr>
							<tr class="table_input">
								<td class="t_center"><input type="text" style="width: 191px;"></td>
								<td class="table_input t_center date">
									<input type="text" style="width: 88px"name="ad_begin_de_${status.index }" type="text" id="ad_begin_de_${status.index }" value="${CACAREER.BEGIN_DE }" class="text picker" >~
									<input type="text" style="width: 88px" name="ad_end_de_${status.index }" type="text" id="ad_end_de_${status.index }" value="${CACAREER.END_DE }"class="text picker">
								</td>
								<td class="t_center"><input type="text" style="width: 130px;"></td>
								<td class="t_center"><input type="text" style="width: 295px;"></td>
							</tr>
						
						</tbody>
					</table>
				</div>
				<div class="list_bl">
					<h4 class="fram_bl">경력기술서 포트폴리오</h4>
					<table class="table_form m_b_10">
						<caption>경력기술서 포트폴리오</caption>
						<colgroup>
							<col width="240px">
							<col width="*">
						</colgroup>
						<tbody>
							<tr class="table_input">
								<th>첨부</th>
								<td class="b_l_0">
									<div class="filebox">
										<input class="upload-name" disabled="disabled" placeholder="선택된 파일 없음" style="width: 600px;"><!-- 공백
										--><label for="ex_filename01" class="gray_btn">파일선택</label>
										<input type="file" id="ex_filename01" class="upload-hidden upload-hidden01">
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn_bl">
					<a href="#" class="wht">임시저장</a>
					<a href="#" class="blu">저장</a>
					<a href="#">신청</a>
				</div>
			</div>
</div>
</div>

</form>

</body>
</html>