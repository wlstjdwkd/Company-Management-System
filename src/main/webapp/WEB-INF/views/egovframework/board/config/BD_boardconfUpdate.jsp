<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="f" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<%@ page import="egovframework.board.config.BoardConfConstant" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
	<title>게시판 생성</title>

	<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask" />
	<ap:jsTag type="tech" items="msg,util,acm" />
	<ap:jsTag type="egovframework" items="boardconf" />
	
	<script type="text/javascript">
		//<CDATA[[
		var confTabz;
		var changeFlag = false;

		/* 공통 초기화 */
		$(document).ready(function(){
			var option = {
				//내용을 표시할 컨테이너는 지정할 수도 있으며 미지정 시 임의로 생성됨.
				tabContainer : "tabContainer",
				//공통 파라미터를 지정할 수 있음.
				baseParam: {
					bbsCd: "${dataVo.bbsCd}"
				},
				//로드전 이벤트 정의
				beforeLoad : function(event, item){
					if(changeFlag){
						if(confirm("변경 사항이 있습니다. 저장 후 이동하세요.")){
							return false;
						}else{
							changeFlag = false;
							return true;
						}
					}
					return true;
				},
				//로드 후 이벤트 정의
				afterLoad : function(event, item){
					changeFlag = false;
					return true;
				}
			};

			confTabz = $("#bbsConfTabDiv").jsTabUi(option);			
			
			// 유효성 검사
			$("#dataForm").validate({  
				rules : { 				
					bbsNm: "required"
	 			},
	 			submitHandler: function(form) {
	 				
					if(!customValidate()) {
	 					return;	
	 				}	 				
	 				
	 				$("#df_method_nm").val("updateBoardBaseConfModifyAction");
	 				
	 				$("#dataForm").ajaxSubmit({
	 					url      : "PGMS0080.do",
	 					type     : "post",
	 					dataType : "text",
	 					async    : false,
	 					success  : function(response) {
	 						try {						
	 							if(eval(response)) {							
	 								jsSuccessBox(Message.msg.processOk);
	 															
	 							} else {
	 								jsErrorBox(Message.msg.processFail);
	 							}
	 						} catch (e) {
	 							jsSysErrorBox(response, e);
	 							return;
	 						}
	 						changeFlag = false;
	 						jsReloadTab();
	 					}
	 				});	 					 				
	 				
	 			}
	 		});
			
			// 등록버튼
			$("#btn_submit").click(function(){
				if(!$('#dataForm').valid()){
					jsWarningBox(Message.msg.checkEssVal);
					return;
				}				
				$("#dataForm").submit();
			});
			
			// 취소버튼
			$("#btn_reset").click(function(){
				changeFlag=false;
				document.dataForm.reset();
			});

		});

		/*
		 * validate() 호출시 사용자 정의 검증을 자동으로 호출함
		 */
		var customValidate = function(){
			var ctgNmArray = $("input[name=ctgNms]").val();
			if($("input[name=ctgYn]:checked").val() == "Y" && ctgNmArray.length == 0){
				jsWarningBox("분류 사용 여부를 사용으로 선택 시 분류 정보를 설정해야 합니다.");
				$("#ctgNms").focus();
				return false;
			}
			return true;
		};
		//]]>
	</script>
</head>

<body>
 <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title"><font color="#aa4d10">${dataVo.bbsNm}</font>게시판 설정</h2>
                <!-- 타이틀 영역 //-->
                
				<!-- 탭 -->
				<div id="bbsConfTabDiv" class="tabwrap">
					<div class="tab">
						<ul>
							<li class="on"><a href="#globalDiv"><span>기본 정보</span></a></li>
							<li><a href="<c:url value="${svcUrl}?df_method_nm=boardConfUpdateSubListConfig"/>"><span>목록 설정</span></a></li>
							<li><a href="<c:url value="${svcUrl}?df_method_nm=boardConfUpdateSubListArrangeConfig"/>"><span>목록 배치</span></a></li>
							<li><a href="<c:url value="${svcUrl}?df_method_nm=boardConfUpdateViewConfig"/>"><span>상세조회 설정</span></a></li>
							<li><a href="<c:url value="${svcUrl}?df_method_nm=boardConfUpdateViewArrangeConfig"/>"><span>상세조회 배치</span></a></li>
							<li><a href="<c:url value="${svcUrl}?df_method_nm=boardConfUpdateRegFormConfig"/>"><span>입력폼 설정</span></a></li>
							<li><a href="<c:url value="${svcUrl}?df_method_nm=boardConfUpdateExtConfig"/>"><span>항목관리</span></a></li>
						</ul>
					</div>
				</div>
				<!-- //탭 -->
				
				<div id="globalDiv">
				
					<form name="dataForm" id="dataForm" method="post" >
				
						<%-- 페이징 관련 파라미터 생성. view 설정 모든 검색 파라미터가 hidden으로 생성됨 --%>
						<op:pagerParam view="view" />
						<input type="hidden" name="bbsCd" id="bbsCd" value="${dataVo.bbsCd}" />
						<input type="hidden" name="gubunCd" value="<%= BoardConfConstant.GUBUN_CD_GLOBAL %>" />
						
						<!-- 검색조건 유지 -->
						<input type="hidden" name="q_searchKey" id="q_searchKey" value="${param.q_searchKey}" />
						<input type="hidden" name="q_searchVal" id="q_searchVal" value="${param.q_searchVal}" />
						
							
						<ap:include page="param/defaultParam.jsp" />
						<ap:include page="param/dispParam.jsp" />
						<ap:include page="param/pagingParam.jsp" />
					
						<!-- 내용쓰기 -->
						<fieldset>
							<legend>글입력</legend>
							<table class="table_basic" cellspacing="0" border="0" summary="게시판 내용 작성페이지입니다.">
								<caption class="hidden">게시판 생성 페이지</caption>
								<colgroup>
									<col width="15%" />
									<col width="85%" />
								</colgroup>
								<tbody>
									<tr>
										<th class="point"><label for="bbsNm">게시판 명</label></th>
										<td>
											<input type="text" name="bbsNm" id="bbsNm" style="width:762px"  title="게시판 명" value="${dataVo.bbsNm}" onchange="jsChkValueChange('text', 'bbsNm', '${dataVo.bbsNm}');" />
											<span class="tx_red">(최대 30자)</span>											
										</td>
									</tr>
									<tr>
										<th><label for="bbsDesc" class="mgl_23">게시판 개요</label></th>
										<td>
											<textarea id="bbsDesc" name="bbsDesc" rows="3" style="width:756px"  title="게시판 개요" onchange="jsChkValueChange('textarea', 'bbsDesc', '${dataVo.bbsDesc}');">${dataVo.bbsDesc}</textarea>
											<span class="tx_red">(최대 30자)</span>											
										</td>
									</tr>
									<tr>
										<th rowspan="3" class="point"><label for="kindCd">게시판 종류</label></th>
										<td>
											<!-- <f:select path="dataVo.kindCd" id="kindCd" items="${kindCdMap}" onchange="jsChkValueChange('select', 'kindCd', '${dataVo.kindCd}');" />
											<valid:msg name="kindCd" /> -->
											목록 : <select id="listSkin" name="listSkin" class="mar_b5"  style="width:729px">
												<c:forEach items="${listTemplates}" var="list">
													<option value="${list.templateId}"<c:if test="${list.templateId eq dataVo.listSkin}"> selected</c:if>>${list.templateNm}</option>
												</c:forEach>
											</select>
										</td>
									</tr>
									<tr>
										<td>
											<!-- <f:select path="dataVo.kindCd" id="kindCd" items="${kindCdMap}" onchange="jsChkValueChange('select', 'kindCd', '${dataVo.kindCd}');" />
											<valid:msg name="kindCd" /> -->
											읽기 : <select id="viewSkin" name="viewSkin" class="mar_b5" style="width:729px">
												<c:forEach items="${viewTemplates}" var="view">
													<option value="${view.templateId}"<c:if test="${view.templateId eq dataVo.viewSkin}"> selected</c:if>>${view.templateNm}</option>
												</c:forEach>
											</select>
										</td>
									</tr>
									<tr>
										<td>
											<!-- <f:select path="dataVo.kindCd" id="kindCd" items="${kindCdMap}" onchange="jsChkValueChange('select', 'kindCd', '${dataVo.kindCd}');" />
											<valid:msg name="kindCd" /> -->
											쓰기 : <select id="formSkin" name="formSkin" style="width:729px">
												<c:forEach items="${formTemplates}" var="form">
													<option value="${form.templateId}"<c:if test="${form.templateId eq dataVo.formSkin}"> selected</c:if>>${form.templateNm}</option>
												</c:forEach>
											</select>
										</td>
									</tr>
									<tr>
										<th class="point"><label for="ctgYn">분류 사용 여부</label></th>
										<td>
											<input type="radio" name="ctgYn" id="ctgYn_Y" value="Y"<c:if test="${dataVo.ctgYn eq 'Y'}"> checked="checked"</c:if> onclick="jsChkValueChange('radio', 'ctgYn', '${dataVo.ctgYn}'); $('#ctgNmsTR').show();" />
											<label for="ctgYn_Y">사용</label>
											<input type="radio" name="ctgYn" id="ctgYn_N" value="N"<c:if test="${dataVo.ctgYn eq 'N'}"> checked="checked"</c:if> onclick="jsChkValueChange('radio', 'ctgYn', '${dataVo.ctgYn}'); $('#ctgNmsTR').hide();" />
											<label for="ctgYn_N">미사용</label>											
										</td>
									</tr>
									<tr id="ctgNmsTR"<c:if test="${dataVo.ctgYn eq 'N'}"> style="display:none"</c:if>>
										<th><label for="ctgNms" class="mgl_23">분류 설정</label></th>
										<td>
											<input type="text" name="ctgNms" id="ctgNms" style="width:762px" value="${fn:join(dataVo.ctgNms, ', ')}" title="분류명" onchange="jsChkValueChange('text', 'ctgNms', '${dataVo.ctgNms}');" />
											<p class="tx_red">(쉼표로 구분하여 분류명을 입력해 주세요. 입력한 순서대로 정렬순번이 지정됩니다.)</p>
										</td>
									</tr>
									<tr>
										<th class="point"><label for="noticeYn">공지글 사용 여부</label></th>
										<td>
											<c:if test="${dataVo.listSkin eq 'basic'}">
												<input type="radio" name="noticeYn" id="noticeYn_Y" value="Y"<c:if test="${dataVo.noticeYn eq 'Y'}"> checked="checked"</c:if> onclick="jsChkValueChange('radio', 'noticeYn', '${dataVo.noticeYn}');" />
												<label for="noticeYn_Y">사용</label>
												<input type="radio" name="noticeYn" id="noticeYn_N" value="N"<c:if test="${dataVo.noticeYn eq 'N'}"> checked="checked"</c:if> onclick="jsChkValueChange('radio', 'noticeYn', '${dataVo.noticeYn}');" />
												<label for="noticeYn_N">미사용</label>
												기본형게시판 외에는 공지글을 미사용으로 설정하시기 바랍니다.
											</c:if>
											<c:if test="${dataVo.listSkin ne 'basic'}">
												해당유형 게시판은 공지글을 사용 할 수 없습니다.<input type="hidden" name="noticeYn" value="N" />
											</c:if>
										</td>
									</tr>
									<tr>
										<th class="point"><label for="commentYn">댓글 사용 여부</label></th>
										<td>
											<c:if test="${dataVo.listSkin eq 'basic'}">
												<input type="radio" name="commentYn" id="commentYn_Y" value="Y"<c:if test="${dataVo.commentYn eq 'Y'}"> checked="checked"</c:if> onclick="jsChkValueChange('radio', 'commentYn', '${dataVo.commentYn}');" />
												<label for="commentYn_Y">사용</label>
												<input type="radio" name="commentYn" id="commentYn_N" value="N"<c:if test="${dataVo.commentYn eq 'N'}"> checked="checked"</c:if> onclick="jsChkValueChange('radio', 'commentYn', '${dataVo.commentYn}');" />
												<label for="commentYn_N">미사용</label>
												기본형게시판 외에는 댓글을 미사용으로 설정하시기 바랍니다.
											</c:if>
											<c:if test="${dataVo.listSkin ne 'basic'}">
												해당유형 게시판은 댓글을 사용 할 수 없습니다.<input type="hidden" name="commentYn" value="N" />
											</c:if>
										</td>
									</tr>									
								</tbody>
							</table>
						</fieldset>
						<!-- //내용쓰기 -->
						
						<!-- 버튼 -->
						<div class="btn_page_last">
							<a href="#none" class="btn_page_admin" id="btn_submit"><span>등록</span></a>
							<a href="#none" class="btn_page_admin" id="btn_reset"><span>취소</span></a>
							<a href="#none" class="btn_page_admin" onclick="jsList();"><span>목록</span></a>
						</div>
						<!-- //버튼 -->
						
					</form>
				</div>
				
			</div>
		</div>
</div>

</body>
</html>