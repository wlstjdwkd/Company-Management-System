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
<title>기업정보찾기|기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery, colorbox, jqGrid, notice, css, validate" />
<ap:jsTag type="tech" items="font,cmn,mainn,subb,msg, util" />
<script type="text/javascript">
	$(document).ready(function() {
		// 전체아이디확인
		$("#btn_find_userId_all").click(function() {
			$("#df_method_nm").val("findUserIdAllForm");
			$("#dataForm").submit();
		});

	});
	
	// 정보변경신청 팝업
	var fn_cmpny_intrcn = function(epNo, bizrno){
		$.colorbox({
			title : "정보변경신청",
			href : "<c:url value='/PGCMLOGIO0050.do?df_method_nm=chargerInfo&ad_ep_no="+ epNo +"&ad_bizrno="+ bizrno +"' />",
			width : "1070",
			height : "660",
			overlayClose : false,
			escKey : false,
			iframe : true
		});
	};

</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />

		<!--//content-->
		<div id="wrap">
			<div class="s_cont" id="s_cont">
				<div class="s_tit s_tit07">
					<h1>회원서비스</h1>
				</div>
				<div class="s_wrap">
					<div class="l_menu">
						<h2 class="tit tit7">회원서비스</h2>
						<ul>
						</ul>
					</div>
					<div class="r_sec">
						<div class="r_top">
							<ap:trail menuNo="${param.df_menu_no}"  />
						</div>
						<div class="r_cont s_cont07_10">
							<div class="list_bl">
								<h4 class="fram_bl">기업정보찾기</h4>
								<p class="resultGuide" style="margin:0 auto;">기업정보 찾기 결과 입니다.</p>
								<div class="table_list">
								<table class="st_bl01 stb_gr01">
									<colgroup>
										<col width="310px">
										<col width="580px">
									</colgroup>
									<thead>
										<tr>
											<th>기업명</th>
											<th>법인등록번호</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${findEntUserList}" var="findEntUserList" varStatus="status">
										<tr>
											<td>
												<a href="#" onclick="fn_cmpny_intrcn('${findEntUserList.userNo}', '${findEntUserList.bizrno }')">${findEntUserList.ENTRPRS_NM}</a>
											</td>
											<td>
												<center>
												<a href="#" onclick="fn_cmpny_intrcn('${findEntUserList.userNo}', '${findEntUserList.bizrno }')">${findEntUserList.jurirno}</a>
												</center>
											</td>
										</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!--content//-->
	</form>
</body>
</html>