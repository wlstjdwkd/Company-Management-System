<%-- <%@ page contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.openworks.kr/jsp/jstl" prefix="op"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="f" %>
<%@ taglib uri="http://www.openworks.kr/jsp/validate" prefix="valid"%>
<%@ page import="zes.openworks.intra.boardconf.BoardConfConstant" %>

<op:jsTag type="spi" items="validate" /> --%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="f" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<%@ page import="egovframework.board.config.BoardConfConstant" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />

<ap:jsTag type="web" items="jquery,cookie,form,notice,ui,validate" />
<ap:jsTag type="tech" items="msg,util,acm" />
<ap:jsTag type="egovframework" items="boardconf" />

<script type="text/javascript">
	var confTabz;

	$().ready(function(){		
		
		// 등록버튼
		$("#btn_submit").click(function(){
			if(!$('#extensionConfigForm').valid()){
				jsWarningBox(Message.msg.checkEssVal);
				return;
			}
			
			$("#df_method_nm").val("updateBoardExtConfModifyAction");
			dataString = $("#extensionConfigForm").serialize();
			$.ajax({
				type: "POST",
				url: "PGMS0080.do",
				data: dataString,
				dataType: "json",
				success: function(response){
				    try {
						if(eval(response)) {
							jsSuccessBox(Message.msg.processOk);
						} else {
							jsErrorBox(Message.msg.processFail);
						}
					} catch (e) {
						// 시스템 오류 발생시 처리 구간
						jsSysErrorBox(response, e);
						return;
					}
					changeFlag = false;
					jsReloadTab();
				}
			});
		});
		
		// 취소버튼
		$("#btn_reset").click(function(){
			changeFlag=false;
			document.extensionConfigForm.reset();
		});
	});
</script>

<!-- 캡션 영역 시작 -->
<div class="bbs-caption">
	<div class="caption-right"> 
		<span id="authResult" class="result"></span>
	</div>
</div>
<!-- 캡션 영역 끝 -->

<form id="extensionConfigForm" name="extensionConfigForm" method="post">

	<input type="hidden" name="bbsCd" value="${param.bbsCd}" />
	<ap:include page="param/defaultParam.jsp" />

	<!-- 컬럼 목록 상세보기 시작 -->
	<fieldset>	
		<legend>컬럼설정</legend>
		<table class="table_basic" cellspacing="0" border="0" summary="컬럼설정 정보를 표시" >
			<caption>컬럼설정</caption>
			<colgroup>
				<col width="10%" />
				<col width="15%" />
				<col />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
			</colgroup>
			<tbody>
				<tr>
					<th>컬럼</th>
					<th>명칭</th>
					<th>설명</th>
					<th>입력유형</th>
					<th>검색</th>
					<th>검색유형</th>
					<th>필수</th>
					<th>사용</th>
				</tr>
				<c:forEach items="${dataList}" var="extensionVo" varStatus="status">
					<tr>
						<td class="tl">
							${extensionVo.columnId}
							<input type="hidden" id="columnId" name="extList[${status.index }].columnId" value="${extensionVo.columnId}" />
						</td>
						<td class="tl">
							<input type="text" id="columnNm" name="extList[${status.index }].columnNm" value="${extensionVo.columnNm}" class="w120" onchange="jsChkValueChange('text', 'extList[${status.index }].columnNm', '${extensionVo.columnNm}');" />
							<valid:msg name="columnNm" />
						</td>
						<td class="tl">
							<input type="text" id="columnComment" name="extList[${status.index }].columnComment" value="${extensionVo.columnComment}" class="w180" onchange="jsChkValueChange('text', 'extList[${status.index }].columnComment', '${extensionVo.columnComment}');" />
						</td>
						<td>
							<select id="columnType" name="extList[${status.index }].columnType" onchange="jsChkValueChange('select', 'extList[${status.index }].columnType', '${extensionVo.columnType}');">
								<option value="" selected="selected"></option>
								<option value="TEXT"<c:if test="${extensionVo.columnType eq 'TEXT'}"> selected="selected"</c:if>>한줄</option>
								<option value="TEXTAREA"<c:if test="${extensionVo.columnType eq 'TEXTAREA'}"> selected="selected"</c:if>>여러줄</option>
								<option value="EMAIL"<c:if test="${extensionVo.columnType eq 'EMAIL'}"> selected="selected"</c:if>>이메일</option>
								<option value="DATE"<c:if test="${extensionVo.columnType eq 'DATE'}"> selected="selected"</c:if>>날짜</option>
							</select>
						</td>
						<td>
							<select id="searchYn" name="extList[${status.index }].searchYn" onchange="jsChkValueChange('select', 'extList[${status.index }].searchYn', '${extensionVo.searchYn}');">
								<option value="Y"<c:if test="${extensionVo.searchYn eq 'Y' or empty extensionVo.searchYn}"> selected="selected"</c:if>>예</option>
								<option value="N"<c:if test="${extensionVo.searchYn eq 'N'}"> selected="selected"</c:if>>아니오</option>
							</select>
						</td>
						<td>
							<select id="searchType" name="extList[${status.index }].searchType" onchange="jsChkValueChange('select', 'extList[${status.index }].searchType', '${extensionVo.searchType}');">
								<option value=""></option>
								<c:forEach items="${dataVo}" var="searchType">
									<option value="${searchType.code}"<c:if test="${searchType.code eq extensionVo.searchType}"> selected="selected"</c:if>>${searchType.codeNm}</option>
								</c:forEach>
							</select>
						</td>
						<td>
							<select id="requireYn" name="extList[${status.index }].requireYn" onchange="jsChkValueChange('select', 'extList[${status.index }].requireYn', '${extensionVo.requireYn}');">
								<option value="Y"<c:if test="${extensionVo.requireYn eq 'Y' or empty extensionVo.requireYn}"> selected="selected"</c:if>>예</option>
								<option value="N"<c:if test="${extensionVo.requireYn eq 'N'}"> selected="selected"</c:if>>아니오</option>
							</select>
						</td>
						<td>
							<select id="useYn" name="extList[${status.index }].useYn" onchange="jsChkValueChange('select', 'extList[${status.index }].useYn', '${extensionVo.useYn}');">
								<option value="Y"<c:if test="${extensionVo.useYn eq 'Y' or empty extensionVo.useYn}"> selected="selected"</c:if>>예</option>
								<option value="N"<c:if test="${extensionVo.useYn eq 'N'}"> selected="selected"</c:if>>아니오</option>
							</select>
						</td>
					</tr>
			   </c:forEach>
			</tbody>
		</table>
	</fieldset>
	<!-- 게시판 목록 상세보기 끝 -->
	
	 <!-- 버튼 -->
	<div class="btn_page_last">
		<a href="#none" class="btn_page_admin" id="btn_submit"><span>등록</span></a>
		<a href="#none" class="btn_page_admin" id="btn_reset"><span>취소</span></a>
		<a href="#none" class="btn_page_admin" onclick="jsList();"><span>목록</span></a>
	</div>
	<!-- //버튼 -->

</form>
