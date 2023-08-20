<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,cookie,form,notice,validate, msgBox, colorbox" />
<ap:jsTag type="tech" items="msg, util, cmn, mainn, subb, font" />
<script type="text/javascript" src="${contextPath}/script/tech2/scskls.js"></script>
<script type="text/javascript" src="${contextPath}/script/bizrnoCert/nxts.min.js"></script>
<script type="text/javascript" src="${contextPath}/script/bizrnoCert/nxtspki_config.js"></script>
<script type="text/javascript" src="${contextPath}/script/bizrnoCert/nxtspki.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
				
		// 아이디 저장 여부
		var userId = $.cookie("userId");
		if (!Util.isEmpty(userId)) {
			$("#ad_user_id").val(userId);
			$("#id_save").attr("checked", true);
		}

		// 아이디 저장
		$("#id_save").click(function() {
			if ($(this).is(":checked") == true) {
				$.cookie("userId", $("#ad_user_id").val());
			} else {
				$.cookie("userId", "");
			}
		});
		
		// 숫자 정규식 체크
		var regExp = /[^0-9]/g;
		$("#ad_ssn").change(function(){
			var v = $(this).val();
			if(!regExp.test(v)){
				$(this).val(v.replace(regExp, ''));
			}
		});
		
		// 사업자 공인인증 초기화
		nxTSPKI.onInit(function(){ 
		});

		nxTSPKI.init(true);
		
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
						page_type : "0",
						loginData : res.data.loginData,
						ad_ssn : $("#ad_ssn").val()
					},
					async : false,
					success : function(
							response) {
						try {
							$("#addd").html(response);
							 if(document.querySelector('span#jb').innerHTML == "Y"){
								 alert("회원 아이디와 사업자번호가 일치한 정보가 없습니다.");
								 return false;
							 }
						} catch (e) {
							if (response != null) {
								jsSysErrorBox(response);
							} else {
								jsSysErrorBox(e);
							}
							return;
						}
						$("#dataForm").submit();
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
		$("#btn_login").click(function() {
			var a = $("#login_type").val();
			var reg = /[^0-9]/g;
			// 기업로그인 일시 사업자 공인인증 로직
			
			/* 2021.03.22 ==== S: 오아림 변경 ====
			if(a == "1")
			{
				
				var verifyVID = true;
		        var options = {};

		        var sessionId = $("#ad_user_id").val();
		        var ssn = $("#ad_ssn").val();
		        var userInfo = $("#ad_user_pw").val();
		        
		        if(ssn == "" || ssn.length != 10){
		        	alert("사업자번호 10자리를 입력해주세요.");
	                return;
		        }
		        
		        if(reg.test(ssn)){
					alert("사업자번호는 숫자만 가능합니다.");
					return;
				}
		        
		        ==== E: 오아림 변경 ===== */
				
	        	/* if (ssn.substring(3,5) == "85") {
	           		alert("본점 사업자번호로만 로그인이 가능합니다.");
	                return;
	           	} */
		        	

				/* 2021.03.22 ==== S: 오아림 변경 ====
		        if(verifyVID == true) {
					if(ssn != "0") {
						options.ssn = ssn;
					}
					else {
						alert("ssn에 입력된 값이 알맞지 않아 신원확인을 수행하지 않습니다.");
					}
		        }

	           	// 사업자 인증이 안된 회원은 사업자인증 팝업 띄우기
	           	$.ajax({
					url : "PGCMLOGIO0010.do",
					type : "POST",
					dataType : "text",
					data : {
						df_method_nm : "certPass",
						ad_user_id : $("#ad_user_id").val(),
						ad_user_pw : $("#ad_user_pw").val(),
						ad_ssn : $("#ad_ssn").val()
					},
					async : false,
					success : function(
							response) {
						try {
							var jsonObj = JSON.parse(response);
							if (jsonObj.result == "X") {
								alert("회원 아이디와 사업자번호가 일치한 정보가 없습니다.");
								return false;
							}
							if (jsonObj.result == "Y") {
								nxTSPKI.loginData(sessionId, ssn, userInfo, options, login_data_complete_callback);
							}
							if (jsonObj.result == "N") {
								// 공인인증 임시 pass
								$("#dataForm").submit();
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
		        //nxTSPKI.loginData(sessionId, ssn, userInfo, options, login_data_complete_callback);
 			}
			else // 일반/기관 로그인 시 기존 로그인 로직 적용

		        ==== E: 오아림 변경 ===== */
				$("#dataForm").submit();
		});

		// 유효성 검사
		$("#dataForm").validate({
			rules : {
				ad_user_id : {
					required : true,
					minlength : 2
				},
				ad_user_pw : {
					required : true,
					minlength : 3
				}
			},
			submitHandler : function(form) {
				$("#df_method_nm").val("checkVaildUser");
				$(form).ajaxSubmit({
					url : "PGCMLOGIO0010.do",
					type : "post",
					dataType : "text",
					async : true,
					success : function(response) {
						try {
							var jsonObj = JSON.parse(response);
							
							if (jsonObj.result == "sucess") {
								$("#df_method_nm").val("processLogin");
								form.submit();
							}
							else if(jsonObj.result == 'fail') {
									$("#err_title").html(Message.msg.failToLoginTitle);
									$("#err_message").html(Message.msg.failToLoginMsg);
							}
							else if(jsonObj.result == 'gubun1') {
								alert("기업회원은 기업 로그인 폼으로 로그인 해주세요.");
							}
							else if(jsonObj.result == 'gubun2') {
								alert("개인/기관회원은 개인/기관 로그인 폼으로 로그인 해주세요.");
							}
							else if(jsonObj.result == 'notcert') {
								$.msgBox({
						            title: "Confirmation",
						            content: "2020년 1월 1일부터 사업자번호 인증에 성공한 계정만 로그인 할 수 있게 변경됩니다. 지금 인증하시겠습니까?",
						            type: "confirm2",
						            // 20200102 나중에 버튼 삭제
						             buttons: [{ value: "예" }, { value: "나중에" }],
						            /* buttons: [{ value: "예" }, {value:"닫기"}], */
						            success: function (result) {
						                if (result == "예") {
						                	$.colorbox({
						                		title : "사업자번호 인증",
						            			href : "<c:url value='/PGCMLOGIO0010.do?df_method_nm=businessNumCert&ad_login_id=" + jsonObj.loginid + "' />",
						            			width : "670",
						            			height : "330",
						            			overlayClose : false,
						            			escKey : false,
						            			iframe : true
						            		});
						                }
						            	 else { // 2020년부터 버튼 '나중에' 삭제하고 else 부분도 주석처리할것
						            		$("#df_method_nm").val("processLogin");
											form.submit();
						            	} 
						            	/* else {
						            			$.colorbox.close();
						            	} */
									}
								});	
							}
							else if(jsonObj.result == 'select') { 
								$.msgBox({
						            title: "Confirmation",
						            content: "비밀번호는 <br />정보통신망 이용촉진 및 정보보호 등에 관한 <br />법률 제28조제1항 및 같은 법 시행령 제15조제6항, <br/>개인정보의 기술적·관리적 보호조치 기준<br/> [방송통신위원회]에 따라 6개월 마다 변경하셔야합니다. <br/>변경하시겠습니까?<br/>",
						            type: "confirm2",
						            buttons: [{ value: "예" }, { value: "아니오" }],
						            success: function (result) {
						                if (result == "예") {
						                	$("#ad_mypage").val("Y");
						                	$("#df_method_nm").val("processLogin");
						                	$("input[name=df_menu_no]").val("79");
						                	$("input[name=df_pmenu_no]").val("73");
						                	form.submit();
						                }
						            	else {
						            		$("#df_method_nm").val("processLogin");
											form.submit();
						            	}
									}
								});
							}
							else if(jsonObj.result == 'noMngUser') {
								$.msgBox({
						            title: "Confirmation",
						            content: "책임자 정보를 등록하세요.",
						            type: "confirm2",
						            // 20200102 나중에 버튼 삭제
						             buttons: [{ value: "예" }, { value: "나중에" }],
						            /* buttons: [{ value: "예" }, {value:"닫기"}], */
						            success: function (result) {
						                if (result == "예") {
						                	$("#manager_page").val("Y");
						                	$("#df_method_nm").val("processLogin");
											form.submit();
						                }
						            	else { // 2020년부터 버튼 '나중에' 삭제하고 else 부분도 주석처리할것
						            		$("#df_method_nm").val("processLogin");
											form.submit();
						            	}
						            	/* else {
						            			$.colorbox.close();
						            	} */
									}
								});	
							}
						} catch (e) {
							jsSysErrorBox(response,e);
							return;
						}
					}
				});
			}
		});
		
		$("#personal").click(function(){
			$("#login_type").val("0");
			$(".toggle").css("display", "none");
		});
		
		$("#enterpr").click(function(){
			$("#login_type").val("1");
			$(".toggle").css("display", "block");
		});
		
		$(".toggle").css("display", "none");
		$("#personal").prop("checked", true);
		$("#login_type").val("0");
		$("#page_type").val("0");
	});
	
	/*
	* 검색단어 입력 후 엔터 시 자동 submit
	*/
	function press(event) {
		if (event.keyCode == 13) {
			$("#btn_login").trigger("click");
			//$("#dataForm").submit();
		}
	}
</script>
</head>

<body>
	<form name="dataForm" id="dataForm" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<%-- <ap:include page="param/dispParam.jsp" /> --%>
		<input type="hidden" name="ad_mypage" id="ad_mypage" value="O" />
		<input type="hidden" name="login_type" id="login_type" value="O" />
		<input type="hidden" name="page_type" id="page_type" value="O" />
		<input type="hidden" name="manager_page" id="manager_page" value="N" />
		<!--//content-->
		<div id="wrap">
			<div class="s_cont" id="s_cont">
		<div class="s_tit s_tit07">
			<h1>인사시스템</h1>
		</div>
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit tit7">인사시스템</h2>
				<ul>
				</ul>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}" />
				</div>
				<div class="r_cont s_cont07_01">
				
				<!--  -->
				<%-- <div class="loginGuide">
					<!-- <img id="loginGuide" alt="로그인 가이드" src="/images2/main/pop/loginGuide.png" usemap="#loginGuide"/>
					<map name="loginGuide" id="#loginGuide">
					 	<area shape="rect" coords="216,319,315,348" href="https://www.mme.or.kr/PGCMLOGIO0010.do?df_method_nm=bsisnoInstall" target="_blank" onfocus="this.blur();" alt="공인인증" /> 
						<area shape="rect" coords="273,356,372,384" href="https://www.mme.or.kr/PGCMLOGIO0010.do?df_method_nm=keyboardEnc" target="_blank" onfocus="this.blur();" alt="키보드보안" /> 
					</map>
					<img alt="로그인 가이드" src="/images2/main/pop/200427_loginGuide.png">
					<img alt="정보변경" src="/images2/main/pop/loginGuide_2.png" usemap="#loginGuide"/> -->
					<H3>보안 프로그램 설치 및 오류 안내</H3>
					<table>
						<caption>설치 프로그램</caption>
						<colgroup>
							<col width="5%">
							<col width="23%">
							<col width="62%">
							<col width="10%">
						</colgroup>
						<thead>
							<tr>
								<th>구분</th>
								<th>프로그램명</th>
								<th>설치 및 오류 안내</th>
								<th>수동설치</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>필수</td>
								<td>
									공인인증서 보안<br/>
									(SCORE PKI for OpenWeb) 
								</td>
								<td class="loginGuide3">
									<p><strong>·전자거래범용(사업장 본점) 및 기업 정보 전용 인증서만 사용가능</strong>하므로, <br/>&nbsp;&nbsp;프로그램 실행시 개인용, 은행용, 전자세금용 공인인증서는 조회되지 않습니다.</p>
									<p><strong>·프로그램 실행시 로딩이 반복되는 경우 프로그램 삭제 후 관리자 권한으로 재설치</strong> 바랍니다.</p>
								</td>
								<td>
									<a href="https://www.mme.or.kr/PGCMLOGIO0010.do?df_method_nm=bsisnoInstall" target="_blank" onfocus="this.blur();" alt="공인인증">
										<span style="color:#2763ba;">[다운로드]</span>
									</a>
								</td>
							</tr>
							<tr>
								<td>선택</td>
								<td>
									키보드 보안<br/>
									(Secure KeyStroke Non-ActiveX)
								</td>
								<td class="loginGuide3">
									<p>·프로그램 미설치 시에도 서비스 이용이 가능하나, 안전한 서비스 이용을 위해 설치를 권장합니다.</p>
									<p><strong>·설치 안내가 반복되는 경우 기업 방화벽 또는 호스트 변조 관련 사항을 해제한 후 재시도</strong> 바랍니다.</p>
								</td>
								<td>
									<a href="https://www.mme.or.kr/PGCMLOGIO0010.do?df_method_nm=keyboardEnc" target="_blank" onfocus="this.blur();" alt="키보드보안">
										<span style="color:#2763ba;">[다운로드]</span>
									</a>
								</td>
							</tr>

						</tbody>
					</table>
					<!--  -->
					<br/><br/>
					<H3>시스템 가입정보 조회 및 변경 안내</H3>
					<table>
						<caption>가입정보 조회/변경</caption>
						<colgroup>
							<col width="90%">
							<col width="10%">
						</colgroup>
						<!-- <thead>
							<tr>
								<th></th>
							</tr>
						</thead> -->
						<tbody>
							<tr>
								<td class="loginGuide3">
									<p>·기업회원 담당자의 부재(퇴사, 변경 등)로 시스템 가입정보(ID/PW)를 확인할 수 없는 경우, 
									<BR/><strong>&nbsp;&nbsp;[고객지원 - 가입정보조회/변경]</strong>에서 담당자 정보를 조회하시거나 변경 신청하시기 바랍니다. (변경 신청 시 24시간 이내에 승인)</p>
								</td>
								<td>
									<a href="#" onclick="jsMoveMenuURL('11','146','PGCMLOGIO0050','PGCMLOGIO0050.do?df_method_nm=index')">
										<span style="color:#2763ba;">[바로가기]</span>
									</a>
								</td>
							</tr>
							
						</tbody>
					</table>
					<!--  -->
				</div> --%>
				<br/><br/>
				<!--  -->
				
					<div class="member_box">
						<div class="login_ico">
							<img src="/images2/sub/member/login_ico.png">
							<h1>Members Login</h1>
						</div>
						<div class="login_form">
							<!-- <div class="check_wrap">
								<ul class="check_sy">
									<li>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									</li>
									<li>
										<input type="radio" id="personal" name="login_value">
										<label for="personal"></label>
										<label for="personal">개인/기관 로그인</label>
									</li>
									<li>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									</li>
									<li>
										<input type="radio" id="enterpr" name="login_value">
										<label for="enterpr"></label>
										<label for="enterpr">기업 로그인</label>
									</li>
								</ul>
							</div> -->
							<div class="form_input userId">
								<img src="/images2/sub/member/id_ico.png">
								<input type="text" id="ad_user_id" name="ad_user_id" placeholder="아이디를 입력하세요." onfocus="this.placeholder=''; return true" >
							</div>
							<div class="eff_wrap">
								<p class="eff_txt" id="chk1" style="display:none;">필수입력 항목입니다.</p>
							</div>
							<input type="hidden" name="loginData" id="loginData" />
							<!-- <div class="form_input userId toggle">
								<img src="/images2/sub/member/biz_ico.png">
								<input type="text" id="ad_ssn" name="ad_ssn" placeholder="- 없이 사업자번호를 입력하세요." onfocus="this.placeholder=''; return true" >
							</div> -->
							<div class="eff_wrap toggle">
								<p class="eff_txt" id="chk3" style="display:none;">필수입력 항목입니다.</p>
							</div>
							<div class="form_input userPass">
								<img src="/images2/sub/member/pass_ico.png">
								<input type="password" id="ad_user_pw" name="ad_user_pw" placeholder="비밀번호를 입력하세요." onfocus="this.placeholder=''; return true" onkeypress="press(event);">
							</div>
							<div class="eff_wrap">
								<p class="eff_txt" id="chk2" style="display:none;">최소 3자 이상이어야 합니다.</p>
							</div>
							<div class="check_wrap">
								<ul class="check_sy">
									<li>
										<input type="checkbox" id="id_save" name="id_save">
										<label for="id_save"></label>
										<label for="id_save">아이디 저장</label>
									</li>
								</ul>
							</div>
							<a href="#none" id="btn_login">로그인</a>
							<!-- <p class="list_noraml"><a class="tradesign_btn" href="http://www.tradesign.net/ra/mme" target="_blank">공인인증서 신청안내</a></p> --><br/><br/>
							<p id="err_title" class="eff_txt"></p>
							<p id="err_message" class="eff_txt"></p>
						</div>
					</div>
					<!-- <p class="list_noraml">기업 정보은 <span>1법인 1계정 가입</span>을 원칙으로 하고 있습니다.</p>
					<p class="list_noraml">이미 등록된 법인등록번호가 있어 회원가입이 불가능한 경우, 담당자 부재(퇴사 등)로  가입정보를 확인할 수 없는 경우, <br>
					<span>가입정보 조회/변경</span>에서 기업 내 업무 담당자를  확인하여 문의 후 기업 정보을 이용해주십시오.</p>
					<p class="list_noraml">키보드 보안 프로그램을 설치 완료하였으나 <span>계속해서 설치 안내 페이지로 이동하는 경우</span>, 기업 내 방화벽 또는 보안 프로그램의 호스트 변조 <br/>관련 사항을 해제한 후 시도해 주시기 바랍니다.</p> -->
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