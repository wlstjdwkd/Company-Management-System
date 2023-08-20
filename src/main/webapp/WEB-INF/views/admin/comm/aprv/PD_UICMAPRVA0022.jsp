<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>석유관리원 환급시스템</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask" />
<ap:jsTag type="tech" items="acm,msg,util,ms,etc" />
<script type="text/javascript">

	$(document).ready(function(){
		
		var pUserNo = "";
		var pUserNm = "";
		var pDeptCd = "";
		var pDeptNm = "";

		//대체결재자 선택시 부서명 자동입력
		$(".altrtvConfmerSelect").on('change',function(){
			
			var id = $(this).attr('id');
			var val = $(this).val();
			
			if(val == '' || val == null){
				if(id == 'altrtvConfmerSelect'){
					$("#altrtvConfmerDeptCd").val('');
					$("#altrtvConfmerDeptNm").val('');
				}
			} else {
				var divIndex = val.indexOf("-");
				var userNo = val.substring(0,divIndex);
				var deptCd = val.substring((divIndex+1),val.length);

				var deptNmText = "";
				if(id == 'altrtvConfmerSelect') deptNmText = $("#altrtvConfmerSelect option:selected").text();

				var deptNmStartIndex = deptNmText.indexOf("(");
				var deptNmEndIndex = deptNmText.indexOf(")");
				var deptNm = deptNmText.substring((deptNmStartIndex+1),deptNmEndIndex);

				if(id == 'altrtvConfmerSelect'){
					//부모창 넘길 텍스트 저장
					pUserNo = userNo;
					pUserNm = deptNmText.substring(0,(deptNmStartIndex-1));
					pDeptCd = deptCd;
					pDeptNm = deptNm;

					$("#altrtvConfmerDeptCd").val(deptCd);
					$("#altrtvConfmerDeptNm").val(deptNm);
				}
			}
		});
		
		$("#btn_choice").on('click',function(){
			
			var altrtvConfmer = $("#altrtvConfmerSelect").val();
			if(altrtvConfmer == '' || altrtvConfmer == null){
				jsMsgBox($(this),'info',"대체결재자를 선택해주세요.");
				return;
			}
			
			parent.document.getElementById("altrtvConfmerId").value = pUserNo;
			parent.document.getElementById("altrtvConfmerNm").value = pUserNm;
			parent.document.getElementById("altrtvConfmerDeptCd").value = pDeptCd;
			parent.document.getElementById("altrtvConfmerDeptNm").value = pDeptNm;

			parent.$.colorbox.close();
		});
		
	});

</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<div class="pop_q_con">
	    	<div class="r_top">
	   			<h2>대체결재자 검색</h2>
	   		</div>
		</div>
		<div class="list_zone">
	    	<div class="sub_title">
				<h4>대체결재자 선택</h4>
			</div>
			<table>
				<colgroup>
					<col width="20%">
					<col width="30%">
					<col width="20%">
					<col width="30%">
				</colgroup>
				<tbody>
					<tr>
						<td class="td_grey">대체결재자</td>
						<td>
							<select id="altrtvConfmerSelect" class="altrtvConfmerSelect" style="width : 100%">
								<option value="">- 선택 -</option>
								<c:forEach var="list" items="${altrtvConfmerList}">
									<option value="${list.userNo}-${list.deptCd}">${list.nm} (${list.deptNm})</option>
								</c:forEach>
							</select>
						</td>
						<td class="td_grey">부서</td>
						<td>
							<input type="hidden" id="altrtvConfmerDeptCd"/>
							<input type="text" class="box_grey" style="width : 90%" id="altrtvConfmerDeptNm" readonly="readonly"/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div style="margin-top:20px; text-align: center;">
			<a class="btn_page_admin" href="#none" id="btn_choice"><span>확인</span></a>
		</div>
	</form>
</body>
</html>