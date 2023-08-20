<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업자료엑셀다운</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,multiselect" />
<ap:jsTag type="tech" items="acm,msg,util" />
<script type="text/javaScript">
$(document).ready(function(){

	
	<c:if test="${resultMsg != null}">
	$(function(){
		jsMsgBox(null, "error", "${resultMsg}", function(){
			parent.$("#btn_down").colorbox.close();
		});
	});
	</c:if>
	
	$("#dataForm").validate({
		submitHandler: function(form) {
			
			if ($("#searchFncItemVal").multipleSelect("getSelects") == "") {
				jsMsgBox(null, "error", Message.template.noSetTarget("출력될재무항목"));
				return;
			}
			
			if ($("input:radio[name='searchResn']").is(":checked") == false) {
				jsMsgBox($("#searchResnS"), "error", Message.template.required("판정사유출력"));
				return;
			}
			
			$("#searchStartYear").val($("span[id=sYear").text());
			$("#searchEndYear").val($("span[id=eYear").text());
			
			$("#df_method_nm").val("excelEntrprsData");
			form.submit();
		}
	});

    $("#searchYearCnt").change(function(){
    	var num = ${param.sel_target_year} - $("#searchYearCnt").val() ;
		$("span[id=sYear]").text(num);
    });

	// 멀티콤보박스 설정
  	$("#searchFncItemVal").multipleSelect({
  		selectAll: true,
		placeholder : "-- 선택 --",
		selectAllText : "전체선택",
    	allSelected : "전체선택",
    	minimumCountSelected: 10,
    	filter: true
  	});
  	$("#searchFncItemVal").attr("multiple", "multiple");
	$("#searchFncItemVal").html($("#searchFncItem").html());
	$("#searchFncItemVal").multipleSelect('refresh');
});

</script>
</head>
<body>
<div id="self_dgs">
	<div class="pop_q_con">
		<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}'/>" method="post">
		<input type="hidden" id="no_lnb" value="true" />
		
		<input type="hidden" id="ad_down" name="ad_down" value="Y" /><!-- 엑셀다운구분 -->

<%-- 폼입력값 모두 출력 --%>
<c:forEach var='parameter' items='${paramValues}'><c:forEach var='value' items='${parameter.value}'>
		<input type="hidden" name="<c:out value='${parameter.key}'/>" value="${value}" />
</c:forEach></c:forEach>
		
		<!-- 엑셀다운 조건 -->
		<input type="hidden" id="searchStartYear" name="searchStartYear" value="" />
		<input type="hidden" id="searchEndYear" name="searchEndYear" value="" />
		
	    <table cellpadding="0" cellspacing="0" class="table_basic" summary="검색조건">
	        <caption>
	        검색조건
	        </caption>
	        <colgroup>
	        <col width="30%" />
	        <col width="*" />
	        </colgroup>
	        <tbody>
	            <tr>
	                <th scope="row">기준사업년도</th>
	                <td>
	                	<c:out value="${param.sel_target_year }" />
	                </td>
	            </tr>
	            <tr>
	                <th scope="row">재무자료출력년수</th>
	                <td>
                    	<select id="searchYearCnt" name="searchYearCnt" title="재무자료출력년수" style="width:150px">
                            <option value="0" selected="selected">1</option>
                            <option value="1">2</option>
                            <option value="2">3</option>
                            <option value="3">4</option>
                            <option value="4">5</option>
                            <option value="5">6</option>
                            <option value="6">7</option>
                            <option value="7">8</option>
                            <option value="8">9</option>
                            <option value="9">10</option>
                        </select> 년
                        (<span id="sYear">${param.sel_target_year }</span> ~ <span id="eYear">${param.sel_target_year }</span> 재무자료)
	                </td>
	            </tr>
	            <tr>
	                <th scope="row">출력될재무항목</th>
	                <td>
	                	<select id="searchFncItemVal" name="searchFncItemVal" style="width:150px">
	                	</select>
                    	<select id="searchFncItem" name="searchFncItem" title="출력될재무항목" style="display:none; ">
                    		<!-- 재무자료 -->
                            <option value="fnnr.ORDTM_LABRR_CO">상시근로자수</option>
                            <option value="fnnr.DYNMC_ASSETS">유동자산</option>
                            <option value="fnnr.CT_DYNMC_ASSETS">비유동자산</option>
                            <option value="fnnr.ASSETS_SM">자산총계</option>
                            <option value="fnnr.DYNMC_DEBT">유동부채</option>
                            <option value="fnnr.CT_DYNMC_DEBT">비유동부채</option>
                            <option value="fnnr.DEBT">부채</option>
                            <option value="fnnr.CAPL_RESIDU_GLD">자본금잉여금</option>
                            <option value="fnnr.CAPL">자본금</option>
                            <option value="fnnr.CLPL">자본잉여금</option>
                            <option value="fnnr.PROFIT_RESIDU_GLD">이익잉여금</option>
                            <option value="fnnr.CAPL_MDAT">자본조정</option>
                            <option value="fnnr.CAPL_SM">자본총계</option>
                            <option value="fnnr.SELNG_AM">매출액</option>
                            <option value="fnnr.SELNG_TOT_PROFIT">매출총이익</option>
                            <option value="fnnr.BSN_PROFIT">영업이익</option>
                            <option value="fnnr.BSN_ELSE_PROFIT">영업외이익</option>
                            <option value="fnnr.BSN_ELSE_CT">영업외비용</option>
                            <option value="fnnr.PBDCRRX">법인세차감전순이익</option>
                            <option value="fnnr.CRRX_CT">법인세비용</option>
                            <option value="fnnr.THSTRM_NTPF">당기순이익</option>
                            <option value="fnnr.BSIS_CASH">기초현금</option>
                            <option value="fnnr.CFFO">영업활동으로인한현금흐름</option>
                            <option value="fnnr.CFFIA">투자활동으로인한현금흐름</option>
                            <option value="fnnr.CFFFA">재무활동으로인한현금흐름</option>
                            <option value="fnnr.CASH_INCRS_DCRS">현금증가감소</option>
                            <option value="fnnr.TRMEND_CASH">기말현금</option>
                            <option value="fnnr.RSRCH_DEVLOP_CT">연구개발비</option>
                            <option value="fnnr.MCHN_DEVICE_ACQS">기계장치취득</option>
                            <option value="fnnr.TOOL_ORGNZ_ACQS">공구기구취득</option>
                            <option value="fnnr.CNSTRC_ASSETS_INCRS">건설자산증가</option>
                            <option value="fnnr.EQP_INVT">설비투자</option>
                            <option value="fnnr.VAT">부가세</option>
                            <option value="fnnr.LBCST">인건비</option>
                            <option value="fnnr.CTBNY">기부금</option>
                            <option value="fnnr.WNMPY_RESRVE_RT">사내유보율</option>
                            <option value="fnnr.Y3AVG_SELNG_AM">3년평균매출액</option>
                            <!-- 특허및수출액 -->
                            <option value="ptnt.DMSTC_PATENT_REGIST_VLM">국내특허등록권</option>
                            <option value="ptnt.DMSTC_APLC_PATNTRT">국내출원특허권</option>
                            <option value="ptnt.UTLMDLRT">실용신안권</option>
                            <option value="ptnt.DSNREG">디자인등록</option>
                            <option value="ptnt.TRDMKRT">상표권</option>
                            <option value="ptnt.XPORT_AM_WON">수출액원화</option>
                            <option value="ptnt.XPORT_AM_DOLLAR">수출액달러</option>
                        </select>
	                </td>
	            </tr>
	            <tr>
	                <th scope="row">판정사유출력</th>
	                <td>
						<ul>
							<li><input type="radio" id="searchResnS" name="searchResn" value="S" checked="checked" />
									<label for="searchResnS">시스템판정</label>
							</li>
							<li><input type="radio" id="searchResnM" name="searchResn" value="S" />
									<label for="searchResnM">확정판정</label>
							</li>
						</ul>
	                </td>
	            </tr>
	            <tr>
	                <th scope="row">출자피출자기업<br>(직간접소유현황)</th>
	                <td>
	                	<ul>
	                		<li><input type="checkbox" id="searchInvst" name="searchInvst" value="Y" /></li>
	                	</ul>
	                </td>
	            </tr>
	        </tbody>
	    </table>
	    <div class="btn_page_last">
	    	<a class="btn_page_admin" href="#none" onclick="$('#dataForm').submit();"><span>엑셀다운</span></a> 
	   	</div>
	   	</form>
	</div>
</div>
</body>
</html>