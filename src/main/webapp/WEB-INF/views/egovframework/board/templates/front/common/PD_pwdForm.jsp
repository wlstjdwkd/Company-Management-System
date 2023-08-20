<%@ page contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<%@ page import="egovframework.board.config.BoardConfConstant" %>
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />

<html>
<head>
	<title>글 비밀번호 확인</title>
	
	<ap:jsTag type="web" items="jquery,form,validate,colorbox,ui,notice,msgBox" />
	<ap:jsTag type="tech" items="msg,util,ucm,mb" />	

	<script type="text/javascript">
		$(function(){
			$("#dataForm").validate();
			
			$("#regPwd")[0].focus();
			
			$("#btn_confirm").click(function(){
				if(!$("#dataForm").valid()){
					return;
				}
				
				$("#df_method_nm").val("boardPwdConfirm");
				dataString = $("#dataForm").serialize();				
				$.ajax({
					type: "POST",
					url: "${svcUrl}",
					data: dataString,
					dataType: "json",
					success: function(response){						
						if(!response.result){
							jsMsgBox($(this),'warn',Message.msg.notMatchPwd);
						}else{
							parent.$("#dataForm input[name=df_method_nm]").val("boardView");
							parent.$("#dataForm input[name=bbsCd]").val("${param.bbsCd}");
							parent.$("#dataForm input[name=seq]").val("${param.seq}");
							parent.jsRequest("dataForm", "${svcUrl}", "post");
							parent.$.fn.colorbox.close();
						}
					}
				});
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
	<input type="hidden" name="bbsCd" value="${param.bbsCd}" />
	<input type="hidden" name="seq" value="${param.seq}" />
	<!-- default values -->		
	<ap:include page="param/defaultParam.jsp" />	

	<div>
	    <div class="pop_write">
	        <div class="txt_zone"><p>글 등록시 사용한 비밀번호를 입력하세요.</p></div>
	        <table cellpadding="0" cellspacing="0" class="ptbl_basic" summary="비밀번호 확인">
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
	        <div class="btn_page tar">
	        	<a class="btn_page_blue" href="#none" id="btn_close"><span>취소</span></a>
	        	<a class="btn_page_blue" href="#none" id="btn_confirm"><span>확인</span></a>
	        </div>
	    </div>
	</div>

</form>

</body> 
  
</html>