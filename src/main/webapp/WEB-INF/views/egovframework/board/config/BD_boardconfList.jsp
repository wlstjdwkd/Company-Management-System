<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<%@ page import="egovframework.board.config.BoardConfConstant" %>
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
	<title>게시판 목록</title>
	
	<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask" />
	<ap:jsTag type="tech" items="msg,util,acm" />
	<ap:jsTag type="egovframework" items="boardconf" />

	<script type="text/javascript">
		/*
		 * 공통 초기화 기능
		 */
		$(document).ready(function(){
			//select 박스 선택 값 설정
			jsSelected("q_searchKey", "${param.q_searchKey}");

			<c:if test="${!empty param.searchKey && !empty param.searchVal}">
				$("#contentDiv").highlight("${param.searchVal}");
			</c:if>

			//대상 체크박스 전체 선택
			$("input[name=chk-all]").click(function(){
				var isChecked = this.checked;
				$("input[name=bbsCds]").prop('checked', isChecked);				
			});
			
			// 관리자메인에서 게시판링크
			if(${!empty param.ad_board_bbsCd}) {
				if(${param.ad_board_bbsCd == "1005" && empty param.ad_board_filter }) {
						$.colorbox({
							title : "나의묻고답하기",
							href  : "<c:url value='/PGMS0081.do?bbsCd=' />" + "${param.ad_board_bbsCd}",						
							width : "80%", height:"100%",
							iframe: true
						});
						
				}
				else if(${param.ad_board_bbsCd == "1005" && !empty param.ad_board_filter }) {
					$.colorbox({
						title : "나의묻고답하기",
						href  : "<c:url value='/PGMS0081.do?bbsCd=' />" + "${param.ad_board_bbsCd}" + "&extColumn1=A",						
						width : "80%", height:"100%",
						iframe: true
					});
					
				}
				else if(${param.ad_board_bbsCd == "1006"}) {
					
					$.colorbox({
						title : "데이터 요청",
						href  : "<c:url value='/PGMS0081.do?bbsCd=' />" +"${param.ad_board_bbsCd}",									
						width : "80%", height:"100%",
						iframe: true
					});
				
				}
			}
		});

		//게시판 관리창
		var jsViewBbs = function(bbsCd, bbsNm){
			$("a[name=boardViewBtn]").colorbox({
				title : bbsNm,
				href  : "<c:url value='/PGMS0081.do?bbsCd=' />" + bbsCd,						
				width : "80%", height:"100%",
				iframe: true
			});
		};
	</script>
</head>
<body>
 <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">게시판관리</h2>
                <!-- 타이틀 영역 //-->
	 
			 	<!-- 검색-old -->
				<form name="dataForm" id="dataForm" method="post" onsubmit="return jsSearch();">				
				
				<input type="hidden" name="q_bbsCd" id="q_bbsCd" />
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />
		
				<div class="src_zone">
					<div class="src">
							<fieldset>
								<legend>게시판 검색</legend>
								<!-- <label class="skip" for="boardsearch">게시판 검색항목</label>-->
								<select name="q_searchKey" id="q_searchKey" title="검색조건선택" style="width:150px">
									<option value="">-- 전체 --</option>
									<option value="1001">게시판 명</option>
								</select>
								<!-- <label class="skip" for="searchText">검색단어 입력</label> -->
								<input type="text" name="q_searchVal" id="q_searchVal" value="${param.q_searchVal}"  style="width:300px;" placeholder="메뉴명을 입력하세요." title="검색어를 입력하세요." />
								<p class="btn_src_zone">
									<a href="#" type="submit" class="btn_search">검색</a> <a href="#" type="button" class="btn_refresh" onclick="jsSearchReset();">초기화</a> 
								</p>
							</fieldset>
						</div>
				</div>
		
				<%-- 페이징 관련 파라미터 생성. 목록표시 갯수 선택 생성됨--%>
				<%-- <op:pagerParam title="게시판 목록" /> --%>
			</form>
			<!-- //검색 -->
				
				<!-- 리스트 -->
				<div  class="list_zone">
				<table cellspacing="0" border="0" summary="기본게시판 목록으로 순번,분류,제목,작성자,작성일,조회 정보를 제공합니다.">
					<caption class="hidden">기본게시판 목록</caption>
					<colgroup>
			             <col width="3%">
			             <col width="">
			             <col width="10%">
			             <col width="10%">
			             <col width="10%">
			             <col width="10%">
			             <col width="10%">
			             <col width="10%">
			             <col width="11%">
			         </colgroup>
					<thead>
						<tr>
							<th rowspan="2"><input type="checkbox" value="Y" name="chk-all" id="chk-all" /></th>
							<th class="line_l" rowspan="2"><span class="sort" id="A.BBS_NM">게시판 명</span></th>
							<th><span class="sort" id="A.USE_YN">게시판 사용</span></th>
							<th><span class="sort" id="B.CTG_YN">분류 사용</span></th>
							<th><span class="sort" id="C.FILE_YN">첨부파일 사용</span></th>
							<th><span class="sort" id="C.CAPTCHA_YN">스팸방지</span></th>
							<th><span class="sort" id="D.RECOMM_YN">추천기능</span></th>
							<th><span class="sort" id="B.COMMENT_YN">댓글 사용</span></th>
							<th rowspan="2">게시물 관리</th>
						</tr>
						<tr>
							<th class="line_l"><span class="sort" id="B.NOTICE_YN">공지글 사용</span></th>
							<th><span class="sort" id="C.USR_EDITOR_YN">에디터 사용<br/>(사용자)</span></th>
							<th><span class="sort" id="E.DOWN_YN">목록 다운로드</span></th>
							<th><span class="sort" id="E.FEED_YN">FEED 사용</span></th>
							<th><span class="sort" id="D.SUE_YN">신고기능</span></th>
							<th><span class="sort" id="D.STFY_YN">만족도 사용</span></th>
							<!-- <th class="lr_none">미리보기</th> -->
						</tr>
					</thead>
					<tbody>
						<%-- <c:set var="index" value="${pager.indexNo}" /> --%>
						<c:forEach items="${resultList}" var="confVo" varStatus="status">
							<c:set var="style" value="${status.count % 2 == 1 ? 'bg_yellow' : ''}" />
							<c:set var="useYnNm" value="${confVo.useYn == 'Y' ? '사 용' : '미사용'}" />
							<c:set var="ctgYnNm" value="${confVo.ctgYn == 'Y' ? '사 용' : '미사용'}" />
							<c:set var="fileYnNm" value="${confVo.fileYn == 'Y' ? '사 용' : '미사용'}" />
							<c:set var="captchaYnNm" value="${confVo.captchaYn == 'Y' ? '사 용' : '미사용'}" />
							<c:set var="recommYnNm" value="${confVo.recommYn == 'Y' ? '사 용' : '미사용'}" />
							<c:set var="commentYnNm" value="${confVo.commentYn == 'Y' ? '사 용' : '미사용'}" />
							<c:set var="noticeYnNm" value="${confVo.noticeYn == 'Y' ? '사 용' : '미사용'}" />
							<c:set var="usrEditorYnNm" value="${confVo.usrEditorYn == 'Y' ? '사 용' : '미사용'}" />
							<c:set var="downYnNm" value="${confVo.downYn == 'Y' ? '사 용' : '미사용'}" />
							<c:set var="feedYnNm" value="${confVo.feedYn == 'Y' ? '사 용' : '미사용'}" />
							<c:set var="sueYnNm" value="${confVo.sueYn == 'Y' ? '사 용' : '미사용'}" />
							<c:set var="stfyYnNm" value="${confVo.stfyYn == 'Y' ? '사 용' : '미사용'}" />
			
							<tr class="${style}" id="${status.count}">
								<td rowspan="2"><input type="checkbox" value="${confVo.bbsCd}" name="bbsCds" class="checkbox" /></td>
								<td rowspan="2" class="tx_l">
									<c:if test="${superAdmYn == 'Y'}">
										<a href="#" id="${confVo.bbsCd}_bbsNm" onclick="jsUpdateForm('${confVo.bbsCd}'); return false;">${confVo.bbsNm}&lt;${confVo.bbsCd}&gt;</a>
										<span class="t_article" title="등록글 ${confVo.articleCnt}개">${confVo.articleCnt}</span>
										<span class="t_file" title="첨부파일 ${confVo.fileCnt}개">${confVo.fileCnt}</span>
										<%-- <span class="t_reply" title="의견글 ${confVo.commentCnt}개">${confVo.commentCnt}</span> --%>
									</c:if>
									<c:if test="${superAdmYn != 'Y'}">${confVo.bbsNm}</c:if>
									<div id="${confVo.bbsCd}_bbsDesc" class="td-summary">${confVo.bbsDesc}</div>
								</td>
								<td>
									<c:if test="${superAdmYn == 'Y'}"><a href="#" onclick="jsYnAction(this, '${confVo.bbsCd}', '0'); return false;"><span id="useYn" class="${confVo.useYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.useYn}">${useYnNm}</span></a></c:if>
									<c:if test="${superAdmYn != 'Y'}"><span id="useYn" class="${confVo.useYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.useYn}">${useYnNm}</span></c:if>
								</td>
								<td>
									<c:if test="${superAdmYn == 'Y'}"><a href="#" onclick="jsYnAction(this, '${confVo.bbsCd}', '<%= BoardConfConstant.GUBUN_CD_GLOBAL %>'); return false;"><span id="ctgYn" class="${confVo.ctgYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.ctgYn}">${ctgYnNm}</span></a></c:if>
									<c:if test="${superAdmYn != 'Y'}"><span id="ctgYn" class="${confVo.ctgYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.ctgYn}">${ctgYnNm}</span></c:if>
								</td>
								<td>
									<c:if test="${superAdmYn == 'Y'}"><a href="#" onclick="jsYnAction(this, '${confVo.bbsCd}', '<%= BoardConfConstant.GUBUN_CD_FORM %>'); return false;"><span id="fileYn" class="${confVo.fileYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.fileYn}">${fileYnNm}</span></a></c:if>
									<c:if test="${superAdmYn != 'Y'}"><span id="fileYn" class="${confVo.fileYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.fileYn}">${fileYnNm}</span></c:if>
								</td>
								<td>
									<c:if test="${superAdmYn == 'Y'}"><a href="#" onclick="jsYnAction(this, '${confVo.bbsCd}', '<%= BoardConfConstant.GUBUN_CD_FORM %>'); return false;"><span id="captchaYn" class="${confVo.captchaYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.captchaYn}">${captchaYnNm}</span></a></c:if>
									<c:if test="${superAdmYn != 'Y'}"><span id="captchaYn" class="${confVo.captchaYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.captchaYn}">${captchaYnNm}</span></c:if>
								</td>
								<td>
									<c:if test="${superAdmYn == 'Y'}"><a href="#" onclick="jsYnAction(this, '${confVo.bbsCd}', '<%= BoardConfConstant.GUBUN_CD_VIEW %>'); return false;"><span id="recommYn" class="${confVo.recommYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.recommYn}">${recommYnNm}</span></a></c:if>
									<c:if test="${superAdmYn != 'Y'}"><span id="recommYn" class="${confVo.recommYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.recommYn}">${recommYnNm}</span></c:if>
								</td>
								<td>
									<c:if test="${superAdmYn == 'Y'}"><a href="#" onclick="jsYnAction(this, '${confVo.bbsCd}', '<%= BoardConfConstant.GUBUN_CD_GLOBAL %>'); return false;"><span id="commentYn" class="${confVo.commentYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.commentYn}">${commentYnNm}</span></a></c:if>
									<c:if test="${superAdmYn != 'Y'}"><span id="commentYn" class="${confVo.commentYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.commentYn}">${commentYnNm}</span></c:if>
								</td>
								<%-- <td class="lr_none"><button type="button" name="boardViewBtn" class="gray" onclick="jsViewBbs(${confVo.bbsCd});">게시물 관리</button></td> --%>
								<td rowspan="2"><div class="btn_inner"><a href="#" class="btn_in_gray" name="boardViewBtn" onclick="jsViewBbs('${confVo.bbsCd}', '${confVo.bbsNm}');"><span>게시물 관리</span></a></div></td>
							</tr>
							<tr class="${style}" id="bot_${status.count}">
								<td  class="line_l">
									<c:if test="${superAdmYn == 'Y'}"><a href="#" onclick="jsYnAction(this, '${confVo.bbsCd}', '<%= BoardConfConstant.GUBUN_CD_GLOBAL %>','${confVo.listSkin}'); return false;"><span id="noticeYn" class="${confVo.noticeYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.noticeYn}">${noticeYnNm}</span></a></c:if>
									<c:if test="${superAdmYn != 'Y'}"><span id="noticeYn" class="${confVo.noticeYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.noticeYn}">${noticeYnNm}</span></c:if>
								</td>
								<td class="tac">
									<c:if test="${superAdmYn == 'Y'}"><a href="#" onclick="jsYnAction(this, '${confVo.bbsCd}', '<%= BoardConfConstant.GUBUN_CD_FORM %>'); return false;"><span id="usrEditorYn" class="${confVo.usrEditorYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.usrEditorYn}">${usrEditorYnNm}</span></a></c:if>
									<c:if test="${superAdmYn != 'Y'}"><span id="usrEditorYn" class="${confVo.usrEditorYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.usrEditorYn}">${usrEditorYnNm}</span></c:if>
								</td>
								<td>
									<c:if test="${superAdmYn == 'Y'}"><a href="#" onclick="jsYnAction(this, '${confVo.bbsCd}', '<%= BoardConfConstant.GUBUN_CD_LIST %>'); return false;"><span id="downYn" class="${confVo.downYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.downYn}">${downYnNm}</span></a></c:if>
									<c:if test="${superAdmYn != 'Y'}"><span id="downYn" class="${confVo.downYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.downYn}">${downYnNm}</span></c:if>
								</td>
								<td>
									<c:if test="${superAdmYn == 'Y'}"><a href="#" onclick="jsYnAction(this, '${confVo.bbsCd}', '<%= BoardConfConstant.GUBUN_CD_LIST %>'); return false;"><span id="feedYn" class="${confVo.feedYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.feedYn}">${feedYnNm}</span></a></c:if>
									<c:if test="${superAdmYn != 'Y'}"><span id="feedYn" class="${confVo.feedYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.feedYn}">${feedYnNm}</span></c:if>
								</td>
								<td>
									<c:if test="${superAdmYn == 'Y'}"><a href="#" onclick="jsYnAction(this, '${confVo.bbsCd}', '<%= BoardConfConstant.GUBUN_CD_VIEW %>'); return false;"><span id="sueYn" class="${confVo.sueYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.sueYn}">${sueYnNm}</span></a></c:if>
									<c:if test="${superAdmYn != 'Y'}"><span id="sueYn" class="${confVo.sueYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.sueYn}">${sueYnNm}</span></c:if>
								</td>
								<td>
									<c:if test="${superAdmYn == 'Y'}"><a href="#" onclick="jsYnAction(this, '${confVo.bbsCd}', '<%= BoardConfConstant.GUBUN_CD_VIEW %>'); return false;"><span id="stfyYn" class="${confVo.stfyYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.stfyYn}">${stfyYnNm}</span></a></c:if>
									<c:if test="${superAdmYn != 'Y'}"><span id="stfyYn" class="${confVo.stfyYn == 'Y' ? 'icon-use' : 'icon-not-use'}" yn="${confVo.stfyYn}">${stfyYnNm}</span></c:if>
								</td>								
							</tr>
						</c:forEach>									
			
					</tbody>
				</table>
				</div>
				<!-- //리스트 -->				
			
				<!-- 버튼 -->
				<c:if test="${superAdmYn == 'Y'}">
				<div class="btn_page_last">
					<a class="btn_page_admin" href="#" onclick="jsDeleteList()"><span>선택삭제</span></a>
					<a class="btn_page_admin" href="#" onclick="jsInsertForm();"><span>신규등록</span></a>
				</div> 				
				<!-- 버튼 //-->
				
				<!-- 페이징 -->
				<ap:pager pager="${pager}" />
				<!-- //페이징 -->
				</c:if>
			</div>
		</div>
	</div>
</body>
</html>