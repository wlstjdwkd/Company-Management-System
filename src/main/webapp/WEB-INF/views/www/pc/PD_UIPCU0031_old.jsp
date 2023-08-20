<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업검색|기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,mask,msgBox,colorboxAdmin" />
<ap:jsTag type="tech" items="pc,ucm,msg,util" />
<script type="text/javascript">
	$(document).ready(function() {

		// MASK
		// 휴대전화
		$('#ad_phon_middle').mask('0000');
		$('#ad_phon_last').mask('0000');

		// 유효성 검사
		$("#dataForm").validate({
			rules : { // 연락처 가운데
				ad_phon_middle : {
					required : true,
					minlength : 3
				},// 연락처 마지막
				ad_phon_last : {
					required : true,
					minlength : 3
				},// 이메일
				ad_email : {
					required : true,
					email : true,
					maxlength : 100
				}, // 제목
				ad_title : {
					required : true,
					minlength : 3,
					maxlength : 200
				}, // 데이터항목
				ad_data_item : {
					required : true
	
				}, // 데이터 요청사유
				ad_data_content : {
					required : true,
					minlength : 10
				}
			},
			submitHandler : function(form) {

				// 연락처
				$("#ad_mbtlNum").val($("#ad_phon_first").val() + "-" + $("#ad_phon_middle").val() + "-" + $("#ad_phon_last").val());

				$.ajax({
					url : "PGPC0030.do",
					type : "POST",
					dataType : "json",
					data : {
						df_method_nm : "insertDataRequest",
						"ad_userNm" : $('#ad_userNm').val(),
						"ad_mbtlNum" : $('#ad_mbtlNum').val(),
						"ad_email" : $('#ad_email').val(),
						"ad_title" : $('#ad_title').val(),
						"ad_data_item" : $('#ad_data_item').val(),
						"ad_data_content" : $('#ad_data_content').val()
					},
					async : false,
					success : function(
							response) {
						try {
							if (response.result) {
								jsMsgBox(null, 'info', '작성하신 내용이 성공적으로 접수되었습니다.<br> 이용해 주셔서 감사합니다.', function() { parent.$.colorbox.close(); });
							}
						} catch (e) {
							if (response != null) {
								jsSysErrorBox(response);
							} else {
								jsSysErrorBox(e);
							}
							return;
						}
					}
				});
			}
		});

		// 취소
		$("#btn_cancel").click(function() {
			parent.$.colorbox.close();
		});

		// 확인
		$("#btn_insert").click(function() {
			$("#dataForm").submit();
		});

	});
</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		
		<!-- LNB 출력 방지 -->
		<input type="hidden" id="no_lnb" value="true" />
				
		<input type="hidden" id="ad_mbtlNum" name="ad_mbtlNum" />
		<input type="hidden" id="ad_userNm" name="ad_userNm" value="${popParam.userNm}" />
		<div>
			<div class="pop_write">
				<div class="txt_zone">
					<p style="margin-bottom: -20px;">아래 요청하실 분의 정보와 요청 사유를 입력해 주세요. 확인 후 데이터 공유 유무를 안내해 드립니다.</p>
					<span>항목은 입력 필수 항목 입니다.</span>
				</div>
				<table class="ptbl_basic">
					<caption>데이터 요청 정보 입력 게시판</caption>
					<colgroup>
						<col style="width: 25%">
						<col style="width: *">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row"> 작성자</th>
							<td>${popParam.userNm}</td>
						</tr>
						<tr>
							<th scope="row" class="point"><label for="ad_phon_first"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 연락처</label></th>
							<td>
								<select id="ad_phon_first" style="width: 101px;">
									<c:forTokens items="${MOBILE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
										<option value="${firstNum }"
											<c:if test="${popParam.mbtlNum.first == firstNum }">selected="selected"</c:if>>${firstNum }</option>
									</c:forTokens>
								</select> ~ <input name="ad_phon_middle" type="text" id="ad_phon_middle" class="text" style="width: 127px;" title="핸드폰가운데번호" value="${popParam.mbtlNum.middle}" /> ~ <input name="ad_phon_last" type="text" id="ad_phon_last" class="text" style="width: 127px;" title="핸드폰마지막번호" value="${popParam.mbtlNum.last}" /></td>
						</tr>
						<tr>
							<th scope="row" class="point"><label for="ad_email"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 이메일</label></th>
							<td><input name="ad_email" type="text" id="ad_email" class="text" style="width: 91%;" title="이메일입력란" value="${popParam.email}"></td>
						</tr>
						<tr>
							<th scope="row" class="point"><label for="ad_title"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 제목</label></th>
							<td><input name="ad_title" type="text" id="ad_title" class="text" style="width: 91%;" title="제목"></td>
						</tr>
						<tr>
							<th scope="row" class="point"><label for="ad_data_item"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 데이터항목</label></th>
							<td><input name="ad_data_item" type="text" id="ad_data_item" class="text" style="width: 91%;" title="데이터항목"></td>
						</tr>
						<tr>
							<th scope="row" class="point"><label for="ad_data_content"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 내용</label></th>
							<td><textarea name="ad_data_content" id="ad_data_content" cols="85" rows="10" title="데이터 요청사유" style="width: 90%;"></textarea></td>
						</tr>
					</tbody>
				</table>
				<!--//페이지버튼-->
				<div class="btn_page tar">
					<a class="btn_page_blue" href="#none" id="btn_cancel"><span>취소</span></a>
					<a class="btn_page_blue" href="#none" id="btn_insert"><span>확인</span></a>
				</div>
			</div>
		</div>
	</form>
</body>
</html>