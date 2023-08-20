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
<ap:jsTag type="web"
	items="jquery,tools,ui,form,validate,notice,msgBox,colorbox,mask,multifile,jBox,flot,multiselect,json" />
<ap:jsTag type="tech" items="acm,msg,cmn, mainn, subb, font,,msg,util,cs,my,pc" />

<style>
/* modal popup */
.modal{z-index:99999; padding-top: 0px; display:block; width: 1050px; position:fixed; left:0; top:0; width:100%; height:100%; background-color:rgb(0,0,0); background-color:rgba(0,0,0,0.4)}
.view_zone{margin:auto; background-color:#fff; position:relative; padding:0; outline:0; width: 1050px;}
.view_zone.w-90{width: 900px;}
.view_zone.w-80{width: 802px;}
.view_zone .modal_header{background: #26366d; padding: 19px 30px 16px 41px;}
.view_zone .modal_header::after{display: block; content: ""; clear: both;}
.view_zone .modal_header h1{float: left; color: #fff; font-size: 20px; font-weight: 700; }
.view_zone .modal_header .btn_close{float: right; cursor: pointer; color: #fff}
.view_zone .modal_cont{max-height: 593px; overflow-y: scroll; width: 100%; padding: 20px 44px 43px 41px; box-sizing: border-box;}
.view_zone .modal_cont2{max-height: 593px; overflow-y: scroll; width: 75%; padding: 13px 14px 13px 11px; box-sizing: border-box;}

.view_zone .list_bl{margin-bottom: 65px;}
.view_zone .list_bl:last-child{margin-bottom: 0;}
.view_zone .list_bl.m_b_0{margin-bottom: 0;}
.view_zone .list_bl .fram_bl{margin-bottom: 12px; font-size: 23px; color: #222222; font-weight: 500; letter-spacing: -2px;}
.view_zone .list_bl .fram_bl::before{display: block; content:""; width: 15px; height: 3px; background-color: #2763ba; margin-bottom: 9px;}
.view_zone .list_bl .fram_bl::after{display: block; content:""; clear: both;}
.view_zone .list_bl .fram_bl.none::before{display: block;}
.view_zone .list_bl .fram_bl p{float: right; font-family: 'NanumBarunGothic'; color: #666; font-weight: 300; font-size: 14px; letter-spacing: 0.025em;}
.view_zone .list_bl .fram_bl p img{margin-right: 5px; margin-top: -3px;}

.view_zone .table_form{ border-collapse: collapse; margin-bottom: 55px; text-align: left; table-layout: fixed;}
.view_zone .table_form.m_b_10{margin-bottom: 10px;}
.view_zone .table_form .p_l_30{padding-left: 30px;}
.view_zone .table_form thead{border-top: 1px solid #222;}
.view_zone .table_form tbody tr:first-child{border-top: 1px solid #222;}
.view_zone .table_form thead + tbody tr:first-child{border-top: 0;}
.view_zone .table_form thead th{text-align: center;}
.view_zone .table_form thead th.t_left{text-align: left;}
.view_zone .table_form tbody th{font-size:15px; padding: 17px 0 16px 16px}
.view_zone .table_form tbody th img{margin-top: -5px; margin-right: 5px;}
.view_zone .table_form img.help_btn{margin-right: 0; margin-left: 7px;}
.view_zone .table_form .t_center{text-align: center;}
.view_zone .table_form tr{border-bottom:1px solid #dadada;}
.view_zone .table_form tr.table_input th{padding: 10px 0 10px 16px}
.view_zone .table_form tr.table_input th.t_center{padding-left: 0; padding-right: 0;}
.view_zone .table_form tr.table_input .p_l_30{padding-left: 30px;}
.view_zone .table_form tr.table_input td{padding: 10px 0 10px 15px}
.view_zone .table_form tr.table_input td.t_center{padding-left: 0; padding-right: 0;}
.view_zone .table_form th, .view_zone .table_form td{border-left: 1px solid #dadada; line-height: 25px;}
.view_zone .table_form tr th:first-child, .view_zone .table_form tr td:first-child{border-left: 0;}
.view_zone .table_form tr th:last-child, .view_zone .table_form tr td:last-child{border-right: 0;}
.view_zone .table_form th{padding: 20px 14px 20px 22px; font-family: 'NanumBarunGothic'; font-size: 16px; color: #222; background: #f4faff; font-weight: 500; text-align: left;}
.view_zone .table_form tr:first-child th{border-top: 0;}
.view_zone .table_form td{padding: 17px 0 16px 15px; color: #666; font-family: 'NanumBarunGothic'; font-size: 15px;}
.view_zone .table_form .t_right{text-align: right; padding-right: 15px;}
.view_zone .table_form td.p_l_0{padding-left: 0;}
.view_zone .table_form td strong{color: #222; font-weight: 500; font-size: 17px;}
.view_zone .table_form td strong.s_strong{font-size: 15px;}
.view_zone .table_form td strong.l_strong{font-size: 20px; font-weight: 700;}
.view_zone .table_form .t_center{text-align: center; padding-left: 0; padding-right: 0;}
.view_zone .table_form .t_red{color: #d50d0d}
.view_zone .table_form .t_blu{color: #2763ba}
.view_zone .table_form .t_pnk{color: #f50045}
.view_zone .table_form td p.ex{font-size: 14px; margin-top: 5px; line-height: 24px;}
.view_zone .table_form .b_l_0{border-left:0;}
.view_zone .table_form .bg_gray{background: #f9f9f9}
.view_zone .table_form .form_blBtn{font-family: 'NanumBarunGothic'; background: #fff; font-size: 14px; color: #2763ba; font-weight: 500; border: 1px solid #2763ba; padding: 6px 14px; display: inline-block;}
.view_zone .table_form .gray_btn{font-family: 'NanumBarunGothic'; color: #fff; font-size: 15px; font-weight: 500; background: #a5a9b6; margin-left: 5px; padding: 11px 16px 9px}
.view_zone .table_form td input[type="text"]{border: 1px solid #dadada; box-sizing: border-box; width: 335px; height: 38px; padding: 0 8px;}
.view_zone .table_form td textarea{border: 1px solid #dadada; box-sizing: border-box; width: 241px; height: 38px; resize: none;}

.view_zone .table_form td .form_sel::after{display: block; clear: both; content:""}
.view_zone .table_form td .form_sel li{float: left;}
.view_zone .table_form td .form_sel li .sel{line-height: normal;min-width: 133px; margin-right: 8px; position: relative; background: #fff url('/images2/sub/sel_btn_ico02.png') no-repeat; background-position: 108px center; border: 1px solid #dadada; background-color: #fff; color: #666; font-family: 'NanumBarunGothic'; font-size: 15px; padding: 9px 11px; box-sizing: border-box; }
.view_zone .table_form td .form_sel li .sel.on{background: #fff url('/images2/sub/sel_btn_ico02_on.png') no-repeat; background-position: 120px center;}
.view_zone .table_form td .form_sel li .sel .sel_option {position:absolute; z-index:990; display:block; width: 133px; left:-1px; top: 37px;}
.view_zone .table_form td .form_sel li .sel .sel_option ul{float: none; border: 1px solid #dadada; border-top:0;}
.view_zone .table_form td .form_sel li .sel .sel_option ul li {float: none; background-color: #fff;}
.view_zone .table_form td .form_sel li .sel .sel_option ul li a {color:#666; font-family: 'NanumBarunGothic'; display: block; padding: 9px 10px; font-size: 14px;}
.view_zone .table_form td .form_sel li .sel .sel_option ul li.on{background-color: #f4f4f4}

.view_zone .table_form .radio_sy li input[type="radio"] + label{margin-top: 3px;}
.view_zone .table_form .radio_sy.intext li input[type="radio"] + label{margin-top: 12px;}
.view_zone .table_form .radio_sy.intext li.nonetext{padding-top: 9px}
.view_zone .table_form .radio_sy.intext li.nonetext input[type="radio"] + label{margin-top: 3px;}

.view_zone .table_form .check_sy2_1 li{width: 100%; text-align: center; padding: 0}
.view_zone .table_form .check_sy2_1 li input[type="checkbox"] + label{margin: 0 auto; display: block; float: none;}

.view_zone .list_noraml{background: url('/images2/sub/list_noraml_style.png') no-repeat; background-position: left 10px; font-size:16px; color: #666666;  font-family: 'NanumBarunGothic'; padding-left: 10px; line-height: 24px; margin-bottom: 15px; word-spacing: -1px;}
.view_zone .list_noraml .detail_btn{font-size: 14px; color: #2763ba; border:1px solid #2763ba; padding: 8px 14px; margin-left: 10px;}

.view_zone .btn_bl{text-align: center; width: 721px; margin: 0 auto; padding-bottom: 43px;}
.view_zone .btn_bl a{width: 160px; background: #26366d; color: #fff; text-align: center; display: inline-block; font-size: 16px; font-family: 'NanumBarunGothic'; padding: 16px 0 15px; letter-spacing: 0.031em; box-sizing: border-box;}
.view_zone .btn_bl a + a{margin-left: 10px;}
.view_zone .btn_bl a.wht{background: #fff; border: 1px solid #222; color: #222}
.view_zone .btn_bl a.blu{background: #2763ba; border: 1px solid #2763ba; color: #fff}

.view_zone .graph{padding-top: 13px; padding-bottom: 50px;}
.view_zone .graph::after{display: block; content:""; clear: both;}
.view_zone .graph > div{float: left; width: 50%;}
.view_zone .graph > div:first-child{text-align: left;}
.view_zone .graph > div:last-child{text-align: right;}

.view_zone .ess_txt{text-align: right; font-family: 'NanumBarunGothic'; color: #666; font-weight: 300; font-size: 14px; letter-spacing: 0.025em;}
.view_zone .ess_txt img{margin-right: 5px; margin-top: -3px;}

#care01.view_zone .btn_bl{border-top: 1px solid #222; width: 100%; margin-top: 80px; padding-top: 38px;}
</style>

<script type="text/javascript">

var labrrDatas = ${labrrDatas};		//근로자수
var selngDatas = ${selngDatas};		//매출액
var caplDatas = ${caplDatas};		//자본금
var assetsDatas = ${assetsDatas};	//자산총액

$(document).ready(function(){
	
	<c:if test="${message != null}">
		jsMsgBox(null, "info","${message}");				
	</c:if>
	
	
	var tcnt = 0;
	var temp = 0;
	
	<c:if test="${layoutList.size() != 0}">
		<c:forEach items="${layoutList}" var="layoutList" varStatus="status">
			if(${layoutList.IEM_SN} != temp) {
				tcnt=0;
			}
			tcnt+=1;
			if(${layoutList.IEM_SN == 1}) {
				$("#ad_sn_image_1").val(tcnt);
				$("#ad_sn_text_1").val(tcnt);
				$("#ad_sn_1").val(tcnt);
			}
			else if(${layoutList.IEM_SN == 2}) {
				$("#ad_sn_image_2").val(tcnt);
				$("#ad_sn_text_2").val(tcnt);
				$("#ad_sn_2").val(tcnt);
			}
			else if(${layoutList.IEM_SN == 3}) {
				$("#ad_sn_image_3").val(tcnt);
				$("#ad_sn_text_3").val(tcnt);
				$("#ad_sn_3").val(tcnt);
			}
			else if(${layoutList.IEM_SN == 4}) {
				$("#ad_sn_image_4").val(tcnt);
				$("#ad_sn_text_4").val(tcnt);
				$("#ad_sn_4").val(tcnt);
			}
			else if(${layoutList.IEM_SN == 5}) {
				$("#ad_sn_image_5").val(tcnt);
				$("#ad_sn_text_5").val(tcnt);
				$("#ad_sn_5").val(tcnt);
			}
			else if(${layoutList.IEM_SN == 6}) {
				$("#ad_sn_image_6").val(tcnt);
				$("#ad_sn_text_6").val(tcnt);
				$("#ad_sn_6").val(tcnt);
			}
			
			temp = ${layoutList.IEM_SN};
		</c:forEach>
	</c:if>
	
	for(i=1; i<7; i++) {
		if($('#ad_sn_image_'+i).val() == 0) {
			$('#ad_sn_image_'+i).val((Number($('#ad_sn_image_'+i).val())+1));
			$('#ad_sn_'+i).val((Number($('#ad_sn_'+i).val())+1));
			addImageRow(i);
			$('#ad_sn_text_'+i).val(1);
		}
		if($('#ad_sn_text_'+i).val() == 1 || $('#ad_sn_text_'+i).val() == 0) {
			$('#ad_sn_text_'+i).val((Number($('#ad_sn_text_'+i).val())+1));
			$('#ad_sn_'+i).val((Number($('#ad_sn_'+i).val())+1));
			addTextRow(i);
		}
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
			list:'#photo_file_view',
			max: '1',
			STRING: {
				remove: '<img src="<c:url value="/images/ucm/icon_del.png" />" alt="x" />',
				denied: '$ext 는(은) 업로드 할 수 없는 파일확장자입니다!',
				duplicate: '$file 는(은) 이미 추가된 파일입니다!'
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

	$("#ad_lst_at").addClass("select_box");
	$("#ad_entrprs_stle").addClass("select_box");
	$("#ad_entrprs_crtfc").addClass("select_box");	

	setDescView();
	setMainIndex();
	// 주요 통계 지표 툴팁 
	$("#placeholder").UseTooltip();
	
});

function setImage() {
	$('.multifile1').MultiFile({
		accept: 'jpg|gif',
		max: '1',
		STRING: {
			remove: '<img src="<c:url value="/images/ucm/icon_del.png" />" alt="x" />',
			denied: '$ext 는(은) 업로드 할 수 없는 파일확장자입니다!',
			duplicate: '$file 는(은) 이미 추가된 파일입니다!'
		},

		afterFileSelect: function(element, value, master_element){
			$("#ad_fileiemsn").val((element.id).substring(10,11));
			$("#ad_filesn").val((element.id).substring(12,13));
			
			var $fileList = $(".show_file_nm").find(".MultiFile-label");
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
//							$("#img_photo").attr("src", srcStr);
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
function delAttFile(fileSeq, sn, iemSn){
	
	jsMsgBox(null, "confirm", Message.msg.fileDeleteConfirm, function() {
		$("#ad_sn").val(sn);
		$("#ad_iemsn").val(iemSn);
		$.ajax({
	        url      : "PGMY0030.do",
	        type     : "POST",
	        dataType : "json",
	        data     : {
	        			df_method_nm:"updateDelLogoFile"
	        			, file_seq:fileSeq
	        			, ad_bizrno:$("#ad_bizrno").val()
	        			, USER_NO:$("#USER_NO").val()
	        			, ad_sn:sn
	        			, ad_iemsn:iemSn
	        },
	        async    : false,                
	        success  : function(response) {        	
	        	try {
	        		if(eval(response)) {
	        			//$("#file_"+id).attr("disabled",false);
	        			//$("#file_show_"+id).remove();
	        			$("#show_file_view"+iemSn+"_"+sn).empty();
	        			jsMsgBox(null,'info',Message.msg.successDelete);
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

// 이미지, 텍스트 값 증가
function addSn(layoutInfoNum, type) {
	if(type == 1) {
		switch(layoutInfoNum) {
			case 1:
				$("#ad_sn_1").val(Number($("#ad_sn_1").val())+1);
				$("#ad_sn_image_1").val(Number($("#ad_sn_image_1").val())+1);
				addImageRow(layoutInfoNum);
				break;
			case 2:
				$("#ad_sn_2").val(Number($("#ad_sn_2").val())+1);
				$("#ad_sn_image_2").val(Number($("#ad_sn_image_2").val())+1);
				addImageRow(layoutInfoNum);
				break;
			case 3:
				$("#ad_sn_3").val(Number($("#ad_sn_3").val())+1);
				$("#ad_sn_image_3").val(Number($("#ad_sn_image_3").val())+1);
				addImageRow(layoutInfoNum);
				break;
			case 4:
				$("#ad_sn_4").val(Number($("#ad_sn_4").val())+1);
				$("#ad_sn_image_4").val(Number($("#ad_sn_image_4").val())+1);
				addImageRow(layoutInfoNum);
				break;
			case 5:
				$("#ad_sn_5").val(Number($("#ad_sn_5").val())+1);
				$("#ad_sn_image_5").val(Number($("#ad_sn_image_5").val())+1);
				addImageRow(layoutInfoNum);
				break;
			case 6:
				$("#ad_sn_6").val(Number($("#ad_sn_6").val())+1);
				$("#ad_sn_image_6").val(Number($("#ad_sn_image_6").val())+1);
				addImageRow(layoutInfoNum);
				break;
			default:
				break;
			}
	}
	else if(type == 2) {
		switch(layoutInfoNum) {
			case 1:
				$("#ad_sn_1").val(Number($("#ad_sn_1").val())+1);
				$("#ad_sn_text_1").val(Number($("#ad_sn_text_1").val())+1);
				addTextRow(layoutInfoNum);
				break;
			case 2:
				$("#ad_sn_2").val(Number($("#ad_sn_2").val())+1);
				$("#ad_sn_text_2").val(Number($("#ad_sn_text_2").val())+1);
				addTextRow(layoutInfoNum);
				break;
			case 3:
				$("#ad_sn_3").val(Number($("#ad_sn_3").val())+1);
				$("#ad_sn_text_3").val(Number($("#ad_sn_text_3").val())+1);
				addTextRow(layoutInfoNum);
				break;
			case 4:
				$("#ad_sn_4").val(Number($("#ad_sn_4").val())+1);
				$("#ad_sn_text_4").val(Number($("#ad_sn_text_4").val())+1);
				addTextRow(layoutInfoNum);
				break;
			case 5:
				$("#ad_sn_5").val(Number($("#ad_sn_5").val())+1);
				$("#ad_sn_text_5").val(Number($("#ad_sn_text_5").val())+1);
				addTextRow(layoutInfoNum);
				break;
			case 6:
				$("#ad_sn_6").val(Number($("#ad_sn_6").val())+1);
				$("#ad_sn_text_6").val(Number($("#ad_sn_text_6").val())+1);
				addTextRow(layoutInfoNum);
				break;
			default:
				break;
			}
	}
}

// 이미지 추가
function addImageRow(layoutInfoNum) {
	$("#ad_tbl_iemSn"+layoutInfoNum).append(	
		  '<tr>'
		  	+ '<th colspan="2"  scope="col" style="padding-left: 50px;">이미지영역</th>'
          	+ '<td>' 
		  		+ '<div class="btn_inner">'                            
		  		+ '<input type="file" onclick="setImage();" id="ad_imageSn'+layoutInfoNum+'_' + $("#ad_sn_"+layoutInfoNum).val() + '" name="ad_imageSn'+layoutInfoNum+'_' + $("#ad_sn_"+layoutInfoNum).val() + '" class="multifile1" title="파일찾아보기" />'
		  	+ '</td>'
		  	+ '<div id="show_file_view' + layoutInfoNum + '_' + $("#ad_sn_image_"+layoutInfoNum).val() + '" class="show_file_nm">'
			+	'</div>'			
		  + '</tr>'
	);
	
	$("#ad_sn_text_"+layoutInfoNum).val(Number($("#ad_sn_"+layoutInfoNum).val())+1);
}

// 텍스트 추가
function addTextRow(layoutInfoNum) {
	$("#ad_tbl_iemSn"+layoutInfoNum).append(	
			  '<tr>'
			  	+ '<th scope="col" class="tac"><input type="checkbox" name="ad_delchk_' + layoutInfoNum + '" /></th>'
			  	+ '<th scope="col">텍스트영역</th>'
	          	+ '<td>' 
			  		+ '<textarea name="ad_textSn'+layoutInfoNum+'_' + $("#ad_sn_"+layoutInfoNum).val() + '" id="ad_textSn'+layoutInfoNum+'_' + $("#ad_sn_"+layoutInfoNum).val() + '" rows="5" title="내용입력란"  style="width:98%;" ></textarea>'
			  	+ '</td>'
			  + '</tr>'
		);
	
	$("#ad_sn_image_"+layoutInfoNum).val(Number($("#ad_sn_"+layoutInfoNum).val())+1);
}

// 선택 삭제
function delRow(layoutInfoNum) {
	var checkCnt = $("input[name=ad_delchk_" + layoutInfoNum + "]").size();
	var count = 0;
	
	// 체크박스에 체크가 되어있을 때 삭제
	for (var i=0; i<checkCnt; i++) {
		if($("input[name=ad_delchk_" + layoutInfoNum + "]").eq(i).is(":checked")) {
			$("input[name=ad_delchk_" + layoutInfoNum + "]").eq(i).parent().parent().remove();
			i--;
			count++;
		}
	}
		if(count != 0) {
		} else {
			// 삭제창 알림
				jsMsgBox(null, "error", Message.template.wrongDelTarget(""));
		}
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
		<input type="hidden" id="ad_iemsn" name="ad_iemsn"/>
		
		<input type="hidden" id="ad_filesn" name="ad_filesn" value=1/>
		<input type="hidden" id="ad_fileiemsn" name="ad_fileiemsn"/>
		<input type="hidden" id="multipart_sn" name="multipart_sn" value=1/>
		
		<input type="hidden" id="ad_sn_text_1" name="ad_sn_text_1" value=0 />
		<input type="hidden" id="ad_sn_text_2" name="ad_sn_text_2" value=0 />
		<input type="hidden" id="ad_sn_text_3" name="ad_sn_text_3" value=0 />
		<input type="hidden" id="ad_sn_text_4" name="ad_sn_text_4" value=0 />
		<input type="hidden" id="ad_sn_text_5" name="ad_sn_text_5" value=0 />
		<input type="hidden" id="ad_sn_text_6" name="ad_sn_text_6" value=0 />
		
		<input type="hidden" id="ad_sn_image_1" name="ad_sn_image_1" value=0 />
		<input type="hidden" id="ad_sn_image_2" name="ad_sn_image_2" value=0 />
		<input type="hidden" id="ad_sn_image_3" name="ad_sn_image_3" value=0 />
		<input type="hidden" id="ad_sn_image_4" name="ad_sn_image_4" value=0 />
		<input type="hidden" id="ad_sn_image_5" name="ad_sn_image_5" value=0 />
		<input type="hidden" id="ad_sn_image_6" name="ad_sn_image_6" value=0 />
		
		<input type="hidden" id="ad_sn_1" name="ad_sn_1" value=0 />
		<input type="hidden" id="ad_sn_2" name="ad_sn_2" value=0 />
		<input type="hidden" id="ad_sn_3" name="ad_sn_3" value=0 />
		<input type="hidden" id="ad_sn_4" name="ad_sn_4" value=0 />
		<input type="hidden" id="ad_sn_5" name="ad_sn_5" value=0 />
		<input type="hidden" id="ad_sn_6" name="ad_sn_6" value=0 />

		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />

<!-- 		<div id="care01" class="modal">
			<div class="modal_wrap">
				<div class="modal_cont"> -->
				<div class="view_zone">
					<table class="table_form">
						<caption>채용정보 상세보기</caption>
						<colgroup>
							<col width="224px">
							<col width="128px">
							<col width="258px">
							<col width="128px">
							<col width="258px">
						</colgroup>
						<tbody>
							<tr class="table_input">
								<td rowspan="8" class="t_center">
									<ul class="my_align">
										<li class="my_width"><c:choose>
												<c:when test="${not empty dataMap.LOGO_FILE_SN }">
													<img
														src="<c:url value="/PGCM0040.do?df_method_nm=updateFileDownBySeq&seq=${dataMap.LOGO_FILE_SN}" />"
														id="img_photo" alt="로고" width="100%" style="border: #666 solid 1px" />
												</c:when>
												<c:otherwise>
													<img src="/images2/sub/support/logo_ex.png" id="img_photo" alt="로고" width="100%"
														style="border: #666 solid 1px;" />
												</c:otherwise>
											</c:choose></li>
										<br>
										<li class="my_file_width">
											<div class="btn_inner">
												<input type="file" id="multipartFile" name="multipartFile" title="파일찾아보기" width="100%" height="40%" class="upload-hidden upload-hidden01"/>
												<div id="photo_file_view">
													<c:if test="${not empty dataMap.LOGO_FILE_SN }">
														<div class="MultiFile-label">
															<a href="#none" onclick="logoDelAttFile('${dataMap.LOGO_FILE_SN}');">
																<img src="<c:url value='/images/ucm/icon_del.png' />" alt="삭제하기" />
															</a> 
															<a href="#none" onclick="downAttFile('${dataMap.LOGO_FILE_SN}')">${dataMap.LOGO_FILE_NM} </a>
														</div>
													</c:if>
												</div>
											</div>
										</li> (150px X 40px)
									</ul>
								</td>
								<c:set var="showEntrprsNm" value="${dataMap.ENTRPRS_NM }" />
								<c:if test="${empty showEntrprsNm }">
									<c:set var="showEntrprsNm" value="${defltEntNm }" />
								</c:if>
								<th>사업자등록번호</th>
								<td class="b_l_0" colspan="3">
									<input name="ad_bizrno" type="text" id="ad_bizrno" value="${BIZRNO}" style="width: 180px;" title="사업자등록번호" readonly />
									<div class="btn_inner">
										<a href="#none" class="form_blBtn" style="padding: 6px 14px 4px; margin-left: 10px; margin-right: 7px;" id="popFindBizrNo">기업	조회</a>
									</div> 
									<span class="check_sy3"> 
										<input type="checkbox" name="recomend_entrprs_at" id="recomend_entrprs_at"	<c:if test="${dataMap.RECOMEND_ENTRPRS_AT == 'Y' }"> checked</c:if> /> 
										<label for="recomend_entrprs_at"></label> 
										<label for="recomend_entrprs_at">추천기업 등록</label>	
									</span>
								</td>
							</tr>
							<tr class="table_input">
								<th style="border-left: 1px solid #dadada;">기업명</th>
								<td class="b_l_0"><input name="ad_entrprs_nm" type="text" id="ad_entrprs_nm"
									value="${showEntrprsNm }" style="width: 241px;" title="기업명" /></td>
								<th>대표자</th>
								<td class="b_l_0"><input name="ad_rprsntv_nm" type="text" id="ad_rprsntv_nm"
									value="${dataMap.RPRSNTV_NM }" style="width: 241px;" title="이름" /></td>
							</tr>
							<tr class="table_input">
								<th style="border-left: 1px solid #dadada;">상장여부</th>
								<td class="b_l_0">
									<ap:code id="ad_lst_at" grpCd="28" type="select" selectedCd="${dataMap.LST_AT }" /></td>
								<th>기업형태</th>
								<td class="b_l_0"><ap:code id="ad_entrprs_stle" grpCd="29" type="select"
										selectedCd="${dataMap.ENTRPRS_STLE }" /></td>
							</tr>
							<tr class="table_input">
								<th style="border-left: 1px solid #dadada;">기업인증</th>
								<td class="b_l_0"><ap:code id="ad_entrprs_crtfc" grpCd="30" type="select"
										selectedCd="${dataMap.ENTRPRS_CRTFC }" /></td>
								<th rowspan="2">기업소개<br />공개여부
								</th>
								<td class="b_l_0" rowspan="2">
									<ul class="radio_sy">
										<li style="margin-right: 35px;"><input name="ad_entrprs_vw_at" type="radio"
											id="ad_entrprs_vw_at_1" value="Y"
											<c:if test="${dataMap.ENTRPRS_VW_AT == 'Y' }"> checked</c:if> /> <label
											for="ad_entrprs_vw_at_1"></label> <label for="ad_entrprs_vw_at_1">공개</label></li>
										<li><input name="ad_entrprs_vw_at" type="radio" id="ad_entrprs_vw_at_2" class="ml40"
											value="N" <c:if test="${dataMap.ENTRPRS_VW_AT != 'Y' }"> checked</c:if> /> <label
											for="ad_entrprs_vw_at_2"></label> <label for="ad_entrprs_vw_at_2">비공개</label></li>
									</ul>
								</td>
							</tr>
							<tr class="table_input">
								<th style="border-left: 1px solid #dadada;">기업특성</th>
								<td class="b_l_0"><select class="selet_box" id="searchChartrVal" name="searchChartrVal"
									style="width: 230px;">
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
								</select></td>
							</tr>
							<tr class="table_input">
								<th style="border-left: 1px solid #dadada;">담당자이메일</th>
								<td class="b_l_0"><input name="ad_charger_email" type="text" id="ad_charger_email"
									value="${dataMap.CHARGER_EMAIL }" style="width: 241px;" title="이메일" /></td>
								<th>홈페이지 주소</th>
								<td class="b_l_0"><input name="ad_hmpg" type="text" id="ad_hmpg"
									value="${dataMap.HMPG }" style="width: 241px;" title="홈페이지주소" /></td>
							</tr>
							<tr class="table_input">
								<th style="border-left: 1px solid #dadada;">전화번호</th>
								<td class="b_l_0">
									<ul class="form_sel">
										<select class="select_box" name="ad_tel_first" id="ad_tel_first" style="width: 80px;">
											<c:forTokens items="${PHONE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
												<option value="${firstNum }"
													<c:if test="${dataMap.TELNO1 == firstNum }">selected="selected"</c:if>>${firstNum }</option>
											</c:forTokens>
										</select>
										- <input name="ad_tel_middle" type="text" id="ad_tel_middle"
											value="${dataMap.TELNO2 }" class="text"
											style="width: 66px; margin-left: 3px; margin-right: 3px;" title="전화번호중간번호" /> - <input
											name="ad_tel_last" type="text" id="ad_tel_last" value="${dataMap.TELNO3 }" class="text"
											style="width: 66px; margin-left: 3px;" title="전화번호마지막번호" />
									</ul>
								</td>
								<th>팩스번호</th>
								<td class="b_l_0">
									<ul class="form_sel">
										<select class="select_box" name="ad_fax_first" id="ad_fax_first" style="width: 80px;">
											<c:forTokens items="${PHONE_NUM_FIRST_TOKEN }" delims="," var="firstNum">
												<option value="${firstNum }"
													<c:if test="${dataMap.FXNUM1 == firstNum }">selected="selected"</c:if>>${firstNum }</option>
											</c:forTokens>
										</select> -
										<input name="ad_fax_middle" type="text" id="ad_fax_middle" value="${dataMap.FXNUM2 }"
											class="text" style="width: 66px; margin-left: 3px; margin-right: 3px;" title="팩스중간번호" />
										-
										<input name="ad_fax_last" type="text" id="ad_fax_last" value="${dataMap.FXNUM3 }"
											class="text" style="width: 66px; margin-left: 3px;" title="팩스마지막번호" />
									</ul>
								</td>
							</tr>
							<tr>
								<th style="border-left: 1px solid #dadada;">주소</th>
								<td class="b_l_0" colspan="3">
									<input name="ad_hedofc_zip" type="text"	id="ad_hedofc_zip" value="${dataMap.HEDOFC_ZIP }" readonly="readonly" style="width: 143px;"	title="우편번호" /> 
									<!-- -<input name="info8" type="text" id="info8_2" style="width:117px;" title="우편번호뒷자리" /> -->
									<a href="#" class="gray_btn" id="btn_search_zip">우편번호 검색</a> 
									<br /> 
									<input name="ad_hedofc_adres" type="text" id="ad_hedofc_adres" value="${dataMap.HEDOFC_ADRES }" style="width: 686px; margin-top: 7px;" title="주소상세" />
								</td>
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
	<div class="view_zone">
					<div class="list_bl" style="margin-bottom: 20px;">
						<div class="detail_left">
							<h4 class="fram_bl">
								상세 정보 및 주요 지표 현황 보이기 <img src="<c:url value = "/images/ucm/btn_code.png"/>" width="20"
									height="20" alt="?" id="tool_dt" /> <input type="checkbox" name="ad_dtl_vw_at"
									id="ad_dtl_vw_at" value="Y" <c:if test="${dataMap.DTL_VW_AT == 'Y' }">checked</c:if> />
							</h4>
							<table class="table_form" style="width: 506px;">
								<caption>채용정보 상세보기</caption>
								<colgroup>
									<col width="145px">
									<col width="*">
								</colgroup>
								<tbody>
									<tr class="table_input">
										<th>설립일자</th>
										<td><input name="ad_fond_de" type="text" id="ad_fond_de" value="${dataMap.FOND_DE }"
											style="width: 209px;" title="설립일자" />&nbsp;&nbsp;&nbsp;&nbsp;예) 20101201</td>
									</tr>
									<tr class="table_input">
										<th>상장일</th>
										<td class="b_l_0"><input name="ad_lst_de" type="text" id="ad_lst_de"
											value="${dataMap.LST_DE }" style="width: 209px;" title="상장일" />&nbsp;&nbsp;&nbsp;&nbsp;예)
											20101201</td>
									</tr>
									<tr class="table_input">
										<th scope="col">업종</th>
										<td class="b_l_0"><input name="ad_induty_nm" type="text" id="ad_induty_nm"
											value="${dataMap.INDUTY_NM }" style="width: 332px;" title="업종" /></td>
									</tr>
									<tr class="table_input">
										<th scope="col">주생산품</th>
										<td class="b_l_0"><input name="ad_main_product" type="text" id="ad_main_product"
											value="${dataMap.MAIN_PRODUCT }" style="width: 332px;" title="주생산품" /></td>
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
							<div id="placeholder" style="width: 100%; height: 300px; margin-top: 28px"></div>
							<div class="remark02">
								<ul>
									<li class="remark1">매출액</li>
									<li class="remark2">자본금</li>
									<li class="remark3">자산총액</li>
									<li class="remark4">근로자수</li>
								</ul>
							</div>
						</div>
					</div>

					<div class="list_bl">
						<!-- 	<br>
			<div style="border: 1px solid #b3b3b3; width: 99%; margin-left: 5px; margin-bottom: 30px;"> -->

						<table class="table_form">
							<colgroup>
								<col style="width: 35%" />
								<col style="width: 35%" />
							</colgroup>
							<tr>
								<th colspan=2>기업소개화면 Layout 선택</th>
							</tr>
							<tr style="text-align: center;">
								<td><input name="ad_layout_ty" type="radio" id="ad_layout_ty_1" value="1"
									<c:if test="${dataMap.LAYOUT_TY == '1' }"> checked</c:if> /></td>
								<td><input name="ad_layout_ty" type="radio" id="ad_layout_ty_2" class="ml40" value="2"
									<c:if test="${dataMap.LAYOUT_TY == '2' }"> checked</c:if> /></td>
							</tr>
							<tr style="text-align: center;">
								<td><label for="ad_layout_ty_1"><img
										src="<c:url value = "/images/my/img_type1.png" />" width="50%" /></label></td>
								<td><label for="ad_layout_ty_2"><img
										src="<c:url value = "/images/my/img_type2.png" />" width="50%" /></label></td>
						</table>
					</div>

					<div id="entprsIntro" name="entprsIntro" style="width: 99%;">
						<div id="entprsIntro_iemSn1" name="entprsIntro_iemSn1" class="list_bl">
							<h4 class="fram_bl">기업소개</h4>
							<table class="table_form m_b_10" id=ad_tbl_iemSn1>
								<colgroup>
									<col style="width: 5%" />
									<col style="width: 20%" />
									<col style="width: *" />
								</colgroup>
								<c:set var="snVar" value="0" />
								<c:forEach items="${layoutList}" var="layoutList" varStatus="status">
									<c:if test="${layoutList.IEM_SN == 1}">
										<c:set var="snVar" value="${snVar+1}" />
										<c:if test="${not empty layoutList.IMAGE_SN}">
											<tr>
												<th colspan="2" scope="col" style="padding-left: 50px;">이미지영역</th>
												<td>
													<div class="btn_inner">
														<input type="file" class="multifile1" id="ad_imageSn${layoutList.IEM_SN}_${snVar}"
															name="ad_imageSn${layoutList.IEM_SN}_${snVar}" class="multipartFile" title="파일찾아보기" />
														<div id="show_file_view${layoutList.IEM_SN}_${layoutList.SN}" class="show_file_nm">
															<c:if test="${not empty layoutList.IMAGE_SN }">
																<div class="MultiFile-label">
																	<a href="#none"
																		onclick="delAttFile('${layoutList.IMAGE_SN}', '${layoutList.SN}', '${layoutList.IEM_SN}')"><img
																		src="<c:url value='/images/ucm/icon_del.png' />" alt="삭제하기" /></a> <a href="#none"
																		onclick="downAttFile('${layoutList.IMAGE_SN}')">${layoutList.IMAGE_NM} </a>
																</div>
															</c:if>
														</div>
													</div>
												</td>
											</tr>
										</c:if>
										<c:if test="${not empty layoutList.TEXT}">
											<tr>
												<th scope="col" class="tac"><input type="checkbox" name="ad_delchk_1" /></th>
												<th scope="col">텍스트영역</th>
												<td><textarea name="ad_textSn${layoutList.IEM_SN}_${snVar}"
														id="ad_textSn${layoutList.IEM_SN}_${snVar}" rows="5" title="내용입력란" style="width: 98%;">${layoutList.TEXT}</textarea>
												</td>
											</tr>
										</c:if>
									</c:if>
								</c:forEach>
							</table>
							<div class="add_item">
								<a class="" href="#none" id="a" onclick="addSn(1, 1);">이미지추가</a> <a class="" href="#none"
									onclick="addSn(1, 2);">텍스트추가</a> <a class="" href="#none" onclick="delRow(1);">삭제</a>
							</div>
						</div>

						<div id="entprsIntro_iemSn2" name="entprsIntro_iemSn2" class="list_bl">
							<h4 class="fram_bl">회사연혁</h4>
							<table class="table_form m_b_10" id="ad_tbl_iemSn2">
								<colgroup>
									<col style="width: 5%" />
									<col style="width: 20%" />
									<col style="width: *" />
								</colgroup>
								<c:set var="snVar" value="0" />
								<c:forEach items="${layoutList}" var="layoutList" varStatus="status">
									<c:if test="${layoutList.IEM_SN == 2}">
										<c:set var="snVar" value="${snVar+1}" />
										<c:if test="${not empty layoutList.IMAGE_SN}">
											<tr>
												<th colspan="2" scope="col" style="padding-left: 50px;">이미지영역</th>
												<td>
													<div class="btn_inner">
														<input type="file" class="multifile1" id="ad_imageSn${layoutList.IEM_SN}_${snVar}"
															name="ad_imageSn${layoutList.IEM_SN}_${snVar}" class="multipartFile" title="파일찾아보기" />
														<div id="show_file_view${layoutList.IEM_SN}_${layoutList.SN}" class="show_file_nm">
															<c:if test="${not empty layoutList.IMAGE_SN }">
																<div class="MultiFile-label">
																	<a href="#none"
																		onclick="delAttFile('${layoutList.IMAGE_SN}', '${layoutList.SN}', '${layoutList.IEM_SN}')"><img
																		src="<c:url value='/images/ucm/icon_del.png' />" alt="삭제하기" /></a> <a href="#none"
																		onclick="downAttFile('${layoutList.IMAGE_SN}')">${layoutList.IMAGE_NM} </a>
																</div>
															</c:if>
														</div>
													</div>
												</td>
											</tr>
										</c:if>
										<c:if test="${not empty layoutList.TEXT}">
											<tr>
												<th scope="col" class="tac"><input type="checkbox" name="ad_delchk_2" /></th>
												<th scope="col">텍스트영역</th>
												<td><textarea name="ad_textSn${layoutList.IEM_SN}_${snVar}"
														id="ad_textSn${layoutList.IEM_SN}_${snVar}" rows="5" title="내용입력란" style="width: 98%;">${layoutList.TEXT}</textarea>
												</td>
											</tr>
										</c:if>
									</c:if>
								</c:forEach>
							</table>
							<div class="add_item">
								<a class="" href="#none" onclick="addSn(2, 1);">이미지추가</a> <a class="" href="#none"
									onclick="addSn(2, 2);">텍스트추가</a> <a class="" href="#none" onclick="delRow(2);">삭제</a>
							</div>
						</div>

						<div id="entprsIntro_iemSn3" name="entprsIntro_iemSn3" class="list_bl">
							<h4 class="fram_bl">제품과고객</h4>
							<table class="table_form m_b_10" id="ad_tbl_iemSn3">
								<colgroup>
									<col style="width: 5%" />
									<col style="width: 20%" />
									<col style="width: *" />
								</colgroup>
								<c:set var="snVar" value="0" />
								<c:forEach items="${layoutList}" var="layoutList" varStatus="status">
									<c:if test="${layoutList.IEM_SN == 3}">
										<c:set var="snVar" value="${snVar+1}" />
										<c:if test="${not empty layoutList.IMAGE_SN}">
											<tr>
												<th colspan="2" scope="col" style="padding-left: 50px;">이미지영역</th>
												<td>
													<div class="btn_inner">
														<input type="file" class="multifile1" id="ad_imageSn${layoutList.IEM_SN}_${snVar}"
															name="ad_imageSn${layoutList.IEM_SN}_${snVar}" class="multipartFile" title="파일찾아보기" />
														<div id="show_file_view${layoutList.IEM_SN}_${layoutList.SN}" class="show_file_nm">
															<c:if test="${not empty layoutList.IMAGE_SN }">
																<div class="MultiFile-label">
																	<a href="#none"
																		onclick="delAttFile('${layoutList.IMAGE_SN}', '${layoutList.SN}', '${layoutList.IEM_SN}')"><img
																		src="<c:url value='/images/ucm/icon_del.png' />" alt="삭제하기" /></a> <a href="#none"
																		onclick="downAttFile('${layoutList.IMAGE_SN}')">${layoutList.IMAGE_NM} </a>
																</div>
															</c:if>
														</div>
													</div>
												</td>
											</tr>
										</c:if>
										<c:if test="${not empty layoutList.TEXT}">
											<tr>
												<th scope="col" class="tac"><input type="checkbox" name="ad_delchk_3" /></th>
												<th scope="col">텍스트영역</th>
												<td><textarea name="ad_textSn${layoutList.IEM_SN}_${snVar}"
														id="ad_textSn${layoutList.IEM_SN}_${snVar}" rows="5" title="내용입력란" style="width: 98%;">${layoutList.TEXT}</textarea>
												</td>
											</tr>
										</c:if>
									</c:if>
								</c:forEach>
							</table>
							<div class="add_item">
								<a class="" href="#none" onclick="addSn(3, 1);">이미지추가</a> <a class="" href="#none"
									onclick="addSn(3, 2);">텍스트추가</a> <a class="" href="#none" onclick="delRow(3);">삭제</a>
							</div>
						</div>

						<div id="entprsIntro_iemSn4" name="entprsIntro_iemSn4" class="list_bl">
							<h4 class="fram_bl">소개</h4>
							<table class="table_form m_b_10" id="ad_tbl_iemSn4">
								<colgroup>
									<col style="width: 5%" />
									<col style="width: 20%" />
									<col style="width: *" />
								</colgroup>
								<c:set var="snVar" value="0" />
								<c:forEach items="${layoutList}" var="layoutList" varStatus="status">
									<c:if test="${layoutList.IEM_SN == 4}">
										<c:set var="snVar" value="${snVar+1}" />
										<c:if test="${not empty layoutList.IMAGE_SN}">
											<tr>
												<th colspan="2" scope="col" style="padding-left: 50px;">이미지영역</th>
												<td>
													<div class="btn_inner">
														<input type="file" class="multifile1" id="ad_imageSn${layoutList.IEM_SN}_${snVar}"
															name="ad_imageSn${layoutList.IEM_SN}_${snVar}" class="multipartFile" title="파일찾아보기" />
														<div id="show_file_view${layoutList.IEM_SN}_${layoutList.SN}" class="show_file_nm">
															<c:if test="${not empty layoutList.IMAGE_SN }">
																<div class="MultiFile-label">
																	<a href="#none"
																		onclick="delAttFile('${layoutList.IMAGE_SN}', '${layoutList.SN}', '${layoutList.IEM_SN}')"><img
																		src="<c:url value='/images/ucm/icon_del.png' />" alt="삭제하기" /></a> <a href="#none"
																		onclick="downAttFile('${layoutList.IMAGE_SN}')">${layoutList.IMAGE_NM} </a>
																</div>
															</c:if>
														</div>
													</div>
												</td>
											</tr>
										</c:if>
										<c:if test="${not empty layoutList.TEXT}">
											<tr>
												<th scope="col" class="tac"><input type="checkbox" name="ad_delchk_4" /></th>
												<th scope="col">텍스트영역</th>
												<td><textarea name="ad_textSn${layoutList.IEM_SN}_${snVar}"
														id="ad_textSn${layoutList.IEM_SN}_${snVar}" rows="5" title="내용입력란" style="width: 98%;">${layoutList.TEXT}</textarea>
												</td>
											</tr>
										</c:if>
									</c:if>
								</c:forEach>
							</table>
							<div class="add_item">
								<a class="" href="#none" onclick="addSn(4, 1);">이미지추가</a> <a class="" href="#none"
									onclick="addSn(4, 2);">텍스트추가</a> <a class="" href="#none" onclick="delRow(4);">삭제</a>
							</div>
						</div>

						<div id="entprsIntro_iemSn5" name="entprsIntro_iemSn5" class="list_bl">
							<h4 class="fram_bl">사회공헌활동</h4>
							<table class="table_form m_b_10" id="ad_tbl_iemSn5">
								<colgroup>
									<col style="width: 5%" />
									<col style="width: 20%" />
									<col style="width: *" />
								</colgroup>
								<c:set var="snVar" value="0" />
								<c:forEach items="${layoutList}" var="layoutList" varStatus="status">
									<c:if test="${layoutList.IEM_SN == 5}">
										<c:set var="snVar" value="${snVar+1}" />
										<c:if test="${not empty layoutList.IMAGE_SN}">
											<tr>
												<th colspan="2" scope="col" style="padding-left: 50px;">이미지영역</th>
												<td>
													<div class="btn_inner">
														<input type="file" class="multifile1" id="ad_imageSn${layoutList.IEM_SN}_${snVar}"
															name="ad_imageSn${layoutList.IEM_SN}_${snVar}" class="multipartFile" title="파일찾아보기" />
														<div id="show_file_view${layoutList.IEM_SN}_${layoutList.SN}" class="show_file_nm">
															<c:if test="${not empty layoutList.IMAGE_SN }">
																<div class="MultiFile-label">
																	<a href="#none"
																		onclick="delAttFile('${layoutList.IMAGE_SN}', '${layoutList.SN}', '${layoutList.IEM_SN}')"><img
																		src="<c:url value='/images/ucm/icon_del.png' />" alt="삭제하기" /></a> <a href="#none"
																		onclick="downAttFile('${layoutList.IMAGE_SN}')">${layoutList.IMAGE_NM} </a>
																</div>
															</c:if>
														</div>
													</div>
												</td>
											</tr>
										</c:if>
										<c:if test="${not empty layoutList.TEXT}">
											<tr>
												<th scope="col" class="tac"><input type="checkbox" name="ad_delchk_5" /></th>
												<th scope="col">텍스트영역</th>
												<td><textarea name="ad_textSn${layoutList.IEM_SN}_${snVar}"
														id="ad_textSn${layoutList.IEM_SN}_${snVar}" rows="5" title="내용입력란" style="width: 98%;">${layoutList.TEXT}</textarea>
												</td>
											</tr>
										</c:if>
									</c:if>
								</c:forEach>
							</table>
							<div class="btn_inner">
								<a class="" href="#none" onclick="addSn(5, 1);">이미지추가</a> <a class="" href="#none"
									onclick="addSn(5, 2);">텍스트추가</a> <a class="" href="#none" onclick="delRow(5);">삭제</a>
							</div>
						</div>

						<div id="entprsIntro_iemSn6" name="entprsIntro_iemSn6" class="list_bl">
							<h4 class="fram_bl">CEO 메시지</h4>
							<table class="table_form m_b_10" id="ad_tbl_iemSn6">
								<colgroup>
									<col style="width: 5%" />
									<col style="width: 20%" />
									<col style="width: *" />
								</colgroup>
								<c:forEach items="${layoutList}" var="layoutList" varStatus="status">
									<c:if test="${layoutList.IEM_SN == 6}">
										<c:set var="snVar" value="${snVar+1}" />
										<c:if test="${not empty layoutList.IMAGE_SN}">
											<tr>
												<th colspan="2" scope="col" style="padding-left: 50px;">이미지영역</th>
												<td>
													<div class="btn_inner">
														<input type="file" class="multifile1" id="ad_imageSn${layoutList.IEM_SN}_${snVar}"
															name="ad_imageSn${layoutList.IEM_SN}_${snVar}" class="multipartFile" title="파일찾아보기" />
														<div id="show_file_view${layoutList.IEM_SN}_${layoutList.SN}" class="show_file_nm">
															<c:if test="${not empty layoutList.IMAGE_SN }">
																<div class="MultiFile-label">
																	<a href="#none"
																		onclick="delAttFile('${layoutList.IMAGE_SN}', '${layoutList.SN}', '${layoutList.IEM_SN}')"><img
																		src="<c:url value='/images/ucm/icon_del.png' />" alt="삭제하기" /></a> <a href="#none"
																		onclick="downAttFile('${layoutList.IMAGE_SN}')">${layoutList.IMAGE_NM} </a>
																</div>
															</c:if>
														</div>
													</div>
												</td>
											</tr>
										</c:if>
										<c:if test="${not empty layoutList.TEXT}">
											<tr>
												<th scope="col" class="tac"><input type="checkbox" name="ad_delchk_6" /></th>
												<th scope="col">텍스트영역</th>
												<td><textarea name="ad_textSn${layoutList.IEM_SN}_${snVar}"
														id="ad_textSn${layoutList.IEM_SN}_${snVar}" rows="5" title="내용입력란" style="width: 98%;">${layoutList.TEXT}</textarea>
												</td>
											</tr>
										</c:if>
									</c:if>
								</c:forEach>
							</table>
							<div class="add_item">
								<a class="" href="#none" onclick="addSn(6, 1);">이미지추가</a> <a class="" href="#none"
									onclick="addSn(6, 2);">텍스트추가</a> <a class="" href="#none" onclick="delRow(6);">삭제</a>
							</div>
						</div>
					</div>
					<!--//페이지버튼-->
					<div class="btn_bl">
						<a class="blu" href="#none" id="btn_save"><span>저장</span></a> 
						<a class="btn_page_blue" href="#none" id="btn_close"><span>닫기</span></a>
					</div>
				</div>
					<!--페이지버튼//-->
				<!-- </div>
				</div>
			</div>
		</div> -->
	</form>

</body>
</html>