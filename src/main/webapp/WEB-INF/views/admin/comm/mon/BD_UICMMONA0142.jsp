<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>정보</title>


<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin, mask" />
<ap:jsTag type="tech" items="acm,msg,util" />
<script type="text/javascript">
$(document).ready(function(){
	// 달력
	$('#searchDate').datepicker({
        showOn : 'button',
        defaultDate : null,
        buttonImage : '/images/acm/icon_cal.png',
        buttonImageOnly : true,
        changeYear: true,
        changeMonth: true,
        yearRange: "2014:+1"
    });	
	
	$('#searchDate').mask('0000-00-00');
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
	form.df_method_nm.value = "";
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
                <h2 class="menu_title">접속로그</h2>
                <!-- 타이틀 영역 //-->
                <div class="search_top">
                    <table cellpadding="0" cellspacing="0" class="table_search" summary="조회 조건">
                        <caption>
                        조회 조건
                        </caption>
                        <colgroup>
                        <col width="15%">
                        <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">조회일</th>
                                <td>
                                <input type="text" name="searchDate" id="searchDate" maxlength="10" title="날짜선택" value="${indexInfo.searchDate }"/>
                                    <select name="searchSelect" title="사용자" id="searchSelect" style="width:130px">
                                    	<option value="1" <c:if test ="${indexInfo.searchSelect=='1'}"> selected="selected" </c:if>>선택</option>
                                        <option value="2" <c:if test ="${indexInfo.searchSelect=='2'}"> selected="selected" </c:if>>사용자ID</option>
                                        <option value="3" <c:if test ="${indexInfo.searchSelect=='3'}"> selected="selected" </c:if>>접속IP</option>
                                        <option value="4" <c:if test ="${indexInfo.searchSelect=='4'}"> selected="selected" </c:if>>업무명</option>
                                    </select>
                                    <input name="searchWrd" title="검색어를 입력하세요." id="searchWrd" type="text" style="width:500px" value = "${indexInfo.searchWrd}" onkeypress="press(event);"/>
                                    <p class="btn_src_zone"><a href="#" class="btn_search" onclick = "btn_joinLog_get_list();" >검색</a></p>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- 등록// -->
                <!-- // 리스트영역-->
               <div class="block">
                    <ap:pagerParam />
                    <!--// 리스트 -->
                    <div class="list_zone">
                        <table cellspacing="0" border="0" summary=" 리스트">
                            <caption>
                            리스트
                            </caption>
                            <colgroup>
                                <col width="5%">
                                <col width="10%">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                            </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">번호</th>
                                        <th scope="col">사용자ID</th>
                                        <th scope="col">접속IP</th>
                                        <th scope="col">업무명</th>
                                        <th scope="col">시작시간</th>
                                        <th scope="col">실행시간(초)</th>
                                    </tr>
                                </thead>
                                
                                <tbody>     
                                	<c:forEach items="${joinLogList}" var="joinLog" varStatus="status">
                                    <tr>
										<td >${pagerNo-(status.index)}</td>
                                        <td class="tal">${joinLog.loginId }</td>
                                        <td class="tal">${joinLog.rqesterIp }</td>
                                        <td class="tal">${joinLog.progrmNm }</td>
                                        <td>${joinLog.beginTm } </td>
                                        <td>${joinLog.dTime }</td>
                                    </tr>
									</c:forEach>
                                </tbody>
                            </table>
                      </div>
                    <!-- 리스트// -->
                    <div class="mgt10"></div>
                    <!--// paginate -->
                    <ap:pager pager="${pager}" />
                    </div>
                    <!-- paginate //-->
                </div>
                <!--리스트영역 //-->
            </div>
        </div>
        <!--content//-->
</div>
</form>
</body>
</html>