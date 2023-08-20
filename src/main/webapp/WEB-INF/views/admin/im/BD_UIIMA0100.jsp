<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset=UTF-8">
<title>정보</title>
<c:set var="svcUrl" value=" ${requestScope[SVC_URL_NAME]}"/>
<ap:globalConst/>
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,blockUI,msgBoxAdmin,colorboxAdmin,mask,jqGrid,css,selectbox"/>
<ap:jsTag type="tech" items="acm,msg,util"/>
<style type="text/css">
	.tab_content{
		display: none;
	}
	.tab_content.on{
		display: inherit;
	}
</style>
<script type='text/javascript'>
	$(document).ready(function() {
		
		$('ul.tabs li').click(function(){
    		$('ul.tabs li').removeClass('on');
    		$(this).addClass('on');
    		var tab_id = $(this).attr('data_tab');
    		$('.tab_content').removeClass('on');
    		$('#'+tab_id).addClass('on');
    	});
	});
	function getData() {
		//	$.blockUI({message:$("#loading")});
		var form = document.dataForm;
		
		// 상세업종 선택 구분 변경
		$("#induty_select").val("D");		
	
		form.df_curr_page.value = 1;
		form.df_method_nm.value = "";
		form.submit(); 
	}
</script>
</head>
<body>
<div id="wrap">
	<div class="wrap_inn">
		<div class="contents">
			<!-- 타이틀 영역 -->
			<h2 class="menu_title">페이징</h2>
			<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}'/>" method="post">
				<ap:include page="param/defaultParam.jsp"/>
				<ap:include page="param/dispParam.jsp"/>
				<ap:include page="param/pagingParam.jsp"/>
				
				<input type="hidden" name="induty_select" id="induty_select" />
				<input type="hidden" id="init_search_yn" name="init_search_yn" value="N" />
				
				<table cellpadding="0" cellspacing="0" class="table_search" summary="공통 검색조건으로 기업군 검색년도로 검색하는 표">
                       <colgroup>
                       <col width="15%" />
                       <col width="30%" />
                       <col width="15%" />
                       <col width="40%" />
                       </colgroup>
                       <tr>
                           <th scope="row">제목</th>
                           <td>
                           	<input type = "text" name = "searchValue" />
                           </td>
                       </tr>
                   </table>
                   <div class="btn_page_search">
                   		 <p class="btn_src_zone"><a class="btn_search" href="#none" id="btn_search_ok" onclick="getData();"><span>검색</span></a></p> 	
                   </div>
               	</form>
               	<div class="block" style="margin-top: 20px">
                   <!--// 리스트 -->
                   <div class="list_zone">
                   	<ap:pagerParam />
                       <table cellpadding="0" cellspacing="0" summary="검색어 기업형태 판정사유 별로 검색조건을 입력하는 표" >
	                        <colgroup>
		                        <col width="10%" />
		                        <col width="10%" />
		                        <col width="5%" />
		                        <col width="10%" />
		                        <col width="10%" />
		                        <col width="30%" />                        
	                        </colgroup>
                           <thead>
                               <tr>
                                   <th scope="col">설문제목</th>
                                   <th scope="col">설문목적</th>
                                   <th scope="col">설문대상</th>
                                   <th scope="col">등록일</th>
                                   <th scope="col">수정일</th>
                                   <th scope="col">안내내용</th>
                               </tr>
                           </thead>
                           <tbody>
							<c:forEach items="${resultList}" var="resultInfo" varStatus="status">
							<tr>
								<td>${resultInfo.qustnrSj}</td>
								<td>${resultInfo.qustnrPurps }</td>
								<td>${resultInfo.qustnrTrget }</td>
								<td>${resultInfo.rgsde}</td>
								<td>${resultInfo.updde}</td>
								<td>${resultInfo.qustnrWritngGuidanceCn}</td>									
							</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
                   <!-- 리스트// -->
                   <div class="mgt10"></div>
               	<ap:pager pager="${pager}" />
               </div>
			</form>
			<div class="tabwrap" style="margin:70px;">
				<div class="tab">
					<ul class="tabs">
                        <li class="on" data_tab="tab_1">JSP</li>
                        <li data_tab="tab_2">JS</li>
                        <li data_tab="tab_3">JAVA</li>
                        <li data_tab="tab_4">SQL</li>
                    </ul>
                   	<div id="tab_1" class="tab_content on">
                   	<c:set var="string1" value='
<ap:include page="param/pagingParam.jsp"/> 
//	페이징에 필요한 변수들이 있는 페이지. 
//	df_curr_page- 현재 어느 페이지 에 있는 값 (기본은 1)
//	df_row_per_page- 한 페이지에 열이 몇게 보이는 변수
<ap:pagerParam />
//	몇게씩 보는 선택 부분 
<ap:pager pager="${pager}" />
//	페이저를 호출하는 부분

                   	'/>
                   	<pre>${fn:escapeXml(string1)}</pre>
					</div>
                   	<div id="tab_2" class="tab_content">
                   	<c:set var="string2" value="
function getData() {
	var form = document.dataForm;			
	form.df_curr_page.value = 1; 		   //	검색을 할때 현재 페이지 값을 초기화 
}
                   	"/>
                   	<pre>${fn:escapeXml(string2)}</pre>
                   	</div>
                   	<div id="tab_3" class="tab_content">
                   	<c:forEach items ="${javaMessage }" var="indMess">
						${indMess }<br><br>
					</c:forEach>
                   	</div>
                   	<div id="tab_4" class="tab_content">
                   	<c:forEach items ="${sqlMessage }" var="indMess">
						${indMess }<br><br>
					</c:forEach>
                   	</div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>