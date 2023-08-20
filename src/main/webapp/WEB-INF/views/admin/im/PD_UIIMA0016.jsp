<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,form,validate,selectbox,notice,msgBox,blockUI,colorbox,ui,mask,multifile,jBox" />
<ap:jsTag type="tech" items="msg,util,acm,font, cmn, mainn, subb" />
<ap:globalConst />	
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<script type="text/javascript">
$(document).ready(function(){
	
});

function saveCancelReception(){
	
	if(!$("#dataForm").valid()){
		return;
	}
	
	$("#df_method_nm").val("updateCancelReception");
	
	$("#dataForm").ajaxSubmit({
        url      : "${svcUrl}",
        type     : "POST",
        dataType : "text",
        data     : {},            
        async    : false,                
        success  : function(response) {
        	try {
        		if(eval(response)){
        			jsMsgBox(null,'info',Message.msg.successSave,function(){
        				parent.document.getElementById("df_method_nm").value="getData";
        				parent.document.getElementById("dataForm").submit();
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
<div id="regisCancle01" class="modal" style="z-index:auto;">
		<div class="modal_wrap w-80">
			 <div class="modal_cont"> 
 
   <table cellpadding="0" cellspacing="0" class="table_form" style="margin-bottom: 2px;width:100%;" summary="접수취소 사유 등록">
        <caption>
      접수취소 사유 등록
        </caption>
        <colgroup>
        <col width="172px" />
        <col width="367px" />
        </colgroup>
        <tbody>
            <tr class="table_input">
                <th class="t_center">접수취소 사유</th>
                <td class="b_l_0" style="line-height: 0;"><textarea name="ad_resn" id="ad_resn" cols="85" rows="10" title="내용입력란"  style="width: calc(100% - 15px); height: 202px; box-sizing: border-box; padding: 15px;" placeholder="접수취소 사유를 입력해 주세요.">${cancelReception.RESN}</textarea></td>
            </tr>
        </tbody>
    </table>
    <c:if test="${param.ad_readonly eq 'N'}" >
    <div class="btn_bl"><a class="bl_btn" href="#none" onclick="saveCancelReception();"><span>저장</span></a> </div> 
  	</c:if>
</div>
</div>
</div>
</form>
</body>
</html>