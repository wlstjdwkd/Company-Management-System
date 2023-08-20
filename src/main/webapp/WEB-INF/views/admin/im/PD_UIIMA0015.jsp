<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,form,validate,notice,msgBoxAdmin" />
<ap:jsTag type="tech" items="msg,util,acm" />
<ap:globalConst />	
<script type="text/javascript">
	$(document).ready(function(){
		
	});
	
	function modal(idx){
		if($("#notiHist_" + idx).css("display") == "none"){
			$("#notiHist_" + idx).css("display", "");
		}
		else{
			$("#notiHist_" + idx).css("display", "none");
		}
	}
</script>
</head>

<body>
<form name="dataForm" id="dataForm" method="post" action="/PGIM0010.do">
<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />
<ap:include page="param/pagingParam.jsp" />
<input type="hidden" id="no_lnb" value="true" />
<input type="hidden" id="ad_rcept_no" value="${partclrMatter.RCEPT_NO}" />

<div id="self_dgs">
<div class="pop_q_con">   
   
   <div class="list_zone">
        <table cellspacing="0" border="0" summary="목록">
            <caption>
            리스트
            </caption>
            <colgroup>
            <col width="*" />
            <col width="*" />
            <col width="*" />
            <col width="*" />
            <col width="*" />
            <col width="*" />            
            </colgroup>
            <thead>
                <tr>
                    <th scope="col">접수구분</th>
                    <th scope="col">상태</th>
                    <th scope="col">시각</th>
                    <th scope="col">처리자</th>                    
                    <th scope="col">SMS 알림</th>
                    <th scope="col">이메일 알림</th>
                </tr>
            </thead>
            <tbody>
            	<c:forEach var="notiHist" items="${notiHistList}" varStatus="status">
                <tr>
                    <td class="tac">${notiHist.REQST_SE_NM}</td>
                    <td><a href="#none" onclick="javascript:modal('${status.count}');">${notiHist.SE_CODE_NM}</a></td>
                    <td>${notiHist.RESN_OCCRRNC_DE}</td>
                    <td>${notiHist.USER_NM}</td>
                    <td>${notiHist.SMS_SENT_DT}</td>
                    <td>${notiHist.EMAIL_SENT_DT}</td>                                        
                </tr>
                <tr id="notiHist_${status.count}" style="display:none;">
                	<td style="height:50px;border:1px solid #d7dcda;border-left:0px;">사유</td>   
                    <td colspan="5" style="height:50px;border:1px solid #d7dcda;">${notiHist.RESN}</td>
                </tr>                     
                </c:forEach>
            </tbody>
        </table>
    </div> 
</div>
</div>
</form>
</body>
</html>