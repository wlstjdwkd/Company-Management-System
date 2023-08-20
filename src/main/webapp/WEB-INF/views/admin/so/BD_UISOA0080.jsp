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
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,mask,colorboxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javascript">

$(document).ready(function(){
	// 검색
	$("#btn_search").click(function(){		
		$("#df_method_nm").val("");
		$("#dataForm").attr("action", "${svcUrl}");
		$("#dataForm").submit();		
	});	
}); // ready

//기업소개수정 팝업
var fn_cmpny_intrcn = function(epNo, bizrno){
	$.colorbox({
		title : "회사소개",
		href : "<c:url value='/PGMY0030.do?df_method_nm=cmpnyIntrcnMngForm&USER_NO="+ epNo +"&ad_bizrno="+ bizrno +"' />",
		width : "80%",
		height : "80%",
		overlayClose : false,
		escKey : false,
		iframe : true
	});
};

//기업소개등록 팝업
var fn_cmpny_intrcn_insert = function(){
	$.colorbox({
		title : "회사소개",
		href : "<c:url value='/PGMY0030.do?df_method_nm=cmpnyIntrcnMngForm' />",
		width : "80%",
		height : "80%",
		overlayClose : false,
		escKey : false,
		iframe : true
	});
};

//회원정보 팝업
var fn_userInfo = function(userNo){
	$.colorbox({
		title : "회원정보",
		href : "<c:url value='/PGMY0070.do?df_method_nm=popUserInfo&ad_userNo=" + userNo + "' />",
		width : "700",
		height : "400",
		overlayClose : false,
		escKey : false,
		iframe : true
	});
};

</script>

</head>
<body>

<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" enctype="multipart/form-data" method="post">

<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />
<ap:include page="param/pagingParam.jsp" />

	<div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">기업정보관리</h2>
                <!-- 타이틀 영역 //-->
                <!--// 검색 조건 -->
                <div class="search_top">
                    <table cellpadding="0" cellspacing="0" class="table_search" summary="검색" >
                        <caption>
                        검색
                        </caption>
                        <colgroup>
                        <col width="*" />
                        <col width="*" />                        
                        </colgroup>
                        <tr>
                            <td class="only" colspan = "2">
                            	<select name="search_type" title="검색조건선택" id="search_type" style="width:110px">
                                    <option value="0" <c:if test="${param.search_type == 0 }">selected="selected"</c:if>>기업명</option>
                                    <option value="1" <c:if test="${param.search_type == 1 }">selected="selected"</c:if>>아이디</option>
                                    <option value="2" <c:if test="${param.search_type == 2 }">selected="selected"</c:if>>작성자</option>
                                </select>
                                <input name="search_word" type="text" id="search_word" value="${param.search_word }" style="width:300px;" title="검색어 입력" placeholder="검색어를 입력하세요."/>
                                <p class="btn_src_zone"><a href="#" class="btn_search" id="btn_search">검색</a></p>
                            </td>
                        </tr>
                        <tr>
                        	<th scope="col" style="width:110px;">기업특성</th>
                            <td>
                            	<select name="search_chartr" title="검색조건선택" id="search_chartr">
                            	    <option value="" selected="selected">-선택-</option>
                                    <option value="1" <c:if test="${param.search_chartr == 1 }">selected="selected"</c:if>>기업소개</option>
                                    <option value="2" <c:if test="${param.search_chartr == 2 }">selected="selected"</c:if>>월드클래스300</option>
                                    <option value="3" <c:if test="${param.search_chartr == 3 }">selected="selected"</c:if>>ATC</option>
                                    <option value="4" <c:if test="${param.search_chartr == 4 }">selected="selected"</c:if>>코스피</option>
                                    <option value="5" <c:if test="${param.search_chartr == 5 }">selected="selected"</c:if>>코스닥</option>
                                    <option value="6" <c:if test="${param.search_chartr == 6 }">selected="selected"</c:if>>입사지원</option>
                                </select>
							</td>
						</tr>
                    </table>
                </div>
                <div class="block">
                    <ap:pagerParam />
                    
                    <!--// 리스트 -->
                    <div class="list_zone mgb10">
                        <table cellspacing="0" border="0" summary="기본게시판 목록으로 번호,제목,작성일 등의 조회 정보를 제공합니다.">
                            <caption>
                            기본게시판 목록
                            </caption>
                            <colgroup>                            
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            </colgroup>
                            <thead>
                                <tr>                                    
                                    <th scope="col">번호</th>
                                    <th scope="col">기업명</th>
                                    <th scope="col">작성자</th>
                                    <th scope="col">수정일</th>
                                </tr>
                            </thead>
                            <tbody>                                
                                <c:forEach items="${dataList }" var="dataMap" varStatus="status">
                                <tr>                                    
                                    <td class="tac">${pager.indexNo - status.index}</td>
                                    <td><a href="#none" onclick="fn_cmpny_intrcn('${dataMap.USER_NO}', '${dataMap.BIZRNO}')">${dataMap.ENTRPRS_NM }</a></td>
                                    <td class="job2"><a href="#none" onclick="fn_userInfo('${dataMap.USER_NO}')">${dataMap.CHARGER_NM }</td>
                                    <td>
                                    	<c:choose>
	                                    	<c:when test="${not empty dataMap.UPDT_DE }">${dataMap.UPDT_DE }</c:when>
	                                    	<c:otherwise>${dataMap.REGIST_DE }</c:otherwise>
                                    	</c:choose>
                                    </td>
                                </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <!-- 리스트// -->
                    <div class="btn_page_last">
						<a class="btn_page_admin" href="#" onclick="fn_cmpny_intrcn_insert();"><span>기업소개등록</span></a>
					</div>
					<!--// paginate -->
					<ap:pager pager="${pager}" />
					<!-- paginate //-->
                </div>
            </div>
            <!--content//-->
        </div>
    </div>
</form>

</body>
</html>