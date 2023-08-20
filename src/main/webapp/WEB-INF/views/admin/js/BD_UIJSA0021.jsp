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
<title>규모기준변경</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,mask,colorboxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javaScript">

$(document).ready(function(){
	
	<c:if test="${scaleStdrList == null }">
	var data_list_cnt = 1;
	</c:if>
	<c:if test="${scaleStdrList != null }">
	var data_list_cnt = ${fn:length(scaleStdrList)};
	</c:if>
	
	// 달력
	$('#ad_applc_begin_de').datepicker({
		showOn : 'button',
		defaultDate : null,
		buttonImage : '<c:url value="/images/acm/icon_cal.png" />',
		buttonImageOnly : true,
		changeYear: true,
		changeMonth: true,
		yearRange: "2000:+1",
		dateFormat: "yymmdd",
		onSelect: function(dateText, inst) {
			$('#ad_applc_begin_de').val(DATE.str2Date(dateText).toFormatString("yyyy-MM-dd"));
			<c:if test="${lastJudgeStdrInfo != null }">$('#ad_last_applc_end_de').val(DATE.str2Date(DATE.addDate(dateText, -1)).toFormatString("yyyy-MM-dd"));</c:if>
		}
	});
	
	$('#ad_applc_begin_de').mask('0000-00-00');
	<c:if test="${lastJudgeStdrInfo != null }">$('#ad_last_applc_end_de').mask('0000-00-00');</c:if>
	
	$("#dataForm").validate({
		rules : {
			ad_dc: {
				required: true,
				maxlength: 2000
			}
		},
		submitHandler: function(form) {

			var isSubmit = true;

			if ($("#ad_applc_begin_de").val() == "") {
				jsMsgBox(null, "error", Message.template.required("신규기준적용기간(적용시작일자)"));
				return false;
			}
			
			<c:if test="${lastJudgeStdrInfo != null }">
			if ($("#ad_last_applc_end_de").val() == "") {
				jsMsgBox(null, "error", Message.template.required("최종기준적용기간(적용만료일자)"));
				return false;
			}
			
			if($("#ad_last_applc_begin_de").val() > $("#ad_last_applc_end_de").val() || $("#ad_last_applc_begin_de").val().replace(/-/gi,"") > $("#ad_last_applc_end_de").val().replace(/-/gi,"")){
		        jsMsgBox(null, "error", Message.msg.invalidDateCondition);
		        return false;
		    }
			$('#ad_last_applc_end_de').val(DATE.str2Date(DATE.addDate($('#ad_applc_begin_de').cleanVal(), -1)).toFormatString("yyyy-MM-dd"));
			</c:if>

			
			// 규모추가 필수
			if ($("input[name=ad_isnew]").length < 1) {
				jsMsgBox(null, "error", Message.template.required("규모기준"));
				return false;
			}
			
			// 업종코드 검증
			$("input[name=ad_ind_cd]").each(function() {
				if (this.value == null || this.value == "") {
					jsMsgBox(this, "error", Message.template.required("업종코드"));
					isSubmit = false;
					return false;
				}
			});
			
			if (!isSubmit) return;
			
			// 상시근로자수 유효성 검증
			$("input[name=ad_ordtm_labrr_co]").each(function() {
				if (this.value == null || this.value == "") {
					jsMsgBox(this, "error", Message.template.required("상시근로자수"));
					isSubmit = false;
					return false;
				}
				if (!$.isNumeric(this.value)) {
					jsMsgBox(this, "error", Message.template.numberOnly("상시근로자수"));
					isSubmit = false;
					return false;
				}
				if (this.value < 0 || this.value > 9999999999) {
					jsMsgBox(this, "error", "입력한 상시근로자수가 유효하지 않습니다.");
					isSubmit = false;
					return false;
				}
			});
			
			if (!isSubmit) return;
			
			// 자본금 유효성 검증
			$("input[name=ad_capl]").each(function() {
				if (this.value == null || this.value == "") {
					jsMsgBox(this, "error", Message.template.required("자본금"));
					isSubmit = false;
					return false;
				}
				if (!$.isNumeric(this.value)) {
					jsMsgBox(this, "error", Message.template.numberOnly("자본금"));
					isSubmit = false;
					return false;
				}
				if (this.value < 0 || this.value > 9999999999999999) {
					jsMsgBox(this, "error", "입력한 자본금이 유효하지 않습니다.");
					isSubmit = false;
					return false;
				}
			});
			
			if (!isSubmit) return;
			
			// 매출액 유효성 검증
			$("input[name=ad_selng_am]").each(function() {
				if (this.value == null || this.value == "") {
					jsMsgBox(this, "error", Message.template.required("매출액"));
					isSubmit = false;
					return false;
				}
				if (!$.isNumeric(this.value)) {
					jsMsgBox(this, "error", Message.template.numberOnly("매출액"));
					isSubmit = false;
					return false;
				}
				if (this.value < 0 || this.value > 9999999999999999) {
					jsMsgBox(this, "error", "입력한 매출액이 유효하지 않습니다.");
					isSubmit = false;
					return false;
				}
			});

			if (!isSubmit) return;
			
			// 3년평균 매출액 유효성 검증
			$("input[name=ad_y3avg_selng_am]").each(function() {
				if (this.value == null || this.value == "") {
					jsMsgBox(this, "error", Message.template.required("3년평균 매출액"));
					isSubmit = false;
					return false;
				}
				if (!$.isNumeric(this.value)) {
					jsMsgBox(this, "error", Message.template.numberOnly("3년평균 매출액"));
					isSubmit = false;
					return false;
				}
				if (this.value < 0 || this.value > 9999999999999999) {
					jsMsgBox(this, "error", "입력한 3년평균 매출액이 유효하지 않습니다.");
					isSubmit = false;
					return false;
				}
			});
			
			if (!isSubmit) return;

			jsMsgBox(null, 'confirm','<spring:message code="confirm.common.save" />', function(){
				
				// 체크박스 값 가공처리
				$("input:checkbox").each(function() {
					if (this.checked == false) {
						this.value = 'N';
						this.checked = true;
					} else {
						this.value = 'Y';
					}
				});
				
				$("#df_method_nm").val("processScaleStdr");
				<c:if test="${lastJudgeStdrInfo != null }">$("#ad_last_applc_end_de").val($("#ad_last_applc_end_de").cleanVal());</c:if>
				$("#ad_applc_begin_de").val($("#ad_applc_begin_de").cleanVal());
				form.submit();
			});
		}
	});

	$("#btn_add_stdr").click(function(){
		addRow();
		getIndCode(data_list_cnt);
	});
	
	// 행 추가
	function addRow() {
		data_list_cnt++;
		$("#stdr_list tbody").append(
				'<tr><td>'+data_list_cnt+'</td>'+
				'<td><div class="btn_inner"><a href="#none" class="btn_in_gray" id="selectIndCode_'+data_list_cnt+'" onclick="getIndCode('+data_list_cnt+');">'+
				'<span>업종선택</span></a></div><span id="ind_code_name_'+data_list_cnt+'"></span></td>'+
				'<td><input type="checkbox" name="ad_ordtm_labrr_co_applc_at" value="Y" /></td>'+
				'<td class="tal"><input name="ad_ordtm_labrr_co" type="text" class="text tar" style="width:80%;" title="명" maxlength="10"/> 명</td>'+
				'<td><input type="checkbox" name="ad_capl_applc_at" value="Y" /></td>'+
				'<td class="tal"><input name="ad_capl" type="text" class="text tar" style="width:70%;" title="원" maxlength="16" /> 원</td>'+
				'<td><input type="checkbox" name="ad_selng_am_applc_at" value="Y" /></td>'+
				'<td class="tal"><input name="ad_selng_am" type="text" class="text tar" style="width:70%;" title="원" maxlength="16" /> 원</td>'+
				'<td><input type="checkbox" name="ad_y3avg_selng_am_applc_at" value="Y" /></td>'+
				'<td class="tal"><input name="ad_y3avg_selng_am" type="text" class="text tar" style="width:70%;" title="원" maxlength="16" /> 원</td></tr>'+
				'<input type="hidden" name="ad_isnew" value="Y" />'+
				'<input type="hidden" name="ad_sn" id="ad_sn_'+data_list_cnt+'" value="0" />'+
				'<input type="hidden" name="ad_ind_cd" id="ad_ind_cd_'+data_list_cnt+'" value="" />'		);
	}
});

function getIndCode(sno) {
    $.colorbox({
        title : "업종선택",
        href : "${svcUrl}?df_method_nm=selectIndCdList&scrno="+sno+"&ad_ac_type="+$("#ad_ac_type").val()+"&ad_stdr_sn="+$("#ad_stdr_sn").val()+"&ad_sn="+$("#ad_sn_"+sno).val(),
        width : "500",
        height : "700",
        overlayClose : false,
        escKey : false,
        iframe : true
    });
}
</script>
</head>
<body>
   <!--//content-->
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title_line">규모기준변경</h2>
                <!-- 타이틀 영역 //-->
				<form id="dataForm" name="dataForm" action="<c:url value='${svcUrl}'/>" method="post">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />

				<input type="hidden" name="ad_ac_type" id="ad_ac_type" value="${param.ad_ac_type }" />
				<input type="hidden" name="ad_stdr_sn" id="ad_stdr_sn" value="${param.ad_stdr_sn }" />
				<input type="hidden" name="ad_last_stdr_sn" id="ad_last_stdr_sn" value="<c:if test="${lastJudgeStdrInfo == null }">N</c:if>${lastJudgeStdrInfo.stdrSn}" />

                <div class="block2">
                    <h3>규모기준</h3>
                    <c:if test="${param.ad_ac_type != 'view' }">
                    <div class="btn_pag fr" style="margin-top:-30px"><a class="btn_page_admin" href="#none" onclick="$('#dataForm').submit();"><span>저장</span></a></div>
					</c:if>
                    <!--//내용 -->                  	
                        <table cellpadding="0" cellspacing="0" class="table_basic" summary="규모기준 내용설명 테이블">
                            <caption>
                            규모기준 내용설명
                            </caption>
                            <colgroup>
                            <col width="20%" />
                            <col width="*" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">최종기준적용기간</th>
                                    <td>
                                    <c:if test="${lastJudgeStdrInfo == null }">
                                    	<input type="hidden" name="ad_last_applc_end_de" id="ad_last_applc_end_de" value="00000000" />
                                   	 	최종기준적용기간 없음
                                   	</c:if>
                                    <c:if test="${lastJudgeStdrInfo != null }">
                                    	<input type="text" name="ad_last_applc_begin_de" id="ad_last_applc_begin_de" class="text" style="width:120px;" title="년월일" value="${lastJudgeStdrInfo.applcBeginDe }" readonly="readonly" /> ~
                                        <input type="text" name="ad_last_applc_end_de" id="ad_last_applc_end_de" class="text" style="width:120px;" title="년월일" value="${lastJudgeStdrInfo.applcEndDe }" readonly="readonly" />
                                    </c:if>
                                    </td>
                                    <th scope="row">신규기준적용기간</th>
                                    <td class="tal"><input type="text" name="ad_applc_begin_de" id="ad_applc_begin_de" class="text" style="width:120px;" title="년월일" value="${judgeStdrInfo.applcBeginDe }" readonly="readonly" />
                                        ~ <c:if test="${judgeStdrInfo == null}">9999-12-31</c:if>${judgeStdrInfo.applcEndDe }</td>
                                </tr>
                                <tr>
                                    <th scope="row">변경내용 설명</th>
                                    <td colspan="3"><span class="right_line">
                                        <textarea name="ad_dc" id="ad_dc" cols="85" rows="3" title="내용입력란"  style="width:95%;" placeholder="변경내용 설명 입력">${judgeStdrInfo.dc }</textarea>
                                        </span></td>
                                </tr>
                            </tbody>
                        </table>
                    <!-- 내용// -->
                </div>
                <!--리스트영역 //-->
                <div class="block2">
                	<c:if test="${param.ad_ac_type != 'view' }">
                    <div class="btn_page_middle"><a class="btn_page_admin" href="#none" id="btn_add_stdr"><span>순번추가</span></a></div>
                    </c:if>
                    <!--// 리스트 -->
                    <div class="list_zone">
                        <table cellspacing="0" border="0" id="stdr_list" summary="상한기준목록" class="list">
                            <caption>
                            리스트
                            </caption>
                            <colgroup>
                            <col width="5%" />
                            <col width="19%" />
                            <col width="7%" />
                            <col width="12%" />
                            <col width="7%" />
                            <col width="12%" />
                            <col width="7%" />
                            <col width="12%" />
                            <col width="7%" />
                            <col width="12%" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th rowspan="2" scope="col">순번</th>
                                    <th rowspan="2" scope="col">대상업종</th>
                                    <th colspan="2" scope="col">상시근로자수</th>
                                    <th colspan="2" scope="col">자본금</th>
                                    <th colspan="2" scope="col">매출액</th>
                                    <th colspan="2" scope="col">3년평균 매출액</th>
                                </tr>
                                <tr>
                                    <th scope="col">적용여부</th>
                                    <th scope="col">초과기준</th>
                                    <th scope="col">적용여부</th>
                                    <th scope="col">초과기준</th>
                                    <th scope="col">적용여부</th>
                                    <th scope="col">초과기준</th>
                                    <th scope="col">적용여부</th>
                                    <th scope="col">초과기준</th>
                                </tr>
                            </thead>
                            <tbody>
                            <c:if test="${scaleStdrList == null }">
                                <tr>
                                    <td>1</td>
                                    <td>
                                    	<div class="btn_inner"><a href="#none" class="btn_in_gray" id="selectIndCode_1" onclick="getIndCode(1);"><span>업종선택</span></a></div>
                                    	<span id="ind_code_name_1"></span>
                                    </td>
                                    <td><input type="checkbox" name="ad_ordtm_labrr_co_applc_at" value="Y" /></td>
                                    <td class="tal"><input name="ad_ordtm_labrr_co" type="text" class="text tar" style="width:80%;" title="명" maxlength="10" />
                                        명</td>
                                    <td><input type="checkbox" name="ad_capl_applc_at" value="Y" /></td>
                                    <td class="tal"><input name="ad_capl" type="text" class="text tar" style="width:70%;" title="원" maxlength="16" />
                                        원</td>
                                    <td><input type="checkbox" name="ad_selng_am_applc_at" value="Y" /></td>
                                    <td class="tal"><input name="ad_selng_am" type="text" class="text tar" style="width:70%;" title="원" maxlength="16" />
                                        원</td>
                                    <td><input type="checkbox" name="ad_y3avg_selng_am_applc_at" value="Y" /></td>
                                    <td class="tal"><input name="ad_y3avg_selng_am" type="text" class="text tar" style="width:70%;" title="원" maxlength="16" />
                                        원</td>
                                </tr>
                              	<input type="hidden" name="ad_isnew" value="Y" />
                              	<input type="hidden" name="ad_sn" id="ad_sn_1" value="0" />
                              	<input type="hidden" name="ad_ind_cd" id="ad_ind_cd_1" value="" />
                            </c:if>
                            <c:forEach items="${scaleStdrList}" var="scaleStdr" varStatus="status">
                                <tr>
                                    <td>${status.count }</td>
                                    <td>
                                    	<div class="btn_inner"><a href="#none" class="btn_in_gray" id="selectIndCode_${status.count }" onclick="getIndCode(${status.count });"><span>업종선택</span></a></div>
                                    	<span id="ind_code_name_${status.count }"><c:out value="${scaleStdr.indName }" /></span>
                                    </td>
                                    <td><input type="checkbox" name="ad_ordtm_labrr_co_applc_at" value="Y" <c:if test="${scaleStdr.ordtmLabrrCoApplcAt == 'Y' }">checked </c:if>/></td>
                                    <td class="tal"><input name="ad_ordtm_labrr_co" type="text" class="text tar" style="width:80%;" title="명" value="${scaleStdr.ordtmLabrrCo }" maxlength="10" />
                                        명</td>
                                    <td><input type="checkbox" name="ad_capl_applc_at" value="Y" <c:if test="${scaleStdr.caplApplcAt == 'Y' }">checked </c:if>/></td>
                                    <td class="tal"><input name="ad_capl" type="text" class="text tar" style="width:70%;" title="원" value="${scaleStdr.capl }" maxlength="16" />
                                        원</td>
                                    <td><input type="checkbox" name="ad_selng_am_applc_at" value="Y" <c:if test="${scaleStdr.selngAmApplcAt == 'Y' }">checked </c:if>/></td>
                                    <td class="tal"><input name="ad_selng_am" type="text" class="text tar" style="width:70%;" title="원" value="${scaleStdr.selngAm }" maxlength="16" />
                                        원</td>
                                    <td><input type="checkbox" name="ad_y3avg_selng_am_applc_at" value="Y" <c:if test="${scaleStdr.y3avgSelngAmApplcAt == 'Y' }">checked </c:if>/></td>
                                    <td class="tal"><input name="ad_y3avg_selng_am" type="text" class="text tar" style="width:70%;" title="원" value="${scaleStdr.y3avgSelngAm }" maxlength="16" />
                                        원</td>
                                </tr>
                              	<input type="hidden" name="ad_isnew" value="N" />
                              	<input type="hidden" name="ad_sn" id="ad_sn_${status.count }" value="${scaleStdr.sn }" />
                              	<input type="hidden" name="ad_ind_cd" id="ad_ind_cd_${status.count }" value="<c:out value="${scaleStdr.indCd }" />" />
							</c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <!-- 리스트// -->
				</form>
                </div>
            </div>
        </div>
        <!--content//-->
    </div>
</body>
</html>