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
	.btn_page_last {margin-right: 10px !important;}
	a {text-decoration: none !important;}
	h4{margin: 0px !important;}
	body {overflow: auto !important;}
	.altrtvSanctnerAtRadio {margin-left: 5px;}
	.approvalSelect {width: 100%;}
	.sub_title_custom {border-bottom: 1px dotted #bdbbbb; padding-bottom: 5px;}
	.inputWidth {width: 93% !important;}
</style>

<script type="text/javascript">

	$(document).ready(function(){

		//부모창 관련 데이터
		var pIndex = ${index};
		var pUserNo = "";
		var pUserNm = "";
		var pDeptNm = "";
		var pDeptCd = "";
		var pAltrtvSanctnerAt = "";
		var pAltrtvConfmerNm = "";

		//대체결재여부 컨트롤
		$(".altrtvSanctnerAt").on('change',function(){
			var value = $(this).val();
			if(value == 'Y') $("#altrtvConfmerDiv").css('display','');
			else if(value == 'N') {
				/* $("#altrtvConfirmDeptCd").val(''); */
				$("#altrtvConfirmDept").val('');
				$("#altrtvConfmerDiv").css('display','none');
			}
		});

		//결재자 선택시 부서명 자동입력
		$(".approvalSelect").on('change',function(){
			var id = $(this).attr('id');
			var val = $(this).val();
			if(val == '' || val == null){
				if(id == 'confirmerSelect'){
					$("#confirmDeptCd").val('');
					$("#confirmDept").val('');

					//대체 결재자 관련
					$("input:radio[id='altrtvSanctnerAtN']").prop('checked',true);
					$("#altrtvConfmerDiv").css('display','none');
					$("#altrtvConfirmer").val('');
					$("#altrtvConfirmDept").val('');
					$("#altrtvConfmBgnDt").val('');
					$("#altrtvConfmEndDt").val('');
					$("#altrtvSanctnerAt").val('N');
					$("#altrtvSanctnerAt").text('N');
				}
				/* else if(id == 'altrtvConfirmerSelect'){
					$("#altrtvConfirmDeptCd").val('');
					$("#altrtvConfirmDept").val('');
				} */
			}else{
				var divIndex = val.indexOf("-");
				var userNo = val.substring(0,divIndex);
				var deptCd = val.substring((divIndex+1),val.length);

				var deptNmText = "";
				if(id == 'confirmerSelect') deptNmText = $("#confirmerSelect option:selected").text();

				//else if(id == 'altrtvConfirmerSelect') deptNmText = $("#altrtvConfirmerSelect option:selected").text();

				var deptNmStartIndex = deptNmText.indexOf("(");
				var deptNmEndIndex = deptNmText.indexOf(")");
				var deptNm = deptNmText.substring((deptNmStartIndex+1),deptNmEndIndex);

				if(id == 'confirmerSelect'){
					//부모창 넘길 텍스트 저장
					pUserNo = userNo;
					pUserNm = deptNmText.substring(0,(deptNmStartIndex-1));
					pDeptCd = deptCd;
					pDeptNm = deptNm;

					$("#confirmDeptCd").val(deptCd);
					$("#confirmDept").val(deptNm);
				}
				/* else if(id == 'altrtvConfirmerSelect'){
					$("#altrtvConfirmDeptCd").val(deptCd);
					$("#altrtvConfirmDept").val(deptNm);
				} */

				$.ajax({
					url      : "${svcUrl}",
					type     : "post",
					dataType : "json",
					data	 : {
								"df_method_nm"	: "findAltrtvConfrm",
								"confmerId"		: userNo
								},
					async    : false,
					success  : function(response) {
						try {
							if(response.result) {
								//대체 결재자 정보
								$("#altrtvConfirmer").val(response.value.altrtvInfo.altrtvConfmerNm);
								$("#altrtvConfirmDept").val(response.value.altrtvInfo.altrtvConfmerDeptNm);
								$("#altrtvConfmBgnDt").val(response.value.altrtvInfo.altrtvConfmBgnDt);
								$("#altrtvConfmEndDt").val(response.value.altrtvInfo.altrtvConfmEndDt);
								$("#altrtvSanctnerAt").val('Y');
								$("#altrtvSanctnerAt").text('Y');
								pAltrtvConfmerNm = response.value.altrtvInfo.altrtvConfmerNm;
								pAltrtvSanctnerAt = "Y";

								//대체 결재자 라디오 , div 컨트롤
								$("input:radio[id='altrtvSanctnerAtY']").prop('checked',true);
								$("#altrtvConfmerDiv").css('display','');
							}else{
								$("#altrtvConfirmer").val('');
								$("#altrtvConfirmDept").val('');
								$("#altrtvConfmBgnDt").val('');
								$("#altrtvConfmEndDt").val('');
								$("#altrtvSanctnerAt").val('N');
								$("#altrtvSanctnerAt").text('N');
								pAltrtvSanctnerAt = "N";

								$("input:radio[id='altrtvSanctnerAtN']").prop('checked',true);
								$("#altrtvConfmerDiv").css('display','none');
							}
						} catch (e) {
							jsSysErrorBox(response, e);
							return;
						}
					}
				});
			}
		});

		//등록
		$("#btn_confirmer_create").on('click',function(){
			//validation
			var confirmer = $("#confirmerSelect").val();
			if(confirmer == '' || confirmer == null){
				jsMsgBox($(this),'info',"결재자를 선택해주세요.");
				return;
			}
			//부모창 이미 입력된 결재자 값 체크
			var confirmerNos = parent.document.getElementsByClassName("confirmerNo");
			var exitCheck = true;
			$.each(confirmerNos,function(){
				var exitVal = $(this).val();
				if(pUserNo == exitVal){
					exitCheck = false;
					jsMsgBox($(this),'info',"이미 선택한 결재자 입니다.");
					return;
				}
			});
			//부모창 입력값 전달
			if(exitCheck){
				parent.document.getElementById("confirmerNo_"+pIndex).value = pUserNo;
				parent.document.getElementById("confirmer_"+pIndex).value = pUserNm;
				parent.document.getElementById("confirmDeptCd_"+pIndex).value = pDeptCd;
				parent.document.getElementById("confirmDept_"+pIndex).value = pDeptNm;
				parent.document.getElementById("altrtvSanctnerAt_"+pIndex).value = pAltrtvSanctnerAt;
				parent.document.getElementById("altrtvConfmerNm_"+pIndex).value = pAltrtvConfmerNm;

				parent.$.colorbox.close();
			}
		});

	});

</script>

</head>
<body>
<form name="confirmerDataForm" id="confirmerDataForm" action="<c:url value='${svcUrl}' />" method="post" enctype="multipart/form-data">
	<ap:include page="param/defaultParam.jsp" />
	<ap:include page="param/pagingParam.jsp" />
	<input type="hidden" name="mode" id="mode" value="${param.mode}"/>

	<div class="pop_q_con">
    	<div class="r_top">
   			<h2>결재자 검색</h2>
   		</div>

   		<!-- 결재자 선택 -->
	    <div class="list_zone" style="margin-top: -20px;">
	    	<div class="sub_title sub_title_custom">
				<h4 style="display: inline-block;">결재자 선택</h4>
				<div class="radioBox" style="display: inline-block; float: right; padding-top: 10px;">
					<div style="display: inline-block;">
						<span style="margin-right: 10px;">대체결재자 존재여부 : </span>
						<span id="altrtvSanctnerAt" name="altrtvSanctnerAt" class="altrtvSanctnerAt">N</span>
						<!-- <input type="radio" id="altrtvSanctnerAtY" name="altrtvSanctnerAt" class="altrtvSanctnerAt" value="Y" onclick="return(false);">
						<label class="altrtvSanctnerAtRadio" for="altrtvSanctnerAtY">Y</label> -->
					</div>
					<!-- <div style="display: inline-block; margin-left: 10px;">
						<input type="radio" id="altrtvSanctnerAtN" name="altrtvSanctnerAt" class="altrtvSanctnerAt" value="N" checked="checked" onclick="return(false);">
						<label class="altrtvSanctnerAtRadio" for="altrtvSanctnerAtN">N</label>
					</div> -->
				</div>
			</div>
			<div style="float: right; margin: 0px 10px 5px;">
			</div>
			<table cellspacing="0" border="0" width="90%">
				<colgroup>
					<col width="10%">
					<col width="40%">
					<col width="10%">
					<col width="40%">
				</colgroup>
				<tbody>
					<tr>
						<td class="td_grey">결재자</td>
						<td class="tac">
							<select id="confirmerSelect" class="approvalSelect">
								<option value="">- 선택 -</option>
								<c:forEach var="list" items="${confirmerList}">
									<option value="${list.userNo}-${list.deptCd}">${list.nm} (${list.deptNm})</option>
								</c:forEach>
							</select>
						</td>
						<td class="td_grey" style="height: 25px;">부서명</td>
						<td class="tac">
							<input type="hidden" id="confirmDeptCd"/>
							<input type="text" id="confirmDept" class="box_grey inputWidth" value="" readonly="readonly"/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<!-- 대체결재자 선택  -->
		<div class="list_zone" id="altrtvConfmerDiv" style="display: none;">
			<div class="sub_title sub_title_custom">
				<h4>대체 결재자 정보</h4>
			</div>
			<div class="list_zone">
				<table cellspacing="0" border="0" width="90%">
					<colgroup>
						<col width="15%">
						<col width="35%">
						<col width="15%">
						<col width="35%">
					</colgroup>
					<tbody>
						<tr>
							<td class="td_grey">대체 결재자</td>
							<td class="tac">
								<input type="text" id="altrtvConfirmer" name="altrtvConfirmer" class="box_grey inputWidth" readonly="readonly"/>
								<%-- <select id="altrtvConfirmerSelect" class="approvalSelect">
									<option value="">- 선택 -</option>
									<c:forEach var="list" items="${confirmerList}">
										<option value="${list.userNo}-${list.deptCd}">${list.nm} (${list.deptNm})</option>
									</c:forEach>
								</select> --%>
							</td>
							<td class="td_grey" style="height: 25px;">대체결재 부서명</td>
							<td class="tac">
								<!-- <input type="hidden" id="altrtvConfirmDeptCd"/> -->
								<input type="text" id="altrtvConfirmDept" class="box_grey inputWidth" value="" readonly="readonly"/>
							</td>
						</tr>
						<tr>
							<td class="td_grey" style="height: 25px;">대체결재 시작일</td>
							<td class="tac">
								<%-- <input type="text" name="altrtvConfmBgnDt" id="altrtvConfmBgnDt" value="${rfdResult.get(0).applyDe}" maxlength="10" title="날짜선택" style="width: 78%;"/> --%>
								<input type="text" id="altrtvConfmBgnDt" name="altrtvConfmBgnDt" class="box_grey inputWidth" readonly="readonly"/>
							</td>
							<td class="td_grey">대체결재 종료일</td>
							<td class="tac">
								<%-- <input type="text" name="altrtvConfmEndDt" id="altrtvConfmEndDt" value="${rfdResult.get(0).applyDe}" maxlength="10" title="날짜선택" style="width: 78%;"/> --%>
								<input type="text" id="altrtvConfmEndDt" name="altrtvConfmEndDt" class="box_grey inputWidth" readonly="readonly"/>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>


		<div style="text-align: center; margin-top: 20px;">
			<div style="display: inline-block;">
				<a class="btn_page_admin" href="#none" id="btn_confirmer_create"><span>등록</span></a>
			</div>
		</div>
	</div>
	<!--content//-->
</form>
</body>
</html>