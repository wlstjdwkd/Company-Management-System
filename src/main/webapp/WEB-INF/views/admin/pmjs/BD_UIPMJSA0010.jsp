<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>정보</title>
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin"/>
<ap:jsTag type="tech" items="acm,msg,util"/>

<!-- 리얼그리드 라이브러리 -->
<script type="text/javascript" src="${contextPath}/script/realgrid.2.5.0/realgrid.2.5.0.min.js"></script>
<link rel="stylesheet" type="text/css" href="${contextPath}/script/realgrid.2.5.0/realgrid-style.css"/>
<script src="${contextPath}/script/realgrid.2.5.0/libs/jszip.min.js"></script>
<script src="${contextPath}/script/realgrid.2.5.0/realgrid-lic.js"></script>

<script src="/gridDef/pm/EMPinfoGrid.js"></script>

<script type="text/javascript">
//검색
function countSess(){
	EMPinfodataProvider.clearRows();
	
	$.ajax({
		type : "POST",
		url : "PGPM0010.do",
		data : { "df_method_nm" : "countSess"
			, "ad_search_word" : $("#ad_search_word").val()
			, "limitFrom" : 0 , "limitTo" : 100},
			error : function(error){
				console.log("error");
			},
			success : function(data){
				console.log("success");
				var ddd = JSON.parse(data);
				EMPinfodataProvider.fillJsonData(ddd, {fillMode: "set"});
			}
	});
}

//검색단어 입력 후 엔터 시 자동 submit
function press(event){
	if(event.keyCode==13){
		event.preventDefault();
		countSess();
	}
}

</script>
</head>
<body>
	<form name="dataForm" id="dataForm" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />
		
		<input type="hidden" name="EMP_NO" id="EMP_NO" />
		<input type="hidden" id="init_search_yn" name="init_search_yn" value="N" />
		
		<!-- //content -->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!-- //타이틀 영역  -->
					<h2 class="menu_title">직원등록조회</h2>
					<!-- 타이틀 영역 //-->
					<!-- //검색조건  -->
					<div class="search_top">
						<table cellpadding="0" cellspacing="0" class="table_search" summary="프로그램관리 검색">
							<caption>검색</caption>
							<colgroup>
								<col width="15%" />
								<col width="*" />
								<col width="*" />
							</colgroup>
							<tr>
								<th scope="row">직원검색</th>
								<td><input name="ad_search_word" id="ad_search_word"
									title="이름을 입력하세요." placeholder="이름을 입력하세요." type="text"
									style="width: 200px" value="${param.ad_search_word}" onkeypress="press(event);"/></td>
								<td>
									<p class="btn_src_zone">
										<a href="#" class="btn_search" onclick="countSess()">검색</a>
									</p>
								</td>
							</tr>
						</table>
					</div><br><br>
					<div class="block">
						<!-- //리스트 -->
						<div class="container-fluid">
							<div id="EMPinfogrid" style="height: 242px; background-color:white;"></div>
						</div>
						<br><br>
						<!-- 리스트// -->
						<div class="btn_page_last">
							<a class="btn_page_admin" href="#" onclick="btn_program_regist_view()"><span>등록</span></a>
							<a class="btn_page_admin" href="#" onclick="downloadExcel();"><span>엑셀다운로드</span></a>
						</div>
					</div>
				</div>
			</div>
		</div>
		
	</form>
</body>
</html>