<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<%@ page import="egovframework.board.config.BoardConfConstant" %>
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />

<html>
<head>
	<title>게시물 목록</title>
	<ap:jsTag type="web" items="jquery,validate,colorbox,ui,notice,msgBox" />
	<ap:jsTag type="tech" items="msg,util,cmn, mainn, subb, font,paginate" />
	<ap:jsTag type="egovframework" items="boardFront" />

	<!-- 사용자 스크립트 시작 -->
	<script type="text/javascript">
	_boardSvcUrl = "${svcUrl}";
	
	//카테고리 저장용
   	bbsCtgAry = new Array();

	$().ready(function(){
		<c:if test="${message != null}">
			jsMsgBox(null, "info","${message}");
		</c:if>
		
		/* var faqlist = jQuery(".tbl_faq tr");
		var faqindex = faqlist.index();
			faqlist.click(function(e){
			    var jQthis = jQuery(this);
				if(!jQthis.next('.viewtd').hasClass('active')){
					jQthis.next('.viewtd').addClass('active').show();
					jQthis.next('.viewtd').children().children('.listshow').show();
					jQthis.addClass('over');
				}
				else if(jQthis.next('.viewtd').hasClass('active')){
					jQthis.next('.viewtd').removeClass('active');
					jQthis.next('.viewtd').children().children('.listshow').hide();
					jQthis.removeClass('over');
				}
				e.preventDefault();
		});
 */
		
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
		Ahpek.showSummaryYn	= "N";
		Ahpek.serverNm 		= "http://" + "<%= request.getServerName() + ':' + request.getLocalPort() %>" + "<c:url value='/web/board/ND_convertAction.do' />";
		Ahpek.isSession		= ${!empty __usk};

		onReadyEventFunctions();

		//검색 날짜 입력
		//$('#q_startDt').datepicker({ ctxRoot : CTX_PATH, buttonText: '달력'});
		//$('#q_endDt').datepicker({ ctxRoot : CTX_PATH, buttonText: '달력'});

		//검색 날짜 입력
	    $('#q_startDt').datepicker({
            showOn : 'button',
            defaultDate : null,
            buttonImage : '<c:url value="/resources/web/theme/default/images/button/btn_calendar.gif" />',
            buttonImageOnly : true
        });
        $('#q_endDt').datepicker({
            showOn : 'button',
            defaultDate : null,
            buttonImage : '<c:url value="/resources/web/theme/default/images/button/btn_calendar.gif" />',
            buttonImageOnly : true
        });		
	});

	//수정 폼
	var jsUpdateForm = function(pageType, seq){
		$("#dataForm input[name=refSeq]").val("");
		$("#dataForm input[name=seq]").val(seq);
		$("#dataForm input[name=pageType]").val(pageType);
		jsRequest("dataForm", "BD_board.update.form.do", "get");
	};
	
	</script>
	<!-- 사용자 스크립트 끝 -->
</head>

<body>
<div id="wrap">
	<div class="s_cont" id="s_cont">
		<div class="s_tit s_tit05">
			<h1>고객지원</h1>
		</div>
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit tit5">고객지원</h2>
				<ul>
				</ul>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}"  />
				</div>
				<div class="r_cont s_cont05_03">
					<form name="convertForm" id="convertForm" method="post" onsubmit="return false;">
						<!--  변환 옵션 사항 -->
						<input type="hidden" name="bbsCd" value="${bbsCd}" />
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
					<form name="dataForm" id="dataForm" method="post" >
						<!-- 기본 검색 사항 -->
						<input type="hidden" name="seq" id="seq" value="" />
						<input type="hidden" name="bbsCd" value="${bbsCd}" />
						<input type="hidden" name="pageType" value="" />
						<input type="hidden" name="showSummaryYn" value="${param.showSummaryYn}" />
						<input type="hidden" name="delDesc" id="delDesc" value="" />
						<input type="hidden" name="domCd" id="domCd" value="${domCd}" />
						
						<!-- default values -->		
						<ap:include page="param/defaultParam.jsp" />
						<ap:include page="param/pagingParam.jsp" />
						<ap:include page="param/dispParam.jsp" />						
						
						
						
						<%-- 항목 표시 수 --%>
						<c:set var="thCnt" value="0" />
					<div class="sear_sec st_box01">
						<c:if test="${boardConfVo.ctgYn eq 'Y'}">
							<c:forEach items="${boardConfVo.ctgList}" var="ctgVo" varStatus="status">
								<script type="text/javascript">
									bbsCtgAry['${ctgVo.ctgCd}'] = '${ctgVo.ctgNm}';
								</script>
							</c:forEach>
							<c:if test="${domCd != 30}">
								<select class="select_box" id="q_ctgCd" name="q_ctgCd" style="vertical-align:middle;">
									<option value="">-- 분류선택 --</option>
									<c:forEach items="${boardConfVo.ctgList}" var="ctgVo" varStatus="status">
										<option value="${ctgVo.ctgCd}"<c:if test="${param.q_ctgCd eq ctgVo.ctgCd}"> selected="selected"</c:if>>${ctgVo.ctgNm}</option>
									</c:forEach>
								</select>
							</c:if>
						</c:if>
			
						<select class="select_box" name="q_searchKeyType" id="q_searchKeyType" style="width:130px;vertical-align:middle;" onchange="if($(this).val() != ''){$(this).next().focus().select();}">
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
								placeholder="    검색어를 입력하세요." onfocus="this.placeholder=''; return true" maxlength="50" style="width:380px; height: 35px; border: 1px solid #dadada; vertical-align: middle; " onkeyup="if(event.keyCode==13)jsSearch();">
				
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
						<div class="sear_text" style="display:inline-block;">
							<a href="#none" onclick="jsSearch();"><span><img src="/images2/sub/sear_ico.png"></span>검색</a>
						</div>
					</div>
					<div class="table_list">
						<%-- 페이징 관련 파라미터 생성. 목록표시 갯수 선택 생성됨--%>
						<ap:pagerParam />
						<div class="acc_list">
							<c:forEach items="${boardList}" var="baseVo" varStatus="status">
									<c:set var="thCnt" value="${thCnt + 1}" />
									<div class="acc_tit">
										<dl>
											<dd><img src="/images2/sub/q_ico.png"></dd>
											<dd>[${baseVo.ctgNm }]</dd>
											<dt>${baseVo.title }</dt>
										</dl>
									</div>
									<div class="acc_cont">
										<c:if test="${boardConfVo.mgrEditorYn eq 'Y'}" >
											<p id="emailCnHtml_${baseVo.seq}"></p>
											<input type="hidden" id="email_cn_html_${baseVo.seq}" value="${baseVo.contents}" />
											<script type="text/javascript">$("#emailCnHtml_${baseVo.seq}").html($("#email_cn_html_${baseVo.seq}").val());</script>
										</c:if>
										<c:if test="${boardConfVo.mgrEditorYn eq 'N'}" >
											<p>${baseVo.contents}</p>
										</c:if>
									</div>
							</c:forEach>
						</div>
					</div>
					<div style="text-align:center;"><ap:pager pager="${pager}" /></div>		
				</div>
			</div>
		</div>
	</div>
	<!-- content -->
</div>
<!-- wrap -->

</body>
</html>