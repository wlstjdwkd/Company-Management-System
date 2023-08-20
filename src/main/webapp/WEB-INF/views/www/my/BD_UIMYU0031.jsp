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
 	
	// 목록 버튼
	$("#btn_list").click(function(){
		$("#df_method_nm").val("");
		$("#dataForm").attr("action", "/PGMY0030.do").submit();
	});
	
	// 복사등록 버튼
	$("#btn_copy_reg").click(function(){
		$("#ad_form_type").val("COPY");
		$("#df_method_nm").val("empmnInfoForm");
		$("#dataForm").attr("action", "/PGMY0030.do").submit();
	});
	
	// 수정 버튼
	$("#btn_mod").click(function(){
		$("#ad_form_type").val("UPDATE");
		$("#df_method_nm").val("empmnInfoForm");
		$("#dataForm").attr("action", "/PGMY0030.do").submit();
	});
	
	// 삭제 버튼
	$("#btn_del").click(function(){
		<c:choose>
			<c:when test="${not empty applyList}">
			jsMsgBox(null,'warn',Message.msg.noDelPblanc);	
			</c:when>
			<c:otherwise>
			jsMsgBox(null,'confirm',Message.msg.delInfo, function() {
				$("#df_method_nm").val("deleteEmpmnInfo");
				$("#dataForm").attr("action", "/PGMY0030.do").submit();	
			});	
			</c:otherwise>
		</c:choose>				
	});
	
	// Excel 다운로드
	$("#btn_excel").click(function(){
		$("#df_method_nm").val("excelDownApplyList");			
		jsFiledownload("/PGMY0030.do", $('#dataForm').formSerialize());
	});
		
}); // ready

// 입사지원 상세보기
var fn_apply_view = function(userNo) {
	$("#ad_user_no").val(userNo);
	$("#df_method_nm").val("applyInfoView");
			
	var empmnInfoWindow = window.open('', 'empmnInfo', 'width=1400, height=680, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbars=yes');	
	document.dataForm.action = "/PGMY0020.do";
	document.dataForm.target = "empmnInfo";
	document.dataForm.submit();
	document.dataForm.target = "";
	if(empmnInfoWindow){
		empmnInfoWindow.focus();
	}
};

</script>

</head>
<body>
	<div id="wrap" class="top_bg">
		<c:set var="flag22" value="N"/>	<%-- 근무지역 --%>
		<c:set var="flag25" value="N"/>	<%-- 경력 --%>
		<c:set var="flag27" value="N"/>	<%-- 학력 --%>
		<c:set var="flag31" value="N"/>	<%-- 모집직급 --%>
		<c:set var="flag32" value="N"/>	<%-- 모집직책 --%>
		<c:set var="flag33" value="N"/>	<%-- 근무형태 --%>
		<c:set var="flag51" value="N"/>	<%-- 모집인원 --%>
		<c:set var="flag52" value="N"/>	<%-- 모집연령 --%>
		
		<c:set var="itemList" value="${dataMap.itemList }" />
		
		<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
			<div class="s_cont" id="s_cont">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />
		
				<input type="hidden" id="ad_empmn_manage_no" name="ad_empmn_manage_no" value="${dataMap.EMPMN_MANAGE_NO }" />
				<input type="hidden" id="ad_user_no" name="ad_user_no" />
				<input type="hidden" id="ad_form_type" name="ad_form_type" />
				<input type="hidden" id="pageNo" value="${indexInfo.pageNo}" /> <input type="hidden" id="rowSize" value="${indexInfo.rowSize}" />
			
				<div class="s_tit s_tit06">
					<h1>마이페이지</h1>
				</div>
				<div class="s_wrap">
					<div class="l_menu">
						<h2 class="tit tit6">마이페이지</h2>
						<ul>
						</ul>
					</div>
					<div class="r_sec">
						<div class="r_top">
							<ap:trail menuNo="${param.df_menu_no}" />
						</div>
						
						<div class="r_cont s_cont06_03">
							<div class="list_bl" style="margin-bottom: 39px;">
								<table class="table_form l_padding">
									<caption>채용관리</caption>
									<colgroup>
										<col width="172px">
										<col width="273px">
										<col width="173px">
										<col width="272px">
									</colgroup>
		                            <tbody>
		                                <tr>
		                                    <th class="p_l_30">신청시작일</th>
		                                    <td class="b_l_0">${dataMap.RCRIT_BEGIN_DE } ~ ${dataMap.RCRIT_END_DE }</td>
		                                    <th class="p_l_30">모집인원</th>
		                                    <td class="b_l_0">
		                                    	<c:forEach items="${itemList }" var="item">
		                                    		<c:if test="${item.PBLANC_IEM == '51' }" >                                    			
		                                    			<c:choose>
		                                    				<c:when test="${item.IEM_VALUE == 'A'}">${item.ATRB1 }명</c:when>
		                                    				<c:otherwise>${item.CODE_NM }</c:otherwise>
		                                    			</c:choose>                                    			                                   		
		                                    		</c:if>
		                                    	</c:forEach>
		                                    </td>
		                                </tr>
		                                <tr>
		                                    <th class="p_l_30">경력</th>
		                                    <td class="b_l_0">
		                                    	<c:forEach items="${itemList }" var="item">
		                                    		<c:if test="${item.PBLANC_IEM == '25' }" >
		                                    			<c:if test="${flag25 == 'Y' }" >, </c:if>
		                                    			${item.CODE_NM }
		                                    			<c:if test="${item.IEM_VALUE == 'CK2'}">
		                                    			(${item.ATRB1 }년 이상 ${item.ATRB2 }년 미만)
		                                    			</c:if>
		                                    			<c:set var="flag25" value="Y" />
		                                    		</c:if>
		                                    	</c:forEach>
		                                    </td>
		                                    <th class="p_l_30">근무형태</th>
		                                    <td class="b_l_0">
		                                    	<c:forEach items="${itemList }" var="item">
		                                    		<c:if test="${item.PBLANC_IEM == '33' }" >
		                                    			<c:if test="${flag33 == 'Y' }" >, </c:if>
		                                    			${item.CODE_NM }
		                                    			<c:set var="flag33" value="Y" />
		                                    		</c:if>
		                                    	</c:forEach>
		                                    </td>
		                                </tr>
		                                <tr>
		                                    <th class="p_l_30">학력</th>
		                                    <td class="b_l_0">
		                                    	<c:forEach items="${itemList }" var="item">
		                                    		<c:if test="${item.PBLANC_IEM == '27' }" >
		                                    			${item.CODE_NM }
		                                    			<c:if test="${item.ATRB1 != null and item.ATRB1 == 'Y' }" >- 졸업예정자 가능</c:if>
		                                    		</c:if>
		                                    	</c:forEach>
		                                    </td>
		                                    <th class="p_l_30">전공</th>
		                                    <td class="b_l_0"></td>
		                                </tr>
		                                <tr>
		                                    <th class="p_l_30">나이</th>
		                                    <td class="b_l_0" colspan="3">
		                                    	<c:forEach items="${itemList }" var="item">
		                                    		<c:if test="${item.PBLANC_IEM == '52' }" >
		                                    			<c:if test="${flag52 == 'Y' }" >, </c:if>
		                                    			${item.CODE_NM }
		                                    			<c:set var="flag52" value="Y" />
		                                    		</c:if>
		                                    	</c:forEach>
		                                    </td>                                    
		                                </tr>
		                                <tr>
		                                    <th class="p_l_30">근무지역</th>
		                                    <td class="b_l_0" colspan="3">
		                                    	<c:forEach items="${itemList }" var="item">
		                                    		<c:if test="${item.PBLANC_IEM == '22' }" >
		                                    			<c:if test="${flag22 == 'Y' }" >, </c:if>
		                                    			${item.CODE_NM }
		                                    			<c:set var="flag22" value="Y" />
		                                    		</c:if>
		                                    	</c:forEach>
		                                    </td>
		                                </tr>
		                                <!-- <tr>
		                                    <th scope="col">모집업종</th>
		                                    <td colspan="3">&nbsp;</td>
		                                </tr> -->
		                                <tr>
		                                    <th class="p_l_30">모집직종</th>
		                                    <td class="b_l_0" colspan="3">${dataMap.JSSFC }</td>
		                                </tr>
		                                <tr>
		                                    <th class="p_l_30">모집직급</th>
		                                    <td class="b_l_0">
		                                    	<c:forEach items="${itemList }" var="item">
		                                    		<c:if test="${item.PBLANC_IEM == '31' }" >
		                                    			<c:if test="${flag31 == 'Y' }" >, </c:if>
		                                    			${item.CODE_NM }
		                                    			<c:set var="flag31" value="Y" />
		                                    		</c:if>
		                                    	</c:forEach>
		                                    </td>
		                                    <th class="p_l_30">모집직책</th>
		                                    <td class="b_l_0">
		                                    	<c:forEach items="${itemList }" var="item">
		                                    		<c:if test="${item.PBLANC_IEM == '32' }" >
		                                    			<c:if test="${flag32 == 'Y' }" >, </c:if>
		                                    			${item.CODE_NM }
		                                    			<c:set var="flag32" value="Y" />
		                                    		</c:if>
		                                    	</c:forEach>
		                                    </td>
		                                </tr>
		                                <tr>
		                                    <th class="p_l_30">우대조건</th>
		                                    <td class="b_l_0" colspan="3">${dataMap.PVLTRT_CND }</td>
		                                </tr>
		                                <tr>
		                                    <th class="p_l_30">업무내용</th>
		                                    <td class="b_l_0" colspan="3">${dataMap.JOB_CN }</td>
		                                </tr>
		                                <tr>
		                                    <th class="p_l_30">경력요건</th>
		                                    <td class="b_l_0" colspan="3">${dataMap.CAREER_DETAIL_RQISIT }</td>
		                                </tr>
		                            </tbody>
		                        </table>
		                    </div>
		                    
							<!--// 버튼 -->
		                    <div class="btn_bl">
		                    	<a class="wht" href="#" id="btn_list"><span>목록</span></a>
		                    	<a class="gr" href="#" id="btn_copy_reg"><span>복사등록</span></a>
		                    	<a class="" href="#" id="btn_del"><span>삭제</span></a>
		                    	<a class="blu" href="#" id="btn_mod"><span>수정</span></a>
		                    </div>
		                    
		                    <c:if test="${dataMap.CLOSED30 == 0 }">
			                    
		                    <!--// 리스트 -->
		                    <div class="list_bl" style="margin-top: 92px;">
		                        <!--//페이지버튼-->
		                        
		                        <!--페이지버튼//-->
		                        <h4 class="fram_bl">지원자목록 <span style="color: #222;">( 총 지원자 수 : ${pager.totalRowCount } 명 )</span> 
		                        </h4>
		                        <div class="btn_bl" style="width:100%;"><a class="btn_page_blue"  style="float:right;margin-bottom: 10px;" href="#" id="btn_excel"><span>엑셀다운로드</span></a> </div>
		                        <div class="table_list">
			                        <table class="st_bl01 stb_gr01">
			                            <caption>
			                            	지원자목록
			                            </caption>
			                            <colgroup>
											<col width="62px">
											<col width="127px">
											<col width="271px">
											<col width="161px">
											<col width="118px">
											<col width="146px">
										</colgroup>
			                            <thead>
											<tr>
												<th>번호</th>
												<th>지원자 이름</th>
												<th>지원제목</th>
												<th>지원분야(직종)</th>
												<th>경력</th>
												<th>입사지원일</th>
											</tr>
										</thead>
			                            <tbody>                                
			                                <c:forEach items="${applyList }" var="applyMap" varStatus="status">
			                                <tr>
			                                    <td>${pager.indexNo - status.index}</td>
			                                    <td>${applyMap.NM }</td>
			                                    <td class="txt_l"><a href="#" onclick="fn_apply_view('${applyMap.USER_NO}')">${applyMap.APPLY_SJ }</a></td>
			                                    <td class="">${applyMap.APPLY_REALM }</td>                                    
			                                    <td>
			                                    	${applyMap.CAREER_DIV_NM }	                                    
			                                    </td>
			                                    <td>${applyMap.RCEPT_DE }</td>
			                                </tr>
			                                </c:forEach>                                                               
			                            </tbody>
			                        </table>
			                    </div>
			                    <!-- 리스트// -->
		                    
			                    <!--// paginate -->
			                    <%-- <ap:pager pager="${pager}" /> --%>
			                    <div style="text-align:center;"><ap:pager pager="${pager}" /></div>
			                    <!-- paginate //-->
			                    </div>
		                    </c:if>
		                </div>
		            </div>
	            </div>
	            <!--sub contents //-->
	        </div>
	    	<!-- 우측영역//-->
		</form>
	</div>
	<!--content//-->
</body>
</html>