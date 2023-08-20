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
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox,multifile,jBox" />
<ap:jsTag type="tech" items="msg,util,cmn, mainn, subb, font" />

<script type="text/javascript">

$(document).ready(function(){
	
	// mask
	$(".num3").mask('000');
	$(".num4").mask('0000');
	$(".num5").mask('00000');
	
	// 우편번호검색
	$('#btn_search_zip').click(function() {
    	var pop = window.open("<c:url value='${SEARCH_ZIP_URL}' />","searchZip","width=570,height=420, scrollbars=yes, resizable=yes");		
    });
	
	// 기업명 툴팁
	$(".entrprs_nm_dec").jBox('Tooltip', {
		content: '변경된 기업명을 입력합니다.(사업자등록증과 동일해야함)'
	});
	
	// 대표자명 툴팁
	$(".rprsntv_nm_dec").jBox('Tooltip', {
		content: '변경된 대표자명을 입력합니다(사업자등록증과 동일해야함)'
	});
	
	// 본사주소 툴팁
	$(".hedofc_adres_dec").jBox('Tooltip', {
		content: '변경된 주소를 입력합니다. (사업자등록증과 동일해야함)'
	});
	
	// 사업자번호 툴팁
	$(".bizrno_dec").jBox('Tooltip', {
		content: '기존 확인서에 명시된 사업자번호와, 추가할 사업자번호를 함께 입력합니다.'
	});
	
	// 표준산업분류코드 툴팁
	$(".induty_cod_dec").jBox('Tooltip', {
		content: '여러 업종을 영위할 경우 3년 매출을 합하여<br /> 매출액이 가장 큰 업종을 주업종으로 함.'
	});
	
	// 영위사업 양도.양수 툴팁
	$(".qy_cptl_at_dec").jBox('Tooltip', {
		content: '대표자, 주소 등 변경신청 시 체크'
	});
	
	// mutifile-upload (양식첨부)
    $("input:file").MultiFile({
		accept: 'hwp|doc|docx|pdf|jpg|jpge|zip',
		max: '1',		
		STRING: {			
			remove: '<img src="<c:url value="/images2/sub/icon_del.png" />" alt="x" />',
			denied: Message.msg.fildUploadDenied,  		//확장자 제한 문구
			duplicate: Message.msg.fildUploadDuplicate	//중복 파일 문구
		}
	});
	
	// 사업자등록번호 추가
	$("#btn_add_bizrno").click(function(){
		var index = $("input[id^='tx_bizrno_compno_first_']").length + 1;
		var appenStr = "<span><br /><input type='text' id='tx_bizrno_compno_first_"+ index +"' class='text tx_bizrno_compno' style='width:50px;' />"
						+ " - <input type='text' id='tx_bizrno_compno_middle_"+ index +"' class='text' style='width:30px;' />"
						+ " - <input type='text' id='tx_bizrno_compno_last_"+ index +"' class='text' style='width:70px;' />"
						+ "<input type='hidden' id='ad_bizrno_compno_"+ index +"' name='ad_bizrno_compno_"+ index +"' class='text' />"
						+ " <img src='/images/ucm/icon_del.png' alt='삭제하기' onclick='$(this).parent().remove()'></span>"
		$("#bizrno_td").append(appenStr);
		$("#tx_bizrno_compno_first_" + index).mask('000');
		$("#tx_bizrno_compno_middle_" + index).mask('00');
		$("#tx_bizrno_compno_last_" + index).mask('00000');
		
		$("#ad_bizrno_cnt").val(index);
	});
	
	// 내용변경신청(재발급신청)
	$("#btn_submit").click(function(){
		
		/* 사업자등록증 필수 첨부 */
		var imgVal = $('#file_proof_document').val(); 

	        if(imgVal==''){ 
	            alert("사업자등록증을 첨부해주세요."); 
	            return false; 
	        } else{

		/*  */
		
		jsMsgBox(null,'confirm', Message.msg.confirmApply, 		
			function(){
				setParameter();				
				$("#df_method_nm").val("processIssueAgain");
				$("#dataForm").ajaxSubmit({
		            url      : "PGMY0060.do",		            
		            dataType : "text",     
		            async    : false,
		            contentType: "multipart/form-data",
		            beforeSubmit : function(){
		            },            
		            success  : function(response) {
		            	try {
		            		if(eval(response)){		            			
			            		jsMsgBox($(this),'info',Message.msg.insertOk, function(){
			            			parent.${ENT_MYPAGE_REQST}
			            		});
		            		}else{
		            			jsMsgBox($(this),'info',Message.msg.failApply);
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
		);
	        }
	});
	
	// 취소 버튼
	$("#btn_cancel").click(function(){
		parent.$.colorbox.close();
	});
	
}); // ready


/* 
//[?]표시 용어설명 
function setDescWord(){
	
	// 기업명 툴팁
	$(".entrprs_nm_dec").jBox('Tooltip', {
		content: '변경된 기업명을 입력합니다.(사업자등록증과 동일해야함)'
	});
	
	// 대표자명 툴팁
	$(".rprsntv_nm_dec").jBox('Tooltip', {
		content: '변경된 대표자명을 입력합니다(사업자등록증과 동일해야함)'
	});
	
	// 본사주소 툴팁
	$(".hedofc_adres_dec").jBox('Tooltip', {
		content: '변경된 주소를 입력합니다. (사업자등록증과 동일해야함)'
	});
	
	// 사업자번호 툴팁
	$(".bizrno_dec").jBox('Tooltip', {
		content: '기존 확인서에 명시된 사업자번호와, 추가할 사업자번호를 함께 입력합니다.'
	});
	
	// 표준산업분류코드 툴팁
	$(".induty_cod_dec").jBox('Tooltip', {
		content: '여러 업종을 영위할 경우 3년 매출을 합하여<br /> 매출액이 가장 큰 업종을 주업종으로 함.'
	});
	
	// 영위사업 양도.양수 툴팁
	$(".qy_cptl_at_dec").jBox('Tooltip', {
		content: '대표자, 주소 등 변경신청 시 체크'
	});	
	
} */

// 파라미터 세팅
function setParameter() {
	var zipCodFirst = $("#ad_zip_first").val();
	//var zipCodLast = $("#ad_zip_last").val();	
	//$("#ad_zip").val("" +zipCodFirst + zipCodLast);
	$("#ad_zip").val("" +zipCodFirst);
	
	var phonumFirst = $("#ad_reprsnt_tlphon_first").val();
	var phonumMiddle = $("#ad_reprsnt_tlphon_middle").val();
	var phonumLast = $("#ad_reprsnt_tlphon_last").val();
	$("#ad_reprsnt_tlphon").val("" + phonumFirst + phonumMiddle + phonumLast);
	
	var fxnumFirst = $("#ad_fxnum_first").val();
	var fxnumMiddle = $("#ad_fxnum_middle").val();
	var fxnumLast = $("#ad_fxnum_last").val();
	$("#ad_fxnum").val("" + fxnumFirst + fxnumMiddle + fxnumLast);
	
	$(".tx_bizrno_compno").each(function(idx){
		var index = idx + 1;
		var bizrnoFirst = $("#tx_bizrno_compno_first_" + index).val();
		var bizrnoMiddle = $("#tx_bizrno_compno_middle_" + index).val();
		var bizrnoLast = $("#tx_bizrno_compno_last_" + index).val();
		
		$("#ad_bizrno_compno_" + index).val("" + bizrnoFirst + bizrnoMiddle + bizrnoLast);
	});
	
}

//도로명주소 검색 콜백
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
	
	var zipArr = Util.str.split(zipNo,'-');	
	$('#ad_zip_first').val(zipArr[0]);
	$('#ad_zip_last').val(zipArr[1]);
	$('#ad_hedofc_adres').val(roadAddrPart1+" "+addrDetail);
	//$('#ad_hedofc_adres_02_ho').val(addrDetail);
	--%>
	
	var zipArr = zipNo.replace("-", "");	// 혹시 모를 '-'처리
	$('#ad_zip_first').val(zipArr);		// 우편번호 자리에 그냥 넣어준다.
	$('#ad_hedofc_adres').val(roadAddrPart1+" "+addrDetail);
}

//첨부파일 다운로드
function downAttFile(fileSeq){
	jsFiledownload("/PGCM0040.do","df_method_nm=updateFileDownBySeq&seq="+fileSeq);
}

//첨부파일 삭제
function delAttFile(fileSeq,id){
	
	var rcept_no = $("#ad_again_rcept_no").val();
	
	jsMsgBox(null
			,'confirm'
			,Message.msg.confirmDelete
			,function(){
				$.ajax({        
			        url      : "PGMY0060.do",
			        type     : "POST",
			        dataType : "text",
			        data     : { df_method_nm: "updateDelAttFile"
			        		   , rcept_no: rcept_no
			        	       , file_seq: fileSeq
			        	       , file_gubun: id
			        	       },                
			        async    : false,                
			        success  : function(response) {
			        	try {        		
			        		if(eval(response)) {
			        			$("#file_"+id).attr("disabled",false);
			        			$("#file_disp_"+id).remove();
			        			jsMsgBox(null,'info',Message.msg.successDelete);
			                } else {
			                	jsMsgBox(null,'info',Message.msg.failDelete);
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
	);			
}

</script>

</head>
<body>

<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" enctype="multipart/form-data" method="post">

<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/pagingParam.jsp" />

<input type="hidden" id="ad_load_rcept_no" name="ad_load_rcept_no" value="${param.ad_load_rcept_no }" />
<input type="hidden" id="ad_again_rcept_no" name="ad_again_rcept_no" value="${param.ad_again_rcept_no }" />
<input type="hidden" id="ad_zip" name="ad_zip" />
<input type="hidden" id="ad_reprsnt_tlphon" name="ad_reprsnt_tlphon" />
<input type="hidden" id="ad_fxnum" name="ad_fxnum" />

<input type="hidden" id="ad_bizrno_cnt" name="ad_bizrno_cnt" />

<div id="change01" class="modal" style="z-index:auto;">
		<div class="modal_wrap">
			 <div class="modal_cont">
				<p class="list_noraml">내용변경신청 메뉴는 재출력 또는 유효기간 연장을 위한 용도가 아닙니다. <br/>
				기업명, 대표자명, 주소, 사업자등록번호 등 기발급된 확인서의 내용을 변경하고자 하실때 신청하시기 바랍니다.</p>
				<div class="list_bl" style="margin-bottom: 20px">
					<table class="table_form" style="margin-bottom: 20px">
						<caption>기업정보</caption>
						<colgroup>
							<col width="172px">
							<col width="367px">
							<col width="173px">
							<col width="367px">
						</colgroup>
						<tbody>
							<tr class="table_input">
								<th class="p_l_30">기업명<img src="/images2/sub/help_btn.png" class="help_btn entrprs_nm_dec"></th>
								<td class="b_l_0"><input type="text" name="ad_entrprs_nm" id="ad_entrprs_nm" placeholder="기업명" value="${applyEntInfo['reqstRcpyList']['ENTRPRS_NM']}"></td>
								<th class="p_l_30">법인등록번호</th>
								<td class="b_l_0">${applyEntInfo['reqstRcpyList']['JURIRNO_FIRST']}-${applyEntInfo['reqstRcpyList']['JURIRNO_LAST']}</td>
							</tr>
							<tr class="table_input">
								<th class="p_l_30">대표자명<img src="/images2/sub/help_btn.png" class="help_btn"></th>
								<td class="b_l_0"><input type="text" name="ad_rprsntv_nm" id="ad_rprsntv_nm" value="${applyEntInfo['issuBsisInfo']['RPRSNTV_NM']}" placeholder="홍길동"></td>
								<th class="p_l_30">확인서발급번호</th>
								<td class="b_l_0">${applyEntInfo['issuBsisInfo']['ISSU_NO']}</td>
							</tr>
							<tr class="table_input">
								<th class="p_l_30">본사주소<img src="/images2/sub/help_btn.png" class="help_btn"></th>
								<td class="b_l_0" colspan="3"><input type="text" name="ad_zip_first" id="ad_zip_first" value="${applyEntInfo['issuBsisInfo']['ZIP_FIRST']}" style="width: 143px;"><a href="#none" id="btn_search_zip" class="gray_btn">우편번호 검색</a><input type="text" name="ad_hedofc_adres" id="ad_hedofc_adres" value="${applyEntInfo['issuBsisInfo']['HEDOFC_ADRES']}" style="width: 686px; margin-top: 7px;"></td>
							</tr>
							<tr>
								<th class="p_l_30">표준산업<br/>분류코드<img src="/images2/sub/help_btn.png" class="help_btn" style="margin-left: 0;"></th>
								<td class="b_l_0">${applyEntInfo['reqstRcpyList']['MN_INDUTY_CODE']}</td>
								<th class="p_l_30">주업종명</th>
								<td class="b_l_0">${applyEntInfo['reqstRcpyList']['MN_INDUTY_NM']}</td>
							</tr>
							<tr class="table_input">
								<th class="p_l_30">전화번호</th>
								<td class="b_l_0">
									<select class="select_box" id="ad_reprsnt_tlphon_first" name="ad_reprsnt_tlphon_first" style="width:80px; ">
				                        <c:forTokens items="${PHONE_NUM_FIRST_TOKEN}" delims="," var="phoneNum">
										<option value="${phoneNum}" <c:if test="${applyEntInfo['issuBsisInfo']['REPRSNT_TLPHON_FIRST'] eq phoneNum}">selected</c:if> >${phoneNum}</option>
										</c:forTokens>
				                    </select>
				                    <input type="text" name="ad_reprsnt_tlphon_middle" id="ad_reprsnt_tlphon_middle" value="${applyEntInfo['issuBsisInfo']['REPRSNT_TLPHON_MIDDLE']}" style="width: 66px; margin-left: 3px; margin-right: 3px;">-<input type="text" name="ad_reprsnt_tlphon_last" id="ad_reprsnt_tlphon_last" value="${applyEntInfo['issuBsisInfo']['REPRSNT_TLPHON_LAST']}" style="width: 66px; margin-left: 3px;">
								</td>
								<th class="p_l_30">FAX번호</th>
								<td class="b_l_0">
									<select class="select_box" id="ad_fxnum_first" name="ad_fxnum_first" style="width:80px; ">
				                        <c:forTokens items="${PHONE_NUM_FIRST_TOKEN}" delims="," var="phoneNum">
										<option value="${phoneNum}" <c:if test="${applyEntInfo['issuBsisInfo']['FXNUM_FIRST'] eq phoneNum}">selected</c:if> >${phoneNum}</option>
										</c:forTokens>
				                    </select>
				                    -<input type="text" name="ad_fxnum_middle" id="ad_fxnum_middle" value="${applyEntInfo['issuBsisInfo']['FXNUM_MIDDLE']}" style="width: 66px; margin-left: 3px; margin-right: 3px;">-<input type="text" name="ad_fxnum_last" id="ad_fxnum_last" value="${applyEntInfo['issuBsisInfo']['FXNUM_LAST']}" style="width: 66px; margin-left: 3px;">
								</td>
							</tr>
							<tr>
								<!-- <th class="p_l_30">사업자번호<img src="/images2/sub/help_btn.png" class="help_btn"><a href="#none" id="btn_add_bizrno" class="form_blBtn" style="padding:2px 8px 1px 8px; text-align:center;">사업자번호<br/>추가</a></th> -->
								<th class="p_l_30">사업자번호
								<a href="#none" id="btn_add_bizrno" class="form_blBtn" style="padding:2px 8px 1px 8px; text-align:center;">추가</a>
								<img src="/images2/sub/help_btn.png" class="help_btn">
								</th>
								<td class="b_l_0" id="bizrno_td" colspan="3">
									<c:forEach items="${applyEntInfo['bizrnoFormatList'] }" var="bizrnoFormat" varStatus="status">
				                		<c:if test="${not status.first }"><br /></c:if>
				                			${bizrnoFormat.first }-${bizrnoFormat.middle }-${bizrnoFormat.last }
				                	</c:forEach>
								</td>
							</tr>
							<tr style="border-bottom: 1px solid #222">
								<td class="t_center" colspan="4">내용변경신청내용(해당란 체크)</td>
							</tr>
							<tr>
								<th class="p_l_30" rowspan="3">구분</th>
								<td class="t_center bg_gray b_l_0" colspan="3"><strong clss="s_strong"><span class="t_blu">변경내용선택</span> (중복선택가능)</strong></td>
							</tr>
							<tr>
								<td class="b_l_0 t_center"><label for="type1">기업명 변경</label></td>
								<td class="b_l_0 t_center"><label for="type2">영위사업 양도·양수<img src="/images2/sub/help_btn.png" class="help_btn"></label></td>
								<td class="b_l_0 t_center"><label for="type3">사업자등록번호 추가</label></td>
							</tr>
							<tr>
								<td class="b_l_0 t_center">
									<ul class="check_sy2 check_sy2_1">
										<li>
											<input type="checkbox" id="ad_entrprs_nm_change_at" name="ad_entrprs_nm_change_at" value="Y" <c:if test="${applyEntInfo['issuBsisInfo']['ENTRPRS_NM_CHANGE_AT'] == 'Y'}">checked</c:if> />
											<label for="ad_entrprs_nm_change_at"></label>
										</li>
									</ul>
								</td>
								<td class="b_l_0 t_center">
									<ul class="check_sy2 check_sy2_1">
										<li>
											<input type="checkbox" id="ad_qy_cptl_at" name="ad_qy_cptl_at" value="Y" <c:if test="${applyEntInfo['issuBsisInfo']['QY_CPTL_AT'] == 'Y'}">checked</c:if> />
											<label for="ad_qy_cptl_at"></label>
										</li>
									</ul>
								</td>
								<td class="b_l_0 t_center">
									<ul class="check_sy2 check_sy2_1">
										<li>
											<input type="checkbox" id="ad_bizrno_adit_at" name="ad_bizrno_adit_at" value="Y" <c:if test="${applyEntInfo['issuBsisInfo']['BIZRNO_ADIT_AT'] == 'Y'}">checked</c:if> />
											<label for="ad_bizrno_adit_at"></label>
										</li>
									</ul>
								</td>
							</tr>
							<tr class="table_input">
								<th class="p_l_30" rowspan="2">제출서류 1)</th>
								<td class="b_l_0">포괄사업양도양수계약서 사본 또는 합병 계약서 사본</td>
								<th class="p_l_30">파일첨부</th>
								<td class="b_l_0">
									<div class="filebox">
										<input class="upload-name" disabled="disabled" placeholder="선택된 파일 없음" style="width: 188px;"><!-- 공백
										--><label for="file_contract_document" class="gray_btn">파일선택</label>
										<input type="file" id="file_contract_document" name="fi_con_doc" class="upload-hidden upload-hidden01" <c:if test="${!empty applyEntInfo['issuBsisInfo']['FILE_SEQ1']}">disabled</c:if> />
										<c:if test="${!empty applyEntInfo['issuBsisInfo']['FILE_SEQ1']}">
						                  	<div id="file_disp_contract_document">                  		
							                   	<a href="#none" onclick="delAttFile('${applyEntInfo['issuBsisInfo']['FILE_SEQ1']}','contract_document')"><img src="<c:url value="/images2/sub/icon_del.png" />" alt="삭제하기" /> </a>
							                   	<a href="#none" onclick="downAttFile('${applyEntInfo['issuBsisInfo']['FILE_SEQ1']}')">${applyEntInfo['issuBsisInfo']['FILE_NM1']} </a>
						                  	</div>
					                  	</c:if>
									</div>
								</td>
							</tr>
							<tr class="table_input">
								<td class="b_l_0">기타 해당사유 입증 서류 <span class="t_red">(사업자등록증 필수 제출)</span></td>
								<th><img src="/images2/sub/table_check.png">파일첨부</th>
								<td class="b_l_0">
									<div class="filebox">
										<input class="upload-name" disabled="disabled" placeholder="선택된 파일 없음" style="width: 188px;"><!-- 공백
										--><label for="file_proof_document" class="gray_btn">파일선택</label>
										<input type="file" required id="file_proof_document" name="fi_proof_doc" class="upload-hidden upload-hidden01" <c:if test="${!empty applyEntInfo['issuBsisInfo']['FILE_SEQ2']}">disabled</c:if> />
										<c:if test="${!empty applyEntInfo['issuBsisInfo']['FILE_SEQ2']}">
						                  	<div id="file_disp_proof_document">                  		
							                   	<a href="#none" onclick="delAttFile('${applyEntInfo['issuBsisInfo']['FILE_SEQ2']}','proof_document')"><img src="<c:url value="/images2/sub/icon_del.png" />" alt="삭제하기" /> </a>
							                   	<a href="#none" onclick="downAttFile('${applyEntInfo['issuBsisInfo']['FILE_SEQ2']}')">${applyEntInfo['issuBsisInfo']['FILE_NM2']} </a>
						                  	</div>
					                  	</c:if>
									</div>
								</td>
							</tr>
							<tr class="table_input" style="border-bottom:0;">
								<td class="b_l_0" style="border-bottom:0;" colspan="4"><p class="ess_txt"><img src="/images2/sub/table_check.png">항목은 입력 필수 항목입니다.</p></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn_bl">
					<a href="#none" id="btn_submit">저장</a>
					<a href="#none" id="btn_cancel" class="wht">취소</a>
				</div>
			</div>
		</div>
	</div>

</form>

</body>
</html>