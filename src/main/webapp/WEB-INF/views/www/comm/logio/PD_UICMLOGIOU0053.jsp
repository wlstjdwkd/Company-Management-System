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
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox,blockUI,flot" />
<ap:jsTag type="tech" items="msg,util,font,cmn,subb,pc" />
<script type="text/javascript">
$(document).ready(function(){
	// DOM 변경 후 세팅 적용
	afterChangeDOM();
	
	$('#seces01').css('display', 'none');
	$('#seces02').css('display', 'none');
	$('#seces03').css('display', 'none');
	
	// 신청
	$("#btn_save_request").click(function(){
		var form = document.dataForm;
		var isValidA = $('#dataForm').valid();
		var isValidB = checkNumeirc();
		var isValidC = checkEmail(form.ad_user_email.value);
		if(!isValidC){
			return false;
		}
		
		if(!isValidA|!isValidB|!isValidC){
			$('#seces01').css('display', 'block');
			$("#msg_detail").html(Message.msg.checkEssVal);
			return;
		}else{
			$('#seces02').css('display', 'block');
			$("#msg_detail2").html(Message.msg.confirmApply);		
		}
	});
	
	$("#btn_ok2").click(function(){
		$('#seces02').css('display', 'none');
		okGo();
	});
	
	$("#btn_cancel2").click(function(){
		$('#seces02').css('display', 'none');
	});
	
	$("#finally_Close").click(function(){
		$('#seces03').css('display', 'none');
		parent.$("#cboxClose").click();
	});
	
	$("#infoType2").click(function() {
		var ep_no = "${dataParam.USER_NO}";
		var bizrno = "${dataParam.BIZRNO}";
		
		var form = document.dataForm;
		
		form.action = "<c:url value='/PGCMLOGIO0050.do' />";
		form.df_method_nm.value = "chargerInfo";
		form.ad_ep_no.value = ep_no;
		form.ad_bizrno.value = bizrno;
		form.ad_se.value = "2";
		form.submit();
	});
});

function okGo(){
	$("#df_method_nm").val("processSaveRequest");
	$("#ad_se").val("1");
	$("#load_msg").text(Message.msg.loadingApply);
	
	// 폼 데이터
	$("#dataForm").ajaxSubmit({
        url      : "PGCMLOGIO0050.do",
        dataType : "json",            
        async    : false,
        contentType: "multipart/form-data",
        beforeSubmit : function(){
        },            
        success  : function(response) {
        	try {			            		
        		if(response.result){
        			if(eval(response)){
        				$('#seces03').css('display', 'block');
        				$("#msg_detail3").html("담당자 변경신청이 완료되었습니다.\n변경이 완료되면 메일로 안내받으실 수 있습니다.");
//            			jsMsgBox(null,'info',Message.msg.successSaveCharger,function(){
//            				$.colorbox.close();
//            			});
            		}else{
            			$('#seces03').css('display', 'block');
        				$("#msg_detail3").html(Message.msg.failSave);
//            			jsMsgBox(null,'info',Message.msg.failSave);
            		}
        		}else{
        			$('#seces03').css('display', 'block');
    				$("#msg_detail3").html(Message.msg.failSaveCharger);
//        			jsMsgBox($(this),'info',Message.msg.failSaveCharger);
        		}
        		
            } catch (e) {
                if(response != null) {
                	$('#seces03').css('display', 'block');
    				$("#msg_detail3").html(response);
                	//jsSysErrorBox(response);
                } else {
                	$('#seces03').css('display', 'block');
    				$("#msg_detail3").html(e);
                    //jsSysErrorBox(e);
                }
                return;
            }
        }
    });			
	
//	jsMsgBox(null
//		,'confirm'				
//		,"아이디와 비밀번호 수신을 위해 수신동의 정보가<br />모두 '동의'로 변경이 됩니다.<br />동의하시겠습니까?"
//		,function(){
//
//		}					
//	);
}

//DOM 변경 후 세팅 적용
function afterChangeDOM(){
	// 유효성, 마스킹
    setValidation();
}

//유효성, 마스킹
function setValidation(){
	$("#dataForm").validate();
	
	$(".max100").each(function(){
		$(this).rules("add", {max:100});
	});
	
    $('input:file').each(function(){
    	$(this).rules('add', {
    		extension: "pdf,png,jpg,jpge"
        });
    });
    
	$('.yyyy-MM-dd').mask('0000-00-00');
	$(".qota_rt").mask('999.99');
	$(".-numeric18").mask('-9999999999999999.99', {
		translation: {
			'-': {pattern: /-/, optional: true}
		}
	});
	$(".numeric16").mask('0000000000000000');
	$(".numeric10").mask('0000000000');
	$(".numeric7").mask('0000000');
	$(".numeric6").mask('000000');
	$(".numeric5").mask('00000');
	$(".numeric4").mask('0000');
	$(".numeric3").mask('000');
	$(".numeric2").mask('00');
}


function checkNumeirc(){
	var $obj = $("input[class*='numeric']");
	var rtn = true;
	$obj.each(function(){
		var val = $(this).val();
		var filter = /^-?(|[0-9]+|[0-9]+\.[0-9]{1,2})$/;
		var result = filter.test(val);
		if(!result){			
			$(this).focus();
			rtn = false;
		}
	});
	return rtn;
}

function checkEmail(chkEmail){
	var email = chkEmail;
	var regex=/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
	 
	if(regex.test(email) === false) {
		$('#seces01').css('display', 'block');
		$("#msg_detail").html("잘못된 이메일 형식입니다.");
	 return false;
	} else {
	 // gogo
	 return true;
	}
}

</script>
</head>
<body>

<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post" enctype="multipart/form-data">

	<ap:include page="param/defaultParam.jsp" />
	<%-- <ap:include page="param/dispParam.jsp" /> --%>
	<ap:include page="param/pagingParam.jsp" />

	<input type="hidden" id="ad_ep_no" name="ad_ep_no" value="" />
	<input type="hidden" id="ad_bizrno" name="ad_bizrno" value="" />
	<input type="hidden" id="ad_se" name="ad_se" value="" />
	
	<div id="changeInfo" class="modal">
		<div class="modal_wrap">
			 <div class="modal_cont">
				<div class="list_bl">
					<h4 class="fram_bl" style="margin-bottom: 6px;">기업명정보</h4>
					<table class="table_form" style="margin-bottom: 20px">
						<caption>기업명정보</caption>
						<colgroup>
							<col width="172px">
							<col width="367px">
							<col width="173px">
							<col width="367px">
						</colgroup>
						<tbody>
							<tr class="table_input" style="border-top: 0; border-bottom: 1px solid #222;">
								<td class="b_l_0 p_l_0" style="border-bottom:0;" colspan="2">
									<ul class="radio_sy">
										<li style="margin-right: 35px;">
											<input type="radio" id="infoType1" name="infoType" value="1" checked="check">
											<label for="infoType1"></label>
											<label for="infoType1">담당자</label>
										</li>
										<li>
											<input type="radio" id="infoType2" name="infoType" value="2">
											<label for="infoType2"></label>
											<label for="infoType2">기업명</label>
										</li>
									</ul>
								</td>
								<td class="b_l_0" style="border-bottom:0;" colspan="2"><p class="ess_txt"><img src="/images2/sub/table_check.png">항목은 입력 필수 항목입니다.</p></td>
							</tr>
							<c:forEach items="${findEntCharger}" var="findEntCharger" varStatus="status">
								<tr>
									<th class="p_l_30">기업명</th>
									<td class="b_l_0" colspan="3">${findEntCharger.entrprsNm }</td>
									<input type="hidden" id="entrprsNm" name="entrprsNm" value="${findEntCharger.entrprsNm}" />
									<input type="hidden" id="jurirno" name="jurirno" value="${findEntCharger.jurirno}" />
									<input type="hidden" id="bizrno" name="bizrno" value="${findEntCharger.bizrno}" />
								</tr>
								<tr class="table_input">
									<th class="p_l_30">기존 담당자</th>
									<td class="b_l_0">${dataMap.chargerNm }</td>
									<th><img src="/images2/sub/table_check.png">신규 담당자</th>
									<td class="b_l_0"><input type="text" required name="ad_user_nm" id="ad_user_nm" value="" placeholder="담당자 이름을 입력해 주세요."></td>
								</tr>
								<tr class="table_input">
									<th class="p_l_30">담당자부서</th>
									<td class="b_l_0">${dataMap.chargerDept }</td>
									<th><img src="/images2/sub/table_check.png">담당자부서</th>
									<td class="b_l_0"><input type="text" required name="ad_dept" id="ad_dept" value="" placeholder="담당자의 소속부서를 입력해 주세요."></td>
								</tr>
								<tr class="table_input">
									<th class="p_l_30">직위</th>
									<td class="b_l_0">${dataMap.ofcps }</td>
									<th><img src="/images2/sub/table_check.png">직위</th>
									<td class="b_l_0"><input type="text" required name="ad_ofcps" id="ad_ofcps" value="" placeholder="담당자의 직위를 입력해 주세요."></td>
								</tr>
								<tr class="table_input">
									<th class="p_l_30">전화번호</th>
									<td class="b_l_0">${dataMap.TELNO1 }-${dataMap.TELNO2 }-${dataMap.TELNO3 }</td>
									<th><img src="/images2/sub/table_check.png">전화번호</th>
									<td class="b_l_0">
										<select name="ad_tel_first2" class="select_box" id="ad_tel_first2" style="width:70px; ">
											<c:forTokens items="${PHONE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
											<option value="${firstNum }">${firstNum }</option>
											</c:forTokens>
										</select>
										-<input type="text" required name="ad_tel_middle2" id="ad_tel_middle2" class="numeric4" value="" style="width: 80px; margin-left: 3px; margin-right: 3px;">-<input type="text" class="numeric4" required name="ad_tel_last2" id="ad_tel_last2" value="" style="width: 80px; margin-left: 3px;">
									</td>
								</tr>
								<tr class="table_input">
									<th class="p_l_30">휴대전화번호</th>
									<td class="b_l_0">${dataMap.mbtlnum1 }-${dataMap.mbtlnum2 }-${dataMap.mbtlnum3 }</td>
									<th><img src="/images2/sub/table_check.png">휴대전화번호</th>
									<td class="b_l_0">
										<select name="ad_phon_first" class="select_box" id="ad_phon_first" style="width:70px; ">
											<c:forTokens items="${MOBILE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
											<option value="${firstNum }" >${firstNum }</option>
											</c:forTokens>
										</select>
										-<input type="text" required name="ad_phon_middle" class="numeric4" id="ad_phon_middle" value="" style="width: 80px; margin-left: 3px; margin-right: 3px;">-<input type="text" class="numeric4" required name="ad_phon_last" id="ad_phon_last" value="" style="width: 80px; margin-left: 3px;">
									</td>
								</tr>
								<tr class="table_input">
									<th class="p_l_30">이메일</th>
									<td class="b_l_0">${dataMap.email }</td>
									<th><img src="/images2/sub/table_check.png">이메일</th>
									<td class="b_l_0"><input type="text" required name="ad_user_email" id="ad_user_email" value="" placeholder="이메일을 입력해 주세요."></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<div class="list_bl" style="margin-bottom: 27px;">
					<h4 class="fram_bl">첨부파일</h4>
					<table class="table_form m_b_10" style="width:100%;">
						<caption>첨부파일</caption>
						<colgroup>
							<col width="172px">
							<col width="*">
						</colgroup>
						<tbody>
							<tr class="table_input">
								<th><img src="/images2/sub/table_check.png">사업자등록증</th>
								<td class="b_l_0">
									<div class="filebox">
										<input class="upload-name" disabled="disabled" placeholder="선택된 파일 없음" style="width: 507px;"><!-- 공백
										--><label for="file_ho_rf1" class="gray_btn">파일선택</label>
										<input type="file" required id="file_ho_rf1" name="file_ho_rf1" class="upload-hidden upload-hidden01">
									</div>
								</td>
							</tr>
							<tr class="table_input">
								<th><img src="/images2/sub/table_check.png">재직증명서</th>
								<td class="b_l_0">
									<div class="filebox">
										<input class="upload-name" disabled="disabled" placeholder="선택된 파일 없음" style="width: 507px;"><!-- 공백
										--><label for="file_ho_rf2" class="gray_btn">파일선택</label>
										<input type="file" required id="file_ho_rf2" name="file_ho_rf2" class="upload-hidden upload-hidden02">
									</div>
								</td>
							</tr>
							<tr class="table_input">
								<td class="b_l_0" colspan="2">
									<p class="t_blu">※ 아이디 분실 기업의 경우, 담당자 변경 후 아이디찾기를 통해 아이디를 확인하시기 바랍니다.</p>
									<p class="t_blu">※ 신청 후 <span class="t_pnk">24시간 이내</span>에 변경이 완료되며, <span class="t_pnk">메일</span>로 안내받으실 수 있습니다.</p>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn_bl">
					<a href="#none" id="btn_save_request">신청</a>
				</div>
			</div>
		</div>
	</div>
	<div id="seces01" class="modal2">
		<div class="modal_wrap">
			<div class="modal_header"> 
				<h1>Confirmation</h1>
			</div>
			 <div class="modal_cont">
				<div class="img_quide" style="padding-top:55px;">
					<div class="img_guide_txt">
					<img src="/images2/sub/mypage/seces_ico.png" style="margin-left:-50px;"><!--공백제거
					--><p id="msg_detail" style="padding-left:40px;"></p>
					</div>
				</div>
				<div class="btn_bl">
					<a href="#none" onclick="$('#seces01').css('display', 'none')" ><span>Yes</span></a>
				</div>
			 </div>
		</div>
	</div>
	<div id="seces02" class="modal2">
		<div class="modal_wrap">
			<div class="modal_header"> 
				<h1>Confirmation</h1>
			</div>
			 <div class="modal_cont">
				<div class="img_quide" style="padding-top:55px;">
					<div class="img_guide_txt">
					<img src="/images2/sub/mypage/seces_ico.png" style="margin-left:-50px;"><!--공백제거
					--><p id="msg_detail2" style="padding-left:40px;"></p>
					</div>
				</div>
				<div class="btn_bl">
					<a href="#none" id="btn_ok2" ><span>Yes</span></a>
					<a href="#none" id="btn_cancel2" class="wht"><span>No</span></a>
				</div>
			 </div>
		</div>
	</div>
	<div id="seces03" class="modal2">
		<div class="modal_wrap">
			<div class="modal_header"> 
				<h1>Confirmation</h1>
			</div>
			 <div class="modal_cont">
				<div class="img_quide" style="padding-top:55px;">
					<div class="img_guide_txt">
					<img src="/images2/sub/mypage/seces_ico.png" style="margin-left:-50px;vertical-align:sub;"><!--공백제거
					--><p id="msg_detail3" style="padding-left:40px;width:200px;"></p>
					</div>
				</div>
				<div class="btn_bl">
					<a href="#none" id="finally_Close" ><span>Yes</span></a>
				</div>
			 </div>
		</div>
	</div>
	<!-- 저장 버튼// -->
</form>

</body>
</html>