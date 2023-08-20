<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업종합정보시스템</title>
<ap:jsTag type="web"
	items="jquery,colorboxAdmin,cookie,flot,form,jqGrid,notice,selectbox,timer,tools,ui,validate" />
<ap:jsTag type="tech" items="util,acm,ps" />
<script type="text/javascript">
	$(document).ready(function() {
		Util.rowSpan($("#tblStatics"), [ 1 ]);
	});
</script>
</head>
<body>
	<form name="dataForm" id="dataForm" method="POST">
		<div id="self_dgs">
			<div class="pop_q_con">
				<!--// 검색 조건 -->
				<div class="search_top">
					<table cellpadding="0" cellspacing="0" class="table_search" summary="일반기업 성장현황">
						<caption>일반기업 성장현황</caption>
						<colgroup>
							<col width="15%" />
							<col width="25%" />
							<col width="15%" />
							<col width="25%" />
						</colgroup>
						<tr>
							<th scope="row">기업군</th>
							<td>일반기업</td>
							<th scope="row">년도</th>
							<td>${from_sel_target_year}년~ ${to_sel_target_year}년</td>
						</tr>
					</table>
				</div>
				<!-- // 리스트영역-->
				<div class="block">
					<!-- // 리스트 -->
					<div class="list_zone">
						<table cellspacing="0" border="0" summary="기업통계" class="list" id="tblStatics">
							<caption>리스트</caption>
							<colgroup>
								<c:if test="${!empty param.searchArea }">
									<col width="*" />
								</c:if>
								<c:if test="${!empty param.searchInduty }">
									<col width="*" />
								</c:if>
								<c:forEach var="outYr" begin="${stdyySt }" end="${stdyyEd }">
									<col width="*" />
								</c:forEach>
							</colgroup>
							<thead>
								<tr>
									<th scope="col">업종</th>
									<th scope="col">구분</th>
									<c:forEach var="outYr" begin="${from_sel_target_year }" end="${to_sel_target_year }">
										<th scope="col">${outYr }</th>
									</c:forEach>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${entprsList}" var="entprs" varStatus="status">
									<tr>
										<td id='rowspan' class='tac'>${entprs.COL1 }</td>
										<td class='tal'>${entprs.GUBUN1 }</td>
										<c:forEach var="outYr" begin="${from_sel_target_year}" end="${to_sel_target_year}"
											varStatus="status">
											<c:set var="cname" value="CNT${status.count-1}N" />
											<td class='tar'><fmt:formatNumber value="${entprs[cname] }" /></td>
										</c:forEach>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
					<!-- 리스트// -->
					<div class="btn_page_last">
						<a class="btn_page_admin" href="javascript:window.print();"><span>인쇄</span></a> <a
							class="btn_page_admin" href="#" onclick="parent.$.fn.colorbox.close();"><span>닫기</span></a>
					</div>
				</div>
				<!--리스트영역 //-->
			</div>
			<!--content//-->
		</div>
		</div>
	</form>
</body>
</html>