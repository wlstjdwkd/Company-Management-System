<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>관계기업판정목록</title>

<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,multifile,blockUI,colorboxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util,etc" />

<script type="text/javaScript">
	$(document).ready(function() {
		// Excel download
		$("#btn_excel").click(function(){
			$("#df_method_nm").val("excelDownDddList");
			$("#dataForm").submit();
		});
	});
	
	function popRcpyJdgmntInfo(jdgMnt) {
		var stdyy = $("#ad_stdyy").val();
		
		$.colorbox({
			title : "관계기업판정상세보기",
			href : "${svcUrl}?df_method_nm=selectRcpyJdgmntInfo&ad_stdyy="+stdyy
					+"&ad_entrprsJurirno="+jdgMnt,
			width : "1200",
			height : "900",
			overlayClose : false,
			escKey : false,
			iframe : true
		});
	}
	
	// 검색
	function fn_search() {
		$("#df_method_nm").val("selectRcpyJdgmntList");
		$("#df_curr_page").val("1");
		$("#dataForm").submit();
	}
</script>
</head>
<body>
<!--//content-->
<div id="wrap">
	<div class="wrap_inn">
		<div class="contents">
			<!--// 타이틀 영역 -->
			<h2>관계기업판정목록</h2>
			<!-- 타이틀 영역 //-->
			
			<form id="dataForm" name="dataForm" action="<c:url value='${svcUrl}'/>" method="post">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />
				
				<input type="hidden" name="ad_stdyy" id="ad_stdyy" value="${param.ad_stdyy}" />
				
				<!--// 검색 영역 -->
				<div class="search_top">
					<table cellpadding="0" cellspacing="0" class="table_search" summary="조회 조건">
						<caption>조회 조건</caption>
						<colgroup>
							<col width="15%" />
							<col width="*" />
							<col width="15%" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">검색어</th>
								<td>
									<select name="ad_searchCondition" title="검색조건" id="ad_searchCondition" style="width:100px;">
										<option <c:if test="${param.ad_searchCondition eq 'entrprsNm'}">selected="selected"</c:if> value="entrprsNm">기업명</option>
										<option <c:if test="${param.ad_searchCondition eq 'entrprsJurirno'}">selected="selected"</c:if> value="entrprsJurirno">법인등록번호</option>
									</select>
									<input name="ad_searchKeyword" type="text" class="text" id="ad_searchKeyword" style="width:150px;" title="검색어" placeholder="검색어를 입력하세요" value="${param.ad_searchKeyword }" />
								</td>
							</tr>
							<tr>
								<th scope="row">관계기업규모여부</th>
								<td>
									<input type="radio" name="ad_searchGubun" id="ad_searchGubun_U" value="U" <c:if test="${param.ad_searchGubun eq 'U'}"> checked</c:if> />
									<label for="ad_searchGubun_U">전체</label>
									<input type="radio" name="ad_searchGubun" id="ad_searchGubun_Y" value="Y" class="mgl50" <c:if test="${param.ad_searchGubun eq 'Y'}"> checked</c:if> />
									<label for="ad_searchGubun_Y">적합</label>
									<input type="radio" name="ad_searchGubun" id="ad_searchGubun_N" value="N" class="mgl50" <c:if test="${param.ad_searchGubun eq 'N'}"> checked</c:if> />
									<label for="ad_searchGubun_N">부적합</label>
									<input type="radio" name="ad_searchGubun" id="ad_searchGubun_A" value="A" class="mgl50" <c:if test="${param.ad_searchGubun eq 'A'}"> checked</c:if> />
									<label for="ad_searchGubun_A">업종없음</label>
									<p class="btn_src_zone"><a href="#none" class="btn_search" onclick="fn_search();">조회</a></p>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<!-- 검색 영역 //-->
			</form>
			
			<div class="btn_page_total">
				<a class="btn_page_admin" href="#" id="btn_excel"><span>엑셀다운로드</span></a> 
			</div>
			
			<!--// 리스트 영역 -->
			<div class="block">
				<ap:pagerParam addJsRowParam="null,'selectRcpyJdgmntList'"/>
				<div class="list_zone">
					<table cellspacing="0" border="0" summary="관계기업판정목록" class="list">
						<caption>관계기업판정목록</caption>
						<colgroup>
							<col width="5%" />
							<col width="10%" />
							<col width="25%" />
							<col width="10%" />
							<col width="10%" />
							<col width="10%" />
							<col width="10%" />
							<col width="10%" />
							<col width="10%" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">기준년도</th>
								<th scope="col">법인등록번호</th>
								<th scope="col">기업명</th>
								<th scope="col">금융업여부</th>
								<th scope="col">관계기업여부</th>
								<th scope="col">${param.ad_stdyy}년<br />확정기업여부</th>
								<th scope="col">${param.ad_stdyy-1}년<br />확정기업여부</th>
								<th scope="col">${param.ad_stdyy-2}년<br />확정기업여부</th>
								<th scope="col">${param.ad_stdyy-3}년<br />확정기업여부</th>
								<th scope="col">상세내용</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${fn:length(entrprsList) == 0}">
								<tr>
									<td colspan="9"><spring:message code="info.nodata.msg" /></td>
								</tr>
							</c:if>
							<c:forEach items="${entrprsList}" var="info" varStatus="status">
								<tr>
									<td>${info.stdyy}</td>
									<td>${fn:substring(info.entrprsJurirno, 0, 6)}-${fn:substring(info.entrprsJurirno, 6, 13)}</td>
									<td>${info.entrprsNm}</td>
									<td>${info.entrprsK}</td>
									<td>${info.rcpyScaleYn}</td>
									<td>${info.dcsnHpeAt1}</td>
									<td>${info.dcsnHpeAt2}</td>
									<td>${info.dcsnHpeAt3}</td>
									<td>${info.dcsnHpeAt4}</td>
									<td><div class="btn_inner"><a href="#none" class="btn_in_gray" id="btn_resn_${info.entrprsJurirno }" onclick="popRcpyJdgmntInfo('${info.entrprsJurirno}');"><span>보기</span></a></div></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<div class="mgt10"></div>
				<ap:pager pager="${pager}" addJsParam="'selectRcpyJdgmntList'" />
			</div>
			<!-- 리스트영역 //-->
		</div>
	</div>
</div>
<!--content//-->
</body>
</html>