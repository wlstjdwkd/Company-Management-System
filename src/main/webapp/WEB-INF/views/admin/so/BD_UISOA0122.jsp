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

<script type="text/javascript">
	$(document).ready(function() {
		<c:if test="${resultMsg != null}">
			$(function() {
				jsMsgBox(null, "info", "${resultMsg}");
			});
		</c:if>
		
		// 메일내용 HTML 형식으로 넣기
		$("#emailCnHtml").html($("#email_cn_html").val());
		
		// 목록
		$("#btn_list").click(function() {
			$("#df_method_nm").val("");
			document.dataForm.submit();
		});
		
		// 삭제
		$("#btn_delete").click(function() {
			jsMsgBox(null, 'confirm'
			,'<spring:message code="fail.common.custom" arguments="해당메일 수신자 목록도 함께 삭제됩니다." /> <spring:message code="confirm.common.delete" />'
			,function() {
				$("#df_method_nm").val("deleteLqttEmail");
				document.dataForm.submit();
			});
		});
		
		// 수정
		$("#btn_update").click(function() {
			$("#df_method_nm").val("lqttEmailWriteForm");
			$("#ad_form_type").val("UPDATE");
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
		<input type="hidden" name="ad_form_type" id="ad_form_type" value="UPDATE" />
		
		<input type="hidden" id="email_cn_html" value="${dataMap.EMAIL_CN}" />
		
		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title">대량메일상세조회</h2>
					<!-- 타이틀 영역 //-->
					<!--// table -->
					<div class="block">
						<table cellpadding="0" cellspacing="0" class="table_basic" summary="대량메일관리 정보">
							<caption>대량메일관리 정보</caption>
							<colgroup>
								<col width="25%" />
								<col width="*" />
							</colgroup>
							<tr>
								<th scope="row"><label>메일제목</label></th>
								<td>${dataMap.EMAIL_SJ}</td>
							</tr>
							<tr>
								<th scope="row"><label>메일내용</label></th>
								<td id="emailCnHtml"></td>
							</tr>
						</table>
						<!--table //-->

						<!--//버튼-->
						<div class="btn_page_last">
							<a class="btn_page_admin" href="#" id="btn_list"><span>목록</span></a>
							<a class="btn_page_admin" href="#" id="btn_delete"><span>삭제</span></a>
							<a class="btn_page_admin" href="#" id="btn_update"><span>수정</span></a>
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