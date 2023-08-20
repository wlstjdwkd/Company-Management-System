<%--
  Class Name : EgovBatchResultDetail.jsp
  Description : 배치결과 상세조회 페이지
  Modification Information
 
      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2010.08.31    김진만          최초 생성
 
    author   : 공통서비스 개발팀 김진만
    since    : 2010.08.31
   
--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<c:set var="tempDate" value=""/>
<%pageContext.setAttribute("crlf", "\r\n"); %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>배치결과관리</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,msgBoxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />
<script type="text/javascript">

/* ********************************************************
 * 목록 으로 가기
 ******************************************************** */
function fn_egov_list(){
    var varForm = document.getElementById("batchResultForm");
    varForm.df_method_nm.value = "";
    varForm.submit()
}
/* ********************************************************
 * 삭제 처리
 ******************************************************** */
 function fn_egov_delete(){
        jsMsgBox(null, 'confirm','<spring:message code="confirm.common.delete" />',function(){$("#df_method_nm").val("deleteBatchResult"); $("#batchResultForm").submit();});
}
</script>
</head>
<body>
   <!--//content-->
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title_line">배치결과 상세조회</h2>
                <!-- 타이틀 영역 //-->
               <div class="block">
                   <h3 class="mgt30"> <span>항목은 입력 필수 항목 입니다.</span> </h3>
                    <!--// 상세조회 -->
					<form name="batchResultForm"  id="batchResultForm" action="<c:url value='${svcUrl}'/>" method="post">
						<ap:include page="param/defaultParam.jsp" />
						<ap:include page="param/dispParam.jsp" />
						<ap:include page="param/pagingParam.jsp" />
						
					    <!-- 검색조건 유지 -->
					    <input type="hidden" name="searchCondition" value="<c:out value='${searchVO.searchCondition}'/>"/>
					    <input type="hidden" name="searchKeyword" value="<c:out value='${searchVO.searchKeyword}'/>"/>
					    <input type="hidden" name="searchKeywordFrom" value="<c:out value='${searchVO.searchKeywordFrom}'/>"/>
					    <input type="hidden" name="searchKeywordTo" value="<c:out value='${searchVO.searchKeywordTo}'/>"/>
					    <input type="hidden" name="sttus" value="<c:out value='${searchVO.sttus}'/>"/>
					    <input type="hidden" name="pageIndex" value="<c:out value='${searchVO.pageIndex}' default="1"/>"/>
					    <input type="hidden" name="batchResultId" value="<c:out value='${resultInfo.batchResultId}'/>"/>

                   <table cellpadding="0" cellspacing="0" class="table_basic mgt10" summary="배치결과 상세조회">
                        <caption>
                        배치결과 상세조회
                        </caption>
                        <colgroup>
                        <col width="15%" />
                        <col width="*" />
                        </colgroup>
                        <tr>
                            <th scope="row">배치결과ID</th>
                            <td><c:out value="${resultInfo.batchResultId}" escapeXml="false" /></td>
                        </tr>
                        <tr>
                            <th scope="row">배치스케줄ID</th>
                            <td><c:out value="${resultInfo.batchSchdulId}" escapeXml="false" /></td>
                        </tr>
                        <tr>
                            <th scope="row">배치작업ID</th>
                            <td><c:out value="${resultInfo.batchOpertId}" escapeXml="false" /></td>
                        </tr>
                        <tr>
                            <th scope="row">배치작업명</th>
                            <td><c:out value="${resultInfo.batchOpertNm}" escapeXml="false" /></td>
                        </tr>
                        <tr>
                            <th scope="row">배치프로그램</th>
                            <td><c:out value="${resultInfo.batchProgrm}" escapeXml="false" /></td>
                        </tr>
                        <tr>
                            <th scope="row">파라미터</th>
                            <td><c:out value="${resultInfo.paramtr}" escapeXml="false" /></td>
                        </tr>
                        <tr>
                            <th scope="row">상태</th>
                            <td><c:out value="${resultInfo.sttusNm}" escapeXml="false" /></td>
                        </tr>
                        <tr>
                            <th scope="row">에러정보</th>
                            <td><c:out value="${resultInfo.errorInfo}" escapeXml="false" /> </td>
                        </tr>
                        <tr>
                            <th scope="row">실행시작시각</th>
                            <td>
					            <fmt:parseDate value="${resultInfo.executBeginTime}" pattern="yyyyMMddHHmmss" var="tempDate"/>
					            <fmt:formatDate value="${tempDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">실행종료시각</th>
                            <td>
					            <fmt:parseDate value="${resultInfo.executEndTime}" pattern="yyyyMMddHHmmss" var="tempDate"/>
					            <fmt:formatDate value="${tempDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </td>
                        </tr>
                    </table>
					</form>
                </div>
                <!-- 상세// -->
                <div class="btn_page_last"> 
                	<a class="btn_page_admin" href="#none" onclick="fn_egov_delete();"><span>삭제</span></a> 
                	<a class="btn_page_admin" href="#none" onclick="fn_egov_list();"><span>목록</span></a>
                </div>
            </div>
        </div>
        <!--content//-->
    </div>
</body>
</html>