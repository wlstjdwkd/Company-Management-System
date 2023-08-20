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
<ap:globalConst />	
<script type="text/javascript">
$(document).ready(function(){
	
});

function saveCancelReception(){
	
	if(!$("#dataForm").valid()){
		return;
	}
	
	$("#df_method_nm").val("updateSupplement");
	
	$("#dataForm").ajaxSubmit({
        url      : "PGIM0010.do",
        type     : "POST",
        dataType : "text",
        data     : {},            
        async    : false,                
        success  : function(response) {
        	try {
        		if(eval(response)){
        			jsMsgBox(null,'info',Message.msg.successSave,function(){
        				<c:if test="${param.supplementYn != 'Y'}" >
        				parent.document.getElementById("df_method_nm").value="index";
        				parent.document.getElementById("dataForm").submit();
        			  	</c:if>
        				parent.$.colorbox.close();
        			});
        		}else{
        			jsMsgBox(null,'info',Message.msg.failSave);
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
<form name="dataForm" id="dataForm" method="post" action="/PGIM0010.do">
<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />
<input type="hidden" id="ad_rcept_no" name="ad_rcept_no" value="${param.ad_rcept_no}" />
<input type="hidden" id="no_lnb" value="true" />

<div class="modal_wrap2">
	<div class="modal_cont">
  <%--  
  <c:if test="${ENTRPRS_NM != null}" >
   <table cellpadding="0" cellspacing="0" border="0" class="table_form" style="margin-bottom: 5px;">
       <tr class="table_input">
           <td height="20">
		     <h3 class="middle">${ENTRPRS_NM}</h3>
           </td>
       </tr>
   </table>
   </c:if> 
   --%>
   
		   <table cellpadding="0" cellspacing="0" class="table_form" style="margin-bottom: 5px;" summary="접수취소 사유 등록">
		        <caption>
		      	보완요청 사유 등록
		        </caption>
		        <colgroup>
		        <col width="20%" />
		        <col width="*" />
		        </colgroup>
		        <tbody>
		            <tr class="table_input">
		                <th class="t_center">보완요청 사유</th>
		                <td class="b_l_0" style="line-height: 0;"><textarea name="ad_resn" id="ad_resn" cols="85" rows="10" title="내용입력란" required="required" style="width: 478px; height: 202px;" placeholder="보완요청 사유를 입력해 주세요.">${supplement.RESN2}</textarea></td>
		            </tr>
		        </tbody>
		    </table>
		    <c:if test="${param.ad_readonly eq 'N'}" >
		    <div class="btn_bl"><a class="bl_btn" href="#none" onclick="saveCancelReception();"><span>저장</span></a> </div> 
		  	</c:if>
		  	
			<c:if test="${param.ad_reqst_se eq 'AK1'}" >
				<p style="width:98%">* 상기 내용을 수정바랍니다.</p>
				<p style="width:98%">** 수정화면에서 저장버튼을 누르면 바로 보완접수되어 수정이 불가하오니 수정이 모두 완료되면 저장을 해주시기 바랍니다.</p>
				<div class="btn_bl"><a class="bl_btn" href="#none" onclick="parent.reqstWriteForm('${param.ad_rcept_no}');"><span>수정화면 이동</span></a> </div> 
			</c:if>
			<c:if test="${param.ad_reqst_se eq 'AK2'}">
				<p style="width:98%">* 상기 내용을 수정바랍니다.</p>
				<p style="width:98%">** 수정화면에서 저장버튼을 누르면 바로 보완접수되어 수정이 불가하오니 수정이 모두 완료되면 저장을 해주시기 바랍니다.</p>
				<div class="btn_bl"><a class="btn_bl" href="#none" onclick="parent.issueAgainPop('${param.ad_upper_rcept_no}', '${param.ad_rcept_no}');"><span>수정화면 이동</span></a> </div> 
			</c:if>
</div>
</div>

</form>
</body>
</html>