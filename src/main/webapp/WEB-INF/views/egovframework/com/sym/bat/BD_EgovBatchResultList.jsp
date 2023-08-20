<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<%
/**
 * @Class Name : EgovBatchResultList.jsp
 * @Description : 배치결과관리 목록조회
 * @Modification Information
 * @
 * @  수정일      수정자            수정내용
 * @ -------        --------    ---------------------------
 * @ 2010.08.31   김진만          최초 생성
 *
 *  @author 김진만
 *  @version 1.0
 *  @see
 *
 */
%>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<c:set var="tempDate" value="" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>배치결과관리</title>

<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,mask" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javascript">

$(document).ready(function(){
	<c:if test="${resultMsg != null}">
		jsMsgBox(null, "info", "${resultMsg}");
	</c:if>
	
	// 달력
	$('#searchStartDate').datepicker({
        showOn : 'button',
        defaultDate : null,
        buttonImage : '<c:url value="/images/acm/icon_cal.png" />',
        buttonImageOnly : true,
        changeYear: true,
        changeMonth: true,
        yearRange: "2014:+1"
    });
    $('#searchEndDate').datepicker({
        showOn : 'button',
        defaultDate : null,
        buttonImage : '<c:url value="/images/acm/icon_cal.png" />',
        buttonImageOnly : true,
        changeYear: true,
        changeMonth: true,
        yearRange: "2014:+1"
    });
    
    $('#searchStartDate').mask('0000-00-00');
    $('#searchEndDate').mask('0000-00-00');

});

function press(event) {
    if (event.keyCode==13) {
		event.preventDefault();
        fn_egov_get_list();
    }
}

function fn_egov_get_list() {

	if ($("#searchKeyword").val() != "" && $("#searchCondition").val() == "") {
		jsMsgBox(null, 'error', Message.template.required('검색구분'));
		return;
	}
    
	if ( ($("#searchStartDate").val() != "" && $("#searchEndDate").val() == "") || ($("#searchStartDate").val() == "" && $("#searchEndDate").val() != "") ) {
		jsMsgBox(null, "error", Message.msg.bothRequiredDateCondition);
		return;
	}
	
	if($("#searchStartDate").val() > $("#searchEndDate").val() || $("#searchStartDate").val().replace(/-/gi,"") > $("#searchEndDate").val().replace(/-/gi,"")){
        jsMsgBox(null, "error", Message.msg.invalidDateCondition);
        $("#searchEndDate").focus();
        return;
    }
	
	if ($("#searchStartDate").val() != "") {
		$("#searchKeywordFrom").val($("#searchStartDate").cleanVal());
	} else {
		$("#searchKeywordFrom").val("");
	}
	
	if ($("#searchEndDate").val() != "") {
		$("#searchKeywordTo").val($("#searchEndDate").cleanVal());
	} else {
		$("#searchKeywordTo").val("");
	}

	$("#df_curr_page").val(1);
	$("#df_method_nm").val("");
	$("#dataForm").submit();
	
}

function fn_egov_get_detail_view(batchResultId) {
	var form = document.dataForm;
	form.df_method_nm.value = "getBatchResult";
	form.batchResultId.value = batchResultId;
	form.submit();
}
</script>
</head>
<body onLoad="fn_egov_init();">
    <!--//content-->
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">배치결과관리</h2>
                <!-- 타이틀 영역 //-->

				<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />
				<input type="hidden" name="batchResultId" id="batchResultId" value="" />
				
				<!--// 조회 조건 -->
				<input type="hidden" name="searchKeywordFrom" id="searchKeywordFrom" value="<c:out value='${searchVO.searchKeywordFrom}'/>" />
				<input type="hidden" name="searchKeywordTo" id="searchKeywordTo" value="<c:out value='${searchVO.searchKeywordTo}'/>" />
				
				<div class="search_top">
					<table cellpadding="0" cellspacing="0" class="table_search" summary="배치결과관리조회" >
						<caption>
                        배치결과관리조회
						</caption>
						<colgroup>
						<col width="18%" />
						<col width="42%" />
						<col width="10%" />
						<col width="30%" />
						</colgroup>
                        <tr>
                            <th scope="row">구분검색</th>
                            <td colspan="3"><span class="only">
                                <select name="searchCondition" title="검색조건선택" id="searchCondition" style="width:110px">
									<option value="">선택하세요</option>
									<option value="0" <c:if test="${searchVO.searchCondition == '0'}">selected="selected"</c:if>>배치작업명</option>
									<option value="1" <c:if test="${searchVO.searchCondition == '1'}">selected="selected"</c:if>>배치프로그램</option>
                                </select> 
                          <input name="searchKeyword" type="text" id="searchKeyword" style="width:400px;" title="검색어 입력" placeholder="검색어를 입력하세요." 
                          	value='<c:out value="${searchVO.searchKeyword}"/>' maxlength="35" onkeypress="press(event);" /></td>
                        </tr>
                        <tr>
                            <th scope="row">배치실행시작일자</th>
                            <td>
								<input type="text" name="searchStartDate" id="searchStartDate" maxlength="10" title="날짜선택" value="${param.searchStartDate }"/>
								~
								<input type="text" name="searchEndDate" id="searchEndDate" maxlength="10" title="날짜선택" value="${param.searchEndDate }" />
                            </td>
                            <th scope="row">상태</th>
                            <td>
                            	<ap:code id="sttus" grpCd="8" type="select" defaultLabel="선택하세요" selectedCd="${searchVO.sttus}" />
                                <p class="btn_src_zone"><a href="#none" class="btn_search" onclick="fn_egov_get_list();">검색</a></p></td>
                        </tr>
                    </table>
                </div>
                <div class="block">
					<ap:pagerParam />	
                   <!--// 리스트 -->
                    <div class="list_zone">
                       <table cellspacing="0" border="0" summary="배치결과관리 리스트">
                            <caption>
                            배치결과관리 리스트
                            </caption>
                            <colgroup>
                            <col width="18%" />
                            <col width="18%" />
                            <col width="18%" />
                            <col width="10%" />
                            <col width="18%" />
                            <col width="18%" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">배치결과ID</th>
                                    <th scope="col">배치스케줄ID</th>
                                    <th scope="col">배치작업명</th>
                                    <th scope="col">상태</th>
                                    <th scope="col">실행시작시각</th>
                                    <th scope="col">실행종료시각</th>
                                </tr>
                            </thead>
                            <tbody>
						        <%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
								<c:if test="${fn:length(resultList) == 0}">
								<tr>
									<td colspan="6">
										<c:if test="${param.searchKeyword == '' and param.searchKeywordFrom == '' }"><spring:message code="info.nodata.msg" /></c:if>
										<c:if test="${param.searchKeyword != '' or param.searchKeywordFrom != '' }"><spring:message code="info.noresult.msg" /></c:if>
									</td>
								</tr>
								</c:if>
								<%-- 데이터를 화면에 출력해준다 --%>
        						<c:forEach items="${resultList}" var="resultInfo" varStatus="status">
                                <tr>
                                    <td><a href="#none" onclick="fn_egov_get_detail_view('<c:out value='${resultInfo.batchResultId}'/>')" /> ${resultInfo.batchResultId}</td>
                                    <td>${resultInfo.batchSchdulId}</td>
                                    <td class="tal">${resultInfo.batchOpertNm}</td>
                                    <td>${resultInfo.sttusNm}</td>
                                    <td>
					                    <fmt:parseDate value="${resultInfo.executBeginTime}" pattern="yyyyMMddHHmmss" var="tempDate"/>
					                    <fmt:formatDate value="${tempDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                    </td>
                                    <td>
					                    <fmt:parseDate value="${resultInfo.executEndTime}" pattern="yyyyMMddHHmmss" var="tempDate"/>
					                    <fmt:formatDate value="${tempDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                    </td>
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
            </form>
            <!--content//-->
        </div>
    </div>
</div>
</body>
</html>