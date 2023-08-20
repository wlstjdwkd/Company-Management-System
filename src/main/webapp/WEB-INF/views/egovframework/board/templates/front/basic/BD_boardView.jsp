<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<%@ page import="egovframework.board.config.BoardConfConstant" %>
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<c:set var="userInfoVo" value="${sessionScope[SESSION_USERINFO_NAME]}" />

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	
<html>
<head>
	<title>게시물 상세</title>
	<ap:jsTag type="web" items="jquery,validate,notice,msgBox,colorbox,multifile,mask,form" />
	<ap:jsTag type="tech" items="msg,util,cmn, mainn, subb, font,cs" />
	<ap:jsTag type="egovframework" items="boardFront" />

	<!-- 사용자 스크립트 시작 -->
	<script type="text/javascript">
	_boardSvcUrl = "${svcUrl}";
	var cmtTabz;

	$().ready(function(){
		
		<c:if test="${message != null}">
			jsMsgBox(null, "info","${message}");
		</c:if>
		
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
		Ahpek.isSession			= ${!empty __usk};

		onReadyEventFunctions();
		
		<!-- //댓글 스크립트 -->
		<c:if test="${boardConfVo.commentYn eq 'Y'}">
		// //댓글 작성
		$("#dataForm_answer").validate({
			//유효성 검증 BEAN Annotation 기반 자동 설정
			rules: {
				answerCn : { required:true, minlength:10 }
			},
			submitHandler: function() {
				jsMsgBox(null, 'confirm', "댓글을 작성하시겠습니까?",
					function() {
						$("#df_method_nm_answer").val("processBoardAnswerInsertAjax");
						$("#bbsCd_answer").val("${dataVo.bbsCd}");
						$("#seq_answer").val("${dataVo.seq}");
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
		});
		
		$("#answer_submit").click(function() {
			$("#dataForm_answer").submit();
		});
		// 댓글 작성//
		
		// //댓글 목록
		boardAnswerList("1");
		// 댓글 목록//
		</c:if>
		<!-- 댓글 스크립트// -->
		
		if(${param.df_menu_no} == '12'){
        	$("#titleNm1").html("고객지원");
        	$("#titleNm2").html("고객지원");
        	$("#subNm").html("공지사항");
        }
        if(${param.df_menu_no} == '70'){
        	$("#titleNm1").html("정보제공");
        	$("#titleNm2").html("정보제공");
        	$("#subNm").html("보도자료");
        }
        if(${param.df_menu_no} == '139'){
        	$("#titleNm1").html("정보제공");
        	$("#titleNm2").html("정보제공");
        	$("#subNm").html("자료실");
        }
		
		
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
	
	// //댓글 수정
	function boardAnswerSeqUpdate(answerSeq) {
		if($("#answerCn_" + answerSeq).val().length == 0) {
			jsMsgBox(null,'info',"필수입력 항목입니다.");
			
			return;
		}
		if($("#answerCn_" + answerSeq).val().length < 10) {
			jsMsgBox(null,'info',"최소 10자 이상이어야합니다.");
			
			return;
		}
		
		jsMsgBox(null, 'confirm', "댓글을 수정하시겠습니까?",
			function() {
				$("#df_method_nm_answer").val("processBoardAnswerSeqUpdateAjax");
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
	// 댓글 수정//
	
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
<div id="wrap">
	<div class="s_cont" id="s_cont">
		<div class="s_tit s_tit04">
			<h1 id="titleNm1"></h1>
		</div>
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit tit4" id="titleNm2"></h2>
				<ul>
				</ul>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}"  />
				</div>
				<div class="r_cont">
					<c:set var="mainArranges" value="" />					
					<c:set var="mainThCnt" value="0" />					
					
					<c:forEach items="${boardConfVo.viewArrange}" var="arrangeRow" varStatus="status">
						<c:if test="${(arrangeRow.columnId eq 'REG_DT') or (arrangeRow.columnId eq 'REG_NM') or (arrangeRow.columnId eq 'READ_CNT')}">
							<c:set var="mainArranges" value="${mainArranges}|${arrangeRow.columnId}" />
							<c:set var="mainThCnt" value="${mainThCnt + 1 }" />							
						</c:if>
					</c:forEach>
					
					<c:set var="maxColSpan" value="${mainThCnt * 2 }" />
					
					<div class="list_view">
						<div class="view_tit">
							<h3>${dataVo.title}</h3>
							<p>
							<c:if test="${fn:indexOf(mainArranges, 'REG_DT') != -1}">
								&nbsp;&nbsp;|&nbsp;&nbsp;${fn:substring(dataVo.regDt,0,10)}
							</c:if>
							<c:if test="${fn:indexOf(mainArranges, 'REG_NM') != -1}">
								&nbsp;&nbsp;|&nbsp;&nbsp; <!-- 등록자 삭제  -->
							</c:if>
							<c:if test="${fn:indexOf(mainArranges, 'READ_CNT') != -1}">
								&nbsp;&nbsp;|&nbsp;&nbsp;hit ${dataVo.readCnt}
							</c:if>
							</p>
						</div>
						<div class="view_cont">
							<p>
								<c:if test="${boardConfVo.mgrEditorYn eq 'Y'}" >
                    				<p id="emailCnHtml"></p>
                    				<input type="hidden" id="email_cn_html" value="${dataVo.contents }" />
                    				<script type="text/javascript">$("#emailCnHtml").html($("#email_cn_html").val());</script>
                    			</c:if>
								<c:if test="${boardConfVo.mgrEditorYn eq 'N'}" >
									<td colspan="${maxColSpan }" class="cont">
										${dataVo.contents}
									</td>
        						</c:if>
							</p>
						</div>
						<c:if test="${!empty dataVo.fileList}">
							<div class="file_down">
								<span>첨부파일</span>
								<c:choose>
									<c:when test="${fn:length(dataVo.fileList) > 0}">
										<p>
											<c:forEach items="${dataVo.fileList}" var="fileVo">				
												<a href="#none" onclick="downAttFile('${fileVo.fileId}')" title="${fileVo.fileDesc}"><img src="/images2/sub/list_file_ico.png">${fileVo.localNm}</a> [${fileVo.fileSize}]
												<br/>
											</c:forEach>
										</p>
									</c:when>
									<c:otherwise>
										<p><a>첨부파일이 없습니다.</a></p>
									</c:otherwise>
								</c:choose>
							</div>
						</c:if>
						
						<%-- 
						댓글기능 사용시 아래의 코드를 수정해야함
						<c:if test="${boardConfVo.commentYn eq 'Y'}">
							<form name="dataForm_answer" id="dataForm_answer" method="post" action="dd.do">
								<input type="hidden" id="df_method_nm_answer" name="df_method_nm" value="" />
								<input type="hidden" id="bbsCd_answer" name="bbsCd" value="${dataVo.bbsCd}" />
								<input type="hidden" id="seq_answer" name="seq" value="${dataVo.seq}" />
								<input type="hidden" id="answerSeq_answer" name="answerSeq" value="" />
								
								<div id="boardAnswerList" style="margin-top:30px;"></div>
								
								<!-- //댓글 작성 영역 -->
								<c:choose>
		     						<c:when test="${empty userInfoVo}">
		     							<p style="margin-bottom:30px;">댓글을 다시려면 로그인을 하셔야합니다.</p>
		     						</c:when>
		     						<c:otherwise>
		     							<c:choose>
		     								<c:when test="${userInfoVo.emplyrTy eq 'JB'}">
		     									<p style="margin-bottom:30px;">개인 또는 회원 아이디로 로그인 하셔야합니다.</p>
		     								</c:when>
		     								<c:otherwise>
		     									<div class="btn_page" style="margin-bottom:30px; text-align:left;">
													<textarea rows="3" cols="103" id="answerCn" name="answerCn" placeholder="댓글을 작성하세요"></textarea>
													<a class="btn_page_blue" href="#" id="answer_submit"><span>댓글등록</span></a>
												</div>
		     								</c:otherwise>
		     							</c:choose>
		     						</c:otherwise>
		     					</c:choose>
							<!-- 댓글 작성 영역// -->
							</form>
						</c:if> 
						--%>
						
						<%-- <!-- 목록 보여주기 시작 -->
						<form name="dataForm" id="dataForm" method="post" action="BD_board.list.do">
						<!-- default values -->		
						<ap:include page="param/defaultParam.jsp" />
						<ap:include page="param/pagingParam.jsp" />
						<ap:include page="param/dispParam.jsp" />
						<%@include file="../common/INC_searchParam.jsp" %>						
				
						<!-- 다음/이전을 목록으로 보기 -->
						<c:if test="${boardConfVo.listViewCd == 1003}">
							<!-- 목록 삽입 시작 -->
							항목 표시 수
							<c:set var="thCnt" value="0" />
				
							<!-- 목록 시작 -->
							<table class="gray_list" >
								<caption class="dpn">기본게시판 목록</caption>
								<colgroup>
									<!-- 번호(필수) -->
									<c:set var="thCnt" value="${thCnt + 1}" />
									<col style="width:6%" />
				
									<!-- 목록 배치에서 설정한 항목 배치 -->
									<c:forEach items="${boardConfVo.listArrange}" var="arrange" varStatus="status">
										<c:set var="thCnt" value="${thCnt + 1}" />
										<c:if test="${arrange.columnId eq 'TITLE'}"><col style="width:*" /></c:if>
										<c:if test="${arrange.columnId != 'TITLE'}"><col style="width:10%" /></c:if>
									</c:forEach>
								</colgroup>
								<thead>
									<tr>
										<!-- 번호(필수) -->
										<th id="th-ROWNUM"><span class="sort cs_pointer" id="ROWNUM">번호</span></th>
							
										<!-- 목록 배치에서 설정한 항목 배치 -->
										<c:forEach items="${boardConfVo.listArrange}" var="arrange" varStatus="status">
											<th id="th-${arrange.columnId}"><span class="sort cs_pointer" id="${arrange.columnId}">${arrange.columnNm}</span></th>
										</c:forEach>
									</tr>
								</thead>
								<tbody id="odd-color">
									<!-- 공지 목록  -->
									<c:if test="${boardConfVo.noticeYn eq 'Y'}">
				
										<c:forEach items="${noticeList}" var="noticeVo" varStatus="status">
					
											<c:set var="trClass" value="bg_blue" />
											<c:if test="${(pageType == 'VIEW') && (dataVo.seq == noticeVo.seq)}">
												<c:set var="trClass" value="tr-sel" />
											</c:if>
				
											<tr class="${trClass}">
												<!-- 번호(필수) -->
												<td>
													<c:choose>
														<c:when test="${(pageType eq 'VIEW') && (noticeVo.seq eq dataVo.seq)}">
															<img src="<c:url value='/resources/web/theme/default/images/icon/icon_current.png' />" alt="현재글" />
														</c:when>
														<c:otherwise>
															<img src="<c:url value='/resources/web/theme/default/images/icon/icon_notice.gif' />" alt="공지알림" />
														</c:otherwise>
													</c:choose>
												</td>

												<!-- 목록 배치에서 설정한 항목 배치 -->
												<c:forEach items="${boardConfVo.listArrange}" var="arrange" varStatus="arrStatus">
													<c:choose>
														<c:when test="${arrange.columnId eq 'TITLE'}">
															<td class="tx_l">
																<a href="#" onclick="jsView(${noticeVo.bbsCd}, ${noticeVo.seq}, '${noticeVo.regPwd}', '${noticeVo.openYn}'); return false;">
																	${noticeVo.title}
																	<c:if test="${noticeVo.titleLength > (boardConfVo.cutTitleNum * 2)}">...</c:if>
																</a>

																<c:choose>
																	<c:when test="${(boardConfVo.downYn eq 'Y') && (noticeVo.fileCnt > 0) && (noticeVo.openYn eq 'Y')}">
																		<a href="/component/file/zipdownload.do?fileSeq=${noticeVo.fileSeq}" class="t_file" title="첨부파일이 ${noticeVo.fileCnt}개 존재합니다.">(${noticeVo.fileCnt})</a>
																	</c:when>
																	<c:when test="${noticeVo.fileCnt > 0}">
																		<span class="t_file" title="첨부파일이 ${noticeVo.fileCnt}개 존재합니다.">(${noticeVo.fileCnt})</span>
																	</c:when>
																</c:choose>

																<c:if test="${boardConfVo.newArticleNum > 0}">
																	<c:if test="${noticeVo.passDay <= boardConfVo.newArticleNum}">
																		<img src="/resources/web/theme/default/images/icon/icon_new.gif" alt="새글"/>
																	</c:if>
																</c:if>

																<div id="titleNoticeSummary${status.count}" class="tx_blue_s"><c:out value="${noticeVo.summary}" escapeXml="true" /></div>
															</td>
														</c:when>
														<c:when test="${arrange.columnId eq 'CTG_CD'}">
															<td>공지</td>
														</c:when>
														<c:when test="${arrange.columnId eq 'READ_CNT'}">
															<td>
																<c:if test="${boardConfVo.emphasisNum <= noticeVo.readCnt}"><span class="tx_blue">${noticeVo.readCnt}</span></c:if>
																<c:if test="${boardConfVo.emphasisNum > noticeVo.readCnt}"><span>${noticeVo.readCnt}</span></c:if>
															</td>
														</c:when>
														<c:otherwise>
															<td><op:bean-util field="${arrange.columnId}" obj="${noticeVo}"/></td>
														</c:otherwise>
													</c:choose>
												</c:forEach>
											</tr>
										</c:forEach>
									</c:if>

									<!-- 공지 제외 게시물 목록 -->
									<c:set var="index" value="${pager.indexNo}"/>
									<c:forEach items="${boardList}" var="baseVo" varStatus="status">
										<tr>
											<!-- 번호(필수) -->
											<td>
												<c:choose>
													<c:when test="${(pageType eq 'VIEW') && (baseVo.seq eq dataVo.seq)}">
														<img src="<c:url value='/resources/web/theme/default/images/icon/icon_current.png' />" alt="현재글" />
													</c:when>
													<c:otherwise>
														${index-status.index}
													</c:otherwise>
												</c:choose>
											</td>

											<!-- 목록 배치에서 설정한 항목 배치 -->
											<c:forEach items="${boardConfVo.listArrange}" var="arrange" varStatus="arrStatus">
												<c:choose>
													<c:when test="${arrange.columnId eq 'TITLE'}">
														<td class="tx_l">
															<c:choose>
																<c:when test="${baseVo.mgrDelYn eq 'Y'}">
																	<p class="tx_blue_l">[관리자에 의하여 삭제되었습니다.]</p>
																</c:when>
																<c:otherwise>
																	<c:choose>
																		<c:when test="${!empty baseVo.moveBbsNm}">
																			<span class="tx_orange_u">[${baseVo.moveBbsNm}](으)로 이동된 글입니다.</span>
																		</c:when>
																		<c:otherwise>
																			<a href="#" class="contentTip"
																				onclick="jsView('${baseVo.bbsCd}', '${baseVo.seq}', '${baseVo.regPwd}', '${baseVo.openYn}'); return false;">
																				${baseVo.title}
																				<c:if test="${baseVo.titleLength > (boardConfVo.cutTitleNum * 2)}">...</c:if>
																			</a>

																			<c:choose>
																				<c:when test="${(boardConfVo.downYn eq 'Y') && (baseVo.fileCnt > 0) && (baseVo.openYn eq 'Y')}">
																					<a href="/component/file/zipdownload.do?fileSeq=${baseVo.fileSeq}" class="t_file" title="첨부파일이 ${baseVo.fileCnt}개 존재합니다.">(${baseVo.fileCnt})</a>
																				</c:when>
																				<c:when test="${baseVo.fileCnt > 0}">
																					<span class="t_file" title="첨부파일이 ${baseVo.fileCnt}개 존재합니다.">(${baseVo.fileCnt})</span>
																				</c:when>
																			</c:choose>
				
																			<c:if test="${boardConfVo.newArticleNum > 0}">
																				<c:if test="${baseVo.passDay <= boardConfVo.newArticleNum}">
																			   		<img src="/resources/web/theme/default/images/icon/icon_new.gif" alt="새글"/>
																			   	</c:if>
																			</c:if>
				
																		</c:otherwise>
																	</c:choose>
																</c:otherwise>
															</c:choose>
														</td>
													</c:when>
													<c:when test="${arrange.columnId eq 'CTG_CD'}">
														<td>${baseVo.ctgNm}</td>
													</c:when>
													<c:when test="${arrange.columnId eq 'READ_CNT'}">
														<td>
															<c:if test="${boardConfVo.emphasisNum <= baseVo.readCnt}"><span class="tx_blue">${baseVo.readCnt}</span></c:if>
															<c:if test="${boardConfVo.emphasisNum > baseVo.readCnt}"><span>${baseVo.readCnt}</span></c:if>
														</td>
													</c:when>
													<c:otherwise>
														<td><op:bean-util field="${arrange.columnId}" obj="${baseVo}"/></td>
													</c:otherwise>
												</c:choose>
											</c:forEach>
										</tr>
									</c:forEach>				
				
								</tbody>
							</table>
							<!-- //목록 끝 -->
							<!-- //목록 삽입 끝 -->

						</c:if>

				
						<input type="hidden" name="showSummaryYn" value="${param.showSummaryYn}" />
						<input type="hidden" name="listShowType" value="${param.listShowType}" />
				
						<input type="hidden" name="bbsCd" value="${dataVo.bbsCd}" />
						<input type="hidden" name="seq" value="${dataVo.seq}" />
						<input type="hidden" name="refSeq" value="${dataVo.refSeq}" />
						<input type="hidden" name="regPwd" value="${dataVo.regPwd}" />
				
						<input type="hidden" name="iconKey" value="" />
						<input type="hidden" name="contents" value="" />
						<input type="hidden" name="ctgCd" id="ctgCd" value="${dataVo.ctgCd}" />
						<input type="hidden" name="pageType" id="pageType" value="" />
				
						<!-- 이동옵션 -->
						<input type="hidden" name="toBbsCd" id="toBbsCd" value="" />
						<input type="hidden" name="newCtg" id="newCtg" value="-1" />
						<input type="hidden" name="delDesc" id="delDesc" value="" />
						<input type="hidden" name="isMove" id="isMove" value="" />
						<input type="hidden" name="domCd" id="domCd" value="${domCd}" />
						</form>
						 --%>
						
						<form name="dataForm" id="dataForm" method="post" action="BD_board.list.do">
						<div class="btn_sec">
							<a href="#none" onclick="jsList('${param.df_curr_page}');" class="backmove_btn">목록</a>
						</div>
						<!-- default values -->		
						<ap:include page="param/defaultParam.jsp" />
						<ap:include page="param/pagingParam.jsp" />
						<ap:include page="param/dispParam.jsp" />
						<%@include file="../common/INC_searchParam.jsp" %>						
						
						<div class="s_list">
							<ul>
								<li>
									<c:if test="${empty dataVo.nextVO}">
										<p><a><img src="/images2/sub/list_view_next_btn.png"><span>다음글</span>다음글이 없습니다.</a></p>
									</c:if>
									<c:if test="${!empty dataVo.nextVO}">
										<c:choose>
											<c:when test="${dataVo.nextVO.mgrDelYn eq 'Y'}">
												<p><a><img src="/images2/sub/list_view_next_btn.png"><span>다음글</span>[관리자에 의하여 삭제되었습니다.]</a></p>
											</c:when>
											<c:otherwise>
												<c:choose>
													<c:when test="${!empty dataVo.nextVO.moveBbsNm}">
														<p><a><img src="/images2/sub/list_view_next_btn.png"><span>다음글</span>[${dataVo.nextVO.moveBbsNm}](으)로 이동된 글입니다.</a></p>
													</c:when>
													<c:otherwise>
														<c:choose>
														<c:when test="${boardConfVo.openYn eq 'Y' && dataVo.nextVO.openYn eq 'N'}">
															<p><a><img src="/images2/sub/list_view_next_btn.png"><span>다음글</span>비공개 글 입니다.</a></p>
														</c:when>
														<c:otherwise>
															<p><a href="#none" onclick="jsView('${dataVo.nextVO.bbsCd}', '${dataVo.nextVO.seq}', '${dataVo.nextVO.regPwd}', '${dataVo.nextVO.openYn}'); return false;"><img src="/images2/sub/list_view_next_btn.png"><span>다음글</span>${dataVo.nextVO.title}</a>
														<!-- 첨부파일 갯수 -->
														<c:if test="${boardConfVo.fileYn eq 'Y' && dataVo.nextVO.fileCnt > 0}">
															<span class="t_file" title="첨부파일이 ${dataVo.nextVO.fileCnt}개 존재합니다.">(${dataVo.nextVO.fileCnt})</span>
														</c:if>
														<!-- 새글 여부 -->
														<c:if test="${boardConfVo.newArticleNum > 0}">
															<c:if test="${dataVo.nextVO.passDay <= boardConfVo.newArticleNum}">
																<img src="/resources/web/theme/default/images/icon/icon_new.gif" alt="새글"/>
															</c:if>
														</c:if>
														</p>
														</c:otherwise>
														</c:choose>
													</c:otherwise>
												</c:choose>
											</c:otherwise>
										</c:choose>
									</c:if>
								</li>
								<li>
									<c:if test="${empty dataVo.prevVO}">
										<p><a><img src="/images2/sub/list_view_prev_btn.png"><span>이전글</span>이전글이 없습니다.</a></p>
									</c:if>
									<c:if test="${!empty dataVo.prevVO}">
										<c:choose>
											<c:when test="${dataVo.prevVO.mgrDelYn eq 'Y'}">
												<p><a><img src="/images2/sub/list_view_prev_btn.png"><span>이전글</span>[관리자에 의하여 삭제되었습니다.]</a></p>
											</c:when>
											<c:otherwise>
												<c:choose>
													<c:when test="${!empty dataVo.prevVO.moveBbsNm}">
														<p><a><img src="/images2/sub/list_view_prev_btn.png"><span>이전글</span>[${dataVo.prevVO.moveBbsNm}](으)로 이동된 글입니다.</a></p>
													</c:when>
													<c:otherwise>
														<c:choose>
														<c:when test="${boardConfVo.openYn eq 'Y' && dataVo.prevVO.openYn eq 'N'}">
															<p><a><img src="/images2/sub/list_view_prev_btn.png"><span>이전글</span>비공개 글 입니다.</a></p>
														</c:when>
														<c:otherwise>
															<p><a href="#none" onclick="jsView('${dataVo.prevVO.bbsCd}', '${dataVo.prevVO.seq}', '${dataVo.prevVO.regPwd}', '${dataVo.prevVO.openYn}'); return false;"><img src="/images2/sub/list_view_prev_btn.png"><span>이전글</span>${dataVo.prevVO.title}</a>
														<!-- 첨부파일 갯수 -->
														<c:if test="${boardConfVo.fileYn eq 'Y' && dataVo.prevVO.fileCnt > 0}">
															<span class="t_file" title="첨부파일이 ${dataVo.prevVO.fileCnt}개 존재합니다.">(${dataVo.prevVO.fileCnt})</span>
														</c:if>
														<!-- 새글 여부 -->
														<c:if test="${boardConfVo.newArticleNum > 0}">
															<c:if test="${dataVo.prevVO.passDay <= boardConfVo.newArticleNum}">
																<img src="/resources/web/theme/default/images/icon/icon_new.gif" alt="새글"/>
															</c:if>
														</c:if>
														</p>
														</c:otherwise>
														</c:choose>
													</c:otherwise>
												</c:choose>
											</c:otherwise>
										</c:choose>
									</c:if>
								</li>
							</ul>
						</div>
						<input type="hidden" name="showSummaryYn" value="${param.showSummaryYn}" />
						<input type="hidden" name="listShowType" value="${param.listShowType}" />
				
						<input type="hidden" name="bbsCd" value="${dataVo.bbsCd}" />
						<input type="hidden" name="seq" value="${dataVo.seq}" />
						<input type="hidden" name="refSeq" value="${dataVo.refSeq}" />
						<input type="hidden" name="regPwd" value="${dataVo.regPwd}" />
				
						<input type="hidden" name="iconKey" value="" />
						<input type="hidden" name="contents" value="" />
						<input type="hidden" name="ctgCd" id="ctgCd" value="${dataVo.ctgCd}" />
						<input type="hidden" name="pageType" id="pageType" value="" />
				
						<!-- 이동옵션 -->
						<input type="hidden" name="toBbsCd" id="toBbsCd" value="" />
						<input type="hidden" name="newCtg" id="newCtg" value="-1" />
						<input type="hidden" name="delDesc" id="delDesc" value="" />
						<input type="hidden" name="isMove" id="isMove" value="" />
						<input type="hidden" name="domCd" id="domCd" value="${domCd}" />
					</form>

					</div>
				</div>
			</div>
		</div>
	</div>
		</div>
	<!--//content -->
	</div>
<!-- //wrap -->	
</div>
</body>
</html>