<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="f" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<%@ page import="egovframework.board.config.BoardConfConstant" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />

<ap:jsTag type="web" items="jquery,cookie,form,notice,ui,validate,mask" />
<ap:jsTag type="tech" items="msg,util,acm" />
<ap:jsTag type="egovframework" items="boardconf" />
<script type="text/javascript">
	var confTabz;

	$().ready(function(){
		
		// MASK
		$("#readCookieHour").mask('000');
		
		$("#viewConfigForm").validate({
			rules : {
				readCookieHour : { required : true, maxlength : 3, number : true }
			},
			submitHandler: function(form){
				$("#df_method_nm").val("updateBoardDetailConfModifyAction");
				$(form).ajaxSubmit({
					url		: "PGMS0080.do",
					type	: "POST",
					dataType: "text",
					success : function(response){
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
			}
		});
		
		// 등록버튼
		$("#btn_submit").click(function(){
			if(!$('#viewConfigForm').valid()){
				jsWarningBox(Message.msg.checkEssVal);
				return;
			}				
			$("#viewConfigForm").submit();
		});
		
		// 취소버튼
		$("#btn_reset").click(function(){
			changeFlag=false;
			document.viewConfigForm.reset();
		});
		
	});
</script>

<!-- 캡션 영역 시작 -->
<div class="bbs-caption">
	<div class="caption-right"> 
		<span id="viewResult" class="result"></span>
	</div>
</div>
<!-- 캡션 영역 끝 -->

<form id="viewConfigForm" name="viewConfigForm" >
<input type="hidden" name="bbsCd" value="${dataVo.bbsCd}" />
<input type="hidden" name="gubunCd" value="<%=BoardConfConstant.GUBUN_CD_VIEW%>" />
<ap:include page="param/defaultParam.jsp" />

	<!-- 게시판 목록 시작 -->
	<fieldset>
		<legend>상세조회 설정</legend>
		<table class="table_basic" border="0" cellspacing="0" cellpadding="0" summary="상세설정 정보를 표시" >
			<caption>상세조회 설정</caption>
			<colgroup>
				<col width="15%" />
				<col width="85%" />
			</colgroup>
			<tbody>
				<tr>
					<th class="point"><label for="listViewCd">하단 목록 표시 방법</label></th>
					<td>
						<f:select path="dataVo.listViewCd" id="listViewCd" items="${listViewCdMap}" onchange="jsChkValueChange('select', 'listViewCd', '${dataVo.listViewCd}');" style="width:589px" />
					</td>
				</tr>
				<tr>
					<th class="point"><label for="recommYn">추천 사용 여부</label></th>
					<td>
						<input type="radio" name="recommYn" id="recommYn_Y" value="Y" class="radio"<c:if test="${dataVo.recommYn == 'Y'}"> checked="checked"</c:if> onclick="jsChkValueChange('radio', 'recommYn', '${dataVo.recommYn}');" /> 
						<label for="recommYn_Y">사용</label> 
						<input type="radio" name="recommYn" id="recommYn_N" value="N" class="radio"<c:if test="${dataVo.recommYn == 'N'}"> checked="checked"</c:if> onclick="jsChkValueChange('radio', 'recommYn', '${dataVo.recommYn}');" /> 
						<label for="recommYn_N">미사용</label>
						<span class="tx_red">(게시글의 추천 기능을 이용하고자 한다면 사용으로 설정하세요.)</span>
					</td>
				</tr>
				<tr>
					<th class="point"><label for="sueYn">신고 사용 여부</label></th>
					<td>
						<input type="radio" name="sueYn" id="sueYn_Y" value="Y" class="radio"<c:if test="${dataVo.sueYn == 'Y'}"> checked="checked"</c:if> onclick="jsChkValueChange('radio', 'sueYn', '${dataVo.sueYn}');" />
						<label for="sueYn_Y">사용</label> 
						<input type="radio" name="sueYn" id="sueYn_N" value="N" class="radio"<c:if test="${dataVo.sueYn == 'N'}"> checked="checked"</c:if> onclick="jsChkValueChange('radio', 'sueYn', '${dataVo.sueYn}');" /> 
						<label for="sueYn_N">미사용</label>
						<span class="tx_red">(게시글의 신고 기능을 이용하고자 한다면 사용으로 설정하세요.)</span>
					</td>
				</tr>
				<tr>
					<th class="point"><label for="stfyYn">만족도 사용 여부</label></th>
					<td>
						<input type="radio" name="stfyYn" id="stfyYn_Y" value="Y" class="radio"<c:if test="${dataVo.stfyYn == 'Y'}"> checked="checked"</c:if> onclick="jsChkValueChange('radio', 'stfyYn', '${dataVo.stfyYn}');" />
						<label for="stfyYn_Y">사용</label> 
						<input type="radio" name="stfyYn" id="stfyYn_N" value="N" class="radio"<c:if test="${dataVo.stfyYn == 'N'}"> checked="checked"</c:if> onclick="jsChkValueChange('radio', 'stfyYn', '${dataVo.stfyYn}');" /> 
						<label for="stfyYn_N">미사용</label>
						<span class="tx_red">(게시글에 대한 사용자 만족도를 입력받고자 한다면 사용으로 설정하세요.)</span>
					</td>
				</tr>
				<tr>
					<th class="point"><label for="tagYn">태그 사용 여부</label></th>
					<td>
						<input type="radio" name="tagYn" id="tagYn_Y" value="Y" class="radio"<c:if test="${dataVo.tagYn == 'Y'}"> checked="checked"</c:if> onclick="jsChkValueChange('radio', 'tagYn', '${dataVo.tagYn}');" />
						<label for="tagYn_Y">사용</label> 
						<input type="radio" name="tagYn" id="tagYn_N" value="N" class="radio"<c:if test="${dataVo.tagYn == 'N'}"> checked="checked"</c:if> onclick="jsChkValueChange('radio', 'tagYn', '${dataVo.tagYn}');" /> 
						<label for="tagYn_N">미사용</label>
						<span class="tx_red">(게시물 태그를 사용하려면 사용으로 설정하세요.)</span>
					</td>
				</tr>
				<tr>
					<th class="point"><label for="readCookieHour">조회수 증가 시간</label></th>
					<td>
						<input type="text" name="readCookieHour" id="readCookieHour" title="조회수 증가 시간은 필수입력 항목입니다." style="width:585px"  value="${dataVo.readCookieHour}" maxlength="3" onchange="jsChkValueChange('text', 'readCookieHour', '${dataVo.readCookieHour}');" />
						<span class="tx_red">단위: 시간 (숫자, 최대 3자)</span>
						<p class="tx_gray">- 조회수/추천수/신고수 등 증가할 기준 시간을 지정합니다. 기준 시간이 지나야만 조회수가 증가합니다. (쿠키에 저장됨)</p>
					</td>
				</tr>

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