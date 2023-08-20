<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>	
<ap:jsTag type="web" items="jquery,form" />
<ap:jsTag type="tech" items="msg,util,cmn, mainn, subb, font,ic, etc" />
<ap:globalConst />
<c:set var="entUserVo" value="${sessionScope[SESSION_ENTUSERINFO_NAME]}" />
<c:set var="today" value="<%= new Date(new Date().getTime()) %>" />
<c:set var="comDate" value="<%= new Date(new Date().getTime() + 60*60*24*1000*10) %>" />
<fmt:formatDate var="todayPat" value="${today}" pattern="yyyy년 MM월 dd일" type="DATE" />
<fmt:formatDate var="comPatDate" value="${comDate}" pattern="yyyy년 MM월 dd일" type="DATE" />
<script type="text/javascript">
$(document).ready(function(){
	
});
</script>
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
	
				<!--//우측영역 -->
				<div class="r_cont s_cont02_06">
					<div class="step_sec">
						<ul>
							<li>1.기본확인</li><!--공백제거
							--><li class="arr"> </li><!--공백제거
							--><li>2.약관동의</li><!--공백제거
							--><li class="arr"></li><!--공백제거
							--><li>3.신청서작성</li><!--공백제거
							--><li class="arr"></li><!--공백제거
							--><li class="on">4.신청완료</li>
						</ul>
					</div>
					<div class="list_bl">
						<table class="table_form">
							<caption>기업정보</caption>
							<colgroup>
								<col width="172px">
								<col width="273px">
								<col width="173px">
								<col width="272px">
							</colgroup>
							<tbody>
								<tr>
									<td colspan="4" class="result_blank">
										<img src="/images2/sub/check/check_complete_img01.png">
										<div><p>${entUserVo.entrprsNm}(기업회원) ${entUserVo.chargerNm}님!!</p><p>정상적으로 기업확인 신청이 접수 되었습니다.<br/>
										빠른 시일 내에 최종 결과를 받아 보실 수 있도록 노력하겠습니다. <br/>좋은 하루 보내세요.</p></div>
									</td>
								</tr>
								<tr>
									<th class="p_l_30">담당</th>
									<td class="b_l_0">연합회</td>
									<th class="p_l_30">접수번호</th>
									<td class="b_l_0">${param.ad_comp_rcept_no}</td>
								</tr>
								<tr>
									<th class="p_l_30">접수일</th>
									<td class="b_l_0">${todayPat}</td>
									<th class="p_l_30">발급 예정일</th>
									<td class="b_l_0">${comPatDate}</td>
								</tr>
								<tr>
									<td class="b_l_0 p_l_30" colspan="4">
										※ 기업 확인요령에 따른 기업 확인서 발급처리기간은 신청일로부터 20일 이내이며, 통상적으로 1~2주의 기간이 소요됩니다.<br/>
										※ <span class="b_txt">고객지원 - 자주하는 질문/묻고답하기</span>를 통해 문의해 주시기 바랍니다.
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="list_bl">
						<p class="list_noraml">신청서 내용 및 제출서류가 미비할 경우 보완요청되어, 발급이 지연될 수 있습니다.</p>
						<p class="list_noraml">보완요청 및 발급완료 시, 회원정보에 입력하신 연락처/이메일로 안내드리오니 회원정보를 확인해주십시오.</p>
						<p class="list_noraml">기업확인서 발급 진행상황은 <strong>기업확인 > 신청내역조회</strong>에서 확인하실 수 있습니다.</p>
					</div>
					<div class="btn_bl">
						<a href="${PUB_INDEX_URL}" class="blu">홈</a>
						<a href="#none" onclick="jsMoveMenu('7', '120', 'PGMY0060');">신청내역조회</a>
						
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</form>
</body>
</html>