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
		
		if(!isValidA | !isValidB){
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
	
	$("#infoType1").click(function() {
		var ep_no = "${dataParam.USER_NO}";
		var bizrno = "${dataParam.BIZRNO}";
		
		var form = document.dataForm;
		
		form.action = "<c:url value='/PGCMLOGIO0050.do' />";
		form.df_method_nm.value = "chargerInfo";
		form.ad_ep_no.value = ep_no;
		form.ad_bizrno.value = bizrno;
		form.ad_se.value = "1";
		form.submit();
	});

});

function okGo(){
	$("#df_method_nm").val("processSaveRequest");
	$("#ad_ep_no").val("${dataParam.USER_NO}");
	$("#ad_se").val("2");
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
        				$("#msg_detail3").html("기업명 변경신청이 완료되었습니다.\n변경이 완료되면 메일로 안내받으실 수 있습니다.");
//            			jsMsgBox(null,'info',Message.msg.successSaveEntrprsNm,function(){
//            				$.colorbox.close();
//            			});
            		}else{
            			$('#seces03').css('display', 'block');
        				$("#msg_detail3").html(Message.msg.failSave);
//            			jsMsgBox(null,'info',Message.msg.failSave);
            		}
        		}else{
        			$('#seces03').css('display', 'block');
    				$("#msg_detail3").html(Message.msg.failSaveEntrprsNm);
//        			jsMsgBox($(this),'info',Message.msg.failSaveEntrprsNm);
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
//		,Message.msg.confirmApply
//		,function(){
//		alert(35);
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
											<input type="radio" id="infoType1" name="infoType" value="1" >
											<label for="infoType1"></label>
											<label for="infoType1">담당자</label>
										</li>
										<li>
											<input type="radio" id="infoType2" name="infoType" value="2" checked="check">
											<label for="infoType2"></label>
											<label for="infoType2">기업명</label>
										</li>
									</ul>
								</td>
								<td class="b_l_0" style="border-bottom:0;" colspan="2"><p class="ess_txt"><img src="/images2/sub/table_check.png">항목은 입력 필수 항목입니다.</p></td>
							</tr>
							<c:forEach items="${findEntCharger}" var="findEntCharger" varStatus="status">
								<tr class="table_input">
									<th class="p_l_30">기업명</th>
									<td class="b_l_0">${findEntCharger.entrprsNm }</td>
									<th><img src="/images2/sub/table_check.png">기업명</th>
									<td class="b_l_0"><input type="text" required name="entrprsNm" id="entrprsNm" value="" placeholder="기업명을 입력해 주세요."></td>
								</tr>
								<tr>
									<th class="p_l_30">기존 담당자</th>
									<td class="b_l_0" colspan="3">${dataMap.chargerNm }</td>
								</tr>
								<tr>
									<th class="p_l_30">담당자부서</th>
									<td class="b_l_0" colspan="3">${dataMap.chargerDept }</td>
								</tr>
								<tr>
									<th class="p_l_30">직위</th>
									<td class="b_l_0" colspan="3">${dataMap.ofcps }</td>
								</tr>
								<tr>
									<th class="p_l_30">전화번호</th>
									<td class="b_l_0" colspan="3">${dataMap.TELNO1 }-${dataMap.TELNO2 }-${dataMap.TELNO3 }</td>
								</tr>
								<tr>
									<th class="p_l_30">휴대전화번호</th>
									<td class="b_l_0" colspan="3">${dataMap.mbtlnum1 }-${dataMap.mbtlnum2 }-${dataMap.mbtlnum3 }</td>
								</tr>
								<tr>
									<th class="p_l_30">이메일</th>
									<td class="b_l_0" colspan="3">${dataMap.email }</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<div class="list_bl" style="margin-bottom: 27px;">
					<h4 class="fram_bl">첨부파일</h4>
					<table class="table_form m_b_10"  style="width:100%;">
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
</form>

</body>
</html>