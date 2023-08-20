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
		
		$("#dataForm").validate({  
			invalidHandler: function(event, validator){												//	폼 등록이 잘못됬을때
				var errors = validator.numberOfInvalids();
				if(errors){
					jsMsgBox(null, "info", "필수입력 항목을 확인하세요.");
				}
			},
			submitHandler: function(form){															//	등록핸틀러 하면
				$("#df_method_nm").val("insertData");
				form.submit(); 
			}
		});
	});
	
																									// 텝 바꾸기
	function openTab(evt, tabid, tabnum){
		console.log("open");
		var i, content, tablist;
		
		tabcontent=document.getElementsByClassName('tabcon');
		for(i=0; i<tabcontent.length; i++){
			tabcontent[i].style.display = "none"
		}
		
		document.getElementById(tabid).style.display = "block";
		 
		if(tabnum == 1){																			//	더 좋은 방법이 필요?
			$('#tabnum2').removeClass('on');
			$('#tabnum1').addClass('on');
			
		}
		if(tabnum == 2){
			$('#tabnum1').removeClass('on');
			$('#tabnum2').addClass('on');
			
		}
	}
	function btn_input_reset() {
		$("#dataForm").each(function() {
			this.reset();
		});	
	}
	
</script>
</head>
<body>
<!--//content-->
<div id="wrap">
	<div class="wrap_inn">
		<div class="contents">
			<h2 class="menu_title" id="tabtitle">설무관리 정보 등록 샘플</h2>
				<div style="height: 300px;" >
        		<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
        			<ap:include page="param/defaultParam.jsp" />
					<ap:include page="param/dispParam.jsp" />
					
					<table cellpadding="0" cellspacing="0" class="table_search">
                        <colgroup>
                       		<col width="15%" />
	                        <col width="30%" />
	                        <col width="15%" />
	                        <col width="40%" />
                        </colgroup>
                        <tr>
                            <th scope="row">설문제목<span style = "color: red">*</span></th>
                            <td>
                            	<input name = "qustnrSj" id = "qustnrSj" type = "text" required>                    
                           	</td>
                            <th scope="row">설문목적</th>
                            <td>
                            	<input name = "qustnrPurps" id = "qustnrPurps" type = "text">                                                                        
                            </td>
                        </tr>
                         <tr>
                            <th scope="row">설문대상</th>
                            <td>
                            	<input name = "qustnrTrget" id = "qustnrTrget" type = "text">                        
                            </td>
                            <th scope="row">템플릿명<span style = "color: red">*</th>
                            <td>
                            	<c:forEach items="${listQustnrTmplat}" var="resultQustnrTmplat" varStatus="status">
                                       <input type="radio" name="qustnrTmplatId" id="qustnrTmplatId" value="${resultQustnrTmplat.qustnrTmplatId}" required/>
                                       <label for="${resultQustnrTmplat.qestnrtmplatid}">${resultQustnrTmplat.qustnrTmplatTy}</label>
								</c:forEach>                                                                  
                            </td>
                        </tr>        
                        <th scope="row">안내</th>
		                    <td>
								<textarea rows="3" cols="60" cssStyle="width:300px;" title="내용 입력" placeholder="안내를 입력해 주세요." name = "qustnrWritngGuidanceCn" id = "qustnrWritngGuidanceCn"></textarea>
		                   </td>
                    </table>
                    <div class="btn_page_search">
                    		<a class="btn_page_admin" href="#none" id="btn_search_ok" onclick="$('#dataForm').submit();"><span>등록</span></a> 
                    		<a class="btn_page_admin" href="#none" id="btn_reset" onclick = "btn_input_reset();"><span id="btnReset">초기화</span></a>
                    </div>
                	</form>
                </div>
				
				<!-- Tab clicker -->
					<div class="tabwrap">
    					<div class="tab">
        					<ul id="gnb">
            					<li class="on" onclick="openTab(event, 'tab1', 1);" id = 'tabnum1'><a href="#none">Java</a></li>
								<li onclick="openTab(event, 'tab2', 2)" id= 'tabnum2'><a href="#none">SQL</a></li>
        					</ul>
    					</div>
					</div>
				<!-- Tab1 -->
					<div class="tabcon" style="display: block; border: 1px" id="tab1">
						<span id="javatabcon">
							<c:forEach items ="${javaMessage }" var="indMess">
								${indMess }<br>
							</c:forEach>
						</span>
					</div>
   
				<!-- Tab 2 -->
					<div class="tabcon" style="display: none;" id="tab2">
						<span id="sqltabcon">
							${sqlMessage}
						</span>
					</div>
				</div>
				<!-- Content End -->
    	</div>
	</div>
</div>
<!--content//-->
</body>
</html>