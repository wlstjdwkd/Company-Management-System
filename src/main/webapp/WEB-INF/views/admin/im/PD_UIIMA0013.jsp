<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,form,validate,notice,msgBoxAdmin" />
<ap:jsTag type="tech" items="msg,util,acm,im" />
<ap:globalConst />	
<script type="text/javascript">
$(document).ready(function(){

});
</script>
</head>

<body>
<form name="dataForm" id="dataForm" method="post" action="/PGIM0010.do">
<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />
<ap:include page="param/pagingParam.jsp" />
<input type="hidden" id="no_lnb" value="true" />

<div id="self_dgs">
<div class="pop_q_con">   
 
    <table cellpadding="0" cellspacing="0" class="table_basic" summary="신청담당자정보보기">
        <caption>
       신청담당자정보
        </caption>
        <colgroup>
        <col width="20%" />
        <col width="*" />
        </colgroup>
        <tbody>
            <tr>
                <th scope="row">담당자명</th>
                <td class="right_line">${chargerInfo.CHARGER_NM}</td>
            </tr>
            <tr>
                <th scope="row">부서</th>
                <td class="right_line">${chargerInfo.CHARGER_DEPT}</td>
            </tr>
            <tr>
                <th scope="row">직위</th>
                <td class="right_line">${chargerInfo.OFCPS}</td>
            </tr>
            <tr>
                <th scope="row">전화</th>
                <td class="right_line">${chargerInfo.TELNO2}</td>
            </tr>
            <tr>
                <th scope="row">핸드폰</th>
                <td class="right_line">${chargerInfo.MBTLNUM}</td>
            </tr>
            <tr>
                <th scope="row">팩스</th>
                <td class="right_line">${chargerInfo.FXNUM}</td>
            </tr>
            <tr>
                <th scope="row">주소</th>
                <td class="right_line">${chargerInfo.HEDOFC_ADRES}</td>
            </tr>
            <tr>
                <th scope="row">e-mail</th>
                <td class="right_line">${chargerInfo.EMAIL}</td>
            </tr>
        </tbody>
    </table>
   
</div>
</div>
</form>
</body>
</html>