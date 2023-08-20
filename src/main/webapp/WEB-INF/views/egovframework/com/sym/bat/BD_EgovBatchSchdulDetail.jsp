<%--
  Class Name : EgovBatchSchdulDetail.jsp
  Description : 배치스케줄 상세조회 페이지
  Modification Information
 
      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2010.08.25    김진만          최초 생성
 
    author   : 공통서비스 개발팀 김진만
    since    : 2010.08.25
   
--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<%pageContext.setAttribute("crlf", "\r\n"); %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>배치스케줄 상세조회</title>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,msgBoxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javaScript">

/* ********************************************************
 * 목록 으로 가기
 ******************************************************** */
function fn_egov_list(){
    var varForm = document.getElementById("batchSchdulForm");
    varForm.df_method_nm.value = "";
    varForm.submit()
}
/* ********************************************************
 * 수정화면으로  바로가기
 ******************************************************** */
function fn_egov_update_view(){
    var varForm = document.getElementById("batchSchdulForm");
    varForm.df_method_nm.value = "getBatchSchdulForUpdate";
    varForm.submit();
}
/* ********************************************************
 * 삭제 처리
 ******************************************************** */
function fn_egov_delete(){
	jsMsgBox(null, 'confirm','<spring:message code="confirm.common.delete" />',function(){$("#df_method_nm").val("deleteBatchSchdul"); $("#batchSchdulForm").submit();});
}

</script>
</head>
<body >
   <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title_line">배치스케줄 상세조회</h2>
                <!-- 타이틀 영역 //-->
                <div class="block">
                    <h3 class="mgt30">
                    <span>항목은 입력 필수 항목 입니다.</span>
                    </h3>

					<form name="batchSchdulForm"  id="batchSchdulForm" action="${svcUrl}" method="post">
					<ap:include page="param/defaultParam.jsp" />
					<ap:include page="param/dispParam.jsp" />
					<ap:include page="param/pagingParam.jsp" />

				    <!-- 검색조건 유지 -->
				    <input type="hidden" name="searchCondition" value="<c:out value='${searchVO.searchCondition}'/>"/>
				    <input type="hidden" name="searchKeyword" value="<c:out value='${searchVO.searchKeyword}'/>"/>
				    <input type="hidden" name="pageIndex" value="<c:out value='${searchVO.pageIndex}' default="1"/>"/>
				    
				    <input type="hidden" name="batchSchdulId" value="<c:out value='${resultInfo.batchSchdulId}'/>"/>
				    
                    <table cellpadding="0" cellspacing="0" class="table_basic mgt10" summary="배치스케줄ID, 배치작업ID, 배치작업명, 실행주기">
                        <caption>
                        배치스케줄 상세조회
                        </caption>
                        <colgroup>
                        <col width="15%" />
                        <col width="*" />
                        </colgroup>
                        <tr>
                            <th scope="row"><label for="배치스케줄ID"> 배치스케줄ID</label></th>
                            <td><c:out value="${resultInfo.batchSchdulId}" escapeXml="false" /></td>
                        </tr>
                        <tr>
                          <th scope="row"><label for="배치작업ID"> 배치작업ID</label></th>
                            <td><c:out value="${resultInfo.batchOpertId}" escapeXml="false" /></td>
                        </tr>
                       <tr>
                         <th scope="row"><label for="배치작업명"> 배치작업명</label></th>
                            <td><c:out value="${resultInfo.batchOpertNm}" escapeXml="false" /></td>
                        </tr>
                       <tr>
                         <th scope="row"><label for="실행주기">실행주기</label></th>
                         <td><c:out value="${resultInfo.executCycleNm}" escapeXml="false" />&nbsp;<c:out value="${resultInfo.executSchdul}" escapeXml="false" />  </td>
                       </tr>
                    </table>
                    </form>
                </div>
                <!-- 등록// -->
                <div class="btn_page_last">
					<a class="btn_page_admin" href="#none" onclick="fn_egov_delete();"><span>삭제</span></a>
                	<a class="btn_page_admin" href="#none" onclick="fn_egov_update_view();"><span>수정</span></a>
					<a class="btn_page_admin" href="#none" onclick="fn_egov_list();"><span>목록</span></a>
                </div>
            </div>
        </div>
        <!--content//-->
    </div>
</body>
</html>