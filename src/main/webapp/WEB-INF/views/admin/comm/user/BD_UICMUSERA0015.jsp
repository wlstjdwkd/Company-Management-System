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
	// 책임자 전화번호
	$('#ad_manager_tel_middle').mask('0000');
	$('#ad_manager_tel_last').mask('0000');
	// 책임자 휴대전화번호
	$('#ad_manager_phon_middle').mask('0000');
	$('#ad_manager_phon_last').mask('0000');
	
	// 유효성 검사
	$("#dataForm").validate({  
		rules : {// 아이디  				
    			ad_user_id: {    				
    				required: true,
    				minlength: 8,
    				maxlength: 20,
    				alphanumeric: true,
    				firstAlpha: true,			// 첫글자는 영문
    				includeAlphaAtLeast2: true	// 최소 영문 2글자 포함
    			},// 비밀번호
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
    			},// 비밀번호 확인
    			ad_confirm_password: {
    				required: true,
    				minlength: 8,
    				maxlength: 20,
    				equalTo: "#ad_user_pw"
    			},// 권한설정
    			ad_chk_auth: {
    				required: true
    			},// 기업명
    			ad_entrprs_nm: {
    				required: true,
    				maxlength: 255
    			},// 대표자명
    			ad_rprsntv_nm: {
    				required: true,
    				maxlength: 50
    			},    			
    			// 법인등록번호 앞자리
    			ad_jurirno_first: {
    				required: true,
    				minlength: 6,
    				maxlength: 6,
    			},// 법인등록번호 뒷자리
    			ad_jurirno_last: {
    				required: true,
    				minlength: 7,
    				maxlength: 7,
    			},// 사업자등록번호 처음
    			ad_bizrno_first: {
    				required: true,
    				minlength: 3,
    				maxlength: 3,
    			},// 사업자등록번호 가운데
    			ad_bizrno_middle: {
    				required: true,
    				minlength: 2,
    				maxlength: 2,
    			},// 사업자등록번호 마지막
    			ad_bizrno_last: {
    				required: true,
    				minlength: 5,
    				maxlength: 5,
    			},// 주소상세02
    			ad_addr_detail02:{    				
    				maxlength: 100
    			},// 이름
    			ad_user_nm:{    				
    				required: true
    			},// 책임자 이름
    			ad_manager_user_nm:{    				
    				required: true
    			},// 소속부서
    			ad_dept:{
    				required: true,
    				maxlength: 13
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
    			},// 휴대전화 가운데
    			ad_phon_middle: { 	
    				required: true
    			},// 휴대전화 마지막
    			ad_phon_last: { 	
    				required: true    			 
    			},// 책임자 휴대전화 가운데
    			ad_manager_phon_middle: { 	
    				required: true
    			},// 책임자 휴대전화 마지막
    			ad_manager_phon_last: { 	
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
				checkpwd = true;
			}
			
			if(checkpwd == true) {
				// 법인등록번호 중복 검사 여부 확인
				var isValidJurirno = $('#ad_chk_jurirno').val();
				if(Util.str.toUpperCase(isValidJurirno)=="N"){
					
					<c:if test="${formType == 'UPDATE'}">
						if(${fn:substring(dataVO.jurirno, 0, 6)} != $('#ad_jurirno_first').val() || 
								${fn:substring(dataVO.jurirno, 6, 13)} != $('#ad_jurirno_last').val()) {
							jsMsgBox($("#btn_dupl_jurirno"),'info',Message.template.chkDuplInfo('법인등록번호'));
							return;
						}
	            	</c:if>
	            	<c:if test="${formType == 'INSERT'}">
		            	jsMsgBox($("#btn_dupl_jurirno"),'info',Message.template.chkDuplInfo('법인등록번호'));
						return;
	            	</c:if>
				}
				
				// 휴대전화번호 조립
				var ad_phon_first 	= $('#ad_phon_first').val();
				var ad_phon_middle 	= $('#ad_phon_middle').val();
				var ad_phon_last 	= $('#ad_phon_last').val();			
				var ad_phone_num 	= ""+ad_phon_first+ad_phon_middle+ad_phon_last;
				$('#ad_phone_num').val(ad_phone_num);
				
				// 책임자 휴대전화번호 조립
				var ad_manager_phon_first 	= $('#ad_manager_phon_first').val();
				var ad_manager_phon_middle 	= $('#ad_manager_phon_middle').val();
				var ad_manager_phon_last 	= $('#ad_manager_phon_last').val();			
				var ad_manager_phone_num 	= ""+ad_manager_phon_first+ad_manager_phon_middle+ad_manager_phon_last;
				$('#ad_manager_phone_num').val(ad_manager_phone_num);
				
				// 법인번호 조립
				var ad_jurirno_first	= $('#ad_jurirno_first').val();
				var ad_jurirno_last 	= $('#ad_jurirno_last').val();
				var ad_jurirno 			= ""+ad_jurirno_first+ad_jurirno_last;
				$('#ad_jurirno').val(ad_jurirno);
	
				// 사업자번호 조립
				var ad_bizrno_first 	= $('#ad_bizrno_first').val();
				var ad_bizrno_middle 	= $('#ad_bizrno_middle').val();
				var ad_bizrno_last 		= $('#ad_bizrno_last').val();
				var ad_bizrno			= ""+ad_bizrno_first+ad_bizrno_middle+ad_bizrno_last;
				$('#ad_bizrno').val(ad_bizrno);
	
				// 전화번호 조립
				var ad_tel_first 	= $('#ad_tel_first').val();
				var ad_tel_middle 	= $('#ad_tel_middle').val();
				var ad_tel_last 	= $('#ad_tel_last').val();
				var ad_tel			= ""+ad_tel_first+ad_tel_middle+ad_tel_last;
				$('#ad_tel').val(ad_tel);
				
				// 담당자 전화번호 조립
				var ad_tel_first2 	= $('#ad_tel_first2').val();
				var ad_tel_middle2 	= $('#ad_tel_middle2').val();
				var ad_tel_last2 	= $('#ad_tel_last2').val();
				var ad_tel2			= ""+ad_tel_first2+ad_tel_middle2+ad_tel_last2;
				$('#ad_tel2').val(ad_tel2);
				
				// 책임자 전화번호 조립
				var ad_manager_tel_first 	= $('#ad_manager_tel_first').val();
				var ad_manager_tel_middle 	= $('#ad_manager_tel_middle').val();
				var ad_manager_tel_last 	= $('#ad_manager_tel_last').val();
				var ad_manager_tel			= ""+ad_manager_tel_first+ad_manager_tel_middle+ad_manager_tel_last;
				$('#ad_manager_tel').val(ad_manager_tel);
				
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
				var ad_addr_detail01	= $('#ad_addr_detail01').val();
				var ad_addr_detail02 	= $('#ad_addr_detail02').val();
				var ad_addr		= ""+ad_addr_detail01+" "+ad_addr_detail02;
				$('#ad_addr').val(ad_addr);
				
				// 휴대전화, 이메일 중복 확인
				$.ajax({
	                url      : "PGCMLOGIO0040.do",
	                type     : "POST",
	                dataType : "json",
	                data     : { df_method_nm	: "checkDuplEntUserInfo"
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
	
	// 법인등록번호 중복 체크
    $("#btn_dupl_jurirno").click(function(){
    	var isvalid01 = $('#ad_jurirno_first').valid();
    	var isvalid02 = $('#ad_jurirno_last').valid();
    	
    	if(!isvalid01){
    		jsMsgBox($('#ad_jurirno_first'),'info',Message.template.wrongInfo('법인등록번호'));
    		return;
    	}
    	
    	if(!isvalid02){
    		jsMsgBox($('#ad_jurirno_last'),'info',Message.template.wrongInfo('법인등록번호'));
    		return;
    	}
    	
    	<c:if test="${formType == 'UPDATE'}">
			var msgParam = '법인등록번호';
			if(${fn:substring(dataVO.jurirno, 0, 6)} == $('#ad_jurirno_first').val() && 
					${fn:substring(dataVO.jurirno, 6, 13)} == $('#ad_jurirno_last').val()) {
				jsMsgBox($("#btn_dupl_jurirno"),'info',Message.template.validInfo(msgParam));
           		$('#ad_chk_jurirno').val('Y');
           		return;
			}
		</c:if>
    	
    	var ad_jurirno = ""+$('#ad_jurirno_first').val()+$('#ad_jurirno_last').val();
    	
   		$.ajax({
               url      : "PGCMLOGIO0040.do",
               type     : "POST",
               dataType : "text",
               data     : { df_method_nm: "checkDuplJrirno", ad_jurirno: ad_jurirno, ad_user_no: '${dataVO.userNo }'},
               async    : false,                
               success  : function(response) {
               	try {
               			var msgParam = '법인등록번호';
                       	if(eval(response)) {
                    	   	jsMsgBox($("#btn_dupl_jurirno"),'info',Message.template.validInfo(msgParam));
                       		$('#ad_chk_jurirno').val('Y');
                       	} else {
                    	   	jsMsgBox($("#btn_dupl_jurirno"),'info',Message.template.existInfo(msgParam));
                       		$('#ad_chk_jurirno').val('N');
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
    	var pop = window.open("<c:url value='${SEARCH_ZIP_URL}' />","searchZip","width=570,height=420, scrollbars=yes, resizable=yes");		
    });
    
 	// 취소
    $("#btn_cancel").click(function() {
    	$("#df_method_nm").val("");
    	document.dataForm.submit();
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
	$('#ad_addr_detail01').val(roadAddrPart1);
	$('#ad_addr_detail02').val(addrDetail);
	--%>
	
	var zipArr = zipNo.replace("-", "");	// 혹시 모를 '-'처리
	$('#ad_zipcod_first').val(zipArr);		// 우편번호 자리에 그냥 넣어준다.
	$('#ad_addr_detail01').val(roadAddrPart1);
	$('#ad_addr_detail02').val(addrDetail);
}
</script>

</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
	<ap:include page="param/defaultParam.jsp" />
	<ap:include page="param/dispParam.jsp" />
	<ap:include page="param/pagingParam.jsp" />
	
	<input type="hidden" name="ad_chk_id" id="ad_chk_id" value="N" />
	<input type="hidden" name="ad_chk_jurirno" id="ad_chk_jurirno" value="N" />
		
	<input type="hidden" name="ad_join_type" id="ad_join_type" value="${dataVO.emplyrTy }" />
	<input type="hidden" name="ad_phone_num" id="ad_phone_num" />
	
	<input type="hidden" name="ad_manager_phone_num" id="ad_manager_phone_num" />
	<input type="hidden" name="ad_manager_tel" id="ad_manager_tel" />
	
	<input type="hidden" name="ad_jurirno" id="ad_jurirno" />
	<input type="hidden" name="ad_bizrno" id="ad_bizrno" />
	<input type="hidden" name="ad_tel" id="ad_tel" />
	<input type="hidden" name="ad_tel2" id="ad_tel2" />
	<input type="hidden" name="ad_fax" id="ad_fax" />
	<input type="hidden" name="ad_zipcod" id="ad_zipcod" />
	<input type="hidden" name="ad_addr" id="ad_addr" />
	
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
                    
                    <!-- 기업회원 입력사항 -->                    
                    <div class="block">
                        <h3 class="mgt30">기업정보</h3>
                        <!--// 등록 -->
                        <table cellpadding="0" cellspacing="0" class="table_basic" summary="" >
                            <caption>
                            </caption>
                            <colgroup>
                            <col width="25%" />
                            <col width="*" />
                            </colgroup>
                            <tr>
                                <th scope="row" class="point"><label for="ad_entrprs_nm"> 기업명</label></th>
                                <td><input name="ad_entrprs_nm" type="text" id="ad_entrprs_nm" value="${dataVO.entrprsNm }" class="text" placeholder="귀사의 기업명을 입력해 주세요." onfocus="this.placeholder=''; return true" style="width:395px;"/></td>
                            </tr>
                            <tr>
                                <th scope="row" class="point"><label for="ad_rprsntv_nm"> 대표자명</label></th>
                                <td><input name="ad_rprsntv_nm" type="text" id="ad_rprsntv_nm" value="${dataVO.rprsntvNm }" class="text" placeholder="귀사의 대표자 이름을 입력해 주세요." onfocus="this.placeholder=''; return true" style="width:395px;"/></td>
                            </tr>
                            <tr>
                                <th scope="row" class="point"><label for="ad_jurirno">법인등록번호</label></th>
                                <td><input name="ad_jurirno_first" type="text" id="ad_jurirno_first" value="<c:out value="${fn:substring(dataVO.jurirno, 0, 6)}" />" class="text" style="width:186px;" title="법인등록번호앞번호" />
                                    ~
                                    <input name="ad_jurirno_last" type="text" id="ad_jurirno_last" value="<c:out value="${fn:substring(dataVO.jurirno, 6, 13)}" />" class="text"style="width:186px;" title="법인등록번호뒷번호" />
                                    <div class="btn_inner ml10"><a href="#" id="btn_dupl_jurirno" class="btn_in_gray"><span>중복체크</span></a></div></td>
                            </tr>
                            <tr>
                                <th scope="row" class="point"><label for="ad_bizrno"> 사업자등록번호</label></th>
                                <td><input name="ad_bizrno_first" type="text" id="ad_bizrno_first" value="<c:out value="${fn:substring(dataVO.bizrno, 0, 3)}" />" class="text" style="width:106px;" title="사업자등록번호앞번호" />
                                    ~
                                    <input name="ad_bizrno_middle" type="text" id="ad_bizrno_middle" value="<c:out value="${fn:substring(dataVO.bizrno, 3, 5)}" />" class="text" style="width:121px;" title="사업자등록번호가운데번호" />
                                    ~
                                    <input name="ad_bizrno_last" type="text" id="ad_bizrno_last" value="<c:out value="${fn:substring(dataVO.bizrno, 5, 10)}" />" class="text" style="width:121px;" title="사업자등록번호마지막번호" /></td>
                            </tr>
                            <tr>
                                <th rowspan="3" scope="row"><label for="ad_zipcod">주소</label></th>
                                <td class="rows">
                                	<input name="ad_zipcod_first" type="text" id="ad_zipcod_first" value="<c:out value="${dataVO.hedofcZip}" />" class="text" style="width:188px;" title="우편번호" readonly />
                                    <!-- -
                                    <input name="ad_zipcod_last" type="text" id="ad_zipcod_last" value="<c:out value="${fn:substring(dataVO.zip, 3, 6)}" />" class="text" style="width:187px;" title="우편번호뒷자리" readonly /> -->
                                    <div class="btn_inner ml10"><a href="#" id="btn_search_zip" class="btn_in_gray"><span>우편번호 검색</span></a></div></td>
                            </tr>
                            <tr>
                                <td class="rows"><input name="ad_addr_detail01" type="text" id="ad_addr_detail01" value="${dataVO.hedofcAdres }" class="text" style="width:395px;" title="주소상세"  placeholder="우편번호를 검색하시면 자동 입력됩니다." readonly /></td>
                            </tr>
                            <tr>
                                <td class="rows"><input name="ad_addr_detail02" type="text" id="ad_addr_detail02" class="text" style="width:395px;" title="주소상세" placeholder="나머지 주소를 입력해 주세요." /></td>
                            </tr>
                            <tr>
                                <th scope="row"><label for="ad_tel">전화번호</label></th>
                                <td><select name="ad_tel_first" id="ad_tel_first" style="width:101px; ">
                                        <c:forTokens items="${PHONE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
											<option value="${firstNum }" <c:if test="${dataMap.TELNO1 == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
										</c:forTokens>	
                                    </select>
                                    ~
                                    <input name="ad_tel_middle" type="text" id="ad_tel_middle" value="${dataMap.TELNO2 }" class="text"style="width:127px;" title="전화번호중간번호" />
                                    ~
                                    <input name="ad_tel_last" type="text" id="ad_tel_last" value="${dataMap.TELNO3 }" class="text"style="width:127px;" title="전화번호마지막번호" /></td>
                            </tr>
                            <tr>
                                <th scope="row"><label for="ad_fax">팩스번호</label></th>
                                <td><select name="ad_fax_first" id="ad_fax_first" style="width:101px; ">
                                        <c:forTokens items="${PHONE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
											<option value="${firstNum }" <c:if test="${dataMap.FXNUM1 == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
										</c:forTokens>	
                                    </select>
                                    ~
                                    <input name="ad_fax_middle" type="text" id="ad_fax_middle" value="${dataMap.FXNUM2 }" class="text"style="width:127px;" title="팩스중간번호" />
                                    ~
                                    <input name="ad_fax_last" type="text" id="ad_fax_last" value="${dataMap.FXNUM3 }" class="text"style="width:127px;" title="팩스마지막번호" />
                            	</td>
                            </tr>
                        </table>
                    </div>
                    
                    <!-- 책임자 정보 등록 20200701 -->
                    <div class="block">
                        <h3 class="mgt30">책임자정보</h3>
                        <table cellpadding="0" cellspacing="0" class="table_basic" summary="" >
                            <caption>
                            </caption>
                            <colgroup>
                            <col width="25%" />
                            <col width="*" />
                            </colgroup>
                            <tr>
                                <th scope="row" class="point"><label for="ad_manager_user_nm"> 이름</label></th>
                                <td><input name="ad_manager_user_nm" type="text" id="ad_manager_user_nm" value="${manager.chargerNm }" class="text" style="width:395px;"  placeholder="담당자 이름을 입력해 주세요." /></td>
                            </tr>
                            <tr>
                                <th scope="row" class="point"><label for="ad_manager_dept">소속부서</label></th>
                                <td><input name="ad_manager_dept" type="text" id="ad_manager_dept" value="${manager.chargerDept }" class="text" style="width:395px;"  placeholder="담당자의 소속부서를 입력해 주세요." /></td>
                            </tr>
                            <tr>
                                <th scope="row"><label for="ad_manager_ofcps">직위</label></th>
                                <td><input name="ad_manager_ofcps" type="text" id="ad_manager_ofcps" value="${manager.ofcps }" class="text" style="width:395px;"  placeholder="담당자의 직위를 입력해 주세요." /></td>
                            </tr>
                            <tr>
                                <th scope="row"><label for="ad_tel">전화번호</label></th>
                                <td><select name="ad_manager_tel_first" id="ad_manager_tel_first" style="width:101px; ">
                                        <c:forTokens items="${PHONE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
											<option value="${firstNum }" <c:if test="${manager.telNo.first == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
										</c:forTokens>	
                                    </select>
                                    ~
                                    <input name="ad_manager_tel_middle" type="text" id="ad_manager_tel_middle" value="${manager.telNo.middle }" class="text"style="width:127px;" title="전화번호중간번호" />
                                    ~
                                    <input name="ad_manager_tel_last" type="text" id="ad_manager_tel_last" value="${manager.telNo.last }" class="text"style="width:127px;" title="전화번호마지막번호" /></td>
                            </tr>
                            <tr>
                                <th scope="row" class="point"><label for="ad_phon"> 휴대전화번호</label></th>
                                <td><select name="ad_manager_phon_first" id="ad_manager_phon_first" style="width:101px; ">
                                        <c:forTokens items="${MOBILE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
											<option value="${firstNum }" <c:if test="${manager.mbtlNum.first == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
										</c:forTokens>	
                                    </select>
                                    ~
                                    <input name="ad_manager_phon_middle" type="text" id="ad_manager_phon_middle" value="${manager.mbtlNum.middle }" class="text"style="width:127px;" title="핸드폰가운데번호" />
                                    ~
                                    <input name="ad_manager_phon_last" type="text" id="ad_manager_phon_last" value="${manager.mbtlNum.last }" class="text"style="width:127px;" title="핸드폰마지막번호" /></td>
                            </tr>
                            <tr>
                                <th scope="row" class="point"><label for="ad_manager_user_email"> 이메일</label></th>
                                <td><input name="ad_manager_user_email" type="text" id="ad_manager_user_email" value="${manager.email }" class="text" style="width:395px;"  placeholder="기업에서 관리 가능한 이메일을 입력해 주세요." /></td>
                            </tr>
                            <tr>
                                <th scope="row"><label for="info16">이메일수신</label></th>
                                <td>
                                	<input name="ad_manager_rcv_email" type="radio" id="ad_manager_rcv_email" value="Y" <c:if test="${manager.emailRecptnAgre == 'Y' }">checked</c:if> />
                                	<label for="ad_manager_rcv_email">신청</label>
                                	<input name="ad_manager_rcv_email" type="radio" id="ad_manager_rcv_email_reject" class="ml85" value="N" <c:if test="${manager.emailRecptnAgre == 'N' }">checked</c:if> />
                                	<label for="ad_manager_rcv_email_reject">신청안함</label></td>
                            </tr>
                            <tr>
                                <th scope="row"><label for="info18">SMS수신</label></th>
                                <td>
                                	<input name="ad_manager_rcv_sms" type="radio" id="ad_manager_rcv_sms" value="Y" <c:if test="${manager.smsRecptnAgre == 'Y' }">checked</c:if> />
                                	<label for="ad_manager_rcv_sms">신청</label>
                                	<input name="ad_manager_rcv_sms" type="radio" id="ad_manager_rcv_sms_reject" class="ml85" value="N" <c:if test="${manager.smsRecptnAgre == 'N' }">checked</c:if> />
                                	<label for="ad_manager_rcv_sms_reject">신청안함</label></td>
                            </tr>
                        </table>
                    </div>
                    <div class="block">
                        <h3 class="mgt30">담당자(개인)정보 </h3>
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
                                <td><input name="ad_user_nm" type="text" id="ad_user_nm" value="${dataVO.chargerNm }" class="text" style="width:395px;"  placeholder="담당자 이름을 입력해 주세요." /></td>
                            </tr>
                            <tr>
                                <th scope="row" class="point"><label for="ad_dept">소속부서</label></th>
                                <td><input name="ad_dept" type="text" id="ad_dept" value="${dataVO.chargerDept }" class="text" style="width:395px;"  placeholder="담당자의 소속부서를 입력해 주세요." /></td>
                            </tr>
                            <tr>
                                <th scope="row"><label for="ad_ofcps">직위</label></th>
                                <td><input name="ad_ofcps" type="text" id="ad_ofcps" value="${dataVO.ofcps }" class="text" style="width:395px;"  placeholder="담당자의 직위를 입력해 주세요." /></td>
                            </tr>
                            <tr>
                                <th scope="row"><label for="ad_tel">전화번호</label></th>
                                <td><select name="ad_tel_first2" id="ad_tel_first2" style="width:101px; ">
                                        <c:forTokens items="${PHONE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
											<option value="${firstNum }" <c:if test="${dataMap.TELNO2_1 == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
										</c:forTokens>	
                                    </select>
                                    ~
                                    <input name="ad_tel_middle2" type="text" id="ad_tel_middle2" value="${dataMap.TELNO2_2 }" class="text"style="width:127px;" title="전화번호중간번호" />
                                    ~
                                    <input name="ad_tel_last2" type="text" id="ad_tel_last2" value="${dataMap.TELNO2_3 }" class="text"style="width:127px;" title="전화번호마지막번호" /></td>
                            </tr>
                            <tr>
                                <th scope="row" class="point"><label for="ad_phon"> 휴대전화번호</label></th>
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
                                <td><input name="ad_user_email" type="text" id="ad_user_email" value="${dataVO.email }" class="text" style="width:395px;"  placeholder="기업에서 관리 가능한 이메일을 입력해 주세요." /></td>
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