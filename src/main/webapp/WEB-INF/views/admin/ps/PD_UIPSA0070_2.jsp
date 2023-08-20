<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@	taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>

<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery,colorboxAdmin,cookie,flot,form,jqGrid,notice,selectbox,timer,tools,ui,validate" />
<ap:jsTag type="tech" items="util,acm,ps" />
<script type="text/javascript">
$(document).ready(function(){
	var form = document.all;
	
	var searchCondition = '${searchCondition}';
	var sel_target_year = '${sel_target_year}';
	
	/* //그리드 리사이즈
	$(window).bind('resize', function() {
		resizeJqGridWidth(); 
	}).trigger('resize');
	
	//기업현황 그리드
	$("#grid_sttus_list3").jqGrid({        
	   	url:'PGPS0070.do?df_method_nm=getGridSttusList&sel_target_year='+sel_target_year,
		datatype: "json",
		colNames:['구분','구분', '중견', '중소', '대기업', '전체', '비고'],
		colModel:[
	   		{name:'CODE_NM',index:'CODE_NM', width:100},
	   		{name:'GUBUN',index:'GUBUN', width:100},
	   		{name:'HPE_VALUE',index:'HPE_VALUE', width:80, align:"right",sorttype:"float"},
	   		{name:'SMLPZ_VALUE',index:'SMLPZ_VALUE', width:80, align:"right",sorttype:"float", summaryType:'avg', summaryTpl:'<b>avg: {0}</b>'},
	   		{name:'LTRS_VALUE',index:'LTRS_VALUE', width:80, align:"right",sorttype:"float"},
	   		{name:'ALL_V',index:'ALL_V', width:80, align:"right",sorttype:"float"},
	   		{name:'CODE_DC',index:'CODE_DC', width:150},
	   	],
	   	rowNum:'${rowNum}',
	   	sortname: 'CODE_NM',
	    viewrecords: false,
	    sortorder: "desc",
	    loadonce: false,
		jsonReader: {
			repeatitems : false
		},
		height: '100%',
	}); */
});

//jqGrid 리사이징
/* function resizeJqGridWidth(){
	$.timer(100, function (timer) {
		var grid_id = "grid_sttus_list3";
		var div_id = "baseGridWidth";		 	
	 	$('#' + grid_id).setGridWidth($('#' + div_id).width()-10 , true);
		timer.stop();
	});
} */
</script>
</head>
<body>
<form name="dataForm" id="dataForm" method="POST">
<div id="self_dgs">
	<div class="pop_q_con">
	    <!--// 검색 조건 -->
	    <div class="search_top">
	        <table cellpadding="0" cellspacing="0" class="table_search" summary="기업위상 현황" >
	            <caption>
	            기업위상 현황
	            </caption>
	            <colgroup>
	            <col width="15%" />
	            <col width="25%" />
	            <col width="15%" />
	            <col width="25%" />
	            </colgroup>
	            <tr>
	                <th scope="row">기업군</th>
	                <td>전체기업</td>
	                <th scope="row">년도</th>
	                <td>${sel_target_year}</td>
	            </tr>
	        </table>
	    </div>
	    <!-- // 리스트영역-->
	    <div class="block">
	        
	        <div class="list_zone" id="div_data_table">
	            <table cellspacing="0" border="0" summary="기업통계" class="list" id="tblStatics">
	                <caption>
	                 리스트
	                 </caption>
	                 <colgroup>		                        	
	              	<col width="*" />
	                  <col width="*" />
	                  <col width="*" />
	                  <col width="*" />
	                  <col width="*" />
	                  <col width="*" />
	                  <col width="*" />
	                 </colgroup>
	                 <thead>		                                
	                     <tr>
	                         <th scope="col" colspan="2">구분</th>		                                    
	                         <th scope="col">중견</th>
	                         <th scope="col">중소</th>
	                         <th scope="col">대기업</th>
	                         <th scope="col">전체</th>
	                         <th scope="col">비고</th>		                                                                       
	                     </tr>
	                 </thead>
	                 <tbody>
	                 	<c:forEach items="${resultList}" var="resultInfo" varStatus="status" begin="0">
	                 	<tr>
	                   		<c:if test="${status.index%2 == 0}">
	                   		<td class='tar' rowspan="2">${resultInfo.CODE_NM }</td>
	                   		</c:if>
							<td class='tar none'>${resultInfo.GUBUN }</td>
							<td class='tar'>
								<c:choose>
								<c:when test="${fn:indexOf(resultInfo.HPE_VALUE, '%') > -1}">${resultInfo.HPE_VALUE }</c:when>
								<c:otherwise><fmt:formatNumber value="${resultInfo.HPE_VALUE }"/></c:otherwise>
								</c:choose>
							</td>
							<td class='tar'>
								<c:choose>
								<c:when test="${fn:indexOf(resultInfo.SMLPZ_VALUE, '%') > -1}">${resultInfo.SMLPZ_VALUE }</c:when>
								<c:otherwise><fmt:formatNumber value="${resultInfo.SMLPZ_VALUE }"/></c:otherwise>
								</c:choose>
							</td>
							<td class='tar'>
								<c:choose>
								<c:when test="${fn:indexOf(resultInfo.LTRS_VALUE, '%') > -1}">${resultInfo.LTRS_VALUE }</c:when>
								<c:otherwise><fmt:formatNumber value="${resultInfo.LTRS_VALUE }"/></c:otherwise>
								</c:choose>
							</td>
							<td class='tar'>
								<c:choose>
								<c:when test="${fn:indexOf(resultInfo.ALL_V, '%') > -1}">${resultInfo.ALL_V }</c:when>
								<c:otherwise><fmt:formatNumber value="${resultInfo.ALL_V }"/></c:otherwise>
								</c:choose>
							</td>
							<c:if test="${status.index%2 == 0}">
                       		<td class='tar' rowspan="2">${resultInfo.CODE_DC }</td>
                       		</c:if>																					
						</tr>
						</c:forEach>                                 
		        	</tbody>
		    	</table>
           	</div>
	        
	        <div class="btn_page_last"> 
	        	<a class="btn_page_admin" href="javascript:window.print();"><span>인쇄</span></a> 
	        	<a class="btn_page_admin" href="#" onclick="parent.$.fn.colorbox.close();"><span>닫기</span></a>
	        </div>
	        <br><br>
	    </div>
	    <!--리스트영역 //-->
	</div>
	<!--content//-->
	</div>
</div>
</form>
</body>
</html>