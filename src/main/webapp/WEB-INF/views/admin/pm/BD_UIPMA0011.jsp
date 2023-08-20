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
<title>정보</title>
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,mask,msgBoxAdmin,colorboxAdmin,selectbox" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javascript">
	function readonly() {
		var t = document.dataForm;
		t.ad_viewFilePath.readOnly = true;
		t.ad_viewFilePath.value = "";
	}

	function readonly_re() {
		var t = document.dataForm;
		t.ad_viewFilePath.readOnly = false;
	}
	
	$(document).ready(function() {
		// 기간 범위
		$("#adjyr").numericOptions({from:1960, to:${frontParam.curr_year}, sort:"desc"});
		$("#adjmon").numericOptions({from:01, to:12, namePadding:2, valuePadding:2, sort:"asc"});
		$("#grayr").numericOptions({from:1960, to:${frontParam.curr_year}, sort:"desc"});
		$("#gramn").numericOptions({from:01, to:12, namePadding:2, valuePadding:2, sort:"asc"});
		
		//달력	
		$('.mobtel').mask('000-0000-0000');
		$('.cizno').mask('000000-0000000');
   		
    	initDatepicker();
    											//	https://api.jqueryui.com/datepicker/
    	function initDatepicker() {
    		$('.datepicker').datepicker({
    			showOn : 'button',						//버튼을 눌러서 출력
    			buttonImage : '<c:url value='/images/acm/icon_cal.png' />',	//이미지 링크
    			buttonImageOnly : true,
    			changeYear : true,
    			changeMonth : true,
    			yearRange : '1960:2030' 					//2000-2030 까지만 선택 가능
    		});
    		$('.datepicker').mask('0000-00-00'); 					// '0000-00-00'를 숨기기
    	}
    });
	
	$(document)
			.ready(
					function() {
						// 목록
						$("#btn_progrm_list").click(function() {
							history.back();
						});

						// 취소
						$("#btn_progrm_reset").click(function() {
							$("#dataForm").each(function() {
								this.reset();
							});
						});

						// 확인
						$("#btn_progrm_insert")
								.click(
										function() {
											var cizno = document.getElementById("cizno").value;
											cizno = cizno.substring(0,6) + cizno.substring(7);
											document.getElementById("cizno").value = cizno;
											
											var mobtel = document.getElementById("mobtel").value;
											mobtel = mobtel.substring(0,3) + mobtel.substring(4,8) + mobtel.substring(9);
											document.getElementById("mobtel").value = mobtel;
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
						
						// 근무형태 찾기
						$("#btn_workType").click(function() {
							$.colorbox({
								title : "근무 형태 찾기",
								href : "PGPM0010.do?df_method_nm=goWorkTypeList",	
								width : "40%",
								height : "70%",
								overlayClose : false,
								escKey : false,
								iframe : true
							});
						});
						
						//부서 검색
						$("#btn_department").click(function() {
							$.colorbox({
								title : "부서 검색",
								href : "PGPM0010.do?df_method_nm=goDepartmentList",
								width : "40%",
								height : "70%",
								overlayClose : false,
								escKey : false,
								iframe : true
							});
						});
						
						//직급 검색
						$("#btn_rank").click(function() {
							$.colorbox({
								title : "직급 검색",
								href : "PGPM0010.do?df_method_nm=goRankList",
								width : "40%",
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

		<input type="hidden" name="ad_menoNo" id="ad_menoNo" /> <input type="hidden" name="insert_update"
			id="insert_update" value="INSERT" />
		
		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title_line">직원 정보 등록</h2>
					<!-- 타이틀 영역 //-->
					<div class="block">
						<h3 class="mgt30">
							<span>항목은 입력 필수 항목 입니다.</span>
						</h3>
						<!--// 등록 -->
						<table cellpadding="0" cellspacing="0" class="table_basic mgt10" summary="프로그램등록">
							<caption>직원 정보 등록</caption>
							<colgroup>
								<col width="15%" />
								<col width="30%" />
								<col width="15%" />
								<col width="*" />
							</colgroup>
							<tr>
								<th scope="row" class="point">직원번호</th>
								<td><input id="empno" name="empno" title="입력" type="text" style="width: 250px" /></td>
								<th scope="row" class="point">이름</th>
								<td><input id="empnm" name="empnm" title="입력" type="text" style="width: 250px" /></td>
							</tr>
							<tr>
								<th scope="row" class="point">직급</th>
								<td><input name="poscd" id="poscd" title="입력" type="text"
									 style="width: 90px; background-color: #aaa5;" readonly/>
									<input name="posnm" title="입력" id="posnm" type="text" 
									 style="width: 90px; background-color: #aaa5;" readonly/>
									<div class="btn_inner">
										<a href="#none" class="btn_in_gray"><span id="btn_rank">선택</span></a>
									</div></td>
								<th scope="row" class="point">주민번호</th>
								<td><input id="cizno" name="cizno" title="입력" class="cizno" type="text" style="width: 250px" /></td>
							</tr>
							<tr>
								<th scope="row" class="point">거래은행</th>
								<td><ap:code name="dealbnk" id="dealbnk" grpCd="88" type="select"/></td>
								<th scope="row" class="point">계좌번호</th>
								<td><input name="acctno" title="입력" id="acctno" type="text" style="width: 250px"/></td>
							</tr>
							<tr>
								<th scope="row" class="point">근무형태</th>
								<td><input name="wrktp" title="입력" id="wrktp" type="text" 
									 style="width: 90px; background-color: #aaa5;" readonly/>
									<input name="wrktpnm" title="입력" id="wrktpnm" type="text" 
									 style="width: 90px; background-color: #aaa5;" readonly/>
									<div class="btn_inner">
										<a href="#none" class="btn_in_gray"><span id="btn_workType">선택</span></a>
									</div></td>
								<th scope="row" class="point">부서</th>
								<td><input name="deptcd" title="입력" id="deptcd" type="text" 
									 style="width: 90px; background-color: #aaa5;" readonly/>
									<input name="deptnm" title="입력" id="deptnm" type="text" 
									 style="width: 90px; background-color: #aaa5;" readonly/>
									<div class="btn_inner">
										<a href="#none" class="btn_in_gray"><span id="btn_department">선택</span></a>
									</div></td>
							</tr>
							<tr>
								<th scope="row" class="point">입사일</th>
								<td><input name="incodt" title="입력" id="incodt" type="text" class="datepicker" style="width: 250px"/></td>
								<th scope="row">퇴사일</th>
								<td><input name="outcodt" title="입력" id="outcodt" type="text" class="datepicker" style="width: 250px"/></td>
							</tr>
							<tr>
								<th scope="row">개인메일</th>
								<td><input name="pmail" title="입력" id="pmail" type="text" style="width: 250px"/></td>
								<th scope="row" class="point">회사메일</th>
								<td><input name="cmail" title="입력" id="cmail" type="text" style="width: 250px"/></td>	
							</tr>
							<tr>
								<th scope="row" class="point">주소</th>
								<td colspan="2"><input name="addr" title="입력" id="addr" type="text" style="width: 600px"/></td>
							</tr>
							<tr>
								<th scope="row" class="point">휴대전화번호</th>
								<td><input name="mobtel" title="입력" id="mobtel" class="mobtel" type="text" style="width: 250px"/></td>
								<th scope="row">집전화번호</th>
								<td><input name="hmtel" title="입력" id="hmtel" type="text" style="width: 250px"/></td>	
							</tr>
							<tr>
								<th scope="row" class="point">조정월</th>
								<td><select id="adjyr" name="adjyr" title="입력" style="width:90px"></select> 년
									<select id="adjmon" name="adjmon" title="입력" style="width:90px"></select> 월</td>
								<th scope="row" class="point">생년월일</th>
								<td><input name="bdt" title="입력" id="bdt" type="text" class="datepicker" style="width: 250px"/></td>	
							</tr>
							<tr>
								<th scope="row" class="point">최종학력</th>
								<td><ap:code name="lsed" id="lsed" grpCd="53" type="select" defaultLabel="일반"/></td>
								<th scope="row" class="point">학과</th>
								<td><input name="dpt" title="입력" id="dpt" type="text" style="width: 250px"/></td>	
							</tr>
							<tr>
								<th scope="row" class="point">인정학력</th>
								<td><ap:code name="dgr" id="dgr" grpCd="53" type="select" defaultLabel="일반"/></td>
								<th scope="row" class="point">졸업년월</th>
								<td><select id="grayr" name="grayr" title="졸업년" style="width:90px"></select> 년
									<select id="gramn" name="gramn" title="졸업월" style="width:90px"></select> 월</td>
							</tr>
							<tr>
								<th scope="row" class="point">혼인여부</th>
								<td>
								<select name="mrg" id="mrg">
									<option value="비혼" selected>비혼</option>
									<option value="결혼">결혼</option>
								</select>
								<!-- <input name="mrg" title="입력" id="mrg" type="text" style="width: 250px"/> --></td>
								<th scope="row">결혼기념일</th>
								<td><input name="mrgdt" title="입력" id="mrgdt" type="text" class="datepicker" style="width: 250px"/></td>	
							</tr>
							<tr>
								<th scope="row">비고</th>
								<td colspan="2"><input name="rmrk" title="입력" id="rmrk" type="text" style="width: 600px"/></td>
							</tr>
						</table>
					</div>
					<!-- 등록// -->
					<!-- // 리스트영역-->
					<div class="block">
						<!-- 리스트// -->
						<div class="btn_page_last">
							<a class="btn_page_admin" href="#" id="btn_progrm_list"><span>목록</span></a> <a
								class="btn_page_admin" href="#" id="btn_progrm_reset"><span>취소</span></a> <a
								class="btn_page_admin" href="#" id="btn_progrm_insert"><span>확인</span></a>
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