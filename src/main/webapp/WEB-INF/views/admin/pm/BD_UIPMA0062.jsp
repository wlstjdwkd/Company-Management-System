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
			rules : {// 급여항목코드  				
				ad_itmCd : {
					required : true,
					min:100000000,	// 급여항목코드는 9자리의 자연수 (자릿수는 홀수)
					max:999999999,
					digits : true
				},// 급여항목명
				ad_payItmNm : {
					required : true,
					maxlength: 50
				},// 세율
				ad_taxRate : {
					required : true,
					min : 0,  
					max : 100,		
					number : true,
				}
			},
			submitHandler : function(form) {
				// 필수값체크
				if ($("#ad_payItmNm").val() == "") {
					jsMsgBox($("#btn_insert_taxItem"), "error", Message.template.required('프로그램'));
					return;
				}
				if ($("#ad_itmCd").val() != parseInt($("#ad_itmCd").val())) {	//정수인지 확인
					jsMsgBox($(this), "error", Message.msg.outptOrdrInteger);
					return;
				}
				
				form.submit();
			}
		});
		
		//세율입력은 소수아래 7자리까지 허용
		//$(".ad_taxRate").number(true, 7);
		
		
		// 확인
		$("#btn_insert_taxItem").click(function() {
			jsMsgBox(null, 'confirm','<spring:message code="confirm.common.save" />', function(){
				$("#df_method_nm").val("processTaxItem"); $("#dataForm").submit();});
		});
		
		// 삭제
		$("#btn_delete").click(function() {
			jsMsgBox(null, 'confirm','<spring:message code="confirm.common.delete" />',function(){
				$("#df_method_nm").val("deleteTaxItem"); $("#dataForm").submit();});
		});
		
		// 취소
		$("#btn_get_list").click(function() {
			$("#df_method_nm").val("index");
			$("#searchSiteSe").val("");
			$("#searchMenuNm").val("");
			
			document.dataForm.submit();
		});
		
		// 참고항목 선택
		$("#popRefItem").click(function() {
			$.colorbox({
				title : "참고 항목 선택",
				href : "PGPM0060.do?df_method_nm=goRefItemList",		
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

		<input type="hidden" name="ad_insert_update" id="ad_insert_update" value="UPDATE" />
		
		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title_line">급여 항목 등록</h2>
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
								<th scope="row" class="point">급여항목</th>
								<td><input name="ad_itmCd" title="입력" id="ad_itmCd" type="text" 
									 style="width: 100px; background-color: #aaa5;" value="${taxInfo.payItmCd}" readonly/>
									<input name="ad_itmNm" title="입력" id="ad_itmNm" type="text" 
									 style="width: 100px; background-color: #aaa5;" value="${taxInfo.payItmNm}" readonly/>
								</td>
							</tr>
							<tr>
								<th scope="row" class="point">참고항목</th>
								<td><input name="ad_refItmCd" title="입력" id="ad_refItmCd" type="text" 
									 style="width: 100px; background-color: #aaa5;" value="${taxInfo.refItmCd}" readonly/>
									<input name="ad_refItmNm" title="입력" id="ad_refItmNm" type="text" 
									 style="width: 100px; background-color: #aaa5;" value="${taxInfo.refItmNm}" readonly/>
									<div class="btn_inner">
										<a href="#none" class="btn_in_gray"><span id="popRefItem">선택</span></a>
									</div></td>
							</tr>
							<tr>
								<th scope="row" class="point">세율(%)</th>
								<td><input class="ad_taxRate" name="ad_taxRate" title="입력" id="ad_taxRate" type="text"
									 style="width: 762px" value="${taxInfo.taxRate}" /> % </td>
							</tr>
							<tr>
								<th scope="row">비고</th>
								<td><input name="ad_rmrk" title="입력" id="ad_rmrk" type="text" style="width: 762px"
									 value="${taxInfo.rmrk}" /></td>
							</tr>
						</table>
					</div>
					
					<!-- 등록// -->
					<div class="btn_page_last">
						<a class="btn_page_admin" href="#none" id="btn_get_list"><span>취소</span></a> <a
						   class="btn_page_admin" id="btn_delete" href="#none"><span>삭제</span></a> <a
						   class="btn_page_admin" id="btn_insert_taxItem" href="#none"><span>확인</span></a>
					</div>
					
				</div>
			</div>
			<!--content//-->
		</div>
	</form>
</body>
</html>