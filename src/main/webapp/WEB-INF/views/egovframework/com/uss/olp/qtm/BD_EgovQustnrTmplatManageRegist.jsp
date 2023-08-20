<%--
  Class Name : EgovQustnrTmplatManageRegist.jsp
  Description : 설문템플릿 등록 페이지
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
<title>설문템플릿등록</title>

<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javaScript">

$(document).ready(function(){
	
	$("#qustnrTmplatManageVO").validate({  
		rules : {
			qestnrTmplatTy: {
				required: true,
				maxlength: 100
			},
			qestnrTmplatCours: {
				required: true,
				maxlength: 100
			},
			qestnrTmplatCn: {
				required: true,
				maxlength: 1000
			}
		},
		submitHandler: function(form) {
			
			if ($("#qestnrTmplatCours").val().indexOf(".jsp") > 0) {
				 jsMsgBox($("#qestnrTmplatCours"), "error", "파일명에서 확장자 .jsp를 제거해주세요.");
				return;
			}
			
			jsMsgBox(null, 'confirm','<spring:message code="confirm.common.save" />', 
					function(){$("#df_method_nm").val("insertEgovQustnrTmplatManage");form.submit();});
		}
	});
});

/* ********************************************************
 * 목록 으로 가기
 ******************************************************** */
function fn_egov_list_QustnrTmplatManage(){
	var form = document.qustnrTmplatManageVO;
    form.df_method_nm.value = "";
    form.submit();
}

</script>
</head>
<body>
   <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">설문템플릿등록</h2>
                <!-- 타이틀 영역 //-->
				<form:form commandName="qustnrTmplatManageVO" name="qustnrTmplatManageVO" action="${svcUrl}" method="post">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />
				
				<!-- 검색조건 유지 -->
				<input type="hidden" name="searchCondition" value="<c:out value='${searchVO.searchCondition}'/>"/>
				<input type="hidden" name="searchKeyword" value="<c:out value='${searchVO.searchKeyword}'/>"/>
                <div>
                    <h3 class="mgt30"> <span>항목은 입력 필수 항목 입니다.</span> </h3>					
                    <table cellpadding="0" cellspacing="0" class="table_basic" summary="설문템플릿등록">
                        <caption>
                        설문템플릿등록
                        </caption>
                        <colgroup>
                        <col width="150" />
                        <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th class="point" scope="row"><label for="qestnrTmplatTy">템플릿명</label></th>
                                <td>
                                	<form:input path="qestnrTmplatTy" cssStyle="width:90%;" maxlength="100" title="템플릿명 입력" placeholder="템플릿 이름을 입력해 주세요" />
                                	<form:errors path="qestnrTmplatTy" cssClass="hiddden_txt" element="div" />
                                </td>
                            </tr>
                            <tr>
                                <th class="point" scope="row"><label for="qestnrTmplatCours"> 템플릿경로</label></th>
                                <td>
                                	<form:input path="qestnrTmplatCours" cssStyle="width:88%;" maxlength="100" title="템플릿경로 입력" placeholder="템플릿 파일 경로를 입력해 주세요" />.jsp
                                	<form:errors path="qestnrTmplatCours" cssClass="hiddden_txt" element="div" />
                                </td>
                            </tr>
                            <tr>
                                <th class="point" scope="row"><label for="qestnrTmplatCn"> 템플릿설명</label></th>
                                <td>
                                	<form:textarea path="qestnrTmplatCn" rows="8" cssStyle="width:90%;" title="템플릿설명 입력" placeholder="템플릿에 대한 설명을 입력해 주세요" />
                                	<form:errors path="qestnrTmplatCn" cssClass="hiddden_txt" element="div" />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="btn_page_last">
                	<a class="btn_page_admin" href="#none" onclick="fn_egov_list_QustnrTmplatManage();"><span>취소</span></a> 
                	<a class="btn_page_admin" href="#none" onclick="$('#qustnrTmplatManageVO').submit();"><span>확인</span></a> 
                </div>
                </form:form>
            </div>
        </div>
        <!--content//-->
    </div>

</body>
</html>
