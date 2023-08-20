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
<title>정보변경신청|기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,form,colorboxAdmin,selectbox,validate,mask,notice,msgBoxAdmin,ui,json,jBox" />
<ap:jsTag type="tech" items="msg,util,acm,im" />

<script type="text/javascript">
	$(document).ready(function() {
		// 유효성 검사
		$("#dataForm").validate({  
			rules : {  				
	    		// 법인등록번호
	    		searchJurirno: {
	    			required: true
	    		}
			},
			submitHandler: function(form) {
				form.submit();
			}
		});
		
		// 확인
		$("#btn_find_userId").click(function() {
			$("#df_method_nm").val("confmInsert1");
			$("#dataForm").submit();
		});
		
		// tool tip
		$("#add_tooltip").jBox('Tooltip', {
			content: '\"-\" 없이 입력하십시오.'
		});
	});
	
	/*
	* 검색단어 입력 후 엔터 시 자동 submit
	*/
	function press(event) {
		if (event.keyCode == 13) {
			$("#df_method_nm").val("confmInsert1");
			$("#dataForm").submit();
		}
	}
	
	// 확인서 신청 진행
	function doConfmInsert(jurirno, entrprs_nm, bizrno, user_no) {
		$("#searchJurirno").val(jurirno);
		
		$("#ad_jurirno").val(jurirno);
		$("#ad_entrprs_nm").val(entrprs_nm);
		$("#ad_bizrno").val(bizrno);
		$("#ad_user_no").val(user_no);
		
		$("#df_method_nm").val("confmInsert2");
		$("#dataForm").submit();
	}
</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<!-- <ap:include page="param/pagingParam.jsp" /> -->
		
		<input type="hidden" id="init_search_yn" name="init_search_yn" value="N" />
		<input type="hidden" id="ad_jurirno" name="ad_jurirno" />
		<input type="hidden" id="ad_entrprs_nm" name="ad_entrprs_nm" />
		<input type="hidden" id="ad_bizrno" name="ad_bizrno" />
		<input type="hidden" id="ad_user_no" name="ad_user_no" />
		
		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title">발급업무관리</h2>
					<!-- 타이틀 영역 //-->
					
					<div class="block">
						<ul>
							<li class="d1">회원 정보상의 법인등록번호로 기업정보를 찾으실 수 있습니다.</li>
						</ul>
					</div>
					
					<!-- // 검색 영역 -->
					<div class="search_top">
						<table cellpadding="0" cellspacing="0" class="table_search" summary="조회 조건">
							<caption>조회 조건</caption>
							<colgroup>
								<col width="20%" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">법인등록번호 <img src="<c:url value="/images/ucm/btn_code.png" />" id="add_tooltip" alt="?" width="20" height="20" /></th>
									<td>
										<input name="searchJurirno" type="text" id="searchJurirno" class="text" placeholder="법인등록번호를 입력하세요." style="width: 370px;" onkeypress="press(event);" />
										<p class="btn_src_zone"><a href="#" class="btn_search" id="btn_find_userId">조회</a></p>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<!-- 검색 영역 // -->
					
					<!--// 리스트 -->
					<div class="list_zone">
						<table cellspacing="0" border="0" summary="목록">
							<caption>리스트</caption>
							<colgroup>
								<col width="20%" />
								<col width="*" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">기업명</th>
									<th scope="col">법인등록번호</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${list}" var="list" varStatus="status"> 
									<tr>
										<td><a href="#none" onclick="doConfmInsert('${list.jurirno}', '${list.entrprsNm}', '${list.bizrno}', '${list.userNo}')">${list.entrprsNm}</a></td>
										<td>${list.jurirno}</td>                           
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
					<!-- <div class="mgt10"></div> -->
					<!--// paginate -->
					<!-- <div class="paginate"> <ap:pager pager="${pager}" /> </div> -->
					<!-- paginate //-->
				</div>
			</div>
		</div>
		<!--content//-->
	</form>
</body>
</html>