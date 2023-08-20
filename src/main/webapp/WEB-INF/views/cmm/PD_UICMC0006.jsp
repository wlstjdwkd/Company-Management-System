<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<script type="text/javascript">
	window.onload = showPrintGuide();
	
	function showPrintGuide() {
		window.open("/popup/printGuide.html", "printGuide", "width=600,height=650,resizable=no,scrollbars=yes");
	}
	
	function doPrint() {
		this.print();
	}
</script>

<style type="text/css">
	html, body {
		width:100%;
		height:100%;
		margin:0;
		padding:0;
	}
	
	@media print {
		.noprint {display:none; }
	}
	
	.header {
		height:50px;
	}
	
	.button1 {
		position:absolute;
		top:10px;
		left:35px;
		width:100px;
		height:30px;
	}
	
	.button2 {
		position:absolute;
		top:10px;
		left:140px;
		width:100px;
		height:30px;
	}
	
	.footer {
		height:50px;
	}
	
	.watermark {
		background-image:url(/images/report/watermark.jpg);
		background-repeat:no-repeat;
		background-position:center center;
		background-size:400px;
		position:absolute;
		z-index:9999;
		opacity:0.2;
		filter:alpha(opacity:'20');
		top:50px;
		left:0;
		margin:0 auto;
		width:100%;
		height:868px;
	}
	
	#pop_sys_code {
		margin:0 auto;
		width:595px;
		height:842px;
		padding:10px;
		border-style:solid;
		border-color:#999999;
		
		line-height:100%;
		font-size:10px;
		font-family:바탕체;
		font-weight:bold;
	}
	
	h2 {
		line-height:150%;
		font-size:35px;
		text-align:center;
	}
	
	table {
		margin-top:70px;
		line-height:100%;
		font-size:19px;
	}
	
	tr {
		height:43px;
		vertical-align:top;
	}
	
	.bizno {
		font-size:15px;
	}
	
	.addRow {
		height:45px;
	}
	
	th {
		text-align:left;
	}
	
	p {
		line-height:130%;
		font-size:13px;
		font-weight:normal;
	}
	
	.num {
		line-height:70%;
		font-size:18px;
		font-weight:bold;
	}
	
	.command {
		margin-top:70px;
		font-size:17px;
	}
	
	.day {
		margin-top:30px;
		font-size:17px;
		text-align:center;
	}
	
	.ji {
		margin-top:30px;
		line-height:300%;
		font-size:27px;
		font-weight:bold;
		text-align:center;
		background-image:url(/images/report/ji.png);
		background-repeat:no-repeat;
		background-position:75% center;
		background-size:80px;
	}
	
	.bonus {
		margin-top:30px;
		font-family:HY중고딕;
		font-size:16px;
	}
</style>
</head>
<body>
<div class="header noprint">
	<button class="button1" title="인쇄" onclick="doPrint();">인쇄</button>
	<button class="button2" title="인쇄 가이드" onclick="showPrintGuide();">인쇄 가이드</button>
</div>
<div class="watermark"></div>
<div id="pop_sys_code">
	<p class="num">문서확인번호 : ${cerissueVo.docNo}</p>
	<p class="num">발급번호 : ${cerissueVo.issueNo}</p>
	<h2>기업 확인서</h2>
	<table border=0>
		<colgroup>
			<col width="100px">
			<col width="*">
		</colgroup>
		<tbody>
			<tr>
				<th>업 체 명 : </th>
				<td>${cerissueVo.corpNm}</td>
			</tr>
			<tr>
				<th>대표자명 : </th>
				<td>${cerissueVo.ceoNm}</td>
			</tr>
			<tr>
				<th>법인번호 : </th>
				<td>${cerissueVo.juriNo}</td>
			</tr>
			<tr class="bizno">
				<td colspan="2">(사업자등록번호 : ${cerissueVo.corpRegNo}</td>
			</tr>
			<tr class="addRow">
				<th>주&nbsp;&nbsp;&nbsp;&nbsp;소 : </th>
				<td>${cerissueVo.address}</td>
			</tr>
			<tr>
				<th>유효기간 : </th>
				<td>${cerissueVo.expireDe}</td>
			</tr>
		</tbody>
	</table>
	<p class="command">&nbsp;위 업체는「기업 성장촉진 및 경쟁력 강화에 관한 특별법」제2조제1호에 의한 기업임을 확인합니다.</p>
	<p class="day">${cerissueVo.printDe}</p>
	<p class="ji">연합회장</p>
	<p class="bonus">* 「독점규제 및 공정거래에 관한 법률」에 의한 상호출자제한기업집단에 속하는 기업 등 관련법령 등에 의해 판정기준을 벗어나는 경우 이 확인서의 효력은 상실함</p>
</div>
<div class="footer noprint">
</div>
</body>
</html>