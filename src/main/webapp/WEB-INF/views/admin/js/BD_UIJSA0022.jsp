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
<title>상한기준변경</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,mask" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javaScript">

$(document).ready(function(){
	
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
			},
			ad_ordtm_labrr_co: {
				required: true,
				number : true,
				min : 0,
				max : 9999999999
			},
			ad_assets_totamt: {
				required: true,
				number : true,
				min : 0,
				max : 9999999999999999
			},
			ad_ecptl: {
				required: true,
				number : true,
				min : 0,
				max : 9999999999999999
			},
			ad_y3avg_selng_am: {
				required: true,
				number : true,
				min : 0,
				max : 9999999999999999
			}
		},
		submitHandler: function(form) {
			
			<c:if test="${lastJudgeStdrInfo != null }">
			if ($("#ad_last_applc_end_de").val() == "") {
				jsMsgBox(this, "error", Message.template.required("최종기준적용기간(적용만료일자)"));
				return false;
			}
			
			if($("#ad_last_applc_begin_de").val() > $("#ad_last_applc_end_de").val() || $("#ad_last_applc_begin_de").val().replace(/-/gi,"") > $("#ad_last_applc_end_de").val().replace(/-/gi,"")){
		        jsMsgBox(null, "error", Message.msg.invalidDateCondition);
		        return;
		    }
			
			</c:if>
			
			if ($("#ad_applc_begin_de").val() == "") {
				jsMsgBox(this, "error", Message.template.required("신규기준적용기간(적용시작일자)"));
				return false;
			}

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
				
				$("#df_method_nm").val("processUplmtStdr");
				<c:if test="${lastJudgeStdrInfo != null }">$("#ad_last_applc_end_de").val($("#ad_last_applc_end_de").cleanVal());</c:if>
				$("#ad_applc_begin_de").val($("#ad_applc_begin_de").cleanVal());
				form.submit();
			});
		}
	});

});
</script>
</head>
<body>
   <!--//content-->
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title_line">상한기준변경</h2>
                <!-- 타이틀 영역 //-->
				<form id="dataForm" name="dataForm" action="<c:url value='${svcUrl}'/>" method="post">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />

				<input type="hidden" name="ad_ac_type" id="ad_ac_type" value="${param.ad_ac_type }" />
				<input type="hidden" name="ad_stdr_sn" id="ad_stdr_sn" value="${param.ad_stdr_sn }" />
				<input type="hidden" name="ad_last_stdr_sn" id="ad_last_stdr_sn" value="<c:if test="${lastJudgeStdrInfo == null }">N</c:if>${lastJudgeStdrInfo.stdrSn}" />

                <div class="block2">
                    <h3>상한기준</h3>
                    <c:if test="${param.ad_ac_type != 'view' }">
                    <div class="btn_pag fr" style="margin-top:-30px"><a class="btn_page_admin" href="#none" onclick="$('#dataForm').submit();"><span>저장</span></a></div>
					</c:if>
                    <!--//내용 -->                  	
                        <table cellpadding="0" cellspacing="0" class="table_basic" summary="상한기준 내용설명 테이블">
                            <caption>
                            상한기준 내용설명
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
                    <!--// 리스트 -->
                    <div class="list_zone">
                        <table cellspacing="0" border="0" id="stdr_list" summary="상한기준목록" class="list">
                            <caption>
                            리스트
                            </caption>
                            <colgroup>
                            <col width="8%" />
                            <col width="17%" />
                            <col width="8%" />
                            <col width="17%" />
                            <col width="8%" />
                            <col width="17%" />
                            <col width="8%" />
                            <col width="17%" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th colspan="2" scope="col">상시근로자수</th>
                                    <th colspan="2" scope="col">자산총액</th>
                                    <th colspan="2" scope="col">자기자본</th>
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
                            <c:if test="${uplmtStdrInfo == null }">
                                <tr>
                                    <td><input type="checkbox" name="ad_ordtm_labrr_co_applc_at" value="Y" /></td>
                                    <td class="tal"><input name="ad_ordtm_labrr_co" id="ad_ordtm_labrr_co" type="text" class="text tar" style="width:80%;" title="명" maxlength="10"/>
                                        명</td>
                                    <td><input type="checkbox" name="ad_assets_totamt_applc_at" value="Y" /></td>
                                    <td class="tal"><input name="ad_assets_totamt" id="ad_assets_totamt" type="text" class="text tar" style="width:70%;" title="원" maxlength="16" />
                                        원</td>
                                    <td><input type="checkbox" name="ad_ecptl_applc_at" value="Y" /></td>
                                    <td class="tal"><input name="ad_ecptl" id="ad_ecptl" type="text" class="text tar" style="width:70%;" title="원" maxlength="16" />
                                        원</td>
                                    <td><input type="checkbox" name="ad_y3avg_selng_am_applc_at" value="Y" /></td>
                                    <td class="tal"><input name="ad_y3avg_selng_am" id="ad_y3avg_selng_am" type="text" class="text tar" style="width:70%;" title="원" maxlength="16" />
                                        원</td>
                                </tr>
                            </c:if>
                            <c:if test="${uplmtStdrInfo != null }">
                                <tr>
                                    <td><input type="checkbox" name="ad_ordtm_labrr_co_applc_at" value="Y" <c:if test="${uplmtStdrInfo.ordtmLabrrCoApplcAt == 'Y' }">checked </c:if>/></td>
                                    <td class="tal"><input name="ad_ordtm_labrr_co" id="ad_ordtm_labrr_co" type="text" class="text tar" style="width:80%;" title="명" value="${uplmtStdrInfo.ordtmLabrrCo }" maxlength="10" />
                                        명</td>
                                    <td><input type="checkbox" name="ad_assets_totamt_applc_at" value="Y" <c:if test="${uplmtStdrInfo.assetsTotamtApplcAt == 'Y' }">checked </c:if>/></td>
                                    <td class="tal"><input name="ad_assets_totamt" id="ad_assets_totamt" type="text" class="text tar" style="width:70%;" title="원" value="${uplmtStdrInfo.assetsTotamt }" maxlength="16" />
                                        원</td>
                                    <td><input type="checkbox" name="ad_ecptl_applc_at" value="Y" <c:if test="${uplmtStdrInfo.ecptlApplcAt == 'Y' }">checked </c:if>/></td>
                                    <td class="tal"><input name="ad_ecptl" id="ad_ecptl" type="text" class="text tar" style="width:70%;" title="원" value="${uplmtStdrInfo.ecptl }" maxlength="16" />
                                        원</td>
                                    <td><input type="checkbox" name="ad_y3avg_selng_am_applc_at" value="Y" <c:if test="${uplmtStdrInfo.y3avgSelngAmApplcAt == 'Y' }">checked </c:if>/></td>
                                    <td class="tal"><input name="ad_y3avg_selng_am" id="ad_y3avg_selng_am" type="text" class="text tar" style="width:70%;" title="원" value="${uplmtStdrInfo.y3avgSelngAm }" maxlength="16" />
                                        원</td>
                                </tr>
                            </c:if>
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