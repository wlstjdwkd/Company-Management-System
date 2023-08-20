<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,cookie,form,jqGrid,timer,tools,selectbox,ui,validate,colorboxAdmin" />
<ap:jsTag type="tech" items="util,acm,ps" />
<script type="text/javascript">

$(document).ready(function(){
	gnb_menu();
	lnb();
	tbl_faq();
	
	var form = document.dataForm;
	var lastYear= Util.date.getLocalYear()-1;
	
	//setSelectBoxYear('sel_target_year',lastYear, null, '${param.sel_target_year}');
	//setSelectBoxYear('from_sel_target_year',lastYear, null, '${param.from_sel_target_year}');
	//setSelectBoxYear('to_sel_target_year',lastYear, null, '${param.to_sel_target_year}');
	
	//엑셀 다운로드
	$("#excelDown").click(function(){
		var searchCondition = jQuery("#searchCondition").val();
		var sel_target_year = jQuery("#sel_target_year").val();
		
		//form.limitUse.value = "Y";
    	jsFiledownload("/PGPS0060.do","df_method_nm=excelRsolver&searchCondition="+searchCondition+"&sel_target_year="+sel_target_year);
    });
});

/*
* 목록 검색
*/
//일반기업 성장현황 > 현황 검색
function search_list() {
	$("#df_method_nm").val("");
	$("#dataForm").submit();
}

//차트 popup
var implementInsertForm = function() {
	var searchCondition = jQuery("#searchCondition").val();
	var sel_target_year = jQuery("#sel_target_year").val();
    
	$.colorbox({
        title : "일반기업성장현황 현황 차트",
        href : "PGPS0060.do?df_method_nm=getGridSttusChart&searchCondition="+searchCondition+"&sel_target_year="+sel_target_year,
        width : "80%",
        height : "100%",
        iframe : true,
        overlayClose : false,
        escKey : false
    });
};

//출력 popup
var output = function() {
	var searchCondition = jQuery("#searchCondition").val();
	var sel_target_year = jQuery("#sel_target_year").val();
    
	$.colorbox({
        title : "일반기업성장현황 현황 출력",
        href : "PGPS0060.do?df_method_nm=outputIdx&searchCondition="+searchCondition+"&sel_target_year="+sel_target_year,
        width : "80%",
        height : "100%",
        iframe : true,
        overlayClose : false,
        escKey : false
    });
};

function idx_detail_view(pcode) {
	var form = document.dataForm;
	if(pcode == "0060"){
		form.df_method_nm.value = "";
	}else if(pcode == "0060_2"){
		form.df_method_nm.value = "goIdxList2";
	}
	
	form.submit();
}
</script>
</head>

<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />
<ap:include page="param/pagingParam.jsp" />
<input name="limitUse" type="hidden" value="">

<!--//content-->
<div id="wrap">
    <div class="wrap_inn">
        <div class="contents">
            <!--// 타이틀 영역 -->
            <h2 class="menu_title">일반기업 성장현황</h2>
            <!-- 타이틀 영역 //-->
            <!--// tab -->
            <div class="tabwrap">
                <div class="tab">
                    <ul id="gnb">
                        <li class="on" onclick="idx_detail_view('0060');"><a href="#">현황</a></li><li onclick="idx_detail_view('0060_2');"><a href="#">추이</a></li>
                    </ul>
                </div>
				<div class="tabcon" style="display: block;">
				    <!--// 조회 조건 -->
				    <div class="search_top">
				        <table cellpadding="0" cellspacing="0" class="table_search" summary="기업군 년도 조회 조건" >
				            <caption>
				            조회 조건
				            </caption>
				            <colgroup>
				            <col width="10%" />
				            <col width="40%" />
				            <col width="10%" />
				            <col width="40%" />
				            </colgroup>
				            <tr>
				                <th scope="row">기업군</th>
				                <td>
				                	<select id="searchCondition" name="searchCondition" title="검색조건선택" id="" style="width:110px">
				                        <option selected="selected" value="EA2">일반기업</option>
				                    </select>
				                </td>
				                <th scope="row">년도</th>
				                <td>
                               		<select id="sel_target_year" name="sel_target_year" style="width:100px; ">
	                                	<c:if test="${fn:length(stdyyList) == 0 }"><option value="">자료없음</option></c:if>
	                                	<c:forEach items="${stdyyList }" var="year" varStatus="status">
	                                        <option value="${year.stdyy }"<c:if test="${year.stdyy eq param.sel_target_year or (param.sel_target_year eq '' and status.index eq 0) }"> selected="selected"</c:if>>${year.stdyy }년</option>
	                                	</c:forEach>
                               		</select>
				                    <p class="btn_src_zone"><a href="#" class="btn_search" onclick="search_list()">조회</a></p>
				                </td>
				            </tr>
				        </table>
				    </div>
                        <!-- // 리스트영역-->
				    <div class="block">
				        <div class="btn_page_middle"> 
				        <span class="mgr20">(단위: 개,%) </span> 
				        <a class="btn_page_admin" href="#" onclick="implementInsertForm();"><span>챠트</span></a>
                        <a class="btn_page_admin" href="#"><span id="excelDown">엑셀다운로드</span></a> 
                        <a class="btn_page_admin" href="#" onclick="output();"><span>출력</span></a>
				     	</div>
                            
                            <div class="list_zone">
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
		                                    <th scope="col">구분</th>		                                    
		                                    <th scope="col">상호출자</th>
		                                    <th scope="col">중견</th>
		                                    <th scope="col">관계</th>
		                                    <th scope="col">후보기업</th>
		                                    <th scope="col">중소</th>
		                                    <th scope="col">전체</th>		                                                                       
		                                </tr>
		                            </thead>
		                            <tbody>
		                            	<c:forEach items="${entprsList}" var="entprs" varStatus="status" begin="0">
		                            	<tr>
		                            		<td>${entprs.GUBUN }</td>
		                            		<td class='tar'>${entprs.B_ENT }</td>
		                            		<td class='tar'>${entprs.H_ENT }</td>
		                            		<td class='tar'>${entprs.R_ENT }</td>
		                            		<td class='tar'>${entprs.C_ENT }</td>
		                            		<td class='tar'>${entprs.S_ENT }</td>
		                            		<td class='tar'>${entprs.SUM_ENT }</td>
										</tr>
										</c:forEach>                                 
		                            </tbody>
		                        </table>
			            	</div>
                        </div>
                    <!--리스트영역 //-->
				</div>
            </div>
            <!--tab //-->
        </div>
    </div>
</div>
<!--content//-->
</form>
</body>
</html>