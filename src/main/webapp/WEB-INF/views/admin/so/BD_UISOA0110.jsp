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
<title>정보</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,mask,colorboxAdmin,jqGrid" />
<ap:jsTag type="tech" items="acm,msg,util,so,hi" />
<script type="text/javascript" src="/script/jquery/rollbanner/jquery.als-1.6.js"></script>
<link rel="stylesheet" type="text/css" media="screen" href="/css/rollbanner.css" />


<script type="text/javascript">

$(document).ready(function(){
	// 검색
	$("#btn_search").click(function(){		
		$("#df_method_nm").val("");
		$("#dataForm").attr("action", "${svcUrl}");
		$("#dataForm").submit();
	});
	
	$("#demo3").als({
		visible_items: 6,
		scrolling_items: 2,
		orientation: "horizontal",
		circular: "yes",
		autoscroll: "yes",
		interval: 4000
	});
	
	//전체선택 체크박스
	$("input[name='chk-all']").click(function(){
		var isChecked = this.checked;
		$("input[name='seqs']").prop('checked', isChecked);
		
		if(isChecked){
// 			$(":checkbox").parent().parent().addClass("bg_blue");
		}else{
// 		    $(":checkbox").parent().parent().removeClass("bg_blue");
		}
	});
	
}); // ready

var logoClick = function(BIZRNO) {
	var form = document.dataForm;
	$("#BIZRNO").val(BIZRNO);

	form.df_curr_page.value = 1;
	form.df_method_nm.value = "";
	form.submit();
}

//회사소개 팝업
var fn_cmpny_intrcn = function(epNo, bizrno){
	$.colorbox({
		title : "회사소개",
		href : "<c:url value='/PGCS0070.do?df_method_nm=cmpnyIntrcn&ad_ep_no="+ epNo +"&ad_bizrno="+ bizrno +"' />",
		width : "1300",
		height : "650",
		overlayClose : false,
		escKey : false,
		iframe : true
	});
};

//회원정보 팝업
var fn_userInfo = function(userNo){
	$.colorbox({
		title : "회원정보",
		href : "<c:url value='/PGMY0070.do?df_method_nm=popUserInfo&ad_userNo=" + userNo + "' />",
		width : "700",
		height : "400",
		overlayClose : false,
		escKey : false,
		iframe : true
	});
};

// 추천기업 여부 변경
var fn_cmpny_intrcn_recommend_update = function(userNo, bizrNo) {
	
	$("#USER_NO").val(userNo);
	$("#BIZR_NO").val(bizrNo);
	
	var form = document.dataForm;
	form.df_method_nm.value = "updateCmpnyIntrcnRecommend";
	form.submit();
	
}

// 추천기업여부 전체 변경
var fn_cmpny_intrcn_all_recommend_update = function() {
	var userNo = new Array();
	var bizrNo = new Array();
	
	var seqs= document.getElementsByName("seqs");				// 체크박스
	
	$("#ad_count").val(seqs.length);
	
	
	for(var i=0; i<seqs.length; i++) {
/*
		bizrNo[i] = selectedSeqs[i].substring(0,10);
		userNo[i] = selectedSeqs[i].substring(10);
		
		$('#dataForm')
		.append(
				'<input type = "hidden" name = "USER_NO_'+ i +'" value = "'+ userNo[i] +'"/>');
		$('#dataForm')
		.append(
				'<input type = "hidden" name = "BIZR_NO_'+ i +'" value = "'+ bizrNo[i] +'"/>');
*/		
		if(seqs[i].checked == true) {
			$('#dataForm')
			.append(
					'<input type = "hidden" name = "check_'+ i +'" value = "Y"/>');
		}
		else {
			$('#dataForm')
			.append(
					'<input type = "hidden" name = "check_'+ i +'" value = "N"/>');
		}
	}

	var form = document.dataForm;
	form.df_method_nm.value = "updateCmpnyIntrcnAllRecommend";
	form.submit();
	
}

//체크된 기업 목록을 가져온다.
var jsCheckedArray = function(){
	var selectedSeqs = new Array();
		$("input[name='seqs']:checked").each(function(i){
		selectedSeqs[i] = $(this).val();
	});
	return selectedSeqs;
};	
</script>

</head>
<body>

<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" enctype="multipart/form-data" method="post">

<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />
<ap:include page="param/pagingParam.jsp" />

<c:forEach items="${dataList }" var="dataMap" varStatus="status">
	<input type="hidden" name="USER_NO_${status.index }" value="${dataMap.USER_NO}"/>
	<input type="hidden" name="BIZR_NO_${status.index }" value="${dataMap.BIZRNO}"/>
</c:forEach>
<input type="hidden" id="ad_count" name="ad_count" />
<input type="hidden" id="BIZRNO" name="BIZRNO" value ="${dataMap }"/>
<input type="hidden" id="BIZR_NO" name="BIZR_NO" value=""/>
    
	<div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">추천기업관리</h2>
                <!-- 타이틀 영역 //-->
                <!-- // 배너영역 
                <c:if test="${not empty recommendList}"> 
                	<div class="als-container" id="demo3" border="1">
	  					<div class="als-viewport">
	    					<ul class="als-wrapper">
	    					<c:forEach items="${recommendList}" var="list" varStatus="status">
	      						<li class="als-item"><a href="#none">
	      							<c:choose>
                		        		<c:when test="${not empty list.LOGO_FILE_SN }">					
	      									<a href="#none" onclick="logoClick(${list.BIZRNO});"><img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${list.LOGO_FILE_SN}" />" width="120" height="50" alt="${list.ENTRPRS_NM }" title="${list.ENTRPRS_NM }"/></a>
		           		             	</c:when>
                   		     			<c:otherwise>
                   		     				<a href="#none" onclick="logoClick(${list.BIZRNO})"><img src="<c:url value="/images/cs/no_logo.png"/>" width="120" height="50" id="img_photo" alt="${list.ENTRPRS_NM }" style="border:#666 solid 1px" /></a>
                   	     				</c:otherwise>
                   	     			</c:choose>	
	      						</a></li>
	    					</c:forEach>
	    					</ul>
	 					</div>
					</div>
      			</c:if>
      			// -->
       			<!-- 배너 영역 // -->
       			<!-- // 추천기업 영역 -->
               	<div class="search_top mgt5" id="demo4" border="1">
                	<div class="inner">
                		<table cellpadding="10" cellspacing="10" border="0">
                			<c:forEach begin="0" end="${(fn:length(recommendList) + 3) / 4 - 1}" var="row">
		                	<tr>
		                		<c:forEach begin="0" end="3" var="col">
		                		<c:set var="list" value="${recommendList[row * 4 + col]}"/>
		                		<c:if test="${not empty list}">
			                	<td>
			                		<div class="recommendbox">
			                			<div id="greenings">
				                			<c:choose>
		                		        		<c:when test="${not empty list.LOGO_FILE_SN }">					
			      									<a href="#none" onclick="logoClick(${list.BIZRNO})"><img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${list.LOGO_FILE_SN}" />" width="150" height="40" alt="${list.ENTRPRS_NM }" title="${list.ENTRPRS_NM }"/></a>
				           		             	</c:when>
		                   		     			<c:otherwise>
		                   		     				<a href="#none" onclick="logoClick(${list.BIZRNO})"><img src="<c:url value="/images/cs/no_logo.png"/>" width="120" height="50" id="img_photo" alt="${list.ENTRPRS_NM }" style="border:#666 solid 1px" /></a>
		                   	     				</c:otherwise>
		                   	     			</c:choose>	
			                			</div>
			                			<div id="maincontents">
			                				<b>${list.ENTRPRS_NM}</b>
			                				</br>
			                				채용진행중 : ${list.recRowCnt}건
			                			</div>
			                		</div>
			                	</td>
			                	</c:if>
			                	</c:forEach>
		                	</tr>
		                	</c:forEach>
	                	</table>
	                </div>
				</div>
       			<!-- 추천기업 영역 // -->     
                <!--// 검색 조건 -->
                <div class="search_top">
                    <table cellpadding="0" cellspacing="0" class="table_search" summary="검색" >
                        <caption>
                        		검색
                        </caption>
                        <colgroup>
                        	<col width="10%" />
                        	<col width="90%" />
                        </colgroup>
                        <tr>
                            <td colspan = "2" class="only"><select name="search_type" title="검색조건선택" id="search_type" style="width:110px">
                                    <option value="0" <c:if test="${param.search_type == 0 }">selected="selected"</c:if>>기업명</option>
                                    <option value="1" <c:if test="${param.search_type == 1 }">selected="selected"</c:if>>아이디</option>
                                    <option value="2" <c:if test="${param.search_type == 2 }">selected="selected"</c:if>>작성자</option>
                                </select>
                                <input name="search_word" type="text" id="search_word" value="${param.search_word }" style="width:300px;" title="검색어 입력" placeholder="검색어를 입력하세요."/>
                                <p class="btn_src_zone"><a href="#" class="btn_search" id="btn_search">검색</a></p></td>
                        </tr>
                        <tr>
                        	<th scope="col" style="width:110px;">업종</th>
                        	<td>
                                <input name="search_induty" type="text" id="search_induty" value="${param.search_induty }" style="width:300px;" title="업종 입력" placeholder="업종을 입력하세요."/>
 								<input type="checkbox" name="recomend_entrprs_search_at" id="recomend_entrprs_search_at" <c:if test="${param.recomend_entrprs_search_at == 'on' }"> checked</c:if>/><label for="recomend_entrprs_at">추천기업만 검색</label>                       		
                        	</td>
                        </tr>
                    </table>
                </div>
                <div class="block">
                    <ap:pagerParam />
                    
                    <!--// 리스트 -->
                    <div class="list_zone mgb10">
                        <table cellspacing="0" border="0" summary="기본게시판 목록으로 번호,제목,작성일 등의 조회 정보를 제공합니다.">
                            <caption>
                            기본게시판 목록
                            </caption>
                            <colgroup>
                            <col width="*" />                        
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col"><input type="checkbox" value="Y" name="chk-all" id="chk-all" /></th>
                                    <th scope="col">번호</th>
                                    <th scope="col">기업명</th>
                                    <th scope="col">작성자</th>
                                    <th scope="col">저장</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${dataList }" var="dataMap" varStatus="status">
                                <tr>
									<td><input type="checkbox" name="seqs" <c:if test="${dataMap.RECOMEND_ENTRPRS_AT == 'Y'}">checked=checked</c:if> /></td>
                                    <td class="tac">${pager.indexNo - status.index}</td>
                                    <td>
                                    	<c:choose>
                        					<c:when test="${dataMap.ENTRPRS_VW_AT == 'Y'}">
												<a href="#none" onclick="fn_cmpny_intrcn('${dataMap.USER_NO}', '${dataMap.BIZRNO}')">${dataMap.ENTRPRS_NM }</a>
                        					</c:when>
                        					<c:otherwise>
        						           		${dataMap.ENTRPRS_NM }			
                        					</c:otherwise>
                        				</c:choose>
                                    </td>
                                    <td class="job2"><a href="#none" onclick="fn_userInfo('${dataMap.USER_NO}')">${dataMap.CHARGER_NM }</td>
                                    <td>
										<a class="btn_page_admin" href="#" onclick="fn_cmpny_intrcn_recommend_update('${dataMap.USER_NO }', '${dataMap.BIZRNO }');"><span><c:if test="${dataMap.RECOMEND_ENTRPRS_AT == 'Y'}">해제</c:if><c:if test="${dataMap.RECOMEND_ENTRPRS_AT != 'Y'}">추천</c:if></span></a>
                                    </td>
                                </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <!-- 리스트// -->
                    <div class="btn_page_last">
						<a class="btn_page_admin" href="#" onclick="fn_cmpny_intrcn_all_recommend_update();"><span>추천기업저장</span></a>
					</div>
					<!--// paginate -->
					<ap:pager pager="${pager}" />
					<!-- paginate //-->
                </div>
            </div>
            <!--content//-->
        </div>
    </div>
</form>

</body>
</html>