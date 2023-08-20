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
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox" />
<ap:jsTag type="tech" items="msg,util,ucm,my" />

<script type="text/javascript">

$(document).ready(function(){
	
	// MASK
	$("#ad_itm_51_atrb1").mask('0000');
	$('#cal_start_dt').mask('0000-00-00');
    $('#cal_end_dt').mask('0000-00-00');
	
	// 달력
	$('#cal_start_dt').datepicker({
        showOn : 'button',
        defaultDate : null,
        buttonImage : '<c:url value="images/ts/icon_cal.gif" />',
        buttonImageOnly : true,
        changeYear: true,
        changeMonth: true,
        yearRange: "1920:+1"
    });
    $('#cal_end_dt').datepicker({
        showOn : 'button',
        defaultDate : null,
        buttonImage : '<c:url value="images/ts/icon_cal.gif" />',
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
			},
		submitHandler: function(form) {
			
			// 달력 valid
			$("#check_date").click(function() {
		    	if($("#cal_start_dt").val() > $("#cal_end_dt").val() || $("#cal_start_dt").val().replace(/-/gi,"") > $("#cal_end_dt").val().replace(/-/gi,"")){
		    		jsMsgBox(Message.msg.invalidDateCondition);		    		
		            $("#cal_end_dt").focus();
		            return false;
		        }
		    });			
			
			$("#dataForm").ajaxSubmit({
				url      : "PGMY0030.do",
				type     : "post",
				dataType : "json",
				async    : false,
				success  : function(response) {
					try {						
						if(response.result) {							
							alert(response.result);
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
 	
}); // ready

</script>

</head>
<body>

<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" enctype="multipart/form-data" method="post">

<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />
<ap:include page="param/pagingParam.jsp" />

</form>

</body>
</html>