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
<title>정책수립관리|정보</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask" />
<ap:jsTag type="tech" items="acm,msg,util,so" />

<script type="text/javascript">
<c:if test="${resultMsg != null}">
	$(function(){
		jsMsgBox(null, "info", "${resultMsg}");
	});
</c:if>

$(document).ready(function(){
    $('#q_pjt_reg_dt').mask('0000-00-00');
	$('#q_pjt_reg_dt').datepicker({
	    showOn : 'button',
	    defaultDate : -30,
	    buttonImage : '<c:url value="/images/acm/icon_cal.png" />',
	    buttonImageOnly : true,
	    changeYear: true,
	    changeMonth: true,
	    yearRange: "-5:+1"
	});
});


/*
* 검색단어 입력 후 엔터 시 자동 submit
*/
function press(event) {
	if (event.keyCode == 13) {
		event.preventDefault();
		btn_suport_get_list();
	}
}

/*
* 목록 검색
*/
function btn_rsssite_get_list() {

	var form = document.dataForm;
	
	form.df_curr_page.value = 1;
	form.df_method_nm.value = "";
	form.submit();
}


/*
* 목록 검색
*/
function curr_rsssite_get_list() {

	var form = document.dataForm;

	form.df_method_nm.value = "";
	form.submit();
}


//공시여부 선택()
function changeSiteInfo(rssNo){
	$.colorbox({
        title : "지원사업사이트등록및수정",
        href  : "PGDC0070.do?df_method_nm=regRssSite&rssno="+rssNo,
        width : "1100",
        height: "400",     
        iframe : true,
        //overflow : auto,
        overlayClose : false,
        escKey : false,            
    });
}

</script>
</head>
<body>

	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />

<!-- 좌측영역 //-->
    <!--//content-->
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">지원사업수집관리</h2>
                <!-- 타이틀 영역 //-->
                <div class="search_top">
                    <table cellpadding="0" cellspacing="0" class="table_search" summary="조회 조건">
                        <caption>&nbsp;
                        </caption>
                        <caption>
                        조회 조건
                        </caption>
                        <colgroup>
                        <col width="15%" />
                        <col width="*" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">사이트명</th>
                                <td><span class="tar">
                                    <input name="searchKeyword" type="text" id="searchKeyword" style="width:98%; text-align:left" title="사이트명 입력." placeholder="사이트명을 입력하세요."  onfocus="this.placeholder=''; return true"
                           			value='<c:out value="${inparam.searchKeyword}"/>' />
                                    </span></td>
                                <th scope="row">등록일자</th>
                                <td>
                                    <input type="text" name="q_pjt_reg_dt" id="q_pjt_reg_dt" maxlength="10" title="날짜선택" value='<c:out value="${inparam.q_pjt_reg_dt}"/>' style="width:130px" />
                                    <p class="btn_src_zone"><a href="#" class="btn_search" onclick="btn_rsssite_get_list()">조회</a></p></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="block">
                 <ap:pagerParam />
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
                            <col width="*" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">번호</th>
                                    <th scope="col">사이트명</th>
                                    <th scope="col">URL</th>
                                    <th scope="col">필터1</th>
                                    <th scope="col">필터2</th>
                                    <th scope="col">등록일자</th>
                                </tr>
                            </thead>
                            <tbody>
   	                            <c:choose>
								   	<c:when test="${fn:length(rsssiteList) > 0}">
									  	<c:forEach items="${rsssiteList}" var="info" varStatus="status">    
									  	 <tr onclick="changeSiteInfo('${info.rssNo}')">   
									  	 	<td>${info.rssNo}</td>
									  	 	<td>${info.siteNm}</td>
											<td class="tal">${info.url}</td>
											<td>${info.flter1}</td>	
											<td>${info.flter2}</td>	
											<td>${info.registDe}</td>	
										</tr>
										</c:forEach>
									</c:when>
								   	<c:otherwise>
								   		<tr>
								   		<td colspan="6" style="text-align:center;"> 지원사업 사이트 정보가 없습니다.</td>
								   		</tr>
								   	</c:otherwise>
								</c:choose>
                             </tbody>
                        </table>
                    </div>
                    <!-- 리스트// -->
                     <div class="btn_page_last"><a class="btn_page_admin" href="#" onclick="changeSiteInfo('');"><span>등록</span></a> </div>
                    <!--// paginate -->
                    <ap:pager pager="${pager}" />
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