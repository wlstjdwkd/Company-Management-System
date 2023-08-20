<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<%@ page import="egovframework.board.config.BoardConfConstant" %>
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	
<html>
<head>
	<title>게시물 상세</title>

	<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask" />
	<ap:jsTag type="tech" items="msg,util,acm" />
	<ap:jsTag type="egovframework" items="board" />

	<!-- 기능별 스크립트 정의 -->
	<script type="text/javascript" src="<%=request.getContextPath()%>/resources/intra/board/board.js"></script>

	<!-- 사용자 스크립트 시작 -->
	<script type="text/javascript">
	_boardSvcUrl = "${svcUrl}";
	var cmtTabz;

	$().ready(function(){
		//게시판 설정값들을 초기화 합니다.
		if(typeof Ahpek == "undefined"){ Ahpek = {}; }
		Ahpek.pageType			= '${pageType}';
		Ahpek.boardType			= '${boardConfVo.kindCd}';
		Ahpek.boardNm			= '${boardConfVo.bbsNm}';
		Ahpek.useCategory		= '${boardConfVo.ctgYn}';
		Ahpek.fileYn			= '${boardConfVo.fileYn}';
		Ahpek.fileExts			= '${boardConfVo.fileExts}';
		Ahpek.captchaYn			= '${boardConfVo.captchaYn}';
		Ahpek.readCookieHour	= '${boardConfVo.readCookieHour}';
		Ahpek.commentYn			= '${boardConfVo.commentYn}';
		Ahpek.bbsCd				= '${dataVo.bbsCd}';
		Ahpek.seq				= '${dataVo.seq}';
		Ahpek.searchVal			= '${param.q_searchVal}';
		Ahpek.searchKey			= '${param.q_searchKey}';
		Ahpek.sortName			= '${param.q_sortName}';
		Ahpek.sortOrder			= '${param.q_sortOrder}';
		Ahpek.tagYn				= "${boardConfVo.tagYn}";
		Ahpek.listViewCd		= '${boardConfVo.listViewCd}';
		Ahpek.showSummaryYn		= '${param.showSummaryYn}';

		onReadyEventFunctions();
		
		<!-- //댓글 스크립트 -->
		<c:if test="${boardConfVo.commentYn eq 'Y'}">
		// //댓글 목록
		boardAnswerList("1");
		// 댓글 목록//
		</c:if>
		<!-- 댓글 스크립트// -->
	 });
	
	//첨부파일 다운로드
	function downAttFile(fileId){
		jsFiledownload("/PGCM0040.do","df_method_nm=updateFileDown&id="+fileId);
	}
	
	<!-- //댓글 스크립트 -->
	<c:if test="${boardConfVo.commentYn eq 'Y'}">
	// //댓글 목록
	function boardAnswerList(page) {
    	$("#df_method_nm_answer").val("processBoardAnswerListAjax");
    	$("#bbsCd_answer").val("${dataVo.bbsCd}");
		$("#seq_answer").val("${dataVo.seq}");
    	$("#answer_curr_page").val(page);
		$("#dataForm_answer").ajaxSubmit({
			url          : "${svcUrl}",
			dataType     : "html",
			async        : false,
			success      : function(response) {
				$("#boardAnswerList").html(response);
			}
		});
    }
	// 댓글 목록//
	
	// //댓글 삭제
	function boardAnswerSeqDelete(answerSeq) {
		jsMsgBox(null, 'confirm', "댓글을 삭제하시겠습니까?",
				function() {
					$("#df_method_nm_answer").val("processBoardAnswerSeqDeleteAjax");
					$("#bbsCd_answer").val("${dataVo.bbsCd}");
					$("#seq_answer").val("${dataVo.seq}");
					$("#answerSeq_answer").val(answerSeq);
					$("#dataForm_answer").ajaxSubmit({
						url          : "${svcUrl}",
						dataType     : "json",
						async        : false,
						success      : function(response) {
							try {
								if(response.result) {
									jsMsgBox(null,'info',response.message,function() {
										jsView('${dataVo.bbsCd}', '${dataVo.seq}');
									});
								} else {
									jsMsgBox(null,'info',response.message);
								}
							} catch (e) {
								if(response != null) {
									jsSysErrorBox(response);
								} else {
									jsSysErrorBox(e);
								}
								return;
							}
						}
					});
				}
			);
    }
	// 댓글 삭제//
	</c:if>
	<!-- 댓글 스크립트// -->
	</script>
	<!-- 사용자 스크립트 끝 -->
</head>
<body>
	<div id="self_dgs">
		<div class="pop_q_con">
			<%-- <div class="po_rel">
				<h4>${boardConfVo.bbsNm} 상세</h4>
			</div> --%>
		
			<!--// 상세보기 -->	
			<table class="table_basic" cellspacing="0" border="0" summary="${dataVo.title} 게시글 정보입니다.">
				<caption>${dataVo.title} 상세보기</caption>
				<%-- <colgroup>
					<col width="15%" />
					<col width="85%" />
				</colgroup> --%>
				<colgroup>
	                <col width="100" />
	                <col />
	                <col width="100" />
	                <col />
	                <col width="100" />
	                <col />
	                <col width="100" />
	                <col />
                </colgroup>                
                <thead>
                    <tr>
                        <th colspan="8" scope="colgroup">${dataVo.title }</th>
                    </tr>
                </thead>
				<tbody>
					<!-- 관리자 필수 항목(상태, 작성일, 작성자, 조회수, 내용) -->
					<tr>
                        <th scope="col">상태</th>
                        <td>
                        	<c:choose>
                        		<c:when test="${not empty dataVo.noticeYn and dataVo.noticeYn eq 'Y'}">공지</c:when>
                        		<c:otherwise>일반</c:otherwise>
                        	</c:choose>
                        </td>	
                        	
                        <th scope="col">작성일</th>
                        <td>${fn:substring(dataVo.regDt,0,10)}</td>
                        <th scope="col">작성자</th>
                        <td>${dataVo.regNm }</td>
                        <th scope="col">조회수</th>
                        <td>${dataVo.readCnt }</td>
                    </tr>
                    <tr>
                    	<c:if test="${boardConfVo.mgrEditorYn eq 'Y'}" >
                    		<td colspan="8" scope="colgroup" class="cont" id="emailCnHtml"></td>
                    		<input type="hidden" id="email_cn_html" value="${dataVo.contents }" />
                    		<script type="text/javascript">$("#emailCnHtml").html($("#email_cn_html").val());</script>
                    	</c:if>
						<c:if test="${boardConfVo.mgrEditorYn eq 'N'}" >
                        	<td colspan="8" scope="colgroup" class="cont">${dataVo.contents }</td>
                        </c:if>
                    </tr>
                    <!-- //관리자 필수 항목(상태, 작성일, 작성자, 조회수, 내용) -->
								
					<!-- 상세 배치에서 설정한 항목 배치 -->
					<!-- 설정제외 항목 -->					
					<c:set var="excludeArrange" value="TITLE|REG_DT|REG_NM|READ_CNT|CONTENTS" />
					<c:set var="scoreRow" value="1" />
					<c:forEach items="${boardConfVo.viewArrange}" var="arrange" varStatus="arrStatus">
						<c:choose>
							<c:when test="${arrange.columnId eq 'CTG_CD'}">
								<!-- 분류 -->
								<c:if test="${boardConfVo.ctgYn eq 'Y'}">
									<tr>
										<th><label for="${arrange.beanNm}">${arrange.columnNm}</label></th>
										<td colspan="7">${dataVo.ctgNm} [${dataVo.ctgCd}]</td>
									</tr>
								</c:if>
							</c:when>
	
							<c:when test="${arrange.columnId eq 'SCORE_CNT' || arrange.columnId eq 'SCORE_SUM'}">
								<!-- 만족도 -->
								<c:if test="${boardConfVo.stfyYn eq 'Y' && scoreRow == 1}">
									<tr>
										<th><label for="${arrange.beanNm}">${arrange.columnNm}</label></th>
										<td colspan="7">
											<form name="scoreForm" id="scoreForm" method="post" action="ND_score.action.do">
												<input type="hidden" name="bbsCd" id="bbsCd" value="${dataVo.bbsCd}" />
												<input type="hidden" name="seq" id="seq" value="${dataVo.seq}" />
												<span class="tx_b vm">평균평점 : <span id="boardScoreAvgSapn" class="tx_orange">${dataVo.scoreAvg}</span></span>
												<select name="scoreSum" class="mar_l5 vm">
													<option value="0">선택</option>
													<option value="1">1점</option>
													<option value="2">2점</option>
													<option value="3">3점</option>
													<option value="4">4점</option>
													<option value="5">5점</option>
													<option value="6">6점</option>
													<option value="7">7점</option>
													<option value="8">8점</option>
													<option value="9">9점</option>
													<option value="10">10점</option>
												</select>
												<input type="submit" class="s_blue vm" value="평점주기" />
											</form>
										</td>
									</tr>
									<c:set var="scoreRow" value="${scoreRow + 1}" />
								</c:if>
							</c:when>
	
							<c:when test="${arrange.columnId eq 'RECOM_CNT'}">
								<!-- 추천 -->
								<c:if test="${boardConfVo.recommYn eq 'Y'}">
									<tr>
										<th><label for="${arrange.beanNm}">${arrange.columnNm}</label></th>
										<td colspan="7">
											<input type="button" id="recomBtn" class="s_blue vm" value="추천 ${dataVo.recomCnt}" onclick="jsClickRecommAction(this, ${dataVo.bbsCd}, '${dataVo.seq}', ${boardConfVo.readCookieHour});" />
											<script type="text/javascript">$("#recomBtn").val("추천 ${dataVo.recomCnt}");</script>
										</td>
									</tr>
								</c:if>
							</c:when>
	
							<c:when test="${arrange.columnId eq 'ACCUSE_CNT'}">
								<!-- 신고 -->
								<c:if test="${boardConfVo.sueYn eq 'Y'}">
									<tr>
										<th><label for="${arrange.beanNm}">${arrange.columnNm}</label></th>
										<td colspan="7">
											<input type="button" id="accuseBtn" class="s_blue vm" value="신고 ${dataVo.accuseCnt}" onclick="jsClickAccuseAction(this, ${dataVo.bbsCd}, '${dataVo.seq}', ${boardConfVo.readCookieHour});" />
											<script type="text/javascript">$("#accuseBtn").val("신고 ${dataVo.accuseCnt}");</script>
										</td>
									</tr>
								</c:if>
							</c:when>
							<c:when test="${arrange.columnId eq 'FILE_SEQ'}">
								<!-- 첨부파일 -->
								<c:if test="${!empty dataVo.fileList}">
									<tr>
										<th class="table_line">첨부</th>
										<td colspan="7" scope="colgroup" class="table_line">											
											<c:choose>
												<c:when test="${fn:length(dataVo.fileList) > 0}">
													<c:forEach items="${dataVo.fileList}" var="fileVo">														
														<%-- <img src="/resources/openworks/theme/default/images/icon/icon_file_jpg.gif" class="vm" alt="파일 첨부" />
														<a href="PGCM0040.do?df_method_nm=updateFileDown&id=${fileVo.fileId}" title="${fileVo.fileDesc}">${fileVo.localNm}</a>
														<span class="tx_gray">(download ${fileVo.downCnt}, ${fileVo.fileSize}, ${fileVo.fileType})</span>
														<button type="button" class="gray_s mar_l10" onclick="jsShowFileHistory('${fileVo.fileSeq}', '${fileVo.fileId}');">이력보기</button> --%>
														
														<a href="#none" onclick="downAttFile('${fileVo.fileId}')" class="dw_fild" title="${fileVo.fileDesc}">
															${fileVo.localNm} [${fileVo.fileSize} byte]	
														</a> 													
													</c:forEach>
												</c:when>
												<c:otherwise>
													첨부파일이 없습니다.
												</c:otherwise>
											</c:choose>											
										</td>
									</tr>
								</c:if>
							</c:when>
	
							<c:otherwise>
								<!-- 기타 항목 -->
								<c:if test="${fn:indexOf(excludeArrange, arrange.columnId) < 0}" >
									<tr>
										<th><label for="${arrange.beanNm}">${arrange.columnNm}</label></th>
										<td colspan="7"><ap:bean-util field="${arrange.columnId}" obj="${dataVo}"/></td>
									</tr>
								</c:if>
							</c:otherwise>
						</c:choose>
					</c:forEach>
	
					<!-- 태그 -->
					<c:if test="${boardConfVo.tagYn eq 'Y'}">
						<tr>
							<td colspan="2">
								<div class="tag">
									<img src="/resources/openworks/theme/default/images/icon/icon_tag.gif" alt="태그" class="vm" />
									<c:if test="${empty dataVo.bbsTags}">등록된 태그가 없습니다.</c:if>
									<c:if test="${!empty dataVo.bbsTags}">
										<c:forEach var="tag" items="${dataVo.bbsTags}" varStatus="status">
											<a href="#" onclick="jsShowBbsListByTag('${tag}')">${tag}</a> <c:if test="${not status.last}">|</c:if>
										</c:forEach>
									</c:if>
								</div>
							</td>
						</tr>
					</c:if>
				</tbody>
			</table>
			
		
			<!-- 댓글 -->
			<%-- <c:if test="${boardConfVo.commentYn eq 'Y'}">
				<!-- <div id="tab_div" class="w_99p mar_t20">
					<ul class="list">
						<li class="tx_13"><a href="<c:url value="/intra/board/INC_cmt.list.do"/>?bbsCd=${dataVo.bbsCd}&seq=${dataVo.seq}" class="on"><span>댓글 : <span id="cmtCnt" class="tx_orange_u">${dataVo.commentCnt}</span>개</span></a></li>
					</ul>
				</div> -->
				<br/><div id="attachedCommentsDiv" class="comment block"></div>
			</c:if> --%>
			
			<c:if test="${boardConfVo.commentYn eq 'Y'}">
				<form name="dataForm_answer" id="dataForm_answer" method="post" action="dd.do">
					<input type="hidden" id="df_method_nm_answer" name="df_method_nm" value="" />
					<input type="hidden" id="bbsCd_answer" name="bbsCd" value="${dataVo.bbsCd}" />
					<input type="hidden" id="seq_answer" name="seq" value="${dataVo.seq}" />
					<input type="hidden" id="answerSeq_answer" name="answerSeq" value="" />
					
					<div id="boardAnswerList" style="margin-top:30px;"></div>
				</form>
			</c:if>
			<!-- //댓글 -->
		
			<!-- 버튼 -->
			<%-- <div class="mar_t10">
				<div class="float_l mar_b10">
					<button type="button" class="w_blue mar_r5" onclick="jsList('${param.df_curr_page}');">목록</button>
					<c:if test="${boardConfVo.listViewCd eq 1001}">
						<button type="button" class="w_blue mar_r5" onclick="jsView('${dataVo.prevVO.bbsCd}', '${dataVo.prevVO.seq}', '${dataVo.prevVO.regPwd}', '${dataVo.prevVO.openYn}'); return false;">이전</button>
						<button type="button" class="w_blue mar_r5" onclick="jsView('${dataVo.nextVO.bbsCd}', '${dataVo.nextVO.seq}', '${dataVo.nextVO.regPwd}', '${dataVo.nextVO.openYn}'); return false;">다음</button>
					</c:if>
				</div>
				<div class="float_r mar_b10">
					<c:if test="${MenuAssignType eq 'A' or MenuAssignType eq 'G'}">
						<button type="button" class="blue mar_l5" onclick="jsInsertForm('INSERT');">등록</button>
					</c:if>
					<c:if test="${(MenuAssignType eq 'A' && dataVo.regId eq __msk.mgrId) or MenuAssignType eq 'G'}">
						<button type="button" class="blue mar_l5" onclick="jsUpdateForm('UPDATE');">수정</button>
						<button type="button" class="blue mar_l5" onclick="jsDelete();">완전삭제</button>
						<c:if test="${empty dataVo.mgrDelYn or dataVo.mgrDelYn eq 'N'}">
							<button type="button" class="blue mar_l5" onclick="jsFlagDelete();">플래그삭제</button>
						</c:if>
					</c:if>
					<c:if test="${MenuAssignType eq 'G' && auth.wbiz_tot_adm eq 'Y'}">
						<button type="button" class="blue mar_l5" onclick="jsTransfer('${param.bbsCd}');">이동</button>
					</c:if>
				</div>
			</div> --%>
			<!-- //버튼 -->
			
			<div class="btn_page_last"><a class="btn_page_admin" href="#" onclick="jsList('${param.df_curr_page}');"><span>목록</span></a>
			<a class="btn_page_admin" href="#" onclick="jsDelete();"><span>삭제</span></a>
			<a class="btn_page_admin" href="#" onclick="jsUpdateForm('UPDATE');"><span>수정</span></a> </div>
		
			<!-- 목록 보여주기 시작 -->
			<form name="dataForm" id="dataForm" method="post" action="BD_board.list.do">				
		
				<!-- 다음/이전을 목록으로 보기 -->
				<c:if test="${boardConfVo.listViewCd == 1003}">
					<!-- 목록 삽입 -->
					<p class="mar_t10">&nbsp;</p>
					<%@include file="INC_boardList.jsp" %>
							
				</c:if>
				<!-- 다음/이전을 목록으로 보기 -->
		
				<!-- 다음/이전을 다음/이전으로 보기 -->
				<c:if test="${boardConfVo.listViewCd == 1002}">
					<%@ include file="../common/INC_prevNextList.jsp" %>
				</c:if>
				<!-- 다음/이전을 다음/이전으로 보기 끝 -->
		
				<input type="hidden" name="showSummaryYn" value="${param.showSummaryYn}" />
				<input type="hidden" name="listShowType" value="${param.listShowType}" />
		
				<input type="hidden" name="bbsCd" value="${dataVo.bbsCd}" />
				<input type="hidden" name="seq" value="${dataVo.seq}" />
				<input type="hidden" name="refSeq" value="${dataVo.refSeq}" />
				<input type="hidden" name="regPwd" value="${dataVo.regPwd}" />
		
				<input type="hidden" name="iconKey" value="" />
				<input type="hidden" name="contents" value="" />
				<input type="hidden" name="ctgCd" id="ctgCd" value="" />
				<input type="hidden" name="pageType" id="pageType" value="" />
				<input type="hidden" name="extColumn3" id="extColumn3" value="${param.extColumn3}" />
		
				<!-- 이동옵션 -->
				<input type="hidden" name="toBbsCd" id="toBbsCd" value="" />
				<input type="hidden" name="newCtg" id="newCtg" value=-1 />
				<input type="hidden" name="delDesc" id="delDesc" value="" />
				<input type="hidden" name="isMove" id="isMove" value="" />
				
				<input type="hidden" name="superAdmYn" value="${auth.wbiz_tot_adm}" />
				
				<!-- default values -->		
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />
				<input type="hidden" name="q_searchKeyType" value="${param.q_searchKeyType}" />
				<input type="hidden" name="q_searchVal" value="${param.q_searchVal}" />
				
			</form>
		</div>	
	</div>
</body>
</html>