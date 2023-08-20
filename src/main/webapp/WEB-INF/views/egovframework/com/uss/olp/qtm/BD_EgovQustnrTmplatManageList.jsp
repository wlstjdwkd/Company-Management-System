<%--
  Class Name : EgovQustnrTmplatManageList.jsp
  Description : 설문템플릿 목록 페이지
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
<title>설문템플릿관리</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,colorboxAdmin" />
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
function fn_egov_regist_QustnrTmplatManage(){
	var form = document.dataForm;

	form.df_curr_page.value = 1;
	form.df_method_nm.value = "EgovQustnrTmplatManageRegist";
	form.submit();
}

/* ********************************************************
 * 상세회면 처리 함수
 ******************************************************** */
function fn_egov_detail_QustnrTmplatManage(qestnrTmplatId){
	var form = document.dataForm;

	form.qestnrTmplatId.value = qestnrTmplatId;
	form.df_method_nm.value = "EgovQustnrTmplatManageDetail";
	form.submit();
}

/*
* 검색단어 입력 후 엔터 시 자동 submit
*/
function press(event) {
	if (event.keyCode == 13) {
		event.preventDefault();
		fn_egov_search_QustnrTmplatManage();
	}
}
/* ********************************************************
 * 검색 함수
 ******************************************************** */
function fn_egov_search_QustnrTmplatManage(){
	var form = document.dataForm;

	if (form.searchKeyword.value != "" && form.searchCondition.value == "") {
		jsMsgBox(null, 'error', Message.template.required('검색구분'));
		return;
	}
	
	form.df_curr_page.value = 1;
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
                <h2 class="menu_title">설문템플릿관리</h2>
                <!-- 타이틀 영역 //-->
                <form name="dataForm" id="dataForm" action="<c:url value='${svcUrl }'/>" method="post">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />
				
				<input name="qestnrTmplatId" type="hidden" value="">
                
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
								<select name="searchCondition" class="select" style="width:150px;" title="검색조건선택">
									<option value=''>선택하세요</option>
									<option value='QUSTNR_TMPLAT_TY' <c:if test="${searchCondition == 'QUSTNR_TMPLAT_TY'}">selected</c:if>>템플릿명</option>
									<option value='QUSTNR_TMPLAT_DC' <c:if test="${searchCondition == 'QUSTNR_TMPLAT_DC'}">selected</c:if>>템플릿설명</option>
								</select>                            
                            	<input name="searchKeyword" type="text" style="width:300px;" value="${searchKeyword}" maxlength="35" title="검색어 입력" placeholder="검색어를 입력하세요." onkeypress="press(event);">
                                <p class="btn_src_zone"><a href="#none" class="btn_search" onclick="fn_egov_search_QustnrTmplatManage();">검색</a></p></td>
                        </tr>
                    </table>
                </div>
                <div class="block">
                	<ap:pagerParam />	
                    <!--// 리스트 -->
                    <div class="list_zone">
                        <table cellspacing="0" border="0" summary="템플릿 목록">
                            <caption>
                            템플릿 목록
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
                                    <th scope="col">템플릿명</th>
                                    <th scope="col">템플릿설명</th>
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
                                    <td>${pager.indexNo-status.index}</td>
                                    <td class="tal"><a href="#none" onclick="fn_egov_detail_QustnrTmplatManage('${resultInfo.qestnrTmplatId}');">
											<c:out value="${resultInfo.qestnrTmplatTy}"/></a></td>
									<td class="tal"><c:out value="${resultInfo.qestnrTmplatCn}" /></td>
                                    <td>${resultInfo.registerNm}</td>
                                    <td>${fn:substring(resultInfo.rgsde, 0, 10)}</td>
                                </tr>
							</c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <!-- 리스트// -->
                    <div class="btn_page_last"><a class="btn_page_admin" href="#none" onclick="fn_egov_regist_QustnrTmplatManage();"><span>등록</span></a></div>
					<ap:pager pager="${pager}" />
                </div>
            </div>
            <!--content//-->
        </div>
    </div>
</div>
</body>
</html>
