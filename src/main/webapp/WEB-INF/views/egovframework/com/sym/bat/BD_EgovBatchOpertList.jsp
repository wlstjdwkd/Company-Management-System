<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<%
	/**
	 * @Class Name : EgovBatchOpertList.jsp
	 * @Description : 배치작업관리 목록조회
	 * @Modification Information
	 * @
	 * @  수정일      수정자            수정내용
	 * @ -------        --------    ---------------------------
	 * @ 2010.08.18   김진만          최초 생성
	 *
	 *  @author 김진만
	 *  @version 1.0
	 *  @see
	 *
	 */
%>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>배치작업관리</title>

<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javascript">
<c:if test="${resultMsg != null}">
	$(function(){
		jsMsgBox(null, "info", "${resultMsg}");
	});
</c:if>

	/*
	* 검색단어 입력 후 엔터 시 자동 submit
	*/
	function press(event) {
		if (event.keyCode == 13) {
			event.preventDefault();
			fn_egov_get_list();
		}
	}
	
	/*
	* 목록 검색
	*/
	function fn_egov_get_list() {
		var form = document.dataForm;
		
		if (form.searchKeyword.value != "" && form.searchCondition.value == "") {
			jsMsgBox(null, 'error', Message.template.required('검색구분'));
			return;
		}
		
		form.df_curr_page.value = 1;
		form.df_method_nm.value = "";
		form.submit();
	}
	
	/* ********************************************************
	 * 등록 처리 함수
	 ******************************************************** */
	function fn_egov_get_regist_view() {
		var form = document.dataForm;
		form.df_method_nm.value = "getBatchOpertForRegist";
		form.submit();
	}
	
	/*
	* 상세보기
	*/
	function fn_egov_get_detail_view(batchOpertId) {
		var form = document.dataForm;
		form.df_method_nm.value = "getBatchOpert";
		form.batchOpertId.value = batchOpertId;
		form.submit();
	}
</script>

</head>
<body>
	<div id="wrap">
		<div class="wrap_inn">
			<div class="contents">
				<!--// 타이틀 영역 -->
				<h2 class="menu_title">배치작업관리</h2>
				<!-- 타이틀 영역 //-->

				<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />
					
				<input name="batchOpertId" type="hidden" value="">

				<!--// 조회 조건 -->
				<div class="search_top">
					<table cellpadding="0" cellspacing="0" class="table_search" summary="배치작업명, 배치프로그램으로 검색" >
						<caption>검색</caption>
						<colgroup>
							<col width="100%" />
						</colgroup>
						<tr>
							<td class="only">
								<select name="searchCondition" title="검색조건선택" style="width: 150px">
									<option value="">선택하세요</option>
									<option value="0" <c:if test="${searchVO.searchCondition == '0'}">selected="selected"</c:if>>배치작업명</option>
									<option value="1" <c:if test="${searchVO.searchCondition == '1'}">selected="selected"</c:if>>배치프로그램</option>
								</select> 
								<input type="text" name="searchKeyword" title="검색어 입력" style="width: 290px;" placeholder="배치작업명 또는 배치프로그램을 입력하세요."
										value='<c:out value="${searchVO.searchKeyword}"/>' maxlength="35" onkeypress="press(event);" />
								<p class="btn_src_zone">
									<a href="#none" class="btn_search" onclick="fn_egov_get_list();">검색</a>
								</p>
							</td>
						</tr>
					</table>
				</div>
                <div class="block">
					<ap:pagerParam />	
                    <!--// 리스트 -->
                    <div class="list_zone">
                        <table cellspacing="0" border="0" summary="배치작업ID 배치작업명 배치프로그램 파라미터 리스트">
                            <caption>
                            배치작업리스트
                            </caption>
                            <colgroup>
                        <col width="20%" />
                        <col width="20%" />
                        <col width="50%" />
                        <col width="10%" />
                        </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">배치작업ID</th>
                                    <th scope="col">배치작업명</th>
                                    <th scope="col">배치프로그램</th>
                                    <th scope="col">파라미터</th>
                                </tr>
                            </thead>
                            <tbody>
							<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
							<c:if test="${fn:length(resultList) == 0}">
								<tr>
									<td colspan="4">
										<c:if test="${param.searchKeyword == '' }"><spring:message code="info.nodata.msg" /></c:if>
										<c:if test="${param.searchKeyword != '' }"><spring:message code="info.noresult.msg" /></c:if>
									</td>
								</tr>
							</c:if>
							<%-- 데이터를 화면에 출력해준다 --%>
							<c:forEach items="${resultList}" var="resultInfo" varStatus="status">
								<tr>
									<td><a href="#none" onclick="fn_egov_get_detail_view('<c:out value='${resultInfo.batchOpertId}'/>')"><c:out
												value='${resultInfo.batchOpertId}' /></a></td>
									<td class="tal">${resultInfo.batchOpertNm}</td>
									<td class="tal">${resultInfo.batchProgrm}</td>
									<td class="tal">${resultInfo.paramtr}</td>
								</tr>
							</c:forEach>
							</tbody>
						</table>
					</div>
                    <!-- 리스트// -->
                    <div class="btn_page_last"><a class="btn_page_admin" href="#none" onclick="fn_egov_get_regist_view()"><span>등록</span></a>	</div>
					<ap:pager pager="${pager}" />
				</div>
				</form>
			</div>
		</div>
	</div>
	
</body>
</html>