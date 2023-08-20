<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>환율정보관리|정보</title>	
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask,selectbox" />
<ap:jsTag type="tech" items="acm,msg,util" />
<script type="text/javascript">
<c:if test="${resultMsg != null}">
	$(function(){
		jsMsgBox(null, "info", "${resultMsg}");
	});
</c:if>

$(document).ready(function(){
	
  	 $("#dataForm").validate({  
			rules : {
			from_year: "required",    
			to_year: "required",    
			tarket_year: "required",
			}
			});
	
	$("#from_year").numericOptions({from:2002,to:${inparam.curr_year},sort:"desc"});
	$("#to_year").numericOptions({from:2002,to:${inparam.curr_year},sort:"desc"});
	$("#tarket_year").numericOptions({from:2002,to:${inparam.before_year},sort:"desc"});
	
	$("#from_year").val(${inparam.fromstdYy});
	$("#to_year").val(${inparam.tostdYy});
});

/*
* 목록 검색
*/
function btn_fxermgr_get_list() {

	var form = document.dataForm;
	
	form.df_method_nm.value = "";
	
	if($("#from_year").valid()  && $("#to_year").valid())
			form.submit();
}


function btn_refesh_fxer()
{
	if(!$("#tarket_year").valid() )
	{
		return false;
	}
	
	batch_refesh_fxer($("#tarket_year option:selected").val())
}


function batch_refesh_fxer( year){
	$.ajax({
        url      : "PGDC0040.do",
        type     : "POST",
        dataType : "text",
        data     : { df_method_nm: "updatefxer", tarket_year: year },
        async    : false,                
        success  : function(response) {
        	try {
        		response = $.parseJSON(response)
        		if(eval(response.result)){
        			jsMsgBox($(this),'info',response.message,btn_fxermgr_get_list);
        		}else{
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
}

//기준년월 수집 주가정보
function findfxerlist(year){
	$.colorbox({
        title : "기준년도 수집 환율정보",
        href  : "PGDC0040.do?df_method_nm=findfxerList&from_year="+year+"&to_year="+year,
        width : "80%",
        height: "80%",     
        iframe : true,
        overlayClose : false,
        escKey : false,            
    });
}


function getErrorMsg(year){
	$.ajax({
        url      : "PGDC0040.do",
        type     : "POST",
        dataType : "text",
        data     : { df_method_nm: "findErrMsg", tarket_year: year },
        async    : false,                
        success  : function(response) {
        	try {
    			response = $.parseJSON(response)
    			jsMsgBox($(this),'info',response.message)
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

function deletefxerlist(year){
	
	jsMsgBox(null,'confirm',"정말로삭제하시겠습니까?", 
	function(){
		$.ajax({
	        url      : "PGDC0040.do",
	        type     : "POST",
	        dataType : "text",
	        data     : { df_method_nm: "deletefxerlist", tarket_year: year },
	        async    : false,                
	        success  : function(response) {
	        	try {
	        		response = $.parseJSON(response)
	        		if(eval(response.result)){
	        			jsMsgBox($(this),'info',response.message,btn_fxermgr_get_list);
	        		}else{
	               		jsMsgBox($(this),'info',response.message,btn_fxermgr_get_list);
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

	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
    <!-- 좌측영역 //-->
    <!--//content-->
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">환율정보</h2>
                <!-- 타이틀 영역 //-->
                <div class="search_top">
                    <table cellpadding="0" cellspacing="0" class="table_search" summary="조회 조건">
                        <caption>
                        조회 조건
                        </caption>
                        <colgroup>
                        <col width="15%" />
                        <col width="*" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">기준년도</th>
                                <td><select name="from_year" title="일자 선택" id="from_year" style="width:80px">
                                    </select>
                                    ~
                                    <select name="to_year" title="일자 선택" id="to_year" style="width:80px">
                                    </select>
                                     <p class="btn_src_zone"><a href="#" class="btn_search" onclick="btn_fxermgr_get_list();">조회</a></p></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="search_top2"> <span class="mgt30">※ 자료출처 : 외환은행  년평균 최초고시 환율 </span>
                    <h4 class="mgt10">환율수집</h4>
                    <table cellpadding="0" cellspacing="0" class="table_search2" summary="수집조건">
                        <caption>
                        수집조건
                        </caption>
                        <colgroup>
                        <col width="15%">
                        <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">대상년도</th>
                                <td><select name="tarket_year" title="선택" id="tarket_year" style="width:130px">
                                    </select>                    
 									<p class="btn_src_zone"><a href="#" class="btn_refresh" onclick="btn_refesh_fxer();">수집</a></p></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="block2">
                    <!--// 리스트 -->
                    <div class="list_zone">
                        <table cellspacing="0" border="0" summary="수집작업목록">
                        <caption>
							주가정보 수집작업 리스트
                        </caption>
                        <colgroup>
                        <col width="*" />
                        <col width="*" />
                        <col width="*" />
                        <col width="*" />
                        <col width="*" />
                        <col width="*" />
                        <col width="*" />
                        </colgroup>
                        <thead>
                            <tr>
                                    <th scope="col">기준년도</th>
                                    <th scope="col">DB load 성공건수</th>
                                    <th scope="col">DB load 실패건수</th>
                                    <th scope="col">대상국가</th>
                                    <th scope="col">상태</th>
                                    <th scope="col">수집일시(수행시간)</th>
                                    <th scope="col">실행</th>
                            </tr>
                        </thead>
                        <tbody>
                         <c:choose>
							   	<c:when test="${fn:length(fxerMgrList) > 0}">
								  	<c:forEach items="${fxerMgrList}" var="info" varStatus="status">    
								  	 <tr>   
								  	 	<td><a href="#" onclick="findfxerlist('${info.stdYy}');">${info.stdYy}</a></td>
										<td class="tar"><fmt:formatNumber value = "${info.successCnt}" pattern = "#,##0"/></td>
										<td class="tar"><fmt:formatNumber value = "${info.failCnt}" pattern = "#,##0"/></td>	
										<td class="tar"><a href="#" onclick="findfxerlist('${info.stdYy}');"><fmt:formatNumber value = "${info.rcdCnt}" pattern = "#,##0"/></a></td>
										<td><c:if test="${info.proSatus == '오류'}"><a href="#" onclick="getErrorMsg('${info.stdYy}','${info.stdMt}');"></c:if>${info.proSatus}<c:if test="${info.proSatus == '오류'}"></a></c:if></td>
										<td>${info.runTm}<c:if test="${info.diffMin != '' || info.diffMin ne null}">( ${info.diffMin} 분  ${info.diffSec}초 )  </c:if></td>	
										<td><div class="btn_inner"><c:if test="${info.proSatus != '시작'}"> <a href="#" class="btn_in_gray" onclick=" batch_refesh_fxer('${info.stdYy}')"><span>재작업</span></a> <a href="#" class="btn_in_gray" onclick="deletefxerlist('${info.stdYy}');"><span>삭제</span></a></c:if></div></td>
									</tr>
									</c:forEach>
								</c:when>
							   	<c:otherwise>
							   		<tr>
							   		<td colspan="7" style="text-align:center;"> 해당년도 환율정보 수집내역이 없습니다.</td>
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

</body>
</html>