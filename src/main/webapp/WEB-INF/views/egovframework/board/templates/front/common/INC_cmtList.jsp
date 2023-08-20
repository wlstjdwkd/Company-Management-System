<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.openworks.kr/jsp/jstl" prefix="op" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!-- 사용자 스크립트 시작 -->
<script type="text/javascript">
	$().ready(function(){
		var commentSubmitHandler = function(form){
		    <c:if test="${empty __usk.userKey}">
		    	alert("작성 권한이 없습니다.");
		    	return;
		    </c:if>
			var _contents = new String($.trim($("#comments").val()));
			if(_contents == '' || _contents.length < 0 || _contents.length > 500){
			    jsWarningBox("내용을 확인하세요.(최대 500글자)");
				$("#comments")[0].focus();
				return false;
			}

			$.post("ND_check.ban.do", {
				bbsCd : "${param.bbsCd}",
				seq : "${param.seq}",
				contents : $("#comments").val()
			}, function(result){
				if(result.result == true){
					//var msg = result.message.replace("\n\n", "<br />");
					alert(result.message);
					return;
				}else{
					actionType = $("input[name=type]").val();
					dataString = $("#commentForm").serialize();
					$.ajax({
						url		 : "ND_cmt.insert.do",
						type	 : "POST",
						data	 : dataString,
						dataType : "json",
						success  : function(response){
							alert(response.message);
							if(actionType == "INSERT") parent.$("#cmtCnt").text(parseInt($("#cmtCnt").text()) + 1);
							jsCmtPageMove($("#commentForm input[name=currentPage]").val());
						}
					});
				}
			}, "json");
		};

		//commentForm 유효성 체크
		$("#commentForm").validate({
			errorClass: "unfill",
			rules : {
			    comments : { required : true, maxlength : 500 },
				regNm : { required : true, minlength : 2, maxlength:10 }
			},
			submitHandler: commentSubmitHandler
		});

		//커멘트 글자수 표시 및 길이 제한 - 파폭, ie에서 keyup이벤트가 다르게 적용됨...!!!
		$("#comments").keyup(function(){
			var str = new String($("#comments").val());
			var length = str.length;
			if(length > 500){
			    jsWarningBox("작성글은 최대 500자 입니다.");
				$("#comments")[0].focus();
			} 
			$("#commentLength").text(length);
			return false;
		});				

	});

	//댓글 페이지 번호이벤트 함수
	var jsCmtPageMove = function(curpage){
		var target = $("#attachedCommentsDiv");

		if($.trim(target.text()) == "" || curpage != $("#commentForm input[name=currentPage]")){
			$.get("INC_cmt.list.do", {
				bbsCd : "${param.bbsCd}",
				seq   : "${param.seq}",
				q_currPage : curpage
			},
			function(result){
				target.empty();
				target.append(result);
			});
		}
	};

	//댓글 수정 클릭 시  
	var jsModifyCommentAction = function(bbsCd, seq, cmtSeq, mid, uid){
		$.post("ND_comment.update.form.do", {
				bbsCd : bbsCd,
				seq : seq,
				cmtSeq : cmtSeq,
				mgrId : mid,
				modId : uid
			},
			function(result){
				if(result.result == true){
					$("#commentForm input[name=bbsCd]").val(result.value.bbsCd);
					$("#commentForm input[name=seq]").val(result.value.seq);
					$("#commentForm input[name=cmtSeq]").val(result.value.cmtSeq);
					$("#commentForm textarea[name=comments]").val(result.value.comments);
					$("#commentForm input[name=userKey]").val(result.value.userKey);
					$("#commentForm input[name=mgrId]").val(result.value.mgrId);
					$("#commentForm input[name=regNm]").val(result.value.regNm);
					$("#commentForm input[name=type]").val("UPDATE");
					$("#commentForm input:radio[name=iconKey][value='" + result.value.iconKey + "']").attr("checked","'checked'");
					$("#commentForm select[name=score]").val(result.value.score);
					$("#commentForm input[name=currentPage]").val(result.value.currentPage);
					$("#commentForm textarea[name=comments]").focus();
					//$("#commentForm input[name=regNm]").attr("readonly", "readonly");
					$("#commentLength").text($("#comments").val().length);
					window.scrollTo(1, $("#commentForm").position().top);
					$("#btnCancel").show();
				}else{
					jsWarningBox(result.message);
				}
			}, 'json');
	};

	//댓글 삭제 클릭 시
	var jsDeleteCommentAction = function(bbsCd, seq, cmtSeq, mid, uid){
		if(!confirm("의견글을 삭제하시겠습니까 ?")) return;

		$.post("ND_comment.delete.do", {
			bbsCd : bbsCd,
			seq : seq,
			cmtSeq : cmtSeq,
			mgrId : mid,
			regId : uid
		}, function(result){
			if(result == 1){
				alert('의견글이 삭제되었습니다');
				parent.$("#cmtCnt").text(parseInt($("#cmtCnt").text()) - 1);
				jsCmtPageMove($("#commentForm input[name=currentPage]").val());
			}else{
				jsWarningBox(result);
			}
		}, 'json');
	};

	//취소 버튼 클릭 시
	var jsCommentFormReset = function(){
		$("#commentForm").validate().resetForm();
		//$("#commentForm input[name=regNm]").attr("readonly", "");
		$("#btnCancel").hide();
	};
</script>
<!-- 사용자 스크립트 끝 -->


<!-- <h4 class="tx_13 mar_t10">댓글 : <span id="cmtCnt" class="tx_orange_u">${pagerVo.totalNum}</span>개</h4> -->

<ul class="comment clear mar_b10">
	<!-- 의견글등록-->
	<li class="bg_gray">	
		<form id="commentForm" name="commentForm" action="ND_cmt.insert.do" method="post">
		<input type="hidden" name="bbsCd" value="${param.bbsCd}" />
		<input type="hidden" name="seq" value="${param.seq}" />
		<input type="hidden" name="cmtSeq" value="0" />
		<input type="hidden" name="currentPage" value="${param.currentPage}" />
		<input type="hidden" name="type" value="INSERT" />

		<p class="mar_b5">
			<span class="mar_r5">
				작성자 : <input type="text" name="regNm" id="regNm" value="${__usk.userNm}" />
				평점 : 
				<select name="score" class="mar_l5 vm">
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
			   	<input type="radio" name="iconKey" id="iconKey1" value="smile_01" checked="checked" />
				<label for="radio1"><img src="/resources/openworks/theme/default/images/icon/smile_01.gif" alt="웃음" class="vm"/></label>
				<input type="radio" name="iconKey" id="iconKey2" value="smile_02" />
				<label for="radio2"><img src="/resources/openworks/theme/default/images/icon/smile_02.gif" alt="윙크" class="vm"/></label>
				<input type="radio" name="iconKey" id="iconKey3" value="smile_03" />
				<label for="radio3"><img src="/resources/openworks/theme/default/images/icon/smile_03.gif" alt="씨익" class="vm"/></label>
				<input type="radio" name="iconKey" id="iconKey4" value="smile_04" />
				<label for="radio4"><img src="/resources/openworks/theme/default/images/icon/smile_04.gif" alt="미소" class="vm"/></label>
				<input type="radio" name="iconKey" id="iconKey5" value="smile_05" />
				<label for="radio5"><img src="/resources/openworks/theme/default/images/icon/smile_05.gif" alt="한숨" class="vm"/></label>
				<input type="radio" name="iconKey" id="iconKey6" value="smile_06" />
				<label for="radio6"><img src="/resources/openworks/theme/default/images/icon/smile_06.gif" alt="걱정" class="vm"/></label>
				<input type="radio" name="iconKey" id="iconKey7" value="smile_07" />
				<label for="radio7"><img src="/resources/openworks/theme/default/images/icon/smile_07.gif" alt="눈물" class="vm"/></label>
		   	</span>
		</p>
		<fieldset class="modify">
			<legend>댓글작성</legend>
			<label for="comments" class="skip">댓글작성</label>
			<textarea id="comments" name="comments" rows="3" class="comm_modify w99_p"></textarea>
			<p class="mar_t5 float_l clear"> (<span id="commentLength" class="tx_orange_b">0</span> / 500자)</p>
			<p class="mar_t5 float_r">
				<input type="image" src="/resources/web/theme/default/images/btn/btn_g_confirm.gif" alt="확인" />
				<input type="image" src="/resources/web/theme/default/images/btn/btn_g_cancel.gif" alt="취소" onclick="jsCommentFormReset(); return false;" />
			</p>
		</fieldset>
		</form>
	</li>
	<!-- //의견글등록-->

	<!-- 의견글내용-->
	<c:if test="${!empty pagerVo.list}">
		<c:forEach items="${pagerVo.list}" var="commentVo" varStatus="status">
			<li>
				<div class="mar_b10">
					<span class="tx_b mar_r15">
						<c:if test="${!empty commentVo.iconKey}"><img src="/resources/openworks/theme/default/images/icon/${commentVo.iconKey}.gif" alt="웃음" class="vm"/></c:if>
						${commentVo.regNm}
					</span>
					<c:if test="${commentVo.score > 0}"><span class="mar_r15">평점 : ${commentVo.score}점</span></c:if>
					<span class="tx_gray_s">${commentVo.regDt} <c:if test="${!empty commentVo.modDt}">(최종수정 : ${commentVo.modDt})</c:if></span>
					<c:if test="${commentVo.mgrDelYn != 'Y'}">
						<c:if test="${!empty __usk.userKey && __usk.userKey eq commentVo.userKey}">
							<span class="btn">
								<a href="#" onclick="jsModifyCommentAction('${commentVo.bbsCd}', '${commentVo.seq}', '${commentVo.cmtSeq}', '${commentVo.mgrId}', '${commentVo.regId}');"><img src="/resources/openworks/theme/default/images/btn/btn_modify.gif" alt="수정" class="vm" /></a>
								<a href="#" onclick="jsDeleteCommentAction('${commentVo.bbsCd}', '${commentVo.seq}', '${commentVo.cmtSeq}', '${commentVo.mgrId}', '${commentVo.regId}');"><img src="/resources/openworks/theme/default/images/btn/btn_del.gif" alt="삭제" class="vm" /></a>
							</span>
						</c:if>
					</c:if>
				</div>
				<c:if test="${commentVo.mgrDelYn eq 'Y'}">
					<div class="tx_gray_u">관리자에 의해 삭제되었습니다.</div>
				</c:if>
				<c:if test="${commentVo.mgrDelYn != 'Y'}">
					<p>${commentVo.comments}</p>
				</c:if>
			</li>
		</c:forEach>
	</c:if>
	<c:if test="${empty pagerVo.list}">
		<li class="tx_c mar_t5 mar_b40">
			<span>등록된 댓글이 없습니다.</span>
		</li>
	</c:if>
	<!-- //의견글내용-->
</ul>

<!-- paging -->
<c:if test="${!empty pagerVo.list}"><op:pager pager="${pagerVo}" page="pager/webCmtPager.jsp" script="jsCmtPageMove" /></c:if>
<!-- //paging -->