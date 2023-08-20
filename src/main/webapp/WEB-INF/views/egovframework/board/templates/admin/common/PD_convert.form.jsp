<%@ page contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.openworks.kr/jsp/jstl" prefix="op"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="f" %>

<html>
<head>
	<title>jQuery Tag Cloud</title>  

	<script type="text/javascript">
	$().ready(function(){
		$("#optionAll").click(function(){
			var checkedStatus = this.checked;
			$("#tbodyOpt input:checkbox").attr("checked", checkedStatus);
		});
		$("#optAll1").click(function(){
			var checkedStatus = this.checked;
			$("#optGrp1 input:checkbox").each(function(){
				this.checked = checkedStatus;
			});
		});
		$("#optAll2").click(function(){
			var checkedStatus = this.checked;
			$("#optGrp2 input:checkbox").each(function(){
				this.checked = checkedStatus;
			});
		});
		$("#optAll3").click(function(){
			var checkedStatus = this.checked;
			$("#optGrp3 input:checkbox").each(function(){
				this.checked = checkedStatus;
			});
		});
		$("#optAll4").click(function(){
			var checkedStatus = this.checked;
			$("#optGrp4 input:checkbox").each(function(){
				this.checked = checkedStatus;
			});
		});
	});

	var jsConvertAction = function(){
		var pbody = parent.document.body;
		var pConvertForm = $("#convertForm", pbody);
		var pDataForm = $("#dataForm", pbody);

		$("input", "table").each( function(){
			var str = "input[name=" + $(this).attr("name") + "]";
			if($(this).attr("checked")) $(str, pbody).val("Y");
			else $(str, pbody).val("N");
		});

		$("input[name=maxResult]", pbody).val($("select[name=maxResult]").val());
		$("input[name=type]", pbody).val($("#type").val());
		$("#convertForm", pbody).attr("target", "_blank");
		$("#convertForm", pbody).attr("action", "ND_convertAction.do");
		$("#convertForm", pbody).attr("method", "get");
		$("input[name=q_searchKey]", pConvertForm).val($("select[name=q_searchKey]", pDataForm).val());
		$("input[name=q_searchVal]", pConvertForm).val($("input[name=q_searchVal]", pDataForm).val());
		$("input[name=q_sortName]", pConvertForm).val($("input[name=q_sortName]", pDataForm).val());
		$("input[name=q_sortOrder]", pConvertForm).val($("input[name=q_sortOrder]", pDataForm).val());
		$("input[name=q_ctgCd]", pConvertForm).val($("select[name=q_ctgCd]", pDataForm).val());
		$("input[name=q_startDt]", pConvertForm).val($("input[name=q_startDt]", pDataForm).val());
		$("input[name=q_endDt]", pConvertForm).val($("input[name=q_endDt]", pDataForm).val());

		parent.document.convertForm.submit();
		parent.$.fn.colorbox.close();
	};
	</script>
</head>
  
<body>  

	<!-- 게시판 목록 상세보기 시작 -->
	<form name="dataForm" id="dataForm" method="get" action="ND_convertAction.do" target="_blank">
		<input type="hidden" name="bbsCd" value="${boardConfVo.bbsCd}" />
		<input type="hidden" name="type" id="type" value="${type}" />

		<table class="boardWrite" border="0" cellspacing="0" cellpadding="0" summary="글 내용을 표시">
			<colgroup>
				<col width="100px" />
				<col width="" />
			</colgroup>

			<tbody>
				<tr>
					<th>게시판이름</th>
					<td>${boardConfVo.bbsNm}&nbsp;[${boardConfVo.bbsCd}]</td>
				</tr>
				<tr>			
					<th colspan="2" class="tx_c">
						<input type="checkbox" name="showAll" id="showAll" value="Y" class="checkbox" /><label for="showAll">&nbsp;전체 리스트 출력</label>&nbsp;
						<input type="checkbox" name="noticeYnYn" id="noticeYnYn" value="Y" class="checkbox" /><label for="noticeYnYn">&nbsp;공지 표시</label>
					</th>
				</tr>
				<tr>
					<th>검색 건수</th>
					<td>
						<select name="maxResult" id="maxResult">
							<option value="">모두</option>
							<option value="10">최근 10건</option>
							<option value="30">최근 30건</option>
							<option value="100">최근 100건</option>
							<option value="300">최근 300건</option>
						</select>			
					</td>
				</tr>
			</tbody>

			<tbody id="tbodyOpt">
				<tr>
					 <th colspan="2" class="tx_c">
						<input type="checkbox" name="optionAll" id="optionAll" value="Y" class="checkbox" /><label for="optionAll">&nbsp;옵션 사항</label>
					</th>
				</tr>
				<tr id="optGrp1">
					<th><input type="checkbox" name="optAll1" id="optAll1" value="Y" class="checkbox" /><label for="optAll1">&nbsp;모두선택</label></th>
					<td>
						<input type="checkbox" name="titleYn" id="titleYn" value="Y" class="checkbox" /><label for="titleYn">&nbsp;제목</label>
						<input type="checkbox" name="summaryYn" id="summaryYn" value="Y" class="checkbox" /><label for="summaryYn">&nbsp;내용요약</label>
						<input type="checkbox" name="scoreSumYn" id="scoreSumYn" value="Y" class="checkbox" /><label for="scoreSumYn">&nbsp;총점</label>
					</td>
				</tr>
				<tr id="optGrp2">
					<th><input type="checkbox" name="optAll2" id="optAll2" value="Y" class="checkbox" /><label for="optAll2">&nbsp;모두선택</label></th>
					<td>
						<input type="checkbox" name="regDtYn" id="regDtYn" value="Y" class="checkbox" /><label for="regDtYn">&nbsp;등록일</label>
						<input type="checkbox" name="modDtYn" id="modDtYn" value="Y" class="checkbox" /><label for="modiDtYn">&nbsp;수정일</label>
						<input type="checkbox" name="readCntYn" id="readCntYn" value="Y" class="checkbox" /><label for="readCntYn">&nbsp;조회수</label>
					</td>
				</tr>
				<tr id="optGrp3">
					<th><input type="checkbox" name="optAll3" id="optAll3" value="Y" class="checkbox" /><label for="optAll3">&nbsp;모두선택</label></th>
					<td>
						<input type="checkbox" name="regNmYn" id="regNmYn" value="Y" class="checkbox" /><label for="regNmYn">&nbsp;작성자이름</label>
						<input type="checkbox" name="mgrIdYn" id="mgrIdYn" value="Y" class="checkbox" /><label for="mgrIdYn">&nbsp;매니저ID</label>
						<input type="checkbox" name="userKeyYn" id="userKeyYn" value="Y" class="checkbox" /><label for="userKeyYn">&nbsp;유저ID</label>
					</td>
				</tr>
				<tr id="optGrp4" class="no-btm">
					<th><input type="checkbox" name="optAll4" id="optAll4" value="Y" class="checkbox" /><label for="optAll4">&nbsp;모두선택</label></th>
					<td>
						<input type="checkbox" name="scoreCntYn" id="scoreCntYn" value="Y" class="checkbox" /><label for="scoreCntYn">&nbsp;투표수</label>
						<input type="checkbox" name="accuseCntYn" id="accuseCntYn" value="Y" class="checkbox" /><label for="accuseCntYn">&nbsp;신고수</label>
						<input type="checkbox" name="recomCntYn" id="recomCntYn" value="Y" class="checkbox" /><label for="recomCntYn">&nbsp;추천수</label>
					</td>
				</tr>
			</tbody>
		</table>

	</form>
	<!-- 게시판 목록 상세보기 끝 -->

	<!-- 게시판 하단 영역 시작 -->
	<p class="tx_c mar_t20">
		<input type="button" value="파일저장" class="blue" onclick="jsConvertAction();" />
		<input type="button" value="닫기" class="blue" onclick="parent.$.fn.colorbox.close();" />
	</p>
	<!-- 게시판 하단 영역 끝 -->

</body> 
  
</html>