<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,form,validate,selectbox,notice,msgBox,blockUI,colorbox,ui,mask,multifile,jBox" />
<ap:jsTag type="tech" items="msg,util,acm, font, cmn, mainn, subb" />
<script type="text/javascript" src="${contextPath}/script/bizrnoCert/nxts.min.js"></script>
<script type="text/javascript" src="${contextPath}/script/bizrnoCert/nxtspki_config.js"></script>
<script type="text/javascript" src="${contextPath}/script/bizrnoCert/nxtspki.js"></script>
<ap:globalConst />	
<script type="text/javascript">
$(document).ready(function(){
	// 사업자 공인인증 초기화
	nxTSPKI.onInit(function(){ 
	});

	nxTSPKI.init(true);
	
	// 사업자 공인인증 콜백함수
	function login_data_complete_callback(res) {
        if (res.code == 0) {
            $("#loginData").val(res.data.loginData);
			
            $.ajax({
				url : "PGCMLOGIO0010.do",
				type : "POST",
				dataType : "html",
				data : {
					df_method_nm : "bsisnoProc",
					page_type : "3",
					loginData : res.data.loginData,
					ad_ssn : $('#ad_bizrno_first').val() + $('#ad_bizrno_middle').val() + $('#ad_bizrno_last').val()
				},
				async : false,
				success : function(
						response) {
					try {
						$("#addd").html(response);
						 if(document.querySelector('span#jb3').innerHTML != "0"){
							 alert("사업자 인증이 완료되었습니다.");
							 parent.$("#df_method_nm").val("processLogin");
						 	 parent.dataForm.submit();
						 }else{
							 alert("이미 등록되어 있는 사업자 정보입니다."); 
						}
					} catch (e) {
						if (response != null) {
							jsSysErrorBox(response);
						} else {
							jsSysErrorBox(e);
						}
						return;
					}
				}
			});
         }
        else {
            /* alert("error code = " + res.code + ", message = " + res.errorMessage); */
        	if (res.code == 100) { // 공인인증창 닫기
            } else if (res.code == 111) {
                alert("인증서의 암호가 틀립니다.");
            } else if (res.code == 140) {
                alert("입력하신 사업자번호와 인증서 정보가 맞지 않습니다.");
            } else {
                alert(res.errorMessage);
            }
        }
    }

	// 사업자 공인인증 로직
	$("#btn_proc").click(function() {
			
		var ad_bizrno_first 	= $('#ad_bizrno_first').val();
		var ad_bizrno_middle 	= $('#ad_bizrno_middle').val();
		var ad_bizrno_last 		= $('#ad_bizrno_last').val();
		var usr 				= $("#ad_user_id").val();
		
		var verifyVID = true;
        var options = {};

        var sessionId = usr;
        var ssn = ""+ad_bizrno_first+ad_bizrno_middle+ad_bizrno_last;
        var userInfo = "0";
        
        if(ssn == "" || ssn.length != 10){
        	alert("사업자번호 10자리를 입력해주세요.");
            return;
        }
		
    	if (ssn.substring(3,5) == "85") {
       		alert("본점 사업자번호로만 가입이 가능합니다.");
            return;
       	}
        	
        if(verifyVID == true) {
			if(ssn != "0") {
				options.ssn = ssn;
			}
			else {
				alert("ssn에 입력된 값이 알맞지 않아 신원확인을 수행하지 않습니다.");
			}
        }
        
        nxTSPKI.loginData(sessionId, ssn, userInfo, options, login_data_complete_callback);
	});

});

</script>
</head>

<body style="overflow-y:hidden;">
<form name="dataForm" id="dataForm" method="post" action="/PGCMLOGIO0010.do">
<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />
<input type="hidden" id="ad_user_id" name="ad_user_id" value="${param.ad_login_id}" />
<input type="hidden" id="no_lnb" value="true" />
<input type="hidden" name="ad_bizrno" id="ad_bizrno" value=""/>
<input type="hidden" name="page_type" id="page_type" value="3" />

<div class="modal_wrap2" style="width:620px;overflow-y:hidden !important;">
	<div class="modal_cont" style="overflow:hidden;">
		   <table cellpadding="0" cellspacing="0" class="table_form" style="margin-bottom: 5px;width:550px;" summary="접수취소 사유 등록">
		        <colgroup>
		        <col width="20%" />
		        <col width="*" />
		        </colgroup>
		        <tbody>
		            <tr class="table_input">
		                <th class="t_center">사업자번호</th>
		                <td class="b_l_0" style="line-height: 0;">
		                	<input type="text" name="ad_bizrno_first" id="ad_bizrno_first" style="width: 76px; margin-right: 5px;" value="${ad_bizrno_first}" >-<input type="text" name="ad_bizrno_middle" id="ad_bizrno_middle" style="width: 56px; margin-right: 5px; margin-left: 5px;" value="${ad_bizrno_middle}" >-<input type="text" name="ad_bizrno_last" id="ad_bizrno_last" style="width: 76px; margin-left: 5px;" value="${ad_bizrno_last}" >
		                	<input type="hidden" name="loginData" id="loginData" />
						</td>
		            </tr>
		        </tbody>
		    </table>
		    <div class="btn_bl" style="width:551px;padding-top:30px;padding-bottom:23px;"><a class="bl_btn" href="#none" id="btn_proc"><span>인증</span></a> </div> 
</div>
</div>

</form>
<div style="display:none" id="addd">
		
</div>
</body>
</html>