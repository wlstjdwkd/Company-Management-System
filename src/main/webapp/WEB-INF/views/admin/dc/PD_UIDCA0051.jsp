<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>주가정보관리|정보</title>	
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask,selectbox" />
<ap:jsTag type="tech" items="acm,msg,util" />
<script type="text/javascript">
<c:if test="${resultMsg != null}">
	$(function(){
		jsMsgBox(null, "info", "${resultMsg}");
	});
</c:if>

$(document).ready(function(){
	
  	 $("#dataForm").validate({  
			rules : {
			search_year: "required",    			
			search_month: "required"
			}
			});
	
	$("#search_year").numericOptions({from:2002,to:${inparam.curr_year},sort:"desc"});
	$("#search_month").numericOptions({from:1,to:12,namePadding:2,valuePadding:2,sort:"desc"});
	
	$("#search_year").val('${inparam.stdYy}');
	$("#search_month").val('${inparam.selMt}');
});

/*
* 목록 검색
*/
function btn_stockpc_get_list() {

	var form = document.dataForm;
	
	form.df_curr_page.value = 1;
	
	
	if($("#search_year").valid() && $("#search_month").valid())
			form.submit();
}


/*
* 검색단어 입력 후 엔터 시 자동 submit
*/
function press(event) {
	if (event.keyCode == 13) {
		event.preventDefault();
		btn_stockpc_get_list();
	}
}

</script>
</head>
<body>

	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />
		
		
				<!-- LNB 출력 방지 -->
		<input type="hidden" id="no_lnb" value="true" />
    <!-- 좌측영역 //-->
    <!--//content-->
 <div id="self_dgs">
	<div class="pop_q_con">
	
                <div class="search_top">
                    <table cellpadding="0" cellspacing="0" class="table_search" summary="조회 조건">
                        <caption>
                        조회 조건
                        </caption>
                        <colgroup>
                        <col width="15%" />
                        <col width="*" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">기준년도</th>
                                <td><select name="search_year" title="기준년도선택" id="search_year" style="width:80px">
                                    </select>
                                    년 
                                    <select name="search_month" title="기준월선택" id="search_month" style="width:80px">
                                    </select> 월</td>
                                <th scope="row">기업명</th>
                                <td><input type="text" name="searchKeyword" title="기업명입력" id="searchKeyword" style="width:250px"  placeholder="기업명을 입력하세요."  onfocus="this.placeholder=''; return true"
                           			<c:if test="${inparam.searchKeyword != '' || inparam.searchKeyword ne null}">value="${inparam.searchKeyword}"</c:if> onkeypress="press(event);"  />
                                    <p class="btn_src_zone"><a href="#" class="btn_search" onclick="btn_stockpc_get_list();">조회</a></p></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="block">
                <ap:pagerParam addJsRowParam="null,'findStockList'"/>
                    <!--// 리스트 -->
                    <div class="list_zone">
                        <table cellspacing="0" border="0" summary="목록">
                            <caption>
                            리스트
                            </caption>
                            <colgroup>
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">기준일자</th>
                                    <th scope="col">상장종목코드</th>
                                    <th scope="col">기업명</th>
                                    <th scope="col">주가</th>
                                </tr>
                            </thead>
                            <tbody>
                          <c:choose>
							   	<c:when test="${fn:length(findStkpcList) > 0}">
								  	<c:forEach items="${findStkpcList}" var="info" varStatus="status">    
								  	 <tr>   
								  	 	<td>${info.stdYy}-${info.stdMt}</td>
								  	 	<td class="tac">${info.stkCd}</td>
										<td class="tal">${info.entNm}</td>
										<td class="tar">${info.stkPc}</td>	
										</tr>
									</c:forEach>
								</c:when>
							   	<c:otherwise>
							   		<tr>
							   		<td colspan="4" style="text-align:center;">요청하신 주가정보가 없습니다.</td>
							   		</tr>
								   	</c:otherwise>
							</c:choose>							</tbody>
                        </table>
                    </div>
                    <!-- 리스트// -->
                    <div class="mgt10"></div>
                    <!--// paginate -->
                   	<ap:pager pager="${pager}"  addJsParam="'findStockList'"/>
					<!-- paginate //-->
                </div>
                <!--리스트영역 //-->
            </div>
        </div>
        </form>
        <!--content//-->
</body>
</html>