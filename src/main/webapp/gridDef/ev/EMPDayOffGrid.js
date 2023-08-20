''/*
 * 리얼그리드 세부설정과 리얼그리드 관련 함수
*/

//필드 생성
var EMPinfofields = [
   {
      fieldName: "EMP_NO",
      dataType: "text",
   },
   {
      fieldName: "EMP_NM",
      dataType: "text",
   },
   {
      fieldName: "DEPT_CD",
      dataType: "text",
   },
   {
      fieldName: "INCO_DT",
      dataType: "text",
   },
   {
      fieldName: "TOTAL_CNT",
      dataType: "text",
   },
   {
      fieldName: "연차사용기간",
      dataType: "text",
   },
   {
      fieldName: "1년 미만 ",
      dataType: "text",
   },
   {
      fieldName: "TOTAL_CNT",
      dataType: "text",
   },
   {
      fieldName: "연차생성일",
      dataType: "text",
   },
   {
      fieldName: "OVERUSE",
      dataType: "text",
   }
];

//칼럼 생성
var EMPinfocolumns = [
   {
      name: "check_box",
      type: "check_box",
      width:50,
      checkLocation: "bottom",
   },
   {
      name: "EMP_NO",
      fieldName: "EMP_NO",
      type: "data",
      width: "50",
      numberFormat: "0",
      header: {
         text: "사원번호",
      },
   },
   {
      name: "EMP_NM",
      fieldName: "EMP_NM",
      type: "data",
      width: "50",
      header: {
         text: "성명",
      },
   },
   {
      name: "CIZ_NO",
      fieldName: "CIZ_NO",
      type: "data",
      width: "80",
      header: {
         text: "부서",
      },
      textFormat: ""
   },
   {
      name: "CODE_NM",
      fieldName: "CODE_NM",
      type: "data",
      width: "80",
      header: {
         text: "입사일",
      },
   },
   {
       name: "ACCT_NO",
      fieldName: "ACCT_NO",
       type: "data",
      width: "100",
      header: {
         text: "근속년수",
      },
   },
   {
      name: "MOB_TEL",
      fieldName: "MOB_TEL",
      type: "data",
      width: "80",
      textFormat: "([0-9]{3})([0-9]{4})([0-9]{4});$1-$2-$3",
      header: {
         text: "연차사용기간",
      },
   },
   {
      name: "COM_MAIL",
      fieldName: "COM_MAIL",
      type: "data",
      width: "80",
      header: {
         text: "1년미만월발생분",
      },
   },
   {
      name: "TOTAL_CNT",
      fieldName: "TOTAL_CNT",
      type: "data",
      width: "50",
      header: {
         text: "근속연차",
      },
   },
   {
      name: "ADDR",
      fieldName: "ADDR",
      type: "data",
      width: "150",
      header: {
         text: "연차생성일",
      },
   },
   {
      name: "OVERUSE",
      fieldName: "OVERUSE",
      type: "data",
      width: "80",
      header: {
         text: "초과사용",
      },
   }
];

var EMPinfodataProvider, EMPinfogridView;

function EMPinfoCreate(container) {
   EMPinfodataProvider = new RealGrid.LocalDataProvider();
   EMPinfogridView = new RealGrid.GridView(container);
   EMPinfogridView.setDataSource(EMPinfodataProvider);

   EMPinfodataProvider.setFields(EMPinfofields);
   EMPinfogridView.setColumns(EMPinfocolumns);
   
   EMPinfodataProvider.clearRows();

   $.ajax({
      type : "POST",
      url : "PGEV1110.do",
      data : { "df_method_nm" : "countSess" 
         , "ad_select_year" : $("#ad_select_year").val()
         , "ad_select_type" : $("#ad_select_type").val()
         , "ad_select_word" : $("#ad_select_word").val()
         , "limitFrom" : 0 , "limitTo" : 100},
      error : function(error) {
         console.log("error");
      },
      success : function(data) {
         console.log("success");
         var ddd = JSON.parse(data);
         EMPinfodataProvider.fillJsonData(ddd, {fillMode: "set"});
      }
   });
   
   registerCallback();

   EMPinfogridView.displayOptions.emptyMessage = "표시할 데이타가 없습니다.";
   //그리드 너비 자동 조정(비율)
   EMPinfogridView.displayOptions.fitStyle = "evenFill";   
   
   // 체크박스 숨기기 - JS파일 createGrid 안에
   EMPinfogridView.setCheckBar({visible: false});

   // 상태바(No. 옆 빈칸) 숨기기 - JS파일 createGrid 안에
   EMPinfogridView.setStateBar({visible: false});
   
   // 합계 footer 숨기기
   EMPinfogridView.setFooter({visible: false});
   
   // 편집을 불가능하게 하려면 - JS파일 createGrid 안에
   EMPinfogridView.setEditOptions({editable: false});
}

window.addEventListener('DOMContentLoaded', function() {
   EMPinfoCreate("EMPinfogrid");
});