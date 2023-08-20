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
<%-- <ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox,multifile,jBox" />
<ap:jsTag type="tech" items="msg,util,ucm,my" /> --%>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox,multifile,jBox" />
<ap:jsTag type="tech" items="msg,util,cmn, mainn, subb, font" />

<script type="text/javascript">

$(document).ready(function(){
	
	// mask
	$(".num3").mask('000');
	$(".num4").mask('0000');
	
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
			remove: '<img src="<c:url value="/images/ucm/icon_del.png" />" alt="x" />',
			denied: Message.msg.fildUploadDenied,  		//확장자 제한 문구
			duplicate: Message.msg.fildUploadDuplicate	//중복 파일 문구
		}
	});
	
	// 사업자등록번호 추가
	$("#btn_add_bizrno").click(function(){
		var index = $("input[id^='tx_bizrno_compno_first_']").length + 1;
		var appenStr = "<br /><input type='text' id='tx_bizrno_compno_first_"+ index +"' class='text tx_bizrno_compno' style='width:50px;' />"
						+ " - <input type='text' id='tx_bizrno_compno_middle_"+ index +"' class='text' style='width:30px;' />"
						+ " - <input type='text' id='tx_bizrno_compno_last_"+ index +"' class='text' style='width:70px;' />"
						+ "<input type='hidden' id='ad_bizrno_compno_"+ index +"' name='ad_bizrno_compno_"+ index +"' class='text' />"
		$("#bizrno_td").append(appenStr);
		$("#tx_bizrno_compno_first_" + index).mask('000');
		$("#tx_bizrno_compno_middle_" + index).mask('00');
		$("#tx_bizrno_compno_last_" + index).mask('00000');
		
		$("#ad_bizrno_cnt").val(index);
	});
	
	// 내용변경신청(재발급신청)
	$("#btn_submit").click(function(){
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
	});
	
	// 취소 버튼
	$("#btn_cancel").click(function(){
		parent.$.colorbox.close();
	});
	
}); // ready

// 파라미터 세팅
function setParameter() {
	var zipCodFirst = $("#ad_zip_first").val();
	var zipCodLast = $("#ad_zip_last").val();	
	$("#ad_zip").val("" +zipCodFirst + zipCodLast);
	
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
	
	2015. 08. 01부터 시행되는 우편번호 5자리 변경 관련 수정
	기존의 팝업방식을 그대로 사용하면 되고, 기존에 000-000 으로 '-'이 붙어서 들어오던 것이 
	앞으로는 '-'없이 00000로 들어온다고 함
	--%>
	
	var zipArr = zipNo.replace("-", "");	// 혹시 모를 '-'처리
	$('#ad_zip_first').val(zipArr);		// 우편번호 자리에 그냥 넣어준다.
	$('#ad_hedofc_adres').val(roadAddrPart1+" "+addrDetail);
}

//첨부파일 다운로드
function downAttFile(fileSeq){
	jsFiledownload("/PGCM0040.do","df_method_nm=updateFileDownBySeq&seq="+fileSeq);
}

</script>

</head>
<body>

<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" enctype="multipart/form-data" method="post">

<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/pagingParam.jsp" />

<input type="hidden" id="ad_load_rcept_no" name="ad_load_rcept_no" value="${param.ad_load_rcept_no }" />
<input type="hidden" id="ad_zip" name="ad_zip" />
<input type="hidden" id="ad_reprsnt_tlphon" name="ad_reprsnt_tlphon" />
<input type="hidden" id="ad_fxnum" name="ad_fxnum" />

<input type="hidden" id="ad_bizrno_cnt" name="ad_bizrno_cnt" />

<div id="change01" class="modal" style="z-index:auto;">
<div class="modal_wrap">
<div class="modal_cont">
    <!-- 보완요청보기 -->
    <div class="list_bl" style="margin-bottom: 20px">
    <table class="table_form" style="margin-bottom: 20px">
        <caption>
        기업확인서내용변경신청
        </caption>
        <colgroup>
        <col style="width:18%" />
        <col style="width:35%" />
        <col style="width:15%" />
        <col style="width:*" />
        <%-- <col width="172px">
		<col width="367px">
		<col width="173px">
		<col width="367px"> --%>
        </colgroup>
        <tbody>
            <tr class="table_input">
                <th scope="row" class="point"> 기업명<a href="#none" class="btn_code entrprs_nm_dec"><img src="<c:url value="/images/my/btn_code.png" />" alt="?" /></a></th>
                <td>${applyEntInfo['reqstRcpyList']['ENTRPRS_NM']}</td>
                <th scope="row" class="point">법인등록번호</th>
                <td> ${applyEntInfo['reqstRcpyList']['JURIRNO_FIRST']}-${applyEntInfo['reqstRcpyList']['JURIRNO_LAST']}</td>
            </tr>
            <tr>
                <th scope="row" class="point"> 대표자명<a href="#none" class="btn_code rprsntv_nm_dec"><img src="<c:url value="/images/my/btn_code.png" />" alt="?" /></a></th>
                <td>${applyEntInfo['issuBsisInfo']['RPRSNTV_NM']}</td>
                <th scope="row" class="point">확인서발급번호</th>
                <td>${applyEntInfo['issuBsisInfo']['ISSU_NO']}</td>
            </tr>
            <tr>
                <th scope="row" class="point"> 본사주소<a href="#none" class="btn_code hedofc_adres_dec"><img src="<c:url value="/images/my/btn_code.png" />" alt="?" /></a></th>
                <td colspan="3">
                	<c:if test="${not empty applyEntInfo['issuBsisInfo']['ZIP_FIRST']}">
                	${applyEntInfo['issuBsisInfo']['ZIP_FIRST']}
                    </c:if>
                    
                    <br />
                    ${applyEntInfo['issuBsisInfo']['HEDOFC_ADRES']}
                </td>
            </tr>
            <tr>
                <th scope="row" class="point"> 표준산업분류코드<a href="#none" class="btn_code induty_cod_dec"><img src="<c:url value="/images/my/btn_code.png" />" alt="?" /></a></th>
                <td>${applyEntInfo['reqstRcpyList']['MN_INDUTY_CODE']}</td>
                <th scope="row" class="point"> 주업종명</th>
                <td>${applyEntInfo['reqstRcpyList']['MN_INDUTY_NM']}</td>
            </tr>
            <tr>
                <th scope="row" class="point"> 전화번호</th>
                <td>            
					${applyEntInfo['issuBsisInfo']['REPRSNT_TLPHON_FIRST']}					
                    ~
                    ${applyEntInfo['issuBsisInfo']['REPRSNT_TLPHON_MIDDLE']}
                    ~
                    ${applyEntInfo['issuBsisInfo']['REPRSNT_TLPHON_LAST']}
                </td>
                <th scope="row" class="point"> FAX번호</th>
                <td>
                	${applyEntInfo['issuBsisInfo']['FXNUM_FIRST']}					
                    ~
                    ${applyEntInfo['issuBsisInfo']['FXNUM_MIDDLE']}
                    ~
                    ${applyEntInfo['issuBsisInfo']['FXNUM_LAST']}
               	</td>
            </tr>
            <tr>
                <th scope="row" class="point"> 사업자번호<a href="#none" class="btn_code bizrno_dec"><img src="<c:url value="/images/my/btn_code.png" />" alt="?" /></a></th>
                <td colspan="3" id="bizrno_td">
                	<c:forEach items="${applyEntInfo['bizrnoFormatList'] }" var="bizrnoFormat" varStatus="status">
                	<c:if test="${not status.first }"><br /></c:if>
                	${bizrnoFormat.first }-${bizrnoFormat.middle }-${bizrnoFormat.last }
                	</c:forEach>                	
                </td>
            </tr>
            <tr>
                <td colspan="4" class="tac" scope="row"style="text-align:center;">내용변경신청내용(해당란 체크) <font color="red">사업자등록증은 반드시 제출</font></td>
            </tr>
            <tr>
                <th rowspan="3" class="point" scope="row">구분</th>
                <td colspan="3" class="t_center bg_gray b_l_0" style="background-color:#f5f5f5">변경내용</td>
            </tr>
            <tr>
                <td class="b_l_0 t_center" ><label for="ad_entrprs_nm_change_at">기업명 변경</label></td>
                <td class="b_l_0 t_center" ><label for="ad_qy_cptl_at">영위사업 양도 · 양수</label><a href="#none" class="btn_code qy_cptl_at_dec"><img src="<c:url value="/images/my/btn_code.png" />" alt="?" /></a></td>
                <td class="b_l_0 t_center" ><label for="ad_bizrno_adit_at">사업자등록번호 추가</label></td>
            </tr>
            <tr>
                <td class="b_l_0 t_center"><input type="checkbox" name="ad_entrprs_nm_change_at" id="ad_entrprs_nm_change_at" disabled="disabled" <c:if test="${applyEntInfo['isgnBsisInfo']['ENTRPRS_NM_CHANGE_AT'] == 'Y' }">checked</c:if> /></td>
                <td class="b_l_0 t_center"><input type="checkbox" name="ad_qy_cptl_at" id="ad_qy_cptl_at" disabled="disabled" <c:if test="${applyEntInfo['isgnBsisInfo']['QY_CPTL_AT'] == 'Y' }">checked</c:if> /></td>
                <td class="b_l_0 t_center"><input type="checkbox" name="ad_bizrno_adit_at" id="ad_bizrno_adit_at" disabled="disabled" <c:if test="${applyEntInfo['isgnBsisInfo']['BIZRNO_ADIT_AT'] == 'Y' }">checked</c:if> /></td>
            </tr>
            <tr>
                <th rowspan="2" class="point" scope="row">제출서류 1)</th>
                <td>포괄사업양도양수계약서 사본 또는 합병 계약서 사본</td>
                <th scope="row" class="point">파일첨부</th>
                <td>               	
                    <c:if test="${!empty applyEntInfo['isgnBsisInfo']['FILE_SEQ1']}">
                  		<a href="#none" class="dw_fild" onclick="downAttFile('${applyEntInfo['isgnBsisInfo']['FILE_SEQ1']}')">
                  			${applyEntInfo['isgnBsisInfo']['FILE_NM1']} 
                  		</a>
                  	</c:if>
                </td>
            </tr>
            <tr>
                <td>기타 해당사유 입증 서류</td>
                <th scope="row" class="point">파일첨부</th>
                <td>                	
                    <c:if test="${!empty applyEntInfo['isgnBsisInfo']['FILE_SEQ2']}">
                  		<a href="#none" class="dw_fild" onclick="downAttFile('${applyEntInfo['isgnBsisInfo']['FILE_SEQ2']}')">
                  			${applyEntInfo['isgnBsisInfo']['FILE_NM2']} 
                  		</a>
                  	</c:if>
                </td>
            </tr>
        </tbody>
    </table>
    </div>
<div class="btn_bl">
	<a class="btn_page_blue" href="#none" id="btn_cancel"><span>닫기</span></a>	
</div>
    </div>
    </div>
</div>

</form>

</body>
</html>