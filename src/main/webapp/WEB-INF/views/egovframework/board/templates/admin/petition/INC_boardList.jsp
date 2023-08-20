<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<ap:globalConst />
<%@ page import="egovframework.board.config.BoardConfConstant" %>
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
	
	<script>
		// 회원정보 팝업
		var fn_userInfo = function(regId){
			$.colorbox({
				title : "회원정보",
				href : "<c:url value='/PGMY0070.do?df_method_nm=popUserInfo&ad_regId=" + regId + "' />",
				width : "700",
				height : "400",
				overlayClose : false,
				escKey : false,
				iframe : true
			});
		};
	</script>
		
<%-- 항목 표시 수 --%>
<c:set var="thCnt" value="0" />

<!--// 리스트 -->
<div class="list_zone">

	<table>
		<caption class="hidden">기본게시판 목록</caption>
		<colgroup>
			<!-- 삭제/이동 등을 위한 체크박스 (목록 필수) -->
			<c:if test="${pageType eq 'LIST'}">
				<c:set var="thCnt" value="${thCnt + 1}" />
				<col style="width:6%" />
			</c:if>
	
			<!-- 순번(필수) -->
			<c:set var="thCnt" value="${thCnt + 1}" />
			<col style="width:6%" />
	
			<!-- 목록 배치에서 설정한 항목 배치 -->
			<c:forEach items="${boardConfVo.listArrange}" var="arrange" varStatus="status">
				<c:set var="thCnt" value="${thCnt + 1}" />
				<c:if test="${arrange.columnId eq 'TITLE'}"><col style="width:*" /></c:if>
				<c:if test="${arrange.columnId != 'TITLE'}"><col style="width:10%" /></c:if>
			</c:forEach>
	
			<!-- 필수(작성자, 상태, 처리자) -->
			<c:set var="thCnt" value="${thCnt + 3}" />
			<col style="width:7%" />
			<col style="width:7%" />
			<col style="width:7%" />
		</colgroup>
		<thead>
			<tr>
				<!-- 삭제/이동 등을 위한 체크박스 (목록 필수) -->
				<c:if test="${pageType eq 'LIST'}">
					<th><input type="checkbox" value="Y" name="chk-all" id="chk-all" /></th>
				</c:if>
	
				<!-- 순번(필수) -->
				<th id="th-ROWNUM"><span class="sort cs_pointer" id="ROWNUM">번호</span></th>
	
				<!-- 목록 배치에서 설정한 항목 배치 -->
				<c:forEach items="${boardConfVo.listArrange}" var="arrange" varStatus="status">
					<th id="th-${arrange.columnId}"><span class="sort cs_pointer" id="${arrange.columnId}">${arrange.columnNm}</span></th>
				</c:forEach>
	
				<!-- 필수(작성자, 상태, 처리자) -->
				<th scope="col">작성자</th>
                <th scope="col">상태</th>
                <th scope="col">처리자</th>
			</tr>
		</thead>
		<tbody>
			<!-- 공지 목록  -->
			<c:if test="${boardConfVo.noticeYn eq 'Y'}">
	
				<c:forEach items="${noticeList}" var="noticeVo" varStatus="status">
	
					<c:set var="trClass" value="bg_blue" />
					<c:if test="${(pageType == 'VIEW') && (dataVo.seq == noticeVo.seq)}">
						<c:set var="trClass" value="tr-sel" />
					</c:if>
	
					<tr class="${trClass}">
						<!-- 삭제/이동 등을 위한 체크박스 (목록 필수) -->
						<c:if test="${pageType eq 'LIST'}">
							<td>
								<input type="checkbox" name="seqs" value="${noticeVo.seq}" class="checkbox" />
								<input type="hidden" id="noticeYn_${noticeVo.seq}" name="chkNoticeYn" value="${noticeVo.noticeYn}" />
							</td>
						</c:if>
	
						<!-- 순번(필수) -->
						<td>
							<c:choose>
								<c:when test="${(pageType eq 'VIEW') && (noticeVo.seq eq dataVo.seq)}">
									<img src="<c:url value='/resources/openworks/theme/default/images/icon/icon_current.png' />" ></img>
								</c:when>
								<c:otherwise>
									<img src="<c:url value='/resources/openworks/theme/default/images/icon/icon_notice2.gif' />" ></img>
								</c:otherwise>
							</c:choose>
						</td>
	
						<!-- 목록 배치에서 설정한 항목 배치 -->					
						<c:forEach items="${boardConfVo.listArrange}" var="arrange" varStatus="arrStatus">
							<c:choose>
								<c:when test="${arrange.columnId eq 'TITLE'}">
									<td class="tw">
										<a href="#" rel="#titleNoticeSummary${status.count}" class="contentTip"
											onclick="jsView('${noticeVo.bbsCd}', '${noticeVo.seq}', '${noticeVo.regPwd}', '${noticeVo.openYn}'); return false;">
											${noticeVo.title}
											<c:if test="${noticeVo.titleLength > (boardConfVo.cutTitleNum * 2)}">...</c:if>
											<c:if test="${noticeVo.fileCnt > 0}">
												<span title="첨부파일이 ${noticeVo.fileCnt}개 존재합니다.">
												<img src="<c:url value="/images/acm/icon_file.png" />" alt="파일" />(${noticeVo.fileCnt})</span>
											</c:if>
										</a>
	
										<c:if test="${noticeVo.mgrDelYn eq 'Y'}">
											<span class="tx_orange_u mar_l5">* 관리자 삭제글</span>
										</c:if>
	
										<c:if test="${!empty noticeVo.moveBbsNm}">
											<span class="tx_orange_u mar_l5">* [${noticeVo.moveBbsNm}](으)로 이동된 글</span>
										</c:if>
	
										<%-- <c:if test="${noticeVo.openYn != 'Y'}"><span class="t_lock" title="비공개 글입니다.">&nbsp;</span></c:if> --%>
	
										<%-- <c:choose>
											<c:when test="${(boardConfVo.downYn eq 'Y') && (noticeVo.fileCnt > 0) && (noticeVo.openYn eq 'Y')}">
												<a href="/component/file/zipdownload.do?fileSeq=${noticeVo.fileSeq}" title="첨부파일이 ${noticeVo.fileCnt}개 존재합니다.">
												<img src="<c:url value="/images/ucm/icon_file.png" />" alt="파일" />(${noticeVo.fileCnt})</a>
											</c:when>
											<c:when test="${noticeVo.fileCnt > 0}">
												<span title="첨부파일이 ${noticeVo.fileCnt}개 존재합니다.">
												<img src="<c:url value="/images/ucm/icon_file.png" />" alt="파일" />(${noticeVo.fileCnt})</span>
											</c:when>
										</c:choose> --%>
	
										<%-- <c:if test="${boardConfVo.commentYn eq 'Y' && noticeVo.commentCnt > 0}">
											<span class="t_reply" title="의견글이 ${noticeVo.commentCnt}개 존재합니다.">(${noticeVo.commentCnt})</span>
										</c:if> --%>
	
										<c:if test="${boardConfVo.newArticleNum > 0}">
											<c:if test="${noticeVo.passDay <= boardConfVo.newArticleNum}">
												<img src="/resources/openworks/theme/default/images/icon/icon_new.gif" alt="새글"/>
											</c:if>
										</c:if>
	
										<%-- <div id="titleNoticeSummary${status.count}" class="tx_blue_s"><c:out value="${noticeVo.summary}" escapeXml="true" /></div> --%>
									</td>
								</c:when>
								<c:when test="${arrange.columnId eq 'CTG_CD'}">
									<td><span class="label_notice">공지</span></td>
								</c:when>
								<c:when test="${arrange.columnId eq 'READ_CNT'}">
									<td>
										<c:if test="${boardConfVo.emphasisNum <= noticeVo.readCnt}"><span class="tx_blue">${noticeVo.readCnt}</span></c:if>
										<c:if test="${boardConfVo.emphasisNum > noticeVo.readCnt}"><span>${noticeVo.readCnt}</span></c:if>
									</td>
								</c:when>
								<c:when test="${arrange.columnId eq 'OPEN_YN'}">
									<td>
										<c:if test="${noticeVo.openYn eq 'Y' }" >공개</c:if>
										<c:if test="${noticeVo.openYn eq 'N' }" >비공개</c:if>
									</td>
								</c:when>
								<c:otherwise>
									<td><ap:bean-util field="${arrange.columnId}" obj="${noticeVo}"/></td>
								</c:otherwise>
							</c:choose>
						</c:forEach>
	
						<!-- 상태(필수) -->
						<td class="lr_none">&nbsp;</td>
					</tr>
				</c:forEach>
			</c:if>
	
			<!-- 공지 제외 게시물 목록 -->
			<c:set var="index" value="${pager.indexNo}"/>
			<c:forEach items="${boardList}" var="baseVo" varStatus="status">
				<tr>
					<!-- 삭제/이동 등을 위한 체크박스 (목록 필수) -->
					<c:if test="${pageType eq 'LIST'}">
						<td><input type="checkbox" value="${baseVo.seq}" name="seqs" class="checkbox" /></td>
					</c:if>
	
					<!-- 순번(필수) -->
					<td class="tac">
						<c:choose>
							<c:when test="${(pageType eq 'VIEW') && (baseVo.seq eq dataVo.seq)}">
								<img src="<c:url value='/resources/openworks/theme/default/images/icon/icon_current.png' />" ></img>
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
								<td class="tw">
									<a href="#" onclick="jsView('${baseVo.bbsCd}', '${baseVo.seq}', '${baseVo.regPwd}', '${baseVo.openYn}'); return false;">
										${baseVo.title}
										<c:if test="${baseVo.titleLength > (boardConfVo.cutTitleNum * 2)}">...</c:if>
										<c:if test="${baseVo.fileCnt > 0}">
											<span title="첨부파일이 ${baseVo.fileCnt}개 존재합니다.">
											<img src="<c:url value="/images/acm/icon_file.png" />" alt="파일" />(${baseVo.fileCnt})</span>
										</c:if>
									</a>
	
									<c:if test="${baseVo.mgrDelYn eq 'Y'}">
										<span class="tx_orange_u mar_l5">* 관리자 삭제글</span>
									</c:if>
	
									<c:if test="${!empty baseVo.moveBbsNm}">
										<span class="tx_orange_u mar_l5">* [${baseVo.moveBbsNm}](으)로 이동된 글</span>
									</c:if>
	
									<%-- <c:if test="${baseVo.openYn != 'Y'}"><span class="t_lock" title="비공개 글입니다.">&nbsp;</span></c:if> --%>
	
									<%-- <c:choose>
										<c:when test="${(boardConfVo.downYn eq 'Y') && (baseVo.fileCnt > 0) && (baseVo.openYn eq 'Y')}">
											<a href="/component/file/zipdownload.do?fileSeq=${baseVo.fileSeq}" title="첨부파일이 ${baseVo.fileCnt}개 존재합니다.">
											<img src="<c:url value="/images/ucm/icon_file.png" />" alt="파일" />(${baseVo.fileCnt})</a>
										</c:when>
										<c:when test="${baseVo.fileCnt > 0}">
											<span title="첨부파일이 ${baseVo.fileCnt}개 존재합니다.">
											<img src="<c:url value="/images/ucm/icon_file.png" />" alt="파일" />(${baseVo.fileCnt})</span>
										</c:when>
									</c:choose> --%>
	
									<%-- <c:if test="${boardConfVo.commentYn eq 'Y' && baseVo.commentCnt > 0}">
										<span class="t_reply" title="댓글이 ${baseVo.commentCnt}개 존재합니다.">(${baseVo.commentCnt})</span>
									</c:if> --%>
	
									<c:if test="${boardConfVo.newArticleNum > 0}">
										<c:if test="${baseVo.passDay <= boardConfVo.newArticleNum}">
									   		<img src="/resources/openworks/theme/default/images/icon/icon_new.gif" alt="새글"/>
									   	</c:if>
									</c:if>
	
									<%-- <c:if test="${baseVo.openYn eq 'Y'}">
										<div id="titleSummary${status.count}" class="tx_blue_s"><c:out value="${baseVo.summary}" escapeXml="true" /></div>
									</c:if>
	
									<c:if test="${baseVo.openYn eq 'N'}">
										<div id="titleSummary${status.count}" class="tx_blue_s" >* 비밀글 입니다. *</div>
									</c:if> --%>
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
							<c:when test="${arrange.columnId eq 'OPEN_YN'}">
								<td>
									<c:if test="${baseVo.openYn eq 'Y' }" >공개</c:if>
									<c:if test="${baseVo.openYn eq 'N' }" >비공개</c:if>
								</td>
							</c:when>
							<c:otherwise>
								<td><ap:bean-util field="${arrange.columnId}" obj="${baseVo}"/></td>
							</c:otherwise>
						</c:choose>
					</c:forEach>
	
					<!-- 작성자(필수) -->
					<td>
						<a href="#none" onclick="fn_userInfo('${baseVo.regId}')">${baseVo.regNm }</a>
					</td>
					<!-- 상태(필수) -->
					<td>						
						<c:choose>
							<c:when test="${baseVo.extColumn1 eq 'A'}">신청</c:when>
							<c:when test="${baseVo.extColumn1 eq 'B'}">접수</c:when>
							<c:when test="${baseVo.extColumn1 eq 'C'}">답변중</c:when>
							<c:when test="${baseVo.extColumn1 eq 'D'}">답변완료</c:when>
							<c:otherwise>&nbsp;</c:otherwise>
						</c:choose>
					</td>
					<!-- 처리자(필수) -->
					<td>
						${baseVo.mgrNm }
					</td>
				</tr>
			</c:forEach>				
	
		</tbody>
	</table>
	<!-- //리스트 -->
</div>	