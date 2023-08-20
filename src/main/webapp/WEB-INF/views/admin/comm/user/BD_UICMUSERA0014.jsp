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
$(document).ready(function(){
	<c:if test="${resultMsg != null}">
	$(function(){
		jsMsgBox(null, "info", "${resultMsg}");
	});
</c:if>

	// MASK
	$('#ad_phon_middle').mask('0000');
	$('#ad_phon_last').mask('0000');
	
	// 유효성 검사
	$("#dataForm").validate({  
		rules : {  				
    			ad_user_id: {    				
    				required: true,
    				minlength: 8,
    				maxlength: 20,
    				alphanumeric: true,
    				firstAlpha: true,			// 첫글자는 영문
    				includeAlphaAtLeast2: true	// 최소 영문 2글자 포함
    			},
    			ad_user_pw: {
    				required: true,
    				minlength: 8,
    				maxlength: 20,
    				noDigitsIncOrDec: true,		// 3자 이상 연속된 숫자(오름,내림)
    				noIdenticalNum: true,		// 3자 이상 동일한 숫자 
    				noAlphaInc: true,			// 3자 이상 연속된 영문(오름)
    				noAlphaDec: true,			// 3자 이상 연속된 영문(내림)
    				noIdenticalWord: true,		// 3자 이상 동일한 영문
    				chekDuplWord : "ad_user_id",// 3자 이상 아이디와 동일한 단어
    				noRefusedSpeChar: true,		// 사용할 수 없는 특수 문자
    				noRefusedWord: true,		// 사용할 수 없는 단어
    			},
    			ad_confirm_password: {
    				required: true,
    				minlength: 8,
    				maxlength: 20,
    				equalTo: "#ad_user_pw"
    			},// 권한설정
    			ad_chk_auth: {
    				required: true
    			},    			
    			ad_phon_middle: { 	
    				required: true
    			},
    			ad_phon_last: { 	
    				required: true    			 
    			},
    			ad_user_email: {
    				required: true,
    				email: true,
    				maxlength: 100
    			},
    			
			},
		submitHandler: function(form) {
			
			// 아이디 중복 검사 여부 확인
			<c:if test="${formType != 'UPDATE'}">
			var isValidId = $('#ad_chk_id').val();
			if(Util.str.toUpperCase(isValidId)=="N"){
				jsMsgBox($("#btn_dupl_user"),'info',Message.template.chkDuplInfo('아이디'));
				return;
			}
			</c:if>
			
			var pattern1 = /[0-9]/;
			var pattern2 = /[a-zA-Z]/;
			var pattern3 = /[~!@\$%^&*]/;
			var checkpwd = false;
			
			if($("#ad_form_type").val() == "INSERT") {
				if(checkpwd == false) {
					// 비밀번호 수가 10자리 이상이면
					if($("#ad_user_pw").val().length >= 10) {
						// 영문자, 숫, 특수문자 중 2가지 이상
						// 영문+숫자, 숫자+특수문자, 영문+특수문자, 영문+숫자+특수문자
						if(((pattern1.test($("#ad_user_pw").val()) && pattern2.test($("#ad_user_pw").val())) || (pattern2.test($("#ad_user_pw").val()) && pattern3.test($("#ad_user_pw").val())) || (pattern3.test($("#ad_user_pw").val()) && pattern1.test($("#ad_user_pw").val())) || (pattern1.test($("#ad_user_pw").val()) && pattern2.test($("#ad_user_pw").val()) && pattern3.test($("#ad_user_pw").val())))) {
							checkpwd = true;
						}
						else {
							jsMsgBox($("#ad_user_pw"), 'warn', '비밀번호가 10자리 이상일 경우 비밀번호는 영문, 숫자, 특수문자 중 2가지 이상 포함해야 합니다.',function(){return;});
						}
					// 비밀번호 수가 8자리 이상이면
					}else {
						// 영문+숫자+특수문자 포함
						if(!pattern1.test($("#ad_user_pw").val()) || !pattern2.test($("#ad_user_pw").val()) || !pattern3.test($("#ad_user_pw").val())) {
							jsMsgBox($("#ad_user_pw"), 'warn', '비밀번호가 8자리 이상일 경우 비밀번호는 영문, 숫자, 특수문자를 모두 포함해야 합니다.',function(){return;});
						}
						else {
							checkpwd = true;
						}
					}
				}
			}
			else {
				checkpwd=true;
			}
			
			if(checkpwd == true) {
				// 휴대전화번호 조립
				var ad_phon_first 	= $('#ad_phon_first').val();
				var ad_phon_middle 	= $('#ad_phon_middle').val();
				var ad_phon_last 	= $('#ad_phon_last').val();			
				var ad_phone_num = ""+ad_phon_first+ad_phon_middle+ad_phon_last;
				$('#ad_phone_num').val(ad_phone_num);
				
				// 휴대전화, 이메일 중복 확인
				$.ajax({
	                url      : "PGCMLOGIO0040.do",
	                type     : "POST",
	                dataType : "json",
	                data     : { df_method_nm	: "checkDuplGnrlUserInfo"
	                			,"ad_phone_num"	: $('#ad_phone_num').val()
	                			,"ad_user_email": $('#ad_user_email').val()
	                			,"ad_user_no": '${dataVO.userNo }'
	                		   },                
	                async    : false,                
	                success  : function(response) {
	                	try {
	                        if(response.result) {
	                        	<c:if test="${formType == 'UPDATE'}">
	                        	$("#df_method_nm").val("updateUserInfo");
	                        	</c:if>
	                        	<c:if test="${formType == 'INSERT'}">
	                        	$("#df_method_nm").val("insertUserInfo");
	                        	</c:if>
	                        	
	                        	form.submit();
	                        } else {                        	 
	                        	if(response.value.reason == 'duplPhonNum'){
	                        		// duplPhonNum
	                        		jsMsgBox($("#btn_dupl_user"),'info',Message.template.existInfo('휴대전화번호'));
	                        	}else{
	                        		// duplEmail
	                        		jsMsgBox($("#ad_user_email"),'info',Message.template.existInfo('이메일'));
	                        	}
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
			}
		}
	});
	
	// 회원가입
	$("#btn_join").click(function(){
		$("#dataForm").submit();
	});
	
	// 아이디 중복 체크
    $("#btn_dupl_user").click(function(){
    	var isvalid = $('#ad_user_id').valid();
    	
    	if(!isvalid){
    		jsMsgBox($("#ad_user_id"),'info',Message.template.wrongInfo('아이디'));
    		return;
    	}
    	
   		$.ajax({
               url      : "PGCMLOGIO0040.do",
               type     : "POST",
               dataType : "text",
               data     : { df_method_nm: "checkDuplUserId", ad_user_id: $('#ad_user_id').val()},
               async    : false,                
               success  : function(response) {
               	try {
						var msgParam = '아이디';
	                   	if(eval(response)) {
	                   		jsMsgBox($("#btn_dupl_user"),'info',Message.template.validInfo(msgParam));
	                   		$('#ad_chk_id').val('Y');
	                   } else {
	                   		jsMsgBox($("#btn_dupl_user"),'info',Message.template.existInfo(msgParam));
	                   		$('#ad_chk_id').val('N');
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
	
    // 아이디 변경시 중복체크 여부 N 처리
    $('#ad_user_id').change(function() {
		$('#ad_chk_id').val('N');		
    });
    
    // 취소
    $("#btn_cancel").click(function() {
    	$("#df_method_nm").val("");
    	document.dataForm.submit();
    });
	
});
</script>

</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
	<ap:include page="param/defaultParam.jsp" />
	<ap:include page="param/dispParam.jsp" />
	<ap:include page="param/pagingParam.jsp" />
	
	<input type="hidden" name="ad_chk_id" id="ad_chk_id" value="N" />	
	<input type="hidden" name="ad_join_type" id="ad_join_type" value="${dataVO.emplyrTy }" />	
	<input type="hidden" name="ad_phone_num" id="ad_phone_num" />
	
	<input type="hidden" name="ad_form_type" id="ad_form_type" value="${formType }" />
	<input type="hidden" name="ad_user_no" id="ad_user_no" value="${dataVO.userNo }" />	
	
	<!--//content-->
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title_line">회원관리</h2>
                <!-- 타이틀 영역 //-->
                <!--// table -->
                <div class="block">
                
                	<!-- 공통 입력 사항 -->
                    <h3  class="mgt30">로그인 정보<span>항목은 입력 필수 항목 입니다.</span></h3>
                    <table cellpadding="0" cellspacing="0" class="table_basic" summary="회원가입정보 입력" >
                        <caption>
                        회원가입정보 입력
                        </caption>
                        <colgroup>
                        <col width="25%" />
                        <col width="*" />
                        </colgroup>
                                                
                        <c:if test="${formType == 'INSERT'}" >
                        <tr>
                            <th scope="row" class="point"><label for="ad_user_id"> 아이디</label></th>
                            <td><input name="ad_user_id" type="text" id="ad_user_id" class="text" placeholder="사용하실 아이디를 입력해 주세요." onfocus="this.placeholder=''; return true" style="width:395px;"/>
                                <div class="btn_inner ml10"><a href="#" id="btn_dupl_user" class="btn_in_gray"><span>중복체크</span></a></div></td>
                        </tr>
                        <tr>
                            <th scope="row" class="point"><label for="ad_user_pw"> 비밀번호</label></th>
                            <td><input name="ad_user_pw" type="password" id="ad_user_pw" class="text" placeholder="비밀번호를 입력해 주세요." onfocus="this.placeholder=''; return true" style="width:395px;"/></td>
                        </tr>
                        <tr>
                            <th scope="row" class="point"><label for="ad_confirm_password"> 비밀번호 확인</label></th>
                            <td><input name="ad_confirm_password" type="password" id="ad_confirm_password" class="text" placeholder="위 입력하신 비밀번호를 다시 한번 입력해 주세요." onfocus="this.placeholder=''; return true" style="width:395px;"/></td>
                        </tr>
                        </c:if>
                        <c:if test="${formType == 'UPDATE'}" >
                        <tr>
                            <th scope="row"><label for="ad_user_id"> 아이디</label></th>
                            <td>${dataVO.loginId }</td>
                        </tr>
                        </c:if>
                        
                        <c:set var="tempAuth" value="" />
                        <c:forEach items="${dataMap.authGroup }" var="authGroup" >
                        	 <c:set var="tempAuth" value="${tempAuth }|${authGroup }" />
                        </c:forEach>
                        <tr>
                            <th scope="row" class="point">권한설정</th>
                            <td>
                            	<input type="checkbox" name="ad_chk_auth" id="ad_chk_auth_1" <c:if test="${fn:contains(tempAuth, AUTH_DIV_ADM)}" >checked</c:if> value="${AUTH_DIV_ADM }" />
                                <label for="ad_chk_auth_1" class="mgr30">운영자</label>
                                <input type="checkbox" name="ad_chk_auth" id="ad_chk_auth_2" <c:if test="${fn:contains(tempAuth, AUTH_DIV_PUB)}" >checked</c:if> value="${AUTH_DIV_PUB }" />
                                <label for="ad_chk_auth_2" class="mgr30">인사담당자</label>
                                <input type="checkbox" name="ad_chk_auth" id="ad_chk_auth_3" <c:if test="${fn:contains(tempAuth, AUTH_DIV_BIZ)}" >checked</c:if> value="${AUTH_DIV_BIZ }" />
                                <label for="ad_chk_auth_3" class="mgr30">이사진</label>
                                <input type="checkbox" name="ad_chk_auth" id="ad_chk_auth_4" <c:if test="${fn:contains(tempAuth, AUTH_DIV_ENT)}" >checked</c:if> value="${AUTH_DIV_ENT }" />
                                <label for="ad_chk_auth_4" class="mgr30">영업담당자</label>
                                <input type="checkbox" name="ad_chk_auth" id="ad_chk_auth_5" <c:if test="${fn:contains(tempAuth, AUTH_DIV_EMP)}" >checked</c:if> value="${AUTH_DIV_EMP }" />
                                <label for="ad_chk_auth_5" class="mgr30">사원</label>
                            </td>
                        </tr>
                    </table>
                    <!--table //-->
                    
                    <!-- 개인회원 입력사항 -->                    
                    <div class="block">
                        <h3 class="mgt30">개인회원정보</h3>
                        <!--// 등록 -->
                        <table cellpadding="0" cellspacing="0" class="table_basic" summary="" >
                            <caption>
                            </caption>
                            <colgroup>
                            <col width="25%" />
                            <col width="*" />
                            </colgroup>
                            <tr>
                                <th scope="row" class="point"><label for="ad_user_nm"> 이름</label></th>
                                <td><input name="ad_user_nm" type="text" id="ad_user_nm" value="${dataVO.userNm }" class="text" style="width:395px;"  placeholder="이름을 입력해 주세요." /></td>
                            </tr>
                            <tr>
                                <th scope="row" class="point"><label for="ad_phon_first"> 휴대전화번호</label></th>
                                <td><select name="ad_phon_first" id="ad_phon_first" style="width:101px; ">
                                        <c:forTokens items="${MOBILE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
											<option value="${firstNum }" <c:if test="${dataMap.MBTLNUM1 == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
										</c:forTokens>	
                                    </select>
                                    ~
                                    <input name="ad_phon_middle" type="text" id="ad_phon_middle" value="${dataMap.MBTLNUM2 }" class="text"style="width:127px;" title="핸드폰가운데번호" />
                                    ~
                                    <input name="ad_phon_last" type="text" id="ad_phon_last" value="${dataMap.MBTLNUM3 }" class="text"style="width:127px;" title="핸드폰마지막번호" /></td>
                            </tr>
                            <tr>
                                <th scope="row" class="point"><label for="ad_user_email"> 이메일</label></th>
                                <td><input name="ad_user_email" type="text" id="ad_user_email" value="${dataVO.email }" class="text" style="width:395px;"  placeholder="이메일을 입력해 주세요." /></td>
                            </tr>
                            <tr>
                                <th scope="row"><label for="info16">이메일수신</label></th>
                                <td>
                                	<input name="ad_rcv_email" type="radio" id="ad_rcv_email" value="Y" <c:if test="${dataVO.emailRecptnAgre == 'Y' }">checked</c:if> />
                                	<label for="ad_rcv_email">신청</label>
                                	<input name="ad_rcv_email" type="radio" id="ad_rcv_email_reject" class="ml85" value="N" <c:if test="${dataVO.emailRecptnAgre == 'N' }">checked</c:if> />
                                	<label for="ad_rcv_email_reject">신청안함</label></td>
                            </tr>
                            <tr>
                                <th scope="row"><label for="info18">SMS수신</label></th>
                                <td>
                                	<input name="ad_rcv_sms" type="radio" id="ad_rcv_sms" value="Y" <c:if test="${dataVO.smsRecptnAgre == 'Y' }">checked</c:if> />
                                	<label for="ad_rcv_sms">신청</label>
                                	<input name="ad_rcv_sms" type="radio" id="ad_rcv_sms_reject" class="ml85" value="N" <c:if test="${dataVO.smsRecptnAgre == 'N' }">checked</c:if> />
                                	<label for="ad_rcv_sms_reject">신청안함</label></td>
                            </tr>
                        </table>
                    </div>                                                      
                    
                    <!--//버튼-->
                    <div class="btn_page_last">
                    	<a class="btn_page_admin" href="#" id="btn_cancel"><span>취소</span></a>
                    	<a class="btn_page_admin" href="#" id="btn_join"><span>확인</span></a>
                    </div>
                    <!--버튼//-->
                </div>
            </div>
            <!--content//-->
        </div>
    </div>
    </form>
</body>
</html>