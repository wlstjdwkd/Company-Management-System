<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>판정기준관리</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javascript">
<c:if test="${resultMsg != null}">
	$(function(){
		jsMsgBox(null, "info", "${resultMsg}");
	});
</c:if>

	/*
	 * 규모기준변경 화면
	 */
	function fnScaleStdrForm(sn, idx) {
		if (sn == null || sn == "") {
			$("#ad_ac_type").val("insert");
			$("#ad_stdr_sn").val("");
		} else if (idx == 0) {
			$("#ad_ac_type").val("update");
			$("#ad_stdr_sn").val(sn);
		} else {
			$("#ad_ac_type").val("view");
			$("#ad_stdr_sn").val(sn);
		}
		
		$("#df_method_nm").val("formScaleStdr");
		$("#dataForm").submit();
	}
	
	/*
	 * 상한기준변경 화면
	 */
	function fnUplmtStdrForm(sn, idx) {
		if (sn == null || sn == "") {
			$("#ad_ac_type").val("insert");
			$("#ad_stdr_sn").val("");
		} else if (idx == 0) {
			$("#ad_ac_type").val("update");
			$("#ad_stdr_sn").val(sn);
		} else {
			$("#ad_ac_type").val("view");
			$("#ad_stdr_sn").val(sn);
		}
		
		$("#df_method_nm").val("formUplmtStdr");
		$("#dataForm").submit();
	}
	
	/*
	 * 독립성기준변경 화면
	 */
	function fnIndpnStdrForm(sn, idx) {
		if (sn == null || sn == "") {
			$("#ad_ac_type").val("insert");
			$("#ad_stdr_sn").val("");
		} else if (idx == 0) {
			$("#ad_ac_type").val("update");
			$("#ad_stdr_sn").val(sn);
		} else {
			$("#ad_ac_type").val("view");
			$("#ad_stdr_sn").val(sn);
		}
		
		$("#df_method_nm").val("formIndpnStdr");
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
                <h2 class="menu_title_line">판정기준관리</h2>
                <!-- 타이틀 영역 //-->
                
                <form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}'/>" method="post">
					<ap:include page="param/defaultParam.jsp" />
					<ap:include page="param/dispParam.jsp" />

					<input type="hidden" name="ad_ac_type" id="ad_ac_type" value="" />
					<input type="hidden" name="ad_stdr_sn" id="ad_stdr_sn" value="" />
                </form>
                
                <div class="block2">
                    <h3>규모기준
                        <div class="btn_pag fr"><a class="btn_page_admin" href="#none" onclick="fnScaleStdrForm();"><span>규모기준변경</span></a> </div>
                    </h3>
                    <!--// 리스트 -->
                    <div class="list_zone">
                        <table cellspacing="0" border="0" summary="규모기준목록" class="list">
                            <caption>
                            리스트
                            </caption>
                            <colgroup>
                            <col width="80px" />
                            <col width="150px" />
                            <col width="150px" />
                            <col width="*" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">기준순번</th>
                                    <th scope="col">적용시작일</th>
                                    <th scope="col">적용만료일</th>
                                    <th scope="col">설명</th>
                                </tr>
                            </thead>
                            <tbody>
							<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
							<c:if test="${fn:length(scaleList) == 0}">
								<tr>
									<td colspan="4"><spring:message code="info.nodata.msg" /></td>
								</tr>
							</c:if>
							<%-- 데이터를 화면에 출력해준다 --%>				
                            <c:forEach items="${scaleList}" var="info" varStatus="status">
                                <tr>
                                    <td>${fn:length(scaleList) - status.index }</td>
                                    <td class="tac"><a href="#none" onclick="fnScaleStdrForm('${info.stdrSn}', '${status.index }');">${info.applcBeginDe }</a></td>
                                    <td><a href="#none" onclick="fnScaleStdrForm('${info.stdrSn}', '${status.index }');">${info.applcEndDe }</a></td>
                                    <td class="tal">${info.dc }</td>
                                </tr>
							</c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <!-- 리스트// -->
                </div>
                <!--리스트영역 //-->
                <div class="block2">
                    <h3>상한기준
                        <div class="btn_pag fr"><a class="btn_page_admin" href="#none" onclick="fnUplmtStdrForm();"><span>상한기준변경</span></a> </div>
                    </h3>
                    <!--// 리스트 -->
                    <div class="list_zone">
                        <table cellspacing="0" border="0" summary="상한기준목록" class="list">
                            <caption>
                            리스트
                            </caption>
                            <colgroup>
                            <col width="80px" />
                            <col width="150px" />
                            <col width="150px" />
                            <col width="*" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">기준순번</th>
                                    <th scope="col">적용시작일</th>
                                    <th scope="col">적용만료일</th>
                                    <th scope="col">설명</th>
                                </tr>
                            </thead>
                            <tbody>
							<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
							<c:if test="${fn:length(scaleList) == 0}">
								<tr>
									<td colspan="4"><spring:message code="info.nodata.msg" /></td>
								</tr>
							</c:if>
							<%-- 데이터를 화면에 출력해준다 --%>				
                            <c:forEach items="${uplmtList}" var="info" varStatus="status">
                                <tr>
                                    <td>${fn:length(uplmtList) - status.index }</td>
                                    <td class="tac"><a href="#none" onclick="fnUplmtStdrForm('${info.stdrSn}', '${status.index }');">${info.applcBeginDe }</a></td>
                                    <td><a href="#none" onclick="fnUplmtStdrForm('${info.stdrSn}', '${status.index }');">${info.applcEndDe }</a></td>
                                    <td class="tal">${info.dc }</td>
                                </tr>
							</c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <!-- 리스트// -->
                </div>
                <!--리스트영역 //-->
                <div class="block2">
                    <h3>독립성기준
                        <div class="btn_pag fr"><a class="btn_page_admin" href="#none" onclick="fnIndpnStdrForm();"><span>독립성기준변경</span></a> </div>
                    </h3>
                    <!--// 리스트 -->
                    <div class="list_zone">
                        <table cellspacing="0" border="0" summary="독립성기준목록" class="list">
                            <caption>
                            리스트
                            </caption>
                            <colgroup>
                            <col width="80px" />
                            <col width="150px" />
                            <col width="150px" />
                            <col width="*" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">기준순번</th>
                                    <th scope="col">적용시작일</th>
                                    <th scope="col">적용만료일</th>
                                    <th scope="col">설명</th>
                                </tr>
                            </thead>
                            <tbody>
 							<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
							<c:if test="${fn:length(scaleList) == 0}">
								<tr>
									<td colspan="4"><spring:message code="info.nodata.msg" /></td>
								</tr>
							</c:if>
							<%-- 데이터를 화면에 출력해준다 --%>				
                            <c:forEach items="${indpntList}" var="info" varStatus="status">
                                <tr>
                                    <td>${fn:length(indpntList) - status.index }</td>
                                    <td class="tac"><a href="#none" onclick="fnIndpnStdrForm('${info.stdrSn}', '${status.index }');">${info.applcBeginDe }</a></td>
                                    <td><a href="#none" onclick="fnIndpnStdrForm('${info.stdrSn}', '${status.index }');">${info.applcEndDe }</a></td>
                                    <td class="tal">${info.dc }</td>
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
</div>
</body>
</html>