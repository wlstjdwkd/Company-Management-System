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

//기업소개 팝업
var fn_cmpny_intrcn = function(epNo, bizrno){
	$.colorbox({
		title : "회사소개",
		href : "<c:url value='/PGCS0070.do?df_method_nm=cmpnyIntrcn&ad_ep_no="+ epNo +"&ad_bizrno="+ bizrno +"' />",
		width : "80%",
		height : "80%",
		overlayClose : false,
		escKey : false,
		iframe : true
	});
};


//채용정보 팝업
var fn_empmn_info = function(empmnNo){	
	$("#ad_empmn_manage_no").val(empmnNo);
	$("#df_method_nm").val("empmnInfoView");
			
	var empmnInfoWindow = window.open('', 'empmnInfo', 'width=900, height=680, top=100, left=100, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbars=yes, fullscreen=no, resizable=yes');	
	document.dataForm.action = "/PGCS0070.do";
	document.dataForm.target = "empmnInfo";
	document.dataForm.submit();
	document.dataForm.target = "";
	if(empmnInfoWindow){
		empmnInfoWindow.focus();
	}
	document.dataForm.action = "/PGSO0060.do";
};

//워크넷 페이지 오픈
var fn_move_weburl = function(url) {
	window.open(url,"_blank");
};

</script>

</head>
<body>

<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post" >

<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />
<ap:include page="param/pagingParam.jsp" />

<input type="hidden" id="ad_empmn_manage_no" name="ad_empmn_manage_no" />

	<div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">채용정보관리 </h2>
                <!-- 타이틀 영역 //-->
                <!--// 검색 조건 -->
                <div class="search_top">
                    <table cellpadding="0" cellspacing="0" class="table_search" summary="검색" >
                        <caption>
                        검색
                        </caption>
                        <colgroup>
                        <col width="100%" />
                        </colgroup>
                        <tr>
                            <td class="only">
                            	<select name="search_type" title="검색조건선택" id="search_type" style="width:110px">
                                    <option value="0" <c:if test="${param.search_type == 0 }">selected="selected"</c:if>>제목</option>
                                    <option value="1" <c:if test="${param.search_type == 1 }">selected="selected"</c:if>>기업명</option>
                                    <option value="2" <c:if test="${param.search_type == 2 }">selected="selected"</c:if>>직종</option>
                                </select>
                                <input name="search_word" type="text" id="search_word" value="${param.search_word }" style="width:300px;" title="검색어 입력" placeholder="검색어를 입력하세요."/>
                                <p class="btn_src_zone"><a href="#" class="btn_search" id="btn_search" >검색</a></p>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="block">
                    <ul>
                        <li class="d1">지원수를 클릭하시면 해당 채용공고에 등록된 지원자 목록을 확인하실 수 있습니다.<br />
                            ※  마감 30일이 지난 채용공고의 입사신청서는 개인정보보호를 위해 삭제되어 확인인 불가할 수 있습니다. </li>
                    </ul>
                </div>
                <div class="block2">
                    <ap:pagerParam />
                    
                    <!--// 리스트 -->
                    <div class="list_zone mgb10">
                        <%-- <table cellspacing="0" border="0" summary="기본게시판 목록으로 번호,제목,작성일 등의 조회 정보를 제공합니다.">
                            <caption>
                            기본게시판 목록
                            </caption>
                            <colgroup>
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">번호</th>
                                    <th scope="col">기업명</th>
                                    <th scope="col">제목</th>
                                    <th scope="col">직종</th>
                                    <th scope="col">경력</th>
                                    <th scope="col">학력</th>
                                    <th scope="col">근무형태</th>
                                    <th scope="col">마감일</th>
                                    <th scope="col">지원수</th>
                                </tr>
                            </thead>
                            <tbody>                                
                                <c:forEach items="${dataList }" var="dataMap" varStatus="status">
                                <tr>
                                    <td>${pager.indexNo - status.index}</td>
                                    <td><a href="#none" onclick="fn_cmpny_intrcn('${dataMap.EP_NO }')">${dataMap.ENTRPRS_NM }</a></td>
                                    <td class="tal">
                                    	<c:if test="${dataMap.CLOSED == 1 }"><img src="<c:url value="/images/acm/icon_finish.png"/>"  alt="마감" /></c:if>
                                    	<c:if test="${dataMap.CLOSED == 0 }"><img src="<c:url value="/images/acm/icon_recruit.png"/>"  alt="채용" /></c:if>
                                    	<a href="#none" onclick="fn_empmn_info('${dataMap.EMPMN_MANAGE_NO }')">${dataMap.EMPMN_SJ }</a>
                                    </td>
                                    <td class="job2">${dataMap.JSSFC }</td>
                                    <td>
									<c:forEach items="${dataMap.item25List }" var="item25" varStatus="inStatus">
										<c:if test="${not inStatus.first }">,</c:if>
										<c:choose>
										<c:when test="${item25.IEM_VALUE == 'CK2' }">${item25.ATRB1 }년이상</c:when>
										<c:otherwise>${item25.CODE_NM }</c:otherwise>
										</c:choose>
									</c:forEach>
									${dataMap.item25 }
									</td>
                                    <td>${dataMap.item27 }</td>
                                    <td class="tal">${dataMap.item33 }</td>
                                    <td>${dataMap.RCRIT_END_DE }</td>
                                    <td>${dataMap.DESIRE_CNT }</td>
                                </tr>
                                </c:forEach>                                
                            </tbody>
                        </table> --%>
                        
                        <table cellspacing="0" border="0" summary="기본게시판 목록으로 번호,제목,작성일 등의 조회 정보를 제공합니다.">
                            <caption>
                            기본게시판 목록
                            </caption>
                            <colgroup>
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />                            
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">번호</th>
                                    <th scope="col">기업명</th>
                                    <th scope="col">제목</th>                                    
                                    <th scope="col">경력</th>
                                    <th scope="col">학력</th>                                    
                                    <th scope="col">마감일</th>
                                    <th scope="col">지원수</th>
                                </tr>
                            </thead>
                            <tbody>                                
                                <c:forEach items="${dataList }" var="dataMap" varStatus="status">
                                <tr>
                                    <td>${pager.indexNo - status.index}</td>
                                    <td>
                                    	<c:if test="${dataMap.ENTRPRS_VW_AT == 'Y' }">
                                       		<a href="#none" onclick="fn_cmpny_intrcn('${dataMap.USER_NO }', '${dataMap.BIZRNO }')">${dataMap.ENTRPRS_NM }</a>
                                       	</c:if>
                                       	<c:if test="${dataMap.ENTRPRS_VW_AT != 'Y' }">
                                       		${dataMap.ENTRPRS_NM }
                                       	</c:if>
                                    </td>
                                    <td class="tal">
                                    	<c:if test="${dataMap.CLOSED == 1 }"><img src="<c:url value="/images/acm/icon_finish.png"/>"  alt="마감" /></c:if>
                                    	<c:if test="${dataMap.CLOSED == 0 }"><img src="<c:url value="/images/acm/icon_recruit.png"/>"  alt="채용" /></c:if>
                                    	<c:if test="${fn:substring(dataMap.WANTED_AUTH_NO, 0, 1) != 'K'}">       <!-- 워크넷 자체 데이터가 아니라면 상세정보가 없으므로 링크 -->
                                       		<c:choose>
						                	<c:when test="${fn:trim(dataMap.WANTED_AUTH_NO) == ''}">   <!-- 워크넷 자체 데이터가 아니라도 직접 입력했다면 팝업 -->
						                		<a href="#none" onclick="fn_empmn_info('${dataMap.EMPMN_MANAGE_NO }')">${dataMap.EMPMN_SJ }</a>
						                	</c:when>
						                	<c:otherwise>
						                		<a href="#none" onclick="fn_move_weburl('${dataMap.ECNY_APPLY__WEB_ADRES }')">${dataMap.EMPMN_SJ }</a>
						                	</c:otherwise>
						                	</c:choose>
                                       	</c:if>
                                       	<c:if test="${fn:substring(dataMap.WANTED_AUTH_NO, 0, 1) == 'K'}">
                                       		<a href="#none" onclick="fn_empmn_info('${dataMap.EMPMN_MANAGE_NO }')">${dataMap.EMPMN_SJ }</a>
                                       	</c:if>
                                    </td>
                                    <td>${dataMap.item25 }<c:if test="${dataMap.item25 == '' }">${dataMap.CAREER_DETAIL_RQISIT2}</c:if></td>
                                    <td>${dataMap.item27 }<c:if test="${dataMap.item27 == '' }">${dataMap.CAREER_DETAIL_RQISIT3}</c:if></td>                           
                                    <td>${dataMap.RCRIT_END_DE }</td>
                                    <td>${dataMap.DESIRE_CNT }</td>
                                </tr>
                                </c:forEach>                                
                            </tbody>
                        </table>
                    </div>
                    <!-- 리스트// -->
                    
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