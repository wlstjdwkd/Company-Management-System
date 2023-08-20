<%--
  Class Name : EgovBatchSchdulRegist.jsp
  Description : 배치스케줄등록 페이지
  Modification Information

      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2010.08.23    김진만          최초 생성

    author   : 공통서비스 개발팀 김진만

--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>배치스케줄등록</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,mask,colorboxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javaScript">

$(document).ready(function(){
	
	$("#batchSchdul").validate({
		submitHandler: function(form) {
			// 필수값체크
			if ($("#batchOpertId").val() == "") {
				jsMsgBox(null, "error", Message.template.required("배치작업ID"));
				return;
			}
			if ($("#executCycle").val() == "") {
				jsMsgBox(null, "error", Message.template.required("실행주기"));
				return;
			}
			
			// 매주
			if ($("#executCycle").val() == "02" && !$("input:checkbox[name='executSchdulDfkSes']").is(":checked")) {
				jsMsgBox(null, "error", Message.template.exeCycleRequired("매주","요일"));
				return;
			}
			// 매월
		    if ($("#executCycle").val() == "03" && $("#executSchdulDay").val() == "") {
		    	jsMsgBox(null, "error", Message.template.exeCycleRequired("매월","실행스케줄일"));
		    	return;
		    }
		    // 매년
		    if ($("#executCycle").val() == "04") {
			    if ($("#executSchdulMonth").val() == "") {
			    	jsMsgBox(null, "error", Message.template.exeCycleRequired("매년","실행스케줄월"));
			    	return;
			    }
			    
			    if ($("#executSchdulDay").val() == "") {
			    	jsMsgBox(null, "error", Message.template.exeCycleRequired("매년","실행스케줄일"));
			    	return;
			    }
			    
			    // 2/29 포함 유효성 체크하기 위해 년도를 윤년으로 설정
				if (!DATE.validateDate("0004"+$("#executSchdulMonth").val()+$("#executSchdulDay").val())) {
			    	jsMsgBox(null, "error", Message.msg.exeCycleInvalidDate);
			    	return;
				}
		    }
			// 한번만
			if ($("#executCycle").val() == "05" && $("#executSchdulDeNm").val() == "") {
		    	jsMsgBox(null, "error", Message.template.exeCycleRequired("한번만","실행스케줄일자"));
		    	return;
			}
			
			jsMsgBox(null, 'confirm','<spring:message code="confirm.common.save" />', function(){
				var executSchdulDe = "";
				
				if ($("#executCycle").val() == "03") {
					executSchdulDe = '0000' + '00' + $("#executSchdulDay").val();
				} else if ($("#executCycle").val() == "04") {
					executSchdulDe = '0000' + $("#executSchdulMonth").val() + $("#executSchdulDay").val();
				} else if ($("#executCycle").val() == "05" ) {
					executSchdulDe = $("#executSchdulDeNm").cleanVal();
				}
				
				$("#executSchdulDe").val(executSchdulDe);
				$("#df_method_nm").val("insertBatchSchdul");
				form.submit();
			});
		}
	});	
	
	$("#popBatchOpert").click(function() { 
		    $.colorbox({
		        title : "배치작업선택",
		        href : "/PGMS0050.do?df_method_nm=getBatchOpertList&popupAt=Y",
		        width : "1024",
		        height : "730",
		        overlayClose : false,
		        escKey : false,
		        iframe : true
		    });
	});
	
	// 달력
	$('#executSchdulDeNm').datepicker({
        showOn : 'button',
        defaultDate : null,
        buttonImage : '<c:url value="/images/acm/icon_cal.png" />',
        buttonImageOnly : true,
        changeYear: true,
        changeMonth: true,
        yearRange: "0:+5",
        minDate:0
    });

    $('#executSchdulDeNm').mask('0000-00-00');
    
    fn_egov_init();

});

/* ********************************************************
 * 초기화
 ******************************************************** */
function fn_egov_init(){
    fn_egov_executCycleOnChange();
}

/* ********************************************************
 * 목록 으로 가기
 ******************************************************** */
function fn_egov_get_list(){
    var varForm = document.getElementById("batchSchdul");
    varForm.action = "${svcUrl}";
    varForm.df_method_nm.value = "";
    varForm.submit()
}

/* ********************************************************
 * executCycle onChange 이벤트 핸들러
 ******************************************************** */
function fn_egov_executCycleOnChange() {

    var varForm = document.getElementById("batchSchdul");
    var i = 0;
    if (varForm.executCycle.value == "01") {
        // 실행주기가 매일인 경우
        fn_egov_displayExecutSchdulSpan(false, false, false, false, true);
        fn_egov_clearExecutSchdulValue(true, true, true, true, false);

    } else if (varForm.executCycle.value == "02") {
        // 실행주기가 매주인 경우
        fn_egov_displayExecutSchdulSpan(false, false, false, true, true);
        fn_egov_clearExecutSchdulValue(true, true, true, false, false);

    } else if (varForm.executCycle.value == "03") {
        // 실행주기가 매월인 경우
        fn_egov_displayExecutSchdulSpan(false, false, true, false, true);
        fn_egov_clearExecutSchdulValue(true, true, false, true, false);

    } else if (varForm.executCycle.value == "04") {
        // 실행주기가 매년인 경우
        fn_egov_displayExecutSchdulSpan(false, true, true, false, true);
        fn_egov_clearExecutSchdulValue(true, false, false, true, false);

    } else if (varForm.executCycle.value == "05") {
        // 실행주기가 한번만인 경우
        fn_egov_displayExecutSchdulSpan(true, false, false, false, true);
        fn_egov_clearExecutSchdulValue(false, true, true, true, false);
    }
}

/* ********************************************************
 * 실행스케줄관련 SPAN Visibility 조절 함수
 ******************************************************** */
function fn_egov_displayExecutSchdulSpan(bYyyyMMdd, bMonth, bDay, bDfk, bHHmmss) {
	
  if (bYyyyMMdd) {
    spnYyyyMMdd.style.visibility ="visible";
    spnYyyyMMdd.style.display ="inline";
  } else {
    spnYyyyMMdd.style.visibility ="hidden";
    spnYyyyMMdd.style.display ="none";
  }

  if (bMonth) {
    spnMonth.style.visibility ="visible";
    spnMonth.style.display ="inline";
  } else {
    spnMonth.style.visibility ="hidden";
    spnMonth.style.display ="none";
  }

  if (bDay) {
    spnDay.style.visibility ="visible";
    spnDay.style.display ="inline";
  } else {
    spnDay.style.visibility ="hidden";
    spnDay.style.display ="none";
  }

  if (bDfk) {
    spnDfk.style.visibility ="visible";
    spnDfk.style.display ="inline";
  } else {
    spnDfk.style.visibility ="hidden";
    spnDfk.style.display ="none";
  }

  if (bHHmmss) {
    spnHHmmss.style.visibility ="visible";
    spnHHmmss.style.display ="inline";
  } else {
    spnHHmmss.style.visibility ="hidden";
    spnHHmmss.style.display ="none";
  }

}

/* ********************************************************
 * 실행스케줄관련 컴포넌트 값 clear 함수
 ******************************************************** */
function fn_egov_clearExecutSchdulValue(bYyyyMMdd, bMonth, bDay, bDfk, bHHmmss) {
	var varForm = document.getElementById("batchSchdul");
	
	if (bYyyyMMdd) {
		varForm.executSchdulDeNm.value = "";
	}

	if (bMonth) {
		varForm.executSchdulMonth[0].selected = true;
	}
	
	if (bDay) {
		varForm.executSchdulDay[0].selected = true;
	}
	
	if (bDfk) {
		// 실행스케줄 요일 값 클리어
		for (var i = 0 ; i < batchSchdul.executSchdulDfkSes.length; i++) {
			varForm.executSchdulDfkSes[i].checked = false;
		}
	}
	
	if (bHHmmss) {
		// 시분초는 클리어 할 필요가 없다.
	}
}

</script>
</head>
<body>
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title_line">배치스케줄등록</h2>
                <!-- 타이틀 영역 //-->
                <div class="block">
                    <h3 class="mgt30">
                    <span>항목은 입력 필수 항목 입니다.</span>
                    </h3>
                    <!--// 등록 -->
					<form:form commandName="batchSchdul"  action="${svcUrl}" method="post">
					<ap:include page="param/defaultParam.jsp" />
					<ap:include page="param/dispParam.jsp" />
					<ap:include page="param/pagingParam.jsp" />
					<!-- 검색조건 유지 -->
					<input type="hidden" id="searchCondition" name="searchCondition" value="<c:out value='${searchVO.searchCondition}'/>"/>
					<input type="hidden" id="searchKeyword" name="searchKeyword" value="<c:out value='${searchVO.searchKeyword}'/>"/>
					<!-- 히든 속성 -->
					<input type="hidden" id="executSchdulDe" name="executSchdulDe" value="<c:out value='${batchSchdul.executSchdulDe}'/>"/>
					
                    <table cellpadding="0" cellspacing="0" class="table_basic mgt10" summary="배치ID, 배치작업명, 스케줄 입력">
                        <caption>배치스케줄등록폼</caption>
                        <colgroup>
                        <col width="15%" />
                        <col width="*" />
                        </colgroup>
                        <tr>
                            <th scope="row" class="point"><label for="batchOpertId">배치작업ID</label></th>
                            <td><form:input path="batchOpertId" cssStyle="width:665px" maxlength="20" readonly="true" title="배치작업ID" cssClass="inp_blue"/>
                            		<div class="btn_inner"><a href="#none" class="btn_in_gray" title="배치작업찾기팝업"><span id="popBatchOpert">배치작업찾기</span></a></div>
        							<form:errors path="batchOpertId" cssClass="hiddden_txt" element="div" />
        					</td>
                        </tr>
                        <tr>
                            <th scope="row" class="point"><label for="batchOpertNm">배치작업명</label></th>
                            <td><form:input path="batchOpertNm" cssStyle="width:762px" maxlength="60" readonly="true" title="배치작업명" cssClass="inp_blue"/>
                           			<form:errors path="batchOpertNm" cssClass="hiddden_txt" element="div" />
                            </td>
                        </tr>
                       <tr>
                            <th scope="row" class="point"><label for="executCycle">실행주기</label></th>
                            <td>
								<form:select path="executCycle" onchange="fn_egov_executCycleOnChange();" title="실행주기선택" cssStyle="width:90px">
             						<form:options items="${executCycleList}" itemValue="code" itemLabel="codeNm"/>
         						</form:select>
								<form:errors path="executCycle" cssClass="hiddden_txt" element="div" />
								<span id="spnYyyyMMdd">
									<input name="executSchdulDeNm" id="executSchdulDeNm" type="text" style="width:110px" maxlength="10" title="실행스케줄일자">
								</span>
								<span id="spnMonth">
									<select name="executSchdulMonth" id="executSchdulMonth" title="실행스케줄월">
										<option value="" selected="selected" >선택</option>
										<c:forEach var="i" begin="1" end="12" step="1">
										<c:if test="${i < 10}"><option value="0${i}">0${i}</option></c:if>
										<c:if test="${i >= 10}"><option value="${i}">${i}</option></c:if>
										</c:forEach>
									</select>월
								</span>
								<span id="spnDay">
									<select name="executSchdulDay" id="executSchdulDay" title="실행스케줄일">
										<option value="" selected="selected">선택</option>
										<c:forEach var="i" begin="1" end="31" step="1">
										<c:if test="${i < 10}"><option value="0${i}">0${i}</option></c:if>
										<c:if test="${i >= 10}"><option value="${i}">${i}</option></c:if>
										</c:forEach>
									</select>일
								</span>
								<span id="spnDfk">
									<form:checkboxes path="executSchdulDfkSes" items="${executSchdulDfkSeList}" itemValue="code" itemLabel="codeNm" />
									<form:errors path="executSchdulDfkSes" cssClass="hiddden_txt" element="div" />
								</span>
								<span id="spnHHmmss">
									<form:select path="executSchdulHour" title="실행스케줄시" cssStyle="width:60px">
										<form:options items="${executSchdulHourList}" />
									</form:select>시
									<form:errors path="executSchdulHour" cssClass="hiddden_txt" element="div" />
                   
									<form:select path="executSchdulMnt" title="실행스케줄분" cssStyle="width:60px">
										<form:options items="${executSchdulMntList}" />
									</form:select>분
									<form:errors path="executSchdulMnt" cssClass="hiddden_txt" element="div" />
                    
									<form:select path="executSchdulSecnd"  title="실행스케줄초" cssStyle="width:60px">
										<form:options items="${executSchdulSecndList}" />
									</form:select>초
									<form:errors path="executSchdulSecnd" cssClass="hiddden_txt" element="div" />
								</span>
                            </td>
                        </tr>
                    </table>
                    </form:form>
                </div>
                <!-- 등록// -->
                <div class="btn_page_last">
                	<a class="btn_page_admin" href="#none" onclick='$("#batchSchdul").submit();'><span>저장</span></a>
                	<a class="btn_page_admin" href="#none" onclick="fn_egov_get_list();"><span>목록</span></a>
				</div>
            </div>
        </div>
        <!--content//-->
    </div>
</body>
</html>