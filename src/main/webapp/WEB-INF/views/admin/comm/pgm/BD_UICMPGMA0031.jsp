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
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,mask,msgBoxAdmin,colorboxAdmin" />
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

	function preSelect() {
		var form = document.dataForm;
		for (var i = 0; i < form.ad_jobSe.length; i++) {
			if (form.ad_jobSe.options[i].selected) {
				form.preProgrmId.value = "PG" + form.ad_jobSe.options[i].value;
			}
		}
	}

	function checkProgrmId() {
		$.ajax({
			url : "PGCMPGM0030.do",
			type : "POST",
			dataType : "json",
			data : {
				df_method_nm : "checkProgrmId",
				progrmId : $("#ad_progrmId").val(),
				preProgrmId : $("#preProgrmId").val()
			},
			async : false,
			success : function(response) {
				if (response.result) {
				} else {
					jsMsgBox($("#ad_progrmId"), "error", Message.template
							.duplicationValue("프로그램ID"));
				}
			}
		});
	}
	
	function checkJobSe() {
		if ($("#ad_jobSe").val() == "") {
			jsMsgBox($("#ad_jobSe"), "error", Message.template.required("업무구분"));
		}
	}
	
	
	$(document)
			.ready(
					function() {
						$("#dataForm").validate({
							rules : {// 사이트구분
								ad_jobSe : {
									required : true
								},
								ad_progrmNm : {
									required : true
								},
								ad_svcAt : {
									required : true
								},
								ad_progrmId : {
									required : true
								}

							},
							submitHandler : function(form) {
								form.submit();
							}
						});

						// 목록
						$("#btn_progrm_list").click(function() {
							$("#df_method_nm").val("index");
							document.dataForm.submit();

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
											jsMsgBox(
													null,
													'confirm',
													'<spring:message code="confirm.common.save" />',
													function() {
														var cnt = $("input[name=inqireAt]").length;

														var menuOutptAt = document
																.getElementsByName("menuOutptAt");
														var inqireAt = document
																.getElementsByName("inqireAt");
														var streAt = document
																.getElementsByName("streAt");
														var deleteAt = document
																.getElementsByName("deleteAt");
														var prntngAt = document
																.getElementsByName("prntngAt");
														var excelAt = document
																.getElementsByName("excelAt");
														var spclAt = document
																.getElementsByName("spclAt");

														for (var i = 0; i < cnt; i++) {
															if (menuOutptAt[i].checked == true) {
																menuOutptAt[i].value = "Y";
															} else {
																menuOutptAt[i].value = "N";
															}
															if (inqireAt[i].checked == true) {
																inqireAt[i].value = "Y";
															} else {
																inqireAt[i].value = "N";
															}
															if (streAt[i].checked == true) {
																streAt[i].value = "Y";
															} else {
																streAt[i].value = "N";
															}
															if (deleteAt[i].checked == true) {
																deleteAt[i].value = "Y";
															} else {
																deleteAt[i].value = "N";
															}
															if (prntngAt[i].checked == true) {
																prntngAt[i].value = "Y";
															} else {
																prntngAt[i].value = "N";
															}
															if (excelAt[i].checked == true) {
																excelAt[i].value = "Y";
															} else {
																excelAt[i].value = "N";
															}
															if (spclAt[i].checked == true) {
																spclAt[i].value = "Y";
															} else {
																spclAt[i].value = "N";
															}

															$('#dataForm')
																	.append(
																			'<input type = "hidden" name = "menuOutptAt__'+ i +'" value = "'+ menuOutptAt[i].value +'"/>');
															$('#dataForm')
																	.append(
																			'<input type = "hidden" name = "inqireAt__'+ i +'" value = "' + inqireAt[i].value +'"/>');
															$('#dataForm')
																	.append(
																			'<input type = "hidden" name = "streAt__'+ i +'" value = "'+ streAt[i].value +'"/>');
															$('#dataForm')
																	.append(
																			'<input type = "hidden" name = "deleteAt__'+ i +'" value = "'+ deleteAt[i].value +'"/>');
															$('#dataForm')
																	.append(
																			'<input type = "hidden" name = "prntngAt__'+ i +'" value = "'+ prntngAt[i].value +'"/>');
															$('#dataForm')
																	.append(
																			'<input type = "hidden" name = "excelAt__'+ i +'" value = "'+ excelAt[i].value +'"/>');
															$('#dataForm')
																	.append(
																			'<input type = "hidden" name = "spclAt__'+ i +'" value = "'+ spclAt[i].value +'"/>');
														}

														$("#df_method_nm")
																.val(
																		"processProgrm");
														$("#dataForm").submit();
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
					<h2 class="menu_title_line">프로그램등록</h2>
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
								<col width="*" />
							</colgroup>
							<tr>
								<th scope="row" class="point">업무구분</th>
								<td><ap:code id="ad_jobSe" name="ad_jobSe" grpCd="4" type="select"
										selectedCd="${param.ad_jobSe}" onchange="preSelect();" defaultLabel="구분선택" /></td>
							</tr>
							<tr>
								<th scope="row" class="point">프로그램ID</th>
								<td><input name="preProgrmId" id="preProgrmId" type="text" style="width: 40px"
									value="PG" readonly /> <input name="ad_progrmId" title="입력" id="ad_progrmId" type="text"
									onfocusout="checkProgrmId();" onfocusin = "checkJobSe();" style="width: 70px" /></td>
							</tr>

							<tr>
								<th scope="row" class="point">프로그램명</th>
								<td><input name="ad_progrmNm" title="입력" id="ad_progrmNm" type="text"
									style="width: 762px" /></td>
							</tr>
							<tr>
								<th scope="row" class="point">서비스여부</th>
								<td><input type="radio" name="ad_svcAt" id="ad_svcAt" value="Y" onclick="readonly();"
									checked /> <label for="ad_svcAt" class="mgr30"">서비스</label> <input type="radio"
									name="ad_svcAt" onclick="readonly_re();" id="ad_svcAt_reject" value="N" /> <label
									for="ad_svcAt_reject">링크</label></td>
							</tr>
							<tr>
								<th scope="row">뷰파일경로</th>
								<td><input name="ad_viewFilePath" title="입력" id="ad_viewFilePath" type="text"
									style="width: 762px" readonly /></td>
							</tr>
							<tr>
								<th scope="row">비고</th>
								<td><input name="ad_rm" title="입력" id="ad_rm" type="text" style="width: 762px" /></td>
							</tr>
						</table>
					</div>
					
					<!-- 등록// -->
					<!-- // 리스트영역-->
					<div class="block">
						<h3 class="mgt30">권한정보</h3>
						<!--// 리스트 -->
						<div class="list_zone">
							<table cellpadding="0" cellspacing="0" class="table_basic" summary="권한정보">
								<caption>권한정보</caption>
								<colgroup>
									<col width="16%" />
									<col width="12%" />
									<col width="12%" />
									<col width="12%" />
									<col width="12%" />
									<col width="12%" />
									<col width="12%" />
									<col width="12%" />
								</colgroup>
								<tr>
									<th scope="col"><label> 업무구분</label></th>
									<th>메뉴출력</th>
									<th>조회</th>
									<th>저장</th>
									<th>삭제</th>
									<th>인쇄</th>
									<th>엑셀</th>
									<th>특수</th>
								</tr>
								<c:forEach items="${codeList}" var="codeList" varStatus="status">
									<tr>
										<th scope="row">${codeList.codeNm}</th>
										<td class="tac"><input type="checkbox" name="menuOutptAt" /></td>
										<td><input type="checkbox" name="inqireAt" /></td>
										<td><input type="checkbox" name="streAt" /></td>
										<td><input type="checkbox" name="deleteAt" /></td>
										<td><input type="checkbox" name="prntngAt" /></td>
										<td><input type="checkbox" name="excelAt" /></td>
										<td><input type="checkbox" name="spclAt" /></td>
									</tr>
								</c:forEach>
							</table>
						</div>
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