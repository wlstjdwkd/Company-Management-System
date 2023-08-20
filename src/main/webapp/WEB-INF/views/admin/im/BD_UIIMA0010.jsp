<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>정보</title>
<ap:jsTag type="web" items="jquery,form,colorboxAdmin,selectbox,validate,mask,notice,msgBoxAdmin,ui,json" />
<ap:jsTag type="tech" items="msg,util,acm" />
<ap:globalConst />	
<script type="text/javascript">
$(document).ready(function(){
	// 발급대상년도 초기화
	/* var fromYear = 2011;
	var toYear = Util.date.getLocalYear(); */
	//$("#jdgmnt_reqst_year_search").numericOptions({from:fromYear,to:toYear,sort:"desc"});
	//$("#confm_target_year_search").numericOptions({from:fromYear,to:toYear,sort:"desc"});
	
	/* <c:if test="${!empty param.ad_jdgmnt_reqst_year}">
	$("#jdgmnt_reqst_year_search").val(${param.ad_jdgmnt_reqst_year});
	</c:if> */
	/* <c:if test="${!empty param.ad_confm_target_yy}">
	$("#confm_target_year_search").val(${param.ad_confm_target_yy});
	</c:if>	 */

	if(${empty param.ad_reqst_se}){
		for(i=1; i < document.getElementsByName("reqst_se_search").length; i++) {
			document.getElementsByName("reqst_se_search")[i].checked = true;
		}
	}
	if(${empty param.ad_se_code_s}){
		for(i=1; i < document.getElementsByName("se_code_s_search").length; i++) {
			document.getElementsByName("se_code_s_search")[i].checked = true;
		}
	}
	/* 
	if(${empty param.ad_se_code_r}){
		for(i=1; i < document.getElementsByName("se_code_r_search").length; i++) {
			document.getElementsByName("se_code_r_search")[i].checked = true;
		}
	} 
	*/
	if(${empty param.ad_confm_target_yy}){
		for(i=1; i < document.getElementsByName("confm_target_year_search").length; i++) {
			document.getElementsByName("confm_target_year_search")[i].checked = true;
		}
	}
	if(${empty param.ad_excpt_trget_at}){
		for(i=1; i < document.getElementsByName("excpt_trget_at_search").length; i++) {
			document.getElementsByName("excpt_trget_at_search")[i].checked = true;
		}
	}
	if(${empty param.ad_item}){
		for(i=1; i < document.getElementsByName("item_search").length; i++) {
			document.getElementsByName("item_search")[i].checked = true;
		}
	}

	count_check('reqst_se_search');
	count_check('se_code_s_search');
	count_check('se_code_r_search');
	count_check('confm_target_year_search');
	count_check('excpt_trget_at_search');
	count_check('item_search');
	
	$("#btn_search_issue").on("click",function(){
		
		/* 
		// 신청구분
		$("#ad_reqst_se").val($("#reqst_se_search option:selected").val());
		// 진행단계
		$("#ad_se_code_s").val($("#se_code_s_search option:selected").val());
		// 처리결과
		$("#ad_se_code_r").val($("#se_code_r_search option:selected").val());
		// 발급대상년도
		//$("#ad_jdgmnt_reqst_year").val($("#jdgmnt_reqst_year_search option:selected").val());
		$("#ad_confm_target_yy").val($("#confm_target_year_search option:selected").val());
		// 조회항목
		$("#ad_item").val($("#item_search option:selected").val());
		$("#ad_item_value").val($("#item_value_search").val());
		// 접수기간
		$("#ad_rcept_de_from").val($("#rcept_de_from_search").val());
		$("#ad_rcept_de_to").val($("#rcept_de_to_search").val());
		// 발급기간
		$("#ad_issu_de_from").val($("#issu_de_from_search").val());
		$("#ad_issu_de_to").val($("#issu_de_to_search").val());
		// 보완접수만
		var onlySplemnt = $("input:checkbox[id='chk_only_splemnt']").is(":checked");		
		if(onlySplemnt){
			$("#ad_only_splemnt").val("Y");	
		}else{
			$("#ad_only_splemnt").val("N");
		}
		// 특례대상여부
		$("#ad_excpt_trget_at").val($("#excpt_trget_at_search").val()); 
		*/
		
		// 신청구분
		$("#ad_reqst_se").val(getCheckboxValues('reqst_se_search'));
		// 진행단계
		$("#ad_se_code_s").val(getCheckboxValues('se_code_s_search'));
		// 처리결과
		$("#ad_se_code_r").val(getCheckboxValues('se_code_r_search'));
		// 발급대상년도
		$("#ad_confm_target_yy").val(getCheckboxValues('confm_target_year_search'));
		// 특례대상여부
		$("#ad_excpt_trget_at").val(getCheckboxValues('excpt_trget_at_search'));
		// 조회항목
		$("#ad_item").val(getCheckboxValues('item_search'));
		$("#ad_item_value").val($("#item_value_search").val());
		// 접수기간
		$("#ad_rcept_de_from").val($("#rcept_de_from_search").val());
		$("#ad_rcept_de_to").val($("#rcept_de_to_search").val());
		// 발급기간
		$("#ad_issu_de_from").val($("#issu_de_from_search").val());
		$("#ad_issu_de_to").val($("#issu_de_to_search").val());
		// 보완접수만
		var onlySplemnt = $("input:checkbox[id='chk_only_splemnt']").is(":checked");		
		if(onlySplemnt){
			$("#ad_only_splemnt").val("Y");	
		}else{
			$("#ad_only_splemnt").val("N");
		}
		$("#df_method_nm").val("getData");
		$("#dataForm").submit();
	});
	
	// 엔터키로 검색
	$("#item_value_search").keyup(function(e) {
		if(e.keyCode == 13) {
			/* 
			// 신청구분
			$("#ad_reqst_se").val($("#reqst_se_search option:selected").val());
			// 진행단계
			$("#ad_se_code_s").val($("#se_code_s_search option:selected").val());
			// 처리결과
			$("#ad_se_code_r").val($("#se_code_r_search option:selected").val());
			// 발급대상년도
			//$("#ad_jdgmnt_reqst_year").val($("#jdgmnt_reqst_year_search option:selected").val());
			$("#ad_confm_target_yy").val($("#confm_target_year_search option:selected").val());
			// 조회항목
			$("#ad_item").val($("#item_search option:selected").val());
			$("#ad_item_value").val($("#item_value_search").val());
			// 접수기간
			$("#ad_rcept_de_from").val($("#rcept_de_from_search").val());
			$("#ad_rcept_de_to").val($("#rcept_de_to_search").val());
			// 발급기간
			$("#ad_issu_de_from").val($("#issu_de_from_search").val());
			$("#ad_issu_de_to").val($("#issu_de_to_search").val());
			// 보완접수만
			var onlySplemnt = $("input:checkbox[id='chk_only_splemnt']").is(":checked");		
			if(onlySplemnt){
				$("#ad_only_splemnt").val("Y");	
			}else{
				$("#ad_only_splemnt").val("N");
			}
			// 특례대상여부
			$("#ad_excpt_trget_at").val($("#excpt_trget_at_search").val()); 
			*/
			// 신청구분
			$("#ad_reqst_se").val(getCheckboxValues('reqst_se_search'));
			// 진행단계
			$("#ad_se_code_s").val(getCheckboxValues('se_code_s_search'));
			// 처리결과
			$("#ad_se_code_r").val(getCheckboxValues('se_code_r_search'));
			// 발급대상년도
			$("#ad_confm_target_yy").val(getCheckboxValues('confm_target_year_search'));
			// 특례대상여부
			$("#ad_excpt_trget_at").val(getCheckboxValues('excpt_trget_at_search'));
			// 조회항목
			$("#ad_item").val(getCheckboxValues('item_search'));
			$("#ad_item_value").val($("#item_value_search").val());
			// 접수기간
			$("#ad_rcept_de_from").val($("#rcept_de_from_search").val());
			$("#ad_rcept_de_to").val($("#rcept_de_to_search").val());
			// 발급기간
			$("#ad_issu_de_from").val($("#issu_de_from_search").val());
			$("#ad_issu_de_to").val($("#issu_de_to_search").val());
			// 보완접수만
			var onlySplemnt = $("input:checkbox[id='chk_only_splemnt']").is(":checked");		
			if(onlySplemnt){
				$("#ad_only_splemnt").val("Y");	
			}else{
				$("#ad_only_splemnt").val("N");
			}
			
			$("#df_method_nm").val("getData");
			$("#dataForm").submit();
		}
	});
	
	$("#btn_edit_porcess_excpt").on("click",function(){		
		
		var chkedCnt=0;
		var no = 1;
		var result = "";
		$("input:checkbox[name='chk']").each(function(){
			if($(this).is(":checked")){
				result = result + ',' + $("#excpt_trget_at_rslt_" + no).val();
				chkedCnt++;	
			}
			no++;
		});
		
		if(chkedCnt<=0){
			jsMsgBox(null,'info',Message.msg.selectStatusStep);
			return;
		}
		
		$("#df_method_nm").val("updateExcptProcess");
		$("#ad_excpt_trget_at_rslt").val(result);
		// 폼 데이터
    	$("#dataForm").ajaxSubmit({
            url      : "PGIM0010.do",
            data     : {},
            dataType : "text",            
            async    : false,            
            beforeSubmit : function(){
            },            
            success  : function(response) {
            	try {
            		if(eval(response)){
            			$("#df_method_nm").val("getData");
            			$("#dataForm").submit();
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
	
	$("#btn_edit_porcess_step").on("click",function(){		
		
		var chkedCnt=0;
		$("input:checkbox[name='chk']").each(function(){
			if($(this).is(":checked")){
				chkedCnt++;	
			}
		});
		
		if(chkedCnt<=0){
			jsMsgBox(null,'info',Message.msg.selectStatusStep);
			return;
		}
		
		$("#df_method_nm").val("updateProcessStep");
		// 폼 데이터
    	$("#dataForm").ajaxSubmit({
            url      : "PGIM0010.do",
            data     : {},
            dataType : "text",            
            async    : false,            
            beforeSubmit : function(){
            },            
            success  : function(response) {
            	try {
            		if(eval(response)){
            			$("#df_method_nm").val("getData");
            			$("#dataForm").submit();
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
	
	$("#btn_edit_porcess_judgment").on("click",function(){		
		var check = "check";
		var elems = "judg";
		var chkedCnt=0;
		
		$("input:checkbox[name='chk']").each(function(){
			if($(this).is(":checked")){
				chkedCnt++;	
				//$("#ad_jdgmnt_code").val($(this).parent().parent().find("#ad_jdg").val());
				check = check + "," + $(this).val();
				elems = elems + "," + $(this).parent().parent().find("#ad_jdg").val();
			}
		});

		$('#ad_check_rcept_code').val(check);
		$('#ad_jdgmnt_code').val(elems); //store array

		if(chkedCnt<=0){
			jsMsgBox(null,'info',Message.msg.selectStatusStep);
			return;
		}
		
		$("#df_method_nm").val("updateJudgmentResn");
		
		// 폼 데이터
    	$("#dataForm").ajaxSubmit({
            url      : "PGIM0010.do",
            data     : {},
            dataType : "text",            
            async    : false,            
            beforeSubmit : function(){
            },            
            success  : function(response) {
            	try {
            		if(eval(response)){
            			$("#df_method_nm").val("getData");
            			$("#dataForm").submit();
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
	
	$("#btn_excel_down").click(function(){
		/* // 신청구분
		$("#ad_reqst_se").val($("#reqst_se_search option:selected").val());
		// 진행단계
		$("#ad_se_code_s").val($("#se_code_s_search option:selected").val());
		// 처리결과
		$("#ad_se_code_r").val($("#se_code_r_search option:selected").val());
		// 발급대상년도
		//$("#ad_jdgmnt_reqst_year").val($("#jdgmnt_reqst_year_search option:selected").val());
		$("#ad_confm_target_yy").val($("#confm_target_year_search option:selected").val());
		// 조회항목
		$("#ad_item").val($("#item_search option:selected").val());
		$("#ad_item_value").val($("#item_value_search").val());
		// 접수기간
		$("#ad_rcept_de_from").val($("#rcept_de_from_search").val());
		$("#ad_rcept_de_to").val($("#rcept_de_to_search").val());
		// 발급기간
		$("#ad_issu_de_from").val($("#issu_de_from_search").val());
		$("#ad_issu_de_to").val($("#issu_de_to_search").val());
		// 보완접수만
		var onlySplemnt = $("input:checkbox[id='chk_only_splemnt']").is(":checked");		
		if(onlySplemnt){
			$("#ad_only_splemnt").val("Y");	
		}else{
			$("#ad_only_splemnt").val("N");
		}
		// 특례대상여부
		$("#ad_excpt_trget_at").val($("#excpt_trget_at_search").val());
		 */
		 
		// 신청구분
		$("#ad_reqst_se").val(getCheckboxValues('reqst_se_search'));
		// 진행단계
		$("#ad_se_code_s").val(getCheckboxValues('se_code_s_search'));
		// 처리결과
		$("#ad_se_code_r").val(getCheckboxValues('se_code_r_search'));
		// 발급대상년도
		$("#ad_confm_target_yy").val(getCheckboxValues('confm_target_year_search'));
		// 특례대상여부
		$("#ad_excpt_trget_at").val(getCheckboxValues('excpt_trget_at_search'));
		// 조회항목
		$("#ad_item").val(getCheckboxValues('item_search'));
		$("#ad_item_value").val($("#item_value_search").val());
		// 접수기간
		$("#ad_rcept_de_from").val($("#rcept_de_from_search").val());
		$("#ad_rcept_de_to").val($("#rcept_de_to_search").val());
		// 발급기간
		$("#ad_issu_de_from").val($("#issu_de_from_search").val());
		$("#ad_issu_de_to").val($("#issu_de_to_search").val());
		// 보완접수만
		var onlySplemnt = $("input:checkbox[id='chk_only_splemnt']").is(":checked");		
		if(onlySplemnt){
			$("#ad_only_splemnt").val("Y");	
		}else{
			$("#ad_only_splemnt").val("N");
		}
		
		$("#df_method_nm").val("excelRsolver");
		$("#dataForm").submit();
    	//jsFiledownload("/PGIM0010.do","df_method_nm=excelRsolver");
    });	
	
	initDatepicker();
	
	//최상단 체크박스 클릭
    $("#checkall").click(function(){
        //클릭되었으면
        if($("#checkall").prop("checked")){
            //input태그의 name이 chk인 태그들을 찾아서 checked옵션을 true로 정의
            $("input[name=chk]").prop("checked",true);
            //클릭이 안되있으면
        }else{
            //input태그의 name이 chk인 태그들을 찾아서 checked옵션을 false로 정의
            $("input[name=chk]").prop("checked",false);
        }
    });
    
	// 확인서 신청 등록
	$("#btn_rcept_reqst").click(function() {
		$("#df_method_nm").val("confmInsert1");
		$("#dataForm").submit();
	});
	
	$("#ad_not_init_flag").val("Y"); 
});

function setCalendar(id, type, val){
	
	var fromId = id+"_de_from_search";
	var toId = id+"_de_to_search";
	var adId = "ad_"+id+"_de_all";
	
	if(type=="all"){
		$("#"+fromId).attr("disabled",true);
		$("#"+toId).attr("disabled",true);
		$("#"+adId).val("Y");
	}else{
		var yyyyMMdd = Util.date.getLocalToday();
		val = Number(val);
		
		var from;
		var to = yyyyMMdd;
		
		switch(type){
		case 'year':
			from = Util.date.addYear(yyyyMMdd,val);
			break;
		case 'month':
			from = Util.date.addMonth(yyyyMMdd,val);
			break;
		case 'day':
			from = Util.date.addDate(yyyyMMdd,val);
			break;
		}	
		
		var test = new Date().toFormatString("yyyy-MM-dd");
		from = new Date(parseInt(from.substr(0, 4)),parseInt(from.substr(4, 2))-1,parseInt(from.substr(6, 2))).toFormatString("yyyy-MM-dd");
		to = new Date(parseInt(to.substr(0, 4)),parseInt(to.substr(4, 2))-1,parseInt(to.substr(6, 2))).toFormatString("yyyy-MM-dd");
		
		$("#"+fromId).val(from);
		$("#"+toId).val(to);
		
		$("#"+fromId).attr("disabled",false);
		$("#"+toId).attr("disabled",false);
		$("#"+adId).val("N");
	}
}


function setCalendar2(id){
	var fromId = id+"_de_from_search";
	var toId = id+"_de_to_search";
	var adId = "ad_"+id+"_de_all";
	
	$("#"+fromId).attr("disabled",false);
	$("#"+toId).attr("disabled",false);
	$("#"+adId).val("N");
}



//설립년월일(달력) 초기화
function initDatepicker(){
	$('.datepicker').datepicker({
        showOn : 'button',        
        buttonImage : '<c:url value="/images/acm/icon_cal.png" />',
        buttonImageOnly : true,
        changeYear: true,
        changeMonth: true,
        yearRange: "2012:+0"
    });
	$('.datepicker').mask('0000-00-00');	
	
	$('#rcept_de_from_search').datepicker("setDate", Util.isEmpty($("#ad_rcept_de_from").val())?new Date():$("#ad_rcept_de_from").val());
	$('#rcept_de_to_search').datepicker("setDate", Util.isEmpty($("#ad_rcept_de_to").val())?new Date():$("#ad_rcept_de_to").val());
	
	$('#issu_de_from_search').datepicker("setDate", Util.isEmpty($("#ad_issu_de_from").val())?new Date():$("#ad_issu_de_from").val());
	$('#issu_de_to_search').datepicker("setDate", Util.isEmpty($("#ad_issu_de_to").val())?new Date():$("#ad_issu_de_to").val());
	
	
	if($("#ad_rcept_de_all").val()=="N"){
		$("#rcept_de_from_search").attr("disabled",false);
		$("#rcept_de_to_search").attr("disabled",false);
	}else{		
		$("#rcept_de_from_search").attr("disabled",true);
		$("#rcept_de_to_search").attr("disabled",true);
	}
	
	if($("#ad_issu_de_all").val()=="N"){
		$("#issu_de_from_search").attr("disabled",false);
		$("#issu_de_to_search").attr("disabled",false);
	}else{		
		$("#issu_de_from_search").attr("disabled",true);
		$("#issu_de_to_search").attr("disabled",true);
	}
}

function showRcepDetail(rceptNo, viewType, winType){
	$.colorbox({
        title : "신청서 상세",
        href  : "PGIC0022.do?ad_load_rcept_no="+rceptNo+"&ad_load_data=Y&ad_win_type="+winType+"&ad_view_type="+viewType,        
        width : "977px",
        height: "80%",            
        overlayClose : false,
        escKey : false,  
        iframe: true
    });
}

function showDetail(title, rceptNo, methodNm, readOnly, jurirno){
	var pgmId;	
	var scrolling;
	if(methodNm=="isgnResultView"){		
		pgmId = "PGMY0060";
		scrolling = true;
	}else{
		pgmId = "PGIM0010";
		scrolling = true;
	}
	$.colorbox({
        title : title,
        href  : pgmId+".do?df_method_nm="+methodNm+"&ad_rcept_no="+rceptNo+"&ad_readonly="+readOnly+"&ad_jurirno="+jurirno+"&ad_load_rcept_no="+rceptNo+"&auth=Y",        
        width : "85%",
        height: "80%",            
        overlayClose : false,
        escKey : false,  
        iframe: true,
        scrolling: scrolling
    });
}

var showSupplementDetail = function(title, rceptNo, reqstSeNm, methodNm, readOnly, jurirno){	
	var pgmId;
	var scrolling;
	if(methodNm=="isgnResultView"){		
		pgmId = "PGMY0060";
		scrolling = true;
	}else{
		pgmId = "PGIM0010";
		scrolling = false;
	}
	
	$("#df_method_nm").val(methodNm);
	$("#ad_rcept_no").val(rceptNo);
	$("#ad_readonly").val(readOnly);
	$("#ad_jurirno").val(jurirno);
	$("#ad_load_rcept_no").val(rceptNo);
	var supplementYn = 'Y';		// 보완접수, 보완요청에서 클릭 시 체크값
	var reqstNm = "";
	if(reqstSeNm=="발급신청"){
		reqstNm = "AK1";
	}else{
		reqstNm = "AK2";
	}
	
	//새창의 크기
	cw=700;
	ch=290;
	
	//스크린의 크기
	sw=screen.availWidth;
	sh=screen.availHeight;

	//열 창의 포지션
	px=(sw-cw)/2;
	py=(sh-ch)/2;
	
	var empmnInfoWindow = window.open('', 'showSupplementWinpop', 'width=700, height=290, top='+py+', left='+px+', fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, Internet Explorer.location=no, scrollbars=no');	
	document.dataForm.action = pgmId+".do?ad_rcept_no="+rceptNo+"&ad_readonly="+readOnly+"&ad_jurirno="+jurirno+"&ad_load_rcept_no="+rceptNo+"&supplementYn="+supplementYn+"&reqstNm="+reqstNm;
	document.dataForm.target = "showSupplementWinpop";
	document.dataForm.submit();
	document.dataForm.target = "";
	if(empmnInfoWindow){
		empmnInfoWindow.focus();
	}
};

function printCertIssue( issue_no, confm_se )
{
	/* $.colorbox({
        title : "기업확인서출력",
        href  : "PGIM0010.do?df_method_nm=printCertIssue&issueNo="+issue_no+"&confmSe="+confm_se,//+"&output=embed",        
        width : "980",
        height: "710",            
        overlayClose : false,
        escKey : false,  
        iframe: true,
        scrolling: true
    }); */
	
	window.open("PGIM0010.do?df_method_nm=processCertIssuetInfo&issueNo="+issue_no+"&confmSe="+confm_se,
			"printPop","width=700, height=750, scrollbars=yes, resizable=no");
}

// 진행단계 보완요청 선택시
function checkSupplement(obj, rceptNo) {
	var $this = $(obj);
	
	// 보완요청
	if($this.val() == "PS3") {
		showDetail('보완사유 등록',rceptNo,'showSupplement','N');
		$this.val('PS2');
	}
}

// checkbox 값 추출
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


</script>
</head>

<body>
<form name="dataForm" id="dataForm" method="post" action="/PGIM0010.do">
<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />
<ap:include page="param/pagingParam.jsp" />
<input type="hidden" id="ad_reqst_se" name="ad_reqst_se" value="${param.ad_reqst_se}" />
<input type="hidden" id="ad_se_code_s" name="ad_se_code_s" value="${param.ad_se_code_s}" />
<input type="hidden" id="ad_se_code_r" name="ad_se_code_r" value="${param.ad_se_code_r}" />
<%-- <input type="hidden" id="ad_jdgmnt_reqst_year" name="ad_jdgmnt_reqst_year" value="${param.ad_jdgmnt_reqst_year}" /> --%>
<%-- 
<c:choose>
	<c:when test="${param.ad_confm_target_yy eq null}">
		<input type="hidden" id="ad_confm_target_yy" name="ad_confm_target_yy" value="${currentYear}" />
	</c:when>
	<c:otherwise>
		<input type="hidden" id="ad_confm_target_yy" name="ad_confm_target_yy" value="${param.ad_confm_target_yy}" />
	</c:otherwise>
</c:choose> 
--%>
<input type="hidden" id="ad_confm_target_yy" name="ad_confm_target_yy" value="${param.ad_confm_target_yy}" />
<input type="hidden" id="ad_item" name="ad_item" value="${param.ad_item}" />
<input type="hidden" id="ad_item_value" name="ad_item_value" value="${param.ad_item_value}" />
<input type="hidden" id="ad_rcept_de_all" name="ad_rcept_de_all" value="${param.ad_rcept_de_all}" />
<input type="hidden" id="ad_rcept_de_from" name="ad_rcept_de_from" value="${param.ad_rcept_de_from}" />
<input type="hidden" id="ad_rcept_de_to" name="ad_rcept_de_to" value="${param.ad_rcept_de_to}" />
<input type="hidden" id="ad_issu_de_all" name="ad_issu_de_all" value="${param.ad_issu_de_all}" />
<input type="hidden" id="ad_issu_de_from" name="ad_issu_de_from" value="${param.ad_issu_de_from}" />
<input type="hidden" id="ad_issu_de_to" name="ad_issu_de_to" value="${param.ad_issu_de_to}" />
<input type="hidden" id="ad_edit_process_step" name="ad_edit_process_step" value="${param.ad_issu_de_to}" />
<input type="hidden" id="ad_only_splemnt" name="ad_only_splemnt" value="${param.ad_only_splemnt}" />
<input type="hidden" id="ad_excpt_trget_at" name="ad_excpt_trget_at" value="${param.ad_excpt_trget_at}" />
<input type="hidden" id="ad_check_rcept_code" name="ad_check_rcept_code" value=""/>
<input type="hidden" id="ad_jdgmnt_code" name="ad_jdgmnt_code" value=""/>
<input type="hidden" id="ad_rollback_flag" name="ad_rollback_flag" value=""/>
<input type="hidden" id="ad_not_init_flag" name="ad_not_init_flag" value="${param.ad_not_init_flag}"/>
<input type="hidden" id="ad_excpt_trget_at_rslt" name="ad_excpt_trget_at_rslt" value=""/>

<!--//content-->
<div id="wrap">
    <div class="wrap_inn">
        <div class="contents">
            <!--// 타이틀 영역 -->
            <h2 class="menu_title">발급업무관리</h2>
            <!-- 타이틀 영역 //-->
            <div class="search_top">
                <table cellpadding="0" cellspacing="0" class="table_search" summary="조회 조건">
                    <caption>&nbsp;
                    </caption>
                    <caption>
                    조회 조건
                    </caption>
                    <colgroup>
                    <col width="7%" />
                    <col width="21%" />
                    <col width="7%" />
                    <col width="35%" />
                    <col width="7%" />
                    <col width="19%" />
                    <col width="*" />
                    <col width="*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">신청구분</th>
                            <td>
                            	<ap:code id="reqst_se_search" grpCd="20" type="checkbox" selectedCd="${param.ad_reqst_se}" onclick="javascript:count_check('reqst_se_search');" ignoreCd="AK0" defaultLabel="전체"  option="style='width:50px'" />
                            </td>
                            <th scope="row">진행단계</th>
                            <td>
                            	<ap:code id="se_code_s_search" grpCd="18" type="checkbox" selectedCd="${param.ad_se_code_s}" onclick="javascript:count_check('se_code_s_search');" ignoreCd="PS0" defaultLabel="전체"   option="style='width:50px'" />
                            	<%-- &nbsp;&nbsp;<input type="checkbox" id="chk_only_splemnt" <c:if test="${param.ad_only_splemnt eq 'Y'}">checked</c:if> ><label for="chk_only_splemnt">보완접수만</label> --%>
                            </td>
                            <th scope="row">처리결과</th>
                            <td colspan="3">
                            	<ap:code id="se_code_r_search" grpCd="38" type="checkbox" selectedCd="${param.ad_se_code_r}" onclick="javascript:count_check('se_code_r_search');" defaultLabel="전체" option="style='width:50px'" />
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">특례대상</th>
                            <td>
                            	<ul>
                            		<li style="float:left;width:102px;"><input type="checkbox" name="excpt_trget_at_search" id="excpt_trget_at_search_all" value="" style="width:50px;" onclick="javascript:check_all('excpt_trget_at_search');" <c:if test="${!param.ad_excpt_trget_at}">checked</c:if> ><label for="excpt_trget_at_search_all">전체</label></li>
                            		<li style="float:left;width:102px;"><input type="checkbox" class="excpt_trget_at_search" name="excpt_trget_at_search" id="excpt_trget_at_search_y" value="Y" onclick="javascript:count_check('excpt_trget_at_search');" style="width:50px;" <c:if test="${fn:contains(param.ad_excpt_trget_at, 'Y')}">checked</c:if><%-- <c:if test="${param.ad_excpt_trget_at eq 'Y'}">checked</c:if> --%> ><label for="excpt_trget_at_search_y">예</label></li>
                            		<li style="float:left;width:102px;"><input type="checkbox" class="excpt_trget_at_search" name="excpt_trget_at_search" id="excpt_trget_at_search_n" value="N" onclick="javascript:count_check('excpt_trget_at_search');" style="width:50px;" <c:if test="${fn:contains(param.ad_excpt_trget_at, 'N')}">checked</c:if><%-- <c:if test="${param.ad_excpt_trget_at eq 'N'}">checked</c:if> --%> ><label for="excpt_trget_at_search_n">아니오</label></li>
                            	<%-- 
                            	<select name="excpt_trget_at_search" title="특례대상여부" id="excpt_trget_at_search" style="width:110px">
                            		<option value="">전체</option>
                            		<option value="Y" <c:if test="${param.ad_excpt_trget_at eq 'Y'}">selected</c:if>>예</option>
                            		<option value="N" <c:if test="${param.ad_excpt_trget_at eq 'N'}">selected</c:if>>아니오</option>
                            	</select> 
                            	--%>
                            	</ul>
                            </td>
                            <th scope="row">대상연도</th>
                            <td>
                            	<ul>
                            	<!-- <select name="jdgmnt_reqst_year_search" title="발급대상년도" id="jdgmnt_reqst_year_search" style="width:80px">                                
                                </select> -->
                                <%-- 
                                <select name="confm_target_year_search" title="발급대상년도" id="confm_target_year_search" style="width:110px">
                                	<option value="">전체</option>
                                	<c:forEach begin="2012" end="${currentYear+1}" var="confmYear" varStatus="yearStatus" >
                                	<c:set var="yearVal" value="${(currentYear+1) - (yearStatus.count-1)}" />
                                	<option value="${yearVal}" <c:if test="${yearVal == paramTargetYear}">selected</c:if>>${yearVal}</option>                                	
                                	</c:forEach>                                                           
                                </select> 
                                --%>
                                <li style="float:left;width:90px;">
                                	<input type="checkbox" name="confm_target_year_search" id="confm_target_year_search_all" value="" onclick="javascript:check_all('confm_target_year_search');" style="width:50px;"><label for="confm_target_year_search_all">전체</label>
                                </li>	
                                <c:forEach begin="2012" end="${currentYear+1}" var="confmYear" varStatus="yearStatus" >
                                	<c:set var="yearVal" value="${(currentYear+1) - (yearStatus.count-1)}" />
                                	<li style="float:left;width:90px;"><input type="checkbox" class="confm_target_year_search" name="confm_target_year_search" id="confm_target_year_search_+${yearVal}" value="${yearVal}" onclick="javascript:count_check('confm_target_year_search');" style="width:50px;" <c:if test="${fn:contains(param.ad_confm_target_yy, yearVal)}">checked</c:if> <%-- <c:if test="${yearVal == paramTargetYear}">checked</c:if> --%>><label for="confm_target_year_search_+${yearVal}">${yearVal}</label></li>                               	
                                </c:forEach>
                                </ul>
                            </td>
                            <th scope="row">조회항목</th>
                            <td colspan="3">
                            	<ul>
	                            	<li style="float:left;width: 102px;"><input type="checkbox" class="item_search" name="item_search" id="item_search_all" value="" onclick="javascript:check_all('item_search');" style="width:50px;" <c:if test="${!param.ad_item}">checked</c:if>><label for="item_search_all">전체</label></li>
	                            	<li style="float:left;width: 102px;"><input type="checkbox" class="item_search" name="item_search" id="item_search_jurirno" value="jurirno" onclick="javascript:count_check('item_search');" style="width:50px;" <c:if test="${fn:contains(param.ad_item, 'jurirno')}">checked</c:if><%-- <c:if test="${param.ad_item eq 'jurirno'}">checked</c:if> --%> ><label for="item_search_jurirno">법인번호</label></li>
	                            	<li style="float:left;width: 102px;"><input type="checkbox" class="item_search" name="item_search" id="item_search_entrprs_nm" value="entrprs_nm" onclick="javascript:count_check('item_search');" style="width:50px;" <c:if test="${fn:contains(param.ad_item, 'entrprs_nm')}">checked</c:if><%-- <c:if test="${param.ad_item eq 'entrprs_nm'}">checked</c:if> --%> ><label for="item_search_entrprs_nm">기업명</label></li>
	                            	<li style="float:left;width: 102px;"><input type="checkbox" class="item_search" name="item_search" id="item_search_issu_no" value="issu_no" onclick="javascript:count_check('item_search');" style="width:50px;" <c:if test="${fn:contains(param.ad_item, 'issu_no')}">checked</c:if><%-- <c:if test="${param.ad_item eq 'issu_no'}">checked</c:if> --%> ><label for="item_search_issu_no">발급번호</label></li>
                            	<%-- 
                            	<select name="item_search" title="조회항목" id="item_search" style="width:110px">
                                    <option value="">전체</option>
                                    <option value="jurirno" <c:if test="${param.ad_item eq 'jurirno'}">selected</c:if>>법인등록번호</option>
                                    <option value="entrprs_nm" <c:if test="${param.ad_item eq 'entrprs_nm'}">selected</c:if>>기업명</option>
                                    <option value="issu_no" <c:if test="${param.ad_item eq 'issu_no'}">selected</c:if>>발급번호</option>
                                </select> 
                                --%>
                                	<li style="margin-left:15px;"><input value="${param.ad_item_value}" name="item_value_search" type="text" id="item_value_search" class="text" style="width:170px;" title="조회항목" placeholder="조회항목을 입력하세요"/></li>
                                </ul>
                           </td>
                        </tr>
                        <tr>
                            <th scope="row">접수</th>
                            <td>
                            	<input type="text" value="${param.ad_rcept_de_from}" id="rcept_de_from_search" name="rcept_de_from_search" class="datepicker" style="width:71px;" onchange="setCalendar2('rcept');" />
                                <strong> ~ </strong>
                                <input type="text" value="${param.ad_rcept_de_to}" id="rcept_de_to_search" name="rcept_de_to_search" class="datepicker" style="width:71px;" onchange="setCalendar2('rcept');" />
                                <div class="btn_inner">
                                	<!-- 
                                	<a href="#none" class="btn_in_gray" onclick="setCalendar('rcept','day', -20);"><span>20일</span></a> 
                                	<a href="#none" class="btn_in_gray" onclick="setCalendar('rcept','month', -1);"><span>1개월</span></a> 
                                	<a href="#none" class="btn_in_gray" onclick="setCalendar('rcept','year', -1);"><span>1년</span></a>  
                                	-->
                                	<a href="#none" class="btn_in_gray" onclick="setCalendar('rcept','all');"><span>전체</span></a> </div></td>
                            <th scope="row">발급</th>
                            <td colspan="5">                            	
                            	<input type="text" value="${param.ad_issu_de_from}" id="issu_de_from_search" name="issu_de_from_search" class="datepicker" style="width:71px;" onchange="setCalendar2('issu');" />
                                <strong> ~ </strong>
                                <input type="text" value="${param.ad_issu_de_to}" id="issu_de_to_search" name="issu_de_to_search" class="datepicker" style="width:71px;" onchange="setCalendar2('issu');" />
                                <div class="btn_inner">
                                	<!-- 
                                	<a href="#none" class="btn_in_gray" onclick="setCalendar('issu','month', -1);"><span>1개월</span></a> 
                                	<a href="#none" class="btn_in_gray" onclick="setCalendar('issu','year', -1);"><span>1년</span></a> 
                                	-->
                                	<a href="#none" class="btn_in_gray" onclick="setCalendar('issu','all');"><span>전체</span></a>
                                </div>
                                <p class="btn_src_zone"><a href="#none" class="btn_search" id="btn_search_issue">조회</a></p>
                            </td>    
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="block">
                <div class="btn_page_middle"> <a class="btn_page_admin" href="#none" id="btn_rcept_reqst"><span>등록</span></a> <a class="btn_page_admin" href="#none" id="btn_excel_down"><span>엑셀다운로드</span></a> </div>
                <!--// 리스트 -->
                <div class="list_zone">
                    <table cellspacing="0" border="0" summary="목록">
                        <caption>
                        리스트
                        </caption>
                        <colgroup>
                        <col width="*" />
                        <col width="*" />
                        <col width="*" />
                        <col width="*" />
                        <col width="*" />
                        <col width="*" />
                        <col width="200px;" />
                        <col width="*" />
                        <col width="170px;" />
                        <col width="*" />
                        <col width="*" />
                        <col width="*" />
                        <col width="*" />
                        <col width="*" />
                        <col width="*" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th scope="col"><input type="checkbox" id="checkall" /></th>
                                <th scope="col">신청</th>
                                <th scope="col">대상연도</th>
                                <th scope="col">특례대상
                                	<div class="btn_inner"><a href="#none" class="btn_in_gray" id="btn_edit_porcess_excpt"><span>변경</span></a></div>
                                </th>
                                <th scope="col">접수번호</th>
                                <th scope="col">접수일자</th>
                                <th scope="col">기업명</th>
                                <th scope="col">법인번호</th>
                                <th scope="col">진행단계
                                    <div class="btn_inner"><a href="#none" class="btn_in_gray" id="btn_edit_porcess_step"><span>변경</span></a></div>
                                </th>
                                <th scope="col">처리결과</th>
                                <th scope="col">발급번호<br />(확인서)</th>
								<th scope="col">사유
									<div class="btn_inner"><a href="#none" class="btn_in_gray" id="btn_edit_porcess_judgment"><span>변경</span></a></div>
								</th>
								<th scope="col">처리자</th>
                                <th scope="col">담당자</th>
                                <th scope="col">비고</th>
                            </tr>
                        </thead>
                        <tbody>
                        	<c:forEach items="${issueTaskMng}" var="issueTaskMng" varStatus="status"> 
                            <tr>
                                <td><input type="checkbox" name="chk" id="chk_${issueTaskMng.RCEPT_NO}" value="${issueTaskMng.RCEPT_NO}" /></td>
                                <td class="tac">
                                	${fn:replace(issueTaskMng.REQST_SE_NM, '신청', '')}
                                </td>
                                <td>${issueTaskMng.CONFM_TARGET_YY}</td>
                                <td>
                                	<%-- 
                                	<c:choose>
                                		<c:when test="${issueTaskMng.EXCPT_TRGET_AT eq 'Y'}">
                                			예
                                		</c:when>
                                		<c:otherwise>
                                			아니오
                                		</c:otherwise>
                                	</c:choose> 
                                	--%>
                                	<select name="excpt_trget_at_rslt" id="excpt_trget_at_rslt_${status.count}" title="특례대상여부" id="excpt_trget_at_rslt" style="width:70px">
	                            		<option value="Y" <c:if test="${issueTaskMng.EXCPT_TRGET_AT eq 'Y'}">selected</c:if>>예</option>
                            			<option value="N" <c:if test="${issueTaskMng.EXCPT_TRGET_AT eq 'N'}">selected</c:if>>아니오</option>
                            		</select> 
                                </td>
                                <td>
                                	<a href="#none" onclick="showDetail('알림이력','${issueTaskMng.RCEPT_NO}','showNotiHist','Y');">${issueTaskMng.RCEPT_NO}</a>
                                </td>
                                <td>${issueTaskMng.RCEPT_DE}</td>
                                <td>
                                	<c:choose>
									<c:when test="${issueTaskMng.REQST_SE eq 'AK2'}">
										<a href="#none" class="btn_in_gray" onclick="showDetail('내용변경신청 상세','${issueTaskMng.RCEPT_NO}','isgnResultView');">
											${issueTaskMng.ENTRPRS_NM}
										</a>
									</c:when>       
									<c:otherwise>
										<c:choose>	
										<c:when test="${issueTaskMng.SE_CODE_S eq 'PS6'}">
										<a href="#none" onclick="showRcepDetail('${issueTaskMng.RCEPT_NO}','view','pop')">${issueTaskMng.ENTRPRS_NM}</a>
										</c:when>       
										<c:otherwise>
										<a href="#none" onclick="showRcepDetail('${issueTaskMng.RCEPT_NO}','edit','pop')">${issueTaskMng.ENTRPRS_NM}</a>
										</c:otherwise>
										</c:choose>
									</c:otherwise>
									</c:choose>
                                </td>
                                <td>
                                	<c:set var="jurText" value="${issueTaskMng.JURIRNO}" />
                                	${fn:substring(jurText, 0, 6)}-${fn:substring(jurText, 6, 13)}
                                </td>
                                <td>
                                	<c:choose>
                                	<%-- 접수:검토중 --%>
									<c:when test="${issueTaskMng.SE_CODE_S eq 'PS1'}">									
									<c:set var="ignoreCode" value="PS0,PS3,PS4,PS5,PS6" />
									</c:when>
									
									<%-- 검토중:보완요청,완료 --%>
									<c:when test="${issueTaskMng.SE_CODE_S eq 'PS2'}">
									<c:set var="ignoreCode" value="PS0,PS1,PS4,PS5" />
									</c:when>
									
									<%-- 보완요청 --%>
									<c:when test="${issueTaskMng.SE_CODE_S eq 'PS3'}">									
									<%-- <c:set var="ignoreCode" value="PS0,PS1,PS2,PS4,PS5,PS6" /> --%>
									<c:set var="ignoreCode" value="PS0,PS1,PS2,PS4,PS6" />
									</c:when>
									
									<%-- 보완접수:보완검토중 --%>
									<c:when test="${issueTaskMng.SE_CODE_S eq 'PS4'}">									
									<c:set var="ignoreCode" value="PS0,PS1,PS2,PS3,PS6" />
									</c:when>
									
									<%-- 보완검토중:보완요청,완료 --%>
									<c:when test="${issueTaskMng.SE_CODE_S eq 'PS5'}">									
									<c:set var="ignoreCode" value="PS0,PS1,PS2,PS4" />
									</c:when>
									
									<%-- 완료:완료 --%>
									<c:when test="${issueTaskMng.SE_CODE_S eq 'PS6'}">									
									<%-- <c:set var="ignoreCode" value="PS0,PS1,PS2,PS3,PS4,PS5" /> --%>
									<c:set var="ignoreCode" value="PS0,PS1,PS3,PS4,PS5" />
									</c:when>
									
									<c:otherwise>
									</c:otherwise>
									</c:choose>                     	
	                                <ap:code id="ad_se_code_s_${issueTaskMng.RCEPT_NO}" grpCd="18" type="select" onchange="checkSupplement(this, '${issueTaskMng.RCEPT_NO}');" selectedCd="${issueTaskMng.SE_CODE_S}" ignoreCd="${ignoreCode}" defaultLabel="" option="style='width:100px'" />
                                </td>
                                <td>
                                	<c:choose>
									<%-- 접수 --%>
									<c:when test="${issueTaskMng.SE_CODE_S eq 'PS1'}">
									<ul class="im1" style="width:160px;">
                                    <li></li><li><div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="showDetail('접수 취소','${issueTaskMng.RCEPT_NO}','showCancelReception','N');"><span>접수취소</span></a></div></li></ul>
									</c:when>
									
									<%-- 검토중 --%>
									<c:when test="${issueTaskMng.SE_CODE_S eq 'PS2'}">
                                    <ul class="im1" style="width:160px;">
									<li><div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="showDetail('판정 등록','${issueTaskMng.RCEPT_NO}','showJudgment','N');"><span>판정</span></a></div></li>
									<li><div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="showDetail('접수취소 등록','${issueTaskMng.RCEPT_NO}','showCancelReception','N');"><span>접수취소</span></a></div></li></ul>
									</c:when>
									
									<%-- 보완요청 --%>
									<c:when test="${issueTaskMng.SE_CODE_S eq 'PS3'}">
                                    <ul class="im1" style="width:160px;">
                                    <li><div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="showSupplementDetail('보완사유 등록','${issueTaskMng.RCEPT_NO}','${issueTaskMng.REQST_SE_NM}','showSupplementWinpop','N');"><span>사유</span></a></div></li>
									<li><div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="showDetail('접수취소 등록','${issueTaskMng.RCEPT_NO}','showCancelReception','N');"><span>접수취소</span></a></div></li></ul>
									</c:when>
                                    
									<%-- 보완접수 --%>
									<c:when test="${issueTaskMng.SE_CODE_S eq 'PS4'}">
                                    <ul class="im1" style="width:160px;">
                                    <li><div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="showSupplementDetail('보완사유 등록','${issueTaskMng.RCEPT_NO}','${issueTaskMng.REQST_SE_NM}','showSupplementWinpop','Y');"><span>사유</span></a></div></li>									
									<li><div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="showDetail('접수취소 등록','${issueTaskMng.RCEPT_NO}','showCancelReception','N');"><span>접수취소</span></a></div></li></ul>                              
									</c:when>
									
									<%-- 보완검토중 --%>
									<c:when test="${issueTaskMng.SE_CODE_S eq 'PS5'}">
                                    <ul class="im1" style="width:160px;">
									<li><div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="showDetail('판정 등록','${issueTaskMng.RCEPT_NO}','showJudgment','N');"><span>판정</span></a></div></li>
									<li><div class="btn_inner"><a href="#none" class="btn_in_gray"onclick="showDetail('접수취소 등록','${issueTaskMng.RCEPT_NO}','showCancelReception','N');"><span>접수취소</span></a></div></li></ul>
									</c:when>
									
									<%-- 완료 --%>
									<c:when test="${issueTaskMng.SE_CODE_S eq 'PS6'}">
									
										<c:if test="${issueTaskMng.SE_CODE_R eq 'RC1'}">
	                                    	<ul class="im1" style="width:160px;">
												<li><a href="#none" class="btn_in_gray" onclick="showDetail('판정결과 보기','${issueTaskMng.RCEPT_NO}','showJudgment','Y');">발급</a></li>
												<li><div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="showDetail('발급취소 등록','${issueTaskMng.RCEPT_NO}','showCancelIssue','N');"><span>발급취소</span></a></div></li>
	                                        </ul>
										</c:if>
										<c:if test="${issueTaskMng.SE_CODE_R eq 'RC2'}">
										<ul class="im1" style="width:160px;">
	                                   		<li></li>
	                                   		<li><a href="#none" onclick="showDetail('판정결과 보기','${issueTaskMng.RCEPT_NO}','showJudgment','Y');">반려</a></li>
	                                   	</ul>
	                                   	</c:if>
										<c:if test="${issueTaskMng.SE_CODE_R eq 'RC3'}">
	                                    <ul class="im1" style="width:160px;">
	                                    	<li></li>
	                                    	<li><a href="#none" onclick="showDetail('접수취소 보기','${issueTaskMng.RCEPT_NO}','showCancelReception','Y');">접수취소</a></li>
	                                    </ul>
	                                    </c:if>
										<c:if test="${issueTaskMng.SE_CODE_R eq 'RC4'}">
	                                    <ul class="im1" style="width:160px;">
	                                    	<li></li>
	                                    	<li><a href="#none" onclick="showDetail('판정결과 보기','${issueTaskMng.RCEPT_NO}','showCancelIssue','Y');">발급취소</a></li>
	                                    </ul>
	                                    </c:if>			
									
									</c:when>
									
									<%-- 완료 --%>
									<c:when test="${issueTaskMng.SE_CODE_S eq 'PS6'}">									
									접수취소
									</c:when>
									
									<%-- 완료 --%>
									<c:when test="${issueTaskMng.SE_CODE_S eq 'PS6'}">									
									발급취소
									</c:when>
									
									<c:otherwise>
									</c:otherwise>
									</c:choose>
									                     	
                                </td>
                                <td><a href="#none" onclick="printCertIssue('${issueTaskMng.ISSU_NO }', '${issueTaskMng.CONFM_SE}');">${issueTaskMng.ISSU_NO}</a></td>
                                <td>
                                	<%-- 완료 --%>
                                	<c:if test="${issueTaskMng.SE_CODE_S eq 'PS6'}">
                                		<!-- 발급 -->
                                		<c:if test="${issueTaskMng.SE_CODE_R eq 'RC1'}">
                                			<%-- <ap:code id="" grpCd="16" selectedCd="${issueTaskMng.JDGMNT_CODE }" type="text"/> --%>
                                			<ap:code grpCd="16" id="ad_jdg" selectedCd="${issueTaskMng.JDGMNT_CODE }" type="select" />
                                		</c:if>
                                		<!-- 반려 -->
                                		<c:if test="${issueTaskMng.SE_CODE_R eq 'RC2'}">
                                			<%-- <ap:code id="" grpCd="17" selectedCd="${issueTaskMng.JDGMNT_CODE }" type="text"/> --%>
                                			<ap:code grpCd="17" id="ad_jdg" selectedCd="${issueTaskMng.JDGMNT_CODE }" type="select" />
                                		</c:if>
                                		<!-- 발급취소 -->
                                		<c:if test="${issueTaskMng.SE_CODE_R eq 'RC4'}">
                                			<ap:code id="" grpCd="17" selectedCd="${issueTaskMng.RESN }" type="text"/>
                                		</c:if>
                                	</c:if>
                                	                	
									
                                </td>
                                <td>
                                	<%-- 완료 --%>
                                	<c:if test="${issueTaskMng.SE_CODE_S eq 'PS6'}">
                                		<%-- 발급 --%>
                                		<c:if test="${issueTaskMng.SE_CODE_R eq 'RC1'}">
                                			${issueTaskMng.NM}
                                		</c:if>
                                	</c:if>
                                </td>
                                <td><div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="showDetail('신청 담당자 정보','${issueTaskMng.RCEPT_NO}','showChargerInfo','N', '${issueTaskMng.JURIRNO}');"><span>Go</span></a></div></td>
                                <td><div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="showDetail('접수서류 특이사항','${issueTaskMng.RCEPT_NO}','showPartclrMatter','N');"><span>Go</span></a></div></td>                                
                            </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <!-- 리스트// -->
                <div class="mgt10"></div>
                <!--// paginate -->
                <div class="paginate"> <ap:pager pager="${pager}" addJsParam="'getData'"/> </div>
                <!-- paginate //-->
            </div>
            <!--리스트영역 //-->
        </div>
    </div>
</div>    
    <!--content//-->


</form>

</body>
</html>