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
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,selectbox,mask,jqGrid,css"/>
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
		
		// Rowspan 처리
		tableRowSpanning();
		
		// Excel 다운로드
		$("#excelDown").click(function(){
			
        	jsFiledownload("/PGIM0080.do","df_method_nm=excelRsolver&ad_reqst_se=" + $("#ad_reqst_se").val() + "&ad_jdgmnt_reqst_year_from_search=" + $("#ad_jdgmnt_reqst_year_from_search").val() + "&ad_jdgmnt_reqst_year_to_search=" + $("#ad_jdgmnt_reqst_year_to_search").val());
        });
		
	});
	
	// Rowspan 처리함수
	function tableRowSpanning() {
        var RowspanTd = "";
        var RowspanText = "";
        var RowspanCount = 0;

        $('tr').each(function () {
            var This = $('td', this)[0];
            var text = $(This).text();

            if (RowspanTd == "") {
                RowspanTd = This;
                RowspanText = text;
                RowspanCount = 1;
            }
            else if (RowspanText != text) {
                $(RowspanTd).attr('rowSpan', RowspanCount);

                RowspanTd = This;
                RowspanText = text;
                RowspanCount = 1;
            }
            else {
                $(This).remove();
                RowspanCount++;
            }
        });
        // 반복 종료 후 마지막 rowspan 적용
        $(RowspanTd).attr('rowSpan', RowspanCount);
    }
</script>
</head>
<body>
<div id="wrap">
	<div class="wrap_inn">
		<div class="contents">
			<!-- 타이틀 영역 -->
			<h2 class="menu_title">엑셀다운로드</h2>
			
			<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}'/>" method="post">
				<ap:include page="param/defaultParam.jsp"/>
				<ap:include page="param/dispParam.jsp"/>
				<ap:include page="param/pagingParam.jsp"/>
				<input type="hidden" id="ad_reqst_se" name="ad_reqst_se" value="${inparam.REQST_SE}"/>
				<input type="hidden" id="ad_jdgmnt_reqst_year_from_search" name="ad_jdgmnt_reqst_year_from_search" value="${inparam.ad_REQST_YEAR_FROM_SEARCH}"/>
				<input type="hidden" id="ad_jdgmnt_reqst_year_to_search" name="ad_jdgmnt_reqst_year_to_search" value="${inparam.ad_REQST_YEAR_TO_SEARCH}"/>
				
				<div class="block">
					<h3>월별 신청기준 집계 추진 현황
						<div class="btn_pag fr"> <a class="btn_page_admin" href="#none" id="excelDown"><span>엑셀 다운로드</span></a></div>
						<p class="unit">(단위 : 개)</p>
					</h3>
					<!--// 리스트 -->
					<div class="list_zone">
						<table id="dataTable" cellspacing="0" border="0" summary="목록">
							<caption>리스트</caption>
							<colgroup>
								<col width="*"/>
								<col width="*"/>
								<col width="*"/>
								<col width="*"/>
								<col width="*"/>
								<col width="*"/>
								<col width="*"/>
								<col width="*"/>
								<col width="*"/>
								<col width="*"/>
								<col width="*"/>
								<col width="*"/>
							</colgroup>
							<thead>
								<tr>
									<th colspan="2" rowspan="2" scope="col">구분</th>
									<th colspan="10" scope="col">신청 월 기준</th>
								</tr>
								<tr>
									<th class="line_l" scope="col">신청</th>
									<th scope="col">접수</th>
									<th scope="col">검토중</th>
									<th scope="col">보완요청</th>
									<th scope="col">보완접수</th>
									<th scope="col">보완검토중</th>
									<th scope="col">발급</th>
									<th scope="col">반려</th>
									<th scope="col">접수취소</th>
									<th scope="col">발급취소</th>
								</tr>
							</thead>
							<tbody>
								<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
								<c:if test="${fn:length(applicationTotal) == 0}">
									<tr>
										<td colspan="8"><spring:message code="info.nodata.msg"/></td>
									</tr>
								</c:if>
								<%-- 데이터를 화면에 출력해준다 --%>
								<c:forEach items="${applicationTotal}" var="applicationTotal" varStatus="status">
									<c:if test="${applicationTotal.MM != '소계'}">
										<tr>
											<td>’${applicationTotal.year}년</td>
											<td class="tac line_l">${applicationTotal.MM}</td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS0}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS1}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS2}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS3}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS4}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS5}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.RC1}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.RC2}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.RC3}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.RC4}" pattern = "#,##0"/></td>
										</tr>
									</c:if>
									<c:if test="${applicationTotal.MM == '소계'}">
										<tr class="sum">
											<c:if test="${applicationTotal.YYYY == '소계'}">
												<td colspan="2">총계</td>
											</c:if>
											<c:if test="${applicationTotal.YYYY != '소계'}">
												<td>’${applicationTotal.year}년</td>
												<td class="line_l">${applicationTotal.MM}</td>
											</c:if>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS0}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS1}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS2}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS3}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS4}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.PS5}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.RC1}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.RC2}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.RC3}" pattern = "#,##0"/></td>
											<td class="tar"><fmt:formatNumber value = "${applicationTotal.RC4}" pattern = "#,##0"/></td>
										</tr>
									</c:if>
								</c:forEach>
							</tbody>
						</table>
					</div>
					<!-- 리스트// -->
					<p class="mgt10">* 보완요청 : 기업에 증빙서류 보완 요청된 경우</p>
				</div>
			</form>
			<div class="tabwrap" style="margin:70px;">
				<div class="tab">
					<ul class="tabs">
                        <li class="on" data_tab="tab_1">jsp</li>
                        <li data_tab="tab_2">js</li>
                        <li data_tab="tab_3">java</li>
                    </ul>
                   	<div id="tab_1" class="tab_content on">
                   	<c:set var="string1" value='
                   	
<body>
<div id="wrap">
    <div class="wrap_inn">
        <div class="contents">
            <!-- 타이틀 영역 -->
            <h2 class="menu_title">엑셀다운로드</h2>
            
            <form name="dataForm" id="dataForm" action="<c:url value="${svcUrl}"/>" method="post">
            
                <input type="hidden" id="ad_reqst_se" name="ad_reqst_se" value="${inparam.REQST_SE}"/>
                <input type="hidden" id="ad_jdgmnt_reqst_year_from_search" name="ad_jdgmnt_reqst_year_from_search" value="${inparam.ad_REQST_YEAR_FROM_SEARCH}"/>
                <input type="hidden" id="ad_jdgmnt_reqst_year_to_search" name="ad_jdgmnt_reqst_year_to_search" value="${inparam.ad_REQST_YEAR_TO_SEARCH}"/>
                
                <div class="block">
                    <h3>월별 신청기준 집계 추진 현황
                        <div class="btn_pag fr"> <a class="btn_page_admin" href="#none" id="excelDown"><span>엑셀 다운로드</span></a></div>
                        <p class="unit">(단위 : 개)</p>
                    </h3>
                    <!--// 리스트 -->
                    <div class="list_zone">
                        <table id="dataTable" cellspacing="0" border="0" summary="목록">
                            <caption>리스트</caption>
                            <colgroup>
                                <col width="*"/>
                                <col width="*"/>
                                <col width="*"/>
                                <col width="*"/>
                                <col width="*"/>
                                <col width="*"/>
                                <col width="*"/>
                                <col width="*"/>
                                <col width="*"/>
                                <col width="*"/>
                                <col width="*"/>
                                <col width="*"/>
                            </colgroup>
                            <thead>
                                <tr>
                                    <th colspan="2" rowspan="2" scope="col">구분</th>
                                    <th colspan="10" scope="col">신청 월 기준</th>
                                </tr>
                                <tr>
                                    <th class="line_l" scope="col">신청</th>
                                    <th scope="col">접수</th>
                                    <th scope="col">검토중</th>
                                    <th scope="col">보완요청</th>
                                    <th scope="col">보완접수</th>
                                    <th scope="col">보완검토중</th>
                                    <th scope="col">발급</th>
                                    <th scope="col">반려</th>
                                    <th scope="col">접수취소</th>
                                    <th scope="col">발급취소</th>
                                </tr>
                            </thead>
	                    </table>
	                </div>
	                <!-- 리스트// -->
	                <p class="mgt10">* 보완요청 : 기업에 증빙서류 보완 요청된 경우</p>
	            </div>
	        </form>
	    </div>
	</div>
</div>
</body>
                   	'/>
                   	<pre>${fn:escapeXml(string1)}</pre>
                   	</div>
                   	<div id="tab_2" class="tab_content">
                   	<c:set var="string2" value='
                   	
<script type="text/javascript">
    $(document).ready(function() {
    
        // Rowspan 처리
        tableRowSpanning();
        
        // Excel 다운로드
        $("#excelDown").click(function(){
        
            jsFiledownload("/PGIM0080.do","df_method_nm=excelRsolver&ad_reqst_se=" + $("#ad_reqst_se").val()
            + "&ad_jdgmnt_reqst_year_from_search=" + $("#ad_jdgmnt_reqst_year_from_search").val()
            + "&ad_jdgmnt_reqst_year_to_search=" + $("#ad_jdgmnt_reqst_year_to_search").val());
        });
        
    });
    
    var jsFiledownload = function(url, data, method){
    
        if( url && data ){
            data = (typeof data == "string" ? data : $.param(data));
            var inputs = "";
            $.each(data.split("&"), function(){
                var pair = this.split("=");
                inputs+="<input type="hidden" name=""+ pair[0] +"" value=""+ pair[1] +"" />";
            });
            $("<form action=""+ url +"" method=""+ (method||"post") +"">"+inputs+"</form>")
                .appendTo("body").submit().remove();
        };
    };
    
</script>	
                   	'/>
                   	<pre>${fn:escapeXml(string2)}</pre>
                   	</div>
                   	<div id="tab_3" class="tab_content">
                   	<c:set var="string3" value='
                   	
public ModelAndView excelRsolver(Map<? , ?> rqstMap) throws Exception {

	HashMap param = new HashMap();
	ModelAndView mv = new ModelAndView();
	
	// 신청기준집계 조회
	List<Map> applicationTotal = pgim0080Mapper.findApplicationTotal(param);
	// 신청기준집계 년도별 카운트
	List<Integer> applicationTotalCnt = pgim0080Mapper.findApplicationTotalCnt(param);
	
	String year;
	String month;
	
	for(int i=0; i<applicationTotal.size(); i++) {
		year = (String) applicationTotal.get(i).get("YYYY");
		month = (String) applicationTotal.get(i).get("MM");
		year = year.substring(2);
		applicationTotal.get(i).put("year", year);
		
		if("소계".equals(month)) {
		} else {
			applicationTotal.get(i).put("MM", month + "월");
		}
	}
	
	mv.addObject("_list", applicationTotal);
	mv.addObject("_listCnt", applicationTotalCnt);
	
	// Header
	String header = "신청 월 기준";
	// SubHeader
	String[] subHeaders = {
			"신청",
			"접수",
			"검토중",
			"보완요청",
			"보완접수",
			"보완검토중",
			"발급",
			"반려",
			"접수취소",
			"발급취소"
	};
	//Item
	String[] items = {
			"YYYY",
			"MM",
			"PS0",
			"PS1",
			"PS2",
			"PS3",
			"PS4",
			"PS5",
			"RC1",
			"RC2",
			"RC3",
			"RC4"
	};
	
	mv.addObject("_headers", header);
	mv.addObject("_subHeaders", subHeaders);
	mv.addObject("_items", items);
	
	IExcelVO excel = new IssuExcelVO("월별추진현황(신청기준집계)");
	
	return ResponseUtil.responseExcel(mv, excel);
}
                   	
                   	'/>
                   	<pre>${fn:escapeXml(string3)}</pre>
                   	</div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>