<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
<meta charset="UTF-8" />
<title>정보</title>	
<ap:jsTag type="web" items="jquery,colorboxAdmin,msgBoxAdmin,form,notice,tools,ui,validate" />
<ap:jsTag type="tech" items="util,acm" />
<ap:globalConst />
<script type="text/javascript">
$(document).ready(function(){
	
	// 유효성 검사
	$("#dataForm").validate({
		rules : { // 신고자명
			siteNm : {
				required : true,
				maxlength : 50
			},// 사이트명
			siteUrl : {
				required : true,
				maxlength : 250
			},// 사이트 URL
		},
		submitHandler: function(form) {	
			
			$.ajax({
		        url      : "PGDC0070.do",
		        type     : "POST",
		        dataType : "json",
		        data     : { "df_method_nm"		 : "insertRssSite" 
		        			,"rssNo" 		: $('#rssNo').val()
		        			,"siteNm" 	: $('#siteNm').val()
		        			,"siteUrl"		: $('#siteUrl').val()
		        			,"flter1"		: $('#flter1').val()
		        			,"flter2"	 	: $('#flter2').val()
		        		   },                
		        async    : false,             
		        success  : function(response) {
		        	try {
		        		if(response.result) {
		        			jsMsgBox(null, 'info', '작성하신 내용이 성공적으로 <br>등록되었습니다.<br> 이용해 주셔서 감사합니다.',function(){window.parent.curr_rsssite_get_list();parent.$.colorbox.close();});
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
	});	
});


// 확인
var btn_rss_reg = function() {
	
	$("#dataForm").submit();
};

</script>
</head>
<body>

	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		
		<!-- LNB 출력 방지 -->
		<input type="hidden" id="no_lnb" value="true" />
<div id="self_dgs">
	<div class="pop_q_con">		
		<div class="view_zone">
		<table cellpadding="0" cellspacing="0" class="table_basic mgt10" summary="등록">
		                        <caption>
		                        등록
		                        </caption>
		                        <colgroup>
		                        <col width="15%" />
		                        <col width="*" />
		                        <col width="15%" />
		                        <col width="*" />
		                        </colgroup>
								<c:choose>
								   	<c:when test="${fn:length(rsssiteList) > 0}">
								   		<c:forEach items="${rsssiteList}" var="info" varStatus="status" begin="0" end="0">    
										<tr>
			                            <th scope="row">사이트명</th>
			                            <td>
			                            		<input name="rssNo" title="사이트번호" id="rssNo" type="hidden" value="${info.rssNo}"/>
			                            		<input name="siteNm" title="입력" id="siteNm" type="text" style="width:95%" value="${info.siteNm}"/>
			                            </td>
			                             <th scope="row">필터1</th>
			                            <td><input name="flter1" title="입력" id="flter1" type="text" style="width:95%" value="${info.flter1}"/></td>
				                        </tr>
				                        <tr>
				                            <th scope="row">URL 주소</th>
				                            <td><input name="siteUrl" title="입력" id="siteUrl" type="text" style="width:95%" value="${info.url}"/></td>
				                             <th scope="row">필터2</th>
				                            <td><input name="flter2" title="입력" id="flter2" type="text" style="width:95%" value="${info.flter2}"/></td>
				                        </tr>
			                        	</c:forEach>
									</c:when>
								   	<c:otherwise>
										<tr>
			                            <th scope="row">사이트명</th>
			                            <td>
			                            	<input name="rssNo" title="사이트번호" id="rssNo" type="hidden" value="" />
			                            	<input name="siteNm" title="입력" id="siteNm" type="text" style="width:95%"/>
			                            </td>
			                             <th scope="row">필터1</th>
			                            <td><input name="flter1" title="입력" id="flter1" type="text" style="width:95%"/></td>
				                        </tr>
				                        <tr>
				                            <th scope="row">URL 주소</th>
				                            <td><input name="siteUrl" title="입력" id="siteUrl" type="text" style="width:95%"/></td>
				                             <th scope="row">필터2</th>
				                            <td><input name="flter2" title="입력" id="flter2" type="text" style="width:95%"/></td>
				                        </tr>
									</c:otherwise>
								</c:choose>
		
		                    </table>
		<div class="btn_page_last"><a class="btn_page_admin" href="#"  onclick="btn_rss_reg();"><span>등록</span></a> <a class="btn_page_admin" href="#" onclick="parent.$.fn.colorbox.close();"><span>취소</span></a></div>		
		</div>
	</div>
</div>		
</form>
</body>
</html>