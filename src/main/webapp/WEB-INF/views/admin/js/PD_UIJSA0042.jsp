<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>확정판정보기 및 등록</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,multifile" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javaScript">
	$(document).ready(function() {
		
	});
</script>
</head>
<body>

<div id="self_dgs">
	<div class="pop_q_con">
			<h3>데이터업로드</h3>
			<table cellpadding="0" cellspacing="0" class="table_basic" summary="상세보기">
				<caption>상세보기</caption>
				<colgroup>
					<col width="30%" />
					<col width="*" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">법인등록번호</th>
						<td>${fn:substring(rcpyJdgmntInfo.entrprsJurirno, 0, 6)}-${fn:substring(rcpyJdgmntInfo.entrprsJurirno, 6, 13)}</td>
					</tr>
					<tr>
						<th scope="row">기업명</th>
						<td>${rcpyJdgmntInfo.entrprsNm}</td>
					</tr>
					<tr>
						<th scope="row">기업업종코드</th>
						<td>${rcpyJdgmntInfo.entrprsIndutyCode}</td>
					</tr>
					<tr>
						<th scope="row">매출액1</th>
						<td class="tar"><fmt:formatNumber value = "${rcpyJdgmntInfo.entrprsSelngAm1}" pattern = "#,##0"/></td>
					</tr>
					<tr>
						<th scope="row">매출액2</th>
						<td class="tar"><fmt:formatNumber value = "${rcpyJdgmntInfo.entrprsSelngAm2}" pattern = "#,##0"/></td>
					</tr>
					<tr>
						<th scope="row">매출액3</th>
						<td class="tar"><fmt:formatNumber value = "${rcpyJdgmntInfo.entrprsSelngAm3}" pattern = "#,##0"/></td>
					</tr>
					<tr>
						<th scope="row">매출액4</th>
						<td class="tar"><fmt:formatNumber value = "${rcpyJdgmntInfo.entrprsSelngAm4}" pattern = "#,##0"/></td>
					</tr>
					<tr>
						<th scope="row">매출액5</th>
						<td class="tar"><fmt:formatNumber value = "${rcpyJdgmntInfo.entrprsSelngAm5}" pattern = "#,##0"/></td>
					</tr>
					<tr>
						<th scope="row">매출액6</th>
						<td class="tar"><fmt:formatNumber value = "${rcpyJdgmntInfo.entrprsSelngAm6}" pattern = "#,##0"/></td>
					</tr>
					<tr>
						<th scope="row">3년평균매출액1</th>
						<td class="tar"><fmt:formatNumber value = "${rcpyJdgmntInfo.y3avgSelngAm1}" pattern = "#,##0"/></td>
					</tr>
					<tr>
						<th scope="row">3년평균매출액2</th>
						<td class="tar"><fmt:formatNumber value = "${rcpyJdgmntInfo.y3avgSelngAm2}" pattern = "#,##0"/></td>
					</tr>
					<tr>
						<th scope="row">3년평균매출액3</th>
						<td class="tar"><fmt:formatNumber value = "${rcpyJdgmntInfo.y3avgSelngAm3}" pattern = "#,##0"/></td>
					</tr>
					<tr>
						<th scope="row">3년평균매출액4</th>
						<td class="tar"><fmt:formatNumber value = "${rcpyJdgmntInfo.y3avgSelngAm4}" pattern = "#,##0"/></td>
					</tr>
					<tr>
						<th scope="row">판정업종코드</th>
						<td>${rcpyJdgmntInfo.jdgmntIndutyCode}</td>
					</tr>
					<tr>
						<th scope="row">합산매출액</th>
						<td class="tar"><fmt:formatNumber value = "${rcpyJdgmntInfo.adupSelngAm}" pattern = "#,##0"/></td>
					</tr>
				</tbody>
			</table>
			
			<div class="list_zone" style="margin-top:10px;">
				<h3>상위그룹</h3>
				<table cellspacing="0" border="0" summary="상위그룹목록" class="list">
					<caption>상위그룹목록</caption>
					<colgroup>
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">상위법인등록번호</th>
							<th scope="col">상위기업명</th>
							<th scope="col">상위지분율</th>
							<th scope="col">상위기업업종코드</th>
							<th scope="col">상위3년평균매출액</th>
							<th scope="col">최상위법인등록번호</th>
							<th scope="col">최상위기업명</th>
							<th scope="col">최상위지분율</th>
							<th scope="col">최상위기업업종코드</th>
							<th scope="col">최상위3년평균매출액</th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${fn:length(rcpyJdgmntUpperInfo) == 0}">
							<tr>
								<td colspan="10"><spring:message code="info.nodata.msg" /></td>
							</tr>
						</c:if>
						<c:forEach items="${rcpyJdgmntUpperInfo}" var="upperInfo" varStatus="status">
							<tr>
								<td>${fn:substring(upperInfo.lev2Jurirno, 0, 6)}-${fn:substring(upperInfo.lev2Jurirno, 6, 13)}</td>
								<td>${upperInfo.lev2EntrprsNm}</td>
								<td>${upperInfo.lev2QotaRt}</td>
								<td>${upperInfo.lev2IndutyCode}</td>
								<td class="tar"><fmt:formatNumber value = "${upperInfo.lev2Y3avgSelngAm1}" pattern = "#,##0"/></td>
								<td>${fn:substring(upperInfo.lev3Jurirno, 0, 6)}-${fn:substring(upperInfo.lev3Jurirno, 6, 13)}</td>
								<td>${upperInfo.lev3EntrprsNm}</td>
								<td>${upperInfo.lev3QotaRt}</td>
								<td>${upperInfo.lev3IndutyCode}</td>
								<td class="tar"><fmt:formatNumber value = "${upperInfo.lev3Y3avgSelngAm1}" pattern = "#,##0"/></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div class="list_zone" style="margin-top:10px;">
				<h3>하위그룹</h3>
				<table cellspacing="0" border="0" summary="하위그룹목록" class="list">
					<caption>하위그룹목록</caption>
					<colgroup>
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
					</colgroup>
					<thead>
						<tr>	
							<th scope="col">하위법인등록번호</th>
							<th scope="col">하위기업명</th>
							<th scope="col">하위지분율</th>
							<th scope="col">하위기업업종코드</th>
							<th scope="col">하위3년평균매출액</th>
							<th scope="col">최하위법인등록번호</th>
							<th scope="col">최하위기업명</th>
							<th scope="col">최하위지분율</th>
							<th scope="col">최하위기업업종코드</th>
							<th scope="col">최하위3년평균매출액</th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${fn:length(rcpyJdgmntLwprtInfo) == 0}">
							<tr>
								<td colspan="10"><spring:message code="info.nodata.msg" /></td>
							</tr>
						</c:if>
						<c:forEach items="${rcpyJdgmntLwprtInfo}" var="lwprtInfo" varStatus="status">
							<tr>
								<td>${fn:substring(lwprtInfo.lev2Jurirno, 0, 6)}-${fn:substring(lwprtInfo.lev2Jurirno, 6, 13)}</td>
								<td>${lwprtInfo.lev2EntrprsNm}</td>
								<td>${lwprtInfo.lev2QotaRt}</td>
								<td>${lwprtInfo.lev2IndutyCode}</td>
								<td class="tar"><fmt:formatNumber value = "${lwprtInfo.lev2Y3avgSelngAm1}" pattern = "#,##0"/></td>
								<td>${fn:substring(lwprtInfo.lev3Jurirno, 0, 6)}-${fn:substring(lwprtInfo.lev3Jurirno, 6, 13)}</td>
								<td>${lwprtInfo.lev3EntrprsNm}</td>
								<td>${lwprtInfo.lev3QotaRt}</td>
								<td>${lwprtInfo.lev3IndutyCode}</td>
								<td class="tar"><fmt:formatNumber value = "${lwprtInfo.lev3Y3avgSelngAm1}" pattern = "#,##0"/></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
	</div>
</div>
</body>
</html>