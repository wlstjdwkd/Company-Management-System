<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="f" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<%@ page import="egovframework.board.config.BoardConfConstant" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />

<ap:jsTag type="web" items="jquery,cookie,form,notice,ui,validate" />
<ap:jsTag type="tech" items="msg,util,acm" />
<ap:jsTag type="egovframework" items="boardconf" />
<script type="text/javascript">
	var confTabz;

	$().ready(function(){
		
		//대상항목 목록 중에 표시항목이 있으면 해당 항목 제거
		$("#allColumns").find("option").each(function(){
			var leftColumn = $(this);
			$("#displayColumns").find("option").each(function(){
				if($(this).val() == leftColumn.val()) leftColumn.remove();
			});
		});
		$("#btn_setList").click(function(){
			JSopt.doOpt("add");
		});
		$("#btn_resetList").click(function(){
			JSopt.doOpt("back");
		});
		$("#btn_upOption").click(function(){
			JSopt.doOpt("up");
		});
		$("#btn_downOption").click(function(){
			JSopt.doOpt("down");
		});		
		
		// 등록버튼
		$("#btn_submit").click(function(){
			
			$("#df_method_nm").val("updateBoardArrangeConfModifyAction");
			$("#displayColumns > option").attr("selected", "selected");
			dataString = $("#listArrangeForm").serialize();			
			
			$.ajax({
				type: "POST",
				url: "PGMS0080.do",
				data: dataString,
				success: function(response){
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
			
		});
		
		// 취소버튼
		$("#btn_reset").click(function(){
			changeFlag=false;
			document.listArrangeForm.reset();
		});
	});

	var JSopt = {
		doOpt : function(_mode){
			/* Option 추가 실행 */
			if(_mode == 'add'){
				$("#allColumns").find("option").each(function(){
					if(this.selected){
						$("#displayColumns").append("<option value='" + this.value +"'>" + this.text +"</option>");
						$(this).remove();
					}
					changeFlag = true;
				});
			}else if(_mode == "back"){
				$("#displayColumns").find("option").each(function(){
					if(this.selected){
						$("#allColumns").append("<option value='" + this.value +"'>" + this.text +"</option>");
						$(this).remove();
					}else{
					}
					changeFlag = true;
				});
			}else if(_mode == "up"){
				$('#displayColumns option:selected').each(function(){
					var selectObj = $(this);
					if(selectObj.index() == 0) return false;
					var targetObj = $('#displayColumns option:eq(' + (selectObj.index()-1) + ')');
					targetObj.before(selectObj);
					changeFlag = true;
				});
			}else if(_mode == "down"){
				$('#displayColumns option:selected').each(function(){
					var selectObj = $(this);
					if(selectObj.index() == $('#displayColumns').children().length) return false;
					var targetObj = $('#displayColumns option:eq(' + (selectObj.index()+1) + ')');
					targetObj.after(selectObj);
					changeFlag = true;
				});
			}else{
			}
		}
	};
	
</script>

<!-- 캡션 영역 시작 -->
<div class="bbs-caption">
	<div class="caption-right"> 
		<span id="formResult" class="result"></span>
	</div>
</div>
<!-- 캡션 영역 끝 -->

<form id="listArrangeForm" name="listArrangeForm">
<input type="hidden" name="bbsCd" value="${param.bbsCd}" />
<input type="hidden" name="listViewGubun" value="<%= BoardConfConstant.GUBUN_DISPLAY_COLUMN_LIST %>" />
<ap:include page="param/defaultParam.jsp" />

	<!-- 게시판 목록 배치 시작 -->
	<fieldset>
		<legend>목록 배치 설정</legend>
		<table class="table_basic" border="0" cellspacing="0" cellpadding="0" summary="목록 배치" >
			<caption>입력표 설정</caption>
			<colgroup>
				<col width="200" />
				<col width="50" />
				<col width="*" />
			</colgroup>
			<tbody>
				<tr>
					<th>대상 항목</th>
					<th></th>
					<th>표시 항목</th>
				</tr>
				<tr>
					<td>
						<select id="allColumns" name="allColumns" size="15" style="width:200px;height:250px;" multiple="">
							<c:forEach items="${boardColumnList}" var="_bean">
								<option value="${_bean.columnId}">${_bean.columnNm}</option>
							</c:forEach>
						</select>
					</td>
					<td>
						<input type="button" style="width:50px" id="btn_setList"  value="→" />
						<input type="button" style="width:50px" id="btn_resetList" value="←" />
						<input type="button" style="width:50px" id="btn_upOption" value="↑" />
						<input type="button" style="width:50px" id="btn_downOption" value="↓" />
					</td>
					<td>
						<select id="displayColumns" name="displayColumns" size="15" style="width:200px;height:250px;" multiple="">
							<c:forEach items="${boardDisplayColumnList}" var="_bean">
								<option value="${_bean.columnId}">${_bean.columnNm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>				
			</tbody>
		</table>
	</fieldset>
	<!-- 게시판 목록 배치 끝 -->
	
	<!-- 버튼 -->
	<div class="btn_page_last">
		<a href="#none" class="btn_page_admin" id="btn_submit"><span>등록</span></a>
		<a href="#none" class="btn_page_admin" id="btn_reset"><span>취소</span></a>
		<a href="#none" class="btn_page_admin" onclick="jsList();"><span>목록</span></a>
	</div>
	<!-- //버튼 -->

</form>