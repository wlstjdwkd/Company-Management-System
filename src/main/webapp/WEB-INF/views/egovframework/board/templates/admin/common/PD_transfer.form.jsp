<%@ page contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.openworks.kr/jsp/jstl" prefix="op"%>
<%@ taglib uri="http://www.openworks.kr/jsp/validate" prefix="valid"%>

<html>
<head>
	<title>게시물 이동</title>

	<op:jsTag type="spi" items="form, validate" />
	<op:jsTag type="openworks" items="validate" />

	<!-- 유효성 검증 BEAN Annotation 기반 자동 설정 -->
	<valid:script type="msgbox" />

	<script type="text/javascript">
		$().ready(function(){
			var seqss;

			if(parent.Ahpek.pageType == "LIST"){
		 		var selectedBbsCds = parent.jsCheckedArray();
				seqss = new Array();
				for(var i=0; i<selectedBbsCds.length ; i++){
					seqss[i] = {name:"seqs", value:selectedBbsCds[i]};
				}

				if(selectedBbsCds.length == 0){
					jsMsgBox("이동할 게시물을 먼저 선택하세요.");
					parent.$.fn.colorbox.close();
					return;
				}
			}

			$("#dataForm").validate({
				rules: {
					toBbsCds: { required: true }
				},
				submitHandler: function(form){
					//목록 보기일 경우 이동 액션
					if(parent.Ahpek.pageType == "LIST"){
						$(form).ajaxSubmit({
							url	  : "ND_list.transfer.do",
							type	 : "POST",
							dataType : "json",
							data	  : { "seqs[]" : $.makeArray(selectedBbsCds) },
							success  : function(result) {
								alert(result.value + "개의 게시물을 성공적으로 이동하였습니다.");
	 							parent.location.reload();
	 							parent.document.getElementById("dataForm").reset();
	 							parent.$.fn.colorbox.close();
							}
						});
					}
					//상세보기일 경우 이동 액션
					else if(parent.Ahpek.pageType == "VIEW"){
						var pform = parent.document.getElementById("dataForm");
						$("input[name=seq]", form).val($("input[name=seq]", pform).val());

					 	$(form).ajaxSubmit({
							url	  : "ND_article.transfer.do",
							type	 : "POST",
							dataType : "json",
							data	 : {
								toBbsCd   : $("#toBbsCd1").val(),
							 	newCtg	: $("#newCtg1").val(),
							 	mgrId	 : $("input[name=mgrId]", pform).val(),
							 	userKey   : $("input[name=userKey]", pform).val()
							},
							success  : function(result){
								if(result.value == 1){
									alert("게시물을 성공적으로 이동하였습니다.");
									parent.jsList(1);
									parent.$.fn.colorbox.close();
								}else{
									jsWarningBox("게시물을 이동할 수 없습니다.");
									parent.$.fn.colorbox.close();
								}
							}
						});
					}
		   		}
			});
		});

		var jsSetCategory = function(idno){
			$.post("INC_board.ctg.list.do", {
				bbsCd : $("#toBbsCd" + idno).val()
				}, function(result){
					$("#newCtg" + idno).empty();

					var ctgList = result.value;
					if((ctgList == null) || (ctgList.length < 1)){
						$("#newCtg" + idno).append("<option value=''>말머리 없음</option>");
					}else{
						j = 0;
						for(var i=0; i<ctgList.length; i++){
							$("#newCtg" + idno).append("<option value='" + ctgList[i].ctgCd + "'>" + ctgList[i].ctgNm + "</option>");
						}
					}
			}, "json");
		};
	</script>
</head>

<body>

<form id="dataForm" name="dataForm" method="post" action="ND_article.transfer.do">
	<input type="hidden" name="bbsCd" value="${boardConfVo.bbsCd}" />
	<input type="hidden" name="seq" value="" />
	<input type="hidden" name="isMove" value="Y" /><!-- Y이면 이동, 아니면 복사 -->

	<!-- 게시물 이동 폼 시작 -->
	<div class="pop_tit">
		<h1>게시글 이동</h1>
		<a href="#" onclick="parent.$.fn.colorbox.close();"><img src="/resources/openworks/theme/default/images/btn/btn_close.gif" alt="창닫기"/></a>
	</div>

	<ul class="blet">
		<li>게시물을 이동할 게시판을 선택합니다.</li>
	</ul>

	<table class="boardWrite" border="0" cellspacing="0" cellpadding="0" summary="게시글 이동">
		<caption>게시글 이동</caption>
		<colgroup>
			<col width="" />
			<col width="25%" />
			<col width="15%" />
			<col width="15%" />
		</colgroup>
		<thead>
			<tr>
				<th>글 제목</th>
				<th>이동할 게시판</th>
				<th>현재 말머리</th>
				<th>새 말머리</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${dataList}" var="boardVo" varStatus="status">
				<tr>
					<td>${boardVo.title}</td>
					<td>
						<select id="toBbsCd${status.count}" name="toBbsCds" onchange="jsSetCategory(${status.count});">
							<option value="">게시판 선택</option>
							<c:forEach items="${boardList}" var="boardConfVo" varStatus="status1">
								<option value="${boardConfVo.bbsCd}">${boardConfVo.bbsNm}</option>
							</c:forEach>
						</select>
						<valid:msg name="toBbsCds" />
					</td>
					<td>
						<c:forEach items="${boardConfVo.ctgList}" var="bbsCtgBean" varStatus="status2">
							<c:if test="${bbsCtgBean.ctgCd == boardVo.ctgCd}">${bbsCtgBean.ctgNm}</c:if>
						</c:forEach>
					</td>
					<td>
						<select id="newCtg${status.count}" name="newCtgs">
							<option value="">글머리 선택</option>
						</select>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<!-- 게시판 복사 끝 -->
			
	<!-- 게시판 하단 영역 시작 -->
	<p class="tx_c mar_t20">
		<input type="submit" value="이동" class="blue" />
		<input type="button" value="닫기" class="blue" onclick="parent.$.fn.colorbox.close();" />
	</p>
	<!-- 게시판 하단 영역 끝 -->

</form>

</body>
</html>