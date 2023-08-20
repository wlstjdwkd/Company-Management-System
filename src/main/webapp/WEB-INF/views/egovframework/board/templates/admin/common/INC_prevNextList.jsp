<%-- <%@ page contentType="text/html;charset=UTF-8" %> --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- 이전/다음 목록 시작 -->

<div class="block2">
	<!-- //글 목록 -->
	<table class="table_basic">
	    <caption>
	    글에 대한 코멘트
	    </caption>
	    <colgroup>
	    <col style="width:100" />
	    <col />
	    </colgroup>
	    <tbody>
	        <tr>
	            <th>다음글</th>
				<td>
					<c:if test="${empty dataVo.nextVO}"><span class="tx_gray_l">다음글이 없습니다.</span></c:if>
					<c:if test="${!empty dataVo.nextVO}">
						<a href="#" onclick="jsView('${dataVo.nextVO.bbsCd}', '${dataVo.nextVO.seq}', '${dataVo.nextVO.regPwd}', '${dataVo.nextVO.openYn}'); return false;">${dataVo.nextVO.title}</a>
						<c:if test="${dataVo.nextVO.mgrDelYn eq 'Y'}">
							<span class="tx_orange_u">* 관리자 삭제글</span>
						</c:if>
						<c:if test="${!empty dataVo.nextVO.moveBbsNm}">
							<span class="tx_orange_u">* [${dataVo.nextVO.moveBbsNm}](으)로 이동된 글</span>
						</c:if>
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
					</c:if>
				</td>
			</tr>	

			<tr>
            	<th>이전글</th>
            	<td>
					<c:if test="${empty dataVo.prevVO}"><span class="tx_gray_l">이전글이 없습니다.</span></c:if>
					<c:if test="${!empty dataVo.prevVO}">
						<a href="#" onclick="jsView('${dataVo.prevVO.bbsCd}', '${dataVo.prevVO.seq}', '${dataVo.prevVO.regPwd}', '${dataVo.prevVO.openYn}'); return false;">${dataVo.prevVO.title}</a>
						<c:if test="${dataVo.prevVO.mgrDelYn eq 'Y'}">
							<span class="tx_orange_u">* 관리자 삭제글</span>
						</c:if>
						<c:if test="${!empty dataVo.prevVO.moveBbsNm}">
							<span class="tx_orange_u">* [${dataVo.prevVO.moveBbsNm}](으)로 이동된 글</span>
						</c:if>
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
					</c:if>
				</td>
			</tr>		
		</tbody>
	</table>
</div>
<!-- 이전/다음 목록 끝 -->