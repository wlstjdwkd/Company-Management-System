<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl" %>
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

	Util.rowSpan($("#tblStatics"), [1]);

	
	gnb_menu();
	lnb();
	tbl_faq();
	tiptoggle();
	
	var form = document.dataForm;
	var lastYear= Util.date.getLocalYear()-1;
	
	// setSelectBoxYear('from_sel_target_year',lastYear, null, '${param.from_sel_target_year}');
	// setSelectBoxYear('to_sel_target_year',lastYear, null, '${param.to_sel_target_year}');
	
	
	$("#dataForm").validate({
			rules : {
				from_sel_target_year: {
					required: true
				},
				to_sel_target_year: {
					required: true
				}
			},
			submitHandler: function(form) {
				
				if ($("#from_sel_target_year").val() > $("#to_sel_target_year").val()) {
					jsMsgBox(null, "error", Message.msg.invalidDateCondition);
					return;
				}
				if ($("#from_sel_target_year").val() - $("#to_sel_target_year").val() > 10) {
					jsMsgBox(null, "error", Message.template.ableSearchTerm("10년"));
					return;
				}
				
				form.submit();
			}
		});
	
	//엑셀 다운로드
	$("#excelDown2").click(function(){
		var form = document.all;
		
		var searchCondition = jQuery("#searchCondition4").val();
		var from_sel_target_year = jQuery("#from_sel_target_year").val();
		var to_sel_target_year = jQuery("#to_sel_target_year").val();
		
    	jsFiledownload("/PGPS0060.do","df_method_nm=excelRsolverGridSttusList2&searchCondition="+searchCondition+"&from_sel_target_year="+from_sel_target_year
    			+"&to_sel_target_year="+to_sel_target_year);
    });
});
/*
* 목록 검색
*/
//일반기업 성장현황 > 추이 검색
function search_list2() {
	$("#df_method_nm").val("goIdxList2");
	$("#dataForm").submit();
}

//차트 popup
var implementInsertForm2 = function() {
	var searchCondition = jQuery("#searchCondition").val();
	var from_sel_target_year = jQuery("#from_sel_target_year").val();
	var to_sel_target_year = jQuery("#to_sel_target_year").val();
    
	$.colorbox({
        title : "일반기업성장현황 추이 차트",
        href : "PGPS0060.do?df_method_nm=getGridSttusChart2&searchCondition="+searchCondition
        		+"&from_sel_target_year="+from_sel_target_year+"&to_sel_target_year="+to_sel_target_year,
        width : "80%",
        height : "100%",
        iframe : true,
        overlayClose : false,
        escKey : false
    });
};

//출력 popup
var output2 = function() {
	var searchCondition = jQuery("#searchCondition").val();
	var from_sel_target_year = jQuery("#from_sel_target_year").val();
	var to_sel_target_year = jQuery("#to_sel_target_year").val();
    
	$.colorbox({
        title : "일반기업성장현황 추이 출력",
        href : "PGPS0060.do?df_method_nm=outputIdx2&searchCondition="+searchCondition+"&from_sel_target_year="+from_sel_target_year+"&to_sel_target_year="+to_sel_target_year,
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
                        <li onclick="idx_detail_view('0060');"><a href="#">현황</a></li><li class="on" onclick="idx_detail_view('0060_2');"><a href="#">추이</a></li>
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
				                	<select id="searchCondition" name="searchCondition2" title="검색조건선택" id="" style="width:110px">
				                        <option selected="selected" value="EA2">일반기업</option>
				                    </select>
				                </td>
				                <th scope="row">년도</th>
				                <td>
                               		<select id="from_sel_target_year" name="from_sel_target_year" style="width:100px; ">
	                                	<c:if test="${fn:length(stdyyList) == 0 }"><option value="">자료없음</option></c:if>
	                                	<c:forEach items="${stdyyList }" var="year" varStatus="status">
	                                        <option value="${year.stdyy }"<c:if test="${year.stdyy eq param.from_sel_target_year or (param.from_sel_target_year eq '' and status.index eq 0) }"> selected="selected"</c:if>>${year.stdyy }년</option>
	                                	</c:forEach>
                               		</select>
                                    ~
                                    <select id="to_sel_target_year" name="to_sel_target_year" style="width:100px; ">
	                                	<c:if test="${fn:length(stdyyList) == 0 }"><option value="">자료없음</option></c:if>
	                                	<c:forEach items="${stdyyList }" var="year" varStatus="status">
	                                        <option value="${year.stdyy }"<c:if test="${year.stdyy eq param.to_sel_target_year or (param.to_sel_target_year eq '' and status.index eq 0) }"> selected="selected"</c:if>>${year.stdyy }년</option>
	                                	</c:forEach>
                               		</select>
				                    <p class="btn_src_zone"><a href="#" class="btn_search" onclick="search_list2()">조회</a></p>
				                </td>
				            </tr>
				        </table>
				    </div>
				    <dl class="tip">
                            <dt class="tip"><a href="#"> 사용 팁</a><span class="openTip" style="display:block;"><a href="#none"><img src="/images/acm/tip_open.png" width="24" height="23" alt="열기" /></a></span><span class="closeTip" style="display:none;"><a href="#none"><img src="/images/acm/tip_close.png" width="24" height="23" alt="닫기" /></a></span></dt>
                            <dd class="tip">
                                <ul>
                                    <li class="left">
                                        <dl>
                                            <dt style="width:110px">조건/그룹선택 </dt>
                                            <dd><span class="blue">챠트 조회 시에만 적용되는 기능으로</span><br />
                                                조건일 경우 선택된 업종 또는 지역의 데이터만 조회<br />
                                                그룹일 경우 선택된 업종 또는 지역의 세부항목별로 데이터가 그룹핑되어 조회 </dd>
                                        </dl>
                                        <dl>
                                            <dt style="width:110px">업종/지역</dt>
                                            <dd>각 조회 조건의 상세항목까지 선택 후 통계 데이터 조회 </dd>
                                        </dl>
                                    </li>
                                    <li class="right">
                                        <dl>
                                            <dt style="width:60px">년도</dt>
                                            <dd>2002년 ~ 최근 통계 발표년도 </dd>
                                        </dl>
                                        <dl>
                                            <dt style="width:60px">맵챠트</dt>
                                            <dd>지역별(시도)로 주요지표현황을 출력 </dd>
                                        </dl>
                                        <dl>
                                            <dt style="width:60px">챠트</dt>
                                            <dd>업종 또는 지역 중 하나의 조건항목을 그룹( x 축 출력 ) 으로 선택으로  조회 </dd>
                                        </dl>
                                    </li>
                                </ul>
                            </dd>
                        </dl>
				    <!-- // 리스트영역-->
				    <div class="block">
				        <div class="btn_page_middle"> 
				        <span class="mgr20">(단위: 개) </span> 
				        <a class="btn_page_admin" href="#" onclick="implementInsertForm2();"><span>챠트</span></a>
                        <a class="btn_page_admin" href="#"><span id="excelDown2">엑셀다운로드</span></a> 
                        <a class="btn_page_admin" href="#" onclick="output2();"><span>출력</span></a>
				        </div>
                        <!-- // 리스트 -->
	                    <div class="list_zone">
                       <table cellspacing="0" border="0" summary="기업통계" class="list" id="tblStatics">
                           <caption>
                            리스트
                            </caption>
                            <colgroup>
                        	<c:if test="${!empty param.searchArea }">
                            <col width="*" />
                        	</c:if>
                        	<c:if test="${!empty param.searchInduty }">
                            <col width="*" />
                        	</c:if>
                            <c:forEach var="outYr" begin="${stdyySt }" end="${stdyyEd }">
                            <col width="*" />
                            </c:forEach>
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">업종</th>
                                    <th scope="col">구분</th>
                                    <c:forEach var="outYr" begin="${from_sel_target_year }" end="${to_sel_target_year }">
                                    	<th scope="col">${outYr }</th>
                                    </c:forEach>
                                </tr>
                            </thead>
                            <tbody>
							<c:forEach items="${entprsList}" var="entprs" varStatus="status">                  		
								<tr>
                                    <td id='rowspan' class='tac'>${entprs.COL1 }</td>
								    <td class='tal'>${entprs.GUBUN1 }</td>
								<c:forEach var="outYr" begin="${from_sel_target_year}" end="${to_sel_target_year}" varStatus="status">
									<c:set var="cname" value="CNT${status.count-1}N" />
									<td class='tar'><fmt:formatNumber value="${entprs[cname] }"/></td>
								</c:forEach>
								</tr>
                           	</c:forEach>
                            </tbody>
                        </table>
	                    </div>
	                    <!-- 리스트// -->
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