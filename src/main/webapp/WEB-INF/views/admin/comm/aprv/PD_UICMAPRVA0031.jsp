<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>한국석유관리원</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask" />
<ap:jsTag type="tech" items="acm,msg,util,ms,etc" />
<link rel="stylesheet" type="text/css" href="/css2/sub.css">
<link rel="stylesheet" type="text/css" href="/css/tab.css">
<link rel="stylesheet" type="text/css" href="/css2/table.css">
<link rel="stylesheet" type="text/css" href="/css/licott.css">
<style type="text/css">
	a {text-decoration: none !important;}
	h4{margin: 0px !important;}
	body {overflow: auto !important;}
	input[type=text] {width: 92%;}
	.selectBox {width: 100% !important;}
	.total {margin-bottom: 0px !important; margin-top: 20px !important;}
	.total .fr {left: 0% !important; bottom: 10%;}
	.row_btn {min-width: 0px !important; margin-top: 2px;}
	.lineuseAtRadio {margin-left: 5px;}
</style>

<script type="text/javascript">

	$().ready(function(){

		//체크박스 하나만 선택
		$(".basisCheckbox").on('click',function(){
			if($(".basisCheckbox").is(':checked') == true){
				$("input[type=checkbox]").prop("checked",false);
				$(this).prop("checked",true);
			}
		});

		//초기 라디오 컨트롤
		var radioVal = $('input:radio[name="lineuseAt"]:checked').val();
		if(radioVal == 'Y'){
			$("#basic").show();
			$("#directInput").hide();
		}else if(radioVal == 'N'){
			$("#basic").hide();
			$("#directInput").show();
		}

		//결재선 적용 여부 컨트롤
		$('input:radio[name="lineuseAt"]').on('change',function(){
			var val = $(this).val();
			if(val == 'Y'){
				$("#basic").slideDown();
				$("#directInput").slideUp();
			}else if(val == 'N'){
				$("#basic").slideUp();
				$("#directInput").slideDown();
			}
		});

		//타이틀 클릭시 슬라이드토글
		/* $("#basicTitle").on('click',function(){
			$("#basic").slideToggle();
		});
		$("#directInputTitle").on('click',function(){
			$("#directInput").slideToggle();
		}); */

		//행클릭
		$("#basisTable tbody tr").on('click',function(){
			var tbody = document.getElementById('detailTbody');
			for(var i = 0; i <= tbody.rows.length; i++){
				tbody.deleteRow(-1);
			}
			var sanctnSeq = $(this).find('td').eq(1).text();
			$.ajax({
				url      : "/PGCMAPRV0010.do",
				type     : "post",
				dataType : "json",
				data	 : {
							"df_method_nm"	: "findDetailProgrs",
							"sanctnSeq" 	: sanctnSeq
							},
				async    : false,
				success  : function(response) {
					try {
						if(response.result) {
							var resultList = response.value.resultList;
							$.each(resultList,function(index,item){
								var i = index + 1;
								var newRow = tbody.insertRow();

								var newCell1 = newRow.insertCell(0);	//결재선 번호 sanctnSeq
								var newCell2 = newRow.insertCell(1);	//결재단계 progrsStep
								var newCell3 = newRow.insertCell(2);	//결재자명 confmerNm
								var newCell4 = newRow.insertCell(3);	//결재자 부서명 confmerDept
								var newCell5 = newRow.insertCell(4);	//대체결재자명  altrtvConfmerNm
								var newCell6 = newRow.insertCell(5);	//대체결재자 부서명 altrtvConfmerDeptNm

								newCell1.innerHTML = '<span class="">'+item.sanctnSeq+'</span>';
								newCell2.innerHTML = '<span id="progrsStep_'+i+'" class="">'+item.progrsStep+'</span>';
								newCell3.innerHTML = '<input type="hidden" value="'+item.confmerId+'"/><span id="confmerNm_'+i+'">'+item.confmerNm+'</span>';
								newCell4.innerHTML = '<input type="hidden" value="'+item.confmerDeptCd+'"/><span id="confmerDept_'+i+'">'+item.confmerDept+'</span>';

								//대체 결재자명
								if(item.altrtvConfmerId != undefined){
									newCell5.innerHTML = '<span id="altrtvConfmerNm_'+i+'">'+item.altrtvConfmerNm+'</span>';
									newCell6.innerHTML = '<span>'+item.altrtvConfmerDeptNm+'</span>';
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

		//기본 결재선 선택 버튼
		$("#btn_line_choice").on('click',function(){
			if($(".basisCheckbox").is(':checked') == false){
				jsMsgBox(null,'info'," 결재선을 선택해주세요.");
			}else{
				//기존 선택했던 결재선 내용 제거
				parent.$("#confirmersInfo > .list_zone").remove();

				//선택한 결재선 html 생성 후 부모창 append
				var trs = $("#detailTbody tr");
				for(var i = 1; i <= trs.length; i++){
					var tds = trs.eq(i-1).find('td');
					var altrtvConfmer = tds.eq(4).find('span').text();
					var altrtv = "";		//대체결재여부

					if(altrtvConfmer == '') altrtv = "N";
					else altrtv = "Y";

					var html = '<div class="list_zone">'
									+'<div class="sub_title">'
									+'<h4>결재자'+i+' 정보</h4>'
									+'</div>'
									+'<table cellspacing="0" border="0" width="90%">'
										+'<colgroup>'
											+'<col width="10%">'
											+'<col width="*">'
											+'<col width="10%">'
											+'<col width="*">'
											+'<col width="10%">'
											+'<col width="*">'
										+'</colgroup>'
										+'<tbody>'
											+'<tr>'
												+'<td class="td_grey">결재자</td>'
												+'<td>'
													+'<input type="hidden" name="pProgrsStep_'+i+'" value="'+i+'"/>'
													+'<input type="hidden" id="pConfirmerNo_'+i+'" name="pConfirmerNo_'+i+'" class="confmerId" value="'+tds.eq(2).find('input').val()+'"/>'
													+'<input type="text" class="box_grey" value="'+tds.eq(2).find('span').text()+'" readonly="readonly"/>'
												+'</td>'
												+'<td class="td_grey">부서명</td>'
												+'<td>'
													+'<input type="hidden" id="pConfirmDeptCd_'+i+'" name="pConfirmDeptCd_'+i+'" value="'+tds.eq(3).find('input').val()+'"/>'
													+'<input type="text" class="box_grey" value="'+tds.eq(3).find('span').text()+'" readonly="readonly"/>'
												+'</td>'
												+'<td class="td_grey">접수승인 상태</td>'
												+'<td class="">'
													+'<input type="text" class="box_grey" readonly="readonly" value=""/>'
												+'</td>'
											+'</tr>'
											+'<tr>'
												+'<td class="td_grey">승인일시</td>'
												+'<td class="">'
													+'<input type="text" class="box_grey" readonly="readonly"/>'
												+'</td>'
												+'<td class="td_grey">대체결재 여부</td>'
												+'<td class="">'
													+'<input type="text" class="box_grey" value="'+altrtv+'" readonly="readonly"/>'
												+'</td>'
												+'<td class="td_grey">대체결재자</td>'
												+'<td class="">'
													+'<input type="text" class="box_grey" value="'+altrtvConfmer+'" readonly="readonly"/>'
												+'</td>'
											+'</tr>'
										+'</tbody>'
								+'</table></div>';
					parent.$("#confirmersInfo").append(html);
				}
				//결재선 번호
				parent.$("#sanctnSeq").val(trs.eq(0).find('td').eq(0).find('span').text());
				parent.$.colorbox.close();
			}
		});

		//-------------------기본결재선 직접 입력
		//행추가 버튼
		$("#btn_add_row").on('click',function(){
			var table = document.getElementById('infoTable');
			var newRow = table.insertRow();
			//var rowIndex = (newRow.rowIndex)-1;

			var newCell1 = newRow.insertCell(0);	//결재 단계
			var newCell2 = newRow.insertCell(1);	//결재자 이름
			var newCell3 = newRow.insertCell(2);	//부서 이름
			var newCell4 = newRow.insertCell(3);	//대결여부
			var newCell5 = newRow.insertCell(4);	//버튼셀

			//결재 단계
			newCell1.innerHTML = '<span></span><input type="hidden" value=""/>';

			//결재자 이름
			newCell2.innerHTML = '<input type="hidden" class="confirmerNo" value=""/><input type="text" class="box_grey inputWidth" value="" readonly="readonly"/>'

			//부서 이름
			newCell3.innerHTML = '<input type="hidden" value=""/><input type="text" class="box_grey inputWidth" value="" readonly="readonly"/>'

			//대결여부
			newCell4.innerHTML = '<input type="text" class="box_grey" value="" style="width : 80%; text-align: center;" readonly="readonly"/><input type="hidden" value=""/>';

			//추가,삭제 버튼
			newCell5.innerHTML = '<a class="btn_page_admin row_btn" href="javascript:void(0)" onclick="addUser(this)">'
									+'<span>선택</span>'
									+'</a>'
									+'<a class="btn_page_admin row_btn" href="javascript:void(0)" onclick="deleteRow(this)">'
									+'<span>삭제</span>'
									+'</a>';

			trChange();
		});

		//기본결재선 직접 입력시 등록 버튼 클릭
		$("#btn_line_create").on('click',function(){
			//validation
			var createCheck = true;
			var confirmNos = $(".confirmerNo");
			$.each(confirmNos,function(){
				var thisVal = $(this).val();
				var seq = $(this).attr('id').substring(12);
				if(thisVal == ''){
					jsMsgBox(null,'info', seq+"번째 결재자를 추가해주세요.");
					createCheck = false;
					return false;
				}
			});

			if(createCheck){
				//부모 창 html append
				//기존 부모창 결재선 내용 제거
				parent.$("#confirmersInfo > .list_zone").remove();
				var trs = $("#infoTbody tr");
				//i = 2 > RA0010에서 사용하는 테이블 그대로 적용하기 위해 display:none 인 tr 하나 존재
				for(var i = 2; i <= trs.length; i++){
					var index = i-1;
					var tds = trs.eq(index).find('td');
					var html = '<div class="list_zone">'
									+'<div class="sub_title">'
									+'<h4>결재자'+(index)+' 정보</h4>'
									+'</div>'
									+'<table cellspacing="0" border="0" width="90%">'
										+'<colgroup>'
											+'<col width="10%">'
											+'<col width="*">'
											+'<col width="10%">'
											+'<col width="*">'
											+'<col width="10%">'
											+'<col width="*">'
										+'</colgroup>'
										+'<tbody>'
											+'<tr>'
												+'<td class="td_grey">결재자</td>'
												+'<td>'
													+'<input type="hidden" name="pProgrsStep_'+index+'" value="'+index+'"/>'
													+'<input type="hidden" id="pConfirmerNo_'+index+'" name="pConfirmerNo_'+index+'" class="confmerId" value="'+tds.eq(1).find('input').eq(0).val()+'"/>'
													+'<input type="text" class="box_grey" value="'+tds.eq(1).find('input').eq(1).val()+'" readonly="readonly"/>'
												+'</td>'
												+'<td class="td_grey">부서명</td>'
												+'<td>'
													+'<input type="hidden" id="pConfirmDeptCd_'+index+'" name="pConfirmDeptCd_'+index+'" value="'+tds.eq(2).find('input').eq(0).val()+'"/>'
													+'<input type="text" class="box_grey" value="'+tds.eq(2).find('input').eq(1).val()+'" readonly="readonly"/>'
												+'</td>'
												+'<td class="td_grey">접수승인 상태</td>'
												+'<td class="">'
													+'<input type="text" class="box_grey" readonly="readonly" value=""/>'
												+'</td>'
											+'</tr>'
											+'<tr>'
												+'<td class="td_grey">승인일시</td>'
												+'<td class="">'
													+'<input type="text" class="box_grey" readonly="readonly"/>'
												+'</td>'
												+'<td class="td_grey">대체결재 여부</td>'
												+'<td class="">'
													+'<input type="text" class="box_grey" value="'+tds.eq(3).find('input').eq(0).val()+'" readonly="readonly"/>'
												+'</td>'
												+'<td class="td_grey">대체결재자</td>'
												+'<td class="">'
													+'<input type="text" class="box_grey" value="'+tds.eq(3).find('input').eq(1).val()+'" readonly="readonly"/>'
												+'</td>'
											+'</tr>'
										+'</tbody>'
								+'</table></div>';
					parent.$("#confirmersInfo").append(html);
				}
				//결재선 번호
				parent.$("#sanctnSeq").val('');
				parent.$.colorbox.close();
			}
		});

	});

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

	//결재자 삭제
	function deleteRow(obj){
		var index = obj.parentNode.parentNode.rowIndex;
		var table = document.getElementById('infoTable');
		table.deleteRow(index);

		trChange();
	}

	//결재 순서 조회 및 id , name 추가 (결재자 검색 후 등록에 필요)
	function trChange(){
		var tr = $("#infoTable tr");
		var length = tr.length;
		var trIndex = length-1;
		for(var i = 1; i < trIndex; i++){
			//접수승인 단계
			tr.eq(i+1).find('td').eq(0).find('span').text("승인"+i);
			tr.eq(i+1).find('td').eq(0).find('input').val(i);
			tr.eq(i+1).find('td').eq(0).find('input').attr('name','progrsStep_'+i);

			//결재자 번호
			tr.eq(i+1).find('td').eq(1).find('input').eq(0).attr('id','confirmerNo_'+i);
			tr.eq(i+1).find('td').eq(1).find('input').eq(0).attr('name','confirmerNo_'+i);
			tr.eq(i+1).find('td').eq(1).find('input').eq(1).attr('id','confirmer_'+i);
			tr.eq(i+1).find('td').eq(1).find('input').eq(1).attr('name','confirmer_'+i);

			//부서 코드
			tr.eq(i+1).find('td').eq(2).find('input').eq(0).attr('id','confirmDeptCd_'+i);
			tr.eq(i+1).find('td').eq(2).find('input').eq(0).attr('name','confirmDeptCd_'+i);
			tr.eq(i+1).find('td').eq(2).find('input').eq(1).attr('id','confirmDept_'+i);
			tr.eq(i+1).find('td').eq(2).find('input').eq(1).attr('name','confirmDept_'+i);

			//대결여부
			tr.eq(i+1).find('td').eq(3).find('input').eq(0).attr('id','altrtvSanctnerAt_'+i);
			//대체결재자명
			tr.eq(i+1).find('td').eq(3).find('input').eq(1).attr('id','altrtvConfmerNm_'+i);
		}
	}
</script>

</head>
<body>
<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post" enctype="multipart/form-data">
	<ap:include page="param/defaultParam.jsp" />
	<ap:include page="param/pagingParam.jsp" />

	<input type="hidden" id="exitEctccNo" name="ectccNo" value="${ectccNo}"/>

	<div class="pop_q_con">
    	<div class="r_top">
   			<h2 style="display: inline-block;">결재선 정보</h2>
   			<div style="display: inline-block; float: right; margin-top: 20px; margin-right: 10px;">
				<div style="display: inline-block;">
					<span style="margin-right: 10px; font-size: 15px;">기본 결재선 적용여부 : </span>
					<input type="radio" id="lineuseAtY" name="lineuseAt" value="Y" checked="checked"><label class="lineuseAtRadio" for="lineuseAtY">Y</label>
				</div>
				<div style="display: inline-block; margin-left: 10px;">
					<input type="radio" id="lineuseAtN" name="lineuseAt" value="N"><label class="lineuseAtRadio" for="lineuseAtN">N</label>
				</div>
			</div>
   		</div>

		<!-- 결재선 기본 정보 -->
		<div class="sub_title" style="display: inline-block; margin: 0px;">
			<h4 style="display: inline-block;" id="basicTitle">기본 결재선 정보</h4>
		</div>
		<div id="basic">
			<div class="block">
				<ap:pagerParam addJsRowParam="null,'getChoiceLine'"/>
				<div class="list_zone">
					<div style="overflow-x:auto; min-width:800px;">
						<table id="basisTable" style="white-space:nowrap" cellspacing="0" border="0">
							<colgroup>
								<col width="5%" />
								<col width="10%" />
								<col width="50%" />
								<col width="15%" />
								<col width="20%" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">선택</th>
									<th scope="col">결재선 번호</th>
									<th scope="col">결재선명</th>
									<th scope="col">기안자</th>
									<th scope="col">부서</th>
								</tr>
							</thead>
							<tbody>
								<c:choose>
									<c:when test="${fn:length(resultList) == 0}">
										<tr>
											<td colspan="5">
												조회 결과가 없습니다.
											</td>
										</tr>
									</c:when>
									<c:otherwise>
										<c:forEach var="list" items="${resultList}" varStatus="status">
											<tr id="basis_${status.index}">
												<td><input class="basisCheckbox" type="checkbox" value="${status.index}" /></td>
												<td id="seq_${status.index}">${list.sanctnSeq}</td>
												<td class="tal">${list.sanctnNm}</td>
												<td class="tal">${list.drafterNm}</td>
												<td class="tal">${list.drafterDeptNm}</td>
											</tr>
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</tbody>
						</table>
					</div>
				</div>
				<div>
		            <ap:pager pager="${pager}" addJsParam="'getChoiceLine'"/>
				</div>
			</div>

			<!-- 결재선 상세정보 -->
			<div class="list_zone">
				<div style="overflow-x: auto; min-width: 800px;">
					<table id="detailTable" style="white-space: nowrap"
						cellspacing="0" border="0">
						<colgroup>
							<col width="10%"/>
							<col width="10%"/>
							<col width="15%"/>
							<col width="25%"/>
							<col width="15%"/>
							<col width="25%"/>
						</colgroup>
						<thead>
							<tr>
								<th scope="col">결재선 번호</th>
								<th scope="col">접수승인단계</th>
								<th scope="col">결재자</th>
								<th scope="col">결재자 부서명</th>
								<th scope="col">대체 결재자</th>
								<th scope="col">대체 결재자 부서명</th>
							</tr>
						</thead>
						<tbody id="detailTbody">
							<tr id="emptyTr">
								<td colspan="6">조회 결과가 없습니다.</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>

			<div style="text-align: center; margin-top: 20px;">
				<div style="display: inline-block;">
					<a class="btn_page_admin" href="javascript:void(0)" id="btn_line_choice"><span>선택</span></a>
				</div>
			</div>
		</div>

		<!-- 결재선 직접입력 -->
		<div class="sub_title" style="margin: 0px; margin-top: 20px;">
			<h4 id="directInputTitle">결재선 직접입력</h4>
		</div>
		<div id="directInput" class="list_zone">
			<div style="overflow-x:auto;">
				<div style="float: right;">
					<a href="javascript:void(0)" id="btn_add_row" class="btn_page_admin"><span>행추가</span></a>
				</div>
				<table id="infoTable" style="white-space:nowrap" cellspacing="0" border="0">
					<colgroup>
						<col width="10%" />
						<col width="29%" />
						<col width="39%" />
						<col width="10%" />
						<col width="12%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">접수승인 단계</th>
							<th scope="col">결재자 이름</th>
							<th scope="col">부서 이름</th>
							<th scope="col">대결여부</th>
							<th scope="col">선택</th>
						</tr>
					</thead>
					<tbody id="infoTbody">
						<!-- RA0010에서 사용하는 테이블 그대로 적용하기 위해 display:none 인 tr 하나 존재 -->
						<tr style="display: none;">
							<td colspan="5"></td>
						</tr>
						<!-- 결재자정보 (고정) -->
						<tr id="confirmerTr" style="height: 40px;">
							<td><span>승인1</span></td>
							<td class="tal">
								<input type="hidden" id="confirmerNo_1" class="confirmerNo" name="confirmerNo_1"/>
								<input type="text" id="confirmer_1" name="confirmer_1" class="box_grey inputWidth" readonly="readonly"/>
							</td>
							<td class="tal">
								<input type="hidden" id="confirmDeptCd_1" name="confirmDeptCd_1"/>
								<input type="text" id="confirmDept_1" name="confirmDept_1" class="box_grey inputWidth" readonly="readonly" style="margin-left: 5px;"/>
							</td>
							<td>
								<input type="text" id="altrtvSanctnerAt_1" class="box_grey" value="" style="width : 80%; text-align: center;" readonly="readonly"/>
								<input type="hidden" id="altrtvConfmerNm_1" class="box_grey" value="" style="width : 80%; text-align: center;" readonly="readonly"/>
							</td>
							<td style="width: 110px; padding: 5px 0px 0px 0px;">
								<a class="btn_page_admin row_btn" href="javascript:void(0)" onclick="addUser(this)"><span>선택</span></a>
								<!-- <a class="btn_page_admin row_btn" href="javascript:void(0)"><span>삭제</span></a> -->
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div style="text-align: center; margin-top: 20px;">
				<div style="display: inline-block;">
					<a class="btn_page_admin" href="javascript:void(0)" id="btn_line_create"><span>등록</span></a>
				</div>
			</div>
		</div>
	</div>
	<!--content//-->
</form>
</body>
</html>