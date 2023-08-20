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
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox" />
<ap:jsTag type="tech" items="msg,util,ucm,pc" />

<script type="text/javascript">
	$(document).ready(function() {
		$("#btn_search").click(function() {
			$("#dataForm").submit();
		});
	}); // ready
</script>

</head>
<body>

	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">

		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />

		<div>
			<div class="pop_write">
				<!--// 머리글-->
				<div class="txt_zone_pc">
					<ul>
						<li>산업통상자원부에서 입수한 기업 정보를 기준으로 판단하였으며, 해당기업이 자료를 제출하여 기업이 아님이 확인되는 경우 게시 명단에서 제외되오니, 단순
							참고용으로만 활용하시기 바랍니다.<br />또한, '15년말 기준 자료로 현재 시점에서 기업의 기업 여부를 판단하는데 사용될 수 없습니다.
						</li>
						<li>기업이 아닌 경우 아래 주소로 확인 서류를 제출하여 주시기 바랍니다. <br />주소 : 서울시 마포구 마포대로 34, 10층(도화동, 도원빌딩)
							기업연합회, 기획총괄팀 (02-3275-2105) <br />
						</li>
						<li>문의처 산업통상자원부 기업정책과 (044-203-4367)</li>
					</ul>
				</div>
				<!--//검색-->
				<div class="search_top">
					<div class="inner">
						<fieldset>
							<legend>게시물 검색</legend>
							
							<select name="ad_lclas_cd" id="ad_lclas_cd" style="vertical-align:top;">
								<option value="">업종세분류</option>
								<c:forEach items="${indutyDtlclfcList}" var="indutyDtlclfcInfo" varStatus="status">
									<option value="${indutyDtlclfcInfo.IND_CODE }" <c:if test="${indutyDtlclfcInfo.IND_CODE eq param.ad_lclas_cd}"> selected="selected"</c:if>>
										<c:out value="${indutyDtlclfcInfo.KOREAN_NM }" />
									</option>
								</c:forEach>
							</select>
							
							<select name="ad_area1" id="ad_area1" style="vertical-align:top;">
								<option value="">지역</option>
								<c:forEach items="${areaDivList}" var="areaDivInfo" varStatus="status">
									<option value="${areaDivInfo.AREA_CODE }" <c:if test="${areaDivInfo.AREA_CODE eq param.ad_area1}"> selected="selected"</c:if>>
										<c:out value="${areaDivInfo.ABRV }" />
									</option>
								</c:forEach>
							</select>
							
							<select name="search_sel" id="search_sel" style="vertical-align: top;">
								<option value="">기업명</option>
							</select> <input type="text" name="ad_entrprs_nm" id="ad_entrprs_nm" value="${param.ad_entrprs_nm }"
								title="검색어를 입력하세요." placeholder="검색어를 입력하세요." onfocus="this.placeholder=''; return true;"
								maxlength="50" style="width:200px;" />
							<p class="btn_src_zone">
								<a href="#none" id="btn_search" class="btn_search">검색</a>
							</p>
						</fieldset>
					</div>
				</div>
				<!--검색//-->

				<ap:pagerParam addJsRowParam="'','statsIncEntrprsSearch'" />

				<!--// 리스트 -->
				<div class="list_zone">
					<table cellspacing="0" border="0" summary="기본게시판 목록으로 번호,제목,작성일 등의 조회 정보를 제공합니다.">
						<caption>기본게시판 목록</caption>
						<colgroup>
							<col style="width: 10%" />
							<col style="width: 30%" />
							<%-- <col style="width: 10%" /> --%>
							<col style="width: 50%" />
							<col style="width: 10%" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">번호</th>
								<th scope="col">기업명</th>
								<!-- <th scope="col">대표자명</th> -->
								<th scope="col">업종세분류</th>
								<th scope="col">지역</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${dataList}" var="entData" varStatus="status">
								<tr>
									<td>${pager.indexNo - status.index}</td>
									<td class="tal">${entData.ENTRPRS_NM }</td>
									<%-- <td>${entData.RPRSNTV_NM }</td> --%>
									<td>${entData.INDUTY_NM }</td>
									<td>${entData.AREA_SIDO }</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<!-- 리스트// -->

				<!--// paginate -->
				<ap:pager pager="${pager}" addJsParam="'statsIncEntrprsSearch'" />
				<!-- paginate //-->

			</div>
		</div>

	</form>

</body>
</html>