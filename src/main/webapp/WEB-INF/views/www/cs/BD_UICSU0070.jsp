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
<meta http-equiv="X-UA-Compatible" content="IE=9" />
<title>기업 종합정보시스템</title>
<%-- <ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox" />
<ap:jsTag type="tech" items="msg,util,ucm,cs" /> --%>
<ap:jsTag type="web" items="jquery, form,validate" />
<ap:jsTag type="tech" items="msg,util, cmn , mainn, subb, font,paginate" />
<script type="text/javascript" src="/script/jquery/rollbanner/jquery.als-1.6.js"></script>
<!--  <link rel="stylesheet" type="text/css" media="screen" href="/css/rollbanner.css" /> -->
<script type="text/javascript" src="../../../../script/tech/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../../../../script/tech/jquery.ui.rcarousel.js"></script>
<link rel="stylesheet" type="text/css" media="screen" href="/css/rollbanner.css" />

<script type="text/javascript">

jQuery(function( $ ) {
	$( "#carousel" ).rcarousel({
		auto: {
			enabled: true,
			interval: 3000,
			direction: "prev"
		}
	});
	
	$( "#ui-carousel-next" )
		.add( "#ui-carousel-prev" )
		.hover(
			function() {
				$( this ).css( "opacity", 0.7 );
			},
			function() {
				$( this ).css( "opacity", 1.0 );
			}
		);				
});

$(document).ready(function(){
	
	/* 좌측 플로팅배터 레이어 시작 */
	var $doc           = $(document);
	var position       = 0;
	var top = $doc.scrollTop(); //현재 스크롤바 위치
	var screenSize     = 0;        // 화면크기
	var halfScreenSize = 0;    // 화면의 반
	/*사용자 설정 값 시작*/
	var pageWidth      = 1000; // 페이지 폭, 단위:px
	var leftOffet      = -480;  // 중앙에서의 폭(왼쪽 -, 오른쪽 +), 단위:px
	var leftMargin     = 509; // 페이지 폭보다 화면이 작을때 옵셋, 단위:px, leftOffet과 pageWidth의 반만큼 차이가 난다.
	var speed          = 1500;     // 따라다닐 속도 : "slow", "normal", or "fast" or numeric(단위:msec)
	var easing         = 'swing'; // 따라다니는 방법 기본 두가지 linear, swing
	var $layer         = $('#floating'); // 레이어 셀렉팅
	var layerTopOffset = 400;   // 레이어 높이 상한선, 단위:px
	$layer.css('z-index', 10);   // 레이어 z-인덱스
	/*사용자 설정 값 끝*/
	
	//좌우 값을 설정하기 위한 함수
	function resetXPosition()
	{
		$screenSize = $('body').width();// 화면크기
		halfScreenSize = $screenSize/2;// 화면의 반
		xPosition = halfScreenSize + leftOffet;
		if ($screenSize < pageWidth)
			xPosition = leftMargin;
		$layer.css('left', xPosition);
	}
	
	// 스크롤 바를 내린 상태에서 리프레시 했을 경우를 위해
	if (top > 0 )
		$doc.scrollTop(layerTopOffset+top);
	else
		$doc.scrollTop(0);
	
	// 최초 레이어가 있을 자리 세팅
	$layer.css('top',layerTopOffset);
	resetXPosition();
	
	//윈도우 크기 변경 이벤트가 발생하면
	$(window).resize(resetXPosition);
	
	//스크롤이벤트가 발생하면
	$(window).scroll(function(){
		 // 스크롤이 탑에서 400이상 떨어지면
		if($doc.scrollTop() >= 400){
			yPosition = $doc.scrollTop();
			$layer.animate({"top":yPosition }, {duration:speed, easing:easing, queue:false});
		}else{		// 스크롤이 탑에서 400이상 떨어지지 않았다면
			yPosition = layerTopOffset;
			$layer.animate({"top":yPosition }, {duration:speed, easing:easing, queue:false});
		}
	});
	/* 좌측 플로팅배터 레이어 끝 */
	
	
	// 검색
	$("#btn_search").click(function(){
		$("#df_method_nm").val("");
		$("#dataForm").submit();
	});
	
	$("#search_word").keyup(function(e){
		if(e.keyCode == 13) {
			$("#df_method_nm").val("");
			$("#dataForm").submit();
		}
	});
	
	// 경력 구분
	$("#search_career").change(function(){
		if($(this).val() == 'CK2') {
			$("#ad_search_career_year").attr("disabled", false);
		}else{
			$("#ad_search_career_year").val("");
			$("#ad_search_career_year").attr("disabled", true);
		}
	});

	$("#demo3").als({
		visible_items: 4,
		scrolling_items: 2,
		orientation: "horizontal",
		circular: "yes",
		autoscroll: "yes",
		interval: 4000
	});
	
}); // ready

var oderClick = function(order) {
	var form = document.dataForm;
	
	form.search_order.value = order;
	form.df_method_nm.value = "";	
	form.submit();
}

var logoClick = function(BIZRNO) {
	var form = document.dataForm;
	$("#BIZRNO").val(BIZRNO);

	form.df_curr_page.value = 1;
	form.df_method_nm.value = "";
	form.submit();
}

// 기업소개 팝업
var fn_cmpny_intrcn = function(epNo, bizrno){
	$.colorbox({
		title : "회사소개",
		href : "<c:url value='/PGCS0070.do?df_method_nm=cmpnyIntrcn&ad_ep_no="+ epNo +"&ad_bizrno="+ bizrno +"' />",
		width : "1500",
		height : "650",
		overlayClose : false,
		escKey : false,
		iframe : true
	});
};

// 채용 공고
var fn_empmn_info = function(empmnNo){
	/* $.colorbox({
		title : "채용공고",
		href : "<c:url value='/PGCS0070.do?df_method_nm=empmnInfoView&ad_empmn_manage_no="+ empmnNo +"' />",
		width : "1300",
		height : "650",
		overlayClose : false,
		escKey : false,
		iframe : true
	}); */
	
	$("#ad_empmn_manage_no").val(empmnNo);
	$("#df_method_nm").val("empmnInfoView");
			
	var empmnInfoWindow = window.open('', 'empmnInfo', 'width=1050, height=590, top=100, left=100, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbars=yes, fullscreen=no, resizable=yes');	
	document.dataForm.action = "/PGCS0070.do";
	document.dataForm.target = "empmnInfo";
	document.dataForm.submit();
	document.dataForm.target = "";
	if(empmnInfoWindow){
		empmnInfoWindow.focus();
	}
};

// 워크넷 페이지 오픈
var fn_move_weburl = function(url) {
	window.open(url,"_blank");
};

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
    <ap:include page="param/dispParam.jsp" />
    <ap:include page="param/pagingParam.jsp" />
    <input type="hidden" id="ad_empmn_manage_no" name="ad_empmn_manage_no" />
    <input type="hidden" id="userNo" name="userNo" />
    <input type="hidden" id="BIZRNO" name="BIZRNO" />
    <input type="hidden" id="search_order" name="search_order" value = "${param.search_order }"/>

    
    <!--//content-->
    <div id="wrap" class="top_bg">
        <div class="contents">
        <div id="go_container">
        <div class="s_cont" id="s_cont">
		<div class="s_tit s_tit04">
			<h1>정보제공</h1>
		</div>
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit tit4">정보제공</h2>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}" />
				</div>
				<div class="r_cont s_cont04_07">
					<div class="list_bl">
						<h4 class="fram_bl">추천 우수기업 채용 정보</h4>
										<div class="company_list">
											<c:if test="${not empty recommendList}">
												<div class="search_top mgt5" id="demo4" border="1">
													<div class="inner">
														<table cellspacing="13" style="border: 5px none #dadada; cellapacing:50;  ">
															<c:forEach begin="0" end="${(fn:length(recommendList) + 3) / 4 - 1}" var="row">
																<tr>
																	<c:forEach begin="0" end="3" var="col">
																		<c:set var="list" value="${recommendList[row * 4 + col]}" />
																		<c:if test="${not empty list}">
																			<td >
																				<div class="recommendbox" style="margin:8px";>
																			  <ul><li>
																					<div id="greenings">
																						<c:choose>
																							<c:when test="${not empty list.LOGO_FILE_SN }">
																								<a href="#none" onclick="logoClick(${list.BIZRNO})"><img
																									src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${list.LOGO_FILE_SN}" />"
																									width="150" height="40" alt="${list.ENTRPRS_NM }"
																									title="${list.ENTRPRS_NM }" /></a>
																							</c:when>
																							<c:otherwise>
																								<a href="#none" onclick="logoClick(${list.BIZRNO})"><img
																									src="<c:url value="/images/cs/no_logo.png"/>" width="120" height="50"
																									id="img_photo" alt="${list.ENTRPRS_NM }" style="border: #666 solid 1px" /></a>
																							</c:otherwise>
																						</c:choose>
																					</div>
																					<div id="maincontents">
																						<h5 style="font-size: 16px; color: #222; font-weight: 500; margin-top: 15px; margin-left : 15px;">${list.ENTRPRS_NM}</h5>
																						<p style="font-family: 'NanumBarunGothic'; color: #666; font-size: 14px; font-weight: 300; margin-top: 9px; margin-left : 15px; margin-bottom: 15px;">채용진행중 : ${list.recRowCnt}건</p>
																					</div>
																			  </li></ul>
																				</div>
																			</td>
																		</c:if>
																	</c:forEach>
																</tr>
															</c:forEach>
														</table>
													</div>
												</div>
											</c:if>
										</div>
									</div>
					<p class="guide_txt">진행중인 채용 정보 목록 입니다 좋은 결과 있으시길 기원합니다.</p>
               <div class="sear_sec st_box01">
                  <ul>
                     <li>
                        <select class ="select_box" name="search_type" id="search_type" style="width:115px; margin-right: 13px;">
                           <p><span id="title_layer1"> <option value="0" 
                                                <c:if test="${param.search_type == 0}">selected="selected"</c:if>
                                                >제목
                                                </option></span></p>
                           <div class="sel_option option" style="width: 80px;">
                              <option value="1" 
                                                <c:if test="${param.search_type == 1}">selected="selected"</c:if>
                                                >기업명
                                                </option>
                           </div>
                           </select>
                     </li>
                     <li>
                        <div class="sear_text">
                           <input type="text" name="search_word" id="search_word" value="${param.search_word }" placeholder=" 검색어를 입력하세요." style="width:550px;"><!-- 공백제거
                           --><span><p class="btn_src_zone"><a href="#none" id="btn_search" class="btn_search50"><img src="/images2/sub/sear_ico.png">검색</a></p>
                        </div>   
                     </li>
                     <li>
                        <select name="search_zone" class="select_box" title="검색조건선택"
                           id="search_zone" style="width: 115px; margin-right: 13px;">
                              <option value="">지역전체</option>
                              <c:forEach items="${abrvList}" var="abrv" varStatus="status">
                                 <c:choose>
                                    <c:when test="${abrv.code == 'WA00' || abrv.code == 'WKN'}">
                                    </c:when>
                                    <c:otherwise>
                                       <option value="${abrv.code}"
                                          <c:if test = "${abrv.code == param.search_zone}"> selected="selected" </c:if>>${abrv.codeNm}</option>
                                    </c:otherwise>
                                 </c:choose>
                              </c:forEach>
                        </select>
                     </li>
                     <li>
                        <select name="search_jssfc" class="select_box" title="검색조건선택" id="search_jssfc" style="width:406px; margin-right: 13px;">
                              <p>
                              <span id="title_layer3"><option value="">직종</option> <c:forEach
                                    items="${jssfcLargeList}" var="list" varStatus="status">
                                 <option value="${list.CODE}"
                                       <c:if test="${list.CODE == param.search_jssfc}"> selected=="selected"</c:if>>${list.CODE_NM }</option>
                                 </c:forEach>
                           </select>
                     </li>
                     <li>
                        <select name="search_career" title="검색조건선택" class="select_box" id="search_career" style="width:130px;">
                           <p><span id="title_layer4"><option value="">경력구분</option>
                           <option value="ck1" <c:if test="${param.search_career == 'ck1'}"> selected=="selected"</c:if>>신입</option>
                           <option value="ck2" <c:if test="${param.search_career == 'ck2'}"> selected=="selected"</c:if>>경력</option>
                           </select>
                     </li>
                  </ul>
               </div>
					<div class="table_list">
						<div class="list_ico">
							<ul>
								<li><img src="/images2/sub/support/list_ico01.png">기업소개</li>
								<li><a href="#none" onclick="wc300_popup();"><img src="/images2/sub/support/list_ico02.png">월드클래스 300</a></li>
								<li><a href="#none" onclick="atc_popup();"><img src="/images2/sub/support/list_ico03.png">ATC</a></li>
								<li><img src="/images2/sub/support/list_ico04.png">코스피</li>
								<li><img src="/images2/sub/support/list_ico05.png">코스닥</li>
							</ul>
						</div>
						<div class="list_look">
							<p>
								<span>총 ${totalRowCnt}건</span>
							</p>
							<p class="range">
								<span><a href="#none" onclick = "oderClick(3);">마감임박순</a> | <a href="#none" onclick = "oderClick(1);">최근 등록일순</a></span>
							</p>
						</div>
						<table class="st_bl01 stb_gr01">
						 <caption>
                            	기본게시판 목록
                            </caption>
							<colgroup>
								<col width="187px">
								<col width="359px">
								<col width="178px">
								<col width="163px">
							</colgroup>
							<thead>
								<tr>
									<th scope="col">기업명</th>
									<th scope="col">채용제목</th>
									<th scope="col">자격요건</th>
									<th scope="col">마감일</th>
								</tr>
							</thead>
							<tbody>
                                <c:forEach items="${dataList }" var="data" varStatus="status">
              					<tr>
                					<td>
										<span>                                    	
										<c:choose>
                        					<c:when test="${data.ENTRPRS_VW_AT == 'Y'}">
     	                                		<a href="#none" onclick="fn_cmpny_intrcn('${data.USER_NO }', '${data.BIZRNO }')">${data.ENTRPRS_NM }</a>
                        					</c:when>
                        					<c:otherwise>
        						           		${data.ENTRPRS_NM }
                        					</c:otherwise>
                        				</c:choose>
                        				</span>
	                 					<div class="mgt5" style="text-align:center; margin:auto;"> 
	                 						<c:forEach items = "${data.chartr }" var="chartr" varStatus="status">
	                 						<c:if test="${chartr.CHARTR_CODE == '1'}">
	                 							<span class="ico_k_2" style="text-align:center; margin:auto;"></span>
	                 						</c:if>	
	                 						<c:if test="${chartr.CHARTR_CODE == '2'}">
	                 							<a href="#none" onclick="wc300_popup();"><span class="ico_w_2"></span></a>
	                 						</c:if>
	                 						<c:if test="${chartr.CHARTR_CODE == '3'}">
	                 							<a href="#none" onclick="atc_popup();"><span class="ico_a_2"></span></a>
	                 						</c:if>
	                 						<c:if test="${chartr.CHARTR_CODE == '4'}">
	                 							<span class="ico_c_2"></span>
	                 						</c:if>
	                 						<c:if test="${chartr.CHARTR_CODE == '5'}">
	                 							<span class="ico_d_2"></span>
	                 						</c:if>
	                 						</c:forEach>
	                 					</div>
                 					</td>
                					<td class="job3">
                					<strong>
                					<a href="#none">
                						<c:if test="${fn:length(data.EMPMN_SJ) > 32}">
                							<c:if test="${fn:substring(data.WANTED_AUTH_NO, 0, 1) != 'K'}">			<!-- 워크넷 자체 데이터가 아니라면 상세정보가 없으므로 링크 -->
                                       			<c:choose>
						                		<c:when test="${fn:trim(data.WANTED_AUTH_NO) == ''}">   			<!-- 워크넷 자체 데이터가 아니라도 직접 입력했다면 팝업 -->
						                			<a href="#none" onclick="fn_empmn_info('${data.EMPMN_MANAGE_NO }')">${fn:substring(data.EMPMN_SJ,0,30) } ...</a>
						                		</c:when>
						                		<c:otherwise>          												<!-- 워크넷 자체 데이터가 아니라면 상세정보가 없으므로 링크 -->
						                			<a href="#none" onclick="fn_move_weburl('${data.ECNY_APPLY__WEB_ADRES }')">${fn:substring(data.EMPMN_SJ,0,30) } ...</a>
						                		</c:otherwise>
						                		</c:choose>
                                       		</c:if>
                                       		<c:if test="${fn:substring(data.WANTED_AUTH_NO, 0, 1) == 'K'}">
                                       			<a href="#none" onclick="fn_empmn_info('${data.EMPMN_MANAGE_NO }')">${fn:substring(data.EMPMN_SJ,0,30) } ...</a>
                                       		</c:if>
                                       	</c:if>
     	                                <c:if test="${fn:length(data.EMPMN_SJ) <= 32}">                                        	
                                       		<c:if test="${fn:substring(data.WANTED_AUTH_NO, 0, 1) != 'K'}">			<!-- 워크넷 자체 데이터가 아니라면 상세정보가 없으므로 링크 -->
                                       			<c:choose>
						                		<c:when test="${fn:trim(data.WANTED_AUTH_NO) == ''}">   			<!-- 워크넷 자체 데이터가 아니라도 직접 입력했다면 팝업 -->
						                			<a href="#none" onclick="fn_empmn_info('${data.EMPMN_MANAGE_NO }')">${data.EMPMN_SJ }</a>
						                		</c:when>
						                		<c:otherwise>          												<!-- 워크넷 자체 데이터가 아니라면 상세정보가 없으므로 링크 -->
						                			<a href="#none" onclick="fn_move_weburl('${data.ECNY_APPLY__WEB_ADRES }')">${data.EMPMN_SJ }</a>
						                		</c:otherwise>
						                		</c:choose>
                                       		</c:if>
                                       		<c:if test="${fn:substring(data.WANTED_AUTH_NO, 0, 1) == 'K'}">
                                       			<a href="#none" onclick="fn_empmn_info('${data.EMPMN_MANAGE_NO }')">${data.EMPMN_SJ }</a>
                                       		</c:if>
                                       	</c:if>
                                    </a>
                                    </strong>
                                    <p class ="gray tal">
                                     ${data.JSSFC }
	                                </p>
	                                </td>
					                <td>
					                <c:choose>
                                 		<c:when test="${fn:substring(data.WANTED_AUTH_NO, 0, 1) == 'K'}">
	                                 		<c:forEach items="${data.iem25 }" var="iem25" varStatus="status"> <c:if test="${not status.first }">,</c:if>
		                                 		<c:choose>
		                                 		<c:when test="${iem25.IEM_VALUE != 'WKN' }">${iem25.CODE_NM }<c:if test="${iem25.CODE_NM == '' }">${data.CAREER_DETAIL_RQISIT2}</c:if></c:when>
							                	<c:otherwise>${iem25.ATRB3}</c:otherwise>
							                	</c:choose>
						                	</c:forEach><br>
						                	<c:forEach items="${data.iem27 }" var="iem27" varStatus="status"><c:if test="${not status.first }">,</c:if>
							                	<c:choose>
							                	<c:when test="${iem27.IEM_VALUE != 'WKN' }">${iem27.CODE_NM }</c:when>
							                	<c:otherwise>${iem27.ATRB3}</c:otherwise>
							                	</c:choose> 
						                	</c:forEach>
                                 		</c:when>   
					                   	<c:otherwise>
	                                 		${data.CAREER_DETAIL_RQISIT2}
	                                 		<br>
						                	${data.CAREER_DETAIL_RQISIT3}
					                	</c:otherwise>
					                </c:choose>
					                </td>
                					<td>${data.RCRIT_END_DE}</td>
              					</tr>
                                </c:forEach>
                            </tbody>
						</table>
					</div>
			<!--  -->		
<div style="text-align:center;"><ap:pager pager="${pager}" /></div>
					<!--  -->
					
				</div>
			</div>
		</div>
	</div>
                </div>
                <!--sub contents //-->
            </div>
            <!-- 우측영역//-->
            <!-- </div>
        </div> -->
    </div>
    <!--content//-->
</form>

<!-- 좌측 따라다니는 배너(플로팅 배너) 시작 -->
<!-- <div id="floating"  style="position:absolute;" >
	<table border="0" height="50" width="500">
		<tr>
			<td>
				<a href="" onClick="window.open('http://www.mme.or.kr', '')"><img src="images/banner/tech.jpg" height="50px" width="180px" /></a>
			</td>
		</tr>
		<tr>
			<td height="5px"></td>
		</tr>
		<tr>
			<td>
				<img src="images/cs/info_source.gif" height="50px" width="180px" />
			</td>
		</tr>
	</table>
</div> -->
<!-- 좌측 따라다니는 배너(플로팅 배너) 끝 -->

</body>
</html>