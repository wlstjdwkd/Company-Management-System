<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>	
<ap:jsTag type="web" items="jquery,form,validate,mask,notice,msgBox,jBox" />
<ap:jsTag type="tech" items="msg,util,mainn, subb, cmn, font,mb" />
<ap:globalConst />
<script type="text/javascript">
$(document).ready(function(){
	
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
			var isValidId = $('#ad_chk_id').val();
			if(Util.str.toUpperCase(isValidId)=="N"){
				jsMsgBox($("#btn_dupl_user"),'info',Message.template.chkDuplInfo('아이디'));
				return;
			}
			
			var pattern1 = /[0-9]/;
			var pattern2 = /[a-zA-Z]/;
			var pattern3 = /[~!@\$%^&*]/;
			var checkpwd = false;
			
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
	                		   },                
	                async    : false,                
	                success  : function(response) {
	                	try {
	                        if(response.result) {
	                        	$("#df_method_nm").val("insertUserInfo");
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
	
	// tool tip
	$("#add_tooltip").jBox('Tooltip', {
		content: '연속적인 숫자나 생일, 전화번호 등 추측하기 쉬운 개인정보 및 아이디와 비슷한 비밀번호는 <br/> 사용하지 않는것이 좋습니다. <br/> 비밀번호는 최소 10자리시 영문(대소문자), 숫자, 특수문자 중 2가지이상 조합되어야 하고<br/> 최소 8자리시 영문(대소문자), 숫자, 특수문자 중 3가지 이상 조합되어야 합니다.'
	});
	$("#add_tooltip_id").jBox('Tooltip', {
		content: '첫 문자는 반드시 영문자로 시작해야 하고, 영문자는 최소 두 글자 이상 포함되어야 합니다.'
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
	
});
</script>
</head>

<body>
<form name="dataForm" id="dataForm" method="post" action="PGCMLOGIO0040.do">
<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />
<input type="hidden" name="ad_chk_id" id="ad_chk_id" value="N" />
<input type="hidden" name="ad_join_type" id="ad_join_type" value="individual" />
<input type="hidden" name="ad_phone_num" id="ad_phone_num" />
<input type="hidden" id="chk_terms03" name="chk_terms03" value="${param.chk_terms03}" />
<!--//content-->
<div id="wrap" style="background:#fff;">
	<div class="s_cont" id="s_cont">
		<div class="s_tit s_tit07">
			<h1>회원서비스</h1>
		</div>
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit tit7">회원서비스</h2>
				<ul>
				</ul>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}"  />
				</div>
				<div class="r_cont s_cont07_07">
					<div class="step_sec join_step" style="margin-bottom: 40px;">
						<ul>
							<li>1.약관동의</li><!--공백제거
							--><li class="arr"> </li><!--공백제거
							--><li>2.본인인증</li><!--공백제거
							--><li class="arr"></li><!--공백제거
							--><li>3.유형선택</li><!--공백제거
							--><li class="arr"></li><!--공백제거
							--><li class="on">4.정보입력</li><!--공백제거
							--><li class="arr"></li><!--공백제거
							--><li>5.가입완료</li>
						</ul>
					</div>
					<div class="list_bl">
						<h4 class="fram_bl">로그인 정보</h4>
						<table class="table_form">
							<caption>로그인 정보</caption>
							<colgroup>
								<col width="172px">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th><img src="/images2/sub/table_check.png">아이디<img src="/images2/sub/help_btn.png" class="help_btn"></th>
									<td class="b_l_0"><input type="text" name="ad_user_id" id="ad_user_id" onfocus="this.placeholder=''; return true" style="width: 507px;" placeholder="사용하실 아이디를 입력해 주세요."><a href="#none" id="btn_dupl_user" class="gray_btn">중복체크</a></td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">비밀번호<img src="/images2/sub/help_btn.png" class="help_btn"></th>
									<td class="b_l_0"><input type="password" name="ad_user_pw" id="ad_user_pw" onfocus="this.placeholder=''; return true" style="width: 507px;" placeholder="비밀번호를 입력해 주세요."></td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">비밀번호 확인</th>
									<td class="b_l_0"><input type="password" name="ad_confirm_password" id="ad_confirm_password" onfocus="this.placeholder=''; return true"style="width: 507px;" placeholder="위 입력하신 비밀번호를 다시 한번 입력해 주세요."></td>
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
									<td class="b_l_0">${certifyName}</td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">휴대전화번호<img src="/images2/sub/help_btn.png" class="help_btn"></th>
									<td class="b_l_0">
										<ul class="form_sel">
											<li>
												<select id="ad_phon_first" class="select_box" name="ad_phon_first" style="width:70px; ">
													<c:forTokens items="${MOBILE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
														<option value="${firstNum }" <c:if test="${mbtlNum.first == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
													</c:forTokens>
												</select>
											</li>
											<li>-<input type="text" name="ad_phon_middle" id="ad_phon_middle" style="width: 66px; margin-left: 3px; margin-right: 3px;">-<input type="text" name="ad_phon_last" id="ad_phon_last" style="width: 66px; margin-left: 3px;"></li>
										</ul>
									</td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">이메일</th>
									<td class="b_l_0"><input type="text" name="ad_user_email" id="ad_user_email" style="width: 507px;"></td>
								</tr>
								<tr>
									<th class="p_l_30">이메일 수신</th>
									<td class="b_l_0">
										<ul class="radio_sy">
											<li style="margin-right: 125px;">								
												<input type="radio" id="ad_rcv_email" name="ad_rcv_email" value="Y">
												<label for="ad_rcv_email"></label>
												<label for="ad_rcv_email">신청</label>
											</li>
											<li>
												<input type="radio" id="ad_rcv_email_reject" name="ad_rcv_email" checked="check" value="N">
												<label for="ad_rcv_email_reject"></label>
												<label for="ad_rcv_email_reject">신청안함</label>
											</li>
										</ul>
									</td>
								</tr>
								<tr>
									<th class="p_l_30">SMS 수신</th>
									<td class="b_l_0">
										<ul class="radio_sy">
											<li style="margin-right: 125px;">
												<input type="radio" id="ad_rcv_sms" name="ad_rcv_sms" value="Y">
												<label for="ad_rcv_sms"></label>
												<label for="ad_rcv_sms">신청</label>
											</li>
											<li>
												<input type="radio" id="ad_rcv_sms_reject" name="ad_rcv_sms" checked="check" value="N">
												<label for="ad_rcv_sms_reject"></label>
												<label for="ad_rcv_sms_reject">신청안함</label>
											</li>
										</ul>
									</td>
								</tr>
							</tbody>
						</table>
						<p>※ 채용안내, 입사지원, 기업 자료, 알림 등의 서비스 이용 안내를 받아보실 수 있도록 1개 이상의 ‘수신’ 수단을<br/>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;선택해 주시길 권장합니다.</p>
					</div>

					<div class="btn_bl">
						<a href="#none" id="btn_join">시스템 회원가입</a>
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