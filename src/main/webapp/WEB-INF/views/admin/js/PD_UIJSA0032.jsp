<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>확정판정보기 및 등록</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,multifile" />
<ap:jsTag type="tech" items="acm,msg,util" />
<script type="text/javaScript">
$(document).ready(function(){
	
<c:if test="${resultMsg != null}">
	$(function(){
		jsMsgBox(null, "info", "${resultMsg}", function(){
			parent.$("#btn_resn_${param.ad_hpe_cd }").colorbox.close();
		});
	});
</c:if>
	
	$("#dataForm").validate({
		rules : {
			ad_basisDc: {
				required: true,
				maxlength: 200
			}
		},
		submitHandler: function(form) {
			
			if ($("input:radio[id='ad_dcsnHpeAt_Y']").is(":checked") == true) {
				if ($("#ad_resn_Y option:selected").val() == '') {
					jsMsgBox($("#ad_resn_Y"), "error", Message.template.required("판정사유"));
					return;
				}
			} else if ($("input:radio[id='ad_dcsnHpeAt_N']").is(":checked") == true) {
				if ($("#ad_resn_N option:selected").val() == '') {
					jsMsgBox($("#ad_resn_N"), "error", Message.template.required("판정사유"));
					return;
				}
			} else {
				jsMsgBox(null, "error", Message.template.required("확정판정"));
				return;
			}
			
			jsMsgBox(null, 'confirm','<spring:message code="confirm.common.save" />', function(){
				$("#df_method_nm").val("insertDcsnJdgmntResn");
				form.submit();
			});
		}
	});
	
    $("#attachFile").MultiFile({
		max: 1,
		STRING: {			
			remove: '<img src="<c:url value="/images/ucm/icon_del.png" />" alt="x" style="vertical-align:baseline;" />',
			denied: Message.msg.fildUploadDenied,  		//확장자 제한 문구
			duplicate: Message.msg.fildUploadDuplicate	//중복 파일 문구
		}
	});
    
    $("input:radio[name=ad_dcsnHpeAt]").change(function(){
    	if (this.value == 'Y') {
    		$("#resnBoxY").css("display", "inline");
    		$("#resnBoxN").css("display", "none");
    	}
    	else if (this.value == 'N') {
    		$("#resnBoxY").css("display", "none");
    		$("#resnBoxN").css("display", "inline");
    	}
    });
});

//첨부파일 다운로드
function downAttFile(fileSeq) {
	jsFiledownload("/PGCM0040.do","df_method_nm=updateFileDownBySeq&seq="+fileSeq);
}

// 첨부파일 삭제 및 파일컴포넌트 활성화
function delAttFile(fileSeq) {
	jsMsgBox(null, "confirm", Message.msg.fileDeleteConfirm, function() {
		$.ajax({
	        url      : "PGJS0030.do",
	        type     : "POST",
	        dataType : "json",
	        data     : {
	        			  df_method_nm:"deleteAttchFile"
	        			, ad_file_seq:fileSeq
	        			, ad_stdyy:$("#ad_stdyy").val()
	        			, ad_hpe_cd:$("#ad_hpe_cd").val()
	        },                
	        async    : false,                
	        success  : function(response) {        	
	        	if(response.result) {
        			$("#ad_attachFile").attr("disabled",false);
        			$("#attachFile_view").remove();
        			jsMsgBox(null, 'info', Message.msg.successDelete);
                } else {
                	jsMsgBox(null, 'info', Message.msg.failDelete);
                }
	        }
	    });
	});
}
</script>
</head>
<body>
<div id="self_dgs">
	<div class="pop_q_con">
		<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}'/>" method="post" enctype="multipart/form-data">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<input type="hidden" id="no_lnb" value="true" />
		
		<input type="hidden" id="ad_stdyy" name="ad_stdyy" value="${param.ad_stdyy }" />
		<input type="hidden" id="ad_hpe_cd" name="ad_hpe_cd" value="${param.ad_hpe_cd }" />
		
	    <table cellpadding="0" cellspacing="0" class="table_basic" summary="근거">
	        <caption>
	        근거
	        </caption>
	        <colgroup>
	        <col width="20%" />
	        <col width="*" />
	        </colgroup>
	        <tbody>
	            <tr>
	                <th scope="row">업체명</th>
	                <td><c:out value="${JdgmntResn.entrprsNm }" /></td>
	            </tr>
	            <tr>
	                <th scope="row">확정판정</th>
	                <td>
	                	<input type="radio" name="ad_dcsnHpeAt" id="ad_dcsnHpeAt_Y" value="Y"<c:if test="${JdgmntResn.dcsnHpeAt eq 'Y' or empty JdgmntResn.dcsnHpeAt}"> checked</c:if> />
	                    <label for="ad_dcsnHpeAt_Y">적합</label>
	                    <input type="radio" name="ad_dcsnHpeAt" id="ad_dcsnHpeAt_N" value="N" class="mgl50"<c:if test="${JdgmntResn.dcsnHpeAt eq 'N' }"> checked</c:if> />
	                    <label for="ad_dcsnHpeAt_N">부적합</label>
	                </td>
	            </tr>
	            <tr>
	                <th rowspan="3" scope="row">판정사유</th>
	                <td>
	                	<div id="resnBoxY" style="display: <c:if test="${JdgmntResn.dcsnHpeAt eq 'Y' or empty JdgmntResn.dcsnHpeAt}">inline</c:if><c:if test="${JdgmntResn.dcsnHpeAt eq 'N' }">none</c:if>;">
	                		<ap:code id="ad_resn_Y" grpCd="16" type="select" selectedCd="${JdgmntResn.dcsnResnCd }" />
	                	</div>
	                	<div id="resnBoxN" style="display: <c:if test="${JdgmntResn.dcsnHpeAt eq 'Y' or empty JdgmntResn.dcsnHpeAt}">none</c:if><c:if test="${JdgmntResn.dcsnHpeAt eq 'N' }">inline</c:if>;">
	                		<ap:code id="ad_resn_N" grpCd="17" type="select" selectedCd="${JdgmntResn.dcsnResnCd }" />
	                	</div>
	                </td>
	            </tr>
	            <tr>
	                <td><textarea name="ad_basisDc" id="ad_basisDc" cols="85" rows="5" title="내용입력란"  style="width:95%;">${JdgmntResn.basisDc }</textarea></td>
	            </tr>
	            <tr>
	                <td>
	                	<input type="file" name="ad_attachFile" id="ad_attachFile" style="width:80%;" title="파일선택"<c:if test="${not empty JdgmntResn.fileSn}"> disabled="disabled"</c:if> />
					<c:if test="${not empty JdgmntResn.fileSn }" >
						<div id="attachFile_view">
							<a href="#none" onclick="delAttFile('${JdgmntResn.fileSn}')"><img src="<c:url value="/images/ucm/icon_del.png"/>" style="vertical-align:baseline;" /> </a>
							<a href="#none" onclick="downAttFile('${JdgmntResn.fileSn}')">${JdgmntResn.fileNm}</a>
						</div>
					</c:if>
	                </td>
	            </tr>
	        </tbody>
	    </table>
	    <div class="btn_page_last">
	    	<a class="btn_page_admin" href="#none" onclick="$('#dataForm').submit();"><span>저장</span></a> 
	    	<a class="btn_page_admin" href="#none" onclick="document.dataForm.reset();"><span>취소</span></a> 
	   	</div>
	   	</form>
	</div>
</div>
</body>
</html>