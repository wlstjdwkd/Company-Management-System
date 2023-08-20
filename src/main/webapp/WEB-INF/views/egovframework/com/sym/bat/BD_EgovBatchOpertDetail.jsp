<%--
  Class Name : EgovBatchOpertDetail.jsp
  Description : 배치작업 상세조회 페이지
  Modification Information
 
      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2010.07.07    김진만          최초 생성
 
    author   : 공통서비스 개발팀 김진만
    since    : 2010.07.07
   
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
<title>배치작업 상세조회</title>

<ap:jsTag type="web" items="jquery,tools,ui,validate,form,msgBoxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javaScript">

/* ********************************************************
 * 목록 으로 가기
 ******************************************************** */
function fn_egov_list(){
    var varForm = document.getElementById("batchOpert");
    varForm.df_method_nm.value = "";
    varForm.submit();
}
/* ********************************************************
 * 수정화면으로  바로가기
 ******************************************************** */
function fn_egov_update_view(){
    var varForm = document.getElementById("batchOpert");
    varForm.df_method_nm.value = "getBatchOpertForUpdate";
    varForm.submit();
}
/* ********************************************************
 * 삭제 처리
 ******************************************************** */
function fn_egov_delete(){
	jsMsgBox(null,'confirm','<spring:message code="confirm.common.delete" />',function(){$("#df_method_nm").val("deleteBatchOpert"); $("#batchOpert").submit();});
}
</script>
</head>

<body>
   <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title_line">배치작업 상세조회</h2>
                <!-- 타이틀 영역 //-->
                <div class="block">
                    <h3 class="mgt30">
                    <span>항목은 입력 필수 항목 입니다.</span>
                    </h3>
                    <!--// 등록 -->
					<form id="batchOpert" name="batchOpert"  action="${svcUrl }" method="post">
					<ap:include page="param/defaultParam.jsp" />
					<ap:include page="param/dispParam.jsp" />
					<ap:include page="param/pagingParam.jsp" />
					
					<!-- 검색조건 유지 -->
					<input type="hidden" name="searchCondition" value="<c:out value='${searchVO.searchCondition}'/>"/>
					<input type="hidden" name="searchKeyword" value="<c:out value='${searchVO.searchKeyword}'/>"/>
					<input type="hidden" name="batchOpertId" value="<c:out value='${resultInfo.batchOpertId}'/>"/>
					
                    <table cellpadding="0" cellspacing="0" class="table_basic mgt10" summary="배치작업명, 배치프로그램, 파라미터">
                        <caption>배치작업조회</caption>
                        <colgroup>
                        <col width="15%" />
                        <col width="*" />
                        </colgroup>
                        <tr>
                            <th scope="row" class="point"><label for="batchOpertNm">배치작업명</label></th>
                            <td>${resultInfo.batchOpertNm } </td>
                        </tr>
                        <tr>
                            <th scope="row" class="point"><label for="batchProgrm">배치프로그램</label></th>
                            <td>${resultInfo.batchProgrm } </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="paramtr">파라미터</label></th>
                            <td>${resultInfo.paramtr } </td>
                        </tr>                        
                    </table>
                </div>

                <div class="btn_page_last">
	                <a class="btn_page_admin" href="#none" onclick="fn_egov_delete();"><span>삭제</span></a>
	                <a class="btn_page_admin" href="#none" onclick="fn_egov_update_view();"><span>수정</span></a>
	                <a class="btn_page_admin" href="#none" onclick="fn_egov_list();"><span>목록</span></a>
                </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>

</body>
</html>