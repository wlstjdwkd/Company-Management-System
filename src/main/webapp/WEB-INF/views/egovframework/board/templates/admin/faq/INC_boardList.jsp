<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<%@ page import="egovframework.board.config.BoardConfConstant" %>
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />

<%-- 항목 표시 수 --%>
<c:set var="thCnt" value="0" />

<!--// 리스트 -->
<div class="list_zone">
	<table cellspacing="0" border="0" class="tbl_faq" summary="기본게시판 목록으로 순번,분류,제목,작성자,작성일 등의 조회 정보를 제공합니다.">
		<caption class="hidden">기본게시판 목록</caption>
		<colgroup>
			<!-- 삭제/이동 등을 위한 체크박스 (목록 필수) -->
			<c:if test="${pageType eq 'LIST'}">
				<c:set var="thCnt" value="${thCnt + 1}" />
				<col width="6%" />
			</c:if>
	
			<!-- 순번(필수) -->
			<c:set var="thCnt" value="${thCnt + 1}" />
			<col width="6%" />
	
			<!-- 목록 배치에서 설정한 항목 배치 -->
			<c:forEach items="${boardConfVo.listArrange}" var="arrange" varStatus="status">
				<c:set var="thCnt" value="${thCnt + 1}" />
				<c:if test="${arrange.columnId eq 'TITLE'}"><col width="*" /></c:if>
				<c:if test="${arrange.columnId != 'TITLE'}"><col width="10%" /></c:if>
			</c:forEach>
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
					<th id="th-${arrange.columnId}"<c:if test="${status.last}"> class="lr_none"</c:if>><span class="sort cs_pointer" id="${arrange.columnId}">${arrange.columnNm}</span></th>
				</c:forEach>
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
										<a href="#" rel="#titleNoticeSummary${status.count}" class="content_view">${noticeVo.title}
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
									<td<c:if test="${arrStatus.last}"> class="lr_none"</c:if>><span class="label_notice">공지</span></td>
								</c:when>
								<c:when test="${arrange.columnId eq 'READ_CNT'}">
									<td<c:if test="${arrStatus.last}"> class="lr_none"</c:if>>
										<c:if test="${boardConfVo.emphasisNum <= noticeVo.readCnt}"><span class="tx_blue">${noticeVo.readCnt}</span></c:if>
										<c:if test="${boardConfVo.emphasisNum > noticeVo.readCnt}"><span>${noticeVo.readCnt}</span></c:if>
									</td>
								</c:when>
								<c:when test="${arrange.columnId eq 'OPEN_YN'}">
									<td>
										<c:if test="${baseVo.openYn eq 'Y' }" >공개</c:if>
										<c:if test="${baseVo.openYn eq 'N' }" >비공개</c:if>
									</td>
								</c:when>
								<c:otherwise>
									<td<c:if test="${arrStatus.last}"> class="lr_none"</c:if>><ap:bean-util field="${arrange.columnId}" obj="${noticeVo}"/></td>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</tr>
					<tr id="${noticeVo.seq}" style="display:none;">
						<td class="faq_left"></td>
						<td colspan="${thCnt - 1}" class="faq">
							<c:if test="${boardConfVo.mgrEditorYn eq 'Y'}" >
								<span id="emailCnHtml_${noticeVo.seq}"></span>
								<input type="hidden" id="email_cn_html_${noticeVo.seq}" value="${noticeVo.contents}" />
								<script type="text/javascript">$("#emailCnHtml_${noticeVo.seq}").html($("#email_cn_html_${noticeVo.seq}").val());</script>
							</c:if>
							<c:if test="${boardConfVo.mgrEditorYn eq 'N'}" >
								${noticeVo.contents}
							</c:if>
							<div class="float_r">
								<button type="button" class="s_blue mar_l5" onclick="jsUpdateForm('UPDATE', '${noticeVo.seq}');">수정</button>
								<button type="button" class="s_blue mar_l5" onclick="jsDelete('${noticeVo.seq}');">삭제</button>
							</div>
						</td>
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
									<a href="#" rel="#contents_${baseVo.seq}" class="content_view">${baseVo.title}
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
								</td>
							</c:when>
							<c:when test="${arrange.columnId eq 'CTG_CD'}">
								<td class="tac">${baseVo.ctgNm}</td>
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
								<td<c:if test="${arrStatus.last}"> class="lr_none"</c:if>><ap:bean-util field="${arrange.columnId}" obj="${baseVo}"/></td>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</tr>
				<%-- <tr id="contents_${baseVo.seq}" class="viewtd">
					<td class="faq_left"></td>
					<td colspan="${thCnt - 1}" class="faq">
						${baseVo.contents}
						<div class="float_r">
							<button type="button" class="s_blue mar_l5" onclick="jsUpdateForm('UPDATE', '${baseVo.seq}');">수정</button>
							<button type="button" class="s_blue mar_l5" onclick="jsDelete('${baseVo.seq}');">삭제</button>
						</div>
					</td>
				</tr> --%>
				<tr id="contents_${baseVo.seq}" class="viewtd">
                    <td colspan="${thCnt}">
                        <div class="listshow" style="display: block;">
                        	<c:if test="${boardConfVo.mgrEditorYn eq 'Y'}" >
								<p class="board_open" id="emailCnHtml_${baseVo.seq}"></p>
								<input type="hidden" id="email_cn_html_${baseVo.seq}" value="${baseVo.contents}" />
								<script type="text/javascript">$("#emailCnHtml_${baseVo.seq}").html($("#email_cn_html_${baseVo.seq}").val());</script>
							</c:if>
                        	<c:if test="${boardConfVo.mgrEditorYn eq 'N'}" >
								<p class="board_open">${baseVo.contents}</p>
							</c:if>
                            <div class="btn_inner fr">
                            	<a href="#" class="btn_in_gray" onclick="jsDelete('${baseVo.seq}');"><span>삭제</span></a>
                            	<a href="#" class="btn_in_gray" onclick="jsUpdateForm('UPDATE', '${baseVo.seq}');"><span>수정</span></a>
                            </div>
                        </div>                                       
                    </td>
                </tr>
			</c:forEach>
	
			<%-- <c:if test="${empty pager.list}">
				<op:no-data obj="${pager}" colspan="${thCnt}" />
			</c:if> --%>
	
		</tbody>
	</table>
</div>
<!-- //리스트 -->