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
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox" />
<ap:jsTag type="tech" items="msg,util,ucm" />

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

$(document).ready(function(){
	
	<c:if test="${not empty RETURN_MSG}">
	jsMsgBox(null,'info','${RETURN_MSG}');
	</c:if>
	
	$("#ad_reg_bizrno").mask("0000000000");
	$("#dataForm").validate({
		rules:{
			ad_reg_entrprs_nm : {
				required: true,
				maxlength: 100
			},
			ad_reg_bizrno : {
				required: true,
				minlength: 10
			}
		}
	}).cancelSubmit = true;
	
	// 검색
 	$("#search_word").keyup(function(e){
 		if(e.keyCode == 13) {
	 		$("#df_method_nm").val("empmnCmpnyMngList");
	 		document.dataForm.submit();
	 		//$("#dataForm").submit();
 		}
 	});
 	$("#btn_search").click(function(){
 		$("#df_method_nm").val("empmnCmpnyMngList");
 		document.dataForm.submit();
 	});
 	
 	// 기업등록
 	$("#btn_reg_entr").click(function(){
 		if($("#dataForm").valid()) {
 			$("#df_method_nm").val("insertEmpmnCmpnyMng");
 			$("#dataForm").submit();
 		}
 	});
 	
}); // ready

// 회사소개 관리
function move_cmpny_intrcn(bizrno){	
	$("#ad_bizrno").val(bizrno);
	
	$("#df_method_nm").val("cmpnyIntrcnMngForm");
	document.dataForm.submit();
}

// 채용공고 등록
function move_pblanc_reg(bizrno){
	var prtDoc = parent.document;
	
	$("#ad_bizrno", prtDoc).val(bizrno);
	$("#df_method_nm", prtDoc).val("empmnInfoForm");
	$("#dataForm", prtDoc).submit();
	parent.$.colorbox.close();
}

</script>
</head>
<body>

<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">

<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/pagingParam.jsp" />

<input type="hidden" id="ad_bizrno" name="ad_bizrno" />
<input type="hidden" id="ad_reg_type" name="ad_reg_type" value="${param.ad_reg_type }" />

<!--//검색-->
<div class="view_zone">
	<table class="table_form">
		<caption>채용정보 상세보기</caption>
		<colgroup>
			<col width="124px">
			<col width="245px">
			<col width="124px">
			<col width="245px">
			<col width="258px">
		</colgroup>
		<tbody>
			<tr class="table_input">
				<th>
					기업명
				</th>
				<td class="b_l_0">
					<input type="text" id="ad_reg_entrprs_nm" name="ad_reg_entrprs_nm" style="width:100px;" />
				</td>
				<th>
					사업자등록번호
				</th>
				<td class="b_l_0">
					<input type="text" id="ad_reg_bizrno" name="ad_reg_bizrno" style="width:100px;" />
				</td>
				<td class="b_l_0">
					<div class="btn_bl" style="width:100px; padding:0px;">
						<a href="#none" class="blu" id="btn_reg_entr"><span>등록</span></a>
					</div>
				</td>
			</tr>
			<tr>
				<td class="b_l_0">
					<ul class="form_sel">
						<select name="search_type" id="search_type" class="sel select_box">
			                <option>기업명</option>
			            </select>
			        </ul>
				</td>
				<td class="b_l_0" colspan="3">
					<input type="text" name="search_word" id="search_word" value="${param.search_word }" title="검색어를 입력하세요." placeholder="검색어를 입력하세요." onFocus="this.placeholder=''; return true"  style="width:250px;" />
				</td>
				<td class="b_l_0">
					<div class="btn_bl" style="width:100px; padding:0px;">
						<a href="#" class="blu" id="btn_search">조회</a>
					</div>
				</td>
			</tr>
    	</tbody>
    </table>
    
</div>
<!--검색//-->
<!-- <div style="text-align: right; margin-top: 10px; margin-bottom:10px; ">
	<div class="btn_inner" style="width:50%; text-align: right">
		기업명 : <input type="text" id="ad_reg_entrprs_nm" name="ad_reg_entrprs_nm" />&nbsp;&nbsp;
		사업자등록번호 : <input type="text" id="ad_reg_bizrno" name="ad_reg_bizrno" />		
		<a href="#none" class="btn_in_gray"><span>등록</span></a>
	</div>
</div> -->

<div class="view_zone">
    <table class="table_form">
        <caption>
        기업목록
        </caption>
        <colgroup>
        <col />
        <col />
        <col />        
        </colgroup>
        <thead>
            <tr>
            	<th scope="col">번호</th>
                <th scope="col">기업명</th>
                <th scope="col">사업자등록번호</th>                
            </tr>
        </thead>
        <tbody>            
            <c:forEach items="${entrprsList }" var="entrprs" varStatus="status">
            <tr>
            	<c:if test="${param.ad_reg_type == 'INTRCN' }">
            	<td>${pager.indexNo - status.index}</td>
            	<td><a href="#none" onclick="move_cmpny_intrcn('${entrprs.BIZRNO }')">${entrprs.ENTRPRS_NM }</a></td>
            	<td><a href="#none" onclick="move_cmpny_intrcn('${entrprs.BIZRNO }')">${entrprs.BIZRNO }</a></td>
            	</c:if>
            	<c:if test="${param.ad_reg_type == 'PBLANC' }">
            	<td>${pager.indexNo - status.index}</td>
            	<td><a href="#none" onclick="move_pblanc_reg('${entrprs.BIZRNO }')">${entrprs.ENTRPRS_NM }</a></td>
            	<td><a href="#none" onclick="move_pblanc_reg('${entrprs.BIZRNO }')">${entrprs.BIZRNO }</a></td>
            	</c:if>
            </tr>                               
            </c:forEach>                    
        </tbody>
    </table>
</div>
<!--// paginate -->
<ap:pager pager="${pager}" addJsParam="'empmnCmpnyMngList'"/>
<!-- paginate //-->
</form>

</body>
</html>