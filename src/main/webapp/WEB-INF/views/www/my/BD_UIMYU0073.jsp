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
<title>내정보관리|기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery, colorbox, jqGrid, notice, css, validate, form, mask, msgBox, jBox" />
<ap:jsTag type="tech" items="font,cmn,mainn,subb, my, msg,util" />
<script type="text/javascript">

	$(document).ready(function(){
		if($("#dataForm").action != "/PGMY0070.do") {
			$("#dataForm").attr("action","/PGMY0070.do");
		}
		
		var smsCheck = "${gnrInfo.smsRecptnAgre}";
		var emailCheck = "${gnrInfo.emailRecptnAgre}";
		
		if(smsCheck == "Y")
			$("#ad_rcv_sms").attr("checked", true);
		else
			$("#ad_rcv_sms_reject").attr("checked", true);
		
		if(emailCheck == "Y")
			$("#ad_rcv_email").attr("checked", true);
		else
			$("#ad_rcv_email_reject").attr("checked", true);
		
		// MASK
		$('#ad_phon_middle').mask('0000');
		$('#ad_phon_last').mask('0000');
		
		// 취소
		$("#btn_cancel").click(function(){
			$.msgBox({
	            title: "Confirmation",
	            content: "취소하시면 수정하시기 전 정보로<br> 유지됩니다. <br> 정말 취소하시겠습니까?",
	            type: "confirm",
	            buttons: [{ value: "아니오" }, { value: "예" }],
	            success: function (result) {
	                if (result == "아니오") {
	       				return;
	                }
	            	else {
	            		$("#df_method_nm").val("index");
	            		document.dataForm.submit();
	            	}
				}
			});
		});
		
		// 유효성 검사
		$("#dataForm").validate({  
			rules : {// 비밀번호		
	    			ad_user_pw: {
	    				required: true,
	    				minlength: 8,
	    				maxlength: 20,
	    				noDigitsIncOrDec: true,		// 3자 이상 연속된 숫자(오름,내림)
	    				noIdenticalNum: true,		// 3자 이상 동일한 숫자 
	    				noAlphaInc: true,			// 3자 이상 연속된 영문(오름)
	    				noAlphaDec: true,			// 3자 이상 연속된 영문(내림)
	    				noIdenticalWord: true,		// 3자 이상 동일한 영문
	    				chekDuplWord : "ad_userId",// 3자 이상 아이디와 동일한 단어
	    				noRefusedSpeChar: true,		// 사용할 수 없는 특수 문자
	    				noRefusedWord: true,		// 사용할 수 없는 단어
	    			},// 새 비밀번호
	    			ad_user_new_pw: {
	    				required: true,
	    				minlength: 8,
	    				maxlength: 20,
	    				noDigitsIncOrDec: true,		// 3자 이상 연속된 숫자(오름,내림)
	    				noIdenticalNum: true,		// 3자 이상 동일한 숫자 
	    				noAlphaInc: true,			// 3자 이상 연속된 영문(오름)
	    				noAlphaDec: true,			// 3자 이상 연속된 영문(내림)
	    				noIdenticalWord: true,		// 3자 이상 동일한 영문
	    				chekDuplWord : "ad_userId",// 3자 이상 아이디와 동일한 단어
	    				noRefusedSpeChar: true,		// 사용할 수 없는 특수 문자
	    				noRefusedWord: true,		// 사용할 수 없는 단어
	    			},// 새 비밀번호 확인
	    			ad_confirm_new_password: {
	    				required: true,
	    				minlength: 8,
	    				maxlength: 20,
	    				equalTo: "#ad_user_new_pw"
	    			},// 핸드폰번호 가운데
	    			ad_phon_middle: { 	
	    				required: true
	    			},// 핸드폰번호 마지막
	    			ad_phon_last: { 	
	    				required: true    			 
	    			},// 이메일
	    			ad_user_email: {
	    				required: true,
	    				email: true,
	    				maxlength: 100
	    			},
				},
			submitHandler: function(form) {
				
				var pattern1 = /[0-9]/;
				var pattern2 = /[a-zA-Z]/;
				var pattern3 = /[~!@\$%^&*]/;
				
				var checkpwd = false;
				var checknext = false;
				
				if(checkpwd == false) {
					// 기존비밀번호
					if($("#ad_passwordAt").val() == "N") {
							checknext = true;
					}
					// 새비밀번호 변경
					if($("#ad_passwordAt").val() == "Y") {
						// 새 비밀번호 수가 10자리 이상이면
						if($("#ad_user_new_pw").val().length >= 10) {
							// 영문자, 숫, 특수문자 중 2가지 이상
							// 영문+숫자, 숫자+특수문자, 영문+특수문자, 영문+숫자+특수문자
							if(((pattern1.test($("#ad_user_new_pw").val()) && pattern2.test($("#ad_user_new_pw").val())) || (pattern2.test($("#ad_user_new_pw").val()) && pattern3.test($("#ad_user_new_pw").val())) || (pattern3.test($("#ad_user_new_pw").val()) && pattern1.test($("#ad_user_new_pw").val())) || (pattern1.test($("#ad_user_new_pw").val()) && pattern2.test($("#ad_user_new_pw").val()) && pattern3.test($("#ad_user_new_pw").val())))) {
								checknext = true;		
							}
							else {
								jsMsgBox($("#ad_user_new_pw"), 'warn', '비밀번호가 10자리 이상일 경우 비밀번호는 영문, 숫자, 특수문자 중 2가지 이상 포함해야 합니다.',function(){return;});
							}
						// 새 비밀번호 수가 8자리 이상이면
						}else {
							// 영문+숫자+특수문자 포함
							if(!pattern1.test($("#ad_user_new_pw").val()) || !pattern2.test($("#ad_user_new_pw").val()) || !pattern3.test($("#ad_user_new_pw").val())) {
								jsMsgBox($("#ad_user_new_pw"), 'warn', '비밀번호가 8자리 이상일 경우 비밀번호는 영문, 숫자, 특수문자를 모두 포함해야 합니다.',function(){return;});
							}
							else { 
								checknext = true;
							}
						}
					}		
				}
					
				if(checknext == true) {
					// 기존 비밀번호 일치확인
						$.ajax({
							url : "PGMY0070.do",
							type : "POST",
							dataType : "json",
							data     : { df_method_nm	: "checkPwd"
		            			,"ad_user_id"	: $('#ad_userId').val()
		            			,"ad_user_pw"	: $('#ad_user_pw').val()
		            		   },
							async : false,
							success : function(response) {
								try {
			                        if(response.result) {
			                        	checkpwd = true;
			                        } else {                        	 
			                        	if(response.value.reason == 'fail'){
			                        		jsMsgBox($("#ad_user_pw"),'info',"기존 비밀번호가 일치하지 않습니다.");
			                        		checkpwd = false;
			                        		return;
			                       
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
				
				
				if(checkpwd == true) {
					
						// 휴대전화번호 조립
						var ad_phon_first 	= $('#ad_phon_first').val();
						var ad_phon_middle 	= $('#ad_phon_middle').val();
						var ad_phon_last 	= $('#ad_phon_last').val();			
						var ad_phone_num = ""+ad_phon_first+ad_phon_middle+ad_phon_last;
						$('#ad_phone_num').val(ad_phone_num);
						
						// 휴대전화, 이메일 그대로
						if(ad_phone_num == $('#ad_prephone_num').val() && $('#ad_user_email').val() == $('#ad_preuser_email').val()) {
							jsMsgBox(null, 'info', '요청하신 수정사항이 성공적으로<br> 반영되었습니다.<br> 이용해 주셔서 감사합니다.',function(){$("#df_method_nm").val("updateUserInfo"); form.submit();});
						}
						
						// 휴대전화만 수정했을 경우, 휴대전화 중복 확인
						if(ad_phone_num != $('#ad_prephone_num').val() && $('#ad_user_email').val() == $('#ad_preuser_email').val()) {
							$.ajax({
				                url      : "PGMY0070.do",
				                type     : "POST",
				                dataType : "json",
				                data     : { df_method_nm	: "checkDuplGnrUserPhone"
				                			,"ad_phone_num"	: $('#ad_phone_num').val()
				                		   },                
				                async    : false,                
				                success  : function(response) {
				                	try {
				                        if(response.result) {
				                        	jsMsgBox(null, 'info', '요청하신 수정사항이 성공적으로<br> 반영되었습니다.<br> 이용해 주셔서 감사합니다.',function(){$("#df_method_nm").val("updateUserInfo"); form.submit();});
				                        } else {                        	 
				                        	if(response.value.reason == 'duplPhonNum'){
				                        		// duplPhonNum
				                        		jsMsgBox($("#ad_phon_first"),'info',Message.template.existInfo('휴대전화번호'));
				                       
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
						// 이메일만 수정했을 경우, 이메일 중복 확인
						if($('#ad_user_email').val() != $('#ad_preuser_email').val() && ad_phone_num == $('#ad_prephone_num').val()) {
							$.ajax({
				                url      : "PGMY0070.do",
				                type     : "POST",
				                dataType : "json",
				                data     : { df_method_nm	: "checkDuplGnrUserEmail"
				                			,"ad_user_email"	: $('#ad_user_email').val()
				                		   },                
				                async    : false,                
				                success  : function(response) {
				                	try {
				                        if(response.result) {
				                        	jsMsgBox(null, 'info', '요청하신 수정사항이 성공적으로<br> 반영되었습니다.<br> 이용해 주셔서 감사합니다.',function(){$("#df_method_nm").val("updateUserInfo"); form.submit();});
				                        } else {                        	 
				                        	if(response.value.reason == 'duplEmail'){
				                        		// duplPhonNum
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
						
						if($('#ad_user_email').val() != $('#ad_preuser_email').val() && ad_phone_num != $('#ad_prephone_num').val()) {
						// 이메일, 휴대전화 모두 수정했을 경우, 중복확인
							$.ajax({
				                url      : "PGMY0070.do",
				                type     : "POST",
				                dataType : "json",
				                data     : { df_method_nm	: "checkDuplGnrUserInfo"
				                			,"ad_phone_num"	: $('#ad_phone_num').val()
				                			,"ad_user_email": $('#ad_user_email').val()
				                		   },                
				                async    : false,                
				                success  : function(response) {
				                	try {
				                        if(response.result) {
				                        	jsMsgBox(null, 'info', '요청하신 수정사항이 성공적으로<br> 반영되었습니다.<br> 이용해 주셔서 감사합니다.',function(){$("#df_method_nm").val("updateUserInfo"); form.submit();});
				                        } else {                        	 
				                        	if(response.value.reason == 'duplPhonNum'){
				                        		// duplPhonNum
				                        		jsMsgBox($("#ad_phon_first"),'info',Message.template.existInfo('휴대전화번호'));
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
				}	
		});
		
		// 수정
		$("#btn_insert").click(function(){
			$("#df_method_nm").val("updateUserInfo"); 
			$("#dataForm").submit();
		});
		
		// 비밀번호변경
		$("#btn_passChange").click(function(){
			if($("#ad_passwordAt").val()== "N") {
				$("#ad_tbodypass").append('<tr><th><img src="<c:url value="/images2/sub/table_check.png" />" alt="필수입력요소" /> 새 비밀번호</th>'
											+ '<td class="b_l_0"><input name="ad_user_new_pw" type="password" id="ad_user_new_pw" class="text" placeholder="새 비밀번호를 입력해 주세요."  style="width:365px;"/></td></tr>'
											+ '<tr><th><img src="<c:url value="/images2/sub/table_check.png" />" alt="필수입력요소" /> 새 비밀번호 확인</th>'
											+ '<td class="b_l_0"><input name="ad_confirm_new_password" type="password" id="ad_confirm_new_password" class="text" placeholder="위 입력하신 새 비밀번호를 다시 한번 입력해 주세요." style="width:365px;"/></td></tr>');
				$("#ad_passwordAt").val("Y");
				// tool tip
				$("#add_tooltip").jBox('Tooltip', {
					content: '연속적인 숫자나 생일, 전화번호 등 추측하기 쉬운 개인정보 및 아이디와 비슷한 비밀번호는 <br/> 사용하지 않는것이 좋습니다. <br/> 비밀번호는 최소 10자리시 영문(대소문자), 숫자, 특수문자 중 2가지이상 조합되어야 하고<br/> 최소 8자리시 영문(대소문자), 숫자, 특수문자 중 3가지 이상 조합되어야 합니다.'
				});
			}
			
		});
		
		
	});
</script>
</head>
<body>
<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		
		<input type="hidden" name="ad_phone_num" id="ad_phone_num" />
		<input type="hidden" name="ad_prephone_num" id="ad_prephone_num" value="${mbtlNum.first}${mbtlNum.middle}${mbtlNum.last}"/>
		<input type="hidden" name="ad_preuser_email" id="ad_preuser_email" value="${gnrInfo.email}"/>
		<input type="hidden" name="ad_join_type" id="ad_join_type" value="individual" />
		<input type="hidden" name="ad_userId" id="ad_userId" value="${gnrInfo.loginId}"/>
		<input type="hidden" name="ad_user_nm" id="ad_user_nm" value="${gnrInfo.userNm}"/>
		<input type="hidden" name="ad_passwordAt" id="ad_passwordAt" value="N"/>
<!--//content-->
<div id="wrap">
	<div class="s_cont" id="s_cont">
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
					<ap:trail menuNo="${param.df_menu_no}"  />
				</div>
				<div class="r_cont s_cont06_06">
					<div class="list_bl">
						<h4 class="fram_bl">로그인정보</h4>
						<table class="table_form">
							<caption>로그인정보</caption>
							<colgroup>
								<col width="172px">
								<col width="*">
							</colgroup>
							<tbody id="ad_tbodypass">
								<tr>
									<th class="p_l_30">아이디</th>
									<td class="b_l_0"><strong>${gnrInfo.loginId}</strong></td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">비밀번호</th>
									<td class="b_l_0"><input type="password" name="ad_user_pw" id="ad_user_pw" onfocus="this.placeholder=''; return true" style="width: 507px;" placeholder="현재 비밀번호를 입력해 주세요."><a href="#none" id="btn_passChange" class="form_blBtn">비밀번호 변경</a></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="list_bl">
						<h4 class="fram_bl">개인정보</h4>
						<table class="table_form">
							<caption>개인정보</caption>
							<colgroup>
								<col width="172px">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th class="p_l_30">이름</th>
									<td class="b_l_0">${gnrInfo.userNm}</td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">휴대전화번호</th>
									<td class="b_l_0">
										<select id="ad_phon_first" class="select_box" name="ad_phon_first" style="width:70px; ">
											<c:forTokens items="${MOBILE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
												<option value="${firstNum }" <c:if test="${mbtlNum.first == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
											</c:forTokens>	
										</select>
										-<input type="text" name="ad_phon_middle" id="ad_phon_middle" value="${mbtlNum.middle}"style="width: 66px; margin-left: 3px; margin-right: 3px;">-<input type="text" name="ad_phon_last" id="ad_phon_last" value="${mbtlNum.last}" style="width: 66px; margin-left: 3px;">
									</td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">이메일</th>
									<td class="b_l_0"><input type="text" name="ad_user_email" id="ad_user_email" value="${gnrInfo.email}" style="width: 507px;"></td>
								</tr>
								<tr>
									<th class="p_l_30">이메일 수신</th>
									<td class="b_l_0">
										<ul class="radio_sy">
											<li style="margin-right: 125px;">
												<input type="radio" id="ad_rcv_email" name="ad_rcv_email" checked="check" value="Y">
												<label for="ad_rcv_email"></label>
												<label for="ad_rcv_email">신청</label>
											</li>
											<li>
												<input type="radio" id="ad_rcv_email_reject" name="ad_rcv_email" value="N">
												<label for="ad_rcv_email"></label>
												<label for="ad_rcv_email">신청안함</label>
											</li>
										</ul>
									</td>
								</tr>
								<tr>
									<th class="p_l_30">SMS 수신</th>
									<td class="b_l_0">
										<ul class="radio_sy">
											<li style="margin-right: 125px;">
												<input type="radio" id="ad_rcv_sms" name="ad_rcv_sms" checked="check" value="Y">
												<label for="ad_rcv_sms"></label>
												<label for="ad_rcv_sms">신청</label>
											</li>
											<li>
												<input type="radio" id="ad_rcv_sms_reject" name="ad_rcv_sms" value="N">
												<label for="ad_rcv_sms"></label>
												<label for="ad_rcv_sms">신청안함</label>
											</li>
										</ul>
									</td>
								</tr>
							</tbody>
						</table>
					</div>

					<div class="btn_bl">
						<a href="#none" id="btn_cancel" class="wht">취소</a>
						<a href="#none" id="btn_insert" class="blu">확인</a>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!--content//-->
</form>
</body>
</html>