<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>정보</title>
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<ap:globalConst />
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask,selectbox,jqGrid,css" />
<ap:jsTag type="tech" items="acm,msg,util" />
<script type="text/javascript">

	<c:if test="${resultMsg != null}">
		$(function(){
			jsMsgBox(null, "info", "${resultMsg}");
		});
	</c:if>
	
	// 데이터 조회
	function btn_relPossession_get_list() {
	
		var form = document.dataForm;
		
		form.df_curr_page.value = 1;
		form.df_method_nm.value = "findrelPossessionList";

		form.submit();
	}
	
</script>
</head>
<body>
<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
	<ap:include page="param/defaultParam.jsp" />
	<ap:include page="param/dispParam.jsp" />
	<ap:include page="param/pagingParam.jsp" />
		
	<!-- LNB 출력 방지 -->
	<input type="hidden" id="no_lnb" value="true" />
	<input type="hidden" id="curr_year_date" value="${inparam.stdYy}" />
    <!-- 좌측영역 -->
    <!-- content -->
	<div id="self_dgs">
		<div class="pop_q_con">
			<div class="block">
				<ap:pagerParam addJsRowParam="null,'findrelPossessionList'"/>
				<!-- 리스트 -->
				<div class="list_zone">
					<table cellspacing="0" border="0" summary="목록">
						<caption>리스트</caption>
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
							<col width="*" />
							<col width="*" />
							<col width="*" />
							<col width="*" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">기준년</th>
			                    <th scope="col">법인등록번호</th>
			                    <th scope="col">사업자번호</th>
			                    <th scope="col">기업명</th>
			                    <th scope="col">직접_법인번호</th>
			                    <th scope="col">직접_기업명</th>
			                    <th scope="col">직접_지분율</th>
			                    <th scope="col">간접_법인번호1</th>
			                    <th scope="col">간접_기업명1</th>
			                    <th scope="col">간접_지분율1</th>
			                    <th scope="col">간접_법인번호2</th>
			                    <th scope="col">간접_기업명2</th>
			                    <th scope="col">간접_지분율2</th>
			                </tr>
			            </thead>
			            <tbody>
			            	<c:choose>
			            		<c:when test="${fn:length(findrelPossessionList) > 0}">
			            			<c:forEach items="${findrelPossessionList}" var="info" varStatus="status">
			            				<tr>   
	 								  	 	<td>${info.stdYy}</td>
	 								  	 	<td class="tac">${info.jurirNo}</td>
	 								  	 	<td>${info.bizrNo}</td>
	 								  	 	<td class="tal">${info.entrprsNm}</td>
									  	 	<td>${info.drposjurirNo}</td>
									  	 	<td class="tal">${info.drposentrprsNm}</td>
									  	 	<td class="tar">${info.drposqotaRt}</td>
									  	 	<td>${info.ndrposjurirNo1}</td>
									  	 	<td class="tal">${info.ndrposentrprsNm1}</td>
									  	 	<td class="tar">${info.ndrposqotaRt1}</td>
									  	 	<td>${info.ndrposjurirNo2}</td>
									  	 	<td class="tal">${info.ndrposentrprsNm2}</td>
									  	 	<td class="tar">${info.ndrposqotaRt2}</td>
										</tr>
									</c:forEach>
								</c:when>
							   	<c:otherwise>
							   		<tr>
							   			<td colspan="13" style="text-align:center;">요청하신 조회년도의 기업직간접소유현황 정보가 없습니다.</td>
							   		</tr>
								</c:otherwise>
							</c:choose>							
						</tbody>
                    </table>
                </div>
                <div class="btn_page_last"><a class="btn_page_admin" href="#" onclick="parent.$.fn.colorbox.close();"><span>닫기</span></a></div>
                <div class="mgt10"></div>
                <!-- paginate -->
                <ap:pager pager="${pager}"  addJsParam="'findrelPossessionList'"/>
            </div>
        </div>
    </div>
</form>
</body>
</html>