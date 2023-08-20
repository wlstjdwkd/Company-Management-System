<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>정보</title>
<script type="text/javascript">
$(document).ready(function(){

});

</script>
</head>

<body>
<!-- <form name="dataForm1" id="dataForm1" method="POST"> -->
<div class="pop_q_con">
    <div class="block">
        <ul class="dib">
            <li>
                <input type="radio" name="ntceAtYN" id="" value="Y">
                <label for="">공개</label>
            </li>
            <li>
                <input type="radio" name="ntceAtYN" id="" value="N">
                <label for="">비공개</label>
            </li>
        </ul>
        <div class="btn_page_last"><a class="btn_page_admin" href="#" onclick="{$.colorbox.close();}"><span>취소</span></a> <a class="btn_page_admin" href="#" onclick="changentceAYN()" ><span>확인</span></a></div>
    </div>
</div>
<!-- </form> -->
</body>
</html>