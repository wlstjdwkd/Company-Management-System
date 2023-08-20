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
			rules : {// 사이트구분  				
				ad_siteSe : {
					required : true
				},// 메뉴명
				ad_menuNm : {
					required : true,
					maxlength: 50
				},// 출력유형
				ad_outptTy : {
					required : true
				},// 출력순서
				ad_outptOrdr : {
					required : true,
					min:1,
					max:999,
					number:true
				},// 출력여부
				ad_rcv_outptAt : {
					required : true
				},// 사용여부
				ad_rcv_useAt : {
					required : true
				},// URL
				ad_url : {
					maxlength: 1000
				}

			},
			submitHandler : function(form) {
				// 필수값체크
				if ($("#ad_programNm").val() == "") {
					jsMsgBox($("#btn_insert_menu"), "error", Message.template.required('프로그램'));
					return;
				}
				if ($("#ad_outptOrdr").val() != parseInt($("#ad_outptOrdr").val())) {
					jsMsgBox($(this), "error", Message.msg.outptOrdrNumber);
					return;
				}
				
				form.submit();
				}
		});
		// 확인
		$("#btn_insert_menu").click(function() {
			var ad_parntsMenuNm_check = $("#ad_parntsMenuNm").val();
	
			if(ad_parntsMenuNm_check == null || ad_parntsMenuNm_check == "") {
				$("#ad_parntsMenuNo").val("0");
				$("#ad_menuLevel").val("1");				
			}
			
			jsMsgBox(null, 'confirm','<spring:message code="confirm.common.save" />',function(){$("#df_method_nm").val("processMenu"); $("#dataForm").submit();});

		});
		
		// 취소
		$("#btn_menu_get_list").click(function() {
			$("#df_method_nm").val("index");
			$("#df_curr_page").val("1");
			$("#searchSiteSe").val("");
			$("#searchMenuNm").val("");
			
			
			document.dataForm.submit();
			
		});
		
		// 상위메뉴 찾기
		$("#popParntsMenu").click(function() {
			$("#pop_searchSiteSe").val($("#ad_siteSe").val());
			var pop_searchSiteSe = $("#pop_searchSiteSe").val();
			
			$.colorbox({
				title : "상위메뉴 찾기",
				href : "PGCMMENU0020.do?df_method_nm=getParntsMenuList&pop_searchSiteSe="+pop_searchSiteSe,		
				width : "70%",
				height : "75%",
				overlayClose : false,
				escKey : false,
				iframe : true
			});
		});
		
		// 프로그램 찾기
		$("#popFindProgram").click(function() {
			$.colorbox({
				title : "프로그램 찾기",
				href : "PGCMMENU0020.do?df_method_nm=getProgramList",
				width : "70%",
				height : "75%",
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
		<input 	type="hidden" name="ad_insert_update" id="ad_insert_update" value="INSERT" />
		
		<!-- 이전페이지 값 -->
		<input type="hidden" name="df_curr_page" id="df_curr_page" value="${param.df_curr_page}" /> <input
			type="hidden" name="df_row_per_page" id="df_row_per_page" value="${param.df_row_per_page}" /> <input
			type="hidden" name="limitFrom" id="limitFrom" value="${param.limitFrom}" /> <input type="hidden"
			name="limitTo" id="limitTo" value="${param.limitTo}" /> <input type="hidden" name="searchMenuNm"
			id="searchMenuNm" value="${param.searchMenuNm}" /> 
			<input type="hidden" name="searchSiteSe" id="searchSiteSe" value="${param.searchSiteSe}" />
			<input type="hidden" name="pop_searchSiteSe" id="pop_searchSiteSe" />
		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title_line">메뉴등록</h2>
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
								<th scope="row" class="point">사이트구분</th>
								<td><ap:code id="ad_siteSe" grpCd="1" type="select" selectedCd="${param.ad_siteSe}"
										defaultLabel="구분선택" /></td>
							</tr>
							<tr>
								<th scope="row" class="point"><label for="info21"> 메뉴명</label></th>
								<td><input name="ad_menuNm" title="입력" id="ad_menuNm" type="text" style="width: 762px" /></td>
							</tr>
							<tr>
								<th scope="row" class="point"><label for="info22"> 프로그램</label></th>
								<td><input name="ad_programNm" title="입력" id="ad_programNm" type="text"
									style="width: 712px" readonly="readonly" />
									<div class="btn_inner">
										<a href="#none" class="btn_in_gray"><span id="popFindProgram">찾기</span></a>
									</div></td>
							</tr>
							<tr>
								<th scope="row">상위메뉴</th>
								<td><input name="ad_parntsMenuNm" title="입력" id="ad_parntsMenuNm" type="text"
									style="width: 712px" readonly="readonly" />
									<div class="btn_inner">
										<a href="#none" class="btn_in_gray"><span id="popParntsMenu">찾기</span></a>
									</div></td>
							</tr>
							<tr>
								<th scope="row" class="point">출력유형</th>
								<td><ap:code id="ad_outptTy" grpCd="3" type="select" selectedCd="${param.ad_outptTy}" /></td>
							</tr>
							<tr>
								<th scope="row" class="point">출력순서</th>
								<td><input name="ad_outptOrdr" title="입력" id="ad_outptOrdr" type="text"
									style="width: 762px" /></td>
							</tr>
							<tr>
								<th scope="row">URL</th>
								<td><input name="ad_url" title="입력" id="ad_url" type="text" style="width: 762px" /></td>
							</tr>
							<tr>
								<th scope="row" class="point">출력여부</th>
								<td><input name="ad_rcv_outptAt" type="radio" id="ad_rcv_outptAt" value="Y" /><label
									for="ad_rcv_outptAt" class="mgr30"> 출력함</label> <input name="ad_rcv_outptAt" type="radio"
									id="ad_rcv_outptAt_reject" value="N" class="ml85" /><label for="ad_rcv_outptAt_reject">
										출력안함</label></td>
							</tr>
							<tr>
								<th scope="row" class="point">사용여부</th>
								<td><input name="ad_rcv_useAt" type="radio" id="ad_rcv_useAt" value="Y" /> <label
									for="ad_rcv_useAt" class="mgr30">사용함</label> <input name="ad_rcv_useAt" type="radio"
									id="ad_rcv_useAt_reject" value="N" class="ml85" /> <label for="ad_rcv_useAt_reject">사용안함</label></td>
							</tr>
						</table>
					</div>
					<!-- 등록// -->
					<div class="btn_page_last">
						<a class="btn_page_admin" href="#none" id="btn_menu_get_list"><span>취소</span></a> <a
							class="btn_page_admin" id="btn_insert_menu" href="#none"><span>확인</span></a>
					</div>
				</div>
			</div>
			<!--content//-->
		</div>
	</form>
</body>
</html>