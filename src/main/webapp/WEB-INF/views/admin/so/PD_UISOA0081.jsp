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
<title>정보</title>
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />


<script type="text/javascript">
	/*
	 * 검색단어 입력 후 엔터 시 자동 submit
	 */
	function press(event) {
		if (event.keyCode == 13) {
			event.preventDefault();
			btn_entUser_get_list()();
		}
	}

	/*
	 * 목록 검색
	 */
	function btn_entUser_get_list() {
		var form = document.dataForm;

		form.df_curr_page.value = 1;
		form.submit();
	}

	// 팝업검색 결과를 호출자에게 리턴하고 화면을 닫는다.
	function btn_ent_return(bizrno, userNo, entrprsNm, rprsntvNm, email, telno, fxnum) {
		var opener = parent;

		opener.document.getElementById("USER_NO").value = userNo;
		opener.document.getElementById("ad_bizrno").value = bizrno;
		opener.document.getElementById("ad_entrprs_nm").value = entrprsNm;
		opener.document.getElementById("ad_rprsntv_nm").value = rprsntvNm;
		opener.document.getElementById("ad_charger_email").value = email;
		
		/*
		var telnoArray = telno.split('-');
		var fxnumArray = fxnum.split('-');
		
		//전화번호
		opener.document.getElementById("ad_tel_first").value = telnoArray[0];
		opener.document.getElementById("ad_tel_middle").value = telnoArray[1];
		opener.document.getElementById("ad_tel_last").value = telnoArray[2];
		//팩스번호
		opener.document.getElementById("ad_fax_first").value = fxnumArray[0];
		opener.document.getElementById("ad_fax_middle").value = fxnumArray[1];
		opener.document.getElementById("ad_fax_last").value = fxnumArray[2];
		*/
		
		parent.$.colorbox.close();
	}


</script>
</head>
<body>
	<!--//content-->
	<div id="self_dgs">
		<div class="pop_q_con">
			<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />
				
				<!-- LNB 출력 방지 -->
				<input type="hidden" id="no_lnb" value="true" /> <input type="hidden" name="ad_outptOrdr"
					id="ad_outptOrdr" /> 
					
				<!--// 타이틀 영역 -->
				<h2 class="menu_title">기업 찾기</h2>
				<!-- 타이틀 영역 //-->
				<!--// 검색 조건 -->
				<div class="search_top">
					<table cellpadding="0" cellspacing="0" class="table_search" summary="기업명으로 검색">
						<caption>검색</caption>
						<colgroup>
							<col width="100%" />
						</colgroup>
						<tr>
							<td class="only">
							<input name="searchEntrprsNm" id = "searchEntrprsNm" type="text" style="width: 300px;" title="기업명 입력" placeholder="기업명을 입력하세요"
								value='<c:out value="${param.searchEntrprsNm}"/>' onkeypress="press(event);" />
								<p class="btn_src_zone">
									<a href="#none" class="btn_search" onclick="btn_entUser_get_list()">검색</a>
								</p></td>
						</tr>
					</table>
				</div>
				<div class="block">
					<ap:pagerParam addJsRowParam="null,'getEntUserList'"/>
					<!--// 리스트 -->
					<div class="list_zone">
						<table cellspacing="0" border="0" summary="">
							<caption>기업유저리스트</caption>
							<colgroup>
								<col width="*" />
								<col width="*" />
								<col width="*" />
								<col width="*" />
								<col width="*" />
								<col width="*" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">번호</th>
									<th scope="col">사업자등록번호</th>
									<th scope="col">기업명</th>
									<th scope="col">대표자명</th>
									<th scope="col">담당자명</th>
									<th scope="col">선택</th>
								</tr>
							</thead>
							<tbody>
								
								<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
								<c:if test="${fn:length(list) == 0}">
									<tr>
										<td colspan="8"><c:if test="${param.searchSiteSe == '' || param.searchMenuNm == ''}">
												<spring:message code="info.nodata.msg" />
											</c:if> <c:if test="${param.searchSiteSe != '' || param.searchMenuNm != ''}">
												<spring:message code="info.noresult.msg" />
											</c:if></td>
									</tr>
								</c:if>
								<%-- 데이터를 화면에 출력해준다 --%>
								<c:forEach items="${list}" var="list" varStatus="status">
									<tr>
										<td>${pagerNo-(status.index)}</td>
										<td>${list.bizrno}</td>
										<td class="tal">${list.entrprsNm}</td>
										<td>${list.rprsntvNm}</td>
										<td>${list.chargerNm}</td>
										<td>
											<div class="btn_inner">
												<a href="#none" class="btn_in_gray"
													onclick="btn_ent_return('<c:out value="${list.bizrno}"/>', '<c:out value="${list.userNo}"/>', '<c:out value="${list.entrprsNm}"/>', '<c:out value="${list.rprsntvNm}"/>', '<c:out value="${list.email}"/>', '<c:out value="${list.telno}"/>', '<c:out value="${list.fxnum}"/>');"><span>선택</span></a>
											</div>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
					<!-- 리스트// -->
					<div class="mgt10"></div>
					<!--// paginate -->
						<ap:pager pager="${pager}" addJsParam="'getEntUserList'" />
					<!-- paginate //-->
				</div>
				<!--content//-->
			</form>
		</div>
	</div>
</body>
</html>