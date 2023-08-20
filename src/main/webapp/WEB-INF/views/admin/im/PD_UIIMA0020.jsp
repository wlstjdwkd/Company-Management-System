<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,form,validate,selectbox,notice,msgBox,blockUI,colorbox,ui,mask,multifile,jBox" />
<ap:jsTag type="tech" items="msg,util,acm,im" />
<ap:globalConst />	
<script type="text/javascript">
$(document).ready(function(){
	$("#ad_resn").attr("required", "required");
	
	<c:if test="${param.ad_readonly eq 'Y'}" >	
	$("#ad_resn").attr("disabled", "disabled");
	</c:if>
});

function saveCancelIssue(){
	
	if(!$("#dataForm").valid()){
		return;
	}
	
	$("#df_method_nm").val("updateCancelIssue");
	
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

<div id="self_dgs">
<div class="pop_q_con">   
 
  <table cellpadding="0" cellspacing="0" class="table_basic" summary="발급취소사유 등록">
        <caption>
        발급취소사유 등록
        </caption>
        <colgroup>
        <col style="width:20%" />
        <col style="width:*" />
        </colgroup>
        <tbody>
            <tr>
                <th scope="row">판정결과</th>
                <td class="right_line">
	                <ap:code id="ad_se_code" grpCd="38" type="select" selectedCd="${cancelIssue.RESN_SE}" ignoreCd="RC3,RC4" defaultLabel="" disabled="true" />
                </td>
            </tr>
            <tr>
                <th scope="row">판정코드</th>
                <td class="right_line">
                	<ap:code id="ad_jdgmnt_code" grpCd="16" type="select" selectedCd="${cancelIssue.JDGMNT_CODE}" ignoreCd="" defaultLabel="" disabled="true" />                	
                </td>
            </tr>
            <tr>
                <th scope="row"><label for="ad_valid_pd_begin_de">유효기간</label></th>
                <td class="right_line">
                	<input required  type="text" value="${cancelIssue.VALID_PD_BEGIN_DE}" id="ad_valid_pd_begin_de" name="ad_valid_pd_begin_de" class="datepicker" title="유효기간 시작일자" style="width:100px;" disabled />
                    <strong> ~ </strong>
                    <input required type="text" value="${cancelIssue.VALID_PD_END_DE}" id="ad_valid_pd_end_de" name="ad_valid_pd_end_de" class="datepicker" title="유효기간 마지막일자" style="width:100px;" disabled />
                </td>
            </tr>
            <tr>
                <th scope="row">발급취소 사유</th>
                <td class="right_line">
                	<%-- <textarea name="ad_resn" id="ad_resn" cols="85" rows="5" title="내용입력란"  style="width:95%;" placeholder="발급취소 사유를 입력해 주세요.">${cancelIssue.RESN}</textarea> --%>
                	<ap:code id="ad_resn" grpCd="17" type="select" selectedCd="${cancelIssue.RESN}" ignoreCd="" />                	
                </td>
            </tr>
        </tbody>
    </table>
    <c:if test="${param.ad_readonly eq 'N'}" >
    <div class="btn_page_last"><a class="btn_page_admin" href="#none" onclick="saveCancelIssue()"><span>저장</span></a> </div>
    </c:if>      
  
</div>
</div>
</form>
</body>
</html>