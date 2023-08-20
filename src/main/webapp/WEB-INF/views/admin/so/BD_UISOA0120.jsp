<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>정보</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,colorboxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javascript">
	<c:if test="${resultMsg != null}">
		$(function() {
			jsMsgBox(null, "info", "${resultMsg}");
		});
	</c:if>
	
	// 검색단어 입력 후 엔터 시 자동 submit
	function press(event) {
		if(event.keyCode == 13) {
			event.preventDefault();
			fn_search_LqttEmailInfo();
		}
	}
	
	// 검색 함수
	function fn_search_LqttEmailInfo() {
		var form = document.dataForm;
		
		if(form.search_word.value != "" && form.search_type.value == "") {
			jsMsgBox(form.search_type, 'error', Message.template.required('검색구분'));
			return false;
		}
		
		form.action = "<c:url value='${svcUrl}' />";
		form.df_curr_page.value = 1;
		form.df_method_nm.value = "";
		form.submit();
	}
	
	// 등록 버튼
	function fn_lqttEmailWriteForm() {
		var form = document.dataForm;
		form.action = "<c:url value='${svcUrl}' />";
		form.df_method_nm.value = "lqttEmailWriteForm";
		form.submit();
	}
	
	// 상세보기
	function fn_lqttEmailDetail(lottEmailId) {
		var form = document.dataForm;
		form.action = "<c:url value='${svcUrl}' />";
		form.ad_lqtt_email_id.value = lottEmailId;
		form.df_method_nm.value = "lqttEmailDetail";
		form.submit();
	}
	
	// 메일 버튼
	function fn_lqttEmailRcverListPopup(lottEmailId) {
		$.colorbox({
			title : "메일발송설정",
			href : "/PGSO0120.do?df_method_nm=lqttEmailRcverListPopup&ad_lqtt_email_id="+lottEmailId,
			width : "1024",
			height : "700",
			overlayClose : false,
			escKey : false,
			iframe : true
		});
	}
</script>
</head>
<body>
	<div id="wrap">
		<div class="wrap_inn">
			<div class="contents">
				<!--// 타이틀 영역 -->
				<h2 class="menu_title">대량메일관리</h2>
				<!-- 타이틀 영역 //-->
				<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl }'/>" method="post">
					<ap:include page="param/defaultParam.jsp" />
					<ap:include page="param/dispParam.jsp" />
					<ap:include page="param/pagingParam.jsp" />
					
					<input type="hidden" name="ad_lqtt_email_id" id="ad_lqtt_email_id" value="" />
					
					<!--// 검색 조건 -->
					<div class="search_top">
						<table cellpadding="0" cellspacing="0" class="table_search" summary="검색">
							<caption>검색</caption>
							<colgroup>
								<col width="100%" />
							</colgroup>
							<tr>
								<td class="only">
									<select name="search_type" class="select" style="width:150px;" title="검색조건선택">
										<option value=''>선택하세요</option>
										<option value='EMAIL_SJ' <c:if test="${param.search_type == 'EMAIL_SJ'}">selected</c:if>>메일제목</option>
										<option value='REGISTER' <c:if test="${param.search_type == 'REGISTER'}">selected</c:if>>등록자</option>
									</select>
									<input name="search_word" type="text" style="width: 300px;" value="${param.search_word}" title="검색어 입력" placeholder="검색어를 입력하세요." maxlength="35" onkeypress="press(event);" />
									<p class="btn_src_zone">
										<a href="#none" class="btn_search" onclick="fn_search_LqttEmailInfo();">검색</a>
									</p>
								</td>
							</tr>
						</table>
					</div>
					<div class="block2">
						<ap:pagerParam />
						<!--// 리스트 -->
						<div class="list_zone">
							<table cellspacing="0" border="0" summary="메일제목, 등록자, 등록일, 메일 리스트">
								<caption>대량메일관리 리스트</caption>
								<colgroup>
									<col width="*" />
									<col width="*" />
									<col width="*" />
									<col width="*" />
									<col width="*" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col">번호</th>
										<th scope="col">메일제목</th>
										<th scope="col">등록자</th>
										<th scope="col">등록일</th>
										<th scope="col">메일</th>
									</tr>
								</thead>
								<tbody>
									<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
									<c:if test="${fn:length(resultList) == 0}">
										<tr>
											<td colspan="5">
												<c:if test="${param.search_word == null or param.search_word == '' }">
													<spring:message code="info.nodata.msg" />
												</c:if>
												<c:if test="${param.search_word != null and param.search_word != '' }">
													<spring:message code="info.noresult.msg" />
												</c:if>
											</td>
										</tr>
									</c:if>
									<%-- 데이터를 화면에 출력해준다 --%>
									<c:forEach items="${resultList}" var="resultInfo" varStatus="status">
										<tr>
											<td>${pager.indexNo-status.index}</td>
											<td class="tal">
												<a href="#none" onclick="fn_lqttEmailDetail('${resultInfo.LQTT_EMAIL_ID}');">
													<c:out value="${resultInfo.EMAIL_SJ}" />
												</a>
											</td>
											<td>${resultInfo.REGISTER_NM}</td>
											<td>${fn:substring(resultInfo.RGSDE, 0, 10)}</td>
											<td>
												<div class="btn_inner">
													<a href="#none" class="btn_in_gray" onclick="fn_lqttEmailRcverListPopup('${resultInfo.LQTT_EMAIL_ID}');"><span>설정</span></a>
												</div>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<!-- 리스트// -->
						<div class="btn_page_last">
							<a class="btn_page_admin" href="#none" onclick="fn_lqttEmailWriteForm();"><span>등록</span></a>
						</div>
						<ap:pager pager="${pager}" />
					</div>
				</form>
			</div>
			<!--content//-->
		</div>
	</div>
</body>
</html>
