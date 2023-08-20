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
<title>정보마당</title>
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask,selectbox" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javascript">
	
</script>
</head>

<body>
	<form name="dataForm" id="dataForm" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />

		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title_line">개인 이력 카드</h2>
					<!-- 타이틀 영역 //-->
					<div class="block">
						<h3>개인정보</h3>
						<!--// 등록 -->
						<table cellpadding="0" cellspacing="0" class="table_basic mgt10" summary="이력카드 개인정보">
							<caption>이력카드 개인정보</caption>
							<colgroup>
								<col width="15%" />
								<col width="30%" />
								<col width="15%" />
								<col width="*" />
							</colgroup>
							<tr>
								<th scope="row" class="point">성명</th>
								<td>${userInfo.EMP_NM} </td>
								<th scope="row" class="point">주민등록 번호</th>
								<td>${userInfo.CIZ_NO}</td>
							</tr>
							<tr>
								<th scope="row" class="point">성별</th>
								<td>${userInfo.GENDER}</td>
								
								<th scope="row" class="point">근무가능일</th>
								<td>${userInfo.WORK_START}</td>
								
							</tr>
							<tr>
								<th scope="row" class="point">부서</th>
								<td>${userInfo.DEPT_CD}</td>
								
								<th scope="row" class="point">직위</th>
								<td>${userInfo.POS_CD}</td>
							</tr>
							<tr>
								<th scope="row" class="point">결혼</th>
								<td>${userInfo.MRG}</td>
								
								<th scope="row" class="point">기타</th>
								<td>${userInfo.RMRK}</td>
							</tr>
							<tr>
								<th scope="row" class="point">전역구분</th>
								<td>${userInfo.MILI_STATE}</td>
								<th scope="row" class="point">군별</th>
								<td>${userInfo.MILI_TYPE}</td>
							</tr>
							<tr>
								<th scope="row" class="point">복무기간</th>
								<td>${userInfo.MILI_START}<br>~<br>${userInfo.MILI_END}</td>
								<th scope="row" class="point">병과</th>
								<td>${userInfo.MILI_CLASS}</td>
							</tr>
							<tr>
								<th scope="row" class="point">휴대전화번호</th>
								<td>${userInfo.MOB_TEL}</td>
								<th scope="row" class="point">집전화번호</th>
								<td>${userInfo.HM_TEL}</td>
							</tr>
							<tr>
								<th scope="row" class="point">이메일</th>
								<td>${userInfo.PER_MAIL}</td>
								<th scope="row" class="point">주소</th>
								<td>${userInfo.ADDR}</td>
							</tr>
						</table>
						
						<br>
						<h3>학력정보</h3>
						<table cellpadding="0" cellspacing="0" class="table_basic mgt10" summary="이력카드 학력정보">
							<caption>이력카드 학력정보</caption>
							<colgroup>
								<col width="20%" />
								<col width="20%" />
								<col width="20%" />
								<col width="20%" />
								<col width="*" />
							</colgroup>
							<thead>
									<tr>
										<th scope="col">대학이름</th>
										<th scope="col">학교</th>
										<th scope="col">학과</th>
										<th scope="col">입학년도</th>
										<th scope="col">졸업년도</th>
									</tr>
								</thead>
								<tbody>
									<c:if test="${fn:length(scholarInfo) == 0}">
										<tr>
											<td colspan="11"><c:if test="${param.searchJobSe == '' || param.searchProgramNm == ''}">
													<spring:message code="info.nodata.msg" />
												</c:if> <c:if test="${param.searchJobSe != '' || param.searchProgramNm != ''}">
													<spring:message code="info.noresult.msg" />
												</c:if></td>
										</tr>
									</c:if>
									<c:forEach items="${scholarInfo}" var="scholarInfo" varStatus="status">
										<tr>
											<td>${scholarInfo.SCHOOL_NAME}</td> 
											<td>${scholarInfo.SCHOOL_TYPE}</td>
											<td>${scholarInfo.DEPARTMENT}</td>
											<td>${scholarInfo.ADMISSION_YEAR}</td>
											<td>${scholarInfo.GRADUATE_YEAR}</td>
										</tr>
									</c:forEach>
								</tbody>
						</table>
						<br>
						<h3>프로젝트 경험</h3>
						<table cellpadding="0" cellspacing="0" class="table_basic mgt10" summary="이력카드 프로젝트 경험정보">
							<caption>이력카드 프로젝트 경험정보</caption>
							<colgroup>
								<col width="20%" />
								<col width="20%" />
								<col width="20%" />
								<col width="20%" />
								<col width="20%" />
								<col width="20%" />
								<col width="20%" />
								<col width="20%" />
								<col width="20%" />
								<col width="20%" />
								<col width="20%" />
								<col width="20%" />
							</colgroup>
							<thead>
									<tr>
					                    <th style="border:1px solid black;" scope="col" rowspan="2">프로젝트명</th>
										<th style="border:1px solid black;" scope="col" rowspan="2">고객사</th>
										<th style="border:1px solid black;" scope="col" rowspan="2">근무회사</th>
										<th style="border:1px solid black;" scope="col" rowspan="2">기간</th>
										<th style="border:1px solid black;" scope="col" rowspan="2">역할</th>
					                    <th style="border:1px solid black;" scope="col" colspan="7">개발환경</th>
										
					                </tr>
					                <tr>
					                    <th style="border:1px solid black;" scope="col">OS</th>
										<th style="border:1px solid black;" scope="col">기술</th>
										<th style="border:1px solid black;" scope="col">언어</th>
										<th style="border:1px solid black;" scope="col">DBMS</th>
										<th style="border:1px solid black;" scope="col">TOOL</th>
										<th style="border:1px solid black;" scope="col">통신</th>
										<th style="border:1px solid black;" scope="col">기타</th>
					                </tr>
							</thead>
							<tbody>
									<c:if test="${fn:length(skillInfo) == 0}">
										<tr>
											<td colspan="11"><c:if test="${param.searchJobSe == '' || param.searchProgramNm == ''}">
													<spring:message code="info.nodata.msg" />
												</c:if> <c:if test="${param.searchJobSe != '' || param.searchProgramNm != ''}">
													<spring:message code="info.noresult.msg" />
												</c:if></td>
										</tr>
									</c:if>
									<c:forEach items="${skillInfo}" var="skillInfo" varStatus="status">
										<tr>
											<td>${skillInfo.PRJ_NAME}</td> 
											<td>${skillInfo.CUS_COMP}</td>
											<td>${skillInfo.WORK_COMP}</td>
											<td>${skillInfo.START_DATE}~${skillInfo.END_DATE}</td>
											<td>${skillInfo.ROLE}</td>
											<td>${skillInfo.OS}</td> 
											<td>${skillInfo.TECH}</td>
											<td>${skillInfo.LANGUAGE}</td>
											<td>${skillInfo.DBMS}</td>
											<td>${skillInfo.TOOL}</td>
											<td>${skillInfo.COMMUNICATION}</td>
											<td>${skillInfo.ETC}</td>
										</tr>
									</c:forEach>
								</tbody>
						</table>
					</div>
				</div>
			</div>
			<!--content//-->
		</div>
	</form>
</body>
</html>