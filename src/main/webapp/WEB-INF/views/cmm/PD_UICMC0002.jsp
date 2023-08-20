<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<script type="text/javascript">
$(document).ready(function(){

});

function setDartData(crpCd,id){	
	getEntInfo(crpCd,id);
	$.colorbox.close();
}
</script>
</head>

<body>

<div id="pop_sys_code">
	<div class="pop_txt_top">아래 목록에서 해당 기업을 선택해 주세요</div>
	
	<!--//리스트-->
	<div class="pop_list_zone">
		<table cellspacing="0" border="0" summary="기업명,대표자,업종 정보를 제공합니다.">
			<caption>상호출자제한기업집단 조회 게시판</caption>
			<colgroup>
				<col />
				<col width="30%" />
				<col width="30%" />
				<col width="40%" />				
			</colgroup>
			<thead>
				<tr>
					<th scope="col">crpCd</th>
					<th scope="col">기업명</th>
					<th scope="col">대표자</th>
					<th scope="col">업종</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
				   	<c:when test="${codeMapList['result']}">
					  	<c:forEach items="${codeMapList['value']}" var="code" varStatus="status">                	
						<tr onclick="setDartData('${code.cikCd}','${param.id}')" style="cursor:pointer;">
							<td>${code.cikCd}</td>
							<td>${code.cikNm}</td>
							<td class="tac">${code.rprNm}</td>
							<td>${code.indutyNm}</td>					                        
						</tr>
						</c:forEach>
					</c:when>
				   	<c:otherwise>
				   		<td colspan="4" style="text-align:center;">일치하는 회사명이 없습니다.</td>
				   	</c:otherwise>
				</c:choose>
			</tbody>
		</table>
	</div>
	<!--리스트//-->
</div>

</body>
</html>