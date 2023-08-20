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
<title>정보</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask" />
<ap:jsTag type="tech" items="acm,msg,util,so" />
<ap:globalConst />
<script type="text/javascript">
<c:if test="${resultMsg != null}">
	$(function(){
		jsMsgBox(null, "info", "${resultMsg}");
	});
</c:if>

$(document).ready(function(){
    $('#q_pjt_start_dt').mask('0000-00-00');
    $('#q_pjt_end_dt').mask('0000-00-00');
	$('#q_pjt_start_dt').datepicker({
	    showOn : 'button',
	    defaultDate : -30,
	    buttonImage : '<c:url value="/images/acm/icon_cal.png" />',
	    buttonImageOnly : true,
	    changeYear: true,
	    changeMonth: true,
	    yearRange: "-5:+1"
	});
	$('#q_pjt_end_dt').datepicker({
	    showOn : 'button',
	    defaultDate : null,
	    buttonImage : '<c:url value="/images/acm/icon_cal.png" />',
	    buttonImageOnly : true,
	    changeYear: true,
	    changeMonth: true,
	    yearRange: "-5:+1"
	});
	
	$("input[name='seqs']").click(function(){
        if($(this).is(":checked")){
//             $(this).parent().parent().addClass("bg_blue");
        }else{
//             $(this).parent().parent().removeClass("bg_blue");
        }
    });
	
	//전체선택 체크박스
	$("input[name='chk-all']").click(function(){
		var isChecked = this.checked;
		$("input[name='seqs']").prop('checked', isChecked);
		
		if(isChecked){
// 			$(":checkbox").parent().parent().addClass("bg_blue");
		}else{
// 		    $(":checkbox").parent().parent().removeClass("bg_blue");
		}
	});
});


/*
* 검색단어 입력 후 엔터 시 자동 submit
*/
function press(event) {
	if (event.keyCode == 13) {
		event.preventDefault();
		btn_suport_get_list();
	}
}

/*
* 목록 검색
*/
function btn_suport_get_list() {
	
	if($("#searchDateType  option:selected").val() != "all")
	{
    	if($("#q_pjt_start_dt").val() > $("#q_pjt_end_dt").val() || $("#q_pjt_start_dt").val().replace(/-/gi,"") > $("#q_pjt_end_dt").val().replace(/-/gi,"")){
            jsMsgBox(null, "info", "시작일이 종료일보다 뒤에 날짜로 올수 없습니다.");
            $("#q_pjt_end_dt").focus();
            return false;
        }
	}
	
	if($("#searchKeyword").val() != "")
	{
		if($("#searchCondition  option:selected").val() == "all")
		{
			  jsMsgBox(null, "info", "검색항목을 선택하세요.");
			$("#searchCondition").focus();
			return false;
		}
	}
	
	var form = document.dataForm;
	
	form.df_curr_page.value = 1;
	form.df_method_nm.value = "";
	form.submit();
}

function curr_suport_get_list() {
	
	var form = document.dataForm;
	
	form.df_method_nm.value = "";
	form.submit();
}

//공시여부 선택()
function disntceAYN(){
	$.colorbox({
        title : "지원사업공개여부선택",
        href  : "PGSO0100.do?df_method_nm=disntceAtYN",
        width : "300px",
        height: "220px",            
        overlayClose : false,
        escKey : false,            
    });
}

var changentceAYN = function(){
	var selectedSeqs = jsCheckedArray();
	
	if(selectedSeqs.length == 0){
		// jsMsgBox(null, "info", "공개여부 대상 지원사업을 1개 이상 선택하세요.");
		 alert("공개여부 대상 지원사업을 1개 이상 선택하세요.");
		return false;
	}

	var ntceAYNval = $(':radio[name="ntceAtYN"]:checked').val();;
	
		
	if( ntceAYNval != null && ntceAYNval == 'Y')
	{
			if(!confirm("선택한 " + selectedSeqs.length + "개의 지원사업을 정말 공개로 변경하시겠습니까?")) return false;
			//if( jsMsgBox(null, "confirm", "공개여부 대상 지원사업을 1개 이상 선택하세요.")) return false;

	}
	else if ( ntceAYNval != null && ntceAYNval == 'N')
	{
			if(!confirm("선택한 " + selectedSeqs.length + "개의 지원사업을 정말 비공개로 변경하시겠습니까?.")) return false;
	}
	else
	{
		alert("공개 여부를 선택하세요.");
		jsWarningBox("공개 여부를 선택하세요.");
		return false;
	}
	
	$("#df_method_nm").val("updatentceAtYN");
	
	var para = [];
	
	$("input[name='seqs']:checked").each(function(i){
		para.push($(this).val());
	});
	
	
	var postData = { "df_method_nm":$("#df_method_nm").val(), "ntceaynval":ntceAYNval,"seqs":para};
	
	$.ajax({
           url      : "PGSO0100.do",
           type     : "POST",
           dataType : "json",
           data     : postData,
           async    : false,     
           traditional : true,
           success  : function(response) {
	           	$.colorbox.close();
	        	try {
	        		if(response.result) {
	        			
	        			jsMsgBox(null, 'info', '지원사업 공개 여부 변경 요청이<br>정상처리되었습니다.<br> 이용해 주셔서 감사합니다.',function(){curr_suport_get_list();});
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
};
    

//체크된 게시판 글 목록을 가져온다.
var jsCheckedArray = function(){
	var selectedSeqs = new Array();
		$("input[name='seqs']:checked").each(function(i){
		selectedSeqs[i] = $(this).val();
	});
	return selectedSeqs;
};	

//목록 완전 삭제 버튼


</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />
		
		 <!-- 좌측영역 //-->
    <!--//content-->
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">지원사업관리</h2>
                <!-- 타이틀 영역 //-->
                <!--// 검색 조건 -->
                <div class="search_top">
                    <table cellpadding="0" cellspacing="0" class="table_search" summary="검색" >
                        <caption>
                        검색
                        </caption>
                        <colgroup>
                        <col width="100%" />
                        </colgroup>
                        <tr>
                            <td class="only">
 								<select name="searchDateType" id="searchDateType" title="날짜검색" style="width:100px">
	                                <option value="all" <c:if test="${(inparam.searchDateType != 'condEnd') && (inparam.searchDateType != 'condStart') }">selected</c:if> >선택</option>
	                                <option value="condEnd" <c:if test="${inparam.searchDateType == 'condEnd' }">selected</c:if> >마감일</option>
	                                <option value="condStart" <c:if test="${inparam.searchDateType == 'condStart' }">selected</c:if>>시작일</option>
                           	 	</select>
                           		<input type="text" name="q_pjt_start_dt" id="q_pjt_start_dt" maxlength="10" title="날짜선택" value='<c:out value="${inparam.fromDate}"/>' />
								~
								<input type="text" name="q_pjt_end_dt" id="q_pjt_end_dt" maxlength="10" title="날짜선택" value='<c:out value="${inparam.toDate}"/>' />
                                
                                <select name="searchCondition" id="searchCondition"  title="검색항목선택" id="" style="width:110px;margin-left: 50px;">
	                                <option value="all" <c:if test="${(inparam.searchCondition != 'realm') && (inparam.searchCondition != 'mngtMiryfc') }">selected</c:if> >선택</option>
	                                <option value="realm" <c:if test="${inparam.searchCondition == 'realm' }">selected</c:if> >사업분야</option>
	                                <option value="mngtMiryfc" <c:if test="${inparam.searchCondition == 'mngtMiryfc' }">selected</c:if>>주관기관</option>
	                            </select>
                           		<input type="text"  id="searchKeyword" name="searchKeyword" title="검색어를 입력하세요." placeholder="검색어를 입력하세요."  onfocus="this.placeholder=''; return true"
                           			value='<c:out value="${inparam.searchKeyword}"/>' onkeypress="press(event);" style="width:250px;"/>
                            	<p class="btn_src_zone"><a href="#" class="btn_search" onclick="btn_suport_get_list()">검색</a></p>
                            </td>
                        </tr>
                    </table>
                </div>

                <div class="block">
                    <ul>
                        <li class="d1">기업마당에서 제공하는 기업지원사업을 RSS로 수집한 정보입니다.</li>
                        <li class="d1">수집된 정보는 기본 공개로 설정됩니다.</li>
                        <li class="d1">RSS 추가 및 기타 수집 데이터는 수집데이터관리 〉 지원사업수집에서 관리 하실 수 있습니다.</li>
                    </ul>
                    <div class="btn_page"><a class="btn_page_admin" href="#" onclick="jsMoveMenu('29','109','PGDC0070')"><span>지원사업수집관리 바로가기</span></a></div>
                </div>

                <div class="block">
                    <ap:pagerParam />
                    <!--// 리스트 -->
                    <div class="list_zone">
                        <table cellspacing="0" border="0" summary="자료요청관리 게시판 목록">
                            <caption>
                            자료요청관리 게시판 목록
                            </caption>
                            <colgroup>
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col"><input type="checkbox" value="Y" name="chk-all" id="chk-all" /></th>
                                    <th scope="col">번호</th>
                                    <th scope="col">제목</th>
                                    <th scope="col">사업분야</th>
                                    <th scope="col">주관기관</th>
                                    <th scope="col">공개</th>
                                    <th scope="col">시작일</th>
                                    <th scope="col">마감일</th>
                                </tr>
                            </thead>
                            <tbody>
	                            <c:choose>
								   	<c:when test="${fn:length(suportList) > 0}">
									  	<c:forEach items="${suportList}" var="info" varStatus="status">    
									  	 <tr>   
									  	 	<td><input type="checkbox" name="seqs"  value="${info.sn}"  /></td>         	
											<td class="tac">${info.sn}</td>
											<td class="tw"><a href="${info.url}" target="_blank">${info.sj}</a></td>
											<td class="tal">${info.realm}</td>	
											<td class="tal">${info.mngtMiryfc}</td>	
											<td>${info.ntceAt}</td>	
											<td>${info.opertnBginde}</td>	
											<td>${info.opertnEndde}</td>					                        
										</tr>
										</c:forEach>
									</c:when>
								   	<c:otherwise>
								   		<tr>
								   		<td colspan="6" style="text-align:center;"> 지원사업 정보가 없습니다.</td>
								   		</tr>
								   	</c:otherwise>
								</c:choose>
                            </tbody>
                        </table>
                    </div>
                    <!-- 리스트// -->
                    <div class="btn_page_last"><a class="btn_page_admin" href="#" onclick="disntceAYN();" ><span>공개/비공개 설정</span></a></div>
                    <!--// paginate -->
						<ap:pager pager="${pager}" />
						<!-- paginate //-->
                </div>
            </div>
            <!--content//-->
        </div>
    </div>
</div>
</form>
</body>
</html>