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
<ap:jsTag type="tech" items="acm,msg,util" />
<ap:jsTag type="egovframework" items="board" />

<script type="text/javascript">
	$(document).ready(function() {
		<c:if test="${resultMsg != null}">
			$(function() {
				jsMsgBox(null, "info", "${resultMsg}");
			});
		</c:if>
		
		// 유효성 검사
		$("#dataForm").validate({
			rules : {
				ad_email_sj: {    				
	    			required : true,
	    			maxlength : 200
	    		},
	    		ad_email_cn : {
	    			required : true
	    		}
			},
			submitHandler : function(form) {
				<c:if test="${formType == 'INSERT'}">
					jsMsgBox(null, 'confirm'
					,'<spring:message code="confirm.common.save" />'
					,function() {
						$("#df_method_nm").val("insertLqttEmail");
        				
            			form.submit();
					});
				</c:if>
				<c:if test="${formType == 'UPDATE'}">
					jsMsgBox(null, 'confirm'
					,'<spring:message code="confirm.common.update" />'
					,function() {
						$("#df_method_nm").val("updateLqttEmail");
	        			
	            		form.submit();
					});
				</c:if>
			}
		});
		
		// 확인
		$("#btn_ok").click(function() {
			if(CKEDITOR.instances.ad_email_cn.getData() == "") {
				jsWarningBox(Message.template.required("메일내용"));
				return;
			}
			
			$("#dataForm").submit();
		});
		
		// 취소
		$("#btn_cancel").click(function() {
			$("#df_method_nm").val("");
			document.dataForm.submit();
		});
	});
</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />

		<input type="hidden" name="ad_lqtt_email_id" id="ad_lqtt_email_id" value="${dataMap.LQTT_EMAIL_ID}" />
		<input type="hidden" name="ad_form_type" id="ad_form_type" value="${formType}" />

		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title">대량메일등록및수정</h2>
					<!-- 타이틀 영역 //-->
					<!--// table -->
					<div class="block">
						<!-- 공통 입력 사항 -->
						<h3 class="mgt30">
							<span>항목은 입력 필수 항목 입니다.</span>
						</h3>
						<table cellpadding="0" cellspacing="0" class="table_basic" summary="대량메일관리 입력">
							<caption>대량메일관리 입력</caption>
							<colgroup>
								<col width="25%" />
								<col width="*" />
							</colgroup>
							<c:if test="${formType == 'INSERT'}">
								<tr>
									<th scope="row" class="point"><label for="ad_email_sj">메일제목</label></th>
									<td>
										<input name="ad_email_sj" type="text" id="ad_email_sj" class="text" placeholder="메일제목을 입력해 주세요." onfocus="this.placeholder=''; return true" style="width: 395px;" />
									</td>
								</tr>
								<tr>
									<th scope="row" class="point"><label for="ad_email_cn">메일내용</label></th>
									<td>
										<textarea name="ad_email_cn" id="ad_email_cn" rows="15" class="w99_p" title="메일내용을 입력해주세요"></textarea>
										<script type="text/javascript">
											//<![CDATA[
											CKEDITOR.replace('ad_email_cn', {
												height : 200,
												enterMode : "2",
												filebrowserUploadUrl : "/PGSO0120.do?df_method_nm=processUploadEditor"
											});
											//]]>
										</script>
									</td>
								</tr>
							</c:if>
							<c:if test="${formType == 'UPDATE'}">
								<tr>
									<th scope="row" class="point"><label for="ad_email_sj">메일제목</label></th>
									<td>
										<input name="ad_email_sj" type="text" id="ad_email_sj" class="text" placeholder="메일제목을 입력해 주세요." onfocus="this.placeholder=''; return true" style="width: 395px;"
											value="${dataMap.EMAIL_SJ}" />
									</td>
								</tr>
								<tr>
									<th scope="row" class="point"><label for="ad_email_cn">메일내용</label></th>
									<td>
										<textarea name="ad_email_cn" id="ad_email_cn" rows="15" class="w99_p" title="메일내용을 입력해주세요">${dataMap.EMAIL_CN}</textarea>
										<script type="text/javascript">
											//<![CDATA[
											CKEDITOR.replace('ad_email_cn', {
												height : 200,
												enterMode : "2",
												filebrowserUploadUrl : "/PGSO0120.do?df_method_nm=processUploadEditor"
											});
											//]]>
										</script>
									</td>
								</tr>
							</c:if>
						</table>
						<!--table //-->

						<!--//버튼-->
						<div class="btn_page_last">
							<a class="btn_page_admin" href="#" id="btn_cancel"><span>취소</span></a>
							<a class="btn_page_admin" href="#" id="btn_ok"><span>확인</span></a>
						</div>
						<!--버튼//-->
					</div>
				</div>
				<!--content//-->
			</div>
		</div>
	</form>
</body>
</html>