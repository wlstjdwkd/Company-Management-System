<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>	
<ap:jsTag type="web" items="jquery,form,validate,selectbox,msgBox,jBox" />
<ap:jsTag type="tech" items="msg,util,cmn, mainn, subb, font,ic" />
<ap:globalConst />
<c:set var="entUserVo" value="${sessionScope[SESSION_ENTUSERINFO_NAME]}" />

<script type="text/javascript">
$(document).ready(function(){
	var existedTempData = "${existedTempData}";
	var tempTargetYear = "${tempTargetYear}";
	var existedApplyData = "N";
	var tempStacntMtYear = "${ad_stacnt_mt_yy}";
	
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
			// 기본확인사항			
			var val01 = $(":input:radio[name=ad_check_01]:checked").val();
			var val02 = $(":input:radio[name=ad_check_02]:checked").val();
			var val03 = $(":input:radio[name=ad_check_03]:checked").val();
			var val04 = $(":input:radio[name=ad_check_04]:checked").val();
						
			if(val01=="Y"||val02=="Y"||val03=="Y"||val04=="Y"){
				jsMsgBox(null, 'info', Message.msg.rejectIcStep01);
				return;
			}			
			
			if(existedApplyData == "Y"){
				jsMsgBox(null
						,'confirm'
						,Message.msg.existedApplyData
						,function(){							
							jsMoveMenu('7','120','PGMY0060');
						}						
				);
			}else if(existedTempData=="Y" && tempTargetYear == $("#ad_confm_target_yy").val()){				
				jsMsgBox(null
						,'confirm'
						,Message.msg.existedTempApplyData
						,function(){
							$("#ad_load_data").val("Y");
							form.action="PGIC0022.do";
							form.submit();
						}
						,function(){
							form.action="PGIC0021.do";
							form.submit();
						}
				);
			}else{
				form.action="PGIC0021.do";
				form.submit();
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
		        url      : "PGIC0020.do",
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
		var issu_year = $(this).val();
		
		if(issu_year) {
			$.ajax({        
		        url      : "PGIC0020.do",
		        type     : "POST",
		        dataType : "json",
		        data     : { df_method_nm: "pblictePossibleAt"        	       
		        	       	, ad_stacnt_mt_ho: $("#ad_stacnt_mt_ho").val()
		        	       	, ad_issu_year: issu_year - 1
		        	       },                
		        async    : false,                
		        success  : function(response) {
		        	try {        		
		        		if(response.result) {
		        			var valueObj = response.value;    				 	
		        			if(valueObj.mutual_invest_limit_at == "Y"){
		        				$("input:radio[name='ad_check_01']").eq(0).prop("checked", "checked");
		        				$("#mutual_invest_txt").show();
		        			}else{
		        				$("input:radio[name='ad_check_01']").eq(1).prop("checked", "checked");
		        				$("#mutual_invest_txt").hide();
		        			}
		        			
		        			if(valueObj.last_year_at) {
		        				$("#smba_ask").show();
		        				
		        				if(valueObj.smba_at == "Y") {
		        					var process_de = valueObj.process_de_fmt;
		        					$("input:radio[name='ad_check_04']").eq(0).prop("checked", "checked");
		        					$("#smba_date").text(process_de.first + "년 " + process_de.middle + "월 " + process_de.last + "일");
		        					$("#smba_txt").show();
		        				}else{
		        					$("input:radio[name='ad_check_04']").eq(1).prop("checked", "checked");
		        					$("#smba_txt").hide();
		        				}
		        				
		        			}else{
		        				$("input:radio[name='ad_check_04']").eq(1).prop("checked", "checked");
		        				$("#smba_ask").hide();
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
	htmlContent += "<option value='"+(end-1)+"' selected='selected'>"+(end-1)+"</option>";
	htmlContent += "<option value='"+(end-2)+"' selected='selected'>"+(end-2)+"</option>";
	$("#ad_stacnt_mt_yy").html(htmlContent);
	$("#ad_stacnt_mt_yy").change();
}
</script>
</head>
<body>
<form name="dataForm" id="dataForm" method="post" action="PGIC0021.do">
<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />
<input type="hidden" id="ad_load_data" name="ad_load_data" value="N" />
<input type="hidden" id="ad_load_rcept_no" name="ad_load_rcept_no" value="${loadRceptNo}" />
<c:set var="entUserVo" value="${sessionScope[SESSION_ENTUSERINFO_NAME]}" />
<!--//content-->
<div id="wrap">
	<div class="s_cont" id="s_cont">
		<div class="s_tit s_tit02">
			<h1>기업확인</h1>
		</div>
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit tit2">기업확인</h2>
				<ul>
				</ul>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}" />
				</div>
				<div class="r_cont s_cont02_03">
					<div class="step_sec">
						<ul>
							<li class="on">1.기본확인</li><!--공백제거
							--><li class="arr"> </li><!--공백제거
							--><li>2.약관동의</li><!--공백제거
							--><li class="arr"></li><!--공백제거
							--><li>3.신청서작성</li><!--공백제거
							--><li class="arr"></li><!--공백제거
							--><li>4.신청완료</li>
						</ul>
					</div>
					<div class="list_bl">
						<h4 class="fram_bl">기업정보 <span>(사업자등록증과 동일하게 작성)</span><p><img src="/images2/sub/table_check.png">항목은 입력 필수 항목입니다.</p></h4>
						<table class="table_form">
							<caption>기업정보</caption>
							<colgroup>
								<col width="172px">
								<col width="273px">
								<col width="173px">
								<col width="272px">
							</colgroup>
							<tbody>
								<tr>
									<th><img src="/images2/sub/table_check.png">기업명</th>
									<%-- <td class="b_l_0"><input type="text" name="ad_entrprs_nm" id="ad_entrprs_nm" value="${fn:replace(entUserVo.entrprsNm, '&amp;', '&')}"></td> --%>
									<td class="b_l_0">${fn:replace(entUserVo.entrprsNm, '&amp;', '&')}</td>
									<input type="hidden" name="ad_entrprs_nm" id="ad_entrprs_nm" value="${fn:replace(entUserVo.entrprsNm, '&amp;', '&')}">
									<th><img src="/images2/sub/table_check.png">특례대상여부</th>
									<td class="b_l_0">
										<ul class="radio_sy">
											<li style="margin-right: 35px;">
												<input type="radio" id="excpt_trget_at_radio1" value="Y" name="ad_excpt_trget_at" >
												<label for="excpt_trget_at_radio1"></label>
												<label for="excpt_trget_at_radio1">예</label>
											</li>
											<li>
												<input type="radio" id="excpt_trget_at_radio2" value="N" name="ad_excpt_trget_at" checked="check">
												<label for="excpt_trget_at_radio2"></label>
												<label for="excpt_trget_at_radio2">아니요&nbsp;&nbsp;&nbsp;(필요시 ‘예’ 선택) </label>
											</li>
										</ul>
									</td>
								</tr>
								<tr>
									<th class="p_l_30">법인등록번호</th>
									<td class="b_l_0">${entUserVo.jurirno.substring(0,6)}-${entUserVo.jurirno.substring(6)}</td>
									<th><img src="/images2/sub/table_check.png">사업자등록번호</th>
									<%-- <td class="b_l_0"><input type="text" name="ad_bizrno_first" id="ad_bizrno_first" value="${entUserVo.bizrno.substring(0,3)}" style="width:76px; margin-right: 3px; ">-<input type="text" name="ad_bizrno_middle" id="ad_bizrno_middle" value="${entUserVo.bizrno.substring(3,5)}" style="width: 56px; margin-left: 3px; margin-right: 3px;">-<input type="text" name="ad_bizrno_last" id="ad_bizrno_last" value="${entUserVo.bizrno.substring(5)}" style="width: 79px; margin-left: 3px;"></td> --%>
									<td class="b_l_0">${entUserVo.bizrno.substring(0,3)}-${entUserVo.bizrno.substring(3,5)}-${entUserVo.bizrno.substring(5)}</td>
									<input type="hidden" name="ad_bizrno_first" id="ad_bizrno_first" value="${entUserVo.bizrno.substring(0,3)}" style="width:76px; margin-right: 3px; ">
									<input type="hidden" name="ad_bizrno_middle" id="ad_bizrno_middle" value="${entUserVo.bizrno.substring(3,5)}" style="width: 56px; margin-left: 3px; margin-right: 3px;">
									<input type="hidden" name="ad_bizrno_last" id="ad_bizrno_last" value="${entUserVo.bizrno.substring(5)}" style="width: 79px; margin-left: 3px;">
								</tr>
								<tr>
									<th><img src="/images2/sub/table_check.png">직전년도 결산월<img src="/images2/sub/help_btn.png" class="help_btn"></th>
									<td class="b_l_0"><!-- 공백제거
										 --><select class="select_box" name="ad_stacnt_mt_yy" id="ad_stacnt_mt_yy" style="width:90px;">
                                           	<option value="">- 선택 -</option>
                                       	</select>
                                       	<select class="select_box" name="ad_stacnt_mt_ho" id="ad_stacnt_mt_ho" style="width:90px;">
                                          	<option value="">- 선택 -</option>
                                             <c:forTokens items="${MONTHS_TOKEN}" delims="," var="month">	                                                
												<option value="${month}">${month}</option>										
											</c:forTokens>
                                        </select>
									</td>
									<th><img src="/images2/sub/table_check.png">확인신청년도<img src="/images2/sub/help_btn.png"  class="help_btn"></th>
									<td class="b_l_0">
                                        <select class="select_box" name="ad_confm_target_yy" id="ad_confm_target_yy" style="width:90px;">
                                           	<option value="">- 선택 -</option>
                                       	</select>
	                                    <input type="hidden" id="ad_jdgmnt_reqst_year" name="ad_jdgmnt_reqst_year" />
										<p class="ex">유효기간 예시) 2016.04.01~2017.03.31</p>
									</td>
								</tr>
							</tbody>
						</table>
						<p class="wrong">
							* 직전 사업연도는 결산월 선택 시, 확인신청년도는 자동으로 반영<br/>
							* 유효기간: 직전사업연도 결산월말 기준 3개월 이후부터 1년간의 유효기간 부여
						</p>
					</div>
					<div class="list_bl">
						<h4 class="fram_bl">기본확인사항</h4>
						<table class="table_wht">
							<caption>기본확인사항</caption>
							<colgroup>
								<col width="*">
								<col width="170px">
							</colgroup>
							<tbody>
								<tr>
									<th style="padding-left: 25px;">1.현재 상호출자제한 기업집단에 속하는가?<span> → 문의 : 공정거래위원회</span></th>
									<td>
										<ul class="radio_sy">
											<li style="margin-right: 35px;">
												<input type="radio" id="radio1" name="ad_check_01" value="Y" disabled="disabled">
												<label for="radio1"></label>
												<label for="radio1">예</label>
											</li>
											<li>
												<input type="radio" id="radio2" name="ad_check_01" value="N" disabled="disabled" checked="check">
												<label for="radio2"></label>
												<label for="radio2">아니요</label>
											</li>
										</ul>
									</td>
								</tr>
								<tr>
									<th style="padding-left: 25px;">2.자산총액 10조원 이상인 외국법인이 발행주식 총수의 30%이상을 직접적, 간접적으로 소유한 <br/>&nbsp;&nbsp;&nbsp;최대주주인 기업이 있는가?<span>  → 문의 : 소속 기업(법인)해당 업무 담당자</span></th>
									<td>
										<ul class="radio_sy">
											<li style="margin-right: 35px;">
												<input type="radio" id="radio3" name="ad_check_02" value="Y" >
												<label for="radio3"></label>
												<label for="radio3">예</label>
											</li>
											<li>
												<input type="radio" id="radio4" name="ad_check_02" value="N" checked="check">
												<label for="radio4"></label>
												<label for="radio4">아니요</label>
											</li>
										</ul>
									</td>
								</tr>
								<tr>
									<th style="padding-left: 25px;">3.중소기업 유예기간에 해당하는가?<span>  → 문의 : 중소벤처기업부 관할 지방청</span></th>
									<td>
										<ul class="radio_sy">
											<li style="margin-right: 35px;">
												<input type="radio" id="radio5" name="ad_check_03" value="Y" >
												<label for="radio5"></label>
												<label for="radio5">예</label>
											</li>
											<li>
												<input type="radio" id="radio6" name="ad_check_03" value="N" checked="check">
												<label for="radio6"></label>
												<label for="radio6">아니요</label>
											</li>
										</ul>
									</td>
								</tr>
								<tr>
									<th style="padding-left: 25px;">4.중소기업확인을 받았는가?<span>  → 문의 : 중소벤처기업부 관할 지방청</span></th>
									<td>
										<ul class="radio_sy">
											<li style="margin-right: 35px;">
												<input type="radio" id="radio7" name="ad_check_04" value="Y" disabled="disabled">
												<label for="radio7"></label>
												<label for="radio7">예</label>
											</li>
											<li>
												<input type="radio" id="radio8" name="ad_check_04" value="N" disabled="disabled" checked="check">
												<label for="radio8"></label>
												<label for="radio8">아니요</label>
											</li>
										</ul>
									</td>
								</tr>
							</tbody>
						</table>
						<p class="wrong">
							<br/>※ 기본확인사항에 단 하나라도 해당하는 경우 기업에서 제외되어 확인신청을 하실 수 없습니다.
						</p>
					</div>
					<div class="btn_bl">
						<a href="#none" id="btn_next_step">다음</a>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!--content//-->

</form>

</body>
</html>
