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
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,selectbox,blockUI,multiselect,colorboxAdmin" />
<ap:jsTag type="tech" items="util,msg,acm" />
<script type="text/javascript">
	$(document).ready(function() {
		<c:if test="${resultMsg != null}">
			$(function() {
				jsMsgBox(null, "info", "${resultMsg}");
			});
		</c:if>
	});
	
	// 텝 바꾸기
	function openTab(evt, tabid, tabnum){
		var i, content, tablist;
		
		tabcontent=document.getElementsByClassName('tabcon');
		for(i=0; i<tabcontent.length; i++){
			tabcontent[i].style.display = "none"
		}
		document.getElementById(tabid).style.display = "block";
		
		//needs optimization to be shorter 
		if(tabnum == 1){
			$('#tabnum2').removeClass('on');
			$('#tabnum1').addClass('on');
			
		}
		if(tabnum == 2){
			$('#tabnum1').removeClass('on');
			$('#tabnum2').addClass('on');
		}
	}
	
	function getData() {
		var form = document.dataForm;	
		form.df_curr_page.value = 1;
		form.df_method_nm.value = "";
		form.submit(); 
	}
	
	function btn_input_delete(){
		var arr = [];
		var chkedCnt=0;
		$("input:checkbox[name='chk']").each(function(){
			if($(this).is(":checked")){
				chkedCnt++;	
				var data =$(this).parents('tr:eq(0)');
				var targetID = $(data).find('td:eq(1)').text(); 
				arr.push(targetID);		
			}
		});
		
		if(chkedCnt<=0){
			jsMsgBox(null, "info", "체크박스를 선택하고 다시 눌러주세요");
			return;
		} else {
			var form = document.dataForm;
			form.df_method_nm.value = "deleteData";
			form.selectedID.value = arr;
			jsMsgBox(null, "confirm", "정말로 삭제하고 싶습니까?", function(){
				form.submit() 
			});
		}
	}
	
																						//최상단 체크박스 클릭
	function checkAll (){
        var checked = document.getElementById("checkall").value;
        if($("#checkall").prop("checked")){
           																				 //input태그의 name이 chk인 태그들을 찾아서 checked옵션을 true로 정의
            $("input[name=chk]").prop("checked",true);
        }else{
           																				 //input태그의 name이 chk인 태그들을 찾아서 checked옵션을 false로 정의
            $("input[name=chk]").prop("checked",false);
        }
    }
	
</script>
</head>
<body>
<div id="wrap">
    <div class="wrap_inn">
        <div class="contents">
        	<h2 class="menu_title" id="tabtitle">설문관리 정보 삭제 샘플</h2>
        	<div>
        		<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
        			<ap:include page="param/defaultParam.jsp" />
					<ap:include page="param/dispParam.jsp" />
					<ap:include page="param/pagingParam.jsp" />
						
					<input type="hidden" id="init_search_yn" name="init_search_yn" value="N" />
					<input type="hidden" id="selectedID" name="selectedID" />
					
					<table cellpadding="0" cellspacing="0" class="table_search" summary="공통 검색조건으로 기업군 검색년도로 검색하는 표">
                        <colgroup>
                        <col width="15%" />
                        <col width="30%" />
                        <col width="15%" />
                        <col width="40%" />
                        </colgroup>
                        <tr>
                            <th scope="row">제목</th>
                            <td>
                            	<input type = "text" name = "searchValue" />
                            </td>
                        </tr>
                    </table>
                    <div class="btn_page_search">
                    	<p class="btn_src_zone"><a class="btn_search" href="#none" id="btn_search_ok" onclick="getData();"><span>검색</span></a></p>
                    </div>
                	</form>
                	<div class="block" style="margin-top: 20px">
                    <!--// 리스트 -->
                    <div class="list_zone">
                    	<ap:pagerParam />
                    	<div class="btn_page_search">
                			<a class="btn_page_admin" href="#none" id="btn_delete" onclick = "btn_input_delete();"><span id="btnDelete">삭제</span></a>
                		</div> 
                        <table cellpadding="0" cellspacing="0" summary="검색어 기업형태 판정사유 별로 검색조건을 입력하는 표" >
                            <colgroup>
                            <col width="3%" />
	                        <col width="10%" />
	                        <col width="10%" />
	                        <col width="5%" />
	                        <col width="10%" />
	                        <col width="10%" />
	                        <col width="30%" />                             
	                        </colgroup>
                            <thead>
                                <tr>
                                	<th scope="col"><input type="checkbox" id="checkall" onclick="checkAll()" /></th>
                                    <th scope="col">설문제목</th>
                                    <th scope="col">설문목적</th>
                                    <th scope="col">설문대상</th>
                                    <th scope="col">등록일</th>
                                    <th scope="col">수정일</th>
                                    <th scope="col">안내내용</th>
                                </tr>
                            </thead>
                            <tbody>
								<c:forEach items="${resultList}" var="resultInfo" varStatus="status">
								<tr>
									<td><input type="checkbox" name="chk" /></td>
									<td style="display: none">${resultInfo.qestnrId }</td>
									<td>${resultInfo.qustnrSj}</td>
									<td>${resultInfo.qustnrPurps }</td>
									<td>${resultInfo.qustnrTrget }</td>
									<td>${resultInfo.rgsde}</td>
									<td>${resultInfo.updde}</td>
									<td>${resultInfo.qustnrWritngGuidanceCn}</td>									
								</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
                    <!-- 리스트// -->
                    <div class="mgt10"></div>
                	<ap:pager pager="${pager}" />
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
            <div class="tabcon" style="display: block;" id="tab1">
            	<span id="javatabcon">
            		<c:forEach items ="${javaMessage }" var="indMess">
						${indMess }<br><br>
					</c:forEach>
            	</span>
            </div>
               
          	<!-- Tab 2 -->
           	<div class="tabcon" style="display: none;" id="tab2">
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
</div>
<!--content//-->
</body>
</html>