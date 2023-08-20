<%--
  Class Name : EgovQustnrItemManageList.jsp
  Description : 설문항목 목록 페이지
  Modification Information

      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2008.03.09    장동한          최초 생성

    author   : 공통서비스 개발팀 장동한
    since    : 2009.03.09

--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>설문항목관리</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javascript">

<c:if test="${resultMsg != null}">
$(function(){
	jsMsgBox(null, "info", "${resultMsg}");
});
</c:if>

/* ********************************************************
 * 등록 처리 함수
 ******************************************************** */
function fn_egov_regist_QustnrItemManage(){
	var form = document.dataForm;
	
	form.action = "<c:url value='${svcUrl}' />";
	form.df_method_nm.value="insertEgovQustnrItemManage";
	form.submit();
}

/* ********************************************************
 * 상세회면 처리 함수
 ******************************************************** */
function fn_egov_detail_QustnrItemManage(qustnrIemId){
	var form = document.dataForm;

	form.qustnrIemId.value = qustnrIemId;
	form.df_method_nm.value="EgovQustnrItemManageDetail";
	form.action = "<c:url value='${svcUrl}' />";
	form.submit();
}
</script>
</head>
<body>
<div id="self_dgs">
	<div class="pop_q_con">
		<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		
		<!-- LNB 출력 방지 -->
		<input type="hidden" id="no_lnb" value="true" />

		<input type="hidden" name="qestnrQesitmId" id="qestnrQesitmId" value="${qustnrItemManageVO.qestnrQesitmId }" />
		<input type="hidden" name="qustnrIemId" id="qustnrIemId" value="" />
		
        <!--// 리스트 -->
        <div class="list_zone">
            <table cellspacing="0" border="0" summary="설문항목 목록">
                <caption>
                설문항목 목록
                </caption>
                <colgroup>
                <col width="*" />
                <col width="*" />
                <col width="*" />
                <col width="*" />
                <col width="*" />
                </colgroup>
                <thead>
                    <tr>
                        <th scope="col">순번</th>
                        <th scope="col">항목내용</th>
                        <th scope="col">기타답변여부</th>
                        <th scope="col">등록자</th>
                        <th scope="col">등록일</th>
                    </tr>
                </thead>
                <tbody>
				<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
				<c:if test="${fn:length(resultList) == 0}">
					<tr>
						<td colspan="5">
							<c:if test="${param.searchKeyword == null or param.searchKeyword == '' }"><spring:message code="info.nodata.msg" /></c:if>
							<c:if test="${param.searchKeyword != null and param.searchKeyword != '' }"><spring:message code="info.noresult.msg" /></c:if>
						</td>
					</tr>
				</c:if>
				<%-- 데이터를 화면에 출력해준다 --%>
				<c:forEach items="${resultList}" var="resultInfo" varStatus="status">
                    <tr>
                        <td>${resultInfo.iemSn }</td>
                        <td class="tal"><a href="#none" onclick="fn_egov_detail_QustnrItemManage('${resultInfo.qustnrIemId}');"><c:out value="${resultInfo.iemCn}" /></a></td>
                        <td><c:if test="${resultInfo.etcAnswerAt == 'Y'}">Yes</c:if><c:if test="${resultInfo.etcAnswerAt != 'Y'}">No</c:if></td>
                        <td>${resultInfo.registerNm}</td>
                        <td>${fn:substring(resultInfo.rgsde, 0, 10)}</td>
                    </tr>
				</c:forEach>
                </tbody>
            </table>
        </div>
        </form>
        <div class="btn_page_last"><a class="btn_page_admin" href="#none" onclick="fn_egov_regist_QustnrItemManage();"><span>등록</span></a></div>
	</div>
</div>
</body>
</html>

