<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
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
	
	$(document).ready(function() {

		var form = document.dataForm;
		var menuInfo = "${menuinfo}";

		$("#SEQ").val("${menuInfo.SEQ}");
		$("#subjBoard").val("${menuInfo.SUBJ_BOARD}");
		$("#descBoard").val("${menuInfo.DESC_BOARD}");
		
		var date = "${menuInfo.DATE_BOARD}";
		date = date.substring(0,4) + "" + date.substring(5,7) + "" + date.substring(8,10);
		$("#dateBoard").val(date);
		
		$("#imgFile").val("${menuInfo.IMG_FILE}");
		
		$("#img_photo").attr("src","/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq="+$("#imgFile").val());
		
		$("#urlBoard").val("${menuInfo.URL_BOARD}");
		
		$("#galleryType").children().eq("${menuInfo.TYPE}").attr("selected", "true");
		//$("#type").val("${menuInfo.TYPE}");
		
		// 확인
		$("#btn_insert_menu").click(function() {
			var ad_parntsMenuNm_check = $("#ad_parntsMenuNm").val();
			jsMsgBox(null, 'confirm','<spring:message code="confirm.common.save" />',function(){$("#df_method_nm").val("processMenu"); $("#dataForm").submit();});
		});
		
		// 삭제
		$("#btn_delete_menu").click(function() {
			jsMsgBox(null, 'confirm','<spring:message code="confirm.common.delete" />',function(){$("#df_method_nm").val("deleteMenu"); $("#dataForm").submit();});
		});
		
		// 취소
		$("#btn_menu_get_list").click(function() {
			$("#df_method_nm").val("index");
			document.dataForm.submit();
		});
		
		
		// 상위메뉴 찾기
		$("#popParntsMenu").click(function() {
			$("#pop_searchSiteSe").val($("#ad_siteSe").val());
			var pop_searchSiteSe = $("#pop_searchSiteSe").val();
			
			$.colorbox({
				title : "상위메뉴 찾기",
				href : "PGCMMENU0020.do?df_method_nm=getParntsMenuList"+"&pop_searchSiteSe="+pop_searchSiteSe,
				
				width : "70%",
				height : "75%",
				overlayClose : false,
				escKey : false,
				iframe : true
			});
		});
		
		// 프로그램 찾기
		$("#popFindProgram").click(function() {
			$.colorbox({
				title : "프로그램 찾기",
				href : "PGCMMENU0020.do?df_method_nm=getProgramList",
				width : "70%",
				height : "75%",
				overlayClose : false,
				escKey : false,
				iframe : true
			});
		});
		
		$('#multipartFile').MultiFile({
			accept: 'jpg|gif',
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
				
				$("#dataForm").ajaxSubmit({
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
	
</script>
</head>

<body>
	<div id="wrap">
		<div class="wrap_inn">
			<div class="contents">
				<!--// 타이틀 영역 -->
				<h2 class="menu_title">갤러리 게시판 상세</h2>
					<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl }' />" method="post">
						<ap:include page="param/defaultParam.jsp" />
						<ap:include page="param/dispParam.jsp" />
						<ap:include page="param/pagingParam.jsp" />
						
						<input type="hidden" id="USER_NO" name="USER_NO" value="1" />
						<input type="hidden" id="ad_bizrno" name="ad_bizrno"value=""/>
						<input type="hidden" name="SEQ" id="SEQ" value="" />
						
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
							
						<!-- 등록// -->
						<div class="btn_page_last">
							<a class="btn_page_admin" id="btn_delete_menu" href="#none"><span>삭제</span></a> 
							<a class="btn_page_admin" id="btn_menu_get_list" href="#none"><span>취소</span></a> 
							<a class="btn_page_admin" id="btn_insert_menu" href="#none"><span>확인</span></a>
						</div>
					</form>
				</div>
			</div>
		</div>
</body>
</html>