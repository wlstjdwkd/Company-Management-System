<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@	taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>상호출자제한기업관리|정보</title>	
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,blockUI,msgBoxAdmin,colorboxAdmin,mask,selectbox" />
<ap:jsTag type="tech" items="acm,msg,util,etc" />
<script type="text/javascript">
<c:if test="${resultMsg != null}">
	$(function(){
		jsMsgBox(null, "info", "${resultMsg}");
	});
</c:if>

$(document).ready(function(){
	
	// 로딩 화면
	$(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);	
	
	
  	 $("#dataForm").validate({  
			rules : {
			tarket_year: "required"    			
			}
			});
  	 
	$("#tarket_year").numericOptions({from:2002,to:${inparam.curr_year},sort:"desc"});
	
	$("#tarket_year").val(${inparam.stdYy});
});

/*
* 목록 검색
*/
function btn_entInfomgr_get_list() {

	var form = document.dataForm;
	
	form.df_method_nm.value = "";
	
	if($("#tarket_year").valid())
			form.submit();
}


function batch_insert_entInfo(year){
	
	jsMsgBox(null
			,'confirm'
			,"수집년도 [${inparam.pre_year}]년</br>수집실행을 수행하시겠습니까?"
			,function(){
				$.ajax({
			        url      : "PGDC0020.do",
			        type     : "POST",
			        dataType : "text",
			        data     : { df_method_nm: "insertentInfo",tarket_year: year },
			        async    : true,                
			        success  : function(response) {
			        	try {
			        		response = $.parseJSON(response)
			        		if(response.result) {
			            		jsMsgBox($(this),'info',response.message,btn_entInfomgr_get_list);

			                } else {
			                	jsMsgBox($(this),'info',response.message);
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
			});
}

</script>
</head>
<body>

	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post" enctype="multipart/form-data">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
    <!-- 좌측영역 //-->
    <!--//content-->
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">신용평가사연동</h2>
                <!-- 타이틀 영역 //-->
                <div class="search_top">
                    <table cellpadding="0" cellspacing="0" class="table_search" summary="조회 조건">
                        <caption>조회 조건</caption>
                        <colgroup>
                        	<col width="10%" />
                        	<col width="*" />
                        </colgroup>
                        <tbody>
                        	<tr>
                        		<th scope="row">수집년도</th>
                        		<td>
                        			<select name="tarket_year" title="년도선택" id="tarket_year" style="width:80px"></select>
                            		<p class="btn_src_zone"><a href="#" class="btn_search"  onclick="btn_entInfomgr_get_list();">조회</a></p>
                        		</td>
                        	</tr>
                        </tbody>
                    </table>
                </div>
                <div class="block">
                    <ul>
                        <li class="d1">수집대상 :  직전년도에 수집됐던 기업  + 확인서 발급기업 + 상호출자제한기업집단 + 년매출 50억 이상기업<div class="btn_inner" style="margin-left:30px"><a href="#" class="btn_in_gray" onclick="batch_insert_entInfo('${inparam.pre_year}');"><span>[${inparam.pre_year}]수집실행</span></a></div><br />
 - 분기별로 자동 수집 됩니다. 필요 시 만 수동 수집하세요.<br />
 - 데이터 요청 후 수집까지 약 4~5일 소요됩니다.</li>
                    </ul>
                </div>
                <div class="block2">
                    <!--// 리스트 -->
                    <div class="list_zone">
                    
                        <table cellspacing="0" border="0" summary="신용평가사 수집작업목록">
                            <caption>
                            신용평가사 수집작업목록
                            </caption>
                            <colgroup>
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">기준년도</th>
                                    <th scope="col">요청일자</th>
                                    <th scope="col">수집일자</th>
                                    <th scope="col">기업수(요청/수집)</th>
                                    <th scope="col">개황</th>
                                    <th scope="col">재무</th>
                                    <th scope="col">출자/피출자</th>
                                    <th scope="col">거래처</th>
                                    <th scope="col">상태</th>
                                </tr>
                            </thead>
                            <tbody>
 		                          <c:choose>
									   	<c:when test="${fn:length(entInfoMgrList) > 0}">
										  	<c:forEach items="${entInfoMgrList}" var="info" varStatus="status">    
										  	 <tr>   
										  	 	<td>${info.stdYy}</td>
										  	 	<td>${info.reqDe}</td>
												<td>${info.colctDe}</td>
												<td class="tar"><fmt:formatNumber value="${info.transCnt}" groupingUsed="true"/></td>	
												<td class="tar"><fmt:formatNumber value = "${info.entInfCnt}" pattern = "#,##0"/></td>	
												<td class="tar"><fmt:formatNumber value = "${info.fnCnt}" pattern = "#,##0"/></td>	
												<td class="tar"><fmt:formatNumber value = "${info.invCnt}" pattern = "#,##0"/></td>	
												<td class="tar"><fmt:formatNumber value = "${info.bcncCnt}" pattern = "#,##0"/></td>	
												<td>${info.proSatus}</td>
											</tr>
											</c:forEach>
										</c:when>
									   	<c:otherwise>
									 	<tr>
							   				<td colspan="9" style="text-align:center;"> 수집년도 신용평가사 수집내역이 없습니다.</td>
							   			</tr>
								   		</c:otherwise>
								</c:choose>
                        </tbody>
                        </table>
                    </div>
                    <!-- 리스트// -->
                </div>
                <!--리스트영역 //-->
            </div>
        </div>
        </div>
        </form>
        <!--content//-->
        <!-- loading -->
		<div style="display:none">
			<div class="loading" id="loading">
				<div class="inner">
					<div class="box">
				    	<p>
				    		<span id="load_msg">신용평가사  정보를 요청하고 있습니다. 잠시만 기다려주십시오.</span>
				    		<br />
							시스템 상태에 따라 최대 10분 정도 소요될 수 있습니다.
						</p>
						<span><img src="<c:url value="/images/etc/loading_bar.gif" />" width="323" height="39" alt="loading" /></span>
					</div>
				</div>
			</div>
		</div>
        
</body>
</html>