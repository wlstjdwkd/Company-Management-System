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
<title>정보마당</title>
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javascript">
	$(document).ready(function() {
		// 유효성 검사
		$("#dataForm").validate({
			rules : {
				// 급여항목명
				ad_payItmNm : {
					required : true,
					maxlength: 50
				},
				// 사용여부
				ad_useYn : {
					required : true
				}
			},
			submitHandler : function(form) {
				// 필수값체크
				if ($("#ad_payItmNm").val() == "") {
					jsMsgBox($("#btn_insert_menu"), "error", Message.template.required('프로그램'));
					return;
				}
				
				form.submit();
			}
		});
		
		// 확인
		$("#btn_insert_payItem").click(function() {
			jsMsgBox(null, 'confirm','<spring:message code="confirm.common.save" />', function(){
				$("#df_method_nm").val("processPayItem");
				$("#dataForm").submit();});
		});
		
		// 취소
		$("#btn_get_list").click(function() {
			$("#df_method_nm").val("index");
			$("#searchSiteSe").val("");
			$("#searchMenuNm").val("");
			
			document.dataForm.submit();
		});
		
		// 상위항목 찾기
		$("#popParentsItem").click(function() {
			$.colorbox({
				title : "상위 급여 항목 찾기",
				href : "PGPM0020.do?df_method_nm=goPayItemList",		
				width : "60%",
				height : "70%",
				overlayClose : false,
				escKey : false,
				iframe : true
			});
		});
	});

</script>
</head>

<body>
	<form name="dataForm" id="dataForm" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />

		<input type="hidden" name="ad_programId" id="ad_programId" /> 
		<input type="hidden" name="ad_menuLevel" id="ad_menuLevel" /> 
		<input type="hidden" name="ad_parntsMenuNo" id="ad_parntsMenuNo" />
		<input type="hidden" name="ad_lastNodeAt" id="ad_lastNodeAt" value="Y" />
		<input type="hidden" name="ad_menuLevelCheck" id="ad_menuLevelCheck" value="check" /> 
		<input type="hidden" name="ad_insert_update" id="ad_insert_update" value="INSERT" />
		
		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title_line">급여 항목 등록</h2>
					
					<p> 최상위 항목을 입력하는 경우 '상위항목코드'를 선택하지 않으면 됩니다. </p>
					
					<!-- 타이틀 영역 //-->
					<div class="block">
						<h3 class="mgt30">
							<span>항목은 입력 필수 항목 입니다.</span>
						</h3>
						<!--// 등록 -->
						<table cellpadding="0" cellspacing="0" class="table_basic mgt10" summary="">
							<caption></caption>
							<colgroup>
								<col width="15%" />
								<col width="*" />
							</colgroup>
							<tr>
								<th scope="row" class="point"><label for="info21"> 급여항목명</label></th>
								<td><input name="ad_payItmNm" title="입력" id="ad_payItmNm" type="text" style="width: 762px" /></td>
							</tr>
							<tr>
								<th scope="row">상위항목코드</th>
								<td><input name="ad_itmCd" title="입력" id="ad_itmCd" type="text" 
									 style="width: 100px; background-color: #aaa5;" readonly/>
									<input name="ad_itmNm" title="입력" id="ad_itmNm" type="text" 
									 style="width: 100px; background-color: #aaa5;" readonly/>
									<div class="btn_inner">
										<a href="#none" class="btn_in_gray"><span id="popParentsItem">선택</span></a>
									</div></td>
							</tr>
							<tr>
								<th scope="row">비고</th>
								<td><input name="ad_rmrk" title="입력" id="ad_rmrk" type="text" style="width: 762px" /></td>
							</tr>
						</table>
					</div>
					
					<!-- 등록// -->
					<div class="btn_page_last">
						<a class="btn_page_admin" href="#none" id="btn_get_list"><span>취소</span></a> <a
						   class="btn_page_admin" id="btn_insert_payItem" href="#none"><span>확인</span></a>
					</div>
					
				</div>
			</div>
			<!--content//-->
		</div>
	</form>
</body>
</html>