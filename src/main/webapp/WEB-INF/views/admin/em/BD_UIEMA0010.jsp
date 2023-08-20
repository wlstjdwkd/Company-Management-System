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
		
		// 등록
		$("#btn_insert").click(function() {
			jsMsgBox(
					null,
					'confirm',
					'<spring:message code="confirm.common.save" />',
					function() {
						$("#df_method_nm").val("insertDOC");
						var tdCount= $(".tdCount").size();
						$("#tdCount").val(idx);						
						$("#dataForm").submit();
					});
		});	
		
		// 합계 계산
		$(document).on("keyup", ".input_price", function (){
			
			var sum_value = 0;

			$(".input_price").each(function() {
				sum_value += Number($(this).val());
			}); 
			sum_value = sum_value.toLocaleString("ko-KR");
			$(".tot_price").text(sum_value+" 원");
			$("#tot_price").val(sum_value);
				
		});
		
	});
	
	
	var idx = 0;
	//행 추가 버튼
	$(document).on("click","button[id=addbtn]", function() {
		
		idx = $(".tdCount").size();
		
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
	
	//삭제 버튼(행 추가 시 생김)
	$(document).on("click","button[id=delbtn]", function(){
		
		var trHTML = $(this).parent().parent();
		trHTML.remove();
		
	});
	
	
</script>
</head>

<body>
	<form name="dataForm" id="dataForm" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		
		<input type="hidden" name="tot_price" id="tot_price"/>		
			
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
								<td><input name="ad_docno" id="ad_docno" class="th_input" type="text" placeholder="YYMMXX"></td>
								<th scope="row">부 서</th>
								<td><ap:code name="department"  id="department" grpCd="89" type="select"/></td>
								<th scope="row">사원명</th>
								<td><input name="ad_empnm" id="ad_empnm" class="th_input" type="text"></td>
							</tr>
							<tr>
								<th scope="row">작성 일자</th>
								<td><input name="ad_date" id="ad_date" class="th_input" type="text" class="datepicker"></td>
								<th scope="row">금 액</th>
								<td colspan='3' class="price_td">
								<text class="th_input tot_price"></td>
							</tr>
						</table><br>
						<button type="button" class="btn btn-default" id="addbtn">행 추가</button><br>
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
							<input type="hidden" id="tdCount" name="tdCount" />
							<c:set var="k" value="0" />
								<tr id="Td" class="tdCount">
									<td><input class="td_input" name="exp_no" id="exp_no_${k}" type="text" placeholder="지출번호"></td>
									<td><input class="td_input" name="exp_date" id="exp_date_${k}" type="text" placeholder="지출일자"></td>
									<td><input class="td_input" name="ad_item" id="ad_item_${k}" type="text" placeholder="지출 사유"></td>
									<td><input class="td_input" name="ad_shop" id="ad_shop_${k}" type="text" placeholder="상	호"></td>
									<td><input class="td_input input_price"
									 name="ad_price" id="ad_price_${k}" type="text" placeholder="가	격"></td>
									<td><input class="td_input" name="ad_note" id="ad_note_${k}" type="text" placeholder="비고"></td>
									<td></td>
								</tr>
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
							<a class="btn_page_admin" href="#" id="btn_insert"><span>등록</span></a>
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