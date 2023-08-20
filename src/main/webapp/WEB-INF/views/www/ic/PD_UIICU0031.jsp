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
<title>발급문서진위확인|기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery, colorbox, jqGrid, notice, css,mask,  validate, msgBox" />
<ap:jsTag type="tech" items="font,cmn,mainn,subb, ic, msg, util" />
<script type="text/javascript">
$(document).ready(function() {

		// MASK
		// 휴대전화
		$('#ad_phon_middle').mask('0000');
		$('#ad_phon_last').mask('0000');
		// 문서확인번호
		$('#ad_documentno_1').mask('0000');
		$('#ad_documentno_2').mask('0000');
		$('#ad_documentno_3').mask('0000');
		$('#ad_documentno_4').mask('0000');
		
		
		// 유효성 검사
		$("#dataForm").validate({
			rules : { // 신고자명
				ad_aplcntNm : {
					required : true,
					maxlength : 50
				},// 연락처 가운데
				ad_phon_middle : {
					required : true
				},// 연락처 마지막
				ad_phon_last : {
					required : true
				},// 문서확인번호01
				ad_documentno_1	: {
					required : true
				},// 문서확인번호02
				ad_documentno_2	: {
					required : true
				},// 문서확인번호03
				ad_documentno_3	: {
					required : true
				},// 문서확인번호04
				ad_documentno_4	: {
					required : true
				},// 이메일
				ad_email: {
    				required: true,
    				email: true,
    				maxlength: 100
				},// 습득경위
				ad_acqsCrcmstncs : {
					required: true,
					maxlength: 250
				},
			},
			submitHandler: function(form) {	
				
				// 연락처
				$("#ad_mbtlNum").val($("#ad_phon_first").val() + $("#ad_phon_middle").val() +$("#ad_phon_last").val());
				
				// 문서확인번호
				$("#ad_docCrfirmNo").val($("#ad_documentno_1").val() + "-" + $("#ad_documentno_2").val() + "-" + $("#ad_documentno_3").val() + "-" + $("#ad_documentno_4").val());

				$.ajax({
			        url      : "PGIC0031.do",
			        type     : "POST",
			        dataType : "json",
			        data     : { df_method_nm		 : "insertDocReport" 
			        			,"ad_aplcntNm" 		 : $('#ad_aplcntNm').val()
			        			,"ad_mbtlNum" 		 : $('#ad_mbtlNum').val()
			        			,"ad_docCrfirmNo"	 : $('#ad_docCrfirmNo').val()
			        			,"ad_email"			 : $('#ad_email').val()
			        			,"ad_acqsCrcmstncs"	 : $('#ad_acqsCrcmstncs').val()
			        		   },                
			        async    : false,                
			        success  : function(response) {
			        	try {
			        		
			        		if(response.result) {
			        			alert("작성하신 내용이 성공적으로 접수되었습니다.\n이용해 주셔서 감사합니다.");
			        			parent.$.colorbox.close();
			        			//jsMsgBox(null, 'info', '작성하신 내용이 성공적으로 <br>접수되었습니다.<br> 이용해 주셔서 감사합니다.', function(){parent.$.colorbox.close();});
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
		});
		
		// 취소
		$("#btn_cancel").click(function() {
			parent.$.colorbox.close();
		});
		
		// 확인
		$("#btn_insert").click(function() {
			$("#dataForm").submit();
		});

	});
</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		
		<!-- LNB 출력 방지 -->
		<input type="hidden" id="no_lnb" value="true" />
		
		<input type="hidden" id="ad_mbtlNum" name="ad_mbtlNum" />
		<input type="hidden" id="ad_docCrfirmNo" name="ad_docCrfirmNo" />
		<div id="lookup01" class="modal">
		<div class="modal_wrap">
				 <div class="modal_cont" style="width:95%;padding-bottom:0px;">
					<table class="table_form">
						<caption>위변조문서신고 게시판</caption>
						<colgroup>
							<col width="172px">
							<col width="*">
						</colgroup>
						<tbody>
							<tr class="table_input" style="border-top:0;">
								<td style="border-top:0;" colspan="2"><p class="ess_txt">궁금하신 점은 언제든 문의 바랍니다. 신속히 안내해 드릴 수 있도록 노력하겠습니다.
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<img src="/images2/sub/table_check.png">항목은 입력 필수 항목입니다.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p></td>
							</tr>
							<tr>
								<th><img src="/images2/sub/table_check.png">신고자이름</th>
								<td><input name="ad_aplcntNm" type="text" id="ad_aplcntNm" style="width: 80%;" title="신고자이름" /></td>
							</tr>
							<tr>
								<th><img src="/images2/sub/table_check.png">연락처</th>
								<td>
									<select id="ad_phon_first" class="select_box" name="ad_phon_first" style="width: 101px;">
											<c:forTokens items="${MOBILE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
												<option value="${firstNum }">${firstNum }</option>
											</c:forTokens>
									</select> ~ <input name="ad_phon_middle" type="text" id="ad_phon_middle" style="width: 130px;" title="전화번호중간번호" /> ~ <input name="ad_phon_last" type="text" id="ad_phon_last" style="width: 130px;" title="전화번호마지막번호" />
								</td>
							</tr>
							<tr>
								<th><img src="/images2/sub/table_check.png">이메일</th>
								<td>
									<input name="ad_email" type="text" id="ad_email" style="width: 80%;" title="이메일입력란" />
								</td>
							</tr>
							<tr>
								<th><img src="/images2/sub/table_check.png">문서확인번호</th>
								<td>
									<input name="ad_documentno_1" type="text" id="ad_documentno_1" style="width: 20%;"	title="문서확인번호" value="${param.ad_documentNo_1}" /> - 
									<input name="ad_documentno_2" type="text" id="ad_documentno_2" style="width: 20%;" title="문서확인번호" value="${param.ad_documentNo_2}" /> - 
									<input name="ad_documentno_3" type="text" id="ad_documentno_3" style="width: 20%;" title="문서확인번호" value="${param.ad_documentNo_3}" /> - 
									<input name="ad_documentno_4" type="text" id="ad_documentno_4" style="width: 20%;" title="문서확인번호" value="${param.ad_documentNo_4}" />
								</td>
							</tr>
							<tr>
								<th><img src="/images2/sub/table_check.png">습득경위</th>
								<td><textarea name="ad_acqsCrcmstncs" id="ad_acqsCrcmstncs" cols="85" rows="10" title="습득경위내용입력란" style="width: 80%;height:200px;"></textarea></td>
							</tr>
						</tbody>
					</table>
				 </div>
				 <div class="btn_bl">
					<a href="#none" id="btn_insert">저장</a>
					<a href="#none" id="btn_cancel" class="wht">취소</a>
				</div>
			</div>
		</div>
	</form>
</body>
</html>