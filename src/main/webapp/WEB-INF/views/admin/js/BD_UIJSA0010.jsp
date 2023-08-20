<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>통계생성관리</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,blockUI" />
<ap:jsTag type="tech" items="acm,msg,util,etc" />

<script type="text/javascript">
	// 검색
	function fn_search() {
		if ($("#ad_searchYear option:selected").val() == "") {
			jsMsgBox($("#ad_searchYear"), "error", Message.template.required("생성년도"));
			return;
		}
		
		$("#df_method_nm").val("");
		$("#dataForm").submit();
	}

	// 통계처리
	function fn_callFunc(gubun, code) {
		
		$("#ad_gubun").val(gubun);
		$("#ad_code").val(code);
		$("#df_method_nm").val("processStaticsSp");
		$.blockUI();
		$("#dataForm").submit();
	}
	
	// 전체 통계처리
	function fn_callFuncAll(gubun) {

		$("#ad_gubun").val(gubun);
		$("#df_method_nm").val("processAllStaticsSp");
		$.blockUI();
		$("#dataForm").submit();
	}
</script>

</head>
<body>
    <div id="wrap">
        <div class="wrap_inn">
    		<!--//content-->
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">통계생성관리</h2>
                <!-- 타이틀 영역 //-->
                
                <form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}'/>" method="post">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />
				
				<input type="hidden" id="ad_stdyy" name="ad_stdyy" value="${stdyy }" />
				<input type="hidden" id="ad_code" name="ad_code" value="" />
				<input type="hidden" id="ad_gubun" name="ad_gubun" value="" />
				
                <div class="search_top">
                    <table cellpadding="0" cellspacing="0" class="table_search" summary="조회 조건">
                        <caption>
                        조회 조건
                        </caption>
                        <colgroup>
                        <col width="15%" />
                        <col width="*" />
                        <col width="15%" />
                        <col width="*" />
                        <col width="15%" />
                        <col width="*" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">생성년도</th>
                                <td colspan="5">
                                    <select name="ad_searchYear" id="ad_searchYear" title="생성년도" id="ad_create_year" style="width:80px">
                                    	<option value=""> --선택-- </option>
                                    	<c:set var="now" value="<%=new java.util.Date()%>" />
                                    	<fmt:formatDate var="thisYear" pattern="yyyy" value="${now }" /><fmt:formatDate pattern="yyyy" value="${now }" />
										<c:forEach var="i" begin="2002" end="${thisYear }" varStatus="sts">
											<c:set var="outYear" value="${thisYear-sts.count+1}" />
											<option value="${outYear }"<c:if test="${param.ad_searchYear eq outYear }"> selected</c:if>>${outYear }</option>
										</c:forEach>
                                    </select> 년
                                    <p class="btn_src_zone"><a href="#none" class="btn_search" onclick="fn_search();">조회</a></p>
                                </td>
                            </tr>
                            <tr>
                              <th scope="row">자료기준년도</th>
                              <td>${jdgmntManage.stdyy } <c:if test="${not empty jdgmntManage.stdyy and jdgmntManage.stdyy ne '-' }">년</c:if></td>
                              <th scope="row">시스템판정일자</th>
                              <td>${jdgmntManage.systemJdgmntDe } </td>
                              <th scope="row">확정판정일자</th>
                              <td>${jdgmntManage.dcsnJdgmntDe }</td>
                          </tr>
                        </tbody>
                    </table>
                </div>
                </form>
                
                <div class="block">
                    <!--// 리스트 -->
                    <div class="list_zone">
                        <table cellspacing="0" border="0" summary="통계생성관리목록" class="list">
                           <caption>
                            리스트
                            </caption>
                            <colgroup>
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="150px" />
                            <col width="150px" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">자료기준년도</th>
                                    <th scope="col">생성일</th>
                                    <th scope="col">통계명</th>
                                    <th scope="col">상태</th>
                                    <th colspan="2" scope="col">실행</th>
                                </tr>
                            </thead>
                            <tbody>
							<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
							<c:if test="${fn:length(statsOpertList) == 0}">
								<tr>
									<td colspan="6"><spring:message code="info.nodata.msg" /></td>
								</tr>
							</c:if>
							<%-- 데이터를 화면에 출력해준다 --%>				
                            <c:forEach items="${statsOpertList}" var="statsOpert" varStatus="status">
                                <tr>
                                    <td>${statsOpert.stdyy }</td>
                                    <td class="tac"><p>${statsOpert.creatDe }</p></td>
                                    <td class="tar"><c:out value="${statsOpert.codeNm }" /></td>
                                    <td>${statsOpert.sttusNm }</td>
                                    <td>
                                        <ul class="im1">
                                        <c:if test="${empty statsOpert.sttus}">
                                            <li style="margin-right:80px">
                                                <div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="fn_callFunc('1', '${statsOpert.code }');"><span style="width:36px">생성</span></a></div>
                                            </li>
                                        </c:if>
                                        <c:if test="${not empty statsOpert.sttus}">
                                            <li>
                                                <div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="fn_callFunc('1', '${statsOpert.code }');"><span>재작업</span></a></div>
                                            </li>
                                            <c:if test="${statsOpert.sttus eq 'S' }">
                                            <li>
                                                <div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="fn_callFunc('2', '${statsOpert.code }');"><span>삭제</span></a></div>
                                            </li>
                                            </c:if>
                                        </c:if>
                                        </ul>
                                    </td>
                                    <c:if test="${status.index == 0 }">
                                    <td rowspan="${fn:length(statsOpertList) }">
                                    	<div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="fn_callFuncAll(1);"><span style="width:90px">일괄생성/재작업</span></a></div>
                                        <br />
                                        <c:if test="${statsOpert.sttus eq 'S' }">
                                        <div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="fn_callFuncAll(2);"><span style="width:90px">일괄삭제</span></a></div>
                                        </c:if>
                                    </td>
                                    </c:if>
                                </tr>
							</c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <!-- 리스트// -->
                </div>
                <!--리스트영역 //-->
            </div>
        </div>
        <!--content//-->
    </div>
	<div style="display:none">
		<div class="loading" id="loading">
			<div class="inner">
				<div class="box">
			    	<p >통계생성을 처리하고 있습니다. 잠시만 기다려주세요.<br />
						시스템 상태에 따라 최대 10분 정도 소요될 수 있습니다.</p>
					<span><img src="/images/etc/loading_bar.gif" width="323" height="39" alt="loading" /></span>
				</div>
			</div>
		</div>
	</div>
</body>
</html>