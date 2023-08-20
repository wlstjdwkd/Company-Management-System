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
<ap:jsTag type="web"
   items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javascript">


var useYear = "";

function countSess(){
   
   var ad_select_year = document.getElementById("ad_select_year").value;
   var ad_search_type = document.getElementById("ad_search_type").value;
   var ad_search_word = document.getElementById("ad_search_word").value;
  
   $.ajax({
      type: "POST",
      url: "PGEV1100.do",
      data:{ "df_method_nm" : "index"
         ,"ad_select_year": $("#ad_select_year").val()
         ,"ad_search_type": $("#ad_search_type").val()
         ,"ad_search_word": $("#ad_search_word").val()
      },
      error: function(error){
         console.log("error");
      },
      success: function(data){
         console.log("success");
//          console.log(dayoffList);
      }
   })
}


function btn_program_regist_view() {
   var form = document.dataForm;
   form.df_method_nm.value = "programRegist";
   form.submit();
}
   /*
    * 검색단어 입력 후 엔터 시 자동 submit
    */
   function press(event) {
      if (event.keyCode == 13) {
         event.preventDefault();
         btn_program_get_list();
      }
   }
   
   var count = 0; 
   function count_checked(){
      var table = document.getElementById("dayofftable");
      var rowList = dayofftable.rows;
      var cells = table.getElementsByTagName("input");
      var empList = table.getElementsByClassName("emp_no");   //사원번호
      var incoList = table.getElementsByClassName("inco_dt");
      console.log(empList.item(0).innerText);
      console.log(rowList.length);
      for(var i =1; i<rowList.length; i++ ){
         if(cells.item(i-1).checked == true){

            $.ajax({
                  type: "POST",
                  url: "PGEV1100.do",
                  data:{ "df_method_nm" : "insertDayoff"
                     ,"use_year": $("#ad_select_year").val()
                        ,"inco_dt": incoList.item(i-1).innerText
                        ,"emp_no": empList.item(i-1).innerText
                  },
                  error: function(error){
                     console.log("error");
                  },
                  success: function(data){
                     console.log("success");
                  }
               }) 
            count++;
         }
         console.log(cells.item(i-1).checked);
      }
   }
   
   
   function clickCreateBtn(){
      const createMessage = confirm('연차를 생성하시겠습니까?');
      count_checked();
      var dayofftable = document.getElementById("dayofftable");
      var rowList = dayofftable.rows;
      
      
      var total_cnt = document.getElementsByClassName("total_cnt");
      var checkbox = document.getElementsByClassName("checkbox");
      
      if(createMessage == true){
        /*  for(var i =1; i<rowList.length; i++){
            var row = rowList[i];
            row.cell[0] == checked 
         } */
         if(total_cnt.value == null){
            alert(count+ '건 생성되었습니다.');
            count =0;
         }
         else{
            alert('이미 생성된 연차는 연차생성을 할 수 없습니다.');
            count =0;
         }
      }
   }
   /* 
    * 목록 검색
    */
   function btn_program_get_list() {
      var form = document.dataForm;
      var storeYear = document.getElementById("ad_select_year").value;
      
      useYear = storeYear;
      console.log(useYear);
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
      padding:0;
      border: 1px solid lightgray;
   }
   #dayoffthead{
        height: 40px;
        font-weight: bold;
      border-top: 2px solid lightgray;
   }
   #dayofftbody{
        border-bottom: 2px solid lightgray;
   }
</style>
</head>

<body>
   <form name="dataForm" id="dataForm" method="post">
      <ap:include page="param/defaultParam.jsp" />
      <ap:include page="param/dispParam.jsp" />
      <ap:include page="param/pagingParam.jsp" />

      <input type="hidden" name="EMP_NO" id="EMP_NO" /> <input type="hidden"
         id="init_search_yn" name="init_search_yn" value="N" />
      <!--//content-->
      <div id="wrap">
         <div class="wrap_inn">
            <div class="contents">
               <!--// 타이틀 영역 -->
               <h2 class="menu_title">연차생성</h2>
               <!-- 타이틀 영역 //-->
               <!--// 검색 조건 -->
               <div class="search_top">
                  <table cellpadding="0" cellspacing="0" class="table_search"
                     summary="프로그램관리 검색">
                     <caption>검색</caption>
                     <colgroup>
                        <col width="15%" />
                        <col width="20%" />
                        <col width="15%" />
                        <col width="20%" />
                        <col width="*" />
                     </colgroup>
                     <tr>
                        <th scope="row">기준연도</th>
                        <td><input name="ad_select_year" id="ad_select_year"
                           title="년도를 입력하세요." placeholder="년도를 입력하세요." type="text"
                           style="width: 200px" value="${dayoffList[0].SELECT_YEAR}" onkeypress="press(event);"/></td>
                        <th scope="row">검색어
                        </th>
                        <td>
                           <select name="ad_search_type" id   ="ad_search_type" onchange="countSess()"/>
                                <option value="EMP_NM" id="EMP_NM" name="EMP_NM">성명</option>
                                <option value="EMP_NO" id="EMP_NO" name="EMP_NO">사원번호</option>
                               <option value="DEPT_CD" id="DEPT_CD" name ="DEPT_CD">부서</option>
                           </select>
                        </td>
                        <td><input name="ad_search_word" id="ad_search_word" type="text" title="검색어를 입력하세요." placeholder="검색어를 입력하세요." style="width: 200px" value="${ad_search_word}" onkeypress="press(event);"/> </td>
                        <td>
                           <p class="btn_src_zone">
                              <a href="#" class="btn_search"
                                 onclick="btn_program_get_list()">조회</a>
                           </p>
                        </td>
                     </tr>
                  </table>
               </div><br><br>
               <div>
               
               <table>
                     <caption>검색</caption>
                     <colgroup>
                        <col width="60%" />
                        <col width="20%" />
                        <col width="10%" />
                        <col width="10%" />
                     </colgroup>
                     <tr>
                        <th style="float:left">연차생성</th>
                        <th><div class="btn_page_last">
                     <a class="btn_page_admin" href="#" onclick="downloadExcel();"><span>엑셀다운로드</span></a>
                  </div></th>
                        <th><div class="btn_page_last">
                           <a class="btn_page_admin" href="#" onclick="clickCreateBtn()"><span>연차 생성</span></a></div></th>
                        <th><div class="btn_page_last"><a class="btn_page_admin" href="#"><span>연차 삭제</span></a></div></th>
                     </tr>
               </table>
               </div>
               <div class="block">
                  <table id="dayofftable" style="border: 1px solid black" cellspacing="0" border="0" summary="연차 생성 리스트" class="table_basic mgt10">
                    <caption>연차 생성</caption>
                        <colgroup>
                           <col width="5%"/>
                           <col width="10%" />
                           <col width="10%" />
                           <col width="10%" />
                           <col width="10%" />
                           <col width="10%" />
                           <col width="10%" />
                           <col width="10%" />
                           <col width="10%" />
                           <col width="10%" />
                           <col width="10%" />
                        </colgroup>
                     <thead id="dayoffthead">
                        <tr>
                           <th id ="dayoff" class="checkbox">✔</th>
                           <th id= "dayoff" >사원번호</th>
                           <th id= "dayoff">성명</th>
                           <th id= "dayoff">부서</th>
                           <th id= "dayoff">입사일</th>
                           <th id= "dayoff">근속연수</th>
                           <th id= "dayoff">연차사용기간</th>
                           <th id= "dayoff">1년미만월발생분</th>
                           <th id= "dayoff">근속연차</th>
                           <th id= "dayoff">연차생성일</th>
                           <th id= "dayoff">초과사용</th>
                        </tr>
                     </thead>
                  <tbody id="dayofftbody">
                    <c:forEach items="${dayoffList}" var="dayoffList" varStatus="status">
                  <tr>
                     <td id= "dayoff" class="checkbox"> <input name ="dayoffCheck" id ="dayoffCheck" type="checkbox"></input></td>
                     <td id= "dayoff" class="emp_no">${dayoffList.EMP_NO}</td> 
                     <td id= "dayoff">${dayoffList.EMP_NM}</td> 
                     <td id= "dayoff" >${dayoffList.DEPT_NM}</td>
                     <td id= "dayoff" class="inco_dt">${dayoffList.INCO_DT}</td>
                     <td id= "dayoff">${dayoffList.WORK_YEAR}</td>
                     <td id= "dayoff">${dayoffList.USE_YEAR}</td>
                     <td id= "dayoff" class=""></td>
                     <td id= "dayoff" class="total_cnt">${dayoffList.TOTAL_CNT}</td>
                     <td id= "dayoff" class="">${dayoffList.INSERT_DATE}</td>
                     <td id= "dayoff">불가능</td>
                  </tr>
               </c:forEach>
                  </tbody>
                  </table>
                  <br> <br>
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