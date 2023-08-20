<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<%-- <div class="simply_list">
<!-- //글 목록 -->
	<table cellspacing="0" border="0" summary="글 내용에 대한 덧글 표시" class="table_slist">
	<caption>글에 대한 코멘트</caption>
	<colgroup>
		<col width="149" /><col />
	</colgroup>
	<tbody>
		<tr>
			<th>다음글</th>
			<td><a href="#">다음(최신)글 제목입니다.</a></td>
		</tr>
		<tr>
			<th>이전글</th>
			<td><a href="#">이전(과거)글 제목입니다.</a></td>
		</tr>
	</tbody>
	</table>
</div>
<!-- //글 목록 --> --%>

<!-- 이전/다음 목록 시작 -->
<div class="simply_list">
<!-- //글 목록 -->
	<table class="table_slist">
	<caption>글에 대한 코멘트</caption>
	<colgroup>
		<col style="width:16%" /><col />
	</colgroup>
	<tbody>
		<tr>
			<th>다음글</th>
			<td>
				<c:if test="${empty dataVo.nextVO}"><span class="tx_gray_l">다음글이 없습니다.</span></c:if>
				<c:if test="${!empty dataVo.nextVO}">
					<c:choose>
						<c:when test="${dataVo.nextVO.mgrDelYn eq 'Y'}">
							<span class="tx_blue_l">[관리자에 의하여 삭제되었습니다.]</span>
						</c:when>
						<c:otherwise>
							<c:choose>
								<c:when test="${!empty dataVo.nextVO.moveBbsNm}">
									<span class="tx_orange_u">[${dataVo.nextVO.moveBbsNm}](으)로 이동된 글입니다.</span>
								</c:when>
								<c:otherwise>
									<c:choose>
									<c:when test="${boardConfVo.openYn eq 'Y' && dataVo.nextVO.openYn eq 'N'}">
										비공개 글 입니다.
									</c:when>
									<c:otherwise>
									<a href="#none" onclick="jsView('${dataVo.nextVO.bbsCd}', '${dataVo.nextVO.seq}', '${dataVo.nextVO.regPwd}', '${dataVo.nextVO.openYn}'); return false;">${dataVo.nextVO.title}</a>
									<!-- 비공개 글 여부 -->
									<%-- <c:if test="${dataVo.nextVO.openYn eq 'N'}">
										<span class="t_lock" title="비공개 글입니다.">&nbsp;</span>
									</c:if> --%>
									<!-- 첨부파일 갯수 -->
									<c:if test="${boardConfVo.fileYn eq 'Y' && dataVo.nextVO.fileCnt > 0}">
										<span class="t_file" title="첨부파일이 ${dataVo.nextVO.fileCnt}개 존재합니다.">(${dataVo.nextVO.fileCnt})</span>
									</c:if>
									<!-- 코멘트 갯수 -->
									<%-- <c:if test="${boardConfVo.commentYn eq 'Y' && dataVo.nextVO.commentCnt > 0}">
										<span class="t_reply" title="의견글이 ${dataVo.nextVO.commentCnt}개 존재합니다.">(${dataVo.nextVO.commentCnt})</span>
									</c:if> --%>
									<!-- 새글 여부 -->
									<c:if test="${boardConfVo.newArticleNum > 0}">
										<c:if test="${dataVo.nextVO.passDay <= boardConfVo.newArticleNum}">
											<img src="/resources/web/theme/default/images/icon/icon_new.gif" alt="새글"/>
										</c:if>
									</c:if>
									</c:otherwise>
									</c:choose>
								</c:otherwise>
							</c:choose>
						</c:otherwise>
					</c:choose>
				</c:if>
			</td>
		</tr>
		<!-- 이전글 -->		
		<tr>
			<th>이전글</th>
			<td>
				<c:if test="${empty dataVo.prevVO}"><span class="tx_gray_l">이전글이 없습니다.</span></c:if>
				<c:if test="${!empty dataVo.prevVO}">
					<c:choose>
						<c:when test="${dataVo.prevVO.mgrDelYn eq 'Y'}">
							<span class="tx_blue_l">[관리자에 의하여 삭제되었습니다.]</span>
						</c:when>
						<c:otherwise>
							<c:choose>
								<c:when test="${!empty dataVo.prevVO.moveBbsNm}">
									<span class="tx_orange_u">[${dataVo.prevVO.moveBbsNm}](으)로 이동된 글입니다.</span>
								</c:when>
								<c:otherwise>
									<c:choose>
									<c:when test="${boardConfVo.openYn eq 'Y' && dataVo.prevVO.openYn eq 'N'}">
										비공개 글 입니다.
									</c:when>
									<c:otherwise>
									<a href="#none" onclick="jsView('${dataVo.prevVO.bbsCd}', '${dataVo.prevVO.seq}', '${dataVo.prevVO.regPwd}', '${dataVo.prevVO.openYn}'); return false;">${dataVo.prevVO.title}</a>
									<!-- 비공개 글 여부 -->
									<%-- <c:if test="${dataVo.prevVO.openYn eq 'N'}">
										<span class="t_lock" title="비공개 글입니다.">&nbsp;</span>
									</c:if> --%>
									<!-- 첨부파일 갯수 -->
									<c:if test="${boardConfVo.fileYn eq 'Y' && dataVo.prevVO.fileCnt > 0}">
										<span class="t_file" title="첨부파일이 ${dataVo.prevVO.fileCnt}개 존재합니다.">(${dataVo.prevVO.fileCnt})</span>
									</c:if>
									<!-- 코멘트 갯수 -->
									<%-- <c:if test="${boardConfVo.commentYn eq 'Y' && dataVo.prevVO.commentCnt > 0}">
										<span class="t_reply" title="의견글이 ${dataVo.prevVO.commentCnt}개 존재합니다.">(${dataVo.prevVO.commentCnt})</span>
									</c:if> --%>
									<!-- 새글 여부 -->
									<c:if test="${boardConfVo.newArticleNum > 0}">
										<c:if test="${dataVo.prevVO.passDay <= boardConfVo.newArticleNum}">
											<img src="/resources/web/theme/default/images/icon/icon_new.gif" alt="새글"/>
										</c:if>
									</c:if>
									</c:otherwise>
									</c:choose>
								</c:otherwise>
							</c:choose>
						</c:otherwise>
					</c:choose>
				</c:if>
			</td>
		</tr>
	</tbody>
	</table>
</div>

<!-- AS-IS domain code '1'이 아닌 경우 -->

<%-- <div class="bottom">
	<ul>
		<li class="prev"><span>이전글</span>
			<c:if test="${empty dataVo.prevVO}">이전글이 없습니다.</c:if>
			<c:if test="${!empty dataVo.prevVO}">
				<c:choose>
					<c:when test="${dataVo.prevVO.mgrDelYn eq 'Y'}">
						[관리자에 의하여 삭제되었습니다.]
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${!empty dataVo.prevVO.moveBbsNm}">
								[${dataVo.prevVO.moveBbsNm}](으)로 이동된 글입니다.
							</c:when>
							<c:otherwise>
								<a href="#none" onclick="jsView('${dataVo.prevVO.bbsCd}', '${dataVo.prevVO.seq}', '${dataVo.prevVO.regPwd}', '${dataVo.prevVO.openYn}'); return false;">${dataVo.prevVO.title}</a>
								<!-- 새글 여부 -->
								<c:if test="${boardConfVo.newArticleNum > 0}">
									<c:if test="${dataVo.prevVO.passDay <= boardConfVo.newArticleNum}">
										<img src="/resources/web/theme/default/images/icon/icon_new.gif" alt="새글"/>
									</c:if>
								</c:if>
							</c:otherwise>
						</c:choose>
					</c:otherwise>
				</c:choose>
			</c:if>
		</li>
		<li class="next"><span>다음글</span>
			<c:if test="${empty dataVo.nextVO}">다음글이 없습니다.</c:if>
			<c:if test="${!empty dataVo.nextVO}">
				<c:choose>
					<c:when test="${dataVo.nextVO.mgrDelYn eq 'Y'}">
						[관리자에 의하여 삭제되었습니다.]
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${!empty dataVo.nextVO.moveBbsNm}">
								[${dataVo.nextVO.moveBbsNm}](으)로 이동된 글입니다.
							</c:when>
							<c:otherwise>
								<a href="#none" onclick="jsView('${dataVo.nextVO.bbsCd}', '${dataVo.nextVO.seq}', '${dataVo.nextVO.regPwd}', '${dataVo.nextVO.openYn}'); return false;">${dataVo.nextVO.title}</a>
								<!-- 새글 여부 -->
								<c:if test="${boardConfVo.newArticleNum > 0}">
									<c:if test="${dataVo.nextVO.passDay <= boardConfVo.newArticleNum}">
										<img src="/resources/web/theme/default/images/icon/icon_new.gif" alt="새글"/>
									</c:if>
								</c:if>
							</c:otherwise>
						</c:choose>
					</c:otherwise>
				</c:choose>
			</c:if>
		</li>
	</ul>
</div>	 --%>
<!-- 이전/다음 목록 끝 -->