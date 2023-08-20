<%--
  Class Name : EgovQustnrRespondInfoRegist.jsp
  Description : 설문지 통계
  Modification Information

      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2008.03.09    장동한          최초 생성

    author   : 공통서비스 개발팀 장동한
    since    : 2009.03.09

--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<%pageContext.setAttribute("crlf", "\r\n"); %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>설문통계</title>

<ap:jsTag type="web" items="jquery,tools,ui,validate,form,msgBoxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javaScript">
/* ********************************************************
 * 목록 으로 가기
 ******************************************************** */
function fn_egov_list_QustnrRespondInfo(){
	var form = document.getElementById("qustnrRespondInfoManage");
	form.df_method_nm.value = "";
	form.submit();
}
</script>
</head>
<body>
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">설문통계</h2>
                <!-- 타이틀 영역 //-->
				<form id="qustnrRespondInfoManage" name="qustnrRespondInfoManage" action="${svcUrl}" method="post">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />
				
        <table cellspacing="0" border="0" summary="설문통계"  class="table_basic">
            <caption>
            설문통계
            </caption>
            <colgroup>
            <col width="150" />
            <col />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col">설문제목</th>
                    <td><c:out value="${fn:replace(Comtnqestnrinfo[0].qestnrSj , crlf , '<br/>')}" escapeXml="false" /></td>
                </tr>
                <tr>
                    <th scope="col">설문목적</th>
                    <td><c:out value="${fn:replace(Comtnqestnrinfo[0].qestnrPurps , crlf , '<br/>')}" escapeXml="false" /></td>
                </tr>
                <tr>
                    <th scope="col">설문기간</th>
                    <td>${Comtnqestnrinfo[0].qestnrBeginDe}~${Comtnqestnrinfo[0].qestnrEndDe}</td>
                </tr>
                <tr>
                    <th scope="col">설문안내</th>
                    <td><c:out value="${fn:replace(Comtnqestnrinfo[0].qestnrWritngGuidanceCn , crlf , '<br/>')}" escapeXml="false" /></td>
                </tr>
                <%--문항출력 --%>
				<c:forEach items="${Comtnqustnrqesitm}" var="QestmInfo" varStatus="status1">
				
                <tr>
                    <th class="tar" scope="col">${status1.count}</th>
                    <td class="none">
                    	<ul style="width:100%">
                    		<li style="width:99%"><c:out value="${fn:replace(QestmInfo.qestnCn , crlf , '<br/>')}" escapeXml="false" /></li>
					<%-- 문항이 객관식 일때  --%>
					<c:if test="${QestmInfo.qestnTyCode ==  '1'}">
						<%-- 설문항목 LOOP --%>
						<c:set var="chartCount" value="1" />
							<%-- 항목출력 --%>
							<c:forEach items="${Comtnqustnriem}" var="QestmItem" varStatus="status2">
								<c:set var="chartCheck" value="0" />
								<%-- 해당 설문문항 AND 설문문항 체크 --%>
								<c:if test="${QestmInfo.qestnrTmplatId eq QestmItem.qestnrTmplatId && QestmInfo.qestnrId eq QestmItem.qestnrId && QestmInfo.qestnrQesitmId eq QestmItem.qestnrQesitmId}">

                    		<li style="width:99%">${chartCount}) <c:out value="${fn:replace(QestmItem.iemCn , crlf , '<br/>')}" escapeXml="false" />
                    			<span>
									<%-- 설문통계(객관식) LOOP --%> 
									<c:forEach items="${qestnrStatistic1}" var="QestmStatistic1" varStatus="status3">
										<c:if test="${QestmInfo.qestnrTmplatId eq QestmStatistic1.qestnrTmplatId && QestmInfo.qestnrId eq QestmStatistic1.qestnrId && QestmStatistic1.qestnrQesitmId eq QestmItem.qestnrQesitmId && QestmStatistic1.qustnrIemId eq QestmItem.qustnrIemId}">
											${QestmStatistic1.qustnrPercent}%
											<c:set var="chartCheck" value="${chartCheck+1}" />
										</c:if>
									</c:forEach> 
									<c:if test="${chartCheck eq 0}">0% <c:set var="chartCount" value="${chartCount+1}" /></c:if>
                    			</span>
                    		</li>
								</c:if>
							</c:forEach>
					</c:if>
					<%-- 주관식 --%>
					<c:if test="${QestmInfo.qestnTyCode ==  '2'}">
						<%-- 설문통계(주관식) LOOP --%>
						<c:forEach items="${qestnrStatistic2}" var="QestmStatistic2" varStatus="status4">
							<c:if test="${QestmInfo.qestnrTmplatId eq QestmStatistic2.qestnrTmplatId && QestmInfo.qestnrId eq QestmStatistic2.qestnrId && QestmInfo.qestnrQesitmId eq QestmStatistic2.qestnrQesitmId}">
                    		<li style="width:99%"><c:out value="${fn:replace(QestmStatistic2.respondNm , crlf , '<br/>')}" escapeXml="false" /> : 
                    			<c:out value="${fn:replace(QestmStatistic2.respondAnswerCn , crlf , '<br/>')}" escapeXml="false" />
                    		</li>
							</c:if>
						</c:forEach>
					</c:if>
                    	</ul>
                    </td>
                </tr>
				</c:forEach>

            </tbody>
        </table>
				</form>

                <div class="btn_page_last">
                	<a class="btn_page_admin" href="#none" onclick="fn_egov_list_QustnrRespondInfo();"><span>목록</span></a> 
                </div>
            </div>
        </div>
        <!--content//-->
    </div>
</body>
</html>