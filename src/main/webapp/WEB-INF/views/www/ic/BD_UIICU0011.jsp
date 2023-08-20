<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="com.infra.util.StringUtil" %>
<%@ page import="com.infra.system.GlobalConst" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>확인절차안내|기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery, form" />
<ap:jsTag type="tech" items="cmn, mainn, subb, font, util, ic" />
<ap:globalConst />
<% 
	StringUtil stringUtil = new StringUtil();
	
	String issu_phone_num = GlobalConst.ISSU_PHONE_NUM;
	
	Map<String,String> num = stringUtil.telNumFormat(issu_phone_num);
	
	String ISSU_PHONE_NUM_FIRST = num.get("first");
	String ISSU_PHONE_NUM_MIDDLE = num.get("middle");
	String ISSU_PHONE_NUM_LAST = num.get("last");
	
%>
</head>
<body>
<form name="dataForm" id="dataForm" method="post">
    <ap:include page="param/defaultParam.jsp" />
    <ap:include page="param/dispParam.jsp" />
    <!--//content-->
    <div id="wrap">
        <div class="s_cont" id="s_cont">
		<div class="s_tit s_tit02">
			<h1>기업확인</h1>
		</div>
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit tit2">기업확인</h2>
				<ul>
				</ul>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}" />
				</div>
				<div class="r_cont s_cont02_02">
					<div class="list_bl">
						<h4 class="fram_bl">신청기업 </h4>
						<table class="table_bl3">
							<caption>신청기업</caption>
							<thead>
								<tr>
									<th>신청기업</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>
										<ul class="num_list">
											<li>법인등기부 등본</li>
											<li>직전 사업연도 말 주주명부</li>
											<li>직전 3개사업연도 감사보고서 또는 표준재무제표증명원</li>
										</ul>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="list_bl">
						<h4 class="fram_bl">신규·분할·합병 등의 경우 </h4>
						<table class="table_bl3">
							<caption>신규·분할·합병 등의 경우 </caption>
							<colgroup>
								<col width="50%">
								<col width="50%">
							</colgroup>
							<thead>
								<tr>
									<th>직전 사업연도에 발생한 경우 </th>
									<th>해당 사업연도에 발생한 경우</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>
										<ul class="num_list">
											<li>창업·분할·합병 발생 당시 주주명부</li>
											<li>직전 사업연도 말 주주명부</li>
											<li>법인등기부 등본(말소사항 포함)</li>
											<li>발생일부터 신청일까지의 월별 매출액 증빙서류(손익계산서 등)</li>
											<li>직전 사업연도 감사보고서 또는 표준재무제표증명원</li>
										</ul>
									</td>
									<td>
										<ul class="num_list">
											<li>창업·분할·합병 발생 당시 주주명부</li>
											<li>신청일 당시 주주명부</li>
											<li>법인등기부 등본</li>
											<li>발생일부터 신청일까지의 월별 매출액 증빙서류(손익계산서 등)</li>
										</ul>
										</td>
								</tr>
								<tr>
										<td colspan="2">
										<ul>
											<center><li>신규·분할·합병 등의 경우이면서, 관계기업이 있는 경우 → <strong>3. 관계기업(지배·종속기업)이 있는 경우 참고</strong></li></center>
										</ul>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="list_bl">
						<h4 class="fram_bl">관계기업(지배·국내종속기업)이 있는 경우</h4>
						<table class="table_bl3">
							<caption>관계기업(지배·국내종속기업)이 있는 경우</caption>
							<tbody>
								<tr>
									<th>관계기업(지배·국내종속기업)</th>
								</tr>
								<tr>
									<td style="border-bottom: 1px solid #222;">
										<ul class="num_list">
											<li>직전 사업연도 말 주주명부</li>
											<li>직전 3개사업연도 감사보고서 또는 표준재무제표증명원</li>
										</ul>
									</td>
								</tr>
								<tr>
									<th>지배기업이 해외법인인 경우</th>
								</tr>
								<tr>
									<td>
										<ul class="num_list">
											<li>직전 사업연도 말 최상위 지배기업(직·간접 지분관계가 30% 이상)까지 지분관계 증빙</li>
											<li>최상위 지배기업까지 각 법인의 직전 사업연도 개별 자산규모(Total Assets) 증빙<br/>(예시) Annual Report, Financial Report, Balanced Sheet, List of Shareholders, List of Subsidiaries, 유가증권보고서(일본) 등</li>
										</ul>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="list_bl bg_gray">
						<div class="left">
							<h3>공통안내</h3>
						</div>
						<div class="right">
							<p>* 주주명부 : 요약 주주명부 또는 주식등변동상황명세서로 대체가능, 원본대조필, 개인정보 제외)</p>
							<p>* 외부감사대상기업은 감사보고서, 비외감기업은 표준재무제표증명원</p>
							<p>* 전자공시대상기업(dart.fss.or.kr)은 감사보고서 제출 생략 가능</p>
						</div>
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