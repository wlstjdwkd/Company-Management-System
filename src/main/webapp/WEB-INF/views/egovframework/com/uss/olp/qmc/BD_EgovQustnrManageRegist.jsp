<%--
  Class Name : EgovQustnrManageRegist.jsp
  Description : 설문관리 등록 페이지
  Modification Information

      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2008.03.09    장동한          최초 생성

    author   : 공통서비스 개발팀 장동한
    since    : 2009.03.09

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
<title>설문정보등록</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,mask,msgBoxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javaScript">

$(document).ready(function(){
	// 달력
	$('#qestnrBeginDe').datepicker({
        showOn : 'button',
        defaultDate : null,
        buttonImage : '<c:url value="/images/acm/icon_cal.png" />',
        buttonImageOnly : true,
        changeYear: true,
        changeMonth: true,
        yearRange: "0:+3",
        minDate:0
    });
	$('#qestnrEndDe').datepicker({
        showOn : 'button',
        defaultDate : null,
        buttonImage : '<c:url value="/images/acm/icon_cal.png" />',
        buttonImageOnly : true,
        changeYear: true,
        changeMonth: true,
        yearRange: "0:+3",
        minDate:0
    });

    $('#qestnrBeginDe').mask('0000-00-00');
    $('#qestnrEndDe').mask('0000-00-00');

    // form submit validation
	$("#qustnrManageVO").validate({
		rules : {
			qestnrSj: {
				required: true,
				maxlength: 250
			},
			qestnrPurps: {
				required: true,
				maxlength: 1000
			},
			qestnrWritngGuidanceCn: {
				required: true,
				maxlength: 500
			},
			qestnrTmplatId: {
				required: true
			}
		},
		submitHandler: function(form) {
			
			if ( $("#qestnrBeginDe").val() == null || $("#qestnrEndDe").val() == null || $("#qestnrBeginDe").val() == "" || $("#qestnrEndDe").val() == "" ) {
				jsMsgBox(null, "error", Message.msg.bothRequiredDateCondition);
				return;
			}
			
			if($("#qestnrBeginDe").val() > $("#qestnrEndDe").val() || $("#qestnrBeginDe").val().replace(/-/gi,"") > $("#qestnrEndDe").val().replace(/-/gi,"")){
		        jsMsgBox(null, "error", Message.msg.invalidDateCondition);
		        $("#qestnrEndDe").focus();
		        return;
		    }
			
			jsMsgBox(null, 'confirm','<spring:message code="confirm.common.save" arguments="이메일" />', function(){
				$("#cmd").val("save");
				$("#df_method_nm").val("insertEgovQustnrManage");
				form.submit();
			});
		}
	});	
	
});


/* ********************************************************
 * 목록 으로 가기
 ******************************************************** */
function fn_egov_list_QustnrManage(){
	
    var form = document.getElementById("qustnrManageVO");
    form.action = "${svcUrl}";
    form.df_method_nm.value = "";
    form.submit()
}

</script>
</head>
<body>
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">설문정보등록</h2>
                <!-- 타이틀 영역 //-->
                <div>
                    <h3> <span>항목은 입력 필수 항목 입니다.</span> </h3>
					<form:form commandName="qustnrManageVO" name="qustnrManageVO" action="${svcUrl}">
					<ap:include page="param/defaultParam.jsp" />
					<ap:include page="param/dispParam.jsp" />
					<ap:include page="param/pagingParam.jsp" />
					
					<!-- 검색조건 유지 -->
					<input type="hidden" id="searchCondition" name="searchCondition" value="<c:out value='${searchVO.searchCondition}'/>"/>
					<input type="hidden" id="searchKeyword" name="searchKeyword" value="<c:out value='${searchVO.searchKeyword}'/>"/>
					
					<input type="hidden" id="cmd" name="cmd" value="">
					
                    <table cellpadding="0" cellspacing="0" class="table_basic" summary="설문정보등록">
                        <caption>
                        설문정보등록
                        </caption>
                        <colgroup>
                        <col width="150" />
                        <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row" class="point">설문제목</th>
                                <td>
                                	<form:input path="qestnrSj" cssStyle="width:90%;" maxlength="250" title="설문제목 입력" placeholder="설문 제목을 입력해 주세요." />
									<form:errors path="qestnrSj" cssClass="hiddden_txt" element="div" />
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="point">설문기간</th>
                                <td><span class="only">
									<form:input path="qestnrBeginDe" cssStyle="width:110px;" maxlength="10" title="설문대상 시작일 입력"/>
									<form:errors path="qestnrBeginDe" cssClass="hiddden_txt" element="div" />
                                    ~
									<form:input path="qestnrEndDe" cssStyle="width:110px;" maxlength="10" title="설문대상 종료일 입력"/>
									<form:errors path="qestnrEndDe" cssClass="hiddden_txt" element="div" />
                                    </span></td>
                            </tr>
                            <tr>
                                <th scope="row" class="point">설문목적</th>
                                <td>
									<form:input path="qestnrPurps" cssStyle="width:90%;" title="설문목적 입력" placeholder="설문 목적을 입력해 주세요." />
									<form:errors path="qestnrPurps" cssClass="hiddden_txt" element="div" />
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="point">설문안내</th>
                                <td>
									<form:textarea path="qestnrWritngGuidanceCn" rows="3" cssStyle="width:90%;" title="설문작성안내 내용 입력" placeholder="설문 안내를 입력해 주세요." />
									<form:errors path="qestnrWritngGuidanceCn" cssClass="hiddden_txt" element="div" />
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="point">템플릿명</th>
                                <td><ul class="def">
									<c:forEach items="${listQustnrTmplat}" var="resultQustnrTmplat" varStatus="status">
                                        <li>
                                            <input type="radio" name="qestnrTmplatId" id="qestnrTmplatId_${status.count }" value="${resultQustnrTmplat.qestnrTmplatId}" />
                                            <label for="qestnrTmplatId_${status.count }">${resultQustnrTmplat.qestnrTmplatTy}</label>
                                        </li>
									</c:forEach>
                                    </ul></td>
                            </tr>
                        </tbody>
                    </table>
                	</form:form>
                </div>
                <div class="btn_page_last">
                	<a class="btn_page_admin" href="#none" onclick="fn_egov_list_QustnrManage();"><span>취소</span></a> 
                	<a class="btn_page_admin" href="#none" onclick="$('#qustnrManageVO').submit();"><span>확인</span></a> 
                </div>
            </div>
        </div>
        <!--content//-->
    </div>

</body>
</html>
