<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
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
<ap:jsTag type="web"
	items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javascript">


function countSess(){
   
   var ad_select_year = document.getElementById("ad_select_year").value;
   var table = document.getElementById("dayofftable");

  
   $.ajax({
      type: "POST",
      url: "PGEV1120.do",
      data:{ "df_method_nm" : "index"
         ,"ad_select_year": $("#ad_select_year").val()
          ,"state": $("#state").val()
          ,"cancel_state": $("#cancel_state").val()
          ,"EMP_NO": $("#EMP_NO").val()
      },
      error: function(error){
         console.log("error");
      },
      success: function(data){
         console.log("success");
         btn_program_get_list();
      }      
   })
}

function clickStoreBtn(save_type){
      var create = null;
      $.ajax({
            type: "POST",
            url: "PGEV1120.do",
            data:{ "df_method_nm" : "saveDayoff"
               ,"pk" : create
               ,"dayoff_type": $("#dayoff_type").val()
                ,"start_date": $("#start_date").val()
                ,"end_date": $("#end_date").val()
                ,"content": $("#content").val()
                ,"state" : save_type
            },
            error: function(error){
               console.log("error");
            },
            success: function(data){
               console.log("success");
               btn_program_get_list();
            }      
         })
}
function btn_program_regist_view() {
   var form = document.dataForm;
   form.df_method_nm.value = "programRegist";
   form.submit();
}

$( document ).ready( function() {
    $( '#start_date, #end_date' ).change( function() {
    	console.log("change")
      var a = $('#start_date').val();
      var b = $('#end_date').val();
      var c = $('#dayoff_day');

      if(a != "" && b != ""){
    	  $.ajax({
              type: "POST",
              url: "PGEV1120.do",
              data:{ "df_method_nm" : "calDate"
                  ,"start_date": $("#start_date").val()
                  ,"end_date": $("#end_date").val()
              },
              error: function(error){
                 console.log("error");
                 console.log(error);
              },
              success: function(data){
                 c.val(JSON.parse(data)[0][0].RESULT);
              }      
           })    	  
      }
    } )
  } );
   /*
    * 검색단어 입력 후 엔터 시 자동 submit
    */
   function press(event) {
      if (event.keyCode == 13) {
         event.preventDefault();
         countSess();
      }
   }
   
   
   /* 
    * 목록 검색
    */
   function btn_program_get_list() {
      var form = document.dataForm;
 
      form.df_curr_page.value = 1;
      form.df_method_nm.value = "";
      form.submit();
   }
      
   
<c:if test="${resultMsg != null}">
$(function(){
   jsMsgBox(null, "info", "${resultMsg}");
});
</c:if>
   
</script>

<style>
#dayoff {
	text-align: center;
	padding: 0;
	border: 1px solid lightgray;
}

#dayoffthead {
	height: 40px;
	font-weight: bold;
	border-top: 2px solid lightgray;
}

#dayofftbody {
	border-bottom: 2px solid lightgray;
}
</style>
</head>

<body>
	<form name="dataForm" id="dataForm" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />

		<input type="hidden" id="init_search_yn" name="init_search_yn"
			value="N" />
		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title">휴가신청</h2>
					<!-- 타이틀 영역 //-->
					<!--// 검색 조건 -->
					<div class="search_top">
						<table cellpadding="0" cellspacing="0" class="table_search"
							summary="휴가신청 검색">
							<caption>검색</caption>
							<colgroup>
								<col width="10%" />
								<col width="10%" />
								<col width="10%" />
								<col width="30%" />
								<col width="10%" />
								<col width="10%" />
								<col width="20%" />
							</colgroup>
							<tr>
								<th scope="row">기준연도</th>
								<td><input name="ad_select_year" id="ad_select_year"
									title="년도를 입력하세요." placeholder="년도를 입력하세요." type="text"
									style="width: 200px" value="${ad_select_year}"
									onkeypress="press(event);" /></td>
								<th scope="row">전자 결재 상태</th>
								<td><select name="state" id="state"">
										<option value="state_all">전체</option>
										<option value="작성">작성</option>
										<option value="요청">요청</option>
										<option value="완료">완료</option>
										<option value="반려">반려</option>
								</select></td>
								<th scope="row">취소여부</th>
								<td><select name="cancel_state" id="cancel_state"">
										<option value="state_all">전체</option>
										<option value="TRUE">Y</option>
										<option value="FALSE">N</option>
								</select></td>
								<td rowspan="2">
									<p class="btn_src_zone">
										<a href="#" class="btn_search" onclick="countSess()">검색</a>
									</p>
								</td>
							</tr>
							<tr>
								<th scope="row">사원번호</th>
								<td><input name="EMP_NO" id="EMP_NO" type="text" /></td>

							</tr>
						</table>
					</div>
					<br> <br>
					<div>
						<div class="holidayTitle" style="border: 1px solid black;"
							width="400">
							<h3 class="menu_title">휴가신청</h3>
						</div>
						<table cellpadding="0" cellspacing="0" class="table_search"
							summary="휴가신청 검색">
							<caption>검색</caption>
							<colgroup>
								<col width="10%" />
								<col width="20%" />
								<col width="10%" />
								<col width="20%" />
								<col width="10%" />
								<col width="20%" />
								<col width="*" />
							</colgroup>
							<tr>
								<th scope="row">사원번호</th>
								<td>${dayoffInfo[0].EMP_NO}</td>
								<th scope="row">성명</th>
								<td>${dayoffInfo[0].EMP_NM}</td>
								<th scope="row">연차기간</th>
								<td>${dayoffInfo[0].USE_YEAR}.01.01~${dayoffInfo[0].USE_YEAR}.12.31</td>
							</tr>
							<tr>
								<th scope="row">발생일수</th>
								<td>${dayoffInfo[0].TOTAL_CNT}</td>
								<th scope="row">사용일수</th>
								<td>${dayoffInfo[0].USE_TOTAL}</td>
								<th scope="row">잔여일수</th>
								<td>${dayoffInfo[0].RESULT}</td>
							</tr>
						</table>
						<br /> <br />

						<table>
							<colgroup>
								<col width="20%" />
								<col width="70%" />
								<col width="10%">
							</colgroup>
							<thead>
								<th><h3>휴가신청내역</h3></th>
								<th />
								<th><p class="btn_src_zone">
										<a href="#" class="btn_search" onclick="countSess()">검색</a>
									</p></th>
							</thead>
						</table>
						<table cellpadding="0" cellspacing="0" class="table_search"
							summary="휴가신청내역 검색">
							<caption>검색</caption>
							<colgroup>
								<col width="5%" />
								<col width="8%" />
								<col width="8%" />
								<col width="8%" />
								<col width="8%" />
								<col width="8%" />
								<col width="8%" />
								<col width="8%" />
								<col width="8%" />
								<col width="15%" />
								<col width="8%" />
								<col width="*" />
							</colgroup>
							<thead id="dayoffthead">
								<tr>
									<th id="dayoff" class="checkbox">No</th>
									<th id="dayoff">신청일</th>
									<th id="dayoff">휴가구분</th>
									<th id="dayoff">전일/반일</th>
									<th id="dayoff">시작일</th>
									<th id="dayoff">종료일</th>
									<th id="dayoff">근태일수</th>
									<th id="dayoff">사용일수</th>
									<th id="dayoff">전자결재상태</th>
									<th id="dayoff">휴가사유</th>
									<th id="dayoff">취소여부</th>
									<th id="dayoff">일괄생성</th>
								</tr>
							</thead>
							<tbody id="dayofftbody">
								<c:forEach items="${dayoffLogList}" var="dayoffLogList"
									varStatus="status">
									<tr>
										<a>
											<td id="no${status.index}"><script
													type="text/javascript">
                              document.getElementById("no"+${status.index}).innerText = ${status.index};
                           </script></td>
											<td id="dayoff">${dayoffLogList.LOG_DATE}</td>
											<td id="dayoff">연차휴가</td>
											<td id="dayoff">${dayoffLogList.DAYOFF_TYPE}</td>
											<td id="dayoff">${dayoffLogList.START_DATE}</td>
											<td id="dayoff">${dayoffLogList.END_DATE}</td>
											<td id="dayoff">${dayoffLogList.DATE_CNT}</td>
											<td id="dayoff">${dayoffLogList.DATE_CNT}</td>
											<td id="dayoff">${dayoffLogList.STATE}</td>
											<td id="dayoff">${dayoffLogList.CONTENT}</td>
											<td id="dayoff">${dayoffLogList.CANCEL_STATE}</td>
											<td id="dayoff"><input type="hidden"
												value="${dayoffLogList.PK}"></td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
						<br /> <br />

						<h3 class="menu_title">휴가신청</h3>

						<table cellpadding="0" cellspacing="0" class="table_search"
							summary="휴가신청 검색">
							<caption>검색</caption>
							<colgroup>
								<col width="10%" />
								<col width="10%" />
								<col width="10%" />
								<col width="10%" />
								<col width="10%" />
								<col width="10%" />
								<col width="*" />
							</colgroup>

							<tr>
								<th>휴가 신청일</th>
								<td><input name="dayoff_Date" id="dayoff_Date" type="text"
									style="width: 200px" onkeypress="press(event);" readonly /></td>
								<th>휴가구분</th>
								<td><select name="dayoff_type1" id="dayoff_type1"
									type="text">
										<option value="연차휴가">연차휴가</option>
										<option value="연차휴가">경조휴가</option>
								</select></td>
								<th>전일/반일</th>
								<td><select name="dayoff_type" id="dayoff_type" type="text">
										<option value="전일">전일</option>
										<option value="오전반차">오전반차</option>
								</select></td>
							</tr>
							<tr>
								<th>휴가 기간</th>
								<td colspan="3"><input type="date" name="start_date"
									id="start_date" style="width: 200px" />~ <input type="date"
									name="end_date" id="end_date" style="width: 200px" /> (일수: <input
									type="text" name="dayoff_day" id="dayoff_day"
									style="width: 50px" value="${days[0].RESULT}">)</td>
								<th>전자결재상태</th>
								<td><input type="text" name="dayoff_state"
									id="dayoff_state" readonly></td>
							</tr>
							<tr>
								<th>휴가 사유</th>
								<td rowspan="3"><input type="text" name="content"
									id="content" style="width: 300px" onkeypress="press(event);">
								</td>

							</tr>
						</table>
						<br> <br>
						<table>
							<caption>검색</caption>
							<colgroup>
								<col width="60%" />
								<col width="20%" />
								<col width="10%" />
								<col width="10%" />
							</colgroup>
							<tr>
								<th><div class="btn_page_last">
										<a class="btn_page_admin" href="#" onclick="downloadExcel();"><span>신규</span></a>
									</div></th>
								<th><div class="btn_page_last">
										<a class="btn_page_admin" href="#"
											onclick="clickStoreBtn('요청')"><span>신청</span></a>
									</div></th>
								<th><div class="btn_page_last">
										<a class="btn_page_admin" href="#"
											onclick="clickStoreBtn('작성')"><span>저장</span></a>
									</div></th>
							</tr>
						</table>
						<!-- 리스트// -->
					</div>
					<br>
				</div>
				<!--content//-->
			</div>
		</div>

	</form>
</body>
</html>