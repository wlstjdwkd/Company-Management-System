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
			search_year: "required",    			
			tarket_date: "required",
			file_miLimit:"required"
			}
			});
	
  	 
	    $('#tarket_date').mask('0000-00-00');
		$('#tarket_date').datepicker({
		    showOn : 'button',
		    defaultDate : 0,
		    buttonImage : '<c:url value="images/acm/icon_cal.png" />',
		    buttonImageOnly : true,
		    changeYear: true,
		    changeMonth: true,
		    yearRange: "-5:+1"
		});
		
	$("#search_year").numericOptions({from:2002,to:${inparam.curr_year},sort:"desc"});
	
	$("#search_year").val(${inparam.stdYy});
});

/*
* 목록 검색
*/
function btn_miLimitmgr_get_list() {

	var form = document.dataForm;
	
	form.df_method_nm.value = "";
	
	if($("#search_year").valid())
			form.submit();
}





function batch_insert_miLimit(){
	
	if(!$("#tarket_date").valid() || !$("#file_miLimit").valid() )
	{
		return false;
	}
	
	$("#df_method_nm").val("updateMiLimit");
	// 폼 데이터
	$("#dataForm").ajaxSubmit({
        url      : "PGDC0030.do",
        dataType : "text",            
        async    : true,
        contentType: "multipart/form-data",
        beforeSubmit : function(){
        },            
        success  : function(response) {
        	try {
        		response = $.parseJSON(response)
        		if(eval(response.result)){
        			jsMsgBox($(this),'info',response.message,btn_miLimitmgr_get_list);
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
function findmiLimitlist(year){
	$.colorbox({
        title : "상호출자제한기업정보",
        href  : "PGDC0030.do?df_method_nm=findmiLimitList&tarket_date="+year,
        width : "80%",
        height: "80%",     
        iframe : true,
        overlayClose : false,
        escKey : false,            
    });
}


function getErrorMsg(date){
	jsMsgBox(null
			,'confirm'
			,Message.msg.confirmSaveTemp
			,function(){
				$.ajax({
			        url      : "PGDC0030.do",
			        type     : "POST",
			        dataType : "text",
			        data     : { df_method_nm: "findErrMsg", tarket_date: date },
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
	);
}

function deletemiLimitlist(year){
	jsMsgBox(null,'confirm',"정말로삭제하시겠습니까?", 
		function(){
			$.ajax({
		        url      : "PGDC0030.do",
		        type     : "POST",
		        dataType : "test",
		        data     : { df_method_nm: "deletemiLimitlist", tarket_date: year },
		        async    : false,                
		        success  : function(response) {
		        	try {
		        		response = $.parseJSON(response)
		        		if(eval(response.result)){
		        			jsMsgBox($(this),'info',response.message,btn_miLimitmgr_get_list);
		        		}else{
		               		jsMsgBox($(this),'info',response.message,btn_miLimitmgr_get_list);
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
                <h2 class="menu_title">상호출자제한기업</h2>
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
                                <th scope="row">조회년도</th>
                                <td><select id="search_year" name="search_year" title="조회년도" style="width:130px">
                                    </select>
                                     <p class="btn_src_zone"><a href="#" class="btn_search" onclick="btn_miLimitmgr_get_list();">조회</a></p></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="search_top2"> <span class="mgt30">※ 업로드 시 첨부된 엑셀파일의 양식을 이용하세요 ( <a href="/download/상호출자제한기업집단_20140301.xls">  상호출자제한기업집단_20140301.xls </a> )</span>
					<h4 class="mgt10">데이터업로드</h4>
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
                                <th scope="row">발표일자</th>
                                <td><input name="tarket_date" title="일자 선택" id="tarket_date" style="width:130px"/> </td>
                                <th scope="row">파일선택</th>
                                <td><input  name="file_miLimit" type="file" id="file_miLimit" style="width:300px;" title="파일첨부" />
                                     <p class="btn_src_zone"><a href="#" class="btn_refresh" onclick="batch_insert_miLimit();">등록</a></p>
                                </td>
  							</tr>
                        </tbody>
                    </table>
                </div>
                <div class="block2">
                    <!--// 리스트 -->
                    <div class="list_zone">
                        <table cellspacing="0" border="0" summary="수집작업목록">
                        <caption>
							상호출자제한기업 수집작업 리스트
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
                                <th scope="col">발표일자</th>
                                <th scope="col">데이터건수</th>
                                <th scope="col">DB load 성공건수</th>
                                <th scope="col">DB load 실패건수</th>
                                <th scope="col">상태</th>
                                <th scope="col">수집일시(수행시간)</th>
                                <th scope="col">실행</th>
                            </tr>
                        </thead>
                        <tbody>
                         <c:choose>
							   	<c:when test="${fn:length(stockMgrList) > 0}">
								  	<c:forEach items="${stockMgrList}" var="info" varStatus="status">    
								  	 <tr>   
								  	 	<td><a href="#" onclick="findmiLimitlist('${info.stdYy}${info.stdYm}${info.stdYd}');">${info.stdYy}-${info.stdYm}-${info.stdYd}</a></td>
								  	 	<td class="tar"><fmt:formatNumber value = "${info.rcdCnt}" pattern = "#,##0"/></td>
										<td class="tar"><fmt:formatNumber value = "${info.successCnt}" pattern = "#,##0"/></td>
										<td class="tar"><fmt:formatNumber value = "${info.failCnt}" pattern = "#,##0"/></td>	
										<td><c:if test="${info.proSatus == '오류'}"><a href="#" onclick="getErrorMsg('${info.stdYy}','${info.stdMt}');"></c:if>${info.proSatus}<c:if test="${info.proSatus == '오류'}"></a></c:if></td>
										<td>${info.runTm}<c:if test="${info.diffMin != '' || info.diffMin ne null}">( ${info.diffMin} 분  ${info.diffSec}초 )  </c:if></td>	
										<td><div class="btn_inner"><c:if test="${info.proSatus != '시작'}"> <a href="#" class="btn_in_gray" onclick="deletemiLimitlist('${info.stdYy}${info.stdYm}${info.stdYd}');"><span>삭제</span></a></c:if></div></td>
									</tr>
									</c:forEach>
								</c:when>
							   	<c:otherwise>
							   		<tr>
							   		<td colspan="7" style="text-align:center;"> 해당년도 상호출자제한기업 수집내역이 없습니다.</td>
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
				    		<span id="load_msg">상호출자제한기업 정보를 등록하고 있습니다. 잠시만 기다려주십시오.</span>
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