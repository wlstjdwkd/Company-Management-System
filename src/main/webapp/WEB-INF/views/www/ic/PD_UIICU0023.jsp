<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@	taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,form,validate" />
<ap:jsTag type="tech" items="msg,util,mainn,subb,font,cmn,ic" />
<ap:globalConst />
<script type="text/javascript">
	
	
</script>
</head>
<body>
<!--팝업영역 시작-->
<!-- modal -->
	<div id="diagnosis01" class="modal">
		<div class="modal_wrap w-90">
			<div class="modal_header"> 
				<h1>자가진단</h1>
			</div>
			 <div class="modal_cont">
				<table class="table_form cust03">
					<caption>로그인정보</caption>
					<colgroup>
						<col width="172px">
						<col width="*">
						<col width="172px">
						<col width="*">
					</colgroup>
					<tbody>
						<tr>
							<th>확인신청 대상년도</th>
							<td class="b_l_0"><strong>${targetYear }년</strong></td>
							<th class="bg_gray">자기진단 결과</th>
							<td class="b_l_0"><strong class="t_red">${ST0.STDR_NM }</strong></td>
						</tr>
						<tr>
							<td class="b_l_0" colspan="4" ><strong class="s_strong t_blu">아래 결과는 입력하신 정보를 기준으로 나온 임시 판정 결과입니다.<br/>
							최종결과는 아래 임시 판정 결과와 다를 수 있고 기업 확인 신청 시 담당자가 면밀히 재검토 후 최종 결과를 안내해 드립니다. </strong></td>
						</tr>
					</tbody>
				</table>
				<div class="list_bl">
					<h4 class="fram_bl">주업종</h4>
					<table class="table_form cust03">
						<caption>주업종</caption>
						<colgroup>
							<col width="172px">
							<col width="*">
						</colgroup>
						<tbody>
							<tr>
								<th>주업종</th>
								<td class="b_l_0">${ST0.ENTR_RESULT }</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="list_bl">
					<h4 class="fram_bl">규모기준</h4>
					<table class="table_form cust03">
						<caption>규모기준</caption>
						<colgroup>
							<col width="33.3333%">
							<col width="33.3333%">
							<col width="33.3333%">
						</colgroup>
						<thead>
							<tr>
								<th>기준</th>
								<th>${entrprsNm }</th>
								<th class="bg_gray">적합여부</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="ST1" items="${selfDiagnosisMap['ST1'] }">
			                	<c:catch var="numFmtExc">
			                		<fmt:formatNumber var="entr_val" value="${ST1['ENTR_VAL'] }" pattern="#,###" />
			                	</c:catch>
			                	<tr>
			                        <td>3년평균매출액 <span class="t_blu">${ST1['STDR_NM'] }</span></td>
			                        <td class="p_l_0 t_center">
			                        	<c:if test="${empty numFmtExc }">${entr_val }</c:if>
			                        	<c:if test="${not empty numFmtExc }">${ST1['ENTR_VAL'] }</c:if>
			                        </td>
			                        <td class="p_l_0 t_center">${ST1['ENTR_RESULT'] }</td>
			                    </tr>
			                </c:forEach>
						</tbody>
					</table>
				</div>
				<div class="list_bl">
					<h4 class="fram_bl">상한기준</h4>
					<table class="table_form cust03">
						<caption>상한기준</caption>
						<colgroup>
							<col width="33.3333%">
							<col width="33.3333%">
							<col width="33.3333%">
						</colgroup>
						<thead>
							<tr>
								<th>기준</th>
								<th>${entrprsNm }</th>
								<th class="bg_gray">적합여부</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="ST2" items="${selfDiagnosisMap['ST2'] }">
				                <c:catch var="numFmtExc">
				               		<fmt:formatNumber var="entr_val" value="${ST2['ENTR_VAL'] }" pattern="#,###" />
				               	</c:catch>
				               	<tr>
				                    <td>자산총액 <span class="t_blu">${ST2['STDR_NM'] }</span></td>
				                    <td class="p_l_0 t_center">
				                    	<c:if test="${empty numFmtExc }">${entr_val }</c:if>
				                    	<c:if test="${not empty numFmtExc }">${ST2['ENTR_VAL'] }</c:if>
				                    </td>
				                    <td class="p_l_0 t_center">${ST2['ENTR_RESULT'] }</td>
				                </tr>
				             </c:forEach>
						</tbody>
					</table>
				</div>
				<div class="list_bl">
					<h4 class="fram_bl">독립성기준</h4>
					<table class="table_form cust03">
						<caption>독립성기준</caption>
						<colgroup>
							<col width="33.3333%">
							<col width="33.3333%">
							<col width="33.3333%">
						</colgroup>
						<thead>
							<tr>
								<th>기준</th>
								<th>${entrprsNm }</th>
								<th class="bg_gray">적합여부</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="ST3" items="${selfDiagnosisMap['ST3'] }">
			                	<tr>
			                        <td>${ST3['STDR_NM'] }</td>
			                        <td class="p_l_0 t_center">${ST3['ENTR_VAL'] }</td>
			                        <td class="p_l_0 t_center">${ST3['ENTR_RESULT'] }</td>
			                    </tr>
			                </c:forEach>
			                <c:forEach var="ST4" items="${selfDiagnosisMap['ST4'] }">
			                	<tr>
			                        <td>${ST4['STDR_NM'] }</td>
			                        <td class="p_l_0 t_center">${ST4['ENTR_VAL'] }</td>
			                        <td class="p_l_0 t_center">${ST4['ENTR_RESULT'] }</td>
			                    </tr>
			                </c:forEach>
						</tbody>
					</table>
				</div>
				<div class="list_bl">
					<h4 class="fram_bl">기타 대기업 및 제외법인</h4>
					<table class="table_form cust03">
						<caption>기타 대기업 및 제외법인</caption>
						<colgroup>
							<col width="33.3333%">
							<col width="33.3333%">
							<col width="33.3333%">
						</colgroup>
						<thead>
							<tr>
								<th>기준</th>
								<th>${entrprsNm }</th>
								<th class="bg_gray">적합여부</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="ST5" items="${selfDiagnosisMap['ST5'] }">
			                	<tr>
			                        <td>${ST5['STDR_NM'] }</td>
			                        <td>${ST5['ENTR_VAL'] }</td>
			                        <td>${ST5['ENTR_RESULT'] }</td>
			                    </tr>
			                </c:forEach>
						</tbody>
					</table>
				</div>
			 </div>
		</div>
	 </div>
</body>
</html>