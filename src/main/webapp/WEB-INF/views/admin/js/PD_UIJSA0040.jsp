<%@ page contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<%@ page import="egovframework.board.config.BoardConfConstant" %>
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />

<html>
<head>
	<title>글 비밀번호 확인</title>
	
	<ap:jsTag type="web" items="jquery,form,validate,colorboxAdmin,ui,notice,msgBoxAdmin" />
	<ap:jsTag type="tech" items="msg,util,acm" />	

	<script type="text/javascript">
		$(function(){
			$("#dataForm").validate();
			
			$("#regPwd")[0].focus();
			
			$("#btn_confirm").click(function(){
				if(!$("#dataForm").valid()){
					return;
				}
				
				// 판정자료삭제
				if($("#ad_dataType").val() == "deleteData") {
					$("#df_method_nm").val("adminPwdConfirm");
					dataString = $("#dataForm").serialize();				
					$.ajax({
						type: "POST",
						url: "${svcUrl}",
						data: dataString,
						dataType: "json",
						success: function(response){				
							try {
		                        if(response.result) {
		                        	parent.document.getElementById("ad_pwdcheck").value = "Y";
									parent.$.fn.colorbox.close();
		                        } else {                        	 
		                        	if(response.value.result == 'fail'){
		                        		jsMsgBox($(this),'warn',Message.msg.notMatchPwd);
		                        		checkpwd = false;
		                        		return;
		                       
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
			
				//판정자료초기화
				if($("#ad_dataType").val() == "backupData") {
					$("#df_method_nm").val("adminPwdConfirm");
					dataString = $("#dataForm").serialize();				
					$.ajax({
						type: "POST",
						url: "${svcUrl}",
						data: dataString,
						dataType: "json",
						success: function(response){				
							try {
		                        if(response.result) {
		                        	parent.document.getElementById("ad_backupcheck").value = "Y";
									parent.$.fn.colorbox.close();
		                        } else {                        	 
		                        	if(response.value.result == 'fail'){
		                        		jsMsgBox($(this),'warn',Message.msg.notMatchPwd);
		                        		checkpwd = false;
		                        		return;
		                       
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
				return false;
			});
			
			$("#regPwd").keyup(function(e){
				if(e.keyCode == 13) {
					$("#btn_confirm").trigger("click");
					return;
				}				
			});
			
			$("#btn_close").click(function(){
				parent.$.fn.colorbox.close();
			});
		});
	
	</script>
</head>
  
<body>  

<form id="dataForm" name="dataForm" method="post" onsubmit="return false" >
	<input type="hidden" id="ad_dataType" name="ad_dataType" value="${param.ad_dataType}" />
	<!-- default values -->		
	<ap:include page="param/defaultParam.jsp" />	
	

	<div>
	    <div class="pop_q_con">
	    	<div class="block">
	        <div class="text_14">관리자 비밀번호를 입력하세요.</div>
	        <table cellpadding="0" cellspacing="0"class="table_basic mgt10" summary="비밀번호 확인">
	            <caption>
	            비밀번호확인
	            </caption>
	            <colgroup>
	            <col width="25%">
	            <col width="*">
	            </colgroup>
	            <tbody>
	                <tr>
	                    <th scope="row" class="point"> 비밀번호</th>
	                    <td>
	                    	<input type="password" id="regPwd" name="regPwd" maxlength="20" required title="비밀번호를 입력해주세요." />
	                    </td>
	                </tr>
	            </tbody>
	        </table>
	        <!--//페이지버튼-->
	        <div class="btn_page_last tar">
	        	<a class="btn_page_admin" href="#none" id="btn_close"><span>취소</span></a>
	        	<a class="btn_page_admin" href="#none" id="btn_confirm"><span>확인</span></a>
	        </div>
	    </div>
	    </div>
	</div>

</form>

</body> 
  
</html>