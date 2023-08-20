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
<title>고객지원</title>
<ap:jsTag type="web" items="jquery,tools,ui" />
<ap:jsTag type="tech" items="util,mv" />
<script type="text/javascript">
	$(document).ready(function() {
		$("#btn_get_list").click(function() {
			$("#df_method_nm").val("index");
			$("#dataForm").submit();
		});

	});
	

	// 워크넷 페이지 오픈
	var fn_move_weburl = function(url) {
		window.open(url,"_blank");
	};
	
	function fn_empmn_info(empmnManageNo, userNo) {
		document.getElementById("df_method_nm").value = "empmnInfoForm";
		document.getElementById("ad_empmnManageNo").value = empmnManageNo;
		document.getElementById("ad_userNo").value = userNo;
		document.dataForm.submit();
	}

	function fn_cmpny_info(bizrNo, userNo) {
		document.getElementById("df_method_nm").value = "cmpnyInfoForm";
		document.getElementById("ad_bizrNo").value = bizrNo;
		document.getElementById("ad_userNo").value = userNo;
		document.dataForm.submit();
	}
</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<input type="hidden" name="ad_empmnManageNo" id="ad_empmnManageNo" /> 
		<input type="hidden" name="ad_userNo" id="ad_userNo" /> 
		<input type="hidden" name="ad_bizrNo" id="ad_bizrNo" /> 
		
		<!--//내용영역-->
		<section class="notice">
			<div class="sub_con">
				<div class="tit_page">
					${empmnPblancInfo.EMPMN_SJ}
					<p>신청기간 : ${empmnPblancInfo.RCRIT_BEGIN_DE} ~ ${empmnPblancInfo.RCRIT_END_DE}</p>
				</div>
				<div class="wtbl_view">
					<table cellspacing="0" border="0" summary="기본게시판 목록으로 채용정보를 제공합니다.">
						<caption>채용정보게시판</caption>
						<colgroup>
							<col width="30%">
							<col width="*">
						</colgroup>
						<tbody>
							<tr>
								<th>기업명</th>
								<td>${companyInfo.ENTRPRS_NM}</td>
							</tr>
							<tr>
								<th>홈페이지</th>
								<td>${companyInfo.HMPG}</td>
							</tr>
							<tr>
								<th>연락처</th>
								<td>${empmnPblancInfo.telNo1}- ${empmnPblancInfo.telNo2} - ${empmnPblancInfo.telNo3}</td>
							</tr>
							<tr>
								<th>주소</th>
								<td>${companyInfo.HEDOFC_ADRES}</td>
							</tr>
						</tbody>
					</table>

					<table cellspacing="0" border="0" summary="기본게시판 목록으로 채용정보를 제공합니다.">
						<caption>채용정보게시판</caption>
						<colgroup>
							<col width="30%">
							<col width="*">
						</colgroup>
						<tbody>
							<tr>
								<th>모집기간</th>
								<td>${empmnPblancInfo.RCRIT_BEGIN_DE}~ ${empmnPblancInfo.RCRIT_END_DE}</td>
							</tr>
							<tr>
								<th>모집인원</th>
								<td>
									<c:choose>
                						<c:when test="${empmnPblancInfo.iem51[0].IEM_VALUE != 'WKN' }">
                							<c:choose>
	                							<c:when test="${empmnPblancInfo.iem51[0].IEM_VALUE == 'A' }">${empmnPblancInfo.iem51[0].ATRB1}명</c:when>
	           						     		<c:otherwise>${empmnPblancInfo.iem51[0].CODE_NM}</c:otherwise>
	            				    		</c:choose>
	             					   </c:when>
	                					<c:otherwise>
	                						${empmnPblancInfo.iem51[0].ATRB3}명
	                					</c:otherwise>
	               					 </c:choose>
								</td>
							</tr>
							<tr>
								<th>근무형태</th>
								<td>
                					<c:forEach items="${empmnPblancInfo.iem33 }" var="iem33" varStatus="status">
                						<c:if test="${not status.first }">,</c:if>
                						<c:choose>
	                						<c:when test="${iem33.IEM_VALUE != 'WKN' }">${iem33.CODE_NM }</c:when>
	                						<c:otherwise>${iem33.ATRB3}</c:otherwise>
	                					</c:choose>
                					</c:forEach>
                				</td>
							</tr>
							<tr>
								<th>경력</th>
								<td>
                					<c:forEach items="${empmnPblancInfo.iem25 }" var="iem25" varStatus="status">
           					     		<c:if test="${not status.first }">,</c:if>
            				    		<c:choose>
	        					        	<c:when test="${iem25.IEM_VALUE != 'WKN' }">${iem25.CODE_NM }</c:when>
	           						     	<c:otherwise>${iem25.ATRB3}</c:otherwise>
	           					     	</c:choose>
              					  		<c:if test="${iem25.IEM_VALUE == 'CK2' }">(${iem25.ATRB1 }년 이상 ~ ${iem25.ATRB2 }년 미만)</c:if>
                					</c:forEach>
                				</td>
							</tr>
							<tr>
								<th>학력</th>
								<td>
									<c:choose>
	               						<c:when test="${empmnPblancInfo.iem27[0].IEM_VALUE != 'WKN' }">${empmnPblancInfo.iem27[0].CODE_NM }</c:when>
	              				 		<c:otherwise>${empmnPblancInfo.iem27[0].ATRB3}</c:otherwise>
	               					</c:choose>
	                				<c:if test="${empmnPblancInfo.iem27[0].ATRB1 == 'Y' }"> (졸업예정자 가능)</c:if>
								</td>
							</tr>
							<tr>
								<th>전공</th>
								<td>
									<c:choose>
	               						<c:when test="${empmnPblancInfo.iem79[0].IEM_VALUE != 'WKN' }">${empmnPblancInfo.iem79[0].CODE_NM }</c:when>
	              				 		<c:otherwise>${empmnPblancInfo.iem79[0].ATRB3}</c:otherwise>
	               					</c:choose>
								</td>
							</tr>
							<tr>
								<th>나이</th>
								<td>
									<c:forEach items="${empmnPblancInfo.iem52 }" var="iem52" varStatus="status">
										<c:if test="${not status.first }">,</c:if>
                					${iem52.CODE_NM }                		
                					</c:forEach>
                				</td>
							</tr>
							<tr>
								<th>근무지역</th>
								<td>
                					<c:forEach items="${empmnPblancInfo.iem22 }" var="iem22" varStatus="status">
                						<c:if test="${not status.first }">,</c:if>
                						<c:choose>
	               						 	<c:when test="${iem22.IEM_VALUE != 'WKN' }">${iem22.CODE_NM }</c:when>
	                						<c:otherwise>${iem22.ATRB3}</c:otherwise>
	                					</c:choose>
                					</c:forEach>
                				</td>
							</tr>
							<tr>
								<th>모집직종</th>
								<td>${empmnPblancInfo.JSSFC}</td>
							</tr>
							<tr>
								<th>모집직급</th>
								<td>
                					<c:forEach items="${empmnPblancInfo.iem31 }" var="iem31" varStatus="status">
                						<c:if test="${not status.first }">,</c:if>
                						<c:choose>
	              						  	<c:when test="${iem31.IEM_VALUE != 'WKN' }">${iem31.CODE_NM }</c:when>
	              						  	<c:otherwise>${iem31.ATRB3}</c:otherwise>
	               					 	</c:choose>
                					</c:forEach>
                				</td>
							</tr>
							<tr>
								<th>모집직책</th>
								<td>
			                		<c:forEach items="${empmnPblancInfo.iem32 }" var="iem32" varStatus="status">
                						<c:if test="${not status.first }">,</c:if>
                						<c:choose>
	                					<c:when test="${iem32.IEM_VALUE != 'WKN' }">${iem32.CODE_NM }</c:when>
	                					<c:otherwise>${iem32.ATRB3}</c:otherwise>
	                					</c:choose>
                					</c:forEach>
			                	</td>
							</tr>
							<tr>
								<th>우대조건</th>
								<td>${empmnPblancInfo.PVLTRT_CND}</td>
							</tr>
							<tr>
								<th>업무내용</th>
								<td>${empmnPblancInfo.JOB_CN}</td>
							</tr>
							<tr>
								<th>경력요건</th>
								<td>${empmnPblancInfo.CAREER_DETAIL_RQISIT}</td>
							</tr>
						</tbody>
					</table>
				</div>
				<!--//버튼-->
				<div class="btn">
					<a href="#none" class="btn_blue" id="btn_get_list">목록</a>
				</div>
				<!--버튼//-->
				
				<p>◆ 현재 기업의 다른 채용공고</p>
				<div class="job_list">
					<c:forEach items="${diffInfoList}" var="list" varStatus="status">
						<dl>
							<dt>
								<c:if test="${fn:substring(list.WANTED_AUTH_NO, 0, 1) != 'K'}">			<!-- 워크넷 자체 데이터가 아니라면 상세정보가 없으므로 링크 -->
                        			<c:choose>
										<c:when test="${fn:trim(list.WANTED_AUTH_NO) == ''}">   			<!-- 워크넷 자체 데이터가 아니라도 직접 입력했다면 팝업 -->
						     				<a href="#none" onclick="fn_empmn_info('${list.EMPMN_MANAGE_NO }', '${list.EP_NO}')">${list.EMPMN_SJ}</a>
						    			</c:when>
										<c:otherwise>          												<!-- 워크넷 자체 데이터가 아니라면 상세정보가 없으므로 링크 -->
						 					<a href="#none" onclick="fn_move_weburl('${list.ECNY_APPLY__WEB_ADRES }')">${list.EMPMN_SJ}</a>
										</c:otherwise>
									</c:choose>
                 				</c:if>
           						<c:if test="${fn:substring(list.WANTED_AUTH_NO, 0, 1) == 'K'}">
            						<a href="#none" onclick="fn_empmn_info('${list.EMPMN_MANAGE_NO }', '${list.EP_NO}')">${list.EMPMN_SJ}</a>
            					</c:if>
							</dt>
							<dd class="pl0">
								<c:if test="${list.ENTRPRS_VW_AT == 'Y'}"><a href="#none" onclick="fn_cmpny_info('${list.BIZRNO }', '${list.EP_NO}')">${list.ENTRPRS_NM}</a> </c:if>
								<c:if test="${list.ENTRPRS_VW_AT != 'Y'}">${list.ENTRPRS_NM}</c:if>
							</dd>
							<dd>${list.JSSFC}</dd>
							<dd>
								<c:forEach items="${list.iem25 }" var="iem25" varStatus="status">
									<c:if test="${not status.first }">,</c:if>
									<c:choose>
										<c:when test="${iem25.IEM_VALUE != 'WKN' }">${iem25.CODE_NM }<c:if test="${iem25.CODE_NM == '' }">${list.CAREER_DETAIL_RQISIT2}</c:if></c:when>
										<c:otherwise>${iem25.ATRB3}</c:otherwise>
		                      	  </c:choose>
								</c:forEach>
							</dd>
							<dd>${list.RCRIT_END_DE}</dd>
						</dl>
					</c:forEach>
				</div>
				<!--//글목록-->
				<!--  
				<div class="simply_list">
					<dl>
						<dt>다음글</dt>
						<dd>
							<c:if test="${fn:length(empmnPblancInfo.nextList) == 0}">
								다음글이 없습니다.
							</c:if>
							<a href="#none" onclick="fn_empmn_info('${empmnPblancInfo.nextList.EMPMN_MANAGE_NO }', '${empmnPblancInfo.nextList.USER_NO}')">${empmnPblancInfo.nextList.EMPMN_SJ}</a>
						</dd>
					</dl>
					<dl>
						<dt>이전글</dt>
						<dd>
							<c:if test="${fn:length(empmnPblancInfo.preList) == 0}">
								이전글이 없습니다.
							</c:if>
							<a href="#none" onclick="fn_empmn_info('${empmnPblancInfo.preList.EMPMN_MANAGE_NO }', '${empmnPblancInfo.preList.USER_NO}')">${empmnPblancInfo.preList.EMPMN_SJ}</a>
						</dd>
					</dl>
				</div>
				-->
				<!--글목록//-->
			</div>
		</section>
		<!--내용영역//-->
	</form>
</body>
</html>