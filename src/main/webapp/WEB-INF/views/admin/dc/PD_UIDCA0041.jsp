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
			from_year: "required",    			
			to_year: "required"
			}
			});
	
	$("#from_year").numericOptions({from:2002,to:${inparam.curr_year},sort:"desc"});
	$("#to_year").numericOptions({from:2002,to:${inparam.curr_year},sort:"desc"});
	
	$.each(crncycdValues, function(key, value) {   
	     $("#crncycd")
	         .append($("<option></option>")
	         .attr("value",key)
	         .text(value)); 
	});

	$("#from_year").val('${inparam.fromstdYy}');
	$("#to_year").val('${inparam.tostdYy}');
	$("#crncycd").val('${inparam.crncyCd}');
});

var crncycdValues ={
		'all':'선택'
			<c:choose>
			<c:when test="${fn:length(findfxercrncyCdList) > 0}">
		  	<c:forEach items="${findfxercrncyCdList}" var="info" varStatus="status">    
				,'${info.crncyCd}':'${info.crncyDesc}'
			</c:forEach>
			</c:when>
			<c:otherwise>
		   	</c:otherwise>
			</c:choose>	
		}
/*
* 목록 검색
*/
function btn_fxer_get_list() {

	var form = document.dataForm;
	
	form.df_curr_page.value = 1;
	
	
	if($("#from_year").valid() && $("#to_year").valid())
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
                                <td><select name="from_year" title="기준년도선택" id="from_year" style="width:80px">
                                    </select>
                                    ~
                                    <select name="to_year" title="기준년도선택" id="to_year" style="width:80px">
                                    </select></td>
                                <th scope="row">통화</th>
                                <td><select name="crncycd" title="통화 선택" id="crncycd" style="width:110px">
                                    </select>
                                    <p class="btn_src_zone"><a href="#" class="btn_search" onclick="btn_fxer_get_list();">조회</a></p></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="block">
                <ap:pagerParam addJsRowParam="null,'findfxerList'"/>
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
<%--                             <col width="*" /> --%>
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">기준년도</th>
                                    <th scope="col">통화명</th>
                                    <th scope="col">원환율</th>
                                    <th scope="col">원환율종가</th>
<!--                                     <th scope="col">달러환율</th> -->
                                </tr>
                            </thead>
                            <tbody>
                          <c:choose>
							   	<c:when test="${fn:length(findfxerList) > 0}">
								  	<c:forEach items="${findfxerList}" var="info" varStatus="status">    
								  	 <tr>   
								  	 	<td>${info.stdYy}</td>
								  	 	<td class="tal"><c:choose><c:when test="${info.crncyDesc eq null}">${info.crncyCd}</c:when><c:otherwise>${info.crncyDesc}(${info.crncyCd})</c:otherwise></c:choose></td>
										<td  class="tar">${info.woneHgt}</td>
<%-- 										<td  class="tar">${info.dollereHgt}</td>	 --%>
										<td  class="tar">${info.woneHgtClsrc}</td>
										</tr>
									</c:forEach>
								</c:when>
							   	<c:otherwise>
							   		<tr>
							   		<td colspan="4" style="text-align:center;">요청하신 환율정보가 없습니다.</td>
							   		</tr>
								   	</c:otherwise>
							</c:choose>							
							</tbody>
                        </table>
                    </div>
                    <!-- 리스트// -->
                    <div class="mgt10"></div>
                    <!--// paginate -->
                   	<ap:pager pager="${pager}"  addJsParam="'findfxerList'"/>
					<!-- paginate //-->
                </div>
                <!--리스트영역 //-->
            </div>
        </div>
        </form>
        <!--content//-->
</body>
</html>