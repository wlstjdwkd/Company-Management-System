<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<%@ page import="egovframework.board.config.BoardConfConstant" %>
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />

<html>
<head>
	<title>게시물 목록</title>

	<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask" />
	<ap:jsTag type="tech" items="msg,util,acm" />
	<ap:jsTag type="egovframework" items="board" />

	<!-- 사용자 스크립트 시작 -->
	<script type="text/javascript">

	//카테고리 저장용
   	bbsCtgAry = new Array();	

	$().ready(function(){
		//게시판 설정값들을 초기화 합니다.
		if(typeof Ahpek == "undefined"){ Ahpek = {}; }
		Ahpek.pageType 		= "LIST";
		Ahpek.boardNm		= "${boardConfVo.bbsNm}";
		Ahpek.boardType		= "${boardConfVo.kindCd}";
		Ahpek.useCategory 	= "${boardConfVo.ctgYn}";
		Ahpek.fileYn 		= "${boardConfVo.fileYn}";
		Ahpek.fileExts 		= "${boardConfVo.fileExts}";
		Ahpek.captchaYn 	= "${boardConfVo.captchaYn}";
		Ahpek.tagYn 		= "${boardConfVo.tagYn}";
		Ahpek.bbsNm		 	= "${boardConfVo.bbsNm}";	
		Ahpek.bbsCd		 	= "${boardConfVo.bbsCd}";
		Ahpek.searchVal		= "${param.q_searchVal}";
		Ahpek.searchKey		= "${param.q_searchKey}";
		Ahpek.sortName		= "${param.q_sortName}";
		Ahpek.sortOrder		= "${param.q_sortOrder}";
		Ahpek.startDt 		= "${param.q_startDt}";
		Ahpek.endDt   		= "${param.q_endDt}";
		Ahpek.showSummaryYn	= "${param.showSummaryYn}";
		Ahpek.serverNm 		= "http://" + "<%= request.getServerName() + ':' + request.getLocalPort() %>" + "<c:url value='/web/board/ND_convertAction.do' />";

		onReadyEventFunctions();

		//검색 날짜 입력
		$('#q_startDt').datepicker({
			/* ctxRoot : CTX_PATH, buttonText: '달력' */
			showOn : 'button',
            defaultDate : null,
            buttonImage : '<c:url value="/resources/openworks/theme/default/images/icon/icon_cal.gif" />',
            buttonImageOnly : true,
            changeYear: true,
            changeMonth: true,
            yearRange: "1920:+1"
		});
		$('#q_endDt').datepicker({
			/* ctxRoot : CTX_PATH, buttonText: '달력' */
			showOn : 'button',
            defaultDate : null,
            buttonImage : '<c:url value="/resources/openworks/theme/default/images/icon/icon_cal.gif" />',
            buttonImageOnly : true,
            changeYear: true,
            changeMonth: true,
            yearRange: "1920:+1"
		});
		
		$("#q_searchVal").keyup(function(e){
			if(e.keyCode == 13) {
				event.preventDefault();
				jsSearch();
			}
		});

	});

	</script>
	<!-- 사용자 스크립트 끝 -->
</head>

<body>
	<div id="self_dgs">
		<div class="pop_q_con">
			<form name="convertForm" id="convertForm" method="post" onsubmit="return false;">
				<!--  변환 옵션 사항 -->
				<input type="hidden" name="bbsCd" value="${param.bbsCd}" />
				<input type="hidden" name="maxResult" id="maxResult" value="" />
				<input type="hidden" name="showAll" id="showAll" value="N" />
				<input type="hidden" name="noticeYnYn" id="noticeYnYn" value="N" />
				<input type="hidden" name="titleYn" id="titleYn" value="N" />
				<input type="hidden" name="summaryYn" id="summaryYn" value="N" />
				<input type="hidden" name="scoreSumYn" id="scoreSumYn" value="N" />
				<input type="hidden" name="regDtYn" id="regDtYn" value="N" />
				<input type="hidden" name="modDtYn" id="modDtYn" value="N" />
				<input type="hidden" name="readCntYn" id="readCntYn" value="N" />
				<input type="hidden" name="regNmYn" id="regNmYn" value="N" />
				<input type="hidden" name="mgrIdYn" id="mgrIdYn" value="N" />
				<input type="hidden" name="userKeyYn" id="userKeyYn" value="N" />
				<input type="hidden" name="scoreCntYn" id="scoreCntYn" value="N" />
				<input type="hidden" name="accuseCntYn" id="accuseCntYn" value="N" />
				<input type="hidden" name="recomCntYn" id="recomCntYn" value="N" />
				<input type="hidden" name="type" value="" />
		
				<input type="hidden" name="q_currPage" value="${param.q_currPage}" />
				<input type="hidden" name="q_ctgCd" value="-1" />
				<input type="hidden" name="q_sortName" value="${param.q_sortName}" />
				<input type="hidden" name="q_sortOrder" value="${param.q_sortOrder}" />
				<input type="hidden" name="q_searchKey" value="${param.q_searchKey}" />
				<input type="hidden" name="q_searchVal" value="${param.q_searchVal}" />
				<input type="hidden" name="q_startDt" value="${param.q_startDt}" />
				<input type="hidden" name="q_endDt" value="${param.q_endDt}" />
			</form>
		
			<!-- 검색 폼 -->
			<form name="dataForm" id="dataForm" method="post" action="${svcUrl }" >
				<!-- 기본 검색 사항 -->
				<input type="hidden" name="seq" id="seq" value="" />
				<input type="hidden" name="domCd" value="${param.q_domCd}" />
				<input type="hidden" name="bbsCd" value="${param.bbsCd}" />
				<input type="hidden" name="pageType" value="" />
				<input type="hidden" name="showSummaryYn" value="${param.showSummaryYn}" />
				<input type="hidden" name="delDesc" id="delDesc" value="" />
				<input type="hidden" name="superAdmYn" value="${auth.wbiz_tot_adm}" />
				<input type="hidden" name="ppAdmYn" value="${auth.wbiz_pp_adm}" />
				
				<!-- default values -->		
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />
		
				<!-- 검색 삽입. -->
				<%@include file="../common/INC_search.jsp" %>						
				
				<div class="block">
					<%-- 페이징 관련 파라미터 생성. 목록표시 갯수 선택 생성됨--%>
					<ap:pagerParam />
										
					<!-- 목록 삽입. -->
					<%@include file="INC_boardList.jsp" %>																				
					
					<!-- 버튼 -->					
					<div class="btn_page_last">
						<a class="btn_page_admin" href="#" onclick="jsSummaryShow();"><span>SUMMARY</span></a>
						<a class="btn_page_admin" href="#" onclick="jsDeleteList('${param.bbsCd}');"><span>삭제</span></a>
						<a class="btn_page_admin" href="#" onclick="jsInsertForm('INSERT');"><span>쓰기</span></a>						
					</div>
					
					<!-- 페이징 -->
					<ap:pager pager="${pager}" />
					<!-- //페이징 -->										
				
				</div>
		
			</form>
		</div>
	</div>

</body>
</html>