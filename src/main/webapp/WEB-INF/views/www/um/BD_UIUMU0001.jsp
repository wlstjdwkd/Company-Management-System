<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>정보</title>

<ap:jsTag type="web" items="jquery,tools,ui,cookie,form,validate,notice,colorbox,flot,jqGrid,msgBox,mask,colorbox,json,jBox" />
<ap:jsTag type="tech" items="util,um,msg,cmn, mainn, font, bxslider, slick, owl" />

<c:choose>
	<c:when test="${isHttps == true }">
		<link rel="stylesheet" href="https://fonts.googleapis.com/earlyaccess/nanumgothic.css">
	</c:when>
	<c:otherwise>
		<link rel="stylesheet" href="http://fonts.googleapis.com/earlyaccess/nanumgothic.css">
	</c:otherwise>
</c:choose>
<link href="/css/main.css" type="text/css" rel="stylesheet">

<script>
	/* $(document).ready(function(){
		$(".bxslider").bxSlider({
			auto : true
		});	
	});
 */
	$(function(){
		$('.bxslider').bxSlider({
		  auto: true,
		  autoControls: true,
		  stopAutoOnClick: true,
		  pager: true,
			  pause: 5000
		});
	});
	$(function(){
		$('.minbanner1').bxSlider({
		  mode: "fade",
		  auto: true,
		  autoControls: true,
		  stopAutoOnClick: true,
		  pager: true,
			  pause: 2000

		});
	});
	$(function(){
		$('.minbanner2').bxSlider({
		  mode: "fade",
		  auto: true,
		  autoControls: true,
		  stopAutoOnClick: true,
		  pager: true,
			  pause: 3000
		});
	});
	$(function(){
		$('.minbanner3').bxSlider({
		  mode: "fade",
		  auto: true,
		  autoControls: true,
		  stopAutoOnClick: true,
		  pager: true,
			  pause: 2000
		});
	});
	$(document).ready(function(){
		$('.visual .bx-stop').click(function(){
			console.log('11');
			$(this).css('display','none');
			$('.visual .bx-start').css('display','block');
		});
		$('.visual .bx-start').click(function(){
			console.log('11');
			$(this).css('display','none');
			$('.visual .bx-stop').css('display','block');
		});
		
		$('.r_banner1 .bx-stop').click(function(){
			console.log('11');
			$(this).css('display','none');
			$('.r_banner1 .bx-start').css('display','block');
		});
		$('.r_banner1 .bx-start').click(function(){
			console.log('11');
			$(this).css('display','none');
			$('.r_banner1 .bx-stop').css('display','block');
		});
		
		$('.r_banner2 .bx-stop').click(function(){
			console.log('11');
			$(this).css('display','none');
			$('.r_banner2 .bx-start').css('display','block');
		});
		$('.r_banner2 .bx-start').click(function(){
			console.log('11');
			$(this).css('display','none');
			$('.r_banner2 .bx-stop').css('display','block');
		});
		
		$('.r_banner3 .bx-stop').click(function(){
			console.log('11');
			$(this).css('display','none');
			$('.r_banner3 .bx-start').css('display','block');
		});
		$('.r_banner3 .bx-start').click(function(){
			console.log('11');
			$(this).css('display','none');
			$('.r_banner3 .bx-stop').css('display','block');
		});

	// 기업명 툴팁
	$("#change").jBox('Tooltip', {
		content: '기업회원의 담당자정보 또는 기업명 조회·변경 <br/>(단, 기업확인서 상 내용변경신청은 기업 확인 - 신청/발급내역조회에서 가능)'
	});
	
	// 확인서 신청 툴팁
	$("#apply").jBox('Tooltip', {
		content: '확인서 신청·발급은 <strong>기업회원만 가능</strong>합니다. '
	});

	});
	
</script>
</head>

<BODY>
<form name="menuForm" id="menuForm" method="post">
	<ap:include page="param/menuParam.jsp" />
	</form>
	<ap:globalConst />
 <p id="skipNav">
	  <a href="#contents">본문 바로가기</a>
	  <a href="#header">주메뉴 바로가기</a>
 </p>
  	<div id="header" class="" style="color: rgb(0, 0, 0); height: 79px;">
		<div class="head" style="color: rgb(0, 0, 0); height: 79px;">
			<div class="logo">
				<h1 class="header_txt"><a href="PGUM0001.do" title="메인이동">기업 정보</a></h1>
			</div>
			<div class="menu">
				<ul class="oneD">
					<li><a href="#none" onclick="jsMoveMenu('1','3','PGHI0020')" class="oned">기업현황</a>
						<div class="twod Visible" id="tab1">
							<ul>
								<li><a href="#none" onclick="jsMoveMenu('1','3','PGHI0020')">기업 범위</a></li>
								<li><a href="#none" onclick="jsMoveMenu('1','2','PGHI0010')">기업 기준</a></li>
								<li><a href="#none" onclick="jsMoveMenu('1','14','PGPC0020')">기업 통계</a></li>
								<li><a href="#none" onclick="jsMoveMenu('1','84','PGHI0030')">관련 법령</a></li>
							</ul>
						</div>
					</li>
					<li><a href="#none" onclick="jsMoveMenu('7','8','PGIC0010')" class="oned">기업확인</a>
						<div class="twod">
							<ul>
								<li><a href="#none" onclick="jsMoveMenu('7','8','PGIC0010')">확인절차 안내</a></li>
								<li><a href="#none" onclick="jsMoveMenu('7','149','PGIC0011')">제출서류 안내</a></li>
								<li><a href="#none" onclick="jsMoveMenu('7','16','PGIC0020')">신청서 작성</a></li>
								<li><a href="#none" onclick="jsMoveMenu('7','120','PGMY0060')">신청/발급내역조회</a></li>
								<li><a href="#none" onclick="jsMoveMenu('7','17','PGIC0030')">진위확인</a></li>
								<li><a href="#none" onclick="jsMoveMenu('7','6','PGPC0010')">발급정보 공개</a></li>
							</ul>
						</div>					
					</li>
					<li><a href="#none" onclick="jsMoveMenu('9','10','PGSP0010')" class="oned">기업정책</a>
						<div class="twod">
							<ul>
								<li><a href="#none" onclick="jsMoveMenu('9','10','PGSP0010')">기업 비전 2020</a></li>
								<li><a href="#none" onclick="jsMoveMenu('9','87','PGSP0060')">기업 사업지원</a></li>
								<li><a href="#none" onclick="jsMoveMenu('9','151','PGSP0070')">기업 조세지원</a></li>
							</ul>
						</div>					
					</li>
					<!-- <li><a href="#none" onclick="jsMoveMenu('5','152','PGCS1008')" class="oned">정보제공</a> -->
					<li><a href="#none" onclick="jsMoveMenu('5','70','PGBS1003')" class="oned">정보제공</a>
						<div class="twod">
							<ul>
								<!-- <li><a href="#none" onclick="jsMoveMenu('5','152','PGCS1008')">우수사례</a></li> -->
								<li><a href="#none" onclick="jsMoveMenu('5','70','PGBS1003')">보도자료</a></li>
								<li><a href="#none" onclick="jsMoveMenu('5','139','PGBS1007')">자료실</a></li>
								<li><a href="#none" onclick="jsMoveMenu('5','87','PGSP0030')">사업공고</a></li>
								<li><a href="#none" onclick="jsMoveMenu('5','13','PGCS0070')">채용공고</a></li>
							</ul>
						</div>					
					</li>
					<c:set var="userInfoVo" value="${sessionScope[SESSION_USERINFO_NAME]}" />
					<li><a href="#none" onclick="jsMoveMenu('11','12','PGBS1001')" class="oned">고객지원</a>
						<div class="twod">
							<ul>
								<li><a href="#none" onclick="jsMoveMenu('11','12','PGBS1001')">공지사항</a></li>
								<li><a href="#none" onclick="jsMoveMenu('11','21','PGBS1004')">자주하는 질문</a></li>
								<li><a href="#none" onclick="jsMoveMenuURL('11','76','PGBS1005','PGBS1005.do?df_method_nm=boardWriteForm&pageType=INSERT')">묻고 답하기</a></li>
								<li><a href="#none" onclick="jsMoveMenu('11','148','PGCS0110')">원격지원</a></li>
								<li><a href="#none" onclick="jsMoveMenu('11','138','PGCS0090')">사이트맵</a></li>
								<li><a href="#none" onclick="jsMoveMenuURL('11','146','PGCMLOGIO0050','PGCMLOGIO0050.do?df_method_nm=index')">가입정보 조회/변경</a></li>
							</ul>
						</div>					
					</li>
					<%-- <li><a href="<c:url value='${PUB_INDEX_URL}' />" class="header_right">홈</a></li> --%>
					<c:choose>
     					<c:when  test="${empty userInfoVo}">
							<li style="margin-left:50px;"><a href="#none" onclick="${PUB_LOGIN_URL}" class="header_right">로그인</a></li>
							<li class="header_right">|</li>
     						<%-- <li><a href="#none" onclick="${PUB_FINDUSERINFO_URL}" class="header_right">아이디/비밀번호찾기</a></li> --%>
     						<!-- <li class="header_right">|</li> -->
     						<%-- <li><a href="#none" onclick="${PUB_CHANGE_MAN_URL}" class="header_right">담당자 확인/정보 변경</a></li> --%>
     						<!-- <li class="header_right">|</li> -->
     						<li><a href="#none" onclick="${PUB_JOIN_URL}" class="header_right">시스템회원가입</a></li>
     					</c:when>
     					<c:otherwise>
     						<li style="margin-left:50px;"><a href="#none" onclick="${PUB_LOGOUT_URL}" class="header_right">로그아웃</a></li>
     						<li class="header_right">|</li>
     					</c:otherwise>
    					</c:choose>
    					<c:if test="${!empty userInfoVo}">
							<li><a href="#none" onclick="${PUB_MYPAGE_URL}" class="header_right">마이페이지</a></li>
							<!-- <li class="header_right">|</li> -->
							<%-- <li><a href="#none" onclick="${PUB_CHANGE_MAN_URL}" class="header_right">담당자 확인/정보 변경</a></li> --%>
							<c:forEach items="${userInfoVo.authorGroupCode}" var="grpCd" varStatus="status">
								<c:if test="${grpCd == AUTH_DIV_ADM || grpCd == AUTH_DIV_BIZ}">
									<li class="header_right">|</li>			
									<li><a href="<c:url value='${ADM_INDEX_URL}'/>" class="header_right">관리자</a></li>
								</c:if>
							</c:forEach>
						</c:if>
				</ul>
			</div>
		</div>
	</div>
	<div id="wrap">
	<div id="container">
		<div class="cont_wrap">
			<div class="confirm" id="contents">
				<h5 class="tit">기업 확인 (기업회원 전용)</h5>
				<div class="cont">
					<a href="#none" class="sec sec1" onclick="jsMoveMenu('1','3','PGHI0020')">
						<div>
							<p>기업 범위</p>
						</div>
					</a>
					<a href="#none" class="sec sec2" onclick="jsMoveMenu('1','2','PGHI0010')">
						<div>
							<p>기업 기준</p>
						</div>
					</a>
					<a href="#none" class="sec sec3" onclick="jsMoveMenu('7','8','PGIC0010')">
						<div>
							<p>확인절차 안내</p>
						</div>
					</a>
					<a href="#none" class="sec sec4" onclick="jsMoveMenu('7','149','PGIC0011')">
						<div>
							<p>제출서류 안내</p>
						</div>
					</a>
					<a href="#none" class="sec sec5" id="apply" onclick="jsMoveMenu('7','16','PGIC0020')">
						<div>
							<p>신청서 작성</p>
							<span style="color: #666">(신규/갱신)</span><br/>
							<span style="color: #2763ba">(기업회원 전용)</span>
						</div>
					</a>
					<a href="#none" class="sec sec6" onclick="jsMoveMenu('7','120','PGMY0060')">
						<div>
							<p>신청/발급내역 조회</p>
							<span style="color: #666">(내용변경)</span>
						</div>
					</a>
				</div>
			</div>
			<div class="visual">
				<ul class="bxslider">
						<li>
							<a href="http://www.mme-innovation.org/2019/" target="_blank">
							<img src="/images2/main/pop/877_809.jpg" alt="2019기업 혁신 국제 컨퍼런스" /></a>
						</li>
						<li>
							<img src="/images2/main/pop/notice_191018_a.png" alt="공인인증서 도입안내" />
						</li>
						<li>
							<img src="/images2/main/pop/notice_191018_b.png" alt="도메인 변경 안내">
						</li>
						<!-- <li>
							<img src="/images2/main/pop/notice_190822_01.png" alt="정보 이용안내">
						</li> -->
						<!-- <li>
							<a href="http://www.fomek.or.kr/main/etc/sinmungo2.php?page=1" target="_blank">
							<img src="/images2/main/pop/notice_190822_02.png" alt="피해 접수 센터" /></a>
						</li>  -->
				</ul>
			</div>
			<div class="member" id="contents">
					<h5 class="tit">회원가입 및 정보 조회/변경</h5>
					<div class="cont">
						<a href="#none" class="sec sec1" onclick="jsMoveMenu('24','47','PGCMLOGIO0040')">
							<div>
								<p>시스템 회원가입</p>
								<span>(개인/기업회원)</span>
							</div>
						</a>
						<a href="#none" class="sec sec2" id="change" onclick="jsMoveMenuURL('11','146','PGCMLOGIO0050','PGCMLOGIO0050.do?df_method_nm=index')">
							<div>
								<p>가입정보 조회/변경</p>
								<span style="color: #2763ba">(기업회원 전용)</span>
							</div>
						</a>
						<a href="#none" class="sec sec3" onclick="jsMoveMenu('24', '85', 'PGCMLOGIO0020')">
							<div>
								<p>아이디/비밀번호 찾기</p>
							</div>
						</a>
					</div>
				</div>
			<div href="#" class="r_banner r_banner1" style="width:280px; height:84px;">
				<ul class="minbanner1">
					<li>
						<a href="http://www.fomek.or.kr/main/news/heated.php" target="_blank">
							<img src="/images2/main/banner/main_banner_01.png" alt="기업 열전">
						</a>
					</li>
					<!-- <li>
						<a href=""><img src="web/images/main/right_banner1.png"></a>
					</li>
					<li>
						<a href=""><img src="web/images/main/right_banner1.png"></a>
					</li> -->
				</ul>
			</div>
			<div href="#" class="r_banner r_banner2" style="width:280px; height:84px;">
				<ul class="minbanner2">
					<li>
						<a href="http://www.fomek.or.kr/main/business/business14.php"  target="_blank">
							<img src="/images2/main/banner/main_banner_03_a.png" alt="일학습병행">
						</a>
					</li>
					<li>
						<a href="http://academy.fomek.or.kr" target="_blank">
							<img src="/images2/main/banner/main_banner_02.png" alt="기업 핵심인재 육성 아카데미">
						</a>
					</li>
					<!-- <li>
						<a href=""><img src="web/images/main/right_banner2.png"></a>
					</li>
					<li>
						<a href=""><img src="web/images/main/right_banner2.png"></a>
					</li> -->
				</ul>
			</div>
			<div href="#" class="r_banner r_banner3" style="width:280px; height:84px;">
				<ul class="minbanner3">
					<li>
						<a href="http://www.fomek.or.kr/main/etc/notice_view.php?pk_seq=944&sc_cond=wr_all&sc_str=%EC%82%AC%EC%97%85%EC%A0%84%ED%99%98&sc_bo_table=news&page=1&" target="_blank">
							<img src="/images2/main/banner/main_banner_03_b.png" alt="사업전환 지원사업">
						</a>
					</li>
				<!-- <li>
						<a href=""><img src="web/images/main/right_banner2.png"></a>
					</li>
					<li>
						<a href=""><img src="web/images/main/right_banner3.png"></a>
					</li> -->
				</ul>
			</div>
			
			<div class="muchuse">
				<ul>
					<li>
						<a href="#none" class="sec sec1" onclick="jsMoveMenu('1','14','PGPC0020')">
							<p>기업 통계</p>
						</a>
					</li>
					<li>
						<a href="#none" class="sec sec2" onclick="jsMoveMenu('9','10','PGSP0010')">
							<p>기업 정책</p>
						</a>
					</li>
					<li>
						<a href="#none" class="sec sec3" onclick="jsMoveMenu('9','87','PGSP0060')">
							<p>사업지원</p>
						</a>
					</li>
					<li>
						<a href="#none" class="sec sec4" onclick="jsMoveMenu('9','151','PGSP0070')">
							<p>조세지원</p>
						</a>
					</li>
					<li>
						<a href="#none" class="sec sec5" onclick="jsMoveMenu('5','70','PGBS1003')">
							<p>보도자료</p>
						</a>
					</li>
					<li>
						<a href="#none" class="sec sec6" onclick="jsMoveMenu('11','12','PGBS1001')">
							<p>공지사항</p>
						</a>
					</li>
					<li>
						<a href="#none" class="sec sec7" onclick="jsMoveMenu('11','21','PGBS1004')">
							<p>자주하는 질문</p>
						</a>
					</li>
					<li>
						<a href="#none" class="sec sec8" onclick="jsMoveMenuURL('11','76','PGBS1005','PGBS1005.do?df_method_nm=boardWriteForm&amp;pageType=INSERT')">
							<p>묻고 답하기</p>
						</a>
					</li>
				</ul>
			</div>
		</div>
		
	</div>
	</div>
 </BODY>
</html>
