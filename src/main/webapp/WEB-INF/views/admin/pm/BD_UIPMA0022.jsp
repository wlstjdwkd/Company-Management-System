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
		var useAtCheck = "${payItemInfo.useYn}";
		var upItm = "${payItemInfo.upItmCd}";
		
		//최상위 항목이면 "root"로 표시
		if(upItm == "0") {
			document.getElementById("ad_itmNm").value = "root";
		}
		
		// 사용여부
		if(useAtCheck == "Y") { 
			document.getElementById("ad_useYn").checked = true;
			
			// 사용여부 라디오버튼 비활성화
			//document.getElementById("ad_useYn").disabled = true;
			document.getElementById("ad_useYn_reject").disabled = true;
		}
		else {
			document.getElementById("ad_useYn_reject").checked = true;
		}
	
		// 유효성 검사
		$("#dataForm").validate({
			rules : {// 급여항목코드  				
				ad_payItmCd : {
					required : true,
					min:100000000,	// 급여항목코드는 9자리의 자연수 (자릿수는 홀수)
					max:999999999,
					digits: true
				},// 급여항목명
				ad_payItmNm : {
					required : true,
					maxlength: 50
				},// 사용여부
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
				if ($("#ad_payItmCd").val() != parseInt($("#ad_payItmCd").val())
				 || $("#ad_itmSeq").val() != parseInt($("#ad_itmSeq").val()) ) {	//정수인지 확인
					jsMsgBox($(this), "error", Message.msg.outptOrdrInteger);
					return;
				}
				
				form.submit();
			}
		});
		
		// 확인
		$("#btn_update").click(function() {
			jsMsgBox(null, 'confirm','<spring:message code="confirm.common.save" />', function(){
				$("#df_method_nm").val("processPayItem"); $("#dataForm").submit();});
		});
		
		// 삭제
		$("#btn_delete").click(function() {
			jsMsgBox(null, 'confirm','<spring:message code="confirm.common.delete" />',function(){
				$("#df_method_nm").val("deletePayItem"); $("#dataForm").submit();});
		});
		
		// 취소
		$("#btn_get_list").click(function() {
			$("#df_method_nm").val("index");
			$("#searchSiteSe").val("");
			$("#searchMenuNm").val("");
			
			document.dataForm.submit();
		});
		
		// 상위항목 찾기
		$("#popParntsItem").click(function() {
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
		<input type="hidden" name="ad_insert_update" id="ad_insert_update" value="UPDATE" />
		
		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title_line">급여 항목 수정</h2>
					<!-- 타이틀 영역 //-->
					<div class="block">
						<h3 class="mgt30">
							<span>항목은 입력 필수 항목 입니다.</span>
						</h3>
						<!--// 수정 -->
						<table cellpadding="0" cellspacing="0" class="table_basic mgt10" summary="">
							<caption></caption>
							<colgroup>
								<col width="15%" />
								<col width="*" />
							</colgroup>
							<tr>
								<th scope="row" class="point">급여항목코드</th>
								<td><input name="ad_payItmCd" title="입력" id="ad_payItmCd" type="text"
									 style="width: 762px; background-color: #aaa5;" value="${payItemInfo.payItmCd}" readonly/></td>
							</tr>
							<tr>
								<th scope="row" class="point"><label for="info21"> 급여항목명</label></th>
								<td><input name="ad_payItmNm" title="입력" id="ad_payItmNm" type="text"
									 style="width: 762px" value="${payItemInfo.payItmNm}"/></td>
							</tr>
							<tr>
								<th scope="row">상위항목코드</th>
								<td><input name="ad_itmCd" title="입력" id="ad_itmCd" type="text" 
									 style="width: 100px; background-color: #aaa5;" value="${payItemInfo.upItmCd}" readonly/>
									<input name="ad_itmNm" title="입력" id="ad_itmNm" type="text" 
									 style="width: 100px; background-color: #aaa5;" value="${upItemInfo.payItmNm}" readonly/>
									<div class="btn_inner">
										<a href="#none" class="btn_in_gray"><span id="popParntsItem">선택</span></a>
									</div></td>
							</tr>
							<tr>
								<th scope="row" class="point">항목순번</th>
								<td><input name="ad_itmSeq" title="입력" id="ad_itmSeq" type="text"
									 style="width: 762px" value="${payItemInfo.itmSeq}"/></td>
							</tr>
							<tr>
								<th scope="row" class="point">사용여부</th>
								<td><input name="ad_useYn" type="radio" id="ad_useYn" value="Y" /> <label
									 for="ad_useYn" class="mgr30">사용함</label> <input name="ad_useYn" type="radio"
									 id="ad_useYn_reject" value="N" class="ml85" /> <label for="ad_useYn_reject">사용안함</label></td>
							</tr>
							<tr>
								<th scope="row">비고</th>
								<td><input name="ad_rmrk" title="입력" id="ad_rmrk" type="text" style="width: 762px"
									 value="${payItemInfo.rmrk}" /></td>
							</tr>
						</table>
					</div>
					
					<!-- 수정// -->
					<div class="btn_page_last">
						<a class="btn_page_admin" id="btn_get_list" href="#none"><span>취소</span></a>
						<a class="btn_page_admin" id="btn_delete" href="#none"><span>삭제</span></a> 
						<a class="btn_page_admin" id="btn_update" href="#none"><span>확인</span></a>
					</div>
					
				</div>
			</div>
			<!--content//-->
		</div>
	</form>
</body>
</html>