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
$(document).ready(function(){
	<c:if test="${resultMsg != null}">
	$(function(){
		jsMsgBox(null, "info", "${resultMsg}");
	});
	</c:if>
	
	// 로딩 화면
	$(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);	
	
  	 $("#dataForm").validate({  
			rules : {
			tarket_year: "required"    			
		}
	});
  	 
	$("#tarket_year").numericOptions({from:2011,to:${indexInfo.curr_year},sort:"desc"});
	
	$("#tarket_year").val(${indexInfo.stdYy});
	
	var hpePoint = document.getElementsByName("hpePoint");
	var smlpzPoint = document.getElementsByName("smlpzPoint");
	var ltrsPoint = document.getElementsByName("ltrsPoint");
	var sumPoint = document.getElementsByName("sumPoint");
	var hpePercent = document.getElementsByName("hpePercent");
	var smlpzPercent = document.getElementsByName("smlpzPercent");
	var ltrsPercent = document.getElementsByName("ltrsPercent");
	var smlpzEntire = document.getElementsByName("smlpzEntire");
	var ltrsEntire = document.getElementsByName("ltrsEntire");
	var entire = document.getElementsByName("entire");
	
	for(var i = 0; i < 21; i++) {
		sumPoint[i].value = Number(hpePoint[i].value) + Number(smlpzPoint[i].value) + Number(ltrsPoint[i].value);
	}
	for(var i = 0; i< 8; i++) {
		hpePercent[i].value = ((Number(hpePoint[i].value) * 100) / sumPoint[i].value).toFixed(2);
		smlpzPercent[i].value = ((Number(smlpzPoint[i].value) * 100) / sumPoint[i].value).toFixed(2);
		ltrsPercent[i].value = ((Number(ltrsPoint[i].value) * 100) / sumPoint[i].value).toFixed(2);
	}
	gravity(9,8);
	gravity(11,9);
	gravity(13,10);
	gravity(14,11);
	
	smlpzEntire[0].value = Number(smlpzPoint[18].value) + Number(smlpzPoint[19].value) + Number(smlpzPoint[20].value);
	ltrsEntire[0].value = Number(ltrsPoint[18].value) + Number(ltrsPoint[19].value) + Number(ltrsPoint[20].value);
	entire[0].value = Number(sumPoint[18].value) + Number(sumPoint[19].value) + Number(sumPoint[20].value);
	
	// 저장
	$("#btn_point_insert").click( function()  {
		jsMsgBox(
			null,
			'confirm',
			'<spring:message code="confirm.common.save" />',
			function() {
				var smlpzPoint = document
				.getElementsByName("smlpzPoint");
				var ltrsPoint = document
				.getElementsByName("ltrsPoint");
				
				for(var i = 0; i < 21; i++) {
					$('#dataForm')
					.append(
							'<input type = "hidden" name = "smlpzPoint'+ i +'" value = "'+ smlpzPoint[i].value +'"/>');
					$('#dataForm')
					.append(
							'<input type = "hidden" name = "ltrsPoint'+ i +'" value = "' + ltrsPoint[i].value +'"/>');	
				}
				$("#df_method_nm").val("insertPoint");
				$("#dataForm").submit();
			}
		)
	});
});
					
/*
 * 검색단어 입력 후 엔터 시 자동 submit
 */
function press(event) {
	if (event.keyCode == 13) {
		btn_pointdata_get_list();
	}
}

/* 
 * 목록 검색
 */
function btn_pointdata_get_list() {
	var form = document.dataForm;
	form.df_method_nm.value = "";
	form.submit();
}

/*
 *  취소(다시 입력)
 */
function btn_input_reset() {
	$("#dataForm").each(function() {
		this.reset();
	});	
}

/*
 *  비중 합계 구하기
 */
function gravity(pointNo,percentNo) {
	var hpePoint = document
	.getElementsByName("hpePoint");
	var smlpzPoint = document
		.getElementsByName("smlpzPoint");
	var ltrsPoint = document
		.getElementsByName("ltrsPoint");
	var sumPoint = document
		.getElementsByName("sumPoint");
	var hpePercent = document
		.getElementsByName("hpePercent");
	var smlpzPercent = document
		.getElementsByName("smlpzPercent");
	var ltrsPercent = document
		.getElementsByName("ltrsPercent");
	
	sumPoint[pointNo].value = Number(hpePoint[pointNo].value) + Number(smlpzPoint[pointNo].value) + Number(ltrsPoint[pointNo].value);
	
	hpePercent[percentNo].value = ((Number(hpePoint[pointNo].value) * 100) / sumPoint[pointNo].value).toFixed(2);
	smlpzPercent[percentNo].value = ((Number(smlpzPoint[pointNo].value) * 100) / sumPoint[pointNo].value).toFixed(2);
	ltrsPercent[percentNo].value = ((Number(ltrsPoint[pointNo].value) * 100) / sumPoint[pointNo].value).toFixed(2);
}

/*
 *  합계 구하기
 */
function calculate(no) {
	var hpePoint = document
	.getElementsByName("hpePoint");
	var smlpzPoint = document
		.getElementsByName("smlpzPoint");
	var ltrsPoint = document
		.getElementsByName("ltrsPoint");
	var sumPoint = document
		.getElementsByName("sumPoint");
	
	sumPoint[no].value = Number(hpePoint[no].value) + Number(smlpzPoint[no].value) + Number(ltrsPoint[no].value);
}

function corporationSum() {
	var hpePoint = document
	.getElementsByName("hpePoint");
	var smlpzPoint = document
		.getElementsByName("smlpzPoint");
	var ltrsPoint = document
		.getElementsByName("ltrsPoint");
	var sumPoint = document
		.getElementsByName("sumPoint");

	var smlpzEntire = document
	.getElementsByName("smlpzEntire");
	var ltrsEntire = document
	.getElementsByName("ltrsEntire");
	var entire = document
	.getElementsByName("entire");
		
	for(var i = 18; i < 21; i++) {
		sumPoint[i].value = Number(hpePoint[i].value) + Number(smlpzPoint[i].value) + Number(ltrsPoint[i].value);		
	}
	smlpzEntire[0].value = Number(smlpzPoint[18].value) + Number(smlpzPoint[19].value) + Number(smlpzPoint[20].value);
	ltrsEntire[0].value = Number(ltrsPoint[18].value) + Number(ltrsPoint[19].value) + Number(ltrsPoint[20].value);
	entire[0].value = Number(sumPoint[18].value) + Number(sumPoint[19].value) + Number(sumPoint[20].value);
}

</script>
</head>
<body>

	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		
		<c:forEach items="${hpePoint}" var="hpePointStat" varStatus="status">
				<c:if test = "${hpePointStat.hpe != null }">
					<input type = "hidden" name = "hpePoint" value = "${hpePointStat.hpe}" />
				</c:if>
		</c:forEach>
	
   <!-- 좌측영역 //-->
    <!--//content-->
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">기타지표데이터</h2>
                <!-- 타이틀 영역 //-->
                <div class="search_top">
                    <table cellpadding="0" cellspacing="0" class="table_search" summary="조회 조건">
                        <caption>&nbsp;
                        </caption>
                        <caption>
                        조회 조건
                        </caption>
                        <colgroup>
                        <col width="15%" />
                        <col width="*" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">년도</th>
                                <td><select name="tarket_year" title="년도선택" id="tarket_year" style="width:80px">
                                </select> 년
                                    <p class="btn_src_zone"><a href="#" class="btn_search" onclick = "btn_pointdata_get_list();">조회</a></p></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="block">
                    <!--// 리스트 -->
                    <div class="list_zone_1">
                        <table cellspacing="0" border="0" summary="수집작업목록" class="list">
                            <tbody>
                            </tbody>
                            <caption>
                            리스트
                            </caption>
                            <colgroup>
                            <col width="14%" />
                            <col width="14%" />
                            <col width="14%" />
                            <col width="14%" />
                            <col width="14%" />
                            <col width="14%" />
                            <col width="*" />
                            </colgroup>
                            <thead>
                                 <tr class="even">
                                    <th colspan="2" scope="col">구분</th>
                                    <th scope="col">중견</th>
                                    <th scope="col">중소</th>
                                    <th scope="col">대기업</th>
                                    <th scope="col">전체</th>
                                    <th scope="col">비고</th>
                                </tr>
                            </thead>
                            <tbody>
                                 <tr>
                                    <td rowspan="2">기업수</td>
                                    <td class="tal">(개)</td>
                                    <td class="tar">${hpePoint[0].hpe}</td>
                                    <td><span class="tar">
                                        <input name="smlpzPoint" type="text" id="smlpzPoint0" style="width:97%; text-align:right" title="입력"  value = "${hpePoint[0].smlpz}" onblur="gravity(0,0);"/>
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="ltrsPoint" type="text" id="ltrsPoint0" style="width:97%; text-align:right" title="입력" value = "${hpePoint[0].ltrs}" onblur="gravity(0,0);"/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                    <input name="sumPoint" type="text" id="sumPoint0" style="width:97%; text-align:right" value = "" readonly/>
                                   </span> </td>
                                    <td rowspan="2">기업생멸</td>
                                </tr>
                                 <tr>
                                    <td class="tal  none">비중(%)</td>
                                    <td class="tar"><span class="tar">
                                        <input name="hpePercent" type="text" id="hpePercent0" style="width:97%; text-align:right"  value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="smlpzPercent" type="text" id="smlpzPercent0" style="width:97%; text-align:right" value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="ltrsPercent" type="text" id="ltrsPercent0" style="width:97%; text-align:right"  value = "" readonly/>
                                        </span></td>
                                    <td class="tar">&nbsp;</td>
                                </tr>
                                <tr class="even">
                                    <td rowspan="2">기업수</td>
                                    <td class="tal">(개)</td>
                                    <td class="tar">${hpePoint[1].hpe}</td>
                                    <td><span class="tar">
                                        <input name="smlpzPoint" type="text" id="smlpzPoint1" style="width:97%; text-align:right" title="입력" value = "${hpePoint[1].smlpz}" onblur = "gravity(1,1);"/>
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="ltrsPoint" type="text" id="ltrsPoint1" style="width:97%; text-align:right" title="입력" value = "${hpePoint[1].ltrs}" onblur ="gravity(1,1);"/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                    <input name="sumPoint" type="text" id="sumPoint1" style="width:97%; text-align:right"  readonly/>
                                   </span></td>
                                    <td rowspan="2">중기청</td>
                                </tr>
                                <tr class="even">
                                    <td class="tal  none">비중(%)</td>
                                    <td class="tar"><span class="tar">
                                        <input name="hpePercent" type="text" id="hpePercent1" style="width:97%; text-align:right" value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="smlpzPercent" type="text" id="smlpzPercent1" style="width:97%; text-align:right" value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="ltrsPercent" type="text" id="ltrsPercent1" style="width:97%; text-align:right"  value = "" readonly/>
                                        </span></td>
                                    <td class="tar">&nbsp;</td>
                                </tr>
                                 <tr>
                                    <td rowspan="2">매출액</td>
                                    <td class="tal">(조원)</td>
                                    <td class="tar">${hpePoint[2].hpe}</td>
                                    <td><span class="tar">
                                        <input name="smlpzPoint" type="text" id="smlpzPoint2" style="width:97%; text-align:right" title="입력"  value = "${hpePoint[2].smlpz}" onblur="gravity(2,2);"/>
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="ltrsPoint" type="text" id="ltrsPoint2" style="width:97%; text-align:right" title="입력" value = "${hpePoint[2].ltrs}" onblur="gravity(2,2);"/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                    <input name="sumPoint" type="text" id="sumPoint2" style="width:97%; text-align:right" value = "" readonly/>
                                   </span> </td>
                                    <td rowspan="2">국세통계</td>
                                </tr>
                                <tr>
                                    <td class="tal  none">비중(%)</td>
                                    <td class="tar"><span class="tar">
                                        <input name="hpePercent" type="text" id="hpePercent2" style="width:97%; text-align:right"  value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="smlpzPercent" type="text" id="smlpzPercent2" style="width:97%; text-align:right"  value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="ltrsPercent" type="text" id="ltrsPercent2" style="width:97%; text-align:right" value = "" readonly/>
                                        </span></td>
                                    <td class="tar">&nbsp;</td>
                                </tr>
                                <tr class="even">
                                    <td rowspan="2">수출액</td>
                                    <td class="tal">&nbsp;</td>
                                    <td class="tar">${hpePoint[3].hpe}</td>
                                    <td><span class="tar">
                                        <input name="smlpzPoint" type="text" id="smlpzPoint3" style="width:97%; text-align:right" title="입력"  value = "${hpePoint[3].smlpz}" onblur="gravity(3,3);"/>
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="ltrsPoint" type="text" id="ltrsPoint3" style="width:97%; text-align:right" title="입력" value = "${hpePoint[3].ltrs}" onblur="gravity(3,3);"/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                    <input name="sumPoint" type="text" id="sumPoint3" style="width:97%; text-align:right"  value = "" readonly/>
                                   </span> </td>
                                    <td rowspan="2">관세청</td>
                                </tr>
                                <tr class="even">
                                    <td class="tal  none">비중(%)</td>
                                    <td class="tar"><span class="tar">
                                        <input name="hpePercent" type="text" id="hpePercent3" style="width:97%; text-align:right"  value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="smlpzPercent" type="text" id="smlpzPercent3" style="width:97%; text-align:right" value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="ltrsPercent" type="text" id="ltrsPercent3" style="width:97%; text-align:right"  value = "" readonly/>
                                        </span></td>
                                    <td class="tar">&nbsp;</td>
                                </tr>
                                 <tr>
                                    <td rowspan="2">고용</td>
                                    <td class="tal">&nbsp;</td>
                                    <td class="tar">${hpePoint[4].hpe}</td>
                                    <td><span class="tar">
                                        <input name="smlpzPoint" type="text" id="smlpzPoint4" style="width:97%; text-align:right" title="입력"  value = "${hpePoint[4].smlpz}" onblur="gravity(4,4);"/>
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="ltrsPoint" type="text" id="ltrsPoint4" style="width:97%; text-align:right" title="입력" value = "${hpePoint[4].ltrs}" onblur="gravity(4,4);"/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                    <input name="sumPoint" type="text" id="sumPoint4" style="width:97%; text-align:right" value = "" readonly/>
                                   </span> </td>
                                    <td rowspan="2">고용통계</td>
                                </tr>
                                <tr>
                                    <td class="tal  none">비중(%)</td>
                                    <td class="tar"><span class="tar">
                                        <input name="hpePercent" type="text" id="hpePercent4" style="width:97%; text-align:right" value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="smlpzPercent" type="text" id="smlpzPercent4" style="width:97%; text-align:right" value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="ltrsPercent" type="text" id="ltrsPercent4" style="width:97%; text-align:right" value = "" readonly/>
                                        </span></td>
                                    <td class="tar">&nbsp;</td>
                                </tr>
                                <tr class="even">
                                    <td rowspan="2">고용</td>
                                    <td class="tal">&nbsp;</td>
                                    <td class="tar">${hpePoint[5].hpe}</td>
                                    <td><span class="tar">
                                        <input name="smlpzPoint" type="text" id="smlpzPoint5" style="width:97%; text-align:right" title="입력"  value = "${hpePoint[5].smlpz}" onblur="gravity(5,5);"/>
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="ltrsPoint" type="text" id="ltrsPoint5" style="width:97%; text-align:right" title="입력" value = "${hpePoint[5].ltrs}" onblur="gravity(5,5);"/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                    <input name="sumPoint" type="text" id="sumPoint5" style="width:97%; text-align:right" value = "" readonly/>
                                   </span> </td>
                                    <td rowspan="2">사업체조사</td>
                                </tr>
                                <tr class="even">
                                    <td class="tal  none">비중(%)</td>
                                    <td class="tar"><span class="tar">
                                        <input name="hpePercent" type="text" id="hpePercent5" style="width:97%; text-align:right" value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="smlpzPercent" type="text" id="smlpzPercent5" style="width:97%; text-align:right" value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="ltrsPercent" type="text" id="ltrsPercent5" style="width:97%; text-align:right" value = "" readonly/>
                                        </span></td>
                                    <td class="tar">&nbsp;</td>
                                </tr>
                                 <tr>
                                    <td rowspan="2">부가가치</td>
                                    <td class="tal  none">(조원)</td>
                                    <td class="tar">${hpePoint[6].hpe}</td>
                                    <td><span class="tar">
                                        <input name="smlpzPoint" type="text" id="smlpzPoint6" style="width:97%; text-align:right" title="입력"  value = "${hpePoint[6].smlpz}" onblur="gravity(6,6);"/>
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="ltrsPoint" type="text" id="ltrsPoint6" style="width:97%; text-align:right" title="입력" value = "${hpePoint[6].ltrs}" onblur="gravity(6,6);"/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                    <input name="sumPoint" type="text" id="sumPoint6" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                   </span> </td>
                                    <td rowspan="2">GDP</td>
                                </tr>
                                <tr>
                                    <td class="tal  none">비중(%)</td>
                                    <td class="tar"><span class="tar">
                                        <input name="hpePercent" type="text" id="hpePercent6" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="smlpzPercent" type="text" id="smlpzPercent6" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="ltrsPercent" type="text" id="ltrsPercent6" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                        </span></td>
                                    <td class="tar">&nbsp;</td>
                                </tr>
                                <tr class="even">
                                    <td rowspan="3">인건비</td>
                                    <td class="tal  none">(조원)</td>
                                    <td class="tar">${hpePoint[7].hpe}</td>
                                    <td><span class="tar">
                                        <input name="smlpzPoint" type="text" id="smlpzPoint7" style="width:97%; text-align:right" title="입력"  value = "${hpePoint[7].smlpz}" onblur="gravity(7,7);"/>
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="ltrsPoint" type="text" id="ltrsPoint7" style="width:97%; text-align:right" title="입력" value = "${hpePoint[7].ltrs}" onblur="gravity(7,7);"/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                    <input name="sumPoint" type="text" id="sumPoint7" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                   </span> </td>
                                    <td rowspan="3">국세통계</td>
                                </tr>
                                <tr class="even">
                                    <td class="tal  none">비중(%)</td>
                                    <td class="tar"><span class="tar">
                                        <input name="hpePercent" type="text" id="hpePercent7" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="smlpzPercent" type="text" id="smlpzPercent7" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="ltrsPercent" type="text" id="ltrsPercent7" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                        </span></td>
                                    <td class="tar">&nbsp;</td>
                                </tr>
                                <tr class="even">
                                    <td class="tal  none">1인당 인건비</td>
                                    <td class="tar">${hpePoint[8].hpe}</td>
                                    <td><span class="tar">
                                        <input name="smlpzPoint" type="text" id="smlpzPoint8" style="width:97%; text-align:right" title="입력"  value = "${hpePoint[8].smlpz}" onblur="calculate(8);"/>
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="ltrsPoint" type="text" id="ltrsPoint8" style="width:97%; text-align:right" title="입력" value = "${hpePoint[8].ltrs}" onblur="calculate(8);"/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                    <input name="sumPoint" type="text" id="sumPoint8" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                   </span> </td>
                                </tr>
                                <tr>
                                    <td rowspan="2">연구개발비</td>
                                    <td class="tal  none">(억원)</td>
                                    <td class="tar">${hpePoint[9].hpe}</td>
                                    <td><span class="tar">
                                        <input name="smlpzPoint" type="text" id="smlpzPoint9" style="width:97%; text-align:right" title="입력"  value = "${hpePoint[9].smlpz}" onblur="gravity(9,8);"/>
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="ltrsPoint" type="text" id="ltrsPoint9" style="width:97%; text-align:right" title="입력" value = "${hpePoint[9].ltrs}" onblur="gravity(9,8);"/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                    <input name="sumPoint" type="text" id="sumPoint9" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                   </span> </td>
                                    <td rowspan="3">연구개발 활동조사 <br>(전체)</td>
                                </tr>
                                <tr>
                                    <td class="tal  none">비중(%)</td>
                                    <td class="tar"><span class="tar">
                                        <input name="hpePercent" type="text" id="hpePercent8" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="smlpzPercent" type="text" id="smlpzPercent8" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="ltrsPercent" type="text" id="ltrsPercent8" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                        </span></td>
                                    <td class="tar">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td rowspan="1">R&D집약도</td>
                                    <td class="tal  none">비중(%)</td>
                                    <td class="tar">${hpePoint[10].hpe}</td>
                                    <td><span class="tar">
                                        <input name="smlpzPoint" type="text" id="smlpzPoint10" style="width:97%; text-align:right" title="입력"  value = "${hpePoint[10].smlpz}" onblur="calculate(10);"/>
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="ltrsPoint" type="text" id="ltrsPoint10" style="width:97%; text-align:right" title="입력" value = "${hpePoint[10].ltrs}" onblur="calculate(10);"/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                    <input name="sumPoint" type="text" id="sumPoint10" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                   </span> </td>
                                </tr>
                                <tr class="even">
                                    <td rowspan="2">연구개발비</td>
                                    <td class="tal  none">(억원)</td>
                                    <td class="tar">${hpePoint[11].hpe}</td>
                                    <td><span class="tar">
                                        <input name="smlpzPoint" type="text" id="smlpzPoint11" style="width:97%; text-align:right" title="입력"  value = "${hpePoint[11].smlpz}" onblur="gravity(11,9);"/>
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="ltrsPoint" type="text" id="ltrsPoint11" style="width:97%; text-align:right" title="입력" value = "${hpePoint[11].ltrs}" onblur="gravity(11,9);"/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                    <input name="sumPoint" type="text" id="sumPoint11" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                   </span> </td>
                                    <td rowspan="3">연구개발 활동조사 <br>(only 기업체)</td>
                                </tr>
                                <tr class="even">
                                    <td class="tal  none">비중(%)</td>
                                    <td class="tar"><span class="tar">
                                        <input name="hpePercent" type="text" id="hpePercent9" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="smlpzPercent" type="text" id="smlpzPercent9" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="ltrsPercent" type="text" id="ltrsPercent9" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                        </span></td>
                                    <td class="tar">&nbsp;</td>
                                </tr>
                                <tr class="even">
                                    <td rowspan="1">R&D집약도</td>
                                    <td class="tal  none">비중(%)</td>
                                    <td class="tar">${hpePoint[12].hpe}</td>
                                    <td><span class="tar">
                                        <input name="smlpzPoint" type="text" id="smlpzPoint12" style="width:97%; text-align:right" title="입력"  value = "${hpePoint[12].smlpz}" onblur="calculate(12);"/>
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="ltrsPoint" type="text" id="ltrsPoint12" style="width:97%; text-align:right" title="입력" value = "${hpePoint[12].ltrs}" onblur="calculate(12);"/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                    <input name="sumPoint" type="text" id="sumPoint12" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                   </span> </td>
                                </tr>
                                
                                <tr>
                                    <td rowspan="2">법인세</td>
                                    <td class="tal  none">(조원)</td>
                                    <td class="tar">${hpePoint[13].hpe}</td>
                                    <td><span class="tar">
                                        <input name="smlpzPoint" type="text" id="smlpzPoint13" style="width:97%; text-align:right" title="입력"  value = "${hpePoint[13].smlpz}" onblur="gravity(13,10);"/>
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="ltrsPoint" type="text" id="ltrsPoint13" style="width:97%; text-align:right" title="입력" value = "${hpePoint[13].ltrs}" onblur="gravity(13,10);"/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                    <input name="sumPoint" type="text" id="sumPoint13" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                   </span> </td>
                                    <td rowspan="2">국세통계</td>
                                </tr>
                                <tr>
                                    <td class="tal  none">비중(%)</td>
                                    <td class="tar"><span class="tar">
                                        <input name="hpePercent" type="text" id="hpePercent10" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="smlpzPercent" type="text" id="smlpzPercent10" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="ltrsPercent" type="text" id="ltrsPercent10" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                        </span></td>
                                    <td class="tar">&nbsp;</td>
                                </tr>
                                <tr class="even">
                                    <td rowspan="2">기부금</td>
                                    <td class="tal  none">(조원)</td>
                                    <td class="tar">${hpePoint[14].hpe}</td>
                                    <td><span class="tar">
                                        <input name="smlpzPoint" type="text" id="smlpzPoint14" style="width:97%; text-align:right" title="입력"  value = "${hpePoint[14].smlpz}" onblur="gravity(14,11);"/>
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="ltrsPoint" type="text" id="ltrsPoint14" style="width:97%; text-align:right" title="입력" value = "${hpePoint[14].ltrs}" onblur="gravity(14,11);"/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                    <input name="sumPoint" type="text" id="sumPoint14" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                   </span> </td>
                                    <td rowspan="2">국세통계</td>
                                </tr>
                                <tr class="even">
                                    <td class="tal  none">비중(%)</td>
                                    <td class="tar"><span class="tar">
                                        <input name="hpePercent" type="text" id="hpePercent11" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="smlpzPercent" type="text" id="smlpzPercent11" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                        <input name="ltrsPercent" type="text" id="ltrsPercent11" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                        </span></td>
                                    <td class="tar">&nbsp;</td>
                                </tr>
                                
                                <tr>
                                    <td rowspan="1">R&D비중</td>
                                    <td class="tal  none">(조원)</td>
                                    <td class="tar">${hpePoint[15].hpe}</td>
                                    <td><span class="tar">
                                        <input name="smlpzPoint" type="text" id="smlpzPoint15" style="width:97%; text-align:right" title="입력"  value = "${hpePoint[15].smlpz}" onblur="calculate(15);"/>
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="ltrsPoint" type="text" id="ltrsPoint15" style="width:97%; text-align:right" title="입력" value = "${hpePoint[15].ltrs}" onblur="calculate(15);"/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                    <input name="sumPoint" type="text" id="sumPoint15" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                   </span> </td>
                                    <td rowspan="1">한국은행</td>
                                </tr>
                                <tr class="even">
                                    <td rowspan="1">매출액증가율</td>
                                    <td class="tal  none">(조원)</td>
                                    <td class="tar">${hpePoint[16].hpe}</td>
                                    <td><span class="tar">
                                        <input name="smlpzPoint" type="text" id="smlpzPoint16" style="width:97%; text-align:right" title="입력"  value = "${hpePoint[16].smlpz}" onblur="calculate(16);"/>
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="ltrsPoint" type="text" id="ltrsPoint16" style="width:97%; text-align:right" title="입력" value = "${hpePoint[16].ltrs}" onblur="calculate(16);"/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                    <input name="sumPoint" type="text" id="sumPoint16" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                   </span> </td>
                                    <td rowspan="1">한국은행</td>
                                </tr>
                                
                                <tr>
                                    <td rowspan="1">사내보유율</td>
                                    <td class="tal  none">(조원)</td>
                                    <td class="tar">${hpePoint[17].hpe}</td>
                                    <td><span class="tar">
                                        <input name="smlpzPoint" type="text" id="smlpzPoint17" style="width:97%; text-align:right" title="입력"  value = "${hpePoint[17].smlpz}" onblur="calculate(17);"/>
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="ltrsPoint" type="text" id="ltrsPoint17" style="width:97%; text-align:right" title="입력" value = "${hpePoint[17].ltrs}" onblur="calculate(17);"/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                    <input name="sumPoint" type="text" id="sumPoint17" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                   </span> </td>
                                    <td rowspan="1">한국은행</td>
                                </tr>
                                 <tr class="even">
                                    <td rowspan="4">상장기업수</td>
                                    <td class="tal  none">전체</td>
                                    <td class="tar">${hpePoint[18].hpe + hpePoint[19].hpe + hpePoint[20].hpe} </td>
                                    <td><span class="tar">
                                        <input name="smlpzEntire" type="text" id="smlpzEntire" style="width:97%; text-align:right" title="입력"  value = "" readonly />
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="ltrsEntire" type="text" id="ltrsEntire" style="width:97%; text-align:right" title="입력"  value = "" readonly/>
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="entire" type="text" id="entire" style="width:97%; text-align:right" title="입력"  value = "" readonly/>
                                    </span></td>
                                    <td rowspan="4">한국거래소</td>
                                </tr>
                                <tr class="even">
                                    <td class="tal  none">코스피</td>
                                    <td class="tar">${hpePoint[18].hpe}</td>
                                    <td><span class="tar">
                                        <input name="smlpzPoint" type="text" id="smlpzPoint18" style="width:97%; text-align:right" title="입력"  value = "${hpePoint[18].smlpz}" onblur="corporationSum();"/>
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="ltrsPoint" type="text" id="ltrsPoint18" style="width:97%; text-align:right" title="입력" value = "${hpePoint[18].ltrs}" onblur="corporationSum();"/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                    <input name="sumPoint" type="text" id="sumPoint18" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                   </span> 
                                </tr>
                                <tr class="even">
                                    <td class="tal  none">코스닥</td>
                                    <td class="tar">${hpePoint[19].hpe}</td>
                                    <td><span class="tar">
                                        <input name="smlpzPoint" type="text" id="smlpzPoint19" style="width:97%; text-align:right" title="입력"  value = "${hpePoint[19].smlpz}" onblur="corporationSum();"/>
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="ltrsPoint" type="text" id="ltrsPoint19" style="width:97%; text-align:right" title="입력" value = "${hpePoint[19].ltrs}" onblur="corporationSum();"/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                    <input name="sumPoint" type="text" id="sumPoint19" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                   </span> 
                                </tr>
                                <tr class="even">
                                    <td class="tal  none">코네스</td>
                                    <td class="tar">${hpePoint[20].hpe}</td>
                                    <td><span class="tar">
                                        <input name="smlpzPoint" type="text" id="smlpzPoint20" style="width:97%; text-align:right" title="입력"  value = "${hpePoint[20].smlpz}" onblur="corporationSum();"/>
                                        </span></td>
                                    <td><span class="tar">
                                        <input name="ltrsPoint" type="text" id="ltrsPoint20" style="width:97%; text-align:right" title="입력" value = "${hpePoint[20].ltrs}" onblur="corporationSum();"/>
                                        </span></td>
                                    <td class="tar"><span class="tar">
                                    <input name="sumPoint" type="text" id="sumPoint20" style="width:97%; text-align:right" title="입력" value = "" readonly/>
                                   </span> 
                                </tr>
                            </tbody>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                    <!-- 리스트// -->
                    <div class="btn_page_last"><a class="btn_page_admin" href="#" id = "btn_point_insert"><span>저장</span></a> <a class="btn_page_admin" href="#" onclick = "btn_input_reset();"><span>다시입력</span></a></div>
                </div>
                <!--리스트영역 //-->
            </div>
        </div>
        <!--content//-->
        </div>
        
</form>
</body>
</html>