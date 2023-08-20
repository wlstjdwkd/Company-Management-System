<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>석유관리원 환급시스템</title>

<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javascript">

	$(document).ready(function() {
		// 취소
		$("#btn_cancel").on('click', function() {
			getList();
		});

		// 유효성 검사
		$("#dataForm").validate({
			rules: {
				deptCd : {
					required: true
				},
				deptNm : {
					required: true
				},
				deptLevel : {
					required: true,
					number: true
				},
				useAt : {
					required: true
				}
			},
			submitHandler: function(form) {
				$("#dataForm").ajaxSubmit({
					url      : "PGMS0170.do",
					dataType : "text",
					async    : true,
					success  : function(response) {
						try {
							response = $.parseJSON(response)
							if(response.result) {
								jsMsgBox(null, "info", response.message, getList);
							} else {
								jsMsgBox(null, "info", response.message);
							}
						} catch(e) {
							if(response != null) {
			                	jsSysErrorBox(response);
			                } else {
			                    jsSysErrorBox(e);
			                }
			                return;
						}
					}
				})
			}
		});

		// 등록 or 수정
		$("#btn_update").on('click', function() {
			jsMsgBox(null, "confirm", "저장하시겠습니까?",
					function() {
						$("#df_method_nm").val("updateOrInsertDept");
						$("#dataForm").submit();
					}
			);
		});
	});

	function getList() {
		var form = document.dataForm;
		form.df_method_nm.value = "";
		form.submit();
	}

	// 등록 or 수정
	function btn_update() {
		$("#dataForm").submit();
	}

</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />

		<input type="hidden" name="registOrUpdate" id="registOrUpdate" value="${registOrUpdate}"/>
		<input type="hidden" name="originDeptCd" id="originDeptCd" value="${deptCd}"/>

   		<!--//content-->
	    <div id="wrap">
	        <div class="wrap_inn">
	            <div class="contents">
	                <!--// 타이틀 영역 -->
	                <div class="r_top">
	                	<h2>${title}</h2>
	                </div>
	                <!-- 타이틀 영역 //-->
	                <div class="block" style="margin-top: 20px;">
						<!-- // 리스트 영역 -->
						<div class="list_zone">
							<h5 style="text-align: right;">
								<font color="#ff0000">* </font>항목은 필수 입력 항목 입니다.
							</h5>
							<table cellspacing="0" border="0" summary="부서 관리 리스트">
								<caption>부서 등록/수정</caption>
								<colgroup>
									<col width="15%" />
									<col width="*" />
								</colgroup>
								<thead>
									<tr>
										<td class="td_grey"><font color="#ff0000">* </font>부서 코드</td>
										<td class="tal"><input type="text" class="require" name="deptCd" id="deptCd" value="${deptInfo.deptCd}" style="width: 20%;" maxlength="6" /></td>
									</tr>
									<tr>
										<td class="td_grey"><font color="#ff0000">* </font>부서 이름</td>
										<td class="tal"><input type="text" class="require" name="deptNm" id="deptNm" value="${deptInfo.deptNm}" style="width: 20%;" /></td>
									</tr>
									<tr>
										<td class="td_grey"><font color="#ff0000">* </font>부서 레벨</td>
										<td class="tal"><input type="text" class="require" name="deptLevel" id="deptLevel" value="${deptInfo.deptLevel}" style="width: 20%;" maxlength="3" /></td>
									</tr>
									<tr>
										<td class="td_grey">상위부서 이름</td>
										<td class="tal">
											<select name="udeptCd" id="udeptCd" style="width: 21%;">
												<option value="">-선택-</option>
												<c:forEach items="${deptAllList}" var="dept" varStatus="status">
													<option value="${dept.deptCd}" <c:if test="${dept.deptCd eq deptInfo.udeptCd}">selected</c:if> >
														${dept.deptNm}
													</option>
												</c:forEach>
											</select>
										</td>
									</tr>
									<tr>
										<td class="td_grey"><font color="#ff0000">* </font>사용 여부</td>
										<td class="tal">
											<select class="require" name="useAt" id="useAt">
												<option value="Y" <c:if test="${deptInfo.useAt eq 'Y'}">selected</c:if> >Y</option>
												<option value="N" <c:if test="${deptInfo.useAt eq 'N'}">selected</c:if> >N</option>
											</select>
										</td>
									</tr>
								</thead>
								<tbody>
								</tbody>
							</table>
						</div>
						<div class="btn_page_last">
							<a class="btn_page_admin" href="#none" id="btn_cancel"><span>취소</span></a>
							<a class="btn_page_admin" href="#none" id="btn_update"><span>${button}</span></a>
						</div>
					</div>
	                <!-- 리스트영역 // -->
	            </div>
	        </div>
	        <!--content//-->
		</div>
	</form>
</body>
</html>