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
	$(document).ready(function() {
		/* $("#hdwuse").numericOptions({from:0, to:${userInfo.EMP_YOS}, sort:"asc"});
		const hdwuse = ${userInfo.HD_WUSE};
		$("#hdwuse").val(hdwuse); */
		// 목록
		$("#btn_progrm_list").click(function() {
			history.back();
		});
		
		// 수정
		$("#btn_progrm_update").click(function() {
			jsMsgBox(
					null,
					'confirm',
					'<spring:message code="confirm.common.save" />',
					function() {
						$("#df_method_nm").val("processProgrm");
						$("#dataForm").submit();
					});
		});
	});
	
	//초기화(미구현)
 	function HD_reset(){
		var form = document.dataForm;
		form.df_method_nm.value = "reset";
		form.submit();
	}	 
	
</script>
</head>

<body>
	<form name="dataForm" id="dataForm" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		
		<input type="hidden" name="empno" id="empno" value="${userInfo.EMP_NO}" />
		<input type="hidden" name="empnm" id="empnm" value="${userInfo.EMP_NM}" />
		<input type="hidden" name="incodt" id="incodt" value="${userInfo.INCO_DT}" />
		<input type="hidden" name="outcodt" id="outcodt" value="${userInfo.OUTCO_DT}" />
		
		
		<%-- <input type="hidden" name="empyos" id="empyos" value="${userInfo.EMP_YOS}" />
		<input type="hidden" name="hdused" id="hdused" value="${userInfo.HD_USED}" />
		<input type="hidden" name="hdleft" id="hdleft" value="${userInfo.HD_LEFT}" /> --%>
		
		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title_line">휴가 사용 정보 수정</h2>
					<!-- 타이틀 영역 //-->
					<div class="block">
						<h3 class="mgt30">
							<span>항목은 입력 필수 항목 입니다.</span>
						</h3>
						<!--// 등록 -->
						<table cellpadding="0" cellspacing="0" class="table_basic mgt10" summary="프로그램등록">
							<caption>휴가 정보 수정</caption>
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
								<th scope="row" class="point">입사일</th>
								<td>${userInfo.INCO_DT}</td>
								<th scope="row" class="point">퇴사일</th>
								<td>${userInfo.OUTCO_DT}</td>
							</tr>
							<tr>
								<th scope="row" class="point">발생 휴가 일수</th>
								<td>${userInfo.EMP_YOS}</td>
								<th scope="row" class="point">당회 사용 일수</th>
								<td><input name="hdwuse" title="입력" id="hdwuse" type="number" step="0.5" style="width: 70px"
								 value="${userInfo.HD_WUSE}" /></input> 일</td>
							</tr>
							<tr>
								<th scope="row" class="point">누적 휴가 일수</th>
								<td>${userInfo.HD_USED}</td>
								<th scope="row" class="point">잔여 휴가 일수</th>
								<td>${userInfo.HD_LEFT}</td>
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
							<!-- <a class="btn_page_admin" href="#" onclick="HD_reset()"><span>초기화</span></a> -->
							<a class="btn_page_admin" href="#" id="btn_progrm_list"><span>목록</span></a>
							<a class="btn_page_admin" href="#" id="btn_progrm_update"><span>수정</span></a>
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