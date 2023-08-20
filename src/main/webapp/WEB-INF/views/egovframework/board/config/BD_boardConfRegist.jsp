<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<%@ page import="egovframework.board.config.BoardConfConstant" %>

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

		/* 공통 초기화 */
		$(document).ready(function(){
			
			// 등록
			$("#btn_submit").click(function() {
				if(!$('#dataForm').valid()){
					jsWarningBox(Message.msg.checkEssVal);
					return;
				}
				
				$("#df_method_nm").val("insertBoardConfRegistAction");
				$("#dataForm").submit();
			});
			
			// 취소
			$("#btn_reset").click(function(){
				document.dataForm.reset();
			});
			
			// 유효성 검사
			$("#dataForm").validate({
				rules : {
					
					},
				submitHandler: function(form) {
					if(!customValidate()) {
						return;
					}
					
					form.submit();
				}
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
                <h2 class="menu_title">게시판 생성</h2>
                <!-- 타이틀 영역 //-->
                
				<!-- 탭 -->
				<div id="bbsConfTabDiv" class="tabwrap">
					<div class="tab">
						<ul>
							<li class="on"><a href="#">기본 정보</a></li>
						</ul>
					</div>
				</div>
				<!-- //탭 -->
			
				<form name="dataForm" id="dataForm" method="post" >
				
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />				
			
				<input type="hidden" name="bbsCd" id="bbsCd" />
			
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
									<input type="text" name="bbsNm" id="bbsNm" title="게시판 명" style="width:762px" required maxlength="30" /> <span class="tx_red">(최대 30자)</span>
									<valid:msg name="bbsNm" />
								</td>
							</tr>
							<tr>
								<th><label for="bbsDesc" class="mgl_23">게시판 개요</label></th>
								<td>
									<textarea id="bbsDesc" name="bbsDesc" rows="3" title="게시판 개요" style="width:756px" maxlength="30"></textarea>
									<span class="tx_red">(최대 30자)</span>
									<valid:msg name="bbsDesc" />
								</td>
							</tr>
							<tr>
								<th rowspan="3" class="point"><label for="kindCd">게시판 종류</label></th>
								<td>
									<!-- <f:select path="dataVo.kindCd" id="kindCd" items="${kindCdMap}" />
									<valid:msg name="kindCd" /> -->
									목록 : <select id="listSkin" name="listSkin" class="mar_b5" style="width:729px">
										<c:forEach items="${listTemplates}" var="list">
											<option value="${list.templateId}">${list.templateNm}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
							<td>
									<!-- <f:select path="dataVo.kindCd" id="kindCd" items="${kindCdMap}" />
									<valid:msg name="kindCd" /> -->
									읽기 : <select id="viewSkin" name="viewSkin" class="mar_b5" style="width:729px">
										<c:forEach items="${viewTemplates}" var="view">
											<option value="${view.templateId}">${view.templateNm}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
							<td>
									<!-- <f:select path="dataVo.kindCd" id="kindCd" items="${kindCdMap}" />
									<valid:msg name="kindCd" /> -->
									쓰기 : <select id="formSkin" name="formSkin" style="width:729px">
										<c:forEach items="${formTemplates}" var="form">
											<option value="${form.templateId}">${form.templateNm}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<th class="point"><label for="ctgYn">분류 사용 여부</label></th>
								<td>
									<input type="radio" name="ctgYn" id="ctgYnY" value="Y" onclick="$('#ctgNmsTR').show();" />
									<label for="ctgYnY">사용</label>
									<input type="radio" name="ctgYn" id="ctgYnN" value="N" checked="checked" onclick="$('#ctgNmsTR').hide();" />
									<label for="ctgYnN">미사용</label>
									<valid:msg name="ctgYn" />
								</td>
							</tr>
							<tr id="ctgNmsTR" style="display:none">
								<th><label for="ctgNms" class="mgl_23">분류 설정</label></th>
								<td>
									<input type="text" name="ctgNms" id="ctgNms" title="분류명" style="width:762px" />
									<p class="tx_blue_s">- 쉼표로 구분하여 분류명을 입력해 주세요. 입력한 순서대로 정렬순번이 지정됩니다.</p>
								</td>
							</tr>
							<tr>
								<th class="point"><label for="noticeYn">공지글 사용 여부</label></th>
								<td>
									<input type="radio" name="noticeYn" id="noticeYnY" value="Y" />
									<label for="noticeYnY">사용</label>
									<input type="radio" name="noticeYn" id="noticeYnN" value="N" checked="checked" />
									<label for="noticeYnN">미사용</label>
									<valid:msg name="noticeYn" />
									기본형게시판 외에는 공지글을 미사용으로 설정하시기 바랍니다.
								</td>
							</tr>
							<tr>
								<th class="point">댓글 사용 여부</th>
								<td>
									<input type="radio" name="commentYn" id="commentYnY" value="Y" />
									<label for="commentYnY">사용</label>
									<input type="radio" name="commentYn" id="commentYnN" value="N" checked="checked" />
									<label for="commentYnN">미사용</label>
									<valid:msg name="commentYn" />
									기본형게시판 외에는 댓글을 미사용으로 설정하시기 바랍니다.
								</td>
							</tr>
						</tbody>
					</table>
				</fieldset>
				<!-- //내용쓰기 -->							
				
				<!-- 버튼 -->
				<div class="btn_page_last">
					<a href="#" class="btn_page_admin" id="btn_submit" ><span>등록</span></a> 
					<a href="#" class="btn_page_admin" id="btn_reset"><span>취소</span></a> 
					<a href="#" class="btn_page_admin" onclick="jsList();"><span>목록</span></a>
				</div>
				<!-- //버튼 -->
			
				</form>
			</div>
		</div>
	</div>

</body>
</html>