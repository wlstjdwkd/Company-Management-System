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
	
	<ap:jsTag type="web" items="jquery,validate,notice,msgBox,colorbox,multifile,mask" />
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
		
       	$("#titleNm1").html("마이페이지");
       	$("#titleNm2").html("마이페이지");
       	$("#subNm").html("묻고답하기");

	 });
	</script>
	<!-- 사용자 스크립트 끝 -->
</head>
<body>
<div id="wrap">
	<div class="s_cont" id="s_cont">
		<div class="s_tit s_tit05">
			<h1 id="titleNm1"></h1>
		</div>
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit tit5" id="titleNm2"></h2>
				<ul>
				</ul>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}"  />
				</div>
				<div class="r_cont">
					<div class="list_view">
						<div class="view_tit">
							<h3>
								<span>
									<c:choose>
										<c:when test="${dataVo.extColumn1 eq 'A'}">신청</c:when>
										<c:when test="${dataVo.extColumn1 eq 'B'}">접수</c:when>
										<c:when test="${dataVo.extColumn1 eq 'C'}">답변중</c:when>
										<c:when test="${dataVo.extColumn1 eq 'D'}">답변완료</c:when>
										<c:otherwise>&nbsp;</c:otherwise>
									</c:choose>
								</span>${dataVo.title}
							</h3>
							<p>${dataVo.regNm }&nbsp;&nbsp;|&nbsp;&nbsp;${fn:substring(dataVo.regDt,0,10)}</p>
						</div>
						<div class="view_cont" style="padding: 24px 8px 24px">
							<p>
								<c:if test="${boardConfVo.usrEditorYn eq 'Y'}" >
									<td colspan="6" class="cont" id="emailCnHtml"></td>
                    				<input type="hidden" id="email_cn_html" value="${dataVo.contents }" />
                    				<script type="text/javascript">$("#emailCnHtml").html($("#email_cn_html").val());</script>
                    			</c:if>
								<c:if test="${boardConfVo.usrEditorYn eq 'N'}" >
                        			<td colspan="6" class="cont">
										${dataVo.contents }
									</td>
                   				</c:if>	
							</p>
						</div>
						<c:if test="${!empty dataVo.fileList}">
						<div class="file_down">
								<span>첨부</span>									
									<c:choose>
										<c:when test="${fn:length(dataVo.fileList) > 0}">
											<p>	
												<c:forEach items="${dataVo.fileList}" var="fileVo">																								
													<a href="PGCM0040.do?df_method_nm=updateFileDown&id=${fileVo.fileId}" title="${fileVo.fileDesc}">
														<img src="/images2/sub/list_file_ico.png">${fileVo.localNm}</a> (download ${fileVo.downCnt}, ${fileVo.fileSize}, ${fileVo.fileType})
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
						<c:if test="${dataVo.extColumn1 eq 'D'}" >	
						<div class="answer_sec">		
								<p class="answer_tit">답변내용 입니다.</p>
								<p>
									${dataVo.replyContents}
								</p>
								<!-- 첨부파일 -->
								<c:if test="${!empty dataVo.ansFileList}">
									<div class="file_down">
										<span>첨부</span>									
											<c:choose>
												<c:when test="${fn:length(dataVo.ansFileList) > 0}">
													<p>	
														<c:forEach items="${dataVo.ansFileList}" var="fileVo">																								
															<a href="PGCM0040.do?df_method_nm=updateFileDown&id=${fileVo.fileId}" title="${fileVo.fileDesc}">
																<img src="/images2/sub/list_file_ico.png">${fileVo.localNm}</a> (download ${fileVo.downCnt}, ${fileVo.fileSize}, ${fileVo.fileType})
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
							</div>
						</c:if>
						<div class="btn_sec">
							<a class="backmove_btn" href="#" onclick="jsList('${param.df_curr_page}');"><span>목록</span></a>
							<c:if test="${dataVo.extColumn1 eq 'A' or dataVo.extColumn1 eq 'B'}" >
								<a class="backmove_btn" href="#" onclick="jsUpdateForm('UPDATE');"><span>수정</span></a>
								<a class="backmove_btn" href="#" onclick="jsDelete();"><span>삭제</span></a>
							</c:if>
						</div>

						<form name="dataForm" id="dataForm" method="post">
							<!-- default values -->		
							<ap:include page="param/defaultParam.jsp" />
							<ap:include page="param/pagingParam.jsp" />
							<ap:include page="param/dispParam.jsp" />
					
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
							
							<!--  검색유지 -->
						</form>
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
															<p><span class="t_file" title="첨부파일이 ${dataVo.prevVO.fileCnt}개 존재합니다.">(${dataVo.prevVO.fileCnt})</span></p>
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
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>