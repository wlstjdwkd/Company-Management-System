<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

$(document).ready(function(){
	$("#btn_excel_down").click(function(){
		$("#df_method_nm").val("processExcelRsolver");
		$("#dataForm").submit();
		//jsFiledownload("/PGIM0010.do","df_method_nm=excelRsolver");
	});	
});

/*
 * 검색단어 입력 후 엔터 시 자동 submit
 */
function press(event) {
	if (event.keyCode == 13) {
		btn_joinLog_get_list();
	}
}

/* 
 * 목록 검색
 */
function btn_joinLog_get_list() {
	var form = document.dataForm;
	form.df_curr_page.value = 1;
	form.df_method_nm.value = "processVisitStats";
	form.submit();
}

</script>
</head>
<body>
	<form name="dataForm" id="dataForm" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />
   <!--//content-->
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">방문자통계</h2>
                <!-- 타이틀 영역 //-->
                <div class="search_top">
                    <table cellpadding="0" cellspacing="0" class="table_search" summary="조회 조건">
                        <caption>&nbsp;
                        </caption>
                        <caption>
                        조회 조건
                        </caption>
                        <colgroup>
                        <col width="11%" />
                        <col width="*" />
                        <col width="11%" />
                        <col width="*" />
                        <col width="9%" />
                        <col width="*" />
                        <col width="9%" />
                        <col width="*" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <td class="only">
                                	<select name="searchYear" title="년도" id="searchYear" style="width:80px">
                                		<c:forEach begin="2015" end="${currentYear}" var="yearStat">
											<option value="${yearStat}" <c:if test="${indexInfo.searchYear == yearStat}"> selected="selected" </c:if>>${yearStat}</option>                                	
										</c:forEach>
                                    </select>
                                    <select name="searchMonth" title="월" id="searchMonth" style="width:80px">
                                   		<c:forEach begin="1" end="9" step="1" var="stat">    
                                    		<option value="0${stat}" <c:if test ="${indexInfo.searchMonth == stat}"> selected="selected" </c:if>>${stat}</option>
                                        </c:forEach>
                                        <c:forEach begin="10" end="12" step="1" var="stat">    
                                    		<option value="${stat}" <c:if test ="${indexInfo.searchMonth == stat}"> selected="selected" </c:if>>${stat}</option>
                                        </c:forEach>
                                    </select><p class="btn_src_zone"><a href="#" class="btn_search" onclick = "btn_joinLog_get_list();">검색</a></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="block">
                    <ul>
                        <li class="d1">방문자접속통계는 전일까지 확인 가능합니다.</li>
                        <li class="d1">따라서 누적방문자접속통계, 당월누적합계, 누적총합계는 모두 전일 집계 데이터 이오니 이점 참고하시기 바랍니다.</li>
                    </ul>
                </div>
                <div class="block">
                    <div class="total">
                        <p>누적방문자통계 : 총 <strong><fmt:formatNumber value = "${totalVisitStats}" pattern = "#,##0"/></strong>명 </p>
                        <div class="btn_pag fr mgt10"> <a class="btn_page_admin" href="#" id="btn_excel_down"><span>엑셀다운로드</span></a> </div>
                    </div>
                    <!--// 리스트 -->
                    <div class="list_zone">
                        <table cellspacing="0" border="0" summary="목록">
                            <caption>
                            리스트
                            </caption>
                            <colgroup>
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">일</th>
                                    <th scope="col">${indexInfo.searchYear} - ${indexInfo.searchMonth}</th>
                                    <th scope="col">당월누적합계</th>
                                    <th scope="col">누적총합계</th>
                                </tr>
                            </thead>
                            <tbody>
                            <tr class="sum">
                                    <td>익월누적순</td>
                                    <td class="tar">&nbsp;</td>
                                    <td class="tar">&nbsp;</td>
                                    <td class="tar">
                                    <c:if test = "${beforeVisitStats.requstCo != null }"><fmt:formatNumber value = "${beforeVisitStats.requstCo }" pattern = "#,##0"/></c:if>
                                    <c:if test = "${beforeVisitStats.requstCo == null }">0</c:if>
                                    </td>
                                </tr>
                            <c:forEach items="${visitStatsList}" var="visitStats" varStatus="status"> 
                                <tr>
                                    <td>${visitStats.de}</td>
                                    <td class="tar"><fmt:formatNumber value = "${visitStats.sum_day}" pattern = "#,##0"/></td>
                                    <td class="tar"><fmt:formatNumber value = "${visitStats.acc_day}" pattern = "#,##0"/></td>
                                    <td class="tar"><fmt:formatNumber value = "${visitStats.total_day}" pattern = "#,##0"/></td>
                                </tr>
                            </c:forEach>    
                            </tbody>
                        </table>
                    </div>
                    <!-- 리스트// -->
                    <div class="mgt10"></div>
                </div>
                <!--리스트영역 //-->
            </div>
        </div>
        <!--content//-->
</div>
</form>
</body>
</html>