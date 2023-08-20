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
<title>기업검색|기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox,json" />
<ap:jsTag type="tech" items="msg,util,sp,cmn, mainn, subb, font" />

<script type="text/javascript">

	// 유효년도 검색을 위한 input 나오게하기
	function changeBox(val){
		var html;
		var searchType1 = document.getElementById("searchType1");
		var searchType2 = document.getElementById("searchType2");
		
		switch (val) {
		case "ENTRPRS_NM" :
			searchType1.style.display = "inline-block"
			searchType2.style.display = "none"		
			break;
		case "JURIRNO" :
			searchType1.style.display = "inline-block"
			searchType2.style.display = "none"	
			break;
		case "선택" :
			searchType1.style.display = "inline-block"
			searchType2.style.display = "none"	
			break;
		case "VALID" :
			searchType1.style.display = "none"
			searchType2.style.display = "inline-block"	
			break;
		default :
		}
	}
	
	/*
	 * 검색단어 입력 후 엔터 시 자동 submit
	 */
	function press(event) {
		if (event.keyCode == 13) {
			btn_entprs_get_list();
		}
	}
	
	/*
	 * 목록 검색
	 */
	function btn_entprs_get_list() {
		$("#load_msg").text("검색 중 입니다. 잠시만 기다려주십시오.");
		$.blockUI({message:$("#loading")});
		
		var form = document.dataForm;
		form.df_curr_page.value = 1;
		form.df_method_nm.value = "";
		form.submit();
	}
	
	// 엑셀다운로드
	function excelDown() {
		$("#load_msg").text("엑셀다운로드를 위한 데이터를 불러오고 있습니다. 잠시만 기다려주십시오.");
		$.blockUI({message:$("#loading")});
		
		setTimeout(function() {
			$.unblockUI({message:$("#loading")});
		}, 10000);
		
		var form = document.dataForm;

		form.df_method_nm.value = "excelRsolver";
		form.submit();
	}
	

</script>
</head>

<body>
	<div id="wrap" class="top_bg">
		<form name="dataForm" id="dataForm" method="post">
			<div class="s_cont" id="s_cont">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />
		
				<input type="hidden" id="pageNo" value="${indexInfo.pageNo}" /> <input type="hidden" id="rowSize" value="${indexInfo.rowSize}" />
			
				<div class="s_tit s_tit03">
					<h1>기업정책</h1>
				</div>
				<div class="s_wrap">
					<div class="l_menu">
						<h2 class="tit tit3">기업정책</h2>
						<ul>
						</ul>
					</div>
					
					<div class="r_sec">
						<div class="r_top">
							<ap:trail menuNo="${param.df_menu_no}" />
						</div>
						
						<div class="r_cont s_cont03_03">
							<div class="sear_sec st_bl01">
								
							</div>
							<div class="img_list">
								<ul>
									<c:if test="${fn:length(resultList) == 0}">
										<tr>
											<td colspan="">
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
										<li class="il_item">
											<a href=http://${resultInfo.URL_BOARD}>
												<img src=/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${resultInfo.IMG_FILE} style="height:197px">
												<div class="il_cont">
													<p class="tit" style="display: -webkit-box;-webkit-box-orient: vertical;-webkit-line-clamp: 1;overflow: hidden;margin-right: 20px;">${resultInfo.SUBJ_BOARD}</p>
													<span>${resultInfo.DATE_BOARD}</span>
												</div>
											</a>
										</li>
									</c:forEach>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
	
	<!-- loading -->
	<div style="display:none">
		<div class="loading" id="loading">
			<div class="inner">
				<div class="box">
			    	<p>
			    		<span id="load_msg">데이터를 불러오고 있습니다. 잠시만 기다려주십시오.</span>
						<br />
						시스템 상태에 따라 최대 10분 정도 소요될 수 있습니다.
					</p>
					<span><img src="<c:url value="/images/etc/loading_bar.gif" />" width="323" height="39" alt="loading" /></span>
				</div>
			</div>
		</div>
	</div>
</body>
</html>