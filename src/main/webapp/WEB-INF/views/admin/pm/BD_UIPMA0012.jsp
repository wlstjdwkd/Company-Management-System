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
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask,selectbox" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javascript">
	$(document)
			.ready(
					function() {
						// 월 범위
						$("#adjyr").numericOptions({from:1960, to:${frontParam.curr_year}, sort:"desc"});
						$("#adjmon").numericOptions({from:01, to:12, namePadding:2, valuePadding:2, sort:"asc"});
						$("#grayr").numericOptions({from:1960, to:${frontParam.curr_year}, sort:"desc"});
						$("#gramn").numericOptions({from:01, to:12, namePadding:2, valuePadding:2, sort:"asc"});
						
						const adjyr = ${userInfo.ADJ_YR};
						$("#adjyr").val(adjyr);
						const adjmon = ${userInfo.ADJ_MON} - 1;
						$("#adjmon option:eq(" + adjmon + ")").prop("selected", true);
						
						const grayr = ${userInfo.GRA_YR};
						$("#grayr").val(grayr);
						const gramn = ${userInfo.GRA_MN} - 1;
						$("#gramn option:eq(" + gramn + ")").prop("selected", true);
						
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
						$("#btn_progrm_insert").click(
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
	
		//달력
		$(document).ready(function() {
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
    			yearRange : '2000:2030' 					//2000-2030 까지만 선택 가능
    		});
    		$('.datepicker').mask('0000-00-00'); 					// '0000-00-00'를 숨기기
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
		<input type="hidden" name="empno" id="empno" value="${userInfo.EMP_NO}" />
		<input type="hidden" name="empnm" id="empnm" value="${userInfo.EMP_NM}" />
		<input type="hidden" name="cizno" id="cizno" value="${userInfo.CIZ_NO}" />
		<input type="hidden" name="incodt" id="incodt" value="${userInfo.INCO_DT}" />
		<input type="hidden" name="outcodt" id="outcodt" value="${userInfo.OUTCO_DT}" />
		<input type="hidden" name="bdt" id="bdt" value="${userInfo.INCO_DT}" />
		
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
							<caption>직원 정보 수정</caption>
							<colgroup>
								<col width="15%" />
								<col width="30%" />
								<col width="15%" />
								<col width="*" />
							</colgroup>
							<tr>
								<th scope="row" class="point">직원번호</th>
								<td>${userInfo.EMP_NO} </td>
								<th scope="row" class="point">이름</th>
								<td>${userInfo.EMP_NM}</td>
							</tr>
							<tr>
								<th scope="row" class="point">직급</th>
								<td><input name="poscd" id="poscd" title="입력" type="text"
									 style="width: 100px; background-color: #aaa5;" value = "${userInfo.POS_CD}" readonly/>
									<input name="posnm" title="입력" id="posnm" type="text" 
									 style="width: 100px; background-color: #aaa5;" value = "${rankInfo.codeNm}" readonly/>
									<div class="btn_inner">
										<a href="#none" class="btn_in_gray"><span id="btn_rank">선택</span></a>
									</div></td>
								<th scope="row" class="point">주민번호</th>
								<td class="cizno">${userInfo.CIZ_NO}</td>
							</tr>
							<tr>
								<th scope="row" class="point">거래은행</th>
								<td><ap:code name="dealbnk" id="dealbnk" grpCd="88" type="select" 
								selectedCd="${userInfo.DEAL_BNK}" /></td>
								<th scope="row" class="point">계좌번호</th>
								<td><input name="acctno" title="입력" id="acctno" type="text"
									style="width: 250px" value = "${userInfo.ACCT_NO}" /></td>
							</tr>
							<tr>
								<th scope="row" class="point">근무형태</th>
								<td><input name="wrktp" title="입력" id="wrktp" type="text" 
									 style="width: 100px; background-color: #aaa5;" value = "${userInfo.WRK_TP}" readonly/>
									<input name="wrktpnm" title="입력" id="wrktpnm" type="text" 
									 style="width: 100px; background-color: #aaa5;" value = "${workTypeInfo.codeNm}" readonly/>
									<div class="btn_inner">
										<a href="#none" class="btn_in_gray"><span id="btn_workType">선택</span></a>
									</div></td>
								<th scope="row" class="point">부서</th>
								<td><input name="deptcd" title="입력" id="deptcd" type="text" 
									 style="width: 100px; background-color: #aaa5;" value = "${userInfo.DEPT_CD}" readonly/>
									<input name="deptnm" title="입력" id="deptnm" type="text" 
									 style="width: 100px; background-color: #aaa5;" value = "${deptInfo.codeNm}" readonly/>
									<div class="btn_inner">
										<a href="#none" class="btn_in_gray"><span id="btn_department">선택</span></a>
									</div></td>
							</tr>
							<tr>
								<th scope="row" class="point">입사일</th>
								<td>${userInfo.INCO_DT}</td>
								<th scope="row" class="point">퇴사일</th>
								<td><input name="outcodt" title="입력" id="outcodt" type="text" style="width: 250px" value="${userInfo.OUTCO_DT}" /></td>
							</tr>
							<tr>
								<th scope="row">개인메일</th>
								<td><input name="pmail" title="입력" id="pmail" type="text"
									style="width: 250px" value = "${userInfo.PER_MAIL}" /></td>
								<th scope="row" class="point">회사메일</th>
								<td><input name="cmail" title="입력" id="cmail" type="text"
									style="width: 250px" value = "${userInfo.COM_MAIL}" /></td>	
							</tr>
							<tr>
								<th scope="row" class="point">주소</th>
								<td colspan="2"><input name="addr" title="입력" id="addr" type="text" style="width: 600px" value = "${userInfo.ADDR}" /></td>
							</tr>
							<tr>
								<th scope="row" class="point">휴대전화번호</th>
								<td><input name="mobtel" title="입력" id="mobtel" class="mobtel" type="text"
									style="width: 250px" value = "${userInfo.MOB_TEL}" /></td>
								<th scope="row">집전화번호</th>
								<td><input name="hmtel" title="입력" id="hmtel" type="text"
									style="width: 250px" value = "${userInfo.HM_TEL}" /></td>	
							</tr>
							<tr>
								<th scope="row" class="point">조정월</th>
								<td><select id="adjyr" name="adjyr" title="입력" style="width:90px"></select> 년
									<select id="adjmon" name="adjmon" style="width:90px"></select> 월</td>
								<th scope="row" class="point">생년월일</th>
								<td>${userInfo.BDT}</td>	
							</tr>
							<tr>
								<th scope="row" class="point">최종학력</th>
								<td><ap:code name="lsed" id="lsed" grpCd="53" type="select" selectedCd="${userInfo.LSED}" defaultLabel="일반"/></td>
								<th scope="row" class="point">학과</th>
								<td><input name="dpt" title="입력" id="dpt" type="text"
									style="width: 250px" value = "${userInfo.DPT}" /></td>	
							</tr>
							<tr>
								<th scope="row" class="point">인정학력</th>
								<td><ap:code name="dgr" id="dgr" grpCd="53" type="select" selectedCd="${userInfo.DGR}" defaultLabel="일반"/></td>
								<th scope="row" class="point">졸업년월</th>
								<td><select id="grayr" name="grayr" title="졸업년" style="width:90px"></select> 년
									<select id="gramn" name="gramn" title="졸업월" style="width:90px"></select> 월</td>
							</tr>
							<tr>
								<th scope="row" class="point">혼인여부</th>
								<td>
								<select name="mrg" id="mrg" >
								<c:if test="${userInfo.MRG eq '결혼'}">
									<option value="비혼">비혼</option>
									<option value="결혼" selected>결혼</option>
								</c:if>
								<c:if test="${userInfo.MRG eq '비혼'}">
									<option value="비혼" selected>비혼</option>
									<option value="결혼" >결혼</option>
								</c:if>
								</select>
								</td>
								<th scope="row">결혼기념일</th>
								<td><input name="mrgdt" title="입력" id="mrgdt" type="text"
									style="width: 250px" value = "${userInfo.MRG_DT}" /></td>	
							</tr>
							<tr>
								<th scope="row">비고</th>
								<td colspan="2"><input name="rmrk" title="입력" id="rmrk" type="text" style="width: 600px" value = "${userInfo.RMRK}" /></td>
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