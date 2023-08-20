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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>중견기업정보마당</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask" />
<ap:jsTag type="tech" items="acm,msg,util,ms,etc" />
<link rel="stylesheet" type="text/css" href="/css2/sub.css">
<link rel="stylesheet" type="text/css" href="/css/tab.css">
<link rel="stylesheet" type="text/css" href="/css2/table.css">
<link rel="stylesheet" type="text/css" href="/css/licott.css">
<style type="text/css">
	#cboxClose {
		top: -30px !important;
		right: 15px !important;
	}
	#cboxTitle {
		padding: 10px 0 0 20px !important;
	}
	.btn_page_last {
		margin-right: 10px !important;
	}
	a {text-decoration: none !important;}
	h4{margin: 0px !important;}
	body {overflow: auto !important;}
	.useAtRadio {margin-left: 5px;}
	.row_btn {min-width: 0px !important;}
	.altrtvSanctnerAt {width: 100%;}
	.inputWidth {width: 90%! important;}
</style>

<script type="text/javascript">

	$().ready(function(){

		var sanctnSeq = 0;
		var mode = '${param.mode}';
		if(mode == 'create'){
			//등록시 결재선번호 조회
			$.ajax({
				url      : "${svcUrl}",
				type     : "post",
				dataType : "json",
				data	 : {
							"df_method_nm"	: "findRegistrationInfo",
							"mode"			: mode
							},
				async    : false,
				success  : function(response) {
					try {
						if(response.result) {
							sanctnSeq = response.value.sanctnSeq;
							$("#sanctnSeq").val(sanctnSeq);
							$(".sanctnSeq").text(sanctnSeq);
							$("#drafterCd").val(response.value.drafterCd);
							$("#drafterNm").val(response.value.drafterNm);
							$("#drafterDeptCd").val(response.value.drafterDeptCd);
							$("#drafterDeptNm").val(response.value.drafterDeptNm);
						}
					} catch (e) {
						jsSysErrorBox(response, e);
						return;
					}
				}
			});
		}else{
			if('${param.sanctnSeq}' != '' || '${param.sanctnSeq}' != null) sanctnSeq = '${param.sanctnSeq}';
			$("#sanctnSeq").val(sanctnSeq);
			$(".sanctnSeq").text(sanctnSeq);
			$.ajax({
				url      : "${svcUrl}",
				type     : "post",
				dataType : "json",
				data	 : {
							"df_method_nm"	: "findRegistrationInfo",
							"mode"			: mode,
							"sanctnSeq"			: sanctnSeq
							},
				async    : false,
				success  : function(response) {
					try {
						if(response.result) {
							//기안자 정보
							$("#drafterCd").val(response.value.drafterCd);
							$("#drafterNm").val(response.value.drafterNm);
							$("#drafterDeptCd").val(response.value.drafterDeptCd);
							$("#drafterDeptNm").val(response.value.drafterDeptNm);

							//결재자 정보
							var confirmers = response.value.detailList;

							//결재선명
							$("#sanctnNm").val(confirmers[0].sanctnNm);

							//사용여부
							var useAt = confirmers[0].useAt;
							$("input:radio[id='useAt"+useAt+"']").prop('checked',true);

							var table = document.getElementById('infoTable');
							$.each(confirmers,function(index,item){
								var altrtvSanctnerAt = item.altrtvSanctnerAt;	//대결여부
								if(altrtvSanctnerAt == undefined){
									altrtvSanctnerAt = "N";
								}

								var newRow = table.insertRow();
								var newCell1 = newRow.insertCell(0);	//결재선 번호
								var newCell2 = newRow.insertCell(1);	//접수승인단계
								var newCell3 = newRow.insertCell(2);	//결재자명
								var newCell4 = newRow.insertCell(3);	//결재자 부서명
								var newCell5 = newRow.insertCell(4);	//대결여부
								var newCell6 = newRow.insertCell(5);	//버튼셀

								//결재선 번호
								newCell1.innerHTML = '<span class="sanctnSeq">'+sanctnSeq+'</span>';

								//접수승인단계
								newCell2.innerHTML = '<span>'+("승인"+(index+1))+'</span><input type="hidden" value=""/>';

								//결재자명
								newCell3.innerHTML = '<input type="hidden" class="confirmerNo" value="'+item.confmerId+'"/><input type="text" class="box_grey inputWidth require" value="'+item.confmerNm+'" readonly="readonly"/>'

								//결재자 부서명
								newCell4.innerHTML = '<input type="hidden" value=""/><input type="text" class="box_grey inputWidth" value="'+item.confmerDept+'" readonly="readonly"/>'

								//대결여부
								newCell5.innerHTML = '<input type="text" class="box_grey" value="'+altrtvSanctnerAt+'" style="width : 80%; text-align: center;" readonly="readonly"/><input type="hidden" value=""/>';

								//추가,삭제 버튼
								newCell6.innerHTML = '<a class="btn_page_admin row_btn" href="#none" onclick="addUser(this)">'
														+'<span>수정</span>'
														+'</a>'
														+'<a class="btn_page_admin row_btn" href="#none" onclick="deleteRow(this)">'
														+'<span>삭제</span>'
														+'</a>';

								trChange();
							});
						}
					} catch (e) {
						jsSysErrorBox(response, e);
						return;
					}
				}
			});
		}

		//행추가
		$("#btn_add_row").on('click',function(){
			var table = document.getElementById('infoTable');
			var newRow = table.insertRow();
			//var rowIndex = (newRow.rowIndex)-1;

			var newCell1 = newRow.insertCell(0);	//결재선 번호
			var newCell2 = newRow.insertCell(1);	//접수승인단계
			var newCell3 = newRow.insertCell(2);	//결재자명
			var newCell4 = newRow.insertCell(3);	//결재자 부서명
			var newCell5 = newRow.insertCell(4);	//대결여부
			var newCell6 = newRow.insertCell(5);	//버튼셀

			//결재선 번호
			newCell1.innerHTML = '<span class="sanctnSeq">'+sanctnSeq+'</span>';

			//접수승인단계
			newCell2.innerHTML = '<span></span><input type="hidden" value=""/>';

			//결재자명
			newCell3.innerHTML = '<input type="hidden" class="confirmerNo" value=""/><input type="text" class="box_grey inputWidth require" value="" readonly="readonly"/>'

			//결재자 부서명
			newCell4.innerHTML = '<input type="hidden" value=""/><input type="text" class="box_grey inputWidth" value="" readonly="readonly"/>'

			//대결여부
			newCell5.innerHTML = '<input type="text" class="box_grey" value="" style="width : 80%; text-align: center;" readonly="readonly"/><input type="hidden" value=""/>';

			//추가,삭제 버튼
			newCell6.innerHTML = '<a class="btn_page_admin row_btn" href="#none" onclick="addUser(this)">'
									+'<span>선택</span>'
									+'</a>'
									+'<a class="btn_page_admin row_btn" href="#none" onclick="deleteRow(this)">'
									+'<span>삭제</span>'
									+'</a>';

			trChange();
		});

		//결재선 등록 및 수정
		$("#btn_line_create").on('click',function(){
			//validation
			var valiCheck = true;
			var sanctnNm = $("#sanctnNm").val();
			var tableTr = $("#infoTable tbody tr").length;
			if(sanctnNm == '' || sanctnNm == null){
				jsMsgBox($(this),'info',"결재선명을 입력하세요.");
				return;
			}
			var confirmerCnt = $(".require").length;
			if(confirmerCnt > 1){
				$.each($(".require"),function(){
					if($(this).val() == ''){
						jsMsgBox($(this),'info',"결재자를 추가하세요.");
						valiCheck = false;
						return false;
					}
				});
			}

			if(tableTr == 1){
				jsMsgBox($(this),'info',"결재자를 추가하세요.");
				return;
			}

			if(valiCheck){
				var confirmMsg = "결재선을 등록하시겠습니까?";
				if(mode == 'update'){
					confirmMsg = "결재선을 수정하시겠습니까?";
				}
				jsMsgBox(null, 'confirm', confirmMsg,
					function() {
						$(".altrtvSanctnerAt").removeAttr()
						$("#df_method_nm").val("createDraftLine");
						$("#lineDataForm").ajaxSubmit({
							url: "PGCMAPRV0010.do",
							cache : false,
							dataType: "text",
							async :true,
							beforeSubmit: function(){
							},
							success: function(response) {
								try{
									response = $.parseJSON(response)
									if(eval(response.result)){
										jsMsgBox($(this),'info',response.message,function(){
											btn_get_line_list();
										});
									}else{
										jsMsgBox($(this),'info',response.message);
					        		}
								}catch (e) {
					                if(response != null) {
					                	jsSysErrorBox(response);
					                } else {
					                    jsSysErrorBox(e);
					                }
					                return;
					            }
							}
						})
					}
				);
			}

		});
	});

	//행삭제
	function deleteRow(obj){
		var index = obj.parentNode.parentNode.rowIndex;
		var table = document.getElementById('infoTable');
		table.deleteRow(index);

		trChange();
	}

	//결재자 추가
	function addUser(obj){
		var index = (obj.parentNode.parentNode.rowIndex) - 1;
		$.colorbox({
			title : "결재자 검색",
			href : "<c:url value='/PGCMAPRV0010.do?df_method_nm=findConfirmer&index="+index+"' />",
			width : "800",
			height : "500",
			overlayClose : false,
			escKey : true,
			iframe : true,
			scrolling:false
		});
	}

	//결재 순서 조회 및 id , name 추가
	function trChange(){
		var tr = $("#infoTable tr");
		var length = tr.length;
		var trIndex = length-1;
		for(var i = 0; i < trIndex; i++){
			if(i > 0) {
				//결재 단계
				tr.eq(i+1).find('td').eq(1).find('span').text("승인"+i);
				tr.eq(i+1).find('td').eq(1).find('input').val(i);
				tr.eq(i+1).find('td').eq(1).find('input').attr('name','progrsStep_'+i);
				//결재자 번호
				tr.eq(i+1).find('td').eq(2).find('input').eq(0).attr('id','confirmerNo_'+i);
				tr.eq(i+1).find('td').eq(2).find('input').eq(0).attr('name','confirmerNo_'+i);
				//결재자명
				tr.eq(i+1).find('td').eq(2).find('input').eq(1).attr('id','confirmer_'+i);
				tr.eq(i+1).find('td').eq(2).find('input').eq(1).attr('name','confirmer_'+i);
				//부서 코드
				tr.eq(i+1).find('td').eq(3).find('input').eq(0).attr('id','confirmDeptCd_'+i);
				tr.eq(i+1).find('td').eq(3).find('input').eq(0).attr('name','confirmDeptCd_'+i);
				//부서 이름
				tr.eq(i+1).find('td').eq(3).find('input').eq(1).attr('id','confirmDept_'+i);
				tr.eq(i+1).find('td').eq(3).find('input').eq(1).attr('name','confirmDept_'+i);
				//대결여부
				tr.eq(i+1).find('td').eq(4).find('input').eq(0).attr('id','altrtvSanctnerAt_'+i);
				//대체결재자명
				tr.eq(i+1).find('td').eq(4).find('input').eq(1).attr('id','altrtvConfmerNm_'+i);

				$("#totalConfirmer").val(i);
			}
		}
	}

	function btn_get_line_list(){
		$(parent.document).find("#dataForm").attr("action","<c:url value='${svcUrl}' />").submit();
	}


</script>

</head>
<body>
<form name="lineDataForm" id="lineDataForm" action="<c:url value='${svcUrl}' />" method="post">
	<ap:include page="param/defaultParam.jsp" />
	<ap:include page="param/pagingParam.jsp" />

	<input type="hidden" name="mode" id="mode" value="${param.mode}"/>
	<input type="hidden" name="sanctnSeq" id="sanctnSeq"/>
	<input type="hidden" name="totalConfirmer" id="totalConfirmer"/>


	<div class="r_top">
		<c:choose>
			<c:when test="${param.mode == 'create'}">
				<h2>결재선 등록</h2>
			</c:when>
			<c:otherwise>
				<h2>결재선 수정</h2>
			</c:otherwise>
		</c:choose>
	</div>

	<div class="pop_q_con">
	    <div class="list_zone" style="margin-top: -20px;">
	    	<div class="sub_title">
				<h4>결재선명</h4>
			</div>
			<div style="float: right; margin: 0px 10px 5px;">
				<div style="display: inline-block;">
					<span style="margin-right: 10px;">사용여부 : </span>
					<input type="radio" id="useAtY" name="useAt" value="Y" checked="checked"><label class="useAtRadio" for="useAtY">Y</label>
				</div>
				<div style="display: inline-block; margin-left: 10px;">
					<input type="radio" id="useAtN" name="useAt" value="N"><label class="useAtRadio" for="useAtN">N</label>
				</div>
			</div>
			<table cellspacing="0" border="0" width="90%">
				<colgroup>
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="70%">
				</colgroup>
				<tbody>
					<tr>
						<td class="td_grey" style="height: 25px;">결재선 번호</td>
						<td class="tac">
							<span class="sanctnSeq"></span>
						</td>
						<td class="td_grey">결재선명</td>
						<td class="tal">
							<input type="text" id="sanctnNm" name="sanctnNm" style="width: 98%;"/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="list_zone" style="margin-top: -10px;">
			<div class="sub_title" style="margin-bottom: -5px;">
				<h4>결재선 정보</h4>
			</div>
			<div style="overflow-x:auto;">
				<div style="float: right;">
					<a href="javascript:void(0)" id="btn_add_row" class="btn_page_admin"><span>행추가</span></a>
				</div>
				<table id="infoTable" style="white-space:nowrap" cellspacing="0" border="0">
					<colgroup>
						<col width="8%" />
						<col width="10%" />
						<col width="25%" />
						<col width="35%" />
						<col width="10%" />
						<col width="12%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">결재선 번호</th>
							<th scope="col">접수승인단계</th>
							<th scope="col">결재자명</th>
							<th scope="col">결재자 부서명</th>
							<th scope="col">대결여부</th>
							<th scope="col">선택</th>
						</tr>
					</thead>
					<tbody id="infoTbody">
						<!-- 기안자 정보 (고정) -->
						<tr id="drafterTr" style="height: 40px;">
							<td><span class="sanctnSeq"></span></td>
							<td><span>기안</span></td>
							<td class="tal">
								<input type="hidden" id="drafterCd" name="drafterCd"/>
								<input type="text" id="drafterNm" name="drafterNm" class="box_grey inputWidth require" readonly="readonly"/>
							</td>
							<td class="tal">
								<input type="hidden" id="drafterDeptCd" name="drafterDeptCd"/>
								<input type="text" id="drafterDeptNm" name="drafterDeptNm" class="box_grey inputWidth" readonly="readonly" style="margin-left: 5px;"/>
							</td>
							<td></td>
							<td style="width: 110px; padding: 5px 0px 0px 0px;">기안자</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>


		<div style="text-align: center; margin-top: 20px;">
			<div style="display: inline-block;">
				<a class="btn_page_admin" href="javascript:void(0)" id="btn_line_create">
					<c:choose>
						<c:when test="${param.mode == 'create'}">
							<span>등록</span>
						</c:when>
						<c:otherwise>
							<span>수정</span>
						</c:otherwise>
					</c:choose>
				</a>
			</div>
		</div>
	</div>
	<!--content//-->
</form>
</body>
</html>