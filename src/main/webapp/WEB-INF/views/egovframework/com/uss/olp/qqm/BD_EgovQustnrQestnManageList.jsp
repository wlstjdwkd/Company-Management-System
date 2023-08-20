<%--
  Class Name : EgovQustnrQestnManageList.jsp
  Description : 설문문항 목록 페이지
  Modification Information

      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2008.03.09    장동한          최초 생성

    author   : 공통서비스 개발팀 장동한
    since    : 2009.03.19

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
<title>설문문항관리</title>
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
function fn_egov_regist_QustnrQestnManage(){
	var form = document.dataForm;

	form.action = "<c:url value='${svcUrl}' />";
	form.cmd.value = "";
	form.df_curr_page.value = 1;
	form.df_method_nm.value="insertEgovQustnrQestnManage";
	form.submit();
}

/* ********************************************************
 * 상세회면 처리 함수
 ******************************************************** */
function fn_egov_detail_QustnrQestnManage(qestnrQesitmId){
	var form = document.dataForm;
	
	form.action = "<c:url value='${svcUrl}' />";
	form.qestnrQesitmId.value = qestnrQesitmId;
	form.df_method_nm.value="EgovQustnrQestnManageDetail";
	form.submit();
}

/* ********************************************************
 * 설문항목 팝업
 ******************************************************** */
function fn_egov_detail_QustnrItemManage(qestnrQesitmId){
    $.colorbox({
        title : "설문항목",
        href : "/PGSO0040.do?qestnrQesitmId="+qestnrQesitmId+"&searchMode=Y",
        width : "1024",
        height : "500",
        overlayClose : false,
        escKey : false,
        iframe : true
    });
}

/*
* 검색단어 입력 후 엔터 시 자동 submit
*/
function press(event) {
	if (event.keyCode == 13) {
		event.preventDefault();
		fn_egov_search_QustnrQestnManage();
	}
}

/* ********************************************************
 * 검색 함수
 ******************************************************** */
function fn_egov_search_QustnrQestnManage(){
	var form = document.dataForm;
	
	if (form.searchKeyword.value != "" && form.searchCondition.value == "") {
		jsMsgBox(null, 'error', Message.template.required('검색구분'));
		return;
	}
	
	form.action = "<c:url value='${svcUrl}' />";
	form.df_curr_page.value = 1;
	form.df_method_nm.value="";
	form.submit();

}
</script>
</head>
<body>
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">설문문항관리</h2>
                <!-- 타이틀 영역 //-->
                <form name="dataForm" id="dataForm" action="<c:url value='${svcUrl }'/>" method="post">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />
				
				<c:if test="${qustnrQestnManageVO.searchMode == 'Y'}">
				<input type="hidden" name="qestnrTmplatId" id="qestnrTmplatId" value="${qustnrQestnManageVO.qestnrTmplatId }">
				<input type="hidden" name="qestnrId" id="qestnrId" value="${qustnrQestnManageVO.qestnrId }">
				<input type="hidden" name="searchMode" id="searchMode" value="Y">
				</c:if>
				
				<input type="hidden" name="qestnrQesitmId" id="qestnrQesitmId" value="">
				<input type="hidden" name="cmd" id="cmd" value="">

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
								<select name="searchCondition" style="width:150px;" title="검색조건선택">
									<option value=''>선택하세요</option>
									<option value='QUSTNR_SJ' <c:if test="${param.searchCondition == 'QUSTNR_SJ'}">selected</c:if>>설문제목</option>
									<option value='QESTN_CN' <c:if test="${param.searchCondition == 'QESTN_CN'}">selected</c:if>>문항내용</option>
									<option value='REGISTER' <c:if test="${param.searchCondition == 'REGISTER'}">selected</c:if>>등록자</option>
								</select>
                            	<input name="searchKeyword" type="text" style="width:300px;" value="${param.searchKeyword}" maxlength="35" title="검색어 입력" 
                            		placeholder="검색어를 입력하세요." onkeypress="press(event);">
                                <p class="btn_src_zone"><a href="#none" class="btn_search" onclick="fn_egov_search_QustnrQestnManage();">검색</a></p></td>
                        </tr>
                    </table>
                </div>
                <div class="block">
                    <ul>
                        <li class="d1">항목 ‘보기’ 클릭하시면 해당 문항의 선택항목 확인은 물론 등록 및 수정관리하실 수 있습니다.</li>
                    </ul>
                </div>
                <div class="block2">
                	<ap:pagerParam />	
                    <!--// 리스트 -->
                    <div class="list_zone">
                        <table cellspacing="0" border="0" summary="설문문항 리스트">
                            <caption>
                            설문문항 리스트
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
                                    <th scope="col">순번</th>
                                    <th scope="col">문항내용</th>
                                    <th scope="col">유형</th>
                                    <th scope="col">항목</th>
                                    <th scope="col">등록자</th>
                                    <th scope="col">등록일</th>
                                </tr>
                            </thead>
                            <tbody>
							<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
							<c:if test="${fn:length(resultList) == 0}">
								<tr>
									<td colspan="8">
										<c:if test="${param.searchKeyword == null or param.searchKeyword == '' }"><spring:message code="info.nodata.msg" /></c:if>
										<c:if test="${param.searchKeyword != null and param.searchKeyword != '' }"><spring:message code="info.noresult.msg" /></c:if>
									</td>
								</tr>
							</c:if>
							<%-- 데이터를 화면에 출력해준다 --%>
							<c:forEach items="${resultList}" var="resultInfo" varStatus="status">
                                <tr>
                                    <td>${pager.indexNo-status.index}</td>
                                    <td class="tal"><c:out value="${resultInfo.qustnrSj }" /></td>
                                    <td>${resultInfo.qestnSn }</td>
									<td class="tal"><a href="#none" onclick="fn_egov_detail_QustnrQestnManage('${resultInfo.qestnrQesitmId}');">
											<c:out value="${resultInfo.qestnCn}"/></a></td>
                                    <td>
									    <c:if test="${resultInfo.qestnTyCode == '1'}">객관식</c:if>
									    <c:if test="${resultInfo.qestnTyCode == '2'}">주관식</c:if>
                                    </td>
                                    <td>
                                    	<div class="btn_inner">
                                    	<c:if test="${resultInfo.qestnTyCode == '1'}">
                                    		<a href="#none" class="btn_in_gray" onclick="fn_egov_detail_QustnrItemManage('${resultInfo.qestnrQesitmId}');"><span>보기</span></a>
                                    	</c:if>
                                    	</div>
                                    </td>
                                    <td>${resultInfo.registerNm}</td>
                                    <td>${fn:substring(resultInfo.rgsde, 0, 10)}</td>
                                </tr>
							</c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <!-- 리스트// -->
                    <div class="btn_page_last"><a class="btn_page_admin" href="#none" onclick="fn_egov_regist_QustnrQestnManage();"><span>등록</span></a></div>
					<ap:pager pager="${pager}" />
                </div>
            </form>
            </div>
            <!--content//-->
        </div>
    </div>

</body>
</html>
