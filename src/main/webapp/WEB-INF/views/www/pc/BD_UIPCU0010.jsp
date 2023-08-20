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
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorbox,blockUI" />
<ap:jsTag type="tech" items="cmn, mainn, subb, font,pc,msg,util,etc, paginate" />

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
	<form name="dataForm" id="dataForm" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />

		<input type="hidden" id="pageNo" value="${indexInfo.pageNo}" /> <input type="hidden" id="rowSize"
			value="${indexInfo.rowSize}" />

		<!--//content-->
		<div id="wrap">
			<div class="s_cont" id="s_cont">
		<div class="s_tit s_tit02">
			<h1>기업확인</h1>
		</div>
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit tit2">기업확인</h2>
				<ul>
				</ul>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}" />
				</div>
				<div class="r_cont s_cont02_09">
					<p class="list_noraml">확인서 발급 현황 목록은「기업 성장촉진 및 경쟁력 강화에 관한 특별법 시행령」제2조에 따라 <span>확인서 발급이 취소된 기업이 포함</span>되어<br/>있을 수 있으므로 참고용으로만 확인바랍니다.</p>
					<p class="list_noraml">지원사업 운영기관은 기업의 기업 여부를 확인하기 위해 기업에 기업 확인서 제출을 요청바랍니다. <span>(유효기간 및 진위확인 必)</span></p>
					<p class="list_noraml" style="margin-bottom: 26px;">기업 확인서 신청내역 조회 및 출력은 <span>기업확인 > 신청내역조회</span>에서 가능합니다.</p>
					<div class="sear_sec st_box01">
						<select class="select_box" name="search_year" id="search_year" style="width: 100px; ">
							<option value="0">발급년도</option>
							<c:forEach begin="2011" end="${indexInfo.cYear}" step="1" var="stat">										
								<option value="${stat}"
									<%-- <c:if test="${indexInfo.searchYear == stat}">selected="selected"</c:if> --%>
									<c:if test ="${indexInfo.searchYear  == stat}"> selected="selected" </c:if>>${stat}
								</option>
							</c:forEach>
						</select> 
						<select class="select_box" name="search_category" id="search_category" style="width: 100px; ">
							<option value="업종">업종전체</option>
							<option value="YY" <c:if test ="${param.search_category == 'YY'}"> selected="selected" </c:if>>제조</option>
							<option value="NN" <c:if test ="${indexInfo.searchCategory == 'NN'}"> selected </c:if>>비제조</option>
						</select> 
						<select class="select_box" name="search_zone" id="search_zone" style="width: 100px; ">
							<option value="지역">지역전체</option>
							<c:forEach items="${abrvList}" var="abrv" varStatus="status">
								<option value="${abrv.abrv}"
									<c:if test = "${abrv.abrv == indexInfo.searchZone}"> selected="selected" </c:if>>${abrv.abrv}</option>
							</c:forEach>
						</select> 
						<select class="select_box" name="search_cp" id="search_cp" style="width: 110px; " onchange = "changeBox(this.value);">
							<option value="선택">선택하세요</option>
							<option value="ENTRPRS_NM" <c:if test ="${'ENTRPRS_NM' == indexInfo.searchCp }" > selected="selected" </c:if>>기업명</option>
							<option value="JURIRNO" <c:if test ="${'JURIRNO' == indexInfo.searchCp}"> selected="selected" </c:if>>법인등록번호</option>
							<option value="VALID" <c:if test ="${'VALID' == indexInfo.searchCp}"> selected="selected" </c:if>>유효기간</option>
						</select>
						<span id = "searchType1" style="display: inline-block;">
						<input type="text" name="search_input" id="search_input" title="검색어를 입력하세요."
							placeholder="   검색어를 입력하세요." onFocus="this.placeholder=''; return true" maxlength="50"
							style="width: 300px; height: 35px; border: 1px solid #dadada; vertical-align: middle; " value="${indexInfo.searchInput}" />
						</span>
						<span style="display: inline-block; float:right;">
							<a href="#none" class="search_corp" onClick="btn_entprs_get_list();" style="color:white;" ><span><img src="/images2/sub/sear_ico.png"></span>검색</a>
						</span>
						<span id = "searchType2" style="display: none;">
							<select class="select_box" title="년도"  name = "validBeginSearchYear" id="validBeginSearchYear" style="width:80px;" >
								<c:forEach begin="2012" end="2015" step="1" var="stat">										
									<option value="${stat}"
										<c:if test ="${indexInfo.validSearchYear1  == stat}"> selected="selected" </c:if>>${stat}
									</option>
								</c:forEach>
	        	            </select>
	         	            <select class="select_box" title="월" name = "validBeginSearchMonth" id="validBeginSearchMonth" style="width:60px;">
	         	                <c:forEach begin="1" end="9" step="1" var="stat">    
	         	                    <option value="0${stat}" <c:if test ="${indexInfo.validSearchMonth1 == stat}"> selected="selected" </c:if>>${stat}</option>
	         	                </c:forEach>
	         	                <c:forEach begin="10" end="12" step="1" var="stat">    
	         	                    <option value="${stat}" <c:if test ="${indexInfo.validSearchMonth1 == stat}"> selected="selected" </c:if>>${stat}</option>
	         	                </c:forEach>
							</select> ~ 
							<select class="select_box" title="년도" name = "validEndSearchYear" id="validEndSearchYear" style="width:80px;">
								<c:forEach begin="2012" end="2016" step="1" var="stat">										
								<option value="${stat}"
									<c:if test ="${indexInfo.validSearchYear2  == stat}"> selected="selected" </c:if>>${stat}
								</option>
								</c:forEach>      	                    
							</select>
	            	        <select class="select_box" title="월" name = "validEndSearchMonth" id="validEndSearchMonth" style="width:60px; ">
	        	                <c:forEach begin="1" end="9" step="1" var="stat">
	        	                    <option value="0${stat}" <c:if test ="${indexInfo.validSearchMonth2 == stat}"> selected="selected" </c:if>>${stat}</option>
	        	                </c:forEach>
	        	                <c:forEach begin="10" end="12" step="1" var="stat">    
	        	                    <option value="${stat}" <c:if test ="${indexInfo.validSearchMonth2 == stat}"> selected="selected" </c:if>>${stat}</option>
	        	                </c:forEach>
	          	           </select>
	         	         </span>
					</div>
					<div class="btn_bl down_btn">
						<a href="#none" id="excelDown" onclick="excelDown();">엑셀 다운로드</a>
					</div>
					<ap:pagerParam />
					
					<div class="table_list">
						<table class="st_bl01 stb_gr01">
							<colgroup>
								<col width="72px">
								<col width="189px">
								<col width="149px">
								<col width="111px">
								<col width="211px">
								<col width="70px">
								<col width="82px">
							</colgroup>
							<thead>
								<tr>
									<th>번호</th>
									<th>기업명</th>
									<th>법인번호</th>
									<th>발급번호</th>
									<th>유효기간</th>
									<th>업종</th>
									<th>지역</th>
								</tr>
							</thead>
							<tbody>
								<c:if test="${fn:length(entprsList) == 0}">
										<tr>
											<td colspan="8"><c:if
													test="${param.searchCategory == '' || param.searchZone == '' || param.searchCp == '' || param.searchInput == ''}">
													<spring:message code="info.nodata.msg" />
												</c:if> <c:if
													test="${param.searchCategory != '' || param.searchZone != '' || param.searchCp != '' || param.searchInput != '' }">
													<spring:message code="info.noresult.msg" />
												</c:if></td>
										</tr>
									</c:if>
									<c:forEach items="${entprsList}" var="entprs" varStatus="status">
										<tr>
											<td>${pagerNo-(status.index)}</td>
											<td>${entprs.entrprsNm}</td>
											<td>${entprs.jurirno }</td>
											<td>${entprs.issuNo }</td>
											<td>${entprs.validPdBeginDe} ~ ${entprs.validPdEndDe}</td>
											
											<td title = "${entprs.mnIndutyNm}">${entprs.indutyCode}</td>

											<td>${entprs.hedofcAdres }</td>
										</tr>
									</c:forEach>
							</tbody>
						</table>
						<div style="text-align:center;"><ap:pager pager="${pager}" /></div>
						
					</div>
					
				</div>
			</div>
		</div>
	</div>
		</div>
		<!--content//-->
	</form>
	
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
					<span><img src="<c:url value="/images2/sub/loading_bar.gif" />" width="323" height="39" alt="loading" /></span>
				</div>
			</div>
		</div>
	</div>
</body>
</html>