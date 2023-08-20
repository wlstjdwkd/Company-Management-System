<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title>정보</title>	
</head>
<body>
<form name="menuForm" id="menuForm" method="post">
<ap:include page="param/menuParam.jsp" />
</form>
<ap:globalConst />
<p id="skipNav">
	  <a href="#s_cont">본문 바로가기</a>
	  <a href="#header">주메뉴 바로가기</a>
 </p>
<div id="header" class="" style="color: rgb(0, 0, 0); height: 79px;">
		<div class="head" style="color: rgb(0, 0, 0); height: 79px;">
			<div class="logo">
				<h1 class="header_txt"><a href="PGUM0001.do" title="메인이동">기업 정보</a></h1>
			</div>
			<div class="menu">
				<ul class="oneD">
					<!-- <li><a href="#none" onclick="jsMoveMenu('1','3','PGHI0020')" class="oned">기업현황</a>
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
								<li><a href="#none" onclick="jsMoveMenu('7','120','PGMY0060')">신청내역조회</a></li>
								<li><a href="#none" onclick="jsMoveMenu('7','17','PGIC0030')">진위확인</a></li>
								<li><a href="#none" onclick="jsMoveMenu('7','6','PGPC0010')">발급기업 조회</a></li>
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
					
					<li><a href="#none" onclick="jsMoveMenu('5','152','PGCS1008')" class="oned">정보제공</a>
						<div class="twod">
							<ul>
								<li><a href="#none" onclick="jsMoveMenu('5','152','PGCS1008')">우수사례</a></li>
								<li><a href="#none" onclick="jsMoveMenu('5','70','PGBS1003')">보도자료</a></li>
								<li><a href="#none" onclick="jsMoveMenu('5','139','PGBS1007')">자료실</a></li>
								<li><a href="#none" onclick="jsMoveMenu('5','153','PGSP0030')">사업공고</a></li>
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
							</ul>
						</div>	 				
					</li> -->
					<%-- <li><a href="<c:url value='${PUB_INDEX_URL}' />" class="header_right">홈</a></li> --%>
					<c:choose>
     					<c:when  test="${empty userInfoVo}">
							<li style="margin-left:50px;"><a href="#none" onclick="${PUB_LOGIN_URL}" class="header_right">로그인</a></li>
							<!-- <li class="header_right">|</li> -->
     						<%-- <li><a href="#none" onclick="${PUB_FINDUSERINFO_URL}" class="header_right">아이디/비밀번호찾기</a></li> --%>
     						<!-- <li class="header_right">|</li> -->
     						<%-- <li><a href="#none" onclick="${PUB_CHANGE_MAN_URL}" class="header_right">담당자 확인/정보 변경</a></li> --%>
     						<!-- <li class="header_right">|</li> -->
     						<%-- <li><a href="#none" onclick="${PUB_JOIN_URL}" class="header_right">시스템회원가입</a></li> --%>
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
</body>
</html>