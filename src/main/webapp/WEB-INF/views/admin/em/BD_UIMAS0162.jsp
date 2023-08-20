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
	
	$(document)
			.ready(
					function() {
				
						// 목록
						$("#btn_progrm_list").click(function() {
							history.back();
						});
						// 삭제
						$("#btn_progrm_reset")
								.click(
										function() {
											jsMsgBox(
													null,
													'confirm',
													'<spring:message code="confirm.common.delete"/>',
													function() {
														$("#df_method_nm").val(
																"deleteProgrm");
														document.dataForm
																.submit();
													});
										});
						// 수정
						$("#btn_progrm_insert")
								.click(
										function() {
											jsMsgBox(
													null,
													'confirm',
													'<spring:message code="confirm.common.save" />',
													function() {
														
														$("#df_method_nm")
																.val(
																		"processProgrm");
														$("#dataForm").submit();
													});
										});
					});
	
	//달력
	$(document).ready(function() {
   		
    	initDatepicker();
    											//	https://api.jqueryui.com/datepicker/
    	function initDatepicker() {
    		$('.datepicker').datepicker({
    			showOn : 'button',						//버튼을 눌러서 출력
    			buttonImage : '<c:url value='/images/acm/icon_cal.png' />',	//이미지 링크
    			buttonImageOnly : true,
    			changeYear : true,
    			changeMonth : true,
    			yearRange : '2000:2030' 					//2000-2030 까지만 선택 가능
    		});
    		$('.datepicker').mask('0000-00-00'); 		// '0000-00-00'를 숨기기
    		
    		$('#start_dt').datepicker(
    			'setDate',
    			Util.isEmpty($('#start_dt').val()) ? new Date() : $('#start_dt').val()
    		);
    		
    	}
    });
</script>
</head>

<body>
	<form name="dataForm" id="dataForm" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />

		<input type="hidden" name="insert_update" id="insert_update" value="UPDATE" /> 
		<input type="hidden" name="df_curr_page" id="df_curr_page" value="${indexValue.df_curr_page}"> 
		<input type="hidden" name="df_row_per_page" id="df_row_per_page" value="${indexValue.df_row_per_page}">
		

		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title_line">정보 수정/삭제</h2>
					<!-- 타이틀 영역 //-->
					<div class="block">
						<h3 class="mgt30">
							<span>항목은 입력 필수 항목 입니다.</span>
						</h3>
						<!--// 등록 -->
						<table cellpadding="0" cellspacing="0" class="table_basic mgt10" summary="프로그램등록">
							<caption>프로그램등록</caption>
							<colgroup>
								<col width="15%" />
								<col width="30%" />
								<col width="15%" />

								<col width="*" />
							</colgroup>
							
							<tr>
								<th scope="row" class="point">사원번호</th>
								<td><input id="ad_PK" name="ad_PK" title="입력" type="text"
										 style="width: 250px" value = "${userInfo.PK}" /></td>
								<th scope="row" class="point">이름</th>
								<td><input id="ad_name" name="ad_name" title="입력" type="text"
										 style="width: 250px" value = "${userInfo.name}" /></td>
							</tr>
							<tr>
								<th scope="row" class="point">직급</th>
								<td><input name="ad_rank" id="ad_rank" title="입력" type="text" 
									style="width: 250px" value = "${userInfo.rank}" /></td>
								<th scope="row" class="point">주민번호</th>
								<td><input name="ad_ss" id="ad_ss" title="입력" type="text" 
									style="width: 250px" placeholder="000000-0000000" value = "${userInfo.ssnum}" /></td>
							</tr>

							<tr>
								<th scope="row" class="point">결제은행</th>
								<td><input name="ad_bank" title="입력" id="ad_bank" type="text"
									style="width: 250px" value = "${userInfo.bank}" /></td>
								<th scope="row" class="point">결제계좌</th>
								<td><input name="ad_banknum" title="입력" id="ad_banknum" type="text"
									style="width: 250px" value = "${userInfo.banknum}" /></td>
							</tr>
							<tr>
								<th scope="row" class="point">입사일</th>
								<td><input type="text" id="start_dt" name="start_dt" class="datepicker" style="width:100px;" value = "${userInfo.indate}" /></td>
								<th scope="row" class="point">전화번호</th>
								<td><input name="ad_tel" title="입력" id="ad_tel" type="text"
									style="width: 250px" placeholder="010-0000-0000" value = "${userInfo.tel}" /></td>
							</tr>
							<tr>
								<th scope="row">개인메일</th>
								<td><input name="ad_pmail" title="입력" id="ad_pmail" type="text"
									style="width: 250px" value = "${userInfo.pmail}" /></td>
								<th scope="row" class="point">회사메일</th>
								<td><input name="ad_cmail" title="입력" id="ad_cmail" type="text"
									style="width: 250px" value = "${userInfo.cmail}" /></td>	
							</tr>
							<tr>
								<th scope="row" class="point">주소</th>
								<td colspan="2"><input name="ad_add" title="입력" id="ad_add" type="text" style="width: 600px" value = "${userInfo.address}" /></td>
							</tr>
							
						</table>
					</div>
					<div class="block">
					<!-- 리스트// -->
						<div class="btn_page_last">
							<a class="btn_page_admin" href="#" id="btn_progrm_list"><span>목록</span></a> 
								<a class="btn_page_admin" href="#" id="btn_progrm_reset"><span>삭제</span></a> 
								<a class="btn_page_admin" href="#" id="btn_progrm_insert"><span>수정</span></a>
						</div>
					</div>
					<!--리스트영역 //-->
				</div>
			</div>
			<!--content//-->
		</div>
	</form>
</body>
</html>
