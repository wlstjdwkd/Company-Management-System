<%--
  Class Name : EgovQustnrQestnManageRegist.jsp
  Description : 설문문항 등록 페이지
  Modification Information

      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2008.03.09    장동한          최초 생성

    author   : 공통서비스 개발팀 장동한
    since    : 2009.03.19

--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>설문문항등록</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,mask,msgBoxAdmin,colorboxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javaScript">

$(document).ready(function(){

    // form submit validation
	$("#qustnrQestnManageVO").validate({
		rules : {
			qestnSn: {
				required: true,
				number: true,
				min: 1,
				max: 999
			},
			qestnTyCode: {
				required: true
			},
			qestnCn: {
				required: true,
				maxlength: 2500
			},
			mxmmChoiseCo: {
				required: true
			}
		},
		submitHandler: function(form) {

			if ( $("#qestnrCn").val() == null || $("#qestnrTmplatId").val() == null || $("#qestnrId").val() == "") {
				jsMsgBox(null, "error", Message.template.required("설문제목"));
				return;
			}
			
			jsMsgBox(null, 'confirm','<spring:message code="confirm.common.save" />', function(){
				$("#cmd").val("save");
				$("#df_method_nm").val("insertEgovQustnrQestnManage");
				form.submit();
			});
		}
	});	
	
});

/* ********************************************************
 * 목록 으로 가기
 ******************************************************** */
function fn_egov_list_QustnrQestnManage(){
	var form = document.getElementById("qustnrQestnManageVO");

	form.action =  "<c:url value='${svcUrl}' />";
	form.df_method_nm.value = "";
	form.submit();
}

/* ********************************************************
 * 설문지정보 팝업창열기
 ******************************************************** */
function fn_egov_QustnrManageListPopup_QustnrQestnManage(){
    $.colorbox({
        title : "설문정보",
        href : "/PGSO0020.do?df_method_nm=EgovQustnrManageListPopup",
        width : "1024",
        height : "700",
        overlayClose : false,
        escKey : false,
        iframe : true
    });
}

function checkSn() {
	$.ajax({
		url      : "PGSO0030.do",
		type     : "POST",
		dataType : "json",
		data     : { df_method_nm: "EgovQustnrQustnCheckSn", qestnrId: $("#qestnrId").val(), qestnrTmplatId: $("#qestnrTmplatId").val(), qestnSn: $("#qestnSn").val() },
        //data     : $('#dataForm').formSerialize(),
		async    : false,                
		success  : function(response) {
			try {
				if(response.result) {
				} else {
					jsMsgBox($("#qestnSn"), "error", Message.template.duplicationQustnrSn("문항"));
				}
			} catch (e) {
				if(response != null) {
					jsSysErrorBox(response);
				} else {
					jsSysErrorBox(e);
				}
				return;
			}                
		}
	});
}

function checkQestnrCn() {
	if ($("#qestnrCn").val() == "") {
		jsMsgBox($("#qestnrCn"), "error", Message.template.required("설문제목"));
	}
}
</script>
</head>
<body>
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">설문문항등록</h2>
                <!-- 타이틀 영역 //-->
                <div>
                    <h3 class="mgt30"> <span>항목은 입력 필수 항목 입니다.</span> </h3>
                    
                	<form name="qustnrQestnManageVO"  id="qustnrQestnManageVO" action="<c:url value='${svcUrl }' />" method="post">
					<ap:include page="param/defaultParam.jsp" />
					<ap:include page="param/dispParam.jsp" />
					<ap:include page="param/pagingParam.jsp" />
                    
					<!-- 검색조건 유지 -->
					<input type="hidden" id="searchCondition" name="searchCondition" value="<c:out value='${searchVO.searchCondition}'/>"/>
					<input type="hidden" id="searchKeyword" name="searchKeyword" value="<c:out value='${searchVO.searchKeyword}'/>"/>
					
					<input type="hidden" name="qestnrTmplatId" id="qestnrTmplatId" value="${qustnrQestnManageVO.qestnrTmplatId}" />
					<input type="hidden" name="qestnrId" id="qestnrId" value="${qustnrQestnManageVO.qestnrId}" />
					<input type="hidden" name="searchMode" id="searchMode" value="${qustnrQestnManageVO.searchMode}" />	      
					
					<input name="cmd" id="cmd" type="hidden" value="">

                    <table cellpadding="0" cellspacing="0" class="table_basic" summary="설문문항등록">
                        <caption>
                        설문문항등록
                        </caption>
                       <colgroup>
                        <col width="150" />
                        <col />
                        </colgroup>
                        <tbody>
	                        <tr>
	                            <th scope="row" class="point">설문제목</th>
	                            <td>
	                            	<c:if test="${qustnrQestnManageVO.searchMode == 'Y'}">
	                            	${qestnrInfo.qustnrSj}
	                            	<input type="hidden" name="qestnrCn" id="qestnrCn" value="${qustnrQestnManageVO.qestnrId}" />
	                            	</c:if>
	                            	<c:if test="${qustnrQestnManageVO.searchMode != 'Y'}">
	                            	<input type="text" name="qestnrCn" id="qestnrCn" title="설문정보 입력" style="width:665px" readonly="true" class="inp_blue" value="${qestnrInfo.qestnrSj}"/>
	                            	<div class="btn_inner">
	                            		<a href="#none" class="btn_in_gray" title="설문정보찾기팝업" onclick="fn_egov_QustnrManageListPopup_QustnrQestnManage();"><span id="popBatchOpert">설문정보찾기</span></a>
	                            	</div>
	                            	</c:if>               		
	        					</td>
	                        </tr>
                            <tr>
                                <th scope="row" class="point">문항순서</th>
                                <td>
                                	<input type="text" name="qestnSn" id="qestnSn" style="width:110px;" title="문항순서입력" onfocusin="checkQestnrCn();" onfocusout="checkSn();" />
                                	<form:errors path="qestnSn" cssClass="hiddden_txt" element="div" />
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="point">문항유형</th>
                                <td><span class="only">
                                			<ap:code id="qestnTyCode" grpCd="10" type="select" />
                                    </span>
                                    <form:errors path="qestnTyCode" cssClass="hiddden_txt" element="div" />
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="point">문항질문</th>
                                <td>
                                	<textarea name="qestnCn" id="qestnCn" rows="8" title="내용입력란"  style="width:90%;" placeholder="질문내용을 입력해 주세요."></textarea>
                                	<form:errors path="qestnCn" cssClass="hiddden_txt" element="div" />
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="point">선택최대건수</th>
                                <td><span class="only">
											<select name="mxmmChoiseCo" id="mxmmChoiseCo" title="최대선택건수 선택" style="width:110px">
												<option value="1">1</option>
												<option value="2">2</option>
												<option value="3">3</option>
												<option value="4">4</option>
												<option value="5">5</option>
												<option value="6">6</option>
												<option value="7">7</option>
												<option value="8">8</option>
												<option value="9">9</option>
												<option value="10">10</option>
											</select>
                                    </span></td>
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
                <div class="btn_page_last">
                	<a class="btn_page_admin" href="#none" onclick="fn_egov_list_QustnrQestnManage();"><span>취소</span></a> 
                	<a class="btn_page_admin" href="#none" onclick="$('#qustnrQestnManageVO').submit();"><span>확인</span></a> 
                </div>
            </div>
        </div>
        <!--content//-->
    </div>

</body>
</html>
