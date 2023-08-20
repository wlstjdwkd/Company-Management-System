<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8"/>
<title>석유관리원 결재선관리</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask,blockUI" />
<ap:jsTag type="tech" items="acm,msg,util,etc,mainn" />
<style type="text/css">
	#cboxClose {
		top: -30px !important;
		right: 15px !important;
	}
	#cboxTitle {
		padding: 10px 0 0 20px !important;
	}
</style>
<script type="text/javascript">

	$(document).ready(function(){

	    //전체선택,전체해제
		$("#basisCheckboxAll").on('click',function(){
			if($("#basisCheckboxAll").prop("checked")){
			  $(".basisCheckbox").prop("checked",true);
			}else{
			  $(".basisCheckbox").prop("checked",false);
			}
		});
	    
		// 전체 체크박스 선택 중 하나 체크박스 선택 해제 시
		$(".basisCheckbox").click(function(){
			if ($("input[name='basisCheckbox']:checked").length == ${fn:length(resultList)}){
				$('#basisCheckboxAll').prop('checked', true);
			} else {
				$("#basisCheckboxAll").prop('checked', false);
			}
		});

		//신규등록
		$("#btn_create").on('click',function(){
			$.colorbox({
				title : "결재선 등록",
				href : "<c:url value='/PGCMAPRV0010.do?df_method_nm=getCreateForm&mode=create' />",
				width : "1000",
				height : "700",
				overlayClose : false,
				escKey : true,
				iframe : true,
				scrolling:false
			});
		});

		//수정
		$("#btn_update").on('click',function(){
			if($(".basisCheckbox").is(':checked') == false){
				jsMsgBox(null,'info',"수정할 결재선을 선택해주세요.");
			}else{
				var checkBoxList = $(".basisCheckbox:checked");
				var checkBoxListCnt = $(".basisCheckbox:checked").length;
				if(checkBoxListCnt > 1){
					jsMsgBox(null,'info',"하나만 선택해주세요.");
				}else{
					$.each(checkBoxList,function(index,item){
						var value = $(this).val();
						var sanctnSeq = $("#seq_"+value).text();
						$.colorbox({
							title : "결재선 수정",
							href : "<c:url value='/PGCMAPRV0010.do?df_method_nm=getCreateForm&mode=update&sanctnSeq="+sanctnSeq+"' />",
							width : "1000",
							height : "700",
							overlayClose : false,
							escKey : true,
							iframe : true,
							scrolling:false
						});
					});
				}
			}
		});

		//삭제
		$("#btn_delete").on('click',function(){
			var checkBoxList = $(".basisCheckbox:checked");
			var checkBoxListCnt = $(".basisCheckbox:checked").length;
			if(checkBoxListCnt == 0){
				jsMsgBox(null,'info',"삭제할 결재선을 선택해주세요.");
			}else{
				var deleteList = [];
				$.each(checkBoxList,function(index,item){
					var value = $(this).val();
					var sanctnSeq = $("#seq_"+value).text();
					deleteList.push(sanctnSeq);
					$("#delList").val(deleteList);
				});
				jsMsgBox(null, 'confirm', checkBoxListCnt + "건을 삭제하시겠습니까?",
					function() {
						$.ajax({
							url      : "${svcUrl}",
							type     : "post",
							dataType : "json",
							data	 : {
										"df_method_nm"	: "deleteDraftLine",
										"deleteList" : $("#delList").val()
										},
							async    : false,
							success  : function(response) {
								try {
									if(response.result) {
										jsMsgBox(null,'info',"삭제되었습니다.",function(){
											btn_get_list();
										});
									}
								} catch (e) {
									jsSysErrorBox(response, e);
									return;
								}
							}
						});
					}
				);
			}
		});

		$("#basisTable tbody tr").on('click',function(){
			var tbody = document.getElementById('detailTbody');
			for(var i = 0; i <= tbody.rows.length; i++){
				tbody.deleteRow(-1);
			}
			var sanctnSeq = $(this).find('td').eq(1).text();
			$.ajax({
				url      : "${svcUrl}",
				type     : "post",
				dataType : "json",
				data	 : {
							"df_method_nm"	: "findDetailProgrs",
							"sanctnSeq" 			: sanctnSeq
							},
				async    : false,
				success  : function(response) {
					try {
						if(response.result) {
							var resultList = response.value.resultList;
							$.each(resultList,function(index,item){
								var newRow = tbody.insertRow();

								var newCell1 = newRow.insertCell(0);	//기안자명
								var newCell2 = newRow.insertCell(1);	//기안자 부서명
								var newCell3 = newRow.insertCell(2);	//결재선 번호
								var newCell4 = newRow.insertCell(3);	//접수승인단계
								var newCell5 = newRow.insertCell(4);	//결재자명
								var newCell6 = newRow.insertCell(5);	//결재자 부서명
								var newCell7 = newRow.insertCell(6);	//결재선 종료여부
								var newCell8 = newRow.insertCell(7);	//대체 결재자 여부
								var newCell9 = newRow.insertCell(8);	//대체 결재자명
								var newCell10 = newRow.insertCell(9);	//대체 결재자 부서명
								var newCell11 = newRow.insertCell(10);	//대체 결재 시작일
								var newCell12 = newRow.insertCell(11);	//대체 결재 종료일

								newCell1.innerHTML = '<span class="">'+item.drafterNm+'</span>';
								newCell2.innerHTML = '<span class="">'+item.drafterDeptNm+'</span>';
								newCell3.innerHTML = '<span class="">'+item.sanctnSeq+'</span>';
								newCell4.innerHTML = '<span class="">'+item.progrsStep+'</span>';
								newCell5.innerHTML = '<span class="">'+item.confmerNm+'</span>';
								newCell6.innerHTML = '<span class="">'+item.confmerDept+'</span>';
								newCell7.innerHTML = '<span class="">'+item.sanctnEnd+'</span>';

								//대체 결재자 여부
								if(item.altrtvConfmerId != undefined){
									newCell8.innerHTML = '<span class="">Y</span>';
									newCell9.innerHTML = '<span class="">'+item.altrtvConfmerNm+'</span>';
									newCell10.innerHTML = '<span class="">'+item.altrtvConfmerDeptNm+'</span>';
									newCell11.innerHTML = '<span class="">'+item.altrtvConfmBgnDt+'</span>';
									newCell12.innerHTML = '<span class="">'+item.altrtvConfmEndDt+'</span>';
								}else{
									newCell8.innerHTML = '<span class="">N</span>';
								}
							});
							return;
						}
					} catch (e) {
						jsSysErrorBox(response, e);
						return;
					}
				}
			});
		});
	});

	function btn_get_list() {
		var form = document.dataForm;
		form.df_method_nm.value = "";
		form.submit();
	}

</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp"/>

		<input type="hidden" name="delList" id="delList"/>

	    <div id="wrap">
	        <div class="wrap_inn">
	            <div class="contents">
            		<div class="r_top">
            			<h2>결재선 목록</h2>
            		</div>
            		<div class="btn_page_total">
						<a href="javascript:void(0)" id="btn_create" class="btn_page_admin"><span>신규등록</span></a>
						<a href="javascript:void(0)" id="btn_update" class="btn_page_admin"><span>수정</span></a>
						<a href="javascript:void(0)" id="btn_delete" class="btn_page_admin"><span>삭제</span></a>
					</div>

					<div class="sub_title">
						<h4>결재선 기본 정보</h4>
					</div>

					<!-- 결재선 기본 정보 -->
					<div class="block">
						<ap:pagerParam />
						<div class="list_zone">
							<div style="overflow-x:auto; min-width:800px;">
								<table id="basisTable" style="white-space:nowrap" cellspacing="0" border="0">
									<colgroup>
										<col width="5%" />
										<col width="10%" />
										<col width="15%" />
										<col width="20%" />
										<col width="40%" />
										<col width="10%" />
									</colgroup>
									<thead>
										<tr>
											<th scope="col"><input id="basisCheckboxAll" type="checkbox" /></th>
											<th scope="col">결재선 번호</th>
											<th scope="col">기안자명</th>
											<th scope="col">기안자 부서명</th>
											<th scope="col">결재선명</th>
		                                    <th scope="col">사용여부</th>
										</tr>
									</thead>
									<tbody>
										<c:choose>
											<c:when test="${fn:length(resultList) == 0}">
												<tr>
													<td colspan="6">
														조회 결과가 없습니다.
													</td>
												</tr>
											</c:when>
											<c:otherwise>
												<c:forEach var="list" items="${resultList}" varStatus="status">
													<tr id="basis_${status.index}">
														<td><input class="basisCheckbox" name="basisCheckbox" type="checkbox" value="${status.index}" /></td>
														<td id="seq_${status.index}">${list.sanctnSeq}</td>
														<td class="tal">${list.drafterNm}</td>
														<td class="tal">${list.drafterDeptNm}</td>
														<td class="tal">${list.sanctnNm}</td>
														<td>${list.useAt}</td>
													</tr>
												</c:forEach>
											</c:otherwise>
										</c:choose>
									</tbody>
								</table>
							</div>
						</div>
						<div>
			             	<ap:pager pager="${pager}" />
			            </div>
					</div>

					<!-- 결재선 상세 정보 -->
	                <div class="block">
	                	<div class="sub_title">
							<h4>결재선 상세 정보</h4>
						</div>
						<div class="list_zone">
							<div style="overflow-x:auto; min-width:800px;">
								<table id="detailTable" style="white-space:nowrap" cellspacing="0" border="0">
									<colgroup>
										<col width="*" />
									</colgroup>
									<thead>
										<tr>
											<th scope="col">기안자명</th>
											<th scope="col">기안자 부서명</th>
											<th scope="col">결재선 번호</th>
											<th scope="col">접수승인단계</th>
		                                    <th scope="col">결재자명</th>
		                                    <th scope="col">결재자 부서명</th>
		                                    <th scope="col">결재선 종료여부</th>
		                                    <th scope="col">대체 결재자 여부</th>
		                                    <th scope="col">대체 결재자명</th>
		                                    <th scope="col">대체 결재자 부서명</th>
		                                    <th scope="col">대체 결재 시작일</th>
		                                    <th scope="col">대체 결재 종료일</th>
										</tr>
									</thead>
									<tbody id="detailTbody">
										<tr id="emptyTr">
											<td colspan="12">조회 결과가 없습니다.</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
	                </div>
		        </div>
		    </div>
	    </div>
	</form>

	<div style="display:none" id="loadingWindow">
		<div class="loading" id="loading">
			<div class="inner">
				<div class="box">
			    	<p>
			    		<span id="load_msg">진행 중 입니다. 잠시만 기다려주십시오.</span>
			    		<br />
						시스템 상태에 따라 최대 1분 정도 소요될 수 있습니다.
					</p>
					<span><img src="<c:url value="/images/etc/loading_bar.gif" />" width="323" height="39" alt="Loading..." /></span>
				</div>
			</div>
		</div>
	</div>
</body>
</html>