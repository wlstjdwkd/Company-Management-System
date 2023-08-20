<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@	taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>	
<ap:jsTag type="web" items="jquery,form,validate,selectbox,notice,msgBox,blockUI,colorbox,ui,mask,multifile,jBox" />
<ap:jsTag type="tech" items="msg,util,font,cmn,mainn,subb,ic,etc" />
<ap:globalConst />
<c:set var="entUserVo" value="${sessionScope[SESSION_ENTUSERINFO_NAME]}" />
<script type="text/javascript">
// 기업개황 전역변수
var gDartdata = {};
// 관계기업아이디 초기값
var gDfAddRcpyId = 0;

$(document).ready(function(){
	var i;
	for(i=1; i<${relateEntInfos.size()}+1; i++) {
		if($("#ad_cpr_regist_se_"+i).val() == 'L') {
			$("#ad_crncy_code_"+i).css("display","none");
			$("#ad_crncy_code_"+i).append("<option value='KRW'>한국</option>");
			$("#ad_crncy_code_"+i).val("KRW");
		}
	}
	
	// 사업자등록번호 추가
	$("#btn_add_bizrno").click(function(){
		var index = $("input[id^='tx_bizrno_compno_first_']").length + 1;
		var lastIndex = $("input[id^='tx_bizrno_compno_first_']").last().attr("name");
		
		if(lastIndex === undefined){
			lastIndex = 0;
		}
		lastIndex++;
		
		var appenStr = "<span><br /><input type='text' id='tx_bizrno_compno_first_"+ lastIndex +"' class='text tx_bizrno_compno' name='"+lastIndex+"' style='width:50px;' />"
						+ " - <input type='text' id='tx_bizrno_compno_middle_"+ lastIndex +"' class='text' style='width:30px;' />"
						+ " - <input type='text' id='tx_bizrno_compno_last_"+ lastIndex +"' class='text' style='width:70px;' />"
						+ "<input type='hidden' id='ad_bizrno_compno_"+ lastIndex +"' name='ad_bizrno_compno_"+ lastIndex +"' class='text' />"
						/* + " <img src='/images/ucm/icon_del.png' alt='삭제하기' onclick='$(this).parent().remove()'></span>" */
						+ " <img src='/images/ucm/icon_del.png' alt='삭제하기' onclick='bizNumRemove($(this))'></span>"
						
		$("#bizrno_td").append(appenStr);
		$("#tx_bizrno_compno_first_" + lastIndex).mask('000');
		$("#tx_bizrno_compno_middle_" + lastIndex).mask('00');
		$("#tx_bizrno_compno_last_" + lastIndex).mask('00000');
		
		// 사업자번호 추가 시 파일 필수
		$("#file_ho_rf4").attr("required",true);
		
		// 사업자등록번호 개수 세팅
		$("#ad_bizrno_cnt").val(index);
		
		$("#tx_bizrno_compno_first_1").rules("remove");
	});
	
	// 로딩 화면
	$(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
	
	// 주주명부, 재무정보, 상시근로자수 닫기 버튼 표시
	$("#btn_skrt_open").css("display","none");
	$("#btn_fnnrinfo_open").css("display","none");
	$("#btn_rabrr_open").css("display","none");
	// 중소기업유예확인정보 닫기 버튼 표시
	$("#btn_excpt_open").css("display","none");
	
	// 관계기업추가 버튼
	$("#btn_add_rcpy").click(function(){
		// 관계기업추가
		addRcpy();
		// DOM 변경 후 세팅 적용
		afterChangeDOM();
		
		// numberOnly-속성: 숫자만 입력
		/* $("input:text[numberOnly]").on("keyup", function() {
		    $(this).val($(this).val().replace(/[^0-9]/g,""));
		}); */
	});
	
	// 주주명부 열기
	$("#btn_skrt_open").click(function(){
		$("#div_skrt_con").show();		
		$("#btn_skrt_close").show();
		$(this).hide();
		
	});
	// 주주명부 닫기
	$("#btn_skrt_close").click(function(){
		$("#div_skrt_con").hide();		
		$("#btn_skrt_open").show();
		$(this).hide();
	});
	
	// 재무정보 열기
	$("#btn_fnnrinfo_open").click(function(){		
		$("#div_fnnrinfo_con").show();		
		$("#btn_fnnrinfo_close").show();
		$(this).hide();
		
	});
	// 재무정보 닫기
	$("#btn_fnnrinfo_close").click(function(){
		$("#div_fnnrinfo_con").hide();		
		$("#btn_fnnrinfo_open").show();
		$(this).hide();
	});
	
	// 상시근로자수 열기
	$("#btn_rabrr_open").click(function(){		
		$("#div_rabrr_con").show();		
		$("#btn_rabrr_close").show();
		$(this).hide();
		
	});
	// 상시근로자수 닫기
	$("#btn_rabrr_close").click(function(){
		$("#div_rabrr_con").hide();		
		$("#btn_rabrr_open").show();
		$(this).hide();
	});
	
	// 중소기업유예확인정보 열기
	$("#btn_excpt_open").click(function(){
		$("#div_excpt_con").show();		
		$("#btn_excpt_close").show();
		$(this).hide();
		
	});
	// 중소기업유예확인정보 닫기
	$("#btn_excpt_close").click(function(){
		$("#div_excpt_con").hide();		
		$("#btn_excpt_open").show();
		$(this).hide();
	});
	
	// 우편번호검색
	$('#btn_search_zip').click(function() {
    	var pop = window.open("<c:url value='${SEARCH_ZIP_URL}' />","searchZip","width=570,height=420, scrollbars=yes, resizable=yes");		
    });
	
	// 확인신청대상년도 변경
	//$("#ad_issu_year").change(function() {		
		//var year = $(this).val();
		var year = $("#ad_issu_year").val();
		// 재무정보 재생성
		//getFnnrConTmp(year);
		/*
		/////////////////////// 2015-04-14 상시근로자수 재생성 주석처리 ///////////////////////
		왜 재생성을?
		*/
		// 상시근로자수 재생성
		//getRabrrConTmp(year);
		
		// 추가관련기업 생성
		//getRcpyConTmp();
		
		// DOM 변경 후 세팅 적용
		afterChangeDOM();
		
		// 주주명부, 재무정보, 상시근로자수 열림 상태로 변경
		changeStatusOpen();
	//});
	
	// 확인신청대상년도 초기화
	//initIssuYear();
	
	// 결산월(신청기업) 초기화
	//initStacntMt("ho");
	
	// 설립년월일(신청기업) 초기화
	initFondDe("ho");
	
	// numberOnly-속성: 숫자만 입력
	$("input:text[numberOnly]").on("keyup", function() {
	    $(this).val($(this).val().replace(/[^0-9]/g,""));
	});
	
	// 용도(사업명)-속성: required 추가
	$("input[name=reqst_se_search]").attr('required','required');

	// 임시저장
	$("#btn_save_temp").click(function(){
		setParameter();	
		chkCprRegistSe();
		changeStatusOpen();		
		validateSelngAmRelate();
		var isValidA = $('#dataForm').valid();
		var isValidB = checkNumeirc();	
		var lastYear = $("#ad_issu_year").val();
		$("#ad_reqst_se_search").val(getCheckboxValues('reqst_se_search'));
		
		if(!isValidA|!isValidB){
			// 필수 입력사항 항목별 메세지
			if(!isValidA){
				if ($("#ad_rprsntv_nm_ho").val() == "") {
					jsMsgBox(null,'info',Message.template.required("대표자명"));
					return;
				} else if ($("#ad_hedofc_adres_01_ho").val() == "") {
					jsMsgBox(null,'info',Message.template.required("본사주소"));
					return;
				} else if ($("#largeGroup").val() == "noSelect") {
					jsMsgBox(null,'info',Message.template.required("주업종"));
					return;
				} else if ($("#ad_reprsnt_tlphon_middle_ho").val() == "" || $("#ad_reprsnt_tlphon_last_ho").val() == "") {
					jsMsgBox(null,'info',Message.template.required("전화번호"));
					return;
				} /* else if ($("#ad_hedofc_adres_01_ho").val() == "") { // 결산월은 셀렉트박스 선택되어 있음
					jsMsgBox(null,'info',Message.template.required("결산월"));
					return;
				} */ else if ($("#ad_fond_de_ho").val() == "") {
					jsMsgBox(null,'info',Message.template.required("설립년월"));
					return;
				} else if ($("input[name=reqst_se_search]:checked").length == 0) {
					jsMsgBox(null,'info',Message.template.required("용도"));
					return;
				} else if ($("#ad_shrholdr_nm1_ho").val() == "") {
					jsMsgBox(null,'info',Message.template.required("주주명"));
					return;
				} else if ($("#ad_qota_rt1_ho").val() == "") {
					jsMsgBox(null,'info',Message.template.required("지분율"));
					return;
				} else if ($("#ad_selng_am_ho_"+lastYear).val() == "") {
					jsMsgBox(null,'info',Message.template.required("매출액"));
					return;
				} else if ($("#ad_assets_totamt_ho_"+lastYear).val() == "") {
					jsMsgBox(null,'info',Message.template.required("자산총액"));
					return;
				}
			}
			jsMsgBox(null,'info',Message.msg.checkEssVal);
			return;
		}else{
			jsMsgBox(null
				,'confirm'
				<c:choose>
				<c:when test="${isAdminOrBiz eq 'Y'}">
					,Message.msg.confirmSave
				</c:when>				
				<c:otherwise>
					<c:choose>
					<c:when test="${(!empty applyEntInfo['resnManageS'] && applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS3)}">
					,Message.msg.confirmSave
					</c:when>
					<c:otherwise>
					,Message.msg.confirmSaveTemp
					</c:otherwise>
					</c:choose>					 
				</c:otherwise>
				</c:choose>				
				,function(){
					<c:choose>
					<c:when test="${isAdminOrBiz eq 'Y'}">
						$("#load_msg").text(Message.msg.loadingSave);
					</c:when>				
					<c:otherwise>
						<c:choose>
						<c:when test="${(!empty applyEntInfo['resnManageS'] && applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS3)}">
							$("#load_msg").text(Message.msg.loadingSave);
						</c:when>       
						<c:otherwise>
							$("#load_msg").text(Message.msg.loadingTempSave);
						</c:otherwise>
						</c:choose>					 
					</c:otherwise>
					</c:choose>	
					
					$("#df_method_nm").val("processSaveRequest");
					$("#ad_reqst_se").val("AK0");
					var rcpyIdArr = new Array();
					$("input[name='addRcpyId']").each(function(){
						var addRcpyId = Number($(this).val());						
						rcpyIdArr.push(addRcpyId);
					});
					
					// 폼 데이터
			    	$("#dataForm").ajaxSubmit({
			            url      : "PGIC0022.do",
			            data     : { ad_rcpy_id: rcpyIdArr.toString() },
			            dataType : "json",            
			            async    : false,
			            contentType: "multipart/form-data",
			            beforeSubmit : function(){
			            },            
			            success  : function(response) {
			            	try {
			            		if(response.result){
			            			var rceptNo = response.rceptNo;
				            		$("#ad_load_rcept_no").val(rceptNo);
				            		<c:choose>
									<c:when test="${isAdminOrBiz eq 'Y'}">
									jsMsgBox($(this),'info',Message.msg.successSave);
									</c:when>				
									<c:otherwise>
										<c:choose>
										<c:when test="${(!empty applyEntInfo['resnManageS'] && applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS3)}">
										jsMsgBox($(this),'info',Message.msg.successSave,function(){
											${ENT_MYPAGE_REQST}	
										});
										</c:when>       
										<c:otherwise>
										jsMsgBox($(this),'info',Message.msg.successSaveTemp);
										</c:otherwise>
										</c:choose>					 
									</c:otherwise>
									</c:choose>				            		
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
	
	// 신청
	$("#btn_save_request").click(function(){
		setParameter();	
		chkCprRegistSe();
		changeStatusOpen();		
		validateSelngAmRelate();
		var isValidA = $('#dataForm').valid();
		var isValidB = checkNumeirc();	
		var lastYear = $("#ad_issu_year").val();
		if(!isValidA|!isValidB){
			// 필수 입력사항 항목별 메세지
			if(!isValidA){
				if ($("#ad_rprsntv_nm_ho").val() == "") {
					jsMsgBox(null,'info',Message.template.required("대표자명"));
					return;
				} else if ($("#ad_hedofc_adres_01_ho").val() == "") {
					jsMsgBox(null,'info',Message.template.required("본사주소"));
					return;
				} else if ($("#largeGroup").val() == "noSelect") {
					jsMsgBox(null,'info',Message.template.required("주업종"));
					return;
				} else if ($("#ad_reprsnt_tlphon_middle_ho").val() == "" || $("#ad_reprsnt_tlphon_last_ho").val() == "") {
					jsMsgBox(null,'info',Message.template.required("전화번호"));
					return;
				} /* else if ($("#ad_hedofc_adres_01_ho").val() == "") { // 결산월은 셀렉트박스 선택되어 있음
					jsMsgBox(null,'info',Message.template.required("결산월"));
					return;
				} */ else if ($("#ad_fond_de_ho").val() == "") {
					jsMsgBox(null,'info',Message.template.required("설립년월"));
					return;
				} else if ($("input[name=reqst_se_search]:checked").length == 0) {
					jsMsgBox(null,'info',Message.template.required("용도"));
					return;
				} else if ($("#ad_shrholdr_nm1_ho").val() == "") {
					jsMsgBox(null,'info',Message.template.required("주주명"));
					return;
				} else if ($("#ad_qota_rt1_ho").val() == "") {
					jsMsgBox(null,'info',Message.template.required("지분율"));
					return;
				} else if ($("#ad_selng_am_ho_"+lastYear).val() == "") {
					jsMsgBox(null,'info',Message.template.required("매출액"));
					return;
				} else if ($("#ad_assets_totamt_ho_"+lastYear).val() == "") {
					jsMsgBox(null,'info',Message.template.required("자산총액"));
					return;
				}
			}
			jsMsgBox(null,'info',Message.msg.checkEssVal);
			return;
		}else{
			jsMsgBox(null
				,'confirm'				
				,Message.msg.confirmApply
				,function(){
					$("#load_msg").text(Message.msg.loadingApply);
					$("#ad_reqst_se_search").val(getCheckboxValues('reqst_se_search'));
					
					$("#df_method_nm").val("processSaveRequest");
					$("#ad_reqst_se").val("AK1");					
					
					var rcpyIdArr = new Array();
					$("input[name='addRcpyId']").each(function(){
						var addRcpyId = Number($(this).val());
						rcpyIdArr.push(addRcpyId);
					});
					
					// 폼 데이터
			    	$("#dataForm").ajaxSubmit({
			            url      : "PGIC0022.do",
			            data     : { ad_rcpy_id: rcpyIdArr.toString() },
			            dataType : "json",            
			            async    : false,
			            contentType: "multipart/form-data",
			            beforeSubmit : function(){
			            },            
			            success  : function(response) {
			            	try {			            		
			            		
			            		if(response.result){
			            			// 20171212 추가
			            			<c:choose>
										<c:when test="${param.ad_admin_new_at eq 'Y'}">
											jsMsgBox($(this),'info',Message.msg.successSave,function(){
												jsMoveMenu('28','113','PGIM0010');
											});
										</c:when>				
										<c:otherwise>
			            					var rceptNo = response.rceptNo;
				            				$("#ad_comp_rcept_no").val(rceptNo);
			            					
			            					$("#df_method_nm").val("index");
			            					$("#dataForm").attr("action","PGIC0024.do");			            			
			            					$("#dataForm").submit();
			            				</c:otherwise>
			            			</c:choose>
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
	
	// 자가진단
	$("#btn_save_self").click(function(){
		setParameter();	
		chkCprRegistSe();
		changeStatusOpen();
		validateSelngAmRelate();
		var isValidA = $('#dataForm').valid();
		var isValidB = checkNumeirc();
		var lastYear = $("#ad_issu_year").val();
		if(!isValidA|!isValidB){
			// 필수 입력사항 항목별 메세지
			if(!isValidA){
				if ($("#ad_rprsntv_nm_ho").val() == "") {
					jsMsgBox(null,'info',Message.template.required("대표자명"));
					return;
				} else if ($("#ad_hedofc_adres_01_ho").val() == "") {
					jsMsgBox(null,'info',Message.template.required("본사주소"));
					return;
				} else if ($("#largeGroup").val() == "noSelect") {
					jsMsgBox(null,'info',Message.template.required("주업종"));
					return;
				} else if ($("#ad_reprsnt_tlphon_middle_ho").val() == "" || $("#ad_reprsnt_tlphon_last_ho").val() == "") {
					jsMsgBox(null,'info',Message.template.required("전화번호"));
					return;
				} /* else if ($("#ad_hedofc_adres_01_ho").val() == "") { // 결산월은 셀렉트박스 선택되어 있음
					jsMsgBox(null,'info',Message.template.required("결산월"));
					return;
				} */ else if ($("#ad_fond_de_ho").val() == "") {
					jsMsgBox(null,'info',Message.template.required("설립년월"));
					return;
				} else if ($("input[name=reqst_se_search]:checked").length == 0) {
					jsMsgBox(null,'info',Message.template.required("용도"));
					return;
				} else if ($("#ad_shrholdr_nm1_ho").val() == "") {
					jsMsgBox(null,'info',Message.template.required("주주명"));
					return;
				} else if ($("#ad_qota_rt1_ho").val() == "") {
					jsMsgBox(null,'info',Message.template.required("지분율"));
					return;
				} else if ($("#ad_selng_am_ho_"+lastYear).val() == "") {
					jsMsgBox(null,'info',Message.template.required("매출액"));
					return;
				} else if ($("#ad_assets_totamt_ho_"+lastYear).val() == "") {
					jsMsgBox(null,'info',Message.template.required("자산총액"));
					return;
				}
			}
			jsMsgBox(null,'info',Message.msg.checkEssVal);
			return;
		}else{
			jsMsgBox(null
					,'confirm'
					,Message.msg.confirmSelfSave
					,function(){
						$("#load_msg").text(Message.msg.loadingApply);
						$("#ad_reqst_se_search").val(getCheckboxValues('reqst_se_search'));
						
						$("#df_method_nm").val("processSaveRequest");
						$("#ad_reqst_se").val("AK0");					
						
						var rcpyIdArr = new Array();
						$("input[name='addRcpyId']").each(function(){
							var addRcpyId = Number($(this).val());
							rcpyIdArr.push(addRcpyId);
						});
						
						// 폼 데이터
				    	$("#dataForm").ajaxSubmit({
				            url      : "PGIC0022.do",
				            data     : { ad_rcpy_id: rcpyIdArr.toString() },
				            dataType : "json",            
				            async    : false,
				            contentType: "multipart/form-data",
				            beforeSubmit : function(){
				            },            
				            success  : function(response) {
				            	try {			            		
				            		
				            		if(response.result){
				            			// 레이어 팝업
				            			/* $.colorbox({
				            		        title : "기업 자가진단",
				            		        href  : "PGIC0022.do",
				            		        data  : {ad_load_rcept_no : response.rceptNo
				            		        		, df_method_nm : "processSelfDiagnosis"
				            		        		, ad_entrprs_nm_ho : $("#ad_entrprs_nm_ho").val()
				            		        		, ad_confm_target_yy : $("#ad_confm_target_yy").val()},
				            		        width : "70%",
				            		        height: "60%",            
				            		        overlayClose : false,
				            		        escKey : false,            
				            		    }); */
				            		   	
				            		    var rceptNo = response.rceptNo;
					            		$("#ad_load_rcept_no").val(rceptNo);
					            		
					            		// window 팝업
				            			$("#df_method_nm").val("processSelfDiagnosis");
				            					
				            			var newWindow = window.open('', 'selfDiagInfo', 'width=900, height=680, top=100, left=100, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbars=yes, fullscreen=no, resizable=yes');	
				            			document.dataForm.action = "/PGIC0022.do";
				            			document.dataForm.target = "selfDiagInfo";
				            			document.dataForm.submit();
				            			document.dataForm.target = "";
				            			if(newWindow){
				            				newWindow.focus();
				            			}
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
	
	/* 
 	// mutifile-upload
    $('input:file').MultiFile({
		accept: 'hwp|doc|docx|pdf|jpg|jpge|zip',
		max: '1',		
		STRING: {			
			remove: '<img src="<c:url value="/images/ucm/icon_del.png" />" alt="x" />',
			denied: Message.msg.fildUploadDenied,  		//확장자 제한 문구
			duplicate: Message.msg.fildUploadDuplicate	//중복 파일 문구
		},
	});
 	 */
 	// DOM 변경 후 세팅 적용
    afterChangeDOM(); 
 	
 	// 2015-03-30 결산월 변경 가능하도록 수정됨.
 	$("#ad_stacnt_mt_ho_disp").change(function(){
 		$("#ad_stacnt_mt_ho").val($(this).val());
 	});
 	 
 	count_check('reqst_se_search');
});

// 사업자번호 입력창 삭제
function bizNumRemove(remove) {
	// 항목 삭제
	remove.parent().remove();
	
	var index = $("input[id^='tx_bizrno_compno_first_']").length;

	// 사업자등록번호 개수 세팅
	$("#ad_bizrno_cnt").val(index);
	
	// 사업자번호 삭제 시 파일 필수x
	if(index == 0){
		$("#file_ho_rf4").attr("required",false);
	}
}

//파라미터 세팅
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
	
	var ad_bizrno_compno_list = ""
	$(".tx_bizrno_compno").each(function(idx){
		//var index = idx + 1;
		var index = $("input[id^='tx_bizrno_compno_first_']")[idx].name;
		var bizrnoFirst = $("#tx_bizrno_compno_first_" + index).val();
		var bizrnoMiddle = $("#tx_bizrno_compno_middle_" + index).val();
		var bizrnoLast = $("#tx_bizrno_compno_last_" + index).val();
		
		$("#ad_bizrno_compno_" + index).val("" + bizrnoFirst + bizrnoMiddle + bizrnoLast);
		var bizNo = "" + bizrnoFirst + bizrnoMiddle + bizrnoLast;
		ad_bizrno_compno_list += "<input type='hidden' id='ad_bizrno_compno_list_"+ (idx+1) +"' name='ad_bizrno_compno_list_"+ (idx+1) +"' value='"+bizNo+"' class='text' />"
	});
	$("input[name^=ad_bizrno_compno_list]").remove();
	$("#dataForm").append(ad_bizrno_compno_list);
}

function check_all(name) {
	var a = "."+name;
	if(document.getElementsByName(name)[0].checked){
		$(a).prop("checked",true);
	}
	else{
		$(a).prop("checked",false);
	}
}

function count_check(name) {
	var cnt = 0;
	for(i=1; i < document.getElementsByName(name).length; i++) {
		if(document.getElementsByName(name)[i].checked) cnt++;
	}
	if(document.getElementsByName(name).length -1 != cnt)
		document.getElementsByName(name)[0].checked = false;
	else
		document.getElementsByName(name)[0].checked = true;
}

// 시스템판정 불러오기
function fn_admin_sys() {
	// window 팝업
	$("#df_method_nm").val("processSelfDiagnosis");
			
	var newWindow = window.open('', 'selfDiagInfo', 'width=900, height=680, top=100, left=100, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbars=yes, fullscreen=no, resizable=yes');	
	document.dataForm.action = "/PGIC0022.do";
	document.dataForm.target = "selfDiagInfo";
	document.dataForm.submit();
	if(newWindow){
		newWindow.focus();
	}
}

// 주주명부, 재무정보, 상시근로자수 열림 상태로 변경
function changeStatusOpen(){
	// 주주명부 열기
	$("#div_skrt_con").show();		
	$("#btn_skrt_close").show();
	$("#btn_skrt_open").hide();

	// 재무정보 열기
	$("#div_fnnrinfo_con").show();		
	$("#btn_fnnrinfo_close").show();
	$("#btn_fnnrinfo_open").hide();	

	// 상시근로자수 열기
	$("#div_rabrr_con").show();		
	$("#btn_rabrr_close").show();
	$("#btn_rabrr_open").hide();
}

//DOM 변경 후 세팅 적용
function afterChangeDOM(){
	// 유효성, 마스킹
    setValidation();
 	// 상시근로자수 합계,연평균
 	setLabbrSumAvg();
 	// 관계기업 매출액 합계, 3년평균
 	setSelingAmRelateSumAvg();
 	// 신청기업 매출액 합계, 평균(입력기준)
 	setSelingAmApplySumAvg();
 	// [?]표시 용어설명 
 	setDescWord(); 	
 	// 분류코드 조회
 	searchCode();
}

// 분류코드 조회
function searchCode(){
	$(".btn_search_code").on("click",function(){
 		var pop = window.open("<c:url value='${KSSC_KOSTAT_URL}' />","kostatPop","width=1200,height=500, scrollbars=yes, resizable=yes");
 	});
}

// [?]표시 용어설명 
function setDescWord(){
	// 확인신청 대상년도
	$(".request_year_dec").jBox('Tooltip', {
		content: '유효기간에 해당하는 연도입니다.<br /> 예) 유효기간 2016.4.1.- 2017.3.31.해당하는 확인서의 경우 2016년이 해당연도입니다.'
	});
	// 직전사업년도
	$(".before_year_dec").jBox('Tooltip', {
		content: '기업판단은 직전사업년도의 자료(재무, 업종)를 기초로 판정'
	});
	// 기업명
	$(".request_entrprs_nm").jBox('Tooltip', {
		content: '사업자등록증상 기업명을 동일하게 입력하시기 바랍니다.'
	});
	// 대표자명
	$(".request_rprsntv_nm").jBox('Tooltip', {
		content: '사업자등록증상 대표자명을 동일하게 입력하시기 바랍니다.<br />(2인일경우 모두 입력)'
	});
	// 본사주소
	$(".request_hedofc_adres").jBox('Tooltip', {
		content: '사업자등록증상 주소와 동일하게 입력하시기 바랍니다.'
	});
	// 표준산업분류코드
	$(".induty_cod_dec").jBox('Tooltip', {
		content: '여러 업종을 영위할 경우 3년 매출을 합하여<br /> 매출액이 가장 큰 업종을 주업종으로 함.'
	});
	// 설립년월
	$(".request_fond_de_ho").jBox('Tooltip', {
		content: '당해 사업년도에 설립 또는 합병, 분할한 법인은 반드시 입력하시기 바랍니다.'
	});
	// 용도(사업명)
	$(".request_prpos_ho").jBox('Tooltip', {
		content: '확인서 발급 목적을 기입하시기 바랍니다. <br />(정책금융신청, 연구소설립, 병역특례지원 등)'
	});
	// 특이사항
	$(".request_partclr_matter_ho").jBox('Tooltip', {
		content: '당해 사업년도 설립, 합병, 분할 등 특이사항 및 결산일 변경, 개인법인 등 <br />참고사항 입력'
	});
	// 주주명부
	$(".request_shrholdr").jBox('Tooltip', {
		content: '주주명(법인일 경우 법인번호포함), 특수관계여부(임원, 친인척 등), 지분율 등 포함하여 <br /> (사용인감)원본대조필 후 제출 PDF(개인주주의 주민번호, 주소 등 개인정보는 삭제)'
	});
	// 관계기업구분
	$(".rcpy_div_dec").jBox('Tooltip', {
		content:'<strong>- 지배기업직접</strong>: 신청기업의 지분을 관계기업이 직접 소유<br />\
				<strong>- 지배기업간접</strong>: 신청기업의 지분을 자회사 등을 통해 소유<br />\
				<strong>- 종속기업직접</strong>: 신청기업이 관계기업의 지분을 직접 소유<br />\
				<strong>- 종속기업간접</strong>: 신청기업이 관계기업의 지분을 자회사 등을 통해 소유<br />\
				 &nbsp;&nbsp;&nbsp; 예) A → B → C(신청기업) B = 지배 직접, A = 지배 간접'
				
	});
	// 법인등록구분
	$(".reqstRcpy_jurir_divide").jBox('Tooltip', {
		content: '관계기업이 해외법인일 경우 <br />지분소유비율(주주명부)와 자산총액(재무재표)만 입력(제출)하면 됩니다.'
	});
	// 관계기업 매출액
	$(".reqstRcpy_amount_unit").jBox('Tooltip', {
		content: "업종의 특성에 따라 '영업수익'도 가능"
	});
	// 통화 
	$(".crncy_cod_dec").jBox('Tooltip', {
		content: '자산총액 확인을 위한 증빙서류에서<br /> 사용된 통화를 선택하세요.'
	});
	// 기타서류 
	$(".ad_etc").jBox('Tooltip', {
		content: '기타 증빙 또는 담당자 요청에 의해 추가로 첨부해야하는 서류가 있는 경우 첨부해주십시오.'
	});
	// 기타서류 
	$(".ad_bizrno_tip").jBox('Tooltip', {
		content: '사업장 본점 외 지점의 사업자등록번호를 추가할 수 있습니다.'
	});
	
	
	
	
}

// 관계기업 매출액 유효성검사
function validateSelngAmRelate(){
	var isValid = true;
	$(".tbl_add").each(function(i){
		var fondDe = $(this).find("input[name*='ad_fond_de']").val();
		var fYear = Util.str.left(fondDe,4); 
		var $sel = $(this).find("input[name*='ad_selng_am']");
		$sel.each(function(){
			var id = $(this).attr("id");
			var sYear = Util.str.right(id,4);
			
			var idx = id.replace("ad_selng_am_", "").split("_");
			var cprSeVal = $("#ad_cpr_regist_se_"+(idx[0])+" option:selected").val();
			
			if(sYear>=fYear){
				var val = $(this).val();
				if(Util.isEmpty(val)){
					if(cprSeVal == "L"){
						$(this).attr("required", true);
						isValid = false;
					}else{
						$(this).attr("required", false);
						isValid = true;
					}
				}
			}
		});
	});
	
	if(!isValid){
		$("#dataForm").validate();
		$("#dataForm").valid();
	}
		
	return isValid;
}

//상시근로자수 합계,연평균
function setLabbrSumAvg(){
<c:if test="${(!empty applyEntInfo['resnManageS'] && applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS3 || applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS4 || applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS5) || !empty applyEntInfo['reqstOrdtmLabrr']}">	
	$(".labbr").on("change",function(){
 		var id = $(this).attr("id");
 		var idx = id.indexOf("ho");

 		// 신청기업
 		var sId;
 		var rtn;
 		if(idx!=-1){
 			sId = "ho_"
 			sId += Util.str.right(id,4);
 			rtn = getSum(sId);
 		// 관계기업
 		}else{
 			var fistIdx = id.lastIndexOf("_"); 			
 			var secondIdx = id.lastIndexOf("_",fistIdx-1);
 			var sn = id.substring(fistIdx, secondIdx+1);
 			
 			sId = sn+"_";
 			sId += Util.str.right(id,4);
 			rtn = getSum(sId);
 		}
 		
 		$("#ordtm_labrr_sum_"+sId).text(rtn.sum);
		$("#ad_ordtm_labrr_sum_"+sId).val(rtn.sum); 			
		$("#ordtm_labrr_avg_"+sId).text(rtn.avg);
		$("#ad_ordtm_labrr_avg_"+sId).val(rtn.avg);
 		
 		function getSum(sId){ 			
 			var rtnSum=0;
 			var rtnMonth;
 			var rtnAvg=0;
 			for(var i=1;i<=12;i++){
 				var fullId = "ad_ordtm_labrr_co"+i+"_"+sId;
 				var val = $("#"+fullId).val();
 				if(!Util.isEmpty(val)){
 					rtnSum += Number(val);
 					if(Util.isEmpty(rtnMonth)){
 						rtnMonth = i;
 					}
 				}
 			}
 			if(rtnSum>0){
 				rtnAvg = Math.floor(rtnSum/(13-rtnMonth));	
 			} 			 			
 			var rtn = {sum:rtnSum, avg:rtnAvg}
 			return rtn;
 		}
 	});
</c:if>		
}

// 관계기업 매출액 합계, 3년평균
function setSelingAmRelateSumAvg(){
	$(".selAmR").on("change",function(){
		var id = $(this).attr("id");	
		evalSelingAmRelateSumAvg(id);
 	});
}

// 신청기업 매출액 합계, 평균(입력기준)
function setSelingAmApplySumAvg(){
	$(".selAmO").on("change",function(){		
		evalSelingAmApplySumAvg();
 	});
}

// 천단위 ( , ) 콤마
function comma(str) {
    str = String(str);
    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}

function evalSelingAmRelateSumAvg(id){
	//var lastYear = Number($("#ad_issu_year option:selected").val());
	var lastYear = $("#ad_issu_year").val();
	 		
	var fistIdx = id.lastIndexOf("_"); 			
	var secondIdx = id.lastIndexOf("_",fistIdx-1);
	var sn = id.substring(fistIdx, secondIdx+1);
	
	var rtn = getSum(sn);		
			
	$("#ad_y3sum_selng_am_"+sn).val(rtn.sum);
	$("#y3sum_selng_am_"+sn).text(comma(rtn.sum));
	$("#ad_y3avg_selng_am_"+sn).val(rtn.avg);
	$("#y3avg_selng_am_"+sn).text(comma(rtn.avg));
	
		function getSum(sId){ 			
			var rtnSum=0; 			
			var rtnAvg=0;
			for(var i=0;i<3;i++){
				var year = lastYear-i; 
				var fullId = "ad_selng_am_"+sn+"_"+year;
				var val = $("#"+fullId).val();
				if(!Util.isEmpty(val)){
					rtnSum += Number(val);
				}
			}
			 
			if(rtnSum>0){
				rtnAvg = Math.floor(rtnSum/3);	
			} 			 			
			var rtn = {sum:rtnSum, avg:rtnAvg}
			return rtn; 			 
		}
}

function evalSelingAmApplySumAvg(){
	var lastYear = $("#ad_issu_year").val();
	var cnt = 0;
	var sum = 0;
	var avg = 0;	
	
	for(var i=0;i<4;i++){
		var year = lastYear-i;
		var fullId = "ad_selng_am_ho_" + year;
		var val = $("#"+fullId).val();
		
		if(!Util.isEmpty(val)){
			cnt++;
			sum += Number(val);
		}
	}
	
	if(cnt > 0) {
		avg = Math.floor(sum/cnt);
	}
	
	$("#ad_y3sum_selng_am_ho").val(sum);
	$("#ad_y3avg_selng_am_ho").val(avg);
}

//checkbox 값 추출
function getCheckboxValues(name){
	var chk = document.getElementsByName(name); // 체크박스객체를 담는다
	var len = chk.length;    //체크박스의 전체 개수
	var checkRow = '';      //체크된 체크박스의 value를 담기위한 변수
	var checkCnt = 0;        //체크된 체크박스의 개수
	var checkLast = '';      //체크된 체크박스 중 마지막 체크박스의 인덱스를 담기위한 변수
	var rowid = '';             //체크된 체크박스의 모든 value 값을 담는다
	var cnt = 0;                 

	for(var i=1; i<len; i++){
		if(chk[i].checked == true){
			checkCnt++;        //체크된 체크박스의 개수
			checkLast = i;     //체크된 체크박스의 인덱스
		}
	} 

	for(var i=1; i<len; i++){
		if(chk[i].checked == true){  //체크가 되어있는 값 구분
			checkRow = chk[i].value;
			if(checkCnt == 1){                            //체크된 체크박스의 개수가 한 개 일때,
				rowid += ""+checkRow+"";        //'value'의 형태 (뒤에 ,(콤마)가 붙지않게)
			}else{                                            //체크된 체크박스의 개수가 여러 개 일때,
				if(i == checkLast){                     //체크된 체크박스 중 마지막 체크박스일 때,
					rowid += ""+checkRow+"";  //'value'의 형태 (뒤에 ,(콤마)가 붙지않게)
				}else{
					rowid += ""+checkRow+",";	 //'value',의 형태 (뒤에 ,(콤마)가 붙게)         			
				}
			}
		}
		cnt++;
		checkRow = '';    //checkRow초기화.
	}
	return rowid;    //'value1', 'value2', 'value3' 의 형태로 출력된다.
}

// 유효성, 마스킹
function setValidation(){
	$("#dataForm").validate();
	
	$(".max100").each(function(){
		$(this).rules("add", {max:100});
	});
	
    $(':file').each(function(){
    	$(this).rules('add', {
    		extension: "hwp,doc,docx,pdf,jpg,png,jpge,zip"
        });
    });
    
	$('.yyyy-MM-dd').mask('0000-00-00');
	$(".qota_rt").mask('999.99');
	/* $(".-numeric18").mask('-9999999999999999.99', {
		translation: {
			'-': {pattern: /-/, optional: true}
		}
	}); */
	$(".-numeric18").mask('S9999999999999999.99', {
		translation: {
			'S': {pattern: /-/, optional: true}
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

//설립년월일(달력) 초기화
//법인등록구분 나라표시 초기화
function initFondDe(id){
	// #ad_fond_de_
	$('.yyyy-MM-dd').datepicker({
        showOn : 'button',
        defaultDate : null,
        buttonImage : '<c:url value="/images/ucm/icon_cal.png" />',
        buttonImageOnly : true,
        changeYear: true,
        changeMonth: true,
        yearRange: "1920:+0"
    });
	$('.yyyy-MM-dd').mask('0000-00-00');
	
	// Dart데이터 불러오기 버튼
	$("#btn_load_dart_ent_"+id).css("display","none");
	// 나라 선택
	$("#ad_crncy_code_"+id).css("display","none");
}

// 대분류 업종명에 따른 중분류 업종명 옵션 삽입
function changelargeGroupSelect(lclasCd) {
	var i;
	
	var beforeSelectSize = $("#smallGroup option").size();
	for(i=0; i<beforeSelectSize; i++) {
		$("#smallGroup option:first").remove();
	}
	$.ajax({
		url 	: 	"PGIC0022.do",
		type	: 	"POST",
		dataType	: "json",
		data	: {
			df_method_nm : "changeSmallGroup"
			, lclasCd : lclasCd
		},
		async : false,
		success : function(response) {
			try {
				if(response.result) {
					var valueObj = response.value

					for(i=0; i<valueObj.list.length; i++) {
						$("#smallGroup").append("<option value='"+valueObj.list[i].indutyCode+":"+valueObj.list[i].koreanNm+"'>"+valueObj.list[i].indutyCode+" "+valueObj.list[i].koreanNm+" </option>");
					}
				} else {
					
				}
			} catch (e) {
				if(response != null) {
					jsSysErrorBox(response.err_code+": "+response.err_msg);
				} else {
                    jsSysErrorBox(e);
				}
				return;
			}
		}
	});
}

//대분류 업종명에 따른 중분류 업종명 옵션 삽입(관계기업)
function changelargeGroupSelectId(lclasCd, id) {
	var i;
	
	var beforeSelectSize = $("#smallGroup_"+id+" option").size();
	for(i=0; i<beforeSelectSize; i++) {
		$("#smallGroup_"+id+" option:first").remove();
	}
	
	$.ajax({
		url 	: 	"PGIC0022.do",
		type	: 	"POST",
		dataType	: "json",
		data	: {
			df_method_nm : "changeSmallGroup"
			, lclasCd : lclasCd
		},
		async : false,
		success : function(response) {
			try {
				if(response.result) {
					var valueObj = response.value

					for(i=0; i<valueObj.list.length; i++) {
						$("#smallGroup_"+id).append("<option value='"+valueObj.list[i].indutyCode+":"+valueObj.list[i].koreanNm+"'>"+valueObj.list[i].indutyCode+" "+valueObj.list[i].koreanNm+" </option>");
					}
				} else {
					
				}
			} catch (e) {
				if(response != null) {
					jsSysErrorBox(response.err_code+": "+response.err_msg);
				} else {
                    jsSysErrorBox(e);
				}
				return;
			}
		}
	});
}

//관계기업삭제
function delRcpy(obj){
	$(obj).parent().parent(".tbl_add").remove();
}

// 관계기업추가
function addRcpy(){
	//var year = $("#ad_issu_year option:selected").val();
	var year = $("#ad_issu_year").val();
	
	var gDfAddRcpyId = 0;
	$("input[name='addRcpyId']").each(function(){
		var addRcpyId = Number($(this).val());
		if(gDfAddRcpyId<addRcpyId){
			gDfAddRcpyId = addRcpyId;
		}
	});
	
	var addRcpyId = gDfAddRcpyId+1;
	
	$.ajax({
        url      : "PGIC0022.do",
        type     : "POST",
        dataType : "html",
        data     : { df_method_nm : "getRcpyConTmp", year:year, addRcpyId:addRcpyId },                
        async    : false,                
        success  : function(response) {
        	try {
        		var html = $.parseHTML(response);            		     		
        		$.each(html, function(i, el) {            		
           			if(el.nodeType==1){
           		  		var clazz = el.getAttribute('class');
           		  		if(clazz == "tbl_add"){
           		  			$("#div_add_rcpy").after(el);
           		  			return;
           		  		}
           		  	}
        		});
        		// 결산월 초기화
        		//initStacntMt(addRcpyId);
        		// 설립년월일 초기화
        		initFondDe(addRcpyId);
        		
        		<c:if test="${(!empty applyEntInfo['resnManageS'] && applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS3 || applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS4 || applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS5)}">
        		$("#labrr_table_"+addRcpyId).show();
        		</c:if>
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

// 결산월 초기화
function initStacntMt(id){
	$("#ad_stacnt_mt_"+id).numericOptions({from:1,to:12,namePadding:2,valuePadding:2});
}

//확인신청대상년도 세팅
function initIssuYear(){
	var localYear = Util.date.getLocalYear();
	<c:choose>
	<c:when test="${loadDataYn eq 'Y'}">
		//$('#ad_issu_year').numericOptions({from:2011,to:${applyEntInfo["issuBsisInfo"]["LAST_ISSU_YEAR"]}});
		$('#ad_issu_year').numericOptions({from:2011,to:localYear});
		$('#ad_issu_year').val(${applyEntInfo["applyMaster"]["JDGMNT_REQST_YEAR"]});
   	</c:when>       
   	<c:otherwise>
	   	$('#ad_issu_year').numericOptions({from:2011,to:localYear});
		$('#ad_issu_year').val(localYear-1);	
		$("#ad_issu_year").trigger("change");
   	</c:otherwise>
	</c:choose>
}

//확인신청대상년도 세팅(불러오기)
function initIssuYearL(){	
	var localYear = Util.date.getLocalYear();
	
}

// 관계기업 템플릿
function getRcpyConTmp(){
	$(".tbl_add").remove();
	addRcpy();	
}

// 재무정보 템플릿
function getFnnrConTmp(year){
	$("#div_fnnrinfo_con").remove();
	$.ajax({
        url      : "PGIC0022.do",
        type     : "POST",
        dataType : "html",
        data     : { df_method_nm : "getFnnrConTmp" , year:year},                
        async    : false,                
        success  : function(response) {
        	try {
        		var html = $.parseHTML(response);            		     		
        		$.each(html, function(i, el) {            		
           			if(el.nodeType==1){
           		  		var id = el.getAttribute('id');
           		  		if(id == "div_fnnrinfo_con"){
           		  			$("#div_fnnrinfo_btn").after(el);
           		  			return;
           		  		}
           		  	}
        		});        		
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

//상시근로자수 템플릿
function getRabrrConTmp(year){
<c:if test="${(!empty applyEntInfo['resnManageS'] && applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS3 || applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS4 || applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS5)|| !empty applyEntInfo['reqstOrdtmLabrr']}">
	$("#div_rabrr_con").remove();
	$.ajax({
        url      : "PGIC0022.do",
        type     : "POST",
        dataType : "html",
        data     : { df_method_nm : "getRabrrConTmp", year:year},                
        async    : false,                
        success  : function(response) {
        	try {
        		var html = $.parseHTML(response);            		     		
        		$.each(html, function(i, el) {            		
           			if(el.nodeType==1){
           		  		var id = el.getAttribute('id');
           		  		if(id == "div_rabrr_con"){
           		  			$("#div_rabrr_btn").after(el);
           		  			return;
           		  		}
           		  	}
        		});        		
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
</c:if>	
}


//공시기업목록 조회 팝업(Dart데이터 불러오기 버튼)
function loadDartEntList(id){
	var $crpEl = $("#ad_entrprs_nm_"+id);
	var crpNm = $crpEl.val();
	crpNm = Util.str.trim(crpNm);
	if(Util.isEmpty(crpNm)){
		jsMsgBox($crpEl,'info',"기업명을 입력하십시오.");
		return;
	}
	
	$("#load_msg").text(Message.msg.loadingDartData);
	crpNm = crpNm.replace(/\(주\)/, "");
	$.colorbox({
        title : "공시시스템코드 조회",
        href  : "PGCM0002.do",
        data  : {crp_nm:crpNm, id:id},
        width : "50%",
        height: "50%",            
        overlayClose : false,
        escKey : false,            
    });
}

// 기업개황(Datr 데이터) 불러오기
function getEntInfo(crpCd,id){	
	$("#load_msg").text(Message.msg.loadingDartData);
	$.ajax({        
        url      : "PGCM0002.do",
        type     : "POST",
        dataType : "json",
        data     : {df_method_nm:"getEntInfo", crp_cd:crpCd},                
        async    : false,                
        success  : function(response) {        	
        	try {
        		if(response.result) {
        			var rspValue = response.value;
        			var errCode = rspValue.status;
            		var errMsg = rspValue.message;
            		
            		console.log("@@@getEntInfo start@@@");
            		console.log("rspValue::" + rspValue);
            		console.log("errCode:: " + errCode);
            		console.log("errMsg:: " + errMsg);
            		console.log("crpCd:: " + crpCd);
            		console.log("id:: " + id);
            		
            		if(errCode=="000"){
            			// 전역변수에 기업 정보 저장
            			gDartdata[id] = {};        	
            			gDartdata[id].crpCd = crpCd;
            			gDartdata[id].entInfo = rspValue;
            			// 화면에 기업 정보 세팅
            			setEntInfo(id);
            			// DOM 변경 후 세팅 적용
            			afterChangeDOM();
            			
            			console.log("@@@getEntInfo u@@");
            		}else{
            			gDartdata[id] = null;            			
            			jsMsgBox($("#btn_load_dart_"+id), "info", errMsg);            			
            		}						
				} else {
					jsMsgBox($("#btn_load_dart_"+id), "info", response.message);
				}        		
            } catch (e) {
            	gDartdata[id] = null;
            	
                if(response != null) {
                	jsSysErrorBox(response.err_code+": "+response.err_msg);
                } else {
                    jsSysErrorBox(e);
                }
                return;
            }
        }
    });	 
}

// 기업개황 세팅
function setEntInfo(id){
	<%-- 
	err_code: 에러코드(오류 메시지 참조)
	err_msg	: 에러메시지(오류 메시지 참조)
	crp_nm	: 정식명칭
	crp_nm_e: 영문명칭
	crp_nm_i: 종목명(상장사) 또는 약식명칭(기타법인)
	stock_cd: 상장회사인 경우 주식의 종목코드
	ceo_nm	: 대표자명
	crp_cls	: 법인구분 : Y(유가), K(코스닥), N(코넥스), E(기타)
	crp_no	: 법인등록번호
	bsn_no	: 사업자등록번호
	adr		: 주소	
	hm_url	: 홈페이지
	ir_url	: IR홈페이지
	phn_no	: 전화번호
	fax_no	: 팩스번호
	ind_cd	: 업종코드
	est_dt	: 설립일(YYYYMMDD)
	acc_mt	: 결산월(MM)
	--%>
	
	var entInfo = gDartdata[id].entInfo; 
	 
	/* var entrprs_nm 		= entInfo.crp_nm; 		// 정식명칭 */
	/* var entrprs_nm_e	= entInfo.crp_nm_e; 		// 영문명칭 */
	/* var crp_cls 		= entInfo.crp_cls; 			// 법인구분 : Y(유가), K(코스닥), N(코넥스), E(기타) */
	/* var jurirno 		= entInfo.crp_no; 			// 법인등록번호 */
	/* var bizrno 			= entInfo.bsn_no; 		// 사업자등록번호 */
	/* var hedofc_adres 	= entInfo.adr; 			// 주소 */
	/* var mn_induty_code 	= entInfo.ind_cd; 		// 업종코드 */
	
	var entrprs_nm 		= entInfo.corp_name; 		// 정식명칭
	var entrprs_nm_e	= entInfo.corp_name_eng; 	// 영문명칭
	var rprsntv_nm 		= entInfo.ceo_nm; 			// 대표자명
	var crp_cls 		= entInfo.corp_cls; 		// 법인구분 : Y(유가), K(코스닥), N(코넥스), E(기타)
	var jurirno 		= entInfo.jurir_no; 		// 법인등록번호
	jurirno = jurirno.replace(/-/gi, "");
	var bizrno 			= entInfo.bizr_no; 			// 사업자등록번호
	bizrno = bizrno.replace(/-/gi, "");
	var hedofc_adres 	= entInfo.adres; 			// 주소
	var hmpg 			= entInfo.hm_url; 			// 홈페이지
	var reprsnt_tlphon 	= entInfo.phn_no; 			// 전화번호
	var fxnum 			= entInfo.fax_no; 			// 팩스번호
	var mn_induty_code 	= entInfo.induty_code; 		// 업종코드
	var fond_de 		= entInfo.est_dt; 			// 설립일(YYYYMMDD)
	var stacnt_mt 		= entInfo.acc_mt; 			// 결산월(MM)
	var last_issu_year	= entInfo.last_issu_year; 	// 확인서발행가능 최종년도

	/* var id = "ho"; */
	
	/* if(id=="ho"){
		var org_jurirno = $("#ad_jurirno_ho").val(); */
		//alert(org_jurirno+":"+jurirno);
		
		/* if(org_jurirno!=jurirno){
			jsMsgBox($("#btn_load_dart_"+id),'info',Message.msg.mismatch);
			return;
		} */
		
		// 결산월 입력 체크
		/* if($("#ad_stacnt_mt_ho").val() != stacnt_mt) {
			jsMsgBox(null, 'warn', Message.msg.mismatchStacnt, function(){
				$("#df_method_nm").val("");
				document.dataForm.action = "/PGIC0020.do";
				document.dataForm.submit();
			});
		} */
	/* } */
 
	// 대표자명
	/* $("#ad_rprsntv_nm_"+id).val(rprsntv_nm); */
	$("#ad_r_rprsntv_nm_ho_"+id).val(rprsntv_nm);
	
	// 법인구분
	$("#ad_crp_cls_"+id).val(crp_cls);
	
	// 주소
	$("#ad_hedofc_adres_01_"+id).val(hedofc_adres);
	
	// 전화번호		
	var telArr; 
	var telFirst;
	var telMiddle;
	var telLast;
	if(reprsnt_tlphon.indexOf(")")!=-1){
		telArr = Util.str.split(reprsnt_tlphon,")");
		telFirst = telArr[0];
		telArr = Util.str.split(telArr[1],"-");
		telMiddle = telArr[0];
		telLast = telArr[1];
	}else{
		telArr = Util.str.split(reprsnt_tlphon,"-");
		telFirst = telArr[0];		
		telMiddle = telArr[1];
		telLast = telArr[2];
	}		
	
	$("#ad_reprsnt_tlphon_first_"+id).val($.trim(telFirst));
	$("#ad_reprsnt_tlphon_middle_"+id).val($.trim(telMiddle));
	$("#ad_reprsnt_tlphon_last_"+id).val($.trim(telLast));		
	
	// 팩스번호
	var faxArr;
	var faxFirst;
	var faxMiddle;
	var faxLast;
	if(fxnum.indexOf(")")!=-1){
		faxArr = Util.str.split(fxnum,")");
		faxFirst = faxArr[0];
		faxArr = Util.str.split(faxArr[1],"-");
		faxMiddle = faxArr[0];
		faxLast = faxArr[1];
	}else{
		faxArr = Util.str.split(fxnum,"-");
		faxFirst = faxArr[0];		
		faxMiddle = faxArr[1];
		faxLast = faxArr[2];
	}	
	
	$("#ad_fxnum_first_"+id).val($.trim(faxFirst));
	$("#ad_fxnum_middle_"+id).val($.trim(faxMiddle));
	$("#ad_fxnum_last_"+id).val($.trim(faxLast));
	
	// 업종코드(표준산업분류코드)
	$("#ad_mn_induty_code_"+id).val(mn_induty_code);
	
	// 결산월세팅
	$("#ad_stacnt_mt_"+id).val(stacnt_mt);
	
	// 설립년월		
	$("#ad_fond_de_"+id).val(fond_de);
	
	/* if(id=="ho"){
		// 확인신청대상년도
		$('#ad_issu_year').numericOptions({from:2011,to:last_issu_year});
	} */
	// 법인등록번호	
	var jurirnoFirst = Util.str.subStr(jurirno,0,6);
	var jurirnoLast = Util.str.subStr(jurirno,6);
	
	$("#ad_jurirno_first_"+id).val(jurirnoFirst);
	$("#ad_jurirno_last_"+id).val(jurirnoLast);

	// 사업자등록번호
	var bizrnoFirst = Util.str.subStr(bizrno,0,3);
	var bizrnoMiddle = Util.str.subStr(bizrno,3,2);
	var bizrnoLast = Util.str.subStr(bizrno,5);
	
	$("#ad_bizrno_first_"+id).val(bizrnoFirst);
	$("#ad_bizrno_middle_"+id).val(bizrnoMiddle);
	$("#ad_bizrno_last_"+id).val(bizrnoLast);
	
	// 신청기업개황이 변경됐을 경우
	/* if(id=="ho"){
		var year = $("#ad_issu_year option:selected").val();
		
		// 재무정보 재생성
		getFnnrConTmp(year);
		// 상시근로자수 재생성
		getRabrrConTmp(year);
		// 추가관련기업 생성
		getRcpyConTmp();	
	} */

	
}


//기업재무(Datr 데이터) 불러오기
function getEntFnnr(id,yr){
	if(Util.isEmpty(gDartdata[id])){		
		jsMsgBox($("#btn_load_dart_"+id),'info',Message.msg.noSearchDataData);		
		return;
	}
	
	<%-- 
	err_code: 에러코드(오류 메시지 참조)
	err_msg	: 에러메시지(오류 메시지 참조)
	crp_nm	: 정식명칭
	crp_nm_e: 영문명칭
	crp_nm_i: 종목명(상장사) 또는 약식명칭(기타법인)
	stock_cd: 상장회사인 경우 주식의 종목코드
	ceo_nm	: 대표자명
	crp_cls	: 법인구분 : Y(유가), K(코스닥), N(코넥스), E(기타)
	crp_no	: 법인등록번호
	bsn_no	: 사업자등록번호
	adr		: 주소	
	hm_url	: 홈페이지
	ir_url	: IR홈페이지
	phn_no	: 전화번호
	fax_no	: 팩스번호
	ind_cd	: 업종코드
	est_dt	: 설립일(YYYYMMDD)
	acc_mt	: 결산월(MM)
	--%>
	/*	
	bsnTp: 보고서유형
	A001 : 사업보고서
	F001 : 감사보고서		
	*/
	var crpCd 	= gDartdata[id].crpCd;
	var entInfo	= gDartdata[id].entInfo;
	
	// 기업재무API 조회 시작, 종료일
	var yyyy = yr;
	//var MM 	= $("#ad_stacnt_mt_"+id+" option:selected").val();
	var MM = $("#ad_stacnt_mt_ho").val();
	
	var dd	= Util.date.getLocalDay();
	
	var yyyyMMdd = yyyy+MM+dd;
	var lastDay = Util.date.lastDateNum(yyyyMMdd);
	
	var lastDate = yyyy+MM+lastDay;
	var startDt	 = Util.date.addDate(lastDate,1);
	var endDt	= Util.date.addMonth(startDt,5);
	
	var crpCls	= entInfo.crp_cls; 	// 법인구분
	var bsnTp	= "";	
	if(crpCls=="Y"||crpCls=="K"){	// 유가, 코스닥
		bsnTp = "A001";	// 사업보고서
	}else{
		bsnTp = "F001"; // 감사보고서
	}
	
	$("#load_msg").text(Message.msg.loadingDartData);
	$.ajax({        
        url      : "PGCM0002.do",
        type     : "POST",
        dataType : "json",
        data     : { df_method_nm: "getEntFnnr"        	       
        	       , crp_cd: crpCd
        	       , start_dt: startDt
        	       , end_dt: endDt
        	       , bsn_tp: bsnTp
        	       , crp_cls: crpCls
        	       },                
        async    : false,                
        success  : function(response) {
        	try {        		
        		if(response.result) {
        			// 재무 팝업
        			popFnnrHTML(id,yr);
                } else {
                	jsMsgBox(null,'info',response.message);
                }
            } catch (e) {
                if(response != null) {
                	jsSysErrorBox(response.err_code+": "+response.err_msg);
                } else {
                    jsSysErrorBox(e);
                }
                return;
            }
        }
    });	 
}

// 신용평가사수집데이터 팝업
function popCdlTColctData(jurirno,bizrno,baseYr){
	var methodNm = "showCdlTColctData";
	var params = "?df_method_nm="+methodNm;
	params += "&ad_jurirno="+jurirno;
	params += "&ad_bizrno="+bizrno;
	params += "&ad_baseYr="+baseYr;
	
	var pop = window.open("<c:url value='/PGIM0010.do' />"+params,"fnnrPop","width=900,height=550, scrollbars=yes, resizable=yes");
}

// 기업재무 팝업
function popFnnrHTML(id,yr){
	var pop = window.open("<c:url value='${PUB_FNNRHTML_URL}' />"+"&id="+id+"&yr="+yr,"fnnrPop","width=900,height=800, scrollbars=yes, resizable=yes");
}

// 도로명주소 검색 콜백
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
	$('#ad_zipcod_first_ho').val(zipArr[0]);
	$('#ad_zipcod_last_ho').val(zipArr[1]);
	$('#ad_hedofc_adres_01_ho').val(roadAddrPart1+" "+addrDetail);
	//$('#ad_hedofc_adres_02_ho').val(addrDetail);
	
	2015. 08. 01부터 시행되는 우편번호 5자리 변경 관련 수정
	기존의 팝업방식을 그대로 사용하면 되고, 기존에 000-000 으로 '-'이 붙어서 들어오던 것이 
	앞으로는 '-'없이 00000로 들어온다고 함
	--%>
	
	var zipArr = zipNo.replace("-", "");	// 혹시 모를 '-'처리
	$('#ad_zipcod_first_ho').val(zipArr);		// 우편번호 자리에 그냥 넣어준다.
	$('#ad_hedofc_adres_01_ho').val(roadAddrPart1+" "+addrDetail);
}

// 첨부파일 삭제
function delAttFile(fileSeq,id){
	jsMsgBox(null
			,'confirm'
			,Message.msg.confirmDelete
			,function(){
				$.ajax({        
			        url      : "PGIC0022.do",
			        type     : "POST",
			        dataType : "json",
			        data     : { df_method_nm: "deleteAttFile"        	       
			        	       , file_seq: fileSeq        	       
			        	       },                
			        async    : false,                
			        success  : function(response) {
			        	try {        		
			        		if(eval(response)) {
			        			$("#file_"+id).attr("disabled",false);
			        			$("#file_show_"+id).remove();
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

// 첨부파일 다운로드
function downAttFile(fileSeq){
	jsFiledownload("/PGCM0040.do","df_method_nm=updateFileDownBySeq&seq="+fileSeq);
}

// 법인등록구분 변경(통화코드도 같이 변경)
function changedCprSe(id, year){
	var cprSeVal = $("#ad_cpr_regist_se_"+id+" option:selected").val();
	
	// 통화 코드 변경을 위한 변수
	var crncyCodeVal = $("#ad_crncy_code_"+id+" option:selected").val();
	var amountUnitOption = "";
	
//	$("#ad_crncy_code_+"id).append("<option value='KRW'>한국</option>");
//	$("#ad_crncy_code_"+id+" option:[value='KRW']").remove();
//  $("#ad_crncy_code_"+id).val("AED");
	
	// 국내
	if(cprSeVal=="L"){
		// 통화 코드를 한국으로 변경
		$("#span_capl_"+id+"_"+year).text("(원)");
		$("#span_clpl_"+id+"_"+year).text("(원)");
		$("#span_capl_sm_"+id+"_"+year).text("(원)");
		$("#span_assets_totamt_"+id+"_"+year).text("(원)");
		
		$("#ad_crncy_code_"+id).append("<option value='KRW'>한국</option>");
		$("#ad_crncy_code_"+id).val("KRW");
		
		amountUnitOption +=	"<option value='1'>원</option>";
		//amountUnitOption +=	"<option value='1000000'>백만원</option>";
		
		$(".amount-unit-"+id).each(function(){
			$(this).html(amountUnitOption);
		});
	
		// Dart데이터 불러오기 버튼
		$("#btn_load_dart_ent_"+id).css("display","block");
		// 나라 선택 셀렉 없앰
		$("#ad_crncy_code_"+id).css("display","none");
		// 법인등록번호
		$("#ad_jurirno_first_"+id).attr("readonly",false);
		$("#ad_jurirno_last_"+id).attr("readonly",false);		
		// 사업자등록번호
		$("#ad_bizrno_first_"+id).attr("readonly",false);
		$("#ad_bizrno_middle_"+id).attr("readonly",false);
		$("#ad_bizrno_last_"+id).attr("readonly",false);
		
		// 표준산업분류코드
		$("#smallGroup_"+id).rules('add', {required:true});

		// 설립년월
		$("#ad_fond_de_"+id).rules('add', {required:true});
		
		
		// 주업종명
		<c:forEach items="${largeGroup}" var="item" varStatus="status">
			$("#largeGroup_"+id).append("<option value='${item.lclasCd }'>${item.lclasCd} : ${item.koreanNm }</option>");
		</c:forEach>
		
		
		// 재무정보 - 자본금, 자본잉여금, 자본총계, 상시근로자수
		$("input:text[id^='ad_capl_"+id+"_']").prop("disabled", false);
		$("input:text[id^='ad_clpl_"+id+"_']").prop("disabled", false);
		$("input:text[id^='ad_capl_sm_"+id+"_']").prop("disabled", false);
		$("input:text[id^='ad_ordtm_labrr_co_"+id+"_']").prop("disabled", false);
		
		// 해외일경우 자산총액을 필수
		$("input:text[id^='ad_assets_totamt_"+id+"_']").rules('add', {required:false});
		
		// 월별 상시근로자수 테이블
		<c:if test="${(!empty applyEntInfo['resnManageS'] && applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS3 || applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS4 || applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS5)}">
		$("#labrr_table_"+id).show();
		</c:if>		
		
		$("img[name='img_dnRequiredMark_"+id+"']").show();
		
	// 해외
	}else if(cprSeVal=="F") {
		// 해외 선택시 한국 옵션 제거
		$("#ad_crncy_code_"+id).val("KRW");
		$("#ad_crncy_code_"+id+" option:selected").remove();
	 	$("#ad_crncy_code_"+id).val("AED");
		
		// 현재 선택 된 통화 코드로 변경
		$("#span_capl_"+id+"_"+year).text("("+crncyCodeVal+")");
		$("#span_clpl_"+id+"_"+year).text("("+crncyCodeVal+")");
		$("#span_capl_sm_"+id+"_"+year).text("("+crncyCodeVal+")");
		$("#span_assets_totamt_"+id+"_"+year).text("("+crncyCodeVal+")");
		
		amountUnitOption += "<option value='1'>" + crncyCodeVal + "</option>";
		$(".amount-unit-"+id).each(function(){
			$(this).html(amountUnitOption);
		});
		
		// Dart데이터 불러오기 버튼
		$("#btn_load_dart_ent_"+id).css("display","none");
		// 나라 선택
		$("#ad_crncy_code_"+id).css("display","inline");
		// 법인등록번호
		$("#ad_jurirno_first_"+id).attr("readonly",true);
		$("#ad_jurirno_last_"+id).attr("readonly",true);
		$("#ad_jurirno_first_"+id).val("");
		$("#ad_jurirno_last_"+id).val("");
		// 사업자등록번호
		$("#ad_bizrno_first_"+id).attr("readonly",true);
		$("#ad_bizrno_middle_"+id).attr("readonly",true);
		$("#ad_bizrno_last_"+id).attr("readonly",true);
		$("#ad_bizrno_first_"+id).val("");
		$("#ad_bizrno_middle_"+id).val("");
		$("#ad_bizrno_last_"+id).val("");
		
		// 표준산업분류코드		
		$("#smallGroup_"+id).rules('add', {required:false});
//		$("#ad_mn_induty_code_"+id).attr("readonly",true);
//		$("#ad_mn_induty_code_"+id).val("");		
//		$("#ad_mn_induty_code_"+id).rules('add', {required:false});

		// 설립년월		
		$("#ad_fond_de_"+id).rules('add', {required:false});
		
		// 주업종명
		$("#smallGroup_"+id).val("");
		$("#largeGroup_"+id).val("");

		var beforeSelectSize = $("#smallGroup_"+id+" option").size();
		for(i=0; i<beforeSelectSize; i++) {
			$("#smallGroup_"+id+" option:first").remove();
		}
		beforeSelectSize = $("#largeGroup_"+id+" option").size();
		for(var j=0; j<beforeSelectSize; j++) {
			$("#largeGroup_"+id+" option:first").remove();
		}
		$("#largeGroup_"+id).append("<option value='noSelect'>-선택-</option>");
		
		// 재무정보 - 자본금, 자본잉여금, 자본총계, 상시근로자수
		$("input:text[id^='ad_capl_"+id+"_']").prop("disabled", true).val("");
		$("input:text[id^='ad_clpl_"+id+"_']").prop("disabled", true).val("");
		$("input:text[id^='ad_capl_sm_"+id+"_']").prop("disabled", true).val("");
		$("input:text[id^='ad_ordtm_labrr_co_"+id+"_']").prop("disabled", true).val("");
		
		// 해외일경우 자산총액을 필수
		$("input:text[id^='ad_assets_totamt_"+id+"_']").rules('add', {required:true});
		
		// 월별 상시근로자수 테이블
		<c:if test="${(!empty applyEntInfo['resnManageS'] && applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS3 || applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS4 || applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS5)}">
		$("#labrr_table_"+id).find("input").each(function(){
			$(this).val("");
		});
		$("#labrr_table_"+id).hide();
		</c:if>
		
		$("img[name='img_dnRequiredMark_"+id+"']").hide();
	}
	else {
		// Dart데이터 불러오기 버튼
		$("#btn_load_dart_ent_"+id).css("display","none");
		// 나라 선택
		$("#ad_crncy_code_"+id).css("display","none");
	}
	$("dataForm").validate();
}

// 통화코드 변경
function changedCrnCyCode(id,year){
	var crncyCodeVal = $("#ad_crncy_code_"+id+" option:selected").val();
	var amountUnitOption = "";
	
	// 한국
	if(crncyCodeVal=="KRW"){
		$("#span_capl_"+id+"_"+year).text("(원)");
		$("#span_clpl_"+id+"_"+year).text("(원)");
		$("#span_capl_sm_"+id+"_"+year).text("(원)");
		$("#span_assets_totamt_"+id+"_"+year).text("(원)");
		
		amountUnitOption +=	"<option value='1'>원</option>";
		//amountUnitOption +=	"<option value='1000000'>백만원</option>";
		$(".amount-unit-"+id).each(function(){
			$(this).html(amountUnitOption);
		});
		
	// 외국
	}else{
		$("#span_capl_"+id+"_"+year).text("("+crncyCodeVal+")");
		$("#span_clpl_"+id+"_"+year).text("("+crncyCodeVal+")");
		$("#span_capl_sm_"+id+"_"+year).text("("+crncyCodeVal+")");
		$("#span_assets_totamt_"+id+"_"+year).text("("+crncyCodeVal+")");
			
		amountUnitOption += "<option value='1'>" + crncyCodeVal + "</option>";
		$(".amount-unit-"+id).each(function(){
			$(this).html(amountUnitOption);
		});
	}	
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

// 테스트
function testFn(){	
	
}

//법인등록구분이 국내일 경우 법인등록번호, 사업자등록번호가 필수입력이 된다.
function chkCprRegistSe(){
	$(".tbl_add").each(function(i){
		var $sel = $(this).find("input[name*='ad_jurirno_first']");
		$sel.each(function(){
			var id = $(this).attr("id");
			
			var idx = id.replace("ad_jurirno_first_", "").split("_");
			var cprSeVal = $("#ad_cpr_regist_se_"+(idx[0])+" option:selected").val();
			var jurirno = $("#ad_jurirno_first_"+(idx[0])).val();

			if(cprSeVal == "L"){
				//$(this).attr("required", true);
				if($("#ad_jurirno_first_"+(idx[0])).val() == "" || $("#ad_jurirno_last_"+(idx[0])).val() == "" ){
					$("#ad_jurirno_first_"+(idx[0])).rules('add', {required:true});
				}
				if($("#ad_bizrno_first_"+(idx[0])).val() == "" || $("#ad_bizrno_middle_"+(idx[0])).val() == "" || $("#ad_bizrno_last_"+(idx[0])).val() == ""){
					$("#ad_bizrno_first_"+(idx[0])).rules('add', {required:true});
				}
				isValid = false;
			}else{
				//$(this).attr("required", false);
				$("#ad_jurirno_first_"+(idx[0])).rules('add', {required:false});
				$("#ad_jurirno_last_"+(idx[0])).rules('add', {required:false});
				$("#ad_bizrno_first_"+(idx[0])).rules('add', {required:false});
				$("#ad_bizrno_middle_"+(idx[0])).rules('add', {required:false});
				$("#ad_bizrno_last_"+(idx[0])).rules('add', {required:false});
				isValid = true;
			}
		});
	});
}

</script>
</head>

<body>
<form name="dataForm" id="dataForm" method="post" action="PGIC0023.do" enctype="multipart/form-data">
<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />
<input type="hidden" id="ad_rcpy_cnt" name="ad_rcpy_cnt" />
<input type="hidden" id="ad_reqst_se" name="ad_reqst_se" />
<input type="hidden" id="ad_load_rcept_no" name="ad_load_rcept_no" value="${param.ad_load_rcept_no}" />
<input type="hidden" id="ad_comp_rcept_no" name="ad_comp_rcept_no" />
<!-- 20171212 추가 -->
<input type="hidden" id="ad_admin_new_at" name="ad_admin_new_at" value="${param.ad_admin_new_at}" />
<input type="hidden" id="ad_user_no" name="ad_user_no" value="${param.ad_user_no}" />
<input type="hidden" id="ad_reqst_se_search" name="ad_reqst_se_search" value="" />

<input type="hidden" id="ad_bizrno_cnt" name="ad_bizrno_cnt" value="${applyEntInfo['bizrnoFormatList'].size()-1}" />

<c:choose>
<c:when test="${loadDataYn eq 'Y'}">
<input type="hidden" id="ad_issu_year" name="ad_issu_year" value="${applyEntInfo['applyMaster']['JDGMNT_REQST_YEAR']}" />
<input type="hidden" id="ad_stacnt_mt_ho" name="ad_stacnt_mt_ho" value="${applyEntInfo['issuBsisInfo']['ACCT_MT']}" />
<input type="hidden" id="ad_confm_target_yy" name="ad_confm_target_yy" value="${applyEntInfo['applyMaster']['CONFM_TARGET_YY']}" />
<input type="hidden" id="ad_excpt_trget_at" name="ad_excpt_trget_at" value="${applyEntInfo['applyMaster']['EXCPT_TRGET_AT']}" />
</c:when>       
<c:otherwise>
<input type="hidden" id="ad_issu_year" name="ad_issu_year" value="${param.ad_jdgmnt_reqst_year}" />
<input type="hidden" id="ad_stacnt_mt_ho" name="ad_stacnt_mt_ho" value="${param.ad_stacnt_mt_ho}" />
<input type="hidden" id="ad_confm_target_yy" name="ad_confm_target_yy" value="${param.ad_confm_target_yy}" />
<input type="hidden" id="ad_excpt_trget_at" name="ad_excpt_trget_at" value="${param.ad_excpt_trget_at}" />
</c:otherwise>
</c:choose>

<!--//content-->
<c:choose>
<c:when test="${param.ad_win_type eq 'pop'}">
<input type="hidden" id="no_lnb" value="true" />
<div id="self_dgs">
	<div class="pop_q_con">
</c:when>       
<c:otherwise>
<div id="wrap">
	<div class="s_cont" id="s_cont">
		<div class="s_tit s_tit02">
			<h1>기업 확인서</h1>
		</div>
		
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit tit2">기업 확인서</h2>
				<ul>
				</ul>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}" />
				</div>
				<div class="r_cont s_cont02_05">
					<div class="step_sec">
						<ul>
							<li>1.기본확인</li><li class="arr"></li>
							<li>2.약관동의</li><li class="arr"></li>
							<li class="on">3.신청서작성</li><li class="arr"></li>
							<li>4.신청완료</li>
						</ul>
					</div>
</c:otherwise>
</c:choose>               
               <br />
               <div class="plz bg_gray">
						<div class="left">
							<h3>공통안내</h3>
						</div>
						<div class="right">
							<p>* <strong>신청기업 및 관계기업에 대한 제출서류</strong>는 신청서 작성 시<strong> 파일로 첨부</strong>해 주시기 바랍니다.</p>
							<p>* 첨부파일 용량은 파일당 <strong>최대 20mb</strong>이며, 첨부 가능한 확장자는 <strong>hwp,doc,docx,pdf,jpg,jpeg,png,zip</strong> 입니다.</p>
							<p>* 주주명부 : 요약 주주명부 또는 주식등변동상황명세서로 대체가능, <strong>주주명 및 특수 관계 여부 기재 (원본대조필, 개인정보 제외)</strong></p>
							<p>* <strong>외부감사대상기업</strong> → 감사보고서  |  <strong>비외감기업</strong> → 표준재무제표증명원 (개별재무제표)</p>
							<p>* <strong>전자공시대상기업</strong>(dart.fss.or.kr)은 <strong>감사보고서 제출 생략 가능</strong>합니다.</p>
							<p>* <strong>로그인 세션 만료 시간은 1시간이나, 장시간 입력하실 경우 반드시 중간중간 임시저장을 해 주십시오.</strong></p>
						</div>
				</div><br/>
				<div class="plz2 bg_sky">
						<div class="left">
							<h3>오류 발생시<br/>확인사항</h3>
						</div>
						<div class="right">
							<p><strong><span style="color:red;">※ 임시저장 또는 신청이 되지 않는 경우 </span></strong></p>
							<p>&emsp;* <strong>임시저장이 되면 신청도 가능합니다. 오류가 발생한 경우 임시저장이 되는지 확인해 주시기 바랍니다.</strong></p>
							<p>&emsp;* <strong>로그인 세션이 만료되었는지 확인</strong>해 주십시오.</p>
							<p>&emsp;* <strong>필수 입력 사항을 입력하였는지 확인</strong>해 주십시오.</p>
							<p>&emsp;* 재무정보 입력란에 <strong>숫자 이외의 문자나 공백이 입력되어 있는지 확인</strong>해 주십시오.</p>
							<p>&emsp;* 업로드한 파일이 <strong>첨부 가능한 확장자인지 확인</strong>해 주십시오.</p><br/>
							<p><strong><span style="color:red;">※ Dart 연동 오류</span></strong></p>
							<p>&emsp;* <strong>Dart에 공시된 기업명과 정보 회원정보의 기업명이 일치하는지 확인</strong>해 주십시오.</p>
							<p>&emsp;* Dart에 공시되어 있으나 <strong>연동이 되지 않는 경우 직접 입력해 주시고 첨부파일은 생략</strong>해 주십시오.</p>
							<p>&emsp;&nbsp;- <strong>특정연도만 Dart연동이 되지 않는 경우</strong> : Dart에서 해당연도 공시 확인 후 첨부파일 생략</p>
							<p>&emsp;&nbsp;- <strong>특정연도만 Dart에 공시되어 있지 않은 경우</strong> : 해당연도만 파일 첨부</p>
						</div>
				</div><br/><br/>
              <!--  <p class="explain_txt" style="padding-left: 0;">※ 장시간 입력하실 경우 반드시 중간중간 임시저장을 해주세요.</p>
               <p class="explain_txt" style="padding-left: 0;">※ 첨부파일 용량은 파일당 최대 20MB 까지 입니다.</p>
               <p class="explain_txt" style="padding-left: 0; margin-bottom: 58px;">
						※ Dart 연동 공지<br/>
						&emsp;* 전자공시시스템(dart.fss.or.kr)에 공시가 되어 있는 경우 첨부파일 생략 가능합니다. <br/>
						&emsp;* Dart에 공시되어 있더라도 주주명부는 첨부해 주셔야 합니다.<br/>
						&emsp;* ‘Dart 데이터 불러오기’ <span style="color:#ff4189;">실패시 직접 입력</span>해 주시고 <span style="color:#ff4189;">첨부파일은 생략</span>해 주십시오.<br/>
						&emsp;&nbsp;- 특정연도만 Dart연동이 되지 않는 경우 : Dart에서 해당연도 공시 확인 후 첨부파일 생략<br/>
						&emsp;&nbsp;- 특정연도만 Dart에 공시되어 있지 않은 경우 : 해당연도만 파일 첨부</br>
						<br/>
					</p> -->
					
               <!--  -->
               <!-- <div class="type_zone"> -->
               <div class="list_bl">
               <!--  -->
               
                   <!--//1.기업정보-->                   
                   <c:choose>
					<c:when test="${loadDataYn eq 'Y'}">
					<c:set var="lastYear" value="${applyEntInfo['applyMaster']['JDGMNT_REQST_YEAR']}" />
					</c:when>       
					<c:otherwise>
					<c:set var="lastYear" value="${param.ad_jdgmnt_reqst_year}" />					
					</c:otherwise>
				   </c:choose>
                   <div class="request_tbl">
                       <div class="list_bl" style="margin:0;">
                           <h4 class="fram_bl">기업정보<span>(사업자등록증과 동일하게 작성)</span><p><img src="/images2/sub/table_check.png">항목은 입력 필수 항목입니다.</p></h4>
                       </div>
                       <div class="write">
                           <table class="table_form">
                               <caption>
                               신청기업정보
                               </caption>
                               <colgroup>
                               <col style="width:170px" />
                               <col style="width:225px" />
                               <col style="width:130px" />
                               <col style="width:225px" />
                               </colgroup>
                               <tbody>
                                   <tr>
                                       <td colspan="4" class="pr0">	   
                                       <div class="fr btn_inner" style="text-align:right;">
                                       		<c:if test="${isAdminOrBiz eq 'Y' && param.ad_admin_new_at ne 'Y'}"> <!-- 20171212 추가 -->
											<a class="form_blBtn" href="#none" onclick="fn_admin_sys();"><span>시스템판정 결과보기</span></a> 
											&nbsp;
											<a href="#none" class="form_blBtn" id=btn_show_cdlt_colct_data" onclick="popCdlTColctData('${applyEntInfo['reqstRcpyList']['JURIRNO']}','${applyEntInfo['reqstRcpyList']['BIZRNO']}','${applyEntInfo['applyMaster']['JDGMNT_REQST_YEAR']}');"><span>신용평가사 수집정보</span></a>                                       		
									   		</c:if>
									   		&nbsp;
                                       		<a href="#none" class="form_blBtn" id="btn_load_dart_ho" onclick="loadDartEntList('ho');">
                                       		<span>Dart데이터 불러오기</span></a>
                                       </div>                                       	
                                       </td>
                                   </tr>
                                   <tr>
                                       <th scope="row" class="point"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 확인신청대상년도<img src="<c:url value="/images2/sub/help_btn.png" />" class="request_year_dec" alt="?" style="float:right; margin-right:5px" /></th>
                                       <td>
                                        <!-- <select name="ad_issu_year" id="ad_issu_year" style="width:80px;">                                           
                                        </select> -->
                                        <c:choose>
											<c:when test="${loadDataYn eq 'Y'}">
												${applyEntInfo["applyMaster"]["CONFM_TARGET_YY"]}
										   	</c:when>       
										   	<c:otherwise>
											   	${param.ad_confm_target_yy }
										   	</c:otherwise>
										</c:choose>
                                        
                                       </td>
                                       <th scope="row">직전사업년도 <img src="<c:url value="/images2/sub/help_btn.png" />" class="before_year_dec" alt="?" style="float:right; margin-right:5px" /></th>
                                       <td>
	                                    <c:choose>
											<c:when test="${loadDataYn eq 'Y'}">
												${applyEntInfo["applyMaster"]["JDGMNT_REQST_YEAR"]}
										   	</c:when>       
										   	<c:otherwise>
											   	${param.ad_jdgmnt_reqst_year }
										   	</c:otherwise>
									   	</c:choose>                                       
                                       </td>
                                   </tr>
                                   <tr>
									<th scope="row" class="point"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 기업명<img src="<c:url value="/images2/sub/help_btn.png" />"  class="request_entrprs_nm" alt="?" style="float:right; margin-right:5px" /></th>
									<td>										
										<c:choose>
										<c:when test="${!empty param.ad_entrprs_nm}">
											<input type="hidden" name="ad_entrprs_nm_ho" id="ad_entrprs_nm_ho" value="${fn:replace(param.ad_entrprs_nm, '&amp;', '&')}" />
											${fn:replace(param.ad_entrprs_nm, '&amp;', '&')}
										</c:when>       
										<c:otherwise>
											<input type="hidden" name="ad_entrprs_nm_ho" id="ad_entrprs_nm_ho" value="${fn:replace(applyEntInfo['reqstRcpyList']['ENTRPRS_NM'], '&amp;', '&')}" />
											${fn:replace(applyEntInfo['reqstRcpyList']['ENTRPRS_NM'], '&amp;', '&')}
										</c:otherwise>
										</c:choose>
									</td>
									<th scope="row">법인등록번호</th>
									<td>
										<c:choose>
										<c:when test="${param.ad_admin_new_at eq 'Y' && !empty param.ad_jurirno}"> <!-- 20171212 추가 -->
											<input type="hidden" name="ad_jurirno_ho" id="ad_jurirno_ho" value="${param.ad_jurirno}" />
											${param.ad_jurirno.substring(0,6)}-${param.ad_jurirno.substring(6)}
										</c:when>
										<c:when test="${!empty entUserVo.jurirno}">
											<input type="hidden" name="ad_jurirno_ho" id="ad_jurirno_ho" value="${entUserVo.jurirno}" />
											${entUserVo.jurirno.substring(0,6)}-${entUserVo.jurirno.substring(6)}
										</c:when>
										<c:otherwise>
											<input type="hidden" name="ad_jurirno_ho" id="ad_jurirno_ho" value="${applyEntInfo['reqstRcpyList']['JURIRNO']}" />
											${applyEntInfo['reqstRcpyList']['JURIRNO_FIRST']}-${applyEntInfo['reqstRcpyList']['JURIRNO_LAST']}
										</c:otherwise>
										</c:choose>										
									</td>
								</tr>
								<tr>
									<th scope="row" class="point">
										<label for="ad_rprsntv_nm_ho"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 대표자명<img src="<c:url value="/images2/sub/help_btn.png" />" class="request_rprsntv_nm" alt="?" style="float:right; margin-right:5px" /></label>
									</th>
									<td>
										<input required maxlength="50" value="${applyEntInfo['issuBsisInfo']['RPRSNTV_NM']}" name="ad_rprsntv_nm_ho" type="text" id="ad_rprsntv_nm_ho" class="text" style="width:98%;" title="대표자명" />
									</td>
									<%-- <th scope="row">사업자등록번호</th>
									<td>
										<c:choose>
										<c:when test="${!empty param.ad_bizrno_first}">
											<input type="hidden" name="ad_bizrno_ho" id="ad_bizrno_ho" value="${param.ad_bizrno_first}${param.ad_bizrno_middle}${param.ad_bizrno_last}" />
											${param.ad_bizrno_first}-${param.ad_bizrno_middle}-${param.ad_bizrno_last}
										</c:when>       
										<c:otherwise>
											<input type="hidden" name="ad_bizrno_ho" id="ad_bizrno_ho" value="${applyEntInfo['reqstRcpyList']['BIZRNO']}" />
											${applyEntInfo['reqstRcpyList']['BIZRNO_FIRST']}-${applyEntInfo['reqstRcpyList']['BIZRNO_MIDDLE']}-${applyEntInfo['reqstRcpyList']['BIZRNO_LAST']}
										</c:otherwise>
										</c:choose>
									</td> --%>
									<!--사업자등록번호 & 임시 추가버튼 -->
									<th scope="row" class="p_l_30" style="padding-left:15px;">사업자등록번호
										<a href="#none" id="btn_add_bizrno" class="form_blBtn" style="padding:2px 8px 1px 8px; text-align:center;">지점 추가</a>
										<img src="<c:url value="/images2/sub/help_btn.png" />"  class="ad_bizrno_tip" alt="?" style="float:right; margin-right:5px" />
									</th>
									<td id="bizrno_td">
										<c:choose>
											<c:when test="${empty applyEntInfo['bizrnoFormatList']}">
												<input type="hidden" name="ad_bizrno_ho" id="ad_bizrno_ho" value="${param.ad_bizrno_first}${param.ad_bizrno_middle}${param.ad_bizrno_last}" />
													${param.ad_bizrno_first}-${param.ad_bizrno_middle}-${param.ad_bizrno_last}
												
												<%-- ${applyEntInfo['reqstRcpyList']['BIZRNO_FIRST']}-${applyEntInfo['reqstRcpyList']['BIZRNO_MIDDLE']}-${applyEntInfo['reqstRcpyList']['BIZRNO_LAST']} --%>
											</c:when>       
											<c:otherwise>
												<input type="hidden" name="ad_bizrno_ho" id="ad_bizrno_ho" value="${applyEntInfo['reqstRcpyList']['BIZRNO']}" />
												<%-- ${applyEntInfo['reqstRcpyList']['BIZRNO_FIRST']}-${applyEntInfo['reqstRcpyList']['BIZRNO_MIDDLE']}-${applyEntInfo['reqstRcpyList']['BIZRNO_LAST']} --%>
												${applyEntInfo['reqstRcpyList']['BIZRNO']}
												<c:forEach items="${applyEntInfo['bizrnoFormatList']}" var="item" varStatus="status">
													<%-- <c:choose>
														<c:when test="${status.count eq '1'}">
															${item.first}-${item.middle}-${item.last}<br>
														</c:when>
														<c:otherwise> --%>
															<span><br />
															<input type="text" id="tx_bizrno_compno_first_${status.count}" name="${status.count}" maxlength="3" class="text tx_bizrno_compno" style="width:50px;" value=${item.first} />
															 - <input type="text" id="tx_bizrno_compno_middle_${status.count}" maxlength="2" class="text" style="width:30px;"" value=${item.middle} />
															 - <input type="text" id="tx_bizrno_compno_last_${status.count}" maxlength="5" class="text" style="width:70px;" value=${item.last} />
															<input type="hidden" id="ad_bizrno_compno_${status.count}" name="ad_bizrno_compno_${status.count}" class="text" value=${item.first}${item.middle}${item.last} />
															<img src="/images/ucm/icon_del.png" alt="삭제하기" onclick='bizNumRemove($(this))'>
															</span>
														<%-- </c:otherwise>
													</c:choose> --%>
												</c:forEach>
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								<!--사업자등록번호 추가 임시 파일첨부01 -->
								<!-- 1 : 파일구분x, 필수입력x-->
								<!-- <tr>
									<th style="width:175px" scope="row"><label>파일첨부</label></th>
									<td colspan="3"><input name="" type="file" id="" style="width: 100%;" title="파일첨부" /></td>
								</tr> -->
								<!-- 2 : 파일구분o, 임시 RF6, 필수입력o-->
								<%-- <tr>
                                   <th scope="row" class="point" colspan="1" style="width:175px"><label for="file_ho_rf2"  ><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 파일첨부</label></th>
                                   <td colspan="3">
                                   	<c:set var="reqstFileRF" value="${applyEntInfo['reqstFile'][lastYear.toString()]}" />                                            	
                                   	<input required <c:if test="${!empty reqstFileRF['RF6']}">disabled</c:if> name="file_ho_rf2" type="file" id="file_ho_rf2" style="width:100%;" title="파일첨부" />
                                   	<c:if test="${!empty reqstFileRF['RF6']}">
                                   	<div id="file_show_ho_rf2">
                                   		<input type="hidden" id="ad_file_ho_rf2" name="ad_file_ho_rf2" value="${reqstFileRF['RF6']['FILE_SEQ']}" />
                                    	<a href="#none" onclick="delAttFile('${reqstFileRF['RF6']['FILE_SEQ']}','ho_rf2')"><img src="<c:url value="/images/ucm/icon_del.png" />" alt="삭제하기" /> </a>
                                    	<a href="#none" onclick="downAttFile('${reqstFileRF['RF6']['FILE_SEQ']}')">${reqstFileRF['RF6']['LOCAL_NM']} </a>
                                   	</div>
                                   	</c:if>                                            	
                                   </td>
                               </tr> --%>
                                   <tr>
                                       <th rowspan="2" scope="row" class="point">
                                       	<img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 본사주소<img src="<c:url value="/images2/sub/help_btn.png" />"  class="request_hedofc_adres" alt="?" style="float:right; margin-right:5px" />
                                       </th>
                                       <td colspan="3">
                                       	<input value="${applyEntInfo['issuBsisInfo']['ZIP_FIRST']}" name="ad_zipcod_first_ho" type="text" id="ad_zipcod_first_ho" class="text numeric5" style="width:87px;" title="우편번호앞자리" />
                                           <!--
                                           <input value="${applyEntInfo['issuBsisInfo']['ZIP_LAST']}" name="ad_zipcod_last_ho" type="text" id="ad_zipcod_last_ho" class="text numeric3" style="width:87px;" title="우편번호뒷자리" />
                                   			-->
                                           <a href="#none" id="btn_search_zip" class="gray_btn"><span>우편번호 검색</span></a></td>
                                   </tr>
                                   <tr>
                                       <td colspan="3">
                                       	<input required maxlength="200" value="${applyEntInfo['issuBsisInfo']['HEDOFC_ADRES']}" name="ad_hedofc_adres_01_ho" type="text" id="ad_hedofc_adres_01_ho" class="text" style="width:100%;" title="주소상세" />
                                       </td>
                                   </tr>
                                   
                                   <tr>
                                   <!--
                                       <th scope="row" class="point"><label><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 표준산업분류코드</label>
                                           <a href="#none" class="btn_code induty_cod_dec"><img src="<c:url value="/images/ic/btn_code.png" />" alt="?" style="float:right; margin-right:5px" /></a>                                            
                                       </th>
                                       <td>
                                       	<input required maxlength="5" value="${applyEntInfo['reqstRcpyList']['MN_INDUTY_CODE']}" name="ad_mn_induty_code_ho" type="text" id="ad_mn_induty_code_ho" class="text" style="width:55px;" title="표준산업분류코드" />
                                           <div class="btn_inner"><a href="#none" class="btn_in_gray btn_search_code"><span>분류코드조회</span></a></div>
                                       </td>
                                    -->
                                       <th scope="row" class="point"><label><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 주업종</label></th>
                                       <td colspan="3">
											<select required name="largeGroup" class="select_box" id="largeGroup" style="width:250px" onchange="changelargeGroupSelect(this.value);">
												<option value="noSelect">-선택-</option>
												<c:forEach items="${largeGroup}" var="item" varStatus="status">
													<option value="${item.lclasCd }" <c:if test="${item.lclasCd eq lclasCd}">selected</c:if> > ${item.lclasCd} : ${item.koreanNm }</option>
												</c:forEach>
											</select>
											<select required name="smallGroup" class="select_box" id="smallGroup" style="width:250px"> 
												<c:forEach items="${small}" var="item" varStatus="status">
													<option value="${item.indutyCode}:${item.koreanNm}" <c:if test="${item.indutyCode eq fn:substring(applyEntInfo['reqstRcpyList']['MN_INDUTY_CODE'],0,2)}">selected</c:if> >${item.indutyCode} ${item.koreanNm} </option>
												</c:forEach>
											</select>
                                       </td>
                                   </tr>
                                   <tr>
                                       <th scope="row" class="point"><label><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 전화번호</label></th>
                                       <td>
										<select id="ad_reprsnt_tlphon_first_ho" class="select_box" name="ad_reprsnt_tlphon_first_ho" style="width:65px; ">
											<c:forTokens items="${PHONE_NUM_FIRST_TOKEN}" delims="," var="phoneNum">
											<option value="${phoneNum}" <c:if test="${applyEntInfo['issuBsisInfo']['REPRSNT_TLPHON_FIRST'] eq phoneNum}">selected</c:if> >${phoneNum}</option>
											</c:forTokens>
										</select>
										~
										<input required value="${applyEntInfo['issuBsisInfo']['REPRSNT_TLPHON_MIDDLE']}" name="ad_reprsnt_tlphon_middle_ho" type="text" id="ad_reprsnt_tlphon_middle_ho" class="text numeric4" style="width:75px;" title="전화번호중간번호" />
										~
										<input required value="${applyEntInfo['issuBsisInfo']['REPRSNT_TLPHON_LAST']}" name="ad_reprsnt_tlphon_last_ho" type="text" id="ad_reprsnt_tlphon_last_ho" class="text numeric4" style="width:75px;" title="전화번호마지막번호" />
									</td>
                                       <th scope="row"> FAX 번호</th>
                                       <td>
										<select id="ad_fxnum_first_ho" class="select_box" name="ad_fxnum_first_ho" style="width:65px; ">
											<c:forTokens items="${PHONE_NUM_FIRST_TOKEN}" delims="," var="phoneNum">
											<option value="${phoneNum}" <c:if test="${applyEntInfo['issuBsisInfo']['FXNUM_FIRST'] eq phoneNum}">selected</c:if> >${phoneNum}</option>
											</c:forTokens>
										</select>
										~
										<input value="${applyEntInfo['issuBsisInfo']['FXNUM_MIDDLE']}" name="ad_fxnum_middle_ho" type="text" id="ad_fxnum_middle_ho" class="text numeric4" style="width:75px;" title="팩스번호중간번호" />
										~
										<input value="${applyEntInfo['issuBsisInfo']['FXNUM_LAST']}" name="ad_fxnum_last_ho" type="text" id="ad_fxnum_last_ho" class="text numeric4" style="width:75px;" title="팩스번호마지막번호" />
									</td>
                                   </tr>
                                   <tr>
                                       <th scope="row" class="point"><label for="ad_stacnt_mt_ho_disp"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 결산월</label></th>
                                       <td>                                       
                                       		<select id="ad_stacnt_mt_ho_disp" class="select_box" name="ad_stacnt_mt_ho_disp" class ="stacnt_mt" style="width:75px;" >
                                       		<c:forTokens items="${MONTHS_TOKEN}" delims="," var="month">
											<%-- <option value="${month}" <c:if test="${applyEntInfo['issuBsisInfo']['ACCT_MT'] eq month }">selected</c:if> >${month}</option> --%>
											<c:choose>
												<c:when test="${loadDataYn eq 'Y'}">
													<option value="${month}" <c:if test="${applyEntInfo['issuBsisInfo']['ACCT_MT'] eq month }">selected</c:if> >${month}</option>
											   	</c:when>       
											   	<c:otherwise>
												   	<option value="${month}" <c:if test="${param.ad_stacnt_mt_ho eq month }">selected</c:if> >${month}</option>	
											   	</c:otherwise>
										   	</c:choose> 																			
											</c:forTokens>
                                        	</select>
                                           월                                            
                                       <th scope="row" class="point"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 설립년월<img src="<c:url value="/images2/sub/help_btn.png" />" class="request_fond_de_ho" alt="?" style="float:right; margin-right:5px" /></th>
                                       <td>
                                       	<input required value="${applyEntInfo['reqstRcpyList']['FOND_DE']}" type="text" name="ad_fond_de_ho" id="ad_fond_de_ho" class="fond_de yyyy-MM-dd" title="날짜선택" style="width:200px;"/>
                                       </td>
                                   </tr>
                                   <tr>
                                       <th scope="row" class="point"><label><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 용도(사업명)</label><img src="<c:url value="/images2/sub/help_btn.png" />" class="request_prpos_ho" alt="?" style="float:right; margin-right:5px" /></th>
                                		<td colspan="3">
                                			<ap:code id="reqst_se_search" grpCd="85" type="checkbox" selectedCd="${applyEntInfo['issuBsisInfo']['CHK_RECEPDSK']}" onclick="javascript:count_check('reqst_se_search');" defaultLabel="전체"/>
                                			기타 : <input maxlength="50" value="${applyEntInfo['issuBsisInfo']['RECEPDSK']}" name="ad_recepdsk_ho" type="text" id="ad_recepdsk_ho" class="text" style="width:100%;" title="제출처" />
                                		</td>
                                   </tr>
                                   <tr>
                                       <th scope="row"> 특이사항<img src="<c:url value="/images2/sub/help_btn.png" />" class="request_partclr_matter_ho" alt="?" style="float:right; margin-right:5px" /></th>
                                       <td colspan="3">
                                           <input maxlength="200" value="${applyEntInfo['reqstRcpyList']['PARTCLR_MATTER']}" name="ad_partclr_matter_ho" type="text" id="ad_partclr_matter_ho" class="text" style="width:100%;" title="특이사항" placeholder="법인 신규설립이나 분할·합병 등의 특이 사항을 입력해 주세요"/></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <!--1.기업정보//-->
                    
                    <!--사업자등록번호 추가 임시 파일첨부02 -->
                    <div class="request_tbl">
                  	   <div class="list_bl" style="margin:0;">
                           <h4 class="fram_bl">지점 사업자등록증 첨부<span style="color:#2763ba;">&nbsp;(지점 사업자등록번호 추가시, 지점 사업자등록증 또는 종된 사업장 명세 첨부 필수)</span></h4>
                       </div>
						<table class="table_form">
							<tbody>
								<tr>
			                        <th scope="row" class="point"><label for="file_ho_rf4"  >파일첨부</label></th>
			                        <td colspan="3">
			                        	<c:set var="reqstFileRF" value="${applyEntInfo['reqstFile'][lastYear.toString()]}" />                                            	
			                        		<c:choose>
												<c:when test="${applyEntInfo['bizrnoFormatList'].size() > 1}">
			                        				<input <c:if test="${!empty reqstFileRF['RF4']}">disabled</c:if> required name="file_ho_rf4" type="file" id="file_ho_rf4" style="width:100%;" title="파일첨부" />
			                        			</c:when>
			                        			<c:otherwise>
			                        				<input <c:if test="${!empty reqstFileRF['RF4']}">disabled</c:if> name="file_ho_rf4" type="file" id="file_ho_rf4" style="width:100%;" title="파일첨부" />
												</c:otherwise>
											</c:choose>			                        			
			                        	<c:if test="${!empty reqstFileRF['RF4']}">
				                        	<div id="file_show_ho_rf4">
				                        		<input type="hidden" id="ad_file_ho_rf4" name="ad_file_ho_rf4" value="${reqstFileRF['RF4']['FILE_SEQ']}" />
				                         		<a href="#none" onclick="delAttFile('${reqstFileRF['RF4']['FILE_SEQ']}','ho_rf4')"><img src="<c:url value="/images/ucm/icon_del.png" />" alt="삭제하기" /> </a>
				                         		<a href="#none" onclick="downAttFile('${reqstFileRF['RF4']['FILE_SEQ']}')">${reqstFileRF['RF4']['LOCAL_NM']} </a>
				                        	</div>
			                        	</c:if>          
			                        </td>
			                    </tr>
							</tbody>
						</table>
					</div>
                    <!--사업자등록번호 추가 임시 파일첨부02 -->
                   
                   <!--//2.주주명부-->
                   <div class="request_tbl">
                       <div class="title_zone">
                           <h4 class="fram_bl">주주명부 <img src="<c:url value="/images2/sub/help_btn.png" />" class="request_shrholdr" alt="?" style="margin:0 5px" /> 
                            <a href="#none" class="btn_t_open" id="btn_skrt_close"><img src="<c:url value="/images/ic/btn_t_close.png" />" alt="닫기" /></a>
                            <a href="#none" class="btn_t_open" id="btn_skrt_open"><img src="<c:url value="/images/ic/btn_t_open.png" />" alt="열기" /></a>
                          	</h4>
                       </div>
                       <div class="con" id="div_skrt_con">
                           <div class="write mb30">
                               <table class="table_form">
                                   <caption>
                                   주주명부
                                   </caption>
                                   <colgroup>
                                   <col style="width:16%" />
                                   <col style="width:14%" />
                                   <col style="width:21%" />
                                   <col style="width:17%" />
                                   <col style="width:*" />
                                   </colgroup>
                                   <tbody>
                                       <tr>
                                           <th rowspan="3" scope="row">지분 소유비율<br/>
                                               (최대 3개 입력)</th>
                                           <th scope="row" class="point"><label for="ad_shrholdr_nm1_ho"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 주주명</label></th>
                                           <td><input required maxlength="255" value="${applyEntInfo['reqstInfoQotaPosesn']['SHRHOLDR_NM1']}" name="ad_shrholdr_nm1_ho" type="text" id="ad_shrholdr_nm1_ho" class="text" style="width:95%;" title="주주명" /></td>
                                           <th scope="row" class="point"><label for="ad_qota_rt1_ho"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 지분소유비율</label></th>
                                           <td><input required value="${applyEntInfo['reqstInfoQotaPosesn']['QOTA_RT1']}" name="ad_qota_rt1_ho" type="text" id="ad_qota_rt1_ho" class="text qota_rt max100" style="width:100%;" title="지분소유비율" /></td>
                                       </tr>
                                       <tr>
                                           <th scope="row"><label for="ad_shrholdr_nm2_ho"> 주주명</label></th>
                                           <td><input maxlength="255" value="${applyEntInfo['reqstInfoQotaPosesn']['SHRHOLDR_NM2']}" name="ad_shrholdr_nm2_ho" type="text" id="ad_shrholdr_nm2_ho" class="text" style="width:95%;" title="주주명" /></td>
                                           <th scope="row"><label for="ad_qota_rt2_ho"> 지분소유비율</label></th>
                                           <td><input value="${applyEntInfo['reqstInfoQotaPosesn']['QOTA_RT2']}" name="ad_qota_rt2_ho" type="text" id="ad_qota_rt2_ho" class="text qota_rt max100" style="width:100%;" title="지분소유비율" /></td>
                                       </tr>
                                       <tr>
                                           <th scope="row"><label for="ad_shrholdr_nm3_ho"> 주주명</label></th>
                                           <td><input maxlength="255" value="${applyEntInfo['reqstInfoQotaPosesn']['SHRHOLDR_NM3']}" name="ad_shrholdr_nm3_ho" type="text" id="ad_shrholdr_nm3_ho" class="text" style="width:95%;" title="주주명" /></td>
                                           <th scope="row"><label for="ad_qota_rt3_ho"> 지분소유비율</label></th>
                                           <td><input value="${applyEntInfo['reqstInfoQotaPosesn']['QOTA_RT3']}" name="ad_qota_rt3_ho" type="text" id="ad_qota_rt3_ho" class="text qota_rt max100" style="width:100%;" title="지분소유비율" /></td>
                                       </tr>
                                       <tr>
                                           <th scope="row" class="point" colspan="2"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 제출서류 1) </th>
                                           <td colspan="3">주주명부 또는 주식등변동상황명세서</td>
                                       </tr>
                                       <tr>
                                           <th scope="row" class="point" colspan="2"><label for="file_ho_rf2"  ><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 파일첨부</label></th>
                                           <td colspan="3">
                                           	<c:set var="reqstFileRF" value="${applyEntInfo['reqstFile'][lastYear.toString()]}" />                                            	
                                           	<input required <c:if test="${!empty reqstFileRF['RF2']}">disabled</c:if> name="file_ho_rf2" type="file" id="file_ho_rf2" style="width:100%;" title="파일첨부" />
                                           	<c:if test="${!empty reqstFileRF['RF2']}">
                                           	<div id="file_show_ho_rf2">
                                           		<input type="hidden" id="ad_file_ho_rf2" name="ad_file_ho_rf2" value="${reqstFileRF['RF2']['FILE_SEQ']}" />
                                            	<a href="#none" onclick="delAttFile('${reqstFileRF['RF2']['FILE_SEQ']}','ho_rf2')"><img src="<c:url value="/images/ucm/icon_del.png" />" alt="삭제하기" /> </a>
                                            	<a href="#none" onclick="downAttFile('${reqstFileRF['RF2']['FILE_SEQ']}')">${reqstFileRF['RF2']['LOCAL_NM']} </a>
                                           	</div>
                                           	</c:if>                                            	
                                           </td>
                                       </tr>
                                   </tbody>
                               </table>
                               <!-- <div class="pt5">※ 첨부된 파일들은 암호화되어 관리됩니다.</div>
                               <div class="pt5">※ 첨부파일 내 개인정보(주민등록번호, 주소 등)는 꼭 삭제해주시기 바랍니다.</div> -->
                           </div>
                       </div>
                   </div>
                   <!--2.주주명부//-->
                   
                   <!--//3.재무정보-->
                   <div class="request_tbl">
                       <div class="title_zone" id="div_fnnrinfo_btn">
                           <h4 class="fram_bl">재무정보 <span style="font-size:20PX; color:#2763ba;">[단위 : 원]</span>
                           	<a href="#none" class="btn_t_open" id="btn_fnnrinfo_close"><img src="<c:url value="/images/ic/btn_t_close.png" />" alt="닫기" /></a>
                           	<a href="#none" class="btn_t_open" id="btn_fnnrinfo_open"><img src="<c:url value="/images/ic/btn_t_open.png" />" alt="열기" /></a>
                           </h4>
                       </div>
                    
                    <%-- <c:if test="${loadDataYn eq 'Y'}"> --%>
                    <c:set var="reqstFnnrData" value="${applyEntInfo['reqstFnnrData']}"/>                                       
                    <div class="con" id="div_fnnrinfo_con">
					<div class="table_hrz">
					    <!--//table1-->
					    <table class="table_form finance_table">
					        <caption>
					        년도별재무정보
					        </caption>
					        <colgroup>
					        <col style="width:170px" />
					        <col style="width:110px" />
					        <col style="width:110px" />
					        <col style="width:110px" />
					        <col style="width:110px" />
                            <col style="width:110px" />
					        <col style="width:80px" />
					        </colgroup>
					        <thead>	
					        	<tr>
						        	<th scope="row">&nbsp;</th>				        
						            <th class="tac">매출액</th>
						            <th class="tac">자본금</th>
						            <th class="tac">자본잉여금</th>
						            <th class="tac">자본총계</th>
						            <th class="tac">자산총액</th>
						            <th class="tac">상시근로자수</th>
					        	</tr>
					        </thead>
					        <tbody>
					        	<c:forEach var="n" begin="0" end="3">
					        		<c:set var="year" value="${lastYear-n}" />
					        		<tr>
					                <th scope="row">
					                	<c:if test="${n <= 2}">
					                		<img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" />
					                	</c:if>
					                	${year}년 
					                	<%-- <a href="#none" class="btn_code" onclick="getEntFnnr('ho','${year}')"> --%>
					                	<a href="#none" class="form_blBtn" onclick="getEntFnnr('ho','${year}')">Dart자료
					                		<%-- <img src="<c:url value="/images/ic/btn_dart.png" />" alt="dart자료" /> --%>                                            
					                	</a>
					                	
					                	<fmt:parseNumber var="fmt_amount_unit_ho" integerOnly="true" type="number" value="${reqstFnnrData[year.toString()]['AMOUNT_UNIT']}" />
					                	<!-- (원) -->
					                	<select name="ad_amount_unit_ho_${year}" class="select_box" id="ad_amount_unit_ho_${year}" style="width:80px; ">
					                		<c:choose>
	                                           	<c:when test="${fmt_amount_unit_ho == 1000000}">
	                                           		<option value="1" <c:if test="${fmt_amount_unit_ho == 1}">selected="selected"</c:if>>원</option>
	                                           		<option value="1000000" <c:if test="${fmt_amount_unit_ho == 1000000}">selected="selected"</c:if>>백만원</option>
	                                           	</c:when>
	                                           	<c:otherwise>
	                                           		<option value="1" <c:if test="${fmt_amount_unit_ho == 1}">selected="selected"</c:if>>원</option>
	                                           	</c:otherwise>
                                           	</c:choose>
                                       	</select>
					                </th>					                
					                <td><input <c:if test="${n eq 0}">required</c:if> value="${reqstFnnrData[year.toString()]['SELNG_AM']}" class="-numeric18 selAmO" id="ad_selng_am_ho_${year}" name="ad_selng_am_ho_${year}" type="text"  style="width:100px;" title="${year}년매출액" /></td>
					                <td><input value="${reqstFnnrData[year.toString()]['CAPL']}" class="-numeric18" id="ad_capl_ho_${year}" name="ad_capl_ho_${year}" type="text" style="width:100px;" title="${year}년자본금" /></td>
					                <td><input value="${reqstFnnrData[year.toString()]['CLPL']}" class="-numeric18" id="ad_clpl_ho_${year}" name="ad_clpl_ho_${year}" type="text" style="width:100px;" title="${year}년자본잉여금" /></td>
					                <td><input value="${reqstFnnrData[year.toString()]['CAPL_SM']}" class="-numeric18" id="ad_capl_sm_ho_${year}" name="ad_capl_sm_ho_${year}" type="text" style="width:100px;" title="${year}년자본총계" /></td>
					                <td><input <c:if test="${n eq 0}">required</c:if> value="${reqstFnnrData[year.toString()]['ASSETS_TOTAMT']}" class="-numeric18" id="ad_assets_totamt_ho_${year}" name="ad_assets_totamt_ho_${year}" type="text" style="width:100px;" title="${year}년자산총액" /></td>
					                <td><input <c:if test="${n eq 0}">required</c:if> <c:if test="${year>2014}">disabled</c:if> value="${reqstFnnrData[year.toString()]['ORDTM_LABRR_CO']}" class="numeric10" id="ad_ordtm_labrr_co_ho_${year}" name="ad_ordtm_labrr_co_ho_${year}" type="text" numberOnly style="width:50px;" title="${year}년상시근로자수" /></td>
					            </tr>
								</c:forEach>
								<input type="hidden" id="ad_y3sum_selng_am_ho" name="ad_y3sum_selng_am_ho" value="${reqstFnnrData[lastYear.toString()]['Y3SUM_SELNG_AM']}" />
								<input type="hidden" id="ad_y3avg_selng_am_ho" name="ad_y3avg_selng_am_ho" value="${reqstFnnrData[lastYear.toString()]['Y3AVG_SELNG_AM']}" />	
					        </tbody>
					    </table>
					</div>
					
					<div class="mgt12">
					    <!--//table2-->
					    <table class="table_form">
					        <caption>
					        년도별제출서류
					        </caption>
					        <colgroup>
					        <col style="width:99px" />
					        <col style="width:95px" />
					        <col style="width:*" />
					  		</colgroup>
					        <tbody>
					        <tr>
					        <th scope="row">제출서류2)</th>
						        <th >국내법인</th>
						        <td>감사보고서 또는 표준재무제표증명원<br />
									<span style="color:#2763ba;">전자공시대상기업(dart.fss.or.kr)은 감사보고서 제출 생략 가능</span>
								</td>
					        </tr>
					        <c:forEach var="n" begin="0" end="3">
					        	<c:set var="year" value="${lastYear-n}" />
					        	<tr>
							        <th scope="row"  colspan="2"><label for="file_ho_rf1_${year}"> ${year}년</label></th>
							        <!--  -->
							        <%-- <th scope="row"  colspan="2"><label for="file_ho_rf1_${year}">
							         
							        <c:if test="${n <= 2}">
							        	${year}년
					                </c:if>
							        <c:if test="${n > 2}">
							        	기타<img id="dd" src="<c:url value="/images2/sub/help_btn.png" />" alt="툴팁" /><br/>
					                </c:if>
					                	 
							        </label></th> --%>
							        <!--  -->
							        
							        <td>
										<c:set var="reqstFileRF" value="${applyEntInfo['reqstFile'][year.toString()]}" />
										<input <c:if test="${!empty reqstFileRF['RF1']}">disabled</c:if> name="file_ho_rf1_${year}" type="file" id="file_ho_rf1_${year}" style="width:100%;" title="파일첨부" />
										<c:if test="${!empty reqstFileRF['RF1']}">
										<div id="file_show_ho_rf1_${year}">
											<input type="hidden" id="ad_file_ho_rf1_${year}" name="ad_file_ho_rf1_${year}" value="${reqstFileRF['RF1']['FILE_SEQ']}" />
											<a href="#none" onclick="delAttFile('${reqstFileRF['RF1']['FILE_SEQ']}','ho_rf1_${year}')"><img src="<c:url value="/images/ucm/icon_del.png" />" /> </a>
											<a href="#none" onclick="downAttFile('${reqstFileRF['RF1']['FILE_SEQ']}')">${reqstFileRF['RF1']['LOCAL_NM']} </a>
										</div>
										</c:if>
							        </td>
					       		</tr>
							</c:forEach>
					        </tbody>
					    </table>
					</div>
					</div>
					
					<!--사업자등록번호 추가 임시 파일첨부02 -->
                    <div class="request_tbl">
              	       <div class="list_bl" style="margin:0;">
                           <h4 class="fram_bl">기타 제출서류&nbsp;&nbsp;<img class="ad_etc" src="<c:url value="/images2/sub/help_btn.png" />" alt="툴팁" /></h4>
                       </div>
						<table class="table_form">
							<tbody>
								<tr>
			                        <th scope="row" class="point"><label for="file_ho_rf3">파일첨부</label></th>
			                        <td colspan="3">
			                        	<c:set var="reqstFileRF" value="${applyEntInfo['reqstFile'][lastYear.toString()]}" />                                            	
			                        		<input <c:if test="${!empty reqstFileRF['RF3']}">disabled</c:if> name="file_ho_rf3" type="file" id="file_ho_rf3" style="width:100%;" title="파일첨부" />
			                        	<c:if test="${!empty reqstFileRF['RF3']}">
				                        	<div id="file_show_ho_rf3">
				                        		<input type="hidden" id="ad_file_ho_rf3" name="ad_file_ho_rf3" value="${reqstFileRF['RF3']['FILE_SEQ']}" />
				                         		<a href="#none" onclick="delAttFile('${reqstFileRF['RF3']['FILE_SEQ']}','ho_rf3')"><img src="<c:url value="/images/ucm/icon_del.png" />" alt="삭제하기" /> </a>
				                         		<a href="#none" onclick="downAttFile('${reqstFileRF['RF3']['FILE_SEQ']}')">${reqstFileRF['RF3']['LOCAL_NM']} </a>
				                        	</div>
			                        	</c:if>          
			                        </td>
			                    </tr>
							</tbody>
						</table>
					</div>
                    <!--사업자등록번호 추가 임시 파일첨부02 -->

                   </div>
                   <!--3.재무정보//-->

				   <%-- 보완요청인 경우에만 상시근로자수 입력 받게해 달라는 수정사항 --%>
				   <%-- <c:if test="${(!empty applyEntInfo['resnManageS'] && applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS3)|| !empty applyEntInfo['reqstOrdtmLabrr']}"> --%>
				   <c:if test="${(!empty applyEntInfo['resnManageS'] && applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS3 || applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS4 || applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS5)}">
                   <!--//4.상시근로자수-->
                   <div class="request_tbl">                   
                       <div class="title_zone" id="div_rabrr_btn">
                           <h4 class="fram_bl">상시근로자수 
                           	<a href="#none" class="btn_t_open" id="btn_rabrr_close"><img src="<c:url value="/images/ic/btn_t_close.png" />" alt="닫기" /></a>
                           	<a href="#none" class="btn_t_open" id="btn_rabrr_open"><img src="<c:url value="/images/ic/btn_t_open.png" />" alt="열기" /></a>
                           </h4>
                       </div>
                       
                       <c:if test="${loadDataYn eq 'Y'}">
                    	<c:set var="reqstOrdtmLabrr" value="${applyEntInfo['reqstOrdtmLabrr']}"/>                     	
                    	<c:set var="lastYear" value="${applyEntInfo['applyMaster']['JDGMNT_REQST_YEAR']}" />
                       <div class="con" id="div_rabrr_con">
					    <div class="table_hrz">
					        <p class="mb7">매월말일 기준의 상시근로자수를 입력해 주세요.<span class="fr">[단위 : 명]</span></p>
					        <!--//table1-->
					        <table cellpadding="0" cellspacing="0" class="table_form finance_table" summary="상시근로자수" >
					            <caption>
					            년도별상시근로자수
					            </caption>
					            <colgroup>
					            <col style="width:*" />
					            <col style="width:*" />
					            <col style="width:*" />
					            <col style="width:*" />
					            <col style="width:*" />
					            <col style="width:*" />
					            <col style="width:*" />
					            <col style="width:*" />
					            <col style="width:*" />
					            <col style="width:*" />
					            <col style="width:*" />
					            <col style="width:*" />
					            <col style="width:*" />
					            <col style="width:*" />
					            <col style="width:*" />
					            <col style="width:*" />
					            </colgroup>
					            <thead>
					            <th></th>
					                <th>1</th>
					                <th>2</th>
					                <th>3</th>
					                <th>4</th>
					                <th>5</th>
					                <th>6</th>
					                <th>7</th>
					                <th>8</th>
					                <th>9</th>
					                <th>10</th>
					                <th>11</th>
					                <th>12</th>
					                <th>합계</th>
					                <th>연평균</th>
					                </thead>
					            <tbody>
					            	<c:forEach var="n" begin="0" end="3">
					        		<c:set var="year" value="${lastYear-n}" />
					        		<c:if test="${year<=2013}" >
					        		<tr>
					                    <th scope="row"><label>${year}년</label></th>
										<td><input value="${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO1']}" name="ad_ordtm_labrr_co1_ho_${year}"  class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co1_ho_${year}" style="width:30px;" title="${year}년1월상시근로자수" /></td>
										<td><input value="${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO2']}" name="ad_ordtm_labrr_co2_ho_${year}"  class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co2_ho_${year}" style="width:30px;" title="${year}년2월상시근로자수" /></td>
										<td><input value="${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO3']}" name="ad_ordtm_labrr_co3_ho_${year}"  class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co3_ho_${year}" style="width:30px;" title="${year}년3월상시근로자수" /></td>
										<td><input value="${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO4']}" name="ad_ordtm_labrr_co4_ho_${year}"  class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co4_ho_${year}" style="width:30px;" title="${year}년4월상시근로자수" /></td>
										<td><input value="${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO5']}" name="ad_ordtm_labrr_co5_ho_${year}"  class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co5_ho_${year}" style="width:30px;" title="${year}년5월상시근로자수" /></td>
										<td><input value="${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO6']}" name="ad_ordtm_labrr_co6_ho_${year}"  class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co6_ho_${year}" style="width:30px;" title="${year}년6월상시근로자수" /></td>
										<td><input value="${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO7']}" name="ad_ordtm_labrr_co7_ho_${year}"  class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co7_ho_${year}" style="width:30px;" title="${year}년7월상시근로자수" /></td>
										<td><input value="${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO8']}" name="ad_ordtm_labrr_co8_ho_${year}"  class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co8_ho_${year}" style="width:30px;" title="${year}년8월상시근로자수" /></td>
										<td><input value="${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO9']}" name="ad_ordtm_labrr_co9_ho_${year}"  class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co9_ho_${year}" style="width:30px;" title="${year}년9월상시근로자수" /></td>
										<td><input value="${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO10']}" name="ad_ordtm_labrr_co10_ho_${year}" class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co10_ho_${year}" style="width:30px;" title="${year}년10월상시근로자수" /></td>
										<td><input value="${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO11']}" name="ad_ordtm_labrr_co11_ho_${year}" class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co11_ho_${year}" style="width:30px;" title="${year}년11월상시근로자수" /></td>
										<td><input value="${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO12']}" name="ad_ordtm_labrr_co12_ho_${year}" class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co12_ho_${year}" style="width:30px;" title="${year}년12월상시근로자수" /></td>											
					                    <td>
					                    	<strong id="ordtm_labrr_sum_ho_${year}">${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO_SM']}</strong>
					                    	<input value="${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO_SM']}" type="hidden" name="ad_ordtm_labrr_sum_ho_${year}" id="ad_ordtm_labrr_sum_ho_${year}" />
					                    </td>
					                    <td>
					                    	<strong id="ordtm_labrr_avg_ho_${year}">${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO']}</strong>
					                    	<input value="${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO']}" type="hidden" name="ad_ordtm_labrr_avg_ho_${year}" id="ad_ordtm_labrr_avg_ho_${year}" />
					                    </td>
					                </tr>
					                </c:if>
					        		</c:forEach>                
					            </tbody>
					        </table>
					    </div>
					    
					    <!--//table2-->
					    <div class="mgt12">
					        <table cellpadding="0" cellspacing="0" class="table_form finance_table" summary="제출서류" >
					            <caption>
					            년도별제출서류
					            </caption>
					            <colgroup>
					            <col style="width:13%" />
					            <col style="width:*" />
					            </colgroup>
					            <tbody>
					                <tr>
					                    <th scope="row"><label for="t4_info6">제출서류</label></th>
					                    <td>월별 원천징수이행상황신고서 원본1부</td>
					                </tr>
					                <c:forEach var="n" begin="0" end="3">
					        		<c:set var="year" value="${lastYear-n}" />
					        		<c:if test="${year<=2013}" >
					        		<tr>
					                    <th scope="row"><label> ${year}년</label></th>
					                    <td colspan="4">
					                    <c:set var="reqstFileRF" value="${applyEntInfo['reqstFile'][year.toString()]}" />
										<input <c:if test="${!empty reqstFileRF['RF0']}">disabled</c:if> name="file_ho_rf0_${year}" type="file" id="file_ho_rf0_${year}" style="width:500px;" title="파일첨부" />
										<c:if test="${!empty reqstFileRF['RF0']}">
										<div id="file_show_ho_rf0_${year}">
											<input type="hidden" id="ad_file_ho_rf0_${year}" name="ad_file_ho_rf0_${year}" value="${reqstFileRF['RF0']['FILE_SEQ']}" />
											<a href="#none" onclick="delAttFile('${reqstFileRF['RF0']['FILE_SEQ']}','ho_rf0_${year}')"><img src="<c:url value="/images/ucm/icon_del.png" />" /> </a>
											<a href="#none" onclick="downAttFile('${reqstFileRF['RF0']['FILE_SEQ']}')">${reqstFileRF['RF0']['LOCAL_NM']} </a>
										</div>
										</c:if>
					                 	</td>
					                </tr>
					        		</c:if>
					        		</c:forEach>
					            </tbody>
					        </table>
					    </div>
					</div>
                       </c:if>
                   </div>
                   <!-- 4.상시근로자수// -->
                   </c:if>
                   
                   <c:if test="${(!empty applyEntInfo['applyMaster'] && applyEntInfo['applyMaster']['EXCPT_TRGET_AT'] eq 'Y' || !empty param.ad_excpt_trget_at && param.ad_excpt_trget_at eq 'Y')}">
                   <!--//5.중소기업유예확인정보-->
                   <%-- <div class="request_tbl">
                       <div class="title_zone">
                           <h4>중소기업유예확인정보
                            <a href="#none" class="btn_t_open" id="btn_excpt_close"><img src="<c:url value="/images/ic/btn_t_close.png" />" alt="닫기" /></a>
                            <a href="#none" class="btn_t_open" id="btn_excpt_open"><img src="<c:url value="/images/ic/btn_t_open.png" />" alt="열기" /></a>
                          	</h4>
                       </div>
                       <div class="con" id="div_excpt_con">
                           <div class="write mb30">
                               <table class="table_form">
                                   <caption>
                                   중소기업유예확인정보
                                   </caption>
                                   <colgroup>
                                   <col style="width:*" />
                                   <col style="width:*" />
                                   </colgroup>
                                   <tbody>
                                       <tr>
                                           <th scope="row" class="point" colspan="2"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 제출서류 </th>
                                           <td colspan="3">중소기업유예확인서 1부</td>
                                       </tr>
                                       <tr>
                                           <th scope="row" class="point" colspan="2"><label for="file_ho_rf5"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 파일첨부</label></th>
                                           <td colspan="3">
                                           	<c:set var="reqstFileRF" value="${applyEntInfo['reqstFile'][lastYear.toString()]}" />                                            	
                                           	<input required <c:if test="${!empty reqstFileRF['RF5']}">disabled</c:if> name="file_ho_rf5" type="file" id="file_ho_rf5" style="width:100%;" title="파일첨부" />
                                           	<c:if test="${!empty reqstFileRF['RF5']}">
                                           	<div id="file_show_ho_rf5">
                                           		<input type="hidden" id="ad_file_ho_rf5" name="ad_file_ho_rf5" value="${reqstFileRF['RF5']['FILE_SEQ']}" />
                                            	<a href="#none" onclick="delAttFile('${reqstFileRF['RF5']['FILE_SEQ']}','ho_rf5')"><img src="<c:url value="/images/ucm/icon_del.png" />" alt="삭제하기" /> </a>
                                            	<a href="#none" onclick="downAttFile('${reqstFileRF['RF5']['FILE_SEQ']}')">${reqstFileRF['RF5']['LOCAL_NM']} </a>
                                           	</div>
                                           	</c:if>                                            	
                                           </td>
                                       </tr>
                                   </tbody>
                               </table>
                           </div>
                       </div>
                   </div> --%>
                   <!--5.중소기업유예확인정보//-->
                   </c:if>
               </div>
               
               <!-- //관계기업추가 버튼 -->
               <div class="btn_bl2 dot1" id="div_add_rcpy"> 
               	<a class="relay_comBtn" href="#none" id="btn_add_rcpy"><span>관계기업추가</span></a> 
               </div>
               <!-- 관계기업추가 버튼// -->
          
               
               <c:if test="${loadDataYn eq 'Y'}">
               <c:forEach var="relateEntInfo" items="${relateEntInfos}">
               <c:set var="reqstFileRelate" value="${relateEntInfo['reqstFileRelate']}" />
               <!--////////////////////////////////////관계기업추가-삭제////////////////////////////////////-->
			<div class="tbl_add">				
			    <!--//삭제버튼-->
			    <div class="btn_bl3"> <a class="relay_comBtn" href="#none" onclick="delRcpy(this);"><span>관계기업삭제</span></a> </div>
			    <!--삭제버튼//-->
			    <!--//1.기업정보-->
			    <c:set var="reqstRcpyListRelate" value="${relateEntInfo['reqstRcpyListRelate']}" />
			    <c:set var="addRcpyId" value="${reqstRcpyListRelate['SN']}" />
			    <input type="hidden" name="addRcpyId" value="${addRcpyId}" />
			    <div class="request_tbl">
			        <div class="write">
			            <table class="table_form02">
			                <caption>
			                관계기업정보
			                </caption>
			                <colgroup>
			                <col style="width:172px" />
			  				<col style="width:273px" />
			  				<col style="width:173px" />
			  				<col style="width:272px" />
			                </colgroup>
			                <tbody>
			                    <tr>
			                        <td colspan="4" class="pr0 tbl_tline">
			                        	<div class="fr btn_inner"  style="width:150px">
			                        		 <a href="#none" id="btn_load_dart_ent_${addRcpyId}" <c:if test="${reqstRcpyListRelate['CPR_REGIST_SE'] eq 'F'}">style="display:none"</c:if> class="form_blBtn" onclick="loadDartEntList('${addRcpyId}')" >
			                        			<span>Dart데이터 불러오기</span>
			                        		</a>
			                        	</div>
			                        </td>
			                    </tr>
			                    <tr>
			                        <th scope="row">
			                        	<img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 관계기업구분
			                        	<a href="#none" class="btn_code rcpy_div_dec"><img src="<c:url value="/images2/sub/help_btn.png" />" alt="?" /></a>
			                        </th>
			                        <td>
			                        	<ap:code id="ad_rcpy_div_${addRcpyId}" grpCd="49" type="select" defaultLabel="" selectedCd="${reqstRcpyListRelate['RCPY_DIV']}" />
			                        </td>
			                        
			                        <th scope="row"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 지분율</th>
			                        <td>
			                        	<input required value="${reqstRcpyListRelate['QOTA_RT']}" name="ad_qota_tr_${addRcpyId}" type="text" id="ad_qota_tr_${addRcpyId}" class="text qota_rt max100" style="width:85px;" title="지분율" />
			                        	%
			                       	</td>
			                    </tr>  
			                    <tr>
			                        <th scope="row"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 기업명</th>                        
			                        <td><input required maxlength="255" value="${reqstRcpyListRelate['ENTRPRS_NM']}" name="ad_entrprs_nm_${addRcpyId}" type="text" id="ad_entrprs_nm_${addRcpyId}" class="text" style="width:191px;" title="기업명" /></td>
			                        <th scope="row" class="point"><label for="file_ho_rf2"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" />법인등록구분</label><img src="<c:url value="/images2/sub/help_btn.png" />" class="reqstRcpy_jurir_divide" alt="?" style="float:right; margin-right:5px" /></th>
			                        
			                        <td>
			                        	<select required name="ad_cpr_regist_se_${addRcpyId}" class="select_box" id="ad_cpr_regist_se_${addRcpyId}" style="width:61px;" onchange="changedCprSe('${addRcpyId}','${lastYear}');">
			                        		<option value="">선택</option>
			                                <option value="L" <c:if test="${reqstRcpyListRelate['CPR_REGIST_SE'] eq 'L'}">selected</c:if> >국내</option>
			                                <option value="F" <c:if test="${reqstRcpyListRelate['CPR_REGIST_SE'] eq 'F'}">selected</c:if> >해외</option>
			                            </select>
			                            &nbsp;통화
			                            <a href="#none" class="btn_code crncy_cod_dec"><img src="<c:url value="/images2/sub/help_btn.png" />" alt="?" style="margin-top:2px;"/></a>
			                         	<select name="ad_crncy_code_${addRcpyId}" class="select_box" id="ad_crncy_code_${addRcpyId}" onchange="changedCrnCyCode('${addRcpyId}','${lastYear}');" >
											<option value="">-선택-</option>
											<c:forEach items="${crncy_code}" var="item" varStatus="status">
												<c:if test="${item.code ne 'KRW'}">
													<option value="${item.code}" <c:if test="${item.code eq reqstRcpyListRelate['CRNCY_CODE'] }">selected</c:if> >${item.codeNm }</option>
												</c:if>
											</c:forEach>
										</select>
			                            <!-- <ap:code id="ad_crncy_code_${addRcpyId}" grpCd="48" type="select" defaultLabel="" selectedCd="${reqstRcpyListRelate['CRNCY_CODE']}" onchange="changedCrnCyCode('${addRcpyId}','${lastYear}');" />
			                        	-->
			                        </td>
			                    </tr>
			                    <tr>
			                        <th scope="row"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" />대표자명</th>                        
			                        <td colspan="3">
			                        	<input required maxlength="255" value="${reqstRcpyListRelate['RPRSNTV_NM']}"  name="ad_r_rprsntv_nm_ho_${addRcpyId}" type="text" id="ad_r_rprsntv_nm_ho_${addRcpyId}" class="text" style="width:100%;" title="대표자명" />
			                        </td>
			                    </tr>
			                    <tr>
			                        <th scope="row">
			                        	<label for="ad_jurirno_first_${addRcpyId}"> 법인등록번호</label>
			                        </th>
			                        <td>
			                        <input value="${reqstRcpyListRelate['JURIRNO_FIRST']}" name="ad_jurirno_first_${addRcpyId}" type="text" id="ad_jurirno_first_${addRcpyId}" class="text numeric6" style="width:82px;" title="법인등록번호앞자리" <c:if test="${reqstRcpyListRelate['CPR_REGIST_SE'] eq 'F'}">readonly</c:if> />
			                        -
			                        <input value="${reqstRcpyListRelate['JURIRNO_LAST']}" name="ad_jurirno_last_${addRcpyId}" type="text" id="ad_jurirno_last_${addRcpyId}" class="text numeric7" style="width:84px;" title="법인등록번호뒷자리" <c:if test="${reqstRcpyListRelate['CPR_REGIST_SE'] eq 'F'}">readonly</c:if> />
			                        </td>
			                        <th scope="row">사업자등록번호</th>
			                        <td>
			                        	<input value="${reqstRcpyListRelate['BIZRNO_FIRST']}" name="ad_bizrno_first_${addRcpyId}" type="text" id="ad_bizrno_first_${addRcpyId}" class="text numeric3" style="width:60px;" title="사업자등록번호앞자리" <c:if test="${reqstRcpyListRelate['CPR_REGIST_SE'] eq 'F'}">readonly</c:if> />
			                            -
			                            <input value="${reqstRcpyListRelate['BIZRNO_MIDDLE']}" name="ad_bizrno_middle_${addRcpyId}" type="text" id="ad_bizrno_middle_${addRcpyId}" class="text numeric2" style="width:40px;" title="사업자등록번호가운데자리" <c:if test="${reqstRcpyListRelate['CPR_REGIST_SE'] eq 'F'}">readonly</c:if> />
			                            -
			                            <input value="${reqstRcpyListRelate['BIZRNO_LAST']}" name="ad_bizrno_last_${addRcpyId}" type="text" id="ad_bizrno_last_${addRcpyId}" class="text numeric5" style="width:60px;" title="사업자등록번호뒷자리" <c:if test="${reqstRcpyListRelate['CPR_REGIST_SE'] eq 'F'}">readonly</c:if> />
			                        </td>
			                    </tr>      
			                    <tr> 
			                    <!-- 
			                        <th scope="row">
			                        	<img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" name="img_dnRequiredMark_${addRcpyId}" <c:if test="${reqstRcpyListRelate['CPR_REGIST_SE'] eq 'F'}">style="display:none"</c:if> /> 표준산업분류코드
			                            <a href="#none" class="induty_cod_dec"><img src="<c:url value="/images/ic/btn_code.png" />" alt="?" /></a>				                           
			                        </th>
			                        <td>
			                        	<input required maxlength="5" value="${reqstRcpyListRelate['MN_INDUTY_CODE']}" name="ad_mn_induty_code_${addRcpyId}" type="text" id="ad_mn_induty_code_${addRcpyId}" class="text" style="width:55px;" title="표준산업분류코드" <c:if test="${reqstRcpyListRelate['CPR_REGIST_SE'] eq 'F'}">readonly</c:if> />
			                            <div class="btn_inner"><a href="#none" class="btn_in_gray btn_search_code"><span>분류코드조회</span></a></div>
			                        </td>
			                    -->
			                        <th scope="row">
			                        	<label>주업종명</label>
			                        </th>
                       				<td colspan="3">
                        				<select name="largeGroup_${addRcpyId}" class="select_box" id="largeGroup_${addRcpyId}" style="width:250px" onchange="changelargeGroupSelectId(this.value, '${addRcpyId}');">
											<option value="noSelect">-선택-</option>
											<c:forEach items="${largeGroup}" var="item" varStatus="status">
												<option value="${item.lclasCd }" <c:if test="${reqstRcpyListRelate['lclasCd'] eq item.lclasCd}">selected</c:if> >${item.lclasCd} : ${item.koreanNm }</option>
											</c:forEach>
										</select> 
										<select name="smallGroup_${addRcpyId}" class="select_box" id="smallGroup_${addRcpyId}" style="width:250px"> 
											<c:forEach items="${reqstRcpyListRelate['small']}" var="item" varStatus="status">
												<option value="${item.indutyCode}:${item.koreanNm}" <c:if test="${item.indutyCode eq fn:substring(reqstRcpyListRelate['MN_INDUTY_CODE'],0,2)}">selected</c:if> >${item.indutyCode} ${item.koreanNm} </option>
											</c:forEach>
										</select>
                        			</td>
			                    </tr>
			                    <tr>
			                        <th scope="row">
			                        	<label>결산월</label>
			                        </th>
			                        <td>
			                        	<select required id="ad_stacnt_mt_${addRcpyId}" class="select_box" name="ad_stacnt_mt_${addRcpyId}" class ="stacnt_mt" style="width:75px;">
			                        	<c:forTokens items="${MONTHS_TOKEN }" delims="," var="month">
											<option value="${month}" <c:if test="${reqstRcpyListRelate['ACCT_MT'] eq month }">selected</c:if> >${month}</option>										
										</c:forTokens>				                        	
			                            </select>
			                            월                                            
			                        <th scope="row"><label><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" name="img_dnRequiredMark_${addRcpyId}" <c:if test="${reqstRcpyListRelate['CPR_REGIST_SE'] eq 'F'}">style="display:none"</c:if> /> 설립년월</label></th>
			                        <td>
			                        	<input <c:if test="${reqstRcpyListRelate['CPR_REGIST_SE'] ne 'F'}">required</c:if> value="${reqstRcpyListRelate['FOND_DE']}" type="text" name="ad_fond_de_${addRcpyId}" id="ad_fond_de_${addRcpyId}" class="fond_de yyyy-MM-dd" title="날짜선택" />
			                        </td>
			                    </tr>
			                    <tr>
			                        <th scope="row">특이사항</th>
			                        <td colspan="3">
				                        <input maxlength="200" value="${reqstRcpyListRelate['PARTCLR_MATTER']}" name="ad_partclr_matter_${addRcpyId}" type="text" id="ad_partclr_matter_${addRcpyId}" class="text" style="width:100%;" title="특이사항" placeholder="법인 신규설립이나 분할?합병 등의 특이 사항을 입력해 주세요"/>
			                        </td>
			                    </tr>
							</tbody>
						</table>
					</div>
			    </div>
				<!--1.기업정보//-->
			    
			     <!--//2.주주명부-->
			    <c:set var="reqstInfoQotaPosesnRelate" value="${relateEntInfo['reqstInfoQotaPosesnRelate']}" />
                   <div class="request_tbl">
                       <div class="write">
                           <table class="table_form02">
                               <caption>
                               주주명부
                               </caption>
                               <colgroup>
                               <col style="width:16%" />
                               <col style="width:14%" />
                               <col style="width:23%" />
                               <col style="width:17%" />
                               <col style="width:*" />
                               </colgroup>
                               <tbody>
                                   <tr>
                                       <th rowspan="3" scope="row">지분 소유비율<br/>
                                           (최대3개 입력)</th>
                                       <th scope="row"><label for="ad_shrholdr_nm1_${addRcpyId}"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 주주명</label></th>
                                       <td><input required maxlength="255" value="${reqstInfoQotaPosesnRelate['SHRHOLDR_NM1']}" name="ad_shrholdr_nm1_${addRcpyId}" type="text" id="ad_shrholdr_nm1_${addRcpyId}" class="text" style="width:98%;" title="주주명" /></td>
                                       <th scope="row"><label for="ad_qota_rt1_${addRcpyId}"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 지분소유비율</label></th>
                                       <td><input required value="${reqstInfoQotaPosesnRelate['QOTA_RT1']}" name="ad_qota_rt1_${addRcpyId}" type="text" id="ad_qota_rt1_${addRcpyId}" class="text qota_rt max100" style="width:100%;" title="지분소유비율" /></td>
                                   </tr>
                                   <tr>
                                       <th scope="row"><label for="ad_shrholdr_nm2_${addRcpyId}"> 주주명</label></th>
                                       <td><input  maxlength="255" value="${reqstInfoQotaPosesnRelate['SHRHOLDR_NM2']}" name="ad_shrholdr_nm2_${addRcpyId}" type="text" id="ad_shrholdr_nm2_${addRcpyId}" class="text" style="width:98%;" title="주주명" /></td>
                                       <th scope="row"><label for="ad_qota_rt2_${addRcpyId}"> 지분소유비율</label></th>
                                       <td><input value="${reqstInfoQotaPosesnRelate['QOTA_RT2']}" name="ad_qota_rt2_${addRcpyId}" type="text" id="ad_qota_rt2_${addRcpyId}" class="text qota_rt max100" style="width:100%;" title="지분소유비율" /></td>
                                   </tr>
                                   <tr>
                                       <th scope="row"><label for="ad_shrholdr_nm3_${addRcpyId}"> 주주명</label></th>
                                       <td><input  maxlength="255" value="${reqstInfoQotaPosesnRelate['SHRHOLDR_NM3']}" name="ad_shrholdr_nm3_${addRcpyId}" type="text" id="ad_shrholdr_nm3_${addRcpyId}" class="text" style="width:98%;" title="주주명" /></td>
                                       <th scope="row"><label for="ad_qota_rt3_${addRcpyId}"> 지분소유비율</label></th>
                                       <td><input value="${reqstInfoQotaPosesnRelate['QOTA_RT3']}" name="ad_qota_rt3_${addRcpyId}" type="text" id="ad_qota_rt3_${addRcpyId}" class="text qota_rt max100" style="width:100%;" title="지분소유비율" /></td>
                                   </tr>
                                   <tr>
                                       <th scope="row" colspan="2"><label> 제출서류</label>
                                           1)</th>
                                       <td colspan="3">주주명부 1부 (법인에 한함)<br />
                                        <c:set var="reqstFileRF" value="${reqstFileRelate[lastYear.toString()]}" />
                                        <input <c:if test="${!empty reqstFileRF['RF2']}">disabled</c:if> name="file_${addRcpyId}_rf2_${lastYear}" type="file" id="file_${addRcpyId}_rf2_${lastYear}" style="width:100%;" title="파일첨부" />
                                        <c:if test="${!empty reqstFileRF['RF2']}">
                                        <div id="file_show_${addRcpyId}_rf2_${lastYear}">
                                        <input type="hidden" id="ad_file_${addRcpyId}_rf2_${lastYear}" name="ad_file_${addRcpyId}_rf2_${lastYear}" value="${reqstFileRF['RF2']['FILE_SEQ']}" />
                                        <a href="#none" onclick="delAttFile('${reqstFileRF['RF2']['FILE_SEQ']}','${addRcpyId}_rf2_${lastYear}')"><img src="<c:url value="/images/ucm/icon_del.png" />" /> </a>
                                        <a href="#none" onclick="downAttFile('${reqstFileRF['RF2']['FILE_SEQ']}')">${reqstFileRF['RF2']['LOCAL_NM']} </a>
                                        </div>
										</c:if>
                                       </td>
                                   </tr>
                               </tbody>
                           </table>
                       </div>
                   </div>
                   <!--2.주주명부//-->		    
			    
			    
			    <!--//2.매출액-->
			    <c:set var="reqstFnnrDataRelate" value="${relateEntInfo['reqstFnnrDataRelate']}" />
			    <div class="request_tbl">
			        <div class="table_hrz_add">
			            <table class="table_form02 finance_table" >
			                <caption>
			                매출액
			                </caption>
			                <colgroup>
			                <col style="width:100px" />
			                <col style="width:110px" />
			                <col style="width:110px" />
			                <col style="width:110px" />
			                <col style="width:110px" />
			                <col style="width:110px" />
			                </colgroup>
			                <tbody>
			                    <tr>
			                        <th rowspan="2" scope="row">매출액<img src="<c:url value="/images2/sub/help_btn.png" />" class="reqstRcpy_amount_unit" alt="?" style="float:right; margin-right:5px" /></th>
			                        
			                        <c:forEach var="n" begin="0" end="2">
			        				<c:set var="year" value="${lastYear-n}" />
			                        <th scope="row">
			                        	<label> ${year}년</label>
			                        	<a href="#none" class="form_blBtn" onclick="getEntFnnr('${addRcpyId}','${year}')" >Dart자료
			                        		<%-- <img src="<c:url value="/images/ic/btn_dart.png" />" alt="dart자료" /> --%>		
			                        	</a>
			                        </th>
			                        </c:forEach>
			                        <th scope="row"><label> 합계</label></th>                       
			                        <th scope="row"><label> 3년 평균</label></th>
			                   </tr>
			                   <tr>
			                   		<c:forEach var="n" begin="0" end="2">
									<c:set var="year" value="${lastYear-n}" />
			                        <td>
			                        	<c:if test="${reqstRcpyListRelate['CRNCY_CODE'] == 'KRW'}">
			                        	<fmt:parseNumber var="fmt_amount_unit_addRcpy" integerOnly="true" type="number" value="${reqstFnnrDataRelate[year.toString()]['AMOUNT_UNIT']}" />
			                        	<!-- (원) -->
			                        	<select name="ad_amount_unit_${addRcpyId}_${year}" class="select_box" id="ad_amount_unit_${addRcpyId}_${year}" style="width:102px; " class="amount-unit-${addRcpyId}">
			                        		<c:choose>
	                                           	<c:when test="${fmt_amount_unit_addRcpy == 1000000}">
	                                           		<option value="1" <c:if test="${fmt_amount_unit_addRcpy == 1}">selected="selected"</c:if>>원</option>
	                                           		<option value="1000000" <c:if test="${fmt_amount_unit_addRcpy == 1000000}">selected="selected"</c:if>>백만원</option>
	                                           	</c:when>
	                                           	<c:otherwise>
	                                           		<option value="1" <c:if test="${fmt_amount_unit_addRcpy == 1}">selected="selected"</c:if>>원</option>
	                                           	</c:otherwise>
                                           	</c:choose>
                                       	</select>
                                       	</c:if>
                                       	<c:if test="${reqstRcpyListRelate['CRNCY_CODE'] != 'KRW'}">
                                       	<select name="ad_amount_unit_${addRcpyId}_${year}" class="select_box" id="ad_amount_unit_${addRcpyId}_${year}" style="width:102px; " class="amount-unit-${addRcpyId}">                                           	                                           	
                                           	<option value="1">${reqstRcpyListRelate['CRNCY_CODE']}</option>
                                       	</select>
                                       	</c:if>
			                        	<input value="${reqstFnnrDataRelate[year.toString()]['SELNG_AM']}" name="ad_selng_am_${addRcpyId}_${year}" class="-numeric18 selAmR" type="text" id="ad_selng_am_${addRcpyId}_${year}"  style="width:90px;" title="매출액입력" />
			                        </td>
			                        </c:forEach>                        
			                      
			                        <td>
			                        	<strong id="y3sum_selng_am_${addRcpyId}">${reqstFnnrDataRelate[lastYear.toString()]['Y3SUM_SELNG_AM']}</strong>
			                        	<input value="${reqstFnnrDataRelate[lastYear.toString()]['Y3SUM_SELNG_AM']}" name="ad_y3sum_selng_am_${addRcpyId}" type="hidden" id="ad_y3sum_selng_am_${addRcpyId}" class="-numeric18" style="width:50px;" title="합계" />
			                        </td>
			                        <td>
			                        	<strong id="y3avg_selng_am_${addRcpyId}">${reqstFnnrDataRelate[lastYear.toString()]['Y3AVG_SELNG_AM']}</strong>
			                        	<input value="${reqstFnnrDataRelate[lastYear.toString()]['Y3AVG_SELNG_AM']}" name="ad_y3avg_selng_am_${addRcpyId}" type="hidden" id="ad_y3avg_selng_am_${addRcpyId}" class="-numeric18" style="width:50px;" title="3년평균매출액" />
			                        </td>
			                    </tr>
			                </tbody>
			            </table>
			        </div>
			    </div>
			    <!--3.매출액//-->

				<!--//4.재무정보-->					
			    <div class="request_tbl">
			        <div class="table_hrz_add">
			            <!--//table1-->
			            <table class="table_form02 finance_table" >
			                <caption>
			                년도별재무정보
			                </caption>
			                <colgroup>
			                <col style="width:194px" />
			                <col style="width:110px" />
			                <col style="width:110px" />
			                <col style="width:110px" />
			                <col style="width:110px" />
			                <col style="width:110px" />
			                </colgroup>
			                <thead>
			                <th></th>
			                    <th class="tac">자본금</th>
			                    <th class="tac">자본잉여금</th>
			                    <th class="tac">자본총계</th>
			                    <th class="tac">자산총액</th>
			                    <th class="tac">상시근로자수</th>
			                    </thead>
			                <tbody>
			                    <tr>
			                        <th scope="row">
			                        	<label><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> ${lastYear} 
			                        	<a href="#none" class="form_blBtn" onclick="getEntFnnr('${addRcpyId}','${lastYear}')">
			                        	Dart자료
			                        		<%-- <img src="<c:url value="/images/ic/btn_dart.png" />" alt="dart자료" /> --%>
			                        	</a>
			                        	</label>
			                        </th>
			                        <td>
			                        	<input value="${reqstFnnrDataRelate[lastYear.toString()]['CAPL']}" <c:if test="${reqstRcpyListRelate['CPR_REGIST_SE'] eq 'F'}">disabled</c:if> class="-numeric18" name="ad_capl_${addRcpyId}_${lastYear}" type="text" id="ad_capl_${addRcpyId}_${lastYear}" style="width:55px;" title="${lastYear}년자본금" />
			                            <span id="span_capl_${addRcpyId}_${lastYear}">
			                            	<c:choose>
											<c:when test="${reqstRcpyListRelate['CRNCY_CODE'] eq 'KRW'}">
											(원)
											</c:when>       
											<c:otherwise>
											(${reqstRcpyListRelate['CRNCY_CODE']})
											</c:otherwise>
											</c:choose>
			                            </span>
			                        </td>
			                        <td>
			                        	<input value="${reqstFnnrDataRelate[lastYear.toString()]['CLPL']}" <c:if test="${reqstRcpyListRelate['CPR_REGIST_SE'] eq 'F'}">disabled</c:if> class="-numeric18" name="ad_clpl_${addRcpyId}_${lastYear}" type="text" id="ad_clpl_${addRcpyId}_${lastYear}" style="width:55px;" title="${lastYear}년자본잉여금" />
			                            <span id="span_clpl_${addRcpyId}_${lastYear}">
			                            	<c:choose>
											<c:when test="${reqstRcpyListRelate['CRNCY_CODE'] eq 'KRW'}">
											(원)
											</c:when>       
											<c:otherwise>
											(${reqstRcpyListRelate['CRNCY_CODE']})
											</c:otherwise>
											</c:choose>
			                            </span>
			                        </td>
			                        <td>
			                        	<input value="${reqstFnnrDataRelate[lastYear.toString()]['CAPL_SM']}" <c:if test="${reqstRcpyListRelate['CPR_REGIST_SE'] eq 'F'}">disabled</c:if> class="-numeric18" name="ad_capl_sm_${addRcpyId}_${lastYear}" type="text" id="ad_capl_sm_${addRcpyId}_${lastYear}" style="width:55px;" title="${lastYear}년자본총계" />
			                            <span id="span_capl_sm_${addRcpyId}_${lastYear}">
			                            	<c:choose>
											<c:when test="${reqstRcpyListRelate['CRNCY_CODE'] eq 'KRW'}">
											(원)
											</c:when>       
											<c:otherwise>
											(${reqstRcpyListRelate['CRNCY_CODE']})
											</c:otherwise>
											</c:choose>
			                            </span>
			                        </td>
			                        <td>
			                        	<input value="${reqstFnnrDataRelate[lastYear.toString()]['ASSETS_TOTAMT']}" class="-numeric18" name="ad_assets_totamt_${addRcpyId}_${lastYear}" type="text" id="ad_assets_totamt_${addRcpyId}_${lastYear}" style="width:55px;" title="${lastYear}년자산총액" />
			                            <span id="span_assets_totamt_${addRcpyId}_${lastYear}">
			                            	<c:choose>
											<c:when test="${reqstRcpyListRelate['CRNCY_CODE'] eq 'KRW'}">
											(원)
											</c:when>       
											<c:otherwise>
											(${reqstRcpyListRelate['CRNCY_CODE']})
											</c:otherwise>
											</c:choose>
			                            </span>
			                        </td>
			                        <td>
			                        	<input <c:if test="${lastYear>2013 or (reqstRcpyListRelate['CPR_REGIST_SE'] eq 'F')}">disabled</c:if> value="${reqstFnnrDataRelate[lastYear.toString()]['ORDTM_LABRR_CO']}" class="numeric10" name="ad_ordtm_labrr_co_${addRcpyId}_${lastYear}" type="text" id="ad_ordtm_labrr_co_${addRcpyId}_${lastYear}" style="width:55px;" title="${lastYear}년상시근로자수" />
			                            (명)
			                        </td>
			                    </tr>
			                </tbody>
			            </table>
			        </div>        
			        <div>
			           <!--//table2-->
				        <table class="table_form02">
				            <caption>
				                년도별제출서류
				            </caption>
				            <colgroup>
				               <col style="width:99px" />
			                    <col style="width:95px" />
			                    <col style="width:*" />
				            </colgroup>
							<tbody>
								<tr>
			                        <th scope="row">제출서류2)</th>
			                        <th >국내법인</th>
									<td>감사보고서 또는 표준재무제표증명원<br />
										<span style="color:#2763ba;">전자공시대상기업(dart.fss.or.kr)은 감사보고서 제출 생략 가능</span>
									</td>
			                    </tr>
			                    <c:forEach var="n" begin="0" end="3">
			        			<c:set var="year" value="${lastYear-n}" />
								<tr>
			                        <th scope="row"  colspan="2"><label> ${year}년</label></th>
			                        <td>				                        	
			                    		<c:set var="reqstFileRF" value="${reqstFileRelate[year.toString()]}" />                                            	
                                        <input <c:if test="${!empty reqstFileRF['RF1']}">disabled</c:if> name="file_${addRcpyId}_rf1_${year}" type="file" id="file_${addRcpyId}_rf1_${year}" style="width:100%;" title="파일첨부" />
                                        <c:if test="${!empty reqstFileRF['RF1']}">
                                        <div id="file_show_${addRcpyId}_rf1_${year}">
                                        <input type="hidden" id="ad_file_${addRcpyId}_rf1_${year}" name="ad_file_${addRcpyId}_rf1_${year}" value="${reqstFileRF['RF1']['FILE_SEQ']}" />
                                        <a href="#none" onclick="delAttFile('${reqstFileRF['RF1']['FILE_SEQ']}','${addRcpyId}_rf1_${year}')"><img src="<c:url value="/images/ucm/icon_del.png" />" /> </a>
                                        <a href="#none" onclick="downAttFile('${reqstFileRF['RF1']['FILE_SEQ']}')">${reqstFileRF['RF1']['LOCAL_NM']} </a>
                                        </div>
                                        </c:if>
			                    	</td>
				                </tr>
				                </c:forEach>	               
				            </tbody>
				        </table>
					</div>
			    </div>
			    <!--4.재무정보//-->		
			    		    
			    <!--//5.상시근로자수-->
			    <c:if test="${(!empty applyEntInfo['resnManageS'] && applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS3 || applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS4 || applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS5)}">
			    <c:set var="reqstOrdtmLabrrRelate" value="${relateEntInfo['reqstOrdtmLabrrRelate']}" />
			    <c:if test="${lastYear <= 2013}">				    
			    <div class="request_tbl">
			        <div class="table_hrz_add">
			            <!--//table1-->
			            <table class="table_form02" >
			                <caption>
			                년도별재무정보
			                </caption>
			                <colgroup>
			                <col style="width:80px" />
				            <col style="width:39px" />
				            <col style="width:39px" />
				            <col style="width:39px" />
				            <col style="width:39px" />
				            <col style="width:39px" />
				            <col style="width:39px" />
				            <col style="width:39px" />
				            <col style="width:39px" />
				            <col style="width:39px" />
				            <col style="width:39px" />
				            <col style="width:39px" />
				            <col style="width:39px" />            
				            <col style="width:*" />
				            <col style="width:56px" />
			                </colgroup>
			                <thead>
			                <th></th>
			                    <th>1</th>
			                    <th>2</th>
			                    <th>3</th>
			                    <th>4</th>
			                    <th>5</th>
			                    <th>6</th>
			                    <th>7</th>
			                    <th>8</th>
			                    <th>9</th>
			                    <th>10</th>
			                    <th>11</th>
			                    <th>12</th>
			                    <th>합계</th>
			                    <th>연평균</th>
			                <tbody>
			                    <tr>
			                        <th scope="row"><label>${lastYear}</label></th>
			                        <td><input value="${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO1']}"  name="ad_ordtm_labrr_co1_${addRcpyId}_${lastYear}" class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co1_${addRcpyId}_${lastYear}" style="width:25px;" title="${lastYear}년1월상시근로자수" /></td>
			                        <td><input value="${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO2']}"  name="ad_ordtm_labrr_co2_${addRcpyId}_${lastYear}" class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co2_${addRcpyId}_${lastYear}" style="width:25px;" title="${lastYear}년2월상시근로자수" /></td>
			                        <td><input value="${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO3']}"  name="ad_ordtm_labrr_co3_${addRcpyId}_${lastYear}" class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co3_${addRcpyId}_${lastYear}" style="width:25px;" title="${lastYear}년3월상시근로자수" /></td>
			                        <td><input value="${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO4']}"  name="ad_ordtm_labrr_co4_${addRcpyId}_${lastYear}" class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co4_${addRcpyId}_${lastYear}" style="width:25px;" title="${lastYear}년4월상시근로자수" /></td>
			                        <td><input value="${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO5']}"  name="ad_ordtm_labrr_co5_${addRcpyId}_${lastYear}" class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co5_${addRcpyId}_${lastYear}" style="width:25px;" title="${lastYear}년5월상시근로자수" /></td>
			                        <td><input value="${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO6']}"  name="ad_ordtm_labrr_co6_${addRcpyId}_${lastYear}" class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co6_${addRcpyId}_${lastYear}" style="width:25px;" title="${lastYear}년6월상시근로자수" /></td>
			                        <td><input value="${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO7']}"  name="ad_ordtm_labrr_co7_${addRcpyId}_${lastYear}" class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co7_${addRcpyId}_${lastYear}" style="width:25px;" title="${lastYear}년7월상시근로자수" /></td>
			                        <td><input value="${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO8']}"  name="ad_ordtm_labrr_co8_${addRcpyId}_${lastYear}" class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co8_${addRcpyId}_${lastYear}" style="width:25px;" title="${lastYear}년8월상시근로자수" /></td>
			                        <td><input value="${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO9']}"  name="ad_ordtm_labrr_co9_${addRcpyId}_${lastYear}" class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co9_${addRcpyId}_${lastYear}" style="width:25px;" title="${lastYear}년9월상시근로자수" /></td>
			                        <td><input value="${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO10']}" name="ad_ordtm_labrr_co10_${addRcpyId}_${lastYear}" class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co10_${addRcpyId}_${lastYear}" style="width:25px;" title="${lastYear}년10월상시근로자수" /></td>
			                        <td><input value="${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO11']}" name="ad_ordtm_labrr_co11_${addRcpyId}_${lastYear}" class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co11_${addRcpyId}_${lastYear}" style="width:25px;" title="${lastYear}년11월상시근로자수" /></td>
			                        <td><input value="${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO12']}" name="ad_ordtm_labrr_co12_${addRcpyId}_${lastYear}" class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co12_${addRcpyId}_${lastYear}" style="width:25px;" title="${lastYear}년12월상시근로자수" /></td>
			                        <td>
			                        	<strong id="ordtm_labrr_sum_${addRcpyId}_${lastYear}">${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO_SM']}</strong>
										<input value="${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO_SM']}" type="hidden" name="ad_ordtm_labrr_sum_${addRcpyId}_${lastYear}" id="ad_ordtm_labrr_sum_${addRcpyId}_${lastYear}" />
									</td>
			                        <td>
			                        	<strong id="ordtm_labrr_avg_${addRcpyId}_${lastYear}">${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO']}</strong>
			                        	<input value="${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO']}" type="hidden" name="ad_ordtm_labrr_avg_${addRcpyId}_${lastYear}" id="ad_ordtm_labrr_avg_${addRcpyId}_${lastYear}" />
			                        </td>
			                    </tr>
			                    <tr>
			                        <th scope="row"><label for="add_t4_info2">제출서류3)</label></th>
			                        <td colspan="13" class="tal">월별 원천징수이행상황신고서 원본1부 </td>
			                    </tr>
			                    <tr>
			                        <th scope="row"><label>${lastYear}년</label></th>
			                        <td colspan="13" class="tal">
			                        	<c:set var="reqstFileRF" value="${reqstFileRelate[lastYear.toString()]}" />                                            	
                                        <input <c:if test="${!empty reqstFileRF['RF0']}">disabled</c:if> name="file_${addRcpyId}_rf0_${lastYear}" type="file" id="file_${addRcpyId}_rf0_${lastYear}" style="width:100%;" title="파일첨부" />
                                        <c:if test="${!empty reqstFileRF['RF0']}">
                                        <div id="file_show_${addRcpyId}_rf0_${lastYear}">
                                        <input type="hidden" id="ad_file_${addRcpyId}_rf0_${lastYear}" name="ad_file_${addRcpyId}_rf0_${lastYear}" value="${reqstFileRF['RF0']['FILE_SEQ']}" />
                                        <a href="#none" onclick="delAttFile('${reqstFileRF['RF0']['FILE_SEQ']}','${addRcpyId}_rf0_${lastYear}')"><img src="<c:url value="/images/ucm/icon_del.png" />" /> </a>
                                        <a href="#none" onclick="downAttFile('${reqstFileRF['RF0']['FILE_SEQ']}')">${reqstFileRF['RF0']['LOCAL_NM']} </a>
                                        </div>
                                        </c:if>
			                        </td>
			                    </tr>
			                </tbody>
			            </table>
			            <!-- 유의사항-->
			            <h4 class="mgt30">[신청서 작성시 유의사항]</h4>
			            <div class="care">
			                <ul>
			                    <li>지분소유비율<br />
			                        - 30%이상 지분을 갖는 주주만 입력합니다.</li>
			                    <li>서류작성<br />
			                        1.직전 사업연도 월별 원천징수이행상황신고서(매월 근로자 확인이 가능한 서류)<br />
			                        - 사본은 세무사 등 적격자의 원본대조필 확인<br />
			                        2.직전 3개 사업연도 감사보고서(재무제표 또는 세법이 정하는 회계장부 1부)<br />
			                        - 사본은 세무사 등 적격자의 원본대조필 확인<br />
			                        3.주주명부 1부(법인에 한함)<br />
			                        - 사본은 원본대조필 확인<br />
			                        4.첨부가능한 파일 확장자<br />
			                        - hwp, doc, docx, pdf, jpg, jpge, zip </li>
			                </ul>
			            </div>
			        </div>
			        <!--//table2-->
			        <div></div>
			    </div>				    
			    </c:if>
			    </c:if>
			    <!--5.상시근로자수//-->
	</div>
	<!-- </div>
	</div> -->
	<!-- </div> -->
			<!-- </div> -->
			<!--////////////////////////////////////관계기업추가-삭제////////////////////////////////////-->
			</c:forEach>
               </c:if>
                
                <!-- //저장 버튼 -->
                <div class="btn_bl dot1">
                <c:choose>
                <c:when test="${param.ad_admin_new_at eq 'Y'}"> <!-- 20171212 추가 -->
					<a class="btn_page_blue" href="#none" id="btn_save_request"><span>신청</span></a>
				</c:when>
                <c:when test="${isAdminOrBiz eq 'Y'}">
					<a class="btn_page_blue" href="#none" id="btn_save_temp"><span>저장</span></a>
				</c:when>				
				<c:otherwise>
					<c:choose>
					<c:when test="${(!empty applyEntInfo['resnManageS'] && applyEntInfo['resnManageS']['SE_CODE'] eq RESN_SE_CODE_PS3)}">
						<a  href="#none" id="btn_save_temp" ><span>신청</span></a>
					</c:when>       
					<c:otherwise>
						<a class="wht" href="#none" id="btn_save_temp"><span>임시저장</span></a>
	                	<a class="blu" href="#none" id="btn_save_self"><span>자가진단</span></a> 
	                	<a href="#none" id="btn_save_request"><span>신청</span></a>
					</c:otherwise>
					</c:choose>					 
				</c:otherwise>
				</c:choose>                	
                </div>
                <!-- 저장 버튼// -->
                </div>
                </div>
                </div>
</div>

<c:choose>
<c:when test="${param.ad_win_type eq 'pop'}">
	</div>
</div>
</c:when>       
<c:otherwise>
			</div>
		</div>
		</div>
	</div>
</div>
</c:otherwise>
</c:choose>

<!--content//-->
</form>

<!-- loading -->
<div style="display:none">
	<div class="loading" id="loading">
		<div class="inner">
			<div class="box">
		    	<p>
		    		<span id="load_msg">공시시스템 'Dart'의 기업정보를 가져오고 있습니다. 잠시만 기다려주십시오.</span>
		    		<br />
					시스템 상태에 따라 최대 10분 정도 소요될 수 있습니다.
				</p>
				<span><img src="<c:url value="/images/etc/loading_bar.gif" />" width="323" height="39" alt="loading" /></span>
			</div>
		</div>
	</div>
</div>
</body>
</html>