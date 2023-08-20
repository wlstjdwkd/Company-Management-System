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
/*
* 검색단어 입력 후 엔터 시 자동 submit
*/
function press(event) {
	if (event.keyCode == 13) {
		event.preventDefault();
		fn_egov_search_QustnrManage();
	}
}

function fn_egov_search_QustnrManage(){
	var form = document.dataForm;
	
	if (form.searchKeyword.value != "" && form.searchCondition.value == "") {
		jsMsgBox(null, 'error', Message.template.required('검색구분'));
		return;
	}
	
	form.action = "<c:url value='${svcUrl}' />";
	form.df_curr_page.value = 1;
	form.df_method_nm.value="EgovQustnrManageListPopup";
	form.submit();
}

/* ********************************************************
 * 선택 처리 함수
 ******************************************************** */
function fn_egov_open_QustnrManage(qestnrId, qestnrTmplatId, cnt){

	parent.document.getElementById("qestnrId").value = qestnrId;
	parent.document.getElementById("qestnrTmplatId").value = qestnrTmplatId;
	parent.document.getElementById("qestnrCn").value = document.getElementById("iptText_"+ cnt).value;

	parent.$(".popQustnrId").colorbox.close();
}
</script>
</head>
<body>
<div id="self_dgs">
	<div class="pop_q_con">
				<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />

				<input type="hidden" name="qestnrId" value="" />
				
				<!-- LNB 출력 방지 -->
				<input type="hidden" id="no_lnb" value="true" />
				
				<!--// 조회 조건 -->
				<div class="search_top">
					<table cellpadding="0" cellspacing="0" class="table_search" summary="검색" >
						<caption>검색</caption>
						<colgroup>
							<col width="100%" />
						</colgroup>
						<tr>
							<td class="only">
								<select name="searchCondition" title="검색조건선택" style="width: 150px">
									<option value="">선택하세요</option>
									<option value='QUSTNR_SJ' <c:if test="${searchCondition == 'QUSTNR_SJ'}">selected</c:if>>설문제목</option>
									<option value='REGISTER' <c:if test="${searchCondition == 'REGISTER'}">selected</c:if>>등록자</option>
								</select> 
								<input type="text" name="searchKeyword" title="검색어 입력" style="width: 290px;" placeholder="검색어를 입력하세요."
										value='<c:out value="${searchKeyword}"/>' maxlength="35" onkeypress="press(event);" />
								<p class="btn_src_zone">
									<a href="#none" class="btn_search" onclick="fn_egov_search_QustnrManage();">검색</a>
								</p>
							</td>
						</tr>
					</table>
				</div>
                <div class="block">
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
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">번호</th>
                                    <th scope="col">설문제목</th>
                                    <th scope="col">설문기간</th>
                                    <th scope="col">등록자</th>
                                    <th scope="col">등록일</th>
                                    <th scope="col">선택</th>
                                </tr>
                            </thead>
                            <tbody>
							<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
							<c:if test="${fn:length(resultList) == 0}">
								<tr>
									<td colspan="6">
										<c:if test="${param.searchKeyword == null or param.searchKeyword == '' }"><spring:message code="info.nodata.msg" /></c:if>
										<c:if test="${param.searchKeyword != null and param.searchKeyword != '' }"><spring:message code="info.noresult.msg" /></c:if>
									</td>
								</tr>
							</c:if>
							<%-- 데이터를 화면에 출력해준다 --%>
							<c:forEach items="${resultList}" var="resultInfo" varStatus="status">
                                <tr>
                                    <td>${pager.indexNo - (status.index)}</td>
                                    <td class="tal"><c:out value="${resultInfo.qestnrSj}"/></td>
                                    <td>${resultInfo.qestnrBeginDe}~${resultInfo.qestnrEndDe}</td>
                                    <td>${resultInfo.registerNm}</td>
                                    <td>${fn:substring(resultInfo.rgsde, 0, 10)}</td>
                                    <td><div class="btn_inner">
                                    	<a href="#none" class="btn_in_gray" onclick="fn_egov_open_QustnrManage('${resultInfo.qestnrId}', '${resultInfo.qestnrTmplatId}', '${status.count}');"><span>선택</span></a>
                                    	</div>
                                    	<input name="iptText_${status.count}" id="iptText_${status.count}" type="hidden" value="${resultInfo.qestnrSj}">
                                    </td>
                                </tr>
							</c:forEach>
							</tbody>
						</table>
                    </div>
                    <!-- 리스트// -->
                    <div class="mgt10"></div>
					<ap:pager pager="${pager}" />
                </div>
                </form>
            </div>
</div>
</body>
</html>
