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
<title>정보변경신청|기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,form,colorboxAdmin,selectbox,validate,mask,notice,msgBoxAdmin,ui,json,jBox" />
<ap:jsTag type="tech" items="msg,util,acm,im" />

<script type="text/javascript">
$(document).ready(function(){
	var existedTempData = "${existedTempData}";
	var tempTargetYear = "${tempTargetYear}";
	var existedApplyData = "N";
	var tempStacntMtYear = "${ad_stacnt_mt_yy}";
	
	var existedMutualInvestLimitAt = "N";    // 상호출자기업여부
	var existedSmlpzAt = "N";                // 중소기업여부
	
	innerHtmlReqstYear(parseInt(tempStacntMtYear));
		
	// 유효성 검사
	$("#dataForm").validate({  
		rules : {  				
    			// 기업명
    			ad_entrprs_nm: {
    				required: true,
    				maxlength: 255
    			},// 특례대상여부
    			ad_excpt_trget_at: {
    				required: true
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
    			},// 결산월
    			ad_stacnt_mt_ho: {
    				required: true
    			},// 확인신청년도
    			ad_confm_target_yy: {
    				required: true
    			},// 직전년도
    			ad_stacnt_mt_yy: {
    				required: true
    			}
    			
			},
		submitHandler: function(form) {
			if(existedApplyData == "Y") {
				jsMsgBox(null,'info','입력하신 확인신청 대상년도의 신청이력이 있습니다.');
				return;
			} else if(existedTempData == "Y" && tempTargetYear == $("#ad_confm_target_yy").val()) {	
				jsMsgBox(null,'info','기업확인신청 임시저장 내역이 있습니다.');
				return;
			} else if(existedMutualInvestLimitAt == "Y") {
				jsMsgBox(null,'info','상호출자제한기업 입니다.');
				return;
			} else if(existedSmlpzAt == "Y") {
				jsMsgBox(null,'info','중소기업확인을 받은 기업입니다.');
				return;
			} else {
				form.df_method_nm.value = "";
				form.ad_admin_new_at = "Y";
				form.ad_win_type = "";
				form.ad_view_type = "edit";
				form.action = "PGIC0022.do";
				form.submit();
				
				/* var ad_jdgmnt_reqst_year = $("#ad_jdgmnt_reqst_year").val();
				var ad_stacnt_mt_ho      = $("#ad_stacnt_mt_ho").val();
				var ad_confm_target_yy   = $("#ad_confm_target_yy").val();
				var ad_excpt_trget_at    = $("#ad_excpt_trget_at").val();
				var ad_entrprs_nm        = $("#ad_entrprs_nm").val();
				var ad_bizrno_first      = $("#ad_bizrno_first").val();
				var ad_bizrno_middle     = $("#ad_bizrno_middle").val();
				var ad_bizrno_last       = $("#ad_bizrno_last").val();
				var ad_stacnt_mt_ho      = $("#ad_stacnt_mt_ho").val();
				var ad_jurirno           = $("#ad_jurirno").val();
				
				$.colorbox({
			        title : "신청서 상세",
			        href  : "PGIC0022.do?df_method_nm=&ad_admin_new_at=Y&ad_win_type=pop&ad_view_type=edit"
			        		+ "&ad_jdgmnt_reqst_year="+ad_jdgmnt_reqst_year
			        		+ "&ad_stacnt_mt_ho="+ad_stacnt_mt_ho
			        		+ "&ad_confm_target_yy="+ad_confm_target_yy
			        		+ "&ad_excpt_trget_at="+ad_excpt_trget_at
			        		+ "&ad_entrprs_nm="+ad_entrprs_nm
			        		+ "&ad_bizrno_first="+ad_bizrno_first
			        		+ "&ad_bizrno_middle="+ad_bizrno_middle
			        		+ "&ad_bizrno_last="+ad_bizrno_last
			        		+ "&ad_stacnt_mt_ho="+ad_stacnt_mt_ho
			        		+ "&ad_jurirno="+ad_jurirno,
			        width : "817px",
			        height: "80%",
			        overlayClose : false,
			        escKey : false,
			        iframe: true
			    }); */
			}
		}
	});
	
	// 직전년도 변경 시 결산월 초기화
	$("#ad_stacnt_mt_yy").change(function(){
		var select_list = document.dataForm.elements["ad_stacnt_mt_ho"];
		
		select_list.options[0].selected = "true";
		$("#ad_stacnt_mt_ho").change();
	});
	
	// 결산월 변경에 따른 발행가능여부
	$("#ad_stacnt_mt_ho").change(function(){
		var form = document.dataForm;
		
		var stacnt_year = form.ad_stacnt_mt_yy.value;
		var stacnt_month = $(this).val();
		
		if(stacnt_month) {
			$.ajax({        
		        url      : "PGIM0010.do",
		        type     : "POST",
		        dataType : "json",
		        data     : { df_method_nm: "getIssuYears"        	       
		        	       	, ad_stacnt_mt_ho: stacnt_month
		        	       	, ad_stacnt_mt_yy: stacnt_year
		        	       },                
		        async    : false,                
		        success  : function(response) {
		        	try {        		
		        		if(response.result) {
		        			var valueObj = response.value;
		        			innerHtmlIssuYear(valueObj.start_issu_year + 1, valueObj.last_issu_year);
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
			
		}else{
			$("#ad_confm_target_yy").html("<option value=''>-- 선택 --</option>");
		}
	});
	
	// 확인신청년도 변경
	$("#ad_confm_target_yy").change(function(){
		var form = document.dataForm;
		var issu_year = $(this).val();
		
		if(issu_year) {
			$.ajax({        
		        url      : "PGIM0010.do",
		        type     : "POST",
		        dataType : "json",
		        data     : { df_method_nm: "pblictePossibleAt"        	       
		        	       	, ad_stacnt_mt_ho: $("#ad_stacnt_mt_ho").val()
		        	       	, ad_issu_year: issu_year - 1
		        	       	, ad_jurirno: $("#ad_jurirno").val()
		        	       },                
		        async    : false,                
		        success  : function(response) {
		        	try {        		
		        		if(response.result) {
		        			var valueObj = response.value;
		        			if(valueObj.mutual_invest_limit_at == "Y"){
		        				existedMutualInvestLimitAt = valueObj.mutual_invest_limit_at;
		        				
		        				jsMsgBox(null,'info','${param.ad_entrprs_nm}'+' 기업은 '+'상호출자제한기업 입니다.');
		        			}
		        			
		        			if(valueObj.last_year_at) {
		        				if(valueObj.smba_at == "Y") {
		        					existedSmlpzAt = valueObj.smba_at;
		        					
		        					var process_de = valueObj.process_de_fmt;
		        					var smba_date = process_de.first + "년 " + process_de.middle + "월 " + process_de.last + "일";
		        					jsMsgBox(null,'info','${param.ad_entrprs_nm}'+' 기업은 '+smba_date+' 중소기업확인을 받은 기업입니다.');
		        				}
		        			}
		        			
		        			existedApplyData = valueObj.applyData_at;
		        			
		                } else {
		                	jsMsgBox(null,'info',response.message);
		                }
		        		
		        		$("#ad_jdgmnt_reqst_year").val(issu_year - 1);
		        		
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
	});
	
	// tool tip
	$("#add_tooltip").jBox('Tooltip', {
		content: '결산월로부터 3개월이 지난 다음날 부터 확인서 발급 가능'
	});
	
	$("#add_tooltip2").jBox('Tooltip', {
		content: '유효기간 예시) <br>직전년도 결산월 : 2015년 12월인 경우<br>2016.04.01 ~ 2017.03.31<br>직전년도 결산월 : 2015년 3월인 경우<br>2015.07.01 ~ 2016.06.30'
	});
	
	// 다음버튼
	$("#btn_next_step").click(function(){
		$("#dataForm").submit();
	});
	
	// 결산월 초기화
	$("#ad_stacnt_mt_ho").val("");
	
});

function innerHtmlIssuYear(start, end) {
	var htmlContent = "";
	/* for(var year=end; year>=start; year--) {		
		htmlContent += "<option value='"+year+"'>"+year+"</option>";
	} */
	
	<%-- 고객의 요청에 의해서 최종년도만 출력됨. (2015-03-23) --%>
	/* htmlContent += "<option value='"+(end+1)+"'>"+(end+1)+"</option>"; */
	htmlContent += "<option value='"+end+"'>"+end+"</option>";
	/* htmlContent += "<option value='"+(end-1)+"'>"+(end-1)+"</option>"; */
	/* htmlContent += "<option value='"+end+"'>"+end+"</option>"; */
	$("#ad_confm_target_yy").html(htmlContent);
	$("#ad_confm_target_yy").change();
}

function innerHtmlReqstYear(end) {
	var htmlContent = "";
	
	<%-- 결산월 선택에 따라 유효기간년도(확인신청년도) 변경이 애매하다 --%>
	htmlContent += "<option value='"+end+"'>"+end+"</option>";
	htmlContent += "<option value='"+(end-1)+"'>"+(end-1)+"</option>";
	htmlContent += "<option value='"+(end-2)+"'>"+(end-2)+"</option>";
	$("#ad_stacnt_mt_yy").html(htmlContent);
	$("#ad_stacnt_mt_yy").change();
}
</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		
		<input type="hidden" id="ad_jurirno" name="ad_jurirno" value="${param.ad_jurirno}" />
		<input type="hidden" id="ad_user_no" name="ad_user_no" value="${param.ad_user_no}" />
		<input type="hidden" id="ad_admin_new_at" name="ad_admin_new_at" value="Y" />
		<input type="hidden" id="ad_win_type" name="ad_win_type" value="adminedit" />
		<input type="hidden" id="ad_view_type" name="ad_view_type" value="edit" />
		
		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title">발급업무관리</h2>
					<!-- 타이틀 영역 //-->
					
					<div class="block">
						<ul>
							<li class="d1">회원 정보상의 법인등록번호로 기업정보를 찾으실 수 있습니다.</li>
						</ul>
						
						<h3  class="mgt30">기업정보<span>항목은 입력 필수 항목 입니다.</span></h3>
						<table cellpadding="0" cellspacing="0" class="table_basic" summary="기업확인신청입력" >
							<caption>기업확인신청입력</caption>
							<colgroup>
								<col style="width:20%" />
								<col style="width:25%" />
								<col style="width:20%" />
								<col style="width:*" />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="point"><label for="ad_entrprs_nm">기업명</label></th>
									<td><input name="ad_entrprs_nm" type="text" id="ad_entrprs_nm" value="${fn:replace(param.ad_entrprs_nm, '&amp;', '&')}" class="text" placeholder="귀사의 기업명을 입력해 주세요." onfocus="this.placeholder=''; return true" style="width:150px;"/></td>
									<th scope="row" class="point"><label for="excpt_trget_at_radio1">특례대상여부</label></th>
									<td>
										<div class="txt_a">
											<input type="radio" id="excpt_trget_at_radio1" name="ad_excpt_trget_at" value="Y" /><label for="excpt_trget_at_radio1">예</label>
											<input type="radio" id="excpt_trget_at_radio2" name="ad_excpt_trget_at" value="N" checked="checked" /><label for="excpt_trget_at_radio2">아니오</label>
										</div>
									</td>
								</tr>
								<tr>
									<th scope="row">법인등록번호</th>
									<td>${param.ad_jurirno.substring(0,6)}-${param.ad_jurirno.substring(6)}</td>
									<th scope="row" class="point"><label for="ad_bizrno_first">사업자등록번호</label></th>
									<td>
										<input name="ad_bizrno_first" type="text" id="ad_bizrno_first" value="${param.ad_bizrno.substring(0,3)}" class="text" style="width:60px;" title="사업자등록번호앞번호" />
										~ 
										<input name="ad_bizrno_middle" type="text" id="ad_bizrno_middle" value="${param.ad_bizrno.substring(3,5)}" class="text" style="width:30px;" title="사업자등록번호가운데번호" />
										~ 
										<input name="ad_bizrno_last" type="text" id="ad_bizrno_last" value="${param.ad_bizrno.substring(5)}" class="text" style="width:60px;" title="사업자등록번호마지막번호" />
									</td>
								</tr>
								<tr>
									<th scope="row" class="point">
										<label for="ad_stacnt_mt_ho">직전년도<br>&nbsp;&nbsp;결산월 <img src="<c:url value="/images/ucm/btn_code.png" />" id="add_tooltip" alt="?" width="20" height="20"  /></label>
									</th>
									<td>
										<select name="ad_stacnt_mt_yy" id="ad_stacnt_mt_yy" style="width:80px;">
											<option value="">- 선택 -</option>
										</select>
										<select name="ad_stacnt_mt_ho" id="ad_stacnt_mt_ho" style="width:80px;">
											<option value="">- 선택 -</option>
											<c:forTokens items="${MONTHS_TOKEN}" delims="," var="month">	                                                
												<option value="${month}">${month}</option>										
											</c:forTokens>
										</select>
									</td>
									<th scope="row" class="point"><label for="ad_confm_target_yy">확인신청년도 <img src="<c:url value="/images/ucm/btn_code.png" />" id="add_tooltip2" alt="?" width="20" height="20"  /></label></th>
									<td>
										<select name="ad_confm_target_yy" id="ad_confm_target_yy" style="width:90px;">
											<option value="">-- 선택 --</option>
										</select>
										<input type="hidden" id="ad_jdgmnt_reqst_year" name="ad_jdgmnt_reqst_year" />
										<span style="display:inline-block">
											유효기간 예시) 2016.04.01 ~ 2017.03.31
										</span>
									</td>
								</tr>
							</tbody>
						</table>
						
						<!--//페이지버튼-->
						 <div class="btn_page_last">
							<a class="btn_page_admin" href="#none" id="btn_next_step"><span>다음</span></a>
						</div>
						<!--페이지버튼//-->
					</div>
				</div>
			</div>
		</div>
		<!--content//-->
	</form>
</body>
</html>