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


<style>
  .th_input {
  	height: 30px;
  	border: none;
  }
  .td_input {
  	border: none;
  	width : 90%;
  }
  table {
    width: 80%;
    border: 1px solid #444444;
    
  }
  th {
    border: 1px solid #444444;
    text-align: center;
    background-color: #dcecf7;
  }
  td {
  	border: 1px solid #444444;
  }
  .price_td{
  	font-size: 20px;
  	text-align: center;
  }
  .input_price{
  	text-align: right;
  	margin-right: 15px;
  }
  .tot_price{
  	margin-right: 15px;
  }
</style>


<script type="text/javascript">
	$(document).ready(function() {
		

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
						$("#df_method_nm").val("updateDOC");
						//tdCount
						var tdCount= $(".tdCount").size();
						$("#tdCount").val(tdCount);
						//Delinfo
						$("#delinfo").val(Delinfo);
						$("#dataForm").submit();
					});
		});
		
		// 삭제
		$("#btn_progrm_delete").click(function() {
			jsMsgBox(
					null,
					'confirm',
					'<spring:message code="confirm.common.delete" />',
					function() {
						$("#df_method_nm").val("deleteAll");
						$("#dataForm").submit();
					});
		});
		
		
		// 합계 계산
		$(document).on("keyup", ".input_price", function (){
			$(".tot_price").each(function() {
				
				var $this = $(this);
				var sum_value = 0;
				
				$(".input_price").each(function(i, e) {
					
					sum_value += parseInt($(e).val());				
				});
				sum_value = sum_value.toLocaleString("ko-KR");
				$this.text(sum_value+" 원");
				$("#tot_price").val(sum_value);
				
			});
		});
		 
	});

	//행 추가 버튼
	$(document).on("click","button[id=addbtn]", function() {
		
		var idx = $(".tdCount").size();
		
		var addTEXT= '<tr id="Td_'+ idx +'" class="tdCount">'+
			'	<td><input class="td_input" name="exp_no" id="exp_no_'+ idx +'" type="text"></td>'+
			'	<td><input class="td_input" name="exp_date" id="exp_date_'+ idx +'" type="text"></td>'+
			'	<td><input class="td_input" name="ad_item" id="ad_item_'+ idx +'" type="text"></td>'+
			'	<td><input class="td_input" name="ad_shop" id="ad_shop_'+ idx +'" type="text"></td>'+
			'	<td><input class="td_input input_price" name="ad_price" id="ad_price_'+ idx +'" type="text" value="0"></td>'+
			'	<td><input class="td_input" name="ad_note" id="ad_note_'+ idx +'" type="text"></td>'+
			'	<td><button type="button" class="btn btn-default" id="delbtn">삭제</button></td>'+
			'</tr>';
		console.log("idx: "+idx);
		
		var trHTML = $("tr[class=tdCount]:last");
		trHTML.after(addTEXT);
		
	});
	
	var Delinfo = [];
	
	//삭제 버튼(행 추가 시 우측에 생성)
	$(document).on("click","button[id=delbtn]", function(){
		
		var thisRow = $(this).closest('tr');
		var no = thisRow.find('td:eq(0)').find('input').val();
		Delinfo.push(no);
		console.log(Delinfo);
		
		var trHTML = $(this).parent().parent();
		trHTML.remove();
		
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
		
		<input type="hidden" name="tot_price" id="tot_price"/>
		<input type="hidden" name="delinfo" id="delinfo"/>		
			
		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<div class="block">
						<!-- 테이블 -->
						<table cellpadding="0" cellspacing="0" summary="품의서 윗단">
							<caption>품의서 윗단</caption>
							<colgroup>
								<col width="15%" />
								<col width="*" />
								<col width="15%" />
								<col width="*" />
								<col width="15%" />
								<col width="*" />
							</colgroup>
							<tr>
								<th colspan='6'><text style="font-size: 30px;">(지출 입금 대체) 품의서-법인</td>
							</tr>
							<tr>
								<th scope="row">문서번호</th>
								<td><input name="ad_docno" id="ad_docno" class="th_input" type="text" value="${TOPInfo.DOCU_NO}"></td>
								<th scope="row">부 서</th>
								<td><input name="departmentname" id="departmentname" class="th_input" type="text" value="${deptInfo.codeNm}"></td>
								<th scope="row">사원명</th>
								<td><input name="ad_empnm" id="ad_empnm" class="th_input" type="text" value="${TOPInfo.EMP_NM}"></td>
							</tr>
							<tr>
								<th scope="row">작성 일자</th>
								<td><input name="ad_date" id="ad_date" class="th_input" type="text" class="datepicker" value="${TOPInfo.DATE}"></td>
								<th scope="row">금 액</th>
								<td colspan='3' class="price_td">
								<text class="th_input tot_price" value="${TOPInfo.PRICE}"></td>
							</tr>
						</table><br>
						<button type="button" class="btn btn-default" id="addbtn">행 +</button><br>
						<table cellpadding="0" cellspacing="0" summary="품의서 아랫단">
							<caption>품의서 아랫단</caption>
							<colgroup>
								<col width="7%" />
								<col width="8%" />
								<col width="30%" />
								<col width="15%" />
								<col width="15%" />
								<col width="20%" />
								<col width="5%" />
							</colgroup>
							<thead>
								<tr>
									<th>번	호</th>
									<th>일	자</th>
									<th>내	역</th>
									<th>상	호</th>
									<th>금	액</th>
									<th>비	고</th>
									<th></th>
								</tr>
							</thead>
							<tbody>
							<c:forEach var="BOTInfo" items="${BOTInfo}">
							<input type="hidden" id="tdCount" name="tdCount" />
							<c:set var="k" value="0" />
								<tr id="Td" class="tdCount">
									<td><input class="td_input" name="exp_no" id="exp_no_${k}" type="text" placeholder="지출번호" value="${BOTInfo.DOCU_NO}"></td>
									<td><input class="td_input" name="exp_date" id="exp_date_${k}" type="text" placeholder="지출일자" value="${BOTInfo.DATE}"></td>
									<td><input class="td_input" name="ad_item" id="ad_item_${k}" type="text" placeholder="지출 사유" value="${BOTInfo.ITEM}"></td>
									<td><input class="td_input" name="ad_shop" id="ad_shop_${k}" type="text" placeholder="상	호" value="${BOTInfo.SHOP}"></td>
									<td><input class="td_input input_price"
									 name="ad_price" id="ad_price_${k}" type="text" placeholder="가	격" value="${BOTInfo.PRICE}"></td>
									<td><input class="td_input" name="ad_note" id="ad_note_${k}" type="text" placeholder="비고"  value="${BOTInfo.NOTE}"></td>
									<td><button type="button" class="btn btn-default" id="delbtn">삭제</button></td>
								</tr>
							</c:forEach>
								<tr>
									<td colspan="3"></td>
									<td style="font-weight: bold; text-align: center;"><span>합	계</span></td>
									<td style="text-align: right;"><text class="tot_price"></td>
									<td colspan="2"></td>
								</tr>
							
							</tbody>		
						</table>					
					</div>
					<div class="block" style="width:80%;">
					<!-- 리스트// -->
						<div class="btn_page_last">
							<a class="btn_page_admin" href="#" id="btn_progrm_list"><span>목록</span></a> 
							<a class="btn_page_admin" href="#" id="btn_progrm_delete"><span>전체 삭제</span></a> 
							<a class="btn_page_admin" href="#" id="btn_progrm_update"><span>수정 완료</span></a>
							
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