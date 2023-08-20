<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>석유관리원 환급시스템</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask,blockUI" />
<ap:jsTag type="tech" items="acm,msg,util,etc,mainn" />
<script type="text/javascript">

	$(document).ready(function(){

	});
	
	// 등록화면 이동
	function btn_regist() {
		jsMsgBox(null, 'confirm', "신규등록하시겠습니까?", function(){
			var form = document.dataForm;
			form.df_method_nm.value = "altrtvConfrmForm";
			document.getElementById("mode").value = 'regist';
			form.submit();
		});
	}
	
	// 수정화면 이동
	function btn_modify(confmerId,altrtvConfmerId,altrtvConfmBgnDe) {
		var form = document.dataForm;
		form.df_method_nm.value = "altrtvConfrmForm";
		document.getElementById("confmerId").value = confmerId;
		document.getElementById("altrtvConfmerId").value = altrtvConfmerId;
		document.getElementById("altrtvConfmBgnDe").value = altrtvConfmBgnDe;
		document.getElementById("mode").value = 'modify';
		form.submit();
	}

</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp"/>
		
		<input type="hidden" name="mode" id="mode"/>
		<input type="hidden" name="confmerId" id="confmerId"/>
		<input type="hidden" name="altrtvConfmerId" id="altrtvConfmerId"/>
		<input type="hidden" name="altrtvConfmBgnDe" id="altrtvConfmBgnDe"/>

		<!-- // content -->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!-- // 타이틀 영역 -->
					<div class="r_sec">
                        <div class="r_top" style="margin-bottom:20px;">
                        	<h2>대체결재자 목록</h2>
                        </div>
                    </div>
                    <div class="btn_page_total" style="margin-bottom:10px;">
						<a href="#none" class="btn_page_admin" onclick="btn_regist()"><span>신규등록</span></a>
					</div>
					<!-- 타이틀 영역 // -->
					<div class="block">
	                	<ap:pagerParam />
	                	<!--// 리스트 -->
	                	<div class="list_zone">
							<div style="overflow-x:auto; min-width:800px;">
								<table style="white-space:nowrap">
									<colgroup>
										<col width="*"/>
									</colgroup>
									<thead>
										<tr>
											<th scope="col">번호</th>
											<th scope="col">대체결재자</th>
											<th scope="col">부서</th>
											<th scope="col">대체결재시작일</th>
											<th scope="col">대체결재종료일</th>
											<th scope="col">대체사유</th>
											<th scope="col">사용여부</th>
											<th scope="col">등록일시</th>
											<th scope="col">수정일시</th>
										</tr>
									</thead>
									<tbody>
										<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
										<c:if test="${fn:length(resultList) == 0}">
											<tr>
												<td colspan="9">
													조회 결과가 없습니다.
												</td>
											</tr>
										</c:if>
										<%-- 데이터를 화면에 출력해준다 --%>
										<c:forEach items="${resultList}" var="list" varStatus="status">
											<tr>
												<td class="tac">${pager.totalRowCount-(pager.totalRowCount-(pager.pageNo-1)*(pager.rowSize)-status.index) + 1}</td>
												<%-- <td>${status.index + 1}</td> --%>
												<%-- <td>${pagerNo-(status.index)}</td> --%>
												<td class="tal">
													<a href="#none" onclick="btn_modify('${list.confmerId}','${list.altrtvConfmerId}','${list.altrtvConfmBgnDe}');">
														<b>${list.altrtvConfmerNm}</b>
													</a>
												</td>
												<td class="tal">${list.altrtvConfmerDeptNm}</td>
												<td>${list.altrtvConfmBgnDe}</td>
												<td>${list.altrtvConfmEndDe}</td>
												<td class="tal">${list.altrtvReason}</td>
												<td>${list.useAt}</td>
												<td>${list.rgsde}</td>
												<td>${list.updde}</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>
						</div>
						<div>
			             	<ap:pager pager="${pager}" />
			            </div>
	                	<!-- 리스트 //-->
	                </div>
				</div>
			</div>
		</div>
		<!-- content // -->
	</form>
</body>
</html>