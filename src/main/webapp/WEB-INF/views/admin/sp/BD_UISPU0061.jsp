<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>정보</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,colorboxAdmin,multifile" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javascript">
	<c:if test="${resultMsg != null}">
		$(function() {
			jsMsgBox(null, "info", "${resultMsg}");
		});
	</c:if>
	
	$(document).ready(function(){
		var today=new Date();
		/* $('#q_pjt_start_dt').mask('0000-00-00');
		$('#q_pjt_start_dt').datepicker({
		    showOn : 'button',
		    defaultDate : -30,
		    buttonImage : '<c:url value="/images/acm/icon_cal.png" />',
		    buttonImageOnly : true,
		    changeYear: true,
		    changeMonth: true,
		    yearRange: "-5:+1"
		}); */
		
		// 유효성 검사
		$("#dataForm2").validate({
			submitHandler : function(form) {
					jsMsgBox(null, 'confirm'
					,'<spring:message code="confirm.common.save" />'
					,function() {
						$("#df_method_nm").val("insertGalleryBoard");
        				
            			form.submit();
					});
			}
		});
		
		// 등록
		$("#btn_ok").click(function() {
			// validation check
			if($("#galleryType option:selected").val().length == 0 || $("#galleryType option:selected").val() == ""
				|| $("#subjBoard").val().length == 0 || $("#subjBoard").val() == ""
				|| $("#descBoard").val().length == 0 || $("#descBoard").val() == ""
				|| $("#dateBoard").val().length != 8 || $("#dateBoard").val() == ""
				|| $("#imgFile").val().length == 0 || $("#imgFile").val() == ""
				|| $("#urlBoard").val().length == 0 || $("#urlBoard").val() == ""
			){
				alert("필수 값을 확인하세요");
				return;	
			}
			
			
			$("#dataForm2").submit();
			
		});
		
		$('#multipartFile').MultiFile({
			accept: 'jpg|gif|png',
			list:'#photo_file_view',
			max: '1',
			STRING: {
				remove: '<img src="<c:url value="/images/ucm/icon_del.png" />" alt="x" />',
				denied: '$ext 는(은) 업로드 할 수 없는 파일확장자입니다!',
				duplicate: '$file 는(은) 이미 추가된 파일입니다!'
			},
			afterFileSelect: function(element, value, master_element){
				console.log(element);
				console.log(value);
				console.log(master_element);
				var $fileList = $("#photo_file_view").find(".MultiFile-label");
				var $remove_btn;
				for(var i=0; i<$fileList.length-1; i++) {
					$remove_btn = $fileList.eq(i).find(".MultiFile-remove");
					
					if($remove_btn.length > 0) {					
						$fileList.eq(i).find(".MultiFile-remove").click();	
					}else{					
						$fileList.eq(i).remove();
					}				
				}
				
				$("#df_method_nm").val("processAtchPhoto");
				
				$("#dataForm2").ajaxSubmit({
					url      : "PGSP0061.do",
					type     : "post",
					dataType : "text",
					async    : false,
					contentType: "multipart/form-data",
					success  : function(response) {
						try {
							if(response) {
								var srcStr = "/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=" + response + "&number=" + Math.random();
								$("#img_photo").attr("src", srcStr);
								$("#imgFile").attr("value", response)
							} else {
								jsErrorBox(Message.msg.processFail);
							}
						} catch (e) {
							jsSysErrorBox(response, e);
							return;
						}                            
					}
				});
				
			}
		});
	});

	// 상세보기
	function fn_lqttEmailDetail(lottEmailId) {
		var form = document.dataForm;
		form.action = "<c:url value='${svcUrl}' />";
		form.ad_lqtt_email_id.value = lottEmailId;
		form.df_method_nm.value = "lqttEmailDetail";
		form.submit();
	}

	/* 
	 * 수정화면 함수
	 */
	function btn_menu_get_modify_view(menuNo) {
		var form = document.dataForm;
		form.df_method_nm.value = "getMenuModify";
		$("#temp").val(menuNo);
		form.submit();
	}
</script>
</head>
<body>
	<div id="wrap">
		<div class="wrap_inn">
			<div class="contents">
				<!--// 타이틀 영역 -->
				<h2 class="menu_title">기업 사업지원 관리</h2>
				<!-- 타이틀 영역 //-->

				<form name="dataForm2" id="dataForm2" action="<c:url value='${svcUrl }' />" method="post">
					<ap:include page="param/defaultParam.jsp" />
					<ap:include page="param/dispParam.jsp" />
					<ap:include page="param/pagingParam.jsp" />
					
					<input type="hidden" id="USER_NO" name="USER_NO" value="1" />
					<input type="hidden" id="ad_bizrno" name="ad_bizrno"value=""/>
					
					<!--// 검색 조건 -->
					<div class="search_top">
						<table cellpadding="0" cellspacing="0" class="table_search" summary="검색">
							<caption>검색</caption>
							<colgroup>
								<col width="100%" />
							</colgroup>
							<tr>
								<td class="only">
									<select name="type" id="galleryType" class="select" style="width:150px;" title="검색조건선택">
										<option value=''>선택하세요</option>
										<option value='1' <c:if test="${param.search_type == '1'}">selected</c:if>>사업지원</option>
										<option value='2' <c:if test="${param.search_type == '2'}">selected</c:if>>조세지원</option>
										<option value='3' <c:if test="${param.search_type == '3'}">selected</c:if>>우수사례</option>
									</select>
								</td>
							</tr>
						</table>
					</div>
					
					<table cellpadding="0" cellspacing="0" class="table_basic" summary="대량메일관리 입력">
						<caption>대량메일관리 입력</caption>
						<colgroup>
							<col width="25%" />
							<col width="*" />
						</colgroup>
						<tr>
							<th scope="row" class="point"><label for="subjBoard">제목</label></th>
							<td>
								<input name="subjBoard" type="text" id="subjBoard" class="text" placeholder="" onfocus="this.placeholder=''; return true" style="width: 395px;" />
							</td>
						</tr>
						<tr>
							<th scope="row" class="point"><label for="descBoard">설명</label></th>
							<td>
								<input name="descBoard" type="text" id="descBoard" class="text" placeholder="" onfocus="this.placeholder=''; return true" style="width: 395px;" />
							</td>
						</tr>
						<tr>
							<th scope="row" class="point"><label for="dateBoard">날짜</label></th>
							<td>
								<input name="dateBoard" type="text" id="dateBoard" class="text" placeholder="" onfocus="this.placeholder=''; return true" style="width: 395px;" />
							</td>
						</tr>
						<tr>
							<th scope="row" class="point"><label for="imgFile">파일</label></th>
							<td>
								<input type="hidden" name="imgFile" id="imgFile" value=""/>
								<li class="my_width" style="width:35%">
	                        	<c:choose>
		                       		<c:when test="${not empty dataMap.LOGO_FILE_SN }">
		                       			<img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${dataMap.LOGO_FILE_SN}" />" id="img_photo" alt="로고" width="100%" style="border:#666 solid 1px" />
		                       		</c:when>
		                       		<c:otherwise>
		                       			<img src="<c:url value='/images/cs/no_logo.png' />" id="img_photo" alt="로고" width="100%" style="border:#666 solid 1px;" />
		                       		</c:otherwise>
		                       	</c:choose>
		                        </li>
		                        <br>
								<li class="my_file_width">
		                            <div class="btn_inner">                            
		                            	<input type="file" id="multipartFile" name="multipartFile" title="파일찾아보기" width="100%" height="40%" />
		                            	<div id="photo_file_view" >
		                            	<c:if test="${not empty dataMap.LOGO_FILE_SN }" >
		                               		<div class="MultiFile-label">
		                                   	<a href="#none" onclick="logoDelAttFile('${dataMap.LOGO_FILE_SN}');"><img src="<c:url value='/images/ucm/icon_del.png' />" alt="삭제하기" /></a>
											<a href="#none" onclick="downAttFile('${dataMap.LOGO_FILE_SN}')">${dataMap.LOGO_FILE_NM} </a>
											</div>								
										</c:if>
										</div>         
		                            </div>
		                        </li>
							</td>
						</tr>
						<tr>
							<th scope="row" class="point"><label for="urlBoard">링크 URL</label></th>
							<td>
								<input name="urlBoard" type="text" id="urlBoard" class="text" placeholder="" onfocus="this.placeholder=''; return true" style="width: 395px;" />
							</td>
						</tr>
					</table>
						
					<div class="btn_page_last">
							<a class="btn_page_admin" href="#" id="btn_ok"><span>확인</span></a>
						</div>
				</form>
				
				
				<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl }'/>" method="post">
					<ap:include page="param/defaultParam.jsp" />
					<ap:include page="param/dispParam.jsp" />
					<ap:include page="param/pagingParam.jsp" />
					
					<input type="hidden" name="ad_lqtt_email_id" id="ad_lqtt_email_id" value="" />
					<input type="hidden" name="temp" id="temp" value="" />
					
					<div class="block2">
						<ap:pagerParam />
						<!--// 리스트 -->
						<div class="list_zone">
							<table cellspacing="0" border="0" summary="번호, 설명, 날짜, 파일, URL">
								<caption>갤러리 게시판 리스트</caption>
								<colgroup>
									<col width="*" />
									<col width="*" />
									<col width="*" />
									<col width="*" />
									<col width="*" />
									<col width="*" />
									<col width="*" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col">번호</th>
										<th scope="col">제목</th>
										<th scope="col">종류</th>
										<th scope="col">설명</th>
										<th scope="col">날짜</th>
										<th scope="col">파일</th>
										<th scope="col">URL</th>
									</tr>
								</thead>
								<tbody>
									<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
									<c:if test="${fn:length(resultList) == 0}">
										<tr>
											<td colspan="7">
												<c:if test="${param.search_word == null or param.search_word == '' }">
													<spring:message code="info.nodata.msg" />
												</c:if>
												<c:if test="${param.search_word != null and param.search_word != '' }">
													<spring:message code="info.noresult.msg" />
												</c:if>
											</td>
										</tr>
									</c:if>
									<%-- 데이터를 화면에 출력해준다 --%>
									<c:forEach items="${resultList}" var="resultInfo" varStatus="status">
										<tr>
											<td>${pager.indexNo-status.index}</td>
											<%-- <td>${resultInfo.SUBJ_BOARD}</td> --%>
											<td>
												<%-- <c:forEach var="i" begin="1" end="${menuList.menuLevel}"><c:out value="&nbsp;&nbsp;&nbsp;&nbsp;" escapeXml="false" /></c:forEach> --%>
												<a href="#none" class="btn_in_gray"	onclick="btn_menu_get_modify_view('<c:out value="${resultInfo.SEQ}"/>')"><span>${resultInfo.SUBJ_BOARD}</span></a>
											</td>
											<c:choose>
												<c:when test="${resultInfo.TYPE == '1'}">
													<td>사업지원</td>
												</c:when>
												<c:when test="${resultInfo.TYPE == '2'}">
													<td>조세지원</td>
												</c:when>
												<c:when test="${resultInfo.TYPE == '3'}">
													<td>우수사례</td>
												</c:when>
												<c:otherwise>
													<td>${resultInfo.TYPE}</td>
												</c:otherwise>
											</c:choose>
											<td>${resultInfo.DESC_BOARD}</td>
											<td>${resultInfo.DATE_BOARD}</td>
											<td>${resultInfo.IMG_FILE}</td>
											<td>${resultInfo.URL_BOARD}</td>
											<input type="hidden" name="SEQ" id="SEQ" value=${resultInfo.SEQ} />
											
											<%-- <td class="tal">
												<a href="#none" onclick="fn_lqttEmailDetail('${resultInfo.LQTT_EMAIL_ID}');">
													<c:out value="${resultInfo.EMAIL_SJ}" />
												</a>
											</td>
											<td>${resultInfo.REGISTER_NM}</td>
											<td>${fn:substring(resultInfo.RGSDE, 0, 10)}</td>
											<td>
												<div class="btn_inner">
													<a href="#none" class="btn_in_gray" onclick="fn_lqttEmailRcverListPopup('${resultInfo.LQTT_EMAIL_ID}');"><span>설정</span></a>
												</div>
											</td> --%>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<!-- 리스트// -->
						<ap:pager pager="${pager}" />
					</div>
				</form>
			</div>
			<!--content//-->
		</div>
	</div>
</body>
</html>
