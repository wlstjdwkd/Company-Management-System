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
					<center>
	      			<c:choose>
                      	 <c:when test="${not empty dataMap.LOGO_FILE_SN }">	      								
	      					<img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${dataMap.LOGO_FILE_SN}" />" alt="smba" title="smba" width="300" height="125" />
		             	</c:when>
                        <c:otherwise>
                        	<img src="<c:url value="/images/cs/logo.jpg"/>" id="img_photo" alt="로고" width="300" height="125" style="border:#666 solid 1px" />
                        </c:otherwise>
               		</c:choose>
               		</center>
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
								<td>${dataMap.ENTRPRS_NM}</td>
							</tr>
							<tr>
								<th>홈페이지</th>
								<td>${dataMap.HMPG}</td>
							</tr>
							<tr>
								<th>상장여부</th>
								<td>${dataMap.LST_AT_NM}</td>
							</tr>
							<tr>
								<th>기업형태</th>
								<td>${dataMap.ENTRPRS_STLE_NM}</td>
							</tr>
							<tr>
								<th>기업인증</th>
								<td>${dataMap.ENTRPRS_CRTFC_NM}</td>
							</tr>
						</tbody>
					</table>
				</div>
				<p>상세정보</p>
				<div class="wtbl_view">
					<table cellspacing="0" border="0" summary="기본게시판 목록으로 채용정보를 제공합니다.">
						<caption>채용정보게시판</caption>
						<colgroup>
							<col width="30%">
							<col width="*">
							<col width="30%">
							<col width="*">
						</colgroup>
						<tbody>
							<tr>
								<th>설립일자</th>
								<td>${dataMap.FOND_DE}</td>
								<th>상장일</th>
								<td>${dataMap.LST_DE}</td>
							</tr>
							<tr>
								<th>업종</th>
								<td>${dataMap.INDUTY_NM}</td>
								<th>주생산품</th>
								<td>${dataMap.MAIN_PRODUCT}</td>
							</tr>
						</tbody>
					</table>
				</div>
				<p>주요지표</p>
				<div class="wtbl_view">	
					<table cellspacing="0" border="0" summary="기본게시판 목록으로 채용정보를 제공합니다.">
						<caption>채용정보게시판</caption>
						<colgroup>
							<col width="*">
							<col width="*">
							<col width="*">
							<col width="*">
							<col width="*">
						</colgroup>
						<thead>
                        	<tr>
                           		<th scope="col"></th>
                                <th scope="col">매출액</th>
                                <th scope="col">자본금</th>
                                <th scope="col">자산총액</th>
                                <th scope="col">근로자수</th>
                          	</tr>
                       	</thead>
						<tbody>
							<tr>
								<th>${jipyo[0].STDYY }</th>
								<td>${jipyo[0].SELNG_AM}</td>
								<td>${jipyo[0].CAPL}</td>
								<td>${jipyo[0].ASSETS_SM}</td>
								<td>${jipyo[0].ORDTM_LABRR_CO}</td>
							</tr>
							<tr>
								<th>${jipyo[1].STDYY }</th>
								<td>${jipyo[1].SELNG_AM}</td>
								<td>${jipyo[1].CAPL}</td>
								<td>${jipyo[1].ASSETS_SM}</td>
								<td>${jipyo[1].ORDTM_LABRR_CO}</td>
							</tr>
							<tr>
								<th>${jipyo[2].STDYY }</th>
								<td>${jipyo[2].SELNG_AM}</td>
								<td>${jipyo[2].CAPL}</td>
								<td>${jipyo[2].ASSETS_SM}</td>
								<td>${jipyo[2].ORDTM_LABRR_CO}</td>
							</tr>
						</tbody>
					</table>
				</div>
				<p> 회사소개</p>
				<div class="wtbl_view">
				
					<c:if test = "${not empty dataMap.LAYOUT_TY}" >
						<table cellspacing="0" border="0" summary="기본게시판 목록으로 채용정보를 제공합니다.">
							<caption>채용정보게시판</caption>
							<tbody>
								<c:if test = "${dataMap.LAYOUT_TY eq 1}">
									<tr>
										<td>
											<c:choose>
                    							<c:when test="${not empty layoutImageList[0].IMAGE_SN }">
                        							<img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${layoutImageList[0].IMAGE_SN}" />" id="img_photo" alt="로고" style="border:#666 solid 1px" />
                        						</c:when>
                   							<c:otherwise>
                    							<img src="<c:url value="/images/cs/photo.png"/>" id="img_photo" alt="로고" style="border:#666 solid 1px" />
                    						</c:otherwise>
                   							</c:choose>
										</td>
									</tr>
									<tr>
										<td>${layoutTextList[0].TEXT }</td>
									</tr>
									<tr>
										<td>
											<c:choose>
                    							<c:when test="${not empty layoutImageList[1].IMAGE_SN }">
                        							<img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${layoutImageList[0].IMAGE_SN}" />" id="img_photo" alt="로고" style="border:#666 solid 1px" />
                        						</c:when>
                   							<c:otherwise>
                    							<img src="<c:url value="/images/cs/photo.png"/>" id="img_photo" alt="로고" style="border:#666 solid 1px" />
                    						</c:otherwise>
                   							</c:choose>										
										</td>
									</tr>
									<tr>
										<td>${layoutTextList[1].TEXT }</td>
									</tr>
									<tr>
										<td>${layoutTextList[2].TEXT }</td>
									</tr>									
								</c:if>
								<c:if test = "${dataMap.LAYOUT_TY eq 2}">
									<tr>
										<td>
											<c:choose>
                    							<c:when test="${not empty layoutImageList[0].IMAGE_SN }">
                        							<img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${layoutImageList[0].IMAGE_SN}" />" id="img_photo" alt="로고" style="border:#666 solid 1px" />
                        						</c:when>
                   							<c:otherwise>
                    							<img src="<c:url value="/images/cs/photo.png"/>" id="img_photo" alt="로고" style="border:#666 solid 1px" />
                    						</c:otherwise>
                   							</c:choose>
										</td>
									</tr>
									<tr>
										<td>${layoutTextList[0].TEXT }</td>
									</tr>
									<tr>
										<td>
											<c:choose>
                    							<c:when test="${not empty layoutImageList[1].IMAGE_SN }">
                        							<img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${layoutImageList[0].IMAGE_SN}" />" id="img_photo" alt="로고" style="border:#666 solid 1px" />
                        						</c:when>
                   							<c:otherwise>
                    							<img src="<c:url value="/images/cs/photo.png"/>" id="img_photo" alt="로고" style="border:#666 solid 1px" />
                    						</c:otherwise>
                   							</c:choose>										
										</td>
									</tr>
									<tr>
										<td>${layoutTextList[1].TEXT }</td>
									</tr>
								</c:if>
								<c:if test = "${dataMap.LAYOUT_TY eq 3}">
									<tr>
										<td>
											<c:choose>
                    							<c:when test="${not empty layoutImageList[0].IMAGE_SN }">
                        							<img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${layoutImageList[0].IMAGE_SN}" />" id="img_photo" alt="로고" style="border:#666 solid 1px" />
                        						</c:when>
                   							<c:otherwise>
                    							<img src="<c:url value="/images/cs/photo.png"/>" id="img_photo" alt="로고" style="border:#666 solid 1px" />
                    						</c:otherwise>
                   							</c:choose>
										</td>
									</tr>
									<tr>
										<td>${layoutTextList[0].TEXT }</td>
									</tr>
									<tr>
										<td>
											<c:choose>
                    							<c:when test="${not empty layoutImageList[1].IMAGE_SN }">
                        							<img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${layoutImageList[0].IMAGE_SN}" />" id="img_photo" alt="로고" style="border:#666 solid 1px" />
                        						</c:when>
                   							<c:otherwise>
                    							<img src="<c:url value="/images/cs/photo.png"/>" id="img_photo" alt="로고" style="border:#666 solid 1px" />
                    						</c:otherwise>
                   							</c:choose>	
										</td>
									</tr>
									<tr>
										<td>${layoutTextList[1].TEXT }</td>
									</tr>
									<tr>
										<td>
											<c:choose>
                    							<c:when test="${not empty layoutImageList[2].IMAGE_SN }">
                        							<img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${layoutImageList[0].IMAGE_SN}" />" id="img_photo" alt="로고" style="border:#666 solid 1px" />
                        						</c:when>
                   							<c:otherwise>
                    							<img src="<c:url value="/images/cs/photo.png"/>" id="img_photo" alt="로고" style="border:#666 solid 1px" />
                    						</c:otherwise>
                   							</c:choose>										
										</td>
									</tr>
									<tr>
										<td>${layoutTextList[2].TEXT }</td>
									</tr>
									<tr>
										<td>
											<c:choose>
                    							<c:when test="${not empty layoutImageList[3].IMAGE_SN }">
                        							<img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${layoutImageList[0].IMAGE_SN}" />" id="img_photo" alt="로고" style="border:#666 solid 1px" />
                        						</c:when>
                   							<c:otherwise>
                    							<img src="<c:url value="/images/cs/photo.png"/>" id="img_photo" alt="로고" style="border:#666 solid 1px" />
                    						</c:otherwise>
                   							</c:choose>										
                   						</td>
									</tr>
									<tr>
										<td>${layoutTextList[3].TEXT }</td>
									</tr>
								</c:if>
							</tbody>
						</table>
					</c:if>
					
					<table cellspacing="0" border="0" summary="기본게시판 목록으로 채용정보를 제공합니다.">
						<caption>채용정보게시판</caption>
						<colgroup>
							<col width="30%">
							<col width="*">
						</colgroup>
						<tbody>
							<tr>
								<th>대표자</th>
								<td>${dataMap.ENTRPRS_NM}</td>
							</tr>
							<tr>
								<th>담당자이메일</th>
								<td>${dataMap.CHARGER_EMAIL}</td>
							</tr>
							<tr>
								<th>전화번호</th>
								<td>${dataMap.TELNO1}- ${dataMap.TELNO2} - ${dataMap.TELNO3}</td>
							</tr>
							<tr>
								<th>팩스번호</th>
								<td>${dataMap.FXNUM1 }-${dataMap.FXNUM2 }-${dataMap.FXNUM3 }</td>
							</tr>
							<tr>
								<th>주소</th>
								<td>${dataMap.HEDOFC_ZIP }${dataMap.HEDOFC_ADRES }</td>
							</tr>
						</tbody>
					</table>
				</div>
				
				<!--//버튼-->
				<div class="btn">
					<a href="#none" class="btn_blue" id="btn_get_list">목록</a>
				</div>
				<!--버튼//-->

				<p>◆ 채용공고</p>
				<div class="job_list">
					<c:forEach items="${empmnInfoList}" var="list" varStatus="status">
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