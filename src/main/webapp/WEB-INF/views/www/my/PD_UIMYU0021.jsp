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
<ap:jsTag type="tech" items="msg,util,cmn, mainn, subb, font,my" />

<script type="text/javascript">

$(document).ready(function(){	
 	
	//목록버튼
	$("#btn_list").click(function(){
		self.close();
	});
	
	//수정버튼
	$("#btn_mod").click(function(){
		/* window.resizeTo(screen.width, 800);
 		window.moveTo(0,0); */
 		 		
 		$("#df_method_nm").val("applyCmpnyForm");
 		$("#dataForm").attr("action", "/PGCS0070.do");
		$("#dataForm").submit();
	});
	
	//삭제버튼
	$("#btn_del").click(function(){		
		
		<c:choose>
			<c:when test="${applyMap.RCEPT_AT == 'Y'}">
			jsMsgBox(null, "confirm", Message.msg.compApplyDelete, fn_apply_del);
			</c:when>
			<c:otherwise>
			jsMsgBox(null, "confirm", Message.msg.confirmDelete, fn_apply_del);
			</c:otherwise>
		</c:choose>		
	});
	
	//입사지원취소버튼
	$("#btn_cancel").click(function(){
		jsMsgBox(null, "confirm", Message.msg.compApplyCancel, fn_apply_cancel);
	});
	
	
}); // ready

// 입사지원 취소 실행
var fn_apply_cancel = function(){
	$.ajax({        
        url      : "PGMY0020.do",
        type     : "POST",
        dataType : "text",
        data     : {
        			df_method_nm:"updateApplyCancel"
        			, empmnNo:$("#ad_empmn_manage_no").val()        			
        },                
        async    : false,                
        success  : function(response) {        	
        	try {
        		if(eval(response)) {        			
        			jsMsgBox(null,'info',Message.msg.processOk);
        			window.opener.location.reload();
        			window.close();
                } else {
                	jsMsgBox(null,'error',Message.msg.processFail);
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
};

// 입사지원 삭제 실행
var fn_apply_del = function(){
	$.ajax({        
        url      : "PGMY0020.do",
        type     : "POST",
        dataType : "text",
        data     : {
        			df_method_nm:"deleteApplyInfo"
        			, empmnNo:$("#ad_empmn_manage_no").val()        			
        },                
        async    : false,                
        success  : function(response) {        	
        	try {
        		if(eval(response)) {        			
        			jsMsgBox(null,'info',Message.msg.deleteOk);
        			window.opener.location.reload();
        			window.close();
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
};

</script>

</head>
<body class="popup">

<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" enctype="multipart/form-data" method="post">

<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />
<ap:include page="param/pagingParam.jsp" />

<input type="hidden" id="ad_empmn_manage_no" name="ad_empmn_manage_no" value="${param.ad_empmn_manage_no }" />

</form>

<div id="wrapper_popup" class="modal">
	<div class="modal_wrap">
    <!--header_popup 시작-->
	    <!--container_popup 시작-->
	    <div id="container_popup" class="modal_cont">
	        <!--//sub contents -->
	        <div class="list_bl">
                <h4 class="fram_bl" style="margin-bottom: 6px;">기본사항</h4>
                <!-- <div class="view_zone"> -->
                <table class="table_form" style="margin-bottom: 20px">
                    <caption>
                    기본사항
                    <colgroup>
						<col width="172px">
						<col width="367px">
						<col width="173px">
						<col width="367px">
					</colgroup>
                    <tbody>
                        <tr>
                            <th class="p_l_30">지원제목</th>
                            <td class="b_l_0" colspan="3">${applyMap.APPLY_SJ }</td>
                        </tr>
                        <tr>
                            <th class="p_l_30">지원분야(직종)</th>
                            <td class="b_l_0" colspan="3">${applyMap.APPLY_REALM }</td>
                        </tr>
                        <tr>
                            <th class="p_l_30">희망연봉</th>
                            <td class="b_l_0" colspan="3">
                            	<c:if test="${applyMap.ANSLRY_DIV == 1 }" >회사내규에 따름</c:if>
                            	<c:if test="${applyMap.ANSLRY_DIV == 2 }" >
                             	<c:if test="${not empty applyMap.HOPE_ANSLRY }" >
                             	${applyMap.HOPE_ANSLRY }만원	
                             	</c:if>                                	
                            	</c:if>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="list_bl">
            	<h4 class="fram_bl">인적사항</h4>
                <table class="table_form">
                    <caption>
                    인적사항
                    </caption>
                    <colgroup>
						<col width="240px">
						<col width="144px">
						<col width="274px">
						<col width="144px">
						<col width="274px">
					</colgroup>
                    <tbody>
                        <tr>
                            <td  class="t_center" rowspan="5">
                            	<!-- <ul style="width:100%">
                                    <li class="tac mb10"> -->                                        	
                                    	<c:choose>
			                              	<c:when test="${not empty applyMap.PHOTO_FILE_SN }"><img src='<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${applyMap.PHOTO_FILE_SN}" />' alt="로고" id="img_photo" width="120" height="150" style="border:#666 solid 1px" /></c:when>
			                              	<c:otherwise><img src="<c:url value="/images/my/photo.png" />" alt="로고" id="img_photo" width="120" height="150" style="border:#666 solid 1px" /></c:otherwise>
			                              	</c:choose>                                            
                                   <!--  </li>
                                </ul></td> -->
                            <th class="p_l_30">이름</th>
                            <td class="b_l_0" colspan="3">
                            	한글&nbsp;&nbsp;&nbsp;&nbsp;<strong class="s_strong">${applyMap.NM }</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            	영문&nbsp;&nbsp;&nbsp;&nbsp;<strong class="s_strong">${applyMap.ENG_NM }</strong>
                            </td>
                        </tr>
                        <tr>
                            <th class="p_l_30">주소</th>
                            <td class="b_l_0" colspan="3">
                            	${fn:substring(applyMap.ZIP, 0, 3) }-${fn:substring(applyMap.ZIP, 3, 6) }
                                <br/>${applyMap.ADRES }
                            </td>
                        </tr>
                        <tr>
                            <th class="p_l_30" style="border-left: 1px solid #dadada;">전화번호</th>
                            <td class="b_l_0">${applyMap.TELNO1 }-${applyMap.TELNO2 }-${applyMap.TELNO3 }</td>
                            <th class="p_l_30">휴대폰</th>
                            <td class="b_l_0">${applyMap.MBTLNUM1 }-${applyMap.MBTLNUM2 }-${applyMap.MBTLNUM3 }</td>
                        </tr>
                        <tr>
                            <th class="p_l_30" style="border-left: 1px solid #dadada;">이메일</th>
                            <td class="b_l_0" colspan="3">${applyMap.EMAIL }</td>
                        </tr>
                        <tr>
                            <th class="p_l_30" style="border-left: 1px solid #dadada;">생년월일</th>
                            <td class="b_l_0" colspan="3">${applyMap.BRTHDY }</td>
                        </tr>
                    </tbody>
                </table>
	        </div>
            <c:if test="${empmnMap.DETAIL_ACDMCR_INPUT_AT == 'Y' }">
	        	<div class="list_bl">
	                <h4 class="fram_bl">학력사항</h4>
	                <!-- <div class="list2_zone mb20"> -->
	                <table class="table_form">
	                    <caption>
	                    학력사항
	                    </caption>
	                    <colgroup>
	                    <col style="width:*" />
	                    <col style="width:*" />
	                    <col style="width:*" />
	                    <col style="width:*" />
	                    <col style="width:*" />
	                    <col style="width:*" />
	                    </colgroup>
	                    <thead>
	                     <tr>
	                        <th>분류</th>
	                        <th>학교명</th>
	                        <th>소재지</th>
	                        <th>재학기간</th>
	                        <th>전공</th>
	                        <th>학점</th>
	                  	  </tr>
	                    </thead>
	                    <tbody>                            
	                        <c:forEach items="${applyMap.ACDMCR }" var="ACDMCR">
	                        <tr>
	                            <td class="t_center">${ACDMCR.ACD_LV_NM }(${ACDMCR.ACD_TYPE_NM })</td>
	                            <td class="t_center">${ACDMCR.SCHUL_NM }</td>
	                            <td class="t_center">${ACDMCR.LOCPLC }</td>
	                            <td class="t_center">
	                            	<c:if test="${not empty ACDMCR.ENTSCH_DE }">${fn:substring(ACDMCR.ENTSCH_DE, 0, 4)}년${fn:substring(ACDMCR.ENTSCH_DE, 4, 6)}월(${ACDMCR.ENTSCH_SE_NM })</c:if>
	                            	<c:if test="${not empty ACDMCR.GRDTN_DE }"> ~ ${fn:substring(ACDMCR.GRDTN_DE, 0, 4)}년${fn:substring(ACDMCR.GRDTN_DE, 4, 6)}월(${ACDMCR.GRDTN_SE_NM })</c:if>                                
	                            </td class="t_center">
	                            <td class="t_center">${ACDMCR.MAJOR1 } ${ACDMCR.MAJOR2 }</td>
	                            <td class="tar">${ACDMCR.SCRE }<c:if test="${not empty ACDMCR.PSCORE }">/${ACDMCR.PSCORE }</c:if></td>
	                        </tr>
	                        </c:forEach>                            
	                    </tbody>
	                </table>
	            </div>
            </c:if>
                
            <c:if test="${empmnMap.EMPYMN_PVLTRT_MATTER_INPUT_AT == 'Y' }">
	            <div class="list_bl">
		            <h4 class="fram_bl">취업우대사항</h4>
	                <table class="table_form">
	                    <caption>
	                    취업우대사항
	                    </caption>
	                    <colgroup>
	                    <col style="width:18%" />
	                    <col style="width:35%" />
	                    <col style="width:15%" />
	                    <col style="width:35%" />
	                    </colgroup>
	                    <tbody>
	                        <tr>
	                            <th class="p_l_30">보훈대상</th>
	                            <td class="b_l_0"><c:if test="${applyMap.RWDMRT_TRGET_AT == 'Y' }">대상</c:if><c:if test="${applyMap.RWDMRT_TRGET_AT == 'N' }">비대상</c:if></td>
	                            <th class="p_l_30">취업보호대상</th>
	                            <td class="b_l_0"><c:if test="${applyMap.EMPYMN_PRTC_TRGET_AT == 'Y' }">대상</c:if><c:if test="${applyMap.EMPYMN_PRTC_TRGET_AT == 'N' }">비대상</c:if></td>
	                        </tr>
	                        <tr>
	                            <th class="p_l_30">고용지원금대상</th>
	                            <td class="b_l_0" colspan="3"><c:if test="${applyMap.EMPLYM_SPRMNY_TRGET_AT == 'Y' }">대상</c:if><c:if test="${applyMap.EMPLYM_SPRMNY_TRGET_AT == 'N' }">비대상</c:if></td>
	                        </tr>
	                        <tr>
	                            <th class="p_l_30">장애</th>
	                            <td class="b_l_0"><c:if test="${applyMap.TROBL_AT == 'Y' }">대상</c:if><c:if test="${applyMap.TROBL_AT == 'N' }">비대상</c:if></td>
	                            <th class="p_l_30">장애등급</th>
	                            <td class="b_l_0">${applyMap.TROBL_GRAD }</td>
	                        </tr>
	                        <tr>
	                            <th class="p_l_30">병역사항</th>
	                            <td class="b_l_0" colspan="3">
	                            	${applyMap.MTRSC_DIV_NM }
	                            	&nbsp;&nbsp;&nbsp;
	                            	<c:if test="${not empty applyMap.ENST_YM }">${fn:substring(applyMap.ENST_YM, 0, 4)}년${fn:substring(applyMap.ENST_YM, 4, 6)}월</c:if>
	                            	<c:if test="${not empty applyMap.DMBLZ_YM }"> ~ ${fn:substring(applyMap.DMBLZ_YM, 0, 4)}년${fn:substring(applyMap.DMBLZ_YM, 4, 6)}월</c:if>
	                            	&nbsp;&nbsp;&nbsp;
	                            	${applyMap.MSCL_NM }<c:if test="${not empty applyMap.CLSS_NM }">/${applyMap.CLSS_NM }</c:if>
	                            </td>
	                        </tr>
	                    </tbody>
	                </table>
	            </div>
            </c:if>
	                
            <c:if test="${empmnMap.EDC_COMPL_INPUT_AT == 'Y' }">
	            <div class="list_bl">
		            <h4 class="fram_bl">교육이수내역</h4>
	                <table class="table_form">
	                    <caption>
	                    교육이수내역
	                    </caption>
	                    <colgroup>
	                    <col style="width:*" />
	                    <col style="width:*" />
	                    <col style="width:*" />
	                    <col style="width:*" />
	                    </colgroup>
	                    <thead>
	                    	<tr>
		                        <th>교육명</th>
		                        <th>교육기관</th>
		                        <th>교육기간</th>
		                        <th>교육내용</th>
	                  		</tr>
	                    </thead>
	                    <tbody>
	                    	<c:forEach items="${applyMap.EDC }" var="EDC">
	                    	<tr>
	                            <td class="b_l_0">${EDC.EDC_NM }</td>
	                            <td class="b_l_0">${EDC.ECLST }</td>
	                            <td class="b_l_0">
	                            	${EDC.EDC_BEGIN_DE }<c:if test="${not empty EDC.EDC_END_DE }" > ~ ${EDC.EDC_END_DE }</c:if>
	                            </td>
	                            <td class="b_l_0">${EDC.EDC_CN }</td>
	                        </tr>
	                    	</c:forEach>                            
	                    </tbody>
	                </table>
		        </div>
            </c:if>
	                
            <c:if test="${empmnMap._ELSE_LGTY_INPUT_AT == 'Y' }">
	            <div class="list_bl">
	            	<h4 class="fram_bl">어학시험 및 외국어 구사능력</h4>
	                <table class="table_form">
	                    <caption>
	                    어학시험 및 외국어 구사능력
	                    </caption>
	                    <colgroup>
	                    <col style="width:12%" />
	                    <col style="width:*" />
	                    <col style="width:*" />
	                    <col style="width:*" />
	                    </colgroup>
	                    <thead>
	                    	<tr>
								<th>외국어명</th>
								<th>수준</th>
								<th>공인시험명</th>
								<th>취득일자</th>
	                    	</tr>
	                    </thead>
	                    <tbody>
	                    	<c:forEach items="${applyMap.FGGG }" var="FGGG">
	                        <tr>
	                            <td class="b_l_0">${FGGG.FGGG_NM }</td>
	                            <td class="b_l_0">
	                            	<c:if test="${FGGG.FGGG_LEVEL == 'H' }">상</c:if>
	                            	<c:if test="${FGGG.FGGG_LEVEL == 'M' }">중</c:if>
	                            	<c:if test="${FGGG.FGGG_LEVEL == 'L' }">하</c:if>                                
	                            </td>
	                            <td class="b_l_0">${FGGG.ATHRI_EXPR_NM }</td>
	                            <td class="b_l_0">${FGGG.ACQS_DE }</td>
	                        </tr>
	                        </c:forEach>
	                    </tbody>
	                </table>
	            </div>
            </c:if>
	                
            <c:if test="${empmnMap.OVSEA_SDYTRN_INPUT_AT == 'Y' }">
	            <div class="list_bl">
		            <h4 class="fram_bl">해외연수</h4>
	                <table class="table_form">
	                    <caption>
	                    해외연수
	                    </caption>
	                    <colgroup>
	                    <col style="width:30%" />
	                    <col style="width:30%" />
	                    <col style="width:40%" />
	                    </colgroup>
	                    <thead>
	                    	<tr>
	                         <th>연수국가(교육명)</th>
	                         <th>연수기간</th>
	                         <th>연수내용 및 목적</th>
	                  	  </tr>
	                    </thead>
	                
	                    <tbody>
	                    	<c:forEach items="${applyMap.SDYTRN }" var="SDYTRN">
	                        <tr>
	                            <td class="b_l_0">${SDYTRN.SDYTRN_NATION }</td>
	                            <td class="b_l_0">
						${SDYTRN.SDYTRN_BEGIN_DE }<c:if test="${not empty SDYTRN.SDYTRN_END_DE }" > ~ ${SDYTRN.SDYTRN_END_DE }</c:if>
					</td>
	                            <td class="b_l_0">${SDYTRN.SDYTRN_CN }</td>
	                        </tr>
	                        </c:forEach>
	                    </tbody>
	                </table>
		        </div>
            </c:if>
	        
			<div class="list_bl">
           		<h4 class="fram_bl">경력사항</h4>
                <table class="table_form" style="width:100%;">
                    <caption>
                    경력사항
                    </caption>
                    <colgroup>
	                    <col width="210px">
						<col width="325px">
						<col width="190px">
						<col width="*">
                    </colgroup>
                    <thead>
                    	<tr>
                         <th>기업명</th>
                         <th>재직기간</th>
                         <th>직위</th>
                         <th>담당업무</th>
                 	   </tr>
                    </thead>
                    <tbody>
                    	<c:forEach items="${applyMap.CACAREER }" var="CACAREER">
                        <tr>
                            <td class="t_center">${CACAREER.WRC_NM }</td>
                            <td class="t_center">
                            	${CACAREER.BEGIN_DE }<c:if test="${not empty CACAREER.END_DE }" > ~ ${CACAREER.END_DE }</c:if>
                            </td>
                            <td class="t_center">${CACAREER.OFCPS }</td>
                            <td class="t_center">${CACAREER.CHRG_JOB }</td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
	                
            <c:if test="${empmnMap.QUALF_ACQS_INPUT_AT == 'Y' }">
            <div class="list_bl">
            	<h4 class="fram_bl">자격사항</h4>
                <table class="table_form">
                    <caption>
                    자격사항
                    </caption>
                    <colgroup>
                    <col style="width:25%" />
                    <col style="width:10%" />
                    <col style="width:20%" />
                    <col style="width:20%" />
                    <col style="width:25%" />
                    </colgroup>
                    <thead>
                    	<tr>
                         <th>자격명</th>
                         <th>등급</th>
                         <th>자격증번호</th>
                         <th>취득일</th>
                         <th>발행기관</th>
                   	 </tr>	
                    </thead>
                    <tbody>
                    	<c:forEach items="${applyMap.QUALF }" var="QUALF">
                        <tr>
                            <td class="b_l_0">${QUALF.QUALF_NM }</td>
                            <td class="b_l_0">${QUALF.GRAD }</td>
                            <td class="b_l_0">${QUALF.CRQFC_NO }</td>
                            <td class="b_l_0">${QUALF.ACQS_DE }</td>
                            <td class="b_l_0">${QUALF.PBLICTE_INSTT }</td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            </c:if>
	                
			<c:if test="${empmnMap.WTRC_DTLS_INPUT_AT == 'Y' }">
			<div class="list_bl">
				<h4 class="fram_bl">수상내역</h4>
			    <table class="table_form">
			        <caption>
			        수상내역
			        </caption>
			        <colgroup>
			        <col style="width:25%" />
			        <col style="width:20%" />
			        <col style="width:20%" />
			        <col style="width:35%" />
			        </colgroup>
			        <thead>
			        	<tr>
			             <th>수상명</th>
			             <th>발행기관</th>
			             <th>발행일</th>
			             <th>비고</th>
			       	 </tr>
			        </thead>
			        <tbody>
			        	<c:forEach items="${applyMap.AQTC }" var="AQTC">
			            <tr>
			                <td class="b_l_0">${AQTC.AQTC_NM }</td>
			                <td class="b_l_0">${AQTC.PBLICTE_INSTT }</td>
			                <td class="b_l_0">${AQTC.OCCRRNC_ON }</td>
			                <td class="b_l_0">${AQTC.RM }</td>
			            </tr>
			            </c:forEach>
			        </tbody>
			    </table>
			</div>
			</c:if>

			<div class="list_bl">
	            <h4 class="fram_bl">경력기술서/포트폴리오</h4>
                <table class="table_form m_b_10" style="width:100%;">
                    <caption>
                    경력기술서/포트폴리오
                    </caption>
                    <colgroup>
                    <col style="width:15%" />
                    <col style="width:*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="p_l_30">첨부</th>
                            <td class="b_l_0">
                            	<c:if test="${not empty applyMap.HIST_FILE_SEQ1 }" >
                            	${applyMap.HIST_FILE1} [${applyMap.HIST_FILE_SIZE1 }]
                            	</c:if>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
	                
            <c:if test="${not empty empmnMap.QUEST1 or not empty empmnMap.QUEST2 or
    			not empty empmnMap.QUEST3 or not empty empmnMap.QUEST4 or not empty empmnMap.QUEST5 }">
    		<div class="list_bl">
             <h4 class="fram_bl">지원자에게 묻습니다.</h4>
             <c:if test="${not empty empmnMap.QUEST1 }">
              <div class="view_zone">
                  <h5>${empmnMap.QUEST1 } ( ${empmnMap.LMTT_LT1 }자 내 ) </h5>
                  <div class="my_info2">${applyMap.ANSWER1 }</div>
              </div>
             </c:if>
             <c:if test="${not empty empmnMap.QUEST2 }">
              <div class="view_zone">
                  <h5>${empmnMap.QUEST2 } ( ${empmnMap.LMTT_LT2 }자 내 ) </h5>
                  <div class="my_info2">${applyMap.ANSWER2 }</div>
              </div>
             </c:if>
             <c:if test="${not empty empmnMap.QUEST3 }">
              <div class="view_zone">
                  <h5>${empmnMap.QUEST3 } ( ${empmnMap.LMTT_LT3 }자 내 ) </h5>
                  <div class="my_info2">${applyMap.ANSWER3 }</div>
              </div>
             </c:if>
             <c:if test="${not empty empmnMap.QUEST4 }">
              <div class="view_zone">
                  <h5>${empmnMap.QUEST4 } ( ${empmnMap.LMTT_LT4 }자 내 ) </h5>
                  <div class="my_info2">${applyMap.ANSWER4 }</div>
              </div>
             </c:if>
             <c:if test="${not empty empmnMap.QUEST5 }">
              <div class="view_zone">
                  <h5>${empmnMap.QUEST5 } ( ${empmnMap.LMTT_LT5 }자 내 ) </h5>
                  <div class="my_info2">${applyMap.ANSWER5 }</div>
              </div>
             </c:if>
             </div>
            </c:if>
             
            <!--//페이지버튼-->
            <div class="btn_bl">
            	<a class=wht href="#" id="btn_list">목록</a>
            	<c:if test="${PRINCIPAL == 'Y' }" >
            		<c:if test="${empmnMap.CLOSED == 0 }">
             		<a class="blu" href="#" id="btn_mod">수정</a>
             	</c:if>
             	<a href="#" id="btn_del">삭제</a>
             	<c:if test="${applyMap.RCEPT_AT == 'Y'}" >
             		<a class="gr" href="#" id="btn_cancel">입사지원취소</a>
             	</c:if>
            	</c:if>
            </div>
            <!--페이지버튼//-->
	
	        <!--sub contents //-->
	    </div>
	    <!--container_popup 마침-->
	</div>
</div>

</body>
</html>