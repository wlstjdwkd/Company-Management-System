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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>정보</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask" />
<ap:jsTag type="tech" items="acm,msg,util,ms" />

<script type="text/javascript">

$().ready(function(){
	
	$("#btn_submit").click(function() {
		var prtDoc = parent.document;
		var $prtUsers = $("#hi_target_user_no", parent.document).val();
		var $authChkeds = $("input[name='ad_chk_auth']:checked");
		var users = [];
		var auths = [];
		
		if($prtUsers == "") {
			jsMsgBox($(this), "info", Message.template.noSetTarget('회원권한설정 대상'));
			return;
		}						
		if($authChkeds.length < 1) {
			jsMsgBox($(this), "info", Message.template.noSetTarget('권한'));	
			return;
		}
		
		$("#ad_ta_users").val($prtUsers);
		$authChkeds.each(function() {
			auths.push($(this).val());
			$("#ad_set_auths").val(auths);
		});
		
		$.ajax({
			url      : "${svcUrl}",
			type     : "post",			
			dataType : "json",
			data	 : {
						"df_method_nm"	: "processUserAuthGroup",
						"ad_ta_users" : $("#ad_ta_users").val(),
						"ad_set_auths" : $("#ad_set_auths").val()
						},
			async    : false,
			success  : function(response) {
				try {
					if(eval(response)) {						
						jsMsgBox(null, "info", Message.msg.processOk, function(){
							parent.location.reload();
							parent.$.colorbox.close();	
						});
						
					} else {
						jsMsgBox(null, Message.msg.processFail);
					}
				} catch (e) {
					jsSysErrorBox(response, e);
					return;
				}                            
			}
		});
	});
	
});

</script>

</head>
<body>

<div id="self_dgs">
<div class="pop_q_con">
    <div class="block">
    
    	<input type="hidden" id="ad_ta_users" />
    	<input type="hidden" id="ad_set_auths" />
    
        <ul class="ud_line">
            <li>
                <input type="checkbox" name="ad_chk_auth" id="ad_chk_auth_1" value="${AUTH_DIV_ADM }">
                <label for="ad_chk_auth_1">운영담당자</label>
            </li>
            <li>
                <input type="checkbox" name="ad_chk_auth" id="ad_chk_auth_2" value="${AUTH_DIV_PUB }">
                <label for="ad_chk_auth_2">인사담당자</label>
            </li>
            <li>
                <input type="checkbox" name="ad_chk_auth" id="ad_chk_auth_3" value="${AUTH_DIV_BIZ }">
                <label for="ad_chk_auth_3">이사진</label>
            </li>
            <li>
                <input type="checkbox" name="ad_chk_auth" id="ad_chk_auth_4" value="${AUTH_DIV_ENT }">
                <label for="ad_chk_auth_4">영업담당자</label>
            </li>
            <li>
                <input type="checkbox" name="ad_chk_auth" id="ad_chk_auth_4" value="${AUTH_DIV_EMP }">
                <label for="ad_chk_auth_5">사원</label>
            </li>
        </ul>
        <div class="btn_page_last">
        	<a class="btn_page_admin" href="#none" id="btn_submit"><span>확인</span></a>
        </div>
    </div>
</div>
<!--content//-->
</body>
</html>