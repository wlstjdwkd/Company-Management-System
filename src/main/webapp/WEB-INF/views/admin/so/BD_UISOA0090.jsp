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
<ap:jsTag type="tech" items="acm,msg,util,cs" />

<script type="text/javascript">
$(document).ready(function(){
	
	$("#btn_search").click( function() {
		document.dataForm.action = "/PGSO0090.do";
		$("#df_method_nm").val("");
		$("#dataForm").submit();
	});
	
	$("#btn_filter_insert").click( function() {
		jsMsgBox(
			null,
			'confirm',
			'<spring:message code="confirm.common.save" />',
			function() {
				
				
				$("#df_method_nm").val("insertFilter");
				$("#dataForm").submit();
			}
		)
	
	});
	
});

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

//채용 공고
var fn_empmn_info = function(empmnNo){

/*	$.colorbox({
		title : "채용공고",
		href : "<c:url value='/PGCS0070.do?df_method_nm=empmnInfoView&ad_empmn_manage_no="+ empmnNo +"' />",
		width : "80%",
		height : "80%",
		overlayClose : false,
		escKey : false,
		iframe : true
	});
*/	
	$("#ad_empmn_manage_no").val(empmnNo);
	$("#df_method_nm").val("empmnInfoView");
			
	var empmnInfoWindow = window.open('', 'empmnInfo', 'width=1000, height=680, top=100, left=100, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbars=yes, fullscreen=no, resizable=yes');	
	document.dataForm.action = "/PGCS0070.do";
	document.dataForm.target = "empmnInfo";
	document.dataForm.submit();
	document.dataForm.target = "";
	if(empmnInfoWindow){
		empmnInfoWindow.focus();
	}
};


//워크넷 페이지 오픈
var fn_move_weburl = function(url) {
	window.open(url,"_blank");
};

var wc300_popup = function() {
	window.open("/popup/wc300Popup.html","event20150825","width=390,height=660, left=10, top=24, scrollbars=no, resizable=no");	
};

var atc_popup = function() {
	window.open("/popup/atcPopup.html","event20150825","width=390,height=660, left=10, top=24, scrollbars=no, resizable=no");	
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
                <h2 class="menu_title">채용관리필터 </h2>
                <!-- 타이틀 영역 //-->
                <!--// 검색 조건 -->
                <div class="search_top">
                    <table cellpadding="0" cellspacing="0" class="table_search" summary="검색" >
                        <caption>
                        	검색
                        </caption>
                        <colgroup>
                                <col width="10%" />
                                <col width="40%" />
                        </colgroup>
                        <tr>
                        	<th scope="row">채용공고 제목</th>
                            <td>
                            	<input type="text" value="불포함항목" title="불포함항목" style="width:80px" readonly/>
                                <input name="ad_hire_word" id="ad_hire_word" type="text" value="${ad_hire_word}" style="width:700px;" title="검색어 입력" placeholder="항목들을 입력하세요.(ex 기업,신입,청호)"/>
                            </td>
                        </tr>
                        <tr>
                        	<th scope="row">직종</th>
                        	<td>
                            	<input type="text" value="불포함항목" title="불포함항목" style="width:80px" readonly/>
                                <input  name="ad_job_word" id="ad_job_word" type="text" value="${ad_job_word}" style="width:700px;" title="검색어 입력" placeholder="항목들을 입력하세요.(ex 기업,신입,청호)"/>
                        	</td>
                        </tr>
                        <tr>
                        	<th scope = "row">기본 정렬조건</th>
                        	<td>
                        		<input type="radio" name = "ad_range" id="ad_range_R" value="1" <c:if test="${ad_range eq '1' }"> checked</c:if> /><label for="ad_range_R">최근 등록일순.</label>
                        		<input type="radio" name = "ad_range" id="ad_range_M" value="2" <c:if test="${ad_range eq '2' }"> checked</c:if> /><label for="ad_range_M">마감일순.</label>
                        		<!-- <input type="radio" name = "ad_range" id="ad_range_H" value="3" <c:if test="${ad_range eq '3' }"> checked</c:if> /><label for="ad_range_H">확인서발급우선.</label>  -->
                        		<p class="btn_src_zone"><a href="#" class="btn_search" id="btn_search" >검색</a></p>
                        	</td>
                        </tr>
                    </table>
                </div>

                <div class="block2">
                    <ap:pagerParam />
                    <!--// 리스트 -->
                    <div class="list_zone mgb10">                     
                        <table cellspacing="0" border="0" summary="" id="">
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
                                    <th scope="col">채용제목</th>     
                                    <th scope="col">마감일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${list }" var="data" varStatus="status">
              					<tr>
                					<td>${pager.indexNo - status.index}</td>
                					<td><span>
                						<c:choose>
                        					<c:when test="${not empty data.LOGO_FILE_SN }">	      								
	      										<img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${data.LOGO_FILE_SN}" />" width="48" height="20" alt="smba" title="smba"/>
		                        			</c:when>
                        					<c:otherwise>
                        						<img src="<c:url value="/images/cs/logo.png"/>" width="80" height="25" id="img_photo" alt="로고" style="border:#666 solid 1px" />
                        					</c:otherwise>
                        				</c:choose>
										</span>
										<span>                                    	
										<c:choose>
                        					<c:when test="${data.ENTRPRS_VW_AT == 'Y'}">
     	                                		<a href="#" onclick="fn_cmpny_intrcn('${data.USER_NO }', '${data.BIZRNO }')">${data.entrprsNm }</a>
                        					</c:when>
                        					<c:otherwise>
        						           		${data.entrprsNm }
                        					</c:otherwise>
                        				</c:choose>
                        				</span>
                 					<div class="mgt12" style="text-align:center">
                 						<c:forEach items = "${data.chartr }" var="chartr" varStatus="status">
                 						<c:if test="${chartr.CHARTR_CODE == '1'}">
                 							<span class="ico_k"></span>
                 						</c:if>	
                 						<c:if test="${chartr.CHARTR_CODE == '2'}">
                 							<a href="#none" onclick="wc300_popup();"><span class="ico_w"></span></a>
                 						</c:if>
                 						<c:if test="${chartr.CHARTR_CODE == '3'}">
                 							<a href="#none" onclick="atc_popup();"><span class="ico_a"></span></a>
                 						</c:if>
                 						<c:if test="${chartr.CHARTR_CODE == '4'}">
                 							<span class="ico_c"></span>
                 						</c:if>
                 						<c:if test="${chartr.CHARTR_CODE == '5'}">
                 							<span class="ico_d"></span>
                 						</c:if>
                 						</c:forEach>
                 					</div>
                 					</td>
                					<td class="job3">
                					<a href="#">			
                						<c:if test="${fn:substring(data.WANTED_AUTH_NO, 0, 1) != 'K'}">			<!-- 워크넷 자체 데이터가 아니라면 상세정보가 없으므로 링크 -->
                                       		<c:choose>
						                	<c:when test="${fn:trim(data.WANTED_AUTH_NO) == ''}">   			<!-- 워크넷 자체 데이터가 아니라도 직접 입력했다면 팝업 -->
						                		<a href="#none" onclick="fn_empmn_info('${data.EMPMN_MANAGE_NO }')">${data.empmnSj }</a>
						                	</c:when>
						                	<c:otherwise>          												<!-- 워크넷 자체 데이터가 아니라면 상세정보가 없으므로 링크 -->
						                		<a href="#none" onclick="fn_move_weburl('${data.ECNY_APPLY__WEB_ADRES }')">${data.empmnSj }</a>
						                	</c:otherwise>
						                	</c:choose>
                                       	</c:if>
                                       	<c:if test="${fn:substring(data.WANTED_AUTH_NO, 0, 1) == 'K'}">
                                       		<a href="#none" onclick="fn_empmn_info('${data.EMPMN_MANAGE_NO }')">${data.empmnSj }</a>
                                       	</c:if>
                                    </a>            		
                                    <c:choose>
                                 		<c:when test="${fn:substring(data.WANTED_AUTH_NO, 0, 1) == 'K'}">
	                                 		${data.jssfc } |  
	                                 		<c:forEach items="${data.iem25 }" var="iem25" varStatus="status"> <c:if test="${not status.first }">,</c:if>
		                                 		<c:choose>
		                                 		<c:when test="${iem25.IEM_VALUE != 'WKN' }">${iem25.CODE_NM }<c:if test="${iem25.CODE_NM == '' }">${data.CAREER_DETAIL_RQISIT2}</c:if></c:when>
							                	<c:otherwise>${iem25.ATRB3}</c:otherwise>
							                	</c:choose>
						                	</c:forEach> | 
						                	<c:forEach items="${data.iem27 }" var="iem27" varStatus="status"><c:if test="${not status.first }">,</c:if>
							                	<c:choose>
							                	<c:when test="${iem27.IEM_VALUE != 'WKN' }">${iem27.CODE_NM }</c:when>
							                	<c:otherwise>${iem27.ATRB3}</c:otherwise>
							                	</c:choose> 
						                	</c:forEach>
                                       	</c:when>
                                       	<c:otherwise>
	                                 		${data.jssfc } |  
	                                 		${data.CAREER_DETAIL_RQISIT2} | 
						                	${data.CAREER_DETAIL_RQISIT3}
					                	</c:otherwise>
					                </c:choose>
					                	</td>
                					<td>${data.rcritEndDe}</td>
              					</tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <!-- 리스트// -->
                    <div class="btn_page_last">
						<a class="btn_page_admin" href="#" id="btn_filter_insert"><span>채용공고 필터 저장</span></a>
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