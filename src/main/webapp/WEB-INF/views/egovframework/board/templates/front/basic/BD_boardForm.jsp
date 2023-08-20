<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<%@ page import="egovframework.board.config.BoardConfConstant" %>
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
	<title>게시물 등록</title>

	<script type="text/javascript" src="${contextPath}/script/egovframework/agentDetector.js"></script>
	<ap:jsTag type="web" items="jquery,validate,notice,msgBox,colorbox,multifile,mask" />
	<ap:jsTag type="tech" items="msg,util,ucm,cs" />
	<ap:jsTag type="egovframework" items="boardFront" />
	
	<c:choose>
		<c:when test="${pageType eq 'INSERT'}">
			<c:set var="methodParam" value="processBoardInsert" />
			<c:set var="title" value="작성" />
			<c:set var="button" value="/resources/web/theme/default/images/btn/btn_regist.gif" />
		</c:when>
		<c:when test="${pageType eq 'UPDATE'}">
			<c:set var="methodParam" value="boardUpdate" />
			<c:set var="title" value="수정" />
			<c:set var="button" value="/resources/web/theme/default/images/btn/btn_edit.gif" />
		</c:when>
		<c:otherwise>
			<c:set var="action" value="${svcUrl}" />
			<c:set var="title" value="답글" />
			<c:set var="button" value="/resources/web/theme/default/images/btn/btn_regist.gif" />
		</c:otherwise>
	</c:choose>

	<!-- 사용자 스크립트 시작  -->
	<script type="text/javascript">

	$().ready(function(){
		
		<c:if test="${message != null}">
			jsMsgBox(null, "info","${message}");
		</c:if>
		
		//게시판 설정값들을 초기화 합니다.
		if(typeof Ahpek == "undefined"){ Ahpek = {}; }

		Ahpek.bbsCd			= "${boardConfVo.bbsCd}";
		Ahpek.pageType		= "${pageType}";
		Ahpek.boardNm		= "${boardConfVo.bbsNm}";
		Ahpek.boardType		= "${boardConfVo.kindCd}";
		Ahpek.useCategory	= "${boardConfVo.ctgYn}";
		Ahpek.fileYn		= "${boardConfVo.fileYn}";
		Ahpek.uploadType	= "${boardConfVo.uploadType}";
		Ahpek.maxFileCnt	= "${boardConfVo.maxFileCnt}";
		Ahpek.maxFileSize	= "${boardConfVo.maxFileSize}";
		Ahpek.totalFileSize	= "${boardConfVo.totalFileSize}";
		Ahpek.fileExts		= "${boardConfVo.fileExts}";
		Ahpek.closeFileIcon	= "<c:url value='/resources/openworks/theme/default/images/btn/btn_r_close.gif' />";
		Ahpek.captchaYn		= "${boardConfVo.captchaYn}";
		Ahpek.fileCnt		= ${dataVo.fileCnt};
		Ahpek.tagYn			= "${boardConfVo.tagYn}";
		Ahpek.banYn			= "${boardConfVo.banYn}";
		Ahpek.editorYn		= "${boardConfVo.usrEditorYn}";

		onReadyEventFunctions();

		$("#agent").val(UserAgent);

		//dataForm 유효성 체크
		SharedAhpek.jsSetFormValidate = function(){

			var submitFunction = function(form){
				/* if($("#dataForm input[name=openYn]:checked").val() == "N"){
					if($("#regPwd").val() == ""){
						$("#regPwd").focus();
						return;
					}
				} */
				<c:choose>
					<c:when test="${boardConfVo.banYn eq 'Y'}">
						$.post("ND_check.ban.do", {
							bbsCd : Ahpek.bbsCd,
							title : $("#title").val(),
							contents : $("textarea[name=contents]").val()
						}, function(result){
							if(result.result == true){
								alert(result.message);
								return;
							}else{
								if($("#dataForm").valid() === true){
									if(Ahpek.uploadType == "1001"){
										detectFlashPlayer().flexSubmit();
									}else{
										document.dataForm.submit();
									}
									return true;
								 };
							};
						}, "json");
					</c:when>
					<c:otherwise>
						if($("#dataForm").valid() === true){
							if(Ahpek.uploadType == "1001"){
								detectFlashPlayer().flexSubmit();
							}else{
								document.dataForm.submit();
							}
							return true;
						 }
					</c:otherwise>
				</c:choose>
			};

			var jsSetErrorPlacement = function(error, element){
				if(element.attr("name") == "contents"){
					error.prependTo($("#contentsErrorDiv"));
				}else{
					error.insertBefore(element);
				}
			};

			$("#dataForm").validate({
				//유효성 검증 BEAN Annotation 기반 자동 설정
				//<valid:script type="jquery" />,
				rules: {
					regNm :		{ required:true, minlength:2, maxlength:10 },
					title :		{ required:true, minlength:3, maxlength:200 },
					contents :	{ required:true, minlength:10 }
					<c:if test="${boardConfVo.ctgYn eq 'Y'}">
						,ctgCd :	{ required:true }
					</c:if>
					<c:forEach var="extensionVo" items="${boardConfVo.formColunms}">
						<c:if test="${!empty extensionVo.columnType and extensionVo.requireYn eq 'Y'}">
							,${extensionVo.beanName} :	{ required: true }
						</c:if>
					</c:forEach>
				},
				errorClass: "unfill",
				errorPlacement: jsSetErrorPlacement,
				submitHandler: submitFunction
			});
		}

		//폼 설정
		jsFormProcess();
	});

	//플래쉬 파일 업로드 창
	function detectFlashPlayer(){
		var flashPlayer = null;
		if(navigator.appName.indexOf("Microsoft") != -1){
			flashPlayer = window.AhpekMultiFileUploader;
			if(flashPlayer == undefined){
				flashPlayer = window.document.AhpekMultiFileUploader;
			}
		}else{
			flashPlayer = window.document.AhpekMultiFileUploader;
		}
		return flashPlayer;
	}

	//업로드 완료 이벤트핸들러
	function uploadComplete(){
		var msg = arguments[0];
		if(msg === "UPLOAD_COMPLETE" || msg === "UPLOAD_DONE"){
			var fileSeq = arguments[1];
			document.dataForm.fileSeq.value = fileSeq;
			document.dataForm.submit();
		}
	}

	//첨부된 파일중 ajax를 이용하여 파일 삭제
	var jsFileDelete = function(element, seq, id){
		jsMsgBox(null, 'confirm', Message.msg.fileDeleteConfirm ,			
			function(){
				var url = "PGMS0081.do";
				$.post(url, 
						{ fileId : id, fileSeq : seq, bbsCd : "${dataVo.bbsCd}", df_method_nm:"boardFileDeleteOne" }, 
					function(result){
						if(result == 1){
							$(element).parent().remove();
		
							if(Ahpek.maxFileCnt <= Ahpek.fileCnt)
								self.location.reload();
		
							if(eval($("#uploadFileCnt").val()) > 0)
								$("#uploadFileCnt").val(eval($("#uploadFileCnt").val()) - 1);
							else $("#uploadFileCnt").val(0);
		
							$.fn.MultiFile.reEnableEmpty();
		
						}else{
							jsMsgBox(null, "error",Message.msg.processFail);
						}
					}, 'json');
			}
		);//jsMsgBox
	};
	</script>
	<!-- 사용자 스크립트 끝  -->
</head>
<body>
<div id="wrap" class="top_bg">
	<div class="contents">
		<!--//top img-->
		<div class="top_img menu01">High Potential Enterprise Support. 대한민국 기업을 지원합니다.</div>
		<!--top img //-->

		<!--// lnb 페이지 타이틀-->
		<div class="title_page">
			<h2><img src="<c:url value="/images/cs/title_m1.png" />" alt="고객지원" /></h2>
		</div>
		<!--lnb 페이지 타이틀//-->
		<div id="go_container">
		<!--//우측영역 -->
		<div class="rcont">
			<!--//page title -->			
			<ap:trail menuNo="${param.df_menu_no}" />
			<!--page title //-->
			
			<!--//sub contents -->
			<div class="sub_cont">
				<form name="dataForm" id="dataForm" method="post" enctype="multipart/form-data" action="${action}" onsubmit="return false;">							
			
				<input type="hidden" name="bbsCd" value='${dataVo.bbsCd}' />
				<input type="hidden" name="seq" value='${dataVo.seq}' />
				<input type="hidden" name="refSeq" value='${dataVo.refSeq}' />
				<input type="hidden" name="orderNo" value='${dataVo.orderNo}' />
				<input type="hidden" name="depth" value='${dataVo.depth}' />
				<input type="hidden" name="mgrId" value='${dataVo.mgrId}' />
				<input type="hidden" name="agent" id="agent" value='${dataVo.agent}' />
				
				<!-- default values -->		
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<%@include file="../common/INC_searchParam.jsp" %>
				
				<!-- 내용쓰기 -->
				<div class="write">
					<legend>글입력</legend>
					<table class="table_basic">
						<caption class="hidden">게시판 글입력 페이지</caption>
						<colgroup>
							<col style="width:25%">
							<col style="width:*">
						</colgroup>
						<tbody>
							<!-- 제목 -->
							<tr>
								<th><label for="title">제목 <span class="tx_red tx_b">*</span></label></th>
								<td>
									<input type="text" name="title" id="title" class="w85_p" title="제목을 입력해주세요" value="${dataVo.title}" />
									<valid:msg name="title"></valid:msg>
								</td>
							</tr>
							
							<!-- 작성자 -->
							<tr>
								<th><label for="regNm">작성자 <span class="tx_red tx_b">*</span></label></th>
								<td>
									<input type="text" name="regNm" id="regNm" value="${dataVo.regNm}" />
									<valid:msg name="regNm"></valid:msg>
								</td>
							</tr>
			
							<!-- 분류 / 공지 지정여부 / 공개여부 -->
							<c:if test="${boardConfVo.ctgYn eq 'Y' or boardConfVo.noticeYn eq 'Y' or boardConfVo.openYn eq 'Y'}">
								<tr>
									<th>기본 설정 <span class="tx_red tx_b">*</span></th>
									<td>
										<c:if test="${boardConfVo.ctgYn eq 'Y'}">
											<select id="ctgCd" name="ctgCd" title="분류를 선택해주세요">
												<option value="">분류 선택</option>
												<c:forEach items="${boardConfVo.ctgList}" var="ctgVo" varStatus="status">
													<option value="${ctgVo.ctgCd}"<c:if test="${ctgVo.ctgCd == dataVo.ctgCd}" > selected="selected"</c:if>>${ctgVo.ctgNm}</option>
												</c:forEach>
											</select>
											<valid:msg name="ctgCd"></valid:msg>
										</c:if>
			
										<c:choose>
											<c:when test="${boardConfVo.noticeYn eq 'Y' && (pageType != 'REPLY')}">
												<input type="checkbox" class="checkbox" name="noticeYn" id="noticeYn" value="Y"<c:if test="${dataVo.noticeYn == 'Y'}"> checked='checked'</c:if> />
												<label for="noticeYn">&nbsp;공지로 지정</label>
											</c:when>
											<c:otherwise>
												<input type="hidden" name="noticeYn" id="noticeYn" value="N" />
											</c:otherwise>
										</c:choose>
			
										<%-- <c:choose>
											<c:when test="${boardConfVo.openYn eq 'Y'}">
												<input type="radio" class="radio" name="openYn" id="openYnN" value="N"<c:if test="${dataVo.openYn == 'N'}"> checked='checked'</c:if> onclick="$('#regPwdTR').show();" />
												<label for="openYnN">&nbsp;비공개</label>
												<input type="radio" class="radio" name="openYn" id="openYnY" value="Y"<c:if test="${(dataVo.openYn == null) || (dataVo.openYn != 'N')}"> checked='checked'</c:if> onclick="$('#regPwdTR').hide();" />
												<label for="openYnY">&nbsp;공개</label>
											</c:when>
											<c:otherwise>
												<input type="hidden" name="openYn" value="Y" />
											</c:otherwise>
										</c:choose> --%>
										<input type="hidden" name="openYn" value="Y" />
									</td>
								</tr>
							</c:if>
			
							<!-- 비공개 선택 시 비밀번호 입력 -->
							<%-- <tr id="regPwdTR"<c:if test="${dataVo.openYn eq 'Y'}"> class="none"</c:if>>
								<th><label for="regPwd">비밀번호<span class="tx_red tx_b"> *</span></label></th>
								<td>
									<input type="password" name="regPwd" id="regPwd" value="${dataVo.regPwd}" maxlength="20" />
									<valid:msg name="regPwd"></valid:msg>
								</td>
							</tr> --%>
			
							<!-- 내용 -->
							<tr>
								<th><label for="contents">내용 <span class="tx_red tx_b">*</span></label></th>
								<td>
									<div id="contentsErrorDiv"></div>
									<c:if test="${boardConfVo.usrEditorYn eq 'Y'}" >
										<textarea name="contents" id="htmlContent" rows="15" class="w99_p" cols="30" title="내용을 입력해주세요">${dataVo.contents}</textarea>
										<!-- <textarea name="contents" id="htmlContent" rows="10" cols="30" class="textarea" style="width:100%;">${dataVo.contents}</textarea> -->
											<script type="text/javascript">
											//<![CDATA[
											CKEDITOR.replace('htmlContent', {
												height : 200,
												enterMode : "2",
												filebrowserUploadUrl : "/PGMS0081.do?df_method_nm=processUploadEditor"
											});
											//]]>
											</script>
									</c:if>
									<c:if test="${boardConfVo.usrEditorYn eq 'N'}" >
										<textarea name="contents" id="textContent" rows="15" class="w99_p" title="내용을 입력해주세요">${dataVo.contents}</textarea>
									</c:if>
									<valid:msg name="contents" />
								</td>
							</tr>
			
							<!-- 확장 컬럼 입력 -->
							<c:forEach var="extensionVo" items="${boardConfVo.formColunms}">
								<c:if test="${!empty extensionVo.columnType}">
									<tr>
										<th scope="row">${extensionVo.columnNm}<c:if test="${extensionVo.requireYn eq 'Y'}"><span class="tx_red tx_b"> *</span></c:if></th>
										<td>
											<c:choose>
												<c:when test="${extensionVo.columnType eq 'TEXT'}">
													<input name="${extensionVo.beanName}" id="${extensionVo.beanName}" value="<ap:bean-util field="${extensionVo.columnId}" obj="${dataVo}"/>" type="text" class="w85_p" />
												</c:when>
												<c:when test="${extensionVo.columnType eq 'TEXTAREA'}">
													<textarea name="${extensionVo.beanName}" id="${extensionVo.beanName}" cols="30" rows="3" class="w99_p"><ap:bean-util field="${extensionVo.columnId}" obj="${dataVo}"/></textarea>
												</c:when>
												<c:when test="${extensionVo.columnType eq 'DATE'}">
													<input name="${extensionVo.beanName}" id="${extensionVo.beanName}" value="<ap:bean-util field="${extensionVo.columnId}" obj="${dataVo}"/>" type="text" maxlength="14" /> 예 : 20120101093000
													<p class="tx_blue_s">- 반드시 년월일시분초(14자리)까지 입력해야 합니다.</p>
												</c:when>
												<c:when test="${extensionVo.columnType eq 'EMAIL'}">
													<input name="${extensionVo.beanName}" id="${extensionVo.beanName}" value="<ap:bean-util field="${extensionVo.columnId}" obj="${dataVo}"/>" type="text" class="w200" />
												</c:when>
											</c:choose>
											<c:if test="${not empty extensionVo.columnComment}">
												<p class="tx_blue_s">- ${extensionVo.columnComment}</p>
											</c:if>
										</td>
									</tr>
								</c:if>
							</c:forEach>
			
							<!-- 파일 업로드 -->
							<c:if test="${boardConfVo.fileYn eq 'Y'}" >
								<tr>
									<th>첨부파일</th>
									<td>
										<c:if test="${pageType eq 'UPDATE'}">
											<c:if test="${fn:length(dataVo.fileList) > 0}">
												<p class="tx_blue_s">
													- 기존 첨부파일을 <span class="tx_red">삭제</span>하시려면 아래 <span class="tx_red">X 아이콘을 클릭</span>하세요.
												</p>
												<ul>
													<c:forEach items="${dataVo.fileList}" var="fileVo">
														<li class="mar_b5">
															<a href="#" onclick="jsFileDelete(this, ${fileVo.fileSeq}, '${fileVo.fileId}');"><img src="<c:url value="/images/ucm/icon_del_red.gif" />" class="vm"></img></a>
															${fileVo.localNm} <span class="tx_gray vm">(download ${fileVo.downCnt}, ${fileVo.fileSize}, ${fileVo.fileType})</span>
														</li>
													</c:forEach>
												</ul>
											</c:if>
										</c:if>
			
										<div class="mar_t5 mar_b5">
											<input type="hidden" name="fileSeq" id="fileSeq" value="${dataVo.fileSeq}" />
											<input type="file" name="multiFiles" id="multiFiles" class="multi max-${boardConfVo.maxFileCnt} w470" accept="${boardConfVo.fileExts}"<c:if test="${boardConfVo.maxFileCnt <= dataVo.fileCnt}"> disabled="disabled"</c:if> value="찾아보기" />
											<div id="multiFilesListDiv" class="regist-file"></div>
										</div>
			
										<p class="tx_blue_s">
											- <c:if test="${fn:length(boardConfVo.fileExts) >= 3 }"><script type="text/javascript">document.write("${boardConfVo.fileExts}".replace(/\|/g, ', ')); </script> 파일 첨부 가능, </c:if>
											최대 ${boardConfVo.maxFileCnt}개까지 업로드 할 수 있습니다.
											<c:if test="${boardConfVo.maxFileSize > 0}">파일당 ${boardConfVo.maxFileSize}MB</c:if>
											<c:if test="${(boardConfVo.maxFileSize > 0) && (boardConfVo.totalFileSize > 0)}">, </c:if>
											<c:if test="${boardConfVo.totalFileSize > 0}">전체 ${boardConfVo.totalFileSize}MB</c:if>
											<c:if test="${(boardConfVo.maxFileSize > 0) || (boardConfVo.totalFileSize > 0)}"> 업로드 할 수 있습니다.</c:if>
										</p>
										<input type="hidden" id="uploadFileCnt" value="${dataVo.fileCnt}" />
									</td>
								</tr>
							</c:if>
			
							<!-- 태그 입력 -->
							<c:if test="${boardConfVo.tagYn eq 'Y'}">
								<tr>
									<th><label for="contents">태그 입력</label></th>
									<td>
										<input type="text" name="bbsTags" id="bbsTags" class="w85_p" value="${fn:join(dataVo.bbsTags, ',')}" title="태그" />
										<p class="tx_blue_s">- 쉼표로 구분하여 태그를 입력해 주세요.</p>
									</td>
								</tr>
							</c:if>
			
							<!-- 자동 작성 방지 -->
							<c:if test="${boardConfVo.captchaYn eq 'Y'}">
								<tr>
									<th><label for="contents">자동 작성 방지 <span class="tx_red tx_b">*</span></label></th>
									<td>
										<img src="<c:url value="/simpleCaptcha.do" />" alt="자동 작성 방지" />
										<p>위의 이미지에 나타나는 문자를 입력해 주세요 : <input type="text" id="answer" name="answer" /></p>
									</td>
								</tr>
							</c:if>
						</tbody>
					</table>
				</div>
				<!-- //내용쓰기 -->
			
				<!-- 버튼 -->
				<div class="float_r mar_t10">
					<input type="image" alt="저장" src="/resources/web/theme/default/images/button/btn_view_save.gif" />
					<input type="image" alt="취소" src="/resources/web/theme/default/images/button/btn_view_cancel.gif" onclick="jsResetForm(); return false;" />
					<input type="image" alt="목록" src="/resources/web/theme/default/images/button/btn_list.gif" onclick="jsList(); return false;" />
				</div>
				<!-- //버튼 -->
			
				</form>
			</div>	
		</div>		
		</div>
	</div>	
</div>	
</body>
</html>