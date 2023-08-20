<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<%@ page import="egovframework.board.config.BoardConfConstant" %>
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	
<html>
<head>
	<title>게시물 상세</title>

	<ap:jsTag type="web" items="jquery,validate,notice,colorbox,multifile" />
	<ap:jsTag type="tech" items="msg,util,acm" />
	<ap:jsTag type="egovframework" items="board" />

	<!-- 사용자 스크립트 시작 -->
	<script type="text/javascript">
	_boardSvcUrl = "${svcUrl}";
	var cmtTabz;

	$().ready(function(){
		//게시판 설정값들을 초기화 합니다.
		if(typeof Ahpek == "undefined"){ Ahpek = {}; }
		Ahpek.pageType			= '${pageType}';
		Ahpek.boardType			= '${boardConfVo.kindCd}';
		Ahpek.boardNm			= '${boardConfVo.bbsNm}';
		Ahpek.useCategory		= '${boardConfVo.ctgYn}';
		Ahpek.fileYn			= '${boardConfVo.fileYn}';
		Ahpek.fileExts			= '${boardConfVo.fileExts}';
		Ahpek.maxFileCnt		= "${boardConfVo.maxFileCnt}";
		Ahpek.maxFileSize		= "${boardConfVo.maxFileSize}";
		Ahpek.totalFileSize		= "${boardConfVo.totalFileSize}";
		Ahpek.closeFileIcon		= "<c:url value='/images/acm/icon_del.png' />";
		Ahpek.captchaYn			= '${boardConfVo.captchaYn}';
		Ahpek.readCookieHour	= '${boardConfVo.readCookieHour}';
		Ahpek.commentYn			= '${boardConfVo.commentYn}';
		Ahpek.bbsCd				= '${dataVo.bbsCd}';
		Ahpek.seq				= '${dataVo.seq}';
		Ahpek.searchVal			= '${param.q_searchVal}';
		Ahpek.searchKey			= '${param.q_searchKey}';
		Ahpek.sortName			= '${param.q_sortName}';
		Ahpek.sortOrder			= '${param.q_sortOrder}';
		Ahpek.tagYn				= "${boardConfVo.tagYn}";
		Ahpek.listViewCd		= '${boardConfVo.listViewCd}';
		Ahpek.showSummaryYn		= '${param.showSummaryYn}';		

		onReadyEventFunctions();
		
		// 확인 버튼
		$("#btn_submit").click(function(){
			$("#replyForm").attr("action", '${svcUrl}' + "?df_method_nm=updateBoardAnswer");
			$("#replyForm").submit();
		});
		
		// validate
		$("#replyForm").validate({
			rules: {
				replyContents: {required:true}
			},			
			submitHandler: function(form) {
				var itemNoVal = $("input[name='extColumn1']:checked").val();
		        if(itemNoVal != 'D'){
	                if(!confirm("상태를 완료로 변경하지 않으면 신청자는 답변을 볼 수 없습니다.\n이대로 저장하시겠습니까?")){
	                    return;    
	                };
	            }
		        		        
		        form.submit();
			}
		});
		
		//파일 업로드 설정
		SharedAhpek.jsSetMultiFile();
		
	});
	
	
	//첨부파일 다운로드
	function downAttFile(fileId){
		jsFiledownload("/PGCM0040.do","df_method_nm=updateFileDown&id="+fileId);
	}
	
	//첨부된 파일중 ajax를 이용하여 파일 삭제
	var jsFileDelete = function(element, seq, id){
		if(!confirm("선택한 파일을 정말 삭제하시겠습니까?\n삭제 후 복구는 불가능 합니다."))
			return false;

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
					alert('파일을 삭제하지 못했습니다.');
				}
			}, 'json');
	};
	
	function fn_userInfo(regId) {
		$.colorbox({
			title : "회원정보",
			href : "<c:url value='/PGMY0070.do?df_method_nm=popUserInfo&ad_regId=" + regId + "' />",
			width : "700",
			height : "450",
			overlayClose : false,
			escKey : false,
			iframe : true
		});
	}
	
	</script>
	<!-- 사용자 스크립트 끝 -->
	
</head>
<body>
	<div id="self_dgs">
		<div class="pop_q_con">
		
			<c:set var="colspan" value="5" />
		
			<!-- 내용보기 -->			
			<table class="table_basic">
				<caption class="hidden">${dataVo.title} 상세보기</caption>
				<colgroup>
					<col style="width:150" />
                    <col />
                    <col style="width:150" />
                    <col />
                    <col style="width:150" />
                    <col />
				</colgroup>
				<thead>
					<tr>
						<th colspan="6" scope="colgroup">${dataVo.title}</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th scope="col">상태</th>
						<td>																											
						<c:choose>
							<c:when test="${dataVo.extColumn1 eq 'A'}">신청</c:when>
							<c:when test="${dataVo.extColumn1 eq 'B'}">접수</c:when>
							<c:when test="${dataVo.extColumn1 eq 'C'}">답변중</c:when>
							<c:when test="${dataVo.extColumn1 eq 'D'}">답변완료</c:when>
							<c:otherwise>&nbsp;</c:otherwise>
						</c:choose>									
						</td>
						<th scope="col">작성일</th>
						<td>${fn:substring(dataVo.regDt,0,10)}</td>
						<th scope="col">작성자</th>
						<td><a href="#none" onclick="fn_userInfo('${dataVo.regId}')">${dataVo.regNm }</a></td>
					</tr>
					<tr>
						<th scope="col">기업명</th>
						<td><c:if test="${!empty entrprsNm }"> ${entrprsNm }</c:if></td>
						<th scope="col" conspan="6">법인등록번호</th>
						<td><c:if test="${!empty jurirno }"> ${fn:substring(jurirno, 0, 6)}-${fn:substring(jurirno, 6, 13)}</c:if></td>
					</tr>
					<tr>
						<c:if test="${boardConfVo.usrEditorYn eq 'Y'}" >
							<td colspan="6" class="cont" id="emailCnHtml"></td>
                    		<input type="hidden" id="email_cn_html" value="${dataVo.contents }" />
                    		<script type="text/javascript">$("#emailCnHtml").html($("#email_cn_html").val());</script>
                    	</c:if>
						<c:if test="${boardConfVo.usrEditorYn eq 'N'}" >
                        	<td colspan="6" class="cont">
								${dataVo.contents }
							</td>
                        </c:if>
					</tr>
				
					<!-- 상세 배치에서 설정한 항목 배치 -->
					<c:set var="scoreRow" value="1" />
					<c:forEach items="${boardConfVo.viewArrange}" var="arrange" varStatus="arrStatus">
						<c:choose>
							<c:when test="${arrange.columnId eq 'CTG_CD'}">
								<!-- 분류 -->
								<c:if test="${boardConfVo.ctgYn eq 'Y'}">
									<tr>
										<th><label for="${arrange.beanNm}">${arrange.columnNm}</label></th>
										<td colspan="${colspan}">${dataVo.ctgNm} [${dataVo.ctgCd}]</td>
									</tr>
								</c:if>
							</c:when>
	
							<c:when test="${arrange.columnId eq 'SCORE_CNT' || arrange.columnId eq 'SCORE_SUM'}">
								<!-- 만족도 -->
								<c:if test="${boardConfVo.stfyYn eq 'Y' && scoreRow == 1}">
									<tr>
										<th><label for="${arrange.beanNm}">${arrange.columnNm}</label></th>
										<td colspan="${colspan}">
											<form name="scoreForm" id="scoreForm" method="post" action="ND_score.action.do">
												<input type="hidden" name="bbsCd" id="bbsCd" value="${dataVo.bbsCd}" />
												<input type="hidden" name="seq" id="seq" value="${dataVo.seq}" />
												<span class="tx_b vm">평균평점 : <span id="boardScoreAvgSapn" class="tx_orange">${dataVo.scoreAvg}</span></span>
												<select name="scoreSum" class="mar_l5 vm">
													<option value="0">선택</option>
													<option value="1">1점</option>
													<option value="2">2점</option>
													<option value="3">3점</option>
													<option value="4">4점</option>
													<option value="5">5점</option>
													<option value="6">6점</option>
													<option value="7">7점</option>
													<option value="8">8점</option>
													<option value="9">9점</option>
													<option value="10">10점</option>
												</select>
												<input type="submit" class="s_blue vm" value="평점주기" />
											</form>
										</td>
									</tr>
									<c:set var="scoreRow" value="${scoreRow + 1}" />
								</c:if>
							</c:when>
	
							<c:when test="${arrange.columnId eq 'RECOM_CNT'}">
								<!-- 추천 -->
								<c:if test="${boardConfVo.recommYn eq 'Y'}">
									<tr>
										<th><label for="${arrange.beanNm}">${arrange.columnNm}</label></th>
										<td colspan="${colspan}">
											<input type="button" id="recomBtn" class="s_blue vm" value="추천 ${dataVo.recomCnt}" onclick="jsClickRecommAction(this, ${dataVo.bbsCd}, '${dataVo.seq}', ${boardConfVo.readCookieHour});" />
											<script type="text/javascript">$("#recomBtn").val("추천 ${dataVo.recomCnt}");</script>
										</td>
									</tr>
								</c:if>
							</c:when>
	
							<c:when test="${arrange.columnId eq 'ACCUSE_CNT'}">
								<!-- 신고 -->
								<c:if test="${boardConfVo.sueYn eq 'Y'}">
									<tr>
										<th><label for="${arrange.beanNm}">${arrange.columnNm}</label></th>
										<td colspan="${colspan}">
											<input type="button" id="accuseBtn" class="s_blue vm" value="신고 ${dataVo.accuseCnt}" onclick="jsClickAccuseAction(this, ${dataVo.bbsCd}, '${dataVo.seq}', ${boardConfVo.readCookieHour});" />
											<script type="text/javascript">$("#accuseBtn").val("신고 ${dataVo.accuseCnt}");</script>
										</td>
									</tr>
								</c:if>
							</c:when>
							<c:when test="${arrange.columnId eq 'FILE_SEQ'}">
								<!-- 첨부파일 -->
								<c:if test="${!empty dataVo.fileList}">
									<tr>
										<th>첨부파일</th>
										<td colspan="${colspan}">											
											<c:choose>
												<c:when test="${fn:length(dataVo.fileList) > 0}">
													<c:forEach items="${dataVo.fileList}" var="fileVo">
														<%-- <li>
															<img src="/resources/openworks/theme/default/images/icon/icon_file_jpg.gif" class="vm" alt="파일 첨부" />
															<a href="/component/file/ND_fileDownload.do?id=${fileVo.fileId}" title="${fileVo.fileDesc}">${fileVo.localNm}</a>
															<span class="tx_gray">(download ${fileVo.downCnt}, ${fileVo.fileSize}, ${fileVo.fileType})</span>
															<button type="button" class="gray_s mar_l10" onclick="jsShowFileHistory('${fileVo.fileSeq}', '${fileVo.fileId}');">이력보기</button>
														</li> --%>														
														<a href="#none" onclick="downAttFile('${fileVo.fileId}')" class="dw_fild" title="${fileVo.fileDesc}">
															${fileVo.localNm} [${fileVo.fileSize} byte]	
														</a>
													</c:forEach>
												</c:when>
												<c:otherwise>
													첨부파일이 없습니다.
												</c:otherwise>
											</c:choose>											
										</td>
									</tr>
								</c:if>
							</c:when>
	
							<c:otherwise>
								<!-- 기타 항목 -->
								<tr>
									<th>${arrange.columnNm}</th>
									<td colspan="${colspan}"><ap:bean-util field="${arrange.columnId}" obj="${dataVo}"/></td>
								</tr>
							</c:otherwise>
						</c:choose>
					</c:forEach>
	
					<!-- 태그 -->
					<c:if test="${boardConfVo.tagYn eq 'Y'}">
						<tr>
							<td colspan="2">
								<div class="tag">
									<img src="/resources/openworks/theme/default/images/icon/icon_tag.gif" alt="태그" class="vm" />
									<c:if test="${empty dataVo.bbsTags}">등록된 태그가 없습니다.</c:if>
									<c:if test="${!empty dataVo.bbsTags}">
										<c:forEach var="tag" items="${dataVo.bbsTags}" varStatus="status">
											<a href="#" onclick="jsShowBbsListByTag('${tag}')">${tag}</a> <c:if test="${not status.last}">|</c:if>
										</c:forEach>
									</c:if>
								</div>
							</td>
						</tr>
					</c:if>
				</tbody>
			</table>
			
		
			<form name="replyForm" id="replyForm" method="post" enctype="multipart/form-data">				
		
				<input type="hidden" name="bbsCd" value='${dataVo.bbsCd}' />
				<input type="hidden" name="seq" value='${dataVo.seq}' />
				<input type="hidden" name="mgrNm" id="mgrNm" value="${dataVo.mgrNm}" />				
		
				<!-- 답변 달기 -->
				<div class="block">
                    <h3 class="mgt30"> <span>항목은 입력 필수 항목 입니다.</span> </h3>
					<table class="table_basic">
						<caption class="hidden">${dataVo.title} 답변달기</caption>
						<colgroup>
							<col style="width:150" />
	                        <col />
	                        <col style="width:150" />
	                        <col />
	                        <col style="width:150" />
	                        <col />
						</colgroup>
						<thead>
                            <tr>
                                <th colspan="6" scope="colgroup">답변내용입니다.</th>
                            </tr>
                        </thead>
						<tbody>
							<tr>
                                <th class="point" scope="col">상태</th>
                                <td>
                                	<input type="radio" name="extColumn1" id="extColumn1_A" value="A"<c:if test="${dataVo.extColumn1 eq 'A'}"> checked="checked"</c:if> />
                                    <label for="extColumn1_A" class="mgr30">신청</label>
                                    <input type="radio" name="extColumn1" id="extColumn1_B" value="B"<c:if test="${dataVo.extColumn1 eq 'B'}"> checked="checked"</c:if> />
                                    <label for="extColumn1_B" class="mgr30">접수</label>
                                    <input type="radio" name="extColumn1" id="extColumn1_C" value="C"<c:if test="${dataVo.extColumn1 eq 'C'}"> checked="checked"</c:if> />
                                    <label for="extColumn1_C" class="mgr30">답변중</label>
                                    <input type="radio" name="extColumn1" id="extColumn1_D" value="D"<c:if test="${dataVo.extColumn1 eq 'D'}"> checked="checked"</c:if> />
                                    <label for="extColumn1_D">답변완료</label>
                                </td>
                                <th scope="col">답변일</th>
                                <td>${today }</td>
                                <th scope="col">처리자</th>
                                <td>${dataVo.mgrNm }</td>
                            </tr>
							<%-- <tr>
								<th><label for="mgrNm">작성자 <span class="tx_red tx_b">*</span></label></th>
								<td colspan="${colspan}"><input type="text" name="mgrNm" id="mgrNm" maxlength="10" value="${dataVo.mgrNm}" /></td>
							</tr> --%>
							<%-- <c:if test="${boardConfVo.openYn eq 'Y' }">
							<tr>
								<th class="point" scope="col">공개여부전환</th>								
								<td colspan="${colspan}">
									<input type="radio" class="radio" name="openYn" id="openYnN" value="N"<c:if test="${dataVo.openYn eq 'N'}"> checked='checked'</c:if> /><label for="openYnN">비공개</label>
									<input type="radio" class="radio" name="openYn" id="openYnY" value="Y"<c:if test="${empty dataVo.openYn or dataVo.openYn eq 'Y'}"> checked='checked'</c:if> /><label for="openYnY">공개</label>
									<span class="tx_blue_s">- 내용에 따라 공개여부를 변경합니다.</span>
								</td>
							</tr>
							</c:if>							 --%>
							<tr>
								<th class="point" scope="col"><label for="replyContents">답변</label></th>
								<td colspan="${colspan}"><textarea name="replyContents" id="replyContents" rows="15" cols="30" class="w99_p">${dataVo.replyContents}</textarea></td>
							</tr>
							<tr>
								<th rowspan="2" scope="row">파일첨부</th>
								<td colspan="${colspan}" class="rows" id="fileTd">
									<%-- <c:if test="${pageType eq 'UPDATE'}"> --%>
									<c:if test="${fn:length(dataVo.ansFileList) > 0}">
										<p class="tx_blue_s">
											- 기존 첨부파일을 <span class="tx_red">삭제</span>하시려면 아래 <span class="tx_red">X 아이콘을 클릭</span>하세요.
										</p>
										
										<c:forEach items="${dataVo.ansFileList}" var="fileVo">
											<div>																						
												<a href="#" onclick="jsFileDelete(this, ${fileVo.fileSeq}, '${fileVo.fileId}');"><img id="fileImg" src="<c:url value="/images/acm/icon_del.png" />" alt="파일첨부" /></a>
												${fileVo.localNm} <span class="tx_gray vm">(download ${fileVo.downCnt}, ${fileVo.fileSize}, ${fileVo.fileType})</span>
											</div>																			
										</c:forEach>
										
									</c:if>
									<%-- </c:if> --%>
		
									<div class="mar_t5 mar_b5">
										<input type="hidden" name="ansFileSeq" id="ansFileSeq" value="${dataVo.ansFileSeq}" />
										<input type="file" name="multiFiles" id="multiFiles" <c:if test="${boardConfVo.maxFileCnt <= dataVo.ansFileCnt}"> disabled="disabled"</c:if> title="찾아보기" />
										<div id="multiFilesListDiv" class="regist-file"></div>
									</div>																																							
									<input type="hidden" id="uploadFileCnt" value="${dataVo.ansFileCnt}" />
								</td>
							</tr>
							<tr>
	                            <td colspan="${colspan}" class="rows">
	                            	<p class="txt_list_i">                            	
	                            		<span>※</span> 
	                            		<c:if test="${fn:length(boardConfVo.fileExts) >= 3 }"><script type="text/javascript">document.write("${boardConfVo.fileExts}".replace(/\|/g, ', ')); </script> 파일 첨부 가능, </c:if>
										최대 ${boardConfVo.maxFileCnt}개까지 업로드 할 수 있습니다.
										<c:if test="${boardConfVo.maxFileSize > 0}">파일당 ${boardConfVo.maxFileSize}MB</c:if>
										<c:if test="${(boardConfVo.maxFileSize > 0) && (boardConfVo.totalFileSize > 0)}">, </c:if>
										<c:if test="${boardConfVo.totalFileSize > 0}">전체 ${boardConfVo.totalFileSize}MB</c:if>
										<c:if test="${(boardConfVo.maxFileSize > 0) || (boardConfVo.totalFileSize > 0)}"> 업로드 할 수 있습니다.</c:if>
	                            	</p>
	                            </td>
	                        </tr>
						</tbody>
					</table>
				</div>
			</form>
		
			<!-- 댓글 -->
			<%-- <c:if test="${boardConfVo.commentYn eq 'Y'}">
				<br/><div id="attachedCommentsDiv" class="comment block"></div>
			</c:if> --%>
			<!-- //댓글 -->
		
			<!-- 버튼 -->
			<div class="btn_page_last">
				<a class="btn_page_admin" href="#" onclick="jsList('${param.df_curr_page}');"><span>목록</span></a>
				<a class="btn_page_admin" href="#" onclick="jsDelete();"><span>삭제</span></a>
				<a class="btn_page_admin" href="#" id="btn_submit"><span>확인</span></a>
			</div>			
			<%-- <div class="mar_t10">
				<div class="float_l mar_b10">
					<c:if test="${boardConfVo.listViewCd eq 1001}">
						<button type="button" class="w_blue mar_r5" onclick="jsView('${dataVo.prevVO.bbsCd}', '${dataVo.prevVO.seq}', '${dataVo.prevVO.regPwd}', '${dataVo.prevVO.openYn}'); return false;">이전</button>
						<button type="button" class="w_blue mar_r5" onclick="jsView('${dataVo.nextVO.bbsCd}', '${dataVo.nextVO.seq}', '${dataVo.nextVO.regPwd}', '${dataVo.nextVO.openYn}'); return false;">다음</button>
					</c:if>
				</div>
				<div class="float_r mar_b10">
					<c:if test="${MenuAssignType eq 'A' or MenuAssignType eq 'G'}">
						<button type="button" class="blue mar_l5" onclick="jsAnswerAction();">저장</button>
					</c:if>
					<button type="button" class="w_blue mar_r5" onclick="jsList('${param.q_currPage}'); return false;">목록</button>							
				</div>
			</div> --%>
			<!-- //버튼 -->
		
			<!-- 목록 보여주기 시작 -->
			<form name="dataForm" id="dataForm" method="post">				
		
				<!-- 다음/이전을 목록으로 보기 -->
				<c:if test="${boardConfVo.listViewCd == 1003}">
					<!-- 목록 삽입 -->
					<p class="mar_t10">&nbsp;</p>
					<%@include file="INC_boardList.jsp" %>
		
					<!-- 페이징 영역 시작 -->
					<%-- <op:pager pager="${pager}" script="jsListReq" /> --%>
					<!-- 페이징 영역 끝 -->
				</c:if>
				<!-- 다음/이전을 목록으로 보기 -->
		
				<!-- 다음/이전을 다음/이전으로 보기 -->
				<c:if test="${boardConfVo.listViewCd == 1002}">
					<%@ include file="../common/INC_prevNextList.jsp" %>
				</c:if>
				<!-- 다음/이전을 다음/이전으로 보기 끝 -->
		
				<input type="hidden" name="showSummaryYn" value="${param.showSummaryYn}" />
				<input type="hidden" name="listShowType" value="${param.listShowType}" />
		
				<input type="hidden" name="bbsCd" value="${dataVo.bbsCd}" />
				<input type="hidden" name="seq" value="${dataVo.seq}" />
				<input type="hidden" name="refSeq" value="${dataVo.refSeq}" />
				<input type="hidden" name="regPwd" value="${dataVo.regPwd}" />
		
				<input type="hidden" name="iconKey" value="" />
				<input type="hidden" name="contents" value="" />
				<input type="hidden" name="ctgCd" id="ctgCd" value="" />
				<input type="hidden" name="pageType" id="pageType" value="" />
		
				<!-- 이동옵션 -->
				<input type="hidden" name="toBbsCd" id="toBbsCd" value="" />
				<input type="hidden" name="newCtg" id="newCtg" value=-1 />
				<input type="hidden" name="delDesc" id="delDesc" value="" />
				<input type="hidden" name="isMove" id="isMove" value="" />
				
				<!--  검색유지 -->
				<input type="hidden" name="q_searchVal" id="q_searchVal" value="${param.q_searchVal}" />
				<input type="hidden" name="q_searchKeyType" id="q_searchKeyType" value="${param.q_searchKeyType}" />
				<input type="hidden" name="q_dateType" id="q_dateType" value="${param.q_dateType}" />
				<input type="hidden" name="q_pjtStartDt" id="q_pjtStartDt" value="${param.q_pjtStartDt}" />
				<input type="hidden" name="q_pjtEndDt" id="q_pjtEndDt" value="${param.q_pjtEndDt}" />
				<input type="hidden" name="q_sttsType" id="q_sttsType" value="${param.q_sttsType}" />
				
				<!-- default values -->		
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />
			</form>
		</div>
	</div>		

</body>
</html>