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
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javascript">

$(document).ready(function() {
	
	// 목록 선택
	$("#btn_code_get_list").click(function() {
		$("#df_method_nm").val("index");
		document.dataForm.submit();
	});
	
	// 유효성 검사
	$("#dataForm").validate(
			{
				rules : {// 코드명  				
					codeGroupNm : {
						required : true,
						maxlength: 100
					},
					ad_outptOrdr : {
						number : true,
						min : 1,
						max : 99
					}

				},
				submitHandler : function(form) {
					var cnt = $("input[name=ad_check]").length;
					$("#codeCnt").attr("value", cnt);
					
					var code_= document.getElementsByName("code_");
					var codeNm_= document.getElementsByName("codeNm_");
					var codeDc_= document.getElementsByName("codeDc_");
					var outptOrdr_= document.getElementsByName("outptOrdr_");
					var useAt_= document.getElementsByName("useAt_");

					for(var i=0; i<cnt; i++) {
			
						if(code_[i].value == "" && codeNm_[i].value == "" && codeDc_[i].value == "" && outptOrdr_[i].value == "") {
							if(i>0) {
								$("input[name=ad_check]").eq(i).parent().parent().remove();
								i--; cnt--;
								
							} else if (i==0 && cnt>1) {
								$("input[name=ad_check]").eq(i).parent().parent().remove();
								i--; cnt--;
							} else if( i==0 && cnt == 1) {
								$("input[name=ad_check]").eq(i).parent().parent().remove();
								form.submit();
							}
						}
						else {
							if (code_[i].value == "") {
								jsMsgBox($(this), "error", Message.template.required("하위코드"));
								return;
							} 
							else {
								for(var j=0; j<i; j++) {
									if(code_[j].value == code_[i].value){
										jsMsgBox($(this), "error", Message.template.duplicationValue("하위코드"));
										return;
									}
								}
							}
							
							if (codeNm_[i].value == "") {
								jsMsgBox($(this), "error", Message.template.required("하위코드명"));
								return;
							}
							else {
								for(var j=0; j<i; j++) {
									if(codeNm_[j].value == codeNm_[i].value){
										jsMsgBox($(this), "error", Message.template.duplicationValue("하위코드명"));
										return;
									}
								}
							}
							
							if (outptOrdr_[i].value == "") {
								jsMsgBox($(this), "error", Message.template.required("출력순서"));
								return;
							} else {
								for(var j=0; j<i; j++) {
									if(outptOrdr_[j].value == outptOrdr_[i].value){
										jsMsgBox($(this), "error", Message.template.duplicationValue("출력순서"));
										return;
									}
								}
							}
							
							if (useAt_[i].checked == true) {
											useAt_[i].value = "Y";
							}else {
								useAt_[i].value = "N";
							}
						}
					}
					
				    addHidden();
					form.submit();
				}
			});

	

	// 삭제
	$("#btn_code_delete").click(function() {
		jsMsgBox(null, 'confirm','<spring:message code="confirm.common.delete" />',function(){$("#df_method_nm").val("deleteCode"); $("#dataForm").submit();});
	});

	// 수정
	$("#btn_code_modify").click(function() {
		jsMsgBox(null, 'confirm','<spring:message code="confirm.common.save" />',function(){$("#df_method_nm").val("processCode"); $("#dataForm").submit();});
	});
	
	// 체크박스 전체 선택/해제
	$("#ad_check_all").click(function() {
		if($(this).is(':checked')) {
			$("input[name=ad_check]").prop("checked", true);
		} 
		else {
			$("input[name=ad_check]").prop("checked", false);
		}
	});
	
	// 하위코드 삭제
	$("#btn_code_row_delete").click(function() {
		var checkCnt = $("input[name=ad_check]").size();
		var count = 0;
		
		// 체크박스에 체크가 되어있을 때 삭제
		for (var i=0; i<checkCnt; i++) {
		
			if($("input[name=ad_check]").eq(i).is(":checked")) {
				$("input[name=ad_check]").eq(i).parent().parent().remove();
				i--;
				count++;
				$("input[name=ad_check_all]").prop("checked", false);
			}
		}
			if(count != 0) {
				
			} else {
				// 삭제창 알림
					jsMsgBox(null, "error", Message.template.wrongDelTarget(""));
			}


		// 전체 삭제 후, 행 추가
		if($("input[name=ad_check]").size() == 0) {
			addRow();
		}

	});
	
	// 하위코드 추가
	$("#btn_code_add").click(function() {
		addRow();
	});
	
	// 행 추가
	function addRow() {	
		
		$("#dataTable tbody").append(
				'<tr>'+'<td><input type="checkbox" name="ad_check" /></td>'+
				'<td><span class="only"> <input name="code_" type="text" style="width: 100%;" title="입력" /></span></td>'+
				'<td><span class="only"> <input name="codeNm_" type="text"  style="width: 100%;" title="입력" /></span></td>'+
				'<td><span class="only"> <input name="codeDc_" type="text"  style="width: 100%;" title="입력" /></span></td>'+
				'<td><span class="only"> <input name="outptOrdr_" type="text"  style="width: 100%;" title="입력" /></span></td>'+
				'<td><input type="checkbox" name="useAt_"   /></td>'+'</tr>');
		
	}
	
	// 각 행의 데이터 추가
	function addHidden() {
		var cnt = $("input[name=ad_check]").length;
		$("#codeCnt").attr("value", cnt);
		
		var code_= document.getElementsByName("code_");
		var codeNm_= document.getElementsByName("codeNm_");
		var codeDc_= document.getElementsByName("codeDc_");
		var outptOrdr_= document.getElementsByName("outptOrdr_");
		var useAt_= document.getElementsByName("useAt_");
		
		for(var i=0; i<cnt; i++) {
			$('#dataForm').append('<input type="hidden" name="code_' + i +'" value="' + code_[i].value +'" />');
			$('#dataForm').append('<input type="hidden" name="codeNm_' + i +'" value="' + codeNm_[i].value +'" />');
			$('#dataForm').append('<input type="hidden" name="codeDc_' + i +'" value="' + codeDc_[i].value +'" />');
			$('#dataForm').append('<input type="hidden" name="outptOrdr_' + i +'" value="' + outptOrdr_[i].value +'" />');
			$('#dataForm').append('<input type="hidden" name="useAt_' + i +'" value="' + useAt_[i].value +'" />');
		}
		
	}
});

</script>
</head>

<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		
		<input type="hidden" name="codeCnt" id="codeCnt" />
		<input type="hidden" name="codeGroupNo" id="codeGroupNo" value="${param.codeGroupNo}" />
		
		<!-- 이전페이지 값 -->
		<input type="hidden" name="df_curr_page" id="df_curr_page" value="${prePage.df_curr_page}" />
		<input type="hidden" name="df_row_per_page" id="df_row_per_page" value="${prePage.df_row_per_page}" />
		<input type="hidden" name="limitFrom" id="limitFrom" value="${prePage.limitFrom}" /> 
		<input type="hidden" name="limitTo" id="limitTo" value="${prePage.limitTo}" /> 
		<input type="hidden" name="searchCondition" id="searchCondition" value="${prePage.searchCondition}" />
		<input type="hidden" name="searchKeyword" id="searchKeyword" value="${prePage.searchKeyword}" />
			
		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title_line">코드수정</h2>
					<!-- 타이틀 영역 //-->
					<div class="block">
						<h3 class="mgt30">
							<span>항목은 입력 필수 항목 입니다.</span>
						</h3>
						<!--// 등록 -->
						<table cellpadding="0" cellspacing="0" class="table_basic mgt10" summary="코드등록">
							<caption>코드등록</caption>
							<colgroup>
								<col width="15%" />
								<col width="*" />
							</colgroup>
							<tr>
								<th scope="row" class="point"><label for="searchWrd20"> 코드명</label></th>
								<td><input name="codeGroupNm" title="입력" id="codeGroupNm" type="text" style="width: 762px"
									value="${codeGroupInfo.codeGroupNm}" /></td>
							</tr>
							<tr>
								<th scope="row">코드설명</th>
								<td><input name="codeGroupDc" title="입력" id="codeGroupDc" type="text"
									style="width: 762px" value="${codeGroupInfo.codeGroupDc}" /></td>
							</tr>
						</table>
					</div>
					<!-- 등록// -->
					<div class="btn_page_last">
						<a class="btn_page_admin" href="#none" id="btn_code_get_list"><span>목록</span></a> <a
							class="btn_page_admin" href="#none" id="btn_code_delete"><span>삭제</span></a> 
							<a class="btn_page_admin" href="#none" id="btn_code_modify"><span>수정</span></a>
					</div>
					<!-- // 리스트영역-->
					<div class="block">
						<h3>하위코드</h3>
						<!--// 리스트 -->
						<div class="list_zone">
							<table cellspacing="0" border="0" id="dataTable" summary="하위코드 리스트">
								<caption>하위코드</caption>
								<colgroup>
									<col width="10%" />
									<col width="20%" />
									<col width="20%" />
									<col width="30%" />
									<col width="10%" />
									<col width="10%" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col"><input type="checkbox" name="ad_check_all" class="checkbox" id="ad_check_all" /></th>
										<th scope="col">하위코드</th>
										<th scope="col">하위코드명</th>
										<th scope="col">하위코드설명</th>
										<th scope="col">출력순서</th>
										<th scope="col">사용</th>
									</tr>
								</thead>
								<tbody>
									<%-- 데이터를 화면에 출력해준다 --%>
									<c:forEach items="${codeList}" var="codeList" varStatus="status">
										<tr>
											<td><input type="checkbox" name="ad_check" id="ad_check" /></td>
											<td><span class="only"> <input name="code_" type="text" 
													style="width: 97%;" title="입력" value="${codeList.code}" />
											</span></td>
											<td><span class="only"> <input name="codeNm_" type="text" 
													style="width: 97%;" title="입력" value="${codeList.codeNm}" />
											</span></td>
											<td><span class="only"> <input name="codeDc_" type="text" 
													style="width: 97%;" title="입력" value="${codeList.codeDc}" />
											</span></td>
											<td><span class="only"> <input name="outptOrdr_" type="text"
													 style="width: 93%;" title="입력" value="${codeList.outptOrdr}" />
											</span></td>
											<td><input type="checkbox" name="useAt_" 
												<c:if test="${codeList.useAt == 'Y'}"> checked="checked" </c:if>></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<!-- 리스트// -->
						<div class="btn_page_last">
							<a class="btn_page_admin" href="#none" id="btn_code_row_delete"><span>삭제</span></a> 
							<a class="btn_page_admin" href="#none" id="btn_code_add"><span>추가</span></a>
						</div>
					</div>
					<!--리스트영역 //-->
				</div>
			</div>
			<!--content//-->
		</div>
		</div>
		</div>
	</form>
</body>
</html>