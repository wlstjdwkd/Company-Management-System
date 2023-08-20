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
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox" />
<ap:jsTag type="tech" items="msg,util,ucm,my" />

<script type="text/javascript">
	$(document).ready(function() {

	});

	var fn_empmn_info = function(empmnNo) {
		$("#ad_empmn_manage_no").val(empmnNo);
		$("#df_method_nm").val("empmnInfoView");

		var empmnInfoWindow = window.open('', 'empmnInfo', 'width=900, height=680, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbars=yes');
		document.dataForm.action = "/PGCS0070.do";
		document.dataForm.target = "empmnInfo";
		document.dataForm.submit();
		document.dataForm.target = "";
		if (empmnInfoWindow) {
			empmnInfoWindow.focus();
		}
	};

	var fn_apply_view = function(empmnNo) {
		$("#ad_empmn_manage_no").val(empmnNo);
		$("#df_method_nm").val("applyInfoView");

		var empmnInfoWindow = window.open('', 'empmnInfo', 'width=1400, height=680, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbars=yes');
		document.dataForm.action = "/PGMY0020.do";
		document.dataForm.target = "empmnInfo";
		document.dataForm.submit();
		document.dataForm.target = "";
		if (empmnInfoWindow) {
			empmnInfoWindow.focus();
		}
	};
</script>

</head>

<body>

	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">

		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />

		<input type="hidden" id="ad_empmn_manage_no" name="ad_empmn_manage_no" />

		<!--//content-->
		<div id="wrap" class="top_bg">
			<div class="contents">
				<!--//top img-->
				<div class="top_img menu01">High Potential Enterprise Support. 대한민국 기업을 지원합니다.</div>
				<!--top img //-->
				<!--// lnb 페이지 타이틀-->
				<div class="title_page">
					<h2>
						<img src="<c:url value="/images/my/title_m1.png"/>" alt="마이페이지" />
					</h2>
				</div>
				<!--lnb 페이지 타이틀//-->
				<div id="go_container">
					<!--//우측영역 -->
					<div class="rcont">
						<!--//sub contents -->
						<div class="sub_cont">
							<ap:trail menuNo="${param.df_menu_no}" />

							<div class="my_info">
								<p>입사지원하신 채용정보 목록입니다. 좋은 결과 있으시길 바랍니다.</p>
								<ul class="def">
									<li>채용기업을 클릭하시면 해당 채용정보를 확인하실 수 있습니다.</li>
									<li>‘지원서제목을 클릭하시면 작성하신 입사지원신청서를 확인하실 수 있습니다.<br /> 채용마감 전인 경우 입사지원신청서를 수정하실 수 있으나,
										마감일이 지난 경우 수정이 불가 합니다.
									</li>
								</ul>
								<!--// 리스트 -->
								<div class="list_zone">
									<table>
										<caption>기본게시판 목록</caption>
										<colgroup>
											<col style="width:*"/>
											<col style="width:*"/>
											<col style="width:*"/>
											<col style="width:*"/>
											<col style="width:*"/>
											<col style="width:*"/>
										</colgroup>
										<thead>
											<tr>
												<th scope="col">접수여부</th>
												<th scope="col">채용기업</th>
												<th scope="col">지원서</th>
												<th scope="col">직종</th>
												<th scope="col">채용기간</th>
												<th scope="col">입사지원일</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach items="${applyList }" var="apply" varStatus="status">
												<tr>
													<td><c:choose>
															<c:when test="${apply.RCEPT_AT == 'Y' }">접수</c:when>
															<c:otherwise>임시저장</c:otherwise>
														</c:choose></td>
													<td class="tal"><a href="#none"
														onclick="fn_empmn_info('${apply.EMPMN_MANAGE_NO}')"> ${apply.ENTRPRS_NM } </a></td>
													<td class="tal"><a href="#none"
														onclick="fn_apply_view('${apply.EMPMN_MANAGE_NO}')"> <c:if
																test="${empty apply.APPLY_SJ }">제목없음</c:if> ${apply.APPLY_SJ }
													</a></td>
													<td>${apply.JSSFC }</td>
													<td>${apply.RCRIT_BEGIN_DE }~ ${apply.RCRIT_END_DE }</td>
													<td>${apply.RCEPT_DE }</td>
												</tr>
											</c:forEach>
										</tbody>
									</table>
								</div>
								<!-- 리스트// -->

								<!--// paginate -->
								<ap:pager pager="${pager}" />
								<!-- paginate //-->

							</div>
						</div>
						<!--sub contents //-->
					</div>
					<!-- 우측영역//-->
				</div>
			</div>
		</div>
		<!--content//-->
	</form>
</body>
</html>