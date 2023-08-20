<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>메일발송설정</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,blockUI" />
<ap:jsTag type="tech" items="acm,msg,util,etc" />

<script type="text/javascript">

	$(document).ready(function(){
		 // form submit validation
		$("#form").validate({
			rules : {
				mailQustnrSj: {
					required: true,
					maxlength: 250
				},
				mailQustnrWritngGuidanceCn: {
					required: true,
					maxlength: 500
				}
			},
			submitHandler: function(form) {
				
				// 이메일 주소 검증
				var txtEmail = $.trim($("#txtEmail").val());
	
				if (txtEmail.length > 0) {
					var arrEmail = txtEmail.split("\n");
					
					for(var i=0; i<arrEmail.length; i++) {
						if (!/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/.test(arrEmail[i])) {
							jsMsgBox($("#txtEmail"), "error", arrEmail[i]+"<spring:message code='errors.email'  arguments=' '/>");
							return;
						}
					}
				}
				
				jsMsgBox(null, 'confirm','<spring:message code="confirm.common.save"/>', function(){
					$("#df_method_nm").val("insertTrgterEmail");
					$.blockUI();
					form.submit();
				});
			}
		});
	});
    
    
	/***
	 * 목록
	 */
	function fn_egov_search_QustnrTrgterEmailPopup(){
		var form = document.form;
	
		form.action = "<c:url value='${svcUrl}' />";
		form.df_curr_page.value = 1;
		form.df_method_nm.value="qustnrTrgterEmailListPopup";
		form.submit();
	}
	
	/***
	 * 확인서발급기업 담당자 불러오기
	 */
	function getCnfirmEnpEmailList() {
		$.ajax({
			url      : "PGSO0020.do",
			type     : "POST",
			dataType : "json",
			data     : { df_method_nm: "selectCnfirmEnpEmailList"},
	        //data     : $('#dataForm').formSerialize(),
			async    : false,                
			success  : function(response) {
				if(response.result) {
					var jsonData = eval(response.value.emailList);
					$("#txtEmail").val(jsonData.join("\n"));
				} else {
					jsMsgBox($("#txtEmail"), "warn", Message.msg.noData);
				}
			}
		});
	}
</script>
</head>
<body>
<body>
<div id="self_dgs">
	<div class="pop_q_con">
		<form name="form" id="form" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />
		<!-- LNB 출력 방지 -->
		<input type="hidden" id="no_lnb" value="true" />
		
		<input type="hidden" id="qestnrId" name="qestnrId" value="${qestnrId}" />
		<input type="hidden" id="qestnrTmplatId" name="qestnrTmplatId" value="${qestnrTmplatId}" />

        <div class="part_2">
            <div class="part_leftzone" style="width:33%">
                <h3 class="middle">기업전체</h3>
                <div class="btn_page_middle"> <a class="btn_page_admin" href="#none" onclick="getCnfirmEnpEmailList();"><span>확인서발급기업 담당자 불러오기 </span></a></div>
                <div>
                    <textarea name="txtEmail" id="txtEmail" title="내용입력란" style="width:98%; height:450px" ></textarea>
                </div>
            </div>
            <div class="part_rightzone" style="width:65%">
                <h3>메일 제목</h3>
                <div>
                    <textarea name="mailQustnrSj" id="mailQustnrSj" rows="8" title="제목입력란" style="width:98%; height:130px" ><c:out value="${resultInfo.qustnrSj}" /></textarea>
                </div>
                <h3 class="mgt30">메일 인사말</h3>
                <div>
                    <textarea name="mailQustnrWritngGuidanceCn" id="mailQustnrWritngGuidanceCn" rows="13" title="인사말입력란" style="width:98%; height:245px" ><c:out value="${resultInfo.guidanceCn}" /></textarea>
                </div>
            </div>
        </div>
        <div class="line_dotted mgt10"></div>
        <div class="btn_page_last">
        	<a class="btn_page_admin" href="#none" onclick="fn_egov_search_QustnrTrgterEmailPopup();"><span>취소</span></a> 
        	<a class="btn_page_admin" href="#none" onclick="$('#form').submit();"><span>확인</span></a> 
        </div>
		</form>
	</div>
</div>
<div style="display:none">
	<div class="loading" id="loading">
		<div class="inner">
			<div class="box">
		    	<p >메일정보를 등록하고 있습니다. 잠시만 기다려주세요.<br />
					시스템 상태에 따라 최대 10분 정도 소요될 수 있습니다.</p>
				<span><img src="/images/etc/loading_bar.gif" width="323" height="39" alt="loading" /></span>
			</div>
		</div>
	</div>
</div>

</body>
</html>