<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<% 
/**
 * @Class Name : EgovBatchOpertListPopup.jsp
 * @Description : 배치작업관리 목록조회팝업
 * @Modification Information
 * @
 * @  수정일      수정자            수정내용
 * @ -------        --------    ---------------------------
 * @ 2010.08.24   김진만          최초 생성
 *
 *  @author 김진만
 *  @version 1.0 
 *  @see
 *  
 */
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>배치작업선택</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,colorboxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javascript">
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

    // 팝업검색 결과를 호출자에게 리턴하고 화면을 닫는다.
    function fn_egov_return_batch_opert(batchOpertId, batchOpertNm) {
        parent.document.getElementById("batchOpertId").value = batchOpertId;
        parent.document.getElementById("batchOpertNm").value = batchOpertNm;
        
        parent.$("#popBatchOpert").colorbox.close();
    }
</script>
</head>
<body>
<div id="self_dgs">
	<div class="pop_q_con">
				<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />

				<input type="hidden" name="popupAt" value="Y" />
				<input type="hidden" name="batchOpertId" value="">

				<!-- LNB 출력 방지 -->
				<input type="hidden" id="no_lnb" value="true" />
								
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
				</form>
                <div class="block">
					<ap:pagerParam />	
                    <!--// 리스트 -->
                    <div class="list_zone">
                        <table cellspacing="0" border="0" summary="배치스케쥴ID 배치작업명 배치프로그램 실행주기 실행스케줄">
                            <caption>
                            배치작업리스트
                            </caption>
                            <colgroup>
                        <col width="25%" />
                        <col width="25%" />
                        <col width="40%" />
                        <col width="10%" />
                        </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">배치작업ID</th>
                                    <th scope="col">배치작업명</th>
                                    <th scope="col">배치프로그램</th>
                                    <th scope="col">선택</th>
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
									<td>${resultInfo.batchOpertId}</td>
									<td class="tal">${resultInfo.batchOpertNm}</td>
									<td class="tal">${resultInfo.batchProgrm}</td>
									<td><div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="fn_egov_return_batch_opert('<c:out value="${resultInfo.batchOpertId}"/>', '<c:out value="${resultInfo.batchOpertNm}"/>'); "><span>선택</span></a></div></td>
								</tr>
							</c:forEach>
							</tbody>
						</table>
                    </div>
                    <!-- 리스트// -->
                    <div class="mgt10"></div>
					<ap:pager pager="${pager}" />
                </div>
            </div>
</div>
</body>
</html>