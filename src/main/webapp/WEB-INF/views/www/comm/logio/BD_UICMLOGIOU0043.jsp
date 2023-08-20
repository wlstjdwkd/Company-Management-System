<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,form,validate,mask,notice,msgBox,jBox" />
<ap:jsTag type="tech" items="msg,util,cmn,mainn, subb, font,mb" />
<script type="text/javascript" src="${contextPath}/script/bizrnoCert/nxts.min.js"></script>
<script type="text/javascript" src="${contextPath}/script/bizrnoCert/nxtspki_config.js"></script>
<script type="text/javascript" src="${contextPath}/script/bizrnoCert/nxtspki.js"></script>
<ap:globalConst />
<script type="text/javascript">
	$(document).ready(function() {
		// MASK
		// 휴대전화
		$('#ad_phon_middle').mask('0000');
		$('#ad_phon_last').mask('0000');
		// 책임자 휴대전화
		$('#ad_manager_phon_middle').mask('0000');
		$('#ad_manager_phon_last').mask('0000');
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
		// 책임자 일반전화번호
		$('#ad_manager_tel_middle').mask('0000');
		$('#ad_manager_tel_last').mask('0000');
		// 팩스번호
		$('#ad_fax_middle').mask('0000');
		$('#ad_fax_last').mask('0000');
		
		$('#page_type').val("2");
		
		nxTSPKI.onInit(function(){ 
		});

		nxTSPKI.init(true);
		
		function login_data_complete_callback(res) {
	        if (res.code == 0) {
	            $("#loginData").val(res.data.loginData);
				
	            $.ajax({
					url : "PGCMLOGIO0010.do",
					type : "POST",
					dataType : "html",
					data : {
						df_method_nm : "bsisnoProc",
						page_type : "2",
						loginData : res.data.loginData
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

		// 로그인
		$("#btn_bizrno_chk").click(function() {
				
			$("#cert_rst").val("N");
			var ad_bizrno_first 	= $('#ad_bizrno_first').val();
			var ad_bizrno_middle 	= $('#ad_bizrno_middle').val();
			var ad_bizrno_last 		= $('#ad_bizrno_last').val();
			
			var verifyVID = true;
	        var options = {};

	        var sessionId = "0";
	        var ssn = ""+ad_bizrno_first+ad_bizrno_middle+ad_bizrno_last;
	        var userInfo = "0";
	        
	        if(ssn == "" || ssn.length != 10){
	        	alert("사업자번호 10자리를 입력해주세요.");
                return;
	        }
			
        	if (ssn.substring(3,5) == "85") {
           		alert("본점 사업자번호로만 가입이 가능합니다.");
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

		// 유효성 검사
		$("#dataForm").validate({
			rules : {// 아이디  				
				ad_user_id : {
					required : true,
					minlength : 8,
					maxlength : 20,
					alphanumeric : true,
					firstAlpha : true, // 첫글자는 영문
					includeAlphaAtLeast2 : true
				// 최소 영문 2글자 포함
				},// 비밀번호
				ad_user_pw : {
					required : true,
					minlength : 8,
					maxlength : 20,
					noDigitsIncOrDec : true, // 3자 이상 연속된 숫자(오름,내림)
					noIdenticalNum : true, // 3자 이상 동일한 숫자 
					noAlphaInc : true, // 3자 이상 연속된 영문(오름)
					noAlphaDec : true, // 3자 이상 연속된 영문(내림)
					noIdenticalWord : true, // 3자 이상 동일한 영문
					chekDuplWord : "ad_user_id",// 3자 이상 아이디와 동일한 단어
					noRefusedSpeChar : true, // 사용할 수 없는 특수 문자
					noRefusedWord : true, // 사용할 수 없는 단어
				},// 비밀번호 확인
				ad_confirm_password : {
					required : true,
					minlength : 8,
					maxlength : 20,
					equalTo : "#ad_user_pw"
				},// 기업명
				ad_entrprs_nm : {
					required : true,
					maxlength : 255
				},// 대표자명
				ad_rprsntv_nm : {
					required : true,
					maxlength : 50
				},
				// 법인등록번호 앞자리
				ad_jurirno_first : {
					required : true,
					minlength : 6,
					maxlength : 6,
				},// 법인등록번호 뒷자리
				ad_jurirno_last : {
					required : true,
					minlength : 7,
					maxlength : 7,
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
				ad_addr_detail02 : {
					maxlength : 100
				},// 소속부서
				ad_dept : {
					required : true,
					maxlength : 13
				},// 직위
				ad_ofcps : {
					maxlength : 50
				},// 담당자 일반전화 가운데
				ad_tel_middle2 : {
					required : true
				},// 담당자 일반전화 마지막
				ad_tel_last2 : {
					required : true
				},// 휴대전화 가운데
				ad_phon_middle : {
					required : true
				},// 휴대전화 마지막
				ad_phon_last : {
					required : true
				},// 이메일
				ad_user_email : {
					required : true,
					email : true,
					maxlength : 100
				},// 비밀번호 확인
				ad_confirm_password : {
					required : true,
					minlength : 8,
					maxlength : 20,
					equalTo : "#ad_user_pw"
				},// 공인인증 확인
				cert_rst : {
					required : true,
					equalTo : "Y"
				},// 책임자 이름
				ad_manager_nm : {
					required : true,
					maxlength : 50
				},// 책임자 소속부서
				ad_manager_dept : {
					required : true,
					maxlength : 13
				},// 책임자 직위
				ad_manager_ofcps : {
					maxlength : 50
				},// 책임자 일반전화 가운데
				ad_manager_tel_middle : {
					required : true
				},// 책임자 일반전화 마지막
				ad_manager_tel_last : {
					required : true
				},// 책임자 휴대전화 가운데
				ad_manager_phon_middle : {
					required : true
				},// 책임자 휴대전화 마지막
				ad_manager_phon_last : {
					required : true
				},// 책임자 이메일
				ad_manager_user_email : {
					required : true,
					email : true,
					maxlength : 100
				}
			},
			submitHandler : function(form) {
				// 아이디 중복 검사 여부 확인
				var isValidId = $('#ad_chk_id')
						.val();
				if (Util.str
						.toUpperCase(isValidId) == "N") {
					jsMsgBox(
							$("#btn_dupl_user"),
							'info',
							Message.template
									.chkDuplInfo('아이디'));
					return;
				}

				// 법인등록번호 중복 검사 여부 확인
				var isValidJurirno = $(
						'#ad_chk_jurirno')
						.val();
				if (Util.str
						.toUpperCase(isValidJurirno) == "N") {
					jsMsgBox(
							$("#btn_dupl_jurirno"),
							'info',
							Message.template
									.chkDuplInfo('법인등록번호'));
					return;
				}
				
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
					var ad_phon_first = $(
							'#ad_phon_first').val();
					var ad_phon_middle = $(
							'#ad_phon_middle')
							.val();
					var ad_phon_last = $(
							'#ad_phon_last').val();
					var ad_phone_num = ""
							+ ad_phon_first
							+ ad_phon_middle
							+ ad_phon_last;
					$('#ad_phone_num').val(
							ad_phone_num);
			
					// 책임자 휴대전화번호 조립
					var ad_manager_phon_first = $('#ad_manager_phon_first').val();
					var ad_manager_phon_middle = $('#ad_manager_phon_middle').val();
					var ad_manager_phon_last = $('#ad_manager_phon_last').val();
					var ad_manager_phone_num = "" + ad_manager_phon_first + ad_manager_phon_middle + ad_manager_phon_last;
					$('#ad_manager_phone_num').val(ad_manager_phone_num);
					
					// 법인번호 조립
					var ad_jurirno_first = $(
							'#ad_jurirno_first')
							.val();
					var ad_jurirno_last = $(
							'#ad_jurirno_last')
							.val();
					var ad_jurirno = ""
							+ ad_jurirno_first
							+ ad_jurirno_last;
					$('#ad_jurirno')
							.val(ad_jurirno);
			
					// 사업자번호 조립
					var ad_bizrno_first = $(
							'#ad_bizrno_first')
							.val();
					var ad_bizrno_middle = $(
							'#ad_bizrno_middle')
							.val();
					var ad_bizrno_last = $(
							'#ad_bizrno_last')
							.val();
					var ad_bizrno = ""
							+ ad_bizrno_first
							+ ad_bizrno_middle
							+ ad_bizrno_last;
					$('#ad_bizrno').val(ad_bizrno);
			
					// 전화번호 조립
					var ad_tel_first = $(
							'#ad_tel_first').val();
					var ad_tel_middle = $(
							'#ad_tel_middle').val();
					var ad_tel_last = $(
							'#ad_tel_last').val();
					var ad_tel = "" + ad_tel_first
							+ ad_tel_middle
							+ ad_tel_last;
					$('#ad_tel').val(ad_tel);
					
					// 담당자 일반전화번호 조립
					var ad_tel_first2 = $(
							'#ad_tel_first2').val();
					var ad_tel_middle2 = $(
							'#ad_tel_middle2').val();
					var ad_tel_last2 = $(
							'#ad_tel_last2').val();
					var ad_tel2 = "" + ad_tel_first2 + ad_tel_middle2 + ad_tel_last2;
					$('#ad_tel2').val(ad_tel2);
			
					// 책임자 일반전화번호 조립
					var ad_manager_tel_first = $('#ad_manager_tel_first').val();
					var ad_manager_tel_middle = $('#ad_manager_tel_middle').val();
					var ad_manager_tel_last = $('#ad_manager_tel_last').val();
					var ad_manager_tel = "" + ad_manager_tel_first + ad_manager_tel_middle + ad_manager_tel_last;
					$('#ad_manager_tel').val(ad_manager_tel);
					
					// 팩스번호 조립
					var ad_fax_first = $(
							'#ad_fax_first').val();
					var ad_fax_middle = $(
							'#ad_fax_middle').val();
					var ad_fax_last = $(
							'#ad_fax_last').val();
					var ad_fax = "" + ad_fax_first
							+ ad_fax_middle
							+ ad_fax_last;
					$('#ad_fax').val(ad_fax);
			
					// 우편번호 조립
					/*
					var ad_zipcod_first = $(
							'#ad_zipcod_first')
							.val();
					var ad_zipcod_last = $(
							'#ad_zipcod_last')
							.val();
					var ad_zipcod = ""
							+ ad_zipcod_first
							+ ad_zipcod_last;
					*/
					var ad_zipcod_first = $('#ad_zipcod_first').val();
					var ad_zipcod = "" + ad_zipcod_first;
					$('#ad_zipcod').val(ad_zipcod);
			
					// 주소 조립
					var ad_addr_detail01 = $(
							'#ad_addr_detail01')
							.val();
					var ad_addr_detail02 = $(
							'#ad_addr_detail02')
							.val();
					var ad_addr = ""
							+ ad_addr_detail01
							+ " "
							+ ad_addr_detail02;
					$('#ad_addr').val(ad_addr);
	
					// 휴대전화, 이메일 중복 확인
					$.ajax({
						url : "PGCMLOGIO0040.do",
						type : "POST",
						dataType : "json",
						data : {
							df_method_nm : "checkDuplEntUserInfo",
							"ad_phone_num" : $(
									'#ad_phone_num')
									.val(),
							"ad_user_email" : $(
									'#ad_user_email')
									.val()
						},
						async : false,
						success : function(
								response) {
							try {
								if (response.result) {
									$("#df_method_nm").val("insertUserInfo");
									form.submit();
									//jsMsgBox('info','전송완료');
								} else {
									if (response.value.reason == 'duplPhonNum') {
										// duplPhonNum
										jsMsgBox($("#ad_phon_first"),'info',Message.template.existInfo('휴대전화번호'));
									} else {
										// duplEmail
										jsMsgBox($("#ad_user_email"),'info',Message.template.existInfo('이메일'));
									}
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
						}
					});
				}
			}
		});

		// 회원가입
		$("#btn_join").click(function() {
			$("#dataForm").submit();
		});

		// 아이디 중복 체크
		$("#btn_dupl_user").click(function() {
			var isvalid = $('#ad_user_id')
					.valid();

			if (!isvalid) {
				jsMsgBox(
						$("#ad_user_id"),
						'info',
						Message.template
								.wrongInfo('아이디'));
				return;
			}

			$.ajax({
				url : "PGCMLOGIO0040.do",
				type : "POST",
				dataType : "text",
				data : {
					df_method_nm : "checkDuplUserId",
					ad_user_id : $(
							'#ad_user_id')
							.val()
				},
				async : false,
				success : function(
						response) {
					try {
						var msgParam = '아이디';
						if (eval(response)) {
							jsMsgBox(
									$("#btn_dupl_user"),
									'info',
									Message.template
											.validInfo(msgParam));
							$(
									'#ad_chk_id')
									.val(
											'Y');
						} else {
							jsMsgBox(
									$("#btn_dupl_user"),
									'info',
									Message.template
											.existInfo(msgParam));
							$(
									'#ad_chk_id')
									.val(
											'N');
						}
					} catch (e) {
						if (response != null) {
							jsSysErrorBox(response);
						} else {
							jsSysErrorBox(e);
						}
						return;
					}
				}
			});
		});

		// 법인등록번호 중복 체크
		$("#btn_dupl_jurirno").click(function() {
			var isvalid01 = $(
					'#ad_jurirno_first')
					.valid();
			var isvalid02 = $(
					'#ad_jurirno_last').valid();

			if (!isvalid01) {
				jsMsgBox(
						$('#ad_jurirno_first'),
						'info',
						Message.template
								.wrongInfo('법인등록번호'));
				return;
			}

			if (!isvalid02) {
				jsMsgBox(
						$('#ad_jurirno_last'),
						'info',
						Message.template
								.wrongInfo('법인등록번호'));
				return;
			}

			var ad_jurirno = ""
					+ $('#ad_jurirno_first')
							.val()
					+ $('#ad_jurirno_last')
							.val();

			$.ajax({
				url : "PGCMLOGIO0040.do",
				type : "POST",
				dataType : "text",
				data : {
					df_method_nm : "checkDuplJrirno",
					ad_jurirno : ad_jurirno
				},
				async : false,
				success : function(
						response) {
					try {
						var msgParam = '법인등록번호';
						if (eval(response)) {
							jsMsgBox(
									$("#btn_dupl_jurirno"),
									'info',
									Message.template
											.validInfo(msgParam));
							$(
									'#ad_chk_jurirno')
									.val(
											'Y');
						} else {
							jsMsgBox(
									$("#btn_dupl_jurirno"),
									'info',
									Message.template
											.existInfo(msgParam));
							$(
									'#ad_chk_jurirno')
									.val(
											'N');
						}
					} catch (e) {
						if (response != null) {
							jsSysErrorBox(response);
						} else {
							jsSysErrorBox(e);
						}
						return;
					}
				}
			});
		});
		
		// tool tip
		$(".add_tooltip").jBox('Tooltip', {
			content: '연속적인 숫자나 생일, 전화번호 등 추측하기 쉬운 개인정보 및 아이디와 비슷한 비밀번호는 <br/> 사용하지 않는것이 좋습니다. <br/> 비밀번호는 최소 10자리시 영문(대소문자), 숫자, 특수문자 중 2가지이상 조합되어야 하고<br/> 최소 8자리시 영문(대소문자), 숫자, 특수문자 중 3가지 이상 조합되어야 합니다.'
		});
		$(".add_tooltip_id").jBox('Tooltip', {
			content: '첫 문자는 반드시 영문자로 시작해야 하고, 영문자는 최소 두 글자 이상 포함되어야 합니다.'
		});
		$(".help_btn_bizrno").jBox('Tooltip', {
			content: '범용공인인증서만 가능하며, 사업장 본점만 등록이 가능합니다.(지점 불가)'
		});
		
		// 아이디 변경시 중복체크 여부 N 처리
		$('#ad_user_id').change(function() {
			$('#ad_chk_id').val('N');
		});

		// 법인등록번호 변경시 중복체크 여부 N 처리
		$('#ad_jurirno_first').change(function() {
			$('#ad_chk_jurirno').val('N');
		});
		$('#ad_jurirno_last').change(function() {
			$('#ad_chk_jurirno').val('N');
		});

		$('#ad_jurirno_last').change(function() {
			$('#ad_chk_jurirno').val('N');
		});

		$('#btn_search_zip').click(function() {
			var pop = window.open("<c:url value='${SEARCH_ZIP_URL}' />", "searchZip", "width=570,height=420, scrollbars=yes, resizable=yes");
		});
});

	function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail,
			roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn) {
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
	
	
	var zipArr = Util.str.split(zipNo, '-');
		$('#ad_zipcod_first').val(zipArr[0]);
		$('#ad_zipcod_last').val(zipArr[1]);
		$('#ad_addr_detail01').val(roadAddrPart1);
		$('#ad_addr_detail02').val(addrDetail);
	
	2015. 08. 01부터 시행되는 우편번호 5자리 변경 관련 수정
	기존의 팝업방식을 그대로 사용하면 되고, 기존에 000-000 으로 '-'이 붙어서 들어오던 것이 
	앞으로는 '-'없이 00000로 들어온다고 함
	--%>
	
	var zipArr = zipNo.replace("-", "");	// 혹시 모를 '-'처리
	$('#ad_zipcod_first').val(zipArr);		// 우편번호 자리에 그냥 넣어준다.
	$('#ad_addr_detail01').val(roadAddrPart1);
	$('#ad_addr_detail02').val(addrDetail);

	}
</script>
</head>

<body>
	<form name="dataForm" id="dataForm" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<input type="hidden" name="ad_chk_id" id="ad_chk_id" value="N" /> 
		<input type="hidden" name="ad_chk_jurirno" id="ad_chk_jurirno" value="N" /> 
		<input type="hidden" name="ad_join_type" id="ad_join_type" value="enterprise" /> 
		<input type="hidden" name="ad_phone_num" id="ad_phone_num" /> <input type="hidden" name="ad_jurirno" id="ad_jurirno" /> 
		<input type="hidden" name="ad_bizrno" id="ad_bizrno" /> 
		<input type="hidden" name="ad_tel" id="ad_tel" />
		<input type="hidden" name="ad_tel2" id="ad_tel2" />
		<input type="hidden" name="ad_fax" id="ad_fax" /> 
		<input type="hidden" name="ad_zipcod" id="ad_zipcod" /> <input type="hidden" name="ad_addr" id="ad_addr" />
		<input type="hidden" id="chk_terms03" name="chk_terms03" value="${param.chk_terms03}" />
		<input type="hidden" name="page_type" id="page_type" value="2" />
		
		<input type="hidden" name="ad_manager_tel" id="ad_manager_tel" />
		<input type="hidden" name="ad_manager_phone_num" id="ad_manager_phone_num" />
	
		<!--//content-->
		<div id="wrap">
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
					<div class="step_sec join_step" style="margin-bottom: 20px;">
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
					<p class="list_noraml">기업 정보은<strong>1법인 1계정 가입</strong>을 원칙으로 하고 있습니다.<br/></p>
					<div class="list_bl">
						<h4 class="fram_bl">로그인 정보<p><img src="/images2/sub/table_check.png">항목은 입력 필수 항목입니다.</p></h4>
						<table class="table_form">
							<caption>로그인 정보</caption>
							<colgroup>
								<col width="172px">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th><img src="/images2/sub/table_check.png">아이디<img src="/images2/sub/help_btn.png" class="add_tooltip_id"></th>
									<td class="b_l_0"><input type="text" name="ad_user_id" id="ad_user_id" onfocus="this.placeholder=''; return true" style="width: 507px;" placeholder="사용하실 아이디를 입력해 주세요.">
									<a href="#" class="gray_btn" id="btn_dupl_user">중복체크</a></td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">비밀번호<img src="/images2/sub/help_btn.png" class="add_tooltip"></th>
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
						<h4 class="fram_bl">기업정보 <span style="color:#2763ba;">(반드시 사업장 본점의 사업자등록증과 동일하게 작성할 것)</span></h4>
						<table class="table_form">
							<caption>개인정보</caption>
							<colgroup>
								<col width="172px">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th><img src="/images2/sub/table_check.png">기업명</th>
									<td class="b_l_0"><input type="text" name="ad_entrprs_nm" id="ad_entrprs_nm" onfocus="this.placeholder=''; return true" style="width: 507px;" placeholder="귀사의 기업명을 입력해 주세요."></td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">대표자명</th>
									<td class="b_l_0"><input type="text" name="ad_rprsntv_nm" id="ad_rprsntv_nm" onfocus="this.placeholder=''; return true" style="width: 507px;" placeholder="귀사의 대표자 이름을 입력해 주세요."></td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">법인등록번호</th>
									<td class="b_l_0"><input type="text" name="ad_jurirno_first" id="ad_jurirno_first" style="width: 114px; margin-right: 5px;">-
									<input type="text" name="ad_jurirno_last" id="ad_jurirno_last" style="width: 114px; margin-left: 5px;">
										<a href="#none" id="btn_dupl_jurirno" class="gray_btn"><span>중복체크</span></a>
									<p><span style="color:red;">※ 이미 등록된 법인등록번호의 경우, <strong>[고객지원 - 가입정보조회/변경]</strong>에서 가입 정보 확인</span></p>
									</td>
								</tr>
								<tr>
									<th>
										<img src="/images2/sub/table_check.png">사업자등록번호
										<!-- <img src="/images2/sub/help_btn.png" class="help_btn_bizrno"> -->
									</th>
									<td class="b_l_0 cert_rsn">
										<input type="text" name="ad_bizrno_first" id="ad_bizrno_first" style="width: 76px; margin-right: 5px;">-<input type="text" name="ad_bizrno_middle" id="ad_bizrno_middle" style="width: 56px; margin-right: 5px; margin-left: 5px;">-<input type="text" name="ad_bizrno_last" id="ad_bizrno_last" style="width: 76px; margin-left: 5px;">
										<a href="#none" id="btn_bizrno_chk" class="blue_btn"><span>공인인증</span></a>
										<a class="tradesign_btn" href="http://www.tradesign.net/ra/mme" target="_blank">공인인증서 신청안내</a>
										<!-- 2021.03.22 ====== S: 오아림 변경 =======
										<input type="hidden" name="cert_rst" id="cert_rst" value="N" /> 
										-->
										<input type="hidden" name="cert_rst" id="cert_rst" value="Y" />
										<!-- ===== E: 오아림 변경 ===== -->
										<input type="hidden" name="loginData" id="loginData" />
										<input type="hidden" name="ad_dn" id="ad_dn" />
										<p>※ 법인 사업장 본점의 전자거래범용, 기업 정보 전용 공인인증서만 등록 가능(사업장 지점 불가)
									</td>
								</tr>
								<tr>
									<th class="p_l_30">주소</th>
									<td class="b_l_0"><input type="text" name="ad_zipcod_first" id="ad_zipcod_first" style="width: 143px;" readonly><a href="#none" id="btn_search_zip" class="gray_btn">우편번호 검색</a><input type="hidden" name="ad_addr_detail01" id="ad_addr_detail01" style="width: 507px; margin-top: 7px;"><input type="text" name="ad_addr_detail02" id="ad_addr_detail02" style="width: 507px; margin-top: 7px;"></td>
								</tr>
								<tr>
									<th class="p_l_30">전화번호</th>
									<td class="b_l_0">
										<ul class="form_sel">
											<li>
												<select id="ad_tel_first" class="select_box" style="width: 70px;">
													<c:forTokens items="${PHONE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
														<option value="${firstNum }" <c:if test="${telNo.first == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
													</c:forTokens>		
												</select>
											</li>
											<li>-<input type="text" name="ad_tel_middle" id="ad_tel_middle" style="width: 66px; margin-left: 3px; margin-right: 3px;">-<input type="text" name="ad_tel_last" id="ad_tel_last" style="width: 66px; margin-left: 3px;"></li>
										</ul>
									</td>
								</tr>
								<tr>
									<th class="p_l_30">팩스번호</th>
									<td class="b_l_0">
										<ul class="form_sel">
											<li>
												<select id="ad_fax_first" class="select_box" style="width: 70px;">
													<c:forTokens items="${PHONE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
														<option value="${firstNum }" <c:if test="${fxNum.first == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
													</c:forTokens>	
												</select>
											</li>
											<li>-<input type="text" name="ad_fax_middle" id="ad_fax_middle" style="width: 66px; margin-left: 3px; margin-right: 3px;">-<input type="text" name="ad_fax_last" id="ad_fax_last" style="width: 66px; margin-left: 3px;"></li>
										</ul>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="list_bl">
						<h4 class="fram_bl">관리자 정보</h4>
						<table class="table_form">
							<caption>개인정보</caption>
							<colgroup>
								<col width="172px">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th><img src="/images2/sub/table_check.png">이름</th>
									<td class="b_l_0"><input type="text" name="ad_manager_nm" id="ad_manager_nm" style="width:507px;"></td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">소속부서</th>
									<td class="b_l_0"><input type="text" name="ad_manager_dept" id="ad_manager_dept" style="width: 507px;"></td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">직위</th>
									<td class="b_l_0"><input type="text" name="ad_manager_ofcps" id="ad_manager_ofcps" style="width: 507px;"></td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">일반전화번호</th>
									<td class="b_l_0">
										<ul class="form_sel">
											<li>
												<select id="ad_manager_tel_first" class="select_box" style="width: 70px;">
													<c:forTokens items="${PHONE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
														<option value="${firstNum }" <c:if test="${telNo.first == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
													</c:forTokens>		
												</select>
											</li>
											<li>-<input type="text" name="ad_manager_tel_middle" id="ad_manager_tel_middle" style="width: 66px; margin-left: 3px; margin-right: 3px;">-<input type="text" name="ad_manager_tel_last" id="ad_manager_tel_last" style="width: 66px; margin-left: 3px;"></li>
										</ul>
									</td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">휴대전화번호</th>
									<td class="b_l_0">
										<ul class="form_sel">
											<li>
												<select id="ad_manager_phon_first" class="select_box" style="width: 70px;">
													<c:forTokens items="${MOBILE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
														<option value="${firstNum }" <c:if test="${mbtlNum.first == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
													</c:forTokens>	
												</select>
											</li>
											<li>-<input type="text" name="ad_manager_phon_middle" id="ad_manager_phon_middle" style="width: 66px; margin-left: 3px; margin-right: 3px;">-<input type="text" name="ad_manager_phon_last" id="ad_manager_phon_last" style="width: 66px; margin-left: 3px;"></li>
										</ul>
									</td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">이메일</th>
									<td class="b_l_0"><input type="text" name="ad_manager_user_email" id="ad_manager_user_email" style="width: 507px;"></td>
								</tr>
								<tr>
									<th class="p_l_30">이메일 수신</th>
									<td class="b_l_0">
										<ul class="radio_sy">
											<li style="margin-right: 125px;">								
												<input type="radio" id="ad_manager_rcv_email" name="ad_manager_rcv_email" value="Y">
												<label for="ad_manager_rcv_email"></label>
												<label for="ad_manager_rcv_email">동의</label>
											</li>
											<li>
												<input type="radio" id="ad_manager_rcv_email_reject" name="ad_manager_rcv_email" checked="check" value="N">
												<label for="ad_manager_rcv_email_reject"></label>
												<label for="ad_manager_rcv_email_reject">미동의</label>
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
												<label for="ad_manager_rcv_sms">동의</label>
											</li>
											<li>
												<input type="radio" id="ad_manager_rcv_sms_reject" name="ad_manager_rcv_sms" checked="check" value="N">
												<label for="ad_manager_rcv_sms_reject"></label>
												<label for="ad_manager_rcv_sms_reject">미동의</label>
											</li>
										</ul>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					
					<div class="list_bl">
						<h4 class="fram_bl">담당자(본인) 정보</h4>
						<p style="color:#2763ba;">* 기업 확인서 발급 진행상황 알림 및 지원사업 등 안내는 등록된 담당자 정보로 진행되오니 정확하게 입력해 주시기 바랍니다.</p>
						<p style="color:#2763ba;">* 이메일 및 SMS 수신 미동의 시 발생하는 불이익은 책임지지 않습니다.</p>
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
									<th><img src="/images2/sub/table_check.png">소속부서</th>
									<td class="b_l_0"><input type="text" name="ad_dept" id="ad_dept" style="width: 507px;"></td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">직위</th>
									<td class="b_l_0"><input type="text" name="ad_ofcps" id="ad_ofcps" style="width: 507px;"></td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">담당자 직통 전화번호</th>
									<td class="b_l_0">
										<ul class="form_sel">
											<li>
												<select id="ad_tel_first2" class="select_box" style="width: 70px;">
													<c:forTokens items="${PHONE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
														<option value="${firstNum }" <c:if test="${telNo.first == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
													</c:forTokens>		
												</select>
											</li>
											<li>-<input type="text" name="ad_tel_middle2" id="ad_tel_middle2" style="width: 66px; margin-left: 3px; margin-right: 3px;">-<input type="text" name="ad_tel_last2" id="ad_tel_last2" style="width: 66px; margin-left: 3px;"></li>
										</ul>
									</td>
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">휴대전화번호</th>
									<td class="b_l_0">
										<ul class="form_sel">
											<li>
												<select id="ad_phon_first" class="select_box" style="width: 70px;">
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
												<input type="radio" id="ad_rcv_email" name="ad_rcv_email" checked="check"  value="Y">
												<label for="ad_rcv_email"></label>
												<label for="ad_rcv_email">동의</label>
											</li>
											<li>
												<input type="radio" id="ad_rcv_email_reject" name="ad_rcv_email" value="N">
												<label for="ad_rcv_email_reject"></label>
												<label for="ad_rcv_email_reject">미동의</label>
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
												<label for="ad_rcv_sms">동의</label>
											</li>
											<li>
												<input type="radio" id="ad_rcv_sms_reject" name="ad_rcv_sms"  value="N">
												<label for="ad_rcv_sms_reject"></label>
												<label for="ad_rcv_sms_reject">미동의</label>
											</li>
										</ul>
									</td>
								</tr>
							</tbody>
						</table>
						<!-- <p>※ 기업확인서 발급 진행사항, 알림, 채용관리, 입사지원 등의 서비스 이용 안내를 받아보실 수 있도록 1개 이상의<br/>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;‘수신’ 수단을 선택해 주시길 권장합니다.</p> -->
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
	<div style="display:none" id="addd">
		
	</div>
</body>
</html>