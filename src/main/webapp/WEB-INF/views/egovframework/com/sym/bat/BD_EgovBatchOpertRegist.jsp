<%--
  Class Name : EgovBatchOpertRegist.jsp
  Description : 배치작업등록 페이지
  Modification Information
 
      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2010.08.19    김진만          최초 생성
 
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
<title>배치작업등록</title>

<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javaScript">

$(document).ready(function(){
	
	$("#batchOpert").validate({  
		rules : {
			batchOpertNm: {
				required: true,
				maxlength: 60
			},
			batchProgrm: {
				required: true,
				maxlength: 255
			}
		},
		submitHandler: function(form) {
			jsMsgBox(null, 'confirm','<spring:message code="confirm.common.save" />', function(){$("#df_method_nm").val("insertBatchOpert");form.submit();});
		}
	});
});

/* ********************************************************
 * 목록 으로 가기
 ******************************************************** */
function fn_egov_list(){
    var varForm = document.getElementById("batchOpert");
    varForm.df_method_nm.value = "";
    varForm.submit();
}

</script>
</head>
<body>
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title_line">배치작업등록</h2>
                <!-- 타이틀 영역 //-->
                <div class="block">
                    <h3 class="mgt30">
                    <span>항목은 입력 필수 항목 입니다.</span>
                    </h3>
                    <!--// 등록 -->
					<form:form commandName="batchOpert"  action="${svcUrl }" method="post">
					<ap:include page="param/defaultParam.jsp" />
					<ap:include page="param/dispParam.jsp" />
					<ap:include page="param/pagingParam.jsp" />
					
					<!-- 검색조건 유지 -->
					<input type="hidden" name="searchCondition" value="<c:out value='${searchVO.searchCondition}'/>"/>
					<input type="hidden" name="searchKeyword" value="<c:out value='${searchVO.searchKeyword}'/>"/>
					
                    <table cellpadding="0" cellspacing="0" class="table_basic mgt10" summary="배치작업명, 배치프로그램, 파라미터 입력">
                        <caption>배치작업등록폼</caption>
                        <colgroup>
                        <col width="15%" />
                        <col width="*" />
                        </colgroup>
                        <tr>
                            <th scope="row" class="point"><label for="batchOpertNm">배치작업명</label></th>
                            <td>
                            	<form:input path="batchOpertNm" maxlength="60" cssStyle="width:762px" title="배치작업명입력" placeholder="배치작업명을 입력해 주세요" />
                            	<form:errors path="batchOpertNm" cssClass="hiddden_txt" element="div" /> </td>
                        </tr>
                        <tr>
                            <th scope="row" class="point"><label for="batchProgrm">배치프로그램</label></th>
                            <td>
                            	<form:input path="batchProgrm" maxlength="255" cssStyle="width:762px" title="배치프로그램입력" placeholder="배치프로그램 경로를 입력해 주세요" />
                            	<form:errors path="batchProgrm" cssClass="hiddden_txt" element="div" /> </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="paramtr">파라미터</label></th>
                            <td>
                            	<form:input path="paramtr" maxlength="250" cssStyle="width:762px" title="파라미터입력" placeholder="파라미터를 입력해 주세요" />
                            	<form:errors path="paramtr" cssClass="hiddden_txt" element="div" /> </td>
                        </tr>                        
                    </table>
                </div>
                <!-- 등록// -->
                <div class="btn_page_last">
	                <a class="btn_page_admin" href="#none" onclick='$("#batchOpert").submit();'><span>저장</span></a>
	                <a class="btn_page_admin" href="#none" onclick="fn_egov_list();"><span>목록</span></a>
                </div>
                </form:form>
            </div>
        </div>
    </div>

</body>
</html>