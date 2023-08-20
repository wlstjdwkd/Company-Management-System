<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>정보</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask" />
<ap:jsTag type="tech" items="acm,msg,util,ms" />

<script type="text/javascript">
	var fn_regist_form = function(type) {
		$("#df_method_nm").val("userInfoWriteForm");
		$("#ad_form_type").val("INSERT");
		$("#ad_join_type").val(type);
		
		$("#dataForm").submit();
	}
</script>


</head>
<body>

	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />
		
		<input type="hidden" id="ad_form_type" name="ad_form_type" />
		<input type="hidden" id="ad_join_type" name="ad_join_type" />		
	</form>
	<!--//content-->
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title_line">회원관리</h2>
                <!-- 타이틀 영역 //-->
                <!--//sub contents -->
                <div class="mem_id_all">
                    <div class="means">
                        <ul class="box">
                            <li><img src="<c:url value="/images/ms/box_img01.png"/>" alt="기관회원" /></li>
                            <div class="btn"> <a class="btn_bul" href="#" onclick="fn_regist_form('${EMPLYR_TY_JB}')" ><span>기관회원가입</span></a> </div>
                        </ul>
                        <ul class="box">
                            <li><img src="<c:url value="/images/ms/box_img02.png"/>" alt="개인회원" /></li>
                            <div class="btn"> <a class="btn_bul" href="#" onclick="fn_regist_form('${EMPLYR_TY_GN}')"><span>개인회원가입</span></a> </div>
                        </ul>
                        <ul class="box">
                            <li><img src="<c:url value="/images/ms/box_img03.png"/>" alt="기업회원" /></li>
                            <div class="btn"> <a class="btn_bul" href="#" onclick="fn_regist_form('${EMPLYR_TY_EP}')"><span>기업회원가입</span></a> </div>
                        </ul>
                    </div>
                    <!--sub contents //-->
                </div>
            </div>
            <!--content//-->
        </div>
    </div>
</body>
</html>