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
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,colorbox,mask,multifile,jBox,flot,multiselect" />
<ap:jsTag type="tech" items="acm,ucm,msg,util,cs,my,pc" />

<script type="text/javascript">

var labrrDatas = ${labrrDatas};		//근로자수
var selngDatas = ${selngDatas};		//매출액
var caplDatas = ${caplDatas};		//자본금
var assetsDatas = ${assetsDatas};	//자산총액

$(document).ready(function(){
	
	<c:if test="${message != null}">
		jsMsgBox(null, "info","${message}");				
	</c:if>
	
	if(${dataMap.LAYOUT_TY == 1}) {
		$("#entprsIntro1").css("display","block");
	}
	else if(${dataMap.LAYOUT_TY == 2}) {
		$("#entprsIntro2").css("display","block");
	}
	else if(${dataMap.LAYOUT_TY == 3}) {
		$("#entprsIntro3").css("display","block");	
	}
	
  	$("#searchChartrVal").multipleSelect({
  		selectAll: true,
		placeholder : "-- 선택 --",
		selectAllText : "전체선택",
    	allSelected : "전체선택",
    	minimumCountSelected: 5,
    	filter: true	
	});
	
  	$("#searchChartrVal").attr("multiple", "multiple");
 
	// 사업자등록번호 찾기
	$("#popFindBizrNo").click(function() {
		
		$.colorbox({
			title : "사업자등록번호 찾기",
			href : "PGMY0030.do?df_method_nm=getEntUserList",		
			width : "90%",
			height : "90%",
			overlayClose : false,
			escKey : false,
			iframe : true
		});
	});
	
	// MASK
	// 전화번호
	$('#ad_tel_middle').mask('0000');
	$('#ad_tel_last').mask('0000');
	// 팩스번호
	$('#ad_fax_middle').mask('0000');
	$('#ad_fax_last').mask('0000');
	//설립일자
	$("#ad_fond_de").mask('00000000');
	$("#ad_lst_de").mask('00000000');	

	// 닫기버튼
	$("#btn_close").click(function(){
		parent.$.colorbox.close();
	});
	
	// 저장버튼
	$("#btn_save").click(function(){
		var searchChartrVal= $("#searchChartrVal").val();
		
		$("#ad_searchChartrVal").val(searchChartrVal);
		$("#df_method_nm").val("insertCmpnyIntrcn");
		$("#dataForm").submit();
	});
	
	$('#btn_search_zip').click(function() {
    	var pop = window.open("<c:url value='${SEARCH_ZIP_URL}' />","searchZip","width=570,height=420, scrollbars=yes, resizable=yes");		
    });

	// 유효성 검사
	$("#dataForm").validate({
		rules : {  				
				ad_rprsntv_nm : {
					maxlength: 50	
				},
				ad_charger_email : {
    				email: true    				
				},
			},
		submitHandler: function(form) {
			// 전화번호 조립
			var ad_tel_first 	= $('#ad_tel_first').val();
			var ad_tel_middle 	= $('#ad_tel_middle').val();
			var ad_tel_last 	= $('#ad_tel_last').val();
			var ad_tel			= ""+ad_tel_first+ad_tel_middle+ad_tel_last;
			$('#ad_telno').val(ad_tel);
			
			// 팩스번호 조립
			var ad_fax_first 	= $('#ad_fax_first').val();
			var ad_fax_middle 	= $('#ad_fax_middle').val();
			var ad_fax_last 	= $('#ad_fax_last').val();
			var ad_fax			= ""+ad_fax_first+ad_fax_middle+ad_fax_last;
			$('#ad_fxnum').val(ad_fax);
			
			form.submit();
		}
	});
	
		$('#multipartFile').MultiFile({
			accept: 'jpg|gif',
			max: '1',
			list: '#photo_file_view',
			STRING: {
				remove: '<img src="<c:url value="/images/ucm/icon_del.png" />" alt="x" />',
				denied: '$ext 는(은) 업로드 할 수 없는 파일확장자입니다!',
				duplicate: '$file 는(은) 이미 추가된 파일입니다!'
			},
			onFileRemove: function(element, value, master_element){
			},
			afterFileRemove: function(element, value, master_element){			
			},
			onFileAppend: function(element, value, master_element){			
			},
			afterFileAppend: function(element, value, master_element){			
			},
			onFileSelect: function(element, value, master_element){		
			},
			afterFileSelect: function(element, value, master_element){
				
				var $fileList = $("#photo_file_view").find(".MultiFile-label");
				var $remove_btn;
				for(var i=0; i<$fileList.length-1; i++) {
					$remove_btn = $fileList.eq(i).find(".MultiFile-remove");
					
					if($remove_btn.length > 0) {					
						$fileList.eq(i).find(".MultiFile-remove").click();	
					}else{					
						$fileList.eq(i).remove();
					}				
				}
				
				$("#df_method_nm").val("processAtchPhoto");
				
				$("#dataForm").ajaxSubmit({
					url      : "PGMY0030.do",
					type     : "post",
					dataType : "text",
					async    : false,
					contentType: "multipart/form-data",
					success  : function(response) {
						try {
							if(response) {
								var srcStr = "/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=" + response + "&number=" + Math.random();
								$("#img_photo").attr("src", srcStr);
							} else {
								jsErrorBox(Message.msg.processFail);
							}
						} catch (e) {
							jsSysErrorBox(response, e);
							return;
						}                            
					}
				});
				
			}
		});	

		$('#multipartFile1').MultiFile({
			accept: 'jpg|gif',
			max: '1',
			list: '#photo_file_view1',
			STRING: {
				remove: '<img src="<c:url value="/images/ucm/icon_del.png" />" alt="x" />',
				denied: '$ext 는(은) 업로드 할 수 없는 파일확장자입니다!',
				duplicate: '$file 는(은) 이미 추가된 파일입니다!'
			},
			onFileRemove: function(element, value, master_element){
			},
			afterFileRemove: function(element, value, master_element){			
			},
			onFileAppend: function(element, value, master_element){			
			},
			afterFileAppend: function(element, value, master_element){			
			},
			onFileSelect: function(element, value, master_element){		
			},
			afterFileSelect: function(element, value, master_element){
				
				$("#ad_sn").val('1');
				$("#multipart_sn").val('1');
				var $fileList = $("#photo_file_view1").find(".MultiFile-label");
				var $remove_btn;
				for(var i=0; i<$fileList.length-1; i++) {
					$remove_btn = $fileList.eq(i).find(".MultiFile-remove");
					
					if($remove_btn.length > 0) {					
						$fileList.eq(i).find(".MultiFile-remove").click();	
					}else{					
						$fileList.eq(i).remove();
					}				
				}
				
				$("#df_method_nm").val("processLayoutImageUpload");
				
				$("#dataForm").ajaxSubmit({
					url      : "PGMY0030.do",
					type     : "post",
					dataType : "text",
					async    : false,
					contentType: "multipart/form-data",
					success  : function(response) {
						try {
							if(response) {
								var srcStr = "/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=" + response + "&number=" + Math.random();
//								$("#img_photo").attr("src", srcStr);
							} else {
								jsErrorBox(Message.msg.processFail);
							}
						} catch (e) {
							jsSysErrorBox(response, e);
							return;
						}                            
					}
				});
			}
		});
		
		$('#multipartFile2').MultiFile({
			accept: 'jpg|gif',
			max: '1',
			list: '#photo_file_view2',
			STRING: {
				remove: '<img src="<c:url value="/images/ucm/icon_del.png" />" alt="x" />',
				denied: '$ext 는(은) 업로드 할 수 없는 파일확장자입니다!',
				duplicate: '$file 는(은) 이미 추가된 파일입니다!'
			},
			onFileRemove: function(element, value, master_element){
			},
			afterFileRemove: function(element, value, master_element){			
			},
			onFileAppend: function(element, value, master_element){			
			},
			afterFileAppend: function(element, value, master_element){			
			},
			onFileSelect: function(element, value, master_element){		
			},
			afterFileSelect: function(element, value, master_element){
				
				$("#ad_sn").val('2');
				$("#multipart_sn").val('2');
				var $fileList = $("#photo_file_view2").find(".MultiFile-label");
				var $remove_btn;
				for(var i=0; i<$fileList.length-1; i++) {
					$remove_btn = $fileList.eq(i).find(".MultiFile-remove");
					
					if($remove_btn.length > 0) {					
						$fileList.eq(i).find(".MultiFile-remove").click();	
					}else{					
						$fileList.eq(i).remove();
					}				
				}
				
				$("#df_method_nm").val("processLayoutImageUpload");
				
				$("#dataForm").ajaxSubmit({
					url      : "PGMY0030.do",
					type     : "post",
					dataType : "text",
					async    : false,
					contentType: "multipart/form-data",
					success  : function(response) {
						try {
							if(response) {
								var srcStr = "/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=" + response + "&number=" + Math.random();
//								$("#img_photo").attr("src", srcStr);
							} else {
								jsErrorBox(Message.msg.processFail);
							}
						} catch (e) {
							jsSysErrorBox(response, e);
							return;
						}                            
					}
				});
			}
		});
		
		$('#multipartFile3').MultiFile({
			accept: 'jpg|gif',
			max: '1',
			list: '#photo_file_view3',
			STRING: {
				remove: '<img src="<c:url value="/images/ucm/icon_del.png" />" alt="x" />',
				denied: '$ext 는(은) 업로드 할 수 없는 파일확장자입니다!',
				duplicate: '$file 는(은) 이미 추가된 파일입니다!'
			},
			onFileRemove: function(element, value, master_element){
			},
			afterFileRemove: function(element, value, master_element){			
			},
			onFileAppend: function(element, value, master_element){			
			},
			afterFileAppend: function(element, value, master_element){			
			},
			onFileSelect: function(element, value, master_element){		
			},
			afterFileSelect: function(element, value, master_element){
				
				$("#ad_sn").val('1');
				$("#multipart_sn").val('3');
				var $fileList = $("#photo_file_view3").find(".MultiFile-label");
				var $remove_btn;
				for(var i=0; i<$fileList.length-1; i++) {
					$remove_btn = $fileList.eq(i).find(".MultiFile-remove");
					
					if($remove_btn.length > 0) {					
						$fileList.eq(i).find(".MultiFile-remove").click();	
					}else{					
						$fileList.eq(i).remove();
					}				
				}
				
				$("#df_method_nm").val("processLayoutImageUpload");
				
				$("#dataForm").ajaxSubmit({
					url      : "PGMY0030.do",
					type     : "post",
					dataType : "text",
					async    : false,
					contentType: "multipart/form-data",
					success  : function(response) {
						try {
							if(response) {
								var srcStr = "/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=" + response + "&number=" + Math.random();
//								$("#img_photo").attr("src", srcStr);
							} else {
								jsErrorBox(Message.msg.processFail);
							}
						} catch (e) {
							jsSysErrorBox(response, e);
							return;
						}                            
					}
				});
			}
		});
		$('#multipartFile4').MultiFile({
			accept: 'jpg|gif',
			max: '1',
			list: '#photo_file_view4',
			STRING: {
				remove: '<img src="<c:url value="/images/ucm/icon_del.png" />" alt="x" />',
				denied: '$ext 는(은) 업로드 할 수 없는 파일확장자입니다!',
				duplicate: '$file 는(은) 이미 추가된 파일입니다!'
			},
			onFileRemove: function(element, value, master_element){
			},
			afterFileRemove: function(element, value, master_element){			
			},
			onFileAppend: function(element, value, master_element){			
			},
			afterFileAppend: function(element, value, master_element){			
			},
			onFileSelect: function(element, value, master_element){		
			},
			afterFileSelect: function(element, value, master_element){
				
				$("#ad_sn").val('2');
				$("#multipart_sn").val('4');
				var $fileList = $("#photo_file_view4").find(".MultiFile-label");
				var $remove_btn;
				for(var i=0; i<$fileList.length-1; i++) {
					$remove_btn = $fileList.eq(i).find(".MultiFile-remove");
					
					if($remove_btn.length > 0) {					
						$fileList.eq(i).find(".MultiFile-remove").click();	
					}else{					
						$fileList.eq(i).remove();
					}				
				}
				
				$("#df_method_nm").val("processLayoutImageUpload");
				
				$("#dataForm").ajaxSubmit({
					url      : "PGMY0030.do",
					type     : "post",
					dataType : "text",
					async    : false,
					contentType: "multipart/form-data",
					success  : function(response) {
						try {
							if(response) {
								var srcStr = "/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=" + response + "&number=" + Math.random();
//								$("#img_photo").attr("src", srcStr);
							} else {
								jsErrorBox(Message.msg.processFail);
							}
						} catch (e) {
							jsSysErrorBox(response, e);
							return;
						}                            
					}
				});
			}
		});
		
		$('#multipartFile5').MultiFile({
			accept: 'jpg|gif',
			max: '1',
			list: '#photo_file_view5',
			STRING: {
				remove: '<img src="<c:url value="/images/ucm/icon_del.png" />" alt="x" />',
				denied: '$ext 는(은) 업로드 할 수 없는 파일확장자입니다!',
				duplicate: '$file 는(은) 이미 추가된 파일입니다!'
			},
			onFileRemove: function(element, value, master_element){
			},
			afterFileRemove: function(element, value, master_element){			
			},
			onFileAppend: function(element, value, master_element){			
			},
			afterFileAppend: function(element, value, master_element){			
			},
			onFileSelect: function(element, value, master_element){		
			},
			afterFileSelect: function(element, value, master_element){
				
				$("#ad_sn").val('1');
				$("#multipart_sn").val('5');
				var $fileList = $("#photo_file_view5").find(".MultiFile-label");
				var $remove_btn;
				for(var i=0; i<$fileList.length-1; i++) {
					$remove_btn = $fileList.eq(i).find(".MultiFile-remove");
					
					if($remove_btn.length > 0) {					
						$fileList.eq(i).find(".MultiFile-remove").click();	
					}else{					
						$fileList.eq(i).remove();
					}				
				}
				
				$("#df_method_nm").val("processLayoutImageUpload");
				
				$("#dataForm").ajaxSubmit({
					url      : "PGMY0030.do",
					type     : "post",
					dataType : "text",
					async    : false,
					contentType: "multipart/form-data",
					success  : function(response) {
						try {
							if(response) {
								var srcStr = "/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=" + response + "&number=" + Math.random();
//								$("#img_photo").attr("src", srcStr);
							} else {
								jsErrorBox(Message.msg.processFail);
							}
						} catch (e) {
							jsSysErrorBox(response, e);
							return;
						}                            
					}
				});
			}
		});
		
		$('#multipartFile6').MultiFile({
			accept: 'jpg|gif',
			max: '1',
			list: '#photo_file_view6',
			STRING: {
				remove: '<img src="<c:url value="/images/ucm/icon_del.png" />" alt="x" />',
				denied: '$ext 는(은) 업로드 할 수 없는 파일확장자입니다!',
				duplicate: '$file 는(은) 이미 추가된 파일입니다!'
			},
			onFileRemove: function(element, value, master_element){
			},
			afterFileRemove: function(element, value, master_element){			
			},
			onFileAppend: function(element, value, master_element){			
			},
			afterFileAppend: function(element, value, master_element){			
			},
			onFileSelect: function(element, value, master_element){		
			},
			afterFileSelect: function(element, value, master_element){
				
				$("#ad_sn").val('2');
				$("#multipart_sn").val('6');
				var $fileList = $("#photo_file_view6").find(".MultiFile-label");
				var $remove_btn;
				for(var i=0; i<$fileList.length-1; i++) {
					$remove_btn = $fileList.eq(i).find(".MultiFile-remove");
					
					if($remove_btn.length > 0) {					
						$fileList.eq(i).find(".MultiFile-remove").click();	
					}else{					
						$fileList.eq(i).remove();
					}				
				}
				
				$("#df_method_nm").val("processLayoutImageUpload");
				
				$("#dataForm").ajaxSubmit({
					url      : "PGMY0030.do",
					type     : "post",
					dataType : "text",
					async    : false,
					contentType: "multipart/form-data",
					success  : function(response) {
						try {
							if(response) {
								var srcStr = "/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=" + response + "&number=" + Math.random();
//								$("#img_photo").attr("src", srcStr);
							} else {
								jsErrorBox(Message.msg.processFail);
							}
						} catch (e) {
							jsSysErrorBox(response, e);
							return;
						}                            
					}
				});
			}
		});
		$('#multipartFile7').MultiFile({
			accept: 'jpg|gif',
			max: '1',
			list: '#photo_file_view7',
			STRING: {
				remove: '<img src="<c:url value="/images/ucm/icon_del.png" />" alt="x" />',
				denied: '$ext 는(은) 업로드 할 수 없는 파일확장자입니다!',
				duplicate: '$file 는(은) 이미 추가된 파일입니다!'
			},
			onFileRemove: function(element, value, master_element){
			},
			afterFileRemove: function(element, value, master_element){			
			},
			onFileAppend: function(element, value, master_element){			
			},
			afterFileAppend: function(element, value, master_element){			
			},
			onFileSelect: function(element, value, master_element){		
			},
			afterFileSelect: function(element, value, master_element){
				
				$("#ad_sn").val('3');
				$("#multipart_sn").val('7');
				var $fileList = $("#photo_file_view7").find(".MultiFile-label");
				var $remove_btn;
				for(var i=0; i<$fileList.length-1; i++) {
					$remove_btn = $fileList.eq(i).find(".MultiFile-remove");
					
					if($remove_btn.length > 0) {					
						$fileList.eq(i).find(".MultiFile-remove").click();	
					}else{					
						$fileList.eq(i).remove();
					}				
				}
				
				$("#df_method_nm").val("processLayoutImageUpload");
				
				$("#dataForm").ajaxSubmit({
					url      : "PGMY0030.do",
					type     : "post",
					dataType : "text",
					async    : false,
					contentType: "multipart/form-data",
					success  : function(response) {
						try {
							if(response) {
								var srcStr = "/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=" + response + "&number=" + Math.random();
//								$("#img_photo").attr("src", srcStr);
							} else {
								jsErrorBox(Message.msg.processFail);
							}
						} catch (e) {
							jsSysErrorBox(response, e);
							return;
						}                            
					}
				});
			}
		});
		$('#multipartFile8').MultiFile({
			accept: 'jpg|gif',
			max: '1',
			list: '#photo_file_view8',
			STRING: {
				remove: '<img src="<c:url value="/images/ucm/icon_del.png" />" alt="x" />',
				denied: '$ext 는(은) 업로드 할 수 없는 파일확장자입니다!',
				duplicate: '$file 는(은) 이미 추가된 파일입니다!'
			},
			onFileRemove: function(element, value, master_element){
			},
			afterFileRemove: function(element, value, master_element){
			},
			onFileAppend: function(element, value, master_element){
			},
			afterFileAppend: function(element, value, master_element){
			},
			onFileSelect: function(element, value, master_element){
			},
			afterFileSelect: function(element, value, master_element){

				$("#ad_sn").val('4');
				$("#multipart_sn").val('8');
				
				var $fileList = $("#photo_file_view8").find(".MultiFile-label");
				var $remove_btn;
				for(var i=0; i<$fileList.length-1; i++) {
					$remove_btn = $fileList.eq(i).find(".MultiFile-remove");
					
					if($remove_btn.length > 0) {					
						$fileList.eq(i).find(".MultiFile-remove").click();	
					}else{					
						$fileList.eq(i).remove();
					}				
				}
				
				$("#df_method_nm").val("processLayoutImageUpload");
				
				$("#dataForm").ajaxSubmit({
					url      : "PGMY0030.do",
					type     : "post",
					dataType : "text",
					async    : false,
					contentType: "multipart/form-data",
					success  : function(response) {
						try {
							if(response) {
								var srcStr = "/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=" + response + "&number=" + Math.random();
//								$("#img_photo").attr("src", srcStr);
							} else {
								jsErrorBox(Message.msg.processFail);
							}
						} catch (e) {
							jsSysErrorBox(response, e);
							return;
						}                            
					}
				});
			}
		});
	
	setDescView();
	setMainIndex();
	// 주요 통계 지표 툴팁 
	$("#placeholder").UseTooltip();
});

// 기업소개 타입
function changeEntprsIntroType(type) {
	
	var html;
	switch (type) {
	case 1 :
		$("#entprsIntro2").css("display","none");
		$("#entprsIntro3").css("display","none");
		$("#entprsIntro1").css("display","inline-block");
		break;
	case 2 :
		$("#entprsIntro1").css("display","none");
		$("#entprsIntro3").css("display","none");
		$("#entprsIntro2").css("display","inline-block");
		break;
	case 3 :
		$("#entprsIntro1").css("display","none");
		$("#entprsIntro2").css("display","none");
		$("#entprsIntro3").css("display","inline-block");
		break;
	default :
		html = "";
	}
	
	$("#entprsIntro").html(html);
}

//[?]표시 설명
function setDescView(){
	/* $("#tool_dt").jBox('Tooltip', {
		content: '선택 시 기업소개페이지에서 해당 내용이 출력됩니다.'
	});
	
	$("#tool_ix").jBox('Tooltip', {
		content: '선택 시 기업소개페이지에서 해당 내용이 출력됩니다.<br />'
					+'직전사업년도부터 과거 3년간의 매출액, 자본금, 자산총액, R&D금액, 상시근로자수 추이를 게시합니다.<br />'
					+'(단, 본 사이트에서 데이터 확인이 가능한 기업에 한합니다.)'
	}); */
	
	$("#tool_dt").jBox('Tooltip', {
		content: '선택 시 기업소개페이지에서 해당 내용이 출력됩니다.<br />'
					+'직전사업년도부터 과거 3년간의 매출액, 자본금, 자산총액, R&D금액, 상시근로자수 추이를 게시합니다.<br />'
					+'(단, 본 사이트에서 데이터 확인이 가능한 기업에 한합니다.)'
	});
}

//주요지표현황
function setMainIndex(){
	
	var data = [];
	
	// chart
    var options = {
    	lines: {
    		show: true
    	},
    	points: {
    		show: true
    	}, 
    	legend : {
			show : false
		},   		
    	xaxis: {
    		tickDecimals: 0,
    		tickSize: 1    		
    	}, 
    	valueLabels : {
			show : true
		},
    	grid: {
    		hoverable: true, 
                  clickable: false, 
                  mouseActiveRadius: 30,
			borderWidth : 0.2              
    	},
    	yaxes: [
	                {
				
			  },
	                { position: "right",
			    axisLabel: "명"
			  }
	      ] 
    };
	
    var series1 = {
    	"label": "매출액",
        "data": selngDatas,
        color : "#014379"
    };
    var series2 = {
    	"label": "자본금",
        "data": caplDatas,
        color : "#015ca5"
    };
    var series3 = {
    	"label": "자산총액",
        "data": assetsDatas,
        color : "#1c8bd6"
    };
    var series4 = {
    	"label": "근로자수",
        "data": labrrDatas,
        yaxis: 2,
        color : "#00bfd0"
    };
    
    data.push(series1);
    data.push(series2);
    data.push(series3);
    data.push(series4);
	
    $.plot("#placeholder", data, options);    
    
}

$.fn.UseTooltip = function () {
    var previousPoint = null;
     
    $(this).bind("plothover", function (event, pos, item) {         
        if (item) {
            if (previousPoint != item.dataIndex) {
                previousPoint = item.dataIndex;
 
                $("#tooltip").remove();
                 
                var x = item.datapoint[0];
                var y = item.datapoint[1];                
                 
                showTooltip(item.pageX, item.pageY,
                  x + "<br/>" + "<strong>" + y + "</strong> (" + 
                  item.series.label + ")");
            }
        }
        else {
            $("#tooltip").remove();
            previousPoint = null;
        }
    });
}

//툴팁
function showTooltip(x, y, contents) {
	$('<div id="tooltip">' + contents + '</div>').css({
		position : 'absolute',
		display : 'none',
		top : y + 5,
		left : x + 20,
		border : '1px solid #4572A7',
		padding : '2px',
		size : '10',
		opacity : 0.80
	}).appendTo("body").fadeIn(200);
}

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
	
	//var zipArr = Util.str.split(zipNo,'-');	
	//$('#ad_hedofc_zip').val(zipArr[0] + zipArr[1]);	
	var zipArr = zipNo.replace("-", "");	// 혹시 모를 '-'처리
	$('#ad_hedofc_zip').val(zipArr);
	$('#ad_hedofc_adres').val(roadAddrPart1 + " " + addrDetail);	
}

//첨부파일 다운로드
function downAttFile(fileSeq) {
	jsFiledownload("/PGCM0040.do","df_method_nm=updateFileDownBySeq&seq="+fileSeq);
}

//로고 첨부파일 삭제
function logoDelAttFile(fileSeq){
	
	jsMsgBox(null, "confirm", Message.msg.fileDeleteConfirm, function() {
		$("#ad_sn").val('0')
		
		$.ajax({
	        url      : "PGMY0030.do",
	        type     : "POST",
	        dataType : "json",
	        data     : {
	        			df_method_nm:"updateDelLogoFile"
	        			, file_seq:fileSeq
	        			, ad_bizrno:$("#ad_bizrno").val()
	        			, USER_NO:$("#USER_NO").val()
	        			, ad_sn:$("#ad_sn").val()
	        },
	        async    : false,
	        success  : function(response) {
	        	try {
	        		if(eval(response)) {
	        			jsMsgBox(null,'info',Message.msg.successDelete);	        			
	        			$("#photo_file_view").empty();
	        			$("#img_photo").attr("src", '<c:url value="/images/cs/no_logo.png"/>');
	                } else {
	                	jsMsgBox(null,'info',Message.msg.failDelete);
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
		
	});
}

//기업소개 첨부파일 삭제
function delAttFile(fileSeq, sn){
	
	jsMsgBox(null, "confirm", Message.msg.fileDeleteConfirm, function() {
		$("#ad_sn").val(sn)
		$.ajax({
	        url      : "PGMY0030.do",
	        type     : "POST",
	        dataType : "json",
	        data     : {
	        			df_method_nm:"updateDelLogoFile"
	        			, file_seq:fileSeq
	        			, ad_bizrno:$("#ad_bizrno").val()
	        			, USER_NO:$("#USER_NO").val()
	        			, ad_sn:$("#ad_sn").val()
	        },
	        async    : false,                
	        success  : function(response) {        	
	        	try {
	        		if(eval(response)) {
	        			jsMsgBox(null,'info',Message.msg.successDelete);
	        			$("#photo_file_view"+sn).empty();
//	        			$("#img_photo").attr("src", '<c:url value="/images/cs/photo.png"/>');
	                } else {
	                	jsMsgBox(null,'info',Message.msg.failDelete);
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
		
	});
}

</script>

</head>

<body>
<form></form>

<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" enctype="multipart/form-data" method="post">

<input type="hidden" id="ad_telno" name="ad_telno" />
<input type="hidden" id="ad_fxnum" name="ad_fxnum" />
<input type="hidden" id="USER_NO" name="USER_NO" value="${dataMap.USER_NO}" />
<input type="hidden" id="ad_searchChartrVal" name="ad_searchChartrVal"/>
<input type="hidden" id="ad_sn" name="ad_sn"/>
<input type="hidden" id="multipart_sn" name="multipart_sn"/>

<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/pagingParam.jsp" />  

<div class="view_zone">
    <table cellspacing="0" border="0" summary="채용정보 상세보기" class="table_view2">
        <caption>
        	채용정보 상세보기
        </caption>
        <colgroup>
        <col style="width:*" />
        <col style="width:*" />        
        <col style="width:*" />
        <col style="width:*" />
        <col style="width:*" />
        <col style="width:*" />
        <col style="width:*" />
        </colgroup>
        <tbody>
            <tr>
                <td colspan="4" rowspan="7" class="none">
                	<ul class="my_align">
                        <li class="my_width">
                        	<c:choose>
                        		<c:when test="${not empty dataMap.LOGO_FILE_SN }">
                        			<img src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${dataMap.LOGO_FILE_SN}" />" id="img_photo" alt="로고" width="100%" style="border:#666 solid 1px" />
                        		</c:when>
                        		<c:otherwise>
                        			<img src="<c:url value='/images/cs/no_logo.png' />" id="img_photo" alt="로고" width="100%" style="border:#666 solid 1px;" />
                        		</c:otherwise>
                        	</c:choose>
                        </li>
                        <br>
                        <li class="my_file_width">
                            <div class="btn_inner">                            
                            	<input type="file" id="multipartFile" name="multipartFile" title="파일찾아보기" width="100%" height="40%" />
                            	
                            	<div id="photo_file_view" >
                            	<c:if test="${not empty dataMap.LOGO_FILE_SN }" >
                               		<div class="MultiFile-label">
                                   	<a href="#none" onclick="logoDelAttFile('${dataMap.LOGO_FILE_SN}');"><img src="<c:url value='/images/ucm/icon_del.png' />" alt="삭제하기" /></a>
									<a href="#none" onclick="downAttFile('${dataMap.LOGO_FILE_SN}')">${dataMap.LOGO_FILE_NM} </a>
									</div>								
								</c:if>
								</div>         
                            </div>
                        </li>
                        <br>
                        <li class="mb10">
                        	<div>
                        		<input name="ad_hmpg" type="text" id="ad_hmpg" value="${dataMap.HMPG }" style="width:100%; margin-top:2px;" title="홈페이지주소" />
                        	</div>
                        </li>
                    </ul>
                </td>                
                <c:set var="showEntrprsNm" value="${dataMap.ENTRPRS_NM }" />
                <c:if test="${empty showEntrprsNm }">
                <c:set var="showEntrprsNm" value="${defltEntNm }" />
                </c:if>
                <th scope="col">사업자등록번호</th>
                <td colspan="4">
                	<input name="ad_bizrno" type="text" id="ad_bizrno" value="${BIZRNO}" style="width:180px;" title="사업자등록번호" readonly />
                	<div class="btn_inner">
						<a href="#none" class="btn_in_gray2"><span id="popFindBizrNo">기업 조회</span></a>
					</div>
					<input type="checkbox" name="recomend_entrprs_at" id="recomend_entrprs_at" <c:if test="${dataMap.RECOMEND_ENTRPRS_AT == 'Y' }"> checked</c:if>/><label for="recomend_entrprs_at">추천기업등록</label>
                </td>
                </td>
            </tr>
            <tr>
                <th scope="col">기업명</th>
                <td><input name="ad_entrprs_nm" type="text" id="ad_entrprs_nm" value="${showEntrprsNm }"  style="width:180px;" title="기업명" /></td>
                <th scope="col">대표자</th>
                <td><input name="ad_rprsntv_nm" type="text" id="ad_rprsntv_nm" value="${dataMap.RPRSNTV_NM }"  style="width:180px;" title="이름" /></td>
            </tr>
            <tr>
                <th scope="col">상장여부</th>
                <td>
                    <ap:code id="ad_lst_at" grpCd="28" type="select" selectedCd="${dataMap.LST_AT }" />
                </td>
                <th scope="col">기업형태</th>
                <td>
                	<ap:code id="ad_entrprs_stle" grpCd="29" type="select" selectedCd="${dataMap.ENTRPRS_STLE }" />
                </td>
            </tr>
            <tr>
                <th scope="col">기업인증</th>
                <td>
                	<ap:code id="ad_entrprs_crtfc" grpCd="30" type="select" selectedCd="${dataMap.ENTRPRS_CRTFC }" />
                </td>
                <th scope="col" rowspan="2">기업소개 공개여부</th>
                <td rowspan="2">
                	<input name="ad_entrprs_vw_at" type="radio" id="ad_entrprs_vw_at_1" value="Y" <c:if test="${dataMap.ENTRPRS_VW_AT == 'Y' }"> checked</c:if>/>
	                <label for="ad_entrprs_vw_at_1">공개</label>
	                <input name="ad_entrprs_vw_at" type="radio" id="ad_entrprs_vw_at_2" class="ml40" value="N" <c:if test="${dataMap.ENTRPRS_VW_AT != 'Y' }"> checked</c:if>/>
	                <label for="ad_entrprs_vw_at_2">비공개</label>
                </td>
            </tr>
            <tr>
            	<th scope="col">기업특성</th>
            	<td>
            		<select id="searchChartrVal" name="searchChartrVal" style="width:230px;">
							<option value="1"
								<c:forEach var="chartr" items="${chartr }">
									<c:if test="${chartr.CHARTR_CODE eq '1'}"> selected="selected"</c:if>
								</c:forEach>>기업소개</option>
							<option value="2"
								<c:forEach var="chartr" items="${chartr }">
									<c:if test="${chartr.CHARTR_CODE eq '2'}"> selected="selected"</c:if>
								</c:forEach>>월드클래스300</option>
							<option value="3"
								<c:forEach var="chartr" items="${chartr }">
									<c:if test="${chartr.CHARTR_CODE eq '3'}"> selected="selected"</c:if>
								</c:forEach>>ATC</option>
							<option value="4"
								<c:forEach var="chartr" items="${chartr }">
									<c:if test="${chartr.CHARTR_CODE eq '4'}"> selected="selected"</c:if>
								</c:forEach>>코스피</option>
							<option value="5"
								<c:forEach var="chartr" items="${chartr }">
									<c:if test="${chartr.CHARTR_CODE eq '5'}"> selected="selected"</c:if>
								</c:forEach>>코스닥</option>
		          	</select>
            	</td>
            </tr>
            <tr>
                <th scope="col">담당자이메일</th>
                <td colspan="4"><input name="ad_charger_email" type="text" id="ad_charger_email" value="${dataMap.CHARGER_EMAIL }" style="width:180px;" title="이메일" />
                </td>
            </tr>
            <tr>
                <th scope="col">전화번호</th>
                <td><select name="ad_tel_first" id="ad_tel_first" style="width:80px; ">
                        <c:forTokens items="${PHONE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
							<option value="${firstNum }" <c:if test="${dataMap.TELNO1 == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
						</c:forTokens>
                    </select>
                    ~
                    <input name="ad_tel_middle" type="text" id="ad_tel_middle" value="${dataMap.TELNO2 }" class="text" style= "width:80px;" title="전화번호중간번호" />
                    ~
                    <input name="ad_tel_last" type="text" id="ad_tel_last" value="${dataMap.TELNO3 }" class="text" style="width:80px;" title="전화번호마지막번호" /></td>
                <th scope="col">팩스번호</th>
                <td><select name="ad_fax_first" id="ad_fax_first" style="width:80px; ">
                      	<c:forTokens items="${PHONE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
							<option value="${firstNum }" <c:if test="${dataMap.FXNUM1 == firstNum }">selected="selected"</c:if> >${firstNum }</option>										
						</c:forTokens>
                    </select>
                    ~
                    <input name="ad_fax_middle" type="text" id="ad_fax_middle" value="${dataMap.FXNUM2 }" class="text" style="width:80px;" title="팩스중간번호" />
                    ~
                    <input name="ad_fax_last" type="text" id="ad_fax_last" value="${dataMap.FXNUM3 }" class="text" style="width:80px;" title="팩스마지막번호" /></td>
            </tr>
            <tr>
            	<th scope="tac" colspan="4" style="border-right: 1px solid #d8dfe3;">홈페이지 주소</th>
                <th scope="col">주소</th>
                <td colspan="4">
                	<input name="ad_hedofc_zip" type="text" id="ad_hedofc_zip" value="${dataMap.HEDOFC_ZIP }" readonly="readonly" style="width:118px;" title="우편번호" />
                    <!-- -
                    <input name="info8" type="text" id="info8_2" style="width:117px;" title="우편번호뒷자리" /> -->
                    <div class="btn_inner"><a href="#" class="btn_in_gray2" id="btn_search_zip"><span>우편번호 검색</span></a></div>
                    <br />
                    <input name="ad_hedofc_adres" type="text" id="ad_hedofc_adres" value="${dataMap.HEDOFC_ADRES }" style="width:398px; margin-top:5px;" title="주소상세" /></td>
            </tr>
            <!-- 
            <tr>
                <th scope="col">홈페이지 주소</th>
                <td colspan="5"  class="none" >
                	<input name="ad_hmpg" type="text" id="ad_hmpg" value="${dataMap.HMPG }" style="width:98%; margin-top:5px;" title="주소상세" />
                </td>
            </tr>
             -->
        </tbody>
    </table>
</div>

<div class="detail_zone">
	<div class="detail_left">
	    <h4 class="mb10"><label for="ad_dtl_vw_at">상세 정보 및 주요 지표 현황  보이기</label> 
	    	<img src="<c:url value = "/images/ucm/btn_code.png"/>" width="20" height="20" alt="?" id="tool_dt" />
        	<input type="checkbox" name="ad_dtl_vw_at" id="ad_dtl_vw_at" value="Y" <c:if test="${dataMap.DTL_VW_AT == 'Y' }">checked</c:if> />
    	</h4>
	    <table class="table_view2">
	        <caption>
	        채용정보 상세보기
	        </caption>
	        <colgroup>
	        <col style="width:30%" />
	        <col style="width:70%" />
	        </colgroup>
	        <tbody>
	            <tr>
	                <th scope="col">설립일자</th>
	                <td><input name="ad_fond_de" type="text" id="ad_fond_de" value="${dataMap.FOND_DE }" style="width:250px;" title="설립일자" /> 예) 20101201</td>
	            </tr>
	            <tr>
	                <th scope="col">상장일</th>
	                <td><input name="ad_lst_de" type="text" id="ad_lst_de" value="${dataMap.LST_DE }" style="width:250px;" title="상장일" /> 예) 20101201</td>
	            </tr>
	            <tr>
	                <th scope="col">업종</th>
	                <td><input name="ad_induty_nm" type="text" id="ad_induty_nm" value="${dataMap.INDUTY_NM }" style="width:350px;" title="업종" /></td>
	            </tr>
	            <tr>
	                <th scope="col">주생산품</th>
	                <td><input name="ad_main_product" type="text" id="ad_main_product" value="${dataMap.MAIN_PRODUCT }" style="width:350px;" title="주생산품" /></td>
	            </tr>
	        </tbody>
	    </table>
	</div>
	<div class="detail_right">
	    <%-- <h4 class="mb10"><label for="ad_ind_vw_at">주요 지표 현황  보이기</label>
	        <img src="<c:url value = "/images/ucm/btn_code.png" />" width="20" height="20" alt="?" id="tool_ix" />
	        <input type="checkbox" name="ad_ind_vw_at" id="ad_ind_vw_at" value="Y" <c:if test="${dataMap.IND_VW_AT == 'Y' }">checked</c:if> />
	    </h4> --%>
	    
	    <!-- <div style="width:100%; height:400px;" id="main_ix_sttu" class="ix-placeholder"></div> -->
	    <!-- <div id="placeholder" style="width:100%; height:300px;" class=""></div> -->	   
       <div id="placeholder" style="width:100%; height: 300px; margin-top:28px"></div>
       <div class="remark">
           <ul>
               <li class="remark1">매출액</li>
               <li class="remark2">자본금</li>
               <li class="remark3">자산총액</li>
               <li class="remark4">근로자수</li>
           </ul>
       </div>
	</div>
</div>

	<br>
	<div style="border: 1px solid #b3b3b3; width: 99%; margin-left: 5px; ">
		<table class="table_layout">
			<colgroup>
				<col style="width:35%" />
				<col style="width:35%" />
				<col style="width:*" />
			</colgroup>
			<tr>
				<th colspan=3>기업소개화면 Layout 선택</th>
			</tr>
			<tr>
				<td><input onclick = "changeEntprsIntroType(1);" name="ad_layout_ty" type="radio" id="ad_layout_ty_1" value="1" <c:if test="${dataMap.LAYOUT_TY == '1' }"> checked</c:if>/></td>
				<td><input onclick = "changeEntprsIntroType(2);" name="ad_layout_ty" type="radio" id="ad_layout_ty_2" class="ml40" value="2" <c:if test="${dataMap.LAYOUT_TY == '2' }"> checked</c:if>/></td>
				<td><input onclick = "changeEntprsIntroType(3);" name="ad_layout_ty" type="radio" id="ad_layout_ty_3" class="ml40" value="3" <c:if test="${dataMap.LAYOUT_TY == '3' }"> checked</c:if>/></td>
			</tr>
			<tr>
				<td><label for="ad_layout_ty_1"><img src="<c:url value = "/images/my/img_type1.png" />" width="60%"  /></label></td>
				<td><label for="ad_layout_ty_2"><img src="<c:url value = "/images/my/img_type2.png" />" width="60%"   /></label></td>
				<td><label for="ad_layout_ty_3"><img src="<c:url value = "/images/my/img_type3.png" />" width="70%"  /></label></td>
		</table>		
	</div>
	
	<div id="entprsIntro1" name="entprsIntro1" class="view_zone2 mt20" style="display: none;">
		<table class="table_view2">
			<colgroup>
        		<col style="width:30%" />
        		<col style="width:70%" />
        	</colgroup>
			<tr>
				<th scope="col">이미지영역1</th>
				<td> 
					<div class="btn_inner">                            
               			<input type="file" id="multipartFile1" name="multipartFile1" title="파일찾아보기" />
                        <div id="photo_file_view1" >
                        	<c:if test="${not empty layoutImageList[0].IMAGE_SN }" >
                        		<c:if test="${dataMap.LAYOUT_TY == '1' }">
         							<div class="MultiFile-label">
                 						<a href="#none" onclick="delAttFile('${layoutImageList[0].IMAGE_SN}', '1')"><img src="<c:url value='/images/ucm/icon_del.png' />" alt="삭제하기" /></a>
										<a href="#none" onclick="downAttFile('${layoutImageList[0].IMAGE_SN}')">${layoutImageList[0].IMAGE_NM} </a>
									</div>
								</c:if>
							</c:if>
						</div>								              	                           
           			</div>
				</td>
			</tr>
			<tr>
				<th scope="col">텍스트영역1</th>
				<td>                	
					<textarea name="ad_text_area1" id="ad_text_area1" rows="5" title="내용입력란"  style="width:98%;" ><c:if test="${dataMap.LAYOUT_TY == '1' }">${layoutTextList[0].TEXT }</c:if></textarea>
				</td>
			</tr>
			<tr>
				<th scope="col">이미지영역2</th>
				<td> 					
					<div class="btn_inner">                            
               			<input type="file" id="multipartFile2" name="multipartFile2" title="파일찾아보기" />
                        <div id="photo_file_view2" >
                        	<c:if test="${not empty layoutImageList[1].IMAGE_SN }" >
                        		<c:if test="${dataMap.LAYOUT_TY == '1' }">
         							<div class="MultiFile-label">
                 						<a href="#none" onclick="delAttFile('${layoutImageList[1].IMAGE_SN}', '2')"><img src="<c:url value='/images/ucm/icon_del.png' />" alt="삭제하기" /></a>
										<a href="#none" onclick="downAttFile('${layoutImageList[1].IMAGE_SN}')">${layoutImageList[1].IMAGE_NM} </a>
									</div>
								</c:if>								
							</c:if>
						</div>								              	                           
           			</div>
				</td>
			</tr>
			<tr>
				<th scope="col">텍스트영역2</th>
				<td>                	
					<textarea name="ad_text_area2" id="ad_text_area2" rows="5" title="내용입력란"  style="width:98%;" ><c:if test="${dataMap.LAYOUT_TY == '1' }">${layoutTextList[1].TEXT }</c:if></textarea>
				</td>

			</tr>
			<tr>
				<th scope="col">텍스트영역3</th>
				<td>                	
					<textarea name="ad_text_area3" id="ad_text_area3" rows="5" title="내용입력란"  style="width:98%;" ><c:if test="${dataMap.LAYOUT_TY == '1' }">${layoutTextList[2].TEXT }</c:if></textarea>
				</td>

			</tr>
		</table>
	</div>
	<div id="entprsIntro2" name="entprsIntro2" class="view_zone2 mt20" style="display: none;">
		<table class="table_view2">
			<colgroup>
        		<col style="width:30%" />
        		<col style="width:70%" />
        	</colgroup>
			<tr>
				<th scope="col">이미지영역1</th>
				<td>
					<div class="btn_inner">                            
               			<input type="file" id="multipartFile3" name="multipartFile3" title="파일찾아보기" />
                        <div id="photo_file_view3" >
                        	<c:if test="${not empty layoutImageList[0].IMAGE_SN }" >
                        		<c:if test="${dataMap.LAYOUT_TY == '2' }">
         							<div class="MultiFile-label">
                 						<a href="#none" onclick="delAttFile('${layoutImageList[0].IMAGE_SN}', '3')"><img src="<c:url value='/images/ucm/icon_del.png' />" alt="삭제하기" /></a>
										<a href="#none" onclick="downAttFile('${layoutImageList[0].IMAGE_SN}')">${layoutImageList[0].IMAGE_NM} </a>
									</div>
								</c:if>
							</c:if>
						</div>								              	                           
           			</div>
				</td>

			</tr>
			<tr>
				<th scope="col">텍스트영역1</th>
				<td>                	
					<textarea name="ad_text_area4" id="ad_text_area4" rows="5" title="내용입력란"  style="width:98%;" ><c:if test="${dataMap.LAYOUT_TY == '2' }">${layoutTextList[0].TEXT }</c:if></textarea>
				</td>
			</tr>
			<tr>
				<th scope="col">이미지영역2</th>
				<td> 
					<div class="btn_inner">                            
               			<input type="file" id="multipartFile4" name="multipartFile4" title="파일찾아보기" />
                        <div id="photo_file_view4" >
                        	<c:if test="${not empty layoutImageList[1].IMAGE_SN }" >
                        		<c:if test="${dataMap.LAYOUT_TY == '2' }">
         							<div class="MultiFile-label">
                 						<a href="#none" onclick="delAttFile('${layoutImageList[1].IMAGE_SN}', '4')"><img src="<c:url value='/images/ucm/icon_del.png' />" alt="삭제하기" /></a>
										<a href="#none" onclick="downAttFile('${layoutImageList[1].IMAGE_SN}')">${layoutImageList[1].IMAGE_NM} </a>
									</div>
								</c:if>	
							</c:if>
						</div>								              	                           
           			</div>
				</td>

			</tr>
			<tr>
				<th scope="col">텍스트영역2</th>
				<td>                	
					<textarea name="ad_text_area5" id="ad_text_area5" rows="5" title="내용입력란"  style="width:98%;" ><c:if test="${dataMap.LAYOUT_TY == '2' }">${layoutTextList[1].TEXT }</c:if></textarea>
				</td>

			</tr>
		</table>
	</div>
	<div id="entprsIntro3" name="entprsIntro3" class="view_zone2 mt20" style="display: none;">
		<table class="table_view2">
			<colgroup>
        		<col style="width:30%" />
        		<col style="width:70%" />
        	</colgroup>
			<tr>
				<th scope="col">이미지영역1</th>
				<td>
					<div class="btn_inner">                            
               			<input type="file" id="multipartFile5" name="multipartFile5" title="파일찾아보기" />
                        <div id="photo_file_view5" >
                        	<c:if test="${not empty layoutImageList[0].IMAGE_SN }" >
                        		<c:if test="${dataMap.LAYOUT_TY == '3' }">
         							<div class="MultiFile-label">
                 						<a href="#none" onclick="delAttFile('${layoutImageList[0].IMAGE_SN}', '5')"><img src="<c:url value='/images/ucm/icon_del.png' />" alt="삭제하기" /></a>
										<a href="#none" onclick="downAttFile('${layoutImageList[0].IMAGE_SN}')">${layoutImageList[0].IMAGE_NM} </a>
									</div>
								</c:if>
							</c:if>
						</div>								              	                           
           			</div>
				</td>
			</tr>
			<tr>
				<th scope="col">텍스트영역1</th>
				<td>                	
					<textarea name="ad_text_area6" id="ad_text_area6" rows="5" title="내용입력란"  style="width:98%;" ><c:if test="${dataMap.LAYOUT_TY == '3' }">${layoutTextList[0].TEXT }</c:if></textarea>
				</td>
			</tr>
			<tr>
				<th scope="col">이미지영역2</th>
				<td>
					<div class="btn_inner">                            
               			<input type="file" id="multipartFile6" name="multipartFile6" title="파일찾아보기" />
                        <div id="photo_file_view6" >
                        	<c:if test="${not empty layoutImageList[1].IMAGE_SN }" >
                        		<c:if test="${dataMap.LAYOUT_TY == '3' }">
         							<div class="MultiFile-label">
                 						<a href="#none" onclick="delAttFile('${layoutImageList[1].IMAGE_SN}', '6')"><img src="<c:url value='/images/ucm/icon_del.png' />" alt="삭제하기" /></a>
										<a href="#none" onclick="downAttFile('${layoutImageList[1].IMAGE_SN}')">${layoutImageList[1].IMAGE_NM} </a>
									</div>
								</c:if>
							</c:if>
						</div>								              	                           
           			</div>
				</td>
			</tr>
			<tr>
				<th scope="col">텍스트영역2</th>
				<td>                	
					<textarea name="ad_text_area7" id="ad_text_area7" rows="5" title="내용입력란"  style="width:98%;" ><c:if test="${dataMap.LAYOUT_TY == '3' }">${layoutTextList[1].TEXT }</c:if></textarea>
				</td>
			</tr>
			<tr>
				<th scope="col">이미지영역3</th>
				<td>
					<div class="btn_inner">                            
               			<input type="file" id="multipartFile7" name="multipartFile7" title="파일찾아보기" />
                        <div id="photo_file_view7" >
                        	<c:if test="${not empty layoutImageList[2].IMAGE_SN }" >
                        		<c:if test="${dataMap.LAYOUT_TY == '3' }">
         							<div class="MultiFile-label">
                 						<a href="#none" onclick="delAttFile('${layoutImageList[2].IMAGE_SN}', '7')"><img src="<c:url value='/images/ucm/icon_del.png' />" alt="삭제하기" /></a>
										<a href="#none" onclick="downAttFile('${layoutImageList[2].IMAGE_SN}')">${layoutImageList[2].IMAGE_NM} </a>
									</div>								
								</c:if>
							</c:if>
						</div>								              	                           
           			</div>
				</td>
			</tr>
			<tr>
				<th scope="col">텍스트영역3</th>
				<td>                	
					<textarea name="ad_text_area8" id="ad_text_area8" rows="5" title="내용입력란"  style="width:98%;" ><c:if test="${dataMap.LAYOUT_TY == '3' }">${layoutTextList[2].TEXT }</c:if></textarea>
				</td>

			</tr>
			<tr>
				<th scope="col">이미지영역4</th>
				<td>
					<div class="btn_inner">                            
               			<input type="file" id="multipartFile8" name="multipartFile8" title="파일찾아보기" />
                        <div id="photo_file_view8" >
                        	<c:if test="${not empty layoutImageList[3].IMAGE_SN }" >
                        		<c:if test="${dataMap.LAYOUT_TY == '3' }">
         							<div class="MultiFile-label">
                 						<a href="#none" onclick="delAttFile('${layoutImageList[3].IMAGE_SN}', '8')"><img src="<c:url value='/images/ucm/icon_del.png' />" alt="삭제하기" /></a>
										<a href="#none" onclick="downAttFile('${layoutImageList[3].IMAGE_SN}')">${layoutImageList[3].IMAGE_NM} </a>
									</div>
								</c:if>								
							</c:if>
						</div>
           			</div>
				</td>
			</tr>
			<tr>
				<th scope="col">텍스트영역4</th>
				<td>                	
					<textarea name="ad_text_area9" id="ad_text_area9" rows="5" title="내용입력란"  style="width:98%;" ><c:if test="${dataMap.LAYOUT_TY == '3' }">${layoutTextList[3].TEXT }</c:if></textarea>
				</td>
			</tr>						
		</table>
	</div>
	 
	<!--//페이지버튼-->
	<div class="btn_page2 dot1 mt20" style="clear: both;">
		<a class="btn_page_blue" href="#none" id="btn_save"><span>저장</span></a>
		<a class="btn_page_blue" href="#none" id="btn_close"><span>닫기</span></a>
	</div>
	<!--페이지버튼//-->

</form>

</body>
</html>