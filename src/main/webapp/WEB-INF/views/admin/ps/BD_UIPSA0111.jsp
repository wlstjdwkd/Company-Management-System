<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,multifile,blockUI,multiselect,colorboxAdmin" />
<ap:jsTag type="tech" items="util,msg,acm" />
<script type="text/javascript">

	$(document).ready(function() {
		<c:if test="${resultMsg != null}">
		$(function() {
			jsMsgBox(null, "info", "${resultMsg}");
		});
		</c:if>
		<c:if test="${resultList != null}">
			<c:forEach items="${resultList}" var="resultList" varStatus="status">
				$(function() {
					document.getElementById('qustnrSj').value = '${resultList.qustnrSj}';
					document.getElementById('qustnrPurps').value = '${resultList.qustnrPurps}';
					document.getElementById('qustnrTrget').value = '${resultList.qustnrTrget}'
					
				})
			</c:forEach>
		</c:if>
	});
	
	function btn_input_reset() {
		$("#dataForm").each(function() {
			this.reset();
		});	
	}
	
	function sendData() {
		var form = document.dataForm;
		$("#df_method_nm").val("updateData");
		
		form.submit(); 
	}
	
	function btn_input_back() {
		var form = document.dataForm;
		$("#df_method_nm").val("");
		
		form.submit(); 	
	}
	
	function openTab(evt, tabid, tabnum){
		var i, content, tablist;
		
		tabcontent=document.getElementsByClassName('tabcon');
		for(i=0; i<tabcontent.length; i++){
			tabcontent[i].style.display = "none"
		}
		
		document.getElementById(tabid).style.display = "block";
		
		//needs optimization to be shorter 
		if(tabnum == 1){
			document.getElementById('tabtitle').innerHTML = 'SQL'
		}
	}
</script>
</head>
<body>
<!--//content-->
<div id="wrap">
	<div class="wrap_inn">
		<div class="contents">
			<h2 class="menu_title" id="tabtitle">설문좐리 정보 수정 폼 샘플</h2>
				<div style="height: 300px;" >
        		<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
        			<ap:include page="param/defaultParam.jsp" />
					<ap:include page="param/dispParam.jsp" />
					<input type="hidden" name="searchValue" id="searchValue" value = '${searchValue }' />
					<input type="hidden" name="qestnrId" id="qestnrId" value = '${targetID }' />
					<input type="hidden" id="init_search_yn" name="init_search_yn" value="N" />
					<table cellpadding="0" cellspacing="0" class="table_search">
                        <c:forEach items="${resultList}" var="resultList" varStatus="status">
                        <tr>
                            <th scope="row">제목</th>
                            <td>
                            	<input name = "qustnrSj" type = "text" id="qustnrSj" size="35" required>                    
                           	</td>
                        </tr>
                        
                        <tr>
                        	<th scope="row">목적</th>
                            <td>
                            	<input name = "qustnrPurps" type = "text" id="qustnrPurps" size="35" required>                                                                        
                            </td>
                        </tr>
                 
                         <tr>
                            <th scope="row">설문대상</th>
                            <td>
                            	<input name = "qustnrTrget" type = "text" id="qustnrTrget" size="35" required>                        
                            </td>
                        </tr>        
                        <tr>
							<th scope="row">안내</th>
		                    <td>
								<textarea id="qustnrWritngGuidanceCn" name = "qustnrWritngGuidanceCn" rows="10" cols="100" cssStyle="width:300px;" title="설문작성안내 내용 입력" placeholder="안내를 입력해 주세요.">${resultList.qustnrWritngGuidanceCn}</textarea>
		                   </td>                        
                        </tr>
						</c:forEach>
                    </table>
                    <div class="btn_page_search">
                    		<a class="btn_page_admin" href="#none" id="btn_search_ok" onclick="sendData();"><span>저장</span></a> 
                    		<a class="btn_page_admin" href="#none" id="btn_reset" onclick = "btn_input_reset();"><span id="btnReset">초기화</span></a>
                    		<a class="btn_page_admin" href="#none" id="btn_back" onclick = "btn_input_back()"><span id="btnBack">뒤로</span></a>
                    </div>
                	</form>
                </div>
                
	            <!-- Tab clicker -->
	            <div class="tabwrap">
	                <div class="tab">
	                    <ul id="gnb">
	                        <li class="on" onclick="openTab(event, 'tab1', 1);" id = 'tabnum1'><a href="#none">SQL</a></li>
	                    </ul>
	                </div>
	            </div>
	            <!-- Tab1 -->
	            <div class="tabcon" style="display: block;" id="tab1">
	            	<span id="sqltabcon">
	            		<c:forEach items ="${sqlMessage }" var="indMess">
							${indMess }<br><br>
						</c:forEach>
	            	</span>
	            </div>
				<!-- Content End -->
    	</div>
	</div>
</div>
<!--content//-->
</body>
</html>