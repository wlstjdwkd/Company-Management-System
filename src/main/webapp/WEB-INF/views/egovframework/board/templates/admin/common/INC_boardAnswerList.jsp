<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<c:set var="userInfoVo" value="${sessionScope[SESSION_USERINFO_NAME]}" />

<input type="hidden" id="answer_curr_page" name="answer_curr_page" value="<c:out value="${param.answer_curr_page}" default="1" />" />
<input type="hidden" id="answer_row_per_page" name="answer_row_per_page" value="<c:out value="${param.answer_row_per_page}" default="5" />" />

<table class="table_basic" cellspacing="0" border="0" summary="댓글 목록" style="margin-bottom:10px;">
	<caption>댓글 목록</caption>
	<colgroup>
		<col style="width:15%" />
		<col style="width:*" />
		<col style="width:25%" />
	</colgroup>
	<thead>
		<tr>
			<th colspan="3" style="text-align:center;">댓  글</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="row" items="${boardAnswerList}">
			<tr>
				<td class="right_line">${row.REG_NM}</td>
				<td class="right_line">
					${row.ANSWER_CN}
					<a class="btn_in_gray_admin" href="#" onclick="boardAnswerSeqDelete('${row.ANSWER_SEQ}');"><span>삭제</span></a>
				</td>
				<td><fmt:formatDate value="${row.REG_DT}" pattern="yyyy-MM-dd a HH:mm:ss" /></td>
			</tr>
		</c:forEach>
	</tbody>
</table>

<!-- 페이징 -->
<ap:pager pager="${boardAnswerPager}" script="boardAnswerList" />
<!-- //페이징 -->