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
<title>기업 종합정보시스템</title>	
<ap:jsTag type="web" items="jquery,form,validate" />
<ap:jsTag type="tech" items="cmn, mainn, subb, font,util" />

<script type="text/javascript">

</script>
</head>

<body>
<form name="dataForm" id="dataForm" method="post">
<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />

<!--//content-->
<div id="wrap">
	<div class="s_cont" id="s_cont">
		<div class="s_tit s_tit01">
			<h1>기업현황</h1>
		</div>
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit">기업현황</h2>
				<ul>
				</ul>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}" />
				</div>
				<div class="r_cont s_cont01_01" style="padding-bottom: 170px;">
					<p class="bg_txt">공공기관, 지방공기업 금융·보험 및 연금업//공정거래법상 상호출자제한기업진단//중소기업기본법상 중소기업//기업법상 기업//기업법상 기업 후보기업</p>
					<div class="list_bl">
						<h4 class="fram_bl">기업 제외대상</h4>
						<ul class="num_list">
							<li>상호출자제한기업집단에 속하는 기업</li>
							<li>상호출자제한기업집단 지정기준(자산총액 10조원) 이상인 기업 또는 법인(외국법인 포함)이 해당 기업의 주식<br> 또는 출자지분의 30% 이상을 직·간접적으로 소유하면서 최다출자자인 기업</li>
							<li>「중소기업기본법」에 따른 중소기업</li>
							<li>「공공기관 운영에 관한 법률」에 따른 공공기관</li>
							<li>「지방공기업법」에 따른 지방공기업</li>
							<li>「민법」 제32조에 따른 비영리법인</li>
							<li>「통계법」 제22조에 따라 통계청장이 고시하는 한국표준산업분류에 따른 금융업, 보험 및 연금업, 금융 및 보험 관련 서비스업을 영위하는 기업 (일반지주회사는 제외대상이 아님)</li>
						</ul>
						<p class="comment">※ 자본시장과 금융투자업에 관한 법률」 제9조제19항에 따른 사모집합투자기구 또는<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;「기업구조조정 촉진법」 제2조제3호에 따른 채권금융기관이 최다출자자인 기업은 제외대상이 아님</p>
					</div>
					<div class="list_bl">
						<h4 class="fram_bl">기업 후보기업 범위</h4>
						<ul class="num_list">
							<li>「중소기업기본법」 제2조제3항 본문에 따라 중소기업으로 보는 기업</li>
							<li>
								해당 기업이 영위하는 주된 업종과 그 기업의 직전 사업연도의 매출액이 기업 후보기업 기준에 맞는 중소기업으로서 다음 각 목의 어느 하나에 해당하는 기업. 이 경우 하나의 기업이 둘 이상의 서로 다른 업종을 영위하는 때에는 직전 사업연도 매출액의 비중이 가장 큰 업종을 주된 업종으로 본다.
								<ul>
									<li>직전 3개 사업연도 동안의 매출액 연평균 증가율 값이 15% 이상인 기업</li>
									<li>직전 3개 사업연도 동안의 매출액 연평균 증가율 값이 15% 이상인 기업</li>
								</ul>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!--content//-->
</form>

</body>
</html>