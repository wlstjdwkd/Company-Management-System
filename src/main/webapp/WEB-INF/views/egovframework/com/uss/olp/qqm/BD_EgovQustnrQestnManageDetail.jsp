<%--
  Class Name : EgovQustnrQestnManageDetail.jsp
  Description : 설문문항 상세보기
  Modification Information

      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2008.03.09    장동한          최초 생성

    author   : 공통서비스 개발팀 장동한
    since    : 2009.03.19

--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<%pageContext.setAttribute("crlf", "\r\n"); %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>설문문항상세조회</title>

<ap:jsTag type="web" items="jquery,tools,ui,validate,form,msgBoxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javaScript">

/* ********************************************************
 * 목록 으로 가기
 ******************************************************** */
 function fn_egov_list_QustnrQestnManage() {
	var form = document.getElementById("QustnrQestnManageForm");
	form.df_method_nm.value = "";
	form.submit();
}

/* ********************************************************
 * 수정화면
 ******************************************************** */
function fn_egov_modify_QustnrQestnManage(){
	var form = document.getElementById("QustnrQestnManageForm");
	form.df_method_nm.value = "updateEgovQustnrQestnManage";
	form.submit();
}
/* ********************************************************
 * 삭제처리
 ******************************************************** */
function fn_egov_delete_QustnrQestnManage(){
	
	jsMsgBox(null, 'confirm','<spring:message code="fail.common.custom" arguments="삭제 시 설문문항/설문항목/설문결과 정보가 함께 삭제됩니다!" /> <spring:message code="confirm.common.delete" />',
			function(){
				$("#df_method_nm").val("deleteEgovQustnrQestnManage");
				$("#QustnrQestnManageForm").submit();
			});	
}
</script>
</head>
<body>
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">설문문항상세조회</h2>
                <!-- 타이틀 영역 //-->
                <!--// 상세보기 -->
                <form name="QustnrQestnManageForm" id="QustnrQestnManageForm" action="<c:url value='${svcUrl }'/>" method="post">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />

				<!-- 검색조건 유지 -->
				<input type="hidden" name="searchCondition" value="<c:out value='${searchVO.searchCondition}'/>"/>
				<input type="hidden" name="searchKeyword" value="<c:out value='${searchVO.searchKeyword}'/>"/>

				<input type="hidden" name="qestnrQesitmId" id="qestnrQesitmId" value="${resultList[0].qestnrQesitmId}">
				
				<%-- 설문지정보 상태유지 --%>
				<c:if test="${qustnrQestnManageVO.searchMode == 'Y'}">
				<input type="hidden" name="qestnrTmplatId" id="qestnrTmplatId" value="${qustnrQestnManageVO.qestnrTmplatId}">
				<input type="hidden" name="qestnrId" id="qestnrId" value="${qustnrQestnManageVO.qestnrId}">
				<input type="hidden" name="searchMode" id="searchMode" value="${qustnrQestnManageVO.searchMode}">
				</c:if>

                <div>
                    <table cellpadding="0" cellspacing="0" class="table_basic" summary="설문문항읽기">
                        <caption>
                        설문문항읽기
                        </caption>
                        <colgroup>
                        <col width="150" />
                        <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row"> 설문제목</th>
                                <td>${resultList[0].qestnrSj}</td>
                            </tr>
                            <tr>
                                <th scope="row"> 문항순서</th>
                                <td>${resultList[0].qestnSn}</td>
                            </tr>
                            <tr>
                                <th scope="row"> 문항유형</th>
                                <td><c:out value="${resultList[0].qestnTyNm}" /></td>
                            </tr>
                            <tr>
                                <th scope="row"><label for="info4"> 문항질문</label></th>
                                <td><c:out value="${fn:replace(resultList[0].qestnCn , crlf , '<br/>')}" escapeXml="false" /></td>
                            </tr>
                            <tr>
                                <th scope="row"> 선택최대건수</th>
                                <td>${resultList[0].mxmmChoiseCo}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                </form>
                <div class="btn_page_last">
                	<a class="btn_page_admin" href="#none" onclick="fn_egov_list_QustnrQestnManage();"><span>목록</span></a> 
                	<a class="btn_page_admin" href="#none" onclick="fn_egov_delete_QustnrQestnManage();"><span>삭제</span></a> 
                	<a class="btn_page_admin" href="#none" onclick="fn_egov_modify_QustnrQestnManage();"><span>수정</span></a> 
                </div>
            </div>
        </div>
        <!--content//-->
    </div>
    
</body>
</html>
