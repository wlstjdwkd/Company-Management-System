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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>정보</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask" />
<ap:jsTag type="tech" items="acm,msg,util,ms" />

<script type="text/javascript">

$().ready(function(){
	
	<c:if test="${not empty rtnMsg}">
	jsMsgBox(null, "info", '${rtnMsg}');
	</c:if>
	
	//목록 버튼
	$("#btn_list").click(function(){
		$("#df_method_nm").val("");
		$("#dataForm").submit();
	});
	
	//수정 버튼
	$("#btn_mod").click(function(){
		$("#df_method_nm").val("userInfoWriteForm");
		$("#ad_form_type").val("UPDATE");		
		
		$("#dataForm").submit();
	});
	
	//비밀번호 초기화 버튼 (기존)
	/* $("#btn_pwd_init").click(function() {
		jsMsgBox(null, "confirm", Message.msg.initlPwdConfirm, function(){
			
			if(${dataMap.emplyrTy eq 'GN' }) {
				$("#hi_target_user_nm").val("${dataMap.userNm }");
			}
			else if(${dataMap.emplyrTy eq 'EP' }) {
				$("#hi_target_user_nm").val("${dataMap.chargerNm }");
			}
			
			$.ajax({
				url      : "${svcUrl}",
				type     : "post",			
				dataType : "json",
				data	 : {
							"df_method_nm"	: "updateInitializePwd",
							"ad_user_no" : $("#ad_user_no").val(),	
							"ad_userNm" : $("#hi_target_user_nm").val(),
							},
				async    : false,
				success  : function(response) {
					try {					
						if(response.result) {						
							jsMsgBox(null, "info", "임시 비밀번호가 발송되었습니다.");					
						} else {
							jsMsgBox(null, "error", Message.msg.processFail);
						}
					} catch (e) {
						jsSysErrorBox(response, e);
						return;
					}                            
				}
			});	
		});	
	}); */
	
	// 비밀번호 초기화 버튼 (변경)
	$("#btn_init").click(function() {
		var pwd1 = $("#init_pwd").val();
		var pwd2 = $("#init_pwd_chk").val();
		if(pwd1 == null || pwd1 == '' || pwd1 == undefined) {
			jsMsgBox(null, "info", "초기화할 비밀번호를 입력해주세요.");
			return;
		}
		if(pwd2 == null || pwd2 == '' || pwd2 == undefined) {
			jsMsgBox(null, "info", "확인 비밀번호를 입력해주세요.");
			return;
		}
		if(pwd1 != pwd2) {
			jsMsgBox(null, "info", "초기화할 비밀번호와 확인 비밀번호가 다릅니다.");
			return;
		}

		jsMsgBox(null, "confirm", Message.msg.initlPwdConfirm, function() {
			if(${dataMap.emplyrTy eq 'GN'}) {
				$("#hi_target_user_nm").val("${dataMap.userNm }");
			} else if(${dataMap.emplyrTy eq 'EP'}) {
				$("#hi_target_user_nm").val("${dataMap.chargerNm }");
			}

			$.ajax({
				url      : "${svcUrl}",
				type     : "post",
				dataType : "json",
				async    : false,
				data     : {
					"df_method_nm" : "updateInitializePwd2",
					"ad_user_no"   : $("#ad_user_no").val(),
					"ad_userNm"    : $("#hi_target_user_nm").val(),
					"init_pwd"     : pwd1
				},
				success  : function(response) {
					if(response) {
						jsMsgBox(null, "info", "비밀번호를 초기화 했습니다.");
					} else {
						jsMsgBox(null, "info", "비밀번호 초기화에 실패했습니다.");
					}
				}
			});
		});
	})
	
	// 권한설정 팝업
	$("#btn_authSet").click(function(){	
		$.colorbox({
			title : "회원권한설정",
			href : "<c:url value='/PGCMUSER0010.do?df_method_nm=getAuthList' />",
			width : "800",
			height : "300",
			overlayClose : false,
			escKey : false,
			iframe : true
		});
	});
});
/* $("a[name=boardViewBtn]").colorbox({
	title : bbsNm,
	//href  : "<c:url value='/intra/board/BD_board.list.do?bbsCd=' />" + bbsCd + "&superAdmYn=" + "${superAdmYn}",
	href  : "<c:url value='/PGMS0081.do?bbsCd=' />" + bbsCd,						
	width : "80%", height:"100%",
	iframe: true
}); */
</script>

</head>
<body>

	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
	
	<ap:include page="param/defaultParam.jsp" />
	<ap:include page="param/dispParam.jsp" />
	<ap:include page="param/pagingParam.jsp" />
	
	<input type="hidden" id="ad_user_no" name="ad_user_no" value="${dataMap.userNo }" />
	<input type="hidden" id="ad_form_type" name="ad_form_type" />
	
	<input type="hidden" id="hi_target_user_no" value="${dataMap.userNo }" />
	<input type="hidden" id="hi_target_user_nm" />	
	
	<!-- 검색유지 조건 -->
	<input type="hidden" id="param_chk_emplyrTys" name="param_chk_emplyrTys" value="${param.param_chk_emplyrTys}"/>
	<input type="hidden" id="param_chk_authorGroupCodes" name="param_chk_authorGroupCodes" value="${param.param_chk_authorGroupCodes}" />
	<input type="hidden" id="ad_emplyrTys" name="ad_emplyrTys" value="${param.ad_emplyrTys}"/>
	<input type="hidden" id="ad_authorGroupCodes" name="ad_authorGroupCodes" value="${param.ad_authorGroupCodes}" />
	<input type="hidden" id="search_start_dt" name="search_start_dt" value="${param.search_start_dt}"/>
	<input type="hidden" id="search_end_dt" name="search_end_dt" value="${param.search_end_dt}" />
	<input type="hidden" id="ad_rgsde_start_dt" name="ad_rgsde_start_dt" value="${param.ad_rgsde_start_dt }"/>
	<input type="hidden" id="ad_rgsde_end_dt" name="ad_rgsde_end_dt" value="${param.ad_rgsde_end_dt}" />
	<input type="hidden" id="ad_search_type" name="ad_search_type" value="${param.ad_search_type}"/>
	<input type="hidden" id="ad_search_word" name="ad_search_word" value="${param.ad_search_word}" />

	<!--//content-->
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title_line">회원관리</h2>
                <!-- 타이틀 영역 //-->

                <!--// table -->
                <div class="block">
                    <h3 class="mgt30">로그인 정보</h3>
                    <!--// 등록 -->
                    <table cellpadding="0" cellspacing="0" class="table_basic" summary="로그인 회원정보상세 보기">
                        <caption>
                        로그인 회원정보상세 보기
                        </caption>
                        <colgroup>
                        <col width="15%" />
                        <col width="*" />
                        </colgroup>
                        <tr>
                            <th scope="row"><label for="searchWrd20"> 아이디</label></th>
                            <td>
                            ${dataMap.loginId }
                            <c:if test="${dataMap.sttus eq '03' }">
	                            <div class="btn_inner">
                            		<a href="#" class="btn_in_gray"><span>탈퇴회원</span></a>
                            	</div>
                            </c:if>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">비밀번호 초기화</th>
                            <td>
                                <div class="btn_inner">
                                	<input type="password" name="init_pwd" id="init_pwd" placeholder="새 비밀번호를 입력하세요." value=""/>
	                            		<input type="password" name="init_pwd_chk" id="init_pwd_chk" placeholder="다시 한번 입력해주세요." value=""/>
	                            		<a href="#" class="btn_in_gray" id="btn_init"><span>초기화 적용</span></a></div>
                                	<!-- <a href="#" class="btn_in_gray" id="btn_pwd_init"><span>비밀번호초기화 | 임시 비밀번호 발송 </span></a> -->
                                	<!-- <a href="#" class="btn_in_gray"><span>임시 비밀번호 발송</span></a></div> -->
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">회원권한</th>
                            <td>
                            	<span class="mgr30">
                            		<c:forEach items="${authGrp }" var="authCd" varStatus="status">
                            			<c:choose>
                            				<c:when test="${authCd == AUTH_DIV_ADM }">운영담당자</c:when>
                            				<c:when test="${authCd == AUTH_DIV_PUB }">인사담당자</c:when>
                            				<c:when test="${authCd == AUTH_DIV_BIZ }">이사진</c:when>
                            				<c:when test="${authCd == AUTH_DIV_ENT }">영업담당자</c:when>
                            				<c:when test="${authCd == AUTH_DIV_EMP }">사원</c:when>
                            			</c:choose>
                            			<c:if test="${not status.last }">
                            				<c:out value=" | "></c:out>
                            			</c:if>
                            		</c:forEach>
                            	</span> 
                            	<div class="btn_inner">
                            		<a href="#" id="btn_authSet" class="btn_in_gray"><span>회원권한설정</span></a>
                            	</div>
                           	</td>
                        </tr>
                        <tr>
                            <th scope="row">회원분류</th>
                            <td>
								<c:choose>
                           			<c:when test="${dataMap.emplyrTy eq EMPLYR_TY_EP }">기업회원</c:when>
                           			<c:when test="${dataMap.emplyrTy eq EMPLYR_TY_GN }">일반회원</c:when>
                           			<c:when test="${dataMap.emplyrTy eq EMPLYR_TY_JB }">기관회원</c:when>	                                       				                                       			
                           		</c:choose>	
							</td>
                        </tr>
                    </table>
                </div>
                <!--table //-->
                
                
                <!--// table -->
                <!-- 기관회원 -->               
               	<c:if test="${dataMap.emplyrTy eq 'JB' }">
               	<div class="block">
                    <h3 class="mgt30">기관담당자(개인)정보</h3>
                    <!--// 등록 -->
                    <table cellpadding="0" cellspacing="0" class="table_basic" summary=" 기업정보상세보기">
                        <caption>
                        기업정보상세보기
                        </caption>
                        <colgroup>
                        <col width="15%" />
                        <col width="*" />
                        </colgroup>
                        <tr>
                            <th scope="row"><label for="searchWrd20"> 이름</label></th>
                            <td>${dataMap.userNm }</td>
                        </tr>
                        <tr>
                            <th scope="row">소속부서</th>
                            <td>${dataMap.deptNm }</td>
                        </tr>
                        <tr>
                            <th scope="row">직위</th>
                            <td></td>
                        </tr>
                        <tr>
                            <th scope="row">전화번호</th>
                            <td>${dataMap.telno }</td>
                        </tr>
                        <tr>
                            <th scope="row">휴대전화번호</th>
                            <td></td>
                        </tr>
                        <tr>
                            <th scope="row">이메일</th>
                            <td>${dataMap.email }</td>
                        </tr>
                        <tr>
                            <th scope="row">이메일수신</th>
                            <td>
                            	<c:choose>
                            		<c:when test="${dataMap.emailRecptnAgre == 'Y'}">신청</c:when>
                            		<c:otherwise>미신청</c:otherwise>
                            	</c:choose>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">SMS수신</th>
                            <td>
                            	<c:choose>
                            		<c:when test="${dataMap.smsRecptnAgre == 'Y'}">신청</c:when>
                            		<c:otherwise>미신청</c:otherwise>
                            	</c:choose>                            
                            </td>
                        </tr>
                    </table>
                </div>    
                </c:if>
                
                <!-- 일반회원 -->  
                <c:if test="${dataMap.emplyrTy eq 'GN' }">
                <div class="block">
	                 <h3 class="mgt30">개인정보</h3>
	                 <!--// 등록 -->
	                 <table cellpadding="0" cellspacing="0" class="table_basic" summary=" 기관담당자정보상세 보기">
	                     <caption>
	                     기관담당자정보상세 보기
	                     </caption>
	                     <colgroup>
	                     <col width="15%" />
	                     <col width="*" />
	                     </colgroup>
	                     <tr>
	                         <th scope="row"><label for="searchWrd20"> 이름</label></th>
	                         <td>${dataMap.userNm }</td>
	                     </tr>
	                     <tr>
	                         <th scope="row">휴대전화번호</th>
	                         <td>${dataMap.mbtlnum }</td>
	                     </tr>
	                     <tr>
	                         <th scope="row">이메일</th>
	                         <td>${dataMap.email }</td>
	                     </tr>	                     
	                     <tr>
                            <th scope="row">이메일수신</th>
                            <td>
                            	<c:choose>
                            		<c:when test="${dataMap.emailRecptnAgre == 'Y'}">신청</c:when>
                            		<c:otherwise>미신청</c:otherwise>
                            	</c:choose>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">SMS수신</th>
                            <td>
                            	<c:choose>
                            		<c:when test="${dataMap.smsRecptnAgre == 'Y'}">신청</c:when>
                            		<c:otherwise>미신청</c:otherwise>
                            	</c:choose>                            
                            </td>
                        </tr>
	                 </table>
                </div>   
                </c:if>
                 
                <!-- 기업회원 --> 
                <c:if test="${dataMap.emplyrTy eq 'EP' }">
                <div class="block">
                    <h3 class="mgt30">기업정보</h3>
                    <!--// 등록 -->
                    <table cellpadding="0" cellspacing="0" class="table_basic" summary=" 기관담당자정보상세 보기">
                        <caption>
                        기관담당자정보상세 보기
                        </caption>
                        <colgroup>
                        <col width="15%" />
                        <col width="*" />
                        </colgroup>
                        <tr>
                            <th scope="row"><label for="searchWrd20"> 기업명</label></th>
                            <td>${dataMap.entrprsNm }</td>
                        </tr>
                        <tr>
                            <th scope="row">대표자명</th>
                            <td>${dataMap.rprsntvNm }</td>
                        </tr>
                        <tr>
                            <th scope="row">법인등록번호</th>
                            <td>${dataMap.jurirno }</td>
                        </tr>
                        <tr>
                            <th scope="row">사업자등록번호</th>
                            <td>${dataMap.bizrno }</td>
                        </tr>
                        <tr>
                            <th scope="row">주소</th>
                            <td>${dataMap.hedofcAdres }</td>
                        </tr>
                        <tr>
                            <th scope="row">전화번호</th>
                            <td>${dataMap.telno }</td>
                        </tr>
                        <tr>
                            <th scope="row">팩스번호</th>
                            <td>${dataMap.fxnum }</td>
                        </tr>
                    </table>
                </div>
                <!--table //-->
                
                <!--// table -->
                <div class="block">
                    <h3 class="mgt30">책임자정보</h3>
                    <!--// 등록 -->
                    <table cellpadding="0" cellspacing="0" class="table_basic" summary="책임자정보상세보기">
                        <caption>
                       책임자정보상세보기
                        </caption>
                        <colgroup>
                        <col width="15%" />
                        <col width="*" />
                        </colgroup>
                        <tr>
                            <th scope="row"><label for="searchWrd20"> 책임자이름</label></th>
                            <td>${manager.chargerNm }</td>
                        </tr>
                        <tr>
                            <th scope="row">소속부서</th>
                            <td>${manager.chargerDept }</td>
                        </tr>
                        <tr>
                            <th scope="row">직위</th>
                            <td>${manager.ofcps }</td>
                        </tr>
                        <tr>
                            <th scope="row">전화번호</th>
                            <td>${manager.telNo.first }-${manager.telNo.middle }-${manager.telNo.last }</td>
                        </tr>
                        <tr>
                            <th scope="row">휴대전화번호</th>
                            <td>${manager.mbtlNum.first }-${manager.mbtlNum.middle }-${manager.mbtlNum.last }</td>
                        </tr>
                        <tr>
                            <th scope="row">이메일</th>
                            <td>${manager.email }</td>
                        </tr>
                        <tr>
                            <th scope="row">이메일수신</th>
                            <td>
                            	<c:choose>
                            		<c:when test="${manager.emailRecptnAgre == 'Y'}">신청</c:when>
                            		<c:otherwise>미신청</c:otherwise>
                            	</c:choose>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">SMS수신</th>
                            <td>
                            	<c:choose>
                            		<c:when test="${manager.smsRecptnAgre == 'Y'}">신청</c:when>
                            		<c:otherwise>미신청</c:otherwise>
                            	</c:choose>                            
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">수정일</th>
                            <td>
                            	${manager.updde }
                            </td>
                        </tr>
                    </table>
                </div>	
                <!--table //-->
                
                <!--// table -->
                <div class="block">
                    <h3 class="mgt30">담당자(본인)정보</h3>
                    <!--// 등록 -->
                    <table cellpadding="0" cellspacing="0" class="table_basic" summary="담당자(본인)정보상세보기">
                        <caption>
                        담당자(본인)정보상세보기
                        </caption>
                        <colgroup>
                        <col width="15%" />
                        <col width="*" />
                        </colgroup>
                        <tr>
                            <th scope="row"><label for="searchWrd20"> 담당자이름</label></th>
                            <td>${dataMap.chargerNm }</td>
                        </tr>
                        <tr>
                            <th scope="row">소속부서</th>
                            <td>${dataMap.chargerDept }</td>
                        </tr>
                        <tr>
                            <th scope="row">직위</th>
                            <td>${dataMap.ofcps }</td>
                        </tr>
                        <tr>
                            <th scope="row">전화번호</th>
                            <td>${dataMap.telno2 }</td>
                        </tr>
                        <tr>
                            <th scope="row">휴대전화번호</th>
                            <td>${dataMap.mbtlnum }</td>
                        </tr>
                        <tr>
                            <th scope="row">이메일</th>
                            <td>${dataMap.email }</td>
                        </tr>
                        <tr>
                            <th scope="row">이메일수신</th>
                            <td>
                            	<c:choose>
                            		<c:when test="${dataMap.emailRecptnAgre == 'Y'}">신청</c:when>
                            		<c:otherwise>미신청</c:otherwise>
                            	</c:choose>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">SMS수신</th>
                            <td>
                            	<c:choose>
                            		<c:when test="${dataMap.smsRecptnAgre == 'Y'}">신청</c:when>
                            		<c:otherwise>미신청</c:otherwise>
                            	</c:choose>                            
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">수정일</th>
                            <td>
                            	${dataMap.updde }
                            </td>
                        </tr>
                    </table>
                </div>	
                </c:if>  
                
                <!--table //-->
                
                <!--//버튼-->
                <div class="btn_page_last">
	                <a class="btn_page_admin" href="#" id="btn_list"><span>목록</span></a>
	                <a class="btn_page_admin" href="#" id="btn_mod"><span>수정</span></a>
                </div>
                <!--버튼//-->
            </div>
        </div>        
    </div>
    <!--content//-->
    
    </form>
</body>
</html>