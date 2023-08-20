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
<meta charset="UTF-8" />
	<title>게시물 등록</title>

	<script type="text/javascript" src="${contextPath}/script/egovframework/agentDetector.js"></script>
	<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,colorbox,multifile,mask" />
	<ap:jsTag type="tech" items="msg,util,cmn, mainn, subb, font" />
	<ap:jsTag type="egovframework" items="boardFront" />
	
	<c:choose>
		<c:when test="${pageType eq 'INSERT'}">
			<c:set var="methodParam" value="processBoardInsertAjax" />
			<c:set var="title" value="작성" />
			<c:set var="button" value="/resources/web/theme/default/images/btn/btn_regist.gif" />
			<!-- 20160718 게시판번호 세션번호로 등록 -->
			<c:set var="SESSION_BBSCD" value="${boardConfVo.bbsCd}" scope="session" />
		</c:when>
		<c:when test="${pageType eq 'UPDATE'}">
			<c:set var="methodParam" value="boardUpdateAjax" />
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
	_boardSvcUrl = "${svcUrl}";

	$().ready(function(){
		<c:if test="${message != null}">
			jsMsgBox(null, "info","${message}");
		</c:if>		
		
		$("#df_method_nm").val('${methodParam}');
		
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
		Ahpek.closeFileIcon	= "<c:url value='/images/ucm/icon_del.png' />";
		Ahpek.captchaYn		= "${boardConfVo.captchaYn}";
		Ahpek.fileCnt		= ${dataVo.fileCnt};		
		Ahpek.tagYn			= "${boardConfVo.tagYn}";
		Ahpek.banYn			= "${boardConfVo.banYn}";
		Ahpek.editorYn		= "${boardConfVo.usrEditorYn}";

		onReadyEventFunctions();

		$("#agent").val(UserAgent);

		// board 공통 js에서 호출하는 함수
		SharedAhpek.jsSetFormValidate = function(){};
		
		var submitFunction = function(form){
			/* if($("#dataForm input[name=openYn]:checked").val() == "N"){
				if($("#regPwd").val() == ""){
					$("#regPwd").focus();
					return;
				}
			} */
			if($("#phNum1")) {
				$("#cellPhone").val($("#phNum1").val() + "-" + $("#phNum2").val() + "-" + $("#phNum3").val());
			}
			
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
									//document.dataForm.submit();
									boardAjaxSubmit();
								}
								return true;
							}
						};
					}, "json");
				</c:when>
				<c:otherwise>
					if($("#dataForm").valid() === true){
						if(Ahpek.uploadType == "1001"){
							detectFlashPlayer().flexSubmit();
						}else{
							//document.dataForm.submit();
							boardAjaxSubmit();
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
				emailAddr : { required:true, email:true },				
				phNum2:		{ required:true, minlength:3 },
				phNum3:		{ required:true, minlength:3 },
				title :		{ required:true, minlength:3, maxlength:200 },
				contents :	{ required:true, minlength:10, maxlength:2000 }
				<c:if test="${boardConfVo.ctgYn eq 'Y'}">
					,ctgCd :	{ required:true }
				</c:if>
				<c:forEach var="extensionVo" items="${boardConfVo.formColunms}">
					<c:if test="${!empty extensionVo.columnType and extensionVo.requireYn eq 'Y'}">
						,${extensionVo.beanName} :	{ required: true }
					</c:if>
				</c:forEach>
			},
			/* errorClass: "unfill",
			errorPlacement: jsSetErrorPlacement, */
			submitHandler: submitFunction
		});
		
		// MASK
		$('#phNum2').mask('0000');
		$('#phNum3').mask('0000');
		
		$("#btn_write").click(function() {
			<c:if test="${boardConfVo.usrEditorYn eq 'Y'}" >
			if(CKEDITOR.instances.htmlContent.getData() == "") {
				jsWarningBox(Message.template.required("내용"));
				return;
			} else {
				CKEDITOR.instances.htmlContent.updateElement();
			}
			</c:if>
			
			$("#dataForm").submit();
		});

		//폼 설정
		jsFormProcess();

		console.log();
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
	var jsFileDelete = function(element, seq, id) {		
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
	
	function boardAjaxSubmit() {
		$("#df_method_nm").val("${methodParam}");
		$("#dataForm").ajaxSubmit({
            url      : "${svcUrl}",		            
            dataType : "text",     
            async    : false,
            contentType: "multipart/form-data",
            beforeSubmit : function(){
            },            
            success  : function(response) {
            	try {
            		
            		response = JSON.parse(response);
            		
            		if(response.result){		            			
	            		jsMsgBox(null,'info',response.message, function(){
	            			
	            			if(Ahpek.pageType == "UPDATE") {
	            				jsView('${dataVo.bbsCd}', '${dataVo.seq}');
	            			}else{
	            				// 묻고답하기 게시판 : 마이페이지 > 나의묻고답하기로 이동
	            				if(Ahpek.bbsCd == "1005") {
	            					${PUB_MYPAGE_URL};
	            				}else{
	            					jsList();	
	            				}	            				
	            			}	            			
	            		});
            		}else{
            			jsMsgBox(null,'info',response.message);
            		}
                } catch (e) {
                    if(response != null) {
                    	jsSysErrorBox(response);
                    } else {
                        jsSysErrorBox(e);
                    }
                    return;
                }
            }
        });
	}
	
	</script>
	<!-- 사용자 스크립트 끝  -->
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
					<div class="agree_st">
						<p class="list_noraml">궁금한 점은 언제든 문의 바랍니다. 신속히 안내해 드릴 수 있도록 하겠습니다. <br/>
						다만, 기업 확인서 발급 예정일과 관련된 사항은 정확한 답변이 어려우니 지양하여 주시기 바랍니다.</p>
					</div>
					<form name="dataForm" id="dataForm" method="post" enctype="multipart/form-data" action="${svcUrl}" onsubmit="return false;">
						<input type="hidden" name="bbsCd" value='${dataVo.bbsCd}' />
						<input type="hidden" name="seq" value='${dataVo.seq}' />
						<input type="hidden" name="refSeq" value='${dataVo.refSeq}' />
						<input type="hidden" name="orderNo" value='${dataVo.orderNo}' />
						<input type="hidden" name="depth" value='${dataVo.depth}' />
						<input type="hidden" name="mgrId" value='${dataVo.mgrId}' />
						<input type="hidden" name="agent" id="agent" value='${dataVo.agent}' />
						
						<input type="hidden" name="cellPhone" id="cellPhone" />
						<input type="hidden" name="rtnPageType" id="rtnPageType" value="FORM"/>
						
						<input type="hidden" name="regNm" id="regNm" value="${dataVo.regNm}" />
						<input type="hidden" name="regId" id="regId" value="${dataVo.regId}" />
									
						<!-- default values -->		
						<ap:include page="param/defaultParam.jsp" />
						<ap:include page="param/pagingParam.jsp" />
						<ap:include page="param/dispParam.jsp" />
					
						<div class="list_bl">
							<h4 class="fram_bl none"><p><img src="/images2/sub/table_check.png">항목은 입력 필수 항목입니다.</p></h4>
							<table class="table_form">
								<caption>묻고답하기</caption>
								<colgroup>
									<col width="172px">
									<col width="273px">
									<col width="173px">
									<col width="272px">
								</colgroup>
								<tbody>
									<tr>
										<th class="p_l_30">작성자</th>
										<td class="b_l_0" colspan="3"><c:out value="${dataVo.regNm }" /></td>
									</tr>
									<tr style="display:none;">
										<th class="p_l_30">기업명</th>
										<td class="b_l_0">임시데이터</td>
										<th class="p_l_30">법인등록번호</th>
										<td class="b_l_0">임시데이터</td>
									</tr>
									<tr>
										<th><img src="/images2/sub/table_check.png">휴대전화</th>
										<td class="b_l_0" colspan="3">
											<c:set var="phNumArr" value="${fn:split(dataVo.cellPhone, '-') }" />
											<c:set var="ph1" value="010" />
											<c:set var="ph2" value="" />
											<c:set var="ph3" value="" />
											
											<c:if test="${fn:length(phNumArr) == 3}" >
												<c:set var="ph1" value="${phNumArr[0] }" />
												<c:set var="ph2" value="${phNumArr[1] }" />
												<c:set var="ph3" value="${phNumArr[2] }" />	
											</c:if>
											
											<select id="phNum1" class="select_box" style="width:101px; ">
												<c:forTokens items="${MOBILE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
													<option value="${firstNum }" <c:if test="${phNumArr[0] == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
												</c:forTokens>								
											</select>
											 ~ <input type="text" id="phNum2" name="phNum2" class="text" value="${ph2 }" style="width:127px;" title="전화번호중간번호">
											 ~ <input type="text" id="phNum3" name="phNum3" class="text" value="${ph3 }" style="width:127px;" title="전화번호마지막번호">
										</td>
									</tr>
									<tr>
										<th><img src="/images2/sub/table_check.png">이메일</th>
										<td class="b_l_0" colspan="3"><input type="text" name="emailAddr" id="emailAddr" value="${dataVo.emailAddr}" style="width: 688px"></td>
									</tr>
									<c:if test="${boardConfVo.ctgYn eq 'Y' or boardConfVo.noticeYn eq 'Y' or boardConfVo.openYn eq 'Y'}">
										<tr>
											<th>
												<c:choose>
													<c:when test="${boardConfVo.ctgYn eq 'Y'}">
														<c:choose>											
															<c:when test="${dataVo.bbsCd == 1001}" >카테고리 </c:when>
															<c:otherwise>
																<img src="<c:out value="/images2/sub/table_check.png" />" alt="필수입력요소"> 분류
															</c:otherwise>
														</c:choose>
													</c:when>
													<c:otherwise>기본 설정</c:otherwise>
												</c:choose>										
											</th>
											<td class="b_l_0" colspan="3">
												<c:if test="${boardConfVo.ctgYn eq 'Y'}">
													<select class="select_box" id="ctgCd" name="ctgCd" title="분류를 선택해주세요" style="width:245px;">
														<option value="">분류 선택</option>
														<c:forEach items="${boardConfVo.ctgList}" var="ctgVo" varStatus="status">
															<option value="${ctgVo.ctgCd}"<c:if test="${ctgVo.ctgCd == dataVo.ctgCd}" > selected="selected"</c:if>>${ctgVo.ctgNm}</option>
														</c:forEach>
													</select>
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
												<input type="hidden" name="openYn" value="Y" />
											</td>
										</tr>
									</c:if>
									<tr>
										<th><img src="/images2/sub/table_check.png">제목</th>
										<td class="b_l_0" colspan="3"><input type="text" name="title" id="title" style="width: 688px" value="${dataVo.title}"></td>
									</tr>
									<tr>
										<th><img src="/images2/sub/table_check.png">내용</th>
										<td class="b_l_0" colspan="3">
											<div id="contentsErrorDiv"></div>
												<c:if test="${boardConfVo.usrEditorYn eq 'Y'}" >
													<textarea name="contents" id="htmlContent" style="width: 688px;" rows="15" class="w99_p" title="내용을 입력해주세요">${dataVo.contents}</textarea>										
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
													<textarea name="contents" id="textContent" style="width: 688px; height: 192px;" cols="85" rows="10" style="width:527px;" title="내용을 입력해주세요">${dataVo.contents}</textarea>										
												</c:if>
										</td>
									</tr>
									<c:forEach var="extensionVo" items="${boardConfVo.formColunms}">
										<c:if test="${!empty extensionVo.columnType}">	
											<c:if test="${dataVo.bbsCd eq '1006'}">		
												<c:if test="${extensionVo.beanName eq 'extColumn2'}">		
													<tr>
														<th><c:if test="${extensionVo.requireYn eq 'Y'}"><img src="<c:out value="/images2/sub/table_check.png" />" alt="필수입력요소"></c:if> <label for="${extensionVo.beanName}">${extensionVo.columnNm}</label></th>
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
											</c:if>
											
											<c:if test="${dataVo.bbsCd ne '1006'}">	
												<c:if test="${extensionVo.beanName != 'extColumn4' && extensionVo.beanName != 'extColumn3'}" >
												<tr>
													<th><c:if test="${extensionVo.requireYn eq 'Y'}"><img src="<c:out value="/images2/sub/table_check.png" />" alt="필수입력요소"></c:if><label for="${extensionVo.beanName}"> ${extensionVo.columnNm}</label></th>
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
											</c:if>
										</c:if>
									</c:forEach>
									<c:if test="${dataVo.bbsCd ne '1006'}">
										<!-- 파일 업로드 -->
										<c:if test="${boardConfVo.fileYn eq 'Y'}" >
											<tr>
												<th class="p_l_30">파일첨부</th>
												<td class="b_l_0" colspan="3">
													<c:if test="${pageType eq 'UPDATE'}">
														<c:if test="${fn:length(dataVo.fileList) > 0}">
															<p class="tx_blue_s">
																- 기존 첨부파일을 <span class="tx_red">삭제</span>하시려면 아래 <span class="tx_red">X 아이콘을 클릭</span>하세요.
															</p>
															<ul>
																<c:forEach items="${dataVo.fileList}" var="fileVo">
																	<li class="mar_b5">
																		<a href="#" onclick="jsFileDelete(this, ${fileVo.fileSeq}, '${fileVo.fileId}');"><img src="<c:url value="/images2/sub/icon_del.png" />" /></a>
																		${fileVo.localNm} <span class="tx_gray vm">(download ${fileVo.downCnt}, ${fileVo.fileSize}, ${fileVo.fileType})</span>
																	</li>
																</c:forEach>
															</ul>
														</c:if>
													</c:if>
						
													<div class="mar_t5 mar_b5">
														<input type="hidden" name="fileSeq" id="fileSeq" value="${dataVo.fileSeq}" />
														<input type="file" name="multiFiles" id="multiFiles" style="width:688px; height:38px;" <c:if test="${boardConfVo.maxFileCnt <= dataVo.fileCnt}"> disabled="disabled"</c:if> title="찾아보기" />
														<div id="multiFilesListDiv" class="regist-file"></div>
													</div>
						
													<p class="ex">- txt, gul, pdf, hwp, xls, xlsx, ppt, pptx, doc, docx, jpg, jpeg, gif, png, bmp, eps, tif, cdr, pds, psp, dxf,<br/>
													&nbsp;&nbsp;&nbsp;&nbsp;dwg, dw 파일 첨부 가능, 최대 4개까지 업로드 할 수 있습니다. <br/>
													&nbsp;&nbsp;&nbsp;&nbsp;파일당 10MB, 전체 10MB 업로드 할 수 있습니다.</p>
													<input type="hidden" id="uploadFileCnt" value="${dataVo.fileCnt}" />
												</td>
											</tr>
										</c:if>
									</c:if>
								</tbody>
							</table>
						</div>
						<div class="btn_bl">
							<a href="#" id="btn_write">확인</a>
							<a href="PGUM0001.do" class="wht">취소</a>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<!-- content -->
</div>
<!-- wrap -->
</body>
</html>