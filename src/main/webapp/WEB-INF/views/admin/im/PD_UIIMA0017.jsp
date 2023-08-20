<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,form,validate,selectbox,notice,msgBox,blockUI,colorbox,ui,mask,multifile,jBox" />
<ap:jsTag type="tech" items="msg,util,acm" />
<ap:globalConst />	

<script type="text/javascript">
$(document).ready(function(){
	<c:if test="${param.ad_readonly eq 'N' or judgment.RC1_FLAG eq 'Y'}" >	
	$('.datepicker').datepicker({
        showOn : 'button',        
        buttonImage : '<c:url value="/images/acm/icon_cal.png" />',
        buttonImageOnly : true,
        changeYear: true,
        changeMonth: true,
        yearRange: "2012:+5"
    });
	$('.datepicker').mask('0000-00-00');		
	$("#dataForm").validate();
	</c:if>
	
	var seCode = $("#ad_se_code option:selected").val();
	initJudgCd(seCode);
	
	<c:if test="${param.ad_readonly eq 'Y'}" >	
	$("#ad_jdgmnt_code").val('${judgment.JDGMNT_CODE}');
	</c:if>
	
	
	$("#ad_se_code").on("change",function(){
		var val = $(this).val();
		initJudgCd(val);
	});
	
});

function initJudgCd(seCode){
	var judgCd;
	if(seCode=="RC1"){
		judgCd = "16";
	}else{
		judgCd = "17";
	}
	
	$("#ad_jdgmnt_code").removeOption(/./);
	$.ajax({
        url      : "PGIM0010.do",
        type     : "POST",
        dataType : "json",
        data     : { df_method_nm : "getJudgCd", ad_grp_cd: judgCd },                
        async    : false,                
        success  : function(response) {
        	try {
        		if(response.result){
        			for(var i=0; i<response.value.length; i++){
	        			$("#ad_jdgmnt_code").append("<option value='"+response.value[i].code+"'>"+response.value[i].codeNm+"</option>");
        			}
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
//	$("#ad_jdgmnt_code").sortOptions(false);
	$("#ad_jdgmnt_code option:first").attr("selected", "selected");
}

function saveJudgment(){
	
	var validPdBeginDe = $('#ad_valid_pd_begin_de').cleanVal();	
	var validPdEndDe = $('#ad_valid_pd_end_de').cleanVal();
	
	var seCode = $("#ad_se_code option:selected").val();
	if(seCode=="RC1"){
		if(Util.isEmpty(validPdBeginDe)||Util.isEmpty(validPdEndDe)){
			jsMsgBox(null,'info',Message.template.required("유효기간"));
			return;
		}
		
		if(validPdBeginDe > validPdEndDe){		
			jsMsgBox(null,'info',Message.msg.invalidDateCondition);
	        return false;
	    }
		
		//TODO : 유효기간 유효성 확인 
	}
	
	
	
	
	var ad_rcept_no = $("#ad_rcept_no").val();
	$("#df_method_nm").val("updateJudgment");
	
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

function updateJudgment(){
	
	var validPdBeginDe = $('#ad_valid_pd_begin_de').cleanVal();	
	var validPdEndDe = $('#ad_valid_pd_end_de').cleanVal();
	
	var seCode = $("#ad_se_code option:selected").val();
	if(seCode=="RC1"){
		if(Util.isEmpty(validPdBeginDe)||Util.isEmpty(validPdEndDe)){
			jsMsgBox(null,'info',Message.template.required("유효기간"));
			return;
		}
		
		if(validPdBeginDe > validPdEndDe){		
			jsMsgBox(null,'info',Message.msg.invalidDateCondition);
	        return false;
	    }
		
		//TODO : 유효기간 유효성 확인 
	}

	var ad_rcept_no = $("#ad_rcept_no").val();
	$("#df_method_nm").val("updateJudgmentForRC1");
	
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
 
  <table cellpadding="0" cellspacing="0" class="table_basic" summary="판정결과 등록">
        <caption>
        판정결과 등록
        </caption>
        <colgroup>
        <col style="width:20%" />
        <col style="width:*" />
        </colgroup>
        <tbody>
            <tr>
                <th scope="row">판정결과</th>
                <td class="right_line">	                
	                <c:choose>
					<c:when test="${param.ad_readonly eq 'Y'}">
					<ap:code id="ad_se_code" grpCd="38" type="select" selectedCd="${judgment.RESN_SE}" ignoreCd="RC3,RC4" defaultLabel="" disabled="true" />
					</c:when>       
					<c:otherwise>
					<ap:code id="ad_se_code" grpCd="38" type="select" selectedCd="${judgment.RESN_SE}" ignoreCd="RC3,RC4" defaultLabel="" />
					</c:otherwise>
					</c:choose>	                
                </td>
            </tr>
            <tr>
                <th scope="row">판정코드</th>
                <td class="right_line">
                	<%-- <ap:code id="ad_jdgmnt_code" grpCd="16" type="select" selectedCd="${judgment.JDGMNT_CODE}" ignoreCd="" defaultLabel="" /> --%>
               		<select <c:if test="${param.ad_readonly eq 'Y'}" >disabled</c:if> id="ad_jdgmnt_code" name="ad_jdgmnt_code"></select>
                </td>
            </tr>
            <tr>
                <th scope="row"><label for="ad_valid_pd_begin_de">유효기간</label></th>
                <td class="right_line">
                	<c:if test="${judgment.RESN_SE ne 'RC2'}">
	                	<input <c:if test="${param.ad_readonly eq 'Y' and judgment.RC1_FLAG eq 'N'}" >disabled</c:if> type="text" value="${judgment.VALID_PD_BEGIN_DE}" id="ad_valid_pd_begin_de" name="ad_valid_pd_begin_de" class="datepicker" style="width:100px;" title="유효기간 시작일자" />
	                    <strong> ~ </strong>
	                    <input <c:if test="${param.ad_readonly eq 'Y' and judgment.RC1_FLAG eq 'N'}" >disabled</c:if> type="text" value="${judgment.VALID_PD_END_DE}" id="ad_valid_pd_end_de" name="ad_valid_pd_end_de" class="datepicker" style="width:100px;" title="유효기간 마지막일자" />
                    </c:if>
                    <c:if test="${judgment.RESN_SE eq 'RC2'}">
	                	<input <c:if test="${param.ad_readonly eq 'Y' and judgment.RC1_FLAG eq 'N'}" >disabled</c:if> type="text" value="" id="ad_valid_pd_begin_de" name="ad_valid_pd_begin_de" class="datepicker" style="width:100px;" title="유효기간 시작일자" />
	                    <strong> ~ </strong>
	                    <input <c:if test="${param.ad_readonly eq 'Y' and judgment.RC1_FLAG eq 'N'}" >disabled</c:if> type="text" value="" id="ad_valid_pd_end_de" name="ad_valid_pd_end_de" class="datepicker" style="width:100px;" title="유효기간 마지막일자" />
                    </c:if>
                </td>
            </tr>
            <tr>
                <th scope="row">확인서구분</th>
                <td class="right_line">
                	<c:if test="${judgment.RESN_SE ne 'RC2'}">
	                	<input <c:if test="${param.ad_readonly eq 'Y' and judgment.RC1_FLAG eq 'N'}" >disabled</c:if> type="radio" id="confm_se_radio1" name="ad_confm_se" value="A" <c:if test="${judgment.CONFM_SE eq null || judgment.CONFM_SE eq 'A'}" >checked</c:if> /><label for="confm_se_radio1">일반</label>
						<input <c:if test="${param.ad_readonly eq 'Y' and judgment.RC1_FLAG eq 'N'}" >disabled</c:if> type="radio" id="confm_se_radio2" name="ad_confm_se" value="B" <c:if test="${judgment.CONFM_SE eq 'B'}" >checked</c:if> /><label for="confm_se_radio2">유형1(Y/Y)</label>
						<input <c:if test="${param.ad_readonly eq 'Y' and judgment.RC1_FLAG eq 'N'}" >disabled</c:if> type="radio" id="confm_se_radio3" name="ad_confm_se" value="C" <c:if test="${judgment.CONFM_SE eq 'C'}" >checked</c:if> /><label for="confm_se_radio3">유형2(Y/N)</label>
						<input <c:if test="${param.ad_readonly eq 'Y' and judgment.RC1_FLAG eq 'N'}" >disabled</c:if> type="radio" id="confm_se_radio4" name="ad_confm_se" value="D" <c:if test="${judgment.CONFM_SE eq 'D'}" >checked</c:if> /><label for="confm_se_radio4">유형3(N/Y)</label>
						<input <c:if test="${param.ad_readonly eq 'Y' and judgment.RC1_FLAG eq 'N'}" >disabled</c:if> type="radio" id="confm_se_radio5" name="ad_confm_se" value="E" <c:if test="${judgment.CONFM_SE eq 'E'}" >checked</c:if> /><label for="confm_se_radio5">유형4(N/N)</label>
					</c:if>
					<c:if test="${judgment.RESN_SE eq 'RC2'}">
	                	<input <c:if test="${param.ad_readonly eq 'Y' and judgment.RC1_FLAG eq 'N'}" >disabled</c:if> type="radio" id="confm_se_radio1" name="ad_confm_se" value="A" checked /><label for="confm_se_radio1">일반</label>
						<input <c:if test="${param.ad_readonly eq 'Y' and judgment.RC1_FLAG eq 'N'}" >disabled</c:if> type="radio" id="confm_se_radio2" name="ad_confm_se" value="B" /><label for="confm_se_radio2">유형1(Y/Y)</label>
						<input <c:if test="${param.ad_readonly eq 'Y' and judgment.RC1_FLAG eq 'N'}" >disabled</c:if> type="radio" id="confm_se_radio3" name="ad_confm_se" value="C" /><label for="confm_se_radio3">유형2(Y/N)</label>
						<input <c:if test="${param.ad_readonly eq 'Y' and judgment.RC1_FLAG eq 'N'}" >disabled</c:if> type="radio" id="confm_se_radio4" name="ad_confm_se" value="D" /><label for="confm_se_radio4">유형3(N/Y)</label>
						<input <c:if test="${param.ad_readonly eq 'Y' and judgment.RC1_FLAG eq 'N'}" >disabled</c:if> type="radio" id="confm_se_radio5" name="ad_confm_se" value="E" /><label for="confm_se_radio5">유형4(N/N)</label>
					</c:if>
                </td>
            </tr>
            <tr>
                <th scope="row">반려 사유</th>
                <td class="right_line"><textarea <c:if test="${param.ad_readonly eq 'Y'}" >disabled</c:if> name="ad_resn" id="ad_resn" cols="85" rows="5" title="내용입력란"  style="width:95%;" placeholder="반려 사유를 입력해 주세요.">${judgment.RESN}</textarea></td>
            </tr>
        </tbody>
    </table>
    <c:if test="${param.ad_readonly eq 'N'}" >
    <div class="btn_page_last"><a class="btn_page_admin" href="#none" onclick="saveJudgment()"><span>저장</span></a> </div>
    </c:if>
    <c:if test="${param.ad_readonly eq 'Y' and judgment.RC1_FLAG eq 'Y'}" >
    <div class="btn_page_last"><a class="btn_page_admin" href="#none" onclick="updateJudgment()"><span>수정</span></a> </div>
    </c:if>     
  
</div>
</div>
</form>
</body>
</html>