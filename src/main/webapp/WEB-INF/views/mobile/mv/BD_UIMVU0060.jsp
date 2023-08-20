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
<title>기업정책</title>
<ap:jsTag type="web" items="jquery,tools,ui" />
<ap:jsTag type="tech" items="util,mv" />
<script type="text/javascript">
	var listLength = "${inparam.cnt}";
	
	$(document).ready(function() {
		// 게시글 수가 10개 이상일때 더보기 표시
		if(listLength < 10) {
			$('.btn_ft').hide();
		} else {
			$('.btn_ft').show();
		}

		/* 선택한 tab의 class에 on 처리 */
		var tabGb = $("#tabGb").val();
		$("#tab" + tabGb).attr("class", "on");

		// 더보기
		$("#btn_more").click(function() {
			$("#ad_moreList").val("MORE");
			$.ajax({
				url : "PGMV0060.do",
				type : "POST",
				dataType : "json",
				data : {
					df_method_nm : "index"
					,"ad_moreList" : $('#ad_moreList').val()
					,"ad_limitFrom" : $('#ad_limitFrom').val()
					/* ,"searchCondition" : $('#searchCondition').val()
					,"searchKeyword" : $('#searchKeyword').val() */
					,"ad_ajax" : "Y"
					,"tabGb" : $('#tabGb').val()
				},
				async : false,
				success : function(response) {
					try {
						if (response.result) {
							for (var i = 0; i < (response.value).length; i++) {
								$('.bs_list').append(
									'<dl><dt><a href="'
									+ response.value[i].url
									+ '" target="_blank">'
									+ response.value[i].sj
									+ '</a></dt><dd class="pl0">'
									+ response.value[i].realm
									+ '</dd><dd>'
									+ response.value[i].mngtMiryfc
									+ '</dd><dd>'
									+ response.value[i].opertnBginde
									+ ' ~ '
									+ response.value[i].opertnEndde
									+ '</dd></dl>'
								);
							}
							$('.btn_ft').hide();
						} else {
							return;
						}
					} catch (e) {
						if (response != null) {
							jsSysErrorBox(response);
						} else {
							jsSysErrorBox(e);
						}
						return;
					}
				}
			});
		});
	});

	/*
	 * 목록 검색
	 */
	/* function btn_suport_get_list() {
		
		if($("#searchKeyword").val() == "" && $("#searchCondition").val() == "all") {
			
		}
		else if($("#searchKeyword").val() != "" || $("#searchCondition").val() != "all")
		{
			if($("#searchCondition  option:selected").val() == "all" || $("#searchKeyword").val() == "")
			{
				alert("검색항목을 선택하세요.");
				document.getElementById("ad_moreList").value = "";
				return false;
			}
		}

		var form = document.dataForm;
		form.df_method_nm.value = "";
		document.getElementById("ad_limitFrom").value = "0";
		document.getElementById("ad_moreList").value = "";
		form.submit();
	} */

	/* 탭 검색 */
	function tab_suport_get_list(tabGb) {
		var form = document.dataForm;

		form.tabGb.value = tabGb;

		form.df_method_nm.value = "";
		document.getElementById("ad_limitFrom").value = "0";
		document.getElementById("ad_moreList").value = "";
		form.submit();
	}
</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<input type="hidden" name="ad_moreList" id="ad_moreList" />
		<input type="hidden" name="ad_limitFrom" id="ad_limitFrom" value='${inparam.limitTo}' />
		<input type="hidden" name="tabGb" id="tabGb" value="${inparam.tabGb}" />

		<!--//내용영역-->
		<section class="notice">
			<div class="sub_con">
				<div class="tabwrap">
					<div class="tab">
						<ul>
							<li id="tabA" onclick="tab_suport_get_list('A')"><span>금융·경영</span></li><li id="tabB" onclick="tab_suport_get_list('B')"><span>기술·인력</span></li><li id="tabC" onclick="tab_suport_get_list('C')"><span>수출·내수</span></li><li id="tabD" onclick="tab_suport_get_list('D')"><span>기타</span></li>
						</ul>
					</div>
					<!-- //검색 -->
					<%-- <div class="sch">
                    <fieldset>
                        <legend>지원사업 검색</legend>
                        <div class="sel">
                            <select name="searchCondition" id="searchCondition" style="width:100px;vertical-align:top;">
                                <option value="all" <c:if test="${(inparam.searchCondition != 'realm') && (inparam.searchCondition != 'mngtMiryfc') }">selected</c:if> >선택</option>
                                <option value="realm" <c:if test="${inparam.searchCondition == 'realm' }">selected</c:if> >사업분야</option>
                                <option value="mngtMiryfc" <c:if test="${inparam.searchCondition == 'mngtMiryfc' }">selected</c:if>>주관기관</option>
                            </select>
                        </div>
                        <div class="sip"><input type="text" name="searchKeyword" id="searchKeyword" title="검색어를 입력하세요." placeholder="검색어를 입력하세요." maxlength="50" value='<c:out value="${inparam.searchKeyword}"/>' ></div>
                        <button class="btn_sch" onclick="btn_suport_get_list(); return false;">검색</button>
                    </fieldset>
                </div> --%>
					<!-- <div class="tit_page" style="display: none">기업을 위한 지원사업 정보를 제공합니다.</div> -->
					<div class="bs_list">
						<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
						<c:if test="${fn:length(suportList) == 0}">
							<dl>
								<dt>지원사업 정보가 없습니다.</dt>
							</dl>
						</c:if>
						<%-- 데이터를 화면에 출력해준다 --%>
						<c:forEach items="${suportList}" var="suportList" varStatus="status">
							<dl>
								<dt>
									<a href="${suportList.url}" target="_blank">${suportList.sj}</a>
								</dt>
								<dd class="pl0">${suportList.realm}</dd>
								<dd>${suportList.mngtMiryfc}</dd>
								<dd>${suportList.opertnBginde}~${suportList.opertnEndde}</dd>
							</dl>
						</c:forEach>
					</div>
					<div class="btn_ft">
						<a href="#none" id="btn_more" class="btn_more">더보기<span class="bul"></span></a>
					</div>
				</div>
			</div>
		</section>
		<!--내용영역//-->
	</form>
</body>
</html>