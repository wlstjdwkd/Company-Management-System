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
<title>지원사업|기업정책|WC300</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,mask" />
<ap:jsTag type="tech" items="ucm,msg,util,sp" />

</head>
<body>
	<form name="dataForm" id="dataForm" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />

		<div id="wrap" class="top_bg">
			<div class="contents">
				<!--//top img-->
				<div class="top_img menu01">Policies & Business for TechBlueGenic 대한민국 기업을
					위한 시책과 지원사업 등의 정보를 제공합니다.</div>
				<!--top img //-->
				<!--// lnb 페이지 타이틀-->
				<div class="title_page">
					<h2>
						<img src="<c:url value='/images/sp/title_m1.png' />" alt="기업정책" />
					</h2>
				</div>
				<!--lnb 페이지 타이틀//-->
				<div id="go_container">
					<!--//우측영역 -->
					<div class="rcont">
						<!--//page title -->
						<!--             <h3>기업지원사업 <span class="page_history"> > <a href="#">기업정책</a> > <a href="#">기업지원사업 </a></span></h3> -->
						<ap:trail menuNo="${param.df_menu_no}" />
						<!--page title //-->
						<!--//sub contents -->
						<div class="sub_cont">
							<div class="define">
								<img src="<c:url value="/images/sp/wc300_img_01_01.jpg"/>" width = "750px" height = "165px" alt="" /> <span>World Class 300 기업의
									개념</span>
								<p>기업 스스로 성장역량을 강화하고 지속적인 혁신을 통해 미래 성장 동력과 경쟁우위를 확보하며, 거래관계의 독립성을 바탕으로 성장잠재력이 큰 시장에서 글로벌
									기업과 경쟁, 거래 협력하면서 시장 지배력을 확대하는 기업</p>
							</div>
							<img src="<c:url value="/images/sp/wc300_img_01_01_01.jpg"/>" width = "780px" alt="" />
							<div class="pTitle mgb25">사업목적</div>
							<p class="commonParagraph01 mgb30">글로벌 기업으로의 성장의지와 잠재력을 갖춘 중소·기업을 World Class 300 기업으로
								육성함으로써, 취약한 산업의 허리를 강화하고 성장 동력을 지속적으로 확충하며 질 좋은 일자리를 창출하는 World Class기업을 300개 육성</p>
							<div class="pTitle mgb25">사업내용</div>
							<p class="commonParagraph01 mgb30">기업 스스로 성장역량을 강화하고 지속적인 혁신을 통해 미래 성장 동력과 경쟁우위를 확보하며,
								거래관계의 독립성을 바탕으로 성장잠재력이 큰 시장에서 글로벌 기업과 경쟁, 거래, 협력하면서 시장 지배력을 확대하는 기업</p>
							<img src="<c:url value="/images/sp/wc300_img_01_01_02.jpg"/>" width = "780px" alt="" />
						<div class="btn_page mgr200 mgt30"><a class="btn_page_blue mgr100" href="http://www.worldclass300.or.kr/" target="_blank"><span>자세히 보기</span></a></div>
						</div>
					</div>
					<!--//우측 영역 -->
				</div>
			</div>
		</div>
	</form>
</body>
</html>