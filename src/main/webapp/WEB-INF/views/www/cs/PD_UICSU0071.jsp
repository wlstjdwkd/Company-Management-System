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
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<%-- <ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox,blockUI,flot" />
<ap:jsTag type="tech" items="msg,util,ucm,cs,pc" /> --%>
<ap:jsTag type="web" items="jquery, form,validate,notice,msgBox,mask,colorbox,blockUI,flot" />
<ap:jsTag type="tech" items="msg,util,cmn , mainn, subb, font" />
<script type="text/javascript">

var preloadCover = 100;
function hidePreload() {
  if (preloadCover == 0) {
    preload.style.visibility = "hidden";
    return;
  } else {
    preloadCover -= 5;
    preload.style.height = String(preloadCover) + "%";
    setTimeout("hidePreload()", 0);
  }
}
function makePreload(msg) {
  document.write("<div id=\"preload\" style=\"",
    "position:absolute;top:0;left:0;width:100%;height:100%;",
    "background-color:white;color:black;",
    "text-align:center;z-index:1\">",
    "<table border=0 height=100% cellspacing=0 cellpadding=0><tr><td align='center'>",
    msg,
    "</td></tr></table>",
    "</div>");
}
makePreload("<div class='loading' id='loading_layer'><div class='inner'><div class='box'><p><span id='load_msg'>기업정보를 요청하고 있습니다. 잠시만 기다려주십시오.</span><br />시스템 상태에 따라 최대 3분 정도 소요될 수 있습니다.</p><span><img src='<c:url value='/images/etc/loading_bar.gif' />' width='323' height='39' alt='loading' /></span></div></div></div>");

self.onload=hidePreload;




var labrrDatas = ${labrrDatas};		//근로자수
var selngDatas = ${selngDatas};		//매출액
var caplDatas = ${caplDatas};		//자본금
var assetsDatas = ${assetsDatas};	//자산총액

$(document).ready(function(){
	// 로딩 화면
	$(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);	
	
	<c:if test="${dataMap.DTL_VW_AT == 'Y' }">
	setMainIndex();
	// 주요 통계 지표 툴팁 
	$("#placeholder").UseTooltip();
	</c:if>
}); // ready

//주요지표현황
function setMainIndex(){
	
	var data = [];
	
	// chart
    var options = {
    	lines: {
    		show: true
    	},
    	points: {
    		show: true
    	}, 
    	legend : {
			show : false
		},   		
    	xaxis: {
    		tickDecimals: 0,
    		tickSize: 1    		
    	}, 
    	valueLabels : {
			show : true
		},
    	grid: {
    		hoverable: true, 
			clickable: false, 
			mouseActiveRadius: 30,
			borderWidth : 0.2
    	},
    	yaxes: [
			{				
				  },
			{position: "right",
			    axisLabel: "명"
			 }
		]
    };
	
    var series1 = {
    	"label": "매출액",
        "data": selngDatas,
        color : "#014379"
    };
    var series2 = {
    	"label": "자본금",
        "data": caplDatas,
        color : "#015ca5"
    };
    var series3 = {
    	"label": "자산총액",
        "data": assetsDatas,
        color : "#1c8bd6"
    };
    var series4 = {
    	"label": "근로자수",
        "data": labrrDatas,
        yaxis: 2,
        color : "#00bfd0"
    };
    
    data.push(series1);
    data.push(series2);
    data.push(series3);
    data.push(series4);
    
	if(${existChartData}) {
    	$.plot("#placeholder", data, options);
	}
    
}

$.fn.UseTooltip = function () {
    var previousPoint = null;
     
    $(this).bind("plothover", function (event, pos, item) {         
        /* if (item) {
            if (previousPoint != item.dataIndex) {
                previousPoint = item.dataIndex;
 
                $("#tooltip").remove();
                 
                var x = item.datapoint[0];
                var y = item.datapoint[1];                
                 
                showTooltip(item.pageX, item.pageY,
                  x + "<br/>" + "<strong>" + y + "</strong> (" + 
                  item.series.label + ")");
            }
        }
        else {
            $("#tooltip").remove();
            previousPoint = null;
        } */
        if (item) { 
        	if (previousPoint != item.datapoint) {
				previousPoint = item.datapoint;
				$("#tooltip").remove();
				var x = item.datapoint[0], y = item.datapoint[1];
	
				showTooltip(item.pageX, item.pageY, x+ "년 " + y + "("+ item.series.label + ")");
			}
		} else {
			$("#tooltip").remove();
			previousPoint = null;
		}
    });
}

//툴팁
function showTooltip(x, y, contents) {	
	$('<div id = "tooltip" style = "z-index: 999;">' +contents +' </div>').css( {
        position: 'absolute',
        display: 'none',
        top: y  - 40,
        left: x - 120 ,
        border: '1px solid #fdd',
        padding: '2px',
        'background-color': '#fee',
        opacity: 0.80,
    }).appendTo("body").show();
}

var wc300_popup = function() {
	window.open("/popup/wc300Popup.html","event20150825","width=390,height=660, left=10, top=24, scrollbars=no, resizable=no");	
};

var atc_popup = function() {
	window.open("/popup/atcPopup.html","event20150825","width=390,height=660, left=10, top=24, scrollbars=no, resizable=no");	
};

</script>

</head>
<body>

	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">

		<ap:include page="param/defaultParam.jsp" />
		<%-- <ap:include page="param/dispParam.jsp" /> --%>
		<ap:include page="param/pagingParam.jsp" />

		<div class="view_zone">
			<table class="table_view">
				<caption>채용정보 상세보기</caption>
				<colgroup>
					<col style="width: *" />
					<col style="width: 8%" />
					<col style="width: 25%" />
					<col style="width: 8%" />
					<col style="width: 25%" />
				</colgroup>
				<tbody>
					<tr>
						<td class="none" rowspan="6">
							<ul style="width: 100%">
								<li class="tac mb10">
									<c:choose>
                        				<c:when test="${not empty dataMap.LOGO_FILE_SN }">	      								
	      									<img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${dataMap.LOGO_FILE_SN}" />" style="width:250px" alt="smba" title="smba"/>
		                    	    	</c:when>
                        			<c:otherwise>
                        				<img src="<c:url value="/images/cs/logo.png"/>" id="img_photo" alt="로고"/>
                        			</c:otherwise>
                        			</c:choose>
                        		</li>
							</ul>
						</td>
						<th scope="col">기업명</th>
						<td>${dataMap.ENTRPRS_NM }</td>
						<th scope="col">대표자</th>
						<td>${dataMap.RPRSNTV_NM }</td>
					</tr>
					<tr>
						<th scope="col">상장여부</th>
						<td>${dataMap.LST_AT_NM }</td>
						<th scope="col">기업형태</th>
						<td>${dataMap.ENTRPRS_STLE_NM }</td>
					</tr>
					<tr>
						<th scope="col">기업인증</th>
						<td colspan="3">${dataMap.ENTRPRS_CRTFC_NM }</td>
					</tr>
					<tr>
						<th scope="col">기업특성</th>
						<td colspan="3">
							<c:forEach items="${chartr}" var="chartr" varStatus="status">
							<c:if test="${chartr.CHARTR_CODE == '1'}">
                 				<span class="ico_k">${chartr.CHARTR_NM}</span>
                 			</c:if>	
                 			<c:if test="${chartr.CHARTR_CODE == '2'}">
                 				<a href="#none" onclick="wc300_popup();"><span class="ico_w">${chartr.CHARTR_NM}</span></a>
                 			</c:if>
                 			<c:if test="${chartr.CHARTR_CODE == '3'}">
                 				<a href="#none" onclick="atc_popup();"><span class="ico_a">${chartr.CHARTR_NM}</span></a>
                 			</c:if>
                 			<c:if test="${chartr.CHARTR_CODE == '4'}">
                 				<span class="ico_c"></span>${chartr.CHARTR_NM}
                 			</c:if>
                 			<c:if test="${chartr.CHARTR_CODE == '5'}">
                 				<span class="ico_d"></span>${chartr.CHARTR_NM}
                 			</c:if>
							</c:forEach>
						</td>
					</tr>
					<!-- 
					<tr>
						<th scope="col">이메일</th>
						<td colspan="3">${dataMap.CHARGER_EMAIL }</td>
					</tr>
					//  -->
					<tr>
						<th scope="col">전화번호</th>
						<td>${dataMap.TELNO1 }-${dataMap.TELNO2 }-${dataMap.TELNO3 }</td>
						<th scope="col">팩스번호</th>
						<td>${dataMap.FXNUM1 }-${dataMap.FXNUM2 }-${dataMap.FXNUM3 }</td>
					</tr>
					<tr>
						<th scope="col">홈페이지</th>
						<td><a href="${dataMap.HMPG }" target="_blank">${dataMap.HMPG }</a></td>
						<th scope="col">주소</th>
						<td>(${fn:substring(dataMap.HEDOFC_ZIP, 0, 3)}-${fn:substring(dataMap.HEDOFC_ZIP, 3, 6)}) &nbsp; ${dataMap.HEDOFC_ADRES }</td>
					</tr>
				</tbody>
			</table>
		</div>

		<c:if test="${dataMap.DTL_VW_AT == 'Y' }">
		<div class="detail_zone">			
				<div class="detail_left">
					<h4 class="mb10">상세정보</h4>
					<table class="table_view">
						<caption>채용정보 상세보기</caption>
						<colgroup>
							<col style="width: 30%" />
							<col style="width: 70%" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="col">설립일자</th>
								<td>${dataMap.FOND_DE }</td>
							</tr>
							<tr>
								<th scope="col">상장일</th>
								<td>${dataMap.LST_DE }</td>
							</tr>
							<tr>
								<th scope="col">업종</th>
								<td>${dataMap.INDUTY_NM }</td>
							</tr>
							<tr>
								<th scope="col">주생산품</th>
								<td>${dataMap.MAIN_PRODUCT }</td>
							</tr>
						</tbody>
					</table>
				</div>
			<%-- </c:if> --%>

			<%-- <c:if test="${dataMap.IND_VW_AT == 'Y' }"> --%>
				<div class="detail_right">
					<h4 class="mb10">기업 주요 지표 현황</h4>
					<!-- <div style="width:100%; height:170px; background-color:#CCC">지표현황그래프영역</div> -->
					<div id="placeholder" style="width: 100%; height: 300px;"></div>
					<div class="remark" style="text-align: left">
						<ul style="width: 550px">
							<li class="remark1">매출액(백만)</li>
							<li class="remark2">자본금(백만)</li>
							<li class="remark3">자산총액(백만)</li>
							<li class="remark4">근로자수(명)</li>
						</ul>
					</div>

				</div>			
		</div>
		</c:if>

		<!--//페이지버튼-->
		<!-- <div class="btn_page dot1" style="clear:both"> <a class="btn_page_blue" href="#"><span>채용공고보기</span></a> </div> -->
		<!--페이지버튼//-->
		<c:if test = "${not empty dataMap.LAYOUT_TY}" >
			<c:if test = "${dataMap.LAYOUT_TY eq 1}">
				<div class="detail_zone">
					<div class="detail_left">
						<c:if test = "${dataMap.IEM_SN_1 > 0}">
						<table class="table_view2 mb20">
							<colgroup>
								<col style="width:98%" />
							</colgroup>
							<tr>
								<th style="font-size: 16px;">기업소개</th>
							</tr>
							<c:forEach items="${layoutList}" var="layoutList" varStatus="status">
							<c:if test="${layoutList.IEM_SN == 1}">
								<c:if test="${!empty layoutList.IMAGE_SN}">
									<c:choose>
		                   				<c:when test="${not empty layoutList.IMAGE_SN }">
		                   					<tr>
		                       				<td><img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${layoutList.IMAGE_SN}" />" id="img_photo" alt="이미지" width="98%" /></td>
		                       				</tr>
	                       				</c:when>
		                  					<c:otherwise>
		                  					<tr>
		                   					<td><img src="<c:url value="/images/cs/no_images.png"/>" id="img_photo" alt="로고" width="258" /></td>
		                   					</tr>	
		                   				</c:otherwise>
		                  			</c:choose>
								</c:if>
							<c:if test="${!empty layoutList.TEXT}">
  									<tr><td>${layoutList.TEXT }</td></tr>
							</c:if>
							</c:if>
							</c:forEach>
						</table>
						</c:if>
						<c:if test = "${dataMap.IEM_SN_3 > 0}">
						<table class="table_view2 mb20">
							<colgroup>
								<col style="width:98%" />
							</colgroup>
							<tr>
								<th style="font-size: 16px;">제품과고객</th>
							</tr>
							<c:forEach items="${layoutList}" var="layoutList" varStatus="status">
							<c:if test="${layoutList.IEM_SN == 3}">
								<c:if test="${!empty layoutList.IMAGE_SN}">
										<c:choose>
			                   				<c:when test="${not empty layoutList.IMAGE_SN }">
			                   					<tr>
			                       					<td><img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${layoutList.IMAGE_SN}" />" id="img_photo" alt="이미지" width="98%" /></td>
			                       				</tr>
			                       			</c:when>
			                  				<c:otherwise>
			                  					<tr>
			                   						<td><img src="<c:url value="/images/cs/no_images.png"/>" id="img_photo" alt="로고" width="258" /></td>
			                   					</tr>
			                   				</c:otherwise>
			                  			</c:choose>
								</c:if>
							<c:if test="${!empty layoutList.TEXT}">
								<tr>
  									<td>${layoutList.TEXT }</td>
 								</tr>
							</c:if>
							</c:if>
							</c:forEach>
						</table>
						</c:if>
						<c:if test = "${dataMap.IEM_SN_5 > 0}">
						<table class="table_view2">
							<colgroup>
								<col style="width:98%" />
							</colgroup>
							<tr>
								<th style="font-size: 16px;">사회공헌활동</th>
							</tr>
							<c:forEach items="${layoutList}" var="layoutList" varStatus="status">
							<c:if test="${layoutList.IEM_SN == 5}">
								<c:if test="${!empty layoutList.IMAGE_SN}">
									<tr>
										<c:choose>
			                   				<c:when test="${not empty layoutList.IMAGE_SN }">
			                       				<td><img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${layoutList.IMAGE_SN}" />" id="img_photo" alt="이미지" width="98%" /></td>
			                       			</c:when>
			                  					<c:otherwise>
			                   					<td><img src="<c:url value="/images/cs/no_images.png"/>" id="img_photo" alt="로고" width="258" /></td>
			                   				</c:otherwise>
			                  			</c:choose>
									</tr>
								</c:if>
							<c:if test="${!empty layoutList.TEXT}">
								<tr>
  									<td>${layoutList.TEXT }</td>
 								</tr>
							</c:if>
							</c:if>
							</c:forEach>
						</table>
						</c:if>
					</div>
					<div class="detail_right">
						<c:if test = "${dataMap.IEM_SN_2 > 0}">
						<table class="table_view2 mb20">
							<colgroup>
								<col style="width:98%" />
							</colgroup>
							<tr>
								<th style="font-size: 16px;">회사연혁</th>
							</tr>
							<c:forEach items="${layoutList}" var="layoutList" varStatus="status">
							<c:if test="${layoutList.IEM_SN == 2}">
								<c:if test="${!empty layoutList.IMAGE_SN}">
									<tr>
										<c:choose>
			                   				<c:when test="${not empty layoutList.IMAGE_SN }">
			                       				<td><img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${layoutList.IMAGE_SN}" />" id="img_photo" alt="이미지" width="98%" /></td>
			                       			</c:when>
			                  					<c:otherwise>
			                   					<td><img src="<c:url value="/images/cs/no_images.png"/>" id="img_photo" alt="로고" width="258" /></td>
			                   				</c:otherwise>
			                  			</c:choose>
									</tr>
								</c:if>
							<c:if test="${!empty layoutList.TEXT}">
								<tr>
  									<td>${layoutList.TEXT }</td>
 								</tr>
							</c:if>
							</c:if>
							</c:forEach>
						</table>
						</c:if>
						<c:if test = "${dataMap.IEM_SN_4 > 0}">
						<table class="table_view2 mb20">
							<colgroup>
								<col style="width:98%" />
							</colgroup>
							<tr>
								<th style="font-size: 16px;">소개</th>
							</tr>
							<c:forEach items="${layoutList}" var="layoutList" varStatus="status">
							<c:if test="${layoutList.IEM_SN == 4}">
								<c:if test="${!empty layoutList.IMAGE_SN}">
									<tr>
										<c:choose>
			                   				<c:when test="${not empty layoutList.IMAGE_SN }">
			                       				<td><img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${layoutList.IMAGE_SN}" />" id="img_photo" alt="이미지" width="98%" /></td>
			                       			</c:when>
			                  					<c:otherwise>
			                   					<td><img src="<c:url value="/images/cs/no_images.png"/>" id="img_photo" alt="로고" width="258" /></td>
			                   				</c:otherwise>
			                  			</c:choose>
									</tr>
								</c:if>
							<c:if test="${!empty layoutList.TEXT}">
								<tr>
  									<td>${layoutList.TEXT }</td>
 								</tr>
							</c:if>
							</c:if>
							</c:forEach>
						</table>
						</c:if>
						<c:if test = "${dataMap.IEM_SN_6 > 0}">
						<table class="table_view2">
							<colgroup>
								<col style="width:98%" />
							</colgroup>
							<tr>
								<th style="font-size: 16px;">CEO 메시지</th>
							</tr>
							<c:forEach items="${layoutList}" var="layoutList" varStatus="status">
							<c:if test="${layoutList.IEM_SN == 6}">
								<c:if test="${!empty layoutList.IMAGE_SN}">
									<tr>
										<c:choose>
			                   				<c:when test="${not empty layoutList.IMAGE_SN }">
			                       				<td><img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${layoutList.IMAGE_SN}" />" id="img_photo" alt="이미지" width="98%" /></td>
			                       			</c:when>
			                  					<c:otherwise>
			                   					<td><img src="<c:url value="/images/cs/no_images.png"/>" id="img_photo" alt="로고" width="258" /></td>
			                   				</c:otherwise>
			                  			</c:choose>
									</tr>
								</c:if>
							<c:if test="${!empty layoutList.TEXT}">
								<tr>
  									<td>${layoutList.TEXT }</td>
 								</tr>
							</c:if>
							</c:if>
							</c:forEach>
						</table>
						</c:if>
					</div>
				</div>
			</c:if>
			<c:if test = "${dataMap.LAYOUT_TY eq '2'}">
				<div class="type_zone">
					<div class="type_1">
						<c:if test = "${dataMap.IEM_SN_1 > 0}">
						<table class="table_view2 mb20">
							<colgroup>
								<col style="width:98%" />
							</colgroup>
							<tr>
								<th style="font-size: 16px;">기업소개</th>
							</tr>
							<c:forEach items="${layoutList}" var="layoutList" varStatus="status">
							<c:if test="${layoutList.IEM_SN == 1}">
								<c:if test="${!empty layoutList.IMAGE_SN}">
									<c:choose>
		                   				<c:when test="${not empty layoutList.IMAGE_SN }">
		                   					<tr>
		                       				<td><img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${layoutList.IMAGE_SN}" />" id="img_photo" alt="이미지" width="98%" /></td>
		                       				</tr>
	                       				</c:when>
		                  					<c:otherwise>
		                  					<tr>
		                   					<td><img src="<c:url value="/images/cs/no_images.png"/>" id="img_photo" alt="로고" width="258" /></td>
		                   					</tr>	
		                   				</c:otherwise>
		                  			</c:choose>
								</c:if>
							<c:if test="${!empty layoutList.TEXT}">
  									<tr><td>${layoutList.TEXT }</td></tr>
							</c:if>
							</c:if>
							</c:forEach>
						</table>
						</c:if>
						<c:if test = "${dataMap.IEM_SN_4 > 0}">
						<table class="table_view2">
							<colgroup>
								<col style="width:98%" />
							</colgroup>
							<tr>
								<th style="font-size: 16px;">소개</th>
							</tr>
							<c:forEach items="${layoutList}" var="layoutList" varStatus="status">
							<c:if test="${layoutList.IEM_SN == 4}">
								<c:if test="${!empty layoutList.IMAGE_SN}">
										<c:choose>
			                   				<c:when test="${not empty layoutList.IMAGE_SN }">
			                   					<tr>
			                       					<td><img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${layoutList.IMAGE_SN}" />" id="img_photo" alt="이미지" width="98%" /></td>
			                       				</tr>
			                       			</c:when>
			                  				<c:otherwise>
			                  					<tr>
			                   						<td><img src="<c:url value="/images/cs/no_images.png"/>" id="img_photo" alt="로고" width="258" /></td>
			                   					</tr>
			                   				</c:otherwise>
			                  			</c:choose>
								</c:if>
							<c:if test="${!empty layoutList.TEXT}">
								<tr>
  									<td>${layoutList.TEXT }</td>
 								</tr>
							</c:if>
							</c:if>
							</c:forEach>
						</table>
						</c:if>
					</div>
					<div class="type_2">
						<c:if test = "${dataMap.IEM_SN_2 > 0}">
						<table class="table_view2 mb20">
							<colgroup>
								<col style="width:98%" />
							</colgroup>
							<tr>
								<th style="font-size: 16px;">회사연혁</th>
							</tr>
							<c:forEach items="${layoutList}" var="layoutList" varStatus="status">
							<c:if test="${layoutList.IEM_SN == 2}">
								<c:if test="${!empty layoutList.IMAGE_SN}">
									<tr>
										<c:choose>
			                   				<c:when test="${not empty layoutList.IMAGE_SN }">
			                       				<td><img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${layoutList.IMAGE_SN}" />" id="img_photo" alt="이미지" width="98%" /></td>
			                       			</c:when>
			                  					<c:otherwise>
			                   					<td><img src="<c:url value="/images/cs/no_images.png"/>" id="img_photo" alt="로고" width="258" /></td>
			                   				</c:otherwise>
			                  			</c:choose>
									</tr>
								</c:if>
							<c:if test="${!empty layoutList.TEXT}">
								<tr>
  									<td>${layoutList.TEXT }</td>
 								</tr>
							</c:if>
							</c:if>
							</c:forEach>
						</table>
						</c:if>
						<c:if test = "${dataMap.IEM_SN_5 > 0}">
						<table class="table_view2">
							<colgroup>
								<col style="width:98%" />
							</colgroup>
							<tr>
								<th style="font-size: 16px;">사회공헌활동</th>
							</tr>
							<c:forEach items="${layoutList}" var="layoutList" varStatus="status">
							<c:if test="${layoutList.IEM_SN == 5}">
								<c:if test="${!empty layoutList.IMAGE_SN}">
									<tr>
										<c:choose>
			                   				<c:when test="${not empty layoutList.IMAGE_SN }">
			                       				<td><img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${layoutList.IMAGE_SN}" />" id="img_photo" alt="이미지" width="98%" /></td>
			                       			</c:when>
			                  					<c:otherwise>
			                   					<td><img src="<c:url value="/images/cs/no_images.png"/>" id="img_photo" alt="로고" width="258" /></td>
			                   				</c:otherwise>
			                  			</c:choose>
									</tr>
								</c:if>
							<c:if test="${!empty layoutList.TEXT}">
								<tr>
  									<td>${layoutList.TEXT }</td>
 								</tr>
							</c:if>
							</c:if>
							</c:forEach>
						</table>
						</c:if>
					</div>
					<div class="type_3">
						<c:if test = "${dataMap.IEM_SN_3 > 0}">
						<table class="table_view2 mb20">
							<colgroup>
								<col style="width:98%" />
							</colgroup>
							<tr>
								<th style="font-size: 16px;">제품과고객</th>
							</tr>
							<c:forEach items="${layoutList}" var="layoutList" varStatus="status">
							<c:if test="${layoutList.IEM_SN == 3}">
								<c:if test="${!empty layoutList.IMAGE_SN}">
									<tr>
										<c:choose>
			                   				<c:when test="${not empty layoutList.IMAGE_SN }">
			                       				<td><img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${layoutList.IMAGE_SN}" />" id="img_photo" alt="이미지" width="98%" /></td>
			                       			</c:when>
			                  					<c:otherwise>
			                   					<td><img src="<c:url value="/images/cs/no_images.png"/>" id="img_photo" alt="로고" width="258" /></td>
			                   				</c:otherwise>
			                  			</c:choose>
									</tr>
								</c:if>
							<c:if test="${!empty layoutList.TEXT}">
								<tr>
  									<td>${layoutList.TEXT }</td>
 								</tr>
							</c:if>
							</c:if>
							</c:forEach>
						</table>
						</c:if>
						<c:if test = "${dataMap.IEM_SN_6 > 0}">
						<table class="table_view2">
							<colgroup>
								<col style="width:98%" />
							</colgroup>
							<tr>
								<th style="font-size: 16px;">CEO 메시지</th>
							</tr>
							<c:forEach items="${layoutList}" var="layoutList" varStatus="status">
							<c:if test="${layoutList.IEM_SN == 6}">
								<c:if test="${!empty layoutList.IMAGE_SN}">
									<tr>
										<c:choose>
			                   				<c:when test="${not empty layoutList.IMAGE_SN }">
			                       				<td><img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${layoutList.IMAGE_SN}" />" id="img_photo" alt="이미지" width="98%" /></td>
			                       			</c:when>
			                  					<c:otherwise>
			                   					<td><img src="<c:url value="/images/cs/no_images.png"/>" id="img_photo" alt="로고" width="258" /></td>
			                   				</c:otherwise>
			                  			</c:choose>
									</tr>
								</c:if>
							<c:if test="${!empty layoutList.TEXT}">
								<tr>
  									<td>${layoutList.TEXT }</td>
 								</tr>
							</c:if>
							</c:if>
							</c:forEach>
						</table>
						</c:if>
					</div>
				</div>
			</c:if>
		</c:if>
	</form>
<!-- loading -->
<div style="display:none">
	<div class="loading" id="loading">
		<div class="inner">
			<div class="box">
		    	<p>
		    		<span id="load_msg">조회중입니다.</span>
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