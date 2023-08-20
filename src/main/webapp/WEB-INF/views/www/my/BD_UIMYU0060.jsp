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
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox" />
<ap:jsTag type="tech" items="msg,util,cmn, mainn, subb, font" />

<script type="text/javascript">

$(document).ready(function(){
	
	// 기업확인신청 화면 이동
 	$("#btn_move").click(function(){
 		jsMoveMenu('7','16','PGIC0020')
 	});
}); // ready

// 확인신청서 수정
function reqstWriteForm(rcept_no) {
	$("#ad_load_data").val("Y");
	$("#ad_view_type").val("form");
	$("#ad_load_rcept_no").val(rcept_no);
	$("#df_method_nm").val("");
	
	$("#dataForm").attr("action", "/PGIC0022.do");
	$("#dataForm").submit();
}

// 확인신청서 상세보기
function reqstResultView(rcept_no) {
	$("#ad_load_data").val("Y");
	$("#ad_view_type").val("view");
	$("#ad_load_rcept_no").val(rcept_no);
	$("#df_method_nm").val("");
	
	$("#dataForm").attr("action", "/PGIC0022.do");
	$("#dataForm").submit();
}

// 내용변경신청(재발급신청) 상세보기
function reqstIsgnView(rcept_no) {
	$.colorbox({
		title : "기업확인서 내용변경신청",
		href : "<c:url value='/PGMY0060.do?df_method_nm=isgnResultView&ad_load_rcept_no="+ rcept_no +"&auth=N' />",
		width : "1100",
		height : "650",
		overlayClose : false,
		escKey : false,
		iframe : true
	});
}

function issueAgainPop(rcept_no, again_rcept_no){
	if(!again_rcept_no) {
		again_rcept_no = "";
	}
	$.colorbox({
		title : "기업확인서 내용변경신청",
		href : "<c:url value='/PGMY0060.do?df_method_nm=issueAgainForm&ad_load_rcept_no="+ rcept_no +"&ad_again_rcept_no="+again_rcept_no+"' />",
		width : "1100",
		height : "650",
		overlayClose : false,
		escKey : false,
		iframe : true
	});	
}

function showDetail(title, rceptNo, methodNm, readOnly, jurirno){
	$.colorbox({
        title : title,
        href  : "PGMY0060.do?df_method_nm="+methodNm+"&ad_rcept_no="+rceptNo+"&ad_readonly="+readOnly+"&ad_jurirno="+jurirno,        
        width : "830px",
        height: "470px",
        top: "-200px",
        overlayClose : false,
        escKey : false,  
        iframe: true,
        scrolling: false
    });
}

function showDetail2(title, rceptNo, methodNm, readOnly, reqstSe, upperRceptNo){
	$.colorbox({
        title : title,
        href  : "PGMY0060.do?df_method_nm="+methodNm+"&ad_rcept_no="+rceptNo+"&ad_readonly="+readOnly+"&ad_reqst_se="+reqstSe+"&ad_upper_rcept_no="+upperRceptNo,
        width : "760px",
        height: "470px",            
        overlayClose : false,
        escKey : false,  
        iframe: true,
        scrolling: false
    });
}

function printCertIssue( issue_no, confm_se )
{
	/* $.colorbox({
        title : "기업확인서출력",
        href  : "PGMY0060.do?df_method_nm=printCertIssue&issueNo="+issue_no+"&confmSe="+confm_se,//+"&output=embed",        
        width : "980",
        height: "710",            
        overlayClose : false,
        escKey : false,  
        iframe: true,
        scrolling: true
    }); */
    
	window.open("PGMY0060.do?df_method_nm=processCertIssuetInfo&issueNo="+issue_no+"&confmSe="+confm_se,
			"printPop","width=700, height=750, scrollbars=yes, resizable=no");
}

function printCertIssue2( rcept_no )
{
	window.open("PGMY0060.do?df_method_nm=processCertIssuetInfo2&rceptNo="+rcept_no,
			"printPop","width=700, height=750, scrollbars=yes, resizable=no");
}

function entrpAnalisysPop(rcept_no){	
	$.colorbox({
		title : "기업분석서비스",
		href : "<c:url value='/PGMY0060.do?df_method_nm=entrpAnalisys&ad_load_rcept_no="+ rcept_no +"' />",
		width : "1100",
		height : "650",
		overlayClose : false,
		escKey : false,
		iframe : true
	});	
}

// 임시저장 삭제
function delete_tmp_saved(rcept_no) {
	jsMsgBox(null,'confirm',Message.msg.confirmDelete, function(){
		$.ajax({        
	        url      : "PGMY0060.do",
	        type     : "POST",
	        dataType : "json",
	        data     : { df_method_nm: "deleteTempSaveInfos"        	       
	        	       	, rcept_no: rcept_no
	        	       },                
	        async    : false,                
	        success  : function(response) {
	        	try {        		
	        		if(response.result) {
	        			jsMsgBox(null,'info',Message.msg.successDelete, function(){
	        				self.location.reload();
	        			});
	                } else {
	                	jsMsgBox(null,'error',Message.msg.failDelete);
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
	});		
}

</script>

</head>
<body>

<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">

<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />
<ap:include page="param/pagingParam.jsp" />

<input type="hidden" id="ad_load_data" name="ad_load_data" />
<input type="hidden" id="ad_view_type" name="ad_view_type" />
<input type="hidden" id="ad_load_rcept_no" name="ad_load_rcept_no" />

<div id="wrap">
    <div class="s_cont" id="s_cont">
		<div class="s_tit s_tit02">
			<h1>기업확인</h1>
		</div>
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit tit2">기업확인</h2>
				<ul>
				</ul>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}" />
				</div>
				<div class="r_cont s_cont02_07">
					<h4 class="list_noraml_tit">기업 확인 > 기업 확인 신청을 통해 신청하신 내역을 확인하실 수 있습니다.</h4>
					<p class="list_noraml">‘기업명’을 클릭하시면 신청정보 확인 및 상태에 따라 수정 가능합니다.</p>
					<p class="list_noraml">상태에서 판정을 위한 진행과정 안내드리며, 처리결과에서는 최종 결과가 출력됩니다.</p>
					<p class="list_noraml">상태의 보완요청을 클릭하시면, 보완하실 내용을 확인하실 수 있습니다. </p>
					<p class="list_noraml">처리결과의 접수취소, 반려, 발급취소를 클릭 하시면 각각의 사유를 확인하실 수 있습니다. </p>
					<p class="list_noraml">신청 취소를 원하시는 경우 완료되지 않은 상태에서는 ‘신청취소’버튼을, 발급완료된 상태에서는 ‘발급취소’버튼을 클릭하시고, <br/>
					사유를 입력해 주십시오.</p>
					<p class="list_noraml">유효기간 내에 사업자등록번호 추가 및 정보변경을 통한 내용변경이 필요하신 경우 ‘내용변경’ 버튼을 클릭하시어 진행하시기 바랍니다. </p>
					<p class="list_noraml" style="margin-bottom: 26px;">처리결과의 발급을 클릭하시면 기업 확인서를 출력하실 수 있습니다.</p>
					<div class="table_list">
						<table class="st_bl01 stb_gr01">
							<colgroup>
								<col width="103px">
								<col width="104px">
								<col width="85px">
								<col width="68px">
								<col width="116px">
								<col width="62px">
								<col width="77px">
								<col width="110px">
								<col width="71px">
								<col width="85px">
							</colgroup>
							<thead>
								<tr>
									<th>등록일자</th>
									<th>접수일자</th>
									<th>신청구분</th>
									<th>기준년도</th>
									<th>신청서</th>
									<th>상태</th>
									<th>결과</th>
									<th>유효기간</th>
									<th>기업분석<br/>서비스</th>
									<th> </th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${issueTaskMng}" var="issueTaskMng" varStatus="status">
	                                <tr>
	                                    <td>${issueTaskMng.CREAT_DE }</td>
	                                    <td>${issueTaskMng.RCEPT_DE }</td>
	                                    <td>${issueTaskMng.REQST_SE_NM }</td>
	                                    <td>${issueTaskMng.CONFM_TARGET_YY }</td>
	                                    <td>
	                                    	<c:choose>
	                                    		<%-- 내용변경(재발급)에 대한 보완요청의 경우 --%>
	                                    		<c:when test="${issueTaskMng.REQST_SE == 'AK2' and issueTaskMng.SE_CODE_S == 'PS3'}">			                                   	
			                                   		<a href="#none" onClick="issueAgainPop('${issueTaskMng.UPPER_RCEPT_NO}', '${issueTaskMng.RCEPT_NO}');" >${issueTaskMng.ENTRPRS_NM }</a>
			                                   	</c:when>
			                                   	<%-- 임시저장, 보완요청의 경우 --%>			                                   	
			                                   	<c:when test="${issueTaskMng.REQST_SE == 'AK0' or issueTaskMng.SE_CODE_S == 'PS3' }">
			                                   		<a href="#none" onClick="reqstWriteForm('${issueTaskMng.RCEPT_NO}');" >${issueTaskMng.ENTRPRS_NM }</a>
			                                   	</c:when>
			                                   	<%-- 내용변경신청(재발급신청)인 경우 --%>
			                                   	<c:when test="${issueTaskMng.REQST_SE == 'AK2'}">
			                                   		<a href="#none" onClick="reqstIsgnView('${issueTaskMng.RCEPT_NO}');" >${issueTaskMng.ENTRPRS_NM }</a>
			                                   	</c:when>
			                                   	<c:otherwise> 
			                                   		<a href="#none" onClick="reqstResultView('${issueTaskMng.RCEPT_NO}');" >${issueTaskMng.ENTRPRS_NM }</a>                                   	
			                                   	</c:otherwise>
	                                    	</c:choose>                                    	
	                                    </td>
	                                    <td>
		                                    <c:choose>
		                                    	<%-- 임시저장 --%>
		                                    	<c:when test="${issueTaskMng.REQST_SE == 'AK0' }">${issueTaskMng.REQST_SE_NM }</c:when>
		                                    	<%-- 보완요청 --%>
		                                    	<c:when test="${issueTaskMng.SE_CODE_S == 'PS3' }">
		                                    			<c:if test="${issueTaskMng.REQST_SE == 'AK1' }">
		                                    				<a href="#none" onClick="showDetail2('보완사유','${issueTaskMng.RCEPT_NO}','showSupplement','Y','AK1');" class="bl_btn"><span>보완<%-- ${issueTaskMng.SE_CODE_NM_S } --%></span></a>
		                                    			</c:if>
		                                    			<c:if test="${issueTaskMng.REQST_SE == 'AK2' }">
		                                    				<a href="#none" onClick="showDetail2('보완사유','${issueTaskMng.RCEPT_NO}','showSupplement','Y','AK2','${issueTaskMng.UPPER_RCEPT_NO}');" class="bl_btn"><span>보완<%-- ${issueTaskMng.SE_CODE_NM_S } --%></span></a>
		                                    			</c:if>
		                                    	</c:when>
		                                    	<c:otherwise>${issueTaskMng.SE_CODE_NM_S }</c:otherwise>
		                                    </c:choose>                                  
	                                    </td>
	                                    <td>
		                                    <c:choose>
		                                    	<c:when test="${empty issueTaskMng.SE_CODE_R and not fn:contains(issueTaskMng.SE_CODE_S, 'PS6')}">
		                                    		<c:choose>
		                                    			<c:when test="${issueTaskMng.REQST_SE != 'AK0' and issueTaskMng.REQST_SE != 'AK2'}">
		                                    				<a href="#none" onClick="printCertIssue2('${issueTaskMng.RCEPT_NO}');" class="bl_btn"><span>신청증</span></a>
		                                    			</c:when>
		                                    			<c:otherwise>-</c:otherwise>
		                                    		</c:choose>
												</c:when>
		                                    	<%-- 발급 --%>
		                                    	<c:when test="${issueTaskMng.SE_CODE_R == 'RC1' and fn:contains(issueTaskMng.SE_CODE_S, 'PS6')}">
		                                    		<c:choose>
		                                    			<c:when test="${issueTaskMng.ISGN_AT == 'Y'}">
		                                    			${issueTaskMng.SE_CODE_NM_R }
		                                    			</c:when>
		                                    			<c:otherwise>
		                                    				<a href="#none" onClick="printCertIssue('${issueTaskMng.ISSU_NO }', '${issueTaskMng.CONFM_SE }');" class="bl_btn">
		                                    					<span>${issueTaskMng.SE_CODE_NM_R }</span></a>
		                                    			</c:otherwise>
		                                    		</c:choose>		                                    		
		                                    	</c:when>
		                                    	<%-- 반려 --%>
		                                    	<c:when test="${issueTaskMng.SE_CODE_R == 'RC2' and fn:contains(issueTaskMng.SE_CODE_S, 'PS6')}">
		                                    		<a href="#none" onClick="showDetail('판정결과 보기','${issueTaskMng.RCEPT_NO}','showJudgment','Y');">${issueTaskMng.SE_CODE_NM_R }</a>
		                                    	</c:when>
		                                    	<%-- 접수취소 --%>
		                                    	<c:when test="${issueTaskMng.SE_CODE_R == 'RC3' and fn:contains(issueTaskMng.SE_CODE_S, 'PS6')}">
		                                    		<a href="#none" onClick="showDetail('접수취소 보기','${issueTaskMng.RCEPT_NO}','showCancelReception','Y');">${issueTaskMng.SE_CODE_NM_R }</a>
		                                    	</c:when>
		                                    	<%-- 발급취소 --%>
		                                    	<c:when test="${issueTaskMng.SE_CODE_R == 'RC4' and fn:contains(issueTaskMng.SE_CODE_S, 'PS6')}">
		                                    		<a href="#none" onClick="showDetail('발급취소 보기','${issueTaskMng.RCEPT_NO}','showCancelIssue','Y');">${issueTaskMng.SE_CODE_NM_R }</a>
		                                    	</c:when>
		                                    	<c:otherwise><c:if test="${fn:contains(issueTaskMng.SE_CODE_S, 'PS6')}">${issueTaskMng.SE_CODE_NM_R }</c:if></c:otherwise>
		                                    </c:choose>                                                                      
	                                    </td>	                                    
	                                    <td>
	                                    	<%-- 처리결과가 발급의 경우 --%>
	                                    	<c:if test="${issueTaskMng.SE_CODE_R == 'RC1' and fn:contains(issueTaskMng.SE_CODE_S, 'PS6')}" >
	                               				${issueTaskMng.VALID_PD_BEGIN_DE } ~<br />
	                               				${issueTaskMng.VALID_PD_END_DE }
	                               			</c:if>
										</td>
	                                    <td>
	                                    	<%-- 처리결과가 발급의 경우 --%>
	                                    	<c:if test="${issueTaskMng.SE_CODE_R == 'RC1' and fn:contains(issueTaskMng.SE_CODE_S, 'PS6') and issueTaskMng.REQST_SE != 'AK2'}" >
	                                    		<a href="#none" onClick="entrpAnalisysPop('${issueTaskMng.RCEPT_NO}')" class="bl_btn"><span>조회</span></a>
	                                    	</c:if>
	                                    </td>
	                                    <td>
	                                    	<c:choose>
	                                    		<%-- 신청구분이 임시저장의 경우 --%>
	                                    		<c:when test="${issueTaskMng.REQST_SE == 'AK0' }">
	                                    			<a href="#" class="bl_btn" onClick="delete_tmp_saved('${issueTaskMng.RCEPT_NO}')"><span>삭제</span></a>
	                                    		</c:when>
	                                    		<%-- 신청상태가 완료의 경우  --%>
	                                    		<c:when test="${issueTaskMng.SE_CODE_S == 'PS6' }">
	                                    			<c:if test="${issueTaskMng.REQST_SE != 'AK2'}">
		                                    			<%-- 처리결과가 발급의 경우(유효기간내) --%>
		                                    			<c:if test="${issueTaskMng.SE_CODE_R == 'RC1' }" >
		                                    				<a href="#" class="bl_btn" onClick="issueAgainPop('${issueTaskMng.RCEPT_NO}');"><span>내용변경</span></a>
		                                    			</c:if>
	                                    			</c:if>
	                                    		</c:when>
	                                    		<c:otherwise>
	                                    			<a href="#" onClick="showDetail('접수취소 등록','${issueTaskMng.RCEPT_NO}','showCancelReception','N');" class="bl_btn"><span>접수취소</span></a>
	                                    		</c:otherwise>
	                                    	</c:choose>                                    
	                                    </td>
	                                </tr>
	                                </c:forEach>
							</tbody>
						</table>
					</div>
					<div class="btn_bl">
						<a href="#none" id="btn_move" class="blu">기업확인신청</a>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</form>
</body>
</html>