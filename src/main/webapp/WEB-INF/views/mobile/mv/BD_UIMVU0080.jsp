<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
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
<title>고객지원</title>
<ap:jsTag type="web" items="jquery,tools,ui" />
<ap:jsTag type="tech" items="util,mv,cs" />
<script type="text/javascript">
	var listLength = "${inparam.cnt}";
	
	$(document).ready(function() {
		
		// 게시글 수가 10개 이상일때 더보기 표시
		if(listLength < 10) {
			$('.btn_ft').hide();
		} else {
			$('.btn_ft').show();
		}
		
		// 더보기
		$("#btn_more").click(function() {
			$("#ad_moreList").val("MORE");
			
			$.ajax({
                url      : "PGMV0080.do",
                type     : "POST",
                dataType : "json",
                data     : { df_method_nm	: "index"
                			,"ad_moreList"	: $('#ad_moreList').val()
                			,"ad_limitFrom" : $('#ad_limitFrom').val()
                			,"search_jssfc" : $('#search_jssfc').val()
                			,"search_zone" : $('#search_zone').val()
                			,"ad_ajax"		: "Y"
                		   },                
                async    : false,                
                success  : function(response) {
                	try {
                        if(response.result) {
                        	for(var i=0; i< (response.value).length; i++) {
//                        		$('.job_list').append('<dl><dt><a href="#none" onclick="fn_empmn_info(' + response.value[i].EMPMN_MANAGE_NO + ',' + response.value[i].EP_NO +')">'+response.value[i].EMPMN_SJ+'</a></dt><dd class="pl0">'+response.value[i].ENTRPRS_NM+'</dd><dd>'+response.value[i].JSSFC+'</dd><dd>'+CODE_NM+'</dd><dd>'+response.value[i].RCRIT_END_DE+'</dd></dl>');
                        		
                        		var code1 = "";
                        		if(response.value[i].WANTED_AUTH_NO.substring(0, 1) != "K") {
                        			if(response.value[i].WANTED_AUTH_NO.trim() == "") {
                        				code1 = "<a href=\"#none\" onclick=\"fn_empmn_info('" + response.value[i].EMPMN_MANAGE_NO + "', '" + response.value[i].EP_NO + "')\">" + response.value[i].EMPMN_SJ + "</a>";
                        			} else {
                        				code1 = "<a href=\"#none\" onclick=\"fn_move_weburl('" + response.value[i].ECNY_APPLY__WEB_ADRES + "')\">" + response.value[i].EMPMN_SJ + "</a>";
                        			}
                        		} else {
                        			code1 = "<a href=\"#none\" onclick=\"fn_empmn_info('" + response.value[i].EMPMN_MANAGE_NO + "', '" + response.value[i].EP_NO + "')\">" + response.value[i].EMPMN_SJ + "</a>";
                        		}
                        		
                        		var code2 = "";
                        		if(response.value[i].ENTRPRS_VW_AT == "Y") {
                        			code2 = "<a href=\"#none\" onclick=\"fn_cmpny_info('" + response.value[i].BIZRNO + "', '" + response.value[i].USER_NO + "')\">" + response.value[i].ENTRPRS_NM + "</a>";
                        		} else {
                        			code2 = response.value[i].ENTRPRS_NM;
                        		}
                        		
                        		var codeNm = "";
                        		for(var j=0; j< (response.value[i].iem25).length; j++) {
                        			if(j != 0) {
                        				codeNm += ",";
                        			}
                        			if(response.value[i].iem25[j].IEM_VALUE != 'WKN') {
                        				codeNm += response.value[i].iem25[j].CODE_NM;
                        				if(response.value[i].iem25[j].CODE_NM == '') {
                        					codeNm += response.value[i].CAREER_DETAIL_RQISIT2;
                        				}
                        			} else {
                        				codeNm += response.value[i].iem25[j].ATRB3;
                        			}
                        		}
                        		
                        		var code3 = "";
                        		for(var k=0; k< (response.value[i].ChartrList).length; k++) {
                        			code3 += "<dd>";
                        			if(response.value[i].ChartrList[k].CHARTR_CODE == "1") {
                        				code3 += "<span class=\"ico_k\"></span>";
                        			} else if(response.value[i].ChartrList[k].CHARTR_CODE == "2") {
                        				code3 += "<span class=\"ico_w\"></span>";
                        			} else if(response.value[i].ChartrList[k].CHARTR_CODE == "3") {
                        				code3 += "<span class=\"ico_a\"></span>";
                        			} else if(response.value[i].ChartrList[k].CHARTR_CODE == "4") {
                        				code3 += "<span class=\"ico_c\"></span>";
                        			} else if(response.value[i].ChartrList[k].CHARTR_CODE == "5") {
                        				code3 += "<span class=\"ico_d\"></span>";
                        			}
                        			code3 += "</dd>";
                        		}
                        		
                        		var codeJassfc = "";
                        		if(response.value[i].JSSFC != null) {
                        			codeJassfc = response.value[i].JSSFC;
                        		}
                        		
                        		var codeRcritEndDe = "";
                        		if(response.value[i].RCRIT_END_DE != null) {
                        			codeRcritEndDe = response.value[i].RCRIT_END_DE;
                        		}
                        		
                        		var resultCode = "";
                        		resultCode += "<dl>";
                        		resultCode += "<dt>" + code1 + "</dt>";
                        		resultCode += "<dd class=\"p10\">" + code2 + "</dd>";
                        		resultCode += "<dd>" + codeJassfc + "</dd>";
                        		resultCode += "<dd>" + codeNm + "</dd>";
                        		resultCode += "<dd>" + codeRcritEndDe + "</dd>";
                        		resultCode += "<dt>" + code3 + "</dt>";
                        		resultCode += "</dl>";
                        		
                        		$('.job_list').append(resultCode);
                        	}
                        	
                        	var paramLimitTo = response.value[0].paramLimitTo;
                        	$('#ad_limitFrom').val(paramLimitTo);
                        	
                        	if(paramLimitTo > listLength-1) {
                        		$('.btn_ft').hide();
                        	}
                        } else {                        	 
                        	return;
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
		
	});
	
	// 워크넷 페이지 오픈
	var fn_move_weburl = function(url) {
		window.open(url,"_blank");
	};
	
	function fn_empmn_info(empmnManageNo, userNo) {
		document.getElementById("df_method_nm").value = "empmnInfoForm";
		document.getElementById("ad_empmnManageNo").value = empmnManageNo;
		document.getElementById("ad_userNo").value = userNo;
		document.dataForm.submit();
	}

	function fn_cmpny_info(bizrNo, userNo) {
		document.getElementById("df_method_nm").value = "cmpnyInfoForm";
		document.getElementById("ad_bizrNo").value = bizrNo;
		document.getElementById("ad_userNo").value = userNo;
		document.dataForm.submit();
	}
	
	function changeSelect() {
		document.getElementById("ad_moreList").value = "";
		document.getElementById("df_method_nm").value = "";		
		document.dataForm.submit();
	}
</script>
</head>

<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<input type="hidden" name="ad_moreList" id="ad_moreList" /> 
		<input type="hidden" name="ad_limitFrom" id="ad_limitFrom" value='${inparam.limitTo}' />
		<input type="hidden" name="ad_empmnManageNo" id="ad_empmnManageNo" /> 
		<input type="hidden" name="ad_userNo" id="ad_userNo" /> 
		<input type="hidden" name="ad_bizrNo" id="ad_bizrNo" /> 

		<!--//내용영역-->
		<section class="notice">
			<div class="sub_con">
				<div class="tit_page">다양한 기업 정보의 소식을 전합니다.</div>
				<div>
					<dl>
					<dd>
					직종 : 
			    		<select name="search_jssfc" id="search_jssfc" style="width:100px;" onchange="changeSelect();">
							<option value="">직종</option>
							<c:forEach items="${jssfcLargeList}" var="list" varStatus="status">
								<option value="${list.CODE}"
									<c:if test="${list.CODE == param.search_jssfc}"> selected=="selected"</c:if>>${list.CODE_NM }</option>
							</c:forEach>
			    	    </select>
					&nbsp;&nbsp;&nbsp;&nbsp;
					지역 : 
						<select name="search_zone" id="search_zone" style="width:100px; vertical-align: top;" onchange="changeSelect();">
							<option value="">지역전체</option>
							<c:forEach items="${abrvList}" var="abrv" varStatus="status">
								<option value="${abrv.code}"
									<c:if test = "${abrv.code == param.search_zone}"> selected="selected" </c:if>>${abrv.codeNm}</option>
							</c:forEach>
						</select> 
					</dd>
					</dl>
				</div>
				<div class="job_list">
					<c:forEach items="${empmnPblancInfo}" var="info" varStatus="status">
						<dl>
						<dt>
							<c:if test="${fn:substring(info.WANTED_AUTH_NO, 0, 1) != 'K'}">			<!-- 워크넷 자체 데이터가 아니라면 상세정보가 없으므로 링크 -->
                        		<c:choose>
									<c:when test="${fn:trim(info.WANTED_AUTH_NO) == ''}">   			<!-- 워크넷 자체 데이터가 아니라도 직접 입력했다면 팝업 -->
						     			<a href="#none" onclick="fn_empmn_info('${info.EMPMN_MANAGE_NO }', '${info.EP_NO}')">${info.EMPMN_SJ}</a>
						    		</c:when>
									<c:otherwise>          												<!-- 워크넷 자체 데이터가 아니라면 상세정보가 없으므로 링크 -->
						 				<a href="#none" onclick="fn_move_weburl('${info.ECNY_APPLY__WEB_ADRES }')">${info.EMPMN_SJ}</a>
									</c:otherwise>
								</c:choose>
                 			</c:if>
           					<c:if test="${fn:substring(info.WANTED_AUTH_NO, 0, 1) == 'K'}">
            					<a href="#none" onclick="fn_empmn_info('${info.EMPMN_MANAGE_NO }', '${info.EP_NO}')">${info.EMPMN_SJ}</a>
            				</c:if>
						</dt>
						<dd class="pl0">
							<c:if test="${info.ENTRPRS_VW_AT == 'Y'}"><a href="#none" onclick="fn_cmpny_info('${info.BIZRNO }', '${info.USER_NO}')">${info.ENTRPRS_NM}</a> </c:if>
							<c:if test="${info.ENTRPRS_VW_AT != 'Y'}">${info.ENTRPRS_NM}</c:if>
						</dd>
						<dd>${info.JSSFC}</dd>
						<dd>
							<c:forEach items="${info.iem25 }" var="iem25" varStatus="status">
								<c:if test="${not status.first }">,</c:if>
								<c:choose>
									<c:when test="${iem25.IEM_VALUE != 'WKN' }">${iem25.CODE_NM }<c:if test="${iem25.CODE_NM == '' }">${info.CAREER_DETAIL_RQISIT2}</c:if></c:when>
									<c:otherwise>${iem25.ATRB3}</c:otherwise>
		                        </c:choose>
							</c:forEach>
						</dd>
						<dd>${info.RCRIT_END_DE}</dd>
						<dt>
							<c:forEach items="${info.ChartrList}" var="chartrlist" varStatus="status">
							<dd>
							<c:if test="${chartrlist.CHARTR_CODE == '1'}">
                 				<span class="ico_k"></span>
                 			</c:if>	
                 			<c:if test="${chartrlist.CHARTR_CODE == '2'}">
                 				<span class="ico_w"></span>
                 			</c:if>
                			<c:if test="${chartrlist.CHARTR_CODE == '3'}">
               					<span class="ico_a"></span>
                			</c:if>
                 			<c:if test="${chartrlist.CHARTR_CODE == '4'}">
                 				<span class="ico_c"></span>
                 			</c:if>
                 			<c:if test="${chartrlist.CHARTR_CODE == '5'}">
                 				<span class="ico_d"></span>
                 			</c:if>
							</dd>
							</c:forEach>
						</dt>
						</dl>
					</c:forEach>
				</div>
				<div class="btn_ft">
					<a href="#none" id="btn_more" class="btn_more">더보기<span class="bul"></span></a>
				</div>
			</div>
		</section>
		<!--내용영역//-->
</body>
</html>