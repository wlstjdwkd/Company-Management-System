<%--
  Class Name : EgovQustnrManageList.jsp
  Description : 설문관리 목록 페이지
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
<title>설문정보관리</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,colorboxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javascript">
<c:if test="${resultMsg != null}">
	$(function(){
		jsMsgBox(null, "info", "${resultMsg}");
	});
</c:if>

function fn_egov_regist_QustnrManage(){
	var form = document.dataForm;

	form.action = "<c:url value='${svcUrl}' />";
	form.df_curr_page.value = 1;
	form.df_method_nm.value="insertEgovQustnrManage";
	form.submit();
}

/* ********************************************************
 * 상세회면 처리 함수
 ******************************************************** */
function fn_egov_detail_QustnrManage(qestnrId){
	var form = document.dataForm;

	form.qestnrId.value = qestnrId;
	form.action = "<c:url value='${svcUrl}' />";
	form.df_method_nm.value="EgovQustnrManageDetail";
	form.submit();
}

/*
* 검색단어 입력 후 엔터 시 자동 submit
*/
function press(event) {
	if (event.keyCode == 13) {
		event.preventDefault();
		fn_egov_search_QustnrManage();
	}
}

/* ********************************************************
 * 검색 함수
 ******************************************************** */
function fn_egov_search_QustnrManage(){
	var form = document.dataForm;
	
	if (form.searchKeyword.value != "" && form.searchCondition.value == "") {
		jsMsgBox(form.searchCondition, 'error', Message.template.required('검색구분'));
		return false;
	}

	form.action = "<c:url value='${svcUrl}' />";
	form.df_curr_page.value = 1;
	form.df_method_nm.value="";
	form.submit();

}

/* ********************************************************
 * 설문문항 보기
 ******************************************************** */
function fn_egov_list_QustnrManag(qestnrId, qestnrTmplatId) {
	var form = document.dataForm;

	form.qestnrId.value = qestnrId;
	form.qestnrTmplatId.value = qestnrTmplatId;
	form.searchMode.value = 'Y';
	form.df_method_nm.value = "";

	form.action = "<c:url value='/PGSO0030.do' />";
	form.submit();
}

/* ********************************************************
 * 통계
 ******************************************************** */
function fn_egov_statistics_QustnrManag(qestnrId, qestnrTmplatId){
    $.colorbox({
        title : "설문통계",
        href : "/PGSO0050.do?df_method_nm=EgovQustnrRespondInfoManageStatistics&popupAt=Y&qestnrId="
        		+qestnrId+"&qestnrTmplatId="+qestnrTmplatId,
        width : "1024",
        height : "700",
        overlayClose : false,
        escKey : false,
        iframe : true
    });
}

/* ********************************************************
 * 엑셀
 ******************************************************** */
 function fn_egov_excel_QustnrManag(qestnrId, qestnrTmplatId){
	 jsFiledownload("/PGSO0020.do","df_method_nm=excelResponseData&qestnrId="+qestnrId+"&qestnrTmplatId="+qestnrTmplatId);
}

 /* ********************************************************
  * 메일발송
  ******************************************************** */
 function fn_egov_email_QustnrManag(qestnrId, qestnrTmplatId){
     $.colorbox({
         title : "메일발송설정",
         href : "/PGSO0020.do?df_method_nm=qustnrTrgterEmailListPopup&qestnrId="+qestnrId+"&qestnrTmplatId="+qestnrTmplatId,
         width : "1024",
         height : "700",
         overlayClose : false,
         escKey : false,
         iframe : true
     });
 }
</script>
</head>
<body>
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">설문정보관리</h2>
                <!-- 타이틀 영역 //-->
                <form name="dataForm" id="dataForm" action="<c:url value='${svcUrl }'/>" method="post">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />
				
				<input name="qestnrId" id="qestnrId" type="hidden" value="" />
				<input name="qestnrTmplatId" id="qestnrTmplatId" type="hidden" value="" />
				<input name="searchMode" id="searchMode" type="hidden" value="" />
				
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
								<select name="searchCondition" class="select" style="width:150px" title="검색조건선택">
									<option value=''>선택하세요</option>
									<option value='QUSTNR_SJ' <c:if test="${searchCondition == 'QUSTNR_SJ'}">selected</c:if>>설문제목</option>
									<option value='REGISTER' <c:if test="${searchCondition == 'REGISTER'}">selected</c:if>>등록자</option>
								</select>
								<input name="searchKeyword" type="text"style="width:300px;" value="${searchKeyword}" title="검색어 입력"
											placeholder="검색어를 입력하세요." maxlength="35" onkeypress="press(event);">
                                <p class="btn_src_zone"><a href="#none" class="btn_search" onclick="fn_egov_search_QustnrManage();">검색</a></p></td>
                        </tr>
                    </table>
                </div>
                <div class="block">
                    <ul>
                        <li class="d1">설문문항 ‘보기’ 클릭하시면 해당 설문의 문항 확인 및 등록, 수정관리하실 수 있습니다. </li>
                        <li class="d1">메일의 ‘설정＇을 클릭하시면 설문조사 대상 설정 및 메일을 발송하실 수 있습니다.</li>
                        <li class="d1">설문보기의 ‘보기＇를 클릭하시면, 해당 설문의 문항, 항목을 미리보실 수 있으며, 설문이 진행된 경우 객관식 문항의 통계도 확인하실 수 있습니다.</li>
                    </ul>
                </div>
                <div class="block2">
                	<ap:pagerParam />	
                    <!--// 리스트 -->
                    <div class="list_zone">
                        <table cellspacing="0" border="0" summary="설문제목, 설문기간, 문항, 통계, 엑셀, 등록자, 등록일, 메일 리스트">
                            <caption>
                            설문정보리스트
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
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">번호</th>
                                    <th scope="col">설문제목</th>
                                    <th scope="col">설문기간</th>
                                    <%-- 설문응답자 정보 출력안함 --%>
                                    <th scope="col">문항</th>
                                    <%-- 설문조사 출력안함 --%>
                                    <th scope="col">통계</th>
                                    <th scope="col">엑셀</th><%-- 추가항목 --%>
                                    <th scope="col">등록자</th>
                                    <th scope="col">등록일</th>
                                    <th scope="col">메일</th><%-- 추가항목 --%>
                                </tr>
                            </thead>
                            <tbody>
							<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
							<c:if test="${fn:length(resultList) == 0}">
								<tr>
									<td colspan="9">
										<c:if test="${param.searchKeyword == null or param.searchKeyword == '' }"><spring:message code="info.nodata.msg" /></c:if>
										<c:if test="${param.searchKeyword != null and param.searchKeyword != '' }"><spring:message code="info.noresult.msg" /></c:if>
									</td>
								</tr>
							</c:if>
							<%-- 데이터를 화면에 출력해준다 --%>				
							<c:forEach items="${resultList}" var="resultInfo" varStatus="status">
                                <tr>
                                    <td>${pager.indexNo-status.index}</td>
                                    <td class="tal"><a href="#none" onclick="fn_egov_detail_QustnrManage('${resultInfo.qestnrId}');">
											<c:out value="${resultInfo.qestnrSj}"/></a></td>
                                    <td>${resultInfo.qestnrBeginDe}~${resultInfo.qestnrEndDe}</td>
                                    <td><div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="fn_egov_list_QustnrManag('${resultInfo.qestnrId}','${resultInfo.qestnrTmplatId}');"><span>보기</span></a></div></td>
                                    <td><div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="fn_egov_statistics_QustnrManag('${resultInfo.qestnrId}','${resultInfo.qestnrTmplatId}');"><span>보기</span></a></div></td>
                                    <td><div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="fn_egov_excel_QustnrManag('${resultInfo.qestnrId}','${resultInfo.qestnrTmplatId}');"><span>다운</span></a></div></td>
                                    <td>${resultInfo.registerNm}</td>
                                    <td>${fn:substring(resultInfo.rgsde, 0, 10)}</td>
                                    <td><div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="fn_egov_email_QustnrManag('${resultInfo.qestnrId}','${resultInfo.qestnrTmplatId}');"><span>설정</span></a></div></td>
                                </tr>
							</c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <!-- 리스트// -->
                    <div class="btn_page_last"><a class="btn_page_admin" href="#none" onclick="fn_egov_regist_QustnrManage();"><span>등록</span></a></div>
			        <ap:pager pager="${pager}" />
                </div>
                </form>
            </div>
            <!--content//-->
        </div>
    </div>
</div>
</body>
</html>
