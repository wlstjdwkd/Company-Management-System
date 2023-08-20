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
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask,blockUI" />
<ap:jsTag type="tech" items="acm,msg,util,ms,etc" />

<script type="text/javascript">

	$().ready(function() {
		
		// 달력 컴포넌트 init
		/*$('#search_start_dt').datepicker({
            showOn : 'button',
            defaultDate : null,
            buttonImage : '<c:url value="images/acm/icon_cal.png" />',
            buttonImageOnly : true,
            changeYear: true,
            changeMonth: true,
            yearRange: "1920:+1"
        });
        $('#search_end_dt').datepicker({
            showOn : 'button',
            defaultDate : null,
            buttonImage : '<c:url value="images/acm/icon_cal.png" />',
            buttonImageOnly : true,
            changeYear: true,
            changeMonth: true,
            yearRange: "1920:+1"
        });
        
        // MASK
        $('#search_start_dt').mask('0000-00-00');
        $('#search_end_dt').mask('0000-00-00');*/
		
        // 검색
		$("#btn_search").click(function(){
			
			$("#df_curr_page").val("1");
			$("#df_method_nm").val("");
			$("#dataForm").attr('action', '/PGCMUSER0010.do').submit();
		});
		$("#ad_search_word").keyup(function(e) {
			if(e.keyCode == 13) {
				
				$("#df_curr_page").val("1");
				$("#df_method_nm").val("");
				$("#dataForm").attr('action', '/PGCMUSER0010.do').submit();
			}
		});
				
		/*$("#dataForm").submit(function() {
			var chk_emplyrTys = "";
			var chk_authorGroupCodes = "";
			
			//달력 입력 format 제거
			$("#ad_rgsde_start_dt").val($('#search_start_dt').cleanVal());
			$("#ad_rgsde_end_dt").val($('#search_end_dt').cleanVal());
			
			//회원분류 checked params
			$("input[name='ad_emplyrTys']:checked").each(function() {
				chk_emplyrTys += "|" + $(this).val();				
			});
			$("#param_chk_emplyrTys").val(chk_emplyrTys);
			
			//회원권한 checked params
			$("input[name='ad_authorGroupCodes']:checked").each(function() {
				chk_authorGroupCodes += "|" + $(this).val();				
			});
			$("#param_chk_authorGroupCodes").val(chk_authorGroupCodes);
		});*/
		
		// 권한설정 팝업
		$("#btn_authSet").click(function(){
			var users = [];
			if($("input[name='chk_userNoes']:checked").length < 1) {
				jsMsgBox($(this), "info", Message.template.noSetTarget('회원권한설정 대상'));
				return;
			}
			
			$("input[name='chk_userNoes']:checked").each(function() {
				users.push($(this).val());
				$("#hi_target_user_no").val(users);
			});
			
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
		
		// 기존 등록버튼
		/* $("#btn_reg").click(function() {
			$("#df_method_nm").val("selectUserType");
			$("#dataForm").submit();
		}); */
		//등록버튼
		$("#btn_reg").click(function() {
			$("#df_method_nm").val("userInfoWriteForm");
			$("#ad_form_type").val("INSERT");
			$("#ad_join_type").val('${EMPLYR_TY_JB}');
			$("#dataForm").submit();
			
		})
		
		// Excel download
		$("#btn_excel").click(function(){
			$("#df_method_nm").val("excelDownUsrList");
			$("#dataForm").submit();
			//jsFiledownload("/PGCMUSER0010.do", $('#dataForm').formSerialize());
		});
		
		$("#ad_emplyrTys_All").click(function() {
			if($(this).is(":checked")) {				
				$("input[name='ad_emplyrTys']").each(function(){
					$(this).attr("checked", false);					
				});	
			}
		});
		$("#ad_authorGroupCodes_All").click(function() {
			if($(this).is(":checked")) {				
				$("input[name='ad_authorGroupCodes']").each(function(){
					$(this).attr("checked", false);					
				});	
			}
		});
		$("input[name='ad_emplyrTys']").click(function() {
			if($(this).is(":checked")) {				
				$("#ad_emplyrTys_All").attr("checked", false)
			}
		});
		$("input[name='ad_authorGroupCodes']").click(function() {
			if($(this).is(":checked")) {
				$("#ad_authorGroupCodes_All").attr("checked", false)
			}
		});
		
		$("#chk_all_list").click(function() {
			$("input[name='chk_userNoes']").prop('checked', this.checked);			
		});
		
		//회원 삭제 버튼
		$("#btn_del").click(function(){
			jsMsgBox(null, "confirm", "삭제하시겠습니까?", function() {
			
				//회원 삭제
				var chk_dellist = "";
				$("input[name='chk_userNoes']:checked").each(function() {
					chk_dellist += $(this).val() + ",";
				});
				$("#dellist").val(chk_dellist);
				console.log(chk_dellist);
				$("#df_method_nm").val("deleteUserInfo");
				$("#dataForm").submit();
			});
		});
		
	});
	
	var fn_user_view = function(user_no) {
		console.log("start");
		$("#ad_user_no").val(user_no);
		$("#df_method_nm").val("getUserInfoView");
		$("#dataForm").submit();
	};
	
</script>

</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
	
	<input type="hidden" id="ad_rgsde_start_dt" name="ad_rgsde_start_dt" />
	<input type="hidden" id="ad_rgsde_end_dt" name="ad_rgsde_end_dt" />
	
	<input type="hidden" id="param_chk_emplyrTys" name="param_chk_emplyrTys" />
	<input type="hidden" id="param_chk_authorGroupCodes" name="param_chk_authorGroupCodes" />
	<input type="hidden" id="dellist" name="dellist" />
	<input type="hidden" id="ad_search_type" name="ad_search_type" value="1" />
	
	<input type="hidden" id="ad_form_type" name="ad_form_type" />
	<input type="hidden" id="ad_join_type" name="ad_join_type" />
	
	<input type="hidden" id="ad_user_no" name="ad_user_no" />
	
	<ap:include page="param/defaultParam.jsp" />
	<ap:include page="param/dispParam.jsp" />
	<ap:include page="param/pagingParam.jsp" />
	
	<input type="hidden" id="hi_target_user_no" />
	
	<input type="hidden" id="init_search_yn" name="init_search_yn" value="N" />
	
	<!--//content-->
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">회원관리</h2>
                <!-- 타이틀 영역 //-->
                <div class="search_top">
                    <table cellpadding="0" cellspacing="0" class="table_search" summary="기업군 년도 업종 지역 지표 현황 조회 조건">
                        <caption>
                        현황 조회 조건
                        </caption>
                        <colgroup>
                        <col width="15%">
                        <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">이름</th>
                                <td>
                                    <input name="ad_search_word" id="ad_search_word" title="검색어를 입력하세요." placeholder="이름을 입력하세요." type="text" style="width:430px" value="${param.ad_search_word }" />
                                    <p class="btn_src_zone"><a href="#" class="btn_search" id="btn_search">검색</a></p>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- 등록// -->
                <!-- // 리스트영역-->
               <div class="block">
					<div class="btn_page_total">
	                	<a class="btn_page_admin" href="#" id="btn_authSet"><span>회원권한설정</span></a>
	                	<a class="btn_page_admin" href="#" id="btn_excel"><span>엑셀다운로드</span></a> 
                	</div>                    
                    <!--// 리스트 -->
                    <div class="list_zone">
                    		<ap:pagerParam />
                        <table cellspacing="0" border="0" summary="메뉴명 프로그램명 메뉴레벨 출력유형 출력여부 사이트구분 사용여부 리스트">
                            <caption>
                            메뉴관리리스트
                            </caption>
                            <colgroup>
                                <col width="5%">
                                <col width="5%">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                            </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col"><input type="checkbox" id="chk_all_list" value="1"></th>
                                        <th scope="col">번호</th>
                                        <th scope="col">회원이름</th>
                                        <th scope="col">직위</th>
                                        <th scope="col">전화번호</th>
                                        <th scope="col">휴대전화번호</th>
                                        <th scope="col">이메일</th>
                                        <th scope="col">가입일</th>
                                    </tr>
                                </thead>
                                <tbody>                                    
                                    <c:forEach items="${userList }" var="userlist" varStatus="status">
                                    	<tr>
	                                        <td><input type="checkbox" name="chk_userNoes" id="view_3" value="${userlist.userNo }"></td>
	                                        <td class="tac">${pager.indexNo - status.index}</td>
	                                        <td class="tac"><a href="#" onclick="fn_user_view('${userlist.userNo}')" >${userlist.userNm }</a></td>
	                                        <td>${userlist.ofcps }</td>
	                                        <td>${userlist.telno2 }</td>
	                                        <td>${userlist.mbtlnum }</td>
	                                        <td class="tal">${userlist.email }</td>
	                                        <td>${userlist.rgsde }</td>
	                                    </tr>                                    
                                    
                                    </c:forEach>
                                </tbody>
                            </table>
                      </div>
                    </div> 
                   	
                    <!-- 리스트// -->
                    <div class="btn_page_last">
                    	<a class="btn_page_admin" href="#none" id="btn_reg"><span>등록</span></a>
                    	<a class="btn_page_admin" href="#none" id="btn_del"><span>회원 삭제</span></a>
                    </div>
                    
                    <!--// paginate -->
                    <ap:pager pager="${pager}" />
                    <!-- paginate //-->
                    
                </div>
                <!--리스트영역 //-->
            </div>
            <!--content//-->
        </div>        
	</form>
</body>
</html>