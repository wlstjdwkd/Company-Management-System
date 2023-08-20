<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,form,validate" />
<ap:jsTag type="tech" items="msg,util,ucm,mb" />
<ap:globalConst />
<script type="text/javascript">
	function btn_ok() {
		parent.$.colorbox.close();
	}
</script>
</head>

<body>
	<div id="pop_sys_code">

		<div class="write">
			<table class="table_basic pop_table">
				<caption>회원정보</caption>
				<colgroup>
					<col style="width: 20%" />
					<col style="width: 80%" />
				</colgroup>
				<tbody>
					<c:forEach items="${userInfo}" var="userInfo" varStatus="status">
						<tr>
							<th scope="row" class="point">회원분류</th>
							<c:if test="${userInfo.emplyrTy eq 'EP'}">
								<td>기업회원</td>
							</c:if>
							<c:if test="${userInfo.emplyrTy eq 'GN'}">
								<td>개인회원</td>
							</c:if>
						</tr>
						<tr>
							<th scope="row" class="point">아이디</th>
							<td>${userInfo.loginId}</td>
						</tr>
						<tr>
							<th scope="row" class="point">기업명</th>
							<td>${userInfo.entrprsNm}</td>
						</tr>
						<tr>
							<th scope="row" class="point">법인등록번호</th>
							<td>${userInfo.jurirno.substring(0,6)}-${userInfo.jurirno.substring(6)}</td>
						</tr>
						<tr>
							<th scope="row" class="point">이름</th>
							<td>${userInfo.userNm}</td>
						</tr>
						<c:if test="${userInfo.emplyrTy eq 'EP'}">
							<tr>
								<th scope="row" class="point">소속부서</th>
								<td>${userInfo.chargerDept}</td>
							</tr>
							<tr>
								<th scope="row" class="point">전화번호</th>
								<td>${telNum.first}-${telNum.middle}-${telNum.last}</td>
							</tr>
						</c:if>
						<tr>
							<th scope="row" class="point">휴대전화번호</th>
							<td>${mbtlNum.first}-${mbtlNum.middle}-${mbtlNum.last}</td>
						</tr>
						<tr>
							<th scope="row" class="point">이메일</th>
							<td><p>${userInfo.email}</p></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		<!--//페이지버튼-->
		<div class="btn_page tar">
			<a class="btn_page_blue" href="#none" onclick="btn_ok();"><span>확인</span></a>
		</div>
		<!--sub contents //-->
	</div>
</body>
</html>