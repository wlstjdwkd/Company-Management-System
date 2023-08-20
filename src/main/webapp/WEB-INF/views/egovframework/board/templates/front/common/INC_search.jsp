<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- 검색 영역 시작 -->
<%-- <div <c:choose><c:when test="${domCd == 30}"><c:if test="${param.bbsCd != 1014}">class="sch_area mT20"</c:if><c:if test="${param.bbsCd == 1014}">class="search mT20"</c:if></c:when><c:otherwise>class="search_top taR mT20"</c:otherwise></c:choose> id="Search_Menu_div"> --%>
<div class="search_top">
	<div class="inner">
		<fieldset>
			<legend>게시물 검색</legend>
			<c:if test="${boardConfVo.ctgYn eq 'Y'}">
				<c:forEach items="${boardConfVo.ctgList}" var="ctgVo" varStatus="status">
					<script type="text/javascript">
						bbsCtgAry['${ctgVo.ctgCd}'] = '${ctgVo.ctgNm}';
					</script>
				</c:forEach>
				<c:if test="${domCd != 30}">
				<select id="q_ctgCd" name="q_ctgCd">
					<option value="">-- 분류선택 --</option>
					<c:forEach items="${boardConfVo.ctgList}" var="ctgVo" varStatus="status">
						<option value="${ctgVo.ctgCd}"<c:if test="${param.q_ctgCd eq ctgVo.ctgCd}"> selected="selected"</c:if>>${ctgVo.ctgNm}</option>
					</c:forEach>
				</select>
				</c:if>
			</c:if>
	
			<select name="q_searchKeyType" id="q_searchKeyType" style="width:130px;vertical-align:top;" onchange="if($(this).val() != ''){$(this).next().focus().select();}">
				<option value="">-- 검색선택 --</option>
				<option value="TITLE___1002"<c:if test="${param.q_searchKeyType eq 'TITLE___1002'}"> selected="selected"</c:if>>제목</option>
				<option value="CONTENTS___1002"<c:if test="${param.q_searchKeyType eq 'CONTENTS___1002'}"> selected="selected"</c:if>>내용</option>
				<c:forEach var="extensionVo" items="${boardConfVo.searchColunms}">
					<c:set var="searchKey" value="${extensionVo.columnId}___${extensionVo.searchType}" />
					<option value="${searchKey}"<c:if test="${param.q_searchKeyType eq searchKey}"> selected="selected"</c:if>>${extensionVo.columnNm}</option>
				</c:forEach>
				<c:if test="${param.q_searchKeyType eq 'TAG___1005'}">
					<option value="TAG___1005"<c:if test="${param.q_searchKeyType eq 'TAG___1005'}"> selected="selected"</c:if>>태그</option>
				</c:if>
			</select>
			<input type="hidden" name="q_searchKey" value="${param.q_searchKey}" />
			<input type="text" name="q_searchVal" id="q_searchVal" value="${param.q_searchVal}" title="검색어를 입력하세요." 
					placeholder="검색어를 입력하세요." onfocus="this.placeholder=''; return true" maxlength="50" style="width:300px;" onkeyup="if(event.keyCode==13)jsSearch();">
	
			<!-- <input type="image" alt="검색" src="/resources/web/theme/default/images/btn/btn_g_search.gif" onclick="jsSearch(); return false;" /> -->
			<p class="btn_src_zone"><a href="#" class="btn_search" onclick="jsSearch();">검색</a></p>
			<%-- <c:if test="${domCd == 30 && param.bbsCd == 1014}">
				<input type="image" alt="검색옵션" src="/resources/web/theme/default/images/btn/btn_g_searchoption.gif" onclick="jsToggleSearchOption(this); return false;" />
			</c:if>
			<input type="image" alt="초기화" src="/resources/web/theme/default/images/btn/btn_g_reset.gif" onclick="jsSearchReset(); return false;" />
			<c:if test="${param.bbsCd == 1014}"><span>&nbsp;&nbsp;&nbsp;&nbsp; * 검색옵션을 클릭하면 기간검색이 가능합니다.</span></c:if> --%>
			<!-- 검색 옵션 시작 -->
			<div id="SearchOptionDiv" class="mar_t5 none" style="display:none;">
				<input type="text" id="q_startDt" name="q_startDt" value="${param.q_startDt}" maxlength="8" title="검색시작일" /> ~
				<input type="text" id="q_endDt" name="q_endDt" value="${param.q_endDt}" maxlength="8" title="검색종료일" />&nbsp;
	
				<input type="button" class="gray_s" onclick="jsSetDay(0, 1, 0);" value="오늘" />
				<input type="button" class="gray_s" onclick="jsSetDay(0, 2, 0);" value="1일" />
				<input type="button" class="gray_s" onclick="jsSetDay(0, 7, 0);" value="7일" />
				<input type="button" class="gray_s" onclick="jsSetDay(0, 10, 0);" value="10일" />
				<input type="button" class="gray_s" onclick="jsSetDay(0, 15, 0);" value="15일" />
				<input type="button" class="gray_s" onclick="jsSetDay(1, 1, 0);" value="1개월" />
				<input type="button" class="gray_s" onclick="jsSetDay(3, 1, 0);" value="3개월" />
				<input type="button" class="gray_s" onclick="jsSetDay(6, 1, 0);" value="6개월" />
				<input type="button" class="gray_s" onclick="jsSetDay(-1, 1, 0);" value="전체" />
			</div>
			<!-- 검색 옵션 끝 -->
		</fieldset>
	</div>
</div>
<!-- 검색 영역 끝 -->