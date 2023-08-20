<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn"		uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring"	uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form"	uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt"		uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ap"		uri="http://www.tech.kr/jsp/jstl"%>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>정보</title>
	<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask,blockUI" />
	<ap:jsTag type="tech" items="acm,msg,util,ms,etc" />
	
	<script type="text/javascript">
		// 엑셀 다운로드
		function btn_download_excel() {
			var form = document.dataForm;
			form.df_method_nm.value = "downloadExcel";
			form.submit();
		}
	</script>
</head>

<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
	
	<ap:include page="param/defaultParam.jsp" />
	<ap:include page="param/dispParam.jsp" />
		
	<!--//content-->
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">엑셀 다운로드 샘플</h2>
                <!-- 타이틀 영역 //-->
                
                <!-- // 리스트영역-->
                <div class="block">  
                    <!--// 리스트 -->
                    <div class="list_zone">
                    	<br> <br>
                    	<h4>식대 목록</h4>
                    	<br>
                        <table cellspacing="0" border="0" summary="식대 리스트">
                            <caption>
                            	식대 리스트
                            </caption>
                            <colgroup>
                                <col width="5%">
                                <col width="10%">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">번 호</th>
                                    <th scope="col">일 자</th>
                                    <th scope="col">내 역</th>
                                    <th scope="col">상 호</th>
                                    <th scope="col">금 액</th>
                                    <th scope="col">비 고</th>
                                </tr>
                            </thead>
                            <tbody>                                    
                                <c:forEach items="${userList}" var="userList" varStatus="status">
                                	<tr>
	                                    <td class="tac">
	                                     	<span>${userList.mealId}</span>
	                                    </td>
	                                    <td class="tal" >
	                                     	<fmt:formatDate value="${userList.date}" pattern="yyyy-MM-dd"/> </td>
	                                    <td class="tal">
	                                     	${userList.item }
	                                    </td>
										<td class="tal"> ${userList.shopName} </td>
										<td class="tar"> <fmt:formatNumber type="number" maxFractionDigits="0"
										 								value="${userList.price}"/> 원</td>
										<td class="tal">
											<c:choose>
		                                   		<c:when test="${userList.note eq 'outlay'}">지출</c:when>
		                                   		<c:otherwise> ${userList.note} </c:otherwise>
		                                   	</c:choose> 
									 	</td>
                                	</tr>
                                </c:forEach>
                            </tbody>
                        </table>
                   	</div>
                </div> 
                   	
                <!-- 리스트// -->
                <div class="btn_page_last">
                	<a class="btn_page_admin" href="#" onclick="btn_download_excel()"><span>엑셀다운로드</span></a>
				</div>
	        </div>
	        <!--리스트영역 //-->
        </div>
    	<!--content//-->
    </div>
    
	</form>
	
	<!-- loading -->
	<div style="display:none">
		<div class="loading" id="loading">
			<div class="inner">
				<div class="box">
			    	<p>
			    		<span id="load_msg">검색 중 입니다. 잠시만 기다려주십시오.</span>
			    		<br/>
						시스템 상태에 따라 최대 1분 정도 소요될 수 있습니다.
					</p>
					<span><img src="<c:url value="/images/etc/loading_bar.gif" />" width="323" height="39" alt="loading" /></span>
				</div>
			</div>
		</div>
	</div>
</body>
</html>