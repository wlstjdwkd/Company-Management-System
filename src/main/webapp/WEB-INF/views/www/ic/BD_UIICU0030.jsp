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
<title>확인서진본확인|기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery, colorbox, jqGrid, notice, css,mask,  validate, msgBox" />
<ap:jsTag type="tech" items="cmn, mainn, subb, font, ic, msg, util" />
<script type="text/javascript">
	$(document).ready(function() {
		
		// MASK
		// 문서확인번호 확인
		$('#ad_documentNo_1').mask('0000');
		$('#ad_documentNo_2').mask('0000');
		$('#ad_documentNo_3').mask('0000');
		$('#ad_documentNo_4').mask('0000');
		
		// 위변조문서 신고
		$("#btn_doc_report").click(function(){
			$.colorbox({
		        title : "위변조문서신고",
		        href  : "PGIC0031.do?df_method_nm=index&ad_documentNo_1="+$('#ad_report_documentNo_1').val()+"&ad_documentNo_2="+$('#ad_report_documentNo_2').val()+"&ad_documentNo_3="+$('#ad_report_documentNo_3').val()+"&ad_documentNo_4="+$('#ad_report_documentNo_4').val(),
		        width : "1030px",
		        height: "800px",            
		        overlayClose : false,
		        escKey : false,          
		        iframe : true
		    });
		});
		
	});
	
	/*
	* 검색단어 입력 후 엔터 시 자동 submit
	*/
	function press(event) {
		if (event.keyCode == 13) {
			btn_confirm_ok();
		}
	}
	
	function btn_confirm_ok() {
		$("#err_noData").html("");
		$("#err_noDocument").html("");
		
		if($("#ad_documentNo_1").val()=="" || $("#ad_documentNo_2").val()=="" || $("#ad_documentNo_3").val()=="" || $("#ad_documentNo_4").val()=="" ||
			$("#ad_documentNo_1").val().length < 4 || $("#ad_documentNo_2").val().length < 4 || $("#ad_documentNo_3").val().length < 4 || $("#ad_documentNo_4").val().length < 4) {
			$("#dataTable").remove();
			$("#err_noData").html(Message.msg.confirmInputData);
			$("#div_forge").hide();
			return;
		}
		
		var documentNo = $("#ad_documentNo_1").val() + "-" + $("#ad_documentNo_2").val() + "-" + $("#ad_documentNo_3").val() + "-" + $("#ad_documentNo_4").val();
		$("#ad_documentNo").val(documentNo);
		
		$.ajax({
	        url      : "PGIC0030.do",
	        type     : "POST",
	        dataType : "json",
	        data     : { df_method_nm		: "checkDocumnet"
	        			,"ad_documentNo"	: $('#ad_documentNo').val()
	        		   },                
	        async    : false,                
	        success  : function(response) {
	        	try {
	                if(response.result) {
	                	$("#dataTable").remove();
	                	// 문서확인
	                	$("#divTable").append(
	                			'<table id="dataTable" class="st_bl01 stb_gr01">' +
	    							'<caption>기본게시판 목록</caption>'+
	    								'<colgroup>'+
			    							'<col width="212px" />' +
			    							'<col width="177px" />' +
			    							'<col width="128px" />' +
			    							'<col width="139px" />' +
			    							'<col width="234px" />' +
	    								'</colgroup>' +
			    						'<thead>'+
			    							'<tr>'+
			    								'<th scope="col">기업명</th>'+
			    								'<th scope="col">법인번호</th>'+
			    								'<th scope="col">발급번호</th>'+
			    								'<th scope="col">발급일자</th>'+
			    								'<th scope="col">유효기간</th>'+
			    							'</tr>'+
			    						'</thead>'+
			    						'<tbody>'+
			    							'<tr>'+
			    								'<td class="txt_l" id="ad_entprsNm"></td>'+
			    								'<td id="ad_jurirno"></td>'+
			    								'<td id="ad_issuNo"></td>'+
			    								'<td id="ad_issuDe"></td>'+
			    								'<td id="ad_validDe"></td>'+
			    							'</tr>'+
			    						'</tbody>'+
	    						'</table>');
	                	
	                	$("#ad_entprsNm").text(response.value.issuInfo.entprsNm);
	                	$("#ad_jurirno").text(response.value.issuInfo.jurirno.substring(0, 6) + "-" + response.value.issuInfo.jurirno.substring(6, 13));
	                	$("#ad_issuNo").text(response.value.issuInfo.issuNo);
	                	$("#ad_issuDe").text(response.value.issuDe.first + "-" + response.value.issuDe.middle + "-" +response.value.issuDe.last);
	                	$("#ad_validDe").text(response.value.validBeginDe.first + "-" + response.value.validBeginDe.middle + "-" + response.value.validBeginDe.last + " ~ " + response.value.validEndDe.first + "-" + response.value.validEndDe.middle + "-" + response.value.validEndDe.last);
	                	$("#div_forge").hide();
	                } else {                        	 
						if(response.value.reason == 'noDocument') {
	                		// 문서정보 에러
	                		$("#ad_report_documentNo_1").val($('#ad_documentNo_1').val());
	                		$("#ad_report_documentNo_2").val($('#ad_documentNo_2').val());
	                		$("#ad_report_documentNo_3").val($('#ad_documentNo_3').val());
	                		$("#ad_report_documentNo_4").val($('#ad_documentNo_4').val());
	                		$("#ad_documentNo_1").val("");
	                		$("#ad_documentNo_2").val("");
	                		$("#ad_documentNo_3").val("");
	                		$("#ad_documentNo_4").val("");
	                		$("#dataTable").remove();
	                		$("#err_noDocument").html(Message.msg.noConfirmInputData);
	                		$("#div_forge").show();		                		
	                	}
	                	return;
	                }
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
</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		
		<input type="hidden" name="ad_documentNo" id="ad_documentNo" />
		<input type="hidden" name="ad_report_documentNo_1" id="ad_report_documentNo_1" />
		<input type="hidden" name="ad_report_documentNo_2" id="ad_report_documentNo_2" />
		<input type="hidden" name="ad_report_documentNo_3" id="ad_report_documentNo_3" />
		<input type="hidden" name="ad_report_documentNo_4" id="ad_report_documentNo_4" />
		<!--//content-->
		<div id="wrap">
			<div class="s_cont" id="s_cont">
		<div class="s_tit s_tit02">
			<h1>기업확인</h1>
		</div>
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit tit2">기업확인</h2>
				<ul>
				</ul>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}" />
				</div>
				<div class="r_cont s_cont02_08">
					<div class="list_bl">
						<h4 class="fram_bl">확인서 진위확인</h4>
						<div class="terms_wrap" style="border-bottom: 0;">
							<div>
								<div class="img_text">
									<img src="/images2/sub/check/check_confirm_img01.png" style="margin-bottom: 20px; margin-left: -2px; margin-top: -8px;">
									<h3>발급된 기업확인서의 진위여부를 확인하실 수 있습니다.</h3>
									<p class="list_noraml" style="display: inline-block;">문서확인번호
									<input name="ad_documentNo_1" type="text" id="ad_documentNo_1" title="문서확인번호" placeholder="" onfocus="this.placeholder=''; return true"  />
									 - <input name="ad_documentNo_2" type="text" id="ad_documentNo_2" title="문서확인번호" placeholder="" onfocus="this.placeholder=''; return true"  />
									 - <input name="ad_documentNo_3" type="text" id="ad_documentNo_3" title="문서확인번호" placeholder="" onfocus="this.placeholder=''; return true"  />
									 - <input name="ad_documentNo_4" type="text" id="ad_documentNo_4" title="문서확인번호" placeholder="" onfocus="this.placeholder=''; return true" onkeypress="press(event);"/>
									 </p>
									 <div class="dot_line"></div>
									<div class="summary">
										<p id="err_noData"></p>
									</div>
								</div>
							</div>
						</div>
						<div class="btn_bl">
							<a href="#none" onclick="btn_confirm_ok()">확인</a>
						</div>
						<div class="table_list" id="divTable">
										
						</div>
						<div id="div_forge" style="display:none;">
							<p class="noneData" id="err_noDocument"></p>
							<div class="reportSec">
								<p>기업확인서의 진위여부를 확인 할 수 없는 경우 ‘위변조문서 신고’를 부탁 드립니다.<br/>
								진위여부 확인을 통해 기업 정보관리 및 더 나은 서비스를 위해 노력하겠습니다.</p>
								<a href="#none" id="btn_doc_report">위변조문서 신고<img src="/images2/common/btn_arr.png"></a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
		</div>
		<!--content//-->
	</form>
</body>
</html>