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
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox,json" />
<ap:jsTag type="tech" items="msg,util,cmn, mainn, subb, font,paginate" />

<script type="text/javascript">
$(document).ready(function(){
	

	// 회사소개 관리 버튼
	$("#btn_cmpy_Intrc").click(function(){		
		<c:choose>
		<c:when test="${isAdmin == true}">
		show_cmpy_list("INTRCN");
		</c:when>
		<c:otherwise>
		$.colorbox({
			title : "회사소개관리",
			href : "<c:url value='/PGMY0030.do?df_method_nm=cmpnyIntrcnMngForm' />",
			width : "90%",
			height : "80%",
			overlayClose : false,
			escKey : false,
			iframe : true
		});
		</c:otherwise>
		</c:choose>						
	});
	
	// 채용공고 등록
	$("#btn_pblanc_reg").click(function(){	
		<c:choose>
		<c:when test="${isAdmin == true}">
		show_cmpy_list("PBLANC");
		</c:when>
		<c:otherwise>
		$.ajax({        
	        url      : "PGMY0030.do",
	        type     : "POST",
	        dataType : "text",
	        data     : {df_method_nm : "checkCmpnyInfoRegAt"},                
	        async    : false,                
	        success  : function(response) {        	
	        	try {
	        		if(eval(response)) {	        			
	        			$("#df_method_nm").val("empmnInfoForm");
	        			$("#dataForm").submit();
	                } else {
	                	jsMsgBox(null,'info',Message.msg.noSearchCmpnyIntrcn);
	                }      		
	            } catch (e) {            	            	
	                if(response != null) {
	                	jsSysErrorBox(response.err_code+": "+response.err_msg);
	                } else {
	                    jsSysErrorBox(e);
	                }
	                return;
	            }
	        }
	    });
		</c:otherwise>
		</c:choose>	
		
	});
	
//	$("#colorbox").css("top","95px");
});

// 채용공고 상세보기
var fn_empmn_view = function(empmn_no) {
	$("#ad_empmn_manage_no").val(empmn_no);
	$("#df_method_nm").val("empmnInfoView");
	$("#dataForm").submit();
};

var show_cmpy_list = function(type) {
	var tttt;

//	$("#colorbox").css("top","95px");

//	alert(window.document.getElementById("colorbox").style.top);
//    window.document.getElementById("colorbox").style.top = "100px";	
//	alert("IF 띄우기 전");
//	$('html, body').stop().animate( { scrollTop : 0 } );	
	$(document).scrollTop(0);
//	alert("scrollTop");
	$.colorbox({
		title : "기업선택",
		href : "<c:url value='/PGMY0030.do?df_method_nm=empmnCmpnyMngList&ad_reg_type="+ type +"' />",
		width : "90%",
		height : "80%",
		overlayClose : false,
		escKey : false,
		iframe : true
	});
	
//    if(parent.$.fn.colorbox) {
//        tttt="parent";
//    } else if($.fn.colorbox) {
//    	tttt="self";
//    } else {
//        tttt="none";
//    }	

//    $(document).scrollTop($(document).height());
//   window.document.getElementById("colorbox").style.top = "100px";	    
//    alert("IF 띄운 후");
//	alert(window.document.getElementById("colorbox").style.top);

//	alert(tttt);
//	alert(window.document.getElementById("colorbox").style.top);
//  alert(parent.$.fn.colorbox);
//	alert(parent.$.fn.colorbox.data(title));
		
};
</script>

</head>

<body>
	<div id="wrap" class="top_bg">
		<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
			<div class="s_cont" id="s_cont">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />

				<input type="hidden" id="ad_empmn_manage_no" name="ad_empmn_manage_no" />		<%-- 채용관리번호 --%>
				<input type="hidden" id="ad_bizrno" name="ad_bizrno" />							<%-- 사업자등록번호 --%>
				
				<div class="s_tit s_tit03">
					<h1>마이페이지</h1>
				</div>
				<div class="s_wrap">
					<div class="l_menu">
						<h2 class="tit tit3">마이페이지</h2>
						<ul>
						</ul>
					</div>
					<div class="r_sec">
						<div class="r_top">
							<ap:trail menuNo="${param.df_menu_no}" />
						</div>

	                <div class="r_cont s_cont06_03">
	                    <h4 class="list_noraml_tit">채용공고를 등록하신 내역 입니다. 좋은 결과 있으시길 기원합니다.</h4>
						<p class="list_noraml">채용기업을 클릭하시면 해당 채용정보를 확인하실 수 있습니다.</p>
						<p class="list_noraml" style="margin-bottom: 26px;">지원수를 클릭하시면 해당 채용공고에 등록된 지원자 목록을 확인하실 수 있습니다. <br/>
						<span>※ 마감 30일이 지난 채용공고의 입사신청서는 개인정보보호를 위해 열람할 수 없습니다.</span></p>
						<div class="table_list">
							<ap:pagerParam />
	                        <table class="st_bl01 stb_gr01">
								<colgroup>
									<col width="63px">
									<col width="301px">
									<col width="138px">
									<col width="85px">
									<col width="113px">
									<col width="112px">
									<col width="78px">
								</colgroup>
	                            <thead>
									<tr>
										<th>번호</th>
										<th>채용제목</th>
										<th>직종</th>
										<th>근무형태</th>
										<th>시작일</th>
										<th>마감일</th>
										<th>지원자수</th>
									</tr>
								</thead>
	                            <tbody>
	                            	<c:forEach items="${dataList }" var="data" varStatus="status">
		                                <tr>
		                                    <td>${pager.indexNo - status.index}</td>
		                                    <td class="txt_l">
		                                    	<a href="#" onClick="fn_empmn_view('${data.EMPMN_MANAGE_NO}')" title="${data.EMPMN_SJ }" >
			                                    	<c:if test="${data.CLOSED == 1 }"><img src="<c:url value="/images/ucm/icon_finish.png"/>"  alt="마감" /></c:if>
			                                    	<c:if test="${data.CLOSED == 0 }"><img src="<c:url value="/images/ucm/icon_recruit.png"/>"  alt="채용" /></c:if>
		                                    	${data.EMPMN_SJ }</a>
		                                    </td>
		                                    <td>${data.JSSFC }</td>
		                                    <td>
		                                    	<c:forEach items="${data.item33List }" var="empmn33Item" varStatus="status">                                    		
		                                    		${empmn33Item.CODE_NM }                                    		
		                                    	</c:forEach>
		                                    </td>
		                                    <td>${data.RCRIT_BEGIN_DE }</td>
		                                    <td>${data.RCRIT_END_DE }</td>
		                                    <td>
		                                    	<a href="#" onClick="fn_empmn_view('${data.EMPMN_MANAGE_NO}')" title="지원자수" >${data.DESIRE_CNT }</a>
		                                    </td>
		                                </tr>
	                                </c:forEach>                           
	                            </tbody>
	                        </table>
	                    </div>
	                    <div class="btn_bl">
	                    	<a class="blu" href="#" id="btn_cmpy_Intrc"><span>회사소개 관리</span></a>
	                    	<a class="" href="#" id="btn_pblanc_reg"><span>채용공고 등록</span></a>
	                    </div>
	                    <div style="text-align:center;margin-top:20px;"><ap:pager pager="${pager}" /></div>
	                </div>
	            </div>
	        </div>
		</div>
	</div>
</form>

<script type="text/javascript">
//alert("여기실행");
//alert($("#colorbox").attr("top"));
//alert($("#colorbox").attr("top"));
//$("#colorbox").css("top","95px");

</script>


</body>



</html>