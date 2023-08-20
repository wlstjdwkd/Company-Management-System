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
<ap:jsTag type="web" items="jquery, colorbox, jqGrid, notice, css, validate, form, mask, msgBox,jBox" />
<ap:jsTag type="tech" items="font,cmn,mainn,subb, my, msg,util" />
<script type="text/javascript" src="${contextPath}/script/bizrnoCert/nxts.min.js"></script>
<script type="text/javascript" src="${contextPath}/script/bizrnoCert/nxtspki_config.js"></script>
<script type="text/javascript" src="${contextPath}/script/bizrnoCert/nxtspki.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		 
		if($("#dataForm").action != "/PGMY0070.do") {
			$("#dataForm").attr("action","/PGMY0070.do");
		}
		
		$("#page_type").val("1");
		
		// 사업자 공인인증 초기화
		nxTSPKI.onInit(function(){ 
		});

		nxTSPKI.init(true);
		 
		var smsCheck = "${entInfo.smsRecptnAgre}";
		var emailCheck = "${entInfo.emailRecptnAgre}";
		
		var mngSmsCheck = "${manager.smsRecptnAgre}";
		var mngEmailCheck = "${manager.emailRecptnAgre}";
		
		// 법인등록번호
		var jurirNo = "${entInfo.jurirNo}";
		var jurirNo_1 = jurirNo.substring(0, 6);
		var jurirNo_2 = jurirNo.substring(6, 13);	
		$("#ad_jurirNoTd").text(jurirNo_1 + "-" + jurirNo_2)
		
		// 사업자등록번호
		var bizrNo = "${entInfo.bizrNo}";
		/* var bizrNo_1 = bizrNo.substring(0, 3);
		var bizrNo_2 = bizrNo.substring(3, 5);
		var bizrNo_3 = bizrNo.substring(5, 10);
		$("#ad_bizrNoTd").text(bizrNo_1 + "-" + bizrNo_2 + "-" + bizrNo_3); */
		
		// 우편번호
		var zip = "${entInfo.hedofcZip}";
		//var zip_1 = zip.substring(0,3);
		//var zip_2 = zip.substring(3,6);
		//$("#ad_zipcod_first").val(zip_1);
		//$("#ad_zipcod_last").val(zip_2);
		
		// 수정 화면에서 기존 우편번호를 분리할 필요없이 그대로 넣는다.
		$("#ad_zipcod_first").val(zip);
		
		
		if(smsCheck == "Y")
			$("#ad_rcv_sms").attr("checked", true);
		else
			$("#ad_rcv_sms_reject").attr("checked", true);
		
		if(emailCheck == "Y")
			$("#ad_rcv_email").attr("checked", true);
		else
			$("#ad_rcv_email_reject").attr("checked", true);
		
		// MASK
		// 휴대전화
		$('#ad_phon_middle').mask('0000');
		$('#ad_phon_last').mask('0000');
		// 법인번호
		$('#ad_jurirno_first').mask('000000');
		$('#ad_jurirno_last').mask('0000000');
		// 사업자번호
		$('#ad_bizrno_first').mask('000');
		$('#ad_bizrno_middle').mask('00');
		$('#ad_bizrno_last').mask('00000');
		// 전화번호
		$('#ad_tel_middle').mask('0000');
		$('#ad_tel_last').mask('0000');
		// 담당자 일반전화번호
		$('#ad_tel_middle2').mask('0000');
		$('#ad_tel_last2').mask('0000');
		// 팩스번호
		$('#ad_fax_middle').mask('0000');
		$('#ad_fax_last').mask('0000');
		
		// MASK
		// 휴대전화
		$('#ad_manager_phon_middle').mask('0000');
		$('#ad_manager_phon_last').mask('0000');

		// 담당자 일반전화번호
		$('#ad_manager_tel_middle2').mask('0000');
		$('#ad_manager_tel_last2').mask('0000');
		
		if(mngSmsCheck == "Y")
			$("#ad_manager_rcv_sms").attr("checked", true);
		else
			$("#ad_manager_rcv_sms_reject").attr("checked", true);
		
		if(mngEmailCheck == "Y")
			$("#ad_manager_rcv_email").attr("checked", true);
		else
			$("#ad_manager_rcv_email_reject").attr("checked", true);
		/*  */
		
		// 취소
		$("#btn_cancel").click(function(){
			$.msgBox({
	            title: "Confirmation",
	            content: "취소하시면 수정하시기 전 정보로 <br>유지됩니다. <br> 정말 취소하시겠습니까?",
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
	    				/* minlength: 8,
	    				maxlength: 20,
	    				noDigitsIncOrDec: true,		// 3자 이상 연속된 숫자(오름,내림)
	    				noIdenticalNum: true,		// 3자 이상 동일한 숫자 
	    				noAlphaInc: true,			// 3자 이상 연속된 영문(오름)
	    				noAlphaDec: true,			// 3자 이상 연속된 영문(내림)
	    				noIdenticalWord: true,		// 3자 이상 동일한 영문
	    				chekDuplWord : "ad_userId",// 3자 이상 아이디와 동일한 단어
	    				noRefusedSpeChar: true,		// 사용할 수 없는 특수 문자
	    				noRefusedWord: true,		// 사용할 수 없는 단어 */
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
	    			},// 대표자명
	    			ad_rprsntv_nm: {
	    				required: true,
	    				maxlength: 50
	    			},// 사업자등록번호 처음
					ad_bizrno_first : {
						required : true,
						minlength : 3,
						maxlength : 3,
					},// 사업자등록번호 가운데
					ad_bizrno_middle : {
						required : true,
						minlength : 2,
						maxlength : 2,
					},// 사업자등록번호 마지막
					ad_bizrno_last : {
						required : true,
						minlength : 5,
						maxlength : 5,
	    			},// 주소상세02
	    			ad_addr_detail02:{    				
	    				maxlength: 100
	    			},// 소속부서
	    			ad_dept:{
	    				required: true,
	    				maxlength: 13
	    			},// 책임자명
	    			ad_manager_chargerNm: {
	    				required: true
	    			},// 책임자 소속부서
	    			ad_manager_dept:{
	    				required: true,
	    				maxlength: 13
	    			},// 직위
	    			ad_ofcps:{
	    				maxlength: 50
	    			},// 책임자 직위
	    			ad_manager_ofcps:{
	    				maxlength: 50
	    			},// 담당자전화번호 가운데
	    			ad_tel_middle2: { 	
	    				required: true
	    			},// 담당자전화번호 마지막
	    			ad_tel_last2: { 	
	    				required: true    			 
	    			},// 휴대전화 가운데
	    			ad_phon_middle: { 	
	    				required: true
	    			},// 휴대전화 마지막
	    			ad_phon_last: { 	
	    				required: true    			 
	    			},// 이메일
	    			ad_user_email: {
	    				required: true,
	    				email: true,
	    				maxlength: 100
	    			},// 책임자 이메일
	    			ad_manager_user_email: {
	    				required: true,
	    				email: true,
	    				maxlength: 100
	    			}
				},
			submitHandler: function(form) {
				
				// 공인인증여부 검사
				var crtChk = $("#cert_rst").val();
	         	if(crtChk == 'N'){
	         		jsMsgBox($("#cert_rst"), 'warn', '사업자번호를 인증해 주십시오.',function(){return;});
	         		return false;
	         	}
				
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
						success : function(	response) {
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
					//사업자번호 중간 85 금지
				 	var midbiz = $('#ad_bizrno_middle').val(); 
		         	if (midbiz == "85") {
       			 	jsMsgBox($("#ad_bizrno"), 'warn', '사업자등록번호를 본점 기준으로 등록하여 주십시오.',function(){return;});
       			 	$('#ad_bizrno_middle').focus();
          		 	
          		 	return false;
       			 	}
		         		
				if(checkpwd == true) {
					
					// 휴대전화번호 조립
					var ad_phon_first 	= $('#ad_phon_first').val();
					var ad_phon_middle 	= $('#ad_phon_middle').val();
					var ad_phon_last 	= $('#ad_phon_last').val();			
					var ad_phone_num 	= ""+ad_phon_first+ad_phon_middle+ad_phon_last;
					$('#ad_phone_num').val(ad_phone_num);
		
					/*  */
					//사업자등록번호 조립
					var ad_bizrno_first 	= $('#ad_bizrno_first').val();
					var ad_bizrno_middle 	= $('#ad_bizrno_middle').val();
					var ad_bizrno_last 		= $('#ad_bizrno_last').val();
					var ad_bizrno			= ""+ad_bizrno_first+ad_bizrno_middle+ad_bizrno_last;
					$('#ad_bizrNo').val(ad_bizrno);
					/*  */
					
					
					// 전화번호 조립
					var ad_tel_first 	= $('#ad_tel_first').val();
					var ad_tel_middle 	= $('#ad_tel_middle').val();
					var ad_tel_last 	= $('#ad_tel_last').val();
					var ad_tel			= ""+ad_tel_first+ad_tel_middle+ad_tel_last;
					$('#ad_tel').val(ad_tel);
					
					// 담당자 일반전화번호 조립
					var ad_tel_first2 	= $('#ad_tel_first2').val();
					var ad_tel_middle2 	= $('#ad_tel_middle2').val();
					var ad_tel_last2 	= $('#ad_tel_last2').val();
					var ad_tel2			= ""+ad_tel_first2+ad_tel_middle2+ad_tel_last2;
					$('#ad_tel2').val(ad_tel2);
					
					// 팩스번호 조립
					var ad_fax_first 	= $('#ad_fax_first').val();
					var ad_fax_middle 	= $('#ad_fax_middle').val();
					var ad_fax_last 	= $('#ad_fax_last').val();
					var ad_fax			= ""+ad_fax_first+ad_fax_middle+ad_fax_last;
					$('#ad_fax').val(ad_fax);
					
					// 우편번호 조립
					var ad_zipcod_first	= $('#ad_zipcod_first').val();
					//var ad_zipcod_last 	= $('#ad_zipcod_last').val();
					//var ad_zipcod		= ""+ad_zipcod_first+ad_zipcod_last;
					//$('#ad_zipcod').val(ad_zipcod);
					$('#ad_zipcod').val(ad_zipcod_first);
					
					// 주소 조립
					var ad_addr		= $('#ad_adres').val();
					$('#ad_addr').val(ad_addr);
					
					/*  */
					
					// 책임자 휴대전화번호 조립
					var ad_manager_phon_first 	= $('#ad_manager_phon_first').val();
					var ad_manager_phon_middle 	= $('#ad_manager_phon_middle').val();
					var ad_manager_phon_last 	= $('#ad_manager_phon_last').val();			
					var ad_manager_phone_num 	= ""+ad_manager_phon_first+ad_manager_phon_middle+ad_manager_phon_last;
					$('#ad_manager_phone_num').val(ad_manager_phone_num);
					
					
					// 책임자 일반전화번호 조립
					var ad_manager_tel_first2 	= $('#ad_manager_tel_first2').val();
					var ad_manager_tel_middle2 	= $('#ad_manager_tel_middle2').val();
					var ad_manager_tel_last2 	= $('#ad_manager_tel_last2').val();
					var ad_manager_tel2			= ""+ad_manager_tel_first2+ad_manager_tel_middle2+ad_manager_tel_last2;
					$('#ad_manager_tel2').val(ad_manager_tel2);
		
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
			                data     : { df_method_nm	: "checkDuplEntUserPhone"
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
			                data     : { df_method_nm	: "checkDuplEntUserEmail"
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
			                data     : { df_method_nm	: "checkDuplEntUserInfo"
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
		
		// 확인
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
		
		// 사업자 공인인증 콜백함수
		function login_data_complete_callback(res) {
	        if (res.code == 0) {
	            $("#loginData").val(res.data.loginData);

	            $.ajax({
					url : "PGCMLOGIO0010.do",
					type : "POST",
					dataType : "html",
					data : {
						df_method_nm : "bsisnoProc",
						page_type : "1",
						loginData : res.data.loginData,
						ad_user_no : ${entInfo.userNo}
					},
					async : false,
					success : function(
							response) {
						try {
							$("#addd").html(response);
							 document.querySelector('input#ad_dn').value = document.querySelector('span#rest').innerHTML;
							 if(document.querySelector('span#jb').innerHTML == "Y")
								$("#cert_rst").val("Y");
							 else{
								$("#cert_rst").val("N");
								alert("이미 동일한 사업자번호로 등록된 회원이 있습니다.");
								return;
							 }
							if(document.querySelector('span#jb2').innerHTML == "Y")
								$("#cert_rst").val("Y");
							 else{
								$("#cert_rst").val("N");
								alert("이전에 등록한 사업자 정보와 동일합니다.");
								return;
							}
						} catch (e) {
							if (response != null) {
								jsSysErrorBox(response);
							} else {
								jsSysErrorBox(e);
							}
							
							return;
						}
						alert("등록완료");
					}
				});
	         }
	        else {
	            /* alert("error code = " + res.code + ", message = " + res.errorMessage); */
	        	if (res.code == 100) { // 공인인증창 닫기
	            } else if (res.code == 111) {
	                alert("인증서의 암호가 틀립니다.");
	            } else if (res.code == 140) {
	                alert("입력하신 사업자번호와 인증서 정보가 맞지 않습니다.");
	            } else {
	                alert(res.errorMessage);
	            }
	        }
	    }
		
		// 사업자 공인인증
		$("#btn_bizrno_chk").click(function(){
			//공인인증로직
			var ad_bizrno_first 	= $('#ad_bizrno_first').val();
			var ad_bizrno_middle 	= $('#ad_bizrno_middle').val();
			var ad_bizrno_last 		= $('#ad_bizrno_last').val();
			var ad_chk = '${entInfo.bizrnoCertChk}';
			
			var ad_bizrno_first_original 	= $('#chk_value1').val();
			var ad_bizrno_middle_original 	= $('#chk_value2').val();
			var ad_bizrno_last_original 	= $('#chk_value3').val();
			if(ad_chk == 'Y' && (ad_bizrno_first == ad_bizrno_first_original && ad_bizrno_middle == ad_bizrno_middle_original && ad_bizrno_last == ad_bizrno_last_original))
			{
				alert("이미 등록하신 사업자 번호입니다.");
				return;
			}

			var verifyVID = true;
	        var options = {};

	        var sessionId = "0";
	        var ssn = ""+ad_bizrno_first+ad_bizrno_middle+ad_bizrno_last;
	        var userInfo = "0";
			
        	if($("#ad_bizrno_middle").val() == '85'){
           		alert("본점 사업자번호로만 등록이 가능합니다.");
                return;
           	}
	        	
	        if(verifyVID == true) {
				if(ssn != "0") {
					options.ssn = ssn;
				}
				else {
					alert("ssn에 입력된 값이 알맞지 않아 신원확인을 수행하지 않습니다.");
				}
	        }
	        
	        nxTSPKI.loginData(sessionId, ssn, userInfo, options, login_data_complete_callback);
		});
		
		// 사업자번호 인증여부
		if('${entInfo.bizrnoCertChk}' == 'Y'){
			$("#cert_rst").val("Y");
		}
		
		if('${entInfo.bizrnoCertChk}' == 'N'){
			$("#cert_rst").val("N");
		}
		
		// 지점번호일시
		if('${fn:substring(entInfo.bizrNo, 3, 5)}' == '85'){
			$("#cert_rst").val("N");
		}
		
		// 사업자번호 원래값과 차이가 있는지 비교
		$("#ad_bizrno_first").change(function(){
			if($(this).val() == $("#chk_value1").val())
				$("#cert_rst").val("Y");
			else
				$("#cert_rst").val("N");
		});
				
		$("#ad_bizrno_middle").change(function(){
			if($(this).val() == $("#chk_value2").val())
				$("#cert_rst").val("Y");
			else
				$("#cert_rst").val("N");
		});
		
		$("#ad_bizrno_last").change(function(){
			if($(this).val() == $("#chk_value3").val())
				$("#cert_rst").val("Y");
			else
				$("#cert_rst").val("N");
		});
		
		// 우편번호
		$('#btn_search_zip').click(function() {
	    	var pop = window.open("<c:url value='${SEARCH_ZIP_URL}' />","searchZip","width=570,height=420, scrollbars=yes, resizable=yes");		
	    });
		
		

		
	});
	
	function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){	
		<%--
		roadFullAddr : 도로명주소 전체(포멧)
		roadAddrPart1: 도로명주소           
		addrDetail   : 고객입력 상세주소    
		roadAddrPart2: 참고주소             
		engAddr      : 영문 도로명주소      
		jibunAddr    : 지번 주소            
		zipNo        : 우편번호             
		admCd        : 행정구역코드         
		rnMgtSn      : 도로명코드           
		bdMgtSn      : 건물관리번호
		--%>
		
		<%--
		var zipArr = Util.str.split(zipNo,'-');
		$('#ad_zipcod_first').val(zipArr[0]);
		$('#ad_zipcod_last').val(zipArr[1]);
		$("#ad_adres").val(roadAddrPart1 + " " + addrDetail);
		
		2015. 08. 01부터 시행되는 우편번호 5자리 변경 관련 수정
		기존의 팝업방식을 그대로 사용하면 되고, 기존에 000-000 으로 '-'이 붙어서 들어오던 것이 
		앞으로는 '-'없이 00000로 들어온다고 함
		--%>
		
		var zipArr = zipNo.replace("-", "");	// 혹시 모를 '-'처리
		$('#ad_zipcod_first').val(zipArr);		// 우편번호 자리에 그냥 넣어준다.
		$("#ad_adres").val(roadAddrPart1 + " " + addrDetail);
	}
	
</script>
</head>
<body>
<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
	
		<input type="hidden" name="ad_phone_num" id="ad_phone_num" />
		<input type="hidden" name="ad_prephone_num" id="ad_prephone_num" value="${mbtlNum.first}${mbtlNum.middle}${mbtlNum.last}"/>
		<input type="hidden" name="ad_preuser_email" id="ad_preuser_email" value="${entInfo.email}"/>
		<input type="hidden" name="ad_tel" id="ad_tel" />
		<input type="hidden" name="ad_tel2" id="ad_tel2" />
		<input type="hidden" name="ad_fax" id="ad_fax" />
		<input type="hidden" name="ad_zipcod" id="ad_zipcod" />
		<input type="hidden" name="ad_addr" id="ad_addr" />
		<input type="hidden" name="ad_join_type" id="ad_join_type" value="enterprise"/>
		<input type="hidden" name="ad_userId" id="ad_userId" value="${entInfo.loginId}"/>
		<input type="hidden" name="ad_chargerNm" id="ad_chargerNm" value="${entInfo.chargerNm}"/>
		<input type="hidden" name="ad_entrprsNm" id="ad_entrprsNm" value="${entInfo.entrprsNm}"/>
		<input type="hidden" name="ad_jurirNo" id="ad_jurirNo" value="${entInfo.jurirNo}"/>
		<input type="hidden" name="ad_bizrNo" id="ad_bizrNo" value="${entInfo.bizrNo}"/>
		<input type="hidden" name="ad_passwordAt" id="ad_passwordAt" value="N"/>
		<input type="hidden" name="page_type" id="page_type" value="1" />
		
		<!-- 책임자 -->
		<input type="hidden" name="ad_manager_phone_num" id="ad_manager_phone_num" />
		<input type="hidden" name="ad_manager_prephone_num" id="ad_manager_prephone_num" value="${managerMbtlNum.first}${managerMbtlNum.middle}${managerMbtlNum.last}"/>
		<input type="hidden" name="ad_manager_email" id="ad_manager_email" value="${manager.email}"/>
		<input type="hidden" name="ad_manager_tel2" id="ad_manager_tel2" />
		<input type="hidden" name="ad_manager_join_type" id="ad_manager_join_type" value="manager"/>
		<%-- <input type="hidden" name="ad_manager_chargerNm" id="ad_manager_chargerNm" value="${manager.chargerNm}"/> --%>
		<input type="hidden" name="ad_manager_entrprsNm" id="ad_manager_entrprsNm" value="${manager.entrprsNm}"/>
		<!--  -->
		
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
									<td class="b_l_0"><strong>${entInfo.loginId}</strong></td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">비밀번호</th>
									<td class="b_l_0"><input type="password" name="ad_user_pw" id="ad_user_pw" onfocus="this.placeholder=''; return true" style="width: 507px;" placeholder="현재 비밀번호를 입력해 주세요."><a href="#none" id="btn_passChange" class="form_blBtn">비밀번호 변경</a></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="list_bl">
						<h4 class="fram_bl">기업정보</h4>
						<table class="table_form">
							<caption>개인정보</caption>
							<colgroup>
								<col width="172px">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th class="p_l_30">기업명</th>
									<td class="b_l_0">${entInfo.entrprsNm}</td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">대표자명</th>
									<td class="b_l_0"><input name="ad_rprsntv_nm" type="text" id="ad_rprsntv_nm" placeholder="귀사의 대표자 이름을 입력해 주세요." onfocus="this.placeholder=''; return true" style="width:507px;" value="${entInfo.rprsntvNm}"/></td>
								</tr>
								<tr>
									<th class="p_l_30">법인등록번호</th>
									<td class="b_l_0" id="ad_jurirNoTd"></td>
								</tr>
								<tr>
									<th class="p_l_30"><label for="ad_bizrno">사업자등록번호</label></th>
									<!-- <td class="b_l_0" id="ad_bizrNoTd"> -->
									<td class="b_l_0">
									<input name="ad_bizrno_first" type="text" id="ad_bizrno_first" value="<c:out value="${fn:substring(entInfo.bizrNo, 0, 3)}" />" class="text" style="width:106px;" title="사업자등록번호앞번호" />
                                    ~
                                    <input name="ad_bizrno_middle" type="text" id="ad_bizrno_middle" value="<c:out value="${fn:substring(entInfo.bizrNo, 3, 5)}" />" class="text" style="width:121px;" title="사업자등록번호가운데번호" />
                                    ~
                                    <input name="ad_bizrno_last" type="text" id="ad_bizrno_last" value="<c:out value="${fn:substring(entInfo.bizrNo, 5, 10)}" />" class="text" style="width:121px;" title="사업자등록번호마지막번호" />
                                    <a href="#none" id="btn_bizrno_chk" class="blue_btn"><span>공인인증</span></a>
                                    <input type="hidden" name="cert_rst" id="cert_rst" value="" />
									<input type="hidden" name="loginData" id="loginData" />
									<input type="hidden" name="ad_dn" id="ad_dn" />
									<input type="hidden" name="chk_value1" id="chk_value1" value="<c:out value="${fn:substring(entInfo.bizrNo, 0, 3)}" />"/>
									<input type="hidden" name="chk_value2" id="chk_value2" value="<c:out value="${fn:substring(entInfo.bizrNo, 3, 5)}" />"/>
									<input type="hidden" name="chk_value3" id="chk_value3" value="<c:out value="${fn:substring(entInfo.bizrNo, 5, 10)}" />"/>
									</td>
								</tr>
								<tr>
									<th class="p_l_30">주소</th>
									<td class="b_l_0"><input name="ad_zipcod_first" type="text" id="ad_zipcod_first" class="text" style="width:90px;" title="우편번호" readonly /><a href="#none" id="btn_search_zip" class="gray_btn">우편번호 검색</a><input type="text" name="ad_adres" id="ad_adres" style="width: 507px; margin-top: 7px;" value="${entInfo.hedofcAdres}" readonly></td>
								</tr>
								<tr>
									<th class="p_l_30">전화번호</th>
									<td class="b_l_0">
										<select id=ad_tel_first class="select_box" name="ad_tel_first" style="width:70px; ">
											<c:forTokens items="${PHONE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
												<option value="${firstNum }" <c:if test="${telNo.first == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
											</c:forTokens>	
										</select>
										-<input type="text" name="ad_tel_middle" id="ad_tel_middle" value="${telNo.middle}"style="width: 66px; margin-left: 3px; margin-right: 3px;">-<input type="text" name="ad_tel_last" id="ad_tel_last" value="${telNo.last}" style="width: 66px; margin-left: 3px;">
									</td>
								</tr>
								<tr>
									<th class="p_l_30">팩스번호</th>
									<td class="b_l_0">
										<select name="ad_fax_first" class="select_box" id="ad_fax_first" style="width:70px; ">
											<c:forTokens items="${PHONE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
												<option value="${firstNum }" <c:if test="${fxNum.first == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
											</c:forTokens>												
										</select>
										-<input type="text" name="ad_fax_middle" id="ad_fax_middle" value="${fxNum.middle}"style="width: 66px; margin-left: 3px; margin-right: 3px;">-<input type="text" name="ad_fax_last" id="ad_fax_last" value="${fxNum.last}" style="width: 66px; margin-left: 3px;">
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					
					<!-- 책임자 정보 등록 20200630 -->
					<div class="list_bl">
						<h4 class="fram_bl">책임자 정보</h4>
						<p style="color:#2763ba;">* 기업 책임자 정보 입력<br/>
						</p>
						<table class="table_form">
							<caption>책임자 정보</caption>
							<colgroup>
								<col width="172px">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th class="p_l_30">책임자이름</th>
									<td class="b_l_0"><input name="ad_manager_chargerNm" type="text" id="ad_manager_chargerNm" style="width:507px;" value="${manager.chargerNm}"/></td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">소속부서</th>
									<td class="b_l_0"><input name="ad_manager_dept" type="text" id="ad_manager_dept" style="width:507px;" value="${manager.chargerDept}"/></td>
								</tr>
								<tr>
									<th class="p_l_30">직위</th>
									<td class="b_l_0"><input name="ad_manager_ofcps" type="text" id="ad_manager_ofcps" style="width:507px;" value="${manager.ofcps}"/></td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">책임자 직통 전화번호</th>
									<td class="b_l_0">
										<select name="ad_manager_tel_first2" class="select_box" id="ad_manager_tel_first2" style="width:70px; ">
											<c:forTokens items="${PHONE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
												<option value="${firstNum }" <c:if test="${manager.telNo.first == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
											</c:forTokens>													
										</select>
										-<input type="text" name="ad_manager_tel_middle2" id="ad_manager_tel_middle2" value="${manager.telNo.middle}"style="width: 66px; margin-left: 3px; margin-right: 3px;">-<input type="text" name="ad_manager_tel_last2" id="ad_manager_tel_last2" value="${manager.telNo.last}" style="width: 66px; margin-left: 3px;">
									</td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">휴대전화번호</th>
									<td class="b_l_0">
										<select name="ad_manager_phon_first" class="select_box" id="ad_manager_phon_first" style="width:70px;">
										<c:forTokens items="${MOBILE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
											<option value="${firstNum }" <c:if test="${manager.mbtlNum.first == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
										</c:forTokens>	
										</select>
										-<input type="text" name="ad_manager_phon_middle" id="ad_manager_phon_middle" value="${manager.mbtlNum.middle}"style="width: 66px; margin-left: 3px; margin-right: 3px;">-<input type="text" name="ad_manager_phon_last" id="ad_manager_phon_last" value="${manager.mbtlNum.last}" style="width: 66px; margin-left: 3px;">
									</td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">이메일</th>
									<td class="b_l_0"><input type="text" name="ad_manager_user_email" id="ad_manager_user_email" value="${manager.email}" style="width: 507px;"></td>
								</tr>
								<tr>
									<th class="p_l_30">이메일 수신</th>
									<td class="b_l_0">
										<ul class="radio_sy">
											<li style="margin-right: 125px;">
												<input type="radio" id="ad_manager_rcv_email" name="ad_manager_rcv_email" value="Y">
												<label for="ad_manager_rcv_email"></label>
												<label for="ad_manager_rcv_email">신청</label>
											</li>
											<li>
												<input type="radio" id="ad_manager_rcv_email_reject" name="ad_manager_rcv_email" value="N">
												<label for="ad_manager_rcv_email"></label>
												<label for="ad_manager_rcv_email">신청안함</label>
											</li>
										</ul>
									</td>
								</tr>
								<tr>
									<th class="p_l_30">SMS 수신</th>
									<td class="b_l_0">
										<ul class="radio_sy">
											<li style="margin-right: 125px;">
												<input type="radio" id="ad_manager_rcv_sms" name="ad_manager_rcv_sms" value="Y">
												<label for="ad_manager_rcv_sms"></label>
												<label for="ad_manager_rcv_sms">신청</label>
											</li>
											<li>
												<input type="radio" id="ad_manager_rcv_sms_reject" name="ad_manager_rcv_sms" value="N">
												<label for="ad_manager_rcv_sms"></label>
												<label for="ad_manager_rcv_sms">신청안함</label>
											</li>
										</ul>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<!--  -->
					
					<div class="list_bl">
						<h4 class="fram_bl">담당자(본인)정보</h4>
						<p style="color:#2763ba;">* 모든 안내는 담당자 정보에 작성된 연락처로 진행되니, 반드시 담당자와 직접 연락가능한 연락처로 작성해주시기 바랍니다.*<br/>
						* 담당자가 변경된 경우 '고객지원 > 가입정보 조회/변경'을 통해 담당자 변경 신청 후 이용해주시기 바랍니다.
						</p>
						<table class="table_form">
							<caption>담당자(본인)정보</caption>
							<colgroup>
								<col width="172px">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th class="p_l_30">담당자이름</th>
									<td class="b_l_0">${entInfo.chargerNm}</td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">소속부서</th>
									<td class="b_l_0"><input name="ad_dept" type="text" id="ad_dept" style="width:507px;" value="${entInfo.chargerDept}"/></td>
								</tr>
								<tr>
									<th class="p_l_30">직위</th>
									<td class="b_l_0"><input name="ad_ofcps" type="text" id="ad_ofcps" style="width:507px;" value="${entInfo.ofcps}"/></td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">담당자 직통 전화번호</th>
									<td class="b_l_0">
										<select name="ad_tel_first2" class="select_box" id="ad_tel_first2" style="width:70px; ">
											<c:forTokens items="${PHONE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
												<option value="${firstNum }" <c:if test="${telNo2.first == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
											</c:forTokens>													
										</select>
										-<input type="text" name="ad_tel_middle2" id="ad_tel_middle2" value="${telNo2.middle}"style="width: 66px; margin-left: 3px; margin-right: 3px;">-<input type="text" name="ad_tel_last2" id="ad_tel_last2" value="${telNo2.last}" style="width: 66px; margin-left: 3px;">
									</td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">휴대전화번호</th>
									<td class="b_l_0">
										<select name="ad_phon_first" class="select_box" id="ad_phon_first" style="width:70px;">
										<c:forTokens items="${MOBILE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
											<option value="${firstNum }" <c:if test="${mbtlNum.first == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
										</c:forTokens>	
										</select>
										-<input type="text" name="ad_phon_middle" id="ad_phon_middle" value="${mbtlNum.middle}"style="width: 66px; margin-left: 3px; margin-right: 3px;">-<input type="text" name="ad_phon_last" id="ad_phon_last" value="${mbtlNum.last}" style="width: 66px; margin-left: 3px;">
									</td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">이메일</th>
									<td class="b_l_0"><input type="text" name="ad_user_email" id="ad_user_email" value="${entInfo.email}" style="width: 507px;"></td>
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
												<input type="radio" id="ad_rcv_sms" name="ad_rcv_sms" value="Y">
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
<div style="display:none" id="addd">
		
</div>
</body>
</html>