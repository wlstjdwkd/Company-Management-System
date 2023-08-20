<%-- <%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.openworks.kr/jsp/jstl" prefix="op" %> --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 검색 영역 시작 -->
<div class="search_top" id="Search_Menu_div" >
	<table class="table_search">		
		<caption>
        검색
        </caption>
        <colgroup>
        <col style="width:100%" />
        </colgroup>
        
        <tr>
        	<td class="only">
				<c:if test="${boardConfVo.ctgYn eq 'Y'}">
					<c:forEach items="${boardConfVo.ctgList}" var="ctgVo" varStatus="status">
						<script>
							bbsCtgAry['${ctgVo.ctgCd}'] = '${ctgVo.ctgNm}';
						</script>
					</c:forEach>
		
					<select id="q_ctgCd" name="q_ctgCd" class="over">
						<option value="">-- 분류선택 --</option>
						<c:forEach items="${boardConfVo.ctgList}" var="ctgVo" varStatus="status">
							<option value="${ctgVo.ctgCd}"<c:if test="${param.q_ctgCd eq ctgVo.ctgCd}"> selected="selected"</c:if>>${ctgVo.ctgNm}</option>
						</c:forEach>
					</select>
				</c:if>
				
				<!-- 자료요청관리 검색조건 추가 시작 -->
				<c:if test="${param.bbsCd eq '1006'}">
					
					<select name="q_dateType" title="요청일선택" id="q_dateType" style="width:110px">
                    	<option <c:if test="${param.q_dateType eq 'regDt'}"> selected="selected"</c:if> value="regDt">요청일</option>
                    	<option <c:if test="${param.q_dateType eq 'replyDt'}"> selected="selected"</c:if> value="replyDt">처리일</option>
                    </select>
					<input type="text" id=q_pjtStartDt name="q_pjtStartDt" class="w80" value="${param.q_pjtStartDt}" maxlength='8' /> ~ 
					<input type="text" id="q_pjtEndDt" name="q_pjtEndDt" class="w80" value="${param.q_pjtEndDt}" maxlength='8' />&nbsp;
				
					<select name="q_sttsType" title="전체상태" id="q_sttsType" style="width:110px">
                    	<option selected="selected" value=''>전체상태</option>
                    	<option <c:if test="${param.q_sttsType eq 'A'}"> selected="selected"</c:if> value="A">신청</option>
                    	<option <c:if test="${param.q_sttsType eq 'B'}"> selected="selected"</c:if> value="B">접수</option>
                    	<option <c:if test="${param.q_sttsType eq 'C'}"> selected="selected"</c:if> value="C">답변중</option>
                    	<option <c:if test="${param.q_sttsType eq 'D'}"> selected="selected"</c:if> value="D">답변완료</option>
                    </select>
                    
                    
				</c:if>
				<!-- 자료요청관리 검색조건 추가 끝 -->
				
				
				<select name="q_searchKeyType" id="q_searchKeyType" class="over" onchange="if($(this).val() != ''){$(this).next().focus().select();}">
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
				<input type="text" name="q_searchVal" id="q_searchVal" onkeyup="if(event.keyCode == 13){jsSearch()}" value="${param.q_searchVal}" maxlength='50' style="width:300px;" title="검색어 입력" placeholder="검색어를 입력하세요." />
		
				<p class="btn_src_zone">
					<button type="button" class="btn_search" onclick="jsSearch();">검색</button>
					<!-- <button type="button" class="btn_search" onclick="jsToggleSearchOption(this);">검색옵션</button>
					<button type="button" class="btn_search" onclick="jsSearchReset();">초기화</button> -->
				</p>	
				
				<!-- 검색 옵션 시작 -->
				<div id="SearchOptionDiv" style="display:none">
					<input type="text" id="q_startDt" name="q_startDt" class="w80" value="${param.q_startDt}" maxlength='8' /> ~ 
					<input type="text" id="q_endDt" name="q_endDt" class="w80" value="${param.q_endDt}" maxlength='8' />&nbsp;
		
					<button type="button" class="gray" onclick="jsSetDay(0, 1, 0);">오늘</button>
					<button type="button" class="gray" onclick="jsSetDay(0, 2, 0);">1일</button>
					<button type="button" class="gray" onclick="jsSetDay(0, 7, 0);">7일</button>
					<button type="button" class="gray" onclick="jsSetDay(0, 10, 0);">10일</button>
					<button type="button" class="gray" onclick="jsSetDay(0, 15, 0);">15일</button>
					<button type="button" class="gray" onclick="jsSetDay(1, 1, 0);">1개월</button>
					<button type="button" class="gray" onclick="jsSetDay(3, 1, 0);">3개월</button>
					<button type="button" class="gray" onclick="jsSetDay(6, 1, 0);">6개월</button>
					<button type="button" class="gray" onclick="jsSetDay(-1, 1, 0);">전체</button>
				</div>
				<!-- 검색 옵션 끝 -->
				
			</td>
		</tr>				
		
		
	</table>
</div>
<!-- 검색 영역 끝 -->